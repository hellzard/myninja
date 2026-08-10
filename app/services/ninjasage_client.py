import httpx
from pyamf import remoting
import pyamf

class NinjaSageClient:
    def __init__(self):
        self.base_url = "https://play.ninjasage.id"
        
    async def send_amf_request(self, target_uri: str, body: list) -> dict:
        """
        Sends an AMF request to the official server and decodes the response.
        """
        # 1. Encode the AMF payload
        # The official APK always wraps the parameters array inside another array (BUILD_LIST 1)
        if body and not isinstance(body[0], list):
            body = [body]
        elif not body:
            body = [[]]
            
        envelope = remoting.Envelope(amfVersion=pyamf.AMF3)
        request_msg = remoting.Request(target=target_uri, body=body)
        envelope["/1"] = request_msg
        
        # 2. Convert to bytes
        encoded_stream = remoting.encode(envelope)
        payload_bytes = encoded_stream.getvalue()
        
        # 3. Send to official server
        headers = {
            "Content-Type": "application/x-amf",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
            "Referer": "http://127.0.0.1:800/NinjaSage.swf",
            "Origin": "https://play.ninjasage.id",
            "Accept": "*/*",
            "Accept-Encoding": "gzip, deflate, br, zstd",
            "Accept-Language": "en-US,en;q=0.9",
            "X-Requested-With": "ShockwaveFlash/32.0.0.465",
            "Connection": "keep-alive"
        }
        
        async with httpx.AsyncClient(verify=False) as client:
            await client.get(f"{self.base_url}/play")
            resp = await client.post(f"{self.base_url}/arnf", content=payload_bytes, headers=headers)
            
        if resp.status_code != 200:
            raise Exception(f"Official server returned status {resp.status_code}")
            
        # 4. Decode response
        try:
            resp_envelope = remoting.decode(resp.content)
            for resp_uri, msg in resp_envelope.bodies:
                if isinstance(msg.body, pyamf.remoting.ErrorFault):
                    return {"status": 0, "error": f"{msg.body.code}: {msg.body.description}"}
                return msg.body
        except Exception as e:
            raise Exception(f"Failed to decode official AMF response: {e}")
            
        return {}

    def generate_nseed(self, char_underscore: float) -> str:
        bytesLoaded = 14252961
        seed = int(char_underscore) % bytesLoaded
        nseed_str = ""
        for _i in range(4):
            seed = (seed * 16807) % 2147483647
            nseed_str += str(seed)
        return nseed_str

    def generate_duar(self, char_underscore: float) -> str:
        import hashlib
        loc4 = "1297"
        hash_loc4 = hashlib.sha256(loc4.encode('utf-8')).hexdigest()
        param3 = str(int(char_underscore))
        return param3 + hash_loc4 + param3 + param3 + param3 + param3

    def encrypt_password(self, password: str, key_str: str, iv_float: float) -> str:
        from Cryptodome.Cipher import AES
        from Cryptodome.Util.Padding import pad
        import base64
        
        key = key_str.encode('utf-8')
        iv_str = str(int(iv_float))
        iv = pad(iv_str.encode('utf-8'), 16)
        
        cipher = AES.new(key, AES.MODE_CBC, iv=iv)
        padded_password = pad(password.encode('utf-8'), 16)
        return base64.b64encode(cipher.encrypt(padded_password)).decode('utf-8')

    def decrypt_password(self, encrypted_password: str, key_str: str, iv_float: float) -> str:
        from Cryptodome.Cipher import AES
        from Cryptodome.Util.Padding import unpad, pad
        import base64
        
        key = key_str.encode('utf-8')
        iv_str = str(int(iv_float))
        iv = pad(iv_str.encode('utf-8'), 16)
        
        cipher = AES.new(key, AES.MODE_CBC, iv=iv)
        encrypted_bytes = base64.b64decode(encrypted_password)
        decrypted_padded = cipher.decrypt(encrypted_bytes)
        return unpad(decrypted_padded, 16).decode('utf-8')

    async def login(self, username: str, password: str) -> dict:
        """
        Performs the complete login flow.
        1. Calls checkVersion to get encryption tokens (_ and __)
        2. Encrypts the password
        3. Sends the loginUser request
        """
        # 1. Get tokens
        version_resp = await self.check_version()
        if not isinstance(version_resp, dict) or '_' not in version_resp or '__' not in version_resp:
            return {"status": "error", "message": "Failed to fetch encryption tokens"}
        
        char_underscore = version_resp['_']
        char_double_underscore = version_resp['__']
        
        # 2. Encrypt password
        try:
            encrypted_password = self.encrypt_password(password, char_double_underscore, char_underscore)
        except Exception as e:
            return {"status": "error", "message": f"Encryption failed: {e}"}
            
        bytes_loaded = 14252961
        duar = self.generate_duar(char_underscore)
        nseed = self.generate_nseed(char_underscore)
            
        # 3. Send Login AMF
        # qgnNJXdbTxOLTF3S.n2znaFWme0q6: [username, encrypted_pass, _, bytes_loaded, bytes_loaded, __, duar, nseed, 10]
        login_body = [
            username,
            encrypted_password,
            char_underscore,
            bytes_loaded,
            bytes_loaded,
            char_double_underscore,
            duar,
            nseed,
            10
        ]
        
        try:
            login_resp = await self.send_amf_request("qgnNJXdbTxOLTF3S.n2znaFWme0q6", [login_body])
        except Exception as e:
            return {"status": "error", "message": f"Login request failed: {e}"}
        
        if isinstance(login_resp, dict) and 'sessionkey' in login_resp and 'uid' in login_resp:
            sessionkey = login_resp['sessionkey']
            account_id = str(login_resp['uid'])  # Charles shows this as String type
            
            # 4. Get All Characters for this account
            # Target: qgnNJXdbTxOLTF3S.bBtq6fiQnFeZ
            # Response format (ASObject):
            # { status: 1, tokens: 0, total_characters: 1,
            #   account_data: [{ char_id: 313196, character_name: 'Pria Solo', 
            #     character_level: 1, character_xp: 0, character_gold: 1000, ... }] }
            char_name = username
            char_level = '--'
            char_xp = '--'
            char_gold = '--'
            char_tokens = '--'
            char_id = 0
            
            try:
                char_list_res = await self.send_amf_request("qgnNJXdbTxOLTF3S.bBtq6fiQnFeZ", [[account_id, sessionkey]])
                
                # Extract tokens from top level
                if hasattr(char_list_res, 'get') or isinstance(char_list_res, dict):
                    char_tokens = char_list_res.get('tokens', '--')
                    
                    # Extract character data from account_data array
                    account_data = char_list_res.get('account_data', [])
                    if account_data and len(account_data) > 0:
                        char = account_data[0]
                        char_id = char.get('char_id', 0)
                        char_name = char.get('character_name', username)
                        char_level = char.get('character_level', '--')
                        char_xp = char.get('character_xp', '--')
                        char_gold = char.get('character_gold', '--')
            except Exception as e:
                print(f"DEBUG Error fetching char data: {e}")
                
            # Fallback to account_id if char_id was not found
            if not char_id:
                char_id = int(account_id)

            return {
                "status": "success",
                "sessionkey": sessionkey,
                "char_id": char_id,
                "char_name": char_name,
                "level": char_level,
                "xp": char_xp,
                "gold": char_gold,
                "tokens": char_tokens
            }
        elif isinstance(login_resp, dict) and 'error' in login_resp:
            return {"status": "error", "message": f"Server Error Code: {login_resp['error']}"}
        else:
            return {"status": "error", "message": "Invalid response from server"}

    async def check_version(self) -> dict:
        """
        Calls SystemLogin.checkVersion (obfuscated)
        """
        target = "qgnNJXdbTxOLTF3S.6zWoiSDdFxW3"
        body = [["Public 0.61"]]
        return await self.send_amf_request(target, body)

    async def login_user(self, username: str, password: str, char_underscore: float, char_double_underscore: str) -> dict:
        """
        Calls SystemLogin.loginUser (obfuscated)
        """
        target = "qgnNJXdbTxOLTF3S.n2znaFWme0q6"
        encrypted_pass = self.encrypt_password(password, char_double_underscore, char_underscore)
        duar = self.generate_duar(char_underscore)
        nseed = self.generate_nseed(char_underscore)
        bytesLoaded = 14252961
        bytesTotal = 14252961
        
        body = [[
            username, 
            encrypted_pass, 
            float(char_underscore), 
            bytesLoaded, 
            bytesTotal, 
            char_double_underscore, 
            duar, 
            nseed, 
            len(password)
        ]]
        return await self.send_amf_request(target, body)
