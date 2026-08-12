package skein.socket.io.parser
{
   public class Packet
   {
       
      
      public var type:int = -1;
      
      public var id:int = -1;
      
      public var nsp:String;
      
      public var data:Object;
      
      public function Packet(param1:int = -1, param2:Object = null)
      {
         super();
         this.type = param1;
         this.data = param2;
      }
   }
}
