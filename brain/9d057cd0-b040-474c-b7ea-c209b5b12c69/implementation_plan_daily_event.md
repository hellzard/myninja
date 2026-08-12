# Fix Daily Event Logic based on APK

This implementation plan outlines the steps to accurately recreate the "Daily Event" logic from the Ninja Sage APK (`daily.py` / `daily_dis.txt`), replacing the naive, hardcoded `msn_101`-`msn_111` frontend loop.

## Proposed Changes

### `app/services/bot_manager.py`
#### [NEW] `auto_daily_event`
- Add a new async function `auto_daily_event(client, sessionkey, char_id)`.
- It will fetch `SystemLogin.getCharacterData` to get the current level and rank (just like `auto_exam`).
- It will call `CharacterService.getMissionRoomData` to fetch the available daily missions.
- It will parse the `daily`, `tp`, and `ss` keys from the response.
- It will filter out TP missions if the user is < Level 40 or < Rank 5.
- It will filter out SS missions if the user is < Level 80 or < Rank 9.
- If there are valid missions with available attempts, it will pick one and execute it.
- **For normal missions (Daily/TP):** It will call our existing `run_mission(client, sessionkey, char_id, mission_id)` logic.
- **For Sage Scroll (SS) missions (`msn_109`, `msn_110`, `msn_111`):** It will call `BattleSystem.startSageScrollMiniGame` and `BattleSystem.finishSageScrollMiniGame` (with parameters `[char_id, sessionkey, mission_id]` and `[char_id, mission_id, battle_id, _loc2_, 0, sessionkey, battle_hash, 0]` respectively).
- If no missions are left, it will return "Daily missions completed".

### `app/main.py`
#### [MODIFY] `api_auto_daily_step`
- Update the API route `/api/bot/auto_daily_step` to call the new `auto_daily_event` function.
- It no longer needs to accept `req.mission_id`.

### `app/web/app.js`
#### [MODIFY] `app.js`
- Remove the hardcoded `currentDailyId = 101` loop logic in the "START" button for Auto Daily.
- The `autoDailyInterval` will simply POST to `/api/bot/auto_daily_step` without any `mission_id` parameter.
- The interval will automatically clear itself if the backend returns "Daily missions completed" or an error indicating no more missions are available.

## User Review Required
> [!IMPORTANT]
> The APK restricts TP (Training Point) missions to Level 40 / Rank 5, and SS (Sage Scroll) missions to Level 80 / Rank 9. This means lower-level characters will ONLY do the standard daily missions and automatically stop. Does this match your expectation of the game mechanics?

## Verification Plan

### Automated Tests
- N/A

### Manual Verification
- We will start the bot and click "START" on the Auto Daily button.
- We will verify that it correctly requests `getMissionRoomData` and executes exactly the missions that the server assigns, skipping completed ones.
- We will ensure it stops on its own when finished.
