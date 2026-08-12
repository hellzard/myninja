package id.ninjasage
{
   import flash.net.URLRequestMethod;
   
   public class Http
   {
       
      
      public function Http()
      {
         super();
      }
      
      public static function get(param1:String, param2:Function, param3:Array = null) : void
      {
         new RequestWrapper(param1,URLRequestMethod.GET,null,param2,param3);
      }
      
      public static function post(param1:String, param2:Object, param3:Function, param4:Array = null) : void
      {
         new RequestWrapper(param1,URLRequestMethod.POST,param2,param3,param4);
      }
   }
}
