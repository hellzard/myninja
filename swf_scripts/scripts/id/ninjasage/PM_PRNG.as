package id.ninjasage
{
   public class PM_PRNG
   {
      
      public var seed:uint;
      
      public function PM_PRNG(param1:* = null)
      {
         super();
         var _loc2_:int = new Date().getTime();
         var _loc3_:int = Math.random() * 0.025 * int.MAX_VALUE;
         this.seed = param1 == null ? uint(_loc2_ ^ _loc3_) : uint(param1);
      }
      
      public function nextInt() : uint
      {
         return this.gen();
      }
      
      public function nextDouble() : Number
      {
         return this.gen() / 2147483647;
      }
      
      public function nextIntRange(param1:Number, param2:Number) : uint
      {
         param1 -= 0.4999;
         param2 += 0.4999;
         return Math.round(param1 + (param2 - param1) * this.nextDouble());
      }
      
      public function nextDoubleRange(param1:Number, param2:Number) : Number
      {
         this.seed = this.seed * 16807 % 2147483647;
         var _loc3_:Number = this.seed / 2147483647;
         return param1 + (param2 - param1) * _loc3_;
      }
      
      private function gen() : uint
      {
         return this.seed = this.seed * 16807 % 2147483647;
      }
   }
}

