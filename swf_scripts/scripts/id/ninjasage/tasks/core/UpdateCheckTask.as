package id.ninjasage.tasks.core
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.events.ErrorEvent;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import id.ninjasage.tasks.ITask;
   import id.ninjasage.tasks.TaskEvent;
   
   public class UpdateCheckTask extends EventDispatcher implements ITask
   {
      
      private var splash:*;
      
      private var tempLoader:*;
      
      private const UPDATE_API:String = "http://127.0.0.1:800/api/game/releases/latest";
      
      public function UpdateCheckTask()
      {
         super();
         this.tempLoader = BulkLoader.createUniqueNamedLoader(1,BulkLoader.LOG_INFO);
      }
      
      public function start(param1:*) : *
      {
         this.splash = param1;
         param1.status("Checking for update...");
         this.tempLoader.add(this.UPDATE_API,{
            "id":"api",
            "type":BulkLoader.TYPE_TEXT
         });
         this.tempLoader.addEventListener(BulkLoader.COMPLETE,this.onLoaded);
         this.tempLoader.addEventListener(BulkLoader.ERROR,this.onLoadError);
         this.tempLoader.start();
      }
      
      private function onLoaded(param1:BulkProgressEvent) : *
      {
      }
      
      private function startUpdater(param1:String) : void
      {
      }
      
      private function onUpdaterInitialized(param1:*) : void
      {
      }
      
      private function onUpdaterCheck(param1:*) : void
      {
      }
      
      private function onDownloadProgress(param1:ProgressEvent) : void
      {
      }
      
      private function onDownloadComplete(param1:*) : void
      {
      }
      
      private function onExitTimer(param1:TimerEvent) : void
      {
      }
      
      private function exitApplication() : void
      {
      }
      
      private function onUpdaterError(param1:ErrorEvent) : void
      {
      }
      
      private function writeTempUpdateDescriptor(param1:String, param2:String) : *
      {
      }
      
      private function escapeXML(param1:String) : String
      {
         return param1.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&apos;");
      }
      
      private function onLoadError(param1:ErrorEvent) : *
      {
         this.cleanup();
         this.complete();
      }
      
      public function complete() : *
      {
         dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
         this.destroy();
      }
      
      private function cleanup() : *
      {
         this.tempLoader.removeEventListener(BulkLoader.COMPLETE,this.onLoaded);
         this.tempLoader.removeEventListener(BulkLoader.ERROR,this.onLoadError);
      }
      
      public function destroy() : *
      {
         this.splash = null;
         this.tempLoader.clear();
         this.tempLoader = null;
      }
   }
}

