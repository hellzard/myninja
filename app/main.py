from fastapi import FastAPI, Response, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import Optional
from app.routers import auth, character, gateway, bot
from app.services.ninjasage_client import NinjaSageClient
from app.services.bot_manager import (
    auto_daily_gacha,
    auto_giveaway,
    run_mission,
    run_hunting,
    auto_shadow_war,
    auto_monster_hunt,
    auto_mission_s,
    auto_clan_war,
    run_circus_event
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
    params: dict = {}

class BasicBotRequest(BaseModel):
    sessionkey: str
    char_id: int

class AutoLevelingRequest(BaseModel):
    sessionkey: str
    char_id: int
    mission_id: str

class AutoDailyRequest(BaseModel):
    sessionkey: str
    char_id: int
    mission_id: str

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
app = FastAPI(title="Ninja Sage API", description="Remake API for Ninja Sage")

app.mount("/panel", StaticFiles(directory="app/web", html=True), name="panel")

app.include_router(auth.router, tags=["Authentication"])
app.include_router(character.router, tags=["Character"])
app.include_router(gateway.router, tags=["Gateway"])
app.include_router(bot.router, tags=["Bot API"])

@app.get("/")
def read_root():
    return {"message": "Ninja Sage Cloud API is running!"}

@app.post("/api/auth/login")
async def api_login(req: LoginRequest):
    client = NinjaSageClient()
    result = await client.login(req.username, req.password)
    return result

# -----------------
# Automation Bot Endpoints
# -----------------
@app.post("/api/bot/auto_leveling_step")
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
        res = await run_mission(client, req.sessionkey, req.char_id, req.mission_id)
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
