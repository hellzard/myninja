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

def calculate_agility(char_data_res: dict) -> int:
    char_data = char_data_res.get('character_data', char_data_res)
    agility = 10
    if 'status' in char_data and 'wind' in char_data['status']:
        agility += char_data['status']['wind'] * 1
    # Note: real calculation includes gear, but often server accepts it if no gear is equipped or hash isn't strictly validated on agility
    return agility

BATTLE_HASH = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDEiLCJiYWNrX2l0ZW0iOiJiYWNrXzAxIiwid2VhcG9uIjoid3BuXzAxIiwic2V0Ijoic2V0XzAxXzAifSwic3RhdHVzIjp7ImVhcnRoIjowLCJmaXJlIjowLCJ3YXRlciI6MCwibGlnaHRuaW5nIjowLCJ3aW5kIjowfSwiYnl0ZXMiOnsiXyI6ODIyODQ0NywiX18iOjgyMjg0NDcsIl9fXyI6IjE3NjI3NDY2NTk0MDM2N2MzY2M5OTlhOWY5ZTk1MWExZDMzMjExNTQ1Yjg0YjJkNWE2MzkzM2IwMDIwNDMzMDAwYzNiYjQxMGZiMTc2Mjc0NjY1OTE3NjI3NDY2NTkxNzYyNzQ2NjU5MTc2Mjc0NjY1OSIsIl9fX19fIjo4MjI4NDQ3LCJfX19fX18iOjgyMjg0NDcsIl9fX18iOjE3NjI3NDY2NTl9LCJfX19fIjpbeyJfIjoic2tpbGxfMTMiLCJfXyI6MjkxMzR9XX0="

async def run_mission(client: NinjaSageClient, sessionkey: str, char_id: int, mission_id: str):
    SAGE_SCROLL_MINIGAME_MISSION_IDS = {'msn_109', 'msn_110', 'msn_111'}
    if mission_id in SAGE_SCROLL_MINIGAME_MISSION_IDS:
        start_res = await client.send_amf_request("BattleSystem.startSageScrollMiniGame", [char_id, sessionkey, mission_id])
        if isinstance(start_res, dict) and 'status' in start_res and start_res['status'] != 1:
            return f"Failed to start Sage Scroll mission {mission_id}: {start_res}"
            
        battle_id = str(start_res) if not isinstance(start_res, dict) else str(start_res.get('battle_code', start_res.get('id', start_res)))
        await asyncio.sleep(2)
        finish_res = await client.send_amf_request("BattleSystem.finishSageScrollMiniGame", [char_id, sessionkey, battle_id])
        return f"Sage Scroll Mission {mission_id} Complete! Reward: {finish_res}"
        
    mission_info = get_data_by_id(mission_id, MISSION_DATA)
    if not mission_info:
        return f"Unknown mission_id {mission_id}"
        
    char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
    if char_data_res.get('status') == 0:
        return f"Failed to get character data: {char_data_res.get('error', 'Unknown error')}"
    char_data = char_data_res
    agility = calculate_agility(char_data)
    
    enemies = mission_info.get("enemies", [])
    enemy_attrs = []
    for enemy in enemies:
        enemy_attr = get_data_by_id(enemy, ENEMY_DATA)
        hp = enemy_attr.get("hp", 0)
        ene_agi = enemy_attr.get("agility", 0)
        enemy_attrs.append(f"id:{enemy}|hp:{hp}|agility:{ene_agi}")
        
    hash_input = ",".join(enemies) + "#".join(enemy_attrs) + str(agility)
    mission_hash = hashlib.sha256(hash_input.encode()).hexdigest()
    
    start_params = [char_id, mission_id, ",".join(enemies), "#".join(enemy_attrs), agility, mission_hash, sessionkey]
    
    start_res = await client.send_amf_request("BattleSystem.startMission", start_params)
    
    # APK treats the response directly as battle_id.
    # Server may return: a raw value (int/str), or a dict with status/error info.
    if isinstance(start_res, dict):
        if start_res.get('status') == 2 or start_res.get('error') is not None:
            return f"Failed to start mission {mission_id}: {start_res}"
        battle_id = str(start_res.get('battle_code', start_res.get('code', start_res.get('id', ''))))
    else:
        battle_id = str(start_res)
    
    if not battle_id or battle_id == 'None':
        return f"Failed to start mission {mission_id}: No battle_id in response: {start_res}"
    
    await asyncio.sleep(1)
    
    finish_hash_input = f"{mission_id}{char_id}{battle_id}0"
    finish_mission_hash = hashlib.sha256(finish_hash_input.encode()).hexdigest()
    
    finish_params = [char_id, mission_id, battle_id, finish_mission_hash, 0, sessionkey, BATTLE_HASH, 0]
    finish_res = await client.send_amf_request("BattleSystem.finishMission", finish_params)
    return f"Mission {mission_id} Complete! Reward: {finish_res}"

