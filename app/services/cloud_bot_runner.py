import asyncio
import secrets
import time
from collections import deque
from dataclasses import dataclass, field
from typing import Any, Dict, Optional

from app.services.bot_manager import (
    auto_clan_war,
    auto_daily_event,
    auto_eudemon,
    auto_exam,
    auto_mission_s,
    auto_monster_hunt,
    auto_shadow_war,
    get_or_fetch_char_level,
    run_auto_mission,
    run_circus_event,
    run_hunting,
    run_mission,
    run_yokai_event,
    run_yokai_minigame,
)
from app.services.ninjasage_client import NinjaSageClient
from app.services.settings_manager import load_settings


SUPPORTED_BOTS = {
    "auto_level",
    "auto_daily",
    "auto_hunting",
    "eudemon",
    "circus",
    "yokai",
    "yokai_minigame",
    "shadow_war",
    "monster",
    "mission_s",
    "clan_war",
    "mission",
}

DEFAULT_DELAYS = {
    "auto_level": 5.0,
    "auto_daily": 2.5,
    "auto_hunting": 3.0,
    "eudemon": 3.5,
    "circus": 4.0,
    "yokai": 5.5,
    "yokai_minigame": 3.0,
    "shadow_war": 3.0,
    "monster": 3.5,
    "mission_s": 2.5,
    "clan_war": 2.0,
    "mission": 2.0,
}


@dataclass
class CloudBotJob:
    char_id: int
    sessionkey: str
    bot_type: str
    params: Dict[str, Any]
    control_token: str
    created_at: float = field(default_factory=time.time)
    finished_at: Optional[float] = None
    running: bool = True
    iteration: int = 0
    consecutive_failures: int = 0
    last_message: str = "Starting..."
    current_zone: int = 1
    log_seq: int = 0
    logs: deque = field(default_factory=lambda: deque(maxlen=100))
    task: Optional[asyncio.Task] = None

    def add_log(self, message: str, level: str = "info") -> None:
        self.log_seq += 1
        self.last_message = str(message)
        self.logs.append(
            {
                "seq": self.log_seq,
                "ts": int(time.time()),
                "level": level,
                "message": str(message),
            }
        )

    def public_status(self) -> Dict[str, Any]:
        safe_params = {
            key: value
            for key, value in self.params.items()
            if key in {"mission_id", "boss_type", "max_level"}
        }
        return {
            "running": self.running,
            "bot_type": self.bot_type,
            "char_id": self.char_id,
            "params": safe_params,
            "iteration": self.iteration,
            "consecutive_failures": self.consecutive_failures,
            "last_message": self.last_message,
            "created_at": self.created_at,
            "finished_at": self.finished_at,
            "logs": list(self.logs)[-30:],
        }


_jobs: Dict[int, CloudBotJob] = {}
_jobs_lock = asyncio.Lock()


def _default_delay(bot_type: str) -> float:
    if bot_type == "auto_level":
        try:
            value = float(load_settings().get("leveling_delay_seconds", 5))
            return max(1.0, value)
        except Exception:
            return 5.0
    return DEFAULT_DELAYS.get(bot_type, 3.0)


def _mission_for_level(level: int) -> str:
    if level >= 80:
        return "msn_109"
    if level >= 60:
        return "msn_60"
    if level >= 40:
        return "msn_42"
    if level >= 20:
        return "msn_21"
    if level >= 10:
        return "msn_11"
    return "msn_3"


async def _run_step(job: CloudBotJob, client: NinjaSageClient) -> str:
    bt = job.bot_type
    sk = job.sessionkey
    cid = job.char_id
    params = job.params

    if bt == "auto_level":
        level = await get_or_fetch_char_level(client, sk, cid)
        level = int(level or 1)
        max_level = params.get("max_level")
        if max_level is not None:
            try:
                if level >= int(max_level):
                    return f"TARGET_REACHED: Character is level {level}; max target is {int(max_level)}."
            except (TypeError, ValueError):
                pass

        # Mirror the browser behavior: check exam periodically instead of every cycle.
        if job.iteration % 10 == 0:
            try:
                exam_result = await auto_exam(client, sk, cid)
                if exam_result and "No exams available" not in str(exam_result):
                    job.add_log(f"[Exam] {exam_result}", "info")
            except Exception as exc:
                job.add_log(f"[Exam] check skipped: {exc}", "warn")

        mission_id = _mission_for_level(level)
        return str(await run_mission(client, sk, cid, mission_id))

    if bt == "auto_daily":
        return str(await auto_daily_event(client, sk, cid))

    if bt == "auto_hunting":
        result = str(await run_hunting(client, sk, cid, job.current_zone))
        job.current_zone = 1 if job.current_zone >= 5 else job.current_zone + 1
        return result

    if bt == "eudemon":
        return str(await auto_eudemon(client, sk, cid))

    if bt == "circus":
        boss_type = str(params.get("boss_type", "ringmaster"))
        if boss_type not in {"ringmaster", "jester"}:
            boss_type = "ringmaster"
        return str(await run_circus_event(client, sk, cid, boss_type=boss_type))

    if bt == "yokai":
        boss_type = str(params.get("boss_type", "kitsune"))
        if boss_type not in {"kitsune", "tengu", "nurarihyon"}:
            boss_type = "kitsune"
        return str(await run_yokai_event(client, sk, cid, boss_type=boss_type))

    if bt == "yokai_minigame":
        return str(await run_yokai_minigame(client, sk, cid))

    if bt == "shadow_war":
        return str(await auto_shadow_war(client, sk, cid))

    if bt == "monster":
        return str(await auto_monster_hunt(client, sk, cid))

    if bt == "mission_s":
        return str(await auto_mission_s(client, sk, cid))

    if bt == "clan_war":
        return str(await auto_clan_war(client, sk, cid))

    if bt == "mission":
        mission_id = str(params.get("mission_id", "")).strip()
        if not mission_id:
            raise ValueError("mission_id is required for mission bot")
        return str(await run_auto_mission(client, sk, cid, mission_id))

    raise ValueError(f"Unsupported bot_type: {bt}")


