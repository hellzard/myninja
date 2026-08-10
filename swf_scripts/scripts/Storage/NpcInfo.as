package Storage
{
   import flash.display.MovieClip;
   
   public class NpcInfo extends MovieClip
   {
      
      private static var data:* = {};
      
      private static var _constructed:* = false;
      
      public var main:*;
      
      public function NpcInfo(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         NpcInfo.data = {};
         for each(_loc2_ in param1)
         {
            NpcInfo.data[_loc2_.id] = NpcInfo.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function getNpcStats(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            if(!data[param1].hasOwnProperty("npc_max_hp"))
            {
               data[param1].npc_max_hp = data[param1].npc_hp;
            }
            if(!data[param1].hasOwnProperty("npc_combustion"))
            {
               data[param1].npc_combustion = 5;
            }
            if(!data[param1].hasOwnProperty("npc_accuracy"))
            {
               data[param1].npc_accuracy = 5;
            }
            if(!data[param1].hasOwnProperty("npc_name"))
            {
               data[param1].npc_id = "ene_00Error";
               data[param1].npc_name = "";
               data[param1].npc_hp = 999999;
               data[param1].npc_cp = 999999;
               data[param1].npc_dodge = 1000;
               data[param1].npc_agility = 10;
               data[param1].description = "ERROR";
               data[param1].skillDmg1 = 10001;
               data[param1].skillDmg2 = 10002;
               data[param1].skillDmg3 = 10003;
               data[param1].skillDmg4 = 10004;
               data[param1].skillDmg5 = 10005;
               data[param1].size_x = 0.65;
               data[param1].size_y = 0.65;
            }
            return data[param1];
         }
         return NpcInfo.prefix();
      }
      
      private static function prefix(param1:* = null) : *
      {
         return {
            "npc_id":(param1 != null && "id" in param1 ? param1.id : null),
            "npc_level":(param1 != null && "level" in param1 ? param1.level : null),
            "npc_name":(param1 != null && "name" in param1 ? param1.name : null),
            "npc_rank":(param1 != null && "rank" in param1 ? param1.rank : null),
            "npc_hp":(param1 != null && "hp" in param1 ? param1.hp : null),
            "npc_cp":(param1 != null && "cp" in param1 ? param1.cp : null),
            "npc_dodge":(param1 != null && "dodge" in param1 ? param1.dodge : null),
            "npc_critical":(param1 != null && "critical" in param1 ? param1.critical : null),
            "npc_purify":(param1 != null && "purify" in param1 ? param1.purify : null),
            "npc_accuracy":(param1 != null && "accuracy" in param1 ? param1.accuracy : null),
            "npc_agility":(param1 != null && "agility" in param1 ? param1.agility : null),
            "description":(param1 != null && "description" in param1 ? param1.description : null),
            "size_x":(param1 != null && "size_x" in param1 ? param1.size_x : null),
            "size_y":(param1 != null && "size_y" in param1 ? param1.size_y : null),
            "anims":(param1 != null && "anims" in param1 ? param1.anims : null),
            "attacks":(param1 != null && "attacks" in param1 ? param1.attacks : null),
            "na":(param1 != null && "na" in param1 ? param1.na : false),
            "npc_ai":NpcInfo.parseAIFlag(param1)
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
      
      public static function getEncyIds() : *
      {
         var item:* = undefined;
         var items:* = [];
         for(item in data)
         {
            if(!(Boolean(data[item].hasOwnProperty("npc_na")) && data[item].npc_na == true))
            {
               items.push(item);
            }
         }
         return items.sort(function(param1:*, param2:*):*
         {
            return int(param1.split("_")[1]) - int(param2.split("_")[1]);
         });
      }
      
      public static function getCopy(param1:*) : *
      {
         return JSON.parse(JSON.stringify(NpcInfo.getNpcStats(param1)));
      }
      
      public static function get constructed() : *
      {
         return NpcInfo._constructed == true;
      }
   }
}

