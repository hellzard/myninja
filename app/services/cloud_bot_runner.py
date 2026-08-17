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

SUPPORTED_BOTS = {
    'auto_level', 'auto_daily', 'auto_hunting', 'eudemon', 'circus', 'yokai',
    'yokai_minigame', 'shadow_war', 'monster', 'mission_s', 'clan_war', 'mission',
}

BOT_DELAY_KEYS = {
    'auto_level': 'leveling_delay_seconds',
    'auto_daily': 'daily_delay_seconds',
    'auto_hunting': 'hunting_delay_seconds',
    'eudemon': 'eudemon_delay_seconds',
    'circus': 'circus_delay_seconds',
    'yokai': 'yokai_delay_seconds',
    'yokai_minigame': 'yokai_minigame_delay_seconds',
    'shadow_war': 'shadow_war_between_battles_seconds',
    'monster': 'monster_delay_seconds',
    'mission_s': 'mission_s_delay_seconds',
    'mission': 'mission_delay_seconds',
    'clan_war': 'clan_war_battle_delay_seconds',
}


@dataclass
class StepResult:
    message: str
    wait_seconds: Optional[float] = None


@dataclass
class CloudBotJob:
    char_id: int
    sessionkey: str
    bot_type: str
    params: Dict[str, Any]
    control_token: str
    credentials: Dict[str, str] = field(default_factory=dict, repr=False)
    created_at: float = field(default_factory=time.time)
    finished_at: Optional[float] = None
    running: bool = True
    iteration: int = 0
    consecutive_failures: int = 0
    last_message: str = 'Starting...'
    current_zone: int = 1
    log_seq: int = 0
    logs: deque = field(default_factory=lambda: deque(maxlen=200))
    task: Optional[asyncio.Task] = None
    failure_times: deque = field(default_factory=lambda: deque(maxlen=50))
    rate_limit_level: int = 0
    session_generation: int = 0
    session_update: Optional[Dict[str, Any]] = None
    runtime: Dict[str, Any] = field(default_factory=dict, repr=False)

    def add_log(self, message: str, level: str = 'info') -> None:
        now = time.time()
        self.log_seq += 1
        self.last_message = str(message)
        self.logs.append({
            'seq': self.log_seq,
            'ts': now,
            'ts_ms': int(now * 1000),
            'level': level,
            'message': str(message),
        })

    def public_status(self) -> Dict[str, Any]:
        safe_params = {k: v for k, v in self.params.items() if k in {'mission_id', 'boss_type', 'max_level'}}
        return {
            'running': self.running,
            'bot_type': self.bot_type,
            'char_id': self.char_id,
            'params': safe_params,
            'iteration': self.iteration,
            'consecutive_failures': self.consecutive_failures,
            'last_message': self.last_message,
            'created_at': self.created_at,
            'finished_at': self.finished_at,
            'session_generation': self.session_generation,
            'session_update': self.session_update,
            'logs': list(self.logs)[-80:],
        }


_jobs: Dict[int, CloudBotJob] = {}
_jobs_lock = asyncio.Lock()


def _settings() -> dict:
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
        jitter = max(0.0, float(cfg.get('leveling_action_jitter_seconds', 2)))
    except (TypeError, ValueError):
        jitter = 2.0
    return base + random.uniform(0.0, jitter)


def _mission_for_level(level: int) -> str:
    if level >= 80: return 'msn_109'
    if level >= 60: return 'msn_60'
    if level >= 40: return 'msn_42'
    if level >= 20: return 'msn_21'
    if level >= 10: return 'msn_11'
    return 'msn_3'


def _is_failed(message: str) -> bool:
    text = (message or '').lower()
    return any(x in text for x in ('failed', 'error', 'exception', 'rejected'))


def _is_666(message: str) -> bool:
    text = (message or '').lower()
    return bool(re.search(r"(?:error['\" ]*[:=]\s*|error\s+)(?:['\"])?666\b", text)) or "'error': 666" in text


def _is_rate_limit(message: str) -> bool:
    text = (message or '').lower()
    return any(x in text for x in ('rate limit', 'too many requests', 'http 429', 'status 429'))


