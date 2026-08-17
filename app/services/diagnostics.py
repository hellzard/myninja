from __future__ import annotations

import json
import os
from typing import Any, Dict, List

import httpx

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "").strip()
OPENAI_MODEL = os.getenv("OPENAI_DIAGNOSTICS_MODEL", "").strip()


def _safe_events(events: Any) -> List[Dict[str, Any]]:
    if not isinstance(events, list):
        return []
    allowed_data = {"state", "bot_type", "iteration", "delay", "latency_ms", "message", "success", "step", "reason"}
    result = []
    for event in events[-200:]:
        if not isinstance(event, dict):
            continue
        data = event.get("data") if isinstance(event.get("data"), dict) else {}
        result.append({
            "type": str(event.get("type") or "UNKNOWN")[:64],
            "ts": event.get("ts"),
            "data": {k: data.get(k) for k in allowed_data if k in data},
        })
    return result


def heuristic(status: Dict[str, Any], events: Any) -> Dict[str, Any]:
    safe = _safe_events(events)
    analytics = status.get("analytics") if isinstance(status.get("analytics"), dict) else {}
    health = status.get("health") if isinstance(status.get("health"), dict) else {}
    failures = int(analytics.get("failure_count") or 0)
    successes = int(analytics.get("success_count") or 0)
    rate_limits = int(analytics.get("rate_limit_count") or 0)
    relogins = int(analytics.get("relogin_count") or 0)
    success_rate = float(analytics.get("success_rate") or 0)
    latency = float(analytics.get("network_p95_ms") or analytics.get("network_avg_ms") or 0)
    observations = []
    recommendations = []
    if successes:
        observations.append(f"{successes} action sukses dengan success rate {success_rate:.1f}%.")
    if failures:
        observations.append(f"Terdapat {failures} action gagal pada session ini.")
    if rate_limits:
        observations.append(f"Rate-limit terdeteksi {rate_limits} kali; adaptive/backoff protection sudah relevan.")
        recommendations.append("Pertahankan floor 5 detik dan biarkan adaptive pacing/backoff memperlambat saat server memberi sinyal penolakan.")
    if relogins:
        observations.append(f"Automatic session recovery berhasil dipakai {relogins} kali.")
    if latency > 2500:
        observations.append(f"p95/average network latency terlihat tinggi (~{int(latency)} ms).")
        recommendations.append("Hindari menurunkan delay; periksa apakah latency tinggi bertepatan dengan rejection atau maintenance server.")
    if not recommendations:
        recommendations.append("Session terlihat stabil; jangan mempercepat di bawah base delay yang sudah dikonfigurasi.")
    return {
        "provider": "local",
        "summary": f"Health saat ini: {str(health.get('state') or 'UNKNOWN')}. " + (observations[0] if observations else "Belum cukup data untuk kesimpulan kuat."),
        "observations": observations,
        "recommendations": recommendations,
        "events_analyzed": len(safe),
    }


def _extract_output_text(payload: Dict[str, Any]) -> str:
    direct = payload.get("output_text")
    if isinstance(direct, str) and direct.strip():
        return direct.strip()
    chunks = []
    for item in payload.get("output") or []:
        if not isinstance(item, dict):
            continue
        for part in item.get("content") or []:
            if isinstance(part, dict) and isinstance(part.get("text"), str):
                chunks.append(part["text"])
    return "\n".join(chunks).strip()


async def analyze(status: Dict[str, Any], events: Any) -> Dict[str, Any]:
    local = heuristic(status, events)
    if not OPENAI_API_KEY or not OPENAI_MODEL:
        return local
    safe_payload = {
        "health": status.get("health", {}),
        "analytics": status.get("analytics", {}),
        "bot_type": status.get("bot_type"),
        "iteration": status.get("iteration"),
        "events": _safe_events(events),
    }
    prompt = (
        "Analyze this automation telemetry for reliability only. Do not suggest bypassing server limits, "
        "exploits, or faster-than-safe request rates. Return concise Indonesian diagnostics: summary, likely causes, "
        "and 3 safe reliability recommendations. Telemetry JSON:\n" + json.dumps(safe_payload, ensure_ascii=False)[:24000]
    )
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(
                "https://api.openai.com/v1/responses",
                headers={"Authorization": f"Bearer {OPENAI_API_KEY}", "Content-Type": "application/json"},
                json={"model": OPENAI_MODEL, "input": prompt},
            )
            response.raise_for_status()
            text = _extract_output_text(response.json())
        if not text:
            return local
        return {"provider": "openai", "analysis": text, "events_analyzed": len(safe_payload["events"]), "fallback": local}
    except Exception as exc:
        local["ai_error"] = str(exc)
        return local
