package socket.io.parser
{
   import flash.events.Event;
   
   public class ParserEvent extends Event
   {
      
      public static const DECODED:String = "decoded";
      
      public var packet:Object;
      
      public function ParserEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:* = null)
      {
         super(param1,param2,param3);
         this.packet = param4;
      }
      
      override public function clone() : Event
      {
         var _loc1_:ParserEvent = new ParserEvent(type,bubbles,cancelable);
         _loc1_.packet = this.packet;
         return _loc1_;
      }
      
      override public function toString() : String
      {
         return formatToString("ParserEvent","type","bubbles","cancelable","eventPhase","packet");
      }
   }
}

