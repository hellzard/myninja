from __future__ import annotations

import asyncio
import random
import re
import secrets
import time
from collections import deque
from dataclasses import dataclass, field
from typing import Any, Dict, Optional

from app.services.bot_manager import (
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
from app.services.clan_war_cloud import ClanRateLimited, CloudClanWarSession
from app.services.ninjasage_client import NinjaSageClient
from app.services.settings_manager import load_settings
from app.services import cloud_store, event_bus, notifications, recipes, durable_journal, orchestrator


SUPPORTED_BOTS = {
    "auto_level", "auto_daily", "auto_hunting", "eudemon", "circus", "yokai",
    "yokai_minigame", "shadow_war", "monster", "mission_s", "clan_war", "mission", "recipe",
}

BOT_DELAY_KEYS = {
    "auto_level": "leveling_delay_seconds",
    "auto_daily": "daily_delay_seconds",
    "auto_hunting": "hunting_delay_seconds",
    "eudemon": "eudemon_delay_seconds",
    "circus": "circus_delay_seconds",
    "yokai": "yokai_delay_seconds",
    "yokai_minigame": "yokai_minigame_delay_seconds",
    "shadow_war": "shadow_war_between_battles_seconds",
    "monster": "monster_delay_seconds",
    "mission_s": "mission_s_delay_seconds",
    "mission": "mission_delay_seconds",
    "clan_war": "clan_war_battle_delay_seconds",
}

STOP_STATES = {"IDLE", "ERROR", "STOPPED"}


@dataclass
class StepResult:
    message: str
    wait_seconds: Optional[float] = None
    count_action: bool = True


@dataclass
class CloudBotJob:
    char_id: int
    sessionkey: str
    bot_type: str
    params: Dict[str, Any]
    control_token: str
    job_id: str = field(default_factory=lambda: secrets.token_hex(16))
    credentials: Dict[str, str] = field(default_factory=dict, repr=False)
    created_at: float = field(default_factory=time.time)
    finished_at: Optional[float] = None
    running: bool = True
    iteration: int = 0
    consecutive_failures: int = 0
    last_message: str = "Starting..."
    current_zone: int = 1
    log_seq: int = 0
    logs: deque = field(default_factory=lambda: deque(maxlen=300))
    task: Optional[asyncio.Task] = None
    failure_times: deque = field(default_factory=lambda: deque(maxlen=50))
    rate_limit_level: int = 0
    session_generation: int = 0
    session_update: Optional[Dict[str, Any]] = None
    runtime: Dict[str, Any] = field(default_factory=dict, repr=False)

    health_state: str = "STARTING"
    health_detail: str = "Preparing cloud job"
    next_action_at: Optional[float] = None
    current_delay: float = 0.0

    success_count: int = 0
    failure_count: int = 0
    rate_limit_count: int = 0
    relogin_count: int = 0
    earned_xp: int = 0
    earned_gold: int = 0
    earned_token: int = 0
    last_success_at: Optional[float] = None
    action_count: int = 0
    first_action_at: Optional[float] = None
    last_action_at: Optional[float] = None

    event_seq: int = 0
    events: deque = field(default_factory=lambda: deque(maxlen=400))
    last_published_event_seq: int = 0
    adaptive_penalty_seconds: float = 0.0
    pacing_base_seconds: float = 0.0
    pacing_effective_seconds: float = 0.0
    pacing_reason: str = "base"
    network_last_ms: float = 0.0
    network_avg_ms: float = 0.0
    network_p95_ms: float = 0.0

    def record_event(self, event_type: str, data: Optional[Dict[str, Any]] = None, level: str = "info") -> Dict[str, Any]:
        self.event_seq += 1
        event = {
            "seq": self.event_seq,
            "ts": time.time(),
            "job_started_at": self.created_at,
            "type": str(event_type).upper()[:64],
            "level": level,
            "data": dict(data or {}),
        }
        self.events.append(event)
        return event

    def add_log(self, message: str, level: str = "info") -> None:
        now = time.time()
        self.log_seq += 1
        self.last_message = str(message)
        self.logs.append({
            "seq": self.log_seq,
            "ts": now,
            "ts_ms": int(now * 1000),
            "level": level,
            "message": str(message),
        })

    def set_health(
        self,
        state: str,
        detail: str = "",
        *,
        next_action_at: Optional[float] = None,
        delay_seconds: float = 0.0,
    ) -> None:
        previous = self.health_state
        self.health_state = str(state).upper()
        self.health_detail = str(detail or "")
        self.next_action_at = next_action_at
        self.current_delay = max(0.0, float(delay_seconds or 0.0))
        if self.health_state != previous:
            self.record_event("HEALTH_CHANGED", {"state": self.health_state, "detail": self.health_detail, "delay": self.current_delay})

    def analytics(self) -> Dict[str, Any]:
        end = self.finished_at or time.time()
        uptime = max(0.0, end - self.created_at)
        attempts = self.success_count + self.failure_count

        if self.first_action_at and self.last_action_at:
            observed = max(0.0, self.last_action_at - self.first_action_at)
        else:
            observed = 0.0
        rate_window = max(300.0, observed)
        hours = rate_window / 3600.0

        if self.action_count >= 40 and observed >= 1800:
            confidence = "high"
        elif self.action_count >= 15 and observed >= 600:
            confidence = "medium"
        elif self.action_count >= 5:
            confidence = "low"
        else:
            confidence = "warming"

        return {
            "action_count": self.action_count,
            "success_count": self.success_count,
            "failure_count": self.failure_count,
            "rate_limit_count": self.rate_limit_count,
            "relogin_count": self.relogin_count,
            "earned_xp": self.earned_xp,
            "earned_gold": self.earned_gold,
            "earned_token": self.earned_token,
            "uptime_seconds": int(uptime),
            "rate_window_seconds": int(rate_window),
            "confidence": confidence,
            "actions_per_hour": round(self.action_count / hours, 1),
            "xp_per_hour": round(self.earned_xp / hours, 1),
            "gold_per_hour": round(self.earned_gold / hours, 1),
            "success_rate": round((self.success_count / attempts) * 100, 1) if attempts else 0.0,
            "last_success_at": self.last_success_at,
            "network_last_ms": round(self.network_last_ms, 1),
            "network_avg_ms": round(self.network_avg_ms, 1),
            "network_p95_ms": round(self.network_p95_ms, 1),
            "pacing_base_seconds": round(self.pacing_base_seconds, 1),
            "pacing_effective_seconds": round(self.pacing_effective_seconds, 1),
            "pacing_reason": self.pacing_reason,
        }

    def public_status(self) -> Dict[str, Any]:
        safe_keys = {
            "mission_id", "boss_type", "max_level", "schedule_at", "repeat_every_seconds", "recipe",
        }
        safe_params = {k: v for k, v in self.params.items() if k in safe_keys}
        return {
            "running": self.running,
            "bot_type": self.bot_type,
            "char_id": self.char_id,
            "job_id": self.job_id,
            "params": safe_params,
            "iteration": self.iteration,
            "action_count": self.action_count,
            "consecutive_failures": self.consecutive_failures,
            "last_message": self.last_message,
            "created_at": self.created_at,
            "finished_at": self.finished_at,
            "session_generation": self.session_generation,
            "session_update": self.session_update,
            "health": {
                "state": self.health_state,
                "detail": self.health_detail,
                "next_action_at": self.next_action_at,
                "delay_seconds": self.current_delay,
            },
            "analytics": self.analytics(),
            "events": list(self.events)[-120:],
            "logs": list(self.logs)[-120:],
        }


_jobs: Dict[int, CloudBotJob] = {}
_jobs_lock = asyncio.Lock()


def _settings() -> Dict[str, Any]:
    return load_settings()


def _delay(bot_type: str) -> float:
    cfg = _settings()
    key = BOT_DELAY_KEYS.get(bot_type)
    try:
        base = float(cfg.get(key, 10)) if key else 10.0
    except (TypeError, ValueError):
        base = 10.0
    base = max(3.0, base)
    try:
        jitter = max(0.0, float(cfg.get("leveling_action_jitter_seconds", 0)))
    except (TypeError, ValueError):
        jitter = 0.0
    return base + (random.uniform(0.0, jitter) if jitter else 0.0)



def _active_delay_type(job: CloudBotJob) -> str:
    if job.bot_type == "recipe":
        return str(job.runtime.get("recipe_effective_bot_type") or "auto_level")
    return job.bot_type


def _adaptive_delay(job: CloudBotJob, client: NinjaSageClient, *, failed: bool = False) -> float:
    cfg = _settings()
    active_type = _active_delay_type(job)
    base = _delay(active_type)
    metrics = client.network_metrics()
    job.network_last_ms = float(metrics.get("last_ms") or 0)
    job.network_avg_ms = float(metrics.get("avg_ms") or 0)
    job.network_p95_ms = float(metrics.get("p95_ms") or 0)
    job.pacing_base_seconds = base

    if not cfg.get("adaptive_pacing_enabled", True):
        job.adaptive_penalty_seconds = 0.0
        job.pacing_effective_seconds = base
        job.pacing_reason = "adaptive disabled"
        return base

    soft = max(500, float(cfg.get("adaptive_latency_soft_ms", 2500) or 2500))
    hard = max(soft, float(cfg.get("adaptive_latency_hard_ms", 5000) or 5000))
    cap = max(0.0, float(cfg.get("adaptive_max_penalty_seconds", 30) or 30))
    reason = "healthy upstream"
    if failed:
        job.adaptive_penalty_seconds = max(job.adaptive_penalty_seconds, min(cap, max(3.0, job.consecutive_failures * 5.0)))
        reason = "recent failure"
    elif job.network_p95_ms >= hard:
        job.adaptive_penalty_seconds = max(job.adaptive_penalty_seconds, min(cap, 8.0))
        reason = "high p95 latency"
    elif job.network_p95_ms >= soft:
        job.adaptive_penalty_seconds = max(job.adaptive_penalty_seconds, min(cap, 3.0))
        reason = "elevated latency"
    else:
        job.adaptive_penalty_seconds = max(0.0, job.adaptive_penalty_seconds - 1.0)
    effective = base + min(cap, job.adaptive_penalty_seconds)
    job.pacing_effective_seconds = effective
    job.pacing_reason = reason if job.adaptive_penalty_seconds else "base delay"
    return effective


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


RESOURCE_EXHAUSTED_PHRASES = (
    "you don't have energy",
    "you dont have energy",
    "you do not have energy",
    "out of energy",
    "not enough energy",
    "insufficient energy",
    "no energy",
    "energy habis",
    "energy is empty",
    "out of free tries",
    "no free tries",
    "free tries exhausted",
)


def _is_resource_exhausted(message: str) -> bool:
    text = str(message or "").lower()
    return any(
        phrase in text
        for phrase in RESOURCE_EXHAUSTED_PHRASES
    )


def _is_failed(message: str) -> bool:
    text = (message or "").lower()

    # Resource exhaustion is an expected terminal state.
    # Do not put it into retry/backoff failure loops.
    if _is_resource_exhausted(text):
        return False

    return any(
        value in text
        for value in ("failed", "error", "exception", "rejected")
    )


def _is_666(message: str) -> bool:
    text = (message or "").lower()
    return (
        bool(re.search(r"(?:error['\" ]*[:=]\s*|error\s+)(?:['\"])?666\b", text))
        or "'error': 666" in text
    )


def _is_rate_limit(message: str) -> bool:
    text = (message or "").lower()
    return any(x in text for x in ("rate limit", "too many requests", "http 429", "status 429"))


def _should_stop(job: CloudBotJob, message: str) -> bool:
    text = (message or "").lower()
    if "target_reached:" in text or "recipe_complete:" in text or "recipe_aborted:" in text:
        return True
    if job.bot_type == "auto_daily":
        return "daily missions completed" in text or "no available daily missions" in text
    if job.bot_type == "auto_hunting":
        return "stopped" in text
    if job.bot_type == "eudemon":
        return "no available eudemon bosses" in text or "requires level" in text
    if job.bot_type in {"circus", "yokai", "yokai_minigame"}:
        if _is_resource_exhausted(text):
            return True

        if "stopped" in text or "ticket" in text:
            return True

        if job.bot_type == "yokai_minigame":
            if "free tries" in text or "free play" in text:
                return True

        return False
    if job.bot_type == "monster":
        return "energy habis" in text or "energy monster hunter habis" in text or "stopped" in text
    if job.bot_type == "mission":
        return "invalid response" in text
    return False


def _repeat_enabled(job: CloudBotJob, message: str) -> bool:
    if "target_reached:" in (message or "").lower():
        return False
    try:
        repeat = int(job.params.get("repeat_every_seconds") or 0)
    except (TypeError, ValueError):
        repeat = 0
    minimum = max(3600, int(_settings().get("scheduler_min_repeat_seconds", 3600) or 3600))
    return repeat >= minimum


def _repeat_seconds(job: CloudBotJob) -> int:
    try:
        repeat = int(job.params.get("repeat_every_seconds") or 0)
    except (TypeError, ValueError):
        repeat = 0
    minimum = max(3600, int(_settings().get("scheduler_min_repeat_seconds", 3600) or 3600))
    return max(minimum, repeat) if repeat else 0


def _capture_rewards(job: CloudBotJob, message: str) -> None:
    text = str(message or "")
    if "SUCCESS" not in text.upper():
        return
    patterns = {
        "xp": r"(?:^|\|\s*)XP:\s*\+?(-?\d+)",
        "gold": r"(?:^|\|\s*)Gold:\s*\+?(-?\d+)",
        "token": r"(?:^|\|\s*)Token:\s*\+?(-?\d+)",
    }
    values: Dict[str, int] = {}
    for key, pattern in patterns.items():
        match = re.search(pattern, text, flags=re.I)
        if match:
            try:
                values[key] = max(0, int(match.group(1)))
            except (TypeError, ValueError):
                pass
    job.earned_xp += values.get("xp", 0)
    job.earned_gold += values.get("gold", 0)
    job.earned_token += values.get("token", 0)


async def _persist(job: CloudBotJob, *, active: Optional[bool] = None) -> None:
    cfg = _settings()
    retention = max(3600, int(cfg.get("cloud_status_retention_seconds", 86400) or 86400))
    status = job.public_status()
    await cloud_store.save_status(job.char_id, status, job.control_token, retention)
    realtime_status = dict(status)
    realtime_status["logs"] = list(status.get("logs") or [])[-4:]
    realtime_status["events"] = []
    await event_bus.publish_status(job.char_id, realtime_status)
    pending = [event for event in job.events if int(event.get("seq") or 0) > job.last_published_event_seq]
    for event in pending:
        await durable_journal.record_event(job, event)
        await event_bus.publish_event(job.char_id, event)
        await notifications.notify_event(job.char_id, event)
        job.last_published_event_seq = max(job.last_published_event_seq, int(event.get("seq") or 0))
    await durable_journal.save_snapshot(job)
    if active is not None and cloud_store.redis_configured():
        spec = {
            "sessionkey": job.sessionkey,
            "char_id": job.char_id,
            "bot_type": job.bot_type,
            "params": job.params,
            "credentials": job.credentials,
        }
        await cloud_store.save_spec(
            job.char_id, spec, job.control_token, active=bool(active)
        )


async def _distributed_stop(job: CloudBotJob) -> bool:
    if await cloud_store.stop_requested(job.char_id):
        job.running = False
        job.set_health("STOPPED", "Stop requested from another process/device")
        job.add_log("Distributed stop request received.", "info")
        return True
    return False


async def _sleep(
    job: CloudBotJob,
    seconds: float,
    state: str,
    detail: str,
) -> bool:
    seconds = max(0.0, float(seconds))
    until = time.time() + seconds
    job.set_health(state, detail, next_action_at=until, delay_seconds=seconds)
    await _persist(job)
    while job.running:
        if await _distributed_stop(job):
            return False
        remaining = until - time.time()
        if remaining <= 0:
            break
        await asyncio.sleep(min(2.0, remaining))
    if job.running:
        job.set_health("RUNNING", "Executing next action")
    return job.running


async def _wait_initial_schedule(job: CloudBotJob) -> bool:
    try:
        scheduled = float(job.params.get("schedule_at") or 0)
    except (TypeError, ValueError):
        scheduled = 0.0
    if scheduled > time.time() + 1:
        when = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(scheduled))
        job.add_log(f"Scheduled start: {when}", "info")
        job.record_event("JOB_SCHEDULED", {"when": scheduled})
        ok = await _sleep(
            job,
            scheduled - time.time(),
            "SCHEDULED",
            f"Waiting until {when}",
        )
        if ok:
            job.record_event("SCHEDULE_STARTED", {"when": time.time()})
            await _persist(job)
        return ok
    return True


