package skein.core
{
   import flash.utils.Dictionary;
   
   public class WeakReference implements Reference
   {
      
      private var d:Dictionary;
      
      public function WeakReference(param1:Object)
      {
         super();
         this.d = new Dictionary(true);
         this.d[param1] = true;
      }
      
      public function get value() : *
      {
         var _loc3_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:Dictionary = this.d;
         var _loc4_:int = 0;
         var _loc5_:* = _loc2_;
         for(_loc3_ in _loc5_)
         {
            return _loc3_;
         }
         return null;
      }
   }
}

