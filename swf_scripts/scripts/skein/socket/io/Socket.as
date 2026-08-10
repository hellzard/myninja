package skein.socket.io
{
   import com.brokenfunction.json.decodeJson;
   import com.brokenfunction.json.encodeJson;
   import skein.emitter.Emitter;
   import skein.logger.Log;
   import skein.socket.io.parser.Packet;
   import skein.socket.io.parser.Parser;
   import skein.utils.StringUtil;
   
   public class Socket extends Emitter
   {
      
      public static const EVENT_CONNECT:String = "connect";
      
      public static const EVENT_DISCONNECT:String = "disconnect";
      
      public static const EVENT_ERROR:String = "error";
      
      public static const EVENT_MESSAGE:String = "message";
      
      private static const events:Array = [EVENT_CONNECT,EVENT_DISCONNECT,EVENT_ERROR];
      
      public var connected:Boolean;
      
      public var disconnected:Boolean = true;
      
      private var ids:int;
      
      internal var nsp:String;
      
      private var io:Manager;
      
      private var acks:Object = {};
      
      private var subs:Array = [];
      
      private var buffer:Array = [];
      
      public function Socket(param1:Manager, param2:String)
      {
         super();
         this.io = param1;
         this.nsp = param2;
      }
      
      private static function toJsonArray(param1:Array) : String
      {
         return encodeJson(param1);
      }
      
      private static function fromJsonArray(param1:String) : Array
      {
         return decodeJson(param1) as Array;
      }
      
      override public function emit(param1:String, ... rest) : Emitter
      {
         var _loc3_:Packet = null;
         var _loc4_:Function = null;
         if(events.indexOf(param1) != -1)
         {
            rest.unshift(param1);
            super.emit.apply(this,rest);
         }
         else if(rest[rest.length - 1] is Function)
         {
            _loc4_ = rest.pop() as Function;
            rest.unshift(param1);
            Log.d("socket.io",StringUtil.substitute("emitting packet with ack id {0}",this.ids));
            _loc3_ = new Packet(Parser.EVENT,rest);
            this.acks[this.ids] = _loc4_;
            _loc3_.id = this.ids++;
            this.packet(_loc3_);
         }
         else
         {
            rest.unshift(param1);
            _loc3_ = new Packet(Parser.EVENT,rest);
            this.packet(_loc3_);
         }
         return this;
      }
      
      public function connect() : void
      {
         this.open();
      }
      
      public function open() : void
      {
         var handle:OnHandle = null;
         for each(handle in this.subs)
         {
            handle.destroy();
         }
         this.subs.length = 0;
         this.subs.push(On.on(this.io,Manager.EVENT_OPEN,function():void
         {
            onopen();
         }));
         this.subs.push(On.on(this.io,Manager.EVENT_ERROR,function(param1:Error = null):void
         {
            onerror(param1);
         }));
         this.subs.push(On.on(this.io,Manager.EVENT_PACKET,function(param1:Packet):void
         {
            onpacket(param1);
         }));
         this.subs.push(On.on(this.io,Manager.EVENT_CLOSE,function(param1:String = null):void
         {
            onclose(param1);
         }));
         if(this.io.readyState == Manager.OPEN)
         {
            this.onopen();
         }
         this.io.open();
      }
      
      public function close() : void
      {
         if(!this.connected)
         {
            return;
         }
         Log.d("socket.io",StringUtil.substitute("performing disconnect ({0})",this.nsp));
         this.packet(new Packet(Parser.DISCONNECT));
         this.destroy();
         this.onclose("io client disconnect");
      }
      
      public function disconnect() : void
      {
         this.close();
      }
      
      public function send(... rest) : Socket
      {
         rest.unshift(EVENT_MESSAGE);
         this.emit.apply(this,rest);
         return this;
      }
      
      private function packet(param1:Packet) : void
      {
         param1.nsp = this.nsp;
         this.io.packet(param1);
      }
      
      private function onopen() : void
      {
         Log.d("socket.io","transport is open - connecting");
         if(this.nsp != "/" || Parser.protocol >= 3)
         {
            this.packet(new Packet(Parser.CONNECT));
         }
      }
      
      private function onclose(param1:String) : void
      {
         this.connected = false;
         this.disconnected = true;
         this.acks = {};
         this.buffer.length = 0;
         this.emit(EVENT_DISCONNECT,param1);
      }
      
      private function onerror(param1:Error) : void
      {
         this.emit(EVENT_ERROR,param1);
      }
      
      private function onpacket(param1:Packet) : void
      {
         if(this.nsp != param1.nsp)
         {
            return;
         }
         switch(param1.type)
         {
            case Parser.CONNECT:
               this.onconnect();
               break;
            case Parser.EVENT:
               this.onevent(param1);
               break;
            case Parser.ACK:
               this.onack(param1);
               break;
            case Parser.DISCONNECT:
               this.ondisconnect();
               break;
            case Parser.CONNECT_ERROR:
               this.emit(EVENT_ERROR,param1.data);
               break;
            case Parser.BINARY_EVENT:
            case Parser.BINARY_ACK:
               this.emit(EVENT_ERROR,"binary packets are not supported");
         }
      }
      
      private function onevent(param1:Packet) : void
      {
         var _loc2_:Array = param1.data as Array;
         if(param1.id >= 0)
         {
            Log.d("socket.io","attaching ack callback to event");
            _loc2_.push(this.ack(param1.id));
         }
         if(this.connected)
         {
            super.emit.apply(this,_loc2_);
         }
         else
         {
            this.buffer.push(_loc2_);
         }
      }
      
      private function ack(param1:int) : Ack
      {
         var self:Socket = null;
         var sent:Boolean = false;
         var id:int = param1;
         self = this;
         sent = false;
         return new Ack(function(... rest):void
         {
            if(sent)
            {
               return;
            }
            sent = true;
            Log.d("socket.io",StringUtil.substitute("sending ack {0}",rest));
            var _loc2_:* = new Packet(Parser.ACK,rest);
            _loc2_.id = id;
            self.packet(_loc2_);
         });
      }
      
      private function onack(param1:Packet) : void
      {
         Log.d("socket.io",StringUtil.substitute("calling ack {0} with {1}",param1.id,param1.data));
         var _loc2_:Function = this.acks[param1.id];
         this.acks[param1.id] = null;
         delete this.acks[param1.id];
         _loc2_.apply(null,param1.data);
      }
      
      private function onconnect() : void
      {
         this.connected = true;
         this.disconnected = false;
         this.acks = {};
         this.emit(EVENT_CONNECT);
         this.emitBuffered();
      }
      
      private function emitBuffered() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         while(true)
         {
            _loc1_ = this.buffer.shift();
            if(_loc1_ == null)
            {
               break;
            }
            _loc2_ = _loc1_.shift();
            this.emit(_loc2_,_loc1_);
         }
      }
      
      private function ondisconnect() : void
      {
         Log.d("socket.io",StringUtil.substitute("server disconnect ({0})",this.nsp));
         this.destroy();
         this.onclose("io server disconnect");
      }
      
      private function destroy() : void
      {
         var _loc1_:OnHandle = null;
         Log.d("socket.io",StringUtil.substitute("destroying socket ({0})",this.nsp));
         for each(_loc1_ in this.subs)
         {
            _loc1_.destroy();
         }
         this.io.destroy(this);
      }
   }
}

