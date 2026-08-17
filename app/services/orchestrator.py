from __future__ import annotations

import asyncio
import os
import time
from typing import Any, Dict

GLOBAL_SPACING = max(0.0, float(os.getenv("GLOBAL_ACTION_SPACING_SECONDS", "1.25") or 1.25))
_lock = asyncio.Lock()
_last_action_at = 0.0
_total_waits = 0
_total_wait_seconds = 0.0
_last_char_id = None


async def wait_turn(char_id: int) -> float:
    global _last_action_at, _total_waits, _total_wait_seconds, _last_char_id
    async with _lock:
        now = time.monotonic()
        wait = max(0.0, _last_action_at + GLOBAL_SPACING - now)
        if wait > 0:
            _total_waits += 1
            _total_wait_seconds += wait
            await asyncio.sleep(wait)
        _last_action_at = time.monotonic()
        _last_char_id = int(char_id)
        return wait


def metrics() -> Dict[str, Any]:
    return {
        "global_spacing_seconds": GLOBAL_SPACING,
        "total_waits": _total_waits,
        "total_wait_seconds": round(_total_wait_seconds, 3),
        "last_char_id": _last_char_id,
    }
