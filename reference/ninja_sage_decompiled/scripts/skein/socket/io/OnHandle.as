package skein.socket.io
{
   public class OnHandle
   {
       
      
      private var destroyFunction:Function;
      
      public function OnHandle(param1:Function)
      {
         super();
         this.destroyFunction = param1;
      }
      
      public function destroy() : void
      {
         this.destroyFunction.apply();
      }
   }
}
