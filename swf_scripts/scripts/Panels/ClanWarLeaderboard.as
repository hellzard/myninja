package Panels
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import gs.TweenLite;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import skein.socket.io.IO;
   import skein.socket.io.Manager;
   import skein.socket.io.Options;
   import skein.socket.io.Socket;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1725")]
   public dynamic class ClanWarLeaderboard extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      private var socket:*;
      
      public var panelMC:MovieClip;
      
      public var main:*;
      
      public var eventHandler:*;
      
      private var r:*;
      
      private var oldR:* = null;
      
      private var defaultColor:* = "#abbbfe";
      
      private var green:* = "#01ff10";
      
      private var red:* = "#b91c1c";
      
      public function ClanWarLeaderboard(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.panelMC.y += this.main.stage.width;
         TweenLite.to(this.panelMC,1.2,{
            "y":0,
            "ease":"easeOutBack"
         });
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         var _loc2_:int = 0;
         while(_loc2_ < 15)
         {
            this.panelMC["rankInfoMc_" + _loc2_].visible = false;
            _loc2_++;
         }
         var _loc3_:* = new Options();
         _loc3_.reconnection = true;
         _loc3_.forceNew = true;
         var _loc4_:* = Character.web ? "http" : "ws";
         var _loc5_:* = _loc4_ + "://ws-ldns.ninjasage.id";
         this.socket = IO.socket(_loc5_,_loc3_);
         this.socket.on(Socket.EVENT_CONNECT,this.onConnected);
         this.socket.on(Socket.EVENT_DISCONNECT,this.onDisconnected);
         this.socket.on(Manager.EVENT_CLOSE,this.onError);
         this.socket.on("UpdateClanReputation",this.onData);
         this.addEventListener("data",this.onData);
         this.socket.connect();
      }
      
      public function onData(param1:* = null, param2:* = null) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         if(param2 != null && Boolean(param2.hasOwnProperty("clans")))
         {
            this.respose = param2;
            if(this.oldR == null)
            {
               this.oldR = {};
               _loc3_ = 0;
               while(_loc3_ < param2.clans.lenght)
               {
                  param2.clans[_loc3_].gap = 0;
                  this.oldR[param2.clans[_loc3_].id] = param2.clans[_loc3_];
                  _loc3_++;
               }
            }
            _loc3_ = 0;
            while(_loc3_ < param2.clans.length)
            {
               if(_loc3_ > 15)
               {
                  break;
               }
               _loc4_ = param2.clans[_loc3_];
               if(_loc4_.hasOwnProperty("reputation"))
               {
                  if(!this.oldR.hasOwnProperty(_loc4_.id))
                  {
                     _loc4_.gap = 0;
                     this.oldR[_loc4_.id] = _loc4_;
                  }
                  _loc5_ = _loc3_ - 1;
                  _loc6_ = param2.clans[_loc5_] != null ? param2.clans[_loc5_].reputation : 0;
                  _loc7_ = Math.max(_loc6_ - _loc4_.reputation,0);
                  _loc8_ = _loc4_.reputation - (this.oldR.hasOwnProperty(_loc4_.id) ? this.oldR[_loc4_.id].reputation : 0);
                  _loc9_ = param2.rpm.hasOwnProperty(_loc4_.id) ? param2.rpm[_loc4_.id] : 0;
                  _loc10_ = param2.rp15m.hasOwnProperty(_loc4_.id) ? param2.rp15m[_loc4_.id] : 0;
                  _loc11_ = this.oldR[_loc4_.id].gap - _loc7_ == 0 ? this.defaultColor : (this.oldR[_loc4_.id].gap - _loc7_ > 0 ? this.green : this.red);
                  _loc12_ = _loc8_ == 0 ? this.defaultColor : (_loc8_ > 0 ? this.green : this.red);
                  _loc13_ = _loc9_ == 0 ? this.defaultColor : (_loc9_ > 0 ? this.green : this.red);
                  _loc14_ = _loc10_ == 0 ? this.defaultColor : (_loc10_ ? this.green : this.red);
                  this.panelMC["rankInfoMc_" + _loc3_].visible = true;
                  this.panelMC["rankInfoMc_" + _loc3_].txt_rank.htmlText = _loc3_ + 1;
                  this.panelMC["rankInfoMc_" + _loc3_].txt_name.htmlText = "[" + _loc4_.id + "] " + _loc4_.name;
                  this.panelMC["rankInfoMc_" + _loc3_].txt_reputation.htmlText = this.colorText(_loc4_.reputation,_loc12_);
                  this.panelMC["rankInfoMc_" + _loc3_].txt_gap.htmlText = this.colorText(_loc7_,_loc11_);
                  this.panelMC["rankInfoMc_" + _loc3_].txt_rp1s.htmlText = this.colorText(_loc8_,_loc12_);
                  this.panelMC["rankInfoMc_" + _loc3_].txt_rp1m.htmlText = this.colorText(_loc9_,_loc13_);
                  this.panelMC["rankInfoMc_" + _loc3_].txt_rp15m.htmlText = this.colorText(_loc10_,_loc14_);
                  param2.clans[_loc3_].gap = _loc7_;
                  this.oldR[param2.clans[_loc3_].id] = param2.clans[_loc3_];
               }
               _loc3_++;
            }
         }
      }
      
      private function onConnected(param1:* = null) : *
      {
         this.socket.emit("subscribe",{"channel":"clan.leaderboard"});
      }
      
      private function onDisconnected(param1:* = null, param2:* = null) : *
      {
      }
      
      private function onError(param1:*) : *
      {
         if(this.main != null)
         {
            this.main.getNotice("Failed to connect to \nReal Time Clan Leaderboard");
         }
      }
      
      private function colorText(param1:*, param2:* = "#ffff") : *
      {
         return "<font color=\"" + param2 + "\">" + param1 + "</font>";
      }
      
      public function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function cleanupSocket() : *
      {
         if(this.socket != null)
         {
            this.socket.off(Socket.EVENT_CONNECT,this.onConnected);
            this.socket.off(Socket.EVENT_DISCONNECT,this.onDisconnected);
            this.socket.off(Manager.EVENT_CLOSE,this.onError);
            this.socket.off("UpdateClanReputation",this.onData);
            this.socket.disconnect();
         }
         this.socket = null;
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         TweenLite.killTweensOf(this.panelMC);
         this.cleanupSocket();
         if(this.eventHandler != null)
         {
            this.eventHandler.removeAllEventListeners();
         }
         this.eventHandler = null;
         this.main = null;
         this.oldR = null;
         GF.removeAllChild(this);
         System.gc();
      }
   }
}

