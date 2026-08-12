package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.StatManager;
   import Storage.Character;
   import Storage.EnemyInfo;
   import Storage.GameData;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   public dynamic class DragonHunt extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var bossData:Array;
      
      private var selectedEnemy:int = -1;
      
      private var selectedMode:int = -1;
      
      private var selectedBuyMaterial:String;
      
      private var amount:int = 1;
      
      private var price:int = 10;
      
      private var cost:int = 0;
      
      private const NORMAL_PRICE:Number = 250000;
      
      private const EASY_PRICE:Number = 100;
      
      private const SUSHI_MATERIAL:String = "item_54";
      
      private const SEAL_MATERIAL:String = "item_52";
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var response:Object;
      
      public function DragonHunt(param1:*, param2:*)
      {
         var _loc3_:* = GameData.get("dragon_hunt");
         var _loc4_:* = {"level":Character.character_lvl};
         this.bossData = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.bosses.length)
         {
            this.bossData.push({
               "bossId":_loc3_.bosses[_loc5_].id,
               "bossName":_loc3_.bosses[_loc5_].name,
               "bossDescription":_loc3_.bosses[_loc5_].description,
               "bossLevel":[int(Character.character_lvl) + _loc3_.bosses[_loc5_].levels[0],int(Character.character_lvl) + _loc3_.bosses[_loc5_].levels[1]],
               "bossGold":int(Util.calculateFromString(_loc3_.bosses[_loc5_].gold,_loc4_)),
               "bossXp":int(Util.calculateFromString(_loc3_.bosses[_loc5_].gold,_loc4_)),
               "bossRequirement":_loc3_.bosses[_loc5_].requirement,
               "bossReward":_loc3_.bosses[_loc5_].rewards,
               "backgroundBattle":_loc3_.bosses[_loc5_].background
            });
            _loc5_++;
         }
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.hidePopup();
         this.initButton();
         this.initUI();
      }
      
      private function initUI() : *
      {
         this.main.handleVillageHUDVisibility(false);
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            this.panelMC["battle_" + _loc1_].btn.graphicMc.gotoAndStop(_loc1_ + 1);
            this.panelMC["battle_" + _loc1_].btn.graphicMc.enemyName.text = this.bossData[_loc1_].bossName;
            this.panelMC["battle_" + _loc1_].gotoAndStop(1);
            this.eventHandler.addListener(this.panelMC["battle_" + _loc1_],MouseEvent.CLICK,this.setSelectedEnemy);
            this.eventHandler.addListener(this.panelMC["battle_" + _loc1_],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.addListener(this.panelMC["battle_" + _loc1_],MouseEvent.MOUSE_OUT,this.out);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            this.panelMC.dragonBallMc["DBMc_" + _loc1_].DBtxt.text = "";
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            this.main.initButton(this.panelMC.bossDetailMc.panel["modeMc_" + _loc1_],this.checkStartBattle,"");
            this.panelMC.bossDetailMc.panel["modeMc_" + _loc1_].btn.modePicMc.gotoAndStop(_loc1_ + 1);
            _loc1_++;
         }
         this.panelMC.bossDetailMc.panel.gotoAndStop(1);
         this.panelMC.bossDetailMc.panel["modeMc_0"].priceMc.visible = false;
         this.panelMC.bossDetailMc.panel["modeMc_0"].modeTxt.text = "Hard Mode";
         this.panelMC.bossDetailMc.panel["modeMc_0"].descTxt.text = "Range of capturable HP: 5%, without capture reminder";
         this.panelMC.bossDetailMc.panel["modeMc_1"].priceMc.icon.gotoAndStop("gold");
         this.panelMC.bossDetailMc.panel["modeMc_1"].priceMc.price_0.text = this.NORMAL_PRICE;
         this.panelMC.bossDetailMc.panel["modeMc_1"].freeTxt.visible = false;
         this.panelMC.bossDetailMc.panel["modeMc_1"].priceMc.token_0.visible = false;
         this.panelMC.bossDetailMc.panel["modeMc_1"].modeTxt.text = "Normal Mode";
         this.panelMC.bossDetailMc.panel["modeMc_1"].descTxt.text = "Range of capturable HP: 15%, without capture reminder";
         this.panelMC.bossDetailMc.panel["modeMc_2"].priceMc.icon.gotoAndStop("token");
         this.panelMC.bossDetailMc.panel["modeMc_2"].priceMc.token_0.text = this.EASY_PRICE;
         this.panelMC.bossDetailMc.panel["modeMc_2"].freeTxt.visible = false;
         this.panelMC.bossDetailMc.panel["modeMc_2"].priceMc.price_0.visible = false;
         this.panelMC.bossDetailMc.panel["modeMc_2"].modeTxt.text = "Easy Mode";
         this.panelMC.bossDetailMc.panel["modeMc_2"].descTxt.text = "Range of capturable HP: 25%, with capture reminder";
         this.panelMC.bossDetailMc.panel.sushiItemTxt.text = String(Character.getConsumableAmount(this.SUSHI_MATERIAL));
         this.panelMC.bossDetailMc.panel.scrollItemTxt.text = String(Character.getConsumableAmount(this.SEAL_MATERIAL));
         this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.btnClose,MouseEvent.CLICK,this.closeBossDetail);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.sushiBtn,MouseEvent.CLICK,this.openBuyMaterial);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.scrollBtn,MouseEvent.CLICK,this.openBuyMaterial);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.convertBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.panel.getMoreTokenBtn,MouseEvent.CLICK,this.openRecharge);
      }
      
      private function setSelectedEnemy(param1:MouseEvent) : *
      {
         var _loc2_:int = param1.currentTarget.name.replace("battle_","");
         var _loc3_:* = 0;
         while(_loc3_ < 5)
         {
            this.panelMC["battle_" + _loc3_].gotoAndStop(1);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 7)
         {
            this.panelMC.dragonBallMc["DBMc_" + _loc3_].DBtxt.text = "x" + String(Character.getMaterialAmount(this.bossData[_loc2_].bossRequirement[_loc3_]));
            NinjaSage.loadItemIcon(this.panelMC.dragonBallMc["DBMc_" + _loc3_].iconHolder.DBIcon.iconHolder,this.bossData[_loc2_].bossRequirement[_loc3_],"icon");
            _loc3_++;
         }
         this.panelMC["battle_" + _loc2_].gotoAndStop(3);
         this.selectedEnemy = _loc2_;
      }
      
      private function openBossDetail(param1:MouseEvent) : *
      {
         var _loc3_:int = 0;
         if(this.selectedEnemy == -1)
         {
            this.main.showMessage("Please select an enemy");
            return;
         }
         this.panelMC.bossDetailMc.visible = true;
         this.panelMC.bossDetailMc.panel.detailMc0.nameTxt.text = this.bossData[this.selectedEnemy].bossName;
         this.panelMC.bossDetailMc.panel.detailMc0.decTxt.text = this.bossData[this.selectedEnemy].bossDescription;
         this.panelMC.bossDetailMc.panel.goldMc.txt.text = this.bossData[this.selectedEnemy].bossGold;
         this.panelMC.bossDetailMc.panel.xpMc.txt.text = this.bossData[this.selectedEnemy].bossXp;
         this.panelMC.bossDetailMc.panel.detailMc0.lvMc.lvLow.txt.text = this.bossData[this.selectedEnemy].bossLevel[0];
         this.panelMC.bossDetailMc.panel.detailMc0.lvMc.lvHigh.txt.text = this.bossData[this.selectedEnemy].bossLevel[1];
         this.panelMC.bossDetailMc.panel.goldTxt.text = String(Character.character_gold);
         this.panelMC.bossDetailMc.panel.tokenTxt.text = String(Character.account_tokens);
         NinjaSage.loadIconSWF("enemy",this.bossData[this.selectedEnemy].bossId[0],this.panelMC.bossDetailMc.panel.detailMc0.bossHolder,"StatichuntingHouse");
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = _loc2_ + 0 * 5;
            if(this.bossData[this.selectedEnemy].bossReward.length > _loc3_)
            {
               this.panelMC.bossDetailMc.panel["item" + _loc2_].visible = true;
               NinjaSage.loadItemIcon(this.panelMC.bossDetailMc.panel["item" + _loc2_].holder,this.bossData[this.selectedEnemy].bossReward[_loc2_],"icon");
            }
            else
            {
               this.panelMC.bossDetailMc.panel["item" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            this.panelMC.bossDetailMc.panel.huntingPassMc["Dbtxt_" + _loc2_].text = "x1";
            NinjaSage.loadItemIcon(this.panelMC.bossDetailMc.panel.huntingPassMc["Db_" + _loc2_].DBIcon.iconHolder,this.bossData[this.selectedEnemy].bossRequirement[_loc2_],"icon");
            _loc2_++;
         }
      }
      
      private function checkStartBattle(param1:MouseEvent) : *
      {
         this.selectedMode = param1.currentTarget.name.replace("modeMc_","");
         if(int(Character.getConsumableAmount(this.SEAL_MATERIAL)) < 1)
         {
            this.openNoScrollPopup();
         }
         else
         {
            this.startBattle();
         }
      }
      
      private function startBattle(param1:MouseEvent = null) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = this.bossData[this.selectedEnemy].bossId[0];
         Character.christmas_boss_num = 0;
         Character.christmas_boss_id = _loc5_;
         _loc2_ = StatManager.calculate_stats_with_data("agility");
         _loc3_ = EnemyInfo.getCopy(_loc5_);
         this.enemyStats = "id:" + _loc3_["enemy_id"] + "|hp:" + _loc3_["enemy_hp"] + "|agility:" + _loc3_["enemy_agility"];
         _loc4_ = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.char_id) + String(_loc5_) + String(this.selectedMode) + this.enemyStats + String(_loc2_))));
         this.main.loading(true);
         this.main.amf_manager.service("uw8zuDzUq5Zgt3o7.VLIF2F93qlaQ",[Character.char_id,_loc5_,this.selectedMode,_loc2_,this.enemyStats,_loc4_,Character.sessionkey],this.onStartEventAmf);
      }
      
      private function onStartEventAmf(param1:Object) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(param1.hash != Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.christmas_boss_id) + param1.code + Character.char_id + String(param1.n1) + param1.n2))))
            {
               this.main.showMessage(param1.result);
               return;
            }
            if(this.selectedMode == 1)
            {
               Character.character_gold = String(Number(Character.character_gold) - Number(this.NORMAL_PRICE));
            }
            else if(this.selectedMode == 2)
            {
               Character.account_tokens -= int(this.EASY_PRICE);
            }
            _loc2_ = 0;
            while(_loc2_ < 7)
            {
               Character.removeMaterials(this.bossData[this.selectedEnemy].bossRequirement[_loc2_],1);
               _loc2_++;
            }
            this.main.HUD.setBasicData();
            _loc3_ = param1.n1;
            _loc4_ = param1.n2;
            BattleVars.CAPTURE_RANGE_START = _loc3_;
            BattleVars.CAPTURE_RANGE_END = _loc4_;
            BattleVars.CAPTURED_AT = -1;
            BattleVars.DH_MODE = this.selectedMode;
            Character.battle_code = param1.code;
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.DRAGON_HUNT_MATCH,this.bossData[this.selectedEnemy].backgroundBattle);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            _loc2_ = 0;
            while(_loc2_ < this.bossData[this.selectedEnemy].bossId.length)
            {
               BattleManager.addPlayerToTeam("enemy",this.bossData[this.selectedEnemy].bossId[_loc2_]);
               _loc2_++;
            }
            BattleManager.startBattle();
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
      
      private function openNoScrollPopup() : *
      {
         this.panelMC.popupNoScrollMc.visible = true;
         this.eventHandler.addListener(this.panelMC.popupNoScrollMc.panel.btnClose,MouseEvent.CLICK,this.closeNoScrollPopup);
         this.eventHandler.addListener(this.panelMC.popupNoScrollMc.panel.attackBtn,MouseEvent.CLICK,this.startBattle);
         this.eventHandler.addListener(this.panelMC.popupNoScrollMc.panel.buyScrollBtn,MouseEvent.CLICK,this.openBuyMaterial);
      }
      
      private function openBuyMaterial(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         this.panelMC.popupBuyItemMc.visible = true;
         this.panelMC.popupBuyItemMc.panel.titleTxt.text = "Dragon Hunt Material";
         this.panelMC.popupBuyItemMc.panel.goldTxt.text = String(Character.character_gold);
         this.panelMC.popupBuyItemMc.panel.tokenTxt.text = String(Character.account_tokens);
         this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.convertBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.getMoreTokenBtn,MouseEvent.CLICK,this.openRecharge);
         GF.removeAllChild(this.panelMC.popupBuyItemMc.panel.displayHolder);
         if(_loc2_ == "sushiBtn")
         {
            this.panelMC.popupBuyItemMc.panel.itemNameTxt.text = "Sushi Item";
            this.selectedBuyMaterial = this.SUSHI_MATERIAL;
            NinjaSage.loadItemIcon(this.panelMC.popupBuyItemMc.panel.displayHolder,this.SUSHI_MATERIAL,"icon");
         }
         else
         {
            this.panelMC.popupBuyItemMc.panel.itemNameTxt.text = "Scroll Item";
            this.selectedBuyMaterial = this.SEAL_MATERIAL;
            NinjaSage.loadItemIcon(this.panelMC.popupBuyItemMc.panel.displayHolder,this.SEAL_MATERIAL,"icon");
         }
         this.cost = this.price * this.amount;
         this.panelMC.popupBuyItemMc.panel.numTxt.text = this.amount;
         this.panelMC.popupBuyItemMc.panel.TokenCost.txt_token.text = this.cost;
         this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.buyBtn,MouseEvent.CLICK,this.buyMaterial);
         this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.btnNext,MouseEvent.CLICK,this.changeAmount);
         this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.btnPrev,MouseEvent.CLICK,this.changeAmount);
         this.eventHandler.addListener(this.panelMC.popupBuyItemMc.panel.btnClose,MouseEvent.CLICK,this.closeBuyMaterial);
      }
      
      private function changeAmount(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         var _loc3_:* = this.panelMC.popupBuyItemMc.panel;
         if(this.amount <= 1 && _loc2_ != "btnNext")
         {
            return;
         }
         if(_loc2_ == "btnNext")
         {
            this.amount += 1;
         }
         else
         {
            --this.amount;
         }
         this.cost = this.price * this.amount;
         _loc3_.numTxt.text = this.amount;
         _loc3_.TokenCost.txt_token.text = this.cost;
      }
      
      private function buyMaterial(param1:MouseEvent) : *
      {
         this.main.loading(false);
         this.main.amf_manager.service("uw8zuDzUq5Zgt3o7.3xt1QkxDR15h",[Character.char_id,Character.sessionkey,this.selectedBuyMaterial,this.amount],this.onBuyMaterial);
      }
      
      private function onBuyMaterial(param1:Object = null) : *
      {
         if(param1.status == 1)
         {
            Character.addConsumables(this.selectedBuyMaterial,this.amount);
            Character.account_tokens -= this.cost;
            this.panelMC.popupBuyItemMc.panel.tokenTxt.text = param1.tokens;
            this.panelMC.bossDetailMc.panel.sushiItemTxt.text = String(Character.getConsumableAmount(this.SUSHI_MATERIAL));
            this.panelMC.bossDetailMc.panel.scrollItemTxt.text = String(Character.getConsumableAmount(this.SEAL_MATERIAL));
            this.main.HUD.setBasicData();
            this.main.showMessage(this.amount + " Material bought!");
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
      
      private function openResource(param1:MouseEvent) : *
      {
         this.panelMC.popupGetMoreMc.visible = true;
         this.panelMC.popupGetMoreMc.panel.popup_chart.visible = false;
         this.main.initButton(this.panelMC.popupGetMoreMc.panel.askFriendBtn,this.openResourcePanel,"Events");
         this.main.initButton(this.panelMC.popupGetMoreMc.panel.postBtn,this.openResourcePanel,"Eudemon Garden");
         this.main.initButton(this.panelMC.popupGetMoreMc.panel.huntingHouseBtn,this.openResourcePanel,"Hunting House");
         this.main.initButton(this.panelMC.popupGetMoreMc.panel.geshaponBtn,this.openResourcePanel,"Dragon Gacha");
         this.main.initButton(this.panelMC.popupGetMoreMc.panel.freeGiftBtn,this.openResourcePanel,"Friend Battle");
         this.main.initButton(this.panelMC.popupGetMoreMc.panel.dailyTaskBtn,this.openResourcePanel,"Shadow War");
         this.main.initButton(this.panelMC.popupGetMoreMc.panel.hintsBtn,this.openResourcePanel,"Chart");
         this.eventHandler.addListener(this.panelMC.popupGetMoreMc.panel.btnClose,MouseEvent.CLICK,this.openResourcePanel);
      }
      
      private function openResourcePanel(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "askFriendBtn":
               this.main.loadExternalSwfPanel("EventMenu","EventMenu");
               this.destroy();
               break;
            case "postBtn":
               this.main.loadExternalSwfPanel("EudemonGarden","EudemonGarden");
               this.destroy();
               break;
            case "huntingHouseBtn":
               this.main.loadExternalSwfPanel("HuntingHouse","HuntingHouse");
               this.destroy();
               break;
            case "geshaponBtn":
               this.main.loadExternalSwfPanel("DragonGacha","DragonGacha");
               this.destroy();
               break;
            case "freeGiftBtn":
               this.main.loadExternalSwfPanel("Social","Social");
               this.destroy();
               break;
            case "dailyTaskBtn":
               this.main.loadPanel("Popups.Scroll_Arena");
               this.destroy();
               break;
            case "hintsBtn":
               this.panelMC.popupGetMoreMc.panel.popup_chart.visible = true;
               this.eventHandler.addListener(this.panelMC.popupGetMoreMc.panel.popup_chart.panel.btnClose,MouseEvent.CLICK,this.closeChart);
               break;
            case "btnClose":
               this.panelMC.popupGetMoreMc.visible = false;
         }
      }
      
      private function closeChart(param1:MouseEvent) : *
      {
         this.panelMC.popupGetMoreMc.panel.popup_chart.visible = false;
         this.eventHandler.removeListener(this.panelMC.popupGetMoreMc.panel.popup_chart.btnClose,MouseEvent.CLICK,this.closeChart);
      }
      
      private function closeNoDragonBall(param1:MouseEvent) : *
      {
         this.panelMC.noDragonBallMc.visible = false;
         this.eventHandler.removeListener(this.panelMC.noDragonBallMc.panel.okBtn,MouseEvent.CLICK,this.closeNoDragonBall);
         this.eventHandler.removeListener(this.panelMC.noDragonBallMc.panel.btnClose,MouseEvent.CLICK,this.closeNoDragonBall);
      }
      
      private function closeNoScrollPopup(param1:MouseEvent) : *
      {
         this.panelMC.popupNoScrollMc.visible = false;
         this.eventHandler.removeListener(this.panelMC.popupNoScrollMc.panel.btnClose,MouseEvent.CLICK,this.closeNoScrollPopup);
         this.eventHandler.removeListener(this.panelMC.popupNoScrollMc.panel.attackBtn,MouseEvent.CLICK,this.startBattle);
         this.eventHandler.removeListener(this.panelMC.popupNoScrollMc.panel.buyScrollBtn,MouseEvent.CLICK,this.openBuyMaterial);
      }
      
      private function closeBossDetail(param1:MouseEvent) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            GF.removeAllChild(this.panelMC.bossDetailMc.panel["item" + _loc2_].holder);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            GF.removeAllChild(this.panelMC.bossDetailMc.panel.huntingPassMc["Db_" + _loc2_].DBIcon.iconHolder);
            _loc2_++;
         }
         GF.removeAllChild(this.panelMC.bossDetailMc.panel.detailMc0.bossHolder);
         this.panelMC.bossDetailMc.visible = false;
      }
      
      private function closeBuyMaterial(param1:MouseEvent) : *
      {
         this.panelMC.popupBuyItemMc.visible = false;
         this.amount = 1;
         this.price = 10;
         this.cost = 0;
      }
      
      private function openDetails(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("DragonHuntDetail","DragonHuntDetail");
      }
      
      private function openRewards(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("DragonHuntReward","DragonHuntReward");
      }
      
      private function openRecharge(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function hidePopup() : *
      {
         this.panelMC.popupBuyItemMc.visible = false;
         this.panelMC.popupNoScrollMc.visible = false;
         this.panelMC.noDragonBallMc.visible = false;
         this.panelMC.popUpGetReward.visible = false;
         this.panelMC.bossDetailMc.visible = false;
         this.panelMC.popupGetMoreMc.visible = false;
      }
      
      private function initButton() : *
      {
         this.main.initButton(this.panelMC.detailBtn,this.openDetails,"Details");
         this.main.initButton(this.panelMC.getMoreBtn,this.openResource,"Get Dragon Ball");
         this.main.initButton(this.panelMC.rewardBtn,this.openRewards,"Rewards");
         this.main.initButton(this.panelMC.battleBtn,this.openBossDetail,"Battle");
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
      }
      
      private function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
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
         this.hidePopup();
         var _loc1_:* = 0;
         while(_loc1_ < 7)
         {
            GF.removeAllChild(this.panelMC.dragonBallMc["DBMc_" + _loc1_].iconHolder.DBIcon.iconHolder);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            GF.removeAllChild(this.panelMC.bossDetailMc.panel["item" + _loc1_].holder);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            GF.removeAllChild(this.panelMC.bossDetailMc.panel.huntingPassMc["Db_" + _loc1_].DBIcon.iconHolder);
            _loc1_++;
         }
         GF.removeAllChild(this.panelMC.bossDetailMc.panel.detailMc0.bossHolder);
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.eventHandler.removeAllEventListeners();
         this.main.clearEvents();
         this.main.removeExternalSwfPanel();
         this.bossData = [];
         this.selectedEnemy = -1;
         this.main = null;
         this.eventHandler = null;
         this.response = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
