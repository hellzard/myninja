package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.SkillLibrary;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import id.ninjasage.EscapeKeyManager;
   
   public class SpecialClassChange extends MovieClip
   {
      
      private static var CLASS_BTN_NAME_ARR:Array = ["select_info","select_surprise","select_perceive","select_attack","select_heal"];
      
      private static var CLASS_SKILL_ARR:Array = ["skill_4002","skill_4004","skill_4001","skill_4003","skill_4000"];
       
      
      private var escapeKey:EscapeKeyManager;
      
      private var CLASS_NAME_ARR:Array;
      
      public var panelMC:MovieClip;
      
      private var dimFilter:ColorMatrixFilter;
      
      private var EXAM_SPECIAL_JOUNIN_ARR:Array;
      
      private var skillArr:Array;
      
      private var curClass:uint = 0;
      
      private var orgClass:int;
      
      private var isEmblem;
      
      private var langArr:Array;
      
      private var price:Array;
      
      private var changeClassPrice:int;
      
      private var currentSelectId:int = -1;
      
      private var main;
      
      private var tooltip;
      
      public function SpecialClassChange(param1:*, param2:*)
      {
         this.CLASS_NAME_ARR = ["Intelligence Class","Surprise Attack Class","Sensor Class","Heavy Attack Class","Medical Class"];
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.hide);
         this.dimFilter = CreateFilter.getSaturationFilter(0);
         this.skillArr = [];
         this.price = [2000,3000];
         super();
         this.tooltip = new skillToolTip();
         this.tooltip.gotoAndStop(1);
         this.tooltip.scaleX = 0.8;
         this.tooltip.scaleY = 0.8;
         this.langArr = ["Class Exchange Platform","Please select ONE of the following classes (except current selection)","Class skill can be used ONCE for each battle.","Emblem Ninjas cost 2000 tokens while Free Ninjas cost 3000 tokens respectively for following class changes.","Intelligence Class","Assault Class","Sensation Class","Offense Class","Medical Class","Learnt","","Class change requires learning fee. Are you sure?","Require:","Do you want to change from \"[oldClassName]\" to \"[newClassName]\"? ","Current Class","New Class","<font size=\'14\'>How to change class?<br><br>Make sure you have achieved the following requirements before any class changes including:<br>i) you have reached LV60 or above;<br>ii) you have completed the \"Special Jounin Exam\" and<br>iii) you have selected your chosen class</font>"];
         this.isEmblem = Character.account_type;
         if(this.isEmblem == 1)
         {
            this.changeClassPrice = this.price[0];
         }
         else
         {
            this.changeClassPrice = this.price[1];
         }
         this.onShow();
      }
      
      public function onShow() : void
      {
         this.panelMC.stop();
         var _loc1_:MovieClip = this.panelMC.panelMC;
         _loc1_.addFrameScript(36,this.stopList);
         _loc1_["showPopupConfirmMc"].visible = false;
         _loc1_["showPopupMc"].visible = false;
         _loc1_["btnClose"].addEventListener(MouseEvent.CLICK,this.hide);
         _loc1_["titleTxt"].text = this.langArr[0];
         _loc1_["displayTxt"].htmlText = this.langArr[2];
         _loc1_["displayTxt2"].visible = false;
         this.main.initButton(_loc1_["btnComfirm"],this.gotoConfirmClass,"Change");
         this.main.initButtonDisable(_loc1_["btnComfirm"],this.gotoConfirmClass,"Change");
         _loc1_["btnComfirm"].filters = [this.dimFilter];
         this.updateClassIcon();
      }
      
      public function stopList() : void
      {
         var _loc1_:MovieClip = this.panelMC.panelMC;
         _loc1_.stop();
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            if(_loc1_[CLASS_BTN_NAME_ARR[_loc2_]].id == -1)
            {
               _loc1_[CLASS_BTN_NAME_ARR[_loc2_]].filters = [this.dimFilter];
               _loc1_["skillLearned_txt_" + this.orgClass].visible = true;
               _loc1_["skillLearned_txt_" + this.orgClass].text = this.langArr[9];
            }
            else
            {
               _loc1_["arrow_" + _loc2_].visible = true;
            }
            _loc2_++;
         }
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         this.destroy();
      }
      
      private function updateClassIcon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         this.panelMC["panelMC"].gotoAndPlay("show");
         var _loc3_:* = 0;
         while(_loc3_ < CLASS_SKILL_ARR.length)
         {
            if(Character.character_class == CLASS_SKILL_ARR[_loc3_])
            {
               this.orgClass = _loc3_;
            }
            _loc3_++;
         }
         var _loc4_:MovieClip = this.panelMC["panelMC"];
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            _loc4_["arrow_" + _loc1_].visible = false;
            _loc4_["skillLearned_txt_" + _loc1_].visible = false;
            _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].gotoAndStop(1);
            if(_loc1_ != this.orgClass)
            {
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]]["classTitle"].text = this.langArr[4 + _loc1_];
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]]["highlightMC"].visible = false;
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].addEventListener(MouseEvent.CLICK,this.changeClass);
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverClassBtn);
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutClassBtn);
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveClassBtn);
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].thisType = _loc1_ + 1;
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].id = _loc1_ + 1;
            }
            else
            {
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]]["classTitle"].text = this.langArr[4 + _loc1_];
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]]["highlightMC"].visible = false;
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].thisType = _loc1_ + 1;
               _loc4_[CLASS_BTN_NAME_ARR[_loc1_]].id = -1;
            }
            _loc1_++;
         }
      }
      
      private function changeClass(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = this.panelMC["panelMC"];
         _loc3_["btnComfirm"].filters = null;
         this.curClass = param1.currentTarget.thisType;
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            if(_loc3_[CLASS_BTN_NAME_ARR[_loc2_]].id != -1)
            {
               if(this.curClass == _loc2_ + 1)
               {
                  if(_loc3_[CLASS_BTN_NAME_ARR[_loc2_]].hasEventListener(MouseEvent.CLICK))
                  {
                     _loc3_[CLASS_BTN_NAME_ARR[_loc2_]].removeEventListener(MouseEvent.CLICK,this.changeClass);
                  }
                  _loc3_[CLASS_BTN_NAME_ARR[_loc2_]].gotoAndStop(3);
                  _loc3_[CLASS_BTN_NAME_ARR[_loc2_]]["highlightMC"].visible = true;
               }
               else
               {
                  if(!_loc3_[CLASS_BTN_NAME_ARR[_loc2_]].hasEventListener(MouseEvent.CLICK))
                  {
                     _loc3_[CLASS_BTN_NAME_ARR[_loc2_]].addEventListener(MouseEvent.CLICK,this.changeClass);
                  }
                  this.enableButton(_loc3_[CLASS_BTN_NAME_ARR[_loc2_]],this.changeClass,null);
                  _loc3_[CLASS_BTN_NAME_ARR[_loc2_]]["highlightMC"].visible = false;
                  _loc3_[CLASS_BTN_NAME_ARR[_loc2_]].filters = null;
               }
            }
            _loc2_++;
         }
         if(!_loc3_["btnComfirm"].hasEventListener(MouseEvent.CLICK))
         {
            this.enableButton(_loc3_["btnComfirm"],this.gotoConfirmClass,"Change");
         }
      }
      
      private function gotoConfirmClass(param1:MouseEvent = null) : void
      {
         this.currentSelectId = this.curClass;
         this.onShowConfirmPopup();
      }
      
      public function onShowConfirmPopup() : void
      {
         this.panelMC["panelMC"]["showPopupConfirmMc"].visible = true;
         var _loc1_:* = this.panelMC["panelMC"]["showPopupConfirmMc"]["panel"];
         _loc1_["oldClass"].gotoAndStop(1);
         _loc1_["newClass"].gotoAndStop(1);
         _loc1_["btnClose"].addEventListener(MouseEvent.CLICK,this.hideConfirmPopup);
         _loc1_["btnOk"].addEventListener(MouseEvent.CLICK,this.confirmedChangeClass);
         _loc1_["oldClassTxt"].text = this.langArr[14];
         _loc1_["newClassTxt"].text = this.langArr[15];
         _loc1_["detailTxt"].text = this.langArr[13].replace("[oldClassName]",this.langArr[4 + this.orgClass]).replace("[newClassName]",this.langArr[3 + this.currentSelectId]);
         _loc1_["newClass"]["icon"].gotoAndStop(this.currentSelectId);
         _loc1_["newClass"]["classIcon"].gotoAndStop(this.currentSelectId);
         _loc1_["newClass"]["classTitle"].text = this.langArr[3 + this.currentSelectId];
         _loc1_["oldClass"]["icon"].gotoAndStop(1 + this.orgClass);
         _loc1_["oldClass"]["classIcon"].gotoAndStop(1 + this.orgClass);
         _loc1_["oldClass"]["classTitle"].text = this.langArr[4 + this.orgClass];
         _loc1_["oldClass"]["highlightMC"].visible = false;
         _loc1_["oldClass"].filters = [this.dimFilter];
         _loc1_["skillLearned_txt_1"].text = this.langArr[9];
      }
      
      private function hideConfirmPopup(param1:MouseEvent = null) : void
      {
         this.panelMC["panelMC"]["showPopupConfirmMc"].visible = false;
      }
      
      private function confirmedChangeClass(param1:MouseEvent) : void
      {
         this.hideConfirmPopup();
         this.onShowPopup();
      }
      
      public function onShowPopup() : void
      {
         this.panelMC.panelMC["showPopupMc"].visible = true;
         var _loc1_:* = this.panelMC.panelMC.showPopupMc["panel"];
         _loc1_["btnClose"].addEventListener(MouseEvent.CLICK,this.hidePopup);
         _loc1_["btnOk"].addEventListener(MouseEvent.CLICK,this.confirmedPayToken);
         _loc1_["detailTxt_1"].text = this.langArr[3];
         _loc1_["detailTxt_2"].text = this.langArr[11];
         _loc1_["tokenReauire"].text = this.langArr[12];
         _loc1_["tokenAmount"].text = this.changeClassPrice;
      }
      
      private function hidePopup(param1:MouseEvent) : void
      {
         this.panelMC["panelMC"]["showPopupMc"].visible = false;
      }
      
      private function confirmedPayToken(param1:MouseEvent) : void
      {
         this.panelMC["panelMC"]["showPopupMc"].visible = false;
         if(Character.account_tokens < this.changeClassPrice)
         {
            this.main.showMessage("Token is not enough!");
            return;
         }
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.by6Fn6mOEsAS",[Character.char_id,Character.sessionkey,CLASS_SKILL_ARR[this.curClass - 1]],this.getBuyResponse);
      }
      
      private function getBuyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.character_class = CLASS_SKILL_ARR[this.curClass - 1];
            Character.account_tokens -= this.changeClassPrice;
            this.main.showMessage(param1.result);
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
      
      private function enableButton(param1:*, param2:Function, param3:String = null) : void
      {
         param1.stop();
         param1["clickMask"].buttonMode = true;
         param1.gotoAndStop(1);
         if(!param1.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutEffect);
         }
         if(!param1.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverEffect);
         }
         if(!param1.hasEventListener(MouseEvent.CLICK))
         {
            param1.addEventListener(MouseEvent.CLICK,param2);
         }
         if(param3 != null && param3 != "")
         {
            param1["txt"].text = param3;
         }
         param1.filters = null;
      }
      
      private function mouseOutEffect(param1:MouseEvent = null) : void
      {
         param1.currentTarget.gotoAndStop(1);
      }
      
      private function mouseOverEffect(param1:MouseEvent = null) : void
      {
         param1.currentTarget.gotoAndStop(2);
      }
      
      private function mouseOutClassBtn(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = param1.currentTarget.thisType;
         param1.currentTarget.gotoAndStop(1);
         GF.removeAllChild(this.panelMC["panelMC"]["tooltipHolder" + _loc2_]);
      }
      
      private function mouseOverClassBtn(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = param1.currentTarget.thisType;
         param1.currentTarget.gotoAndStop(2);
         var _loc3_:* = CLASS_SKILL_ARR[_loc2_ - 1];
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
         this.tooltip.iconMC.gotoAndStop(1);
         GF.removeAllChild(this.tooltip.iconMC.iconHolder);
         NinjaSage.loadIconSWF("skills",_loc3_,this.tooltip.iconMC.iconHolder,"icon");
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
         this.panelMC["panelMC"]["tooltipHolder" + _loc2_].addChild(this.tooltip);
      }
      
      private function mouseMoveClassBtn(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = param1.currentTarget.thisType;
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.removeAllChild(this.tooltip.iconMC.iconHolder);
         GF.removeAllChild(this.tooltip);
         NinjaSage.clearLoader();
         this.main.removeExternalSwfPanel();
         this.langArr = [];
         this.tooltip = null;
         this.dimFilter = null;
         this.main = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
