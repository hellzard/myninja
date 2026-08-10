package skein.logger
{
   public interface LoggerAppender
   {
      
      function get layout() : LoggerLayout;
      
      function append(param1:LogEvent) : void;
   }
}

