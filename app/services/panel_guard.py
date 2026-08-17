from __future__ import annotations

import base64
import hashlib
import hmac
import json
import os
import secrets
import time
from collections import defaultdict, deque
from typing import Any, Dict, Optional
from urllib.parse import urlparse

from fastapi import Request, WebSocket
from fastapi.responses import JSONResponse

from app.services import durable_journal

try:
    from webauthn import (
        base64url_to_bytes,
        generate_authentication_options,
        generate_registration_options,
        options_to_json,
        verify_authentication_response,
        verify_registration_response,
    )
    from webauthn.helpers.structs import (
        AuthenticatorSelectionCriteria,
        PublicKeyCredentialDescriptor,
        ResidentKeyRequirement,
        UserVerificationRequirement,
    )
except Exception:
    base64url_to_bytes = None
    generate_authentication_options = None
    generate_registration_options = None
    options_to_json = None
    verify_authentication_response = None
    verify_registration_response = None
    AuthenticatorSelectionCriteria = None
    PublicKeyCredentialDescriptor = None
    ResidentKeyRequirement = None
    UserVerificationRequirement = None


GUARD_ENABLED = os.getenv("PANEL_GUARD_ENABLED", "0").strip() == "1"
SESSION_SECRET = os.getenv("PANEL_SESSION_SECRET", "").strip()
SETUP_TOKEN = os.getenv("PANEL_SETUP_TOKEN", "").strip()
RP_ID = os.getenv("PANEL_RP_ID", "").strip()
RP_NAME = os.getenv("PANEL_RP_NAME", "Ninja Sage Control Center").strip()
SESSION_TTL = max(900, min(86400, int(os.getenv("PANEL_SESSION_TTL_SECONDS", "43200") or 43200)))
ALLOWED_ORIGINS = {
    x.strip().rstrip("/")
    for x in os.getenv("PANEL_ALLOWED_ORIGINS", "").split(",")
    if x.strip()
}
RATE_WINDOW = 60.0
RATE_MAX = max(20, int(os.getenv("PANEL_API_RATE_LIMIT_PER_MINUTE", "180") or 180))

_challenges: Dict[str, Dict[str, Any]] = {}
_rate: dict[str, deque] = defaultdict(lambda: deque(maxlen=RATE_MAX * 2))


def enabled() -> bool:
    return GUARD_ENABLED


def _webauthn_ready() -> bool:
    return all([
        generate_registration_options, generate_authentication_options,
        verify_registration_response, verify_authentication_response,
        options_to_json, base64url_to_bytes,
    ])


def _b64(data: bytes) -> str:
    return base64.urlsafe_b64encode(bytes(data)).decode("ascii").rstrip("=")


def _allowed_origin(origin: str) -> bool:
    return bool(origin and origin.rstrip("/") in ALLOWED_ORIGINS)


def _expected_origin() -> str:
    if len(ALLOWED_ORIGINS) != 1:
        raise RuntimeError("Passkey enrollment/authentication requires exactly one PANEL_ALLOWED_ORIGINS entry.")
    return next(iter(ALLOWED_ORIGINS))


def _effective_rp_id() -> str:
    if RP_ID:
        return RP_ID
    origin = _expected_origin()
    return urlparse(origin).hostname or ""


def _prune_challenges() -> None:
    now = time.time()
    for key, item in list(_challenges.items()):
        if float(item.get("expires_at") or 0) <= now:
            _challenges.pop(key, None)


def _issue_challenge(kind: str, challenge: bytes) -> str:
    _prune_challenges()
    ceremony_id = secrets.token_urlsafe(24)
    _challenges[ceremony_id] = {
        "kind": kind,
        "challenge": bytes(challenge),
        "expires_at": time.time() + 300,
    }
    return ceremony_id


def _consume_challenge(ceremony_id: str, kind: str) -> bytes:
    _prune_challenges()
    item = _challenges.pop(str(ceremony_id), None)
    if not item or item.get("kind") != kind:
        raise ValueError("Passkey ceremony expired or invalid")
    return bytes(item["challenge"])


