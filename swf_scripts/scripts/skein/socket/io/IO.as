package skein.socket.io
{
   import com.adobe.net.URI;
   import skein.socket.io.parser.Parser;
   
   public class IO
   {
      
      public static const protocol:int = Parser.protocol;
      
      private static var managers:Object = {};
      
      public function IO()
      {
         super();
      }
      
      public static function socket(param1:String, param2:Options = null) : Socket
      {
         var _loc4_:Manager = null;
         var _loc6_:String = null;
         if(param2 == null)
         {
            param2 = new Options();
         }
         var _loc3_:URI = new URI(param1);
         if(param2.forceNew || !param2.multiplex)
         {
            _loc4_ = new Manager(_loc3_,param2);
         }
         else
         {
            _loc6_ = URL.extractId(_loc3_);
            if(!managers.hasOwnProperty(_loc6_))
            {
               _loc4_ = managers[_loc6_] = new Manager(_loc3_,param2);
            }
            else
            {
               _loc4_ = managers[_loc6_];
            }
         }
         var _loc5_:String = _loc3_.path || "/";
         return _loc4_.socket(_loc5_);
      }
      
      public static function removeManager(param1:String) : void
      {
         var _loc2_:URI = new URI(param1);
         var _loc3_:String = URL.extractId(_loc2_);
         if(managers.hasOwnProperty(_loc3_))
         {
            delete managers[_loc3_];
         }
      }
   }
}

