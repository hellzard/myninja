package id.ninjasage.tasks.core
{
   import Managers.AmfManager;
   import Managers.ExamManager;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.PanelManager;
   import Managers.StatManager;
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.CreateFilter;
   import flash.display.StageScaleMode;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import flash.system.System;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.Stats;
   import id.ninjasage.sounds.SoundAS;
   import id.ninjasage.tasks.ITask;
   import id.ninjasage.tasks.TaskEvent;
   
   public class InitTask extends EventDispatcher implements ITask
   {
       
      
      private var main;
      
      private var stage;
      
      private var splash;
      
      public function InitTask(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.stage = param2;
      }
      
      public function start(param1:*) : *
      {
         var splash:* = param1;
         this.splash = splash;
         this.splash.status("Initializing...");
         try
         {
            this.initSO();
            this.initMain();
            this.complete();
         }
         catch(e:*)
         {
            Log.error(this,"Init",e);
            this.error(e);
         }
      }
      
      private function initMain() : *
      {
         var _loc1_:* = undefined;
         if(ExternalInterface.available)
         {
            _loc1_ = ExternalInterface.call("window.navigator.userAgent.toString");
            Character.web = _loc1_ != null;
         }
         this.main.eventHandler = new EventHandler();
         this.main.panelLoader = new BulkLoader("panels",10);
         new BulkLoader("assets",10);
         new BulkLoader("combat",10);
         new BulkLoader("skills",10);
         new BulkLoader("talents",10);
         new BulkLoader("specialclass",10);
         new BulkLoader("etc",10);
         new PanelManager();
         new ExamManager();
         if(false == false)
         {
            this.stage.addChild(new Stats(this.main));
         }
         this.main.amf_manager = new AmfManager();
         this.main.stat_manager = new StatManager();
         this.main.outfit_manager = new OutfitManager(this.main);
         this.main.dimFilter = CreateFilter.getSaturationFilter(0);
         this.main.pvp_tooltip = ToolTip.getInstance(true);
         NinjaSage.initTooltipAndEventHandler(this.main);
      }
      
      private function initSO() : *
      {
         var _loc5_:* = undefined;
         this.stage.scaleMode = StageScaleMode.EXACT_FIT;
         var _loc1_:Number = System.freeMemory / (1024 * 1024);
         var _loc2_:String = "MEDIUM";
         var _loc3_:int = 40;
         if(_loc1_ < 100)
         {
            _loc2_ = "LOW";
            _loc3_ = 24;
         }
         else if(_loc1_ < 200)
         {
            _loc2_ = "MEDIUM";
            _loc3_ = 30;
         }
         this.stage.quality = _loc2_;
         this.stage.frameRate = _loc3_;
         var _loc4_:*;
         if((_loc4_ = SharedObject.getLocal("ninja_sage")).data.option_quality)
         {
            this.stage.quality = _loc4_.data.option_quality;
         }
         if(_loc4_.data.option_volume != null)
         {
            SoundMixer.soundTransform = new SoundTransform(Math.min(1,_loc4_.data.option_volume));
         }
         if(_loc4_.data.option_framerate != null)
         {
            if((_loc5_ = int(_loc4_.data.option_framerate)) >= 24 && _loc5_ <= 40)
            {
               this.stage.frameRate = _loc5_;
            }
         }
         if(_loc4_.data.option_enable_bgm)
         {
            this.main.bgm_enabled = true;
         }
         if(_loc4_.data.hasOwnProperty("option_enable_sfx"))
         {
            SoundAS.enableSfx = _loc4_.data.option_enable_sfx;
         }
         if(_loc4_.data.option_is_stickman)
         {
            Character.is_stickman = _loc4_.data.option_is_stickman;
         }
         if(_loc4_.data.hasOwnProperty("option_item_animation"))
         {
            Character.play_items_animation = _loc4_.data.option_item_animation;
         }
         if(_loc4_.data.hasOwnProperty("option_intel_animation"))
         {
            Character.intel_class_animation = _loc4_.data.option_intel_animation;
         }
         if(_loc4_.data.hasOwnProperty("option_senjutsu_animation"))
         {
            Character.senjutsu_animation = _loc4_.data.option_senjutsu_animation;
         }
         if(_loc4_.data.hasOwnProperty("option_is_new_village"))
         {
            Character.is_new_village = _loc4_.data.option_is_new_village;
         }
         _loc4_ = null;
      }
      
      public function complete() : *
      {
         this.splash.status("Game initialized");
         dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
         this.destroy();
      }
      
      public function error(param1:*) : *
      {
         this.splash.status("Failed to initialized error: " + param1);
         dispatchEvent(new TaskEvent(TaskEvent.ERROR,param1));
         this.destroy();
      }
      
      private function destroy() : *
      {
         this.main = null;
         this.stage = null;
         this.splash = null;
      }
   }
}
