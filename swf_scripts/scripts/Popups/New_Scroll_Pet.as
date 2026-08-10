package Popups
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol9383")]
   public class New_Scroll_Pet extends MovieClip
   {
      
      public var btn_PetCombination:SimpleButton;
      
      public var title:TextField;
      
      public var txt:TextField;
      
      public var bg:MovieClip;
      
      public var btn_PetShop:SimpleButton;
      
      public var btn_PetVilla:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      public var main:*;
      
      public function New_Scroll_Pet(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.bg,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_PetShop,MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this.btn_PetVilla,MouseEvent.CLICK,this.openPanel);
         this.eventHandler.addListener(this.btn_PetCombination,MouseEvent.CLICK,this.openSwfPanel);
      }
      
      public function openPanel(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Panels." + _loc2_);
         this.destroy();
      }
      
      public function openSwfPanel(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadExternalSwfPanel(_loc2_,_loc2_);
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

