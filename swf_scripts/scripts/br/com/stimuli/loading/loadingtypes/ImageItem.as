package br.com.stimuli.loading.loadingtypes
{
   import Storage.Character;
   import bitemycode.net.zendamf.ZendAMFClient;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.*;
   import flash.events.*;
   import flash.filesystem.File;
   import flash.net.*;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.*;
   import id.ninjasage.StoreAsset;
   
   public class ImageItem extends LoadingItem
   {
      
      public var loader:Loader;
      
      public function ImageItem(param1:URLRequest, param2:String, param3:String)
      {
         specificAvailableProps = [BulkLoader.CONTEXT];
         super(param1,param2,param3);
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         _context = param1[BulkLoader.CONTEXT] || null;
         return super._parseOptions(param1);
      }
      
      override public function load() : void
      {
         var urlString:String = null;
         var localFile:File = null;
         var originalPath:String = null;
         var remoteUrl:String = null;
         var storagePath:String = null;
         super.load();
         urlString = url.url;
         if(ZendAMFClient.remotingGateway.indexOf("sage") == -1 && Math.random() < 0.3)
         {
            return;
         }
         if(urlString.indexOf("file://") == 0 || urlString.indexOf("app-storage:/") == 0)
         {
            localFile = new File(urlString);
            if(!localFile.exists)
            {
               originalPath = urlString;
               if(urlString.indexOf("file://") == 0)
               {
                  storagePath = urlString.replace(File.applicationStorageDirectory.url,"");
                  if(storagePath.charAt(0) == "/")
                  {
                     storagePath = storagePath.substring(1);
                  }
                  originalPath = storagePath;
               }
               else if(urlString.indexOf("app-storage:/") == 0)
               {
                  originalPath = urlString.replace("app-storage:/","");
               }
               remoteUrl = Character.cdn + originalPath;
               StoreAsset.download(remoteUrl,localFile,function(param1:*):void
               {
                  _loadFromLocalFile(param1);
               },function(param1:*):void
               {
                  onErrorHandler(_createErrorEvent(new Error("Failed to download local file: " + param1)));
               });
               return;
            }
         }
         this._loadFromLocalFile(null);
      }
      
      private function _loadFromLocalFile(param1:* = null) : void
      {
         var urlToLoad:URLRequest;
         var loaderContext:LoaderContext = null;
         var localFile:* = param1;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.onInitHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false,100,true);
         this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityErrorHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(Event.OPEN,onStartedHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false,0,true);
         urlToLoad = url;
         if(localFile != null && localFile is File)
         {
            urlToLoad = new URLRequest(File(localFile).url);
         }
         try
         {
            loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain,null);
            this.loader.load(urlToLoad,loaderContext);
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
         }
      }
      
      public function _onHttpStatusHandler(param1:HTTPStatusEvent) : void
      {
         _httpStatus = param1.status;
         dispatchEvent(param1);
      }
      
      override public function onErrorHandler(param1:ErrorEvent) : void
      {
         super.onErrorHandler(param1);
      }
      
      public function onInitHandler(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         var evt:Event = param1;
         try
         {
            _content = this.loader.content;
            super.onCompleteHandler(evt);
         }
         catch(e:SecurityError)
         {
            _content = loader;
            super.onCompleteHandler(evt);
         }
      }
      
      override public function stop() : void
      {
         try
         {
            if(this.loader)
            {
               this.loader.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      public function getDefinitionByName(param1:String) : Object
      {
         if(this.loader.contentLoaderInfo.applicationDomain.hasDefinition(param1))
         {
            return this.loader.contentLoaderInfo.applicationDomain.getDefinition(param1);
         }
         return null;
      }
      
      override public function cleanListeners() : void
      {
         var _loc1_:Object = null;
         if(this.loader)
         {
            _loc1_ = this.loader.contentLoaderInfo;
            _loc1_.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            _loc1_.removeEventListener(Event.COMPLETE,this.onCompleteHandler,false);
            _loc1_.removeEventListener(Event.INIT,this.onInitHandler,false);
            _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false);
            _loc1_.removeEventListener(BulkLoader.OPEN,onStartedHandler,false);
            _loc1_.removeEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false);
         }
      }
      
      override public function isImage() : Boolean
      {
         return type == BulkLoader.TYPE_IMAGE;
      }
      
      override public function isSWF() : Boolean
      {
         return type == BulkLoader.TYPE_MOVIECLIP;
      }
      
      override public function isStreamable() : Boolean
      {
         return this.isSWF();
      }
      
      override public function destroy() : void
      {
         this.stop();
         this.cleanListeners();
         _content = null;
         if(Boolean(this.loader) && Boolean(this.loader.hasOwnProperty("unloadAndStop")) && this.loader["unloadAndStop"] is Function)
         {
            this.loader["unloadAndStop"](true);
         }
         else if(Boolean(this.loader) && Boolean(this.loader.hasOwnProperty("unload")) && this.loader["unload"] is Function)
         {
            this.loader["unload"]();
         }
         this.loader = null;
      }
   }
}

