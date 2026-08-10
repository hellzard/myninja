package Panels
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4871")]
   public class News extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var bg:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var txt:TextField;
      
      public var main:*;
      
      public function News(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.bg.addEventListener(MouseEvent.CLICK,this.closePanel);
      }
      
      internal function closePanel(param1:MouseEvent) : void
      {
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.bg.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.txt.text = "";
         this.main = null;
         parent.removeChild(this);
      }
   }
}

