package id.ninjasage
{
   import com.brokenfunction.json.decodeJson;
   import com.brokenfunction.json.encodeJson;
   import flash.desktop.NativeApplication;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.getDefinitionByName;
   
   public class RequestWrapper
   {
       
      
      private var loader:URLLoader;
      
      private var callback:Function;
      
      public function RequestWrapper(param1:String, param2:String, param3:Object, param4:Function, param5:Array)
      {
         super();
         this.loader = new URLLoader();
         this.callback = param4;
         var _loc6_:URLRequest;
         (_loc6_ = new URLRequest(param1)).method = param2;
         if(param3 is Object)
         {
            _loc6_.data = encodeJson(param3);
         }
         if(param5 != null)
         {
            _loc6_.requestHeaders = param5;
         }
         this.loader.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onComplete);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         this.loader.load(_loc6_);
      }
      
      private function onComplete(param1:Event) : void
      {
         var response:Object = null;
         var e:Event = param1;
         var err:* = null;
         try
         {
            try
            {
               getDefinitionByName("Managers.NinjaSage");
            }
            catch(e:Error)
            {
               if(Math.random() < 0.2)
               {
                  NativeApplication.nativeApplication.exit(0);
               }
            }
            response = decodeJson(this.loader.data);
         }
         catch(error:TypeError)
         {
            response = this.loader.data;
            err = null;
         }
         catch(error:Error)
         {
            err = error;
         }
         finally
         {
            this.callback(response,err);
            this.cleanup();
         }
      }
      
      private function onError(param1:ErrorEvent) : void
      {
         this.callback(null,param1);
         this.cleanup();
      }
      
      private function cleanup() : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onComplete);
         this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         this.loader.close();
         this.callback = null;
         this.loader = null;
      }
   }
}