async def _auto_relogin(job: CloudBotJob, client: NinjaSageClient) -> bool:
    cfg = _settings()
    if not cfg.get("sage_auto_relogin_enabled", True):
        return False
    username = job.credentials.get("username") or job.credentials.get("user")
    password = job.credentials.get("password") or job.credentials.get("pass")
    if not username or not password:
        job.add_log(
            "Session needs recovery, but no quick-login credentials were handed to the cloud job.",
            "warn",
        )
        return False

    wait_seconds = max(5, int(cfg.get("sage_auto_relogin_wait_seconds", 20) or 20))
    attempts = max(1, min(5, int(cfg.get("sage_auto_relogin_attempts", 3) or 3)))
    retry_seconds = max(1, int(cfg.get("sage_auto_relogin_retry_seconds", 3) or 3))
    job.add_log(
        f"Session appears invalid. Cooling down {wait_seconds}s before automatic relogin.",
        "warn",
    )
    if not await _sleep(job, wait_seconds, "RECOVERING_SESSION", "Cooling down before relogin"):
        return False

    for attempt in range(1, attempts + 1):
        job.set_health("RECOVERING_SESSION", f"Relogin attempt {attempt}/{attempts}")
        job.add_log(f"Automatic relogin attempt {attempt}/{attempts}...", "warn")
        await _persist(job)
        result = await client.login(username, password)
        if isinstance(result, dict) and result.get("status") == "success":
            try:
                recovered_char = int(result.get("char_id") or 0)
            except (TypeError, ValueError):
                recovered_char = 0
            if recovered_char and recovered_char != job.char_id:
                job.add_log(
                    "Automatic relogin returned a different character; recovery aborted for safety.",
                    "error",
                )
                return False

            job.sessionkey = str(result["sessionkey"])
            job.session_generation += 1
            job.relogin_count += 1
            job.session_update = {
                "sessionkey": job.sessionkey,
                "char_id": job.char_id,
                "level": result.get("level"),
                "xp": result.get("xp"),
                "gold": result.get("gold"),
                "tokens": result.get("tokens"),
                "generation": job.session_generation,
            }
            clan = job.runtime.get("clan")
            if clan:
                clan.update_session(job.sessionkey)
            job.add_log(
                "Automatic relogin successful. Cloud bot will continue with the new session.",
                "info",
            )
            job.record_event("SESSION_RECOVERED", {"generation": job.session_generation})
            await _persist(job, active=True)
            return True
        if attempt < attempts:
            if not await _sleep(
                job, retry_seconds, "RECOVERING_SESSION", "Waiting before next relogin attempt"
            ):
                return False

    job.add_log("Automatic relogin failed after all attempts.", "error")
    job.record_event("SESSION_RECOVERY_FAILED", {"attempts": attempts}, "error")
    await _persist(job)
    return False


