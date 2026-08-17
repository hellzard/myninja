from __future__ import annotations

import base64
import hashlib
import json
import os
import secrets
import time
from typing import Any, Dict, List, Optional

from Cryptodome.Cipher import AES

try:
    import redis.asyncio as redis
except Exception:  # redis is optional in local/in-process mode
    redis = None


REDIS_URL = os.getenv("REDIS_URL", "").strip()
ENGINE_MODE = os.getenv("BOT_ENGINE_MODE", "web").strip().lower()
STATE_SECRET = os.getenv("BOT_STATE_SECRET", "").strip()
PREFIX = os.getenv("BOT_STATE_PREFIX", "myninja:v4").strip() or "myninja:v4"

_client = None


def redis_configured() -> bool:
    return bool(REDIS_URL)


def queue_mode() -> bool:
    return ENGINE_MODE == "worker" and redis_configured()


def persistence_mode() -> str:
    if queue_mode():
        return "worker"
    if redis_configured():
        return "shared-state"
    return "memory"


def _control_hash(token: str) -> str:
    return hashlib.sha256(str(token).encode("utf-8")).hexdigest()


def _secret_key() -> bytes:
    if not STATE_SECRET:
        raise RuntimeError(
            "BOT_STATE_SECRET is required before cloud job payloads can be persisted or queued."
        )
    return hashlib.sha256(STATE_SECRET.encode("utf-8")).digest()


def _seal(payload: Dict[str, Any]) -> str:
    raw = json.dumps(payload, separators=(",", ":"), ensure_ascii=False).encode("utf-8")
    cipher = AES.new(_secret_key(), AES.MODE_GCM)
    ciphertext, tag = cipher.encrypt_and_digest(raw)
    blob = cipher.nonce + tag + ciphertext
    return base64.urlsafe_b64encode(blob).decode("ascii")


def _open(blob: str) -> Dict[str, Any]:
    packed = base64.urlsafe_b64decode(blob.encode("ascii"))
    nonce, tag, ciphertext = packed[:16], packed[16:32], packed[32:]
    cipher = AES.new(_secret_key(), AES.MODE_GCM, nonce=nonce)
    raw = cipher.decrypt_and_verify(ciphertext, tag)
    value = json.loads(raw.decode("utf-8"))
    if not isinstance(value, dict):
        raise ValueError("Encrypted cloud payload is not an object.")
    return value


async def _redis():
    global _client
    if not REDIS_URL or redis is None:
        return None
    if _client is None:
        _client = redis.from_url(
            REDIS_URL,
            encoding="utf-8",
            decode_responses=True,
            health_check_interval=30,
            socket_connect_timeout=8,
            socket_timeout=15,
        )
    return _client


def _status_key(char_id: int) -> str:
    return f"{PREFIX}:status:{int(char_id)}"


def _spec_key(char_id: int) -> str:
    return f"{PREFIX}:spec:{int(char_id)}"


def _stop_key(char_id: int) -> str:
    return f"{PREFIX}:stop:{int(char_id)}"


QUEUE_KEY = f"{PREFIX}:queue:start"


async def ping() -> bool:
    client = await _redis()
    if client is None:
        return False
    try:
        return bool(await client.ping())
    except Exception:
        return False


async def save_status(
    char_id: int,
    status: Dict[str, Any],
    control_token: str,
    retention_seconds: int = 86400,
) -> bool:
    client = await _redis()
    if client is None:
        return False
    payload = dict(status)
    payload["_control_hash"] = _control_hash(control_token)
    payload["_stored_at"] = time.time()

    # Worker mode always has BOT_STATE_SECRET and stores the entire authorized
    # status encrypted, including a recovered session update. Shared-state mode
    # without a secret stores only non-sensitive public status.
    if STATE_SECRET:
        encoded = "enc:" + _seal(payload)
    else:
        update = payload.get("session_update")
        if isinstance(update, dict) and "sessionkey" in update:
            update = dict(update)
            update.pop("sessionkey", None)
            payload["session_update"] = update
        encoded = json.dumps(payload, separators=(",", ":"), ensure_ascii=False)

    try:
        await client.set(
            _status_key(char_id),
            encoded,
            ex=max(3600, int(retention_seconds)),
        )
        return True
    except Exception:
        return False


async def authorized_status(char_id: int, control_token: str) -> Optional[Dict[str, Any]]:
    client = await _redis()
    if client is None:
        return None
    raw = await client.get(_status_key(char_id))
    if not raw:
        return None
    if raw.startswith("enc:"):
        data = _open(raw[4:])
    else:
        data = json.loads(raw)
    expected = str(data.pop("_control_hash", ""))
    data.pop("_stored_at", None)
    if not control_token or not secrets.compare_digest(expected, _control_hash(control_token)):
        raise PermissionError("Invalid control token")
    return data


