package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.PreviewManager;
   import Storage.Character;
   import Storage.GameData;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class EasterGacha extends MovieClip
   {
      
      private static const MATERIAL_GACHA:String = "material_2250";
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var selectedGacha:String;
      
      private var playType:String;
      
      private var playQty:int;
      
      private var topRewardData:Array;
      
      private var middleRewardData:Array;
      
      private var bottomRewardData:Array;
      
      private var currentPageMiddle:int = 1;
      
      private var totalPageMiddle:int = 0;
      
      private var currentPageBottom:int = 1;
      
      private var totalPageBottom:int = 0;
      
      private var currentPageHistory:int = 1;
      
      private var totalPageHistory:int = 1;
      
      private var bonusData:Array;
      
      private var historyData:Array;
      
      private const PRICE_COINS:Array = [1,3];
      
      private const PRICE_TOKENS:Array = [20,50,100];
      
      private var loaderSwf:BulkLoader;
      
      private var previewMC:PreviewManager;
      
      private var selectedPreviewSkill:String;
      
      private var selectedPreviewItem:String;
      
      private var obtainedGachaRewards:Array;
      
      private var outfits:Array;
      
      public function EasterGacha(param1:*, param2:*)
      {
         this.outfits = [];
         var _loc3_:* = GameData.get("easter2026");
         this.topRewardData = this.fillRewards(_loc3_.gacha.top);
         this.middleRewardData = this.fillRewards(_loc3_.gacha.mid);
         this.bottomRewardData = this.fillRewards(_loc3_.gacha.common);
         this.bonusData = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.gacha.milestone.length)
         {
            this.bonusData.push({
               "rewardId":_loc3_.gacha.milestone[_loc4_].id.replace("%s",Character.character_gender),
               "rewardReq":_loc3_.gacha.milestone[_loc4_].requirement,
               "rewardQty":_loc3_.gacha.milestone[_loc4_].quantity
            });
            _loc4_++;
         }
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.previewItemMC,this.closeItemPreview);
         this.escapeKey.addListener(this.panelMC.previewMC,this.closePreview);
         this.eventHandler = new EventHandler();
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.getEventData();
         this.initUI();
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
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.ZyD6h0uzyu7R",[Character.char_id,Character.sessionkey,Character.account_id],this.eventDataResponse);
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
         this.panelMC.popupPrizeListMC.visible = false;
         this.panelMC.bonusMC.visible = false;
         this.panelMC.btnSkip.tick.visible = false;
         this.panelMC.historyMC.visible = false;
         this.panelMC.previewMC.visible = false;
         this.panelMC.previewItemMC.visible = false;
         this.panelMC.machineMC.gotoAndStop("idle");
         this.panelMC.titleTxt.text = "Lucky Draw";
         this.main.initButton(this.panelMC.ticketBtn_1,this.playGacha,this.PRICE_COINS[0]);
         this.main.initButton(this.panelMC.tokenBtn_1,this.playGacha,this.PRICE_TOKENS[0]);
         this.main.initButton(this.panelMC.tokenBtn_2,this.playGacha,this.PRICE_TOKENS[2]);
         this.main.initButton(this.panelMC.ticketBtn_3,this.playGacha,this.PRICE_COINS[1]);
         this.main.initButton(this.panelMC.tokenBtn_3,this.playGacha,this.PRICE_TOKENS[1]);
         this.eventHandler.addListener(this.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.prizelistBtn,MouseEvent.CLICK,this.showPrizeList);
         this.eventHandler.addListener(this.panelMC.historyBtn,MouseEvent.CLICK,this.openBonusRewards);
         this.eventHandler.addListener(this.panelMC.worldBtn,MouseEvent.CLICK,this.openHistory);
         this.eventHandler.addListener(this.panelMC.personalBtn,MouseEvent.CLICK,this.openHistory);
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btnSkip,MouseEvent.CLICK,this.skipAnimation);
         this.panelMC.machineMC.addFrameScript(88,this.showObtainedGachaRewards,95,this.stopMachine);
      }
      
      private function playGacha(param1:MouseEvent) : void
      {
         this.selectedGacha = param1.currentTarget.name;
         this.main.initButtonDisable(this.panelMC.ticketBtn_1,this.playGacha,this.PRICE_COINS[0]);
         this.main.initButtonDisable(this.panelMC.tokenBtn_1,this.playGacha,this.PRICE_TOKENS[0]);
         this.main.initButtonDisable(this.panelMC.tokenBtn_2,this.playGacha,this.PRICE_TOKENS[2]);
         this.main.initButtonDisable(this.panelMC.ticketBtn_3,this.playGacha,this.PRICE_COINS[1]);
         this.main.initButtonDisable(this.panelMC.tokenBtn_3,this.playGacha,this.PRICE_TOKENS[1]);
         this.sendAmf();
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
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.FBbe4f8zv1U8",[Character.char_id,Character.sessionkey,this.playType,this.playQty],this.getGachaRewardsRes);
      }
      
      private function getGachaRewardsRes(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1.status == 1)
         {
            this.obtainedGachaRewards = param1.rewards;
            if(!this.panelMC.btnSkip.tick.visible)
            {
               this.panelMC.machineMC.gotoAndPlay("draw");
            }
            else
            {
               this.showObtainedGachaRewards();
            }
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
         this.main.initButton(this.panelMC.ticketBtn_1,this.playGacha,this.PRICE_COINS[0]);
         this.main.initButton(this.panelMC.tokenBtn_1,this.playGacha,this.PRICE_TOKENS[0]);
         this.main.initButton(this.panelMC.tokenBtn_2,this.playGacha,this.PRICE_TOKENS[2]);
         this.main.initButton(this.panelMC.ticketBtn_3,this.playGacha,this.PRICE_COINS[1]);
         this.main.initButton(this.panelMC.tokenBtn_3,this.playGacha,this.PRICE_TOKENS[1]);
      }
      
      private function showObtainedGachaRewards() : void
      {
         this.main.giveReward(1,this.obtainedGachaRewards,"easter");
      }
      
      private function openBonusRewards(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.FoDQx7WUgz7q",[Character.char_id,Character.sessionkey,Character.account_id],this.openBonusRewardsRes);
      }
      
      private function openBonusRewardsRes(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.bonusMC.visible = true;
            this.eventHandler.addListener(this.panelMC.bonusMC.btn_close,MouseEvent.CLICK,this.closeBonusRewards);
            this.panelMC.bonusMC.txt_draws.text = "You\'ve drawn " + param1.total_spins + " times !";
            _loc2_ = 0;
            while(_loc2_ < this.bonusData.length)
            {
               _loc3_ = param1.data[_loc2_].claimed == false && param1.total_spins >= int(this.bonusData[_loc2_].rewardReq) ? true : false;
               this.panelMC.bonusMC["btn_claim_" + _loc2_].visible = _loc3_;
               this.panelMC.bonusMC["txt_draw_" + _loc2_].text = this.bonusData[_loc2_].rewardReq + " Draws";
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
         var _loc1_:int = 0;
         while(_loc1_ < this.bonusData.length)
         {
            this.panelMC.bonusMC["iconMc" + _loc1_].visible = true;
            this.panelMC.bonusMC["iconMc" + _loc1_].amountTxt.visible = false;
            this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.visible = false;
            this.panelMC.bonusMC["iconMc" + _loc1_].btn_preview.visible = this.checkIsItemOrSkill(this.bonusData[_loc1_].rewardId);
            this.panelMC.bonusMC["iconMc" + _loc1_].btn_preview.metaData = {"itemId":this.bonusData[_loc1_].rewardId};
            this.eventHandler.addListener(this.panelMC.bonusMC["iconMc" + _loc1_].btn_preview,MouseEvent.CLICK,this.openPreview);
            if(Character.hasSkill(this.bonusData[_loc1_].rewardId) > 0)
            {
               this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.visible = true;
               this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.bonusData[_loc1_].rewardId) > 0)
            {
               this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.visible = true;
               this.panelMC.bonusMC["iconMc" + _loc1_].ownedTxt.text = "Owned";
            }
            if(this.bonusData[_loc1_].rewardQty > 1)
            {
               this.panelMC.bonusMC["iconMc" + _loc1_].amountTxt.visible = true;
               this.panelMC.bonusMC["iconMc" + _loc1_].amountTxt.text = "x" + String(this.bonusData[_loc1_].rewardQty);
            }
            NinjaSage.loadItemIcon(this.panelMC.bonusMC["iconMc" + _loc1_],this.bonusData[_loc1_].rewardId);
            _loc1_++;
         }
      }
      
      private function onClaimBonusRequest(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.currentTarget.name.replace("btn_claim_",""));
         this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.783snEL0hRRT",[Character.char_id,Character.sessionkey,_loc2_],this.onClaimBonusResponse);
      }
      
      private function onClaimBonusResponse(param1:Object) : void
      {
         if(param1.status > 0)
         {
            if(param1.status == 1)
            {
               this.openBonusRewards(null);
               Character.addRewards(param1.reward);
               this.main.HUD.setBasicData();
               this.main.giveReward(1,param1.reward,"easter");
               this.panelMC.tokenTxt.text = String(Character.account_tokens);
               this.panelMC.IconTxt.text = Character.getMaterialAmount(MATERIAL_GACHA);
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
         this.panelMC.popupPrizeListMC.visible = true;
         this.eventHandler.addListener(this.panelMC.popupPrizeListMC.prevBtn_1,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.popupPrizeListMC.nextBtn_1,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.popupPrizeListMC.prevBtn_2,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.popupPrizeListMC.nextBtn_2,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.popupPrizeListMC.btnClose,MouseEvent.CLICK,this.closePrizeList);
         this.panelMC.popupPrizeListMC.titleTxt.text = "Reward List";
         this.showRewardsTop();
         this.showRewardsMiddle();
         this.showRewardsBottom();
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
            this.panelMC.popupPrizeListMC["IconMc0_" + _loc2_].rewardIcon.tooltip = null;
            this.panelMC.popupPrizeListMC["IconMc0_" + _loc2_].skillIcon.tooltip = null;
            GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc0_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc0_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            this.panelMC.popupPrizeListMC["IconMc1_" + _loc2_].rewardIcon.tooltip = null;
            this.panelMC.popupPrizeListMC["IconMc2_" + _loc2_].skillIcon.tooltip = null;
            GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc1_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc1_" + _loc2_].skillIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc2_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc2_" + _loc2_].skillIcon.iconHolder);
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
            this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.zLbmpPCP17Tu",[Character.char_id,Character.sessionkey],this.historyResponse);
         }
         else
         {
            this.panelMC.historyMC.titleTxt.text = "Global Prize History";
            this.main.amf_manager.service("dNybGv4T7OcLQ5Yq.MKZaXNQkaQh3",[Character.char_id,Character.sessionkey],this.historyResponse);
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
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
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
         this.totalPageHistory = Math.max(1,Math.ceil(this.historyData.length / 7));
         this.updatePageNumberHistory();
         this.renderHistoryList();
      }
      
      private function renderHistoryList() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageHistory - 1) * 7);
            this.panelMC.historyMC["history_" + _loc1_].visible = false;
            this.panelMC.historyMC["history_" + _loc1_].coinIcon.visible = false;
            this.panelMC.historyMC["history_" + _loc1_].tokenIcon.visible = false;
            this.panelMC.historyMC["history_" + _loc1_].iconMC.amountTxt.visible = false;
            this.panelMC.historyMC["history_" + _loc1_].iconMC.ownedTxt.visible = false;
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
               this.panelMC.historyMC["history_" + _loc1_].iconMC.btn_preview.visible = this.checkIsItemOrSkill(this.historyData[_loc2_].reward);
               this.panelMC.historyMC["history_" + _loc1_].iconMC.btn_preview.metaData = {"itemId":this.historyData[_loc2_].reward};
               this.eventHandler.addListener(this.panelMC.historyMC["history_" + _loc1_].iconMC.btn_preview,MouseEvent.CLICK,this.openPreview);
               if(Character.hasSkill(this.historyData[_loc2_].reward) > 0)
               {
                  this.panelMC.historyMC["history_" + _loc1_].iconMC.ownedTxt.visible = true;
                  this.panelMC.historyMC["history_" + _loc1_].iconMC.ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.historyData[_loc2_].reward) > 0)
               {
                  this.panelMC.historyMC["history_" + _loc1_].iconMC.ownedTxt.visible = true;
                  this.panelMC.historyMC["history_" + _loc1_].iconMC.ownedTxt.text = "Owned";
               }
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
         while(_loc2_ < 7)
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
            this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].visible = true;
            this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].amountTxt.visible = false;
            this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].ownedTxt.visible = false;
            this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].btn_preview.visible = this.checkIsItemOrSkill(this.topRewardData[_loc1_]);
            this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].btn_preview.metaData = {"itemId":this.topRewardData[_loc1_]};
            this.eventHandler.addListener(this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].btn_preview,MouseEvent.CLICK,this.openPreview);
            if(Character.hasSkill(this.topRewardData[_loc1_]) > 0)
            {
               this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].ownedTxt.visible = true;
               this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.topRewardData[_loc1_]) > 0)
            {
               this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].ownedTxt.visible = true;
               this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_].ownedTxt.text = "Owned";
            }
            NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC["IconMc0_" + _loc1_],this.topRewardData[_loc1_]);
            _loc1_++;
         }
      }
      
      private function showRewardsMiddle() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageMiddle - 1) * 8);
            this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].visible = false;
            if(this.middleRewardData.length > _loc2_)
            {
               this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].visible = true;
               this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].amountTxt.visible = false;
               this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].ownedTxt.visible = false;
               this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].btn_preview.visible = this.checkIsItemOrSkill(this.middleRewardData[_loc2_]);
               this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].btn_preview.metaData = {"itemId":this.middleRewardData[_loc2_]};
               this.eventHandler.addListener(this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].btn_preview,MouseEvent.CLICK,this.openPreview);
               if(Character.hasSkill(this.middleRewardData[_loc2_]) > 0)
               {
                  this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.middleRewardData[_loc2_]) > 0)
               {
                  this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].ownedTxt.text = "Owned";
               }
               GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_].skillIcon.iconHolder);
               NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC["IconMc1_" + _loc1_],this.middleRewardData[_loc2_]);
            }
            _loc1_++;
         }
         this.updatePageNumber();
         this.totalPageMiddle = Math.max(Math.ceil(this.middleRewardData.length / 8),1);
      }
      
      private function showRewardsBottom() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageBottom - 1) * 8);
            this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].visible = false;
            if(this.bottomRewardData.length > _loc2_)
            {
               this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].visible = true;
               this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].amountTxt.visible = false;
               this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].ownedTxt.visible = false;
               this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].btn_preview.visible = this.checkIsItemOrSkill(this.bottomRewardData[_loc2_]);
               this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].btn_preview.metaData = {"itemId":this.bottomRewardData[_loc2_]};
               this.eventHandler.addListener(this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].btn_preview,MouseEvent.CLICK,this.openPreview);
               if(Character.hasSkill(this.bottomRewardData[_loc2_]) > 0)
               {
                  this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.bottomRewardData[_loc2_]) > 0)
               {
                  this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].ownedTxt.text = "Owned";
               }
               GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_].skillIcon.iconHolder);
               NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC["IconMc2_" + _loc1_],this.bottomRewardData[_loc2_]);
            }
            _loc1_++;
         }
         this.updatePageNumber();
         this.totalPageBottom = Math.max(Math.ceil(this.bottomRewardData.length / 8),1);
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
            this.panelMC.popupPrizeListMC.prevBtn_1.visible = false;
         }
         else
         {
            this.panelMC.popupPrizeListMC.prevBtn_1.visible = true;
         }
         if(this.currentPageBottom == 1)
         {
            this.panelMC.popupPrizeListMC.prevBtn_2.visible = false;
         }
         else
         {
            this.panelMC.popupPrizeListMC.prevBtn_2.visible = true;
         }
         if(this.totalPageMiddle == this.currentPageMiddle)
         {
            this.panelMC.popupPrizeListMC.nextBtn_1.visible = false;
         }
         else
         {
            this.panelMC.popupPrizeListMC.nextBtn_1.visible = true;
         }
         if(this.totalPageBottom == this.currentPageBottom)
         {
            this.panelMC.popupPrizeListMC.nextBtn_2.visible = false;
         }
         else
         {
            this.panelMC.popupPrizeListMC.nextBtn_2.visible = true;
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
      
      private function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
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
         this.panelMC.machineMC.addFrameScript(88,null,95,null);
         this.obtainedGachaRewards = null;
         this.main.HUD.setBasicData();
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.loaderSwf.clear();
         this.loaderSwf = null;
         this.main.removeExternalSwfPanel();
         this.closeBonusRewards(null);
         this.closePrizeList(null);
         this.bonusData = [];
         this.topRewardData = [];
         this.middleRewardData = [];
         this.bottomRewardData = [];
         this.main = null;
         this.eventHandler = null;
         this.panelMC.stopAllMovieClips();
         GF.removeAllChild(this.panelMC);
      }
   }
}