async def _handle_666(job: CloudBotJob, client: NinjaSageClient) -> float:
    cfg = _settings()
    cooldown = max(10, int(cfg.get("server_error_666_cooldown_seconds", 20) or 20))
    job.add_log(
        f"Server rejection 666 detected. Cooling down {cooldown}s before checking the session.",
        "warn",
    )
    job.adaptive_penalty_seconds = max(job.adaptive_penalty_seconds, 10.0)
    job.record_event("SERVER_REJECTION", {"code": 666, "cooldown": cooldown}, "warn")
    if not await _sleep(job, cooldown, "BACKOFF", "Server rejection 666 cooldown"):
        return 0.0

    validation = await client.validate_session(job.sessionkey, job.char_id)
    if validation is True:
        job.add_log(
            "Session is still valid; treating 666 as a temporary server rejection.",
            "warn",
        )
        return max(30.0, float(cfg.get("rate_limit_backoff_seconds", 30) or 30))
    if validation is None:
        delay = max(30.0, float(cfg.get("rate_limit_backoff_seconds", 30) or 30))
        job.add_log(
            f"Session validation was inconclusive; keeping the current session and backing off {int(delay)}s.",
            "warn",
        )
        return delay

    if await _auto_relogin(job, client):
        job.consecutive_failures = 0
        job.failure_times.clear()
        return max(5.0, _delay(job.bot_type))

    return max(60.0, float(cfg.get("circuit_cooldown_seconds", 120) or 120))



