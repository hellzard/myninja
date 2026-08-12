package id.ninjasage
{
   import Storage.Character;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import gs.TweenLite;
   import gs.easing.Linear;
   
   public class GradientText
   {
      
      private static var _instances:Array = [];
       
      
      private var _gradientSprite:Sprite;
      
      private var _maskTextField:TextField;
      
      private var _textField;
      
      private var _originalAlpha:Number;
      
      private var _originalTextColor:uint;
      
      private var _filterTextField:TextField;
      
      private var _glowMaskTextField:TextField;
      
      public function GradientText()
      {
         super();
      }
      
      public static function apply(param1:*, param2:* = null) : void
      {
         remove(param1);
         var _loc3_:GradientText = new GradientText();
         _loc3_.init(param1,param2);
         _instances.push(_loc3_);
      }
      
      public static function remove(param1:*) : void
      {
         var _loc2_:int = _instances.length - 1;
         while(_loc2_ >= 0)
         {
            if(_instances[_loc2_]._textField == param1)
            {
               _instances[_loc2_].destroy();
               _instances.splice(_loc2_,1);
               return;
            }
            _loc2_--;
         }
      }
      
      public static function removeAll() : void
      {
         var _loc1_:int = _instances.length - 1;
         while(_loc1_ >= 0)
         {
            _instances[_loc1_].destroy();
            _loc1_--;
         }
         _instances = [];
      }
      
      private function init(param1:*, param2:* = null) : void
      {
         var _loc5_:Array = null;
         var _loc9_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Matrix = null;
         this._textField = param1;
         this._originalAlpha = param1.alpha;
         this._originalTextColor = param1.textColor;
         var _loc3_:Object = param1.getBounds(param1.parent);
         var _loc4_:Number = _loc3_.width;
         this._maskTextField = this.cloneTextField(param1);
         this._maskTextField.cacheAsBitmap = true;
         this._filterTextField = this.cloneTextField(param1);
         this._filterTextField.filters = param1.filters;
         this._filterTextField.cacheAsBitmap = true;
         this._glowMaskTextField = this.cloneTextField(param1);
         this._glowMaskTextField.cacheAsBitmap = true;
         var _loc6_:*;
         if((_loc6_ = param2 != null ? Character.rgb_data[param2] : null) is Array && _loc6_.length > 1)
         {
            _loc5_ = [];
            _loc14_ = 0;
            while(_loc14_ < _loc6_.length)
            {
               _loc5_.push(uint("0x" + String(_loc6_[_loc14_]).substr(1)));
               _loc14_++;
            }
            if(_loc5_[0] != _loc5_[_loc5_.length - 1])
            {
               _loc5_.push(_loc5_[0]);
            }
         }
         else
         {
            _loc5_ = [8308963,13144016,9141960,14919806,8308896,13936766,10518216,8308963];
         }
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         _loc9_ = 0;
         while(_loc9_ < _loc5_.length)
         {
            _loc7_.push(1);
            _loc8_.push(Math.round(_loc9_ * 255 / (_loc5_.length - 1)));
            _loc9_++;
         }
         var _loc10_:Number = 120;
         var _loc11_:Number = _loc4_ + _loc10_;
         this._gradientSprite = new Sprite();
         var _loc12_:Number = _loc3_.x;
         while(_loc12_ < _loc3_.x + _loc11_)
         {
            (_loc15_ = new Matrix()).createGradientBox(_loc10_,_loc3_.height,0,_loc12_,_loc3_.y);
            this._gradientSprite.graphics.beginGradientFill(GradientType.LINEAR,_loc5_,_loc7_,_loc8_,_loc15_);
            this._gradientSprite.graphics.drawRect(_loc12_,_loc3_.y,_loc10_,_loc3_.height);
            this._gradientSprite.graphics.endFill();
            _loc12_ += _loc10_;
         }
         this._gradientSprite.cacheAsBitmap = true;
         this._gradientSprite.mouseEnabled = false;
         this._gradientSprite.mouseChildren = false;
         var _loc13_:int = param1.parent.getChildIndex(param1);
         param1.parent.addChildAt(this._filterTextField,_loc13_ + 1);
         param1.parent.addChildAt(this._glowMaskTextField,_loc13_ + 2);
         param1.parent.addChildAt(this._maskTextField,_loc13_ + 3);
         param1.parent.addChildAt(this._gradientSprite,_loc13_ + 4);
         this._filterTextField.mask = this._glowMaskTextField;
         this._gradientSprite.mask = this._maskTextField;
         param1.alpha = 0;
         param1.textColor = 0;
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.startTween();
      }
      
      private function cloneTextField(param1:*) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.width = param1.width;
         _loc2_.height = param1.height;
         _loc2_.text = param1.text;
         _loc2_.setTextFormat(param1.getTextFormat());
         _loc2_.embedFonts = true;
         _loc2_.selectable = false;
         _loc2_.mouseEnabled = false;
         _loc2_.antiAliasType = param1.antiAliasType;
         _loc2_.gridFitType = param1.gridFitType;
         _loc2_.sharpness = param1.sharpness;
         _loc2_.thickness = param1.thickness;
         return _loc2_;
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         GradientText.remove(param1.target);
      }
      
      private function startTween() : void
      {
         if(this._gradientSprite == null)
         {
            return;
         }
         this._gradientSprite.x = 0;
         TweenLite.to(this._gradientSprite,3,{
            "x":-120,
            "ease":Linear.easeNone,
            "onComplete":this.startTween
         });
      }
      
      private function destroy() : void
      {
         if(this._textField != null)
         {
            this._textField.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
            this._textField.alpha = this._originalAlpha;
            this._textField.textColor = this._originalTextColor;
         }
         if(this._gradientSprite != null)
         {
            TweenLite.killTweensOf(this._gradientSprite);
            if(this._gradientSprite.parent != null)
            {
               this._gradientSprite.parent.removeChild(this._gradientSprite);
            }
         }
         if(this._maskTextField != null && this._maskTextField.parent != null)
         {
            this._maskTextField.parent.removeChild(this._maskTextField);
         }
         if(this._glowMaskTextField != null && this._glowMaskTextField.parent != null)
         {
            this._glowMaskTextField.parent.removeChild(this._glowMaskTextField);
         }
         if(this._filterTextField != null && this._filterTextField.parent != null)
         {
            this._filterTextField.parent.removeChild(this._filterTextField);
         }
         this._gradientSprite = null;
         this._maskTextField = null;
         this._glowMaskTextField = null;
         this._filterTextField = null;
         this._textField = null;
      }
      
      public function destroyExternal() : void
      {
         this.destroy();
         var _loc1_:int = _instances.indexOf(this);
         if(_loc1_ >= 0)
         {
            _instances.splice(_loc1_,1);
         }
      }
   }
}
