package skein.logger.impl
{
   import skein.logger.LogEvent;
   import skein.logger.LoggerLayout;
   
   public class SimpleLoggerLayout implements LoggerLayout
   {
      
      public function SimpleLoggerLayout()
      {
         super();
      }
      
      public function format(param1:LogEvent) : Object
      {
         return "[" + param1.tag + "] " + param1.levelForDisplay + ": " + param1.message;
      }
   }
}