def _should_stop(job: CloudBotJob, message: str) -> bool:
    text = (message or "").lower()

    if "target_reached:" in text:
        return True

    if job.bot_type == "auto_daily":
        return "daily missions completed" in text or "no available daily missions" in text

    if job.bot_type == "auto_hunting":
        return "stopped" in text

    if job.bot_type == "eudemon":
        return "no available eudemon bosses" in text or "requires level" in text

    if job.bot_type in {"circus", "yokai"}:
        return any(word in text for word in ("energy", "ticket", "stopped"))

    if job.bot_type == "yokai_minigame":
        return any(word in text for word in ("energy", "ticket"))

    if job.bot_type == "monster":
        return "energy habis" in text or "energy monster hunter habis" in text or "stopped" in text

    if job.bot_type == "mission":
        return "invalid response" in text

    return False


def _looks_failed(message: str) -> bool:
    text = (message or "").lower()
    return any(marker in text for marker in ("failed", "error", "exception"))


async def _job_loop(job: CloudBotJob) -> None:
    client = NinjaSageClient()
    job.add_log(f"Cloud bot started: {job.bot_type}", "info")

    try:
        while job.running:
            try:
                message = await _run_step(job, client)
                job.iteration += 1

                if _looks_failed(message):
                    job.consecutive_failures += 1
                    job.add_log(message, "warn")
                else:
                    job.consecutive_failures = 0
                    job.add_log(message, "info")

                if _should_stop(job, message):
                    job.add_log("Stop condition reached; cloud bot finished.", "info")
                    break

                if job.consecutive_failures >= 3:
                    job.add_log("Stopped after 3 consecutive failed responses.", "error")
                    break

                delay = _default_delay(job.bot_type)
                if "rate limit" in message.lower():
                    delay = max(delay, 10.0)
                    job.add_log("Rate limit detected; backing off for 10 seconds.", "warn")

                await asyncio.sleep(delay)

            except asyncio.CancelledError:
                raise
            except Exception as exc:
                job.consecutive_failures += 1
                job.add_log(f"Step error: {exc}", "error")
                if job.consecutive_failures >= 3:
                    job.add_log("Stopped after 3 consecutive exceptions.", "error")
                    break
                await asyncio.sleep(max(_default_delay(job.bot_type), 8.0))

    except asyncio.CancelledError:
        job.add_log("Cloud bot cancelled by user.", "info")
        raise
    finally:
        job.running = False
        job.finished_at = time.time()
        job.add_log("Cloud bot is now idle.", "info")


async def start_job(
    sessionkey: str,
    char_id: int,
    bot_type: str,
    params: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
    bot_type = str(bot_type).strip().lower()
    if bot_type not in SUPPORTED_BOTS:
        raise ValueError(f"Unsupported bot_type: {bot_type}")
    if not sessionkey:
        raise ValueError("sessionkey is required")

    params = dict(params or {})

    async with _jobs_lock:
        existing = _jobs.get(char_id)
        if existing and existing.running and existing.task:
            existing.running = False
            existing.task.cancel()
            await asyncio.gather(existing.task, return_exceptions=True)

        token = secrets.token_urlsafe(32)
        job = CloudBotJob(
            char_id=char_id,
            sessionkey=sessionkey,
            bot_type=bot_type,
            params=params,
            control_token=token,
        )
        _jobs[char_id] = job
        job.task = asyncio.create_task(_job_loop(job), name=f"cloud-bot-{char_id}-{bot_type}")

    result = job.public_status()
    result["control_token"] = token
    return result


def _get_authorized_job(char_id: int, control_token: str) -> Optional[CloudBotJob]:
    job = _jobs.get(char_id)
    if job is None:
        return None
    if not control_token or not secrets.compare_digest(job.control_token, control_token):
        raise PermissionError("Invalid control token")
    return job


async def stop_job(char_id: int, control_token: str) -> Dict[str, Any]:
    async with _jobs_lock:
        job = _get_authorized_job(char_id, control_token)
        if job is None:
            return {"running": False, "char_id": char_id, "status": "idle", "logs": []}

        if job.running and job.task:
            job.running = False
            job.task.cancel()
            await asyncio.gather(job.task, return_exceptions=True)

        return job.public_status()


async def get_status(char_id: int, control_token: str) -> Dict[str, Any]:
    job = _get_authorized_job(char_id, control_token)
    if job is None:
        return {"running": False, "char_id": char_id, "status": "idle", "logs": []}
    return job.public_status()
