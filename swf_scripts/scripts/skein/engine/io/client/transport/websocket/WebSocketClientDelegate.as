package skein.engine.io.client.transport.websocket
{
   public interface WebSocketClientDelegate
   {
      
      function webSocketClientDidOpen() : void;
      
      function webSocketClientDidClose() : void;
      
      function webSocketClientDidError() : void;
      
      function webSocketClientDidMessage(param1:String) : void;
   }
}

