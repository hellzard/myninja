from typing import Any, Dict

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from app.services.cloud_bot_runner import get_status, start_job, stop_job
from app.services.ninjasage_client import NinjaSageClient

router = APIRouter()


class CloudBotStartRequest(BaseModel):
    sessionkey: str = Field(min_length=1)
    char_id: int
    bot_type: str = Field(min_length=1)
    params: Dict[str, Any] = Field(default_factory=dict)


class CloudBotControlRequest(BaseModel):
    char_id: int
    control_token: str = Field(min_length=1)


@router.post("/bot-api/check-version")
async def check_version():
    """Contacts the official Ninja Sage server and returns the version handshake tokens."""
    try:
        client = NinjaSageClient()
        response = await client.check_version()
        return {"status": "success", "data": response}
    except Exception as exc:
        return {"status": "error", "message": str(exc)}


@router.post("/api/bot/cloud/start")
async def cloud_start(req: CloudBotStartRequest):
    try:
        result = await start_job(req.sessionkey, req.char_id, req.bot_type, req.params)
        return {"status": "success", "job": result}
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.post("/api/bot/cloud/stop")
async def cloud_stop(req: CloudBotControlRequest):
    try:
        result = await stop_job(req.char_id, req.control_token)
        return {"status": "success", "job": result}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.post("/api/bot/cloud/status")
async def cloud_status(req: CloudBotControlRequest):
    try:
        result = await get_status(req.char_id, req.control_token)
        return {"status": "success", "job": result}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
