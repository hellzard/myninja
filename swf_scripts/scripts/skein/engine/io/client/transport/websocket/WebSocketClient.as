package skein.engine.io.client.transport.websocket
{
   import flash.system.Security;
   import net.gimite.websocket.IWebSocketLogger;
   import net.gimite.websocket.WebSocket;
   import net.gimite.websocket.WebSocketEvent;
   import skein.core.WeakReference;
   import skein.logger.Log;
   import skein.utils.delay.callLater;
   
   public class WebSocketClient implements IWebSocketLogger
   {
      
      private var _dataSource:WeakReference;
      
      private var _delegate:WeakReference;
      
      private var webSocket:WebSocket;
      
      private var debug:Boolean = false;
      
      private var manualPolicyFileLoaded:Boolean = false;
      
      public function WebSocketClient(param1:String, param2:Array, param3:String = null, param4:int = 0, param5:String = null)
      {
         var uri:String = param1;
         var protocols:Array = param2;
         var proxyHost:String = param3;
         var proxyPort:int = param4;
         var headers:String = param5;
         super();
         callLater(function():void
         {
            create(uri,protocols,proxyHost,proxyPort,headers);
         });
      }
      
      public function get dataSource() : WebSocketClientDataSource
      {
         return this._dataSource ? this._dataSource.value : null;
      }
      
      public function set dataSource(param1:WebSocketClientDataSource) : void
      {
         this._dataSource = new WeakReference(param1);
      }
      
      public function get delegate() : WebSocketClientDelegate
      {
         return this._delegate ? this._delegate.value : null;
      }
      
      public function set delegate(param1:WebSocketClientDelegate) : void
      {
         this._delegate = new WeakReference(param1);
      }
      
      protected function create(param1:String, param2:Array, param3:String = null, param4:int = 0, param5:String = null) : void
      {
         if(!this.manualPolicyFileLoaded)
         {
            this.loadDefaultPolicyFile(param1);
         }
         var _loc6_:WebSocket = new WebSocket(this.getId(),param1,param2,this.getOrigin(),param3,param4,this.getCookie(param1),param5,this);
         _loc6_.addEventListener(WebSocketEvent.OPEN,this.socketOpenHandler);
         _loc6_.addEventListener(WebSocketEvent.CLOSE,this.socketCloseHandler);
         _loc6_.addEventListener(WebSocketEvent.ERROR,this.socketErrorHandler);
         _loc6_.addEventListener(WebSocketEvent.MESSAGE,this.socketMessageHandler);
         this.webSocket = _loc6_;
      }
      
      public function send(param1:String) : int
      {
         return this.webSocket.send(param1);
      }
      
      public function close() : void
      {
         this.webSocket.close();
      }
      
      private function loadDefaultPolicyFile(param1:String) : void
      {
         var _loc2_:String = "xmlsocket://" + this.getHostname() + ":843";
         this.log("policy file: " + _loc2_);
         Security.loadPolicyFile(_loc2_);
      }
      
      public function loadManualPolicyFile(param1:String) : void
      {
         this.log("policy file: " + param1);
         Security.loadPolicyFile(param1);
         this.manualPolicyFileLoaded = true;
      }
      
      protected function getId() : int
      {
         return this.dataSource ? this.dataSource.webSocketClientID() : 0;
      }
      
      protected function getHostname() : String
      {
         return this.dataSource ? this.dataSource.webSocketClientHostname() : null;
      }
      
      protected function getOrigin() : String
      {
         return this.dataSource ? this.dataSource.webSocketClientOrigin() : null;
      }
      
      protected function getCookie(param1:String) : String
      {
         return this.dataSource ? this.dataSource.webSocketClientCookie() : null;
      }
      
      private function parseEvent(param1:WebSocketEvent) : Object
      {
         var _loc2_:WebSocket = param1.target as WebSocket;
         var _loc3_:Object = {};
         _loc3_.type = param1.type;
         _loc3_.webSocketId = _loc2_.getId();
         _loc3_.readyState = _loc2_.getReadyState();
         _loc3_.protocol = _loc2_.getAcceptedProtocol();
         if(param1.message !== null)
         {
            _loc3_.message = param1.message;
         }
         if(param1.wasClean)
         {
            _loc3_.wasClean = param1.wasClean;
         }
         if(param1.code)
         {
            _loc3_.code = param1.code;
         }
         if(param1.reason !== null)
         {
            _loc3_.reason = param1.reason;
         }
         return _loc3_;
      }
      
      private function socketOpenHandler(param1:WebSocketEvent) : void
      {
         this.log("Socket opened");
         if(this.delegate)
         {
            this.delegate.webSocketClientDidOpen();
         }
      }
      
      private function socketCloseHandler(param1:WebSocketEvent) : void
      {
         this.log("Socket closed");
         if(this.delegate)
         {
            this.delegate.webSocketClientDidClose();
         }
      }
      
      private function socketErrorHandler(param1:WebSocketEvent) : void
      {
         this.error("Socket error: " + param1.message);
         if(this.delegate)
         {
            this.delegate.webSocketClientDidError();
         }
      }
      
      private function socketMessageHandler(param1:WebSocketEvent) : void
      {
         if(this.delegate)
         {
            this.delegate.webSocketClientDidMessage(param1.message);
         }
      }
      
      public function log(param1:String) : void
      {
         if(this.debug)
         {
            Log.d("engine.io",param1);
         }
      }
      
      public function error(param1:String) : void
      {
         Log.d("engine.io",param1);
      }
   }
}

