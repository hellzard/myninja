package skein.engine.io.client
{
   import com.adobe.net.URI;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import skein.emitter.Emitter;
   import skein.engine.io.client.transport.Polling;
   import skein.engine.io.client.transport.PollingXHR;
   import skein.engine.io.client.transport.WebSocketTransport;
   import skein.engine.io.parser.HandshakeData;
   import skein.engine.io.parser.Packet;
   import skein.engine.io.parser.Parser;
   import skein.logger.Log;
   import skein.utils.StringUtil;
   
   public class Engine extends Emitter
   {
      
      public static const EVENT_OPEN:String = "open";
      
      public static const EVENT_CLOSE:String = "close";
      
      public static const EVENT_MESSAGE:String = "message";
      
      public static const EVENT_ERROR:String = "error";
      
      public static const EVENT_UPGRADE_ERROR:String = "upgradeError";
      
      public static const EVENT_FLUSH:String = "flush";
      
      public static const EVENT_DRAIN:String = "drain";
      
      public static const OPENING:String = "opening";
      
      public static const OPEN:String = "open";
      
      public static const CLOSING:String = "closing";
      
      public static const CLOSED:String = "closed";
      
      public static const EVENT_HANDSHAKE:String = "handshake";
      
      public static const EVENT_UPGRADING:String = "upgrading";
      
      public static const EVENT_UPGRADE:String = "upgrade";
      
      public static const EVENT_PACKET:String = "packet";
      
      public static const EVENT_PACKET_CREATE:String = "packetCreate";
      
      public static const EVENT_HEARTBEAT:String = "heartbeat";
      
      public static const EVENT_DATA:String = "data";
      
      public static const EVENT_TRANSPORT:String = "transport";
       
      
      private var secure:Boolean;
      
      private var upgrade:Boolean;
      
      private var timestampRequests:Boolean;
      
      private var upgrading:Boolean;
      
      private var port:int;
      
      private var policyPort:int;
      
      private var prevBufferLen:int;
      
      private var pingInterval:Number;
      
      private var pingTimeout:Number;
      
      private var id:String;
      
      private var hostname:String;
      
      private var path:String;
      
      private var timestampParam:String;
      
      private var transports:Vector.<String>;
      
      private var upgrades:Vector.<String>;
      
      private var query:Object;
      
      private var writeBuffer:Array;
      
      private var callbackBuffer:Array;
      
      private var transport:Transport;
      
      private var pingTimeoutTimer:Timer;
      
      private var pingIntervalTimer:Timer;
      
      private var readyState:String;
      
      public function Engine(param1:Object, param2:SocketOptions = null)
      {
         var _loc3_:Array = null;
         this.writeBuffer = [];
         this.callbackBuffer = [];
         super();
         if(param1 is String)
         {
            param1 = new URI(param1 as String);
         }
         param2 = SocketOptions.fromURI(URI(param1),param2);
         if(param2.host != null)
         {
            _loc3_ = param2.host.split(":");
            param2.hostname = _loc3_[0];
            if(_loc3_.length > 1)
            {
               param2.port = parseInt(_loc3_[_loc3_.length - 1]);
            }
         }
         this.secure = param2.secure;
         this.hostname = param2.hostname != null ? param2.hostname : "localhost";
         this.port = param2.port != 0 ? int(param2.port) : (!!this.secure ? 443 : 80);
         this.query = param2.query || {};
         this.upgrade = param2.upgrade;
         this.path = (param2.path != null ? param2.path : "/engine.io").replace("/$/g","") + "/";
         this.timestampParam = param2.timestampParam != null ? param2.timestampParam : "t";
         this.timestampRequests = param2.timestampRequests;
         this.transports = Vector.<String>(param2.transports as Array || [WebSocketTransport.NAME]);
         this.policyPort = param2.policyPort != 0 ? int(param2.policyPort) : 843;
      }
      
      public function open() : void
      {
         var _loc1_:String = this.transports[0];
         this.readyState = OPENING;
         var _loc2_:Transport = this.createTransport(_loc1_);
         this.setTransport(_loc2_);
         _loc2_.open();
      }
      
      public function close() : Engine
      {
         if(this.readyState == OPENING || this.readyState == OPEN)
         {
            this.onClose("forced close");
            Log.d("engine.io","socket closing - telling transport to close");
            this.transport.close();
         }
         return this;
      }
      
      public function write(param1:String, param2:Function = null) : void
      {
         this.send(param1,param2);
      }
      
      public function send(param1:String, param2:Function = null) : void
      {
         this.sendPacket(Packet.MESSAGE,param1,param2);
      }
      
      private function createTransport(param1:String) : Transport
      {
         var _loc3_:* = null;
         Log.d("engine.io",StringUtil.substitute("creating transport \'{0}\'",param1));
         var _loc2_:Object = {};
         for(_loc3_ in this.query)
         {
            _loc2_[_loc3_] = this.query[_loc3_];
         }
         _loc2_["EIO"] = Parser.protocol;
         _loc2_["transport"] = param1;
         if(this.id)
         {
            _loc2_["sid"] = this.id;
         }
         var _loc4_:TransportOptions;
         (_loc4_ = new TransportOptions()).hostname = this.hostname;
         _loc4_.port = this.port;
         _loc4_.secure = this.secure;
         _loc4_.path = this.path;
         _loc4_.query = _loc2_;
         _loc4_.timestampRequests = this.timestampRequests;
         _loc4_.timestampParam = this.timestampParam;
         _loc4_.policyPort = this.policyPort;
         if(param1 == WebSocketTransport.NAME)
         {
            return new WebSocketTransport(_loc4_);
         }
         if(param1 == Polling.NAME)
         {
            return new PollingXHR(_loc4_);
         }
         throw new Error();
      }
      
      private function setTransport(param1:Transport) : void
      {
         var transport:Transport = param1;
         Log.d("engine.io",StringUtil.substitute("setting transport {0}",transport.name));
         if(this.transport)
         {
            Log.d("engine.io",StringUtil.substitute("clearing existing transport {0}",this.transport.name));
            this.transport.off();
         }
         this.transport = transport;
         emit(EVENT_TRANSPORT,transport);
         this.transport.on(Transport.EVENT_DRAIN,function(... rest):void
         {
            onDrain();
         });
         this.transport.on(Transport.EVENT_PACKET,function(param1:Packet):void
         {
            onPacket(param1);
         });
         this.transport.on(Transport.EVENT_ERROR,function(param1:Error = null):void
         {
            onError(param1);
         });
         this.transport.on(Transport.EVENT_CLOSE,function(... rest):void
         {
            onClose("transport close");
         });
      }
      
      private function probe(param1:String) : void
      {
         var transport:Transport = null;
         var failed:Boolean = false;
         var self:Engine = null;
         var onerror:Function = null;
         var name:String = param1;
         Log.d("engine.io",StringUtil.substitute("probing transport {0}",name));
         transport = this.createTransport(name);
         failed = false;
         self = this;
         onerror = function(param1:Error = null):void
         {
            if(failed)
            {
               return;
            }
            failed = true;
            transport.close();
            emit(EVENT_UPGRADE_ERROR,param1);
         };
         transport.once(Transport.EVENT_OPEN,function(... rest):void
         {
            if(failed)
            {
               return;
            }
            Log.d("engine.io",StringUtil.substitute("probe transport \'{0}\' opened",name));
            var packet:Packet = new Packet(Packet.PING,"probe");
            transport.send([packet]);
            transport.once(Transport.EVENT_PACKET,function(... rest):void
            {
               if(failed)
               {
                  return;
               }
               var msg:Packet = rest[0];
               if(msg.type == Packet.PONG && msg.data == "probe")
               {
                  Log.d("engine.io",StringUtil.substitute("probe transport \'%s\' pong",name));
                  upgrading = true;
                  emit(EVENT_UPGRADING,transport);
                  Log.d("engine.io",StringUtil.substitute("pausing current transport {0}",self.transport.name));
                  Polling(self.transport).pause(function():void
                  {
                     if(failed)
                     {
                        return;
                     }
                     if(readyState == CLOSED || readyState == CLOSING)
                     {
                        return;
                     }
                     Log.d("engine.io","changing transport and sending upgrade packet");
                     transport.off(Transport.EVENT_ERROR,onerror);
                     emit(EVENT_UPGRADE,transport);
                     setTransport(transport);
                     var _loc1_:Packet = new Packet(Packet.UPGRADE);
                     transport.send([_loc1_]);
                     transport = null;
                     upgrading = false;
                     flush();
                  });
               }
               else
               {
                  Log.d("engine.io",StringUtil.substitute("probe transport \'{0}\' failed",name));
                  emit(EVENT_UPGRADE_ERROR,new Error("probe error"));
               }
            });
         });
         transport.once(Transport.EVENT_ERROR,onerror);
         transport.once(Transport.EVENT_CLOSE,function(... rest):void
         {
            if(transport)
            {
               Log.d("engine.io","socket closed prematurely - aborting probe");
               failed = true;
               transport.close();
               transport = null;
            }
         });
         this.once(EVENT_UPGRADING,function(param1:Transport = null):void
         {
            if(param1 != null && param1.name != transport.name)
            {
               Log.d("engine.io",StringUtil.substitute("\'{0}\' works - aborting \'{1}\'",param1.name,transport[0].name));
               transport.close();
               transport = null;
            }
         });
         transport.open();
      }
      
      private function setPing() : void
      {
         if(this.pingIntervalTimer)
         {
            this.pingIntervalTimer.stop();
            this.pingIntervalTimer.removeEventListener(TimerEvent.TIMER,this.pingIntervalTimer_timerHandler);
         }
         this.pingIntervalTimer = new Timer(this.pingInterval);
         this.pingIntervalTimer.addEventListener(TimerEvent.TIMER,this.pingIntervalTimer_timerHandler);
         this.pingIntervalTimer.start();
      }
      
      private function ping() : void
      {
         this.sendPacket(Packet.PING);
      }
      
      private function flush() : void
      {
         if(this.readyState != CLOSED && this.transport.writable && !this.upgrading && this.writeBuffer.length > 0)
         {
            this.prevBufferLen = this.writeBuffer.length;
            this.transport.send(this.writeBuffer);
            emit(EVENT_FLUSH);
         }
      }
      
      private function sendPacket(param1:String, param2:String = null, param3:Function = null) : *
      {
         var _loc4_:Packet = new Packet(param1,param2);
         emit(EVENT_PACKET_CREATE,_loc4_);
         this.writeBuffer.push(_loc4_);
         this.callbackBuffer.push(param3);
         this.flush();
      }
      
      public function onopen() : void
      {
      }
      
      public function onmessage(param1:String) : void
      {
      }
      
      public function onclose() : void
      {
      }
      
      public function onerror(param1:Error) : void
      {
      }
      
      private function onOpen() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         Log.d("engine.io","socket open");
         this.readyState = OPEN;
         this.emit(EVENT_OPEN);
         this.onopen();
         this.flush();
         if(this.readyState == OPEN && this.upgrade && this.transport is Polling)
         {
            Log.d("engine.io","starting upgrade probes");
            _loc1_ = 0;
            _loc2_ = this.upgrades.length;
            while(_loc1_ < _loc2_)
            {
               this.probe(this.upgrades[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      private function onPacket(param1:Packet) : void
      {
         if(this.readyState == OPENING || this.readyState == OPEN)
         {
            this.emit(EVENT_PACKET,param1);
            switch(param1.type)
            {
               case Packet.OPEN:
                  this.onHandshake(HandshakeData.parse(param1.data));
                  break;
               case Packet.PING:
                  if(Parser.protocol == 3)
                  {
                     return;
                  }
                  this.sendPacket(Packet.PONG);
                  this.emit(EVENT_HEARTBEAT);
                  break;
               case Packet.PONG:
                  if(Parser.protocol != 3)
                  {
                     return;
                  }
                  this.setPing();
                  this.emit(EVENT_HEARTBEAT);
                  break;
               case Packet.ERROR:
                  emit(EVENT_ERROR,new Error("serve error"));
                  break;
               case Packet.MESSAGE:
                  emit(EVENT_DATA,param1.data);
                  emit(EVENT_MESSAGE,param1.data);
                  this.onmessage(param1.data);
            }
         }
         else
         {
            Log.d("engine.io",StringUtil.substitute("packet received with socket readyState \'{0}\'",this.readyState));
         }
      }
      
      private function onHandshake(param1:HandshakeData) : *
      {
         this.emit(EVENT_HANDSHAKE,param1);
         this.id = param1.sid;
         this.transport.query["sid"] = param1.sid;
         this.upgrades = this.filterUpgrades(param1.upgrades);
         this.pingInterval = param1.pingInterval;
         this.pingTimeout = param1.pingTimeout;
         this.off(EVENT_HEARTBEAT,this.onHeartbeat);
         this.on(EVENT_HEARTBEAT,this.onHeartbeat);
         if(Parser.protocol == 3)
         {
            this.setPing();
         }
         else
         {
            this.onHeartbeat();
         }
         this.onOpen();
      }
      
      private function onHeartbeat(param1:Number = 0) : void
      {
         if(this.pingTimeoutTimer)
         {
            this.pingTimeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.pingTimeoutTimer_timerCompleteHandler);
            this.pingTimeoutTimer.stop();
         }
         if(param1 <= 0)
         {
            param1 = this.pingInterval + Math.min(this.pingTimeout,10000);
         }
         this.pingTimeoutTimer = new Timer(param1,1);
         this.pingTimeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.pingTimeoutTimer_timerCompleteHandler);
         this.pingTimeoutTimer.start();
      }
      
      private function onDrain() : void
      {
         var _loc2_:Function = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.prevBufferLen)
         {
            _loc2_ = this.callbackBuffer[_loc1_];
            if(_loc2_ != null)
            {
               _loc2_.apply();
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.prevBufferLen)
         {
            this.writeBuffer.shift();
            this.callbackBuffer.shift();
            _loc1_++;
         }
         this.prevBufferLen = 0;
         if(this.writeBuffer.length == 0)
         {
            emit(EVENT_DRAIN);
         }
         else
         {
            this.flush();
         }
      }
      
      private function onError(param1:Error) : void
      {
         Log.d("engine.io","socket error " + param1);
         emit(EVENT_ERROR);
         this.onerror(param1);
         this.onClose("transport error",param1);
      }
      
      private function onClose(param1:String, param2:Error = null) : void
      {
         var _loc3_:String = null;
         if(this.readyState == OPENING || this.readyState == OPEN)
         {
            if(this.pingIntervalTimer != null)
            {
               this.pingIntervalTimer.removeEventListener(TimerEvent.TIMER,this.pingIntervalTimer_timerHandler);
               this.pingIntervalTimer.stop();
            }
            if(this.pingTimeoutTimer != null)
            {
               this.pingTimeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.pingTimeoutTimer_timerCompleteHandler);
               this.pingTimeoutTimer.stop();
            }
            this.writeBuffer.length = 0;
            this.callbackBuffer.length = 0;
            this.prevBufferLen = 0;
            this.transport.off();
            _loc3_ = this.readyState;
            this.readyState = CLOSED;
            this.id = null;
            if(_loc3_ == OPEN)
            {
               emit(EVENT_CLOSE,param1,param2);
               this.onclose();
            }
         }
      }
      
      function filterUpgrades(param1:Array) : Vector.<String>
      {
         var _loc3_:String = null;
         var _loc2_:Vector.<String> = new Vector.<String>(0);
         for each(_loc3_ in param1)
         {
            if(this.transports.indexOf(_loc3_) != -1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function pingIntervalTimer_timerHandler(param1:TimerEvent) : void
      {
         this.ping();
         this.onHeartbeat(this.pingTimeout);
      }
      
      private function pingTimeoutTimer_timerCompleteHandler(param1:TimerEvent) : void
      {
         if(this.readyState != CLOSED)
         {
            this.onClose("ping timeout");
         }
      }
   }
}
