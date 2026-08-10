package id.ninjasage
{
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.crypto.symmetric.IVMode;
   import com.hurlant.crypto.symmetric.PKCS5;
   import com.hurlant.util.Base64;
   import com.hurlant.util.Hex;
   import flash.utils.ByteArray;
   
   public class Crypt
   {
      
      private static var cipher:* = "aes-128-cbc";
      
      public function Crypt()
      {
         super();
      }
      
      public static function encrypt(param1:String, param2:String, param3:*) : *
      {
         param3 = Hex.toArray(Hex.fromString(param3));
         new PKCS5(16).pad(param3);
         var _loc4_:ByteArray = Hex.toArray(Hex.fromString(param1));
         var _loc5_:ByteArray = Hex.toArray(Hex.fromString(param2));
         var _loc6_:ICipher = Crypto.getCipher(Crypt.cipher,_loc5_);
         var _loc7_:IVMode = _loc6_ as IVMode;
         _loc7_.IV = param3;
         _loc6_.encrypt(_loc4_);
         var _loc8_:* = Base64.encodeByteArray(_loc4_);
         _loc6_.dispose();
         _loc4_.clear();
         _loc5_.clear();
         return _loc8_;
      }
      
      public static function decrypt(param1:String, param2:String, param3:*) : *
      {
         param3 = Hex.toArray(Hex.fromString(param3));
         new PKCS5(16).pad(param3);
         var _loc4_:ByteArray = Base64.decodeToByteArray(param1);
         var _loc5_:ByteArray = Hex.toArray(Hex.fromString(param2));
         var _loc6_:ICipher = Crypto.getCipher(Crypt.cipher,_loc5_);
         var _loc7_:IVMode = _loc6_ as IVMode;
         _loc7_.IV = param3;
         _loc6_.decrypt(_loc4_);
         var _loc8_:* = Hex.toString(Hex.fromArray(_loc4_));
         _loc6_.dispose();
         _loc4_.clear();
         _loc5_.clear();
         return _loc8_;
      }
   }
}

