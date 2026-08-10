package id.ninjasage.pvp.battle
{
   import Popups.Confirmation;
   import com.brokenfunction.json.encodeJson;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.Battle;
   import id.ninjasage.multiplayer.battle.BattleAnimationEvent;
   import id.ninjasage.multiplayer.battle.BattleTimer;
   import id.ninjasage.multiplayer.battle.CharacterManager;
   import id.ninjasage.multiplayer.battle.CharacterModel;
   import id.ninjasage.multiplayer.battle.PetManager;
   import id.ninjasage.multiplayer.battle.PetModel;
   import id.ninjasage.pvp.BattleResult;
   import id.ninjasage.pvp.PvPLobby;
   import id.ninjasage.pvp.PvPSocket;
   
   public class PvPBattleHandler
   {
      
      private static const ELAPSED_TIMER_INTERVAL_MS:int = 1000;
      
      private static const ELAPSED_TIMER_TARGETS:Array = ["battleTimeMc"];
      
      private static const RANKED_BATTLE_DURATION_SECONDS_DEFAULT:int = 480;
      
      private static const BERSERK_TIMER_COLOR:uint = 16711680;
      
      private static const DEFAULT_TIMER_COLOR:uint = 16777215;
      
      private static const BERSERK_BACKGROUND_ID:String = "mission_1072";
      
      private var _battle:Battle;
      
      private var _eventHandler:EventHandler;
      
      private var _actions:Array = [];
      
      private var _chatMessages:Array = [];
      
      private var _maxChatMessages:int = 25;
      
      private var _battleTimer:BattleTimer;
      
      private var _lastAmbushCharId:*;
      
      private var _gearPanel:MovieClip;
      
      private var _battleResult:BattleResult;
      
      private var _confirmation:Confirmation;
      
      private var _optionPanel:MovieClip;
      
      private var _elapsedTimer:Timer;
      
      private var _elapsedBaseMs:Number = 0;
      
      private var _elapsedBaseTick:int = 0;
      
      private var _tieBreakerAnimating:Boolean = false;
      
      private var _queuedBattleEndData:Object = null;
      
      private var _tieBreakerTimer:Timer = null;
      
      private var _berserkActive:Boolean = false;
      
      private var _ownEffects:Array = [];
      
      private var _rankedDurationSeconds:int = 480;
      
      public function PvPBattleHandler()
      {
         super();
         this._battle = PvPBattleManager.getBattle();
         this._eventHandler = new EventHandler();
         this._battleTimer = new BattleTimer();
      }
      
      public function setup() : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:CharacterModel = null;
         var _loc5_:PetModel = null;
         this._berserkActive = false;
         this._battleTimer.setTimerCompleteCallback(this.handleTimerTimeout);
         this._battleTimer.setTimerTickCallback(this.handleTimerTick);
         var _loc1_:* = PvPSocket.getInstance();
         _loc1_.on("Battle.action.ambush",this.handleAmbushAction);
         _loc1_.on("Battle.action.dodge",this.handleDodgeAction);
         _loc1_.on("Battle.action.charge",this.handleChargeAction);
         _loc1_.on("Battle.action.weapon",this.handleWeaponAction);
         _loc1_.on("Battle.action.skill",this.handleSkillAction);
         _loc1_.on("Battle.action.run",this.handleRunAction);
         _loc1_.on("Battle.action.scroll",this.handleScrollAction);
         _loc1_.on("Battle.action.pet",this.handlePetAction);
         _loc1_.on("Battle.updateInfo",this.handleUpdateInfo);
         _loc1_.on("Battle.elapsed",this.handleBattleElapsedSync);
         _loc1_.on("Battle.spectator.sync",this.handleSpectatorSync);
         _loc1_.on("Conversation.battle.newMessage",this.handleChatMessage);
         _loc1_.on("Battle.spectator.count",this.handleSpectatorCount);
         _loc1_.on("Battle.tieBreaker",this.handleTieBreaker);
         _loc1_.on("Battle.berserk",this.handleBerserk);
         _loc1_.on("Battle.ended",this.onBattleEnded);
         for(_loc2_ in PvPBattleManager.CHARACTER_MANAGERS)
         {
            _loc3_ = 0;
            while(_loc3_ < PvPBattleManager.CHARACTER_MANAGERS[_loc2_].length)
            {
               _loc4_ = PvPBattleManager.CHARACTER_MANAGERS[_loc2_][_loc3_].getCharacterModel();
               this._eventHandler.addListener(_loc4_,BattleAnimationEvent.DODGE_FINISHED,this.handleDodgeFinished);
               this._eventHandler.addListener(_loc4_,BattleAnimationEvent.CHARGE_FINISHED,this.handleChargeFinished);
               this._eventHandler.addListener(_loc4_,BattleAnimationEvent.WEAPON_FINISHED,this.handleWeaponFinished);
               this._eventHandler.addListener(_loc4_,BattleAnimationEvent.ITEM_FINISHED,this.handleItemFinished);
               this._eventHandler.addListener(_loc4_,BattleAnimationEvent.HIT,this.handleHit);
               _loc3_++;
            }
         }
         for(_loc2_ in PvPBattleManager.PET_MANAGERS)
         {
            _loc3_ = 0;
            while(_loc3_ < PvPBattleManager.PET_MANAGERS[_loc2_].length)
            {
               _loc5_ = PvPBattleManager.PET_MANAGERS[_loc2_][_loc3_].getPetModel();
               this._eventHandler.addListener(_loc5_,BattleAnimationEvent.DODGE_FINISHED,this.handleDodgeFinished);
               this._eventHandler.addListener(_loc5_,BattleAnimationEvent.ATTACK_FINISHED,this.handlePetFinished);
               this._eventHandler.addListener(_loc5_,BattleAnimationEvent.HIT,this.handleHit);
               _loc3_++;
            }
         }
         this._eventHandler.addListener(this._battle.chatBoxMc,KeyboardEvent.KEY_UP,this.sendBattleChatMessage);
         this._eventHandler.addListener(this._battle.btn_close,MouseEvent.CLICK,this.closeBattleConfirmation);
         this._eventHandler.addListener(this._battle.btn_UI_Gear,MouseEvent.CLICK,this.handleOpenGear);
         this._eventHandler.addListener(this._battle.btn_UI_Option,MouseEvent.CLICK,this.handleOpenOption);
         this.handleSpectatorCount(0);
         this.handleBattleElapsedSync({"elapsedMs":PvPBattleManager.getBattleElapsedMs()});
         this.startElapsedTimer();
         if(PvPBattleManager.getIsSpectator())
         {
            _loc1_.emit("Battle.spectator.ready",{"battleId":PvPBattleManager.getBattleID()});
         }
      }
      
      private function handleSpectatorSync(param1:Object) : void
      {
         if(!PvPBattleManager.getIsSpectator() || !param1)
         {
            return;
         }
         if(param1.hasOwnProperty("elapsedMs"))
         {
            this.handleBattleElapsedSync(param1);
         }
         if(param1.hasOwnProperty("attackBar") && Boolean(PvPBattleManager.AGILITY_BAR_MANAGER))
         {
            PvPBattleManager.AGILITY_BAR_MANAGER.applySpectatorSync(param1.attackBar);
         }
         this.syncSpectatorTurnState(param1.hasOwnProperty("activeTurnCharId") ? param1.activeTurnCharId : null,param1.hasOwnProperty("turnUsed") ? param1.turnUsed === true : true,param1.hasOwnProperty("remainingTurnSeconds") ? int(param1.remainingTurnSeconds) : 0);
      }
      
      private function syncSpectatorTurnState(param1:*, param2:Boolean, param3:int) : void
      {
         this._lastAmbushCharId = param1;
         if(param1 == null || param2 || param3 <= 0)
         {
            this.stopTurnTimer();
            return;
         }
         this.startTurnTimer(param3);
      }
      
      private function handleBattleElapsedSync(param1:Object) : void
      {
         if(!param1 || !param1.hasOwnProperty("elapsedMs"))
         {
            return;
         }
         this._elapsedBaseMs = Math.max(0,Number(param1.elapsedMs));
         this._elapsedBaseTick = getTimer();
         if(param1.hasOwnProperty("rankedDurationMs") && Number(param1.rankedDurationMs) > 0)
         {
            this._rankedDurationSeconds = int(Number(param1.rankedDurationMs) / 1000);
         }
         if(Boolean(param1.hasOwnProperty("isBerserkActive")) && Boolean(param1.isBerserkActive) && !this._berserkActive)
         {
            this._berserkActive = true;
         }
         this.updateElapsedTimerDisplay();
      }
      
      private function startElapsedTimer() : void
      {
         this.stopElapsedTimer();
         this._elapsedTimer = new Timer(ELAPSED_TIMER_INTERVAL_MS);
         this._elapsedTimer.addEventListener(TimerEvent.TIMER,this.handleElapsedTimerTick,false,0,true);
         this._elapsedTimer.start();
         this.updateElapsedTimerDisplay();
      }
      
      private function stopElapsedTimer() : void
      {
         if(!this._elapsedTimer)
         {
            return;
         }
         this._elapsedTimer.removeEventListener(TimerEvent.TIMER,this.handleElapsedTimerTick);
         this._elapsedTimer.stop();
         this._elapsedTimer = null;
      }
      
      private function handleElapsedTimerTick(param1:TimerEvent) : void
      {
         this.updateElapsedTimerDisplay();
      }
      
      private function updateElapsedTimerDisplay() : void
      {
         var _loc1_:Object = this.getElapsedTimerTextTarget();
         if(!_loc1_)
         {
            return;
         }
         _loc1_.text = this.formatElapsedTime(this.getElapsedSeconds());
         if(_loc1_.hasOwnProperty("textColor"))
         {
            _loc1_.textColor = this._berserkActive ? BERSERK_TIMER_COLOR : DEFAULT_TIMER_COLOR;
         }
      }
      
      private function getElapsedSeconds() : int
      {
         var _loc1_:int = Math.max(0,int((this._elapsedBaseMs + (getTimer() - this._elapsedBaseTick)) / 1000));
         if(PvPBattleManager.getIsRankedMode())
         {
            return Math.max(0,this._rankedDurationSeconds - _loc1_);
         }
         return _loc1_;
      }
      
      private function formatElapsedTime(param1:int) : String
      {
         var _loc2_:int = int(param1 / 60);
         var _loc3_:int = param1 % 60;
         return this.padTime(_loc2_) + ":" + this.padTime(_loc3_);
      }
      
      private function padTime(param1:int) : String
      {
         return param1 < 10 ? "0" + param1 : String(param1);
      }
      
      private function getElapsedTimerTextTarget() : Object
      {
         if(!this._battle)
         {
            return null;
         }
         var _loc1_:Object = this.resolveElapsedTimerTextTarget(this._battle);
         if(_loc1_)
         {
            return _loc1_;
         }
         return this.resolveElapsedTimerTextTarget(this._battle.actionBar);
      }
      
      private function resolveElapsedTimerTextTarget(param1:Object) : Object
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         if(!param1)
         {
            return null;
         }
         for each(_loc2_ in ELAPSED_TIMER_TARGETS)
         {
            if(!(!param1.hasOwnProperty(_loc2_) || !param1[_loc2_]))
            {
               _loc3_ = param1[_loc2_];
               if(Boolean(_loc3_.hasOwnProperty("txt")) && Boolean(_loc3_.txt) && Boolean(_loc3_.txt.hasOwnProperty("text")))
               {
                  return _loc3_.txt;
               }
               if(_loc3_.hasOwnProperty("text"))
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function handleAmbushAction(param1:Object) : void
      {
         this._lastAmbushCharId = param1.id;
         if(PvPBattleManager.getIsSpectator())
         {
            this.syncSpectatorTurnState(param1.id,false,Boolean(param1) && param1.hasOwnProperty("remainingTurnSeconds") ? int(param1.remainingTurnSeconds) : BattleTimer.DEFAULT_TURN_DURATION_SECONDS);
            return;
         }
         if(param1.id != PvPBattleManager.PVP.character.getID())
         {
            this._battleTimer.startTurnTimer(BattleTimer.DEFAULT_TURN_DURATION_SECONDS);
            return;
         }
         var _loc2_:CharacterManager = PvPBattleManager.getCharacterManagerByID(param1.id);
         if(!_loc2_)
         {
            Log.error(this,"handleAmbushAction","Character manager not found");
            return;
         }
         _loc2_.getActionManager().showActionBar();
         this.startTurnTimer(BattleTimer.DEFAULT_TURN_DURATION_SECONDS);
      }
      
      public function handleDodgeAction(param1:Object) : void
      {
         var _loc2_:CharacterManager = PvPBattleManager.getCharacterManagerByID(param1.id);
         var _loc3_:PetManager = PvPBattleManager.getPetManagerByID(param1.id + "_pet");
         if(!_loc2_)
         {
            Log.error(this,"handleDodgeAction","Character manager not found");
            return;
         }
         _loc2_.getCharacterModel().playAnimation("dodge");
         this.stopTurnTimer();
      }
      
      public function handleChargeAction(param1:Object) : void
      {
         var _loc2_:CharacterManager = PvPBattleManager.getCharacterManagerByID(param1.id);
         if(!_loc2_)
         {
            Log.error(this,"handleChargeAction","Character manager not found");
            return;
         }
         if(Boolean(param1.error) && param1.id == PvPBattleManager.PVP.character.getID())
         {
            PvPBattleManager.getMain().showMessage(param1.error);
            _loc2_.getActionManager().showActionBar();
            this.resumeTurnTimer();
            return;
         }
         this.stopTurnTimer();
         _loc2_.updateStats(param1.stat);
         _loc2_.getCharacterModel().refreshStats(_loc2_,this._battle).playAnimation("charge");
         PvPBattleManager.EFFECT_OVERLAY.showOverlayEffects(_loc2_,param1.overlays);
      }
      
      public function handleWeaponAction(param1:Object) : void
      {
         Log.info(this,"handleWeaponAction",JSON.stringify(param1));
         var _loc2_:CharacterManager = PvPBattleManager.getCharacterManagerByID(param1.id);
         if(!_loc2_)
         {
            Log.error(this,"handleWeaponAction","Character manager not found");
            return;
         }
         if(Boolean(param1.error) && param1.id == PvPBattleManager.PVP.character.getID())
         {
            PvPBattleManager.getMain().showMessage(param1.error);
            _loc2_.getActionManager().showActionBar();
            this.resumeTurnTimer();
            return;
         }
         this.stopTurnTimer();
         this._actions.push(param1);
         _loc2_.getCharacterModel().attackWithWeapon(_loc2_);
      }
      
      public function handleSkillAction(param1:Object) : void
      {
         Log.info(this,"handleSkillAction",JSON.stringify(param1));
         var _loc2_:CharacterManager = PvPBattleManager.getCharacterManagerByID(param1.id);
         if(!_loc2_)
         {
            Log.error(this,"handleSkillAction","Character manager not found");
            return;
         }
         if(Boolean(param1.error) && param1.id == PvPBattleManager.PVP.character.getID())
         {
            PvPBattleManager.getMain().showMessage(param1.error);
            _loc2_.getActionManager().showActionBar();
            this.resumeTurnTimer();
            return;
         }
         if(param1.hasOwnProperty("skillName"))
         {
            PvPBattleManager.getMain().showMessage(param1.skillName);
         }
         this.stopTurnTimer();
         this._actions.push(param1);
         if(param1.hasOwnProperty("copySkill") && Boolean(param1.copySkill))
         {
            _loc2_.getActionManager().playCopySkill(param1.skillId);
         }
         else
         {
            _loc2_.getActionManager().playSkill(param1.skillId);
         }
      }
      
      public function handleRunAction(param1:Object) : void
      {
         Log.info(this,"handleRunAction",JSON.stringify(param1));
         var _loc2_:* = PvPBattleManager.getCharacterManagerByID(param1.id);
         if(!_loc2_)
         {
            Log.error(this,"handleRunAction","Character manager not found");
            return;
         }
         var _loc3_:* = PvPBattleManager.getBattle().getObjectHolder(_loc2_.getPlayerTeam(),_loc2_.getPlayerNumber());
         _loc3_.charMc.visible = true;
         _loc3_.skillMc.visible = false;
         _loc2_.getCharacterModel().playAnimation("run");
         this.stopTurnTimer();
      }
      
      public function handleScrollAction(param1:Object) : void
      {
         Log.info(this,"handleScrollAction",JSON.stringify(param1));
         var _loc2_:int = 0;
         var _loc3_:* = PvPBattleManager.getCharacterManagerByID(param1.id);
         if(!_loc3_)
         {
            Log.error(this,"handleScrollAction","Character manager not found");
            return;
         }
         if(Boolean(param1.error) && param1.id == PvPBattleManager.PVP.character.getID())
         {
            PvPBattleManager.getMain().showMessage(param1.error);
            _loc3_.getActionManager().showActionBar();
            this.resumeTurnTimer();
            return;
         }
         if(param1.id == PvPBattleManager.PVP.character.getID() && param1.hasOwnProperty("scrolls"))
         {
            _loc3_.updateScrolls(param1.scrolls);
            _loc3_.getActionManager().updateScrollsDisplay();
         }
         this.stopTurnTimer();
         if(this._gearPanel)
         {
            this._gearPanel.visible = false;
         }
         if(param1.hasOwnProperty("overlays"))
         {
            PvPBattleManager.EFFECT_OVERLAY.showOverlays(PvPBattleManager,param1.overlays);
         }
         if(param1.hasOwnProperty("stats"))
         {
            _loc2_ = 0;
            while(_loc2_ < param1.stats.length)
            {
               _loc3_ = PvPBattleManager.getCharacterManagerByID(param1.stats[_loc2_].id);
               if(_loc3_)
               {
                  _loc3_.updateStats(param1.stats[_loc2_].stat);
                  _loc3_.getCharacterModel().refreshStats(_loc3_,this._battle);
               }
               _loc2_++;
            }
         }
         _loc3_.getCharacterModel().playAnimation("item");
      }
      
      public function handlePetAction(param1:Object) : void
      {
         Log.debug(this,"pet",JSON.stringify(param1));
         var _loc2_:* = PvPBattleManager.getPetManagerByID(param1.id);
         if(!_loc2_)
         {
            Log.error(this,"handlePetAction","Pet manager not found");
            return;
         }
         if(param1.hasOwnProperty("name"))
         {
            PvPBattleManager.getMain().showMessage(param1.name);
         }
         this._actions.push(param1);
         _loc2_.getPetModel().playAnimation(param1.attack);
      }
      
      public function handleHit(param1:* = null) : void
      {
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         if(this._actions.length < 1)
         {
            return;
         }
         var _loc2_:Object = this._actions.shift();
         var _loc3_:* = PvPBattleManager.getCharacterManagerByID(_loc2_.id);
         var _loc4_:* = PvPBattleManager.getPetManagerByID(_loc2_.id);
         var _loc5_:* = _loc3_ ? _loc3_ : _loc4_;
         var _loc6_:* = _loc3_ ? _loc3_.getCharacterModel() : _loc4_.getPetModel();
         if(Boolean(_loc5_) && _loc2_.hasOwnProperty("stat"))
         {
            _loc5_.updateStats(_loc2_.stat);
         }
         if((_loc2_.action == "weapon" || _loc2_.action == "skill" || _loc2_.action == "pet") && _loc2_.hasOwnProperty("targets") && _loc8_ != _loc2_.id)
         {
            _loc7_ = _loc2_.hasOwnProperty("dodged") && Boolean(_loc2_.dodged) ? "dodge" : "hit";
            _loc8_ = _loc2_.targets is Array ? _loc2_.targets : [_loc2_.targets];
            _loc9_ = 0;
            while(_loc9_ < _loc8_.length)
            {
               _loc3_ = PvPBattleManager.getCharacterManagerByID(_loc8_[_loc9_]);
               _loc4_ = PvPBattleManager.getPetManagerByID(_loc8_[_loc9_]);
               _loc5_ = _loc3_ ? _loc3_ : _loc4_;
               _loc6_ = _loc3_ ? _loc3_.getCharacterModel() : _loc4_.getPetModel();
               if(_loc5_)
               {
                  _loc6_.playAnimation(_loc7_);
               }
               _loc9_++;
            }
         }
         if(_loc2_.hasOwnProperty("stats"))
         {
            _loc9_ = 0;
            while(_loc9_ < _loc2_.stats.length)
            {
               _loc3_ = PvPBattleManager.getCharacterManagerByID(_loc2_.stats[_loc9_].id);
               _loc4_ = PvPBattleManager.getPetManagerByID(_loc2_.stats[_loc9_].id);
               _loc5_ = _loc3_ ? _loc3_ : _loc4_;
               _loc6_ = _loc3_ ? _loc3_.getCharacterModel() : _loc4_.getPetModel();
               if(_loc3_)
               {
                  _loc3_.updateStats(_loc2_.stats[_loc9_].stat);
                  _loc3_.getCharacterModel().refreshStats(_loc3_,this._battle);
               }
               _loc9_++;
            }
         }
         if(_loc2_.hasOwnProperty("overlays"))
         {
            PvPBattleManager.EFFECT_OVERLAY.showOverlays(PvPBattleManager,_loc2_.overlays);
         }
      }
      
      public function handleUpdateInfo(param1:Object) : void
      {
         Log.info(this,"handleUpdateInfo",JSON.stringify(param1));
         var _loc2_:int = 0;
         var _loc3_:* = PvPBattleManager.getCharacterManagerByID(param1.id);
         if(param1.hasOwnProperty("skillCooldowns") && Boolean(_loc3_))
         {
            _loc3_.getActionManager().updateSkillsCooldownDisplay(param1.skillCooldowns);
         }
         if(param1.hasOwnProperty("stat") && Boolean(_loc3_))
         {
            _loc3_.updateStats(param1.stat);
            _loc3_.getCharacterModel().refreshStats(_loc3_,this._battle);
            _loc3_.getActionManager().updateSageModeButton();
         }
         if(Boolean(_loc3_) && Boolean(_loc3_.getID() == PvPBattleManager.PVP.character.getID()) && param1.hasOwnProperty("scrolls"))
         {
            _loc3_.updateScrolls(param1.scrolls);
            _loc3_.getActionManager().updateScrollsDisplay();
         }
         if(param1.hasOwnProperty("stats") && param1.stats is Array)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.stats.length)
            {
               _loc3_ = PvPBattleManager.getCharacterManagerByID(param1.stats[_loc2_].id);
               if(_loc3_)
               {
                  _loc3_.updateStats(param1.stats[_loc2_].stat);
                  _loc3_.getCharacterModel().refreshStats(_loc3_,this._battle);
                  if(param1.stats[_loc2_].hasOwnProperty("es"))
                  {
                     _loc3_.updateEnemyRandomSkills(param1.stats[_loc2_].es);
                  }
               }
               _loc2_++;
            }
         }
         if(param1.hasOwnProperty("changeBg"))
         {
            PvPBattleManager.BATTLE_LOADER.loadBackground(param1.changeBg);
         }
         if(param1.hasOwnProperty("resetBg"))
         {
            PvPBattleManager.BATTLE_LOADER.loadBackground();
         }
         if(param1.hasOwnProperty("effects") && param1.effects is Array)
         {
            this._ownEffects = param1.effects;
         }
         if(param1.hasOwnProperty("overlays"))
         {
            PvPBattleManager.EFFECT_OVERLAY.showOverlays(PvPBattleManager,param1.overlays);
         }
      }
      
      public function get ownEffects() : Array
      {
         return this._ownEffects;
      }
      
      public function handleWeaponFinished(param1:* = null) : void
      {
         this._actions.shift();
         PvPSocket.getInstance().emit("Battle.action.finished",{
            "battle_id":PvPBattleManager.getBattleID(),
            "action":"weapon"
         });
      }
      
      public function handlePetFinished(param1:* = null) : void
      {
         PvPSocket.getInstance().emit("Battle.action.finished",{
            "battle_id":PvPBattleManager.getBattleID(),
            "action":"pet"
         });
      }
      
      public function handleDodgeFinished(param1:* = null) : void
      {
         PvPSocket.getInstance().emit("Battle.action.finished",{
            "battle_id":PvPBattleManager.getBattleID(),
            "action":"dodge"
         });
      }
      
      public function handleChargeFinished(param1:* = null) : void
      {
         PvPSocket.getInstance().emit("Battle.action.finished",{
            "battle_id":PvPBattleManager.getBattleID(),
            "action":"charge"
         });
      }
      
      public function handleSkillFinished(param1:String) : void
      {
         PvPSocket.getInstance().emit("Battle.action.finished",{
            "battle_id":PvPBattleManager.getBattleID(),
            "action":"skill",
            "skillId":param1
         });
      }
      
      public function handleItemFinished(param1:* = null) : void
      {
         PvPSocket.getInstance().emit("Battle.action.finished",{
            "battle_id":PvPBattleManager.getBattleID(),
            "action":"scroll"
         });
      }
      
      public function handleTimerTimeout() : void
      {
         var _loc2_:CharacterManager = null;
         if(PvPBattleManager.getIsSpectator())
         {
            this.stopTurnTimer();
            return;
         }
         var _loc1_:* = this._lastAmbushCharId == PvPBattleManager.PVP.character.getID() ? "dodge" : "timeout";
         PvPSocket.getInstance().emit("Battle.action." + _loc1_,{"battle_id":PvPBattleManager.getBattleID()});
         if(this._lastAmbushCharId == PvPBattleManager.PVP.character.getID())
         {
            _loc2_ = PvPBattleManager.getCharacterManagerByID(this._lastAmbushCharId);
            if(_loc2_)
            {
               _loc2_.getActionManager().hideActionBar();
            }
         }
      }
      
      public function handleTimerTick() : void
      {
         if(!this._battle || !this._battle.actionBar || !this._battle.atk_turnTimerTxt || !this._battle.atk_turnTimerTxt.txt)
         {
            return;
         }
         var _loc1_:Timer = this._battleTimer.getTimer();
         if(!_loc1_)
         {
            return;
         }
         this._battle.atk_turnTimerTxt.visible = true;
         this._battle.atk_turnTimerTxt.txt.text = String(this._battleTimer.getTurnDurationSeconds() - int(_loc1_.currentCount));
      }
      
      public function sendBattleChatMessage(param1:KeyboardEvent) : void
      {
         if(this._battle.chatBoxMc.chatInputMc.text != "" && param1.charCode == 13)
         {
            PvPSocket.getInstance().emit("Conversation.battle.sendMessage",{
               "message":this._battle.chatBoxMc.chatInputMc.text,
               "battle_id":PvPBattleManager.getBattleID()
            });
            this._battle.chatBoxMc.chatInputMc.text = "";
         }
      }
      
      public function handleChatMessage(param1:Object) : void
      {
         this._chatMessages.push(PvPLobby.formatLobbyMessage(param1));
         if(this._chatMessages.length > this._maxChatMessages)
         {
            this._chatMessages.shift();
         }
         this._battle.chatBoxMc.pvp_match_chat_outputMC.htmlText = this._chatMessages.join("\n");
         if(this._battle.chatBoxMc.pvp_match_chat_outputMC.hasOwnProperty("maxScrollV"))
         {
            this._battle.chatBoxMc.pvp_match_chat_outputMC.scrollV = this._battle.chatBoxMc.pvp_match_chat_outputMC.maxScrollV;
         }
      }
      
      public function onBattleEnded(param1:Object) : void
      {
         if(this._tieBreakerAnimating)
         {
            this._queuedBattleEndData = param1;
            return;
         }
         Log.info(this,"onBattleEnded",encodeJson(param1));
         var _loc2_:* = PvPSocket.getInstance();
         _loc2_.off("Battle.elapsed",this.handleBattleElapsedSync);
         _loc2_.off("Battle.berserk",this.handleBerserk);
         this.stopElapsedTimer();
         if(this._battleTimer)
         {
            this._battleTimer.stopTurnTimer();
         }
         PvPBattleManager.PVP.spectatorMode = false;
         if(this._battleResult)
         {
            this._battleResult.destroy();
            this._battleResult = null;
         }
         this._battleResult = new BattleResult();
         this._battleResult.setResultData(param1);
         PvPBattleManager.getMain().loader.addChild(this._battleResult);
      }
      
      private function handleTieBreaker(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:int = 0;
         var _loc6_:CharacterManager = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:CharacterManager = null;
         Log.info(this,"handleTieBreaker",encodeJson(param1));
         this.stopElapsedTimer();
         if(this._battleTimer)
         {
            this._battleTimer.stopTurnTimer();
         }
         for(_loc2_ in PvPBattleManager.CHARACTER_MANAGERS)
         {
            _loc5_ = 0;
            while(_loc5_ < PvPBattleManager.CHARACTER_MANAGERS[_loc2_].length)
            {
               _loc6_ = PvPBattleManager.CHARACTER_MANAGERS[_loc2_][_loc5_];
               if((Boolean(_loc6_)) && Boolean(_loc6_.getActionManager()))
               {
                  _loc6_.getActionManager().hideActionBar();
               }
               _loc5_++;
            }
         }
         if(Boolean(this._battle) && Boolean(this._battle.actionBar))
         {
            this._battle.actionBar.visible = false;
         }
         var _loc3_:int = param1.hasOwnProperty("durationMs") ? int(param1.durationMs) : 4000;
         var _loc4_:Array = param1.stats as Array;
         if(_loc4_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               _loc8_ = _loc4_[_loc7_];
               _loc9_ = PvPBattleManager.getCharacterManagerByID(String(_loc8_.id));
               if((Boolean(_loc9_)) && Boolean(_loc9_.getCharacterModel()))
               {
                  _loc9_.getCharacterModel().animateHpToZero(int(_loc8_.hp),int(_loc8_.maxHp),_loc3_,_loc9_,this._battle);
               }
               _loc7_++;
            }
         }
         this._tieBreakerAnimating = true;
         if(this._tieBreakerTimer)
         {
            this._tieBreakerTimer.stop();
            this._tieBreakerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTieBreakerComplete);
            this._tieBreakerTimer = null;
         }
         this._tieBreakerTimer = new Timer(_loc3_,1);
         this._tieBreakerTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTieBreakerComplete);
         this._tieBreakerTimer.start();
      }
      
      private function handleBerserk(param1:Object) : void
      {
         Log.info(this,"handleBerserk",encodeJson(param1));
         this._berserkActive = true;
         this._battle.berserkMC.gotoAndPlay(2);
         PvPBattleManager.BATTLE_LOADER.loadBackground(BERSERK_BACKGROUND_ID);
         PvPBattleManager.BATTLE_LOADER.berserk = true;
         this.updateElapsedTimerDisplay();
      }
      
      private function onTieBreakerComplete(param1:TimerEvent) : void
      {
         var _loc2_:Object = null;
         if(this._tieBreakerTimer)
         {
            this._tieBreakerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTieBreakerComplete);
            this._tieBreakerTimer.stop();
            this._tieBreakerTimer = null;
         }
         this._tieBreakerAnimating = false;
         if(this._queuedBattleEndData)
         {
            _loc2_ = this._queuedBattleEndData;
            this._queuedBattleEndData = null;
            this.onBattleEnded(_loc2_);
         }
      }
      
      public function handleSpectatorCount(param1:int) : void
      {
         this._battle.spectatorViewMC.txt.text = String(param1);
      }
      
      public function pauseTurnTimer() : *
      {
         this._battle.atk_turnTimerTxt.visible = false;
         this._battle.atk_turnTimerTxt.txt.text = String(this._battleTimer.getTurnDurationSeconds());
         this._battleTimer.pauseTurnTimer();
      }
      
      public function resumeTurnTimer() : *
      {
         this._battle.atk_turnTimerTxt.visible = true;
         this._battleTimer.resumeTurnTimer();
      }
      
      public function startTurnTimer(param1:int = -1) : *
      {
         this._battle.atk_turnTimerTxt.visible = true;
         this._battle.atk_turnTimerTxt.txt.text = String(this._battleTimer.getTurnDurationSeconds());
         this._battleTimer.startTurnTimer(param1);
      }
      
      public function stopTurnTimer() : *
      {
         this._battleTimer.stopTurnTimer();
         this._battle.atk_turnTimerTxt.visible = false;
         this._battle.atk_turnTimerTxt.txt.text = "";
      }
      
      protected function closeBattleConfirmation(param1:MouseEvent) : void
      {
         this._confirmation = new Confirmation();
         this._confirmation.txtMc.txt.text = "Are you sure you want to leave the battle?";
         this._eventHandler.addListener(this._confirmation.btn_confirm,MouseEvent.CLICK,this.handleCloseBattle);
         this._eventHandler.addListener(this._confirmation.btn_close,MouseEvent.CLICK,this.handleCloseConfirmation);
         PvPBattleManager.getMain().loader.addChild(this._confirmation);
      }
      
      protected function handleCloseConfirmation(param1:MouseEvent) : void
      {
         GF.removeAllChild(this._confirmation);
         this._confirmation = null;
      }
      
      protected function handleCloseBattle(param1:MouseEvent) : void
      {
         this.handleCloseConfirmation(null);
         if(PvPBattleManager.getIsSpectator() && Boolean(PvPBattleManager.PVP))
         {
            PvPBattleManager.PVP.leaveSpectatorMode();
         }
         else
         {
            PvPSocket.getInstance().emit("Battle.action.run",{"battle_id":PvPBattleManager.getBattleID()});
            PvPBattleManager.getMain().stopAllBgm();
            PvPBattleManager.getMain().startBgm();
            PvPBattleManager.endBattle();
         }
      }
      
      protected function handleOpenOption(param1:MouseEvent) : void
      {
         if(this._optionPanel)
         {
            this._optionPanel.destroy();
            GF.removeParent(this._optionPanel);
            this._optionPanel = null;
         }
         this._optionPanel = PvPBattleManager.getMain().loadPanel("Panels.UI_Option",true);
         this._optionPanel.setOnBattle();
         this._optionPanel.panel.btn_change.visible = false;
         this._optionPanel.panel.btn_logout.visible = false;
         this._optionPanel.visible = true;
      }
      
      protected function handleOpenGear(param1:MouseEvent) : void
      {
         if(this._lastAmbushCharId != PvPBattleManager.PVP.character.getID())
         {
            return;
         }
         if(this._gearPanel)
         {
            this._eventHandler.removeListener(this._gearPanel,BattleAnimationEvent.ITEM_USE,this.handleItemUseGear);
            this._gearPanel.destroy();
            GF.removeParent(this._gearPanel);
            this._gearPanel = null;
         }
         this._gearPanel = PvPBattleManager.getMain().loadPanel("Panels.Battle_UI_Gear",true);
         this._eventHandler.addListener(this._gearPanel,BattleAnimationEvent.ITEM_USE,this.handleItemUseGear);
         this._gearPanel.visible = true;
      }
      
      protected function handleItemUseGear(param1:BattleAnimationEvent) : void
      {
         Log.info(this,"handleItemUseGear",param1.id);
         PvPSocket.getInstance().emit("Battle.action.scroll",{
            "battle_id":PvPBattleManager.getBattleID(),
            "scroll_id":param1.id
         });
         var _loc2_:* = PvPBattleManager.getCharacterManagerByID(this._lastAmbushCharId);
         if(_loc2_)
         {
            _loc2_.getActionManager().hideActionBar();
         }
         this.pauseTurnTimer();
      }
      
      public function destroy() : void
      {
         var _loc1_:* = PvPSocket.getInstance();
         _loc1_.off("Battle.action.ambush",this.handleAmbushAction);
         _loc1_.off("Battle.action.dodge",this.handleDodgeAction);
         _loc1_.off("Battle.action.charge",this.handleChargeAction);
         _loc1_.off("Battle.action.weapon",this.handleWeaponAction);
         _loc1_.off("Battle.action.skill",this.handleSkillAction);
         _loc1_.off("Battle.action.run",this.handleRunAction);
         _loc1_.off("Battle.action.scroll",this.handleScrollAction);
         _loc1_.off("Battle.action.pet",this.handlePetAction);
         _loc1_.off("Battle.updateInfo",this.handleUpdateInfo);
         _loc1_.off("Battle.elapsed",this.handleBattleElapsedSync);
         _loc1_.off("Battle.spectator.sync",this.handleSpectatorSync);
         _loc1_.off("Battle.berserk",this.handleBerserk);
         _loc1_.off("Conversation.battle.newMessage",this.handleChatMessage);
         _loc1_.off("Battle.spectator.count",this.handleSpectatorCount);
         _loc1_.off("Battle.tieBreaker",this.handleTieBreaker);
         _loc1_.off("Battle.ended",this.onBattleEnded);
         if(this._tieBreakerTimer)
         {
            this._tieBreakerTimer.stop();
            this._tieBreakerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTieBreakerComplete);
            this._tieBreakerTimer = null;
         }
         this._queuedBattleEndData = null;
         if(this._eventHandler)
         {
            this._eventHandler.removeAllEventListeners();
         }
         if(this._confirmation)
         {
            GF.removeAllChild(this._confirmation);
            this._confirmation = null;
         }
         if(this._battleTimer)
         {
            this._battleTimer.destroy();
            this._battleTimer = null;
         }
         this.stopElapsedTimer();
         this._elapsedBaseMs = 0;
         this._elapsedBaseTick = 0;
         if(this._gearPanel)
         {
            this._gearPanel.destroy();
            GF.removeParent(this._gearPanel);
            this._gearPanel = null;
         }
         if(this._optionPanel)
         {
            this._optionPanel.destroy();
            GF.removeParent(this._optionPanel);
            this._optionPanel = null;
         }
         if(this._battleResult)
         {
            GF.removeAllChild(this._battleResult);
            GF.removeParent(this._battleResult);
            this._battleResult = null;
         }
         this._eventHandler = null;
         this._actions = null;
         this._battle = null;
         this._chatMessages = null;
         this._lastAmbushCharId = null;
      }
   }
}