async def auto_daily_event(client: NinjaSageClient, sessionkey: str, char_id: int):
    # 1. Fetch Char Data
    char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
    if isinstance(char_data_res, dict) and char_data_res.get('status') == 1:
        char_obj = char_data_res.get('data', {})
        level = int(char_obj.get('character_level', char_obj.get('level', 1)))
        rank_val = char_obj.get('character_rank') or char_obj.get('character_data_character_rank') or char_obj.get('rank') or 1
        try:
            rank = int(rank_val)
        except (ValueError, TypeError):
            rank = 1
    else:
        return "Failed to load character data for daily events"

    # 2. Get Mission Room Data
    room_data = await client.send_amf_request("CharacterService.getMissionRoomData", [char_id, sessionkey])
    if not isinstance(room_data, dict) or room_data.get('status') != 1:
        return "No available daily missions (or failed to fetch)"

    def _normalize(missions):
        items = []
        if isinstance(missions, list):
            for m in missions:
                if isinstance(m, dict):
                    m_id = str(m.get("id", ""))
                    available = m.get("available", m.get("run_count", 0))
                    if m_id:
                        run_count = max(0, int(available))
                        if run_count > 0:
                            items.append((m_id, run_count))
            return items
        
        if not isinstance(missions, dict):
            return items
            
        for m_id, available in missions.items():
            run_count = max(0, int(available))
            if run_count > 0:
                items.append((str(m_id), run_count))
        return items

    daily_entries = _normalize(room_data.get('daily'))
    tp_entries = _normalize(room_data.get('tp'))
    ss_entries = _normalize(room_data.get('ss'))

    # APK Rules: TP requires Level 40 and Rank 5
    if level < 40 or rank < 5:
        tp_entries = []
    
    # APK Rules: SS requires Level 80 and Rank 9
    if level < 80 or rank < 9:
        ss_entries = []

    # Run the first available mission, prioritizing Daily -> TP -> SS
    for m_id, _ in daily_entries:
        return await run_mission(client, sessionkey, char_id, m_id)
    
    for m_id, _ in tp_entries:
        return await run_mission(client, sessionkey, char_id, m_id)

    for m_id, _ in ss_entries:
        return await run_mission(client, sessionkey, char_id, m_id)

    return "Daily missions completed"

