package Combat
{
   import Managers.NinjaSage;
   import Storage.EnemyInfo;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.setTimeout;
   import id.ninjasage.Log;
   
   public class EnemyModel
   {
       
      
      public var player_team:String;
      
      public var player_number:int;
      
      public var player_identification:String;
      
      public var movieclip_holder:String;
      
      public var enemy_info;
      
      public var health_manager:HealthManager;
      
      public var effects_manager:EffectsManager;
      
      public var object_mc:MovieClip;
      
      public var object_head:MovieClip;
      
      public var attack_results:Array;
      
      public var attack_result:Object;
      
      public var theft_mode:Boolean = false;
      
      public var blood_tax_mode:Boolean = false;
      
      public var unyielding_mode:Boolean = false;
      
      public var debuff_resist:Boolean = false;
      
      public var IS_BLOCK_DAMAGE:Boolean = false;
      
      public var IS_DODGED:Boolean = false;
      
      public var IS_CHAOS:Boolean = false;
      
      public var knowledge_of_time:Object;
      
      public var background_active:Boolean = false;
      
      private var mode:String;
      
      private var stage_mode:String;
      
      private var enemy_ai:EnemyAI;
      
      private var stage_element_list:Array;
      
      private var currentAttackIndex:int = -1;
      
      public function EnemyModel(param1:String, param2:int, param3:String)
      {
         this.knowledge_of_time = {};
         this.stage_element_list = ["wind","fire","thunder","earth","water"];
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
         super();
         this.enemy_ai = new EnemyAI();
         this.player_team = param1;
         this.player_number = param2;
         this.player_identification = param3;
         this.movieclip_holder = this.player_team == "player" ? "charMc_" : "enemyMc_";
         this.effects_manager = new EffectsManager(this.player_team,this.player_number);
         BattleManager.getBattle()[this.movieclip_holder + this.player_number].charMc.scaleX = this.player_team == "player" ? -1 : 1;
         BattleManager.getMain().loadEnemySWF(this.player_identification,this.onEnemyLoaded);
      }
      
      public function onEnemyLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         this.enemy_info = EnemyInfo.getCopy(this.player_identification);
         this.enemy_info.curr_skill_cooldowns = [];
         this.enemy_info.used_skill_order = [];
         this.enemy_info.order_used_count = 0;
         this.enemy_info.next_skill = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.enemy_info.attacks.length)
         {
            this.enemy_info.curr_skill_cooldowns.push(0);
            this.enemy_info.used_skill_order.push(false);
            _loc3_++;
         }
         this.object_mc = param1.target.content[this.player_identification];
         this.object_mc.gotoAndStop(1);
         this.object_head = param1.target.content["enemy_head"];
         this.setFrameScript();
         this.object_mc.scaleX = this.enemy_info.size_x * BattleVars.ENEMY_SCALE;
         this.object_mc.scaleY = this.enemy_info.size_y * BattleVars.ENEMY_SCALE;
         GF.removeAllChild(BattleManager.getBattle()[this.movieclip_holder + this.player_number].charMc);
         BattleManager.getBattle()[this.movieclip_holder + this.player_number].charMc.addChild(this.object_mc);
         BattleManager.getBattle()[this.movieclip_holder + this.player_number].charMc.character_model = this;
         this.health_manager = new HealthManager(this.player_team,this.player_number);
         this.health_manager.fillHealth(this.enemy_info);
         var _loc4_:int = this.player_number + 1;
         if(this.player_team != "player")
         {
            setTimeout(BattleManager.loadEnemyTeam,100,_loc4_);
         }
         else
         {
            setTimeout(BattleManager.loadPlayerTeam,100,_loc4_);
         }
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
      }
      
      public function findSkillByOrder() : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!this.enemy_info.attacks[0].hasOwnProperty("order"))
         {
            return -1;
         }
         var _loc1_:int = 0;
         var _loc2_:Array = this.enemy_info.attacks;
         if(this.enemy_info.order_used_count == _loc2_.length)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.enemy_info.used_skill_order[_loc3_] = false;
               _loc3_++;
            }
            this.enemy_info.order_used_count = 0;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc1_ = int(_loc2_[_loc4_].order);
               if(_loc1_ == _loc3_ && this.enemy_info.curr_skill_cooldowns[_loc4_] < 1 && !this.enemy_info.used_skill_order[_loc4_])
               {
                  this.enemy_info.used_skill_order[_loc4_] = true;
                  ++this.enemy_info.order_used_count;
                  return _loc4_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function viceRapidCooldown(param1:int, param2:String) : *
      {
         var text:String = null;
         var cooldown:int = param1;
         var effectName:String = param2;
         var s:* = undefined;
         var total:int = cooldown;
         text = effectName;
         try
         {
            s = 1;
            while(s < this.enemy_info.curr_skill_cooldowns.length)
            {
               this.enemy_info.curr_skill_cooldowns[s] = int(this.enemy_info.curr_skill_cooldowns[s]) + total;
               s++;
            }
            Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),text,false);
         }
         catch(e:*)
         {
            Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),text,false);
         }
      }
      
      public function randomOblivion(param1:int, param2:String = "", param3:int = 0) : *
      {
         var text:String = null;
         var cooldown:int = param1;
         var effectName:String = param2;
         var counter:int = param3;
         var rand_skill_id:* = undefined;
         var amount:int = cooldown;
         text = effectName;
         var retries:int = counter;
         try
         {
            rand_skill_id = NumberUtil.randomInt(0,this.enemy_info.curr_skill_cooldowns.length - 1);
            if(this.enemy_info.curr_skill_cooldowns[rand_skill_id] == 0)
            {
               this.enemy_info.curr_skill_cooldowns[rand_skill_id] = amount;
               Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),text,false);
            }
            else if(retries < this.enemy_info.curr_skill_cooldowns.length)
            {
               retries++;
               this.randomOblivion(amount,text,retries);
            }
            else
            {
               this.enemy_info.curr_skill_cooldowns[rand_skill_id] = amount;
               Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),text,false);
            }
         }
         catch(e:*)
         {
            Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),text,false);
         }
      }
      
      public function setModes(param1:String, param2:String) : Boolean
      {
         this.stage_mode = param1;
         this.mode = param2;
         var _loc3_:int = 0;
         while(_loc3_ < this.enemy_info.curr_skill_cooldowns.length)
         {
            this.enemy_info.curr_skill_cooldowns[_loc3_] = 0;
            _loc3_++;
         }
         if(!this.isDead())
         {
            this.object_mc.gotoAndPlay(25);
            return true;
         }
         return false;
      }
      
      public function targetIsSleeping() : *
      {
         var target:int = 0;
         var target_model:* = undefined;
         try
         {
            target = this.player_team == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
            target_model = this.player_team == "player" ? BattleManager.getBattle().enemy_team_players[target] : BattleManager.getBattle().character_team_players[target];
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
         var _loc3_:* = 0;
         while(_loc3_ < this.enemy_info.curr_skill_cooldowns.length)
         {
            if(this.enemy_info.curr_skill_cooldowns[_loc3_] > 0 && param1)
            {
               --this.enemy_info.curr_skill_cooldowns[_loc3_];
            }
            _loc3_++;
         }
         var _loc4_:* = 0;
         var _loc5_:* = BattleManager.getBattle();
         var _loc6_:Array = this.player_team == "player" ? _loc5_.enemy_team_players : _loc5_.character_team_players;
         var _loc7_:Array = this.player_team == "player" ? _loc5_.character_team_players : _loc5_.enemy_team_players;
         var _loc8_:Boolean;
         if(_loc8_ = !this.enemy_info.hasOwnProperty("enemy_ai") || Boolean(this.enemy_info.enemy_ai))
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
         if((_loc4_ = int(_loc9_.index)) < 0 || _loc4_ >= this.enemy_info.attacks.length)
         {
            _loc4_ = 0;
         }
         if(this.enemy_info.attacks[_loc4_].hasOwnProperty("next_skill"))
         {
            this.enemy_info.next_skill = this.enemy_info.attacks[_loc4_].next_skill;
         }
         else if(this.enemy_info.next_skill == _loc4_)
         {
            this.enemy_info.next_skill = -1;
         }
         var _loc10_:String = this.player_team;
         var _loc11_:String = this.player_team == "player" ? "enemy" : "player";
         var _loc12_:Object = this.enemy_info.attacks[_loc4_];
         var _loc13_:Boolean = this.isOpponentTargetSkill(_loc12_);
         var _loc15_:Array = !!(_loc14_ = Boolean(_loc9_.is_friendly_target && !_loc13_)) ? _loc7_ : _loc6_;
         _loc9_.target = this.normalizeLiveTargetIndex(int(_loc9_.target),_loc15_);
         if(_loc14_)
         {
            BattleManager.getBattle().setDefender(_loc10_,_loc9_.target);
         }
         else
         {
            if(this.player_team == "player")
            {
               BattleVars.PLAYER_TARGET = _loc9_.target;
            }
            else
            {
               BattleVars.ENEMY_TARGET = _loc9_.target;
            }
            BattleManager.getBattle().setDefender(_loc11_,_loc9_.target);
         }
         this.enemy_info.curr_skill_cooldowns[_loc4_] = this.enemy_info.attacks[_loc4_].cooldown;
         var _loc16_:* = BattleManager.getBattle().getDefender();
         var _loc17_:* = Math.round(20 + this.getLevel() / 2 * (1 + 0.06 * this.getLevel()));
         this.currentAttackIndex = _loc4_;
         var _loc18_:* = Math.floor(_loc12_.dmg * _loc17_);
         if("is_static" in _loc12_ && Boolean(_loc12_.is_static))
         {
            _loc18_ = Math.floor(_loc12_.dmg);
         }
         var _loc19_:* = "multi_hit" in _loc12_ ? _loc12_.multi_hit : false;
         var _loc20_:Boolean = "is_self_skill" in _loc12_ ? Boolean(Boolean(_loc12_.is_self_skill)) : false;
         var _loc21_:Boolean;
         if((_loc21_ = this.targetIsSleeping()) && !_loc20_)
         {
            this.enemy_info.curr_skill_cooldowns[_loc4_] = 0;
            BattleManager.startRun();
            return [0,[],false,false];
         }
         var _loc22_:* = _loc12_.effects;
         _loc22_ = BattleManager.getBattle().checkForDisperse(_loc22_);
         var _loc23_:int = this.player_team == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
         this.gotoAttackPos(_loc12_,_loc23_,_loc19_);
         this.attack_results = [_loc18_,_loc22_,_loc19_,_loc20_];
         this.attack_result = {
            "damage":_loc18_,
            "effects":_loc22_,
            "multi_hit":_loc19_,
            "self_target":_loc20_
         };
         this.object_mc.gotoAndPlay(_loc12_.animation);
         return _loc12_;
      }
      
      private function getRandomAttackDecision(param1:Array) : Object
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.enemy_info.attacks.length)
         {
            if(_loc3_ >= this.enemy_info.curr_skill_cooldowns.length || this.enemy_info.curr_skill_cooldowns[_loc3_] <= 0)
            {
               _loc2_.push(_loc3_);
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         if(_loc2_.length > 0)
         {
            _loc4_ = int(_loc2_[NumberUtil.randomInt(0,_loc2_.length - 1)]);
         }
         return {
            "type":-1,
            "index":_loc4_,
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
            if((_loc4_ = param1[_loc3_]) != null && _loc4_.health_manager != null && !_loc4_.health_manager.isDead())
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
         if(param1.hasOwnProperty("is_self_skill") && Boolean(param1.is_self_skill))
         {
            return false;
         }
         return false;
      }
      
      private function skillHasEnemyEffect(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:Array = param1 != null && param1.hasOwnProperty("effects") ? param1.effects : null;
         if(_loc2_ == null)
         {
            return false;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ != null && _loc3_.hasOwnProperty("target") && _loc3_.target == "enemy")
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
         if(param1.hasOwnProperty("dmg") && Number(param1.dmg) > 0)
         {
            return true;
         }
         if(param1.hasOwnProperty("skill_damage") && Number(param1.skill_damage) > 0)
         {
            return true;
         }
         if(param1.hasOwnProperty("talent_skill_damage") && Number(param1.talent_skill_damage) > 0)
         {
            return true;
         }
         if(param1.hasOwnProperty("damage") && Number(param1.damage) > 0)
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
            if((_loc4_ = param2[_loc3_]) != null && _loc4_.health_manager != null && !_loc4_.health_manager.isDead())
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function getSkillByPrioritySet(param1:int = 1) : *
      {
         var _loc6_:* = undefined;
         var _loc7_:Boolean = false;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:* = this.enemy_info != null ? this.enemy_info.priority : null;
         if(_loc2_ == null)
         {
            return this.getFallbackSkillIndex();
         }
         var _loc3_:* = _loc2_[param1];
         if(!(_loc3_ is Array) || _loc3_.length == 0)
         {
            _loc7_ = false;
            for(_loc8_ in _loc2_)
            {
               if(_loc2_[_loc8_] is Array && _loc2_[_loc8_].length > 0)
               {
                  _loc7_ = true;
                  break;
               }
            }
            return !!_loc7_ ? this.getSkillByPrioritySet(param1 + 1) : this.getFallbackSkillIndex();
         }
         var _loc4_:Array = _loc3_.concat();
         while(_loc4_.length > 0)
         {
            _loc9_ = NumberUtil.randomInt(0,_loc4_.length - 1);
            if((_loc10_ = _loc4_[_loc9_] - 1) < 0 || _loc10_ >= this.enemy_info.attacks.length)
            {
               _loc4_.splice(_loc9_,1);
            }
            else
            {
               if(this.enemy_info.curr_skill_cooldowns[_loc10_] <= 0)
               {
                  return _loc10_;
               }
               _loc4_.splice(_loc9_,1);
            }
         }
         var _loc5_:int = 0;
         for(_loc6_ in this.enemy_info.priority)
         {
            _loc5_++;
         }
         if(param1 >= _loc5_)
         {
            return this.getFallbackSkillIndex();
         }
         return this.getSkillByPrioritySet(param1 + 1);
      }
      
      private function getFallbackSkillIndex() : int
      {
         var _loc4_:Object = null;
         if(this.enemy_info == null || this.enemy_info.attacks == null || this.enemy_info.attacks.length == 0)
         {
            return 0;
         }
         var _loc1_:int = 0;
         var _loc2_:Number = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.enemy_info.attacks.length)
         {
            _loc4_ = this.enemy_info.attacks[_loc3_];
            if(!(_loc3_ < this.enemy_info.curr_skill_cooldowns.length && this.enemy_info.curr_skill_cooldowns[_loc3_] > 0))
            {
               if(_loc4_ != null)
               {
                  if(_loc4_.dmg > _loc2_)
                  {
                     _loc2_ = _loc4_.dmg;
                     _loc1_ = _loc3_;
                  }
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getLevel() : int
      {
         return this.enemy_info.enemy_level;
      }
      
      public function handleChaos() : *
      {
         BattleManager.startRun();
      }
      
      public function getAccuracy() : int
      {
         var _loc1_:int = int(this.enemy_info.enemy_accuracy);
         var _loc2_:Array = this.effects_manager.getActiveBuff("accuracy");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("accuracy");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"accuracy");
         return int(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"accuracy"));
      }
      
      public function getDodgeRate() : int
      {
         var _loc1_:int = int(this.enemy_info.enemy_dodge);
         var _loc2_:Array = this.effects_manager.getActiveBuff("dodge");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("dodge");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"dodge");
         _loc1_ = BattleManager.modifyChance(_loc3_,"RM",_loc1_,"dodge");
         if(this.player_identification == "ene_98")
         {
            if(this.mode == "wind" && this.stage_mode == "wind")
            {
               _loc1_ += 40;
            }
         }
         return _loc1_;
      }
      
      public function getCombustionChance() : int
      {
         var _loc1_:Number = Number(this.enemy_info.enemy_combustion);
         var _loc2_:Array = this.effects_manager.getActiveBuff("combustion");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("combustion");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_);
         _loc1_ = BattleManager.modifyChance(_loc3_,"RM",_loc1_);
         if(this.player_identification == "ene_98")
         {
            if(this.mode == "fire" && this.stage_mode == "fire")
            {
               _loc1_ += 50;
            }
         }
         return _loc1_;
      }
      
      public function getCriticalChance() : int
      {
         var _loc1_:Number = Number(this.enemy_info.enemy_critical);
         var _loc2_:Array = this.effects_manager.getActiveBuff("critical");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("critical");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"critical");
         _loc1_ = BattleManager.modifyChance(_loc3_,"RM",_loc1_,"critical");
         if(this.player_identification == "ene_98")
         {
            if(this.mode == "thunder" && this.stage_mode == "thunder")
            {
               _loc1_ += 40;
            }
         }
         return _loc1_;
      }
      
      public function getPurify() : int
      {
         var _loc1_:Number = Number(this.enemy_info.enemy_purify);
         var _loc2_:Array = this.effects_manager.getActiveBuff("purify");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("purify");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"purify");
         return Number(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"purify"));
      }
      
      public function getReactiveForce() : int
      {
         var _loc1_:Number = Number(this.enemy_info.enemy_reactive);
         var _loc2_:Array = this.effects_manager.getActiveBuff("reactive");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("reactive");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"reactive_force");
         return Number(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"reactive_force"));
      }
      
      public function getHead() : MovieClip
      {
         return this.object_head;
      }
      
      public function getAttackResults() : Array
      {
         return this.attack_results;
      }
      
      public function getAttackResult() : Object
      {
         return this.attack_result;
      }
      
      public function reloadInfo() : *
      {
      }
      
      public function playDodge() : *
      {
         this.object_mc.gotoAndPlay("dodge");
      }
      
      public function playHit() : *
      {
         this.object_mc.gotoAndPlay("hit");
      }
      
      public function playWin() : *
      {
      }
      
      public function playRun() : *
      {
      }
      
      public function playDead() : *
      {
         this.object_mc.gotoAndPlay("dead");
      }
      
      public function getPlayerTeam() : String
      {
         return this.player_team;
      }
      
      public function getPlayerNumber() : int
      {
         return this.player_number;
      }
      
      public function getAgility() : Number
      {
         var _loc1_:int = int(this.enemy_info.enemy_agility);
         var _loc2_:Array = this.effects_manager.getActiveBuff("agility");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("agility");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_);
         _loc1_ = BattleManager.modifyChance(_loc3_,"RM",_loc1_);
         return int(Math.max(_loc1_,Math.round(this.enemy_info.enemy_agility * 25 / 100)));
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
      
      public function isCharacter() : Boolean
      {
         return false;
      }
      
      public function isDead() : Boolean
      {
         return this.health_manager.isDead();
      }
      
      public function isPet() : Boolean
      {
         return false;
      }
      
      public function isEnemy() : Boolean
      {
         return true;
      }
      
      public function isNpc() : Boolean
      {
         return false;
      }
      
      public function reduceHealth(param1:int) : *
      {
         this.health_manager.reduceHealth(param1);
      }
      
      public function playAnimation(param1:String) : *
      {
         this.object_mc.gotoAndPlay(param1);
      }
      
      public function standByFrameEnd() : *
      {
         this.object_mc.x = 0;
         this.object_mc.y = 0;
         this.object_mc.gotoAndPlay("standby");
      }
      
      public function attackHit() : *
      {
         BattleManager.getBattle().hitPlayer();
      }
      
      public function attackFinish() : *
      {
         this.standByFrameEnd();
         BattleManager.getBattle().enemyAttacked();
      }
      
      public function dodgeFrame() : *
      {
         this.standByFrameEnd();
      }
      
      public function attackedFrame() : *
      {
         this.standByFrameEnd();
      }
      
      public function deadFrame() : *
      {
         this.object_mc.stop();
         BattleManager.getBattle().enemyDead();
      }
      
      public function addFullScreen() : *
      {
         var scales:int = 0;
         try
         {
            scales = "scale" in this.enemy_info.attacks[this.currentAttackIndex].anims.fullscreen ? int(this.enemy_info.attacks[this.currentAttackIndex].anims.fullscreen.scale) : 2;
            this.object_mc.fullScreenEffect.x = 0;
            this.object_mc.fullScreenEffect.y = 0;
            this.object_mc.fullScreenEffect.scaleX = scales;
            this.object_mc.fullScreenEffect.scaleY = scales;
            BattleManager.getMain().loader.addChild(this.object_mc.fullScreenEffect);
         }
         catch(e:*)
         {
         }
      }
      
      public function removeFullScreen() : *
      {
         try
         {
            BattleManager.getMain().loader.removeChild(this.object_mc.fullScreenEffect);
         }
         catch(e:*)
         {
         }
      }
      
      public function setFrameScript() : void
      {
         var j:int = 0;
         var finishFrame:int = 0;
         var i:int = 0;
         while(i < this.enemy_info.attacks.length)
         {
            j = 0;
            while(j < this.enemy_info.attacks[i].anims.hit.length)
            {
               this.object_mc.addFrameScript(this.enemy_info.attacks[i].anims.hit[j],this.attackHit);
               j++;
            }
            if(this.enemy_info.attacks[i].anims.hasOwnProperty("fullscreen"))
            {
               this.object_mc.addFrameScript(this.enemy_info.attacks[i].anims.fullscreen.add,this.addFullScreen);
               this.object_mc.addFrameScript(this.enemy_info.attacks[i].anims.fullscreen.remove,this.removeFullScreen);
            }
            finishFrame = NinjaSage.getLabelFrames(this.object_mc,this.enemy_info.attacks[i].animation).end - 1;
            this.object_mc.addFrameScript(finishFrame,this.attackFinish);
            i++;
         }
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"standby").end - 1,this.standByFrameEnd);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dodge").end - 1,this.dodgeFrame);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"hit").end - 1,this.attackedFrame);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dead").end - 1,this.deadFrame);
         if(this.player_identification == "ene_98")
         {
            var stopAnimation:Function = function():*
            {
               object_mc.elementeffect.stop();
            };
            var updateElementAnim:Function = function():*
            {
               object_mc.elementeffect.gotoAndStop(mode);
            };
            this.object_mc.addFrameScript(0,updateElementAnim);
         }
         this.object_mc.gotoAndPlay("standby");
      }
      
      public function clearFrameScript() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.enemy_info.attacks.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.enemy_info.attacks[_loc1_].anims.hit.length)
            {
               this.object_mc.addFrameScript(this.enemy_info.attacks[_loc1_].anims.hit[_loc2_],null);
               _loc2_++;
            }
            if(this.enemy_info.attacks[_loc1_].anims.hasOwnProperty("fullscreen"))
            {
               this.object_mc.addFrameScript(this.enemy_info.attacks[_loc1_].anims.fullscreen.add,null);
               this.object_mc.addFrameScript(this.enemy_info.attacks[_loc1_].anims.fullscreen.remove,null);
            }
            _loc3_ = NinjaSage.getLabelFrames(this.object_mc,this.enemy_info.attacks[_loc1_].animation).end - 1;
            this.object_mc.addFrameScript(_loc3_,null);
            _loc1_++;
         }
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"standby").end - 1,null);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dodge").end - 1,null);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"hit").end - 1,null);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dead").end - 1,null);
         if(true)
         {
            this.object_mc.stopAllMovieClips();
         }
      }
      
      public function gotoAttackPos(param1:Object, param2:int, param3:Boolean) : *
      {
         if(param1.posType == BattleVars.Position_START)
         {
            this.object_mc.x = 0;
            this.object_mc.y = 0;
            return;
         }
         switch(param1.posType)
         {
            case BattleVars.Position_MELEE_1:
               this.object_mc.x = -470;
               break;
            case BattleVars.Position_MELEE_2:
               this.object_mc.x = -420;
               break;
            case BattleVars.Position_MELEE_3:
               this.object_mc.x = -370;
               break;
            case BattleVars.Position_RANGE_1:
               this.object_mc.x = -220;
               break;
            case BattleVars.Position_RANGE_2:
               this.object_mc.x = -120;
               break;
            case BattleVars.Position_RANGE_3:
               this.object_mc.x = 20;
         }
         if(this.player_number > 0 && !param3)
         {
            this.object_mc.x -= 130;
         }
         if(param2 > 0 && !param3)
         {
            this.object_mc.x -= 130;
         }
         if(this.player_number == 1 && param2 == 0)
         {
            this.object_mc.y += 80;
         }
         if(this.player_number == 2 && param2 == 0)
         {
            this.object_mc.y -= 80;
         }
         if(this.player_number == 0 && param2 == 1)
         {
            this.object_mc.y -= 80;
         }
         if(this.player_number == 0 && param2 == 2)
         {
            this.object_mc.y += 80;
         }
         if(this.player_number == 1 && param2 == 2)
         {
            this.object_mc.y += 160;
         }
         if(this.player_number == 2 && param2 == 1)
         {
            this.object_mc.y -= 160;
         }
         if(param3)
         {
            this.object_mc.y = 0;
         }
      }
      
      public function destroy() : *
      {
         if(this.enemy_ai)
         {
            this.enemy_ai.destroy();
         }
         this.enemy_ai = null;
         Log.debug(this,"destroy",this.enemy_info.enemy_id);
         var _loc1_:* = BattleManager.getBattle();
         var _loc2_:* = this.movieclip_holder + this.player_number;
         if(_loc1_ != null)
         {
            if(_loc1_ && _loc2_ in _loc1_)
            {
               if("character_model" in _loc1_[_loc2_].charMc)
               {
                  _loc1_[_loc2_].charMc.character_model = null;
               }
               if(this.object_mc != null && _loc1_[_loc2_].charMc.contains(this.object_mc))
               {
                  _loc1_[_loc2_].charMc.removeChild(this.object_mc);
               }
            }
            GF.removeAllChild(_loc1_[_loc2_].charMc);
            if("skillMc" in _loc1_[_loc2_])
            {
               GF.removeAllChild(_loc1_[_loc2_].skillMc);
            }
            _loc1_[_loc2_] = null;
         }
         this.clearFrameScript();
         if(this.object_mc)
         {
            this.object_mc.gotoAndStop(1);
         }
         GF.removeAllChild(this.object_head);
         GF.removeAllChild(this.object_mc);
         this.object_head = null;
         this.object_mc = null;
         GF.clearArray(this.attack_results);
         this.enemy_info = null;
         this.health_manager.destroy();
         this.health_manager = null;
         this.stage_element_list = null;
         this.attack_results = null;
         this.attack_result = null;
         this.player_team = null;
         this.player_number = 0;
         this.player_identification = null;
         this.movieclip_holder = null;
         this.effects_manager.destroy();
         this.effects_manager = null;
         _loc1_ = null;
         _loc2_ = null;
      }
   }
}
