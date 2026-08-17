from __future__ import annotations

import asyncio
import secrets
from typing import Any, Dict, Optional

from fastapi import APIRouter, HTTPException, WebSocket, WebSocketDisconnect
from pydantic import BaseModel, Field

from app.services import cloud_store, event_bus, notifications, diagnostics, recipes, panel_guard
from app.services.cloud_bot_runner import get_status, start_job, stop_job, engine_metrics
from app.services.settings_manager import load_settings, list_setting_snapshots, restore_setting_snapshot
from app.services.ninjasage_client import NinjaSageClient

router = APIRouter()


class CloudCredentials(BaseModel):
    username: Optional[str] = None
    password: Optional[str] = None
    user: Optional[str] = None
    pass_: Optional[str] = Field(default=None, alias="pass")

    def safe_dict(self) -> Dict[str, str]:
        data = (
            self.model_dump(by_alias=True)
            if hasattr(self, "model_dump")
            else self.dict(by_alias=True)
        )
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


class RecipeDryRunRequest(BaseModel):
    recipe: Dict[str, Any]


class DiagnosticsRequest(CloudBotControlRequest):
    events: list[Dict[str, Any]] = Field(default_factory=list)


class PushSubscribeRequest(BaseModel):
    char_id: int
    sessionkey: str = Field(min_length=1)
    subscription: Dict[str, Any]


class PushUnsubscribeRequest(BaseModel):
    char_id: int
    endpoint: str = Field(min_length=1)


class SettingsRestoreRequest(BaseModel):
    snapshot_id: str = Field(min_length=1)


@router.post("/bot-api/check-version")
async def check_version():
    client = NinjaSageClient()
    try:
        response = await client.check_version()
        return {"status": "success", "data": response}
    except Exception as exc:
        return {"status": "error", "message": str(exc)}
    finally:
        await client.aclose()


@router.get("/api/bot/cloud/engine")
async def cloud_engine():
    info = await cloud_store.engine_info()
    info["metrics"] = await engine_metrics()
    info["push_enabled"] = notifications.enabled()
    return {"status": "success", "engine": info}


@router.get("/api/bot/cloud/metrics")
async def cloud_metrics():
    return {"status": "success", "metrics": await engine_metrics()}


@router.post("/api/bot/cloud/start")
async def cloud_start(req: CloudBotStartRequest):
    try:
        credentials = req.credentials.safe_dict() if req.credentials else None
        if cloud_store.queue_mode():
            token = secrets.token_urlsafe(32)
            spec = {
                "sessionkey": req.sessionkey,
                "char_id": req.char_id,
                "bot_type": req.bot_type,
                "params": dict(req.params or {}),
                "credentials": credentials or {},
            }
            result = await cloud_store.enqueue_start(spec, token)
        else:
            result = await start_job(
                req.sessionkey, req.char_id, req.bot_type, req.params, credentials
            )
        return {"status": "success", "job": result}
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except RuntimeError as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc
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


@router.post("/api/bot/cloud/ws-ticket")
async def cloud_ws_ticket(req: CloudBotControlRequest):
    try:
        await get_status(req.char_id, req.control_token)
        ticket = await event_bus.issue_ticket(req.char_id, req.control_token, ttl_seconds=60)
        return {"status": "success", "ticket": ticket, "expires_in": 60}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc


@router.websocket("/api/bot/cloud/ws/{char_id}")
async def cloud_ws(websocket: WebSocket, char_id: int, ticket: str):
    if not await panel_guard.websocket_allowed(websocket):
        await websocket.close(code=1008)
        return
    control_token = await event_bus.consume_ticket(ticket, char_id)
    if not control_token:
        await websocket.close(code=1008)
        return
    try:
        initial = await get_status(char_id, control_token)
    except PermissionError:
        await websocket.close(code=1008)
        return

    await websocket.accept()
    queue = await event_bus.subscribe(char_id, max_queue=64)
    receive_task = asyncio.create_task(websocket.receive_json())
    queue_task = asyncio.create_task(queue.get())
    try:
        await websocket.send_json({"type": "job_status", "job": initial})
        while True:
            done, _ = await asyncio.wait(
                {receive_task, queue_task},
                timeout=15.0,
                return_when=asyncio.FIRST_COMPLETED,
            )

            if not done:
                try:
                    status = await get_status(char_id, control_token)
                except PermissionError:
                    await websocket.close(code=1008)
                    return
                await websocket.send_json({"type": "heartbeat", "job": status})
                continue

            if receive_task in done:
                message = receive_task.result()
                receive_task = asyncio.create_task(websocket.receive_json())
                if isinstance(message, dict) and message.get("type") == "ping":
                    await websocket.send_json({"type": "pong", "echo": message.get("ts")})

            if queue_task in done:
                payload = queue_task.result()
                queue_task = asyncio.create_task(queue.get())
                await websocket.send_json(payload)
    except (WebSocketDisconnect, RuntimeError, OSError):
        return
    finally:
        for task in (receive_task, queue_task):
            task.cancel()
        await asyncio.gather(receive_task, queue_task, return_exceptions=True)
        await event_bus.unsubscribe(char_id, queue)


@router.post("/api/bot/recipe/dry-run")
async def recipe_dry_run(req: RecipeDryRunRequest):
    try:
        return {"status": "success", "dry_run": recipes.dry_run(req.recipe, load_settings())}
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc


@router.post("/api/bot/diagnostics/analyze")
async def diagnostics_analyze(req: DiagnosticsRequest):
    try:
        status = await get_status(req.char_id, req.control_token)
        result = await diagnostics.analyze(status, req.events)
        return {"status": "success", "diagnostics": result}
    except PermissionError as exc:
        raise HTTPException(status_code=403, detail=str(exc)) from exc


@router.get("/api/bot/push/public-key")
async def push_public_key():
    return {"status": "success", "enabled": notifications.enabled(), "public_key": notifications.public_key()}


@router.post("/api/bot/push/subscribe")
async def push_subscribe(req: PushSubscribeRequest):
    client = NinjaSageClient(persistent=True)
    try:
        valid = await client.validate_session(req.sessionkey, req.char_id)
        if valid is not True:
            raise HTTPException(status_code=403, detail="Session validation failed")
        await notifications.subscribe(req.char_id, req.subscription)
        return {"status": "success", "enabled": notifications.enabled()}
    finally:
        await client.aclose()


@router.post("/api/bot/push/unsubscribe")
async def push_unsubscribe(req: PushUnsubscribeRequest):
    await notifications.unsubscribe(req.char_id, req.endpoint)
    return {"status": "success"}


@router.get("/api/bot/settings/snapshots")
async def settings_snapshots():
    return {"status": "success", "snapshots": list_setting_snapshots()}


@router.post("/api/bot/settings/restore")
async def settings_restore(req: SettingsRestoreRequest):
    if not restore_setting_snapshot(req.snapshot_id):
        raise HTTPException(status_code=404, detail="Settings snapshot not found")
    return {"status": "success", "settings": load_settings()}
