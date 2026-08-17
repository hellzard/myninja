from __future__ import annotations

from typing import Any, Dict, List

MAX_RUNTIME_SECONDS = 12 * 3600
MIN_RUNTIME_SECONDS = 5 * 60


def plan(goals: Any) -> Dict[str, Any]:
    if not isinstance(goals, dict):
        raise ValueError("goals must be an object")

    run_daily = bool(goals.get("run_daily", False))
    include_shadow = bool(goals.get("include_shadow_war", False))
    target_level = goals.get("target_level")
    runtime = int(goals.get("max_runtime_seconds") or 4 * 3600)

    if runtime < MIN_RUNTIME_SECONDS or runtime > MAX_RUNTIME_SECONDS:
        raise ValueError(
            f"max_runtime_seconds must be {MIN_RUNTIME_SECONDS}..{MAX_RUNTIME_SECONDS}"
        )

    if bool(goals.get("allow_premium_resources", False)):
        raise ValueError(
            "Autonomous mode does not allow automatic premium-resource spending."
        )

    if target_level not in (None, "", 0, "0"):
        target_level = int(target_level)
        if target_level < 2 or target_level > 200:
            raise ValueError("target_level must be 2..200")
    else:
        target_level = None

    steps: List[Dict[str, Any]] = []
    reasons: List[str] = []

    if run_daily:
        steps.append({
            "kind": "bot",
            "bot_type": "auto_daily",
            "mode": "until_stop",
            "max_cycles": 100,
            "params": {},
            "label": "Complete Daily",
        })
        reasons.append("Daily is ordered before long-running leveling work.")

    if target_level:
        steps.append({
            "kind": "bot",
            "bot_type": "auto_level",
            "mode": "level_at_least",
            "target_level": target_level,
            "max_cycles": min(4500, max(100, runtime // 10)),
            "params": {},
            "label": f"Level to {target_level}",
        })
        reasons.append("Leveling uses the configured 5s+ adaptive pacing floor and target stop.")

    if include_shadow:
        steps.append({
            "kind": "bot",
            "bot_type": "shadow_war",
            "mode": "cycles",
            "cycles": 1,
            "params": {},
            "label": "Shadow War check",
        })
        reasons.append(
            "Shadow War remains subject to the existing no-premium/default resource policy."
        )

    if not steps:
        raise ValueError("Choose at least one automation goal")

    recipe = {
        "name": str(goals.get("name") or "Autonomous Plan")[:80],
        "steps": steps,
        "version": 2,
    }

    return {
        "recipe": recipe,
        "policy": {
            "max_runtime_seconds": runtime,
            "premium_resources": "forbidden",
            "adaptive_pacing": "required",
            "human_confirmation_for_uncertain_recovery": True,
        },
        "reasons": reasons,
        "requires_confirmation": True,
    }


def validate_execution(plan_obj: Any) -> Dict[str, Any]:
    if not isinstance(plan_obj, dict):
        raise ValueError("plan must be an object")
    policy = plan_obj.get("policy") if isinstance(plan_obj.get("policy"), dict) else {}
    if policy.get("premium_resources") != "forbidden":
        raise ValueError("policy must forbid premium-resource automation")
    if not plan_obj.get("requires_confirmation"):
        raise ValueError("autonomous plan must require explicit confirmation")
    recipe = plan_obj.get("recipe")
    if not isinstance(recipe, dict) or not recipe.get("steps"):
        raise ValueError("plan recipe is missing")
    return plan_obj
