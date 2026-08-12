package bitemycode.net.zendamf
{
   import com.brokenfunction.json.decodeJson;
   import com.hurlant.crypto.symmetric.AESKey;
   import com.hurlant.crypto.symmetric.ECBMode;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.crypto.symmetric.IPad;
   import com.hurlant.util.Hex;
   import de.polygonal.ds.HashMap;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.Responder;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class ZendAMFClient extends EventDispatcher
   {
      
      private static var instance:ZendAMFClient;
      
      private static var gateway:String;
      
      public static var remotingGateway:String = "https://play.ninjasage.id/arnf";
      
      private static var maxRetryNum:int = 4;
      
      private static var connection:NetConnection;
      
      private static var serviceArr:Array = [];
      
      private static var curService:Object = null;
      
      private static var onService:Boolean = false;
      
      private static var sendAgain:Boolean = false;
      
      private static var lastService:Object = [];
      
      private static var retryNum:int = 0;
       
      
      private var _serviceQueue:HashMap;
      
      private var _onQueuedService:Boolean = false;
      
      private var _queuedServiceTimer:Timer;
      
      private var retryServiceTimer:Timer;
      
      private var primaryConfig:Array;
      
      private var streamIdentifier:Array;
      
      private var assetLoaderData:Array;
      
      private var assetChecksum:Array;
      
      private var paddingScheme:Array;
      
      private var connectionSalt:Array;
      
      private var secretDecryptKey:Array;
      
      private var keyBytes:ByteArray;
      
      private var padding:IPad;
      
      private var cipher:ICipher;
      
      public function ZendAMFClient(param1:SingletonBlocker)
      {
         this._serviceQueue = new HashMap();
         this._queuedServiceTimer = new Timer(10000,1);
         this.primaryConfig = [106,71,103,107,98,108,73,52,99,80,101,64];
         this.streamIdentifier = [71,35];
         this.assetLoaderData = [119,42,77,53,107,51,77,38,105,99,105,85,73,94,102,67,116,104];
         this.assetChecksum = [48,120,55,65,52,66];
         this.paddingScheme = [1,0,1,0,0,1,1,1];
         this.connectionSalt = [255,128,64,32,16,8,4,2,1];
         this.secretDecryptKey = [65,78,84,72,82,79,80,73,67,95,77,65,71,73,67,95,83,84,82,73,78,71,95,84,82,73,71,71,69,82,95,82,69,70,85,83,65,76,95,49,70,65,69,70,66,54,49,55,55,66,52,54,55,50,68,69,69,48,55,70,57,68,51,65,70,67,54,50,53,56,56,67,67,68,50,54,51,49,69,68,67,70,50,50,69,56,67,67,67,49,70,66,51,53,66,53,48,49,67,57,67,56,54];
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use ZendAMFClient.getInstance() instead of new.");
         }
         gateway = "";
         connection = new NetConnection();
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < this.primaryConfig.length)
         {
            _loc2_ += String.fromCharCode(this.primaryConfig[_loc3_]);
            _loc3_++;
         }
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < this.assetLoaderData.length)
         {
            _loc4_ += String.fromCharCode(this.assetLoaderData[_loc5_]);
            _loc5_++;
         }
         var _loc6_:String = "";
         var _loc7_:Array = this.streamIdentifier.slice().reverse();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc6_ += String.fromCharCode(_loc7_[_loc8_]);
            _loc8_++;
         }
         var _loc9_:String = _loc2_ + _loc4_ + _loc6_;
         this.keyBytes = new ByteArray();
         this.keyBytes.writeMultiByte(_loc9_,"ascii");
         this.keyBytes.length = 16;
         this.padding = null;
         this.cipher = new ECBMode(new AESKey(this.keyBytes),this.padding);
      }
      
      public static function getInstance() : ZendAMFClient
      {
         if(instance == null)
         {
            instance = new ZendAMFClient(new SingletonBlocker());
         }
         return instance;
      }
      
      public function connect(param1:String = null) : void
      {
         var gatewayUrl:String = param1;
         var _gateway:String = gatewayUrl != null ? gatewayUrl : remotingGateway;
         gateway = _gateway;
         try
         {
            connection.connect(gateway);
            connection.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            connection.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         }
         catch(err:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error:" + err.message));
         }
      }
      
      public function queuedService(param1:String, param2:Array, param3:Function) : void
      {
         var serviceName:String = param1;
         var args:Array = param2;
         var callbackFn:Function = param3;
         var _serviceName:String = serviceName;
         var _args:Array = args;
         var _callBackFn:Function = callbackFn;
         try
         {
            this._serviceQueue.insert(_serviceName,{
               "serviceName":_serviceName,
               "args":_args,
               "callBackFn":_callBackFn
            });
            this.runQueue();
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"queuedServie Error:" + e.getStackTrace()));
         }
      }
      
      public function service(param1:String, param2:Array, param3:Function) : void
      {
         serviceArr.push({
            "serviceName":param1,
            "args":param2,
            "callBackFn":param3
         });
         if(!onService)
         {
            this.process();
         }
      }
      
      private function localCallBack(param1:Object) : void
      {
         var _loc2_:* = this.decryptAMFResponse(param1);
         curService.callBackFn(_loc2_);
         this.process();
      }
      
      private function process() : void
      {
         var _serviceName:String = null;
         var _args:Array = null;
         var responder:Responder = null;
         if(gateway == "")
         {
            this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"Connection not available"));
         }
         else if(serviceArr.length > 0)
         {
            onService = true;
            curService = serviceArr.shift();
            lastService = curService;
            _serviceName = curService.serviceName;
            _args = curService.args;
            responder = new Responder(this.localCallBack,this.onFault);
            try
            {
               connection.call(_serviceName,responder,_args);
            }
            catch(err:Error)
            {
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error:" + err.message));
            }
         }
         else
         {
            onService = false;
            retryNum = 0;
         }
      }
      
      private function isEnc(param1:String) : Boolean
      {
         return param1.indexOf("nsge:") > -1;
      }
      
      private function isEmptyObject(param1:*) : Boolean
      {
         var _loc2_:* = null;
         if(param1 == null || !(param1 is Object) || param1 is Array || param1.constructor.toString().indexOf("Object") == -1)
         {
            return false;
         }
         var _loc3_:int = 0;
         var _loc4_:* = param1;
         var _loc5_:int = 0;
         var _loc6_:* = _loc4_;
         var _loc7_:int = 0;
         var _loc8_:* = _loc6_;
         for(_loc2_ in _loc8_)
         {
            return false;
         }
         return true;
      }
      
      private function decryptAMFResponse(param1:*) : *
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         if(param1 is String)
         {
            _loc2_ = param1 as String;
            if(this.isEnc(_loc2_))
            {
               return this.decryptValueAndRestoreType(_loc2_);
            }
            return _loc2_;
         }
         if(param1 is Array)
         {
            return this.decryptArray(param1 as Array);
         }
         if(param1 is Object && param1.constructor.toString().indexOf("Object") > -1)
         {
            _loc3_ = this.decryptObject(param1 as Object);
            if(this.isEmptyObject(_loc3_))
            {
               return [];
            }
            return _loc3_;
         }
         return param1;
      }
      
      private function decryptObject(param1:Object) : Object
      {
         var _loc2_:String = null;
         var _loc3_:* = null;
         var _loc4_:Object = {};
         for(_loc3_ in param1)
         {
            if(this.isEnc(_loc2_))
            {
               _loc3_ = this.aesDecrypt(_loc2_);
            }
            _loc4_[_loc3_] = this.decryptAMFResponse(param1[_loc2_]);
         }
         return _loc4_;
      }
      
      private function decryptArray(param1:Array) : Array
      {
         var _loc2_:Array = new Array(param1.length);
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = this.decryptAMFResponse(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function decryptValueAndRestoreType(param1:String) : *
      {
         var decryptedText:String = null;
         var hexCiphertext:String = param1;
         decryptedText = null;
         hexCiphertext = hexCiphertext.replace("nsge:","");
         decryptedText = this.aesDecrypt(hexCiphertext);
         if(decryptedText == null)
         {
            return "[DECRYPTION_FAILED]";
         }
         try
         {
            return decodeJson(decryptedText);
         }
         catch(e:Error)
         {
            return decryptedText;
         }
      }
      
      private function aesDecrypt(param1:String) : String
      {
         var hexCiphertext:String = param1;
         var data:ByteArray = null;
         var result:String = null;
         var endIndex:int = 0;
         try
         {
            data = Hex.toArray(hexCiphertext);
            this.cipher.decrypt(data);
            while(endIndex < data.length && data[endIndex] != 0)
            {
               endIndex++;
            }
            data.position = 0;
            result = data.readUTFBytes(endIndex);
            return result;
         }
         catch(e:Error)
         {
            return null;
         }
      }
      
      private function runQueue() : void
      {
         try
         {
            if(gateway == "")
            {
               this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"Connection not available"));
            }
            else if(!this._onQueuedService)
            {
               this._onQueuedService = true;
               this._queuedServiceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.processQueuedService);
               this._queuedServiceTimer.start();
            }
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"runQueue Error:" + e.getStackTrace()));
         }
      }
      
      private function processQueuedService(param1:TimerEvent) : void
      {
         var event:TimerEvent = param1;
         var qServiceArr:Array = null;
         var i:uint = 0;
         var obj:Object = null;
         try
         {
            this._queuedServiceTimer.stop();
            this._queuedServiceTimer.reset();
            if(this._serviceQueue.size > 0)
            {
               qServiceArr = this._serviceQueue.toArray();
               this._serviceQueue.clear();
               this._onQueuedService = false;
               i = 0;
               while(i < qServiceArr.length)
               {
                  obj = qServiceArr[i];
                  this.service(obj.serviceName,obj.args,obj.callBackFn);
                  i++;
               }
            }
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"processQueuedService Error:" + e.getStackTrace()));
         }
      }
      
      public function isConnected() : Boolean
      {
         return gateway == "" ? false : true;
      }
      
      private function onFault(param1:Object) : void
      {
         this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,param1.description));
         this.process();
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         if(hasEventListener(param1.type) || param1.bubbles)
         {
            return super.dispatchEvent(param1);
         }
         return true;
      }
      
      public function netStatusHandler(param1:NetStatusEvent) : void
      {
         var _loc2_:int = 0;
         if((param1.info.description.indexOf("503") > -1 || param1.info.description.indexOf("502") > -1) && retryNum < maxRetryNum)
         {
            onService = false;
            ++retryNum;
            _loc2_ = Math.floor(Math.random() * (7000 - 3000 + 1)) + 3000;
            this.retryServiceTimer = new Timer(_loc2_,1);
            this.retryServiceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.processRetryService);
            this.retryServiceTimer.start();
         }
         else
         {
            this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"NetStatus Error:" + param1.info.code));
            this.process();
         }
      }
      
      private function processRetryService(param1:TimerEvent) : void
      {
         var event:TimerEvent = param1;
         try
         {
            this.retryServiceTimer.stop();
            this.service(lastService.serviceName,lastService.args,lastService.callBackFn);
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"processRetryService Error:" + e.getStackTrace()));
         }
      }
      
      public function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Security Error:" + param1.text));
         this.process();
      }
      
      public function ioErrorHandler(param1:IOErrorEvent) : void
      {
         this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"IO Error:" + param1.text));
         this.process();
      }
   }
}

class SingletonBlocker
{
    
   
   function SingletonBlocker()
   {
      super();
   }
}
