package id.ninjasage.features
{
   import Managers.AppManager;
   import Storage.Character;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.Crew;
   import id.ninjasage.EventHandler;
   
   public class CrewMiniGame extends MovieClip
   {
       
      
      public var mc:MovieClip;
      
      private var currStage:int;
      
      private var isStart:Boolean = false;
      
      private const totalLevel:int = 3;
      
      private var correctStep:Array;
      
      private var clickedStep:int;
      
      private var isPlayed:Boolean = false;
      
      private var heartRemain:int = 3;
      
      private var calledFinishTime:int = 0;
      
      private var energyRefillRemainTime:int;
      
      private const TimeFree:int = 5;
      
      private const HeartFree:int = 10;
      
      private var energyRefillCounting:EnergyRefillSystem;
      
      private var levelData:Array;
      
      private var currStep:int;
      
      private var c;
      
      private var ts;
      
      public var eventHandler:EventHandler;
      
      public var main;
      
      public var crewParent;
      
      public function CrewMiniGame(param1:*, param2:*)
      {
         this.energyRefillCounting = new EnergyRefillSystem();
         this.main = AppManager.getInstance().main;
         this.crewParent = param1;
         this.eventHandler = new EventHandler();
         this.levelData = [{
            "level":1,
            "time":45,
            "size":9,
            "step":3
         },{
            "level":2,
            "time":30,
            "size":16,
            "step":4
         },{
            "level":3,
            "time":20,
            "size":25,
            "step":6
         }];
         this.mc = param2.panelMC;
         this.mc.addFrameScript(9,this.onShow,16,this.frame16,46,this.frame46);
         super();
      }
      
      private function loadPanelContent() : void
      {
         var _loc1_:* = undefined;
         this.mc.panelMc.stageLT.text = "Stage " + this.currStage + " / " + this.levelData.length;
         this.mc.panelMc.Token.myTokenTxt.text = Character.account_tokens;
         this.mc.panelMc.payPanel.costLabel.text = "Cost";
         this.mc.panelMc.payPanel.costTxt.text = this.TimeFree;
         this.mc.panelMc.heartBarMC.costLabel.text = "Cost";
         this.mc.panelMc.heartBarMC.costTxt.text = this.HeartFree;
         this.main.initButton(this.mc.panelMc.payPanel.confirmBtn,this.onClickBuyTime,"Buy");
         this.main.initButton(this.mc.panelMc.heartBarMC.confirmBtn,this.onClickBuyHeart,"Buy");
         if(this.currStage >= 1)
         {
            _loc1_ = 0;
            while(_loc1_ < this.levelData[this.currStage - 1].size)
            {
               this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + _loc1_].gotoAndStop("idle");
               this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + _loc1_].addFrameScript(0,this.createFrameScript1(_loc1_));
               this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + _loc1_].addFrameScript(21,this.createFrameScript1(_loc1_));
               this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + _loc1_].addFrameScript(22,this.createFrameScript2(_loc1_));
               this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + _loc1_].addFrameScript(30,this.createFrameScript1(_loc1_));
               this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + _loc1_].addFrameScript(14,this.showNextStep,30,this.nextStage);
               this.eventHandler.addListener(this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + _loc1_],MouseEvent.CLICK,this.onClickChooseStep);
               _loc1_++;
            }
         }
      }
      
      private function gameStart() : void
      {
         this.updateHeart();
         this.changeStage();
      }
      
      private function changeStage() : void
      {
         var _loc1_:int = 0;
         ++this.currStage;
         this.mc.panelMc["stageLogo"].visible = true;
         _loc1_ = 1;
         while(_loc1_ < this.totalLevel + 1)
         {
            this.mc.panelMc["mainGameStageMc" + _loc1_].visible = false;
            _loc1_++;
         }
         this.mc.panelMc["stageLogo"].gotoAndStop("stage" + this.currStage);
         this.mc.panelMc["stageLogo"]["logo" + this.currStage].addFrameScript(19,this.onStage);
         this.mc.panelMc["stageLogo"]["logo" + this.currStage].gotoAndPlay("show");
         this.mc.panelMc["timer"].text = this.levelData[this.currStage - 1].time + "s";
         this.loadPanelContent();
      }
      
      private function resetGameLevel() : void
      {
         var _loc1_:int = 0;
         this.correctStep = [];
         do
         {
            _loc1_ = this.random(0,this.levelData[this.currStage - 1].size);
            if(this.correctStep.indexOf(_loc1_) < 0)
            {
               this.correctStep.push(_loc1_);
            }
         }
         while(this.correctStep.length < this.levelData[this.currStage - 1].step);
         
         this.currStep = 0;
         this.isPlayed = false;
         this.showNextStep();
      }
      
      private function random(param1:int, param2:int) : int
      {
         var _loc3_:int = param2 - param1;
         return param1 + Math.random() * _loc3_;
      }
      
      public function showStep(param1:int) : void
      {
         this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + param1].gotoAndPlay("show");
      }
      
      public function createFrameScript1(param1:int) : Function
      {
         var position:int = param1;
         return function():void
         {
            stopStep(position);
         };
      }
      
      public function createFrameScript2(param1:int) : Function
      {
         var position:int = param1;
         return function():void
         {
            stopStepNow(position);
         };
      }
      
      public function stopStep(param1:int) : void
      {
         this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + param1].gotoAndStop(1);
      }
      
      public function stopStepNow(param1:int) : void
      {
         this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + param1].stop();
      }
      
      private function clearStage() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.correctStep.length)
         {
            this.mc.panelMc["mainGameStageMc" + this.currStage]["iconMc_" + this.correctStep[_loc1_]].gotoAndPlay("correct");
            _loc1_++;
         }
      }
      
      private function updateHeart() : void
      {
         this.mc.panelMc["heartBarMC"].gotoAndStop(4 - this.heartRemain);
         if(this.heartRemain == 0)
         {
            this.energyRefillCounting.stopTimer();
            this.finishGame();
         }
      }
      
      private function finishGame(param1:* = 0) : void
      {
         this.isPlayed = false;
         this.main.loading(true);
         var _loc2_:* = new Date().getTime();
         Crew.instance.finishMiniGame({
            "c":this.c,
            "t":this.ts,
            "r":param1,
            "n":_loc2_,
            "h":Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([this.c,this.ts,param1,_loc2_].join("|")))))
         },this.finishMiniGameRes);
      }
      
      private function finishMiniGameRes(param1:* = null, param2:* = null) : void
      {
         if(param1 != null && param1.hasOwnProperty("r") && param1.r != "")
         {
            this.main.loading(false);
            Character.addRewards(param1.r);
            this.main.giveReward(1,param1.r);
            this.crewParent.getMiniGameData();
            this.backToCrewWar();
         }
         else
         {
            this.main.loading(false);
            this.mc.panelMc["popupLose"].addFrameScript(4,this.onShowLost);
            this.mc.panelMc["popupLose"].gotoAndPlay("show");
         }
      }
      
      private function updateCounting() : void
      {
         --this.energyRefillRemainTime;
      }
      
      private function buyTime() : void
      {
         this.main.loading(true);
         this.energyRefillCounting.stopTimer();
         Crew.instance.buyMiniGame(1,this.buyTimeResponse);
      }
      
      private function buyTimeResponse(param1:* = null, param2:* = null) : void
      {
         this.main.loading(false);
         this.energyRefillCounting.startTimer(this.mc.panelMc,this.energyRefillRemainTime,this.finishGame,this.updateCounting,"[time]s");
         if(param1 != null && param1.hasOwnProperty("t"))
         {
            Character.account_tokens = param1.t;
            this.energyRefillRemainTime += 10;
            this.loadPanelContent();
         }
      }
      
      private function buyHeart() : void
      {
         this.main.loading(true);
         this.energyRefillCounting.stopTimer();
         Crew.instance.buyMiniGame(2,this.buyHeartResponse);
      }
      
      private function buyHeartResponse(param1:* = null, param2:* = null) : void
      {
         this.main.loading(false);
         this.energyRefillCounting.startTimer(this.mc.panelMc,this.energyRefillRemainTime,this.finishGame,this.updateCounting,"[time]s");
         if(param1 != null && param1.hasOwnProperty("t"))
         {
            Character.account_tokens = param1.t;
            this.heartRemain += 1;
            this.updateHeart();
            this.loadPanelContent();
         }
      }
      
      public function show() : void
      {
         this.gotoAndPlay("show");
      }
      
      public function onShow() : void
      {
         this.currStage = 0;
         this.mc.stop();
         var _loc1_:int = 1;
         while(_loc1_ < this.totalLevel + 1)
         {
            this.mc.panelMc["mainGameStageMc" + _loc1_].visible = false;
            _loc1_++;
         }
         this.mc.panelMc.heartBarMC.gotoAndStop(1);
         this.mc.panelMc["stageLogo"].visible = false;
         this.mc.panelMc["stageLogo"].gotoAndStop(1);
         this.mc.panelMc["popupWin"].gotoAndStop(1);
         this.mc.panelMc["popupWin"].addFrameScript(0,this.onStopWin);
         this.mc.panelMc["popupWin"].addFrameScript(19,this.onStopWinNow);
         this.mc.panelMc["popupWin"].addFrameScript(38,this.onStopWin);
         this.mc.panelMc["popupLose"].gotoAndStop(1);
         this.mc.panelMc["popupLose"].addFrameScript(0,this.onStopLose);
         this.mc.panelMc["popupLose"].addFrameScript(19,this.onStopLoseNow);
         this.mc.panelMc["popupLose"].addFrameScript(38,this.onStopLose);
         this.mc.panelMc["popUpGetReward"].gotoAndStop(1);
         this.mc.panelMc["popUpGetReward"].addFrameScript(0,this.onStopGetReward);
         this.mc.panelMc["popUpGetReward"].addFrameScript(5,this.onStopGetReward);
         this.mc.panelMc["popupTutorial"].addFrameScript(0,this.onStopTutorial);
         this.mc.panelMc["popupTutorial"].addFrameScript(11,this.onInitTutor);
         this.mc.panelMc["popupTutorial"].addFrameScript(37,this.onStopTutorial);
         this.mc.panelMc["popupTutorial"].gotoAndPlay("show");
      }
      
      public function onInitTutor() : void
      {
         this.mc.panelMc["stageLogo"].visible = false;
         this.mc.panelMc.popupTutorial.stop();
         this.mc.panelMc.popupTutorial.panel.titleTxt.text = "Game Tutorial";
         this.mc.panelMc.popupTutorial.panel.instMC.gotoAndStop(1);
         this.mc.panelMc.popupTutorial.panel.instMC.subTxt1.text = "Show the order \nof step";
         this.mc.panelMc.popupTutorial.panel.instMC.subTxt2.text = "Click the step \nby following order";
         this.mc.panelMc.popupTutorial.panel.instMC.subTxt3.text = "Show the order \nof step";
         this.mc.panelMc.popupTutorial.panel.instMC.subTxt4.text = "Click the step \nby following order";
         this.main.initButton(this.mc.panelMc.popupTutorial.panel.instMC.btnGo,this.onClickStart,"Start");
         this.eventHandler.addListener(this.mc.panelMc.popupTutorial.panel.btnClose,MouseEvent.CLICK,this.onClickHide);
         this.loadPanelContent();
      }
      
      public function onStopTutorial() : void
      {
         this.mc.panelMc["popupTutorial"].gotoAndStop(1);
      }
      
      public function onStopGetReward() : void
      {
         this.mc.panelMc["popUpGetReward"].gotoAndStop(1);
      }
      
      public function onStopWinNow() : void
      {
         this.mc.panelMc["popupWin"].stop();
      }
      
      public function onStopLoseNow() : void
      {
         this.mc.panelMc["popupLose"].stop();
      }
      
      public function onStopWinLogo() : void
      {
         this.mc.panelMc["popupWin"].panel.logo.stop();
      }
      
      public function onStopLoseLogo() : void
      {
         this.mc.panelMc["popupLose"].panel.logo.stop();
      }
      
      public function onStopWin() : void
      {
         this.mc.panelMc["popupWin"].gotoAndStop(1);
      }
      
      public function onStopLose() : void
      {
         this.mc.panelMc["popupLose"].gotoAndStop(1);
      }
      
      public function onStage() : void
      {
         this.isStart = true;
         this.mc.panelMc["mainGameStageMc" + this.currStage].visible = true;
         this.mc.panelMc["stageLogo"]["logo" + this.currStage].gotoAndStop("idle");
         this.mc.panelMc["stageLogo"].visible = false;
         this.resetGameLevel();
      }
      
      public function showNextStep() : void
      {
         if(this.currStep < int(this.levelData[this.currStage - 1].step))
         {
            this.showStep(this.correctStep[this.currStep]);
            ++this.currStep;
         }
         else
         {
            this.isPlayed = true;
            this.clickedStep = 0;
            this.energyRefillRemainTime = this.levelData[this.currStage - 1].time;
            this.energyRefillCounting.startTimer(this.mc.panelMc,this.energyRefillRemainTime,this.finishGame,this.updateCounting,"[time]s");
         }
      }
      
      public function backToCrewWar() : void
      {
         this.destroy();
      }
      
      public function nextStage() : void
      {
         ++this.calledFinishTime;
         if(this.calledFinishTime == int(this.levelData[this.currStage - 1].step))
         {
            if(this.currStage == 3)
            {
               this.finishGame(1);
               return;
            }
            this.mc.panelMc["popupWin"].addFrameScript(4,this.onShowWin);
            this.mc.panelMc["popupWin"].gotoAndPlay("show");
            this.calledFinishTime = 0;
         }
      }
      
      public function onShowWin() : void
      {
         this.mc.panelMc.popupWin.panel.titleTxt.text = "Stage Clear";
         this.mc.panelMc.popupWin.panel.stageTxt.text = "Congratulations!";
         this.mc.panelMc.popupWin.panel.logo.addFrameScript(21,this.onStopWinLogo);
         this.main.initButton(this.mc.panelMc.popupWin.panel.btnNext,this.onClickNextStage,"Next");
         this.loadPanelContent();
      }
      
      public function onShowLost() : void
      {
         this.mc.panelMc.popupLose.panel.titleTxt.text = "Mission Fail";
         this.mc.panelMc.popupLose.panel.detailTxt.text = "Sorry, please try again.";
         this.mc.panelMc.popupLose.panel.logo.addFrameScript(21,this.onStopLoseLogo);
         this.main.initButton(this.mc.panelMc.popupLose.panel.btnQuit,this.onClickHide,"OK");
         this.loadPanelContent();
      }
      
      private function onClickChooseStep(param1:MouseEvent) : void
      {
         if(!this.isPlayed)
         {
            return;
         }
         if(param1.currentTarget.currentLabel == "click")
         {
            return;
         }
         if(this.correctStep[this.clickedStep] == int(param1.currentTarget.name.replace("iconMc_","")))
         {
            param1.currentTarget.gotoAndPlay("click");
            ++this.clickedStep;
         }
         else
         {
            --this.heartRemain;
            this.updateHeart();
            this.mc.panelMc["popUpGetReward"].gotoAndPlay("show");
         }
         if(this.clickedStep == int(this.levelData[this.currStage - 1].step))
         {
            this.clearStage();
            this.energyRefillCounting.stopTimer();
         }
      }
      
      private function onClickNextStage(param1:MouseEvent) : void
      {
         this.changeStage();
         this.mc.panelMc["popupWin"].gotoAndPlay("exit");
      }
      
      private function onClickHide(param1:MouseEvent) : void
      {
         this.backToCrewWar();
      }
      
      private function onClickBuyTime(param1:MouseEvent) : void
      {
         if(!this.isPlayed)
         {
            this.main.showMessage("Please wait the game start");
            return;
         }
         this.buyTime();
      }
      
      private function onClickBuyHeart(param1:MouseEvent) : void
      {
         if(this.heartRemain == 3)
         {
            this.main.showMessage("Heart is full");
            return;
         }
         this.buyHeart();
      }
      
      private function onClickStart(param1:MouseEvent) : void
      {
         this.mc.panelMc["popupTutorial"].gotoAndStop(1);
         Crew.instance.startMiniGame(this.onStartRes);
      }
      
      private function onStartRes(param1:* = null, param2:* = null) : *
      {
         if(param1 != null && param1.hasOwnProperty("c"))
         {
            this.c = param1.c;
            this.ts = param1.t;
            this.mc.panelMc["popupTutorial"].gotoAndPlay("exit");
            this.gameStart();
         }
         else if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.showMessage(param1.errorMessage);
            this.backToCrewWar();
         }
         else
         {
            this.main.showMessage("Unable to start the game");
            this.backToCrewWar();
         }
      }
      
      private function onClickNextPage(param1:MouseEvent) : void
      {
         this.mc.panelMc["popupTutorial"]["instMC"].gotoAndStop(2);
         this.loadPanelContent();
      }
      
      private function onClickPrevPage(param1:MouseEvent) : void
      {
         this.mc.panelMc["popupTutorial"]["instMC"].gotoAndStop(1);
         this.loadPanelContent();
      }
      
      public function frame16() : *
      {
         this.mc.stop();
      }
      
      public function frame46() : *
      {
         this.mc.gotoAndStop("idle");
      }
      
      public function destroy() : *
      {
         if(this.energyRefillCounting)
         {
            this.energyRefillCounting.stopTimer();
         }
         this.crewParent.initStatusDisplay();
         this.main.HUD.setBasicData();
         GF.removeAllChild(this.mc);
         this.mc = null;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.levelData = null;
         this.energyRefillCounting = null;
         this.correctStep = null;
         this.crewParent = null;
      }
   }
}

