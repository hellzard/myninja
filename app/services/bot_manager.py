import asyncio
import json
import base64
import hashlib
from app.services.ninjasage_client import NinjaSageClient
from app.services.settings_manager import load_settings

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

async def exploit_gacha_race(client: NinjaSageClient, sessionkey: str, char_id: int, coin_type: str, spam_count: int = 50):
    """
    Race condition exploit: Send multiple AMF requests concurrently.
    Used for bypassing the coin check when server fails to lock database rows properly.
    """
    try:
        # Build tasks to run concurrently
        tasks = []
        for _ in range(spam_count):
            tasks.append(client.send_amf_request("mGbT7HiV6WeVOUXp.Ckpdt4SSQ1wF", [sessionkey, char_id, coin_type, 1]))
            
        # Fire all requests at the exact same time
        results = await asyncio.gather(*tasks, return_exceptions=True)
        
        # Count successes
        success_count = sum(1 for r in results if isinstance(r, dict) and r.get('status') == 1)
        
        return f"[Gacha Exploit] Fired {spam_count}x {coin_type}. Success: {success_count}/{spam_count}. Results: {results[:2]}..."
    except Exception as e:
        return f"[Gacha Exploit] Failed: {e}"

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

def get_inventory_amount(payload, item_id: str) -> int:
    if isinstance(payload, dict):
        if item_id in payload:
            try:
                return int(payload[item_id])
            except:
                pass
                
        id_keys = ('id', 'item_id', 'material_id', 'essential_id', 'name', 'code')
        amount_keys = ('amount', 'quantity', 'qty', 'count', 'num', 'value')
        for k in id_keys:
            if str(payload.get(k, "")) == item_id:
                for ak in amount_keys:
                    if ak in payload:
                        try: return int(payload[ak])
                        except: pass
                        
        for k, v in payload.items():
            if isinstance(v, (dict, list)):
                res = get_inventory_amount(v, item_id)
                if res > 0:
                    return res
    elif isinstance(payload, list):
        for item in payload:
            res = get_inventory_amount(item, item_id)
            if res > 0:
                return res
    return 0

def _parse_materials(raw_mat) -> list:
    """Safely extracts material strings from various AMF material structures without throwing IndexError."""
    materials = []
    if not raw_mat:
        return materials
        
    if isinstance(raw_mat, list):
        for item in raw_mat:
            if isinstance(item, list):
                if len(item) >= 2:
                    materials.append(f"{item[0]}x{item[1]}")
                elif len(item) == 1:
                    materials.append(str(item[0]))
            elif isinstance(item, dict):
                item_id = item.get('id', item.get('item_id', item.get('name', 'item')))
                qty = item.get('amount', item.get('qty', item.get('count', 1)))
                materials.append(f"{item_id}x{qty}")
            elif isinstance(item, (str, int, float)):
                materials.append(str(item))
    elif isinstance(raw_mat, dict):
        for k, v in raw_mat.items():
            materials.append(f"{k}x{v}")
    elif isinstance(raw_mat, (str, int, float)):
        materials.append(str(raw_mat))
        
    return materials

_char_level_cache = {}
_event_char_data_cache = {}
_char_info_cache = {}
_char_stats_cache = {}

def update_char_snapshot(char_id: int, char_data_res: dict = None, acc_data_res: dict = None, initial_stats: dict = None):
    """Updates internal cached stats (level, total xp, total gold, total tokens) for a character."""
    global _char_stats_cache, _char_level_cache
    if not char_id:
        return
    if char_id not in _char_stats_cache:
        _char_stats_cache[char_id] = {"level": 1, "xp": 0, "gold": 0, "tokens": 0}
        
    if initial_stats and isinstance(initial_stats, dict):
        for k in ("level", "xp", "gold", "tokens"):
            if k in initial_stats and initial_stats[k] not in (None, '--', '?'):
                try:
                    _char_stats_cache[char_id][k] = int(initial_stats[k])
                except Exception:
                    pass
        if "level" in _char_stats_cache[char_id]:
            _char_level_cache[char_id] = _char_stats_cache[char_id]["level"]
            
    if isinstance(char_data_res, dict):
        char_obj = char_data_res.get('character_data') or char_data_res.get('data') or char_data_res
        if isinstance(char_obj, list) and len(char_obj) > 0 and isinstance(char_obj[0], dict):
            char_obj = char_obj[0]
        if isinstance(char_obj, dict):
            try:
                lvl_val = char_obj.get("character_level") or char_obj.get("level")
                if lvl_val not in (None, '--', '?'):
                    lvl = int(lvl_val)
                    _char_stats_cache[char_id]["level"] = lvl
                    _char_level_cache[char_id] = lvl
            except Exception:
                pass
                
            try:
                xp_val = char_obj.get("character_xp") or char_obj.get("xp")
                if xp_val not in (None, '--', '?'):
                    _char_stats_cache[char_id]["xp"] = int(xp_val)
            except Exception:
                pass
                
            try:
                gold_val = char_obj.get("character_gold") or char_obj.get("gold")
                if gold_val not in (None, '--', '?'):
                    _char_stats_cache[char_id]["gold"] = int(gold_val)
            except Exception:
                pass
                
            try:
                tok_val = char_obj.get("character_tokens") or char_obj.get("tokens") or char_obj.get("token")
                if tok_val not in (None, '--', '?'):
                    _char_stats_cache[char_id]["tokens"] = int(tok_val)
            except Exception:
                pass
                
    if isinstance(acc_data_res, dict):
        acc = acc_data_res.get("account", {})
        tok_val = acc.get("tokens") if isinstance(acc, dict) else None
        if tok_val is None:
            tok_val = acc_data_res.get("tokens")
        if tok_val not in (None, '--', '?'):
            try:
                _char_stats_cache[char_id]["tokens"] = int(tok_val)
            except Exception:
                pass

async def get_or_fetch_char_level(client: NinjaSageClient, sessionkey: str, char_id: int) -> int:
    global _char_level_cache
    if char_id in _char_level_cache and _char_level_cache[char_id] is not None:
        return _char_level_cache[char_id]
    try:
        char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
        update_char_snapshot(char_id, char_data_res)
        char_obj = char_data_res.get('character_data') or char_data_res.get('data') or char_data_res
        if isinstance(char_obj, list) and len(char_obj) > 0 and isinstance(char_obj[0], dict):
            char_obj = char_obj[0]
        if isinstance(char_obj, dict):
            lvl = int(char_obj.get("character_level") or char_obj.get("level") or 1)
            _char_level_cache[char_id] = lvl
            return lvl
    except Exception:
        pass
    return _char_level_cache.get(char_id, None)

async def get_or_fetch_event_char_data(client: NinjaSageClient, sessionkey: str, char_id: int) -> dict:
    global _event_char_data_cache
    if char_id in _event_char_data_cache and _event_char_data_cache[char_id]:
        return _event_char_data_cache[char_id]
    try:
        char_info_res = await client.send_amf_request("36a62s4oZ7iYRJjd.iakN46g0GaJN", [[char_id, sessionkey, char_id, "EVENT"]])
        if isinstance(char_info_res, dict) and char_info_res.get('status') != 0:
            _event_char_data_cache[char_id] = char_info_res
            return char_info_res
    except Exception:
        pass
    return _event_char_data_cache.get(char_id, {})

