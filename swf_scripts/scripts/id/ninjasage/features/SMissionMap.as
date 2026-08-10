package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.OutfitManager;
   import Managers.StatManager;
   import Storage.Character;
   import Storage.EnemyInfo;
   import Storage.MissionLibrary;
   import com.adobe.crypto.CUCSG;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class SMissionMap extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var response:Object;
      
      private var buyType:String;
      
      private var refillType:String;
      
      private var amount:int = 1;
      
      private var price:int;
      
      private var cost:int = 0;
      
      private var gradeS:Array = MissionLibrary.getMissionIds("s");
      
      private var enemies:Object = {"stage1":["ene_440","ene_441","ene_442","ene_443","ene_444"]};
      
      private var selectedStage:int;
      
      private var selectedMission:*;
      
      private var currentStage:int;
      
      private var energyUsage:Array = [10,12,14,16,25];
      
      public function SMissionMap(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.main.handleVillageHUDVisibility(false);
         this.setFrameScript();
         this.getData();
         this.initButton();
      }
      
      private function setFrameScript() : void
      {
         this.panelMC.getHeartPopup.addFrameScript(0,this.stopAnimation,7,this.onShowPopupGetHeart,16,this.stopAnimation,29,this.backToIdle);
         this.panelMC.energyBuyPopup.addFrameScript(0,this.stopAnimation,8,this.onShowPopupRefill,14,this.stopAnimation,24,this.backToIdle,35,this.backToIdle);
         this.panelMC.popupTreasure.addFrameScript(0,this.stopAnimation,8,this.onShowPopupBattle,15,this.stopAnimation,28,this.backToIdle);
         this.panelMC.getHeartPopup.gotoAndStop(1);
         this.panelMC.energyBuyPopup.gotoAndStop(1);
         this.panelMC.popupTreasure.gotoAndStop(1);
      }
      
      private function stopAnimation() : void
      {
         this.panelMC.getHeartPopup.stop();
         this.panelMC.energyBuyPopup.stop();
         this.panelMC.popupTreasure.stop();
      }
      
      private function backToIdle() : void
      {
         this.panelMC.getHeartPopup.gotoAndStop(1);
         this.panelMC.energyBuyPopup.gotoAndStop(1);
         this.panelMC.popupTreasure.gotoAndStop(1);
      }
      
      private function getData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("IOIJB836r2Hu2PPW.fPEOS6zoumUK",[Character.char_id,Character.sessionkey],this.onGetMissionData);
      }
      
      private function onGetMissionData(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.currentStage = param1.stage;
            this.initUI();
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
      
      private function initUI() : *
      {
         var _loc2_:* = undefined;
         this.panelMC.goldTxt.text = Character.character_gold;
         this.panelMC.tokenTxt.text = Character.account_tokens;
         this.panelMC.energyTxt.text = this.response.energy + "/" + this.response.max_energy;
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = _loc1_ + 0 * 5;
            this.panelMC["btnMission" + _loc1_].visible = false;
            if(this.currentStage > _loc2_)
            {
               this.panelMC["btnMission" + _loc1_].visible = true;
               this.main.initButton(this.panelMC["btnMission" + _loc1_],this.openPopup,"");
            }
            _loc1_++;
         }
      }
      
      public function onShowPopupBattle() : *
      {
         var _loc1_:* = this.panelMC.popupTreasure.panel;
         var _loc2_:* = MissionLibrary.getMissionInfo(this.gradeS[this.selectedStage]);
         this.selectedMission = _loc2_;
         _loc1_.detailTitletxt.text = _loc2_["msn_name"];
         _loc1_.storydetailtxt.text = _loc2_["msn_description"];
         _loc1_.wintxt.text = "Winning Condition: Defeat All Enemies";
         _loc1_.losetxt.text = "Losing Condition: Player is Defeated";
         _loc1_.warningtxt.text = "Minumum Requirement: Level " + _loc2_["msn_level"];
         _loc1_.detailgoldtxt.text = _loc2_["msn_rewards"].gold;
         _loc1_.detailxptxt.text = _loc2_["msn_rewards"].xp;
         Character.character_recruit_ids.length + "/2";
         _loc1_.teammembertxt.text = Character.character_recruit_ids.length + "/2";
         _loc1_.goBattleBtn.txt2.text = "-" + this.energyUsage[this.selectedStage];
         this.main.initButton(_loc1_.goBattleBtn,this.startMission,"Battle");
         this.eventHandler.addListener(_loc1_.btnClose,MouseEvent.CLICK,this.closeBattle);
      }
      
      private function startMission(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this.selectedMission["msn_level"] > int(Character.character_lvl))
         {
            this.main.showMessage("Level too low!");
            return;
         }
         Character.mission_level = int(this.selectedMission["msn_level"]);
         Character.mission_id = this.selectedMission["msn_id"];
         Character.stage_grade_s_mission = this.selectedStage + 1;
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
            this.main.amf_manager.service("IOIJB836r2Hu2PPW.mwaPMdtCPC5o",[Character.char_id,Character.mission_id,_loc2_,_loc3_,_loc4_,_loc6_,Character.sessionkey,Character.stage_grade_s_mission],this.onStartMissionAmf);
         }
      }
      
      private function onStartMissionAmf(param1:Object) : *
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         this.main.loading(false);
         if(param1.length != 10)
         {
            this.main.showMessage("Not enough energy to enter this mission");
            return;
         }
         Character.is_hunting_house = false;
         Character.battle_code = param1;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         if(this.selectedStage + 1 == 1)
         {
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.MISSION_MATCH,this.selectedMission["msn_bg"]);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               _loc4_ = Math.floor(Math.random() * this.enemies["stage" + (this.selectedStage + 1)].length);
               _loc2_.push(this.enemies["stage" + (this.selectedStage + 1)][_loc4_]);
               this.enemies["stage" + (this.selectedStage + 1)].splice(_loc4_,1);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               BattleManager.addPlayerToTeam("enemy",_loc2_[_loc3_]);
               _loc3_++;
            }
            BattleManager.startBattle();
         }
         else if(this.selectedStage + 1 == 2)
         {
            _loc5_ = ["ene_445","ene_446","ene_447"];
            _loc3_ = 0;
            while(_loc3_ < 3)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc4_ = Math.floor(Math.random() * _loc5_.length);
                  _loc2_.push(_loc5_[_loc4_]);
                  _loc6_++;
               }
               this.main.grade_s_battle_enemies[_loc3_] = _loc2_;
               _loc2_ = [];
               _loc3_++;
            }
            this.main.grade_s_battle_counter = 0;
            this.main.startGradeSBattle(this.main.grade_s_battle_counter);
         }
         else if(this.selectedStage + 1 == 3)
         {
            this.main.ambushBattleData = {
               "random_enemy":["ene_448","ene_449","ene_450"],
               "final_enemy":["ene_448","ene_449","ene_450"],
               "current_engagement":0,
               "min_engagement":3,
               "max_engagement":6
            };
            OutfitManager.removeChildsFromMovieClips(this.main.loader);
            this.main.loadAmbushBattle();
         }
         else if(this.selectedStage + 1 == 4)
         {
            this.main.is_grade_s_stage_4 = true;
            this.main.grade_s_battle_counter = 0;
            this.main.loadStage4GradeS();
         }
         else if(this.selectedStage + 1 == 5)
         {
            this.main.is_grade_s_stage_5 = true;
            this.main.grade_s_battle_counter = 0;
            this.main.loadStage5GradeS();
         }
         this.destroy();
      }
      
      public function onShowPopupRefill() : *
      {
         var _loc1_:* = this.panelMC.energyBuyPopup.panel;
         this.main.initButton(_loc1_.useRefillAllBtn,this.useRefill,"USE");
         this.main.initButton(_loc1_.useRefillFiveBtn,this.useRefill,"USE");
         this.main.initButton(_loc1_.buyFullBtn,this.openPopup,"50");
         this.main.initButton(_loc1_.buyFiveBtn,this.openPopup,"15");
         _loc1_.detailMc0.ownedFiveNumTxt.text = this.response.materials.material_899;
         _loc1_.detailMc0.ownedAllNumTxt.text = this.response.materials.material_900;
         this.eventHandler.addListener(_loc1_.btnClose,MouseEvent.CLICK,this.closeRefill);
      }
      
      public function useRefill(param1:MouseEvent) : *
      {
         this.refillType = param1.currentTarget.name == "useRefillAllBtn" ? "material_900" : "material_899";
         this.main.loading(false);
         this.main.amf_manager.service("IOIJB836r2Hu2PPW.2XFPoC4cDsye",[Character.char_id,Character.sessionkey,this.refillType],this.onUseRefill);
      }
      
      public function onUseRefill(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.removeMaterials(this.refillType,1);
            this.panelMC.energyBuyPopup.panel.detailMc0.ownedFiveNumTxt.text = param1.materials.material_899;
            this.panelMC.energyBuyPopup.panel.detailMc0.ownedAllNumTxt.text = param1.materials.material_900;
            this.panelMC.energyTxt.text = param1.energy + "/" + this.response.max_energy;
            this.main.HUD.setBasicData();
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
      
      public function onShowPopupGetHeart() : *
      {
         var _loc1_:* = this.panelMC.getHeartPopup.panel;
         _loc1_.fullIcon.visible = false;
         _loc1_.fiveIcon.visible = false;
         if(this.buyType == "material_900")
         {
            this.price = 50;
            _loc1_.fullIcon.visible = true;
         }
         else
         {
            this.price = 15;
            _loc1_.fiveIcon.visible = true;
         }
         this.main.initButton(_loc1_.buyBtn,this.buyRamen,"Buy");
         this.cost = this.price * this.amount;
         _loc1_.amountTxt.text = this.amount;
         _loc1_.tokenTxt.text = this.cost;
         this.eventHandler.addListener(_loc1_.btnNextPage,MouseEvent.CLICK,this.changeAmount);
         this.eventHandler.addListener(_loc1_.btnPrevPage,MouseEvent.CLICK,this.changeAmount);
         this.eventHandler.addListener(_loc1_.btnClose,MouseEvent.CLICK,this.closeBuyRamen);
      }
      
      private function changeAmount(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         var _loc3_:* = this.panelMC.getHeartPopup.panel;
         if(this.amount <= 1 && _loc2_ != "btnNextPage")
         {
            return;
         }
         if(_loc2_ == "btnNextPage")
         {
            this.amount += 1;
         }
         else
         {
            --this.amount;
         }
         this.cost = this.price * this.amount;
         _loc3_.amountTxt.text = this.amount;
         _loc3_.tokenTxt.text = this.cost;
         this.main.initButton(_loc3_.buyBtn,this.buyRamen,"Buy");
      }
      
      private function buyRamen(param1:MouseEvent) : *
      {
         this.main.loading(false);
         this.main.amf_manager.service("IOIJB836r2Hu2PPW.eEkE4GR2TwBO",[Character.char_id,Character.sessionkey,this.buyType,this.amount],this.onBuyRamen);
      }
      
      private function onBuyRamen(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.addMaterials(this.buyType,this.amount);
            Character.account_tokens -= this.cost;
            this.panelMC.energyBuyPopup.panel.detailMc0.ownedFiveNumTxt.text = param1.materials.material_899;
            this.panelMC.energyBuyPopup.panel.detailMc0.ownedAllNumTxt.text = param1.materials.material_900;
            this.main.HUD.setBasicData();
            this.main.showMessage(this.amount + " Ramen bought!");
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
      
      private function closeBuyRamen(param1:MouseEvent) : *
      {
         this.panelMC.getHeartPopup.gotoAndPlay(18);
         this.amount = 1;
         this.price = 0;
         this.cost = 0;
      }
      
      private function closeRefill(param1:MouseEvent) : *
      {
         this.panelMC.energyBuyPopup.gotoAndPlay("exit");
      }
      
      private function closeBattle(param1:MouseEvent) : *
      {
         this.panelMC.popupTreasure.gotoAndPlay("exit");
      }
      
      private function initButton() : *
      {
         this.main.initButton(this.panelMC.energyBtn,this.openPopup,"");
         this.main.initButton(this.panelMC.convertBtn,this.openPopup,"");
         this.main.initButton(this.panelMC.getMoreBtn,this.openPopup,"");
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btnSpin,MouseEvent.CLICK,this.openPopup);
      }
      
      private function openPopup(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "energyBtn":
               this.panelMC.energyBuyPopup.gotoAndPlay(2);
               break;
            case "convertBtn":
               this.main.loadPanel("Panels.Recharge");
               break;
            case "getMoreBtn":
               this.main.loadPanel("Panels.Recharge");
               break;
            case "buyFullBtn":
               this.buyType = "material_900";
               this.panelMC.getHeartPopup.gotoAndPlay(2);
               break;
            case "buyFiveBtn":
               this.buyType = "material_899";
               this.panelMC.getHeartPopup.gotoAndPlay(2);
               break;
            case "btnSpin":
               this.main.loadExternalSwfPanel("SpinMission","SpinMission");
               break;
            case "btnMission0":
               this.selectedStage = 0;
               this.panelMC.popupTreasure.gotoAndPlay(2);
               break;
            case "btnMission1":
               this.selectedStage = 1;
               this.panelMC.popupTreasure.gotoAndPlay(2);
               break;
            case "btnMission2":
               this.selectedStage = 2;
               this.panelMC.popupTreasure.gotoAndPlay(2);
               break;
            case "btnMission3":
               this.selectedStage = 3;
               this.panelMC.popupTreasure.gotoAndPlay(2);
               break;
            case "btnMission4":
               this.selectedStage = 4;
               this.panelMC.popupTreasure.gotoAndPlay(2);
         }
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
         this.main.handleVillageHUDVisibility(true);
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.gradeS = [];
         this.main = null;
         this.eventHandler = null;
         this.response = null;
         this.enemies = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

