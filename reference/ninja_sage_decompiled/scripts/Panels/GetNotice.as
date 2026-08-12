package Panels
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   
   public class GetNotice extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var bg:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var txt_msg:TextField;
      
      public function GetNotice(param1:String)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.txt_msg.text = param1;
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.bg.addEventListener(MouseEvent.CLICK,this.closePanel);
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.txt_msg = null;
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.bg.removeEventListener(MouseEvent.CLICK,this.closePanel);
         parent.removeChild(this);
      }
   }
}
