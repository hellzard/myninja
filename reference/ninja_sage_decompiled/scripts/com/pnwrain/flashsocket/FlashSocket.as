package com.pnwrain.flashsocket
{
   import com.adobe.net.URI;
   import com.pnwrain.flashsocket.events.EventEmitter;
   import com.pnwrain.flashsocket.events.FlashSocketEvent;
   import flash.external.ExternalInterface;
   import flash.utils.ByteArray;
   import socket.io.parser.Decoder;
   import socket.io.parser.Encoder;
   import socket.io.parser.Parser;
   import socket.io.parser.ParserEvent;
   
   public class FlashSocket extends EventEmitter
   {
      
      public static var debug:Boolean = false;
       
      
      public var name:String;
      
      private var opts:Object;
      
      private var _uri:String;
      
      private var engine:Engine;
      
      private var ackId:int = 0;
      
      private var acks:Object;
      
      private var _receiveBuffer:Array;
      
      public var connected:Boolean;
      
      public var connecting:Boolean;
      
      private var encoder:Encoder;
      
      private var decoder:Decoder;
      
      public function FlashSocket(param1:String, param2:Object = null)
      {
         this.acks = {};
         this._receiveBuffer = [];
         super();
         this.opts = param2 || {};
         this.uri = param1;
         this.encoder = new Encoder();
         this.decoder = new Decoder();
         this.decoder.addEventListener(ParserEvent.DECODED,this.onDecoded);
         this.open();
      }
      
      public static function log(... rest) : void
      {
         if(!debug)
         {
            return;
         }
         if(ExternalInterface.available)
         {
            rest.unshift("console.log");
            ExternalInterface.call.apply(ExternalInterface,rest);
         }
      }
      
      public static function error(param1:String) : void
      {
      }
      
      public static function fatal(param1:String) : void
      {
      }
      
      public function get uri() : String
      {
         return this._uri;
      }
      
      public function set uri(param1:String) : void
      {
         this._uri = param1;
         var _loc2_:URI = new URI(param1);
         this.opts.protocol = _loc2_.scheme;
         this.opts.host = _loc2_.authority + (!!_loc2_.port ? ":" + _loc2_.port : "");
         this.opts.query = _loc2_.query;
         this.opts.channel = _loc2_.path || "/";
      }
      
      public function get transport() : String
      {
         return this.engine && this.engine.transport ? this.engine.transport.name : null;
      }
      
      private function open() : void
      {
         this.connecting = true;
         this.engine = new Engine(this.opts);
         this.engine.on("data",this.onData);
         this.engine.on("close",this.onClose);
         this.engine.on("error",this.onError);
      }
      
      private function onData(param1:FlashSocketEvent) : void
      {
         this.decoder.add(param1.data);
      }
      
      private function onDecoded(param1:ParserEvent) : void
      {
         var packet:Object = null;
         var ev:ParserEvent = param1;
         var args:Array = null;
         packet = null;
         var func:Function = null;
         packet = ev.packet;
         switch(packet.type)
         {
            case Parser.CONNECT:
               if(packet.nsp == this.opts.channel)
               {
                  this.connected = true;
                  this.connecting = false;
                  _emit(FlashSocketEvent.CONNECT);
                  this.emitBuffered();
               }
               else
               {
                  this.sendPacket({
                     "type":Parser.CONNECT,
                     "nsp":this.opts.channel
                  });
               }
               break;
            case Parser.EVENT:
            case Parser.BINARY_EVENT:
               args = packet.data || [];
               if(null != packet.id)
               {
                  args.push(function(... rest):void
                  {
                     sendAck(rest,packet.id);
                  });
               }
               if(this.connected)
               {
                  _emit(args.shift(),args);
               }
               else
               {
                  this._receiveBuffer.push(args);
               }
               break;
            case Parser.ACK:
            case Parser.BINARY_ACK:
               args = packet.data || [];
               if(this.acks.hasOwnProperty(packet.id))
               {
                  func = this.acks[packet.id] as Function;
                  delete this.acks[packet.id];
                  if(args.length > func.length)
                  {
                     func.apply(null,args.slice(0,func.length));
                  }
                  else
                  {
                     func.apply(null,args);
                  }
               }
               break;
            case Parser.DISCONNECT:
               this.onClose();
               break;
            case Parser.ERROR:
               log("3: error: " + packet.data);
               _emit(FlashSocketEvent.ERROR,packet.data);
         }
      }
      
      private function onClose(param1:FlashSocketEvent = null) : void
      {
         log("engine closed",this.connecting,this.connected);
         var _loc2_:String = !!this.connected ? FlashSocketEvent.DISCONNECT : (!!this.connecting ? FlashSocketEvent.CONNECT_ERROR : null);
         this.destroy();
         if(_loc2_)
         {
            _emit(_loc2_);
         }
      }
      
      private function onError(param1:FlashSocketEvent = null) : void
      {
         _emit(param1.data);
         this.destroy();
      }
      
      private function sendPacket(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.encoder.encode(param1))
         {
            this.engine.sendPacket("message",_loc2_,null,false);
         }
         this.engine.flush();
      }
      
      public function emit(param1:String, param2:Object, param3:Function = null) : void
      {
         var _loc4_:int = 0;
         if(param2 as Array)
         {
            (param2 as Array).unshift(param1);
         }
         else
         {
            param2 = [param1,param2];
         }
         var _loc5_:Number = !!this.hasBin(param2) ? Number(Number(Parser.BINARY_EVENT)) : Number(Number(Parser.EVENT));
         var _loc6_:Object = {
            "type":_loc5_,
            "data":param2,
            "nsp":this.opts.channel
         };
         if(null != param3)
         {
            _loc4_ = this.ackId;
            this.acks[this.ackId] = param3;
            ++this.ackId;
            _loc6_.id = _loc4_;
         }
         this.sendPacket(_loc6_);
      }
      
      private function sendAck(param1:Array, param2:String) : void
      {
         this.sendPacket({
            "type":(!!this.hasBin(param1) ? Parser.BINARY_ACK : Parser.ACK),
            "data":param1,
            "nsp":this.opts.channel,
            "id":param2
         });
      }
      
      private function hasBin(param1:*) : Boolean
      {
         var _loc2_:* = undefined;
         if(param1 is ByteArray)
         {
            return true;
         }
         if(typeof param1 == "object")
         {
            for each(_loc2_ in param1)
            {
               if(this.hasBin(_loc2_))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function emitBuffered() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         if(!this.connected)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this._receiveBuffer.length)
         {
            _loc2_ = this._receiveBuffer[_loc1_] as Array;
            _emit(_loc2_.shift(),_loc2_);
            _loc1_++;
         }
         this._receiveBuffer = [];
      }
      
      public function destroy() : void
      {
         this.connecting = false;
         this.connected = false;
         if(this.engine)
         {
            this.engine.removeListener("data",this.onData);
            this.engine.removeListener("close",this.onClose);
            this.engine.removeListener("error",this.onError);
            this.engine.close();
            this.engine = null;
         }
         if(this.decoder)
         {
            this.decoder.removeEventListener(ParserEvent.DECODED,this.onDecoded);
            this.decoder.destroy();
            this.decoder = null;
         }
         this.encoder = null;
         this.acks = null;
         this.opts = null;
         this._receiveBuffer = null;
      }
      
      public function close() : void
      {
         if(this.connected || this.connecting)
         {
            this.engine.close();
         }
         else
         {
            this.destroy();
         }
      }
   }
}