import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.utils.Timer;

class EnergyRefillSystem
{
    
   
   private var energyTimer:Timer = null;
   
   private var slotHolder:MovieClip;
   
   private var energyTime:uint;
   
   private var remainingTime:int;
   
   private var cbFnComplete:Function;
   
   private var cbFnUpdate:Function;
   
   private var desText:String;
   
   public var updateSlot:Boolean = true;
   
   function EnergyRefillSystem()
   {
      super();
   }
   
   public function startTimer(param1:MovieClip, param2:int, param3:Function, param4:Function, param5:String) : *
   {
      var _loc6_:int = 0;
      var _loc7_:int = 0;
      var _loc8_:String = null;
      this.slotHolder = param1;
      this.remainingTime = param2;
      this.cbFnComplete = param3;
      this.cbFnUpdate = param4;
      this.desText = param5;
      if(this.remainingTime == 0)
      {
         this.cbFnComplete();
         return;
      }
      if(this.energyTimer == null)
      {
         this.slotHolder["timer"].visible = true;
         if((_loc6_ = int(this.remainingTime)) < 0)
         {
            _loc6_ = 0;
         }
         _loc7_ = Math.floor(_loc6_ / 60);
         _loc6_ %= 60;
         _loc7_ %= 60;
         _loc8_ = String(_loc7_ * 60 + _loc6_);
         if(this.updateSlot)
         {
            this.slotHolder["timer"].text = this.desText.replace("[time]",_loc8_);
         }
         this.energyTimer = new Timer(1000,this.remainingTime);
         this.energyTimer.addEventListener(TimerEvent.TIMER,this.onUpdateProgress);
         this.energyTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.energyTimer.start();
      }
   }
   
