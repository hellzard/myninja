package amf
{
   import Managers.AppManager;
   import Panels.ReconnectNotice;
   import bitemycode.net.zendamf.ZendAMFClient;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class amfConnect
   {
      
      private var zendClient:ZendAMFClient;
      
      private var amfName:String;
      
      private var amfParameter:Array;
      
      private var amfCallback:Function;
      
      private var amfErrorCallback:Function;
      
      private var autoReconnect:Boolean;
      
      private var maxReconnectAttempt:int = 3;
      
      private var reconnectAttempt:int = 0;
      
      private var reconnectDelay:int = 5000;
      
      private var reconnectTimeout:uint;
      
      private var popupNotice:MovieClip;
      
      private var errorHandlerBound:Boolean = false;
      
      private var isActive:Boolean = false;
      
      public function amfConnect()
      {
         super();
         this.zendClient = ZendAMFClient.getInstance();
      }
      
      public function service(param1:String, param2:Array, param3:Function, param4:Boolean = false, param5:Function = null) : void
      {
         this.reconnectAttempt = 0;
         this.amfName = param1;
         this.amfParameter = param2;
         this.amfCallback = param3;
         this.autoReconnect = param4;
         this.amfErrorCallback = param5;
         this.isActive = true;
         this.connectAmf();
      }
      
      private function connectAmf() : void
      {
         if(!this.errorHandlerBound)
         {
            this.zendClient.addEventListener(ErrorEvent.ERROR,this.errorHandler,false,0,true);
            this.errorHandlerBound = true;
         }
         if(!this.zendClient.isConnected())
         {
            this.zendClient.connect();
         }
         this.zendClient.service(this.amfName,this.amfParameter,this.successfulResult);
      }
      
      private function successfulResult(param1:Object) : void
      {
         if(!this.isActive)
         {
            return;
         }
         if(this.amfCallback != null)
         {
            this.amfCallback(param1);
         }
         this.cleanup();
      }
      
      private function errorHandler(param1:ErrorEvent) : void
      {
         var _loc2_:Object = null;
         if(!this.isActive)
         {
            return;
         }
         if(this.amfErrorCallback != null)
         {
            _loc2_ = {
               "code":"NetConnection.Call.Failed",
               "description":param1.text
            };
            this.amfErrorCallback(_loc2_);
         }
         this.tryReconnect();
      }
      
      private function tryReconnect() : *
      {
         if(!this.autoReconnect)
         {
            this.cleanup();
            return;
         }
         ++this.reconnectAttempt;
         if(this.reconnectAttempt <= this.maxReconnectAttempt)
         {
            AppManager.getInstance().main.showMessage("Reconnecting...");
            clearTimeout(this.reconnectTimeout);
            this.reconnectTimeout = setTimeout(this.connectAmf,this.reconnectDelay);
            return;
         }
         this.showReconnectNotice();
      }
      
      private function showReconnectNotice() : void
      {
         if(this.reconnectTimeout)
         {
            clearTimeout(this.reconnectTimeout);
         }
         this.popupNotice = new ReconnectNotice();
         this.popupNotice.txt_msg.text = "Connection error, please reconnect.";
         this.popupNotice.btn_reconnect.addEventListener(MouseEvent.CLICK,this.reconnect);
         AppManager.getInstance().main.loader.addChild(this.popupNotice);
      }
      
      private function reconnect(param1:MouseEvent) : void
      {
         this.reconnectAttempt = 0;
         this.connectAmf();
         this.closeReconnectNotice();
      }
      
      private function closeReconnectNotice() : void
      {
         if(this.popupNotice)
         {
            GF.removeAllChild(this.popupNotice);
            this.popupNotice.btn_reconnect.removeEventListener(MouseEvent.CLICK,this.reconnect);
            this.popupNotice.txt_msg.text = "";
            this.popupNotice = null;
         }
      }
      
      private function cleanup() : void
      {
         this.isActive = false;
         if(this.reconnectTimeout)
         {
            clearTimeout(this.reconnectTimeout);
         }
         this.reconnectTimeout = 0;
         if(this.errorHandlerBound)
         {
            this.zendClient.removeEventListener(ErrorEvent.ERROR,this.errorHandler);
            this.errorHandlerBound = false;
         }
         this.zendClient = null;
         this.closeReconnectNotice();
         this.popupNotice = null;
         this.amfName = null;
         this.amfCallback = null;
         this.amfErrorCallback = null;
         this.amfParameter = null;
      }
   }
}

