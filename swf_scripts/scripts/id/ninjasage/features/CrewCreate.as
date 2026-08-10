package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.Crew;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   public dynamic class CrewCreate extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var rewardData:Object;
      
      private var tokenPoolData:Object;
      
      private var crewDataOriginal:Array;
      
      private var crewData:Array;
      
      private var selectedCrewId:int = -1;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 0;
      
      private const CREATE_PRICE:int = 1000;
      
      public function CrewCreate(param1:*, param2:*)
      {
         var _loc3_:Object = GameData.get("crew");
         this.rewardData = Crew.instance.getRewardData();
         this.tokenPoolData = _loc3_.token_pool;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.initButton();
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
      
      private function initUI() : void
      {
         this.panelMC.requestMemberListMc.visible = false;
         this.panelMC.detailMC.gotoAndStop("idle");
         this.panelMC.lbl_create.text = "Create Crew";
         this.panelMC.lbl_enter.text = "Enter Crew Name: ";
         this.panelMC.lbl_fees.text = this.CREATE_PRICE;
         this.panelMC.lbl_token.text = "Tokens";
         this.panelMC.lbl_requestclan.text = "Request Join Crew";
         this.panelMC.lbl_requestclan_description.text = "Select a crew to apply for membership";
         this.panelMC.lbl_clanranking.text = "Crew Reward";
         this.panelMC.lbl_clanranking_description.text = "Shows a reward of current season";
         this.panelMC.lbl_clanShop.text = "Crew Shop";
      }
      
      private function initButton() : void
      {
         this.eventHandler.addListener(this.panelMC.closeBtn,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.createClanBtn,MouseEvent.CLICK,this.createCrewConfirmation);
         this.eventHandler.addListener(this.panelMC.btn_requestmembership,MouseEvent.CLICK,this.openCrewList);
         this.eventHandler.addListener(this.panelMC.rewardBtn,MouseEvent.CLICK,this.showRewardDamageRank);
         this.eventHandler.addListener(this.panelMC.btn_clanshop,MouseEvent.CLICK,this.openCrewShop);
         this.eventHandler.addListener(this.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
      }
      
      private function openCrewList(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.getCrewsForRequest(this.onGetCrewsRes);
      }
      
      public function onGetCrewsRes(param1:*, param2:* = null) : void
      {
         var _loc3_:int = 0;
         this.main.loading(false);
         if(param1 != null && Boolean(param1.hasOwnProperty("crews")))
         {
            this.crewDataOriginal = param1.crews;
            _loc3_ = 0;
            while(_loc3_ < this.crewDataOriginal.length)
            {
               this.crewDataOriginal[_loc3_].ranking = _loc3_ + 1;
               _loc3_++;
            }
            this.crewData = this.crewDataOriginal;
            this.initCrewList();
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice("Server Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      private function getSearchedCrew(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         _loc2_ = String(this.panelMC.requestMemberListMc.searchTxt.text || "").replace(/^\s+|\s+$/g,"");
         var _loc3_:Number = parseInt(_loc2_);
         if(isNaN(_loc3_) || _loc3_ <= 0)
         {
            this.main.getNotice("Please enter a valid crew ID");
            return;
         }
         if(!this.searchCrew(_loc3_.toString()))
         {
            this.main.loading(true);
            Crew.instance.searchCrewsForRequest(_loc3_.toString(),this.onGetSearchRes);
         }
      }
      
      public function searchCrew(param1:String = null) : Boolean
      {
         var searchTerm:String = null;
         var searchId:String = param1;
         var searchText:String = this.panelMC.requestMemberListMc.searchTxt.text;
         if(!searchText && !searchId)
         {
            return false;
         }
         searchTerm = (searchId || searchText).toLowerCase();
         this.crewData = this.crewDataOriginal.filter(function(param1:Object, param2:int, param3:Array):Boolean
         {
            return Boolean(param1) && Boolean(param1.id) && String(param1.id).toLowerCase() === searchTerm;
         });
         this.updateSearchResults();
         return this.crewData.length > 0;
      }
      
      private function onGetSearchRes(param1:Object, param2:* = null) : void
      {
         var _loc4_:String = null;
         this.main.loading(false);
         if(param2)
         {
            this.main.getNotice("Search failed. Please try again later.");
            return;
         }
         if(!param1 || !param1.crews || !param1.crews.length)
         {
            _loc4_ = Boolean(param1) && Boolean(param1.errorMessage) ? "Error: " + param1.errorMessage : "Crew not found. Please check the ID and try again.";
            this.main.getNotice(_loc4_);
            this.resetSearch();
            return;
         }
         var _loc3_:Object = param1.crews[0];
         if(!_loc3_.hasOwnProperty("ranking"))
         {
            _loc3_.ranking = 1;
         }
         this.crewData = [_loc3_];
         this.updateSearchResults(1);
      }
      
      private function updateSearchResults(param1:int = -1) : void
      {
         this.currentPage = 1;
         this.totalPage = param1 > 0 ? param1 : int(Math.ceil(this.crewData.length / 8));
         this.updatePageNumber();
         this.displayCrewList();
      }
      
      private function initCrewList() : void
      {
         this.panelMC.requestMemberListMc.visible = true;
         NinjaSage.showDynamicTooltip(this.panelMC.requestMemberListMc.backBtn,"Clear search");
         this.eventHandler.addListener(this.panelMC.requestMemberListMc.closeBtn,MouseEvent.CLICK,this.closeCrewList);
         this.eventHandler.addListener(this.panelMC.requestMemberListMc.backBtn,MouseEvent.CLICK,this.clearSearch);
         this.eventHandler.addListener(this.panelMC.requestMemberListMc.prevPageBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.requestMemberListMc.nextPageBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.requestMemberListMc.searchBtn,MouseEvent.CLICK,this.getSearchedCrew);
         this.eventHandler.addListener(this.panelMC.requestMemberListMc.btn_sendrequest,MouseEvent.CLICK,this.onRequestReq);
         this.totalPage = Math.max(Math.ceil(this.crewData.length / 8),1);
         this.updatePageNumber();
         this.displayCrewList();
      }
      
      private function displayCrewList() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 8);
            this.panelMC.requestMemberListMc["clan_" + _loc1_].visible = false;
            this.panelMC.requestMemberListMc["clan_" + _loc1_].metaData = {};
            this.panelMC.requestMemberListMc["clan_" + _loc1_].gotoAndStop("idle");
            if(this.crewData.length > _loc2_)
            {
               this.panelMC.requestMemberListMc["clan_" + _loc1_].visible = true;
               this.panelMC.requestMemberListMc["clan_" + _loc1_].rankingTxt.text = this.crewData[_loc2_].ranking;
               this.panelMC.requestMemberListMc["clan_" + _loc1_].idTxt.text = "[" + this.crewData[_loc2_].id + "]";
               this.panelMC.requestMemberListMc["clan_" + _loc1_].nameTxt.text = this.crewData[_loc2_].name;
               this.panelMC.requestMemberListMc["clan_" + _loc1_].totalMemberTxt.text = this.crewData[_loc2_].members + "/" + this.crewData[_loc2_].max_members;
               this.panelMC.requestMemberListMc["clan_" + _loc1_].metaData = {"crew_data":this.crewData[_loc2_]};
               if(this.selectedCrewId == this.crewData[_loc2_].id)
               {
                  this.panelMC.requestMemberListMc["clan_" + _loc1_].gotoAndStop("selected");
               }
               this.eventHandler.addListener(this.panelMC.requestMemberListMc["clan_" + _loc1_],MouseEvent.CLICK,this.selectCrew);
            }
            _loc1_++;
         }
         this.updatePageNumber();
         this.totalPage = Math.max(Math.ceil(this.crewData.length / 8),1);
      }
      
      private function selectCrew(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this.panelMC.requestMemberListMc["clan_" + _loc2_].gotoAndStop("idle");
            _loc2_++;
         }
         param1.currentTarget.gotoAndStop("selected");
         this.selectedCrewId = param1.currentTarget.metaData.crew_data.id;
         this.panelMC.requestMemberListMc.lbl_request_remark.text = "Send a request to " + param1.currentTarget.metaData.crew_data.name + " crew?";
      }
      
      private function onRequestReq(param1:MouseEvent) : void
      {
         if(this.selectedCrewId == -1)
         {
            this.main.getNotice("Please select a crew first!");
         }
         else
         {
            this.main.loading(true);
            Crew.instance.sendRequestToCrew(this.selectedCrewId,this.onRequestToCrewRes);
         }
      }
      
      private function onRequestToCrewRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("data"))
         {
            this.main.getNotice(param1.data.result);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "nextPageBtn":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.displayCrewList();
               }
               break;
            case "prevPageBtn":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.displayCrewList();
               }
         }
      }
      
      private function clearSearch(param1:MouseEvent) : void
      {
         this.resetSearch();
      }
      
      private function resetSearch() : void
      {
         this.crewData = this.crewDataOriginal;
         this.panelMC.requestMemberListMc.searchTxt.text = "";
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.crewData.length / 8),1);
         this.updatePageNumber();
         this.displayCrewList();
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.requestMemberListMc.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function closeCrewList(param1:MouseEvent) : void
      {
         this.panelMC.requestMemberListMc.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this.panelMC.requestMemberListMc["clan_" + _loc2_].metaData = {};
            _loc2_++;
         }
         this.crewDataOriginal = [];
         this.crewData = [];
      }
      
      private function createCrewConfirmation(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to create " + this.panelMC["clanNameInput"].text + " crew for " + this.CREATE_PRICE + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():void
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onCreateCrewReq);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function onCreateCrewReq(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         if(this.panelMC["clanNameInput"].text == "")
         {
            this.main.getNotice("Crew name should not be empty!");
         }
         else
         {
            this.main.loading(true);
            Crew.instance.createCrew(this.panelMC.clanNameInput.text,this.onCreateCrewRes);
         }
      }
      
      private function onCreateCrewRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if("status" in param1 && param1.status == "ok")
         {
            Character.account_tokens -= this.CREATE_PRICE;
            this.main.HUD.setBasicData();
            Crew.instance.getCrewData(this.onGetCrewData);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("");
         }
      }
      
      private function onGetCrewData(param1:*, param2:* = null) : void
      {
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("crew")) && Boolean(param1.hasOwnProperty("char")))
         {
            Character.crew_data = param1.crew;
            Character.crew_char_data = param1.char;
            this.main.loadExternalSwfPanel("CrewVillage","CrewVillage");
            this.destroy();
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         this.closePanel(null);
      }
      
      private function showRewardDamageRank(param1:MouseEvent) : void
      {
         this.panelMC.detailMC.gotoAndStop("damageRank");
         var _loc2_:MovieClip = this.panelMC.detailMC.panelMC;
         var _loc3_:Array = ["1","2","3","4","5","6-10"];
         var _loc4_:Array = ["lbl_first_prize_1","lbl_secon_1","lbl_third_1","lbl_forth_1","lbl_5th_1","lbl_6th_1"];
         var _loc5_:Array = ["lbl_first_prize_2","lbl_second_2","lbl_third_2","lbl_forth_2","lbl_5th_2","lbl_6th_2"];
         var _loc6_:int = 0;
         while(_loc6_ < 6)
         {
            _loc2_[_loc4_[_loc6_]].text = this.tokenPoolData[_loc3_[_loc6_]].token + "% of token pool";
            _loc2_[_loc5_[_loc6_]].text = Util.formatNumberWithDot(this.tokenPoolData[_loc3_[_loc6_]].merit) + " Merit";
            _loc6_++;
         }
         _loc2_.lbl_date.text = "Total Token Pool: 0 + " + this.tokenPoolData.base;
         Crew.instance.getTokenPool(this.onTokenPoolRes);
         this.eventHandler.addListener(this.panelMC.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.addListener(this.panelMC.detailMC.panelMC.nextBtn,MouseEvent.CLICK,this.showRewardDamageBonus);
      }
      
      private function onTokenPoolRes(param1:Object, param2:* = null) : void
      {
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("t"))
         {
            this.panelMC.detailMC.panelMC.lbl_date.text = "Total Token Pool: " + param1.t + " + " + this.tokenPoolData.base;
            return;
         }
      }
      
      private function showRewardDamageBonus(param1:MouseEvent) : void
      {
         this.panelMC.detailMC.gotoAndStop("damageBonus");
         this.eventHandler.addListener(this.panelMC.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.addListener(this.panelMC.detailMC.panelMC.prevBtn,MouseEvent.CLICK,this.showRewardDamageRank);
         var _loc2_:int = 0;
         while(_loc2_ < this.rewardData.phase_1.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.detailMC.panelMC["IconMc0_" + _loc2_],this.rewardData.phase_1[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.rewardData.phase_2.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.detailMC.panelMC["IconMc_" + _loc2_],this.rewardData.phase_2[_loc2_]);
            _loc2_++;
         }
      }
      
      private function closeRewards(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.panelMC.detailMC.currentLabel == "damageBonus")
         {
            _loc2_ = 0;
            while(_loc2_ < this.rewardData.phase_1.length)
            {
               GF.removeAllChild(this.panelMC.detailMC.panelMC["IconMc0_" + _loc2_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.detailMC.panelMC["IconMc0_" + _loc2_].skillIcon.iconHolder);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.rewardData.phase_2.length)
            {
               GF.removeAllChild(this.panelMC.detailMC.panelMC["IconMc_" + _loc2_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.detailMC.panelMC["IconMc_" + _loc2_].skillIcon.iconHolder);
               _loc2_++;
            }
         }
         this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.prevBtn,MouseEvent.CLICK,this.showRewardDamageRank);
         this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.nextBtn,MouseEvent.CLICK,this.showRewardDamageBonus);
         this.panelMC.detailMC.gotoAndStop("idle");
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openCrewShop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.CrewShop");
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
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.main = null;
         this.character = null;
         this.eventHandler = null;
         this.rewardData = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}

