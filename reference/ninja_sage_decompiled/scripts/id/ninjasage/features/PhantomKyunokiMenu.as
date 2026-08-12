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
   
   public class PhantomKyunokiMenu extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      private var main;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var response:Object;
      
      private var bossData:Object;
      
      private var milestoneData:Array;
      
      private var skillData:Array;
      
      private var REFILL_PRICE:int = 50;
      
      private var selectedBuySkill:int = -1;
      
      private var selectedPreviewSkill:String;
      
      private var selectedPreviewItem:String;
      
      private var skillPrice:int;
      
      private var milestoneTarget:int;
      
      private var loaderSwf:BulkLoader;
      
      private var previewMC:PreviewManager;
      
      private var outfits:Array;
      
      public function PhantomKyunokiMenu(param1:*, param2:*)
      {
         this.outfits = [];
         var _loc3_:Object = GameData.get("phantomkyunoki2026");
         var _loc4_:* = {"level":Character.character_lvl};
         super();
         this.skillData = [];
         this.bossData = {
            "bossId":_loc3_.bosses.id,
            "bossName":_loc3_.bosses.name,
            "bossDescription":_loc3_.bosses.description,
            "bossLevel":[int(Character.character_lvl) + _loc3_.bosses.levels[0],int(Character.character_lvl) + _loc3_.bosses.levels[1]],
            "bossGold":int(Util.calculateFromString(_loc3_.bosses.gold,_loc4_)),
            "bossXp":int(Util.calculateFromString(_loc3_.bosses.gold,_loc4_)),
            "bossReward":_loc3_.bosses.rewards,
            "battleBackground":_loc3_.bosses.background
         };
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.training.length)
         {
            this.skillData.push({
               "skillId":_loc3_.training[_loc5_].id,
               "skillPrice":_loc3_.training[_loc5_].price,
               "skillName":_loc3_.training[_loc5_].name
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
         this.main.amf_manager.service("PhantomKyunokiEvent2026.getBattleData",[Character.char_id,Character.sessionkey],this.onGetEventData);
      }
      
      private function onGetEventData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.updateEnergy();
            this.initMilestoneUI();
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
         while(_loc1_ < 8)
         {
            this.panelMC.energyMC["heart_" + _loc1_].visible = false;
            if(this.response.energy > _loc1_)
            {
               this.panelMC.energyMC["heart_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function initUI() : void
      {
         this.panelMC.rewardListMC.visible = false;
         this.panelMC.trainingMC.visible = false;
         this.panelMC.previewMC.visible = false;
         this.panelMC.previewItemMC.visible = false;
         this.panelMC.tokenTxt.text = Character.account_tokens;
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_rewardList,MouseEvent.CLICK,this.openRewardList);
         this.eventHandler.addListener(this.panelMC.btn_battle,MouseEvent.CLICK,this.startBattle);
         this.eventHandler.addListener(this.panelMC.btn_training,MouseEvent.CLICK,this.openTraining);
         this.eventHandler.addListener(this.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.energyMC.heartBtn,MouseEvent.CLICK,this.refillConfirmation);
         this.initBossUI();
      }
      
      private function initBossUI() : void
      {
         this.panelMC.txt_level.text = "Lv. " + this.bossData.bossLevel[1];
         this.panelMC.txt_name.text = this.bossData.bossName;
         this.panelMC.rewardMC.goldMc.txt.text = this.bossData.bossGold;
         this.panelMC.rewardMC.xpMc.txt.text = this.bossData.bossXp;
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.panelMC.rewardMC["iconMc_" + _loc1_].visible = false;
            if(this.bossData.bossReward.length > _loc1_)
            {
               this.panelMC.rewardMC["iconMc_" + _loc1_].visible = true;
               this.panelMC.rewardMC["iconMc_" + _loc1_].btn_preview.visible = this.checkIsItemOrSkill(this.bossData.bossReward[_loc1_]);
               this.panelMC.rewardMC["iconMc_" + _loc1_].btn_preview.metaData = {"itemId":this.bossData.bossReward[_loc1_]};
               this.eventHandler.addListener(this.panelMC.rewardMC["iconMc_" + _loc1_].btn_preview,MouseEvent.CLICK,this.openPreview);
               NinjaSage.loadItemIcon(this.panelMC.rewardMC["iconMc_" + _loc1_],this.bossData.bossReward[_loc1_]);
            }
            this.panelMC.rewardMC["iconMc_" + _loc1_].amountTxt.text = "";
            this.panelMC.rewardMC["iconMc_" + _loc1_].ownedTxt.text = "";
            _loc1_++;
         }
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
         this.main.amf_manager.service("PhantomKyunokiEvent2026.refillEnergy",[Character.char_id,Character.sessionkey],this.refillResponse);
      }
      
      private function refillResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response.energy = param1.energy;
            Character.account_tokens = int(Character.account_tokens) - this.REFILL_PRICE;
            this.panelMC.tokenTxt.text = Character.account_tokens;
            this.main.HUD.setBasicData();
            this.updateEnergy();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function startBattle(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = this.bossData.bossId[0];
         Character.christmas_boss_num = 0;
         Character.christmas_boss_id = _loc6_;
         _loc2_ = StatManager.calculate_stats_with_data("agility");
         _loc3_ = EnemyInfo.getCopy(_loc6_);
         _loc5_ = "id:" + _loc3_["enemy_id"] + "|hp:" + _loc3_["enemy_hp"] + "|agility:" + _loc3_["enemy_agility"];
         _loc4_ = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.char_id) + String(_loc6_) + _loc5_ + String(_loc2_))));
         this.main.loading(true);
         this.main.amf_manager.service("PhantomKyunokiEvent2026.startBattle",[Character.char_id,_loc6_,_loc2_,_loc5_,_loc4_,Character.sessionkey],this.onStartEventAmf);
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
            Character.is_kyunoki_event = true;
            Character.battle_code = param1.code;
            Character.mission_id = this.bossData.battleBackground;
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.EVENT_MATCH,Character.mission_id);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            _loc2_ = 0;
            while(_loc2_ < this.bossData.bossId.length)
            {
               BattleManager.addPlayerToTeam("enemy",this.bossData.bossId[_loc2_]);
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
      
      private function initMilestoneUI() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.main.loading(false);
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            this.panelMC["reward_" + _loc1_]["txt_requiredBattle"].text = String(this.milestoneData[_loc1_].rewardReq) + " Kills";
            this.panelMC["reward_" + _loc1_]["iconMc"].amountTxt.text = this.milestoneData[_loc1_].rewardQty <= 1 ? "" : "x" + this.milestoneData[_loc1_].rewardQty;
            this.panelMC["reward_" + _loc1_]["iconMc"].ownedTxt.visible = false;
            if(Character.hasSkill(this.milestoneData[_loc1_].rewardId) > 0)
            {
               this.panelMC["reward_" + _loc1_]["iconMc"].ownedTxt.visible = true;
               this.panelMC["reward_" + _loc1_]["iconMc"].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.milestoneData[_loc1_].rewardId) > 0)
            {
               this.panelMC["reward_" + _loc1_]["iconMc"].ownedTxt.visible = true;
               this.panelMC["reward_" + _loc1_]["iconMc"].ownedTxt.text = "Owned";
            }
            this.panelMC["reward_" + _loc1_]["iconMc"].btn_preview.visible = this.checkIsItemOrSkill(this.milestoneData[_loc1_].rewardId);
            this.panelMC["reward_" + _loc1_]["iconMc"].btn_preview.metaData = {"itemId":this.milestoneData[_loc1_].rewardId};
            this.eventHandler.addListener(this.panelMC["reward_" + _loc1_]["iconMc"].btn_preview,MouseEvent.CLICK,this.openPreview);
            NinjaSage.loadItemIcon(this.panelMC["reward_" + _loc1_]["iconMc"],this.milestoneData[_loc1_].rewardId);
            this.panelMC.txt_draws.text = this.response.total_kills + " Kills";
            _loc2_ = this.response.milestone_data[_loc1_].claimed == false && this.response.total_kills >= this.milestoneData[_loc1_].rewardReq ? true : false;
            _loc3_ = this.response.milestone_data[_loc1_].claimed == true;
            this.panelMC["reward_" + _loc1_]["btn_claim"].visible = _loc2_;
            this.panelMC["reward_" + _loc1_].lock.visible = true;
            if(_loc2_)
            {
               this.panelMC["reward_" + _loc1_].lock.visible = false;
               this.eventHandler.addListener(this.panelMC["reward_" + _loc1_]["btn_claim"],MouseEvent.CLICK,this.onClaimBonusRequest);
            }
            if(_loc3_)
            {
               this.panelMC["reward_" + _loc1_].lock.visible = false;
            }
            _loc1_++;
         }
      }
      
      private function onClaimBonusRequest(param1:MouseEvent) : *
      {
         this.milestoneTarget = int(param1.currentTarget.parent.name.replace("reward_",""));
         this.main.amf_manager.service("PhantomKyunokiEvent2026.claimBonusRewards",[Character.char_id,Character.sessionkey,this.milestoneTarget],this.onClaimBonusResponse);
      }
      
      private function onClaimBonusResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.addRewards(param1.reward);
            this.main.HUD.setBasicData();
            this.main.giveReward(1,param1.reward,"independence");
            this.response.milestone_data[this.milestoneTarget].claimed = true;
            this.panelMC.tokenTxt.text = Character.account_tokens;
            this.initMilestoneUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function closeMilestone() : *
      {
         this.panelMC.visible = false;
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            GF.removeAllChild(this.panelMC["reward_" + _loc1_]["iconMc"].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC["reward_" + _loc1_]["iconMc"].skillIcon.iconHolder);
            _loc1_++;
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
         var _loc2_:Object = GameData.get("phantomkyunoki2026");
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
         this.panelMC.trainingMC.visible = true;
         this.eventHandler.addListener(this.panelMC.trainingMC.btn_close,MouseEvent.CLICK,this.closeTraining);
         var _loc2_:int = 0;
         while(_loc2_ < this.skillData.length)
         {
            this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].amountTxt.text = "";
            this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].ownedTxt.text = "";
            this.panelMC.trainingMC["skill_" + _loc2_].txt_name.text = this.skillData[_loc2_].skillName;
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
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_0.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_1.visible = false;
               if(Character.account_type == 1)
               {
                  this.panelMC.trainingMC["skill_" + _loc2_].btn_emblem.visible = false;
               }
               this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].ownedTxt.text = "Owned";
            }
            _loc2_++;
         }
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
      
      private function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function showConfirmationSkill(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.selectedBuySkill = e.currentTarget.name.replace("skill_","");
         this.confirmation = new Confirmation();
         this.skillPrice = this.skillData[this.selectedBuySkill].skillPrice[Character.account_type];
         this.confirmation.txtMc.txt.text = "Confirm buying " + this.skillData[this.selectedBuySkill].skillName + " for " + this.skillPrice + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buySkill);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function buySkill(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("PhantomKyunokiEvent2026.buyPackage",[Character.char_id,Character.sessionkey],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,this.skillData[this.selectedBuySkill].skillId,"independence");
            Character.updateSkills(this.skillData[this.selectedBuySkill].skillId,true);
            Character.account_tokens = int(Character.account_tokens) - this.skillPrice;
            this.panelMC.tokenTxt.text = Character.account_tokens;
            if(this.selectedBuySkill > 0)
            {
               Character.updateSkills(this.skillData[0].skillId,false);
            }
            this.openTraining(null);
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeTraining(param1:MouseEvent) : void
      {
         this.panelMC.trainingMC.visible = false;
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openMaterialMarket(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.MaterialMarket");
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
         this.closeMilestone();
         GF.removeAllChild(this.panelMC);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.panelMC = null;
         this.response = null;
         this.bossData = null;
         this.milestoneData = null;
         this.skillData = null;
         this.main = null;
      }
   }
}