async def _run_recipe_step(job: CloudBotJob, client: NinjaSageClient) -> StepResult:
    normalized = recipes.validate_recipe(job.params.get("recipe"))
    runtime = job.runtime.setdefault("recipe_state", {"index": 0, "cycles": 0, "wait_until": 0.0})
    steps = normalized["steps"]
    index = int(runtime.get("index") or 0)
    if index >= len(steps):
        job.record_event("RECIPE_COMPLETE", {"name": normalized["name"]})
        return StepResult(f"RECIPE_COMPLETE: {normalized['name']}", count_action=False)

    step = steps[index]
    if step["kind"] == "wait":
        job.runtime["recipe_effective_bot_type"] = "wait"
        wait_until = float(runtime.get("wait_until") or 0)
        if wait_until <= 0:
            wait_until = time.time() + int(step["seconds"])
            runtime["wait_until"] = wait_until
            job.record_event("RECIPE_STEP_STARTED", {"step": index + 1, "label": step["label"], "kind": "wait"})
        remaining = max(0.0, wait_until - time.time())
        if remaining > 0:
            return StepResult(f"Recipe wait: {step['label']}", remaining, count_action=False)
        runtime.update({"index": index + 1, "cycles": 0, "wait_until": 0.0})
        job.record_event("RECIPE_STEP_COMPLETE", {"step": index + 1, "label": step["label"]})
        if index + 1 >= len(steps):
            job.record_event("RECIPE_COMPLETE", {"name": normalized["name"]})
            return StepResult(f"RECIPE_COMPLETE: {normalized['name']}", count_action=False)
        return StepResult(f"Recipe step complete: {step['label']}", 1.0, count_action=False)

    bot_type = step["bot_type"]
    step_params = dict(step.get("params") or {})
    if step["mode"] == "level_at_least":
        step_params["max_level"] = int(step["target_level"])
    if int(runtime.get("cycles") or 0) == 0:
        job.record_event("RECIPE_STEP_STARTED", {"step": index + 1, "label": step["label"], "bot_type": bot_type})

    old_type, old_params = job.bot_type, job.params
    job.bot_type, job.params = bot_type, step_params
    job.runtime["recipe_effective_bot_type"] = bot_type
    try:
        result = await _run_step(job, client)
        step_stop = _should_stop(job, result.message)
    finally:
        job.bot_type, job.params = old_type, old_params

    runtime["cycles"] = int(runtime.get("cycles") or 0) + 1
    done = False
    if step["mode"] == "cycles":
        done = runtime["cycles"] >= int(step["cycles"])
    elif step["mode"] == "until_stop":
        if step_stop:
            done = True
        elif runtime["cycles"] >= int(step["max_cycles"]):
            job.record_event(
                "RECIPE_STEP_CAPPED",
                {"step": index + 1, "label": step["label"], "cycles": runtime["cycles"]},
                "warn",
            )
            return StepResult(
                f"RECIPE_ABORTED: {step['label']} reached max_cycles without its stop condition. Last action: {result.message}",
            )
    elif step["mode"] == "level_at_least":
        level = int(await get_or_fetch_char_level(client, job.sessionkey, job.char_id) or 1)
        if level >= int(step["target_level"]):
            done = True
        elif runtime["cycles"] >= int(step["max_cycles"]):
            job.record_event(
                "RECIPE_STEP_CAPPED",
                {
                    "step": index + 1, "label": step["label"],
                    "cycles": runtime["cycles"], "level": level,
                    "target_level": int(step["target_level"]),
                },
                "warn",
            )
            return StepResult(
                f"RECIPE_ABORTED: {step['label']} reached max_cycles at level {level} before target {int(step['target_level'])}. Last action: {result.message}",
            )

    if done:
        job.record_event("RECIPE_STEP_COMPLETE", {"step": index + 1, "label": step["label"], "cycles": runtime["cycles"]})
        runtime.update({"index": index + 1, "cycles": 0, "wait_until": 0.0})
        if index + 1 >= len(steps):
            job.record_event("RECIPE_COMPLETE", {"name": normalized["name"]})
            return StepResult(f"RECIPE_COMPLETE: {normalized['name']}", count_action=False)
    return result


