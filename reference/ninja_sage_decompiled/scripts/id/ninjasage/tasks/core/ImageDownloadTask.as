package id.ninjasage.tasks.core
{
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.EventDispatcher;
   import flash.filesystem.File;
   import id.ninjasage.StoreAsset;
   import id.ninjasage.tasks.ITask;
   import id.ninjasage.tasks.TaskEvent;
   
   public class ImageDownloadTask extends EventDispatcher implements ITask
   {
       
      
      private var splash;
      
      private var tempLoader;
      
      private var data;
      
      private var main;
      
      private var loaded = 0;
      
      private var downloading = 0;
      
      private var downloadQueue:Array;
      
      private var pendingDownloads:Object;
      
      public function ImageDownloadTask(param1:*)
      {
         this.downloadQueue = [];
         this.pendingDownloads = {};
         super();
         this.main = param1;
         this.tempLoader = BulkLoader.createUniqueNamedLoader(12,BulkLoader.LOG_INFO);
      }
      
      public function start(param1:*) : *
      {
         this.splash = param1;
         param1.status("Loading events images...");
         this.main.amf_manager.service("P82btEvICVSugCUp.N3M3nS3I5og3",null,this.eventDataResponse,true,this.errorGetEvent);
      }
      
      public function errorGetEvent(param1:*) : *
      {
         this.splash.status("Unable to get event images.");
         this.complete();
      }
      
      private function eventDataResponse(param1:*) : *
      {
         if(param1 && param1.hasOwnProperty("status") && param1.status == 1)
         {
            this.data = param1.events;
            this.checkAndDownloadImages();
         }
         else
         {
            this.complete();
         }
      }
      
      private function checkAndDownloadImages() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:File = null;
         if(this.data.hasOwnProperty("seasonal") && this.data.seasonal is Array && this.data.seasonal.length > 0)
         {
            this.loaded = 0;
            this.downloading = 0;
            this.downloadQueue = [];
            this.pendingDownloads = {};
            _loc1_ = false;
            _loc1_ = true;
            _loc2_ = 0;
            while(_loc2_ < this.data.seasonal.length)
            {
               _loc3_ = this.data.seasonal[_loc2_].img;
               _loc4_ = this.extractFileName(_loc3_);
               _loc5_ = "tmp/" + _loc4_;
               if(!(_loc6_ = File.applicationStorageDirectory.resolvePath(_loc5_)).exists)
               {
                  this.downloadQueue.push({
                     "index":_loc2_,
                     "url":_loc3_,
                     "localFile":_loc6_
                  });
               }
               _loc2_++;
            }
            if(this.downloadQueue.length > 0)
            {
               this.splash.status("Downloading events images...");
               this.downloadNext();
            }
            else
            {
               this.loadImages();
            }
            if(!_loc1_)
            {
               this.loadImages();
            }
         }
         else
         {
            this.complete();
         }
      }
      
      private function extractFileName(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         var _loc2_:int = param1.lastIndexOf("/");
         if(_loc2_ >= 0 && _loc2_ < param1.length - 1)
         {
            return param1.substring(_loc2_ + 1);
         }
         return param1;
      }
      
      private function downloadNext() : void
      {
         var item:Object = null;
         var directory:File = null;
         var self:ImageDownloadTask = null;
         if(this.downloadQueue.length == 0)
         {
            this.loadImages();
            return;
         }
         item = this.downloadQueue.shift();
         ++this.downloading;
         this.pendingDownloads[item.index] = item;
         directory = item.localFile.parent;
         if(!directory.exists)
         {
            try
            {
               directory.createDirectory();
            }
            catch(error:Error)
            {
            }
         }
         self = this;
         StoreAsset.download(item.url,item.localFile,function(param1:*):void
         {
            self.onDownloadComplete(item.index);
         },function(param1:*):void
         {
            self.onDownloadError(item.index);
         });
      }
      
      private function onDownloadComplete(param1:int) : void
      {
         --this.downloading;
         delete this.pendingDownloads[param1];
         var _loc2_:Number = (this.data.seasonal.length - this.downloadQueue.length - this.downloading) / this.data.seasonal.length;
         this.splash.status("Downloading events images... (" + Math.floor(_loc2_ * 100) + "%)");
         this.splash.increase(_loc2_);
         this.downloadNext();
      }
      
      private function onDownloadError(param1:int) : void
      {
         --this.downloading;
         delete this.pendingDownloads[param1];
         this.downloadNext();
      }
      
      private function loadImages() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:File = null;
         if(this.data.hasOwnProperty("seasonal") && this.data.seasonal is Array && this.data.seasonal.length > 0)
         {
            this.loaded = 0;
            _loc1_ = 0;
            while(_loc1_ < this.data.seasonal.length)
            {
               _loc2_ = this.data.seasonal[_loc1_].img;
               _loc3_ = _loc2_;
               _loc6_ = this.extractFileName(_loc2_);
               _loc7_ = "tmp/" + _loc6_;
               if((_loc8_ = File.applicationStorageDirectory.resolvePath(_loc7_)).exists)
               {
                  _loc3_ = _loc8_.url;
               }
               _loc4_ = "img:" + _loc1_;
               _loc5_ = this.tempLoader.add(_loc3_,{
                  "id":_loc4_,
                  "type":BulkLoader.TYPE_IMAGE,
                  "maxTries":0
               });
               this.tempLoader.get(_loc4_).addEventListener(BulkLoader.COMPLETE,this.completeImg,false,0,true);
               this.tempLoader.get(_loc4_).addEventListener(BulkLoader.ERROR,this.errImg,false,0,true);
               _loc1_++;
            }
            this.tempLoader.addEventListener(BulkLoader.COMPLETE,this.onImageComplete);
            this.splash.startSubProgress();
            this.tempLoader.start();
         }
         else
         {
            this.complete();
         }
      }
      
      function completeImg(param1:*) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:* = int(param1.target.id.split(":")[1]);
         this.data.seasonal[_loc3_].image = param1.target.content;
         this.checkComplete();
      }
      
      function errImg(param1:*) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.checkComplete();
      }
      
      function checkComplete() : *
      {
         ++this.loaded;
         var _loc1_:* = Math.floor(this.loaded / Math.max(1,this.data.seasonal.length));
         this.splash.status("Loading events images... (" + _loc1_ * 100 + "%)");
         this.splash.increase(_loc1_);
         if(this.loaded >= this.data.seasonal.length)
         {
            Character.event_data = this.data;
            this.complete();
         }
      }
      
      function onImageComplete(param1:*) : void
      {
         this.complete();
      }
      
      public function complete() : *
      {
         this.splash.reset();
         dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
         this.destroy();
      }
      
      public function destroy() : *
      {
         this.tempLoader.removeEventListener(BulkLoader.COMPLETE,this.onImageComplete);
         this.tempLoader.clear();
         this.tempLoader = null;
         this.splash = null;
         this.data = null;
         this.main = null;
         this.downloadQueue = null;
         this.pendingDownloads = null;
      }
   }
}
