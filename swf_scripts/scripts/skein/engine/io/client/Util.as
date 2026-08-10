package skein.engine.io.client
{
   public class Util
   {
      
      public function Util()
      {
         super();
      }
      
      public static function qs(param1:Object) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         for(_loc3_ in param1)
         {
            if(_loc2_.length > 0)
            {
               _loc2_ += "&";
            }
            _loc2_ += encodeURIComponent(_loc3_) + "=" + encodeURIComponent(param1[_loc3_]);
         }
         return _loc2_.toString();
      }
      
      public static function qsParse(param1:String) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:Object = new Object();
         var _loc3_:Array = param1.split("&");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.split("=");
            _loc2_[_loc5_[0]] = _loc5_[1];
         }
         return _loc2_;
      }
      
      public static function encodeURIComponent(param1:String) : String
      {
         return escape(param1).replace("+","%20").replace("%21","!").replace("%27","\'").replace("%28","(").replace("%29",")").replace("%7E","~");
      }
      
      public static function decodeURIComponent(param1:String) : String
      {
         return unescape(param1);
      }
   }
}

