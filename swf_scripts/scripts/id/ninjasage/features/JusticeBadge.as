package id.ninjasage.features
{
   import Managers.StatManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   public dynamic class JusticeBadge extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:*;
      
      private var main:*;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var selectedExchange:int = -1;
      
      private var ownedMaterial:int = 0;
      
      private var rewardArray:Array = [];
      
      private var statManager:StatManager = new StatManager(this);
      
      private var confirmation:Confirmation;
      
      private const MATERIAL_BADGE:String = "material_2110";
      
      private var destroyed:Boolean = false;
      
      public function JusticeBadge(param1:*, param2:*)
      {
         this.rewardArray = GameData.get("justice_badge").rewards;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.panelMC.closeBtn,MouseEvent.CLICK,this.closePanel);
         this.getEventData();
      }
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("UK5lklcX65GCV4Zr.5dlu4kV6ZQRF",[Character.char_id,Character.sessionkey],this.eventDataResponse);
      }
      
      private function eventDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.ownedMaterial = param1.materials;
            this.panelMC.endTxt.text = param1.end;
         }
         else if(param1.status > 1 && param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.initUI();
      }
      
      private function initUI() : void
      {
         var _loc8_:String = null;
         this.panelMC.ownedTxt.text = "x" + this.ownedMaterial;
         var _loc1_:int = 0;
         while(_loc1_ < this.rewardArray.length)
         {
            this.panelMC["priceTxt_" + _loc1_].text = "x" + this.rewardArray[_loc1_].requirement;
            _loc8_ = this.ownedMaterial >= this.rewardArray[_loc1_].requirement ? "initButton" : "initButtonDisable";
            this.main[_loc8_](this.panelMC["exchangeBtn_" + _loc1_],this.exchangeConfirmation,"Exchange");
            _loc1_++;
         }
         var _loc2_:int = int(this.rewardArray[0].id.replace("xp_",""));
         var _loc3_:int = int(this.statManager.calculate_xp(int(Character.character_lvl)));
         var _loc4_:int = _loc3_ * _loc2_ / 100;
         var _loc5_:int = int(this.rewardArray[1].id.replace("gold_",""));
         var _loc6_:int = int(this.rewardArray[2].id.replace("tp_",""));
         var _loc7_:int = int(this.rewardArray[3].id.replace("ss_",""));
         this.panelMC["rewardTxt_0"].text = "+" + Util.formatNumberWithDot(_loc4_) + " XP";
         this.panelMC["rewardTxt_1"].text = Util.formatNumberWithDot(_loc5_) + " Gold";
         this.panelMC["rewardTxt_2"].text = Util.formatNumberWithDot(_loc6_) + " TP";
         this.panelMC["rewardTxt_3"].text = Util.formatNumberWithDot(_loc7_) + " SS";
      }
      
      private function exchangeConfirmation(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.selectedExchange = e.currentTarget.name.replace("exchangeBtn_","");
         this.confirmation.txtMc.txt.text = "Are you sure that you want to exchange " + this.panelMC["rewardTxt_" + this.selectedExchange].text + " for " + this.rewardArray[this.selectedExchange].requirement + " Justice Badge?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.exchangeBadge);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function exchangeBadge(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.main.loading(true);
         this.main.amf_manager.service("UK5lklcX65GCV4Zr.DxT75fAPByOw",[Character.char_id,Character.sessionkey,this.rewardArray[this.selectedExchange].requirement],this.onExchangeBadge);
      }
      
      private function onExchangeBadge(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.addRewards(param1.rewards);
            Character.removeMaterials(this.MATERIAL_BADGE,this.rewardArray[this.selectedExchange].requirement);
            this.ownedMaterial = param1.materials;
            if(param1.level_up)
            {
               this.main.levelUp();
            }
            Character.character_lvl = param1.level;
            Character.character_xp = param1.xp;
            this.main.giveReward(1,param1.rewards);
            this.main.HUD.loadFrame();
            this.main.HUD.setBasicData();
            this.initUI();
         }
         else if(param1.status > 1 && param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function closePanel(param1:MouseEvent) : void
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
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         this.main.clearEvents();
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.rewardArray = [];
         this.statManager = null;
         this.confirmation = null;
         this.main = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}

