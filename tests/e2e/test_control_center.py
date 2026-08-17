import os
import re

import pytest
from playwright.sync_api import Page, expect

BASE_URL = os.getenv("E2E_BASE_URL", "http://127.0.0.1:8000")


def test_shell_and_release_assets(page: Page):
    page.goto(f"{BASE_URL}/panel/")
    expect(page).to_have_title(re.compile(r".*Ninja.*", re.IGNORECASE))
    response = page.request.get(f"{BASE_URL}/panel/version.json")
    assert response.ok
    assert response.json()["version"] == "6.0.0"
    ready = page.request.get(f"{BASE_URL}/readyz")
    assert ready.ok


@pytest.mark.parametrize("width,height", [(320, 568), (375, 812), (768, 1024)])
def test_mobile_shell_has_no_horizontal_overflow(page: Page, width: int, height: int):
    page.set_viewport_size({"width": width, "height": height})
    page.goto(f"{BASE_URL}/panel/")
    overflow = page.evaluate("document.documentElement.scrollWidth - document.documentElement.clientWidth")
    assert overflow <= 2


def test_recipe_dry_run_without_game_credentials(page: Page):
    response = page.request.post(
        f"{BASE_URL}/api/bot/recipe/dry-run",
        data={
            "recipe": {
                "name": "E2E",
                "steps": [
                    {"kind": "bot", "bot_type": "auto_level", "mode": "cycles", "cycles": 2}
                ],
            }
        },
    )
    assert response.ok
    data = response.json()
    assert data["status"] == "success"
