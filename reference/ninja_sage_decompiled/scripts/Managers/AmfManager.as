package Managers
{
   import amf.amfConnect;
   
   public class AmfManager
   {
       
      
      public function AmfManager(param1:* = null)
      {
         super();
      }
      
      public function service(param1:String, param2:Array, param3:Function, param4:Boolean = false, param5:* = null) : *
      {
         new amfConnect().service(param1,param2,param3,param4,param5);
      }
   }
}
