from contextlib import asynccontextmanager
import time
from fastapi import FastAPI, Response, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
from pydantic import BaseModel, Field
from typing import Optional
from app.routers import auth, character, gateway, bot, v6
from app.services.ninjasage_client import NinjaSageClient
from app.services.cloud_bot_runner import recover_persisted_jobs, flush_jobs
from app.services import cloud_store, durable_journal, panel_guard, release_manager, slo
from app.services.observability import configure as configure_observability
from app.services.bot_manager import (
    auto_daily_gacha,
    auto_giveaway,
    run_mission,
    auto_daily_event,
    run_hunting,
    auto_shadow_war,
    auto_monster_hunt,
    auto_mission_s,
    auto_clan_war,
    auto_exam,
    auto_eudemon,
    run_circus_event,
    run_yokai_event,
    update_char_snapshot
)

# -----------------
# Pydantic Models
# -----------------
class LoginRequest(BaseModel):
    username: str
    password: str

class BotCommandRequest(BaseModel):
    action: str
    sessionkey: str
    char_id: int
    params: dict = Field(default_factory=dict)

class BasicBotRequest(BaseModel):
    sessionkey: str
    char_id: int

class AutoLevelingRequest(BaseModel):
    sessionkey: str
    char_id: int
    mission_id: str

class ExploitGachaRequest(BaseModel):
    sessionkey: str
    char_id: int
    coin_type: str
    spam_count: int

class AutoDailyRequest(BaseModel):
    sessionkey: str
    char_id: int

class AutoHuntingRequest(BaseModel):
    sessionkey: str
    char_id: int
    zone: int

class AutoEventRequest(BaseModel):
    sessionkey: str
    char_id: int
    event_id: str

# -----------------
# FastAPI App
# -----------------
@asynccontextmanager
async def cloud_lifespan(app: FastAPI):
    release_manager.validate_startup()
    await durable_journal.initialize()
    recovered_redis = await recover_persisted_jobs()
    recovered_journal = await durable_journal.recover_jobs()
    if recovered_redis or recovered_journal.get("recovered"):
        print(
            f"[Control Center v6] Recovered Redis={recovered_redis}, "
            f"Journal={recovered_journal.get('recovered', 0)} job(s)."
        )
    if recovered_journal.get("needs_confirmation"):
        print(
            f"[Control Center v6] {recovered_journal['needs_confirmation']} "
            "job(s) require human recovery confirmation."
        )
    try:
        yield
    finally:
        await flush_jobs()
        await cloud_store.close()
        await durable_journal.close()


app = FastAPI(title="Ninja Sage API", description="Remake API for Ninja Sage", lifespan=cloud_lifespan)
configure_observability(app)

app.mount("/panel", StaticFiles(directory="app/web", html=True), name="panel")

app.include_router(auth.router, tags=["Authentication"])
app.include_router(character.router, tags=["Character"])
app.include_router(gateway.router, tags=["Gateway"])
app.include_router(bot.router, tags=["Bot API"])
app.include_router(v6.router, tags=["Control Center v6"])

@app.get("/")
def read_root():
    return {"message": "Ninja Sage Cloud API is running!"}

@app.get("/healthz", include_in_schema=False)
def healthz():
    return {"status": "ok"}


@app.get("/readyz", include_in_schema=False)
async def readyz():
    return await release_manager.readiness()

@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    started = time.perf_counter()
    guard_response = await panel_guard.guard_http(request)
    if guard_response is not None:
        return guard_response

    response = await call_next(request)
    duration_ms = (time.perf_counter() - started) * 1000.0
    slo.observe(request.url.path, response.status_code, duration_ms)

    response.headers.setdefault("X-Content-Type-Options", "nosniff")
    response.headers.setdefault("X-Frame-Options", "DENY")
    response.headers.setdefault("Referrer-Policy", "same-origin")
    response.headers.setdefault("Permissions-Policy", "camera=(), microphone=(), geolocation=()")
    response.headers.setdefault(
        "Content-Security-Policy",
        "default-src 'self'; "
        "script-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com; "
        "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com; "
        "font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com data:; "
        "img-src 'self' data: blob:; "
        "connect-src 'self' ws: wss: https:; "
        "object-src 'none'; base-uri 'self'; frame-ancestors 'none'; form-action 'self'"
    )
    if request.url.path.startswith("/api/"):
        response.headers.setdefault("Cache-Control", "no-store")
    return response

@app.post("/api/auth/login")
async def api_login(req: LoginRequest):
    client = NinjaSageClient()
    result = await client.login(req.username, req.password)
    if isinstance(result, dict) and result.get("status") == "success":
        char_id = result.get("char_id")
        if char_id:
            update_char_snapshot(char_id, initial_stats={
                "level": result.get("level"),
                "xp": result.get("xp"),
                "gold": result.get("gold"),
                "tokens": result.get("tokens")
            })
    return result

