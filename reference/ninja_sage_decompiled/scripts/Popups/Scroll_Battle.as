package Popups
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class Scroll_Battle extends MovieClip
   {
       
      
      public var bg:MovieClip;
      
      public var btn_Hunting_House:SimpleButton;
      
      public var btn_Mission_Room:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var huntingLock:MovieClip;
      
      public var eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      public var main;
      
      public function Scroll_Battle(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.huntingLock.visible = false;
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.bg,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_Mission_Room,MouseEvent.CLICK,this.openMissionRoom);
         if(int(Character.character_lvl) >= 20)
         {
            this.eventHandler.addListener(this.btn_Hunting_House,MouseEvent.CLICK,this.openExternalPanel);
         }
         else
         {
            this.huntingLock.visible = true;
         }
      }
      
      public function openPanel(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Panels." + _loc2_);
         this.destroy();
      }
      
      public function openExternalPanel(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("HuntingHouse","HuntingHouse");
         this.destroy();
      }
      
      public function openMissionRoom(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("MissionRoom","MissionRoom");
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
