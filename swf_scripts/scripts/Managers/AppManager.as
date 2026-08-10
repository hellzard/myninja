package Managers
{
   import Panels.SplashScreen;
   import Storage.StorageLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.utils.setTimeout;
   import id.ninjasage.tasks.TaskEvent;
   import id.ninjasage.tasks.core.ColorCheckTask;
   import id.ninjasage.tasks.core.ImageDownloadTask;
   import id.ninjasage.tasks.core.InitTask;
   import id.ninjasage.tasks.core.StorageDeleteTask;
   import id.ninjasage.tasks.core.UpdateCheckTask;
   import id.ninjasage.tasks.core.VersionCheckTask;
   
   public class AppManager
   {
      
      private static var _instance:AppManager;
      
      private var splashScreen:MovieClip;
      
      public var main:*;
      
      private var stage:*;
      
      private var tasks:Array;
      
      private var tasksCount:int;
      
      private var tasksCompleted:int;
      
      private var finalDelay:* = 200;
      
      public function AppManager(param1:*, param2:*)
      {
         super();
         if(AppManager._instance != null)
         {
            throw new Error("Cannot reinstantiate AppManager");
         }
         this.main = param1;
         this.stage = param2;
      }
      
      public static function getInstance() : *
      {
         if(AppManager._instance == null)
         {
            throw new Error("Not instantiated");
         }
         return AppManager._instance;
      }
      
      public static function boot(param1:*, param2:*) : *
      {
         if(AppManager._instance != null)
         {
            return;
         }
         AppManager._instance = new AppManager(param1,param2);
         AppManager.getInstance().run();
      }
      
      private function run() : *
      {
         this.splashScreen = new SplashScreen();
         this.main.loader.addChild(this.splashScreen);
         this.tasksCompleted = 0;
         this.tasks = [new InitTask(this.main,this.stage),null,new VersionCheckTask(this.main),new StorageLoader(),new ColorCheckTask(),new ImageDownloadTask(this.main),true ? new StorageDeleteTask() : null];
         this.tasksCount = this.tasks.length;
         this.splashScreen.setPercentagePerTask(this.tasksCount);
         this.nextTask();
      }
      
      private function allTaskCompleted() : *
      {
         setTimeout(this.final,this.finalDelay);
      }
      
      private function final() : *
      {
         this.main.loadPanel("Managers.LoginManager");
         if(this.main.loader.contains(this.splashScreen))
         {
            this.main.loader.removeChild(this.splashScreen);
         }
         GF.removeAllChild(this.splashScreen);
         this.splashScreen = null;
         GF.clearArray(this.tasks);
      }
      
      private function nextTask() : void
      {
         var _loc1_:* = undefined;
         if(this.tasks[0] != null && this.tasks.length > 0)
         {
            _loc1_ = this.tasks.shift();
            _loc1_.addEventListener(TaskEvent.COMPLETE,this.onTaskComplete);
            _loc1_.addEventListener(TaskEvent.ERROR,this.onTaskError);
            _loc1_.start(this.splashScreen);
         }
         else if(this.tasks.length == 0)
         {
            this.allTaskCompleted();
         }
         else
         {
            this.tasks.shift();
            this.nextTask();
         }
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc2_:* = param1.target;
         this.clearTaskListener(_loc2_);
         ++this.tasksCompleted;
         this.splashScreen.increase(this.splashScreen.calculateTask(this.tasksCompleted,this.tasksCount));
         this.nextTask();
      }
      
      private function onTaskError(param1:TaskEvent) : void
      {
         var _loc2_:* = param1.target;
         this.clearTaskListener(_loc2_);
         this.nextTask();
      }
      
      private function clearTaskListener(param1:*) : *
      {
         param1.removeEventListener(TaskEvent.COMPLETE,this.onTaskComplete);
         param1.removeEventListener(TaskEvent.ERROR,this.onTaskError);
      }
   }
}

