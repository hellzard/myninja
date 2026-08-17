from __future__ import annotations

import math
import statistics
from typing import Any, Dict, Iterable, List


def _latencies(events: Iterable[Dict[str, Any]]) -> List[float]:
    out = []
    for event in events:
        if str(event.get("type") or "").upper() != "ACTION_RESULT":
            continue
        data = event.get("data") if isinstance(event.get("data"), dict) else {}
        try:
            value = float(data.get("latency_ms") or 0)
        except (TypeError, ValueError):
            continue
        if value > 0:
            out.append(value)
    return out


def _robust_anomalies(values: List[float]) -> Dict[str, Any]:
    if len(values) < 8:
        return {"count": 0, "latest_is_anomaly": False, "baseline_ms": None}
    sample = values[-100:]
    median = statistics.median(sample)
    deviations = [abs(v - median) for v in sample]
    mad = statistics.median(deviations) or 1.0
    threshold = median + 6.0 * mad
    count = sum(1 for v in sample if v > threshold)
    return {
        "count": count,
        "latest_is_anomaly": bool(sample[-1] > threshold),
        "baseline_ms": round(median, 1),
        "threshold_ms": round(threshold, 1),
    }


def score(events: Iterable[Dict[str, Any]], status: Dict[str, Any] | None = None) -> Dict[str, Any]:
    events = list(events)
    status = dict(status or {})
    analytics = status.get("analytics") if isinstance(status.get("analytics"), dict) else {}

    failures = sum(
        1 for e in events
        if str(e.get("type") or "").upper() == "ACTION_RESULT"
        and not bool((e.get("data") or {}).get("success", True))
    )
    rate_limits = sum(1 for e in events if str(e.get("type") or "").upper() == "RATE_LIMITED")
    relogin_failed = sum(1 for e in events if str(e.get("type") or "").upper() == "SESSION_RECOVERY_FAILED")
    circuit = sum(1 for e in events if str(e.get("type") or "").upper() == "CIRCUIT_BREAKER")
    lat = _latencies(events)
    anomaly = _robust_anomalies(lat)

    action_count = int(analytics.get("action_count") or 0)
    success_rate = float(analytics.get("success_rate") or (100.0 if action_count == 0 else 0.0))
    p95 = float(analytics.get("network_p95_ms") or 0.0)

    value = 100.0
    value -= min(30.0, failures * 4.0)
    value -= min(20.0, rate_limits * 5.0)
    value -= min(20.0, relogin_failed * 10.0)
    value -= min(15.0, circuit * 7.5)
    value -= min(15.0, max(0.0, 98.0 - success_rate) * 1.5)
    if p95 > 5000:
        value -= 10.0
    elif p95 > 2500:
        value -= 5.0
    if anomaly["latest_is_anomaly"]:
        value -= 5.0
    value = max(0.0, min(100.0, value))

    if value >= 90:
        label = "EXCELLENT"
    elif value >= 75:
        label = "HEALTHY"
    elif value >= 55:
        label = "DEGRADED"
    else:
        label = "UNSTABLE"

    return {
        "score": round(value, 1),
        "label": label,
        "anomaly": anomaly,
        "signals": {
            "failures": failures,
            "rate_limits": rate_limits,
            "session_recovery_failed": relogin_failed,
            "circuit_breakers": circuit,
            "p95_latency_ms": p95,
            "success_rate": success_rate,
        },
    }
