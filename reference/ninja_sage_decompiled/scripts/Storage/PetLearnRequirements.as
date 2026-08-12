package Storage
{
   public class PetLearnRequirements
   {
       
      
      public function PetLearnRequirements()
      {
         super();
      }
      
      public static function getSkillRequirements(param1:int = 0) : *
      {
         var _loc2_:Object = new Object();
         switch(param1)
         {
            case 2:
               _loc2_.golds = 10000;
               _loc2_.tokens = 50;
               _loc2_.material_01 = 0;
               _loc2_.material_02 = 0;
               _loc2_.material_03 = 0;
               _loc2_.material_04 = 0;
               _loc2_.material_05 = 0;
               break;
            case 3:
               _loc2_.golds = 20000;
               _loc2_.tokens = 80;
               _loc2_.material_01 = 5;
               _loc2_.material_02 = 0;
               _loc2_.material_03 = 0;
               _loc2_.material_04 = 0;
               _loc2_.material_05 = 0;
               break;
            case 4:
               _loc2_.golds = 30000;
               _loc2_.tokens = 120;
               _loc2_.material_01 = 6;
               _loc2_.material_02 = 4;
               _loc2_.material_03 = 2;
               _loc2_.material_04 = 0;
               _loc2_.material_05 = 0;
               break;
            case 5:
               _loc2_.golds = 40000;
               _loc2_.tokens = 150;
               _loc2_.material_01 = 8;
               _loc2_.material_02 = 6;
               _loc2_.material_03 = 4;
               _loc2_.material_04 = 0;
               _loc2_.material_05 = 0;
               break;
            case 6:
               _loc2_.golds = 50000;
               _loc2_.tokens = 200;
               _loc2_.material_01 = 10;
               _loc2_.material_02 = 8;
               _loc2_.material_03 = 6;
               _loc2_.material_04 = 4;
               _loc2_.material_05 = 2;
               break;
            default:
               return false;
         }
         return _loc2_;
      }
   }
}
