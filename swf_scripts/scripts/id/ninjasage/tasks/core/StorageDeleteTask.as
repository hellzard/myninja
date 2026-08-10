package id.ninjasage.tasks.core
{
   import Storage.Character;
   import flash.events.EventDispatcher;
   import flash.filesystem.File;
   import flash.net.SharedObject;
   import id.ninjasage.tasks.ITask;
   import id.ninjasage.tasks.TaskEvent;
   
   public class StorageDeleteTask extends EventDispatcher implements ITask
   {
      
      private var splash:*;
      
      private var sharedObject:SharedObject;
      
      public function StorageDeleteTask()
      {
         super();
         this.sharedObject = SharedObject.getLocal("ninja_sage");
      }
      
      public function start(param1:*) : *
      {
         this.splash = param1;
         this.initDeleteStorage();
      }
      
      public function initDeleteStorage() : void
      {
         var storageDir:File = null;
         var files:Array = null;
         var f:File = null;
         if(!Character.storage_delete || this.sharedObject.data.hasOwnProperty("storage_deleted_version") && this.sharedObject.data.storage_deleted_version == Character.build_num)
         {
            this.complete();
            return;
         }
         this.splash.status("Deleting storage...");
         storageDir = File.applicationStorageDirectory;
         if(storageDir.exists)
         {
            files = storageDir.getDirectoryListing();
            for each(f in files)
            {
               try
               {
                  if(f.isDirectory)
                  {
                     f.deleteDirectory(true);
                  }
                  else
                  {
                     f.deleteFile();
                  }
               }
               catch(err:Error)
               {
               }
            }
         }
         this.sharedObject.data.storage_deleted_version = Character.build_num;
         this.sharedObject.flush();
         this.complete();
      }
      
      public function complete() : *
      {
         dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
         this.destroy();
      }
      
      public function destroy() : *
      {
         this.splash = null;
         this.sharedObject = null;
      }
   }
}

