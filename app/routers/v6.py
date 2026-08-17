from __future__ import annotations

from typing import Any, Dict, List, Optional

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from app.services import (
    durable_journal,
    orchestrator,
    panel_guard,
    policy_engine,
    release_manager,
    reliability,
    replay_simulator,
)
from app.services.cloud_bot_runner import get_status


router = APIRouter()


class SetupOptionsRequest(BaseModel):
    setup_token: str = Field(min_length=1)


class SetupFinishRequest(BaseModel):
    ceremony_id: str = Field(min_length=1)
    setup_token: str = Field(min_length=1)
    credential: Dict[str, Any]


class AuthFinishRequest(BaseModel):
    ceremony_id: str = Field(min_length=1)
    credential: Dict[str, Any]


class ReplayRequest(BaseModel):
    events: List[Dict[str, Any]] = Field(default_factory=list)
    config: Dict[str, Any] = Field(default_factory=dict)


class ReliabilityRequest(BaseModel):
    char_id: int
    control_token: str = Field(min_length=1)
    journal_limit: int = 1000


class RecoveryResumeRequest(BaseModel):
    job_id: str = Field(min_length=1)
    char_id: int
    control_token: str = Field(min_length=1)


class PolicyRequest(BaseModel):
    goals: Dict[str, Any]


@router.get("/api/v6/security/status")
async def security_status():
    return {"status": "success", "security": await panel_guard.status()}


@router.post("/api/v6/security/register/options")
async def security_register_options(req: SetupOptionsRequest):
    try:
        return {"status": "success", **(await panel_guard.registration_options(req.setup_token))}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    except (ValueError, RuntimeError) as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.post("/api/v6/security/register/finish")
async def security_register_finish(req: SetupFinishRequest):
    try:
        result = await panel_guard.finish_registration(
            req.ceremony_id, req.setup_token, req.credential
        )
        return {"status": "success", **result}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.post("/api/v6/security/auth/options")
async def security_auth_options():
    try:
        return {"status": "success", **(await panel_guard.authentication_options())}
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.post("/api/v6/security/auth/finish")
async def security_auth_finish(req: AuthFinishRequest):
    try:
        result = await panel_guard.finish_authentication(req.ceremony_id, req.credential)
        return {"status": "success", **result}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.post("/api/v6/replay/simulate")
async def replay(req: ReplayRequest):
    try:
        return {"status": "success", "replay": replay_simulator.simulate(req.events, req.config)}
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.post("/api/v6/reliability")
async def reliability_report(req: ReliabilityRequest):
    try:
        status = await get_status(req.char_id, req.control_token)
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    events = await durable_journal.recent_events(
        req.char_id, max(50, min(5000, req.journal_limit))
    )
    if not events:
        events = list(status.get("events") or [])
    return {
        "status": "success",
        "reliability": reliability.score(events, status),
        "source": "journal" if durable_journal.configured() else "current-job",
    }


@router.get("/api/v6/recovery/candidates")
async def recovery_candidates():
    return {
        "status": "success",
        "configured": durable_journal.encrypted_recovery_ready(),
        "candidates": await durable_journal.list_recovery_candidates(),
    }


@router.post("/api/v6/recovery/resume")
async def recovery_resume(req: RecoveryResumeRequest):
    try:
        ok = await durable_journal.resume_candidate(
            req.job_id, req.char_id, req.control_token
        )
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=409, detail=str(exc)) from exc
    if not ok:
        raise HTTPException(status_code=404, detail="Recovery candidate unavailable")
    return {
        "status": "success",
        "message": "Recovery confirmed. The automation resumed after the uncertain action boundary.",
    }


@router.post("/api/v6/policy/plan")
async def policy_plan(req: PolicyRequest):
    try:
        return {"status": "success", "plan": policy_engine.plan(req.goals)}
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.post("/api/v6/policy/validate")
async def policy_validate(req: Dict[str, Any]):
    try:
        return {"status": "success", "plan": policy_engine.validate_execution(req)}
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.get("/api/v6/release")
async def release():
    return {
        "status": "success",
        "readiness": await release_manager.readiness(),
        "orchestrator": orchestrator.metrics(),
    }
