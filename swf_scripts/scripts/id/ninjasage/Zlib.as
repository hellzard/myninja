package id.ninjasage
{
   import flash.utils.ByteArray;
   
   public class Zlib
   {
      
      public function Zlib()
      {
         super();
      }
      
      public static function compress(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.compress("zlib");
         return _loc2_;
      }
      
      public static function decompress(param1:ByteArray) : *
      {
         param1.uncompress("zlib");
         return param1.readUTFBytes(param1.length);
      }
   }
}

