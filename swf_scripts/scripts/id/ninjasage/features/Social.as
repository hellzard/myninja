package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Storage.Character;
   import Storage.MissionLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.adobe.crypto.CUCSG;
   import com.utils.GF;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class Social extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var friendData:Object;
      
      private var friendRequestData:Object;
      
      private var friendRecommendationData:Object;
      
      private var addFriendData:Object;
      
      private var isRecruitable:Boolean = true;
      
      private var totalFriendRequest:int;
      
      private var totalFriend:int;
      
      private var limitFriend:int;
      
      private var outfits:Array = [];
      
      private var selectedFriendIndex:int;
      
      private var selectedFriendId:int;
      
      private var originalOverlayIndex:int;
      
      private var tabArray:Array = ["allfriend","favorite","request","recommendation"];
      
      private var currentTab:String;
      
      private var acceptRejectButton:String;
      
      private var selectMode:Boolean = false;
      
      private var selectedIdArray:Array = [];
      
      private var loaderSwf:BulkLoader;
      
      private var filterType:String = "";
      
      public function Social(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(10,BulkLoader.LOG_INFO);
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_Friendship_Shop,MouseEvent.CLICK,this.openFriendshipShop);
         this.eventHandler.addListener(this.panelMC.friendListMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.friendListMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.friendRequestMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.friendRequestMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.friendRecommendationMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.friendRecommendationMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.friendRequestMC.btn_acceptAll,MouseEvent.CLICK,this.handleAcceptRejectFriendRequest);
         this.eventHandler.addListener(this.panelMC.friendRequestMC.btn_rejectAll,MouseEvent.CLICK,this.handleAcceptRejectFriendRequest);
         this.eventHandler.addListener(this.panelMC.friendListMC.allowMC,MouseEvent.CLICK,this.handleAllowRecruit);
         this.eventHandler.addListener(this.panelMC.friendListMC.btn_removeRecruit,MouseEvent.CLICK,this.removeRecruitedSquad);
         this.eventHandler.addListener(this.panelMC.friendListMC.searchBtn,MouseEvent.CLICK,this.onSearch);
         this.eventHandler.addListener(this.panelMC.friendListMC.clearSearch,MouseEvent.CLICK,this.onSearchClear);
         this.eventHandler.addListener(this.panelMC.friendListMC.btn_unfriend,MouseEvent.CLICK,this.handleUnfriend);
         this.eventHandler.addListener(this.panelMC.friendListMC.btn_AddFriend,MouseEvent.CLICK,this.handleAddFriend);
         this.eventHandler.addListener(this.panelMC.friendListMC.filterRankMC,MouseEvent.CLICK,this.handleFilterLevel);
         NinjaSage.showDynamicTooltip(this.panelMC.friendListMC.lbl_allow_recruit,"Allow your friend to recruit this character");
         NinjaSage.showDynamicTooltip(this.panelMC.friendListMC.lbl_filter_rank,"Only showing friends with same rank or higher with +10 level difference");
         NinjaSage.showDynamicTooltip(this.panelMC.friendListMC.clearSearch,"Clear search");
         this.panelMC.friendListMC.filterRankMC.tick.visible = false;
         this.hideTabContent();
         this.getFriendList();
         this.resetSelectedTab();
         this.checkRecruited();
         this.currentTab = "allfriend";
         var _loc1_:int = 0;
         while(_loc1_ < this.tabArray.length)
         {
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabArray[_loc1_]],MouseEvent.CLICK,this.changeTab);
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabArray[_loc1_]],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabArray[_loc1_]],MouseEvent.MOUSE_OUT,this.out);
            _loc1_++;
         }
         this.panelMC["btn_" + this.currentTab].gotoAndStop(3);
      }
      
      public function handleFilterLevel(param1:MouseEvent = null) : *
      {
         this.panelMC.friendListMC.filterRankMC.tick.visible = !this.panelMC.friendListMC.filterRankMC.tick.visible;
         this.filterType = this.panelMC.friendListMC.filterRankMC.tick.visible ? "rank" : "";
         this.currentPage = 1;
         switch(this.currentTab)
         {
            case "allfriend":
               this.getFriendList();
               break;
            case "favorite":
               this.getFriendFavorite();
         }
      }
      
      private function getFriendList() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.IiqwXl8dfbqw",[Character.char_id,Character.sessionkey,this.currentPage,this.filterType],this.friendListResponse);
      }
      
      private function getFriendFavorite() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.y6mWeQBukGt9",[Character.char_id,Character.sessionkey,this.currentPage,this.filterType],this.friendListResponse);
      }
      
      private function getFriendRequest() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.ATYh3pqcAhae",[Character.char_id,Character.sessionkey,this.currentPage],this.friendRequestResponse);
      }
      
      private function getFriendRecommendation() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.6HSTubbacsbg",[Character.char_id,Character.sessionkey,this.currentPage],this.friendRecommendationResponse);
      }
      
      private function friendListResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.friendData = param1.friends;
            this.isRecruitable = param1.hasOwnProperty("recruitable") ? Boolean(param1.recruitable) : this.isRecruitable;
            this.currentPage = param1.page.current;
            this.totalPage = param1.page.total;
            this.limitFriend = param1.limit;
            this.totalFriend = param1.total;
            this.renderFriendList();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function renderFriendList() : void
      {
         var _loc3_:OutfitManager = null;
         var _loc1_:MovieClip = this.panelMC.friendListMC;
         _loc1_.visible = true;
         _loc1_.overlay.visible = false;
         _loc1_.txt_total_friend.text = "Friend(s) : " + this.totalFriend + "/" + this.limitFriend;
         _loc1_.allowMC.tick.visible = this.isRecruitable;
         _loc1_.txt_page.text = this.currentPage + "/" + this.totalPage;
         if(!this.selectMode)
         {
            _loc1_.btn_cancel.visible = false;
            _loc1_.btn_unfriendAll.visible = false;
            _loc1_.btn_unfriendSelected.visible = false;
            _loc1_.tick.visible = false;
            _loc1_.btn_unfriend.visible = true;
            _loc1_.btn_AddFriend.visible = true;
            _loc1_.btn_removeRecruit.visible = true;
         }
         else
         {
            _loc1_.btn_cancel.visible = true;
            _loc1_.btn_unfriendAll.visible = true;
            _loc1_.btn_unfriendSelected.visible = true;
            _loc1_.tick.visible = true;
            _loc1_.tick.tick.visible = this.checkIfCurrentPageIsAllSelected();
            _loc1_.btn_unfriend.visible = false;
            _loc1_.btn_AddFriend.visible = false;
            _loc1_.btn_removeRecruit.visible = false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            _loc1_["friend_" + _loc2_].visible = false;
            if(this.friendData[_loc2_])
            {
               _loc1_["friend_" + _loc2_].visible = true;
               _loc3_ = new OutfitManager();
               this.outfits.push(_loc3_);
               _loc3_.fillHead(_loc1_["friend_" + _loc2_].holder,this.friendData[_loc2_].sets.hairstyle,this.friendData[_loc2_].sets.face,this.friendData[_loc2_].sets.hair_color,this.friendData[_loc2_].sets.skin_color);
               if(!this.selectMode)
               {
                  _loc1_["friend_" + _loc2_].tick.visible = false;
                  _loc1_["friend_" + _loc2_].btn_recruit.visible = true;
                  _loc1_["friend_" + _loc2_].btn_option.visible = true;
               }
               else
               {
                  _loc1_["friend_" + _loc2_].btn_recruit.visible = false;
                  _loc1_["friend_" + _loc2_].btn_option.visible = false;
                  _loc1_["friend_" + _loc2_].tick.visible = true;
                  _loc1_["friend_" + _loc2_].tick.tick.visible = this.selectedIdArray.indexOf(this.friendData[_loc2_].id) != -1;
                  this.eventHandler.addListener(_loc1_["friend_" + _loc2_].tick,MouseEvent.CLICK,this.handleTickUnfriend);
               }
               _loc1_["friend_" + _loc2_].optionMC.visible = false;
               _loc1_["friend_" + _loc2_].txt_name.htmlText = Character.colorifyText(this.friendData[_loc2_].id,this.friendData[_loc2_].char.name,_loc1_["friend_" + _loc2_].txt_name);
               this.changeBorderColor(_loc1_["friend_" + _loc2_],this.friendData[_loc2_].id);
               _loc1_["friend_" + _loc2_].txt_lvl.htmlText = "Lv. " + this.friendData[_loc2_].char.level;
               _loc1_["friend_" + _loc2_].rankMC.gotoAndStop(this.friendData[_loc2_].char.rank);
               _loc1_["friend_" + _loc2_].emblemMC.gotoAndStop(int(this.friendData[_loc2_].account_type) + 1);
               _loc1_["friend_" + _loc2_].btn_option.metaData = {"data":this.friendData[_loc2_]};
               _loc1_["friend_" + _loc2_].btn_recruit.metaData = {"data":this.friendData[_loc2_]};
               this.eventHandler.addListener(_loc1_["friend_" + _loc2_].btn_recruit,MouseEvent.CLICK,this.handleRecruit);
               this.eventHandler.addListener(_loc1_["friend_" + _loc2_].btn_option,MouseEvent.CLICK,this.openFriendOption);
            }
            _loc2_++;
         }
      }
      
      private function openFriendOption(param1:MouseEvent) : void
      {
         this.selectedFriendId = param1.currentTarget.metaData.data.id;
         this.selectedFriendIndex = param1.currentTarget.parent.name.replace("friend_","");
         var _loc2_:MovieClip = this.panelMC.friendListMC;
         _loc2_.overlay.visible = true;
         _loc2_["friend_" + this.selectedFriendIndex].optionMC.visible = true;
         this.originalOverlayIndex = _loc2_["friend_" + this.selectedFriendIndex].parent.getChildIndex(_loc2_["friend_" + this.selectedFriendIndex]);
         _loc2_.overlay.parent.setChildIndex(_loc2_["friend_" + this.selectedFriendIndex],_loc2_.overlay.parent.numChildren - 1);
         this.eventHandler.addListener(_loc2_.overlay,MouseEvent.CLICK,this.closeFriendOption);
         _loc2_["friend_" + this.selectedFriendIndex].optionMC.btn_favorite.visible = this.currentTab == "allfriend";
         _loc2_["friend_" + this.selectedFriendIndex].optionMC.btn_unfavorite.visible = this.currentTab == "favorite";
         this.eventHandler.addListener(_loc2_["friend_" + this.selectedFriendIndex].optionMC.btn_profile,MouseEvent.CLICK,this.openFriendProfile);
         this.eventHandler.addListener(_loc2_["friend_" + this.selectedFriendIndex].optionMC.btn_favorite,MouseEvent.CLICK,this.setFavorite);
         this.eventHandler.addListener(_loc2_["friend_" + this.selectedFriendIndex].optionMC.btn_unfavorite,MouseEvent.CLICK,this.removeFavorite);
         this.eventHandler.addListener(_loc2_["friend_" + this.selectedFriendIndex].optionMC.btn_battle,MouseEvent.CLICK,this.startFriendBerantem);
         this.eventHandler.addListener(_loc2_["friend_" + this.selectedFriendIndex].optionMC.btn_unfriend,MouseEvent.CLICK,this.unfriendCharacter);
      }
      
      private function openFriendProfile(param1:MouseEvent) : void
      {
         if(this.currentTab == "request" || this.currentTab == "recommendation")
         {
            this.selectedFriendId = param1.currentTarget.metaData.data.id;
         }
         var _loc2_:Boolean = this.currentTab == "allfriend" || this.currentTab == "favorite" ? false : true;
         _loc2_ = param1.currentTarget.parent.name == "addFriendMC" ? true : _loc2_;
         this.main.openFriendProfile(this.selectedFriendId,_loc2_);
      }
      
      private function startFriendBerantem(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(int(Character.character_lvl) < 10)
         {
            this.main.showMessage("You must be at least Lv. 10 to Challenge your friend");
         }
         else
         {
            this.main.loading(true);
            _loc2_ = CUCSG.hash(Character.char_id + this.selectedFriendId.toString() + Character.sessionkey);
            this.main.amf_manager.service("OvAKMASEbHeDKgxc.bV8fbnOovZAv",[Character.char_id,this.selectedFriendId.toString(),_loc2_,Character.sessionkey],this.startFriendBerantemRes);
         }
      }
      
      private function startFriendBerantemRes(param1:Object) : void
      {
         var _loc2_:Object = null;
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.is_friend_berantem = true;
            Character.battle_code = param1.battle_code;
            Character.mission_id = "temen_berantem";
            _loc2_ = MissionLibrary.getMissionInfo(Character.mission_id);
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.FRIENDLY_MATCH,_loc2_.msn_bg);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            BattleManager.addPlayerToTeam("enemy","char_" + param1.friend_id);
            BattleManager.startBattle();
            this.closePanel(null);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function setFavorite(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.EmBKCFq4G1UC",[Character.char_id,Character.sessionkey,this.selectedFriendId],this.setFavoriteResponse);
      }
      
      private function setFavoriteResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function removeFavorite(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.k3IxPWsmtH39",[Character.char_id,Character.sessionkey,this.selectedFriendId],this.removeFavoriteResponse);
      }
      
      private function removeFavoriteResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            this.getFriendFavorite();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function unfriendCharacter(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name == "btn_unfriendSelected" ? this.selectedIdArray : this.selectedFriendId;
         if(_loc2_ is Array && _loc2_.length == 0)
         {
            this.main.showMessage("Please select at least one friend to unfriend");
            return;
         }
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.XnQr1WuEfkNY",[Character.char_id,Character.sessionkey,_loc2_],this.unfriendCharacterResponse);
      }
      
      private function unfriendCharacterResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            if(this.currentTab == "allfriend")
            {
               this.getFriendList();
            }
            else
            {
               this.getFriendFavorite();
            }
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closeFriendOption(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.panelMC.friendListMC;
         _loc2_.overlay.visible = false;
         _loc2_["friend_" + this.selectedFriendIndex].optionMC.visible = false;
         _loc2_["friend_" + this.selectedFriendIndex].parent.setChildIndex(_loc2_["friend_" + this.selectedFriendIndex],this.originalOverlayIndex);
      }
      
      private function onSearch(param1:MouseEvent) : void
      {
         var _loc2_:* = this.panelMC.friendListMC.searchTxt.text;
         if(_loc2_ != null && _loc2_ != "")
         {
            this.handleSearchAmf();
         }
         else
         {
            this.main.showMessage("Type Friend ID or Name!");
         }
      }
      
      private function handleSearchAmf() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.SZ6kAQtsr5gx",[Character.char_id,Character.sessionkey,this.panelMC.friendListMC.searchTxt.text],this.friendListResponse);
      }
      
      private function onSearchClear(param1:MouseEvent) : void
      {
         if(this.currentTab == "allfriend")
         {
            this.getFriendList();
         }
         else
         {
            this.getFriendFavorite();
         }
         this.panelMC.friendListMC.searchTxt.text = "";
      }
      
      private function handleAllowRecruit(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.FzaFk6C2Wzxs",[Character.char_id,Character.sessionkey],this.allowRecruitRes);
      }
      
      private function allowRecruitRes(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.friendListMC.allowMC.tick.visible = param1.recruitable;
            this.isRecruitable = param1.recruitable;
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function handleRecruit(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.OVCCoJ2razfi",[Character.char_id,Character.sessionkey,param1.currentTarget.metaData.data.id],this.recruitResponse);
      }
      
      private function recruitResponse(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = param1.recruiters[1];
            _loc3_ = CUCSG.hash(param1.recruiters[0][0]);
            if(_loc2_ == _loc3_)
            {
               Character.character_recruit_ids = param1.recruiters[0];
               this.main.showMessage("Friend Recruited");
               this.checkRecruited();
               this.main.HUD.setBasicData();
            }
            else
            {
               this.main.getError(204);
            }
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function checkRecruited() : void
      {
         if(Character.character_recruit_ids.length == 0)
         {
            this.panelMC.friendListMC.btn_removeRecruit.visible = false;
         }
         else
         {
            this.panelMC.friendListMC.btn_removeRecruit.visible = true;
         }
      }
      
      private function removeRecruitedSquad(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.UfM4kjzQev0Y",[Character.char_id,Character.sessionkey],this.removeRecruitedSquadRes);
      }
      
      private function removeRecruitedSquadRes(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            Character.character_recruit_ids = [];
            this.main.HUD.setBasicData();
            this.checkRecruited();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function friendRecommendationResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.friendRequestData = param1.recommendations;
            this.currentPage = param1.page.current;
            this.totalPage = param1.page.total;
            this.renderFriendRecommendationList();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function friendRequestResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.friendRequestData = param1.invitations;
            this.currentPage = param1.page.current;
            this.totalPage = param1.page.total;
            this.totalFriendRequest = param1.total;
            this.renderFriendRequestList();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function handleUnfriend(param1:MouseEvent) : void
      {
         this.selectMode = true;
         var _loc2_:MovieClip = this.panelMC.friendListMC;
         _loc2_.tick.visible = false;
         this.eventHandler.addListener(_loc2_.btn_unfriendSelected,MouseEvent.CLICK,this.unfriendCharacter);
         this.eventHandler.addListener(_loc2_.btn_unfriendAll,MouseEvent.CLICK,this.unfriendAllConfirmation);
         this.eventHandler.addListener(_loc2_.btn_cancel,MouseEvent.CLICK,this.cancelUnfriend);
         this.eventHandler.addListener(_loc2_.tick,MouseEvent.CLICK,this.selectAllListUnfriend);
         if(this.currentTab == "allfriend")
         {
            this.getFriendList();
         }
         else
         {
            this.getFriendFavorite();
         }
      }
      
      private function cancelUnfriend(param1:MouseEvent) : void
      {
         this.selectMode = false;
         this.selectedIdArray = [];
         if(this.currentTab == "allfriend")
         {
            this.getFriendList();
         }
         else
         {
            this.getFriendFavorite();
         }
      }
      
      private function handleTickUnfriend(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.panelMC.friendListMC;
         var _loc3_:int = int(param1.currentTarget.parent.name.replace("friend_",""));
         _loc2_["friend_" + _loc3_].tick.tick.visible = !_loc2_["friend_" + _loc3_].tick.tick.visible;
         if(_loc2_["friend_" + _loc3_].tick.tick.visible)
         {
            this.selectedIdArray.push(this.friendData[_loc3_].id);
         }
         else
         {
            this.selectedIdArray.splice(this.selectedIdArray.indexOf(this.friendData[_loc3_].id),1);
         }
         _loc2_.tick.tick.visible = this.checkIfCurrentPageIsAllSelected();
      }
      
      private function selectAllListUnfriend(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.panelMC.friendListMC;
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            if(Boolean(!_loc2_.tick.tick.visible) && Boolean(this.friendData[_loc3_]) && this.selectedIdArray.indexOf(this.friendData[_loc3_].id) == -1)
            {
               _loc2_["friend_" + _loc3_].tick.tick.visible = true;
               this.selectedIdArray.push(this.friendData[_loc3_].id);
            }
            if(Boolean(_loc2_.tick.tick.visible) && Boolean(this.friendData[_loc3_]) && this.selectedIdArray.indexOf(this.friendData[_loc3_].id) != -1)
            {
               _loc2_["friend_" + _loc3_].tick.tick.visible = false;
               this.selectedIdArray.splice(this.selectedIdArray.indexOf(this.friendData[_loc3_].id),1);
            }
            _loc3_++;
         }
         _loc2_.tick.tick.visible = this.checkIfCurrentPageIsAllSelected();
      }
      
      private function checkIfCurrentPageIsAllSelected() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            if(Boolean(this.friendData[_loc1_]) && this.selectedIdArray.indexOf(this.friendData[_loc1_].id) == -1)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function unfriendAllConfirmation(param1:MouseEvent) : void
      {
         this.panelMC.friendListMC.confirmationMc.visible = true;
         this.panelMC.friendListMC.setChildIndex(this.panelMC.friendListMC.confirmationMc,this.panelMC.friendListMC.numChildren - 1);
         this.panelMC.friendListMC.confirmationMc.btn_confirm.addEventListener(MouseEvent.CLICK,this.unfriendAll);
         this.panelMC.friendListMC.confirmationMc.btn_close.addEventListener(MouseEvent.CLICK,this.closeUnfriendAll);
      }
      
      private function closeUnfriendAll(param1:MouseEvent = null) : void
      {
         this.panelMC.friendListMC.confirmationMc.visible = false;
         this.panelMC.friendListMC.confirmationMc.txt_reset.text = "";
      }
      
      private function unfriendAll(param1:MouseEvent) : void
      {
         if(this.panelMC.friendListMC.confirmationMc.txt_reset.text != "UNFRIEND ALL")
         {
            this.main.getNotice("Wrong Input! Must Type UNFRIEND ALL in Uppercase");
            return;
         }
         this.closeUnfriendAll();
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.NkOD2hqZv79S",[Character.char_id,Character.sessionkey],this.onUnfriendAll);
      }
      
      private function onUnfriendAll(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(this.currentTab == "allfriend")
            {
               this.getFriendList();
            }
            else
            {
               this.getFriendFavorite();
            }
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function renderFriendRequestList() : void
      {
         var _loc3_:OutfitManager = null;
         var _loc1_:MovieClip = this.panelMC.friendRequestMC;
         _loc1_.visible = true;
         _loc1_.txt_total_request.text = "Request(s) : " + this.totalFriendRequest;
         _loc1_.txt_page.text = this.currentPage + "/" + this.totalPage;
         _loc1_.btn_select.visible = false;
         _loc1_.tick.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc1_["request_" + _loc2_].visible = false;
            if(this.friendRequestData[_loc2_])
            {
               _loc1_["request_" + _loc2_].visible = true;
               _loc3_ = new OutfitManager();
               this.outfits.push(_loc3_);
               _loc3_.fillHead(_loc1_["request_" + _loc2_].holder,this.friendRequestData[_loc2_].sets.hairstyle,this.friendRequestData[_loc2_].sets.face,this.friendRequestData[_loc2_].sets.hair_color,this.friendRequestData[_loc2_].sets.skin_color);
               _loc1_["request_" + _loc2_].tick.visible = false;
               _loc1_["request_" + _loc2_].txt_name.htmlText = Character.colorifyText(this.friendRequestData[_loc2_].id,this.friendRequestData[_loc2_].char.name,_loc1_["request_" + _loc2_].txt_name);
               _loc1_["request_" + _loc2_].txt_lvl.htmlText = "Lv. " + this.friendRequestData[_loc2_].char.level;
               _loc1_["request_" + _loc2_].rankMC.gotoAndStop(this.friendRequestData[_loc2_].char.rank);
               _loc1_["request_" + _loc2_].emblemMC.gotoAndStop(int(this.friendRequestData[_loc2_].account_type) + 1);
               _loc1_["request_" + _loc2_].btn_accept.metaData = {"data":this.friendRequestData[_loc2_]};
               _loc1_["request_" + _loc2_].btn_reject.metaData = {"data":this.friendRequestData[_loc2_]};
               _loc1_["request_" + _loc2_].btn_profile.metaData = {"data":this.friendRequestData[_loc2_]};
               this.eventHandler.addListener(_loc1_["request_" + _loc2_].btn_accept,MouseEvent.CLICK,this.handleAcceptRejectFriendRequest);
               this.eventHandler.addListener(_loc1_["request_" + _loc2_].btn_reject,MouseEvent.CLICK,this.handleAcceptRejectFriendRequest);
               this.eventHandler.addListener(_loc1_["request_" + _loc2_].btn_profile,MouseEvent.CLICK,this.openFriendProfile);
            }
            _loc2_++;
         }
      }
      
      private function handleAcceptRejectFriendRequest(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.acceptRejectButton = param1.currentTarget.name;
         if(this.acceptRejectButton == "btn_accept")
         {
            this.main.amf_manager.service("OvAKMASEbHeDKgxc.3szoqPfpO81A",[Character.char_id,Character.sessionkey,param1.currentTarget.metaData.data.id],this.acceptRejectResponse);
         }
         else if(this.acceptRejectButton == "btn_reject")
         {
            this.main.amf_manager.service("OvAKMASEbHeDKgxc.XnQr1WuEfkNY",[Character.char_id,Character.sessionkey,param1.currentTarget.metaData.data.id],this.acceptRejectResponse);
         }
         else if(this.acceptRejectButton == "btn_acceptAll")
         {
            this.main.amf_manager.service("OvAKMASEbHeDKgxc.1SCgBo1oKuyD",[Character.char_id,Character.sessionkey],this.acceptRejectResponse);
         }
         else if(this.acceptRejectButton == "btn_rejectAll")
         {
            this.main.amf_manager.service("OvAKMASEbHeDKgxc.EOaCuygFiy3O",[Character.char_id,Character.sessionkey],this.acceptRejectResponse);
         }
      }
      
      private function acceptRejectResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            if(this.acceptRejectButton == "btn_acceptAll" || this.acceptRejectButton == "btn_rejectAll")
            {
               this.currentPage = 1;
            }
            this.getFriendRequest();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function renderFriendRecommendationList() : void
      {
         var _loc3_:OutfitManager = null;
         var _loc1_:MovieClip = this.panelMC.friendRecommendationMC;
         _loc1_.visible = true;
         _loc1_.txt_page.text = this.currentPage + "/" + this.totalPage;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc1_["recommend_" + _loc2_].visible = false;
            if(this.friendRequestData[_loc2_])
            {
               _loc1_["recommend_" + _loc2_].visible = true;
               _loc3_ = new OutfitManager();
               this.outfits.push(_loc3_);
               _loc3_.fillHead(_loc1_["recommend_" + _loc2_].holder,this.friendRequestData[_loc2_].sets.hairstyle,this.friendRequestData[_loc2_].sets.face,this.friendRequestData[_loc2_].sets.hair_color,this.friendRequestData[_loc2_].sets.skin_color);
               _loc1_["recommend_" + _loc2_].txt_name.htmlText = Character.colorifyText(this.friendRequestData[_loc2_].id,this.friendRequestData[_loc2_].char.name,_loc1_["recommend_" + _loc2_].txt_name);
               _loc1_["recommend_" + _loc2_].txt_lvl.htmlText = "Lv. " + this.friendRequestData[_loc2_].char.level;
               _loc1_["recommend_" + _loc2_].rankMC.gotoAndStop(this.friendRequestData[_loc2_].char.rank);
               _loc1_["recommend_" + _loc2_].emblemMC.gotoAndStop(int(this.friendRequestData[_loc2_].account_type) + 1);
               _loc1_["recommend_" + _loc2_].btn_addFriend.metaData = {"data":this.friendRequestData[_loc2_]};
               _loc1_["recommend_" + _loc2_].btn_profile.metaData = {"data":this.friendRequestData[_loc2_]};
               this.eventHandler.addListener(_loc1_["recommend_" + _loc2_].btn_addFriend,MouseEvent.CLICK,this.handleAddFriendSend);
               this.eventHandler.addListener(_loc1_["recommend_" + _loc2_].btn_profile,MouseEvent.CLICK,this.openFriendProfile);
            }
            _loc2_++;
         }
      }
      
      private function handleAddFriend(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.panelMC.addFriendMC;
         _loc2_.visible = true;
         _loc2_.btn_profile.visible = false;
         _loc2_.btn_addFriend.visible = false;
         _loc2_.contentMC.visible = false;
         this.eventHandler.addListener(_loc2_.btn_close,MouseEvent.CLICK,this.closeAddFriend);
         this.eventHandler.addListener(_loc2_.btn_search,MouseEvent.CLICK,this.handleAddFriendSearch);
         this.eventHandler.addListener(_loc2_.btn_profile,MouseEvent.CLICK,this.openFriendProfile);
         this.eventHandler.addListener(_loc2_.btn_addFriend,MouseEvent.CLICK,this.handleAddFriendSend);
         this.eventHandler.addListener(_loc2_.clearSearch,MouseEvent.CLICK,this.handleAddFriendSearchClear);
      }
      
      private function handleAddFriendSearch(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.iakN46g0GaJN",[Character.char_id,Character.sessionkey,this.panelMC.addFriendMC.search.text],this.searchAddFriendResponse);
      }
      
      private function searchAddFriendResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.addFriendData = param1;
            this.panelMC.addFriendMC.btn_profile.visible = true;
            this.panelMC.addFriendMC.btn_addFriend.visible = true;
            this.selectedFriendId = this.panelMC.addFriendMC.search.text;
            this.renderAddFriend();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function renderAddFriend() : void
      {
         var _loc6_:int = 0;
         var _loc1_:MovieClip = this.panelMC.addFriendMC;
         _loc1_.contentMC.visible = true;
         var _loc2_:OutfitManager = new OutfitManager();
         this.outfits.push(_loc2_);
         _loc2_.fillHead(_loc1_.contentMC.holder,this.addFriendData.character_sets.hairstyle,this.addFriendData.character_sets.face,this.addFriendData.character_sets.hair_color,this.addFriendData.character_sets.skin_color);
         _loc1_.contentMC.txt_name.htmlText = Character.colorifyText(this.addFriendData.character_data.character_id,this.addFriendData.character_data.character_name,_loc1_.contentMC.txt_name);
         _loc1_.contentMC.txt_lvl.htmlText = "Lv. " + this.addFriendData.character_data.character_level;
         _loc1_.contentMC.rankMC.gotoAndStop(this.addFriendData.character_data.character_rank);
         _loc1_.contentMC.emblemMC.gotoAndStop(int(this.addFriendData.account_type) + 1);
         _loc1_.contentMC.element_1.gotoAndStop(int(this.addFriendData.character_data.character_element_1) + 1);
         _loc1_.contentMC.element_2.gotoAndStop(int(this.addFriendData.character_data.character_element_2) + 1);
         if(this.addFriendData.character_data.character_element_3 == 0 || this.addFriendData.account_type == 0)
         {
            _loc1_.contentMC.element_3.gotoAndStop(1);
         }
         else
         {
            _loc1_.contentMC.element_3.gotoAndStop(int(this.addFriendData.character_data.character_element_3) + 1);
         }
         var _loc3_:int = 1;
         while(_loc3_ < 4)
         {
            if(this.addFriendData.character_data["character_talent_" + _loc3_] == null)
            {
               _loc6_ = _loc3_ == 1 ? 3 : 4;
               _loc1_.contentMC["talent_" + _loc3_].gotoAndStop(_loc6_);
            }
            else
            {
               _loc1_.contentMC["talent_" + _loc3_].gotoAndStop(this.addFriendData.character_data["character_talent_" + _loc3_]);
            }
            _loc3_++;
         }
         var _loc4_:String = this.addFriendData.character_data.character_senjutsu ? this.addFriendData.character_data.character_senjutsu : "learnSenjutsu";
         _loc1_.contentMC.senjutsuMC.gotoAndStop(_loc4_);
         var _loc5_:String = this.addFriendData.character_data.character_class ? this.addFriendData.character_data.character_class : "classNull";
         _loc1_.contentMC.classMC.gotoAndStop(_loc5_);
         GF.removeAllChild(_loc1_.contentMC.petMC.holder);
         if("pet_swf" in this.addFriendData.pet_data && this.addFriendData.pet_data.pet_swf != null)
         {
            NinjaSage.loadIconSWF("pets",this.addFriendData.pet_data.pet_swf,_loc1_.contentMC.petMC.holder,"PetStaticFullBody");
            _loc1_.contentMC.petMC.holder.scaleX = 0.8;
            _loc1_.contentMC.petMC.holder.scaleY = 0.8;
         }
         GF.removeAllChild(this.panelMC.addFriendMC.contentMC.clanLogoHolder);
         if(this.addFriendData.clan != null)
         {
            if(this.addFriendData.clan.banner != null)
            {
               this.loaderSwf.removeAll();
               this.loaderSwf.add(this.addFriendData.clan.banner,{"id":"clanBanner"});
               this.loaderSwf.addEventListener(BulkLoader.COMPLETE,this.onClanLogoLoaded);
               this.loaderSwf.start();
            }
         }
      }
      
      private function onClanLogoLoaded(param1:Event) : void
      {
         this.loaderSwf.removeEventListener(BulkLoader.COMPLETE,this.onClanLogoLoaded);
         GF.removeAllChild(this.panelMC.addFriendMC.contentMC.clanLogoHolder);
         this.panelMC.addFriendMC.contentMC.clanLogoHolder.addChild(this.loaderSwf.getContent("clanBanner",true));
         NinjaSage.showDynamicTooltip(this.panelMC.addFriendMC.contentMC.clanLogoHolder,"[" + this.addFriendData.clan.id + "] " + this.addFriendData.clan.name);
         this.panelMC.addFriendMC.contentMC.clanLogoHolder.scaleX = 0.5;
         this.panelMC.addFriendMC.contentMC.clanLogoHolder.scaleY = 0.5;
      }
      
      private function handleAddFriendSend(param1:MouseEvent) : void
      {
         this.selectedFriendId = this.currentTab == "recommendation" ? int(param1.currentTarget.metaData.data.id) : this.selectedFriendId;
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.fRhD12Uvu6No",[Character.char_id,Character.sessionkey,this.selectedFriendId],this.addFriendResponse);
      }
      
      private function addFriendResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function handleAddFriendSearchClear(param1:MouseEvent) : void
      {
         this.panelMC.addFriendMC.search.text = "";
      }
      
      private function closeAddFriend(param1:MouseEvent) : void
      {
         this.panelMC.addFriendMC.visible = false;
         this.panelMC.addFriendMC.search.text = "";
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
               }
         }
         switch(this.currentTab)
         {
            case "allfriend":
               this.getFriendList();
               break;
            case "favorite":
               this.getFriendFavorite();
               break;
            case "request":
               this.getFriendRequest();
               break;
            case "recommendation":
               this.getFriendRecommendation();
         }
      }
      
      private function hideTabContent() : void
      {
         this.panelMC.addFriendMC.visible = false;
         this.panelMC.friendRecommendationMC.visible = false;
         this.panelMC.friendRequestMC.visible = false;
         this.panelMC.friendListMC.visible = false;
         this.panelMC.friendListMC.overlay.visible = false;
         this.panelMC.friendListMC.confirmationMc.visible = false;
      }
      
      private function changeTab(param1:MouseEvent) : void
      {
         this.currentPage = 1;
         this.resetSelectedTab();
         this.hideTabContent();
         param1.currentTarget.gotoAndStop(3);
         switch(param1.currentTarget.name)
         {
            case "btn_allfriend":
               this.currentTab = "allfriend";
               this.getFriendList();
               break;
            case "btn_favorite":
               this.currentTab = "favorite";
               this.getFriendFavorite();
               break;
            case "btn_request":
               this.currentTab = "request";
               this.getFriendRequest();
               break;
            case "btn_recommendation":
               this.currentTab = "recommendation";
               this.getFriendRecommendation();
         }
      }
      
      private function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function resetSelectedTab() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.tabArray.length)
         {
            this.panelMC["btn_" + this.tabArray[_loc1_]].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function changeBorderColor(param1:MovieClip, param2:int) : void
      {
         var _loc4_:ColorTransform = null;
         var _loc3_:uint = this.getCharacterColor(param2);
         this.removeGradient(param1.bg);
         if(_loc3_ != 0)
         {
            _loc4_ = new ColorTransform();
            _loc4_.color = _loc3_;
            param1.border.transform.colorTransform = _loc4_;
            this.applyGradient(param1.bg,[_loc3_,_loc3_],[0,0.4],[0,255]);
         }
         else
         {
            param1.border.transform.colorTransform = new ColorTransform();
         }
      }
      
      private function getCharacterColor(param1:int) : uint
      {
         var _loc2_:* = Character.rgb_data[param1];
         if(!_loc2_)
         {
            return 0;
         }
         if(_loc2_ is Array)
         {
            return _loc2_.length > 0 ? uint("0x" + String(_loc2_[0]).substr(1)) : 0;
         }
         return uint("0x" + _loc2_.substr(1));
      }
      
      private function applyGradient(param1:MovieClip, param2:Array, param3:Array, param4:Array) : void
      {
         var _loc5_:* = param1.parent;
         var _loc6_:Object = param1.getBounds(param1.parent);
         var _loc7_:Matrix = new Matrix();
         _loc7_.createGradientBox(_loc6_.width,_loc6_.height,0,_loc6_.x,_loc6_.y);
         var _loc8_:Sprite = new Sprite();
         _loc8_.name = param1.parent.name + "_gradient";
         _loc8_.graphics.beginGradientFill(GradientType.LINEAR,param2,param3,param4,_loc7_);
         _loc8_.graphics.drawRect(_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height);
         _loc8_.graphics.endFill();
         var _loc9_:int = int(_loc5_.getChildIndex(param1));
         _loc5_.addChildAt(_loc8_,_loc9_ + 1);
         _loc8_.mask = param1;
      }
      
      private function removeGradient(param1:MovieClip) : void
      {
         if(param1.parent.getChildByName(param1.parent.name + "_gradient") != null)
         {
            param1.parent.removeChild(param1.parent.getChildByName(param1.parent.name + "_gradient"));
         }
      }
      
      private function openFriendshipShop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Friendship_Shop");
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.destroyArray(this.outfits);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.outfits = null;
         this.friendData = null;
         this.friendRequestData = null;
         this.friendRecommendationData = null;
         this.tabArray = null;
         this.currentTab = null;
         this.acceptRejectButton = null;
         this.selectedIdArray = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
         this.loaderSwf.clear();
         this.loaderSwf = null;
         this.addFriendData = null;
      }
   }
}

