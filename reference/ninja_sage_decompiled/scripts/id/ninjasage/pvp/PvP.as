package id.ninjasage.pvp
{
   import Managers.AppManager;
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.GameData;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.features.TextScrollPane;
   import id.ninjasage.multiplayer.battle.Battle;
   import id.ninjasage.multiplayer.battle.CharacterManager;
   import id.ninjasage.pvp.battle.PvPBattleManager;
   import skein.socket.io.Socket;
   
   public class PvP extends MovieClip
   {
       
      
      public var activePlayerTxt:TextField;
      
      public var announcementMC:MovieClip;
      
      public var battleHistoryMC:BattleHistory;
      
      public var btn_Leaderboard:SimpleButton;
      
      public var btn_PvpHallOfFame:SimpleButton;
      
      public var btn_PvpLeague:SimpleButton;
      
      public var btn_PvpLeagueShop:SimpleButton;
      
      public var btn_PvpMilestoneRewards:SimpleButton;
      
      public var btn_PvpShop:SimpleButton;
      
      public var btn_battleHistory:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_create:SimpleButton;
      
      public var btn_join:SimpleButton;
      
      public var btn_live:SimpleButton;
      
      public var btn_news:SimpleButton;
      
      public var btn_quick:SimpleButton;
      
      public var btn_refill:SimpleButton;
      
      public var btn_reportBug:SimpleButton;
      
      public var btn_rules:SimpleButton;
      
      public var btn_thropy:MovieClip;
      
      public var char_mc:MovieClip;
      
      public var chatBoxMc:MovieClip;
      
      public var classMC:MovieClip;
      
      public var connectionStatus:MovieClip;
      
      public var connectionStatusTxt:TextField;
      
      public var cpBar:MovieClip;
      
      public var createRoomMC:CreateRoom;
      
      public var element_1:MovieClip;
      
      public var element_2:MovieClip;
      
      public var element_3:MovieClip;
      
      public var emblemMC:MovieClip;
      
      public var energyBar:MovieClip;
      
      public var energyTxt:TextField;
      
      public var getNotice:MovieClip;
      
      public var headMc:MovieClip;
      
      public var hpBar:MovieClip;
      
      public var joinRoomMC:JoinRoom;
      
      public var leagueMC:MovieClip;
      
      public var liveMatchesMC:LiveMatches;
      
      public var matchMakingMC:MovieClip;
      
      public var matchSelectMC:MovieClip;
      
      public var matchTitleTxt:TextField;
      
      public var nameTxt:TextField;
      
      public var noticeMC:MovieClip;
      
      public var pointTxt:TextField;
      
      public var profileTitleTxt:TextField;
      
      public var rankMC:MovieClip;
      
      public var reportBugMC:MovieClip;
      
      public var roomMC:BattleRoom;
      
      public var rulesMC:MovieClip;
      
      public var senjutsuMC:MovieClip;
      
      public var statsMC:MovieClip;
      
      public var statusTitleTxt:TextField;
      
      public var talent_1:MovieClip;
      
      public var talent_2:MovieClip;
      
      public var talent_3:MovieClip;
      
      public var titleMC:MovieClip;
      
      public var trophiesTxt:TextField;
      
      public var txt_cp:TextField;
      
      public var txt_hp:TextField;
      
      public var txt_lvl:TextField;
      
      public var txt_seasonEnd:TextField;
      
      public var main;
      
      public var outfits:Array;
      
      private var eventHandler:EventHandler;
      
      public var response:Object;
      
      private var socket:Socket;
      
      private var lobbyScreen:PvPLobby;
      
      public var roomInfo:Object;
      
      public var character:CharacterManager;
      
      public var loaderSwf:BulkLoader;
      
      public var isMatchingMaking:Boolean = false;
      
      public var autoStartMatch:Boolean = false;
      
      public var missionIDs:Array;
      
      private var disconnectReason:String = "";
      
      public var battleUI:Battle;
      
      private var _reconnectTimer:Timer = null;
      
      public var spectatorMode:Boolean = false;
      
      public var matchMode:String = "casual";
      
      private var escapeKey:EscapeKeyManager;
      
      private const STATUS_TYPE:int = 2;
      
      public var textPane:TextScrollPane;
      
      public function PvP(param1:* = null)
      {
         this.outfits = [];
         this.roomInfo = {};
         this.missionIDs = ["mission_1011","mission_1055","mission_1050","mission_1048","mission_1039","mission_1030"];
         super();
         this.main = AppManager.getInstance().main;
         this.eventHandler = new EventHandler();
         this.escapeKey = new EscapeKeyManager(this);
         this.loaderSwf = this.main.getLoader("pvp");
         this.main.handleVillageHUDVisibility(false);
         this.statsMC.gotoAndStop(this.STATUS_TYPE);
         this.stopUIAnimation();
         this.getCharacterStats();
         this.hidePopups();
         this.initEscapeKey();
         this.initSocket();
         this.initLobby();
         this.initButtons();
      }
      
      private function initEscapeKey() : void
      {
         this.escapeKey.addListener(this,this.closePanel);
         if(this.chatBoxMc && this.chatBoxMc.hasOwnProperty("bg_close"))
         {
            this.escapeKey.addListener(this.chatBoxMc.bg_close,this.lobbyScreenCloseChatBox);
         }
         if(this.roomMC)
         {
            this.escapeKey.addListener(this.roomMC,this.roomMC.closeByEscape);
         }
         if(this.createRoomMC)
         {
            this.escapeKey.addListener(this.createRoomMC,this.createRoomMC.hidePanel);
         }
         if(this.joinRoomMC)
         {
            this.escapeKey.addListener(this.joinRoomMC,this.joinRoomMC.closePanel);
         }
         if(this.liveMatchesMC)
         {
            this.escapeKey.addListener(this.liveMatchesMC,this.liveMatchesMC.closePanel);
         }
         if(this.battleHistoryMC)
         {
            this.escapeKey.addListener(this.battleHistoryMC,this.battleHistoryMC.closePanel);
            if(this.battleHistoryMC.battleDetailMC)
            {
               this.escapeKey.addListener(this.battleHistoryMC.battleDetailMC,this.battleHistoryMC.closeBattleDetail);
            }
         }
         this.escapeKey.addListener(this.matchMakingMC,this.cancelMatchMaking);
         this.escapeKey.addListener(this.matchSelectMC,this.closeMatchSelection);
         this.escapeKey.addListener(this.announcementMC,this.closeAnnouncement);
         this.escapeKey.addListener(this.reportBugMC,this.closeBugReport);
         this.escapeKey.addListener(this.noticeMC,this.closeNotice);
      }
      
      private function lobbyScreenCloseChatBox(param1:MouseEvent = null) : void
      {
         if(this.lobbyScreen)
         {
            this.lobbyScreen.closeChatBox(param1);
         }
      }
      
      public function getCharacterStats() : void
      {
         this.main.loading(false);
         this.main.amf_manager.service("jpwzlvqNru201CF3.TZwl5dICvIpe",[Character.char_id,Character.sessionkey],this.getCharacterStatsRes);
      }
      
      private function getCharacterStatsRes(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.updateEnergy();
            this.initStatsUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function updateEnergy() : void
      {
         this.energyTxt.text = String(this.response.data.energy) + "/100";
         this.energyBar.bar.scaleX = Math.max(Math.min(int(this.response.data.energy) / 100,1),0);
      }
      
      private function initStatsUI() : void
      {
         var _loc1_:int = Math.max(int(this.response.data.played),1);
         this.statsMC.totalMatchesTxt.text = _loc1_;
         this.statsMC.winTxt.text = this.response.data.won;
         this.pointTxt.text = this.response.data.pvp_points;
         this.statsMC.winRateTxt.text = (int(this.response.data.won) / _loc1_ * 100).toFixed(1) + "%";
         if(this.statsMC.currentFrame == 2 && this.statsMC.hasOwnProperty("bar_win_rate_attack"))
         {
            this.statsMC.bar_win_rate_attack.bar.scaleX = Math.max(Math.min(int(this.response.data.won) / _loc1_ * 100,1),0);
         }
         this.trophiesTxt.text = String(this.response.data.trophy || 0);
         this.announcementMC.version_txt.text = String(this.response.data.pvp_version);
         this.announcementMC.txt.htmlText = this.response.data.pvp_news;
         this.txt_seasonEnd.text = this.response.data.season_ends_in;
         this.leagueMC.gotoAndStop(this.response.data.league + 1 || 1);
         NinjaSage.showDynamicTooltip(this.leagueMC,this.response.data.league_name || "");
         if(this.response.data.hasOwnProperty("show_news") && this.response.data.show_news)
         {
            this.showAnnouncement();
         }
         this.createRoomMC.setContext(this);
         this.joinRoomMC.setContext(this);
      }
      
      private function showAnnouncement(param1:MouseEvent = null) : void
      {
         this.announcementMC.visible = true;
         this.announcementMC.scrollBar.enabled = true;
         if(this.announcementMC.txt.textHeight <= this.announcementMC.txt.height / 1.8)
         {
            this.announcementMC.scrollBar.enabled = false;
            this.announcementMC.scrollBar.visible = false;
         }
         this.eventHandler.addListener(this.announcementMC.btn_close,MouseEvent.CLICK,this.closeAnnouncement);
      }
      
      private function closeAnnouncement(param1:MouseEvent) : void
      {
         this.announcementMC.visible = false;
      }
      
      private function openPvpShop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.PvpShop");
      }
      
      private function openPvpLeaderboard(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("PvpLeaderboard","PvpLeaderboard");
      }
      
      private function openPvpHallOfFame(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("PvpHallOfFame","PvpHallOfFame");
      }
      
      private function openPvpLeague(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("PvpLeague","PvpLeague");
      }
      
      private function openPvpLeagueShop(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("PvpLeagueShop","PvpLeagueShop");
      }
      
      private function openPvpMilestoneRewards(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("PvpMilestoneRewards","PvpMilestoneRewards");
      }
      
      private function openBattleHistory(param1:MouseEvent) : void
      {
         this.battleHistoryMC.setContext(this);
         this.battleHistoryMC.activate();
      }
      
      private function initLobby() : void
      {
         this.lobbyScreen = new PvPLobby();
         this.lobbyScreen.setContext(this);
         this.lobbyScreen.activate();
      }
      
      private function initButtons() : void
      {
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_reportBug,MouseEvent.CLICK,this.showReportBug);
         this.eventHandler.addListener(this.btn_rules,MouseEvent.CLICK,this.showRules);
         this.eventHandler.addListener(this.btn_news,MouseEvent.CLICK,this.showAnnouncement);
         this.eventHandler.addListener(this.btn_PvpShop,MouseEvent.CLICK,this.openPvpShop);
         this.eventHandler.addListener(this.btn_Leaderboard,MouseEvent.CLICK,this.openPvpLeaderboard);
         this.eventHandler.addListener(this.btn_PvpHallOfFame,MouseEvent.CLICK,this.openPvpHallOfFame);
         this.eventHandler.addListener(this.btn_PvpLeague,MouseEvent.CLICK,this.openPvpLeague);
         this.eventHandler.addListener(this.btn_PvpLeagueShop,MouseEvent.CLICK,this.openPvpLeagueShop);
         this.eventHandler.addListener(this.btn_PvpMilestoneRewards,MouseEvent.CLICK,this.openPvpMilestoneRewards);
         this.eventHandler.addListener(this.btn_battleHistory,MouseEvent.CLICK,this.openBattleHistory);
         this.eventHandler.addListener(this.btn_live,MouseEvent.CLICK,this.openLiveMatches);
         if(this.chatBoxMc && this.chatBoxMc.hasOwnProperty("clickmask"))
         {
            this.eventHandler.addListener(this.chatBoxMc.clickmask,MouseEvent.CLICK,this.lobbyScreen.showChatBox);
         }
         if(this.chatBoxMc && this.chatBoxMc.hasOwnProperty("bg_close"))
         {
            this.eventHandler.addListener(this.chatBoxMc.bg_close,MouseEvent.CLICK,this.lobbyScreen.closeChatBox);
         }
      }
      
      private function openLiveMatches(param1:MouseEvent) : void
      {
         if(this.liveMatchesMC)
         {
            this.liveMatchesMC.setContext(this);
            this.liveMatchesMC.activate();
         }
      }
      
      private function initSocket() : void
      {
         var _loc1_:PvPSocket = PvPSocket.getInstance();
         _loc1_.connect();
         this.addSocketListener();
      }
      
      private function addSocketListener() : void
      {
         var _loc1_:* = PvPSocket.getInstance();
         this.chatBoxMc.placeholderTxt.htmlText = "Ninja Sage - PvP Chat";
         _loc1_.on(Socket.EVENT_CONNECT,this.onSocketConnect);
         _loc1_.on(Socket.EVENT_DISCONNECT,this.disconnectState);
         _loc1_.on("System.mapIDs",this.onMapIDs);
         _loc1_.on("System.activePlayers",this.onActivePlayers);
         _loc1_.on("Notification.popUp",this.onNotificationPopUp);
         _loc1_.on("Notification.flash",this.onNotificationFlash);
         _loc1_.on("Notification.disconnect",this.onNotificationDisconnect);
         _loc1_.on("Notification.queue",this.onNotificationQueue);
         _loc1_.on("Room.created",this.onRoomCreated);
         _loc1_.on("Room.joinedAsEnemy",this.onRoomJoinedAsEnemy);
         _loc1_.on("Battle.started",this.onBattleStarted);
         _loc1_.on("Battle.stopMatchMaking",this.stopMatchMaking);
         _loc1_.on("Battle.spectator.join.error",this.onSpectatorJoinError);
      }
      
      private function removeSocketListener() : void
      {
         var _loc1_:* = PvPSocket.getInstance();
         _loc1_.off(Socket.EVENT_CONNECT,this.onSocketConnect);
         _loc1_.off(Socket.EVENT_DISCONNECT,this.disconnectState);
         _loc1_.off("System.mapIDs",this.onMapIDs);
         _loc1_.off("System.activePlayers",this.onActivePlayers);
         _loc1_.off("Notification.popUp",this.onNotificationPopUp);
         _loc1_.off("Notification.flash",this.onNotificationFlash);
         _loc1_.off("Notification.disconnect",this.onNotificationDisconnect);
         _loc1_.off("Notification.queue",this.onNotificationQueue);
         _loc1_.off("Room.created",this.onRoomCreated);
         _loc1_.off("Room.joinedAsEnemy",this.onRoomJoinedAsEnemy);
         _loc1_.off("Battle.started",this.onBattleStarted);
         _loc1_.off("Battle.stopMatchMaking",this.stopMatchMaking);
         _loc1_.off("Battle.spectator.join.error",this.onSpectatorJoinError);
      }
      
      private function onSocketConnect() : void
      {
         Log.info(this,"onSocketConnect","Socket connected, clearing reconnect timer");
         if(this.noticeMC && this.noticeMC.visible)
         {
            this.closeNotice();
         }
         this.connectedState();
      }
      
      private function onNotificationFlash(param1:Object) : void
      {
         this.main.showMessage(param1);
      }
      
      public function connectedState() : *
      {
         this.clearReconnectTimer();
         this.disconnectReason = "";
         this.addSocketListener();
         this.lobbyScreen.activate();
         this.connectionStatus.gotoAndStop("true");
         this.connectionStatusTxt.text = "Connected";
         this.closeNotice();
         this.stopMatchMaking();
         this.showCharMC();
         if(this.eventHandler)
         {
            this.eventHandler.addListener(this.matchMakingMC.btnCancel,MouseEvent.CLICK,this.cancelMatchMaking);
            this.eventHandler.addListener(this.btn_quick,MouseEvent.CLICK,this.selectMatches);
            this.eventHandler.addListener(this.btn_create,MouseEvent.CLICK,this.showCreateRoom);
            this.eventHandler.addListener(this.btn_join,MouseEvent.CLICK,this.showJoinRoom);
         }
         this.hidePopups();
      }
      
      public function disconnectState(param1:String = null) : void
      {
         Log.info(this,"disconnectState",param1);
         if(PvPBattleManager.BATTLE)
         {
            this.main.stopAllBgm();
            this.main.startBgm();
            PvPBattleManager.endBattle();
         }
         this.connectionStatusTxt.text = "Disconnected";
         this.connectionStatus.gotoAndStop("false");
         var _loc2_:String = !!this.disconnectReason ? this.disconnectReason : "Disconnected from PvP server";
         this.showNotice(_loc2_,true,true);
         this.lobbyScreen.deactivate();
         this.joinRoomMC.deactivate();
         this.createRoomMC.deactivate();
         this.stopMatchMaking();
         this.hideCharMC();
         if(this.eventHandler)
         {
            this.eventHandler.addListener(this.matchMakingMC.btnCancel,MouseEvent.CLICK,this.cancelMatchMaking);
            this.eventHandler.removeListener(this.btn_quick,MouseEvent.CLICK,this.selectMatches);
            this.eventHandler.removeListener(this.btn_create,MouseEvent.CLICK,this.showCreateRoom);
            this.eventHandler.removeListener(this.btn_join,MouseEvent.CLICK,this.showJoinRoom);
         }
      }
      
      public function selectMatches(param1:MouseEvent) : *
      {
         this.matchSelectMC.visible = true;
         this.eventHandler.addListener(this.matchSelectMC.btn_ranked,MouseEvent.CLICK,this.showMatchMaking);
         this.eventHandler.addListener(this.matchSelectMC.btn_casual,MouseEvent.CLICK,this.showMatchMaking);
         this.eventHandler.addListener(this.matchSelectMC.bg,MouseEvent.CLICK,this.closeMatchSelection);
      }
      
      public function closeMatchSelection(param1:MouseEvent = null) : *
      {
         this.eventHandler.removeListener(this.matchSelectMC.btn_ranked,MouseEvent.CLICK,this.showMatchMaking);
         this.eventHandler.removeListener(this.matchSelectMC.btn_casual,MouseEvent.CLICK,this.showMatchMaking);
         this.eventHandler.removeListener(this.matchSelectMC.bg,MouseEvent.CLICK,this.closeMatchSelection);
         this.matchSelectMC.visible = false;
      }
      
      public function showMatchMaking(param1:MouseEvent) : *
      {
         this.matchMakingMC.txt_queue.text = "";
         this.matchMode = param1.currentTarget.name == "btn_ranked" ? "ranked" : "casual";
         this.closeMatchSelection();
         PvPSocket.getInstance().emit("Battle.startMatchMaking",{"mode":this.matchMode});
         this.setOnMatchMaking(this.matchMode);
      }
      
      public function setOnMatchMaking(param1:String) : *
      {
         this.matchMakingMC.visible = true;
         this.matchMakingMC.matchTypeTxt.text = param1 == "ranked" ? "Ranked Mode" : "Casual Mode";
         this.closeMatchSelection();
         this.autoStartMatch = true;
         this.setMatchMaking(true);
      }
      
      public function cancelMatchMaking(param1:MouseEvent) : *
      {
         this.matchMakingMC.txt_queue.text = "";
         PvPSocket.getInstance().emit("Battle.stopMatchMaking",{});
         this.stopMatchMaking();
      }
      
      public function stopMatchMaking(param1:* = null) : *
      {
         this.matchMakingMC.txt_queue.text = "";
         this.matchMakingMC.visible = false;
         this.autoStartMatch = false;
         this.isMatchingMaking = false;
      }
      
      public function onNotificationQueue(param1:String) : void
      {
         this.matchMakingMC.txt_queue.text = param1;
      }
      
      public function isMatchMaking() : *
      {
         return this.isMatchingMaking;
      }
      
      public function setMatchMaking(param1:Boolean) : *
      {
         this.isMatchingMaking = param1;
      }
      
      public function showCreateRoom(param1:MouseEvent) : *
      {
         this.createRoomMC.activate();
      }
      
      public function showJoinRoom(param1:MouseEvent) : *
      {
         this.joinRoomMC.visible = true;
         this.joinRoomMC.activate();
      }
      
      private function onRoomCreated(param1:Object) : void
      {
         Log.debug(this,"onRoomCreated",JSON.stringify(param1));
         this.roomInfo = param1;
         this.goToRoom();
      }
      
      private function onRoomJoinedAsEnemy(param1:Object) : void
      {
         Log.debug(this,"onRoomJoinedAsEnemy",JSON.stringify(param1));
         this.roomInfo = param1;
         this.goToRoom();
      }
      
      public function hideLobbyUI() : *
      {
         this.hidePopups();
         this.lobbyScreen.deactivate();
         this.joinRoomMC.deactivate();
         this.createRoomMC.deactivate();
         this.hideCharMC();
         if(this.roomMC)
         {
            this.roomMC.deactivate();
         }
      }
      
      public function goToRoom() : void
      {
         this.hideLobbyUI();
         this.roomMC.setContext(this);
         this.roomMC.activate();
      }
      
      public function goToLobby() : *
      {
         this.lobbyScreen.activate();
         this.hidePopups();
         this.stopMatchMaking();
         this.showCharMC();
      }
      
      public function showNotice(param1:*, param2:Boolean = false, param3:Boolean = false) : *
      {
         this.noticeMC.desc_txt.text = param1;
         this.noticeMC.visible = true;
         this.noticeMC.btn_reconnect.visible = param2;
         this.noticeMC.btn_village.visible = param3;
         this.eventHandler.addListener(this.noticeMC.btn_close,MouseEvent.CLICK,this.closeNotice,false,0,true);
         if(param2)
         {
            this.eventHandler.addListener(this.noticeMC.btn_reconnect,MouseEvent.CLICK,this.reconnect,false,0,true);
         }
         if(param3)
         {
            this.eventHandler.addListener(this.noticeMC.btn_village,MouseEvent.CLICK,this.goToVillage,false,0,true);
         }
      }
      
      public function closeNotice(param1:* = null) : *
      {
         this.noticeMC.visible = false;
         this.noticeMC.desc_txt.text = "";
         this.noticeMC.btn_reconnect.visible = false;
         this.noticeMC.btn_village.visible = false;
         this.eventHandler.removeListener(this.noticeMC.btn_close,MouseEvent.CLICK,this.closeNotice);
         this.eventHandler.removeListener(this.noticeMC.btn_reconnect,MouseEvent.CLICK,this.reconnect);
         this.eventHandler.removeListener(this.noticeMC.btn_village,MouseEvent.CLICK,this.goToVillage);
      }
      
      public function showReportBug(param1:MouseEvent) : *
      {
         this.reportBugMC.visible = true;
         this.reportBugMC.title_txt.text = "Report Title";
         this.reportBugMC.desc_txt.text = "Type Your Description/Bug/Suggestion Here";
         this.eventHandler.addListener(this.reportBugMC.btn_close,MouseEvent.CLICK,this.closeBugReport);
         this.eventHandler.addListener(this.reportBugMC.btn_submit,MouseEvent.CLICK,this.submitBugReport);
         this.eventHandler.addListener(this.reportBugMC.title_txt,MouseEvent.CLICK,this.onFocusClick);
         this.eventHandler.addListener(this.reportBugMC.desc_txt,MouseEvent.CLICK,this.onFocusClick);
      }
      
      public function showRules(param1:MouseEvent) : *
      {
         this.rulesMC.visible = true;
         this.textPane = new TextScrollPane();
         this.rulesMC.scrollPaneHolder.addChild(this.textPane.getScrollPane());
         this.rulesMC.title_txt.text = GameData.get("pvp_rules").title + " " + this.response.data.season;
         this.textPane.updatePane({
            "text":GameData.get("pvp_rules").rules,
            "text_width":747,
            "width":764,
            "height":352.55,
            "font_size":20,
            "font_name":"Franklin Gothic Demi",
            "font_color":16777215,
            "align":"left",
            "x":0,
            "y":0,
            "scroll_visible":"auto"
         });
         this.eventHandler.addListener(this.rulesMC.btn_close,MouseEvent.CLICK,this.closeRules);
      }
      
      public function closeRules(param1:MouseEvent) : *
      {
         this.rulesMC.visible = false;
      }
      
      public function onFocusClick(param1:MouseEvent) : *
      {
         if(param1.currentTarget.name == "title_txt")
         {
            if(this.reportBugMC.title_txt.text == "Report Title")
            {
               this.reportBugMC.title_txt.text = "";
            }
            if(this.reportBugMC.desc_txt.text == "")
            {
               this.reportBugMC.desc_txt.text = "Type Your Description/Bug/Suggestion Here";
            }
         }
         if(param1.currentTarget.name == "desc_txt")
         {
            if(this.reportBugMC.desc_txt.text == "Type Your Description/Bug/Suggestion Here")
            {
               this.reportBugMC.desc_txt.text = "";
            }
            if(this.reportBugMC.title_txt.text == "")
            {
               this.reportBugMC.title_txt.text = "Report Title";
            }
         }
      }
      
      public function closeBugReport(param1:MouseEvent) : *
      {
         this.reportBugMC.visible = false;
      }
      
      public function submitBugReport(param1:MouseEvent) : *
      {
         if(this.reportBugMC.title_txt.text == "" || this.reportBugMC.title_txt.text == "Report Title")
         {
            this.showNotice("Please Input Report Title or Description");
            return;
         }
         if(this.reportBugMC.desc_txt.text == "" || this.reportBugMC.desc_txt.text == "Type Your Description/Bug/Suggestion Here")
         {
            this.showNotice("Please Input Report Title or Description");
            return;
         }
         this.main.amf_manager.service("jpwzlvqNru201CF3.uIy822jeG2Nn",[Character.char_id,Character.sessionkey,this.reportBugMC.title_txt.text,this.reportBugMC.desc_txt.text],this.onSubmitBugReport);
      }
      
      public function onSubmitBugReport(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.showNotice(param1.result || "Bug report submitted successfully");
         }
         else
         {
            this.showNotice(param1.result || "Unknown Error");
         }
      }
      
      public function reconnect(param1:MouseEvent = null) : void
      {
         var e:MouseEvent = param1;
         Log.info(this,"reconnect","Attempting to reconnect to PvP server");
         this.clearReconnectTimer();
         this.showNotice("Reconnecting to PvP server...",false,false);
         try
         {
            PvPSocket.getInstance().connect();
            this._reconnectTimer = new Timer(10000,1);
            this._reconnectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onReconnectTimeout);
            this._reconnectTimer.start();
         }
         catch(err:*)
         {
            Log.error(this,"reconnect","Error during reconnect: " + err);
            this.showNotice("Failed to reconnect. Please try again.",true,false);
         }
      }
      
      private function onReconnectTimeout(param1:TimerEvent) : void
      {
         var _loc2_:* = PvPSocket.getInstance();
         if(!_loc2_.socket || !_loc2_.socket.connected)
         {
            Log.warning(this,"onReconnectTimeout","Reconnection timeout - connection failed");
            this.showNotice("Failed to reconnect. Please try again.",true,false);
         }
         this.clearReconnectTimer();
      }
      
      public function goToVillage(param1:MouseEvent = null) : void
      {
         Log.info(this,"goToVillage","Returning to village");
         this.main.stopAllBgm();
         this.main.startBgm();
         this.destroy();
      }
      
      public function playIdleAnimation() : *
      {
         this.char_mc.gotoAndPlay("show");
      }
      
      private function onNotificationPopUp(param1:*) : void
      {
         Log.info(this,"notificationPopUp",param1);
         this.main.loading(false);
         this.main.getNotice(param1);
      }
      
      private function onMapIDs(param1:*) : void
      {
         this.missionIDs = param1;
      }
      
      private function onActivePlayers(param1:*) : void
      {
         this.activePlayerTxt.text = "Active Players: " + (param1 || 0);
      }
      
      private function onNotificationDisconnect(param1:*) : void
      {
         Log.debug(this,"onNotificationDisconnect",JSON.stringify(param1));
         this.disconnectReason = param1;
      }
      
      private function onBattleStarted(param1:Object) : void
      {
         Log.info(this,"onBattleStarted",JSON.stringify(param1));
         this.spectatorMode = param1.hasOwnProperty("spectator") && param1.spectator === true;
         this.hideLobbyUI();
         this.stopMatchMaking();
         this.main.loading(false);
         if(this.battleUI)
         {
            if(this.main.loader.contains(this.battleUI))
            {
               this.main.loader.removeChild(this.battleUI);
            }
            this.battleUI.destroy();
            this.battleUI = null;
         }
         this.battleUI = new Battle();
         this.main.stopAllBgm();
         this.main.startBgm("battle");
         PvPBattleManager.initiateBattle(this,param1);
      }
      
      public function leaveSpectatorMode() : void
      {
         if(!this.spectatorMode)
         {
            return;
         }
         PvPSocket.getInstance().emit("Battle.spectator.leave",{});
         this.spectatorMode = false;
         this.main.stopAllBgm();
         this.main.startBgm();
         PvPBattleManager.endBattle();
      }
      
      public function getMissionIDs() : Array
      {
         var _loc1_:* = GameData.get("encyclopedia");
         return _loc1_ && _loc1_.hasOwnProperty("background") ? _loc1_.background : this.missionIDs;
      }
      
      private function onSpectatorJoinError(param1:Object) : void
      {
         this.main.loading(false);
         var _loc2_:String = "Failed to join as spectator";
         if(param1 && param1.hasOwnProperty("message"))
         {
            _loc2_ = param1.message;
         }
         else if(param1 && param1.hasOwnProperty("error"))
         {
            _loc2_ = param1.error;
         }
         this.main.getNotice(_loc2_);
      }
      
      private function hidePopups() : void
      {
         this.noticeMC.visible = false;
         this.battleHistoryMC.visible = false;
         this.reportBugMC.visible = false;
         this.rulesMC.visible = false;
         this.joinRoomMC.visible = false;
         this.roomMC.visible = false;
         this.createRoomMC.visible = false;
         this.announcementMC.visible = false;
         this.matchMakingMC.visible = false;
         this.matchSelectMC.visible = false;
         if(this.liveMatchesMC)
         {
            this.liveMatchesMC.visible = false;
         }
         this.chatBoxMc.chatBg.visible = false;
         this.chatBoxMc.chatBoxTxt.visible = false;
         this.chatBoxMc.bg_close.visible = false;
         this.getNotice.visible = false;
      }
      
      private function stopUIAnimation() : void
      {
         this.rankMC.gotoAndStop(1);
         this.titleMC.gotoAndStop(1);
         this.classMC.gotoAndStop(1);
         this.char_mc.visible = false;
      }
      
      private function hideCharMC() : *
      {
         this.char_mc.visible = false;
      }
      
      private function showCharMC() : *
      {
         this.char_mc.visible = true;
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function clearReconnectTimer() : void
      {
         if(this._reconnectTimer)
         {
            this._reconnectTimer.stop();
            this._reconnectTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onReconnectTimeout);
            this._reconnectTimer = null;
         }
      }
      
      private function destroy() : void
      {
         this.main.handleVillageHUDVisibility(true);
         this.clearReconnectTimer();
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this.lobbyScreen)
         {
            this.lobbyScreen.destroy();
         }
         if(this.liveMatchesMC)
         {
            this.liveMatchesMC.destroy();
            this.liveMatchesMC = null;
         }
         if(this.character)
         {
            this.character.destroy();
         }
         this.character = null;
         if(this.roomMC)
         {
            this.roomMC.destroy();
         }
         if(this.textPane)
         {
            this.textPane.destroy();
         }
         this.textPane = null;
         if(this.battleUI)
         {
            this.battleUI.destroy();
            if(this.contains(this.battleUI))
            {
               this.removeChild(this.battleUI);
            }
            this.battleUI = null;
         }
         PvPBattleManager.destroyBattle();
         GF.destroyArray(this.outfits);
         GF.removeAllChild(this.char_mc);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.lobbyScreen = null;
         this.char_mc = null;
         this.outfits = [];
         NinjaSage.clearLoader();
         if(this.loaderSwf)
         {
            this.loaderSwf.removeAll();
         }
         this.loaderSwf = null;
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         try
         {
            this.removeSocketListener();
            PvPSocket.getInstance().disconnect();
            PvPSocket.getInstance().destroy();
         }
         catch(e:*)
         {
         }
      }
   }
}