async def run_hunting(client: NinjaSageClient, sessionkey: str, char_id: int, zone: int):
    import hashlib
    import asyncio
    
    RIFT_HUNTING_HOUSE_BOSSES = [
        {'num': 0, 'name': 'Ginkotsu'},
        {'num': 1, 'name': 'Shikigami Yanki'},
        {'num': 2, 'name': 'Gedo Sessho Seki'},
        {'num': 3, 'name': 'Tengu'},
        {'num': 4, 'name': 'Byakko'},
        {'num': 5, 'name': 'Ape King'},
        {'num': 6, 'name': 'Battle Turtle'},
        {'num': 7, 'name': 'Soul General Mutoh'},
        {'num': 8, 'name': 'Calamity Serpent'},
        {'num': 9, 'name': 'Kojima'},
        {'num': 16, 'name': 'The Mother & Father of Ghosts'},
        {'num': 17, 'name': 'Moon Princess & Black Puppets'}
    ]
    
    boss_num = zone - 1
    boss_info = next((b for b in RIFT_HUNTING_HOUSE_BOSSES if b['num'] == boss_num), None)
    if not boss_info:
        return f"Unknown boss zone: {zone}"
        
    # Get custom Hunting House data
    get_data_res = await client.send_amf_request("HuntingHouse.getData", [char_id, sessionkey])
    
    if isinstance(get_data_res, dict) and get_data_res.get('status') == 1:
        material = get_data_res.get('material', 0)
        if material <= 0:
            return f"Stopped: You do not have enough material ({material})."
            
    # The server expects 1-indexed zone for this custom feature
    start_res = await client.send_amf_request("JDEUnbiWJXOtHxVv.CCQV8v8GpKBY", [char_id, zone, sessionkey])
    
    if isinstance(start_res, dict) and start_res.get('status') == 1 and 'battle_code' in start_res:
        battle_code = start_res['battle_code']
        await asyncio.sleep(2)
        
        # Original finish endpoint for custom hunting house: [char_id, zone, battle_code, win, sessionkey, drops]
        finish_res = await client.send_amf_request("JDEUnbiWJXOtHxVv.wrlPOTLOEWFE", [char_id, zone, battle_code, 1, sessionkey, []])
        
        if isinstance(finish_res, dict) and finish_res.get('status') == 1:
            return f"Hunting House Zone {zone} Cleared! Rewards: {finish_res.get('result', [])}"
        else:
            return f"Failed to finish hunting: {finish_res}"
    else:
        error_msg = start_res.get('result', start_res) if isinstance(start_res, dict) else start_res
        return f"Failed to start hunting: {error_msg}"

async def auto_shadow_war(client: NinjaSageClient, sessionkey: str, char_id: int):
    # 1. Check Event Status and Energy
    status_res = await client.send_amf_request("ShadowWar.executeService", ["getStatus", [char_id, sessionkey]])
    if not isinstance(status_res, dict) or status_res.get('status') != 1:
        return f"Shadow War unavailable: {status_res}"
        
    energy = int(status_res.get('energy', 0))
    if energy < 10:
        # Try to refill energy
        refill_res = await client.send_amf_request("ShadowWar.executeService", ["refillEnergy", [char_id, sessionkey]])
        if isinstance(refill_res, dict) and str(refill_res.get('status')) == "1":
            energy = 100 # Refilled
        else:
            raise Exception(f"Shadow War energy empty ({energy}) and refill failed: {refill_res}")
            
    # 2. Get Enemies
    enemies_res = await client.send_amf_request("ShadowWar.executeService", ["getEnemies", [char_id, sessionkey]])
    if not isinstance(enemies_res, dict) or "enemies" not in enemies_res or not enemies_res["enemies"]:
        return "No Shadow War enemies available right now."
        
    enemy = enemies_res["enemies"][0]
    enemy_id = enemy.get("id")
    enemy_name = enemy.get("name", str(enemy_id))
    
    # 3. Start Battle
    start_res = await client.send_amf_request("ShadowWar.executeService", ["startBattle", [char_id, sessionkey, enemy_id]])
    if not isinstance(start_res, dict) or start_res.get("status") != 1:
        raise Exception(f"Failed to start Shadow War against {enemy_name}: {start_res}")
        
    battle_id = start_res.get("id")
    await asyncio.sleep(2)
    
    # 4. Finish Battle
    hash_input = f"{char_id}{battle_id}0{BATTLE_HASH}"
    mission_hash = hashlib.sha256(hash_input.encode()).hexdigest()
    
    finish_params = [char_id, sessionkey, battle_id, 0, BATTLE_HASH, mission_hash]
    finish_res = await client.send_amf_request("ShadowWar.executeService", ["finishBattle", finish_params])
    
    if finish_res.get("status") == 1:
        result_payload = finish_res.get("result", [])
        xp = result_payload[0] if len(result_payload) > 0 else "n/a"
        gold = result_payload[1] if len(result_payload) > 1 else "n/a"
        win_trophy = finish_res.get("win_trophy", "n/a")
        return f"Shadow War Victory against {enemy_name}! XP: {xp}, Gold: {gold}, Trophy won: {win_trophy}"
    else:
        return f"Shadow War Battle Failed: {finish_res}"

