from __future__ import annotations

import re
from typing import Any, Dict, List

ALLOWED_BOTS = {
    "auto_level", "auto_daily", "auto_hunting", "eudemon", "circus", "yokai",
    "yokai_minigame", "shadow_war", "monster", "mission_s", "clan_war", "mission",
}
ALLOWED_MODES = {"cycles", "until_stop", "level_at_least"}
LEVEL_TARGET_BOTS = {"auto_level"}
MAX_STEPS = 20
MAX_CYCLES = 5000
MAX_TOTAL_CYCLES = 5000
MISSION_ID_RE = re.compile(r"^[A-Za-z0-9_.:-]{1,80}$")


def _safe_params(raw: Any) -> Dict[str, Any]:
    if not isinstance(raw, dict):
        return {}
    result: Dict[str, Any] = {}
    if raw.get("mission_id") is not None:
        result["mission_id"] = str(raw["mission_id"]).strip()[:80]
    if raw.get("boss_type") is not None:
        result["boss_type"] = str(raw["boss_type"]).strip()[:80]
    if raw.get("max_level") is not None:
        try:
            result["max_level"] = int(raw["max_level"])
        except (TypeError, ValueError):
            pass
    return result


def validate_recipe(recipe: Any) -> Dict[str, Any]:
    if not isinstance(recipe, dict):
        raise ValueError("recipe must be an object")
    name = str(recipe.get("name") or "Automation Recipe").strip()[:80] or "Automation Recipe"
    raw_steps = recipe.get("steps")
    if not isinstance(raw_steps, list) or not raw_steps:
        raise ValueError("recipe.steps must contain at least one step")
    if len(raw_steps) > MAX_STEPS:
        raise ValueError(f"recipe supports at most {MAX_STEPS} steps")

    steps: List[Dict[str, Any]] = []
    cycle_budget = 0
    for index, raw in enumerate(raw_steps, start=1):
        if not isinstance(raw, dict):
            raise ValueError(f"recipe step {index} must be an object")

        kind = str(raw.get("kind") or "bot").lower()
        if kind == "wait":
            seconds = int(raw.get("seconds") or 0)
            if seconds < 5 or seconds > 86400:
                raise ValueError(f"recipe wait step {index} must be 5..86400 seconds")
            steps.append({
                "kind": "wait",
                "seconds": seconds,
                "label": str(raw.get("label") or "Wait").strip()[:80] or "Wait",
            })
            continue
        if kind != "bot":
            raise ValueError(f"unsupported recipe step kind: {kind}")

        bot_type = str(raw.get("bot_type") or "").strip().lower()
        if bot_type not in ALLOWED_BOTS:
            raise ValueError(f"unsupported recipe bot_type at step {index}: {bot_type}")

        mode = str(raw.get("mode") or "cycles").lower()
        if mode not in ALLOWED_MODES:
            raise ValueError(f"unsupported recipe mode at step {index}: {mode}")
        if mode == "level_at_least" and bot_type not in LEVEL_TARGET_BOTS:
            raise ValueError(f"level_at_least is only supported by Auto Leveling (step {index})")

        params = _safe_params(raw.get("params"))
        if bot_type == "mission":
            mission_id = str(params.get("mission_id") or "").strip()
            if not mission_id:
                raise ValueError(f"mission_id is required for Mission Farmer at step {index}")
            if not MISSION_ID_RE.fullmatch(mission_id):
                raise ValueError(f"mission_id at step {index} contains unsupported characters")

        cycles = int(raw.get("cycles") or 1)
        if mode == "cycles" and not (1 <= cycles <= MAX_CYCLES):
            raise ValueError(f"recipe cycles at step {index} must be 1..{MAX_CYCLES}")

        target_level = raw.get("target_level")
        if mode == "level_at_least":
            target_level = int(target_level or 0)
            if target_level < 2 or target_level > 200:
                raise ValueError(f"target_level at step {index} must be 2..200")

        default_cap = cycles if mode == "cycles" else 500
        max_cycles = max(1, min(MAX_CYCLES, int(raw.get("max_cycles") or default_cap)))
        cycle_budget += cycles if mode == "cycles" else max_cycles
        if cycle_budget > MAX_TOTAL_CYCLES:
            raise ValueError(
                f"recipe total cycle budget exceeds {MAX_TOTAL_CYCLES}; split it into smaller scheduled recipes"
            )

        steps.append({
            "kind": "bot",
            "bot_type": bot_type,
            "mode": mode,
            "cycles": cycles if mode == "cycles" else 0,
            "target_level": target_level if mode == "level_at_least" else None,
            "max_cycles": max_cycles,
            "params": params,
            "label": str(raw.get("label") or bot_type.replace("_", " ").title()).strip()[:80],
        })

    return {"name": name, "steps": steps, "version": 2, "cycle_budget": cycle_budget}


def dry_run(recipe: Any, settings: Dict[str, Any]) -> Dict[str, Any]:
    normalized = validate_recipe(recipe)
    delays = {
        "auto_level": settings.get("leveling_delay_seconds", 5),
        "auto_daily": settings.get("daily_delay_seconds", 8),
        "auto_hunting": settings.get("hunting_delay_seconds", 8),
        "eudemon": settings.get("eudemon_delay_seconds", 10),
        "circus": settings.get("circus_delay_seconds", 10),
        "yokai": settings.get("yokai_delay_seconds", 10),
        "yokai_minigame": settings.get("yokai_minigame_delay_seconds", 8),
        "shadow_war": settings.get("shadow_war_between_battles_seconds", 30),
        "monster": settings.get("monster_delay_seconds", 8),
        "mission_s": settings.get("mission_s_delay_seconds", 8),
        "clan_war": settings.get("clan_war_battle_delay_seconds", 8),
        "mission": settings.get("mission_delay_seconds", 10),
    }
    internal_wait = {
        "auto_level": settings.get("sage_battle_wait_seconds", 5),
        "mission": settings.get("sage_battle_wait_seconds", 5),
        "shadow_war": settings.get("shadow_war_battle_wait_seconds", 20),
    }

    seconds = 0
    condition_driven = False
    outline = []
    for idx, step in enumerate(normalized["steps"], start=1):
        if step["kind"] == "wait":
            estimate = int(step["seconds"])
            seconds += estimate
            outline.append({"index": idx, "label": step["label"], "estimate_seconds": estimate, "bounded": True, "mode": "wait"})
            continue

        base = max(3, int(delays.get(step["bot_type"], 10) or 10))
        per_cycle = base + max(0, int(internal_wait.get(step["bot_type"], 0) or 0))
        if step["mode"] == "cycles":
            estimate = per_cycle * step["cycles"]
            bounded = True
        else:
            estimate = per_cycle * step["max_cycles"]
            bounded = False
            condition_driven = True
        seconds += estimate
        outline.append({
            "index": idx,
            "label": step["label"],
            "estimate_seconds": estimate,
            "bounded": bounded,
            "mode": step["mode"],
            "max_cycles": step.get("max_cycles"),
        })

    warnings = [
        "Estimate includes configured cycle delays and known battle waits. Resource waits, rate-limit backoff, exams, network latency and relogin can extend runtime."
    ]
    if condition_driven:
        warnings.append(
            "Condition-driven steps use max_cycles only as a safety-cap estimate. If the condition is not reached by the cap, v5.1 aborts that recipe step instead of reporting false success."
        )
    return {
        "recipe": normalized,
        "estimate_seconds": seconds,
        "exact": not condition_driven,
        "outline": outline,
        "warnings": warnings,
        "cycle_budget": normalized["cycle_budget"],
    }
