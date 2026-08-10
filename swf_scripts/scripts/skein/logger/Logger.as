package skein.logger
{
   public interface Logger
   {
      
      function get appenders() : Vector.<LoggerAppender>;
      
      function set appenders(param1:Vector.<LoggerAppender>) : void;
      
      function log(param1:LogEvent) : void;
   }
}

