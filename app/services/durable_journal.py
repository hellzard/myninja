from __future__ import annotations

import base64
import hashlib
import json
import os
import secrets
import time
from typing import Any, Dict, Iterable, List, Optional

from Cryptodome.Cipher import AES

try:
    from psycopg_pool import AsyncConnectionPool
except Exception:  # optional until configured
    AsyncConnectionPool = None


DATABASE_URL = os.getenv("JOURNAL_DATABASE_URL", "").strip()
JOURNAL_SECRET = os.getenv("JOURNAL_SECRET", os.getenv("BOT_STATE_SECRET", "")).strip()
AUTO_RECOVER = os.getenv("JOURNAL_AUTO_RECOVER", "1").strip() == "1"
POOL_MIN = max(1, int(os.getenv("JOURNAL_POOL_MIN", "1") or 1))
POOL_MAX = max(2, int(os.getenv("JOURNAL_POOL_MAX", "4") or 4))
SCHEMA_VERSION = 1

_pool: Optional[AsyncConnectionPool] = None
_last_snapshot: Dict[str, float] = {}

DDL = """
CREATE TABLE IF NOT EXISTS myninja_schema_meta (
    key text PRIMARY KEY,
    value text NOT NULL,
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS myninja_job_journal (
    id bigserial PRIMARY KEY,
    job_id text NOT NULL,
    char_id bigint NOT NULL,
    event_seq bigint NOT NULL,
    event_type text NOT NULL,
    level text NOT NULL DEFAULT 'info',
    payload jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(job_id, event_seq)
);
CREATE INDEX IF NOT EXISTS idx_myninja_job_journal_char_created
ON myninja_job_journal(char_id, created_at DESC);

CREATE TABLE IF NOT EXISTS myninja_job_snapshots (
    job_id text PRIMARY KEY,
    char_id bigint NOT NULL,
    active boolean NOT NULL DEFAULT true,
    inflight boolean NOT NULL DEFAULT false,
    recovery_required boolean NOT NULL DEFAULT false,
    public_state jsonb NOT NULL DEFAULT '{}'::jsonb,
    spec_ciphertext text,
    updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_myninja_job_snapshots_active
ON myninja_job_snapshots(active, updated_at DESC);

CREATE TABLE IF NOT EXISTS myninja_passkeys (
    credential_id text PRIMARY KEY,
    credential_public_key text NOT NULL,
    sign_count bigint NOT NULL DEFAULT 0,
    transports jsonb NOT NULL DEFAULT '[]'::jsonb,
    device_type text,
    backed_up boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS myninja_security_audit (
    id bigserial PRIMARY KEY,
    event_type text NOT NULL,
    detail jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);
"""


def configured() -> bool:
    return bool(DATABASE_URL and AsyncConnectionPool is not None)


def encrypted_recovery_ready() -> bool:
    return configured() and bool(JOURNAL_SECRET)


def _key() -> bytes:
    if not JOURNAL_SECRET:
        raise RuntimeError("JOURNAL_SECRET (or BOT_STATE_SECRET) is required for durable job recovery.")
    return hashlib.sha256(JOURNAL_SECRET.encode("utf-8")).digest()


def _seal(value: Dict[str, Any]) -> str:
    raw = json.dumps(value, separators=(",", ":"), ensure_ascii=False).encode("utf-8")
    cipher = AES.new(_key(), AES.MODE_GCM)
    ciphertext, tag = cipher.encrypt_and_digest(raw)
    return base64.urlsafe_b64encode(cipher.nonce + tag + ciphertext).decode("ascii")


def _open(blob: str) -> Dict[str, Any]:
    packed = base64.urlsafe_b64decode(blob.encode("ascii"))
    nonce, tag, ciphertext = packed[:16], packed[16:32], packed[32:]
    cipher = AES.new(_key(), AES.MODE_GCM, nonce=nonce)
    raw = cipher.decrypt_and_verify(ciphertext, tag)
    value = json.loads(raw.decode("utf-8"))
    if not isinstance(value, dict):
        raise ValueError("sealed durable payload is not an object")
    return value


async def _get_pool() -> Optional[AsyncConnectionPool]:
    global _pool
    if not configured():
        return None
    if _pool is None:
        _pool = AsyncConnectionPool(
            conninfo=DATABASE_URL,
            min_size=POOL_MIN,
            max_size=POOL_MAX,
            open=False,
            kwargs={"autocommit": True},
        )
        await _pool.open()
    return _pool


async def initialize() -> bool:
    pool = await _get_pool()
    if pool is None:
        return False
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(DDL)
            await cur.execute(
                """
                INSERT INTO myninja_schema_meta(key, value)
                VALUES ('schema_version', %s)
                ON CONFLICT(key) DO UPDATE
                SET value=excluded.value, updated_at=now()
                """,
                (str(SCHEMA_VERSION),),
            )
    return True


