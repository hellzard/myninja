package id.ninjasage
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class StoreAsset
   {
      
      private var url:String;
      
      private var urlLoader:URLLoader;
      
      private var path:File;
      
      private var fs:FileStream;
      
      private var onCompleteCallback:Function;
      
      private var onErrorCallback:Function;
      
      public function StoreAsset(param1:String, param2:File, param3:Function = null, param4:Function = null)
      {
         super();
         this.url = param1;
         this.path = param2;
         this.onCompleteCallback = param3;
         this.onErrorCallback = param4;
      }
      
      public static function download(param1:String, param2:File, param3:Function = null, param4:Function = null) : StoreAsset
      {
         var _loc5_:StoreAsset = new StoreAsset(param1,param2,param3,param4);
         _loc5_.store();
         return _loc5_;
      }
      
      private function store() : void
      {
         var urlRequest:URLRequest;
         if(!this.url || !this.path)
         {
            if(this.onErrorCallback != null)
            {
               this.onErrorCallback("Invalid url or path");
            }
            return;
         }
         urlRequest = new URLRequest(this.url);
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onComplete);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         try
         {
            this.urlLoader.load(urlRequest);
         }
         catch(error:Error)
         {
            Log.error(this,"Unable to store assets:",this.url,error);
            if(onErrorCallback != null)
            {
               onErrorCallback(error);
            }
            destroy();
         }
      }
      
      private function onComplete(param1:Event) : void
      {
         if(!param1.target.hasOwnProperty("data"))
         {
            Log.error(this,"Unable to save:",this.url);
            if(this.onErrorCallback != null)
            {
               this.onErrorCallback("No data received");
            }
            this.destroy();
            return;
         }
         this.fs = new FileStream();
         this.fs.addEventListener(IOErrorEvent.IO_ERROR,this.onFileSaveError);
         this.fs.open(this.path,FileMode.WRITE);
         this.fs.writeBytes(param1.target.data);
         this.fs.close();
         if(this.onCompleteCallback != null)
         {
            this.onCompleteCallback(this.path);
         }
         this.destroy();
      }
      
      private function onFileSaveError(param1:IOErrorEvent) : void
      {
         Log.error(this,"Unable to open/save to a file:",this.url,this.path,param1.toString());
         if(this.onErrorCallback != null)
         {
            this.onErrorCallback(param1);
         }
         this.destroy();
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
         Log.error(this,"Download error:",this.url,param1.toString());
         if(this.onErrorCallback != null)
         {
            this.onErrorCallback(param1);
         }
         this.destroy();
      }
      
      private function destroy() : void
      {
         if(this.urlLoader)
         {
            this.urlLoader.removeEventListener(Event.COMPLETE,this.onComplete);
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this.urlLoader.close();
            this.urlLoader = null;
         }
         if(this.fs)
         {
            this.fs.removeEventListener(IOErrorEvent.IO_ERROR,this.onFileSaveError);
            this.fs = null;
         }
         this.path = null;
         this.url = null;
         this.onCompleteCallback = null;
         this.onErrorCallback = null;
      }
   }
}

