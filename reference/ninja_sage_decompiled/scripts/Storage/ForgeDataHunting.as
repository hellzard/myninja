package Storage
{
   public class ForgeDataHunting
   {
      
      private static var data;
      
      private static var _constructed = false;
       
      
      public function ForgeDataHunting()
      {
         super();
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(_constructed)
         {
            return;
         }
         ForgeDataHunting.data = {};
         for each(_loc2_ in param1)
         {
            ForgeDataHunting.data[_loc2_.item] = {
               "item_materials":_loc2_.requirements.materials,
               "item_mat_price":_loc2_.requirements.qty
            };
         }
         _constructed = true;
      }
      
      public static function getItemByCategory(param1:* = "wpn") : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = [];
         for(_loc3_ in data)
         {
            if(_loc3_.indexOf(param1 + "_") >= 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getForgeItems(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         return {
            "item_materials":[],
            "item_mat_price":[]
         };
      }
   }
}
