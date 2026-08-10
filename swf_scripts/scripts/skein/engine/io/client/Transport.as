package skein.engine.io.client
{
   import flash.errors.IllegalOperationError;
   import skein.emitter.Emitter;
   import skein.engine.io.parser.Packet;
   import skein.engine.io.parser.Parser;
   import skein.logger.Log;
   
   public class Transport extends Emitter
   {
      
      public static const EVENT_OPEN:String = "open";
      
      public static const EVENT_CLOSE:String = "close";
      
      public static const EVENT_PACKET:String = "packet";
      
      public static const EVENT_DRAIN:String = "drain";
      
      public static const EVENT_ERROR:String = "error";
      
      public static const EVENT_REQUEST_HEADERS:String = "requestHeaders";
      
      public static const EVENT_RESPONSE_HEADERS:String = "responseHeaders";
      
      public static const OPENING:String = "opening";
      
      public static const OPEN:String = "open";
      
      public static const CLOSED:String = "closed";
      
      public static const PAUSED:String = "paused";
      
      public var name:String;
      
      public var writable:Boolean;
      
      public var query:Object;
      
      protected var secure:Boolean;
      
      protected var timestampRequests:Boolean;
      
      protected var port:int;
      
      protected var path:String;
      
      protected var hostname:String;
      
      protected var timestampParam:String;
      
      protected var _readyState:String;
      
      public function Transport(param1:TransportOptions)
      {
         super();
         if(param1)
         {
            this.path = param1.path;
            this.hostname = param1.hostname;
            this.port = param1.port;
            this.secure = param1.secure;
            this.query = param1.query;
            this.timestampParam = param1.timestampParam;
            this.timestampRequests = param1.timestampRequests;
         }
      }
      
      public function get readyState() : String
      {
         return this._readyState;
      }
      
      protected function onError(param1:String, param2:Error) : Transport
      {
         emit(EVENT_ERROR,param2);
         return this;
      }
      
      public function open() : Transport
      {
         if(this._readyState == CLOSED || this._readyState == null)
         {
            this._readyState = OPENING;
            this.doOpen();
         }
         return this;
      }
      
      public function close() : Transport
      {
         if(this._readyState == OPENING || this._readyState == OPEN)
         {
            this.doClose();
            this.onClose();
         }
         return this;
      }
      
      public function send(param1:Array) : void
      {
         if(this._readyState == OPEN)
         {
            this.write(param1);
            return;
         }
         throw new IllegalOperationError("Transport not open");
      }
      
      protected function onOpen() : void
      {
         this._readyState = OPEN;
         this.writable = true;
         emit(EVENT_OPEN);
      }
      
      protected function onData(param1:String) : void
      {
         Log.d("engine.io",param1);
         this.onPacket(Parser.decodePacket(decodeURIComponent(param1)));
      }
      
      protected function onPacket(param1:Packet) : void
      {
         emit(EVENT_PACKET,param1);
      }
      
      protected function onClose() : void
      {
         this._readyState = CLOSED;
         emit(EVENT_CLOSE);
      }
      
      protected function write(param1:Array) : void
      {
      }
      
      protected function doOpen() : void
      {
      }
      
      protected function doClose() : void
      {
      }
   }
}

