package skein.engine.io.client.transport
{
   import skein.engine.io.client.Transport;
   import skein.engine.io.client.TransportOptions;
   import skein.engine.io.client.Util;
   import skein.engine.io.parser.Packet;
   import skein.engine.io.parser.Parser;
   import skein.logger.Log;
   import skein.utils.StringUtil;
   
   public class Polling extends Transport
   {
      
      public static const NAME:String = "polling";
      
      public static const EVENT_POLL:String = "poll";
      
      public static const EVENT_POLL_COMPLETE:String = "pollComplete";
       
      
      private var polling:Boolean;
      
      public function Polling(param1:TransportOptions)
      {
         super(param1);
         this.name = NAME;
      }
      
      override protected function doOpen() : void
      {
         this.poll();
      }
      
      override protected function doClose() : void
      {
         var close:Function = function(... rest):void
         {
            write([new Packet(Packet.CLOSE)]);
         };
         if(_readyState == OPEN)
         {
            Log.d("engine.io","transport open - closing");
            close();
         }
         else
         {
            Log.d("engine.io","transport not open - deferring close");
            once(EVENT_OPEN,close);
         }
      }
      
      override protected function onData(param1:String) : void
      {
         var data:String = param1;
         Log.d("engine.io",StringUtil.substitute("polling got data {0}",data));
         Parser.decodePayload(data,function(param1:Packet, param2:int, param3:int):Boolean
         {
            if(_readyState == OPENING)
            {
               onOpen();
            }
            if(param1.type == Packet.CLOSE)
            {
               onClose();
               return false;
            }
            onPacket(param1);
            return true;
         });
         if(_readyState != CLOSED)
         {
            this.polling = false;
            emit(EVENT_POLL);
            if(_readyState == OPEN)
            {
               this.poll();
            }
            else
            {
               Log.d("engine.io",StringUtil.substitute("ignoring poll - transport state {0}",this.readyState));
            }
         }
      }
      
      override protected function write(param1:Array) : void
      {
         var packets:Array = param1;
         this.writable = false;
         this.doWrite(Parser.encodePayload(packets),function():void
         {
            writable = true;
            emit(EVENT_DRAIN);
         });
      }
      
      public function pause(param1:Function) : void
      {
         var total:int = 0;
         var callback:Function = param1;
         var onPaused:Function = function():void
         {
            _readyState = PAUSED;
            callback();
         };
         _readyState = PAUSED;
         if(this.polling || !this.writable)
         {
            total = 0;
            if(this.polling)
            {
               Log.d("engine.io","we are currently polling - waiting to pause");
               total++;
               this.once(EVENT_POLL_COMPLETE,function(... rest):void
               {
                  Log.d("engine.io","pre-pause polling complete");
                  if(--total == 0)
                  {
                     onPaused();
                  }
               });
            }
            if(!this.writable)
            {
               Log.d("engine.io","we are currently writing - waiting to pause");
               total++;
               this.once(EVENT_DRAIN,function(... rest):void
               {
                  Log.d("engine.io","pre-pause writing complete");
                  if(--total == 0)
                  {
                     onPaused();
                  }
               });
            }
         }
         else
         {
            onPaused();
         }
      }
      
      private function poll() : void
      {
         Log.d("engine.io","polling");
         this.polling = true;
         this.doPoll();
         emit(EVENT_POLL);
      }
      
      protected function uri() : String
      {
         var _loc1_:Object = this.query || {};
         var _loc2_:String = !!this.secure ? "https" : "http";
         var _loc3_:String = "";
         if(timestampRequests)
         {
            _loc1_[timestampParam] = new Date().getTime();
         }
         var _loc4_:String = Util.qs(_loc1_);
         if(this.port > 0 && (_loc2_ == "https" && this.port != 443) || _loc2_ == "http" && this.port != 80)
         {
            _loc3_ = ":" + this.port;
         }
         if(_loc4_.length > 0)
         {
            _loc4_ = "?" + _loc4_;
         }
         return _loc2_ + "://" + hostname + _loc3_ + path + _loc4_;
      }
      
      protected function doWrite(param1:String, param2:Function) : void
      {
      }
      
      protected function doPoll() : void
      {
      }
   }
}
