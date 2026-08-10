package Storage
{
   import flash.display.MovieClip;
   
   public class EnemyInfo extends MovieClip
   {
      
      private static var data:* = {};
      
      private static var _constructed:* = false;
      
      public var main:*;
      
      public function EnemyInfo(param1:*)
      {
         super();
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         EnemyInfo.data = {};
         for each(_loc2_ in param1)
         {
            EnemyInfo.data[_loc2_.id] = EnemyInfo.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function getEnemyStats(param1:String) : *
      {
         var _loc2_:* = undefined;
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         return EnemyInfo.prefix();
      }
      
      private static function prefix(param1:* = null) : *
      {
         var _loc2_:* = {
            "enemy_id":(param1 != null && "id" in param1 ? param1.id : "null"),
            "enemy_name":(param1 != null && "name" in param1 ? param1.name : "null"),
            "enemy_level":(param1 != null && "level" in param1 ? param1.level : 1),
            "description":(param1 != null && "description" in param1 ? param1.description : ""),
            "enemy_hp":(param1 != null && "hp" in param1 ? param1.hp : 0),
            "enemy_cp":(param1 != null && "cp" in param1 ? param1.cp : 0),
            "enemy_dodge":(param1 != null && "dodge" in param1 ? param1.dodge : 0),
            "enemy_critical":(param1 != null && "critical" in param1 ? param1.critical : 0),
            "enemy_critical_damage":(param1 != null && "critical_damage" in param1 ? param1.critical_damage : 0),
            "enemy_purify":(param1 != null && "purify" in param1 ? param1.purify : 0),
            "enemy_accuracy":(param1 != null && "accuracy" in param1 ? param1.accuracy : 0),
            "enemy_agility":(param1 != null && "agility" in param1 ? param1.agility : 0),
            "enemy_reactive":(param1 != null && "reactive" in param1 ? param1.reactive : 0),
            "enemy_combustion":(param1 != null && "combustion" in param1 ? param1.combustion : 0),
            "size_x":(param1 != null && "size_x" in param1 ? param1.size_x : 0),
            "size_y":(param1 != null && "size_y" in param1 ? param1.size_y : 0),
            "anims":(param1 != null && "anims" in param1 ? param1.anims : null),
            "combo_skill":(param1 != null && "combo_skill" in param1 ? param1.combo_skill : false),
            "priority":(param1 != null && "priority" in param1 ? param1.priority : null),
            "enemy_ai":EnemyInfo.parseAIFlag(param1)
         };
         if(param1 != null)
         {
            if("na" in param1)
            {
               _loc2_["enemy_na"] = param1.na;
            }
            if("event" in param1)
            {
               _loc2_["enemy_event"] = param1.event;
            }
            if("calculation" in param1)
            {
               _loc2_["enemy_calculation"] = param1.calculation;
            }
            if("calculation_agility" in param1)
            {
               _loc2_["enemy_calculation_agility"] = param1.calculation_agility;
            }
            if("attacks" in param1)
            {
               _loc2_["attacks"] = param1.attacks;
            }
         }
         return _loc2_;
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
         var enemyInfo:* = undefined;
         var i:* = undefined;
         var enemyId:* = param1;
         var setEnemyStats:Function = function(param1:Number, param2:Number, param3:Number):void
         {
            var _loc4_:Number = Number(Character.character_lvl);
            enemyInfo.enemy_level = Number(_loc4_) + Number(Math.floor(Math.random() * 21) - 10);
            enemyInfo.enemy_hp = Number(param1 + (_loc4_ - 1) * (param2 + param3 * _loc4_));
            enemyInfo.enemy_cp = Number(param1 + (_loc4_ - 1) * (param2 + param3 * _loc4_));
            enemyInfo.enemy_agility = Number(10 + param2 + param3 * _loc4_ / 20);
         };
         enemyInfo = JSON.parse(JSON.stringify(EnemyInfo.getEnemyStats(enemyId)));
         var enemyDifficulty:Array = [0.7,1,1.2];
         if(!enemyInfo.hasOwnProperty("attacks"))
         {
            enemyInfo.attacks = [];
         }
         if(Boolean(enemyInfo.hasOwnProperty("enemy_calculation")) && Boolean(enemyInfo.hasOwnProperty("enemy_calculation_agility")))
         {
            enemyInfo.enemy_level = int(Character.character_lvl) + 5;
            enemyInfo.enemy_hp = int(Character.character_lvl) * enemyInfo.enemy_calculation;
            enemyInfo.enemy_cp = int(Character.character_lvl) * enemyInfo.enemy_calculation;
            enemyInfo.enemy_agility = 10 + int(Character.character_lvl) + enemyInfo.enemy_calculation_agility;
         }
         else if(enemyInfo.hasOwnProperty("enemy_calculation"))
         {
            enemyInfo.enemy_level = int(Character.character_lvl) + 5;
            enemyInfo.enemy_hp = int(Character.character_lvl) * enemyInfo.enemy_calculation;
            enemyInfo.enemy_cp = int(Character.character_lvl) * enemyInfo.enemy_calculation;
         }
         else if(Boolean(enemyInfo.hasOwnProperty("enemy_hp")) && int(enemyInfo.enemy_hp) == 0)
         {
            enemyInfo.enemy_hp = 30 + int(Character.mission_level) * 30;
            enemyInfo.enemy_cp = 30 + int(Character.mission_level) * 30;
            enemyInfo.enemy_agility = 11 + int(Character.mission_level);
            enemyInfo.skillDmg1 = 5 + int(Character.mission_level) * 2;
            enemyInfo.skillDmg2 = 5 + int(Character.mission_level) * 3;
            enemyInfo.enemy_level = Character.mission_level;
         }
         switch(enemyInfo.enemy_id)
         {
            case "ene_81":
               setEnemyStats(20000,40,3);
               break;
            case "ene_82":
               setEnemyStats(21000,50,3);
               break;
            case "ene_83":
               setEnemyStats(22000,60,3.5);
               break;
            case "ene_84":
               setEnemyStats(23000,60,3);
               break;
            case "ene_85":
               setEnemyStats(24000,50,3);
               break;
            case "ene_86":
               setEnemyStats(25000,60,4);
               break;
            case "ene_106":
               setEnemyStats(26000,70,4);
               break;
            case "ene_120":
               setEnemyStats(27000,75,4.5);
               break;
            case "ene_155":
               setEnemyStats(28000,80,5);
         }
         if(Character.is_hard_mode)
         {
            enemyInfo.enemy_level = Math.floor(int(Character.character_lvl) * 2);
            enemyInfo.enemy_hp = Math.floor(enemyInfo.enemy_hp * 2);
            enemyInfo.enemy_cp = Math.floor(enemyInfo.enemy_cp * 2);
            enemyInfo.enemy_dodge = Math.floor(enemyInfo.enemy_dodge * 2);
            enemyInfo.enemy_critical = Math.floor(enemyInfo.enemy_critical * 2);
            enemyInfo.enemy_accuracy = Math.floor(enemyInfo.enemy_accuracy * 2);
            enemyInfo.enemy_agility = Math.floor(enemyInfo.enemy_agility * 2);
            enemyInfo.enemy_reactive = Math.floor(enemyInfo.enemy_reactive * 2);
            i = 0;
            while(i < enemyInfo.attacks.length)
            {
               if(enemyInfo.attacks[i].dmg > 0)
               {
                  enemyInfo.attacks[i].dmg *= 2;
               }
               i++;
            }
         }
         if(Character.encyclopedia_battle.battle)
         {
            enemyInfo.enemy_level = Math.floor(int(Character.character_lvl) * Character.encyclopedia_battle.multiplier);
            enemyInfo.enemy_hp = Math.floor(enemyInfo.enemy_hp * Character.encyclopedia_battle.multiplier);
            enemyInfo.enemy_cp = Math.floor(enemyInfo.enemy_cp * Character.encyclopedia_battle.multiplier);
            enemyInfo.enemy_critical = Math.floor(enemyInfo.enemy_critical * Character.encyclopedia_battle.multiplier);
            enemyInfo.enemy_agility = Math.floor(enemyInfo.enemy_agility * Character.encyclopedia_battle.multiplier);
            enemyInfo.enemy_reactive = Math.floor(enemyInfo.enemy_reactive * Character.encyclopedia_battle.multiplier);
            i = 0;
            while(i < enemyInfo.attacks.length)
            {
               if(enemyInfo.attacks[i].dmg > 0)
               {
                  enemyInfo.attacks[i].dmg *= Character.encyclopedia_battle.multiplier;
               }
               i++;
            }
         }
         if(!enemyInfo.hasOwnProperty("enemy_max_hp"))
         {
            enemyInfo.enemy_max_hp = enemyInfo.enemy_hp;
         }
         if(!enemyInfo.hasOwnProperty("enemy_level"))
         {
            enemyInfo.enemy_level = 5;
         }
         if(!enemyInfo.hasOwnProperty("enemy_combustion"))
         {
            enemyInfo.enemy_combustion = 0;
         }
         if(!enemyInfo.hasOwnProperty("enemy_accuracy"))
         {
            enemyInfo.enemy_accuracy = 10;
         }
         if(!enemyInfo.hasOwnProperty("enemy_reactive"))
         {
            enemyInfo.enemy_reactive = 5;
         }
         if(!enemyInfo.hasOwnProperty("enemy_name"))
         {
            enemyInfo.enemy_id = "ene_00Error";
            enemyInfo.enemy_name = "";
            enemyInfo.enemy_hp = 999999;
            enemyInfo.enemy_max_hp = 999999;
            enemyInfo.enemy_cp = 999999;
            enemyInfo.enemy_dodge = 1000;
            enemyInfo.enemy_agility = 0;
            enemyInfo.description = "ERROR";
            enemyInfo.skillDmg1 = 10001;
            enemyInfo.skillDmg2 = 10002;
            enemyInfo.skillDmg3 = 10003;
            enemyInfo.skillDmg4 = 10004;
            enemyInfo.skillDmg5 = 10005;
            enemyInfo.size_x = 0.55;
            enemyInfo.size_y = 0.55;
         }
         return enemyInfo;
      }
      
      public static function getEncyIds() : *
      {
         var item:* = undefined;
         var items:* = [];
         for(item in data)
         {
            if(!(Boolean(data[item].hasOwnProperty("enemy_na")) && data[item].enemy_na == true))
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
         return EnemyInfo._constructed == true;
      }
   }
}

