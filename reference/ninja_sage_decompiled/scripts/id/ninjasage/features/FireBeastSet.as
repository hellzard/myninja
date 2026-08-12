package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class FireBeastSet extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var costumeData:Object;
      
      private var price:int;
      
      private var target:int;
      
      private var confirmation:Confirmation;
      
      private var eventHandler:EventHandler;
      
      private var main;
      
      public function FireBeastSet(param1:*, param2:*)
      {
         this.costumeData = {};
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.getData();
      }
      
      private function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("UokNmLBKpsRnTHx2.svIetUx0XNJu",[Character.char_id,Character.sessionkey],this.getDataResponse);
      }
      
      private function getDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.costumeData = param1.packages.firebeast;
         }
         else if(param1.status > 1 && param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.panelMC.panelMC.goldMC.visible = false;
         this.panelMC.panelMC.tokenMC.visible = true;
         this.panelMC.panelMC.tokenMC.tokenTxt.text = this.costumeData.price;
         this.eventHandler.addListener(this.panelMC.panelMC.tokenMC.tokenBuy,MouseEvent.CLICK,this.showConfirmation);
         var _loc1_:* = 0;
         while(_loc1_ < this.costumeData.items.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.panelMC["icon_" + _loc1_],this.costumeData.items[_loc1_]);
            _loc1_++;
         }
         this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
         this.panelMC.panelMC.goldTxt.text = Character.character_gold;
         this.panelMC.panelMC.titleTxt.text = this.costumeData.name;
         this.eventHandler.addListener(this.panelMC.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.panelMC.getMoreBtn1,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
      }
      
      private function showConfirmation(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var price:* = this.costumeData.price + " Token(s)";
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Confirm buying " + this.costumeData.name + " for " + price + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPackage);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function buyPackage(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.main.loading(true);
         this.main.amf_manager.service("UokNmLBKpsRnTHx2.ucqwx8rP1T7A",[Character.char_id,Character.sessionkey,"firebeast"],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.addRewards(param1.rewards);
            this.main.giveReward(1,param1.rewards,"anniversary");
            Character.account_tokens = int(Character.account_tokens) - this.costumeData.price;
            this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
            this.panelMC.panelMC.goldTxt.text = Character.character_gold;
            this.panelMC.panelMC.goldMC.visible = false;
            this.main.HUD.setBasicData();
         }
         else if(param1.status > 1 && param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.error);
         }
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
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
         var _loc1_:* = 0;
         while(_loc1_ < 6)
         {
            GF.removeAllChild(this.panelMC.panelMC["icon_" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC["icon_" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.costumeData = [];
         this.main = null;
         this.eventHandler = null;
         this.confirmation = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
