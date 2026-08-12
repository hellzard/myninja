package id.ninjasage
{
   import flash.utils.getQualifiedClassName;
   
   public class Log
   {
       
      
      public function Log()
      {
         super();
      }
      
      public static function info(... rest) : void
      {
         log("INFO",rest);
      }
      
      public static function warning(... rest) : void
      {
         log("WARNING",rest);
      }
      
      public static function error(... rest) : void
      {
         log("ERROR",rest);
      }
      
      public static function debug(... rest) : void
      {
         log("DEBUG",rest);
      }
      
      private static function log(param1:*, param2:*) : void
      {
         var _loc4_:* = undefined;
         if(param2 == null)
         {
            param2 = [];
         }
         var _loc3_:String = new Date().toLocaleTimeString();
         if(param2.length > 1)
         {
            if(!((_loc4_ = param2[0]) is String))
            {
               _loc4_ = getQualifiedClassName(_loc4_);
               param2.shift();
            }
            return;
         }
      }
   }
}
