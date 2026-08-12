package com.pnwrain.flashsocket
{
   import com.pnwrain.flashsocket.events.EventEmitter;
   import com.pnwrain.flashsocket.events.FlashSocketEvent;
   import com.pnwrain.flashsocket.transports.Polling;
   import com.pnwrain.flashsocket.transports.WebSocket;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class Transport extends EventEmitter
   {
      
      protected static const typeCodes:Object = {
         "open":0,
         "close":1,
         "ping":2,
         "pong":3,
         "message":4,
         "upgrade":5,
         "noop":6
      };
      
      protected static const typeNames:Array = ["open","close","ping","pong","message","upgrade","noop"];
       
      
      public var name:String;
      
      protected var readyState:String;
      
      public var opts:Object;
      
      public var writable:Boolean = false;
      
      public var pausable:Boolean = false;
      
      private var connectTimeoutTimer:int = 0;
      
      public function Transport(param1:Object)
      {
         super();
         this.opts = param1;
      }
      
      public static function create(param1:String, param2:Object) : Transport
      {
         return param1 == "polling" ? new Polling(param2) : new WebSocket(param2);
      }
      
      public function open() : void
      {
         this.readyState = "opening";
         this.connectTimeoutTimer = setTimeout(this.onConnectTimeout,Number(Number(this.opts.connectTimeout)) || Number(Number(20000)));
      }
      
      public function close() : void
      {
      }
      
      public function send(param1:Array) : void
      {
      }
      
      public function pause(param1:Function) : void
      {
      }
      
      protected function decodePacket(param1:*) : Object
      {
         var _loc2_:Object = {};
         if(param1 is ByteArray)
         {
            _loc2_.type = typeNames[param1.readUnsignedByte()];
            param1.position = 0;
            param1.writeBytes(param1,1,param1.length - 1);
            --param1.length;
            param1.position = 0;
            _loc2_.data = param1;
         }
         else
         {
            _loc2_.type = typeNames[int(param1.charAt(0))];
            _loc2_.data = param1.substr(1);
         }
         return _loc2_;
      }
      
      private function onConnectTimeout() : void
      {
         this.onError(FlashSocketEvent.CONNECT_ERROR);
      }
      
      protected function cleanup() : void
      {
      }
      
      protected function onOpen() : void
      {
         this.readyState = "open";
         this.writable = true;
         clearTimeout(this.connectTimeoutTimer);
         _emit("open");
      }
      
      protected function onClose() : void
      {
         this.writable = false;
         this.readyState = "closed";
         clearTimeout(this.connectTimeoutTimer);
         this.cleanup();
         _emit("close");
      }
      
      protected function onPacket(param1:Object) : void
      {
         _emit("packet",param1);
      }
      
      protected function onError(param1:String) : void
      {
         FlashSocket.log("transport error",param1);
         this.writable = false;
         this.readyState = "closed";
         clearTimeout(this.connectTimeoutTimer);
         this.cleanup();
         _emit("error",param1);
      }
   }
}
