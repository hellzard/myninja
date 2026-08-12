package Storage
{
   public class SenjutsuInfo
   {
       
      
      public function SenjutsuInfo()
      {
         super();
      }
      
      public static function getSenjutsuInfo(param1:String) : *
      {
         var _loc2_:* = {};
         switch(param1)
         {
            case "other":
               _loc2_.name = "Other";
               _loc2_.description = "Other";
               _loc2_.premium = false;
               _loc2_.token = 1000000;
               _loc2_.gold = 0;
               break;
            case "toad":
               _loc2_.name = "Toad Sage Mode";
               _loc2_.description = "The sage mode come from the Toad Hill, learn it from the Old Huge Toad, toad senjutsu can make our body become stronger and damage become more powerful.";
               _loc2_.premium = false;
               _loc2_.token = 0;
               _loc2_.gold = 2000000;
               break;
            case "snake":
               _loc2_.name = "Snake Sage Mode";
               _loc2_.description = "The sage mode come from the Snake Cave, learn it from the Snake God, snake sage can make help for your skill using.";
               _loc2_.premium = false;
               _loc2_.token = 0;
               _loc2_.gold = 2000000;
               break;
            case "slug":
               _loc2_.name = "Slug Sage Mode";
               _loc2_.description = "Slug Sage Mode, imparted by the wise slugs of Shikkotsu Forest, is known for its unparalleled healing prowess and immense vitality.";
               _loc2_.premium = false;
               _loc2_.token = 3500;
               _loc2_.gold = 0;
               break;
            default:
               return false;
         }
         return _loc2_;
      }
   }
}
