package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
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
   
   public class FeastOfGratitudeMenu extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      private var main;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var response:Object;
      
      private var bossData:Array;
      
      private var milestoneData:Array;
      
      private var selectedBoss:int;
      
      private var packageData:Object;
      
      private var REFILL_PRICE:int = 50;
      
      private var selectedBuySkill:int = -1;
      
      private var selectedPreviewSkill:String;
      
      private var skillPrice:int;
      
      private var loaderSwf:BulkLoader;
      
      private var previewMC:PreviewManager;
      
      public function FeastOfGratitudeMenu(param1:*, param2:*)
      {
         var _loc3_:Object = GameData.get("thanksgiving2025");
         var _loc4_:* = {"level":Character.character_lvl};
         super();
         this.packageData = [];
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
         this.packageData = {
            "packageName":_loc3_.paket.name,
            "packagePrice":_loc3_.paket.price,
            "packageRewards":_loc3_.paket.rewards
         };
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
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.previewMC,this.closePreview);
         this.eventHandler = this.main.eventHandler;
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.main.handleVillageHUDVisibility(false);
         this.getEventData();
      }
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("ThanksGivingEvent2025.getBattleData",[Character.char_id,Character.sessionkey],this.onGetEventData);
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
         while(_loc1_ < 10)
         {
            this.panelMC.bossDetailMc.content.energyMC["heart_" + _loc1_].visible = false;
            if(this.response.energy > _loc1_)
            {
               this.panelMC.bossDetailMc.content.energyMC["heart_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function hidePanels() : void
      {
         this.panelMC.milestoneMC.visible = false;
         this.panelMC.rewardListMC.visible = false;
         this.panelMC.packageMC.visible = false;
         this.panelMC.bossDetailMc.visible = false;
         this.panelMC.bossDetailMc.content.visible = false;
         this.panelMC.previewMC.visible = false;
         this.panelMC.menuMC.visible = false;
      }
      
      private function initUI() : void
      {
         this.hidePanels();
         this.panelMC.menuMC.visible = true;
         this.eventHandler.addListener(this.panelMC.menuMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_rewardList,MouseEvent.CLICK,this.openRewardList);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_milestone,MouseEvent.CLICK,this.openMilestone);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_battle,MouseEvent.CLICK,this.openBossUI);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_package,MouseEvent.CLICK,this.getPackageData);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_materialmarket,MouseEvent.CLICK,this.openMaterialMarket);
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
         this.main.amf_manager.service("ThanksGivingEvent2025.refillEnergy",[Character.char_id,Character.sessionkey],this.refillResponse);
      }
      
      private function refillResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response.energy = param1.energy;
            Character.account_tokens = int(Character.account_tokens) - this.REFILL_PRICE;
            this.panelMC.bossDetailMc.content.tokenTxt.text = Character.account_tokens;
            this.main.HUD.setBasicData();
            this.updateEnergy();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openBossUI(param1:MouseEvent) : void
      {
         this.hidePanels();
         this.panelMC.bossDetailMc.visible = true;
         this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_close,MouseEvent.CLICK,this.closeBossUI);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.btn_milestone,MouseEvent.CLICK,this.openMilestone);
         var _loc2_:MovieClip = this.panelMC.bossDetailMc;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc2_["enemy_" + _loc3_].enemyMC.gotoAndStop(_loc3_ + 1);
            this.eventHandler.addListener(_loc2_["enemy_" + _loc3_].btn_openDetail,MouseEvent.CLICK,this.openBossDetail);
            _loc3_++;
         }
      }
      
      private function closeBossUI(param1:MouseEvent) : void
      {
         this.panelMC.bossDetailMc.visible = false;
         this.panelMC.menuMC.visible = true;
      }
      
      private function openBossDetail(param1:MouseEvent) : void
      {
         this.selectedBoss = param1.currentTarget.parent.name.replace("enemy_","");
         this.panelMC.bossDetailMc.content.visible = true;
         this.panelMC.bossDetailMc.content.enemyMC.gotoAndStop(this.selectedBoss + 1);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.content.btn_close,MouseEvent.CLICK,this.closeBossDetail);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.content.btn_start,MouseEvent.CLICK,this.startBattle);
         this.eventHandler.addListener(this.panelMC.bossDetailMc.content.energyMC.heartBtn,MouseEvent.CLICK,this.refillConfirmation);
         this.panelMC.bossDetailMc.content.tokenTxt.text = Character.account_tokens;
         this.panelMC.bossDetailMc.content.rewardMC.goldMc.txt.text = this.bossData[this.selectedBoss].bossGold;
         this.panelMC.bossDetailMc.content.rewardMC.xpMc.txt.text = this.bossData[this.selectedBoss].bossXp;
         this.panelMC.bossDetailMc.content.txt_level.text = "Lv. " + this.bossData[this.selectedBoss].bossLevel[1];
         this.panelMC.bossDetailMc.content.txt_name.text = this.bossData[this.selectedBoss].bossName;
         this.panelMC.bossDetailMc.content.txt_description.text = this.bossData[this.selectedBoss].bossDescription;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            this.panelMC.bossDetailMc.content.rewardMC["iconMc_" + _loc2_].visible = false;
            this.panelMC.bossDetailMc.content.rewardMC["iconMc_" + _loc2_].btn_preview.visible = false;
            if(this.bossData[this.selectedBoss].bossReward.length > _loc2_)
            {
               this.panelMC.bossDetailMc.content.rewardMC["iconMc_" + _loc2_].visible = true;
               NinjaSage.loadItemIcon(this.panelMC.bossDetailMc.content.rewardMC["iconMc_" + _loc2_],this.bossData[this.selectedBoss].bossReward[_loc2_]);
            }
            this.panelMC.bossDetailMc.content.rewardMC["iconMc_" + _loc2_].amountTxt.text = "";
            this.panelMC.bossDetailMc.content.rewardMC["iconMc_" + _loc2_].ownedTxt.text = "";
            _loc2_++;
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
         this.main.amf_manager.service("ThanksGivingEvent2025.startBattle",[Character.char_id,_loc6_,_loc2_,_loc5_,_loc4_,Character.sessionkey],this.onStartEventAmf);
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
            Character.is_thanksgiving_event = true;
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
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeBossDetail(param1:MouseEvent) : void
      {
         this.panelMC.bossDetailMc.content.visible = false;
      }
      
      private function openMilestone(param1:MouseEvent) : *
      {
         this.hidePanels();
         this.panelMC.milestoneMC.visible = true;
         this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close,MouseEvent.CLICK,this.closeMilestone);
         this.main.loading(true);
         this.main.amf_manager.service("ThanksGivingEvent2025.getBonusRewards",[Character.char_id,Character.sessionkey],this.openMilestoneRewards);
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
            this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].btn_preview.visible = this.milestoneData[_loc2_].rewardId.indexOf("skill_") == -1 ? false : true;
            this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].btn_preview.metaData = {"skillId":this.milestoneData[_loc2_].rewardId};
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
            this.panelMC.milestoneMC.txt_draws.text = "You\'ve Battles " + param1.milestone + " times !";
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
         this.main.amf_manager.service("ThanksGivingEvent2025.claimBonusRewards",[Character.char_id,Character.sessionkey,_loc2_],this.onClaimBonusResponse);
      }
      
      private function onClaimBonusResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.addRewards(param1.reward);
            this.main.HUD.setBasicData();
            this.main.giveReward(1,param1.reward,"thanksgiving");
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
         var _loc2_:Object = GameData.get("thanksgiving2025");
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
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].btn_preview.visible = _loc7_.indexOf("skill_") == -1 ? false : true;
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc6_].btn_preview.metaData = {"skillId":_loc7_};
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
      
      private function getPackageData(param1:MouseEvent) : void
      {
         this.main.amf_manager.service("ThanksGivingEvent2025.getPackage",[Character.char_id,Character.sessionkey],this.openTraining);
      }
      
      private function openTraining(param1:Object) : void
      {
         var _loc4_:String = null;
         this.hidePanels();
         this.panelMC.packageMC.visible = true;
         this.eventHandler.addListener(this.panelMC.packageMC.btn_close,MouseEvent.CLICK,this.closeTraining);
         var _loc2_:MovieClip = this.panelMC.packageMC;
         _loc2_.tokenTxt.text = Character.account_tokens;
         var _loc3_:int = 0;
         while(_loc3_ < this.packageData.packageRewards.length)
         {
            _loc4_ = this.packageData.packageRewards[_loc3_].replace("%s",Character.character_gender);
            _loc2_["iconMC_" + _loc3_].amountTxt.text = "";
            _loc2_["iconMC_" + _loc3_].ownedTxt.text = "";
            _loc2_["iconMC_" + _loc3_].btn_preview.visible = _loc4_.indexOf("skill_") == -1 ? false : true;
            _loc2_["iconMC_" + _loc3_].btn_preview.metaData = {"skillId":_loc4_};
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
         _loc2_.priceMC.emblemMC.btn_emblem.visible = true;
         _loc2_.priceMC.emblemMC.btn_buy.visible = false;
         if(Character.account_type == 1)
         {
            _loc2_.priceMC.freeMC.btn_buy.visible = false;
            _loc2_.priceMC.emblemMC.btn_emblem.visible = false;
            _loc2_.priceMC.emblemMC.btn_buy.visible = true;
         }
         if(param1.bought)
         {
            _loc2_.priceMC.emblemMC.btn_buy.visible = false;
            _loc2_.priceMC.freeMC.btn_buy.visible = false;
         }
         _loc2_.priceMC.freeMC.txt_price.text = this.packageData.packagePrice[0];
         _loc2_.priceMC.emblemMC.txt_price.text = this.packageData.packagePrice[1];
         this.eventHandler.addListener(_loc2_.priceMC.emblemMC.btn_emblem,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(_loc2_.priceMC.emblemMC.btn_buy,MouseEvent.CLICK,this.showConfirmationSkill);
         this.eventHandler.addListener(_loc2_.priceMC.freeMC.btn_buy,MouseEvent.CLICK,this.showConfirmationSkill);
      }
      
      private function openPreview(param1:MouseEvent) : void
      {
         this.panelMC.previewMC.visible = true;
         this.eventHandler.addListener(this.panelMC.previewMC.btn_close,MouseEvent.CLICK,this.closePreview);
         this.eventHandler.addListener(this.panelMC.previewMC.btn_replay,MouseEvent.CLICK,this.handleReplay);
         this.selectedPreviewSkill = param1.currentTarget.metaData.skillId;
         this.panelMC.previewMC.txt_name.text = SkillLibrary.getSkillInfo(this.selectedPreviewSkill).skill_name;
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
         var _loc5_:Array = [this.packageData.packageRewards[3],this.packageData.packageRewards[2],this.packageData.packageRewards[1],this.packageData.packageRewards[0],Character.character_face,Character.character_color_hair,Character.character_color_skin];
         if(!this.panelMC.packageMC.visible)
         {
            _loc5_ = null;
         }
         this.previewMC = new PreviewManager(this.main,_loc4_,_loc3_,_loc5_);
         this.panelMC.previewMC.skillMc.scaleX = 1.5;
         this.panelMC.previewMC.skillMc.scaleY = 1.5;
         this.panelMC.previewMC.skillMc.addChild(this.previewMC.preview_mc);
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function closePreview(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.panelMC.previewMC.skillMc);
         this.previewMC.destroy();
         this.previewMC = null;
         this.panelMC.previewMC.visible = false;
      }
      
      private function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function showConfirmationSkill(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.selectedBuySkill = Character.account_type;
         this.confirmation = new Confirmation();
         this.skillPrice = this.packageData.packagePrice[Character.account_type];
         this.confirmation.txtMc.txt.text = "Confirm buying " + this.packageData.packageName + " for " + this.skillPrice + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPackage);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function buyPackage(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("ThanksGivingEvent2025.buyPackage",[Character.char_id,Character.sessionkey],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,this.packageData.packageRewards,"thanksgiving");
            Character.addRewards(this.packageData.packageRewards);
            Character.account_tokens = int(Character.account_tokens) - this.skillPrice;
            this.getPackageData(null);
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeTraining(param1:MouseEvent) : void
      {
         this.panelMC.packageMC.visible = false;
         this.panelMC.menuMC.visible = true;
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
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.panelMC = null;
         this.response = null;
         this.bossData = null;
         this.milestoneData = null;
         this.packageData = null;
         this.main = null;
      }
   }
}
