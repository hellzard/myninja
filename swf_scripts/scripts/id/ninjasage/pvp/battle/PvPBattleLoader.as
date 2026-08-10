package id.ninjasage.pvp.battle
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.Battle;
   import id.ninjasage.multiplayer.battle.CharacterManager;
   import id.ninjasage.multiplayer.battle.CharacterModel;
   import id.ninjasage.multiplayer.battle.PetManager;
   import id.ninjasage.multiplayer.battle.PetModel;
   import id.ninjasage.pvp.PvPSocket;
   
   public class PvPBattleLoader
   {
      
      private static const BG_LINKAGE:String = "BattleBG";
      
      private static const MAX_TEAM_SIZE:int = 3;
      
      private static const UI_ELEMENTS_TO_HIDE:Array = ["char_hpcp","atbBar","effectLogMC","atk_turnTimerTxt","btn_openLog"];
      
      private static const ACTION_BAR_ELEMENTS:Array = ["enemyMcInfo_0","enemyMcInfo_1","enemyMcInfo_2","btn_senjutsu","btn_ninjutsu"];
      
      private static const CHARACTER_PREFIXES:Array = ["charMc_","charPetMc_","enemyMc_","enemyPetMc_","scrollDisplayMc_"];
      
      private var _backgroundMC:MovieClip;
      
      private var _battle:Battle;
      
      private var _main:*;
      
      private var _destroyed:Boolean = false;
      
      private var _loadTarget:IEventDispatcher;
      
      private var _backgroundLoaded:Boolean = false;
      
      private var _charactersLoaded:Boolean = false;
      
      private var _effectTooltip:PvPEffectTooltip;
      
      public var berserk:Boolean = false;
      
      public function PvPBattleLoader(param1:Battle, param2:*)
      {
         super();
         this._battle = param1;
         this._main = param2;
      }
      
      public function loadPlayer() : *
      {
         PvPSocket.getInstance().on("Battle.getPlayerInfo",this.onPlayerInfo);
         PvPSocket.getInstance().emit("Battle.getPlayerInfo",{
            "battle_id":PvPBattleManager.getBattleID(),
            "char_id":PvPBattleManager.getPlayerTeam()[0]
         });
      }
      
      public function onPlayerInfo(param1:Object) : void
      {
         var _loc7_:PetManager = null;
         var _loc8_:PetModel = null;
         Log.info(this,"onPlayerInfo",JSON.stringify(param1));
         PvPSocket.getInstance().off("Battle.getPlayerInfo",this.onPlayerInfo);
         var _loc2_:* = "player";
         var _loc3_:* = 0;
         var _loc4_:CharacterManager = new CharacterManager(param1);
         PvPBattleManager.addCharacterManager(_loc2_,_loc3_,_loc4_);
         var _loc5_:CharacterModel = new CharacterModel(_loc2_,_loc3_);
         var _loc6_:PvPActionManager = new PvPActionManager(_loc2_,_loc3_,param1.id);
         _loc5_.setup(_loc4_,this._battle);
         _loc4_.setModel(_loc5_);
         _loc4_.setActionManager(_loc6_);
         if(Boolean(param1.set.hasOwnProperty("char_pet")) && Boolean(param1.set.char_pet != null) && Boolean(param1.set.char_pet.hasOwnProperty("pet")))
         {
            _loc2_ = "player_pet";
            param1.set.char_pet.stat = param1.pet;
            _loc7_ = new PetManager(param1.set.char_pet);
            _loc8_ = new PetModel(_loc2_,_loc3_);
            PvPBattleManager.addPetManager(_loc2_,_loc3_,_loc7_);
            _loc8_.setup(_loc7_,this._battle);
            _loc7_.setPetModel(_loc8_);
         }
         this.setupOwnEffectTooltip();
         this.loadEnemy();
      }
      
      private function setupOwnEffectTooltip() : void
      {
         if(PvPBattleManager.getIsSpectator() || this._destroyed || !this._battle)
         {
            return;
         }
         var _loc1_:* = this._battle["charMc_0"];
         if(Boolean(_loc1_) && Boolean(_loc1_.hasOwnProperty("btn_info")) && Boolean(_loc1_.btn_info))
         {
            this._effectTooltip = new PvPEffectTooltip(_loc1_.btn_info);
            _loc1_.btn_info.visible = true;
         }
      }
      
      public function loadEnemy() : *
      {
         PvPSocket.getInstance().on("Battle.getPlayerInfo",this.onEnemyInfo);
         PvPSocket.getInstance().emit("Battle.getPlayerInfo",{
            "battle_id":PvPBattleManager.getBattleID(),
            "char_id":PvPBattleManager.getEnemyTeam()[0]
         });
      }
      
      public function onEnemyInfo(param1:Object) : void
      {
         var _loc7_:PetManager = null;
         var _loc8_:PetModel = null;
         Log.info(this,"onEnemyInfo",JSON.stringify(param1));
         PvPSocket.getInstance().off("Battle.getPlayerInfo",this.onEnemyInfo);
         var _loc2_:* = "enemy";
         var _loc3_:* = 0;
         var _loc4_:CharacterManager = new CharacterManager(param1);
         PvPBattleManager.addCharacterManager(_loc2_,_loc3_,_loc4_);
         var _loc5_:CharacterModel = new CharacterModel(_loc2_,_loc3_);
         var _loc6_:PvPActionManager = new PvPActionManager(_loc2_,_loc3_,param1.id);
         _loc5_.setup(_loc4_,this._battle);
         _loc4_.setModel(_loc5_);
         _loc4_.setActionManager(_loc6_);
         if(Boolean(param1.set.hasOwnProperty("char_pet")) && Boolean(param1.set.char_pet != null) && Boolean(param1.set.char_pet.hasOwnProperty("pet")))
         {
            _loc2_ = "enemy_pet";
            param1.set.char_pet.stat = param1.pet;
            _loc7_ = new PetManager(param1.set.char_pet);
            _loc8_ = new PetModel(_loc2_,_loc3_);
            PvPBattleManager.addPetManager(_loc2_,_loc3_,_loc7_);
            _loc8_.setup(_loc7_,this._battle);
            _loc7_.setPetModel(_loc8_);
         }
         PvPBattleManager.AGILITY_BAR_MANAGER.setup();
         PvPBattleManager.BATTLE_HANDLER.setup();
         this._charactersLoaded = true;
         this.checkBattleReady();
      }
      
      private function checkBattleReady() : void
      {
         var _loc1_:PvPAgilityBarManager = null;
         if(this._backgroundLoaded && this._charactersLoaded)
         {
            _loc1_ = PvPBattleManager.AGILITY_BAR_MANAGER;
            if(_loc1_)
            {
               _loc1_.setBattleReady(true);
            }
         }
      }
      
      public function loadBackground(param1:String = null) : void
      {
         if(this.berserk)
         {
            Log.warning("PvPBattleLoader","loadBackground","Berserk mode, skipping background load");
            this._backgroundLoaded = true;
            this.checkBattleReady();
            return;
         }
         if(this._destroyed)
         {
            Log.warning("PvPBattleLoader","loadBackground","Loader is destroyed");
            return;
         }
         var _loc2_:String = param1 || PvPBattleManager.getBackground();
         if(!_loc2_ || _loc2_.length == 0)
         {
            Log.warning("PvPBattleLoader","loadBackground","No background ID specified");
            this._backgroundLoaded = true;
            this.checkBattleReady();
            return;
         }
         this.removeLoadListener();
         this._main.loadSwf("mission",_loc2_,this.handleBackgroundLoad);
      }
      
      private function removeLoadListener() : void
      {
         if(this._loadTarget)
         {
            try
            {
               this._loadTarget.removeEventListener(Event.COMPLETE,this.handleBackgroundLoad);
            }
            catch(e:Error)
            {
            }
            this._loadTarget = null;
         }
      }
      
      private function handleBackgroundLoad(param1:Event) : void
      {
         if(this._destroyed)
         {
            return;
         }
         this._loadTarget = param1.target as IEventDispatcher;
         if(this._loadTarget)
         {
            this._loadTarget.removeEventListener(Event.COMPLETE,this.handleBackgroundLoad);
         }
         this.clearLoadedBackground();
         if(!param1.target || !param1.target.content)
         {
            Log.error("PvPBattleLoader","handleBackgroundLoad","Invalid load event target");
            this._loadTarget = null;
            this._backgroundLoaded = true;
            this.checkBattleReady();
            return;
         }
         this._backgroundMC = param1.target.content[BG_LINKAGE];
         if(!this._backgroundMC)
         {
            Log.warning("PvPBattleLoader","handleBackgroundLoad","Background MC not found: " + BG_LINKAGE);
            this._loadTarget = null;
            this._backgroundLoaded = true;
            this.checkBattleReady();
            return;
         }
         this._backgroundMC.gotoAndStop(1);
         this._backgroundMC.width += 100;
         if(Boolean(this._battle) && Boolean(this._battle.bgHolder))
         {
            this._battle.bgHolder.addChild(this._backgroundMC);
         }
         if(param1.target.loader)
         {
            param1.target.loader.unloadAndStop(true);
         }
         this._loadTarget = null;
         this._backgroundLoaded = true;
         this.checkBattleReady();
      }
      
      public function clearLoadedBackground() : void
      {
         if(this._backgroundMC)
         {
            if(Boolean(this._battle) && Boolean(this._battle.bgHolder) && this._backgroundMC.parent == this._battle.bgHolder)
            {
               this._battle.bgHolder.removeChild(this._backgroundMC);
            }
            else if(this._backgroundMC.parent)
            {
               this._backgroundMC.parent.removeChild(this._backgroundMC);
            }
            this._backgroundMC.cacheAsBitmap = false;
            GF.removeAllChild(this._backgroundMC);
            this._backgroundMC = null;
            Log.debug("PvPBattleLoader","clearLoadedBackground","Background destroyed");
         }
      }
      
      public function hideEverything() : void
      {
         var isSpectator:Boolean;
         var senjutsuTransition:* = undefined;
         var charHpcp:MovieClip = null;
         if(!this._battle || this._destroyed)
         {
            return;
         }
         isSpectator = PvPBattleManager.getIsSpectator();
         this.hideUIElements(isSpectator);
         this.hideActionBarElements();
         this.hideCharacterElements();
         this.disableSenjutsuButton();
         if(isSpectator && this._battle.hasOwnProperty("char_hpcp"))
         {
            charHpcp = this._battle.char_hpcp as MovieClip;
            if(charHpcp)
            {
               charHpcp.visible = false;
            }
         }
         senjutsuTransition = PvPBattleManager.getBattle().senjutsuTransition;
         senjutsuTransition.addFrameScript(senjutsuTransition.totalFrames - 1,function():*
         {
            senjutsuTransition.gotoAndStop(1);
         });
      }
      
      public function disableSenjutsuButton() : void
      {
         if(!this._battle || this._destroyed)
         {
            return;
         }
         PvPBattleManager.getMain().initButtonDisable(this._battle["char_hpcp"]["btn_activate_senjutsu"],null);
      }
      
      private function hideUIElements(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         for each(_loc2_ in UI_ELEMENTS_TO_HIDE)
         {
            if(this._battle.hasOwnProperty(_loc2_))
            {
               _loc3_ = this._battle[_loc2_];
               if(_loc3_)
               {
                  _loc3_.visible = false;
               }
            }
         }
         if(param1)
         {
            if(this._battle.hasOwnProperty("btn_UI_Gear"))
            {
               _loc4_ = this._battle.btn_UI_Gear;
               if(_loc4_)
               {
                  _loc4_.visible = false;
               }
            }
         }
      }
      
      private function hideActionBarElements() : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         if(!this._battle.hasOwnProperty("actionBar"))
         {
            return;
         }
         var _loc1_:* = this._battle.actionBar;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.visible = false;
         for each(_loc2_ in ACTION_BAR_ELEMENTS)
         {
            if(_loc1_.hasOwnProperty(_loc2_))
            {
               _loc3_ = _loc1_[_loc2_];
               if(_loc3_)
               {
                  _loc3_.visible = false;
               }
            }
         }
      }
      
      private function hideCharacterElements() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc1_:int = 0;
         while(_loc1_ < MAX_TEAM_SIZE)
         {
            for each(_loc2_ in CHARACTER_PREFIXES)
            {
               _loc3_ = _loc2_ + String(_loc1_);
               if(this._battle.hasOwnProperty(_loc3_))
               {
                  _loc4_ = this._battle[_loc3_];
                  if(_loc4_)
                  {
                     _loc4_.visible = false;
                     if(_loc4_.hasOwnProperty("btn_info"))
                     {
                        _loc4_.btn_info.visible = false;
                     }
                     if(_loc4_.hasOwnProperty("swRankMC"))
                     {
                        _loc4_.swRankMC.visible = false;
                     }
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public function destroy() : void
      {
         if(this._destroyed)
         {
            return;
         }
         PvPSocket.getInstance().off("Battle.getPlayerInfo",this.onPlayerInfo);
         PvPSocket.getInstance().off("Battle.getPlayerInfo",this.onEnemyInfo);
         if(this._effectTooltip)
         {
            this._effectTooltip.destroy();
            this._effectTooltip = null;
         }
         this._destroyed = true;
         this.berserk = false;
         this._backgroundLoaded = false;
         this._charactersLoaded = false;
         this.removeLoadListener();
         this.clearLoadedBackground();
         this._battle = null;
         this._main = null;
      }
   }
}

