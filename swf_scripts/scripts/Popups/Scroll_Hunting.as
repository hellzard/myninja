package Popups
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4841")]
   public class Scroll_Hunting extends MovieClip
   {
      
      public var descTxt:TextField;
      
      public var eudemonLock:MovieClip;
      
      public var bg:MovieClip;
      
      public var btn_HuntingHouse:SimpleButton;
      
      public var btn_EudemonGarden:SimpleButton;
      
      public var btn_MaterialMarket:SimpleButton;
      
      public var btn_Blacksmith:SimpleButton;
      
      public var btn_HuntingMarket:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var huntingLock:MovieClip;
      
      public var eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      public var main:*;
      
      public function Scroll_Hunting(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.bg,MouseEvent.CLICK,this.closePanel);
         this.huntingLock.visible = false;
         this.eudemonLock.visible = false;
         if(int(Character.character_lvl) >= 10)
         {
            this.eventHandler.addListener(this.btn_EudemonGarden,MouseEvent.CLICK,this.openExternalPanel);
         }
         else
         {
            this.eudemonLock.visible = true;
         }
         if(int(Character.character_lvl) >= 20 && int(Character.character_rank) >= 3)
         {
            this.eventHandler.addListener(this.btn_HuntingHouse,MouseEvent.CLICK,this.openExternalPanel);
         }
         else
         {
            this.huntingLock.visible = true;
         }
         this.eventHandler.addListener(this.btn_MaterialMarket,MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this.btn_Blacksmith,MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this.btn_HuntingMarket,MouseEvent.CLICK,this.openPanel);
      }
      
      public function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadExternalSwfPanel(_loc2_,_loc2_);
         this.destroy();
      }
      
      public function openPanel(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Panels." + _loc2_);
         this.destroy();
      }
      
      public function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
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