def format_battle_rewards(feature_name: str, finish_res, current_level=None, char_id=None) -> str:
    try:
        global _char_level_cache, _char_stats_cache
        if current_level is None and char_id is not None:
            current_level = _char_level_cache.get(char_id)
            
        xp = 0
        gold = 0
        token = 0
        materials = []
        
        explicit_total_xp = None
        explicit_total_gold = None
        explicit_total_token = None
        
        if isinstance(finish_res, dict):
            # Check if total stats are explicitly provided at the root of finish_res
            if 'xp' in finish_res and isinstance(finish_res['xp'], (int, float)):
                explicit_total_xp = int(finish_res['xp'])
            elif 'character_xp' in finish_res and isinstance(finish_res['character_xp'], (int, float)):
                explicit_total_xp = int(finish_res['character_xp'])
                
            if 'character_gold' in finish_res and isinstance(finish_res['character_gold'], (int, float)):
                explicit_total_gold = int(finish_res['character_gold'])
                
            if 'account_tokens' in finish_res and isinstance(finish_res['account_tokens'], (int, float)):
                explicit_total_token = int(finish_res['account_tokens'])
            elif 'tokens' in finish_res and isinstance(finish_res['tokens'], (int, float)):
                explicit_total_token = int(finish_res['tokens'])
            elif 'character_tokens' in finish_res and isinstance(finish_res['character_tokens'], (int, float)):
                explicit_total_token = int(finish_res['character_tokens'])
            
            if 'result' in finish_res and isinstance(finish_res['result'], list):
                rewards = finish_res['result']
                if len(rewards) > 0 and isinstance(rewards[0], (int, float, str)):
                    try: xp = int(rewards[0])
                    except: xp = rewards[0]
                if len(rewards) > 1 and isinstance(rewards[1], (int, float, str)):
                    try: gold = int(rewards[1])
                    except: gold = rewards[1]
                if len(rewards) > 2:
                    materials.extend(_parse_materials(rewards[2]))
                if len(rewards) > 3 and isinstance(rewards[3], (int, float)):
                    try: token = int(rewards[3])
                    except: token = rewards[3]
            elif 'result' in finish_res and isinstance(finish_res['result'], dict):
                res_dict = finish_res['result']
                raw_xp = res_dict.get('xp', res_dict.get('character_xp', 0))
                try: xp = int(raw_xp)
                except: xp = raw_xp
                
                raw_gold = res_dict.get('gold', res_dict.get('character_gold', 0))
                try: gold = int(raw_gold)
                except: gold = raw_gold
                
                raw_token = res_dict.get('token', res_dict.get('character_token', 0))
                try: token = int(raw_token)
                except: token = raw_token
                
                new_level = res_dict.get('level', res_dict.get('character_level'))
                if new_level:
                    current_level = new_level
                    if char_id:
                        _char_level_cache[char_id] = new_level
                mat_raw = res_dict.get('material') or res_dict.get('materials') or res_dict.get('items')
                materials.extend(_parse_materials(mat_raw))
            else:
                rewards = finish_res.get('rewards') or finish_res.get('reward') or finish_res
                if isinstance(rewards, dict):
                    raw_xp = rewards.get('xp', rewards.get('character_xp', 0))
                    try: xp = int(raw_xp)
                    except: xp = raw_xp
                    
                    raw_gold = rewards.get('gold', rewards.get('character_gold', 0))
                    try: gold = int(raw_gold)
                    except: gold = raw_gold
                    
                    raw_token = rewards.get('token', rewards.get('character_token', 0))
                    try: token = int(raw_token)
                    except: token = raw_token
                    
                    new_level = rewards.get('level', rewards.get('character_level'))
                    if new_level:
                        current_level = new_level
                        if char_id:
                            _char_level_cache[char_id] = new_level
                    
                    mat_raw = rewards.get('material') or rewards.get('materials') or rewards.get('items')
                    materials.extend(_parse_materials(mat_raw))
        elif isinstance(finish_res, list):
            if len(finish_res) > 0 and isinstance(finish_res[0], (int, float, str)):
                try: xp = int(finish_res[0])
                except: xp = finish_res[0]
            if len(finish_res) > 1 and isinstance(finish_res[1], (int, float, str)):
                try: gold = int(finish_res[1])
                except: gold = finish_res[1]
            if len(finish_res) > 2:
                materials.extend(_parse_materials(finish_res[2]))
            if len(finish_res) > 3 and isinstance(finish_res[3], (int, float)):
                try: token = int(finish_res[3])
                except: token = finish_res[3]

        # Calculate Total Stats
        char_stats = _char_stats_cache.get(char_id, {}) if char_id else {}
        
        # 1. Total XP
        if explicit_total_xp is not None:
            total_xp = explicit_total_xp
        elif "xp" in char_stats and isinstance(char_stats["xp"], (int, float)) and isinstance(xp, (int, float)):
            total_xp = char_stats["xp"] + xp
        else:
            total_xp = xp if isinstance(xp, (int, float)) else 0
            
        if char_id:
            if char_id not in _char_stats_cache:
                _char_stats_cache[char_id] = {}
            if isinstance(total_xp, (int, float)):
                _char_stats_cache[char_id]["xp"] = total_xp
                
        # 2. Total Gold
        if explicit_total_gold is not None:
            total_gold = explicit_total_gold
        elif "gold" in char_stats and isinstance(char_stats["gold"], (int, float)) and isinstance(gold, (int, float)):
            total_gold = char_stats["gold"] + gold
        else:
            total_gold = gold if isinstance(gold, (int, float)) else 0
            
        if char_id:
            if isinstance(total_gold, (int, float)):
                _char_stats_cache[char_id]["gold"] = total_gold
                
        # 3. Total Token
        if explicit_total_token is not None:
            total_token = explicit_total_token
        elif "tokens" in char_stats and isinstance(char_stats["tokens"], (int, float)) and isinstance(token, (int, float)):
            total_token = char_stats["tokens"] + token
        else:
            total_token = token if isinstance(token, (int, float)) else 0
            
        if char_id:
            if isinstance(total_token, (int, float)):
                _char_stats_cache[char_id]["tokens"] = total_token
                
        # 4. Total Level
        if current_level is not None and char_id:
            try:
                _char_stats_cache[char_id]["level"] = int(current_level)
            except Exception:
                pass

        # Build comprehensive informative log string
        parts = [f"{feature_name} SUCCESS!"]
        
        # 1. Level Karakter Saat Ini
        if current_level is not None and str(current_level) not in ('--', 'None', '?'):
            parts.append(f"Level: {current_level}")
        else:
            parts.append("Level: -")
            
        # 2. XP Reward
        parts.append(f"XP: +{xp}" if xp else "XP: 0")
        
        # 3. Gold Reward
        parts.append(f"Gold: +{gold}" if gold else "Gold: 0")
        
        # 4. Token Reward
        parts.append(f"Token: +{token}" if token else "Token: 0")
        
        # 5. Materials
        if materials:
            parts.append(f"Materials: {', '.join(materials)}")
        else:
            parts.append("Materials: -")
            
        # 6. Total XP
        parts.append(f"Total XP: {total_xp}")
        
        # 7. Total Gold
        parts.append(f"Total Gold: {total_gold}")
        
        # 8. Total Token
        parts.append(f"Total Token: {total_token}")
            
        return " | ".join(parts)
    except Exception as e:
        return f"{feature_name} SUCCESS! Raw: {finish_res}"

