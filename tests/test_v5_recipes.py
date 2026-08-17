from app.services.recipes import validate_recipe, dry_run
from app.services.settings_manager import DEFAULT_SETTINGS


def test_recipe_validation_and_dry_run():
    recipe={"name":"test","steps":[{"kind":"bot","bot_type":"auto_level","mode":"cycles","cycles":2},{"kind":"wait","seconds":5}]}
    normalized=validate_recipe(recipe)
    assert len(normalized["steps"])==2
    result=dry_run(recipe,DEFAULT_SETTINGS)
    assert result["estimate_seconds"]>=15


def test_recipe_rejects_unknown_bot():
    try:
        validate_recipe({"steps":[{"kind":"bot","bot_type":"unknown","mode":"cycles","cycles":1}]})
    except ValueError:
        return
    raise AssertionError("unknown bot_type should be rejected")
