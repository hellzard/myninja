import unittest
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.services.bot_manager import format_battle_rewards, _parse_materials

class TestRewardFormatter(unittest.TestCase):

    def test_yokai_single_material_list(self):
        """Test Yokai reward with single item string list (the exact payload that triggered the bug)."""
        payload = {'status': 1, 'result': [3166, 3166, ['material_2268']]}
        res = format_battle_rewards("Yokai Kitsune", payload)
        self.assertIn("Yokai Kitsune SUCCESS!", res)
        self.assertIn("XP: 3166", res)
        self.assertIn("Gold: 3166", res)
        self.assertIn("Materials: material_2268", res)

    def test_circus_multi_materials_list(self):
        """Test Circus reward with multiple material string IDs."""
        payload = {'status': 1, 'result': [3166, 3166, ['material_2267', 'material_2269']]}
        res = format_battle_rewards("Circus Ringmaster", payload)
        self.assertIn("Circus Ringmaster SUCCESS!", res)
        self.assertIn("XP: 3166", res)
        self.assertIn("Gold: 3166", res)
        self.assertIn("Materials: material_2267, material_2269", res)

    def test_nested_material_tuples(self):
        """Test reward with nested [id, amount] tuples."""
        payload = {'status': 1, 'result': [5000, 10000, [['material_2267', 2], ['material_2269', 5]]]}
        res = format_battle_rewards("Monster Hunt", payload)
        self.assertIn("Monster Hunt SUCCESS!", res)
        self.assertIn("XP: 5000", res)
        self.assertIn("Gold: 10000", res)
        self.assertIn("Materials: material_2267x2, material_2269x5", res)

    def test_rewards_dict_format(self):
        """Test dict style reward from missions."""
        payload = {
            'status': 1,
            'rewards': {
                'xp': 1500,
                'gold': 3000,
                'token': 10,
                'level': 60,
                'material': {'mat_fire': 3, 'mat_water': 1}
            }
        }
        res = format_battle_rewards("Mission S", payload)
        self.assertIn("Mission S SUCCESS!", res)
        self.assertIn("Level: 60", res)
        self.assertIn("XP: 1500", res)
        self.assertIn("Gold: 3000", res)
        self.assertIn("Token: 10", res)
        self.assertIn("Materials: mat_firex3, mat_waterx1", res)

    def test_direct_list_format(self):
        """Test direct list response."""
        payload = [2500, 5000, ['material_999'], 5]
        res = format_battle_rewards("Eudemon", payload)
        self.assertIn("Eudemon SUCCESS!", res)
        self.assertIn("XP: 2500", res)
        self.assertIn("Gold: 5000", res)
        self.assertIn("Token: 5", res)
        self.assertIn("Materials: material_999", res)

    def test_empty_or_malformed_rewards(self):
        """Test that malformed or empty payloads never raise exceptions."""
        self.assertIsNotNone(format_battle_rewards("Test", None))
        self.assertIsNotNone(format_battle_rewards("Test", {}))
        self.assertIsNotNone(format_battle_rewards("Test", []))
        self.assertIsNotNone(format_battle_rewards("Test", "Random String"))
        self.assertIsNotNone(format_battle_rewards("Test", {'result': []}))
        self.assertIsNotNone(format_battle_rewards("Test", {'result': [100]}))
        self.assertIsNotNone(format_battle_rewards("Test", {'result': [100, 200, None]}))

if __name__ == '__main__':
    unittest.main()