   private function onUpdateProgress(param1:TimerEvent) : void
   {
      var _loc2_:int = 0;
      var _loc3_:int = 0;
      var _loc4_:String = null;
      if(this.remainingTime > 0)
      {
         this.cbFnUpdate();
         --this.remainingTime;
      }
      if(this.slotHolder["timer"])
      {
         _loc2_ = int(this.remainingTime);
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         _loc3_ = Math.floor(_loc2_ / 60);
         _loc2_ %= 60;
         _loc3_ %= 60;
         _loc4_ = String(_loc3_ * 60 + _loc2_);
         if(this.updateSlot)
         {
            this.slotHolder["timer"].text = this.desText.replace("[time]",_loc4_);
         }
      }
   }
   
   private function onTimerComplete(param1:TimerEvent) : void
   {
      if(this.cbFnComplete != null)
      {
         this.stopTimer();
         this.cbFnComplete();
      }
   }
   
   public function stopTimer() : *
   {
      if(this.energyTimer != null)
      {
         this.energyTimer.reset();
         this.energyTimer.stop();
         this.energyTimer = null;
      }
   }
   
   private function checkDigits(param1:int) : String
   {
      if(param1.toString().length < 2)
      {
         return "0" + param1.toString();
      }
      return param1.toString();
   }
}
