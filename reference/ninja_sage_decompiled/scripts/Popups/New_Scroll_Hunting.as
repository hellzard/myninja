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
   
   public class New_Scroll_Hunting extends MovieClip
   {
       
      
      public var title:TextField;
      
      public var txt:TextField;
      
      public var bg:MovieClip;
      
      public var btn_HuntingHouse:SimpleButton;
      
      public var btn_EudemonGarden:SimpleButton;
      
      public var btn_MaterialMarket:SimpleButton;
      
      public var btn_Blacksmith:SimpleButton;
      
      public var btn_HuntingMarket:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      public var main;
      
      public function New_Scroll_Hunting(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.bg,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_EudemonGarden,MouseEvent.CLICK,this.openExternalPanel);
         this.eventHandler.addListener(this.btn_HuntingHouse,MouseEvent.CLICK,this.openExternalPanel);
         this.eventHandler.addListener(this.btn_MaterialMarket,MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this.btn_Blacksmith,MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this.btn_HuntingMarket,MouseEvent.CLICK,this.openPanel);
      }
      
      public function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         if(_loc2_ == "HuntingHouse" && int(Character.character_lvl) < 20 && int(Character.character_rank) < 2)
         {
            this.main.getNotice("Unlocks on Level 20 and Rank Chunin!");
            return;
         }
         if(_loc2_ == "EudemonGarden" && int(Character.character_lvl) < 10)
         {
            this.main.getNotice("Unlocks on Level 10 !");
            return;
         }
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