async def auto_monster_hunt(client: NinjaSageClient, sessionkey: str, char_id: int):
    import hashlib
    import asyncio
    
    # Constants
    EQUIPMENT_DATA = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDEiLCJiYWNrX2l0ZW0iOiJiYWNrXzIzODEiLCJ3ZWFwb24iOiJ3cG5fMjM4MCIsInNldCI6InNldF8yMjU4XzEifSwic3RhdHVzIjp7ImVhcnRoIjowLCJsaWdodG5pbmciOjAsImZpcmUiOjAsIndhdGVyIjowLCJ3aW5kIjo3OH0sImJ5dGVzIjp7Il9fXyI6IjE3NjM4Nzk1ODk0MDM2N2MzY2M5OTlhOWY5ZTk1MWExZDMzMjExNTQ1Yjg0YjJkNWE2MzkzM2IwMDIwNDMzMDAwYzNiYjQxMGZiMTc2Mzg3OTU4OTE3NjM4Nzk1ODkxNzYzODc5NTg5MTc2Mzg3OTU4OSIsIl8iOjgyMjg0NDcsIl9fX18iOjE3NjM4Nzk1ODksIl9fX19fIjo4MjI4NDQ3LCJfXyI6ODIyODQ0NywiX19fX19fIjo4MjI4NDQ3fSwiX19fXyI6W3siXyI6InNraWxsXzIzMTIiLCJfXyI6NTQ2MDV9LHsiXyI6InNraWxsXzM0NSIsIl9fIjo4MDI0M30seyJfIjoic2tpbGxfMjMxMCIsIl9fIjoxMjg0Njl9LHsiXyI6InNraWxsXzIyMTUiLCJfXyI6MjkzNDl9LHsiXyI6InNraWxsXzIyODYiLCJfXyI6NDk0NzR9LHsiXyI6InNraWxsXzIyMDYiLCJfXyI6NjA5NDR9LHsiXyI6InNraWxsXzIzMDgiLCJfXyI6NjUxMDF9LHsiXyI6InNraWxsXzMyOSIsIl9fIjo3NTM1Nn1dfQ=="
    
    # 1. Get Event Data
    event_res = await client.send_amf_request("MonsterHunterEvent2023.getEventData", [char_id, sessionkey])
    if event_res.get('status') != 1:
        return f"Failed to get Monster Hunt data: {event_res}"
        
    boss_id = event_res.get('boss_id', '')
    energy = event_res.get('energy', 0)
    
    if energy < 10:
        return f"Not enough energy to hunt. Current: {energy}/10 required."
        
    # 2. Start Battle
    # hash(char_id + boss_id)
    start_hash_str = str(char_id) + str(boss_id)
    start_hash = hashlib.sha256(start_hash_str.encode()).hexdigest()
    
    start_res = await client.send_amf_request("MonsterHunterEvent2023.startBattle", [char_id, boss_id, start_hash, sessionkey])
    if start_res.get("status") != 1:
        return f"Failed to start battle: {start_res}"
        
    battle_id = str(start_res.get("code", ""))
    await asyncio.sleep(2)
    
    # 3. Finish Battle
    # hash(char_id + boss_id + battle_id + "0" + equipment_data)
    finish_hash_str = str(char_id) + str(boss_id) + battle_id + "0" + EQUIPMENT_DATA
    finish_hash = hashlib.sha256(finish_hash_str.encode()).hexdigest()
    
    finish_res = await client.send_amf_request("MonsterHunterEvent2023.finishBattle", [
        char_id, boss_id, battle_id, 0, finish_hash, EQUIPMENT_DATA, sessionkey
    ])
    
    if finish_res.get("status") == 1:
        rewards = finish_res.get("result", [])
        if len(rewards) >= 2:
            return f"Monster Hunt {boss_id} Completed! Energy left: {energy-10}. Gained {rewards[0]} XP, {rewards[1]} Gold."
        return f"Monster Hunt {boss_id} Completed! Result: {rewards}"
    else:
        return f"Battle failed: {finish_res}"

