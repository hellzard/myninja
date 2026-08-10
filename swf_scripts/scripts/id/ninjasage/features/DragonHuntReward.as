package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class DragonHuntReward extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:*;
      
      private var PET_RANK_I:Array;
      
      private var PET_RANK_II:Array;
      
      private var PET_RANK_III:Array;
      
      private var PET_RANK_IV:Array;
      
      public function DragonHuntReward(param1:*, param2:*)
      {
         var _loc3_:Object = GameData.get("dragon_hunt").pets;
         this.PET_RANK_I = _loc3_.rank_i;
         this.PET_RANK_II = _loc3_.rank_ii;
         this.PET_RANK_III = _loc3_.rank_iii;
         this.PET_RANK_IV = _loc3_.rank_iv;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.initUI();
      }
      
      private function initUI() : *
      {
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.PET_RANK_I.length)
         {
            NinjaSage.loadItemIcon(this.panelMC["IconMc1_" + _loc1_],this.PET_RANK_I[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.PET_RANK_II.length)
         {
            NinjaSage.loadItemIcon(this.panelMC["IconMc2_" + _loc1_],this.PET_RANK_II[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.PET_RANK_III.length)
         {
            NinjaSage.loadItemIcon(this.panelMC["IconMc3_" + _loc1_],this.PET_RANK_III[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.PET_RANK_IV.length)
         {
            NinjaSage.loadItemIcon(this.panelMC["IconMc4_" + _loc1_],this.PET_RANK_IV[_loc1_]);
            _loc1_++;
         }
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         var _loc1_:* = 0;
         while(_loc1_ < this.PET_RANK_I.length)
         {
            GF.removeAllChild(this.panelMC["IconMc1_" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC["IconMc1_" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.PET_RANK_II.length)
         {
            GF.removeAllChild(this.panelMC["IconMc2_" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC["IconMc2_" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.PET_RANK_III.length)
         {
            GF.removeAllChild(this.panelMC["IconMc3_" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC["IconMc3_" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.PET_RANK_IV.length)
         {
            GF.removeAllChild(this.panelMC["IconMc4_" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC["IconMc4_" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         NinjaSage.clearLoader();
         this.main = null;
         this.character = null;
         this.eventHandler = null;
         this.PET_RANK_I = [];
         this.PET_RANK_II = [];
         this.PET_RANK_III = [];
         this.PET_RANK_IV = [];
         GF.removeAllChild(this.panelMC);
      }
   }
}