async def save_spec(
    char_id: int,
    spec: Dict[str, Any],
    control_token: str,
    *,
    active: bool = True,
) -> bool:
    client = await _redis()
    if client is None:
        return False
    payload = dict(spec)
    payload["control_token"] = control_token
    payload["active"] = bool(active)
    payload["stored_at"] = time.time()
    try:
        await client.set(_spec_key(char_id), _seal(payload))
        return True
    except Exception:
        return False


async def load_spec(char_id: int) -> Optional[Dict[str, Any]]:
    client = await _redis()
    if client is None:
        return None
    raw = await client.get(_spec_key(char_id))
    if not raw:
        return None
    try:
        return _open(raw)
    except Exception:
        return None


async def mark_spec_inactive(char_id: int) -> None:
    spec = await load_spec(char_id)
    if not spec:
        return
    token = str(spec.get("control_token") or "")
    if not token:
        return
    spec.pop("control_token", None)
    await save_spec(char_id, spec, token, active=False)


async def list_active_specs(*, include_queued: bool = False) -> List[Dict[str, Any]]:
    client = await _redis()
    if client is None:
        return []
    specs: List[Dict[str, Any]] = []
    async for key in client.scan_iter(match=f"{PREFIX}:spec:*", count=100):
        raw = await client.get(key)
        if not raw:
            continue
        try:
            spec = _open(raw)
        except Exception:
            continue
        if not spec.get("active"):
            continue
        if not include_queued:
            char_id = int(spec.get("char_id") or 0)
            if char_id:
                status_raw = await client.get(_status_key(char_id))
                if status_raw:
                    try:
                        status_obj = _open(status_raw[4:]) if status_raw.startswith("enc:") else json.loads(status_raw)
                        state = status_obj.get("health", {}).get("state")
                        if state == "QUEUED":
                            continue
                    except Exception:
                        pass
        specs.append(spec)
    return specs


async def request_stop(char_id: int, ttl: int = 3600) -> bool:
    client = await _redis()
    if client is None:
        return False
    await client.set(_stop_key(char_id), "1", ex=max(60, int(ttl)))
    return True


async def clear_stop(char_id: int) -> None:
    client = await _redis()
    if client is not None:
        await client.delete(_stop_key(char_id))


async def stop_requested(char_id: int) -> bool:
    client = await _redis()
    if client is None:
        return False
    try:
        return bool(await client.exists(_stop_key(char_id)))
    except Exception:
        return False


async def enqueue_start(spec: Dict[str, Any], control_token: str) -> Dict[str, Any]:
    if not queue_mode():
        raise RuntimeError("BOT_ENGINE_MODE=worker and REDIS_URL are required for queue mode.")
    if not STATE_SECRET:
        raise RuntimeError("BOT_STATE_SECRET is required for queue mode.")
    client = await _redis()
    if client is None:
        raise RuntimeError("Redis/Valkey client is unavailable.")

    payload = dict(spec)
    payload["control_token"] = control_token
    payload["active"] = True
    await save_spec(int(spec["char_id"]), spec, control_token, active=True)

    queued = {
        "running": True,
        "bot_type": spec["bot_type"],
        "char_id": int(spec["char_id"]),
        "params": {
            k: v for k, v in dict(spec.get("params") or {}).items()
            if k in {"mission_id", "boss_type", "max_level", "schedule_at", "repeat_every_seconds"}
        },
        "iteration": 0,
        "consecutive_failures": 0,
        "last_message": "Queued for background worker.",
        "created_at": time.time(),
        "finished_at": None,
        "health": {
            "state": "QUEUED",
            "detail": "Waiting for background worker",
            "next_action_at": None,
            "delay_seconds": 0,
        },
        "analytics": {
            "success_count": 0,
            "failure_count": 0,
            "rate_limit_count": 0,
            "relogin_count": 0,
            "earned_xp": 0,
            "earned_gold": 0,
            "earned_token": 0,
            "uptime_seconds": 0,
            "actions_per_hour": 0,
            "xp_per_hour": 0,
            "gold_per_hour": 0,
            "success_rate": 0,
        },
        "logs": [],
    }
    await save_status(int(spec["char_id"]), queued, control_token)
    await client.lpush(QUEUE_KEY, _seal(payload))
    result = dict(queued)
    result["control_token"] = control_token
    return result


async def dequeue_start(timeout_seconds: int = 2) -> Optional[Dict[str, Any]]:
    client = await _redis()
    if client is None:
        return None
    item = await client.brpop(QUEUE_KEY, timeout=max(1, int(timeout_seconds)))
    if not item:
        return None
    _, blob = item
    return _open(blob)


async def engine_info() -> Dict[str, Any]:
    return {
        "mode": persistence_mode(),
        "engine_mode_env": ENGINE_MODE,
        "redis_configured": redis_configured(),
        "redis_reachable": await ping() if redis_configured() else False,
        "encrypted_state_ready": bool(STATE_SECRET),
        "worker_queue_enabled": queue_mode(),
    }


async def close() -> None:
    global _client
    if _client is not None:
        try:
            await _client.aclose()
        finally:
            _client = None
