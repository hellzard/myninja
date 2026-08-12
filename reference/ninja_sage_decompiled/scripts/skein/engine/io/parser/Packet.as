package skein.engine.io.parser
{
   public class Packet
   {
      
      public static const OPEN:String = "open";
      
      public static const CLOSE:String = "close";
      
      public static const PING:String = "ping";
      
      public static const PONG:String = "pong";
      
      public static const UPGRADE:String = "upgrade";
      
      public static const MESSAGE:String = "message";
      
      public static const NOOP:String = "noop";
      
      public static const ERROR:String = "error";
       
      
      public var type:String;
      
      public var data:String;
      
      public function Packet(param1:String, param2:String = null)
      {
         super();
         this.type = param1;
         this.data = param2;
      }
   }
}
