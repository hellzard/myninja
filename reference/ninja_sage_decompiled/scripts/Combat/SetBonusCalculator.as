package Combat
{
   import Storage.SetBuffs;
   
   public class SetBonusCalculator
   {
       
      
      public function SetBonusCalculator()
      {
         super();
      }
      
      public static function getSetBonusEffects(param1:String, param2:String, param3:String, param4:String, param5:String = null, param6:Boolean = true) : Array
      {
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:* = undefined;
         if(!SetBuffs.constructed)
         {
            return [];
         }
         var _loc7_:Object = {};
         if(param6)
         {
            tally(_loc7_,SetBuffs.getSetIdForItem("weapon",param1));
         }
         tally(_loc7_,SetBuffs.getSetIdForItem("back_item",param2));
         tally(_loc7_,SetBuffs.getSetIdForItem("cloth",param4));
         tally(_loc7_,SetBuffs.getSetIdForItem("hair",param5));
         if(param3 != null && param3 != "")
         {
            tally(_loc7_,SetBuffs.getSetIdForItem("accessory",param3));
         }
         var _loc8_:Array = [];
         for(_loc9_ in _loc7_)
         {
            if((_loc10_ = int(_loc7_[_loc9_])) >= 2)
            {
               _loc11_ = 2;
               while(_loc11_ <= _loc10_)
               {
                  _loc12_ = SetBuffs.getTierEffects(_loc9_,_loc11_);
                  for each(_loc13_ in _loc12_)
                  {
                     if(_loc13_ != null)
                     {
                        _loc8_.push(_loc13_);
                     }
                  }
                  _loc11_++;
               }
            }
         }
         return _loc8_;
      }
      
      private static function tally(param1:Object, param2:String) : void
      {
         if(param2 == null || param2 == "")
         {
            return;
         }
         param1[param2] = (!!param1.hasOwnProperty(param2) ? int(param1[param2]) : 0) + 1;
      }
   }
}
