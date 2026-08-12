package id.ninjasage.features
{
   import Managers.AppManager;
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   import id.ninjasage.Crew;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   public dynamic class CrewHall extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var memberRequest:Array;
      
      private var crewMembers:Array;
      
      private var crewData:Object;
      
      private var crewVillage;
      
      private var charData:Object;
      
      private var currentPageMember:int = 1;
      
      private var totalPageMember:int = 0;
      
      private var currentPageRequest:int = 1;
      
      private var totalPageRequest:int = 0;
      
      private var selectedMemberId:int = -1;
      
      private var selectedRequestId:int = -1;
      
      private var totalDonation:Number;
      
      private var selectedDonation:String;
      
      private var currentTab:String;
      
      private const RENAME_PRICE_TOKEN:int = 3000;
      
      private const MAX_TOTAL_MEMBERS:int = 40;
      
      private var historyScrollPane:HistoryScrollPane;
      
      public function CrewHall(param1:*, param2:*)
      {
         super();
         this.main = AppManager.getInstance().main;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.crewVillage = param1;
         this.eventHandler = new EventHandler();
         this.crewData = Character.crew_data;
         this.charData = Character.crew_char_data;
         this.crewVillage.panelMC.visible = false;
         this.panelMC.addFrameScript(0,this.frame1,11,this.onInitProfile,16,this.onInitAnnouncement,21,this.onInitMember,26,this.onInitHistory);
         this.panelMC.gotoAndPlay(2);
      }
      
      private function initTab() : void
      {
         this.eventHandler.removeListener(this.panelMC.panelMc.profileBtn,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.removeListener(this.panelMC.panelMc.announcementBtn,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.removeListener(this.panelMC.panelMc.memberListBtn,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.removeListener(this.panelMC.panelMc.logBtn,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.removeListener(this.panelMC.panelMc.closeBtn,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.panelMc.profileBtn,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.panelMC.panelMc.announcementBtn,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.panelMC.panelMc.memberListBtn,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.panelMC.panelMc.logBtn,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.panelMC.panelMc.closeBtn,MouseEvent.CLICK,this.closePanel);
         this.panelMC.panelMc.profileBtn.gotoAndStop("unselect");
         this.panelMC.panelMc.announcementBtn.gotoAndStop("unselect");
         this.panelMC.panelMc.memberListBtn.gotoAndStop("unselect");
         this.panelMC.panelMc.logBtn.gotoAndStop("unselect");
      }
      
      private function initProfile() : void
      {
         this.currentTab = "profile";
         this.panelMC.gotoAndStop("profile");
         this.initTab();
         this.panelMC.panelMc.profileBtn.gotoAndStop("select");
         this.panelMC.panelMc.donateMc.gotoAndStop("idle");
         this.panelMC.panelMc.addMemberMc.gotoAndStop("idle");
         this.panelMC.panelMc.managementMc.gotoAndStop("idle");
         this.panelMC.panelMc.recruitMc.gotoAndStop("idle");
         this.panelMC.panelMc.rewardMc.gotoAndStop("idle");
         this.panelMC.panelMc.donateTokenMc.gotoAndStop("idle");
         this.panelMC.panelMc.quitMC.gotoAndStop("idle");
         this.panelMC.panelMc.detailMC.gotoAndStop("idle");
         this.panelMC.panelMc.detailMC2.gotoAndStop("idle");
         this.panelMC.panelMc.nameTxt.text = this.crewData.name;
         this.panelMC.panelMc.idTxt.text = this.crewData.id;
         this.panelMC.panelMc.masterNameTxt.htmlText = Character.colorifyText(this.crewData.master_id,"[" + this.crewData.master_id + "] " + this.crewData.master_name,this.panelMC.panelMc.masterNameTxt);
         this.panelMC.panelMc.elderNameTxt.htmlText = this.crewData.elder_id == 0 ? "-" : Character.colorifyText(this.crewData.elder_id,"[" + this.crewData.elder_id + "] " + this.crewData.elder_name,this.panelMC.panelMc.elderNameTxt);
         this.panelMC.panelMc.memberTxt.text = this.crewData.members + "/" + this.crewData.max_members;
         this.panelMC.panelMc.goldTxt.text = this.crewData.golds;
         this.panelMC.panelMc.tokenTxt.text = this.crewData.tokens;
         this.panelMC.panelMc.teahouseMc.gotoAndStop("level_" + this.crewData.tea_house);
         this.panelMC.panelMc.KushiDangoMc.gotoAndStop("level_" + this.crewData.kushi_dango);
         this.panelMC.panelMc.bathhouseMc.gotoAndStop("level_" + this.crewData.bath_house);
         this.panelMC.panelMc.trainingMc.gotoAndStop("level_" + this.crewData.training_centre);
         this.panelMC.panelMc.teahouseLv.text = "[Level " + this.crewData.tea_house + "]";
         this.panelMC.panelMc.KushiDangoLv.text = "[Level " + this.crewData.kushi_dango + "]";
         this.panelMC.panelMc.bathhouseLv.text = "[Level " + this.crewData.bath_house + "]";
         this.panelMC.panelMc.trainingLv.text = "[Level " + this.crewData.training_centre + "]";
         this.panelMC.panelMc.teahouseDes.text = "+" + this.crewVillage.buildingData.teahouseBtn.amount[this.crewData.tea_house] + this.crewVillage.buildingData.teahouseBtn.description;
         this.panelMC.panelMc.KushiDangoDes.text = "+" + this.crewVillage.buildingData.KushiDangoBtn.amount[this.crewData.kushi_dango] + this.crewVillage.buildingData.KushiDangoBtn.description;
         this.panelMC.panelMc.bathhouseDes.text = "+" + this.crewVillage.buildingData.bathhouseBtn.amount[this.crewData.bath_house] + this.crewVillage.buildingData.bathhouseBtn.description;
         this.panelMC.panelMc.trainingDes.text = "+" + this.crewVillage.buildingData.trainingBtn.amount[this.crewData.training_centre] + this.crewVillage.buildingData.trainingBtn.description;
         this.panelMC.panelMc.dismissBtn.visible = false;
         this.panelMC.panelMc.managementBtn.visible = false;
         this.panelMC.panelMc.inviteBtn.visible = false;
         this.panelMC.panelMc.quitBtn.visible = true;
         if(this.crewData.master_id == Character.char_id || this.crewData.elder_id == Character.char_id)
         {
            this.panelMC.panelMc.dismissBtn.visible = true;
            this.panelMC.panelMc.managementBtn.visible = true;
            this.panelMC.panelMc.inviteBtn.visible = true;
            this.panelMC.panelMc.quitBtn.visible = false;
         }
         this.eventHandler.addListener(this.panelMC.panelMc.rewardBtn,MouseEvent.CLICK,this.showRewardDamageRank);
         this.eventHandler.addListener(this.panelMC.panelMc.faqBtn,MouseEvent.CLICK,this.showDamageBonusFaq);
         this.eventHandler.addListener(this.panelMC.panelMc.inviteBtn,MouseEvent.CLICK,this.openInviteMember);
         this.eventHandler.addListener(this.panelMC.panelMc.managementBtn,MouseEvent.CLICK,this.openManagement);
         this.eventHandler.addListener(this.panelMC.panelMc.donateGoldBtn,MouseEvent.CLICK,this.openDonate);
         this.eventHandler.addListener(this.panelMC.panelMc.donateTokenBtn,MouseEvent.CLICK,this.openDonate);
         this.eventHandler.addListener(this.panelMC.panelMc.quitBtn,MouseEvent.CLICK,this.firstConfirmationQuitDismiss);
         this.eventHandler.addListener(this.panelMC.panelMc.dismissBtn,MouseEvent.CLICK,this.firstConfirmationQuitDismiss);
      }
      
      private function openInviteMember(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.recruitMc.gotoAndStop("show");
         this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.closeBtn,MouseEvent.CLICK,this.closeInviteMember);
         this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.btn_requestlist,MouseEvent.CLICK,this.initRequestMember);
         this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.inviteBtn,MouseEvent.CLICK,this.sendInviteRequest);
         this.panelMC.panelMc.recruitMc.panelMc.charIdTxt.restrict = "0-9";
      }
      
      private function initRequestMember(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.recruitMc.gotoAndStop("accept_request_list");
         this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.closeBtn,MouseEvent.CLICK,this.closeInviteMember);
         this.main.loading(true);
         Crew.instance.getMemberRequests(this.initRequestMemberData);
      }
      
      private function initRequestMemberData(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("requests"))
         {
            this.memberRequest = param1.requests;
            this.panelMC.panelMc.recruitMc.panelMc.pageTxt.text = this.currentPageRequest + " / " + this.totalPageRequest;
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.closeBtn,MouseEvent.CLICK,this.closeRequestMember);
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.prevPageBtn,MouseEvent.CLICK,this.changePageRequest);
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.nextPageBtn,MouseEvent.CLICK,this.changePageRequest);
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.btn_accept,MouseEvent.CLICK,this.acceptMember);
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.btn_reject,MouseEvent.CLICK,this.rejectMember);
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.btn_rejectall,MouseEvent.CLICK,this.rejectAllMember);
            this.currentPageRequest = 1;
            this.totalPageRequest = Math.max(Math.ceil(this.memberRequest.length / 8),1);
            this.renderCrewRequest();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      private function renderCrewRequest() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = this.panelMC.panelMc.recruitMc.panelMc["request_" + _loc1_];
            _loc2_.visible = false;
            _loc2_.gotoAndStop("idle");
            _loc3_ = _loc1_ + int(int(this.currentPageRequest - 1) * 8);
            if(this.memberRequest.length > _loc3_)
            {
               _loc2_.visible = true;
               _loc2_.idTxt.text = this.memberRequest[_loc3_].char_id;
               _loc2_.NameTxt.htmlText = Character.colorifyText(this.memberRequest[_loc3_].char_id,this.memberRequest[_loc3_].name,_loc2_.NameTxt);
               _loc2_.lvTxt.text = this.memberRequest[_loc3_].level;
               _loc2_.buttonMode = true;
               _loc2_.metaData = {"charId":this.memberRequest[_loc3_].char_id};
               this.eventHandler.addListener(_loc2_,MouseEvent.CLICK,this.selectRequestMember);
            }
            _loc1_++;
         }
         this.totalPageRequest = Math.max(Math.ceil(this.memberRequest.length / 8),1);
         this.updatePageTextRequest();
      }
      
      private function selectRequestMember(param1:MouseEvent) : void
      {
         this.resetSelectedRequestMember();
         var _loc2_:int = param1.currentTarget.name.replace("request_","");
         this.panelMC.panelMc.recruitMc.panelMc["request_" + _loc2_].gotoAndStop("selected");
         this.selectedRequestId = param1.currentTarget.metaData.charId;
      }
      
      private function resetSelectedRequestMember() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            this.panelMC.panelMc.recruitMc.panelMc["request_" + _loc1_].gotoAndStop("idle");
            this.selectedRequestId = -1;
            _loc1_++;
         }
      }
      
      private function acceptMember(param1:MouseEvent) : void
      {
         if(this.selectedRequestId < 0)
         {
            this.main.getNotice("Please select a member");
            return;
         }
         this.main.loading(true);
         Crew.instance.acceptMember(this.selectedRequestId,this.onAcceptMemberRes);
      }
      
      private function onAcceptMemberRes(param1:Object, param2:*) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("result"))
         {
            this.main.getNotice("Member accepted");
            this.selectedRequestId = -1;
            this.initRequestMember(null);
            this.resetSelectedRequestMember();
            this.panelMC.panelMc.memberTxt.text = this.crewData.members + "/" + this.crewData.max_members;
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getNotice("Failed to accept the member. Please try again later");
      }
      
      private function rejectMember(param1:MouseEvent) : void
      {
         if(this.selectedRequestId < 0)
         {
            this.main.getNotice("Please select a member");
            return;
         }
         this.main.loading(true);
         Crew.instance.rejectMember(this.selectedRequestId,this.onRejectMemberRes);
      }
      
      private function onRejectMemberRes(param1:Object, param2:*) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("result"))
         {
            this.main.getNotice("Member rejected");
            this.selectedRequestId = -1;
            this.initRequestMember(null);
            this.resetSelectedRequestMember();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getNotice("Failed to accept the member. Please try again later");
      }
      
      private function rejectAllMember(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.rejectMembers(this.onRejectAllMemberRes);
      }
      
      private function onRejectAllMemberRes(param1:Object, param2:*) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("result"))
         {
            this.main.getNotice("All Member rejected");
            this.selectedRequestId = -1;
            this.initRequestMember(null);
            this.resetSelectedRequestMember();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getNotice("Failed to accept the member. Please try again later");
      }
      
      private function changePageRequest(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "nextPageBtn":
               if(this.totalPageRequest > this.currentPageRequest)
               {
                  ++this.currentPageRequest;
                  this.renderCrewRequest();
               }
               break;
            case "prevPageBtn":
               if(this.currentPageRequest > 1)
               {
                  --this.currentPageRequest;
                  this.renderCrewRequest();
               }
         }
         this.updatePageTextRequest();
      }
      
      private function updatePageTextRequest() : void
      {
         this.panelMC.panelMc.recruitMc.panelMc.pageTxt.text = this.currentPageRequest + "/" + this.totalPageRequest;
      }
      
      private function closeRequestMember(param1:MouseEvent) : void
      {
         this.selectedRequestId = -1;
         this.resetSelectedRequestMember();
         this.panelMC.panelMc.recruitMc.gotoAndStop("show");
      }
      
      private function sendInviteRequest(param1:MouseEvent) : void
      {
         if(this.panelMC.panelMc.recruitMc.panelMc.charIdTxt.text == "")
         {
            this.main.getNotice("Char ID can\'t be empty!");
            return;
         }
         Crew.instance.inviteCharacter(this.panelMC.panelMc.recruitMc.panelMc.charIdTxt.text,this.onInviteRequestSent);
      }
      
      private function onInviteRequestSent(param1:Object, param2:* = null) : void
      {
         if("status" in param1 && param1.status == "ok")
         {
            this.main.giveMessage("invitation has been sent");
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Unable to send invitation.\n" + param1.errorMessage);
         }
      }
      
      private function closeInviteMember(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.recruitMc.gotoAndStop("idle");
      }
      
      private function openManagement(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.managementMc.gotoAndStop("show");
         this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.visible = false;
         if(this.crewData.master_id != Character.char_id)
         {
            this.panelMC.panelMc.managementMc.panelMc.btn_renameCrew.visible = false;
         }
         this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.btn_increaseMember,MouseEvent.CLICK,this.openIncreaseMember);
         this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.btn_renameCrew,MouseEvent.CLICK,this.renameCrew);
         this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.btn_close,MouseEvent.CLICK,this.closeCrewManagement);
      }
      
      public function renameCrew(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.visible = true;
         this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.warningTxt.text = "Attention:\n- Rename Crew Cost " + this.RENAME_PRICE_TOKEN + " Tokens\n- Rename Crew Will Cost Crew Tokens\n- 30 Days Cooldown After Rename\n- Crew Rename is Closed 7 Days Before Final Day";
         this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.btn_close,MouseEvent.CLICK,this.closeCrewRename);
         this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.btn_confirm,MouseEvent.CLICK,this.crewRenameConfirmation);
      }
      
      public function crewRenameConfirmation(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.confirmation = null;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to change your clan name to " + this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.nameTxt.text + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onCrewRename);
         this.panelMC.addChild(this.confirmation);
      }
      
      public function onCrewRename(param1:MouseEvent) : void
      {
         this.closeConfirmation(null);
         this.main.loading(true);
         Crew.instance.renameCrew(this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.nameTxt.text,this.onCrewRenameRes);
      }
      
      public function onCrewRenameRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 == null)
         {
            this.main.showMessage("Crew Name Successfully Renamed!");
            this.closeCrewRename();
            this.refreshData();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         this.main.getNotice("Failed to rename crew. Please try again later");
      }
      
      public function closeCrewRename(param1:MouseEvent = null) : void
      {
         this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.nameTxt.text = "";
         this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.visible = false;
      }
      
      public function closeCrewManagement(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.managementMc.gotoAndStop("idle");
      }
      
      private function openIncreaseMember(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.addMemberMc.gotoAndStop("show");
         var _loc2_:* = Math.min(Math.max(this.MAX_TOTAL_MEMBERS - this.crewData.max_members,0),10);
         var _loc3_:* = this.crewData.max_members + _loc2_;
         var _loc4_:* = _loc3_ * 10;
         this.panelMC.panelMc.addMemberMc.panelMc.txt_MemberSlotUpgrade.text = _loc3_;
         this.panelMC.panelMc.addMemberMc.panelMc.txt_TokenRequired.text = _loc4_;
         this.panelMC.panelMc.addMemberMc.panelMc.txt_YourToken.text = this.crewData.tokens;
         this.eventHandler.addListener(this.panelMC.panelMc.addMemberMc.panelMc.closeBtn,MouseEvent.CLICK,this.closeIncreaseMember);
         this.eventHandler.addListener(this.panelMC.panelMc.addMemberMc.panelMc.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.panelMc.addMemberMc.panelMc.btn_BuyMemberSlot,MouseEvent.CLICK,this.onIncreaseMember);
      }
      
      private function onIncreaseMember(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.increaseMaxMembers(this.onIncreasedMember);
      }
      
      private function onIncreasedMember(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("unknown error");
            return;
         }
         if(param1 != null && param1.hasOwnProperty("max_members"))
         {
            this.main.giveMessage("You\'ve successfuly upgrade max member to " + param1.max_members);
            this.refreshData();
         }
      }
      
      private function closeIncreaseMember(param1:MouseEvent) : void
      {
         this.eventHandler.removeListener(this.panelMC.panelMc.addMemberMc.panelMc.closeBtn,MouseEvent.CLICK,this.closeIncreaseMember);
         this.eventHandler.removeListener(this.panelMC.panelMc.addMemberMc.panelMc.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.removeListener(this.panelMC.panelMc.addMemberMc.panelMc.btn_BuyMemberSlot,MouseEvent.CLICK,this.onIncreaseMember);
         this.panelMC.panelMc.addMemberMc.gotoAndStop("idle");
      }
      
      private function openDonate(param1:MouseEvent) : void
      {
         this.selectedDonation = param1.currentTarget.name == "donateGoldBtn" ? "gold" : "token";
         if(this.selectedDonation == "gold")
         {
            this.panelMC.panelMc.donateMc.gotoAndStop("show");
            this.panelMC.panelMc.donateMc.panelMc.donateGoldTxt.restrict = "0-9";
            this.panelMC.panelMc.donateMc.panelMc.clanGoldTxt.text = this.crewData.golds;
            this.panelMC.panelMc.donateMc.panelMc.goldTxt.text = Character.character_gold;
            this.eventHandler.addListener(this.panelMC.panelMc.donateMc.panelMc.closeBtn,MouseEvent.CLICK,this.closeDonation);
            this.eventHandler.addListener(this.panelMC.panelMc.donateMc.panelMc.donateBtn,MouseEvent.CLICK,this.onDonate);
         }
         else
         {
            this.panelMC.panelMc.donateTokenMc.gotoAndStop("show");
            this.panelMC.panelMc.donateTokenMc.panelMc.donateGoldTxt.restrict = "0-9";
            this.panelMC.panelMc.donateTokenMc.panelMc.clanGoldTxt.text = this.crewData.tokens;
            this.panelMC.panelMc.donateTokenMc.panelMc.goldTxt.text = Character.account_tokens;
            this.eventHandler.addListener(this.panelMC.panelMc.donateTokenMc.panelMc.closeBtn,MouseEvent.CLICK,this.closeDonation);
            this.eventHandler.addListener(this.panelMC.panelMc.donateTokenMc.panelMc.donateBtn,MouseEvent.CLICK,this.onDonate);
         }
      }
      
      private function onDonate(param1:MouseEvent) : void
      {
         this.totalDonation = this.selectedDonation == "gold" ? Number(int(this.panelMC.panelMc.donateMc.panelMc.donateGoldTxt.text)) : Number(int(this.panelMC.panelMc.donateTokenMc.panelMc.donateGoldTxt.text));
         if(this.totalDonation < 1)
         {
            this.main.getNotice("Amount need to be more than 0");
            return;
         }
         this.main.loading(true);
         if(this.selectedDonation == "gold")
         {
            Crew.instance.donateGolds(this.totalDonation,this.onDonated);
         }
         else
         {
            Crew.instance.donateTokens(this.totalDonation,this.onDonated);
         }
      }
      
      private function onDonated(param1:*, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("unknown error");
            return;
         }
         if(param1 !== null && (param1.hasOwnProperty("t") || param1.hasOwnProperty("g")))
         {
            if(this.selectedDonation == "gold")
            {
               Character.character_gold = String(Number(param1.g));
               this.main.getNotice("Golds has been donated!");
            }
            else
            {
               Character.account_tokens = int(Number(param1.t));
               this.main.getNotice("Tokens has been donated!");
            }
            this.main.HUD.setBasicData();
         }
         this.closeDonation(null);
         this.refreshData();
      }
      
      private function closeDonation(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.donateMc.gotoAndStop("idle");
         this.panelMC.panelMc.donateTokenMc.gotoAndStop("idle");
      }
      
      private function initAnnouncement() : void
      {
         this.currentTab = "announcement";
         this.panelMC.gotoAndStop("announcement");
         this.initTab();
         this.panelMC.panelMc.announcementBtn.gotoAndStop("select");
         this.panelMC.panelMc.saveBtn.visible = false;
         this.panelMC.panelMc.announcementTxt.text = this.crewData.announcement;
         this.panelMC.panelMc.announcementTxt.type = TextFieldType.DYNAMIC;
         this.panelMC.panelMc.announcementTxt.selectable = true;
         if(this.crewData.master_id == Character.char_id || this.crewData.elder_id == Character.char_id)
         {
            this.panelMC.panelMc.announcementTxt.type = TextFieldType.INPUT;
            this.panelMC.panelMc.saveBtn.visible = true;
            this.eventHandler.addListener(this.panelMC.panelMc.saveBtn,MouseEvent.CLICK,this.saveAnnouncementReq);
         }
      }
      
      private function saveAnnouncementReq(param1:MouseEvent) : void
      {
         this.main.loading(true);
         Crew.instance.updateAnnouncement(this.panelMC.panelMc.announcementTxt.text,this.onUpdatedAnnouncement);
      }
      
      private function onUpdatedAnnouncement(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("unknown error");
         }
         this.crewData.announcement = this.panelMC.panelMc.announcementTxt.text;
         this.panelMC.panelMc.announcementTxt.text = !!this.crewData.announcement ? this.crewData.announcement : "";
         this.main.showMessage("Announcement has been updated!");
         this.refreshData();
      }
      
      private function initMember() : void
      {
         this.currentTab = "member";
         this.panelMC.gotoAndStop("member_list");
         this.initTab();
         this.panelMC.panelMc.memberListBtn.gotoAndStop("select");
         this.panelMC.panelMc.recruitMc.gotoAndStop("idle");
         this.main.loading(true);
         Crew.instance.getMembersInfo(this.initMemberData);
      }
      
      private function initMemberData(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("members"))
         {
            this.crewMembers = param1.members;
            this.panelMC.panelMc.totalMemberTxt.text = this.crewMembers.length + "/" + this.crewData.max_members;
            this.panelMC.panelMc.pageTxt.text = this.currentPageMember + " / " + this.totalPageMember;
            this.eventHandler.addListener(this.panelMC.panelMc.prevPageBtn,MouseEvent.CLICK,this.changePageMember);
            this.eventHandler.addListener(this.panelMC.panelMc.nextPageBtn,MouseEvent.CLICK,this.changePageMember);
            this.eventHandler.addListener(this.panelMC.panelMc.removeBtn,MouseEvent.CLICK,this.kickMemberConfirmation);
            this.eventHandler.addListener(this.panelMC.panelMc.promoteBtn,MouseEvent.CLICK,this.promoteMemberConfirmation);
            this.eventHandler.addListener(this.panelMC.panelMc.promoteElderBtn,MouseEvent.CLICK,this.promoteElderConfirmation);
            if(this.crewData.master_id != Character.char_id && this.crewData.elder_id != Character.char_id)
            {
               this.panelMC.panelMc.removeBtn.visible = false;
            }
            if(this.crewData.master_id != Character.char_id)
            {
               this.panelMC.panelMc.promoteBtn.visible = false;
               this.panelMC.panelMc.promoteElderBtn.visible = false;
            }
            this.currentPageMember = 1;
            this.totalPageMember = Math.max(Math.ceil(this.crewMembers.length / 12),1);
            this.renderCrewMember();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      private function renderCrewMember() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 12)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageMember - 1) * 12);
            this.panelMC.panelMc["member_" + _loc1_].visible = false;
            this.panelMC.panelMc["member_" + _loc1_].gotoAndStop("idle");
            if(this.crewMembers.length > _loc2_)
            {
               this.panelMC.panelMc["member_" + _loc1_].visible = true;
               this.panelMC.panelMc["member_" + _loc1_].nameTxt.htmlText = Character.colorifyText(this.crewMembers[_loc2_].char_id,this.crewMembers[_loc2_].name,this.panelMC.panelMc["member_" + _loc1_].nameTxt);
               this.panelMC.panelMc["member_" + _loc1_].role.gotoAndStop(this.crewMembers[_loc2_].role);
               this.panelMC.panelMc["member_" + _loc1_].staminaTxt.text = this.crewMembers[_loc2_].stamina;
               this.panelMC.panelMc["member_" + _loc1_].damageTxt.text = this.crewMembers[_loc2_].damage;
               this.panelMC.panelMc["member_" + _loc1_].killedTxt.text = this.crewMembers[_loc2_].boss_kill;
               this.panelMC.panelMc["member_" + _loc1_].donationGoldTxt.text = this.crewMembers[_loc2_].gold_donated;
               this.panelMC.panelMc["member_" + _loc1_].donationTokenTxt.text = this.crewMembers[_loc2_].token_donated;
               this.panelMC.panelMc["member_" + _loc1_].buttonMode = true;
               this.panelMC.panelMc["member_" + _loc1_].metaData = {"charId":this.crewMembers[_loc2_].char_id};
               this.eventHandler.addListener(this.panelMC.panelMc["member_" + _loc1_],MouseEvent.CLICK,this.selectCrewMember);
            }
            _loc1_++;
         }
         this.totalPageMember = Math.max(Math.ceil(this.crewMembers.length / 12),1);
         this.updatePageText();
      }
      
      private function selectCrewMember(param1:MouseEvent) : void
      {
         this.resetSelectedCrewMember();
         var _loc2_:int = param1.currentTarget.name.replace("member_","");
         this.panelMC.panelMc["member_" + _loc2_].gotoAndStop("selected");
         this.selectedMemberId = param1.currentTarget.metaData.charId;
      }
      
      private function kickMemberConfirmation(param1:MouseEvent) : void
      {
         if(this.selectedMemberId < 1)
         {
            this.main.getNotice("Please select a member to kick");
            return;
         }
         this.confirmation = null;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to kick this member from your crew?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onRemoveMember);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function onRemoveMember(param1:MouseEvent) : void
      {
         this.closeConfirmation(null);
         this.main.loading(true);
         Crew.instance.kickMember(this.selectedMemberId,this.onRemoveMemberRes);
      }
      
      private function onRemoveMemberRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         this.main.showMessage("Member has been kicked");
         this.refreshData();
      }
      
      private function promoteMemberConfirmation(param1:MouseEvent) : void
      {
         if(this.selectedMemberId < 1)
         {
            this.main.getNotice("Please select a member to promote");
            return;
         }
         this.confirmation = null;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to promote this member as Crew Master?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onPromoteMember);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function onPromoteMember(param1:MouseEvent) : void
      {
         this.closeConfirmation(null);
         this.main.loading(true);
         Crew.instance.changeCrewMaster(this.selectedMemberId,this.onPromoteMemberRes);
      }
      
      private function onPromoteMemberRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         this.main.getNotice("Member has been promoted to Crew Master");
         this.crewVillage.destroy();
         this.destroy();
      }
      
      private function promoteElderConfirmation(param1:MouseEvent) : void
      {
         if(this.selectedMemberId < 1)
         {
            this.main.getNotice("Please select a member to promote to elder");
            return;
         }
         this.confirmation = null;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to promote this member as Crew Elder?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onPromoteElder);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function onPromoteElder(param1:MouseEvent) : void
      {
         this.closeConfirmation(null);
         this.main.loading(true);
         Crew.instance.promoteElder(this.selectedMemberId,this.onPromoteElderRes);
      }
      
      private function onPromoteElderRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         this.main.getNotice("Member has been promoted to Crew Elder");
         this.closePanel(null);
      }
      
      private function resetSelectedCrewMember() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < 12)
         {
            this.panelMC.panelMc["member_" + _loc1_].gotoAndStop("idle");
            this.selectedMemberId = -1;
            _loc1_++;
         }
      }
      
      private function changePageMember(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "nextPageBtn":
               if(this.totalPageMember > this.currentPageMember)
               {
                  ++this.currentPageMember;
                  this.renderCrewMember();
               }
               break;
            case "prevPageBtn":
               if(this.currentPageMember > 1)
               {
                  --this.currentPageMember;
                  this.renderCrewMember();
               }
         }
         this.updatePageText();
      }
      
      private function updatePageText() : void
      {
         this.panelMC.panelMc.pageTxt.text = this.currentPageMember + "/" + this.totalPageMember;
      }
      
      private function initHistory() : void
      {
         this.currentTab = "history";
         this.panelMC.gotoAndStop("history");
         this.initTab();
         this.panelMC.panelMc.logBtn.gotoAndStop("select");
         this.initHistoryScrollPane();
         Crew.instance.getHistory(this.onGetLatestHistory);
      }
      
      private function initHistoryScrollPane() : void
      {
         if(this.historyScrollPane == null)
         {
            this.historyScrollPane = new HistoryScrollPane();
         }
         var _loc1_:MovieClip = this.panelMC.panelMc.scrollPaneHolder;
         var _loc2_:* = this.historyScrollPane.getScrollPane();
         if(_loc2_.parent != _loc1_)
         {
            if(_loc2_.parent != null)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
            _loc1_.addChild(_loc2_);
         }
         this.panelMC.panelMc.historyTxt.visible = false;
      }
      
      private function crewHistoryRaw(param1:*) : String
      {
         if(param1 == null)
         {
            return "";
         }
         if(param1 is Array)
         {
            return (param1 as Array).join("<br/>");
         }
         return String(param1);
      }
      
      private function onGetLatestHistory(param1:*, param2:* = null) : void
      {
         this.setHistoryInfo(param1 != null && param1.hasOwnProperty("histories") ? param1.histories : "");
      }
      
      private function setHistoryInfo(param1:*) : void
      {
         if(!param1)
         {
            return;
         }
         this.initHistoryScrollPane();
         this.historyScrollPane.updatePane({
            "history_raw":this.crewHistoryRaw(param1),
            "text_width":708.85,
            "width":730.85,
            "height":394,
            "x":0,
            "y":0,
            "scroll_visible":"auto"
         });
      }
      
      private function firstConfirmationQuitDismiss(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.quitMC.gotoAndStop("show");
         if(this.crewData.master_id == Character.char_id)
         {
            this.panelMC.panelMc.quitMC.titleTxt.text = "Type DISBAND to Confirm";
         }
         else
         {
            this.panelMC.panelMc.quitMC.titleTxt.text = "Type QUIT to Confirm";
         }
         this.panelMC.panelMc.quitMC.warningTxt.text = "Attention:\n- Must Type in Upper Case\n- Can\'t Quit/Disband Crew on Final Day";
         this.eventHandler.addListener(this.panelMC.panelMc.quitMC.btn_close,MouseEvent.CLICK,this.closeQuitConfirm);
         this.eventHandler.addListener(this.panelMC.panelMc.quitMC.btn_confirm,MouseEvent.CLICK,this.quitAMF);
      }
      
      private function quitAMF(param1:MouseEvent) : void
      {
         var _loc2_:String = this.panelMC.panelMc.quitMC.quitTxt.text;
         if(this.crewData.master_id == Character.char_id)
         {
            if(_loc2_ == "DISBAND")
            {
               this.secondQuitConfirm();
            }
            else
            {
               this.main.showMessage("Wrong confirmation text");
            }
         }
         else if(_loc2_ == "QUIT")
         {
            this.secondQuitConfirm();
         }
         else
         {
            this.main.showMessage("Wrong confirmation text");
         }
      }
      
      private function secondQuitConfirm() : void
      {
         this.confirmation = null;
         this.confirmation = new Confirmation();
         if(this.crewData.master_id == Character.char_id)
         {
            this.confirmation.txtMc.txt.text = "Are you sure that you want to disband this crew?";
         }
         this.confirmation.txtMc.txt.text = "Are you sure that you want to quit from your crew?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onQuitAMF);
         this.main.loader.addChild(this.confirmation);
      }
      
      private function onQuitAMF(param1:MouseEvent) : void
      {
         this.closeConfirmation(null);
         this.main.loading(true);
         Crew.instance.quitFromCrew(this.onGetQuitRes);
      }
      
      private function onGetQuitRes(param1:Object, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         Crew.instance.destroy();
         this.crewVillage.destroy();
         this.destroy();
      }
      
      private function closeQuitConfirm(param1:MouseEvent) : void
      {
         this.confirmation = null;
         this.eventHandler.removeListener(this.panelMC.panelMc.quitMC.btn_close,MouseEvent.CLICK,this.closeQuitConfirm);
         this.eventHandler.removeListener(this.panelMC.panelMc.quitMC.btn_confirm,MouseEvent.CLICK,this.quitAMF);
         this.panelMC.panelMc.quitMC.gotoAndStop("idle");
      }
      
      private function closeConfirmation(param1:MouseEvent) : void
      {
         this.eventHandler.removeListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onQuitAMF);
         this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onRemoveMember);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
      }
      
      private function showRewardDamageRank(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.detailMC.gotoAndStop("damageRank");
         var _loc2_:MovieClip = this.panelMC.panelMc.detailMC.panelMC;
         var _loc3_:Array = ["1","2","3","4","5","6-10"];
         var _loc4_:Array = ["lbl_first_prize_1","lbl_secon_1","lbl_third_1","lbl_forth_1","lbl_5th_1","lbl_6th_1"];
         var _loc5_:Array = ["lbl_first_prize_2","lbl_second_2","lbl_third_2","lbl_forth_2","lbl_5th_2","lbl_6th_2"];
         var _loc6_:int = 0;
         while(_loc6_ < 6)
         {
            _loc2_[_loc4_[_loc6_]].text = this.crewVillage.tokenPoolData[_loc3_[_loc6_]].token + "% of token pool";
            _loc2_[_loc5_[_loc6_]].text = Util.formatNumberWithDot(this.crewVillage.tokenPoolData[_loc3_[_loc6_]].merit) + " Merit";
            _loc6_++;
         }
         _loc2_.lbl_date.text = "Total Token Pool: 0 + " + this.crewVillage.tokenPoolData.base;
         Crew.instance.getTokenPool(this.onTokenPoolRes);
         this.eventHandler.addListener(this.panelMC.panelMc.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.addListener(this.panelMC.panelMc.detailMC.panelMC.nextBtn,MouseEvent.CLICK,this.showRewardDamageBonus);
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
            this.panelMC.panelMc.detailMC.panelMC.lbl_date.text = "Total Token Pool: " + param1.t + " + " + this.crewVillage.tokenPoolData.base;
            return;
         }
      }
      
      private function showRewardDamageBonus(param1:MouseEvent) : void
      {
         this.panelMC.panelMc.detailMC.gotoAndStop("damageBonus");
         this.eventHandler.addListener(this.panelMC.panelMc.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.addListener(this.panelMC.panelMc.detailMC.panelMC.prevBtn,MouseEvent.CLICK,this.showRewardDamageRank);
         var _loc2_:int = 0;
         while(_loc2_ < this.crewVillage.rewardData.phase_1.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.panelMc.detailMC.panelMC["IconMc0_" + _loc2_],this.crewVillage.rewardData.phase_1[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.crewVillage.rewardData.phase_2.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.panelMc.detailMC.panelMC["IconMc_" + _loc2_],this.crewVillage.rewardData.phase_2[_loc2_]);
            _loc2_++;
         }
      }
      
      private function closeRewards(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.panelMC.panelMc.detailMC.currentLabel == "damageBonus")
         {
            _loc2_ = 0;
            while(_loc2_ < this.crewVillage.rewardData.phase_1.length)
            {
               GF.removeAllChild(this.panelMC.panelMc.detailMC.panelMC["IconMc0_" + _loc2_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.panelMc.detailMC.panelMC["IconMc0_" + _loc2_].skillIcon.iconHolder);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.crewVillage.rewardData.phase_2.length)
            {
               GF.removeAllChild(this.panelMC.panelMc.detailMC.panelMC["IconMc_" + _loc2_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.panelMc.detailMC.panelMC["IconMc_" + _loc2_].skillIcon.iconHolder);
               _loc2_++;
            }
         }
         this.eventHandler.removeListener(this.panelMC.panelMc.detailMC.panelMC.closeBtn,MouseEvent.CLICK,this.closeRewards);
         this.eventHandler.removeListener(this.panelMC.panelMc.detailMC.panelMC.prevBtn,MouseEvent.CLICK,this.showRewardDamageRank);
         this.eventHandler.removeListener(this.panelMC.panelMc.detailMC.panelMC.nextBtn,MouseEvent.CLICK,this.showRewardDamageBonus);
         this.panelMC.panelMc.detailMC.gotoAndStop("idle");
      }
      
      private function showDamageBonusFaq(param1:MouseEvent) : void
      {
         if(this.crewVillage.damageBonusData.length == 0)
         {
            this.main.showMessage("Coming Soon");
            return;
         }
         this.panelMC.panelMc.detailMC2.gotoAndStop("damageBonus");
         var _loc2_:MovieClip = this.panelMC.panelMc.detailMC2.panelMC;
         var _loc3_:int = 1;
         while(_loc3_ <= this.crewVillage.damageBonusData.length)
         {
            _loc2_["dmg" + _loc3_].text = Util.formatNumberWithDot(this.crewVillage.damageBonusData[_loc3_ - 1].damage);
            _loc2_["lbl_tot" + _loc3_].text = this.crewVillage.damageBonusData[_loc3_ - 1].description;
            _loc3_++;
         }
         this.eventHandler.addListener(this.panelMC.panelMc.detailMC2.panelMC.closeBtn,MouseEvent.CLICK,this.closeDamageBonusFaq);
      }
      
      private function closeDamageBonusFaq(param1:MouseEvent) : void
      {
         this.eventHandler.removeListener(this.panelMC.panelMc.detailMC2.panelMC.closeBtn,MouseEvent.CLICK,this.closeDamageBonusFaq);
         this.panelMC.panelMc.detailMC2.gotoAndStop("idle");
      }
      
      private function changeCategory(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "profileBtn":
               this.initProfile();
               break;
            case "announcementBtn":
               this.initAnnouncement();
               break;
            case "memberListBtn":
               this.initMember();
               break;
            case "logBtn":
               this.initHistory();
         }
      }
      
      private function refreshData() : void
      {
         Crew.instance.getCrewData(this.onRefreshData);
      }
      
      private function onRefreshData(param1:*, param2:* = null) : void
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("crew") && param1.hasOwnProperty("char"))
         {
            Character.crew_data = param1.crew;
            Character.crew_char_data = param1.char;
            this.crewData = param1.crew;
            this.charData = param1.char;
            switch(this.currentTab)
            {
               case "profile":
                  this.initProfile();
                  break;
               case "announcement":
                  this.initAnnouncement();
                  break;
               case "member":
                  this.initMember();
                  break;
               case "history":
                  this.initHistory();
            }
            return;
         }
         if(param2 != null)
         {
            this.main.removeLoadedPanel("Panels.CrewVillage");
            this.main.showMessage("Unable to the refresh data");
            this.destroy();
         }
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openCrewShop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.ClanShop");
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         if(this.crewVillage && this.crewVillage.panelMC)
         {
            this.crewVillage.panelMC.visible = true;
         }
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this.historyScrollPane != null)
         {
            this.historyScrollPane.destroy();
            this.historyScrollPane = null;
         }
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.main = null;
         this.eventHandler = null;
         this.crewVillage = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
      
      private function frame1() : void
      {
         this.panelMC.stop();
      }
      
      private function onInitProfile() : void
      {
         this.panelMC.stop();
         this.initProfile();
      }
      
      private function onInitAnnouncement() : void
      {
         this.panelMC.stop();
      }
      
      private function onInitMember() : void
      {
         this.panelMC.stop();
      }
      
      private function onInitHistory() : void
      {
         this.panelMC.stop();
      }
   }
}
