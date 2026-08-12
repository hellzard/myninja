package socket.io.parser
{
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class Decoder extends EventDispatcher
   {
       
      
      private var reconstructor:BinaryReconstructor;
      
      public function Decoder()
      {
         super();
      }
      
      public function add(param1:*) : void
      {
         var _loc2_:Object = null;
         if("string" == typeof param1)
         {
            _loc2_ = this.decodeString(param1);
            if(Parser.BINARY_EVENT == _loc2_.type || Parser.BINARY_ACK == _loc2_.type)
            {
               this.reconstructor = new BinaryReconstructor(_loc2_);
               if(this.reconstructor.reconPack.attachments === 0)
               {
                  dispatchEvent(new ParserEvent(ParserEvent.DECODED,true,false,_loc2_));
               }
            }
            else
            {
               dispatchEvent(new ParserEvent(ParserEvent.DECODED,true,false,_loc2_));
            }
         }
         else
         {
            if(!(param1 is ByteArray || param1.base64))
            {
               throw new Error("Unknown type: " + param1);
            }
            if(!this.reconstructor)
            {
               throw new Error("got binary data when not reconstructing a packet");
            }
            _loc2_ = this.reconstructor.takeBinaryData(param1);
            if(_loc2_)
            {
               this.reconstructor = null;
               dispatchEvent(new ParserEvent(ParserEvent.DECODED,true,false,_loc2_));
            }
         }
      }
      
      private function decodeString(param1:String) : Object
      {
         var str:String = param1;
         var c:String = null;
         var buf:String = null;
         var p:Object = {};
         var i:Number = 0;
         p.type = Number(str.charAt(0));
         if(null == Parser.TYPES[p.type])
         {
            return this.error();
         }
         if(Parser.BINARY_EVENT == p.type || Parser.BINARY_ACK == p.type)
         {
            buf = "";
            while(str.charAt(++i) != "-")
            {
               buf += str.charAt(i);
               if(i == str.length)
               {
                  break;
               }
            }
            if(isNaN(Number(buf)) || str.charAt(i) != "-")
            {
               throw new Error("Illegal attachments");
            }
            p.attachments = Number(buf);
         }
         if("/" == str.charAt(i + 1))
         {
            p.nsp = "";
            while(++i)
            {
               c = str.charAt(i);
               if("," == c)
               {
                  break;
               }
               p.nsp += c;
               if(i == str.length)
               {
                  break;
               }
            }
         }
         else
         {
            p.nsp = "/";
         }
         var next:String = str.charAt(i + 1);
         if("" !== next && !isNaN(Number(next)))
         {
            p.id = "";
            while(++i)
            {
               c = str.charAt(i);
               if(null == c || isNaN(Number(c)))
               {
                  i--;
                  break;
               }
               p.id += str.charAt(i);
               if(i == str.length)
               {
                  break;
               }
            }
            p.id = Number(p.id);
         }
         if(str.charAt(++i))
         {
            try
            {
               p.data = JSON.parse(str.substr(i));
            }
            catch(e:*)
            {
               return error();
            }
         }
         return p;
      }
      
      public function destroy() : void
      {
         if(this.reconstructor)
         {
            this.reconstructor.finishedReconstruction();
         }
      }
      
      private function error() : Object
      {
         return {
            "type":Parser.ERROR,
            "data":"parser error"
         };
      }
   }
}

import flash.utils.ByteArray;
import socket.io.parser.Binary;

class BinaryReconstructor
{
    
   
   public var reconPack:Object;
   
   public var buffers:Array;
   
   function BinaryReconstructor(param1:Object)
   {
      this.buffers = [];
      super();
      this.reconPack = param1;
   }
   
   public function takeBinaryData(param1:ByteArray) : Object
   {
      var _loc2_:Object = null;
      this.buffers.push(param1);
      if(this.buffers.length == this.reconPack.attachments)
      {
         _loc2_ = Binary.reconstructPacket(this.reconPack,this.buffers);
         this.finishedReconstruction();
         return _loc2_;
      }
      return null;
   }
   
   public function finishedReconstruction() : void
   {
      this.reconPack = null;
      this.buffers = [];
   }
}