def _sign(payload: bytes) -> str:
    if not SESSION_SECRET:
        raise RuntimeError("PANEL_SESSION_SECRET is required")
    return hmac.new(SESSION_SECRET.encode("utf-8"), payload, hashlib.sha256).hexdigest()


def issue_session() -> str:
    body = {
        "sub": "owner",
        "iat": int(time.time()),
        "exp": int(time.time()) + SESSION_TTL,
        "nonce": secrets.token_hex(12),
    }
    raw = base64.urlsafe_b64encode(
        json.dumps(body, separators=(",", ":")).encode("utf-8")
    ).decode("ascii").rstrip("=")
    return f"{raw}.{_sign(raw.encode('ascii'))}"


def verify_session(token: str) -> bool:
    try:
        raw, signature = str(token).split(".", 1)
        if not hmac.compare_digest(signature, _sign(raw.encode("ascii"))):
            return False
        padded = raw + "=" * (-len(raw) % 4)
        body = json.loads(base64.urlsafe_b64decode(padded.encode("ascii")))
        return body.get("sub") == "owner" and int(body.get("exp") or 0) > int(time.time())
    except Exception:
        return False


async def status() -> Dict[str, Any]:
    passkeys = await durable_journal.list_passkeys() if durable_journal.configured() else []
    configured = (
        (not enabled())
        or (
            bool(SESSION_SECRET)
            and bool(ALLOWED_ORIGINS)
            and durable_journal.configured()
            and _webauthn_ready()
        )
    )
    return {
        "enabled": enabled(),
        "configured": configured,
        "enrolled": bool(passkeys),
        "passkey_count": len(passkeys),
        "rp_id": _effective_rp_id() if ALLOWED_ORIGINS else RP_ID,
        "allowed_origins": sorted(ALLOWED_ORIGINS),
        "session_ttl_seconds": SESSION_TTL,
        "requires_setup_token": enabled() and not bool(passkeys),
    }


def _client_key(request: Request) -> str:
    forwarded = request.headers.get("x-forwarded-for", "").split(",")[0].strip()
    host = forwarded or (request.client.host if request.client else "unknown")
    return f"{host}:{request.url.path}"


def _rate_allowed(request: Request) -> bool:
    key = _client_key(request)
    now = time.monotonic()
    q = _rate[key]
    while q and now - q[0] > RATE_WINDOW:
        q.popleft()
    if len(q) >= RATE_MAX:
        return False
    q.append(now)
    return True


async def guard_http(request: Request) -> Optional[JSONResponse]:
    if not enabled():
        return None

    path = request.url.path
    public = (
        path.startswith("/api/v6/security/")
        or path in {"/healthz", "/readyz"}
        or not path.startswith("/api/")
    )
    if public:
        return None

    if not _rate_allowed(request):
        await durable_journal.audit("PANEL_RATE_LIMIT", {"path": path})
        return JSONResponse({"detail": "Panel API rate limit exceeded"}, status_code=429)

    origin = request.headers.get("origin")
    if origin and not _allowed_origin(origin):
        await durable_journal.audit("PANEL_ORIGIN_REJECTED", {"path": path, "origin": origin})
        return JSONResponse({"detail": "Unexpected Origin"}, status_code=403)

    token = request.headers.get("x-panel-session", "")
    if not verify_session(token):
        return JSONResponse({"detail": "Panel unlock required"}, status_code=401)
    return None


async def websocket_allowed(websocket: WebSocket) -> bool:
    if not enabled():
        return True
    origin = websocket.headers.get("origin", "")
    allowed = _allowed_origin(origin)
    if not allowed:
        await durable_journal.audit("WEBSOCKET_ORIGIN_REJECTED", {"origin": origin})
    return allowed


