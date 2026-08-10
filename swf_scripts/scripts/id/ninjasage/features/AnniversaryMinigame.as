package id.ninjasage.features
{
   import Storage.Character;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AnniversaryMinigame extends MovieClip
   {
      
      protected var questionProp:Array = [];
      
      protected var lifes:int = 3;
      
      private var currentStage:int = 0;
      
      private var ans:int;
      
      private var initial:Array;
      
      private var choice:Array;
      
      private var selectedAns:int = -1;
      
      private var rightAns:int = 0;
      
      private var wrongAns:int = 0;
      
      private var timeToNextStage:Timer;
      
      private var stageTimer:Timer;
      
      protected var allCards:Array = [0,1,2,3,4,5,6,7,8,9];
      
      public var main:*;
      
      public var panelMC:MovieClip;
      
      public function AnniversaryMinigame(param1:*, param2:*)
      {
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.panelMC.addFrameScript(25,this.onStart,28,this.onStop);
         this.questionProp.push({
            "lv":1,
            "cards":2,
            "time":6
         });
         this.questionProp.push({
            "lv":2,
            "cards":2,
            "time":6
         });
         this.questionProp.push({
            "lv":3,
            "cards":3,
            "time":6
         });
         this.questionProp.push({
            "lv":4,
            "cards":3,
            "time":6
         });
         this.questionProp.push({
            "lv":5,
            "cards":4,
            "time":6
         });
         this.questionProp.push({
            "lv":6,
            "cards":4,
            "time":6
         });
         this.questionProp.push({
            "lv":7,
            "cards":5,
            "time":6
         });
         this.questionProp.push({
            "lv":8,
            "cards":5,
            "time":6
         });
         this.questionProp.push({
            "lv":9,
            "cards":5,
            "time":6
         });
         this.questionProp.push({
            "lv":10,
            "cards":5,
            "time":6
         });
         super();
      }
      
      public function onStart() : void
      {
         this.panelMC.stop();
         this.panelMC["instruction_mc"].gotoAndStop("show");
         this.showInstruction();
         this.panelMC["btn_next"].visible = false;
         this.main.initButton(this.panelMC["btnRequestMemberhelp"],this.showHelp,"");
         this.main.initButton(this.panelMC["backBtn"],this.exitMission,"");
      }
      
      public function showInstruction() : void
      {
         this.panelMC.instruction_mc["lbl_instruction_title"].text = "Instruction";
         this.panelMC.instruction_mc["lbl_instruction"].text = "Or";
         if(this.panelMC.currentLabel == "start")
         {
            this.panelMC.instruction_mc["btn_next"].visible = true;
            this.main.initButton(this.panelMC.instruction_mc["btn_next"],this.gotoExam,"Start");
            this.panelMC.instruction_mc["closeBtn"].visible = false;
         }
         else
         {
            this.panelMC.instruction_mc["btn_next"].visible = false;
            this.panelMC.instruction_mc["closeBtn"].visible = true;
            this.panelMC.instruction_mc["closeBtn"].addEventListener(MouseEvent.CLICK,this.closeHelp);
         }
      }
      
      private function closeHelp(param1:MouseEvent) : void
      {
         this.panelMC.instruction_mc.gotoAndStop("idle");
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         this.panelMC.instruction_mc.gotoAndStop("show");
         this.showInstruction();
      }
      
      private function gotoExam(param1:MouseEvent) : void
      {
         this.panelMC.gotoAndStop("exam");
         this.onExam();
      }
      
      protected function onExam() : void
      {
         this.panelMC.stop();
         var _loc1_:MovieClip = null;
         this.panelMC.instruction_mc.gotoAndStop("idle");
         this.selectedAns = -1;
         this.panelMC.txt_timmer.text = "";
         this.panelMC.txt_life.text = "Life:";
         this.panelMC.txt_round.text = "Question " + String(this.currentStage + 1);
         this.updateLife();
         this.restoreCards(this.panelMC);
         this.panelMC.rightSound.gotoAndStop(1);
         this.panelMC.wrongSound.gotoAndStop(1);
         this.panelMC.rightSound.addFrameScript(15,this.stopRightSound);
         this.panelMC.wrongSound.addFrameScript(11,this.stopWrongSound);
         this.panelMC.choice_0["marking"].text = "A.";
         this.panelMC.choice_1["marking"].text = "B.";
         this.panelMC.choice_2["marking"].text = "C.";
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = this.panelMC["choice_" + String(_loc2_)];
            _loc1_.gotoAndStop("idle");
            _loc1_["icon"].gotoAndStop(1);
            _loc1_.visible = true;
            this.restoreCards(this.panelMC["choice_" + String(_loc2_)]);
            _loc2_++;
         }
         this.panelMC.btn_next.visible = false;
         this.getQuestion();
      }
      
      private function restoreCards(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            param1["card_" + String(_loc2_)].visible = true;
            param1["card_" + String(_loc2_)].gotoAndStop(1);
            _loc2_++;
         }
      }
      
      private function getQuestion() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = int(this.questionProp[this.currentStage].cards);
         this.panelMC.btn_next.visible = false;
         this.initial = [];
         this.choice = [];
         if(_loc8_ == 2)
         {
            _loc2_ = [];
            _loc2_[0] = this.shuffleCards(this.allCards,_loc8_);
            _loc2_[1] = [_loc2_[0][1],_loc2_[0][0]];
            while(true)
            {
               _loc5_ = Math.floor(NumberUtil.randomInt(0,this.allCards.length - 0.01));
               if(!(_loc5_ == _loc2_[0][0] || _loc5_ == _loc2_[0][1]))
               {
                  break;
               }
            }
            _loc2_[2] = [0,_loc5_];
            _loc6_ = NumberUtil.getRandom();
            if(_loc6_ > 0.5)
            {
               _loc2_[2][0] = _loc2_[0][0];
            }
            else
            {
               _loc2_[2][0] = _loc2_[0][1];
            }
            _loc6_ = NumberUtil.getRandom();
            if(_loc6_ > 0.5)
            {
               _loc2_[2][1] = _loc2_[2][0];
               _loc2_[2][0] = _loc5_;
            }
            this.choice = this.shuffleCards(_loc2_,3);
            _loc7_ = 0;
            while(_loc7_ < 3)
            {
               if(this.choice[_loc7_] == _loc2_[0])
               {
                  this.ans = _loc7_;
               }
               _loc7_++;
            }
         }
         else
         {
            this.initial = this.shuffleCards(this.allCards,_loc8_);
            this.choice.push(this.initial);
            do
            {
               this.choice[1] = this.shuffleCards(this.initial,_loc8_);
            }
            while(this.sameArray(this.choice[1],this.choice[0]));
            do
            {
               this.choice[2] = this.shuffleCards(this.initial,_loc8_);
            }
            while(this.sameArray(this.choice[2],this.choice[0]) || this.sameArray(this.choice[2],this.choice[1]));
            this.ans = Math.floor(NumberUtil.randomInt(0,2.99));
         }
         this.showQuestion();
      }
      
      private function sameArray(param1:Array, param2:Array) : Boolean
      {
         if(param1.length != param2.length)
         {
            return false;
         }
         var _loc3_:int = 1;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != param2[_loc3_])
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function showQuestion() : void
      {
         this.listCards(this.panelMC,this.choice[this.ans]);
         this.listCards(this.panelMC.choice_0,this.choice[0]);
         this.listCards(this.panelMC.choice_1,this.choice[1]);
         this.listCards(this.panelMC.choice_2,this.choice[2]);
         this.panelMC.choice_0.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverChoice);
         this.panelMC.choice_1.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverChoice);
         this.panelMC.choice_2.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverChoice);
         this.panelMC.choice_0.addEventListener(MouseEvent.CLICK,this.onMouseClickChoice);
         this.panelMC.choice_1.addEventListener(MouseEvent.CLICK,this.onMouseClickChoice);
         this.panelMC.choice_2.addEventListener(MouseEvent.CLICK,this.onMouseClickChoice);
         this.stageTimer = new Timer(1000,this.questionProp[this.currentStage].time);
         this.stageTimer.addEventListener(TimerEvent.TIMER,this.tickTimer);
         this.stageTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timesUp);
         this.stageTimer.start();
         this.panelMC.txt_timmer.text = String(this.questionProp[this.currentStage].time);
      }
      
      private function tickTimer(param1:TimerEvent) : void
      {
         this.panelMC.txt_timmer.text = String(int(this.panelMC.txt_timmer.text) - 1);
      }
      
      private function timesUp(param1:TimerEvent) : void
      {
         this.panelMC.txt_timmer.text = String(0);
         this.onResult();
      }
      
      private function onMouseOverChoice(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         _loc2_.gotoAndStop("over");
         _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutChoice);
      }
      
      private function onMouseOutChoice(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         _loc2_.gotoAndStop("idle");
      }
      
      private function onMouseClickChoice(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         this.stageTimer.stop();
         _loc2_.gotoAndStop("select");
         this.selectedAns = int(String(param1.currentTarget.name).replace("choice_",""));
         this.onResult();
      }
      
      private function onResult() : void
      {
         var j:int;
         var i:int = 0;
         i = 0;
         var choiceMC:MovieClip = null;
         this.stageTimer.stop();
         j = 0;
         while(j < 3)
         {
            choiceMC = this.panelMC["choice_" + String(j)];
            choiceMC.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverChoice);
            choiceMC.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutChoice);
            choiceMC.removeEventListener(MouseEvent.CLICK,this.onMouseClickChoice);
            j++;
         }
         if(this.selectedAns == this.ans)
         {
            this.panelMC["choice_" + String(this.ans)]["icon"].gotoAndStop("right");
            this.panelMC["choice_" + String(this.ans)]["icon"]["mc"].addFrameScript(15,function():void
            {
               panelMC["choice_" + String(this.ans)]["icon"]["mc"].stop();
            });
            i = 0;
            while(i < 3)
            {
               if(i != this.ans)
               {
                  this.panelMC["choice_" + String(i)].visible = false;
               }
               i++;
            }
            this.panelMC.rightSound.gotoAndPlay(1);
            ++this.rightAns;
         }
         else
         {
            i = 0;
            while(i < 3)
            {
               if(i != this.ans)
               {
                  this.panelMC["choice_" + String(i)]["icon"].gotoAndStop("wrong");
                  this.panelMC["choice_" + String(i)]["icon"]["mc"].addFrameScript(15,function():void
                  {
                     panelMC["choice_" + String(i)]["icon"]["mc"].stop();
                  });
               }
               else
               {
                  this.panelMC["choice_" + String(i)]["icon"].gotoAndStop("right");
                  this.panelMC["choice_" + String(i)]["icon"]["mc"].addFrameScript(15,function():void
                  {
                     panelMC["choice_" + String(i)]["icon"]["mc"].stop();
                  });
               }
               i++;
            }
            this.panelMC.wrongSound.gotoAndPlay(1);
            ++this.wrongAns;
            this.updateLife();
         }
         if(this.currentStage == 9 && this.rightAns >= this.questionProp.length - this.lifes)
         {
            this.timeToNextStage = new Timer(1000,2);
            this.timeToNextStage.addEventListener(TimerEvent.TIMER_COMPLETE,this.gotoSuccess);
            this.timeToNextStage.start();
         }
         else if(this.wrongAns > this.lifes)
         {
            this.timeToNextStage = new Timer(1000,2);
            this.timeToNextStage.addEventListener(TimerEvent.TIMER_COMPLETE,this.failedFinishExam);
            this.timeToNextStage.start();
         }
         else
         {
            this.timeToNextStage = new Timer(1000,2);
            this.timeToNextStage.addEventListener(TimerEvent.TIMER_COMPLETE,this.goInitStage);
            this.timeToNextStage.start();
         }
      }
      
      private function gotoSuccess(param1:TimerEvent) : void
      {
         this.panelMC.gotoAndStop("success");
         this.panelMC.successMc.addFrameScript(21,this.successLblTitle);
         this.panelMC.successMc.addFrameScript(41,this.onCheckResult);
      }
      
      private function updateLife() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ <= 3)
         {
            this.panelMC["mc_heart_" + String(_loc1_)].gotoAndStop("full");
            _loc1_++;
         }
         var _loc2_:* = this.lifes;
         while(_loc2_ > this.lifes - this.wrongAns)
         {
            if(_loc2_ > 0)
            {
               this.panelMC["mc_heart_" + String(_loc2_)].gotoAndStop("empty");
            }
            _loc2_--;
         }
      }
      
      private function goInitStage(param1:TimerEvent) : void
      {
         ++this.currentStage;
         this.onExam();
      }
      
      private function listCards(param1:MovieClip, param2:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         switch(param2.length)
         {
            case 2:
               param1["card_0"].visible = false;
               param1["card_3"].visible = false;
               param1["card_4"].visible = false;
               _loc4_ = 1;
            case 3:
               param1["card_0"].visible = false;
               param1["card_4"].visible = false;
               _loc4_ = 1;
               break;
            case 4:
               param1["card_4"].visible = false;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc3_ = "card_" + String(_loc5_ + _loc4_);
            param1[_loc3_].gotoAndStop(param2[_loc5_] + 2);
            _loc5_++;
         }
      }
      
      private function shuffleCards(param1:Array, param2:int) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_.push(param1[_loc3_]);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = Math.floor(NumberUtil.randomInt(0,_loc5_.length - 0.01));
            _loc6_.push(_loc5_[_loc4_]);
            _loc5_.splice(_loc4_,1);
            _loc3_++;
         }
         return _loc6_;
      }
      
      protected function onCheckResult() : void
      {
         this.panelMC.successMc.stop();
         this.timeToNextStage = new Timer(1000,2);
         this.timeToNextStage.addEventListener(TimerEvent.TIMER_COMPLETE,this.sucessfullyFinishExam);
         this.timeToNextStage.start();
      }
      
      private function failedFinishExam(param1:TimerEvent) : void
      {
         this.stopStageTimer();
         this.stopTimeToNextStage();
         this.main.loading(true);
         var _loc2_:String = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.char_id) + "|" + String(Character.sessionkey) + "|" + String("lose") + "|" + String(Character.battle_code))));
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.fzNVyox5kcQU",[Character.char_id,Character.sessionkey,"lose",_loc2_],this.onExamFinished);
      }
      
      private function sucessfullyFinishExam(param1:TimerEvent) : void
      {
         this.stopStageTimer();
         this.stopTimeToNextStage();
         this.main.loading(true);
         var _loc2_:String = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.char_id) + "|" + String(Character.sessionkey) + "|" + String("win") + "|" + String(Character.battle_code))));
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.fzNVyox5kcQU",[Character.char_id,Character.sessionkey,"win",_loc2_],this.onExamFinished);
      }
      
      private function onExamFinished(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(param1.hasOwnProperty("rewards") && param1.rewards != null && param1.rewards.length > 0)
            {
               Character.addRewards(param1.rewards);
               this.main.giveReward(1,param1.rewards);
            }
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
         this.destroy();
      }
      
      private function exitMission(param1:MouseEvent = null) : void
      {
         var _loc2_:String = "Are you sure you want to exit the minigame?";
         this.main.showConfirmation(_loc2_,this.destroy);
      }
      
      private function failMission() : void
      {
         this.stopStageTimer();
         this.stopTimeToNextStage();
         this.destroy();
      }
      
      private function stopStageTimer() : void
      {
         if(this.stageTimer)
         {
            this.stageTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.goInitStage);
            this.stageTimer.stop();
            this.stageTimer.reset();
            this.stageTimer = null;
         }
      }
      
      private function stopTimeToNextStage() : void
      {
         if(this.timeToNextStage)
         {
            this.timeToNextStage.removeEventListener(TimerEvent.TIMER_COMPLETE,this.goInitStage);
            this.timeToNextStage.stop();
            this.timeToNextStage.reset();
            this.timeToNextStage = null;
         }
      }
      
      public function onStop() : *
      {
         this.panelMC.stop();
      }
      
      public function stopRightSound() : void
      {
         this.panelMC.rightSound.gotoAndStop(1);
      }
      
      public function stopWrongSound() : void
      {
         this.panelMC.wrongSound.gotoAndStop(1);
      }
      
      public function successLblTitle() : void
      {
         this.panelMC.successMc["lbl_success_title"].text = "Mission Success!";
      }
      
      public function destroy(param1:MouseEvent = null) : void
      {
         this.stopStageTimer();
         this.stopTimeToNextStage();
         this.main.loadVillageAndHUD();
         this.panelMC.rightSound.gotoAndStop(1);
         this.panelMC.wrongSound.gotoAndStop(1);
         GF.removeAllChild(this.panelMC);
         this.main = null;
         this.panelMC = null;
         this.questionProp = null;
         this.lifes = 0;
         this.currentStage = 0;
         this.ans = 0;
      }
   }
}

