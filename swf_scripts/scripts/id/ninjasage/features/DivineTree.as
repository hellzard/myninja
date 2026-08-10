package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.StatManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class DivineTree extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      private var main:*;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var statManager:StatManager;
      
      private var treeData:Object;
      
      private var response:Object;
      
      private var milestoneData:Object;
      
      private var leaderboardData:Object;
      
      private var playerLeaderboardData:Object;
      
      private var currentPage:int;
      
      private var totalPage:int;
      
      private var outfits:Array;
      
      private var confirmation:Confirmation;
      
      public function DivineTree(param1:*, param2:MovieClip)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.treeListMC.previewMC,this.closeTreeListPreview);
         this.eventHandler = new EventHandler();
         this.statManager = new StatManager();
         this.treeData = GameData.get("divinetree");
         this.milestoneData = [];
         this.outfits = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.treeData.milestone.length)
         {
            this.milestoneData.push({
               "rewardId":this.treeData.milestone[_loc3_].id.replace("%s",Character.character_gender),
               "rewardReq":this.treeData.milestone[_loc3_].requirement,
               "rewardQty":this.treeData.milestone[_loc3_].quantity
            });
            _loc3_++;
         }
         this.dummyResponse();
         this.hidePopups();
         this.initButton();
         this.initUI();
      }
      
      private function dummyResponse() : void
      {
         this.response = {
            "status":1,
            "data":{
               "level":0,
               "experience":23,
               "tree":"tree_rosethornsentinel",
               "chance":3,
               "total_harvest":17
            }
         };
      }
      
      private function initButton() : void
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_rules,MouseEvent.CLICK,this.openRules);
         this.eventHandler.addListener(this.panelMC.btn_leaderboard,MouseEvent.CLICK,this.openLeaderboard);
         this.eventHandler.addListener(this.panelMC.btn_milestone,MouseEvent.CLICK,this.openMilestone);
         this.eventHandler.addListener(this.panelMC.btn_seed,MouseEvent.CLICK,this.openTreeList);
         this.eventHandler.addListener(this.panelMC.btn_Headquarter,MouseEvent.CLICK,this.openHeadquarter);
         this.eventHandler.addListener(this.panelMC.btn_buy_token,MouseEvent.CLICK,this.buyToken);
         this.eventHandler.addListener(this.panelMC.wateringMC.btn_watering_can,MouseEvent.CLICK,this.watering);
         this.eventHandler.addListener(this.panelMC.wateringMC.btn_buy_water,MouseEvent.CLICK,this.buyWaterConfirmation);
         this.eventHandler.addListener(this.panelMC.buffMC.btn_open,MouseEvent.CLICK,this.openBuff);
         this.eventHandler.addListener(this.panelMC.buffMC.content.btn_close,MouseEvent.CLICK,this.closeBuff);
         this.eventHandler.addListener(this.panelMC.rulesMC.btn_close,MouseEvent.CLICK,this.closeRules);
         this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_close,MouseEvent.CLICK,this.closeLeaderboard);
         this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close,MouseEvent.CLICK,this.closeMilestone);
         this.eventHandler.addListener(this.panelMC.treeListMC.btn_close,MouseEvent.CLICK,this.closeTreeList);
         this.eventHandler.addListener(this.panelMC.treeListMC.previewMC.btn_close,MouseEvent.CLICK,this.closeTreeListPreview);
         NinjaSage.showDynamicTooltip(this.panelMC.btn_milestone,"Harvest Milestone");
         NinjaSage.showDynamicTooltip(this.panelMC.btn_leaderboard,"Harvest Leaderboard");
         NinjaSage.showDynamicTooltip(this.panelMC.btn_rules,"Divine Tree Rules");
         NinjaSage.showDynamicTooltip(this.panelMC.buffMC.btn_open,"XP & Gold Bonus");
      }
      
      private function initUI() : void
      {
         this.panelMC.txt_token.text = Character.account_tokens;
         this.panelMC.txt_gold.text = Character.character_gold;
         this.panelMC.frame.txt_name.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.panelMC.frame.txt_name);
         this.panelMC.frame.txt_lvl.text = Character.character_lvl;
         this.panelMC.frame.txt_hp.text = StatManager.calculate_stats_with_data("hp") + " / " + StatManager.calculate_stats_with_data("hp");
         this.panelMC.frame.txt_cp.text = StatManager.calculate_stats_with_data("cp") + " / " + StatManager.calculate_stats_with_data("cp");
         this.panelMC.frame.txt_xp.text = Character.character_xp + " / " + String(this.statManager.calculate_xp(int(Character.character_lvl)));
         this.panelMC.frame.txt_sp.text = "0 / " + StatManager.calculate_stats_with_data("sp");
         this.panelMC.frame.spBar.scaleX = 1;
         this.panelMC.frame.xpBar.scaleX = Math.max(Math.min(int(Character.character_xp) / int(this.statManager.calculate_xp(int(Character.character_lvl))),1),0);
         if(int(Character.character_lvl) <= 80 && int(Character.character_rank) < 8)
         {
            this.panelMC.frame.txt_sp.visible = false;
            this.panelMC.frame.spBar.visible = false;
            this.panelMC.frame.spBarBg.visible = false;
            this.panelMC.frame.spIcon.visible = false;
            this.panelMC.frame.black_bg.height = 38.45;
         }
         var _loc1_:String = this.response.data.level == 0 ? "Seedling" : "Level " + String(this.response.data.level);
         this.panelMC.xpBar.txt_level.text = _loc1_;
         this.panelMC.xpBar.txt_xp.text = this.response.data.experience + " / " + String(this.treeData.experience[this.response.data.level]);
         this.panelMC.xpBar.bar.scaleX = Math.max(Math.min(int(this.response.data.experience) / int(this.treeData.experience[this.response.data.level]),1),0);
         this.panelMC.wateringMC.txt_watering_chances.text = "Watering Chances: " + this.response.data.chance;
         if(this.response.data.level == 0)
         {
            this.panelMC.btn_seed.visible = true;
            this.panelMC.tree.visible = false;
         }
         else
         {
            this.panelMC.btn_seed.visible = false;
            this.panelMC.tree.visible = true;
            this.panelMC.tree.gotoAndStop(this.response.data.tree);
            this.panelMC.tree.tree.gotoAndStop(this.response.data.level);
            if(this.response.data.level == 3)
            {
               this.eventHandler.addListener(this.panelMC.tree,MouseEvent.CLICK,this.claimRewards);
            }
         }
      }
      
      private function hidePopups() : void
      {
         this.panelMC.rulesMC.visible = false;
         this.panelMC.leaderboardMC.visible = false;
         this.panelMC.milestoneMC.visible = false;
         this.panelMC.treeListMC.visible = false;
         this.panelMC.treeListMC.previewMC.visible = false;
         this.panelMC.ani_watering.visible = false;
         this.panelMC.buffMC.content.visible = false;
      }
      
      private function openTreeList(param1:MouseEvent) : void
      {
         this.panelMC.treeListMC.visible = true;
         var _loc2_:MovieClip = this.panelMC.treeListMC;
         var _loc3_:int = 0;
         while(_loc3_ < 6)
         {
            _loc2_["tree_" + _loc3_].txt_name.text = this.treeData.trees[_loc3_].name;
            _loc2_["tree_" + _loc3_].treeMC.gotoAndStop(_loc3_ + 1);
            this.eventHandler.addListener(_loc2_["tree_" + _loc3_].btn_preview,MouseEvent.CLICK,this.openTreePreview);
            _loc3_++;
         }
      }
      
      private function openTreePreview(param1:MouseEvent) : void
      {
         this.panelMC.treeListMC.previewMC.visible = true;
         var _loc2_:MovieClip = this.panelMC.treeListMC.previewMC;
         var _loc3_:int = int(param1.currentTarget.parent.name.replace("tree_",""));
         var _loc4_:int = 1;
         while(_loc4_ <= 3)
         {
            _loc2_["level_" + _loc4_].txt_level.text = "Level " + _loc4_;
            _loc2_["level_" + _loc4_].treeMC.gotoAndStop(_loc3_ + 1);
            _loc2_["level_" + _loc4_].treeMC.tree.gotoAndStop(_loc4_);
            _loc4_++;
         }
         _loc2_.txt_name.text = this.treeData.trees[_loc3_].name;
         _loc2_.iconMc.amountTxt.text = "";
         _loc2_.iconMc.ownedTxt.text = "";
         NinjaSage.loadItemIcon(_loc2_.iconMc,this.treeData.trees[_loc3_].rewards[0]);
         this.eventHandler.addListener(_loc2_.btn_close,MouseEvent.CLICK,this.closeTreeListPreview);
      }
      
      private function claimRewards(param1:MouseEvent) : void
      {
      }
      
      private function openRules(param1:MouseEvent) : void
      {
         this.panelMC.rulesMC.visible = true;
         var _loc2_:MovieClip = this.panelMC.rulesMC;
         _loc2_.txt_rules.htmlText = this.treeData.rules;
      }
      
      private function openLeaderboard(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("bQqnGVJtou5YIn69.fcigkFHrbhDR",[Character.char_id,Character.sessionkey,null],this.leaderboardResponse);
      }
      
      private function leaderboardResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.leaderboardMC.visible = true;
            this.leaderboardData = param1.data;
            this.playerLeaderboardData = {
               "char_id":Character.char_id,
               "name":Character.character_name,
               "rank":1,
               "total_harvest":param1.player_kill
            };
            this.currentPage = 1;
            this.totalPage = Math.max(1,Math.ceil(this.leaderboardData.length / 10));
            this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_prev,MouseEvent.CLICK,this.changePage);
            this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_next,MouseEvent.CLICK,this.changePage);
            this.panelMC.leaderboardMC["playerRankInfoMc"].holder.scaleX = 1.6;
            this.panelMC.leaderboardMC["playerRankInfoMc"].holder.scaleY = 1.6;
            this.panelMC.leaderboardMC["playerRankInfoMc"].holder.addChild(this.main.getPlayerHead());
            this.panelMC.leaderboardMC["playerRankInfoMc"].txt_name.htmlText = Character.colorifyText(this.playerLeaderboardData.char_id,this.playerLeaderboardData.name,this.panelMC.leaderboardMC["playerRankInfoMc"].txt_name);
            this.panelMC.leaderboardMC["playerRankInfoMc"].txt_total_harvest.text = this.playerLeaderboardData.total_harvest + " Total Harvest";
            this.panelMC.leaderboardMC["playerRankInfoMc"].txt_rank.text = this.playerLeaderboardData.rank;
            this.updatePageText();
            this.renderLeaderboardUI();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function getPlayerHead(param1:*) : *
      {
         if(this.outfits[param1])
         {
            this.outfits[param1].destroy();
            this.outfits[param1] = null;
         }
         this.outfits[param1] = new OutfitManager();
         var _loc2_:* = new CharHead();
         _loc2_.scaleX = 1.6;
         _loc2_.scaleY = 1.6;
         this.outfits[param1].fillHead(_loc2_,this.leaderboardData[param1].sets.hair_style,this.leaderboardData[param1].sets.face,this.leaderboardData[param1].sets.hair_color,this.leaderboardData[param1].sets.skin_color);
         return _loc2_;
      }
      
      private function renderLeaderboardUI() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.panelMC.leaderboardMC["rankInfoMc" + _loc1_].visible = false;
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 10);
            if(this.leaderboardData.length > _loc2_)
            {
               this.panelMC.leaderboardMC["rankInfoMc" + _loc1_].visible = true;
               this.panelMC.leaderboardMC["rankInfoMc" + _loc1_].txt_name.htmlText = Character.colorifyText(this.leaderboardData[_loc2_].char_id,this.leaderboardData[_loc2_].name,this.panelMC.leaderboardMC["rankInfoMc" + _loc1_].txt_name);
               this.panelMC.leaderboardMC["rankInfoMc" + _loc1_].txt_total_harvest.text = this.leaderboardData[_loc2_].kill + " Total Harvest";
               this.panelMC.leaderboardMC["rankInfoMc" + _loc1_].txt_rank.text = _loc2_ + 1;
               this.panelMC.leaderboardMC["rankInfoMc" + _loc1_].holder.addChild(this.getPlayerHead(_loc2_));
            }
            _loc1_++;
         }
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderLeaderboardUI();
               }
               break;
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderLeaderboardUI();
               }
         }
         this.updatePageText();
      }
      
      private function updatePageText() : void
      {
         this.panelMC.leaderboardMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function openMilestone(param1:MouseEvent) : *
      {
         this.panelMC.milestoneMC.visible = true;
         this.panelMC.milestoneMC.txt_title.text = "Harvest Milestone";
         this.eventHandler.addListener(this.panelMC.milestoneMC.btn_close,MouseEvent.CLICK,this.closeMilestone);
         this.main.loading(true);
         this.main.amf_manager.service("Kut8xeaxJWcRM9w1.RQEjNd1KByfL",[Character.char_id,Character.sessionkey],this.openMilestoneRewards);
         var _loc2_:* = 0;
         while(_loc2_ < 8)
         {
            this.panelMC.milestoneMC["reward_" + _loc2_]["txt_required"].text = String(this.milestoneData[_loc2_].rewardReq) + " Harvest";
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
            this.panelMC.milestoneMC.txt_total_harvest.text = "Harvest " + param1.milestone;
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               _loc3_ = param1.rewards[_loc2_] == false && param1.milestone >= this.milestoneData[_loc2_].rewardReq ? true : false;
               _loc4_ = param1.rewards[_loc2_] == true;
               this.panelMC.milestoneMC["reward_" + _loc2_]["btn_claim"].visible = _loc3_;
               this.panelMC.milestoneMC["reward_" + _loc2_].lock.visible = true;
               this.panelMC.milestoneMC["reward_" + _loc2_].star_unlock.visible = false;
               if(_loc3_)
               {
                  this.panelMC.milestoneMC["reward_" + _loc2_].lock.visible = false;
                  this.panelMC.milestoneMC["reward_" + _loc2_].star_unlock.visible = true;
                  this.eventHandler.addListener(this.panelMC.milestoneMC["reward_" + _loc2_]["btn_claim"],MouseEvent.CLICK,this.onClaimBonusRequest);
               }
               if(_loc4_)
               {
                  this.panelMC.milestoneMC["reward_" + _loc2_].lock.visible = false;
                  this.panelMC.milestoneMC["reward_" + _loc2_].star_unlock.visible = true;
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
         this.main.amf_manager.service("Kut8xeaxJWcRM9w1.vw5jCcOzaeXe",[Character.char_id,Character.sessionkey,_loc2_],this.onClaimBonusResponse);
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
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            GF.removeAllChild(this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.milestoneMC["reward_" + _loc2_]["iconMc"].skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function watering(param1:MouseEvent) : void
      {
         this.wateringResponse({"status":1});
      }
      
      private function wateringResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.ani_watering.visible = true;
            this.panelMC.wateringMC.btn_watering_can.visible = false;
            this.panelMC.ani_watering.addFrameScript(this.panelMC.ani_watering.totalFrames - 1,this.closeWatering);
            this.panelMC.ani_watering.gotoAndPlay(1);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeWatering() : void
      {
         this.panelMC.ani_watering.visible = false;
         this.panelMC.wateringMC.btn_watering_can.visible = true;
      }
      
      private function buyWaterConfirmation(param1:MouseEvent) : void
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to buy water for 10 tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyWater);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function removeConfirmation(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
      }
      
      private function buyWater(param1:MouseEvent) : void
      {
         this.removeConfirmation(null);
         this.buyWaterResponse({"status":1});
      }
      
      private function buyWaterResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.wateringMC.txt_watering_chances.text = "Watering Chances: " + param1.chance;
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openBuff(param1:MouseEvent) : void
      {
         this.panelMC.buffMC.content.visible = true;
         var _loc2_:MovieClip = this.panelMC.buffMC.content;
         var _loc3_:int = 0;
         while(_loc3_ < this.treeData.buffs.length)
         {
            _loc2_["buff_" + _loc3_]["txt_percent"].text = this.treeData.buffs[_loc3_].rewards;
            _loc2_["buff_" + _loc3_].lockMC.visible = this.response.data.total_harvest < this.treeData.buffs[_loc3_].harvest_requirement;
            NinjaSage.showDynamicTooltip(_loc2_["buff_" + _loc3_]["clickmask"],this.treeData.buffs[_loc3_].description);
            _loc3_++;
         }
         NinjaSage.showDynamicTooltip(_loc2_["clickmask_bar"],"Total Harvest: " + this.response.data.total_harvest);
         _loc2_.bar.scaleX = Math.max(Math.min(this.response.data.total_harvest / this.treeData.buffs[this.treeData.buffs.length - 1].harvest_requirement,1),0);
      }
      
      private function openHeadquarter(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("Headquarter","Headquarter");
         this.destroy();
      }
      
      private function buyToken(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function closeRules(param1:MouseEvent) : void
      {
         this.panelMC.rulesMC.visible = false;
      }
      
      private function closeLeaderboard(param1:MouseEvent) : void
      {
         this.panelMC.leaderboardMC.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.outfits.length)
         {
            if(this.outfits[_loc2_])
            {
               this.outfits[_loc2_].destroy();
               this.outfits[_loc2_] = null;
            }
            _loc2_++;
         }
      }
      
      private function closeTreeList(param1:MouseEvent) : void
      {
         this.panelMC.treeListMC.visible = false;
      }
      
      private function closeTreeListPreview(param1:MouseEvent) : void
      {
         this.panelMC.treeListMC.previewMC.visible = false;
      }
      
      private function closeBuff(param1:MouseEvent) : void
      {
         this.panelMC.buffMC.content.visible = false;
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
         this.main = null;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.panelMC.ani_watering.addFrameScript(this.panelMC.ani_watering.totalFrames - 1,null);
         GF.removeAllChild(this.panelMC);
         var _loc1_:int = 0;
         while(_loc1_ < this.outfits.length)
         {
            if(this.outfits[_loc1_])
            {
               this.outfits[_loc1_].destroy();
               this.outfits[_loc1_] = null;
            }
            _loc1_++;
         }
         this.outfits = null;
         this.panelMC = null;
      }
   }
}

