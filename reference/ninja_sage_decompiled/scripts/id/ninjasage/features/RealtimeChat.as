package id.ninjasage.features
{
   import Storage.Character;
   import com.gestouch.events.GestureEvent;
   import com.gestouch.gestures.PanGesture;
   import com.pnwrain.flashsocket.FlashSocket;
   import com.pnwrain.flashsocket.events.FlashSocketEvent;
   import com.utils.GF;
   import fl.containers.ScrollPane;
   import fl.events.ScrollEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldType;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public dynamic class RealtimeChat extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      protected var socket:FlashSocket;
      
      protected var main;
      
      protected var messages;
      
      protected var timeoutHandler;
      
      protected var timeOut = false;
      
      protected var eventHandler:EventHandler;
      
      protected var socketEventHandler:EventHandler;
      
      protected var instanceEmpty:MovieClip;
      
      protected var nicknameColors;
      
      protected var scheme:String;
      
      protected var manualClosePanel = false;
      
      protected var destroyed = false;
      
      private var chatScrollPane;
      
      private var maxReconnect = 10;
      
      private var reconnectTries = 0;
      
      private var panGesture:PanGesture;
      
      private var isUserAtBottom:Boolean = true;
      
      private var scrollThreshold:Number = 50;
      
      private var lastOnlineUpdateTime:Number = 0;
      
      private var onlineUpdateDelay:Number;
      
      private var pendingOnlineData:Object = null;
      
      private var onlineUpdateTimer:uint = 0;
      
      private var maxMessages;
      
      public function RealtimeChat(param1:* = null)
      {
         this.messages = [];
         this.nicknameColors = {};
         this.onlineUpdateDelay = Number(4000);
         this.maxMessages = 200;
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closeChatPanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.socketEventHandler = new EventHandler();
         this.scheme = !!Character.web ? "https" : "wss";
      }
      
      public function init() : *
      {
         this.initChatBox();
         this.initSocket();
      }
      
      public function initSocket() : *
      {
         if(this.destroyed)
         {
            return;
         }
         this.socket = new FlashSocket(this.getSocketAddress(),this.getSocketOptions());
         this.socketEventHandler.addListener(this.socket,"nickname-colors",this.onNicknameColors);
         this.socketEventHandler.addListener(this.socket,"online-users",this.onTotalOnlineChange);
         this.socketEventHandler.addListener(this.socket,"history",this.onHistoryChatUpdate);
         this.socketEventHandler.addListener(this.socket,"message",this.onNewMessage);
         this.socketEventHandler.addListener(this.socket,"announcement",this.onAnnouncement);
         this.socketEventHandler.addListener(this.socket,FlashSocketEvent.CONNECT,this.onSocketConnected);
         this.socketEventHandler.addListener(this.socket,FlashSocketEvent.DISCONNECT,this.onDisconnect);
         this.socketEventHandler.addListener(this.socket,FlashSocketEvent.SECURITY_ERROR,this.onSocketError);
         this.socketEventHandler.addListener(this.socket,FlashSocketEvent.CONNECT_ERROR,this.onSocketError);
         this.socketEventHandler.addListener(this.socket,FlashSocketEvent.IO_ERROR,this.onSocketError);
         this.socketEventHandler.addListener(this.socket,FlashSocketEvent.ERROR,this.onSocketError);
      }
      
      protected function getSocketAddress() : *
      {
         return "";
      }
      
      protected function getSocketOptions() : Object
      {
         return {"transports":["websocket"]};
      }
      
      public function onHistoryChatUpdate(param1:*) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.data[0];
         this.messages = [];
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            this.messages.push(_loc4_);
            _loc3_++;
         }
         this.renderHistoryMessages();
      }
      
      protected function onNewMessage(param1:*) : *
      {
         this.checkIfUserAtBottom();
         this.addMessageToQueue(param1.data[0]);
         this.ensureChatPaneInitialized();
         var _loc2_:* = this.chatScrollPane.source;
         var _loc3_:* = Math.max(0,_loc2_.numChildren);
         var _loc4_:* = this.createChatInstance(param1.data[0],_loc3_);
         _loc2_.addChild(_loc4_);
         this.refreshChatPane();
      }
      
      public function renderHistoryMessages() : *
      {
         var _loc2_:* = undefined;
         this.ensureChatPaneInitialized();
         var _loc1_:int = 0;
         while(_loc1_ < this.messages.length)
         {
            _loc2_ = this.createChatInstance(this.messages[_loc1_],_loc1_);
            this.instanceEmpty.addChild(_loc2_);
            _loc1_++;
         }
         this.isUserAtBottom = true;
         this.refreshChatPane();
      }
      
      private function addMessageToQueue(param1:Object) : void
      {
         if(this.messages.length >= this.maxMessages)
         {
            this.messages.shift();
         }
         this.messages.push(param1);
      }
      
      private function ensureChatPaneInitialized() : void
      {
         var _loc1_:* = undefined;
         if(!this.instanceEmpty)
         {
            _loc1_ = getDefinitionByName("iconMCHolder") as Class;
            this.instanceEmpty = new _loc1_();
            this.chatScrollPane.source = this.instanceEmpty;
            this.chatBoxMc.scrollPaneHolder.addChild(this.chatScrollPane);
         }
      }
      
      private function createChatInstance(param1:Object, param2:int) : MovieClip
      {
         var _loc3_:* = getDefinitionByName("ChatDisplay") as Class;
         var _loc4_:MovieClip = new _loc3_();
         var _loc5_:MovieClip = this.duplicateObject(_loc4_);
         var _loc6_:Sprite = this.createBackgroundRectangle(param1.character.id);
         _loc5_.bgMC.addChild(_loc6_);
         _loc5_.name = "chatMC" + (param2 + 1);
         this.populateChatInstance(_loc5_,param1,param2);
         return _loc5_;
      }
      
      private function createBackgroundRectangle(param1:int) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:uint = this.getIntColorById(param1);
         _loc2_.graphics.beginFill(_loc3_,0.15);
         _loc2_.graphics.moveTo(4.9,5.2);
         _loc2_.graphics.lineTo(124,5.2);
         _loc2_.graphics.lineStyle(0.5,_loc3_,0.3);
         _loc2_.graphics.drawRoundRect(5,0.25,120,13.45,4);
         _loc2_.graphics.endFill();
         return _loc2_;
      }
      
      private function populateChatInstance(param1:MovieClip, param2:Object, param3:int) : void
      {
         param1.txt_name.htmlText = this.colorText("[ID " + param2.character.id + "] " + param2.character.name,this.getHexColorById(param2.character.id));
         param1.txt_lvl.text = "Lv. " + param2.character.level;
         param1.chatContents.text = param2.message;
         param1.rankMC.gotoAndStop(param2.character.rank);
         param1.emblemMC.gotoAndStop(param2.character.premium + 1);
         param1.y += param3 * 105;
         if(param2.character.id == Character.char_id)
         {
            param1.btn_AddFriend.removeEventListener(MouseEvent.CLICK,this.checkProfile);
            param1.btn_AddFriend.visible = false;
         }
         else
         {
            param1.btn_AddFriend.metaData = {"char_id":param2.character.id};
            param1.btn_AddFriend.addEventListener(MouseEvent.CLICK,this.checkProfile);
            param1.btn_AddFriend.visible = true;
         }
      }
      
      private function refreshChatPane() : void
      {
         this.chatScrollPane.refreshPane();
         if(this.isUserAtBottom)
         {
            try
            {
               this.chatScrollPane.verticalScrollPosition = this.chatScrollPane.maxVerticalScrollPosition;
               this.isUserAtBottom = true;
            }
            catch(e:*)
            {
            }
         }
      }
      
      private function checkIfUserAtBottom() : void
      {
         var currentPos:* = undefined;
         var maxPos:* = undefined;
         try
         {
            currentPos = this.chatScrollPane.verticalScrollPosition;
            maxPos = this.chatScrollPane.maxVerticalScrollPosition;
            this.isUserAtBottom = maxPos - currentPos <= this.scrollThreshold;
         }
         catch(e:*)
         {
            this.isUserAtBottom = true;
         }
      }
      
      public function checkProfile(param1:MouseEvent) : *
      {
         this.main.openFriendProfile(param1.currentTarget.metaData.char_id,true);
      }
      
      protected function duplicateObject(param1:MovieClip) : MovieClip
      {
         var _loc4_:Rectangle = null;
         var _loc2_:Class = Object(param1).constructor;
         var _loc3_:MovieClip = new _loc2_();
         _loc3_.transform = param1.transform;
         _loc3_.filters = param1.filters;
         _loc3_.cacheAsBitmap = param1.cacheAsBitmap;
         _loc3_.opaqueBackground = param1.opaqueBackground;
         if(param1.scale9Grid)
         {
            _loc4_ = param1.scale9Grid;
            _loc3_.scale9Grid = _loc4_;
         }
         return _loc3_;
      }
      
      protected function getHexColorById(param1:*) : *
      {
         if(this.nicknameColors && this.nicknameColors.hasOwnProperty(param1))
         {
            return this.nicknameColors[param1];
         }
         return "000000";
      }
      
      protected function getIntColorById(param1:*) : *
      {
         var _loc2_:String = this.getHexColorById(param1);
         return parseInt(_loc2_,16);
      }
      
      protected function colorText(param1:*, param2:*) : *
      {
         return "<font color=\"#" + param2 + "\">" + param1 + "</font>";
      }
      
      public function onSocketConnected(param1:*) : *
      {
         this.reconnectTries = 0;
         this.emit("auth",{
            "character_id":Character.char_id,
            "session_key":Character.sessionkey
         });
         this.emit("open-chatbox",[]);
      }
      
      public function onTotalOnlineChange(param1:*) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.data[0];
         var _loc3_:* = new Date().getTime();
         this.chatBoxMc.onlineMc.onlineTxt.text = _loc2_.total + " Players Online";
         this.pendingOnlineData = _loc2_;
         if(_loc3_ - this.lastOnlineUpdateTime >= this.onlineUpdateDelay)
         {
            this.updateOnlineUsersList(_loc2_);
            this.lastOnlineUpdateTime = _loc3_;
         }
         else
         {
            if(this.onlineUpdateTimer != 0)
            {
               clearTimeout(this.onlineUpdateTimer);
            }
            _loc4_ = this.onlineUpdateDelay - (_loc3_ - this.lastOnlineUpdateTime);
            this.onlineUpdateTimer = setTimeout(this.delayedOnlineUpdate,_loc4_);
         }
      }
      
      private function updateOnlineUsersList(param1:Object) : void
      {
         var _loc2_:* = [];
         var _loc3_:* = 0;
         while(_loc3_ < param1.users.length)
         {
            _loc2_.push("[" + param1.users[_loc3_].id + "] " + this.colorText(param1.users[_loc3_].name,this.getHexColorById(param1.users[_loc3_].id)));
            _loc3_++;
         }
         this.chatBoxMc.listOnlineUsers.htmlText = _loc2_.join("\n");
      }
      
      private function delayedOnlineUpdate() : void
      {
         clearTimeout(this.onlineUpdateTimer);
         this.onlineUpdateTimer = 0;
         if(this.pendingOnlineData)
         {
            this.updateOnlineUsersList(this.pendingOnlineData);
            this.lastOnlineUpdateTime = new Date().getTime();
            this.pendingOnlineData = null;
         }
      }
      
      public function onDisconnect(param1:*) : *
      {
         this.chatBoxMc.onlineMc.offlineIcon.visible = true;
         if(this.manualClosePanel && this.reconnectTries < this.maxReconnect)
         {
            this.reconnect();
         }
         else
         {
            this.main.showMessage("Chat has been disconnected from the server...");
         }
      }
      
      public function onSocketError(param1:*) : *
      {
         this.main.showMessage("Something wrong with our end, please re-open the chat menu");
         this.chatBoxMc.onlineMc.offlineIcon.visible = true;
      }
      
      public function onAnnouncement(param1:*) : *
      {
         if(param1.data[0] != "")
         {
            this.main.showMessage(param1.data[0]);
         }
      }
      
      public function onNicknameColors(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1.data.length > 0 && param1.data[0] != null)
         {
            _loc2_ = param1.data[0];
            for(_loc3_ in _loc2_)
            {
               this.nicknameColors[_loc3_] = _loc2_[_loc3_].slice(1);
            }
         }
      }
      
      public function initChatBox() : *
      {
         this.chatScrollPane = new ScrollPane();
         this.panGesture = new PanGesture(this.chatScrollPane);
         this.chatScrollPane.setSize(441.2,700.8);
         this.chatScrollPane.horizontalScrollPolicy = "off";
         this.chatScrollPane.addEventListener(ScrollEvent.SCROLL,this.onScrollChange);
         this.btn_clancht.visible = false;
         this.chatBoxMc.onlineMc.offlineIcon.visible = false;
         this.chatBoxMc.chatInputAndroid.visible = false;
         this.chatBoxMc.chatInputDesktop.visible = true;
         this.eventHandler.addListener(this.chatBoxMc.chatInputDesktop.send_msg,MouseEvent.CLICK,this.chatInputHandler);
         this.eventHandler.addListener(this.chatBoxMc.chatInputDesktop.chatInputMc,KeyboardEvent.KEY_DOWN,this.chatInputHandler);
         this.eventHandler.addListener(this.panGesture,GestureEvent.GESTURE_CHANGED,this.onGestureChanged);
         this.eventHandler.addListener(this.closeChat,MouseEvent.CLICK,this.closeChatPanel,false,0,true);
         this.eventHandler.addListener(this.btn_back,MouseEvent.CLICK,this.closeChatPanel,false,0,true);
         this.eventHandler.addListener(this.facebookPage,MouseEvent.CLICK,this.openSocial,false,0,true);
         this.eventHandler.addListener(this.facebookGroup,MouseEvent.CLICK,this.openSocial,false,0,true);
         this.eventHandler.addListener(this.discordChannel,MouseEvent.CLICK,this.openSocial,false,0,true);
      }
      
      public function onGestureChanged(param1:GestureEvent) : void
      {
         var _loc2_:PanGesture = PanGesture(param1.target);
         this.chatScrollPane.verticalScrollPosition -= _loc2_.offsetY;
         this.checkIfUserAtBottom();
      }
      
      public function onScrollChange(param1:*) : void
      {
         this.checkIfUserAtBottom();
      }
      
      public function scrollHandler(param1:*) : *
      {
         this.checkIfUserAtBottom();
      }
      
      public function chatInputHandler(param1:*) : *
      {
         var _loc2_:* = 3;
         if(this.timeOut == false)
         {
            if(param1 is MouseEvent)
            {
               if(this.chatBoxMc.chatInputDesktop.chatInputMc.text != "")
               {
                  this.emit("sendMessage",this.chatBoxMc.chatInputDesktop.chatInputMc.text);
                  this.chatBoxMc.chatInputDesktop.chatInputMc.text = "";
                  this.timeOut = true;
                  this.timeoutHandler = setTimeout(this.timeoutChat,3000);
               }
            }
            else if(param1.charCode == 13 && this.chatBoxMc.chatInputDesktop.chatInputMc.text != "")
            {
               this.emit("sendMessage",this.chatBoxMc.chatInputDesktop.chatInputMc.text);
               this.chatBoxMc.chatInputDesktop.chatInputMc.text = "";
               this.timeOut = true;
               this.timeoutHandler = setTimeout(this.timeoutChat,3000);
            }
         }
         else
         {
            this.chatBoxMc.chatInputDesktop.chatInputMc.text = "Cooldown for 3 seconds";
            this.chatBoxMc.chatInputDesktop.chatInputMc.type = TextFieldType.DYNAMIC;
         }
      }
      
      protected function emit(param1:*, param2:*) : *
      {
         if(this.socket.connected)
         {
            this.socket.emit(param1,param2);
         }
      }
      
      public function timeoutChat() : *
      {
         this.timeOut = false;
         this.chatBoxMc.chatInputDesktop.chatInputMc.text = "";
         this.chatBoxMc.chatInputDesktop.chatInputMc.type = TextFieldType.INPUT;
      }
      
      protected function openSocial(param1:*) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         if(_loc2_ == "facebookPage")
         {
            navigateToURL(new URLRequest("https://www.facebook.com/NinjaSage.ID"));
         }
         else if(_loc2_ == "facebookGroup")
         {
            navigateToURL(new URLRequest("https://www.facebook.com/groups/ninjasage/"));
         }
         else if(_loc2_ == "discordChannel")
         {
            navigateToURL(new URLRequest("https://dc.ninjasage.id/"));
         }
      }
      
      public function destroy() : *
      {
         var _loc1_:MovieClip = null;
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         Log.debug(this,"DESTROY");
         if(this.onlineUpdateTimer != 0)
         {
            clearTimeout(this.onlineUpdateTimer);
            this.onlineUpdateTimer = 0;
         }
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
         }
         if(this.socketEventHandler)
         {
            this.socketEventHandler.removeAllEventListeners();
            this.socketEventHandler = null;
         }
         if(this.messages)
         {
            GF.clearArray(this.messages);
            this.messages = null;
         }
         this.nicknameColors = null;
         this.pendingOnlineData = null;
         if(this.instanceEmpty)
         {
            while(this.instanceEmpty.numChildren > 0)
            {
               _loc1_ = this.instanceEmpty.getChildAt(0) as MovieClip;
               if(_loc1_ && _loc1_.btn_AddFriend)
               {
                  _loc1_.btn_AddFriend.removeEventListener(MouseEvent.CLICK,this.checkProfile);
               }
               this.instanceEmpty.removeChild(_loc1_);
            }
            this.instanceEmpty = null;
         }
         if(this.chatScrollPane)
         {
            this.chatScrollPane.removeEventListener(ScrollEvent.SCROLL,this.onScrollChange);
            this.chatScrollPane.source = null;
            this.chatScrollPane = null;
         }
         if(this.panGesture)
         {
            this.panGesture = null;
         }
         if(this.chatBoxMc && this.chatBoxMc.listOnlineUsers)
         {
            this.chatBoxMc.listOnlineUsers.htmlText = "";
         }
         if(this.timeoutHandler != null)
         {
            clearTimeout(this.timeoutHandler);
            this.timeoutHandler = null;
         }
         if(this.socket)
         {
            this.socket.destroy();
         }
         this.socket = null;
         this.main = null;
         GF.removeAllChild(this);
      }
      
      private function reconnect() : *
      {
         if(this.reconnectTries >= this.maxReconnect)
         {
            Log.debug(this,"Couldnot connect to server: Reconnect tries exceeded");
            return;
         }
         if(this.socket)
         {
            this.socketEventHandler.removeAllEventListeners();
            this.socket.destroy();
         }
         ++this.reconnectTries;
         setTimeout(this.initSocket,1500);
      }
      
      public function show() : *
      {
         if(this.main)
         {
            this.main.loader.addChild(this);
         }
      }
      
      public function manualClose() : *
      {
         this.manualClosePanel = true;
      }
      
      public function closeChatPanel(param1:MouseEvent = null) : *
      {
         if(this.manualClosePanel)
         {
            parent.removeChild(this);
         }
         else
         {
            this.destroy();
         }
      }
   }
}
