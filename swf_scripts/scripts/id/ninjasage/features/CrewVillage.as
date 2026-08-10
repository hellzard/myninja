package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.StatManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.GameData;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import id.ninjasage.Crew;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.Util;
   
   public dynamic class CrewVillage extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var timeout:*;
      
      private var crewTimestamp:*;
      
      private var loaderSwf:BulkLoader;
      
      private var upgradeName:String;
      
      private var restoreType:String;
      
      public var rewardData:Object;
      
      public var minigameRewardData:Array;
      
      private var crewData:Object;
      
      private var charData:Object;
      
      public var buildingData:Object;
      
      public var tokenPoolData:Object;
      
      public var damageBonusData:Array;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 0;
      
      private var destroyed:* = false;
      
      public const GOLDEN_ONIGIRI:String = "material_941";
      
      public const REFILL_PRICE_GOLDEN_ONIGIRI:int = 1;
      
      public const REFILL_PRICE_TOKEN:int = 10;
      
      public const REFILL_STAMINA_AMOUNT:int = 50;
      
      public const UPGRADE_STAMINA_AMOUNT:int = 50;
      
      public const UPGRADE_PRICE_TOKEN:int = 500;
      
      public const MAX_STAMINA:int = 200;
      
      public function CrewVillage(param1:*, param2:*)
      {
         var _loc3_:Object = GameData.get("crew");
         this.rewardData = Crew.instance.getRewardData();
         this.minigameRewardData = this.fillRewards(_loc3_.minigame_rewards);
         this.buildingData = _loc3_.building;
         this.tokenPoolData = _loc3_.token_pool;
         this.damageBonusData = _loc3_.damage_bonus;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(10);
         this.crewData = Character.crew_data;
         this.charData = Character.crew_char_data;
         this.crewTimestamp = Character.crew_timestamp;
         this.initButton();
         this.initUI();
         Crew.instance.addUI("village",this);
      }
      
      private function fillRewards(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_].replace("%s",Character.character_gender));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function initUI() : void
      {
         this.main.handleVillageHUDVisibility(false);
         this.panelMC.detailMC.gotoAndStop("idle");
         this.panelMC.popupdefendside.gotoAndStop("idle");
         this.panelMC.buildingUpgradeMc.gotoAndStop("idle");
         this.panelMC.stamin_panel.gotoAndStop("idle");
         this.initBuildings();
         this.updateTimeleft();
         this.initStatusDisplay();
         this.initPlayerHead();
         this.getMiniGameData();
      }
      
      public function getMiniGameData() : *
      {
         Crew.instance.getMiniGame(this.onMiniGameRes);
      }
      
      private function initBuildings() : *
      {
         this.panelMC.KushiDangoBtn.gotoAndStop("level_" + this.getBuildingLevel(this.panelMC.KushiDangoBtn.name));
         this.panelMC.teahouseBtn.gotoAndStop("level_" + this.getBuildingLevel(this.panelMC.teahouseBtn.name));
         this.panelMC.bathhouseBtn.gotoAndStop("level_" + this.getBuildingLevel(this.panelMC.bathhouseBtn.name));
         this.panelMC.trainingBtn.gotoAndStop("level_" + this.getBuildingLevel(this.panelMC.trainingBtn.name));
      }
      
      private function initButton() : void
      {
         this.eventHandler.addListener(this.panelMC.return_btn,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_CrewWarLeaderboard,MouseEvent.CLICK,this.openCrewLeaderboard);
         this.eventHandler.addListener(this.panelMC.CrewBattleBtn,MouseEvent.CLICK,this.openCrewBattle);
         this.eventHandler.addListener(this.panelMC.clanStatusMc.Btn_Mail,MouseEvent.CLICK,this.showRewardDamageRank);
         this.eventHandler.addListener(this.panelMC.clanStatusMc.btn_buystamina,MouseEvent.CLICK,this.openStaminaPopup);
         this.eventHandler.addListener(this.panelMC.crewShop,MouseEvent.CLICK,this.openCrewShop);
         this.eventHandler.addListener(this.panelMC.clanHallBtn,MouseEvent.CLICK,this.openCrewHall);
         this.main.initButton(this.panelMC.miniGameBtn,this.openMinigamePopup,"");
         if(this.crewData.master_id == Character.char_id || this.crewData.elder_id == Character.char_id)
         {
            this.eventHandler.addListener(this.panelMC.KushiDangoBtn,MouseEvent.CLICK,this.upgradeBuildingHandler);
            this.eventHandler.addListener(this.panelMC.teahouseBtn,MouseEvent.CLICK,this.upgradeBuildingHandler);
            this.eventHandler.addListener(this.panelMC.bathhouseBtn,MouseEvent.CLICK,this.upgradeBuildingHandler);
            this.eventHandler.addListener(this.panelMC.trainingBtn,MouseEvent.CLICK,this.upgradeBuildingHandler);
         }
      }
      
      private function upgradeBuildingHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         this.upgradeName = this.buildingData[_loc2_].upgradeId;
         this.panelMC.buildingUpgradeMc.gotoAndStop(_loc2_);
         this.panelMC.buildingUpgradeMc.panelMc.lbl_name.text = this.buildingData[_loc2_].name;
         this.eventHandler.addListener(this.panelMC.buildingUpgradeMc.panelMc.closeBtn,MouseEvent.CLICK,this.closeUpgradeBuilding);
         this.eventHandler.addListener(this.panelMC.buildingUpgradeMc.panelMc.upgradeBtn,MouseEvent.CLICK,this.onUpgrade);
         if(this.getBuildingLevel(_loc2_) > 2)
         {
            this.panelMC.buildingUpgradeMc.panelMc.curLevelTxt.text = "Current Level " + this.getBuildingLevel(_loc2_);
            this.panelMC.buildingUpgradeMc.panelMc.nextLevelTxt.text = "Next Level " + int(this.getBuildingLevel(_loc2_));
            this.panelMC.buildingUpgradeMc.panelMc.curFunctionTxt.text = "+" + this.buildingData[_loc2_].amount[int(this.getBuildingLevel(_loc2_))] + this.buildingData[_loc2_].description;
            this.panelMC.buildingUpgradeMc.panelMc.nextFunctionTxt.text = "+" + this.buildingData[_loc2_].amount[int(this.getBuildingLevel(_loc2_))] + this.buildingData[_loc2_].description;
            this.panelMC.buildingUpgradeMc.panelMc.curBuildingMc.gotoAndStop("level_" + int(this.getBuildingLevel(_loc2_)));
            this.panelMC.buildingUpgradeMc.panelMc.nextBuildingMc.gotoAndStop("level_" + int(this.getBuildingLevel(_loc2_)));
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCostTxt_Token.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCost_Token.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeTxt_Token.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.icon_Token.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCostTxt_Gold.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCost_Gold.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeTxt_Gold.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.icon_Gold.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeBtn.visible = false;
            return;
         }
         this.panelMC.buildingUpgradeMc.panelMc.curLevelTxt.text = "Current Level " + this.getBuildingLevel(_loc2_);
         this.panelMC.buildingUpgradeMc.panelMc.nextLevelTxt.text = "Next Level " + int(this.getBuildingLevel(_loc2_) + 1);
         this.panelMC.buildingUpgradeMc.panelMc.curFunctionTxt.text = "+" + this.buildingData[_loc2_].amount[int(this.getBuildingLevel(_loc2_))] + this.buildingData[_loc2_].description;
         this.panelMC.buildingUpgradeMc.panelMc.nextFunctionTxt.text = "+" + this.buildingData[_loc2_].amount[int(this.getBuildingLevel(_loc2_) + 1)] + this.buildingData[_loc2_].description;
         this.panelMC.buildingUpgradeMc.panelMc.curBuildingMc.gotoAndStop("level_" + int(this.getBuildingLevel(_loc2_)));
         this.panelMC.buildingUpgradeMc.panelMc.nextBuildingMc.gotoAndStop("level_" + int(this.getBuildingLevel(_loc2_) + 1));
         if(this.getBuildingLevel(_loc2_) < 2)
         {
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCostTxt_Token.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCost_Token.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeTxt_Token.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.icon_Token.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCostTxt_Gold.text = "Uprade Cost";
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCost_Gold.text = this.buildingData[_loc2_].price[int(this.getBuildingLevel(_loc2_) + 1)];
            this.panelMC.buildingUpgradeMc.panelMc.upgradeTxt_Gold.text = "Crew Gold";
         }
         else
         {
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCostTxt_Gold.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCost_Gold.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeTxt_Gold.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.icon_Gold.visible = false;
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCostTxt_Token.text = "Uprade Cost";
            this.panelMC.buildingUpgradeMc.panelMc.upgradeCost_Token.text = this.buildingData[_loc2_].price[int(this.getBuildingLevel(_loc2_) + 1)];
            this.panelMC.buildingUpgradeMc.panelMc.upgradeTxt_Token.text = "Crew Token";
         }
      }
      
      private function onUpgrade(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.upgradeBuilding(this.upgradeName,this.onUpgradeRes);
      }
      
      private function onUpgradeRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 == null && param2 == null)
         {
            Crew.instance.getCrewData(this.onGetCrewResNew);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getNotice("Unable to upgrade building.\nPlease try again later");
         }
      }
      
      private function onMiniGameRes(param1:* = null, param2:* = null) : *
      {
         if(this.destroyed)
         {
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("energy")))
         {
            this.panelMC.miniGameBtn.txt.text = "Mini Game: x" + param1.energy;
         }
      }
      
      private function onGetCrewResNew(param1:*, param2:* = null) : *
      {
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("crew")) && Boolean(param1.hasOwnProperty("char")) && this.crewData != null)
         {
            this.crewData = param1.crew;
            Character.crew_data = param1.crew;
            Character.crew_char_data = param1.char;
            this.initUI();
         }
      }
      
      private function closeUpgradeBuilding(param1:MouseEvent) : void
      {
         this.panelMC.buildingUpgradeMc.gotoAndStop("idle");
      }
      
      public function getBuildingLevel(param1:String) : int
      {
         switch(param1)
         {
            case "KushiDangoBtn":
               return this.crewData.kushi_dango;
            case "teahouseBtn":
               return this.crewData.tea_house;
            case "bathhouseBtn":
               return this.crewData.bath_house;
            case "trainingBtn":
               return this.crewData.training_centre;
            default:
               return -1;
         }
      }
      
      private function openStaminaPopup(param1:MouseEvent) : void
      {
         this.panelMC.stamin_panel.gotoAndStop("show");
         this.eventHandler.addListener(this.panelMC.stamin_panel.panelMc.closeBtn,MouseEvent.CLICK,this.closeStaminaPopup);
         this.eventHandler.addListener(this.panelMC.stamin_panel.panelMc.btn_restore,MouseEvent.CLICK,this.onRestoreStamina);
         this.eventHandler.addListener(this.panelMC.stamin_panel.panelMc.btn_upgrade,MouseEvent.CLICK,this.onUpgradeMaxStamina);
         this.panelMC.stamin_panel.panelMc.roll_num.text = Character.getMaterialAmount(this.GOLDEN_ONIGIRI);
         this.panelMC.stamin_panel.panelMc.txt_stamina_cur.text = this.charData.stamina + "/" + this.charData.max_stamina;
         this.panelMC.stamin_panel.panelMc.staminaBar.scaleX = this.charData.stamina / this.charData.max_stamina * 1.63;
         this.panelMC.stamin_panel.panelMc.txt_upgrade_maxsta_cost.text = this.UPGRADE_PRICE_TOKEN;
         if(this.charData.max_stamina < this.MAX_STAMINA)
         {
            this.panelMC.stamin_panel.panelMc.txt_maxsta_cur.text = this.charData.max_stamina;
            this.panelMC.stamin_panel.panelMc.txt_maxsta_upgradeto.text = int(this.charData.max_stamina + this.UPGRADE_STAMINA_AMOUNT);
         }
         else
         {
            this.panelMC.stamin_panel.panelMc.txt_maxsta_cur.text = this.charData.max_stamina;
            this.panelMC.stamin_panel.panelMc.txt_maxsta_upgradeto.text = this.MAX_STAMINA;
            this.panelMC.stamin_panel.panelMc.btn_upgrade.visible = false;
         }
         this.checkRestoreTokenOrOnigiri();
      }
      
      private function checkRestoreTokenOrOnigiri() : void
      {
         var _loc1_:int = Character.getMaterialAmount(this.GOLDEN_ONIGIRI);
         this.panelMC.stamin_panel.panelMc.roll_num.text = _loc1_;
         this.panelMC.stamin_panel.panelMc.btn_upgrade.visible = _loc1_ > 0 || Character.account_tokens >= this.REFILL_PRICE_TOKEN ? true : false;
         if(_loc1_ > 0)
         {
            this.panelMC.stamin_panel.panelMc.icon_Token.visible = false;
            this.panelMC.stamin_panel.panelMc.txt_restore_sta_cost.visible = false;
            this.panelMC.stamin_panel.panelMc.RollIcon.visible = true;
            this.panelMC.stamin_panel.panelMc.txt_restore_sta_cost_roll.visible = true;
            this.panelMC.stamin_panel.panelMc.txt_restore_sta_cost_roll.text = this.REFILL_PRICE_GOLDEN_ONIGIRI;
         }
         else
         {
            this.panelMC.stamin_panel.panelMc.icon_Token.visible = true;
            this.panelMC.stamin_panel.panelMc.txt_restore_sta_cost.visible = true;
            this.panelMC.stamin_panel.panelMc.RollIcon.visible = false;
            this.panelMC.stamin_panel.panelMc.txt_restore_sta_cost_roll.visible = false;
            this.panelMC.stamin_panel.panelMc.txt_restore_sta_cost.text = this.REFILL_PRICE_TOKEN;
         }
      }
      
      private function onRestoreStamina(param1:MouseEvent) : void
      {
         this.confirmation = null;
         this.confirmation = new Confirmation();
         var _loc2_:int = Character.getMaterialAmount(this.GOLDEN_ONIGIRI);
         this.restoreType = _loc2_ > 0 ? "rolls" : "tokens";
         var _loc3_:String = _loc2_ > 0 ? this.REFILL_PRICE_GOLDEN_ONIGIRI + " Roll?" : this.REFILL_PRICE_TOKEN + " Tokens?";
         this.confirmation.txtMc.txt.text = "Are you sure that you want to restore " + this.REFILL_STAMINA_AMOUNT + " Stamina with " + _loc3_;
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onRestoreStaminaConf);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function removeConfirmation(param1:MouseEvent) : *
      {
         if(!this.confirmation)
         {
            return;
         }
         this.eventHandler.removeListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onRestoreStaminaConf);
         this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onUpgradeMaxStaminaConf);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
      }
      
      private function onRestoreStaminaConf(param1:MouseEvent) : void
      {
         Crew.instance.restoreStamina(this.onRestoreStaminaRes);
      }
      
      private function onRestoreStaminaRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if("status" in param1 && param1.status == "ok" && "data" in param1)
         {
            if(param1.data.currency_type == 2)
            {
               Character.replaceMaterials(this.GOLDEN_ONIGIRI,param1.data.currency_remaining);
               this.main.showMessage("+" + param1.data.restored_stamina + " stamina refilled using " + param1.data.currency_used + " Golden Stamina Roll");
            }
            else if(param1.data.currency_type == 1)
            {
               Character.account_tokens = param1.data.currency_remaining;
               this.main.showMessage("+" + param1.data.restored_stamina + " stamina refilled using " + param1.data.currency_used + " tokens");
            }
            else
            {
               this.main.showMessage("Stamina is full");
            }
            this.openStaminaPopup(null);
            this.refreshStamina();
            return;
         }
         if(param2 != null)
         {
            this.main.getNotice("Unable to restore stamina.\nPlease try again later");
         }
      }
      
      private function onUpgradeMaxStamina(param1:MouseEvent) : void
      {
         this.confirmation = null;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to increase your max stamina for " + this.UPGRADE_STAMINA_AMOUNT + " with " + this.UPGRADE_PRICE_TOKEN + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onUpgradeMaxStaminaConf);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function onUpgradeMaxStaminaConf(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.upgradeMaxStamina(this.onUpgradeStaminaRes);
      }
      
      private function onUpgradeStaminaRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getNotice("Unable to upgrade stamina.");
            return;
         }
         if("status" in param1 && param1.status == "ok")
         {
            Character.account_tokens -= this.UPGRADE_PRICE_TOKEN;
            this.refreshStamina();
         }
      }
      
      private function refreshStamina() : *
      {
         Crew.instance.getStamina(this.onRefreshStamina);
      }
      
      private function onRefreshStamina(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && Boolean(param1.hasOwnProperty("char")))
         {
            Character.crew_char_data = param1.char;
            this.charData = param1.char;
            this.openStaminaPopup(null);
            this.initStatusDisplay();
            this.main.HUD.setBasicData();
            GF.removeAllChild(this.confirmation);
            this.removeConfirmation(null);
            return;
         }
         if(param2 != null)
         {
            this.main.showMessage("Error refreshing data");
         }
         GF.removeAllChild(this.confirmation);
         this.removeConfirmation(null);
      }
      
      private function closeStaminaPopup(param1:MouseEvent) : void
      {
         this.panelMC.stamin_panel.gotoAndStop("idle");
      }
      
      private function openMinigamePopup(param1:MouseEvent) : void
      {
         this.panelMC.popupdefendside.gotoAndStop("show");
         NinjaSage.loadItemIcon(this.panelMC.popupdefendside.panelMC.IconMc_0,this.minigameRewardData[0]);
         NinjaSage.loadItemIcon(this.panelMC.popupdefendside.panelMC.IconMc_1,this.minigameRewardData[1]);
         this.eventHandler.addListener(this.panelMC.popupdefendside.panelMC.closeBtn,MouseEvent.CLICK,this.closeMinigamePopup);
         this.eventHandler.addListener(this.panelMC.popupdefendside.panelMC.claimBtn,MouseEvent.CLICK,this.startMiniGame);
      }
      
      private function startMiniGame(param1:MouseEvent) : void
      {
         var _loc2_:* = this.loaderSwf.add("swfpanels/CrewMiniGame.swf");
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.onCrewMiniGameLoaded);
         this.loaderSwf.start();
         this.closeMinigamePopup(null);
      }
      
      private function onCrewMiniGameLoaded(param1:Event) : *
      {
         this.loaderSwf.removeEventListener(BulkLoader.COMPLETE,this.onCrewMiniGameLoaded);
         var _loc2_:Class = getDefinitionByName("id.ninjasage.features.CrewMiniGame") as Class;
         var _loc3_:MovieClip = param1.target.content;
         var _loc4_:* = new _loc2_(this,_loc3_);
         this.main.loader.addChild(_loc3_);
      }
      
      private function closeMinigamePopup(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.panelMC.popupdefendside.panelMC.IconMc_0.rewardIcon.iconHolder);
         GF.removeAllChild(this.panelMC.popupdefendside.panelMC.IconMc_0.skillIcon.iconHolder);
         GF.removeAllChild(this.panelMC.popupdefendside.panelMC.IconMc_1.rewardIcon.iconHolder);
         GF.removeAllChild(this.panelMC.popupdefendside.panelMC.IconMc_1.skillIcon.iconHolder);
         this.eventHandler.removeListener(this.panelMC.popupdefendside.panelMC.closeBtn,MouseEvent.CLICK,this.closeMinigamePopup);
         this.eventHandler.removeListener(this.panelMC.popupdefendside.panelMC.claimBtn,MouseEvent.CLICK,this.closeMinigamePopup);
         this.panelMC.popupdefendside.gotoAndStop("idle");
      }
      
      public function initStatusDisplay() : void
      {
         this.panelMC.clanStatusMc.nameTxt.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.panelMC.clanStatusMc.nameTxt);
         this.panelMC.clanStatusMc.lbl_level.text = "Level";
         this.panelMC.clanStatusMc.levelTxt.text = Character.character_lvl;
         this.panelMC.clanStatusMc.goldTxt.text = Character.character_gold;
         this.panelMC.clanStatusMc.tokenTxt.text = Character.account_tokens;
         this.panelMC.clanStatusMc.hpTxt.text = StatManager.calculate_stats_with_data("hp") + "/" + StatManager.calculate_stats_with_data("hp");
         this.panelMC.clanStatusMc.cpTxt.text = StatManager.calculate_stats_with_data("cp") + "/" + StatManager.calculate_stats_with_data("cp");
         this.panelMC.clanStatusMc.staminaTxt.text = this.charData.stamina + "/" + this.charData.max_stamina;
         this.panelMC.clanStatusMc.staminaBar.scaleX = this.charData.stamina / this.charData.max_stamina;
         this.panelMC.clanStatusMc.meritTxt.text = this.charData.merit || 0;
         this.panelMC.clanStatusMc.rollTxt.text = Character.getMaterialAmount(this.GOLDEN_ONIGIRI);
         this.panelMC.clanStatusMc.tickTxt.text = "+" + int(30 + this.crewData.kushi_dango * 10) + "/30 min";
         this.panelMC.clanStatusMc.clanNameTxt.text = this.crewData.name;
         this.panelMC.clanStatusMc.lbl_member.text = "Member";
         this.panelMC.clanStatusMc.memberSlotTxt.text = this.crewData.members + " / " + this.crewData.max_members;
         this.panelMC.clanStatusMc.clanGoldTxt.text = this.crewData.golds;
         this.panelMC.clanStatusMc.clanTokenTxt.text = this.crewData.tokens;
         this.panelMC.clanStatusMc.phaselbl.text = "Phase " + Crew.instance.getPhase();
      }
      
      public function initPlayerHead() : void
      {
         var _loc1_:MovieClip = this.main.getPlayerHead();
         GF.removeAllChild(this.panelMC.clanStatusMc.headHolder);
         this.panelMC.clanStatusMc.headHolder.addChild(_loc1_);
      }
      
      private function showRewardDamageRank(param1:MouseEvent) : void
      {
         this.panelMC.detailMC.gotoAndStop("damageRank");
         var _loc2_:MovieClip = this.panelMC.detailMC.panelMC;
         var _loc3_:Array = ["1","2","3","4","5","6-10"];
         var _loc4_:Array = ["lbl_first_prize_1","lbl_secon_1","lbl_third_1","lbl_forth_1","lbl_5th_1","lbl_6th_1"];
         var _loc5_:Array = ["lbl_first_prize_2","lbl_second_2","lbl_third_2","lbl_forth_2","lbl_5th_2","lbl_6th_2"];
         var _loc6_:int = 0;
         while(_loc6_ < 6)
         {
            _loc2_[_loc4_[_loc6_]].text = this.tokenPoolData[_loc3_[_loc6_]].token + "% of token pool";
            _loc2_[_loc5_[_loc6_]].text = Util.formatNumberWithDot(this.tokenPoolData[_loc3_[_loc6_]].merit) + " Merit";
            _loc6_++;
         }
         _loc2_.lbl_date.text = "Total Token Pool: 0 + " + this.tokenPoolData.base;
         Crew.instance.getTokenPool(this.onTokenPoolRes);
         this.eventHandler.addListener(this.panelMC.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.addListener(this.panelMC.detailMC.panelMC.nextBtn,MouseEvent.CLICK,this.showRewardDamageBonus);
      }
      
      private function onTokenPoolRes(param1:Object, param2:* = null) : void
      {
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("t"))
         {
            this.panelMC.detailMC.panelMC.lbl_date.text = "Total Token Pool: " + param1.t + " + " + this.tokenPoolData.base;
            return;
         }
      }
      
      private function showRewardDamageBonus(param1:MouseEvent) : void
      {
         this.panelMC.detailMC.gotoAndStop("damageBonus");
         this.eventHandler.addListener(this.panelMC.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.addListener(this.panelMC.detailMC.panelMC.prevBtn,MouseEvent.CLICK,this.showRewardDamageRank);
         var _loc2_:int = 0;
         while(_loc2_ < this.rewardData.phase_1.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.detailMC.panelMC["IconMc0_" + _loc2_],this.rewardData.phase_1[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.rewardData.phase_2.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.detailMC.panelMC["IconMc_" + _loc2_],this.rewardData.phase_2[_loc2_]);
            _loc2_++;
         }
      }
      
      private function closeRewards(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.panelMC.detailMC.currentLabel == "damageBonus")
         {
            _loc2_ = 0;
            while(_loc2_ < this.rewardData.phase_1.length)
            {
               GF.removeAllChild(this.panelMC.detailMC.panelMC["IconMc0_" + _loc2_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.detailMC.panelMC["IconMc0_" + _loc2_].skillIcon.iconHolder);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.rewardData.phase_2.length)
            {
               GF.removeAllChild(this.panelMC.detailMC.panelMC["IconMc_" + _loc2_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.detailMC.panelMC["IconMc_" + _loc2_].skillIcon.iconHolder);
               _loc2_++;
            }
         }
         this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.prevBtn,MouseEvent.CLICK,this.showRewardDamageRank);
         this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.nextBtn,MouseEvent.CLICK,this.showRewardDamageBonus);
         this.panelMC.detailMC.gotoAndStop("idle");
      }
      
      public function updateTimeleft() : void
      {
         if(this.timeout)
         {
            clearTimeout(this.timeout);
            this.timeout = null;
         }
         if(this.destroyed)
         {
            if(this.timeout)
            {
               clearTimeout(this.timeout);
            }
            this.timeout = null;
            return;
         }
         if(this.crewTimestamp == null)
         {
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:int = this.crewTimestamp;
         var _loc5_:int = Math.floor(_loc4_ / _loc1_);
         var _loc6_:int = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         var _loc7_:int = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         if(_loc7_ >= 30)
         {
            this.panelMC.clanStatusMc.timer_StaRecover.gotoAndStop(60 - _loc7_);
         }
         else
         {
            this.panelMC.clanStatusMc.timer_StaRecover.gotoAndStop(30 - _loc7_);
         }
         this.panelMC.clanStatusMc.dayTxt.text = _loc5_;
         this.panelMC.clanStatusMc.hourTxt.text = _loc6_;
         this.panelMC.clanStatusMc.minTxt.text = _loc7_;
         this.crewTimestamp -= 10;
         Crew.instance.getStamina(this.onGetStamina);
      }
      
      public function onGetStamina(param1:Object, param2:* = null) : void
      {
         if(this.timeout)
         {
            clearTimeout(this.timeout);
            this.timeout = null;
         }
         if(param1 != null && param1.hasOwnProperty("char"))
         {
            Character.crew_char_data = param1.char;
            this.charData = param1.char;
            this.crewTimestamp = param1.season.timestamp;
            this.panelMC.clanStatusMc.staminaTxt.text = this.charData.stamina + "/" + this.charData.max_stamina;
            this.panelMC.clanStatusMc.staminaBar.scaleX = this.charData.stamina / this.charData.max_stamina;
            this.timeout = setTimeout(this.updateTimeleft,10000);
         }
         if(param1 != null && param1.hasOwnProperty("season") && param1.season != null)
         {
            Crew.instance.setPhase(param1.season.phase);
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            this.destroy();
         }
         if(param2 != null)
         {
            this.main.showMessage("Unable to get stamina data");
            this.destroy();
            return;
         }
      }
      
      private function openCrewBattle(param1:MouseEvent) : void
      {
         this.loaderSwf.add("swfpanels/CrewBattle.swf",{"id":"CrewBattle"});
         this.loaderSwf.addEventListener(BulkLoader.COMPLETE,this.onCrewBattleLoaded);
         this.loaderSwf.start();
      }
      
      private function onCrewBattleLoaded(param1:Event) : *
      {
         this.loaderSwf.removeEventListener(BulkLoader.COMPLETE,this.onCrewBattleLoaded);
         var _loc2_:MovieClip = this.loaderSwf.getContent("CrewBattle");
         var _loc3_:Class = getDefinitionByName("id.ninjasage.features.CrewBattle") as Class;
         var _loc4_:MovieClip = new _loc3_(this,_loc2_,this.crewTimestamp);
         this.main.loader.addChild(_loc2_.panelMC);
         this.loaderSwf.removeAll();
         if(this.timeout)
         {
            clearTimeout(this.timeout);
            this.timeout = null;
         }
      }
      
      private function openCrewHall(param1:MouseEvent) : void
      {
         this.loaderSwf.add("swfpanels/CrewHall.swf",{"id":"CrewHall"});
         this.loaderSwf.addEventListener(BulkLoader.COMPLETE,this.onCrewHallLoaded);
         this.loaderSwf.start();
      }
      
      private function onCrewHallLoaded(param1:Event) : *
      {
         this.loaderSwf.removeEventListener(BulkLoader.COMPLETE,this.onCrewHallLoaded);
         var _loc2_:MovieClip = this.loaderSwf.getContent("CrewHall");
         var _loc3_:Class = getDefinitionByName("id.ninjasage.features.CrewHall") as Class;
         var _loc4_:MovieClip = new _loc3_(this,_loc2_);
         this.main.loader.addChild(_loc2_.panelMC);
         this.loaderSwf.removeAll();
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openCrewShop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.CrewShop");
      }
      
      private function openCrewLeaderboard(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("http://127.0.0.1:800/en/leaderboards/crew"));
      }
      
      private function closePanel(param1:MouseEvent) : void
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
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         Log.debug(this,"DESTROY");
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         Crew.instance.destroy();
         this.timeout = null;
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.loaderSwf.clear();
         this.main.handleVillageHUDVisibility(true);
         this.main = null;
         this.eventHandler = null;
         this.rewardData = null;
         this.loaderSwf = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}

