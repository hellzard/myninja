package skein.engine.io.client.transport.xhr
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import skein.emitter.Emitter;
   import skein.logger.Log;
   import skein.utils.StringUtil;
   
   public class Request extends Emitter
   {
      
      public static const EVENT_SUCCESS:String = "success";
      
      public static const EVENT_DATA:String = "data";
      
      public static const EVENT_ERROR:String = "error";
      
      public static const EVENT_REQUEST_HEADERS:String = "requestHeaders";
      
      public static const EVENT_RESPONSE_HEADERS:String = "responseHeaders";
      
      internal var method:String;
      
      internal var uri:String;
      
      internal var data:String;
      
      internal var xhr:URLLoader;
      
      public function Request(param1:RequestOptions)
      {
         super();
         this.method = param1.method || "GET";
         this.uri = param1.uri;
         this.data = param1.data;
      }
      
      public function create() : void
      {
         var request:URLRequest;
         var headers:Array;
         var resultHandler:Function = null;
         var responseStatusHandler:Function = null;
         var errorHandler:Function = null;
         Log.d("engine.io",StringUtil.substitute("xhr open {0}: {1}",this.method,this.uri));
         this.xhr = new URLLoader();
         request = new URLRequest(this.uri);
         request.method = this.method;
         headers = [];
         if(this.method == "POST")
         {
            request.data = this.data;
            headers.push(new URLRequestHeader("Content-Type","text/plain;charset=UTF-8"));
         }
         this.onRequestHeaders(headers);
         request.requestHeaders = headers;
         resultHandler = function(param1:Event):void
         {
            xhr.removeEventListener(Event.COMPLETE,resultHandler);
            xhr.removeEventListener("httpResponseStatus",responseStatusHandler);
            xhr.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
            xhr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
            onData(xhr.data);
         };
         responseStatusHandler = function(param1:HTTPStatusEvent):void
         {
            onResponseHeaders(param1.responseHeaders);
         };
         errorHandler = function(param1:ErrorEvent):void
         {
            xhr.removeEventListener(Event.COMPLETE,resultHandler);
            xhr.removeEventListener("httpResponseStatus",responseStatusHandler);
            xhr.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
            xhr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
            onError(new Error(param1.text,param1.errorID));
         };
         this.xhr.addEventListener(Event.COMPLETE,resultHandler);
         this.xhr.addEventListener("httpResponseStatus",responseStatusHandler);
         this.xhr.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
         this.xhr.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
         this.xhr.load(request);
      }
      
      private function onSuccess() : void
      {
         this.emit(EVENT_SUCCESS);
         this.cleanup();
      }
      
      private function onData(param1:String) : void
      {
         this.emit(EVENT_DATA,param1);
         this.onSuccess();
      }
      
      private function onError(param1:Error) : void
      {
         this.emit(EVENT_ERROR,param1);
         this.cleanup();
      }
      
      private function onRequestHeaders(param1:Array) : *
      {
         this.emit(EVENT_REQUEST_HEADERS,param1);
      }
      
      private function onResponseHeaders(param1:Array) : *
      {
         this.emit(EVENT_RESPONSE_HEADERS,param1);
      }
      
      private function cleanup() : *
      {
         if(this.xhr != null)
         {
            this.xhr.close();
            this.xhr = null;
         }
      }
      
      public function abort() : void
      {
         this.cleanup();
      }
   }
}