async def _run_step(job: CloudBotJob, client: NinjaSageClient) -> StepResult:
    bt, sk, cid, params = job.bot_type, job.sessionkey, job.char_id, job.params

    if bt == "recipe":
        return await _run_recipe_step(job, client)

    if bt == "auto_level":
        level = int(await get_or_fetch_char_level(client, sk, cid) or 1)
        max_level = params.get("max_level")
        if max_level is not None:
            try:
                if level >= int(max_level):
                    return StepResult(
                        f"TARGET_REACHED: Character is level {level}; max target is {int(max_level)}.",
                        count_action=False,
                    )
            except (TypeError, ValueError):
                pass

        if job.iteration > 0 and job.iteration % 10 == 0:
            try:
                exam = await auto_exam(client, sk, cid)
                if exam and "No exams available" not in str(exam):
                    job.add_log(f"[Exam] {exam}", "info")
            except Exception as exc:
                job.add_log(f"[Exam] check skipped: {exc}", "warn")
        return StepResult(
            str(await run_mission(client, sk, cid, _mission_for_level(level)))
        )

    if bt == "auto_daily":
        return StepResult(str(await auto_daily_event(client, sk, cid)))
    if bt == "auto_hunting":
        result = str(await run_hunting(client, sk, cid, job.current_zone))
        job.current_zone = 1 if job.current_zone >= 5 else job.current_zone + 1
        return StepResult(result)
    if bt == "eudemon":
        return StepResult(str(await auto_eudemon(client, sk, cid)))
    if bt == "circus":
        return StepResult(
            str(
                await run_circus_event(
                    client, sk, cid, boss_type=str(params.get("boss_type", "ringmaster"))
                )
            )
        )
    if bt == "yokai":
        return StepResult(
            str(
                await run_yokai_event(
                    client, sk, cid, boss_type=str(params.get("boss_type", "kitsune"))
                )
            )
        )
    if bt == "yokai_minigame":
        return StepResult(str(await run_yokai_minigame(client, sk, cid)))
    if bt == "shadow_war":
        message = str(await auto_shadow_war(client, sk, cid))
        match = re.match(r"^WAIT_RESOURCE:(\d+(?:\.\d+)?)\|(.*)$", message, flags=re.S)
        if match:
            return StepResult(match.group(2).strip(), float(match.group(1)), count_action=False)
        return StepResult(message)
    if bt == "monster":
        return StepResult(str(await auto_monster_hunt(client, sk, cid)))
    if bt == "mission_s":
        return StepResult(str(await auto_mission_s(client, sk, cid)))
    if bt == "mission":
        mission_id = str(params.get("mission_id", "")).strip()
        if not mission_id:
            raise ValueError("mission_id is required for mission bot")
        return StepResult(str(await run_auto_mission(client, sk, cid, mission_id)))
    if bt == "clan_war":
        clan: Optional[CloudClanWarSession] = job.runtime.get("clan")
        if clan is None:
            clan = CloudClanWarSession(job.sessionkey, cid, _settings())
            job.runtime["clan"] = clan
        message, wait_seconds = await clan.step()
        return StepResult(message, wait_seconds)
    raise ValueError(f"Unsupported bot_type: {bt}")