# Anti-cheat payload from nsepanel (base64 encoded JSON with default gear/stats)
BATTLE_HASH = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDEiLCJiYWNrX2l0ZW0iOiJiYWNrXzAxIiwid2VhcG9uIjoid3BuXzAxIiwic2V0Ijoic2V0XzAxXzAifSwic3RhdHVzIjp7ImVhcnRoIjowLCJmaXJlIjowLCJ3YXRlciI6MCwibGlnaHRuaW5nIjowLCJ3aW5kIjowfSwiYnl0ZXMiOnsiXyI6ODIyODQ0NywiX18iOjgyMjg0NDcsIl9fXyI6IjE3NjI3NDY2NTk0MDM2N2MzY2M5OTlhOWY5ZTk1MWExZDMzMjExNTQ1Yjg0YjJkNWE2MzkzM2IwMDIwNDMzMDAwYzNiYjQxMGZiMTc2Mjc0NjY1OTE3NjI3NDY2NTkxNzYyNzQ2NjU5MTc2Mjc0NjY1OSIsIl9fX19fIjo4MjI4NDQ3LCJfX19fX18iOjgyMjg0NDcsIl9fX18iOjE3NjI3NDY2NTl9LCJfX19fIjpbeyJfIjoic2tpbGxfMTMiLCJfXyI6MjkxMzR9XX0="

def get_best_mission(level: int, rank: int) -> str:
    # rank 1=Genin(C), 2=Chunin(B), 3=Jounin(A), 4=Special(S), 5=Sage(SS)
    allowed_grades = ["c"]
    if rank >= 2: allowed_grades.append("b")
    if rank >= 3: allowed_grades.append("a")
    if rank >= 4: allowed_grades.append("s")
    if rank >= 5: allowed_grades.append("ss")
    
    best_mission = None
    highest_level = -1
    
    for m in MISSION_DATA:
        m_level = m.get("level", 1)
        m_grade = m.get("grade", "c").lower()
        if m_level <= level and m_grade in allowed_grades and "enemies" in m and len(m["enemies"]) > 0:
            if m_level > highest_level:
                highest_level = m_level
                best_mission = m.get("id")
                
    return best_mission or "msn_3"

async def run_mission(client: NinjaSageClient, sessionkey: str, char_id: int, mission_id: str):
    SAGE_SCROLL_MINIGAME_MISSION_IDS = {'msn_109', 'msn_110', 'msn_111'}
    if mission_id in SAGE_SCROLL_MINIGAME_MISSION_IDS:
        start_res = await client.send_amf_request("BattleSystem.startSageScrollMiniGame", [char_id, sessionkey, mission_id])
        if isinstance(start_res, dict) and 'status' in start_res and start_res['status'] != 1:
            return f"Failed to start Sage Scroll mission {mission_id}: {start_res}"
            
        battle_id = str(start_res) if not isinstance(start_res, dict) else str(start_res.get('battle_code', start_res.get('id', start_res)))
        await asyncio.sleep(1)
        finish_res = await client.send_amf_request("BattleSystem.finishSageScrollMiniGame", [char_id, sessionkey, battle_id])
        return format_battle_rewards(f"Sage Scroll Mission {mission_id}", finish_res, char_id=char_id)
        
    global _char_info_cache
    
    char_info = _char_info_cache.get(char_id)
    if char_info is None:
        char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
        if isinstance(char_data_res, dict) and char_data_res.get('status') == 0:
            return f"Failed to get character data: {char_data_res.get('error', 'Unknown error')}"
        update_char_snapshot(char_id, char_data_res)
        char_obj = char_data_res.get('character_data') or char_data_res.get('data') or char_data_res
        if isinstance(char_obj, list):
            for item in char_obj:
                if isinstance(item, dict):
                    char_obj = item
                    break
        
        try:
            lvl = int(char_obj.get("character_level") or char_obj.get("level") or 1)
        except:
            lvl = 1
            
        rank_val = char_obj.get('character_rank') or char_obj.get('character_data_character_rank') or char_obj.get('rank') or 1
        try:
            rk = int(rank_val)
        except:
            rk = 1
        
        char_info = {
            "agility": calculate_agility(char_data_res),
            "level": lvl,
            "rank": rk
        }
        _char_info_cache[char_id] = char_info

    # Use provided mission_id if valid, else dynamically select optimal mission based on nsepanel decompiled logic
    actual_mission_id = mission_id if mission_id and mission_id.lower() != "auto" else get_best_mission(char_info["level"], char_info["rank"])
    
    mission_info = get_data_by_id(actual_mission_id, MISSION_DATA)
    if not mission_info:
        return f"Failed: Unknown mission_id {actual_mission_id}"
        
    # === PHASE 1: startMission (matches SWF Mission_Room.as:341-362) ===
    enemies = mission_info.get("enemies", [])
    enemy_attrs = []
    for enemy in enemies:
        enemy_attr = get_data_by_id(enemy, ENEMY_DATA)
        hp = enemy_attr.get("hp", 0)
        ene_agi = enemy_attr.get("agility", 0)
        enemy_attrs.append(f"id:{enemy}|hp:{hp}|agility:{ene_agi}")
    
    enemies_str = ",".join(enemies)
    enemy_attrs_str = "#".join(enemy_attrs)
        
    # Hash: SWF does CUCSG.hash(_loc2_ + _loc3_ + _loc4_) where _loc2_=enemies, _loc3_=enemy_attrs, _loc4_=agility
    start_hash_input = enemies_str + enemy_attrs_str + str(char_info["agility"])
    mission_hash = hashlib.sha256(start_hash_input.encode()).hexdigest()
    
    # SWF params: [char_id, mission_id, enemies, enemy_attrs, agility, hash, sessionkey]
    start_params = [char_id, actual_mission_id, enemies_str, enemy_attrs_str, char_info["agility"], mission_hash, sessionkey]
    start_res = await client.send_amf_request("IOIJB836r2Hu2PPW.mwaPMdtCPC5o", start_params)
    
    # === PHASE 2: Validate startMission response ===
    # SWF checks: if(param1.length != 10) → fail. Success = raw battle_code string/number
    if isinstance(start_res, dict):
        if start_res.get('status') == 2 or start_res.get('status') == 0:
            return f"Failed: startMission rejected {actual_mission_id}: {start_res}"
        battle_id = str(start_res.get('battle_code', start_res.get('code', start_res.get('id', ''))))
    else:
        battle_id = str(start_res)
    
    if not battle_id or battle_id == 'None' or battle_id == '':
        return f"Failed: No battle_id for {actual_mission_id}: {start_res}"
    
    battle_wait = max(3, int(load_settings().get('sage_battle_wait_seconds', 5) or 5))
    await asyncio.sleep(battle_wait)
    
    # === PHASE 3: finishMission (matches nsepanel leveling_dis.txt:3795-3826) ===
    # nsepanel hash: f"{mission_id}{char_id}{battle_id}0"
    finish_hash_input = f"{actual_mission_id}{char_id}{battle_id}0"
    finish_hash = hashlib.sha256(finish_hash_input.encode()).hexdigest()
    
    # nsepanel params: [char_id, mission_id, battle_id, finish_hash, 0, session_key, battle_hash, 0]
    finish_params = [char_id, actual_mission_id, battle_id, finish_hash, 0, sessionkey, BATTLE_HASH, 0]
    finish_res = await client.send_amf_request("IOIJB836r2Hu2PPW.MSi71s3i1X89", finish_params)
    
    # === PHASE 4: Check finish response status ===
    if isinstance(finish_res, dict) and finish_res.get('status') == 0:
        return f"Failed: finishMission rejected {actual_mission_id}: {finish_res}"
        
    if isinstance(finish_res, (dict, list)):
        formatted_msg = format_battle_rewards(f"Mission {actual_mission_id}", finish_res, current_level=char_info.get("level"), char_id=char_id)
        if char_id in _char_level_cache:
            char_info["level"] = _char_level_cache[char_id]
        return formatted_msg
    else:
        return f"Failed: finishMission unexpected response for {actual_mission_id}: {finish_res}"

