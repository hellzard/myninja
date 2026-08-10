package Panels
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7808")]
   public class Update extends MovieClip
   {
      
      public var btn_site:SimpleButton;
      
      public function Update(param1:*)
      {
         super();
         this.btn_site.addEventListener(MouseEvent.CLICK,this.update);
      }
      
      internal function update(param1:MouseEvent) : void
      {
         var _loc2_:String = "http://127.0.0.1:800/en#downloads";
         navigateToURL(new URLRequest(_loc2_));
         this.btn_site.removeEventListener(MouseEvent.CLICK,this.update);
         this.btn_site = null;
      }
   }
}