def _record_failure(job: CloudBotJob) -> bool:
    cfg = _settings()
    now = time.monotonic()
    window = max(30, int(cfg.get("failure_window_seconds", 180) or 180))
    maximum = max(3, int(cfg.get("max_failures_in_window", 6) or 6))
    job.failure_times.append(now)
    while job.failure_times and now - job.failure_times[0] > window:
        job.failure_times.popleft()
    return len(job.failure_times) >= maximum


def _will_execute_action(job: CloudBotJob) -> bool:
    if job.bot_type != "recipe":
        return True
    try:
        normalized = recipes.validate_recipe(job.params.get("recipe"))
        runtime = job.runtime.get("recipe_state") or {}
        index = int(runtime.get("index") or 0)
        if index >= len(normalized["steps"]):
            return False
        return normalized["steps"][index].get("kind") == "bot"
    except Exception:
        return True


def _apply_resume_state(job: CloudBotJob, state: Optional[Dict[str, Any]]) -> None:
    if not isinstance(state, dict):
        return
    numeric = (
        "iteration", "action_count", "success_count", "failure_count",
        "rate_limit_count", "relogin_count", "earned_xp", "earned_gold",
        "earned_token", "current_zone", "session_generation",
    )
    for key in numeric:
        if key in state:
            try:
                setattr(job, key, int(state[key]))
            except (TypeError, ValueError):
                pass
    runtime = state.get("runtime")
    if isinstance(runtime, dict):
        job.runtime.update(runtime)
    for key in ("created_at", "first_action_at", "last_action_at"):
        if state.get(key) is not None:
            try:
                setattr(job, key, float(state[key]))
            except (TypeError, ValueError):
                pass


async def _scheduled_rest(job: CloudBotJob) -> bool:
    active_type = _active_delay_type(job)
    if active_type not in {"auto_level", "mission"}:
        return True
    cfg = _settings()
    every = max(0, int(cfg.get("leveling_rest_every_cycles", 40) or 0))
    duration = max(0, int(cfg.get("leveling_rest_duration_seconds", 60) or 0))
    if every and duration and job.action_count > 0 and job.action_count % every == 0:
        job.add_log(f"Scheduled rest: {duration}s after {job.action_count} actions.", "info")
        job.record_event("STABILITY_REST", {"duration": duration, "action_count": job.action_count})
        return await _sleep(job, duration, "PAUSED", "Periodic stability rest")
    return True