def _should_stop(job: CloudBotJob, message: str) -> bool:
    text = (message or '').lower()
    if 'target_reached:' in text: return True
    if job.bot_type == 'auto_daily':
        return 'daily missions completed' in text or 'no available daily missions' in text
    if job.bot_type == 'auto_hunting': return 'stopped' in text
    if job.bot_type == 'eudemon': return 'no available eudemon bosses' in text or 'requires level' in text
    if job.bot_type in {'circus', 'yokai'}: return any(w in text for w in ('ticket', 'stopped'))
    if job.bot_type == 'yokai_minigame': return 'ticket' in text
    if job.bot_type == 'monster': return 'energy habis' in text or 'energy monster hunter habis' in text or 'stopped' in text
    if job.bot_type == 'mission': return 'invalid response' in text
    return False


async def _auto_relogin(job: CloudBotJob, client: NinjaSageClient) -> bool:
    cfg = _settings()
    if not cfg.get('sage_auto_relogin_enabled', True):
        return False
    username = job.credentials.get('username') or job.credentials.get('user')
    password = job.credentials.get('password') or job.credentials.get('pass')
    if not username or not password:
        job.add_log('Session needs recovery, but no quick-login credentials were handed to the cloud job.', 'warn')
        return False

    wait_seconds = max(5, int(cfg.get('sage_auto_relogin_wait_seconds', 20) or 20))
    attempts = max(1, min(5, int(cfg.get('sage_auto_relogin_attempts', 3) or 3)))
    retry_seconds = max(1, int(cfg.get('sage_auto_relogin_retry_seconds', 3) or 3))
    job.add_log(f'Session appears invalid. Cooling down {wait_seconds}s before automatic relogin.', 'warn')
    await asyncio.sleep(wait_seconds)

    for attempt in range(1, attempts + 1):
        job.add_log(f'Automatic relogin attempt {attempt}/{attempts}...', 'warn')
        result = await client.login(username, password)
        if isinstance(result, dict) and result.get('status') == 'success':
            try:
                recovered_char = int(result.get('char_id') or 0)
            except (TypeError, ValueError):
                recovered_char = 0
            if recovered_char and recovered_char != job.char_id:
                job.add_log('Automatic relogin returned a different character; recovery aborted for safety.', 'error')
                return False
            job.sessionkey = str(result['sessionkey'])
            job.session_generation += 1
            job.session_update = {
                'sessionkey': job.sessionkey,
                'char_id': job.char_id,
                'level': result.get('level'),
                'xp': result.get('xp'),
                'gold': result.get('gold'),
                'tokens': result.get('tokens'),
                'generation': job.session_generation,
            }
            clan = job.runtime.get('clan')
            if clan:
                clan.update_session(job.sessionkey)
            job.add_log('Automatic relogin successful. Cloud bot will continue with the new session.', 'info')
            return True
        if attempt < attempts:
            await asyncio.sleep(retry_seconds)

    job.add_log('Automatic relogin failed after all attempts.', 'error')
    return False


async def _handle_666(job: CloudBotJob, client: NinjaSageClient) -> float:
    cfg = _settings()
    cooldown = max(10, int(cfg.get('server_error_666_cooldown_seconds', 20) or 20))
    job.add_log(f'Server rejection 666 detected. Cooling down {cooldown}s before checking the session.', 'warn')
    await asyncio.sleep(cooldown)

    if await client.validate_session(job.sessionkey, job.char_id):
        job.add_log('Session is still valid; treating 666 as a temporary server rejection.', 'warn')
        return max(30.0, float(cfg.get('rate_limit_backoff_seconds', 30) or 30))

    if await _auto_relogin(job, client):
        job.consecutive_failures = 0
        job.failure_times.clear()
        return max(5.0, _delay(job.bot_type))

    return max(60.0, float(cfg.get('circuit_cooldown_seconds', 120) or 120))


