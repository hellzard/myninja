package id.ninjasage.tasks
{
   import flash.events.Event;
   
   public class TaskEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
      
      public static const ERROR:String = "error";
       
      
      public var message:String;
      
      public function TaskEvent(param1:String, param2:String = "", param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.message = param2;
      }
      
      override public function clone() : Event
      {
         return new TaskEvent(type,this.message,bubbles,cancelable);
      }
   }
}
