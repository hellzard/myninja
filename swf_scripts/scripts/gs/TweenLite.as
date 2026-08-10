package gs
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TweenLite
   {
      
      public static var overwriteManager:Object;
      
      protected static var _curTime:uint;
      
      private static var _classInitted:Boolean;
      
      private static var _listening:Boolean;
      
      public static var version:Number = 8.16;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var defaultEase:Function = TweenLite.easeOut;
      
      protected static var _all:Dictionary = new Dictionary();
      
      private static var _sprite:Sprite = new Sprite();
      
      private static var _timer:Timer = new Timer(2000);
      
      public var duration:Number;
      
      public var vars:Object;
      
      public var delay:Number;
      
      public var startTime:int;
      
      public var initTime:int;
      
      public var tweens:Array;
      
      public var target:Object;
      
      protected var _active:Boolean;
      
      protected var _subTweens:Array;
      
      protected var _hst:Boolean;
      
      protected var _hasUpdate:Boolean;
      
      protected var _isDisplayObject:Boolean;
      
      protected var _initted:Boolean;
      
      protected var _timeScale:Number;
      
      public function TweenLite(param1:Object, param2:Number, param3:Object)
      {
         var _loc6_:* = undefined;
         var _loc4_:* = undefined;
         super();
         if(param1 == null)
         {
            return;
         }
         if(!_classInitted)
         {
            _curTime = getTimer();
            _sprite.addEventListener(Event.ENTER_FRAME,executeAll);
            if(overwriteManager == null)
            {
               overwriteManager = {
                  "mode":1,
                  "enabled":false
               };
            }
            _classInitted = true;
         }
         this.vars = param3;
         this.duration = Number(Number(Number(Number(param2)))) || Number(Number(Number(Number(0.001))));
         this.delay = Number(Number(Number(Number(param3.delay)))) || Number(Number(Number(Number(0))));
         this._timeScale = Number(Number(Number(Number(param3.timeScale)))) || Number(Number(Number(Number(1))));
         this._active = param2 == 0 && this.delay == 0;
         this.target = param1;
         this._isDisplayObject = param1 is DisplayObject;
         if(!(this.vars.ease is Function))
         {
            this.vars.ease = defaultEase;
         }
         if(this.vars.easeParams != null)
         {
            this.vars.proxiedEase = this.vars.ease;
            this.vars.ease = this.easeProxy;
         }
         if(!isNaN(Number(this.vars.autoAlpha)))
         {
            this.vars.alpha = Number(this.vars.autoAlpha);
            this.vars.visible = this.vars.alpha > 0;
         }
         this.tweens = [];
         this._subTweens = [];
         this._hst = this._initted = false;
         this.initTime = _curTime;
         this.startTime = this.initTime + this.delay * 1000;
         var _loc5_:int = param3.overwrite == undefined || !overwriteManager.enabled && param3.overwrite > 1 ? int(int(int(int(overwriteManager.mode)))) : int(int(int(int(int(param3.overwrite)))));
         if(_all[param1] == undefined || param1 != null && _loc5_ == 1)
         {
            delete _all[param1];
            _all[param1] = new Dictionary(true);
         }
         else if(_loc5_ > 1 && this.delay == 0)
         {
            overwriteManager.manageOverwrites(this,_all[param1]);
         }
         _all[param1][this] = this;
         if(this.vars.runBackwards == true && this.vars.renderOnStart != true || this._active)
         {
            this.initTweenVals();
            if(this._active)
            {
               this.render(this.startTime + 1);
            }
            else
            {
               this.render(this.startTime);
            }
            _loc6_ = this.vars.visible;
            if(this.vars.isTV == true)
            {
               _loc6_ = this.vars.exposedProps.visible;
            }
            if(_loc6_ != null && this.vars.runBackwards == true && this._isDisplayObject)
            {
               this.target.visible = Boolean(_loc6_);
            }
         }
         if(!_listening && !this._active)
         {
            _timer.addEventListener("timer",killGarbage);
            _timer.start();
            _listening = true;
         }
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         return new TweenLite(param1,param2,param3);
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         param3.runBackwards = true;
         return new TweenLite(param1,param2,param3);
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenLite
      {
         return new TweenLite(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "overwrite":0
         });
      }
      
      public static function executeAll(param1:Event = null) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:uint = _curTime = getTimer();
         if(_listening)
         {
            _loc2_ = _all;
            for each(_loc3_ in _loc2_)
            {
               for(_loc4_ in _loc3_)
               {
                  if(_loc3_[_loc4_] != undefined && Boolean(_loc3_[_loc4_].active))
                  {
                     _loc3_[_loc4_].render(_loc5_);
                  }
               }
            }
         }
      }
      
      public static function removeTween(param1:TweenLite = null) : void
      {
         if(param1 != null && _all[param1.target] != undefined)
         {
            _all[param1.target][param1] = null;
            delete _all[param1.target][param1];
         }
      }
      
      public static function killTweensOf(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         if(param1 != null && _all[param1] != undefined)
         {
            if(param2)
            {
               _loc3_ = _all[param1];
               for(_loc4_ in _loc3_)
               {
                  _loc3_[_loc4_].complete(false);
               }
            }
            delete _all[param1];
         }
      }
      
      public static function killGarbage(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         for(_loc3_ in _all)
         {
            _loc2_ = false;
            for(_loc4_ in _all[_loc3_])
            {
               _loc2_ = true;
            }
            if(!_loc2_)
            {
               delete _all[_loc3_];
            }
            else
            {
               _loc6_++;
            }
         }
         if(_loc6_ == 0)
         {
            _timer.removeEventListener("timer",killGarbage);
            _timer.stop();
            _listening = false;
         }
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * (param1 = param1 / param4) * (param1 - 2) + param2;
      }
      
      public static function tintProxy(param1:Object) : void
      {
         var _loc2_:Number = Number(param1.target.progress);
         var _loc3_:Number = 1 - _loc2_;
         var _loc4_:Object = param1.info.color;
         var _loc5_:Object = param1.info.endColor;
         param1.info.target.transform.colorTransform = new ColorTransform(_loc4_.redMultiplier * _loc3_ + _loc5_.redMultiplier * _loc2_,_loc4_.greenMultiplier * _loc3_ + _loc5_.greenMultiplier * _loc2_,_loc4_.blueMultiplier * _loc3_ + _loc5_.blueMultiplier * _loc2_,_loc4_.alphaMultiplier * _loc3_ + _loc5_.alphaMultiplier * _loc2_,_loc4_.redOffset * _loc3_ + _loc5_.redOffset * _loc2_,_loc4_.greenOffset * _loc3_ + _loc5_.greenOffset * _loc2_,_loc4_.blueOffset * _loc3_ + _loc5_.blueOffset * _loc2_,_loc4_.alphaOffset * _loc3_ + _loc5_.alphaOffset * _loc2_);
      }
      
      public static function frameProxy(param1:Object) : void
      {
         param1.info.target.gotoAndStop(Math.round(param1.target.frame));
      }
      
      public static function volumeProxy(param1:Object) : void
      {
         param1.info.target.soundTransform = param1.target;
      }
      
      public function initTweenVals(param1:Boolean = false, param2:String = "") : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:Array = null;
         var _loc7_:ColorTransform = null;
         var _loc8_:ColorTransform = null;
         var _loc9_:Object = null;
         _loc3_ = this.vars;
         if(_loc3_.isTV == true)
         {
            _loc3_ = _loc3_.exposedProps;
         }
         if(!param1 && this.delay != 0 && Boolean(overwriteManager.enabled))
         {
            overwriteManager.manageOverwrites(this,_all[this.target]);
         }
         if(this.target is Array)
         {
            _loc6_ = this.vars.endArray || [];
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               if(this.target[_loc5_] != _loc6_[_loc5_] && this.target[_loc5_] != undefined)
               {
                  this.tweens[this.tweens.length] = {
                     "o":this.target,
                     "p":_loc5_.toString(),
                     "s":this.target[_loc5_],
                     "c":_loc6_[_loc5_] - this.target[_loc5_],
                     "name":_loc5_.toString()
                  };
               }
               _loc5_++;
            }
         }
         else
         {
            if((typeof _loc3_.tint != "undefined" || this.vars.removeTint == true) && this._isDisplayObject)
            {
               _loc7_ = this.target.transform.colorTransform;
               _loc8_ = new ColorTransform();
               if(_loc3_.alpha != undefined)
               {
                  _loc8_.alphaMultiplier = _loc3_.alpha;
                  delete _loc3_.alpha;
               }
               else
               {
                  _loc8_.alphaMultiplier = this.target.alpha;
               }
               if(this.vars.removeTint != true && (_loc3_.tint != null && _loc3_.tint != "" || _loc3_.tint == 0))
               {
                  _loc8_.color = _loc3_.tint;
               }
               this.addSubTween("tint",tintProxy,{"progress":0},{"progress":1},{
                  "target":this.target,
                  "color":_loc7_,
                  "endColor":_loc8_
               });
            }
            if(_loc3_.frame != null && this._isDisplayObject)
            {
               this.addSubTween("frame",frameProxy,{"frame":this.target.currentFrame},{"frame":_loc3_.frame},{"target":this.target});
            }
            if(!isNaN(this.vars.volume) && this.target.hasOwnProperty("soundTransform"))
            {
               this.addSubTween("volume",volumeProxy,this.target.soundTransform,{"volume":this.vars.volume},{"target":this.target});
            }
            for(_loc4_ in _loc3_)
            {
               if(!(_loc4_ == "ease" || _loc4_ == "delay" || _loc4_ == "overwrite" || _loc4_ == "onComplete" || _loc4_ == "onCompleteParams" || _loc4_ == "runBackwards" || _loc4_ == "visible" || _loc4_ == "autoOverwrite" || _loc4_ == "persist" || _loc4_ == "onUpdate" || _loc4_ == "onUpdateParams" || _loc4_ == "autoAlpha" || _loc4_ == "timeScale" && !(this.target is TweenLite) || _loc4_ == "onStart" || _loc4_ == "onStartParams" || _loc4_ == "renderOnStart" || _loc4_ == "proxiedEase" || _loc4_ == "easeParams" || param1 && param2.indexOf(" " + _loc4_ + " ") != -1))
               {
                  if(!(this._isDisplayObject && (_loc4_ == "tint" || _loc4_ == "removeTint" || _loc4_ == "frame")) && !(_loc4_ == "volume" && this.target.hasOwnProperty("soundTransform")))
                  {
                     if(typeof _loc3_[_loc4_] == "number")
                     {
                        this.tweens[this.tweens.length] = {
                           "o":this.target,
                           "p":_loc4_,
                           "s":this.target[_loc4_],
                           "c":_loc3_[_loc4_] - this.target[_loc4_],
                           "name":_loc4_
                        };
                     }
                     else
                     {
                        this.tweens[this.tweens.length] = {
                           "o":this.target,
                           "p":_loc4_,
                           "s":this.target[_loc4_],
                           "c":Number(_loc3_[_loc4_]),
                           "name":_loc4_
                        };
                     }
                  }
               }
            }
         }
         if(this.vars.runBackwards == true)
         {
            _loc5_ = int(this.tweens.length - 1);
            while(_loc5_ > -1)
            {
               _loc9_ = this.tweens[_loc5_];
               _loc9_.s += _loc9_.c;
               _loc9_.c *= -1;
               _loc5_--;
            }
         }
         if(_loc3_.visible == true && this._isDisplayObject)
         {
            this.target.visible = true;
         }
         if(this.vars.onUpdate != null)
         {
            this._hasUpdate = true;
         }
         this._initted = true;
      }
      
      protected function addSubTween(param1:String, param2:Function, param3:Object, param4:Object, param5:Object = null) : void
      {
         var _loc6_:* = null;
         var _loc7_:Object = {
            "name":param1,
            "proxy":param2,
            "target":param3,
            "info":param5
         };
         this._subTweens[this._subTweens.length] = _loc7_;
         for(_loc6_ in param4)
         {
            if(typeof param4[_loc6_] == "number")
            {
               this.tweens[this.tweens.length] = {
                  "o":param3,
                  "p":_loc6_,
                  "s":param3[_loc6_],
                  "c":param4[_loc6_] - param3[_loc6_],
                  "sub":_loc7_,
                  "name":param1
               };
            }
            else
            {
               this.tweens[this.tweens.length] = {
                  "o":param3,
                  "p":_loc6_,
                  "s":param3[_loc6_],
                  "c":Number(param4[_loc6_]),
                  "sub":_loc7_,
                  "name":param1
               };
            }
         }
         this._hst = true;
      }
      
      public function render(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:* = 0;
         _loc2_ = (param1 - this.startTime) / 1000;
         if(_loc2_ >= this.duration)
         {
            _loc2_ = this.duration;
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = Number(this.vars.ease(_loc2_,0,1,this.duration));
         }
         _loc5_ = int(this.tweens.length - 1);
         while(_loc5_ > -1)
         {
            _loc4_ = this.tweens[_loc5_];
            _loc4_.o[_loc4_.p] = _loc4_.s + _loc3_ * _loc4_.c;
            _loc5_--;
         }
         if(this._hst)
         {
            _loc5_ = int(this._subTweens.length - 1);
            while(_loc5_ > -1)
            {
               this._subTweens[_loc5_].proxy(this._subTweens[_loc5_]);
               _loc5_--;
            }
         }
         if(this._hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_loc2_ == this.duration)
         {
            this.complete(true);
         }
      }
      
      public function complete(param1:Boolean = false) : void
      {
         if(!param1)
         {
            if(!this._initted)
            {
               this.initTweenVals();
            }
            this.startTime = _curTime - this.duration * 1000 / this._timeScale;
            this.render(_curTime);
            return;
         }
         if(this.vars.visible != undefined && this._isDisplayObject)
         {
            if(!isNaN(this.vars.autoAlpha) && this.target.alpha == 0)
            {
               this.target.visible = false;
            }
            else if(this.vars.runBackwards != true)
            {
               this.target.visible = this.vars.visible;
            }
         }
         if(this.vars.persist != true)
         {
            removeTween(this);
         }
         if(this.vars.onComplete != null)
         {
            this.vars.onComplete.apply(null,this.vars.onCompleteParams);
         }
      }
      
      public function killVars(param1:Object) : void
      {
         if(overwriteManager.enabled)
         {
            overwriteManager.killVars(param1,this.vars,this.tweens,this._subTweens,[]);
         }
      }
      
      protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
      }
      
      public function get active() : Boolean
      {
         if(this._active)
         {
            return true;
         }
         if(_curTime >= this.startTime)
         {
            this._active = true;
            if(!this._initted)
            {
               this.initTweenVals();
            }
            else if(this.vars.visible != undefined && this._isDisplayObject)
            {
               this.target.visible = true;
            }
            if(this.vars.onStart != null)
            {
               this.vars.onStart.apply(null,this.vars.onStartParams);
            }
            if(this.duration == 0.001)
            {
               --this.startTime;
            }
            return true;
         }
         return false;
      }
   }
}

