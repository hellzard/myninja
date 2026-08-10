package com.gestouch.gestures
{
   import com.gestouch.core.GestureState;
   import com.gestouch.core.Touch;
   import flash.geom.Point;
   
   public class PanGesture extends AbstractContinuousGesture
   {
      
      public var slop:Number = Gesture.DEFAULT_SLOP;
      
      public var direction:uint = 0;
      
      private var _maxNumTouchesRequired:uint = 4294967295;
      
      private var _minNumTouchesRequired:uint = 1;
      
      protected var _offsetX:Number = 0;
      
      protected var _offsetY:Number = 0;
      
      public function PanGesture(param1:Object = null)
      {
         super(param1);
      }
      
      public function get maxNumTouchesRequired() : uint
      {
         return this._maxNumTouchesRequired;
      }
      
      public function set maxNumTouchesRequired(param1:uint) : void
      {
         if(this._maxNumTouchesRequired == param1)
         {
            return;
         }
         if(param1 < this.minNumTouchesRequired)
         {
            throw ArgumentError("maxNumTouchesRequired must be not less then minNumTouchesRequired");
         }
         this._maxNumTouchesRequired = param1;
      }
      
      public function get minNumTouchesRequired() : uint
      {
         return this._minNumTouchesRequired;
      }
      
      public function set minNumTouchesRequired(param1:uint) : void
      {
         if(this._minNumTouchesRequired == param1)
         {
            return;
         }
         if(param1 > this.maxNumTouchesRequired)
         {
            throw ArgumentError("minNumTouchesRequired must be not greater then maxNumTouchesRequired");
         }
         this._minNumTouchesRequired = param1;
      }
      
      public function get offsetX() : Number
      {
         return this._offsetX;
      }
      
      public function get offsetY() : Number
      {
         return this._offsetY;
      }
      
      override public function reflect() : Class
      {
         return PanGesture;
      }
      
      override protected function onTouchBegin(param1:Touch) : void
      {
         if(touchesCount > this.maxNumTouchesRequired)
         {
            failOrIgnoreTouch(param1);
            return;
         }
         if(touchesCount >= this.minNumTouchesRequired)
         {
            updateLocation();
         }
      }
      
      override protected function onTouchMove(param1:Touch) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         if(touchesCount < this.minNumTouchesRequired)
         {
            return;
         }
         if(state == GestureState.POSSIBLE)
         {
            _loc2_ = _location.x;
            _loc3_ = _location.y;
            updateLocation();
            _loc4_ = param1.locationOffset;
            if(this.direction == PanGestureDirection.VERTICAL)
            {
               _loc4_.x = 0;
            }
            else if(this.direction == PanGestureDirection.HORIZONTAL)
            {
               _loc4_.y = 0;
            }
            if(_loc4_.length > this.slop || this.slop != this.slop)
            {
               this._offsetX += _location.x - _loc2_;
               this._offsetY += _location.y - _loc3_;
               setState(GestureState.BEGAN);
            }
         }
         else if(state == GestureState.BEGAN || state == GestureState.CHANGED)
         {
            _loc2_ = _location.x;
            _loc3_ = _location.y;
            updateLocation();
            this._offsetX = _location.x - _loc2_;
            this._offsetY = _location.y - _loc3_;
            setState(GestureState.CHANGED);
         }
      }
      
      override protected function onTouchEnd(param1:Touch) : void
      {
         if(touchesCount < this.minNumTouchesRequired)
         {
            if(state == GestureState.POSSIBLE)
            {
               setState(GestureState.FAILED);
            }
            else
            {
               setState(GestureState.ENDED);
            }
         }
         else
         {
            updateLocation();
         }
      }
      
      override protected function resetNotificationProperties() : void
      {
         super.resetNotificationProperties();
         this._offsetX = this._offsetY = 0;
      }
   }
}

