package Combat
{
   import Storage.PetInfo;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.base.PetModelBase;
   
   public class PetModel extends PetModelBase
   {
      
      public var player_identification:String;
      
      public var pet_data:*;
      
      public var theft_mode:Boolean = false;
      
      public var blood_tax_mode:Boolean = false;
      
      public var unyielding_mode:Boolean = false;
      
      public var debuff_resist:Boolean = false;
      
      public var IS_BLOCK_DAMAGE:Boolean = false;
      
      public var IS_DODGED:Boolean = false;
      
      public var IS_CHAOS:Boolean = false;
      
      public var pet_movieclip_holder:String;
      
      public var health_manager:HealthManager;
      
      public var effects_manager:EffectsManager;
      
      private var enemy_ai:EnemyAI;
      
      public var attack_results:Array;
      
      public var attack_result:Object;
      
      public var knowledge_of_time:Object = {};
      
      public var background_active:Boolean = false;
      
      private var destroyed:* = false;
      
      public function PetModel(param1:String, param2:int, param3:String, param4:*)
      {
         super(param1,param2);
         this.attack_results = [];
         this.attack_result = {
            "damage":0,
            "effects":[],
            "multi_hit":false,
            "self_target":false
         };
         this.knowledge_of_time = {
            "is_active":false,
            "stored_damage":0,
            "max_store":0,
            "heal_block_turns":0
         };
         this.player_identification = param3;
         this.pet_data = param4;
         this.health_manager = new HealthManager(this.pet_team + "_pet",this.pet_number);
         this.effects_manager = new EffectsManager(this.pet_team + "_pet",this.pet_number);
         this.pet_movieclip_holder = this.pet_team == "player" ? "charPetMc_" : "enemyPetMc_";
         BattleManager.getBattle()[this.pet_movieclip_holder + this.pet_number].charMc.scaleX = this.pet_team == "player" ? -1 : 1;
         this.enemy_ai = new EnemyAI();
         BattleManager.getMain().loadPetSWF(this.player_identification,this.onPetLoaded);
      }
      
      public function getPetMovieClipHolder() : *
      {
         return BattleManager.getBattle()[this.pet_movieclip_holder + this.pet_number];
      }
      
      public function onPetLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         this.pet_info = PetInfo.getCopy(this.pet_data.pet_swf);
         this.pet_info.pet_level = this.pet_data.pet_level;
         this.pet_info.pet_name = this.pet_data.pet_name;
         this.pet_info.pet_hp = 60 + int(this.pet_info.pet_level) * 40;
         this.pet_info.pet_max_hp = this.pet_info.pet_hp;
         this.pet_info.pet_cp = 60 + int(this.pet_info.pet_level) * 40;
         this.pet_info.pet_max_cp = this.pet_info.pet_cp;
         this.pet_info.pet_agility = 9 + int(this.pet_info.pet_level);
         this.pet_info.team = this.pet_team;
         this.pet_info.num = this.pet_number;
         this.pet_info.pet_skills = "";
         this.pet_info.skills_available = this.pet_data.pet_skills.split(",");
         this.pet_info.curr_skill_cooldowns = [0,0,0,0,0,0];
         this.object_mc = param1.target.content[this.player_identification];
         this.object_mc.gotoAndStop(1);
         this.object_head = param1.target.content["pet_head"];
         this.setFrameScript();
         this.object_mc.scaleX = this.pet_info.size_x * BattleVars.PET_SCALE;
         this.object_mc.scaleY = this.pet_info.size_y * BattleVars.PET_SCALE;
         GF.removeAllChild(this.getPetMovieClipHolder().charMc);
         this.getPetMovieClipHolder().charMc.addChild(this.object_mc);
         this.getPetMovieClipHolder().charMc.character_model = this;
         this.getPetMovieClipHolder().visible = true;
         this.health_manager.fillHealth(this.pet_info);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
      }
      
      public function viceRapidCooldown(param1:int, param2:String) : *
      {
         var _loc3_:* = 1;
         while(_loc3_ < this.pet_info.curr_skill_cooldowns.length)
         {
            this.pet_info.curr_skill_cooldowns[_loc3_] = int(this.pet_info.curr_skill_cooldowns[_loc3_]) + param1;
            _loc3_++;
         }
         Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),param2);
      }
      
      public function randomOblivion(param1:int, param2:String = "", param3:int = 0) : *
      {
         var _loc4_:* = NumberUtil.randomInt(0,this.pet_info.curr_skill_cooldowns.length - 1);
         if(this.pet_info.curr_skill_cooldowns[_loc4_] == 0)
         {
            this.pet_info.curr_skill_cooldowns[_loc4_] = param1;
            Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),param2);
         }
         else if(param3 < this.pet_info.curr_skill_cooldowns.length)
         {
            param3++;
            this.randomOblivion(param1,param2,param3);
         }
         else
         {
            this.pet_info.curr_skill_cooldowns[_loc4_] = param1;
            Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),param2);
         }
      }
      
      public function resetCooldowns(param1:int = 0) : *
      {
         var _loc2_:* = NumberUtil.randomInt(0,this.pet_info.curr_skill_cooldowns.length - 1);
         if(this.pet_info.curr_skill_cooldowns[_loc2_] > 0)
         {
            this.pet_info.curr_skill_cooldowns[_loc2_] = 0;
         }
         else if(param1 < this.pet_info.curr_skill_cooldowns.length)
         {
            param1++;
            this.resetCooldowns(param1);
         }
      }
      
      public function targetIsSleeping() : *
      {
         var target:int = 0;
         var target_model:* = undefined;
         try
         {
            target = this.pet_team == "player" ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET;
            target_model = this.pet_team == "player" ? BattleManager.getBattle().enemy_team_players[target] : BattleManager.getBattle().character_team_players[target];
            if(Boolean(target_model.effects_manager.hadEffect("sleep")) || Boolean(target_model.effects_manager.hadEffect("pet_sleep")))
            {
               return true;
            }
         }
         catch(e:*)
         {
            Log.error(this,"targetIsSleeping",e);
         }
         return false;
      }
      
      public function getAttack(param1:Boolean = true, param2:int = 0) : *
      {
         var _loc9_:Object = null;
         var _loc23_:* = undefined;
         if(param1)
         {
            _loc23_ = 0;
            while(_loc23_ < this.pet_info.curr_skill_cooldowns.length)
            {
               if(this.pet_info.curr_skill_cooldowns[_loc23_] > 0)
               {
                  --this.pet_info.curr_skill_cooldowns[_loc23_];
               }
               _loc23_++;
            }
         }
         var _loc3_:* = BattleManager.getBattle();
         var _loc4_:String = this.pet_team;
         var _loc5_:String = this.pet_team == "player" ? "enemy" : "player";
         var _loc6_:Array = this.pet_team == "player" ? _loc3_.enemy_team_players : _loc3_.character_team_players;
         var _loc7_:Array = this.pet_team == "player" ? _loc3_.character_team_players : _loc3_.enemy_team_players;
         var _loc8_:Boolean = !this.pet_info.hasOwnProperty("pet_ai") || Boolean(this.pet_info.pet_ai);
         if(_loc8_)
         {
            _loc9_ = this.enemy_ai.decideAction(this,_loc6_,_loc7_);
         }
         else
         {
            _loc9_ = this.getRandomAttackDecision(_loc6_);
         }
         if(_loc9_ == null || !_loc9_.hasOwnProperty("index"))
         {
            _loc9_ = {
               "type":-1,
               "index":0,
               "target":0,
               "is_friendly_target":false
            };
         }
         if(!_loc9_.hasOwnProperty("target"))
         {
            _loc9_.target = 0;
         }
         var _loc10_:* = int(_loc9_.index);
         if(_loc10_ < 0 || _loc10_ >= this.pet_info.attacks.length)
         {
            _loc10_ = 0;
         }
         var _loc11_:Object = this.pet_info.attacks[_loc10_];
         var _loc12_:Boolean = this.isOpponentTargetSkill(_loc11_);
         var _loc13_:Boolean = Boolean(_loc9_.is_friendly_target) && !_loc12_;
         var _loc14_:Array = _loc13_ ? _loc7_ : _loc6_;
         var _loc15_:int = this.normalizeLiveTargetIndex(int(_loc9_.target),_loc14_);
         if(_loc13_)
         {
            _loc3_.setDefender(_loc4_,_loc15_);
         }
         else
         {
            if(this.pet_team == "player")
            {
               BattleVars.PLAYER_TARGET = _loc15_;
            }
            else
            {
               BattleVars.ENEMY_TARGET = _loc15_;
            }
            _loc3_.setDefender(_loc5_,_loc15_);
         }
         this.pet_info.curr_skill_cooldowns[_loc10_] = this.pet_info.attacks[_loc10_].cooldown;
         var _loc16_:* = _loc15_;
         var _loc17_:Boolean = this.targetIsSleeping();
         var _loc18_:* = Math.round(3 * this.pet_info.pet_level);
         var _loc19_:* = Math.floor(_loc11_.dmg * _loc18_);
         if("is_static" in _loc11_ && Boolean(_loc11_.is_static))
         {
            _loc19_ = Math.floor(_loc11_.dmg);
         }
         var _loc20_:* = _loc11_.effects;
         var _loc21_:Boolean = "is_self_skill" in _loc11_ ? Boolean(_loc11_.is_self_skill) : false;
         var _loc22_:Boolean = "multi_hit" in _loc11_ ? Boolean(_loc11_.multi_hit) : false;
         if(_loc17_ && !_loc21_)
         {
            this.pet_info.curr_skill_cooldowns[_loc10_] = 0;
            BattleManager.startRun();
            return [0,[],false,false];
         }
         _loc20_ = BattleManager.getBattle().checkForDisperse(_loc20_);
         this.gotoAttackPos(_loc16_,_loc11_.posType);
         this.attack_results = [_loc19_,_loc20_,_loc22_,_loc21_];
         this.attack_result = {
            "damage":_loc19_,
            "effects":_loc20_,
            "multi_hit":_loc22_,
            "self_target":_loc21_
         };
         this.object_mc.gotoAndPlay(_loc11_.animation);
         if(BattleManager.getBattle().showGUI)
         {
            BattleManager.giveMessage(_loc11_.name);
         }
         return _loc11_;
      }
      
      private function getRandomAttackDecision(param1:Array) : Object
      {
         var _loc2_:Array = [];
         var _loc3_:int = Math.min(this.pet_info.attacks.length,this.pet_info.curr_skill_cooldowns.length,this.pet_info.skills_available.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.pet_info.curr_skill_cooldowns[_loc4_] <= 0 && this.pet_info.skills_available[_loc4_] != "0")
            {
               _loc2_.push(_loc4_);
            }
            _loc4_++;
         }
         var _loc5_:int = 0;
         if(_loc2_.length > 0)
         {
            _loc5_ = int(_loc2_[NumberUtil.randomInt(0,_loc2_.length - 1)]);
         }
         return {
            "type":-1,
            "index":_loc5_,
            "target":this.getRandomTargetIndex(param1),
            "is_friendly_target":false
         };
      }
      
      private function getRandomTargetIndex(param1:Array) : int
      {
         var _loc4_:Object = null;
         if(param1 == null || param1.length == 0)
         {
            return 0;
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_ != null && _loc4_.health_manager != null && !_loc4_.health_manager.isDead())
            {
               _loc2_.push(_loc3_);
            }
            _loc3_++;
         }
         if(_loc2_.length == 0)
         {
            return 0;
         }
         return int(_loc2_[NumberUtil.randomInt(0,_loc2_.length - 1)]);
      }
      
      private function isOpponentTargetSkill(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(this.skillHasIntrinsicDamage(param1))
         {
            return true;
         }
         if(this.skillHasEnemyEffect(param1))
         {
            return true;
         }
         if("is_self_skill" in param1 && Boolean(param1.is_self_skill))
         {
            return false;
         }
         return false;
      }
      
      private function skillHasEnemyEffect(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:Array = param1 != null && "effects" in param1 ? param1.effects : null;
         if(_loc2_ == null)
         {
            return false;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ != null && "target" in _loc3_ && _loc3_.target == "enemy")
            {
               return true;
            }
         }
         return false;
      }
      
      private function skillHasIntrinsicDamage(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if("dmg" in param1 && Number(param1.dmg) > 0)
         {
            return true;
         }
         if("skill_damage" in param1 && Number(param1.skill_damage) > 0)
         {
            return true;
         }
         if("talent_skill_damage" in param1 && Number(param1.talent_skill_damage) > 0)
         {
            return true;
         }
         if("damage" in param1 && Number(param1.damage) > 0)
         {
            return true;
         }
         return false;
      }
      
      private function normalizeLiveTargetIndex(param1:int, param2:Array) : int
      {
         var _loc4_:Object = null;
         if(param2 == null || param2.length == 0)
         {
            return 0;
         }
         if(param1 >= 0 && param1 < param2.length && param2[param1] != null && param2[param1].health_manager != null && !param2[param1].health_manager.isDead())
         {
            return param1;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = param2[_loc3_];
            if(_loc4_ != null && _loc4_.health_manager != null && !_loc4_.health_manager.isDead())
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      override public function standByFrameEnd() : *
      {
         super.standByFrameEnd();
      }
      
      override public function attackHit() : *
      {
         BattleManager.getBattle().hitByPet();
      }
      
      override public function attackFinish() : *
      {
         super.attackFinish();
         BattleManager.getBattle().petAttacked();
      }
      
      override public function dodgeFrame() : *
      {
         super.dodgeFrame();
      }
      
      override public function attackedFrame() : *
      {
         super.attackedFrame();
      }
      
      override public function deadFrame() : *
      {
         super.deadFrame();
      }
      
      override public function addFullScreen() : *
      {
         super.addFullScreen();
         if(this.object_mc.hasOwnProperty("fullScreenEffect"))
         {
            BattleManager.getMain().loader.addChild(this.object_mc.fullScreenEffect);
         }
      }
      
      override public function removeFullScreen() : *
      {
         if(this.object_mc.hasOwnProperty("fullScreenEffect"))
         {
            BattleManager.getMain().loader.removeChild(this.object_mc.fullScreenEffect);
         }
         super.removeFullScreen();
      }
      
      public function handleChaos() : *
      {
         BattleManager.startRun();
      }
      
      public function getAccuracy() : int
      {
         var _loc1_:int = int(this.pet_info.pet_accuracy);
         var _loc2_:Array = this.effects_manager.getActiveBuff("accuracy");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("accuracy");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"accuracy");
         return BattleManager.modifyChance(_loc3_,"RM",_loc1_,"accuracy");
      }
      
      public function getDodgeRate() : int
      {
         var _loc1_:int = int(this.pet_info.pet_dodge);
         var _loc2_:Array = this.effects_manager.getActiveBuff("dodge");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("dodge");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"dodge");
         return BattleManager.modifyChance(_loc3_,"RM",_loc1_,"dodge");
      }
      
      public function getCombustionChance() : int
      {
         var _loc1_:Number = Number(this.pet_info.pet_combustion);
         var _loc2_:Array = this.effects_manager.getActiveBuff("combustion");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("combustion");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_);
         return BattleManager.modifyChance(_loc3_,"RM",_loc1_);
      }
      
      public function getCriticalChance() : int
      {
         var _loc1_:Number = Number(this.pet_info.pet_critical);
         var _loc2_:Array = this.effects_manager.getActiveBuff("critical");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("critical");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"critical");
         return BattleManager.modifyChance(_loc3_,"RM",_loc1_,"critical");
      }
      
      public function getPurify() : int
      {
         var _loc1_:Number = Number(this.pet_info.pet_purify);
         var _loc2_:Array = this.effects_manager.getActiveBuff("purify");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("purify");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"purify");
         return BattleManager.modifyChance(_loc3_,"RM",_loc1_,"purify");
      }
      
      public function getReactiveForce() : int
      {
         return 0;
      }
      
      public function getAttackResults() : Array
      {
         return this.attack_results;
      }
      
      public function getAttackResult() : Object
      {
         return this.attack_result;
      }
      
      public function getAgility() : Number
      {
         return Number(this.pet_info.pet_agility);
      }
      
      public function getHead() : MovieClip
      {
         return this.object_head;
      }
      
      public function getLevel() : int
      {
         return this.pet_info.pet_level;
      }
      
      public function isDead() : Boolean
      {
         return this.health_manager.isDead();
      }
      
      public function isEnemy() : Boolean
      {
         return false;
      }
      
      public function isNpc() : Boolean
      {
         return false;
      }
      
      public function checkBlockDamage() : Boolean
      {
         return false;
      }
      
      public function checkConvertDamage() : Boolean
      {
         return false;
      }
      
      public function checkConvertDamageCP() : Boolean
      {
         return false;
      }
      
      public function reduceHealth(param1:int) : *
      {
         this.health_manager.reduceHealth(param1);
      }
      
      override public function playAnimation(param1:String) : *
      {
         super.playAnimation(param1);
      }
      
      override public function destroy() : *
      {
         var _loc2_:* = undefined;
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         Log.info(this,"destroy",this.player_identification);
         super.destroy();
         if(this.enemy_ai)
         {
            this.enemy_ai.destroy();
         }
         this.enemy_ai = null;
         var _loc1_:* = BattleManager.getBattle();
         if(Boolean(_loc1_) && this.pet_movieclip_holder + this.pet_number in _loc1_)
         {
            _loc2_ = _loc1_[this.pet_movieclip_holder + this.pet_number];
            if(this.object_mc != null && Boolean(_loc2_.charMc.contains(this.object_mc)))
            {
               _loc2_.charMc.removeChild(this.object_mc);
            }
            GF.removeAllChild(_loc2_.charMc);
            _loc2_.charMc.character_model = null;
            if("skillMc" in _loc2_)
            {
               GF.removeAllChild(_loc2_.skillMc);
            }
            GF.removeAllChild(_loc2_);
            _loc1_ = null;
            _loc2_ = null;
         }
         this.player_identification = null;
         this.pet_data = null;
         this.pet_movieclip_holder = null;
         this.health_manager.destroy();
         this.health_manager = null;
         this.effects_manager.destroy();
         this.effects_manager = null;
         GF.clearArray(this.attack_results);
         this.attack_results = null;
         this.attack_result = null;
      }
   }
}

