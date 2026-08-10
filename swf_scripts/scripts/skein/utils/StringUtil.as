package skein.utils
{
   public class StringUtil
   {
      
      public function StringUtil()
      {
         super();
      }
      
      public static function substitute(param1:String, ... rest) : String
      {
         var _loc5_:uint = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return "";
         }
         _loc5_ = uint(rest.length);
         if(_loc5_ == 1 && rest[0] is Array)
         {
            _loc3_ = rest[0] as Array;
            _loc5_ = uint(_loc3_.length);
         }
         else
         {
            _loc3_ = rest;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            param1 = param1.replace(new RegExp("\\{" + _loc4_ + "\\}","g"),_loc3_[_loc4_]);
            _loc4_++;
         }
         return param1;
      }
      
      public static function trim(param1:String) : String
      {
         if(param1 == null)
         {
            return "";
         }
         var _loc2_:int = 0;
         while(isWhitespace(param1.charAt(_loc2_)))
         {
            _loc2_++;
         }
         var _loc3_:* = int(param1.length - 1);
         while(isWhitespace(param1.charAt(_loc3_)))
         {
            _loc3_--;
         }
         if(_loc3_ >= _loc2_)
         {
            return param1.slice(_loc2_,_loc3_ + 1);
         }
         return "";
      }
      
      public static function isWhitespace(param1:String) : Boolean
      {
         switch(param1)
         {
            case " ":
            case "\t":
            case "\r":
            case "\n":
            case "\f":
               return true;
            default:
               return false;
         }
      }
   }
}

