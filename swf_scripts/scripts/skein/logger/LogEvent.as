package skein.logger
{
   public class LogEvent
   {
      
      private var _tag:String;
      
      private var _level:int;
      
      private var _message:Object;
      
      public function LogEvent(param1:String, param2:int, param3:Object)
      {
         super();
         this._tag = param1;
         this._level = param2;
         this._message = param3;
      }
      
      public function get tag() : String
      {
         return this._tag;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get levelForDisplay() : String
      {
         switch(this._level - 3)
         {
            case 0:
               return "DEBUG";
            case 1:
               return "INFO";
            case 2:
               return "WARN";
            case 3:
               return "ERROR";
            default:
               return "UNKNOWN";
         }
      }
      
      public function get message() : Object
      {
         return this._message;
      }
   }
}

