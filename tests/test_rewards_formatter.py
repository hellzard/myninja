import unittest
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.services.bot_manager import format_battle_rewards, _parse_materials

class TestRewardFormatter(unittest.TestCase):

    def test_yokai_single_material_list(self):
        """Test Yokai reward with single item string list."""
        payload = {'status': 1, 'result': [3166, 3166, ['material_2268']]}
        res = format_battle_rewards("Yokai Kitsune", payload, current_level=60)
        self.assertIn("Yokai Kitsune SUCCESS!", res)
        self.assertIn("Level: 60", res)
        self.assertIn("XP: +3166", res)
        self.assertIn("Gold: +3166", res)
        self.assertIn("Token: 0", res)
        self.assertIn("Materials: material_2268", res)

    def test_circus_multi_materials_list(self):
        """Test Circus reward with multiple material string IDs."""
        payload = {'status': 1, 'result': [3166, 3166, ['material_2267', 'material_2269']]}
        res = format_battle_rewards("Circus Ringmaster", payload, current_level=60)
        self.assertIn("Circus Ringmaster SUCCESS!", res)
        self.assertIn("Level: 60", res)
        self.assertIn("XP: +3166", res)
        self.assertIn("Gold: +3166", res)
        self.assertIn("Token: 0", res)
        self.assertIn("Materials: material_2267, material_2269", res)

    def test_nested_material_tuples(self):
        """Test reward with nested [id, amount] tuples."""
        payload = {'status': 1, 'result': [5000, 10000, [['material_2267', 2], ['material_2269', 5]]]}
        res = format_battle_rewards("Monster Hunt", payload, current_level=80)
        self.assertIn("Monster Hunt SUCCESS!", res)
        self.assertIn("Level: 80", res)
        self.assertIn("XP: +5000", res)
        self.assertIn("Gold: +10000", res)
        self.assertIn("Token: 0", res)
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
        self.assertIn("XP: +1500", res)
        self.assertIn("Gold: +3000", res)
        self.assertIn("Token: +10", res)
        self.assertIn("Materials: mat_firex3, mat_waterx1", res)

    def test_direct_list_format(self):
        """Test direct list response."""
        payload = [2500, 5000, ['material_999'], 5]
        res = format_battle_rewards("Eudemon", payload, current_level=45)
        self.assertIn("Eudemon SUCCESS!", res)
        self.assertIn("Level: 45", res)
        self.assertIn("XP: +2500", res)
        self.assertIn("Gold: +5000", res)
        self.assertIn("Token: +5", res)
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

    def test_total_stats_tracking_with_snapshot(self):
        """Test Total XP, Total Gold, and Total Token tracking when snapshot is provided."""
        from app.services.bot_manager import update_char_snapshot
        char_id = 99999
        update_char_snapshot(char_id, initial_stats={"level": 76, "xp": 29000000, "gold": 15000000, "tokens": 200})
        
        payload1 = {'status': 1, 'result': [3200, 5000, [], 10]}
        res1 = format_battle_rewards("Auto Leveling", payload1, current_level=76, char_id=char_id)
        self.assertIn("Auto Leveling SUCCESS!", res1)
        self.assertIn("XP: +3200", res1)
        self.assertIn("Gold: +5000", res1)
        self.assertIn("Token: +10", res1)
        self.assertIn("Total XP: 29003200", res1)
        self.assertIn("Total Gold: 15005000", res1)
        self.assertIn("Total Token: 210", res1)

        # Step 2: Second mission adds up
        payload2 = {'status': 1, 'result': [3200, 5000, [], 0]}
        res2 = format_battle_rewards("Auto Leveling", payload2, current_level=76, char_id=char_id)
        self.assertIn("Total XP: 29006400", res2)
        self.assertIn("Total Gold: 15010000", res2)
        self.assertIn("Total Token: 210", res2)

    def test_explicit_total_xp_in_payload(self):
        """Test when server sends total cumulative xp at payload root (e.g. finish_res['xp'] = 29729477)."""
        payload = {
            'status': 1,
            'xp': 29729477,
            'character_gold': 15420000,
            'account_tokens': 350,
            'result': [3200, 3200, ['material_123'], 0]
        }
        res = format_battle_rewards("Mission msn_60", payload, current_level=76, char_id=12345)
        self.assertIn("Mission msn_60 SUCCESS!", res)
        self.assertIn("Level: 76", res)
        self.assertIn("XP: +3200", res)
        self.assertIn("Gold: +3200", res)
        self.assertIn("Token: 0", res)
        self.assertIn("Materials: material_123", res)
        self.assertIn("Total XP: 29729477", res)
        self.assertIn("Total Gold: 15420000", res)
        self.assertIn("Total Token: 350", res)

if __name__ == '__main__':
    unittest.main()
