package Storage
{
   import com.brokenfunction.json.decodeJson;
   import com.brokenfunction.json.encodeJson;
   
   public class SkillLibrary
   {
      
      private static var data = {};
      
      private static var _constructed = false;
       
      
      public var main;
      
      public function SkillLibrary(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         SkillLibrary.data = {};
         for each(_loc2_ in param1)
         {
            SkillLibrary.data[_loc2_.id] = SkillLibrary.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function getSkillInfo(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         return SkillLibrary.prefix();
      }
      
      public static function getCopy(param1:*) : *
      {
         return decodeJson(encodeJson(SkillLibrary.getSkillInfo(param1)));
      }
      
      private static function prefix(param1:* = null) : *
      {
         var _loc2_:* = {
            "skill_id":(param1 != null && "id" in param1 ? param1.id : "null"),
            "skill_type":(param1 != null && "type" in param1 ? param1.type : "0"),
            "skill_name":(param1 != null && "name" in param1 ? param1.name : "null"),
            "skill_level":(param1 != null && "level" in param1 ? param1.level : 1),
            "skill_description":(param1 != null && "description" in param1 ? param1.description : ""),
            "skill_damage":(param1 != null && "damage" in param1 ? param1.damage : 0),
            "skill_cp_cost":(param1 != null && "cp_cost" in param1 ? param1.cp_cost : 0),
            "skill_cooldown":(param1 != null && "cooldown" in param1 ? param1.cooldown : 0),
            "skill_target":(param1 != null && "target" in param1 ? param1.target : "Single"),
            "skill_premium":(param1 != null && "premium" in param1 ? param1.premium : false),
            "skill_buyable":(param1 != null && "buyable" in param1 ? param1.buyable : false),
            "skill_buyable_clan":(param1 != null && "buyable_clan" in param1 ? param1.buyable_clan : false),
            "skill_price_gold":(param1 != null && "price_gold" in param1 ? param1.price_gold : 0),
            "skill_price_tokens":(param1 != null && "price_tokens" in param1 ? param1.price_tokens : 0),
            "skill_hit_chance":(param1 != null && "hit_chance" in param1 ? param1.hit_chance : 0),
            "skill_category":(param1 != null && "category" in param1 ? param1.category : 0),
            "anims":(param1 != null && "anims" in param1 ? param1.anims : {}),
            "attack_hit_position":(param1 != null && "attack_hit_position" in param1 ? param1.attack_hit_position : ""),
            "skill_source":(param1 != null && "source" in param1 ? param1.source : [])
         };
         if(param1 != null)
         {
            if("na" in param1)
            {
               _loc2_["skill_na"] = param1.na;
            }
            if("item_price_pvp" in param1)
            {
               _loc2_["item_price_pvp"] = param1.item_price_pvp;
            }
            if("price_prestige" in param1)
            {
               _loc2_["skill_price_prestige"] = param1.price_prestige;
            }
            if("buyable_clan" in param1)
            {
               _loc2_["skill_buyable_clan"] = param1.buyable_clan;
            }
            if("attack_hit_position" in param1)
            {
               _loc2_["skill_attack_hit_position"] = param1.attack_hit_position;
            }
            if("multi_hit" in param1)
            {
               _loc2_["multi_hit"] = param1.multi_hit;
            }
            if("category" in param1)
            {
               _loc2_["category"] = param1.category;
            }
         }
         return _loc2_;
      }
      
      public static function getExtremeHitChance(param1:String) : int
      {
         var _loc2_:Object = getCopy(param1);
         return _loc2_ && "skill_hit_chance" in _loc2_ ? int(_loc2_.skill_hit_chance) : 0;
      }
      
      public static function getSkillIds(param1:*) : *
      {
         var item:* = undefined;
         var type:* = param1;
         var items:* = [];
         for(item in data)
         {
            if(data[item].skill_type == type)
            {
               items.push(item);
            }
         }
         return items.sort(function(param1:*, param2:*):*
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function getEncyIds(param1:*) : *
      {
         var item:* = undefined;
         var type:* = param1;
         var items:* = [];
         for(item in data)
         {
            if(data[item].skill_type == type)
            {
               if(!(data[item].hasOwnProperty("skill_na") && data[item].skill_na == true))
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
      
      public static function getSkillByCategory(param1:*) : *
      {
         var item:* = undefined;
         var type:* = param1;
         var items:* = [];
         for(item in data)
         {
            if(data[item].skill_category == type)
            {
               items.push(item);
            }
         }
         return items.sort(function(param1:*, param2:*):*
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function get(param1:*) : *
      {
         return decodeJson(encodeJson(SkillLibrary.getSkillInfo(param1)));
      }
      
      public static function get constructed() : *
      {
         return SkillLibrary._constructed == true;
      }
      
      public static function getTrueDamage(param1:String) : Boolean
      {
         var _loc2_:Array = ["skill_4004"];
         return _loc2_.indexOf(param1) >= 0 ? true : false;
      }
   }
}
