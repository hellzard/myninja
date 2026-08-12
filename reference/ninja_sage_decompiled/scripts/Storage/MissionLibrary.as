package Storage
{
   import flash.display.MovieClip;
   
   public class MissionLibrary extends MovieClip
   {
      
      private static var data = {};
      
      private static var _constructed = false;
       
      
      public var main;
      
      public function MissionLibrary(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         MissionLibrary.data = {};
         for each(_loc2_ in param1)
         {
            MissionLibrary.data[_loc2_.id] = MissionLibrary.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function getMissionInfo(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         return MissionLibrary.prefix();
      }
      
      public static function getCopy(param1:*) : *
      {
         return JSON.parse(JSON.stringify(MissionLibrary.getMissionInfo(param1)));
      }
      
      private static function prefix(param1:* = null) : *
      {
         return {
            "msn_id":(param1 != null && "id" in param1 ? param1.id : "null"),
            "msn_enemy":(param1 != null && "enemies" in param1 ? param1.enemies : []),
            "msn_bg":(param1 != null && "bg" in param1 ? param1.bg : "null"),
            "msn_grade":(param1 != null && "grade" in param1 ? param1.grade : "a"),
            "msn_name":(param1 != null && "name" in param1 ? param1.name : "null"),
            "msn_description":(param1 != null && "description" in param1 ? param1.description : "null"),
            "msn_level":(param1 != null && "level" in param1 ? param1.level : 1),
            "msn_premium":(param1 != null && "premium" in param1 ? param1.premium : false),
            "msn_dialog":(param1 != null && "dialog" in param1 ? param1.dialog : []),
            "msn_visible":(param1 != null && "visible" in param1 ? param1.visible : false),
            "msn_rewards":(param1 != null && "rewards" in param1 ? param1.rewards : [])
         };
      }
      
      public static function getMissionIds(param1:*) : *
      {
         var item:* = undefined;
         var grade:* = param1;
         var items:* = [];
         for(item in data)
         {
            if(data[item].msn_grade == grade)
            {
               if(!(data[item].hasOwnProperty("visible") && data[item].visible == true))
               {
                  items.push(item);
               }
            }
         }
         return items.sort(function(param1:*, param2:*):*
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function get constructed() : *
      {
         return MissionLibrary._constructed == true;
      }
   }
}
