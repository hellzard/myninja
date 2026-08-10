import asyncio
import json
import base64
import hashlib
from app.services.ninjasage_client import NinjaSageClient

async def auto_daily_gacha(client: NinjaSageClient, sessionkey: str, char_id: int):
    # 1. Check tokens/coins
    res = await client.send_amf_request("mGbT7HiV6WeVOUXp.8CDKfNk7hu3I", [sessionkey, char_id, 0])
    if res.get('status') == 1:
        coins = int(res.get('coin', 0))
        if coins >= 1:
            roll_res = await client.send_amf_request("mGbT7HiV6WeVOUXp.Ckpdt4SSQ1wF", [sessionkey, char_id, "coins", 1])
            return f"Found {coins} coins! Roll Result: {roll_res}"
        else:
            return "No gacha coins available today."
    else:
        return f"Failed to check gacha: {res}"

async def auto_giveaway(client: NinjaSageClient, sessionkey: str, char_id: int):
    res = await client.send_amf_request("be9WkVbJZYaRo69c.C3VahnT6Jydb", [char_id, sessionkey])
    logs = []
    if res.get('status') == 1 and 'giveaways' in res:
        giveaways = res['giveaways']
        for gw in giveaways:
            if gw.get('joined') == 0:
                gw_id = gw.get('id')
                join_res = await client.send_amf_request("be9WkVbJZYaRo69c.n1LlmpeXb0GK", [char_id, sessionkey, gw_id])
                logs.append(f"Joined Giveaway #{gw_id}: {join_res}")
            else:
                logs.append(f"Already joined Giveaway #{gw.get('id')}")
    else:
        logs.append(f"Failed to check giveaways: {res}")
    return " | ".join(logs)

import hashlib
import json
import os

base_dir = os.path.dirname(os.path.dirname(__file__))
with open(os.path.join(base_dir, "data", "mission.json"), "r", encoding="utf-8") as f:
    MISSION_DATA = json.load(f)
with open(os.path.join(base_dir, "data", "enemy.json"), "r", encoding="utf-8") as f:
    ENEMY_DATA = json.load(f)

def get_data_by_id(data_id: str, data_list: list) -> dict:
    for item in data_list:
        if item.get("id") == data_id:
            return item
    return {}

def calculate_agility(char_data: dict) -> int:
    agility = 10
    if 'status' in char_data and 'wind' in char_data['status']:
        agility += char_data['status']['wind'] * 1
    # Note: real calculation includes gear, but often server accepts it if no gear is equipped or hash isn't strictly validated on agility
    return agility

BATTLE_HASH = "e89c256038cc9603"

async def run_mission(client: NinjaSageClient, sessionkey: str, char_id: int, mission_id: str):
    mission_info = get_data_by_id(mission_id, MISSION_DATA)
    if not mission_info:
        return f"Unknown mission_id {mission_id}"
        
    char_data_res = await client.send_amf_request("CharacterDAO.getById", [char_id, sessionkey])
    if char_data_res.get('status') != 1:
        return "Failed to get character data"
    char_data = char_data_res['character']
    agility = calculate_agility(char_data)
    
    enemies = mission_info.get("enemies", [])
    enemy_attrs = []
    for enemy in enemies:
        enemy_attr = get_data_by_id(enemy, ENEMY_DATA)
        hp = enemy_attr.get("hp", 0)
        ene_agi = enemy_attr.get("agility", 0)
        enemy_attrs.append(f"id:{enemy}|hp:{hp}|agility:{ene_agi}")
        
    hash_input = ",".join(enemies) + "".join(enemy_attrs) + str(agility)
    mission_hash = hashlib.md5(hash_input.encode()).hexdigest()
    
    start_params = [char_id, mission_id, ",".join(enemies), "#".join(enemy_attrs), agility, mission_hash, sessionkey]
    
    start_res = await client.send_amf_request("BattleSystem.startMission", start_params)
    if start_res.get('status') == 1 and 'battle_code' in start_res:
        battle_id = start_res['battle_code']
        await asyncio.sleep(1)
        
        finish_hash_input = f"{mission_id}{char_id}{battle_id}0"
        finish_mission_hash = hashlib.md5(finish_hash_input.encode()).hexdigest()
        
        finish_params = [char_id, mission_id, battle_id, finish_mission_hash, 0, sessionkey, BATTLE_HASH, 0]
        finish_res = await client.send_amf_request("BattleSystem.finishMission", finish_params)
        return f"Mission {mission_id} Complete! Reward: {finish_res}"
    else:
        return f"Failed to start mission {mission_id}: {start_res}"

