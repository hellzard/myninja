package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ChuninPackages extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var ancestorPackage:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var chuninPackage:MovieClip;
      
      private var rewardsArray:Object;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      public function ChuninPackages(param1:*, param2:*)
      {
         this.rewardsArray = {
            "chunin_package":["skill_399","wpn_864","back_536"],
            "ancestor_package":["hair_309_" + Character.character_gender,"set_1155_" + Character.character_gender,"back_605","wpn_1341"]
         };
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.init();
      }
      
      private function init() : *
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.chuninPackage.btn_buy,MouseEvent.CLICK,this.showConfirmation);
         this.panelMC.ancestorPackage.btn_buy.metaData = {"packageId":"id.ninjasage.ancestor"};
         this.main.initButton(this.panelMC.ancestorPackage.btn_buy,this.openMerchant,!!this.main.isPaymentSupported() ? this.main.payment.getProductData("id.ninjasage.ancestor").priceString : "Merchant");
         var _loc1_:* = 0;
         while(_loc1_ < 3)
         {
            NinjaSage.loadItemIcon(this.panelMC.chuninPackage.rewardMC["iconMC" + _loc1_],this.rewardsArray.chunin_package[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            NinjaSage.loadItemIcon(this.panelMC.ancestorPackage.rewardMC["iconMC" + _loc1_],this.rewardsArray.ancestor_package[_loc1_]);
            _loc1_++;
         }
      }
      
      private function showConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Confirm buying Chunin Packages for 2000 Tokens ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPackage);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function buyPackage(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.main.loading(true);
         this.main.amf_manager.service("orA84WWheAf1SI5M.5pZk1Q7epBhZ",[Character.char_id,Character.sessionkey],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,"skill_399,wpn_864,back_536");
            Character.addWeapon("wpn_864");
            Character.addBack("back_536");
            Character.updateSkills("skill_399",true);
            Character.account_tokens = int(Character.account_tokens) - 2000;
            this.main.HUD.setBasicData();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.error);
         }
      }
      
      private function openMerchant(param1:MouseEvent) : *
      {
         if(this.main.isPaymentSupported())
         {
            this.main.payment.purchaseProduct(param1.currentTarget.metaData.packageId);
         }
         else
         {
            navigateToURL(new URLRequest("https://ninjasage.id/merchants"));
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
         while(_loc1_ < 3)
         {
            GF.removeAllChild(this.panelMC.chuninPackage.rewardMC["iconMC" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.chuninPackage.rewardMC["iconMC" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            GF.removeAllChild(this.panelMC.ancestorPackage.rewardMC["iconMC" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.ancestorPackage.rewardMC["iconMC" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.main = null;
         this.character = null;
         this.eventHandler = null;
         this.confirmation = null;
         this.rewardsArray = [];
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
