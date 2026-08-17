import asyncio
import base64
import hashlib
import time
from typing import Optional

import httpx
import pyamf
from Cryptodome.Cipher import AES
from Cryptodome.Util.Padding import pad, unpad
from pyamf import remoting

from app.services.settings_manager import load_settings


class NinjaSageClient:
    """AMF client with an optional persistent HTTP session for long-running cloud jobs."""

    def __init__(self, persistent: bool = False):
        self.base_url = 'https://play.ninjasage.id'
        self.persistent = bool(persistent)
        self._http: Optional[httpx.AsyncClient] = None
        self._request_lock = asyncio.Lock()
        self._last_request_at = 0.0
        self._warmed = False

    def _headers(self) -> dict:
        return {
            'Content-Type': 'application/x-amf',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
            'Referer': 'http://127.0.0.1:800/NinjaSage.swf',
            'Origin': 'https://play.ninjasage.id',
            'Accept': '*/*',
            'Accept-Encoding': 'gzip, deflate, br, zstd',
            'Accept-Language': 'en-US,en;q=0.9',
            'X-Requested-With': 'ShockwaveFlash/32.0.0.465',
            'Connection': 'keep-alive',
        }

    async def _persistent_http(self) -> httpx.AsyncClient:
        if self._http is None:
            self._http = httpx.AsyncClient(verify=False, timeout=30.0)
        return self._http

    async def _pace(self) -> None:
        try:
            minimum = max(0.0, float(load_settings().get('amf_min_request_interval_seconds', 1.25)))
        except (TypeError, ValueError):
            minimum = 1.25
        elapsed = time.monotonic() - self._last_request_at
        if minimum > 0 and elapsed < minimum:
            await asyncio.sleep(minimum - elapsed)

    async def _post_amf(self, payload_bytes: bytes, headers: dict) -> httpx.Response:
        if not self.persistent:
            async with httpx.AsyncClient(verify=False, timeout=30.0) as client:
                await client.get(f'{self.base_url}/play')
                return await client.post(f'{self.base_url}/arnf', content=payload_bytes, headers=headers)

        client = await self._persistent_http()
        if not self._warmed:
            await client.get(f'{self.base_url}/play')
            self._warmed = True
        return await client.post(f'{self.base_url}/arnf', content=payload_bytes, headers=headers)

    async def send_amf_request(self, target_uri: str, body: list) -> dict:
        if body and not isinstance(body[0], list):
            body = [body]
        elif not body:
            body = [[]]

        envelope = remoting.Envelope(amfVersion=pyamf.AMF3)
        envelope['/0'] = remoting.Request(target=target_uri, body=body)
        payload_bytes = remoting.encode(envelope).getvalue()

        # One request at a time per cloud job. This also makes min-call spacing meaningful.
        async with self._request_lock:
            await self._pace()
            try:
                response = await self._post_amf(payload_bytes, self._headers())
            finally:
                self._last_request_at = time.monotonic()

        if response.status_code != 200:
            retry_after = response.headers.get('Retry-After')
            suffix = f' (Retry-After: {retry_after}s)' if retry_after else ''
            raise RuntimeError(f'Official server returned HTTP {response.status_code}{suffix}')

        try:
            decoded = remoting.decode(response.content)
            for _resp_uri, message in decoded.bodies:
                if isinstance(message.body, pyamf.remoting.ErrorFault):
                    return {'status': 0, 'error': f'{message.body.code}: {message.body.description}'}
                return message.body
        except Exception as exc:
            raise RuntimeError(f'Failed to decode official AMF response: {exc}') from exc
        return {}

    async def aclose(self) -> None:
        if self._http is not None:
            await self._http.aclose()
            self._http = None
            self._warmed = False

    async def validate_session(self, sessionkey: str, char_id: int) -> bool:
        try:
            result = await self.send_amf_request('SystemLogin.getCharacterData', [char_id, sessionkey])
        except Exception:
            return False
        return isinstance(result, dict) and result.get('status') == 1

    def generate_nseed(self, char_underscore: float) -> str:
        bytes_loaded = 14252961
        seed = int(char_underscore) % bytes_loaded
        nseed = ''
        for _ in range(4):
            seed = (seed * 16807) % 2147483647
            nseed += str(seed)
        return nseed

    def generate_duar(self, char_underscore: float) -> str:
        value = '1297'
        digest = hashlib.sha256(value.encode('utf-8')).hexdigest()
        param = str(int(char_underscore))
        return param + digest + param + param + param + param

    def encrypt_password(self, password: str, key_str: str, iv_float: float) -> str:
        key = key_str.encode('utf-8')
        iv = pad(str(int(iv_float)).encode('utf-8'), 16)
        cipher = AES.new(key, AES.MODE_CBC, iv=iv)
        return base64.b64encode(cipher.encrypt(pad(password.encode('utf-8'), 16))).decode('utf-8')

    def decrypt_password(self, encrypted_password: str, key_str: str, iv_float: float) -> str:
        key = key_str.encode('utf-8')
        iv = pad(str(int(iv_float)).encode('utf-8'), 16)
        cipher = AES.new(key, AES.MODE_CBC, iv=iv)
        return unpad(cipher.decrypt(base64.b64decode(encrypted_password)), 16).decode('utf-8')

    async def login(self, username: str, password: str) -> dict:
        version = await self.check_version()
        if not isinstance(version, dict) or '_' not in version or '__' not in version:
            return {'status': 'error', 'message': 'Failed to fetch encryption tokens'}

        underscore = version['_']
        double_underscore = version['__']
        try:
            encrypted = self.encrypt_password(password, double_underscore, underscore)
        except Exception as exc:
            return {'status': 'error', 'message': f'Encryption failed: {exc}'}

        bytes_loaded = 14252961
        login_body = [
            username,
            encrypted,
            underscore,
            bytes_loaded,
            bytes_loaded,
            double_underscore,
            self.generate_duar(underscore),
            self.generate_nseed(underscore),
            10,
        ]
        try:
            login_response = await self.send_amf_request('qgnNJXdbTxOLTF3S.n2znaFWme0q6', [login_body])
        except Exception as exc:
            return {'status': 'error', 'message': f'Login request failed: {exc}'}

        if not (isinstance(login_response, dict) and 'sessionkey' in login_response and 'uid' in login_response):
            if isinstance(login_response, dict) and 'error' in login_response:
                return {'status': 'error', 'message': f"Server Error Code: {login_response['error']}"}
            return {'status': 'error', 'message': 'Invalid response from server'}

        sessionkey = login_response['sessionkey']
        account_id = str(login_response['uid'])
        char_name = username
        char_level = '--'
        char_xp = '--'
        char_gold = '--'
        char_tokens = '--'
        char_id = 0

        try:
            chars = await self.send_amf_request('qgnNJXdbTxOLTF3S.bBtq6fiQnFeZ', [[account_id, sessionkey]])
            if isinstance(chars, dict):
                char_tokens = chars.get('tokens', '--')
                account_data = chars.get('account_data', [])
                if account_data and isinstance(account_data[0], dict):
                    char = account_data[0]
                    char_id = char.get('char_id', 0)
                    char_name = char.get('character_name', username)
                    char_level = char.get('character_level', '--')
                    char_xp = char.get('character_xp', '--')
                    char_gold = char.get('character_gold', '--')
        except Exception:
            pass

        if not char_id:
            char_id = int(account_id)
        return {
            'status': 'success',
            'sessionkey': sessionkey,
            'char_id': char_id,
            'char_name': char_name,
            'level': char_level,
            'xp': char_xp,
            'gold': char_gold,
            'tokens': char_tokens,
        }

    async def check_version(self) -> dict:
        return await self.send_amf_request('qgnNJXdbTxOLTF3S.6zWoiSDdFxW3', [['Public 0.61']])

    async def login_user(self, username: str, password: str, char_underscore: float, char_double_underscore: str) -> dict:
        encrypted = self.encrypt_password(password, char_double_underscore, char_underscore)
        bytes_loaded = 14252961
        body = [[
            username,
            encrypted,
            float(char_underscore),
            bytes_loaded,
            bytes_loaded,
            char_double_underscore,
            self.generate_duar(char_underscore),
            self.generate_nseed(char_underscore),
            len(password),
        ]]
        return await self.send_amf_request('qgnNJXdbTxOLTF3S.n2znaFWme0q6', body)
