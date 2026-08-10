package Storage
{
   import id.ninjasage.Util;
   
   public class SkillBuffs
   {
      
      private static var data:Object = {};
      
      private static var _constructed:Boolean = false;
      
      public function SkillBuffs()
      {
         super();
      }
      
      public static function getCopy(param1:String) : Object
      {
         return Util.copy(SkillBuffs.getSkillBuff(param1));
      }
      
      public static function constructData(param1:Array) : void
      {
         var _loc2_:Object = null;
         SkillBuffs.data = {};
         for each(_loc2_ in param1)
         {
            SkillBuffs.data[_loc2_.skill_id] = SkillBuffs.prefix(_loc2_);
         }
         _constructed = true;
      }
      
      public static function getSkillBuff(param1:String) : Object
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(data.hasOwnProperty(param1))
         {
            _loc2_ = data[param1]["skill_effect"];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_];
               SkillBuffs.ensureDefaults(_loc4_,{
                  "duration":0,
                  "calc_type":"percent",
                  "amount":0,
                  "amount_prc":0,
                  "amount_hp":0,
                  "amount_cp":0,
                  "chance":100,
                  "reduce_type":"MAX",
                  "no_disperse":false
               });
               _loc3_++;
            }
            return data[param1];
         }
         return SkillBuffs.prefix();
      }
      
      private static function ensureDefaults(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            if(!param1.hasOwnProperty(_loc3_))
            {
               param1[_loc3_] = param2[_loc3_];
            }
         }
      }
      
      private static function prefix(param1:Object = null) : Object
      {
         return {
            "skill_id":(param1 != null && "skill_id" in param1 ? param1.skill_id : null),
            "skill_effect":(param1 != null && "skill_effect" in param1 ? param1.skill_effect : [])
         };
      }
      
      public static function get constructed() : Boolean
      {
         return _constructed;
      }
   }
}

