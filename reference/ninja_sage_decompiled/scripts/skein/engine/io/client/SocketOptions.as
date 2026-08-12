package skein.engine.io.client
{
   import com.adobe.net.URI;
   
   public class SocketOptions extends TransportOptions
   {
       
      
      public var transports:Array;
      
      public var upgrade:Boolean;
      
      public var host:String;
      
      public function SocketOptions()
      {
         super();
      }
      
      static function fromURI(param1:URI, param2:SocketOptions = null) : SocketOptions
      {
         if(param2 == null)
         {
            param2 = new SocketOptions();
         }
         param2.hostname = param1.authority;
         param2.secure = param1.scheme == "https" || param1.scheme == "wss";
         if(param1.port)
         {
            param2.port = Number(param1.port);
         }
         if(param1.queryRaw)
         {
            param2.query = param1.queryRaw;
         }
         return param2;
      }
   }
}
