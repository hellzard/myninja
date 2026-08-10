package Storage
{
   import flash.display.MovieClip;
   
   public class ItemDropSourceMapping extends MovieClip
   {
      
      private static var data:Object = {
         "academy":"Academy",
         "advanced_academy":"Advanced Academy",
         "shop":"Shop",
         "pvp_shop":"PvP Shop",
         "pvp_league_shop":"PvP League Shop",
         "clan_shop":"Clan Shop",
         "crew_shop":"Crew Shop",
         "pet_shop":"Pet Shop",
         "friendship":"Friendship Shop",
         "material_market":"Material Market",
         "hunting_market":"Hunting Market",
         "dragon_gacha":"Dragon Gacha",
         "dragon_hunt":"Dragon Hunt",
         "eudemon":"Eudemon",
         "scratch":"Scratch Card",
         "recruit":"Recruit",
         "monster_hunter":"Monster Hunter",
         "justice_badge":"Justice Badge",
         "clan_forge":"Clan Forge",
         "hunting_forge":"Hunting Forge",
         "tailed_beast":"Tailed Beast",
         "divinetree":"Divine Tree",
         "shangri-la":"Shangri-La",
         "clan":"Clan Tournament",
         "crew":"Crew Battle",
         "pvp":"PvP",
         "sw":"Shadow War",
         "valentine2025":"Valentine Event 2025",
         "anniv2025":"Anniversary Event 2025",
         "ramadhan2025":"Ramadhan Event 2025",
         "easter2025":"Easter Event 2025",
         "wmg2025":"World Master Game 2025",
         "summer2025":"Summer Event 2025",
         "independence2025":"Independence Event 2025",
         "yinyang2025":"Yin Yang 2025",
         "halloween2025":"Halloween Event 2025",
         "confrontingdeath2025":"Confronting Death 2025",
         "thanksgiving2025":"Thanksgiving Event 2025",
         "christmas2025":"Christmas Event 2025",
         "phantomkyunoki2026":"Phantom Kyunoki 2026",
         "valentine2026":"Valentine Event 2026",
         "anniv2026":"Anniversary Event 2026",
         "ramadhan2026":"Ramadhan Event 2026",
         "hanami2026":"Hanami Event 2026",
         "easter2026":"Easter Event 2026",
         "hanami2022":"Hanami Event 2022",
         "hanami2024":"Hanami Event 2024",
         "cny2023":"Chinese New Year Event 2023",
         "christmas2021":"Christmas Event 2021",
         "newyear2022":"New Year Event 2022",
         "valentine2022":"Valentine Event 2022",
         "ramadhan2022":"Ramadhan Event 2022",
         "easter2022":"Easter Egg Event 2022",
         "pirate2022":"Pirate Event 2022",
         "fighter2022":"Fighter Event 2022",
         "independence2022":"Independence Event 2022",
         "soccer2022":"Soccer Fever Event 2022",
         "summer2022":"Summer Event 2022",
         "kojimareturns2022":"Kojima Return Event 2022",
         "anniv2022":"Anniversary Event 2022",
         "afterlife2022":"Afterlife Event 2022",
         "thousandyears2022":"Thousand Years Event 2022",
         "turkeytengu2022":"Invasion of Turkey Tengu Event 2022",
         "halloween2022":"Halloween Event 2022",
         "christmas2022":"Christmas Event 2022",
         "newyear2023":"New Year Event 2023",
         "valentine2023":"Valentine Event 2023",
         "ramadhan2023":"Ramadhan Event 2023",
         "easter2023":"Easter Event 2023",
         "sakura2023":"Sakura Tournament Event 2023",
         "salus2023":"Salus Event 2023",
         "garuda2023":"Garuda Event 2023",
         "summerstorm2023":"Summer Storm Event 2023",
         "anniv2023":"Anniversary Event 2023",
         "halloween2023":"Halloween Event 2023",
         "thanksgiving2023":"Thanksgiving Event 2023",
         "christmas2023":"Christmas Event 2023",
         "cny2024":"Chinese New Year Event 2024",
         "valentine2024":"Valentine Event 2024",
         "ramadhan2024":"Ramadhan Event 2024",
         "easter2024":"Easter Event 2024",
         "ambush2024":"Ambush at Delivery Event 2024",
         "independence2024":"Independence Event 2024",
         "summer2024":"Summer Event 2024",
         "anniv2024":"Anniversary Event 2024",
         "settlethegrudge2024":"Settle the Grudge Event 2024",
         "halloween2024":"Halloween Event 2024",
         "thanksgiving2024":"Thanksgiving Event 2024",
         "christmas2024":"Christmas Event 2024",
         "cny2025":"Chinese New Year Event 2025",
         "ramadhankareem2025":"Ramadhan Kareem Event 2025",
         "mekkorvath":"Mekkorvath Package",
         "elementalars":"Elemental Ars Package",
         "taixioumountain":"Taixiou Mountain Package",
         "worldcup2026":"World Cup Event 2026",
         "chaosarchangel":"Chaos Archangel Package",
         "summer2026":"Summer Event 2026",
         "circus2026":"Shadow Circus Event 2026"
      };
      
      private static var SOURCE_COLOR:String = "#cc6633";
      
      public function ItemDropSourceMapping()
      {
         super();
      }
      
      public static function getDisplayName(param1:String) : String
      {
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         return param1;
      }
      
      public static function getColor() : String
      {
         return SOURCE_COLOR;
      }
      
      public static function formatSourceText(param1:Array) : String
      {
         if(!param1 || param1.length == 0)
         {
            return "";
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(getDisplayName(param1[_loc3_]));
            _loc3_++;
         }
         return "\n\n<font color=\"" + SOURCE_COLOR + "\">Obtained from: " + _loc2_.join(", ") + "</font>";
      }
      
      public static function getAllSources() : Object
      {
         return data;
      }
      
      public static function hasSource(param1:String) : Boolean
      {
         return data.hasOwnProperty(param1);
      }
   }
}

