package Popups
{
   import Panels.TalentPanel;
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EventHandler;
   
   public class TalentBoost extends MovieClip
   {
       
      
      public var btnClose:MovieClip;
      
      public var convertBtn:MovieClip;
      
      public var info_mc:MovieClip;
      
      public var p1:MovieClip;
      
      public var p2:MovieClip;
      
      public var p3:MovieClip;
      
      public var p4:MovieClip;
      
      public var parent_mc:TalentPanel;
      
      public var main;
      
      public var selected_package = -1;
      
      private var eventHandler:EventHandler;
      
      public function TalentBoost()
      {
         super();
         this.eventHandler = new EventHandler();
      }
      
      public function init(param1:*) : *
      {
         this.parent_mc = param1;
         this.main = param1.main;
         this.addButtonListeners();
         this.setTexts();
         this.initMovieClips();
      }
      
      public function setTexts() : *
      {
         this.info_mc.tokenTxt.text = String(Character.account_tokens);
         this.info_mc.bpTxt.text = String(Character.character_tp);
      }
      
      public function resetOtherButtons() : *
      {
         this.p1.highlight.gotoAndStop(1);
         this.p2.highlight.gotoAndStop(1);
         this.p3.highlight.gotoAndStop(1);
         this.p4.highlight.gotoAndStop(1);
         this.selected_package = -1;
         this.main.disableButton(this.convertBtn);
      }
      
      public function initMovieClips() : *
      {
         this.resetOtherButtons();
         this.p1.gotoAndStop(1);
         this.p1.bpTxt.text = "20 TP";
         this.p1.tokenTxt.text = "20 Token";
         this.p2.gotoAndStop(2);
         this.p2.bpTxt.text = "100 + 25 TP";
         this.p2.tokenTxt.text = "100 Token";
         this.p3.gotoAndStop(3);
         this.p3.bpTxt.text = "200 + 50 TP";
         this.p3.tokenTxt.text = "200 Token";
         this.p4.gotoAndStop(4);
         this.p4.bpTxt.text = "400 + 200 TP";
         this.p4.tokenTxt.text = "400 Token";
         this.eventHandler.addListener(this.p1,MouseEvent.CLICK,this.onClickPackage);
         this.eventHandler.addListener(this.p2,MouseEvent.CLICK,this.onClickPackage);
         this.eventHandler.addListener(this.p3,MouseEvent.CLICK,this.onClickPackage);
         this.eventHandler.addListener(this.p4,MouseEvent.CLICK,this.onClickPackage);
      }
      
      public function addButtonListeners() : *
      {
         this.main.initButton(this.convertBtn,this.boostTP,"Boost TP");
         this.main.initButton(this.btnClose,this.closeThis);
      }
      
      public function onClickPackage(param1:MouseEvent) : *
      {
         this.resetOtherButtons();
         var _loc2_:* = int(param1.currentTarget.name.replace("p",""));
         this.selected_package = _loc2_ - 1;
         param1.currentTarget.highlight.gotoAndStop("show");
         this.main.enableButton(this.convertBtn);
      }
      
      public function boostTP(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1.currentTarget.is_enabled)
         {
            _loc2_ = [20,125,250,600][this.selected_package];
            _loc3_ = [20,100,200,400][this.selected_package];
            this.parent_mc.showConfirmationBox("Are you sure that you want to boost " + _loc2_ + "TP For " + _loc3_ + "Token",this.onBoostTPAMF);
         }
      }
      
      public function onBoostTPAMF(param1:MouseEvent) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.parent_mc.confirmBox.visible = false;
         this.main.loading(true);
         this.main.amf_manager.service("RzFUf16G1EIy2bfB.UUIhgtQUO7hk",[Character.char_id,Character.sessionkey,this.selected_package],this.onTPBoosted);
      }
      
      public function onTPBoosted(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this.main.showMessage(param1.result);
               return;
            }
            Character.account_tokens -= param1.price;
            Character.character_tp = int(int(Character.character_tp) + param1.add).toString();
            this.main.showMessage("You have boosted " + param1.add + "TP");
            this.setTexts();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function closeThis(param1:MouseEvent) : *
      {
         this.parent_mc.setTexts();
         this.visible = false;
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
         }
         if(this.main)
         {
            this.main.clearEvents();
         }
         this.eventHandler = null;
         this.main = null;
      }
   }
}
