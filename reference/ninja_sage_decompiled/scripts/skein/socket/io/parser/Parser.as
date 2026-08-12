package skein.socket.io.parser
{
   import com.brokenfunction.json.decodeJson;
   import com.brokenfunction.json.encodeJson;
   import skein.logger.Log;
   import skein.utils.StringUtil;
   
   public class Parser
   {
      
      public static const CONNECT:int = 0;
      
      public static const DISCONNECT:int = 1;
      
      public static const EVENT:int = 2;
      
      public static const ACK:int = 3;
      
      public static const CONNECT_ERROR:int = 4;
      
      public static const BINARY_EVENT:int = 5;
      
      public static const BINARY_ACK:int = 6;
      
      public static const ERROR:int = CONNECT_ERROR;
      
      public static const protocol:int = 5;
      
      public static const types:Array = ["CONNECT","DISCONNECT","EVENT","ACK","CONNECT_ERROR","BINARY_EVENT","BINARY_ACK"];
       
      
      public function Parser()
      {
         super();
      }
      
      public static function encode(param1:Packet) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = false;
         _loc2_ += param1.type;
         if(param1.nsp && "/" != param1.nsp)
         {
            _loc3_ = true;
            _loc2_ += param1.nsp;
         }
         if(param1.id != -1)
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
            _loc2_ += encodeJson(param1.data);
         }
         Log.d("socket.io",["encoded %j as %s",param1,_loc2_]);
         return _loc2_;
      }
      
      public static function decode(param1:String) : Packet
      {
         var c:* = undefined;
         var id:String = null;
         var str:String = param1;
         var p:* = new Packet();
         var i:* = 0;
         p.type = Number(str.charAt(0));
         if(null == types[p.type])
         {
            return error();
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
               if(i + 1 == str.length)
               {
                  break;
               }
            }
         }
         else
         {
            p.nsp = "/";
         }
         var next:* = str.charAt(i + 1);
         if("" != next && Number(next) == next)
         {
            id = "";
            while(++i)
            {
               c = str.charAt(i);
               if(null == c || Number(c) != c)
               {
                  i--;
                  break;
               }
               id += str.charAt(i);
               if(i + 1 == str.length)
               {
                  break;
               }
            }
            p.id = Number(id);
         }
         if(str.charAt(++i))
         {
            try
            {
               p.data = decodeJson(str.substr(i));
            }
            catch(e:*)
            {
               return error();
            }
         }
         Log.d("socket.io",StringUtil.substitute("decoded {0} as {1}",str,p));
         return p;
      }
      
      private static function error() : Packet
      {
         return new Packet(2);
      }
   }
}
