from typing import Any, Dict, Optional

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from app.services.cloud_bot_runner import get_status, start_job, stop_job
from app.services.ninjasage_client import NinjaSageClient

router = APIRouter()


class CloudCredentials(BaseModel):
    username: Optional[str] = None
    password: Optional[str] = None
    user: Optional[str] = None
    pass_: Optional[str] = Field(default=None, alias='pass')

    def safe_dict(self) -> Dict[str, str]:
        data = self.model_dump(by_alias=True) if hasattr(self, 'model_dump') else self.dict(by_alias=True)
        return {k: str(v) for k, v in data.items() if v}


class CloudBotStartRequest(BaseModel):
    sessionkey: str = Field(min_length=1)
    char_id: int
    bot_type: str = Field(min_length=1)
    params: Dict[str, Any] = Field(default_factory=dict)
    credentials: Optional[CloudCredentials] = None


class CloudBotControlRequest(BaseModel):
    char_id: int
    control_token: str = Field(min_length=1)


@router.post('/bot-api/check-version')
async def check_version():
    client = NinjaSageClient()
    try:
        response = await client.check_version()
        return {'status': 'success', 'data': response}
    except Exception as exc:
        return {'status': 'error', 'message': str(exc)}
    finally:
        await client.aclose()


@router.post('/api/bot/cloud/start')
async def cloud_start(req: CloudBotStartRequest):
    try:
        credentials = req.credentials.safe_dict() if req.credentials else None
        result = await start_job(req.sessionkey, req.char_id, req.bot_type, req.params, credentials)
        return {'status': 'success', 'job': result}
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.post('/api/bot/cloud/stop')
async def cloud_stop(req: CloudBotControlRequest):
    try:
        result = await stop_job(req.char_id, req.control_token)
        return {'status': 'success', 'job': result}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.post('/api/bot/cloud/status')
async def cloud_status(req: CloudBotControlRequest):
    try:
        result = await get_status(req.char_id, req.control_token)
        return {'status': 'success', 'job': result}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
