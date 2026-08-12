package com.pnwrain.flashsocket.events
{
   import flash.events.Event;
   
   public class FlashSocketEvent extends Event
   {
      
      public static const CONNECT:String = "connect";
      
      public static const MESSAGE:String = "message";
      
      public static const IO_ERROR:String = "ioError";
      
      public static const SECURITY_ERROR:String = "securityError";
      
      public static const DISCONNECT:String = "disconnect";
      
      public static const CONNECT_ERROR:String = "connectError";
      
      public static const ERROR:String = "error";
       
      
      public var data;
      
      public function FlashSocketEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:FlashSocketEvent = new FlashSocketEvent(type,bubbles,cancelable);
         _loc1_.data = this.data;
         return _loc1_;
      }
      
      override public function toString() : String
      {
         return formatToString("FlashSocketEvent","type","bubbles","cancelable","eventPhase","data");
      }
   }
}
