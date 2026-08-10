package skein.engine.io.client.transport
{
   import skein.engine.io.client.TransportOptions;
   import skein.engine.io.client.transport.xhr.Request;
   import skein.engine.io.client.transport.xhr.RequestOptions;
   import skein.logger.Log;
   
   public class PollingXHR extends Polling
   {
      
      private var sendXhr:Request;
      
      private var pollXhr:Request;
      
      public function PollingXHR(param1:TransportOptions)
      {
         super(param1);
      }
      
      override protected function doWrite(param1:String, param2:Function) : void
      {
         var data:String = param1;
         var fn:Function = param2;
         var opts:RequestOptions = new RequestOptions();
         opts.method = "POST";
         opts.data = data;
         this.sendXhr = this.request(opts);
         this.sendXhr.on(Request.EVENT_SUCCESS,function():void
         {
            fn.apply();
         });
         this.sendXhr.on(Request.EVENT_ERROR,function(param1:Error = null):void
         {
            onError("xhr post error",param1);
         });
         this.sendXhr.create();
      }
      
      override protected function doPoll() : void
      {
         Log.d("engine.io","xhr poll");
         this.pollXhr = this.request();
         this.pollXhr.on(Request.EVENT_DATA,function(param1:String):void
         {
            onData(param1);
         });
         this.pollXhr.on(Request.EVENT_ERROR,function(param1:Error = null):void
         {
            onError("xhr poll error",param1);
         });
         this.pollXhr.create();
      }
      
      protected function request(param1:RequestOptions = null) : Request
      {
         var request:Request;
         var opts:RequestOptions = param1;
         if(opts == null)
         {
            opts = new RequestOptions();
         }
         opts.uri = this.uri();
         request = new Request(opts);
         request.on(Request.EVENT_REQUEST_HEADERS,function(param1:Array):void
         {
            emit(EVENT_REQUEST_HEADERS,param1);
         }).on(Request.EVENT_RESPONSE_HEADERS,function(param1:Array):void
         {
            emit(EVENT_RESPONSE_HEADERS,param1);
         });
         return request;
      }
   }
}

