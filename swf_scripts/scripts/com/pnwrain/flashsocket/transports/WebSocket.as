package com.pnwrain.flashsocket.transports
{
   import com.pnwrain.flashsocket.FlashSocket;
   import com.pnwrain.flashsocket.Transport;
   import com.pnwrain.flashsocket.events.FlashSocketEvent;
   import com.worlize.websocket.WebSocket;
   import com.worlize.websocket.WebSocketErrorEvent;
   import com.worlize.websocket.WebSocketEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class WebSocket extends Transport
   {
      
      private var webSocket:com.worlize.websocket.WebSocket;
      
      public function WebSocket(param1:Object)
      {
         super(param1);
         name = "websocket";
      }
      
      override public function open() : void
      {
         var _loc1_:ByteArray = null;
         super.open();
         var _loc2_:String = opts.protocol;
         var _loc3_:String = opts.host;
         var _loc4_:String = opts.query;
         var _loc5_:String = opts.sid;
         var _loc6_:String = (_loc2_ == "https" ? "wss" : "ws") + "://" + _loc3_ + "/socket.io/?EIO=3&transport=websocket" + (_loc5_ ? "&sid=" + _loc5_ : "") + (_loc4_ ? "&" + _loc4_ : "");
         var _loc7_:String = _loc2_ + "://" + _loc3_.toLowerCase();
         this.webSocket = new com.worlize.websocket.WebSocket(_loc6_,_loc7_,[_loc2_]);
         this.webSocket.debug = FlashSocket.debug;
         this.webSocket.addEventListener(WebSocketEvent.OPEN,this.onWSOpen);
         this.webSocket.addEventListener(WebSocketEvent.MESSAGE,this.onMessage);
         this.webSocket.addEventListener(WebSocketEvent.CLOSED,this.onWSClose);
         this.webSocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL,this.onConnectionFail);
         this.webSocket.addEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
         this.webSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         for each(_loc1_ in opts.certificates)
         {
            this.webSocket.addBinaryChainBuildingCertificate(_loc1_,true);
         }
         this.webSocket.connect();
      }
      
      override public function close() : void
      {
         if(readyState != "opening" && readyState != "open")
         {
            return;
         }
         var _loc1_:Boolean = this.webSocket.connected;
         this.webSocket.close();
         if(!_loc1_)
         {
            this.onWSClose(null);
         }
      }
      
      override public function send(param1:Array) : void
      {
         var i:Number;
         var packets:Array = param1;
         var type:int = 0;
         var data:* = undefined;
         var ba:ByteArray = null;
         writable = false;
         i = 0;
         while(i < packets.length)
         {
            type = int(typeCodes[packets[i].type]);
            data = packets[i].data || "";
            if(data is String)
            {
               this.webSocket.sendUTF(String(type) + data);
            }
            else
            {
               ba = new ByteArray();
               ba.writeByte(type);
               ba.writeBytes(data,0,data.length);
               this.webSocket.sendBytes(ba);
            }
            i++;
         }
         setTimeout(function():void
         {
            writable = true;
            _emit("drain");
         },0);
      }
      
      private function onWSOpen(param1:WebSocketEvent) : void
      {
         super.onOpen();
      }
      
      private function onMessage(param1:WebSocketEvent) : void
      {
         var _loc2_:Object = decodePacket(param1.message.type == "utf8" ? param1.message.utf8Data : param1.message.binaryData);
         FlashSocket.log("decoded packet",_loc2_,_loc2_.data is String);
         super.onPacket(_loc2_);
      }
      
      private function onWSClose(param1:WebSocketEvent) : void
      {
         super.onClose();
      }
      
      private function onConnectionFail(param1:Event) : void
      {
         super.onError(FlashSocketEvent.CONNECT_ERROR);
      }
      
      private function onIoError(param1:Event) : void
      {
         super.onError(FlashSocketEvent.IO_ERROR);
      }
      
      private function onSecurityError(param1:Event) : void
      {
         super.onError(FlashSocketEvent.SECURITY_ERROR);
      }
      
      override protected function cleanup() : void
      {
         if(this.webSocket)
         {
            this.webSocket.addEventListener(IOErrorEvent.IO_ERROR,function(param1:*):void
            {
            });
            this.webSocket.removeEventListener(WebSocketEvent.OPEN,this.onWSOpen);
            this.webSocket.removeEventListener(WebSocketEvent.MESSAGE,this.onMessage);
            this.webSocket.removeEventListener(WebSocketEvent.CLOSED,this.onWSClose);
            this.webSocket.removeEventListener(WebSocketErrorEvent.CONNECTION_FAIL,this.onIoError);
            this.webSocket.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
            this.webSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.webSocket = null;
         }
      }
   }
}

