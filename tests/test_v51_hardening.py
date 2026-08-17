import asyncio
import time

import pytest

from app.services import event_bus
from app.services.cloud_bot_runner import CloudBotJob, _capture_rewards
from app.services.recipes import dry_run, validate_recipe
from app.services.settings_manager import DEFAULT_SETTINGS


def test_recipe_level_target_only_auto_level():
    with pytest.raises(ValueError):
        validate_recipe({
            "steps": [{
                "kind": "bot", "bot_type": "auto_daily",
                "mode": "level_at_least", "target_level": 80,
            }]
        })


def test_recipe_mission_requires_id():
    with pytest.raises(ValueError):
        validate_recipe({
            "steps": [{"kind": "bot", "bot_type": "mission", "mode": "cycles", "cycles": 1}]
        })


def test_recipe_total_budget_is_bounded():
    with pytest.raises(ValueError):
        validate_recipe({
            "steps": [
                {"kind": "bot", "bot_type": "auto_level", "mode": "cycles", "cycles": 3000},
                {"kind": "bot", "bot_type": "auto_level", "mode": "cycles", "cycles": 3000},
            ]
        })


def test_dry_run_includes_known_battle_wait():
    result = dry_run(
        {"steps": [{"kind": "bot", "bot_type": "auto_level", "mode": "cycles", "cycles": 2}]},
        DEFAULT_SETTINGS,
    )
    assert result["estimate_seconds"] >= 20
    assert result["cycle_budget"] == 2


def test_reward_parser_does_not_count_totals_as_new_rewards():
    job = CloudBotJob(
        char_id=1, sessionkey="s", bot_type="auto_level", params={},
        control_token="t",
    )
    _capture_rewards(job, "SUCCESS | Total XP: 999999 | Total Gold: 888888 | Total Token: 77")
    assert job.earned_xp == 0
    assert job.earned_gold == 0
    assert job.earned_token == 0

    _capture_rewards(
        job,
        "SUCCESS | XP: +100 | Gold: +20 | Token: +3 | Total XP: 999999 | Total Gold: 888888",
    )
    assert job.earned_xp == 100
    assert job.earned_gold == 20
    assert job.earned_token == 3


def test_analytics_uses_action_count_and_reports_confidence():
    job = CloudBotJob(
        char_id=2, sessionkey="s", bot_type="auto_level", params={},
        control_token="t",
        created_at=time.time() - 900,
    )
    job.action_count = 12
    job.success_count = 11
    job.failure_count = 1
    job.first_action_at = time.time() - 600
    job.last_action_at = time.time()
    job.earned_xp = 1200
    metrics = job.analytics()
    assert metrics["action_count"] == 12
    assert 0 <= metrics["success_rate"] <= 100
    assert metrics["confidence"] in {"warming", "low", "medium", "high"}


def test_event_bus_bounded_queue_tracks_drops():
    async def run():
        queue = await event_bus.subscribe(999, max_queue=8)
        try:
            for i in range(20):
                await event_bus.publish_event(999, {"seq": i, "type": "TEST"})
            assert queue.qsize() <= 8
            stats = await event_bus.stats()
            assert stats["dropped_messages"] >= 1
        finally:
            await event_bus.unsubscribe(999, queue)
    asyncio.run(run())
