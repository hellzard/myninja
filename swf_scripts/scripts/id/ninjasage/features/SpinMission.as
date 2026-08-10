package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.system.System;
   import flash.utils.Timer;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class SpinMission extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var response:Object;
      
      private var chance:Object;
      
      private var rewardsArray:Array = [];
      
      private var rewardsQty:Array = [];
      
      private var timeArray:Array;
      
      private var loopPosition:int;
      
      private var loopPositionMax:int = 6;
      
      private var timer:Timer;
      
      private var itemGet:String;
      
      public function SpinMission(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.hide);
         this.eventHandler = new EventHandler();
         this.onShow();
         this.panelMC.addFrameScript(8,this.frame9,14,this.frame15);
      }
      
      public function onShow() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.DJHBpvXqOXfi",[Character.char_id,Character.sessionkey],this.onGetData);
      }
      
      public function onGetData(param1:Object) : *
      {
         var _loc2_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.rewards.length)
            {
               this.rewardsArray.push(param1.rewards[_loc2_].id);
               this.rewardsQty.push(param1.rewards[_loc2_].qty);
               if(this.rewardsArray[_loc2_].indexOf("gold_") >= 0 || this.rewardsArray[_loc2_].indexOf("tokens_") >= 0 || this.rewardsArray[_loc2_].indexOf("tp_") >= 0 || this.rewardsArray[_loc2_].indexOf("xp_") >= 0 || this.rewardsArray[_loc2_].indexOf("ss_") >= 0)
               {
                  this.rewardsQty[_loc2_] = null;
               }
               _loc2_++;
            }
            this.chance = param1.spin;
            this.panelMC.gotoAndPlay(1);
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
            this.hide();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function initUI() : *
      {
         this.panelMC.panel.titleTxt.text = "Grade S Mission Reward";
         this.panelMC.panel.chanceTxt.text = "Chance: " + this.chance.chance + "/" + this.chance.max;
         var _loc1_:* = 0;
         while(_loc1_ < this.rewardsArray.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.panel["iconMc2_" + _loc1_].rewardIcon.iconHolder,this.rewardsArray[_loc1_],"icon");
            this.panelMC.panel["iconMc2_" + _loc1_].amountTxt.text = this.rewardsQty[_loc1_] == null ? "" : "x" + this.rewardsQty[_loc1_];
            this.panelMC.panel["iconMc2_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         this.eventHandler.addListener(this.panelMC.panel.btnClose,MouseEvent.CLICK,this.hide);
         this.eventHandler.addListener(this.panelMC.panel.btnSpin,MouseEvent.CLICK,this.getReward);
      }
      
      public function getReward(param1:MouseEvent) : *
      {
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.suoAZwzxJfbx",[Character.char_id,Character.sessionkey],this.startSpin);
      }
      
      public function startSpin(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(param1.status == 1)
         {
            this.response = param1;
            this.itemGet = this.response.reward;
            _loc2_ = this.itemGet.split(":");
            if(this.rewardsArray.indexOf(_loc2_[0]) < 0)
            {
               this.main.showMessage("Reward not found");
               return;
            }
            this.timeArray = this.getTimeArray(this.rewardsArray.indexOf(_loc2_[0]));
            this.loopPosition = -1;
            this.timeUp();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function timeUp(param1:TimerEvent = null) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:int = 0;
         if(this.timer)
         {
            this.timer.stop();
         }
         _loc2_ = 0;
         while(_loc2_ < this.loopPositionMax)
         {
            this.panelMC.panel["iconMc2_" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         if(this.loopPosition >= 0)
         {
            this.panelMC.panel["iconMc2_" + this.loopPosition].gotoAndStop(2);
         }
         if(this.timeArray.length > 0)
         {
            ++this.loopPosition;
            if(this.loopPosition >= this.loopPositionMax)
            {
               this.loopPosition = 0;
            }
            this.timer = new Timer(this.timeArray.shift());
            this.eventHandler.addListener(this.timer,TimerEvent.TIMER,this.timeUp);
            this.timer.start();
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.rewardsArray.length)
            {
               this.panelMC.panel["iconMc2_" + _loc2_].gotoAndStop(1);
               _loc2_++;
            }
            _loc3_ = this.itemGet.split(":");
            Character.addRewards(this.itemGet);
            this.main.HUD.setBasicData();
            --this.chance.chance;
            this.panelMC.panel.chanceTxt.text = "Chance: " + this.chance.chance + "/" + this.chance.max;
            if(_loc3_[0].indexOf("gold_") >= 0 || _loc3_[0].indexOf("tokens_") >= 0 || _loc3_[0].indexOf("tp_") >= 0 || _loc3_[0].indexOf("xp_") >= 0 || _loc3_[0].indexOf("ss_") >= 0)
            {
               this.main.giveReward(1,_loc3_[0]);
            }
            else
            {
               this.main.giveReward(1,_loc3_[0] + ":" + _loc3_[1]);
            }
         }
      }
      
      private function getTimeArray(param1:int) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         _loc2_ = 0;
         while((_loc2_ - 2) % 6 != param1 || Math.random() > 0.1 || _loc5_ < 10)
         {
            if((_loc2_ - 2) % 6 == param1)
            {
               _loc5_++;
            }
            _loc3_ += 0.001;
            _loc4_.push(int(1 / _loc3_));
            _loc2_++;
         }
         return _loc4_.reverse();
      }
      
      private function hide(param1:MouseEvent = null) : void
      {
         this.destroy();
      }
      
      internal function frame9() : *
      {
         this.initUI();
      }
      
      internal function frame15() : *
      {
         this.panelMC.stop();
      }
      
      internal function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.rewardsArray.length)
         {
            this.panelMC.panel["iconMc2_" + _loc1_].rewardIcon.iconHolder;
            _loc1_++;
         }
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.rewardsArray = [];
         this.timeArray = [];
         this.loopPosition = 0;
         this.loopPositionMax = 0;
         if(this.timer)
         {
            this.timer.stop();
         }
         this.timer = null;
         this.itemGet = null;
         this.chance = null;
         this.main = null;
         this.eventHandler = null;
         this.response = null;
         this.rewardsArray = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

