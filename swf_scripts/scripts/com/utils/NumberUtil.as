package com.utils
{
   import id.ninjasage.PM_PRNG;
   
   public final class NumberUtil
   {
      
      public function NumberUtil()
      {
         super();
      }
      
      public static function randomNumber(param1:Number, param2:Number) : Number
      {
         return Math.floor((param1 + getRandom() * (param2 - param1)) * 10000) / 10000;
      }
      
      public static function getRandom() : Number
      {
         var _loc1_:PM_PRNG = new PM_PRNG();
         return _loc1_.nextDoubleRange(0,1);
      }
      
      public static function getRandomNSeed(param1:*, param2:*) : String
      {
         var _loc3_:* = "";
         var _loc4_:* = param1 % param2["loaderInfo"]["bytesLoaded"];
         var _loc5_:* = new PM_PRNG(_loc4_);
         var _loc6_:* = 0;
         while(_loc6_ < 4)
         {
            _loc3_ += String(_loc5_.nextInt());
            _loc6_++;
         }
         return _loc3_;
      }
      
      public static function getRandomInt() : int
      {
         return Math.max(1,Math.floor(getRandom() * 100) + 1);
      }
      
      public static function randomInt(param1:int, param2:int) : int
      {
         var _loc4_:int = 0;
         var _loc3_:* = new PM_PRNG();
         _loc4_ = int(_loc3_.nextIntRange(param1,param2));
         if(_loc4_ < param1)
         {
            _loc4_ = param1;
         }
         if(_loc4_ > param2)
         {
            _loc4_ = param2;
         }
         return _loc4_;
      }
      
      public static function getChance(param1:Number) : Boolean
      {
         if(param1 >= getRandomInt())
         {
            return true;
         }
         return false;
      }
   }
}

