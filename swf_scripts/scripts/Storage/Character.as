package Storage
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import id.ninjasage.GradientText;
   
   public class Character
   {
      
      public static var hunting_zone:int;
      
      public static var clan_enemy_building:*;
      
      public static var clan_id:int;
      
      public static var clan_name:String;
      
      public static var clan_banner:String;
      
      public static var clan_season_number:*;
      
      public static var crew_enemy_building:*;
      
      public static var crew_id:int;
      
      public static var crew_name:String;
      
      public static var crew_banner:String;
      
      public static var crew_season_number:*;
      
      public static var squad_id:int;
      
      public static var squad_name:String;
      
      public static var squad_season_number:*;
      
      public static var sw_season_number:*;
      
      public static var stage_grade_s_mission:int;
      
      public static var emblem_duration:int;
      
      public static var character_equipped_skills:String;
      
      public static var character_equipped_senjutsu_skills:String;
      
      public static var account_id:String;
      
      public static var account_type:int;
      
      public static var account_tokens:int;
      
      public static var account_username:String;
      
      public static var sessionkey:String;
      
      public static var char_id:*;
      
      public static var character_name:String;
      
      public static var character_gender:int;
      
      public static var character_xp:String;
      
      public static var character_lvl:String;
      
      public static var character_rank:String;
      
      public static var character_gold:String;
      
      public static var character_prestige:String;
      
      public static var character_tp:String;
      
      public static var character_pvp_point:int;
      
      public static var character_merit:int;
      
      public static var character_element_1:String;
      
      public static var character_element_2:String;
      
      public static var character_element_3:String;
      
      public static var character_class:String;
      
      public static var character_hp:*;
      
      public static var character_cp:*;
      
      public static var character_agility:*;
      
      public static var character_base_agility:*;
      
      public static var character_dodge:*;
      
      public static var character_critical:*;
      
      public static var character_purify:*;
      
      public static var character_accuracy:*;
      
      public static var character_weapons:String;
      
      public static var character_back_items:String;
      
      public static var character_accessories:String;
      
      public static var character_sets:String;
      
      public static var character_hairs:String;
      
      public static var character_skills:String;
      
      public static var character_talent_skills:String;
      
      public static var character_senjutsu_skills:String;
      
      public static var character_materials:String;
      
      public static var character_essentials:String;
      
      public static var character_consumables:String;
      
      public static var character_item_favorites:String;
      
      public static var character_animations:String;
      
      public static var character_weapon:String;
      
      public static var character_back_item:String;
      
      public static var character_accessory:String;
      
      public static var character_set:String;
      
      public static var character_hair:String;
      
      public static var character_skill_set:String;
      
      public static var character_skill_set_original:String;
      
      public static var character_color_hair:String;
      
      public static var character_color_skin:String;
      
      public static var character_face:String;
      
      public static var character_pet:String;
      
      public static var character_pets:String;
      
      public static var character_pet_id:int;
      
      public static var slot_weapons:int;
      
      public static var slot_back_items:int;
      
      public static var slot_accessories:int;
      
      public static var slot_sets:int;
      
      public static var slot_hairs:int;
      
      public static var atrrib_wind_:int;
      
      public static var atrrib_fire_:int;
      
      public static var atrrib_lightning_:int;
      
      public static var atrrib_water_:int;
      
      public static var atrrib_earth_:int;
      
      public static var atrrib_free_:int;
      
      public static var selected_char:int;
      
      public static var hide_event:Array;
      
      public static var character_senjutsu:String;
      
      public static var character_ss:int;
      
      public static var _:*;
      
      public static var __:*;
      
      public static var cdn:*;
      
      public static var build_num:* = "Public 0.61";
      
      public static var clan_timestamp:* = null;
      
      public static var clan_season:* = null;
      
      public static var clan_data:* = null;
      
      public static var clan_char_data:* = null;
      
      public static var clan_recruits:Array = [];
      
      public static var clan_recruit_names:Array = [];
      
      public static var clan_attack_id:int = 0;
      
      public static var crew_timestamp:* = null;
      
      public static var crew_season:* = null;
      
      public static var crew_data:* = null;
      
      public static var crew_char_data:* = null;
      
      public static var crew_recruits:Array = [];
      
      public static var crew_recruit_names:Array = [];
      
      public static var crew_attack_id:int = 0;
      
      public static var battle_logs:Array = [];
      
      public static var preview_wpn_id:String = "";
      
      public static var preview_acc_id:String = "";
      
      public static var preview_bis_id:String = "";
      
      public static var preview_set_id:String = "";
      
      public static var preview_hai_id:String = "";
      
      public static var play_items_animation:Boolean = true;
      
      public static var intel_class_animation:Boolean = true;
      
      public static var senjutsu_animation:Boolean = true;
      
      public static var lvl_60_exam_mode:String = "";
      
      public static var character_recruit_npc_amount:Array = [];
      
      public static var character_recruit_ids:Array = [];
      
      public static var temp_recruit_ids:Array = [];
      
      public static var mission_id:* = "";
      
      public static var background_id:* = null;
      
      public static var mission_level:* = 0;
      
      public static var is_hunting_house:* = false;
      
      public static var is_eudemon_garden:* = false;
      
      public static var is_hard_mode:* = false;
      
      public static var is_clan_war:* = false;
      
      public static var is_crew_war:* = false;
      
      public static var is_squad_war:* = false;
      
      public static var shadow_war_timestamp:* = null;
      
      public static var shadow_war_season:* = null;
      
      public static var squad_data:* = null;
      
      public static var shadow_war_battle_data:Object = null;
      
      public static var is_friend_berantem:* = false;
      
      public static var teammate_controllable:* = false;
      
      public static var is_jounin_stage_5_1:* = false;
      
      public static var is_jounin_stage_5_2:* = false;
      
      public static var is_jounin_stage_5_2_set:* = false;
      
      public static var is_jounin_stage_4:* = false;
      
      public static var stage_mode:* = "";
      
      public static var hunting_house_boss_id:* = "";
      
      public static var hunting_house_boss_num:* = -1;
      
      public static var eudemon_boss_id:* = "";
      
      public static var eudemon_boss_num:* = -1;
      
      public static var is_christmas_event:* = false;
      
      public static var is_christmas_special_event:* = false;
      
      public static var is_valentine_event:* = false;
      
      public static var is_valentine_special_event:* = false;
      
      public static var is_hanami_event:* = false;
      
      public static var is_ramadhan_event:* = false;
      
      public static var is_easter_event:* = false;
      
      public static var is_pirate_event:* = false;
      
      public static var is_pirate_special_event:* = false;
      
      public static var is_summer_event:* = false;
      
      public static var is_summer_special_event:* = false;
      
      public static var is_kojima_event:* = false;
      
      public static var is_fighter_event:* = false;
      
      public static var is_independence_event:* = false;
      
      public static var is_halloween_event:* = false;
      
      public static var is_halloween_special_event:* = false;
      
      public static var is_afterlife_event:* = false;
      
      public static var is_afterlife_special_event:* = false;
      
      public static var is_thanksgiving_event:* = false;
      
      public static var is_thanksgiving_special_event:* = false;
      
      public static var is_thousandyears_event:* = false;
      
      public static var is_cny_event:* = false;
      
      public static var is_anniversary_event:* = false;
      
      public static var is_anniversary_spenemy_event:* = false;
      
      public static var is_salus_event:* = false;
      
      public static var is_monster_hunter_event:* = false;
      
      public static var is_delivery_event:* = false;
      
      public static var is_poseidon_event:* = false;
      
      public static var is_confronting_death_event:* = false;
      
      public static var is_world_master_games_event:* = false;
      
      public static var is_yinyang_event:* = false;
      
      public static var is_kyunoki_event:* = false;
      
      public static var is_worldcup_event:* = false;
      
      public static var is_circus_event:* = false;
      
      public static var christmas_boss_id:* = "";
      
      public static var christmas_boss_num:* = -1;
      
      public static var battle_code:* = "";
      
      public static var battle_enemies:Array = [];
      
      public static var battle_enemy_pets:Array = [];
      
      public static var battle_characters:Array = [];
      
      public static var battle_character_pets:Array = [];
      
      public static var character_talent_1:String = "";
      
      public static var character_talent_2:String = "";
      
      public static var character_talent_3:String = "";
      
      public static var equipped_animations:Object = {};
      
      public static var char_ids:Array = [];
      
      public static var character_names:Array = [];
      
      public static var character_genders:Array = [];
      
      public static var character_xps:Array = [];
      
      public static var character_lvls:Array = [];
      
      public static var character_ranks:Array = [];
      
      public static var character_golds:Array = [];
      
      public static var character_tps:Array = [];
      
      public static var character_prestiges:Array = [];
      
      public static var character_element_1s:Array = [];
      
      public static var character_element_2s:Array = [];
      
      public static var character_element_3s:Array = [];
      
      public static var character_talent_1s:Array = [];
      
      public static var character_talent_2s:Array = [];
      
      public static var character_talent_3s:Array = [];
      
      public static var character_classes:Array = [];
      
      public static var welcome_status:int = 0;
      
      public static var _inBattle:Boolean = false;
      
      public static var name_color:uint = 15454004;
      
      public static var has_notification:Boolean = false;
      
      public static var is_stickman:Boolean = false;
      
      public static var show_special_skill:* = true;
      
      public static var features:* = [];
      
      public static var banners:Array = [];
      
      public static var rgb_data:Object = {};
      
      public static var skip_dialogue:Boolean = false;
      
      public static var is_new_village:Boolean = false;
      
      public static var encyclopedia_battle:Object = {
         "background":"mission_155",
         "controllable":false,
         "multiplier":1,
         "battle":false,
         "difficulty":"NORMAL"
      };
      
      public static var web:* = false;
      
      public static var menggokil:* = "eyJpdiI6Ijh5Ulo0VmZ3cisxbnRYdFNONTZPZlE9PSIsInZhbHVlIjoiTzFNWGpDN24yZ1VKQXRqTGJad3BiY1Q1YUVWUDE2c2tNbnZ6QkpVS1laND0iLCJtYWMiOiI0NGYzOTdkMmQ5MDFkMzE1ZWIyZjMyYjU1NjI4Mjk3MzU1NmYwMjlhODUyMzU1Mjc1ZWRmNzE5NGFiNTBiMzc3IiwidGFnIjoiIn0";
      
      public static var event_data:Object = {};
      
      public static var event_current_page:int = 1;
      
      public static var event_current_tab:String = "seasonal";
      
      public static var storage_delete:Boolean = false;
      
      private static const rox:int = Math.round(Math.random() * 2147483647);
      
      public var main:*;
      
      public function Character(param1:*)
      {
         super();
      }
      
      public static function fillRewards(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_].replace("%s",Character.character_gender));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getSquadName(param1:int) : String
      {
         var _loc2_:Array = ["assault","ambush","medic","kage","hq"];
         return param1 >= 0 && param1 < _loc2_.length ? _loc2_[param1] : "No Squad";
      }
      
      public static function getSquadId(param1:String) : int
      {
         var _loc2_:Object = {
            "assault":0,
            "ambush":1,
            "medic":2,
            "kage":3,
            "hq":4
         };
         return _loc2_.hasOwnProperty(param1) ? int(_loc2_[param1]) : -1;
      }
      
      public static function getSquadFullName(param1:int) : String
      {
         var _loc2_:Array = ["Assault Squad","Ambush Squad","Medic Squad","Kage Squad","HQ Squad"];
         return param1 >= 0 && param1 < _loc2_.length ? _loc2_[param1] : "No Squad";
      }
      
      public static function getLeagueFullName(param1:int) : String
      {
         var _loc2_:Array = ["Bronze","Silver","Gold","Platinum","Diamond","Master","Grand Master","Sage"];
         return param1 >= 0 && param1 < _loc2_.length ? _loc2_[param1] : "No League";
      }
      
      public static function addRewards(param1:*) : *
      {
         var _loc3_:String = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = [];
         var _loc4_:int = 1;
         if(!(param1 is Array))
         {
            param1 = param1.split(",");
         }
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = param1[_loc5_].split("_");
            _loc3_ = param1[_loc5_].replace("%s",Character.character_gender);
            _loc4_ = param1[_loc5_].indexOf(":") >= 0 ? int(param1[_loc5_].split(":")[1]) : 1;
            if(_loc2_[0] == "wpn")
            {
               Character.addWeapon(_loc3_);
            }
            else if(_loc2_[0] == "back")
            {
               Character.addBack(_loc3_);
            }
            else if(_loc2_[0] == "accessory")
            {
               Character.addAccessory(_loc3_);
            }
            else if(_loc2_[0] == "set")
            {
               Character.addSet(_loc3_);
            }
            else if(_loc2_[0] == "hair")
            {
               Character.addHair(_loc3_);
            }
            else if(_loc2_[0] == "material")
            {
               Character.addMaterials(_loc3_,_loc4_);
            }
            else if(_loc2_[0] == "item")
            {
               Character.addConsumables(_loc3_,_loc4_);
            }
            else if(_loc2_[0] == "essential")
            {
               Character.addEssentials(_loc3_,_loc4_);
            }
            else if(_loc2_[0] == "skill")
            {
               Character.updateSkills(_loc3_);
            }
            else if(_loc2_[0] == "token" || _loc2_[0] == "tokens")
            {
               Character.account_tokens += Number(_loc2_[1]);
            }
            else if(_loc2_[0] == "gold" || _loc2_[0] == "golds")
            {
               Character.character_gold = String(Number(Number(Character.character_gold) + Number(_loc2_[1])));
            }
            else if(_loc2_[0] == "tp" || _loc2_[0] == "tps")
            {
               Character.character_tp = String(Number(Number(Character.character_tp) + Number(_loc2_[1])));
            }
            else if(_loc2_[0] == "ss")
            {
               Character.character_ss = int(Number(Number(Character.character_ss) + Number(_loc2_[1])));
            }
            else if(_loc2_[0] == "xp" || _loc2_[0] == "exp")
            {
               Character.character_xp = String(Number(Number(Character.character_xp) + Number(_loc2_[1])));
            }
            else if(_loc2_[0] == "prestige")
            {
               Character.character_prestige = String(Number(Number(Character.character_prestige) + Number(_loc2_[1])));
            }
            else if(_loc2_[0] == "merit")
            {
               Character.character_merit += Number(_loc2_[1]);
            }
            _loc5_++;
         }
      }
      
      public static function isAttributesExcedingLevel() : Boolean
      {
         var _loc1_:Array = [Character.atrrib_earth,Character.atrrib_fire,Character.atrrib_free,Character.atrrib_lightning,Character.atrrib_water,Character.atrrib_wind];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] > int(Character.character_lvl))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public static function getMaterialAmount(param1:*) : *
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:String = Character.character_materials;
         if(!_loc2_ || _loc2_ == "")
         {
            return 0;
         }
         var _loc3_:Array = _loc2_.indexOf(",") >= 0 ? _loc2_.split(",") : [_loc2_];
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.split(":");
            if(_loc5_[0] == param1)
            {
               return _loc5_[1];
            }
         }
         return 0;
      }
      
      public static function getEssentialAmount(param1:String) : *
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:String = Character.character_essentials;
         if(!_loc2_ || _loc2_ == "")
         {
            return 0;
         }
         var _loc3_:Array = _loc2_.indexOf(",") >= 0 ? _loc2_.split(",") : [_loc2_];
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.split(":");
            if(_loc5_[0] == param1)
            {
               return _loc5_[1];
            }
         }
         return 0;
      }
      
      public static function getConsumableAmount(param1:String) : *
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:String = Character.character_consumables;
         if(!_loc2_ || _loc2_ == "")
         {
            return 0;
         }
         var _loc3_:Array = _loc2_.indexOf(",") >= 0 ? _loc2_.split(",") : [_loc2_];
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.split(":");
            if(_loc5_[0] == param1)
            {
               return _loc5_[1];
            }
         }
         return 0;
      }
      
      public static function hasSkill(param1:String) : int
      {
         var _loc2_:Array = [];
         if(Character.character_skills != "")
         {
            if(Character.character_skills.indexOf(",") >= 0)
            {
               _loc2_ = Character.character_skills.split(",");
            }
            else
            {
               _loc2_ = [Character.character_skills];
            }
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc4_])
            {
               _loc3_ = 1;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function isItemOwned(param1:*) : Boolean
      {
         if(checkIfItemExists(character_skills,param1))
         {
            return true;
         }
         if(checkIfItemExists(character_hairs,param1))
         {
            return true;
         }
         if(character_materials.indexOf(param1 + ":") >= 0)
         {
            return true;
         }
         if(character_essentials.indexOf(param1 + ":") >= 0)
         {
            return true;
         }
         if(character_sets.indexOf(param1 + ":") >= 0)
         {
            return true;
         }
         if(character_accessories.indexOf(param1 + ":") >= 0)
         {
            return true;
         }
         if(character_back_items.indexOf(param1 + ":") >= 0)
         {
            return true;
         }
         if(character_weapons.indexOf(param1 + ":") >= 0)
         {
            return true;
         }
         if(character_animations.indexOf(param1) >= 0)
         {
            return true;
         }
         if(character_pets.indexOf(param1) >= 0)
         {
            return true;
         }
         return false;
      }
      
      public static function checkIfItemExists(param1:*, param2:*) : Boolean
      {
         var _loc3_:Array = [];
         if(param1 != "")
         {
            if(param1.indexOf(",") >= 0)
            {
               _loc3_ = param1.split(",");
            }
            else
            {
               _loc3_ = [param1];
            }
         }
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public static function getSkillAttributes(param1:*) : int
      {
         switch(param1)
         {
            case "1":
               return atrrib_wind;
            case "2":
               return atrrib_fire;
            case "3":
               return atrrib_lightning;
            case "4":
               return atrrib_earth;
            case "5":
               return atrrib_water;
            default:
               return 0;
         }
      }
      
      public static function getEquippedSkillsAsArray(param1:* = null) : Array
      {
         var _loc2_:* = character_equipped_skills;
         if(param1 != null)
         {
            _loc2_ = param1;
         }
         if(_loc2_ != "")
         {
            if(_loc2_.indexOf(",") >= 0)
            {
               return _loc2_.split(",");
            }
            return [_loc2_];
         }
         return [];
      }
      
      public static function updateSkills(param1:String, param2:Boolean = true) : *
      {
         var _loc3_:Array = character_skills.split(",");
         var _loc4_:Boolean = false;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] == param1)
            {
               if(!param2)
               {
                  character_skills = character_skills.replace(param1 + ",","");
               }
               _loc4_ = true;
               break;
            }
            _loc5_++;
         }
         if(!_loc4_ && param2)
         {
            character_skills = param1 + "," + character_skills;
         }
      }
      
      public static function removeWeapon(param1:String, param2:int = 1) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(character_weapons.indexOf(param1 + ":") >= 0)
         {
            _loc3_ = character_weapons.split(",");
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc5_].split(":");
               if(_loc4_[0] == param1)
               {
                  _loc4_[1] -= param2;
               }
               if(_loc4_[1] > 0)
               {
                  _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
               }
               else
               {
                  _loc3_.splice(_loc5_,1);
               }
               _loc5_++;
            }
            character_weapons = _loc3_.join(",");
         }
      }
      
      public static function removeSet(param1:String, param2:int = 1) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(character_sets.indexOf(param1 + ":") >= 0)
         {
            _loc3_ = character_sets.split(",");
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc5_].split(":");
               if(_loc4_[0] == param1)
               {
                  _loc4_[1] -= param2;
               }
               if(_loc4_[1] > 0)
               {
                  _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
               }
               else
               {
                  _loc3_.splice(_loc5_,1);
               }
               _loc5_++;
            }
            character_sets = _loc3_.join(",");
         }
      }
      
      public static function removeAccesory(param1:String, param2:int = 1) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(character_accessories.indexOf(param1 + ":") >= 0)
         {
            _loc3_ = character_accessories.split(",");
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc5_].split(":");
               if(_loc4_[0] == param1)
               {
                  _loc4_[1] -= param2;
               }
               if(_loc4_[1] > 0)
               {
                  _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
               }
               else
               {
                  _loc3_.splice(_loc5_,1);
               }
               _loc5_++;
            }
            character_accessories = _loc3_.join(",");
         }
      }
      
      public static function removeHair(param1:String) : *
      {
         var _loc2_:Array = null;
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         if(character_hairs.indexOf(param1) >= 0)
         {
            _loc2_ = character_hairs.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_];
               if(_loc3_ == param1)
               {
                  _loc2_.splice(_loc4_,1);
               }
               _loc4_++;
            }
            character_hairs = _loc2_.join(",");
         }
      }
      
      public static function removeBackItem(param1:String, param2:int = 1) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(character_back_items.indexOf(param1 + ":") >= 0)
         {
            _loc3_ = character_back_items.split(",");
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc5_].split(":");
               if(_loc4_[0] == param1)
               {
                  _loc4_[1] -= param2;
               }
               if(_loc4_[1] > 0)
               {
                  _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
               }
               else
               {
                  _loc3_.splice(_loc5_,1);
               }
               _loc5_++;
            }
            character_back_items = _loc3_.join(",");
         }
      }
      
      public static function addWeapon(param1:String) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         if(character_weapons.indexOf(param1 + ":") >= 0)
         {
            _loc2_ = character_weapons.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_].split(":");
               if(_loc3_[0] == param1)
               {
                  ++_loc3_[1];
               }
               _loc2_[_loc4_] = _loc3_[0] + ":" + _loc3_[1];
               _loc4_++;
            }
            character_weapons = _loc2_.join(",");
         }
         else
         {
            character_weapons = param1 + ":1," + character_weapons;
         }
      }
      
      public static function addMaterials(param1:String, param2:int = 1) : *
      {
         var _loc6_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(param1.indexOf(":") >= 0)
         {
            _loc6_ = param1.split(":");
            param1 = _loc6_[0];
            param2 = int(_loc6_[1]);
            _loc6_ = null;
         }
         if(character_materials != "")
         {
            if(character_materials.indexOf(param1 + ":") >= 0)
            {
               _loc3_ = character_materials.split(",");
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc5_].split(":");
                  if(_loc4_[0] == param1)
                  {
                     _loc4_[1] = int(_loc4_[1]) + int(param2);
                  }
                  _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
                  _loc5_++;
               }
               character_materials = _loc3_.join(",");
            }
            else
            {
               character_materials = param1 + ":" + param2 + "," + character_materials;
            }
         }
         else
         {
            character_materials = param1 + ":" + param2;
         }
      }
      
      public static function addEssentials(param1:String, param2:int = 1) : *
      {
         var _loc6_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(param1.indexOf(":") >= 0)
         {
            _loc6_ = param1.split(":");
            param1 = _loc6_[0];
            param2 = int(_loc6_[1]);
            _loc6_ = null;
         }
         if(character_essentials != "")
         {
            if(character_essentials.indexOf(param1 + ":") >= 0)
            {
               _loc3_ = character_essentials.split(",");
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc5_].split(":");
                  if(_loc4_[0] == param1)
                  {
                     _loc4_[1] = int(_loc4_[1]) + int(param2);
                  }
                  _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
                  _loc5_++;
               }
               character_essentials = _loc3_.join(",");
            }
            else
            {
               character_essentials = param1 + ":" + param2 + "," + character_essentials;
            }
         }
         else
         {
            character_essentials = param1 + ":" + param2;
         }
      }
      
      public static function addConsumables(param1:String, param2:int = 1) : *
      {
         var _loc6_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(param1.indexOf(":") >= 0)
         {
            _loc6_ = param1.split(":");
            param1 = _loc6_[0];
            param2 = int(_loc6_[1]);
            _loc6_ = null;
         }
         if(character_consumables != "")
         {
            if(character_consumables.indexOf(param1 + ":") >= 0)
            {
               _loc3_ = character_consumables.split(",");
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc5_].split(":");
                  if(_loc4_[0] == param1)
                  {
                     _loc4_[1] = int(_loc4_[1]) + int(param2);
                  }
                  _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
                  _loc5_++;
               }
               character_consumables = _loc3_.join(",");
            }
            else
            {
               character_consumables = param1 + ":" + param2 + "," + character_consumables;
            }
         }
         else
         {
            character_consumables = param1 + ":" + param2;
         }
      }
      
      public static function removeMaterials(param1:String, param2:int = 1) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(character_materials != "")
         {
            if(character_materials.indexOf(param1 + ":") >= 0)
            {
               _loc3_ = character_materials.split(",");
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc5_].split(":");
                  if(_loc4_[0] == param1)
                  {
                     _loc4_[1] -= param2;
                  }
                  if(_loc4_[1] > 0)
                  {
                     _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
                  }
                  else
                  {
                     _loc3_.splice(_loc5_,1);
                  }
                  _loc5_++;
               }
               character_materials = _loc3_.join(",");
            }
         }
      }
      
      public static function replaceMaterials(param1:String, param2:int = 1) : *
      {
         var _loc6_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(param1.indexOf(":") >= 0)
         {
            _loc6_ = param1.split(":");
            param1 = _loc6_[0];
            param2 = int(_loc6_[1]);
            _loc6_ = null;
         }
         if(character_materials != "")
         {
            if(character_materials.indexOf(param1 + ":") >= 0)
            {
               _loc3_ = character_materials.split(",");
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc5_].split(":");
                  if(_loc4_[0] == param1)
                  {
                     _loc4_[1] = int(param2);
                  }
                  _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
                  _loc5_++;
               }
               character_materials = _loc3_.join(",");
            }
            else
            {
               character_materials = param1 + ":" + param2 + "," + character_materials;
            }
         }
         else
         {
            character_materials = param1 + ":" + param2;
         }
      }
      
      public static function getMaterialsAsArray() : Array
      {
         if(character_materials != "")
         {
            if(character_materials.indexOf(",") >= 0)
            {
               return character_materials.split(",");
            }
            return [character_materials];
         }
         return [];
      }
      
      public static function getEssentialsAsArray() : Array
      {
         if(character_essentials != "")
         {
            if(character_essentials.indexOf(",") >= 0)
            {
               return character_essentials.split(",");
            }
            return [character_essentials];
         }
         return [];
      }
      
      public static function removeEssentials(param1:String, param2:int = 1) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(character_essentials != "")
         {
            if(character_essentials.indexOf(param1 + ":") >= 0)
            {
               _loc3_ = character_essentials.split(",");
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc5_].split(":");
                  if(_loc4_[0] == param1)
                  {
                     _loc4_[1] -= param2;
                  }
                  if(_loc4_[1] > 0)
                  {
                     _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
                  }
                  else
                  {
                     _loc3_.splice(_loc5_,1);
                  }
                  _loc5_++;
               }
               character_essentials = _loc3_.join(",");
            }
         }
      }
      
      public static function removeConsumables(param1:String, param2:int = 1) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(character_consumables != "")
         {
            if(character_consumables.indexOf(param1 + ":") >= 0)
            {
               _loc3_ = character_consumables.split(",");
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc5_].split(":");
                  if(_loc4_[0] == param1)
                  {
                     _loc4_[1] -= param2;
                  }
                  if(_loc4_[1] > 0)
                  {
                     _loc3_[_loc5_] = _loc4_[0] + ":" + _loc4_[1];
                  }
                  else
                  {
                     _loc3_.splice(_loc5_,1);
                  }
                  _loc5_++;
               }
               character_consumables = _loc3_.join(",");
            }
         }
      }
      
      public static function addSet(param1:String) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         if(character_sets.indexOf(param1 + ":") >= 0)
         {
            _loc2_ = character_sets.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_].split(":");
               if(_loc3_[0] == param1)
               {
                  ++_loc3_[1];
               }
               _loc2_[_loc4_] = _loc3_[0] + ":" + _loc3_[1];
               _loc4_++;
            }
            character_sets = _loc2_.join(",");
         }
         else
         {
            character_sets = param1 + ":1," + character_sets;
         }
      }
      
      public static function addHair(param1:String) : *
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:Boolean = false;
         var _loc5_:* = undefined;
         if(character_hairs.indexOf(",") >= 0)
         {
            _loc2_ = character_hairs.split(",");
            _loc4_ = true;
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc5_];
               if(_loc3_ == param1)
               {
                  _loc4_ = false;
                  break;
               }
               _loc5_++;
            }
            if(_loc4_)
            {
               character_hairs = param1 + "," + character_hairs;
            }
         }
         else
         {
            character_hairs = param1 + "," + character_hairs;
         }
      }
      
      public static function addBack(param1:String) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         if(character_back_items.indexOf(param1 + ":") >= 0)
         {
            _loc2_ = character_back_items.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_].split(":");
               if(_loc3_[0] == param1)
               {
                  ++_loc3_[1];
               }
               _loc2_[_loc4_] = _loc3_[0] + ":" + _loc3_[1];
               _loc4_++;
            }
            character_back_items = _loc2_.join(",");
         }
         else
         {
            character_back_items = param1 + ":1," + character_back_items;
         }
      }
      
      public static function addAccessory(param1:String) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         if(character_accessories.indexOf(param1 + ":") >= 0)
         {
            _loc2_ = character_accessories.split(",");
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_].split(":");
               if(_loc3_[0] == param1)
               {
                  ++_loc3_[1];
               }
               _loc2_[_loc4_] = _loc3_[0] + ":" + _loc3_[1];
               _loc4_++;
            }
            character_accessories = _loc2_.join(",");
         }
         else
         {
            character_accessories = param1 + ":1," + character_accessories;
         }
      }
      
      public static function recolor(param1:TextField, param2:* = null) : *
      {
         var _loc3_:* = new TextFormat();
         _loc3_.color = param2 == null ? Character.name_color : param2;
         param1.setTextFormat(_loc3_);
      }
      
      public static function colorifyText(param1:*, param2:String, param3:* = null) : String
      {
         if(param3 != null)
         {
            GradientText.remove(param3);
         }
         var _loc4_:* = rgb_data[param1];
         if(_loc4_ is Array && (_loc4_.length == 0 || _loc4_.length > 1) && param3 != null)
         {
            param3.text = param2;
            GradientText.apply(param3,param1);
            return param2;
         }
         _loc4_ = _loc4_ is Array && _loc4_.length == 1 ? _loc4_[0] : _loc4_;
         return "<font color=\"" + _loc4_ + "\">" + param2 + "</font>";
      }
      
      public static function resetBattleInfo(param1:* = null) : *
      {
         Character.is_clan_war = false;
         Character.is_squad_war = false;
         Character.is_hunting_house = false;
         Character.is_crew_war = false;
         Character.clan_id = 0;
         Character.clan_name = null;
         Character.clan_banner = null;
         Character.clan_season_number;
         Character.crew_id = 0;
         Character.crew_name = null;
         Character.crew_banner = null;
         Character.crew_season_number;
         Character.sw_season_number;
         Character.is_friend_berantem = false;
         Character.teammate_controllable = false;
         Character.is_jounin_stage_5_1 = false;
         Character.is_jounin_stage_5_2 = false;
         Character.is_jounin_stage_5_2_set = false;
         Character.is_jounin_stage_4 = false;
         Character.stage_mode = "";
         Character.hunting_house_boss_id = "";
         Character.hunting_house_boss_num = -1;
         Character.is_christmas_event = false;
         Character.is_christmas_special_event = false;
         Character.is_valentine_event = false;
         Character.is_valentine_special_event = false;
         Character.is_hanami_event = false;
         Character.is_ramadhan_event = false;
         Character.is_easter_event = false;
         Character.is_pirate_event = false;
         Character.is_pirate_special_event = false;
         Character.is_summer_event = false;
         Character.is_summer_special_event = false;
         Character.is_kojima_event = false;
         Character.is_fighter_event = false;
         Character.is_independence_event = false;
         Character.is_halloween_event = false;
         Character.is_halloween_special_event = false;
         Character.is_afterlife_event = false;
         Character.is_afterlife_special_event = false;
         Character.is_thanksgiving_event = false;
         Character.is_thanksgiving_special_event = false;
         Character.is_thousandyears_event = false;
         Character.is_cny_event = false;
         Character.is_anniversary_event = false;
         Character.is_anniversary_spenemy_event = false;
         Character.is_salus_event = false;
         Character.is_monster_hunter_event = false;
         Character.is_delivery_event = false;
         Character.is_poseidon_event = false;
         Character.is_world_master_games_event = false;
         Character.is_yinyang_event = false;
         Character.is_kyunoki_event = false;
         Character.is_circus_event = false;
         Character.is_worldcup_event = false;
         Character.is_eudemon_garden = false;
         Character.hunting_zone = 0;
         Character.is_confronting_death_event = false;
         Character.christmas_boss_id = "";
         Character.christmas_boss_num = -1;
         Character.battle_code = "";
         Character.show_special_skill = true;
         Character.temp_recruit_ids = [];
         if(param1)
         {
            param1.is_jounin_exam_stage2 = false;
            param1.is_jounin_exam_stage3 = false;
            param1.is_jounin_exam_stage4 = false;
            param1.is_jounin_exam_stage5 = false;
            param1.is_special_jounin_exam_s1c2 = false;
            param1.is_special_jounin_exam_s2c2 = false;
            param1.is_special_jounin_exam_s3c2 = false;
            param1.is_special_jounin_exam_s4c2 = false;
            param1.is_special_jounin_exam_s5c2 = false;
            param1.is_special_jounin_exam_s6c1 = false;
            param1.is_special_jounin_exam_s6c2 = false;
            param1.is_special_jounin_exam_s6c3 = false;
            param1.is_ninja_tutor_exam_s1c2 = false;
            param1.is_ninja_tutor_exam_s2c2 = false;
            param1.is_ninja_tutor_exam_s3c2 = false;
            param1.is_ninja_tutor_exam_s4c2 = false;
            param1.is_ninja_tutor_exam_s5c2 = false;
            param1.is_ninja_tutor_exam_s6c1 = false;
            param1.is_ninja_tutor_exam_s6c2 = false;
            param1.is_exam_stage2 = false;
            param1.is_exam_stage3 = false;
            param1.is_exam_stage4 = false;
            param1.is_exam_stage5 = false;
            param1.is_grade_s_stage_4 = false;
            param1.is_grade_s_stage_5 = false;
            param1.exam_enemy = null;
            param1.stage3_battle = 0;
            param1.remainingStatus = [];
         }
      }
      
      public static function get atrrib_wind() : *
      {
         return Character.atrrib_wind_ ^ rox;
      }
      
      public static function set atrrib_wind(param1:*) : *
      {
         Character.atrrib_wind_ = param1 ^ rox;
      }
      
      public static function get atrrib_fire() : *
      {
         return Character.atrrib_fire_ ^ rox;
      }
      
      public static function set atrrib_fire(param1:*) : *
      {
         Character.atrrib_fire_ = param1 ^ rox;
      }
      
      public static function get atrrib_earth() : *
      {
         return Character.atrrib_earth_ ^ rox;
      }
      
      public static function set atrrib_earth(param1:*) : *
      {
         Character.atrrib_earth_ = param1 ^ rox;
      }
      
      public static function get atrrib_water() : *
      {
         return Character.atrrib_water_ ^ rox;
      }
      
      public static function set atrrib_water(param1:*) : *
      {
         Character.atrrib_water_ = param1 ^ rox;
      }
      
      public static function get atrrib_lightning() : *
      {
         return Character.atrrib_lightning_ ^ rox;
      }
      
      public static function set atrrib_lightning(param1:*) : *
      {
         Character.atrrib_lightning_ = param1 ^ rox;
      }
      
      public static function get atrrib_free() : *
      {
         return Character.atrrib_free_ ^ rox;
      }
      
      public static function set atrrib_free(param1:*) : *
      {
         Character.atrrib_free_ = param1 ^ rox;
      }
   }
}

