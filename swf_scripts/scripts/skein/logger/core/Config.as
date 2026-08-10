package skein.logger.core
{
   import flash.utils.Dictionary;
   import skein.logger.Logger;
   import skein.logger.LoggerAppender;
   import skein.logger.impl.DefaultLogger;
   import skein.logger.impl.SimpleLoggerLayout;
   import skein.logger.impl.TraceLoggerAppender;
   
   public class Config
   {
      
      private static var instance:Config;
      
      private static var _defaultImplementations:Dictionary = new Dictionary();
      
      private static var _implementations:Object = {};
      
      private static var _tagLogLevels:Object = {};
      
      private static var _loggerAppenders:Object = {};
      
      _defaultImplementations[Logger] = DefaultLogger;
      
      public function Config()
      {
         super();
      }
      
      public static function get sharedInstance() : Config
      {
         if(instance == null)
         {
            instance = new Config();
         }
         return instance;
      }
      
      public static function setImplementationForTag(param1:String, param2:Class, param3:Class) : void
      {
         if(!_implementations.hasOwnProperty(param1))
         {
            _implementations = new Dictionary();
         }
         _implementations[param1][param2] = param3;
      }
      
      public static function getImplementationForTag(param1:String, param2:Class) : Class
      {
         if(_implementations.hasOwnProperty(param1))
         {
            return _implementations[param1][param2] || _defaultImplementations[param2];
         }
         return _defaultImplementations[param2];
      }
      
      public static function logLevelForTag(param1:String) : Object
      {
         if(!_tagLogLevels.hasOwnProperty(param1))
         {
            _tagLogLevels[param1] = {"logLevel":6};
         }
         return _tagLogLevels[param1];
      }
      
      public static function setLogLevelForTag(param1:String, param2:uint) : *
      {
         logLevelForTag(param1).logLevel = param2;
      }
      
      public static function getLogLevelForTag(param1:String) : uint
      {
         return logLevelForTag(param1).logLevel;
      }
      
      public static function releaseLoggerAppenders(param1:String) : Vector.<LoggerAppender>
      {
         var _loc2_:Vector.<LoggerAppender> = _loggerAppenders[param1];
         _loggerAppenders[param1] = null;
         if(_loc2_ == null || _loc2_.length == 0)
         {
            _loc2_ = new <LoggerAppender>[new TraceLoggerAppender(new SimpleLoggerLayout())];
         }
         return _loc2_;
      }
      
      public static function retainLoggerAppendersForTag(param1:String, param2:Vector.<LoggerAppender>) : void
      {
         _loggerAppenders[param1] = param2;
      }
   }
}

