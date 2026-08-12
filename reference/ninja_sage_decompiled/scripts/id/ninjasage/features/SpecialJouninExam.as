package id.ninjasage.features
{
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import id.ninjasage.EventHandler;
   
   public dynamic class SpecialJouninExam extends MovieClip
   {
       
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var spjounin:Array;
      
      private var curr_stage:int;
      
      private var curr_chapter:int;
      
      private var confirmation:Confirmation;
      
      private var CLASS_BTN_NAME_ARR:Array;
      
      private var CLASS_SKILL_ARR:Array;
      
      private var CLASS_NAME_ARR:Array;
      
      private var tooltip;
      
      private var loader:BulkLoader;
      
      private var swfName:String;
      
      private var selected_class:int;
      
      private var eventHandler:EventHandler;
      
      public function SpecialJouninExam(param1:*, param2:*)
      {
         this.CLASS_BTN_NAME_ARR = ["select_info","select_surprise","select_perceive","select_attack","select_heal"];
         this.CLASS_SKILL_ARR = ["skill_4002","skill_4004","skill_4001","skill_4003","skill_4000"];
         this.CLASS_NAME_ARR = ["Intelligence Class","Surprise Attack Class","Sensor Class","Heavy Attack Class","Medical Class"];
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.main.handleVillageHUDVisibility(false);
         this.eventHandler = new EventHandler();
         this.loader = BulkLoader.createUniqueNamedLoader(10);
         this.panelMC.gotoAndStop(1);
         this.main.loading(true);
         this.main.amf_manager.service("SpecialJouninExam.getData",[Character.sessionkey,Character.char_id],this.onShow);
         this.panelMC.addFrameScript(40,this.frame41,47,this.frame48,80,this.frame81);
      }
      
      private function onShow(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.spjounin = param1.data;
            this.panelMC.gotoAndPlay(1);
         }
         else if(param1.status > 1 && param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function stageFrame27() : *
      {
         this.panelMC.panel.stageMc.stop();
         this.panelMC.panel.stageMc.hintMC.visible = false;
         this.panelMC.panel.stageMc.gotoAndStop("show");
         this.panelMC.panel.stageMc.hintMC2.gotoAndStop("hard");
         this.panelMC.panel.stageMc.hintMC2.iconMC1.gotoAndStop("tensai");
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
         if(this.spjounin[0].status == 2 && this.spjounin[1].status == 2)
         {
            this.panelMC.panel.stageMc["stage1"].tickMC.visible = true;
         }
         if(this.spjounin[2].status == 2 && this.spjounin[3].status == 2)
         {
            this.panelMC.panel.stageMc["stage2"].tickMC.visible = true;
         }
         if(this.spjounin[4].status == 2 && this.spjounin[5].status == 2)
         {
            this.panelMC.panel.stageMc["stage3"].tickMC.visible = true;
         }
         if(this.spjounin[6].status == 2 && this.spjounin[7].status == 2)
         {
            this.panelMC.panel.stageMc["stage4"].tickMC.visible = true;
         }
         if(this.spjounin[8].status == 2 && this.spjounin[9].status == 2)
         {
            this.panelMC.panel.stageMc["stage5"].tickMC.visible = true;
         }
         if(this.spjounin[10].status == 2 && this.spjounin[11].status == 2 && this.spjounin[12].status == 2)
         {
            this.panelMC.panel.stageMc["stage6"].tickMC.visible = true;
         }
         if(this.spjounin[0].status == 0 && this.spjounin[1].status == 0)
         {
            this.panelMC.panel.stageMc["stage1"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage1"].gotoAndStop("locked");
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage1"],MouseEvent.CLICK,this.mouseClick);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage1"],MouseEvent.MOUSE_OUT,this.mouseOut);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage1"],MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.spjounin[2].status == 0 && this.spjounin[3].status == 0)
         {
            this.panelMC.panel.stageMc["stage2"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage2"].gotoAndStop("locked");
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage2"],MouseEvent.CLICK,this.mouseClick);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage2"],MouseEvent.MOUSE_OUT,this.mouseOut);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage2"],MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.spjounin[4].status == 0 && this.spjounin[5].status == 0)
         {
            this.panelMC.panel.stageMc["stage3"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage3"].gotoAndStop("locked");
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage3"],MouseEvent.CLICK,this.mouseClick);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage3"],MouseEvent.MOUSE_OUT,this.mouseOut);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage3"],MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.spjounin[6].status == 0 && this.spjounin[7].status == 0)
         {
            this.panelMC.panel.stageMc["stage4"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage4"].gotoAndStop("locked");
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage4"],MouseEvent.CLICK,this.mouseClick);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage4"],MouseEvent.MOUSE_OUT,this.mouseOut);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage4"],MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.spjounin[8].status == 0 && this.spjounin[9].status == 0)
         {
            this.panelMC.panel.stageMc["stage5"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage5"].gotoAndStop("locked");
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage5"],MouseEvent.CLICK,this.mouseClick);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage5"],MouseEvent.MOUSE_OUT,this.mouseOut);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage5"],MouseEvent.MOUSE_OVER,this.mouseOver);
         }
         if(this.spjounin[10].status == 0 && this.spjounin[11].status == 0 && this.spjounin[12].status == 0)
         {
            this.panelMC.panel.stageMc["stage6"].bgMC.gotoAndStop("idle");
            this.panelMC.panel.stageMc["stage6"].gotoAndStop("locked");
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage6"],MouseEvent.CLICK,this.mouseClick);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage6"],MouseEvent.MOUSE_OUT,this.mouseOut);
            this.eventHandler.removeListener(this.panelMC.panel.stageMc["stage6"],MouseEvent.MOUSE_OVER,this.mouseOver);
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "The Force Of Yami";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Mystery enemy is attacking Fire Village. They have someone who look like Shin and Ryu. Yudai has called out a meeting and gathered the five captains from each division.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[0].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[1].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[1].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Front Line Battle";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Kage has appointed you to work with the Surprise Attack Division.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[2].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[3].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[3].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Sensor Division";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Facing the unknown enemy, It is better to know what they are good at as soon as possible. Sensor Division Captain is here and tell you what you can do.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[4].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[5].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[5].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Secret Training";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Based on previous battle, Yudai suggests you should take some advises from Heavy Attack Division.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[6].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[7].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[7].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Medical Division";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Kage finally discovers the man behind this attack. Also, there are lack of ninja in Medical Division. Kage wants you to help with them.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[8].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[9].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab2,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[9].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab2.tickMC.visible = true;
               }
               break;
            case "stage6":
               this.curr_stage = 6;
               this.curr_chapter = 10;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage11");
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab4.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab5.visible = true;
               this.panelMC.panel.rightPanel.tabMc.tab5.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab5.chapTxt.text = "Chapter 3";
               this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab4.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.tab4.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab3.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "The Released Beast";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Vadar has brought a evil beast with him together!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab4,MouseEvent.CLICK,this.setRightPanel2,false,0,true);
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab5,MouseEvent.CLICK,this.setRightPanel3,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[10].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 1";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = true;
               }
               if(this.spjounin[11].status == 0)
               {
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4,MouseEvent.CLICK,this.setRightPanel2);
                  this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5,MouseEvent.CLICK,this.setRightPanel3);
               }
               if(this.spjounin[11].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
               }
               if(this.spjounin[12].status == 0)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5,MouseEvent.CLICK,this.setRightPanel3);
               }
               if(this.spjounin[12].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = true;
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Unpredicted Attack";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "The weapons are now ready, go and deliver the weapons to the front line. But watch out for the enemy!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToS1C1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[0].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[1].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Defense! Defense!";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Yudai suggest every Jounin should in charge one guarding tower and observe all the enemy movements. It looks like an enemy is coming towards you!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToS2C1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[2].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[3].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Call For Backup";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Enemies sneak in and attack us from behind. You must go to the front line and call for backup. Hurry! You are the only hope!";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToS3C1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[4].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[5].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Swords vs Ninjutsu";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "After the training, you are more confidence to fight in battle. Yudai tells you to go back to front line as he wants to end this battle as soon as possible.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToS4C1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[6].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[7].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Time To Fight Back";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "According to Mori Naruhisa, enemy will try to sneak into the village tonight. We can prepare a massive attack for this.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToS5C1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[8].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab1.tickMC.visible = true;
               }
               if(this.spjounin[9].status == 2)
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
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab3.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.tab3.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab5.chapTxt.text = "Chapter 3";
               this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab4.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Kage vs Kage";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Long battle has came to a close, the fight between Vadar and Yudai is finally begun.";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab3,MouseEvent.CLICK,this.backToS6C1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[10].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = true;
               }
               if(this.spjounin[11].status == 0)
               {
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4,MouseEvent.CLICK,this.setRightPanel2);
                  this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[11].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 2";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
               }
               if(this.spjounin[12].status == 0)
               {
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4,MouseEvent.CLICK,this.setRightPanel2);
                  this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[12].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = true;
               }
         }
      }
      
      private function setRightPanel3(param1:String) : *
      {
         switch(this.curr_stage)
         {
            case 6:
               this.curr_chapter = 12;
               this.panelMC.panel.rightPanel.visible = true;
               this.panelMC.panel.rightPanel.tabMc.gotoAndStop("stage13");
               this.panelMC.panel.rightPanel.tabMc.tab1.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab2.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab3.chapTxt.text = "Chapter 1";
               this.panelMC.panel.rightPanel.tabMc.tab3.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab3.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.gotoAndStop("unselect");
               this.panelMC.panel.rightPanel.tabMc.tab4.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab4.chapTxt.text = "Chapter 2";
               this.panelMC.panel.rightPanel.tabMc.tab5.gotoAndStop("select");
               this.panelMC.panel.rightPanel.tabMc.tab5.dateTxt.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.tab5.chapTxt.text = "Chapter 3";
               this.panelMC.panel.rightPanel.tabMc.lvAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageAlert.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.stageTick.visible = false;
               this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Beyond Kage\'s Power";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Vadar has shown his true power to everyone. However, Kage\'s Ultimate Element Seal is not yet complete, how much longer can you last?";
               this.panelMC.panel.rightPanel.tabMc.lvMC.txt.text = "60";
               this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.tab1,MouseEvent.CLICK,this.backToS5C1,false,0,true);
               this.main.initButton(this.panelMC.panel.rightPanel.tabMc.btnClaim,this.startStage,"Start");
               if(this.spjounin[10].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab3.tickMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab4.lockMC.visible = false;
               }
               if(this.spjounin[11].status == 0)
               {
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4,MouseEvent.CLICK,this.setRightPanel2);
                  this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[11].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.tab4.tickMC.visible = true;
               }
               if(this.spjounin[12].status == 0)
               {
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab4,MouseEvent.CLICK,this.setRightPanel2);
                  this.panelMC.panel.rightPanel.tabMc.tab5.lockMC.visible = true;
                  this.eventHandler.removeListener(this.panelMC.panel.rightPanel.tabMc.tab5,MouseEvent.CLICK,this.setRightPanel2);
               }
               if(this.spjounin[12].status == 2)
               {
                  this.panelMC.panel.rightPanel.tabMc.stageMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.stageMC.text = "Finish Chapter 3";
                  this.panelMC.panel.rightPanel.tabMc.stageTick.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
                  this.panelMC.panel.rightPanel.tabMc.tab5.tickMC.visible = true;
               }
         }
      }
      
      private function startStage(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("SpecialJouninExam.startStage",[Character.sessionkey,Character.char_id,this.curr_chapter + 11],this.startExam);
      }
      
      private function startExam(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(this.curr_chapter == 0)
            {
               this.main.loadSpecialJouninStage("stage1c1");
            }
            else if(this.curr_chapter == 1)
            {
               this.main.loadSpecialJouninStage("stage1c2");
            }
            else if(this.curr_chapter == 2)
            {
               this.main.loadSpecialJouninStage("stage2c1");
            }
            else if(this.curr_chapter == 3)
            {
               this.main.loadSpecialJouninStage("stage2c2");
            }
            else if(this.curr_chapter == 4)
            {
               this.main.loadSpecialJouninStage("stage3c1");
            }
            else if(this.curr_chapter == 5)
            {
               this.main.loadSpecialJouninStage("stage3c2");
            }
            else if(this.curr_chapter == 6)
            {
               this.main.loadSpecialJouninStage("stage4c1");
            }
            else if(this.curr_chapter == 7)
            {
               this.main.loadSpecialJouninStage("stage4c2");
            }
            else if(this.curr_chapter == 8)
            {
               this.main.loadSpecialJouninStage("stage5c1");
            }
            else if(this.curr_chapter == 9)
            {
               this.main.loadSpecialJouninStage("stage5c2");
            }
            else if(this.curr_chapter == 10)
            {
               this.main.loadSpecialJouninStage("stage6c1");
            }
            else if(this.curr_chapter == 11)
            {
               this.main.loadSpecialJouninStage("stage6c2");
            }
            else if(this.curr_chapter == 12)
            {
               this.main.loadSpecialJouninStage("stage6c3");
            }
            this.destroy();
         }
         else
         {
            this.main.showMessage(param1.result);
         }
      }
      
      private function backToS1C1(param1:MouseEvent) : *
      {
         this.setRightPanel("stage1");
      }
      
      private function backToS2C1(param1:MouseEvent) : *
      {
         this.setRightPanel("stage2");
      }
      
      private function backToS3C1(param1:MouseEvent) : *
      {
         this.setRightPanel("stage3");
      }
      
      private function backToS4C1(param1:MouseEvent) : *
      {
         this.setRightPanel("stage4");
      }
      
      private function backToS5C1(param1:MouseEvent) : *
      {
         this.setRightPanel("stage5");
      }
      
      private function backToS6C1(param1:MouseEvent) : *
      {
         this.setRightPanel("stage6");
      }
      
      private function backToS6C2(param1:MouseEvent) : *
      {
         this.setRightPanel2("6");
      }
      
      private function showExamPassed() : *
      {
         this.panelMC.panel.finishAni.visible = true;
         this.panelMC.panel.finishAni.gotoAndPlay(1);
         this.panelMC.panel.finishAni.addFrameScript(222,this.showCharInfo,226,this.showBadge,229,this.showClassSelection,244,this.confirmExamScroll);
      }
      
      private function showBadge() : *
      {
         this.panelMC.panel.finishAni.badgeMC.gotoAndStop("genius");
      }
      
      private function showCharInfo() : *
      {
         var _loc1_:* = this.main.getPlayerHead();
         _loc1_.scaleX = 3;
         _loc1_.scaleY = 3;
         this.panelMC.panel.finishAni.iconHolder.addChild(_loc1_);
         this.panelMC.panel.finishAni.nameTxt.text = "Name:";
         this.panelMC.panel.finishAni.nameField.text = Character.character_name;
         this.panelMC.panel.finishAni.rankTxt.text = "Rank:";
         this.panelMC.panel.finishAni.classTxt.text = "Class:";
      }
      
      private function showClassSelection() : *
      {
         this.panelMC.panel.finishAni.stop();
         this.panelMC.panel.finishAni.classSelectionMC.addFrameScript(16,this.onShowClassSelection);
      }
      
      private function onShowClassSelection() : *
      {
         this.panelMC.panel.finishAni.classSelectionMC.stop();
         this.panelMC.panel.finishAni.classSelectionMC.panelMC.addFrameScript(15,this.onSelectClass,36,this.stopSelectClassPanel);
      }
      
      private function onSelectClass() : *
      {
         this.tooltip = new skillToolTip();
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_loc1_]].gotoAndStop(1);
            this.eventHandler.addListener(this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_loc1_]],MouseEvent.CLICK,this.changeClass,false,0,true);
            this.eventHandler.addListener(this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_loc1_]],MouseEvent.MOUSE_OVER,this.mouseOverClassBtn,false,0,true);
            this.eventHandler.addListener(this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_loc1_]],MouseEvent.MOUSE_OUT,this.mouseOutClassBtn,false,0,true);
            this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_loc1_]].classTitle.text = this.CLASS_NAME_ARR[_loc1_];
            this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_loc1_]].highlightMC.visible = false;
            this.panelMC.panel.finishAni.classSelectionMC.panelMC[this.CLASS_BTN_NAME_ARR[_loc1_]].thisType = _loc1_ + 1;
            this.main.initButtonDisable(this.panelMC.panel.finishAni["classSelectionMC"]["panelMC"]["btnComfirm"],this.showConfirmationClass,"Confirm");
            _loc1_++;
         }
      }
      
      private function stopSelectClassPanel() : *
      {
         this.panelMC.panel.finishAni.classSelectionMC.panelMC.stop();
      }
      
      private function changeClass(param1:MouseEvent = null) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = this.panelMC.panel.finishAni["classSelectionMC"]["panelMC"];
         this.selected_class = param1.currentTarget.thisType;
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            if(this.selected_class == _loc2_ + 1)
            {
               if(_loc3_[this.CLASS_BTN_NAME_ARR[_loc2_]].hasEventListener(MouseEvent.CLICK))
               {
                  this.eventHandler.removeListener(_loc3_[this.CLASS_BTN_NAME_ARR[_loc2_]],MouseEvent.CLICK,this.changeClass);
               }
               _loc3_[this.CLASS_BTN_NAME_ARR[_loc2_]]["highlightMC"].visible = true;
            }
            else
            {
               if(!_loc3_[this.CLASS_BTN_NAME_ARR[_loc2_]].hasEventListener(MouseEvent.CLICK))
               {
                  this.eventHandler.addListener(_loc3_[this.CLASS_BTN_NAME_ARR[_loc2_]],MouseEvent.CLICK,this.changeClass,false,0,true);
               }
               _loc3_[this.CLASS_BTN_NAME_ARR[_loc2_]]["highlightMC"].visible = false;
            }
            _loc2_++;
         }
         if(!_loc3_["btnComfirm"].hasEventListener(MouseEvent.CLICK))
         {
            this.main.initButton(_loc3_["btnComfirm"],this.showConfirmationClass,"Confirm");
         }
      }
      
      private function mouseOutClassBtn(param1:MouseEvent = null) : *
      {
         var _loc2_:uint = param1.currentTarget.thisType;
         param1.currentTarget.gotoAndStop(1);
         GF.removeAllChild(this.panelMC.panel.finishAni.classSelectionMC.panelMC["tooltipHolder" + _loc2_]);
      }
      
      private function mouseOverClassBtn(param1:MouseEvent = null) : *
      {
         param1.currentTarget.gotoAndStop(2);
         var _loc2_:uint = param1.currentTarget.thisType;
         var _loc3_:* = this.CLASS_SKILL_ARR[_loc2_ - 1];
         var _loc4_:* = SkillLibrary.getSkillInfo(_loc3_);
         var _loc5_:* = -1;
         if(_loc3_ == "skill_4000")
         {
            _loc5_ = 1000 + (int(Character.character_lvl) - 60) * 70;
            this.tooltip.healTxt.text = _loc5_;
            Character.recolor(this.tooltip.healTxt,65280);
         }
         else if(_loc3_ == "skill_4004")
         {
            _loc5_ = 700 + (int(Character.character_lvl) - 60) * 64;
            this.tooltip.healTxt.text = _loc5_;
            Character.recolor(this.tooltip.healTxt,16711680);
         }
         else
         {
            this.tooltip.healTxt.text = "-";
            Character.recolor(this.tooltip.healTxt,16777215);
         }
         this.tooltip.classMC.gotoAndStop(_loc2_ + 1);
         this.tooltip.cooldownTxt.text = "-";
         this.tooltip.skillNameTxt.text = _loc4_.skill_name;
         this.tooltip.currskillTxt.text = _loc4_.skill_description.replace("[valamount]",_loc5_);
         if(_loc2_ != 5)
         {
            this.tooltip.damageIcon.visible = true;
            this.tooltip.healIcon.visible = false;
         }
         else
         {
            this.tooltip.damageIcon.visible = false;
            this.tooltip.healIcon.visible = true;
         }
         this.loadSkill(_loc3_);
         this.panelMC.panel.finishAni.classSelectionMC.panelMC["tooltipHolder" + _loc2_].addChild(this.tooltip);
      }
      
      private function loadSkill(param1:*) : *
      {
         this.swfName = param1;
         var _loc2_:* = this.loader.add("skills/" + param1 + ".swf",{"id":param1});
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.onSkillLoaded);
         this.loader.start();
      }
      
      private function onSkillLoaded(param1:Event) : *
      {
         param1.target.removeEventListener(BulkLoader.COMPLETE,this.onSkillLoaded);
         param1.target.content[this.swfName].gotoAndStop(1);
         var _loc2_:* = param1.target.content["icon"];
         this.tooltip.iconMC.gotoAndStop("enable");
         this.tooltip.iconMC.iconHolder.addChild(_loc2_);
      }
      
      private function showConfirmationClass(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         var target:* = e.currentTarget.name.replace("select_","");
         this.confirmation = new Confirmation();
         var name:* = this.CLASS_NAME_ARR[this.selected_class - 1];
         this.confirmation.txtMc.txt.text = "Are you sure to become a member of " + name + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.continueExamScroll);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function continueExamScroll(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.panelMC.panel.finishAni.classSelectionMC.visible = false;
         this.panelMC.panel.finishAni.iconMC.gotoAndStop("class" + this.selected_class);
         this.panelMC.panel.finishAni.gotoAndPlay(230);
      }
      
      private function confirmExamScroll() : *
      {
         this.panelMC.panel.finishAni.stop();
         this.main.initButton(this.panelMC.panel.finishAni.btnGo,this.closeExamScroll,"Confirm");
      }
      
      private function closeExamScroll(param1:MouseEvent) : *
      {
         this.panelMC.panel.finishAni.visible = false;
         this.panelMC.panel.rewardAni.visible = true;
         this.panelMC.panel.rewardAni.gotoAndPlay("idle");
         this.panelMC.panel.rewardAni.addFrameScript(7,this.onShowReward,39,this.onCloseReward);
      }
      
      private function onShowReward() : *
      {
         this.panelMC.panel.rewardAni.stop();
         this.panelMC.panel.rewardAni.panelMC.iconMC1.gotoAndStop(this.selected_class);
         this.panelMC.panel.rewardAni.panelMC.iconMC3.gotoAndStop(String(Character.character_gender));
         this.main.initButton(this.panelMC.panel.rewardAni.panelMC.btnGo,this.closeReward,"Confirm");
         this.eventHandler.addListener(this.panelMC.panel.rewardAni.panelMC.btnGo,MouseEvent.CLICK,this.closeReward,false,0,true);
      }
      
      private function closeReward(param1:MouseEvent) : *
      {
         this.panelMC.panel.rewardAni.gotoAndPlay("exit");
      }
      
      private function onCloseReward() : *
      {
         this.panelMC.panel.rewardAni.gotoAndStop("idle");
         this.panelMC.panel.rewardAni.visible = false;
         this.sendAmfReward();
      }
      
      private function sendAmfReward() : *
      {
         this.main.amf_manager.service("SpecialJouninExam.promoteToSpecialJounin",[Character.sessionkey,Character.char_id,this.CLASS_SKILL_ARR[this.selected_class - 1]],this.amfRewardRes);
      }
      
      private function amfRewardRes(param1:Object = null) : *
      {
         if(param1.status == 1)
         {
            Character.updateSkills("skill_345",true);
            Character.addSet("set_588_" + Character.character_gender);
            Character.character_rank = "7";
            Character.character_class = this.CLASS_SKILL_ARR[this.selected_class - 1];
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
      
      private function frame41() : *
      {
         this.panelMC.panel.stageMc.addFrameScript(0,this.stage1Desc,1,this.stage2Desc,4,this.stage3Desc,9,this.stage4Desc,12,this.stage5Desc,16,this.stage6Desc,26,this.stageFrame27);
         this.eventHandler.addListener(this.panelMC.panel.btnClose,MouseEvent.CLICK,this.onExit);
         this.panelMC.panel.rewardAni.visible = false;
         this.panelMC.panel.finishAni.visible = false;
         this.panelMC.panel.helpPanel.visible = false;
         this.panelMC.panel.stageMc.maskMC.visible = false;
         this.panelMC.panel.timerMC.visible = false;
         this.panelMC.panel.stageMc.titleMC.dateTxt.visible = false;
         this.panelMC.panel.rightPanel.visible = false;
         this.panelMC.panel.stageMc.titleMC.tabMC.visible = false;
         this.panelMC.panel.stageMc.titleMC.gotoAndStop("hard1");
         if(this.spjounin[12].status == 2)
         {
            this.showExamPassed();
         }
      }
      
      function stage1Desc() : *
      {
         this.panelMC.panel.stageMc.stage1.bgMC.gotoAndStop("stage1");
         this.panelMC.panel.stageMc.stage1.comeTxt.text = "Intelligence Division";
         this.panelMC.panel.stageMc.stage1.descTxt.text = "Stage 1";
         this.panelMC.panel.stageMc.stage1.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage1.gotoAndStop("enable");
      }
      
      function stage2Desc() : *
      {
         this.panelMC.panel.stageMc.stage2.bgMC.gotoAndStop("stage2");
         this.panelMC.panel.stageMc.stage2.comeTxt.text = "Surprise Attack Division";
         this.panelMC.panel.stageMc.stage2.descTxt.text = "Stage 2";
         this.panelMC.panel.stageMc.stage2.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage2.gotoAndStop("enable");
      }
      
      function stage3Desc() : *
      {
         this.panelMC.panel.stageMc.stage3.bgMC.gotoAndStop("stage3");
         this.panelMC.panel.stageMc.stage3.comeTxt.text = "Sensor Division";
         this.panelMC.panel.stageMc.stage3.descTxt.text = "Stage 3";
         this.panelMC.panel.stageMc.stage3.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage3.gotoAndStop("enable");
      }
      
      function stage4Desc() : *
      {
         this.panelMC.panel.stageMc.stage4.bgMC.gotoAndStop("stage4");
         this.panelMC.panel.stageMc.stage4.comeTxt.text = "Heavy Attack Division";
         this.panelMC.panel.stageMc.stage4.descTxt.text = "Stage 4";
         this.panelMC.panel.stageMc.stage4.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage4.gotoAndStop("enable");
      }
      
      function stage5Desc() : *
      {
         this.panelMC.panel.stageMc.stage5.bgMC.gotoAndStop("stage5");
         this.panelMC.panel.stageMc.stage5.comeTxt.text = "Medical Division";
         this.panelMC.panel.stageMc.stage5.descTxt.text = "Stage 5";
         this.panelMC.panel.stageMc.stage5.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage5.gotoAndStop("enable");
      }
      
      function stage6Desc() : *
      {
         this.panelMC.panel.stageMc.stage6.bgMC.gotoAndStop("stage6");
         this.panelMC.panel.stageMc.stage6.comeTxt.text = "Vadar, The Finale";
         this.panelMC.panel.stageMc.stage6.descTxt.text = "Stage 6";
         this.panelMC.panel.stageMc.stage6.tickMC.visible = false;
         this.panelMC.panel.stageMc.stage6.gotoAndStop("enable");
      }
      
      private function frame48() : *
      {
         this.panelMC.stop();
      }
      
      private function frame81() : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         this.panelMC.stop();
         this.main.handleVillageHUDVisibility(true);
         this.loader.removeAll();
         this.loader.clear();
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.main.clearEvents();
         this.main = null;
         this.eventHandler = null;
         this.tooltip = null;
         this.curr_stage = 0;
         this.curr_chapter = 0;
         this.confirmation = null;
         this.loader = null;
         this.swfName = null;
         this.selected_class = 0;
         GF.clearArray(this.spjounin);
         GF.clearArray(this.CLASS_BTN_NAME_ARR);
         GF.clearArray(this.CLASS_SKILL_ARR);
         GF.clearArray(this.CLASS_NAME_ARR);
         GF.removeAllChild(this.panelMC);
      }
   }
}
