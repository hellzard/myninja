import asyncio
import random
import string
import time
from typing import Any, Optional

import httpx


class ClanRateLimited(RuntimeError):
    def __init__(self, seconds: int, message: str = 'Clan API rate limited'):
        super().__init__(message)
        self.seconds = max(1, int(seconds))


class CloudClanWarSession:
    """Persistent, rate-aware Clan War REST client for one cloud job."""

    def __init__(self, sessionkey: str, char_id: int, settings: dict):
        self.base_url = 'https://clan.ninjasage.id'
        self.sessionkey = sessionkey
        self.char_id = char_id
        self.settings = settings
        self.http = httpx.AsyncClient(
            timeout=httpx.Timeout(25.0, connect=15.0),
            limits=httpx.Limits(max_connections=4, max_keepalive_connections=2, keepalive_expiry=30.0),
        )
        self.token: Optional[str] = None
        self.last_stamina: Optional[int] = None
        self.last_stamina_at = 0.0
        self.last_opponents: list[dict[str, Any]] = []
        self.last_opponents_at = 0.0

    async def close(self) -> None:
        await self.http.aclose()

    def update_session(self, sessionkey: str) -> None:
        self.sessionkey = sessionkey
        self.token = None

    @staticmethod
    def _retry_after(response: httpx.Response, default: int = 60) -> int:
        raw = response.headers.get('Retry-After')
        try:
            return max(default, int(float(raw)))
        except (TypeError, ValueError):
            return default

    async def _post(self, path: str, payload: Optional[dict] = None, retry_auth: bool = True) -> Any:
        headers = {'Authorization': f'Bearer {self.token}'} if self.token else {}
        response = await self.http.post(f'{self.base_url}{path}', json=payload or {}, headers=headers)
        if response.status_code == 429:
            raise ClanRateLimited(self._retry_after(response))
        if response.status_code in (401, 403) and retry_auth:
            self.token = None
            if await self.authenticate():
                return await self._post(path, payload, retry_auth=False)
        response.raise_for_status()
        return response.json() if response.content else {}

    async def authenticate(self) -> bool:
        response = await self.http.post(
            f'{self.base_url}/auth/login',
            json={'char_id': self.char_id, 'session_key': self.sessionkey},
        )
        if response.status_code == 429:
            raise ClanRateLimited(self._retry_after(response))
        if response.status_code != 200:
            return False
        data = response.json() if response.content else {}
        self.token = data.get('token') or data.get('access_token')
        return bool(self.token)

    async def get_stamina(self, force: bool = False) -> Optional[int]:
        now = time.monotonic()
        if not force and self.last_stamina is not None and now - self.last_stamina_at < 10:
            return self.last_stamina
        data = await self._post('/player/stamina')
        char = data.get('char', {}) if isinstance(data, dict) else {}
        try:
            self.last_stamina = int(char.get('stamina', 0))
        except (TypeError, ValueError):
            self.last_stamina = 0
        self.last_stamina_at = time.monotonic()
        return self.last_stamina

    async def refill_stamina(self) -> bool:
        data = await self._post('/player/stamina/refill')
        if not isinstance(data, dict):
            return False
        char = data.get('char', {}) if isinstance(data.get('char'), dict) else {}
        try:
            self.last_stamina = int(char.get('stamina', self.last_stamina or 0))
            self.last_stamina_at = time.monotonic()
        except (TypeError, ValueError):
            pass
        return data.get('status') in ('ok', 1, '1', True) or (self.last_stamina or 0) >= 10

    async def get_opponents(self, force: bool = False) -> list[dict[str, Any]]:
        refresh_seconds = max(10, int(self.settings.get('clan_war_refresh_delay_seconds', 30) or 30))
        now = time.monotonic()
        if not force and self.last_opponents and now - self.last_opponents_at < refresh_seconds:
            return self.last_opponents
        data = await self._post('/battle/opponents')
        clans = data.get('clans', []) if isinstance(data, dict) else []
        self.last_opponents = [item for item in clans if isinstance(item, dict)]
        self.last_opponents_at = time.monotonic()
        return self.last_opponents

    async def step(self) -> tuple[str, float]:
        if not self.token and not await self.authenticate():
            return 'Clan War authentication failed.', 30.0

        stamina = await self.get_stamina()
        if stamina is None:
            return 'Clan War stamina unavailable; retrying later.', 30.0

        if stamina < 10:
            auto_spend = bool(self.settings.get('clan_war_auto_spend_token', False))
            if not auto_spend:
                return f'Clan War stamina is {stamina}. Auto-spend is disabled; waiting 30 minutes.', 1800.0
            await asyncio.sleep(max(1, int(self.settings.get('clan_war_buy_stamina_delay_seconds', 3) or 3)))
            if not await self.refill_stamina():
                return 'Clan War stamina refill failed; waiting 30 minutes.', 1800.0

        opponents = await self.get_opponents()
        if not opponents:
            return 'No Clan War opponents available; waiting 30 seconds.', 30.0

        opponent = opponents[0]
        opponent_id = opponent.get('id') or opponent.get('clan_id')
        opponent_name = opponent.get('name') or opponent.get('clan_name') or str(opponent_id)
        if not opponent_id:
            self.last_opponents = []
            return 'Clan War opponent payload is incomplete; refreshing later.', 30.0

        code = ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(24))
        data = await self._post(f'/battle/quick/{opponent_id}', {'code': code})
        self.last_stamina = max(0, int(self.last_stamina or 10) - 10)
        message = f'Clan War vs {opponent_name} completed: {data}'
        delay = max(8, int(self.settings.get('clan_war_battle_delay_seconds', 8) or 8))
        return message, float(delay)
