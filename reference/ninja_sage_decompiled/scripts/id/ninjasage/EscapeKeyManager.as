package id.ninjasage
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class EscapeKeyManager
   {
      
      private static var keyboardEventHandler:EventHandler;
      
      private static var keyboardDispatcher;
      
      private static var managers:Array = [];
       
      
      private var eventHandler:EventHandler;
      
      private var owner:DisplayObject;
      
      private var listeners:Array;
      
      public function EscapeKeyManager(param1:DisplayObject)
      {
         super();
         this.eventHandler = new EventHandler();
         this.listeners = [];
         this.owner = param1;
         managers.push(this);
         this.initDispatcher();
      }
      
      private static function onGlobalKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode != Keyboard.ESCAPE)
         {
            return;
         }
         var _loc2_:int = managers.length - 1;
         while(_loc2_ >= 0)
         {
            if(managers[_loc2_].handleEscape())
            {
               return;
            }
            _loc2_--;
         }
      }
      
      private static function focusNewestManager() : void
      {
         var _loc1_:int = managers.length - 1;
         while(_loc1_ >= 0)
         {
            if(managers[_loc1_] != null && managers[_loc1_].owner != null && managers[_loc1_].owner.stage != null)
            {
               managers[_loc1_].focusOwner();
               return;
            }
            _loc1_--;
         }
      }
      
      private function initDispatcher() : void
      {
         if(this.owner == null)
         {
            return;
         }
         this.eventHandler.addListener(this.owner,Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         if(this.owner.stage != null)
         {
            this.setDispatcher(this.owner.stage);
            return;
         }
         this.eventHandler.addListener(this.owner,Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.eventHandler.removeListener(this.owner,Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.setDispatcher(this.owner.stage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.destroy();
      }
      
      public function setDispatcher(param1:*) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(keyboardDispatcher == param1)
         {
            this.focusOwner();
            return;
         }
         if(keyboardEventHandler == null)
         {
            keyboardEventHandler = new EventHandler();
         }
         if(keyboardDispatcher != null)
         {
            keyboardEventHandler.removeListener(keyboardDispatcher,KeyboardEvent.KEY_DOWN,onGlobalKeyDown);
         }
         keyboardDispatcher = param1;
         keyboardEventHandler.addListener(keyboardDispatcher,KeyboardEvent.KEY_DOWN,onGlobalKeyDown);
         this.focusOwner();
      }
      
      public function addListener(param1:*, param2:Function) : void
      {
         if(param1 == null || param2 == null)
         {
            return;
         }
         this.removeListener(param1,param2);
         this.listeners.push({
            "movieClip":param1,
            "callback":param2
         });
         this.focusOwner();
      }
      
      public function removeListener(param1:*, param2:Function = null) : void
      {
         var _loc3_:int = this.listeners.length - 1;
         while(_loc3_ >= 0)
         {
            if(this.listeners[_loc3_].movieClip == param1 && (param2 == null || this.listeners[_loc3_].callback == param2))
            {
               this.listeners.splice(_loc3_,1);
            }
            _loc3_--;
         }
      }
      
      public function removeAllListeners() : void
      {
         this.listeners = [];
      }
      
      private function handleEscape() : Boolean
      {
         if(this.owner == null || this.owner.stage == null)
         {
            return false;
         }
         var _loc1_:int = this.listeners.length - 1;
         while(_loc1_ >= 0)
         {
            if(this.canTrigger(this.listeners[_loc1_].movieClip))
            {
               this.callCallback(this.listeners[_loc1_].callback);
               return true;
            }
            _loc1_--;
         }
         return false;
      }
      
      private function canTrigger(param1:*) : Boolean
      {
         var _loc2_:DisplayObject = param1 as DisplayObject;
         if(_loc2_ == null || _loc2_.visible != true || _loc2_.stage == null)
         {
            return false;
         }
         while(_loc2_.parent != null)
         {
            _loc2_ = _loc2_.parent;
            if(_loc2_.visible != true)
            {
               return false;
            }
         }
         return true;
      }
      
      private function callCallback(param1:Function) : void
      {
         if(param1.length > 0)
         {
            param1(null);
            return;
         }
         param1();
      }
      
      private function focusOwner() : void
      {
         if(this.owner == null || this.owner.stage == null || !(this.owner is InteractiveObject))
         {
            return;
         }
         InteractiveObject(this.owner).focusRect = false;
         this.owner.stage.focus = InteractiveObject(this.owner);
      }
      
      public function destroy() : void
      {
         var _loc1_:int = managers.length - 1;
         while(_loc1_ >= 0)
         {
            if(managers[_loc1_] == this)
            {
               managers.splice(_loc1_,1);
               break;
            }
            _loc1_--;
         }
         this.removeAllListeners();
         if(this.eventHandler != null)
         {
            this.eventHandler.removeAllEventListeners();
         }
         if(managers.length == 0 && keyboardEventHandler != null && keyboardDispatcher != null)
         {
            keyboardEventHandler.removeListener(keyboardDispatcher,KeyboardEvent.KEY_DOWN,onGlobalKeyDown);
            keyboardDispatcher = null;
         }
         else
         {
            focusNewestManager();
         }
         this.eventHandler = null;
         this.owner = null;
      }
   }
}
