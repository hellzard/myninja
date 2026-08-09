from fastapi import APIRouter, Request, Response
from app.utilities.amf_decoder import decode_amf_request, encode_amf_response

router = APIRouter()

@router.post("/character/get-all-characters")
async def get_all_characters(request: Request):
    try:
        body = await request.body()
        if body:
            decoded = decode_amf_request(body)
            print("get_all_characters request:", decoded)
    except Exception as e:
        print("Error decoding AMF:", e)
    
    # Dummy character response based on Shinobi Revenge example
    response_data = {
        "status": 1,
        "error": 0,
        "account_type": 0,
        "tokens": 100,
        "total_characters": 1,
        "account_data": [{
            "char_id": 1,
            "character_name": "Ninja",
            "character_level": 1,
            "character_xp": 0,
            "character_gender": 0,
            "character_rank": 1,
            "character_element_1": 1,
            "character_element_2": 0,
            "character_element_3": 0,
            "character_gold": 2500,
            "character_tp": 0,
            "character_class": "",
            "gender": "male"
        }]
    }
    return Response(
        content=encode_amf_response("/character/get-all-characters", [response_data]), 
        media_type="application/x-amf"
    )

@router.post("/character/verify-files")
async def verify_files(request: Request):
    return Response(
        content=encode_amf_response("/character/verify-files", [{"status": True}]), 
        media_type="application/x-amf"
    )
