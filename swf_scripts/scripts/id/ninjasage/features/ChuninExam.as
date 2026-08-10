package id.ninjasage.features
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EventHandler;
   
   public class ChuninExam extends MovieClip
   {
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var target:int;
      
      private var eventHandler:EventHandler;
      
      public function ChuninExam(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.eventHandler = new EventHandler();
         this.main.loading(true);
         this.getData();
      }
      
      public function getData() : void
      {
         this.main.amf_manager.service("ChuninExam.getData",[Character.sessionkey,Character.char_id],this.onGetChuninData);
      }
      
      public function onGetChuninData(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.panel.chunin_data = param1.data;
            this.panelMC.panel.rightPanel.visible = false;
            this.eventHandler.addListener(this.panelMC.panel.btnClose,MouseEvent.CLICK,this.closePanel);
            this.panelMC.panel.btnClaim.visible = false;
            _loc2_ = true;
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].gotoAndStop(1);
               if(this.panelMC.panel.chunin_data[_loc3_].status == "2")
               {
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].tickMC.visible = true;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].buttonMode = true;
                  this.eventHandler.addListener(this.panelMC.panel["stage" + String(int(_loc3_) + int(1))],MouseEvent.MOUSE_OVER,this.over);
                  this.eventHandler.addListener(this.panelMC.panel["stage" + String(int(_loc3_) + int(1))],MouseEvent.MOUSE_OUT,this.out);
                  this.eventHandler.addListener(this.panelMC.panel["stage" + String(int(_loc3_) + int(1))],MouseEvent.CLICK,this.click);
               }
               else if(this.panelMC.panel.chunin_data[_loc3_].status == "1")
               {
                  _loc2_ = false;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].tickMC.visible = false;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].buttonMode = true;
                  this.eventHandler.addListener(this.panelMC.panel["stage" + String(int(_loc3_) + int(1))],MouseEvent.MOUSE_OVER,this.over);
                  this.eventHandler.addListener(this.panelMC.panel["stage" + String(int(_loc3_) + int(1))],MouseEvent.MOUSE_OUT,this.out);
                  this.eventHandler.addListener(this.panelMC.panel["stage" + String(int(_loc3_) + int(1))],MouseEvent.CLICK,this.click);
               }
               else
               {
                  _loc2_ = false;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].gotoAndStop(4);
               }
               _loc3_++;
            }
            if(Boolean(_loc2_) && this.panelMC.panel.chunin_data[0].claimed == "0")
            {
               this.panelMC.panel.btnClaim.visible = true;
               this.eventHandler.addListener(this.panelMC.panel.btnClaim,MouseEvent.CLICK,this.promoteToChunin);
            }
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      internal function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame != 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      internal function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame != 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      internal function click(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(3);
         this.target = int(param1.currentTarget.name.replace("stage",""));
         this.panelMC.panel.rightPanel.visible = true;
         this.panelMC.panel.rightPanel.tabMc.gotoAndStop(this.target);
         this.setRightPanel(this.target);
      }
      
      internal function setRightPanel(param1:int) : void
      {
         if(this.panelMC.panel.chunin_data[param1 - 1].status == "2")
         {
            this.panelMC.panel.rightPanel.tabMc.btnStart.visible = false;
            this.panelMC.panel.rightPanel.tabMc.completeMC.visible = true;
         }
         else
         {
            this.panelMC.panel.rightPanel.tabMc.btnStart.visible = true;
            this.panelMC.panel.rightPanel.tabMc.completeMC.visible = false;
         }
         switch(param1)
         {
            case 1:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage I - Written Test";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "To be promoted to Chunin, you need to pass a series of tests and exams. The first round is a written test.";
               break;
            case 2:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage II - Scroll War";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Don\'t forget to recruit your teammates before you start your next exam.";
               break;
            case 3:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage III - Arena";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "The third exam is to finish a 1vs1 battle you will fight with other ninja candidates. Note: No teammates can go inside the Tower with you!";
               break;
            case 4:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage IV - Team Battle";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Team cooperation is very important. The final exam is to test your teamwork.";
               break;
            case 5:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage V - Finale";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Help Shin and Genzu to defeat Kojima and save Ken. Note: No teammates can go inside with you!";
         }
         this.eventHandler.addListener(this.panelMC.panel.rightPanel.tabMc.btnStart,MouseEvent.CLICK,this.startStage);
      }
      
      public function promoteToChunin(param1:MouseEvent) : void
      {
         param1.currentTarget.visible = false;
         this.main.loading(true);
         this.main.amf_manager.service("ChuninExam.promoteToChunin",[Character.sessionkey,Character.char_id],this.onPromoteChuninRes);
      }
      
      public function onPromoteChuninRes(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status == 1)
            {
               this.main.makeChunin(param1.rewards);
            }
            else
            {
               this.main.getNotice(param1.result);
            }
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function startStage(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("ChuninExam.startStage",[Character.sessionkey,Character.char_id,this.target],this.onStageStartRes);
      }
      
      public function onStageStartRes(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = param1.hash;
            _loc3_ = param1.result.split("_");
            if(int(this.target) == int(_loc3_[2]))
            {
               if(param1.result == "start_stage_1")
               {
                  this.main.loadStage("stage1");
               }
               else if(param1.result == "start_stage_2")
               {
                  this.main.loadStage("stage2");
               }
               else if(param1.result == "start_stage_3")
               {
                  this.main.loadStage("stage3");
               }
               else if(param1.result == "start_stage_4")
               {
                  this.main.loadStage("stage4");
               }
               else if(param1.result == "start_stage_5")
               {
                  this.main.loadStage("stage5");
               }
               this.destroy();
            }
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
      
      public function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.target = 0;
         this.main = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}

