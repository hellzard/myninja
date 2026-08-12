package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.AppManager;
   import Managers.NinjaSage;
   import Managers.StatManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.GameData;
   import br.com.stimuli.loading.BulkLoader;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import id.ninjasage.Crew;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class CrewBattle extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var loaderSwf:BulkLoader;
      
      private var confirmation:Confirmation;
      
      private var crewTimestamp;
      
      private var crewData:Object;
      
      private var crewVillage:CrewVillage;
      
      private var charData:Object;
      
      private var bossData:Array;
      
      private var castles;
      
      private var castleName:Array;
      
      private var recruitData:Array;
      
      private var rankingData:Array;
      
      private var defendingData:Array;
      
      private var recruitedFriend:Array;
      
      private var seasonRewardData:Object;
      
      private var selectedCastle:int = -1;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var role:int;
      
      private var RECOVER_PRICE_TOKEN:int = 50;
      
      private var RECOVER_LIFE_TOKEN:int = 100;
      
      private var RECOVER_PRICE_GOURD:int = 1;
      
      private var RECOVER_LIFE_GOURD:int = 50;
      
      private var RECOVER_LIFE_FREE:int;
      
      private var selectedEnemyIndex:int;
      
      private var notificationText:String;
      
      private const notifPosX:int = 1366;
      
      private var init = false;
      
      private var destroyed = false;
      
      private var timeoutGetCastle = null;
      
      private var n = null;
      
      public function CrewBattle(param1:*, param2:*, param3:*)
      {
         this.castles = {};
         this.recruitedFriend = [];
         var _loc4_:Object = GameData.get("crew");
         this.castleName = _loc4_.castle;
         this.bossData = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.boss.length)
         {
            this.bossData.push({
               "bossId":_loc4_.boss[_loc5_].id,
               "bossName":_loc4_.boss[_loc5_].name,
               "bossDescription":_loc4_.boss[_loc5_].description,
               "bossLevel":[int(Character.character_lvl) + _loc4_.boss[_loc5_].levels[0],int(Character.character_lvl) + _loc4_.boss[_loc5_].levels[1]],
               "battleBackground":_loc4_.boss[_loc5_].background
            });
            _loc5_++;
         }
         super();
         this.main = AppManager.getInstance().main;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.crewVillage = param1;
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(10);
         this.eventHandler = new EventHandler();
         this.crewData = Character.crew_data;
         this.charData = Character.crew_char_data;
         this.crewTimestamp = param3;
         this.role = this.charData.role;
         this.RECOVER_LIFE_FREE = this.crewVillage.buildingData["KushiDangoBtn"].amount[int(this.crewVillage.getBuildingLevel("KushiDangoBtn"))];
         this.crewVillage.panelMC.visible = false;
         this.initButton();
         this.initUI();
      }
      
      private function initUI() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            this.panelMC["clan_btn_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         this.panelMC.popuploading.addFrameScript(8,this.hideObjectDuringAnimation,92,this.sendBattlePhaseTwo,102,this.closeBattleAnimation);
         this.panelMC.popupNotification.x = 2000;
         this.hidePopup();
         this.updateRoleIcon();
         this.updateTimeleft();
         this.initStatusDisplay();
         this.initPlayerHead();
         this.getMiniGameData();
      }
      
      private function hidePopup() : void
      {
         this.panelMC.popupMiniGame.gotoAndStop("idle");
         this.panelMC.popuploading.gotoAndStop("idle");
         this.panelMC.popupResult.gotoAndStop("idle");
         this.panelMC.lastpopupRewardHome.gotoAndStop("idle");
         this.panelMC.popupattackside.gotoAndStop("idle");
         this.panelMC.stamin_panel.gotoAndStop("idle");
         this.panelMC.popupRewardHome.gotoAndStop("idle");
         this.panelMC.popupattacksideph2.gotoAndStop("idle");
         this.panelMC.popupdefendside.gotoAndStop("idle");
         this.panelMC.status.gotoAndStop(1);
      }
      
      private function onInitCastle(param1:* = null, param2:* = null) : void
      {
         if(this.destroyed)
         {
            return;
         }
         this.onCastleData(param1,param2);
         this.updateCastleOwner();
      }
      
      private function onCastleData(param1:* = null, param2:* = null) : *
      {
         var _loc3_:* = undefined;
         if(param1 != null && param1.hasOwnProperty("castles") && param1.castles != null)
         {
            if(this.timeoutGetCastle != null)
            {
               clearTimeout(this.timeoutGetCastle);
            }
            this.timeoutGetCastle = null;
            this.castles = param1.castles;
            if(Crew.instance.getPhase() == 2 && (this.panelMC.popupattacksideph2.currentLabel == "show" || this.panelMC.popupdefendside.currentLabel == "show"))
            {
               this.renderCastleInfo(this.panelMC.popupattacksideph2.panel);
               this.renderCastleInfo(this.panelMC.popupdefendside.panel);
            }
            this.notificationText = param1.a;
            this.updateNotification();
         }
         else if(!this.init && !this.timeoutGetCastle && param1 != null && param1.hasOwnProperty("code") && param1.code == 429)
         {
            this.timeoutGetCastle = setTimeout(Crew.instance.getCastles,500,this.onInitCastle);
            this.init = true;
         }
         this.myCastleDummy = "a";
      }
      
      public function getMiniGameData() : *
      {
         Crew.instance.getMiniGame(this.onMiniGameRes);
      }
      
      private function onMiniGameRes(param1:* = null, param2:* = null) : *
      {
         if(param1 != null && Boolean(param1.hasOwnProperty("energy")))
         {
            this.panelMC.miniGameBtn.txt.text = "Mini Game: x" + param1.energy;
         }
      }
      
      private function updateRoleIcon() : void
      {
         var _loc1_:* = undefined;
         this.panelMC.status.gotoAndStop(this.role);
         try
         {
            if(this.charData.role_limit_at != "")
            {
               _loc1_ = this.panelMC.popupdefendside.panel;
               _loc1_.timer.visible = true;
               _loc1_.timer.timeTxt.text = this.charData.role_limit_at;
               _loc1_.AttackerToDefBtn.change.gotoAndStop(this.role);
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function updateCastleOwner() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = this.castles.hasOwnProperty(_loc1_);
            _loc3_ = !!_loc2_ ? this.castles[_loc1_].owner_name : "";
            _loc4_ = this.panelMC["clan_btn_" + _loc1_];
            this.panelMC["name_" + _loc1_].text = !!_loc2_ ? this.castles[_loc1_].name : this.castleName[_loc1_];
            this.main.removeButtonListener(_loc4_,this.checkBattlePopup,_loc3_);
            this.main.initButton(_loc4_,this.checkBattlePopup,_loc3_);
            _loc1_++;
         }
      }
      
      private function updateNotification() : void
      {
         if(this.notificationText != "")
         {
            if(this.panelMC.popupNotification.x != this.notifPosX)
            {
               TweenLite.to(this.panelMC.popupNotification,1.2,{
                  "x":this.notifPosX,
                  "ease":"easeOutBack"
               });
            }
            this.eventHandler.addListener(this.panelMC.popupNotification,MouseEvent.CLICK,this.closeNotification);
            this.panelMC.popupNotification.txt.htmlText = this.notificationText;
         }
         else
         {
            this.panelMC.popupNotification.x = 2000;
         }
      }
      
      private function closeNotification(param1:MouseEvent) : void
      {
         this.eventHandler.removeListener(this.panelMC.popupNotification.closeBtn,MouseEvent.CLICK,this.closeNotification);
         TweenLite.to(this.panelMC.popupNotification,1.2,{
            "x":2000,
            "ease":"easeOutBack"
         });
      }
      
      private function initButton() : void
      {
         this.eventHandler.addListener(this.panelMC.backBtn,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.rewardListHomeBtn,MouseEvent.CLICK,this.openRewardListHome);
         this.eventHandler.addListener(this.panelMC.btn_buystamina,MouseEvent.CLICK,this.openStaminaPopup);
         this.eventHandler.addListener(this.panelMC.lastseasonrewardBtn,MouseEvent.CLICK,this.openLastSeasonReward);
         this.main.initButton(this.panelMC.miniGameBtn,this.openMinigamePopup,"");
      }
      
      private function openStaminaPopup(param1:MouseEvent) : void
      {
         this.panelMC.stamin_panel.gotoAndStop("show");
         this.eventHandler.addListener(this.panelMC.stamin_panel.panel.closeBtn,MouseEvent.CLICK,this.closeStaminaPopup);
         this.eventHandler.addListener(this.panelMC.stamin_panel.panel.btn_restore,MouseEvent.CLICK,this.onRestoreStamina);
         this.eventHandler.addListener(this.panelMC.stamin_panel.panel.btn_upgrade,MouseEvent.CLICK,this.onUpgradeMaxStamina);
         this.panelMC.stamin_panel.panel.roll_num.text = Character.getMaterialAmount(this.crewVillage.GOLDEN_ONIGIRI);
         this.panelMC.stamin_panel.panel.txt_stamina_cur.text = this.charData.stamina + "/" + this.charData.max_stamina;
         this.panelMC.stamin_panel.panel.staminaBar.scaleX = this.charData.stamina / this.charData.max_stamina * 1.63;
         this.panelMC.stamin_panel.panel.txt_upgrade_maxsta_cost.text = this.crewVillage.UPGRADE_PRICE_TOKEN;
         if(this.charData.max_stamina < this.crewVillage.MAX_STAMINA)
         {
            this.panelMC.stamin_panel.panel.txt_maxsta_cur.text = this.charData.max_stamina;
            this.panelMC.stamin_panel.panel.txt_maxsta_upgradeto.text = int(this.charData.max_stamina + this.crewVillage.UPGRADE_STAMINA_AMOUNT);
         }
         else
         {
            this.panelMC.stamin_panel.panel.txt_maxsta_cur.text = this.charData.max_stamina;
            this.panelMC.stamin_panel.panel.txt_maxsta_upgradeto.text = this.crewVillage.MAX_STAMINA;
            this.panelMC.stamin_panel.panel.btn_upgrade.visible = false;
         }
         this.checkRestoreTokenOrOnigiri();
      }
      
      private function checkRestoreTokenOrOnigiri() : void
      {
         var _loc1_:int = Character.getMaterialAmount(this.crewVillage.GOLDEN_ONIGIRI);
         this.panelMC.stamin_panel.panel.roll_num.text = _loc1_;
         this.panelMC.stamin_panel.panel.btn_upgrade.visible = _loc1_ > 0 || Character.account_tokens >= this.crewVillage.REFILL_PRICE_TOKEN ? true : false;
         if(_loc1_ > 0)
         {
            this.panelMC.stamin_panel.panel.icon_Token.visible = false;
            this.panelMC.stamin_panel.panel.txt_restore_sta_cost.visible = false;
            this.panelMC.stamin_panel.panel.RollIcon.visible = true;
            this.panelMC.stamin_panel.panel.txt_restore_sta_cost_roll.visible = true;
            this.panelMC.stamin_panel.panel.txt_restore_sta_cost_roll.text = this.crewVillage.REFILL_PRICE_GOLDEN_ONIGIRI;
         }
         else
         {
            this.panelMC.stamin_panel.panel.icon_Token.visible = true;
            this.panelMC.stamin_panel.panel.txt_restore_sta_cost.visible = true;
            this.panelMC.stamin_panel.panel.RollIcon.visible = false;
            this.panelMC.stamin_panel.panel.txt_restore_sta_cost_roll.visible = false;
            this.panelMC.stamin_panel.panel.txt_restore_sta_cost.text = this.crewVillage.REFILL_PRICE_TOKEN;
         }
      }
      
      private function onRestoreStamina(param1:MouseEvent) : void
      {
         this.confirmation = null;
         this.confirmation = new Confirmation();
         var _loc2_:int = Character.getMaterialAmount(this.crewVillage.GOLDEN_ONIGIRI);
         this.restoreType = _loc2_ > 0 ? "rolls" : "tokens";
         var _loc3_:String = _loc2_ > 0 ? this.crewVillage.REFILL_PRICE_GOLDEN_ONIGIRI + " Roll?" : this.crewVillage.REFILL_PRICE_TOKEN + " Tokens?";
         this.confirmation.txtMc.txt.text = "Are you sure that you want to restore " + this.crewVillage.REFILL_STAMINA_AMOUNT + " Stamina with " + _loc3_;
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
            this.removeConfirmation(null);
            this.main.showMessage(param1.errorMessage);
            if(param1.code == 422)
            {
               this.closeStaminaPopup(null);
            }
            else if(param1.code == 402)
            {
               this.closeStaminaPopup(null);
               this.openRecharge(null);
            }
            else
            {
               this.main.getNotice(param1.errorMessage + "\nErr:" + param1.code);
            }
            return;
         }
         if("status" in param1 && param1.status == "ok")
         {
            if(param1.data.currency_type == 2)
            {
               Character.replaceMaterials(this.crewVillage.GOLDEN_ONIGIRI,param1.data.currency_remaining);
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
            this.main.getNotice("Unable to restore stamina");
         }
      }
      
      private function onUpgradeMaxStamina(param1:MouseEvent) : void
      {
         this.confirmation = null;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to increase your max stamina for " + this.crewVillage.UPGRADE_STAMINA_AMOUNT + " with " + this.crewVillage.UPGRADE_PRICE_TOKEN + " tokens?";
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
            this.main.getError("unknown");
            return;
         }
         if("status" in param1 && param1.status == "ok")
         {
            Character.account_tokens -= this.crewVillage.UPGRADE_PRICE_TOKEN;
            this.refreshStamina();
            this.crewVillage.refreshStamina();
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
            this.main.getError("Error");
            this.destroy();
         }
         GF.removeAllChild(this.confirmation);
         this.removeConfirmation(null);
      }
      
      private function closeStaminaPopup(param1:MouseEvent) : void
      {
         this.panelMC.stamin_panel.gotoAndStop("idle");
      }
      
      private function checkBattlePopup(param1:MouseEvent) : void
      {
         this.selectedCastle = param1.currentTarget.name.replace("clan_btn_","");
         if(Crew.instance.getPhase() == 1)
         {
            this.openPhaseOneBattle();
            return;
         }
         if(this.crewData.id == this.castles[this.selectedCastle].owner_id)
         {
            this.main.loading(true);
            Crew.instance.getDefenders(this.castles[this.selectedCastle].id,this.onGetDefendData);
         }
         else
         {
            this.openPhaseTwoBattle();
         }
      }
      
      private function openPhaseOneBattle() : void
      {
         this.panelMC.popupattackside.gotoAndStop("show");
         this.panelMC.popupattackside.panel.popupReward.gotoAndStop("idle");
         this.panelMC.popupattackside.panel.rankList.gotoAndStop("idle");
         this.panelMC.popupattackside.panel.bossDetail.gotoAndStop("idle");
         var _loc1_:* = this.selectedCastle;
         this.panelMC.popupattackside.panel.clanStatusMc.nameTxt.text = !!this.castles.hasOwnProperty(_loc1_) ? this.castles[_loc1_].name : "Castle";
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.closeBtn,MouseEvent.CLICK,this.closeBattlePopup);
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.fightBtn,MouseEvent.CLICK,this.openBossDetailPhaseOne);
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.rewardListBtn,MouseEvent.CLICK,this.openRewardCastle);
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.Btn_Rank,MouseEvent.CLICK,this.openRankingPhaseOne);
      }
      
      private function openBossDetailPhaseOne(param1:MouseEvent) : void
      {
         this.panelMC.popupattackside.panel.bossDetail.gotoAndStop("show");
         this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.gotoAndStop("idle");
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.closeBtn,MouseEvent.CLICK,this.closeBossDetailPhaseOne);
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.attackShowFdListBtn,MouseEvent.CLICK,this.openInviteCrewMemberPhaseOne);
         this.panelMC.popupattackside.panel.bossDetail.panel.detailMc.nameTxt.text = "Myterious Foe";
         this.panelMC.popupattackside.panel.bossDetail.panel.detailMc.lvMc.lvLow.txt.text = this.bossData[0].bossLevel[0];
         this.panelMC.popupattackside.panel.bossDetail.panel.detailMc.lvMc.lvHigh.txt.text = this.bossData[0].bossLevel[1];
         this.panelMC.popupattackside.panel.bossDetail.panel.detailMc.decTxt.text = "Different mysterious creatures will attack the castle that endangered the village.";
      }
      
      private function openInviteCrewMemberPhaseOne(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.getAttackers(this.onRecruitDataRes);
         this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.gotoAndStop("show");
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.panel.backPageBtn,MouseEvent.CLICK,this.closeInviteMemberRecruit);
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.panel.battleBtn,MouseEvent.CLICK,this.startPhaseOneBattle);
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.panel.prevPageBtn,MouseEvent.CLICK,this.changePageRecruit);
         this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.panel.nextPageBtn,MouseEvent.CLICK,this.changePageRecruit);
      }
      
      private function startPhaseOneBattle(param1:MouseEvent) : void
      {
         var _loc2_:int = NumberUtil.randomInt(0,this.bossData.length - 1);
         this.selectedEnemyIndex = _loc2_;
         var _loc3_:String = this.bossData[this.selectedEnemyIndex].bossId[0];
         var _loc4_:*;
         (_loc4_ = {
            "b":NinjaSage.generateRandomString(22),
            "c":int(this.selectedCastle) + 1,
            "t":new Date().time,
            "f":this.recruitedFriend,
            "e":_loc3_
         }).h = Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([Character.char_id,_loc4_.b,_loc4_.t,_loc4_.c,_loc4_.e].join("|")))));
         Crew.instance.startBattle(_loc4_,this.startBattleResponse);
      }
      
      private function startBattleResponse(param1:Object = null, param2:* = null) : void
      {
         var _loc3_:int = 0;
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("c"))
         {
            Character.mission_id = this.bossData[this.selectedEnemyIndex].battleBackground;
            Character.is_crew_war = true;
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.CREW_MATCH,Character.mission_id);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            Crew.instance.setBattleData(param1);
            Crew.instance.delayDestroy(true);
            if(!param1.hasOwnProperty("f") || param1.f == null)
            {
               param1.f = [];
            }
            this.recruitedFriend = param1.f;
            Character.temp_recruit_ids = [];
            _loc3_ = 0;
            while(_loc3_ < param1.f.length)
            {
               Character.temp_recruit_ids.push("char_" + this.recruitedFriend[_loc3_]);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.bossData[this.selectedEnemyIndex].bossId.length)
            {
               BattleManager.addPlayerToTeam("enemy",this.bossData[this.selectedEnemyIndex].bossId[_loc3_]);
               _loc3_++;
            }
            BattleManager.startBattle();
            this.crewVillage.destroy();
            this.destroy();
         }
      }
      
      private function closeBossDetailPhaseOne(param1:MouseEvent) : void
      {
         this.panelMC.popupattackside.panel.bossDetail.gotoAndStop("idle");
      }
      
      private function openPhaseTwoBattle() : void
      {
         this.panelMC.popupattacksideph2.gotoAndStop("show");
         this.panelMC.popupattacksideph2.panel.popupReward.gotoAndStop("idle");
         this.panelMC.popupattacksideph2.panel.popupWarList.gotoAndStop("idle");
         var _loc1_:MovieClip = this.panelMC.popupattacksideph2.panel;
         this.renderCastleInfo(_loc1_);
         this.refreshCastle();
         _loc1_.Btn_Rank.visible = false;
         _loc1_.clanStatusMc.castleNameTxt.text = this.castleName[this.selectedCastle];
         if(this.role == 1)
         {
            _loc1_.phase2fightBtn.visible = false;
         }
         _loc1_.skipMC.tick.visible = Crew.instance.getSkipAnimation();
         this.eventHandler.addListener(_loc1_.skipMC,MouseEvent.CLICK,this.onSkipAnimation);
         this.eventHandler.addListener(_loc1_.closeBtn,MouseEvent.CLICK,this.closeBattlePopup);
         this.eventHandler.addListener(_loc1_.phase2fightBtn,MouseEvent.CLICK,this.startAnimationPhaseTwo);
         this.eventHandler.addListener(_loc1_.refreshBtn,MouseEvent.CLICK,this.refreshCastle);
         this.eventHandler.addListener(_loc1_.rewardListBtn,MouseEvent.CLICK,this.openRewardCastle);
      }
      
      private function onSkipAnimation(param1:MouseEvent) : void
      {
         Crew.instance.setSkipAnimation(!Crew.instance.getSkipAnimation());
         this.panelMC.popupattacksideph2.panel.skipMC.tick.visible = Crew.instance.getSkipAnimation();
      }
      
      private function refreshCastle(param1:MouseEvent = null) : void
      {
         Crew.instance.getCastles(this.onRefreshCastle,this.castles[this.selectedCastle].id);
      }
      
      private function onRefreshCastle(param1:* = null, param2:* = null) : *
      {
         if(param1 != null && param1.hasOwnProperty("castles") && param1.castles != null && param1.castles.length > 0)
         {
            this.castles[this.selectedCastle] = param1.castles[0];
            this.renderCastleInfo(this.panelMC.popupattacksideph2.panel);
            this.renderCastleInfo(this.panelMC.popupdefendside.panel);
         }
      }
      
      private function renderCastleInfo(param1:*) : *
      {
         if(!param1)
         {
            return;
         }
         param1.clanStatusMc.nameTxt.htmlText = Character.colorifyText(this.castles[this.selectedCastle].owner_id,this.castles[this.selectedCastle].owner_name,param1.clanStatusMc.nameTxt);
         param1.hpTxt.text = this.castles[this.selectedCastle].wall_hp + " %";
         param1.hpTxt2.text = this.castles[this.selectedCastle].defender_hp + " %";
         param1.wallHpBar.scaleX = this.castles[this.selectedCastle].wall_hp / 100;
         param1.wallHpBar2.scaleX = this.castles[this.selectedCastle].defender_hp / 100;
      }
      
      private function openInviteCrewMemberPhaseTwo(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.getAttackers(this.onRecruitDataRes);
         this.panelMC.popupattacksideph2.panel.popupWarList.gotoAndStop("show");
         this.eventHandler.addListener(this.panelMC.popupattacksideph2.panel.popupWarList.panel.backPageBtn,MouseEvent.CLICK,this.closeInviteMemberRecruit);
         this.eventHandler.addListener(this.panelMC.popupattacksideph2.panel.popupWarList.panel.battleBtn,MouseEvent.CLICK,this.startAnimationPhaseTwo);
         this.eventHandler.addListener(this.panelMC.popupattacksideph2.panel.popupWarList.panel.prevPageBtn,MouseEvent.CLICK,this.changePageRecruit);
         this.eventHandler.addListener(this.panelMC.popupattacksideph2.panel.popupWarList.panel.nextPageBtn,MouseEvent.CLICK,this.changePageRecruit);
      }
      
      private function startAnimationPhaseTwo(param1:MouseEvent) : void
      {
         if(this.charData.stamina < 10)
         {
            this.main.showMessage("Stamina is not enough");
            this.openStaminaPopup(null);
            return;
         }
         if(Crew.instance.getSkipAnimation())
         {
            this.sendBattlePhaseTwo();
            return;
         }
         this.panelMC.popuploading.gotoAndPlay("show");
      }
      
      private function sendBattlePhaseTwo() : void
      {
         this.hideObjectDuringAnimation(true);
         var _loc1_:* = {
            "c":this.castles[this.selectedCastle].id,
            "b":NinjaSage.generateRandomString(24)
         };
         _loc1_["t"] = int(new Date().getTime() / 1000);
         _loc1_["h"] = Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([Character.char_id,_loc1_.b,_loc1_.t,_loc1_.c].join("|")))));
         Crew.instance.startBattle(_loc1_,this.onBattleResult);
      }
      
      private function onBattleResult(param1:* = null, param2:* = null) : void
      {
         if(param1 != null && Boolean(param1.hasOwnProperty("b")))
         {
            this.panelMC.popupResult.gotoAndStop("show");
            this.eventHandler.addListener(this.panelMC.popupResult.panel.okBtn,MouseEvent.CLICK,this.closeBattleResult);
            this.panelMC.popupResult.panel.lbl_battle_result.text = "Battle Result";
            this.panelMC.popupResult.panel.lbl_win.text = "Win";
            this.panelMC.popupResult.panel.lbl_lose.text = "Lose";
            this.panelMC.popupResult.panel.winClanTxt.text = param1.w;
            this.panelMC.popupResult.panel.loseClanTxt.text = param1.l;
            this.panelMC.popupResult.panel.loseTotalRepTxt.text = "Attack Damage: " + param1.d;
            this.panelMC.popupResult.panel.getMeritTxt.text = "Merit Obtained: " + param1.m;
            this.charData.stamina = param1.s;
            this.initStatusDisplay();
         }
         else
         {
            this.panelMC.popupResult.gotoAndStop("idle");
            if(param1 != null && Boolean(param1.hasOwnProperty("code")))
            {
               if(param1.code == 402)
               {
                  this.main.showMessage("Stamina is not enough");
                  this.openStaminaPopup(null);
               }
               else if(param1.code == 406)
               {
                  this.main.getNotice("The castle has been taken over by your crew.");
               }
               else
               {
                  this.main.getNotice("Battle failed:" + "\n" + param1.errorMessage);
               }
            }
            else
            {
               this.main.getNotice("Battle failed.\n" + param2);
            }
         }
         this.refreshCastle();
      }
      
      private function hideObjectDuringAnimation(param1:Boolean = false) : void
      {
         this.panelMC.popupattacksideph2.visible = param1;
         this.panelMC.clanStatusMc.visible = param1;
         this.panelMC.bg.visible = param1;
         this.panelMC.miniGameBtn.visible = param1;
         this.panelMC.rewardListHomeBtn.visible = param1;
         this.panelMC.backBtn.visible = param1;
         this.panelMC.status.visible = param1;
         this.panelMC.popupNotification.visible = param1;
         var _loc2_:int = 0;
         while(_loc2_ < 7)
         {
            this.panelMC["clan_btn_" + _loc2_].visible = param1;
            _loc2_++;
         }
      }
      
      private function closeBattleAnimation() : void
      {
         this.panelMC.popuploading.gotoAndStop("idle");
      }
      
      private function closeBattleResult(param1:MouseEvent) : void
      {
         this.panelMC.popupResult.gotoAndStop("idle");
      }
      
      private function closeBattlePopup(param1:MouseEvent) : void
      {
         this.panelMC.popupattackside.gotoAndStop("idle");
         this.panelMC.popupattacksideph2.gotoAndStop("idle");
      }
      
      private function onGetDefendData(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            if(param1.code == 429)
            {
               this.main.showMessage(param1.errorMessage);
            }
            else
            {
               this.main.getNotice(param1.errorMessage);
            }
            this.refreshCastle();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("statusCode"))
         {
            this.main.getNotice("Error Code: " + param1.statusCode);
            this.refreshCastle();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("defenders"))
         {
            this.defendingData = param1.defenders;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil(this.defendingData.length / 10),1);
            this.openPhaseTwoDefend();
            return;
         }
         if(param2 != null)
         {
            this.main.getNotice("Unable to get castle defenders");
            return;
         }
      }
      
      private function openPhaseTwoDefend() : void
      {
         if(this.castles[this.selectedCastle].owner_id != this.crewData.id)
         {
            this.main.showMessage("This castle has been taken over");
            this.closePhaseTwoDefend(null);
            return;
         }
         this.panelMC.popupdefendside.gotoAndStop("show");
         this.panelMC.popupdefendside.panel.popupReward.gotoAndStop("idle");
         this.panelMC.popupdefendside.panel.popupRecovery.gotoAndStop("idle");
         var _loc1_:MovieClip = this.panelMC.popupdefendside.panel;
         _loc1_.DefendThisBtn.visible = false;
         this.eventHandler.addListener(_loc1_.closeBtn,MouseEvent.CLICK,this.closePhaseTwoDefend);
         this.eventHandler.addListener(_loc1_.recoveryBtn,MouseEvent.CLICK,this.getRecoveryData);
         this.eventHandler.addListener(_loc1_.defendrewardListBtn,MouseEvent.CLICK,this.openRewardCastle);
         this.eventHandler.addListener(_loc1_.nextPageBtn,MouseEvent.CLICK,this.changePageMember);
         this.eventHandler.addListener(_loc1_.prevPageBtn,MouseEvent.CLICK,this.changePageMember);
         this.eventHandler.addListener(_loc1_.refreshBtn,MouseEvent.CLICK,this.refreshDefender);
         _loc1_.clanStatusMc.nameTxt.htmlText = Character.colorifyText(this.castles[this.selectedCastle].owner_id,this.castles[this.selectedCastle].owner_name,_loc1_.clanStatusMc.nameTxt);
         _loc1_.clanStatusMc.numTxt.text = this.defendingData.length + " / " + this.crewData.max_members;
         this.renderCastleInfo(_loc1_);
         this.refreshCastle();
         _loc1_.AttackerToDefBtn.change.gotoAndStop(this.role);
         if("role_limit_at" in this.charData && this.charData.role_limit_at != "")
         {
            _loc1_.timer.visible = true;
            _loc1_.timer.timeTxt.text = this.charData.role_limit_at;
            _loc1_.AttackerToDefBtn.visible = false;
         }
         else
         {
            _loc1_.timer.visible = false;
            _loc1_.AttackerToDefBtn.visible = true;
            this.main.initButton(_loc1_.AttackerToDefBtn,this.switchRoleConfirmation,"");
         }
         this.renderCrewMember();
      }
      
      private function refreshDefender(param1:MouseEvent) : void
      {
         Crew.instance.getDefenders(this.castles[this.selectedCastle].id,this.onGetDefendData);
      }
      
      private function getRecoveryData(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.getRecoverLifeBar(this.castles[this.selectedCastle].id,{"t":int(new Date().time / 1000)},this.onRecoveryData);
      }
      
      private function onRecoveryData(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("n"))
         {
            Character.account_tokens = param1.t;
            this.initStatusDisplay();
            this.openRecovery(param1);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("Unknown erorr");
            return;
         }
      }
      
      private function openRecovery(param1:Object) : void
      {
         this.panelMC.popupdefendside.panel.popupRecovery.gotoAndStop("show");
         var _loc2_:MovieClip = this.panelMC.popupdefendside.panel.popupRecovery.panel;
         this.eventHandler.addListener(_loc2_.closeBtn,MouseEvent.CLICK,this.closeRecovery);
         NinjaSage.showDynamicTooltip(_loc2_.recoverytime,"Claimable every 30 mins to recover " + param1.a + " life bar");
         NinjaSage.showDynamicTooltip(_loc2_.item,"Use Vitality Gourd to recover your life bar. " + this.RECOVER_PRICE_GOURD + " gourd for " + this.RECOVER_LIFE_GOURD + " Life bar");
         NinjaSage.showDynamicTooltip(_loc2_.token,"Use Token to recover your life bar. " + this.RECOVER_PRICE_TOKEN + " tokens for " + this.RECOVER_LIFE_TOKEN + " Life bar");
         _loc2_.hpTxt.text = this.castles[this.selectedCastle].wall_hp + " %";
         _loc2_.wallHpBar.scaleX = this.castles[this.selectedCastle].wall_hp / 100;
         this.n = param1.n;
         if(param1.f != "")
         {
            _loc2_.timeTxt.text = param1.f;
            this.main.initButtonDisable(_loc2_.btn_restore,this.recoverWall,"Claim");
         }
         else
         {
            _loc2_.timeTxt.text = "Claimable";
            this.main.initButton(_loc2_.btn_restore,this.recoverWall,"Claim");
         }
         _loc2_.refillAllNum.text = "Owned: x" + param1.g;
         if(param1.g > 0)
         {
            this.main.initButton(_loc2_.btn_useItem,this.recoverWall,"Use");
         }
         else
         {
            this.main.initButtonDisable(_loc2_.btn_useItem,this.recoverWall,"Use");
         }
         if(param1.t >= this.RECOVER_PRICE_TOKEN)
         {
            this.main.initButton(_loc2_.btn_token,this.recoverWall,"Use " + this.RECOVER_PRICE_TOKEN + "T");
         }
         else
         {
            this.main.initButtonDisable(_loc2_.btn_token,this.recoverWall,"Use " + this.RECOVER_PRICE_TOKEN + "T");
         }
      }
      
      private function recoverWall(param1:MouseEvent) : void
      {
         var _loc2_:* = String(param1.currentTarget.name).replace("btn_","");
         this.main.loading(true);
         _loc2_ = _loc2_ == "restore" ? 1 : (_loc2_ == "token" ? 3 : 2);
         var _loc3_:* = int(new Date().time / 1000);
         Crew.instance.recoverCastle(this.castles[this.selectedCastle].id,{
            "r":_loc2_,
            "t":_loc3_,
            "h":Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([Character.char_id,_loc2_,_loc3_,this.n].join("|")))))
         },this.onWallHpRecovered);
      }
      
      private function onWallHpRecovered(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            if(param1.code == 429)
            {
               this.main.showMessage(param1.errorMessage);
            }
            else
            {
               this.main.getNotice(param1.errorMessage);
            }
            return;
         }
         if(param1 != null && param1.hasOwnProperty("a"))
         {
            this.main.showMessage("Wall successfully recovered, it should increase shortly");
            this.castles[this.selectedCastle].wall_hp = param1.w;
            this.getRecoveryData(null);
            this.renderCastleInfo(this.panelMC.popupdefendside.panel);
            return;
         }
         if(param2 != null)
         {
            this.main.getNotice("Unable to recover wall");
            return;
         }
      }
      
      private function closeRecovery(param1:MouseEvent) : void
      {
         this.panelMC.popupdefendside.panel.popupRecovery.gotoAndStop("idle");
         this.refreshDefender(param1);
      }
      
      private function renderCrewMember() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = this.panelMC.popupdefendside.panel;
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            _loc1_ = _loc3_ + int(int(this.currentPage - 1) * 10);
            _loc2_["member_" + _loc3_].visible = false;
            _loc2_["member_" + _loc3_].gotoAndStop(1);
            if(this.defendingData.length > _loc1_)
            {
               _loc2_["member_" + _loc3_].visible = true;
               _loc2_["member_" + _loc3_].nameTxt.htmlText = Character.colorifyText(this.defendingData[_loc1_].char_id,"[" + this.defendingData[_loc1_].id + "] " + this.defendingData[_loc1_].name,_loc2_["member_" + _loc3_].nameTxt);
               _loc2_["member_" + _loc3_].levelTxt.text = this.defendingData[_loc1_].level;
               _loc2_["member_" + _loc3_].staminaTxt.text = this.defendingData[_loc1_].hp;
            }
            _loc3_++;
         }
         this.updatePageMember();
      }
      
      private function changePageMember(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "nextPageBtn":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderCrewMember();
               }
               break;
            case "prevPageBtn":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderCrewMember();
               }
         }
      }
      
      private function updatePageMember() : void
      {
         var _loc1_:MovieClip = this.panelMC.popupdefendside.panel;
         _loc1_.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function switchRoleConfirmation(param1:MouseEvent) : void
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to change role for this castle?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeSwitchRoleConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.switchRole);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function closeSwitchRoleConfirmation(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation.txtMc.txt.text = "";
         this.eventHandler.removeListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeSwitchRoleConfirmation);
         this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.switchRole);
         this.confirmation = null;
      }
      
      private function switchRole(param1:MouseEvent) : void
      {
         this.closeSwitchRoleConfirmation(null);
         this.main.loading(true);
         Crew.instance.switchRole(this.castles[this.selectedCastle].id,this.onSwitchedRole);
      }
      
      private function onSwitchedRole(param1:Object, param2:* = null) : *
      {
         var _loc3_:MovieClip = null;
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 == "ok")
         {
            this.role = this.role == 1 ? 2 : 1;
            _loc3_ = this.panelMC.popupdefendside.panel;
            _loc3_.AttackerToDefBtn.visible = false;
            this.updateRoleIcon();
            this.main.showMessage("Successfully changed your role.");
            return;
         }
         if(param2 != null)
         {
            this.main.getNotice("Unable to switch role\n" + param2);
            return;
         }
      }
      
      private function closePhaseTwoDefend(param1:MouseEvent) : void
      {
         this.panelMC.popupdefendside.gotoAndStop("idle");
      }
      
      private function onRecruitDataRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("statusCode"))
         {
            this.main.getNotice("Error Code: " + param1.statusCode);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("members"))
         {
            this.recruitData = !!param1.members ? param1.members : [];
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil(this.recruitData.length / 10),1);
            this.renderRecruitData();
            return;
         }
         if(param2 != null)
         {
            this.main.getNotice("Unable to get crew attackers");
            return;
         }
      }
      
      private function renderRecruitData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = Crew.instance.getPhase() == 1 ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel;
         this.resetSelectedRecruitMember();
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _loc1_ = _loc4_ + int(int(this.currentPage - 1) * 10);
            _loc3_.popupWarList.panel["member_" + _loc4_].visible = false;
            if(this.recruitData.length > _loc1_)
            {
               _loc3_.popupWarList.panel["member_" + _loc4_].visible = true;
               _loc3_.popupWarList.panel["member_" + _loc4_].nameTxt.htmlText = Character.colorifyText(this.recruitData[_loc1_].char_id,"[" + this.recruitData[_loc1_].char_id + "] " + this.recruitData[_loc1_].name,_loc3_.popupWarList.panel["member_" + _loc4_].nameTxt);
               _loc3_.popupWarList.panel["member_" + _loc4_].levelTxt.text = this.recruitData[_loc1_].level;
               _loc3_.popupWarList.panel["member_" + _loc4_].staminaTxt.text = this.recruitData[_loc1_].stamina;
               _loc3_.popupWarList.panel["member_" + _loc4_].buttonMode = true;
               _loc3_.popupWarList.panel["member_" + _loc4_].metaData = {"charId":this.recruitData[_loc1_].char_id};
               this.eventHandler.addListener(_loc3_.popupWarList.panel["member_" + _loc4_],MouseEvent.CLICK,this.selectRecruitMember);
               _loc2_ = 0;
               while(_loc2_ < this.recruitedFriend.length)
               {
                  if(this.recruitedFriend[_loc2_] == this.recruitData[_loc1_].char_id)
                  {
                     _loc3_.popupWarList.panel["member_" + _loc4_].gotoAndStop("selected");
                  }
                  _loc2_++;
               }
            }
            _loc4_++;
         }
         this.updatePageRecruit();
      }
      
      private function selectRecruitMember(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(param1.currentTarget.name.replace("member_",""));
         var _loc4_:int = int(param1.currentTarget.metaData.charId);
         var _loc5_:MovieClip = Crew.instance.getPhase() == 1 ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel;
         if(this.recruitedFriend.length >= 1)
         {
            _loc2_ = 0;
            while(_loc2_ < this.recruitedFriend.length)
            {
               if(this.recruitedFriend[_loc2_] == _loc4_)
               {
                  this.recruitedFriend.splice(_loc2_,1);
                  _loc5_.popupWarList.panel["member_" + _loc3_].gotoAndStop("idle");
                  this.updateTotalRecruited();
                  return;
               }
               _loc2_++;
            }
         }
         if(this.recruitedFriend.length >= 2)
         {
            this.main.getNotice("You can only recruit up to 2 friends");
            return;
         }
         _loc5_.popupWarList.panel["member_" + _loc3_].gotoAndStop("selected");
         this.recruitedFriend.push(_loc4_);
         this.updateTotalRecruited();
      }
      
      private function resetSelectedRecruitMember() : void
      {
         var _loc1_:MovieClip = Crew.instance.getPhase() == 1 ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel;
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc1_.popupWarList.panel["member_" + _loc2_].gotoAndStop("idle");
            _loc2_++;
         }
      }
      
      private function changePageRecruit(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "nextPageBtn":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderRecruitData();
               }
               break;
            case "prevPageBtn":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderRecruitData();
               }
         }
      }
      
      private function updateTotalRecruited() : void
      {
         var _loc1_:MovieClip = Crew.instance.getPhase() == 1 ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel;
         _loc1_.popupWarList.panel.txt_memberRecruited.text = this.recruitedFriend.length + "/2";
      }
      
      private function updatePageRecruit() : void
      {
         var _loc1_:MovieClip = Crew.instance.getPhase() == 1 ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel;
         _loc1_.popupWarList.panel.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function closeInviteMemberRecruit(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = Crew.instance.getPhase() == 1 ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel;
         this.recruitedFriend = [];
         this.resetSelectedRecruitMember();
         this.updatePageRecruit();
         _loc2_.popupWarList.gotoAndStop("idle");
      }
      
      private function openRankingPhaseOne(param1:MouseEvent) : void
      {
         this.panelMC.popupattackside.panel.rankList.gotoAndStop("show");
         this.main.loading(true);
         Crew.instance.getCrewRanks(this.selectedCastle + 1,this.onGetRankingList);
         var _loc2_:MovieClip = this.panelMC.popupattackside.panel.rankList.panel;
         this.eventHandler.addListener(_loc2_.closeBtn,MouseEvent.CLICK,this.closeRankingPhaseOne);
         this.eventHandler.addListener(_loc2_.prevPageBtn,MouseEvent.CLICK,this.changePageRanking);
         this.eventHandler.addListener(_loc2_.nextPageBtn,MouseEvent.CLICK,this.changePageRanking);
      }
      
      private function onGetRankingList(param1:*, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && Boolean(param1.hasOwnProperty("crews")))
         {
            this.rankingData = param1.crews == null ? [] : param1.crews;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil(param1.total / 9),1);
            this.renderRankingData();
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice("Server Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      private function renderRankingData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = this.panelMC.popupattackside.panel.rankList.panel;
         var _loc3_:int = 0;
         while(_loc3_ < 9)
         {
            _loc1_ = _loc3_ + int(int(this.currentPage - 1) * 9);
            _loc2_["clan_" + _loc3_].visible = false;
            _loc2_["clan_" + _loc3_].gotoAndStop(1);
            if(this.rankingData.length > _loc1_)
            {
               _loc2_["clan_" + _loc3_].visible = true;
               _loc2_["clan_" + _loc3_].idTxt.text = this.rankingData[_loc1_].id;
               _loc2_["clan_" + _loc3_].nameTxt.htmlText = Character.colorifyText(this.rankingData[_loc1_].char_id,this.rankingData[_loc1_].name,_loc2_["clan_" + _loc3_].nameTxt);
               _loc2_["clan_" + _loc3_].totalMemberTxt.text = this.rankingData[_loc1_].total_members + "/" + this.rankingData[_loc1_].max_members;
               _loc2_["clan_" + _loc3_].reputationTxt.text = this.rankingData[_loc1_].boss_killed;
            }
            _loc3_++;
         }
         this.updatePageRanking();
      }
      
      private function changePageRanking(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "nextPageBtn":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderRankingData();
               }
               break;
            case "prevPageBtn":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderRankingData();
               }
         }
      }
      
      private function updatePageRanking() : void
      {
         var _loc1_:MovieClip = this.panelMC.popupattackside.panel.rankList.panel;
         _loc1_.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function closeRankingPhaseOne(param1:MouseEvent) : void
      {
         this.panelMC.popupattackside.panel.rankList.gotoAndStop("idle");
         this.currentPage = 1;
         this.totalPage = 1;
      }
      
      private function openRewardCastle(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = Crew.instance.getPhase() == 1 ? this.panelMC.popupattackside.panel : (this.crewData.id == this.castles[this.selectedCastle].owner_id ? this.panelMC.popupdefendside.panel : this.panelMC.popupattacksideph2.panel);
         _loc2_.popupReward.gotoAndStop("show");
         this.eventHandler.addListener(_loc2_.popupReward.panel.closeBtn,MouseEvent.CLICK,this.closeRewardCastle);
         this.eventHandler.addListener(_loc2_.popupReward.panel.okBtn,MouseEvent.CLICK,this.closeRewardCastle);
         _loc2_.popupReward.panel.rewardTxt.text = this.castleName[this.selectedCastle] + " Reward";
         var _loc3_:String = Crew.instance.getPhase() == 1 ? String(this.crewVillage.rewardData.phase_1[0]) : String(this.castles[this.selectedCastle].reward);
         NinjaSage.loadItemIcon(_loc2_.popupReward.panel.IconMc_0,_loc3_);
      }
      
      private function closeRewardCastle(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = Crew.instance.getPhase() == 1 ? this.panelMC.popupattackside.panel : (this.crewData.id == this.castles[this.selectedCastle].owner_id ? this.panelMC.popupdefendside.panel : this.panelMC.popupattacksideph2.panel);
         this.eventHandler.removeListener(_loc2_.popupReward.panel.closeBtn,MouseEvent.CLICK,this.closeRewardCastle);
         this.eventHandler.removeListener(_loc2_.popupReward.panel.okBtn,MouseEvent.CLICK,this.closeRewardCastle);
         GF.removeAllChild(_loc2_.popupReward.panel.IconMc_0.rewardIcon.iconHolder);
         GF.removeAllChild(_loc2_.popupReward.panel.IconMc_0.skillIcon.iconHolder);
         _loc2_.popupReward.gotoAndStop("idle");
      }
      
      private function openRewardListHome(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         this.panelMC.popupRewardHome.gotoAndStop("show");
         this.eventHandler.addListener(this.panelMC.popupRewardHome.panel.closeBtn,MouseEvent.CLICK,this.closeRewardListHome);
         _loc2_ = 0;
         while(_loc2_ < this.crewVillage.rewardData.phase_1.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.popupRewardHome.panel["IconMc0_" + _loc2_],this.crewVillage.rewardData.phase_1[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.crewVillage.rewardData.phase_2.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.popupRewardHome.panel["IconMc_" + _loc2_],this.crewVillage.rewardData.phase_2[_loc2_]);
            _loc2_++;
         }
      }
      
      private function closeRewardListHome(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.crewVillage.rewardData.phase_1.length)
         {
            GF.removeAllChild(this.panelMC.popupRewardHome.panel["IconMc0_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupRewardHome.panel["IconMc0_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.crewVillage.rewardData.phase_2.length)
         {
            GF.removeAllChild(this.panelMC.popupRewardHome.panel["IconMc_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupRewardHome.panel["IconMc_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         this.eventHandler.removeListener(this.panelMC.popupRewardHome.panel.closeBtn,MouseEvent.CLICK,this.closeMinigamePopup);
         this.eventHandler.removeListener(this.panelMC.popupRewardHome.panel.claimBtn,MouseEvent.CLICK,this.closeMinigamePopup);
         this.panelMC.popupRewardHome.gotoAndStop("idle");
      }
      
      private function openLastSeasonReward(param1:MouseEvent) : void
      {
         Crew.instance.getLastSeasonRewards(this.onSeasonReward);
      }
      
      private function onSeasonReward(param1:*, param2:* = null) : void
      {
         var _loc3_:MovieClip = null;
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice("Server Error: " + param1.errorMessage);
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("c")))
         {
            this.seasonRewardData = param1;
            this.panelMC.lastpopupRewardHome.gotoAndStop("show");
            _loc3_ = this.panelMC.lastpopupRewardHome.panel;
            this.eventHandler.addListener(_loc3_.closeBtn,MouseEvent.CLICK,this.closeLastSeasonReward);
            this.renderSeasonReward();
            return;
         }
      }
      
      private function renderSeasonReward() : void
      {
         var _loc1_:MovieClip = this.panelMC.lastpopupRewardHome.panel;
         _loc1_.titleTxt.text = "Season " + this.seasonRewardData.s + " Rewards";
         _loc1_.titleTxt1.text = "Phase 1 Owner Reward";
         _loc1_.titleTxt2.text = "Phase 2 Castle Reward";
         _loc1_.prevPageBtn.visible = false;
         _loc1_.nextPageBtn.visible = false;
         _loc1_.pageTxt.visible = false;
         NinjaSage.loadItemIcon(_loc1_.icon,this.seasonRewardData.r.phase1[0]);
         var _loc2_:int = 0;
         while(_loc2_ < this.castleName.length)
         {
            _loc1_["name_" + _loc2_].text = this.seasonRewardData.c[_loc2_].name;
            _loc1_["owner_" + _loc2_].text = this.seasonRewardData.c[_loc2_].owner_p2_name;
            NinjaSage.loadItemIcon(_loc1_["icon_" + _loc2_],this.seasonRewardData.c[_loc2_].reward);
            _loc2_++;
         }
      }
      
      private function closeLastSeasonReward(param1:MouseEvent) : void
      {
         this.eventHandler.removeListener(this.panelMC.lastpopupRewardHome.panel.closeBtn,MouseEvent.CLICK,this.closeLastSeasonReward);
         this.panelMC.lastpopupRewardHome.gotoAndStop("idle");
      }
      
      private function openMinigamePopup(param1:MouseEvent) : void
      {
         this.panelMC.popupMiniGame.gotoAndStop("show");
         this.eventHandler.addListener(this.panelMC.popupMiniGame.panel.closeBtn,MouseEvent.CLICK,this.closeMinigamePopup);
         this.eventHandler.addListener(this.panelMC.popupMiniGame.panel.claimBtn,MouseEvent.CLICK,this.startMiniGame);
         NinjaSage.loadItemIcon(this.panelMC.popupMiniGame.panel.IconMc_0,this.crewVillage.minigameRewardData[0]);
         NinjaSage.loadItemIcon(this.panelMC.popupMiniGame.panel.IconMc_1,this.crewVillage.minigameRewardData[1]);
      }
      
      private function startMiniGame(param1:MouseEvent) : void
      {
         this.loaderSwf.add("swfpanels/CrewMiniGame.swf",{"id":"CrewMiniGame"});
         this.loaderSwf.addEventListener(BulkLoader.COMPLETE,this.onCrewMiniGameLoaded);
         this.loaderSwf.start();
         this.closeMinigamePopup(null);
      }
      
      private function onCrewMiniGameLoaded(param1:Event) : *
      {
         this.loaderSwf.removeEventListener(BulkLoader.COMPLETE,this.onCrewMiniGameLoaded);
         var _loc2_:Class = this.loaderSwf.getContent("CrewMiniGame").loaderInfo.applicationDomain.getDefinition("CrewMiniGame") as Class;
         var _loc3_:MovieClip = new _loc2_();
         var _loc4_:Class;
         var _loc5_:MovieClip = new (_loc4_ = getDefinitionByName("id.ninjasage.features.CrewMiniGame") as Class)(this,_loc3_);
         this.main.loader.addChild(_loc3_);
         this.loaderSwf.removeAll();
      }
      
      private function closeMinigamePopup(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.panelMC.popupMiniGame.panel.IconMc_0.rewardIcon.iconHolder);
         GF.removeAllChild(this.panelMC.popupMiniGame.panel.IconMc_0.skillIcon.iconHolder);
         GF.removeAllChild(this.panelMC.popupMiniGame.panel.IconMc_1.rewardIcon.iconHolder);
         GF.removeAllChild(this.panelMC.popupMiniGame.panel.IconMc_1.skillIcon.iconHolder);
         this.eventHandler.removeListener(this.panelMC.popupMiniGame.panel.closeBtn,MouseEvent.CLICK,this.closeMinigamePopup);
         this.eventHandler.removeListener(this.panelMC.popupMiniGame.panel.claimBtn,MouseEvent.CLICK,this.closeMinigamePopup);
         this.panelMC.popupMiniGame.gotoAndStop("idle");
      }
      
      public function initStatusDisplay() : void
      {
         this.panelMC.clanStatusMc.extraTimeMc.visible = false;
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
         this.panelMC.clanStatusMc.rollTxt.text = Character.getMaterialAmount(this.crewVillage.GOLDEN_ONIGIRI);
         this.panelMC.clanStatusMc.timeTxt.text = "+" + int(30 + this.crewData.kushi_dango * 10) + "/30 min";
         this.panelMC.clanStatusMc.PhaseTxt.text = "Phase " + Crew.instance.getPhase();
      }
      
      private function initPlayerHead() : void
      {
         var _loc1_:MovieClip = this.main.getPlayerHead();
         GF.removeAllChild(this.panelMC.clanStatusMc.headHolder);
         this.panelMC.clanStatusMc.headHolder.addChild(_loc1_);
      }
      
      private function updateTimeleft() : void
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
         var _loc1_:int = this.crewTimestamp;
         var _loc2_:int = Math.floor(_loc1_ / 86400);
         var _loc3_:int = Math.floor((_loc1_ - _loc2_ * 86400) / 3600);
         var _loc4_:int;
         if((_loc4_ = Math.floor((_loc1_ - _loc2_ * 86400 - _loc3_ * 3600) / 60)) >= 30)
         {
            this.panelMC.clanStatusMc.timer_StaRecover.gotoAndStop(60 - _loc4_);
         }
         else
         {
            this.panelMC.clanStatusMc.timer_StaRecover.gotoAndStop(30 - _loc4_);
         }
         this.panelMC.clanStatusMc.dayTxt.text = _loc2_;
         this.panelMC.clanStatusMc.hourTxt.text = _loc3_;
         this.panelMC.clanStatusMc.minTxt.text = _loc4_;
         this.crewTimestamp -= 5;
         Crew.instance.getStamina(this.onGetStamina);
         Crew.instance.getCastles(this.onInitCastle);
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
            this.role = param1.char.role;
            this.crewTimestamp = param1.season.timestamp;
            this.updateRoleIcon();
            this.panelMC.clanStatusMc.staminaTxt.text = this.charData.stamina + "/" + this.charData.max_stamina;
            this.panelMC.clanStatusMc.staminaBar.scaleX = this.charData.stamina / this.charData.max_stamina;
            this.timeout = setTimeout(this.updateTimeleft,5000);
         }
         if(param1 != null && param1.hasOwnProperty("season") && param1.season != null)
         {
            Crew.instance.setPhase(param1.season.phase);
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.showMessage("Unable to get stamina");
            return;
         }
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.crewVillage.panelMC.visible = true;
         this.crewVillage.initStatusDisplay();
         this.crewVillage.initPlayerHead();
         this.crewVillage.getMiniGameData();
         this.crewVillage.updateTimeleft();
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
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         this.panelMC.popuploading.addFrameScript(8,null,92,null,102,null);
         TweenLite.killTweensOf(this.panelMC.popupNotification);
         this.loaderSwf.clear();
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.main = null;
         this.timeout = null;
         this.eventHandler = null;
         this.crewVillage = null;
         this.loaderSwf = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}
