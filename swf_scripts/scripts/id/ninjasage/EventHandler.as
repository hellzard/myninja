package id.ninjasage
{
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import id.ninjasage.sounds.SoundAS;
   
   public class EventHandler extends EventDispatcher
   {
      
      private var dispatchList:Array;
      
      private var eventList:Array;
      
      public function EventHandler()
      {
         super();
         this.eventList = [];
         this.dispatchList = [];
      }
      
      public function addListener(param1:*, param2:String, param3:Function, param4:Boolean = false, param5:int = 0, param6:Boolean = true) : void
      {
         var dispatchName:*;
         var wFun:* = undefined;
         var dispatch:* = param1;
         var type:String = param2;
         var listener:Function = param3;
         var useCapture:Boolean = param4;
         var priority:int = param5;
         var useWeakReference:Boolean = param6;
         if(dispatch == null)
         {
            return;
         }
         dispatchName = getQualifiedClassName(dispatch);
         if(!dispatch.hasEventListener(type))
         {
            wFun = type == "click" ? function(param1:*):*
            {
               SoundAS.playFx("sfx:click",0.3);
               listener(param1);
            } : listener;
            this.dispatchList.push({
               "func":dispatch,
               "name":dispatchName
            });
            this.eventList.push({
               "type":type,
               "listener":wFun,
               "useCapture":useCapture
            });
            dispatch.addEventListener(type,wFun,useCapture,priority,useWeakReference);
         }
      }
      
      public function removeListener(param1:*, param2:String, param3:Function, param4:Boolean = false) : void
      {
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         var _loc7_:uint = 0;
         while(_loc7_ < this.eventList.length)
         {
            _loc5_ = this.eventList[_loc7_];
            _loc6_ = this.dispatchList[_loc7_].func;
            if(_loc6_ == param1)
            {
               if(param2 == "click")
               {
                  _loc6_.removeEventListener(param2,_loc5_.listener,param4);
               }
               else if(_loc5_.type == param2 && _loc5_.listener == param3 && _loc5_.useCapture == param4)
               {
                  _loc6_.removeEventListener(param2,param3,param4);
               }
               this.dispatchList.splice(_loc7_,1);
               this.eventList.splice(_loc7_,1);
               break;
            }
            _loc7_++;
         }
         _loc6_ = null;
         _loc5_ = null;
      }
      
      public function removeAllEventListeners() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         while(_loc3_ < this.eventList.length)
         {
            _loc1_ = this.eventList[_loc3_];
            _loc2_ = this.dispatchList[_loc3_].func;
            this.removeTooltip(_loc2_);
            _loc2_.removeEventListener(_loc1_.type,_loc1_.listener,_loc1_.useCapture);
            _loc3_++;
         }
         _loc1_ = null;
         _loc2_ = null;
         this.dispatchList = [];
         this.eventList = [];
      }
      
      public function getAllEventListeners() : Array
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = [];
         while(_loc1_ < this.eventList.length)
         {
            _loc2_.push(this.dispatchList[_loc1_].name + ": " + this.eventList[_loc1_].type);
            _loc1_++;
         }
         return _loc2_;
      }
      
      private function removeTooltip(param1:*) : void
      {
         if(param1.hasOwnProperty("tooltip"))
         {
            delete param1.tooltip;
         }
         if(param1.hasOwnProperty("tooltipCache"))
         {
            delete param1.tooltipCache;
         }
         if(param1.hasOwnProperty("metaData"))
         {
            param1.metaData = {};
         }
      }
   }
}

