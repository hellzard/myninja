package Storage
{
   import flash.display.MovieClip;
   
   public class ArenaBuffs extends MovieClip
   {
      
      private static var data = {};
      
      private static var cachedData = {};
      
      private static var _constructed = false;
       
      
      public var main;
      
      public function ArenaBuffs(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public static function constructData(param1:*) : *
      {
         var _loc2_:* = undefined;
         ArenaBuffs.data = {};
         for each(_loc2_ in param1)
         {
            ArenaBuffs.data[_loc2_.id] = ArenaBuffs.prefix(_loc2_);
         }
         _constructed = true;
         _loc2_ = null;
      }
      
      public static function getArenaBuff(param1:String) : *
      {
         if(data.hasOwnProperty(param1))
         {
            return data[param1];
         }
         return ArenaBuffs.prefix();
      }
      
      private static function prefix(param1:* = null) : *
      {
         return {
            "id":(param1 != null && "id" in param1 ? param1.id : null),
            "buff":(param1 != null && "buff" in param1 ? param1.buff : null),
            "debuff":(param1 != null && "debuff" in param1 ? param1.debuff : null)
         };
      }
      
      public static function clearCached() : *
      {
         ArenaBuffs.cachedData = {};
      }
      
      public static function getCopy(param1:String) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         if(param1 in ArenaBuffs.cachedData)
         {
            _loc2_ = ArenaBuffs.cachedData[param1];
         }
         else
         {
            _loc2_ = JSON.parse(JSON.stringify(ArenaBuffs.getArenaBuff(param1)));
            ArenaBuffs.cachedData[param1] = _loc2_;
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
         return ArenaBuffs._constructed == true;
      }
   }
}
