package Storage
{
   public class TalentSkillDescriptions
   {
       
      
      public function TalentSkillDescriptions()
      {
         super();
      }
      
      public static function getTalentSkillDescriptions(param1:String) : *
      {
         return GameData.get("talent_description")[param1];
      }
   }
}
