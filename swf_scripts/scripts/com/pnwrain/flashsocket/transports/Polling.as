package com.pnwrain.flashsocket.transports
{
   import com.pnwrain.flashsocket.FlashSocket;
   import com.pnwrain.flashsocket.Transport;
   import com.pnwrain.flashsocket.Yeast;
   import com.pnwrain.flashsocket.events.FlashSocketEvent;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class Polling extends Transport
   {
      
      private var polling:Boolean = false;
      
      private var pollLoader:URLLoader;
      
      private var sendLoader:URLLoader;
      
      private var yeast:Yeast = new Yeast();
      
      public function Polling(param1:Object)
      {
         super(param1);
         name = "polling";
         pausable = true;
      }
      
      override public function open() : void
      {
         super.open();
         this.poll();
      }
      
      private function request(param1:* = null) : URLRequest
      {
         var _loc2_:String = opts.protocol;
         var _loc3_:String = opts.host;
         var _loc4_:String = opts.query;
         var _loc5_:String = opts.sid;
         var _loc6_:URLRequest = new URLRequest();
         _loc6_.method = param1 ? "POST" : "GET";
         _loc6_.contentType = "application/octet-stream";
         _loc6_.data = param1;
         _loc6_.url = _loc2_ + "://" + _loc3_ + "/socket.io/?EIO=3&transport=polling" + "&t=" + this.yeast.next() + (_loc5_ ? "&sid=" + _loc5_ : "") + (_loc4_ ? "&" + _loc4_ : "");
         return _loc6_;
      }
      
      private function poll() : void
      {
         this.polling = true;
         FlashSocket.log("polling");
         this.pollLoader = new URLLoader();
         this.pollLoader.dataFormat = "binary";
         this.pollLoader.addEventListener(Event.COMPLETE,this.onPollData);
         this.pollLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onPollHttpStatus);
         this.pollLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
         this.pollLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.pollLoader.load(this.request());
      }
      
      override public function close() : void
      {
         FlashSocket.log("Polling.close",readyState);
         if(readyState == "opening")
         {
            once("open",function(param1:*):void
            {
               close();
            });
         }
         else if(readyState == "open")
         {
            this.send([{"type":"close"}]);
            readyState = "closing";
            once("drain",function(param1:Event):void
            {
               FlashSocket.log("Polling: close message send, closing");
               onClose();
            });
         }
      }
      
      override public function send(param1:Array) : void
      {
         if(readyState != "open" && readyState != "opening")
         {
            return;
         }
         writable = false;
         var _loc2_:ByteArray = this.encodePayload(param1);
         this.sendLoader = new URLLoader();
         this.sendLoader.dataFormat = "binary";
         this.sendLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onSendHttpStatus);
         this.sendLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
         this.sendLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.sendLoader.load(this.request(_loc2_));
      }
      
      override public function pause(param1:Function) : void
      {
         var cb:Function = param1;
         var total:int = 0;
         var pause:Function = function():void
         {
            FlashSocket.log("paused");
            readyState = "paused";
            cb();
         };
         readyState = "pausing";
         if(this.polling || !writable)
         {
            total = 0;
            if(this.polling)
            {
               FlashSocket.log("we are currently polling - waiting to pause");
               total++;
               once("pollComplete",function(param1:*):void
               {
                  FlashSocket.log("pre-pause polling complete");
                  --total || pause();
               });
            }
            if(!writable)
            {
               FlashSocket.log("we are currently writing - waiting to pause");
               total++;
               once("drain",function(param1:*):void
               {
                  FlashSocket.log("pre-pause writing complete");
                  --total || pause();
               });
            }
         }
         else
         {
            pause();
         }
      }
      
      private function onPollData(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = this.decodePayload(param1.target.data);
         for each(_loc2_ in _loc3_)
         {
            FlashSocket.log("polling decoded packet ",_loc2_,_loc2_.data is String);
            if("close" == _loc2_.type)
            {
               super.onClose();
               return;
            }
            super.onPacket(_loc2_);
            if("open" == _loc2_.type)
            {
               super.onOpen();
            }
         }
         if("closed" != readyState)
         {
            this.polling = false;
            _emit("pollComplete");
            if("open" == readyState)
            {
               this.poll();
            }
            else
            {
               FlashSocket.log("stopping poll - transport state ",readyState);
            }
         }
      }
      
      private function onPollHttpStatus(param1:HTTPStatusEvent) : void
      {
         if(param1.status != 200)
         {
            super.onError(FlashSocketEvent.CONNECT_ERROR);
         }
      }
      
      private function onSendHttpStatus(param1:HTTPStatusEvent) : void
      {
         if(param1.status == 200)
         {
            writable = true;
            _emit("drain");
         }
         else
         {
            super.onError(FlashSocketEvent.IO_ERROR);
         }
      }
      
      private function onIoError(param1:Event) : void
      {
         super.onError(FlashSocketEvent.IO_ERROR);
      }
      
      private function onSecurityError(param1:Event) : void
      {
         super.onError(FlashSocketEvent.SECURITY_ERROR);
      }
      
      private function encodePayload(param1:Array) : ByteArray
      {
         var ba:ByteArray = null;
         var packets:Array = param1;
         ba = null;
         var packet:Object = null;
         var data:* = undefined;
         var utf8:ByteArray = null;
         var writeLength:Function = function(param1:int):void
         {
            var _loc2_:String = "" + param1;
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_.length)
            {
               ba.writeByte(int(_loc2_.charAt(_loc3_)));
               _loc3_++;
            }
            ba.writeByte(255);
         };
         ba = new ByteArray();
         for each(packet in packets)
         {
            data = packet.data;
            if(data is ByteArray)
            {
               ba.writeByte(1);
               writeLength(1 + data.length);
               ba.writeByte(typeCodes[packet.type]);
               ba.writeBytes(data);
            }
            else
            {
               utf8 = new ByteArray();
               utf8.writeUTFBytes(typeCodes[packet.type] + (data || ""));
               ba.writeByte(0);
               writeLength(utf8.length);
               ba.writeBytes(utf8);
            }
         }
         return ba;
      }
      
      private function decodePayload(param1:ByteArray) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:Array = [];
         while(param1.bytesAvailable)
         {
            _loc2_ = int(param1.readUnsignedByte());
            _loc3_ = "";
            while(true)
            {
               _loc4_ = int(param1.readUnsignedByte());
               if(_loc4_ == 255)
               {
                  break;
               }
               _loc3_ += String(_loc4_);
            }
            _loc5_ = int(_loc3_);
            if(_loc2_)
            {
               _loc6_ = new ByteArray();
               param1.readBytes(_loc6_,0,_loc5_);
            }
            else
            {
               _loc6_ = param1.readUTFBytes(_loc5_);
            }
            _loc7_.push(decodePacket(_loc6_));
         }
         return _loc7_;
      }
      
      override protected function cleanup() : void
      {
         if(this.pollLoader)
         {
            this.pollLoader.addEventListener(IOErrorEvent.IO_ERROR,function(param1:*):void
            {
            });
            this.pollLoader.removeEventListener(Event.COMPLETE,this.onPollData);
            this.pollLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onPollHttpStatus);
            this.pollLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
            this.pollLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.pollLoader = null;
         }
         if(this.sendLoader)
         {
            this.sendLoader.addEventListener(IOErrorEvent.IO_ERROR,function(param1:*):void
            {
            });
            this.sendLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onSendHttpStatus);
            this.sendLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
            this.sendLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.sendLoader = null;
         }
      }
   }
}

