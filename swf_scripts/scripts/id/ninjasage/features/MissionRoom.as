package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.StatManager;
   import Storage.Character;
   import Storage.EnemyInfo;
   import Storage.MissionLibrary;
   import Storage.NpcInfo;
   import br.com.stimuli.loading.BulkLoader;
   import com.adobe.crypto.CUCSG;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class MissionRoom extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var response:Object;
      
      private var recruitCounter:int = 0;
      
      private var recruitArray:Array;
      
      private var gradeC:Array = MissionLibrary.getMissionIds("c");
      
      private var gradeB:Array = MissionLibrary.getMissionIds("b");
      
      private var gradeA:Array = MissionLibrary.getMissionIds("a");
      
      private var gradeS:Array = MissionLibrary.getMissionIds("s");
      
      private var gradeSS:Array = MissionLibrary.getMissionIds("ss");
      
      private var gradeTP:Array = MissionLibrary.getMissionIds("tp");
      
      private var gradeSpecial:Array = MissionLibrary.getMissionIds("special");
      
      private var gradeDaily:Array = MissionLibrary.getMissionIds("daily");
      
      private var selectedCategory:Array;
      
      public var outfits:Array = [];
      
      private var selectedMission:*;
      
      private var titleScroll:String;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var currentTab:String = "story";
      
      public function MissionRoom(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.main.handleVillageHUDVisibility(false);
         this.panelMC.missionPanel.addFrameScript(0,this.onGradeList,3,this.stopMissionPanel,12,this.onMissionList,16,this.stopMissionPanel);
         this.panelMC.missionPanel.story.gotoAndStop("select");
         this.panelMC.missionPanel.other.gotoAndStop("unselect");
         this.setFrameOne();
         this.getMissionData();
         this.initButton();
         this.initBasicUI();
      }
      
      private function setFrameOne() : void
      {
         var _loc1_:MovieClip = this.panelMC.missionPanel;
         _loc1_.menu1.btnGrade_s.gotoAndStop(1);
         _loc1_.menu1.btnGrade_a.gotoAndStop(1);
         _loc1_.menu1.btnGrade_b.gotoAndStop(1);
         _loc1_.menu1.btnGrade_c.gotoAndStop(1);
         _loc1_.menu2.btnGrade_special.gotoAndStop(1);
         _loc1_.menu2.btnGrade_daily.gotoAndStop(1);
         _loc1_.menu2.btnGrade_tp.gotoAndStop(1);
         _loc1_.menu2.btnGrade_ss.gotoAndStop(1);
      }
      
      private function initBasicUI() : void
      {
         this.panelMC.recruitPanel.gotoAndStop(1);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.panelMC.recruitPanel["recruit" + _loc1_].charLevelMC.visible = false;
            this.panelMC.recruitPanel["recruit" + _loc1_].rankIcon.visible = false;
            this.panelMC.recruitPanel["recruit" + _loc1_].emblemIcon.visible = false;
            this.panelMC.recruitPanel["recruit" + _loc1_].charMc.visible = false;
            _loc1_++;
         }
         if(Character.character_recruit_ids.length > 0)
         {
            this.panelMC.btn_removeRecruit.visible = true;
            this.eventHandler.addListener(this.panelMC.btn_removeRecruit,MouseEvent.CLICK,this.removeRecruitedSquad);
         }
         else
         {
            this.panelMC.btn_removeRecruit.visible = false;
         }
         this.panelMC.tokenTxt.text = String(Character.account_tokens);
         this.main.initButton(this.panelMC.getMoreBtn,this.openRecharge,"");
      }
      
      private function getMissionData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.qTvkAQHXzLQb",[Character.char_id,Character.sessionkey],this.onGetMissionData);
      }
      
      private function onGetMissionData(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1.status == 1)
         {
            this.response = param1;
            this.recruitArray = ["char_" + Character.char_id];
            _loc2_ = 0;
            while(_loc2_ < this.response.recruit.length)
            {
               if(this.response.recruit[_loc2_].type == "char")
               {
                  this.recruitArray.push(this.response.recruit[_loc2_].type + "_" + this.response.recruit[_loc2_].id);
               }
               else
               {
                  this.recruitArray.push(this.response.recruit[_loc2_].id.recruiter_id);
               }
               _loc2_++;
            }
            this.initRecruitUI();
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
      
      public function initRecruitUI() : void
      {
         if(this.recruitCounter < this.recruitArray.length)
         {
            if(this.recruitArray[this.recruitCounter].indexOf("char_") >= 0)
            {
               this.loadPlayerCharacter();
            }
            else
            {
               this.loadNpcCharacter();
            }
            return;
         }
         this.main.loading(false);
      }
      
      private function loadPlayerCharacter() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:OutfitManager = new OutfitManager();
         var _loc2_:int = 1;
         while(_loc2_ < 4)
         {
            this.panelMC.recruitPanel["recruit0"]["skillBtn" + _loc2_].gotoAndStop(1);
            this.panelMC.recruitPanel["recruit1"]["skillBtn" + _loc2_].gotoAndStop(1);
            this.panelMC.recruitPanel["recruit2"]["skillBtn" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         if(Character.char_id == this.recruitArray[this.recruitCounter].split("_")[1])
         {
            if(!Character.is_stickman)
            {
               _loc1_.fillOutfit(this.panelMC.recruitPanel["recruit" + this.recruitCounter].charMc,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
            }
            this.outfits.push(_loc1_);
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].charMc.visible = true;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].noPlayer.visible = false;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].recruitTeam.visible = false;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].charLevelMC.visible = true;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].rankIcon.visible = true;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].emblemIcon.visible = Character.account_type == 1;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].char_name.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.panelMC.recruitPanel["recruit" + this.recruitCounter].char_name);
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].charLevelMC.levelTxt.text = Character.character_lvl;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].rankIcon.gotoAndStop(Character.character_rank);
            _loc2_ = 1;
            while(_loc2_ < 4)
            {
               this.panelMC.recruitPanel["recruit0"]["skillBtn" + _loc2_].gotoAndStop(1);
               this.panelMC.recruitPanel["recruit1"]["skillBtn" + _loc2_].gotoAndStop(1);
               this.panelMC.recruitPanel["recruit2"]["skillBtn" + _loc2_].gotoAndStop(1);
               this.panelMC.recruitPanel["recruit" + this.recruitCounter]["skillBtn" + _loc2_].gotoAndStop(int(Character["character_element_" + _loc2_]) + 1);
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = this.response.recruit[this.recruitCounter - 1].info.set;
            _loc4_ = this.response.recruit[this.recruitCounter - 1].info;
            if(!Character.is_stickman)
            {
               _loc1_.fillOutfit(this.panelMC.recruitPanel["recruit" + this.recruitCounter].charMc,_loc3_.weapon,_loc3_.back_item,_loc3_.clothing,_loc3_.hairstyle,_loc3_.face,_loc3_.hair_color,_loc3_.skin_color);
            }
            this.outfits.push(_loc1_);
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].charMc.visible = true;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].noPlayer.visible = false;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].recruitTeam.visible = false;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].charLevelMC.visible = true;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].rankIcon.visible = true;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].emblemIcon.visible = _loc4_.emblem == true;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].char_name.htmlText = Character.colorifyText(_loc4_.id,_loc4_.name,this.panelMC.recruitPanel["recruit" + this.recruitCounter].char_name);
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].charLevelMC.levelTxt.text = _loc4_.level;
            this.panelMC.recruitPanel["recruit" + this.recruitCounter].rankIcon.gotoAndStop(_loc4_.rank);
            _loc2_ = 1;
            while(_loc2_ < 4)
            {
               this.panelMC.recruitPanel["recruit" + this.recruitCounter]["skillBtn" + _loc2_].gotoAndStop(int(_loc4_["element_" + _loc2_]) + 1);
               _loc2_++;
            }
         }
         ++this.recruitCounter;
         setTimeout(this.initRecruitUI,100);
      }
      
      private function loadNpcCharacter() : void
      {
         GF.removeAllChild(this.panelMC.recruitPanel["recruit" + this.recruitCounter].holder);
         NinjaSage.loadIconSWF("npcs",this.recruitArray[this.recruitCounter],this.panelMC.recruitPanel["recruit" + this.recruitCounter].holder,this.recruitArray[this.recruitCounter]);
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].charMc.visible = false;
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].recruitTeam.visible = false;
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].noPlayer.visible = false;
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].emblemIcon.visible = false;
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].charLevelMC.visible = true;
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].rankIcon.visible = true;
         var _loc1_:Object = NpcInfo.getNpcStats(this.recruitArray[this.recruitCounter]);
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].char_name.htmlText = Character.colorifyText(_loc1_.npc_id,_loc1_.npc_name,this.panelMC.recruitPanel["recruit" + this.recruitCounter].char_name);
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].charLevelMC.levelTxt.text = _loc1_.npc_level;
         this.panelMC.recruitPanel["recruit" + this.recruitCounter].rankIcon.gotoAndStop(_loc1_.npc_rank);
         ++this.recruitCounter;
         this.initRecruitUI();
      }
      
      public function onGradeList() : void
      {
         var _loc1_:MovieClip = this.panelMC.missionPanel;
         _loc1_.stop();
         _loc1_.other.gotoAndStop("unselect");
         _loc1_.other.btn.gotoAndStop(1);
         _loc1_.menu2.visible = false;
         _loc1_.arrowMc.visible = false;
         _loc1_.arrowMc1.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_.doubleXPMc["doubleXp_" + _loc2_].visible = false;
            _loc1_.doubleXPTxt["doubleTime_" + _loc2_].visible = false;
            _loc1_.doubleXPTxt["doubleTimeBg_" + _loc2_].visible = false;
            _loc2_++;
         }
      }
      
      public function onGradeSMission() : void
      {
         var _loc1_:MovieClip = this.panelMC.missionPanel;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc1_.gradeSList["eightymission_" + _loc2_].gotoAndStop("disable");
            _loc1_.gradeSList["eightymission_" + _loc2_].newMc.visible = false;
            _loc2_++;
         }
         _loc1_.menu1.visible = false;
         _loc1_.btnEightyPrevPage.visible = false;
         _loc1_.btnEightyNextPage.visible = false;
         _loc1_.gradeSList["eightymission_0"].newMc.visible = true;
         _loc1_.gradeSList["eightymission_0"].gotoAndStop("enable");
         this.eventHandler.addListener(_loc1_.backBtn,MouseEvent.CLICK,this.backToSelectCategory);
         this.eventHandler.addListener(_loc1_.gradeSList["eightymission_0"],MouseEvent.CLICK,this.openGradeSPanel);
         this.eventHandler.addListener(_loc1_.gradeSList["eightymission_0"],MouseEvent.MOUSE_OVER,this.onCategoryHover);
         this.eventHandler.addListener(_loc1_.gradeSList["eightymission_0"],MouseEvent.MOUSE_OUT,this.onCategoryOut);
      }
      
      public function openGradeSPanel(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("SMissionMap","SMissionMap");
         this.destroy();
      }
      
      public function onMissionListButton() : void
      {
         var _loc1_:MovieClip = this.panelMC.missionPanel;
         this.eventHandler.addListener(_loc1_.btnExit,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(_loc1_.missionListMc.backBtn,MouseEvent.CLICK,this.backToSelectCategory);
         this.eventHandler.addListener(_loc1_.missionListMc.prevPageBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(_loc1_.missionListMc.nextPageBtn,MouseEvent.CLICK,this.changePage);
      }
      
      public function onMissionList() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         this.onMissionListButton();
         var _loc1_:MovieClip = this.panelMC.missionPanel;
         _loc1_.stop();
         _loc1_.txt_misssionselect.text = this.titleScroll;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_.missionListMc["btnMission_" + _loc2_].gotoAndStop(1);
            _loc3_ = _loc2_ + int(int(this.currentPage - 1) * 3);
            if(this.selectedCategory.length > _loc3_)
            {
               _loc4_ = MissionLibrary.getMissionInfo(this.selectedCategory[_loc3_]);
               _loc1_.missionListMc["btnMission_" + _loc2_].visible = true;
               _loc1_.missionListMc["btnMission_" + _loc2_].nameTxt.text = _loc4_["msn_name"];
               _loc1_.missionListMc["btnMission_" + _loc2_].levelTxt.text = _loc4_["msn_level"];
               _loc1_.missionListMc["btnMission_" + _loc2_].xpTxt.text = _loc4_["msn_rewards"].xp;
               _loc1_.missionListMc["btnMission_" + _loc2_].goldTxt.text = _loc4_["msn_rewards"].gold;
               _loc1_.missionListMc["btnMission_" + _loc2_].sp.visible = false;
               _loc1_.missionListMc["btnMission_" + _loc2_].tp.visible = false;
               _loc1_.missionListMc["btnMission_" + _loc2_].doubleXPMc.visible = false;
               if(_loc4_["msn_premium"])
               {
                  _loc1_.missionListMc["btnMission_" + _loc2_].lockMc.gotoAndStop(3);
               }
               if(_loc4_["msn_level"] > int(Character.character_lvl))
               {
                  _loc1_.missionListMc["btnMission_" + _loc2_].lockMc.gotoAndStop(2);
               }
               else
               {
                  _loc1_.missionListMc["btnMission_" + _loc2_].lockMc.gotoAndStop(1);
               }
               if(_loc4_["msn_grade"] == "tp")
               {
                  _loc1_.missionListMc["btnMission_" + _loc2_].tp.visible = true;
                  _loc1_.missionListMc["btnMission_" + _loc2_].tpTxt.text = _loc4_["msn_rewards"].tp;
               }
               else if(_loc4_["msn_grade"] == "ss")
               {
                  _loc1_.missionListMc["btnMission_" + _loc2_].sp.visible = true;
                  _loc1_.missionListMc["btnMission_" + _loc2_].tpTxt.text = _loc4_["msn_rewards"].ss;
               }
               _loc1_.missionListMc["btnMission_" + _loc2_].missionData = _loc4_;
               this.eventHandler.addListener(_loc1_.missionListMc["btnMission_" + _loc2_],MouseEvent.CLICK,this.openDetail);
               this.eventHandler.addListener(_loc1_.missionListMc["btnMission_" + _loc2_],MouseEvent.MOUSE_OVER,this.onCategoryHover);
               this.eventHandler.addListener(_loc1_.missionListMc["btnMission_" + _loc2_],MouseEvent.MOUSE_OUT,this.onCategoryOut);
            }
            else
            {
               _loc1_.missionListMc["btnMission_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 3),1);
         this.updatePageText();
      }
      
      private function openDetail(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:MovieClip = this.panelMC.missionPanel;
         this.eventHandler.addListener(_loc2_.btnExit,MouseEvent.CLICK,this.closePanel);
         this.selectedMission = param1.currentTarget.missionData;
         _loc2_.gotoAndStop("detail");
         _loc2_.txt_misssionselect.text = this.titleScroll;
         if(this.selectedMission["msn_id"] in this.response.daily)
         {
            _loc2_.detailMc.lbl_completed_detail.text = "Remaining: " + this.response.daily[this.selectedMission["msn_id"]];
         }
         _loc2_.detailMc.nameTxt.text = this.selectedMission["msn_name"];
         _loc2_.detailMc.levelTxt.text = this.selectedMission["msn_level"];
         _loc2_.detailMc.descriptionTxt.text = this.selectedMission["msn_description"];
         _loc2_.detailMc.xpTxt.text = this.selectedMission["msn_rewards"].xp;
         _loc2_.detailMc.goldTxt.text = this.selectedMission["msn_rewards"].gold;
         _loc2_.detailMc.sp.visible = false;
         _loc2_.detailMc.tp.visible = false;
         _loc2_.detailMc.doubleXPMc.visible = false;
         if(this.selectedMission["msn_grade"] == "tp")
         {
            _loc2_.detailMc.tp.visible = true;
            _loc2_.detailMc.tpTxt.text = this.selectedMission["msn_rewards"].tp;
         }
         else if(this.selectedMission["msn_grade"] == "ss")
         {
            _loc2_.detailMc.sp.visible = true;
            _loc2_.detailMc.tpTxt.text = this.selectedMission["msn_rewards"].ss;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc4_ = _loc3_ + 0 * 4;
            _loc2_.detailMc["rewardItem" + _loc3_].visible = false;
            if("materials" in this.selectedMission["msn_rewards"])
            {
               if(this.selectedMission["msn_rewards"].materials.length > _loc4_)
               {
                  _loc2_.detailMc["rewardItem" + _loc3_].visible = true;
                  NinjaSage.loadItemIcon(_loc2_.detailMc["rewardItem" + _loc3_].iconHolder,this.selectedMission["msn_rewards"].materials[_loc3_],"icon");
               }
            }
            _loc3_++;
         }
         this.eventHandler.addListener(_loc2_.detailMc.btnBack,MouseEvent.CLICK,this.backToMissionList);
         this.eventHandler.addListener(_loc2_.detailMc.btnAccept,MouseEvent.CLICK,this.startMission);
      }
      
      private function startMission(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.main.showMessage("Please equip at least 1 skill");
            return;
         }
         if(Boolean(this.selectedMission["msn_premium"]) && Character.account_type == 0)
         {
            this.main.showMessage("Must Premium User to play this mission!");
            return;
         }
         if(this.selectedMission["msn_level"] > int(Character.character_lvl))
         {
            this.main.showMessage("Level too low!");
            return;
         }
         if(this.selectedMission["msn_enemy"].length == 0)
         {
            this.main.loading(true);
            this.main.amf_manager.service("IOIJB836r2Hu2PPW.Nl00nmmPMKN6",[Character.char_id,Character.sessionkey,this.selectedMission["msn_id"]],this.onStartMiniGameAmf);
         }
         else
         {
            Character.mission_level = int(this.selectedMission["msn_level"]);
            Character.mission_id = this.selectedMission["msn_id"];
            if(int(Character.character_lvl) >= int(this.selectedMission["msn_level"]))
            {
               _loc2_ = "";
               _loc3_ = "";
               _loc4_ = StatManager.calculate_stats_with_data("agility",int(Character.character_lvl),Character.atrrib_earth,Character.atrrib_water,Character.atrrib_wind,Character.atrrib_lightning);
               _loc5_ = 0;
               while(_loc5_ < this.selectedMission["msn_enemy"].length)
               {
                  _loc7_ = EnemyInfo.getEnemyStats(this.selectedMission["msn_enemy"][_loc5_]);
                  if(_loc2_ == "")
                  {
                     _loc2_ = this.selectedMission["msn_enemy"][_loc5_];
                     _loc3_ = "id:" + _loc7_["enemy_id"] + "|hp:" + _loc7_["enemy_hp"] + "|agility:" + _loc7_["enemy_agility"];
                  }
                  else
                  {
                     _loc2_ = _loc2_ + "," + this.selectedMission["msn_enemy"][_loc5_];
                     _loc3_ = _loc3_ + "#id:" + _loc7_["enemy_id"] + "|hp:" + _loc7_["enemy_hp"] + "|agility:" + _loc7_["enemy_agility"];
                  }
                  _loc5_++;
               }
               this.main.loading(true);
               _loc6_ = CUCSG.hash(_loc2_ + _loc3_ + _loc4_);
               this.main.amf_manager.service("IOIJB836r2Hu2PPW.mwaPMdtCPC5o",[Character.char_id,Character.mission_id,_loc2_,_loc3_,_loc4_,_loc6_,Character.sessionkey],this.onStartMissionAmf);
            }
         }
      }
      
      private function onStartMissionAmf(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.length != 10)
         {
            this.main.showMessage("You have 0 chance to enter this mission, comeback tomorrow!");
            return;
         }
         Character.is_hunting_house = false;
         Character.battle_code = param1;
         this.main.combat = this.main.loadPanel("Combat.Battle",true);
         BattleManager.init(this.main.combat,this.main,BattleVars.MISSION_MATCH,this.selectedMission["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < this.selectedMission["msn_enemy"].length)
         {
            BattleManager.addPlayerToTeam("enemy",this.selectedMission["msn_enemy"][_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
         this.destroy();
      }
      
      private function onStartMiniGameAmf(param1:Object) : void
      {
         var _loc2_:String = null;
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.battle_code = param1.code;
            _loc2_ = this.selectedMission["msn_bg"].charAt(0).toUpperCase() + this.selectedMission["msn_bg"].substring(1).toLowerCase();
            this.main.loadMissionMiniGame(this.selectedMission["msn_bg"],_loc2_);
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
      
      private function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "nextPageBtn":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.onMissionList();
               }
               break;
            case "prevPageBtn":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.onMissionList();
               }
         }
         this.updatePageText();
      }
      
      private function updatePageText() : void
      {
         this.panelMC.missionPanel.missionListMc.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function changeTab(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc2_:MovieClip = this.panelMC.missionPanel;
         if(_loc2_.currentLabel == "mission")
         {
            return;
         }
         if(param1 is MouseEvent)
         {
            _loc3_ = param1.currentTarget.name;
         }
         else
         {
            _loc3_ = param1;
         }
         if(_loc3_ == "other")
         {
            _loc2_.other.gotoAndStop("select");
            _loc2_.story.gotoAndStop("unselect");
            _loc2_.story.btn.gotoAndStop(1);
            _loc2_.menu2.visible = true;
            _loc2_.menu1.visible = false;
            this.currentTab = "other";
         }
         else
         {
            _loc2_.story.gotoAndStop("select");
            _loc2_.other.gotoAndStop("unselect");
            _loc2_.other.btn.gotoAndStop(1);
            _loc2_.menu1.visible = true;
            _loc2_.menu2.visible = false;
            this.currentTab = "story";
         }
      }
      
      private function changeCategory(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.panelMC.missionPanel;
         var _loc3_:String = param1.currentTarget.name.replace("btnGrade_","");
         switch(_loc3_)
         {
            case "c":
               this.selectedCategory = this.gradeC;
               this.titleScroll = "Grade C Mission";
               break;
            case "b":
               this.selectedCategory = this.gradeB;
               this.titleScroll = "Grade B Mission";
               break;
            case "a":
               this.selectedCategory = this.gradeA;
               this.titleScroll = "Grade A Mission";
               break;
            case "s":
               this.selectedCategory = this.gradeS;
               this.titleScroll = "Grade S Mission";
               break;
            case "ss":
               this.selectedCategory = this.gradeSS;
               this.titleScroll = "SS Training";
               break;
            case "tp":
               this.selectedCategory = this.gradeTP;
               this.titleScroll = "TP Training";
               break;
            case "daily":
               this.selectedCategory = this.gradeDaily;
               this.titleScroll = "Daily Mission";
               break;
            case "special":
               this.selectedCategory = this.gradeSpecial;
               this.titleScroll = "Special Events";
         }
         if(_loc3_ == "s")
         {
            _loc2_.gotoAndPlay("mission");
            this.onGradeSMission();
         }
         else
         {
            _loc2_.gotoAndStop("list");
            _loc2_.rollMC.addFrameScript(0,this.stopRollMC,12,this.stopRollMC,19,this.stopRollMC,26,this.stopRollMC,33,this.stopRollMC,40,this.stopRollMC,47,this.stopRollMC,54,this.stopRollMC);
            _loc2_.rollMC.gotoAndPlay(_loc3_);
            _loc2_.gotoAndPlay("list");
         }
      }
      
      private function backToSelectCategory(param1:MouseEvent) : void
      {
         this.panelMC.missionPanel.gotoAndStop("show");
         this.setFrameOne();
         this.onGradeList();
         this.initButton();
         this.changeTab(this.currentTab);
         this.currentPage = 1;
      }
      
      private function backToMissionList(param1:MouseEvent) : void
      {
         this.panelMC.missionPanel.gotoAndPlay(13);
      }
      
      private function removeRecruitedSquad(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.UfM4kjzQev0Y",[Character.char_id,Character.sessionkey],this.removeRecruitedSquadRes);
      }
      
      private function removeRecruitedSquadRes(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            Character.character_recruit_ids = [];
            this.panelMC.btn_removeRecruit.visible = false;
            this.resetRecruitUI();
            this.main.HUD.setBasicData();
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
      
      private function resetRecruitUI() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 3)
         {
            this.panelMC.recruitPanel["recruit" + _loc1_].charMc.visible = false;
            this.panelMC.recruitPanel["recruit" + _loc1_].noPlayer.visible = true;
            this.panelMC.recruitPanel["recruit" + _loc1_].recruitTeam.visible = true;
            this.panelMC.recruitPanel["recruit" + _loc1_].charLevelMC.visible = false;
            this.panelMC.recruitPanel["recruit" + _loc1_].rankIcon.visible = false;
            this.panelMC.recruitPanel["recruit" + _loc1_].emblemIcon.visible = false;
            this.panelMC.recruitPanel["recruit" + _loc1_].char_name.text = "";
            this.panelMC.recruitPanel["recruit" + _loc1_].rankIcon.visible = false;
            GF.removeAllChild(this.panelMC.recruitPanel["recruit" + _loc1_].holder);
            GF.removeAllChild(this.panelMC.recruitPanel["recruit" + _loc1_].charMc);
            _loc1_++;
         }
         _loc1_ = 1;
         while(_loc1_ < 4)
         {
            this.panelMC.recruitPanel["recruit1"]["skillBtn" + _loc1_].gotoAndStop(1);
            this.panelMC.recruitPanel["recruit2"]["skillBtn" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      public function initButton() : void
      {
         var _loc1_:MovieClip = this.panelMC.missionPanel;
         this.eventHandler.addListener(_loc1_.btnExit,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(_loc1_.other,MouseEvent.CLICK,this.changeTab);
         this.eventHandler.addListener(_loc1_.other,MouseEvent.MOUSE_OVER,this.onTabHover);
         this.eventHandler.addListener(_loc1_.other,MouseEvent.MOUSE_OUT,this.onTabOut);
         this.eventHandler.addListener(_loc1_.story,MouseEvent.CLICK,this.changeTab);
         this.eventHandler.addListener(_loc1_.story,MouseEvent.MOUSE_OVER,this.onTabHover);
         this.eventHandler.addListener(_loc1_.story,MouseEvent.MOUSE_OUT,this.onTabOut);
         this.eventHandler.addListener(_loc1_.menu1.btnGrade_c,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(_loc1_.menu1.btnGrade_c,MouseEvent.MOUSE_OVER,this.onCategoryHover);
         this.eventHandler.addListener(_loc1_.menu1.btnGrade_c,MouseEvent.MOUSE_OUT,this.onCategoryOut);
         this.eventHandler.addListener(_loc1_.menu2.btnGrade_daily,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(_loc1_.menu2.btnGrade_daily,MouseEvent.MOUSE_OVER,this.onCategoryHover);
         this.eventHandler.addListener(_loc1_.menu2.btnGrade_daily,MouseEvent.MOUSE_OUT,this.onCategoryOut);
         if(this.gradeSpecial.length > 0)
         {
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_special,MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_special,MouseEvent.MOUSE_OVER,this.onCategoryHover);
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_special,MouseEvent.MOUSE_OUT,this.onCategoryOut);
         }
         else
         {
            _loc1_.menu2.btnGrade_special.gotoAndStop("disable");
         }
         if(int(Character.character_lvl) >= 20)
         {
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_b,MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_b,MouseEvent.MOUSE_OVER,this.onCategoryHover);
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_b,MouseEvent.MOUSE_OUT,this.onCategoryOut);
         }
         else
         {
            _loc1_.menu1.btnGrade_b.gotoAndStop("disable");
         }
         if(int(Character.character_lvl) >= 40)
         {
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_a,MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_a,MouseEvent.MOUSE_OVER,this.onCategoryHover);
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_a,MouseEvent.MOUSE_OUT,this.onCategoryOut);
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_tp,MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_tp,MouseEvent.MOUSE_OVER,this.onCategoryHover);
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_tp,MouseEvent.MOUSE_OUT,this.onCategoryOut);
         }
         else
         {
            _loc1_.menu1.btnGrade_a.gotoAndStop("disable");
            _loc1_.menu2.btnGrade_tp.gotoAndStop("disable");
         }
         if(int(Character.character_lvl) >= 80)
         {
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_s,MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_s,MouseEvent.MOUSE_OVER,this.onCategoryHover);
            this.eventHandler.addListener(_loc1_.menu1.btnGrade_s,MouseEvent.MOUSE_OUT,this.onCategoryOut);
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_ss,MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_ss,MouseEvent.MOUSE_OVER,this.onCategoryHover);
            this.eventHandler.addListener(_loc1_.menu2.btnGrade_ss,MouseEvent.MOUSE_OUT,this.onCategoryOut);
         }
         else
         {
            _loc1_.menu1.btnGrade_s.gotoAndStop("disable");
            _loc1_.menu2.btnGrade_ss.gotoAndStop("disable");
            _loc1_.menu2.btnGrade_ss.stampTxt.visible = false;
         }
      }
      
      private function onCategoryHover(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop("mover");
      }
      
      private function onCategoryOut(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop("enable");
      }
      
      private function onTabHover(param1:MouseEvent) : void
      {
         param1.currentTarget.btn.gotoAndStop(2);
      }
      
      private function onTabOut(param1:MouseEvent) : void
      {
         param1.currentTarget.btn.gotoAndStop(1);
      }
      
      private function stopMissionPanel() : void
      {
         this.panelMC.missionPanel.stop();
      }
      
      private function stopRollMC() : void
      {
         this.panelMC.missionPanel.rollMC.stop();
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.handleVillageHUDVisibility(true);
         this.main.removeExternalSwfPanel();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            GF.removeAllChild(this.panelMC.recruitPanel["recruit" + _loc1_].charMc);
            _loc1_++;
         }
         this.eventHandler.removeAllEventListeners();
         this.recruitArray = [];
         this.gradeC = [];
         this.gradeB = [];
         this.gradeA = [];
         this.gradeS = [];
         this.gradeSS = [];
         this.gradeTP = [];
         this.gradeSpecial = [];
         this.gradeDaily = [];
         this.selectedCategory = [];
         GF.destroyArray(this.outfits);
         NinjaSage.clearLoader();
         BulkLoader.getLoader("assets").removeAll();
         OutfitManager.clearStaticMc();
         this.resetRecruitUI();
         this.outfits = null;
         this.recruitCounter = 0;
         this.selectedMission = null;
         this.titleScroll = null;
         this.currentPage = 0;
         this.totalPage = 0;
         this.currentTab = null;
         this.main = null;
         this.eventHandler = null;
         this.response = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

