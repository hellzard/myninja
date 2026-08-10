package Storage
{
   import flash.display.MovieClip;
   
   public class AccessoryBuffs extends MovieClip
   {
      
      private static var data:* = {};
      
      private static var cachedData:* = {};
      
      private static var _constructed:* = false;
      
      public var main:*;
      
      public function AccessoryBuffs(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         AccessoryBuffs.data = {};
         for each(_loc2_ in param1)
         {
            AccessoryBuffs.data[_loc2_.id] = AccessoryBuffs.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function getAccessoryBuff(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         return AccessoryBuffs.prefix();
      }
      
      private static function prefix(param1:* = null) : *
      {
         return {
            "id":(param1 != null && "id" in param1 ? param1.id : null),
            "effects":(param1 != null && "effects" in param1 ? param1.effects : null)
         };
      }
      
      public static function clearCached() : *
      {
         AccessoryBuffs.cachedData = {};
      }
      
      public static function getCopy(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         if(param1 in AccessoryBuffs.cachedData)
         {
            _loc2_ = AccessoryBuffs.cachedData[param1];
         }
         else
         {
            _loc2_ = JSON.parse(JSON.stringify(AccessoryBuffs.getAccessoryBuff(param1)));
            AccessoryBuffs.cachedData[param1] = _loc2_;
         }
         if(_loc2_.effects != null)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_["effects"].length)
            {
               if(!("duration" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].duration = 0;
               }
               if(!("calc_type" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].calc_type = "percent";
               }
               if(!("amount" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].amount = 0;
               }
               if(!("amount_prc" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].amount_prc = 0;
               }
               if(!("amount_hp" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].amount_hp = 0;
               }
               if(!("amount_cp" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].amount_cp = 0;
               }
               if(!("chance" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].chance = 100;
               }
               if(!("reduce_type" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].reduce_type = "MAX";
               }
               if(!("no_disperse" in _loc2_["effects"][_loc3_]))
               {
                  _loc2_["effects"][_loc3_].no_disperse = false;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc2_.effects = [];
         }
         return _loc2_;
      }
      
      public static function get constructed() : *
      {
         return AccessoryBuffs._constructed == true;
      }
   }
}

