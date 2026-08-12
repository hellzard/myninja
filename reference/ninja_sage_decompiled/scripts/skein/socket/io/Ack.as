package skein.socket.io
{
   public class Ack
   {
       
      
      private var acknowledgeFunction:Function;
      
      public function Ack(param1:Function)
      {
         super();
         this.acknowledgeFunction = param1;
      }
      
      public function call(... rest) : void
      {
         this.acknowledgeFunction.apply(null,rest);
      }
   }
}
