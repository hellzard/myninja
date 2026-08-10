package Storage
{
   public class ForgeData
   {
      
      private static var data:*;
      
      private static var _constructed:* = false;
      
      public function ForgeData()
      {
         super();
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(_constructed)
         {
            return;
         }
         ForgeData.data = {};
         for each(_loc2_ in param1)
         {
            ForgeData.data[_loc2_.item] = {
               "item_materials":_loc2_.requirements.materials,
               "item_mat_price":_loc2_.requirements.qty,
               "item_mat_end":_loc2_.end,
               "category":_loc2_.category
            };
         }
         for each(_loc3_ in param1)
         {
            if(ForgeData.data.hasOwnProperty(_loc3_.item))
            {
               ForgeData.data[_loc3_.item]["category"] = _loc3_.category;
            }
         }
         _constructed = true;
      }
      
      public static function getItemByCategory(param1:* = "wpn") : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = [];
         for(_loc3_ in data)
         {
            if(_loc3_.indexOf(param1 + "_") >= 0)
            {
               _loc4_ = _loc3_.split("_");
               if(!(_loc4_[2] != null && int(_loc4_[2]) != Character.character_gender && param1 != "pet"))
               {
                  _loc2_.push(_loc3_);
               }
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
            "item_mat_price":[],
            "item_mat_end":""
         };
      }
   }
}

