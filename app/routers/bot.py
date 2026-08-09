from fastapi import APIRouter
from app.services.ninjasage_client import NinjaSageClient

router = APIRouter(prefix="/bot-api")

@router.post("/check-version")
async def check_version():
    """
    Contacts the official Ninja Sage server and returns the version handshake tokens.
    """
    try:
        client = NinjaSageClient()
        response = await client.check_version()
        return {"status": "success", "data": response}
    except Exception as e:
        return {"status": "error", "message": str(e)}
