package id.ninjasage.pvp
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.pvp.battle.PvPBattleManager;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8919")]
   public class BattleResult extends MovieClip
   {
      
      public var victoryMC:MovieClip;
      
      public var defeatMC:MovieClip;
      
      public var data:Object;
      
      private var _eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      public function BattleResult()
      {
         super();
         this._eventHandler = new EventHandler();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
      }
      
      public function setResultData(param1:Object) : void
      {
         this.data = param1;
         this.initUI();
      }
      
      public function initUI() : void
      {
         var _loc8_:MovieClip = null;
         var _loc1_:* = PvPBattleManager.PVP.character.getID();
         if(Boolean(this.data) && Boolean(this.data.hasOwnProperty("id")) && PvPBattleManager.PVP.character.getID() == this.data.id)
         {
            this.victoryMC.visible = true;
            this.defeatMC.visible = false;
         }
         else
         {
            this.defeatMC.visible = true;
            this.victoryMC.visible = false;
         }
         var _loc2_:MovieClip = this.victoryMC.visible ? this.victoryMC : this.defeatMC;
         this._eventHandler.addListener(_loc2_.btn_close,MouseEvent.CLICK,this.closePanel);
         this._eventHandler.addListener(_loc2_.btn_claim,MouseEvent.CLICK,this.closePanel);
         var _loc3_:* = [];
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(Boolean(this.data) && this.data.hasOwnProperty("rewards"))
         {
            _loc4_ = Number(this.data.rewards.gold || 0);
            _loc5_ = Number(this.data.rewards.xp || 0);
            _loc6_ = Number(this.data.rewards.point || this.data.rewards.points || 0);
            _loc2_.goldMc.txt.text = _loc4_;
            _loc2_.xpMc.txt.text = _loc5_;
            _loc2_.txt_coin.text = _loc6_;
            Character.character_pvp_point += _loc6_;
            if(this.data.rewards.hasOwnProperty("etc"))
            {
               _loc3_ = _loc3_.concat(this.data.rewards.etc);
            }
         }
         _loc2_.leagueMC.visible = false;
         if(this.data.hasOwnProperty("league"))
         {
            _loc2_.trophyMC.visible = false;
            _loc2_.leagueMC.visible = true;
            _loc2_.leagueMC.gotoAndStop(this.data.league + 1);
         }
         _loc2_.txt_trophy.text = this.data.trophy || 0;
         var _loc7_:int = 0;
         while(_loc7_ < 4)
         {
            _loc8_ = _loc2_["iconMc_" + _loc7_];
            _loc8_.visible = false;
            if(_loc7_ < _loc3_.length)
            {
               _loc8_.visible = true;
               _loc8_.amountTxt.text = "";
               _loc8_.ownedTxt.text = "";
               NinjaSage.loadItemIcon(_loc8_,_loc3_[_loc7_]);
            }
            _loc7_++;
         }
         Character.addRewards(_loc3_);
         Character.character_gold = String(Number(Character.character_gold) + _loc4_);
         Character.character_xp = String(Number(Character.character_xp) + _loc5_);
      }
      
      public function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this._eventHandler)
         {
            this._eventHandler.removeAllEventListeners();
         }
         this._eventHandler = null;
         this.data = null;
         GF.removeAllChild(this);
         GF.removeParent(this);
         NinjaSage.clearLoader();
         var _loc1_:* = PvPBattleManager.getMain();
         if(_loc1_)
         {
            _loc1_.stopAllBgm();
            _loc1_.startBgm();
         }
         if(PvPBattleManager.PVP)
         {
            PvPBattleManager.PVP.goToLobby();
            PvPBattleManager.PVP.getCharacterStats();
         }
         PvPBattleManager.endBattle();
      }
   }
}

