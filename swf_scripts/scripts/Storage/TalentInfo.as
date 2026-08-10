package Storage
{
   public class TalentInfo
   {
      
      public function TalentInfo()
      {
         super();
      }
      
      public static function getTalentInfos(param1:String) : *
      {
         return GameData.get("talent_info")[param1];
      }
   }
}

