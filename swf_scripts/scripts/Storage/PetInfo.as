package Storage
{
   import flash.display.MovieClip;
   
   public class PetInfo extends MovieClip
   {
      
      private static var data:* = {};
      
      private static var _constructed:* = false;
      
      public var main:*;
      
      public function PetInfo(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         PetInfo.data = {};
         for each(_loc2_ in param1)
         {
            PetInfo.data[_loc2_.id] = PetInfo.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function getPetStats(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            if(Boolean(data[param1].hasOwnProperty("pet_hp")) && int(data[param1].pet_hp) == 0)
            {
               data[param1].pet_hp = 60 + int(data[param1].pet_level) * 40;
               data[param1].pet_cp = 60 + int(data[param1].pet_level) * 40;
               data[param1].pet_agility = 9 + int(data[param1].pet_level);
            }
            if(!data[param1].hasOwnProperty("pet_combustion"))
            {
               data[param1].pet_combustion = 0;
            }
            if(!data[param1].hasOwnProperty("pet_accuracy"))
            {
               data[param1].pet_accuracy = 10;
            }
            if(!data[param1].hasOwnProperty("pet_name"))
            {
               data[param1].pet_id = "pet_00Error";
               data[param1].pet_name = "";
               data[param1].pet_hp = 999999;
               data[param1].pet_cp = 999999;
               data[param1].pet_dodge = 1000;
               data[param1].pet_agility = 10;
               data[param1].description = "ERROR";
               data[param1].size_x = 0.65;
               data[param1].size_y = 0.65;
            }
            return data[param1];
         }
         return PetInfo.prefix();
      }
      
      private static function prefix(param1:* = null) : *
      {
         return {
            "pet_id":(param1 != null && "id" in param1 ? param1.id : null),
            "pet_level":(param1 != null && "level" in param1 ? param1.level : null),
            "pet_name":(param1 != null && "name" in param1 ? param1.name : null),
            "pet_rank":(param1 != null && "rank" in param1 ? param1.rank : null),
            "pet_hp":(param1 != null && "hp" in param1 ? param1.hp : null),
            "pet_cp":(param1 != null && "cp" in param1 ? param1.cp : null),
            "pet_dodge":(param1 != null && "dodge" in param1 ? param1.dodge : null),
            "pet_critical":(param1 != null && "critical" in param1 ? param1.critical : null),
            "pet_purify":(param1 != null && "purify" in param1 ? param1.purify : null),
            "pet_accuracy":(param1 != null && "accuracy" in param1 ? param1.accuracy : null),
            "pet_agility":(param1 != null && "agility" in param1 ? param1.agility : null),
            "description":(param1 != null && "description" in param1 ? param1.description : null),
            "pet_emblem":(param1 != null && "emblem" in param1 ? param1.emblem : null),
            "pet_combine":(param1 != null && "combine" in param1 ? param1.combine : false),
            "pet_combine_gold":(param1 != null && "combine_gold" in param1 ? param1.combine_gold : null),
            "size_x":(param1 != null && "size_x" in param1 ? param1.size_x : null),
            "size_y":(param1 != null && "size_y" in param1 ? param1.size_y : null),
            "attacks":(param1 != null && "attacks" in param1 ? param1.attacks : null),
            "multi_hit":(param1 != null && "multi_hit" in param1 ? param1.multi_hit : null),
            "anims":(param1 != null && "anims" in param1 ? param1.anims : null),
            "item_source":(param1 != null && "source" in param1 ? param1.source : []),
            "pet_ai":PetInfo.parseAIFlag(param1)
         };
      }
      
      private static function parseAIFlag(param1:* = null) : Boolean
      {
         if(param1 == null || !("AI" in param1))
         {
            return true;
         }
         var _loc2_:* = param1.AI;
         if(_loc2_ is Boolean)
         {
            return _loc2_;
         }
         if(_loc2_ is String)
         {
            return String(_loc2_).toLowerCase() != "false";
         }
         return Boolean(_loc2_);
      }
      
      public static function getCopy(param1:*) : *
      {
         return JSON.parse(JSON.stringify(PetInfo.getPetStats(param1)));
      }
      
      public static function getEncyIds() : *
      {
         var item:* = undefined;
         var items:* = [];
         for(item in data)
         {
            if(!(Boolean(data[item].hasOwnProperty("pet_na")) && data[item].pet_na == true))
            {
               items.push(item);
            }
         }
         return items.sort(function(param1:*, param2:*):*
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function getCombinePet() : *
      {
         var item:* = undefined;
         var items:* = [];
         for(item in data)
         {
            if(!(Boolean(data[item].hasOwnProperty("pet_combine")) && data[item].pet_combine == false))
            {
               items.push(item);
            }
         }
         return items.sort(function(param1:*, param2:*):*
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function get constructed() : *
      {
         return PetInfo._constructed == true;
      }
   }
}

