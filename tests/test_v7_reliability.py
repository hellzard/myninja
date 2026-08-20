from app.services.cloud_bot_runner import (
    CloudBotJob,
    _is_failed,
    _is_resource_exhausted,
    _should_stop,
)
from app.services.bot_manager import _collect_nested_materials


def make_job(bot_type: str) -> CloudBotJob:
    return CloudBotJob(
        char_id=100,
        sessionkey="test-session",
        bot_type=bot_type,
        params={},
        control_token="test-control",
    )


def test_resource_exhaustion_is_not_operational_failure():
    messages = (
        "You don't have energy",
        "You dont have energy",
        "You do not have energy",
        "Out of energy",
        "Not enough energy",
        "Insufficient energy",
        "Energy habis",
    )

    for message in messages:
        assert _is_resource_exhausted(message)
        assert _is_failed(message) is False


def test_yokai_stops_when_energy_is_empty():
    assert _should_stop(
        make_job("yokai"),
        "Failed: You don't have energy",
    )


def test_circus_stops_when_energy_is_empty():
    assert _should_stop(
        make_job("circus"),
        "Failed: Not enough energy",
    )


def test_yokai_minigame_stops_when_resources_end():
    assert _should_stop(
        make_job("yokai_minigame"),
        "Failed: Out of energy and free tries",
    )


def test_real_failure_remains_failure():
    message = "Failed to connect to upstream server"

    assert _is_failed(message)
    assert not _is_resource_exhausted(message)


def test_nested_materials_are_discovered_without_inventing_rewards():
    payload = {
        "status": 1,
        "data": {
            "reward": {
                "materials": [
                    {
                        "id": "material_test",
                        "amount": 3,
                    }
                ]
            }
        },
    }

    assert _collect_nested_materials(payload) == [
        "material_testx3"
    ]