async def _job_loop(job: CloudBotJob) -> None:
    client = NinjaSageClient(persistent=True)
    job.add_log(f"Cloud bot started: {job.bot_type}", "info")
    job.record_event("JOB_STARTED", {"bot_type": job.bot_type})
    await durable_journal.job_started(job)
    await _persist(job, active=True)

    try:
        if not await _wait_initial_schedule(job):
            return

        while job.running:
            if await _distributed_stop(job):
                break

            action_marker = ""
            try:
                job.set_health("RUNNING", "Executing bot action")
                await _persist(job)
                if _will_execute_action(job):
                    fairness_wait = await orchestrator.wait_turn(job.char_id)
                    if fairness_wait > 0:
                        job.record_event("ORCHESTRATOR_WAIT", {"seconds": fairness_wait})
                    action_marker = await durable_journal.action_started(job)
                result = await _run_step(job, client)
                message = result.message
                job.iteration += 1
                count_action = bool(result.count_action)
                now_action = time.time()
                if count_action:
                    job.action_count += 1
                    if job.first_action_at is None:
                        job.first_action_at = now_action
                    job.last_action_at = now_action

                net = client.network_metrics()
                job.network_last_ms = float(net.get("last_ms") or 0)
                job.network_avg_ms = float(net.get("avg_ms") or 0)
                job.network_p95_ms = float(net.get("p95_ms") or 0)

                failed = _is_failed(message)
                if failed:
                    job.consecutive_failures += 1
                    if count_action:
                        job.failure_count += 1
                    job.add_log(message, "warn")
                    circuit = _record_failure(job)
                else:
                    job.consecutive_failures = 0
                    job.rate_limit_level = 0
                    if count_action:
                        job.success_count += 1
                        job.last_success_at = now_action
                    job.add_log(message, "info")
                    if count_action:
                        _capture_rewards(job, message)
                    circuit = False

                if action_marker:
                    await durable_journal.action_finished(
                        job, action_marker, success=not failed, message=message
                    )

                if count_action:
                    job.record_event("ACTION_RESULT", {
                        "bot_type": _active_delay_type(job), "iteration": job.iteration,
                        "action_count": job.action_count,
                        "success": not failed, "latency_ms": job.network_last_ms,
                        "message": str(message)[:240],
                    }, "warn" if failed else "info")

                if "target_reached:" in (message or "").lower():
                    job.record_event("TARGET_REACHED", {"message": str(message)[:240]})

                if _should_stop(job, message):
                    if _repeat_enabled(job, message):
                        repeat = _repeat_seconds(job)
                        job.add_log(
                            f"Run completed. Scheduler will run it again in {repeat // 3600}h.",
                            "info",
                        )
                        job.consecutive_failures = 0
                        job.failure_times.clear()
                        if job.bot_type == "recipe":
                            job.runtime["recipe_state"] = {"index": 0, "cycles": 0, "wait_until": 0.0}
                            job.runtime.pop("recipe_effective_bot_type", None)
                            job.record_event("RECIPE_RESET_FOR_REPEAT", {"repeat_seconds": repeat})
                            await _persist(job, active=True)
                        if not await _sleep(
                            job, repeat, "SCHEDULED", "Waiting for the next scheduled run"
                        ):
                            break
                        continue
                    job.add_log("Normal stop condition reached; cloud bot finished.", "info")
                    break

                if _is_666(message):
                    delay = await _handle_666(job, client)
                    state = "BACKOFF"
                    detail = "Server rejection recovery"
                elif _is_rate_limit(message):
                    cfg = _settings()
                    base = max(15, int(cfg.get("rate_limit_backoff_seconds", 30) or 30))
                    maximum = max(
                        base, int(cfg.get("rate_limit_backoff_max_seconds", 120) or 120)
                    )
                    delay = min(maximum, base * (2 ** min(job.rate_limit_level, 3)))
                    job.rate_limit_level += 1
                    job.rate_limit_count += 1
                    job.add_log(f"Rate limit detected. Backing off for {int(delay)}s.", "warn")
                    job.record_event("RATE_LIMITED", {"delay": delay}, "warn")
                    state = "RATE_LIMITED"
                    detail = "Respecting server rate limit"
                elif circuit:
                    delay = max(
                        30, int(_settings().get("circuit_cooldown_seconds", 120) or 120)
                    )
                    job.add_log(
                        f"Too many failures in a short window. Circuit breaker cooling down {delay}s.",
                        "warn",
                    )
                    job.failure_times.clear()
                    job.record_event("CIRCUIT_BREAKER", {"delay": delay}, "warn")
                    state = "CIRCUIT_BREAKER"
                    detail = "Failure circuit breaker cooldown"
                elif result.wait_seconds is not None:
                    delay = max(1.0, float(result.wait_seconds))
                    state = "WAITING_RESOURCE"
                    detail = "Waiting for game resource/cooldown"
                elif job.consecutive_failures >= 3:
                    delay = max(30.0, _delay(job.bot_type))
                    job.add_log(
                        f"{job.consecutive_failures} consecutive failures; pausing {int(delay)}s before retry.",
                        "warn",
                    )
                    state = "BACKOFF"
                    detail = "Consecutive failure backoff"
                else:
                    delay = _adaptive_delay(job, client, failed=failed)
                    state = "RUNNING"
                    detail = f"Adaptive pacing: {job.pacing_reason}"

                if not await _scheduled_rest(job):
                    break
                if job.running and delay > 0:
                    if not await _sleep(job, delay, state, detail):
                        break

            except ClanRateLimited as exc:
                if action_marker:
                    await durable_journal.action_finished(
                        job, action_marker, success=False, message=str(exc)
                    )
                job.consecutive_failures += 1
                job.failure_count += 1
                job.rate_limit_count += 1
                job.add_log(
                    f"Clan API rate limited. Respecting Retry-After/backoff for {exc.seconds}s.",
                    "warn",
                )
                if not await _sleep(
                    job, exc.seconds, "RATE_LIMITED", "Clan API Retry-After"
                ):
                    break
            except asyncio.CancelledError:
                if action_marker:
                    await durable_journal.action_uncertain(
                        job, action_marker, "Action cancelled before confirmation"
                    )
                raise
            except Exception as exc:
                if action_marker:
                    await durable_journal.action_uncertain(
                        job, action_marker, f"Step exception before confirmation: {exc}"
                    )
                job.consecutive_failures += 1
                job.failure_count += 1
                text = f"Step error: {exc}"
                job.add_log(text, "error")
                if _is_666(text):
                    delay = await _handle_666(job, client)
                else:
                    _record_failure(job)
                    delay = max(15.0, _delay(job.bot_type))
                if not await _sleep(job, delay, "BACKOFF", "Recovering from step error"):
                    break

    except asyncio.CancelledError:
        job.add_log("Cloud bot cancelled by user.", "info")
        job.set_health("STOPPED", "Cancelled by user")
        raise
    finally:
        clan = job.runtime.get("clan")
        if clan is not None:
            try:
                await clan.close()
            except Exception:
                pass
        await client.aclose()
        job.credentials.clear()
        job.running = False
        job.finished_at = time.time()
        if job.health_state not in {"STOPPED", "ERROR"}:
            job.set_health("IDLE", "Cloud bot finished")
        job.add_log("Cloud bot is now idle.", "info")
        job.record_event("JOB_STOPPED", {"state": job.health_state, "iteration": job.iteration})
        await _persist(job, active=False)
        await durable_journal.job_finished(job)
        await cloud_store.clear_stop(job.char_id)


