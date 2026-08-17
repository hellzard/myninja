from app.services import panel_guard


def test_signed_panel_session_when_secret_available(monkeypatch):
    monkeypatch.setattr(panel_guard, "SESSION_SECRET", "unit-test-secret")
    token = panel_guard.issue_session()
    assert panel_guard.verify_session(token)
    assert not panel_guard.verify_session(token + "x")
