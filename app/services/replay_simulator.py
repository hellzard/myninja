from __future__ import annotations

import math
import statistics
from typing import Any, Dict, List


def _num(value: Any, default: float = 0.0) -> float:
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def simulate(events: Any, config: Any = None) -> Dict[str, Any]:
    if not isinstance(events, list):
        raise ValueError("events must be a list")
    if len(events) > 5000:
        raise ValueError("replay accepts at most 5000 events")

    cfg = dict(config or {}) if isinstance(config, dict) else {}
    base = max(5.0, _num(cfg.get("base_delay_seconds"), 5.0))
    soft = max(500.0, _num(cfg.get("soft_latency_ms"), 2500.0))
    hard = max(soft, _num(cfg.get("hard_latency_ms"), 5000.0))
    cap = max(0.0, _num(cfg.get("max_penalty_seconds"), 30.0))

    actions = []
    failures = 0
    rate_limits = 0
    relogins = 0
    observed_wait = 0.0

    for raw in events:
        if not isinstance(raw, dict):
            continue
        typ = str(raw.get("type") or "").upper()
        data = raw.get("data") if isinstance(raw.get("data"), dict) else {}
        if typ == "ACTION_RESULT":
            actions.append({
                "latency_ms": max(0.0, _num(data.get("latency_ms"))),
                "success": bool(data.get("success", True)),
            })
            if not actions[-1]["success"]:
                failures += 1
        elif typ == "RATE_LIMITED":
            rate_limits += 1
            observed_wait += max(0.0, _num(data.get("delay")))
        elif typ == "SESSION_RECOVERED":
            relogins += 1

    penalty = 0.0
    simulated_wait = 0.0
    simulated_rate_limited = 0
    latencies = []

    for action in actions:
        latency = action["latency_ms"]
        latencies.append(latency)
        if not action["success"]:
            penalty = min(cap, max(penalty, 5.0))
        elif latency >= hard:
            penalty = min(cap, max(penalty, 8.0))
        elif latency >= soft:
            penalty = min(cap, max(penalty, 3.0))
        else:
            penalty = max(0.0, penalty - 1.0)

        simulated_wait += base + penalty
        if penalty >= max(8.0, cap * 0.5) and cap > 0:
            simulated_rate_limited += 1

    p95 = 0.0
    if latencies:
        ordered = sorted(latencies)
        p95 = ordered[min(len(ordered) - 1, max(0, math.ceil(len(ordered) * 0.95) - 1))]

    return {
        "observed": {
            "actions": len(actions),
            "failures": failures,
            "rate_limits": rate_limits,
            "relogins": relogins,
            "explicit_backoff_seconds": round(observed_wait, 1),
            "p95_latency_ms": round(p95, 1),
        },
        "simulation": {
            "base_delay_seconds": base,
            "soft_latency_ms": soft,
            "hard_latency_ms": hard,
            "max_penalty_seconds": cap,
            "estimated_pacing_seconds": round(simulated_wait, 1),
            "final_penalty_seconds": round(penalty, 1),
            "high_penalty_actions": simulated_rate_limited,
        },
        "note": "Replay is offline-only and never sends game requests.",
    }
