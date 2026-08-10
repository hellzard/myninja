package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class DailyGacha extends MovieClip
   {
      
      private static const MATERIAL_GACHA:String = "material_874";
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var character:*;
      
      private var eventHandler:*;
      
      private var selectedGacha:String;
      
      private var playType:String;
      
      private var playQty:int;
      
      private var topRewardData:Array = [];
      
      private var middleRewardData:Array = [];
      
      private var bottomRewardData:Array = [];
      
      private var currentPageMiddle:int = 1;
      
      private var totalPageMiddle:int = 0;
      
      private var currentPageBottom:int = 1;
      
      private var totalPageBottom:int = 0;
      
      private var currentPageHistory:int = 1;
      
      private var totalPageHistory:int = 1;
      
      private var bonusData:Array = [];
      
      private var historyData:Array;
      
      private const PRICE_COINS:Array = [1,3];
      
      private const PRICE_TOKENS:Array = [50,100,250];
      
      public function DailyGacha(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.popupPrizeListMC,this.closePrizeList);
         this.escapeKey.addListener(this.panelMC.bonusMC,this.closeBonusRewards);
         this.escapeKey.addListener(this.panelMC.historyMC,this.closeHistory);
         this.eventHandler = new EventHandler();
         this.getEventData();
         this.initUI();
      }
      
      private function getEventData() : void
      {
         this.main.loading(false);
         this.main.amf_manager.service("mGbT7HiV6WeVOUXp.8CDKfNk7hu3I",[Character.sessionkey,Character.char_id,Character.account_id],this.eventDataResponse);
      }
      
      private function eventDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.tokenTxt.text = String(Character.account_tokens);
            this.panelMC.IconTxt.text = param1.coin;
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
      
      private function initUI() : void
      {
         this.main.handleVillageHUDVisibility(false);
         this.panelMC.popupPrizeListMC.visible = false;
         this.panelMC.bonusMC.visible = false;
         this.panelMC.btnSkip.tick.visible = false;
         this.panelMC.historyMC.visible = false;
         this.panelMC.machineMC.gotoAndStop("idle");
         this.panelMC.titleTxt.text = "Daily Lucky Draw";
         this.main.initButton(this.panelMC.getMoreBtn,this.openRecharge,"Get More");
         this.main.initButton(this.panelMC.btnPanelMc.ticketBtn_1,this.playGacha,this.PRICE_COINS[0]);
         this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_1,this.playGacha,this.PRICE_TOKENS[0]);
         this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_2,this.playGacha,this.PRICE_TOKENS[2]);
         this.main.initButton(this.panelMC.btnPanelMc.ticketBtn_3,this.playGacha,this.PRICE_COINS[1]);
         this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_3,this.playGacha,this.PRICE_TOKENS[1]);
         this.main.initButton(this.panelMC.btnPanelMc.prizelistBtn,this.showPrizeList,"Prize List");
         this.main.initButton(this.panelMC.btnPanelMc.historyBtn,this.openBonusRewards,"Bonus Reward");
         this.main.initButton(this.panelMC.btnPanelMc.worldBtn,this.openHistory,"Global History");
         this.main.initButton(this.panelMC.btnPanelMc.personalBtn,this.openHistory,"Personal History");
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btnSkip,MouseEvent.CLICK,this.skipAnimation);
      }
      
      private function playGacha(param1:MouseEvent) : void
      {
         this.selectedGacha = param1.currentTarget.name;
         if(this.panelMC.btnSkip.tick.visible)
         {
            this.sendAmf();
            this.main.initButtonDisable(this.panelMC.btnPanelMc.ticketBtn_1,this.playGacha,this.PRICE_COINS[0]);
            this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_1,this.playGacha,this.PRICE_TOKENS[0]);
            this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_2,this.playGacha,this.PRICE_TOKENS[2]);
            this.main.initButtonDisable(this.panelMC.btnPanelMc.ticketBtn_3,this.playGacha,this.PRICE_COINS[1]);
            this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_3,this.playGacha,this.PRICE_TOKENS[1]);
            return;
         }
         this.panelMC.machineMC.addFrameScript(88,this.sendAmf,95,this.stopMachine);
         this.panelMC.machineMC.gotoAndPlay("draw");
         this.main.initButtonDisable(this.panelMC.btnPanelMc.ticketBtn_1,this.playGacha,this.PRICE_COINS[0]);
         this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_1,this.playGacha,this.PRICE_TOKENS[0]);
         this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_2,this.playGacha,this.PRICE_TOKENS[2]);
         this.main.initButtonDisable(this.panelMC.btnPanelMc.ticketBtn_3,this.playGacha,this.PRICE_COINS[1]);
         this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_3,this.playGacha,this.PRICE_TOKENS[1]);
      }
      
      private function stopMachine() : *
      {
         this.panelMC.machineMC.gotoAndStop("idle");
      }
      
      private function sendAmf() : *
      {
         this.playType = "";
         switch(this.selectedGacha)
         {
            case "ticketBtn_1":
               this.playType = "coins";
               this.playQty = 1;
               break;
            case "tokenBtn_1":
               this.playType = "tokens";
               this.playQty = 1;
               break;
            case "tokenBtn_2":
               this.playType = "tokens";
               this.playQty = 6;
               break;
            case "ticketBtn_3":
               this.playType = "coins";
               this.playQty = 3;
               break;
            case "tokenBtn_3":
               this.playType = "tokens";
               this.playQty = 3;
         }
         this.main.amf_manager.service("mGbT7HiV6WeVOUXp.Ckpdt4SSQ1wF",[Character.sessionkey,Character.char_id,this.playType,this.playQty],this.getGachaRewardsRes);
      }
      
      private function getGachaRewardsRes(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1.status == 1)
         {
            if(this.playType == "coins")
            {
               Character.removeMaterials(MATERIAL_GACHA,this.playQty);
            }
            else
            {
               _loc2_ = this.selectedGacha.replace("tokenBtn_","");
               _loc3_ = int(_loc2_) == 1 ? 0 : (int(_loc2_) == 2 ? 2 : 1);
               Character.account_tokens -= this.PRICE_TOKENS[_loc3_];
            }
            Character.addRewards(param1.rewards);
            this.main.giveReward(1,param1.rewards,"moyai");
            this.panelMC.tokenTxt.text = String(Character.account_tokens);
            this.panelMC.IconTxt.text = String(param1.coin);
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.main.initButton(this.panelMC.btnPanelMc.ticketBtn_1,this.playGacha,this.PRICE_COINS[0]);
         this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_1,this.playGacha,this.PRICE_TOKENS[0]);
         this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_2,this.playGacha,this.PRICE_TOKENS[2]);
         this.main.initButton(this.panelMC.btnPanelMc.ticketBtn_3,this.playGacha,this.PRICE_COINS[1]);
         this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_3,this.playGacha,this.PRICE_TOKENS[1]);
      }
      
      private function openBonusRewards(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("mGbT7HiV6WeVOUXp.221KnObLLsB2",[Character.sessionkey,Character.char_id,Character.account_id],this.openBonusRewardsRes);
      }
      
      private function openBonusRewardsRes(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.bonusData = param1.data;
            this.panelMC.bonusMC.visible = true;
            this.eventHandler.addListener(this.panelMC.bonusMC.btn_close,MouseEvent.CLICK,this.closeBonusRewards);
            this.panelMC.bonusMC.txt_draws.text = "You\'ve drawn " + param1.total_spins + " times !";
            _loc2_ = 0;
            while(_loc2_ < this.bonusData.length)
            {
               _loc3_ = param1.data[_loc2_].claimed == false && param1.total_spins >= int(this.bonusData[_loc2_].req) ? true : false;
               this.panelMC.bonusMC["btn_claim_" + _loc2_].visible = _loc3_;
               this.panelMC.bonusMC["txt_draw_" + _loc2_].text = this.bonusData[_loc2_].req + " Draws";
               if(_loc3_)
               {
                  this.eventHandler.addListener(this.panelMC.bonusMC["btn_claim_" + _loc2_],MouseEvent.CLICK,this.onClaimBonusRequest);
               }
               _loc2_++;
            }
            this.showRewardsBonus();
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
      
      private function showRewardsBonus() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.bonusData.length)
         {
            this.panelMC.bonusMC["iconMc" + _loc1_].visible = true;
            this.panelMC.bonusMC["iconMc" + _loc1_].amountTxt.visible = false;
            this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.visible = false;
            if(Character.hasSkill(this.bonusData[_loc1_].id) > 0)
            {
               this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.visible = true;
               this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.bonusData[_loc1_].id) > 0)
            {
               this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.visible = true;
               this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.text = "Owned";
            }
            _loc2_ = int(this.bonusData[_loc1_].id.split(":")[1]);
            if(_loc2_ > 1)
            {
               this.panelMC.bonusMC["iconMc" + _loc1_].amountTxt.visible = true;
               this.panelMC.bonusMC["iconMc" + _loc1_].amountTxt.text = "x" + String(_loc2_);
            }
            NinjaSage.loadItemIcon(this.panelMC.bonusMC["iconMc" + _loc1_],this.bonusData[_loc1_].id);
            _loc1_++;
         }
      }
      
      private function onClaimBonusRequest(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.currentTarget.name.replace("btn_claim_",""));
         this.main.amf_manager.service("mGbT7HiV6WeVOUXp.O6gI1mxCsKix",[Character.sessionkey,Character.char_id,_loc2_],this.onClaimBonusResponse);
      }
      
      private function onClaimBonusResponse(param1:Object) : void
      {
         if(param1.status > 0)
         {
            if(param1.status == 1)
            {
               this.panelMC.bonusMC.visible = false;
               Character.addRewards(param1.reward);
               this.main.HUD.setBasicData();
               this.main.giveReward(1,param1.reward,"moyai");
               this.panelMC.tokenTxt.text = String(Character.account_tokens);
            }
            else
            {
               this.main.showMessage(param1.result);
            }
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function closeBonusRewards(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this.panelMC.bonusMC["iconMc" + _loc2_].rewardIcon.tooltip = null;
            this.panelMC.bonusMC["iconMc" + _loc2_].skillIcon.tooltip = null;
            GF.removeAllChild(this.panelMC.bonusMC["iconMc" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.bonusMC["iconMc" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         this.panelMC.bonusMC.visible = false;
         System.gc();
      }
      
      private function showPrizeList(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("mGbT7HiV6WeVOUXp.VQyTamsBypGu",[Character.sessionkey,Character.char_id],this.prizeListResponse);
      }
      
      private function prizeListResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.topRewardData = param1.top;
            this.middleRewardData = param1.mid;
            this.bottomRewardData = param1.common;
            this.panelMC.popupPrizeListMC.visible = true;
            this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.prevBtn_1,MouseEvent.CLICK,this.changePage);
            this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.nextBtn_1,MouseEvent.CLICK,this.changePage);
            this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.prevBtn_2,MouseEvent.CLICK,this.changePage);
            this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.nextBtn_2,MouseEvent.CLICK,this.changePage);
            this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.btnClose,MouseEvent.CLICK,this.closePrizeList);
            this.panelMC.popupPrizeListMC.panelMC.titleTxt.text = "Reward List";
            this.panelMC.popupPrizeListMC.panelMC.dec1Txt.text = "Biggest Prize";
            this.panelMC.popupPrizeListMC.panelMC.dec2Txt.text = "Medium Prize";
            this.panelMC.popupPrizeListMC.panelMC.dec3Txt.text = "Consolation Prize";
            this.showRewardsTop();
            this.showRewardsMiddle();
            this.showRewardsBottom();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function closePrizeList(param1:MouseEvent) : *
      {
         this.panelMC.popupPrizeListMC.visible = false;
         this.currentPageMiddle = 1;
         this.currentPageBottom = 1;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc2_].rewardIcon.tooltip = null;
            this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc2_].skillIcon.tooltip = null;
            GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 10)
         {
            this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc2_].rewardIcon.tooltip = null;
            this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc2_].skillIcon.tooltip = null;
            GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc2_].skillIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         System.gc();
      }
      
      private function openHistory(param1:MouseEvent) : void
      {
         this.main.loading(true);
         var _loc2_:* = param1.currentTarget.name;
         if(_loc2_ == "personalBtn")
         {
            this.panelMC.historyMC.titleTxt.text = "Personal Prize History";
            this.main.amf_manager.service("mGbT7HiV6WeVOUXp.JoRUblW1NE5c",[Character.char_id,Character.sessionkey],this.historyResponse);
         }
         else
         {
            this.panelMC.historyMC.titleTxt.text = "Global Prize History";
            this.main.amf_manager.service("mGbT7HiV6WeVOUXp.q4D9Zk8W2z8i",[Character.char_id,Character.sessionkey],this.historyResponse);
         }
      }
      
      private function historyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.historyData = param1.histories;
            this.initHistory();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function initHistory() : void
      {
         this.panelMC.historyMC.visible = true;
         this.eventHandler.addListener(this.panelMC.historyMC.btnClose,MouseEvent.CLICK,this.closeHistory);
         this.eventHandler.addListener(this.panelMC.historyMC.btn_next,MouseEvent.CLICK,this.changePageHistory);
         this.eventHandler.addListener(this.panelMC.historyMC.btn_prev,MouseEvent.CLICK,this.changePageHistory);
         this.totalPageHistory = Math.max(1,Math.ceil(this.historyData.length / 10));
         this.updatePageNumberHistory();
         this.renderHistoryList();
      }
      
      private function renderHistoryList() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageHistory - 1) * 10);
            this.panelMC.historyMC["history_" + _loc1_].visible = false;
            this.panelMC.historyMC["history_" + _loc1_].coinIcon.visible = false;
            this.panelMC.historyMC["history_" + _loc1_].tokenIcon.visible = false;
            if(this.historyData.length > _loc2_)
            {
               this.panelMC.historyMC["history_" + _loc1_].visible = true;
               this.panelMC.historyMC["history_" + _loc1_].rankTxt.text = String(_loc2_ + 1);
               this.panelMC.historyMC["history_" + _loc1_].nameTxt.text = "[" + this.historyData[_loc2_].id + "] " + this.historyData[_loc2_].name;
               this.panelMC.historyMC["history_" + _loc1_].levelTxt.text = this.historyData[_loc2_].level;
               this.panelMC.historyMC["history_" + _loc1_].detailTxt.text = this.historyData[_loc2_].obtained_at + " | Draw " + this.historyData[_loc2_].spin + "x";
               if(this.historyData[_loc2_].currency == 1)
               {
                  this.panelMC.historyMC["history_" + _loc1_].tokenIcon.visible = true;
               }
               else
               {
                  this.panelMC.historyMC["history_" + _loc1_].coinIcon.visible = true;
               }
               NinjaSage.loadItemIcon(this.panelMC.historyMC["history_" + _loc1_].iconMC,this.historyData[_loc2_].reward);
            }
            _loc1_++;
         }
      }
      
      private function changePageHistory(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPageHistory > this.currentPageHistory)
               {
                  ++this.currentPageHistory;
                  this.renderHistoryList();
               }
               break;
            case "btn_prev":
               if(this.currentPageHistory > 1)
               {
                  --this.currentPageHistory;
                  this.renderHistoryList();
               }
         }
         this.updatePageNumberHistory();
      }
      
      private function updatePageNumberHistory() : void
      {
         this.panelMC.historyMC.pageTxt.text = this.currentPageHistory + "/" + this.totalPageHistory;
      }
      
      private function closeHistory(param1:MouseEvent) : void
      {
         this.panelMC.historyMC.visible = false;
         this.currentPageHistory = 1;
         this.totalPageHistory = 1;
         this.eventHandler.removeListener(this.panelMC.historyMC.btnClose,MouseEvent.CLICK,this.closeHistory);
         this.eventHandler.removeListener(this.panelMC.historyMC.btn_next,MouseEvent.CLICK,this.changePageHistory);
         this.eventHandler.removeListener(this.panelMC.historyMC.btn_prev,MouseEvent.CLICK,this.changePageHistory);
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            this.panelMC.historyMC["history_" + _loc2_].iconMC.rewardIcon.tooltip = null;
            this.panelMC.historyMC["history_" + _loc2_].iconMC.skillIcon.tooltip = null;
            GF.removeAllChild(this.panelMC.historyMC["history_" + _loc2_].iconMC.rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.historyMC["history_" + _loc2_].iconMC.skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function showRewardsTop() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.topRewardData.length)
         {
            this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].visible = true;
            this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].amountTxt.visible = false;
            this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.visible = false;
            if(Character.hasSkill(this.topRewardData[_loc1_]) > 0)
            {
               this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.visible = true;
               this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.topRewardData[_loc1_]) > 0)
            {
               this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.visible = true;
               this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.text = "Owned";
            }
            NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_],this.topRewardData[_loc1_]);
            _loc1_++;
         }
      }
      
      private function showRewardsMiddle() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageMiddle - 1) * 10);
            this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].visible = false;
            if(this.middleRewardData.length > _loc2_)
            {
               this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].visible = true;
               this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].amountTxt.visible = false;
               this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.visible = false;
               if(Character.hasSkill(this.middleRewardData[_loc2_]) > 0)
               {
                  this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.middleRewardData[_loc2_]) > 0)
               {
                  this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.text = "Owned";
               }
               GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].skillIcon.iconHolder);
               NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_],this.middleRewardData[_loc2_]);
            }
            _loc1_++;
         }
         this.updatePageNumber();
         this.totalPageMiddle = Math.max(Math.ceil(this.middleRewardData.length / 10),1);
      }
      
      private function showRewardsBottom() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageBottom - 1) * 10);
            this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].visible = false;
            if(this.bottomRewardData.length > _loc2_)
            {
               this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].visible = true;
               this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].amountTxt.visible = false;
               this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.visible = false;
               if(Character.hasSkill(this.bottomRewardData[_loc2_]) > 0)
               {
                  this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.bottomRewardData[_loc2_]) > 0)
               {
                  this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.text = "Owned";
               }
               GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].skillIcon.iconHolder);
               NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_],this.bottomRewardData[_loc2_]);
            }
            _loc1_++;
         }
         this.updatePageNumber();
         this.totalPageBottom = Math.max(Math.ceil(this.bottomRewardData.length / 10),1);
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "nextBtn_1":
               if(this.totalPageMiddle > this.currentPageMiddle)
               {
                  ++this.currentPageMiddle;
                  this.showRewardsMiddle();
               }
               break;
            case "prevBtn_1":
               if(this.currentPageMiddle > 1)
               {
                  --this.currentPageMiddle;
                  this.showRewardsMiddle();
               }
               break;
            case "nextBtn_2":
               if(this.totalPageBottom > this.currentPageBottom)
               {
                  ++this.currentPageBottom;
                  this.showRewardsBottom();
               }
               break;
            case "prevBtn_2":
               if(this.currentPageBottom > 1)
               {
                  --this.currentPageBottom;
                  this.showRewardsBottom();
               }
         }
      }
      
      private function updatePageNumber() : *
      {
         if(this.currentPageMiddle == 1)
         {
            this.panelMC.popupPrizeListMC.panelMC.prevBtn_1.visible = false;
         }
         else
         {
            this.panelMC.popupPrizeListMC.panelMC.prevBtn_1.visible = true;
         }
         if(this.currentPageBottom == 1)
         {
            this.panelMC.popupPrizeListMC.panelMC.prevBtn_2.visible = false;
         }
         else
         {
            this.panelMC.popupPrizeListMC.panelMC.prevBtn_2.visible = true;
         }
         if(this.totalPageMiddle == this.currentPageMiddle)
         {
            this.panelMC.popupPrizeListMC.panelMC.nextBtn_1.visible = false;
         }
         else
         {
            this.panelMC.popupPrizeListMC.panelMC.nextBtn_1.visible = true;
         }
         if(this.totalPageBottom == this.currentPageBottom)
         {
            this.panelMC.popupPrizeListMC.panelMC.nextBtn_2.visible = false;
         }
         else
         {
            this.panelMC.popupPrizeListMC.panelMC.nextBtn_2.visible = true;
         }
      }
      
      private function skipAnimation(param1:MouseEvent) : void
      {
         this.panelMC.btnSkip.tick.visible = !this.panelMC.btnSkip.tick.visible;
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "getMoreBtn")
         {
            this.main.loadPanel("Panels.Recharge");
         }
         else
         {
            this.main.loadExternalSwfPanel("Headquarter","Headquarter");
         }
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
         this.main.HUD.setBasicData();
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.main.removeExternalSwfPanel();
         this.closeBonusRewards(null);
         this.closePrizeList(null);
         this.bonusData = [];
         this.topRewardData = [];
         this.middleRewardData = [];
         this.bottomRewardData = [];
         this.main = null;
         this.character = null;
         this.eventHandler = null;
         this.panelMC.stopAllMovieClips();
         GF.removeAllChild(this.panelMC);
      }
   }
}

