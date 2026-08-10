package skein.logger.impl
{
   import skein.logger.LogEvent;
   import skein.logger.Logger;
   import skein.logger.LoggerAppender;
   
   public class DefaultLogger implements Logger
   {
      
      private var _appenders:Vector.<LoggerAppender>;
      
      public function DefaultLogger()
      {
         super();
      }
      
      public function get appenders() : Vector.<LoggerAppender>
      {
         return this._appenders;
      }
      
      public function set appenders(param1:Vector.<LoggerAppender>) : void
      {
         this._appenders = param1;
      }
      
      public function log(param1:LogEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._appenders != null && this._appenders.length > 0)
         {
            _loc2_ = 0;
            _loc3_ = int(this._appenders.length);
            while(_loc2_ < _loc3_)
            {
               this._appenders[_loc2_].append(param1);
               _loc2_++;
            }
         }
      }
   }
}

