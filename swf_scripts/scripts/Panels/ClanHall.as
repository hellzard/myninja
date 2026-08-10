package Panels
{
   import Managers.OutfitManager;
   import Popups.ClanDonateGolds;
   import Popups.ClanDonateTokens;
   import Popups.ClanIncreaseMembers;
   import Popups.Confirmation;
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldType;
   import id.ninjasage.Clan;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.features.HistoryScrollPane;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7029")]
   public class ClanHall extends MovieClip
   {
      
      public var clanManagementMC:MovieClip;
      
      public var quitMC:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var announcementMC:MovieClip;
      
      public var btn_announcement:MovieClip;
      
      public var sendOnigiriMC:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_general:MovieClip;
      
      public var btn_history:MovieClip;
      
      public var btn_members:MovieClip;
      
      public var generalMC:MovieClip;
      
      public var historyMC:MovieClip;
      
      public var membersMC:MovieClip;
      
      public var clanLogoHolder:MovieClip;
      
      public var main:*;
      
      public var clan_village:*;
      
      public var clan_data:* = Character.clan_data;
      
      public var char_data:* = Character.clan_char_data;
      
      public var upgrade_info:Array = [];
      
      internal var quit_pop:*;
      
      internal var quit_clan:*;
      
      public var members:Array = [];
      
      public var current_page:int = 1;
      
      public var total_page:int = 1;
      
      public var max_amount:int = 1000;
      
      public var amount:int = 100;
      
      public var price:int = 10;
      
      public var cost:int = 0;
      
      public var tax:int;
      
      public var total:int;
      
      public var selected_member_index:* = -1;
      
      public var eventHandler:* = new EventHandler();
      
      public var confirmation:*;
      
      internal var historyScrollPane:HistoryScrollPane;
      
      public function ClanHall(param1:*, param2:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.getClanStatusReq);
         this.sendOnigiriMC.visible = false;
         this.quitMC.visible = false;
         this.clanLogoHolder.visible = false;
         this.clanManagementMC.visible = false;
         this.main = param1;
         this.clan_village = param2;
         this.addButtonListeners();
         this.hideAllMCs();
         this.addClanLogo();
         this.upgrade_info = [];
         this.upgrade_info.push(["No boosts","+10 Stamina every 30 minutes","+20 Stamina every 30 minutes","+30 Stamina every 30 minutes"]);
         this.upgrade_info.push(["No boosts","+30% maximum HP","+60% maximum HP","+90% maximum HP"]);
         this.upgrade_info.push(["No boosts","+30% maximum CP","+60% maximum CP","+90% maximum CP"]);
         this.upgrade_info.push(["No boosts","+30% damage for all attacks","+60% damage for all attacks","+90% damage for all attacks"]);
         this.displayTab("general");
      }
      
      public function addButtonListeners() : *
      {
         this.resetBtns();
         this.eventHandler.addListener(this.btn_general,MouseEvent.CLICK,this.onGeneralTab);
         this.eventHandler.addListener(this.btn_announcement,MouseEvent.CLICK,this.onAnnouncementTab);
         this.eventHandler.addListener(this.btn_members,MouseEvent.CLICK,this.onMembersTab);
         this.eventHandler.addListener(this.btn_history,MouseEvent.CLICK,this.onHistoryTab);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.getClanStatusReq);
      }
      
      public function closeThis(param1:MouseEvent) : *
      {
         parent.removeChild(this);
      }
      
      public function resetBtns() : *
      {
         this.btn_general.gotoAndStop(2);
         this.btn_announcement.gotoAndStop(2);
         this.btn_members.gotoAndStop(2);
         this.btn_history.gotoAndStop(2);
      }
      
      public function hideAllMCs() : *
      {
         this.generalMC.visible = false;
         this.historyMC.visible = false;
         this.announcementMC.visible = false;
         this.membersMC.visible = false;
      }
      
      public function onGeneralTab(param1:MouseEvent) : *
      {
         this.displayTab("general");
      }
      
      public function onAnnouncementTab(param1:MouseEvent) : *
      {
         this.displayTab("announcement");
      }
      
      public function onMembersTab(param1:MouseEvent) : *
      {
         this.displayTab("members");
      }
      
      public function onHistoryTab(param1:MouseEvent) : *
      {
         this.displayTab("history");
      }
      
      public function displayTab(param1:*) : *
      {
         this.resetBtns();
         this.hideAllMCs();
         switch(param1)
         {
            case "general":
               this.btn_general.gotoAndStop(1);
               this.generalMC.visible = true;
               this.setGeneralInfo();
               break;
            case "announcement":
               this.btn_announcement.gotoAndStop(1);
               this.announcementMC.visible = true;
               this.setAnnouncementInfo();
               break;
            case "members":
               this.btn_members.gotoAndStop(1);
               this.membersMC.visible = true;
               this.getAndSetMembersInfo();
               break;
            case "history":
               this.btn_history.gotoAndStop(1);
               this.fetchLatestHistory();
         }
      }
      
      public function fetchLatestHistory() : *
      {
         Clan.instance.getHistory(this.onGetLatestHistory);
      }
      
      private function initHistoryScrollPane() : void
      {
         if(this.historyScrollPane != null)
         {
            return;
         }
         this.historyScrollPane = new HistoryScrollPane();
         this.historyMC.scrollPaneHolder.addChild(this.historyScrollPane.getScrollPane());
         this.historyMC.historyTxt.visible = false;
         this.historyMC.btn_next.visible = false;
         this.historyMC.btn_prev.visible = false;
      }
      
      public function onGetLatestHistory(param1:*, param2:* = null) : *
      {
         this.historyMC.visible = true;
         this.setHistoryInfo(param1 != null && Boolean(param1.hasOwnProperty("histories")) ? param1.histories : "");
      }
      
      public function setHistoryInfo(param1:*) : *
      {
         this.clanLogoHolder.visible = false;
         if(!param1)
         {
            return;
         }
         this.initHistoryScrollPane();
         this.historyScrollPane.updatePane({
            "history_raw":(param1 ? String(param1) : ""),
            "text_width":742.85,
            "width":765.85,
            "height":394,
            "x":0,
            "y":0,
            "scroll_visible":"auto"
         });
         this.eventHandler.addListener(this.historyMC.btn_next,MouseEvent.CLICK,this.onLatestInfo);
         this.eventHandler.addListener(this.historyMC.btn_prev,MouseEvent.CLICK,this.onOldestInfo);
      }
      
      public function onOldestInfo(param1:MouseEvent) : *
      {
         if(this.historyScrollPane == null)
         {
            return;
         }
         var _loc2_:* = this.historyScrollPane.getScrollPane();
         _loc2_.verticalScrollPosition = Math.max(0,_loc2_.verticalScrollPosition - 10);
      }
      
      public function onLatestInfo(param1:MouseEvent) : *
      {
         if(this.historyScrollPane == null)
         {
            return;
         }
         var _loc2_:* = this.historyScrollPane.getScrollPane();
         _loc2_.verticalScrollPosition += 10;
      }
      
      public function setGeneralInfo() : *
      {
         this.clanLogoHolder.visible = true;
         this.generalMC.clan_name.text = this.clan_data.name;
         this.generalMC.clan_id.text = this.clan_data.id > 0 ? this.clan_data.id : "-R-";
         this.generalMC.clan_master.htmlText = Character.colorifyText(this.clan_data.master_id,this.clan_data.master_name,this.generalMC.clan_master);
         if(this.clan_data.elder_name == null)
         {
            this.generalMC.clan_elder.htmlText = "-";
         }
         else
         {
            this.generalMC.clan_elder.htmlText = Character.colorifyText(this.clan_data.elder_id,this.clan_data.elder_name,this.generalMC.clan_elder);
         }
         this.generalMC.clan_tokens.text = this.clan_data.tokens;
         this.generalMC.clan_golds.text = this.clan_data.golds;
         this.generalMC.ramenmc.gotoAndStop(this.clan_data.ramen + 1);
         this.generalMC.ramenlvl.text = "Level " + this.clan_data.ramen;
         this.generalMC.ramendesc.text = this.upgrade_info[0][this.clan_data.ramen];
         this.generalMC.templemc.gotoAndStop(this.clan_data.temple + 1);
         this.generalMC.templelvl.text = "Level " + this.clan_data.temple;
         this.generalMC.templedesc.text = this.upgrade_info[2][this.clan_data.temple];
         this.generalMC.hotspringmc.gotoAndStop(this.clan_data.hot_spring + 1);
         this.generalMC.hotspringlvl.text = "Level " + this.clan_data.hot_spring;
         this.generalMC.hotspringdesc.text = this.upgrade_info[1][this.clan_data.hot_spring];
         this.generalMC.traininghallmc.gotoAndStop(this.clan_data.training_hall + 1);
         this.generalMC.traininghalllvl.text = "Level " + this.clan_data.training_hall;
         this.generalMC.traininghalldesc.text = this.upgrade_info[3][this.clan_data.training_hall];
         if(this.clan_data.master_id != Character.char_id && this.clan_data.elder_id != Character.char_id)
         {
            this.generalMC.btn_invite.visible = false;
            this.generalMC.btn_manage.visible = false;
         }
         this.eventHandler.addListener(this.generalMC.btn_invite,MouseEvent.CLICK,this.inviteMembers);
         this.eventHandler.addListener(this.generalMC.btn_quit,MouseEvent.CLICK,this.quitClanConfirm);
         this.eventHandler.addListener(this.generalMC.btn_gold,MouseEvent.CLICK,this.donateGold);
         this.eventHandler.addListener(this.generalMC.btn_token,MouseEvent.CLICK,this.doneteTokens);
         this.eventHandler.addListener(this.generalMC.btn_manage,MouseEvent.CLICK,this.clanManagement);
      }
      
      public function donateGold(param1:MouseEvent) : *
      {
         var _loc2_:* = new ClanDonateGolds(this.main,this.clan_village,this);
         addChild(_loc2_);
      }
      
      public function doneteTokens(param1:MouseEvent) : *
      {
         var _loc2_:* = new ClanDonateTokens(this.main,this.clan_village,this);
         addChild(_loc2_);
      }
      
      public function increaseMembers(param1:MouseEvent) : *
      {
         var _loc2_:* = new ClanIncreaseMembers(this.main,this.clan_village,this);
         addChild(_loc2_);
      }
      
      public function inviteMembers(param1:MouseEvent) : *
      {
         var _loc2_:* = new ClanMemberRequest(this.main,this.clan_village,this);
         addChild(_loc2_);
      }
      
      public function clanManagement(param1:MouseEvent) : *
      {
         this.clanManagementMC.visible = true;
         this.clanManagementMC.clanRenameMC.visible = false;
         if(this.clan_data.master_id != Character.char_id)
         {
            this.clanManagementMC.btn_renameClan.visible = false;
            this.clanManagementMC.btn_swapMaster.visible = false;
         }
         this.eventHandler.addListener(this.clanManagementMC.btn_increaseMember,MouseEvent.CLICK,this.increaseMembers);
         this.eventHandler.addListener(this.clanManagementMC.btn_changeBanner,MouseEvent.CLICK,this.changeBanner);
         this.eventHandler.addListener(this.clanManagementMC.btn_renameClan,MouseEvent.CLICK,this.renameClan);
         this.eventHandler.addListener(this.clanManagementMC.btn_swapMaster,MouseEvent.CLICK,this.swapMasterConfirmation);
         this.eventHandler.addListener(this.clanManagementMC.btn_close,MouseEvent.CLICK,this.closeManagement);
      }
      
      public function changeBanner(param1:MouseEvent) : *
      {
         navigateToURL(new URLRequest("http://127.0.0.1:800/player/clan/" + this.clan_data.id + "/banner"));
      }
      
      public function renameClan(param1:MouseEvent) : *
      {
         this.clanManagementMC.clanRenameMC.visible = true;
         this.clanManagementMC.clanRenameMC.warningTxt.text = "Attention:\n- Rename Clan Cost 3000 Tokens\n- Rename Clan Will Cost Clan Tokens\n- 30 Days Cooldown After Rename\n- Clan Rename is Closed 7 Days Before Final Day";
         this.eventHandler.addListener(this.clanManagementMC.clanRenameMC.btn_close,MouseEvent.CLICK,this.closeClanRename);
         this.eventHandler.addListener(this.clanManagementMC.clanRenameMC.btn_confirm,MouseEvent.CLICK,this.clanRenameConfirmation);
      }
      
      public function clanRenameConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to change your clan name to " + this.clanManagementMC.clanRenameMC.nameTxt.text + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onClanRename);
         addChild(this.confirmation);
      }
      
      public function onClanRename(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.loading(true);
         Clan.instance.renameClan(this.clanManagementMC.clanRenameMC.nameTxt.text,this.onClanRenameRes);
      }
      
      public function onClanRenameRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1 == "ok")
         {
            this.main.showMessage("Clan Name Successfully Renamed!");
            this.closeClanRename();
            this.displayTab("general");
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
            return;
         }
      }
      
      public function closeClanRename(param1:MouseEvent = null) : *
      {
         this.clanManagementMC.clanRenameMC.nameTxt.text = "";
         this.clanManagementMC.visible = false;
         this.confirmation = null;
      }
      
      public function swapMasterConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         if(this.clan_data.elder_name == null)
         {
            this.main.showMessage("Your clan don\'t have elder");
            return;
         }
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to swap master and elder?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onSwapMaster);
         addChild(this.confirmation);
      }
      
      public function onSwapMaster(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.loading(true);
         Clan.instance.swapMaster(this.onSwapMasterRes);
      }
      
      public function onSwapMasterRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         this.refreshData();
         this.main.showMessage("Elder Successfully Promoted to Master!");
         this.closeManagement();
         this.displayTab("general");
      }
      
      public function closeManagement(param1:MouseEvent = null) : *
      {
         this.clanManagementMC.visible = false;
         this.confirmation = null;
      }
      
      public function quitClanConfirm(param1:MouseEvent) : *
      {
         this.quitMC.visible = true;
         if(this.clan_data.master_id == Character.char_id && this.clan_data.elder_id == null)
         {
            this.quitMC.titleTxt.text = "Type DISBAND to Confirm";
         }
         else
         {
            this.quitMC.titleTxt.text = "Type QUIT to Confirm";
         }
         this.quitMC.warningTxt.text = "Attention:\n- Must Type in Upper Case\n- Can\'t Quit/Disband Clan on Final Day";
         this.eventHandler.addListener(this.quitMC.btn_close,MouseEvent.CLICK,this.closeQuitConfirm,false,0,true);
         this.eventHandler.addListener(this.quitMC.btn_confirm,MouseEvent.CLICK,this.quitAMF,false,0,true);
      }
      
      public function closeQuitConfirm(param1:MouseEvent) : *
      {
         this.quitMC.visible = false;
      }
      
      public function quitAMF(param1:MouseEvent) : *
      {
         var _loc2_:* = this.quitMC.quitTxt.text;
         if(this.clan_data.master_id == Character.char_id && this.clan_data.elder_id == null)
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
      
      public function secondQuitConfirm() : *
      {
         this.quit_clan = new Confirmation();
         if(this.clan_data.master_id == Character.char_id && this.clan_data.elder_id == null)
         {
            this.quit_clan.txtMc.txt.text = "Are you sure that you want to disband this clan?";
         }
         this.quit_clan.txtMc.txt.text = "Are you sure that you want to quit from your clan?";
         this.eventHandler.addListener(this.quit_clan.btn_close,MouseEvent.CLICK,this.onRemoveQuitClan);
         this.eventHandler.addListener(this.quit_clan.btn_confirm,MouseEvent.CLICK,this.onQuitAMF,false,0,true);
         addChild(this.quit_clan);
      }
      
      public function onRemoveQuitClan(param1:* = null) : *
      {
         if(this.quit_clan)
         {
            removeChild(this.quit_clan);
         }
         this.quit_clan = null;
      }
      
      public function onQuitAMF(param1:MouseEvent) : *
      {
         this.onRemoveQuitClan();
         this.main.loading(true);
         Clan.instance.quitFromClan(this.onGetQuitRes);
      }
      
      public function onGetQuitRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         OutfitManager.removeChildsFromMovieClips(this.main.loader);
         this.main.removeLoadedPanel("Panels.ClanVillage");
         this.main.loadVillageAndHUD();
         this.destroy();
      }
      
      public function setAnnouncementInfo() : *
      {
         this.clanLogoHolder.visible = false;
         this.announcementMC.announcementTxt.text = this.clan_data.announcement ? this.clan_data.announcement : "";
         this.announcementMC.btn_save.visible = false;
         this.announcementMC.btn_publish.visible = false;
         this.announcementMC.announcementTxt.selectable = false;
         this.announcementMC.announcementTxt.type = TextFieldType.DYNAMIC;
         if(this.clan_data.master_id == Character.char_id || this.clan_data.elder_id == Character.char_id)
         {
            this.announcementMC.announcementTxt.selectable = true;
            this.announcementMC.announcementTxt.type = TextFieldType.INPUT;
            this.announcementMC.btn_save.visible = true;
            this.announcementMC.btn_publish.visible = true;
            this.eventHandler.addListener(this.announcementMC.btn_save,MouseEvent.CLICK,this.saveAnnouncementReq);
            this.eventHandler.addListener(this.announcementMC.btn_publish,MouseEvent.CLICK,this.publishAnnouncement);
         }
      }
      
      public function saveAnnouncementReq(param1:MouseEvent) : *
      {
         this.main.loading(true);
         Clan.instance.updateAnnouncement(this.announcementMC.announcementTxt.text,this.onUpdatedAnnouncement);
      }
      
      public function onUpdatedAnnouncement(param1:Object, param2:* = null) : *
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
         if(this.clan_village != null)
         {
            this.clan_data.announcement = this.announcementMC.announcementTxt.text;
            this.announcementMC.announcementTxt.text = this.clan_data.announcement ? this.clan_data.announcement : "";
            this.main.getNotice("Announcement has been updated!");
            this.refreshData();
         }
      }
      
      public function publishAnnouncement(param1:MouseEvent) : *
      {
         this.main.loading(true);
         Clan.instance.publishAnnouncement(this.onPublishedAnnouncement);
      }
      
      public function onPublishedAnnouncement(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 == "ok")
         {
            this.main.showMessage("The announcement has been published to your members mailbox");
            return;
         }
         if(param2 != null)
         {
            this.main.getNotice("Unable to publish the announcement. Please try again later");
         }
      }
      
      public function getAndSetMembersInfo() : *
      {
         this.main.loading(true);
         this.clanLogoHolder.visible = false;
         Clan.instance.getMembersInfo(this.showMembersInfo);
      }
      
      public function showMembersInfo(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("members"))
         {
            this.members = param1.members;
            this.current_page = 1;
            this.total_page = Math.max(Math.ceil(this.members.length / 12),1);
            this.displayMembers();
            this.membersMC.txt_total_members.text = this.members.length;
            this.membersMC.txt_page.text = this.current_page + " / " + this.total_page;
            this.eventHandler.addListener(this.membersMC.btn_next,MouseEvent.CLICK,this.changePage);
            this.eventHandler.addListener(this.membersMC.btn_prev,MouseEvent.CLICK,this.changePage);
            if(this.clan_data.master_id != Character.char_id && this.clan_data.elder_id != Character.char_id)
            {
               this.membersMC.btn_remove.visible = false;
               this.membersMC.btn_promote.visible = false;
               this.membersMC.btn_send.visible = false;
            }
            this.membersMC.btn_profile.visible = false;
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      public function updatePageText() : *
      {
         this.membersMC.txt_page.text = this.current_page + " / " + this.total_page;
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_page > this.current_page)
               {
                  ++this.current_page;
                  this.displayMembers();
               }
               break;
            case "btn_prev":
               if(this.current_page > 1)
               {
                  --this.current_page;
                  this.displayMembers();
               }
         }
         this.updatePageText();
      }
      
      public function displayMembers() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < 12)
         {
            _loc1_ = _loc2_ + (this.current_page - 1) * 12;
            if(this.members.length > _loc1_)
            {
               this.membersMC["member_" + _loc2_].gotoAndStop(1);
               this.membersMC["member_" + _loc2_].visible = true;
               if(this.members[_loc1_].char_id == Character.char_id && Boolean(this.membersMC["member_" + _loc2_].hasEventListener(MouseEvent.CLICK)))
               {
                  this.membersMC["member_" + _loc2_].removeEventListener(MouseEvent.CLICK,this.selectMember);
               }
               this.eventHandler.addListener(this.membersMC["member_" + _loc2_],MouseEvent.CLICK,this.selectMember);
               this.membersMC["member_" + _loc2_].member_name.htmlText = Character.colorifyText(this.members[_loc1_].char_id,this.members[_loc1_].name,this.membersMC["member_" + _loc2_].member_name);
               this.membersMC["member_" + _loc2_].member_level.text = this.members[_loc1_].level;
               this.membersMC["member_" + _loc2_].member_stamina.text = this.members[_loc1_].stamina;
               this.membersMC["member_" + _loc2_].member_reputation.text = this.members[_loc1_].reputation;
               this.membersMC["member_" + _loc2_].member_gold_donated.text = this.members[_loc1_].gold_donated;
               this.membersMC["member_" + _loc2_].member_token_donated.text = this.members[_loc1_].token_donated;
            }
            else
            {
               this.membersMC["member_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      public function resetOtherMembersMc() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 12)
         {
            this.membersMC["member_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      public function selectMember(param1:MouseEvent) : *
      {
         this.resetOtherMembersMc();
         this.membersMC.btn_profile.visible = true;
         var _loc2_:* = int(param1.currentTarget.name.replace("member_",""));
         param1.currentTarget.gotoAndStop(2);
         this.selected_member_index = _loc2_ + (this.current_page - 1) * 12;
         if(!this.membersMC.btn_remove.hasEventListener(MouseEvent.CLICK))
         {
            if(this.clan_data.master_id == Character.char_id || this.clan_data.elder_id == Character.char_id)
            {
               this.eventHandler.addListener(this.membersMC.btn_remove,MouseEvent.CLICK,this.removeMember);
            }
         }
         if(!this.membersMC.btn_promote.hasEventListener(MouseEvent.CLICK))
         {
            if(this.clan_data.master_id == Character.char_id || this.clan_data.elder_id == Character.char_id)
            {
               this.eventHandler.addListener(this.membersMC.btn_promote,MouseEvent.CLICK,this.onPromoteElder);
            }
         }
         if(!this.membersMC.btn_send.hasEventListener(MouseEvent.CLICK))
         {
            if(this.clan_data.master_id == Character.char_id || this.clan_data.elder_id == Character.char_id)
            {
               this.eventHandler.addListener(this.membersMC.btn_send,MouseEvent.CLICK,this.getOnigiriLimit);
            }
         }
         if(!this.membersMC.btn_profile.hasEventListener(MouseEvent.CLICK))
         {
            this.eventHandler.addListener(this.membersMC.btn_profile,MouseEvent.CLICK,this.checkProfile);
         }
      }
      
      public function checkProfile(param1:MouseEvent) : *
      {
         this.main.openFriendProfile(this.members[this.selected_member_index].char_id,true);
      }
      
      public function getOnigiriLimit(param1:MouseEvent) : *
      {
         this.main.loading(true);
         Clan.instance.getOnigiriInfo(this.members[this.selected_member_index].char_id,this.openOnigiri);
      }
      
      public function openOnigiri(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 == null && param2 != null)
         {
            this.main.getError("");
            return;
         }
         if(param1 != null && param1.hasOwnProperty("info") && param1.hasOwnProperty("onigiri"))
         {
            this.sendOnigiriMC.visible = true;
            this.sendOnigiriMC.member_name.htmlText = Character.colorifyText(this.members[this.selected_member_index].char_id,this.members[this.selected_member_index].name,this.sendOnigiriMC.member_name);
            this.sendOnigiriMC.onigiri_limit.text = param1.info;
            this.max_amount = 40000 - int(param1.onigiri);
            this.sendOnigiriMC.char_tokens.text = Character.account_tokens;
            this.eventHandler.addListener(this.sendOnigiriMC.btn_close,MouseEvent.CLICK,this.closeOnigiri);
            this.eventHandler.addListener(this.sendOnigiriMC.btnNext,MouseEvent.CLICK,this.changeAmount);
            this.eventHandler.addListener(this.sendOnigiriMC.btnPrev,MouseEvent.CLICK,this.changeAmount);
            this.cost = this.price * this.amount;
            this.tax = this.cost * 0.1;
            this.total = this.cost + this.tax;
            this.sendOnigiriMC.tax.text = "Price: " + this.cost + " + " + this.tax + " Tax";
            this.sendOnigiriMC.numTxt.text = this.amount;
            this.sendOnigiriMC.tokenCost.text = this.total;
            this.eventHandler.addListener(this.sendOnigiriMC.btn_send,MouseEvent.CLICK,this.sendOnigiri);
         }
      }
      
      internal function changeAmount(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         if(this.amount <= 100 && _loc2_ != "btnNext")
         {
            return;
         }
         if(this.amount == this.max_amount && _loc2_ == "btnNext")
         {
            return;
         }
         if(_loc2_ == "btnNext")
         {
            this.amount += 100;
         }
         else
         {
            this.amount -= 100;
         }
         this.cost = this.price * this.amount;
         this.tax = this.cost * 0.1;
         this.total = this.cost + this.tax;
         this.sendOnigiriMC.tax.text = "Price: " + this.cost + " + " + this.tax + " Tax";
         this.sendOnigiriMC.numTxt.text = this.amount;
         this.sendOnigiriMC.tokenCost.text = this.total;
         this.eventHandler.addListener(this.sendOnigiriMC.btn_send,MouseEvent.CLICK,this.sendOnigiri);
      }
      
      public function sendOnigiri(param1:MouseEvent) : *
      {
         if(Character.account_type == 0 && Character.emblem_duration == -1)
         {
            this.main.giveMessage("Must be Permanent Emblem User!");
         }
         this.main.loading(true);
         Clan.instance.giveOnigiri(this.members[this.selected_member_index].char_id,this.amount,this.onSendOnigiri);
      }
      
      public function onSendOnigiri(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("info"))
         {
            this.main.giveMessage(param1.amount + " Onigiri Successfully Sent!");
            this.sendOnigiriMC.onigiri_limit.text = param1.info;
            Character.account_tokens = int(int(Character.account_tokens) - param1.price);
            this.sendOnigiriMC.char_tokens.text = Character.account_tokens;
            return;
         }
         if(param2 != null)
         {
            this.main.giveMessage("Unknown error");
         }
      }
      
      private function addClanLogo() : *
      {
         var _loc1_:* = undefined;
         if(Character.clan_banner != null)
         {
            _loc1_ = BulkLoader.getLoader("assets");
            _loc1_.add(Character.clan_banner,{"id":"clanBanner"});
            this.eventHandler.addListener(_loc1_,BulkLoader.COMPLETE,this.onClanLogoLoaded);
            _loc1_.start();
            _loc1_ = null;
         }
         else
         {
            this.clanLogoHolder.visible = false;
         }
      }
      
      private function onClanLogoLoaded(param1:*) : *
      {
         BulkLoader.getLoader("assets").removeEventListener(BulkLoader.COMPLETE,this.onClanLogoLoaded);
         this.clanLogoHolder.addChild(BulkLoader.getLoader("assets").getContent("clanBanner",true));
         this.clanLogoHolder.scaleX = 1;
         this.clanLogoHolder.scaleY = 1;
      }
      
      public function removeMember(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         if(this.selected_member_index == -1)
         {
            this.main.getNotice("Select a member first!");
            return;
         }
         this.quit_pop = new Confirmation();
         this.quit_pop.txtMc.txt.text = "Are you sure that you want to remove " + this.members[this.selected_member_index].name + " from your clan?";
         this.eventHandler.addListener(this.quit_pop.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(quit_pop);
         });
         this.eventHandler.addListener(this.quit_pop.btn_confirm,MouseEvent.CLICK,this.onRemoveMember);
         addChild(this.quit_pop);
      }
      
      public function onRemoveMember(param1:MouseEvent) : *
      {
         removeChild(this.quit_pop);
         this.main.loading(true);
         Clan.instance.kickMember(this.members[this.selected_member_index].char_id,this.onRemoveMemberRes);
      }
      
      public function onRemoveMemberRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         Clan.instance.getClanData(this.onGetClanResNew);
      }
      
      internal function getClanStatusReq(param1:MouseEvent) : *
      {
         this.main.loading(true);
         Clan.instance.getSeason(this.onGetClanStatusRes);
      }
      
      public function onGetClanStatusRes(param1:Object, param2:*) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null || param1 == null)
         {
            this.main.getNotice("Clan server is unreachable.\nProbably maintenance.\nPlease try again later");
            return;
         }
         if(Boolean(param1) && param1.hasOwnProperty("timestamp"))
         {
            Character.clan_timestamp = param1.timestamp;
         }
         if(Boolean(param1) && param1.hasOwnProperty("season"))
         {
            Character.clan_season = param1.season;
         }
         this.main.loading(true);
         Clan.instance.getClanData(this.onGetClanResNew);
      }
      
      public function onGetClanResNew(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("clan")) && Boolean(param1.hasOwnProperty("char")))
         {
            Character.clan_data = param1.clan;
            Character.clan_char_data = param1.char;
            if(this.clan_village != null)
            {
               this.clan_village.clan_data = param1.clan;
               this.clan_village.char_data = param1.char;
               this.clan_village.setDisplay();
            }
            this.main.loadPanel("Panels.ClanVillage");
            this.destroy();
            return;
         }
         if(param2 != null)
         {
            this.main.removeLoadedPanel("Panels.ClanVillage");
            this.main.getError("Error");
            this.destroy();
         }
      }
      
      public function onGetClanRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status == 1)
            {
               Character.clan_data = param1.clan_data;
               Character.clan_char_data = param1.char_data;
               this.main.loadPanel("Panels.ClanVillage");
            }
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.destroy();
      }
      
      public function onPromoteElder(param1:MouseEvent) : *
      {
         if(this.selected_member_index == -1)
         {
            this.main.getNotice("Select a member first!");
            return;
         }
         this.main.loading(true);
         Clan.instance.promoteElder(this.members[this.selected_member_index].char_id,this.onPromoteElderRes);
      }
      
      public function onPromoteElderRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError();
            return;
         }
         this.main.giveMessage(this.members[this.selected_member_index].name + " is promoted as elder!");
         this.refreshData();
      }
      
      public function refreshData() : *
      {
         Clan.instance.getClanData(this.onRefreshData);
      }
      
      public function onRefreshData(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("clan")) && Boolean(param1.hasOwnProperty("char")))
         {
            Character.clan_data = param1.clan;
            Character.clan_char_data = param1.char;
            if(this.clan_village != null)
            {
               this.clan_village.clan_data = param1.clan;
               this.clan_village.char_data = param1.char;
               this.clan_village.setDisplay();
            }
            return;
         }
         if(param2 != null)
         {
            this.main.removeLoadedPanel("Panels.ClanVillage");
            this.main.getError("Error");
            this.destroy();
         }
      }
      
      internal function closeOnigiri(param1:MouseEvent) : void
      {
         this.sendOnigiriMC.visible = false;
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         Log.debug(this,"DESTROY");
         if(this.eventHandler == null)
         {
            return;
         }
         if(this.historyScrollPane != null)
         {
            this.historyScrollPane.destroy();
            this.historyScrollPane = null;
         }
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.clan_village = null;
         this.confirmation = null;
         GF.removeAllChild(this);
      }
   }
}