async def _run_step(job: CloudBotJob, client: NinjaSageClient) -> StepResult:
    bt, sk, cid, params = job.bot_type, job.sessionkey, job.char_id, job.params

    if bt == 'auto_level':
        level = int(await get_or_fetch_char_level(client, sk, cid) or 1)
        max_level = params.get('max_level')
        if max_level is not None:
            try:
                if level >= int(max_level):
                    return StepResult(f'TARGET_REACHED: Character is level {level}; max target is {int(max_level)}.')
            except (TypeError, ValueError):
                pass
        if job.iteration % 10 == 0:
            try:
                exam = await auto_exam(client, sk, cid)
                if exam and 'No exams available' not in str(exam):
                    job.add_log(f'[Exam] {exam}', 'info')
            except Exception as exc:
                job.add_log(f'[Exam] check skipped: {exc}', 'warn')
        return StepResult(str(await run_mission(client, sk, cid, _mission_for_level(level))))

    if bt == 'auto_daily': return StepResult(str(await auto_daily_event(client, sk, cid)))
    if bt == 'auto_hunting':
        result = str(await run_hunting(client, sk, cid, job.current_zone))
        job.current_zone = 1 if job.current_zone >= 5 else job.current_zone + 1
        return StepResult(result)
    if bt == 'eudemon': return StepResult(str(await auto_eudemon(client, sk, cid)))
    if bt == 'circus': return StepResult(str(await run_circus_event(client, sk, cid, boss_type=str(params.get('boss_type', 'ringmaster')))))
    if bt == 'yokai': return StepResult(str(await run_yokai_event(client, sk, cid, boss_type=str(params.get('boss_type', 'kitsune')))))
    if bt == 'yokai_minigame': return StepResult(str(await run_yokai_minigame(client, sk, cid)))
    if bt == 'shadow_war':
        message = str(await auto_shadow_war(client, sk, cid))
        match = re.match(r'^WAIT_RESOURCE:(\d+(?:\.\d+)?)\|(.*)$', message, flags=re.S)
        if match:
            return StepResult(match.group(2).strip(), float(match.group(1)))
        return StepResult(message)
    if bt == 'monster': return StepResult(str(await auto_monster_hunt(client, sk, cid)))
    if bt == 'mission_s': return StepResult(str(await auto_mission_s(client, sk, cid)))
    if bt == 'mission':
        mission_id = str(params.get('mission_id', '')).strip()
        if not mission_id: raise ValueError('mission_id is required for mission bot')
        return StepResult(str(await run_auto_mission(client, sk, cid, mission_id)))
    if bt == 'clan_war':
        clan: Optional[CloudClanWarSession] = job.runtime.get('clan')
        if clan is None:
            clan = CloudClanWarSession(job.sessionkey, cid, _settings())
            job.runtime['clan'] = clan
        message, wait_seconds = await clan.step()
        return StepResult(message, wait_seconds)
    raise ValueError(f'Unsupported bot_type: {bt}')


def _record_failure(job: CloudBotJob) -> bool:
    cfg = _settings()
    now = time.monotonic()
    window = max(30, int(cfg.get('failure_window_seconds', 180) or 180))
    maximum = max(3, int(cfg.get('max_failures_in_window', 6) or 6))
    job.failure_times.append(now)
    while job.failure_times and now - job.failure_times[0] > window:
        job.failure_times.popleft()
    return len(job.failure_times) >= maximum


async def _maybe_scheduled_rest(job: CloudBotJob) -> None:
    if job.bot_type not in {'auto_level', 'mission'}:
        return
    cfg = _settings()
    every = max(0, int(cfg.get('leveling_rest_every_cycles', 40) or 0))
    duration = max(0, int(cfg.get('leveling_rest_duration_seconds', 60) or 0))
    if every and duration and job.iteration > 0 and job.iteration % every == 0:
        job.add_log(f'Scheduled rest: {duration}s after {job.iteration} cycles.', 'info')
        await asyncio.sleep(duration)


