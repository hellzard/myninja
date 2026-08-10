package Popups
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol9460")]
   public class New_Scroll_Academy extends MovieClip
   {
      
      public var title:TextField;
      
      public var txt:TextField;
      
      public var bg:MovieClip;
      
      public var btn_Academy:SimpleButton;
      
      public var btn_AdvancedAcademy:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      private var main:*;
      
      private var eventHandler:*;
      
      private var escapeKey:EscapeKeyManager;
      
      public function New_Scroll_Academy(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this["btn_close"],MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this["bg"],MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this["btn_Academy"],MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this["btn_AdvancedAcademy"],MouseEvent.CLICK,this.openPanel);
      }
      
      private function openPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Panels." + _loc2_);
         this.destroy();
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
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         GF.removeAllChild(this);
      }
   }
}

