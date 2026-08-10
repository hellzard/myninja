import asyncio
from app.services.ninjasage_client import NinjaSageClient

async def main():
    client = NinjaSageClient()
    login_res = await client.login("test1234", "test1234")
    if login_res.get('status') != 'success':
        print("Login failed")
        return
    sessionkey = login_res['session_key']
    char_id = login_res['characters'][0]['id']
    
    # Try EventBattleSystem for normal mission
    mission_id = "msn_1"
    start_res = await client.send_amf_request("IOIJB836r2Hu2PPW.mwaPMdtCPC5o", [char_id, mission_id, "char_0", "char_0", "char_0", "char_0", sessionkey])
    print("EventBattleSystem start:", start_res)
    
    if start_res.get('status') == 1:
        bcode = start_res.get('battle_code')
        finish_res = await client.send_amf_request("IOIJB836r2Hu2PPW.MSi71s3i1X89", [char_id, mission_id, bcode, 1, 9999, sessionkey, [], 0])
        print("EventBattleSystem finish:", finish_res)
        
    # Try standard BattleSystem.startMission
    hash_test = "dummy"
    start2 = await client.send_amf_request("BattleSystem.startMission", [char_id, mission_id, "ene_0", "id:ene_0|hp:100|agility:10", 50, hash_test, sessionkey])
    print("BattleSystem start:", start2)

asyncio.run(main())
