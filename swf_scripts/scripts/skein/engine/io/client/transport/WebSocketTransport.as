package skein.engine.io.client.transport
{
   import skein.engine.io.client.Transport;
   import skein.engine.io.client.TransportOptions;
   import skein.engine.io.client.transport.websocket.WebSocketClient;
   import skein.engine.io.client.transport.websocket.WebSocketClientDataSource;
   import skein.engine.io.client.transport.websocket.WebSocketClientDelegate;
   import skein.engine.io.parser.Packet;
   import skein.engine.io.parser.Parser;
   
   public class WebSocketTransport extends Transport implements WebSocketClientDataSource, WebSocketClientDelegate
   {
      
      public static const NAME:String = "websocket";
      
      private var socket:WebSocketClient;
      
      public function WebSocketTransport(param1:TransportOptions)
      {
         super(param1);
         this.name = NAME;
      }
      
      protected function get uri() : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc1_:Object = this.query || new Object();
         var _loc2_:String = this.secure ? "wss" : "ws";
         var _loc3_:String = "";
         if(this.port > 0 && (_loc2_ == "wss" && this.port != 443) || _loc2_ == "ws" && this.port != 80)
         {
            _loc3_ = ":" + this.port;
         }
         if(this.timestampRequests)
         {
            _loc1_[this.timestampParam] = new Date().getTime();
         }
         var _loc4_:Array = [];
         for(_loc5_ in _loc1_)
         {
            _loc4_.push(_loc5_ + "=" + _loc1_[_loc5_]);
         }
         _loc6_ = "";
         if(_loc4_.length > 0)
         {
            _loc6_ = "?" + _loc4_.join("&");
         }
         return _loc2_ + "://" + this.hostname + _loc3_ + this.path + _loc6_;
      }
      
      override protected function doOpen() : void
      {
         if(!this.check())
         {
            return;
         }
         this.socket = new WebSocketClient(this.uri,[]);
         this.socket.dataSource = this;
         this.socket.delegate = this;
      }
      
      override protected function write(param1:Array) : void
      {
         var _loc2_:Packet = null;
         for each(_loc2_ in param1)
         {
            this.socket.send(Parser.encodePacket(_loc2_));
         }
         writable = true;
         emit(EVENT_DRAIN);
      }
      
      override protected function onClose() : void
      {
         super.onClose();
      }
      
      override protected function doClose() : void
      {
         if(this.socket != null)
         {
            this.socket.close();
         }
      }
      
      private function check() : Boolean
      {
         return true;
      }
      
      public function webSocketClientID() : int
      {
         return 0;
      }
      
      public function webSocketClientHostname() : String
      {
         return hostname;
      }
      
      public function webSocketClientOrigin() : String
      {
         return (secure ? "https" : "http") + "://" + hostname;
      }
      
      public function webSocketClientCookie() : String
      {
         return "";
      }
      
      public function webSocketClientDidOpen() : void
      {
         var _loc1_:Array = [];
         emit(EVENT_RESPONSE_HEADERS,_loc1_);
         onOpen();
      }
      
      public function webSocketClientDidClose() : void
      {
         this.onClose();
      }
      
      public function webSocketClientDidError() : void
      {
         onError("websocket error",new Error());
      }
      
      public function webSocketClientDidMessage(param1:String) : void
      {
         onData(param1);
      }
   }
}