async def run_hunting(client: NinjaSageClient, sessionkey: str, char_id: int, zone: int):
    start_res = await client.send_amf_request("JDEUnbiWJXOtHxVv.CCQV8v8GpKBY", [char_id, zone, sessionkey])
    if start_res.get('status') == 1 and 'battle_code' in start_res:
        battle_code = start_res['battle_code']
        await asyncio.sleep(1)
        finish_res = await client.send_amf_request("JDEUnbiWJXOtHxVv.wrlPOTLOEWFE", [char_id, zone, battle_code, 1, sessionkey, []])
        return f"Boss Defeated! Drop: {finish_res}"
    else:
        return f"Failed to start hunting: {start_res}"

async def auto_shadow_war(client: NinjaSageClient, sessionkey: str, char_id: int):
    # Get shadow war enemies
    enemies_res = await client.send_amf_request("ShadowWar.executeService", [["getEnemies", [char_id, sessionkey]]])
    if not isinstance(enemies_res, dict) or 'enemies' not in enemies_res or not enemies_res['enemies']:
        return "Failed to get Shadow War enemies or no enemies available."
        
    enemy = enemies_res['enemies'][0]
    enemy_id = enemy['id']
    enemy_name = enemy.get('name', 'Unknown')
    
    # Start match
    start_res = await client.send_amf_request("ShadowWar.executeService", [["startBattle", [char_id, sessionkey, enemy_id]]])
    if start_res.get('status') == 1 and 'id' in start_res:
        battle_id = start_res['id']
        await asyncio.sleep(1)
        
        # Finish match
        battle_hash_const = "e89c256038cc9603" # BATTLE_HASH from apk config
        hash_str = f"{char_id}{battle_id}0{battle_hash_const}"
        mission_hash = hashlib.sha256(hash_str.encode('utf-8')).hexdigest()
        
        finish_res = await client.send_amf_request("ShadowWar.executeService", [["finishBattle", [char_id, sessionkey, battle_id, 0, battle_hash_const, mission_hash]]])
        return f"Shadow War Complete against {enemy_name}! Reward: {finish_res}"
    else:
        return f"Failed to start Shadow War: {start_res}"

async def auto_monster_hunt(client: NinjaSageClient, sessionkey: str, char_id: int):
    # Monster Hunt missions typically use standard run_mission with specific IDs
    # e.g., msn_163 could be a monster hunt event
    return await run_mission(client, sessionkey, char_id, "msn_163")

async def auto_mission_s(client: NinjaSageClient, sessionkey: str, char_id: int):
    # Mission S uses specific high tier mission IDs
    # Using placeholder msn_s1
    return await run_mission(client, sessionkey, char_id, "msn_s1")

async def auto_clan_war(client: NinjaSageClient, sessionkey: str, char_id: int):
    import httpx
    import random
    import string
    
    clan_base_url = "https://clan.ninjasage.id"
    # Ninja Sage ID Clan War uses a separate REST API
    async with httpx.AsyncClient(verify=False) as http:
        # 1. Authenticate to Clan API
        auth_resp = await http.post(f"{clan_base_url}/auth/login", json={"char_id": char_id, "session_key": sessionkey})
        if auth_resp.status_code != 200:
            return f"Clan War Auth Failed: {auth_resp.text}"
            
        auth_data = auth_resp.json()
        token = auth_data.get("token") or auth_data.get("access_token")
        if not token:
            return "Clan War Auth Failed: No token received"
            
        headers = {"Authorization": f"Bearer {token}"}
        
        # 2. Get opponents
        opp_resp = await http.post(f"{clan_base_url}/battle/opponents", json={}, headers=headers)
        if opp_resp.status_code != 200:
            return f"Failed to get Clan War opponents: {opp_resp.text}"
            
        opp_data = opp_resp.json()
        clans = opp_data.get("clans", [])
        if not clans:
            return "No clan opponents found"
            
        # Pick the first opponent clan
        opponent = clans[0]
        opponent_id = opponent['id']
        opponent_name = opponent.get('name', str(opponent_id))
        
        # 3. Quick battle
        code = "".join(random.choices(string.ascii_letters + string.digits, k=24))
        battle_resp = await http.post(f"{clan_base_url}/battle/quick/{opponent_id}", json={"code": code}, headers=headers)
        
        if battle_resp.status_code == 200:
            reward_data = battle_resp.json()
            return f"Clan War against {opponent_name} Complete! Reward: {reward_data}"
        else:
            return f"Clan War failed: {battle_resp.text}"

