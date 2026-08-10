package skein.utils
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class DelayUtil
   {
      
      private static var _callLaterDisplayObject:Shape;
      
      private static var _callLaterIsListeningForRender:Boolean;
      
      private static var stretches:Array = [];
      
      private static var _callLaterQueue:Vector.<Function> = new Vector.<Function>(0);
      
      private static var _callLaterDict:Dictionary = new Dictionary(true);
      
      public function DelayUtil()
      {
         super();
      }
      
      public static function delayToEvent(param1:Object, param2:String, param3:Function, ... rest) : void
      {
         var dispatcher:Object = param1;
         var event:String = param2;
         var callback:Function = param3;
         var args:Array = rest;
         dispatcher.addEventListener(event,(function():*
         {
            var handler:* = undefined;
            handler = function(param1:Object):void
            {
               dispatcher.removeEventListener(event,handler);
               callback.apply(null,args);
            };
            return handler;
         })());
      }
      
      public static function delayToTimeout(param1:uint, param2:Function, ... rest) : void
      {
         var timer:Timer = null;
         var timeout:uint = param1;
         var callback:Function = param2;
         var args:Array = rest;
         timer = new Timer(timeout,1);
         timer.addEventListener("timerComplete",(function():*
         {
            var handler:* = undefined;
            handler = function(param1:Object):void
            {
               timer.removeEventListener("timerComplete",handler);
               callback.apply(null,args);
            };
            return handler;
         })());
         timer.start();
      }
      
      public static function stretchToTimeout(param1:uint, param2:Function, ... rest) : void
      {
         var o:Object = null;
         var timer:Timer = null;
         var timeout:uint = param1;
         var callback:Function = param2;
         var args:Array = rest;
         for each(o in stretches)
         {
            if(o.callback == callback)
            {
               o.args = args;
               o.timer.reset();
               o.timer.start();
               return;
            }
         }
         timer = new Timer(timeout,1);
         timer.addEventListener("timerComplete",(function():*
         {
            var handler:* = undefined;
            handler = function(param1:Object):void
            {
               var _loc3_:* = 0;
               var _loc4_:* = 0;
               var _loc5_:* = null;
               timer.removeEventListener("timerComplete",arguments.callee);
               _loc3_ = 0;
               _loc4_ = int(stretches.length);
               while(_loc3_ < _loc4_)
               {
                  _loc5_ = stretches[_loc3_];
                  if(_loc5_.callback == callback)
                  {
                     stretches.splice(_loc3_,1);
                     _loc5_.callback.apply(null,_loc5_.args);
                     break;
                  }
                  _loc3_++;
               }
            };
            return handler;
         })());
         timer.start();
         stretches.push({
            "callback":callback,
            "timer":timer,
            "args":args
         });
      }
      
      public static function callLater(param1:Function) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(_callLaterDict[param1])
         {
            return;
         }
         _callLaterQueue[_callLaterQueue.length] = param1;
         _callLaterDict[param1] = true;
         if(_callLaterDisplayObject == null)
         {
            _callLaterDisplayObject = new Shape();
         }
         if(!_callLaterIsListeningForRender)
         {
            _callLaterIsListeningForRender = true;
            _callLaterDisplayObject.addEventListener("enterFrame",_callLaterDisplayObjectRenderHandler);
         }
      }
      
      private static function _callLaterDisplayObjectRenderHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         _callLaterDisplayObject.removeEventListener("enterFrame",_callLaterDisplayObjectRenderHandler);
         _callLaterIsListeningForRender = false;
         var _loc4_:Vector.<Function> = _callLaterQueue.concat();
         _callLaterQueue.length = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            _loc3_ = _loc4_[_loc2_];
            _loc4_[_loc2_].apply(null);
            _loc2_++;
         }
      }
   }
}

class DelayedCall
{
   
   private var _method:Function;
   
   private var _args:Array;
   
   public function DelayedCall(param1:Function, param2:Array)
   {
      super();
      this._method = param1;
      this._args = param2;
   }
   
   public function get method() : Function
   {
      return this._method;
   }
   
   public function get args() : Array
   {
      return this._args;
   }
}
