import json
import os
from typing import Dict, Any

SETTINGS_FILE = os.path.join(os.path.dirname(__file__), "..", "..", "sage_settings.json")

DEFAULT_SETTINGS = {
    "leveling_delay_seconds": 10,
    "leveling_cycle_cooldown_seconds": 5,
    "leveling_rest_every_cycles": 40,
    "leveling_rest_duration_seconds": 60,
    "clan_war_auto_spend_token": False,
    "clan_war_stamina_refill_source": "auto",
    "sage_shadow_war_wait_minutes": 30,
    "sage_exam_start_delay_seconds": 8,
    "sage_special_jounin_class_skill": "skill_4001"
}

def load_settings() -> Dict[str, Any]:
    if not os.path.exists(SETTINGS_FILE):
        return DEFAULT_SETTINGS.copy()
    try:
        with open(SETTINGS_FILE, "r") as f:
            data = json.load(f)
            merged = DEFAULT_SETTINGS.copy()
            merged.update(data)
            return merged
    except:
        return DEFAULT_SETTINGS.copy()

def save_settings(settings: Dict[str, Any]) -> bool:
    try:
        merged = load_settings()
        merged.update(settings)
        with open(SETTINGS_FILE, "w") as f:
            json.dump(merged, f, indent=4)
        return True
    except:
        return False
