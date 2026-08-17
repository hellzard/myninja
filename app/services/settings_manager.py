import json
import os
from typing import Any, Dict

SETTINGS_FILE = os.path.join(os.path.dirname(__file__), "..", "..", "sage_settings.json")
HISTORY_FILE = os.path.join(os.path.dirname(__file__), "..", "..", "sage_settings_history.json")

DEFAULT_SETTINGS: Dict[str, Any] = {
    "leveling_delay_seconds": 5,
    "leveling_cycle_cooldown_seconds": 5,
    "leveling_rest_every_cycles": 40,
    "leveling_rest_duration_seconds": 60,
    "leveling_action_jitter_seconds": 0,
    "sage_battle_wait_seconds": 5,
    "amf_min_request_interval_seconds": 1.25,
    "sage_auto_relogin_enabled": True,
    "sage_auto_relogin_wait_seconds": 20,
    "sage_auto_relogin_attempts": 3,
    "sage_auto_relogin_retry_seconds": 3,
    "server_error_666_cooldown_seconds": 20,
    "rate_limit_backoff_seconds": 30,
    "rate_limit_backoff_max_seconds": 120,
    "failure_window_seconds": 180,
    "max_failures_in_window": 6,
    "circuit_cooldown_seconds": 120,
    "stats_refresh_seconds": 45,
    "daily_delay_seconds": 8,
    "hunting_delay_seconds": 8,
    "eudemon_delay_seconds": 10,
    "circus_delay_seconds": 10,
    "yokai_delay_seconds": 10,
    "yokai_minigame_delay_seconds": 8,
    "monster_delay_seconds": 8,
    "mission_s_delay_seconds": 8,
    "mission_delay_seconds": 10,
    "shadow_war_battle_wait_seconds": 20,
    "shadow_war_between_battles_seconds": 30,
    "sage_shadow_war_empty_resource_mode": "wait",
    "sage_shadow_war_wait_minutes": 30,
    "clan_war_battle_delay_seconds": 8,
    "clan_war_refresh_delay_seconds": 30,
    "clan_war_buy_stamina_delay_seconds": 3,
    "clan_war_auto_spend_token": False,
    "clan_war_stamina_refill_source": "auto",
    "sage_exam_start_delay_seconds": 8,
    "sage_special_jounin_class_skill": "skill_4001",
    "cloud_status_retention_seconds": 86400,
    "scheduler_min_repeat_seconds": 3600,
    "adaptive_pacing_enabled": True,
    "adaptive_latency_soft_ms": 2500,
    "adaptive_latency_hard_ms": 5000,
    "adaptive_max_penalty_seconds": 30,
    "realtime_fallback_poll_seconds": 30,
    "flight_recorder_max_events": 5000,
    "recipe_max_steps": 20,
}


def _clean(data: Dict[str, Any]) -> Dict[str, Any]:
    return {key: value for key, value in data.items() if key in DEFAULT_SETTINGS}


def load_settings() -> Dict[str, Any]:
    merged = DEFAULT_SETTINGS.copy()
    if not os.path.exists(SETTINGS_FILE):
        return merged
    try:
        with open(SETTINGS_FILE, "r", encoding="utf-8") as handle:
            data = json.load(handle)
        if isinstance(data, dict):
            merged.update(_clean(data))
    except (OSError, ValueError, TypeError):
        pass
    return merged


def save_settings(settings: Dict[str, Any]) -> bool:
    if not isinstance(settings, dict):
        return False
    try:
        if os.path.exists(SETTINGS_FILE):
            snapshot_settings("before-save")
        merged = load_settings()
        merged.update(_clean(settings))
        with open(SETTINGS_FILE, "w", encoding="utf-8") as handle:
            json.dump(merged, handle, indent=2, ensure_ascii=False)
        return True
    except OSError:
        return False



def _read_history() -> list:
    try:
        with open(HISTORY_FILE, "r", encoding="utf-8") as handle:
            value = json.load(handle)
        return value if isinstance(value, list) else []
    except (OSError, ValueError, TypeError):
        return []


def _write_history(items: list) -> None:
    try:
        with open(HISTORY_FILE, "w", encoding="utf-8") as handle:
            json.dump(items[-10:], handle, indent=2, ensure_ascii=False)
    except OSError:
        pass


def snapshot_settings(label: str = "manual") -> Dict[str, Any]:
    import time
    item = {"id": str(int(time.time() * 1000)), "ts": time.time(), "label": str(label)[:80], "settings": load_settings()}
    history = _read_history()
    history.append(item)
    _write_history(history)
    return {k: v for k, v in item.items() if k != "settings"}


def list_setting_snapshots() -> list:
    return [{k: v for k, v in item.items() if k != "settings"} for item in reversed(_read_history())]


def restore_setting_snapshot(snapshot_id: str) -> bool:
    for item in _read_history():
        if str(item.get("id")) == str(snapshot_id) and isinstance(item.get("settings"), dict):
            try:
                with open(SETTINGS_FILE, "w", encoding="utf-8") as handle:
                    json.dump({**DEFAULT_SETTINGS, **_clean(item["settings"])}, handle, indent=2, ensure_ascii=False)
                return True
            except OSError:
                return False
    return False
