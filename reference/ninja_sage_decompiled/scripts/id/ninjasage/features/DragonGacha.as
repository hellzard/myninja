package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class DragonGacha extends MovieClip
   {
      
      private static const MATERIAL_GACHA:String = "material_773";
      
      private static const TITLE_GACHA:String = "Dragon Gacha Draw";
      
      private static const SUBTITLE_GACHA:String = "Permanent Feature";
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var character;
      
      private var eventHandler;
      
      private var selectedGacha:String;
      
      private var playType:String;
      
      private var playQty:int;
      
      private var topRewardData:Array;
      
      private var middleRewardData:Array;
      
      private var bottomRewardData:Array;
      
      private var currentPageTop:int = 1;
      
      private var totalPageTop:int = 1;
      
      private var currentPageMiddle:int = 1;
      
      private var totalPageMiddle:int = 1;
      
      private var currentPageBottom:int = 1;
      
      private var totalPageBottom:int = 1;
      
      private var currentPageHistory:int = 1;
      
      private var totalPageHistory:int = 1;
      
      private var historyData:Array;
      
      private const PRICE_COINS:Array = [1,2];
      
      private const PRICE_TOKENS:Array = [25,50,250];
      
      public function DragonGacha(param1:*, param2:*)
      {
         var _loc3_:* = GameData.get("dragon_gacha");
         this.topRewardData = this.fillRewards(_loc3_.top);
         this.middleRewardData = this.fillRewards(_loc3_.mid);
         this.bottomRewardData = this.fillRewards(_loc3_.common);
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.panelMC.popupPrizeListMC,this.closePrizeList);
         this.escapeKey.addListener(this.panelMC.panelMC.popupWorldHistoryMC,this.closeHistory);
         this.eventHandler = new EventHandler();
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
         this.main.amf_manager.service("uw8zuDzUq5Zgt3o7.SSr0jtPDd8J5",[Character.char_id,Character.sessionkey,Character.account_id],this.eventDataResponse);
      }
      
      private function eventDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.panelMC.tokenTxt.text = String(Character.account_tokens);
            this.panelMC.panelMC.IconTxt.text = param1.coin;
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function initUI() : void
      {
         this.main.handleVillageHUDVisibility(false);
         this.eventHandler.addListener(this.panelMC.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.panelMC.panelMC.popupPrizeListMC.visible = false;
         this.panelMC.panelMC.popupWorldHistoryMC.visible = false;
         this.panelMC.panelMC.popUpGetReward.visible = false;
         this.panelMC.panelMC.popUpGetReward.gotoAndStop(1);
         this.panelMC.panelMC.titleTxt.text = TITLE_GACHA;
         this.panelMC.panelMC.dateTxt.text = SUBTITLE_GACHA;
         this.main.initButton(this.panelMC.panelMC.getMoreBtn,this.openRecharge,"Get More");
         this.main.initButton(this.panelMC.panelMC.historyBtn,this.openHistory,"Global History");
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.eventHandler.addListener(this.panelMC.panelMC["List_" + _loc1_]["btn_change_icon" + _loc1_],MouseEvent.CLICK,this.showPrizeList);
            _loc1_++;
         }
         this.gachaButtonHandler(true);
      }
      
      private function playGacha(param1:MouseEvent) : void
      {
         this.selectedGacha = param1.currentTarget.name;
         this.gachaButtonHandler(false);
         this.playType = "";
         switch(this.selectedGacha)
         {
            case "ticket_1Btn":
               this.playType = "coins";
               this.playQty = 1;
               break;
            case "token_1Btn":
               this.playType = "tokens";
               this.playQty = 1;
               break;
            case "token_2Btn":
               this.playType = "tokens";
               this.playQty = 2;
               break;
            case "ticket_2Btn":
               this.playType = "coins";
               this.playQty = 2;
               break;
            case "token_6Btn":
               this.playType = "tokens";
               this.playQty = 6;
         }
         this.main.amf_manager.service("uw8zuDzUq5Zgt3o7.iIgQR9ePdHhp",[Character.char_id,Character.sessionkey,this.playType,this.playQty],this.getGachaRewardsRes);
      }
      
      private function getGachaRewardsRes(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1.status == 1)
         {
            if(this.playType == "coins")
            {
               Character.removeMaterials(MATERIAL_GACHA,this.playQty);
            }
            else
            {
               _loc2_ = this.selectedGacha == "token_1Btn" ? 0 : (this.selectedGacha == "token_2Btn" ? 1 : 2);
               Character.account_tokens -= this.PRICE_TOKENS[_loc2_];
            }
            Character.addRewards(param1.rewards);
            this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
            this.panelMC.panelMC.IconTxt.text = String(param1.coin);
            this.main.HUD.setBasicData();
            this.playGetRewardAnimation(param1.rewards);
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.gachaButtonHandler(true);
      }
      
      private function playGetRewardAnimation(param1:Array) : void
      {
         this.panelMC.panelMC.popUpGetReward.addFrameScript(13,this.stopReward);
         this.panelMC.panelMC.popUpGetReward.visible = true;
         this.eventHandler.addListener(this.panelMC.panelMC.popUpGetReward.panelMC.btnOk,MouseEvent.CLICK,this.closeGetReward);
         this.eventHandler.addListener(this.panelMC.panelMC.popUpGetReward.bg,MouseEvent.CLICK,this.closeGetReward);
         this.panelMC.panelMC.popUpGetReward.panelMC.titleTxt.text = "Congratulations";
         var _loc2_:String = this.selectedGacha == "token_6Btn" ? "six" : "one";
         this.panelMC.panelMC.popUpGetReward.panelMC.gotoAndStop(_loc2_);
         var _loc3_:int = this.panelMC.panelMC.popUpGetReward.panelMC.currentLabel == "six" ? 6 : 1;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            NinjaSage.loadItemIcon(this.panelMC.panelMC.popUpGetReward.panelMC["IconMC" + _loc4_],param1[_loc4_]);
            _loc4_++;
         }
         this.panelMC.panelMC.popUpGetReward.gotoAndPlay(1);
      }
      
      public function stopReward() : void
      {
         this.panelMC.panelMC.popUpGetReward.stop();
      }
      
      private function closeGetReward(param1:MouseEvent) : void
      {
         this.panelMC.panelMC.popUpGetReward.visible = false;
         this.panelMC.panelMC.popUpGetReward.gotoAndStop(1);
         this.eventHandler.removeListener(this.panelMC.panelMC.popUpGetReward.panelMC.btnOk,MouseEvent.CLICK,this.closeGetReward);
         this.eventHandler.removeListener(this.panelMC.panelMC.popUpGetReward.bg,MouseEvent.CLICK,this.closeGetReward);
         var _loc2_:int = this.panelMC.panelMC.popUpGetReward.panelMC.currentLabel == "six" ? 6 : 1;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            GF.removeAllChild(this.panelMC.panelMC.popUpGetReward.panelMC["IconMC" + _loc3_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC.popUpGetReward.panelMC["IconMC" + _loc3_].skillIcon.iconHolder);
            _loc3_++;
         }
      }
      
      private function showPrizeList(param1:MouseEvent) : void
      {
         this.panelMC.panelMC.popupPrizeListMC.visible = true;
         this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1PrevBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1NextBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2PrevBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2NextBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3PrevBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3NextBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.btnClose,MouseEvent.CLICK,this.closePrizeList);
         this.panelMC.panelMC.popupPrizeListMC.panelMC.titleTxt.text = "Reward List";
         this.totalPageTop = Math.max(Math.ceil(this.topRewardData.length / 12),1);
         this.totalPageMiddle = Math.max(Math.ceil(this.middleRewardData.length / 12),1);
         this.totalPageBottom = Math.max(Math.ceil(this.bottomRewardData.length / 12),1);
         this.updatePageNumber();
         this.showRewardsTop();
         this.showRewardsMiddle();
         this.showRewardsBottom();
      }
      
      private function closePrizeList(param1:MouseEvent) : *
      {
         this.panelMC.panelMC.popupPrizeListMC.visible = false;
         this.currentPageTop = 1;
         this.currentPageMiddle = 1;
         this.currentPageBottom = 1;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 12)
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc2_].rewardIcon.tooltip = null;
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc2_].skillIcon.tooltip = null;
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc2_].rewardIcon.tooltip = null;
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc2_].skillIcon.tooltip = null;
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc2_].rewardIcon.tooltip = null;
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc2_].skillIcon.tooltip = null;
            GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc2_].skillIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc2_].skillIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         System.gc();
      }
      
      private function openHistory(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("uw8zuDzUq5Zgt3o7.O67P3MC54ks2",[Character.char_id,Character.sessionkey],this.historyResponse);
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
         this.panelMC.panelMC.popupWorldHistoryMC.visible = true;
         this.panelMC.panelMC.popupWorldHistoryMC.panelMC.titleTxt.text = "Global Prize History";
         this.eventHandler.addListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btnClose,MouseEvent.CLICK,this.closeHistory);
         this.eventHandler.addListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btn_next,MouseEvent.CLICK,this.changePageHistory);
         this.eventHandler.addListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btn_prev,MouseEvent.CLICK,this.changePageHistory);
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
            this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc1_].visible = false;
            if(this.historyData.length > _loc2_)
            {
               this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc1_].visible = true;
               this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc1_].rankTxt.text = String(_loc2_ + 1);
               this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc1_].nameTxt.text = "[" + this.historyData[_loc2_].id + "] " + this.historyData[_loc2_].name;
               this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc1_].levelTxt.text = this.historyData[_loc2_].level;
               this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc1_].detailTxt.text = this.historyData[_loc2_].obtained_at + " | Draw " + this.historyData[_loc2_].spin + "x";
               NinjaSage.loadItemIcon(this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc1_].iconMC,this.historyData[_loc2_].reward);
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
         this.panelMC.panelMC.popupWorldHistoryMC.panelMC.pageTxt.text = this.currentPageHistory + "/" + this.totalPageHistory;
      }
      
      private function closeHistory(param1:MouseEvent) : void
      {
         this.panelMC.panelMC.popupWorldHistoryMC.visible = false;
         this.currentPageHistory = 1;
         this.totalPageHistory = 1;
         this.eventHandler.removeListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btnClose,MouseEvent.CLICK,this.closeHistory);
         this.eventHandler.removeListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btn_next,MouseEvent.CLICK,this.changePageHistory);
         this.eventHandler.removeListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btn_prev,MouseEvent.CLICK,this.changePageHistory);
         var _loc2_:int = 0;
         while(_loc2_ < 7)
         {
            this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc2_].iconMC.rewardIcon.tooltip = null;
            this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc2_].iconMC.skillIcon.tooltip = null;
            GF.removeAllChild(this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc2_].iconMC.rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC.popupWorldHistoryMC.panelMC["item_" + _loc2_].iconMC.skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function showRewardsTop() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 12)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageTop - 1) * 12);
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].visible = false;
            if(this.topRewardData.length > _loc2_)
            {
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].visible = true;
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].amountTxt.visible = false;
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.visible = false;
               if(Character.hasSkill(this.topRewardData[_loc2_]) > 0)
               {
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.topRewardData[_loc2_]) > 0)
               {
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].ownedTxt.text = "Owned";
               }
               GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_].skillIcon.iconHolder);
               NinjaSage.loadItemIcon(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc0_" + _loc1_],this.topRewardData[_loc2_]);
            }
            _loc1_++;
         }
      }
      
      private function showRewardsMiddle() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 12)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageMiddle - 1) * 12);
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].visible = false;
            if(this.middleRewardData.length > _loc2_)
            {
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].visible = true;
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].amountTxt.visible = false;
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.visible = false;
               if(Character.hasSkill(this.middleRewardData[_loc2_]) > 0)
               {
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.middleRewardData[_loc2_]) > 0)
               {
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].ownedTxt.text = "Owned";
               }
               GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_].skillIcon.iconHolder);
               NinjaSage.loadItemIcon(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc1_" + _loc1_],this.middleRewardData[_loc2_]);
            }
            _loc1_++;
         }
      }
      
      private function showRewardsBottom() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 12)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageBottom - 1) * 12);
            this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].visible = false;
            if(this.bottomRewardData.length > _loc2_)
            {
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].visible = true;
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].amountTxt.visible = false;
               this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.visible = false;
               if(Character.hasSkill(this.bottomRewardData[_loc2_]) > 0)
               {
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(this.bottomRewardData[_loc2_]) > 0)
               {
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.visible = true;
                  this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].ownedTxt.text = "Owned";
               }
               GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_].skillIcon.iconHolder);
               NinjaSage.loadItemIcon(this.panelMC.panelMC.popupPrizeListMC.panelMC["IconMc2_" + _loc1_],this.bottomRewardData[_loc2_]);
            }
            _loc1_++;
         }
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "rank1NextBtn":
               if(this.totalPageTop > this.currentPageTop)
               {
                  ++this.currentPageTop;
                  this.showRewardsTop();
               }
               break;
            case "rank1PrevBtn":
               if(this.currentPageTop > 1)
               {
                  --this.currentPageTop;
                  this.showRewardsTop();
               }
               break;
            case "rank2NextBtn":
               if(this.totalPageMiddle > this.currentPageMiddle)
               {
                  ++this.currentPageMiddle;
                  this.showRewardsMiddle();
               }
               break;
            case "rank2PrevBtn":
               if(this.currentPageMiddle > 1)
               {
                  --this.currentPageMiddle;
                  this.showRewardsMiddle();
               }
               break;
            case "rank3NextBtn":
               if(this.totalPageBottom > this.currentPageBottom)
               {
                  ++this.currentPageBottom;
                  this.showRewardsBottom();
               }
               break;
            case "rank3PrevBtn":
               if(this.currentPageBottom > 1)
               {
                  --this.currentPageBottom;
                  this.showRewardsBottom();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : *
      {
         if(this.currentPageTop == 1)
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1PrevBtn.visible = false;
         }
         else
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1PrevBtn.visible = true;
         }
         if(this.currentPageMiddle == 1)
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2PrevBtn.visible = false;
         }
         else
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2PrevBtn.visible = true;
         }
         if(this.currentPageBottom == 1)
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3PrevBtn.visible = false;
         }
         else
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3PrevBtn.visible = true;
         }
         if(this.totalPageTop == this.currentPageTop)
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1NextBtn.visible = false;
         }
         else
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1NextBtn.visible = true;
         }
         if(this.totalPageMiddle == this.currentPageMiddle)
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2NextBtn.visible = false;
         }
         else
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2NextBtn.visible = true;
         }
         if(this.totalPageBottom == this.currentPageBottom)
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3NextBtn.visible = false;
         }
         else
         {
            this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3NextBtn.visible = true;
         }
      }
      
      private function gachaButtonHandler(param1:Boolean = true) : void
      {
         var _loc2_:String = !!param1 ? "initButton" : "initButtonDisable";
         this.main[_loc2_](this.panelMC.panelMC.ticket_1Btn,this.playGacha,this.PRICE_COINS[0]);
         this.main[_loc2_](this.panelMC.panelMC.ticket_2Btn,this.playGacha,this.PRICE_COINS[1]);
         this.main[_loc2_](this.panelMC.panelMC.token_1Btn,this.playGacha,this.PRICE_TOKENS[0]);
         this.main[_loc2_](this.panelMC.panelMC.token_2Btn,this.playGacha,this.PRICE_TOKENS[1]);
         this.main[_loc2_](this.panelMC.panelMC.token_6Btn,this.playGacha,this.PRICE_TOKENS[2]);
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
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.closePrizeList(null);
         this.topRewardData = [];
         this.middleRewardData = [];
         this.bottomRewardData = [];
         this.historyData = [];
         this.main = null;
         this.character = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