async def auto_daily_event(client: NinjaSageClient, sessionkey: str, char_id: int):
    # 1. Fetch Char Data
    char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
    if isinstance(char_data_res, dict) and char_data_res.get('status') == 1:
        update_char_snapshot(char_id, char_data_res)
        char_obj = char_data_res.get('character_data') or char_data_res.get('data') or char_data_res
        if isinstance(char_obj, list):
            for item in char_obj:
                if isinstance(item, dict):
                    char_obj = item
                    break
        
        try:
            level = int(char_obj.get('character_level') or char_obj.get('level') or 1)
        except:
            level = 1
            
        rank_val = char_obj.get('character_rank') or char_obj.get('character_data_character_rank') or char_obj.get('rank') or 1
        try:
            rank = int(rank_val)
        except:
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
    
    # Generic events (like moyai island, summer, etc) that might appear dynamically
    event_entries = _normalize(room_data.get('event'))

    # APK Rules: TP requires Level 40 and Rank 5
    if level < 40 or rank < 5:
        tp_entries = []
    
    # APK Rules: SS requires Level 80 and Rank 9
    if level < 80 or rank < 9:
        ss_entries = []

    # Run the first available mission, prioritizing Event -> Daily -> TP -> SS
    for m_id, _ in event_entries:
        return await run_mission(client, sessionkey, char_id, m_id)

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
            level = await get_or_fetch_char_level(client, sessionkey, char_id)
            return format_battle_rewards(f"Hunting Zone {zone} ({boss_info['name']})", finish_res, current_level=level, char_id=char_id)
        else:
            return f"Failed to finish hunting: {finish_res}"
    else:
        error_msg = start_res.get('result', start_res) if isinstance(start_res, dict) else start_res
        return f"Failed to start hunting: {error_msg}"

async def auto_shadow_war(client: NinjaSageClient, sessionkey: str, char_id: int):
    """Run one Shadow War battle with conservative timing and explicit resource policy."""
    cfg = load_settings()

    status_res = await client.send_amf_request("ShadowWar.executeService", ["getStatus", [char_id, sessionkey]])
    if not isinstance(status_res, dict) or status_res.get('status') != 1:
        return f"Shadow War unavailable: {status_res}"

    try:
        energy = int(status_res.get('energy', 0))
    except (TypeError, ValueError):
        energy = 0

    if energy < 10:
        mode = str(cfg.get('sage_shadow_war_empty_resource_mode', 'wait')).strip().lower()
        if mode not in {'wait', 'buy', 'stop'}:
            mode = 'wait'

        if mode == 'stop':
            return f"Shadow War stopped: energy is {energy}."

        if mode == 'buy':
            refill_res = await client.send_amf_request("ShadowWar.executeService", ["refillEnergy", [char_id, sessionkey]])
            if not (isinstance(refill_res, dict) and str(refill_res.get('status')) == '1'):
                wait_minutes = max(1, int(cfg.get('sage_shadow_war_wait_minutes', 30) or 30))
                return f"WAIT_RESOURCE:{wait_minutes * 60}|Shadow War refill failed; waiting {wait_minutes} minute(s): {refill_res}"
        else:
            wait_minutes = max(1, int(cfg.get('sage_shadow_war_wait_minutes', 30) or 30))
            return f"WAIT_RESOURCE:{wait_minutes * 60}|Shadow War energy is {energy}; waiting {wait_minutes} minute(s) without spending tokens."

    enemies_res = await client.send_amf_request("ShadowWar.executeService", ["getEnemies", [char_id, sessionkey]])
    if not isinstance(enemies_res, dict) or not enemies_res.get('enemies'):
        return "No Shadow War enemies available right now."

    enemy = enemies_res['enemies'][0]
    enemy_id = enemy.get('id')
    enemy_name = enemy.get('name', str(enemy_id))
    start_res = await client.send_amf_request("ShadowWar.executeService", ["startBattle", [char_id, sessionkey, enemy_id]])
    if not isinstance(start_res, dict) or start_res.get('status') != 1:
        return f"Failed to start Shadow War against {enemy_name}: {start_res}"

    battle_id = start_res.get('id')
    wait_seconds = max(10, int(cfg.get('shadow_war_battle_wait_seconds', 20) or 20))
    await asyncio.sleep(wait_seconds)

    mission_hash = hashlib.sha256(f"{char_id}{battle_id}0{BATTLE_HASH}".encode()).hexdigest()
    finish_params = [char_id, sessionkey, battle_id, 0, BATTLE_HASH, mission_hash]
    finish_res = await client.send_amf_request("ShadowWar.executeService", ["finishBattle", finish_params])

    if isinstance(finish_res, dict) and finish_res.get('status') == 1:
        level = await get_or_fetch_char_level(client, sessionkey, char_id)
        return format_battle_rewards(f"Shadow War vs {enemy_name}", finish_res, current_level=level, char_id=char_id)
    return f"Shadow War Battle Failed: {finish_res}"

