package socket.io.parser
{
   import flash.utils.ByteArray;
   
   public class Binary
   {
      
      public function Binary()
      {
         super();
      }
      
      public static function deconstructPacket(param1:Object) : Object
      {
         var buffers:Array = null;
         var packet:Object = param1;
         buffers = null;
         var _packet:Object = packet;
         var _deconstructPacket:Function = function(param1:*):*
         {
            var _loc2_:Object = null;
            var _loc3_:Array = null;
            var _loc4_:Number = NaN;
            var _loc5_:Object = null;
            var _loc6_:* = null;
            if(!param1)
            {
               return param1;
            }
            if(param1 is ByteArray)
            {
               _loc2_ = {
                  "_placeholder":true,
                  "num":buffers.length
               };
               buffers.push(param1);
               return _loc2_;
            }
            if(param1 is Array)
            {
               _loc3_ = new Array(param1.length);
               _loc4_ = 0;
               while(_loc4_ < param1.length)
               {
                  _loc3_[_loc4_] = _deconstructPacket(param1[_loc4_]);
                  _loc4_++;
               }
               return _loc3_;
            }
            if("object" == typeof param1 && !(param1 is Date))
            {
               _loc5_ = {};
               for(_loc6_ in param1)
               {
                  _loc5_[_loc6_] = _deconstructPacket(param1[_loc6_]);
               }
               return _loc5_;
            }
            return param1;
         };
         buffers = [];
         var packetData:* = _packet.data;
         var pack:Object = _packet;
         pack.data = _deconstructPacket(packetData);
         pack.attachments = buffers.length;
         return {
            "packet":pack,
            "buffers":buffers
         };
      }
      
      public static function reconstructPacket(param1:Object, param2:Array) : Object
      {
         var packet:Object = param1;
         var buffers:Array = param2;
         var _reconstructPacket:Function = function(param1:*):*
         {
            var _loc2_:ByteArray = null;
            var _loc3_:Number = NaN;
            var _loc4_:* = null;
            if(Boolean(param1) && Boolean("_placeholder" in param1) && Boolean(param1._placeholder))
            {
               return buffers[param1.num];
            }
            if(param1 is Array)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.length)
               {
                  param1[_loc3_] = _reconstructPacket(param1[_loc3_]);
                  _loc3_++;
               }
               return param1;
            }
            if(Boolean(param1) && "object" == typeof param1)
            {
               for(_loc4_ in param1)
               {
                  param1[_loc4_] = _reconstructPacket(param1[_loc4_]);
               }
               return param1;
            }
            return param1;
         };
         var curPlaceHolder:Number = 0;
         packet.data = _reconstructPacket(packet.data);
         packet.attachments = undefined;
         return packet;
      }
   }
}

