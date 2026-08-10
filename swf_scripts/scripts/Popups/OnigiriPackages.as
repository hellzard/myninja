package Popups
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.Clan;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2710")]
   public dynamic class OnigiriPackages extends MovieClip
   {
      
      public var btnClose:MovieClip;
      
      public var convertBtn:MovieClip;
      
      public var info_mc:MovieClip;
      
      public var p1:MovieClip;
      
      public var p2:MovieClip;
      
      public var p3:MovieClip;
      
      public var main:*;
      
      public var selected_package:* = -1;
      
      public var qty:*;
      
      public var price:*;
      
      public var ownedonigiri:int;
      
      private var confirmation:*;
      
      public var eventHandler:* = new EventHandler();
      
      public function OnigiriPackages(param1:*)
      {
         super();
         this.main = param1;
         this.setTexts();
         this.initPackage();
         this.initButton();
      }
      
      public function resetOtherButtons() : *
      {
         this.p1.highlight.gotoAndStop(1);
         this.p2.highlight.gotoAndStop(1);
         this.p3.highlight.gotoAndStop(1);
         this.selected_package = -1;
         this.main.disableButton(this.convertBtn);
      }
      
      public function setTexts() : *
      {
         this.info_mc.tokenTxt.text = String(Character.account_tokens);
         this.info_mc.onigiriTxt.text = NinjaSage.getMaterialAmount("material_69");
         this.ownedonigiri = int(NinjaSage.getMaterialAmount("material_69"));
      }
      
      public function initPackage() : *
      {
         this.resetOtherButtons();
         this.eventHandler.addListener(this.p1,MouseEvent.CLICK,this.onClickPackage);
         this.eventHandler.addListener(this.p2,MouseEvent.CLICK,this.onClickPackage);
         this.eventHandler.addListener(this.p3,MouseEvent.CLICK,this.onClickPackage);
      }
      
      public function initButton() : *
      {
         this.main.initButton(this.convertBtn,this.buyConfirmation);
         this.main.initButton(this.btnClose,this.closeThis);
      }
      
      public function onClickPackage(param1:MouseEvent) : *
      {
         this.resetOtherButtons();
         var _loc2_:* = int(param1.currentTarget.name.replace("p",""));
         this.selected_package = _loc2_ - 1;
         param1.currentTarget.highlight.gotoAndStop("show");
         this.main.enableButton(this.convertBtn);
      }
      
      protected function buyConfirmation(param1:MouseEvent) : *
      {
         if(this.selected_package < 0)
         {
            this.main.getNotice("Please choose the onigiri package first");
            return;
         }
         this.confirmation = getDefinitionByName("Popups.Confirmation") as Class;
         this.confirmation = new this.confirmation();
         if(param1.currentTarget.is_enabled)
         {
            this.qty = [100,200,500][this.selected_package];
            this.price = [975,1900,4625][this.selected_package];
         }
         this.confirmation.txtMc.txt.text = "Are you sure that you want to buy " + this.qty + " Onigiri For " + this.price + " Token";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.onCloseConfirm);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyOnigiri);
         addChild(this.confirmation);
      }
      
      public function onCloseConfirm(param1:MouseEvent = null) : *
      {
         if("btn_confirm" in this.confirmation)
         {
            this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyOnigiri);
            this.eventHandler.removeListener(this.confirmation.btn_close,MouseEvent.CLICK,this.onCloseConfirm);
            removeChild(this.confirmation);
         }
         this.confirmation = null;
      }
      
      public function buyOnigiri(param1:MouseEvent) : *
      {
         this.onCloseConfirm();
         this.main.loading(true);
         Clan.instance.buyOnigiriPackage(this.selected_package,this.buyOnigiriResponse);
      }
      
      public function buyOnigiriResponse(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("qty"))
         {
            Character.account_tokens -= param1.price;
            Character.addMaterials("material_69",param1.qty);
            this.main.showMessage("You have bought " + param1.qty + " Onigiri");
            this.setTexts();
            return;
         }
         this.main.getError("");
      }
      
      public function closeThis(param1:MouseEvent) : *
      {
         this.confirmation = null;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         GF.removeAllChild(this);
         this.main = null;
      }
   }
}

