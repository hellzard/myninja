from __future__ import annotations

import os
import time
from collections import deque
from typing import Any, Dict

WINDOW = max(100, min(10000, int(os.getenv("SLO_WINDOW_REQUESTS", "1000") or 1000)))
LATENCY_TARGET_MS = max(50.0, float(os.getenv("SLO_API_LATENCY_TARGET_MS", "500") or 500))
SUCCESS_TARGET = min(100.0, max(50.0, float(os.getenv("SLO_SUCCESS_TARGET_PERCENT", "99") or 99)))

_samples = deque(maxlen=WINDOW)


def observe(path: str, status_code: int, duration_ms: float) -> None:
    if not str(path).startswith("/api/"):
        return
    _samples.append({
        "ts": time.time(),
        "path": str(path)[:160],
        "status": int(status_code),
        "duration_ms": max(0.0, float(duration_ms)),
    })


def snapshot() -> Dict[str, Any]:
    rows = list(_samples)
    if not rows:
        return {
            "samples": 0,
            "success_percent": 100.0,
            "latency_target_ms": LATENCY_TARGET_MS,
            "latency_compliance_percent": 100.0,
            "success_target_percent": SUCCESS_TARGET,
            "meeting_slo": True,
        }

    success = sum(1 for x in rows if int(x["status"]) < 500)
    fast = sum(1 for x in rows if float(x["duration_ms"]) <= LATENCY_TARGET_MS)
    success_pct = success / len(rows) * 100.0
    fast_pct = fast / len(rows) * 100.0
    return {
        "samples": len(rows),
        "success_percent": round(success_pct, 2),
        "latency_target_ms": LATENCY_TARGET_MS,
        "latency_compliance_percent": round(fast_pct, 2),
        "success_target_percent": SUCCESS_TARGET,
        "meeting_slo": success_pct >= SUCCESS_TARGET and fast_pct >= SUCCESS_TARGET,
    }