async def auto_mission_s(client: NinjaSageClient, sessionkey: str, char_id: int):
    import hashlib
    import asyncio
    
    MISSION_S_STAGE_CONFIG = {
        1: {'mission_id': 'msn_112', 'energy_cost': 10, 'min_level': 80},
        2: {'mission_id': 'msn_113', 'energy_cost': 12, 'min_level': 81},
        3: {'mission_id': 'msn_114', 'energy_cost': 14, 'min_level': 82},
        4: {'mission_id': 'msn_115', 'energy_cost': 16, 'min_level': 83},
        5: {'mission_id': 'msn_116', 'energy_cost': 25, 'min_level': 84},
    }
    MISSION_S_FINISH_DAMAGE = 235000

    # 1. Get Char data to find level
    char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
    if char_data_res.get('status') == 0:
        return f"Failed to get character data for Mission S: {char_data_res.get('error', 'Unknown error')}"
    char_data = char_data_res
    char_obj = char_data.get('character_data', char_data)
    char_level = int(char_obj.get('character_level', char_obj.get('level', 0)))
    if char_level < 80:
        raise Exception(f"Mission S requires level 80. Current level: {char_level}")

    # 2. Get Mission S Data
    msn_s_data = await client.send_amf_request("BattleSystem.getMissionSData", [char_id, sessionkey])
    if not isinstance(msn_s_data, dict) or msn_s_data.get('status') != 1:
        return f"Failed to get Mission S data: {msn_s_data}"
        
    unlocked_stage = int(msn_s_data.get('stage', 0))
    energy = int(msn_s_data.get('energy', 0))
    max_energy = int(msn_s_data.get('max_energy', 0))
    
    # 3. Resolve stage to run
    stage_to_run = None
    for stage in range(min(unlocked_stage, 5), 0, -1):
        stage_cfg = MISSION_S_STAGE_CONFIG.get(stage)
        if stage_cfg and char_level >= stage_cfg['min_level'] and energy >= stage_cfg['energy_cost']:
            stage_to_run = stage
            break
            
    if stage_to_run is None:
        raise Exception(f"Mission S has no unlocked stage available for level {char_level} and energy {energy}/{max_energy}")
        
    stage_cfg = MISSION_S_STAGE_CONFIG[stage_to_run]
    mission_id = stage_cfg['mission_id']
    
    mission_info = get_data_by_id(mission_id, MISSION_DATA)
    if not mission_info:
        return f"Unknown mission_id {mission_id} for Mission S"
        
    # Calculate agility
    agility = calculate_agility(char_data)
    
    # Prepare enemies
    enemies = mission_info.get("enemies", [])
    enemy_attrs = []
    for enemy in enemies:
        enemy_attr = get_data_by_id(enemy, ENEMY_DATA)
        hp = enemy_attr.get("hp", 0)
        ene_agi = enemy_attr.get("agility", 0)
        enemy_attrs.append(f"id:{enemy}|hp:{hp}|agility:{ene_agi}")
        
    hash_input = ",".join(enemies) + "#".join(enemy_attrs) + str(agility)
    mission_hash = hashlib.sha256(hash_input.encode()).hexdigest()
    
    # 4. Start Battle
    start_params = [char_id, mission_id, ",".join(enemies), "#".join(enemy_attrs), agility, mission_hash, sessionkey, stage_to_run]
    start_res = await client.send_amf_request("BattleSystem.startMission", start_params)
    
    if start_res.get('status') != 1 or 'battle_code' not in start_res:
        return f"Failed to start Mission S stage {stage_to_run}: {start_res}"
        
    battle_id = start_res['battle_code']
    await asyncio.sleep(2)
    
    # 5. Finish Battle
    finish_hash_input = f"{mission_id}{char_id}{battle_id}{MISSION_S_FINISH_DAMAGE}"
    finish_mission_hash = hashlib.sha256(finish_hash_input.encode()).hexdigest()
    
    finish_params = [char_id, mission_id, battle_id, finish_mission_hash, MISSION_S_FINISH_DAMAGE, sessionkey, BATTLE_HASH, 1]
    finish_res = await client.send_amf_request("BattleSystem.finishMission", finish_params)
    
    if finish_res.get('status') == 1:
        rewards = finish_res.get('result', [])
        return f"Mission S Stage {stage_to_run} Complete! Energy left: {energy - stage_cfg['energy_cost']}. Rewards: {rewards}"
    else:
        return f"Mission S finish failed: {finish_res}"

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
        
        # 2. Check stamina
        stamina_resp = await http.post(f"{clan_base_url}/player/stamina", json={}, headers=headers)
        if stamina_resp.status_code != 200:
            return f"Failed to get Clan War stamina: {stamina_resp.text}"
            
        stamina_data = stamina_resp.json()
        char_stamina_data = stamina_data.get("char", {})
        stamina = char_stamina_data.get("stamina", 0)
        
        if stamina < 10:
            # Try to refill
            refill_resp = await http.post(f"{clan_base_url}/player/stamina/refill", json={}, headers=headers)
            if refill_resp.status_code == 200:
                refill_data = refill_resp.json()
                if refill_data.get("status") == "ok":
                    stamina = refill_data.get("char", {}).get("stamina", stamina)
                else:
                    raise Exception("Not enough clan stamina and refill failed.")
            else:
                raise Exception(f"Not enough clan stamina ({stamina}/100) and refill request failed.")
                
        if stamina < 10:
            raise Exception("Still not enough stamina after refill attempt.")
            
        # 3. Get opponents
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
        
        # 4. Quick battle
        code = "".join(random.choices(string.ascii_letters + string.digits, k=24))
        battle_resp = await http.post(f"{clan_base_url}/battle/quick/{opponent_id}", json={"code": code}, headers=headers)
        
        if battle_resp.status_code == 200:
            reward_data = battle_resp.json()
            return f"Clan War against {opponent_name} Complete! Reward: {reward_data}"
        else:
            return f"Clan War failed: {battle_resp.text}"