async def _job_loop(job: CloudBotJob) -> None:
    client = NinjaSageClient(persistent=True)
    job.add_log(f'Cloud bot started: {job.bot_type}', 'info')
    try:
        while job.running:
            try:
                result = await _run_step(job, client)
                message = result.message
                job.iteration += 1

                if _is_failed(message):
                    job.consecutive_failures += 1
                    job.add_log(message, 'warn')
                    circuit = _record_failure(job)
                else:
                    job.consecutive_failures = 0
                    job.rate_limit_level = 0
                    job.add_log(message, 'info')
                    circuit = False

                if _should_stop(job, message):
                    job.add_log('Normal stop condition reached; cloud bot finished.', 'info')
                    break

                if _is_666(message):
                    delay = await _handle_666(job, client)
                elif _is_rate_limit(message):
                    cfg = _settings()
                    base = max(15, int(cfg.get('rate_limit_backoff_seconds', 30) or 30))
                    maximum = max(base, int(cfg.get('rate_limit_backoff_max_seconds', 120) or 120))
                    delay = min(maximum, base * (2 ** min(job.rate_limit_level, 3)))
                    job.rate_limit_level += 1
                    job.add_log(f'Rate limit detected. Backing off for {delay}s.', 'warn')
                elif circuit:
                    delay = max(30, int(_settings().get('circuit_cooldown_seconds', 120) or 120))
                    job.add_log(f'Too many failures in a short window. Circuit breaker cooling down {delay}s instead of killing the job.', 'warn')
                    job.failure_times.clear()
                elif result.wait_seconds is not None:
                    delay = max(1.0, float(result.wait_seconds))
                elif job.consecutive_failures >= 3:
                    delay = max(30.0, _delay(job.bot_type))
                    job.add_log(f'{job.consecutive_failures} consecutive failures; pausing {int(delay)}s before retry.', 'warn')
                else:
                    delay = _delay(job.bot_type)

                await _maybe_scheduled_rest(job)
                if job.running:
                    await asyncio.sleep(delay)

            except ClanRateLimited as exc:
                job.consecutive_failures += 1
                job.add_log(f'Clan API rate limited. Respecting Retry-After/backoff for {exc.seconds}s.', 'warn')
                await asyncio.sleep(exc.seconds)
            except asyncio.CancelledError:
                raise
            except Exception as exc:
                job.consecutive_failures += 1
                text = f'Step error: {exc}'
                job.add_log(text, 'error')
                if _is_666(text):
                    await asyncio.sleep(await _handle_666(job, client))
                else:
                    _record_failure(job)
                    await asyncio.sleep(max(15.0, _delay(job.bot_type)))

    except asyncio.CancelledError:
        job.add_log('Cloud bot cancelled by user.', 'info')
        raise
    finally:
        clan = job.runtime.get('clan')
        if clan is not None:
            try: await clan.close()
            except Exception: pass
        await client.aclose()
        job.credentials.clear()
        job.running = False
        job.finished_at = time.time()
        job.add_log('Cloud bot is now idle.', 'info')


async def start_job(sessionkey: str, char_id: int, bot_type: str, params: Optional[Dict[str, Any]] = None, credentials: Optional[Dict[str, str]] = None) -> Dict[str, Any]:
    bot_type = str(bot_type).strip().lower()
    if bot_type not in SUPPORTED_BOTS: raise ValueError(f'Unsupported bot_type: {bot_type}')
    if not sessionkey: raise ValueError('sessionkey is required')
    params = dict(params or {})
    credentials = {str(k): str(v) for k, v in dict(credentials or {}).items() if v is not None}

    async with _jobs_lock:
        existing = _jobs.get(char_id)
        if existing and existing.running and existing.task:
            existing.running = False
            existing.task.cancel()
            await asyncio.gather(existing.task, return_exceptions=True)
        token = secrets.token_urlsafe(32)
        job = CloudBotJob(char_id=char_id, sessionkey=sessionkey, bot_type=bot_type, params=params, control_token=token, credentials=credentials)
        _jobs[char_id] = job
        job.task = asyncio.create_task(_job_loop(job), name=f'cloud-bot-{char_id}-{bot_type}')

    result = job.public_status()
    result['control_token'] = token
    return result


def _authorized_job(char_id: int, control_token: str) -> Optional[CloudBotJob]:
    job = _jobs.get(char_id)
    if job is None: return None
    if not control_token or not secrets.compare_digest(job.control_token, control_token):
        raise PermissionError('Invalid control token')
    return job


async def stop_job(char_id: int, control_token: str) -> Dict[str, Any]:
    async with _jobs_lock:
        job = _authorized_job(char_id, control_token)
        if job is None: return {'running': False, 'char_id': char_id, 'status': 'idle', 'logs': []}
        if job.running and job.task:
            job.running = False
            job.task.cancel()
            await asyncio.gather(job.task, return_exceptions=True)
        return job.public_status()


async def get_status(char_id: int, control_token: str) -> Dict[str, Any]:
    job = _authorized_job(char_id, control_token)
    if job is None: return {'running': False, 'char_id': char_id, 'status': 'idle', 'logs': []}
    return job.public_status()
