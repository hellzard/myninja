from __future__ import annotations

from typing import Any, Dict, List

ALLOWED_BOTS = {
    "auto_level", "auto_daily", "auto_hunting", "eudemon", "circus", "yokai",
    "yokai_minigame", "shadow_war", "monster", "mission_s", "clan_war", "mission",
}
ALLOWED_MODES = {"cycles", "until_stop", "level_at_least"}
MAX_STEPS = 20
MAX_CYCLES = 5000


def _safe_params(raw: Any) -> Dict[str, Any]:
    if not isinstance(raw, dict):
        return {}
    allowed = {"mission_id", "boss_type", "max_level"}
    return {str(k): v for k, v in raw.items() if k in allowed}


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
    for index, raw in enumerate(raw_steps, start=1):
        if not isinstance(raw, dict):
            raise ValueError(f"recipe step {index} must be an object")
        kind = str(raw.get("kind") or "bot").lower()
        if kind == "wait":
            seconds = int(raw.get("seconds") or 0)
            if seconds < 5 or seconds > 86400:
                raise ValueError(f"recipe wait step {index} must be 5..86400 seconds")
            steps.append({"kind": "wait", "seconds": seconds, "label": str(raw.get("label") or "Wait")[:80]})
            continue
        if kind != "bot":
            raise ValueError(f"unsupported recipe step kind: {kind}")

        bot_type = str(raw.get("bot_type") or "").strip().lower()
        if bot_type not in ALLOWED_BOTS:
            raise ValueError(f"unsupported recipe bot_type at step {index}: {bot_type}")
        mode = str(raw.get("mode") or "cycles").lower()
        if mode not in ALLOWED_MODES:
            raise ValueError(f"unsupported recipe mode at step {index}: {mode}")
        cycles = int(raw.get("cycles") or 1)
        if mode == "cycles" and not (1 <= cycles <= MAX_CYCLES):
            raise ValueError(f"recipe cycles at step {index} must be 1..{MAX_CYCLES}")
        target_level = raw.get("target_level")
        if mode == "level_at_least":
            target_level = int(target_level or 0)
            if target_level < 2 or target_level > 200:
                raise ValueError(f"target_level at step {index} must be 2..200")

        steps.append({
            "kind": "bot",
            "bot_type": bot_type,
            "mode": mode,
            "cycles": cycles if mode == "cycles" else 0,
            "target_level": target_level if mode == "level_at_least" else None,
            "max_cycles": max(1, min(MAX_CYCLES, int(raw.get("max_cycles") or (cycles if mode == "cycles" else 500)))),
            "params": _safe_params(raw.get("params")),
            "label": str(raw.get("label") or bot_type.replace("_", " ").title())[:80],
        })
    return {"name": name, "steps": steps, "version": 1}


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
    seconds = 0
    unknown = False
    outline = []
    for idx, step in enumerate(normalized["steps"], start=1):
        if step["kind"] == "wait":
            seconds += step["seconds"]
            outline.append({"index": idx, "label": step["label"], "estimate_seconds": step["seconds"], "bounded": True})
            continue
        base = max(3, int(delays.get(step["bot_type"], 10) or 10))
        if step["mode"] == "cycles":
            estimate = base * step["cycles"]
            seconds += estimate
            bounded = True
        else:
            estimate = base * step["max_cycles"]
            seconds += estimate
            bounded = False
            unknown = True
        outline.append({"index": idx, "label": step["label"], "estimate_seconds": estimate, "bounded": bounded})
    warnings = [
        "Estimates use configured base delays; battle waits, resource waits, rate-limit backoff, exams and relogin can extend runtime."
    ]
    if unknown:
        warnings.append("At least one condition-driven step has no exact completion time; its max_cycles cap is used for the upper estimate.")
    return {"recipe": normalized, "estimate_seconds": seconds, "exact": not unknown, "outline": outline, "warnings": warnings}
