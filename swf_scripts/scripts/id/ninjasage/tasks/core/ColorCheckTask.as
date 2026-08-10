package id.ninjasage.tasks.core
{
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.events.ErrorEvent;
   import flash.events.EventDispatcher;
   import id.ninjasage.tasks.ITask;
   import id.ninjasage.tasks.TaskEvent;
   
   public class ColorCheckTask extends EventDispatcher implements ITask
   {
      
      private var splash:*;
      
      private var tempLoader:*;
      
      private const RGB_API:String = "http://127.0.0.1:800/api/id-custom-color";
      
      public function ColorCheckTask()
      {
         super();
         this.tempLoader = BulkLoader.createUniqueNamedLoader(1,BulkLoader.LOG_INFO);
      }
      
      public function start(param1:*) : *
      {
         this.splash = param1;
         param1.status("Checking version...");
         this.tempLoader.add(this.RGB_API,{
            "id":"api",
            "type":BulkLoader.TYPE_TEXT
         });
         this.tempLoader.addEventListener(BulkLoader.COMPLETE,this.onLoaded);
         this.tempLoader.addEventListener(BulkLoader.ERROR,this.onLoadError);
         this.tempLoader.start();
      }
      
      private function onLoaded(param1:BulkProgressEvent) : *
      {
         this.cleanup();
         var _loc2_:Object = JSON.parse(this.tempLoader.getContent("api"));
         Character.rgb_data = "data" in _loc2_ ? _loc2_.data : {};
         this.complete();
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

