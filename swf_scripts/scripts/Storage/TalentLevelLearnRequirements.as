package Storage
{
   public class TalentLevelLearnRequirements
   {
      
      public function TalentLevelLearnRequirements()
      {
         super();
      }
      
      public static function getSkillRequirements(param1:int = 0) : *
      {
         var _loc2_:Object = new Object();
         switch(param1)
         {
            case 1:
               _loc2_.tp = 5;
               break;
            case 2:
               _loc2_.tp = 10;
               break;
            case 3:
               _loc2_.tp = 25;
               break;
            case 4:
               _loc2_.tp = 50;
               break;
            case 5:
               _loc2_.tp = 100;
               break;
            case 6:
               _loc2_.tp = 200;
               break;
            case 7:
               _loc2_.tp = 300;
               break;
            case 8:
               _loc2_.tp = 450;
               break;
            case 9:
               _loc2_.tp = 600;
               break;
            case 10:
               _loc2_.tp = 800;
               break;
            default:
               return false;
         }
         return _loc2_;
      }
   }
}

