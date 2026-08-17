import pytest

from app.services.policy_engine import plan, validate_execution


def test_policy_requires_goal():
    with pytest.raises(ValueError):
        plan({"run_daily": False, "target_level": None, "include_shadow_war": False})


def test_policy_forbids_premium_resources():
    with pytest.raises(ValueError):
        plan({"run_daily": True, "allow_premium_resources": True})


def test_policy_builds_confirmed_normal_recipe():
    result = plan({
        "run_daily": True,
        "target_level": 80,
        "include_shadow_war": True,
        "max_runtime_seconds": 4 * 3600,
        "allow_premium_resources": False,
    })
    assert result["requires_confirmation"] is True
    assert result["policy"]["premium_resources"] == "forbidden"
    bots = [x.get("bot_type") for x in result["recipe"]["steps"] if x.get("kind") == "bot"]
    assert bots == ["auto_daily", "auto_level", "shadow_war"]
    assert validate_execution(result)["recipe"]["steps"]
