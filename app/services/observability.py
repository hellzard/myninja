from __future__ import annotations

import os
from typing import Any, Dict

_configured = False


def enabled() -> bool:
    return os.getenv("OTEL_ENABLED", "0").strip().lower() in {"1", "true", "yes", "on"}


def configure(app) -> Dict[str, Any]:
    global _configured
    if _configured or not enabled():
        return {"enabled": enabled(), "configured": _configured}
    try:
        from opentelemetry import trace
        from opentelemetry.sdk.resources import Resource
        from opentelemetry.sdk.trace import TracerProvider
        from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter
        from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
        from opentelemetry.instrumentation.httpx import HTTPXClientInstrumentor

        resource = Resource.create({"service.name": os.getenv("OTEL_SERVICE_NAME", "myninja-control-center")})
        provider = TracerProvider(resource=resource)
        endpoint = os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "").strip()
        if endpoint:
            from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
            provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter(endpoint=endpoint)))
        elif os.getenv("OTEL_CONSOLE", "0").lower() in {"1", "true", "yes"}:
            provider.add_span_processor(BatchSpanProcessor(ConsoleSpanExporter()))
        trace.set_tracer_provider(provider)
        FastAPIInstrumentor.instrument_app(app)
        HTTPXClientInstrumentor().instrument()
        _configured = True
        return {"enabled": True, "configured": True, "exporter": "otlp" if endpoint else "console-or-none"}
    except Exception as exc:
        return {"enabled": True, "configured": False, "error": str(exc)}
