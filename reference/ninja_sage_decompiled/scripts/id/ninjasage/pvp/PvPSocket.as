package id.ninjasage.pvp
{
   import Storage.Character;
   import id.ninjasage.Log;
   import skein.socket.io.IO;
   import skein.socket.io.Options;
   import skein.socket.io.Socket;
   
   public class PvPSocket
   {
      
      private static var _instance:PvPSocket;
      
      private static const SOCKET_URI:String = "http://pvp-ts.ninjasage.id/pvp";
       
      
      private var _socket:Socket;
      
      private var _isInitialized:Boolean = false;
      
      private var _onConnectCallbacks:Array;
      
      private var _onDisconnectCallbacks:Array;
      
      public function PvPSocket()
      {
         this._onConnectCallbacks = [];
         this._onDisconnectCallbacks = [];
         super();
      }
      
      public static function getInstance() : PvPSocket
      {
         if(_instance == null)
         {
            _instance = new PvPSocket();
         }
         return _instance;
      }
      
      public function connect() : void
      {
         var _loc3_:Boolean = false;
         if(this._socket && this._socket.connected)
         {
            return;
         }
         if(this._socket)
         {
            _loc3_ = this._isInitialized;
            this._isInitialized = true;
            this.removeCoreListeners();
            this._socket.off();
            this._socket = null;
            this._isInitialized = false;
         }
         var _loc1_:* = SOCKET_URI;
         var _loc2_:Options = new Options();
         _loc2_.reconnection = true;
         _loc2_.reconnectionAttempts = 5;
         _loc2_.reconnectionDelay = 1000;
         _loc2_.reconnectionDelayMax = 5000;
         this._socket = IO.socket(_loc1_,_loc2_);
         this.addCoreListeners();
         this._socket.connect();
      }
      
      public function disconnect() : void
      {
         if(!this._socket)
         {
            return;
         }
         try
         {
            this._socket.disconnect();
         }
         catch(e:*)
         {
         }
      }
      
      private function addCoreListeners() : void
      {
         if(!this._socket || this._isInitialized)
         {
            return;
         }
         this._isInitialized = true;
         this._socket.on(Socket.EVENT_CONNECT,this.onConnect);
         this._socket.on(Socket.EVENT_ERROR,this.onError);
         this._socket.on(Socket.EVENT_DISCONNECT,this.onDisconnect);
      }
      
      private function removeCoreListeners() : void
      {
         if(!this._socket || !this._isInitialized)
         {
            return;
         }
         this._socket.off(Socket.EVENT_CONNECT,this.onConnect);
         this._socket.off(Socket.EVENT_ERROR,this.onError);
         this._socket.off(Socket.EVENT_DISCONNECT,this.onDisconnect);
      }
      
      private function onConnect() : void
      {
         var callbacksCopy:Array = null;
         var i:int = 0;
         var callback:Function = null;
         Log.info(this,"connected");
         try
         {
            this.authenticate();
            callbacksCopy = this._onConnectCallbacks.slice();
            i = 0;
            for(; i < callbacksCopy.length; i++)
            {
               try
               {
                  callback = callbacksCopy[i] as Function;
                  if(callback != null)
                  {
                     callback();
                  }
               }
               catch(e:*)
               {
                  Log.error(this,"onConnect","Error calling connect callback: " + e);
                  continue;
               }
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function onError(param1:Object = null) : void
      {
         Log.info(this,"PvP socket error" + (!!param1 ? ": " + String(param1) : ""));
      }
      
      private function onDisconnect(param1:String = null) : void
      {
         var i:int = 0;
         var callback:Function = null;
         var reason:String = param1;
         Log.info(this,"PvP socket disconnected" + (!!reason ? ": " + reason : ""));
         this._isInitialized = false;
         var callbacksCopy:Array = this._onDisconnectCallbacks.slice();
         i = 0;
         for(; i < callbacksCopy.length; i++)
         {
            try
            {
               callback = callbacksCopy[i] as Function;
               if(callback != null)
               {
                  callback(reason);
               }
            }
            catch(e:*)
            {
               Log.error(this,"onDisconnect","Error calling disconnect callback: " + e);
               continue;
            }
         }
      }
      
      public function on(param1:String, param2:Function) : void
      {
         if(!this._socket || param2 == null)
         {
            return;
         }
         if(param1 == Socket.EVENT_CONNECT)
         {
            if(this._onConnectCallbacks.indexOf(param2) == -1)
            {
               this._onConnectCallbacks.push(param2);
            }
         }
         else if(param1 == Socket.EVENT_DISCONNECT)
         {
            if(this._onDisconnectCallbacks.indexOf(param2) == -1)
            {
               this._onDisconnectCallbacks.push(param2);
            }
         }
         else
         {
            this._socket.on(param1,param2);
         }
      }
      
      public function once(param1:String, param2:Function) : void
      {
         if(!this._socket)
         {
            return;
         }
         this._socket.once(param1,param2);
      }
      
      public function off(param1:String = null, param2:Function = null) : void
      {
         var _loc3_:int = 0;
         if(!this._socket)
         {
            return;
         }
         if(param1 == Socket.EVENT_CONNECT && param2 != null)
         {
            _loc3_ = this._onConnectCallbacks.indexOf(param2);
            if(_loc3_ != -1)
            {
               this._onConnectCallbacks.splice(_loc3_,1);
            }
         }
         else if(param1 == Socket.EVENT_DISCONNECT && param2 != null)
         {
            _loc3_ = this._onDisconnectCallbacks.indexOf(param2);
            if(_loc3_ != -1)
            {
               this._onDisconnectCallbacks.splice(_loc3_,1);
            }
         }
         else if(param1 == Socket.EVENT_CONNECT && param2 == null)
         {
            this._onConnectCallbacks = [];
         }
         else if(param1 == Socket.EVENT_DISCONNECT && param2 == null)
         {
            this._onDisconnectCallbacks = [];
         }
         else
         {
            this._socket.off(param1,param2);
         }
      }
      
      public function emit(param1:String, ... rest) : void
      {
         if(!this._socket)
         {
            return;
         }
         rest.unshift(param1);
         this._socket.emit.apply(this._socket,rest);
      }
      
      private function authenticate() : void
      {
         if(!this._socket)
         {
            return;
         }
         this.emit("System.auth",{
            "character_id":Character.char_id,
            "session_key":Character.sessionkey,
            "ver":Character.build_num
         });
      }
      
      public function get socket() : Socket
      {
         return this._socket;
      }
      
      public function destroy() : void
      {
         try
         {
            this.removeCoreListeners();
            if(this._socket)
            {
               this._socket.off();
               this._socket.disconnect();
            }
         }
         catch(e:*)
         {
         }
         IO.removeManager(SOCKET_URI);
         this._onConnectCallbacks = [];
         this._onDisconnectCallbacks = [];
         _instance = null;
         this._socket = null;
         this._isInitialized = false;
      }
   }
}
