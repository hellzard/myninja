package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.StatManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.EnemyInfo;
   import Storage.GameData;
   import com.adobe.crypto.CUCSG;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   public class WorldCupMenu extends MovieClip
   {
      
      private var main:*;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      private var confirmation:Confirmation;
      
      private var response:Object;
      
      private var minigameResponse:Object;
      
      private var bossData:Array;
      
      private var milestoneData:Array;
      
      private var skillData:Array;
      
      private var REFILL_PRICE:int = 50;
      
      private var selectedBuySkill:int = -1;
      
      private var selectedBoss:int = 0;
      
      private var skillPrice:int;
      
      private var milestoneTarget:int;
      
      private var outfits:Array = [];
      
      private var outfitsPreview:Array = [];
      
      private var storyText:String;
      
      private var glowFilter:*;
      
      private var isMinigameOpen:Boolean;
      
      private var petFrenzy:*;
      
      private var minigameData:Array;
      
      private var currentPage:int;
      
      private var totalPage:int;
      
      private var currentPageBet:int;
      
      private var totalPageBet:int;
      
      private var countryListData:Array = [];
      
      private var isOnBetSelection:Boolean = false;
      
      private var isSelectChampion:Boolean = false;
      
      private var isSelectRunnerUp:Boolean = false;
      
      private var selectedChampion:String = "";
      
      private var selectedRunnerUp:String = "";
      
      private var matchBetData:Array = [];
      
      private var selectedStageData:Array = [];
      
      private var selectedStageIndex:int = 0;
      
      private var selectedMatchBetData:Object;
      
      private var goal_positions:Array;
      
      private var gk_positions:Array;
      
      private var time_left:int = 45;
      
      private var score:int = 0;
      
      private var start_score:int = 100;
      
      private var plus_score:int;
      
      private var combo:int = 0;
      
      private var last_is_goal:Boolean = false;
      
      private var timer:Timer;
      
      private var timeout:*;
      
      private var selectedTeamBetMatch:String;
      
      private var selectedTeamBetMatchId:int;
      
      public function WorldCupMenu(param1:*, param2:*)
      {
         var _loc3_:Object = GameData.get("worldcup2026");
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
         this.skillData = [];
         _loc5_ = 0;
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
         this.minigameData = [];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.minigame_rewards.length)
         {
            this.minigameData.push(_loc3_.minigame_rewards[_loc5_].replace("%s",Character.character_gender));
            _loc5_++;
         }
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.eventHandler = this.main.eventHandler;
         this.glowFilter = CreateFilter.getGlowFilter({
            "color":16776960,
            "strength":1000,
            "blurX":8,
            "blurY":8
         });
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.main.handleVillageHUDVisibility(false);
         this.getEventData();
      }
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.4IRkhD1R85mw",[Character.char_id,Character.sessionkey],this.onGetEventData);
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
         this.eventHandler.addListener(this.panelMC.menuMC.btn_training,MouseEvent.CLICK,this.openTraining);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_milestone,MouseEvent.CLICK,this.openMilestone);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_betReward,MouseEvent.CLICK,this.openBetRewardList);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_country,MouseEvent.CLICK,this.openCountryList);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_predict,MouseEvent.CLICK,this.openMatchBetting);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_period,MouseEvent.CLICK,this.openVotingPeriod);
         this.eventHandler.addListener(this.panelMC.menuMC.btn_minigame,MouseEvent.CLICK,this.openMinigameCover);
         this.eventHandler.addListener(this.panelMC.battleMC.heartBtn,MouseEvent.CLICK,this.refillConfirmation);
         if(this.response.bet_champion == null)
         {
            this.eventHandler.addListener(this.panelMC.menuMC.championMC,MouseEvent.CLICK,this.openCountryList);
            this.panelMC.menuMC.championMC.flags.gotoAndStop(1);
         }
         else
         {
            this.panelMC.menuMC.championMC.flags.gotoAndStop(this.response.bet_champion);
         }
         if(this.response.bet_runnerup == null)
         {
            this.eventHandler.addListener(this.panelMC.menuMC.runnerUpMC,MouseEvent.CLICK,this.openCountryList);
            this.panelMC.menuMC.runnerUpMC.flags.gotoAndStop(1);
         }
         else
         {
            this.panelMC.menuMC.runnerUpMC.flags.gotoAndStop(this.response.bet_runnerup);
         }
         this.panelMC.menuMC.btn_bet.visible = false;
         if(this.response.bet_champion == null || this.response.bet_runnerup == null)
         {
            this.panelMC.menuMC.btn_bet.visible = true;
            this.eventHandler.addListener(this.panelMC.menuMC.btn_bet,MouseEvent.CLICK,this.betChampionConfirmation);
         }
         NinjaSage.showDynamicTooltip(this.panelMC.menuMC.btn_help,this.response.timestamp);
         this.initEscapeKey();
      }
      
      private function initEscapeKey() : void
      {
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.battleMC,this.closeBossBattle);
         this.escapeKey.addListener(this.panelMC.milestoneMC,this.closeMilestone);
         this.escapeKey.addListener(this.panelMC.rewardListMC,this.closeRewardList);
         this.escapeKey.addListener(this.panelMC.trainingMC,this.closeTraining);
         this.escapeKey.addListener(this.panelMC.betPrizeListMC,this.closeBetPrizeList);
         this.escapeKey.addListener(this.panelMC.minigameCoverMC,this.closeMinigameCover);
         this.escapeKey.addListener(this.panelMC.bettingMC,this.closeMatchBetting);
         this.escapeKey.addListener(this.panelMC.countryListMC,this.closeCountryList);
         this.escapeKey.addListener(this.panelMC.votingPeriodMC,this.closeVotingPeriod);
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
         this.eventHandler.addListener(this.panelMC.battleMC.btn_recruit,MouseEvent.CLICK,this.openSocial);
         this.updateBossUI();
         this.panelMC.battleMC["enemy_0"].filters = [this.glowFilter];
         var _loc2_:int = 0;
         while(_loc2_ < 2)
         {
            this.panelMC.battleMC["enemy_" + _loc2_].txt_name.text = this.bossData[_loc2_].bossName;
            this.eventHandler.addListener(this.panelMC.battleMC["enemy_" + _loc2_],MouseEvent.CLICK,this.selectBoss);
            _loc2_++;
         }
      }
      
      private function updateBossUI() : void
      {
         this.panelMC.battleMC.goldMc.txt.text = this.bossData[this.selectedBoss].bossGold;
         this.panelMC.battleMC.xpMc.txt.text = this.bossData[this.selectedBoss].bossXp;
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.panelMC.battleMC["iconMc_" + _loc1_].visible = false;
            if(this.bossData[this.selectedBoss].bossReward.length > _loc1_)
            {
               this.panelMC.battleMC["iconMc_" + _loc1_].visible = true;
               this.panelMC.battleMC["iconMc_" + _loc1_].btn_preview.visible = this.checkIsItemOrSkill(this.bossData[this.selectedBoss].bossReward[_loc1_]);
               this.panelMC.battleMC["iconMc_" + _loc1_].btn_preview.metaData = {"itemId":this.bossData[this.selectedBoss].bossReward[_loc1_]};
               this.eventHandler.addListener(this.panelMC.battleMC["iconMc_" + _loc1_].btn_preview,MouseEvent.CLICK,this.openPreview);
               NinjaSage.loadItemIcon(this.panelMC.battleMC["iconMc_" + _loc1_],this.bossData[this.selectedBoss].bossReward[_loc1_]);
            }
            this.panelMC.battleMC["iconMc_" + _loc1_].amountTxt.text = "";
            this.panelMC.battleMC["iconMc_" + _loc1_].ownedTxt.text = "";
            _loc1_++;
         }
      }
      
      private function selectBoss(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.currentTarget.name.replace("enemy_",""));
         if(this.selectedBoss == _loc2_)
         {
            return;
         }
         this.panelMC.battleMC["enemy_0"].filters = null;
         this.panelMC.battleMC["enemy_1"].filters = null;
         this.selectedBoss = _loc2_;
         this.panelMC.battleMC["enemy_" + this.selectedBoss].filters = [this.glowFilter];
         this.updateBossUI();
      }
      
      private function closeBossBattle(param1:MouseEvent) : void
      {
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
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.CHFgCmoUr4DQ",[Character.char_id,Character.sessionkey],this.refillResponse);
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
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.I6b4FmJTM2cW",[Character.char_id,_loc6_,_loc2_,_loc5_,_loc4_,Character.sessionkey],this.onStartEventAmf);
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
            Character.is_worldcup_event = true;
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
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.Z7mwyAOlOnYg",[Character.char_id,Character.sessionkey],this.openMilestoneRewards);
         var _loc2_:int = 0;
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
               this.panelMC.milestoneMC["reward_" + _loc2_].lockMc.visible = true;
               if(_loc3_)
               {
                  this.panelMC.milestoneMC["reward_" + _loc2_].lockMc.visible = false;
                  this.eventHandler.addListener(this.panelMC.milestoneMC["reward_" + _loc2_]["btn_claim"],MouseEvent.CLICK,this.onClaimBonusRequest);
               }
               if(_loc4_)
               {
                  this.panelMC.milestoneMC["reward_" + _loc2_].lockMc.visible = false;
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
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.0fBhOCZCMRHc",[Character.char_id,Character.sessionkey,_loc2_],this.onClaimBonusResponse);
      }
      
      private function onClaimBonusResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.addRewards(param1.reward);
            this.main.HUD.setBasicData();
            this.main.giveReward(1,param1.reward);
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
      
      private function openBetRewardList(param1:MouseEvent) : void
      {
         var _loc5_:int = 0;
         this.panelMC.betPrizeListMC.visible = true;
         this.eventHandler.addListener(this.panelMC.betPrizeListMC.btn_close,MouseEvent.CLICK,this.closeBetPrizeList);
         var _loc2_:Object = GameData.get("worldcup2026").bet_prize;
         var _loc3_:Array = ["first","second","participant"];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_[_loc3_[_loc4_]].length)
            {
               this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.amountTxt.text = "";
               this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.ownedTxt.visible = false;
               if(Character.hasSkill(_loc2_[_loc3_[_loc4_]][_loc5_]) > 0)
               {
                  this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.ownedTxt.visible = true;
                  this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(_loc2_[_loc3_[_loc4_]][_loc5_]) > 0)
               {
                  this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.ownedTxt.visible = true;
                  this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.ownedTxt.text = "Owned";
               }
               this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.btn_preview.visible = this.checkIsItemOrSkill(_loc2_[_loc3_[_loc4_]][_loc5_]);
               this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.btn_preview.metaData = {"itemId":_loc2_[_loc3_[_loc4_]][_loc5_]};
               this.eventHandler.addListener(this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon.btn_preview,MouseEvent.CLICK,this.openPreview);
               NinjaSage.loadItemIcon(this.panelMC.betPrizeListMC["rewardMC_" + _loc4_ + "_" + _loc5_].icon,_loc2_[_loc3_[_loc4_]][_loc5_]);
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      private function closeBetPrizeList(param1:MouseEvent) : void
      {
         this.panelMC.betPrizeListMC.visible = false;
      }
      
      private function openRewardList(param1:MouseEvent) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         this.panelMC.rewardListMC.visible = true;
         this.eventHandler.addListener(this.panelMC.rewardListMC.btn_close,MouseEvent.CLICK,this.closeRewardList);
         this.eventHandler.addListener(this.panelMC.rewardListMC.btn_mm,MouseEvent.CLICK,this.openMaterialMarket);
         var _loc2_:Object = GameData.get("worldcup2026");
         var _loc3_:Array = ["hair","set","back","weapon","skill","pet"];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc2_.rewards_preview[_loc3_[_loc4_]];
            _loc6_ = _loc3_[_loc4_] == "pet" ? 3 : 2;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.visible = false;
               this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.amountTxt.text = "";
               if(_loc7_ < _loc5_.length)
               {
                  _loc8_ = _loc5_[_loc7_].replace("%s",Character.character_gender);
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.visible = true;
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.btn_preview.visible = this.checkIsItemOrSkill(_loc8_);
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.btn_preview.metaData = {"itemId":_loc8_};
                  this.eventHandler.addListener(this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.btn_preview,MouseEvent.CLICK,this.openPreview);
                  NinjaSage.loadItemIcon(this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon,_loc8_);
                  this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.ownedTxt.visible = false;
                  if(Character.hasSkill(_loc8_) > 0)
                  {
                     this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.ownedTxt.visible = true;
                     this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.ownedTxt.text = "Owned";
                  }
                  if(Character.isItemOwned(_loc8_) > 0)
                  {
                     this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.ownedTxt.visible = true;
                     this.panelMC.rewardListMC["item_" + _loc4_]["iconMC_" + _loc7_].icon.ownedTxt.text = "Owned";
                  }
               }
               _loc7_++;
            }
            _loc4_++;
         }
      }
      
      private function closeRewardList(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.panelMC.rewardListMC.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               GF.removeAllChild(this.panelMC.rewardListMC["item_" + _loc2_]["iconMC_" + _loc3_].icon.rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.rewardListMC["item_" + _loc2_]["iconMC_" + _loc3_].icon.skillIcon.iconHolder);
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function openTraining(param1:MouseEvent) : void
      {
         this.hidePanels();
         this.panelMC.trainingMC.visible = true;
         this.eventHandler.addListener(this.panelMC.trainingMC.btn_close,MouseEvent.CLICK,this.closeTraining);
         var _loc2_:int = 0;
         while(_loc2_ < this.skillData.length)
         {
            this.panelMC.trainingMC["skill_" + _loc2_]["txt_skill"].text = this.skillData[_loc2_].skillName;
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
            this.panelMC.trainingMC["skill_" + _loc2_].tick.visible = false;
            if(Character.hasSkill(this.skillData[_loc2_].skillId) > 0)
            {
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_0.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_buy_1.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_].btn_emblem.visible = false;
               this.panelMC.trainingMC["skill_" + _loc2_].tick.visible = true;
               this.panelMC.trainingMC["skill_" + _loc2_]["iconMC"].ownedTxt.text = "Owned";
            }
            _loc2_++;
         }
      }
      
      private function openPreview(param1:MouseEvent) : void
      {
         this.main.openPreview(param1);
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
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.9NcgjHlroUJF",[Character.char_id,Character.sessionkey,this.selectedBuySkill],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,this.skillData[this.selectedBuySkill].skillId,"hanami");
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
      
      private function openMinigameCover(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.3IgUoVAAXaZJ",[Character.char_id,Character.sessionkey],this.onGetMinigameData);
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
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openMinigameUI() : void
      {
         this.isMinigameOpen = true;
         this.panelMC.minigameCoverMC.visible = true;
         this.eventHandler.addListener(this.panelMC.minigameCoverMC.btn_close,MouseEvent.CLICK,this.closeMinigameCover);
         this.eventHandler.addListener(this.panelMC.minigameCoverMC.heartBtn,MouseEvent.CLICK,this.refillConfirmation);
         this.eventHandler.addListener(this.panelMC.minigameCoverMC.btn_start,MouseEvent.CLICK,this.startMinigame);
         this.eventHandler.addListener(this.panelMC.minigameCoverMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.panelMC.minigameCoverMC.tokenTxt.text = Character.account_tokens;
         this.panelMC.minigameCoverMC.txt_desc.text = "Shoot the ball to the goal. Earn 3 stars to earn massive rewards!";
         this.updateMinigameEnergy();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.panelMC.minigameCoverMC["iconMc_" + _loc1_].visible = false;
            if(this.minigameData.length > _loc1_)
            {
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].visible = true;
               NinjaSage.loadItemIcon(this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon,this.minigameData[_loc1_]);
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.amountTxt.text = "";
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.btn_preview.visible = this.minigameData[_loc1_].indexOf("skill_") == -1 ? false : true;
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.btn_preview.metaData = {"skillId":this.minigameData[_loc1_]};
               this.eventHandler.addListener(this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.btn_preview,MouseEvent.CLICK,this.openPreview);
               this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.ownedTxt.visible = false;
               if(Character.hasSkill(this.minigameData[_loc1_]) > 0)
               {
                  this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.ownedTxt.visible = true;
                  this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.minigameData[_loc1_]) > 0)
               {
                  this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.ownedTxt.visible = true;
                  this.panelMC.minigameCoverMC["iconMc_" + _loc1_].icon.ownedTxt.text = "Owned";
               }
            }
            _loc1_++;
         }
      }
      
      private function startMinigame(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.DU3i9vqDpuNg",[Character.char_id,Character.sessionkey],this.onStartMinigame);
      }
      
      private function onStartMinigame(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.time_left = 45;
            this.score = 0;
            this.combo = 0;
            this.plus_score = this.start_score;
            this.panelMC.minigameMC.score_txt.text = 0;
            this.panelMC.minigameMC.combo_txt.text = 0;
            this.panelMC.minigameMC.plus_score_txt.text = 0;
            this.panelMC.minigameMC.progress_bar.scaleX = 0;
            Character.battle_code = param1.battle_code;
            this.initMinigame();
            this.hideThisPanel();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function initMinigame() : void
      {
         this.goal_positions = [{
            "x":600,
            "y":450
         },{
            "x":950,
            "y":450
         },{
            "x":1300,
            "y":450
         }];
         this.gk_positions = [{
            "x":625,
            "y":580
         },{
            "x":975,
            "y":580
         },{
            "x":1350,
            "y":580
         }];
         this.plus_score = this.start_score;
         this.eventHandler.addListener(this.panelMC.minigameMC.left_side_btn,MouseEvent.CLICK,this.onShoot);
         this.eventHandler.addListener(this.panelMC.minigameMC.center_side_btn,MouseEvent.CLICK,this.onShoot);
         this.eventHandler.addListener(this.panelMC.minigameMC.right_side_btn,MouseEvent.CLICK,this.onShoot);
         this.panelMC.minigameMC.time_left_txt.text = this.time_left.toString();
         this.panelMC.minigameMC.score_txt.text = this.score.toString();
         this.timer = new Timer(1000,this.time_left);
         this.eventHandler.addListener(this.timer,TimerEvent.TIMER,this.onTimerUpdate);
         this.eventHandler.addListener(this.timer,TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.setIsGoal(false);
         this.panelMC.minigameMC.progress_bar.scaleX = 0;
         this.panelMC.minigameMC.gk_mc.addFrameScript(this.panelMC.minigameMC.gk_mc.totalFrames - 1,this.gkIdle);
         this.init();
         this.panelMC.minigameMC.visible = true;
         this.timer.start();
      }
      
      public function gkIdle() : void
      {
         this.panelMC.minigameMC.gk_mc.gotoAndPlay(1);
      }
      
      public function onTimerUpdate(param1:TimerEvent) : *
      {
         --this.time_left;
         this.panelMC.minigameMC.time_left_txt.text = this.time_left.toString();
      }
      
      public function onTimerComplete(param1:TimerEvent) : *
      {
         this.main.loading(true);
         var _loc2_:String = CUCSG.hash(Character.char_id + "_" + this.score.toString() + "_" + Character.battle_code);
         this.main.amf_manager.service("WorldCupEvent2026.finishMiniGame",[Character.char_id,Character.sessionkey,this.score,_loc2_,Character.battle_code],this.onMinigameFinished);
      }
      
      public function onMinigameFinished(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,param1.rewards);
            Character.addRewards(param1.rewards);
            this.main.HUD.setBasicData();
            this.minigameResponse.minigame_energy = param1.minigame_energy;
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
         this.panelMC.minigameMC.visible = false;
         this.eventHandler.removeListener(this.timer,TimerEvent.TIMER,this.onTimerUpdate);
         this.eventHandler.removeListener(this.timer,TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.timer = null;
         this.goal_positions = [];
         this.gk_positions = [];
         this.showThisPanel();
      }
      
      public function setIsGoal(param1:Boolean, param2:Boolean = false) : *
      {
         var _loc3_:Number = NaN;
         if(this.time_left > 0)
         {
            if(param2)
            {
               if(param1 && this.last_is_goal)
               {
                  this.plus_score += 10;
                  this.score += this.plus_score;
                  ++this.combo;
               }
               else if(param1)
               {
                  this.score += this.plus_score;
               }
               else
               {
                  this.plus_score = this.start_score;
                  this.combo = 0;
               }
               this.panelMC.minigameMC.plus_score_txt.text = "+" + this.plus_score.toString();
               this.panelMC.minigameMC.combo_txt.text = this.combo.toString();
               this.last_is_goal = param1;
               if(this.score >= 20000)
               {
                  this.panelMC.minigameMC.s2_0.filters = [];
                  this.panelMC.minigameMC.s2_1.filters = [];
               }
               if(this.score >= 25000)
               {
                  this.panelMC.minigameMC.s3_0.filters = [];
                  this.panelMC.minigameMC.s3_1.filters = [];
                  this.panelMC.minigameMC.s3_2.filters = [];
               }
               _loc3_ = Number(this.score / 25000);
               this.panelMC.minigameMC.progress_bar.scaleX = _loc3_;
            }
            this.panelMC.minigameMC.goal_mc.visible = param1;
         }
      }
      
      public function onShoot(param1:MouseEvent) : *
      {
         this.resetGame();
         var _loc2_:int = -1;
         switch(param1.currentTarget.name)
         {
            case "left_side_btn":
               _loc2_ = 0;
               break;
            case "center_side_btn":
               _loc2_ = 1;
               break;
            case "right_side_btn":
               _loc2_ = 2;
         }
         var _loc3_:int = Math.floor(Math.random() * 3);
         var _loc4_:Boolean = _loc2_ != _loc3_ ? true : false;
         this.setIsGoal(_loc4_,true);
         this.setGoalBallPos(_loc2_,_loc4_);
         this.setGKPos(_loc3_,_loc4_);
         this.panelMC.minigameMC.score_txt.text = this.score.toString();
         if(!this.timeout)
         {
            this.timeout = setTimeout(this.resetGame,200);
         }
      }
      
      public function resetGame() : *
      {
         if(this.timeout)
         {
            clearTimeout(this.timeout);
            this.timeout = null;
         }
         this.panelMC.minigameMC.gk_mc.gotoAndPlay(1);
         this.setIsGoal(false);
         this.init();
      }
      
      public function setGoalBallPos(param1:*, param2:*) : *
      {
         this.panelMC.minigameMC.large_ball_mc.visible = false;
         this.panelMC.minigameMC.goal_ball_mc.visible = false;
         if(param2)
         {
            this.panelMC.minigameMC.goal_ball_mc.visible = true;
         }
         this.panelMC.minigameMC.goal_ball_mc.x = this.goal_positions[param1].x;
         this.panelMC.minigameMC.goal_ball_mc.y = this.goal_positions[param1].y;
      }
      
      public function setGKPos(param1:*, param2:*) : *
      {
         if(!param2)
         {
            this.goalKeeperSave();
         }
         this.panelMC.minigameMC.gk_mc.x = this.gk_positions[param1].x;
         this.panelMC.minigameMC.gk_mc.y = this.gk_positions[param1].y;
      }
      
      public function init() : *
      {
         this.panelMC.minigameMC.large_ball_mc.visible = true;
         this.panelMC.minigameMC.goal_ball_mc.visible = false;
      }
      
      public function goalKeeperSave() : *
      {
         this.panelMC.minigameMC.gk_mc.gotoAndStop("save");
      }
      
      private function showThisPanel() : void
      {
         this.panelMC.menuMC.visible = true;
         this.updateMinigameEnergy();
      }
      
      private function hideThisPanel() : void
      {
         this.panelMC.menuMC.visible = false;
      }
      
      private function updateMinigameEnergy() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this.panelMC.minigameCoverMC["heart_" + _loc1_].visible = false;
            if(this.minigameResponse.minigame_energy > _loc1_)
            {
               this.panelMC.minigameCoverMC["heart_" + _loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function closeMinigameCover(param1:MouseEvent) : void
      {
         this.isMinigameOpen = false;
         this.panelMC.minigameCoverMC.visible = false;
      }
      
      private function openVotingPeriod(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.8TjZPaxYYGkW",[Character.char_id,Character.sessionkey],this.onBetPrices);
      }
      
      private function onBetPrices(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.votingPeriodMC.visible = true;
            this.eventHandler.addListener(this.panelMC.votingPeriodMC.btn_close,MouseEvent.CLICK,this.closeVotingPeriod);
            _loc2_ = 0;
            while(_loc2_ < param1.bet_prices.length)
            {
               this.panelMC.votingPeriodMC["token_" + _loc2_].text = param1.bet_prices[_loc2_] + " Tokens";
               _loc2_++;
            }
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeVotingPeriod(param1:MouseEvent) : void
      {
         this.panelMC.votingPeriodMC.visible = false;
      }
      
      private function openCountryList(param1:MouseEvent) : void
      {
         this.isSelectChampion = param1.currentTarget.name == "championMC";
         this.isSelectRunnerUp = param1.currentTarget.name == "runnerUpMC";
         this.isOnBetSelection = this.isSelectChampion || this.isSelectRunnerUp;
         this.main.loading(true);
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.mYmQmrmxN3kf",[Character.char_id,Character.sessionkey],this.onCountryList);
      }
      
      private function onCountryList(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.countryListData = param1.countries;
            this.currentPage = 1;
            this.totalPage = Math.max(1,Math.ceil(this.countryListData.length / 16));
            this.updatePageNumber();
            this.renderCountryList();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function renderCountryList() : void
      {
         var _loc2_:int = 0;
         this.panelMC.countryListMC.visible = true;
         this.eventHandler.addListener(this.panelMC.countryListMC.btn_close,MouseEvent.CLICK,this.closeCountryList);
         this.eventHandler.addListener(this.panelMC.countryListMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.countryListMC.btn_prev,MouseEvent.CLICK,this.changePage);
         var _loc1_:int = 0;
         while(_loc1_ < 16)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 16);
            this.panelMC.countryListMC["country_" + _loc1_].visible = false;
            if(this.countryListData.length > _loc2_)
            {
               this.panelMC.countryListMC["country_" + _loc1_].visible = true;
               this.panelMC.countryListMC["country_" + _loc1_].metaData = {"data":this.countryListData[_loc2_]};
               this.panelMC.countryListMC["country_" + _loc1_].flags.gotoAndStop(this.countryListData[_loc2_].country);
               this.panelMC.countryListMC["country_" + _loc1_].txt_eliminated.text = "";
               if(this.countryListData[_loc2_].eliminated)
               {
                  this.panelMC.countryListMC["country_" + _loc1_].txt_eliminated.text = "Eliminated";
               }
               this.eventHandler.addListener(this.panelMC.countryListMC["country_" + _loc1_],MouseEvent.CLICK,this.selectCountry);
               NinjaSage.showDynamicTooltip(this.panelMC.countryListMC["country_" + _loc1_].clickmask,this.countryListData[_loc2_].country);
            }
            _loc1_++;
         }
      }
      
      private function selectCountry(param1:MouseEvent) : void
      {
         if(!this.isOnBetSelection)
         {
            return;
         }
         if(param1.currentTarget.metaData.data.eliminated)
         {
            this.main.showMessage("You cannot select eliminated country");
            return;
         }
         if(this.isSelectChampion)
         {
            this.selectedChampion = param1.currentTarget.metaData.data.country;
            this.panelMC.menuMC.championMC.flags.gotoAndStop(this.selectedChampion);
         }
         if(this.isSelectRunnerUp)
         {
            this.selectedRunnerUp = param1.currentTarget.metaData.data.country;
            this.panelMC.menuMC.runnerUpMC.flags.gotoAndStop(this.selectedRunnerUp);
         }
         if(this.selectedChampion == this.selectedRunnerUp)
         {
            this.main.showMessage("You cannot select the same country on both sides");
            return;
         }
         this.closeCountryList(null);
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderCountryList();
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderCountryList();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.countryListMC.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function closeCountryList(param1:MouseEvent) : void
      {
         this.panelMC.countryListMC.visible = false;
         this.currentPage = 1;
         this.countryListData = [];
      }
      
      private function betChampionConfirmation(param1:MouseEvent) : void
      {
         if(this.selectedChampion == "" || this.selectedRunnerUp == "")
         {
            this.main.showMessage("You must select both sides first before placing a prediction.");
            return;
         }
         this.main.showConfirmation("Are you sure to place a prediction for this country? You cannot reselect after placing a prediction.",this.betChampionAmf);
      }
      
      private function betChampionAmf(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.Af1c1ZkkmDAu",[Character.char_id,Character.sessionkey,this.selectedChampion,this.selectedRunnerUp],this.onChampionBetPlaced);
      }
      
      private function onChampionBetPlaced(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Bet successfully placed.");
            Character.account_tokens = param1.account_tokens;
            this.main.HUD.setBasicData();
            this.response.bet_champion = this.selectedChampion;
            this.response.bet_runnerup = this.selectedRunnerUp;
            this.eventHandler.removeListener(this.panelMC.menuMC.championMC,MouseEvent.CLICK,this.openCountryList);
            this.eventHandler.removeListener(this.panelMC.menuMC.runnerUpMC,MouseEvent.CLICK,this.openCountryList);
            this.eventHandler.removeListener(this.panelMC.menuMC.btn_bet,MouseEvent.CLICK,this.betChampionConfirmation);
            this.panelMC.menuMC.btn_bet.visible = false;
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openMatchBetting(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.VDtaHMh0RevO",[Character.char_id,Character.sessionkey],this.onMatchData);
      }
      
      private function onMatchData(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.bettingMC.visible = true;
            this.matchBetData = param1.matches;
            this.selectedTeamBetMatch = "";
            this.selectedTeamBetMatchId = -1;
            this.selectedStageData = this.sortStageData(this.selectedStageIndex);
            this.currentPageBet = 1;
            this.totalPageBet = Math.max(1,Math.ceil(this.selectedStageData.length / 4));
            this.eventHandler.addListener(this.panelMC.bettingMC.btn_close,MouseEvent.CLICK,this.closeMatchBetting);
            this.eventHandler.addListener(this.panelMC.bettingMC.btn_next,MouseEvent.CLICK,this.changePageBet);
            this.eventHandler.addListener(this.panelMC.bettingMC.btn_prev,MouseEvent.CLICK,this.changePageBet);
            _loc2_ = ["Group Stage","Round of 32","Round of 16","Quarter Finals","Semi Finals","The Final"];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.main.initButton(this.panelMC.bettingMC["stage_" + _loc3_],this.changeStage,_loc2_[_loc3_]);
               _loc3_++;
            }
            this.updatePageNumberBet();
            this.renderMatchBet();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function changeStage(param1:MouseEvent) : void
      {
         this.selectedStageIndex = param1.currentTarget.name.replace("stage_","");
         this.selectedStageData = this.sortStageData(this.selectedStageIndex);
         this.currentPageBet = 1;
         this.totalPageBet = Math.max(1,Math.ceil(this.selectedStageData.length / 4));
         this.updatePageNumberBet();
         this.renderMatchBet();
      }
      
      private function sortStageData(param1:int) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.matchBetData.length)
         {
            if(this.matchBetData[_loc3_].stage == param1)
            {
               _loc2_.push(this.matchBetData[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function renderMatchBet() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageBet - 1) * 4);
            this.panelMC.bettingMC["match_" + _loc1_].visible = false;
            if(this.selectedStageData.length > _loc2_)
            {
               this.panelMC.bettingMC["match_" + _loc1_].visible = true;
               this.panelMC.bettingMC["match_" + _loc1_].metaData = {"data":this.selectedStageData[_loc2_]};
               this.panelMC.bettingMC["match_" + _loc1_].homeTeam.flags.gotoAndStop(this.hasLabel(this.panelMC.bettingMC["match_" + _loc1_].homeTeam.flags,this.selectedStageData[_loc2_].home_team));
               this.panelMC.bettingMC["match_" + _loc1_].awayTeam.flags.gotoAndStop(this.hasLabel(this.panelMC.bettingMC["match_" + _loc1_].awayTeam.flags,this.selectedStageData[_loc2_].away_team));
               this.panelMC.bettingMC["match_" + _loc1_].txt_date.text = this.selectedStageData[_loc2_].match_date + " " + this.selectedStageData[_loc2_].match_time;
               this.panelMC.bettingMC["match_" + _loc1_].btn_bet.visible = true;
               this.selectedStageData[_loc2_].home_score = this.selectedStageData[_loc2_].home_score == null ? "0" : this.selectedStageData[_loc2_].home_score;
               this.selectedStageData[_loc2_].away_score = this.selectedStageData[_loc2_].away_score == null ? "0" : this.selectedStageData[_loc2_].away_score;
               this.panelMC.bettingMC["match_" + _loc1_].txt_score.text = this.selectedStageData[_loc2_].home_score + " - " + this.selectedStageData[_loc2_].away_score;
               this.panelMC.bettingMC["match_" + _loc1_].txt_bet.text = "";
               this.panelMC.bettingMC["match_" + _loc1_].btn_bet.txt.text = this.selectedStageData[_loc2_].bet_token;
               if(this.selectedStageData[_loc2_].is_bet)
               {
                  this.panelMC.bettingMC["match_" + _loc1_].btn_bet.visible = false;
                  this.panelMC.bettingMC["match_" + _loc1_].txt_bet.text = "Predicted\nfor " + this.selectedStageData[_loc2_].bet_token + " Tokens";
               }
               this.panelMC.bettingMC["match_" + _loc1_].btn_bet.metaData = {"data":this.selectedStageData[_loc2_]};
               this.panelMC.bettingMC["match_" + _loc1_].homeTeam.metaData = {"data":this.selectedStageData[_loc2_]};
               this.panelMC.bettingMC["match_" + _loc1_].awayTeam.metaData = {"data":this.selectedStageData[_loc2_]};
               this.panelMC.bettingMC["match_" + _loc1_].homeTeam.filters = null;
               this.panelMC.bettingMC["match_" + _loc1_].awayTeam.filters = null;
               if(this.selectedStageData[_loc2_].predicted_team != null)
               {
                  if(this.selectedStageData[_loc2_].predicted_team == this.selectedStageData[_loc2_].home_team)
                  {
                     this.panelMC.bettingMC["match_" + _loc1_].homeTeam.filters = [this.glowFilter];
                  }
                  else
                  {
                     this.panelMC.bettingMC["match_" + _loc1_].awayTeam.filters = [this.glowFilter];
                  }
               }
               this.eventHandler.addListener(this.panelMC.bettingMC["match_" + _loc1_].homeTeam,MouseEvent.CLICK,this.selectTeamBetMatch);
               this.eventHandler.addListener(this.panelMC.bettingMC["match_" + _loc1_].awayTeam,MouseEvent.CLICK,this.selectTeamBetMatch);
               this.eventHandler.addListener(this.panelMC.bettingMC["match_" + _loc1_].btn_bet,MouseEvent.CLICK,this.confirmationMatchBet);
               NinjaSage.showDynamicTooltip(this.panelMC.bettingMC["match_" + _loc1_].homeTeam.clickmask,this.selectedStageData[_loc2_].home_team);
               NinjaSage.showDynamicTooltip(this.panelMC.bettingMC["match_" + _loc1_].awayTeam.clickmask,this.selectedStageData[_loc2_].away_team);
               NinjaSage.showDynamicTooltip(this.panelMC.bettingMC["match_" + _loc1_].btn_help,"You will receive x2 amount of tokens spent if you successfully predict a winner for this match. The rewards will be sent to your mailbox.");
            }
            _loc1_++;
         }
      }
      
      private function selectTeamBetMatch(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this.panelMC.bettingMC["match_" + _loc2_].homeTeam.filters = null;
            this.panelMC.bettingMC["match_" + _loc2_].awayTeam.filters = null;
            _loc2_++;
         }
         param1.currentTarget.filters = [this.glowFilter];
         this.selectedTeamBetMatch = param1.currentTarget.name == "homeTeam" ? param1.currentTarget.metaData.data.home_team : param1.currentTarget.metaData.data.away_team;
         this.selectedTeamBetMatchId = param1.currentTarget.metaData.data.id;
      }
      
      private function confirmationMatchBet(param1:MouseEvent) : void
      {
         this.selectedMatchBetData = param1.currentTarget.metaData.data;
         if(this.selectedTeamBetMatchId != this.selectedMatchBetData.id)
         {
            this.main.showMessage("Please select a country to predict first");
            return;
         }
         this.main.showConfirmation("Are you sure to place a prediction for " + this.selectedTeamBetMatch + "? You cannot cancel after placing a prediction.",this.betMatchAmf);
      }
      
      private function betMatchAmf(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("qewuJV7QnTaJ86hH.hQBTE66P2uEI",[Character.char_id,Character.sessionkey,this.selectedMatchBetData.id,this.selectedTeamBetMatch],this.onMatchBetPlaced);
      }
      
      private function updateMatchData(param1:int, param2:Boolean, param3:String) : void
      {
         var _loc4_:int = 0;
         while(_loc4_ < this.matchBetData.length)
         {
            if(this.matchBetData[_loc4_].id == param1)
            {
               this.matchBetData[_loc4_].is_bet = true;
               this.matchBetData[_loc4_].predicted_team = param3;
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this.selectedStageData.length)
         {
            if(this.selectedStageData[_loc4_].id == param1)
            {
               this.selectedStageData[_loc4_].is_bet = true;
               this.selectedStageData[_loc4_].predicted_team = param3;
            }
            _loc4_++;
         }
      }
      
      private function onMatchBetPlaced(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Bet successfully placed.");
            this.updateMatchData(this.selectedMatchBetData.id,true,this.selectedTeamBetMatch);
            Character.account_tokens = param1.account_tokens;
            this.main.HUD.setBasicData();
            this.renderMatchBet();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function hasLabel(param1:MovieClip, param2:String) : String
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param1.currentLabels)
         {
            if(_loc3_.name == param2)
            {
               return _loc3_.name;
            }
         }
         return "null";
      }
      
      private function changePageBet(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPageBet > this.currentPageBet)
               {
                  ++this.currentPageBet;
                  this.renderMatchBet();
               }
               break;
            case "btn_prev":
               if(this.currentPageBet > 1)
               {
                  --this.currentPageBet;
                  this.renderMatchBet();
               }
         }
         this.selectedTeamBetMatch = "";
         this.selectedTeamBetMatchId = -1;
         this.updatePageNumberBet();
      }
      
      private function updatePageNumberBet() : void
      {
         this.panelMC.bettingMC.pageTxt.text = this.currentPageBet + "/" + this.totalPageBet;
      }
      
      private function closeMatchBetting(param1:MouseEvent) : void
      {
         this.panelMC.bettingMC.visible = false;
         this.selectedTeamBetMatch = "";
         this.selectedTeamBetMatchId = -1;
         this.currentPageBet = 1;
         this.totalPageBet = 1;
         this.selectedMatchBetData = null;
         this.selectedStageData = [];
         this.matchBetData = [];
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openMaterialMarket(param1:MouseEvent) : void
      {
         var _loc2_:* = getDefinitionByName("Panels.MaterialMarket") as Class;
         var _loc3_:* = new _loc2_(this.main,"worldcup2026");
         this.main.loader.addChild(_loc3_);
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
         this.panelMC.trainingMC.visible = false;
         this.panelMC.votingPeriodMC.visible = false;
         this.panelMC.countryListMC.visible = false;
         this.panelMC.betPrizeListMC.visible = false;
         this.panelMC.bettingMC.visible = false;
         this.panelMC.minigameMC.visible = false;
         this.panelMC.minigameCoverMC.visible = false;
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.timer)
         {
            this.timer.stop();
            this.timer = null;
         }
         this.main.handleVillageHUDVisibility(true);
         this.escapeKey.destroy();
         GF.removeAllChild(this.panelMC);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.escapeKey = null;
         this.panelMC = null;
         this.response = null;
         this.bossData = null;
         this.milestoneData = null;
         this.skillData = null;
         this.main = null;
      }
   }
}

