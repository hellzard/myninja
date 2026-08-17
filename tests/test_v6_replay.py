from app.services.replay_simulator import simulate


def test_replay_is_bounded_and_offline():
    events = [
        {"type": "ACTION_RESULT", "data": {"latency_ms": 500, "success": True}},
        {"type": "ACTION_RESULT", "data": {"latency_ms": 6000, "success": True}},
        {"type": "RATE_LIMITED", "data": {"delay": 30}},
        {"type": "SESSION_RECOVERED", "data": {}},
    ]
    result = simulate(events, {
        "base_delay_seconds": 5,
        "soft_latency_ms": 2500,
        "hard_latency_ms": 5000,
        "max_penalty_seconds": 30,
    })
    assert result["observed"]["actions"] == 2
    assert result["observed"]["rate_limits"] == 1
    assert result["simulation"]["estimated_pacing_seconds"] >= 10
    assert "never sends game requests" in result["note"]
