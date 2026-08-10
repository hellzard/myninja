package skein.logger.core
{
   import skein.logger.*;
   
   public class LoggerRegistry
   {
      
      private static const _loggers:Object = {};
      
      public function LoggerRegistry()
      {
         super();
      }
      
      public static function getLogger(param1:String) : Logger
      {
         var _loc2_:Class = null;
         var _loc3_:Logger = null;
         if(_loggers.hasOwnProperty(param1))
         {
            return _loggers[param1];
         }
         _loc2_ = Config.getImplementationForTag(param1,Logger);
         if(_loc2_ != null)
         {
            _loc3_ = new _loc2_();
            _loc3_.appenders = Config.releaseLoggerAppenders(param1);
            _loggers[param1] = _loc3_;
            return _loc3_;
         }
         return null;
      }
   }
}

