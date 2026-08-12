package com.utils
{
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public final class CreateFilter
   {
       
      
      public function CreateFilter()
      {
         super();
      }
      
      public static function getSaturationFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0];
         _loc2_[0] = (1 - param1) * 0.3086 + param1;
         _loc2_[1] = (1 - param1) * 0.6094;
         _loc2_[2] = (1 - param1) * 0.082;
         _loc2_[5] = (1 - param1) * 0.3086;
         _loc2_[6] = (1 - param1) * 0.6094 + param1;
         _loc2_[7] = (1 - param1) * 0.082;
         _loc2_[10] = (1 - param1) * 0.3086;
         _loc2_[11] = (1 - param1) * 0.6094;
         _loc2_[12] = (1 - param1) * 0.082 + param1;
         _loc2_[18] = 1;
         return new ColorMatrixFilter(_loc2_);
      }
      
      public static function getBrightnessFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0];
         _loc2_[0] = param1;
         _loc2_[6] = param1;
         _loc2_[12] = param1;
         _loc2_[18] = 1;
         return new ColorMatrixFilter(_loc2_);
      }
      
      public static function getGlowFilter(param1:Object = null) : GlowFilter
      {
         var _loc2_:uint = 16711680;
         var _loc3_:Number = 1;
         var _loc4_:Number = 6;
         var _loc5_:Number = 6;
         var _loc6_:Number = 100;
         var _loc7_:int = BitmapFilterQuality.HIGH;
         if(param1 != null)
         {
            if(param1.color != null)
            {
               _loc2_ = param1.color;
            }
            if(param1.alpha != null)
            {
               _loc3_ = param1.alpha;
            }
            if(param1.blurX != null)
            {
               _loc4_ = param1.blurX;
            }
            if(param1.blurY != null)
            {
               _loc5_ = param1.blurY;
            }
            if(param1.strength != null)
            {
               _loc6_ = param1.strength;
            }
            if(param1.quality != null)
            {
               _loc7_ = param1.quality;
            }
         }
         return new GlowFilter(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
      }
   }
}
