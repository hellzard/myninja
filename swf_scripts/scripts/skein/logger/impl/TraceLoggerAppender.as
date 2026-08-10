package skein.logger.impl
{
   import skein.logger.LogEvent;
   import skein.logger.LoggerAppender;
   import skein.logger.LoggerLayout;
   
   public class TraceLoggerAppender implements LoggerAppender
   {
      
      private var _layout:LoggerLayout;
      
      public function TraceLoggerAppender(param1:LoggerLayout)
      {
         super();
         this._layout = param1;
      }
      
      public function get layout() : LoggerLayout
      {
         return this._layout;
      }
      
      public function append(param1:LogEvent) : void
      {
      }
   }
}

