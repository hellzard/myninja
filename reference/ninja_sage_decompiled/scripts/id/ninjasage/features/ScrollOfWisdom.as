package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ScrollOfWisdom extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var selectedElementSkill:Array;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var selectedElementType:int;
      
      private var elementName:String;
      
      private var wind_skills:Array;
      
      private var water_skills:Array;
      
      private var fire_skills:Array;
      
      private var thunder_skills:Array;
      
      private var earth_skills:Array;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var response:Object;
      
      public function ScrollOfWisdom(param1:*, param2:*)
      {
         var _loc3_:* = GameData.get("sow");
         this.wind_skills = _loc3_.wind;
         this.fire_skills = _loc3_.fire;
         this.thunder_skills = _loc3_.thunder;
         this.earth_skills = _loc3_.earth;
         this.water_skills = _loc3_.water;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.getData();
      }
      
      private function getData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("MyaDpgue7uwc5ovg.y3rADoLQpEsN",[Character.char_id,Character.sessionkey],this.onGetData);
      }
      
      private function onGetData(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.initUI();
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
      
      private function initUI() : *
      {
         var _loc2_:* = undefined;
         this.eventHandler.addListener(this.panelMC.panel.btnClose,MouseEvent.CLICK,this.closePanel);
         this.panelMC.panel.titleTxt.text = "Secret Scroll of Wisdom";
         this.panelMC.panel.subTitleTxt.text = "With Secret Scroll of Wisdom, you can instantly learn ALL skills from one element (not including upgrade token skills and event skills)";
         this.panelMC.panel.titleTxt2.text = "You have";
         this.panelMC.panel.essenceNum.text = this.response.scrolls;
         this.panelMC.panel.warningTxt.text = "Using Secret Scroll of Wisdom will not affect the skills you have learnt.";
         this.panelMC.panel.claimBtn.visible = false;
         this.panelMC.panel.popupConfirmMc.visible = false;
         this.panelMC.panel.popUpGetReward.visible = false;
         this.panelMC.panel.helpMc.visible = false;
         var _loc1_:* = 1;
         while(_loc1_ < 6)
         {
            this.panelMC.panel["tab" + _loc1_].skillIcon.gotoAndStop(_loc1_);
            this.panelMC.panel["tab" + _loc1_].upgradeBtn.visible = false;
            this.panelMC.panel["tab" + _loc1_].claimBtn.visible = false;
            this.panelMC.panel["tab" + _loc1_].IconMc.visible = false;
            this.panelMC.panel["tab" + _loc1_].NumMc.visible = false;
            this.panelMC.panel["tab" + _loc1_].tickIcon.visible = false;
            this.panelMC.panel["tab" + _loc1_].learnedTxt.visible = false;
            this.eventHandler.addListener(this.panelMC.panel["tab" + _loc1_].btnHelp,MouseEvent.CLICK,this.openHelp);
            _loc2_ = 1;
            while(_loc2_ < 4)
            {
               if(_loc1_ == int(Character["character_element_" + _loc2_]))
               {
                  this.panelMC.panel["tab" + _loc1_].IconMc.visible = true;
                  this.panelMC.panel["tab" + _loc1_].NumMc.visible = true;
                  this.panelMC.panel["tab" + _loc1_].claimBtn.visible = true;
                  this.panelMC.panel["tab" + _loc1_].lockTxt.visible = false;
                  this.main.initButton(this.panelMC.panel["tab" + _loc1_].claimBtn,this.showConfirmation,"Learn");
               }
               _loc2_++;
            }
            this.checkAllSkillOwned(_loc1_);
            _loc1_++;
         }
      }
      
      private function checkAllSkillOwned(param1:int) : *
      {
         var _loc2_:Array = this.getElement(param1);
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(this.hasSkill(_loc2_[_loc4_]) > 0)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         if(_loc2_.length == _loc3_)
         {
            this.panelMC.panel["tab" + param1].tickIcon.visible = true;
            this.panelMC.panel["tab" + param1].learnedTxt.visible = true;
            this.panelMC.panel["tab" + param1].IconMc.visible = false;
            this.panelMC.panel["tab" + param1].NumMc.visible = false;
            this.panelMC.panel["tab" + param1].claimBtn.visible = false;
         }
      }
      
      private function showConfirmation(param1:MouseEvent) : *
      {
         this.panelMC.panel.popupConfirmMc.visible = true;
         this.selectedElementType = param1.currentTarget.parent.name.replace("tab","");
         this.main.initButton(this.panelMC.panel.popupConfirmMc.panel.btnClose,this.closeConfirmation,"Cancel");
         this.main.initButton(this.panelMC.panel.popupConfirmMc.panel.okMc,this.claimAllSkill,"Confirm");
      }
      
      private function claimAllSkill(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("MyaDpgue7uwc5ovg.r0jrW8WCqCOt",[Character.char_id,Character.sessionkey,this.selectedElementType],this.claimResponse);
      }
      
      private function claimResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.character_skills = param1.skills;
            Character.removeEssentials("essential_10",1);
            --this.response.scrolls;
            this.initUI();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.closeConfirmation();
      }
      
      private function closeConfirmation(param1:* = null) : *
      {
         this.panelMC.panel.popupConfirmMc.visible = false;
      }
      
      private function openHelp(param1:MouseEvent) : *
      {
         this.panelMC.panel.helpMc.visible = true;
         this.selectedElementType = param1.currentTarget.parent.name.replace("tab","");
         this.selectedElementSkill = this.getElement(this.selectedElementType);
         this.panelMC.panel.helpMc.panel.titleTxt.text = "Ninjutsu - " + this.elementName;
         this.panelMC.panel.helpMc.panel.skillNumTxt.text = "Total " + this.selectedElementSkill.length + " Skills";
         this.panelMC.panel.helpMc.panel.skillTypeIcon.gotoAndStop(this.elementName.toLowerCase());
         this.eventHandler.addListener(this.panelMC.panel.helpMc.panel.btnPrevPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.panel.helpMc.panel.btnNextPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.panel.helpMc.panel.btnClose,MouseEvent.CLICK,this.closeHelp);
         this.totalPage = Math.max(Math.ceil(this.selectedElementSkill.length / 15),1);
         this.showSkillIcon();
      }
      
      private function closeHelp(param1:MouseEvent) : *
      {
         this.panelMC.panel.helpMc.visible = false;
         this.currentPage = 1;
         this.totalPage = 1;
         var _loc2_:* = 0;
         while(_loc2_ < 15)
         {
            GF.removeAllChild(this.panelMC.panel.helpMc.panel["skill" + _loc2_].iconHolder);
            _loc2_++;
         }
      }
      
      private function showSkillIcon() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 15)
         {
            GF.removeAllChild(this.panelMC.panel.helpMc.panel["skill" + _loc1_].iconHolder);
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 15);
            if(this.selectedElementSkill.length > _loc2_)
            {
               this.panelMC.panel.helpMc.panel["skill" + _loc1_].visible = true;
               this.panelMC.panel.helpMc.panel["skill" + _loc1_].cdTxt.visible = this.hasSkill(this.selectedElementSkill[_loc2_]) > 0 ? true : false;
               NinjaSage.loadItemIcon(this.panelMC.panel.helpMc.panel["skill" + _loc1_].iconHolder,this.selectedElementSkill[_loc2_],"icon");
            }
            else
            {
               this.panelMC.panel.helpMc.panel["skill" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.updatePageNumber();
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNextPage":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.showSkillIcon();
               }
               break;
            case "btnPrevPage":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.showSkillIcon();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : *
      {
         this.panelMC.panel.helpMc.panel.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function getElement(param1:int) : *
      {
         switch(param1)
         {
            case 1:
               this.elementName = "Wind";
               return this.wind_skills;
            case 2:
               this.elementName = "Fire";
               return this.fire_skills;
            case 3:
               this.elementName = "Lightning";
               return this.thunder_skills;
            case 4:
               this.elementName = "Earth";
               return this.earth_skills;
            case 5:
               this.elementName = "Water";
               return this.water_skills;
            default:
               return;
         }
      }
      
      private function hasSkill(param1:*) : *
      {
         var _loc2_:* = [];
         if(Character.character_skills != "")
         {
            if(Character.character_skills.indexOf(",") >= 0)
            {
               _loc2_ = Character.character_skills.split(",");
            }
            else
            {
               _loc2_ = [Character.character_skills];
            }
         }
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc4_])
            {
               _loc3_ = 1;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         var _loc1_:* = 0;
         while(_loc1_ < 15)
         {
            GF.removeAllChild(this.panelMC.panel.helpMc.panel["skill" + _loc1_].iconHolder);
            this.panelMC.panel.helpMc.panel["skill" + _loc1_].tooltip = null;
            _loc1_++;
         }
         this.wind_skills = [];
         this.fire_skills = [];
         this.thunder_skills = [];
         this.earth_skills = [];
         this.water_skills = [];
         this.selectedElementSkill = [];
         NinjaSage.clearLoader();
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.response = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
