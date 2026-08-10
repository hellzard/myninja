package socket.io.parser
{
   public class Encoder
   {
      
      public function Encoder()
      {
         super();
      }
      
      public function encode(param1:Object) : Array
      {
         if(Parser.BINARY_EVENT == param1.type || Parser.BINARY_ACK == param1.type)
         {
            return this.encodeAsBinary(param1);
         }
         return [this.encodeAsString(param1)];
      }
      
      public function encodeAsString(param1:Object) : String
      {
         var _loc2_:* = "";
         var _loc3_:Boolean = false;
         _loc2_ += param1.type;
         if(Parser.BINARY_EVENT == param1.type || Parser.BINARY_ACK == param1.type)
         {
            _loc2_ += param1.attachments;
            _loc2_ += "-";
         }
         if(Boolean(param1.nsp) && "/" != param1.nsp)
         {
            _loc3_ = true;
            _loc2_ += param1.nsp;
         }
         if(null != param1.id)
         {
            if(_loc3_)
            {
               _loc2_ += ",";
               _loc3_ = false;
            }
            _loc2_ += param1.id;
         }
         if(null != param1.data)
         {
            if(_loc3_)
            {
               _loc2_ += ",";
            }
            _loc2_ += JSON.stringify(param1.data);
         }
         return _loc2_;
      }
      
      public function encodeAsBinary(param1:Object) : Array
      {
         var _loc4_:Array = null;
         var _loc2_:Object = Binary.deconstructPacket(param1);
         var _loc3_:String = this.encodeAsString(_loc2_.packet);
         _loc4_ = _loc2_.buffers;
         _loc4_.unshift(_loc3_);
         return _loc4_;
      }
   }
}

