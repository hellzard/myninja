package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.SenjutsuLevelLearnRequirements;
   import Storage.SenjutsuSkillDescriptions;
   import Storage.SenjutsuSkillLevel;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class SenjutsuProfile extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var selectedCategorySkill:Array;
      
      private var selectedCategoryType:String;
      
      private var tooltip:ToolTip;
      
      private var selectedBuySS:int;
      
      private var upgradeSkillId:String;
      
      private var upgradePrice:int;
      
      private var upgradeSkillLevel:int;
      
      private var removingSkill:Boolean = false;
      
      private var openType:String;
      
      private var sageScrollShop:Array;
      
      private var senjutsuSkills:Array;
      
      private var senjutsuOther:Array;
      
      private var iconCollection:Array;
      
      private var toolTipInfoHolder:Array;
      
      private var senjutsuEquippedSkills:Array;
      
      private var maxEquipableSlot:int;
      
      private var isMax:Boolean = false;
      
      private var upgradeBtnData:Object;
      
      public function SenjutsuProfile(param1:*, param2:*, param3:* = "equip")
      {
         this.sageScrollShop = [];
         this.senjutsuSkills = [];
         this.senjutsuOther = [];
         this.iconCollection = [];
         this.toolTipInfoHolder = [];
         this.senjutsuEquippedSkills = [];
         this.sageScrollShop = [{
            "price":20,
            "amount":10
         },{
            "price":100,
            "amount":55
         },{
            "price":200,
            "amount":120
         },{
            "price":400,
            "amount":250
         }];
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.openType = param3;
         this.eventHandler = new EventHandler();
         this.tooltip = ToolTip.getInstance();
         this.main.handleVillageHUDVisibility(false);
         this.getSenjutsuFromAmf();
      }
      
      private function getSenjutsuFromAmf() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("fBANtsWU39EIjrT8.BMMQvYvp2ME8",[Character.char_id,Character.sessionkey],this.onAmfResponse);
      }
      
      private function onAmfResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.senjutsuSkills = [];
            this.senjutsuOther = [];
            this.toolTipInfoHolder = [];
            _loc2_ = 0;
            while(_loc2_ < param1.data.length)
            {
               if(param1.data[_loc2_].type == Character.character_senjutsu)
               {
                  this.senjutsuSkills.push(param1.data[_loc2_]);
               }
               else
               {
                  this.senjutsuOther.push(param1.data[_loc2_]);
               }
               _loc2_++;
            }
            this.getBasicData();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function getBasicData() : *
      {
         if(Character.character_senjutsu != null)
         {
            this.selectedCategorySkill = this.senjutsuSkills;
            this.selectedCategoryType = Character.character_senjutsu;
         }
         else
         {
            this.selectedCategorySkill = this.senjutsuOther;
            this.selectedCategoryType = "other";
         }
         if(this.openType == "equip")
         {
            this.panelMC.gotoAndStop("install_toad_snake");
            this.setEquipModeButton();
            this.initEquipUI();
         }
         else if(Character.character_senjutsu == null)
         {
            this.panelMC.gotoAndStop("install_toad_snake");
         }
         else
         {
            this.panelMC.gotoAndStop("show_" + Character.character_senjutsu);
            this.initBasicUpgradeUI();
         }
      }
      
      private function initBasicUpgradeUI() : *
      {
         this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("idle");
         this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
         this.panelMC.panelMC.getSsMc.gotoAndStop("idle");
         this.panelMC.panelMC.txtTitle.text = Character.character_senjutsu.charAt(0).toUpperCase() + Character.character_senjutsu.substring(1) + " Sage";
         this.panelMC.panelMC.txtSs.text = String(Character.character_ss);
         this.main.initButton(this.panelMC.panelMC.btnConvert,this.buySageScroll,"Boost SS");
         this.main.initButton(this.panelMC.panelMC.btnTraining,this.openMissionRoom,"SS Training");
         this.main.initButton(this.panelMC.panelMC.btnReset,this.openResetSenjutsu,"Reset");
         this.eventHandler.addListener(this.panelMC.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         if(Character.character_senjutsu == "toad")
         {
            this.panelMC.panelMC.txtTreeName.text = "Toad Sage Mode";
            this.panelMC.panelMC.txtTreeDesc.text = "The sage mode come from the Toad Hill, learn it from the Old Huge Toad. Toad Senjutsu can make our body become stronger and damage become more higher.";
         }
         else if(Character.character_senjutsu == "snake")
         {
            this.panelMC.panelMC.txtTreeName.text = "Snake Sage Mode";
            this.panelMC.panelMC.txtTreeDesc.text = "The sage mode come from the Snake Cave, learn it from the Snake God. Snake Senjutsu can make help for your skill usage.";
         }
         else if(Character.character_senjutsu == "slug")
         {
            this.panelMC.panelMC.txtTreeName.text = "Slug Sage Mode";
            this.panelMC.panelMC.txtTreeDesc.text = "The sage mode come from the Slug Hill, learn it from the Slug God. Slug Senjutsu can make help for your battle support.";
         }
         this.loadSkillTree();
      }
      
      private function loadSkillTree() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = "senjutsu_" + this.selectedCategoryType + "_skill_" + int(_loc1_ + 1);
            _loc3_ = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_loc2_);
            GF.removeAllChild(this.panelMC.panelMC["skill_" + _loc1_].skill.holder);
            this.panelMC.panelMC["skill_" + _loc1_].skill.gotoAndStop("enable");
            this.panelMC.panelMC["skill_" + _loc1_].McSenjutsu_lv.txtSkillLevel.text = "--/--";
            this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.visible = false;
            if(_loc4_ = this.getCurrentSkillInfo(_loc3_.id,Character.character_senjutsu))
            {
               this.panelMC.panelMC["skill_" + _loc1_].McSenjutsu_lv.txtSkillLevel.text = "Lv. " + _loc4_.level + "/10";
               if(_loc4_.level < 10)
               {
                  if(this.canLvlUP(_loc3_,Character.character_senjutsu))
                  {
                     this.panelMC.panelMC["skill_" + _loc1_].skill.gotoAndStop("enable");
                     NinjaSage.loadIconSWF("skills",_loc3_.id,this.panelMC.panelMC["skill_" + _loc1_].skill.holder,"with_holder");
                     this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.visible = true;
                     this.main.initButton(this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade,this.showNewLevelInfo,"");
                     this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.id = _loc3_.id;
                     this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.level = _loc4_.level;
                     this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.skill_target = _loc2_;
                  }
                  else
                  {
                     this.panelMC.panelMC["skill_" + _loc1_].skill.gotoAndStop("question_mark");
                  }
               }
               else
               {
                  NinjaSage.loadIconSWF("skills",_loc3_.id,this.panelMC.panelMC["skill_" + _loc1_].skill.holder,"with_holder");
                  this.eventHandler.addListener(this.panelMC.panelMC["skill_" + _loc1_],MouseEvent.CLICK,this.showFullLevelInfo);
                  this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.visible = false;
                  this.panelMC.panelMC["skill_" + _loc1_].id = _loc3_.id;
                  this.panelMC.panelMC["skill_" + _loc1_].skill_target = _loc2_;
               }
               _loc5_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(_loc4_.id,_loc4_.level);
               this.toolTipInfoHolder.push([_loc5_.name,_loc4_.level,_loc5_.damage,_loc5_.sp_cost,_loc5_.cooldown,_loc5_.description]);
               this.eventHandler.addListener(this.panelMC.panelMC["skill_" + _loc1_].skill,MouseEvent.ROLL_OVER,this.toolTiponOverUpgrade);
               this.eventHandler.addListener(this.panelMC.panelMC["skill_" + _loc1_].skill,MouseEvent.ROLL_OUT,this.toolTiponOut);
            }
            else
            {
               this.panelMC.panelMC["skill_" + _loc1_].McSenjutsu_lv.txtSkillLevel.text = "Lv. 0/10";
               if(this.canLvlUP(_loc3_,Character.character_senjutsu))
               {
                  this.panelMC.panelMC["skill_" + _loc1_].skill.gotoAndStop("enable");
                  NinjaSage.loadIconSWF("skills",_loc3_.id,this.panelMC.panelMC["skill_" + _loc1_].skill.holder,"with_holder");
                  this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.visible = true;
                  this.main.initButton(this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade,this.showNewLevelInfo,"");
                  this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.id = _loc3_.id;
                  this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.level = 0;
                  this.panelMC.panelMC["skill_" + _loc1_].btnUpgrade.skill_target = _loc2_;
               }
               else
               {
                  this.panelMC.panelMC["skill_" + _loc1_].skill.gotoAndStop("question_mark");
               }
               _loc5_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(_loc3_.id,_loc3_.level);
               this.toolTipInfoHolder.push([_loc3_.name,_loc3_.description]);
               this.eventHandler.addListener(this.panelMC.panelMC["skill_" + _loc1_].skill,MouseEvent.ROLL_OVER,this.toolTiponOverNotLearned);
               this.eventHandler.addListener(this.panelMC.panelMC["skill_" + _loc1_].skill,MouseEvent.ROLL_OUT,this.toolTiponOut);
            }
            _loc1_++;
         }
      }
      
      private function showNewLevelInfo(param1:MouseEvent) : *
      {
         this.upgradeBtnData = param1.currentTarget;
         this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("upgrade");
         var _loc2_:MovieClip = this.panelMC.panelMC.upgradeSenjutsuMc.panelMC;
         this.main.initButton(_loc2_.btnUpgrade,this.upgradeConfirmation,"Upgrade");
         this.main.initButton(_loc2_.btnTrainMax,this.setMaxTrue,"Upgrade Max");
         this.eventHandler.addListener(_loc2_.btnClose,MouseEvent.CLICK,this.closeUpgradePanel);
         this.setUpgradeInfo();
      }
      
      private function setUpgradeInfo() : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc1_:* = this.panelMC.panelMC.upgradeSenjutsuMc.panelMC;
         _loc1_.skill_icon.gotoAndStop("enable");
         GF.removeAllChild(_loc1_.skill_icon.holder);
         NinjaSage.loadIconSWF("skills",this.upgradeBtnData.id,_loc1_.skill_icon.holder,"with_holder");
         this.upgradeSkillLevel = this.upgradeBtnData.level == 0 ? 1 : int(int(this.upgradeBtnData.level));
         var _loc2_:* = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.upgradeBtnData.id,this.upgradeSkillLevel);
         var _loc3_:* = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(this.upgradeBtnData.skill_target);
         var _loc4_:* = SenjutsuLevelLearnRequirements.getSkillRequirements(this.upgradeBtnData.level == 0 ? 1 : int(int(this.upgradeSkillLevel + 1)));
         this.upgradePrice = _loc4_.ss;
         this.upgradeSkillId = this.upgradeBtnData.id;
         if(this.upgradeSkillLevel < 10)
         {
            if(this.isMax)
            {
               _loc8_ = 0;
               _loc9_ = int(Character.character_ss);
               _loc10_ = this.upgradeBtnData.level == 0 ? 0 : int(this.upgradeBtnData.level);
               while(_loc10_ < 10)
               {
                  _loc7_ = _loc10_ + 1;
                  _loc11_ = SenjutsuLevelLearnRequirements.getSkillRequirements(_loc7_).ss;
                  if(_loc8_ + _loc11_ > _loc9_)
                  {
                     _loc7_ = _loc10_;
                     break;
                  }
                  _loc8_ += _loc11_;
                  _loc10_++;
               }
               this.upgradeSkillLevel = _loc7_;
               this.upgradePrice = _loc8_;
            }
            _loc6_ = (_loc5_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.upgradeBtnData.id,!!this.isMax ? this.upgradeSkillLevel : int(this.upgradeSkillLevel + 1))).cooldown == 0 ? "(Passive Skill)" : "(Active Skill)";
            _loc1_.txtSubName.text = _loc6_;
            _loc1_.currDamageTxt.text = _loc2_.damage;
            _loc1_.currSPTxt.text = _loc2_.sp_cost;
            _loc1_.currCooldownTxt.text = _loc2_.cooldown;
            _loc1_.currskillTxt.text = _loc2_.description;
            _loc1_.nextDamageTxt.text = _loc5_.damage;
            _loc1_.nextSPTxt.text = _loc5_.sp_cost;
            _loc1_.nextCooldownTxt.text = _loc5_.cooldown;
            _loc1_.nextskillTxt.text = _loc5_.description;
         }
         else
         {
            _loc5_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.upgradeBtnData.id,this.upgradeSkillLevel);
            _loc1_.currDamageTxt.text = "0";
            _loc1_.currSPTxt.text = "0";
            _loc1_.currCooldownTxt.text = "0";
            _loc1_.currskillTxt.text = "";
            _loc1_.nextDamageTxt.text = _loc5_.damage;
            _loc1_.nextSPTxt.text = _loc5_.sp_cost;
            _loc1_.nextCooldownTxt.text = _loc5_.cooldown;
            _loc1_.nextskillTxt.text = _loc5_.description;
         }
         _loc1_.txtSenjutsuName.text = _loc5_.name;
         _loc1_.txtSenjutsuDesc.text = _loc3_.description;
         _loc1_.lbl_char_ss.text = "You have ";
         _loc1_.ssTxt.text = String(Character.character_ss);
         _loc1_.txtCurrLv.text = "Level " + String(this.upgradeBtnData.level);
         _loc1_.nextSkillLv.text = "Level " + String(!!this.isMax ? this.upgradeSkillLevel : int(this.upgradeBtnData.level + 1));
         _loc1_.txtCurrDamage.text = "Damage";
         _loc1_.txtCurrSP.text = "SP Cost";
         _loc1_.txtCurrCooldown.text = "Cooldown";
         _loc1_.lbl_nextDamage.text = "Damage";
         _loc1_.lbl_nextSP.text = "SP Cost";
         _loc1_.lbl_nextCooldown.text = "Cooldown";
         _loc1_.lbl_ss_cost.text = "Upgrade Cost: ";
         _loc1_.bpPrice.text = this.upgradePrice + " SS";
      }
      
      public function setMaxTrue(param1:MouseEvent) : void
      {
         this.isMax = !this.isMax;
         var _loc2_:String = !!this.isMax ? "Normal" : "Upgrade Max";
         var _loc3_:MovieClip = this.panelMC.panelMC.upgradeSenjutsuMc.panelMC;
         this.main.initButton(_loc3_.btnTrainMax,this.setMaxTrue,_loc2_);
         this.setUpgradeInfo();
      }
      
      private function showFullLevelInfo(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget;
         this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("maximumLevel");
         var _loc3_:* = this.panelMC.panelMC.upgradeSenjutsuMc.panelMC;
         _loc3_.skill_icon.gotoAndStop("enable");
         GF.removeAllChild(_loc3_.skill_icon.holder);
         NinjaSage.loadIconSWF("skills",_loc2_.id,_loc3_.skill_icon.holder,"with_holder");
         var _loc4_:* = SenjutsuSkillLevel.getSenjutsuSkillLevels(_loc2_.id,"10");
         var _loc5_:* = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_loc2_.skill_target);
         var _loc6_:* = _loc4_.cooldown == 0 ? "(Passive Skill)" : "(Active Skill)";
         _loc3_.txtSenjutsuName.text = _loc4_.name;
         _loc3_.txtSubName.text = _loc6_;
         _loc3_.txtSenjutsuDesc.text = _loc5_.description;
         _loc3_.txtCurrLv.text = "Level 10";
         _loc3_.txtCurrDamage.text = "Damage";
         _loc3_.txtCurrSP.text = "SP Cost";
         _loc3_.txtCurrCooldown.text = "Cooldown";
         _loc3_.currDamageTxt.text = _loc4_.damage;
         _loc3_.currSPTxt.text = _loc4_.sp_cost;
         _loc3_.currCooldownTxt.text = _loc4_.cooldown;
         _loc3_.currskillTxt.text = _loc4_.description;
         this.eventHandler.addListener(_loc3_.btnClose,MouseEvent.CLICK,this.closeUpgradePanel);
      }
      
      private function upgradeConfirmation(param1:MouseEvent) : *
      {
         var _loc2_:* = this.panelMC.panelMC.confirmBox;
         _loc2_.gotoAndStop("show");
         _loc2_.okBtn.visible = false;
         _loc2_.displayTxt.text = "Are you sure want to use " + this.upgradePrice + " SS to Upgrade " + this.panelMC.panelMC.upgradeSenjutsuMc.panelMC.txtSenjutsuName.text + " to level " + this.upgradeSkillLevel;
         this.eventHandler.addListener(_loc2_.yesBtn,MouseEvent.CLICK,this.upgradeAMF);
         this.eventHandler.addListener(_loc2_.noBtn,MouseEvent.CLICK,this.closeConfirmationBox);
      }
      
      private function upgradeAMF(param1:MouseEvent) : *
      {
         this.main.amf_manager.service("fBANtsWU39EIjrT8.570HnGg2su11",[Character.char_id,Character.sessionkey,this.upgradeSkillId,!!this.isMax ? 1 : 0],this.onUpgradedSenjutsu);
      }
      
      private function onUpgradedSenjutsu(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.character_ss = param1.current_ss;
            this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
            this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("idle");
            this.isMax = false;
            this.getSenjutsuFromAmf();
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
      
      private function closeUpgradePanel(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.panelMC.panelMC.upgradeSenjutsuMc.panelMC.skill_icon.holder);
         this.isMax = false;
         this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("idle");
      }
      
      private function closeConfirmationBox(param1:MouseEvent) : *
      {
         this.panelMC.panelMC.confirmBox.displayTxt.text = "";
         this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
      }
      
      public function getCurrentSkillInfo(param1:String, param2:String) : *
      {
         var _loc3_:* = 0;
         while(_loc3_ < this.senjutsuSkills.length)
         {
            if(this.senjutsuSkills[_loc3_].id == param1 && this.senjutsuSkills[_loc3_].type == param2)
            {
               return this.senjutsuSkills[_loc3_];
            }
            _loc3_++;
         }
         return false;
      }
      
      public function canLvlUP(param1:*, param2:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = true;
         if("link1" in param1)
         {
            if((_loc3_ = this.getCurrentSkillInfo(param1.link1,param2)) && _loc3_.level >= 5)
            {
               _loc5_ = true;
            }
            else
            {
               _loc5_ = false;
            }
         }
         if("link2" in param1 && _loc5_)
         {
            if((_loc4_ = this.getCurrentSkillInfo(param1.link2,param2)) && _loc4_.level >= 5)
            {
               _loc5_ = true;
            }
            else
            {
               _loc5_ = false;
            }
         }
         return _loc5_;
      }
      
      private function initEquipUI() : *
      {
         if(Character.character_equipped_senjutsu_skills == null || Character.character_equipped_senjutsu_skills == "")
         {
            this.senjutsuEquippedSkills = [];
         }
         else
         {
            this.senjutsuEquippedSkills = Character.character_equipped_senjutsu_skills.split(",");
         }
         this.panelMC.txtTitle.text = Character.character_senjutsu != null ? Character.character_senjutsu.charAt(0).toUpperCase() + Character.character_senjutsu.substring(1) + " Sage" : "Sage";
         this.panelMC.txtSkillName.text = "";
         this.panelMC.txtSkillDesc.text = "";
         this.panelMC.pageTxt.text = "1/1";
         this.panelMC.tagOther.gotoAndStop("unselect");
         this.totalPage = Math.max(Math.ceil(this.selectedCategorySkill.length / 8),1);
         this.checkEquipableSlot();
         if(Character.character_senjutsu == null)
         {
            this.panelMC.tagBackgroundMc.gotoAndStop("other");
            this.selectedCategorySkill = this.senjutsuOther;
            this.selectedCategoryType = "other";
         }
         this.loadSenjutsuSkill();
         this.loadEquippedSkills();
      }
      
      private function checkEquipableSlot() : *
      {
         if(int(Character.character_lvl) >= 80)
         {
            this.maxEquipableSlot = int((int(Character.character_lvl) - 60) / 10) + 4;
         }
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            this.panelMC["skill_" + _loc1_].gotoAndStop("enable");
            _loc1_++;
         }
         _loc1_ = int((int(Character.character_lvl) - 60) / 10) + 4;
         while(_loc1_ < 8)
         {
            this.panelMC["skill_" + _loc1_].gotoAndStop("disable");
            _loc1_++;
         }
      }
      
      private function loadSenjutsuSkill() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this.toolTipInfoHolder = [];
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 8);
            if(this.selectedCategorySkill.length > _loc2_)
            {
               this.panelMC["learnedSenjutsu_" + _loc1_].visible = true;
               _loc3_ = this.getSenjutsuSkillOrder(this.selectedCategorySkill[_loc2_].id,this.selectedCategorySkill[_loc2_].type);
               _loc4_ = "senjutsu_" + this.selectedCategoryType + "_skill_" + _loc3_;
               _loc5_ = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_loc4_);
               _loc6_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.selectedCategorySkill[_loc2_].id,this.selectedCategorySkill[_loc2_].level);
               this.panelMC["learnedSenjutsu_" + _loc1_].Senjutsu.gotoAndStop("enable");
               this.panelMC["learnedSenjutsu_" + _loc1_].txtSkillName.text = _loc5_.name;
               this.panelMC["learnedSenjutsu_" + _loc1_].lvMc.txtLevel.text = this.selectedCategorySkill[_loc2_].level;
               if(!this.removingSkill)
               {
                  GF.removeAllChild(this.panelMC["learnedSenjutsu_" + _loc1_].Senjutsu.holder);
                  NinjaSage.loadIconSWF("skills",this.selectedCategorySkill[_loc2_].id,this.panelMC["learnedSenjutsu_" + _loc1_].Senjutsu.holder,"with_holder");
               }
               this.toolTipInfoHolder.push([_loc6_.name,this.selectedCategorySkill[_loc2_].level,_loc6_.damage,_loc6_.sp_cost,_loc6_.cooldown,_loc6_.description]);
               if(this.checkEquipped(this.selectedCategorySkill[_loc2_].id))
               {
                  this.panelMC["learnedSenjutsu_" + _loc1_].btnEquip.visible = false;
                  this.panelMC["learnedSenjutsu_" + _loc1_].txtSkillEquipped.visible = true;
                  this.panelMC["learnedSenjutsu_" + _loc1_].txtSkillEquipped.text = "Equipped";
               }
               else
               {
                  this.panelMC["learnedSenjutsu_" + _loc1_].btnEquip.visible = true;
                  this.panelMC["learnedSenjutsu_" + _loc1_].txtSkillEquipped.visible = false;
                  this.main.initButton(this.panelMC["learnedSenjutsu_" + _loc1_].btnEquip,this.equipSkill,"Equip");
               }
               if(_loc6_.cooldown == 0)
               {
                  this.panelMC["learnedSenjutsu_" + _loc1_].btnEquip.visible = false;
                  this.panelMC["learnedSenjutsu_" + _loc1_].txtSkillEquipped.visible = true;
                  this.panelMC["learnedSenjutsu_" + _loc1_].txtSkillEquipped.text = "Passive";
               }
               this.eventHandler.addListener(this.panelMC["learnedSenjutsu_" + _loc1_],MouseEvent.CLICK,this.showRightInfo);
               this.eventHandler.addListener(this.panelMC["learnedSenjutsu_" + _loc1_].Senjutsu,MouseEvent.ROLL_OVER,this.toolTiponOver);
               this.eventHandler.addListener(this.panelMC["learnedSenjutsu_" + _loc1_].Senjutsu,MouseEvent.ROLL_OUT,this.toolTiponOut);
            }
            else
            {
               this.panelMC["learnedSenjutsu_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.removingSkill = false;
         this.updatePageNumber();
         this.totalPage = Math.max(Math.ceil(this.selectedCategorySkill.length / 8),1);
      }
      
      private function getSenjutsuSkillOrder(param1:String, param2:String) : int
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc3_:* = param2 == "other" ? 3 : 11;
         var _loc4_:* = 1;
         while(_loc4_ < 11)
         {
            _loc5_ = "senjutsu_" + param2 + "_skill_" + _loc4_;
            if((_loc6_ = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_loc5_)).id == param1)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return 1;
      }
      
      private function showRightInfo(param1:MouseEvent) : *
      {
         var _loc2_:int = param1.currentTarget.name.replace("learnedSenjutsu_","");
         var _loc3_:int = _loc2_ + int(int(this.currentPage - 1) * 8);
         var _loc4_:* = this.getSenjutsuSkillOrder(this.selectedCategorySkill[_loc3_].id,this.selectedCategorySkill[_loc3_].type);
         var _loc5_:* = "senjutsu_" + this.selectedCategoryType + "_skill_" + _loc4_;
         var _loc6_:* = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_loc5_);
         this.panelMC.txtSkillName.text = _loc6_.name;
         this.panelMC.txtSkillDesc.text = _loc6_.description;
      }
      
      private function checkEquipped(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(param1 != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.senjutsuEquippedSkills.length)
            {
               if(this.senjutsuEquippedSkills[_loc2_] == param1)
               {
                  return true;
               }
               _loc2_++;
            }
            return false;
         }
         return false;
      }
      
      private function equipSkill(param1:MouseEvent) : *
      {
         if(this.senjutsuEquippedSkills.length >= this.maxEquipableSlot || this.senjutsuEquippedSkills.length >= 8)
         {
            return;
         }
         var _loc2_:int = param1.currentTarget.parent.name.replace("learnedSenjutsu_","");
         var _loc3_:int = _loc2_ + int(int(this.currentPage - 1) * 8);
         this.panelMC["learnedSenjutsu_" + _loc2_].btnEquip.visible = false;
         this.panelMC["learnedSenjutsu_" + _loc2_].txtSkillEquipped.visible = true;
         this.panelMC["learnedSenjutsu_" + _loc2_].txtSkillEquipped.text = "Equipped";
         this.senjutsuEquippedSkills.push(this.selectedCategorySkill[_loc3_].id);
         this.loadEquippedSkills();
      }
      
      private function loadEquippedSkills() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.senjutsuEquippedSkills.length)
         {
            this.panelMC["skill_" + _loc1_].gotoAndStop("enable");
            GF.removeAllChild(this.panelMC["skill_" + _loc1_].holder);
            NinjaSage.loadIconSWF("skills",this.senjutsuEquippedSkills[_loc1_],this.panelMC["skill_" + _loc1_].holder,"with_holder");
            _loc1_++;
         }
      }
      
      private function removeEquippedSkill(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btnClearSkill_","");
         if(_loc2_ >= this.senjutsuEquippedSkills.length)
         {
            return;
         }
         var _loc3_:* = 0;
         while(_loc3_ < 8)
         {
            GF.removeAllChild(this.panelMC["skill_" + _loc3_].holder);
            _loc3_++;
         }
         this.senjutsuEquippedSkills.splice(_loc2_,1);
         this.removingSkill = true;
         this.loadSenjutsuSkill();
         this.loadEquippedSkills();
      }
      
      private function updatePageNumber() : *
      {
         this.panelMC.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function setEquipModeButton() : *
      {
         this.panelMC.confirmBox.gotoAndStop(1);
         this.main.initButton(this.panelMC.btnReset,this.openResetSenjutsu,"Reset");
         this.eventHandler.addListener(this.panelMC.tagToad,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.panelMC.tagSnake,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.panelMC.tagSlug,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.panelMC.tagOther,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btnNextPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btnPrevPage,MouseEvent.CLICK,this.changePage);
         if(Character.character_senjutsu == "toad")
         {
            this.panelMC.tagSnake.visible = false;
            this.panelMC.tagSlug.visible = false;
            this.panelMC.tagToad.buttonMode = true;
            this.panelMC.tagToad.gotoAndStop("select");
            this.panelMC.tagBackgroundMc.gotoAndStop("toad");
         }
         else if(Character.character_senjutsu == "snake")
         {
            this.panelMC.tagToad.visible = false;
            this.panelMC.tagSlug.visible = false;
            this.panelMC.tagSnake.buttonMode = true;
            this.panelMC.tagSnake.gotoAndStop("select");
            this.panelMC.tagBackgroundMc.gotoAndStop("snake");
         }
         else if(Character.character_senjutsu == "slug")
         {
            this.panelMC.tagToad.visible = false;
            this.panelMC.tagSnake.visible = false;
            this.panelMC.tagSlug.buttonMode = true;
            this.panelMC.tagSlug.gotoAndStop("select");
            this.panelMC.tagBackgroundMc.gotoAndStop("slug");
         }
         else
         {
            this.panelMC.tagToad.visible = false;
            this.panelMC.tagSnake.visible = false;
            this.panelMC.tagSlug.visible = false;
            this.panelMC.tagBackgroundMc.gotoAndStop("other");
         }
         this.panelMC.tagOther.buttonMode = true;
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            this.eventHandler.addListener(this.panelMC["btnClearSkill_" + _loc1_],MouseEvent.CLICK,this.removeEquippedSkill);
            _loc1_++;
         }
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNextPage":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.loadSenjutsuSkill();
               }
               break;
            case "btnPrevPage":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.loadSenjutsuSkill();
               }
         }
         this.updatePageNumber();
      }
      
      private function changeCategory(param1:MouseEvent) : *
      {
         this.panelMC.tagToad.gotoAndStop("unselect");
         this.panelMC.tagSnake.gotoAndStop("unselect");
         this.panelMC.tagSlug.gotoAndStop("unselect");
         this.panelMC.tagOther.gotoAndStop("unselect");
         param1.currentTarget.gotoAndStop("select");
         var _loc2_:* = param1.currentTarget.name.replace("tag","");
         if(_loc2_ == "Toad")
         {
            this.panelMC.tagBackgroundMc.gotoAndStop("toad");
            this.selectedCategorySkill = this.senjutsuSkills;
            this.selectedCategoryType = Character.character_senjutsu;
         }
         else if(_loc2_ == "Snake")
         {
            this.panelMC.tagBackgroundMc.gotoAndStop("snake");
            this.selectedCategorySkill = this.senjutsuSkills;
            this.selectedCategoryType = Character.character_senjutsu;
         }
         else if(_loc2_ == "Slug")
         {
            this.panelMC.tagBackgroundMc.gotoAndStop("slug");
            this.selectedCategorySkill = this.senjutsuSkills;
            this.selectedCategoryType = Character.character_senjutsu;
         }
         else
         {
            this.panelMC.tagBackgroundMc.gotoAndStop("other");
            this.selectedCategorySkill = this.senjutsuOther;
            this.selectedCategoryType = "other";
         }
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategorySkill.length / 8),1);
         this.updatePageNumber();
         this.loadSenjutsuSkill();
      }
      
      private function toolTiponOver(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.parent.name;
         _loc2_ = _loc2_.replace("learnedSenjutsu_","");
         var _loc3_:* = "" + "<b>" + this.toolTipInfoHolder[_loc2_][0] + "</b>" + "\n(Senjutsu Skill)\n\nLevel: " + this.toolTipInfoHolder[_loc2_][1] + "\n" + "<font color=\"#ff0000\">" + "Damage: " + this.toolTipInfoHolder[_loc2_][2] + "</font>" + "\n" + "<font color=\"#ff5300\">" + "SP Cost: " + this.toolTipInfoHolder[_loc2_][3] + "</font>" + "\n" + "<font color=\"#666666\">" + "Cooldown: " + this.toolTipInfoHolder[_loc2_][4] + "</font>" + "\n\n" + this.toolTipInfoHolder[_loc2_][5];
         this.main.stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc3_);
      }
      
      private function toolTiponOverUpgrade(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.parent.name;
         _loc2_ = _loc2_.replace("skill_","");
         var _loc3_:* = "" + "<b>" + this.toolTipInfoHolder[_loc2_][0] + "</b>" + "\n(Senjutsu Skill)\n\nLevel: " + this.toolTipInfoHolder[_loc2_][1] + "\n" + "<font color=\"#ff0000\">" + "Damage: " + this.toolTipInfoHolder[_loc2_][2] + "</font>" + "\n" + "<font color=\"#ff5300\">" + "SP Cost: " + this.toolTipInfoHolder[_loc2_][3] + "</font>" + "\n" + "<font color=\"#666666\">" + "Cooldown: " + this.toolTipInfoHolder[_loc2_][4] + "</font>" + "\n\n" + this.toolTipInfoHolder[_loc2_][5];
         this.main.stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc3_);
      }
      
      private function toolTiponOverNotLearned(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.parent.name;
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
      
      private function buySageScroll(param1:MouseEvent) : *
      {
         this.panelMC.panelMC.getSsMc.gotoAndStop("show");
         this.panelMC.panelMC.getSsMc.confirmBox.gotoAndStop(1);
         var _loc2_:* = this.panelMC.panelMC.getSsMc.panelMC;
         _loc2_.txtTitle.text = "Buy Sage Scroll";
         _loc2_.yourTokenTxt.text = String(Character.account_tokens);
         _loc2_.yourSSTxt.text = String(Character.character_ss);
         _loc2_.lbl_question.text = "What is Sage Scroll?";
         _loc2_.lbl_answer.text = "Sage Scroll (SS) is used to level up a senjutsu skill";
         var _loc3_:* = 0;
         while(_loc3_ < 4)
         {
            _loc2_["p" + _loc3_].gotoAndStop(_loc3_ + _loc3_);
            _loc2_["p" + _loc3_].highlight.gotoAndStop("idle");
            _loc2_["p" + _loc3_].ssTxt.text = this.sageScrollShop[_loc3_].amount;
            _loc2_["p" + _loc3_].tokenTxt.text = this.sageScrollShop[_loc3_].price;
            this.eventHandler.addListener(_loc2_["p" + _loc3_],MouseEvent.CLICK,this.setSelectedBuySS);
            _loc3_++;
         }
         this.main.initButton(_loc2_.convertBtn,this.openConfirmationBuySS,"Convert");
         this.eventHandler.addListener(_loc2_.btnClose,MouseEvent.CLICK,this.closeBuySageScroll);
      }
      
      private function closeBuySageScroll(param1:MouseEvent) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 4)
         {
            this.panelMC.panelMC.getSsMc.panelMC["p" + _loc2_].highlight.gotoAndStop("idle");
            _loc2_++;
         }
         this.panelMC.panelMC.getSsMc.gotoAndStop("idle");
      }
      
      private function setSelectedBuySS(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("p","");
         var _loc3_:* = 0;
         while(_loc3_ < 4)
         {
            this.panelMC.panelMC.getSsMc.panelMC["p" + _loc3_].highlight.gotoAndStop("idle");
            _loc3_++;
         }
         param1.currentTarget.highlight.gotoAndStop("show");
         this.selectedBuySS = _loc2_;
      }
      
      private function openConfirmationBuySS(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         if(this.selectedBuySS >= 0)
         {
            _loc2_ = this.panelMC.panelMC.getSsMc.confirmBox;
            _loc2_.gotoAndStop("show");
            _loc2_.okBtn.visible = false;
            _loc2_.displayTxt.text = "Are you sure want to buy " + this.sageScrollShop[this.selectedBuySS].amount + " SS for " + this.sageScrollShop[this.selectedBuySS].price + " tokens";
            this.eventHandler.addListener(_loc2_.yesBtn,MouseEvent.CLICK,this.buySageScrollAMF);
            this.eventHandler.addListener(_loc2_.noBtn,MouseEvent.CLICK,this.closeConfirmationBoxSS);
         }
         else
         {
            this.main.showMessage("Select a package before convert");
         }
      }
      
      private function closeConfirmationBoxSS(param1:MouseEvent) : *
      {
         this.panelMC.panelMC.getSsMc.confirmBox.displayTxt.text = "";
         this.panelMC.panelMC.getSsMc.confirmBox.gotoAndStop("idle");
      }
      
      private function buySageScrollAMF(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("fBANtsWU39EIjrT8.BEIRAVo13Zmf",[Character.char_id,Character.sessionkey,this.selectedBuySS],this.onSageScrollBought);
      }
      
      private function onSageScrollBought(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.panelMC.getSsMc.confirmBox.gotoAndStop("idle");
            Character.account_tokens = int(Character.account_tokens) - int(this.sageScrollShop[this.selectedBuySS].price);
            Character.character_ss = int(param1.ss);
            this.panelMC.panelMC.getSsMc.panelMC.yourTokenTxt.text = String(Character.account_tokens);
            this.panelMC.panelMC.getSsMc.panelMC.yourSSTxt.text = String(Character.character_ss);
            this.panelMC.panelMC.txtSs.text = String(Character.character_ss);
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
      
      private function openMissionRoom(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("MissionRoom","MissionRoom");
      }
      
      private function openResetSenjutsu(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("ResetSenjutsu","ResetSenjutsu");
         this.destroy();
      }
      
      private function openHelp(param1:MouseEvent) : *
      {
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         if(this.openType == "equip")
         {
            this.main.loading(true);
            this.main.amf_manager.service("fBANtsWU39EIjrT8.VRqGDbiowF6q",[Character.char_id,Character.sessionkey,this.senjutsuEquippedSkills],this.onSenjutsuSkillEquipped);
         }
         else
         {
            this.destroy();
         }
      }
      
      private function onSenjutsuSkillEquipped(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.character_equipped_senjutsu_skills = param1.skills;
            this.destroy();
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
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this.tooltip)
         {
            this.tooltip.destroy();
         }
         this.main.handleVillageHUDVisibility(true);
         this.main.removeExternalSwfPanel();
         this.currentPage = 1;
         this.totalPage = 1;
         this.selectedCategorySkill = null;
         this.selectedCategoryType = null;
         this.tooltip = null;
         this.selectedBuySS = 0;
         this.upgradeSkillId = null;
         this.upgradePrice = 0;
         this.upgradeSkillLevel = 0;
         this.removingSkill = false;
         this.openType = null;
         this.sageScrollShop = null;
         this.senjutsuSkills = null;
         this.senjutsuOther = null;
         this.iconCollection = null;
         this.toolTipInfoHolder = null;
         this.senjutsuEquippedSkills = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
