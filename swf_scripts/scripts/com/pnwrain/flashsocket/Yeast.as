package com.pnwrain.flashsocket
{
   public class Yeast
   {
      
      private const length:int = 64;
      
      private var alphabet:Array;
      
      private var map:Object;
      
      private var seed:int = 0;
      
      private var prev:String;
      
      public function Yeast()
      {
         super();
         this.alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_".split("");
         this.map = [];
         var _loc1_:int = 0;
         while(_loc1_ < this.length)
         {
            this.map[this.alphabet[_loc1_]] = _loc1_;
            _loc1_++;
         }
      }
      
      private function encode(param1:int) : String
      {
         var _loc2_:String = "";
         do
         {
            _loc2_ = this.alphabet[param1 % this.length] + _loc2_;
            param1 = Math.floor(param1 / this.length);
         }
         while(param1 > 0);
         return _loc2_;
      }
      
      public function next() : String
      {
         var _loc1_:String = this.encode(new Date().getTime());
         if(_loc1_ !== this.prev)
         {
            this.seed = 0;
            this.prev = _loc1_;
            return _loc1_;
         }
         return _loc1_ + "." + this.encode(this.seed++);
      }
   }
}

