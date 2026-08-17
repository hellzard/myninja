from app.services.release_manager import config_checksum


def test_config_checksum_is_stable(monkeypatch):
    monkeypatch.setenv("BOT_ENGINE_MODE", "web")
    assert config_checksum() == config_checksum()
