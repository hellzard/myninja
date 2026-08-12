package Storage
{
   public class AnimationLibrary
   {
      
      private static var data = {};
      
      private static var _constructed = false;
       
      
      public function AnimationLibrary()
      {
         super();
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         AnimationLibrary.data = {};
         for each(_loc2_ in param1)
         {
            AnimationLibrary.data[_loc2_.id] = AnimationLibrary.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function get constructed() : *
      {
         return AnimationLibrary._constructed == true;
      }
      
      public static function getAnimation(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         return AnimationLibrary.prefix();
      }
      
      private static function prefix(param1:* = null) : *
      {
         return {
            "id":(param1 != null && "id" in param1 ? param1.id : ""),
            "name":(param1 != null && "name" in param1 ? param1.name : ""),
            "price":(param1 != null && "price" in param1 ? param1.price : 0),
            "buyable":(param1 != null && "buyable" in param1 ? param1.buyable : false),
            "premium":(param1 != null && "premium" in param1 ? param1.premium : false),
            "loop":(param1 != null && "loop" in param1 ? param1.loop : false),
            "category":(param1 != null && "category" in param1 ? param1.category : ""),
            "label":(param1 != null && "label" in param1 ? param1.label : ""),
            "na":(param1 != null && "na" in param1 ? param1.na : false)
         };
      }
      
      public static function getCategory(param1:String) : Array
      {
         var item:* = undefined;
         var category:String = param1;
         var items:* = [];
         for(item in data)
         {
            if(data[item].hasOwnProperty("category") && data[item].category == category && data[item].hasOwnProperty("na") && !data[item].na)
            {
               items.push(data[item]);
            }
         }
         return items.sort(function(param1:*, param2:*):*
         {
            return int(param1.id.split("_")[1]) - int(param2.id.split("_")[1]);
         });
      }
   }
}