async def auto_monster_hunt(client: NinjaSageClient, sessionkey: str, char_id: int):
    import hashlib
    import asyncio
    
    EQUIPMENT_DATA = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDEiLCJiYWNrX2l0ZW0iOiJiYWNrXzIzODEiLCJ3ZWFwb24iOiJ3cG5fMjM4MCIsInNldCI6InNldF8yMjU4XzEifSwic3RhdHVzIjp7ImVhcnRoIjowLCJsaWdodG5pbmciOjAsImZpcmUiOjAsIndhdGVyIjowLCJ3aW5kIjo3OH0sImJ5dGVzIjp7Il9fXyI6IjE3NjM4Nzk1ODk0MDM2N2MzY2M5OTlhOWY5ZTk1MWExZDMzMjExNTQ1Yjg0YjJkNWE2MzkzM2IwMDIwNDMzMDAwYzNiYjQxMGZiMTc2Mzg3OTU4OTE3NjM4Nzk1ODkxNzYzODc5NTg5MTc2Mzg3OTU4OSIsIl8iOjgyMjg0NDcsIl9fX18iOjE3NjM4Nzk1ODksIl9fX19fIjo4MjI4NDQ3LCJfXyI6ODIyODQ0NywiX19fX19fIjo4MjI4NDQ3fSwiX19fXyI6W3siXyI6InNraWxsXzIzMTIiLCJfXyI6NTQ2MDV9LHsiXyI6InNraWxsXzM0NSIsIl9fIjo4MDI0M30seyJfIjoic2tpbGxfMjMxMCIsIl9fIjoxMjg0Njl9LHsiXyI6InNraWxsXzIyMTUiLCJfXyI6MjkzNDl9LHsiXyI6InNraWxsXzIyODYiLCJfXyI6NDk0NzR9LHsiXyI6InNraWxsXzIyMDYiLCJfXyI6NjA5NDR9LHsiXyI6InNraWxsXzIzMDgiLCJfXyI6NjUxMDF9LHsiXyI6InNraWxsXzMyOSIsIl9fIjo3NTM1Nn1dfQ=="
    
    # 1. Fetch Event Data (Check event data and energy)
    event_data = None
    endpoint_prefix = "MonsterHunterEvent2023" # Source of truth from APK bytecode
    
    try:
        event_res = await client.send_amf_request("MonsterHunterEvent2023.getEventData", [char_id, sessionkey])
        if isinstance(event_res, dict) and (event_res.get('status') == 1 or str(event_res.get('status')) == "1"):
            event_data = event_res
            endpoint_prefix = "MonsterHunterEvent2023"
        elif isinstance(event_res, list) and len(event_res) > 0 and isinstance(event_res[0], dict):
            event_data = event_res[0]
            endpoint_prefix = "MonsterHunterEvent2023"
    except Exception:
        event_data = None

    if not event_data:
        try:
            # Fallback to SWF obfuscated service name
            event_res = await client.send_amf_request("vnB7P8simcleapK1.rqZYazLcWOgx", [char_id, sessionkey])
            if isinstance(event_res, dict) and (event_res.get('status') == 1 or str(event_res.get('status')) == "1"):
                event_data = event_res
                endpoint_prefix = "vnB7P8simcleapK1"
            elif isinstance(event_res, list) and len(event_res) > 0 and isinstance(event_res[0], dict):
                event_data = event_res[0]
                endpoint_prefix = "vnB7P8simcleapK1"
        except Exception:
            pass

    boss_id = "ene_2080"
    if isinstance(event_data, dict):
        inner_data = event_data.get('data') or event_data.get('event_data') or event_data
        if isinstance(inner_data, dict):
            boss_id = inner_data.get('boss_id') or inner_data.get('boss') or 'ene_2080'
            energy_val = inner_data.get('energy')
            if energy_val is not None:
                energy = int(energy_val)
                if energy < 10:
                    return f"STOPPED: Energy Monster Hunter habis ({energy}/10 required). Bot dihentikan."

    # 2. Start Battle
    start_hash_str = f"{char_id}{boss_id}"
    start_hash = hashlib.sha256(start_hash_str.encode()).hexdigest()
    
    start_endpoint = "MonsterHunterEvent2023.startBattle" if endpoint_prefix == "MonsterHunterEvent2023" else "vnB7P8simcleapK1.L0ZnAYiHcaRE"
    try:
        start_res = await client.send_amf_request(start_endpoint, [char_id, boss_id, start_hash, sessionkey])
    except Exception as e:
        start_res = {"status": 0, "error": str(e)}
        
    if not isinstance(start_res, dict) or (start_res.get("status") != 1 and str(start_res.get("status")) != "1"):
        # If the prefix failed, try the alternate endpoint
        alt_start_endpoint = "vnB7P8simcleapK1.L0ZnAYiHcaRE" if endpoint_prefix == "MonsterHunterEvent2023" else "MonsterHunterEvent2023.startBattle"
        try:
            start_res = await client.send_amf_request(alt_start_endpoint, [char_id, boss_id, start_hash, sessionkey])
            if isinstance(start_res, dict) and (start_res.get("status") == 1 or str(start_res.get("status")) == "1"):
                endpoint_prefix = "vnB7P8simcleapK1" if alt_start_endpoint.startswith("vnB7P8") else "MonsterHunterEvent2023"
        except Exception:
            pass
            
    if not isinstance(start_res, dict) or (start_res.get("status") != 1 and str(start_res.get("status")) != "1"):
        error_msg = start_res.get('result', start_res.get('error', start_res)) if isinstance(start_res, dict) else start_res
        return f"Failed to start Monster Hunter battle against {boss_id}: {error_msg}"

    battle_id = str(start_res.get("code", start_res.get("battle_code", start_res.get("id", ""))))
    if not battle_id:
        return f"Failed: No battle ID returned for Monster Hunter {boss_id}: {start_res}"

    await asyncio.sleep(2.5) # Safe battle delay
    
    # 3. Finish Battle
    finish_hash_str = f"{char_id}{boss_id}{battle_id}0{EQUIPMENT_DATA}"
    finish_hash = hashlib.sha256(finish_hash_str.encode()).hexdigest()
    
    finish_endpoint = "MonsterHunterEvent2023.finishBattle" if endpoint_prefix == "MonsterHunterEvent2023" else "vnB7P8simcleapK1.hW7GRYkEv7Ak"
    finish_params = [char_id, boss_id, battle_id, 0, finish_hash, EQUIPMENT_DATA, sessionkey]
    
    try:
        finish_res = await client.send_amf_request(finish_endpoint, finish_params)
    except Exception as e:
        finish_res = {"status": 0, "error": str(e)}
        
    if not isinstance(finish_res, dict) or (finish_res.get("status") != 1 and str(finish_res.get("status")) != "1"):
        # Fallback to alternate finish endpoint if status != 1
        alt_finish_endpoint = "vnB7P8simcleapK1.hW7GRYkEv7Ak" if endpoint_prefix == "MonsterHunterEvent2023" else "MonsterHunterEvent2023.finishBattle"
        try:
            finish_res = await client.send_amf_request(alt_finish_endpoint, finish_params)
        except Exception:
            pass
        
    if isinstance(finish_res, dict) and (finish_res.get("status") == 1 or str(finish_res.get("status")) == "1"):
        level = await get_or_fetch_char_level(client, sessionkey, char_id)
        return format_battle_rewards(f"Monster Hunter {boss_id}", finish_res, current_level=level, char_id=char_id)
    else:
        error_msg = finish_res.get('result', finish_res.get('error', finish_res)) if isinstance(finish_res, dict) else finish_res
        return f"Monster Hunter Battle failed: {error_msg}"

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
    update_char_snapshot(char_id, char_data_res)
    char_obj = char_data_res.get('character_data') or char_data_res.get('data') or char_data_res
    if isinstance(char_obj, list):
        for item in char_obj:
            if isinstance(item, dict):
                char_obj = item
                break
                
    try:
        char_level = int(char_obj.get('character_level') or char_obj.get('level') or 0)
    except:
        char_level = 0
        
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
    start_res = await client.send_amf_request("IOIJB836r2Hu2PPW.mwaPMdtCPC5o", start_params)
    
    if start_res.get('status') != 1 or 'battle_code' not in start_res:
        return f"Failed to start Mission S stage {stage_to_run}: {start_res}"
        
    battle_id = start_res['battle_code']
    await asyncio.sleep(2)
    
    # 5. Finish Battle
    finish_hash_input = f"{mission_id}{char_id}{battle_id}{MISSION_S_FINISH_DAMAGE}"
    finish_mission_hash = hashlib.sha256(finish_hash_input.encode()).hexdigest()
    
    finish_params = [char_id, mission_id, battle_id, finish_mission_hash, MISSION_S_FINISH_DAMAGE, sessionkey, BATTLE_HASH, 1]
    finish_res = await client.send_amf_request("IOIJB836r2Hu2PPW.MSi71s3i1X89", finish_params)
    
    if finish_res.get('status') == 1:
        level = await get_or_fetch_char_level(client, sessionkey, char_id)
        return format_battle_rewards(f"Mission S Stage {stage_to_run}", finish_res, current_level=level, char_id=char_id)
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
            level = await get_or_fetch_char_level(client, sessionkey, char_id)
            return format_battle_rewards(f"Clan War vs {opponent_name}", reward_data, current_level=level, char_id=char_id)
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
    update_char_snapshot(char_id, char_data_res)
    
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
                    return format_battle_rewards(f"Chunin Exam Stage {stage_num}", res, current_level=level, char_id=char_id)
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
                    return format_battle_rewards(f"Jounin Exam Stage {progress+1}", res, current_level=level, char_id=char_id)
            else:
                # All stages done, promote!
                res = await client.send_amf_request("JouninExam.promoteToJounin", [sessionkey, char_id])
                return f"Promoted to Jounin! {res}"
        return f"Jounin Exam data: {exam_res}"
        
    # Add higher exams (Special Jounin, Ninja Tutor) similarly if needed...
    
    return f"No exams available for Level {level} Rank {rank}"

