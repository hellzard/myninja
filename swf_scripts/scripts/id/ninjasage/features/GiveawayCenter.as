package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class GiveawayCenter extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var selectedTabIndex:int;
      
      private var currentPage:int;
      
      private var currentPageHistory:int;
      
      private var currentPageWinner:int;
      
      private var totalPage:int;
      
      private var totalPageHistory:int;
      
      private var totalPageWinner:int;
      
      private var response:Object;
      
      private var historyData:Object;
      
      private var timestamp:*;
      
      private var timeout:*;
      
      private var main:*;
      
      public function GiveawayCenter(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.historyMC,this.closeHistory);
         this.eventHandler = new EventHandler();
         this.getData();
      }
      
      private function getData(param1:MouseEvent = null) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("be9WkVbJZYaRo69c.C3VahnT6Jydb",[Character.char_id,Character.sessionkey],this.giveawayResponse);
      }
      
      private function giveawayResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.initUI();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.destroy();
         }
      }
      
      private function initUI() : void
      {
         this.panelMC.historyMC.visible = false;
         this.panelMC.winnerMC.visible = false;
         this.panelMC.rewardMC.gotoAndStop(1);
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btnPrev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btnNext,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_history,MouseEvent.CLICK,this.openHistory);
         this.eventHandler.addListener(this.panelMC.btn_refresh,MouseEvent.CLICK,this.getData);
         this.eventHandler.addListener(this.panelMC.btn_join,MouseEvent.CLICK,this.joinGiveaway);
         this.selectedTabIndex = -1;
         this.currentPage = 1;
         this.totalPage = Math.max(1,Math.ceil(this.response.giveaways.length / 3));
         if(this.response.giveaways.length > 0)
         {
            this.resetSelectedTab();
            this.renderTabPage();
            this.selectGiveaway();
            this.updatePageButton();
            this.panelMC["tab0"].gotoAndStop(3);
         }
         else
         {
            this.hideEverything();
         }
      }
      
      private function hideEverything() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.panelMC["tab" + _loc1_].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.panelMC["task_" + _loc1_].visible = false;
            _loc1_++;
         }
         this.panelMC.btnPrev.visible = false;
         this.panelMC.btnNext.visible = false;
         this.panelMC.rewardMC.visible = false;
         this.panelMC.timestamp.visible = false;
         this.panelMC.giveawayTitleTxt.visible = false;
         this.panelMC.giveawayDescriptionTxt.visible = false;
         this.panelMC.btn_join.visible = false;
         this.panelMC.participantsTxt.visible = false;
         this.panelMC.requirementTxt.visible = false;
         this.panelMC.prizeTxt.visible = false;
      }
      
      private function renderTabPage() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 3);
            this.panelMC["tab" + _loc1_].visible = false;
            if(this.response.giveaways.length > _loc2_)
            {
               this.panelMC["tab" + _loc1_].visible = true;
               this.panelMC["tab" + _loc1_].metaData = {"index":_loc2_};
               this.panelMC["tab" + _loc1_].txt.text = "Giveaway #" + this.response.giveaways[_loc2_].id;
               this.panelMC["tab" + _loc1_].gotoAndStop(1);
               if(this.selectedTabIndex == _loc2_)
               {
                  this.panelMC["tab" + _loc1_].gotoAndStop(3);
               }
               this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.CLICK,this.selectGiveaway);
               this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.MOUSE_OVER,this.hoverOver);
               this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.MOUSE_OUT,this.hoverOut);
            }
            _loc1_++;
         }
      }
      
      private function resetSelectedTab() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.panelMC["tab" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function selectGiveaway(param1:MouseEvent = null) : void
      {
         this.selectedTabIndex = param1 ? int(param1.currentTarget.metaData.index) : 0;
         if(param1)
         {
            this.resetSelectedTab();
            param1.currentTarget.gotoAndStop(3);
         }
         var _loc2_:Object = this.response.giveaways[this.selectedTabIndex];
         this.panelMC.rewardMC.gotoAndStop(_loc2_.prizes.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.prizes.length)
         {
            this.panelMC.rewardMC["iconMC" + _loc3_].amountTxt.text = _loc2_.prizes[_loc3_].split(":")[1] != null ? "x" + _loc2_.prizes[_loc3_].split(":")[1] : "";
            this.panelMC.rewardMC["iconMC" + _loc3_].ownedTxt.visible = false;
            if(Character.hasSkill(_loc2_.prizes[_loc3_]) > 0)
            {
               this.panelMC.rewardMC["iconMC" + _loc3_].ownedTxt.visible = true;
               this.panelMC.rewardMC["iconMC" + _loc3_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(_loc2_.prizes[_loc3_]) > 0)
            {
               this.panelMC.rewardMC["iconMC" + _loc3_].ownedTxt.visible = true;
               this.panelMC.rewardMC["iconMC" + _loc3_].ownedTxt.text = "Owned";
            }
            NinjaSage.loadItemIcon(this.panelMC.rewardMC["iconMC" + _loc3_],_loc2_.prizes[_loc3_]);
            _loc3_++;
         }
         this.panelMC.giveawayTitleTxt.text = _loc2_.title;
         this.panelMC.giveawayDescriptionTxt.text = _loc2_.desc;
         this.panelMC.participantsTxt.visible = _loc2_.hasOwnProperty("participants");
         this.panelMC.participantsTxt.text = "Participants: " + _loc2_.participants;
         this.timestamp = _loc2_.timestamp;
         if(_loc2_.hasOwnProperty("winners") && _loc2_.winners != null && _loc2_.winners.length > 0)
         {
            this.currentPageWinner = 1;
            this.totalPageWinner = Math.max(1,Math.ceil(_loc2_.winners.length / 10));
            this.eventHandler.addListener(this.panelMC.winnerMC.btnPrev,MouseEvent.CLICK,this.changePageWinner);
            this.eventHandler.addListener(this.panelMC.winnerMC.btnNext,MouseEvent.CLICK,this.changePageWinner);
            this.updatePageButtonWinner();
            this.renderWinner();
         }
         else
         {
            this.panelMC.winnerMC.visible = false;
            this.panelMC.requirementTxt.visible = true;
            this.panelMC.endedTxt.visible = false;
            this.panelMC.remainingTimeTxt.visible = true;
            this.panelMC.timestamp.visible = true;
            this.panelMC.btn_join.visible = _loc2_.joined ? false : true;
            this.panelMC.joinedTxt.visible = _loc2_.joined;
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               this.panelMC["task_" + _loc3_].visible = false;
               if(_loc2_.requirements.length > _loc3_)
               {
                  this.panelMC["task_" + _loc3_].visible = true;
                  this.panelMC["task_" + _loc3_].taskName.text = _loc2_.requirements[_loc3_].name;
                  this.panelMC["task_" + _loc3_].taskRequirement.text = _loc2_.requirements[_loc3_].progress + "/" + _loc2_.requirements[_loc3_].total;
                  this.panelMC["task_" + _loc3_].tick.visible = _loc2_.requirements[_loc3_].progress >= _loc2_.requirements[_loc3_].total;
               }
               _loc3_++;
            }
         }
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         this.updateTimeleft();
      }
      
      private function renderWinner() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Object = this.response.giveaways[this.selectedTabIndex];
         this.panelMC.winnerMC.visible = true;
         this.panelMC.requirementTxt.visible = false;
         this.panelMC.btn_join.visible = false;
         this.panelMC.endedTxt.visible = true;
         this.panelMC.remainingTimeTxt.visible = false;
         this.panelMC.timestamp.visible = false;
         this.panelMC.joinedTxt.visible = _loc1_.joined;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this.panelMC["task_" + _loc2_].visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 10)
         {
            _loc3_ = _loc2_ + int(int(this.currentPageWinner - 1) * 10);
            this.panelMC.winnerMC["winner" + _loc2_].visible = false;
            if(_loc1_.winners.length > _loc3_)
            {
               this.panelMC.winnerMC["winner" + _loc2_].visible = true;
               this.panelMC.winnerMC["winner" + _loc2_].txt.htmlText = Character.colorifyText(_loc1_.winners[_loc3_].id,"[" + _loc1_.winners[_loc3_].id + "] " + _loc1_.winners[_loc3_].name,this.panelMC.winnerMC["winner" + _loc2_].txt);
               this.panelMC.winnerMC["winner" + _loc2_].metaData = {"charId":_loc1_.winners[_loc3_].id};
               this.eventHandler.addListener(this.panelMC.winnerMC["winner" + _loc2_],MouseEvent.CLICK,this.openFriendProfile);
            }
            _loc2_++;
         }
      }
      
      private function openFriendProfile(param1:MouseEvent) : *
      {
         this.main.openFriendProfile(param1.currentTarget.metaData.charId,true);
      }
      
      private function changePageWinner(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNext":
               if(this.totalPageWinner > this.currentPageWinner)
               {
                  ++this.currentPageWinner;
                  this.renderWinner();
               }
               break;
            case "btnPrev":
               if(this.currentPageWinner > 1)
               {
                  --this.currentPageWinner;
                  this.renderWinner();
               }
         }
         this.updatePageButtonWinner();
      }
      
      private function updatePageButtonWinner() : void
      {
         if(this.currentPageWinner == 1)
         {
            this.panelMC.winnerMC.btnPrev.visible = false;
            this.panelMC.winnerMC.btnNext.visible = true;
         }
         else if(this.currentPageWinner == this.totalPageWinner)
         {
            this.panelMC.winnerMC.btnPrev.visible = true;
            this.panelMC.winnerMC.btnNext.visible = false;
         }
         else
         {
            this.panelMC.winnerMC.btnPrev.visible = true;
            this.panelMC.winnerMC.btnNext.visible = true;
         }
         if(this.totalPageWinner == 1)
         {
            this.panelMC.winnerMC.btnPrev.visible = false;
            this.panelMC.winnerMC.btnNext.visible = false;
         }
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNext":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderTabPage();
               }
               break;
            case "btnPrev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderTabPage();
               }
         }
         this.updatePageButton();
      }
      
      private function updatePageButton() : void
      {
         if(this.currentPage == 1)
         {
            this.panelMC.btnPrev.visible = false;
            this.panelMC.btnNext.visible = true;
         }
         else if(this.currentPage == this.totalPage)
         {
            this.panelMC.btnPrev.visible = true;
            this.panelMC.btnNext.visible = false;
         }
         else
         {
            this.panelMC.btnPrev.visible = true;
            this.panelMC.btnNext.visible = true;
         }
         if(this.totalPage == 1)
         {
            this.panelMC.btnPrev.visible = false;
            this.panelMC.btnNext.visible = false;
         }
      }
      
      private function openHistory(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("be9WkVbJZYaRo69c.ZQvL9TFnJ44z",[Character.char_id,Character.sessionkey],this.historyResponse);
      }
      
      private function historyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.historyData = param1.giveaway;
            this.initHistoryUI();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function initHistoryUI() : void
      {
         this.panelMC.historyMC.visible = true;
         var _loc1_:MovieClip = this.panelMC.historyMC;
         this.currentPageHistory = 1;
         this.totalPageHistory = Math.max(1,Math.ceil(this.historyData.length / 4));
         this.eventHandler.addListener(_loc1_.btnClose,MouseEvent.CLICK,this.closeHistory);
         this.eventHandler.addListener(_loc1_.btnPrev,MouseEvent.CLICK,this.changePageHistory);
         this.eventHandler.addListener(_loc1_.btnNext,MouseEvent.CLICK,this.changePageHistory);
         this.renderHistory();
         this.updatePageNumber();
      }
      
      private function renderHistory() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:MovieClip = this.panelMC.historyMC;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = _loc2_ + int(int(this.currentPageHistory - 1) * 4);
            _loc1_["history" + _loc2_].visible = false;
            if(this.historyData.length > _loc3_)
            {
               _loc1_["history" + _loc2_].visible = true;
               _loc1_["history" + _loc2_].titleTxt.text = this.historyData[_loc3_].title;
               _loc1_["history" + _loc2_].descTxt.text = this.historyData[_loc3_].description;
               _loc1_["history" + _loc2_].dateTxt.text = this.historyData[_loc3_].ended_at;
               _loc4_ = 0;
               while(_loc4_ < 5)
               {
                  _loc1_["history" + _loc2_]["iconMc0_" + _loc4_].visible = false;
                  if(this.historyData[_loc3_].prizes[_loc4_])
                  {
                     _loc1_["history" + _loc2_]["iconMc0_" + _loc4_].visible = true;
                     _loc1_["history" + _loc2_]["iconMc0_" + _loc4_].amountTxt.text = this.historyData[_loc3_].prizes[_loc4_].split(":")[1] != null ? "x" + this.historyData[_loc3_].prizes[_loc4_].split(":")[1] : "";
                     _loc1_["history" + _loc2_]["iconMc0_" + _loc4_].ownedTxt.visible = false;
                     if(Character.hasSkill(this.historyData[_loc3_].prizes[_loc4_]) > 0)
                     {
                        _loc1_["history" + _loc2_]["iconMc0_" + _loc4_].ownedTxt.visible = true;
                        _loc1_["history" + _loc2_]["iconMc0_" + _loc4_].ownedTxt.text = "Owned";
                     }
                     if(Character.isItemOwned(this.historyData[_loc3_].prizes[_loc4_]) > 0)
                     {
                        _loc1_["history" + _loc2_]["iconMc0_" + _loc4_].ownedTxt.visible = true;
                        _loc1_["history" + _loc2_]["iconMc0_" + _loc4_].ownedTxt.text = "Owned";
                     }
                     NinjaSage.loadItemIcon(_loc1_["history" + _loc2_]["iconMc0_" + _loc4_],this.historyData[_loc3_].prizes[_loc4_]);
                  }
                  _loc4_++;
               }
            }
            _loc2_++;
         }
      }
      
      private function changePageHistory(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNext":
               if(this.totalPageHistory > this.currentPageHistory)
               {
                  ++this.currentPageHistory;
                  this.renderHistory();
               }
               break;
            case "btnPrev":
               if(this.currentPageHistory > 1)
               {
                  --this.currentPageHistory;
                  this.renderHistory();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.historyMC.pageTxt.text = this.currentPageHistory + "/" + this.totalPageHistory;
      }
      
      private function closeHistory(param1:MouseEvent) : void
      {
         this.panelMC.historyMC.visible = false;
      }
      
      private function joinGiveaway(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("be9WkVbJZYaRo69c.n1LlmpeXb0GK",[Character.char_id,Character.sessionkey,this.response.giveaways[this.selectedTabIndex].id],this.joinResponse);
      }
      
      private function joinResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response.giveaways[this.selectedTabIndex].joined = 1;
            this.panelMC.btn_join.visible = false;
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function updateTimeleft() : void
      {
         if(this.timestamp == null)
         {
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:* = this.timestamp;
         var _loc5_:* = Math.floor(_loc4_ / _loc1_);
         var _loc6_:* = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         var _loc7_:* = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         this.panelMC.timestamp.dayTxt.text = _loc5_;
         this.panelMC.timestamp.hourTxt.text = _loc6_;
         this.panelMC.timestamp.minTxt.text = _loc7_;
         this.timeout = setTimeout(this.updateTimeleft,10000);
         this.timestamp -= 10;
         if(this.timestamp < 0)
         {
            this.timestamp = 0;
         }
         this.response.giveaways[this.selectedTabIndex].timestamp = this.timestamp;
      }
      
      public function hoverOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      public function hoverOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
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
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         this.timestamp = null;
         this.response = null;
         this.historyData = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}