async def auto_exam(client: NinjaSageClient, sessionkey: str, char_id: int):
    # Retrieve char data to check level and rank
    char_data_res = await client.send_amf_request("CharacterDAO.getById", [char_id, sessionkey])
    if char_data_res.get('status') != 1:
        return "Failed to get character data for exam"
    
    char = char_data_res['character']
    level = char.get('level', 1)
    rank = char.get('rank', 1)
    
    # 1. Genin -> Chunin (Level 20)
    if level >= 20 and rank < 2:
        exam_data = await client.send_amf_request("ChuninExam.getData", [sessionkey, char_id])
        if exam_data.get('status') == 1:
            stage = exam_data.get('progress', 0)
            if stage < 5:
                # Need to complete stages 1-5 (index 0 to 4)
                await client.send_amf_request("ChuninExam.startStage", [char_id, stage, sessionkey])
                await asyncio.sleep(1)
                # Stage 1 needs special payload (2, 0, 0, 0), others might just need empty or none
                finish_params = [sessionkey, char_id, 2, 0, 0, 0] if stage == 0 else [sessionkey, char_id]
                res = await client.send_amf_request("ChuninExam.finishStage", finish_params)
                return f"Chunin Exam Stage {stage+1} completed! {res}"
            else:
                # All stages done, promote!
                res = await client.send_amf_request("ChuninExam.promoteToChunin", [sessionkey, char_id])
                return f"Promoted to Chunin! {res}"
        return f"Chunin Exam data: {exam_data}"
        
    # 2. Chunin -> Jounin (Level 40)
    elif level >= 40 and rank < 3:
        # Simplistic implementation logic based on APK decompilation
        exam_data = await client.send_amf_request("JouninExam.getData", [sessionkey, char_id])
        if exam_data.get('status') == 1:
            stage = exam_data.get('progress', 0)
            if stage < 6:
                await client.send_amf_request("JouninExam.startStage", [char_id, stage, sessionkey])
                await asyncio.sleep(1)
                res = await client.send_amf_request("JouninExam.finishStage", [sessionkey, char_id])
                return f"Jounin Exam Stage {stage+1} completed! {res}"
            else:
                res = await client.send_amf_request("JouninExam.promoteToJounin", [sessionkey, char_id])
                return f"Promoted to Jounin! {res}"
        return f"Jounin Exam data: {exam_data}"
        
    # Add higher exams (Special Jounin, Ninja Tutor) similarly if needed...
    
    return f"No exams available for Level {level} Rank {rank}"

