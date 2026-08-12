package Combat
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import gs.easing.Linear;
   import id.ninjasage.Log;
   
   public class AgilityBarManager
   {
       
      
      public var action_bar;
      
      public var players_mc_holders:Object;
      
      public var team_headMc_agility:Vector.<AgilityBarEntry>;
      
      public var plus_x_next_round:Vector.<Number>;
      
      public var calc_type:String = "Number";
      
      public var ambush_team:String = "";
      
      public var ambush_num:int = -1;
      
      public var action_bar_width:int = 600;
      
      public var action_bar_divider:int = 20;
      
      public var to_repeat_number:int = 0;
      
      public var last_ambush_index:int = -1;
      
      public var turns:int = 0;
      
      public var player_turns:int = 7;
      
      public var is_running:Boolean = false;
      
      public var enable_actions:Boolean = false;
      
      private var destroyed = false;
      
      private var startRunTimeout:uint = 0;
      
      private var startRunToken:uint = 0;
      
      public function AgilityBarManager()
      {
         this.team_headMc_agility = new Vector.<AgilityBarEntry>();
         this.plus_x_next_round = new Vector.<Number>();
         super();
         var _loc1_:* = BattleManager.getBattle();
         this.action_bar = _loc1_["atbBar"];
         this.players_mc_holders = {
            "enemy_0":_loc1_["enemyMc_0"],
            "player_0":_loc1_["charMc_0"],
            "player_1":_loc1_["charMc_1"],
            "enemy_1":_loc1_["enemyMc_1"],
            "player_2":_loc1_["charMc_2"],
            "enemy_2":_loc1_["enemyMc_2"],
            "player_pet_0":_loc1_["charPetMc_0"],
            "enemy_pet_0":_loc1_["enemyPetMc_0"],
            "player_pet_1":_loc1_["charPetMc_1"],
            "enemy_pet_1":_loc1_["enemyPetMc_1"],
            "player_pet_2":_loc1_["charPetMc_2"],
            "enemy_pet_2":_loc1_["enemyPetMc_2"]
         };
         this.setupHeadsAndAgility();
         this.action_bar.visible = true;
         this.startRun(500);
      }
      
      public function setupHeadsAndAgility() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:MovieClip = null;
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = -30;
         var _loc8_:AgilityBarTeamInfo = null;
         for(_loc3_ in this.players_mc_holders)
         {
            if("character_model" in this.players_mc_holders[_loc3_].charMc)
            {
               _loc1_ = this.players_mc_holders[_loc3_].charMc.character_model;
               _loc2_ = _loc1_.getHead();
               _loc7_ = -30;
               if(_loc3_.indexOf("player") == -1)
               {
                  _loc7_ = 7;
               }
               _loc2_.x = 0;
               _loc2_.y = _loc7_;
               _loc2_.scaleX = !!_loc1_.isCharacter() ? Number(0.5) : Number(-0.5);
               _loc2_.scaleY = !!_loc1_.isCharacter() ? Number(0.5) : Number(0.5);
               if((_loc5_ = this.getCalculatedAgility(_loc1_)) > _loc6_)
               {
                  _loc6_ = _loc5_;
               }
               _loc8_ = this.parseTeamInfo(_loc3_);
               this.team_headMc_agility.push(new AgilityBarEntry(_loc3_,_loc2_,_loc1_,_loc5_,_loc2_.x,_loc8_.teamName,_loc8_.teamNum,_loc8_.isPet));
            }
         }
         this.to_repeat_number = Math.floor(_loc6_ / this.action_bar_divider);
         _loc4_ = 0;
         while(_loc4_ < this.team_headMc_agility.length)
         {
            _loc2_ = this.team_headMc_agility[_loc4_].head;
            this.action_bar.holder.addChild(_loc2_);
            this.plus_x_next_round[_loc4_] = 0;
            _loc4_++;
         }
         this.plus_x_next_round.length = this.team_headMc_agility.length;
      }
      
      private function getCalculatedAgility(param1:*) : int
      {
         var _loc2_:int = int(param1.getAgility());
         return _loc2_ > 0 ? int(Math.max(_loc2_,(param1.getLevel() + 9) / 2)) : 0;
      }
      
      private function parseTeamInfo(param1:String) : AgilityBarTeamInfo
      {
         var _loc2_:Array = param1.split("_");
         var _loc3_:* = _loc2_[0];
         var _loc4_:int = int(_loc2_[1]);
         var _loc5_:Boolean = false;
         if(_loc2_.length == 3)
         {
            _loc3_ = _loc2_[0] + "_pet";
            _loc4_ = int(_loc2_[2]);
            _loc5_ = true;
         }
         return new AgilityBarTeamInfo(_loc3_,_loc4_,_loc5_);
      }
      
      public function startRun(param1:int = 0) : *
      {
         var _loc2_:* = BattleManager.getBattle();
         if(this.destroyed || _loc2_ == null)
         {
            return;
         }
         if("isDebugEnemyManualWaiting" in _loc2_ && _loc2_.isDebugEnemyManualWaiting())
         {
            return;
         }
         if(param1 > 0)
         {
            this.scheduleStartRun(param1);
            return;
         }
         if(_loc2_.agility_bar_manager != this)
         {
            return;
         }
         if(this.is_running)
         {
            return;
         }
         if(!this.prepareStartRun(_loc2_))
         {
            return;
         }
         if(this.handleBattleInterrupts())
         {
            return;
         }
         this.resolveBattleOrStartAgility(_loc2_,this.checkForBattleStatus());
      }
      
      private function scheduleStartRun(param1:int) : void
      {
         if(this.startRunTimeout != 0)
         {
            clearTimeout(this.startRunTimeout);
         }
         var _loc2_:uint = ++this.startRunToken;
         this.startRunTimeout = setTimeout(this.startRunIfCurrent,param1,_loc2_);
      }
      
      private function startRunIfCurrent(param1:uint) : void
      {
         this.startRunTimeout = 0;
         if(param1 != this.startRunToken)
         {
            return;
         }
         this.startRun(0);
      }
      
      private function prepareStartRun(param1:*) : Boolean
      {
         if(this.enable_actions)
         {
            this.enable_actions = false;
            param1.character_team_players[0].actions_manager.greyOutActions(false);
         }
         if(!this.handleFirstTurnInit(param1))
         {
            return false;
         }
         param1["btn_UI_Gear"].visible = false;
         param1["char_hpcp"]["btn_activate_senjutsu"].visible = false;
         if(!BattleVars.MATCH_RUNNING)
         {
            return false;
         }
         param1.hideDragonHuntHint();
         param1.checkPlayDeadAnimation();
         return true;
      }
      
      private function handleFirstTurnInit(param1:*) : Boolean
      {
         var _loc2_:* = undefined;
         if(this.turns != 0)
         {
            return true;
         }
         if(!this.checkAllActionsManagerLoaded())
         {
            this.scheduleStartRun(200);
            return false;
         }
         (_loc2_ = new Animation(param1,false)).gotoAndPlay(1);
         BattleManager.getMain().loader.addChild(_loc2_);
         BattleManager.getMain().loading(false);
         return true;
      }
      
      private function handleBattleInterrupts() : Boolean
      {
         var _loc1_:Boolean = this.checkActivateUnyielding();
         var _loc2_:Boolean = !_loc1_ ? Boolean(this.checkReviveEOM()) : false;
         return _loc1_ || _loc2_;
      }
      
      private function resolveBattleOrStartAgility(param1:*, param2:String) : void
      {
         if(param2 == "")
         {
            ++this.turns;
            this.is_running = true;
            this.updateAgilityToActionBar();
            this.checkAmbush();
         }
         else if(param2 == "LOST")
         {
            param1.endBattle(false);
         }
         else if(param2 == "WON")
         {
            this.playWinAnimationToSelfAndTeammates();
            param1.endBattle(true);
         }
      }
      
      public function checkAllActionsManagerLoaded() : Boolean
      {
         var _loc1_:* = BattleManager.getBattle();
         return this.isTeamActionsManagerLoaded(_loc1_.character_team_players) && this.isTeamActionsManagerLoaded(_loc1_.enemy_team_players);
      }
      
      private function isTeamActionsManagerLoaded(param1:*) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1[_loc3_];
            if(Boolean(_loc2_.isCharacter()) && !_loc2_.character_manager.isActionsManagerLoaded())
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function playWinAnimationToSelfAndTeammates() : *
      {
         var _loc1_:* = BattleManager.getBattle();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.character_team_players.length)
         {
            if(!_loc1_.character_team_players[_loc2_].health_manager.isDead())
            {
               _loc1_.character_team_players[_loc2_].playWin();
            }
            _loc2_++;
         }
      }
      
      public function checkForBattleStatus() : String
      {
         var _loc1_:Battle = BattleManager.getBattle();
         var _loc2_:Array = this.getAliveEnemyIndicesAndResetTarget(_loc1_);
         if(this.isPlayerTeamDefeated(_loc1_))
         {
            return "LOST";
         }
         if(this.isEnemyTeamDefeated(_loc1_))
         {
            return "WON";
         }
         this.ensureValidPlayerTarget(_loc1_,_loc2_);
         return "";
      }
      
      private function isPlayerTeamDefeated(param1:Battle) : Boolean
      {
         var _loc2_:Boolean = this.isSpecialJouninStage();
         var _loc3_:int = 0;
         while(_loc3_ < param1.character_team_players.length)
         {
            if(param1.character_team_players[_loc3_].health_manager.isDead() && (_loc2_ || _loc3_ == 0))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function isEnemyTeamDefeated(param1:Battle) : Boolean
      {
         if(this.getDeadEnemyCount(param1) == param1.enemy_team_players.length)
         {
            return true;
         }
         return this.isSpecialJouninStage() && param1.enemy_team_players[0].health_manager.isDead();
      }
      
      private function getAliveEnemyIndicesAndResetTarget(param1:Battle) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.enemy_team_players.length)
         {
            if(param1.enemy_team_players[_loc3_].health_manager.isDead())
            {
               if(BattleVars.PLAYER_TARGET == _loc3_)
               {
                  param1.resetTargetArrows();
                  BattleVars.PLAYER_TARGET = -1;
               }
            }
            else
            {
               _loc2_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function ensureValidPlayerTarget(param1:Battle, param2:Array) : void
      {
         if(param2.length == 0)
         {
            BattleVars.PLAYER_TARGET = 0;
            return;
         }
         if(BattleVars.PLAYER_TARGET != -1)
         {
            return;
         }
         BattleVars.PLAYER_TARGET = param2[0];
         BattleVars.MASTER_PLAYER_TARGET = BattleVars.PLAYER_TARGET;
         param1.showTargetArrow();
      }
      
      private function getDeadEnemyCount(param1:Battle) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.enemy_team_players.length)
         {
            if(param1.enemy_team_players[_loc3_].health_manager.isDead())
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function isSpecialJouninStage() : Boolean
      {
         return Character.is_jounin_stage_4 || Character.is_jounin_stage_5_1 || Character.is_jounin_stage_5_2;
      }
      
      public function checkReviveEOM() : Boolean
      {
         var _loc1_:* = BattleManager.getBattle();
         var _loc2_:* = _loc1_.character_team_players;
         var _loc3_:* = _loc1_.enemy_team_players;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(_loc2_[_loc5_].health_manager.checkReviveEOM())
            {
               _loc4_ = true;
               break;
            }
            _loc5_++;
         }
         if(!_loc4_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               if(_loc3_[_loc5_].health_manager.checkReviveEOM())
               {
                  _loc4_ = true;
                  break;
               }
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      public function checkActivateUnyielding() : Boolean
      {
         var _loc1_:* = BattleManager.getBattle();
         return this.hasTeamUnyieldingActivation(_loc1_.character_team_players) || this.hasTeamUnyieldingActivation(_loc1_.enemy_team_players);
      }
      
      private function hasTeamUnyieldingActivation(param1:*) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1[_loc3_];
            if(Boolean(_loc2_.isCharacter()) && _loc2_.health_manager.checkActivateUnyielding())
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function checkMemekKudaActivation() : Boolean
      {
         return this.checkLegacyICMActivation();
      }
      
      public function checkLegacyICMActivation() : Boolean
      {
         return this.checkICMActivation();
      }
      
      public function checkICMActivation() : Boolean
      {
         var _loc1_:* = BattleManager.getBattle();
         return this.hasTeamICMActivation(_loc1_.character_team_players) || this.hasTeamICMActivation(_loc1_.enemy_team_players);
      }
      
      private function hasTeamICMActivation(param1:*) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].health_manager.checkActivateICM())
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function stopRun() : *
      {
         this.is_running = false;
      }
      
      public function checkAmbush() : void
      {
         var _loc4_:int = 0;
         var _loc1_:Vector.<Number> = new Vector.<Number>(this.team_headMc_agility.length,true);
         var _loc2_:Vector.<Number> = new Vector.<Number>(this.team_headMc_agility.length,true);
         var _loc3_:Number = this.prepareAmbushState(_loc1_,_loc2_);
         if(_loc3_ == Number.MAX_VALUE)
         {
            return;
         }
         if((_loc4_ = this.applyAmbushMovement(_loc3_,_loc1_,_loc2_)) >= 0)
         {
            this.triggerAmbushAnimation(_loc4_);
         }
      }
      
      private function prepareAmbushState(param1:Vector.<Number>, param2:Vector.<Number>) : Number
      {
         var _loc3_:AgilityBarEntry = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = Number.MAX_VALUE;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         while(_loc7_ < this.team_headMc_agility.length)
         {
            _loc3_ = this.team_headMc_agility[_loc7_];
            this.resetAmbushStateForIndex(_loc7_,_loc3_);
            if(_loc3_.model.isDead())
            {
               this.clearAmbushTransientStateForIndex(_loc7_,_loc3_);
            }
            else
            {
               param2[_loc7_] = this.getAmbushSpeed(_loc3_.agility);
               _loc4_ = _loc3_.lastX;
               if(this.plus_x_next_round[_loc7_] > 0)
               {
                  _loc4_ += this.plus_x_next_round[_loc7_];
                  this.plus_x_next_round[_loc7_] = 0;
               }
               param1[_loc7_] = _loc4_;
               if((_loc6_ = this.getAmbushStepsNeeded(_loc4_,param2[_loc7_])) < _loc5_)
               {
                  _loc5_ = _loc6_;
               }
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function resetAmbushStateForIndex(param1:int, param2:AgilityBarEntry) : void
      {
         if(this.last_ambush_index == param1)
         {
            this.last_ambush_index = -1;
            param2.head.x = 0;
            param2.lastX = this.plus_x_next_round[param1];
            this.plus_x_next_round[param1] = 0;
         }
      }
      
      private function clearAmbushTransientStateForIndex(param1:int, param2:AgilityBarEntry) : void
      {
         param2.head.x = 0;
         param2.lastX = 0;
         this.plus_x_next_round[param1] = 0;
      }
      
      private function getAmbushSpeed(param1:Number) : Number
      {
         var _loc2_:Number = param1;
         if(this.to_repeat_number > 2)
         {
            _loc2_ = Number(Number(param1 / this.to_repeat_number).toFixed(1));
            if(this.calc_type == "Integer")
            {
               _loc2_ = Math.floor(param1 / this.to_repeat_number);
            }
         }
         if(param1 > 0)
         {
            _loc2_ = Math.max(_loc2_,0.1);
         }
         return _loc2_;
      }
      
      private function getAmbushStepsNeeded(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = this.action_bar_width - param1;
         return _loc3_ <= 0 ? Number(1) : Number(Math.ceil(_loc3_ / param2));
      }
      
      private function applyAmbushMovement(param1:Number, param2:Vector.<Number>, param3:Vector.<Number>) : int
      {
         var _loc4_:AgilityBarEntry = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = -1;
         var _loc7_:int = -1;
         var _loc8_:int = 0;
         while(_loc8_ < this.team_headMc_agility.length)
         {
            if((_loc4_ = this.team_headMc_agility[_loc8_]).model.isDead())
            {
               this.clearAmbushTransientStateForIndex(_loc8_,_loc4_);
            }
            else if((_loc5_ = param2[_loc8_] + param1 * param3[_loc8_]) >= this.action_bar_width)
            {
               if(_loc5_ > _loc6_)
               {
                  _loc6_ = _loc5_;
                  _loc7_ = _loc8_;
               }
               this.plus_x_next_round[_loc8_] = _loc5_ - this.action_bar_width;
               _loc4_.lastX = this.action_bar_width;
            }
            else
            {
               _loc4_.lastX = _loc5_;
            }
            _loc8_++;
         }
         return _loc7_;
      }
      
      private function triggerAmbushAnimation(param1:int) : void
      {
         var _loc2_:AgilityBarEntry = null;
         var _loc3_:AgilityBarEntry = this.team_headMc_agility[param1];
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         this.stopRun();
         this.last_ambush_index = param1;
         this.ambush_team = _loc3_.teamName;
         this.ambush_num = _loc3_.teamNum;
         while(_loc5_ < this.team_headMc_agility.length)
         {
            _loc2_ = this.team_headMc_agility[_loc5_];
            _loc4_ = {
               "x":_loc2_.lastX,
               "ease":Linear.easeNone
            };
            if(_loc5_ == param1)
            {
               _loc4_.onComplete = this.onAmbush;
               _loc4_.onCompleteParams = [_loc2_.head];
            }
            TweenLite.to(_loc2_.head,0.8,_loc4_);
            _loc5_++;
         }
      }
      
      public function onAmbush(param1:*) : *
      {
         TweenLite.killTweensOf(param1);
         if(this.isDebugManualEnemyAmbush())
         {
            BattleManager.getBattle().setupViewForAmbush(this.ambush_team,this.ambush_num,true);
            return;
         }
         BattleManager.getBattle().setupViewForAmbush(this.ambush_team,this.ambush_num);
         if(this.ambush_team == "player" && this.ambush_num == 0)
         {
            --this.player_turns;
         }
      }
      
      private function isDebugManualEnemyAmbush() : Boolean
      {
         return false;
      }
      
      public function updateAgilityToActionBar() : *
      {
         var _loc6_:AgilityBarEntry = null;
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = this.team_headMc_agility.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_ = (_loc6_ = this.team_headMc_agility[_loc5_]).model;
            _loc2_ = this.getCalculatedAgility(_loc1_);
            if(_loc2_ > _loc3_)
            {
               _loc3_ = _loc2_;
            }
            _loc6_.agility = _loc2_;
            _loc5_++;
         }
         this.to_repeat_number = Math.floor(_loc3_ / this.action_bar_divider);
      }
      
      public function destroy() : *
      {
         var _loc1_:int = 0;
         var _loc2_:AgilityBarEntry = null;
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         ++this.startRunToken;
         if(this.startRunTimeout != 0)
         {
            clearTimeout(this.startRunTimeout);
            this.startRunTimeout = 0;
         }
         Log.debug(this,"destroy");
         this.stopRun();
         if(this.action_bar != null && this.action_bar.holder != null)
         {
            GF.removeAllChild(this.action_bar.holder);
         }
         this.action_bar = null;
         this.players_mc_holders = null;
         if(this.team_headMc_agility != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.team_headMc_agility.length)
            {
               _loc2_ = this.team_headMc_agility[_loc1_];
               TweenLite.killTweensOf(_loc2_.head);
               GF.removeAllChild(_loc2_.head);
               _loc2_.head = null;
               _loc2_.model = null;
               _loc1_++;
            }
            this.team_headMc_agility.length = 0;
            this.team_headMc_agility = null;
         }
         this.plus_x_next_round = null;
         this.ambush_team = "";
         this.ambush_num = -1;
      }
   }
}

class AgilityBarTeamInfo
{
    
   
   public var teamName:String;
   
   public var teamNum:int;
   
   public var isPet:Boolean;
   
   function AgilityBarTeamInfo(param1:String, param2:int, param3:Boolean)
   {
      super();
      this.teamName = param1;
      this.teamNum = param2;
      this.isPet = param3;
   }
}
