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

async def run_mission(client: NinjaSageClient, sessionkey: str, char_id: int, mission_id: str):
    start_res = await client.send_amf_request("IOIJB836r2Hu2PPW.mwaPMdtCPC5o", [char_id, mission_id, "char_0", "char_0", "char_0", "char_0", sessionkey])
    if start_res.get('status') == 1 and 'battle_code' in start_res:
        battle_code = start_res['battle_code']
        await asyncio.sleep(1)
        finish_res = await client.send_amf_request("IOIJB836r2Hu2PPW.MSi71s3i1X89", [char_id, mission_id, battle_code, 1, 9999, sessionkey, [], 0])
        return f"Mission Complete! Reward: {finish_res}"
    else:
        return f"Failed to start mission: {start_res}"

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
    # Placeholder for actual Shadow War AMF route
    start_res = await client.send_amf_request("ShadowWar.startMatch", [char_id, sessionkey])
    if start_res.get('status') == 1 and 'battle_code' in start_res:
        battle_code = start_res['battle_code']
        await asyncio.sleep(1)
        finish_res = await client.send_amf_request("ShadowWar.finishMatch", [char_id, battle_code, 1, sessionkey])
        return f"Shadow War Complete! Reward: {finish_res}"
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
    # Placeholder for actual Clan War AMF route
    start_res = await client.send_amf_request("ClanWar.startMatch", [char_id, sessionkey])
    if start_res.get('status') == 1 and 'battle_code' in start_res:
        battle_code = start_res['battle_code']
        await asyncio.sleep(1)
        finish_res = await client.send_amf_request("ClanWar.finishMatch", [char_id, battle_code, 1, sessionkey])
        return f"Clan War Complete! Reward: {finish_res}"
    else:
        return f"Failed to start Clan War: {start_res}"

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

