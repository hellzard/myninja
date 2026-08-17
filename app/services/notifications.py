from __future__ import annotations

import asyncio
import hashlib
import json
import os
from collections import defaultdict
from typing import Any, Dict, List

from app.services import cloud_store

try:
    from pywebpush import webpush, WebPushException
except Exception:
    webpush = None
    WebPushException = Exception

VAPID_PRIVATE_KEY = os.getenv("VAPID_PRIVATE_KEY", "").strip()
VAPID_PUBLIC_KEY = os.getenv("VAPID_PUBLIC_KEY", "").strip()
VAPID_SUBJECT = os.getenv("VAPID_SUBJECT", "mailto:admin@example.com").strip()

_memory: dict[int, dict[str, Dict[str, Any]]] = defaultdict(dict)

IMPORTANT_EVENTS = {
    "TARGET_REACHED", "SESSION_RECOVERED", "SESSION_RECOVERY_FAILED",
    "CIRCUIT_BREAKER", "RECIPE_COMPLETE", "JOB_STOPPED", "SCHEDULE_STARTED",
}


def enabled() -> bool:
    return bool(webpush and VAPID_PRIVATE_KEY and VAPID_PUBLIC_KEY and VAPID_SUBJECT)


def public_key() -> str:
    return VAPID_PUBLIC_KEY if enabled() else ""


def _key(subscription: Dict[str, Any]) -> str:
    return hashlib.sha256(str(subscription.get("endpoint") or "").encode()).hexdigest()


async def subscribe(char_id: int, subscription: Dict[str, Any]) -> None:
    if not isinstance(subscription, dict) or not subscription.get("endpoint"):
        raise ValueError("Invalid push subscription")
    entry = {"endpoint": subscription.get("endpoint"), "keys": dict(subscription.get("keys") or {})}
    _memory[int(char_id)][_key(entry)] = entry
    await cloud_store.save_push_subscription(int(char_id), entry)


async def unsubscribe(char_id: int, endpoint: str) -> None:
    digest = hashlib.sha256(str(endpoint).encode()).hexdigest()
    _memory[int(char_id)].pop(digest, None)
    await cloud_store.delete_push_subscription(int(char_id), endpoint)


async def subscriptions(char_id: int) -> List[Dict[str, Any]]:
    merged = dict(_memory.get(int(char_id), {}))
    for entry in await cloud_store.list_push_subscriptions(int(char_id)):
        merged[_key(entry)] = entry
    return list(merged.values())


def _content(event: Dict[str, Any]) -> tuple[str, str]:
    kind = str(event.get("type") or "BOT_EVENT")
    data = event.get("data") if isinstance(event.get("data"), dict) else {}
    title = "Ninja Sage Control Center"
    messages = {
        "TARGET_REACHED": "Target Auto Leveling sudah tercapai.",
        "SESSION_RECOVERED": "Session berhasil dipulihkan dan bot melanjutkan pekerjaan.",
        "SESSION_RECOVERY_FAILED": "Session tidak berhasil dipulihkan. Periksa panel.",
        "CIRCUIT_BREAKER": "Bot sedang cooldown karena error berulang.",
        "RECIPE_COMPLETE": "Automation Recipe selesai.",
        "JOB_STOPPED": "Cloud bot berhenti.",
        "SCHEDULE_STARTED": "Jadwal automation mulai dijalankan.",
    }
    body = messages.get(kind, str(data.get("message") or kind.replace("_", " ").title()))
    return title, body


async def notify_event(char_id: int, event: Dict[str, Any]) -> int:
    if not enabled() or str(event.get("type") or "") not in IMPORTANT_EVENTS:
        return 0
    title, body = _content(event)
    payload = json.dumps({"title": title, "body": body, "url": "/panel/", "event": event.get("type")})
    sent = 0
    for subscription in await subscriptions(int(char_id)):
        try:
            await asyncio.to_thread(
                webpush,
                subscription_info=subscription,
                data=payload,
                vapid_private_key=VAPID_PRIVATE_KEY,
                vapid_claims={"sub": VAPID_SUBJECT},
                ttl=120,
            )
            sent += 1
        except WebPushException as exc:
            response = getattr(exc, "response", None)
            if getattr(response, "status_code", None) in (404, 410):
                await unsubscribe(int(char_id), str(subscription.get("endpoint") or ""))
        except Exception:
            continue
    return sent
