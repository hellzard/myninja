from fastapi.testclient import TestClient

from app.main import app


def test_v6_runtime_routes_do_not_crash():
    with TestClient(app) as client:
        root = client.get("/")
        assert root.status_code == 200

        health = client.get("/healthz")
        assert health.status_code == 200

        ready = client.get("/readyz")
        assert ready.status_code == 200

        panel = client.get("/panel/", follow_redirects=True)
        assert panel.status_code == 200
