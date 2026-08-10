package Storage
{
   public class SenjutsuLevelLearnRequirements
   {
      
      public function SenjutsuLevelLearnRequirements()
      {
         super();
      }
      
      public static function getSkillRequirements(param1:int = 0) : *
      {
         var _loc2_:Object = new Object();
         switch(param1)
         {
            case 1:
               _loc2_.ss = 5;
               break;
            case 2:
               _loc2_.ss = 10;
               break;
            case 3:
               _loc2_.ss = 25;
               break;
            case 4:
               _loc2_.ss = 50;
               break;
            case 5:
               _loc2_.ss = 100;
               break;
            case 6:
               _loc2_.ss = 200;
               break;
            case 7:
               _loc2_.ss = 300;
               break;
            case 8:
               _loc2_.ss = 450;
               break;
            case 9:
               _loc2_.ss = 600;
               break;
            case 10:
               _loc2_.ss = 800;
               break;
            default:
               return false;
         }
         return _loc2_;
      }
   }
}