async def auto_eudemon(client: NinjaSageClient, sessionkey: str, char_id: int):
    # 1. Get Char Level
    char_data_res = await client.send_amf_request("CharacterDAO.getById", [char_id, sessionkey])
    if char_data_res.get('status') != 1:
        return "Failed to get character data for Eudemon"
    char_level = char_data_res.get('character', {}).get('level', 1)
    
    # 2. Get available bosses
    avail_res = await client.send_amf_request("EudemonGarden.getData", [sessionkey, char_id])
    if "data" not in avail_res:
        return "Eudemon boss response missing 'data'"
        
    avail_raw = avail_res["data"]
    if not avail_raw:
        return "No boss entries"
        
    # avail_bosses is a list of integers representing how many times we can fight each boss
    avail_bosses = list(map(int, avail_raw.split(",")))
    
    # 3. Load gamedata.json
    import json
    import os
    try:
        with open(os.path.join(os.path.dirname(__file__), "..", "data", "gamedata.json"), "r", encoding="utf-8") as f:
            gamedata = json.load(f)
    except Exception as e:
        return f"Failed to load gamedata.json: {e}"
        
    eudemon_entry = next((item for item in gamedata if item.get('id') == 'eudemon'), None)
    if not eudemon_entry:
        return "Eudemon gamedata not found"
        
    bosses = eudemon_entry["data"]["bosses"]
    results = []
    
    for b in bosses:
        if int(b["lvl"]) > char_level:
            break
            
        boss_index = b.get("num", 0)
        boss_name = b.get("name", "Unknown Boss")
        
        # If boss_index is out of range, skip
        if boss_index >= len(avail_bosses):
            continue
            
        attempts = avail_bosses[boss_index]
        for i in range(attempts):
            import asyncio
            import hashlib
            
            # Start Hunting
            start_res = await client.send_amf_request("EudemonGarden.startHunting", [char_id, boss_index, sessionkey])
            if start_res.get("status") != 1:
                results.append(f"Failed to start {boss_name}: {start_res}")
                continue
                
            battle_id = str(start_res.get("code", ""))
            
            # Wait for battle (2 seconds simulate)
            await asyncio.sleep(2)
            
            # Finish Hunting
            # Hash logic: md5(str(boss_index) + str(char_id) + battle_id)
            loc2_str = str(boss_index) + str(char_id) + battle_id
            loc2 = hashlib.md5(loc2_str.encode()).hexdigest()
            
            BATTLE_HASH = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDEiLCJiYWNrX2l0ZW0iOiJiYWNrXzAxIiwid2VhcG9uIjoid3BuXzAxIiwic2V0Ijoic2V0XzAxXzAifSwic3RhdHVzIjp7ImVhcnRoIjowLCJmaXJlIjowLCJ3YXRlciI6MCwibGlnaHRuaW5nIjowLCJ3aW5kIjowfSwiYnl0ZXMiOnsiXyI6ODIyODQ0NywiX18iOjgyMjg0NDcsIl9fXyI6IjE3NjI3NDY2NTk0MDM2N2MzY2M5OTlhOWY5ZTk1MWExZDMzMjExNTQ1Yjg0YjJkNWE2MzkzM2IwMDIwNDMzMDAwYzNiYjQxMGZiMTc2Mjc0NjY1OTE3NjI3NDY2NTkxNzYyNzQ2NjU5MTc2Mjc0NjY1OSIsIl9fX19fIjo4MjI4NDQ3LCJfX19fX18iOjgyMjg0NDcsIl9fX18iOjE3NjI3NDY2NTl9LCJfX19fIjpbeyJfIjoic2tpbGxfMTMiLCJfXyI6MjkxMzR9XX0="
            
            finish_params = [char_id, boss_index, battle_id, loc2, sessionkey, BATTLE_HASH]
            finish_res = await client.send_amf_request("EudemonGarden.finishHunting", finish_params)
            
            if finish_res.get("status") == 1:
                xp = finish_res.get("result", [0,0])[0]
                gold = finish_res.get("result", [0,0])[1]
                results.append(f"Defeated {boss_name} {i+1}/{attempts} - Gained XP: {xp}, Gold: {gold}")
            else:
                results.append(f"Failed to defeat {boss_name}: {finish_res}")
                
    if not results:
        return "No Eudemon Bosses fought (maybe out of attempts)."
    return " | ".join(results)