async def auto_eudemon(client: NinjaSageClient, sessionkey: str, char_id: int):
    import asyncio
    import hashlib
    import json
    import os

    # 1. Get Char Level (using cache first to prevent spamming SystemLogin.getCharacterData)
    global _char_level_cache
    char_level = _char_level_cache.get(char_id)
    if not char_level:
        char_data_res = await client.send_amf_request("SystemLogin.getCharacterData", [char_id, sessionkey])
        if isinstance(char_data_res, dict) and char_data_res.get('status') == 0:
            return f"Failed to get character data for Eudemon: {char_data_res.get('error', 'Unknown error')}"
        update_char_snapshot(char_id, char_data_res)
            
        char_obj = char_data_res.get('character_data') or char_data_res.get('data') or char_data_res
        if isinstance(char_obj, list) and len(char_obj) > 0 and isinstance(char_obj[0], dict):
            char_obj = char_obj[0]
                    
        try:
            char_level = int(char_obj.get('character_level') or char_obj.get('level') or 1)
            _char_level_cache[char_id] = char_level
        except:
            char_level = 1
        
    if char_level < 10:
        return f"Eudemon requires level 10 (Current: {char_level})"
        
    # 2. Get available bosses
    avail_res = await client.send_amf_request("A11M5XZ9wxhTs2Dr.RuyuMINDEhfE", [sessionkey, char_id])
    if isinstance(avail_res, dict) and "Rate limited" in str(avail_res.get("result", "")):
        await asyncio.sleep(4) # Server rate limit backoff
        avail_res = await client.send_amf_request("A11M5XZ9wxhTs2Dr.RuyuMINDEhfE", [sessionkey, char_id])

    if not isinstance(avail_res, dict) or "data" not in avail_res:
        error_msg = avail_res.get('result', avail_res) if isinstance(avail_res, dict) else avail_res
        return f"Eudemon boss check response: {error_msg}"
        
    avail_raw = avail_res["data"]
    if not avail_raw:
        return "No boss entries"
        
    avail_bosses = list(map(int, avail_raw.split(",")))
    
    # 3. Load gamedata.json
    try:
        with open(os.path.join(os.path.dirname(__file__), "..", "data", "gamedata.json"), "r", encoding="utf-8") as f:
            gamedata = json.load(f)
    except Exception as e:
        return f"Failed to load gamedata.json: {e}"
        
    eudemon_entry = next((item for item in gamedata if item.get('id') == 'eudemon'), None)
    if not eudemon_entry:
        return "Eudemon gamedata not found"
        
    bosses = eudemon_entry["data"]["bosses"]
    
    target_boss_index = -1
    target_boss_name = ""
    
    for b in bosses:
        if int(b["lvl"]) > char_level:
            break
            
        boss_index = b.get("num", 0)
        
        if boss_index >= len(avail_bosses):
            continue
            
        attempts = avail_bosses[boss_index]
        if attempts > 0:
            target_boss_index = boss_index
            target_boss_name = b.get("name", "Unknown Boss")
            break
            
    if target_boss_index == -1:
        return "No available Eudemon bosses (or failed to fetch)"
        
    # Start Hunting
    start_res = await client.send_amf_request("A11M5XZ9wxhTs2Dr.iIOH3uczAJZI", [char_id, target_boss_index, sessionkey])
    if isinstance(start_res, dict) and "Rate limited" in str(start_res.get("result", "")):
        await asyncio.sleep(4) # Server rate limit backoff
        start_res = await client.send_amf_request("A11M5XZ9wxhTs2Dr.iIOH3uczAJZI", [char_id, target_boss_index, sessionkey])

    if not isinstance(start_res, dict) or start_res.get("status") != 1:
        return f"Failed to start {target_boss_name}: {start_res}"
        
    battle_id = str(start_res.get("code", ""))
    
    # Wait for battle (3s safe delay)
    await asyncio.sleep(3)
    
    # Finish Hunting
    loc2_str = str(target_boss_index) + str(char_id) + battle_id
    loc2 = hashlib.sha256(loc2_str.encode()).hexdigest()
    
    BATTLE_HASH = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDEiLCJiYWNrX2l0ZW0iOiJiYWNrXzAxIiwid2VhcG9uIjoid3BuXzAxIiwic2V0Ijoic2V0XzAxXzAifSwic3RhdHVzIjp7ImVhcnRoIjowLCJmaXJlIjowLCJ3YXRlciI6MCwibGlnaHRuaW5nIjowLCJ3aW5kIjowfSwiYnl0ZXMiOnsiXyI6ODIyODQ0NywiX18iOjgyMjg0NDcsIl9fXyI6IjE3NjI3NDY2NTk0MDM2N2MzY2M5OTlhOWY5ZTk1MWExZDMzMjExNTQ1Yjg0YjJkNWE2MzkzM2IwMDIwNDMzMDAwYzNiYjQxMGZiMTc2Mjc0NjY1OTE3NjI3NDY2NTkxNzYyNzQ2NjU5MTc2Mjc0NjY1OSIsIl9fX19fIjo4MjI4NDQ3LCJfX19fX18iOjgyMjg0NDcsIl9fX18iOjE3NjI3NDY2NTl9LCJfX19fIjpbeyJfIjoic2tpbGxfMTMiLCJfXyI6MjkxMzR9XX0="
    
    finish_params = [char_id, target_boss_index, battle_id, loc2, sessionkey, BATTLE_HASH]
    finish_res = await client.send_amf_request("A11M5XZ9wxhTs2Dr.L6IPyPI8oNXL", finish_params)
    if isinstance(finish_res, dict) and "Rate limited" in str(finish_res.get("result", "")):
        await asyncio.sleep(4)
        finish_res = await client.send_amf_request("A11M5XZ9wxhTs2Dr.L6IPyPI8oNXL", finish_params)
    
    if isinstance(finish_res, dict) and finish_res.get("status") == 1:
        return format_battle_rewards(f"Eudemon {target_boss_name}", finish_res, current_level=char_level, char_id=char_id)
    else:
        return f"Failed to defeat {target_boss_name}: {finish_res}"

