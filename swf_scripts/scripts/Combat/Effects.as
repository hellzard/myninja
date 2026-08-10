package Combat
{
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import gs.easing.Linear;
   
   public class Effects
   {
      
      public static var buff_overlay:Array = [];
      
      public static var immediately_affected_effects:Array = ["sacrifice_hp_random_buff","sacrifice_self_health","increase_buff_duration","add_cooldown_player","toad_fire","steal_buff","sensation","instant_kill","add_buff_duration","add_debuff_duration","kill_instant_under","absorb_hp_to_sp","instant_drain_sp","shield","senju_mark","increase_wind_cd","drain_cp_stun","drain_cp_injury","increase_fire_cd","increase_lightning_cd","increase_earth_cd","increase_water_cd","absorb_buff","revive_teammates","pet_flame_eater","pet_reduce_cd_random","pet_oil_bottle","set_single_cooldown","set_all_cooldown","random_add_cooldown","pet_random_add_cooldown","pet_ocean_atmosphere","recover_hp_cp","hpcp_up","sacrifice_self_health","sacrifice_self_health_chance","lock","heal","kira_kuin","pet_heal","debuff_clear","purify","disperse","disperse_all","self_disperse_all","oblivion","add_cooldown","instant_hp_recover","instant_cp_recover","insta_consume_all_cp","plague","instant_reduce_cp","instant_reduce_hp","insta_reduce_max_cp"
      ,"reduce_hp_as_damage","insta_reduce_curr_hp","insta_reduce_max_hp","insta_reduce_max_hpcp","drain_cp_with_attack","drain_hp_with_attack","insta_drain_hp","insta_drain_cp","current_hp_drain","current_cp_drain","hp_drain","cp_drain","pet_drain_HpCp","drain_HpCp","double_cp_consumption","damage_to_hp","rapid_cooldown","reduce_cd","pet_reduce_cd","pet_cp_drain","pet_hp_drain","attack_reduce_gen_cooldown"];
      
      public static var using_heal_mc_effects:Array = ["BloodfeedMC","BloodlustMC","HealMC","DamageAbsorption","DamageToHp","LiquidationArmor"];
      
      public static var all_buffs:Object = {
         "bless":{
            "effect":"bless",
            "effect_name":"Bless",
            "duration_deduct":"after_attack",
            "effect_description":"debuff resist and cannot be disperse"
         },
         "defer":{
            "effect":"defer",
            "effect_name":"Time Distortion",
            "duration_deduct":"after_attack",
            "effect_description":"Delays damage taken, grants debuff immunity, then releases the stored damage and blocks healing on expiry."
         },
         "counter_effect":{
            "effect":"counter_effect",
            "effect_name":"Reflective Strike",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "shield":{
            "effect":"shield",
            "effect_name":"Shield",
            "duration_deduct":"immediately",
            "effect_description":"Grant a shield for x amount"
         },
         "sacrifice_hp_random_buff":{
            "effect":"sacrifice_hp_random_buff",
            "effect_name":"Sacrifice",
            "duration_deduct":"immediately",
            "effect_description":"Sacrifices 30% current HP and CP to trigger a random instant buff."
         },
         "senju_mark":{
            "effect":"senju_mark",
            "effect_name":"Senju Mark",
            "duration_deduct":"immediately",
            "effect_description":"Grant a shield for x amount"
         },
         "debuff_clear_next_turn":{
            "effect":"debuff_clear_next_turn",
            "effect_name":"",
            "duration_deduct":"immediately",
            "effect_description":"Remove all current debuffs from user."
         },
         "critical_buff_n_received_stun":{
            "effect":"critical_buff_n_received_stun",
            "effect_name":"Supercharged",
            "duration_deduct":"after_attack",
            "effect_description":"Increase critical rate and damage by x% an y turn, also stun the attacker for x turn"
         },
         "domain_expansion":{
            "effect":"domain_expansion",
            "effect_name":"Alter Reality",
            "duration_deduct":"after_attack",
            "effect_description":"Increase max HP and max CP by x% for y turns."
         },
         "change_background":{
            "effect":"change_background",
            "effect_name":"Ame no Kanata",
            "duration_deduct":"after_attack",
            "effect_description":"Change the battle background for x turns."
         },
         "sage_mode":{
            "effect":"sage_mode",
            "effect_name":"Sage Mode",
            "duration_deduct":"after_attack",
            "effect_description":"Ninjutsu, Taijutsu, Talent and Senjutsu will cast an extra 5% damage without costing any SP"
         },
         "increase_agility":{
            "effect":"increase_agility",
            "effect_name":"Agility Increase",
            "duration_deduct":"immediately",
            "effect_description":"Increase Agility by x% for y turn."
         },
         "self_love":{
            "effect":"self_love",
            "effect_name":"Self Love",
            "duration_deduct":"after_attack",
            "effect_description":"Increase max HP and max CP by x% for y turns."
         },
         "bloodflame":{
            "effect":"bloodflame",
            "effect_name":"Bloodflame",
            "duration_deduct":"after_attack",
            "effect_description":"Increase max HP and max CP by x% for y turns."
         },
         "slug_sage":{
            "effect":"slug_sage",
            "effect_name":"Slug Sage",
            "duration_deduct":"after_attack",
            "effect_description":"Increase max HP by x% for y turns and recover x% HP every turn."
         },
         "meditation":{
            "effect":"meditation",
            "effect_name":"Meditation",
            "duration_deduct":"immediately",
            "effect_description":"Increase dodge rate and heal overtime."
         },
         "purify":{
            "effect":"purify",
            "effect_name":"Purify",
            "duration_deduct":"immediately",
            "effect_description":"Remove all current debuffs from user."
         },
         "energize":{
            "effect":"energize",
            "effect_name":"Energize",
            "duration_deduct":"after_attack",
            "effect_description":"Increase critical chance, dodge rate, combustion, purify, and reactive force by x% for y turns."
         },
         "rampage":{
            "effect":"rampage",
            "effect_name":"Rampage",
            "duration_deduct":"never",
            "effect_description":""
         },
         "pet_stubborn_recover_cp":{
            "effect":"pet_stubborn_recover_cp",
            "effect_name":"Stubborn",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "invincible":{
            "effect":"invincible",
            "effect_name":"Invincible",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "illuminated_chakra_mode":{
            "effect":"illuminated_chakra_mode",
            "effect_name":"Illuminated Chakra Mode",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "reflexes":{
            "effect":"reflexes",
            "effect_name":"Flexible",
            "duration_deduct":"after_attack",
            "effect_description":"Increase dodge chance by x% for y turns."
         },
         "flexible":{
            "effect":"flexible",
            "effect_name":"Flexible",
            "duration_deduct":"after_attack",
            "effect_description":"Increase dodge chance by x% for y turns."
         },
         "pet_flexible":{
            "effect":"pet_flexible",
            "effect_name":"Flexible",
            "duration_deduct":"after_attack",
            "effect_description":"Increase dodge chance by x% for y turns."
         },
         "attacker_disorient":{
            "effect":"attacker_disorient",
            "effect_name":"Attacker Disoriented",
            "duration_deduct":"after_attack",
            "effect_description":"Disorient attacker."
         },
         "slow_attacker":{
            "effect":"slow_attacker",
            "effect_name":"Attacker Slow",
            "duration_deduct":"after_attack",
            "effect_description":"Slow attacker."
         },
         "poison_attacker":{
            "effect":"poison_attacker",
            "effect_name":"Attacker Poison",
            "duration_deduct":"after_attack",
            "effect_description":"Poison attacker."
         },
         "pet_frenzy":{
            "effect":"pet_frenzy",
            "effect_name":"Frenzy",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage by x% and y% critical chance for z turns."
         },
         "pet_mortal":{
            "effect":"pet_mortal",
            "effect_name":"Mortal",
            "duration_deduct":"after_attack",
            "effect_description":"Increase critical damage by x% for y turns."
         },
         "power_up":{
            "effect":"power_up",
            "effect_name":"Strengthen",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage by x% for y turns."
         },
         "shukaku_blessing":{
            "effect":"shukaku_blessing",
            "effect_name":"Shukaku Blessing",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage by x% for y turns."
         },
         "strengthen":{
            "effect":"strengthen",
            "effect_name":"Strengthen",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage by x% for y turns."
         },
         "strengthen_special":{
            "effect":"strengthen_special",
            "effect_name":"Strengthen",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage by x% for y turns."
         },
         "pet_strengthen":{
            "effect":"pet_strengthen",
            "effect_name":"Strengthen",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage by x% for y turns."
         },
         "tolerance":{
            "effect":"tolerance",
            "effect_name":"Tolerance",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage and decrease all damage by x% for y turns."
         },
         "vigor":{
            "effect":"vigor",
            "effect_name":"Vigor",
            "duration_deduct":"after_attack",
            "effect_description":"Immune to Internal Injury for x turns."
         },
         "boundless":{
            "effect":"boundless",
            "effect_name":"Boundless",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "inquisitor":{
            "effect":"inquisitor",
            "effect_name":"Inquisitor",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage and agility by x% for y turns."
         },
         "fire_wall":{
            "effect":"fire_wall",
            "effect_name":"Fire Wall",
            "duration_deduct":"after_attack",
            "effect_description":"Attackers get x% of burn for y turns."
         },
         "pet_fire_wall":{
            "effect":"pet_fire_wall",
            "effect_name":"Fire Wall",
            "duration_deduct":"after_attack",
            "effect_description":"Attackers get x% of burn for y turns."
         },
         "attacker_bleeding":{
            "effect":"attacker_bleeding",
            "effect_name":"Bleeding Attacker",
            "duration_deduct":"after_attack",
            "effecct_description":"ngasih bleeding ke musuh yg nge-attack."
         },
         "pet_attacker_bleeding":{
            "effect":"pet_attacker_bleeding",
            "effect_name":"Bleeding Attacker",
            "duration_deduct":"after_attack",
            "effecct_description":"ngasih bleeding ke musuh yg nge-attack."
         },
         "power_up_battle":{
            "effect":"power_up_battle",
            "effect_name":"Strengthen",
            "duration_deduct":"never",
            "effect_description":"Increase all attack damage by x% for y turns."
         },
         "ocean_atmosphere":{
            "effect":"ocean_atmosphere",
            "effect_name":"Ocean Atmosphere",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce master x% of cp comsuption for y turns."
         },
         "pet_ocean_atmosphere":{
            "effect":"pet_ocean_atmosphere",
            "effect_name":"Ocean Atmosphere",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce master x% of cp comsuption for y turns."
         },
         "reduce_cd":{
            "effect":"reduce_cd",
            "effect_name":"Reduce Cooldown",
            "duration_deduct":"immediately",
            "effect_description":"Reduce cooldown of resting skills by x turns. (not including talent skills)"
         },
         "rapid_cooldown":{
            "effect":"rapid_cooldown",
            "effect_name":"Rapid Cooldown",
            "duration_deduct":"immediately",
            "effect_description":"Reduce cooldown of resting skills by x turns. (not including talent skills)"
         },
         "pet_reduce_cd":{
            "effect":"pet_reduce_cd",
            "effect_name":"Reduce Cooldown",
            "duration_deduct":"immediately",
            "effect_description":"Reduce cooldown of resting skills by x turns. (not including talent skills)"
         },
         "debuff_resist":{
            "effect":"debuff_resist",
            "effect_name":"Debuff Resist",
            "duration_deduct":"after_attack",
            "effect_description":"Resist all debuffs except disperse, drain cp, drain hp and oblivion for x turns"
         },
         "pet_debuff_resist":{
            "effect":"pet_debuff_resist",
            "effect_name":"Debuff Resist",
            "duration_deduct":"after_attack",
            "effect_description":"Resist all debuffs except disperse, drain cp, drain hp and oblivion for x turns"
         },
         "unyielding":{
            "effect":"unyielding",
            "effect_name":"Unyielding",
            "duration_deduct":"after_attack",
            "effect_description":"Maintaining 1 HP"
         },
         "increase_charge_master":{
            "effect":"increase_charge_master",
            "effect_name":"Increase Charge Master",
            "duration_deduct":"after_attack",
            "effect_description":"Increase Charge Master by x% for y turn"
         },
         "stealth":{
            "effect":"stealth",
            "effect_name":"Stealth",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce damage taken by x% until your next turn and increase all attack damage by y % on your next turn"
         },
         "wolfram":{
            "effect":"wolfram",
            "effect_name":"Wolfram",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce damage taken by x% for y turns."
         },
         "protection":{
            "effect":"protection",
            "effect_name":"Protection",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce damage taken by x% for y turns."
         },
         "pet_protection":{
            "effect":"pet_protection",
            "effect_name":"Protection",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce damage taken by x% for y turns."
         },
         "plus_protection":{
            "effect":"plus_protection",
            "effect_name":"Plus Protection",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce damage taken by x% for y turns."
         },
         "preservation":{
            "effect":"preservation",
            "effect_name":"Preservation",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce damage taken by x% for y turns."
         },
         "reduce_wind_cd":{
            "effect":"reduce_wind_cd",
            "effect_name":"Reduce Wind CD",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce 1 Wind Ninjutsu CD on every attack the player receives for y turns."
         },
         "cp_shield":{
            "effect":"cp_shield",
            "effect_name":"CP Shield",
            "duration_deduct":"after_attack",
            "effect_description":"If the target or user gets attacked, the user\'s CP will reduce instead of their HP in a ratio of 1 HP = x CP. When they have no CP, they go back to taking damage by HP."
         },
         "cp_shield_and_increase_purify":{
            "effect":"cp_shield_and_increase_purify",
            "effect_name":"CP Shield",
            "duration_deduct":"after_attack",
            "effect_description":"If the target or user gets attacked, the user\'s CP will reduce instead of their HP in a ratio of 1 HP = x CP. When they have no CP, they go back to taking damage by HP."
         },
         "pet_cp_shield":{
            "effect":"pet_cp_shield",
            "effect_name":"CP Shield",
            "duration_deduct":"after_attack",
            "effect_description":"If the target or user gets attacked, the user\'s CP will reduce instead of their HP in a ratio of 1 HP = x CP. When they have no CP, they go back to taking damage by HP."
         },
         "serene_mind":{
            "effect":"serene_mind",
            "effect_name":"Serene Mind",
            "duration_deduct":"after_attack",
            "effect_description":"Rebound all damage taken for x turns"
         },
         "pet_serene_mind":{
            "effect":"pet_serene_mind",
            "effect_name":"Serene Mind",
            "duration_deduct":"after_attack",
            "effect_description":"Rebound all damage taken for x turns"
         },
         "rage":{
            "effect":"rage",
            "effect_name":"Rage",
            "duration_deduct":"after_attack",
            "effect_description":" Increase damage as well as damage taken by x%; Enemy also takes all damage they gave you for y turns as well."
         },
         "self_reduce_hp":{
            "effect":"self_reduce_hp",
            "effect_name":"Reduce HP",
            "duration_deduct":"never",
            "effect_description":"Reduce user\'s HP by x% every turn."
         },
         "kontol_memek_jembut":{
            "effect":"kontol_memek_jembut",
            "effect_name":"Increase Accuracy",
            "duration_deduct":"immediately",
            "effect_description":"Increase accuracy by x % for y turns."
         },
         "kontol_jembut_memek":{
            "effect":"kontol_jembut_memek",
            "effect_name":"Increase Critical Chance",
            "duration_deduct":"after_attack",
            "effect_description":"Increase critical chance by x % for y turns."
         },
         "kyubi_cloak":{
            "effect":"kyubi_cloak",
            "effect_name":"Kurama Cloak",
            "duration_deduct":"after_attack",
            "effect_description":"Bloodfeed and Strengthen"
         },
         "deka_kontol":{
            "effect":"deka_kontol",
            "effect_name":"Increase Dodge Chance",
            "duration_deduct":"after_attack",
            "effect_description":"Increase dodge chance by x % for y turns when your hp is less than z%."
         },
         "solar_might":{
            "effect":"solar_might",
            "effect_name":"Solar Might",
            "duration_deduct":"after_attack",
            "effect_description":"Increase accuracy by x %  and increase damage by y % for z turns."
         },
         "increase_accuracy":{
            "effect":"increase_accuracy",
            "effect_name":"Increase Accuracy",
            "duration_deduct":"after_attack",
            "effect_description":"Increase accuracy by x % for y turns."
         },
         "aqua_regia":{
            "effect":"aqua_regia",
            "effect_name":"Aqua Regia",
            "duration_deduct":"immediately",
            "effect_description":"Increase accuracy by x% and purify chance by y % for z turns."
         },
         "attention":{
            "effect":"attention",
            "effect_name":"Attention",
            "duration_deduct":"after_attack",
            "effect_description":"Increase accuracy by x % for y turns."
         },
         "pet_attention":{
            "effect":"pet_attention",
            "effect_name":"Attention",
            "duration_deduct":"after_attack",
            "effect_description":"Increase accuracy by x % for y turns."
         },
         "toad_attention":{
            "effect":"toad_attention",
            "effect_name":"Toad Spirit: Attention",
            "duration_deduct":"after_attack",
            "effect_description":"Increase accuracy by x % for y turns."
         },
         "peace":{
            "effect":"peace",
            "effect_name":"Peace",
            "duration_deduct":"immediately",
            "effect_description":"User\'s dodge rate increases by x%  and CP is recovered by y% amount of total CP for z number of turns."
         },
         "restoration":{
            "effect":"restoration",
            "effect_name":"Restoration",
            "duration_deduct":"immediately",
            "effect_description":"Restore x% cp for y turns."
         },
         "pet_restoration":{
            "effect":"pet_restoration",
            "effect_name":"Restoration",
            "duration_deduct":"immediately",
            "effect_description":"Restore x% cp for y turns."
         },
         "overload":{
            "effect":"overload",
            "effect_name":"Overload",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "titan_mode":{
            "effect":"titan_mode",
            "effect_name":"Titan Mode",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "emberstep_demonic":{
            "effect":"emberstep_demonic",
            "effect_name":"Emberstep Demonic",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "taijutsu_strengthen":{
            "effect":"taijutsu_strengthen",
            "effect_name":"Taijutsu Strengthen",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "senjutsu_strengthen":{
            "effect":"senjutsu_strengthen",
            "effect_name":"Strengthen",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "extreme_mode":{
            "effect":"extreme_mode",
            "effect_name":"Extreme Mode",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "regenHP":{
            "effect":"regenHP",
            "effect_name":"Regeneration",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "regeneration":{
            "effect":"regeneration",
            "effect_name":"Regeneration",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "pet_regeneration":{
            "effect":"pet_regeneration",
            "effect_name":"Regeneration",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "damage_absorption":{
            "effect":"damage_absorption",
            "effect_name":"Damage Absorption",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "liquidation_armor":{
            "effect":"liquidation_armor",
            "effect_name":"Saiken Cloak",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "guard":{
            "effect":"guard",
            "effect_name":"Guard",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce user damage taken by 100% for x turns."
         },
         "pet_guard":{
            "effect":"pet_guard",
            "effect_name":"Guard",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce user damage taken by 100% for x turns."
         },
         "debuff_clear":{
            "effect":"debuff_clear",
            "effect_name":"Debuff Clear",
            "duration_deduct":"immediately",
            "effect_description":"Remove all current debuffs from user."
         },
         "bloodfeed":{
            "effect":"bloodfeed",
            "effect_name":"Bloodfeed",
            "duration_deduct":"after_attack",
            "effect_description":"Recoved (x%)HP from damage done."
         },
         "pet_bloodfeed":{
            "effect":"pet_bloodfeed",
            "effect_name":"Bloodfeed",
            "duration_deduct":"after_attack",
            "effect_description":"Recoved (x%)HP from damage done."
         },
         "toad_spirit":{
            "effect":"toad_spirit",
            "effect_name":"Toad Spirit",
            "duration_deduct":"after_attack",
            "effect_description":"Increase Critical and Accuracy by x% for y turn"
         },
         "concentration":{
            "effect":"concentration",
            "effect_name":"Concentration",
            "duration_deduct":"after_attack",
            "effect_description":"Increase critical chance by x%."
         },
         "pet_concentration":{
            "effect":"pet_concentration",
            "effect_name":"Concentration",
            "duration_deduct":"after_attack",
            "effect_description":"Increase critical chance by x%."
         },
         "toad_concentration":{
            "effect":"toad_concentration",
            "effect_name":"Toad Spirit: Concentration",
            "duration_deduct":"after_attack",
            "effect_description":"Increase critical chance by x%."
         },
         "lightning_armor":{
            "effect":"lightning_armor",
            "effect_name":"Lightning Armor",
            "duration_deduct":"after_attack",
            "effect_description":"Increase damage and critical chance by x% and ignore x% of target\'s dodge rate."
         },
         "pet_lightning_armor":{
            "effect":"pet_lightning_armor",
            "effect_name":"Lightning Armor",
            "duration_deduct":"after_attack",
            "effect_description":"Increase damage and critical chance by x% and ignore x% of target\'s dodge rate."
         },
         "heavy_voltage":{
            "effect":"heavy_voltage",
            "effect_name":"Heavy Voltage",
            "duration_deduct":"after_attack",
            "effect_description":"Stun target x turns with Lightning Ninjutsu."
         },
         "overwhelm":{
            "effect":"overwhelm",
            "effect_name":"Overwhelm",
            "duration_deduct":"after_attack",
            "effect_description":"Increase dodge rate and agility by x% for y turns."
         },
         "random_debuff":{
            "effect":"random_debuff",
            "effect_name":"Random Debuff",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "random_s16":{
            "effect":"random_s16",
            "effect_name":"Bizarre",
            "duration_deduct":"never",
            "effect_description":""
         },
         "reduce_cp_consumption":{
            "effect":"reduce_cp_consumption",
            "effect_name":"Reduce CP Consumption",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "excitation":{
            "effect":"excitation",
            "effect_name":"Excitation",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "plus_extra_hp":{
            "effect":"plus_extra_hp",
            "effect_name":"Plus Extra HP",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "reduce_attacker_cp":{
            "effect":"reduce_attacker_cp",
            "effect_name":"Reduce Attacker CP",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "reduce_hp_attacker":{
            "effect":"reduce_hp_attacker",
            "effect_name":"Reduce Attacker HP",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "instant_reduce_hp_attacker":{
            "effect":"instant_reduce_hp_attacker",
            "effect_name":"Reduce Attacker HP",
            "duration_deduct":"immediately",
            "effect_description":"When this buff being active, attacker who hit the defender will instantly reduced their HP by x% or y number."
         },
         "dec_cp_attacker":{
            "effect":"dec_cp_attacker",
            "effect_name":"Reduce Attacker CP",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "lava_shield":{
            "effect":"lava_shield",
            "effect_name":"Lava Shield",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "pet_energize":{
            "effect":"pet_energize",
            "effect_name":"Energize",
            "duration_deduct":"after_attack",
            "effect_description":"Increases critical chance, dodge rate, combustion, purify, and reactive force by a x% for y number of turns."
         },
         "fast":{
            "effect":"fast",
            "effect_name":"Fast",
            "duration_deduct":"immediately",
            "effect_description":"Increases agility by a x% for y number of turns."
         },
         "agility_up":{
            "effect":"agility_up",
            "effect_name":"Increase Agility",
            "duration_deduct":"immediately",
            "effect_description":"Increases agility by a x% for y number of turns."
         },
         "pet_fast":{
            "effect":"pet_fast",
            "effect_name":"Fast",
            "duration_deduct":"immediately",
            "effect_description":"Increases agility by a x% for y number of turns."
         },
         "breakthrough":{
            "effect":"breakthrough",
            "effect_name":"Breakthrough",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "reactive_force":{
            "effect":"reactive_force",
            "effect_name":"Reactive Force",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "increase_silhouette_chance":{
            "effect":"increase_silhouette_chance",
            "effect_name":"Increase Silhouette Chance",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "wider":{
            "effect":"wider",
            "effect_name":"Wider",
            "duration_deduct":"never",
            "effect_description":""
         },
         "wellness":{
            "effect":"wellness",
            "effect_name":"Wellness",
            "duration_deduct":"never",
            "effect_description":""
         },
         "evade":{
            "effect":"evade",
            "effect_name":"Evade",
            "duration_deduct":"never",
            "effect_description":""
         },
         "reflect":{
            "effect":"reflect",
            "effect_name":"Reflect",
            "duration_deduct":"never",
            "effect_description":""
         },
         "venom_spread":{
            "effect":"venom_spread",
            "effect_name":"Venom Spread",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce Target\'s x% HP, CP, SP during target\'s attack"
         },
         "cannot_reduced_cp":{
            "effect":"cannot_reduced_cp",
            "effect_name":"CP Guard",
            "duration_deduct":"after_attack",
            "effect_description":"Prevent enemy to reduce or drain user CP for a number of turns."
         },
         "bleeding_protection":{
            "effect":"bleeding_protection",
            "effect_name":"Bleeding Protection",
            "duration_deduct":"after_attack",
            "effect_description":"Prevent enemy to inflict bleeding to user for a number of turns."
         },
         "unyielding_soul":{
            "effect":"unyielding_soul",
            "effect_name":"Unyielding Soul",
            "duration_deduct":"after_attack",
            "effect_description":"Negate any form of instant Reduce HP/CP by x% for y turns."
         },
         "damage_percent":{
            "effect":"damage_percent",
            "effect_name":"Increase Attack",
            "duration_deduct":"after_attack",
            "effect_description":"Increase all attack damage by x% for y turns."
         },
         "damage_reduce_self":{
            "effect":"damage_reduce_self",
            "effect_name":"Reduce Attack",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce user damage done by x% for y turns."
         },
         "defense_percent":{
            "effect":"defense_percent",
            "effect_name":"Increase Defense",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce damage taken by x% for y turns."
         },
         "accuracy_percent":{
            "effect":"accuracy_percent",
            "effect_name":"Increase Accuracy",
            "duration_deduct":"after_attack",
            "effect_description":"Increase accuracy by x% for y turns."
         },
         "dodge_percent":{
            "effect":"dodge_percent",
            "effect_name":"Increase Dodge",
            "duration_deduct":"after_attack",
            "effect_description":"Increase dodge chance by x% for y turns."
         },
         "critical_percent":{
            "effect":"critical_percent",
            "effect_name":"Increase Critical",
            "duration_deduct":"after_attack",
            "effect_description":"Increase critical chance by x% for y turns."
         },
         "purify_percent":{
            "effect":"purify_percent",
            "effect_name":"Increase Purify",
            "duration_deduct":"after_attack",
            "effect_description":"Increase purify chance by x% for y turns."
         }
      };
      
      public static var all_debuffs:Object = {
         "reverse_healing":{
            "effect":"reverse_healing",
            "effect_name":"Reverse Healing",
            "duration_deduct":"after_attack",
            "effect_description":"Any healing the target receives is converted into self-damage instead. Cannot be purified, only removed by sensation."
         },
         "disable_passive_talent":{
            "effect":"disable_passive_talent",
            "effect_name":"Disable Passive Talent",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "fast_forward":{
            "effect":"fast_forward",
            "effect_name":"Future Sentence",
            "duration_deduct":"after_attack",
            "effect_description":"Future Sentence"
         },
         "confinement":{
            "effect":"confinement",
            "effect_name":"Conefinement",
            "duration_deduct":"after_attack",
            "effect_description":"sama kaya serene mind tapi debuff"
         },
         "oblivion":{
            "effect":"oblivion",
            "effect_name":"Oblivion",
            "duration_deduct":"after_attack",
            "effect_description":"Increase cooldown for all skills by x. (not including talent skills)"
         },
         "decrease_charge":{
            "effect":"decrease_charge",
            "effect_name":"Decrease Charge",
            "duration_deduct":"after_attack",
            "effect_description":"Decrease target charge by x% for y turn"
         },
         "decrease_critical_damage":{
            "effect":"decrease_critical_damage",
            "effect_name":"Decrease Critical Damage",
            "duration_deduct":"after_attack",
            "effect_description":"Decrease target Critical Damage by x% for y turn"
         },
         "snake_mark":{
            "effect":"snake_mark",
            "effect_name":"Snake Mark",
            "duration_deduct":"after_attack",
            "effect_description":"Target cannot use Talent and Senjutsu for x Turns"
         },
         "time_stop":{
            "effect":"time_stop",
            "effect_name":"Time Stop",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"cannot move and ignore debuff resist"
         },
         "negate":{
            "effect":"negate",
            "effect_name":"Buff Negate",
            "duration_deduct":"after_attack",
            "effect_description":"Cannot receive buff when this debuff active"
         },
         "theft":{
            "effect":"theft",
            "effect_name":"Theft",
            "duration_deduct":"after_attack",
            "effect_description":"Increase hp on target that has this debuff"
         },
         "recoil_curse":{
            "effect":"recoil_curse",
            "effect_name":"Recoil Curse",
            "duration_deduct":"after_attack",
            "effect_description":"Reduces the cursed target\'s HP when they attack and recovers the reduced amount to the user. Accumulates per affected target on AoE attacks."
         },
         "blood_tax":{
            "effect":"blood_tax",
            "effect_name":"Blood Tax",
            "duration_deduct":"after_attack",
            "effect_description":"Drain attacker HP and heal all targets hit when the cursed target attacks"
         },
         "add_cooldown":{
            "effect":"add_cooldown",
            "effect_name":"add_cooldown",
            "duration_deduct":"after_attack",
            "effect_description":"Increase cooldown for all skills by x. (not including talent skills)"
         },
         "transform":{
            "effect":"transform",
            "effect_name":"Transform",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "disperse":{
            "effect":"disperse",
            "effect_name":"Disperse",
            "duration_deduct":"immediately",
            "effect_description":"Remove all buffs from target immediately."
         },
         "bleeding":{
            "effect":"bleeding",
            "effect_name":"Bleeding",
            "duration_deduct":"after_attack",
            "effect_description":"Increase damage taken by target by x% for y turns."
         },
         "pet_bleeding":{
            "effect":"pet_bleeding",
            "effect_name":"Bleeding",
            "duration_deduct":"after_attack",
            "effect_description":"Increase damage taken by target by x% for y turns."
         },
         "ultra_bleeding":{
            "effect":"ultra_bleeding",
            "effect_name":"Ultra Bleeding",
            "duration_deduct":"never",
            "effect_description":"Increase damage taken by target by x% with no turn limit. Amount increases by 10% each turn."
         },
         "decrease_max_cp":{
            "effect":"decrease_max_cp",
            "effect_name":"Decrease Max CP",
            "duration_deduct":"after_attack",
            "effect_description":"Decrease the target\'s CP limit by x% for y turn."
         },
         "decrease_max_hpcp":{
            "effect":"decrease_max_hpcp",
            "effect_name":"Decrease Max HP CP",
            "duration_deduct":"after_attack",
            "effect_description":"Decrease the target\'s HP and CP limit by x% for y turn."
         },
         "toxic_tooth":{
            "effect":"toxic_tooth",
            "effect_name":"Toxic Tooth",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "amount_change":0,
            "effect_description":"Petrify and poison target by x% for y turn."
         },
         "chaos":{
            "effect":"chaos",
            "effect_name":"Chaos",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Target can only randomly charge cp or weapon attack for x turns. (cannot be resisted)."
         },
         "pet_chaos":{
            "effect":"pet_chaos",
            "effect_name":"Chaos",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Target can only randomly charge cp or weapon attack for x turns. (cannot be resisted)."
         },
         "tease":{
            "effect":"tease",
            "effect_name":"Tease",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Targets are forced to use weapon attack only."
         },
         "stun":{
            "effect":"stun",
            "effect_name":"Stun",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Target cannot move for x turns. (50% chance to be resisted)."
         },
         "locked":{
            "effect":"locked",
            "effect_name":"Lock",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Target cannot move for x turns. (50% chance to be resisted)."
         },
         "skip_turn":{
            "effect":"skip_turn",
            "effect_name":"Skip Turn",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Skip turn target"
         },
         "pet_stun":{
            "effect":"pet_stun",
            "effect_name":"Stun",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Target cannot move for x turns. (50% chance to be resisted)."
         },
         "sleep":{
            "effect":"sleep",
            "effect_name":"Sleep",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Target cannot move for x turns."
         },
         "pet_sleep":{
            "effect":"pet_sleep",
            "effect_name":"Sleep",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Target cannot move for x turns."
         },
         "fear":{
            "effect":"fear",
            "effect_name":"Fear",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":""
         },
         "pet_fear":{
            "effect":"pet_fear",
            "effect_name":"Fear",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":""
         },
         "darkness":{
            "effect":"darkness",
            "effect_name":"Darkness",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce target\'s dodge rate and accuracy by x% for y turns."
         },
         "embrace":{
            "effect":"embrace",
            "effect_name":"Embrace",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce target\'s dodge rate, damage and purify chance by x% for y turns."
         },
         "internal_injury":{
            "effect":"internal_injury",
            "effect_name":"Internal Injury",
            "duration_deduct":"after_attack",
            "effect_description":"Target cannot heal by any method (jutsu, scroll etc) for x turns."
         },
         "pet_internal_injury":{
            "effect":"pet_internal_injury",
            "effect_name":"Internal Injury",
            "duration_deduct":"after_attack",
            "effect_description":"Target cannot heal by any method (jutsu, scroll etc) for x turns."
         },
         "hanyaoni":{
            "effect":"hanyaoni",
            "effect_name":"Hanyaoni",
            "duration_deduct":"after_attack",
            "effect_description":"Target cannot heal by any method (jutsu, scroll etc) for x turns."
         },
         "suffocate":{
            "effect":"suffocate",
            "effect_name":"Suffocate",
            "duration_deduct":"immediately",
            "effect_description":"Reduce HP and CP by x% for y turns. Target cannot heal by any method (jutsu, scroll etc) for z turns."
         },
         "disorient":{
            "effect":"disorient",
            "effect_name":"Disoriented",
            "duration_deduct":"after_attack",
            "effect_description":"Lower targets critical chance, dodge rate, combustion, purify, and reactive force by a x% for y number of turns."
         },
         "disorient_2":{
            "effect":"disorient_2",
            "effect_name":"Disoriented",
            "duration_deduct":"after_attack",
            "effect_description":"Lower targets critical chance, dodge rate, combustion, purify, and reactive force by a x% for y number of turns."
         },
         "pet_disorient":{
            "effect":"pet_disorient",
            "effect_name":"Disoriented",
            "duration_deduct":"after_attack",
            "effect_description":"Lower targets critical chance, dodge rate, combustion, purify, and reactive force by a x% for y number of turns."
         },
         "dark_curse":{
            "effect":"dark_curse",
            "effect_name":"Dark Curse",
            "duration_deduct":"after_attack",
            "effect_description":"Lower targets critical chance, dodge rate and attack damage by a x% for y number of turns."
         },
         "vulnerable":{
            "effect":"vulnerable",
            "effect_name":"Vulnerable",
            "duration_deduct":"after_attack",
            "effect_description":"Increase damage taken and reduce damage done on target by x% for y turns."
         },
         "weaken":{
            "effect":"weaken",
            "effect_name":"Weaken",
            "duration_deduct":"after_attack",
            "effect_description":"Targets damage gets reduced damage done by x % for y turns."
         },
         "weaken_unpurify":{
            "effect":"weaken_unpurify",
            "effect_name":"Weaken",
            "duration_deduct":"after_attack",
            "effect_description":"Targets damage gets reduced damage done by x % for y turns."
         },
         "pet_weaken":{
            "effect":"pet_weaken",
            "effect_name":"Weaken",
            "duration_deduct":"after_attack",
            "effect_description":"Targets damage gets reduced damage done by x % for y turns."
         },
         "kekkai":{
            "effect":"kekkai",
            "effect_name":"Kekkai",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce x% of HP and CP when user attack with weapon for y turns."
         },
         "bloodlust":{
            "effect":"bloodlust",
            "effect_name":"Bloodlust",
            "duration_deduct":"after_attack",
            "effect_description":"Recovering x% HP of damage done when attacking user with weapon for y turns."
         },
         "numb":{
            "effect":"numb",
            "effect_name":"Numb",
            "duration_deduct":"after_attack",
            "effect_description":"Lower dodge rate of target by x % for y turns."
         },
         "pet_numb":{
            "effect":"pet_numb",
            "effect_name":"Numb",
            "duration_deduct":"after_attack",
            "effect_description":"Lower dodge rate of target by x % for y turns."
         },
         "silhouette":{
            "effect":"silhouette",
            "effect_name":"Silhouette",
            "duration_deduct":"after_attack",
            "effect_description":"Lower dodge rate of target by x % for y turns."
         },
         "capture":{
            "effect":"capture",
            "effect_name":"Capture",
            "duration_deduct":"after_attack",
            "effect_description":"Lower dodge rate of target by x % for y turns."
         },
         "restriction":{
            "effect":"restriction",
            "effect_name":"Restriction",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"The restricted target cannot perform any Ninjutsu for x amount of turns."
         },
         "pet_restriction":{
            "effect":"pet_restriction",
            "effect_name":"Restriction",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"The restricted target cannot perform any Ninjutsu for x amount of turns."
         },
         "meridian_seal":{
            "effect":"meridian_seal",
            "effect_name":"Meridian Seal",
            "duration_deduct":"after_attack",
            "add_in_array":true,
            "effect_description":"The restricted target cannot perform any Ninjutsu AND charge for x amount of turns."
         },
         "conduction":{
            "effect":"conduction",
            "effect_name":"Conduction",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce target\'s dodge rate for x%. Reduce target\'s CP for x% when target attacks for y turns."
         },
         "pet_conduction":{
            "effect":"pet_conduction",
            "effect_name":"Conduction",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce target\'s dodge rate for x%. Reduce target\'s CP for x% when target attacks for y turns."
         },
         "ecstasy":{
            "effect":"ecstasy",
            "effect_name":"Ecstasy",
            "duration_deduct":"after_attack",
            "effect_description":"The ecstasied target cannot perform any Ninjutsu for x amount of turns and Damage will be reduced for x%."
         },
         "pet_ecstasy":{
            "effect":"pet_ecstasy",
            "effect_name":"Ecstasy",
            "duration_deduct":"after_attack",
            "effect_description":"The ecstasied target cannot perform any Ninjutsu for x amount of turns and Damage will be reduced for x%."
         },
         "blaze":{
            "effect":"blaze",
            "effect_name":"Blaze",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "frostbite":{
            "effect":"frostbite",
            "effect_name":"Frostbite",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "covid":{
            "effect":"covid",
            "effect_name":"Covid",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "muddy":{
            "effect":"muddy",
            "effect_name":"Muddy",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s purify by % or a fixed number over time."
         },
         "pet_muddy":{
            "effect":"pet_muddy",
            "effect_name":"Muddy",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s purify by % or a fixed number over time."
         },
         "demonic_curse":{
            "effect":"demonic_curse",
            "effect_name":"Demonic Curse",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp by % or a fixed number over time."
         },
         "flaming":{
            "effect":"flaming",
            "effect_name":"Flaming",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp and cp by % or a fixed number over time."
         },
         "cosmic_flame":{
            "effect":"cosmic_flame",
            "effect_name":"Cosmic Flame",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp by % or a fixed number over time."
         },
         "burn":{
            "effect":"burn",
            "effect_name":"Burn",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp by % or a fixed number over time."
         },
         "burning":{
            "effect":"burning",
            "effect_name":"Burning",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp by % or a fixed number over time."
         },
         "burningX":{
            "effect":"burningX",
            "effect_name":"Burning",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp by % or a fixed number over time."
         },
         "fire_wall_burn":{
            "effect":"fire_wall_burn",
            "effect_name":"Burn",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp by % or a fixed number over time."
         },
         "hemorrhage":{
            "effect":"hemorrhage",
            "effect_name":"Hemorrhage",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce target\'s current hp by % or a fixed number over time when you crit."
         },
         "pet_burn":{
            "effect":"pet_burn",
            "effect_name":"Burn",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp by % or a fixed number over time."
         },
         "ultra_burning":{
            "effect":"ultra_burning",
            "effect_name":"Ultra Burning",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s current hp by 3% for each negative status effect they have, over a number of turns."
         },
         "reduce_hp":{
            "effect":"reduce_hp",
            "effect_name":"Reduce HP",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "reduceHP":{
            "effect":"reduceHP",
            "effect_name":"Reduce HP",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "pet_reduce_hp":{
            "effect":"pet_reduce_hp",
            "effect_name":"Reduce HP",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "reduce_hp_cp":{
            "effect":"reduce_hp_cp",
            "effect_name":"Reduce HP & CP",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp and cp by % or a fixed number over time."
         },
         "weapon_attack_penalty":{
            "effect":"weapon_attack_penalty",
            "effect_name":"Weapon Attack Penalty",
            "duration_deduct":"immediately",
            "effect_description":"Reduce HP and CP when attacking with weapon."
         },
         "prison":{
            "effect":"prison",
            "effect_name":"Prison",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Reduce target\'s maximum hp and cp by x% and stuns for y turns."
         },
         "pet_prison":{
            "effect":"pet_prison",
            "effect_name":"Prison",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Reduce target\'s maximum hp and cp by x% and stuns for y turns."
         },
         "poison":{
            "effect":"poison",
            "effect_name":"Poison",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "infection":{
            "effect":"infection",
            "effect_name":"Infection",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "oil":{
            "effect":"oil",
            "effect_name":"oil",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "pet_poison":{
            "effect":"pet_poison",
            "effect_name":"Poison",
            "duration_deduct":"immediately",
            "effect_description":"Reduce target\'s maximum hp by % or a fixed number over time."
         },
         "cp_cost":{
            "effect":"cp_cost",
            "effect_name":"+ CP Consumption",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "expose_defence":{
            "effect":"expose_defence",
            "effect_name":"Expose Defence",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "barrier":{
            "effect":"barrier",
            "effect_name":"Barrier",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":""
         },
         "blind":{
            "effect":"blind",
            "effect_name":"Blind",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "pet_blind":{
            "effect":"pet_blind",
            "effect_name":"Blind",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "dismantle":{
            "effect":"dismantle",
            "effect_name":"Dismantle",
            "duration_deduct":"after_attack",
            "effect_description":"Target cannot use weapon attack for x turns."
         },
         "pet_dismantle":{
            "effect":"pet_dismantle",
            "effect_name":"Dismantle",
            "duration_deduct":"after_attack",
            "effect_description":"Target cannot use weapon attack for x turns."
         },
         "frozen":{
            "effect":"frozen",
            "effect_name":"Frozen",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Like stun but targets damage taken is reduced by 80%."
         },
         "chill":{
            "effect":"chill",
            "effect_name":"Chill",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Inflict Bleeding by percentage amount and reduce enemy hp by percentage amount and frozen"
         },
         "pet_frozen":{
            "effect":"pet_frozen",
            "effect_name":"Frozen",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Like stun but targets damage taken is reduced by 80%."
         },
         "petrify":{
            "effect":"petrify",
            "effect_name":"Petrify",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Like stun but targets damage taken is reduced by 100%."
         },
         "pet_petrify":{
            "effect":"pet_petrify",
            "effect_name":"Petrify",
            "duration_deduct":"immediately",
            "add_in_array":true,
            "effect_description":"Like stun but targets damage taken is reduced by 100%."
         },
         "charge_disable":{
            "effect":"charge_disable",
            "effect_name":"Charge Disabled",
            "duration_deduct":"immediately",
            "effect_description":"User can not charge for x turns."
         },
         "pet_charge_disable":{
            "effect":"pet_charge_disable",
            "effect_name":"Charge Disabled",
            "duration_deduct":"immediately",
            "effect_description":"User can not charge for x turns."
         },
         "meridian_injury":{
            "effect":"meridian_injury",
            "effect_name":"Meridian Injury",
            "duration_deduct":"after_attack",
            "effect_description":"User can not get CP for x turns."
         },
         "slow":{
            "effect":"slow",
            "effect_name":"Reduce Agility",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce agility by x%."
         },
         "slow_oil":{
            "effect":"slow_oil",
            "effect_name":"Reduce Agility",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce agility by x%."
         },
         "pet_slow":{
            "effect":"pet_slow",
            "effect_name":"Reduce Agility",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce agility by x%."
         },
         "decrease_purify_active":{
            "effect":"decrease_purify_active",
            "effect_name":"Muddy",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce purify by x%."
         },
         "decrease_combustion_chance":{
            "effect":"decrease_combustion_chance",
            "effect_name":"Chilly",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce combustion chance by x%."
         },
         "decrease_critical_chance":{
            "effect":"decrease_critical_chance",
            "effect_name":"Decrease Critical Chance",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce critical chance by x%."
         },
         "distract":{
            "effect":"distract",
            "effect_name":"Distract",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce critical chance by x%."
         },
         "pet_distract":{
            "effect":"pet_distract",
            "effect_name":"Distract",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce critical chance by x%."
         },
         "decrease_reactive_chance":{
            "effect":"decrease_reactive_chance",
            "effect_name":"Decrease Reactive Chance",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce reactive chance by x%."
         },
         "weak_body":{
            "effect":"weak_body",
            "effect_name":"Weak Body",
            "duration_deduct":"after_attack",
            "effect_description":"Reduce reactive chance by x%."
         },
         "reduce_cp":{
            "effect":"reduce_cp",
            "effect_name":"CP Reduce",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "cp_burn":{
            "effect":"cp_burn",
            "effect_name":"CP Burn",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "reduceCP":{
            "effect":"reduceCP",
            "effect_name":"CP Reduce",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "wind_faint":{
            "effect":"wind_faint",
            "effect_name":"Wind Faint",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "water_faint":{
            "effect":"water_faint",
            "effect_name":"Water Faint",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "fire_faint":{
            "effect":"fire_faint",
            "effect_name":"Fire Faint",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "earth_faint":{
            "effect":"earth_faint",
            "effect_name":"Earth Faint",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "lightning_faint":{
            "effect":"lightning_faint",
            "effect_name":"Lightning Faint",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "parasite":{
            "effect":"parasite",
            "effect_name":"Parasite",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "meridian_cut_off":{
            "effect":"meridian_cut_off",
            "effect_name":"Meridian Cut-Off",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "pet_meridian_cut_off":{
            "effect":"pet_meridian_cut_off",
            "effect_name":"Meridian Cut-Off",
            "duration_deduct":"immediately",
            "effect_description":""
         },
         "disable_weapon_effect":{
            "effect":"disable_weapon_effect",
            "effect_name":"Disable Weapon Effect",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "snake_shadow":{
            "effect":"snake_shadow",
            "effect_name":"Snake Shadow",
            "duration_deduct":"after_attack",
            "effect_description":""
         },
         "isolate":{
            "effect":"isolate",
            "effect_name":"Isolate",
            "duration_deduct":"never",
            "effect_description":""
         },
         "clarify":{
            "effect":"clarify",
            "effect_name":"Clarify",
            "duration_deduct":"never",
            "effect_description":""
         },
         "botched":{
            "effect":"botched",
            "effect_name":"Botched",
            "duration_deduct":"never",
            "effect_description":""
         },
         "unwell":{
            "effect":"unwell",
            "effect_name":"Unwell",
            "duration_deduct":"never",
            "effect_description":""
         },
         "holdback":{
            "effect":"holdback",
            "effect_name":"Holdback",
            "duration_deduct":"never",
            "effect_description":""
         }
      };
      
      public static var dont_need_show_duration:Array = ["rampage","isolate","wider","clarify","botched","wellness","unwell","evade","reflect","holdback","ultra_bleeding"];
      
      public static var dont_need_to_show:Array = ["snake_shadow","meditation","suffocate","illuminated_chakra_mode","regeneration","regenHP","pet_regeneration","parasite","pet_parasite","restoration","pet_restoration","reduce_hp_cp","pet_reduce_hp_cp","prison","pet_prison","cosmic_flame","burn","flaming","demonic_curse","pet_burn","fire_wall_burn","reduce_hp","reduceHP","pet_reduce_hp","peace","pet_peace","cp_burn","reduce_cp","reduceCP","pet_reduce_cp","blaze","burningX","frostbite","covid"];
      
      public static var need_to_show_minus_duration:Array = ["weaken_unpurify","slug_sage","defer","fast_forward","counter_effect","emberstep_demonic","aqua_regia","preservation","confinement","disable_weapon_effect","disable_passive_talent","bleeding_protection","solar_might","meridian_seal","meridian_injury","concentration","kyubi_cloak","titan_mode","overload","boundless","poison_attacker","liquidation_armor","tolerance","transform","shukaku_blessing","negate","hanyaoni","attacker_bleeding","pet_attacker_bleeding","wolfram","internal_injury","cannot_reduced_cp","venom_spread","cp_shield_and_increase_purify","critical_buff_n_received_stun","decrease_critical_damage","decrease_charge","increase_charge_master","vigor","decrease_max_cp","decrease_max_hpcp","snake_mark","power_up","senjutsu_strengthen","slow_oil","sage_mode","hemorrhage","invincible","unyielding","self_love","bloodflame","fast","agility_up","pet_fast","theft","recoil_curse","blood_tax","domain_expansion","change_background","stealth"
      ,"decrease_critical_chance","weak_body","distract","pet_distract","expose_defence","reactive_force","increase_silhouette_chance","reduce_wind_cd","pet_reduce_wind_cd","attention","pet_attention","toad_attention","bleeding","pet_bleeding","slow","pet_slow","pet_stubborn_recover_cp","taijutsu_strengthen","extreme_mode","pet_frenzy","pet_mortal","inquisitor","strengthen","strengthen_special","pet_strengthen","damage_reduce_self","vulnerable","weaken","pet_weaken","energize","overwhelm","concentration","pet_concentration","toad_concentration","excitation","pet_excitation","energize","reflexes","flexible","pet_flexible","attacker_disorient","slow_attacker","cp_cost","weapon_attack_penalty","dark_curse","darkness","embrace","pet_darkness","pet_energize","disorient","disorient_2","pet_disorient","debuff_resist","pet_debuff_resist","ecstasy","pet_ecstasy","numb","pet_numb","protection","pet_protection","plus_extra_hp","conduction","pet_conduction","blind","pet_blind","cp_shield","pet_cp_shield"
      ,"dismantle","pet_dismantle","decrease_purify_active","decrease_combustion_chance","pet_decrease_purify_active","guard","pet_guard","rage","pet_rage","bloodfeed","pet_bloodfeed","bloodlust","pet_bloodlust","breakthrough","pet_breakthrough","damage_absorption","pet_damage_absorption","attacker_bleeding","pet_attacker_bleeding","fire_wall","pet_fire_wall","kekkai","pet_kekkai","serene_mind","pet_serene_mind","heavy_voltage","pet_heavy_voltage","plus_protection","pet_plus_protection","lava_shield","oet_lava_shield","lightning_armor","pet_lightning_armor","illuminated_chakra_mode","ocean_atmosphere","reduce_cp_consumption","unyielding_soul","damage_percent","defense_percent","accuracy_percent","dodge_percent","critical_percent","purify_percent"];
      
      public static var equipped_set_increase_dmg_effects:Array = ["senjutsu_strengthen","increase_damage_number","increase_damage_pct","damage_increase","power_up_by_hp"];
      
      public static var equipped_set_decrease_dmg_effects:Array = ["damage_reduce"];
      
      public static var inc_damage_buffs:Array = ["solar_might","kyubi_cloak","dodge_damage_bonus","tolerance","shukaku_blessing","rampage","extreme_mode","senjutsu_strengthen","sage_mode","invincible","unyielding","pet_frenzy","power_up","inquisitor","domain_expansion","strengthen","strengthen_special","pet_strengthen","stealth","rage","taijutsu_strengthen","pet_lightning_armor","lightning_armor","power_up_battle"];
      
      public static var dec_damage_buffs:Array = ["weaken_unpurify","holdback","infection","vulnerable","weaken","pet_weaken","ecstasy","pet_ecstasy","dark_curse","embrace"];
      
      public static var inc_enemy_damage_buffs:Array = ["rage"];
      
      public static var inc_enemy_damage_debuffs:Array = ["chill","bleeding","pet_bleeding","ultra_bleeding","vulnerable","expose_defence"];
      
      public static var dec_enemy_damage_debuffs:Array = ["preservation","petrify","frozen","chill","tolerance","wolfram","invincible","unyielding","self_love","bloodflame","protection","pet_protection","stealth","guard","pet_guard","plus_protection"];
      
      public static var lock_effects:* = ["sleep","pet_sleep","frozen","pet_frozen","chill","stun","locked","pet_stun","fear","pet_fear","prison","pet_prison","petrify","pet_petrify","chaos","pet_chaos","restriction","pet_restriction"];
      
      public static var allBuffsEffectNames:* = [];
      
      public static var allDebuffEffectNames:* = [];
      
      public static var buffEffectArray:* = ["HPRecover+HP","CPConsumeHP+HP","AbsorbHP+HP","AbsorbCP+CP","AbosrbSP+","RewindCooldown","DrainSP+","SP+","InstaRecoverHP+HP","InstaRecoverCP+CP","RecoverCP+CP","CP+","HP+","HP+HP","CP+CP","Charge+","ChargedCP","Regeneration","SlugSage","Rejuvenation","Catalytic","Peace","Heal+","Combustion","Purify","GenjutsuCooldown","Drain+HP","CPDrain+","HPDrain+","Restoration","Restore","Restore+","Parasite+","PeaceCP+","StubbornRecoverCP+","InstaRecoverCP+","ReduceCD","DisperseAll","Recovery","Convert+HP","RecoveredHP+HP","RecoveredCP+CP"];
      
      public static var debuffEffectArray:* = ["Ez","AddCooldown","InstantKill-HP","AbosrbHP-HP","DrainSP-","SP-","CP-","HP-","ReactiveForceHP-","+CPCost","Lock","Drain-HP","Drain-CP","Wind+CD","Fire+CD","Lightning+CD","Earth+CD","Water+CD","CPDrain-","HPDrain-","TaijutsuHP-","Parasite-","InstantReduceCP-","Reduce","CosmicFlame-HP","FlamingHP-","FlamingCP-","StealBuff","FastForward:-HP"];
      
      private static var timeouts:* = [];
      
      private static var overlayTimerActive:Boolean = false;
      
      private static var activeOverlayTextFields:Array = [];
      
      private static const MAX_OVERLAY_QUEUE:int = 80;
      
      private static const OVERLAY_FONT:String = "Franklin Gothic Demi";
      
      private static const OVERLAY_FONT_SIZE:int = 42;
      
      private static var OVERLAY_GLOW:GlowFilter = new GlowFilter(0,1,4,4,6,1);
      
      private static var OVERLAY_FORMAT_DEFAULT:TextFormat = new TextFormat(OVERLAY_FONT,OVERLAY_FONT_SIZE,16777215,true);
      
      private static var OVERLAY_FORMAT_BUFF:TextFormat = new TextFormat(OVERLAY_FONT,OVERLAY_FONT_SIZE,65280,true);
      
      private static var OVERLAY_FORMAT_DEBUFF:TextFormat = new TextFormat(OVERLAY_FONT,OVERLAY_FONT_SIZE,16711680,true);
      
      public function Effects()
      {
         super();
      }
      
      public static function init() : *
      {
         if(Effects.overlayTimerActive)
         {
            return;
         }
         Effects.overlayTimerActive = true;
         Effects.timeouts.push(setTimeout(Effects.buffOverlay,200,Effects.timeouts.length));
      }
      
      public static function buffOverlay(param1:int = 0) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         Effects.overlayTimerActive = false;
         if(Effects.buff_overlay.length > 0)
         {
            _loc2_ = Effects.buff_overlay[0];
            _loc3_ = _loc2_.mc;
            _loc4_ = int(Effects.buff_overlay.length);
            if(_loc3_ == null)
            {
               _loc3_ = Effects.createOverlayTextField(_loc2_);
               if(_loc2_.effectType == "Buff" || _loc2_.effectType == "Debuff")
               {
                  Effects.setOverlayTextColor(_loc3_,_loc2_.effectType);
               }
               else
               {
                  Effects.changeBuffTextColor(_loc3_);
               }
               _loc3_.cacheAsBitmap = true;
            }
            _loc5_ = BattleManager.getBattle();
            if(_loc5_ == null)
            {
               Effects.buff_overlay.shift();
               init();
               return;
            }
            _loc5_.addChild(_loc3_);
            Effects.activeOverlayTextFields.push(_loc3_);
            _loc6_ = _loc3_.y - 200;
            _loc3_.visible = _loc5_.showGUI ? true : false;
            TweenLite.to(_loc3_,1.5,{
               "y":_loc6_,
               "ease":Linear.easeNone,
               "onComplete":removeBuffFromScreen,
               "onCompleteParams":[_loc3_]
            });
            Effects.buff_overlay.shift();
         }
         if(Effects.timeouts.length > 0)
         {
            Effects.timeouts.shift();
         }
         init();
      }
      
      private static function createOverlayTextField(param1:Object) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.alpha = 1;
         _loc2_.mouseEnabled = false;
         _loc2_.selectable = false;
         _loc2_.embedFonts = false;
         _loc2_.autoSize = TextFieldAutoSize.CENTER;
         _loc2_.defaultTextFormat = Effects.OVERLAY_FORMAT_DEFAULT;
         _loc2_.text = param1.text;
         _loc2_.filters = [Effects.OVERLAY_GLOW];
         return _loc2_;
      }
      
      private static function queueOverlay(param1:*, param2:String, param3:String = "") : void
      {
         if(param1 == null || param2 == null || param2.length == 0)
         {
            return;
         }
         var _loc4_:String = Effects.getMcModel(param2);
         var _loc5_:String = param2;
         if((_loc4_ == "healing" || _loc4_ == "charging") && !isNaN(Number(Effects.getNumberFromText(param2))))
         {
            _loc5_ = Effects.getNumberFromText(param2);
         }
         if(Effects.buff_overlay.length >= MAX_OVERLAY_QUEUE)
         {
            Effects.buff_overlay.shift();
         }
         Effects.buff_overlay.push({
            "mc":null,
            "x":param1.x + 120,
            "y":param1.y + 300,
            "text":_loc5_,
            "effectType":param3
         });
      }
      
      private static function setOverlayTextColor(param1:*, param2:String) : void
      {
         if(param2 == "Buff")
         {
            param1.setTextFormat(Effects.OVERLAY_FORMAT_BUFF);
         }
         else if(param2 == "Debuff")
         {
            param1.setTextFormat(Effects.OVERLAY_FORMAT_DEBUFF);
         }
      }
      
      private static function createOverlayTextFormat(param1:uint) : TextFormat
      {
         return new TextFormat(OVERLAY_FONT,OVERLAY_FONT_SIZE,param1,true);
      }
      
      public static function removeBuffFromScreen(param1:*) : void
      {
         var _loc2_:* = BattleManager.getBattle();
         if(Boolean(_loc2_) && param1.parent == _loc2_)
         {
            TweenLite.killTweensOf(param1);
            _loc2_.removeChild(param1);
         }
         var _loc3_:int = Effects.activeOverlayTextFields.indexOf(param1);
         if(_loc3_ >= 0)
         {
            Effects.activeOverlayTextFields.splice(_loc3_,1);
         }
      }
      
      public static function showMcAndPlay(param1:*, param2:String, param3:String = "") : void
      {
         if(param1 == null || param2 == null || param2.length == 0)
         {
            return;
         }
         Effects.queueOverlay(param1,param2,param3);
      }
      
      public static function showEffectAdded(param1:String, param2:int, param3:Object) : void
      {
         var holderMC:*;
         var effectType:String;
         var effectName:String = null;
         var team:String = param1;
         var num:int = param2;
         var effects:Object = param3;
         var battle:* = BattleManager.getBattle();
         if(battle == null || effects == null)
         {
            return;
         }
         holderMC = battle.getObjectHolder(team,num);
         if(holderMC == null)
         {
            return;
         }
         if(effects.hasOwnProperty("effect_name") && effects.effect_name != null && String(effects.effect_name).length > 0)
         {
            effectName = String(effects.effect_name);
         }
         else
         {
            try
            {
               effectName = getEffectName(effects.effect);
            }
            catch(e:*)
            {
               effectName = String(effects.effect);
            }
         }
         if(effectName == null || effectName.length == 0)
         {
            return;
         }
         if(Boolean(effects.hasOwnProperty("show_added_duration") && effects.show_added_duration) && Boolean(effects.hasOwnProperty("duration")) && int(effects.duration) > 0)
         {
            effectName += " " + int(effects.duration);
         }
         effectType = effects.hasOwnProperty("type") ? String(effects.type) : "Buff";
         Effects.queueOverlay(holderMC,effectName,effectType);
      }
      
      public static function showEffectResisted(param1:String, param2:int, param3:String = "Resisted") : void
      {
         var _loc4_:* = BattleManager.getBattle().getObjectHolder(param1,param2);
         showMcAndPlay(_loc4_,param3);
      }
      
      public static function displayEffect(param1:Object, param2:Object) : void
      {
         var team:String;
         var num:int;
         var effectType:String;
         var battle:*;
         var holderMC:*;
         var effectName:String = null;
         var model:Object = param1;
         var effects:Object = param2;
         if(model == null || effects == null || model.effects_manager == null)
         {
            return;
         }
         team = model.effects_manager.user_team;
         num = int(model.effects_manager.user_number);
         if(effects.effect_name != null && String(effects.effect_name).length > 0)
         {
            effectName = String(effects.effect_name);
         }
         else
         {
            try
            {
               effectName = getEffectName(effects.effect);
            }
            catch(e:*)
            {
               effectName = String(effects.effect);
            }
         }
         if(effectName == null || effectName.length == 0)
         {
            return;
         }
         effectType = effects.hasOwnProperty("type") ? String(effects.type) : "";
         battle = BattleManager.getBattle();
         if(battle == null)
         {
            return;
         }
         holderMC = battle.getObjectHolder(team,num);
         if(holderMC == null)
         {
            return;
         }
         Effects.queueOverlay(holderMC,effectName,effectType);
      }
      
      public static function showEffectInfo(param1:String, param2:int, param3:String, param4:Boolean = true) : void
      {
         if(BattleVars.ATTACKER_TYPE == "PET" && param4 && param1.indexOf("_pet") == -1)
         {
            param1 += "_pet";
         }
         var _loc5_:* = BattleManager.getBattle();
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:* = _loc5_.getObjectHolder(param1,param2);
         showMcAndPlay(_loc6_,param3);
      }
      
      public static function destroy() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < Effects.timeouts.length)
         {
            clearTimeout(Effects.timeouts[_loc1_]);
            delete Effects.timeouts[_loc1_];
            _loc1_++;
         }
         Effects.timeouts = [];
         Effects.buff_overlay = [];
         Effects.allBuffsEffectNames = [];
         Effects.allDebuffEffectNames = [];
         Effects.overlayTimerActive = false;
         for each(_loc2_ in Effects.activeOverlayTextFields)
         {
            TweenLite.killTweensOf(_loc2_);
         }
         Effects.activeOverlayTextFields = [];
      }
      
      public static function getAllBuffsEffectNames() : Array
      {
         if(Effects.allBuffsEffectNames.length > 0)
         {
            return Effects.allBuffsEffectNames;
         }
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:Array = [];
         for each(_loc1_ in Effects.all_buffs)
         {
            _loc2_ = String(_loc1_.effect_name);
            while(_loc2_.indexOf(" ") >= 0)
            {
               _loc2_ = _loc2_.replace(" ","");
            }
            _loc3_.push(_loc2_);
            _loc3_.push(_loc2_ + "+");
         }
         Effects.allBuffsEffectNames = _loc3_;
         return _loc3_;
      }
      
      public static function getAllDebuffsEffectNames() : Array
      {
         if(Effects.allDebuffEffectNames.length > 0)
         {
            return Effects.allDebuffEffectNames;
         }
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:Array = [];
         for each(_loc1_ in Effects.all_debuffs)
         {
            _loc2_ = String(_loc1_.effect_name);
            while(_loc2_.indexOf(" ") >= 0)
            {
               _loc2_ = _loc2_.replace(" ","");
            }
            _loc3_.push(_loc2_);
            _loc3_.push(_loc2_ + "-");
         }
         Effects.allDebuffEffectNames = _loc3_;
         return _loc3_;
      }
      
      public static function changeBuffTextColor(param1:*) : *
      {
         var _loc2_:Array = Effects.getAllBuffsEffectNames();
         var _loc3_:Array = Effects.getAllDebuffsEffectNames();
         var _loc4_:TextFormat = new TextFormat();
         var _loc5_:String = param1.text.replace(/\s|!|\d/g,"");
         if(_loc2_.indexOf(_loc5_) >= 0 || Effects.buffEffectArray.indexOf(_loc5_) >= 0 || _loc2_.indexOf(_loc5_.split("+")[0]) >= 0 || _loc5_.indexOf("%turn") >= 0)
         {
            _loc4_ = Effects.createOverlayTextFormat(65280);
            param1.setTextFormat(_loc4_);
         }
         else if(_loc3_.indexOf(_loc5_) >= 0 || Effects.debuffEffectArray.indexOf(_loc5_) >= 0)
         {
            _loc4_ = Effects.createOverlayTextFormat(16711680);
            param1.setTextFormat(_loc4_);
         }
         else if(_loc5_ == "IlluminatedChakraMode")
         {
            _loc4_ = Effects.createOverlayTextFormat(255);
            param1.setTextFormat(_loc4_);
         }
      }
      
      public static function createEffectDisplay(param1:String, param2:int, param3:*, param4:Boolean = false, param5:Boolean = false) : *
      {
      }
      
      public static function getMcModel(param1:String) : String
      {
         var _loc2_:Array = [param1];
         if(param1.indexOf(" ") >= 0)
         {
            _loc2_ = param1.split(" ");
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(using_heal_mc_effects.indexOf(_loc2_[_loc3_]) >= 0)
            {
               return "healing";
            }
            _loc3_++;
         }
         return "damagedeal";
      }
      
      public static function getNumberFromText(param1:String) : String
      {
         var _loc2_:Array = [param1];
         if(param1.indexOf(" ") >= 0)
         {
            _loc2_ = param1.split(" ");
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(!isNaN(Number(_loc2_[_loc3_])))
            {
               return _loc2_[_loc3_];
            }
            _loc3_++;
         }
         return param1;
      }
      
      public static function getEffectName(param1:String) : String
      {
         return param1 in all_buffs ? all_buffs[param1].effect_name : all_debuffs[param1].effect_name;
      }
      
      public static function getBasicEffect(param1:String) : Object
      {
         return param1 in all_buffs ? all_buffs[param1] : all_debuffs[param1];
      }
      
      public static function getEffectDeductType(param1:String) : String
      {
         var effect:String = param1;
         var duration_deduct:* = "";
         try
         {
            duration_deduct = effect in all_buffs ? all_buffs[effect].duration_deduct : all_debuffs[effect].duration_deduct;
         }
         catch(e:*)
         {
            duration_deduct = "after_attack";
         }
         return duration_deduct;
      }
      
      public static function doesEffectDecreaseHealthAndCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["reduce_hp_cp","prison","pet_prison","flaming","suffocate"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectDecreaseHealth(param1:String) : Boolean
      {
         var _loc2_:Array = ["reduce_hp_cp","prison","pet_prison","cosmic_flame","flaming","suffocate","infection","blaze","burningX","frostbite","inquisitor","chill","covid","demonic_curse","burn","hemorrhage","burning","ultra_burning","fire_wall_burn","pet_burn","reduce_hp","reduceHP","pet_reduce_hp","poison","pet_poison","toxic_tooth"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectDecreaseCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["cp_burn","reduce_hp_cp","prison","pet_prison","flaming","suffocate","vemom_spread","reduce_cp","reduceCP"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectDecreaseSP(param1:String) : Boolean
      {
         var _loc2_:Array = ["vemom_spread"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectInstantReduceCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["oblivion","pet_oblivion","instant_reduce_cp","insta_reduce_max_cp","drain_cp_stun","drain_cp_injury","cp_drain","current_cp_drain","insta_drain_cp"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectIncreaseHealthAndCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["empty_for_now"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectIncreaseMaxHealth(param1:String) : Boolean
      {
         var _loc2_:Array = ["slug_sage","self_love","bloodflame","domain_expansion"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectIncreaseMaxCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["self_love","bloodflame","wider"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectIncreaseMaxSP(param1:String) : Boolean
      {
         var _loc2_:Array = ["belom ada"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectIncreaseMaxHealthAndCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["self_love","bloodflame","domain_expansion"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectDecreaseMaxCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["decrease_max_cp","botched"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectDecreaseMaxHP(param1:String) : Boolean
      {
         var _loc2_:Array = ["unwell"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectDecreaseMaxHPAndCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["decrease_max_hpcp"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectIncreaseHealth(param1:String) : Boolean
      {
         var _loc2_:Array = ["slug_sage","regeneration","regenHP","pet_regeneration","meditation","wellness"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectIncreaseCPForWholeTeam(param1:String) : Boolean
      {
         if(param1 == "peace" || param1 == "pet_peace")
         {
            return true;
         }
         return false;
      }
      
      public static function doesEffectIncreaseCP(param1:String) : Boolean
      {
         var _loc2_:Array = ["restoration","pet_restoration","peace","pet_peace"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectDrainHP(param1:String) : Boolean
      {
         var _loc2_:Array = ["parasite"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectLowerAgility(param1:String) : Boolean
      {
         var _loc2_:Array = ["slow","pet_slow","slow_oil"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectSkipTurns(param1:String) : Boolean
      {
         var _loc2_:Array = ["locked","stun","pet_stun","time_stop","fear","pet_fear","frozen","chill","pet_frozen","prison","pet_prison","petrify","pet_petrify","sleep","pet_sleep","toxic_tooth"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectInstantSkipTurns(param1:String) : Boolean
      {
         var _loc2_:Array = ["skip_turn"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function isResistingDebuff(param1:String) : Boolean
      {
         var _loc2_:Array = ["debuff_resist","pet_debuff_resist","bless","unyielding","time_stop"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectLowerReactiveForceChance(param1:String) : Boolean
      {
         var _loc2_:Array = ["disorient","pet_disorient","disorient_2","decrease_reactive_chance","weak_body"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectSkipTurnsForFirstTime(param1:String) : Boolean
      {
         var _loc2_:Array = ["locked","stun","pet_stun","time_stop","fear","tease","pet_fear","frozen","chill","pet_frozen","prison","pet_prison","petrify","pet_petrify","sleep","pet_sleep","pet_chaos","chaos","meridian_seal","pet_meridian_seal","barrier","restriction","pet_restriction","toxic_tooth"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectCannotPurified(param1:String) : Boolean
      {
         var _loc2_:Array = ["weaken_unpurify","fast_forward","snake_shadow","holdback","clarify","unwell","botched","blaze","burningX","covid","time_stop","hanyaoni","sage_mode","reverse_healing","defer","recoil_curse","blood_tax"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectCannotDisperse(param1:String) : Boolean
      {
         var _loc2_:Array = ["slug_sage","counter_effect","preservation","wider","reflect","evade","wellness","rampage","liquidation_armor","self_love","bloodflame","domain_expansion","overload","unyielding","sage_mode","boundless","vigor","isolate","change_background","defer","recoil_curse","blood_tax"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function doesEffectChangeBackground(param1:String) : Boolean
      {
         var _loc2_:Array = ["domain_expansion","change_background"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function copyEffect(param1:Object) : *
      {
         var _loc2_:Object = new Object();
         _loc2_.effect = param1.effect;
         _loc2_.effect_name = param1.effect_name;
         _loc2_.duration_deduct = param1.duration_deduct;
         _loc2_.add_in_array = "add_in_array" in param1 ? param1.add_in_array : false;
         _loc2_.amount_change = "amount_change" in param1 ? param1.amount_change : 0;
         _loc2_.duration = 0;
         _loc2_.chaos_duration = "chaos_duration" in param1 ? param1.chaos_duration : 0;
         _loc2_.calc_type = "percent";
         _loc2_.amount = 0;
         _loc2_.no_disperse = false;
         _loc2_.reduce_type = "MAX";
         _loc2_.amount_prc = 0;
         _loc2_.amount_hp = 0;
         _loc2_.amount_cp = 0;
         _loc2_.amount_protection = 0;
         _loc2_.amount_duration = 0;
         _loc2_.amount_change = 0;
         _loc2_.already_deducted = true;
         _loc2_.no_protect = false;
         return _loc2_;
      }
      
      public static function doesEffectGoesToActiveAfterPassive(param1:String) : Boolean
      {
         var _loc2_:Array = ["reduce_cd","stun_when_attack","sleep","pet_mortal","reduce_hp","transform","frozen","instant_kill","add_buff_duration","add_debuff_duration","infection","cp_recover_with_attack","drain_hp_with_attack","drain_cp_with_attack","hp_recover_with_attack","instant_hp_recover","instant_cp_recover","dismantle","heal","kira_kuin","bloodfeed","distract","pet_distract","burning","ultra_burning","dark_curse","demonic_curse","internal_injury","kill_instant_under","plague","disperse","locked","stun","chaos","blaze","burningX","freeze","frozen","parasite","absorb_cp","drain_cp","weaken","meridian_injury","restriction","blind","darkness","concentration","bleeding","ultra_bleeding","poison","burn","numb","petrify","frostbite","reduceCP","double_cp_consumption","rare_reduce_hp","rare_kill","hp_recover_with_attack","insta_reduce_max_cp","insta_reduce_max_hp","instant_reduce_hp","instant_reduce_cp","inflict_bleeding","inflict_burn","inflict_burning","inflict_weaken","inflict_restriction"
         ,"inflict_slow","slow","inflict_numb","inflict_blind","inflict_poison","inflict_petrify"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
      
      public static function convertPassiveToActiveEffect(param1:String) : String
      {
         var _loc2_:Array = [];
         _loc2_["cp_recover_with_attack"] = "instant_cp_recover";
         _loc2_["hp_recover_with_attack"] = "instant_hp_recover";
         _loc2_["kill_instant_under"] = "kill_instant_under";
         _loc2_["bloodfeed"] = "bloodfeed";
         _loc2_["disperse"] = "disperse";
         _loc2_["stun"] = "stun";
         _loc2_["chaos"] = "chaos";
         _loc2_["blaze"] = "blaze";
         _loc2_["freeze"] = "frozen";
         _loc2_["frozen"] = "frozen";
         _loc2_["parasite"] = "parasite";
         _loc2_["absorb_cp"] = "cp_drain";
         _loc2_["weaken"] = "weaken";
         _loc2_["sleep"] = "sleep";
         _loc2_["dismantle"] = "dismantle";
         _loc2_["drain_cp"] = "instant_reduce_cp";
         _loc2_["restriction"] = "restriction";
         _loc2_["blind"] = "blind";
         _loc2_["darkness"] = "darkness";
         _loc2_["concentration"] = "concentration";
         _loc2_["reduce_cd"] = "reduce_cd";
         _loc2_["bleeding"] = "bleeding";
         _loc2_["poison"] = "poison";
         _loc2_["burn"] = "burn";
         _loc2_["demonic_curse"] = "demonic_curse";
         _loc2_["dark_curse"] = "dark_curse";
         _loc2_["distract"] = "distract";
         _loc2_["numb"] = "numb";
         _loc2_["slow"] = "slow";
         _loc2_["petrify"] = "petrify";
         _loc2_["frostbite"] = "frostbite";
         _loc2_["plague"] = "plague";
         _loc2_["reduceCP"] = "reduceCP";
         _loc2_["reduce_hp"] = "reduce_hp";
         _loc2_["internal_injury"] = "internal_injury";
         _loc2_["double_cp_consumption"] = "double_cp_consumption";
         _loc2_["rare_reduce_hp"] = "instant_reduce_hp";
         _loc2_["rare_kill"] = "instant_reduce_hp";
         _loc2_["insta_reduce_max_hp"] = "instant_reduce_hp";
         _loc2_["insta_reduce_max_cp"] = "instant_reduce_cp";
         _loc2_["inflict_bleeding"] = "bleeding";
         _loc2_["inflict_burn"] = "burn";
         _loc2_["inflict_burning"] = "burning";
         _loc2_["burning"] = "burning";
         _loc2_["inflict_weaken"] = "weaken";
         _loc2_["inflict_restriction"] = "restriction";
         _loc2_["inflict_slow"] = "slow";
         _loc2_["inflict_numb"] = "numb";
         _loc2_["inflict_blind"] = "blind";
         _loc2_["inflict_poison"] = "poison";
         _loc2_["infection"] = "infection";
         _loc2_["inflict_petrify"] = "petrify";
         _loc2_["pet_mortal"] = "pet_mortal";
         _loc2_["stun_when_attack"] = "stun";
         if(_loc2_[param1] != null)
         {
            return _loc2_[param1];
         }
         return param1;
      }
   }
}