async def run_circus_event(client: NinjaSageClient, sessionkey: str, char_id: int, boss_type: str = "ringmaster"):
    # 1. Get Character Data to calculate agility and _loc6_
    print(f"DEBUG CIRCUS: char_id={char_id} type={type(char_id)} sessionkey={sessionkey[:20]}... boss_type={boss_type}")
    try:
        char_info_res = await client.send_amf_request("36a62s4oZ7iYRJjd.iakN46g0GaJN", [[char_id, sessionkey, char_id, "EVENT"]])
        print(f"DEBUG CIRCUS getCharData: type={type(char_info_res).__name__} val={char_info_res}")
    except Exception as e:
        return f"Failed to fetch character data: {e}"
    
    if not isinstance(char_info_res, dict) or not hasattr(char_info_res, 'get'):
        # Try to get error details from ErrorFault
        err_detail = ""
        if hasattr(char_info_res, 'description'):
            err_detail = f" desc={char_info_res.description}"
        if hasattr(char_info_res, 'code'):
            err_detail += f" code={char_info_res.code}"
        if hasattr(char_info_res, 'details'):
            err_detail += f" details={char_info_res.details}"
        return f"Failed to fetch character data: server returned {type(char_info_res).__name__}{err_detail}"
    
    if char_info_res.get('status') != 1:
        return f"Failed to fetch character data: {char_info_res}"
        
    char_data = char_info_res.get('character_data', {})
    if not isinstance(char_data, dict):
        char_data = {}
    char_agility = char_data.get('agility', 0)
    
    # Simulate _loc6_ equipment encoding logic
    loc5 = {
        "status": {
            "wind": char_data.get('atrrib_wind', 0),
            "fire": char_data.get('atrrib_fire', 0),
            "lightning": char_data.get('atrrib_lightning', 0),
            "water": char_data.get('atrrib_water', 0),
            "earth": char_data.get('atrrib_earth', 0)
        },
        "items": {
            "weapon": char_data.get('character_weapon', ''),
            "set": char_data.get('character_set', ''),
            "back_item": char_data.get('character_back_item', ''),
            "accessory": char_data.get('character_accessory', '')
        },
        "____": [],
        "bytes": {
            "_": 100000, "__": 100000, "___": "1", "____": "1", "_____": 100000, "______": 100000
        }
    }
    
    loc6_str = base64.b64encode(json.dumps(loc5).encode('utf-8')).decode('utf-8')
    
    # 2. Start Event
    if boss_type == "jester":
        boss_id = 312610
        ene_id = "ene_2135"
        hp = 114000
        enemy_agility = 166
        
        # Jester requires using a ticket first (item_48)
        try:
            item_res = await client.send_amf_request("36a62s4oZ7iYRJjd.zLYzbsmF8811", [[sessionkey, char_id, "item_48"]])
            print(f"DEBUG CIRCUS Jester Ticket Use: {item_res}")
        except Exception as e:
            return f"Failed to use Jester ticket: {e}"
            
    else: # default to ringmaster
        boss_id = 312610 
        ene_id = "ene_2134"
        hp = 34200
        enemy_agility = 186
    
    enemy_info_str = f"id:{ene_id}|hp:{hp}|agility:{enemy_agility}"
    
    hash_start_str = str(char_id) + ene_id + enemy_info_str + str(char_agility)
    hash_start = hashlib.sha256(hash_start_str.encode('utf-8')).hexdigest()
    
    try:
        start_res = await client.send_amf_request("Yg8TZbNQrrhSci2l.QBUJb0w3NBsX", [[
            char_id, ene_id, char_agility, enemy_info_str, hash_start, sessionkey
        ]])
    except Exception as e:
        return f"Failed to start Circus Event: {e}"
    
    if not isinstance(start_res, dict) or not hasattr(start_res, 'get'):
        return f"Failed to start Circus Event: server returned {type(start_res).__name__}"
    
    if start_res.get('status') != 1 or 'code' not in start_res:
        return f"Failed to start Circus Event: {start_res}"
        
    battle_code = start_res['code']
    
    # 3. Wait for battle
    await asyncio.sleep(3)
    
    # 4. Finish Event
    if boss_type == "jester":
        damage_done = 300308  # From Charles Proxy for Jester
    else:
        damage_done = hp
        
    hash_end_str = str(char_id) + ene_id + battle_code + str(damage_done) + loc6_str
    
    hash_end = hashlib.sha256(hash_end_str.encode('utf-8')).hexdigest()
    
    try:
        finish_res = await client.send_amf_request("Yg8TZbNQrrhSci2l.fRGiPcIczAbE", [[
            char_id, ene_id, battle_code, damage_done, hash_end, loc6_str, sessionkey
        ]])
    except Exception as e:
        return f"Circus Event finish failed: {e}"
    
    return f"Circus Event Complete! Reward: {finish_res}"