async def registration_options(setup_token: str) -> Dict[str, Any]:
    if not enabled():
        raise ValueError("Panel Guard is disabled")
    if not SETUP_TOKEN or not secrets.compare_digest(str(setup_token), SETUP_TOKEN):
        raise PermissionError("Invalid setup token")
    if not durable_journal.configured():
        raise RuntimeError("JOURNAL_DATABASE_URL is required for passkey storage")
    if not _webauthn_ready():
        raise RuntimeError("webauthn dependency is unavailable")

    existing = await durable_journal.list_passkeys()
    exclude = [
        PublicKeyCredentialDescriptor(id=base64url_to_bytes(item["credential_id"]))
        for item in existing
    ]
    options = generate_registration_options(
        rp_id=_effective_rp_id(),
        rp_name=RP_NAME,
        user_id=b"myninja-owner",
        user_name="owner",
        user_display_name="MyNinja Owner",
        exclude_credentials=exclude,
        authenticator_selection=AuthenticatorSelectionCriteria(
            resident_key=ResidentKeyRequirement.PREFERRED,
            user_verification=UserVerificationRequirement.REQUIRED,
        ),
    )
    ceremony_id = _issue_challenge("register", options.challenge)
    return {"ceremony_id": ceremony_id, "options": json.loads(options_to_json(options))}


async def finish_registration(
    ceremony_id: str,
    setup_token: str,
    credential: Dict[str, Any],
) -> Dict[str, Any]:
    if not SETUP_TOKEN or not secrets.compare_digest(str(setup_token), SETUP_TOKEN):
        raise PermissionError("Invalid setup token")
    challenge = _consume_challenge(ceremony_id, "register")
    verification = verify_registration_response(
        credential=credential,
        expected_challenge=challenge,
        expected_rp_id=_effective_rp_id(),
        expected_origin=_expected_origin(),
        require_user_verification=True,
    )
    transports = (
        credential.get("response", {}).get("transports", [])
        if isinstance(credential, dict) else []
    )
    record = {
        "credential_id": _b64(verification.credential_id),
        "credential_public_key": _b64(verification.credential_public_key),
        "sign_count": int(verification.sign_count or 0),
        "transports": transports if isinstance(transports, list) else [],
        "device_type": str(getattr(verification, "credential_device_type", "") or ""),
        "backed_up": bool(getattr(verification, "credential_backed_up", False)),
    }
    await durable_journal.save_passkey(record)
    await durable_journal.audit("PASSKEY_ENROLLED", {"credential_id": record["credential_id"][:16]})
    return {"session": issue_session(), "credential_id": record["credential_id"]}


async def authentication_options() -> Dict[str, Any]:
    if not enabled():
        raise ValueError("Panel Guard is disabled")
    records = await durable_journal.list_passkeys()
    if not records:
        raise RuntimeError("No passkey is enrolled")
    allow = [
        PublicKeyCredentialDescriptor(
            id=base64url_to_bytes(item["credential_id"]),
            transports=item.get("transports") or None,
        )
        for item in records
    ]
    options = generate_authentication_options(
        rp_id=_effective_rp_id(),
        allow_credentials=allow,
        user_verification=UserVerificationRequirement.REQUIRED,
    )
    ceremony_id = _issue_challenge("auth", options.challenge)
    return {"ceremony_id": ceremony_id, "options": json.loads(options_to_json(options))}


async def finish_authentication(ceremony_id: str, credential: Dict[str, Any]) -> Dict[str, Any]:
    challenge = _consume_challenge(ceremony_id, "auth")
    credential_id = str(credential.get("id") or "")
    records = await durable_journal.list_passkeys()
    record = next((x for x in records if x["credential_id"] == credential_id), None)
    if not record:
        raise PermissionError("Unknown passkey")

    verification = verify_authentication_response(
        credential=credential,
        expected_challenge=challenge,
        expected_rp_id=_effective_rp_id(),
        expected_origin=_expected_origin(),
        credential_public_key=base64url_to_bytes(record["credential_public_key"]),
        credential_current_sign_count=int(record.get("sign_count") or 0),
        require_user_verification=True,
    )
    await durable_journal.update_passkey_sign_count(
        credential_id, int(verification.new_sign_count or 0)
    )
    await durable_journal.audit("PASSKEY_AUTHENTICATED", {"credential_id": credential_id[:16]})
    return {"session": issue_session(), "expires_in": SESSION_TTL}
