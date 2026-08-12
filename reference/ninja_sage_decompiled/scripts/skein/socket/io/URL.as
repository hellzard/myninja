package skein.socket.io
{
   import com.adobe.net.URI;
   
   public class URL
   {
       
      
      public function URL()
      {
         super();
      }
      
      public static function extractId(param1:URI) : String
      {
         return param1.scheme + "://" + param1.authority + (!!param1.port ? ":" + param1.port : "");
      }
   }
}