async def run_yokai_event(client: NinjaSageClient, sessionkey: str, char_id: int, boss_type: str = "kitsune"):
    # 1. Get Character Data
    try:
        char_info_res = await client.send_amf_request("36a62s4oZ7iYRJjd.iakN46g0GaJN", [[char_id, sessionkey, char_id, "EVENT"]])
    except Exception as e:
        return f"Failed to fetch character data: {e}"
    
    if not isinstance(char_info_res, dict) or not hasattr(char_info_res, 'get'):
        err_detail = ""
        if hasattr(char_info_res, 'description'):
            err_detail = f" desc={char_info_res.description}"
        if hasattr(char_info_res, 'code'):
            err_detail += f" code={char_info_res.code}"
        if hasattr(char_info_res, 'details'):
            err_detail += f" details={char_info_res.details}"
        return f"Failed to fetch character data: server returned {type(char_info_res).__name__}{err_detail}"
    
    if char_info_res.get('status') != 1:
        return f"Failed to fetch character data: {char_info_res}"
        
    char_data = char_info_res.get('character_data', {})
    if not isinstance(char_data, dict):
        char_data = {}
    char_agility = char_data.get('agility', 0)
    
    loc5 = {
        "status": {
            "wind": char_data.get('atrrib_wind', 0),
            "fire": char_data.get('atrrib_fire', 0),
            "lightning": char_data.get('atrrib_lightning', 0),
            "water": char_data.get('atrrib_water', 0),
            "earth": char_data.get('atrrib_earth', 0)
        },
        "items": {
            "weapon": char_data.get('character_weapon', ''),
            "set": char_data.get('character_set', ''),
            "back_item": char_data.get('character_back_item', ''),
            "accessory": char_data.get('character_accessory', '')
        },
        "____": [],
        "bytes": {
            "_": 100000, "__": 100000, "___": "1", "____": "1", "_____": 100000, "______": 100000
        }
    }
    loc6_str = base64.b64encode(json.dumps(loc5).encode('utf-8')).decode('utf-8')
    
    # 2. Start Event
    if boss_type == "kitsune":
        boss_id = 312610
        ene_id = "ene_2133"
        hp = 60800
        enemy_agility = 171
        
        # Kitsune requires item_27
        try:
            item_res = await client.send_amf_request("36a62s4oZ7iYRJjd.zLYzbsmF8811", [[sessionkey, char_id, "item_27"]])
        except Exception as e:
            return f"Failed to use Yokai ticket: {e}"
    elif boss_type == "tengu":
        boss_id = 312610
        ene_id = "ene_2132"
        hp = 75924
        enemy_agility = 176
        
        # Tengu requires item_31
        try:
            item_res = await client.send_amf_request("36a62s4oZ7iYRJjd.zLYzbsmF8811", [[sessionkey, char_id, "item_31"]])
        except Exception as e:
            return f"Failed to use Tengu ticket: {e}"
    elif boss_type == "nurarihyon":
        boss_id = 312610
        ene_id = "ene_2131"
        hp = 114000
        enemy_agility = 176
        # No ticket observed for Nurarihyon based on Charles logs
    else:
        return f"Unknown yokai boss type: {boss_type}"
    
    enemy_info_str = f"id:{ene_id}|hp:{hp}|agility:{enemy_agility}"
    
    hash_start_str = str(char_id) + ene_id + enemy_info_str + str(char_agility)
    hash_start = hashlib.sha256(hash_start_str.encode('utf-8')).hexdigest()
    
    try:
        start_res = await client.send_amf_request("urUACOuL6PahuoEd.MTpVa9K3yFwo", [[
            char_id, ene_id, char_agility, enemy_info_str, hash_start, sessionkey
        ]])
    except Exception as e:
        return f"Failed to start Yokai Event: {e}"
    
    if not isinstance(start_res, dict) or not hasattr(start_res, 'get'):
        return f"Failed to start Yokai Event: server returned {type(start_res).__name__}"
    
    if start_res.get('status') != 1 or 'code' not in start_res:
        return f"Failed to start Yokai Event: {start_res}"
        
    battle_code = start_res['code']
    
    # 3. Wait for battle
    await asyncio.sleep(3)
    
    # 4. Finish Event
    if boss_type == "kitsune":
        damage_done = 60800 # from charles
    elif boss_type == "tengu":
        damage_done = 75924 # from charles
    elif boss_type == "nurarihyon":
        damage_done = 250800 # from charles
    else:
        damage_done = hp
        
    hash_end_str = str(char_id) + ene_id + battle_code + str(damage_done) + loc6_str
    hash_end = hashlib.sha256(hash_end_str.encode('utf-8')).hexdigest()
    
    try:
        finish_res = await client.send_amf_request("urUACOuL6PahuoEd.4nI6yGEvtUni", [[
            char_id, ene_id, battle_code, damage_done, hash_end, loc6_str, sessionkey
        ]])
    except Exception as e:
        return f"Yokai Event finish failed: {e}"
    
    return f"Yokai Event Complete! Reward: {finish_res}"