# -----------------
# Automation Bot Endpoints
# -----------------
@app.post("/api/bot/auto_leveling_step")
@app.post("/api/bot/auto_level_step")
async def api_auto_level_step(req: AutoLevelingRequest):
    client = NinjaSageClient()
    try:
        res = await run_mission(client, req.sessionkey, req.char_id, req.mission_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_daily_step")
async def api_auto_daily_step(req: AutoDailyRequest):
    client = NinjaSageClient()
    try:
        res = await auto_daily_event(client, req.sessionkey, req.char_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_hunting_step")
async def api_auto_hunting_step(req: AutoHuntingRequest):
    client = NinjaSageClient()
    try:
        res = await run_hunting(client, req.sessionkey, req.char_id, req.zone)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_event_step")
async def api_auto_event_step(req: AutoEventRequest):
    client = NinjaSageClient()
    try:
        if req.event_id == "circus" or req.event_id == "circus_ringmaster":
            res = await run_circus_event(client, req.sessionkey, req.char_id, boss_type="ringmaster")
        elif req.event_id == "circus_jester":
            res = await run_circus_event(client, req.sessionkey, req.char_id, boss_type="jester")
        elif req.event_id == "yokai_kitsune":
            res = await run_yokai_event(client, req.sessionkey, req.char_id, boss_type="kitsune")
        elif req.event_id == "yokai_tengu":
            res = await run_yokai_event(client, req.sessionkey, req.char_id, boss_type="tengu")
        elif req.event_id == "yokai_nurarihyon":
            res = await run_yokai_event(client, req.sessionkey, req.char_id, boss_type="nurarihyon")
        else:
            res = await run_mission(client, req.sessionkey, req.char_id, req.event_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_shadow_war_step")
async def api_auto_shadow_war_step(req: BasicBotRequest):
    client = NinjaSageClient()
    try:
        res = await auto_shadow_war(client, req.sessionkey, req.char_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_monster_step")
async def api_auto_monster_step(req: BasicBotRequest):
    client = NinjaSageClient()
    try:
        res = await auto_monster_hunt(client, req.sessionkey, req.char_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_mission_s_step")
async def api_auto_mission_s_step(req: BasicBotRequest):
    client = NinjaSageClient()
    try:
        res = await auto_mission_s(client, req.sessionkey, req.char_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_clan_war_step")
async def api_auto_clan_war_step(req: BasicBotRequest):
    client = NinjaSageClient()
    try:
        res = await auto_clan_war(client, req.sessionkey, req.char_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

import traceback

@app.post("/api/bot/auto_exam_step")
async def api_auto_exam_step(req: BasicBotRequest):
    client = NinjaSageClient()
    try:
        res = await auto_exam(client, req.sessionkey, req.char_id)
        return {"status": "success", "message": res}
    except Exception as e:
        error_trace = traceback.format_exc()
        print(f"API AUTO EXAM ERROR:\n{error_trace}")
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_eudemon")
async def api_auto_eudemon(req: BasicBotRequest):
    client = NinjaSageClient()
    try:
        res = await auto_eudemon(client, req.sessionkey, req.char_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_mission_step")
async def api_auto_mission_step(req: AutoLevelingRequest):
    client = NinjaSageClient()
    try:
        from app.services.bot_manager import run_auto_mission
        res = await run_auto_mission(client, req.sessionkey, req.char_id, req.mission_id)
        return {"status": "success", "message": res}
    except Exception as e:
        import traceback
        error_trace = traceback.format_exc()
        print(f"API AUTO MISSION ERROR:\n{error_trace}")
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/auto_yokai_minigame_step")
async def api_auto_yokai_minigame(req: BasicBotRequest):
    client = NinjaSageClient()
    try:
        from app.services.bot_manager import run_yokai_minigame
        res = await run_yokai_minigame(client, req.sessionkey, req.char_id)
        return {"status": "success", "message": res}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/exploit_gacha")
async def api_exploit_gacha(req: ExploitGachaRequest):
    return Response(
        content='{"status":"error","message":"Experimental endpoint disabled in Control Center v6."}',
        status_code=410,
        media_type="application/json",
    )

@app.post("/api/bot/get_stats")
async def api_get_stats(req: BasicBotRequest):
    client = NinjaSageClient()
    try:
        char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [req.char_id, req.sessionkey])
        if char_data_res.get("status") == 1:
            char_obj = char_data_res.get("data", char_data_res.get("character_data", char_data_res))
            gold = char_obj.get("gold", "--")
            xp = char_obj.get("xp", "--")
            lvl = char_obj.get("character_level", char_obj.get("level", "--"))
            
            # Fetch token data as well (from SystemLogin.getAccountData)
            acc_data = await client.send_amf_request("SystemLogin.getAccountData", [req.sessionkey])
            tokens = "--"
            if acc_data.get("status") == 1:
                tokens = acc_data.get("account", {}).get("tokens", "--")
                
            update_char_snapshot(req.char_id, char_data_res, acc_data)
                
            return {
                "status": "success",
                "gold": gold,
                "xp": xp,
                "level": lvl,
                "tokens": tokens
            }
        else:
            return {"status": "error", "message": "Failed to get character data"}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.post("/api/bot/command")
async def bot_command(req: BotCommandRequest):
    client = NinjaSageClient()
    action = req.action
    sessionkey = req.sessionkey
    char_id = req.char_id
    
    try:
        if action == "daily_gacha":
            result = await auto_daily_gacha(client, sessionkey, char_id)
        elif action == "giveaway":
            result = await auto_giveaway(client, sessionkey, char_id)
        elif action == "mission":
            mission_id = req.params.get("mission_id")
            if not mission_id:
                return {"status": "error", "message": "Missing mission_id"}
            result = await run_mission(client, sessionkey, char_id, mission_id)
        elif action == "hunting":
            zone = req.params.get("zone")
            if zone is None:
                return {"status": "error", "message": "Missing hunting zone"}
            result = await run_hunting(client, sessionkey, char_id, int(zone))
        else:
            return {"status": "error", "message": "Unknown command"}
            
        return {"status": "success", "result": result}
    except Exception as e:
        return {"status": "error", "message": str(e)}

from .services.settings_manager import load_settings, save_settings

@app.get("/api/bot/settings")
async def api_get_settings():
    return {"status": "success", "settings": load_settings()}

@app.post("/api/bot/settings")
async def api_save_settings(req: Request):
    try:
        settings = await req.json()
        success = save_settings(settings)
        if success:
            return {"status": "success", "message": "Settings saved successfully"}
        return {"status": "error", "message": "Failed to save settings"}
    except Exception as e:
        return {"status": "error", "message": str(e)}
