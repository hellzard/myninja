package skein.socket.io
{
   public class On
   {
       
      
      public function On()
      {
         super();
      }
      
      public static function on(param1:Object, param2:String, param3:Function) : OnHandle
      {
         var emitter:Object = param1;
         var event:String = param2;
         var listener:Function = param3;
         emitter.on(event,listener);
         var destroy:Function = function():void
         {
            emitter.off(event,listener);
         };
         return new OnHandle(destroy);
      }
   }
}
