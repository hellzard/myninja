package id.ninjasage.features
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class JouninExam extends MovieClip
   {
      
      public var panelMC:MovieClip;
      
      public var main:*;
      
      public var target:int;
      
      public var response:Object;
      
      public function JouninExam(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.getData();
      }
      
      public function getData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("JouninExam.getData",[Character.sessionkey,Character.char_id],this.onGetJouninData);
      }
      
      public function onGetJouninData(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1.data;
            this.panelMC.panel.rightPanel.visible = false;
            this.panelMC.panel.parent_mc = this;
            this.panelMC.panel.btnClose.addEventListener(MouseEvent.CLICK,this.closePanel);
            this.panelMC.panel.btnClaim.visible = false;
            _loc2_ = true;
            _loc3_ = 0;
            while(_loc3_ < this.response.length)
            {
               this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].gotoAndStop(1);
               if(this.response[_loc3_].status == "2")
               {
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].tickMC.visible = true;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].buttonMode = true;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].addEventListener(MouseEvent.MOUSE_OVER,this.over);
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].addEventListener(MouseEvent.MOUSE_OUT,this.out);
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].addEventListener(MouseEvent.CLICK,this.click);
               }
               else if(this.response[_loc3_].status == "1")
               {
                  _loc2_ = false;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].tickMC.visible = false;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].buttonMode = true;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].addEventListener(MouseEvent.MOUSE_OVER,this.over);
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].addEventListener(MouseEvent.MOUSE_OUT,this.out);
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].addEventListener(MouseEvent.CLICK,this.click);
               }
               else
               {
                  _loc2_ = false;
                  this.panelMC.panel["stage" + String(int(_loc3_) + int(1))].gotoAndStop(4);
               }
               _loc3_++;
            }
            if(Boolean(_loc2_) && this.response[0].claimed == "0")
            {
               this.panelMC.panel.btnClaim.visible = true;
               this.panelMC.panel.btnClaim.addEventListener(MouseEvent.CLICK,this.promoteToJounin);
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
         if(this.response[param1 - 1].status == "2")
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
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage I - Hand Seals";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "To be promoted to Jounin, you need to pass a series of tests and exams. First test: can you learn a jutsu quickly?";
               break;
            case 2:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage II - Shinobi Tower";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Reach the top of the Tower. Note: Team mates aren\'t allowed to go inside of the tower with you.";
               break;
            case 3:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage III - The Kekkai";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Unseal all the Kekkai in the forest.";
               break;
            case 4:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage IV - The Elements";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Lead your team and challenge the Shinkigami of Elements!";
               break;
            case 5:
               this.panelMC.panel.rightPanel.tabMc.titleTxt.text = "Stage V - The Orochi";
               this.panelMC.panel.rightPanel.tabMc.msgTxt.text = "Hunt Orochi the Yamata No Orochi. Advice: Make sure you recruit 2 team mates to assist you in this mission. Mission Complete upon capture of the Giant Snake (only).";
         }
         this.panelMC.panel.rightPanel.tabMc.btnStart.addEventListener(MouseEvent.CLICK,this.startStage);
      }
      
      public function promoteToJounin(param1:MouseEvent) : *
      {
         param1.currentTarget.visible = false;
         this.main.loading(true);
         this.main.amf_manager.service("JouninExam.promoteToJounin",[Character.sessionkey,Character.char_id],this.onPromoteJouninRes);
      }
      
      public function onPromoteJouninRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status == 1)
            {
               this.main.makeJounin(param1.rewards);
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
      
      public function startStage(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("JouninExam.startStage",[Character.sessionkey,Character.char_id,int(this.target) + 5],this.onStageStartRes);
      }
      
      public function onStageStartRes(param1:Object) : *
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
                  this.main.loadJouninStage("stage1");
                  this.destroy();
               }
               else if(param1.result == "start_stage_2")
               {
                  this.main.loadJouninStage("stage2");
                  this.destroy();
               }
               else if(param1.result == "start_stage_3")
               {
                  this.main.loadJouninStage("stage3");
                  this.destroy();
               }
               else if(param1.result == "start_stage_4")
               {
                  this.main.loadJouninStage("stage4");
                  this.destroy();
               }
               else if(param1.result == "start_stage_5")
               {
                  this.main.loadJouninStage("stage5");
                  this.destroy();
               }
            }
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         this.panelMC.panel.btnClose.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.panelMC.panel.stage1.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.panelMC.panel.stage1.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.panelMC.panel.stage1.removeEventListener(MouseEvent.CLICK,this.click);
         this.panelMC.panel.rightPanel.tabMc.btnStart.removeEventListener(MouseEvent.CLICK,this.startStage);
         this.target = 0;
         this.main = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}

