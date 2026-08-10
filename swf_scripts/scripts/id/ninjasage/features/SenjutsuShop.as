package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.SenjutsuInfo;
   import Storage.SenjutsuSkillDescriptions;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class SenjutsuShop extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var tooltip:ToolTip;
      
      private var selectedSkillArray:Array;
      
      private var selectedSenjutsu:String;
      
      private var toadSkillArray:Array = ["skill_3001","skill_3002","skill_3003","skill_3004","skill_3005","skill_3006","skill_3007","skill_3008","skill_3009","skill_3010"];
      
      private var snakeSkillArray:Array = ["skill_3101","skill_3102","skill_3103","skill_3104","skill_3105","skill_3106","skill_3107","skill_3108","skill_3109","skill_3110"];
      
      private var slugSkillArray:Array = ["skill_3201","skill_3202","skill_3203","skill_3204","skill_3205","skill_3206","skill_3207","skill_3208","skill_3209","skill_3210"];
      
      private var toolTipInfoHolder:Array;
      
      public function SenjutsuShop(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.tooltip = ToolTip.getInstance();
         this.panelMC.gotoAndPlay(2);
         this.panelMC.addFrameScript(0,this.frame1,4,this.hideVillage,59,this.frame60,63,this.frame64,68,this.frame69,73,this.frame74);
      }
      
      private function onShowTutorial() : *
      {
         var _loc1_:* = this.panelMC.panelMC;
         _loc1_.txtTitle.text = "Sage Mode Shop";
         _loc1_.lbl_table_desc.text = "Description";
         _loc1_.lbl_table_require.text = "Requirement";
         _loc1_.lbl_table_youhave.text = "You Can Have";
         _loc1_.lbl_table_toad.text = "Toad Sage Mode";
         _loc1_.lbl_table_snake.text = "Snake Sage Mode";
         _loc1_.lbl_table_slug.text = "Slug Sage Mode";
         _loc1_.lbl_table_other.text = "Common Senjutsu";
         _loc1_.txtToadDesc.text = "Senjutsu skill that learn from Toad Elder. Focusing on Physical Strength";
         _loc1_.txReqToad.text = "- Level: 80\n- Pass Ninja Tutor Exam";
         _loc1_.txtHaveToad.text = "1 of the Sage Mode only";
         _loc1_.txtSnakeDesc.text = "Senjutsu skill that learn from Snake Elder. Focusing on Ninjutsu";
         _loc1_.txReqSnake.text = "- Level: 80\n- Pass Ninja Tutor Exam";
         _loc1_.txtHaveSnake.text = "1 of the Sage Mode only";
         _loc1_.txtSlugDesc.text = "Senjutsu skill that learn from Slug Elder. Focusing on Healing";
         _loc1_.txReqSlug.text = "- Level: 80\n- Pass Ninja Tutor Exam";
         _loc1_.txtHaveSlug.text = "1 of the Sage Mode only";
         _loc1_.txtOtherDesc.text = "None";
         _loc1_.txReqOther.text = "- Level: 80\n- Pass Ninja Tutor Exam";
         _loc1_.txtHaveOther.text = "No Limit";
         this.eventHandler.addListener(_loc1_.btnClose,MouseEvent.CLICK,this.closePanel);
         this.main.initButton(_loc1_.btnEnter,this.onShowSelectSenjutsu,"Enter");
      }
      
      private function onShowSelectSenjutsu(param1:MouseEvent = null) : *
      {
         this.panelMC.gotoAndStop("show");
         var _loc2_:* = this.panelMC.panelMC;
         if(Character.character_senjutsu == null)
         {
            _loc2_.isToad.visible = false;
            _loc2_.isSnake.visible = false;
            _loc2_.isSlug.visible = false;
         }
         else if(Character.character_senjutsu == "toad")
         {
            _loc2_.isToad.gotoAndStop("show");
            _loc2_.isToad.visible = true;
            _loc2_.isSnake.visible = false;
            _loc2_.isSlug.visible = false;
         }
         else if(Character.character_senjutsu == "snake")
         {
            _loc2_.isSnake.gotoAndStop("show");
            _loc2_.isToad.visible = false;
            _loc2_.isSnake.visible = true;
            _loc2_.isSlug.visible = false;
         }
         else
         {
            _loc2_.isSlug.gotoAndStop("show");
            _loc2_.isToad.visible = false;
            _loc2_.isSnake.visible = false;
            _loc2_.isSlug.visible = true;
         }
         this.eventHandler.addListener(_loc2_.btnClose,MouseEvent.CLICK,this.closePanel);
         this.main.initButton(_loc2_.btnToad,this.selectSenjutsuMode,"Toad Sage Mode");
         this.main.initButton(_loc2_.btnSnake,this.selectSenjutsuMode,"Snake Sage Mode");
         this.main.initButton(_loc2_.btnSlug,this.selectSenjutsuMode,"Slug Sage Mode");
      }
      
      private function selectSenjutsuMode(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn","");
         this.selectedSenjutsu = _loc2_.toLowerCase();
         this.initSenjutsuUI();
      }
      
      private function initSenjutsuUI() : *
      {
         this.panelMC.gotoAndStop(this.selectedSenjutsu);
         var _loc1_:* = this.panelMC.panelMC;
         _loc1_.confirmBox.gotoAndStop(1);
         var _loc2_:* = SenjutsuInfo.getSenjutsuInfo(this.selectedSenjutsu);
         if(this.selectedSenjutsu == "toad")
         {
            if(Character.character_senjutsu != null)
            {
               _loc1_.txtLearnedDesc.text = "Learned";
               _loc1_.btnLearnToad.visible = false;
            }
            else
            {
               _loc1_.txtLearnedDesc.visible = false;
               _loc1_.btnLearnToad.visible = true;
               this.main.initButton(_loc1_.btnLearnToad,this.learnSenjutsuConfirmation,"Learn");
            }
            this.selectedSkillArray = this.toadSkillArray;
         }
         else if(this.selectedSenjutsu == "snake")
         {
            if(Character.character_senjutsu != null)
            {
               _loc1_.txtLearnedDesc.text = "Learned";
               _loc1_.btnLearnSnake.visible = false;
            }
            else
            {
               _loc1_.txtLearnedDesc.visible = false;
               _loc1_.btnLearnSnake.visible = true;
               this.main.initButton(_loc1_.btnLearnSnake,this.learnSenjutsuConfirmation,"Learn");
            }
            this.selectedSkillArray = this.snakeSkillArray;
         }
         else if(this.selectedSenjutsu == "slug")
         {
            if(Character.character_senjutsu != null)
            {
               _loc1_.txtLearnedDesc.text = "Learned";
               _loc1_.btnLearnSlug.visible = false;
            }
            else
            {
               _loc1_.txtLearnedDesc.visible = false;
               _loc1_.btnLearnSlug.visible = true;
               this.main.initButton(_loc1_.btnLearnSlug,this.learnSenjutsuConfirmation,"Learn");
            }
            this.selectedSkillArray = this.slugSkillArray;
         }
         _loc1_.txtTitle.text = this.selectedSenjutsu.charAt(0).toUpperCase() + this.selectedSenjutsu.substring(1) + " Sage Mode";
         _loc1_.txtSs.text = String(Character.character_ss);
         _loc1_.goldTxt.text = Character.character_gold;
         _loc1_.txtTypeName.text = _loc2_.name;
         _loc1_.txtTypeDesc.text = _loc2_.description;
         _loc1_.txtRequest.text = "Requirement";
         _loc1_.txtRequestDesc.text = "- Level: 80\n- Pass Ninja Tutor Exam";
         this.eventHandler.addListener(_loc1_.btnClose,MouseEvent.CLICK,this.closeSkillTree);
         this.main.initButton(_loc1_.getMoreBtn2,this.openHeadquarter,"");
         this.main.initButton(_loc1_.btnReset,this.openResetSenjutsu,"Reset");
         this.loadSenjutsuSkillTree();
      }
      
      private function loadSenjutsuSkillTree() : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.toolTipInfoHolder = [];
         var _loc1_:* = this.panelMC.panelMC;
         var _loc2_:* = 0;
         while(_loc2_ < 10)
         {
            _loc1_["skill_" + _loc2_].gotoAndStop("enable");
            _loc3_ = "senjutsu_" + this.selectedSenjutsu + "_skill_" + int(_loc2_ + 1);
            _loc4_ = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_loc3_);
            GF.removeAllChild(_loc1_["skill_" + _loc2_].holder);
            NinjaSage.loadIconSWF("skills",this.selectedSkillArray[_loc2_],_loc1_["skill_" + _loc2_].holder,"with_holder");
            this.toolTipInfoHolder.push([_loc4_.name,_loc4_.description]);
            this.eventHandler.addListener(_loc1_["skill_" + _loc2_],MouseEvent.ROLL_OVER,this.toolTiponOver);
            this.eventHandler.addListener(_loc1_["skill_" + _loc2_],MouseEvent.ROLL_OUT,this.toolTiponOut);
            _loc2_++;
         }
      }
      
      private function learnSenjutsuConfirmation(param1:MouseEvent) : *
      {
         this.panelMC.panelMC.confirmBox.gotoAndStop("show");
         var _loc2_:* = SenjutsuInfo.getSenjutsuInfo(this.selectedSenjutsu);
         var _loc3_:* = this.panelMC.panelMC.confirmBox.panelMC;
         _loc3_.okBtn.visible = false;
         var _loc4_:* = _loc2_.token == 0 ? _loc2_.gold + " Gold" : _loc2_.token + " Tokens";
         _loc3_.displayTxt.text = "Are you sure you want to use " + _loc4_ + " to learn " + this.selectedSenjutsu.charAt(0).toUpperCase() + this.selectedSenjutsu.substring(1) + " Sage Mode?" + " You can only learn 1 Sage Mode at a time.";
         this.eventHandler.addListener(_loc3_.yesBtn,MouseEvent.CLICK,this.buySelectedSenjutsu);
         this.eventHandler.addListener(_loc3_.noBtn,MouseEvent.CLICK,this.closeConfirmationBox);
      }
      
      private function buySelectedSenjutsu(param1:MouseEvent) : *
      {
         this.main.amf_manager.service("fBANtsWU39EIjrT8.A9UiY6mwuOY6",[Character.char_id,Character.sessionkey,this.selectedSenjutsu],this.onBuySenjutsuResponse);
      }
      
      private function onBuySenjutsuResponse(param1:Object) : *
      {
         this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
         var _loc2_:* = SenjutsuInfo.getSenjutsuInfo(this.selectedSenjutsu);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            if(_loc2_.token == 0)
            {
               Character.character_gold = String(Number(Character.character_gold) - Number(_loc2_.gold));
            }
            else
            {
               Character.account_tokens = Number(Character.account_tokens) - Number(_loc2_.token);
            }
            this.panelMC.panelMC.txtLearnedDesc.visible = true;
            this.panelMC.panelMC.txtLearnedDesc.text = "Learned";
            if(this.selectedSenjutsu == "toad")
            {
               this.panelMC.panelMC.btnLearnToad.visible = false;
            }
            else if(this.selectedSenjutsu == "toad")
            {
               this.panelMC.panelMC.btnLearnSnake.visible = false;
            }
            else if(this.selectedSenjutsu == "slug")
            {
               this.panelMC.panelMC.btnLearnSlug.visible = false;
            }
            Character.character_senjutsu = param1.type;
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
      
      private function toolTiponOver(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         _loc2_ = _loc2_.replace("skill_","");
         var _loc3_:* = "" + "<b>" + this.toolTipInfoHolder[_loc2_][0] + "</b>" + "\n\n" + this.toolTipInfoHolder[_loc2_][1];
         this.main.stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc3_);
      }
      
      private function toolTiponOut(param1:MouseEvent) : *
      {
         this.tooltip.hide();
      }
      
      private function openHeadquarter(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("Headquarter","Headquarter");
      }
      
      private function openResetSenjutsu(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("ResetSenjutsu","ResetSenjutsu");
      }
      
      private function closeConfirmationBox(param1:MouseEvent) : *
      {
         this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
      }
      
      private function closeSkillTree(param1:MouseEvent) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 10)
         {
            GF.removeAllChild(this.panelMC.panelMC["skill_" + _loc2_].holder);
            _loc2_++;
         }
         this.onShowSelectSenjutsu();
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      private function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.handleVillageHUDVisibility(true);
         if(this.tooltip)
         {
            this.tooltip.destroy();
            this.tooltip = null;
         }
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.selectedSenjutsu = null;
         this.selectedSkillArray = null;
         this.main = null;
         GF.clearArray(this.toadSkillArray);
         GF.clearArray(this.snakeSkillArray);
         GF.clearArray(this.toolTipInfoHolder);
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
      
      internal function frame1() : *
      {
         this.panelMC.stop();
      }
      
      internal function hideVillage() : *
      {
         this.main.handleVillageHUDVisibility(false);
      }
      
      internal function frame60() : *
      {
         this.onShowTutorial();
         this.panelMC.stop();
      }
      
      internal function frame64() : *
      {
         this.panelMC.confirmBox.gotoAndStop(1);
         this.panelMC.stop();
      }
      
      internal function frame69() : *
      {
         this.panelMC.stop();
      }
      
      internal function frame74() : *
      {
         this.panelMC.stop();
      }
   }
}

