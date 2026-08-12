package Storage
{
   import flash.display.MovieClip;
   
   public class GameData extends MovieClip
   {
      
      private static var data = {};
      
      private static var _constructed = false;
       
      
      public var main;
      
      public function GameData(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         GameData.data = {};
         for each(_loc2_ in param1)
         {
            GameData.data[_loc2_.id] = GameData.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function get constructed() : *
      {
         return GameData._constructed == true;
      }
      
      public static function get(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            return data[param1].data;
         }
         return GameData.prefix();
      }
      
      private static function prefix(param1:* = null) : *
      {
         return {
            "id":(param1 != null && "id" in param1 ? param1.id : ""),
            "data":(param1 != null && "data" in param1 ? param1.data : {})
         };
      }
   }
}
