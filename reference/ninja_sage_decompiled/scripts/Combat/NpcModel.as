package Combat
{
   import Managers.NinjaSage;
   import Storage.NpcInfo;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.setTimeout;
   import id.ninjasage.Log;
   
   public class NpcModel
   {
       
      
      public var player_team:String;
      
      public var player_number:int;
      
      public var player_identification:String;
      
      public var npc_info;
      
      public var object_mc:MovieClip;
      
      public var object_head:MovieClip;
      
      public var npc_movieclip_holder:String;
      
      public var theft_mode:Boolean = false;
      
      public var blood_tax_mode:Boolean = false;
      
      public var unyielding_mode:Boolean = false;
      
      public var debuff_resist:Boolean = false;
      
      public var attack_results:Array;
      
      public var attack_result:Object;
      
      public var IS_BLOCK_DAMAGE:Boolean = false;
      
      public var IS_DODGED:Boolean = false;
      
      public var IS_CHAOS:Boolean = false;
      
      public var knowledge_of_time:Object;
      
      public var health_manager:HealthManager;
      
      public var effects_manager:EffectsManager;
      
      private var enemy_ai:EnemyAI;
      
      public var background_active:Boolean = false;
      
      public function NpcModel(param1:String, param2:int, param3:String)
      {
         this.knowledge_of_time = {};
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
         this.player_team = param1;
         this.player_number = param2;
         this.player_identification = param3;
         this.npc_movieclip_holder = this.player_team == "player" ? "charMc_" : "enemyMc_";
         BattleManager.getBattle()[this.npc_movieclip_holder + this.player_number].charMc.scaleX = this.player_team == "player" ? -1 : 1;
         this.health_manager = new HealthManager(this.player_team,this.player_number);
         this.effects_manager = new EffectsManager(this.player_team,this.player_number);
         this.enemy_ai = new EnemyAI();
         BattleManager.getMain().loadNpcSWF(this.player_identification,this.onNpcLoaded);
      }
      
      public function onNpcLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         this.npc_info = NpcInfo.getCopy(this.player_identification);
         this.npc_info.curr_skill_cooldowns = [0,0,0,0,0,0,0];
         this.object_mc = param1.target.content[this.player_identification];
         this.object_mc.gotoAndStop(1);
         if(true)
         {
            this.object_mc.stopAllMovieClips();
         }
         this.object_head = param1.target.content["npc_head"];
         this.setFrameScript();
         this.object_mc.scaleX = this.npc_info.size_x * BattleVars.NPC_SCALE;
         this.object_mc.scaleY = this.npc_info.size_y * BattleVars.NPC_SCALE;
         this.health_manager.fillHealth(this.npc_info);
         GF.removeAllChild(BattleManager.getBattle()[this.npc_movieclip_holder + this.player_number].charMc);
         BattleManager.getBattle()[this.npc_movieclip_holder + this.player_number].charMc.addChild(this.object_mc);
         BattleManager.getBattle()[this.npc_movieclip_holder + this.player_number].charMc.character_model = this;
         var _loc3_:int = this.player_number + 1;
         setTimeout(BattleManager.loadPlayerTeam,100,_loc3_);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
      }
      
      public function getAgility() : Number
      {
         return Number(Number(this.npc_info.npc_agility));
      }
      
      public function getHead() : MovieClip
      {
         return this.object_head;
      }
      
      public function findSkillByOrder() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = -1;
         var _loc3_:Array = this.npc_info.attacks;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc1_ = int(_loc3_[_loc4_].order);
            if(this.npc_info.curr_skill_cooldowns[_loc1_] < 1)
            {
               _loc2_ = _loc1_;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function viceRapidCooldown(param1:int, param2:String) : *
      {
         var _loc3_:* = 1;
         while(_loc3_ < this.npc_info.curr_skill_cooldowns.length)
         {
            this.npc_info.curr_skill_cooldowns[_loc3_] = int(this.npc_info.curr_skill_cooldowns[_loc3_]) + param1;
            _loc3_++;
         }
         Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),param2,false);
      }
      
      public function randomOblivion(param1:int, param2:String = "", param3:int = 0) : *
      {
         var _loc4_:* = NumberUtil.randomInt(0,this.npc_info.curr_skill_cooldowns.length - 1);
         if(this.npc_info.curr_skill_cooldowns[_loc4_] == 0)
         {
            this.npc_info.curr_skill_cooldowns[_loc4_] = param1;
            Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),param2,false);
         }
         else if(param3 < this.npc_info.curr_skill_cooldowns.length)
         {
            param3++;
            this.randomOblivion(param1,param2,param3);
         }
         else
         {
            this.npc_info.curr_skill_cooldowns[_loc4_] = param1;
            Effects.showEffectInfo(this.getPlayerTeam(),this.getPlayerNumber(),param2,false);
         }
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
      
      public function getAttack(param1:Boolean = true) : *
      {
         var _loc9_:Object = null;
         var _loc2_:* = 0;
         while(_loc2_ < this.npc_info.curr_skill_cooldowns.length)
         {
            if(this.npc_info.curr_skill_cooldowns[_loc2_] > 0 && param1)
            {
               --this.npc_info.curr_skill_cooldowns[_loc2_];
            }
            _loc2_++;
         }
         var _loc3_:* = BattleManager.getBattle();
         var _loc4_:String = this.player_team;
         var _loc5_:String = this.player_team == "player" ? "enemy" : "player";
         var _loc6_:Array = this.player_team == "player" ? _loc3_.enemy_team_players : _loc3_.character_team_players;
         var _loc7_:Array = this.player_team == "player" ? _loc3_.character_team_players : _loc3_.enemy_team_players;
         var _loc8_:Boolean;
         if(_loc8_ = !this.npc_info.hasOwnProperty("npc_ai") || Boolean(this.npc_info.npc_ai))
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
         var _loc10_:*;
         if((_loc10_ = int(_loc9_.index)) < 0 || _loc10_ >= this.npc_info.attacks.length)
         {
            _loc10_ = 0;
         }
         var _loc11_:Object = this.npc_info.attacks[_loc10_];
         var _loc12_:Boolean = this.isOpponentTargetSkill(_loc11_);
         var _loc14_:Array = !!(_loc13_ = Boolean(_loc9_.is_friendly_target && !_loc12_)) ? _loc7_ : _loc6_;
         var _loc15_:int = this.normalizeLiveTargetIndex(int(_loc9_.target),_loc14_);
         this.npc_info.curr_skill_cooldowns[_loc10_] = this.npc_info.attacks[_loc10_].cooldown;
         if(_loc13_)
         {
            _loc3_.setDefender(_loc4_,_loc15_);
         }
         else
         {
            if(this.player_team == "player")
            {
               BattleVars.PLAYER_TARGET = _loc15_;
            }
            else
            {
               BattleVars.ENEMY_TARGET = _loc15_;
            }
            _loc3_.setDefender(_loc5_,_loc15_);
         }
         var _loc16_:* = _loc3_.getDefender();
         var _loc17_:* = Math.round(20 + _loc16_.getLevel() / 2 * (1 + 0.06 * _loc16_.getLevel()));
         var _loc18_:* = Math.floor(_loc11_.dmg * _loc17_);
         if("is_static" in _loc11_ && Boolean(_loc11_.is_static))
         {
            _loc18_ = Math.floor(_loc11_.dmg);
         }
         var _loc19_:* = _loc11_.multi_hit;
         var _loc20_:* = _loc11_.effects;
         _loc20_ = BattleManager.getBattle().checkForDisperse(_loc20_);
         var _loc21_:Boolean = _loc11_.dmg == 0 ? true : false;
         var _loc22_:Boolean;
         if((_loc22_ = this.targetIsSleeping()) && !_loc21_)
         {
            this.npc_info.curr_skill_cooldowns[_loc10_] = 0;
            BattleManager.startRun();
            return [0,[],false,false];
         }
         this.gotoAttackPos(_loc11_,_loc15_,_loc19_);
         this.attack_results = [_loc18_,_loc20_,_loc19_,_loc21_];
         this.attack_result = {
            "damage":_loc18_,
            "effects":_loc20_,
            "multi_hit":_loc19_,
            "self_target":_loc21_
         };
         this.object_mc.gotoAndPlay(_loc11_.animation);
         return _loc11_;
      }
      
      private function getRandomAttackDecision(param1:Array) : Object
      {
         var _loc2_:Array = [];
         var _loc3_:int = Math.min(this.npc_info.attacks.length,this.npc_info.curr_skill_cooldowns.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.npc_info.curr_skill_cooldowns[_loc4_] <= 0)
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
            if((_loc4_ = param2[_loc3_]) != null && _loc4_.health_manager != null && !_loc4_.health_manager.isDead())
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function handleChaos() : *
      {
         BattleManager.startRun();
      }
      
      public function getAccuracy() : int
      {
         var _loc1_:int = int(this.npc_info.npc_accuracy);
         var _loc2_:Array = this.effects_manager.getActiveBuff("accuracy");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("accuracy");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"accuracy");
         return int(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"accuracy"));
      }
      
      public function getDodgeRate() : int
      {
         var _loc1_:int = int(this.npc_info.npc_dodge);
         var _loc2_:Array = this.effects_manager.getActiveBuff("dodge");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("dodge");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"dodge");
         return int(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"dodge"));
      }
      
      public function getCombustionChance() : int
      {
         var _loc1_:Number = Number(this.npc_info.npc_combustion);
         var _loc2_:Array = this.effects_manager.getActiveBuff("combustion");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("combustion");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_);
         return Number(BattleManager.modifyChance(_loc3_,"RM",_loc1_));
      }
      
      public function getCriticalChance() : int
      {
         var _loc1_:Number = Number(this.npc_info.npc_critical);
         var _loc2_:Array = this.effects_manager.getActiveBuff("critical");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("critical");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"critical");
         return Number(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"critical"));
      }
      
      public function getPurify() : int
      {
         var _loc1_:Number = Number(this.npc_info.npc_purify);
         var _loc2_:Array = this.effects_manager.getActiveBuff("purify");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("purify");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"purify");
         return Number(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"purify"));
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
      
      public function getLevel() : int
      {
         return this.npc_info.npc_level;
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
         return false;
      }
      
      public function isNpc() : Boolean
      {
         return true;
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
      
      public function playWin() : *
      {
      }
      
      public function playRun() : *
      {
      }
      
      public function playAnimation(param1:String) : *
      {
         this.object_mc.gotoAndPlay(param1);
      }
      
      public function getPlayerTeam() : String
      {
         return this.player_team;
      }
      
      public function getPlayerNumber() : int
      {
         return this.player_number;
      }
      
      public function standByFrameEnd() : *
      {
         this.object_mc.x = 0;
         this.object_mc.y = 0;
         this.object_mc.gotoAndPlay("standby");
      }
      
      public function attackHit() : *
      {
         BattleManager.getBattle().hitEnemyNpc();
      }
      
      public function attackFinish() : *
      {
         this.standByFrameEnd();
         BattleManager.getBattle().npcAttacked();
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
         this.object_mc.gotoAndStop(this.object_mc.totalFrames - 1);
         BattleManager.getBattle().enemyDead();
      }
      
      public function setFrameScript() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.npc_info.attacks.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.npc_info.attacks[_loc1_].anims.hit.length)
            {
               this.object_mc.addFrameScript(this.npc_info.attacks[_loc1_].anims.hit[_loc2_],this.attackHit);
               _loc2_++;
            }
            _loc3_ = NinjaSage.getLabelFrames(this.object_mc,this.npc_info.attacks[_loc1_].animation).end - 1;
            this.object_mc.addFrameScript(_loc3_,this.attackFinish);
            _loc1_++;
         }
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"standby").end - 1,this.standByFrameEnd);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dodge").end - 1,this.dodgeFrame);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"hit").end - 1,this.attackedFrame);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dead").end - 1,this.deadFrame);
         this.object_mc.gotoAndPlay("standby");
      }
      
      public function clearFrameScript() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.npc_info.attacks.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.npc_info.attacks[_loc1_].anims.hit.length)
            {
               this.object_mc.addFrameScript(this.npc_info.attacks[_loc1_].anims.hit[_loc2_],null);
               _loc2_++;
            }
            _loc3_ = NinjaSage.getLabelFrames(this.object_mc,this.npc_info.attacks[_loc1_].animation).end - 1;
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
         var _loc1_:* = this.npc_movieclip_holder + this.player_number;
         Log.debug(this,"destroy",this.npc_info.npc_id,_loc1_);
         if(this.enemy_ai)
         {
            this.enemy_ai.destroy();
         }
         this.enemy_ai = null;
         var _loc2_:* = BattleManager.getBattle();
         if(this.object_mc != null && _loc2_ != null)
         {
            if(_loc2_ && _loc1_ in _loc2_ && _loc2_[_loc1_].charMc.contains(this.object_mc))
            {
               _loc2_[_loc1_].charMc.removeChild(this.object_mc);
            }
            _loc2_[_loc1_].charMc.character_model = null;
            GF.removeAllChild(_loc2_[_loc1_].charMc);
            if("skillMc" in _loc2_[_loc1_])
            {
               GF.removeAllChild(_loc2_[_loc1_].skillMc);
            }
            _loc2_[_loc1_] = null;
            this.clearFrameScript();
            if(this.object_mc)
            {
               this.object_mc.gotoAndStop(1);
            }
            GF.removeAllChild(this.object_head);
            GF.removeAllChild(this.object_mc);
            this.object_head = null;
            this.object_mc = null;
         }
         GF.clearArray(this.attack_results);
         this.npc_info = null;
         this.attack_results = null;
         this.attack_result = null;
         this.player_team = null;
         this.player_number = 0;
         this.player_identification = null;
         this.npc_movieclip_holder = null;
         this.health_manager.destroy();
         this.health_manager = null;
         this.effects_manager.destroy();
         this.effects_manager = null;
         _loc2_ = null;
         _loc1_ = null;
      }
   }
}
