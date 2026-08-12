package id.ninjasage.tasks.core
{
   import Storage.Character;
   import flash.events.EventDispatcher;
   import id.ninjasage.Util;
   import id.ninjasage.sounds.SoundAS;
   import id.ninjasage.tasks.ITask;
   import id.ninjasage.tasks.TaskEvent;
   
   public class VersionCheckTask extends EventDispatcher implements ITask
   {
       
      
      private var main;
      
      private var splash;
      
      private var errorCount = 0;
      
      public function VersionCheckTask(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public function start(param1:*) : *
      {
         this.splash = param1;
         param1.status("Checking version...");
         this.main.amf_manager.service("qgnNJXdbTxOLTF3S.6zWoiSDdFxW3",[Character.build_num],this.callback,true,this.errorCallback);
      }
      
      private function callback(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(param1.status == 1)
         {
            this.splash.status("Already latest version");
            Character._ = Number(param1._);
            Character.__ = param1.__;
            Character.cdn = param1.cdn;
            Character.storage_delete = param1._rm;
            this.initSounds();
            this.complete();
         }
         else if(param1.status == 2)
         {
            this.splash.status("Please update your game.");
            this.splash.increase(1);
            this.main.getUpdate();
         }
         else if(param1.status == 3)
         {
            this.splash.status("Game is under maintenance.");
            this.splash.increase(1);
            this.main.getNotice("The game is under active maintenance, please check back later!");
         }
         else
         {
            _loc2_ = "Failed to start the game.";
            if("status" in param1)
            {
               _loc2_ += " Error Code: " + param1.status;
            }
            this.splash.status(_loc2_);
            this.splash.increase(1);
         }
      }
      
      private function initSounds() : void
      {
         SoundAS.loadSound(Util.url("sounds/click.mp3"),"sfx:click");
      }
      
      public function complete() : *
      {
         dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
         this.destroy();
      }
      
      private function errorCallback(param1:*) : *
      {
         ++this.errorCount;
         this.splash.status("Disconnected from the server. Re-trying to connect (" + this.errorCount + ")");
         if(this.errorCount >= 10)
         {
            this.splash.status("Unable to connect to the server. " + ("description" in param1 ? param1.description : "500"));
         }
      }
      
      public function destroy() : *
      {
         this.main = null;
         this.splash = null;
      }
   }
}
