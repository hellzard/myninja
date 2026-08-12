package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.PreviewManager;
   import Managers.StatManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.EnemyInfo;
   import Storage.GameData;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   public class AnniversaryMenu extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      private var main;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var response:Object;
      
      private var spendingResponse:Object;
      
      private var targetClaim:int;
      
      public var minigameResponse:Object;
      
      private var bossData:Object;
      
      private var milestoneData:Array;
      
      private var minigameData:Array;
      
      private var spendingData:Array;
      
      private var wishingTreeData:Array;
      
      private var selectedBoss:String;
      
      private var REFILL_PRICE:int = 50;
      
      private var REFRESH_COST:int = 50;
      
      private var selectedPreviewSkill:String;
      
      private var selectedPreviewItem:String;
      
      private var loaderSwf:BulkLoader;
      
      private var previewMC:PreviewManager;
      
      private var isMinigameOpen:Boolean = false;
      
      private var outfits:Array;
      
      public function AnniversaryMenu(param1:*, param2:*)
      {
         this.outfits = [];
         var _loc3_:Object = GameData.get("anniv2026");
         var _loc4_:* = {"level":Character.character_lvl};
         super();
         this.bossData = _loc3_.bosses;
         this.minigameData = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.minigame.length)
         {
            this.minigameData.push(_loc3_.minigame[_loc5_].replace("%s",Character.character_gender));
            _loc5_++;
         }
         this.milestoneData = [];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.milestone_battle.length)
         {
            this.milestoneData.push({
               "rewardId":_loc3_.milestone_battle[_loc5_].id.replace("%s",Character.character_gender),
               "rewardReq":_loc3_.milestone_battle[_loc5_].requirement,
               "rewardQty":_loc3_.milestone_battle[_loc5_].quantity
            });
            _loc5_++;
         }
         this.spendingData = [];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.spending.length)
         {
            this.spendingData.push({
               "rewardId":_loc3_.spending[_loc5_].id.replace("%s",Character.character_gender),
               "rewardReq":_loc3_.spending[_loc5_].requirement,
               "rewardQty":_loc3_.spending[_loc5_].quantity
            });
            _loc5_++;
         }
         this.wishingTreeData = Character.fillRewards(_loc3_.wishing_tree);
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.previewItemMC,this.closeItemPreview);
         this.escapeKey.addListener(this.panelMC.previewMC,this.closePreview);
         this.eventHandler = this.main.eventHandler;
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.main.handleVillageHUDVisibility(false);
         this.getEventData();
      }
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.pnf5xcJeNlAD",[Character.char_id,Character.sessionkey],this.onGetEventData);
      }
      
      private function onGetEventData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.updateEnergy();
            this.initUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function updateEnergy() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 12)
         {
            this.panelMC.bossDetailMc.energyMC["heart_" + _loc1_].visible = false;
            if(this.response.energy > _loc1_)
            {
               this.panelMC.bossDetailMc.energyMC["heart_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function hidePanels() : void
      {
         this.panelMC.wishingTreeMC.visible = false;
         this.panelMC.spendingMC.visible = false;
         this.panelMC.milestoneMC.visible = false;
         this.panelMC.rewardListMC.visible = false;
         this.panelMC.specialBossDetailMc.visible = false;
         this.panelMC.bossDetailMc.visible = false;
         this.panelMC.previewMC.visible = false;
         this.panelMC.previewItemMC.visible = false;
         this.panelMC.minigameCoverMC.visible = false;
         this.panelMC.menuMC.visible = false;
      }
      
      private function initUI() : void
      {
         this.hidePanels();
         this.panelMC.menuMC.visible = true;
         this.eventHandler.addListener(this.panelMC.menuMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_rewardList,MouseEvent.CLICK,this.openRewardList);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_sento,MouseEvent.CLICK,this.openSento);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_milestone,MouseEvent.CLICK,this.openMilestone);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_battle,MouseEvent.CLICK,this.openBossDetail);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_minigame,MouseEvent.CLICK,this.openMinigame);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_specialBattle,MouseEvent.CLICK,this.openSpecialBossDetail);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_leaderboard,MouseEvent.CLICK,this.openLeaderboard);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_gacha,MouseEvent.CLICK,this.openGacha);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_spending,MouseEvent.CLICK,this.openSpending);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_wishingTree,MouseEvent.CLICK,this.openWishingTree);
      }
      
      private function refreshEnemyConfirmation(param1:MouseEvent) : void
      {
         this.main.showConfirmation("Are you sure to refresh the boss for " + this.REFRESH_COST + " tokens?",this.refreshEnemyAmf);
      }
      
      private function refreshEnemyAmf() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.7ilOUWbAjUre",[Character.char_id,Character.sessionkey],this.refreshEnemyResponse);
      }
      
      private function refreshEnemyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.account_tokens = int(Character.account_tokens) - this.REFRESH_COST;
            this.response.enemy = param1.enemy;
            this.openBossDetail();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function refillConfirmation(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure to refill full energy for " + this.REFILL_PRICE + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.refillAmf);
         this.panelMC.addChild(this.confirmation);
      }
      
      public function refillAmf(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.main.loading(true);
         if(this.isMinigameOpen)
         {
            this.main.amf_manager.service("zy8Ztqe05vkpqNx0.p6tQ6bn32gPF",[Character.char_id,Character.sessionkey],this.refillResponse);
         }
         else
         {
            this.main.amf_manager.service("zy8Ztqe05vkpqNx0.javU1c9QS1Z1",[Character.char_id,Character.sessionkey],this.refillResponse);
         }
      }
      
      private function refillResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(this.isMinigameOpen)
            {
               this.minigameResponse.energy = param1.energy;
               this.updateMinigameEnergy();
            }
            else
            {
               this.response.energy = param1.energy;
               this.updateEnergy();
            }
            Character.account_tokens = int(Character.account_tokens) - this.REFILL_PRICE;
            this.panelMC.bossDetailMc.tokenTxt.text = Character.account_tokens;
            this.panelMC.minigameCoverMC.tokenTxt.text = Character.account_tokens;
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeBossUI(param1:MouseEvent) : void
      {
         this.panelMC.bossDetailMc.visible = false;
         this.panelMC.menuMC.visible = true;
      }
      
      private function closeSpecialBossDetail(param1:MouseEvent) : void
      {
         this.panelMC.specialBossDetailMc.visible = false;
         this.panelMC.menuMC.visible = true;
      }
      
      private function openBossDetail(param1:MouseEvent = null) : void
      {
         this.hidePanels();
         this.selectedBoss = this.response.enemy;
         this.panelMC.bossDetailMc.visible = true;
         this.panelMC.bossDetailMc.enemyMC.gotoAndStop(this.selectedBoss);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_close,MouseEvent.CLICK,this.closeBossDetail);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_start,MouseEvent.CLICK,this.startBattle);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_refresh,MouseEvent.CLICK,this.refreshEnemyConfirmation);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.energyMC.heartBtn,MouseEvent.CLICK,this.refillConfirmation);
         var _loc2_:* = {"level":Character.character_lvl};
         var _loc3_:Array = [int(Character.character_lvl) + this.bossData[this.selectedBoss].levels[0],int(Character.character_lvl) + this.bossData[this.selectedBoss].levels[1]];
         var _loc4_:int = int(Util.calculateFromString(this.bossData[this.selectedBoss].gold,_loc2_));
         var _loc5_:int = int(Util.calculateFromString(this.bossData[this.selectedBoss].xp,_loc2_));
         this.panelMC.bossDetailMc.txt_refresh.text = this.REFRESH_COST;
         this.panelMC.bossDetailMc.tokenTxt.text = Character.account_tokens;
         this.panelMC.bossDetailMc.goldMc.txt.text = _loc4_;
         this.panelMC.bossDetailMc.xpMc.txt.text = _loc5_;
         this.panelMC.bossDetailMc.txt_name.text = this.bossData[this.selectedBoss].name;
         NinjaSage.showDynamicTooltip(this.panelMC.bossDetailMc.btn_help,"The boss will automatically refresh daily at 00:00 AM (GMT+7). You can also manually refresh the enemy for " + this.REFRESH_COST + " tokens.");
         var _loc6_:int = 0;
         while(_loc6_ < 5)
         {
            this.panelMC.bossDetailMc["iconMc_" + _loc6_].visible = false;
            this.panelMC.bossDetailMc["iconMc_" + _loc6_].btn_preview.visible = false;
            if(this.bossData[this.selectedBoss].rewards.length > _loc6_)
            {
               this.panelMC.bossDetailMc["iconMc_" + _loc6_].visible = true;
               NinjaSage.loadItemIcon(this.panelMC.bossDetailMc["iconMc_" + _loc6_],this.bossData[this.selectedBoss].rewards[_loc6_]);
            }
            this.panelMC.bossDetailMc["iconMc_" + _loc6_].amountTxt.text = "";
            this.panelMC.bossDetailMc["iconMc_" + _loc6_].ownedTxt.text = "";
            _loc6_++;
         }
      }
      
      private function openSpecialBossDetail(param1:MouseEvent = null) : void
      {
         this.hidePanels();
         this.selectedBoss = "ene_525";
         this.panelMC.specialBossDetailMc.visible = true;
         this.panelMC.specialBossDetailMc.enemyMC.gotoAndStop(this.selectedBoss);
         this.eventHandler.addListener(this.panelMC.specialBossDetailMc.btn_close,MouseEvent.CLICK,this.closeSpecialBossDetail);
         this.eventHandler.addListener(this.panelMC.specialBossDetailMc.btn_start,MouseEvent.CLICK,this.startBattle);
         var _loc2_:* = {"level":Character.character_lvl};
         var _loc3_:Array = [int(Character.character_lvl) + this.bossData[this.selectedBoss].levels[0],int(Character.character_lvl) + this.bossData[this.selectedBoss].levels[1]];
         var _loc4_:int = int(Util.calculateFromString(this.bossData[this.selectedBoss].gold,_loc2_));
         var _loc5_:int = int(Util.calculateFromString(this.bossData[this.selectedBoss].xp,_loc2_));
         this.panelMC.specialBossDetailMc.goldMc.txt.text = _loc4_;
         this.panelMC.specialBossDetailMc.xpMc.txt.text = _loc5_;
         var _loc6_:int = 0;
         while(_loc6_ < 5)
         {
            this.panelMC.specialBossDetailMc["iconMc_" + _loc6_].visible = false;
            this.panelMC.specialBossDetailMc["iconMc_" + _loc6_].btn_preview.visible = false;
            if(this.bossData[this.selectedBoss].rewards.length > _loc6_)
            {
               this.panelMC.specialBossDetailMc["iconMc_" + _loc6_].visible = true;
               NinjaSage.loadItemIcon(this.panelMC.specialBossDetailMc["iconMc_" + _loc6_],this.bossData[this.selectedBoss].rewards[_loc6_]);
            }
            this.panelMC.specialBossDetailMc["iconMc_" + _loc6_].amountTxt.text = "";
            this.panelMC.specialBossDetailMc["iconMc_" + _loc6_].ownedTxt.text = "";
            _loc6_++;
         }
      }
      
      private function startBattle(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = this.selectedBoss;
         Character.christmas_boss_num = 0;
         Character.christmas_boss_id = _loc6_;
         _loc2_ = StatManager.calculate_stats_with_data("agility");
         _loc3_ = EnemyInfo.getCopy(_loc6_);
         _loc5_ = "id:" + _loc3_["enemy_id"] + "|hp:" + _loc3_["enemy_hp"] + "|agility:" + _loc3_["enemy_agility"];
         _loc4_ = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.char_id) + String(_loc6_) + _loc5_ + String(_loc2_))));
         this.main.loading(true);
         if(this.selectedBoss == "ene_525")
         {
            this.main.amf_manager.service("zy8Ztqe05vkpqNx0.yWRUrYGIu4WZ",[Character.char_id,_loc6_,_loc2_,_loc5_,_loc4_,Character.sessionkey],this.onStartEventAmf);
         }
         else
         {
            this.main.amf_manager.service("zy8Ztqe05vkpqNx0.t8pP9xblFuBW",[Character.char_id,_loc6_,_loc2_,_loc5_,_loc4_,Character.sessionkey],this.onStartEventAmf);
         }
      }
      
      private function onStartEventAmf(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(param1.hash != Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.christmas_boss_id) + param1.code + Character.char_id))))
            {
               this.main.showMessage(param1.result);
               return;
            }
            if(this.selectedBoss == "ene_525")
            {
               Character.is_anniversary_spenemy_event = true;
            }
            else
            {
               Character.is_anniversary_event = true;
            }
            Character.battle_code = param1.code;
            Character.mission_id = this.bossData[this.selectedBoss].background;
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.EVENT_MATCH,Character.mission_id);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            _loc2_ = 0;
            while(_loc2_ < this.bossData[this.selectedBoss].id.length)
            {
               BattleManager.addPlayerToTeam("enemy",this.bossData[this.selectedBoss].id[_loc2_]);
               _loc2_++;
            }
            BattleManager.startBattle();
            this.destroy();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeBossDetail(param1:MouseEvent) : void
      {
         this.panelMC.bossDetailMc.visible = false;
         this.panelMC.menuMC.visible = true;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            GF.removeAllChild(this.panelMC.bossDetailMc["iconMc_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.bossDetailMc["iconMc_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function openMilestone(param1:MouseEvent) : *
      {
         this.hidePanels();
         this.panelMC.milestoneMC.visible = true;
         this.panelMC.menuMC.visible = false;
         this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close,MouseEvent.CLICK,this.closeMilestone);
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.LjRaBRuy6E9A",[Character.char_id,Character.sessionkey],this.openMilestoneRewards);
         var _loc2_:* = 0;
         while(_loc2_ < 8)
         {
            this.panelMC.milestoneMC["reward_" + _loc2_]["txt_requiredBattle"].text = String(this.milestoneData[_loc2_].rewardReq) + " Battles";
            this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].amountTxt.text = this.milestoneData[_loc2_].rewardQty <= 1 ? "" : "x" + this.milestoneData[_loc2_].rewardQty;
            this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].ownedTxt.visible = false;
            if(Character.hasSkill(this.milestoneData[_loc2_].rewardId) > 0)
            {
               this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].ownedTxt.visible = true;
               this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.milestoneData[_loc2_].rewardId) > 0)
            {
               this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].ownedTxt.visible = true;
               this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].ownedTxt.text = "Owned";
            }
            this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].btn_preview.visible = this.checkIsItemOrSkill(this.milestoneData[_loc2_].rewardId);
            this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].btn_preview.metaData = {"itemId":this.milestoneData[_loc2_].rewardId};
            this.eventHandler.addListener(this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].btn_preview,MouseEvent.CLICK,this.openPreview);
            NinjaSage.loadItemIcon(this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"],this.milestoneData[_loc2_].rewardId);
            _loc2_++;
         }
      }
      
      private function openMilestoneRewards(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.milestoneMC.txt_draws.text = "Battles: " + param1.milestone;
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               _loc3_ = param1.rewards[_loc2_] == false && param1.milestone >= this.milestoneData[_loc2_].rewardReq ? true : false;
               _loc4_ = param1.rewards[_loc2_] == true;
               this.panelMC.milestoneMC["reward_" + _loc2_]["btn_claim"].visible = _loc3_;
               this.panelMC.milestoneMC["reward_" + _loc2_].lock.visible = true;
               if(_loc3_)
               {
                  this.panelMC.milestoneMC["reward_" + _loc2_].lock.visible = false;
                  this.eventHandler.addListener(this.panelMC.milestoneMC["reward_" + _loc2_]["btn_claim"],MouseEvent.CLICK,this.onClaimBonusRequest);
               }
               if(_loc4_)
               {
                  this.panelMC.milestoneMC["reward_" + _loc2_].lock.visible = false;
               }
               _loc2_++;
            }
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function onClaimBonusRequest(param1:MouseEvent) : *
      {
         var _loc2_:int = int(param1.currentTarget.parent.name.replace("reward_",""));
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.0nX6f07iO18j",[Character.char_id,Character.sessionkey,_loc2_],this.onClaimBonusResponse);
      }
      
      private function onClaimBonusResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.addRewards(param1.reward);
            this.main.HUD.setBasicData();
            this.main.giveReward(1,param1.reward,"winter");
            this.openMilestone(null);
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function closeMilestone(param1:MouseEvent) : *
      {
         this.panelMC.milestoneMC.visible = false;
         this.panelMC.menuMC.visible = true;
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            GF.removeAllChild(this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function openRewardList(param1:MouseEvent) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         this.hidePanels();
         this.panelMC.rewardListMC.visible = true;
         this.eventHandler.addListener(this.panelMC.rewardListMC.btn_close,MouseEvent.CLICK,this.closeRewardList);
         this.eventHandler.addListener(this.panelMC.rewardListMC.btn_mm,MouseEvent.CLICK,this.openMaterialMarket);
         var _loc2_:Object = GameData.get("anniv2026");
         var _loc3_:Array = ["hair","set","back","weapon","skill"];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc2_.rewards_preview[_loc3_[_loc4_]];
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
               this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].visible = false;
               this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].amountTxt.text = "";
               this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].btn_preview.visible = false;
               if(_loc6_ < _loc5_.length)
               {
                  _loc7_ = _loc5_[_loc6_].replace("%s",Character.character_gender);
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].visible = true;
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].btn_preview.visible = this.checkIsItemOrSkill(_loc7_);
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].btn_preview.metaData = {"itemId":_loc7_};
                  this.eventHandler.addListener(this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].btn_preview,MouseEvent.CLICK,this.openPreview);
                  NinjaSage.loadItemIcon(this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_],_loc7_);
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].ownedTxt.visible = false;
                  if(Character.hasSkill(_loc7_) > 0)
                  {
                     this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].ownedTxt.visible = true;
                     this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].ownedTxt.text = "Owned";
                  }
                  if(Character.isItemOwned(_loc7_) > 0)
                  {
                     this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].ownedTxt.visible = true;
                     this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].ownedTxt.text = "Owned";
                  }
               }
               _loc6_++;
            }
            _loc4_++;
         }
      }
      
      private function closeRewardList(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.panelMC.rewardListMC.visible = false;
         this.panelMC.menuMC.visible = true;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               GF.removeAllChild(this.panelMC.rewardListMC["item_" + _loc2_]["iconMC_" + _loc3_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.rewardListMC["item_" + _loc2_]["iconMC_" + _loc3_].skillIcon.iconHolder);
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function openWishingTree(param1:MouseEvent) : void
      {
         this.panelMC.wishingTreeMC.visible = true;
         this.panelMC.wishingTreeMC.rewardListMC.visible = false;
         this.panelMC.wishingTreeMC.rewardMC.visible = false;
         this.panelMC.menuMC.visible = false;
         this.eventHandler.addListener(this.panelMC.wishingTreeMC.btn_close,MouseEvent.CLICK,this.closeWishingTree);
         this.eventHandler.addListener(this.panelMC.wishingTreeMC.btn_claim,MouseEvent.CLICK,this.claimWishingTree);
         this.eventHandler.addListener(this.panelMC.wishingTreeMC.btn_rewardList,MouseEvent.CLICK,this.openWishingTreeRewardList);
      }
      
      private function claimWishingTree(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.UUJBUKxQlMIv",[Character.char_id,Character.sessionkey],this.onClaimWishingTree);
      }
      
      private function onClaimWishingTree(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.addRewards(param1.reward);
            this.main.HUD.setBasicData();
            this.showWishingTreeReward(param1.reward);
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function showWishingTreeReward(param1:String) : void
      {
         this.panelMC.wishingTreeMC.rewardMC.visible = true;
         this.eventHandler.addListener(this.panelMC.wishingTreeMC.rewardMC.btn_confirm,MouseEvent.CLICK,this.closeWishingTreeReward);
         NinjaSage.loadItemIcon(this.panelMC.wishingTreeMC.rewardMC["IconMc"],param1);
         this.panelMC.wishingTreeMC.rewardMC["IconMc"].ownedTxt.visible = false;
         this.panelMC.wishingTreeMC.rewardMC["IconMc"].amountTxt.visible = false;
         this.panelMC.wishingTreeMC.rewardMC["IconMc"].btn_preview.visible = this.checkIsItemOrSkill(param1);
         this.panelMC.wishingTreeMC.rewardMC["IconMc"].btn_preview.metaData = {"itemId":param1};
         this.eventHandler.addListener(this.panelMC.wishingTreeMC.rewardMC["IconMc"].btn_preview,MouseEvent.CLICK,this.openPreview);
         if(Character.hasSkill(param1) > 0)
         {
            this.panelMC.wishingTreeMC.rewardMC["IconMc"].ownedTxt.visible = true;
            this.panelMC.wishingTreeMC.rewardMC["IconMc"].ownedTxt.text = "Owned";
         }
         if(Character.isItemOwned(param1) > 0)
         {
            this.panelMC.wishingTreeMC.rewardMC["IconMc"].ownedTxt.visible = true;
            this.panelMC.wishingTreeMC.rewardMC["IconMc"].ownedTxt.text = "Owned";
         }
      }
      
      private function closeWishingTreeReward(param1:MouseEvent) : void
      {
         this.panelMC.wishingTreeMC.rewardMC.visible = false;
         GF.removeAllChild(this.panelMC.wishingTreeMC.rewardMC["IconMc"].rewardIcon.iconHolder);
         GF.removeAllChild(this.panelMC.wishingTreeMC.rewardMC["IconMc"].skillIcon.iconHolder);
      }
      
      private function openWishingTreeRewardList(param1:MouseEvent) : void
      {
         this.panelMC.wishingTreeMC.rewardListMC.visible = true;
         this.eventHandler.addListener(this.panelMC.wishingTreeMC.rewardListMC.btn_close,MouseEvent.CLICK,this.closeWishingTreeRewardList);
         var _loc2_:int = 0;
         while(_loc2_ < this.wishingTreeData.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_],this.wishingTreeData[_loc2_]);
            this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].btn_preview.visible = this.checkIsItemOrSkill(this.wishingTreeData[_loc2_]);
            this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].btn_preview.metaData = {"itemId":this.wishingTreeData[_loc2_]};
            this.eventHandler.addListener(this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].btn_preview,MouseEvent.CLICK,this.openPreview);
            this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].ownedTxt.visible = false;
            this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].amountTxt.visible = false;
            if(Character.hasSkill(this.wishingTreeData[_loc2_]) > 0)
            {
               this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].ownedTxt.visible = true;
               this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.wishingTreeData[_loc2_]) > 0)
            {
               this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].ownedTxt.visible = true;
               this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].ownedTxt.text = "Owned";
            }
            _loc2_++;
         }
      }
      
      private function closeWishingTreeRewardList(param1:MouseEvent) : void
      {
         this.panelMC.wishingTreeMC.rewardListMC.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.wishingTreeData.length)
         {
            GF.removeAllChild(this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.wishingTreeMC.rewardListMC["IconMc_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function closeWishingTree(param1:MouseEvent) : void
      {
         this.panelMC.wishingTreeMC.visible = false;
         this.panelMC.menuMC.visible = true;
      }
      
      private function openPreview(param1:MouseEvent) : void
      {
         if(param1.currentTarget.metaData.itemId.indexOf("skill_") >= 0)
         {
            this.handleSkillPreview(param1.currentTarget.metaData.itemId);
         }
         else
         {
            this.handleItemPreview(param1.currentTarget.metaData.itemId);
         }
      }
      
      private function handleItemPreview(param1:String) : void
      {
         this.panelMC.previewItemMC.visible = true;
         this.eventHandler.addListener(this.panelMC.previewItemMC.btn_close,MouseEvent.CLICK,this.closeItemPreview);
         this.selectedPreviewItem = param1;
         var _loc2_:* = new OutfitManager(false);
         var _loc3_:* = param1.indexOf("wpn") >= 0 ? param1 : Character.character_weapon;
         var _loc4_:* = param1.indexOf("back") >= 0 ? param1 : Character.character_back_item;
         var _loc5_:* = param1.indexOf("set") >= 0 ? param1 : Character.character_set;
         var _loc6_:* = param1.indexOf("hair") >= 0 ? param1 : Character.character_hair;
         _loc2_.fillOutfit(this.panelMC.previewItemMC.char_mc,_loc3_,_loc4_,_loc5_,_loc6_,Character.character_face,Character.character_color_hair,Character.character_color_skin);
         this.outfits.push(_loc2_);
      }
      
      private function closeItemPreview(param1:MouseEvent) : void
      {
         this.panelMC.previewItemMC.visible = false;
         GF.destroyArray(this.outfits);
         OutfitManager.clearStaticMc();
         this.outfits = [];
      }
      
      private function handleSkillPreview(param1:String) : void
      {
         this.panelMC.previewMC.visible = true;
         this.eventHandler.addListener(this.panelMC.previewMC.btn_close,MouseEvent.CLICK,this.closePreview);
         this.eventHandler.addListener(this.panelMC.previewMC.btn_replay,MouseEvent.CLICK,this.handleReplay);
         this.selectedPreviewSkill = param1;
         this.loadSkillAndPreview();
      }
      
      private function loadSkillAndPreview() : void
      {
         var _loc1_:* = "skills/" + this.selectedPreviewSkill + ".swf";
         var _loc2_:* = this.loaderSwf.add(_loc1_);
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.completePreview);
         this.loaderSwf.start();
      }
      
      private function completePreview(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = SkillLibrary.getSkillInfo(this.selectedPreviewSkill);
         var _loc4_:MovieClip = param1.target.content[this.selectedPreviewSkill];
         this.previewMC = new PreviewManager(this.main,_loc4_,_loc3_);
         this.panelMC.previewMC.skillMc.scaleX = 1.3;
         this.panelMC.previewMC.skillMc.scaleY = 1.3;
         this.panelMC.previewMC.skillMc.addChild(this.previewMC.preview_mc);
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function closePreview(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.panelMC.previewMC.skillMc);
         if(this.previewMC)
         {
            this.previewMC.destroy();
         }
         this.previewMC = null;
         this.panelMC.previewMC.visible = false;
      }
      
      private function openMinigame(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.wZMqtoCKRYMA",[Character.char_id,Character.sessionkey],this.onGetMinigameData);
      }
      
      private function onGetMinigameData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.minigameResponse = param1;
            this.openMinigameUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openMinigameUI() : void
      {
         this.isMinigameOpen = true;
         this.panelMC.minigameCoverMC.visible = true;
         this.panelMC.minigameCoverMC.txt_desc.text = "Match the food";
         this.eventHandler.addListener(this.panelMC.minigameCoverMC.btn_close,MouseEvent.CLICK,this.closeMinigame);
         this.eventHandler.addListener(this.panelMC.minigameCoverMC.heartBtn,MouseEvent.CLICK,this.refillConfirmation);
         this.eventHandler.addListener(this.panelMC.minigameCoverMC.btn_start,MouseEvent.CLICK,this.startMinigame);
         this.eventHandler.addListener(this.panelMC.minigameCoverMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.panelMC.minigameCoverMC.tokenTxt.text = Character.account_tokens;
         this.updateMinigameEnergy();
         var _loc1_:int = 0;
         while(_loc1_ < this.minigameData.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.minigameCoverMC["iconMc_" + _loc1_],this.minigameData[_loc1_]);
            this.panelMC.minigameCoverMC["iconMc_" + _loc1_].amountTxt.text = "";
            this.panelMC.minigameCoverMC["iconMc_" + _loc1_].btn_preview.visible = this.checkIsItemOrSkill(this.minigameData[_loc1_]);
            this.panelMC.minigameCoverMC["iconMc_" + _loc1_].btn_preview.metaData = {"itemId":this.minigameData[_loc1_]};
            this.eventHandler.addListener(this.panelMC.minigameCoverMC["iconMc_" + _loc1_].btn_preview,MouseEvent.CLICK,this.openPreview);
            this.panelMC.minigameCoverMC["iconMc_" + _loc1_].ownedTxt.visible = false;
            if(Character.hasSkill(this.minigameData[_loc1_]) > 0)
            {
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].ownedTxt.visible = true;
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.minigameData[_loc1_]) > 0)
            {
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].ownedTxt.visible = true;
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].ownedTxt.text = "Owned";
            }
            _loc1_++;
         }
      }
      
      private function startMinigame(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.6yVDmzCYrmAp",[Character.char_id,Character.sessionkey],this.onStartMinigame);
      }
      
      private function onStartMinigame(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.battle_code = param1.code;
            this.panelMC.minigameCoverMC.visible = false;
            this.main.loadExternalSwfPanel("AnniversaryMinigame","AnniversaryMinigame");
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openSpending(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.IP78ucGRVVCl",[Character.char_id,Character.sessionkey],this.onGetSpendingData);
      }
      
      private function onGetSpendingData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.spendingResponse = param1;
            this.initSpendingUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.closeSpending(null);
         }
      }
      
      private function initSpendingUI() : void
      {
         this.panelMC.spendingMC.visible = true;
         this.panelMC.menuMC.visible = false;
         this.eventHandler.addListener(this.panelMC.spendingMC.btnClose,MouseEvent.CLICK,this.closeSpending);
         this.panelMC.spendingMC.tokenTxt.text = this.spendingResponse.spent;
         var _loc1_:int = 0;
         while(_loc1_ < 13)
         {
            this.panelMC.spendingMC["IconMc_" + _loc1_].tokenTxt.text = this.spendingData[_loc1_].rewardReq;
            if(this.spendingResponse.spent < this.spendingData[_loc1_].rewardReq || this.spendingResponse.rewards[_loc1_] == 1)
            {
               this.main.initButtonDisable(this.panelMC.spendingMC["IconMc_" + _loc1_].claimBtn,this.claimSpending,"Claim");
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.lockMC.visible = true;
            }
            else
            {
               this.main.initButton(this.panelMC.spendingMC["IconMc_" + _loc1_].claimBtn,this.claimSpending,"Claim");
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.lockMC.visible = false;
            }
            if(this.spendingResponse.rewards[_loc1_] == 1)
            {
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.tickMC.visible = true;
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.lockMC.visible = false;
            }
            else
            {
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.tickMC.visible = false;
            }
            this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.amountTxt.visible = false;
            this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.ownedTxt.visible = false;
            if(Character.hasSkill(this.spendingData[_loc1_].rewardId) > 0)
            {
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.ownedTxt.visible = true;
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.spendingData[_loc1_].rewardId) > 0)
            {
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.ownedTxt.visible = true;
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.ownedTxt.text = "Owned";
            }
            if(this.spendingData[_loc1_].rewardQty > 1)
            {
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.amountTxt.visible = true;
               this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.amountTxt.text = "x" + String(this.spendingData[_loc1_].rewardQty);
            }
            this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.btn_preview.visible = this.checkIsItemOrSkill(this.spendingData[_loc1_].rewardId);
            this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.btn_preview.metaData = {"itemId":this.spendingData[_loc1_].rewardId};
            this.eventHandler.addListener(this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc.btn_preview,MouseEvent.CLICK,this.openPreview);
            NinjaSage.loadItemIcon(this.panelMC.spendingMC["IconMc_" + _loc1_].IconMc,this.spendingData[_loc1_].rewardId);
            _loc1_++;
         }
      }
      
      private function claimSpending(param1:MouseEvent) : void
      {
         this.targetClaim = int(param1.currentTarget.parent.name.replace("IconMc_",""));
         this.main.loading(false);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.71HcQfQezUjM",[Character.char_id,Character.sessionkey,this.spendingData[this.targetClaim].rewardReq],this.onSpendingClaimed);
      }
      
      private function onSpendingClaimed(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1.status == 1)
         {
            _loc2_ = this.spendingData[this.targetClaim].rewardId + ":" + this.spendingData[this.targetClaim].rewardQty;
            Character.addRewards(_loc2_);
            this.main.giveReward(1,_loc2_,"anniversary");
            this.spendingResponse.rewards[this.targetClaim] = 1;
            this.initSpendingUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeSpending(param1:MouseEvent) : void
      {
         this.panelMC.spendingMC.visible = false;
         this.panelMC.menuMC.visible = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.spendingData.length)
         {
            GF.removeAllChild(this.panelMC.spendingMC["IconMc_" + _loc2_].IconMc.rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.spendingMC["IconMc_" + _loc2_].IconMc.skillIcon.iconHolder);
            _loc2_++;
         }
         this.spendingResponse = null;
      }
      
      public function showThisPanel() : void
      {
         this.panelMC.visible = true;
         this.updateMinigameEnergy();
      }
      
      public function hideThisPanel() : void
      {
         this.panelMC.visible = false;
      }
      
      private function checkIsItemOrSkill(param1:String) : Boolean
      {
         var _loc2_:Array = ["skill_","hair_","set_","back_","wpn_"];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1.indexOf(_loc2_[_loc3_]) >= 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function updateMinigameEnergy() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this.panelMC.minigameCoverMC["heart_" + _loc1_].visible = false;
            if(this.minigameResponse.energy > _loc1_)
            {
               this.panelMC.minigameCoverMC["heart_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function closeMinigame(param1:MouseEvent) : void
      {
         this.isMinigameOpen = false;
         this.panelMC.minigameCoverMC.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.minigameData.length)
         {
            GF.removeAllChild(this.panelMC.minigameCoverMC["iconMc_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.minigameCoverMC["iconMc_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openMaterialMarket(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.MaterialMarket");
      }
      
      private function openLeaderboard(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("Leaderboard","Leaderboard");
      }
      
      private function openGacha(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("AnniversaryGacha","AnniversaryGacha");
      }
      
      private function openSento(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("AnniversarySento","AnniversarySento");
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
         GF.removeAllChild(this.panelMC);
         NinjaSage.clearLoader();
         this.loaderSwf.clear();
         this.loaderSwf = null;
         this.eventHandler.removeAllEventListeners();
         if(this.previewMC)
         {
            this.previewMC.destroy();
         }
         this.previewMC = null;
         this.eventHandler = null;
         this.panelMC = null;
         this.response = null;
         this.bossData = null;
         this.milestoneData = null;
         this.minigameData = null;
         this.main = null;
      }
   }
}
