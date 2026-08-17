from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
from typing import Any, Dict

from app.services import cloud_store, durable_journal, orchestrator

ROOT = Path(__file__).resolve().parents[1]
WEB = ROOT / "web"


def version_info() -> Dict[str, Any]:
    try:
        version = json.loads((WEB / "version.json").read_text(encoding="utf-8"))
    except Exception:
        version = {"version": "unknown"}
    try:
        manifest = json.loads((WEB / "release-manifest.json").read_text(encoding="utf-8"))
    except Exception:
        manifest = {}
    return {"version": version, "release": manifest}


def config_checksum() -> str:
    # Only non-secret operational flags are hashed.
    keys = [
        "BOT_ENGINE_MODE", "BOT_STATE_PREFIX", "JOURNAL_AUTO_RECOVER",
        "GLOBAL_ACTION_SPACING_SECONDS", "PANEL_GUARD_ENABLED",
        "OTEL_ENABLED", "RENDER_GIT_BRANCH", "RENDER_GIT_COMMIT",
    ]
    payload = {k: os.getenv(k, "") for k in keys}
    raw = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha256(raw).hexdigest()[:16]


async def readiness() -> Dict[str, Any]:
    from app.services import panel_guard

    journal_ok = await durable_journal.ping() if durable_journal.configured() else None
    redis_ok = await cloud_store.ping() if cloud_store.redis_configured() else None
    guard = await panel_guard.status()

    ready = True
    reasons = []
    if durable_journal.configured() and not journal_ok:
        ready = False
        reasons.append("durable journal configured but unreachable")
    if panel_guard.enabled() and not guard.get("configured"):
        ready = False
        reasons.append("panel guard enabled but incomplete")

    return {
        "ready": ready,
        "reasons": reasons,
        "journal": {
            "configured": durable_journal.configured(),
            "reachable": journal_ok,
            "encrypted_recovery_ready": durable_journal.encrypted_recovery_ready(),
        },
        "redis": {
            "configured": cloud_store.redis_configured(),
            "reachable": redis_ok,
        },
        "panel_guard": guard,
        "orchestrator": orchestrator.metrics(),
        "config_checksum": config_checksum(),
        **version_info(),
    }


def validate_startup() -> None:
    info = version_info()
    version = str((info.get("version") or {}).get("version") or "")
    if version != "6.0.0":
        raise RuntimeError(f"Expected Control Center 6.0.0 assets, found {version!r}")
