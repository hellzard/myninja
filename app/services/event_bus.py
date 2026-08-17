from __future__ import annotations

import asyncio
import secrets
import time
from collections import defaultdict
from dataclasses import dataclass
from typing import Any, Dict, Optional


@dataclass
class Ticket:
    char_id: int
    control_token: str
    expires_at: float


_subscribers: dict[int, set[asyncio.Queue]] = defaultdict(set)
_tickets: Dict[str, Ticket] = {}
_lock = asyncio.Lock()


def _cleanup_tickets() -> None:
    now = time.time()
    for key, ticket in list(_tickets.items()):
        if ticket.expires_at <= now:
            _tickets.pop(key, None)


async def issue_ticket(char_id: int, control_token: str, ttl_seconds: int = 60) -> str:
    token = secrets.token_urlsafe(32)
    async with _lock:
        _cleanup_tickets()
        _tickets[token] = Ticket(
            char_id=int(char_id),
            control_token=str(control_token),
            expires_at=time.time() + max(15, min(120, int(ttl_seconds))),
        )
    return token


async def consume_ticket(ticket: str, char_id: int) -> Optional[str]:
    async with _lock:
        _cleanup_tickets()
        item = _tickets.pop(str(ticket), None)
    if item is None or item.char_id != int(char_id) or item.expires_at <= time.time():
        return None
    return item.control_token


async def subscribe(char_id: int, max_queue: int = 24) -> asyncio.Queue:
    queue: asyncio.Queue = asyncio.Queue(maxsize=max(4, int(max_queue)))
    async with _lock:
        _subscribers[int(char_id)].add(queue)
    return queue


async def unsubscribe(char_id: int, queue: asyncio.Queue) -> None:
    async with _lock:
        group = _subscribers.get(int(char_id))
        if group is None:
            return
        group.discard(queue)
        if not group:
            _subscribers.pop(int(char_id), None)


async def _publish(char_id: int, payload: Dict[str, Any]) -> None:
    async with _lock:
        queues = list(_subscribers.get(int(char_id), set()))
    for queue in queues:
        try:
            if queue.full():
                try:
                    queue.get_nowait()
                except asyncio.QueueEmpty:
                    pass
            queue.put_nowait(dict(payload))
        except Exception:
            continue


async def publish_status(char_id: int, status: Dict[str, Any]) -> None:
    await _publish(int(char_id), {"type": "job_status", "job": status, "ts": time.time()})


async def publish_event(char_id: int, event: Dict[str, Any]) -> None:
    await _publish(int(char_id), {"type": "job_event", "event": event, "ts": time.time()})


async def subscriber_count(char_id: Optional[int] = None) -> int:
    async with _lock:
        if char_id is not None:
            return len(_subscribers.get(int(char_id), set()))
        return sum(len(group) for group in _subscribers.values())
