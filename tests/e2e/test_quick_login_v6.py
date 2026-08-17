import re
from playwright.sync_api import Page, expect

BASE_URL = "http://127.0.0.1:8000"

def mock_login(page: Page):
    page.route(
        "**/api/auth/login",
        lambda route: route.fulfill(
            status=200,
            content_type="application/json",
            body='{"status":"success","sessionkey":"test-session","char_id":123,"char_name":"Quick Ninja","level":42,"xp":1000,"gold":2000,"tokens":30}',
        ),
    )

def test_quick_login_survives_logout_in_same_tab(page: Page):
    mock_login(page)
    page.goto(f"{BASE_URL}/panel/")
    page.locator("#login-user").fill("quick-user")
    page.locator("#login-pass").fill("quick-pass")
    page.locator("#login-btn").click()
    expect(page.locator("#app-shell")).to_be_visible()

    stored = page.evaluate("JSON.parse(sessionStorage.getItem('ns_quick_login'))")
    assert stored["user"] == "quick-user"
    assert stored["pass"] == "quick-pass"

    page.once("dialog", lambda dialog: dialog.accept())
    page.locator("#btn-logout").click()
    page.wait_for_load_state("domcontentloaded")

    expect(page.locator("#auth-view")).to_be_visible()
    stored_after = page.evaluate("JSON.parse(sessionStorage.getItem('ns_quick_login'))")
    assert stored_after["user"] == "quick-user"
    expect(page.locator("#quick-login-btn")).to_contain_text(re.compile("READY", re.I))
    assert page.locator("#login-pass").input_value() == ""

    page.locator("#quick-login-btn").click()
    expect(page.locator("#app-shell")).to_be_visible()