async def auto_exam(client: NinjaSageClient, sessionkey: str, char_id: int):
    # Retrieve char data to check level and rank
    char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
    
    # AMF may return a list or dict — normalize to dict
    if isinstance(char_data_res, list):
        # Try to find a dict element containing character info
        for item in char_data_res:
            if isinstance(item, dict):
                char_data_res = item
                break
        else:
            return "No exams available (character data is a list with no dict)"
    
    if not isinstance(char_data_res, dict):
        return "No exams available (unexpected character data format)"
    
    if char_data_res.get('status') == 0:
        return f"Failed to get character data for exam: {char_data_res.get('error', 'Unknown error')}"
    
    char_obj = char_data_res.get('character_data', char_data_res)
    if isinstance(char_obj, list):
        for item in char_obj:
            if isinstance(item, dict):
                char_obj = item
                break
        else:
            return "No exams available (could not parse character object)"
    
    level = int(char_obj.get('character_level', char_obj.get('level', 1)))
    rank_val = char_obj.get('character_rank') or char_obj.get('character_data_character_rank') or char_obj.get('rank') or 1
    try:
        rank = int(rank_val)
    except (ValueError, TypeError):
        rank = 1
    
    # 1. Genin -> Chunin (Level 20)
    if level >= 20 and rank < 2:
        exam_res = await client.send_amf_request("ChuninExam.getData", [sessionkey, char_id])
        
        if isinstance(exam_res, dict) and exam_res.get('status') == 1:
            exam_data = exam_res.get('data', [])
            
            if isinstance(exam_data, list):
                progress = sum(1 for s in exam_data if isinstance(s, dict) and s.get("status") == 2)
            elif isinstance(exam_data, dict):
                progress = exam_data.get('progress', 0)
            else:
                progress = 0
                
            if progress < 5:
                stage_num = progress + 1
                
                # startStage expects [sessionkey, char_id, stage_num]
                await client.send_amf_request("ChuninExam.startStage", [sessionkey, char_id, stage_num])
                await asyncio.sleep(1)
                
                # finishStage expects different arrays per stage
                if stage_num == 1:
                    finish_params = [sessionkey, char_id, 1, 1, [], []]
                elif stage_num == 2:
                    finish_params = [sessionkey, char_id, 2, 0, 0, 0]
                elif stage_num in (3, 4, 5):
                    finish_params = [sessionkey, char_id, stage_num, 0, []]
                else:
                    finish_params = [sessionkey, char_id]
                    
                res = await client.send_amf_request("ChuninExam.finishStage", finish_params)
                
                if isinstance(res, dict) and res.get('status') == 2:
                    return f"Chunin Exam Stage {stage_num} failed! {res}"
                else:
                    return f"Chunin Exam Stage {stage_num} completed! {res}"
            else:
                # All stages done (progress == 5), but rank is still 1!
                # The original APK requires the user to log in manually to claim the promotion if manual_claim is False.
                # The server's ChuninExam.promoteToChunin endpoint returns 'Unable to promote', so we must stop spamming.
                return ""
        return f"Chunin Exam data: {exam_res}"
        
    # 2. Chunin -> Jounin (Level 40)
    elif level >= 40 and rank < 3:
        exam_res = await client.send_amf_request("JouninExam.getData", [sessionkey, char_id])
        
        if isinstance(exam_res, dict) and exam_res.get('status') == 1:
            exam_data = exam_res.get('data', [])
            
            if isinstance(exam_data, list):
                progress = sum(1 for s in exam_data if isinstance(s, dict) and s.get("status") == 2)
            elif isinstance(exam_data, dict):
                progress = exam_data.get('progress', 0)
            else:
                progress = 0
                
            if progress < 5:
                stage_num = progress + 6 # Jounin exam uses stages 6 to 10 internally
                await client.send_amf_request("JouninExam.startStage", [sessionkey, char_id, stage_num])
                await asyncio.sleep(1)
                
                # Jounin finish parameters follow the template [stage_num, 1, []]
                res = await client.send_amf_request("JouninExam.finishStage", [sessionkey, char_id, stage_num, 1, []])
                
                if isinstance(res, dict) and res.get('status') == 2:
                    return f"Jounin Exam Stage {progress+1} failed! {res}"
                else:
                    return f"Jounin Exam Stage {progress+1} completed! {res}"
            else:
                # All stages done, promote!
                res = await client.send_amf_request("JouninExam.promoteToJounin", [sessionkey, char_id])
                return f"Promoted to Jounin! {res}"
        return f"Jounin Exam data: {exam_res}"
        
    # Add higher exams (Special Jounin, Ninja Tutor) similarly if needed...
    
    return f"No exams available for Level {level} Rank {rank}"

