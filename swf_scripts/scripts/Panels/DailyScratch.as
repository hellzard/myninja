package Panels
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1966")]
   public dynamic class DailyScratch extends MovieClip
   {
      
      public var iconMC:MovieClip;
      
      public var popupRewardMC:MovieClip;
      
      public var scratch_0:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_reward:SimpleButton;
      
      public var loginView:MovieClip;
      
      public var scratch_1:MovieClip;
      
      public var scratch_2:MovieClip;
      
      public var scratch_3:MovieClip;
      
      public var ticketMc:MovieClip;
      
      public var rewardMc:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      private var rewardData:Array;
      
      private var grandPrizeData:Array;
      
      private var selectedScratch:int;
      
      private var obtainedReward:String;
      
      private var response:Object;
      
      private var main:*;
      
      public function DailyScratch(param1:*)
      {
         var _loc2_:* = GameData.get("scratch");
         this.eventHandler = new EventHandler();
         this.escapeKey = new EscapeKeyManager(this);
         this.grandPrizeData = _loc2_.grand_prize;
         this.rewardData = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.rewards.length)
         {
            this.rewardData.push(_loc2_.rewards[_loc3_].replace("%s",Character.character_gender));
            _loc3_++;
         }
         super();
         this.main = param1;
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_reward,MouseEvent.CLICK,this.openRewardList);
         this.popupRewardMC.visible = false;
         this.rewardMc.visible = false;
         this.escapeKey.addListener(this,this.closePanel);
         this.escapeKey.addListener(this.rewardMc,this.closeRewardList);
         this.escapeKey.addListener(this.popupRewardMC,this.closePopupReward);
         this.loginView.gotoAndStop(1);
         this.ticketMc.gotoAndStop(1);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this["scratch_" + _loc1_].stop();
            _loc1_++;
         }
         this.loadGrandPrizeIcon();
         this.getData();
      }
      
      private function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("Eo4j1Hp7MyIXy5Vo.wrW8T2B7pMB4",[Character.char_id,Character.sessionkey],this.onGetData);
      }
      
      private function onGetData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.loginView.gotoAndStop(int(this.response.consecutive));
            this.checkScratch();
         }
         else if(param1.status > 1)
         {
            if(param1.hasOwnProperty("result"))
            {
               this.main.showMessage(param1.result);
               return;
            }
            this.main.showMessage("Unknown Error");
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function checkScratch() : void
      {
         this.ticketMc.remainScratch_Txt.text = "You have " + this.response.ticket + " FREE SCRATCH now";
         this.ticketMc.gotoAndStop("left_" + Math.max(1,Math.min(9,this.response.ticket)));
         if(int(this.response.ticket) > 0)
         {
            this.enableScratch();
         }
         else
         {
            this.main.showMessage("You can scratch again tomorrow");
            this.disableScratch();
         }
      }
      
      private function enableScratch() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this["scratch_" + _loc1_].gotoAndStop("idle");
            this.eventHandler.addListener(this["scratch_" + _loc1_],MouseEvent.CLICK,this.scratchAMF);
            _loc1_++;
         }
      }
      
      private function disableScratch() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this["scratch_" + _loc1_].gotoAndStop("idle");
            this.eventHandler.removeListener(this["scratch_" + _loc1_],MouseEvent.CLICK,this.scratchAMF);
            _loc1_++;
         }
      }
      
      private function scratchAMF(param1:MouseEvent) : void
      {
         this.disableScratch();
         this.selectedScratch = param1.currentTarget.name.replace("scratch_","");
         this.main.amf_manager.service("Eo4j1Hp7MyIXy5Vo.KVbls7ShSvob",[Character.char_id,Character.sessionkey],this.onGetReward);
      }
      
      private function onGetReward(param1:Object) : void
      {
         if(param1.status == 1)
         {
            this.obtainedReward = param1.reward;
            this["scratch_" + this.selectedScratch].gotoAndPlay("select");
            this["scratch_" + this.selectedScratch].addFrameScript(23,this.showPopupReward);
            this["scratch_" + this.selectedScratch].iconMC.amtTxt.visible = false;
            this["scratch_" + this.selectedScratch].iconMC.ownedTxt.visible = false;
            NinjaSage.loadItemIcon(this["scratch_" + this.selectedScratch].iconMC,this.obtainedReward);
         }
         else if(param1.status > 1)
         {
            if(param1.hasOwnProperty("result"))
            {
               this.main.showMessage(param1.result);
               return;
            }
            this.main.showMessage("Unknown Error");
            this.enableScratch();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function showPopupReward() : void
      {
         this["scratch_" + this.selectedScratch].stop();
         this.eventHandler.addListener(this.popupRewardMC.btn_confirm,MouseEvent.CLICK,this.closePopupReward);
         this.popupRewardMC.iconMC.amtTxt.visible = false;
         this.popupRewardMC.iconMC.ownedTxt.visible = false;
         NinjaSage.loadItemIcon(this.popupRewardMC.iconMC,this.obtainedReward);
         Character.addRewards(this.obtainedReward);
         this.main.HUD.setBasicData();
         this.popupRewardMC.visible = true;
      }
      
      private function closePopupReward(param1:MouseEvent) : void
      {
         if(this.response.ticket > 0)
         {
            --this.response.ticket;
         }
         this.popupRewardMC.visible = false;
         this.eventHandler.removeListener(this.popupRewardMC.btn_confirm,MouseEvent.CLICK,this.closePopupReward);
         GF.removeAllChild(this.popupRewardMC.iconMC.rewardIcon.iconHolder);
         GF.removeAllChild(this.popupRewardMC.iconMC.skillIcon.iconHolder);
         this.selectedScratch = -1;
         this.obtainedReward = "";
         this.checkScratch();
      }
      
      private function loadGrandPrizeIcon() : void
      {
         this.iconMC.amtTxt.visible = false;
         this.iconMC.ownedTxt.visible = false;
         NinjaSage.loadItemIcon(this.iconMC,this.grandPrizeData[0]);
      }
      
      private function openRewardList(param1:MouseEvent) : void
      {
         this.rewardMc.visible = true;
         this.eventHandler.addListener(this.rewardMc.btn_close,MouseEvent.CLICK,this.closeRewardList);
         var _loc2_:int = 0;
         while(_loc2_ < this.rewardData.length)
         {
            this.rewardMc["iconMC" + _loc2_].amtTxt.visible = false;
            this.rewardMc["iconMC" + _loc2_].ownedTxt.visible = false;
            NinjaSage.loadItemIcon(this.rewardMc["iconMC" + _loc2_],this.rewardData[_loc2_]);
            _loc2_++;
         }
      }
      
      private function closeRewardList(param1:MouseEvent) : void
      {
         this.rewardMc.visible = false;
         this.eventHandler.removeListener(this.rewardMc.btn_close,MouseEvent.CLICK,this.closeRewardList);
         var _loc2_:int = 0;
         while(_loc2_ < this.rewardData.length)
         {
            GF.removeAllChild(this.rewardMc["iconMC" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.rewardMc["iconMC" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         this.main = null;
         this.response = null;
         this.obtainedReward = null;
         this.rewardData = [];
         this.grandPrizeData = [];
         this.selectedScratch = -1;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.escapeKey.destroy();
         this.escapeKey = null;
         GF.removeAllChild(this);
         System.gc();
      }
   }
}

