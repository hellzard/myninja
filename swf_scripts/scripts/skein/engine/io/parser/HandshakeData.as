package skein.engine.io.parser
{
   import com.brokenfunction.json.decodeJson;
   
   public class HandshakeData
   {
      
      public var sid:String;
      
      public var upgrades:Array;
      
      public var pingInterval:Number;
      
      public var pingTimeout:Number;
      
      public function HandshakeData()
      {
         super();
      }
      
      public static function parse(param1:String) : HandshakeData
      {
         var _loc2_:Object = decodeJson(param1);
         var _loc3_:HandshakeData = new HandshakeData();
         _loc3_.sid = _loc2_.sid;
         _loc3_.upgrades = _loc2_.upgrades;
         _loc3_.pingInterval = _loc2_.pingInterval;
         _loc3_.pingTimeout = _loc2_.pingTimeout;
         return _loc3_;
      }
   }
}