async def auto_eudemon(client: NinjaSageClient, sessionkey: str, char_id: int):
    # 1. Get Char Level
    char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
    if char_data_res.get('status') == 0:
        return f"Failed to get character data for Eudemon: {char_data_res.get('error', 'Unknown error')}"
    char_obj = char_data_res.get('character_data', char_data_res)
    char_level = int(char_obj.get('character_level', char_obj.get('level', 1)))
    
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
            
            # Wait for battle (simulate realistic fight time to avoid rate limit - APK waits 30s)
            await asyncio.sleep(25)
            
            # Finish Hunting
            # Hash logic: md5(str(boss_index) + str(char_id) + battle_id)
            loc2_str = str(boss_index) + str(char_id) + battle_id
            loc2 = hashlib.sha256(loc2_str.encode()).hexdigest()
            
            BATTLE_HASH = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDEiLCJiYWNrX2l0ZW0iOiJiYWNrXzAxIiwid2VhcG9uIjoid3BuXzAxIiwic2V0Ijoic2V0XzAxXzAifSwic3RhdHVzIjp7ImVhcnRoIjowLCJmaXJlIjowLCJ3YXRlciI6MCwibGlnaHRuaW5nIjowLCJ3aW5kIjowfSwiYnl0ZXMiOnsiXyI6ODIyODQ0NywiX18iOjgyMjg0NDcsIl9fXyI6IjE3NjI3NDY2NTk0MDM2N2MzY2M5OTlhOWY5ZTk1MWExZDMzMjExNTQ1Yjg0YjJkNWE2MzkzM2IwMDIwNDMzMDAwYzNiYjQxMGZiMTc2Mjc0NjY1OTE3NjI3NDY2NTkxNzYyNzQ2NjU5MTc2Mjc0NjY1OSIsIl9fX19fIjo4MjI4NDQ3LCJfX19fX18iOjgyMjg0NDcsIl9fX18iOjE3NjI3NDY2NTl9LCJfX19fIjpbeyJfIjoic2tpbGxfMTMiLCJfXyI6MjkxMzR9XX0="
            
            finish_params = [char_id, boss_index, battle_id, loc2, sessionkey, BATTLE_HASH]
            finish_res = await client.send_amf_request("EudemonGarden.finishHunting", finish_params)
            
            if finish_res.get("status") == 1:
                xp = finish_res.get("result", [0,0])[0]
                gold = finish_res.get("result", [0,0])[1]
                results.append(f"Defeated {boss_name} {i+1}/{attempts} - Gained XP: {xp}, Gold: {gold}")
            else:
                results.append(f"Failed to defeat {boss_name}: {finish_res}")
                
            # Delay between attempts to avoid rate limit
            await asyncio.sleep(6)
                
    if not results:
        return f"No Eudemon Bosses fought. Parsed Level: {char_level}. Attempts: {avail_raw}"
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
    
    if char_info_res.get('status') == 0:
        return f"Failed to fetch character data: {char_info_res.get('error', 'Unknown error')}"
        
    char_data = char_info_res
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
    
    if char_info_res.get('status') == 0:
        return f"Failed to fetch character data: {char_info_res.get('error', 'Unknown error')}"
        
    char_data = char_info_res
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
            item_res = await client.send_amf_request("36a62s4oZ7iYRJjd.zLYzbsmF8811", [sessionkey, char_id, "item_27"])
            if isinstance(item_res, dict) and item_res.get('status') == 0:
                return f"Failed to use Kitsune ticket (item_27): {item_res.get('result', item_res)}"
        except Exception as e:
            return f"Failed to use Yokai ticket: {e}"
    elif boss_type == "tengu":
        boss_id = 312610
        ene_id = "ene_2132"
        hp = 75924
        enemy_agility = 176
        
        # Tengu requires item_31
        try:
            item_res = await client.send_amf_request("36a62s4oZ7iYRJjd.zLYzbsmF8811", [sessionkey, char_id, "item_31"])
            if isinstance(item_res, dict) and item_res.get('status') == 0:
                return f"Failed to use Tengu ticket (item_31): {item_res.get('result', item_res)}"
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
        error_msg = start_res.get('result', start_res)
        return f"Failed to start Yokai Event: {error_msg}"
        
    battle_code = start_res['code']
    
    # 3. Wait for battle - Increased to avoid error 666 (Time Hack)
    await asyncio.sleep(12)
    
    # 4. Finish Event
    if boss_type == "kitsune":
        damage_done = hp
    elif boss_type == "tengu":
        damage_done = hp
    elif boss_type == "nurarihyon":
        damage_done = hp
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
        
    if isinstance(finish_res, dict) and finish_res.get('status') == 1:
        return f"Yokai Event Complete! Reward: {finish_res.get('result', [])}"
    else:
        error_msg = finish_res.get('result', finish_res) if isinstance(finish_res, dict) else finish_res
        return f"Yokai Event Complete but server rejected finish: {error_msg}"

