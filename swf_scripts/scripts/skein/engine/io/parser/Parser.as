package skein.engine.io.parser
{
   public class Parser
   {
      
      public static const protocol:int = 4;
      
      private static const SEPARATOR:String = String.fromCharCode(30);
      
      private static const packets:Object = {};
      
      private static const bipackets:Object = {};
      
      private static const err:Packet = new Packet(Packet.ERROR,"parser error");
      
      packets[Packet.OPEN] = 0;
      packets[Packet.CLOSE] = 1;
      packets[Packet.PING] = 2;
      packets[Packet.PONG] = 3;
      packets[Packet.MESSAGE] = 4;
      packets[Packet.UPGRADE] = 5;
      packets[Packet.NOOP] = 6;
      bipackets[0] = Packet.OPEN;
      bipackets[1] = Packet.CLOSE;
      bipackets[2] = Packet.PING;
      bipackets[3] = Packet.PONG;
      bipackets[4] = Packet.MESSAGE;
      bipackets[5] = Packet.UPGRADE;
      bipackets[6] = Packet.NOOP;
      
      public function Parser()
      {
         super();
      }
      
      public static function encodePacket(param1:Packet) : String
      {
         var _loc2_:String = String(packets[param1.type]);
         if(param1.data != null)
         {
            _loc2_ += param1.data;
         }
         if(protocol == 4)
         {
            return _loc2_;
         }
         return encodeURIComponent(_loc2_);
      }
      
      public static function decodePacket(param1:String) : Packet
      {
         var _loc2_:int = -1;
         try
         {
            _loc2_ = parseInt(param1.charAt(0));
         }
         catch(error:Error)
         {
         }
         if(!bipackets.hasOwnProperty(_loc2_))
         {
            return err;
         }
         return new Packet(bipackets[_loc2_],param1.length > 1 ? param1.substring(1) : null);
      }
      
      public static function encodePayload(param1:Array) : String
      {
         var _loc4_:Packet = null;
         var _loc5_:String = null;
         if(param1.length == 0)
         {
            return protocol == 4 ? "" : "0:";
         }
         var _loc2_:String = "";
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            _loc5_ = encodePacket(_loc4_);
            if(protocol == 4)
            {
               _loc3_.push(_loc5_);
            }
            else
            {
               _loc2_ += _loc5_.length + ":" + _loc5_;
            }
         }
         if(protocol == 4)
         {
            return _loc3_.join(SEPARATOR);
         }
         return _loc2_;
      }
      
      public static function decodePayload(param1:String, param2:Function) : void
      {
         var length:String;
         var i:int;
         var l:*;
         var messages:Array = null;
         var j:int = 0;
         var decoded:Packet = null;
         var shouldContinue:Boolean = false;
         var char:String = null;
         var n:int = 0;
         var msg:String = null;
         var packet:Packet = null;
         var ret:Boolean = false;
         var data:String = param1;
         var callback:Function = param2;
         if(!data)
         {
            callback(err,0,1);
            return;
         }
         if(protocol == 4)
         {
            messages = data.split(SEPARATOR);
            j = 0;
            while(j < messages.length)
            {
               decoded = decodePacket(messages[j]);
               if(decoded.type == err.type && decoded.data == err.data)
               {
                  callback(err,0,1);
                  return;
               }
               shouldContinue = callback(decoded,j,messages.length);
               if(!shouldContinue)
               {
                  return;
               }
               j++;
            }
            return;
         }
         length = "";
         i = 0;
         l = data.length;
         while(i < l)
         {
            char = data.charAt(i);
            if(":" != char)
            {
               length += char;
            }
            else
            {
               try
               {
                  n = parseInt(length);
               }
               catch(e:Error)
               {
                  callback(err,0,1);
                  return;
               }
               try
               {
                  msg = data.substring(i + 1,i + 1 + n);
               }
               catch(e:Error)
               {
                  callback(err,0,1);
                  return;
               }
               if(msg.length != 0)
               {
                  packet = decodePacket(msg);
                  if(packet.type == err.type && packet.data == err.data)
                  {
                     callback(err,0,1);
                     return;
                  }
                  ret = callback(packet,i + n,l);
                  if(!ret)
                  {
                     return;
                  }
               }
               i += n;
               length = "";
            }
            i++;
         }
         if(length.length > 0)
         {
            callback(err,0,1);
         }
      }
   }
}

