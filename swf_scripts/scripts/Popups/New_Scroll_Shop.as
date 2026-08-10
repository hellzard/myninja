package Popups
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol9337")]
   public class New_Scroll_Shop extends MovieClip
   {
      
      public var btn_ClanShop:SimpleButton;
      
      public var btn_PvpShop:SimpleButton;
      
      public var title:TextField;
      
      public var txt:TextField;
      
      public var bg:MovieClip;
      
      public var btn_Shop:SimpleButton;
      
      public var btn_PVPShop:SimpleButton;
      
      public var btn_CrewShop:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      private var eventHandler:*;
      
      private var escapeKey:EscapeKeyManager;
      
      private var main:*;
      
      public function New_Scroll_Shop(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this["btn_close"],MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this["bg"],MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this["btn_Shop"],MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this["btn_ClanShop"],MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this["btn_PvpShop"],MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this["btn_CrewShop"],MouseEvent.CLICK,this.openPanel);
      }
      
      private function openPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Panels." + _loc2_);
         this.closePanel();
      }
      
      private function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         if(_loc2_ == "PVPShop")
         {
            _loc2_ = "PvpShop";
         }
         this.main.loadExternalSwfPanel(_loc2_,_loc2_);
         this.closePanel();
      }
      
      private function closePanel(param1:MouseEvent = null) : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         GF.removeAllChild(this);
      }
   }
}

