package skein.emitter
{
   public class Emitter
   {
       
      
      private var callbacksMap:Object;
      
      private var onceCallbacks:Vector.<Function>;
      
      public function Emitter()
      {
         super();
      }
      
      public function on(param1:String, param2:Function) : Emitter
      {
         if(this.callbacksMap == null)
         {
            this.callbacksMap = new Object();
         }
         var _loc3_:Vector.<Function> = this.callbacksMap[param1] as Vector.<Function>;
         if(_loc3_ == null)
         {
            this.callbacksMap[param1] = new <Function>[param2];
         }
         else if(_loc3_.indexOf(param2) == -1)
         {
            _loc3_.push(param2);
         }
         return this;
      }
      
      public function once(param1:String, param2:Function) : Emitter
      {
         if(this.onceCallbacks)
         {
            this.onceCallbacks = new Vector.<Function>();
         }
         this.on(param1,param2);
         return this;
      }
      
      public function off(param1:String = null, param2:Function = null) : Emitter
      {
         var _loc3_:Vector.<Function> = null;
         var _loc4_:Vector.<Function> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Function = null;
         if(param1 == null && param2 == null)
         {
            if(this.callbacksMap)
            {
               this.callbacksMap = null;
            }
         }
         else if(param1 != null && param2 == null)
         {
            if(this.callbacksMap)
            {
               if(this.callbacksMap.hasOwnProperty(param1))
               {
                  this.callbacksMap[param1] = null;
                  delete this.callbacksMap[param1];
               }
            }
         }
         else if(param1 != null && param2 != null)
         {
            if(this.callbacksMap)
            {
               _loc3_ = this.callbacksMap[param1] as Vector.<Function>;
               if(_loc3_)
               {
                  _loc4_ = new Vector.<Function>(0);
                  _loc5_ = 0;
                  _loc6_ = _loc3_.length;
                  while(_loc5_ < _loc6_)
                  {
                     if((_loc7_ = _loc3_[_loc5_]) != param2)
                     {
                        _loc4_.push(_loc7_);
                     }
                     _loc5_++;
                  }
                  this.callbacksMap[param1] = _loc4_;
               }
            }
         }
         return this;
      }
      
      public function emit(param1:String, ... rest) : Emitter
      {
         var _loc3_:Vector.<Function> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Function = null;
         var _loc7_:int = 0;
         if(this.callbacksMap)
         {
            _loc3_ = this.callbacksMap[param1] as Vector.<Function>;
            if(_loc3_)
            {
               _loc4_ = 0;
               _loc5_ = _loc3_.length;
               while(_loc4_ < _loc5_)
               {
                  (_loc6_ = _loc3_[_loc4_]).apply(null,rest);
                  if((_loc7_ = !!this.onceCallbacks ? int(this.onceCallbacks.indexOf(_loc6_)) : -1) != -1)
                  {
                     this.onceCallbacks.splice(_loc7_,1);
                     this.off(param1,_loc6_);
                  }
                  _loc4_++;
               }
            }
         }
         return this;
      }
   }
}
