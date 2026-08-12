package Combat
{
   import Storage.AccessoryBuffs;
   import Storage.BackItemBuffs;
   import Storage.SenjutsuSkillLevel;
   import Storage.TalentSkillLevel;
   import Storage.WeaponBuffs;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.Util;
   
   public class EffectsManager
   {
      
      private static var activeBackgroundModel:Object = null;
       
      
      public var user_buffs:Array;
      
      public var user_debuffs:Array;
      
      public var all_buffs_name_array:Array;
      
      public var all_debuffs_name_array:Array;
      
      public var tempt_skills_used_for_senjutsu:Array;
      
      public var cooldownListFromSenjutsu:Array;
      
      public var tempt_skills_used_for_talent:Array;
      
      public var cooldownListFromTalent:Array;
      
      public var user_team:String;
      
      public var user_number:int;
      
      public var has_added_health_from_debuff:Boolean = false;
      
      public var has_added_cp_from_debuff:Boolean = false;
      
      public var has_added_health_from_buff:Boolean = false;
      
      public var has_added_cp_from_buff:Boolean = false;
      
      public var meridian_kekkai_procced_this_turn:Boolean = false;
      
      public var model = null;
      
      private var allSetEffects;
      
      public var dataBuff:Vector.<Object>;
      
      public var dataDebuff:Vector.<Object>;
      
      private var lastDisableWeaponState:Boolean = false;
      
      private var lastSetEffectsSignature:String = null;
      
      public var is_passive_talent_disabled:Boolean = false;
      
      public function EffectsManager(param1:String, param2:int)
      {
         this.allSetEffects = [];
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         this.user_buffs = [];
         this.user_debuffs = [];
         this.dataBuff = new Vector.<Object>();
         this.dataDebuff = new Vector.<Object>();
         this.all_buffs_name_array = [];
         this.all_debuffs_name_array = [];
         this.tempt_skills_used_for_senjutsu = [false];
         this.cooldownListFromSenjutsu = [""];
         this.tempt_skills_used_for_talent = [false];
         this.cooldownListFromTalent = [""];
         super();
         this.user_team = param1;
         this.user_number = param2;
         var _loc6_:Object = this.getAllBuffs();
         for each(_loc3_ in _loc6_)
         {
            this.user_buffs[_loc3_.effect] = Effects.copyEffect(_loc3_);
            this.all_buffs_name_array.push(_loc3_.effect);
         }
         _loc4_ = this.getAllDebuffs();
         for each(_loc5_ in _loc4_)
         {
            this.user_debuffs[_loc5_.effect] = Effects.copyEffect(_loc5_);
            this.all_debuffs_name_array.push(_loc5_.effect);
         }
         Effects.init();
      }
      
      public function hadEffect(param1:String) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == "unyielding" && this.hadEffect("disable_passive_talent"))
         {
            return false;
         }
         for each(_loc2_ in this.dataBuff)
         {
            if(param1 == _loc2_.effect && _loc2_.duration > 0)
            {
               return true;
            }
         }
         for each(_loc3_ in this.dataDebuff)
         {
            if(param1 == _loc3_.effect && _loc3_.duration > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getEffect(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == "unyielding" && this.hadEffect("disable_passive_talent"))
         {
            return {};
         }
         for each(_loc2_ in this.dataBuff)
         {
            if(param1 == _loc2_.effect && _loc2_.duration > 0)
            {
               return _loc2_;
            }
         }
         for each(_loc3_ in this.dataDebuff)
         {
            if(param1 == _loc3_.effect && _loc3_.duration > 0)
            {
               return _loc3_;
            }
         }
         return {};
      }
      
      public function resetHasAddedHpCpEffects() : *
      {
         this.has_added_health_from_debuff = false;
         this.has_added_cp_from_debuff = false;
         this.has_added_health_from_buff = false;
         this.has_added_cp_from_buff = false;
         this.meridian_kekkai_procced_this_turn = false;
      }
      
      public function showCombustion() : *
      {
         Effects.showEffectInfo(this.user_team,this.user_number,"Combustion");
      }
      
      public function purifyPlayer(param1:String = "Purify", param2:String = "") : *
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc3_:Object = this.getCurrentModel();
         this.checkRecoverHPAfterPurified();
         this.checkRecoverCPAfterPurified();
         _loc3_.health_manager.createDisplay(param1);
         if(param2 === "sensation")
         {
            this.dataDebuff = new Vector.<Object>();
            return;
         }
         if(this.dataDebuff.length > 0)
         {
            _loc4_ = this.dataDebuff.length - 1;
            while(_loc4_ >= 0)
            {
               _loc5_ = this.dataDebuff[_loc4_];
               if(!("no_purify" in _loc5_ && _loc5_.no_purify || Effects.doesEffectCannotPurified(_loc5_.effect)))
               {
                  this.dataDebuff.splice(_loc4_,1);
               }
               _loc4_--;
            }
         }
      }
      
      public function canPlayerUseSkill(param1:String, param2:int, param3:*, param4:*) : *
      {
         var _loc5_:* = param4 is MouseEvent;
         var _loc6_:Boolean = this.hadEffect("restriction") || this.hadEffect("pet_restriction");
         var _loc7_:Boolean = this.hadEffect("ecstasy") || this.hadEffect("pet_ecstasy");
         var _loc8_:Boolean = this.hadEffect("meridian_seal");
         var _loc9_:Boolean = this.hadEffect("snake_mark");
         var _loc10_:Boolean = this.hadEffect("barrier");
         var _loc11_:Boolean = this.hadEffect("unyielding");
         if(param3.skill_type < 6 && _loc6_)
         {
            if(_loc5_)
            {
               BattleManager.getMain().showMessage("Cannot use that while restricted.");
            }
            return false;
         }
         if(param3.skill_type == 9 || param3.skill_type == 11 && _loc9_)
         {
            if(_loc5_)
            {
               BattleManager.getMain().showMessage("Cannot use that while under Snake Mark.");
            }
            return false;
         }
         if(param3.skill_type < 6 && _loc7_)
         {
            if(_loc5_)
            {
               BattleManager.getMain().showMessage("Cannot use that while under Ecstasy.");
            }
            return false;
         }
         if(_loc8_)
         {
            if(_loc5_)
            {
               BattleManager.getMain().showMessage("Cannot use that while under Meridian Seal.");
            }
            return false;
         }
         if(_loc10_)
         {
            if(_loc5_)
            {
               BattleManager.getMain().showMessage("Cannot use that while under Barrier.");
            }
            return false;
         }
         if(_loc11_)
         {
            if(_loc5_)
            {
               BattleManager.getMain().showMessage("Cannot use that while under unyielding.");
            }
            return false;
         }
         if(this.hadEffect("chaos") || this.hadEffect("pet_chaos"))
         {
            if(_loc5_)
            {
               BattleManager.getMain().showMessage("Cannot use that while under Chaos.");
            }
            return false;
         }
         return true;
      }
      
      public function checkPassiveEffectsAfterBeingHit(param1:*, param2:*, param3:Boolean = true) : *
      {
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         if(param1.isCharacter())
         {
            if(param1.effects_manager.hadEffect("disable_passive_talent"))
            {
               return;
            }
            _loc4_ = param1.effects_manager.getEffect("pet_stubborn_recover_cp");
            _loc5_ = param1.effects_manager.getEffect("attacker_disorient");
            _loc6_ = param1.effects_manager.getAllCharacterSetEffects();
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = "";
            if(param1.effects_manager.hadEffect("pet_stubborn_recover_cp"))
            {
               _loc7_ = int(_loc4_.duration);
               _loc8_ = "chance" in _loc4_ ? int(int(_loc4_.chance)) : 100;
               _loc9_ = int(_loc4_.amount);
               _loc10_ = String(_loc4_.calc_type);
               this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc8_,_loc7_,_loc9_,_loc10_,"instant_cp_recover",true,false,"Stubborn");
            }
            _loc11_ = 0;
            while(_loc11_ < _loc6_.length)
            {
               _loc12_ = _loc6_[_loc11_];
               _loc13_ = 0;
               while(_loc13_ < _loc12_.length)
               {
                  _loc14_ = _loc12_[_loc13_];
                  _loc15_ = int(_loc14_.duration);
                  _loc16_ = int(_loc14_.chance);
                  _loc17_ = int(_loc14_.amount);
                  _loc18_ = String(_loc14_.calc_type);
                  switch(_loc14_.effect)
                  {
                     case "concentration_when_attacked":
                        this.checkPassiveEffectToActiveAfterBeingHit(param1,_loc16_,_loc15_,_loc17_,_loc18_,"concentration",false,true,"Concentration",false,true);
                        break;
                     case "attacker_chaos":
                     case "chaos_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"chaos");
                        break;
                     case "attacker_restrict":
                     case "restrict_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"restriction");
                        break;
                     case "attacker_petrify":
                     case "petrify_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"petrify");
                        break;
                     case "attacker_fear":
                     case "fear_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"fear");
                        break;
                     case "attacker_stun":
                     case "stun_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"stun");
                        break;
                     case "attacker_freeze":
                     case "freeze_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"frozen",true,true,"Frozen");
                        break;
                     case "attacker_blind":
                     case "blind_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"blind",true,true,"Blind");
                        break;
                     case "attacker_poison":
                     case "poison_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"poison",true,true,"Poison");
                        break;
                     case "attacker_slow":
                     case "slow_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"slow",true,true,"Slow");
                        break;
                     case "attacker_burn":
                     case "burn_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"burn",true,false,"Burn");
                        break;
                     case "attacker_bleeding":
                     case "bleeding_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"bleeding",true,false,"Bleeding");
                        break;
                     case "attacker_numb":
                     case "numb_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"numb",true,false,"Numb");
                        break;
                     case "attacker_weaken":
                     case "weaken_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"weaken",true,false,"Weaken");
                        break;
                     case "attacker_concentration":
                     case "concentration_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param1,_loc16_,_loc15_,_loc17_,_loc18_,"concentration",false,false,"Concentration");
                        break;
                     case "absorb_attacker_hp_present":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"insta_drain_hp",true,true,"Drain HP");
                        break;
                     case "absorb_hp_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param1,_loc16_,_loc15_,_loc17_,_loc18_,"insta_drain_hp",true,true,"Absorb HP");
                        break;
                     case "absorb_cp_attacker":
                        this.checkPassiveEffectToActiveAfterBeingHit(param1,_loc16_,_loc15_,_loc17_,_loc18_,"insta_drain_cp",true,true,"Absorb CP");
                        break;
                     case "stubborn_recover_cp":
                        this.checkPassiveEffectToActiveAfterBeingHit(param2,_loc16_,_loc15_,_loc17_,_loc18_,"instant_cp_recover",true,false,"CP +");
                        break;
                  }
                  _loc13_++;
               }
               _loc11_++;
            }
         }
      }
      
      public function checkPassiveEffectToActiveAfterBeingHit(param1:*, param2:int, param3:int, param4:int, param5:String, param6:String, param7:Boolean = true, param8:Boolean = false, param9:String = "", param10:Boolean = false, param11:Boolean = false) : *
      {
         var _loc12_:Object = null;
         var _loc13_:int = NumberUtil.getRandomInt();
         if(param2 >= _loc13_)
         {
            _loc12_ = {
               "passive":param10,
               "type":(!!param7 ? "Debuff" : "Buff"),
               "target":(!!param7 ? "enemy" : "player"),
               "effect":param6,
               "amount":param4,
               "amount_hp":param4,
               "amount_cp":param4,
               "amount_prc":param4,
               "amount_protection":param4,
               "duration":param3,
               "calc_type":param5,
               "switch_att_def":param8,
               "effect_name":param9,
               "reduce_type":"MAX",
               "no_disperse":false
            };
            if(param7)
            {
               param1.effects_manager.addDebuff(_loc12_);
            }
            if(!param7)
            {
               param1.effects_manager.addBuff(_loc12_);
            }
         }
      }
      
      public function getCanBeEffectForEffectName(param1:String) : Array
      {
         if(param1 == "dodge")
         {
            return ["increase_dodge","dodge_increase"];
         }
         if(param1 == "accuracy")
         {
            return ["increase_accuracy","accuracy_increase","aqua_regia"];
         }
         if(param1 == "critical")
         {
            return ["increase_critical","critical_increase"];
         }
         if(param1 == "agility")
         {
            return ["increase_agility","agility_increase"];
         }
         if(param1 == "purify")
         {
            return ["increase_purify","purify_increase","aqua_regia"];
         }
         if(param1 == "combustion")
         {
            return ["increase_combustion","combustion_increase"];
         }
         if(param1 == "reactive_force")
         {
            return ["increase_reactive","reactive_increase","weapon_reactive_force","reflect"];
         }
         if(param1 == "cp_costing")
         {
            return ["reduce_cp_cost"];
         }
         return [];
      }
      
      public function getCanBeEffectForDebuffEffectName(param1:String) : Array
      {
         if(param1 == "dodge")
         {
            return ["decrease_dodge","dodge_decrease"];
         }
         if(param1 == "accuracy")
         {
            return ["decrease_accuracy","accuracy_decrease"];
         }
         if(param1 == "critical")
         {
            return ["decrease_critical","critical_decrease"];
         }
         if(param1 == "agility")
         {
            return ["decrease_agility","agility_decrease"];
         }
         if(param1 == "purify")
         {
            return ["decrease_purify","purify_decrease"];
         }
         if(param1 == "comubstion")
         {
            return ["decrease_combustion","combustion_decrease"];
         }
         if(param1 == "reactive_force")
         {
            return ["decrease_reactive","reactive_decrease"];
         }
         return [];
      }
      
      public function getEquippedSetForEffects(param1:String, param2:Boolean = true) : Array
      {
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc3_:Array = this.getAllCharacterSetEffects();
         var _loc4_:Array = this.getCanBeEffectForDebuffEffectName(param1);
         if(param2)
         {
            _loc4_ = this.getCanBeEffectForEffectName(param1);
         }
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc7_];
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               for each(_loc9_ in _loc4_)
               {
                  if(_loc5_[_loc8_].effect == _loc9_)
                  {
                     _loc6_.push(_loc5_[_loc8_]);
                  }
               }
               _loc8_++;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      public function checkRecoverHpIfUserIsUnderBloodlust() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = BattleManager.getBattle().getAttacker();
         var _loc3_:* = BattleManager.getBattle().getDefender();
         var _loc4_:*;
         if((_loc4_ = _loc3_.effects_manager.getEffect("bloodlust")).duration > 0)
         {
            if(_loc4_.next_turn == true)
            {
               _loc4_.next_turn = false;
               return;
            }
            if((_loc1_ = Math.floor(_loc4_.amount * BattleManager.getTotalDamage() / 100)) > 0)
            {
               _loc2_.health_manager.addHealth(_loc1_,"BloodlustMC ");
            }
         }
      }
      
      public function checkForIncreasePurifyFromHPPercentage() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:*;
         if(!(_loc4_ = this.getCurrentModel()).isCharacter())
         {
            return _loc1_;
         }
         _loc2_ = int(_loc4_.health_manager.getMaxCP());
         _loc3_ = int(_loc4_.health_manager.getCurrentCP());
         var _loc5_:* = _loc3_ <= _loc2_ / 2;
         if(_loc4_.effects_manager.hadEffect("cp_shield_and_increase_purify") && _loc5_)
         {
            _loc1_ += 100;
         }
         return _loc1_;
      }
      
      public function checkKekkaiReduceHpCp() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Object;
         var _loc5_:*;
         if((_loc6_ = (_loc5_ = BattleManager.getBattle().getDefender()).effects_manager.getEffect("kekkai")).duration > 0)
         {
            _loc1_ = int(_loc5_.health_manager.getMaxHP());
            _loc2_ = int(_loc5_.health_manager.getMaxCP());
            _loc3_ = Math.floor(_loc1_ * _loc6_.amount / 100);
            _loc4_ = Math.floor(_loc2_ * _loc6_.amount / 100);
            if(_loc3_ > 0)
            {
               _loc5_.health_manager.reduceHealth(_loc3_,"Kekkai HP -");
            }
            if(_loc4_ > 0)
            {
               _loc5_.health_manager.reduceCP(_loc4_,"Kekkai CP -");
            }
         }
      }
      
      public function checkCapture() : *
      {
         var _loc6_:Object = null;
         var _loc1_:* = BattleManager.getBattle().getDefender();
         var _loc2_:* = BattleManager.getBattle().getAttacker();
         var _loc3_:Object = _loc2_.effects_manager.getCaptureChanceFromSilhouette();
         var _loc4_:int = NumberUtil.getRandomInt();
         var _loc5_:Boolean = this.hasDebuffResist(_loc1_);
         if(_loc3_.chance >= _loc4_ && !_loc5_)
         {
            _loc6_ = {
               "effect":"capture",
               "amount":_loc3_.amount,
               "duration":_loc3_.duration - 1,
               "calc_type":"percent"
            };
            _loc1_.effects_manager.addDebuff(_loc6_);
         }
      }
      
      public function checkLavaShield() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc1_:Object = BattleManager.getBattle().getDefender();
         var _loc2_:Object = BattleManager.getBattle().getAttacker();
         if(_loc1_.effects_manager.hadEffect("lava_shield"))
         {
            _loc3_ = new Object();
            _loc3_.effect = "fire_faint";
            _loc3_.duration = 2;
            _loc3_.calc_type = "percent";
            _loc3_.amount = _loc1_.effects_manager.getEffect("lava_shield").amount;
            _loc2_.effects_manager.addDebuff(_loc3_);
            (_loc4_ = new Object()).effect = "earth_faint";
            _loc4_.duration = 2;
            _loc4_.calc_type = "percent";
            _loc4_.amount = _loc1_.effects_manager.getEffect("lava_shield").amount;
            _loc2_.effects_manager.addDebuff(_loc4_);
            (_loc5_ = new Object()).effect = "numb";
            _loc5_.duration = 3;
            _loc5_.calc_type = "number";
            _loc5_.amount = _loc1_.effects_manager.getEffect("lava_shield").amount_numb;
            _loc2_.effects_manager.addDebuff(_loc5_);
         }
      }
      
      public function checkReduceWindCD() : *
      {
         var _loc1_:* = BattleManager.getBattle().getDefender();
         var _loc2_:Object = _loc1_.effects_manager.getEffect("reduce_wind_cd");
         if(_loc2_.duration > 0)
         {
            _loc1_.actions_manager.reduceElementSkillsCD(_loc2_.amount,1);
            Effects.showEffectInfo(this.user_team,this.user_number,"Reduce Wind CD " + _loc2_.amount);
         }
      }
      
      public function checkRecoverEnemyHPAfterDidDamage() : void
      {
         var _loc1_:Object = BattleManager.getBattle().getAttacker();
         var _loc2_:Object = _loc1_.effects_manager;
         var _loc3_:int = 0;
         if(_loc2_.hadEffect("bloodfeed") || _loc2_.hadEffect("pet_bloodfeed"))
         {
            _loc3_ += Math.floor(BattleManager.getTotalDamage() * _loc2_.getEffect("bloodfeed").amount / 100);
         }
         if(_loc2_.hadEffect("kyubi_cloak"))
         {
            _loc3_ += Math.floor(BattleManager.getTotalDamage() * _loc2_.getEffect("kyubi_cloak").amount_bloodfeed / 100);
         }
         if(_loc3_ > 0)
         {
            _loc1_.health_manager.addHealth(_loc3_,"BloodfeedMC ");
         }
      }
      
      public function checkRecoverHPAfterPurified() : void
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:Object = this.getCurrentModel();
         if(!_loc1_ || !_loc1_.isCharacter())
         {
            return;
         }
         var _loc2_:Array = this.getAllCharacterSetEffects();
         if(!_loc2_ || _loc2_.length == 0)
         {
            return;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc5_ in _loc2_)
         {
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_ && _loc6_.effect == "recover_hp_after_purify")
               {
                  if(_loc6_.calc_type == "number")
                  {
                     _loc4_ += _loc6_.amount;
                  }
                  else
                  {
                     _loc3_ += _loc6_.amount;
                  }
               }
            }
         }
         if((_loc3_ > 0 || _loc4_ > 0) && _loc1_.health_manager)
         {
            _loc7_ = _loc1_.health_manager.getMaxHP();
            _loc8_ = _loc4_ + Math.floor(_loc7_ * _loc3_ / 100);
            _loc1_.health_manager.addHealth(_loc8_,"Recovered HP +");
         }
      }
      
      public function checkRecoverCPAfterPurified() : void
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:Object = this.getCurrentModel();
         if(!_loc1_ || !_loc1_.isCharacter())
         {
            return;
         }
         var _loc2_:Array = this.getAllCharacterSetEffects();
         if(!_loc2_ || _loc2_.length == 0)
         {
            return;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc5_ in _loc2_)
         {
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_ && _loc6_.effect == "recover_cp_after_purify")
               {
                  if(_loc6_.calc_type == "number")
                  {
                     _loc4_ += _loc6_.amount;
                  }
                  else
                  {
                     _loc3_ += _loc6_.amount;
                  }
               }
            }
         }
         if((_loc3_ > 0 || _loc4_ > 0) && _loc1_.health_manager)
         {
            _loc7_ = _loc1_.health_manager.getMaxCP();
            _loc8_ = _loc4_ + Math.floor(_loc7_ * _loc3_ / 100);
            _loc1_.health_manager.addCP(_loc8_,"Recovered CP +");
         }
      }
      
      public function checkStunAfterDidDamage(param1:String = "critical_buff_n_received_stun") : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = BattleManager.getBattle().getAttacker();
         var _loc4_:*;
         var _loc5_:* = (_loc4_ = BattleManager.getBattle().getDefender().effects_manager).getEffect(param1);
         var _loc6_:*;
         if(_loc6_ = _loc4_.hadEffect(param1))
         {
            (_loc2_ = {}).effect = "stun";
            _loc2_.effect_name = "Stun";
            _loc2_.duration_deduct = "after_attack";
            _loc2_.calc_type = "percent";
            _loc2_.reduce_type = "MAX";
            _loc2_.passive = false;
            _loc2_.type = "Debuff";
            _loc2_.target = "enemy";
            _loc2_.switch_att_def = false;
            _loc2_.no_disperse = false;
            _loc2_.amount = _loc5_.amount;
            _loc2_.amount_hp = _loc5_.amount;
            _loc2_.amount_cp = _loc5_.amount;
            _loc2_.amount_protection = "amount_protection" in _loc5_ ? _loc5_.amount_protection : _loc5_.amount;
            _loc2_.amount_prc = _loc5_.amount;
            _loc2_.duration = 1;
            _loc3_.effects_manager.addDebuff(_loc2_);
         }
      }
      
      public function checkBurnAfterDidDamage(param1:String = "fire_wall") : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = BattleManager.getBattle().getAttacker();
         var _loc4_:*;
         var _loc5_:* = (_loc4_ = BattleManager.getBattle().getDefender().effects_manager).getEffect(param1);
         var _loc6_:*;
         if(_loc6_ = _loc4_.hadEffect(param1))
         {
            (_loc2_ = {}).effect = "fire_wall_burn";
            _loc2_.effect_name = "Burn";
            _loc2_.duration_deduct = "after_attack";
            _loc2_.calc_type = "percent";
            _loc2_.reduce_type = "MAX";
            _loc2_.passive = false;
            _loc2_.type = "Debuff";
            _loc2_.target = "enemy";
            _loc2_.switch_att_def = false;
            _loc2_.no_disperse = false;
            _loc2_.amount = _loc5_.amount;
            _loc2_.amount_hp = _loc5_.amount;
            _loc2_.amount_cp = _loc5_.amount;
            _loc2_.amount_protection = "amount_protection" in _loc5_ ? _loc5_.amount_protection : _loc5_.amount;
            _loc2_.amount_prc = _loc5_.amount;
            _loc2_.duration = _loc5_.amount_duration;
            _loc3_.effects_manager.addDebuff(_loc2_);
         }
         if(param1 == "fire_wall")
         {
            this.checkBurnAfterDidDamage("pet_fire_wall");
         }
      }
      
      public function checkBleedingAfterDidDamage(param1:String = "attacker_bleeding") : void
      {
         var _loc7_:Object = null;
         var _loc2_:Object = BattleManager.getBattle();
         var _loc3_:Object = _loc2_.getAttacker();
         var _loc6_:Object;
         var _loc5_:Object;
         var _loc4_:Object;
         if((_loc6_ = (_loc5_ = (_loc4_ = _loc2_.getDefender()).effects_manager).getEffect(param1)) && _loc6_.duration > 0)
         {
            _loc7_ = {
               "effect":"bleeding",
               "effect_name":"bleeding",
               "duration_deduct":"after_attack",
               "calc_type":"percent",
               "reduce_type":"MAX",
               "passive":false,
               "type":"Debuff",
               "target":"enemy",
               "switch_att_def":false,
               "no_disperse":false,
               "amount":_loc6_.amount,
               "amount_hp":("amount_hp" in _loc6_ ? _loc6_.amount_hp : 0),
               "amount_cp":("amount_cp" in _loc6_ ? _loc6_.amount_cp : 0),
               "amount_protection":("amount_protection" in _loc6_ ? _loc6_.amount_protection : 0),
               "amount_prc":("amount_prc" in _loc6_ ? _loc6_.amount_prc : 0),
               "duration":_loc6_.amount_duration
            };
            _loc3_.effects_manager.addDebuff(_loc7_);
         }
         if(param1 == "attacker_bleeding")
         {
            this.checkBleedingAfterDidDamage("pet_attacker_bleeding");
         }
      }
      
      public function checkBurnAfterCritical(param1:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc2_:Object = BattleManager.getBattle().getAttacker();
         if(!_loc2_.isCharacter())
         {
            return;
         }
         var _loc3_:Array = _loc2_.effects_manager.getAllCharacterSetEffects();
         for each(_loc4_ in _loc3_)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.effect == "hemorrhage")
               {
                  param1.effects_manager.addDebuff(_loc5_);
                  return;
               }
            }
         }
      }
      
      public function checkStunAfterCritical(param1:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc2_:Object = BattleManager.getBattle().getAttacker();
         if(!_loc2_.isCharacter())
         {
            return;
         }
         var _loc3_:Array = _loc2_.effects_manager.getAllCharacterSetEffects();
         for each(_loc4_ in _loc3_)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.effect == "stun_when_crit")
               {
                  this.checkPassiveEffectToActiveAfterBeingHit(param1,100,1,_loc5_.amount,"","stun",true,true,"Stun",false,false);
                  return;
               }
            }
         }
      }
      
      public function checkConcentrationAfterCritical(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         if(!param1.isCharacter())
         {
            return;
         }
         var _loc2_:Array = param1.effects_manager.getAllCharacterSetEffects();
         for each(_loc3_ in _loc2_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.effect == "concentration_when_crit")
               {
                  this.checkPassiveEffectToActiveAfterBeingHit(param1,100,_loc4_.duration,_loc4_.amount,"","concentration",false,true,"Concentration",false,false);
                  return;
               }
            }
         }
      }
      
      public function checkRecoverHPAfterCritical(param1:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         if(!param1.isCharacter())
         {
            return;
         }
         var _loc2_:Array = param1.effects_manager.getAllCharacterSetEffects();
         var _loc3_:Number = param1.health_manager.getMaxHP();
         for each(_loc4_ in _loc2_)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.effect == "recover_hp_after_critical")
               {
                  _loc6_ = _loc5_.calc_type == "percent" ? Number(Math.floor(_loc3_ * _loc5_.amount / 100)) : Number(_loc5_.amount);
                  param1.health_manager.addHealth(_loc6_);
                  return;
               }
            }
         }
      }
      
      public function checkRecoverHPAfterReceivedCritical(param1:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(!param1.isCharacter())
         {
            return;
         }
         var _loc2_:Array = param1.effects_manager.getAllCharacterSetEffects();
         var _loc3_:Number = param1.health_manager.getMaxHP();
         for each(_loc4_ in _loc2_)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.effect == "recover_hp_after_received_critical")
               {
                  _loc6_ = "chance" in _loc5_ ? int(int(_loc5_.chance)) : 100;
                  _loc7_ = NumberUtil.getRandomInt();
                  if(_loc6_ >= _loc7_)
                  {
                     _loc8_ = _loc5_.calc_type == "percent" ? Number(Math.floor(_loc3_ * _loc5_.amount / 100)) : Number(_loc5_.amount);
                     param1.health_manager.addHealth(_loc8_,"Recovered HP +");
                  }
                  continue;
                  return;
               }
            }
         }
      }
      
      public function checkDisorientAttacker(param1:String = "attacker_disorient") : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = BattleManager.getBattle().getAttacker();
         var _loc4_:*;
         var _loc5_:* = (_loc4_ = BattleManager.getBattle().getDefender().effects_manager).getEffect(param1);
         var _loc6_:* = _loc4_.hadEffect(param1);
         var _loc7_:int = 0;
         if(_loc6_)
         {
            (_loc2_ = {}).effect = "disorient_2";
            _loc2_.effect_name = "Disorient";
            _loc2_.duration_deduct = "after_attack";
            _loc2_.calc_type = "percent";
            _loc2_.reduce_type = "MAX";
            _loc2_.passive = false;
            _loc2_.type = "Debuff";
            _loc2_.target = "enemy";
            _loc2_.switch_att_def = false;
            _loc2_.no_disperse = false;
            _loc2_.amount = _loc5_.amount;
            _loc2_.amount_hp = _loc5_.amount;
            _loc2_.amount_cp = _loc5_.amount;
            _loc2_.amount_protection = 0;
            _loc2_.amount_prc = _loc5_.amount;
            _loc2_.duration = _loc5_.amount_duration;
            _loc2_.chance = "chance" in _loc5_ ? _loc5_.chance : 100;
            _loc7_ = NumberUtil.getRandomInt();
            if(_loc2_.chance >= _loc7_)
            {
               _loc3_.effects_manager.addDebuff(_loc2_);
            }
         }
      }
      
      public function resolveDrainCaster(param1:Object) : Object
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1.from_team == null || param1.from_number == null)
         {
            return null;
         }
         var _loc2_:* = BattleManager.getBattle().getObjectHolder(param1.from_team,param1.from_number);
         if(_loc2_ == null || _loc2_.charMc == null || _loc2_.charMc.character_model == null)
         {
            return null;
         }
         return _loc2_.charMc.character_model;
      }
      
      public function checkTheft(param1:String = "theft") : void
      {
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = BattleManager.getBattle().getAttacker();
         var _loc5_:Object = this.getCurrentModel();
         var _loc6_:Object = _loc4_.effects_manager.getEffect(param1);
         var _loc7_:* = param1 + "_mode";
         if(_loc6_.duration > 0)
         {
            _loc2_ = NumberUtil.getRandomInt();
            if(_loc6_.chance >= _loc2_)
            {
               _loc8_ = int(_loc4_.health_manager.getMaxHP());
               _loc3_ += _loc6_.amount;
               if(_loc6_.calc_type == "percent")
               {
                  _loc3_ = Math.floor(_loc3_ * _loc8_ / 100);
               }
               if(!_loc4_[_loc7_])
               {
                  _loc4_.health_manager.reduceHealth(_loc3_,_loc6_.effect_name + " -");
                  _loc4_[_loc7_] = true;
               }
               _loc5_.health_manager.addHealth(_loc3_,_loc6_.effect_name + " +");
            }
         }
      }
      
      public function checkAoeDamage(param1:String, param2:int) : void
      {
         var _loc7_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Object;
         var _loc5_:Object;
         if((_loc6_ = (_loc5_ = this.getCurrentModel()).effects_manager.getEffect(param1)).duration > 0)
         {
            _loc3_ = NumberUtil.getRandomInt();
            if(_loc6_.chance >= _loc3_)
            {
               if(param2 >= 2)
               {
                  _loc7_ = int(_loc5_.health_manager.getMaxHP());
                  _loc4_ = _loc6_.amount * param2;
                  if(_loc6_.calc_type == "percent")
                  {
                     _loc4_ = Math.floor(_loc4_ * _loc7_ / 100);
                  }
                  _loc5_.health_manager.reduceHealth(_loc4_,_loc6_.effect_name + " -");
               }
            }
         }
      }
      
      public function checkAoeAttackerDamage(param1:String, param2:int) : int
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Object;
         var _loc5_:Object;
         if((_loc6_ = (_loc5_ = this.getCurrentModel()).effects_manager.getEffect(param1)).duration > 0)
         {
            _loc3_ = NumberUtil.getRandomInt();
            if(_loc6_.chance >= _loc3_)
            {
               _loc7_ = int(_loc5_.health_manager.getMaxHP());
               _loc4_ = _loc6_.amount * param2;
               if(_loc6_.calc_type == "percent")
               {
                  _loc4_ = Math.floor(_loc4_ * _loc7_ / 100);
               }
               if(_loc4_ <= 0)
               {
                  return 0;
               }
               _loc8_ = int(_loc5_.health_manager.getCurrentHP());
               _loc5_.health_manager.reduceHealth(_loc4_,_loc6_.effect_name + " -");
               return int(_loc8_ - int(_loc5_.health_manager.getCurrentHP()));
            }
         }
         return 0;
      }
      
      public function checkWeaponAttackPenalty() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:Object = this.getCurrentModel();
         var _loc2_:Object = _loc1_.effects_manager.getEffect("weapon_attack_penalty");
         if(_loc2_.duration > 0)
         {
            _loc3_ = _loc1_.health_manager.getMaxHP();
            _loc4_ = _loc1_.health_manager.getMaxCP();
            _loc5_ = 0;
            _loc6_ = 0;
            if(_loc2_.calc_type == "percent")
            {
               _loc5_ = Math.floor(_loc2_.amount * _loc3_ / 100);
               _loc6_ = Math.floor(_loc2_.amount * _loc4_ / 100);
            }
            else
            {
               _loc5_ = _loc2_.amount;
               _loc6_ = _loc2_.amount;
            }
            if(_loc5_ > 0)
            {
               _loc1_.health_manager.reduceHealth(_loc5_,_loc2_.effect_name + " -");
            }
            if(_loc6_ > 0)
            {
               _loc1_.health_manager.reduceCP(_loc6_,_loc2_.effect_name + " -");
            }
         }
      }
      
      public function checkReduceHPAttacker(param1:String = "reduce_hp_attacker") : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = BattleManager.getBattle().getAttacker();
         var _loc4_:*;
         var _loc5_:* = (_loc4_ = BattleManager.getBattle().getDefender().effects_manager).getEffect(param1);
         var _loc6_:* = _loc4_.hadEffect(param1);
         var _loc7_:int = 0;
         if(_loc6_)
         {
            (_loc2_ = {}).effect = "reduce_hp";
            _loc2_.effect_name = "Reduce HP";
            _loc2_.duration_deduct = "immediately";
            _loc2_.calc_type = _loc5_.calc_type;
            _loc2_.reduce_type = "MAX";
            _loc2_.passive = false;
            _loc2_.type = "Debuff";
            _loc2_.target = "enemy";
            _loc2_.switch_att_def = false;
            _loc2_.no_disperse = false;
            _loc2_.amount = _loc5_.amount;
            _loc2_.amount_hp = _loc5_.amount;
            _loc2_.amount_cp = _loc5_.amount;
            _loc2_.amount_protection = 0;
            _loc2_.amount_prc = _loc5_.amount;
            _loc2_.duration = _loc5_.amount_duration;
            _loc2_.chance = "chance" in _loc5_ ? _loc5_.chance : 100;
            _loc7_ = NumberUtil.getRandomInt();
            if(_loc2_.chance >= _loc7_)
            {
               _loc3_.effects_manager.addDebuff(_loc2_);
            }
         }
      }
      
      public function checkSlowAttacker(param1:String = "slow_attacker") : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = BattleManager.getBattle().getAttacker();
         var _loc4_:*;
         var _loc5_:* = (_loc4_ = BattleManager.getBattle().getDefender().effects_manager).getEffect(param1);
         var _loc6_:* = _loc4_.hadEffect(param1);
         var _loc7_:int = 0;
         if(_loc6_)
         {
            (_loc2_ = {}).effect = "slow";
            _loc2_.effect_name = "Slow";
            _loc2_.duration_deduct = "immediately";
            _loc2_.calc_type = _loc5_.calc_type;
            _loc2_.reduce_type = "MAX";
            _loc2_.passive = false;
            _loc2_.type = "Debuff";
            _loc2_.target = "enemy";
            _loc2_.switch_att_def = false;
            _loc2_.no_disperse = false;
            _loc2_.amount = _loc5_.amount;
            _loc2_.amount_hp = _loc5_.amount;
            _loc2_.amount_cp = _loc5_.amount;
            _loc2_.amount_protection = 0;
            _loc2_.amount_prc = _loc5_.amount;
            _loc2_.duration = _loc5_.amount_duration;
            _loc2_.chance = "chance" in _loc5_ ? _loc5_.chance : 100;
            _loc7_ = NumberUtil.getRandomInt();
            if(_loc2_.chance >= _loc7_)
            {
               _loc3_.effects_manager.addDebuff(_loc2_);
            }
         }
      }
      
      public function checkStrengthenAfterDodgedTheAttack() : *
      {
         var _loc1_:Array = null;
         var _loc2_:Array = this.getAllCharacterSetEffects();
         var _loc3_:Object = {};
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc1_ = _loc2_[_loc5_];
            _loc4_ = 0;
            while(_loc4_ < _loc1_.length)
            {
               if(_loc1_[_loc4_].effect == "dodge_damage_bonus")
               {
                  _loc3_.effect = "power_up";
                  _loc3_.type = "Buff";
                  _loc3_.target = "self";
                  _loc3_.effect_name = "Strengthen";
                  _loc3_.duration_deduct = "after_attack";
                  _loc3_.amount = _loc1_[_loc4_].amount;
                  _loc3_.duration = _loc1_[_loc4_].duration;
                  _loc3_.calc_type = "percent";
                  _loc3_.chance = 100;
                  _loc3_.effect_description = "Increase all attack damage by x% for y turns.";
               }
               _loc4_++;
            }
            _loc5_++;
         }
         if(_loc3_.effect)
         {
            this.addBuff(_loc3_);
         }
      }
      
      public function checkAbsorbDamage(param1:Object, param2:int) : int
      {
         if(param2 < 0)
         {
            return 0;
         }
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:Array = this.getAllCharacterSetEffects();
         var _loc6_:int = NumberUtil.getRandomInt();
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         while(_loc8_ < _loc5_.length)
         {
            _loc3_ = _loc5_[_loc8_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].effect == "absorb_damage_to_hp")
               {
                  if(_loc3_[_loc4_].chance >= _loc6_)
                  {
                     if(_loc3_[_loc4_].calc_type == "percent")
                     {
                        _loc7_ += Math.floor(param2 * _loc3_[_loc4_].amount / 100);
                     }
                     else
                     {
                        _loc7_ += int(_loc3_[_loc4_].amount);
                     }
                     param1.health_manager.addHealth(_loc7_,"Absorb HP +");
                  }
               }
               _loc4_++;
            }
            _loc8_++;
         }
         var _loc9_:*;
         if((_loc9_ = param2 - _loc7_) == 0)
         {
            BattleVars.SHOW_DAMAGE_ZERO = true;
         }
         return _loc9_;
      }
      
      public function checkDamageToHealth(param1:*, param2:int) : *
      {
         if(param2 < 0)
         {
            param2 = 0;
         }
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:Array = this.getAllCharacterSetEffects();
         var _loc6_:int = NumberUtil.getRandomInt();
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         while(_loc8_ < _loc5_.length)
         {
            _loc3_ = _loc5_[_loc8_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].effect == "absorb_damage_to_hp")
               {
                  if(_loc3_[_loc4_].chance >= _loc6_)
                  {
                     if(_loc3_[_loc4_].calc_type == "percent")
                     {
                        _loc7_ += Math.floor(_loc3_[_loc4_].amount * param2 / 100);
                     }
                     else
                     {
                        _loc7_ += int(_loc3_[_loc4_].amount);
                     }
                     param1.health_manager.addHealth(_loc7_,"Absorb HP +");
                  }
               }
               _loc4_++;
            }
            _loc8_++;
         }
      }
      
      public function checkDamageToCP(param1:*, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:Array = this.getAllCharacterSetEffects();
         var _loc6_:int = NumberUtil.getRandomInt();
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         while(_loc8_ < _loc5_.length)
         {
            _loc3_ = _loc5_[_loc8_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].effect == "absorb_damage_to_cp" || _loc3_[_loc4_].effect == "convert_damage_taken_cp")
               {
                  if(_loc3_[_loc4_].chance >= _loc6_)
                  {
                     if(_loc3_[_loc4_].calc_type == "percent")
                     {
                        _loc7_ += Math.floor(_loc3_[_loc4_].amount * param2 / 100);
                     }
                     else
                     {
                        _loc7_ += int(_loc3_[_loc4_].amount);
                     }
                     param1.health_manager.addCP(_loc7_,"Recover CP +");
                  }
               }
               _loc4_++;
            }
            _loc8_++;
         }
      }
      
      public function checkConsumeCPToHealth(param1:HealthManager, param2:int) : *
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:Array = this.getAllCharacterSetEffects();
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         while(_loc7_ < _loc5_.length)
         {
            _loc3_ = _loc5_[_loc7_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].effect == "cp_consume_to_hp" || _loc3_[_loc4_].effect == "recover_hp_by_cp_cost")
               {
                  if(_loc3_[_loc4_].calc_type == "percent")
                  {
                     _loc6_ += Math.floor(_loc3_[_loc4_].amount * param2 / 100);
                  }
                  else
                  {
                     _loc6_ += int(_loc3_[_loc4_].amount);
                  }
                  param1.addHealth(_loc6_,"CP Consume HP +");
               }
               _loc4_++;
            }
            _loc7_++;
         }
      }
      
      public function wakePlayer() : *
      {
         this.getEffect("sleep").duration = 0;
         this.getEffect("pet_sleep").duration = 0;
      }
      
      public function hasDebuffResist(param1:*) : Boolean
      {
         if(Boolean(param1.effects_manager.hadEffect("unyielding")) || Boolean(param1.effects_manager.hadEffect("debuff_resist")) || Boolean(param1.effects_manager.hadEffect("pet_debuff_resist")))
         {
            return true;
         }
         return false;
      }
      
      public function checkRandomBuff() : void
      {
         var _loc1_:Object = BattleManager.getBattle().getAttacker();
         if(this.hadEffect("negate"))
         {
            _loc1_.health_manager.createDisplay("Buff Negated");
            return;
         }
         var _loc2_:Array = ["power_up","protection","attention","energize","peace","concentration","flexible"];
         var _loc3_:Array = ["Strengthen","Protection","Attention","Energize","Peace","Concentration","Flexibility"];
         var _loc4_:int = NumberUtil.randomInt(0,_loc2_.length - 1);
         var _loc5_:String = _loc2_[_loc4_];
         var _loc6_:Object = {
            "effect":_loc5_,
            "duration":(_loc5_ == "peace" ? NumberUtil.randomInt(2,8) : NumberUtil.randomInt(1,7)),
            "amount":NumberUtil.randomInt(7,77),
            "calc_type":"percent"
         };
         _loc1_.effects_manager.addBuff(_loc6_);
         _loc1_.health_manager.createDisplay(_loc3_[_loc4_] + " " + _loc6_.amount + "% " + _loc6_.duration + " turn");
      }
      
      public function checkRandomLock() : *
      {
         var _loc1_:Object = this.hadEffect("random_debuff");
         var _loc2_:Object = this.getEffect("random_debuff");
         if(!_loc1_)
         {
            return;
         }
         var _loc3_:Object = BattleManager.getBattle().getAttacker();
         if(this.hasDebuffResist(_loc3_))
         {
            Effects.showEffectResisted(_loc3_.getPlayerTeam(),_loc3_.getPlayerNumber());
            return;
         }
         var _loc4_:Array = ["stun","restriction","meridian_seal","sleep"];
         var _loc5_:Array = ["Stun","Restriction","Meridian Seal","Sleep"];
         var _loc6_:int = NumberUtil.randomInt(0,_loc4_.length - 1);
         var _loc7_:String = _loc4_[_loc6_];
         var _loc8_:Object = {
            "effect":_loc7_,
            "duration":_loc2_.amount
         };
         _loc3_.effects_manager.addDebuff(_loc8_);
      }
      
      public function checkRandomS16(param1:Object) : *
      {
         var _loc2_:Object = this.getCurrentModel();
         var _loc3_:Object = BattleManager.getBattle().getDefender();
         if(this.hasDebuffResist(_loc2_))
         {
            Effects.showEffectResisted(_loc3_.getPlayerTeam(),_loc3_.getPlayerNumber());
            return;
         }
         var _loc4_:Array = ["stun","barrier","chaos"];
         var _loc5_:Array = ["Stun","Barrier","Chaos"];
         var _loc6_:int = NumberUtil.randomInt(0,_loc4_.length - 1);
         var _loc7_:String = _loc4_[_loc6_];
         var _loc8_:Object = {
            "effect":_loc7_,
            "duration":param1.amount
         };
         _loc2_.effects_manager.addDebuff(_loc8_);
      }
      
      private function handleSacrificeHPRandomBuff(param1:Object, param2:Object) : void
      {
         var _loc3_:int = "sacrifice_amount" in param2 && param2.sacrifice_amount > 0 ? int(int(param2.sacrifice_amount)) : 30;
         var _loc4_:int = int(param1.health_manager.getCurrentHP());
         var _loc5_:int = int(param1.health_manager.getMaxHP());
         var _loc6_:int;
         if((_loc6_ = Math.floor(_loc5_ * _loc3_ / 100)) >= _loc4_)
         {
            _loc6_ = _loc4_ - 1;
         }
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         param1.health_manager.reduceHealth(_loc6_,"Sacrifice -");
         var _loc7_:int = NumberUtil.randomInt(0,2);
         var _loc8_:int = param2.duration > 0 ? int(int(param2.duration)) : 3;
         var _loc9_:int = param2.amount > 0 ? int(int(param2.amount)) : 50;
         switch(_loc7_)
         {
            case 0:
               param1.effects_manager.addBuff({
                  "effect":"critical_percent",
                  "effect_name":"Critical",
                  "duration":_loc8_,
                  "calc_type":"percent",
                  "amount":_loc9_,
                  "chance":100
               });
               break;
            case 1:
               param1.effects_manager.addBuff({
                  "effect":"accuracy_percent",
                  "effect_name":"Accuracy",
                  "duration":_loc8_,
                  "calc_type":"percent",
                  "amount":_loc9_,
                  "chance":100
               });
               break;
            case 2:
               param1.effects_manager.addBuff({
                  "effect":"reflexes",
                  "effect_name":"Reflexes",
                  "duration":_loc8_,
                  "calc_type":"percent",
                  "amount":_loc9_,
                  "chance":100
               });
         }
      }
      
      private function capitalizeFirstLetter(param1:String) : String
      {
         return param1.charAt(0).toUpperCase() + param1.slice(1);
      }
      
      public function checkDeductAttackerCP() : *
      {
         var _loc1_:* = BattleManager.getBattle().getAttacker();
         var _loc2_:* = BattleManager.getBattle().getDefender();
         var _loc3_:int = int(_loc1_.health_manager.getMaxCP());
         var _loc4_:int = 0;
         if(_loc2_.effects_manager.hadEffect("reduce_attacker_cp"))
         {
            _loc4_ += Math.floor(_loc3_ * _loc2_.effects_manager.getEffect("reduce_attacker_cp").amount_cp / 100);
         }
         if(_loc2_.effects_manager.hadEffect("dec_cp_attacker"))
         {
            _loc4_ += Math.floor(_loc3_ * _loc2_.effects_manager.getEffect("dec_cp_attacker").amount / 100);
         }
         if(_loc1_.effects_manager.hadEffect("conduction"))
         {
            _loc4_ += Math.floor(_loc3_ * _loc1_.effects_manager.getEffect("conduction").amount / 100);
         }
         if(_loc1_.effects_manager.hadEffect("pet_conduction"))
         {
            _loc4_ += Math.floor(_loc3_ * _loc1_.effects_manager.getEffect("pet_conduction").amount / 100);
         }
         if(_loc4_ > 0)
         {
            _loc1_.health_manager.reduceCP(_loc4_,"Reduce CP -");
         }
      }
      
      public function checkInstantDeductAttackerHP() : *
      {
         var _loc4_:Object = null;
         var _loc1_:Object = BattleManager.getBattle().getAttacker();
         var _loc2_:Object = BattleManager.getBattle().getDefender();
         var _loc3_:int = 0;
         if(_loc2_.effects_manager.hadEffect("instant_reduce_hp_attacker"))
         {
            _loc4_ = _loc2_.effects_manager.getEffect("instant_reduce_hp_attacker");
            _loc3_ += _loc4_.amount;
            if(_loc4_.calc_type == "percent")
            {
               _loc3_ += Math.floor(_loc1_.health_manager.getMaxHP() * _loc3_ / 100);
            }
         }
         if(_loc3_ > 0)
         {
            _loc1_.health_manager.reduceHealth(_loc3_,"Reduce HP -");
         }
      }
      
      public function getIncreaseCriticalByPassiveEffects(param1:String) : Number
      {
         var _loc7_:* = undefined;
         var _loc2_:Array = [];
         var _loc3_:Array = this.getAllCharacterSetEffects();
         var _loc4_:Number = 0;
         var _loc5_:Array = ["attacker_critical_damage_bonus","mortal"];
         var _loc6_:* = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc6_];
            _loc7_ = 0;
            while(_loc7_ < _loc2_.length)
            {
               if(Util.in_array(_loc2_[_loc7_].effect,_loc5_))
               {
                  if(_loc2_[_loc7_].calc_type == param1)
                  {
                     _loc4_ += Math.floor(_loc2_[_loc7_].amount);
                  }
               }
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc4_;
      }
      
      public function noCPCostFromTalent() : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc1_:Object = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return false;
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1057"))
         {
            _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1057",_loc1_.character_manager.getTalentLevel("skill_1057")).chance;
            if(_loc2_ >= NumberUtil.getRandomInt())
            {
               _loc1_.health_manager.createDisplay("Future Vision");
               return true;
            }
         }
         return false;
      }
      
      public function getCooldownReduceFromTalent(param1:String) : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc2_:Object = this.getCurrentModel();
         var _loc3_:Boolean = false;
         if(!_loc2_.isCharacter())
         {
            return false;
         }
         if(_loc2_.effects_manager.hasActivePassiveTalent("skill_1057"))
         {
            if((_loc5_ = TalentSkillLevel.getTalentSkillLevels("skill_1057",_loc2_.character_manager.getTalentLevel("skill_1057")).cooldown_chance) >= NumberUtil.getRandomInt())
            {
               _loc3_ = true;
            }
         }
         var _loc4_:* = this.checkTempForTalent(param1);
         if(_loc3_ && _loc4_)
         {
            _loc2_.health_manager.createDisplay("Cooldown Reduction");
            return true;
         }
         return false;
      }
      
      public function getCpReductionBySenjutsu() : Number
      {
         var _loc1_:Object = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         var _loc2_:int = 0;
         if(_loc1_.character_manager.hasSenjutsuSkill("skill_3101"))
         {
            _loc2_ += SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3101",_loc1_.character_manager.getSenjutsuLevel("skill_3101")).reduce_cp_cost;
         }
         return Math.round(_loc2_);
      }
      
      public function getCooldownReduceMemekKuda(param1:String) : int
      {
         var _loc2_:* = this.getCurrentModel();
         var _loc3_:int = 0;
         if(!_loc2_.isCharacter())
         {
            return _loc3_;
         }
         var _loc4_:Array = this.getPassiveSenjutsuSkills();
         var _loc5_:Boolean = false;
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_.length)
         {
            if(_loc4_[_loc6_].item_id == "skill_3101")
            {
               _loc3_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3101",_loc2_.character_manager.getSenjutsuLevel("skill_3101")).cooldown_decrease;
               _loc5_ = true;
            }
            _loc6_++;
         }
         var _loc7_:* = this.checkTempForSenjutsu(param1);
         if(_loc5_ && _loc7_)
         {
            _loc2_.health_manager.createDisplay("Cooldown Reduction");
         }
         else
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function checkTempForSenjutsu(param1:*) : Boolean
      {
         var _loc2_:* = this.getCurrentModel();
         var _loc3_:Array = _loc2_.character_manager.getEquippedSkills();
         var _loc4_:Boolean = false;
         var _loc5_:* = 0;
         while(_loc5_ < this.cooldownListFromSenjutsu.length)
         {
            if(this.cooldownListFromSenjutsu[_loc5_] != param1 && !this.tempt_skills_used_for_senjutsu[_loc5_] && this.cooldownListFromSenjutsu.indexOf(param1) < 0)
            {
               _loc4_ = true;
            }
            _loc5_++;
         }
         if(_loc4_)
         {
            this.cooldownListFromSenjutsu.push(param1);
            this.tempt_skills_used_for_senjutsu.push(true);
         }
         return _loc4_;
      }
      
      public function checkTempForTalent(param1:*) : Boolean
      {
         var _loc2_:* = this.getCurrentModel();
         var _loc3_:Array = _loc2_.character_manager.getEquippedSkills();
         var _loc4_:Boolean = false;
         var _loc5_:* = 0;
         while(_loc5_ < this.cooldownListFromTalent.length)
         {
            if(this.cooldownListFromTalent[_loc5_] != param1 && !this.tempt_skills_used_for_talent[_loc5_] && this.cooldownListFromTalent.indexOf(param1) < 0)
            {
               _loc4_ = true;
            }
            _loc5_++;
         }
         if(_loc4_)
         {
            this.cooldownListFromTalent.push(param1);
            this.tempt_skills_used_for_talent.push(true);
         }
         return _loc4_;
      }
      
      public function getIncreaseChargeCPByEquippedSet() : Number
      {
         var _loc6_:* = undefined;
         var _loc1_:Array = null;
         var _loc2_:Array = this.getAllCharacterSetEffects();
         var _loc3_:Number = 0;
         var _loc4_:Array = ["charge_cp_bonus","increase_cp_charge"];
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc1_ = _loc2_[_loc5_];
            _loc6_ = 0;
            while(_loc6_ < _loc1_.length)
            {
               if(Util.in_array(_loc1_[_loc6_].effect,_loc4_))
               {
                  _loc3_ += _loc1_[_loc6_].amount;
               }
               _loc6_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function getIncreaseChargeCPByEffect() : Number
      {
         var _loc3_:Object = null;
         var _loc1_:Object = this.getCurrentModel();
         var _loc2_:int = 0;
         if(_loc1_.effects_manager.hadEffect("increase_charge_master"))
         {
            _loc3_ = _loc1_.effects_manager.getEffect("increase_charge_master");
            _loc2_ += _loc3_.amount;
         }
         return _loc2_;
      }
      
      public function getDecreaseChargeCPByEffect() : Number
      {
         var _loc1_:* = this.getCurrentModel();
         var _loc2_:Number = 0;
         var _loc3_:* = _loc1_.effects_manager;
         var _loc4_:Array = _loc3_.user_debuffs;
         var _loc5_:Boolean;
         if(_loc5_ = _loc3_.hadEffect("decrease_charge"))
         {
            _loc2_ += _loc4_["decrease_charge"].amount;
         }
         return _loc2_;
      }
      
      public function checkRecoverHPAfterCharge(param1:int) : *
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc2_:Array = this.getAllCharacterSetEffects();
         var _loc3_:* = this.getCurrentModel();
         var _loc4_:int = int(_loc3_.health_manager.getMaxHP());
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc7_ = _loc2_[_loc6_];
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               if(_loc7_[_loc8_].effect == "charge_hp_recover")
               {
                  _loc5_ = int(_loc7_[_loc8_].amount);
                  if(_loc7_[_loc8_].calc_type == "percent")
                  {
                     _loc5_ = Math.floor(_loc5_ * _loc4_ / 100);
                  }
               }
               else if(_loc7_[_loc8_].effect == "increase_hp_charge")
               {
                  _loc5_ = int(_loc7_[_loc8_].amount);
                  if(_loc7_[_loc8_].calc_type == "percent")
                  {
                     _loc5_ = Math.floor(_loc5_ * param1 / 100);
                  }
               }
               _loc8_++;
            }
            _loc6_++;
         }
         if(_loc5_ > 0)
         {
            _loc3_.health_manager.addHealth(_loc5_,"Charge HP Recover +");
         }
      }
      
      public function checkAddHPAfterDodge() : *
      {
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         var _loc3_:Array = this.getAllCharacterSetEffects();
         var _loc4_:*;
         var _loc5_:int = (_loc4_ = this.getCurrentModel()).health_manager.getMaxHP();
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc1_ = _loc3_[_loc7_];
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(_loc1_[_loc2_].effect == "recover_hp_after_dodge")
               {
                  _loc6_ = int(_loc1_[_loc2_].amount);
                  if(_loc1_[_loc2_].calc_type == "percent")
                  {
                     _loc6_ = Math.floor(_loc6_ * _loc5_ / 100);
                  }
               }
               _loc2_++;
            }
            _loc7_++;
         }
         if(_loc6_ > 0)
         {
            _loc4_.health_manager.addHealth(_loc6_,"HP Recover +");
         }
      }
      
      public function checkAddHealthAfterGotDebuff() : *
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         if(this.has_added_health_from_debuff)
         {
            return;
         }
         var _loc1_:* = this.getCurrentModel();
         var _loc2_:int = 0;
         var _loc3_:int = int(_loc1_.health_manager.getMaxHP());
         var _loc4_:Array = this.getAllCharacterSetEffects();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               if(_loc6_[_loc7_].effect == "recover_hp_debuff")
               {
                  if(_loc6_[_loc7_].calc_type == "percent")
                  {
                     _loc2_ += Math.floor(_loc3_ * _loc6_[_loc7_].amount / 100);
                  }
                  else
                  {
                     _loc2_ += _loc6_[_loc7_].amount;
                  }
                  this.has_added_health_from_debuff = true;
               }
               if(_loc6_[_loc7_].effect == "recover_hp_cp_debuff")
               {
                  if(_loc6_[_loc7_].calc_type == "percent")
                  {
                     _loc2_ += Math.floor(_loc3_ * _loc6_[_loc7_].amount / 100);
                  }
                  else
                  {
                     _loc2_ += _loc6_[_loc7_].amount;
                  }
                  this.has_added_health_from_debuff = true;
               }
               _loc7_++;
            }
            _loc5_++;
         }
         if(_loc2_)
         {
            _loc1_.health_manager.addHealth(_loc2_,"Recovered HP +");
         }
      }
      
      public function checkAddCPAfterGotDebuff() : *
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         if(this.has_added_cp_from_debuff)
         {
            return;
         }
         var _loc1_:* = this.getCurrentModel();
         var _loc2_:int = 0;
         var _loc3_:int = int(_loc1_.health_manager.getMaxCP());
         var _loc4_:Array = this.getAllCharacterSetEffects();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               if(_loc6_[_loc7_].effect == "recover_cp_debuff")
               {
                  if(_loc6_[_loc7_].calc_type == "percent")
                  {
                     _loc2_ += Math.floor(_loc3_ * _loc6_[_loc7_].amount / 100);
                  }
                  else
                  {
                     _loc2_ += _loc6_[_loc7_].amount;
                  }
                  this.has_added_cp_from_debuff = true;
               }
               if(_loc6_[_loc7_].effect == "recover_hp_cp_debuff")
               {
                  if(_loc6_[_loc7_].calc_type == "percent")
                  {
                     _loc2_ += Math.floor(_loc3_ * _loc6_[_loc7_].amount / 100);
                  }
                  else
                  {
                     _loc2_ += _loc6_[_loc7_].amount;
                  }
                  this.has_added_cp_from_debuff = true;
               }
               _loc7_++;
            }
            _loc5_++;
         }
         if(_loc2_)
         {
            _loc1_.health_manager.addCP(_loc2_,"Recovered CP +");
         }
      }
      
      public function checkAddHealthAfterGotBuff() : *
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         if(this.has_added_health_from_buff)
         {
            return;
         }
         var _loc1_:* = this.getCurrentModel();
         var _loc2_:int = 0;
         var _loc3_:int = int(_loc1_.health_manager.getMaxHP());
         var _loc4_:Array = this.getAllCharacterSetEffects();
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               if(_loc6_[_loc7_].effect == "recover_hp_buff")
               {
                  if(_loc6_[_loc7_].calc_type == "percent")
                  {
                     _loc2_ += Math.floor(_loc3_ * _loc6_[_loc7_].amount / 100);
                  }
                  else
                  {
                     _loc2_ += _loc6_[_loc7_].amount;
                  }
                  this.has_added_health_from_buff = true;
               }
               if(_loc6_[_loc7_].effect == "recover_hp_cp_buff")
               {
                  if(_loc6_[_loc7_].calc_type == "percent")
                  {
                     _loc2_ += Math.floor(_loc3_ * _loc6_[_loc7_].amount / 100);
                  }
                  else
                  {
                     _loc2_ += _loc6_[_loc7_].amount;
                  }
                  this.has_added_health_from_buff = true;
               }
               _loc7_++;
            }
            _loc5_++;
         }
         if(_loc2_)
         {
            _loc1_.health_manager.addHealth(_loc2_,"Recovered HP +");
         }
      }
      
      public function checkAddCPAfterGotBuff() : *
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         if(this.has_added_cp_from_buff)
         {
            return;
         }
         var _loc1_:* = this.getCurrentModel();
         var _loc2_:int = 0;
         var _loc3_:int = int(_loc1_.health_manager.getMaxCP());
         var _loc4_:Array = this.getAllCharacterSetEffects();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               if(_loc6_[_loc7_].effect == "recover_cp_buff")
               {
                  if(_loc6_[_loc7_].calc_type == "percent")
                  {
                     _loc2_ += Math.floor(_loc3_ * _loc6_[_loc7_].amount / 100);
                  }
                  else
                  {
                     _loc2_ += _loc6_[_loc7_].amount;
                  }
                  this.has_added_cp_from_buff = true;
               }
               if(_loc6_[_loc7_].effect == "recover_hp_cp_buff")
               {
                  if(_loc6_[_loc7_].calc_type == "percent")
                  {
                     _loc2_ += Math.floor(_loc3_ * _loc6_[_loc7_].amount / 100);
                  }
                  else
                  {
                     _loc2_ += _loc6_[_loc7_].amount;
                  }
                  this.has_added_cp_from_buff = true;
               }
               _loc7_++;
            }
            _loc5_++;
         }
         if(_loc2_)
         {
            _loc1_.health_manager.addCP(_loc2_,"Recovered CP +");
         }
      }
      
      public function getAllCharacterSetEffects() : Array
      {
         var cm:* = undefined;
         var setBonusEffects:Array = null;
         var disableWeaponEffect:Boolean = this.hadEffect("disable_weapon_effect");
         var weaponId:String = "";
         var backItemId:String = "";
         var accessoryId:String = "";
         var clothingId:String = "";
         var hairId:String = "";
         try
         {
            cm = this.getCurrentModel().character_manager;
            weaponId = String(cm.getWeapon());
            backItemId = String(cm.getBackItem());
            accessoryId = String(cm.getAccessory());
            clothingId = String(cm.getClothing());
            hairId = String(cm.getHair());
         }
         catch(e:*)
         {
            weaponId = backItemId = accessoryId = clothingId = hairId = "";
         }
         var signature:String = [!!disableWeaponEffect ? "1" : "0",weaponId,backItemId,accessoryId,clothingId,hairId].join("|");
         if(this.allSetEffects.length < 1 || signature != this.lastSetEffectsSignature)
         {
            setBonusEffects = SetBonusCalculator.getSetBonusEffects(weaponId,backItemId,accessoryId,clothingId,hairId,!disableWeaponEffect);
            if(disableWeaponEffect)
            {
               this.allSetEffects = [this.getCharacterBackItemEffects(),this.getCharacterAccessoryEffects(),setBonusEffects];
            }
            else
            {
               this.allSetEffects = [this.getCharacterWeaponEffects(),this.getCharacterBackItemEffects(),this.getCharacterAccessoryEffects(),setBonusEffects];
            }
            this.lastDisableWeaponState = disableWeaponEffect;
            this.lastSetEffectsSignature = signature;
         }
         return this.allSetEffects;
      }
      
      private function getSetEffects() : Array
      {
         var _loc1_:Array = this.getCharacterWeaponEffects().concat(this.getCharacterBackItemEffects()).concat(this.getCharacterAccessoryEffects());
         return _loc1_.length > 0 ? _loc1_ : [];
      }
      
      public function getCharacterWeaponEffects() : *
      {
         var effect:* = undefined;
         var wpnId:String = null;
         if(this.hadEffect("disable_weapon_effect"))
         {
            return [];
         }
         var charMc:* = this.getCurrentModel();
         try
         {
            wpnId = String(charMc.character_manager.getWeapon());
            effect = WeaponBuffs.getCopy(wpnId).effects == null ? [] : WeaponBuffs.getCopy(wpnId).effects;
            return effect;
         }
         catch(e:*)
         {
            return [];
         }
      }
      
      public function getCharacterBackItemEffects() : *
      {
         var effect:* = undefined;
         var backItemId:String = null;
         var charMc:* = this.getCurrentModel();
         try
         {
            backItemId = String(charMc.character_manager.getBackItem());
            effect = BackItemBuffs.getCopy(backItemId).effects == null ? [] : BackItemBuffs.getCopy(backItemId).effects;
            return effect;
         }
         catch(e:*)
         {
            return [];
         }
      }
      
      public function getCharacterAccessoryEffects() : *
      {
         var effect:* = undefined;
         var accId:String = null;
         var charMc:* = this.getCurrentModel();
         try
         {
            accId = String(charMc.character_manager.getAccessory());
            effect = AccessoryBuffs.getCopy(accId).effects == null ? [] : AccessoryBuffs.getCopy(accId).effects;
            return effect;
         }
         catch(e:*)
         {
            return [];
         }
      }
      
      public function isBurnImmune() : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc1_:Array = this.getAllCharacterSetEffects();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].effect == "burn_protection" || _loc3_[_loc4_].effect == "immune_burn")
               {
                  return true;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function isInternalInjuryImmune() : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc1_:Array = this.getAllCharacterSetEffects();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if((_loc5_ = _loc3_[_loc4_]).effect == "immune_internal_injury")
               {
                  _loc6_ = _loc5_.chance != null ? Number(_loc5_.chance) : Number(100);
                  if(Math.random() * 100 < _loc6_)
                  {
                     return true;
                  }
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function increaseRecoverByEffects(param1:int, param2:String) : int
      {
         var _loc3_:Array = null;
         var _loc9_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = this.getAllCharacterSetEffects();
         var _loc7_:Object;
         if((_loc7_ = this.checkIncreaseRecoverItemFromTalent()) != null)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc7_.length)
            {
               if(_loc7_[_loc9_].effect == "item_restore_hp_bonus" && param2 == "hp")
               {
                  _loc5_ = Math.floor(param1 * _loc7_[_loc9_].amount / 100);
                  param1 += _loc5_;
               }
               if(_loc7_[_loc9_].effect == "item_restore_cp_bonus" && param2 == "cp")
               {
                  _loc5_ = Math.floor(param1 * _loc7_[_loc9_].amount / 100);
                  param1 += _loc5_;
               }
               _loc9_++;
            }
         }
         var _loc8_:* = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc3_ = _loc6_[_loc8_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].effect == "item_restore_hp_bonus" && param2 == "hp")
               {
                  _loc5_ = Math.floor(param1 * _loc3_[_loc4_].amount / 100);
                  param1 += _loc5_;
               }
               if(_loc3_[_loc4_].effect == "item_restore_cp_bonus" && param2 == "cp")
               {
                  _loc5_ = Math.floor(param1 * _loc3_[_loc4_].amount / 100);
                  param1 += _loc5_;
               }
               _loc4_++;
            }
            _loc8_++;
         }
         return param1;
      }
      
      public function handleLightMatter() : Boolean
      {
         var _loc1_:Object = this.getCurrentModel();
         var _loc2_:Number = 0;
         if(!_loc1_.isCharacter())
         {
            return false;
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1113"))
         {
            _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1113",_loc1_.character_manager.getTalentLevel("skill_1113")).internal_injury_chance;
         }
         return NumberUtil.getChance(_loc2_);
      }
      
      public function handleDarkMatter() : Boolean
      {
         var _loc1_:Object = this.getCurrentModel();
         var _loc2_:Number = 0;
         if(!_loc1_.isCharacter())
         {
            return false;
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1116"))
         {
            _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1116",_loc1_.character_manager.getTalentLevel("skill_1116")).disable_chance;
         }
         return NumberUtil.getChance(_loc2_);
      }
      
      public function checkDecreaseDamageFromOnmyouji(param1:Object) : Number
      {
         var _loc2_:Number = 0;
         if(param1 && param1.effects_manager && param1.effects_manager.hadEffect("disable_passive_talent"))
         {
            return 0;
         }
         if(param1.effects_manager.hasActivePassiveTalent("skill_1014"))
         {
            _loc2_ += TalentSkillLevel.getTalentSkillLevels("skill_1014",param1.character_manager.getTalentLevel("skill_1014")).reduce_damage_taken;
         }
         return _loc2_;
      }
      
      public function checkDecreaseDamageFromOrochi(param1:Object) : Number
      {
         var _loc2_:Number = 0;
         if(param1 && param1.effects_manager && param1.effects_manager.hadEffect("disable_passive_talent"))
         {
            return 0;
         }
         if(param1.effects_manager.hasActivePassiveTalent("skill_1024"))
         {
            _loc2_ += TalentSkillLevel.getTalentSkillLevels("skill_1024",param1.character_manager.getTalentLevel("skill_1024")).reduce_damage_taken;
         }
         return _loc2_;
      }
      
      public function checkDecreaseDamageFromCarapace(param1:Object) : Number
      {
         var _loc2_:Number = 0;
         if(param1 && param1.effects_manager && param1.effects_manager.hadEffect("disable_passive_talent"))
         {
            return 0;
         }
         if(param1.effects_manager.hasActivePassiveTalent("skill_1051"))
         {
            _loc2_ += TalentSkillLevel.getTalentSkillLevels("skill_1051",param1.character_manager.getTalentLevel("skill_1051")).reduce_damage_taken;
         }
         return _loc2_;
      }
      
      public function checkIncreaseDamageFromChakraConvergence(param1:Object) : Number
      {
         var _loc2_:Number = 0;
         if(param1.effects_manager.hasActivePassiveTalent("skill_1058"))
         {
            _loc2_ += TalentSkillLevel.getTalentSkillLevels("skill_1058",param1.character_manager.getTalentLevel("skill_1058")).amount;
         }
         if(_loc2_ > 0)
         {
            _loc2_ = Math.floor(param1.health_manager.temp_skill_cp_cost * _loc2_ / 100);
         }
         return _loc2_;
      }
      
      public function checkIncreaseDamageFromUltimateEvolution(param1:Object) : Number
      {
         var _loc3_:* = undefined;
         var _loc2_:Number = 0;
         if(param1.effects_manager.hasActivePassiveTalent("skill_1055"))
         {
            _loc3_ = param1.health_manager.getMaxCP();
            _loc2_ += TalentSkillLevel.getTalentSkillLevels("skill_1055",param1.character_manager.getTalentLevel("skill_1055")).increase_damage;
            _loc2_ = Math.round(_loc3_ * _loc2_ / 100);
         }
         return _loc2_;
      }
      
      public function checkIncreaseDamageFromEssenceOfTime(param1:Object) : Number
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Number = 0;
         if(param1.effects_manager.hasActivePassiveTalent("skill_1120"))
         {
            _loc3_ = param1.getAgility();
            _loc4_ = TalentSkillLevel.getTalentSkillLevels("skill_1120",param1.character_manager.getTalentLevel("skill_1120")).agility_point;
            _loc2_ = Math.floor(_loc3_ / _loc4_);
         }
         return _loc2_;
      }
      
      public function checkIncreaseDamageFromMarionette(param1:Object) : Number
      {
         var _loc2_:Number = 0;
         if(param1.effects_manager.hasActivePassiveTalent("skill_1102"))
         {
            _loc2_ += TalentSkillLevel.getTalentSkillLevels("skill_1102",param1.character_manager.getTalentLevel("skill_1102")).increase_damage;
         }
         return _loc2_;
      }
      
      public function checkIncreaseDamageFromExtrimities(param1:Object) : Number
      {
         var _loc2_:Number = 0;
         if(param1.effects_manager.hasActivePassiveTalent("skill_1001"))
         {
            _loc2_ += TalentSkillLevel.getTalentSkillLevels("skill_1001",param1.character_manager.getTalentLevel("skill_1001")).amount_increase;
         }
         return _loc2_;
      }
      
      public function checkIncreaseDamageFromExplosiveLava(param1:Object) : Number
      {
         var _loc2_:Number = 0;
         if(param1.effects_manager.hasActivePassiveTalent("skill_1039"))
         {
            _loc2_ += TalentSkillLevel.getTalentSkillLevels("skill_1039",param1.character_manager.getTalentLevel("skill_1039")).amount;
         }
         return _loc2_;
      }
      
      public function checkIncreaseDamageFromMountainFlavor(param1:Object) : Number
      {
         var _loc3_:Object = null;
         var _loc2_:Number = 0;
         if(param1 == null || !param1.isCharacter() || param1.character_manager == null)
         {
            return _loc2_;
         }
         if(param1.character_manager.hasSenjutsuSkill("skill_3001"))
         {
            _loc3_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3001",param1.character_manager.getSenjutsuLevel("skill_3001"));
            if(_loc3_ != null && "increase_damage" in _loc3_)
            {
               _loc2_ += Number(_loc3_.increase_damage);
            }
         }
         return _loc2_;
      }
      
      public function checkIncreaseDamageFromSlugEarthMastery(param1:Object) : Number
      {
         var _loc3_:Object = null;
         var _loc2_:Number = 0;
         if(param1 == null || !param1.isCharacter() || param1.character_manager == null)
         {
            return _loc2_;
         }
         if(BattleVars.SKILL_USED_TYPE != 4 && BattleVars.SKILL_USED_TYPE != 11)
         {
            return _loc2_;
         }
         if(param1.character_manager.hasSenjutsuSkill("skill_3204"))
         {
            _loc3_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3204",param1.character_manager.getSenjutsuLevel("skill_3204"));
            if(_loc3_ != null && "increase_damage" in _loc3_)
            {
               _loc2_ += Number(_loc3_.increase_damage);
            }
         }
         return _loc2_;
      }
      
      public function getIncreaseReactiveFromSlugEarthMastery() : Number
      {
         var _loc3_:Object = null;
         var _loc1_:Object = this.getCurrentModel();
         var _loc2_:Number = 0;
         if(_loc1_ == null || !_loc1_.isCharacter() || _loc1_.character_manager == null)
         {
            return _loc2_;
         }
         if(_loc1_.character_manager.hasSenjutsuSkill("skill_3204"))
         {
            _loc3_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3204",_loc1_.character_manager.getSenjutsuLevel("skill_3204"));
            if(_loc3_ != null && "increase_reactive" in _loc3_)
            {
               _loc2_ += Number(_loc3_.increase_reactive);
            }
         }
         return _loc2_;
      }
      
      private function getPassiveEffect() : *
      {
         var _loc1_:Array = [];
      }
      
      private function getActiveEffect() : *
      {
         var _loc1_:Array = [];
      }
      
      private function getCriticalEffect() : *
      {
         var _loc1_:Array = [];
      }
      
      public function calculateDamage(param1:int, param2:Object, param3:Boolean = false) : int
      {
         param1 = this.increaseDamage(param1,param2,param3);
         param1 = this.increaseFromPassiveEffects_Clan(param1,this.getCurrentModel());
         param1 = this.calculateCriticalDamage(param1);
         return int(this.decreaseDamage(param1,param2));
      }
      
      public function increaseDamage(param1:int, param2:Object, param3:Boolean = false) : int
      {
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc22_:Array = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc4_:Object = this.getCurrentModel();
         var _loc5_:int = this.increaseDamageFromPassive_Buff(_loc4_).additive;
         var _loc6_:Array = this.increaseDamageFromPassive_Buff(_loc4_).multiplicative;
         param1 += _loc5_;
         var _loc7_:int = 1;
         for each(_loc8_ in _loc6_)
         {
            param1 += Math.round(param1 * _loc8_ / 100);
            _loc7_++;
         }
         _loc9_ = this.increaseDamageFromActive_Buff_Attacker(_loc4_);
         _loc10_ = this.increaseDamageFromActive_Buff_Defender(param2);
         _loc11_ = this.increaseDamageFromActive_Debuff_Attacker(_loc4_);
         _loc12_ = this.increaseDamageFromActive_Debuff_Defender(param2);
         _loc13_ = _loc9_.additive;
         _loc14_ = _loc9_.multiplicative;
         _loc15_ = _loc10_.additive;
         _loc16_ = _loc10_.multiplicative;
         _loc17_ = _loc11_.additive;
         _loc18_ = _loc11_.multiplicative;
         _loc19_ = _loc12_.additive;
         _loc20_ = _loc12_.multiplicative;
         _loc21_ = _loc13_ + _loc15_ + _loc17_ + _loc19_;
         _loc22_ = _loc14_.concat(_loc16_).concat(_loc18_).concat(_loc20_);
         param1 += _loc21_;
         _loc23_ = 1;
         for each(_loc24_ in _loc22_)
         {
            param1 += Math.round(param1 * _loc24_ / 100);
            _loc23_++;
         }
         return param1;
      }
      
      private function calculateCriticalDamage(param1:int) : int
      {
         var _loc6_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(!BattleVars.IS_CRITICAL)
         {
            return param1;
         }
         var _loc2_:Object = this.getCurrentModel();
         var _loc3_:int = 50;
         var _loc4_:int = _loc3_;
         var _loc5_:int = 0;
         if(this.hadEffect("decrease_critical_damage"))
         {
            if((_loc6_ = this.getEffect("decrease_critical_damage")) && _loc6_.amount)
            {
               _loc4_ -= _loc6_.amount;
            }
         }
         if(this.hadEffect("critical_buff_n_received_stun"))
         {
            if((_loc6_ = this.getEffect("critical_buff_n_received_stun")) && _loc6_.amount)
            {
               _loc4_ += _loc6_.amount;
            }
         }
         if(this.hadEffect("pet_mortal"))
         {
            if((_loc6_ = this.getEffect("pet_mortal")) && _loc6_.amount)
            {
               _loc4_ += _loc6_.amount;
            }
         }
         if(_loc2_.isCharacter())
         {
            _loc8_ = _loc2_.character_manager;
            _loc4_ += Math.round(_loc8_.getLightningAttributes() * 0.8);
            _loc9_ = this.getIncreaseCriticalByPassiveEffects("percent");
            _loc10_ = this.getIncreaseCriticalByPassiveEffects("number");
            _loc4_ += Math.round(_loc9_);
            _loc5_ += Math.round(_loc10_);
            _loc4_ += this.getIncreaseCritDamageByTalent();
         }
         var _loc7_:Number = 1 + _loc4_ / 100;
         return int(Math.round(param1 * _loc7_ + _loc5_));
      }
      
      private function increaseFromPassiveEffects_Clan(param1:int, param2:Object) : int
      {
         if(!param2.isCharacter())
         {
            return param1;
         }
         if(BattleManager.BATTLE_VARS.BATTLE_MODE != "CLAN")
         {
            return param1;
         }
         var _loc3_:* = param2.characterClanData;
         return int(Math.round(_loc3_.training_hall * 0.3 + int(1)) * param1);
      }
      
      private function increaseFromPassiveEffects_Element_Multiplicative(param1:Object) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = BattleVars.SKILL_USED_TYPE;
         var _loc4_:Object = param1.character_manager;
         var _loc5_:Number = 0.4 * _loc4_.getFireAttributes();
         _loc2_.push(_loc5_);
         switch(_loc3_)
         {
            case 1:
               _loc2_.push(_loc4_.getWindAttributes());
               break;
            case 2:
               _loc2_.push(_loc4_.getFireAttributes());
               break;
            case 3:
               _loc2_.push(_loc4_.getLightningAttributes());
               break;
            case 4:
               _loc2_.push(_loc4_.getEarthAttributes());
               break;
            case 5:
               _loc2_.push(_loc4_.getWaterAttributes());
         }
         return _loc2_;
      }
      
      private function increaseFromPassiveEffects_Gear_Additive(param1:Object) : int
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc2_:Array = param1.effects_manager.getPassiveEffect();
         var _loc3_:Array = param1.effects_manager.getAllCharacterSetEffects();
         var _loc4_:int = 0;
         for each(_loc5_ in _loc3_)
         {
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.calc_type == "number" && _loc6_.effect == "damage_increase")
               {
                  _loc4_ += _loc6_.amount;
               }
               else if(_loc6_.effect == "power_up_by_hp")
               {
                  _loc4_ += this.applyPowerUpByHP(param1,_loc6_);
               }
            }
         }
         return _loc4_;
      }
      
      private function decreaseFromPassiveEffects_Gear_Additive(param1:Object) : int
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc2_:Array = param1.effects_manager.getPassiveEffect();
         var _loc3_:Array = param1.effects_manager.getAllCharacterSetEffects();
         var _loc4_:int = 0;
         for each(_loc5_ in _loc3_)
         {
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.calc_type == "number" && _loc6_.effect == "damage_reduce")
               {
                  _loc4_ += _loc6_.amount;
               }
            }
         }
         return _loc4_;
      }
      
      private function increaseFromPassiveEffects_Gear_Multiplicative(param1:Object) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc2_:Array = param1.effects_manager.getAllCharacterSetEffects();
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.calc_type == "percent" && _loc5_.effect != "power_up_by_hp" && _loc5_.effect == "damage_increase")
               {
                  _loc3_.push(_loc5_.amount);
               }
            }
         }
         return _loc3_;
      }
      
      private function decreaseFromPassiveEffects_Gear_Multiplicative(param1:Object) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc2_:Array = param1.effects_manager.getAllCharacterSetEffects();
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.calc_type == "percent" && _loc5_.effect == "damage_reduce")
               {
                  _loc3_.push(_loc5_.amount);
               }
            }
         }
         return _loc3_;
      }
      
      private function increaseFromPassiveEffects_Talent_Additive(param1:Object) : int
      {
         var _loc2_:int = 0;
         _loc2_ += param1.effects_manager.checkIncreaseDamageFromChakraConvergence(param1);
         return int(_loc2_ + param1.effects_manager.checkIncreaseDamageFromUltimateEvolution(param1));
      }
      
      private function decreaseFromPassiveEffects_Talent_Additive(param1:Object) : int
      {
         return 0;
      }
      
      private function increaseFromPassiveEffects_Talent_Multiplicative(param1:Object) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = param1.effects_manager.checkIncreaseDamageFromMarionette(param1);
         var _loc4_:int;
         if((_loc4_ = param1.effects_manager.checkIncreaseDamageFromEssenceOfTime(param1)) > 0)
         {
            _loc2_.push(_loc4_);
         }
         if(_loc3_ > 0)
         {
            _loc2_.push(_loc3_);
         }
         if(BattleVars.SKILL_USED_TYPE == 6 || BattleVars.SKILL_USED_ID.split("_")[1] >= 1000 && int(BattleVars.SKILL_USED_ID.split("_")[1]) <= 1005)
         {
            _loc2_.push(param1.effects_manager.checkIncreaseDamageFromExtrimities(param1));
         }
         if(BattleVars.SKILL_USED_TYPE == 2 || BattleVars.SKILL_USED_TYPE == 4)
         {
            _loc2_.push(param1.effects_manager.checkIncreaseDamageFromExplosiveLava(param1));
         }
         return _loc2_;
      }
      
      private function decreaseFromPassiveEffects_Talent_Multiplicative(param1:Object) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = param1.effects_manager.checkDecreaseDamageFromOnmyouji(param1);
         var _loc4_:int = param1.effects_manager.checkDecreaseDamageFromOrochi(param1);
         var _loc5_:int = param1.effects_manager.checkDecreaseDamageFromCarapace(param1);
         if(_loc3_ > 0)
         {
            _loc2_.push(_loc3_);
         }
         if(_loc4_ > 0)
         {
            _loc2_.push(_loc4_);
         }
         if(_loc5_ > 0)
         {
            _loc2_.push(_loc5_);
         }
         return _loc2_;
      }
      
      private function increaseFromPassiveEffects_Senjutsu_Additive(param1:Object) : int
      {
         return 0;
      }
      
      private function decreaseFromPassiveEffects_Senjutsu_Additive(param1:Object) : int
      {
         return 0;
      }
      
      private function increaseFromPassiveEffects_Senjutsu_Multiplicative(param1:Object) : Array
      {
         var _loc2_:Array = [];
         _loc2_.push(this.checkIncreaseDamageFromMountainFlavor(param1));
         _loc2_.push(this.checkIncreaseDamageFromSlugEarthMastery(param1));
         return _loc2_;
      }
      
      private function decreaseFromPassiveEffects_Senjutsu_Multiplicative(param1:Object) : Array
      {
         return [];
      }
      
      private function increaseDamageFromPassive_Buff(param1:Object) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         if(param1.isCharacter())
         {
            _loc4_ = this.increaseFromPassiveEffects_Gear_Additive(param1);
            _loc5_ = this.increaseFromPassiveEffects_Talent_Additive(param1);
            _loc6_ = this.increaseFromPassiveEffects_Senjutsu_Additive(param1);
            _loc7_ = this.increaseFromPassiveEffects_Element_Multiplicative(param1);
            _loc8_ = this.increaseFromPassiveEffects_Gear_Multiplicative(param1);
            _loc9_ = this.increaseFromPassiveEffects_Talent_Multiplicative(param1);
            _loc10_ = this.increaseFromPassiveEffects_Senjutsu_Multiplicative(param1);
         }
         _loc2_ = _loc4_ + _loc5_ + _loc6_;
         _loc3_ = _loc7_.concat(_loc8_).concat(_loc9_).concat(_loc10_);
         if(BattleVars.IS_COMBUSTION)
         {
            _loc3_.push(30);
         }
         return {
            "additive":_loc2_,
            "multiplicative":_loc3_
         };
      }
      
      private function decreaseDamageFromPassive_Buff(param1:Object) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         if(param1.isCharacter())
         {
            _loc4_ = this.decreaseFromPassiveEffects_Gear_Additive(param1);
            _loc5_ = this.decreaseFromPassiveEffects_Talent_Additive(param1);
            _loc6_ = this.decreaseFromPassiveEffects_Senjutsu_Additive(param1);
            _loc7_ = this.decreaseFromPassiveEffects_Gear_Multiplicative(param1);
            _loc8_ = this.decreaseFromPassiveEffects_Talent_Multiplicative(param1);
            _loc9_ = this.decreaseFromPassiveEffects_Senjutsu_Multiplicative(param1);
         }
         _loc2_ = _loc4_ + _loc5_ + _loc6_;
         _loc3_ = _loc7_.concat(_loc8_).concat(_loc9_);
         return {
            "additive":_loc2_,
            "multiplicative":_loc3_
         };
      }
      
      private function increaseDamageFromActive_Buff_Attacker(param1:Object) : Object
      {
         var _loc6_:Object = null;
         var _loc7_:* = false;
         var _loc8_:Boolean = false;
         var _loc2_:Array = ["damage_percent","solar_might","kyubi_cloak","dodge_damage_bonus","tolerance","shukaku_blessing","rampage","extreme_mode","senjutsu_strengthen","sage_mode","invincible","unyielding","pet_frenzy","power_up","inquisitor","domain_expansion","strengthen","strengthen_special","pet_strengthen","stealth","rage","taijutsu_strengthen","pet_lightning_armor","lightning_armor","power_up_battle"];
         var _loc3_:Vector.<Object> = param1.effects_manager.getActiveEffects();
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc6_.effect) == -1)
            {
               continue;
            }
            switch(_loc6_.effect)
            {
               case "senjutsu_strengthen":
                  _loc4_ += Math.round(param1.health_manager.getMaxSP() * _loc6_.amount / 100);
                  break;
               case "extreme_mode":
                  _loc7_ = BattleVars.SKILL_USED_TYPE == 6;
                  _loc8_ = BattleVars.SKILL_USED_ID.split("_")[1] >= 1000 && int(BattleVars.SKILL_USED_ID.split("_")[1]) <= 1005;
                  if(!(_loc7_ == false && _loc8_ == false))
                  {
                     _loc5_.push(_loc6_.amount);
                  }
                  break;
               default:
                  if(_loc6_.calc_type == "number")
                  {
                     _loc4_ += _loc6_.amount;
                  }
                  else if(_loc6_.calc_type == "percent")
                  {
                     _loc5_.push(_loc6_.amount);
                  }
                  break;
            }
         }
         return {
            "additive":_loc4_,
            "multiplicative":_loc5_
         };
      }
      
      private function increaseDamageFromActive_Buff_Defender(param1:Object) : Object
      {
         var _loc6_:Object = null;
         var _loc2_:Array = ["rage"];
         var _loc3_:Vector.<Object> = param1.effects_manager.getActiveEffects();
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc6_.effect) != -1)
            {
               if(_loc6_.calc_type == "number")
               {
                  _loc4_ += _loc6_.amount;
               }
               else if(_loc6_.calc_type == "percent")
               {
                  _loc5_.push(_loc6_.amount);
               }
            }
         }
         return {
            "additive":_loc4_,
            "multiplicative":_loc5_
         };
      }
      
      private function decreaseDamageFromActive_Buff_Attacker(param1:Object) : Object
      {
         var _loc6_:Object = null;
         var _loc2_:Array = ["damage_reduce_self"];
         var _loc3_:Vector.<Object> = param1.effects_manager.getActiveEffects();
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc6_.effect) != -1)
            {
               if(_loc6_.calc_type == "number")
               {
                  _loc4_ += _loc6_.amount;
               }
               else if(_loc6_.calc_type == "percent")
               {
                  _loc5_.push(_loc6_.amount);
               }
            }
         }
         return {
            "additive":_loc4_,
            "multiplicative":_loc5_
         };
      }
      
      private function decreaseDamageFromActive_Buff_Defender(param1:Object) : Object
      {
         var _loc6_:Object = null;
         var _loc2_:Array = ["damage_reduction","damage_reduce","defense_percent","emberstep_demonic","preservation","tolerance","wolfram","invincible","unyielding","self_love","bloodflame","protection","pet_protection","stealth","guard","pet_guard","plus_protection"];
         var _loc3_:Vector.<Object> = param1.effects_manager.getActiveEffects();
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc6_.effect) == -1)
            {
               continue;
            }
            switch(_loc6_.effect)
            {
               case "stealth":
                  if(_loc6_.calc_type == "percent")
                  {
                     _loc5_.push(_loc6_.amount_protection);
                  }
                  else
                  {
                     _loc4_ += _loc6_.amount_protection;
                  }
                  break;
               case "plus_protection":
                  if(_loc6_.new_amount != undefined)
                  {
                     if(_loc6_.calc_type == "percent")
                     {
                        _loc5_.push(_loc6_.new_amount);
                     }
                     else
                     {
                        _loc4_ += _loc6_.new_amount;
                     }
                  }
                  break;
               default:
                  if(_loc6_.calc_type == "number")
                  {
                     _loc4_ += _loc6_.amount;
                  }
                  else if(_loc6_.calc_type == "percent")
                  {
                     _loc5_.push(_loc6_.amount);
                  }
                  break;
            }
         }
         return {
            "additive":_loc4_,
            "multiplicative":_loc5_
         };
      }
      
      private function increaseDamageFromActive_Debuff_Attacker(param1:Object) : Object
      {
         var _loc6_:Object = null;
         var _loc2_:Array = ["none"];
         var _loc3_:Vector.<Object> = param1.effects_manager.getActiveEffects();
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc6_.effect) != -1)
            {
               if(_loc6_.calc_type == "number")
               {
                  _loc4_ += _loc6_.amount;
               }
               else if(_loc6_.calc_type == "percent")
               {
                  _loc5_.push(_loc6_.amount);
               }
            }
         }
         return {
            "additive":_loc4_,
            "multiplicative":_loc5_
         };
      }
      
      private function increaseDamageFromActive_Debuff_Defender(param1:Object) : Object
      {
         var _loc6_:Object = null;
         var _loc2_:Array = ["chill","bleeding","pet_bleeding","ultra_bleeding","vulnerable","expose_defence"];
         var _loc3_:Vector.<Object> = param1.effects_manager.getActiveEffects();
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc6_.effect) == -1)
            {
               continue;
            }
            switch(_loc6_.effect)
            {
               case "chill":
                  _loc5_.push(80);
                  break;
               case "petrify":
                  _loc5_.push(100);
                  break;
               default:
                  if(_loc6_.calc_type == "number")
                  {
                     _loc4_ += _loc6_.amount;
                  }
                  else if(_loc6_.calc_type == "percent")
                  {
                     _loc5_.push(_loc6_.amount);
                  }
                  break;
            }
         }
         return {
            "additive":_loc4_,
            "multiplicative":_loc5_
         };
      }
      
      private function decreaseDamageFromActive_Debuff_Attacker(param1:Object) : Object
      {
         var _loc6_:Object = null;
         var _loc2_:Array = ["weaken_unpurify","holdback","infection","vulnerable","weaken","pet_weaken","ecstasy","pet_ecstasy","dark_curse","embrace"];
         var _loc3_:Vector.<Object> = param1.effects_manager.getActiveEffects();
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc6_.effect) == -1)
            {
               continue;
            }
            switch(_loc6_.effect)
            {
               case "infection":
                  _loc5_.push(_loc6_.amount_reduce);
                  break;
               case "petrify":
                  _loc5_.push(100);
                  break;
               default:
                  if(_loc6_.calc_type == "number")
                  {
                     _loc4_ += _loc6_.amount;
                  }
                  else if(_loc6_.calc_type == "percent")
                  {
                     _loc5_.push(_loc6_.amount);
                  }
                  break;
            }
         }
         return {
            "additive":_loc4_,
            "multiplicative":_loc5_
         };
      }
      
      private function decreaseDamageFromActive_Debuff_Defender(param1:Object) : Object
      {
         var _loc6_:Object = null;
         var _loc2_:Array = ["damage_reduction","damage_reduce","defense_percent","preservation","petrify","frozen","chill","tolerance","wolfram","invincible","unyielding","self_love","bloodflame","protection","pet_protection","stealth","guard","pet_guard","plus_protection","toxic_tooth"];
         var _loc3_:Vector.<Object> = param1.effects_manager.getActiveEffects();
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc6_.effect) == -1)
            {
               continue;
            }
            switch(_loc6_.effect)
            {
               case "chill":
                  _loc5_.push(80);
                  break;
               case "petrify":
               case "toxic_tooth":
                  _loc5_.push(100);
                  break;
               default:
                  if(_loc6_.calc_type == "number")
                  {
                     _loc4_ += _loc6_.amount;
                  }
                  else if(_loc6_.calc_type == "percent")
                  {
                     _loc5_.push(_loc6_.amount);
                  }
                  break;
            }
         }
         return {
            "additive":_loc4_,
            "multiplicative":_loc5_
         };
      }
      
      private function increaseDamageFromCritical_Buff() : Object
      {
         var _loc5_:Object = null;
         var _loc1_:Array = ["concentration","reflexes"];
         var _loc2_:Vector.<Object> = this.getActiveEffects();
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         for each(_loc5_ in _loc2_)
         {
            if(_loc1_.indexOf(_loc5_.effect) != -1)
            {
               if(_loc5_.calc_type == "number")
               {
                  _loc3_ += _loc5_.amount;
               }
               else if(_loc5_.calc_type == "percent")
               {
                  _loc4_.push(_loc5_.amount);
               }
            }
         }
         return {
            "additive":_loc3_,
            "multiplicative":_loc4_
         };
      }
      
      public function decreaseDamage(param1:int, param2:Object) : int
      {
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:Array = null;
         var _loc20_:int = 0;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc3_:Object = this.getCurrentModel();
         if(param2 != null && param2.effects_manager.getEffect("fast_forward") && param2.effects_manager.getEffect("fast_forward").duration > 1)
         {
            return param1;
         }
         _loc3_ = this.getCurrentModel();
         var _loc4_:int = this.decreaseDamageFromPassive_Buff(param2).additive;
         var _loc5_:Array = this.decreaseDamageFromPassive_Buff(param2).multiplicative;
         param1 -= _loc4_;
         var _loc6_:int = 1;
         for each(_loc7_ in _loc5_)
         {
            param1 -= Math.round(param1 * _loc7_ / 100);
            _loc6_++;
         }
         _loc8_ = this.decreaseDamageFromActive_Buff_Attacker(_loc3_);
         _loc9_ = this.decreaseDamageFromActive_Buff_Defender(param2);
         _loc10_ = this.decreaseDamageFromActive_Debuff_Attacker(_loc3_);
         _loc11_ = this.decreaseDamageFromActive_Debuff_Defender(param2);
         _loc12_ = _loc8_.additive;
         _loc13_ = _loc8_.multiplicative;
         _loc14_ = _loc9_.additive;
         _loc15_ = _loc9_.multiplicative;
         _loc16_ = _loc10_.additive;
         _loc17_ = _loc10_.multiplicative;
         _loc18_ = _loc11_.additive;
         _loc19_ = _loc11_.multiplicative;
         _loc20_ = _loc12_ + _loc14_ + _loc16_ + _loc18_;
         _loc21_ = _loc13_.concat(_loc15_).concat(_loc17_).concat(_loc19_);
         param1 -= _loc20_;
         _loc22_ = 1;
         for each(_loc23_ in _loc21_)
         {
            param1 -= Math.round(param1 * _loc23_ / 100);
            _loc22_++;
         }
         return param1;
      }
      
      private function applyPowerUpByHP(param1:Object, param2:Object) : int
      {
         var _loc3_:int = int(param1.health_manager.getMaxHP());
         var _loc4_:int = int(param1.health_manager.getCurrentHP());
         if(param2.calc_type === "percent")
         {
            return param2.reduce_type != "MAX" ? int(Math.floor(_loc4_ * param2.amount / 100)) : int(Math.floor(_loc3_ * param2.amount / 100));
         }
         return param2.amount;
      }
      
      public function checkSereneMind() : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc1_:Array = this.getAllCharacterSetEffects();
         var _loc2_:Boolean = false;
         for each(_loc3_ in _loc1_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.effect == "serene_mind_item" && _loc4_.chance >= NumberUtil.getRandomInt())
               {
                  _loc2_ = true;
                  break;
               }
            }
         }
         if(this.hadEffect("serene_mind") || this.hadEffect("pet_serene_mind"))
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function dealCounterSkill() : Boolean
      {
         var _loc1_:* = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return false;
         }
         if(!_loc1_.effects_manager.hadEffect("counter_effect"))
         {
            return false;
         }
         if(_loc1_.character_manager.getSpecificSkill("skill_7036"))
         {
            BattleVars.COPY_SKILL_ID_SAVE = "skill_7038";
            return true;
         }
         if(_loc1_.character_manager.getSpecificSkill("skill_7037"))
         {
            BattleVars.COPY_SKILL_ID_SAVE = "skill_7039";
            return true;
         }
         return false;
      }
      
      public function checkIncreaseDamageForToad(param1:*) : int
      {
         var _loc9_:Array = null;
         var _loc2_:int = param1;
         var _loc3_:* = this.getCurrentModel();
         if(!_loc3_.isCharacter())
         {
            return _loc2_;
         }
         var _loc4_:Array = this.getSenjutsuSkills(_loc3_);
         var _loc5_:int = _loc3_.health_manager.getCurrentHP();
         var _loc6_:int;
         var _loc7_:int = (_loc6_ = _loc3_.health_manager.getMaxHP()) - _loc5_;
         var _loc8_:* = 0;
         while(_loc8_ < _loc4_.length)
         {
            if((_loc9_ = _loc4_[_loc8_].split(":"))[0] == "skill_3009")
            {
               param1 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3009",_loc3_.character_manager.getSenjutsuLevel("skill_3009")).hp_requirement;
               _loc2_ += Math.round(_loc7_ * param1 / 100);
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      public function checkBackgroundChangeFinish() : void
      {
         var _loc4_:Object = null;
         var _loc1_:Object = this.getCurrentModel();
         var _loc2_:String = null;
         var _loc3_:int = _loc1_.effects_manager.dataBuff.length - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = _loc1_.effects_manager.dataBuff[_loc3_];
            if(Effects.doesEffectChangeBackground(_loc4_.effect))
            {
               _loc2_ = _loc4_.background_id;
               break;
            }
            _loc3_--;
         }
         if(_loc2_ != null)
         {
            if(BattleManager.BATTLE_VARS.BATTLE_BACKGROUND != _loc2_)
            {
               BattleManager.BATTLE_VARS.BATTLE_BACKGROUND = _loc2_;
               BattleManager.loadBackground();
            }
         }
         else
         {
            if(!_loc1_.background_active)
            {
               return;
            }
            if(BattleManager.BATTLE_VARS.ORIGINAL_BATTLE_BACKGROUND == BattleManager.BATTLE_VARS.BATTLE_BACKGROUND)
            {
               return;
            }
            BattleManager.BATTLE_VARS.BATTLE_BACKGROUND = BattleManager.BATTLE_VARS.ORIGINAL_BATTLE_BACKGROUND;
            _loc1_.background_active = false;
            activeBackgroundModel = null;
            BattleManager.loadBackground();
         }
      }
      
      public function decreaseDamageByEffect(param1:int, param2:Object, param3:* = null) : *
      {
         var _loc4_:int = int(param2.amount);
         if(param2.effect == "stealth" && (!("no_protect" in param2) || param2.no_protect == false))
         {
            param2.no_protect = true;
            if((_loc4_ = int(param2.amount_protection)) == 100)
            {
               BattleVars.SHOW_DAMAGE_ZERO = true;
            }
         }
         if(param2.effect == "unyielding")
         {
            BattleVars.SHOW_DAMAGE_ZERO = false;
            param1 -= Math.floor(param1 * 100 / 100);
         }
         if(param2.effect == "plus_protection")
         {
            if(param2.new_amount != undefined)
            {
               _loc4_ = int(param2.new_amount);
               if(param3 != null)
               {
                  BattleManager.getBattle().addToResetNewAmountOnNextTurn(param2,param3.getPlayerTeam(),param3.getPlayerNumber());
               }
               else
               {
                  param2.new_amount = undefined;
               }
            }
         }
         if(param2.calc_type == "percent")
         {
            param1 -= Math.floor(param1 * _loc4_ / 100);
         }
         else
         {
            param1 -= _loc4_;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         return param1;
      }
      
      public function increaseDamageByEffect(param1:int, param2:Object) : *
      {
         if(param2.effect == "chill")
         {
            if(param2.calc_type == "percent")
            {
               param1 += Math.floor(param1 * param2.bleeding_amount / 100);
            }
            else
            {
               param1 += param2.bleeding_amount;
            }
         }
         else if(param2.calc_type == "percent")
         {
            param1 += Math.floor(param1 * param2.amount / 100);
         }
         else
         {
            param1 += param2.amount;
         }
         return param1;
      }
      
      public function addElementalDamage(param1:int, param2:int, param3:Object) : int
      {
         var _loc5_:Object;
         var _loc4_:Object;
         var _loc6_:int = (_loc5_ = (_loc4_ = this.getCurrentModel()).character_manager).getWindAttributes();
         var _loc7_:int = _loc5_.getFireAttributes();
         var _loc8_:int = _loc5_.getLightningAttributes();
         var _loc9_:int = _loc5_.getEarthAttributes();
         var _loc10_:int = _loc5_.getWaterAttributes();
         var _loc11_:Object = {};
         switch(param2)
         {
            case 5:
               if(param3.player_identification == "ene_2102" || param3.player_identification == "ene_2104")
               {
                  param1 += param1;
               }
               break;
            case 6:
               if(param3.player_identification == "ene_2103")
               {
                  param1 /= 2;
               }
               else if(param3.player_identification == "ene_2106" || param3.player_identification == "ene_2105")
               {
                  param1 += param1;
               }
               break;
            case 7:
               if(param3.player_identification == "ene_2102")
               {
                  param1 /= 2;
               }
         }
         return param1;
      }
      
      public function reviveTeammates(param1:Object) : *
      {
         var _loc2_:* = this.getCurrentModel();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = int(param1.revive_prc);
         var _loc6_:int = int(param1.revive_sacrifice_prc);
         var _loc7_:int = 0;
         var _loc8_:* = null;
         if(this.user_team == "player")
         {
            while(_loc7_ < BattleManager.getBattle().character_team_players.length)
            {
               _loc8_ = BattleManager.getBattle().character_team_players[_loc7_];
               if(_loc2_ == _loc8_)
               {
                  BattleVars.CHARACTER_TEAM_REVIVED[_loc7_] = true;
                  _loc8_.health_manager.reduceHealth(Math.floor(_loc8_.health_manager.getCurrentHP() * _loc6_ / 100),"Revive HP -");
               }
               else if(_loc8_.health_manager.getCurrentHP() <= 0)
               {
                  _loc8_.effects_manager.purifyPlayer("");
                  _loc3_ = Math.floor(_loc8_.health_manager.getMaxHP() * _loc5_ / 100);
                  _loc4_ = Math.floor(_loc8_.health_manager.getMaxCP() * _loc5_ / 100);
                  _loc8_.health_manager.addHealth(_loc3_,"Revived HP +");
                  _loc8_.health_manager.addCP(_loc4_,"Revived CP +");
                  _loc8_.health_manager.play_dead_animation = false;
                  _loc8_.health_manager.played_dead_animation = false;
                  if(_loc8_.isCharacter())
                  {
                     _loc8_.gotoAndPlay("standby");
                  }
                  else
                  {
                     _loc8_.standByFrameEnd();
                  }
               }
               _loc7_++;
            }
         }
         else if(this.user_team == "enemy")
         {
            while(_loc7_ < BattleManager.getBattle().enemy_team_players.length)
            {
               _loc8_ = BattleManager.getBattle().enemy_team_players[_loc7_];
               if(_loc2_ == _loc8_)
               {
                  BattleVars.ENEMY_TEAM_REVIVED[_loc7_] = true;
                  _loc8_.health_manager.reduceHealth(Math.floor(_loc8_.health_manager.getCurrentHP() * _loc6_ / 100),"Revive HP -");
               }
               else if(_loc8_.health_manager.getCurrentHP() <= 0)
               {
                  _loc3_ = Math.floor(_loc8_.health_manager.getMaxHP() * _loc5_ / 100);
                  _loc4_ = Math.floor(_loc8_.health_manager.getMaxCP() * _loc5_ / 100);
                  _loc8_.health_manager.addHealth(_loc3_,"Revived HP +");
                  _loc8_.health_manager.addCP(_loc4_,"Revived CP +");
                  _loc8_.health_manager.play_dead_animation = false;
                  _loc8_.health_manager.played_dead_animation = false;
                  if(_loc8_.isCharacter())
                  {
                     _loc8_.gotoAndPlay("standby");
                  }
                  else
                  {
                     _loc8_.object_mc.standByFrameEnd();
                  }
               }
               _loc7_++;
            }
         }
      }
      
      public function shuffleArray(param1:Array) : Array
      {
         var _loc2_:Number = 0;
         var _loc3_:Array = new Array(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = NumberUtil.randomInt(0,param1.length - 1);
            _loc3_[_loc4_] = param1[_loc2_];
            param1.splice(_loc2_,1);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function isTalentBuff(param1:String) : *
      {
         var _loc2_:Array = ["unyielding","titan_mode","overload_mode","taijutsu_strengthen","extreme_mode","increase_silhouette_chance","lava_shield","illuminated_chakra_mode"];
         return Util.in_array(param1,_loc2_);
      }
      
      public function checkIncreaseElementCooldown(param1:String) : int
      {
         var _loc2_:Array = ["increase_wind_cd","increase_fire_cd","increase_lightning_cd","increase_earth_cd","increase_water_cd"];
         return _loc2_.indexOf(param1) + 1;
      }
      
      private function handleInstantEffect(param1:Object, param2:Object) : void
      {
         var attacker:Object = null;
         var defender:Object = null;
         var masterModel:Object = null;
         var amount:int = 0;
         var currentHP:int = 0;
         var maxHP:int = 0;
         var amountHP:int = 0;
         var amountCP:int = 0;
         var effectEnemy:Vector.<Object> = null;
         var elementIndex:int = 0;
         var display:String = null;
         var target:Object = null;
         var model_buff:Vector.<Object> = null;
         var extra_hp:Object = null;
         var message:String = null;
         var totalAmount:int = 0;
         var isMasterBuff:Boolean = false;
         var totalDamage:int = 0;
         var targetMaxHP:* = undefined;
         var buff:Object = null;
         var effect:Object = param1;
         var model:Object = param2;
         var getIncreaseHeal:Function = function(param1:Object, param2:int):int
         {
            var _loc3_:int = !!param1.isCharacter() ? int(param1.character_manager.getWaterAttributes()) : 0;
            var _loc4_:int = 0;
            if(_loc3_ > 0)
            {
               _loc4_ = Math.round(param2 * _loc3_ / 100);
            }
            return _loc4_;
         };
         var recoverHealthFromHpReduction:Function = function(param1:Object):void
         {
            var _loc2_:Number = param1.effects_manager.getRecoverWhenHPReducedByTalent();
            if(_loc2_ > 0)
            {
               param1.health_manager.addHealth(_loc2_);
            }
         };
         var getDrainTarget:Function = function(param1:Object, param2:Object, param3:Object):Object
         {
            return param1.effect.split("_")[0] == "pet" ? param3 : param2;
         };
         var handlePetOceanAtmosphere:Function = function(param1:*, param2:*, param3:*):*
         {
            var _loc4_:Object = param2.effects_manager;
            param1.effect = "ocean_atmosphere";
            _loc4_.addBuff(param1);
            _loc4_.checkAddHealthAfterGotBuff();
            _loc4_.checkAddCPAfterGotBuff();
         };
         var addEffect:Function = function(param1:Object, param2:Object, param3:String):*
         {
            if(param3 == "buff")
            {
               param2.effects_manager.addBuff(param1);
            }
            else
            {
               param2.effects_manager.addDebuff(param1);
            }
         };
         var handlePetFlameEater:Function = function(param1:*, param2:*):*
         {
            if(Boolean(param2.effects_manager.hadEffect("burn")) || Boolean(param2.effects_manager.hadEffect("pet_burn")))
            {
               param2.effects_manager.getEffect("burn").duration = 0;
               param2.effects_manager.getEffect("pet_burn").duration = 0;
               param1.new_amount_percent = true;
               param2.health_manager.reduceHpFromDebuff(param1,"HP -");
               Effects.showEffectInfo(param2.effects_manager.user_team,param2.effects_manager.user_number,"Flame Eater",false);
            }
            else
            {
               param2.health_manager.reduceHpFromDebuff(param1,"HP -");
            }
         };
         var handleInstantReduceHp:Function = function(param1:*, param2:*):*
         {
            var _loc3_:Boolean = false;
            var _loc4_:Object = null;
            _loc3_ = param2.effects_manager.hadEffect("slow");
            _loc4_ = !!_loc3_ ? param2.effects_manager.getEffect("slow") : null;
            if(_loc3_ && _loc4_ != null && "oil_increase" in _loc4_ && Boolean(_loc4_.oil_increase) && "oil_increase" in param1)
            {
               param1.amount = param1.oil_increase;
               param2.effects_manager.removeEffect("slow");
            }
            param2.health_manager.reduceHpFromDebuff(param1,"Reduce HP -");
            if("amount_cp" in param1 && int(param1.amount_cp) > 0)
            {
               param2.health_manager.reduceCPFromDebuff(param1,"Reduce CP -");
            }
         };
         attacker = BattleManager.getBattle().getAttacker();
         defender = BattleManager.getBattle().getDefender();
         masterModel = BattleManager.getBattle().master_model;
         amount = 0;
         currentHP = 0;
         maxHP = 0;
         amountHP = 0;
         amountCP = 0;
         switch(effect.effect)
         {
            case "sacrifice_hp_random_buff":
               this.handleSacrificeHPRandomBuff(model,effect);
               break;
            case "steal_buff":
               effectEnemy = model.effects_manager.dataBuff;
               attacker.effects_manager.dataBuff = attacker.effects_manager.dataBuff.concat(effectEnemy);
               model.effects_manager.dataBuff = new Vector.<Object>();
               Effects.showEffectInfo(this.user_team,this.user_number,"Steal Buff");
               break;
            case "instant_kill":
               model.health_manager.reduceHealth(model.health_manager.getCurrentHP(),"Instant Kill -");
               model.health_manager.createDisplay("EZ");
               break;
            case "add_debuff_duration":
               model.effects_manager.handleAddDebuffDuration(effect);
               break;
            case "add_buff_duration":
               model.effects_manager.handleAddBuffDuration(effect);
               break;
            case "kill_instant_under":
               currentHP = model.health_manager.getCurrentHP();
               maxHP = model.health_manager.getMaxHP();
               if(currentHP < Math.floor(maxHP * effect.amount / 100))
               {
                  model.health_manager.reduceHealth(currentHP,"Instant Kill -");
               }
               break;
            case "increase_wind_cd":
            case "increase_fire_cd":
            case "increase_lightning_cd":
            case "increase_earth_cd":
            case "increase_water_cd":
               elementIndex = this.checkIncreaseElementCooldown(effect.effect);
               if(model.isCharacter())
               {
                  model.actions_manager.increaseSkillTypeCds(effect.amount,elementIndex);
               }
               break;
            case "revive_teammates":
               this.reviveTeammates(effect);
               break;
            case "debuff_clear":
               this.purifyPlayer("Purify","sensation");
               break;
            case "self_disperse_all":
               BattleVars.IS_DISPERSED = true;
               model.effects_manager.clearAllEffect();
               model.health_manager.createDisplay("Purify");
               model.effects_manager.resetMaxStats(model);
               model.effects_manager.checkBackgroundChangeFinish();
               break;
            case "pet_ocean_atmosphere":
               handlePetOceanAtmosphere(effect,model,NumberUtil.getRandomInt());
               break;
            case "add_cooldown":
               if(model.isCharacter())
               {
                  model.actions_manager.viceRapidCooldown(effect.amount + 1,"Cooldown + ");
               }
               else
               {
                  model.viceRapidCooldown(effect.amount + 1,"Cooldown + ");
               }
               break;
            case "add_cooldown_player":
               if(model.isCharacter())
               {
                  model.actions_manager.viceRapidCooldown(effect.amount + 1,"Cooldown + ");
               }
               break;
            case "reduce_cd":
            case "rapid_cooldown":
            case "pet_rapid_cooldown":
               model.actions_manager.rewindCooldown(effect.amount,"Reduce CD " + effect.amount);
               this.checkAddHealthAfterGotBuff();
               this.checkAddCPAfterGotBuff();
               break;
            case "attack_reduce_gen_cooldown":
               model.actions_manager.rapidGenjutusuCooldown(effect.amount);
               this.checkAddHealthAfterGotBuff();
               this.checkAddCPAfterGotBuff();
               break;
            case "pet_oil_bottle":
               model.resetCooldowns();
               Effects.showEffectInfo(model.effects_manager.user_team,model.effects_manager.user_number,"Reset Cooldown");
               break;
            case "pet_flame_eater":
               handlePetFlameEater(effect,model);
               break;
            case "pet_reduce_cd_random":
               model.actions_manager.reduceRandomSkillCoolDown(effect.amount);
               Effects.showEffectInfo(model.effects_manager.user_team,model.effects_manager.user_number,"Reduce Cooldown",false);
               break;
            case "random_add_cooldown":
            case "pet_random_add_cooldown":
            case "oblivion":
               display = "Add Cooldown";
               if(effect.effect == "oblivion")
               {
                  display = "Oblivion";
               }
               if(model.isCharacter())
               {
                  model.actions_manager.randomOblivion(effect.amount,display);
               }
               else
               {
                  model.randomOblivion(effect.amount,display);
               }
               break;
            case "set_all_cooldown":
               if(model.isCharacter())
               {
                  model.actions_manager.setCooldownFromEffect(effect.amount,"Add Cooldown");
               }
               break;
            case "set_single_cooldown":
               if(model.isCharacter())
               {
                  model.actions_manager.setSingleCooldownFromEffect(effect.amount,"Add Cooldown");
               }
               break;
            case "sacrifice_self_health":
               currentHP = model.health_manager.getCurrentHP();
               amount = effect.amount;
               if(effect.calc_type == "percent")
               {
                  if(effect.reduce_type == "MAX")
                  {
                     maxHP = model.health_manager.getMaxHP();
                     amount = Math.floor(maxHP * effect.amount / 100);
                  }
                  else
                  {
                     amount = Math.floor(currentHP * effect.amount / 100);
                  }
               }
               else
               {
                  amount = effect.amount;
               }
               if(amount >= currentHP)
               {
                  amount = currentHP - 1;
               }
               if(amount < 0)
               {
                  amount = 0;
               }
               model.health_manager.reduceHealth(amount,"Sacrifice -");
               break;
            case "instant_reduce_cp":
            case "insta_reduce_max_cp":
            case "drain_cp_injury":
               recoverHealthFromHpReduction(attacker);
               if(this.checkInstantProtection(model,effect))
               {
                  break;
               }
               model.health_manager.reduceCPFromDebuff(effect,"Reduce CP -");
               break;
            case "toad_fire":
               handleInstantReduceHp(effect,model);
               break;
            case "instant_reduce_hp":
            case "insta_reduce_max_hp":
               if(this.checkInstantProtection(model,effect))
               {
                  break;
               }
               model.health_manager.reduceHpFromDebuff(effect,"Reduce HP -");
               break;
            case "instant_drain_sp":
               this.drainSP(effect,attacker,model);
               break;
            case "absorb_hp_to_sp":
               this.absorbHpToSP(model,attacker,effect);
               break;
            case "insta_reduce_max_hpcp":
               recoverHealthFromHpReduction(attacker);
               if(this.checkInstantProtection(model,effect))
               {
                  break;
               }
               model.health_manager.reduceHpFromDebuff(effect,"Reduce HP -");
               model.health_manager.reduceCPFromDebuff(effect,"Reduce CP -");
               break;
            case "plague":
               model.health_manager.reduceHpFromDebuff(effect,"Plague HP -");
               model.health_manager.reduceCPFromDebuff(effect,"Plague CP -");
               break;
            case "insta_drain_hp":
            case "drain_hp_with_attack":
            case "current_hp_drain":
            case "hp_drain":
            case "pet_hp_drain":
               target = getDrainTarget(effect,attacker,masterModel);
               this.drainHP(model,target,effect);
               break;
            case "insta_drain_cp":
            case "current_cp_drain":
            case "drain_cp_with_attack":
            case "cp_drain":
            case "drain_cp_stun":
            case "pet_cp_drain":
               target = getDrainTarget(effect,attacker,masterModel);
               recoverHealthFromHpReduction(target);
               this.drainCP(model,target,effect);
               break;
            case "drain_HpCp":
            case "pet_drain_HpCp":
               target = getDrainTarget(effect,attacker,masterModel);
               recoverHealthFromHpReduction(target);
               this.drainHP(model,target,effect);
               this.drainCP(model,target,effect);
               break;
            case "shield":
               model.health_manager.createDisplay("Shield: " + effect.amount.toString());
               model.health_manager.amount_shield = effect.amount;
               break;
            case "senju_mark":
               model.health_manager.createDisplay("Shield of Senju: " + effect.amount.toString());
               model.health_manager.amount_shield = effect.amount;
               break;
            case "increase_buff_duration":
               model_buff = model.effects_manager.dataBuff;
               for each(buff in model_buff)
               {
                  buff.duration += effect.amount;
               }
               Effects.displayEffect(model,effect);
               break;
            case "heal":
            case "pet_heal":
            case "kira_kuin":
               amount = effect.amount;
               extra_hp = new Object();
               if(effect.calc_type == "percent")
               {
                  amount = Math.floor(model.health_manager.getMaxHP() * amount / 100);
               }
               if((extra_hp = this.getEffect("plus_extra_hp")).duration > 0)
               {
                  amount += Math.floor(amount * extra_hp.amount / 100);
               }
               amount += getIncreaseHeal(model,amount);
               model.health_manager.addHealth(amount,"HealMC ");
               break;
            case "recover_hp_cp":
            case "hpcp_up":
               amountHP = 0;
               amountCP = 0;
               if("checkSageMode" in effect && model.effects_manager.hadEffect("sage_mode"))
               {
                  effect.amount += 15;
               }
               if(effect.calc_type == "percent")
               {
                  amountHP = Math.floor(model.health_manager.getMaxHP() * effect.amount / 100);
                  amountCP = Math.floor(model.health_manager.getMaxCP() * effect.amount / 100);
               }
               else
               {
                  amountHP = effect.amount;
                  amountCP = effect.amount;
               }
               amountHP += getIncreaseHeal(model,amountHP);
               model.health_manager.addHealth(amountHP,"Recover HP +");
               model.health_manager.addCP(amountCP,"Recover CP +");
               break;
            case "recover_hp":
            case "wellness":
               amount = effect.amount;
               if(effect.calc_type == "percent")
               {
                  amount = Math.floor(model.health_manager.getMaxHP() * effect.amount / 100);
               }
               amount += getIncreaseHeal(model,amount);
               model.health_manager.addHealth(amount,"Recover HP +");
               break;
            case "recover_cp":
               amount = effect.amount;
               if(effect.calc_type == "percent")
               {
                  amount = Math.floor(model.health_manager.getMaxCP() * effect.amount / 100);
               }
               model.health_manager.addCP(amount,"Recover CP +");
               break;
            case "instant_cp_recover":
               message = "Insta Recover CP +";
               amount = int(effect.amount);
               totalAmount = 0;
               target = "is_master_buff" in effect && masterModel != null ? masterModel : model;
               switch(effect.effect_name)
               {
                  case "Attack Recover CP":
                     message = "CP +";
                     break;
                  case "Stubborn Recover CP":
                     message = "Stubborn Recover CP +";
                     totalAmount = BattleManager.getTotalDamage();
                     break;
                  default:
                     totalAmount = target.health_manager.getMaxCP();
               }
               if(effect.calc_type == "percent")
               {
                  amount = Math.floor(totalAmount * amount / 100);
               }
               target.health_manager.addCP(amount,message);
               break;
            case "instant_hp_recover":
               message = "Insta Recover HP +";
               amount = effect.amount;
               isMasterBuff = "is_master_buff" in effect;
               totalDamage = 0;
               target = isMasterBuff == true && masterModel != null ? masterModel : model;
               targetMaxHP = target.health_manager.getMaxHP();
               if(effect.effect_name == "Attack Recover HP")
               {
                  message = "HP +";
               }
               amount = int(effect.amount);
               if(effect.calc_type == "percent")
               {
                  amount = Math.floor(targetMaxHP * amount / 100);
               }
               amount += getIncreaseHeal(model,amount);
               target.health_manager.addHealth(amount,message);
               break;
            case "insta_consume_all_cp":
               model.health_manager.reduceCP(model.health_manager.getMaxCP(),"CP -");
               break;
            case "lock":
               currentHP = int(model.health_manager.getCurrentHP());
               maxHP = int(model.health_manager.getMaxHP());
               if(currentHP >= Math.ceil(maxHP / 2))
               {
                  effect.effect = "weaken";
                  effect.calc_type = "percent";
                  effect.duration = effect.duration;
                  effect.amount = effect.amount;
               }
               else
               {
                  effect.effect = "locked";
                  effect.add_in_array = true;
                  effect.duration = effect.duration;
               }
               model.effects_manager.addDebuff(effect);
               break;
            case "double_cp_consumption":
               effect.effect = "cp_cost";
               this.addDebuff(effect);
               break;
            case "damage_to_hp":
               if(defender.IS_DODGED)
               {
                  return;
               }
               amount = Math.floor(BattleManager.getTotalDamage() * effect.amount / 100);
               model.health_manager.addHealth(amount,"Convert +");
               break;
         }
      }
      
      public function handlingTransform(param1:int) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = this.getCurrentModel();
         if(this.hadEffect("transform"))
         {
            _loc3_ = this.getEffect("transform");
            _loc4_ = NumberUtil.getRandomInt();
            _loc5_ = _loc3_.amount;
            if(_loc3_.calc_type == "percent")
            {
               _loc5_ = param1 * _loc5_ / 100;
            }
            _loc2_.health_manager.reduceCP(_loc5_,"Transform -");
         }
      }
      
      public function drainHP(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:Number = NaN;
         _loc4_ = undefined;
         if("switch_att_def" in param3 && Boolean(param3.switch_att_def))
         {
            _loc4_ = param1;
            param1 = param2;
            param2 = _loc4_;
         }
         _loc5_ = int(param1.health_manager.getCurrentHP());
         _loc6_ = int(param1.health_manager.getMaxHP());
         _loc7_ = int(param2.health_manager.getCurrentHP());
         var _loc8_:int = int(param2.health_manager.getMaxHP());
         _loc9_ = param3.reduce_type == "MAX" ? true : false;
         _loc10_ = Math.floor(param3.amount * _loc5_ / 100);
         if(_loc9_ && param3.effect.indexOf("current") == -1)
         {
            _loc10_ = Math.floor(param3.amount * _loc6_ / 100);
         }
         if(_loc7_ > 0)
         {
            if(!((_loc11_ = param2.effects_manager).hadEffect("unyielding") || _loc11_.hadEffect("negate")))
            {
               param2.health_manager.addHealth(_loc10_,"HP Drain +");
            }
            else
            {
               param2.health_manager.createDisplay("Buff Resisted");
            }
            if(param1.effects_manager.hadEffect("unyielding_soul"))
            {
               param1.health_manager.createDisplay("Parried!");
               _loc10_ = 0;
            }
            param1.health_manager.reduceHealth(_loc10_,"HP Drain -");
            if(_loc10_ > 0)
            {
               if((_loc12_ = param2.effects_manager.getRecoverWhenHPReducedByTalent()) > 0)
               {
                  param2.health_manager.addHealth(_loc12_);
               }
            }
         }
      }
      
      public function drainCP(param1:*, param2:*, param3:Object) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         _loc4_ = undefined;
         if("switch_att_def" in param3 && Boolean(param3.switch_att_def))
         {
            _loc4_ = param1;
            param1 = param2;
            param2 = _loc4_;
         }
         _loc5_ = int(param1.health_manager.getCurrentCP());
         _loc6_ = int(param1.health_manager.getMaxCP());
         _loc7_ = param3.reduce_type == "MAX" ? true : false;
         _loc8_ = Math.floor(param3.amount * _loc5_ / 100);
         if(_loc7_)
         {
            _loc8_ = Math.floor(param3.amount * _loc6_ / 100);
         }
         if(!((_loc9_ = param2.effects_manager).hadEffect("unyielding") || _loc9_.hadEffect("negate")))
         {
            param2.health_manager.addCP(_loc8_,"CP Drain +");
         }
         else
         {
            param2.health_manager.createDisplay("Buff Resisted");
         }
         if(param1.effects_manager.hadEffect("unyielding_soul"))
         {
            param1.health_manager.createDisplay("Parried!");
            _loc8_ = 0;
         }
         if(param3.effect == "drain_cp_stun")
         {
            param3.amount = _loc8_;
            param1.health_manager.reduceCPFromDebuff(param3,"CP Drain -");
         }
         else
         {
            param1.health_manager.reduceCP(_loc8_,"CP Drain -");
         }
      }
      
      public function drainSP(param1:*, param2:*, param3:Object) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc4_ = undefined;
         if("switch_att_def" in param3 && Boolean(param3.switch_att_def))
         {
            _loc4_ = param1;
            param1 = param2;
            param2 = _loc4_;
         }
         _loc5_ = param1.health_manager.getCurrentSP();
         if((_loc6_ = param1.health_manager.getMaxSP()) == 0)
         {
            return;
         }
         var _loc7_:int = param2.health_manager.getCurrentSP();
         var _loc8_:int = param2.health_manager.getMaxSP();
         var _loc9_:Boolean = param3.reduce_type == "MAX" ? true : false;
         _loc11_ = (_loc10_ = Math.floor(param3.amount * _loc5_ / 100)) / 2;
         param2.health_manager.addSP("Drain SP +",_loc11_);
         if(this.checkInstantProtection(param1,param3))
         {
            return;
         }
         param1.health_manager.reduceSP(_loc10_,"Drain SP -");
      }
      
      public function absorbHpToSP(param1:*, param2:*, param3:Object) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc4_ = undefined;
         if("switch_att_def" in param3 && Boolean(param3.switch_att_def))
         {
            _loc4_ = param1;
            param1 = param2;
            param2 = _loc4_;
         }
         _loc5_ = param1.health_manager.getCurrentHP();
         if((_loc6_ = param1.health_manager.getMaxHP()) == 0)
         {
            return;
         }
         var _loc7_:int = param2.health_manager.getCurrentSP();
         var _loc8_:int = param2.health_manager.getMaxSP();
         var _loc9_:Boolean = param3.reduce_type == "MAX" ? true : false;
         _loc11_ = (_loc10_ = Math.floor(param3.amount * _loc5_ / 100)) / 2;
         param2.health_manager.addSP("Absorb SP +",_loc11_);
         if(this.checkInstantProtection(param1,param3))
         {
            return;
         }
         param1.health_manager.reduceHealth(_loc10_,"Absorb HP -");
      }
      
      private function checkInstantProtection(param1:Object, param2:Object) : Boolean
      {
         if(param1.effects_manager.hadEffect("unyielding_soul"))
         {
            param2.amount = 0;
            param1.health_manager.createDisplay("Parried!");
            return true;
         }
         return false;
      }
      
      public function addEffect(param1:String, param2:String, param3:String, param4:int, param5:String = "", param6:int = 0, param7:int = 100, param8:String = "immediately") : void
      {
         var _loc9_:Object = null;
         (_loc9_ = new Object()).effect = param2;
         _loc9_.effect_name = param3;
         _loc9_.amount = param4;
         _loc9_.calc_type = param5;
         _loc9_.duration = param6;
         _loc9_.chance = param7;
         _loc9_.duration_deduct = param8;
         _loc9_.type = param1;
         this["add" + param1](_loc9_);
      }
      
      public function addBuff(param1:Object, param2:Object = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Boolean = false;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:* = null;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         _loc3_ = Effects.immediately_affected_effects;
         _loc5_ = (_loc4_ = param2 != null ? param2 : this.getCurrentModel()).health_manager;
         if(this.hadEffect("unyielding"))
         {
            _loc5_.createDisplay("Buff Resisted");
            return;
         }
         if(this.hadEffect("negate") && param1.effect != "sensation")
         {
            _loc5_.createDisplay("Buff Negated");
            return;
         }
         if(this.hadEffect("titan_mode") && param1.effect == "titan_mode")
         {
            return;
         }
         if(this.hadEffect("emberstep_demonic") && param1.effect == "emberstep_demonic")
         {
            return;
         }
         if(this.hadEffect("overload") && param1.effect == "overload")
         {
            return;
         }
         if(param1.effect == "defer" && this.hadEffect("fast_forward"))
         {
            _loc5_.createDisplay("Resisted");
            return;
         }
         if(_loc3_.indexOf(param1.effect) >= 0)
         {
            this.handleInstantEffect(param1,_loc4_);
            return;
         }
         for each(_loc7_ in this.getAllBuffs())
         {
            if(_loc7_.effect == param1.effect)
            {
               param1.effect_name = _loc7_.effect_name;
               break;
            }
         }
         if(param1.effect == "cp_shield" && "amount_cp_recover" in param1 && int(param1.amount_cp_recover) > 0)
         {
            param1.no_disperse = true;
         }
         if(!(_loc8_ = this.replaceEffect(param1,"Buff")))
         {
            _loc9_ = this.cloneEffect(param1);
            this.dataBuff.push(_loc9_);
         }
         if(param1.effect == "defer")
         {
            this.setupDefer(_loc4_,param1);
         }
         if(Effects.doesEffectChangeBackground(param1.effect))
         {
            if(activeBackgroundModel != null && activeBackgroundModel != _loc4_)
            {
               activeBackgroundModel.background_active = false;
            }
            _loc4_.background_active = true;
            activeBackgroundModel = _loc4_;
            this.checkBackgroundChangeFinish();
         }
         if(_loc8_)
         {
            return;
         }
         if(Effects.doesEffectIncreaseMaxHealth(param1.effect))
         {
            _loc10_ = int(_loc5_.getMaxHP());
            _loc11_ = int(_loc5_.getCurrentHP());
            _loc5_.effectAddMaxHP[param1.effect].original_hp = _loc10_;
            if(param1.effect == "slug_sage")
            {
               for(_loc12_ in _loc5_.effectAddMaxHP)
               {
                  if(_loc12_ != "slug_sage" && _loc5_.effectAddMaxHP[_loc12_].increase_hp > 0)
                  {
                     _loc5_.effectAddMaxHP[_loc12_].suppressed_hp = int(_loc5_.effectAddMaxHP[_loc12_].increase_hp);
                     _loc5_.max_hp -= int(_loc5_.effectAddMaxHP[_loc12_].increase_hp);
                     _loc5_.effectAddMaxHP[_loc12_].increase_hp = 0;
                  }
               }
               _loc5_.effectAddMaxHP.slug_sage.increase_hp = param1.amount_hp;
               _loc5_.max_hp += param1.amount_hp;
               _loc5_.setCurrentHP(_loc11_ + param1.amount_hp);
            }
            else if(_loc13_ = _loc5_.effectAddMaxHP.slug_sage != null && _loc5_.effectAddMaxHP.slug_sage.increase_hp > 0)
            {
               if(param1.calc_type == "percent")
               {
                  _loc5_.effectAddMaxHP[param1.effect].suppressed_hp = Math.floor(_loc10_ * param1.amount_hp / 100);
               }
               else
               {
                  _loc5_.effectAddMaxHP[param1.effect].suppressed_hp = param1.amount_hp;
               }
            }
            else if(param1.calc_type == "percent")
            {
               _loc5_.effectAddMaxHP[param1.effect].increase_hp = Math.floor(_loc10_ * param1.amount_hp / 100);
               _loc5_.max_hp += _loc5_.effectAddMaxHP[param1.effect].increase_hp;
               _loc5_.setCurrentHP(_loc11_ + Math.floor(_loc11_ * param1.amount_hp / 100));
            }
            else
            {
               _loc5_.effectAddMaxHP[param1.effect].increase_hp = param1.amount_hp;
               _loc5_.max_hp += param1.amount_hp;
               _loc5_.setCurrentHP(_loc11_ + param1.amount_hp);
            }
            _loc5_.updateHealthBar();
         }
         if(Effects.doesEffectIncreaseMaxCP(param1.effect))
         {
            _loc14_ = int(_loc5_.getMaxCP());
            _loc15_ = int(_loc5_.getCurrentCP());
            _loc5_.effectAddMaxCP[param1.effect].original_cp = _loc14_;
            if(param1.amount_cp > 0)
            {
               param1.amount = param1.amount_cp;
            }
            if(param1.calc_type == "percent")
            {
               _loc5_.effectAddMaxCP[param1.effect].increase_cp = Math.floor(_loc14_ * param1.amount / 100);
               _loc5_.max_cp += _loc5_.effectAddMaxCP[param1.effect].increase_cp;
               _loc5_.setCurrentCP(_loc15_ + Math.floor(_loc15_ * param1.amount / 100));
            }
            else
            {
               _loc5_.effectAddMaxCP[param1.effect].increase_cp = param1.amount;
               _loc5_.max_cp += _loc5_.effectAddMaxCP[param1.effect].increase_cp;
               _loc5_.setCurrentCP(_loc15_ + param1.amount);
            }
            if(param1.effect == "wider")
            {
               _loc5_.original_max_cp = _loc5_.max_cp;
            }
            _loc5_.updateHealthBar();
         }
         if(Effects.doesEffectIncreaseMaxSP(param1.effect))
         {
            _loc16_ = int(_loc5_.getMaxSP());
            _loc17_ = int(_loc5_.getCurrentSP());
            if(param1.calc_type == "percent")
            {
               _loc5_.effectAddMaxSP[param1.effect].increase_sp = Math.floor(_loc16_ * param1.amount / 100);
               _loc5_.max_sp += _loc5_.effectAddMaxSP[param1.effect].increase_sp;
               _loc5_.setCurrentSP(_loc17_ + _loc16_ * param1.amount / 100);
            }
            else
            {
               _loc5_.effectAddMaxSP[param1.effect].increase_sp = param1.amount;
               _loc5_.max_sp += _loc5_.effectAddMaxSP[param1.effect].increase_sp;
               _loc5_.setCurrentSP(_loc17_ + param1.amount);
            }
         }
         Effects.showEffectAdded(this.user_team,this.user_number,param1);
         _loc5_.updateHealthBar();
      }
      
      public function checkForPowerofToad(param1:*) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = this.getCurrentModel();
         if(!_loc2_.isCharacter())
         {
            return;
         }
         if(BattleVars.SKILL_USED_ID != "skill_3009")
         {
            return;
         }
         _loc3_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3009",_loc2_.character_manager.getSenjutsuLevel("skill_3009"));
         _loc6_ = (_loc5_ = (_loc4_ = _loc2_.health_manager).getMaxHP()) * (_loc3_.amount / 100);
         param1.health_manager.reduceHealth(_loc6_,"Power of Toad -");
      }
      
      public function checkForShedding() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return false;
         }
         if(!_loc1_.character_manager.hasSenjutsuSkill("skill_3107"))
         {
            return false;
         }
         _loc2_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3107",_loc1_.character_manager.getSenjutsuLevel("skill_3107"));
         var _loc3_:int = _loc2_.sp_req;
         _loc5_ = (_loc4_ = _loc1_.health_manager).getCurrentSP();
         if((_loc6_ = _loc4_.getMaxSP()) == 0)
         {
            return false;
         }
         if((_loc7_ = _loc5_ / _loc6_ * 100) > _loc2_.sp_req || _loc1_.effects_manager.hadEffect("sage_mode"))
         {
            return NumberUtil.getRandomInt() <= _loc2_.trigger_chance ? true : false;
         }
         return false;
      }
      
      public function checkForSnakeShadow(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1.effects_manager.hadEffect("snake_shadow"))
         {
            _loc2_ = param1.effects_manager.getEffect("snake_shadow");
            if(_loc2_.duration == 5 || _loc2_.duration == 3 || _loc2_.duration == 1)
            {
               param1.effects_manager.addEffect("Debuff","chaos","Chaos",0,"",_loc2_.chaos_duration,100);
            }
         }
      }
      
      public function addDebuff(param1:Object, param2:Object = null, param3:Boolean = true) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Object = null;
         var _loc14_:Array = null;
         var _loc15_:String = null;
         var _loc16_:Object = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:* = undefined;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         _loc4_ = param2 != null ? param2 : this.getCurrentModel();
         _loc6_ = Effects.immediately_affected_effects;
         _loc7_ = _loc4_.health_manager;
         if(this.hadEffect("unyielding"))
         {
            _loc7_.createDisplay("Debuff Resisted");
            return;
         }
         if(param1.effect == "random_s16")
         {
            this.checkRandomS16(param1);
            return;
         }
         if(param1.effect != "time_stop")
         {
            if(_loc4_.debuff_resist)
            {
               _loc7_.createDisplay("Crystal Resisted");
               return;
            }
            _loc14_ = ["debuff_resist","pet_debuff_resist","bless","defer"];
            for each(_loc15_ in _loc14_)
            {
               if(this.hadEffect(_loc15_))
               {
                  _loc7_.createDisplay("Debuff Resisted");
                  return;
               }
            }
         }
         if(_loc6_.indexOf(param1.effect) >= 0)
         {
            this.handleInstantEffect(param1,_loc4_);
            return;
         }
         for each(_loc8_ in this.getAllDebuffs())
         {
            if(_loc8_.effect == param1.effect)
            {
               if("add_in_array" in _loc8_ && _loc8_.add_in_array)
               {
                  param1.add_in_array = true;
               }
               param1.effect_name = _loc8_.effect_name;
               break;
            }
         }
         if(param1.effect == "vulnerable" && BattleVars.SKILL_USED_ID == "skill_3206")
         {
            param1.no_purify = true;
         }
         if(param1.effect == "cosmic_flame" && this.dataDebuff.length > 0)
         {
            _loc16_ = {
               "effect":"internal_injury",
               "effect_name":"Internal Injury",
               "duration":3,
               "amount":0,
               "calc_type":"",
               "chance":100
            };
            this.addDebuff(_loc16_);
         }
         if((_loc9_ = ["burn","inflict_burn","pet_burn","fire_wall_burn","hemorrhage","burning","ultra_burning"]).indexOf(param1.effect) >= 0 && this.isBurnImmune())
         {
            Effects.showEffectInfo(this.user_team,this.user_number,"Burn Immune");
            return;
         }
         if((_loc10_ = ["bleeding","inflict_bleeding","pet_bleeding","attacker_bleeding","pet_attacker_bleeding","bleeding_attacker","ultra_bleeding"]).indexOf(param1.effect) >= 0 && this.hadEffect("bleeding_protection"))
         {
            Effects.showEffectInfo(this.user_team,this.user_number,"Bleeding Immune");
            return;
         }
         if((_loc11_ = ["poison","inflict_poison","pet_poison"]).indexOf(param1.effect) >= 0 && this.getResistPoisonPrcByTalent())
         {
            Effects.showEffectInfo(this.user_team,this.user_number,"Poison Immune");
            return;
         }
         if((_loc12_ = ["internal_injury","hanyaoni","suffocate"]).indexOf(param1.effect) >= 0 && (this.hadEffect("vigor") || this.isInternalInjuryImmune()))
         {
            Effects.showEffectInfo(this.user_team,this.user_number,"Internal Injury Immune");
            return;
         }
         if(param1.effect === "parasite" || param1.effect === "recoil_curse")
         {
            param1.from_team = BattleManager.getBattle().attacker_model.getPlayerTeam();
            param1.from_number = BattleManager.getBattle().attacker_model.getPlayerNumber();
         }
         if((_loc11_ = ["poison","inflict_poison","pet_poison","poison_attacker"]).indexOf(param1.effect) >= 0)
         {
            BattleManager.getBattle().attacker_model.effects_manager.getChanceToInflictChaosByTalent(_loc4_);
         }
         if(this.replaceEffect(param1,"Debuff"))
         {
            return;
         }
         _loc13_ = this.cloneEffect(param1);
         this.dataDebuff.push(_loc13_);
         if(_loc13_.effect == "disable_passive_talent" && _loc4_.isCharacter())
         {
            this.is_passive_talent_disabled = true;
            _loc17_ = _loc4_.character_manager.recalculateHP();
            _loc18_ = _loc4_.character_manager.recalculateCP();
            _loc4_.character_info.character_max_hp = _loc17_;
            _loc4_.character_info.character_max_cp = _loc18_;
            _loc7_.max_hp = _loc17_;
            _loc7_.max_cp = _loc18_;
            this.reApplyMaxHPBonuses(_loc7_);
            this.reApplyMaxCPBonuses(_loc7_);
            if(_loc7_.getCurrentHP() > _loc7_.getMaxHP())
            {
               _loc7_.setCurrentHP(_loc7_.getMaxHP());
            }
            if(_loc7_.getCurrentCP() > _loc7_.getMaxCP())
            {
               _loc7_.setCurrentCP(_loc7_.getMaxCP());
            }
            _loc7_.updateHealthBar();
         }
         if(_loc13_.effect == "disable_weapon_effect" && _loc4_.isCharacter())
         {
            _loc7_.effectDecreaseMaxHP.disable_weapon_effect.original_hp = _loc7_.original_max_hp;
            _loc7_.effectDecreaseMaxCP.disable_weapon_effect.original_cp = _loc7_.original_max_cp;
            _loc7_.effectDecreaseMaxSP.disable_weapon_effect.original_sp = _loc7_.original_max_sp;
            _loc7_.max_hp = _loc4_.character_manager.recalculateHP();
            _loc7_.max_cp = _loc4_.character_manager.recalculateCP();
            _loc7_.max_sp = _loc4_.character_manager.recalculateSP();
            this.reApplyMaxHPBonuses(_loc7_);
            this.reApplyMaxCPBonuses(_loc7_);
            _loc19_ = _loc7_.getMaxHP();
            _loc20_ = _loc7_.getMaxCP();
            _loc21_ = _loc7_.getMaxSP();
            _loc7_.effectDecreaseMaxHP.disable_weapon_effect.modifier_hp = _loc7_.original_max_hp - _loc19_;
            _loc7_.effectDecreaseMaxCP.disable_weapon_effect.modifier_cp = _loc7_.original_max_cp - _loc20_;
            _loc7_.effectDecreaseMaxSP.disable_weapon_effect.modifier_sp = _loc7_.original_max_sp - _loc21_;
            if(_loc7_.getCurrentHP() > _loc7_.getMaxHP())
            {
               _loc7_.setCurrentHP(_loc7_.max_hp);
            }
            if(_loc7_.getCurrentCP() > _loc7_.getMaxCP())
            {
               _loc7_.setCurrentCP(_loc7_.max_cp);
            }
            if(_loc7_.getCurrentSP() > _loc7_.getMaxSP())
            {
               _loc7_.setCurrentSP(_loc7_.max_sp);
            }
            _loc7_.updateHealthBar();
         }
         if(Effects.doesEffectDecreaseMaxHPAndCP(param1.effect))
         {
            _loc22_ = _loc7_.getCurrentCP();
            _loc23_ = _loc7_.getMaxCP();
            if(param1.calc_type == "percent")
            {
               _loc7_.effectDecreaseMaxCP.decrease_max_hpcp.modifier_cp = Math.floor(_loc23_ * param1.amount / 100);
            }
            else
            {
               _loc7_.effectDecreaseMaxCP.decrease_max_hpcp.modifier_cp = _loc23_ - param1.amount;
            }
            _loc24_ = _loc7_.getCurrentHP();
            _loc25_ = _loc7_.getMaxHP();
            if(param1.calc_type == "percent")
            {
               _loc7_.effectDecreaseMaxHP.decrease_max_hpcp.modifier_hp = Math.floor(_loc25_ * param1.amount / 100);
            }
            else
            {
               _loc7_.effectDecreaseMaxHP.decrease_max_hpcp.modifier_hp = _loc25_ - param1.amount;
            }
            _loc7_.max_cp -= _loc7_.effectDecreaseMaxCP.decrease_max_hpcp.modifier_cp;
            _loc7_.max_hp -= _loc7_.effectDecreaseMaxHP.decrease_max_hpcp.modifier_hp;
            if(_loc7_.getCurrentCP() > _loc7_.getMaxCP())
            {
               _loc7_.setCurrentCP(_loc7_.getMaxCP());
            }
            if(_loc7_.getCurrentHP() > _loc7_.getMaxHP())
            {
               _loc7_.setCurrentHP(_loc7_.getMaxHP());
            }
            _loc7_.updateHealthBar();
         }
         if(Effects.doesEffectDecreaseMaxCP(param1.effect))
         {
            _loc22_ = _loc7_.getCurrentCP();
            _loc23_ = _loc7_.getMaxCP();
            if(param1.calc_type == "percent")
            {
               _loc7_.status_change.decrease_cp = Math.floor(_loc23_ * param1.amount / 100);
            }
            else
            {
               _loc7_.status_change.decrease_cp = _loc23_ - param1.amount;
            }
            _loc7_.max_cp -= _loc7_.status_change.decrease_cp;
            if(_loc7_.getCurrentCP() > _loc7_.getMaxCP())
            {
               _loc7_.setCurrentCP(_loc7_.getMaxCP());
            }
            _loc7_.updateHealthBar();
         }
         if(Effects.doesEffectDecreaseMaxHP(param1.effect))
         {
            _loc24_ = _loc7_.getCurrentHP();
            _loc25_ = _loc7_.getMaxHP();
            if(param1.calc_type == "percent")
            {
               _loc7_.status_change.decrease_hp = Math.floor(_loc25_ * param1.amount / 100);
            }
            else
            {
               _loc7_.status_change.decrease_hp = _loc25_ - param1.amount;
            }
            _loc7_.max_hp -= _loc7_.status_change.decrease_hp;
            if(param1.effect == "unwell")
            {
               _loc7_.effectDecreaseMaxHP.unwell.modifier_hp = _loc7_.status_change.decrease_hp;
               _loc7_.original_max_hp = _loc7_.max_hp;
            }
            if(_loc7_.getCurrentHP() > _loc7_.getMaxHP())
            {
               _loc7_.setCurrentHP(_loc7_.getMaxHP());
            }
            _loc7_.updateHealthBar();
         }
         if(Effects.doesEffectDecreaseSP(param1.effect))
         {
            _loc26_ = _loc7_.getCurrentSP();
            _loc27_ = _loc7_.getMaxSP();
            if(param1.calc_type == "percent")
            {
               _loc7_.status_change.decrease_sp = Math.floor(_loc27_ * param1.amount / 100);
            }
            else
            {
               _loc7_.status_change.decrease_sp = _loc27_ - param1.amount;
            }
            _loc7_.max_sp -= _loc7_.status_change.decrease_sp;
            if(_loc7_.getCurrentSP() > _loc7_.getMaxSP())
            {
               _loc7_.setCurrentSP(_loc7_.getMaxSP());
            }
            _loc7_.updateHealthBar();
         }
         if(param1.effect === "meridian_cut_off" || param1.effect === "pet_meridian_cut_off")
         {
            _loc22_ = _loc7_.getCurrentCP();
            _loc23_ = _loc7_.getMaxCP();
            _loc7_.max_cp = Math.floor(_loc23_ * param1.amount / 100);
            if(_loc22_ > _loc7_.max_cp)
            {
               _loc7_.setCurrentCP(_loc7_.max_cp);
            }
            _loc7_.updateHealthBar();
         }
         if(param1.effect === "decrease_max_cp")
         {
            param1.amount_change = param1.amount_change;
         }
         Effects.showEffectAdded(this.user_team,this.user_number,param1);
      }
      
      private function cloneEffect(param1:Object) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         var _loc4_:String = null;
         _loc2_ = new Object();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         if((_loc4_ = Effects.getEffectDeductType(_loc2_.effect)) === "after_attack" && (!_loc2_.hasOwnProperty("no_duration_increment") || !_loc2_.no_duration_increment))
         {
            ++_loc2_.duration;
         }
         return _loc2_;
      }
      
      private function replaceEffect(param1:Object, param2:String) : Boolean
      {
         var _loc3_:Vector.<Object> = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         _loc3_ = this["data" + param2];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc5_ = _loc3_[_loc4_]).effect == param1.effect)
            {
               for(_loc6_ in param1)
               {
                  _loc5_[_loc6_] = param1[_loc6_];
               }
               _loc5_.chaos_duration = !!param1.hasOwnProperty("chaos_duration") ? param1.chaos_duration : 0;
               _loc5_.oil_increase = !!param1.hasOwnProperty("oil_increase") ? param1.oil_increase : false;
               _loc5_.duration = param1.hasOwnProperty("add_in_array") || param1.hasOwnProperty("passive") && param1.passive == true ? param1.duration : param1.duration + 1;
               _loc3_.push(_loc3_.splice(_loc4_,1)[0]);
               Effects.showEffectAdded(this.user_team,this.user_number,param1);
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function handleAddDebuffDuration(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         _loc2_ = this.getActiveDebuff();
         _loc3_ = NumberUtil.getRandomInt();
         if(param1.chance >= _loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_[1].length)
            {
               if((_loc5_ = _loc2_[0][_loc2_[1][_loc4_]]) != null)
               {
                  _loc5_.duration += param1.amount;
               }
               _loc4_++;
            }
         }
      }
      
      public function handleAddBuffDuration(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         _loc2_ = this.getActiveBuff();
         _loc3_ = NumberUtil.getRandomInt();
         if(param1.chance >= _loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_[1].length)
            {
               if((_loc5_ = _loc2_[0][_loc2_[1][_loc4_]]) != null)
               {
                  _loc5_.duration += param1.amount;
               }
               _loc4_++;
            }
         }
      }
      
      public function showActiveEffects() : String
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc8_:Vector.<Object> = null;
         var _loc9_:* = undefined;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         _loc1_ = [];
         _loc2_ = "";
         _loc3_ = false;
         _loc4_ = false;
         _loc5_ = false;
         _loc6_ = false;
         var _loc7_:* = this.getCurrentModel();
         _loc8_ = this.getActiveEffects();
         for each(_loc9_ in _loc8_)
         {
            _loc1_ = this.handleEffectIfImmediately(_loc9_,_loc1_);
            if(_loc9_.duration < 1)
            {
               _loc9_.duration = 0;
            }
            else
            {
               _loc10_ = Util.checkInArray(_loc9_.effect,Effects.dont_need_to_show);
               _loc11_ = Util.checkInArray(_loc9_.effect,Effects.dont_need_show_duration);
               _loc12_ = Util.checkInArray(_loc9_.effect,Effects.need_to_show_minus_duration);
               if(!_loc10_)
               {
                  _loc13_ = _loc9_.effect_name;
                  if(_loc11_)
                  {
                     _loc13_ = _loc9_.effect_name;
                  }
                  else if(_loc12_)
                  {
                     if((_loc14_ = _loc9_.duration - 1) <= 0)
                     {
                        continue;
                     }
                     _loc9_.shown_duration = _loc14_;
                     _loc13_ += " " + _loc14_;
                  }
                  else
                  {
                     _loc9_.shown_duration = _loc9_.duration;
                     _loc13_ += " " + _loc9_.duration;
                  }
                  if(Effects.doesEffectSkipTurns(_loc9_.effect))
                  {
                     _loc3_ = true;
                  }
                  Effects.showEffectInfo(this.user_team,this.user_number,_loc13_,false);
               }
            }
         }
         if(this.dataBuff.length > 0)
         {
            this.checkAddHealthAfterGotBuff();
            this.checkAddCPAfterGotBuff();
         }
         if(this.dataDebuff.length > 0)
         {
            this.checkAddHealthAfterGotDebuff();
            this.checkAddCPAfterGotDebuff();
         }
         if(_loc1_.length > 0)
         {
            _loc15_ = 0;
            while(_loc15_ < _loc1_.length)
            {
               _loc2_ = _loc1_[_loc15_];
               if(Effects.doesEffectSkipTurns(_loc1_[_loc15_]))
               {
                  _loc3_ = true;
               }
               else if(_loc2_ == "chaos" || _loc2_ == "pet_chaos")
               {
                  _loc4_ = true;
               }
               else if(_loc2_ == "barrier")
               {
                  _loc5_ = true;
               }
               else if(_loc2_ == "meridian_seal" || _loc2_ == "pet_meridian_seal")
               {
                  _loc6_ = true;
               }
               _loc15_++;
            }
         }
         if(_loc3_)
         {
            _loc2_ = "stun";
         }
         else if(_loc4_)
         {
            _loc2_ = "chaos";
         }
         else if(_loc5_)
         {
            _loc2_ = "barrier";
         }
         else if(_loc6_)
         {
            _loc2_ = "meridian_seal";
         }
         return _loc2_;
      }
      
      public function checkPassiveEffects() : *
      {
         var _loc1_:Object = null;
         var _loc2_:CharacterManager = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Array = null;
         var _loc17_:Object = null;
         _loc1_ = this.getCurrentModel();
         if(!("character_manager" in _loc1_))
         {
            return;
         }
         _loc2_ = _loc1_.character_manager;
         _loc3_ = _loc2_.getWeapon();
         _loc4_ = _loc2_.getBackItem();
         _loc5_ = _loc2_.getAccessory();
         _loc6_ = this.gatherItemEffects(_loc3_,_loc4_,_loc5_);
         _loc7_ = _loc1_.health_manager.getCurrentHP();
         _loc8_ = _loc1_.health_manager.getMaxHP();
         _loc9_ = _loc1_.health_manager.getCurrentCP();
         _loc10_ = _loc1_.health_manager.getMaxCP();
         var _loc11_:int = _loc1_.health_manager.getCurrentSP();
         _loc12_ = _loc1_.health_manager.getMaxSP();
         _loc13_ = 0;
         _loc14_ = 0;
         if(!this.hadEffect("disable_passive_talent"))
         {
            _loc13_ += this.checkRecoverHPFromTalent();
            _loc14_ += this.checkRecoverCPFromTalent();
         }
         _loc14_ += this.checkRecoverCPFromActiveCPShield();
         _loc15_ = 0;
         for each(_loc16_ in _loc6_)
         {
            for each(_loc17_ in _loc16_)
            {
               switch(_loc17_.effect)
               {
                  case "sp_recover":
                     _loc15_ += this.calculateRecovery(_loc17_,_loc12_);
                     break;
                  case "hp_recover":
                  case "recover_hp_every_turn":
                     _loc13_ += this.calculateHPRecovery(_loc17_,_loc7_,_loc8_);
                     break;
                  case "hp_recover_below":
                     _loc13_ += this.handleHPRecoveryBelow(_loc17_,_loc7_,_loc8_);
                     break;
                  case "hp_recover_below_cp":
                     _loc13_ += this.handleHPRecoveryBelowCP(_loc17_,_loc9_,_loc10_,_loc8_);
                     break;
                  case "cp_recover_below":
                     _loc14_ += this.handleCPRecoveryBelow(_loc17_,_loc9_,_loc10_);
                     break;
                  case "cp_recover":
                     _loc14_ += this.calculateRecovery(_loc17_,_loc10_);
                     break;
                  case "hp_cp_recover":
                     _loc13_ += this.calculateHPRecovery(_loc17_,_loc7_,_loc8_);
                     _loc14_ += _loc17_.calc_type == "number" ? int(_loc17_.amount_cp) : Math.floor(_loc10_ * _loc17_.amount_cp / 100);
                     break;
                  case "rewind":
                     this.handleRewind(_loc17_,_loc1_);
                     break;
                  case "recover_hp_debuff":
                  case "recover_cp_debuff":
                  case "recover_hp_cp_debuff":
                     this.handleDebuffRecovery(_loc17_,_loc13_,_loc14_,_loc8_,_loc10_);
                     break;
                  case "attribute_change":
                     this.handleAttributeChange(_loc17_,_loc7_,_loc8_,_loc1_);
                     break;
                  case "dodge_change":
                     this.handleDodgeChange(_loc17_,_loc7_,_loc8_,_loc1_);
                     break;
                  case "power_up_when":
                     this.handlePowerUp(_loc17_,_loc7_,_loc8_,_loc1_);
                     break;
                  case "agility_up_when":
                     this.handleAgilityUp(_loc17_,_loc7_,_loc8_,_loc1_);
                     break;
                  case "self_reduce_hp":
                     if(_loc17_.calc_type == "percent")
                     {
                        _loc1_.health_manager.reduceHealth(Math.floor(_loc8_ * _loc17_.amount / 100),"HP -");
                     }
                     else
                     {
                        _loc1_.health_manager.reduceHealth(int(_loc17_.amount),"HP -");
                     }
                     break;
               }
            }
         }
         if(_loc7_ < _loc8_ / 2 && !this.hadEffect("disable_passive_talent"))
         {
            _loc13_ += Math.floor(this.getRecoverHPPercectByTalent() * _loc8_ / 100);
         }
         this.applyEffects(_loc1_,_loc13_,_loc14_,_loc15_);
      }
      
      private function gatherItemEffects(param1:String, param2:String, param3:String) : Array
      {
         var _loc4_:Array = null;
         _loc4_ = [];
         if(!this.hadEffect("disable_weapon_effect"))
         {
            _loc4_.push(WeaponBuffs.getCopy(param1).effects || []);
         }
         if(param2 !== "back_item_00")
         {
            _loc4_.push(BackItemBuffs.getCopy(param2).effects || []);
         }
         if(param3 !== "accessory_00")
         {
            _loc4_.push(AccessoryBuffs.getCopy(param3).effects || []);
         }
         return _loc4_;
      }
      
      private function filterActiveDebuffs(param1:Array) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc2_ = [];
         _loc3_ = 0;
         while(_loc3_ < param1[1].length)
         {
            if((_loc4_ = param1[0][param1[1][_loc3_]]).duration > 0)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function calculateRecovery(param1:Object, param2:int) : int
      {
         return param1.calc_type == "number" ? int(int(param1.amount)) : int(Math.floor(param2 * param1.amount / 100));
      }
      
      private function checkRecoverCPFromActiveCPShield() : int
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         _loc1_ = this.getEffect("cp_shield");
         if(_loc1_ == null || !("duration" in _loc1_) || int(_loc1_.duration) <= 0)
         {
            return 0;
         }
         if(!("amount_cp_recover" in _loc1_))
         {
            return 0;
         }
         _loc2_ = int(_loc1_.amount_cp_recover);
         return _loc2_ > 0 ? int(_loc2_) : 0;
      }
      
      private function calculateHPRecovery(param1:Object, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = NumberUtil.getRandomInt();
         if("chance" in param1 && param1.chance >= _loc4_)
         {
            if(!("hp_requirement" in param1))
            {
               return param1.calc_type == "number" ? int(int(param1.amount)) : int(Math.floor(int(param1.amount) * param3 / 100));
            }
            if((_loc5_ = Math.round(param2 / param3 * 100)) < param1.hp_requirement)
            {
               return Math.floor(int(param1.amount) * param3 / 100);
            }
         }
         return 0;
      }
      
      private function handleHPRecoveryBelow(param1:Object, param2:int, param3:int) : int
      {
         var _loc4_:Boolean = false;
         return !!(_loc4_ = param2 <= Math.floor(param3 * param1.active_when / 100)) ? int(this.calculateRecovery(param1,param3)) : 0;
      }
      
      private function handleHPRecoveryBelowCP(param1:Object, param2:int, param3:int, param4:int) : int
      {
         var _loc5_:Boolean = false;
         return !!(_loc5_ = param2 <= Math.floor(param3 * param1.active_when / 100)) ? int(this.calculateRecovery(param1,param4)) : 0;
      }
      
      private function handleCPRecoveryBelow(param1:Object, param2:int, param3:int) : int
      {
         var _loc4_:Boolean = false;
         return !!(_loc4_ = param2 <= Math.floor(param3 * param1.active_when / 100)) ? int(this.calculateRecovery(param1,param3)) : 0;
      }
      
      private function handleRewind(param1:Object, param2:*) : void
      {
         var _loc3_:int = 0;
         _loc3_ = NumberUtil.getRandomInt();
         if(!("chance" in param1) || param1.chance >= _loc3_)
         {
            param2.actions_manager.rewindCooldown(int(param1.amount));
         }
      }
      
      private function handleDebuffRecovery(param1:Object, param2:int, param3:int, param4:int, param5:int) : void
      {
         if(this.dataDebuff.length > 0)
         {
            if(param1.calc_type == "number")
            {
               if(param1.effect == "recover_hp_debuff" || param1.effect == "recover_hp_cp_debuff")
               {
                  param2 += int(param1.amount);
               }
               if(param1.effect == "recover_cp_debuff" || param1.effect == "recover_hp_cp_debuff")
               {
                  param3 += int(param1.amount);
               }
            }
            else
            {
               if(param1.effect == "recover_hp_debuff" || param1.effect == "recover_hp_cp_debuff")
               {
                  param2 += Math.floor(int(param1.amount) * param4 / 100);
               }
               if(param1.effect == "recover_cp_debuff" || param1.effect == "recover_hp_cp_debuff")
               {
                  param3 += Math.floor(int(param1.amount) * param5 / 100);
               }
            }
         }
      }
      
      private function handleAttributeChange(param1:Object, param2:int, param3:int, param4:Object) : void
      {
         if(Math.floor(param2 / param3 * 100) < param1.chance)
         {
            this.checkPassiveEffectToActiveAfterBeingHit(param4,100,param1.duration,param1.amount,"number","kontol_jembut_memek",false,false,"Increase Crit Chance",false,true);
         }
      }
      
      private function handleDodgeChange(param1:Object, param2:int, param3:int, param4:Object) : void
      {
         if(Math.floor(param2 / param3 * 100) < param1.chance)
         {
            this.checkPassiveEffectToActiveAfterBeingHit(param4,100,param1.duration,param1.amount,"number","deka_kontol",false,false,"Increase Dodge Chance",false,true);
         }
      }
      
      private function handleAgilityUp(param1:Object, param2:int, param3:int, param4:Object) : void
      {
         var _loc5_:Object = null;
         if(Math.floor(param2 / param3 * 100) < param1.chance)
         {
            _loc5_ = {
               "effect_name":"Agility Increase",
               "effect":"increase_agility",
               "duration":2,
               "duration_deduct":"immediately",
               "amount":10,
               "calc_type":"percent"
            };
            param4.effects_manager.addBuff(_loc5_);
         }
      }
      
      private function handlePowerUp(param1:Object, param2:int, param3:int, param4:Object) : void
      {
         var _loc5_:Object = null;
         if(Math.floor(param2 / param3 * 100) < param1.chance)
         {
            _loc5_ = {
               "effect_name":"Strengthen",
               "effect":"power_up",
               "duration":3,
               "duration_deduct":"after_attack",
               "amount":30,
               "calc_type":"percent"
            };
            param4.effects_manager.addBuff(_loc5_);
         }
      }
      
      private function applyEffects(param1:*, param2:int, param3:int, param4:int) : void
      {
         if(param4 > 0)
         {
            param1.health_manager.addSP("SP +",param4);
         }
         if(param2 > 0)
         {
            param1.health_manager.addHealth(param2," HP +");
         }
         if(param3 > 0)
         {
            param1.health_manager.addCP(param3," CP +");
         }
      }
      
      public function deductDurationOfEffects() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         _loc1_ = this.getCurrentModel();
         _loc2_ = this.dataBuff.concat(this.dataDebuff);
         _loc3_ = [];
         _loc4_ = _loc2_.length - 1;
         while(_loc4_ >= 0)
         {
            if((_loc7_ = _loc2_[_loc4_]).hasOwnProperty("duration") && typeof _loc7_.duration === "number")
            {
               if((_loc8_ = Effects.getEffectDeductType(_loc7_.effect)) === "never")
               {
                  if(_loc7_.effect === "ultra_bleeding" && _loc7_.hasOwnProperty("amount_increase") && _loc7_.amount_increase > 0)
                  {
                     _loc7_.amount += _loc7_.amount_increase;
                  }
               }
               else if(_loc8_ === "after_attack" && _loc7_.duration === 1)
               {
                  this.collectAfterEffects(_loc7_,_loc3_);
                  _loc2_.splice(_loc4_,1);
               }
               else if(_loc7_.duration > 0)
               {
                  --_loc7_.duration;
               }
               else
               {
                  this.collectAfterEffects(_loc7_,_loc3_);
                  _loc2_.splice(_loc4_,1);
               }
            }
            _loc4_--;
         }
         this.dataBuff = new Vector.<Object>();
         this.dataDebuff = new Vector.<Object>();
         for each(_loc5_ in _loc2_)
         {
            if((_loc9_ = _loc5_.type === "Buff" || _loc5_.is_master_buff || _loc5_.is_buff || _loc5_.is_self && !_loc5_.is_debuff ? "buff" : "debuff") === "debuff")
            {
               this.dataDebuff.push(_loc5_);
            }
            else
            {
               this.dataBuff.push(_loc5_);
            }
         }
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_.type == "Buff")
            {
               _loc1_.effects_manager.addBuff(_loc6_,_loc1_);
            }
            else
            {
               _loc1_.effects_manager.addDebuff(_loc6_,_loc1_);
            }
         }
         this.checkIncreaseMaxHPCPFinish();
      }
      
      private function collectAfterEffects(param1:Object, param2:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         if(!param1.hasOwnProperty("after_effect"))
         {
            return;
         }
         for each(_loc3_ in param1.after_effect)
         {
            _loc4_ = new Object();
            for(_loc5_ in _loc3_)
            {
               _loc4_[_loc5_] = _loc3_[_loc5_];
            }
            if(!_loc3_.hasOwnProperty("type"))
            {
               _loc4_.type = "Debuff";
            }
            _loc4_.show_added_duration = true;
            _loc4_.no_duration_increment = true;
            param2.push(_loc4_);
         }
      }
      
      public function removeEffect(param1:String) : void
      {
         var _loc2_:Vector.<Object> = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         _loc2_ = this.dataBuff.concat(this.dataDebuff);
         _loc3_ = _loc2_.length - 1;
         while(_loc3_ >= 0)
         {
            if((_loc5_ = _loc2_[_loc3_]).effect == param1)
            {
               _loc2_.splice(_loc3_,1);
            }
            _loc3_--;
         }
         this.dataBuff = new Vector.<Object>();
         this.dataDebuff = new Vector.<Object>();
         for each(_loc4_ in _loc2_)
         {
            if((_loc6_ = _loc4_.type === "Buff" || _loc4_.is_master_buff || _loc4_.is_buff || _loc4_.is_self && !_loc4_.is_debuff ? "buff" : "debuff") === "debuff")
            {
               this.dataDebuff.push(_loc4_);
            }
            else
            {
               this.dataBuff.push(_loc4_);
            }
         }
      }
      
      public function checkMeridianCutOffFinish() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         this.updateMaxCP(_loc1_.effects_manager.getEffect("meridian_cut_off"));
         this.updateMaxCP(_loc1_.effects_manager.getEffect("pet_meridian_cut_off"));
      }
      
      private function updateMaxCP(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(param1 && param1.duration == 0 && param1.remove_effect)
         {
            param1.remove_effect = false;
            _loc2_ = this.getCurrentModel();
            _loc2_.health_manager.max_cp = _loc2_.health_manager.original_max_cp;
            _loc2_.health_manager.updateHealthBar();
         }
      }
      
      public function recalculatingHPCP() : void
      {
         var _loc1_:* = undefined;
      }
      
      public function checkIncreaseMaxHPCPFinish() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(_loc1_ == null || !_loc1_.isCharacter())
         {
            return;
         }
         _loc2_ = _loc1_.effects_manager;
         _loc3_ = _loc2_.hadEffect("self_love");
         _loc4_ = _loc2_.hadEffect("bloodflame");
         _loc5_ = _loc2_.hadEffect("domain_expansion");
         _loc6_ = _loc2_.hadEffect("disable_weapon_effect");
         if(!(_loc7_ = _loc2_.hadEffect("disable_passive_talent")) && _loc2_.is_passive_talent_disabled)
         {
            _loc2_.is_passive_talent_disabled = false;
            _loc8_ = _loc1_.character_manager.recalculateHP();
            _loc9_ = _loc1_.character_manager.recalculateCP();
            _loc1_.character_info.character_max_hp = _loc8_;
            _loc1_.character_info.character_max_cp = _loc9_;
            _loc1_.health_manager.max_hp = _loc8_;
            _loc1_.health_manager.max_cp = _loc9_;
            this.reApplyMaxHPBonuses(_loc1_.health_manager);
            this.reApplyMaxCPBonuses(_loc1_.health_manager);
         }
         if(!_loc6_)
         {
            this.resetMaxStats(_loc1_,"disable_weapon_effect","decrease");
         }
         if(!_loc5_)
         {
            this.resetMaxStats(_loc1_,"domain_expansion","increase");
         }
         if(!_loc3_)
         {
            this.resetMaxStats(_loc1_,"self_love","increase");
         }
         if(!_loc4_)
         {
            this.resetMaxStats(_loc1_,"bloodflame","increase");
         }
         _loc1_.health_manager.capHealthAndCP();
         _loc1_.health_manager.updateHealthBar();
      }
      
      public function checkIncreaseMaxHPFinish() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(_loc1_ == null || !_loc1_.isCharacter())
         {
            return;
         }
         _loc2_ = _loc1_.effects_manager;
         _loc3_ = _loc2_.hadEffect("slug_sage");
         if(!_loc3_)
         {
            this.resetMaxStats(_loc1_,"slug_sage","increase");
            _loc4_ = _loc1_.character_manager.recalculateHP();
            _loc1_.character_info.character_max_hp = _loc4_;
            _loc1_.health_manager.max_hp = _loc4_;
            this.reApplyMaxHPBonuses(_loc1_.health_manager);
         }
         _loc1_.health_manager.capHealthAndCP();
         _loc1_.health_manager.updateHealthBar();
      }
      
      private function addDebuffs(param1:Object, param2:String, param3:int, param4:int) : void
      {
         var _loc5_:Object = null;
         _loc5_ = {
            "type":"Debuff",
            "effect":param2,
            "duration":param3,
            "amount":param4
         };
         param1.effects_manager.addDebuff(_loc5_);
      }
      
      private function resetMaxStats(param1:Object, param2:String, param3:String) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         if(param1 == null || param1.health_manager == null)
         {
            return;
         }
         _loc4_ = param1.health_manager;
         if(param3 == "increase")
         {
            _loc5_ = !!_loc4_.effectAddMaxHP ? _loc4_.effectAddMaxHP[param2] : null;
            _loc6_ = !!_loc4_.effectAddMaxCP ? _loc4_.effectAddMaxCP[param2] : null;
            if(_loc5_ != null)
            {
               _loc4_.max_hp -= int(_loc5_.increase_hp);
               _loc5_.increase_hp = 0;
               if("suppressed_hp" in _loc5_ && _loc5_.suppressed_hp > 0)
               {
                  _loc5_.suppressed_hp = 0;
               }
            }
            if(_loc6_ != null)
            {
               _loc4_.max_cp -= int(_loc6_.increase_cp);
               _loc6_.increase_cp = 0;
            }
         }
         else
         {
            _loc7_ = !!_loc4_.effectDecreaseMaxHP ? _loc4_.effectDecreaseMaxHP[param2] : null;
            _loc8_ = !!_loc4_.effectDecreaseMaxCP ? _loc4_.effectDecreaseMaxCP[param2] : null;
            _loc9_ = !!_loc4_.effectDecreaseMaxSP ? _loc4_.effectDecreaseMaxSP[param2] : null;
            if(_loc7_ != null)
            {
               _loc4_.max_hp += int(_loc7_.modifier_hp);
               _loc7_.modifier_hp = 0;
            }
            if(_loc8_ != null)
            {
               _loc4_.max_cp += int(_loc8_.modifier_cp);
               _loc8_.modifier_cp = 0;
            }
            if(_loc9_ != null)
            {
               _loc4_.max_sp += int(_loc9_.modifier_sp);
               _loc9_.modifier_sp = 0;
            }
         }
      }
      
      private function reApplyMaxHPBonuses(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:* = null;
         var _loc5_:* = null;
         _loc2_ = param1.effectAddMaxHP;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.slug_sage != null && _loc2_.slug_sage.increase_hp > 0;
            if(_loc3_)
            {
               param1.max_hp += int(_loc2_.slug_sage.increase_hp);
            }
            else
            {
               for(_loc4_ in _loc2_)
               {
                  if(_loc4_ != "slug_sage" && _loc2_[_loc4_] != null && _loc2_[_loc4_].suppressed_hp > 0)
                  {
                     _loc2_[_loc4_].increase_hp = int(_loc2_[_loc4_].suppressed_hp);
                     _loc2_[_loc4_].suppressed_hp = 0;
                  }
               }
               for(_loc5_ in _loc2_)
               {
                  if(_loc5_ != "slug_sage" && _loc2_[_loc5_] != null && "increase_hp" in _loc2_[_loc5_])
                  {
                     param1.max_hp += int(_loc2_[_loc5_].increase_hp);
                  }
               }
            }
         }
         if(param1.effectDecreaseMaxHP && param1.effectDecreaseMaxHP.unwell)
         {
            param1.max_hp -= int(param1.effectDecreaseMaxHP.unwell.modifier_hp);
         }
      }
      
      private function reApplyMaxCPBonuses(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         _loc2_ = param1.effectAddMaxCP;
         if(_loc2_ != null)
         {
            for(_loc3_ in _loc2_)
            {
               if(_loc2_[_loc3_] != null && "increase_cp" in _loc2_[_loc3_])
               {
                  param1.max_cp += int(_loc2_[_loc3_].increase_cp);
               }
            }
         }
      }
      
      public function checkDecreaseMaxCPFinish() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:* = null;
         _loc1_ = this.getCurrentModel();
         _loc2_ = _loc1_.effects_manager.getEffect("decrease_max_cp");
         _loc3_ = false;
         for(_loc4_ in _loc2_)
         {
            if(_loc2_[_loc4_] > 0)
            {
               _loc3_ = true;
               break;
            }
         }
         if(_loc2_ && _loc2_.duration == 0 && _loc2_.remove_effect || !_loc3_)
         {
            _loc2_.remove_effect = false;
            _loc1_.health_manager.max_cp += _loc1_.health_manager.status_change.decrease_cp;
            _loc1_.health_manager.status_change.decrease_cp = 0;
         }
         if(_loc1_.health_manager.getCurrentCP() > _loc1_.health_manager.max_cp)
         {
            _loc1_.health_manager.setCurrentCP(_loc1_.health_manager.max_cp);
         }
         _loc1_.health_manager.updateHealthBar();
      }
      
      public function checkDecreaseMaxHPCPFinish() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:* = null;
         _loc1_ = this.getCurrentModel();
         _loc2_ = _loc1_.effects_manager.getEffect("decrease_max_hpcp");
         _loc3_ = false;
         if(!_loc2_)
         {
            return;
         }
         for(_loc4_ in _loc2_)
         {
            if(_loc2_[_loc4_] > 0)
            {
               _loc3_ = true;
               break;
            }
         }
         if(_loc2_.duration == 0 && _loc2_.remove_effect || !_loc3_)
         {
            _loc2_.remove_effect = false;
            _loc1_.health_manager.max_cp += _loc1_.health_manager.effectDecreaseMaxCP.decrease_max_hpcp.modifier_cp;
            _loc1_.health_manager.effectDecreaseMaxCP.decrease_max_hpcp.modifier_cp = 0;
            _loc1_.health_manager.max_hp += _loc1_.health_manager.effectDecreaseMaxHP.decrease_max_hpcp.modifier_hp;
            _loc1_.health_manager.effectDecreaseMaxHP.decrease_max_hpcp.modifier_hp = 0;
         }
         if(_loc1_.health_manager.getCurrentCP() > _loc1_.health_manager.max_cp)
         {
            _loc1_.health_manager.setCurrentCP(_loc1_.health_manager.max_cp);
         }
         if(_loc1_.health_manager.getCurrentHP() > _loc1_.health_manager.max_hp)
         {
            _loc1_.health_manager.setCurrentHP(_loc1_.health_manager.max_hp);
         }
         _loc1_.health_manager.updateHealthBar();
      }
      
      public function checkPurifyOnRoundStart() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         _loc1_ = this.getEffect("debuff_clear_next_turn");
         _loc2_ = this.getEffect("illuminated_chakra_mode");
         if(_loc1_ && _loc1_.duration > 0 || _loc2_ && _loc2_.duration > 0)
         {
            this.purifyPlayer("Debuff Clear");
            this.checkAddCPAfterGotBuff();
            this.checkAddHealthAfterGotBuff();
         }
      }
      
      public function checkPeace() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         _loc1_ = this.getCurrentModel();
         _loc2_ = 0;
         _loc3_ = int(_loc1_.health_manager.getMaxCP());
         _loc4_ = this.user_team == "player" ? BattleManager.getBattle().character_team_players : BattleManager.getBattle().enemy_team_players;
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            if((_loc7_ = (_loc6_ = _loc4_[_loc5_]).effects_manager.getEffect("peace")) && _loc7_.duration > 1)
            {
               _loc2_ = this.increaseOrDecreaseByObject(_loc2_,_loc3_,_loc7_,"amount_cp");
               _loc1_.health_manager.addCP(_loc2_,"Peace" + " " + (_loc7_.duration - 1) + " | CP +");
            }
            _loc5_++;
         }
      }
      
      public function isUnderLockDebuffs() : Boolean
      {
         var _loc1_:String = null;
         for each(_loc1_ in Effects.lock_effects)
         {
            if(this.hadEffect(_loc1_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function setModel(param1:*) : *
      {
         this.model = param1;
      }
      
      public function getCurrentModel() : *
      {
         var _loc1_:MovieClip = null;
         if(this.model != null)
         {
            return this.model;
         }
         _loc1_ = this.getMovieClipHolder();
         return _loc1_.charMc.character_model;
      }
      
      public function getAccuracyBelowHP() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         _loc1_ = this.getCurrentModel();
         _loc2_ = 0;
         _loc3_ = _loc1_.health_manager;
         _loc4_ = _loc3_.getCurrentHP();
         _loc5_ = _loc3_.getMaxHP();
         _loc6_ = _loc1_.effects_manager.getAllCharacterSetEffects();
         for each(_loc7_ in _loc6_)
         {
            for each(_loc8_ in _loc7_)
            {
               if(_loc8_.effect == "accuracy_up_below_hp")
               {
                  _loc9_ = _loc5_ * _loc8_.chance / 100;
                  if(_loc4_ < _loc9_)
                  {
                     _loc2_ += _loc8_.chance;
                     _loc1_.effects_manager.addEffect("Buff","increase_accuracy","Increase Accuracy",_loc8_.amount,"percent",1,100);
                  }
               }
            }
         }
      }
      
      public function getCriticalAndAccuracyWhenHPBelow() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return;
         }
         _loc2_ = _loc1_.health_manager.getMaxHP();
         _loc3_ = _loc1_.health_manager.getCurrentHP();
         if(_loc2_ == 0)
         {
            return;
         }
         _loc4_ = Math.round(_loc3_ / _loc2_ * 100);
         if(_loc1_.character_manager.hasSenjutsuSkill("skill_3006"))
         {
            _loc5_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3006",_loc1_.character_manager.getSenjutsuLevel("skill_3006"));
            if(_loc4_ <= _loc5_.hp_condition)
            {
               _loc6_ = {
                  "effect":"toad_concentration",
                  "effect_name":"Concentration",
                  "duration":1,
                  "amount":_loc5_.increase_critical_chance
               };
               _loc7_ = {
                  "effect":"toad_attention",
                  "effect_name":"Attention",
                  "duration":1,
                  "amount":_loc5_.increase_accuracy
               };
               _loc1_.effects_manager.addBuff(_loc6_);
               _loc1_.effects_manager.addBuff(_loc7_);
            }
         }
      }
      
      public function getActivateIlluminatedChakraMode() : Object
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return {};
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_100001"))
         {
            return {};
         }
         return TalentSkillLevel.getTalentSkillLevels("skill_100001",_loc1_.character_manager.getTalentLevel("skill_100001"));
      }
      
      public function getActivateUnyielding() : Object
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return {};
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1050"))
         {
            return {};
         }
         return TalentSkillLevel.getTalentSkillLevels("skill_1050",_loc1_.character_manager.getTalentLevel("skill_1050"));
      }
      
      public function getActivateEOMRevive() : Object
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return {};
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1023"))
         {
            return {};
         }
         return TalentSkillLevel.getTalentSkillLevels("skill_1023",_loc1_.character_manager.getTalentLevel("skill_1023"));
      }
      
      public function checkStealJutsu() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         _loc1_ = this.getCurrentModel();
         _loc2_ = BattleManager.getBattle().defender_model;
         if(!_loc2_.isCharacter() || _loc2_.effects_manager.hadEffect("unyielding") || _loc2_.effects_manager.hadEffect("debuff_resist") || !_loc1_.character_manager.hasSenjutsuSkill("skill_3005"))
         {
            return false;
         }
         _loc3_ = this.checkEnemiesSkill(_loc2_);
         if(_loc3_.length == 0)
         {
            return false;
         }
         _loc4_ = Math.floor(Math.random() * _loc3_.length);
         if((_loc5_ = _loc3_[_loc4_]) == null)
         {
            return false;
         }
         _loc6_ = int(SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3005",_loc1_.character_manager.getSenjutsuLevel("skill_3005")).setCooldown);
         _loc2_.actions_manager.setCooldown(_loc6_ + 1,_loc5_);
         BattleVars.COPY_SKILL_ID_SAVE = _loc5_;
         return true;
      }
      
      public function checkEnemiesSkill(param1:*) : Array
      {
         var _loc2_:Array = null;
         _loc2_ = param1.getSkillsCooldown();
         if(_loc2_ == null)
         {
            _loc2_ = param1.character_manager.getEquippedSkills();
         }
         return _loc2_;
      }
      
      public function checkCopySkill(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = this.getCurrentModel();
         if(!_loc2_.isCharacter())
         {
            return false;
         }
         _loc3_ = this.user_team == "player" ? Boolean(Boolean(BattleVars.CHARACTER_REVIVED[this.user_number])) : Boolean(Boolean(BattleVars.ENEMY_REVIVED[this.user_number]));
         if(_loc3_ || this.isUnderLockDebuffs() || this.hadEffect("disable_passive_talent"))
         {
            return false;
         }
         if(!_loc2_.character_manager.hasTalentSkill("skill_1018"))
         {
            return false;
         }
         _loc4_ = _loc2_.character_manager.getTalentLevel("skill_1018");
         _loc5_ = int(TalentSkillLevel.getTalentSkillLevels("skill_1018",_loc4_).chance);
         _loc6_ = NumberUtil.getRandomInt();
         if(_loc5_ > 0 && _loc5_ >= _loc6_)
         {
            BattleVars.COPY_SKILL_ID_SAVE = param1;
            return true;
         }
         BattleVars.COPY_SKILL_ID_SAVE = "";
         return false;
      }
      
      public function resetKnowledgeOfTime() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         _loc1_ = this.getCurrentModel();
         _loc2_ = _loc1_.effects_manager.hadEffect("defer");
         _loc3_ = _loc1_.effects_manager.hadEffect("fast_forward");
         if(_loc2_)
         {
            if(_loc1_.effects_manager.getEffect("defer").duration > 1)
            {
               return;
            }
         }
         else if(_loc3_)
         {
            if(_loc1_.effects_manager.getEffect("fast_forward").duration > 1)
            {
               return;
            }
         }
         else if(!_loc1_.knowledge_of_time.is_active)
         {
            return;
         }
         if(!_loc1_.knowledge_of_time.is_active)
         {
            return;
         }
         _loc4_ = !!_loc2_ ? "Time Distortion: -" : "Fast Forward: -";
         if(!_loc1_.effects_manager.hadEffect("debuff_resist"))
         {
            _loc1_.health_manager.reduceHealth(_loc1_.knowledge_of_time.stored_damage,_loc4_);
         }
         _loc1_.knowledge_of_time.is_active = false;
         _loc1_.knowledge_of_time.stored_damage = 0;
         _loc1_.knowledge_of_time.max_store = 0;
      }
      
      public function setupDefer(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         this.purifyPlayer("Purify");
         param1.health_manager.createDisplay("Time Distortion");
         _loc3_ = 0;
         if(param2.calc_type == "percent")
         {
            _loc3_ = Math.floor(param1.health_manager.getMaxHP() * param2.amount / 100);
         }
         else
         {
            _loc3_ = int(param2.amount);
         }
         param1.knowledge_of_time.is_active = true;
         param1.knowledge_of_time.stored_damage = 0;
         param1.knowledge_of_time.max_store = _loc3_;
         if((_loc4_ = !!param2.hasOwnProperty("heal_block_turns") ? int(int(param2.heal_block_turns)) : 0) > 0)
         {
            if((_loc5_ = param1.effects_manager.getEffect("defer")) != null && _loc5_.hasOwnProperty("effect"))
            {
               _loc5_.after_effect = [{
                  "effect":"internal_injury",
                  "effect_name":"Internal Injury",
                  "duration":_loc4_,
                  "amount":0,
                  "calc_type":"",
                  "chance":100,
                  "type":"Debuff"
               }];
            }
         }
      }
      
      public function calculateKnowledgeOfTime(param1:int) : int
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = this.getCurrentModel();
         if(!_loc2_.effects_manager.hadEffect("defer") && !_loc2_.effects_manager.hadEffect("fast_forward"))
         {
            return param1;
         }
         _loc2_.knowledge_of_time.is_active = true;
         _loc3_ = int(_loc2_.knowledge_of_time.max_store);
         if(_loc2_.effects_manager.hadEffect("defer") && _loc3_ > 0)
         {
            if((_loc4_ = _loc3_ - int(_loc2_.knowledge_of_time.stored_damage)) <= 0)
            {
               return param1;
            }
            if(param1 > _loc4_)
            {
               _loc2_.knowledge_of_time.stored_damage += _loc4_;
               return param1 - _loc4_;
            }
         }
         _loc2_.knowledge_of_time.stored_damage += param1;
         return 0;
      }
      
      public function checkRecoverHPFromTalent() : int
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         _loc3_ = 0;
         var _loc4_:* = 0;
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1045"))
         {
            _loc3_ += TalentSkillLevel.getTalentSkillLevels("skill_1045",_loc1_.character_manager.getTalentLevel("skill_1045")).amount;
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1046"))
         {
            _loc5_ = TalentSkillLevel.getTalentSkillLevels("skill_1046",_loc1_.character_manager.getTalentLevel("skill_1046"));
            _loc6_ = _loc1_.health_manager.getCurrentHP() / _loc1_.health_manager.getMaxHP() * 100;
            _loc2_ = _loc5_.chance;
            if(_loc2_ > _loc6_)
            {
               _loc3_ += _loc5_.amount;
            }
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1051"))
         {
            _loc3_ += TalentSkillLevel.getTalentSkillLevels("skill_1051",_loc1_.character_manager.getTalentLevel("skill_1051")).amount;
         }
         return Math.round(_loc3_);
      }
      
      public function checkRecoverCPFromTalent() : int
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1052"))
         {
            return 0;
         }
         _loc2_ = 0;
         _loc3_ = 0;
         var _loc4_:* = 0;
         _loc5_ = _loc1_.health_manager.getCurrentCP() / _loc1_.health_manager.getMaxCP() * 100;
         _loc6_ = _loc1_.health_manager.getMaxCP();
         _loc7_ = TalentSkillLevel.getTalentSkillLevels("skill_1052",_loc1_.character_manager.getTalentLevel("skill_1052"));
         _loc2_ += _loc7_.chance;
         if(_loc2_ > _loc5_)
         {
            _loc3_ += _loc6_ * _loc7_.amount / 100;
         }
         return Math.round(_loc3_);
      }
      
      public function checkIncreaseRecoverItemFromTalent() : Array
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return [];
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1045"))
         {
            return [];
         }
         return TalentSkillLevel.getTalentSkillLevels("skill_1045",_loc1_.character_manager.getTalentLevel("skill_1045")).effects;
      }
      
      public function checkReboundEffects() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = this.getCurrentModel();
         _loc2_ = this.user_team == "player" ? Boolean(Boolean(BattleVars.CHARACTER_REVIVED[this.user_number])) : Boolean(Boolean(BattleVars.ENEMY_REVIVED[this.user_number]));
         if(!_loc1_.isCharacter())
         {
            return false;
         }
         if(this.hadEffect("disable_passive_talent"))
         {
            return false;
         }
         if(!_loc1_.character_manager.hasTalentSkill("skill_1019"))
         {
            return false;
         }
         _loc3_ = int(TalentSkillLevel.getTalentSkillLevels("skill_1019",_loc1_.character_manager.getTalentLevel("skill_1019")).chance);
         _loc4_ = NumberUtil.getRandomInt();
         var _loc5_:Object = _loc3_ >= _loc4_ && !_loc2_;
         return _loc3_ >= _loc4_ && !_loc2_;
      }
      
      public function getReduceTaijutsuImprove() : Number
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1001"))
         {
            return 0;
         }
         return Number(TalentSkillLevel.getTalentSkillLevels("skill_1001",_loc1_.character_manager.getTalentLevel("skill_1001")).amount_deduct);
      }
      
      public function getIncreaseDamageForTaijutsu() : Number
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1001"))
         {
            return 0;
         }
         return Number(TalentSkillLevel.getTalentSkillLevels("skill_1001",_loc1_.character_manager.getTalentLevel("skill_1001")).amount_increase);
      }
      
      public function getDebuffResistByTalent() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return;
         }
         if(_loc1_.effects_manager.hadEffect("disable_passive_talent"))
         {
            return;
         }
         if(!_loc1_.character_manager.hasTalentSkill("skill_1110"))
         {
            return;
         }
         _loc1_.debuff_resist = false;
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1110",_loc1_.character_manager.getTalentLevel("skill_1110")).resist_debuff_chance;
         if(_loc2_ >= NumberUtil.getRandomInt())
         {
            _loc1_.debuff_resist = true;
         }
      }
      
      public function getIncreaseDamageByTalent(param1:int) : int
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         _loc2_ = this.getCurrentModel();
         if(!_loc2_.isCharacter())
         {
            return 0;
         }
         _loc3_ = 0;
         _loc4_ = 0;
         if(_loc2_.effects_manager.hasActivePassiveTalent("skill_100001"))
         {
            _loc4_ += TalentSkillLevel.getTalentSkillLevels("skill_100001",_loc2_.character_manager.getTalentLevel("skill_100001")).increase_damage;
            _loc3_ += Math.round(param1 * _loc4_ / 100);
         }
         else if(_loc2_.effects_manager.hasActivePassiveTalent("skill_1055"))
         {
            _loc5_ = _loc2_.health_manager.getMaxCP();
            _loc4_ += TalentSkillLevel.getTalentSkillLevels("skill_1055",_loc2_.character_manager.getTalentLevel("skill_1055")).increase_damage;
            _loc3_ += Math.round(_loc5_ * _loc4_ / 100);
         }
         else if(_loc2_.effects_manager.hasActivePassiveTalent("skill_1102"))
         {
            _loc4_ += TalentSkillLevel.getTalentSkillLevels("skill_1102",_loc2_.character_manager.getTalentLevel("skill_1102")).increase_damage;
            _loc3_ += Math.round(param1 * _loc4_ / 100);
         }
         return _loc3_;
      }
      
      public function getIncreaseDamageBySenjutsu(param1:int) : int
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc2_ = this.getCurrentModel();
         if(!_loc2_.isCharacter())
         {
            return 0;
         }
         _loc3_ = 0;
         if(_loc2_.character_manager.hasSenjutsuSkill("skill_3001"))
         {
            _loc4_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3001",_loc2_.character_manager.getSenjutsuLevel("skill_3001"));
            _loc3_ += Math.round(param1 * _loc4_.increase_damage / 100);
         }
         return Math.round(_loc3_);
      }
      
      public function getReduceDamageTakenByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = ["skill_1014","skill_1024","skill_1051"];
         _loc3_ = 0;
         for each(_loc4_ in _loc2_)
         {
            if(_loc1_.effects_manager.hasActivePassiveTalent(_loc4_))
            {
               _loc5_ = _loc1_.character_manager.getTalentLevel(_loc4_);
               _loc6_ = Number(TalentSkillLevel.getTalentSkillLevels(_loc4_,_loc5_).reduce_damage_taken);
               _loc3_ += _loc6_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function calculateChanceFromTalent_Wolfram(param1:int) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         _loc2_ = this.getCurrentModel();
         if(!_loc2_.isCharacter())
         {
            return;
         }
         if(!_loc2_.effects_manager.hasActivePassiveTalent("skill_1107"))
         {
            return;
         }
         _loc3_ = NumberUtil.getRandomInt();
         _loc4_ = _loc2_.character_manager.getTalentLevel("skill_1107");
         if((_loc5_ = TalentSkillLevel.getTalentSkillLevels("skill_1107",_loc4_)).chance >= _loc3_ && param1 > _loc5_.damage_count)
         {
            _loc6_ = {
               "passive":false,
               "type":"Buff",
               "target":"self",
               "is_debuff":false,
               "effect":"wolfram",
               "effect_name":"Wolfram",
               "duration_deduct":"after_attack",
               "duration":1,
               "amount":_loc5_.reduce_damage_taken,
               "calc_type":"percent"
            };
            _loc2_.effects_manager.addBuff(_loc6_);
         }
      }
      
      function calculateInsectPurify(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = 1 * param2 / 100;
         _loc4_ = _loc3_ * (param2 / param1);
         _loc5_ = param2 + _loc4_;
         return Math.round(_loc5_);
      }
      
      public function getIncreasePurifyByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1051"))
         {
            _loc2_ = _loc1_.health_manager.getMaxCP();
            _loc3_ = TalentSkillLevel.getTalentSkillLevels("skill_1051",_loc1_.character_manager.getTalentLevel("skill_1051")).purify_chance_on;
            return Number(Math.round(_loc2_ / _loc3_));
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1102"))
         {
            _loc5_ = _loc1_.health_manager.getMaxHP();
            _loc3_ = TalentSkillLevel.getTalentSkillLevels("skill_1102",_loc1_.character_manager.getTalentLevel("skill_1102")).purify_chance_on;
            return Number(Math.round(_loc5_ / _loc3_));
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1061"))
         {
            return Number(TalentSkillLevel.getTalentSkillLevels("skill_1061",_loc1_.character_manager.getTalentLevel("skill_1061")).increase_purify_chance);
         }
         return 0;
      }
      
      public function getIncreaseAgilityByTalent() : Number
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(_loc1_.effects_manager.hadEffect("disable_passive_talent"))
         {
            return 0;
         }
         if(_loc1_.character_manager.hasTalentSkill("skill_1003"))
         {
            return Number(TalentSkillLevel.getTalentSkillLevels("skill_1003",_loc1_.character_manager.getTalentLevel("skill_1003")).increase_agility);
         }
         return 0;
      }
      
      public function getIncreaseMaxHPBySenjutsu(param1:int) : Number
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc2_ = this.getCurrentModel();
         if(!_loc2_.isCharacter())
         {
            return 0;
         }
         _loc3_ = 0;
         if(_loc2_.character_manager.hasSenjutsuSkill("skill_3001"))
         {
            _loc4_ = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3001",_loc2_.character_manager.getSenjutsuLevel("skill_3001"));
            _loc3_ += Math.floor(param1 * _loc4_.increase_max_hp / 100);
         }
         return _loc3_;
      }
      
      public function getIncreaseMaxCPByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1010"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_1010",_loc1_.character_manager.getTalentLevel("skill_1010")).increase_max_cp);
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1061"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_1061",_loc1_.character_manager.getTalentLevel("skill_1061")).increase_max_cp);
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_100001"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_100001",_loc1_.character_manager.getTalentLevel("skill_100001")).increase_max_cp);
         }
         return _loc2_;
      }
      
      public function getIncreaseAccuracyByTalent() : Number
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1006"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_1006",_loc1_.character_manager.getTalentLevel("skill_1006")).increase_accuracy);
         }
         return _loc2_;
      }
      
      public function getIncreaseCritDamageByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(this.is_passive_talent_disabled)
         {
            return 0;
         }
         _loc1_ = this.getCurrentModel();
         if(!_loc1_ || !_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = _loc1_.character_manager;
         _loc3_ = 0;
         if(_loc2_.hasTalentSkill("skill_1009"))
         {
            _loc4_ = _loc2_.getTalentLevel("skill_1009");
            if((_loc5_ = TalentSkillLevel.getTalentSkillLevels("skill_1009",_loc4_)) && _loc5_.hasOwnProperty("increase_critical_damage"))
            {
               _loc3_ = Number(_loc5_.increase_critical_damage);
            }
         }
         return _loc3_;
      }
      
      public function getIncreaseDodgeByTalent() : Number
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1006"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_1006",_loc1_.character_manager.getTalentLevel("skill_1006")).increase_dodge);
         }
         return _loc2_;
      }
      
      public function getIgnoreDodgeBySenjutsu() : Number
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.character_manager.hasSenjutsuSkill("skill_3104"))
         {
            _loc2_ += SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3104",_loc1_.character_manager.getSenjutsuLevel("skill_3104")).ignore_dodge;
         }
         return Math.round(_loc2_);
      }
      
      public function getChanceToInflictChaosByTalent(param1:Object) : *
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         _loc2_ = this.getCurrentModel();
         _loc3_ = BattleManager.getBattle().getAttacker();
         _loc4_ = BattleManager.getBattle().getDefender();
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         if(param1 == _loc3_)
         {
            _loc2_ = _loc4_;
         }
         if(!_loc2_.isCharacter())
         {
            return;
         }
         if(_loc2_.effects_manager.hasActivePassiveTalent("skill_1101"))
         {
            _loc7_ = TalentSkillLevel.getTalentSkillLevels("skill_1101",_loc2_.character_manager.getTalentLevel("skill_1101"));
            _loc8_ = NumberUtil.getRandomInt();
            if(_loc7_.chance >= _loc8_)
            {
               _loc9_ = {
                  "effect":"chaos",
                  "add_in_array":true,
                  "duration_deduct":"immediately",
                  "duration":_loc7_.chaos_duration
               };
               param1.effects_manager.addDebuff(_loc9_);
               _loc10_ = {
                  "isTrue":true,
                  "amount":_loc7_.hp_recover
               };
               _loc2_.ultimate_string = _loc10_;
            }
         }
      }
      
      public function getRecoverWhenHPReducedByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         _loc1_ = this.getCurrentModel();
         _loc2_ = 0;
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1054"))
         {
            _loc3_ = TalentSkillLevel.getTalentSkillLevels("skill_1054",_loc1_.character_manager.getTalentLevel("skill_1054"));
            _loc4_ = _loc3_.chance;
            _loc5_ = NumberUtil.getRandomInt();
            if(_loc4_ >= _loc5_)
            {
               _loc2_ += _loc3_.recover_hp;
            }
         }
         return _loc2_;
      }
      
      public function getReboundAsDamageByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(_loc1_.effects_manager.hadEffect("disable_passive_talent"))
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.character_manager.hasTalentSkill("skill_1007"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_1007",_loc1_.character_manager.getTalentLevel("skill_1007")).receive_damage_prc);
         }
         return _loc2_;
      }
      
      public function getStunChanceAfterReboundByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(_loc1_.effects_manager.hadEffect("disable_passive_talent"))
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.character_manager.hasTalentSkill("skill_1007"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_1007",_loc1_.character_manager.getTalentLevel("skill_1007")).stun_chance);
         }
         return _loc2_;
      }
      
      public function getResistStunPrcByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1014"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_1014",_loc1_.character_manager.getTalentLevel("skill_1014")).increase_resist_stun);
         }
         return _loc2_;
      }
      
      public function getResistPoisonPrcByTalent() : Number
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1025"))
         {
            return 0;
         }
         return 100;
      }
      
      public function getIncreaseChargeCPByTalent() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_1010"))
         {
            _loc2_ = Number(TalentSkillLevel.getTalentSkillLevels("skill_1010",_loc1_.character_manager.getTalentLevel("skill_1010")).increase_charge);
         }
         return _loc2_;
      }
      
      public function getReboundDamageChanceFromTalent() : int
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1015"))
         {
            return 0;
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1015",_loc1_.character_manager.getTalentLevel("skill_1015"));
         return _loc2_.chance_to_rebound;
      }
      
      public function getReboundDamageFromTalent() : int
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1015"))
         {
            return 0;
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1015",_loc1_.character_manager.getTalentLevel("skill_1015"));
         return _loc2_.amount_rebound;
      }
      
      public function getReboundAndReboundAmountChance() : Array
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return [0,0];
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1015"))
         {
            return [0,0];
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1015",_loc1_.character_manager.getTalentLevel("skill_1015"));
         return [_loc2_.chance_to_rebound,_loc2_.amount_rebound];
      }
      
      public function getRecoverHPAfterDealingDmgByTalent() : Array
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return [0,0];
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1025"))
         {
            return [0,0];
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1025",_loc1_.character_manager.getTalentLevel("skill_1025"));
         return [_loc2_.chance_to_recover,_loc2_.amount_recover_hp];
      }
      
      public function getRecoverHPFromPassive() : Object
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return {};
         }
         _loc2_ = _loc1_.effects_manager.getAllCharacterSetEffects();
         _loc3_ = [];
         _loc4_ = {};
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc5_];
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               if(_loc3_[_loc6_].effect == "bloodfeed_attack")
               {
                  _loc4_ = _loc3_[_loc6_];
               }
               _loc6_++;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function getRecoverHPPercectByTalent() : Number
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(_loc1_.effects_manager && _loc1_.effects_manager.hadEffect("disable_passive_talent"))
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1024"))
         {
            return 0;
         }
         return Number(TalentSkillLevel.getTalentSkillLevels("skill_1024",_loc1_.character_manager.getTalentLevel("skill_1024")).recover_after_half_hp);
      }
      
      public function getUseChanceToUseSkillWithoutCP() : int
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_100001"))
         {
            _loc2_ = int(TalentSkillLevel.getTalentSkillLevels("skill_100001",_loc1_.character_manager.getTalentLevel("skill_100001")).chance_to_use_skill_no_cp);
         }
         return _loc2_;
      }
      
      public function getCooldownDecreaseForSkills() : int
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         _loc2_ = 0;
         if(_loc1_.effects_manager.hasActivePassiveTalent("skill_100001"))
         {
            _loc2_ = int(TalentSkillLevel.getTalentSkillLevels("skill_100001",_loc1_.character_manager.getTalentLevel("skill_100001")).cooldown_decrease);
         }
         return _loc2_;
      }
      
      public function getCaptureChanceFromSilhouette() : Object
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         _loc1_ = this.getCurrentModel();
         if(_loc1_ == null || !_loc1_.isCharacter() || _loc1_.character_manager == null || _loc1_.effects_manager == null || !_loc1_.effects_manager.hasActivePassiveTalent("skill_1036"))
         {
            return {
               "chance":0,
               "amount":0,
               "duration":0
            };
         }
         _loc2_ = _loc1_.effects_manager.getEffect("increase_silhouette_chance");
         _loc3_ = TalentSkillLevel.getTalentSkillLevels("skill_1036",_loc1_.character_manager.getTalentLevel("skill_1036"));
         if(_loc3_ == null)
         {
            return {
               "chance":0,
               "amount":0,
               "duration":0
            };
         }
         _loc4_ = {
            "chance":_loc3_.chance,
            "amount":_loc3_.amount,
            "duration":_loc3_.duration
         };
         _loc5_ = 0;
         if(_loc1_.effects_manager.hadEffect("increase_silhouette_chance") && _loc2_ != null && !isNaN(_loc2_.amount))
         {
            _loc5_ += _loc2_.amount;
         }
         _loc4_.chance += _loc5_;
         return _loc4_;
      }
      
      public function getChanceToRecoverPercentHPCP() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(_loc1_ == null || !_loc1_.isCharacter() || !_loc1_.effects_manager.hasActivePassiveTalent("skill_1033"))
         {
            return {
               "chance":0,
               "amount":0
            };
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1033",_loc1_.character_manager.getTalentLevel("skill_1033"));
         return {
            "chance":_loc2_.chance,
            "amount":_loc2_.amount
         };
      }
      
      public function getWeakenEnemyChanceByAttack() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         _loc1_ = this.getCurrentModel();
         if(_loc1_ == null || !_loc1_.isCharacter() || !_loc1_.effects_manager.hasActivePassiveTalent("skill_1030"))
         {
            return {
               "chance":0,
               "amount":0,
               "duration":0
            };
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1030",_loc1_.character_manager.getTalentLevel("skill_1030"));
         return {
            "chance":_loc2_.chance,
            "amount":_loc2_.amount,
            "duration":_loc2_.duration
         };
      }
      
      public function getFreezeEnemyChanceByAttack() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         _loc1_ = this.getCurrentModel();
         if(_loc1_ == null || !_loc1_.isCharacter() || !_loc1_.effects_manager.hasActivePassiveTalent("skill_1042"))
         {
            return {
               "chance":0,
               "duration":0
            };
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1042",_loc1_.character_manager.getTalentLevel("skill_1042"));
         return {
            "chance":_loc2_.chance,
            "duration":_loc2_.duration
         };
      }
      
      public function getIncreaseFireJutsuDamage() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1039"))
         {
            return 0;
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1039",_loc1_.character_manager.getTalentLevel("skill_1039"));
         return Number(_loc2_.amount);
      }
      
      public function getIncreaseEarthJutsuDamage() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1039"))
         {
            return 0;
         }
         _loc2_ = TalentSkillLevel.getTalentSkillLevels("skill_1039",_loc1_.character_manager.getTalentLevel("skill_1039"));
         return Number(_loc2_.amount);
      }
      
      public function getRecoverCPAmountFromDealtDmg() : int
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return 0;
         }
         if(!_loc1_.effects_manager.hasActivePassiveTalent("skill_1066"))
         {
            return 0;
         }
         return TalentSkillLevel.getTalentSkillLevels("skill_1066",_loc1_.character_manager.getTalentLevel("skill_1066")).restore_cp_prc;
      }
      
      public function getPassiveSkills() : Array
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return [];
         }
         _loc2_ = _loc1_.actions_manager.getTalentPassiveSkills();
         if(_loc2_ is Array)
         {
            return _loc2_;
         }
         return [];
      }
      
      public function getPassiveSenjutsuSkills() : Array
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         _loc1_ = this.getCurrentModel();
         if(!_loc1_.isCharacter())
         {
            return [];
         }
         _loc2_ = _loc1_.actions_manager.getSenjutsuPassiveSkills();
         if(_loc2_ is Array)
         {
            return _loc2_;
         }
         return [];
      }
      
      public function getSenjutsuSkills(param1:*) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         _loc2_ = [];
         if(!param1.isCharacter())
         {
            return _loc2_;
         }
         _loc3_ = param1.character_manager.getSenjutsuSkills();
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_.push(_loc3_[_loc4_]);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function checkRestoreCPAfterDealtDamage(param1:int) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         _loc2_ = BattleManager.getBattle().getAttacker();
         _loc3_ = int(_loc2_.effects_manager.getRecoverCPAmountFromDealtDmg());
         if(_loc3_ > 0)
         {
            param1 = Math.floor(_loc3_ * param1 / 100);
            _loc2_.health_manager.addCP(param1,"Restore CP +");
         }
      }
      
      public function checkWeakenEnemy() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc1_ = BattleManager.getBattle().getAttacker();
         _loc2_ = _loc1_.effects_manager.getWeakenEnemyChanceByAttack();
         _loc3_ = NumberUtil.getRandomInt();
         if(_loc2_.chance > _loc3_)
         {
            _loc4_ = {
               "effect":"weaken",
               "duration":_loc2_.duration,
               "amount":_loc2_.amount
            };
            this.addDebuff(_loc4_);
         }
      }
      
      public function checkFreezeEnemy() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc1_ = BattleManager.getBattle().getAttacker();
         _loc2_ = _loc1_.effects_manager.getFreezeEnemyChanceByAttack();
         _loc3_ = NumberUtil.getRandomInt();
         if(_loc2_.chance > _loc3_)
         {
            _loc4_ = {
               "effect":"frozen",
               "duration":_loc2_.duration,
               "amount":80
            };
            this.addDebuff(_loc4_);
         }
      }
      
      public function checkRecoverHPAfterHealthDeduct(param1:int) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = BattleManager.getBattle().getAttacker();
         if(!_loc2_.isCharacter())
         {
            return 0;
         }
         _loc3_ = _loc2_.effects_manager.getRecoverHPAfterDealingDmgByTalent();
         _loc4_ = _loc2_.effects_manager.getRecoverHPFromPassive();
         _loc5_ = NumberUtil.getRandomInt();
         _loc6_ = 0;
         if(_loc3_[0] > _loc5_)
         {
            _loc6_ = Math.floor(_loc3_[1] * param1 / 100);
            _loc2_.health_manager.addHealth(_loc6_,"Dmg Dealt HP +");
         }
         if(_loc4_.effect == "bloodfeed_attack" && BattleVars.ATTACK_TYPE == "weapon")
         {
            if("chance" in _loc4_ && _loc4_.chance >= _loc5_)
            {
               _loc6_ = Math.floor(_loc4_.amount * param1 / 100);
               _loc2_.health_manager.addHealth(_loc6_,"Bloodfeed +");
            }
         }
      }
      
      public function checkRecoverHPAfterAttacked(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         if(!param1.isCharacter())
         {
            return;
         }
         _loc2_ = NumberUtil.getRandomInt();
         _loc3_ = 0;
         _loc4_ = this.getAllCharacterSetEffects();
         for each(_loc5_ in _loc4_)
         {
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.effect == "recover_hp_when_attacked")
               {
                  if(_loc6_.chance >= _loc2_)
                  {
                     _loc3_ = _loc6_.amount;
                     if(_loc6_.calc_type == "percent")
                     {
                        _loc3_ = Math.round(param1.health_manager.getMaxHP() * _loc3_ / 100);
                     }
                  }
                  continue;
                  param1.health_manager.addHealth(_loc3_,"Recovered HP +");
                  return;
               }
            }
         }
      }
      
      public function checkReboundAfterHPDeduct(param1:int) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc2_ = this.getCurrentModel();
         _loc3_ = BattleManager.getBattle().getAttacker();
         this.handleReactiveForce(_loc2_,_loc3_,param1);
         this.handleReboundDamage(_loc2_,_loc3_,param1);
      }
      
      private function handleReactiveForce(param1:Object, param2:Object, param3:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:* = undefined;
         _loc4_ = 0;
         _loc5_ = null;
         _loc6_ = undefined;
         _loc7_ = 30;
         if(param1.isCharacter())
         {
            _loc4_ = param1.character_manager.getEarthAttributes() * 0.4;
            _loc5_ = this.getEquippedSetForEffects("reactive_force");
            _loc4_ = (_loc4_ = BattleManager.modifyChance(_loc5_,"ADD",_loc4_,"reactive_force")) + param1.effects_manager.getIncreaseReactiveFromSlugEarthMastery();
         }
         else
         {
            _loc4_ = Number(param1.getReactiveForce());
         }
         _loc8_ = param1.effects_manager.getActiveBuff("reactive");
         _loc9_ = param1.effects_manager.getActiveDebuff("reactive");
         _loc4_ = BattleManager.modifyChance(_loc8_,"ADD",_loc4_,"reactive_force");
         _loc4_ = BattleManager.modifyChance(_loc9_,"RM",_loc4_,"reactive_force");
         if(_loc8_.length > 0)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc8_[0].length)
            {
               if((_loc12_ = _loc8_[0][_loc8_[1][_loc11_]]).effect == "reactive_force")
               {
                  _loc7_ = int(_loc12_.amount_reactive);
                  _loc4_ += int(_loc12_.amount);
               }
               _loc11_++;
            }
         }
         _loc10_ = NumberUtil.getRandomInt();
         if(_loc4_ > _loc10_)
         {
            _loc6_ = Math.floor(_loc7_ * param3 / 100);
            param2.health_manager.reduceHealth(_loc6_,"Reactive Force HP -");
         }
      }
      
      private function handleReboundDamage(param1:Object, param2:Object, param3:int) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = this.getReboundAndReboundAmountChance();
         _loc5_ = NumberUtil.getRandomInt();
         if(_loc4_[0] > _loc5_)
         {
            _loc6_ = int(_loc4_[1]);
            param3 = Math.floor(_loc6_ * param3 / 100);
            param2.health_manager.reduceHealth(param3,"Rebound HP -");
         }
      }
      
      public function checkReactiveChanceDrop(param1:Number) : Number
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         _loc2_ = this.user_debuffs;
         _loc3_ = this.all_debuffs_name_array;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc2_[_loc3_[_loc4_]];
            if(this.hadEffect(_loc5_.effect) && Effects.doesEffectLowerReactiveForceChance(_loc5_.effect))
            {
               param1 -= _loc5_.amount;
            }
            _loc4_++;
         }
         return param1;
      }
      
      public function activateMeridianKekkai(param1:int, param2:String, param3:*) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         _loc4_ = ["skill","talent","CP -","CP Reduce -","Flaming -","Suffocate -","Prison -","Reduce HP & CP -"];
         _loc5_ = false;
         for each(_loc6_ in _loc4_)
         {
            if(param2 === _loc6_)
            {
               _loc5_ = true;
               break;
            }
         }
         if(!_loc5_)
         {
            this.checkForReboundAsDamage(param1,param3);
         }
      }
      
      public function checkForReboundAsDamage(param1:int, param2:int) : *
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         _loc3_ = 0;
         _loc4_ = null;
         if(!(_loc5_ = this.getCurrentModel()).isCharacter())
         {
            return 0;
         }
         _loc6_ = NumberUtil.getRandomInt();
         _loc7_ = this.getReboundAsDamageByTalent();
         _loc8_ = this.getStunChanceAfterReboundByTalent();
         _loc9_ = BattleManager.getBattle().getAttacker();
         var _loc11_:int = int((_loc10_ = _loc5_).health_manager.getCurrentCP());
         if(!_loc9_.effects_manager.hasDebuffResist(_loc9_))
         {
            if(_loc7_ > 0)
            {
               _loc12_ = Math.round(_loc7_ * param2 / 100);
               _loc3_ = Math.round(_loc7_ * param1 / 100);
               _loc3_ = _loc12_ > _loc3_ ? int(_loc3_) : int(_loc12_);
               if(_loc3_ > 0)
               {
                  _loc9_.health_manager.reduceHealth(_loc3_,"Meridian Kekkai HP -");
               }
            }
            if(_loc3_ > 0 && !this.meridian_kekkai_procced_this_turn)
            {
               this.meridian_kekkai_procced_this_turn = true;
               if((_loc13_ = Boolean(_loc9_.effects_manager.getAcceptChance("stun"))) && _loc8_ >= _loc6_ && !_loc9_.debuff_resist)
               {
                  (_loc4_ = new Object()).effect = "stun";
                  _loc4_.effect_name = "Stun";
                  _loc4_.duration = 1;
                  _loc4_.chance = 100;
                  _loc9_.effects_manager.addDebuff(_loc4_);
               }
            }
         }
      }
      
      public function getAcceptChance(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         _loc2_ = this.getCurrentModel();
         _loc3_ = 0;
         _loc4_ = 0;
         if(param1 == "stun" || param1 == "pet_stun")
         {
            _loc3_ = !!_loc2_.isCharacter() ? 0 : 30;
            _loc4_ = Number(_loc2_.effects_manager.getResistStunPrcByTalent());
            _loc3_ += _loc4_;
         }
         _loc5_ = NumberUtil.getRandomInt();
         return _loc3_ > 0 && _loc3_ >= _loc5_ ? false : true;
      }
      
      public function handleEffectIfImmediately(param1:Object, param2:Array) : Array
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:* = null;
         if(param1.duration === 0)
         {
            return param2;
         }
         _loc3_ = this.getCurrentModel();
         _loc4_ = _loc3_.health_manager;
         _loc5_ = param1 && param1.effect_name ? String(param1.effect_name) : "";
         _loc6_ = param1.effect;
         _loc7_ = _loc3_.effects_manager.hadEffect("skip_turn");
         _loc8_ = {
            "hp":_loc4_.getMaxHP(),
            "cp":_loc4_.getMaxCP(),
            "sp":_loc4_.getMaxSP()
         };
         _loc9_ = {
            "hp":{
               "inc":0,
               "dec":0
            },
            "cp":{
               "inc":0,
               "dec":0
            },
            "sp":{
               "inc":0,
               "dec":0
            }
         };
         switch(_loc6_)
         {
            case "infection":
            case "inquisitor":
               if(Effects.doesEffectDecreaseHealth(_loc6_))
               {
                  _loc9_.hp.dec = this.calculateEffectAmount(0,_loc8_.hp,param1,"amount_reduce");
               }
               break;
            case "chill":
               if(Effects.doesEffectDecreaseHealth(_loc6_))
               {
                  _loc9_.hp.dec = this.calculateEffectAmount(0,_loc8_.hp,param1,"frostbite_amount");
               }
               break;
            case "parasite":
               this.parasiteDrain(param1);
               break;
            case "ultra_burning":
               if(!_loc7_)
               {
                  _loc11_ = 0;
                  for each(_loc12_ in _loc3_.effects_manager.dataDebuff)
                  {
                     if(_loc12_.effect !== "ultra_burning")
                     {
                        _loc11_++;
                     }
                  }
                  if(param1.amount_per_debuff && _loc11_ > 0)
                  {
                     if(param1.calc_type == "number")
                     {
                        _loc9_.hp.dec = param1.amount_per_debuff * _loc11_;
                     }
                     else
                     {
                        _loc13_ = param1.amount_per_debuff * _loc11_;
                        _loc9_.hp.dec = Math.floor(_loc8_.hp * _loc13_ / 100);
                     }
                  }
               }
               break;
            default:
               _loc10_ = {
                  "hp":{
                     "dec":Effects.doesEffectDecreaseHealth(_loc6_) && !_loc7_,
                     "inc":Effects.doesEffectIncreaseHealth(_loc6_) && !_loc7_
                  },
                  "cp":{
                     "dec":Effects.doesEffectDecreaseCP(_loc6_),
                     "inc":Effects.doesEffectIncreaseCP(_loc6_)
                  },
                  "sp":{"dec":Effects.doesEffectDecreaseSP(_loc6_)}
               };
               for(_loc14_ in _loc10_)
               {
                  if(_loc10_[_loc14_].dec)
                  {
                     _loc9_[_loc14_].dec += this.calculateEffectAmount(0,_loc8_[_loc14_],param1,_loc14_ === "cp" ? "amount_cp" : "amount");
                  }
                  if(_loc10_[_loc14_].inc)
                  {
                     _loc9_[_loc14_].inc += this.calculateEffectAmount(0,_loc8_[_loc14_],param1,_loc14_ === "cp" ? "amount_cp" : "amount");
                  }
               }
         }
         if(_loc9_.hp.inc > 0)
         {
            _loc4_.addHealth(_loc9_.hp.inc,_loc5_ + " +");
         }
         if(_loc9_.cp.inc > 0)
         {
            _loc4_.addCP(_loc9_.cp.inc,_loc5_ + " +");
         }
         if(_loc9_.hp.dec > 0)
         {
            _loc4_.reduceHealth(_loc9_.hp.dec,_loc5_ + " -");
         }
         if(_loc9_.cp.dec > 0)
         {
            _loc4_.reduceCP(_loc9_.cp.dec,_loc5_ + " -");
         }
         if(_loc9_.sp.dec > 0)
         {
            _loc4_.reduceSP(_loc9_.sp.dec,_loc5_ + " -");
         }
         if(param1.add_in_array === true)
         {
            param2.push(param1.effect);
         }
         return param2;
      }
      
      private function calculateEffectAmount(param1:int, param2:int, param3:Object, param4:String = "amount") : int
      {
         return this.increaseOrDecreaseByObject(param1,param2,param3,param4);
      }
      
      public function increaseOrDecreaseByObject(param1:int, param2:int, param3:Object, param4:String = "amount") : int
      {
         var _loc5_:Number = NaN;
         var _loc6_:* = false;
         if(!param3)
         {
            return param1;
         }
         _loc6_ = param3.calc_type == "percent";
         if(param4 == "amount_cp")
         {
            _loc5_ = Number(param3.amount_cp) || Number(0);
         }
         else if(param4 == "frostbite_amount")
         {
            _loc5_ = !!_loc6_ ? Number(param3.frostbite_amount) || Number(0) : Number(0);
         }
         else if(param4 == "amount_reduce")
         {
            _loc5_ = !!_loc6_ ? Number(param3.amount_reduce) || Number(0) : Number(0);
         }
         else
         {
            _loc5_ = Number(param3.amount) || Number(0);
         }
         return param1 + (!!_loc6_ ? Math.floor(_loc5_ * param2 / 100) : int(_loc5_));
      }
      
      public function checkPreventDeath(param1:*, param2:int) : int
      {
         var _loc8_:Object = null;
         var _loc9_:* = undefined;
         var _loc3_:* = BattleManager.getBattle().getAttacker();
         var _loc4_:int = int(param1.health_manager.getCurrentCP());
         var _loc5_:int = int(param1.health_manager.getMaxCP());
         var _loc6_:Vector.<Object> = this.dataBuff;
         var _loc7_:Vector.<Object> = this.dataDebuff;
         _loc9_ = param2;
         if((_loc8_ = this.getEffect("unyielding")).duration > 0)
         {
            if(_loc9_ <= 0)
            {
               _loc9_ = 0;
            }
         }
         return _loc9_;
      }
      
      public function checkUnyielding(param1:*) : *
      {
         var _loc3_:Object = null;
         var _loc2_:Vector.<Object> = this.dataBuff;
         if((_loc3_ = this.getEffect("unyielding")).duration > 0)
         {
         }
      }
      
      public function passiveTalentsDisabled() : Boolean
      {
         return this.is_passive_talent_disabled;
      }
      
      public function hasActivePassiveTalent(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         if(this.is_passive_talent_disabled)
         {
            return false;
         }
         _loc2_ = this.getCurrentModel();
         if(!_loc2_ || !_loc2_.isCharacter())
         {
            return false;
         }
         return _loc2_.character_manager.hasTalentSkill(param1);
      }
      
      public function disablePassiveTalentEffect() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = BattleManager.getBattle().getDefender();
         if(_loc1_ && _loc1_.isCharacter())
         {
            _loc2_ = new Object();
            _loc2_.effect = "disable_passive_talent";
            _loc2_.effect_name = "Disable Passive Talent";
            _loc2_.duration = 3;
            _loc2_.chance = 100;
            _loc2_.amount = 0;
            _loc1_.effects_manager.addDebuff(_loc2_);
            _loc1_.effects_manager.is_passive_talent_disabled = true;
            _loc3_ = _loc1_.character_manager.recalculateHP();
            _loc4_ = _loc1_.character_manager.recalculateCP();
            _loc1_.character_info.character_max_hp = _loc3_;
            _loc1_.character_info.character_max_cp = _loc4_;
            if(_loc1_.health_manager.getCurrentHP() > _loc3_)
            {
               _loc1_.health_manager.setCurrentHP(_loc3_);
            }
            if(_loc1_.health_manager.getCurrentCP() > _loc4_)
            {
               _loc1_.health_manager.setCurrentCP(_loc4_);
            }
         }
      }
      
      public function checkReduceHealthEffects(param1:*, param2:int) : int
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc7_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         var _loc18_:int = 0;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:int = 0;
         var _loc22_:Array = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         _loc3_ = undefined;
         _loc4_ = 0;
         if(BattleVars.CAN_NOT_DODGE)
         {
            return param2;
         }
         _loc5_ = BattleManager.getBattle().getAttacker();
         var _loc6_:* = BattleManager.getBattle().getDefender();
         _loc7_ = int(param1.health_manager.getCurrentCP());
         var _loc8_:int = int(param1.health_manager.getMaxCP());
         _loc9_ = (_loc9_ = this.getActiveBuff("damage_reduction")).concat(this.getActiveBuff("damage_reduce"));
         for each(_loc10_ in _loc9_)
         {
            if(_loc10_.duration > 0)
            {
               _loc24_ = 0;
               if(_loc10_.calc_type == "percent")
               {
                  _loc24_ = Math.floor(param2 * _loc10_.amount / 100);
               }
               else
               {
                  _loc24_ = _loc10_.amount;
               }
               param2 -= _loc24_;
            }
         }
         if(param2 <= 0)
         {
            param1.health_manager.createDisplay("0");
            return 0;
         }
         if((_loc11_ = this.getEffect("damage_absorption")).duration > 0 && !BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            _loc3_ = Math.floor(param2 * _loc11_.amount / 100);
            param2 -= _loc3_;
            param1.health_manager.addHealth(_loc3_,"DamageAbsorption ");
            if(param2 <= 0)
            {
               return 0;
            }
         }
         if((_loc12_ = this.getEffect("liquidation_armor")).duration > 0 && !BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            _loc3_ = Math.floor(param2 * _loc12_.amount / 100);
            param2 -= _loc3_;
            param1.health_manager.addHealth(_loc3_,"LiquidationArmor ");
            if(param2 <= 0)
            {
               return 0;
            }
         }
         if((_loc13_ = this.getEffect("venom_spread")).duration > 0)
         {
            _loc25_ = _loc5_.health_manager.getMaxHP();
            _loc26_ = _loc5_.health_manager.getMaxCP();
            _loc27_ = _loc5_.health_manager.getMaxSP();
            _loc28_ = Math.floor(_loc25_ * _loc13_.amount / 100);
            _loc29_ = Math.floor(_loc26_ * _loc13_.amount / 100);
            _loc30_ = Math.floor(_loc27_ * _loc13_.amount / 100);
            _loc5_.health_manager.reduceHealth(_loc28_,"HP - ");
            _loc5_.health_manager.reduceCP(_loc29_,"CP - ");
            _loc5_.health_manager.reduceSP(_loc30_,"SP - ");
         }
         if((_loc14_ = this.getEffect("pet_serene_mind") || this.getEffect("serene_mind")) != null && _loc14_.duration > 0)
         {
            _loc5_.health_manager.reduceHealth(param2,"Pet Serene Mind -");
            return 0;
         }
         if((_loc15_ = this.getEffect("breakthrough")).duration > 0 && !BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            _loc4_ = Math.floor(_loc15_.amount * param2 / 100);
            param2 -= _loc4_;
            _loc5_.health_manager.reduceHealth(_loc4_,"Breakthrough -");
            if(param2 <= 0)
            {
               return 0;
            }
         }
         _loc16_ = this.getEffect("rage");
         if("duration" in _loc16_ && _loc16_.duration > 0)
         {
            _loc5_.health_manager.reduceHealth(param2,"Rage -");
         }
         _loc17_ = this.getEffect("cp_shield");
         _loc18_ = 0;
         if("duration" in _loc17_ && _loc17_.duration > 0 && !BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            param2 = this.applyCPShieldDamageReduction(param1,param2,_loc7_,_loc17_,"CP Shield -");
            _loc7_ = param1.health_manager.getCurrentCP();
         }
         _loc19_ = this.getEffect("pet_cp_shield");
         if("duration" in _loc19_ && _loc19_.duration > 0 && !BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            param2 = this.applyCPShieldDamageReduction(param1,param2,_loc7_,_loc19_,"CP Shield -");
            _loc7_ = param1.health_manager.getCurrentCP();
         }
         _loc20_ = this.getEffect("cp_shield_and_increase_purify");
         if("duration" in _loc20_ && _loc20_.duration > 0 && !BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            param2 = this.applyCPShieldDamageReduction(param1,param2,_loc7_,_loc20_,"CP Shield -",50);
            _loc7_ = param1.health_manager.getCurrentCP();
         }
         _loc21_ = 0;
         _loc22_ = this.getCharacterWeaponEffects();
         if(BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            _loc22_ = [];
         }
         _loc23_ = 0;
         while(_loc23_ < _loc22_.length)
         {
            if(_loc22_[_loc23_].effect == "cp_shield_weapon" && !param1.effects_manager.hadEffect("unyielding"))
            {
               if(param1.health_manager.getCurrentCP() > 0)
               {
                  _loc21_ = Math.floor(param2 * _loc22_[_loc23_].amount / 100);
                  _loc18_ = Math.floor(_loc21_ / _loc22_[_loc23_].amount_cp);
                  if(_loc7_ >= _loc18_)
                  {
                     param2 -= _loc21_;
                     param1.health_manager.reduceCP(int(_loc21_ / 2),"Weapon CP Shield -");
                     if(param2 <= 0)
                     {
                        param1.health_manager.createDisplay("0");
                        return 0;
                     }
                  }
               }
            }
            _loc23_++;
         }
         return int(param2);
      }
      
      private function applyCPShieldDamageReduction(param1:Object, param2:int, param3:int, param4:Object, param5:String, param6:int = 0) : int
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param1 == null || param1.health_manager == null)
         {
            return param2;
         }
         if(param4 == null || param2 <= 0 || param3 <= 0)
         {
            return param2;
         }
         _loc7_ = param6;
         if("amount" in param4)
         {
            _loc7_ = int(param4.amount);
         }
         if(_loc7_ <= 0)
         {
            return param2;
         }
         if(_loc7_ > 100)
         {
            _loc7_ = 100;
         }
         if((_loc8_ = Math.floor(param2 * _loc7_ / 100)) <= 0)
         {
            return param2;
         }
         _loc9_ = _loc8_;
         if("amount_cp" in param4 && int(param4.amount_cp) > 0)
         {
            _loc9_ = int(Math.ceil(_loc8_ / int(param4.amount_cp)));
         }
         if(_loc9_ <= 0)
         {
            return param2;
         }
         _loc10_ = int(Math.min(param3,_loc9_));
         _loc11_ = _loc8_;
         if(_loc10_ < _loc9_)
         {
            _loc11_ = Math.floor(_loc8_ * _loc10_ / _loc9_);
         }
         if(_loc11_ <= 0)
         {
            return param2;
         }
         param1.health_manager.reduceCP(_loc10_,param5);
         param2 -= _loc11_;
         if(param2 <= 0)
         {
            param1.health_manager.createDisplay("0");
            return 0;
         }
         return param2;
      }
      
      public function parasiteDrain(param1:Object) : *
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc2_ = 0;
         _loc3_ = BattleManager.getBattle().getObjectHolder(param1.from_team,param1.from_number).charMc.character_model;
         _loc4_ = BattleManager.getBattle().getAttacker();
         _loc5_ = int(_loc4_.health_manager.getMaxHP());
         _loc6_ = int(_loc4_.health_manager.getCurrentHP());
         if((_loc7_ = int(_loc3_.health_manager.getCurrentHP())) > 0)
         {
            if(param1.calc_type == "percent")
            {
               _loc2_ = Math.floor(param1.amount * _loc6_ / 100);
               if(param1.reduce_type == "MAX")
               {
                  _loc2_ = Math.floor(param1.amount * _loc5_ / 100);
               }
               _loc3_.health_manager.addHealth(_loc2_,"Parasite +");
               _loc4_.health_manager.reduceHealth(_loc2_,"Parasite -");
            }
            else
            {
               _loc3_.health_manager.addHealth(param1.amount,"Parasite +");
               _loc4_.health_manager.reduceHealth(param1.amount,"Parasite -");
            }
         }
      }
      
      public function getMovieClipHolder() : *
      {
         var _loc1_:String = null;
         _loc1_ = "charMc_";
         if(this.user_team == "player_pet")
         {
            _loc1_ = "charPetMc_";
         }
         if(this.user_team == "enemy")
         {
            _loc1_ = "enemyMc_";
         }
         if(this.user_team == "enemy_pet")
         {
            _loc1_ = "enemyPetMc_";
         }
         return BattleManager.getBattle()[_loc1_ + this.user_number];
      }
      
      public function getActiveBuff(param1:String = "") : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         _loc2_ = [];
         _loc3_ = this.getEnabledBuffsFor(param1);
         for each(_loc4_ in this.dataBuff)
         {
            for each(_loc5_ in _loc3_)
            {
               if(_loc4_.effect == _loc5_)
               {
                  _loc2_.push(_loc4_);
               }
            }
         }
         return _loc2_;
      }
      
      public function getActiveDebuff(param1:String = "") : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         _loc2_ = [];
         _loc3_ = this.getEnabledDebuffsFor(param1);
         for each(_loc4_ in this.dataDebuff)
         {
            for each(_loc5_ in _loc3_)
            {
               if(_loc4_.effect == _loc5_)
               {
                  _loc2_.push(_loc4_);
               }
            }
         }
         return _loc2_;
      }
      
      public function clearAllEffect() : void
      {
         var _loc1_:Object = null;
         this.dataBuff = new Vector.<Object>();
         this.dataDebuff = new Vector.<Object>();
         this.is_passive_talent_disabled = false;
         _loc1_ = this.getCurrentModel();
         if(_loc1_ != null && _loc1_.knowledge_of_time != null)
         {
            _loc1_.knowledge_of_time.is_active = false;
            _loc1_.knowledge_of_time.stored_damage = 0;
            _loc1_.knowledge_of_time.max_store = 0;
            _loc1_.knowledge_of_time.heal_block_turns = 0;
         }
      }
      
      public function getActiveEffects(param1:String = "") : Vector.<Object>
      {
         var _loc2_:Vector.<Object> = null;
         return this.dataBuff.concat(this.dataDebuff);
      }
      
      public function getEnabledBuffsFor(param1:*) : Array
      {
         if(param1 == "")
         {
            return this.all_buffs_name_array;
         }
         if(param1 == "accuracy")
         {
            return ["accuracy_percent","increase_accuracy","aqua_regia","unyielding","invincible","attention","pet_attention","toad_attention","lightning_armor","pet_lightning_armor","kontol_memek_jembut","solar_might"];
         }
         if(param1 == "dodge")
         {
            return ["dodge_percent","invincible","pet_energize","energize","reflexes","flexible","pet_flexible","peace","overwhelm","meditation","evade","deka_kontol"];
         }
         if(param1 == "cp_costing")
         {
            return ["reduce_cp_consumption","excitation","pet_ocean_atmosphere","ocean_atmosphere","boundless"];
         }
         if(param1 == "critical")
         {
            return ["critical_percent","pet_energize","energize","concentration","pet_concentration","toad_concentration","lightning_armor","pet_lightning_armor","pet_frenzy","kontol_jembut_memek","critical_buff_n_received_stun"];
         }
         if(param1 == "combustion")
         {
            return ["combustion_percent","pet_energize","energize"];
         }
         if(param1 == "purify")
         {
            return ["purify_percent","aqua_regia","pet_energize","energize"];
         }
         if(param1 == "reactive")
         {
            return ["reactive_force"];
         }
         if(param1 == "agility")
         {
            return ["increase_agility"];
         }
         if(param1 == "damage_reduction" || param1 == "damage_reduce" || param1 == "defense")
         {
            return ["damage_reduction","damage_reduce","defense_percent"];
         }
         return [];
      }
      
      public function getEnabledDebuffsFor(param1:*) : Array
      {
         if(param1 == "")
         {
            return this.all_debuffs_name_array;
         }
         if(param1 == "accuracy")
         {
            return ["accuracy_reduction","darkness","blind","pet_blind"];
         }
         if(param1 == "dodge")
         {
            return ["dodge_reduction","silhouette","darkness","disorient","pet_disorient","disorient_2","pet_numb","numb","conduction","pet_conduction","dark_curse","embrace"];
         }
         if(param1 == "damage_percent")
         {
            return ["damage_reduction","damage_percent","disorient","disorient_2","pet_disorient"];
         }
         if(param1 == "combustion")
         {
            return ["pet_disorient","disorient_2","disorient","decrease_combustion_chance"];
         }
         if(param1 == "purify")
         {
            return ["pet_disorient","disorient","disorient_2","decrease_purify_active","embrace","muddy","pet_muddy","clarify"];
         }
         if(param1 == "cp_costing")
         {
            return ["cp_cost","transform"];
         }
         if(param1 == "critical")
         {
            return ["isolate","pet_disorient","disorient","disorient_2","dark_curse","decrease_critical_chance","distract","pet_distract"];
         }
         if(param1 == "reactive")
         {
            return ["decrease_reactive_chance","disorient","disorient_2","pet_disorient","weak_body"];
         }
         if(param1 == "agility")
         {
            return ["slow","pet_slow","slow_oil"];
         }
         return [];
      }
      
      public function getAllBuffs() : Object
      {
         return Effects.all_buffs;
      }
      
      public function getAllDebuffs() : Object
      {
         return Effects.all_debuffs;
      }
      
      public function destroy() : *
      {
         var _loc1_:* = undefined;
         GF.clearArray(this.all_buffs_name_array);
         GF.clearArray(this.all_debuffs_name_array);
         GF.clearArray(this.allSetEffects);
         Effects.destroy();
         this.dataBuff = null;
         this.dataDebuff = null;
         this.allSetEffects = null;
         this.all_buffs_name_array = null;
         this.all_debuffs_name_array = null;
         this.user_team = null;
         this.user_number = 0;
         this.cooldownListFromSenjutsu = null;
         this.cooldownListFromTalent = null;
         this.tempt_skills_used_for_senjutsu = null;
         this.tempt_skills_used_for_talent = null;
         for each(_loc1_ in this.user_buffs)
         {
            this.user_buffs[_loc1_] = null;
         }
         this.user_buffs = null;
         for each(_loc1_ in this.user_debuffs)
         {
            this.user_debuffs[_loc1_] = null;
         }
         this.user_debuffs = null;
         _loc1_ = null;
         this.all_debuffs_name_array = null;
         this.model = null;
         activeBackgroundModel = null;
      }
   }
}
