from app.services.reliability import score


def test_reliability_penalizes_failure_bursts():
    good = [
        {"type": "ACTION_RESULT", "data": {"success": True, "latency_ms": 500}}
        for _ in range(20)
    ]
    bad = good + [
        {"type": "ACTION_RESULT", "data": {"success": False, "latency_ms": 6000}},
        {"type": "RATE_LIMITED", "data": {"delay": 30}},
        {"type": "CIRCUIT_BREAKER", "data": {"delay": 120}},
    ]
    status = {"analytics": {"action_count": 23, "success_rate": 95, "network_p95_ms": 6000}}
    assert score(good, status)["score"] > score(bad, status)["score"]
