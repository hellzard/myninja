package Managers
{
   import Combat.BattleManager;
   import Combat.CharacterManager;
   import Combat.SetBonusCalculator;
   import Storage.AccessoryBuffs;
   import Storage.BackItemBuffs;
   import Storage.Character;
   import Storage.SenjutsuSkillLevel;
   import Storage.TalentSkillLevel;
   import Storage.WeaponBuffs;
   
   public class StatManager
   {
      
      public static var temp_talent_skills:String = null;
      
      public static var temp_senjutsu_skills:String = null;
      
      private static var calculating_data_hp:Boolean = false;
      
      private static var calculating_data_cp:Boolean = false;
      
      private static var _level:int = 0;
      
      private static var _earth:int = 0;
      
      private static var _water:int = 0;
      
      private static var _wind:int = 0;
      
      private static var _lightning:int = 0;
      
      private static var _weaponId:String = "";
      
      private static var _backItemId:String = "";
      
      private static var _accessoryId:String = "";
      
      private static var _clothingId:String = "";
      
      private static var _hairId:String = "";
      
      private static var _currentCharacterManager:CharacterManager = null;
      
      private static const STAT_EFFECTS:Object = {
         "hp":{
            "inc":["max_hp_increase"],
            "dec":["max_hp_decrease"]
         },
         "cp":{
            "inc":["max_cp_increase"],
            "dec":["max_cp_decrease"]
         },
         "sp":{
            "inc":["max_sp_increase"],
            "dec":["max_sp_decrease"]
         },
         "agility":{
            "inc":["agility_increase","increase_agility"],
            "dec":["agility_decrease","decrease_agility"]
         },
         "critical":{
            "inc":["critical_increase","increase_critical"],
            "dec":["critical_decrease","decrease_critical"]
         },
         "dodge":{
            "inc":["dodge_increase","increase_dodge"],
            "dec":["dodge_decrease","decrease_dodge"]
         },
         "purify":{
            "inc":["purify_increase","increase_purify"],
            "dec":["decrease_purify","decrease_purify"]
         },
         "accuracy":{
            "inc":["accuracy_increase","increase_accuracy"],
            "dec":["accuracy_decrease","decrease_accuracy"]
         }
      };
       
      
      public var main;
      
      public function StatManager(param1:* = false)
      {
         super();
         this.main = param1;
      }
      
      private static function buildEquippedSets(param1:String, param2:String, param3:String, param4:String = null, param5:String = null) : Array
      {
         var _loc6_:Object = param1 != "" ? WeaponBuffs.getCopy(param1) : null;
         var _loc7_:Object = param2 != "" ? BackItemBuffs.getCopy(param2) : null;
         var _loc8_:Object = param3 != "" ? AccessoryBuffs.getCopy(param3) : null;
         var _loc9_:Array = SetBonusCalculator.getSetBonusEffects(param1,param2,param3,param4 != null ? param4 : "",param5 != null ? param5 : "",param1 != "");
         return [_loc6_ && _loc6_.effects ? _loc6_.effects : [],_loc7_ && _loc7_.effects ? _loc7_.effects : [],_loc8_ && _loc8_.effects ? _loc8_.effects : [],_loc9_];
      }
      
      private static function passiveTalentsDisabledForCurrent() : Boolean
      {
         if(_currentCharacterManager == null)
         {
            return false;
         }
         var _loc1_:Object = _currentCharacterManager.character_model;
         if(!_loc1_ || !_loc1_.effects_manager)
         {
            return false;
         }
         return _loc1_.effects_manager.passiveTalentsDisabled();
      }
      
      public static function calculate_stats_with_data(param1:String, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:String = "", param8:String = "", param9:String = "", param10:String = null, param11:String = null, param12:String = null, param13:String = null) : *
      {
         var baseHp:int = 0;
         var baseCp:int = 0;
         var statType:String = param1;
         var level:int = param2;
         var earth:int = param3;
         var water:int = param4;
         var wind:int = param5;
         var lightning:int = param6;
         var weaponId:String = param7;
         var backItemId:String = param8;
         var accessoryId:String = param9;
         var talentSkills:String = param10;
         var senjutsuSkills:String = param11;
         var clothingId:String = param12;
         var hairId:String = param13;
         var oldTalent:String = temp_talent_skills;
         var oldSenjutsu:String = temp_senjutsu_skills;
         if(talentSkills != null)
         {
            temp_talent_skills = talentSkills;
         }
         if(senjutsuSkills != null)
         {
            temp_senjutsu_skills = senjutsuSkills;
         }
         if(weaponId == "" || level == 0)
         {
            level = int(Character.character_lvl);
            earth = Character.atrrib_earth;
            water = Character.atrrib_water;
            wind = Character.atrrib_wind;
            lightning = Character.atrrib_lightning;
            weaponId = Character.character_weapon;
            accessoryId = Character.character_accessory;
            backItemId = Character.character_back_item;
            if(clothingId == null)
            {
               clothingId = Character.character_set;
            }
            if(hairId == null)
            {
               hairId = Character.character_hair;
            }
         }
         _level = level;
         _earth = earth;
         _water = water;
         _wind = wind;
         _lightning = lightning;
         _weaponId = weaponId;
         _backItemId = backItemId;
         _accessoryId = accessoryId;
         _clothingId = clothingId != null ? clothingId : "";
         _hairId = hairId != null ? hairId : "";
         var equippedSets:Array = buildEquippedSets(weaponId,backItemId,accessoryId,_clothingId,_hairId);
         var result:* = 0;
         try
         {
            switch(statType)
            {
               case "hp":
                  baseHp = getBaseHp(level,earth);
                  if(calculating_data_hp)
                  {
                     return baseHp;
                  }
                  calculating_data_hp = true;
                  result = calculateMaxHpFromModifiers(baseHp,equippedSets);
                  calculating_data_hp = false;
                  break;
               case "cp":
                  baseCp = getBaseCp(level,water);
                  if(calculating_data_cp)
                  {
                     return baseCp;
                  }
                  calculating_data_cp = true;
                  result = checkEquippedSetNew("cp",baseCp,equippedSets);
                  calculating_data_cp = false;
                  break;
               case "sp":
                  result = checkEquippedSetNew("sp",getBaseSp(level),equippedSets);
                  break;
               case "agility":
                  result = checkEquippedSetNew("agility",getBaseAgility(level,wind),equippedSets);
                  break;
               case "critical":
                  result = checkEquippedSetNew("critical",getBaseCritical(lightning),equippedSets).toFixed(1);
                  break;
               case "dodge":
                  result = checkEquippedSetNew("dodge",getBaseDodge(wind),equippedSets).toFixed(1);
                  break;
               case "purify":
                  result = checkEquippedSetNew("purify",getBasePurify(water),equippedSets).toFixed(1);
                  break;
               case "accuracy":
                  result = checkEquippedSetNew("accuracy",getBaseAccuracy(),equippedSets).toFixed(1);
            }
         }
         finally
         {
            temp_talent_skills = oldTalent;
            temp_senjutsu_skills = oldSenjutsu;
         }
         return result;
      }
      
      private static function getSkillList(param1:String) : Array
      {
         var _loc2_:String = param1 == "talent" ? (temp_talent_skills != null ? temp_talent_skills : Character.character_talent_skills) : (temp_senjutsu_skills != null ? temp_senjutsu_skills : Character.character_senjutsu_skills);
         if(_loc2_ == null || _loc2_ == "")
         {
            return [];
         }
         return _loc2_.indexOf(",") >= 0 ? _loc2_.split(",") : [_loc2_];
      }
      
      public static function getBaseHp(param1:int, param2:int) : int
      {
         return 60 + param1 * 40 + param2 * 30;
      }
      
      public static function getBaseCp(param1:int, param2:int) : int
      {
         return 60 + param1 * 40 + param2 * 30;
      }
      
      public static function getBaseSp(param1:int) : int
      {
         return 1000 + (param1 - 80) * 40;
      }
      
      public static function getBaseAgility(param1:int, param2:int) : Number
      {
         return Number(9) + Number(param1) + Number(param2);
      }
      
      public static function getBaseCritical(param1:int) : Number
      {
         return 5 + param1 * 0.4;
      }
      
      public static function getBaseDodge(param1:int) : Number
      {
         return 5 + param1 * 0.4;
      }
      
      public static function getBasePurify(param1:int) : Number
      {
         return param1 * 0.4;
      }
      
      public static function getBaseAccuracy() : Number
      {
         return 0;
      }
      
      public static function calculateItemStat(param1:String, param2:Number, param3:Array) : Number
      {
         if(!STAT_EFFECTS.hasOwnProperty(param1))
         {
            return param2;
         }
         var _loc4_:Object = STAT_EFFECTS[param1];
         return applyEffects(param2,param3,_loc4_.inc,_loc4_.dec);
      }
      
      private static function applyEffects(param1:Number, param2:Array, param3:Array, param4:Array) : Number
      {
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < param2.length)
         {
            _loc6_ = param2[_loc7_];
            _loc8_ = 0;
            while(_loc8_ < _loc6_.length)
            {
               _loc5_ = _loc6_[_loc8_];
               if(param3.indexOf(_loc5_.effect) >= 0 || param4.indexOf(_loc5_.effect) >= 0)
               {
                  _loc9_ = int(_loc5_.amount);
                  if(_loc5_.hasOwnProperty("calc_type") && _loc5_.calc_type != null)
                  {
                     _loc10_ = _loc5_.calc_type == "number" ? int(_loc9_) : int(Math.floor(_loc9_ * param1 / 100));
                  }
                  else
                  {
                     _loc10_ = _loc9_;
                  }
                  if(param3.indexOf(_loc5_.effect) >= 0)
                  {
                     param1 += _loc10_;
                  }
                  if(param4.indexOf(_loc5_.effect) >= 0)
                  {
                     param1 -= _loc10_;
                  }
               }
               _loc8_++;
            }
            _loc7_++;
         }
         return param1;
      }
      
      private static function checkEquippedSetNew(param1:*, param2:*, param3:*) : *
      {
         switch(param1)
         {
            case "hp":
               return calculateMaxHpFromModifiers(param2,param3);
            case "cp":
               param2 = calculateItemStat(param1,param2,param3);
               param2 = getMaximumCPFromTalent(param2);
               return getMaximumCPFromSenjutsu(param2);
            case "agility":
               param2 = calculateItemStat(param1,param2,param3);
               param2 = getAgilityRateFromTalent(param2);
               return getAgilityFromPassiveTalent(param2);
            case "critical":
               param2 = calculateItemStat(param1,param2,param3);
               return getCriticalRateFromTalent(param2);
            case "dodge":
               param2 = calculateItemStat(param1,param2,param3);
               return getDodgeFromTalent(param2);
            case "purify":
               param2 = calculateItemStat(param1,param2,param3);
               param2 = getPurifyRateFromTalent(param2);
               param2 = getPurifyRateFromTalentByCP(param2);
               return getPurifyRateFromTalentByHP(param2);
            case "accuracy":
               param2 = calculateItemStat(param1,param2,param3);
               return getAccuracyFromTalent(param2);
            default:
               return calculateItemStat(param1,param2,param3);
         }
      }
      
      public static function canCheckWpnEffects(param1:CharacterManager) : *
      {
         var effects:* = undefined;
         var characterManager:CharacterManager = param1;
         try
         {
            effects = characterManager.character_model.effects_manager.user_debuffs;
            return effects["disable_weapon_effect"].duration > 0 ? false : true;
         }
         catch(e:*)
         {
            return true;
         }
      }
      
      public static function getSp(param1:CharacterManager) : *
      {
         var _loc2_:int = param1.getLevel();
         var _loc3_:int = getBaseSp(_loc2_);
         var _loc4_:String = !!canCheckWpnEffects(param1) ? param1.getWeapon() : "";
         var _loc5_:String = param1.getBackItem();
         var _loc6_:String = param1.getAccessory();
         var _loc7_:String = param1.getClothing();
         var _loc8_:String = param1.getHair();
         var _loc9_:Array = buildEquippedSets(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
         return int(checkEquippedSetNew("sp",_loc3_,_loc9_));
      }
      
      public static function recalculateSp(param1:CharacterManager) : *
      {
         return getSp(param1);
      }
      
      public static function recalculateHp(param1:CharacterManager) : *
      {
         return getHp(param1);
      }
      
      public static function getHp(param1:CharacterManager) : *
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Automatic deobfuscation" in Settings
          * Error type: NullPointerException (null)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      private static function calculateMaxHpFromModifiers(param1:int, param2:Array, param3:CharacterManager = null) : int
      {
         var _loc4_:int = int(calculateItemStat("hp",param1,param2));
         var _loc5_:int = int(checkEquippedSetNew("cp",getBaseCp(_level,_water),param2));
         _loc4_ += getIncreaseMaxHPByTalentData(_loc5_,_loc4_,param3);
         return int(getMaximumHPFromSenjutsu(_loc4_));
      }
      
      private static function isOwnPlayer(param1:CharacterManager) : Boolean
      {
         return param1.character_model.getPlayerTeam() == "player" && param1.character_model.getPlayerNumber() == 0;
      }
      
      private static function getIncreaseMaxHPByTalentData(param1:int, param2:int, param3:CharacterManager = null) : int
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         if(param3 && param3.character_model && param3.character_model.effects_manager && param3.character_model.effects_manager.hadEffect("disable_passive_talent"))
         {
            return 0;
         }
         for each(_loc4_ in getSkillList("talent"))
         {
            _loc6_ = (_loc5_ = _loc4_.split(":"))[0];
            if(_loc7_ = TalentSkillLevel.getCopy(_loc6_,int(_loc5_[1])))
            {
               if(_loc6_ == "skill_1003" && _loc7_.hasOwnProperty("increase_max_hp"))
               {
                  return int(param2 * _loc7_.increase_max_hp / 100);
               }
               if(_loc6_ == "skill_1046" && _loc7_.hasOwnProperty("increase_max_hp"))
               {
                  return int(_loc7_.increase_max_hp);
               }
               if(_loc6_ == "skill_1052" && _loc7_.hasOwnProperty("increase_max_hp"))
               {
                  return int(param1 * _loc7_.increase_max_hp / 100);
               }
            }
         }
         return 0;
      }
      
      public static function recalculateCp(param1:CharacterManager) : *
      {
         return getCp(param1);
      }
      
      public static function getCp(param1:CharacterManager) : *
      {
         if(isOwnPlayer(param1) && Character.character_cp != null)
         {
            return int(Character.character_cp);
         }
         var _loc2_:int = getBaseCp(param1.getLevel(),param1.getWaterAttributes());
         var _loc3_:Number = !!param1.isActionsManagerLoaded() ? Number(param1.character_model.effects_manager.getIncreaseMaxCPByTalent()) : Number(0);
         if(_loc3_ > 0)
         {
            _loc2_ += Math.floor(_loc2_ * _loc3_ / 100);
         }
         var _loc4_:String = !!canCheckWpnEffects(param1) ? param1.getWeapon() : "";
         var _loc5_:Array = buildEquippedSets(_loc4_,param1.getBackItem(),param1.getAccessory(),param1.getClothing(),param1.getHair());
         _loc2_ = int(calculateItemStat("cp",_loc2_,_loc5_));
         _loc2_ = int(getMaximumCPFromSenjutsu(_loc2_));
         if(Character.is_clan_war && param1.characterClanData)
         {
            _loc2_ += Math.floor(_loc2_ * int(param1.characterClanData.temple * 30) / 100);
         }
         return _loc2_;
      }
      
      public static function getPurify(param1:CharacterManager) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _currentCharacterManager = param1;
         if(isOwnPlayer(param1) && Character.character_purify != null)
         {
            _loc2_ = Number(Character.character_purify);
         }
         else
         {
            _loc3_ = param1.getLevel();
            _loc4_ = param1.getWaterAttributes();
            _loc5_ = !!canCheckWpnEffects(param1) ? param1.getWeapon() : "";
            _loc2_ = Number(calculate_stats_with_data("purify",_loc3_,0,_loc4_,0,0,_loc5_,param1.getBackItem(),param1.getAccessory(),param1.getTalentSkillsString(),param1.getSenjutsuSkillsString(),param1.getClothing(),param1.getHair()));
         }
         _currentCharacterManager = null;
         return int(_loc2_);
      }
      
      public static function getAgility(param1:CharacterManager) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = param1.getLevel();
         var _loc4_:int = param1.getWindAttributes();
         var _loc5_:String = !!canCheckWpnEffects(param1) ? param1.getWeapon() : "";
         var _loc6_:String = param1.getBackItem();
         var _loc7_:String = param1.getAccessory();
         var _loc8_:String = param1.getClothing();
         var _loc9_:String = param1.getHair();
         if(param1.character_model.effects_manager.hadEffect("disable_passive_talent"))
         {
            _loc2_ = calculateItemStat("agility",getBaseAgility(_loc3_,_loc4_),buildEquippedSets(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_));
         }
         else if(isOwnPlayer(param1) && Character.character_agility != null)
         {
            _loc2_ = Number(Character.character_agility);
         }
         else
         {
            _loc2_ = Number(calculate_stats_with_data("agility",_loc3_,0,0,_loc4_,0,_loc5_,_loc6_,_loc7_,param1.getTalentSkillsString(),param1.getSenjutsuSkillsString(),_loc8_,_loc9_));
         }
         var _loc10_:Array = param1.character_model.effects_manager.getActiveBuff("agility");
         var _loc11_:Array = param1.character_model.effects_manager.getActiveDebuff("agility");
         var _loc12_:Number = BattleManager.modifyChance(_loc10_,"ADD",_loc2_);
         return Number(BattleManager.modifyChance(_loc11_,"RM",_loc12_));
      }
      
      public static function getAccuracy(param1:CharacterManager) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _currentCharacterManager = param1;
         if(isOwnPlayer(param1) && Character.character_accuracy != null)
         {
            _loc2_ = Number(Character.character_accuracy);
         }
         else
         {
            _loc3_ = param1.getLevel();
            _loc4_ = !!canCheckWpnEffects(param1) ? param1.getWeapon() : "";
            _loc2_ = Number(calculate_stats_with_data("accuracy",_loc3_,0,0,0,0,_loc4_,param1.getBackItem(),param1.getAccessory(),param1.getTalentSkillsString(),param1.getSenjutsuSkillsString(),param1.getClothing(),param1.getHair()));
         }
         _currentCharacterManager = null;
         return _loc2_;
      }
      
      public static function getCritical(param1:CharacterManager) : Number
      {
         _currentCharacterManager = param1;
         var _loc2_:int = param1.getLevel();
         var _loc3_:int = param1.getLightningAttributes();
         var _loc4_:String = !!canCheckWpnEffects(param1) ? param1.getWeapon() : "";
         var _loc5_:Number = Number(calculate_stats_with_data("critical",_loc2_,0,0,0,_loc3_,_loc4_,param1.getBackItem(),param1.getAccessory(),param1.getTalentSkillsString(),param1.getSenjutsuSkillsString(),param1.getClothing(),param1.getHair()));
         _currentCharacterManager = null;
         return _loc5_;
      }
      
      public static function getDodge(param1:CharacterManager) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _currentCharacterManager = param1;
         if(isOwnPlayer(param1) && Character.character_dodge != null)
         {
            _loc2_ = Number(Character.character_dodge);
         }
         else
         {
            _loc3_ = param1.getLevel();
            _loc4_ = param1.getWindAttributes();
            _loc5_ = !!canCheckWpnEffects(param1) ? param1.getWeapon() : "";
            _loc2_ = Number(calculate_stats_with_data("dodge",_loc3_,0,0,_loc4_,0,_loc5_,param1.getBackItem(),param1.getAccessory(),param1.getTalentSkillsString(),param1.getSenjutsuSkillsString(),param1.getClothing(),param1.getHair()));
         }
         _currentCharacterManager = null;
         return _loc2_;
      }
      
      public static function getBlockChance(param1:CharacterManager) : *
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = param1.character_model.health_manager.getCurrentHP();
         var _loc4_:int = param1.character_model.health_manager.getMaxHP();
         var _loc5_:Array = param1.character_model.effects_manager.getAllCharacterSetEffects();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               if(_loc7_[_loc8_].effect == "block_damage")
               {
                  _loc2_ += _loc7_[_loc8_].amount;
               }
               else if(_loc7_[_loc8_].effect == "guard_below_hp")
               {
                  if(_loc3_ < _loc4_ * _loc7_[_loc8_].amount / 100)
                  {
                     _loc2_ += _loc7_[_loc8_].chance;
                  }
               }
               _loc8_++;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public static function getIgnoreBlockChance(param1:CharacterManager) : *
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = param1.character_model.effects_manager.getAllCharacterSetEffects();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_].effect == "ignore_block_damage")
               {
                  _loc2_ += _loc5_[_loc6_].amount;
               }
               _loc6_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function getConvertChance(param1:CharacterManager) : *
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = param1.character_model.effects_manager.getAllCharacterSetEffects();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_].effect == "convert_fulldmg_to_hp" || _loc5_[_loc6_].effect == "convert_damage_taken_hp")
               {
                  _loc2_ += _loc5_[_loc6_].chance;
               }
               _loc6_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function getConvertChanceCP(param1:CharacterManager) : *
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = param1.character_model.effects_manager.getAllCharacterSetEffects();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_].effect == "convert_damage_taken_cp")
               {
                  _loc2_ += _loc5_[_loc6_].chance;
               }
               _loc6_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function getDodgeFromTalent(param1:*) : *
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return param1;
         }
         var _loc2_:* = 0;
         for each(_loc3_ in getSkillList("talent"))
         {
            if((_loc4_ = _loc3_.split(":"))[0] == "skill_1006")
            {
               _loc2_ = (_loc5_ = TalentSkillLevel.getCopy(_loc4_[0],_loc4_[1])) && _loc5_.hasOwnProperty("increase_dodge") ? _loc5_.increase_dodge : _loc4_[1];
            }
         }
         return param1 + int(_loc2_);
      }
      
      public static function getExtraChargeCPFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return 0;
         }
         var _loc1_:* = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentExtraCPByLvl(_loc3_[0],_loc3_[1]);
         }
         return _loc1_;
      }
      
      public static function talentExtraCPByLvl(param1:*, param2:*) : *
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("increase_charge") ? _loc3_.increase_charge : 0;
      }
      
      public static function getExtraDamageForTaijutsuFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:* = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentExtraDmgTaijutsuByLvl(_loc3_[0],_loc3_[1]);
         }
         return _loc1_;
      }
      
      public static function talentExtraDmgTaijutsuByLvl(param1:*, param2:*) : *
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("amount_increase") ? _loc3_.amount_increase : 0;
      }
      
      public static function getReduceHPForTaijutsuFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:* = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentExtraReduceDmgTaijutsuByLvl(_loc3_[0],_loc3_[1]);
         }
         return _loc1_;
      }
      
      public static function talentExtraReduceDmgTaijutsuByLvl(param1:*, param2:*) : *
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("amount_deduct") ? _loc3_.amount_deduct : 0;
      }
      
      public static function getCopyJutsuPrcFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:* = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentCopyJutsuPrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return _loc1_;
      }
      
      public static function talentCopyJutsuPrcByLvl(param1:*, param2:*) : *
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("chance") ? _loc3_.chance : 0;
      }
      
      public static function getCopyGenjutsuPrcFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:* = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentCopyGenjutsuPrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return _loc1_;
      }
      
      public static function talentCopyGenjutsuPrcByLvl(param1:*, param2:*) : *
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("chance") ? _loc3_.chance : 0;
      }
      
      public static function getHPCPRevivePrcFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:* = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentHPCPRevivePrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return _loc1_;
      }
      
      public static function talentHPCPRevivePrcByLvl(param1:*, param2:*) : *
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("amount") ? _loc3_.amount : 0;
      }
      
      public static function getReboundChanceFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:* = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentReboundChanceByLvl(_loc3_[0],_loc3_[1]);
         }
         return _loc1_;
      }
      
      public static function talentReboundChanceByLvl(param1:*, param2:*) : *
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("receive_damage_prc") ? _loc3_.receive_damage_prc : 0;
      }
      
      public static function getStunChanceFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:* = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentStunChanceByLvl(_loc3_[0],_loc3_[1]);
         }
         return _loc1_;
      }
      
      public static function talentStunChanceByLvl(param1:*, param2:*) : *
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("stun_chance") ? _loc3_.stun_chance : 0;
      }
      
      public static function getReduceDamagePercentFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentReduceDamagePrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return int(_loc1_);
      }
      
      public static function talentReduceDamagePrcByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("reduce_damage_percent") ? int(int(_loc3_.reduce_damage_percent)) : 0;
      }
      
      public static function getWeakenChancePercentFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc1_:Array = [0,0];
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc4_ = talentWeakenChancePrcByLvl(_loc3_[0],_loc3_[1]);
            _loc1_[0] += _loc4_[0];
            _loc1_[1] += _loc4_[1];
         }
         return _loc1_;
      }
      
      public static function talentWeakenChancePrcByLvl(param1:*, param2:*) : Array
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("weaken_chance_data") ? _loc3_.weaken_chance_data : [0,0];
      }
      
      public static function getRecoverHPCPChancePercentFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc1_:Array = [0,0];
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc4_ = talentRecoverHPCPChancePrcByLvl(_loc3_[0],_loc3_[1]);
            _loc1_[0] += _loc4_[0];
            _loc1_[1] += _loc4_[1];
         }
         return _loc1_;
      }
      
      public static function talentRecoverHPCPChancePrcByLvl(param1:*, param2:*) : Array
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("recover_hpcp_chance") ? _loc3_.recover_hpcp_chance : [0,0];
      }
      
      public static function getHPRecoverPercentUnder50PRCFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentHPRPUnder50PrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return int(_loc1_);
      }
      
      public static function talentHPRPUnder50PrcByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("hp_recover_percent_under_50") ? int(int(_loc3_.hp_recover_percent_under_50)) : 0;
      }
      
      public static function getReboundDamagePercentAndAmountFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc1_:Array = [0,0];
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc4_ = talentReboundDamagePrcAndAmtByLvl(_loc3_[0],_loc3_[1]);
            _loc1_[0] += _loc4_[0];
            _loc1_[1] += _loc4_[1];
         }
         return _loc1_;
      }
      
      public static function talentReboundDamagePrcAndAmtByLvl(param1:*, param2:*) : Array
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("rebound_damage") ? _loc3_.rebound_damage : [0,0];
      }
      
      public static function getStunResistPercentFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentStunResistPrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return int(_loc1_);
      }
      
      public static function talentStunResistPrcByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("stun_resist_percent") ? int(int(_loc3_.stun_resist_percent)) : 0;
      }
      
      public static function getChanceToRecoverHPByAttackFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentRecoverHPPrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return int(_loc1_);
      }
      
      public static function talentRecoverHPPrcByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("recover_hp_by_attack_percent") ? int(int(_loc3_.recover_hp_by_attack_percent)) : 0;
      }
      
      public static function getCaptureReduceDodgeFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentCaptureReduceDodgePrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return int(_loc1_);
      }
      
      public static function talentCaptureReduceDodgePrcByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("capture_reduce_dodge_percent") ? int(int(_loc3_.capture_reduce_dodge_percent)) : 0;
      }
      
      public static function getCapturePercentFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentCapturePrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return int(_loc1_);
      }
      
      public static function talentCapturePrcByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("chance") ? int(_loc3_.chance) : 0;
      }
      
      public static function getFrozenChanceFromTalent() : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            _loc1_ += talentFrozenChancePrcByLvl(_loc3_[0],_loc3_[1]);
         }
         return int(_loc1_);
      }
      
      public static function talentFrozenChancePrcByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("chance") ? int(_loc3_.chance) : 0;
      }
      
      public static function getCriticalRateFromTalent(param1:*) : *
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return param1;
         }
         var _loc2_:int = 0;
         for each(_loc3_ in getSkillList("talent"))
         {
            _loc4_ = _loc3_.split(":");
            _loc2_ += talentCriticalByLvl(_loc4_[0],_loc4_[1]);
         }
         return param1 + int(_loc2_);
      }
      
      public static function talentCriticalByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("increase_critical_chance") ? int(int(_loc3_.increase_critical_chance)) : 0;
      }
      
      public static function getAccuracyFromTalent(param1:int) : *
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return int(param1);
         }
         var _loc2_:int = 0;
         for each(_loc3_ in getSkillList("talent"))
         {
            _loc4_ = _loc3_.split(":");
            _loc2_ += talentAccuracyByLvl(_loc4_[0],_loc4_[1]);
         }
         return int(param1 + _loc2_);
      }
      
      public static function talentAccuracyByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("increase_accuracy") ? int(_loc3_.increase_accuracy) : 0;
      }
      
      public static function getAgilityRateFromTalent(param1:int) : int
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return param1;
         }
         var _loc2_:Number = 0;
         for each(_loc3_ in getSkillList("talent"))
         {
            if((_loc4_ = _loc3_.split(":"))[0] == "skill_1003")
            {
               if((_loc5_ = TalentSkillLevel.getCopy(_loc4_[0],_loc4_[1])) && _loc5_.hasOwnProperty("increase_agility"))
               {
                  _loc2_ += Number(_loc5_.increase_agility);
               }
            }
         }
         return param1 + Math.floor(param1 * _loc2_ / 100);
      }
      
      public static function getAgilityFromPassiveTalent(param1:*) : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         if(passiveTalentsDisabledForCurrent())
         {
            return param1;
         }
         for each(_loc2_ in getSkillList("talent"))
         {
            _loc3_ = _loc2_.split(":");
            if(_loc3_[0] == "skill_1119")
            {
               if((_loc4_ = TalentSkillLevel.getCopy(_loc3_[0],_loc3_[1])) && _loc4_.hasOwnProperty("max_hp_count") && _loc4_.hasOwnProperty("increase_agility"))
               {
                  _loc5_ = calculate_stats_with_data("hp",_level,_earth,_water,_wind,_lightning,_weaponId,_backItemId,_accessoryId,null,null,_clothingId,_hairId);
                  param1 += Math.round(_loc5_ / _loc4_.max_hp_count) * _loc4_.increase_agility;
               }
            }
         }
         return param1;
      }
      
      public static function getPurifyRateFromTalent(param1:*) : *
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return param1;
         }
         var _loc2_:* = 0;
         for each(_loc3_ in getSkillList("talent"))
         {
            _loc4_ = _loc3_.split(":");
            _loc2_ += talentPurifyByTalent(_loc4_[0],_loc4_[1]);
         }
         return param1 + _loc2_;
      }
      
      public static function talentPurifyByTalent(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return _loc3_ && _loc3_.hasOwnProperty("increase_purify_chance") ? int(_loc3_.increase_purify_chance) : 0;
      }
      
      public static function getPurifyRateFromTalentByCP(param1:*) : *
      {
         var _loc3_:String = null;
         var _loc6_:Array = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return param1;
         }
         var _loc2_:* = 0;
         for each(_loc3_ in getSkillList("talent"))
         {
            _loc6_ = _loc3_.split(":");
            _loc2_ += talentPurifyByLvlCP(_loc6_[0],_loc6_[1]);
         }
         if(_loc2_ == 0)
         {
            return param1;
         }
         var _loc4_:int = int(calculate_stats_with_data("cp",_level,_earth,_water,_wind,_lightning,_weaponId,_backItemId,_accessoryId,null,null,_clothingId,_hairId));
         var _loc5_:int = Math.round(_loc4_ / _loc2_);
         return param1 + _loc5_;
      }
      
      public static function talentPurifyByLvlCP(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         if(!_loc3_)
         {
            return 0;
         }
         if(_loc3_.hasOwnProperty("purify_rate_by_cp_divisor"))
         {
            return int(_loc3_.purify_rate_by_cp_divisor);
         }
         return param1 == "skill_1051" && _loc3_.hasOwnProperty("purify_chance_on") ? int(int(_loc3_.purify_chance_on)) : 0;
      }
      
      public static function getPurifyRateFromTalentByHP(param1:*) : *
      {
         var _loc3_:String = null;
         var _loc5_:Array = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return param1;
         }
         var _loc2_:* = 0;
         for each(_loc3_ in getSkillList("talent"))
         {
            _loc5_ = _loc3_.split(":");
            _loc2_ += talentPurifyByLvlHP(_loc5_[0],_loc5_[1]);
         }
         if(_loc2_ == 0)
         {
            return param1;
         }
         var _loc4_:int = Math.round(calculate_stats_with_data("hp",_level,_earth,_water,_wind,_lightning,_weaponId,_backItemId,_accessoryId,null,null,_clothingId,_hairId) / _loc2_);
         return param1 + _loc4_;
      }
      
      public static function talentPurifyByLvlHP(param1:*, param2:*) : int
      {
         var _loc3_:Object = TalentSkillLevel.getCopy(param1,param2);
         return param1 == "skill_1102" && _loc3_ && _loc3_.hasOwnProperty("purify_chance_on") ? int(int(_loc3_.purify_chance_on)) : 0;
      }
      
      public static function getMaximumCPFromTalent(param1:*) : *
      {
         var _loc3_:String = null;
         if(passiveTalentsDisabledForCurrent())
         {
            return param1;
         }
         var _loc2_:int = 0;
         for each(_loc3_ in getSkillList("talent"))
         {
            _loc2_ += talentMaxCPByLvl(_loc3_,param1);
         }
         return int(int(param1) + int(_loc2_));
      }
      
      public static function talentMaxCPByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Array = param1.split(":");
         if(_loc3_.length < 2)
         {
            return 0;
         }
         return (_loc4_ = TalentSkillLevel.getCopy(_loc3_[0],_loc3_[1])) && _loc4_.hasOwnProperty("increase_max_cp") ? int(Math.floor(param2 * _loc4_.increase_max_cp / 100)) : 0;
      }
      
      public static function getMaximumHPFromSenjutsu(param1:*) : *
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for each(_loc3_ in getSkillList("senjutsu"))
         {
            _loc2_ += senjutsuMaxHPByLvl(_loc3_,param1);
         }
         return int(int(param1) + int(_loc2_));
      }
      
      public static function senjutsuMaxHPByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Array = param1.split(":");
         if(_loc3_.length < 2)
         {
            return 0;
         }
         return (_loc4_ = SenjutsuSkillLevel.getCopy(_loc3_[0],_loc3_[1])) && _loc4_.hasOwnProperty("increase_max_hp") ? int(Math.floor(param2 * _loc4_.increase_max_hp / 100)) : 0;
      }
      
      public static function getMaximumCPFromSenjutsu(param1:*) : *
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for each(_loc3_ in getSkillList("senjutsu"))
         {
            _loc2_ += senjutsuMaxCPByLvl(_loc3_,param1);
         }
         return int(int(param1) + int(_loc2_));
      }
      
      public static function senjutsuMaxCPByLvl(param1:*, param2:*) : int
      {
         var _loc3_:Array = param1.split(":");
         if(_loc3_.length < 2)
         {
            return 0;
         }
         return (_loc4_ = SenjutsuSkillLevel.getCopy(_loc3_[0],_loc3_[1])) && _loc4_.hasOwnProperty("increase_max_cp") ? int(Math.floor(param2 * _loc4_.increase_max_cp / 100)) : 0;
      }
      
      public static function formatNumber(param1:*) : *
      {
         var _loc2_:Array = ["","K","M"];
         var _loc3_:int = 0;
         while(param1 >= 1000 && _loc3_ < _loc2_.length - 1)
         {
            param1 /= 1000;
            _loc3_++;
         }
         return Math.round(param1) + _loc2_[_loc3_];
      }
      
      public static function calculate_pet_xp(param1:int) : *
      {
         var _loc2_:Array = [0,28,61,99,142,192,249,315,389,473,569,676,798,935,1088,1261,1455,1671,1914,2184,2487,2823,3198,3616,4080,4596,5196,5805,6510,7291,8156,9114,10173,11345,12640,14071,15651,17395,19319,21440,23780,27733,30696,33471,36193,39579,42140,46342,49634,53379,56695,59936,66622,70841,74605,79734,86755,90227,95427,103740,110291,125307,145705,174070,211985,259748,314393,377280,447571,526381,612222,705963,806478,912730,1026380,1144886,1269847,1402425,1538415,1683103,1831845,2049957,2372858,2695758,3018659,3541560,4057490,4639279,5221067,5902856,6184644,7297879,8611498,10161568,11990650,14148967,65910291,81728761,101343664,125666144,155826018];
         return param1 >= 1 && param1 <= 100 ? _loc2_[param1] : 99999999999;
      }
      
      public static function cleanup() : void
      {
         temp_talent_skills = null;
         temp_senjutsu_skills = null;
         calculating_data_hp = false;
         calculating_data_cp = false;
         _level = 0;
         _earth = 0;
         _water = 0;
         _wind = 0;
         _lightning = 0;
         _weaponId = "";
         _backItemId = "";
         _accessoryId = "";
         _clothingId = "";
         _hairId = "";
      }
      
      public function calculate_stats(param1:String) : *
      {
         return calculate_stats_with_data(param1);
      }
      
      public function calculate_xp(param1:int) : *
      {
         var _loc2_:Array = [0,15,304,493,711,961,1247,1574,1945,2366,2843,3382,3989,4673,5542,6306,7273,8537,9569,10922,12433,14117,15992,18080,20401,22981,25845,29024,32548,36454,40780,45569,50867,56725,63201,70354,78254,86973,96593,107202,118899,131790,145991,161632,178850,197801,218652,241587,266806,294530,325000,358478,395253,435640,479982,528656,582073,640648,704980,775497,858822,973598,1030523,1132364,1243956,1366211,1500266,1646789,1807388,1983211,2175702,3857490,5539279,7221067,8902856,10584644,34958287,38667739,42377192,46086644,49796096,69149957,73172858,77195758,81218659,85241560,118206898,130658489,143202210,155837542,168563974,586602629,686931906,811340210,965606507,1156896715,4164828174,5067207611,6240300880,7765322130,9747849755];
         return param1 >= 1 && param1 <= 100 ? _loc2_[param1] : 99999999999;
      }
      
      public function destroy() : void
      {
         this.main = null;
         cleanup();
      }
   }
}
