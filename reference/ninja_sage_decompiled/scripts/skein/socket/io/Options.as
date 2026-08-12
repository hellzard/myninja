package skein.socket.io
{
   import skein.engine.io.client.SocketOptions;
   
   public class Options extends SocketOptions
   {
       
      
      public var forceNew:Boolean;
      
      public var multiplex:Boolean = true;
      
      public var reconnection:Boolean = true;
      
      public var reconnectionAttempts:int;
      
      public var reconnectionDelay:Number;
      
      public var reconnectionDelayMax:Number;
      
      public var timeout:Number = -1;
      
      public function Options()
      {
         super();
      }
   }
}
