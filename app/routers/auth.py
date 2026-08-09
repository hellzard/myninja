import time
from fastapi import APIRouter

router = APIRouter()

def check_version(args):
    # Expects ['Public 0.61']
    # Return local CDN
    return {
        'status': 1, 
        'error': 0, 
        'cdn': 'http://127.0.0.1:800/', 
        '_': time.time(), 
        '__': 'dummy_token', 
        '_rm': False
    }

def get_events(args):
    # Return empty events so client doesn't get stuck on images
    return {
        'status': 1, 
        'error': 0, 
        'events': {
            'seasonal': [], 
            'event:permanent': [],
            'features': [],
            'packages': []
        }
    }

def login_user(args):
    # Expects something like ['mulyono', 'QaA2lDIAh8/wbNCGo5bshw==', timestamp, num, num, 'token', 'hash', 'hash', 10]
    username = args[0] if len(args) > 0 else "unknown"
    print(f"User {username} is logging in locally!")
    
    # Return a successful login response based on shinobirevenge-api-reference
    return {
        "status": 1,
        "error": 0,
        "account_type": 0,
        "tokens": 100000,
        "total_characters": 1,
        "session_key": "local_session_abc123",
        "account_id": "local_account_1"
    }
