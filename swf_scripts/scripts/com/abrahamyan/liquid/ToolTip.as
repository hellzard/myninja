package com.abrahamyan.liquid
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import gs.TweenLite;
   import gs.easing.Linear;
   import id.ninjasage.Log;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6051")]
   public class ToolTip extends MovieClip
   {
      
      private static var instance:ToolTip;
      
      private static var allowInstance:Boolean;
      
      private static const DIRECTION_LEFT:String = "directionleft";
      
      private static const DIRECTION_RIGHT:String = "directionright";
      
      private static const DIRECTION_TOP:String = "directiontop";
      
      private static const DIRECTION_BOTTOM:String = "directionbottom";
      
      public var label_txt:TextField;
      
      public var bg_mc:MovieClip;
      
      public var _multiLine:Boolean = false;
      
      public var labelMargin:Number = 10;
      
      public var arrowMargin:Number = 0;
      
      public var showDelay:Number = 0;
      
      public var hideDelay:Number = 0;
      
      private var _label:String;
      
      private var _fixedWidth:Number = 1;
      
      private var _horDirection:String;
      
      private var _verticalDirection:String;
      
      private var _followMouse:Boolean;
      
      private var _timer:Timer;
      
      private var _xposition:Number;
      
      private var _yposition:Number;
      
      private var _stageWidth:Number;
      
      private var _stageHeight:Number;
      
      private var _labelColor:Number;
      
      private var is_pvp:Boolean = false;
      
      public function ToolTip()
      {
         super();
      }
      
      public static function getInstance(param1:Boolean = false) : ToolTip
      {
         if(instance == null)
         {
            allowInstance = true;
            instance = new ToolTip();
            allowInstance = false;
         }
         instance.is_pvp = param1;
         instance.init();
         return instance;
      }
      
      public function Tooltip() : *
      {
         if(!allowInstance)
         {
            throw new Error("use ToolTip.getInstance() instead of new keyword !");
         }
      }
      
      public function set multiLine(param1:Boolean) : void
      {
         this._multiLine = param1;
         if(this._multiLine)
         {
            this.label_txt.multiline = true;
            this.label_txt.wordWrap = true;
            this.label_txt.width = this._fixedWidth;
            this.label_txt.autoSize = TextFieldAutoSize.RIGHT;
         }
         else
         {
            this.label_txt.multiline = false;
            this.label_txt.wordWrap = false;
            this.label_txt.autoSize = TextFieldAutoSize.LEFT;
         }
      }
      
      public function set fixedWidth(param1:Number) : void
      {
         this._fixedWidth = Math.max(param1,50);
      }
      
      public function set labelColor(param1:Number) : void
      {
         this._labelColor = param1;
         this.label_txt.textColor = param1;
      }
      
      public function get labelColor() : Number
      {
         return this._labelColor;
      }
      
      private function init() : void
      {
         alpha = 0;
         visible = false;
         cacheAsBitmap = true;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.label_txt.x = this.labelMargin;
         this.label_txt.autoSize = TextFieldAutoSize.LEFT;
         this._horDirection = DIRECTION_RIGHT;
         this._verticalDirection = DIRECTION_TOP;
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded,false,0,true);
      }
      
      private function onAdded(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         this.onStageResize();
         stage.addEventListener(Event.RESIZE,this.onStageResize,false,0,true);
      }
      
      private function onStageResize(param1:Event = null) : void
      {
         this._stageWidth = stage.stageWidth;
         this._stageHeight = stage.stageHeight;
      }
      
      public function show(param1:String = "", param2:Number = 0, param3:Number = 0) : void
      {
         var _loc4_:String = null;
         this.alpha = 0;
         this.visible = false;
         this._label = param1;
         if(this.is_pvp)
         {
            this.label_txt.htmlText = this._label;
         }
         else
         {
            this.label_txt.text = this._label;
         }
         this.label_txt.htmlText = this._label;
         if(this._multiLine)
         {
            _loc4_ = this._label.replace(/<[^>]*>/g,"");
            if(_loc4_.length <= 15)
            {
               this.label_txt.wordWrap = false;
               this.label_txt.autoSize = TextFieldAutoSize.LEFT;
            }
            else
            {
               this.label_txt.wordWrap = true;
               this.label_txt.width = this._fixedWidth;
               this.label_txt.autoSize = TextFieldAutoSize.RIGHT;
            }
         }
         this._xposition = param2;
         this._yposition = param3;
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer = null;
         }
         this.updatePosition();
         TweenLite.killTweensOf(this);
         TweenLite.to(this,this.showDelay,{
            "autoAlpha":1,
            "ease":Linear.easeNone
         });
         if(this._followMouse)
         {
            this._timer = new Timer(20);
            this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
            this._timer.start();
         }
      }
      
      private function updatePosition() : void
      {
         var _loc1_:Number = this._followMouse ? Number(Number(Number(stage.mouseX + this._xposition))) : Number(Number(Number(this._xposition)));
         var _loc2_:Number = this._followMouse ? Number(Number(Number(stage.mouseY + this._yposition))) : Number(Number(Number(this._yposition)));
         this._horDirection = _loc1_ + this.label_txt.width > this._stageWidth ? DIRECTION_LEFT : DIRECTION_RIGHT;
         this._verticalDirection = _loc2_ - this.label_txt.height < 0 ? DIRECTION_BOTTOM : DIRECTION_TOP;
         this.x = Math.round(this._horDirection == DIRECTION_LEFT ? Number(Number(Number(_loc1_ - this.label_txt.width))) : Number(Number(Number(_loc1_))));
         this.y = Math.round(this._verticalDirection == DIRECTION_TOP ? Number(Number(Number(_loc2_ - this.label_txt.height))) : Number(Number(Number(_loc2_))));
      }
      
      public function hide() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer = null;
         }
         TweenLite.killTweensOf(this);
         TweenLite.to(this,this.hideDelay,{
            "autoAlpha":0,
            "ease":Linear.easeNone
         });
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         param1.updateAfterEvent();
         this.updatePosition();
      }
      
      public function set followMouse(param1:Boolean) : void
      {
         this._followMouse = param1;
      }
      
      public function get followMouse() : Boolean
      {
         return this._followMouse;
      }
      
      public function destroy() : void
      {
         Log.debug(this,"DESTROY");
         TweenLite.killTweensOf(this);
         if(stage)
         {
            stage.removeEventListener(Event.RESIZE,this.onStageResize);
         }
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer = null;
         }
      }
   }
}

