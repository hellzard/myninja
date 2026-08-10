package id.ninjasage.features.exam.jounin.stage1
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.*;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class Mission_132 extends MovieClip
   {
      
      public static var turn_timer:Timer = null;
      
      public static var turn_timer_seconds:int = 19;
      
      public static var turn_stage:int = 1;
      
      public var main:*;
      
      public var questions:* = [];
      
      public var arrCards:* = [];
      
      protected var curQuestion:*;
      
      protected var currentQuestionNumber:uint = 0;
      
      protected var questionPool:* = [];
      
      protected var answers:* = [];
      
      protected var userAnswers:* = [];
      
      protected var randNum:* = 0;
      
      protected var iconOffset:int = 0;
      
      protected var skillId:* = "";
      
      protected var dimFilter:*;
      
      private var win:* = false;
      
      private var completedQuestion:* = 0;
      
      private var heart:* = 3;
      
      public var langFile:*;
      
      public var panelMC:*;
      
      public function Mission_132(param1:* = null, param2:* = null)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.langFile = new Mission_132_Language();
         this.showDialogue();
         this.dimFilter = getSaturationFilter(0);
         this.panelMC.btn_1.gotoAndStop(12);
         this.panelMC.btn_2.gotoAndStop(12);
         this.panelMC.btn_3.gotoAndStop(12);
         this.panelMC.btn_4.gotoAndStop(12);
         this.panelMC.btn_5.gotoAndStop(12);
         this.panelMC.btn_6.gotoAndStop(12);
         this.panelMC.btn_7.gotoAndStop(12);
         this.panelMC.btn_8.gotoAndStop(12);
         this.panelMC.btn_9.gotoAndStop(12);
         this.panelMC.btn_10.gotoAndStop(12);
         this.questions.push({
            "lv":1,
            "c":[2,8],
            "skill":13
         });
         this.questions.push({
            "lv":1,
            "c":[1,3],
            "skill":16
         });
         this.questions.push({
            "lv":1,
            "c":[6,0],
            "skill":10
         });
         this.questions.push({
            "lv":1,
            "c":[7,4],
            "skill":20
         });
         this.questions.push({
            "lv":1,
            "c":[8,5],
            "skill":"01"
         });
         this.questions.push({
            "lv":1,
            "c":[4,9],
            "skill":38
         });
         this.questions.push({
            "lv":1,
            "c":[5,2],
            "skill":12
         });
         this.questions.push({
            "lv":1,
            "c":[0,6],
            "skill":34
         });
         this.questions.push({
            "lv":1,
            "c":[4,2],
            "skill":"09"
         });
         this.questions.push({
            "lv":1,
            "c":[9,3],
            "skill":24
         });
         this.questions.push({
            "lv":2,
            "c":[7,1],
            "skill":"06"
         });
         this.questions.push({
            "lv":2,
            "c":[5,8],
            "skill":17
         });
         this.questions.push({
            "lv":2,
            "c":[9,5],
            "skill":28
         });
         this.questions.push({
            "lv":2,
            "c":[6,2],
            "skill":11
         });
         this.questions.push({
            "lv":2,
            "c":[4,3],
            "skill":14
         });
         this.questions.push({
            "lv":2,
            "c":[8,6],
            "skill":25
         });
         this.questions.push({
            "lv":2,
            "c":[2,7],
            "skill":"07"
         });
         this.questions.push({
            "lv":2,
            "c":[7,3],
            "skill":31
         });
         this.questions.push({
            "lv":2,
            "c":[3,9],
            "skill":22
         });
         this.questions.push({
            "lv":2,
            "c":[6,4],
            "skill":33
         });
         this.questions.push({
            "lv":3,
            "c":[2,3,6,8],
            "skill":29
         });
         this.questions.push({
            "lv":3,
            "c":[2,6,1,9],
            "skill":30
         });
         this.questions.push({
            "lv":3,
            "c":[0,9,1,7],
            "skill":19
         });
         this.questions.push({
            "lv":3,
            "c":[4,6,7,0],
            "skill":18
         });
         this.questions.push({
            "lv":3,
            "c":[7,3,2,8],
            "skill":"05"
         });
         this.questions.push({
            "lv":3,
            "c":[9,3,8,4],
            "skill":15
         });
         this.questions.push({
            "lv":3,
            "c":[6,0,7,2],
            "skill":32
         });
         this.questions.push({
            "lv":3,
            "c":[2,6,1,0],
            "skill":44
         });
         this.questions.push({
            "lv":3,
            "c":[4,9,5,1],
            "skill":23
         });
         this.questions.push({
            "lv":3,
            "c":[5,6,8,1],
            "skill":25
         });
         this.questions.push({
            "lv":4,
            "c":[0,7,3,5,1,2],
            "skill":45
         });
         this.questions.push({
            "lv":4,
            "c":[3,2,9,6,1,4],
            "skill":46
         });
         this.questions.push({
            "lv":4,
            "c":[9,2,8,5,1,3],
            "skill":21
         });
         this.questions.push({
            "lv":4,
            "c":[3,5,9,7,8,2],
            "skill":47
         });
         this.questions.push({
            "lv":4,
            "c":[6,2,7,3,4,1],
            "skill":27
         });
         this.questions.push({
            "lv":4,
            "c":[2,9,1,6,5,3],
            "skill":49
         });
         this.questions.push({
            "lv":4,
            "c":[9,4,3,5,2,8],
            "skill":48
         });
         this.questions.push({
            "lv":4,
            "c":[3,5,8,0,9,4],
            "skill":50
         });
         this.questions.push({
            "lv":4,
            "c":[8,6,9,2,7,1],
            "skill":40
         });
         this.questions.push({
            "lv":4,
            "c":[1,5,4,0,9,2],
            "skill":51
         });
         this.questions.push({
            "lv":5,
            "c":[1,4,6,7,3,0,5,2],
            "skill":52
         });
         this.questions.push({
            "lv":5,
            "c":[2,6,5,9,1,0,7,4],
            "skill":67
         });
         this.questions.push({
            "lv":5,
            "c":[8,4,5,7,9,2,1,3],
            "skill":53
         });
         this.questions.push({
            "lv":5,
            "c":[7,4,6,8,3,0,2,9],
            "skill":70
         });
         this.questions.push({
            "lv":5,
            "c":[4,7,5,8,3,0,9,1],
            "skill":54
         });
         this.questions.push({
            "lv":5,
            "c":[1,8,5,7,9,2,3,4],
            "skill":71
         });
         this.questions.push({
            "lv":5,
            "c":[1,3,5,4,9,2,7,6],
            "skill":55
         });
         this.questions.push({
            "lv":5,
            "c":[2,4,9,8,3,0,1,5],
            "skill":72
         });
         this.questions.push({
            "lv":5,
            "c":[2,0,6,8,5,7,3,9],
            "skill":56
         });
         this.questions.push({
            "lv":5,
            "c":[6,3,5,0,9,2,4,8],
            "skill":73
         });
         this.questions.push({
            "lv":6,
            "c":[7,8,6,1,4,5,2,3,9,0],
            "skill":74
         });
         this.questions.push({
            "lv":6,
            "c":[4,9,3,6,7,1,0,2,5,8],
            "skill":65
         });
         this.questions.push({
            "lv":6,
            "c":[8,9,5,1,3,2,0,4,6,7],
            "skill":75
         });
         this.questions.push({
            "lv":6,
            "c":[6,3,0,4,1,8,2,5,7,9],
            "skill":66
         });
         this.questions.push({
            "lv":6,
            "c":[9,6,4,2,3,7,1,5,8,0],
            "skill":76
         });
         this.questions.push({
            "lv":6,
            "c":[7,5,6,2,8,1,0,3,4,9],
            "skill":63
         });
         this.questions.push({
            "lv":6,
            "c":[3,0,6,8,7,4,1,2,5,9],
            "skill":77
         });
         this.questions.push({
            "lv":6,
            "c":[4,5,1,6,9,2,3,7,8,0],
            "skill":64
         });
         this.questions.push({
            "lv":6,
            "c":[0,7,2,1,6,4,3,5,9,8],
            "skill":78
         });
         this.questions.push({
            "lv":6,
            "c":[0,4,5,9,7,6,2,1,3,8],
            "skill":69
         });
      }
      
      public static function getSaturationFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:* = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0];
         _loc2_[0] = (1 - param1) * 0.3086 + param1;
         _loc2_[1] = (1 - param1) * 0.6094;
         _loc2_[2] = (1 - param1) * 0.082;
         _loc2_[5] = (1 - param1) * 0.3086;
         _loc2_[6] = (1 - param1) * 0.6094 + param1;
         _loc2_[7] = (1 - param1) * 0.082;
         _loc2_[10] = (1 - param1) * 0.3086;
         _loc2_[11] = (1 - param1) * 0.6094;
         _loc2_[12] = (1 - param1) * 0.082 + param1;
         _loc2_[18] = 1;
         return new ColorMatrixFilter(_loc2_);
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.langFile.textArr[0]];
         this.main.showDialogue(_loc1_,this.showDialogue2,"yudai");
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.langFile.textArr[1]];
         this.main.showDialogue(_loc1_,this.showDialogue3,"yudai");
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.langFile.textArr[2]];
         this.main.showDialogue(_loc1_,this.showDialogue4,"mizukage");
      }
      
      public function showDialogue4() : *
      {
         var _loc1_:* = [this.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,this.showDialogue5,"kazekage");
      }
      
      public function showDialogue5() : *
      {
         var _loc1_:* = [this.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.showDialogue6,"raikage");
      }
      
      public function showDialogue6() : *
      {
         var _loc1_:* = [this.langFile.textArr[5]];
         this.main.showDialogue(_loc1_,this.showDialogue7,"tsuchikage");
      }
      
      public function showDialogue7() : *
      {
         var _loc1_:* = [this.langFile.textArr[6]];
         this.main.showDialogue(_loc1_,this.showDialogue8,"yudai");
      }
      
      public function showDialogue8() : *
      {
         var _loc1_:* = [this.langFile.textArr[7]];
         this.main.showDialogue(_loc1_,this.showDialogue9,"shin");
      }
      
      public function showDialogue9() : *
      {
         var _loc1_:* = [this.langFile.textArr[8]];
         this.main.showDialogue(_loc1_,this.initialScreen,"shin");
      }
      
      public function showDialoguePass() : *
      {
         var _loc1_:* = [this.langFile.textArr[9]];
         this.main.showDialogue(_loc1_,this.finishStage6,"shin");
      }
      
      public function showDialogueFail() : *
      {
         var _loc1_:* = [this.langFile.textArr[10]];
         this.main.showDialogue(_loc1_,this.backToVillage,"shin");
      }
      
      public function initialScreen() : *
      {
         this.panelMC.txt_round.text = "Skill: 1 / 6";
         this.panelMC.helpmc.visible = false;
         this.resetStartButton();
         this.panelMC.mc_heart_1.gotoAndStop(1);
         this.panelMC.mc_heart_2.gotoAndStop(1);
         this.panelMC.mc_heart_3.gotoAndStop(1);
         this.currentQuestionNumber = 1;
         this.resetQuestion();
      }
      
      private function resetQuestion() : *
      {
         if(this.heart < 1)
         {
            return;
         }
         var _loc1_:* = 0;
         this.questionPool = [];
         while(_loc1_ < this.questions.length)
         {
            if(this.questions[_loc1_].lv == this.currentQuestionNumber)
            {
               this.questionPool.push(this.questions[_loc1_]);
            }
            _loc1_++;
         }
         this.randNum = this.randomRange(0,this.questionPool.length - 1);
         this.curQuestion = this.questionPool.splice(this.randNum,1)[0];
         _loc1_ = 0;
         while(_loc1_ < this.curQuestion.c.length)
         {
            this.curQuestion.c[_loc1_] += 1;
            _loc1_++;
         }
         this.answers = this.curQuestion.c;
         this.initAllIconButtons();
         this.skillId = "skill_" + this.curQuestion.skill;
         var _loc2_:* = this.main.getSkillLibrary();
         var _loc3_:* = _loc2_.getSkillInfo(this.skillId);
         this.panelMC.txt_skillname.text = _loc3_.skill_name;
         this.iconOffset = 5 - Math.floor((this.answers.length - 1) / 2);
         if(this.iconOffset <= 0)
         {
            this.iconOffset = 1;
         }
         _loc1_ = 0;
         while(_loc1_ < this.answers.length)
         {
            this.panelMC["icon_" + String(_loc1_ + this.iconOffset)].gotoAndStop(11);
            _loc1_++;
         }
         this.main.getSkillIcon(this.skillId,this.panelMC.skill_icon.iconHolder);
      }
      
      private function resetStartButton() : *
      {
         this.panelMC.mc_Result.gotoAndStop(6);
         if(!this.panelMC.mc_Result.hasEventListener(MouseEvent.CLICK))
         {
            this.panelMC.mc_Result.addEventListener(MouseEvent.CLICK,this.startExam,false,0,true);
         }
      }
      
      private function hideAnswers() : *
      {
         var _loc1_:* = 1;
         var _loc2_:* = 1;
         if(this.answers.length == 2)
         {
            _loc1_ = 5;
            _loc2_ = 6;
         }
         else if(this.answers.length == 4)
         {
            _loc1_ = 4;
            _loc2_ = 7;
         }
         else if(this.answers.length == 6)
         {
            _loc1_ = 3;
            _loc2_ = 8;
         }
         else if(this.answers.length == 8)
         {
            _loc1_ = 2;
            _loc2_ = 9;
         }
         else
         {
            _loc1_ = 1;
            _loc2_ = 10;
         }
         while(_loc1_ <= _loc2_)
         {
            this.panelMC["icon_" + _loc1_].visible = true;
            this.panelMC["icon_" + _loc1_].buttonMode = false;
            this.panelMC["icon_" + _loc1_].gotoAndStop(12);
            _loc1_++;
         }
      }
      
      private function initAllIconButtons() : void
      {
         this.panelMC.mc_Result.gotoAndStop(6);
         var _loc1_:* = 1;
         while(_loc1_ < 11)
         {
            this.panelMC["icon_" + String(_loc1_)].visible = false;
            this.panelMC["btn_" + String(_loc1_)].buttonMode = false;
            this.panelMC["btn_" + String(_loc1_)].gotoAndStop(12);
            this.panelMC["btn_" + String(_loc1_)].filters = null;
            _loc1_++;
         }
         this.hideAnswers();
      }
      
      private function startExam(param1:MouseEvent) : *
      {
         this.panelMC.mc_Result.gotoAndStop(1);
         setTimeout(this.getExam,500);
      }
      
      private function getExam() : *
      {
         this.panelMC.mc_Result.gotoAndStop(2);
         this.panelMC.mc_Result.txt_timmer.text = String(this.getMaxTime());
         this.startTurnTimer();
         var _loc1_:* = this.getRandomSequence(1,10);
         if(this.answers.length == 2)
         {
            this.panelMC.icon_5.gotoAndStop(this.answers[0]);
            this.panelMC.icon_6.gotoAndStop(this.answers[1]);
         }
         else if(this.answers.length == 4)
         {
            this.panelMC.icon_4.gotoAndStop(this.answers[0]);
            this.panelMC.icon_5.gotoAndStop(this.answers[1]);
            this.panelMC.icon_6.gotoAndStop(this.answers[2]);
            this.panelMC.icon_7.gotoAndStop(this.answers[3]);
         }
         else if(this.answers.length == 6)
         {
            this.panelMC.icon_3.gotoAndStop(this.answers[0]);
            this.panelMC.icon_4.gotoAndStop(this.answers[1]);
            this.panelMC.icon_5.gotoAndStop(this.answers[2]);
            this.panelMC.icon_6.gotoAndStop(this.answers[3]);
            this.panelMC.icon_7.gotoAndStop(this.answers[4]);
            this.panelMC.icon_8.gotoAndStop(this.answers[5]);
         }
         else if(this.answers.length == 8)
         {
            this.panelMC.icon_2.gotoAndStop(this.answers[0]);
            this.panelMC.icon_3.gotoAndStop(this.answers[1]);
            this.panelMC.icon_4.gotoAndStop(this.answers[2]);
            this.panelMC.icon_5.gotoAndStop(this.answers[3]);
            this.panelMC.icon_6.gotoAndStop(this.answers[4]);
            this.panelMC.icon_7.gotoAndStop(this.answers[5]);
            this.panelMC.icon_8.gotoAndStop(this.answers[6]);
            this.panelMC.icon_9.gotoAndStop(this.answers[7]);
         }
         else if(this.answers.length == 10)
         {
            this.panelMC.icon_1.gotoAndStop(this.answers[0]);
            this.panelMC.icon_2.gotoAndStop(this.answers[1]);
            this.panelMC.icon_3.gotoAndStop(this.answers[2]);
            this.panelMC.icon_4.gotoAndStop(this.answers[3]);
            this.panelMC.icon_5.gotoAndStop(this.answers[4]);
            this.panelMC.icon_6.gotoAndStop(this.answers[5]);
            this.panelMC.icon_7.gotoAndStop(this.answers[6]);
            this.panelMC.icon_8.gotoAndStop(this.answers[7]);
            this.panelMC.icon_9.gotoAndStop(this.answers[8]);
            this.panelMC.icon_10.gotoAndStop(this.answers[9]);
         }
         var _loc2_:int = 1;
         while(_loc2_ < 11)
         {
            this.panelMC["btn_" + String(_loc2_)].gotoAndStop(String(_loc1_[_loc2_ - 1]));
            this.panelMC["btn_" + String(_loc2_)].buttonMode = false;
            _loc2_++;
         }
         this.disableAllButtons();
      }
      
      private function getRandomSequence(param1:int, param2:int) : Array
      {
         if(param1 > param2)
         {
            throw new Error("Max value should be greater than Min value!");
         }
         if(param1 == param2)
         {
            return [param1];
         }
         var _loc3_:Array = [];
         var _loc4_:int = param1;
         while(_loc4_ <= param2)
         {
            _loc3_.push(_loc4_);
            _loc4_++;
         }
         var _loc5_:Array = [];
         while(_loc3_.length > 0)
         {
            _loc5_ = _loc5_.concat(_loc3_.splice(Math.floor(Math.random() * _loc3_.length),1));
         }
         return _loc5_;
      }
      
      public function randomRange(param1:Number, param2:Number) : Number
      {
         return Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
      }
      
      private function enableAllButtons() : void
      {
         var _loc1_:* = 1;
         while(_loc1_ < 11)
         {
            this.panelMC["btn_" + String(_loc1_)].addEventListener(MouseEvent.CLICK,this.gotoSelected,false,0,true);
            this.panelMC["btn_" + String(_loc1_)].buttonMode = true;
            this.panelMC["btn_" + String(_loc1_)].filters = null;
            if(this.panelMC["btn_" + String(_loc1_)].hasOwnProperty("fakebtn"))
            {
               this.panelMC["btn_" + String(_loc1_)]["fakebtn"].enabled = true;
            }
            this.panelMC["btn_" + String(_loc1_)].visible = true;
            _loc1_++;
         }
      }
      
      private function disableAllButtons() : void
      {
         var _loc1_:* = 1;
         while(_loc1_ < 11)
         {
            this.panelMC["btn_" + String(_loc1_)].visible = true;
            this.panelMC["btn_" + String(_loc1_)].removeEventListener(MouseEvent.CLICK,this.gotoSelected);
            this.panelMC["btn_" + String(_loc1_)].buttonMode = false;
            this.panelMC["btn_" + String(_loc1_)].filters = null;
            if(this.panelMC["btn_" + String(_loc1_)].currentLabel != "idle" && this.panelMC["btn_" + String(_loc1_)].currentLabel != "0")
            {
               this.panelMC["btn_" + String(_loc1_)].filters = [this.dimFilter];
               this.panelMC["btn_" + String(_loc1_)]["fakebtn"].enabled = false;
            }
            _loc1_++;
         }
      }
      
      private function gotoSelected(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = int(param1.currentTarget.currentLabel);
         if(this.answers.length > this.userAnswers.length)
         {
            this.userAnswers.push(_loc4_);
         }
         param1.currentTarget.removeEventListener(MouseEvent.CLICK,this.gotoSelected);
         param1.currentTarget.filters = [this.dimFilter];
         param1.currentTarget.buttonMode = false;
         _loc2_ = 0;
         while(_loc2_ < this.userAnswers.length)
         {
            this.panelMC["icon_" + String(_loc2_ + this.iconOffset)].gotoAndStop(this.userAnswers[_loc2_]);
            _loc2_++;
         }
         if(this.userAnswers.length >= this.answers.length)
         {
            _loc3_ = 0;
            _loc2_ = 0;
            while(_loc2_ < this.answers.length)
            {
               if(this.userAnswers[_loc2_] == this.answers[_loc2_])
               {
                  _loc3_++;
               }
               _loc2_++;
            }
            this.win = _loc3_ == this.answers.length;
            if(this.win)
            {
               this.panelMC.mc_Result.gotoAndStop(4);
               ++this.currentQuestionNumber;
               this.userAnswers = [];
               this.panelMC.txt_round.text = "Skill: " + this.currentQuestionNumber + " / 6";
               if(this.currentQuestionNumber > 6)
               {
                  this.showDialoguePass();
               }
               else
               {
                  setTimeout(this.resetQuestion,2500);
               }
            }
            else
            {
               this.userAnswers = [];
               this.panelMC.mc_Result.gotoAndStop(5);
               if(this.heart > 0)
               {
                  --this.heart;
                  _loc2_ = 3;
                  while(this.heart < _loc2_)
                  {
                     this.panelMC["mc_heart_" + _loc2_].gotoAndStop("empty");
                     _loc2_--;
                  }
                  setTimeout(this.resetQuestion,2000);
               }
               if(this.heart == 0)
               {
                  this.showDialogueFail();
               }
            }
         }
      }
      
      public function finishStage6() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("JouninExam.finishStage",[Character.sessionkey,Character.char_id,6,this.win,this.currentQuestionNumber],this.onFinishStageRes);
      }
      
      public function backToVillage() : *
      {
         this.main.loadVillageAndHUD();
         turn_timer.reset();
         turn_timer = null;
         this.main = null;
         this.questions = null;
         this.arrCards = null;
         this.curQuestion = null;
         this.currentQuestionNumber = 0;
         this.questionPool = null;
         this.answers = null;
         this.userAnswers = null;
         this.randNum = 0;
         this.skillId = null;
         this.langFile = null;
         this.dimFilter = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            this.backToVillage();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function startTurnTimer() : *
      {
         if(turn_timer != null && turn_timer.running)
         {
            this.stopTurnTimer();
         }
         turn_timer = new Timer(1000,this.getMaxTime());
         this.panelMC.mc_Result.txt_timmer.text = String(this.getMaxTime());
         turn_timer.addEventListener(TimerEvent.TIMER,this.turnTimerTick);
         turn_timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.turnTimerCompleted);
         turn_timer.start();
      }
      
      private function stopTurnTimer() : *
      {
         if(turn_timer != null && turn_timer.running)
         {
            turn_timer.stop();
            turn_timer.reset();
         }
         this.initAllIconButtons();
         this.enableAllButtons();
         this.panelMC.mc_Result.gotoAndStop(3);
      }
      
      private function turnTimerTick(param1:TimerEvent) : *
      {
         this.panelMC.mc_Result.txt_timmer.text = String(this.getMaxTime() - int(param1.currentTarget.currentCount));
      }
      
      private function turnTimerCompleted(param1:TimerEvent) : *
      {
         this.hideAnswers();
         this.enableAllButtons();
         this.panelMC.mc_Result.gotoAndStop(3);
      }
      
      private function getMaxTime() : int
      {
         switch(this.currentQuestionNumber)
         {
            case 1:
               turn_timer_seconds = 8 + this.answers.length;
               break;
            case 2:
               turn_timer_seconds = 8 + this.answers.length;
               break;
            case 3:
               turn_timer_seconds = 12 + this.answers.length;
               break;
            case 4:
               turn_timer_seconds = 20 + this.answers.length;
               break;
            case 5:
               turn_timer_seconds = 20 + this.answers.length;
               break;
            case 6:
               turn_timer_seconds = 20 + this.answers.length;
               break;
            case 7:
               turn_timer_seconds = 10 + this.answers.length;
               break;
            case 8:
               turn_timer_seconds = 5 + this.answers.length;
               break;
            case 9:
               turn_timer_seconds = 10 + this.answers.length;
               break;
            case 10:
               turn_timer_seconds = 7 + this.answers.length;
               break;
            default:
               turn_timer_seconds = 10 + this.answers.length;
         }
         return turn_timer_seconds;
      }
   }
}