async def ping() -> bool:
    pool = await _get_pool()
    if pool is None:
        return False
    try:
        async with pool.connection() as conn:
            async with conn.cursor() as cur:
                await cur.execute("SELECT 1")
                row = await cur.fetchone()
        return bool(row and row[0] == 1)
    except Exception:
        return False


def _json_safe(value: Any, depth: int = 0) -> Any:
    if depth > 5:
        return None
    if value is None or isinstance(value, (str, int, float, bool)):
        return value
    if isinstance(value, dict):
        result = {}
        for k, v in value.items():
            if str(k) in {"clan", "http", "client"}:
                continue
            safe = _json_safe(v, depth + 1)
            if safe is not None:
                result[str(k)] = safe
        return result
    if isinstance(value, (list, tuple)):
        return [_json_safe(v, depth + 1) for v in value]
    return None


def _resume_state(job: Any) -> Dict[str, Any]:
    return {
        "iteration": int(getattr(job, "iteration", 0) or 0),
        "action_count": int(getattr(job, "action_count", 0) or 0),
        "success_count": int(getattr(job, "success_count", 0) or 0),
        "failure_count": int(getattr(job, "failure_count", 0) or 0),
        "rate_limit_count": int(getattr(job, "rate_limit_count", 0) or 0),
        "relogin_count": int(getattr(job, "relogin_count", 0) or 0),
        "earned_xp": int(getattr(job, "earned_xp", 0) or 0),
        "earned_gold": int(getattr(job, "earned_gold", 0) or 0),
        "earned_token": int(getattr(job, "earned_token", 0) or 0),
        "current_zone": int(getattr(job, "current_zone", 1) or 1),
        "runtime": _json_safe(getattr(job, "runtime", {}) or {}),
        "session_generation": int(getattr(job, "session_generation", 0) or 0),
        "created_at": float(getattr(job, "created_at", time.time()) or time.time()),
        "first_action_at": getattr(job, "first_action_at", None),
        "last_action_at": getattr(job, "last_action_at", None),
    }


