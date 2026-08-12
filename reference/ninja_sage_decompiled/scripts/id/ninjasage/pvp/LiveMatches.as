package id.ninjasage.pvp
{
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import gs.TweenLite;
   import id.ninjasage.EventHandler;
   
   public dynamic class LiveMatches extends MovieClip
   {
       
      
      public var activePlayerTxt:TextField;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_refresh:SimpleButton;
      
      public var matchMC0:MovieClip;
      
      public var matchMC1:MovieClip;
      
      public var matchMC2:MovieClip;
      
      public var matchMC3:MovieClip;
      
      public var pageTxt:TextField;
      
      public var profileTitleTxt:TextField;
      
      public var eventHandler;
      
      public var response;
      
      public var currentPage:int = 1;
      
      public var totalPage:int = 1;
      
      private var pvp:PvP;
      
      public function LiveMatches()
      {
         super();
         this.eventHandler = new EventHandler();
      }
      
      public function setContext(param1:PvP) : void
      {
         this.pvp = param1;
      }
      
      private function setupSocketListener() : void
      {
         this.removeSocketListener();
         PvPSocket.getInstance().on("System.listLiveMatches",this.onLiveMatchesData);
         PvPSocket.getInstance().emit("System.listLiveMatches");
      }
      
      private function removeSocketListener() : void
      {
         PvPSocket.getInstance().off("System.listLiveMatches",this.onLiveMatchesData);
      }
      
      public function requestLiveMatches() : void
      {
         PvPSocket.getInstance().emit("System.listLiveMatches");
      }
      
      public function activate() : *
      {
         this.visible = true;
         this.hideAllMatches();
         this.setupSocketListener();
         this.initButton();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.y = stage.height;
         this.btn_close.x = 686;
         this.btn_close.y = 0;
         TweenLite.to(this,0.7,{
            "y":150,
            "ease":"easeOutBack"
         });
      }
      
      private function hideAllMatches() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = this["matchMC" + _loc1_];
            if(_loc2_)
            {
               _loc2_.visible = false;
            }
            _loc1_++;
         }
      }
      
      public function deactivate() : void
      {
         this.removeSocketListener();
         this.closePanel();
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         TweenLite.killTweensOf(this);
         this.removeSocketListener();
         if(this.eventHandler)
         {
            this.eventHandler.removeListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
            this.eventHandler.removeListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
            this.eventHandler.removeListener(this.btn_next,MouseEvent.CLICK,this.changePage);
            this.eventHandler.removeListener(this.btn_refresh,MouseEvent.CLICK,this.refreshList);
            _loc1_ = 0;
            while(_loc1_ < 4)
            {
               if(this["matchMC" + _loc1_] && this["matchMC" + _loc1_].hasOwnProperty("btn_watch"))
               {
                  this.eventHandler.removeListener(this["matchMC" + _loc1_].btn_watch,MouseEvent.CLICK,this.prepareWatch);
               }
               _loc1_++;
            }
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
         }
         this.matches = null;
         this.pvp = null;
         this.response = null;
      }
      
      public function onLiveMatchesData(param1:*) : *
      {
         var _loc2_:* = param1;
         if(!_loc2_)
         {
            return;
         }
         this.responseActivityData(_loc2_);
      }
      
      public function responseActivityData(param1:*) : *
      {
         if(!param1 || !(param1 is Array) || param1.length == 0)
         {
            this.matches = [];
            this.initUI();
            return;
         }
         this.matches = param1;
         this.initUI();
      }
      
      public function initUI() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = this["matchMC" + _loc1_];
            if(_loc2_ && _loc2_.hasOwnProperty("btn_watch"))
            {
               this.eventHandler.removeListener(_loc2_.btn_watch,MouseEvent.CLICK,this.prepareWatch);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = this["matchMC" + _loc1_];
            if(_loc2_)
            {
               _loc3_ = _loc1_ + int(int(this.currentPage - 1) * 4);
               _loc2_.visible = false;
               if(this.matches && this.matches.length > _loc3_)
               {
                  if(_loc4_ = this.matches[_loc3_])
                  {
                     _loc2_.visible = true;
                     this.eventHandler.addListener(_loc2_.btn_watch,MouseEvent.CLICK,this.prepareWatch);
                     _loc2_.btn_watch.metaData = {
                        "matchId":_loc4_.id || _loc4_.roomId || "",
                        "requirePassword":_loc4_.requirePassword
                     };
                     _loc2_.matchTypeTxt.text = _loc4_.mode || _loc4_.matchType || "";
                     _loc2_.txt.text = (_loc4_.spectators || 0) + "/10";
                     if(_loc4_.players && _loc4_.players.length > 0)
                     {
                        _loc5_ = _loc4_.players[0];
                        if(_loc2_.hasOwnProperty("playerNameTxt"))
                        {
                           _loc2_.playerNameTxt.htmlText = Character.colorifyText(_loc5_.id,_loc5_.name,_loc2_.playerNameTxt);
                        }
                        if(_loc2_.hasOwnProperty("playerTrophyTxt"))
                        {
                           _loc2_.playerTrophyTxt.text = String(_loc5_.trophy || 0);
                        }
                     }
                     if(_loc4_.players && _loc4_.players.length > 1)
                     {
                        _loc6_ = _loc4_.players[1];
                        if(_loc2_.hasOwnProperty("enemyNameTxt"))
                        {
                           _loc2_.enemyNameTxt.htmlText = Character.colorifyText(_loc6_.id,_loc6_.name,_loc2_.enemyNameTxt);
                        }
                        if(_loc2_.hasOwnProperty("enemyTrophyTxt"))
                        {
                           _loc2_.enemyTrophyTxt.text = String(_loc6_.trophy || 0);
                        }
                     }
                  }
               }
            }
            _loc1_++;
         }
         this.totalPage = Math.max(Math.ceil((!!this.matches ? this.matches.length : 0) / 4),1);
         this.updatePageText();
      }
      
      public function prepareWatch(param1:MouseEvent) : *
      {
         if(param1.currentTarget.metaData.requirePassword)
         {
            this.pvp.main.showMessage("This match requires password to spectate");
            this.pvp.joinRoomMC.initUI();
            this.pvp.joinRoomMC.btn_join_room.visible = false;
            this.pvp.joinRoomMC.roomId.text = param1.currentTarget.metaData.matchId;
            this.pvp.joinRoomMC.visible = true;
         }
         else
         {
            this.watch(param1.currentTarget.metaData.matchId);
         }
      }
      
      public function watch(param1:*, param2:* = null) : *
      {
         this.pvp.main.loading(true);
         PvPSocket.getInstance().emit("Battle.spectator.join",{
            "roomId":param1,
            "password":param2
         });
         if(this.pvp.joinRoomMC.password.text)
         {
            this.pvp.joinRoomMC.closePanel();
         }
      }
      
      public function refreshList(param1:MouseEvent) : *
      {
         PvPSocket.getInstance().emit("System.listLiveMatches");
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.initUI();
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.initUI();
               }
         }
         this.updatePageText();
      }
      
      public function updatePageText() : *
      {
         this.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      public function initButton() : *
      {
         this.eventHandler.removeListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.removeListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.removeListener(this.btn_refresh,MouseEvent.CLICK,this.refreshList);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_refresh,MouseEvent.CLICK,this.refreshList);
      }
      
      public function closePanel(param1:MouseEvent = null) : *
      {
         TweenLite.killTweensOf(this);
         this.removeSocketListener();
         this.eventHandler.removeListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.removeListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.removeListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.removeListener(this.btn_refresh,MouseEvent.CLICK,this.refreshList);
         var _loc2_:* = 0;
         while(_loc2_ < 4)
         {
            if(this["matchMC" + _loc2_] && this["matchMC" + _loc2_].hasOwnProperty("btn_watch"))
            {
               this.eventHandler.removeListener(this["matchMC" + _loc2_].btn_watch,MouseEvent.CLICK,this.prepareWatch);
            }
            _loc2_++;
         }
         this.visible = false;
         this.currentPage = 1;
         this.totalPage = 1;
         this.matches = null;
      }
   }
}
