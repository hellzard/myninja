package id.ninjasage.pvp.battle
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import gs.easing.Linear;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.Battle;
   import id.ninjasage.multiplayer.battle.CharacterManager;
   import id.ninjasage.multiplayer.battle.PetManager;
   import id.ninjasage.multiplayer.battle.PetModel;
   import id.ninjasage.pvp.PvPSocket;
   
   public class PvPAgilityBarManager
   {
      
      private static const INITIAL_DELAY_MS:int = 500;
      
      private static const ACTION_BAR_DIVIDER:int = 20;
      
      private static const ACTION_BAR_WIDTH:int = 600;
      
      private static const NON_WINNER_FINISH_GAP:int = 12;
      
      private static const NON_WINNER_FINISH_X:int = ACTION_BAR_WIDTH - NON_WINNER_FINISH_GAP;
      
      private static const HEAD_Y_PLAYER:int = -30;
      
      private static const HEAD_Y_ENEMY:int = 7;
      
      private static const HEAD_SCALE:Number = 0.5;
      
      private static const MAX_PET_HEAD_CHECK_RETRIES:int = 10;
      
      private static const TEAM_PLAYER:String = "player";
      
      private static const TEAM_ENEMY:String = "enemy";
      
      private var _actionBar:MovieClip;
      
      private var _playersMcHolders:Object;
      
      private var _teamHeadMcAgility:Array;
      
      private var _battle:Battle;
      
      private var _isRunning:Boolean = false;
      
      private var _animationRunning:Boolean = false;
      
      private var _enableActions:Boolean = false;
      
      private var _turns:int = 0;
      
      private var _destroyed:Boolean = false;
      
      private var _timeoutId:uint = 0;
      
      private var _startRunToken:uint = 0;
      
      private var _petHeadCheckTimeoutId:uint = 0;
      
      private var _petHeadCheckRetries:int = 0;
      
      private var _toRepeatNumber:int = 0;
      
      private var _calcType:String = "Integer";
      
      private var _plusXNextRound:Object;
      
      private var _lastAmbushKey:String = "";
      
      private var _ambushTeam:String = "";
      
      private var _ambushNum:int = -1;
      
      private var _authoritativeWinnerId:String = "";
      
      private var _sortIndices:Object = {};
      
      private var _entitiesVisible:Boolean = false;
      
      private var _socketEventsRegistered:Boolean = false;
      
      private var _setupCompleted:Boolean = false;
      
      private var _battleReady:Boolean = false;
      
      private var _pendingStartAttackBarData:Object = null;
      
      private var _serverFrame:Object = {};
      
      public function PvPAgilityBarManager()
      {
         super();
         this._teamHeadMcAgility = [];
         this._playersMcHolders = {};
         this._plusXNextRound = {};
         this._battle = PvPBattleManager.getBattle();
         if(!this._battle)
         {
            Log.warning("PvPAgilityBarManager","constructor","Battle not initialized");
            return;
         }
         if(!this.initializeActionBar())
         {
            return;
         }
         if(!this.initializePlayerHolders())
         {
            return;
         }
         this.registerSocketEvents();
      }
      
      public function setup() : void
      {
         this._petHeadCheckRetries = 0;
         this.checkPendingPetHead();
      }
      
      public function setBattleReady(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         if(this._battleReady == param1)
         {
            return;
         }
         this._battleReady = param1;
         if(this._battleReady && this._pendingStartAttackBarData != null)
         {
            Log.debug("PvPAgilityBarManager","setBattleReady","Processing pending startAttackBar");
            _loc2_ = this._pendingStartAttackBarData;
            this._pendingStartAttackBarData = null;
            this.onStartAttackBar(_loc2_);
         }
      }
      
      public function onStartAttackBar(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:Object = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Boolean = false;
         Log.info("PvPAgilityBarManager","onStartAttackBar",JSON.stringify(param1));
         if(!this._setupCompleted || !this._battleReady)
         {
            this._pendingStartAttackBarData = param1;
            return;
         }
         if(this._animationRunning)
         {
            this._pendingStartAttackBarData = param1;
            return;
         }
         this._authoritativeWinnerId = Boolean(param1) && Boolean(param1.hasOwnProperty("w")) && param1.w != null ? String(param1.w) : "";
         this._serverFrame = this.buildServerFrame(param1);
         var _loc2_:Object = this.buildHeadMap();
         var _loc3_:* = 0;
         for(_loc4_ in this._sortIndices)
         {
            delete this._sortIndices[_loc4_];
         }
         for(_loc5_ in param1.x)
         {
            _loc6_ = param1.x[_loc5_];
            _loc7_ = String(_loc6_.i);
            this._sortIndices[_loc7_] = _loc3_++;
            _loc8_ = Number(_loc6_.a || 0) + Number(_loc6_.s || 0);
            this.updateEntityAgility(_loc7_,_loc8_);
            _loc9_ = _loc2_[_loc7_];
            if(!_loc9_)
            {
               _loc9_ = this.findHeadDataByServerId(_loc7_,_loc2_);
            }
            if(_loc9_)
            {
               _loc10_ = Number(_loc6_.p || 0);
               _loc11_ = Number(_loc9_.x);
               _loc12_ = this._lastAmbushKey != "" && this.isSameEntity(this._lastAmbushKey,_loc7_);
               _loc13_ = this._turns == 0 || _loc12_;
               _loc14_ = _loc9_.headMc ? Number(_loc9_.headMc.x) : Math.min(_loc11_,ACTION_BAR_WIDTH);
               _loc15_ = _loc13_ ? 0 : _loc14_;
               _loc16_ = _loc10_ == 0 && Number(_loc6_.s || 0) == 0 && Number(_loc6_.n || 0) == 0;
               _loc9_.visualX = Math.min(_loc10_,ACTION_BAR_WIDTH);
               if(_loc15_ > _loc9_.visualX)
               {
                  _loc15_ = Number(_loc9_.visualX);
               }
               _loc9_.agility = _loc8_;
               _loc9_.x = _loc10_;
               _loc9_.startX = _loc15_;
               _loc9_.isDead = _loc16_;
               if(_loc9_.headMc)
               {
                  TweenLite.killTweensOf(_loc9_.headMc);
                  _loc9_.headMc.visible = !_loc16_;
                  _loc9_.headMc.x = _loc15_;
               }
            }
         }
         Log.debug("PvPAgilityBarManager","onStartAttackBar","turns=" + this._turns + " lastWinner=" + this._lastAmbushKey + " totalHeads=" + _loc3_);
         this._lastAmbushKey = "";
         if(_loc3_ > 0)
         {
            this._teamHeadMcAgility.sort(this.sortAgilityHeads);
         }
         this.startRun(INITIAL_DELAY_MS,param1);
      }
      
      private function buildServerFrame(param1:Object) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc2_:Object = {};
         var _loc3_:Object = this.buildHeadMap();
         if(Boolean(param1) && param1.hasOwnProperty("x"))
         {
            for(_loc4_ in param1.x)
            {
               _loc5_ = param1.x[_loc4_];
               _loc6_ = String(_loc5_.i);
               _loc7_ = _loc3_[_loc6_];
               if(!_loc7_)
               {
                  _loc7_ = this.findHeadDataByServerId(_loc6_,_loc3_);
               }
               if(_loc7_)
               {
                  _loc2_[String(_loc7_.id)] = _loc5_;
               }
               else
               {
                  _loc2_[_loc6_] = _loc5_;
               }
            }
         }
         return _loc2_;
      }
      
      public function applySpectatorSync(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:Object = null;
         var _loc10_:Number = NaN;
         var _loc11_:Boolean = false;
         if(!param1 || !param1.hasOwnProperty("x"))
         {
            return;
         }
         this._authoritativeWinnerId = param1.hasOwnProperty("w") && param1.w != null ? String(param1.w) : "";
         var _loc2_:Object = this.buildHeadMap();
         var _loc3_:* = 0;
         for(_loc4_ in this._sortIndices)
         {
            delete this._sortIndices[_loc4_];
         }
         for(_loc5_ in param1.x)
         {
            _loc6_ = param1.x[_loc5_];
            _loc7_ = String(_loc6_.i);
            this._sortIndices[_loc7_] = _loc3_++;
            _loc8_ = Number(_loc6_.a || 0) + Number(_loc6_.s || 0);
            this.updateEntityAgility(_loc7_,_loc8_);
            _loc9_ = _loc2_[_loc7_];
            if(!_loc9_)
            {
               _loc9_ = this.findHeadDataByServerId(_loc7_,_loc2_);
            }
            if(_loc9_)
            {
               _loc10_ = Number(_loc6_.p || 0);
               _loc11_ = _loc10_ == 0 && Number(_loc6_.s || 0) == 0 && Number(_loc6_.n || 0) == 0;
               _loc9_.agility = _loc8_;
               _loc9_.x = _loc10_;
               _loc9_.startX = 0;
               _loc9_.visualX = Math.min(_loc10_,ACTION_BAR_WIDTH);
               _loc9_.isDead = _loc11_;
               if(_loc9_.headMc)
               {
                  _loc9_.headMc.visible = !_loc11_;
                  _loc9_.headMc.x = _loc9_.visualX;
               }
            }
         }
         if(_loc3_ > 0)
         {
            this._teamHeadMcAgility.sort(this.sortAgilityHeads);
         }
         this.updateAgilityToActionBar();
         this.showEntitiesImmediately();
      }
      
      private function buildHeadMap() : Object
      {
         var _loc4_:Object = null;
         var _loc1_:Object = {};
         var _loc2_:int = int(this._teamHeadMcAgility.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._teamHeadMcAgility[_loc3_];
            if(_loc4_)
            {
               _loc1_[String(_loc4_.id)] = _loc4_;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function updateEntityAgility(param1:String, param2:Number) : void
      {
         var _loc4_:PetManager = null;
         if(param1.indexOf("_pet") >= 0)
         {
            _loc4_ = PvPBattleManager.getPetManagerByID(param1);
            if(_loc4_)
            {
               _loc4_.updateStats({"agility":param2});
            }
            return;
         }
         var _loc3_:CharacterManager = PvPBattleManager.getCharacterManagerByID(param1);
         if(_loc3_)
         {
            _loc3_.updateStats({"agility":param2});
         }
      }
      
      private function showEntitiesImmediately() : void
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this._entitiesVisible || !this._battle)
         {
            return;
         }
         var _loc1_:Array = ["player","enemy","player_pet","enemy_pet"];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = _loc3_ == "player" ? PvPBattleManager.CHARACTER_MANAGERS["player"] : (_loc3_ == "enemy" ? PvPBattleManager.CHARACTER_MANAGERS["enemy"] : (_loc3_ == "player_pet" ? PvPBattleManager.PET_MANAGERS["player_pet"] : PvPBattleManager.PET_MANAGERS["enemy_pet"]));
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc7_ = this._battle.getObjectHolder(_loc6_.getPlayerTeam(),_loc6_.getPlayerNumber());
               if(_loc7_)
               {
                  _loc7_.alpha = 1;
                  _loc7_.visible = true;
               }
               _loc5_++;
            }
            _loc2_++;
         }
         this._actionBar.visible = true;
         this._actionBar.alpha = 1;
         this._entitiesVisible = true;
      }
      
      private function sortAgilityHeads(param1:Object, param2:Object) : int
      {
         if(int(param2.agility) != int(param1.agility))
         {
            return int(param2.agility) - int(param1.agility);
         }
         var _loc3_:int = int(String(param1.id).replace("_pet",""));
         var _loc4_:int = int(String(param2.id).replace("_pet",""));
         if(_loc3_ != _loc4_)
         {
            return _loc3_ - _loc4_;
         }
         if(param1.isPet != param2.isPet)
         {
            return param1.isPet ? 1 : -1;
         }
         return int(param1.num) - int(param2.num);
      }
      
      private function initializeActionBar() : Boolean
      {
         this._actionBar = this._battle.atbBar;
         if(!this._actionBar)
         {
            Log.warning("PvPAgilityBarManager","initializeActionBar","Action bar not found");
            return false;
         }
         return true;
      }
      
      private function initializePlayerHolders() : Boolean
      {
         this._playersMcHolders = {
            "enemy_0":this._battle.enemyMc_0,
            "player_0":this._battle.charMc_0,
            "player_pet_0":this._battle.charPetMc_0,
            "enemy_pet_0":this._battle.enemyPetMc_0
         };
         return true;
      }
      
      private function checkPendingPetHead() : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc4_:PetManager = null;
         var _loc5_:PetModel = null;
         var _loc6_:MovieClip = null;
         if(this._petHeadCheckTimeoutId > 0)
         {
            clearTimeout(this._petHeadCheckTimeoutId);
            this._petHeadCheckTimeoutId = 0;
         }
         if(this._destroyed)
         {
            Log.debug("PvPAgilityBarManager","checkPendingPetHead","Manager destroyed, aborting");
            return;
         }
         var _loc1_:Array = [];
         for(_loc2_ in this._playersMcHolders)
         {
            if(_loc2_.indexOf("pet") >= 0)
            {
               _loc3_ = this._playersMcHolders[_loc2_] as MovieClip;
               if(_loc3_)
               {
                  _loc4_ = this.getPetManager(_loc3_);
                  if(_loc4_)
                  {
                     _loc5_ = _loc4_.getPetModel();
                     if(!_loc5_)
                     {
                        _loc1_.push(_loc2_);
                     }
                     else
                     {
                        _loc6_ = _loc5_.getHead();
                        if(!_loc6_)
                        {
                           _loc1_.push(_loc2_);
                        }
                     }
                  }
               }
            }
         }
         if(_loc1_.length > 0)
         {
            if(this._petHeadCheckRetries >= MAX_PET_HEAD_CHECK_RETRIES)
            {
               Log.warning("PvPAgilityBarManager","checkPendingPetHead","Max retries (" + MAX_PET_HEAD_CHECK_RETRIES + ") reached. Proceeding with setup despite " + _loc1_.length + " pending pet head(s): " + _loc1_.join(", "));
               this.setupComplete();
               return;
            }
            ++this._petHeadCheckRetries;
            Log.debug("PvPAgilityBarManager","checkPendingPetHead","Waiting for " + _loc1_.length + " pet head(s) to load: " + _loc1_.join(", ") + " (retry " + this._petHeadCheckRetries + "/" + MAX_PET_HEAD_CHECK_RETRIES + ")");
            this._petHeadCheckTimeoutId = setTimeout(this.checkPendingPetHead,100);
            return;
         }
         Log.debug("PvPAgilityBarManager","checkPendingPetHead","All pet heads loaded, proceeding with setup");
         this.setupComplete();
      }
      
      private function setupComplete() : void
      {
         var _loc1_:Object = null;
         Log.debug("PvPAgilityBarManager","setupComplete","Setup complete");
         this.setupHeadsAndAgility();
         this.registerSocketEvents();
         this._setupCompleted = true;
         if(this._pendingStartAttackBarData != null)
         {
            _loc1_ = this._pendingStartAttackBarData;
            this._pendingStartAttackBarData = null;
            this.onStartAttackBar(_loc1_);
         }
      }
      
      private function registerSocketEvents() : void
      {
         if(this._socketEventsRegistered)
         {
            return;
         }
         this._socketEventsRegistered = true;
         var _loc1_:PvPSocket = PvPSocket.getInstance();
         _loc1_.off("Battle.startAttackBar",this.onStartAttackBar);
         _loc1_.on("Battle.startAttackBar",this.onStartAttackBar);
      }
      
      private function unregisterSocketEvents() : void
      {
         this._socketEventsRegistered = false;
         PvPSocket.getInstance().off("Battle.startAttackBar",this.onStartAttackBar);
      }
      
      public function setupHeadsAndAgility() : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc4_:CharacterManager = null;
         var _loc5_:PetManager = null;
         var _loc6_:* = undefined;
         var _loc7_:Boolean = false;
         var _loc8_:MovieClip = null;
         var _loc9_:Boolean = false;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         if(this._petHeadCheckTimeoutId > 0)
         {
            clearTimeout(this._petHeadCheckTimeoutId);
            this._petHeadCheckTimeoutId = 0;
         }
         var _loc1_:int = 0;
         for(_loc2_ in this._playersMcHolders)
         {
            _loc3_ = this._playersMcHolders[_loc2_] as MovieClip;
            if(_loc3_)
            {
               _loc4_ = this.getCharacterManager(_loc3_);
               _loc5_ = this.getPetManager(_loc3_);
               _loc6_ = null;
               _loc7_ = false;
               if(_loc5_)
               {
                  _loc6_ = _loc5_;
                  _loc7_ = true;
               }
               else if(_loc4_)
               {
                  _loc6_ = _loc4_;
                  _loc7_ = false;
               }
               if(_loc6_)
               {
                  _loc8_ = null;
                  if(_loc7_)
                  {
                     _loc13_ = _loc5_.getPetModel();
                     if(_loc13_)
                     {
                        _loc8_ = _loc13_.getHead();
                     }
                  }
                  else
                  {
                     _loc14_ = _loc4_.getCharacterModel();
                     if(_loc14_)
                     {
                        _loc8_ = _loc14_.getHead();
                     }
                  }
                  if(_loc8_)
                  {
                     _loc9_ = _loc2_.indexOf(TEAM_PLAYER) >= 0;
                     _loc10_ = _loc7_ ? _loc5_.getPetModel() : _loc4_.getCharacterModel();
                     this.configureHead(_loc8_,_loc10_,_loc9_);
                     _loc11_ = int(_loc6_.getAgility());
                     if(_loc11_ > _loc1_)
                     {
                        _loc1_ = _loc11_;
                     }
                     _loc12_ = _loc6_.getPlayerTeam();
                     if(_loc7_ && _loc12_.indexOf("pet") == -1)
                     {
                        _loc12_ += "_pet";
                     }
                     this._teamHeadMcAgility.push({
                        "team":_loc12_,
                        "num":_loc6_.getPlayerNumber(),
                        "id":_loc6_.getID(),
                        "agility":_loc11_,
                        "headMc":_loc8_,
                        "x":_loc8_.x,
                        "startX":_loc8_.x,
                        "visualX":_loc8_.x,
                        "isDead":false,
                        "isPet":_loc7_
                     });
                  }
               }
            }
         }
         this.addHeadsToActionBar();
      }
      
      private function getCharacterManager(param1:MovieClip) : CharacterManager
      {
         var _loc2_:* = int(param1.name.split("_")[1]);
         if(param1.name.indexOf("charMc_") >= 0)
         {
            return PvPBattleManager.CHARACTER_MANAGERS["player"][_loc2_];
         }
         if(param1.name.indexOf("enemyMc_") >= 0)
         {
            return PvPBattleManager.CHARACTER_MANAGERS["enemy"][_loc2_];
         }
         return null;
      }
      
      private function getPetManager(param1:MovieClip) : PetManager
      {
         var _loc2_:* = int(param1.name.split("_")[1]);
         if(param1.name.indexOf("charPetMc_") >= 0)
         {
            return PvPBattleManager.PET_MANAGERS["player_pet"][_loc2_];
         }
         if(param1.name.indexOf("enemyPetMc_") >= 0)
         {
            return PvPBattleManager.PET_MANAGERS["enemy_pet"][_loc2_];
         }
         return null;
      }
      
      private function configureHead(param1:MovieClip, param2:*, param3:Boolean) : void
      {
         param1.x = 0;
         param1.y = param3 ? HEAD_Y_PLAYER : HEAD_Y_ENEMY;
         param1.scaleX = param2.isCharacter() ? HEAD_SCALE : -HEAD_SCALE;
         param1.scaleY = HEAD_SCALE;
      }
      
      private function addHeadsToActionBar() : void
      {
         var _loc3_:MovieClip = null;
         if(!this._actionBar || !this._actionBar.hasOwnProperty("holder"))
         {
            return;
         }
         var _loc1_:Sprite = this._actionBar.holder as Sprite;
         var _loc2_:* = int(this._teamHeadMcAgility.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this._teamHeadMcAgility[_loc2_].headMc as MovieClip;
            if(Boolean(_loc3_) && _loc3_.parent != _loc1_)
            {
               if(_loc3_.parent)
               {
                  _loc3_.parent.removeChild(_loc3_);
               }
               _loc1_.addChild(_loc3_);
            }
            _loc2_--;
         }
      }
      
      public function startRun(param1:int = 0, param2:* = null) : void
      {
         var token:uint = 0;
         var animation:* = undefined;
         var delayMs:int = param1;
         var data:* = param2;
         if(this._timeoutId > 0)
         {
            clearTimeout(this._timeoutId);
            this._timeoutId = 0;
         }
         if(delayMs > 0)
         {
            token = ++this._startRunToken;
            this._timeoutId = setTimeout(this.startRunIfCurrent,delayMs,token,data);
            return;
         }
         if(!PvPBattleManager.BATTLE_VARS.matchRunning || this._destroyed)
         {
            Log.debug("PvPAgilityBarManager","startRun","Match not running or destroyed, aborting");
            return;
         }
         if(this._isRunning)
         {
            return;
         }
         if(this._turns == 0 && !PvPBattleManager.getIsSpectator())
         {
            animation = new Animation(this._battle,true);
            animation.addFrameScript(animation.totalFrames - 1,function():void
            {
               animation.destroy();
               PvPBattleManager.getMain().loader.removeChild(animation);
               animation.addFrameScript(animation.totalFrames - 1,null);
               run(data);
               visibleEntities();
            });
            PvPBattleManager.getMain().loader.addChild(animation);
            animation.gotoAndPlay(1);
         }
         else
         {
            if(this._turns == 0)
            {
               this.visibleEntities();
            }
            this.run(data);
         }
      }
      
      private function startRunIfCurrent(param1:uint, param2:* = null) : void
      {
         this._timeoutId = 0;
         if(param1 != this._startRunToken)
         {
            return;
         }
         this.startRun(0,param2);
      }
      
      public function visibleEntities() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this._entitiesVisible)
         {
            return;
         }
         var _loc1_:Array = ["player","enemy","player_pet","enemy_pet"];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = _loc3_ == "player" ? PvPBattleManager.CHARACTER_MANAGERS["player"] : (_loc3_ == "enemy" ? PvPBattleManager.CHARACTER_MANAGERS["enemy"] : (_loc3_ == "player_pet" ? PvPBattleManager.PET_MANAGERS["player_pet"] : PvPBattleManager.PET_MANAGERS["enemy_pet"]));
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc7_ = this._battle.getObjectHolder(_loc6_.getPlayerTeam(),_loc6_.getPlayerNumber());
               if(_loc7_)
               {
                  _loc7_.alpha = 0;
                  _loc7_.visible = true;
                  TweenLite.to(_loc7_,1.5,{"alpha":1});
               }
               _loc5_++;
            }
            _loc2_++;
         }
         this._actionBar.visible = true;
         this._actionBar.alpha = 0;
         TweenLite.to(this._actionBar,1.5,{"alpha":1});
         this._entitiesVisible = true;
      }
      
      public function run(param1:* = null) : *
      {
         ++this._turns;
         this._isRunning = true;
         this.updateAgilityToActionBar();
         this.renderServerFrame();
      }
      
      public function updateAgilityToActionBar() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:Sprite = null;
         var _loc10_:* = 0;
         var _loc11_:MovieClip = null;
         var _loc1_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this._teamHeadMcAgility.length)
         {
            _loc6_ = this._teamHeadMcAgility[_loc5_].team as String;
            _loc7_ = this._teamHeadMcAgility[_loc5_].num as int;
            if(_loc6_.indexOf("pet") >= 0)
            {
               _loc3_ = PvPBattleManager.PET_MANAGERS[_loc6_][_loc7_];
               _loc8_ = _loc3_;
            }
            else
            {
               _loc2_ = PvPBattleManager.CHARACTER_MANAGERS[_loc6_][_loc7_];
               _loc8_ = _loc2_;
            }
            if(_loc8_)
            {
               _loc4_ = int(_loc8_.getAgility());
               this._teamHeadMcAgility[_loc5_].agility = _loc4_;
               if(_loc4_ > _loc1_)
               {
                  _loc1_ = _loc4_;
               }
            }
            _loc5_++;
         }
         this._teamHeadMcAgility.sort(this.sortAgilityHeads);
         if(Boolean(this._actionBar) && this._actionBar.hasOwnProperty("holder"))
         {
            _loc9_ = this._actionBar.holder as Sprite;
            _loc10_ = int(this._teamHeadMcAgility.length - 1);
            while(_loc10_ >= 0)
            {
               _loc11_ = this._teamHeadMcAgility[_loc10_].headMc as MovieClip;
               if((Boolean(_loc11_)) && _loc11_.parent == _loc9_)
               {
                  _loc9_.setChildIndex(_loc11_,_loc9_.numChildren - 1);
               }
               _loc10_--;
            }
         }
         this._toRepeatNumber = Math.floor(_loc1_ / ACTION_BAR_DIVIDER);
      }
      
      private function renderServerFrame() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc1_:int = -1;
         var _loc5_:int = -1;
         var _loc6_:Number = -1;
         _loc2_ = 0;
         while(_loc2_ < this._teamHeadMcAgility.length)
         {
            _loc3_ = this._teamHeadMcAgility[_loc2_];
            if(_loc3_ != null)
            {
               _loc4_ = this._serverFrame[String(_loc3_.id)];
               if(_loc4_ != null)
               {
                  _loc7_ = Number(_loc4_.p || 0);
                  if(_loc7_ < 0)
                  {
                     _loc7_ = 0;
                  }
                  _loc3_.x = _loc7_;
                  _loc3_.visualX = Math.min(_loc7_,ACTION_BAR_WIDTH);
                  _loc8_ = this._authoritativeWinnerId != "" && this.isSameEntity(this._authoritativeWinnerId,_loc3_.id);
                  if(_loc8_)
                  {
                     _loc1_ = _loc2_;
                  }
                  if(_loc7_ > _loc6_)
                  {
                     _loc6_ = _loc7_;
                     _loc5_ = _loc2_;
                  }
               }
            }
            _loc2_++;
         }
         if(_loc1_ < 0)
         {
            if(_loc5_ < 0)
            {
               Log.warning("PvPAgilityBarManager","renderServerFrame","Winner id " + this._authoritativeWinnerId + " not found among heads and no fallback available; waiting for server ACK timeout");
               this.stop();
               return;
            }
            Log.warning("PvPAgilityBarManager","renderServerFrame","Winner id " + this._authoritativeWinnerId + " not found among heads; falling back to local max-p winner index " + _loc5_);
            _loc1_ = _loc5_;
         }
         this.triggerAmbushAnimation(_loc1_,[]);
      }
      
      public function checkAmbush() : void
      {
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Number = this.prepareAmbushState(_loc1_,_loc2_,_loc3_);
         if(_loc4_ == Number.MAX_VALUE)
         {
            this.stop();
            return;
         }
         var _loc5_:int = this.applyAmbushMovement(_loc4_,_loc1_,_loc2_);
         if(_loc5_ >= 0)
         {
            this.triggerAmbushAnimation(_loc5_,_loc3_);
         }
      }
      
      private function prepareAmbushState(param1:Array, param2:Array, param3:Array) : Number
      {
         var _loc6_:Object = null;
         var _loc7_:* = undefined;
         var _loc8_:String = null;
         var _loc9_:MovieClip = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc4_:Number = Number.MAX_VALUE;
         var _loc5_:int = 0;
         while(_loc5_ < this._teamHeadMcAgility.length)
         {
            _loc6_ = this._teamHeadMcAgility[_loc5_];
            _loc7_ = this.getManagerForEntry(_loc6_);
            if(_loc7_)
            {
               _loc8_ = String(_loc7_.getID());
               _loc9_ = _loc6_.headMc as MovieClip;
               this.resetAmbushStateForEntry(_loc6_,_loc8_,_loc9_);
               param3.push("Idx:" + _loc5_ + " ID:" + _loc6_.id + " isPet:" + _loc6_.isPet + " Agi:" + _loc6_.agility);
               if(_loc7_.isDead())
               {
                  this.clearAmbushStateForEntry(_loc6_,_loc8_,_loc9_);
               }
               else
               {
                  _loc10_ = this.getAmbushSpeed(Number(_loc6_.agility));
                  if(_loc10_ > 0)
                  {
                     _loc11_ = Number(_loc6_.x);
                     param1[_loc5_] = _loc11_;
                     param2[_loc5_] = _loc10_;
                     _loc12_ = ACTION_BAR_WIDTH - _loc11_;
                     _loc13_ = _loc12_ <= 0 ? 1 : Math.ceil(_loc12_ / _loc10_);
                     if(_loc13_ < _loc4_)
                     {
                        _loc4_ = _loc13_;
                     }
                  }
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function resetAmbushStateForEntry(param1:Object, param2:String, param3:MovieClip) : void
      {
         if(this._lastAmbushKey != param2)
         {
            return;
         }
         this._lastAmbushKey = "";
         var _loc4_:Number = this._plusXNextRound[param2] != null ? Number(this._plusXNextRound[param2]) : 0;
         param1.x = _loc4_;
         if(param3)
         {
            param3.x = _loc4_;
         }
         delete this._plusXNextRound[param2];
      }
      
      private function clearAmbushStateForEntry(param1:Object, param2:String, param3:MovieClip) : void
      {
         param1.x = 0;
         if(param3)
         {
            param3.x = 0;
         }
         delete this._plusXNextRound[param2];
      }
      
      private function getAmbushSpeed(param1:Number) : Number
      {
         var _loc2_:Number = param1;
         if(this._toRepeatNumber > 2)
         {
            if(this._calcType == "Integer")
            {
               _loc2_ = Math.floor(param1 / this._toRepeatNumber);
            }
            else
            {
               _loc2_ = Number(Number(param1 / this._toRepeatNumber).toFixed(1));
            }
         }
         return _loc2_;
      }
      
      private function applyAmbushMovement(param1:Number, param2:Array, param3:Array) : int
      {
         var _loc7_:Object = null;
         var _loc8_:* = undefined;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:Object = null;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc4_:int = -1;
         var _loc5_:Number = -1;
         var _loc6_:int = 0;
         while(_loc6_ < this._teamHeadMcAgility.length)
         {
            _loc7_ = this._teamHeadMcAgility[_loc6_];
            _loc8_ = this.getManagerForEntry(_loc7_);
            if(_loc8_)
            {
               _loc9_ = String(_loc8_.getID());
               if(_loc8_.isDead())
               {
                  this.clearAmbushStateForEntry(_loc7_,_loc9_,_loc7_.headMc as MovieClip);
               }
               else if(param3[_loc6_] != null)
               {
                  _loc10_ = Number(param2[_loc6_]) + param1 * Number(param3[_loc6_]);
                  if(_loc10_ >= ACTION_BAR_WIDTH)
                  {
                     if(_loc4_ < 0)
                     {
                        _loc4_ = _loc6_;
                        _loc5_ = _loc10_;
                     }
                     else
                     {
                        _loc11_ = this._teamHeadMcAgility[_loc4_];
                        if(this.compareAmbushCandidates(_loc7_,_loc11_,_loc10_,_loc5_) < 0)
                        {
                           _loc4_ = _loc6_;
                           _loc5_ = _loc10_;
                        }
                     }
                     this._plusXNextRound[_loc9_] = _loc10_ - ACTION_BAR_WIDTH;
                     _loc7_.x = ACTION_BAR_WIDTH;
                  }
                  else
                  {
                     _loc7_.x = _loc10_;
                  }
               }
            }
            _loc6_++;
         }
         if(_loc4_ >= 0)
         {
            _loc4_ = this.resolveAuthoritativeAmbushIndex(_loc4_,param2,param3,param1);
            _loc6_ = 0;
            while(_loc6_ < this._teamHeadMcAgility.length)
            {
               if(_loc6_ != _loc4_)
               {
                  _loc7_ = this._teamHeadMcAgility[_loc6_];
                  _loc8_ = this.getManagerForEntry(_loc7_);
                  if(!(!_loc8_ || Boolean(_loc8_.isDead())))
                  {
                     _loc12_ = Number(param2[_loc6_]) + param1 * Number(param3[_loc6_]);
                     if(_loc12_ >= ACTION_BAR_WIDTH)
                     {
                        _loc13_ = String(_loc8_.getID());
                        delete this._plusXNextRound[_loc13_];
                        _loc14_ = _loc7_.headMc ? Number(_loc7_.headMc.x) : Number(param2[_loc6_]);
                        _loc7_.x = _loc14_ > NON_WINNER_FINISH_X && _loc14_ < ACTION_BAR_WIDTH ? _loc14_ : NON_WINNER_FINISH_X;
                     }
                  }
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      private function resolveAuthoritativeAmbushIndex(param1:int, param2:Array, param3:Array, param4:Number) : int
      {
         var _loc6_:Object = null;
         var _loc7_:* = undefined;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         if(this._authoritativeWinnerId == "")
         {
            return param1;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._teamHeadMcAgility.length)
         {
            _loc6_ = this._teamHeadMcAgility[_loc5_];
            if(!(_loc6_ == null || String(_loc6_.id) != this._authoritativeWinnerId))
            {
               _loc7_ = this.getManagerForEntry(_loc6_);
               if(Boolean(!_loc7_) || Boolean(_loc7_.isDead()) || param3[_loc5_] == null)
               {
                  return param1;
               }
               _loc8_ = String(_loc7_.getID());
               _loc9_ = Number(param2[_loc5_]) + param4 * Number(param3[_loc5_]);
               this._plusXNextRound[_loc8_] = Math.max(_loc9_ - ACTION_BAR_WIDTH,0);
               _loc6_.x = ACTION_BAR_WIDTH;
               return _loc5_;
            }
            _loc5_++;
         }
         Log.warning("PvPAgilityBarManager","resolveAuthoritativeAmbushIndex","Server winner " + this._authoritativeWinnerId + " not found among heads; falling back to local winner");
         return param1;
      }
      
      private function compareAmbushCandidates(param1:Object, param2:Object, param3:Number, param4:Number) : int
      {
         if(param3 != param4)
         {
            return param4 - param3;
         }
         var _loc5_:int = this.getTeamPriority(param1.team as String);
         var _loc6_:int = this.getTeamPriority(param2.team as String);
         if(_loc5_ != _loc6_)
         {
            return _loc5_ - _loc6_;
         }
         if(param1.isPet != param2.isPet)
         {
            return param1.isPet ? 1 : -1;
         }
         var _loc7_:int = int(String(param1.id).replace("_pet",""));
         var _loc8_:int = int(String(param2.id).replace("_pet",""));
         if(_loc7_ != _loc8_)
         {
            return _loc7_ - _loc8_;
         }
         return int(param1.num) - int(param2.num);
      }
      
      private function getTeamPriority(param1:String) : int
      {
         switch(param1)
         {
            case TEAM_PLAYER:
               return 0;
            case TEAM_ENEMY:
               return 1;
            case "player_pet":
               return 2;
            case "enemy_pet":
               return 3;
            default:
               return 4;
         }
      }
      
      private function triggerAmbushAnimation(param1:int, param2:Array) : void
      {
         var _loc5_:Sprite = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:Object = null;
         this.stop();
         this._animationRunning = true;
         var _loc3_:Object = this._teamHeadMcAgility[param1];
         this._lastAmbushKey = String(_loc3_.id);
         this._ambushTeam = String(_loc3_.team);
         this._ambushNum = int(_loc3_.num);
         Log.debug("PvPAgilityBarManager","triggerAmbushAnimation","Ambush WON by Index:" + param1 + " ServerWinner:" + this._authoritativeWinnerId + " RawHeadId:" + _loc3_.id + " Team:" + this._ambushTeam + " NewX:" + _loc3_.x + " LastAmbushKey Set To:" + this._lastAmbushKey);
         if(Boolean(_loc3_.headMc) && Boolean(this._actionBar) && this._actionBar.hasOwnProperty("holder"))
         {
            _loc5_ = this._actionBar.holder as Sprite;
            if(_loc3_.headMc.parent == _loc5_)
            {
               _loc5_.setChildIndex(_loc3_.headMc,_loc5_.numChildren - 1);
            }
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._teamHeadMcAgility.length)
         {
            _loc6_ = this._teamHeadMcAgility[_loc4_];
            _loc7_ = _loc6_.headMc as MovieClip;
            if(!(!_loc7_ || Boolean(_loc6_.isDead)))
            {
               TweenLite.killTweensOf(_loc7_);
               _loc7_.x = Number(_loc6_.startX || 0);
               _loc8_ = {
                  "x":Number(_loc6_.visualX || 0),
                  "ease":Linear.easeNone
               };
               if(_loc4_ == param1)
               {
                  _loc8_.onComplete = this.onAmbush;
                  _loc8_.onCompleteParams = [_loc7_];
               }
               TweenLite.to(_loc7_,0.8,_loc8_);
            }
            _loc4_++;
         }
      }
      
      public function onAmbush(param1:MovieClip) : void
      {
         var _loc3_:Object = null;
         TweenLite.killTweensOf(param1);
         Log.debug("PvPAgilityBarManager","onAmbush","Ambush triggered by " + this._ambushTeam + "_" + this._ambushNum);
         var _loc2_:* = this.getManagerByTeamAndNum(this._ambushTeam,this._ambushNum);
         if(!_loc2_)
         {
            Log.error("PvPAgilityBarManager","onAmbush","Manager not found for " + this._ambushTeam + "_" + this._ambushNum);
            return;
         }
         PvPSocket.getInstance().emit("Battle.ambush",{
            "battle_id":PvPBattleManager.getBattleID(),
            "team":this._ambushTeam,
            "num":this._ambushNum,
            "char_id":_loc2_.getID(),
            "id":_loc2_.getID(),
            "x":this.getPlayerPositions()
         });
         this._animationRunning = false;
         if(this._pendingStartAttackBarData != null)
         {
            _loc3_ = this._pendingStartAttackBarData;
            this._pendingStartAttackBarData = null;
            this.onStartAttackBar(_loc3_);
         }
      }
      
      private function getPlayerPositions() : Array
      {
         var _loc3_:Object = null;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this._teamHeadMcAgility.length)
         {
            _loc3_ = this._teamHeadMcAgility[_loc2_];
            _loc1_.push({
               "team":_loc3_.team,
               "num":_loc3_.num,
               "id":_loc3_.id,
               "x":_loc3_.x
            });
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function getManagerForEntry(param1:Object) : *
      {
         return this.getManagerByTeamAndNum(param1.team as String,int(param1.num));
      }
      
      private function getManagerByTeamAndNum(param1:String, param2:int) : *
      {
         var _loc3_:String = null;
         if(param1.indexOf("pet") >= 0)
         {
            if(PvPBattleManager.PET_MANAGERS[param1])
            {
               return PvPBattleManager.PET_MANAGERS[param1][param2];
            }
            _loc3_ = param1.replace("_pet","");
            return PvPBattleManager.PET_MANAGERS[_loc3_] ? PvPBattleManager.PET_MANAGERS[_loc3_][param2] : null;
         }
         return PvPBattleManager.CHARACTER_MANAGERS[param1] ? PvPBattleManager.CHARACTER_MANAGERS[param1][param2] : null;
      }
      
      private function isSameEntity(param1:*, param2:*) : Boolean
      {
         var _loc3_:String = String(param1);
         var _loc4_:String = String(param2);
         var _loc5_:String = _loc3_.replace("_pet","").replace(/[^0-9]/g,"");
         var _loc6_:String = _loc4_.replace("_pet","").replace(/[^0-9]/g,"");
         if(_loc5_ == "" || _loc5_ != _loc6_)
         {
            return false;
         }
         var _loc7_:Boolean = _loc3_.indexOf("_pet") >= 0;
         var _loc8_:Boolean = _loc4_.indexOf("_pet") >= 0;
         return _loc7_ == _loc8_;
      }
      
      private function findHeadDataByServerId(param1:String, param2:Object) : Object
      {
         var _loc4_:String = null;
         var _loc3_:Object = param2[param1];
         if(_loc3_)
         {
            return _loc3_;
         }
         for(_loc4_ in param2)
         {
            if(this.isSameEntity(_loc4_,param1))
            {
               return param2[_loc4_];
            }
         }
         return null;
      }
      
      public function stop() : void
      {
         this._isRunning = false;
         this._enableActions = false;
         if(this._timeoutId > 0)
         {
            clearTimeout(this._timeoutId);
            this._timeoutId = 0;
         }
      }
      
      public function get isRunning() : Boolean
      {
         return this._isRunning;
      }
      
      public function get enableActions() : Boolean
      {
         return this._enableActions;
      }
      
      public function set enableActions(param1:Boolean) : void
      {
         this._enableActions = param1;
      }
      
      public function get turns() : int
      {
         return this._turns;
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:MovieClip = null;
         if(this._destroyed)
         {
            return;
         }
         this._destroyed = true;
         ++this._startRunToken;
         this.stop();
         if(this._petHeadCheckTimeoutId > 0)
         {
            clearTimeout(this._petHeadCheckTimeoutId);
            this._petHeadCheckTimeoutId = 0;
         }
         this.unregisterSocketEvents();
         this._sortIndices = {};
         this._entitiesVisible = false;
         this._battleReady = false;
         if(Boolean(this._actionBar) && this._actionBar.hasOwnProperty("holder"))
         {
            _loc1_ = this._actionBar.holder;
            if(_loc1_)
            {
               _loc2_ = 0;
               while(_loc2_ < this._teamHeadMcAgility.length)
               {
                  _loc3_ = this._teamHeadMcAgility[_loc2_];
                  if(Boolean(_loc3_) && Boolean(_loc3_.headMc))
                  {
                     _loc4_ = _loc3_.headMc as MovieClip;
                     if(_loc4_)
                     {
                        TweenLite.killTweensOf(_loc4_);
                        if(_loc4_.parent == _loc1_)
                        {
                           _loc1_.removeChild(_loc4_);
                        }
                     }
                     _loc3_.headMc = null;
                  }
                  _loc2_++;
               }
               GF.removeAllChild(_loc1_);
            }
         }
         if(this._teamHeadMcAgility)
         {
            _loc2_ = 0;
            while(_loc2_ < this._teamHeadMcAgility.length)
            {
               this._teamHeadMcAgility[_loc2_] = null;
               _loc2_++;
            }
            this._teamHeadMcAgility = [];
         }
         this._playersMcHolders = null;
         this._actionBar = null;
         this._battle = null;
      }
   }
}