async def run_circus_event(client: NinjaSageClient, sessionkey: str, char_id: int, boss_type: str = "ringmaster"):
    # 1. Get Character Data to calculate agility and _loc6_ (Using cache to eliminate redundant AMF calls)
    char_info_res = await get_or_fetch_event_char_data(client, sessionkey, char_id)
    if not isinstance(char_info_res, dict) or char_info_res.get('status') == 0:
        return f"Failed to fetch character data: {char_info_res.get('error', 'Unknown error')}"
        
    char_data = char_info_res
    char_agility = char_data.get('agility', 0)
    initial_tokens = int(char_info_res.get('account_tokens', 0))
    
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
        error_msg = start_res.get('result', start_res)
        return f"Failed to start Circus Event: {error_msg}"
        
    battle_code = start_res['code']
    
    # 3. Wait for battle (3.5s optimal safe duration for Circus)
    await asyncio.sleep(3.5)
    
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
        
    if isinstance(finish_res, dict) and finish_res.get('status') == 1:
        final_tokens = finish_res.get('account_tokens')
        if final_tokens is not None and int(final_tokens) < initial_tokens:
            return f"STOPPED: Tiket {boss_type.capitalize()} habis! Server memotong {initial_tokens - int(final_tokens)} Token. Bot dihentikan untuk melindungi tokenmu."
        level = await get_or_fetch_char_level(client, sessionkey, char_id)
        return format_battle_rewards(f"Circus {boss_type.capitalize()}", finish_res, current_level=level, char_id=char_id)
    else:
        error_msg = finish_res.get('result', finish_res) if isinstance(finish_res, dict) else finish_res
        return f"Circus Event Complete but server rejected finish: {error_msg}"

async def run_yokai_event(client: NinjaSageClient, sessionkey: str, char_id: int, boss_type: str = "kitsune"):
    # 1. Get Character Data (Using cache to eliminate redundant AMF calls)
    char_info_res = await get_or_fetch_event_char_data(client, sessionkey, char_id)
    if not isinstance(char_info_res, dict) or char_info_res.get('status') == 0:
        return f"Failed to fetch character data: {char_info_res.get('error', 'Unknown error')}"
        
    char_data = char_info_res
    char_agility = char_data.get('agility', 0)
    initial_tokens = int(char_info_res.get('account_tokens', 0))
    
    # BATTLE_HASH from config.py - the correct base64 string for Event battles
    # This is DIFFERENT from monster_hunting's equipment_data!
    BATTLE_HASH = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDQiLCJiYWNrX2l0ZW0iOiJiYWNrXzIyMDIiLCJ3ZWFwb24iOiJ3cG5fMjIxMyIsInNldCI6InNldF84MzFfMCJ9LCJfX19fIjpbeyJfIjoic2tpbGxfMDQiLCJfXyI6MjMzOTd9LHsiXyI6InNraWxsXzIzMDciLCJfXyI6NTQxMTR9LHsiXyI6InNraWxsXzAzIiwiX18iOjIyOTM0fSx7Il8iOiJza2lsbF82NTMiLCJfXyI6ODE1MTJ9LHsiXyI6InNraWxsXzE5NSIsIl9fIjo2NTczM30seyJfIjoic2tpbGxfMzE0IiwiX18iOjUyNjgxfSx7Il8iOiJza2lsbF8xODciLCJfXyI6NDc1Nzl9LHsiXyI6InNraWxsXzE2NCIsIl9fIjo1NDQ0NH1dLCJzdGF0dXMiOnsiZWFydGgiOjAsImxpZ2h0bmluZyI6MCwiZmlyZSI6MCwid2F0ZXIiOjAsIndpbmQiOjczfSwiYnl0ZXMiOnsiX19fIjoiMTc2Mjg0MzY2NjQwMzY3YzNjYzk5OWE5ZjllOTUxYTFkMzMyMTE1NDViODRiMmQ1YTYzOTMzYjAwMjA0MzMwMDBjM2JiNDEwZmIxNzYyODQzNjY2MTc2Mjg0MzY2NjE3NjI4NDM2NjYxNzYyODQzNjY2IiwiX19fX19fIjo4MjI4NDQ3LCJfIjo4MjI4NDQ3LCJfXyI6ODIyODQ0NywiX19fXyI6MTc2Mjg0MzY2NiwiX19fX18iOjgyMjg0NDd9fQ=="
    
    # 2. Start Event
    if boss_type == "kitsune":
        boss_id = 312610
        ene_id = "ene_2133"
        hp = 60800
        enemy_agility = 171
    elif boss_type == "tengu":
        boss_id = 312610
        ene_id = "ene_2132"
        hp = 75924
        enemy_agility = 176
    elif boss_type == "nurarihyon":
        boss_id = 312610
        ene_id = "ene_2131"
        hp = 114000
        enemy_agility = 176
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
    
    # 3. Wait for battle - 5 seconds (optimal safe & fast duration for Yokai boss)
    await asyncio.sleep(5)
    
    # 4. Finish Event
    # From Charles logs: Yokai uses the generic/summer event endpoints.
    damage_done = hp  # Doing full damage based on Charles logs or 61280.
    
    # We will use the same hardcoded EQUIPMENT_DATA from Monster Hunt.
    EQUIPMENT_DATA = "eyJpdGVtcyI6eyJhY2Nlc3NvcnkiOiJhY2Nlc3NvcnlfMDEiLCJiYWNrX2l0ZW0iOiJiYWNrXzIzODEiLCJ3ZWFwb24iOiJ3cG5fMjM4MCIsInNldCI6InNldF8yMjU4XzEifSwic3RhdHVzIjp7ImVhcnRoIjowLCJsaWdodG5pbmciOjAsImZpcmUiOjAsIndhdGVyIjowLCJ3aW5kIjo3OH0sImJ5dGVzIjp7Il9fXyI6IjE3NjM4Nzk1ODk0MDM2N2MzY2M5OTlhOWY5ZTk1MWExZDMzMjExNTQ1Yjg0YjJkNWE2MzkzM2IwMDIwNDMzMDAwYzNiYjQxMGZiMTc2Mzg3OTU4OTE3NjM4Nzk1ODkxNzYzODc5NTg5MTc2Mzg3OTU4OSIsIl8iOjgyMjg0NDcsIl9fX18iOjE3NjM4Nzk1ODksIl9fX19fIjo4MjI4NDQ3LCJfXyI6ODIyODQ0NywiX19fX19fIjo4MjI4NDQ3fSwiX19fXyI6W3siXyI6InNraWxsXzIzMTIiLCJfXyI6NTQ2MDV9LHsiXyI6InNraWxsXzM0NSIsIl9fIjo4MDI0M30seyJfIjoic2tpbGxfMjMxMCIsIl9fIjoxMjg0Njl9LHsiXyI6InNraWxsXzIyMTUiLCJfXyI6MjkzNDl9LHsiXyI6InNraWxsXzIyODYiLCJfXyI6NDk0NzR9LHsiXyI6InNraWxsXzIyMDYiLCJfXyI6NjA5NDR9LHsiXyI6InNraWxsXzIzMDgiLCJfXyI6NjUxMDF9LHsiXyI6InNraWxsXzMyOSIsIl9fIjo3NTM1Nn1dfQ=="
    
    hash_end_str = str(char_id) + ene_id + battle_code + str(damage_done) + EQUIPMENT_DATA
    # In Monster Hunt the hash calculation uses cucsg_hash locally but python uses hashlib.
    # The server accepts it since `bot_manager.py` uses this exact equipment data logic for Monster Hunt.
    hash_end = hashlib.sha256(hash_end_str.encode('utf-8')).hexdigest()
    
    try:
        finish_res = await client.send_amf_request("urUACOuL6PahuoEd.iETwupoGdQMO", [[
            char_id, ene_id, battle_code, damage_done, hash_end, EQUIPMENT_DATA, sessionkey
        ]])
    except Exception as e:
        return f"Yokai Event finish failed: {e}"
        
    if isinstance(finish_res, dict) and finish_res.get('status') == 1:
        final_tokens = finish_res.get('account_tokens')
        if final_tokens is not None and int(final_tokens) < initial_tokens:
            return f"STOPPED: Tiket {boss_type.capitalize()} habis! Server memotong {initial_tokens - int(final_tokens)} Token. Bot dihentikan untuk melindungi tokenmu."
        level = await get_or_fetch_char_level(client, sessionkey, char_id)
        return format_battle_rewards(f"Yokai {boss_type.capitalize()}", finish_res, current_level=level, char_id=char_id)
    else:
        error_msg = finish_res.get('result', finish_res) if isinstance(finish_res, dict) else finish_res
        return f"Yokai Event Complete but server rejected finish: {error_msg}"

