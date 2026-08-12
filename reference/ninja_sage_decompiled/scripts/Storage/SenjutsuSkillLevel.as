package Storage
{
   import id.ninjasage.Util;
   
   public class SenjutsuSkillLevel
   {
      
      private static var data = {};
      
      private static var _constructed = false;
       
      
      public function SenjutsuSkillLevel()
      {
         super();
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         SenjutsuSkillLevel.data = {};
         for(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_];
            SenjutsuSkillLevel.data[_loc3_.id] = _loc3_;
         }
         _constructed = true;
         param1 = null;
      }
      
      public static function getSenjutsuSkillLevels(param1:String, param2:*) : *
      {
         var _loc3_:* = param1 + ":" + String(param2);
         if(!SenjutsuSkillLevel.data.hasOwnProperty(_loc3_))
         {
            return false;
         }
         var _loc4_:* = SenjutsuSkillLevel.data[_loc3_];
         SenjutsuSkillLevel.mutateEffects(_loc4_);
         return _loc4_;
      }
      
      public static function getCopy(param1:*, param2:*) : *
      {
         var _loc3_:* = SenjutsuSkillLevel.getSenjutsuSkillLevels(param1,param2);
         if(_loc3_)
         {
            return Util.copy(_loc3_);
         }
         return {};
      }
      
      private static function mutateEffects(param1:*) : *
      {
         if(!param1.hasOwnProperty("effects"))
         {
            param1.effects = [];
            return;
         }
         var _loc2_:* = 0;
         while(_loc2_ < param1.effects.length)
         {
            if(param1.effects[_loc2_].effect.indexOf("_faint") >= 0)
            {
               --param1.effects[_loc2_].duration;
            }
            if(!("duration" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].duration = 0;
            }
            if(!("calc_type" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].calc_type = "percent";
            }
            if(!("amount" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].amount = 0;
            }
            if(!("amount_prc" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].amount_prc = 0;
            }
            if(!("amount_hp" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].amount_hp = 0;
            }
            if(!("amount_cp" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].amount_cp = 0;
            }
            if(!("amount_protection" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].amount_protection = 0;
            }
            if(!("reduce_type" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].reduce_type = "MAX";
            }
            if(!("no_disperse" in param1.effects[_loc2_]))
            {
               param1.effects[_loc2_].no_disperse = false;
            }
            _loc2_++;
         }
      }
      
      public static function get constructed() : *
      {
         return SenjutsuSkillLevel._constructed == true;
      }
   }
}