async def _append(
    job_id: str,
    char_id: int,
    seq: int,
    event_type: str,
    payload: Optional[Dict[str, Any]] = None,
    level: str = "info",
) -> None:
    pool = await _get_pool()
    if pool is None:
        return
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                INSERT INTO myninja_job_journal(job_id,char_id,event_seq,event_type,level,payload)
                VALUES (%s,%s,%s,%s,%s,%s::jsonb)
                ON CONFLICT(job_id,event_seq) DO NOTHING
                """,
                (
                    str(job_id), int(char_id), int(seq), str(event_type)[:80],
                    str(level)[:16], json.dumps(payload or {}, ensure_ascii=False),
                ),
            )


async def record_event(job: Any, event: Dict[str, Any]) -> None:
    if not configured():
        return
    await _append(
        str(job.job_id),
        int(job.char_id),
        int(event.get("seq") or 0),
        str(event.get("type") or "EVENT"),
        dict(event.get("data") or {}),
        str(event.get("level") or "info"),
    )


async def save_snapshot(job: Any, *, inflight: Optional[bool] = None, force: bool = False) -> None:
    if not configured():
        return

    now = time.time()
    job_id = str(job.job_id)
    if not force and now - _last_snapshot.get(job_id, 0.0) < 3.0:
        return
    _last_snapshot[job_id] = now

    public_state = _resume_state(job)
    spec_ciphertext = None
    if JOURNAL_SECRET:
        spec_ciphertext = _seal({
            "sessionkey": str(job.sessionkey),
            "char_id": int(job.char_id),
            "bot_type": str(job.bot_type),
            "params": _json_safe(job.params or {}),
            "credentials": _json_safe(job.credentials or {}),
            "control_token": str(job.control_token),
            "resume_state": public_state,
        })

    pool = await _get_pool()
    assert pool is not None
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            if inflight is None:
                await cur.execute(
                    """
                    INSERT INTO myninja_job_snapshots(
                        job_id,char_id,active,public_state,spec_ciphertext
                    )
                    VALUES (%s,%s,%s,%s::jsonb,%s)
                    ON CONFLICT(job_id) DO UPDATE SET
                        char_id=excluded.char_id,
                        active=excluded.active,
                        public_state=excluded.public_state,
                        spec_ciphertext=COALESCE(excluded.spec_ciphertext,myninja_job_snapshots.spec_ciphertext),
                        updated_at=now()
                    """,
                    (
                        job_id, int(job.char_id), bool(job.running),
                        json.dumps(public_state, ensure_ascii=False), spec_ciphertext,
                    ),
                )
            else:
                await cur.execute(
                    """
                    INSERT INTO myninja_job_snapshots(
                        job_id,char_id,active,inflight,public_state,spec_ciphertext
                    )
                    VALUES (%s,%s,%s,%s,%s::jsonb,%s)
                    ON CONFLICT(job_id) DO UPDATE SET
                        char_id=excluded.char_id,
                        active=excluded.active,
                        inflight=excluded.inflight,
                        recovery_required=CASE WHEN excluded.inflight THEN false ELSE myninja_job_snapshots.recovery_required END,
                        public_state=excluded.public_state,
                        spec_ciphertext=COALESCE(excluded.spec_ciphertext,myninja_job_snapshots.spec_ciphertext),
                        updated_at=now()
                    """,
                    (
                        job_id, int(job.char_id), bool(job.running), bool(inflight),
                        json.dumps(public_state, ensure_ascii=False), spec_ciphertext,
                    ),
                )


async def job_started(job: Any) -> None:
    if not configured():
        return
    await save_snapshot(job, inflight=False, force=True)
    await _append(job.job_id, job.char_id, 10_000_000_000, "DURABLE_JOB_STARTED", {
        "bot_type": job.bot_type,
    })


async def action_started(job: Any) -> str:
    marker = secrets.token_hex(8)
    if not configured():
        return marker
    await save_snapshot(job, inflight=True, force=True)
    await _append(job.job_id, job.char_id, 20_000_000_000 + int(job.iteration), "ACTION_INFLIGHT", {
        "marker": marker,
        "iteration": int(job.iteration),
        "bot_type": str(job.bot_type),
    }, "warn")
    return marker


async def action_finished(job: Any, marker: str, *, success: bool, message: str) -> None:
    if not configured():
        return
    await save_snapshot(job, inflight=False, force=True)
    await _append(job.job_id, job.char_id, 30_000_000_000 + int(job.iteration), "ACTION_CONFIRMED", {
        "marker": marker,
        "iteration": int(job.iteration),
        "success": bool(success),
        "message": str(message)[:300],
    }, "info" if success else "warn")


async def action_uncertain(job: Any, marker: str, message: str) -> None:
    if not configured():
        return
    await save_snapshot(job, inflight=True, force=True)
    await _append(job.job_id, job.char_id, 40_000_000_000 + int(job.iteration), "ACTION_UNCERTAIN", {
        "marker": marker,
        "message": str(message)[:300],
    }, "error")


async def job_finished(job: Any) -> None:
    if not configured():
        return
    await save_snapshot(job, inflight=False, force=True)
    pool = await _get_pool()
    assert pool is not None
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                UPDATE myninja_job_snapshots
                SET active=false,inflight=false,recovery_required=false,updated_at=now()
                WHERE job_id=%s
                """,
                (str(job.job_id),),
            )


async def list_recovery_candidates() -> List[Dict[str, Any]]:
    pool = await _get_pool()
    if pool is None:
        return []
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT job_id,char_id,active,inflight,recovery_required,public_state,updated_at
                FROM myninja_job_snapshots
                WHERE active=true OR recovery_required=true
                ORDER BY updated_at DESC
                LIMIT 50
                """
            )
            rows = await cur.fetchall()
    return [{
        "job_id": row[0],
        "char_id": int(row[1]),
        "active": bool(row[2]),
        "inflight": bool(row[3]),
        "recovery_required": bool(row[4]),
        "public_state": row[5] or {},
        "updated_at": row[6].isoformat() if row[6] else None,
    } for row in rows]


async def _load_spec(job_id: str) -> Optional[Dict[str, Any]]:
    if not encrypted_recovery_ready():
        return None
    pool = await _get_pool()
    assert pool is not None
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                "SELECT spec_ciphertext FROM myninja_job_snapshots WHERE job_id=%s",
                (str(job_id),),
            )
            row = await cur.fetchone()
    if not row or not row[0]:
        return None
    try:
        return _open(str(row[0]))
    except Exception:
        return None


async def recover_jobs() -> Dict[str, int]:
    result = {"recovered": 0, "needs_confirmation": 0}
    if not (AUTO_RECOVER and encrypted_recovery_ready()):
        return result

    # Redis/worker recovery already owns the durable execution path when configured.
    try:
        from app.services import cloud_store
        if cloud_store.redis_configured():
            return result
    except Exception:
        pass

    pool = await _get_pool()
    assert pool is not None
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT job_id,char_id,inflight,spec_ciphertext
                FROM myninja_job_snapshots
                WHERE active=true
                ORDER BY updated_at ASC
                """
            )
            rows = await cur.fetchall()

    from app.services.cloud_bot_runner import start_job

    for job_id, char_id, inflight, blob in rows:
        if inflight:
            result["needs_confirmation"] += 1
            async with pool.connection() as conn:
                async with conn.cursor() as cur:
                    await cur.execute(
                        """
                        UPDATE myninja_job_snapshots
                        SET recovery_required=true,active=false,updated_at=now()
                        WHERE job_id=%s
                        """,
                        (job_id,),
                    )
            continue
        if not blob:
            continue
        try:
            spec = _open(str(blob))
            await start_job(
                spec["sessionkey"],
                int(spec["char_id"]),
                spec["bot_type"],
                spec.get("params"),
                spec.get("credentials"),
                control_token=spec["control_token"],
                replace_existing=False,
                resume_state=spec.get("resume_state"),
                recovered_job_id=str(job_id),
            )
            result["recovered"] += 1
        except Exception:
            continue
    return result


