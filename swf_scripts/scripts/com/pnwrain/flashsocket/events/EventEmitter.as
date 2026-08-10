package com.pnwrain.flashsocket.events
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   
   public class EventEmitter extends EventDispatcher
   {
      
      private var _wrapped:Dictionary;
      
      public function EventEmitter(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function on(param1:String, param2:Function) : void
      {
         addEventListener(param1,param2);
      }
      
      public function once(param1:String, param2:Function) : void
      {
         var type:String = param1;
         var listener:Function = param2;
         if(!this._wrapped)
         {
            this._wrapped = new Dictionary(true);
         }
         this._wrapped[listener] = function():void
         {
            if(!(listener in _wrapped))
            {
               return;
            }
            removeListener(type,listener);
            listener.apply(this,arguments);
         };
         this.on(type,this._wrapped[listener]);
      }
      
      public function removeListener(param1:String, param2:Function) : void
      {
         if(Boolean(this._wrapped) && param2 in this._wrapped)
         {
            removeEventListener(param1,this._wrapped[param2]);
            delete this._wrapped[param2];
         }
         else
         {
            removeEventListener(param1,param2);
         }
      }
      
      public function _emit(param1:String, param2:Object = null) : void
      {
         var _loc3_:FlashSocketEvent = new FlashSocketEvent(param1);
         _loc3_.data = param2;
         dispatchEvent(_loc3_);
      }
   }
}

