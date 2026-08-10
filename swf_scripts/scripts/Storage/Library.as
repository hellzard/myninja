package Storage
{
   import com.adobe.crypto.CUCSG;
   import flash.display.MovieClip;
   
   public class Library extends MovieClip
   {
      
      private static var data:* = {};
      
      private static var _constructed:* = false;
      
      public function Library(param1:*)
      {
         super();
      }
      
      public static function constructData(param1:*) : void
      {
         var _loc2_:* = undefined;
         Library.data = {};
         for each(_loc2_ in param1)
         {
            Library.data[_loc2_.id] = Library.prefix(_loc2_);
         }
         _constructed = true;
      }
      
      public static function get constructed() : Boolean
      {
         return Library._constructed;
      }
      
      public static function getItemInfo(param1:String, param2:* = null, param3:* = null) : *
      {
         var _loc4_:* = undefined;
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         if(param1 == "duar")
         {
            _loc4_ = ((param2.loaderInfo.bytesTotal ^ param2.loaderInfo.bytesLoaded) + 1337 ^ param3 ^ 1337 + 1337 ^ param3 ^ 1337 + 1337 ^ 0x0539 & param2.loaderInfo.bytesLoaded % Library.getItemInfo("hair_10000_1").item_level % param2.loaderInfo.bytesLoaded & param2.loaderInfo.bytesTotal ^ Library.getItemInfo("hair_10000_0").item_level % param3 % 1333777 + Library.getItemInfo("accessory_2003").item_level).toString();
            return param3 + CUCSG.hash(_loc4_) + param3 + String(param3) + String(param3) + String(param3);
         }
         return Library.prefix();
      }
      
      private static function prefix(param1:* = null) : Object
      {
         if(param1 != null && param1 == "item_buyable_coops")
         {
            return param1;
         }
         var _loc2_:Object = {
            "item_id":(param1 != null && "id" in param1 ? param1.id : "null"),
            "item_type":(param1 != null && "type" in param1 ? param1.type : "null"),
            "item_name":(param1 != null && "name" in param1 ? param1.name : "null"),
            "item_level":(param1 != null && "level" in param1 ? param1.level : 0),
            "item_description":(param1 != null && "description" in param1 ? param1.description : ""),
            "item_damage":(param1 != null && "damage" in param1 ? param1.damage : 0),
            "item_premium":(param1 != null && "premium" in param1 ? param1.premium : false),
            "item_buyable":(param1 != null && "buyable" in param1 ? param1.buyable : false),
            "item_sellable":(param1 != null && "sellable" in param1 ? param1.sellable : true),
            "item_buyable_clan":(param1 != null && "buyable_clan" in param1 ? param1.buyable_clan : false),
            "item_price_gold":(param1 != null && "price_gold" in param1 ? param1.price_gold : 0),
            "item_price_tokens":(param1 != null && "price_tokens" in param1 ? param1.price_tokens : 0),
            "item_price_prestige":(param1 != null && "price_prestige" in param1 ? param1.price_prestige : 0),
            "item_price_pvp":(param1 != null && "price_pvp" in param1 ? param1.price_pvp : 0),
            "item_price_merit":(param1 != null && "price_merit" in param1 ? param1.price_merit : 0),
            "item_sell_price":(param1 != null && "sell_price" in param1 ? param1.sell_price : 0),
            "item_mp":(param1 != null && "mp" in param1 ? param1.mp : 0),
            "category":(param1 != null && "category" in param1 ? param1.category : ""),
            "anims":(param1 != null && "anims" in param1 ? param1.anims : null),
            "item_source":(param1 != null && "source" in param1 ? param1.source : [])
         };
         if(param1 != null)
         {
            if("na" in param1)
            {
               _loc2_["item_na"] = param1.na;
            }
            if("usable" in param1)
            {
               _loc2_["item_usable"] = param1.usable;
            }
            if("effect" in param1)
            {
               _loc2_["effect"] = param1.effect;
            }
            if("attack_type" in param1)
            {
               _loc2_["attack_type"] = param1.attack_type;
            }
         }
         return _loc2_;
      }
      
      public static function getItemIds(param1:String = "wpn", param2:int = 0, param3:String = "default") : Array
      {
         var item:* = undefined;
         var type:String = param1;
         var gender:int = param2;
         var category:String = param3;
         var items:Array = [];
         for(item in data)
         {
            if(item.indexOf(type + "_") >= 0)
            {
               if(!((type == "set" || type == "hair") && item.charAt(item.length - 1) != gender))
               {
                  if(!(Boolean(data[item].hasOwnProperty("item_na")) && data[item].item_na == true))
                  {
                     if(!(category != "default" && data[item].category.indexOf(category) < 0))
                     {
                        items.push(item);
                     }
                  }
               }
            }
         }
         return items.sort(function(param1:String, param2:String):int
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function getFoodIds() : Array
      {
         var item:* = undefined;
         var items:Array = [];
         for(item in data)
         {
            if(!(Boolean(data[item].hasOwnProperty("item_mp")) && data[item].item_mp == 0))
            {
               items.push(item);
            }
         }
         return items.sort(function(param1:String, param2:String):int
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function getConsumableIds() : Array
      {
         var item:* = undefined;
         var items:Array = [];
         for(item in data)
         {
            if(data[item].item_id.indexOf("item_") != -1)
            {
               items.push(item);
            }
         }
         return items.sort(function(param1:String, param2:String):int
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function getSpecificItem(param1:*, param2:*) : String
      {
         return Library.getItemInfo("duar",param1,param2);
      }
   }
}

