package skein.engine.io.client.transport.websocket
{
   public interface WebSocketClientDataSource
   {
       
      
      function webSocketClientID() : int;
      
      function webSocketClientHostname() : String;
      
      function webSocketClientOrigin() : String;
      
      function webSocketClientCookie() : String;
   }
}