async def resume_candidate(job_id: str, char_id: int, control_token: str) -> bool:
    spec = await _load_spec(job_id)
    if not spec:
        return False
    if int(spec.get("char_id") or 0) != int(char_id):
        return False
    if not secrets.compare_digest(str(spec.get("control_token") or ""), str(control_token or "")):
        raise PermissionError("Invalid control token")

    from app.services.cloud_bot_runner import start_job
    await start_job(
        spec["sessionkey"],
        int(char_id),
        spec["bot_type"],
        spec.get("params"),
        spec.get("credentials"),
        control_token=spec["control_token"],
        replace_existing=False,
        resume_state=spec.get("resume_state"),
        recovered_job_id=str(job_id),
    )

    pool = await _get_pool()
    assert pool is not None
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                UPDATE myninja_job_snapshots
                SET recovery_required=false,active=true,inflight=false,updated_at=now()
                WHERE job_id=%s
                """,
                (str(job_id),),
            )
    return True


async def recent_events(char_id: int, limit: int = 1000) -> List[Dict[str, Any]]:
    pool = await _get_pool()
    if pool is None:
        return []
    limit = max(1, min(5000, int(limit)))
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT job_id,event_seq,event_type,level,payload,
                       extract(epoch from created_at)
                FROM myninja_job_journal
                WHERE char_id=%s
                ORDER BY created_at DESC
                LIMIT %s
                """,
                (int(char_id), limit),
            )
            rows = await cur.fetchall()
    return [{
        "job_id": row[0],
        "seq": int(row[1]),
        "type": row[2],
        "level": row[3],
        "data": row[4] or {},
        "ts": float(row[5]),
    } for row in rows]


async def save_passkey(record: Dict[str, Any]) -> None:
    pool = await _get_pool()
    if pool is None:
        raise RuntimeError("Durable database is required for passkey storage")
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                INSERT INTO myninja_passkeys(
                    credential_id,credential_public_key,sign_count,transports,
                    device_type,backed_up
                )
                VALUES (%s,%s,%s,%s::jsonb,%s,%s)
                ON CONFLICT(credential_id) DO UPDATE SET
                    credential_public_key=excluded.credential_public_key,
                    sign_count=excluded.sign_count,
                    transports=excluded.transports,
                    device_type=excluded.device_type,
                    backed_up=excluded.backed_up,
                    updated_at=now()
                """,
                (
                    record["credential_id"], record["credential_public_key"],
                    int(record.get("sign_count") or 0),
                    json.dumps(record.get("transports") or []),
                    record.get("device_type"), bool(record.get("backed_up")),
                ),
            )


async def list_passkeys() -> List[Dict[str, Any]]:
    pool = await _get_pool()
    if pool is None:
        return []
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT credential_id,credential_public_key,sign_count,transports,
                       device_type,backed_up
                FROM myninja_passkeys ORDER BY created_at ASC
                """
            )
            rows = await cur.fetchall()
    return [{
        "credential_id": r[0], "credential_public_key": r[1],
        "sign_count": int(r[2]), "transports": r[3] or [],
        "device_type": r[4], "backed_up": bool(r[5]),
    } for r in rows]


async def update_passkey_sign_count(credential_id: str, sign_count: int) -> None:
    pool = await _get_pool()
    if pool is None:
        return
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                UPDATE myninja_passkeys
                SET sign_count=%s,updated_at=now()
                WHERE credential_id=%s
                """,
                (int(sign_count), str(credential_id)),
            )


async def audit(event_type: str, detail: Optional[Dict[str, Any]] = None) -> None:
    pool = await _get_pool()
    if pool is None:
        return
    async with pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                INSERT INTO myninja_security_audit(event_type,detail)
                VALUES (%s,%s::jsonb)
                """,
                (str(event_type)[:80], json.dumps(detail or {}, ensure_ascii=False)),
            )


async def close() -> None:
    global _pool
    if _pool is not None:
        try:
            await _pool.close()
        finally:
            _pool = None
