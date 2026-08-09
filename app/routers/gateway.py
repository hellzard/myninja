from fastapi import APIRouter, Response
from app.routers import auth
import traceback

router = APIRouter()

async def handle_amf_request(body_bytes: bytes) -> Response:
    try:
        from pyamf import remoting
        from app.utilities.amf_decoder import encode_amf_response
        
        envelope = remoting.decode(body_bytes)
        
        # We will handle the first request in the envelope
        response_uri = "/1"
        method = "Unknown"
        args = []
        
        if envelope.bodies:
            response_uri = envelope.bodies[0][0]
            message = envelope.bodies[0][1]
            method = getattr(message, 'target', '')
            args = getattr(message, 'body', [])
            
        print(f"AMF Request: {method} args: {args}")
        
        # Route to the appropriate function
        response_data = {"status": 1, "error": 1, "message": "Method not implemented"}
        
        if method == "qgnNJXdbTxOLTF3S.6zWoiSDdFxW3":
            # checkVersion
            response_data = auth.check_version(args)
        elif method == "0KarDls5w35giAP7.Gj8OdFY7bfva":
            # init
            response_data = {"status": 1, "error": 0}
        elif method == "P82btEvICVSugCUp.N3M3nS3I5og3":
            # getEvents
            response_data = auth.get_events(args)
        elif method == "qgnNJXdbTxOLTF3S.n2znaFWme0q6":
            # loginUser
            response_data = auth.login_user(args)
        else:
            print(f"UNHANDLED METHOD: {method}")
            
        # Format response uri
        resp_uri = response_uri
        if not resp_uri.endswith("/onResult"):
            resp_uri += "/onResult"
            
        amf_resp = encode_amf_response(resp_uri, [response_data])
        return Response(content=amf_resp, media_type="application/x-amf")
    except Exception as e:
        print(f"Gateway AMF Error: {e}\n{traceback.format_exc()}")
        return Response(content='{"status": 1, "message": "error"}', status_code=500, media_type="application/json")
