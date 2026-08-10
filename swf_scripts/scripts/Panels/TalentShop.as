package Panels
{
   import Popups.TalentsShow;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1371")]
   public class TalentShop extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var btnEnter:MovieClip;
      
      public var btnExit:MovieClip;
      
      public var confirmBox:MovieClip;
      
      public var show_mc:TalentsShow;
      
      public var main:*;
      
      public var eventHandler:* = new EventHandler();
      
      public function TalentShop(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closeThis);
         this.main = param1;
         this.addButtonListeners();
         this.show_mc.visible = false;
         this.main.handleVillageHUDVisibility(false);
         this.confirmBox.gotoAndStop(1);
      }
      
      public function addButtonListeners() : *
      {
         this.main.initButton(this.btnEnter,this.openTalentShop,"Go");
         this.main.initButton(this.btnExit,this.closeThis);
      }
      
      public function showConfirmationBox(param1:*, param2:*) : *
      {
         this.confirmBox.visible = true;
         this.confirmBox.gotoAndStop("show");
         this.confirmBox.displayTxt.text = param1;
         this.eventHandler.addListener(this.confirmBox.yesBtn,MouseEvent.CLICK,param2);
         this.eventHandler.addListener(this.confirmBox.noBtn,MouseEvent.CLICK,this.closeConfirmBox);
      }
      
      public function closeConfirmBox(param1:MouseEvent) : *
      {
         this.confirmBox.visible = false;
      }
      
      public function closeThis(param1:MouseEvent) : *
      {
         this.main.handleVillageHUDVisibility(true);
         this.main.clearEvents();
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         GF.removeAllChild(this.show_mc);
         GF.removeAllChild(this);
      }
      
      public function openTalentShop(param1:MouseEvent) : *
      {
         this.show_mc.visible = true;
         this.show_mc.openThis(this);
      }
   }
}

