from __future__ import annotations

import asyncio
import signal

from app.services import cloud_store
from app.services.cloud_bot_runner import start_job


async def _recover() -> int:
    recovered = 0
    for spec in await cloud_store.list_active_specs(include_queued=False):
        token = str(spec.pop("control_token", "") or "")
        spec.pop("active", None)
        spec.pop("stored_at", None)
        if not token:
            continue
        try:
            await start_job(
                spec["sessionkey"],
                int(spec["char_id"]),
                spec["bot_type"],
                spec.get("params"),
                spec.get("credentials"),
                control_token=token,
                replace_existing=False,
            )
            recovered += 1
        except Exception as exc:
            print(f"[worker] recovery skipped for char {spec.get('char_id')}: {exc}")
    return recovered


async def main() -> None:
    if not cloud_store.queue_mode():
        raise RuntimeError(
            "Worker requires BOT_ENGINE_MODE=worker, REDIS_URL, and BOT_STATE_SECRET."
        )
    if not await cloud_store.ping():
        raise RuntimeError("Unable to reach Redis/Render Key Value.")

    recovered = await _recover()
    print(f"[worker] ready; recovered {recovered} active job(s)")

    stop_event = asyncio.Event()
    loop = asyncio.get_running_loop()
    for sig in (signal.SIGINT, signal.SIGTERM):
        try:
            loop.add_signal_handler(sig, stop_event.set)
        except NotImplementedError:
            pass

    while not stop_event.is_set():
        try:
            payload = await cloud_store.dequeue_start(timeout_seconds=2)
            if not payload:
                continue

            token = str(payload.pop("control_token", "") or "")
            payload.pop("active", None)
            if not token:
                print("[worker] ignored queued job without control token")
                continue

            char_id = int(payload["char_id"])
            if await cloud_store.stop_requested(char_id):
                await cloud_store.mark_spec_inactive(char_id)
                stopped = {
                    "running": False,
                    "bot_type": payload.get("bot_type"),
                    "char_id": char_id,
                    "params": payload.get("params") or {},
                    "iteration": 0,
                    "consecutive_failures": 0,
                    "last_message": "Queued job was cancelled before worker start.",
                    "created_at": 0,
                    "finished_at": None,
                    "health": {"state": "STOPPED", "detail": "Cancelled before worker start", "next_action_at": None, "delay_seconds": 0},
                    "analytics": {},
                    "logs": [],
                }
                await cloud_store.save_status(char_id, stopped, token)
                await cloud_store.clear_stop(char_id)
                print(f"[worker] skipped cancelled queued job for char {char_id}")
                continue

            try:
                await start_job(
                    payload["sessionkey"],
                    int(payload["char_id"]),
                    payload["bot_type"],
                    payload.get("params"),
                    payload.get("credentials"),
                    control_token=token,
                    replace_existing=True,
                )
                print(
                    f"[worker] started {payload['bot_type']} for char {payload['char_id']}"
                )
            except Exception as exc:
                print(f"[worker] failed to start queued job: {exc}")
        except asyncio.CancelledError:
            raise
        except Exception as exc:
            print(f"[worker] queue error: {exc}")
            await asyncio.sleep(3)

    await cloud_store.close()


if __name__ == "__main__":
    asyncio.run(main())
