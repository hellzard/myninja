package Panels
{
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7231")]
   public class TrialEmblem extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var btn_renew:SimpleButton;
      
      public var txt_totalDay:TextField;
      
      public var main:*;
      
      public function TrialEmblem(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.btn_renew.metaData = {"packageId":"id.ninjasage.trial.emblem"};
         this.btn_renew.addEventListener(MouseEvent.CLICK,this.goToSite);
         this.getBasicData();
      }
      
      public function getBasicData() : void
      {
         this.txt_totalDay.text = Character.emblem_duration + " Days Remaining";
         if(int(Character.account_type) == 0)
         {
            this.txt_totalDay.text = "Free User";
         }
         if(int(Character.account_type) == 1 && int(Character.emblem_duration) == -1)
         {
            this.txt_totalDay.text = "Premium";
            this.btn_renew.visible = false;
         }
      }
      
      public function goToSite(param1:MouseEvent) : void
      {
         this.main.payment.purchaseProduct(param1.currentTarget.metaData.packageId);
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.btn_renew.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.main = null;
         parent.removeChild(this);
      }
   }
}

