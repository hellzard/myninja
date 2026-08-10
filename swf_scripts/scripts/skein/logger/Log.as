package skein.logger
{
   import skein.logger.core.Config;
   import skein.logger.core.LoggerRegistry;
   
   public class Log
   {
      
      public static const DEBUG:uint = 3;
      
      public static const INFO:uint = 4;
      
      public static const WARN:uint = 5;
      
      public static const ERROR:uint = 6;
      
      public static const DEFAULT:uint = 6;
      
      public static const DISABLED:uint = 4294967295;
      
      public function Log()
      {
         super();
      }
      
      public static function d(param1:String, param2:Object) : void
      {
         if(Config.getLogLevelForTag(param1) <= 3)
         {
            log(3,param1,param2);
         }
      }
      
      public static function i(param1:String, param2:Object) : void
      {
         if(Config.getLogLevelForTag(param1) <= 4)
         {
            log(4,param1,param2);
         }
      }
      
      public static function w(param1:String, param2:Object) : void
      {
         if(Config.getLogLevelForTag(param1) <= 5)
         {
            log(5,param1,param2);
         }
      }
      
      public static function e(param1:String, param2:Object) : void
      {
         if(Config.getLogLevelForTag(param1) <= 6)
         {
            log(6,param1,param2);
         }
      }
      
      private static function log(param1:uint, param2:String, param3:Object) : void
      {
         if(LoggerRegistry.getLogger(param2) != null)
         {
            LoggerRegistry.getLogger(param2).log(new LogEvent(param2,param1,param3));
         }
      }
   }
}

