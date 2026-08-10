package Popups
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6049")]
   public class EmblemUpgrade extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_return:SimpleButton;
      
      public var btn_upgrade:SimpleButton;
      
      public var main:*;
      
      public function EmblemUpgrade(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.exit);
         this.main = param1;
         this.btn_return.addEventListener(MouseEvent.CLICK,this.exit,false,0,true);
         this.btn_upgrade.metaData = {"packageId":"id.ninjasage.emblem"};
         this.btn_upgrade.addEventListener(MouseEvent.CLICK,this.goToSite,false,0,true);
      }
      
      public function goToSite(param1:MouseEvent) : void
      {
         this.main.payment.purchaseProduct(param1.currentTarget.metaData.packageId);
      }
      
      internal function exit(param1:MouseEvent) : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.btn_return.removeEventListener(MouseEvent.CLICK,this.exit);
         this.btn_upgrade.removeEventListener(MouseEvent.CLICK,this.goToSite);
         this.main = null;
         parent.removeChild(this);
      }
   }
}