async def run_yokai_minigame(client: NinjaSageClient, sessionkey: str, char_id: int):
    import hashlib
    import asyncio
    
    # 1. Get Minigame Data
    try:
        get_data_res = await client.send_amf_request("urUACOuL6PahuoEd.vcx81Tk10da9", [[char_id, sessionkey]])
    except Exception as e:
        return f"Failed to get Yokai Minigame Data: {e}"
        
    if not isinstance(get_data_res, dict) or get_data_res.get('status') == 0:
        return f"Failed to get Yokai Minigame Data: {get_data_res}"

    free_play = get_data_res.get('free_play', 0)
    energy = get_data_res.get('energy', 0)
    
    if free_play <= 0 and energy <= 0:
        return "Failed: Out of energy and free tries! Stopped to prevent token deduction."

    # 2. Start Minigame
    try:
        start_res = await client.send_amf_request("urUACOuL6PahuoEd.swP4z80ragAZ", [[char_id, sessionkey]])
    except Exception as e:
        return f"Failed to start Yokai Minigame: {e}"
        
    if not isinstance(start_res, dict):
        return f"Failed to start Yokai Minigame: Invalid response {type(start_res).__name__}"
    
    if start_res.get('status') == 0:
        return f"Failed to start Yokai Minigame: {start_res}"
        
    # Attempt to extract battle code
    battle_code = ""
    if 'battle_code' in start_res:
        battle_code = start_res['battle_code']
    elif 'code' in start_res:
        battle_code = start_res['code']
    else:
        # Some endpoints return code implicitly or it relies on a previously set character state
        pass
        
    await asyncio.sleep(3)
    
    score = 5240
    lanterns = 192
    combo = 192
    
    hash_str = f"{char_id}_{score}_{lanterns}_{combo}_{battle_code}"
    hash_val = hashlib.sha256(hash_str.encode('utf-8')).hexdigest()
    
    # 3. Finish Minigame
    try:
        finish_res = await client.send_amf_request("urUACOuL6PahuoEd.VQF5sdP8F3Yj", [[
            char_id, sessionkey, score, lanterns, combo, hash_val, battle_code
        ]])
    except Exception as e:
        return f"Failed to finish Yokai Minigame: {e}"
    
    if not isinstance(finish_res, dict) or finish_res.get('status') == 0:
        return f"Failed to finish Yokai Minigame: {finish_res}"
        
    level = await get_or_fetch_char_level(client, sessionkey, char_id)
    return format_battle_rewards("Yokai Minigame", finish_res, current_level=level, char_id=char_id)

async def run_auto_mission(client: NinjaSageClient, sessionkey: str, char_id: int, mission_id: str):
    import hashlib
    import asyncio
    
    if not mission_id or mission_id.lower() == "auto":
        try:
            char_data_res = await client.send_amf_request("CharacterDAO.getCharacterData", [char_id])
            if isinstance(char_data_res, dict) and char_data_res.get('status') == 1:
                level = int(char_data_res.get('character_level', 1))
                if level >= 40: mission_id = "msn_60"
                elif level >= 20: mission_id = "msn_35"
                elif level >= 10: mission_id = "msn_22"
                else: mission_id = "msn_11"
            else:
                return "Failed to fetch character data for auto-selection."
        except Exception as e:
            return f"Failed to get character level: {e}"

    # Dummy enemy parameters for starting the mission
    _loc2_ = "enm_302"
    _loc3_ = "id:enm_302|hp:100|agility:10"
    _loc4_ = ""
    
    # Calculate start hash
    start_hash_str = f"{_loc2_}{_loc3_}{_loc4_}"
    start_hash = hashlib.sha256(start_hash_str.encode('utf-8')).hexdigest()
    
    # 1. Start Mission
    try:
        start_res = await client.send_amf_request("IOIJB836r2Hu2PPW.mwaPMdtCPC5o", [
            char_id, mission_id, _loc2_, _loc3_, _loc4_, start_hash, sessionkey
        ])
    except Exception as e:
        return f"Failed to start mission: {e}"
        
    if not isinstance(start_res, dict):
        return f"Failed to start mission: Invalid response {type(start_res).__name__}"
    
    if start_res.get('status') == 0:
        return f"Failed to start mission: {start_res}"
        
    # Extract battle code
    battle_code = ""
    if 'battle_code' in start_res:
        battle_code = start_res['battle_code']
    elif 'code' in start_res:
        battle_code = start_res['code']
        
    if not battle_code:
        return f"Failed to start mission: No battle code found in {start_res}"
        
    await asyncio.sleep(1) # Fast clear
    
    # Calculate finish hash
    total_damage = 100
    finish_hash_str = f"{mission_id}{char_id}{battle_code}{total_damage}"
    finish_hash = hashlib.sha256(finish_hash_str.encode('utf-8')).hexdigest()
    
    # 2. Finish Mission
    try:
        finish_res = await client.send_amf_request("IOIJB836r2Hu2PPW.MSi71s3i1X89", [
            char_id, mission_id, battle_code, finish_hash, total_damage, sessionkey, 1, 0
        ])
    except Exception as e:
        return f"Failed to finish mission: {e}"
    
    if not isinstance(finish_res, dict) or finish_res.get('status') == 0:
        return f"Failed to finish mission: {finish_res}"
        
    level = await get_or_fetch_char_level(client, sessionkey, char_id)
    return format_battle_rewards(f"Auto Mission {mission_id}", finish_res, current_level=level, char_id=char_id)
