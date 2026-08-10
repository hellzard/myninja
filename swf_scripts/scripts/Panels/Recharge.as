package Panels
{
   import Managers.NinjaSage;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import id.ninjasage.EscapeKeyManager;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4811")]
   public class Recharge extends MovieClip
   {
      
      public var btn_BonusRecharge:SimpleButton;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var emblem:MovieClip;
      
      public var tokens_500:MovieClip;
      
      public var tokens_2500:MovieClip;
      
      public var tokens_5000:MovieClip;
      
      public var tokens_25000:MovieClip;
      
      public var tokens_50000:MovieClip;
      
      public var btn_RedeemTicket:SimpleButton;
      
      public var btn_Recover:SimpleButton;
      
      public var buttons:Array;
      
      public var main:*;
      
      public function Recharge(param1:*)
      {
         var _loc4_:String = null;
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.buttons = [this.emblem,this.tokens_500,this.tokens_2500,this.tokens_5000,this.tokens_25000,this.tokens_50000];
         var _loc2_:String = "id.ninjasage.";
         var _loc3_:int = 0;
         while(_loc3_ < this.buttons.length)
         {
            _loc4_ = _loc2_ + this.buttons[_loc3_].name.replace("_",".");
            this.buttons[_loc3_].metaData = {"packageId":_loc4_};
            this.main.initButton(this.buttons[_loc3_],this.buyPack,this.main.isPaymentSupported() ? this.main.payment.getProductData(_loc4_).priceString : "");
            _loc3_++;
         }
         this.btn_RedeemTicket.addEventListener(MouseEvent.CLICK,this.buyPack);
         this.btn_BonusRecharge.addEventListener(MouseEvent.CLICK,this.buyPack);
         this.btn_Recover.visible = false;
         if(this.main.isPaymentSupported())
         {
            this.btn_Recover.visible = true;
            this.btn_Recover.addEventListener(MouseEvent.CLICK,this.buyPack);
            NinjaSage.showDynamicTooltip(this.btn_Recover,"Click here to check for pending purchase");
         }
      }
      
      internal function buyPack(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "btn_RedeemTicket")
         {
            this.main.loadExternalSwfPanel("RedeemTicket","RedeemTicket");
         }
         else if(param1.currentTarget.name == "btn_BonusRecharge")
         {
            this.main.showMessage("Coming Soon!");
         }
         else if(param1.currentTarget.name == "btn_Recover")
         {
            if(this.main.isPaymentSupported())
            {
               this.main.payment.checkPendingPurchases();
            }
            else
            {
               this.main.showMessage("Payment service is not ready yet.");
            }
         }
         else if(this.main.isPaymentSupported())
         {
            this.main.payment.purchaseProduct(param1.currentTarget.metaData.packageId);
         }
         else
         {
            navigateToURL(new URLRequest("http://127.0.0.1:800/merchants"));
         }
      }
      
      internal function closePanel(param1:MouseEvent) : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main = null;
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.buttons = null;
         this.btn_RedeemTicket.removeEventListener(MouseEvent.CLICK,this.buyPack);
         this.btn_BonusRecharge.removeEventListener(MouseEvent.CLICK,this.buyPack);
         this.btn_Recover.removeEventListener(MouseEvent.CLICK,this.buyPack);
         GF.removeAllChild(this);
      }
   }
}

