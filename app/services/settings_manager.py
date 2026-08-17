import json
import os
from typing import Any, Dict

SETTINGS_FILE = os.path.join(os.path.dirname(__file__), "..", "..", "sage_settings.json")

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
        merged = load_settings()
        merged.update(_clean(settings))
        with open(SETTINGS_FILE, "w", encoding="utf-8") as handle:
            json.dump(merged, handle, indent=2, ensure_ascii=False)
        return True
    except OSError:
        return False
