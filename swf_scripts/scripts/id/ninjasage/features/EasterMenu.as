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
   
   public class EasterMenu extends MovieClip
   {
      
      private var main:*;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      private var confirmation:Confirmation;
      
      private var response:Object;
      
      private var bossData:Array;
      
      private var milestoneData:Array;
      
      private var packageData:Object;
      
      private var skillData:Array;
      
      private var REFILL_PRICE:int = 50;
      
      private var selectedBuySkill:int = -1;
      
      private var selectedPreviewSkill:String;
      
      private var selectedPreviewItem:String;
      
      private var selectedBoss:int = 0;
      
      private var skillPrice:int;
      
      private var milestoneTarget:int;
      
      private var loaderSwf:BulkLoader;
      
      private var previewMC:PreviewManager;
      
      private var outfits:Array = [];
      
      private var outfitsPreview:Array = [];
      
      private var storyText:String;
      
      private var eggsData:Array = [];
      
      public function EasterMenu(param1:*, param2:*)
      {
         var _loc3_:Object = GameData.get("easter2026");
         var _loc4_:* = {"level":Character.character_lvl};
         super();
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
               "bossReward":_loc3_.bosses[_loc5_].rewards,
               "bossBackground":_loc3_.bosses[_loc5_].background
            });
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
         this.packageData = {
            "packageName":_loc3_.paket.name,
            "packagePrice":_loc3_.paket.price,
            "packageRewards":_loc3_.paket.rewards
         };
         this.storyText = _loc3_.story;
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.eventHandler = this.main.eventHandler;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.main.handleVillageHUDVisibility(false);
         this.getEventData();
      }
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.ubKx5QXNCvfi",[Character.char_id,Character.sessionkey],this.onGetEventData);
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
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function updateEnergy() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.panelMC.battleMC["heart_" + _loc1_].visible = false;
            if(this.response.energy > _loc1_)
            {
               this.panelMC.battleMC["heart_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function initUI() : void
      {
         this.hidePanels();
         this.panelMC.menuMC.visible = true;
         this.eventHandler.addListener(this.panelMC.menuMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_rewardList,MouseEvent.CLICK,this.openRewardList);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_battle,MouseEvent.CLICK,this.openBossBattle);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_gacha,MouseEvent.CLICK,this.openGacha);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_milestone,MouseEvent.CLICK,this.openMilestone);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_story,MouseEvent.CLICK,this.openStory);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_package,MouseEvent.CLICK,this.openPackage);
         this.eventHandler.addListener(this.panelMC.battleMC.heartBtn,MouseEvent.CLICK,this.refillConfirmation);
         this.eventHandler.addListener(this.panelMC.battleMC.btn_recruit,MouseEvent.CLICK,this.openSocial);
         this.initEscapeKey();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.eventHandler.addListener(this.panelMC.menuMC.eggs["egg_" + _loc1_],MouseEvent.CLICK,this.onCheckEggReward);
            _loc1_++;
         }
      }
      
      private function onCheckEggReward(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("egg_","");
         if(this.eggsData.length < 4)
         {
            this.eggsData.push(int(_loc2_) + 1);
         }
         if(this.checkEggReward())
         {
            this.main.loading(true);
            this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.9bDAp8krljJk",[Character.char_id,Character.sessionkey,this.eggsData],this.onClaimEggRewardRes);
         }
      }
      
      private function checkEggReward() : Boolean
      {
         if(this.eggsData.length != 4)
         {
            return false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            if(this.eggsData[_loc1_] != _loc1_ + 1)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function onClaimEggRewardRes(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.addRewards(param1.rewards);
            this.main.HUD.setBasicData();
            this.main.giveReward(1,param1.rewards,"easter");
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function initEscapeKey() : void
      {
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.battleMC,this.closeBossBattle);
         this.escapeKey.addListener(this.panelMC.milestoneMC,this.closeMilestone);
         this.escapeKey.addListener(this.panelMC.rewardListMC,this.closeRewardList);
         this.escapeKey.addListener(this.panelMC.packageMC,this.closePackage);
         this.escapeKey.addListener(this.panelMC.storyMC,this.closeStory);
         this.escapeKey.addListener(this.panelMC.previewItemMC,this.closeItemPreview);
         this.escapeKey.addListener(this.panelMC.previewMC,this.closePreview);
      }
      
      private function openBossBattle(param1:MouseEvent) : void
      {
         this.hidePanels();
         this.panelMC.battleMC.visible = true;
         this.panelMC.menuMC.visible = false;
         this.panelMC.battleMC.tokenTxt.text = Character.account_tokens;
         this.eventHandler.addListener(this.panelMC.battleMC.btn_close,MouseEvent.CLICK,this.closeBossBattle);
         this.eventHandler.addListener(this.panelMC.battleMC.btn_start,MouseEvent.CLICK,this.startBattle);
         this.eventHandler.addListener(this.panelMC.battleMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.updateBossUI();
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            this.panelMC.battleMC["boss_" + _loc2_].txt_name.text = this.bossData[_loc2_].bossName;
            this.panelMC.battleMC["boss_" + _loc2_].enemyMC.gotoAndStop(_loc2_ + 1);
            this.panelMC.battleMC["boss_" + _loc2_].buttonMode = true;
            this.eventHandler.addListener(this.panelMC.battleMC["boss_" + _loc2_],MouseEvent.CLICK,this.updateBossUI);
            _loc2_++;
         }
      }
      
      private function updateBossUI(param1:MouseEvent = null) : void
      {
         this.selectedBoss = param1 is MouseEvent ? int(param1.currentTarget.name.replace("boss_","")) : 0;
         this.panelMC.battleMC.txt_name.text = this.bossData[this.selectedBoss].bossName;
         this.panelMC.battleMC.goldMc.txt.text = this.bossData[this.selectedBoss].bossGold;
         this.panelMC.battleMC.xpMc.txt.text = this.bossData[this.selectedBoss].bossXp;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            this.panelMC.battleMC["iconMc_" + _loc2_].visible = false;
            if(this.bossData[this.selectedBoss].bossReward.length > _loc2_)
            {
               this.panelMC.battleMC["iconMc_" + _loc2_].visible = true;
               this.panelMC.battleMC["iconMc_" + _loc2_].btn_preview.visible = this.checkIsItemOrSkill(this.bossData[this.selectedBoss].bossReward[_loc2_]);
               this.panelMC.battleMC["iconMc_" + _loc2_].btn_preview.metaData = {"itemId":this.bossData[this.selectedBoss].bossReward[_loc2_]};
               this.eventHandler.addListener(this.panelMC.battleMC["iconMc_" + _loc2_].btn_preview,MouseEvent.CLICK,this.openPreview);
               NinjaSage.loadItemIcon(this.panelMC.battleMC["iconMc_" + _loc2_],this.bossData[this.selectedBoss].bossReward[_loc2_]);
            }
            this.panelMC.battleMC["boss_" + _loc2_].selected.visible = false;
            this.panelMC.battleMC["iconMc_" + _loc2_].amountTxt.text = "";
            this.panelMC.battleMC["iconMc_" + _loc2_].ownedTxt.text = "";
            _loc2_++;
         }
         this.panelMC.battleMC["boss_" + this.selectedBoss].selected.visible = true;
      }
      
      private function closeBossBattle(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            this.panelMC.battleMC["boss_" + _loc2_].buttonMode = false;
            GF.removeAllChild(this.panelMC.battleMC["iconMc_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.battleMC["iconMc_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         this.panelMC.battleMC.visible = false;
         this.panelMC.menuMC.visible = true;
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
      
      private function refillConfirmation(param1:MouseEvent) : void
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure to refill full energy for " + this.REFILL_PRICE + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.refillAmf);
         this.panelMC.addChild(this.confirmation);
         this.escapeKey.addListener(this.confirmation,this.closeConfirmation);
      }
      
      public function refillAmf(param1:MouseEvent) : *
      {
         this.escapeKey.removeListener(this.confirmation,this.closeConfirmation);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.LDAPFNVxK4mx",[Character.char_id,Character.sessionkey],this.refillResponse);
      }
      
      private function refillResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response.energy = param1.energy;
            Character.account_tokens = int(Character.account_tokens) - this.REFILL_PRICE;
            this.panelMC.battleMC.tokenTxt.text = Character.account_tokens;
            this.main.HUD.setBasicData();
            this.updateEnergy();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function startBattle(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = this.bossData[this.selectedBoss].bossId[0];
         Character.christmas_boss_num = 0;
         Character.christmas_boss_id = _loc6_;
         _loc2_ = StatManager.calculate_stats_with_data("agility");
         _loc3_ = EnemyInfo.getCopy(_loc6_);
         _loc5_ = "id:" + _loc3_["enemy_id"] + "|hp:" + _loc3_["enemy_hp"] + "|agility:" + _loc3_["enemy_agility"];
         _loc4_ = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.char_id) + String(_loc6_) + _loc5_ + String(_loc2_))));
         this.main.loading(true);
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.xjm2BYeD0iEi",[Character.char_id,_loc6_,_loc2_,_loc5_,_loc4_,Character.sessionkey],this.onStartEventAmf);
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
            Character.is_easter_event = true;
            Character.battle_code = param1.code;
            Character.mission_id = this.bossData[this.selectedBoss].bossBackground;
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.EVENT_MATCH,Character.mission_id);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            _loc2_ = 0;
            while(_loc2_ < this.bossData[this.selectedBoss].bossId.length)
            {
               BattleManager.addPlayerToTeam("enemy",this.bossData[this.selectedBoss].bossId[_loc2_]);
               _loc2_++;
            }
            BattleManager.startBattle();
            this.destroy();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openMilestone(param1:MouseEvent) : *
      {
         this.hidePanels();
         this.panelMC.milestoneMC.visible = true;
         this.panelMC.menuMC.visible = false;
         this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close,MouseEvent.CLICK,this.closeMilestone);
         this.main.loading(true);
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.iPhYuXOmoneK",[Character.char_id,Character.sessionkey],this.openMilestoneRewards);
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
            this.panelMC.milestoneMC.txt_draws.text = "Total Battles: " + param1.milestone;
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               _loc3_ = param1.rewards[_loc2_] == false && param1.milestone >= this.milestoneData[_loc2_].rewardReq ? true : false;
               _loc4_ = param1.rewards[_loc2_] == true;
               this.panelMC.milestoneMC["reward_" + _loc2_]["btn_claim"].visible = _loc3_;
               if(_loc3_)
               {
                  this.eventHandler.addListener(this.panelMC.milestoneMC["reward_" + _loc2_]["btn_claim"],MouseEvent.CLICK,this.onClaimBonusRequest);
               }
               _loc2_++;
            }
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function onClaimBonusRequest(param1:MouseEvent) : *
      {
         var _loc2_:int = int(param1.currentTarget.parent.name.replace("reward_",""));
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.SfU2Z2XVIZB2",[Character.char_id,Character.sessionkey,_loc2_],this.onClaimBonusResponse);
      }
      
      private function onClaimBonusResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.addRewards(param1.reward);
            this.main.HUD.setBasicData();
            this.main.giveReward(1,param1.reward,"easter");
            this.openMilestone(null);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
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
         this.panelMC.rewardListMC.visible = true;
         this.eventHandler.addListener(this.panelMC.rewardListMC.btn_close,MouseEvent.CLICK,this.closeRewardList);
         this.eventHandler.addListener(this.panelMC.rewardListMC.btn_mm,MouseEvent.CLICK,this.openMaterialMarket);
         var _loc2_:Object = GameData.get("easter2026");
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
      
      private function openTraining(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.hidePanels();
         this.panelMC.trainingMC.visible = true;
         this.eventHandler.addListener(this.panelMC.trainingMC.btn_close,MouseEvent.CLICK,this.closeTraining);
         var _loc2_:int = 0;
         while(_loc2_ < this.skillData.length)
         {
            this.panelMC.trainingMC["txt_skill_" + _loc2_].text = this.skillData[_loc2_].skillName;
            this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].amountTxt.text = "";
            this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].ownedTxt.text = "";
            this.panelMC.trainingMC["skill_" + _loc2_]["price_0"].text = this.skillData[_loc2_].skillPrice[0];
            this.panelMC.trainingMC["skill_" + _loc2_]["price_1"].text = this.skillData[_loc2_].skillPrice[1];
            this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].btn_preview.visible = this.checkIsItemOrSkill(this.skillData[_loc2_].skillId);
            this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].btn_preview.metaData = {"itemId":this.skillData[_loc2_].skillId};
            this.eventHandler.addListener(this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].btn_preview,MouseEvent.CLICK,this.openPreview);
            NinjaSage.loadItemIcon(this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"],this.skillData[_loc2_].skillId);
            this.eventHandler.addListener(this.panelMC.trainingMC["skill_" + _loc2_].btn_emblem,MouseEvent.CLICK,this.openRecharge);
            this.eventHandler.addListener(this.panelMC.trainingMC["skill_" + _loc2_].btn_preview,MouseEvent.CLICK,this.openPreview);
            this.eventHandler.addListener(this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_0,MouseEvent.CLICK,this.showConfirmationSkill);
            this.eventHandler.addListener(this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_1,MouseEvent.CLICK,this.showConfirmationSkill);
            if(Character.account_type == 0)
            {
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_0.visible = true;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_1.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_emblem.visible = true;
            }
            else
            {
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_0.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_1.visible = true;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_emblem.visible = false;
            }
            if(Character.hasSkill(this.skillData[_loc2_].skillId) > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this.panelMC.trainingMC["skill_" + _loc3_].btn_buy_0.visible = false;
                  this.panelMC.trainingMC["skill_" + _loc3_].btn_buy_1.visible = false;
                  this.panelMC.trainingMC["skill_" + _loc3_].btn_emblem.visible = false;
                  _loc3_++;
               }
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_0.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_1.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_emblem.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].ownedTxt.text = "Owned";
            }
            _loc2_++;
         }
      }
      
      private function openGacha(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("EasterGacha","EasterGacha");
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
         this.outfitsPreview.push(_loc2_);
      }
      
      private function closeItemPreview(param1:MouseEvent) : void
      {
         this.panelMC.previewItemMC.visible = false;
         GF.destroyArray(this.outfitsPreview);
         this.outfitsPreview = [];
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
         this.panelMC.previewMC.skillMc.scaleX = 1.6;
         this.panelMC.previewMC.skillMc.scaleY = 1.6;
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
      
      private function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function showConfirmationSkill(param1:MouseEvent) : void
      {
         this.selectedBuySkill = param1.currentTarget.parent.name.replace("skill_","");
         this.confirmation = new Confirmation();
         this.skillPrice = this.skillData[this.selectedBuySkill].skillPrice[Character.account_type];
         this.confirmation.txtMc.txt.text = "Confirm buying " + this.skillData[this.selectedBuySkill].skillName + " for " + this.skillPrice + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buySkill);
         this.panelMC.addChild(this.confirmation);
         this.escapeKey.addListener(this.confirmation,this.closeConfirmation);
      }
      
      private function buySkill(param1:MouseEvent) : void
      {
         this.escapeKey.removeListener(this.confirmation,this.closeConfirmation);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("EasterEvent2026.buySkill",[Character.char_id,Character.sessionkey,this.selectedBuySkill],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,this.skillData[this.selectedBuySkill].skillId,"easter");
            Character.updateSkills(this.skillData[this.selectedBuySkill].skillId,true);
            Character.account_tokens = int(Character.account_tokens) - this.skillPrice;
            if(this.selectedBuySkill > 0)
            {
               Character.updateSkills(this.skillData[this.selectedBuySkill - 1].skillId,false);
            }
            this.openTraining(null);
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeTraining(param1:MouseEvent) : void
      {
         this.panelMC.trainingMC.visible = false;
         this.panelMC.menuMC.visible = true;
      }
      
      private function openPackage(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.9SqCSpXyoRuL",[Character.char_id,Character.sessionkey],this.onGetPackageData);
      }
      
      private function onGetPackageData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.initPackageUI(param1);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function initPackageUI(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         this.hidePanels();
         this.panelMC.packageMC.visible = true;
         this.eventHandler.addListener(this.panelMC.packageMC.btn_close,MouseEvent.CLICK,this.closePackage);
         var _loc2_:MovieClip = this.panelMC.packageMC;
         var _loc3_:int = 0;
         while(_loc3_ < this.packageData.packageRewards.length)
         {
            _loc4_ = this.packageData.packageRewards[_loc3_].replace("%s",Character.character_gender);
            _loc2_["iconMC_" + _loc3_].amountTxt.text = "";
            _loc2_["iconMC_" + _loc3_].ownedTxt.text = "";
            _loc2_["iconMC_" + _loc3_].btn_preview.visible = this.checkIsItemOrSkill(_loc4_);
            _loc2_["iconMC_" + _loc3_].btn_preview.metaData = {"itemId":_loc4_};
            this.eventHandler.addListener(_loc2_["iconMC_" + _loc3_].btn_preview,MouseEvent.CLICK,this.openPreview);
            NinjaSage.loadItemIcon(_loc2_["iconMC_" + _loc3_],_loc4_);
            if(Character.hasSkill(_loc4_) > 0)
            {
               _loc2_["iconMC_" + _loc3_].ownedTxt.visible = true;
               _loc2_["iconMC_" + _loc3_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(_loc4_) > 0)
            {
               _loc2_["iconMC_" + _loc3_].ownedTxt.visible = true;
               _loc2_["iconMC_" + _loc3_].ownedTxt.text = "Owned";
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 2)
         {
            _loc5_ = new OutfitManager(false);
            _loc5_.fillOutfit(_loc2_["char_mc" + _loc3_],this.packageData.packageRewards[3].replace("%s",_loc3_),this.packageData.packageRewards[2].replace("%s",_loc3_),this.packageData.packageRewards[1].replace("%s",_loc3_),this.packageData.packageRewards[0].replace("%s",_loc3_),"face_01_" + _loc3_,Character.character_color_hair,Character.character_color_skin);
            this.outfits.push(_loc5_);
            _loc3_++;
         }
         if(Character.account_type == 0)
         {
            _loc2_.priceMC.btn_buy_0.visible = true;
            _loc2_.priceMC.btn_buy_1.visible = false;
            _loc2_.priceMC.btn_emblem.visible = true;
         }
         else
         {
            _loc2_.priceMC.btn_buy_0.visible = false;
            _loc2_.priceMC.btn_buy_1.visible = true;
            _loc2_.priceMC.btn_emblem.visible = false;
         }
         _loc2_.priceMC.tick.visible = false;
         if(this.response.package_bought)
         {
            _loc2_.priceMC.tick.visible = true;
            _loc2_.priceMC.btn_buy_0.visible = false;
            _loc2_.priceMC.btn_buy_1.visible = false;
         }
         _loc2_.priceMC.price_0.text = this.packageData.packagePrice[0];
         _loc2_.priceMC.price_1.text = this.packageData.packagePrice[1];
         this.eventHandler.addListener(_loc2_.priceMC.btn_emblem,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(_loc2_.priceMC.btn_buy_0,MouseEvent.CLICK,this.showConfirmationPackage);
         this.eventHandler.addListener(_loc2_.priceMC.btn_buy_1,MouseEvent.CLICK,this.showConfirmationPackage);
      }
      
      private function showConfirmationPackage(param1:MouseEvent) : void
      {
         this.confirmation = new Confirmation();
         this.skillPrice = this.packageData.packagePrice[Character.account_type];
         this.confirmation.txtMc.txt.text = "Confirm buying " + this.packageData.packageName + " for " + this.skillPrice + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPackage);
         this.panelMC.addChild(this.confirmation);
         this.escapeKey.addListener(this.confirmation,this.closeConfirmation);
      }
      
      private function buyPackage(param1:MouseEvent) : void
      {
         this.escapeKey.removeListener(this.confirmation,this.closeConfirmation);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.vAJslC5OZSww",[Character.char_id,Character.sessionkey],this.buyPackageResponse);
      }
      
      private function buyPackageResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,this.packageData.packageRewards,"easter");
            Character.addRewards(this.packageData.packageRewards);
            this.response.package_bought = true;
            Character.account_tokens = param1.account_tokens;
            this.panelMC.packageMC.priceMC.tick.visible = true;
            this.panelMC.packageMC.priceMC.btn_buy_0.visible = false;
            this.panelMC.packageMC.priceMC.btn_buy_1.visible = false;
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closePackage(param1:MouseEvent) : void
      {
         this.panelMC.packageMC.visible = false;
         this.panelMC.menuMC.visible = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.packageData.packageRewards.length)
         {
            GF.removeAllChild(this.panelMC.packageMC["iconMC_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.packageMC["iconMC_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         GF.destroyArray(this.outfits);
         OutfitManager.clearStaticMc();
         this.outfits = [];
      }
      
      private function openStory(param1:MouseEvent) : void
      {
         this.panelMC.storyMC.visible = true;
         this.panelMC.storyMC.txt_story.text = this.storyText;
         this.eventHandler.addListener(this.panelMC.storyMC.btn_close,MouseEvent.CLICK,this.closeStory);
      }
      
      private function closeStory(param1:MouseEvent) : void
      {
         this.panelMC.storyMC.visible = false;
      }
      
      private function closeConfirmation(param1:MouseEvent) : void
      {
         if(this.confirmation == null)
         {
            return;
         }
         this.escapeKey.removeListener(this.confirmation,this.closeConfirmation);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openMaterialMarket(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.MaterialMarket");
      }
      
      private function openSocial(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("Social","Social");
      }
      
      private function hidePanels() : void
      {
         this.panelMC.battleMC.visible = false;
         this.panelMC.milestoneMC.visible = false;
         this.panelMC.rewardListMC.visible = false;
         this.panelMC.packageMC.visible = false;
         this.panelMC.storyMC.visible = false;
         this.panelMC.previewMC.visible = false;
         this.panelMC.previewItemMC.visible = false;
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         this.main.handleVillageHUDVisibility(true);
         this.escapeKey.destroy();
         GF.removeAllChild(this.panelMC);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.escapeKey = null;
         this.eggsData = null;
         this.panelMC = null;
         this.response = null;
         this.bossData = null;
         this.packageData = null;
         this.loaderSwf.clear();
         this.loaderSwf = null;
         this.milestoneData = null;
         this.skillData = null;
         this.main = null;
      }
   }
}

