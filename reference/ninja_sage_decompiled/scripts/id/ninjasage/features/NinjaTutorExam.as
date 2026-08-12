package id.ninjasage.features
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EventHandler;
   
   public dynamic class NinjaTutorExam extends MovieClip
   {
       
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var ninjatutor:Array;
      
      private var curr_stage:int;
      
      private var curr_chapter:int;
      
      private var eventHandler:EventHandler;
      
      public function NinjaTutorExam(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.main.handleVillageHUDVisibility(false);
         this.eventHandler = new EventHandler();
         this.main.amf_manager.service("NinjaTutorExam.getData",[Character.char_id,Character.sessionkey],this.getBasicData);
         this.panelMC.addFrameScript(0,this.frame1,4,this.frame6,33,this.frame34,43,this.frame44);
      }
      
      private function getBasicData(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.ninjatutor = param1.data;
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
      
      private function onShow() : *
      {
         this.eventHandler.addListener(this.panelMC.panel.btnClose,MouseEvent.CLICK,this.onExit);
         this.panelMC.panel.stageMc.addFrameScript(26,this.stageFrame27);
         if(this.ninjatutor[11].status == 2)
         {
            this.showExamPassed();
         }
      }
      
      private function stageFrame27() : *
      {
         this.stop();
         this.panelMC.panel.stageMc.gotoAndStop("show");
         var _loc1_:* = 1;
         while(_loc1_ < 7)
         {
            this.panelMC.panel.stageMc["stage" + _loc1_].gotoAndStop("enable");
            this.panelMC.panel.rightPanel.tabMc.btnClaim.visible = true;
            this.panelMC.panel.stageMc["stage" + _loc1_].tickMC.visible = false;
            this.panelMC.panel.stageMc["stage" + _loc1_].buttonMode = true;
            this.eventHandler.addListener(this.panelMC.panel.stageMc["stage" + _loc1_],MouseEvent.MOUSE_OVER,this.mouseOver);
            this.eventHandler.addListener(this.panelMC.panel.stageMc["stage" + _loc1_],MouseEvent.MOUSE_OUT,this.mouseOut);
            this.eventHandler.addListener(this.panelMC.panel.stageMc["stage" + _loc1_],MouseEvent.CLICK,this.mouseClick);
            _loc1_++;
         }
         if(this.ninjatutor[0].status == 2 && this.ninjatutor[1].status == 2)
         {
            this.panelMC.panel.stageMc["stage1"].tickMC.visible = true;
         }
         if(this.ninjatutor[2].status == 2 && this.ninjatutor[3].status == 2)
         {
            this.panelMC.panel.stageMc["stage2"].tickMC.visible = true;
         }
         if(this.ninjatutor[4].status == 2 && this.ninjatutor[5].status == 2)
         {
            this.panelMC.panel.stageMc["stage3"].tickMC.visible = true;
         }
         if(this.ninjatutor[6].status == 2 && this.ninjatutor[7].status == 2)
         {
            this.panelMC.panel.stageMc["stage4"].tickMC.visible = true;
         }
         if(this.ninjatutor[8].status == 2 && this.ninjatutor[9].status == 2)
         {
            this.panelMC.panel.stageMc["stage5"].tickMC.visible = true;
         }
         if(this.ninjatutor[10].status == 2 && this.ninjatutor[11].status == 2)
         {
            this.panelMC.panel.stageMc["stage6"].tickMC.visible = true;
         }
         if(this.ninjatutor[0].status == 0 && this.ninjatutor[1].status == 0)
         {
            this.panelMC.panel.stageMc["stage1"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage1"].gotoAndStop("locked");
            this.panelMC.panel.stageMc["stage1"].removeEventListener(MouseEvent.CLICK,this.mouseClick);
            this.panelMC.panel.stageMc["stage1"].removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this.panelMC.panel.stageMc["stage1"].removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.ninjatutor[2].status == 0 && this.ninjatutor[3].status == 0)
         {
            this.panelMC.panel.stageMc["stage2"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage2"].gotoAndStop("locked");
            this.panelMC.panel.stageMc["stage2"].removeEventListener(MouseEvent.CLICK,this.mouseClick);
            this.panelMC.panel.stageMc["stage2"].removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this.panelMC.panel.stageMc["stage2"].removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.ninjatutor[4].status == 0 && this.ninjatutor[5].status == 0)
         {
            this.panelMC.panel.stageMc["stage3"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage3"].gotoAndStop("locked");
            this.panelMC.panel.stageMc["stage3"].removeEventListener(MouseEvent.CLICK,this.mouseClick);
            this.panelMC.panel.stageMc["stage3"].removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this.panelMC.panel.stageMc["stage3"].removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.ninjatutor[6].status == 0 && this.ninjatutor[7].status == 0)
         {
            this.panelMC.panel.stageMc["stage4"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage4"].gotoAndStop("locked");
            this.panelMC.panel.stageMc["stage4"].removeEventListener(MouseEvent.CLICK,this.mouseClick);
            this.panelMC.panel.stageMc["stage4"].removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this.panelMC.panel.stageMc["stage4"].removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.ninjatutor[8].status == 0 && this.ninjatutor[9].status == 0)
         {
            this.panelMC.panel.stageMc["stage5"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage5"].gotoAndStop("locked");
            this.panelMC.panel.stageMc["stage5"].removeEventListener(MouseEvent.CLICK,this.mouseClick);
            this.panelMC.panel.stageMc["stage5"].removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this.panelMC.panel.stageMc["stage5"].removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.ninjatutor[10].status == 0 && this.ninjatutor[11].status == 0)
         {
            this.panelMC.panel.stageMc["stage6"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage6"].gotoAndStop("locked");
            this.panelMC.panel.stageMc["stage6"].removeEventListener(MouseEvent.CLICK,this.mouseClick);
            this.panelMC.panel.stageMc["stage6"].removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            this.panelMC.panel.stageMc["stage6"].removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         }
      }
      
      private function setRightPanel(param1:String) : *
      {
         switch(param1)
         {
            case "stage1":
               this.curr_stage = 1;
               this.curr_chapter = 0;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage1");
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Attack of Nemesis";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "6 cloaked strangers showed up in Fire Village one day and claimed to seize the Secret Book of Fire. Their power is unstoppable and many have fallen before them. Kage is leading a task force to defend the village and he needs your help. Finish this training and join Kage to battle!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[0].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[1].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.ninjatutor[1].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case "stage2":
               this.curr_stage = 2;
               this.curr_chapter = 2;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage3");
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Enduring the Hardship";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Task force is recruiting! The Kage wants you to join the team! It’s time to equip new skills!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[2].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[3].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.ninjatutor[3].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case "stage3":
               this.curr_stage = 3;
               this.curr_chapter = 4;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage5");
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "New Hope";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Our Kage is doing his best to protect the Village with all his might! You should finish the training ASAP and assist our Kage.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[4].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[5].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.ninjatutor[5].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case "stage4":
               this.curr_stage = 4;
               this.curr_chapter = 6;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage7");
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Things are looking up...";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Here’s a tailor-made training for you from the Kage to improve your Adversity Quotient and sixth sense.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[6].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[7].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.ninjatutor[7].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case "stage5":
               this.curr_stage = 5;
               this.curr_chapter = 8;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage9");
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Fruit of Training";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "If you wish to become more powerful, hurry up and finish the training!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[8].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[9].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.ninjatutor[9].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case "stage6":
               this.curr_stage = 6;
               this.curr_chapter = 10;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage11");
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Finale! The Tower of Demons";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "We’re finally arrived. They hid the Secret Book of Fire in the Tower of Demons. It’s the origin of every disaster. Yes, the truth is not what you think it is...";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[10].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[11].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel2);
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel3);
               }
               if(this.ninjatutor[11].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
         }
      }
      
      private function setRightPanel2(param1:String) : *
      {
         switch(this.curr_stage)
         {
            case 1:
               this.curr_chapter = 1;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage2");
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Emergency! Fire Village is Falling...";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "A group of beasts has been summoned by 1 of the enemies, defeat them first to fight the pack leader.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToTab1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[0].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[1].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case 2:
               this.curr_chapter = 3;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage4");
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Battle off! Homunculus Ninjas!";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "You’ve encountered a homunculus… his anatomy is too different, perhaps Genjutsu is no use against him.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToTab1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[2].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[3].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case 3:
               this.curr_chapter = 5;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage6");
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Fight on! Preta Realm!";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "This enemy is not only blocking our way but is also sucking the life out of us! This is going to be a tough fight! Be careful!!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToTab1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[4].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[5].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case 4:
               this.curr_chapter = 7;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage8");
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Soul Snatcher";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "How familiar… Seems like you’ve fought with him before...";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToTab1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[6].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[7].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case 5:
               this.curr_chapter = 9;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage10");
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "The Hall of Pain";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "This is impossible! How can we defeat the enemies if they keep coming back to life?";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToTab1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[8].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[9].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case 6:
               this.curr_chapter = 11;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage12");
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab1.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.tab1.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab1.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab2.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "The Truth";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "When everybody thought the last enemy has been defeated and victory has been claimed, the real nemesis appeared! He possesses every skills from all the previous enemies! It’s going to be an epic battle!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "80";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToTab1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.ninjatutor[10].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.ninjatutor[11].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel2);
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.removeEventListener(MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.ninjatutor[11].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
         }
      }
      
      private function startStage(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("NinjaTutorExam.startStage",[Character.char_id,Character.sessionkey,this.ninjatutor[this.curr_chapter].id],this.startExam);
      }
      
      private function startExam(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(this.curr_chapter == 0)
            {
               this.main.loadNinjaTutorStage("stage1c1");
            }
            else if(this.curr_chapter == 1)
            {
               this.main.loadNinjaTutorStage("stage1c2");
            }
            else if(this.curr_chapter == 2)
            {
               this.main.loadNinjaTutorStage("stage2c1");
            }
            else if(this.curr_chapter == 3)
            {
               this.main.loadNinjaTutorStage("stage2c2");
            }
            else if(this.curr_chapter == 4)
            {
               this.main.loadNinjaTutorStage("stage3c1");
            }
            else if(this.curr_chapter == 5)
            {
               this.main.loadNinjaTutorStage("stage3c2");
            }
            else if(this.curr_chapter == 6)
            {
               this.main.loadNinjaTutorStage("stage4c1");
            }
            else if(this.curr_chapter == 7)
            {
               this.main.loadNinjaTutorStage("stage4c2");
            }
            else if(this.curr_chapter == 8)
            {
               this.main.loadNinjaTutorStage("stage5c1");
            }
            else if(this.curr_chapter == 9)
            {
               this.main.loadNinjaTutorStage("stage5c2");
            }
            else if(this.curr_chapter == 10)
            {
               this.main.loadNinjaTutorStage("stage6c1");
            }
            else if(this.curr_chapter == 11)
            {
               this.main.loadNinjaTutorStage("stage6c2");
            }
            else if(this.curr_chapter == 12)
            {
               this.main.loadNinjaTutorStage("stage6c3");
            }
            this.destroy();
         }
         else
         {
            this.main.showMessage(param1.result);
         }
      }
      
      private function backToTab1(param1:MouseEvent) : *
      {
         if(this.curr_chapter == 1)
         {
            this.setRightPanel("stage1");
         }
         else if(this.curr_chapter == 3)
         {
            this.setRightPanel("stage2");
         }
         else if(this.curr_chapter == 5)
         {
            this.setRightPanel("stage3");
         }
         else if(this.curr_chapter == 7)
         {
            this.setRightPanel("stage4");
         }
         else if(this.curr_chapter == 9)
         {
            this.setRightPanel("stage5");
         }
         else if(this.curr_chapter == 11)
         {
            this.setRightPanel("stage6");
         }
      }
      
      private function showExamPassed() : *
      {
         this.panelMC.panel.finishAni.visible = true;
         this.panelMC.panel.finishAni.addFrameScript(222,this.showCharInfo,226,this.showBadge,229,this.showClassSelection,244,this.confirmExamScroll);
      }
      
      private function showBadge() : *
      {
         this.panelMC.panel.finishAni.badgeMC.gotoAndStop("genius");
      }
      
      private function confirmExamScroll() : *
      {
         this.panelMC.panel.finishAni.stop();
         this.main.initButton(this.panelMC.panel.finishAni.btnGo,this.closeExamScroll,"Confirm");
      }
      
      private function showCharInfo() : *
      {
         var _loc1_:* = this.main.getPlayerHead();
         _loc1_.scaleX = 3;
         _loc1_.scaleY = 3;
         this.panelMC.panel.finishAni.iconHolder.addChild(_loc1_);
         this.panelMC.panel.finishAni.titleTxt.text = "Senior Ninja Tutor Exam";
         this.panelMC.panel.finishAni.nameTxt.text = "Name:";
         this.panelMC.panel.finishAni.nameField.text = Character.character_name;
         this.panelMC.panel.finishAni.rankTxt.text = "Rank:";
         this.panelMC.panel.finishAni.classTxt.text = "Class:";
         this.panelMC.panel.finishAni.classTxt.visible = false;
      }
      
      private function closeExamScroll(param1:MouseEvent) : *
      {
         this.panelMC.panel.finishAni.visible = false;
         this.sendAmfReward();
      }
      
      private function sendAmfReward() : *
      {
         this.main.amf_manager.service("NinjaTutorExam.promoteToNinjaTutor",[Character.char_id,Character.sessionkey],this.amfRewardRes);
      }
      
      private function amfRewardRes(param1:Object = null) : *
      {
         if(param1.status == 1)
         {
            this.main.giveReward(1,param1.rewards);
            this.main.showMessage(param1.result);
            Character.addWeapon("wpn_988");
            Character.addSet("set_942_" + Character.character_gender);
            Character.addBack("back_430");
            Character.character_rank = "9";
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
      
      private function mouseClick(param1:MouseEvent) : *
      {
         var _loc2_:* = 1;
         while(_loc2_ < 7)
         {
            if(this.panelMC.panel.stageMc["stage" + _loc2_].currentLabel != "locked")
            {
               this.panelMC.panel.stageMc["stage" + _loc2_].gotoAndStop("enable");
            }
            _loc2_++;
         }
         if(param1.currentTarget.currentFrameLabel == "locked")
         {
            param1.currentTarget.gotoAndStop("locked");
         }
         else
         {
            param1.currentTarget.gotoAndStop("selected");
         }
         this.setRightPanel(param1.currentTarget.name);
      }
      
      private function mouseOver(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrameLabel == "locked")
         {
            param1.currentTarget.gotoAndStop("locked");
         }
         if(param1.currentTarget.currentFrameLabel != "selected")
         {
            param1.currentTarget.gotoAndStop("mover");
         }
      }
      
      private function mouseOut(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrameLabel == "locked")
         {
            param1.currentTarget.gotoAndStop("locked");
         }
         if(param1.currentTarget.currentFrameLabel != "selected")
         {
            param1.currentTarget.gotoAndStop("enable");
         }
      }
      
      private function onExit(param1:MouseEvent) : *
      {
         this.panelMC.gotoAndPlay("exit");
      }
      
      private function openRewardPreview(param1:MouseEvent) : *
      {
         this.panelMC.panel.newRewardMc.visible = true;
         this.eventHandler.addListener(this.panelMC.panel.newRewardMc.btnClose,MouseEvent.CLICK,this.closeRewardPreview);
      }
      
      private function closeRewardPreview(param1:MouseEvent) : *
      {
         this.panelMC.panel.newRewardMc.visible = false;
      }
      
      private function frame1() : *
      {
      }
      
      private function frame6() : *
      {
         this.panelMC.panel.newRewardMc.visible = false;
         this.panelMC.panel.finishAni.visible = false;
         this.panelMC.panel.rewardBtn2.visible = false;
         this.panelMC.panel.btnClaim.visible = false;
         this.panelMC.panel.btnClaimGlowMc.visible = false;
         this.panelMC.panel.stageMc.maskMC.visible = false;
         this.panelMC.panel.stageMc.titleMC.dateTxt.visible = false;
         this.panelMC.panel.stageMc.titleMC.tabMC.visible = false;
         this.panelMC.panel.stageMc.titleMC.gotoAndStop("hard1");
         this.panelMC.panel.rightPanel.visible = false;
         this.panelMC.panel.timerMC.visible = false;
         this.panelMC.panel.stageMc.addFrameScript(0,this.stage1Desc,1,this.stage2Desc,4,this.stage3Desc,9,this.stage4Desc,12,this.stage5Desc,16,this.stage6Desc,26,this.stopAnim);
         this.main.initButton(this.panelMC.panel.rewardBtn,this.openRewardPreview,"Rewards");
      }
      
      function stage1Desc() : *
      {
         this.panelMC.panel.stageMc.stage1.bgMC.gotoAndStop("stage1");
         this.panelMC.panel.stageMc.stage1.newMC.visible = false;
         this.panelMC.panel.stageMc.stage1.comeTxt.text = "Attack of Nemesis";
         this.panelMC.panel.stageMc.stage1.descTxt.text = "Stage 1";
         this.panelMC.panel.stageMc.stage1.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage1.gotoAndStop("enable");
      }
      
      function stage2Desc() : *
      {
         this.panelMC.panel.stageMc.stage2.bgMC.gotoAndStop("stage2");
         this.panelMC.panel.stageMc.stage2.newMC.visible = false;
         this.panelMC.panel.stageMc.stage2.comeTxt.text = "Enduring the Hardship";
         this.panelMC.panel.stageMc.stage2.descTxt.text = "Stage 2";
         this.panelMC.panel.stageMc.stage2.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage2.gotoAndStop("enable");
      }
      
      function stage3Desc() : *
      {
         this.panelMC.panel.stageMc.stage3.bgMC.gotoAndStop("stage3");
         this.panelMC.panel.stageMc.stage3.newMC.visible = false;
         this.panelMC.panel.stageMc.stage3.comeTxt.text = "New Hope";
         this.panelMC.panel.stageMc.stage3.descTxt.text = "Stage 3";
         this.panelMC.panel.stageMc.stage3.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage3.gotoAndStop("enable");
      }
      
      function stage4Desc() : *
      {
         this.panelMC.panel.stageMc.stage4.bgMC.gotoAndStop("stage4");
         this.panelMC.panel.stageMc.stage4.newMC.visible = false;
         this.panelMC.panel.stageMc.stage4.comeTxt.text = "Look Up";
         this.panelMC.panel.stageMc.stage4.descTxt.text = "Stage 4";
         this.panelMC.panel.stageMc.stage4.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage4.gotoAndStop("enable");
      }
      
      function stage5Desc() : *
      {
         this.panelMC.panel.stageMc.stage5.bgMC.gotoAndStop("stage5");
         this.panelMC.panel.stageMc.stage5.newMC.visible = false;
         this.panelMC.panel.stageMc.stage5.comeTxt.text = "Fruit of Training";
         this.panelMC.panel.stageMc.stage5.descTxt.text = "Stage 5";
         this.panelMC.panel.stageMc.stage5.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage5.gotoAndStop("enable");
      }
      
      function stage6Desc() : *
      {
         this.panelMC.panel.stageMc.stage6.bgMC.gotoAndStop("stage6");
         this.panelMC.panel.stageMc.stage6.newMC.visible = false;
         this.panelMC.panel.stageMc.stage6.comeTxt.text = "The Truth";
         this.panelMC.panel.stageMc.stage6.descTxt.text = "Stage 6";
         this.panelMC.panel.stageMc.stage6.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage6.gotoAndStop("enable");
      }
      
      function stopAnim() : *
      {
         this.panelMC.panel.stageMc.stop();
      }
      
      private function frame34() : *
      {
         this.panelMC.stop();
         this.onShow();
      }
      
      private function frame44() : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         this.main.handleVillageHUDVisibility(true);
         this.panelMC.gotoAndStop("idle");
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.main.clearEvents();
         this.main = null;
         this.eventHandler = null;
         this.curr_stage = 0;
         this.curr_chapter = 0;
         GF.clearArray(this.ninjatutor);
         GF.removeAllChild(this.panelMC);
      }
   }
}
