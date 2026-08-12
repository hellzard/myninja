package Panels
{
   import Managers.NinjaSage;
   import Popups.TalentBoost;
   import Popups.TalentLvlUP;
   import Popups.TalentSkillInfo;
   import Storage.Character;
   import Storage.TalentInfo;
   import Storage.TalentSkillDescriptions;
   import Storage.TalentSkillLevel;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class TalentPanel extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var BloodlineMC:MovieClip;
      
      public var SecretMC_1:MovieClip;
      
      public var SecretMC_2:MovieClip;
      
      public var boost_mc:TalentBoost;
      
      public var btnBPMission:MovieClip;
      
      public var btnConvertBP:MovieClip;
      
      public var btnExit:MovieClip;
      
      public var btnReset:MovieClip;
      
      public var confirmBox:MovieClip;
      
      public var lbl_bloodline:TextField;
      
      public var lvl_up_mc:TalentLvlUP;
      
      public var skill_info_mc:TalentSkillInfo;
      
      public var yourBPTxt:TextField;
      
      public var main;
      
      public var tooltip:ToolTip;
      
      public var talent_skill:Array;
      
      public var tooltipExtreme:Object;
      
      public var tooltipSecret1:Object;
      
      public var tooltipSecret2:Object;
      
      public var eventHandler:EventHandler;
      
      private var ref:String;
      
      public function TalentPanel(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closeThis);
         this.escapeKey.addListener(this.boost_mc,this.boost_mc.closeThis);
         this.tooltipExtreme = {};
         this.tooltipSecret1 = {};
         this.tooltipSecret2 = {};
         this.main = param1;
         this.tooltip = ToolTip.getInstance();
         this.eventHandler = new EventHandler();
         this.addChild(this.tooltip);
         this.loadEverything();
      }
      
      public function fetchTalents(param1:*) : *
      {
         this.main.amf_manager.service("RzFUf16G1EIy2bfB.u08n6h73qXKo",[Character.char_id,Character.sessionkey],param1);
      }
      
      public function setTalentSkills(param1:*) : *
      {
         this.talent_skill = param1;
      }
      
      public function loadEverything() : *
      {
         this.main.loading(true);
         this.fetchTalents(this.onGotInfo);
      }
      
      public function onGotInfo(param1:Object) : *
      {
         this.main.loading(false);
         if(!param1.hasOwnProperty("data"))
         {
            this.main.getNotice("Unable to get talent data");
            this.destroy();
            return;
         }
         this.setTalentSkills(param1.data);
         this.addButtonListeners();
         this.setTexts();
         this.initMovieClips();
      }
      
      public function setTexts() : *
      {
         this.yourBPTxt.text = String(Character.character_tp);
      }
      
      public function showConfirmationBox(param1:*, param2:*) : *
      {
         this.confirmBox.visible = true;
         this.confirmBox.gotoAndStop("show");
         this.confirmBox.displayTxt.text = param1;
         this.confirmBox.yesBtn.addEventListener(MouseEvent.CLICK,param2);
         this.eventHandler.addListener(this.confirmBox.noBtn,MouseEvent.CLICK,this.closeConfirmBox);
      }
      
      public function closeConfirmBox(param1:MouseEvent) : *
      {
         this.confirmBox.visible = false;
      }
      
      public function initMovieClips() : *
      {
         this.main.handleVillageHUDVisibility(false);
         this.lvl_up_mc.visible = false;
         this.boost_mc.visible = false;
         this.skill_info_mc.visible = false;
         if(Character.character_talent_1 != null)
         {
            this.BloodlineMC.gotoAndStop(Character.character_talent_1);
            this.fillUP();
         }
         else
         {
            this.BloodlineMC.gotoAndStop(1);
            this.main.initButton(this.BloodlineMC.btnDiscover,this.openDiscoverTalent,"Discover");
         }
         if(Character.character_talent_2 != null)
         {
            this.SecretMC_1.gotoAndStop("SecSkill_1");
            this.fillUPSecret();
         }
         else
         {
            this.SecretMC_1.gotoAndStop(1);
            this.main.initButton(this.SecretMC_1.btnDiscover,this.openDiscoverTalent,"Discover");
         }
         if(Character.character_talent_3 != null)
         {
            this.SecretMC_2.gotoAndStop("SecSkill_1");
            this.fillUPSecret2();
         }
         else
         {
            this.SecretMC_2.gotoAndStop(1);
            this.main.initButton(this.SecretMC_2.btnDiscover,this.openDiscoverTalent,"Discover");
         }
         this.confirmBox.gotoAndStop(1);
      }
      
      public function getCurrentSkillInfo(param1:String, param2:String) : *
      {
         var _loc3_:* = 0;
         while(_loc3_ < this.talent_skill.length)
         {
            if(this.talent_skill[_loc3_].item_id == param1 && this.talent_skill[_loc3_].talent_type == param2)
            {
               return this.talent_skill[_loc3_];
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
         if("talent_link_skill_id" in param1)
         {
            if((_loc3_ = this.getCurrentSkillInfo(param1.talent_link_skill_id,param2)) && _loc3_.item_level >= 5)
            {
               _loc5_ = true;
            }
            else
            {
               _loc5_ = false;
            }
         }
         if("talent_link_skill_id2" in param1 && _loc5_)
         {
            if((_loc4_ = this.getCurrentSkillInfo(param1.talent_link_skill_id2,param2)) && _loc4_.item_level >= 5)
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
      
      public function fillUP() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.tooltipExtreme = {};
         var _loc5_:* = TalentInfo.getTalentInfos(Character.character_talent_1);
         this.BloodlineMC.lbl_BLSkillName.text = _loc5_.talent_name;
         var _loc6_:* = 1;
         while(_loc6_ < 7)
         {
            this.BloodlineMC["skill_" + _loc6_].gotoAndStop("enable");
            this.BloodlineMC["skill_" + _loc6_].typeIcon.gotoAndStop(1);
            _loc1_ = "talent_" + Character.character_talent_1 + "_skill_" + _loc6_;
            _loc2_ = TalentSkillDescriptions.getTalentSkillDescriptions(_loc1_);
            GF.removeAllChild(this.BloodlineMC["skill_" + _loc6_].holder);
            this.BloodlineMC["btnUpgrade_" + _loc6_].addBtnDim.visible = false;
            this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.visible = false;
            this.BloodlineMC["btnUpgrade_" + _loc6_].detailBtn.visible = false;
            this.BloodlineMC["skillLvTxt_" + _loc6_].text = "Lv: 0/10";
            if("talent_skill_id" in _loc2_)
            {
               _loc3_ = this.getCurrentSkillInfo(_loc2_.talent_skill_id,Character.character_talent_1);
               if(_loc3_)
               {
                  this.BloodlineMC["skillLvTxt_" + _loc6_].text = "Lv. " + _loc3_.item_level + "/10";
                  if(_loc3_.item_level < 10)
                  {
                     if(this.canLvlUP(_loc2_,Character.character_talent_1))
                     {
                        NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.BloodlineMC["skill_" + _loc6_].holder,"with_holder");
                        this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.visible = true;
                        this.main.initButton(this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn,this.showNewLevelInfo);
                        this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.skill_id = _loc2_.talent_skill_id;
                        this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.skill_level = _loc3_.item_level;
                        this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.talent_skill_id = _loc1_;
                     }
                     else
                     {
                        this.BloodlineMC["skill_" + _loc6_].gotoAndStop("queston_mark");
                        this.BloodlineMC["btnUpgrade_" + _loc6_].addBtnDim.visible = true;
                     }
                  }
                  else
                  {
                     NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.BloodlineMC["skill_" + _loc6_].holder,"with_holder");
                     this.BloodlineMC["btnUpgrade_" + _loc6_].detailBtn.visible = true;
                     this.main.initButton(this.BloodlineMC["btnUpgrade_" + _loc6_].detailBtn,this.showFullLevelInfo);
                     this.BloodlineMC["btnUpgrade_" + _loc6_].detailBtn.skill_id = _loc2_.talent_skill_id;
                     this.BloodlineMC["btnUpgrade_" + _loc6_].detailBtn.talent_skill_id = _loc1_;
                  }
                  _loc4_ = TalentSkillLevel.getTalentSkillLevels(_loc2_.talent_skill_id,_loc3_.item_level);
                  this.BloodlineMC["skill_" + String(_loc6_)].metaData = {
                     "name":_loc4_.talent_skill_name,
                     "description":_loc4_.talent_skill_description,
                     "level":_loc3_.item_level
                  };
                  this.eventHandler.addListener(this.BloodlineMC["skill_" + String(_loc6_)],MouseEvent.ROLL_OVER,this.toolTipTalent,false,0,true);
                  this.eventHandler.addListener(this.BloodlineMC["skill_" + String(_loc6_)],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
               }
               else
               {
                  this.BloodlineMC["skillLvTxt_" + _loc6_].text = "Lv: 0/10";
                  if(this.canLvlUP(_loc2_,Character.character_talent_1))
                  {
                     this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.visible = true;
                     this.main.initButton(this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn,this.showNewLevelInfo);
                     this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.skill_id = _loc2_.talent_skill_id;
                     this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.skill_level = 0;
                     this.BloodlineMC["btnUpgrade_" + _loc6_].addBtn.talent_skill_id = _loc1_;
                     NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.BloodlineMC["skill_" + _loc6_].holder,"with_holder");
                  }
                  else
                  {
                     this.BloodlineMC["skill_" + _loc6_].gotoAndStop("queston_mark");
                     this.BloodlineMC["btnUpgrade_" + _loc6_].addBtnDim.visible = true;
                  }
                  this.BloodlineMC["skill_" + String(_loc6_)].metaData = {
                     "name":_loc2_.talent_skill_name,
                     "description":_loc2_.talent_skill_description,
                     "level":0
                  };
                  this.eventHandler.addListener(this.BloodlineMC["skill_" + String(_loc6_)],MouseEvent.ROLL_OVER,this.toolTipTalent,false,0,true);
                  this.eventHandler.addListener(this.BloodlineMC["skill_" + String(_loc6_)],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
               }
            }
            _loc6_++;
         }
      }
      
      public function fillUPSecret() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.tooltipSecret1 = {};
         var _loc5_:* = TalentInfo.getTalentInfos(Character.character_talent_2);
         this.SecretMC_1.SecSkillNameTxt.text = _loc5_.talent_name;
         var _loc6_:* = 1;
         while(_loc6_ < 4)
         {
            this.SecretMC_1["skill_" + _loc6_].gotoAndStop("enable");
            this.SecretMC_1["skill_" + _loc6_].typeIcon.gotoAndStop(1);
            _loc1_ = "talent_" + Character.character_talent_2 + "_skill_" + _loc6_;
            _loc2_ = TalentSkillDescriptions.getTalentSkillDescriptions(_loc1_);
            GF.removeAllChild(this.SecretMC_1["skill_" + _loc6_].holder);
            this.SecretMC_1["btnUpgrade_" + _loc6_].addBtnDim.visible = false;
            this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.visible = false;
            this.SecretMC_1["btnUpgrade_" + _loc6_].detailBtn.visible = false;
            this.SecretMC_1["skillLvTxt_" + _loc6_].text = "Lv: 0/10";
            if("talent_skill_id" in _loc2_)
            {
               _loc3_ = this.getCurrentSkillInfo(_loc2_.talent_skill_id,Character.character_talent_2);
               if(_loc3_)
               {
                  this.SecretMC_1["skillLvTxt_" + _loc6_].text = "Lv. " + _loc3_.item_level + "/10";
                  if(_loc3_.item_level < 10)
                  {
                     if(this.canLvlUP(_loc2_,Character.character_talent_2))
                     {
                        NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.SecretMC_1["skill_" + _loc6_].holder,"with_holder");
                        this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.visible = true;
                        this.main.initButton(this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn,this.showNewLevelInfo);
                        this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.skill_id = _loc2_.talent_skill_id;
                        this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.skill_level = _loc3_.item_level;
                        this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.talent_skill_id = _loc1_;
                     }
                     else
                     {
                        this.SecretMC_1["skill_" + _loc6_].gotoAndStop("queston_mark");
                        this.SecretMC_1["btnUpgrade_" + _loc6_].addBtnDim.visible = true;
                     }
                  }
                  else
                  {
                     NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.SecretMC_1["skill_" + _loc6_].holder,"with_holder");
                     this.SecretMC_1["btnUpgrade_" + _loc6_].detailBtn.visible = true;
                     this.main.initButton(this.SecretMC_1["btnUpgrade_" + _loc6_].detailBtn,this.showFullLevelInfo);
                     this.SecretMC_1["btnUpgrade_" + _loc6_].detailBtn.skill_id = _loc2_.talent_skill_id;
                     this.SecretMC_1["btnUpgrade_" + _loc6_].detailBtn.talent_skill_id = _loc1_;
                  }
                  _loc4_ = TalentSkillLevel.getTalentSkillLevels(_loc2_.talent_skill_id,_loc3_.item_level);
                  this.SecretMC_1["skill_" + String(_loc6_)].metaData = {
                     "name":_loc4_.talent_skill_name,
                     "description":_loc4_.talent_skill_description,
                     "level":_loc3_.item_level
                  };
                  this.eventHandler.addListener(this.SecretMC_1["skill_" + String(_loc6_)],MouseEvent.ROLL_OVER,this.toolTipTalent,false,0,true);
                  this.eventHandler.addListener(this.SecretMC_1["skill_" + String(_loc6_)],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
               }
               else
               {
                  this.SecretMC_1["skillLvTxt_" + _loc6_].text = "Lv: 0/10";
                  if(this.canLvlUP(_loc2_,Character.character_talent_2))
                  {
                     this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.visible = true;
                     this.main.initButton(this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn,this.showNewLevelInfo);
                     this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.skill_id = _loc2_.talent_skill_id;
                     this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.skill_level = 0;
                     this.SecretMC_1["btnUpgrade_" + _loc6_].addBtn.talent_skill_id = _loc1_;
                     NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.SecretMC_1["skill_" + _loc6_].holder,"with_holder");
                  }
                  else
                  {
                     this.SecretMC_1["skill_" + _loc6_].gotoAndStop("queston_mark");
                     this.SecretMC_1["btnUpgrade_" + _loc6_].addBtnDim.visible = true;
                  }
                  this.SecretMC_1["skill_" + String(_loc6_)].metaData = {
                     "name":_loc2_.talent_skill_name,
                     "description":_loc2_.talent_skill_description,
                     "level":0
                  };
                  this.eventHandler.addListener(this.SecretMC_1["skill_" + String(_loc6_)],MouseEvent.ROLL_OVER,this.toolTipTalent,false,0,true);
                  this.eventHandler.addListener(this.SecretMC_1["skill_" + String(_loc6_)],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
               }
            }
            _loc6_++;
         }
      }
      
      public function fillUPSecret2() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.tooltipSecret2 = {};
         var _loc5_:* = TalentInfo.getTalentInfos(Character.character_talent_3);
         this.SecretMC_2.SecSkillNameTxt.text = _loc5_.talent_name;
         var _loc6_:* = 1;
         while(_loc6_ < 4)
         {
            this.SecretMC_2["skill_" + _loc6_].gotoAndStop("enable");
            this.SecretMC_2["skill_" + _loc6_].typeIcon.gotoAndStop(1);
            _loc1_ = "talent_" + Character.character_talent_3 + "_skill_" + _loc6_;
            _loc2_ = TalentSkillDescriptions.getTalentSkillDescriptions(_loc1_);
            GF.removeAllChild(this.SecretMC_2["skill_" + _loc6_].holder);
            this.SecretMC_2["btnUpgrade_" + _loc6_].addBtnDim.visible = false;
            this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.visible = false;
            this.SecretMC_2["btnUpgrade_" + _loc6_].detailBtn.visible = false;
            this.SecretMC_2["skillLvTxt_" + _loc6_].text = "Lv: 0/10";
            if("talent_skill_id" in _loc2_)
            {
               _loc3_ = this.getCurrentSkillInfo(_loc2_.talent_skill_id,Character.character_talent_3);
               if(_loc3_)
               {
                  this.SecretMC_2["skillLvTxt_" + _loc6_].text = "Lv. " + _loc3_.item_level + "/10";
                  if(_loc3_.item_level < 10)
                  {
                     if(this.canLvlUP(_loc2_,Character.character_talent_3))
                     {
                        NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.SecretMC_2["skill_" + _loc6_].holder,"with_holder");
                        this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.visible = true;
                        this.main.initButton(this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn,this.showNewLevelInfo);
                        this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.skill_id = _loc2_.talent_skill_id;
                        this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.skill_level = _loc3_.item_level;
                        this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.talent_skill_id = _loc1_;
                     }
                     else
                     {
                        this.SecretMC_2["skill_" + _loc6_].gotoAndStop("queston_mark");
                        this.SecretMC_2["btnUpgrade_" + _loc6_].addBtnDim.visible = true;
                     }
                  }
                  else
                  {
                     NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.SecretMC_2["skill_" + _loc6_].holder,"with_holder");
                     this.SecretMC_2["btnUpgrade_" + _loc6_].detailBtn.visible = true;
                     this.main.initButton(this.SecretMC_2["btnUpgrade_" + _loc6_].detailBtn,this.showFullLevelInfo);
                     this.SecretMC_2["btnUpgrade_" + _loc6_].detailBtn.skill_id = _loc2_.talent_skill_id;
                     this.SecretMC_2["btnUpgrade_" + _loc6_].detailBtn.talent_skill_id = _loc1_;
                  }
                  _loc4_ = TalentSkillLevel.getTalentSkillLevels(_loc2_.talent_skill_id,_loc3_.item_level);
                  this.SecretMC_2["skill_" + String(_loc6_)].metaData = {
                     "name":_loc4_.talent_skill_name,
                     "description":_loc4_.talent_skill_description,
                     "level":_loc3_.item_level
                  };
                  this.eventHandler.addListener(this.SecretMC_2["skill_" + String(_loc6_)],MouseEvent.ROLL_OVER,this.toolTipTalent,false,0,true);
                  this.eventHandler.addListener(this.SecretMC_2["skill_" + String(_loc6_)],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
               }
               else
               {
                  this.SecretMC_2["skillLvTxt_" + _loc6_].text = "Lv: 0/10";
                  if(this.canLvlUP(_loc2_,Character.character_talent_3))
                  {
                     this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.visible = true;
                     this.main.initButton(this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn,this.showNewLevelInfo);
                     this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.skill_id = _loc2_.talent_skill_id;
                     this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.skill_level = 0;
                     this.SecretMC_2["btnUpgrade_" + _loc6_].addBtn.talent_skill_id = _loc1_;
                     NinjaSage.loadIconSWF("skills",_loc2_.talent_skill_id,this.SecretMC_2["skill_" + _loc6_].holder,"with_holder");
                  }
                  else
                  {
                     this.SecretMC_2["skill_" + _loc6_].gotoAndStop("queston_mark");
                     this.SecretMC_2["btnUpgrade_" + _loc6_].addBtnDim.visible = true;
                  }
                  this.SecretMC_2["skill_" + String(_loc6_)].metaData = {
                     "name":_loc2_.talent_skill_name,
                     "description":_loc2_.talent_skill_description,
                     "level":0
                  };
                  this.eventHandler.addListener(this.SecretMC_2["skill_" + String(_loc6_)],MouseEvent.ROLL_OVER,this.toolTipTalent,false,0,true);
                  this.eventHandler.addListener(this.SecretMC_2["skill_" + String(_loc6_)],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
               }
            }
            _loc6_++;
         }
      }
      
      public function reloadTalentInfo(param1:String) : *
      {
         this.ref = param1;
         this.fetchTalents(this.reloadTalentBox);
      }
      
      public function reloadTalentBox(param1:*) : *
      {
         if(!param1.hasOwnProperty("data"))
         {
            this.destroy();
            return;
         }
         this.setTalentSkills(param1.data);
         if(this.ref == "SecretMC_2")
         {
            this.fillUPSecret2();
         }
         else if(this.ref == "SecretMC_1")
         {
            this.fillUPSecret();
         }
         else
         {
            this.fillUP();
         }
      }
      
      function toolTipTalent(param1:*) : *
      {
         var _loc2_:* = param1.currentTarget.metaData;
         var _loc3_:* = _loc2_.name + "\n(Level " + _loc2_.level + ")\n\n" + _loc2_.description;
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc3_);
      }
      
      function toolTiponOut(param1:MouseEvent) : void
      {
         this.tooltip.hide();
      }
      
      public function showNewLevelInfo(param1:MouseEvent) : *
      {
         this.lvl_up_mc.visible = true;
         this.lvl_up_mc.init(this);
         this.lvl_up_mc.setInfo(param1.currentTarget.skill_id,param1.currentTarget.talent_skill_id,param1.currentTarget.skill_level,param1.currentTarget.parent.parent.name);
      }
      
      public function showFullLevelInfo(param1:MouseEvent) : *
      {
         this.skill_info_mc.visible = true;
         this.skill_info_mc.init(this);
         this.skill_info_mc.setInfo(param1.currentTarget.skill_id,param1.currentTarget.talent_skill_id);
      }
      
      public function addButtonListeners() : *
      {
         this.main.initButton(this.btnBPMission,this.openTPTraining,"TP Training");
         this.main.initButton(this.btnConvertBP,this.openTPBoost,"Boost TP");
         this.main.initButton(this.btnReset,this.openResetTP,"Reset");
         this.main.initButton(this.btnExit,this.closeThis);
      }
      
      public function closeThis(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("RzFUf16G1EIy2bfB.u08n6h73qXKo",[Character.char_id,Character.sessionkey],this.onGotInfo2);
      }
      
      public function onGotInfo2(param1:Object) : *
      {
         this.main.loading(false);
         this.talent_skill = param1.data;
         Character.character_talent_skills = "";
         var _loc2_:* = 0;
         while(_loc2_ < this.talent_skill.length)
         {
            if(Character.character_talent_skills == "")
            {
               Character.character_talent_skills = this.talent_skill[_loc2_].item_id + ":" + this.talent_skill[_loc2_].item_level;
            }
            else
            {
               Character.character_talent_skills = Character.character_talent_skills + "," + this.talent_skill[_loc2_].item_id + ":" + this.talent_skill[_loc2_].item_level;
            }
            _loc2_++;
         }
         this.main.HUD.setBasicData();
         this.main.HUD.loadFrame();
         this.destroy();
      }
      
      public function removeIcon() : *
      {
         var _loc1_:* = 1;
         this.BloodlineMC.gotoAndStop(6);
         this.SecretMC_1.gotoAndStop(6);
         this.SecretMC_2.gotoAndStop(6);
         while(_loc1_ < 7)
         {
            GF.removeAllChild(this.BloodlineMC["skill_" + _loc1_].holder);
            _loc1_++;
         }
         var _loc2_:* = 1;
         while(_loc2_ < 4)
         {
            GF.removeAllChild(this.SecretMC_1["skill_" + _loc2_].holder);
            GF.removeAllChild(this.SecretMC_2["skill_" + _loc2_].holder);
            _loc2_++;
         }
         if(NinjaSage.loader != null)
         {
            NinjaSage.loader.removeAll();
         }
      }
      
      public function openTPTraining(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("MissionRoom","MissionRoom");
         this.destroy();
      }
      
      public function openTPBoost(param1:MouseEvent) : *
      {
         this.boost_mc.visible = true;
         this.boost_mc.init(this);
      }
      
      public function openResetTP(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.ResetTalent");
         this.destroy();
      }
      
      public function openDiscoverTalent(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.TalentShop");
         this.destroy();
      }
      
      public function clearMain() : *
      {
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.handleVillageHUDVisibility(true);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         if(NinjaSage.loader != null)
         {
            NinjaSage.clearLoader();
         }
         this.removeIcon();
         this.removeChild(this.tooltip);
         this.tooltip = null;
         GF.removeAllChild(this);
         this.main = null;
         parent.removeChild(this);
      }
   }
}
