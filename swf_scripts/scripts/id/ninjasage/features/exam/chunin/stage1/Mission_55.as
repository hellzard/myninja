package id.ninjasage.features.exam.chunin.stage1
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class Mission_55 extends MovieClip
   {
      
      public var ansMc_0:MovieClip;
      
      public var ansMc_1:MovieClip;
      
      public var ansMc_2:MovieClip;
      
      public var ansMc_3:MovieClip;
      
      public var ansMc_4:MovieClip;
      
      public var ansMc_5:MovieClip;
      
      public var ansMc_6:MovieClip;
      
      public var lbl_Result:TextField;
      
      public var lbl_Title1:TextField;
      
      public var lbl_Title2:TextField;
      
      public var npcName:TextField;
      
      public var npcTxt:TextField;
      
      public var okBtn:MovieClip;
      
      public var resultMc:MovieClip;
      
      public var startBtn:SimpleButton;
      
      public var table:MovieClip;
      
      public const id:String = "msn55";
      
      public const type:String = "normal";
      
      public var main:*;
      
      public var panelMC:MovieClip;
      
      public var question:*;
      
      internal var question_nr:* = 0;
      
      internal var selected_ans:* = 0;
      
      public var answers:* = [false,false,false,false,false];
      
      public var pass:Boolean = false;
      
      public function Mission_55(param1:*, param2:*)
      {
         super();
         this.scaleY += 0.1;
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.question = new Mission_55_MC();
         this.panelMC.addFrameScript(12,this.onWelcome,22,this.onQuestions,47,this.onResultFrame);
      }
      
      internal function onWelcome() : void
      {
         this.panelMC.stop();
         this.panelMC["npcName"].text = "Yuuhi:";
         this.panelMC["npcTxt"].text = "Welcome to the Chunin Exam, I am your examiner, Yuuhi. The first round is a written test. You have to answer all 5 questions correctly to get to the next stage.";
         this.panelMC["startBtn"].addEventListener(MouseEvent.CLICK,this.gotoExam);
      }
      
      internal function gotoExam(param1:MouseEvent) : void
      {
         this.panelMC.gotoAndPlay("exam");
         this.panelMC["table"].title.text = "Question 1 / 5";
         this.panelMC["table"].question.text = "";
      }
      
      internal function onQuestions() : *
      {
         this.panelMC.stop();
         this.loadQuestion();
      }
      
      internal function loadQuestion() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.panelMC["table"]["resultBtn"].visible = false;
         if(this.question_nr < 5)
         {
            this.panelMC["table"].title.text = "Question " + String(this.question_nr + 1) + " / 5";
            this.panelMC["table"].question.text = this.question.questions[this.question_nr].q;
            _loc1_ = this.question.questions[this.question_nr].c;
            this.panelMC["table"]["nextBtn"].visible = true;
            this.panelMC["table"]["nextBtn"].addEventListener(MouseEvent.CLICK,this.nextQuestion);
            if(this.question_nr == 4)
            {
               this.panelMC["table"]["nextBtn"].visible = false;
               this.panelMC["table"]["resultBtn"].visible = true;
               this.panelMC["table"]["resultBtn"].addEventListener(MouseEvent.CLICK,this.nextQuestion);
            }
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               this.panelMC["table"]["answer_" + String(_loc2_ + 1)].gotoAndStop(1);
               this.panelMC["table"]["answer_" + String(_loc2_ + 1)].answer = _loc2_;
               this.panelMC["table"]["answer_" + String(_loc2_ + 1)]["txt"].text = String.fromCharCode(_loc2_ + 65) + ") " + String(_loc1_[_loc2_]).replace("[playername]",Character.character_name);
               this.panelMC["table"]["answer_" + String(_loc2_ + 1)].buttonMode = true;
               this.panelMC["table"]["answer_" + String(_loc2_ + 1)].addEventListener(MouseEvent.CLICK,this.gotoSelected);
               _loc2_++;
            }
         }
         else
         {
            this.onResults();
         }
      }
      
      internal function nextQuestion(param1:MouseEvent) : *
      {
         ++this.question_nr;
         this.loadQuestion();
      }
      
      public function gotoSelected(param1:MouseEvent) : *
      {
         var _loc2_:* = 1;
         while(_loc2_ <= this.answers.length)
         {
            this.panelMC["table"]["answer_" + String(_loc2_)].gotoAndStop(1);
            _loc2_++;
         }
         param1.currentTarget.gotoAndStop(3);
         this.selected_ans = int(param1.currentTarget.name.replace("answer_",""));
         this.answers[this.question_nr] = this.selected_ans - 1;
      }
      
      public function onResults() : *
      {
         this.panelMC.gotoAndPlay("results");
      }
      
      public function onResultFrame() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.panelMC.stop();
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         while(_loc6_ < 5)
         {
            _loc1_ = this.question.questions[_loc6_].a;
            _loc2_ = this.question.questions[_loc6_].c;
            _loc3_ = this.answers[_loc6_];
            if(_loc3_ == _loc1_)
            {
               _loc4_++;
               this.panelMC["ansMc_" + String(_loc6_)].tickMc.gotoAndStop(1);
            }
            else
            {
               _loc5_++;
               this.panelMC["ansMc_" + String(_loc6_)].tickMc.gotoAndStop(2);
            }
            this.panelMC["ansMc_" + String(_loc6_)].yourAnsTxt.text = "Your Answer : " + String(_loc3_ + 1);
            this.panelMC["ansMc_" + String(_loc6_)].corrAnsTxt.text = "Correct Answer : " + String(_loc1_ + 1);
            this.panelMC["ansMc_" + String(_loc6_)].questionTxt = _loc2_[_loc6_];
            _loc6_++;
         }
         if(_loc4_ > 2)
         {
            this.pass = true;
         }
         else
         {
            this.pass = false;
         }
         if(this.pass)
         {
            if(_loc4_ == 3)
            {
               this.panelMC["resultMc"].gotoAndStop("great");
            }
            else if(_loc4_ == 4)
            {
               this.panelMC["resultMc"].gotoAndStop("excellent");
            }
            else
            {
               this.panelMC["resultMc"].gotoAndStop("perfect");
            }
            this.panelMC["okBtn"].addEventListener(MouseEvent.CLICK,this.onFinishStage1);
         }
         else
         {
            this.panelMC["resultMc"].gotoAndStop("fail");
            this.panelMC["okBtn"].addEventListener(MouseEvent.CLICK,this.backToVillage);
         }
      }
      
      public function backToVillage(param1:MouseEvent) : *
      {
         this.question = null;
         this.answers = null;
         this.main.loadVillageAndHUD();
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
         this.main = null;
      }
      
      public function onFinishStage1(param1:MouseEvent) : *
      {
         this.main.amf_manager.service("ChuninExam.finishStage",[Character.sessionkey,Character.char_id,1,this.pass,this.question.questions,this.answers],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         var _loc2_:* = undefined;
         if(param1.status > 0)
         {
            _loc2_ = param1.hash;
            this.main.loadVillageAndHUD();
            GF.removeAllChild(this);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
   }
}

