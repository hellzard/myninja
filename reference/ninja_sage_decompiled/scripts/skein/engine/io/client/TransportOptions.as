package skein.engine.io.client
{
   public class TransportOptions
   {
       
      
      public var hostname:String;
      
      public var path:String;
      
      public var secure:Boolean;
      
      public var timestampParam:String;
      
      public var timestampRequests:Boolean;
      
      public var port:int;
      
      public var policyPort:int;
      
      public var query:Object;
      
      public function TransportOptions()
      {
         super();
      }
   }
}