async def start_job(
    sessionkey: str,
    char_id: int,
    bot_type: str,
    params: Optional[Dict[str, Any]] = None,
    credentials: Optional[Dict[str, str]] = None,
    *,
    control_token: Optional[str] = None,
    replace_existing: bool = True,
    resume_state: Optional[Dict[str, Any]] = None,
    recovered_job_id: Optional[str] = None,
) -> Dict[str, Any]:
    bot_type = str(bot_type).strip().lower()
    if bot_type not in SUPPORTED_BOTS:
        raise ValueError(f"Unsupported bot_type: {bot_type}")
    if not sessionkey:
        raise ValueError("sessionkey is required")

    params = dict(params or {})
    if bot_type == "recipe":
        params["recipe"] = recipes.validate_recipe(params.get("recipe"))
    credentials = {
        str(k): str(v)
        for k, v in dict(credentials or {}).items()
        if v is not None
    }

    try:
        scheduled = float(params.get("schedule_at") or 0)
        if scheduled and scheduled < time.time() - 60:
            raise ValueError("schedule_at is already in the past")
    except (TypeError, ValueError) as exc:
        if isinstance(exc, ValueError) and str(exc) == "schedule_at is already in the past":
            raise
        params.pop("schedule_at", None)

    repeat = params.get("repeat_every_seconds")
    if repeat not in (None, "", 0, "0"):
        try:
            repeat_i = int(repeat)
        except (TypeError, ValueError):
            raise ValueError("repeat_every_seconds must be an integer") from None
        minimum = max(
            3600, int(_settings().get("scheduler_min_repeat_seconds", 3600) or 3600)
        )
        if repeat_i < minimum:
            raise ValueError(f"repeat_every_seconds must be at least {minimum}")
        params["repeat_every_seconds"] = repeat_i

    async with _jobs_lock:
        existing = _jobs.get(char_id)
        if existing and existing.running and existing.task:
            try:
                future_schedule = float(params.get("schedule_at") or 0) > time.time() + 1
            except (TypeError, ValueError):
                future_schedule = False
            if future_schedule:
                raise ValueError("Stop the current cloud bot before scheduling another job")
            if not replace_existing:
                raise ValueError("A cloud bot is already running for this character")
            existing.running = False
            existing.task.cancel()
            await asyncio.gather(existing.task, return_exceptions=True)

        token = control_token or secrets.token_urlsafe(32)
        job = CloudBotJob(
            char_id=int(char_id),
            sessionkey=sessionkey,
            bot_type=bot_type,
            params=params,
            control_token=token,
            job_id=str(recovered_job_id or secrets.token_hex(16)),
            credentials=credentials,
        )
        _apply_resume_state(job, resume_state)
        _jobs[int(char_id)] = job
        await cloud_store.clear_stop(int(char_id))
        job.task = asyncio.create_task(
            _job_loop(job), name=f"cloud-bot-{char_id}-{bot_type}"
        )

    result = job.public_status()
    result["control_token"] = token
    return result


def _authorized_job(char_id: int, control_token: str) -> Optional[CloudBotJob]:
    job = _jobs.get(int(char_id))
    if job is None:
        return None
    if not control_token or not secrets.compare_digest(job.control_token, control_token):
        raise PermissionError("Invalid control token")
    return job


async def stop_job(char_id: int, control_token: str) -> Dict[str, Any]:
    async with _jobs_lock:
        job = _authorized_job(char_id, control_token)
        if job is not None:
            if job.running and job.task:
                job.running = False
                job.task.cancel()
                await asyncio.gather(job.task, return_exceptions=True)
            return job.public_status()

    remote = await cloud_store.authorized_status(char_id, control_token)
    if remote is None:
        return {
            "running": False,
            "char_id": char_id,
            "health": {"state": "IDLE", "detail": "No cloud job", "next_action_at": None},
            "logs": [],
        }
    await cloud_store.request_stop(char_id)
    remote["last_message"] = "Stop requested; waiting for worker acknowledgement."
    return remote


async def get_status(char_id: int, control_token: str) -> Dict[str, Any]:
    job = _authorized_job(char_id, control_token)
    if job is not None:
        return job.public_status()

    remote = await cloud_store.authorized_status(char_id, control_token)
    if remote is not None:
        return remote
    return {
        "running": False,
        "char_id": char_id,
        "health": {"state": "IDLE", "detail": "No cloud job", "next_action_at": None},
        "analytics": {},
        "logs": [],
    }



async def engine_metrics() -> Dict[str, Any]:
    jobs = list(_jobs.values())
    states: Dict[str, int] = {}
    for job in jobs:
        states[job.health_state] = states.get(job.health_state, 0) + 1
    return {
        "jobs_total": len(jobs),
        "jobs_running": sum(1 for job in jobs if job.running),
        "states": states,
        "actions": sum(job.action_count for job in jobs),
        "successes": sum(job.success_count for job in jobs),
        "failures": sum(job.failure_count for job in jobs),
        "websocket_subscribers": await event_bus.subscriber_count(),
        "event_bus": await event_bus.stats(),
    }


async def flush_jobs() -> None:
    for job in list(_jobs.values()):
        try:
            await _persist(job, active=job.running)
        except Exception:
            continue


async def recover_persisted_jobs() -> int:
    if not cloud_store.redis_configured() or cloud_store.queue_mode():
        return 0
    recovered = 0
    for spec in await cloud_store.list_active_specs(include_queued=False):
        token = str(spec.pop("control_token", "") or "")
        spec.pop("active", None)
        spec.pop("stored_at", None)
        if not token:
            continue
        char_id = int(spec.get("char_id") or 0)
        if not char_id or char_id in _jobs:
            continue
        try:
            await start_job(
                spec["sessionkey"],
                char_id,
                spec["bot_type"],
                spec.get("params"),
                spec.get("credentials"),
                control_token=token,
                replace_existing=False,
            )
            recovered += 1
        except Exception:
            continue
    return recovered
