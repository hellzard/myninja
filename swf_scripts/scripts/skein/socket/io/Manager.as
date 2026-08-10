package skein.socket.io
{
   import com.adobe.net.URI;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import skein.emitter.Emitter;
   import skein.engine.io.client.Engine;
   import skein.logger.Log;
   import skein.socket.io.parser.Packet;
   import skein.socket.io.parser.Parser;
   import skein.utils.StringUtil;
   
   public class Manager extends Emitter
   {
      
      public static const CLOSED:String = "closed";
      
      public static const OPENING:String = "opening";
      
      public static const OPEN:String = "open";
      
      public static const EVENT_OPEN:String = "open";
      
      public static const EVENT_CLOSE:String = "close";
      
      public static const EVENT_PACKET:String = "packet";
      
      public static const EVENT_ERROR:String = "error";
      
      public static const EVENT_CONNECT_ERROR:String = "connectError";
      
      public static const EVENT_CONNECT_TIMEOUT:String = "connectTimeout";
      
      public static const EVENT_RECONNECT:String = "reconnect";
      
      public static const EVENT_RECONNECT_ERROR:String = "reconnectError";
      
      public static const EVENT_RECONNECT_FAILED:String = "reconnectFailed";
      
      internal var readyState:String;
      
      private var _reconnection:Boolean;
      
      private var skipReconnect:Boolean;
      
      private var reconnecting:Boolean;
      
      private var _reconnectionAttempts:int;
      
      private var _reconnectionDelay:Number;
      
      private var _reconnectionDelayMax:Number;
      
      private var _timeout:Number;
      
      private var connected:int;
      
      private var attempts:int;
      
      private var subs:Array = [];
      
      private var engine:Engine;
      
      private var nsps:Object = {};
      
      public function Manager(param1:URI, param2:Options)
      {
         super();
         param2 = this.initOptions(param2);
         this.engine = new Engine(param1,param2);
      }
      
      private function initOptions(param1:Options) : Options
      {
         if(param1 == null)
         {
            param1 = new Options();
         }
         if(param1.path == null)
         {
            param1.path = "/socket.io";
         }
         this.reconnection(param1.reconnection);
         this.reconnectionAttempts(param1.reconnectionAttempts || int.MAX_VALUE);
         this.reconnectionDelay(param1.reconnectionDelay || 1000);
         this.reconnectionDelayMax(param1.reconnectionDelayMax || 5000);
         this.timeout(param1.timeout < 0 ? 10000 : param1.timeout);
         return param1;
      }
      
      public function reconnection(param1:Boolean) : Manager
      {
         this._reconnection = param1;
         return this;
      }
      
      public function reconnectionAttempts(param1:int) : Manager
      {
         this._reconnectionAttempts = param1;
         return this;
      }
      
      public function reconnectionDelay(param1:Number) : Manager
      {
         this._reconnectionDelay = param1;
         return this;
      }
      
      public function reconnectionDelayMax(param1:Number) : Manager
      {
         this._reconnectionDelayMax = param1;
         return this;
      }
      
      public function timeout(param1:Number) : Manager
      {
         this._timeout = param1;
         return this;
      }
      
      public function open(param1:Function = null) : Manager
      {
         var errorSub:OnHandle;
         var openSub:OnHandle = null;
         var timeoutHandler:Function = null;
         var timer:Timer = null;
         var timeSub:OnHandle = null;
         var callback:Function = param1;
         if(this.readyState == OPEN)
         {
            return this;
         }
         if(this.readyState == OPENING)
         {
            this.cleanup();
         }
         this.readyState = OPENING;
         openSub = On.on(this.engine,Engine.EVENT_OPEN,function(... rest):void
         {
            onopen();
            if(callback != null)
            {
               callback();
            }
         });
         errorSub = On.on(this.engine,Engine.EVENT_ERROR,function(param1:Object = null):void
         {
            cleanup();
            emit(EVENT_CONNECT_ERROR,param1);
            if(callback != null)
            {
               callback(param1 as Error);
            }
         });
         if(this._timeout >= 0)
         {
            Log.d("socket.io",StringUtil.substitute("connection attempt will timeout after {0}",this._timeout));
            timeoutHandler = function(param1:Event):void
            {
               timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timeoutHandler);
               Log.e("socket.io",StringUtil.substitute("connect attempt timed out after {0}",_timeout));
               openSub.destroy();
               engine.close();
               engine.emit(Engine.EVENT_ERROR,new Error("timeout"));
               emit(EVENT_CONNECT_TIMEOUT,_timeout);
            };
            timer = new Timer(this._timeout,1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,timeoutHandler);
            timer.start();
            timeSub = new OnHandle(function():void
            {
               timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timeoutHandler);
               timer.stop();
            });
            this.subs.push(timeSub);
         }
         this.subs.push(openSub);
         this.subs.push(errorSub);
         this.engine.open();
         return this;
      }
      
      public function socket(param1:String) : Socket
      {
         var nsp:String = param1;
         var socket:Socket = this.nsps[nsp];
         if(socket == null)
         {
            socket = this.nsps[nsp] = new Socket(this,nsp);
            socket.on(Socket.EVENT_CONNECT,function():void
            {
               ++connected;
            });
         }
         return socket;
      }
      
      internal function destroy(param1:Socket) : void
      {
         param1.off(Socket.EVENT_CONNECT);
         --this.connected;
         if(this.nsps.hasOwnProperty(param1.nsp))
         {
            delete this.nsps[param1.nsp];
         }
         if(this.connected == 0)
         {
            this.close();
         }
      }
      
      internal function packet(param1:Packet) : void
      {
         this.engine.write(Parser.encode(param1));
      }
      
      private function cleanup() : void
      {
         var _loc1_:OnHandle = null;
         while(true)
         {
            _loc1_ = this.subs.shift();
            if(!_loc1_)
            {
               break;
            }
            _loc1_.destroy();
         }
      }
      
      private function close() : void
      {
         this.skipReconnect = true;
         this.cleanup();
         this.readyState = CLOSED;
         this.engine.close();
      }
      
      private function reconnect() : void
      {
         var delay:Number = NaN;
         var timer:Timer = null;
         var delayHandler:Function = null;
         ++this.attempts;
         if(this.attempts > this._reconnectionAttempts)
         {
            emit(EVENT_RECONNECT_FAILED);
            this.reconnecting = false;
         }
         else
         {
            this.cleanup();
            delay = this.attempts * this._reconnectionDelay;
            delay = Math.min(delay,this._reconnectionDelayMax);
            Log.d("socket.io",StringUtil.substitute("will wait {0} before reconnect attempt",delay));
            this.reconnecting = true;
            timer = new Timer(delay,1);
            delayHandler = function(param1:TimerEvent):void
            {
               var event:TimerEvent = param1;
               timer.removeEventListener(TimerEvent.TIMER_COMPLETE,delayHandler);
               open(function(param1:Error = null):void
               {
                  if(param1 != null)
                  {
                     Log.d("socket.io","reconnect attempt error");
                     reconnect();
                     emit(EVENT_RECONNECT_ERROR,param1);
                  }
                  else
                  {
                     Log.d("socket.io","reconnect success");
                     onreconnect();
                  }
               });
            };
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,delayHandler);
            timer.start();
            this.subs.push(new OnHandle(function():void
            {
               timer.removeEventListener(TimerEvent.TIMER_COMPLETE,delayHandler);
               timer.stop();
            }));
         }
      }
      
      private function onopen() : void
      {
         this.cleanup();
         this.readyState = OPEN;
         emit(EVENT_OPEN);
         this.subs.push(On.on(this.engine,Engine.EVENT_DATA,function(param1:String):void
         {
            ondata(param1);
         }));
         this.subs.push(On.on(this.engine,Engine.EVENT_ERROR,function(param1:Error = null):void
         {
            onerror(param1);
         }));
         this.subs.push(On.on(this.engine,Engine.EVENT_CLOSE,function(param1:String = null, param2:Error = null):void
         {
            onclose(param1,param2);
         }));
      }
      
      private function ondata(param1:String) : void
      {
         emit(EVENT_PACKET,Parser.decode(param1));
      }
      
      private function onerror(param1:Error) : void
      {
         emit(EVENT_ERROR,param1);
      }
      
      private function onclose(param1:String = null, param2:Error = null) : void
      {
         this.cleanup();
         this.readyState = CLOSED;
         emit(EVENT_CLOSE,param1);
         if(this._reconnection && !this.skipReconnect)
         {
            this.reconnect();
         }
      }
      
      private function onreconnect() : void
      {
         var _loc1_:int = this.attempts;
         this.attempts = 0;
         this.reconnecting = false;
         emit(EVENT_RECONNECT,_loc1_);
      }
   }
}

