package Panels
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.StatManager;
   import Storage.Character;
   import Storage.EnemyInfo;
   import Storage.MissionLibrary;
   import com.adobe.crypto.CUCSG;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   
   public class Mission_Room extends MovieClip
   {
      
      public static var hair_mc:Array = [];
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_cat_0:MovieClip;
      
      public var btn_cat_1:MovieClip;
      
      public var btn_cat_2:MovieClip;
      
      public var btn_cat_3:MovieClip;
      
      public var btn_cat_4:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_fight:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_return:SimpleButton;
      
      public var btn_removeRecruit:SimpleButton;
      
      public var char_0:MovieClip;
      
      public var char_1:MovieClip;
      
      public var char_2:MovieClip;
      
      public var infoMC:MovieClip;
      
      public var msn_0:MovieClip;
      
      public var msn_1:MovieClip;
      
      public var msn_2:MovieClip;
      
      public var msn_3:MovieClip;
      
      public var txt_page:TextField;
      
      public var txt_type:TextField;
      
      public var main;
      
      var grade_c:Array;
      
      var grade_b:Array;
      
      var grade_a:Array;
      
      var grade_daily:Array;
      
      var curr_page:int = 1;
      
      var curr_target:int;
      
      var curr_target_mc;
      
      var total_page:int = 1;
      
      var itemCnt:int = 0;
      
      var total_items:int = 0;
      
      var color:Color;
      
      public var stage_missions:Array;
      
      public var stage_type = "";
      
      var hairMC:MovieClip;
      
      var backHairMC:MovieClip;
      
      var color_1:uint;
      
      var color_2:uint;
      
      public function Mission_Room(param1:*)
      {
         this.grade_c = ["msn_01","msn_02","msn_03","msn_04","msn_05","msn_06","msn_07","msn_08","msn_09","msn_10","msn_11","msn_12","msn_13","msn_14","msn_15","msn_16","msn_17","msn_18","msn_19","msn_20"];
         this.grade_b = ["msn_21","msn_22","msn_23","msn_24","msn_25","msn_26","msn_27","msn_28","msn_29","msn_30","msn_31","msn_32","msn_33","msn_34","msn_35","msn_36","msn_37","msn_38","msn_39","msn_40"];
         this.grade_a = ["msn_41","msn_42","msn_43","msn_44","msn_45","msn_46","msn_47","msn_48","msn_49","msn_50","msn_51","msn_52","msn_53","msn_54","msn_55","msn_56","msn_57","msn_58","msn_59","msn_60"];
         this.grade_daily = ["msn_101","msn_102","msn_103","msn_104","msn_105","msn_106","msn_107","msn_108","msn_109","msn_110","msn_111"];
         this.color = new Color();
         this.stage_missions = [];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.gotoAndStop(1);
         this.loadBasicData();
      }
      
      function loadBasicData() : void
      {
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         if(Character.character_recruit_ids.length > 0)
         {
            this.btn_removeRecruit.visible = true;
            this.btn_removeRecruit.addEventListener(MouseEvent.CLICK,this.removeRecruitedSquad);
         }
         else
         {
            this.btn_removeRecruit.visible = false;
         }
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            this["btn_cat_" + _loc1_].gotoAndStop(1);
            this["btn_cat_" + _loc1_]["clickmask"].mouseEnabled = true;
            this["btn_cat_" + _loc1_]["clickmask"].addEventListener(MouseEvent.MOUSE_OVER,this.mOver);
            this["btn_cat_" + _loc1_]["clickmask"].addEventListener(MouseEvent.MOUSE_OUT,this.mOut);
            this["btn_cat_" + _loc1_]["clickmask"].addEventListener(MouseEvent.CLICK,this.selectCategory);
            _loc1_++;
         }
         this["btn_cat_4"].gotoAndStop(3);
         this["btn_cat_4"]["clickmask"].mouseEnabled = false;
         this["btn_cat_4"]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER,this.mOver);
         this["btn_cat_4"]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT,this.mOut);
         this["btn_cat_4"]["clickmask"].removeEventListener(MouseEvent.CLICK,this.selectCategory);
         if(int(Character.character_lvl) > 20 || int(Character.character_rank) > 1)
         {
            this.btn_cat_1.gotoAndStop(1);
            this["btn_cat_1"]["clickmask"].mouseEnabled = true;
         }
         else
         {
            this.btn_cat_1.gotoAndStop(3);
            this["btn_cat_1"]["clickmask"].mouseEnabled = false;
         }
         if(int(Character.character_lvl) > 40 || int(Character.character_rank) > 3)
         {
            this.btn_cat_2.gotoAndStop(1);
            this["btn_cat_2"]["clickmask"].mouseEnabled = true;
         }
         else
         {
            this.btn_cat_2.gotoAndStop(3);
            this["btn_cat_2"]["clickmask"].mouseEnabled = false;
         }
         if(int(Character.character_lvl) > 0 || int(Character.character_rank) > 0)
         {
            this.btn_cat_3.gotoAndStop(1);
            this["btn_cat_3"]["clickmask"].mouseEnabled = true;
         }
         else
         {
            this.btn_cat_3.gotoAndStop(3);
            this["btn_cat_3"]["clickmask"].mouseEnabled = false;
         }
         this.char_0.lvlMC.txt_lvl.text = Character.character_lvl;
         this.char_0.txt_name.text = Character.character_name;
         this.char_0.rankMC.gotoAndStop(Character.character_rank);
         this.char_0.element_1.gotoAndStop(int(Character.character_element_1) + 1);
         this.char_0.element_2.gotoAndStop(int(Character.character_element_2) + 1);
         this.char_0.element_1.addEventListener(MouseEvent.CLICK,this.openAcademy);
         this.char_0.element_2.addEventListener(MouseEvent.CLICK,this.openAcademy);
         if(Character.account_type == 0)
         {
            this.char_0.element_3.gotoAndStop(1);
            this.char_0.element_3.addEventListener(MouseEvent.CLICK,this.openPremiumPop);
         }
         else
         {
            this.char_0.element_3.gotoAndStop(int(Character.character_element_3) + 1);
            this.char_0.element_3.addEventListener(MouseEvent.CLICK,this.openAcademy);
         }
         if(Character.account_type == 0)
         {
            this.char_0.emblemMC.gotoAndStop(1);
            this.char_0.emblemMC.addEventListener(MouseEvent.CLICK,this.openPremiumPop);
         }
         else if(Character.account_type == 1)
         {
            this.char_0.emblemMC.gotoAndStop(2);
         }
         if(Character.character_talent_1)
         {
            this.char_0.talent_1.gotoAndStop(Character.character_talent_1);
         }
         else
         {
            this.char_0.talent_1.gotoAndStop(3);
         }
         if(Character.character_talent_2)
         {
            this.char_0.talent_2.gotoAndStop(Character.character_talent_2);
         }
         else
         {
            this.char_0.talent_2.gotoAndStop(4);
         }
         if(Character.character_talent_3)
         {
            this.char_0.talent_3.gotoAndStop(Character.character_talent_3);
         }
         else
         {
            this.char_0.talent_3.gotoAndStop(4);
         }
         this.main.outfit_manager.fillHead(this.char_0.holder,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
         var _loc2_:* = 1;
         while(_loc2_ < 3)
         {
            this["char_" + _loc2_].visible = false;
            this["char_" + _loc2_].holder.visible = false;
            this["char_" + _loc2_].lvlMC.visible = false;
            this["char_" + _loc2_].txt_name.text = "None";
            this["char_" + _loc2_].rankMC.gotoAndStop(1);
            this["char_" + _loc2_].emblemMC.gotoAndStop(1);
            this["char_" + _loc2_].talent_1.gotoAndStop(1);
            this["char_" + _loc2_].talent_2.gotoAndStop(1);
            this["char_" + _loc2_].talent_3.gotoAndStop(1);
            this["char_" + _loc2_].element_1.gotoAndStop(1);
            this["char_" + _loc2_].element_2.gotoAndStop(1);
            this["char_" + _loc2_].element_3.gotoAndStop(1);
            _loc2_++;
         }
      }
      
      function openPremiumPop(param1:MouseEvent) : void
      {
         parent.removeChild(this);
         this.main.loadPanel("Popups.EmblemUpgrade");
      }
      
      function openAcademy(param1:MouseEvent) : void
      {
         if(Character._inBattle)
         {
            this.main.giveMessage("You can\'t change your skill set during battle !");
         }
      }
      
      function mOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget.parent.currentFrame !== 3)
         {
            param1.currentTarget.parent.gotoAndStop(2);
         }
      }
      
      function mOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget.parent.currentFrame !== 3)
         {
            param1.currentTarget.parent.gotoAndStop(1);
         }
      }
      
      function selectCategory(param1:MouseEvent) : void
      {
         this.killEverything();
         this.gotoAndStop(2);
         var _loc2_:* = param1.currentTarget.parent.name.split("_");
         _loc2_ = _loc2_[2];
         this.loadMissionCategory(_loc2_);
      }
      
      function loadMissionCategory(param1:String) : void
      {
         this.btn_return.addEventListener(MouseEvent.CLICK,this.returnToMain);
         this.resetSlots();
         if(param1 == "0")
         {
            this.stage_type = "C";
            this.stage_missions = this.grade_c;
            this.curr_target = 1;
            this.getMissionInfo(this.curr_target);
            this.curr_target_mc = this["msn_0"];
            this.txt_type.text = "Grade C Missions";
         }
         else if(param1 == "1")
         {
            this.stage_type = "B";
            this.stage_missions = this.grade_b;
            this.curr_target = 21;
            this.getMissionInfo(this.curr_target);
            this.curr_target_mc = this["msn_0"];
            this.txt_type.text = "Grade B Missions";
         }
         else if(param1 == "2")
         {
            this.stage_type = "A";
            this.stage_missions = this.grade_a;
            this.curr_target = 41;
            this.getMissionInfo(this.curr_target);
            this.curr_target_mc = this["msn_0"];
            this.txt_type.text = "Grade A Missions";
         }
         else if(param1 == "3")
         {
            this.stage_type = "Daily";
            this.stage_missions = this.grade_daily;
            this.curr_target = 101;
            this.getMissionInfo(this.curr_target);
            this.curr_target_mc = this["msn_0"];
            this.txt_type.text = "Daily Missions";
         }
         this.total_page = Math.max(Math.ceil(this.stage_missions.length / 4),1);
         this.total_items = this.stage_missions.length;
         this.curr_page = 1;
         this.itemCnt = 0;
         this.loadItems();
         this.btn_next.addEventListener(MouseEvent.CLICK,this.changePage);
         this.btn_prev.addEventListener(MouseEvent.CLICK,this.changePage);
         this.btn_fight.addEventListener(MouseEvent.CLICK,this.startFight);
      }
      
      function startFight(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = MissionLibrary.getMissionInfo("msn_" + this.curr_target);
         Character.mission_level = int(_loc8_["msn_level"]);
         if(int(Character.character_lvl) >= int(_loc8_["msn_level"]))
         {
            _loc2_ = "";
            _loc3_ = "";
            _loc4_ = StatManager.calculate_stats_with_data("agility",int(Character.character_lvl),Character.atrrib_earth,Character.atrrib_water,Character.atrrib_wind,Character.atrrib_lightning);
            _loc5_ = 0;
            while(_loc5_ < _loc8_["msn_enemy"].length)
            {
               _loc7_ = EnemyInfo.getEnemyStats(_loc8_["msn_enemy"][_loc5_]);
               if(_loc2_ == "")
               {
                  _loc2_ = _loc8_["msn_enemy"][_loc5_];
                  _loc3_ = "id:" + _loc7_["enemy_id"] + "|hp:" + _loc7_["enemy_hp"] + "|agility:" + _loc7_["enemy_agility"];
               }
               else
               {
                  _loc2_ = _loc2_ + "," + _loc8_["msn_enemy"][_loc5_];
                  _loc3_ = _loc3_ + "#id:" + _loc7_["enemy_id"] + "|hp:" + _loc7_["enemy_hp"] + "|agility:" + _loc7_["enemy_agility"];
               }
               _loc5_++;
            }
            this.main.loading(true);
            _loc6_ = CUCSG.hash(_loc2_ + _loc3_ + _loc4_);
            this.main.amf_manager.service("IOIJB836r2Hu2PPW.mwaPMdtCPC5o",[Character.char_id,Character.mission_id,_loc2_,_loc3_,_loc4_,_loc6_,Character.sessionkey],this.onStartMissionAmf);
         }
      }
      
      public function onStartMissionAmf(param1:*) : *
      {
         this.main.loading(false);
         if(param1.length != 10)
         {
            this.main.giveMessage("You have 0 chance to enter this mission, comeback tomorrow!");
            return;
         }
         var _loc2_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         Character.is_hunting_house = false;
         Character.battle_code = param1;
         this.main.combat = this.main.loadPanel("Combat.Battle",true);
         BattleManager.init(this.main.combat,this.main,BattleVars.MISSION_MATCH,_loc2_["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_["msn_enemy"].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_["msn_enemy"][_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
         _loc2_ = null;
      }
      
      function loadItems() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.msn_0.visible = false;
         this.msn_1.visible = false;
         this.msn_2.visible = false;
         this.msn_3.visible = false;
         var _loc3_:* = 0;
         if(this.stage_type == "B")
         {
            _loc3_ = 20;
         }
         if(this.stage_type == "A")
         {
            _loc3_ = 40;
         }
         if(this.stage_type == "Daily")
         {
            _loc3_ = 100;
         }
         var _loc4_:* = 0;
         var _loc5_:int = int(this.curr_page - 1) * 4;
         var _loc6_:int = int(this.curr_page) * 4;
         while(_loc5_ < _loc6_)
         {
            if(_loc5_ < int(this.total_items))
            {
               if(this.curr_target_mc.name == "msn_" + int(_loc5_))
               {
                  this.curr_target_mc.gotoAndStop(3);
               }
               _loc1_ = _loc5_ + int(_loc3_);
               _loc2_ = MissionLibrary.getMissionInfo("msn_" + (_loc1_ + int(1)));
               this["msn_" + _loc4_]["clickmask"].addEventListener(MouseEvent.MOUSE_OVER,this.mOver);
               this["msn_" + _loc4_]["clickmask"].addEventListener(MouseEvent.MOUSE_OUT,this.mOut);
               this["msn_" + _loc4_].visible = true;
               this["msn_" + _loc4_]["txt_name"].text = _loc2_["msn_name"];
               this["msn_" + _loc4_]["txt_lvl"].text = _loc2_["msn_level"];
               this["msn_" + _loc4_]["txt_xp"].text = _loc2_["msn_reward_xp"];
               this["msn_" + _loc4_]["txt_gold"].text = _loc2_["msn_reward_gold"];
               this["msn_" + _loc4_]["txt_tp"].text = _loc2_["msn_reward_tp"];
               this["msn_" + _loc4_]["txt_ss"].text = _loc2_["msn_reward_ss"];
               if(_loc2_["msn_level"] > Character.character_lvl)
               {
                  this["msn_" + _loc4_].lockMC.visible = true;
                  this["msn_" + _loc4_].lockMC.gotoAndStop(1);
               }
               else
               {
                  this["msn_" + _loc4_].lockMC.visible = false;
                  this["msn_" + _loc4_].lockMC.gotoAndStop(1);
               }
               if(_loc2_["msn_premium"] && Character.account_type == 0)
               {
                  this["msn_" + _loc4_].lockMC.visible = true;
                  this["msn_" + _loc4_].lockMC.gotoAndStop(2);
                  this["msn_" + _loc4_].lockMC.addEventListener(MouseEvent.CLICK,this.openPremiumPop);
                  this.color.brightness = -0.3;
                  this["msn_" + _loc4_].transform.colorTransform = this.color;
               }
               else if(_loc2_["msn_premium"] && Character.account_type !== 0)
               {
                  this["msn_" + _loc4_].lockMC.visible = true;
                  this["msn_" + _loc4_].lockMC.gotoAndStop(2);
                  this["msn_" + _loc4_].lockMC.removeEventListener(MouseEvent.CLICK,this.openPremiumPop);
                  this.color.brightness = 0;
                  this["msn_" + _loc4_].transform.colorTransform = this.color;
               }
               else
               {
                  this["msn_" + _loc4_].lockMC.visible = false;
                  this["msn_" + _loc4_].lockMC.removeEventListener(MouseEvent.CLICK,this.openPremiumPop);
                  this.color.brightness = 0;
                  this["msn_" + _loc4_].transform.colorTransform = this.color;
               }
               this["msn_" + _loc4_]["clickmask"].buttonMode = true;
               this["msn_" + _loc4_]["clickmask"].addEventListener(MouseEvent.CLICK,this.selectMission);
               _loc4_++;
            }
            _loc5_++;
         }
         this.txt_page.text = this.curr_page + "/" + this.total_page;
      }
      
      function selectMission(param1:MouseEvent) : void
      {
         this.resetSlots();
         param1.currentTarget.parent.gotoAndStop(3);
         this.curr_target_mc = param1.currentTarget.parent;
         var _loc2_:* = param1.currentTarget.parent.name.split("_");
         _loc2_ = _loc2_[1];
         _loc2_ = (int(this.curr_page) - 1) * 4 + (int(_loc2_) + 1);
         var _loc3_:* = 0;
         if(this.stage_type == "B")
         {
            _loc3_ = 20;
         }
         if(this.stage_type == "A")
         {
            _loc3_ = 40;
         }
         if(this.stage_type == "Daily")
         {
            _loc3_ = 100;
         }
         _loc2_ = int(_loc2_) + int(_loc3_);
         this.getMissionInfo(_loc2_);
      }
      
      function getMissionInfo(param1:int) : void
      {
         this.curr_target = param1;
         var _loc2_:* = MissionLibrary.getMissionInfo("msn_" + this.curr_target);
         Character.mission_id = _loc2_.msn_id;
         this.infoMC["txt_name"].text = _loc2_["msn_name"];
         this.infoMC["txt_desc"].text = _loc2_["msn_description"];
         this.infoMC["txt_tp"].text = _loc2_["msn_reward_tp"];
         this.infoMC["txt_ss"].text = _loc2_["msn_reward_ss"];
         this.infoMC["txt_xp"].text = _loc2_["msn_reward_xp"];
         this.infoMC["txt_gold"].text = _loc2_["msn_reward_gold"];
         this.btn_fight.visible = false;
         if(int(Character.character_lvl) >= int(_loc2_["msn_level"]))
         {
            this.btn_fight.visible = true;
         }
      }
      
      function resetSlots() : void
      {
         this["msn_0"].gotoAndStop(1);
         this["msn_1"].gotoAndStop(1);
         this["msn_2"].gotoAndStop(1);
         this["msn_3"].gotoAndStop(1);
      }
      
      function changePage(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "btn_next")
         {
            if(this.curr_page < this.total_page)
            {
               ++this.curr_page;
               this.resetSlots();
               this.loadItems();
            }
         }
         else if(param1.currentTarget.name == "btn_prev")
         {
            if(this.curr_page > 1)
            {
               --this.curr_page;
               this.resetSlots();
               this.loadItems();
            }
         }
      }
      
      function returnToMain(param1:MouseEvent) : void
      {
         this.killEverything();
         this.gotoAndStop(1);
         this.loadBasicData();
      }
      
      function removeRecruitedSquad(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.UfM4kjzQev0Y",[Character.char_id,Character.sessionkey],this.removeRecruitedSquadRes);
      }
      
      function removeRecruitedSquadRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            Character.character_recruit_ids = [];
            this.btn_removeRecruit.visible = false;
            this.btn_removeRecruit.removeEventListener(MouseEvent.CLICK,this.removeRecruitedSquad);
            this.btn_removeRecruit = null;
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      function killEverything() : void
      {
         var _loc1_:* = undefined;
         try
         {
            this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
            this.btn_return.removeEventListener(MouseEvent.CLICK,this.returnToMain);
            this.char_0.element_1.removeEventListener(MouseEvent.CLICK,this.openAcademy);
            this.char_0.element_2.removeEventListener(MouseEvent.CLICK,this.openAcademy);
            this.char_0.element_3.removeEventListener(MouseEvent.CLICK,this.openAcademy);
            this.char_0.element_3.removeEventListener(MouseEvent.CLICK,this.openPremiumPop);
            this.char_0.emblemMC.removeEventListener(MouseEvent.CLICK,this.openPremiumPop);
            this.btn_next.removeEventListener(MouseEvent.CLICK,this.changePage);
            this.btn_prev.removeEventListener(MouseEvent.CLICK,this.changePage);
            this.msn_0.lockMC.removeEventListener(MouseEvent.CLICK,this.openPremiumPop);
            this.msn_1.lockMC.removeEventListener(MouseEvent.CLICK,this.openPremiumPop);
            this.msn_2.lockMC.removeEventListener(MouseEvent.CLICK,this.openPremiumPop);
            this.msn_3.lockMC.removeEventListener(MouseEvent.CLICK,this.openPremiumPop);
            this.msn_0.clickmask.removeEventListener(MouseEvent.CLICK,this.selectMission);
            this.msn_1.clickmask.removeEventListener(MouseEvent.CLICK,this.selectMission);
            this.msn_2.clickmask.removeEventListener(MouseEvent.CLICK,this.selectMission);
            this.msn_3.clickmask.removeEventListener(MouseEvent.CLICK,this.selectMission);
            this.msn_0.clickmask.removeEventListener(MouseEvent.MOUSE_OVER,this.mOver);
            this.msn_0.clickmask.removeEventListener(MouseEvent.MOUSE_OUT,this.mOut);
            this.msn_1.clickmask.removeEventListener(MouseEvent.MOUSE_OVER,this.mOver);
            this.msn_1.clickmask.removeEventListener(MouseEvent.MOUSE_OUT,this.mOut);
            this.msn_2.clickmask.removeEventListener(MouseEvent.MOUSE_OVER,this.mOver);
            this.msn_2.clickmask.removeEventListener(MouseEvent.MOUSE_OUT,this.mOut);
            this.msn_3.clickmask.removeEventListener(MouseEvent.MOUSE_OVER,this.mOver);
            this.msn_3.clickmask.removeEventListener(MouseEvent.MOUSE_OUT,this.mOut);
            _loc1_ = 0;
            while(_loc1_ < 5)
            {
               this["btn_cat_" + _loc1_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER,this.mOver);
               this["btn_cat_" + _loc1_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT,this.mOut);
               this["btn_cat_" + _loc1_]["clickmask"].removeEventListener(MouseEvent.CLICK,this.selectCategory);
               _loc1_++;
            }
            this.main = null;
            hair_mc = null;
            this.grade_c = null;
            this.grade_b = null;
            this.grade_daily = null;
            this.stage_missions = null;
            this.stage_type = null;
            this.curr_page = undefined;
            this.curr_target = undefined;
            this.curr_target_mc = null;
            this.total_page = undefined;
            this.itemCnt = undefined;
            this.total_items = undefined;
            this.color = null;
         }
         catch(e:*)
         {
         }
         System.gc();
      }
      
      function closePanel(param1:MouseEvent) : void
      {
         this.killEverything();
         this.grade_c = null;
         this.curr_page = undefined;
         this.curr_target = undefined;
         this.curr_target_mc = null;
         this.total_page = undefined;
         this.itemCnt = undefined;
         this.total_items = undefined;
         this.color = null;
         parent.removeChild(this);
      }
   }
}
