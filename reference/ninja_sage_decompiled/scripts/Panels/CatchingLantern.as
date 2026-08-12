package Panels
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.adobe.crypto.CUCSG;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import gs.TweenLite;
   import gs.easing.Linear;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.features.SummerMenu;
   
   public dynamic class CatchingLantern extends MovieClip
   {
      
      private static const STAGE_W:Number = 1920;
      
      private static const STAGE_H:Number = 1080;
      
      private static const CAT_LANTERN:int = 0;
      
      private static const CAT_GOLDEN:int = 1;
      
      private static const CAT_DEBUFF:int = 2;
      
      private static const CAT_BUFF:int = 3;
      
      private static const LBL_YOKAI_NORMAL:String = "normal";
      
      private static const LBL_YOKAI_VENOM:String = "venom";
      
      private static const LBL_YOKAI_INSTAKILL:String = "instakill";
      
      private static const LBL_BUFF_SLOW:String = "slow";
      
      private static const LBL_BUFF_DOUBLE:String = "double";
      
      private static const SCORE_LANTERN:int = 10;
      
      private static const SCORE_GOLDEN:int = 50;
      
      private static const SCORE_YOKAI_NORMAL:int = -20;
      
      private static const BASKET_SCORE_SOME:int = 200;
      
      private static const BASKET_SCORE_LOTS:int = 500;
      
      private static const VENOM_DURATION_MS:int = 10000;
      
      private static const VENOM_TICK_MS:int = 2000;
      
      private static const VENOM_MIN_LOSS:int = 20;
      
      private static const VENOM_MAX_LOSS:int = 30;
      
      private static const MAX_HEARTS:int = 5;
      
      private static const BUFF_DURATION_MS:int = 10000;
      
      private static const SLOWDOWN_FACTOR:Number = 0.75;
      
      private static const DOUBLE_POINT_FACTOR:int = 2;
      
      private static const BUFF_SPAWN_CHANCE:Number = 0.06;
      
      private static const INSTAKILL_FRAME_CHANCE:Number = 0.15;
      
      private static const BASKET_W:Number = 220;
      
      private static const BASKET_H:Number = 120;
      
      private static const OBJ_RADIUS:Number = 42;
      
      private static const SPAWN_EDGE_INSET:Number = 30;
      
      private static const BUFF_ICON_OFFSET_Y:Number = 140;
      
      private static const BUFF_ICON_SPACING:Number = 110;
      
      private static const COLOR_SCORE_PLUS:uint = 7077739;
      
      private static const COLOR_SCORE_MINUS:uint = 16735067;
      
      private static var FLOAT_GLOW:GlowFilter;
      
      private static var FLOAT_FORMAT_PLUS:TextFormat = new TextFormat("Franklin Gothic Demi",44,COLOR_SCORE_PLUS,true);
      
      private static var FLOAT_FORMAT_MINUS:TextFormat = new TextFormat("Franklin Gothic Demi",44,COLOR_SCORE_MINUS,true);
      
      private static const COLOR_SLOWDOWN_GLOW:uint = 11789823;
      
      private static const COLOR_DOUBLE_GLOW:uint = 15320831;
      
      private static const COLOR_VENOM:uint = 11619048;
       
      
      public var basketMC:MovieClip;
      
      public var comboMC:MovieClip;
      
      public var heartMC:MovieClip;
      
      public var resultMC:MovieClip;
      
      public var scoreMC:MovieClip;
      
      public var main;
      
      private var escapeKey:EscapeKeyManager;
      
      private var eventHandler:EventHandler;
      
      private var destroyed:Boolean = false;
      
      private var objectLayer:MovieClip;
      
      private var fxLayer:MovieClip;
      
      private var buffLayer:MovieClip;
      
      private var clickMask:MovieClip;
      
      private var score:int = 0;
      
      private var combo:int = 0;
      
      private var bestCombo:int = 0;
      
      private var totalLanternCaught:int = 0;
      
      private var hearts:int = 5;
      
      private var prevHearts:int = 5;
      
      private var playing:Boolean = false;
      
      private var ending:Boolean = false;
      
      private var activeObjects:Array;
      
      private var spawnedCount:int = 0;
      
      private var slowdownUntil:int = 0;
      
      private var doubleUntil:int = 0;
      
      private var venomUntil:int = 0;
      
      private var slowIcon:MovieClip;
      
      private var doubleIcon:MovieClip;
      
      private var venomIcon:MovieClip;
      
      private var venomTimer:Timer;
      
      private var hudTimer:Timer;
      
      private var spawnTween:TweenLite;
      
      private var dragging:Boolean = false;
      
      private var lastPointerX:Number = 0;
      
      private var summerMenu:SummerMenu;
      
      public function CatchingLantern(param1:*, param2:SummerMenu)
      {
         this.eventHandler = new EventHandler();
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.summerMenu = param2;
         this.main.handleVillageHUDVisibility(false);
         this.activeObjects = [];
         this.build();
         this.startGame();
      }
      
      private function build() : void
      {
         this.objectLayer = new MovieClip();
         this.objectLayer.mouseEnabled = false;
         this.objectLayer.mouseChildren = false;
         this.addChild(this.objectLayer);
         this.buffLayer = new MovieClip();
         this.buffLayer.mouseEnabled = false;
         this.buffLayer.mouseChildren = false;
         this.addChild(this.buffLayer);
         this.fxLayer = new MovieClip();
         this.fxLayer.mouseEnabled = false;
         this.fxLayer.mouseChildren = false;
         this.addChild(this.fxLayer);
         this.clickMask = new MovieClip();
         this.clickMask.graphics.beginFill(0,0);
         this.clickMask.graphics.drawRect(0,0,STAGE_W,STAGE_H);
         this.clickMask.graphics.endFill();
         this.addChild(this.clickMask);
         this.resultMC.visible = false;
         if(this.basketMC != null)
         {
            this.basketMC.mouseEnabled = false;
            this.basketMC.mouseChildren = false;
            this.basketMC.gotoAndStop(1);
         }
         this.eventHandler.addListener(this.clickMask,MouseEvent.MOUSE_DOWN,this.onDragStart);
      }
      
      private function onDragStart(param1:MouseEvent) : void
      {
         if(!this.playing)
         {
            return;
         }
         this.dragging = true;
         this.lastPointerX = this.clickMask.mouseX;
         this.clickMask.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
         this.clickMask.addEventListener(MouseEvent.MOUSE_UP,this.onDragEnd);
         if(this.stage != null)
         {
            this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDragEnd);
            this.stage.addEventListener(Event.MOUSE_LEAVE,this.onDragEnd);
         }
      }
      
      private function onDragMove(param1:MouseEvent) : void
      {
         if(!this.dragging)
         {
            return;
         }
         var _loc2_:Number = this.clickMask.mouseX;
         var _loc3_:Number = _loc2_ - this.lastPointerX;
         this.lastPointerX = _loc2_;
         this.moveBasketBy(_loc3_);
         param1.updateAfterEvent();
      }
      
      private function onDragEnd(param1:Event = null) : void
      {
         if(!this.dragging)
         {
            return;
         }
         this.dragging = false;
         this.clickMask.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
         this.clickMask.removeEventListener(MouseEvent.MOUSE_UP,this.onDragEnd);
         if(this.stage != null)
         {
            this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDragEnd);
            this.stage.removeEventListener(Event.MOUSE_LEAVE,this.onDragEnd);
         }
      }
      
      private function moveBasketBy(param1:Number) : void
      {
         if(this.basketMC == null)
         {
            return;
         }
         var _loc2_:Number = BASKET_W * 0.5;
         var _loc3_:Number = this.basketMC.x + param1;
         if(_loc3_ < _loc2_)
         {
            _loc3_ = _loc2_;
         }
         else if(_loc3_ > STAGE_W - _loc2_)
         {
            _loc3_ = STAGE_W - _loc2_;
         }
         this.basketMC.x = _loc3_;
      }
      
      private function get basketX() : Number
      {
         return this.basketMC != null ? Number(this.basketMC.x) : Number(STAGE_W * 0.5);
      }
      
      private function get basketY() : Number
      {
         return this.basketMC != null ? Number(this.basketMC.y) : Number(STAGE_H - 160);
      }
      
      private function startGame() : void
      {
         this.score = 0;
         this.combo = 0;
         this.bestCombo = 0;
         this.totalLanternCaught = 0;
         this.hearts = MAX_HEARTS;
         this.spawnedCount = 0;
         this.slowdownUntil = 0;
         this.doubleUntil = 0;
         this.stopVenom();
         this.removeAllBuffIcons();
         this.initHearts();
         this.ending = false;
         this.playing = true;
         this.refreshHud();
         this.updateBasketFrame();
         this.hudTimer = new Timer(250,0);
         this.eventHandler.addListener(this.hudTimer,TimerEvent.TIMER,this.onHudTick);
         this.hudTimer.start();
         this.scheduleNextSpawn();
      }
      
      private function onHudTick(param1:TimerEvent) : void
      {
         this.refreshBuffIcons();
      }
      
      private function currentSpawnDelay() : Number
      {
         var _loc1_:int = this.totalLanternCaught;
         if(_loc1_ < 10)
         {
            return 1.2;
         }
         if(_loc1_ < 25)
         {
            return 0.95;
         }
         if(_loc1_ < 45)
         {
            return 0.7;
         }
         if(_loc1_ < 100)
         {
            return 0.6;
         }
         return 0.5;
      }
      
      private function currentFallDuration() : Number
      {
         var _loc2_:Number = NaN;
         var _loc1_:int = this.totalLanternCaught;
         if(_loc1_ < 10)
         {
            _loc2_ = 3.4;
         }
         else if(_loc1_ < 25)
         {
            _loc2_ = 2.9;
         }
         else if(_loc1_ < 45)
         {
            _loc2_ = 2.4;
         }
         else if(_loc1_ < 70)
         {
            _loc2_ = 2.2;
         }
         else if(_loc1_ < 100)
         {
            _loc2_ = 2;
         }
         else
         {
            _loc2_ = 1.5;
         }
         if(this.isSlowdownActive())
         {
            _loc2_ /= SLOWDOWN_FACTOR;
         }
         return _loc2_;
      }
      
      private function currentYokaiChance() : Number
      {
         var _loc1_:int = this.totalLanternCaught;
         if(_loc1_ < 8)
         {
            return 0;
         }
         if(_loc1_ < 25)
         {
            return 0.18;
         }
         if(_loc1_ < 45)
         {
            return 0.28;
         }
         return 0.35;
      }
      
      private function scheduleNextSpawn() : void
      {
         if(!this.playing)
         {
            return;
         }
         this.spawnTween = TweenLite.delayedCall(this.currentSpawnDelay(),this.spawnObject);
      }
      
      private function spawnObject() : void
      {
         if(!this.playing)
         {
            return;
         }
         var _loc1_:int = this.pickCategory();
         var _loc2_:MovieClip = this.makeObject(_loc1_);
         var _loc3_:Number = BASKET_W * 0.5;
         var _loc4_:Number = _loc3_ + SPAWN_EDGE_INSET;
         var _loc5_:Number;
         if((_loc5_ = STAGE_W - _loc3_ - SPAWN_EDGE_INSET) < _loc4_)
         {
            _loc4_ = STAGE_W * 0.5;
            _loc5_ = STAGE_W * 0.5;
         }
         _loc2_.scaleX = 0.8;
         _loc2_.scaleY = 0.8;
         _loc2_.x = _loc4_ + Math.random() * (_loc5_ - _loc4_);
         _loc2_.y = -OBJ_RADIUS;
         _loc2_["cat"] = _loc1_;
         _loc2_["effect"] = _loc2_.currentLabel;
         _loc2_["caught"] = false;
         this.objectLayer.addChild(_loc2_);
         this.activeObjects.push(_loc2_);
         ++this.spawnedCount;
         var _loc6_:Number = STAGE_H + OBJ_RADIUS;
         TweenLite.to(_loc2_,this.currentFallDuration(),{
            "y":_loc6_,
            "ease":Linear.easeNone,
            "onUpdate":this.onObjectUpdate,
            "onUpdateParams":[_loc2_],
            "onComplete":this.onObjectMissed,
            "onCompleteParams":[_loc2_]
         });
         this.scheduleNextSpawn();
      }
      
      private function pickCategory() : int
      {
         if(Math.random() < this.currentYokaiChance())
         {
            return CAT_DEBUFF;
         }
         if(Math.random() < BUFF_SPAWN_CHANCE)
         {
            return CAT_BUFF;
         }
         if(Math.random() < 0.08)
         {
            return CAT_GOLDEN;
         }
         return CAT_LANTERN;
      }
      
      private function makeObject(param1:int) : MovieClip
      {
         var _loc2_:MovieClip = null;
         if(param1 == CAT_GOLDEN)
         {
            _loc2_ = new LanternGolden();
            this.gotoRandomFrame(_loc2_);
         }
         else if(param1 == CAT_BUFF)
         {
            _loc2_ = new LanternBuffs();
            this.gotoRandomFrame(_loc2_);
         }
         else if(param1 == CAT_DEBUFF)
         {
            _loc2_ = new LanternYokai();
            this.gotoDebuffFrame(_loc2_);
         }
         else
         {
            _loc2_ = new Lantern();
            this.gotoRandomFrame(_loc2_);
         }
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         return _loc2_;
      }
      
      private function gotoRandomFrame(param1:MovieClip) : void
      {
         var _loc2_:int = param1.totalFrames;
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         var _loc3_:int = 1 + Math.floor(Math.random() * _loc2_);
         if(_loc3_ < 1)
         {
            _loc3_ = 1;
         }
         else if(_loc3_ > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         param1.gotoAndStop(_loc3_);
      }
      
      private function gotoDebuffFrame(param1:MovieClip) : void
      {
         var _loc2_:String = null;
         if(Math.random() < INSTAKILL_FRAME_CHANCE)
         {
            _loc2_ = LBL_YOKAI_INSTAKILL;
         }
         else
         {
            _loc2_ = Math.random() < 0.5 ? LBL_YOKAI_NORMAL : LBL_YOKAI_VENOM;
         }
         if(this.hasFrameLabel(param1,_loc2_))
         {
            param1.gotoAndStop(_loc2_);
         }
         else
         {
            this.gotoRandomFrame(param1);
         }
      }
      
      private function hasFrameLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:Array = param1.currentLabels;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].name == param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function onObjectUpdate(param1:MovieClip) : void
      {
         if(!this.playing || this.ending || param1 == null || param1["caught"])
         {
            return;
         }
         var _loc2_:Number = this.basketY;
         if(param1.y < _loc2_ - OBJ_RADIUS)
         {
            return;
         }
         if(param1.y > _loc2_ + BASKET_H)
         {
            return;
         }
         var _loc3_:Number = BASKET_W * 0.5;
         var _loc4_:Number = this.basketX;
         if(param1.x > _loc4_ - _loc3_ && param1.x < _loc4_ + _loc3_)
         {
            this.catchObject(param1);
         }
      }
      
      private function onObjectMissed(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = param1["cat"];
         var _loc3_:Number = param1.x;
         this.removeObject(param1);
         if(this.playing && (_loc2_ == CAT_LANTERN || _loc2_ == CAT_GOLDEN))
         {
            this.combo = 0;
            this.spawnMissEffect(_loc3_,this.basketY);
            this.loseHeart();
            this.refreshHud();
         }
      }
      
      private function spawnMissEffect(param1:Number, param2:Number) : void
      {
         if(this.fxLayer == null)
         {
            return;
         }
         var _loc3_:MovieClip = new LanternMiss();
         _loc3_.mouseEnabled = false;
         _loc3_.mouseChildren = false;
         _loc3_.x = param1;
         _loc3_.y = param2;
         this.fxLayer.addChild(_loc3_);
         TweenLite.to(_loc3_,0.8,{
            "y":_loc3_.y - 90,
            "alpha":0,
            "ease":Linear.easeNone,
            "onComplete":this.removeMissEffect,
            "onCompleteParams":[_loc3_]
         });
      }
      
      private function removeMissEffect(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         TweenLite.killTweensOf(param1);
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function catchObject(param1:MovieClip) : void
      {
         param1["caught"] = true;
         TweenLite.killTweensOf(param1);
         var _loc2_:int = param1["cat"];
         if(_loc2_ == CAT_BUFF)
         {
            this.applyBuff(param1);
            return;
         }
         if(_loc2_ == CAT_DEBUFF)
         {
            this.applyDebuff(param1);
            return;
         }
         ++this.combo;
         if(this.combo > this.bestCombo)
         {
            this.bestCombo = this.combo;
         }
         ++this.totalLanternCaught;
         var _loc3_:int = _loc2_ == CAT_GOLDEN ? int(SCORE_GOLDEN) : int(SCORE_LANTERN);
         if(this.isDoubleActive())
         {
            _loc3_ *= DOUBLE_POINT_FACTOR;
         }
         this.addScore(_loc3_);
         this.popObject(param1,true);
         this.spawnFloatingScore(param1.x,param1.y,_loc3_);
         this.refreshHud();
      }
      
      private function applyBuff(param1:MovieClip) : void
      {
         var _loc2_:String = param1["effect"];
         if(_loc2_ == LBL_BUFF_DOUBLE)
         {
            this.activateDoublePoint();
            this.spawnFloatingText(param1.x,param1.y,"x2 POINT!",COLOR_DOUBLE_GLOW);
         }
         else
         {
            this.activateSlowdown();
            this.spawnFloatingText(param1.x,param1.y,"SLOW!",COLOR_SLOWDOWN_GLOW);
         }
         this.popObject(param1,true);
         this.refreshBuffIcons();
      }
      
      private function applyDebuff(param1:MovieClip) : void
      {
         var _loc2_:String = param1["effect"];
         this.combo = 0;
         if(_loc2_ == LBL_YOKAI_INSTAKILL)
         {
            this.ending = true;
            this.popObject(param1,false);
            this.spawnFloatingText(param1.x,param1.y,"GAME OVER!",COLOR_SCORE_MINUS);
            this.breakAllHearts();
            this.refreshHud();
            this.stopVenom();
            this.refreshBuffIcons();
            if(this.spawnTween != null)
            {
               TweenLite.killTweensOf(this.spawnObject);
               this.spawnTween = null;
            }
            TweenLite.delayedCall(0.9,this.endGame);
            return;
         }
         if(_loc2_ == LBL_YOKAI_VENOM)
         {
            this.popObject(param1,false);
            this.spawnFloatingText(param1.x,param1.y,"VENOM!",COLOR_VENOM);
            this.startVenom();
            this.refreshBuffIcons();
            this.refreshHud();
            return;
         }
         this.popObject(param1,false);
         this.addScore(SCORE_YOKAI_NORMAL);
         this.spawnFloatingScore(param1.x,param1.y,SCORE_YOKAI_NORMAL);
         this.refreshHud();
      }
      
      private function loseHeart() : void
      {
         if(!this.playing)
         {
            return;
         }
         --this.hearts;
         if(this.hearts < 0)
         {
            this.hearts = 0;
         }
         this.refreshHearts();
         if(this.hearts <= 0)
         {
            this.endGame();
         }
      }
      
      private function breakAllHearts() : void
      {
         this.hearts = 0;
         this.refreshHearts();
      }
      
      private function addScore(param1:int) : void
      {
         this.score += param1;
         if(this.score < 0)
         {
            this.score = 0;
         }
      }
      
      private function isSlowdownActive() : Boolean
      {
         return getTimer() < this.slowdownUntil;
      }
      
      private function isDoubleActive() : Boolean
      {
         return getTimer() < this.doubleUntil;
      }
      
      private function isVenomActive() : Boolean
      {
         return getTimer() < this.venomUntil;
      }
      
      private function activateSlowdown() : void
      {
         this.slowdownUntil = getTimer() + BUFF_DURATION_MS;
      }
      
      private function activateDoublePoint() : void
      {
         this.doubleUntil = getTimer() + BUFF_DURATION_MS;
      }
      
      private function startVenom() : void
      {
         this.venomUntil = getTimer() + VENOM_DURATION_MS;
         if(this.venomTimer == null)
         {
            this.venomTimer = new Timer(VENOM_TICK_MS,0);
            this.eventHandler.addListener(this.venomTimer,TimerEvent.TIMER,this.onVenomTick);
         }
         if(!this.venomTimer.running)
         {
            this.venomTimer.start();
         }
      }
      
      private function onVenomTick(param1:TimerEvent) : void
      {
         if(!this.playing || !this.isVenomActive())
         {
            this.stopVenom();
            this.refreshBuffIcons();
            return;
         }
         var _loc2_:int = VENOM_MIN_LOSS + Math.floor(Math.random() * (VENOM_MAX_LOSS - VENOM_MIN_LOSS + 1));
         this.addScore(-_loc2_);
         this.spawnVenomLoss(_loc2_);
         this.refreshHud();
      }
      
      private function spawnVenomLoss(param1:int) : void
      {
         var _loc2_:Number = (this.scoreMC != null ? this.scoreMC.x : 100) + 200;
         var _loc3_:Number = (this.scoreMC != null ? this.scoreMC.y : 60) + 140;
         this.spawnFloatingText(_loc2_,_loc3_,"-" + param1,COLOR_VENOM);
      }
      
      private function stopVenom() : void
      {
         this.venomUntil = 0;
         if(this.venomTimer != null)
         {
            this.eventHandler.removeListener(this.venomTimer,TimerEvent.TIMER,this.onVenomTick);
            this.venomTimer.stop();
            this.venomTimer = null;
         }
      }
      
      private function refreshHud() : void
      {
         if(this.scoreMC != null && this.scoreMC.txt_score != null)
         {
            this.scoreMC.txt_score.text = "" + this.score;
         }
         if(this.comboMC != null && this.comboMC.txt_score != null)
         {
            this.comboMC.txt_score.text = "" + this.combo;
         }
         this.refreshHearts();
         this.updateBasketFrame();
      }
      
      private function initHearts() : void
      {
         var _loc2_:Object = null;
         this.prevHearts = MAX_HEARTS;
         if(this.heartMC == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < MAX_HEARTS)
         {
            _loc2_ = this.heartMC["heart_" + _loc1_];
            if(_loc2_ != null)
            {
               _loc2_.visible = true;
               (_loc2_ as MovieClip).gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      private function refreshHearts() : void
      {
         var _loc2_:MovieClip = null;
         if(this.heartMC == null)
         {
            this.prevHearts = this.hearts;
            return;
         }
         var _loc1_:int = this.hearts;
         while(_loc1_ < this.prevHearts)
         {
            if(!(_loc1_ < 0 || _loc1_ >= MAX_HEARTS))
            {
               _loc2_ = this.heartMC["heart_" + _loc1_] as MovieClip;
               if(_loc2_ != null)
               {
                  this.playHeartBreak(_loc2_);
               }
            }
            _loc1_++;
         }
         this.prevHearts = this.hearts;
      }
      
      private function playHeartBreak(param1:MovieClip) : void
      {
         var last:int = 0;
         var h:MovieClip = param1;
         last = h.totalFrames;
         if(last <= 1)
         {
            h.visible = false;
            return;
         }
         h.addFrameScript(last - 1,function():void
         {
            h.stop();
            h.visible = false;
            h.addFrameScript(last - 1,null);
         });
         h.gotoAndPlay(1);
      }
      
      private function updateBasketFrame() : void
      {
         if(this.basketMC == null)
         {
            return;
         }
         var _loc1_:int = 1;
         if(this.score >= BASKET_SCORE_LOTS)
         {
            _loc1_ = 3;
         }
         else if(this.score >= BASKET_SCORE_SOME)
         {
            _loc1_ = 2;
         }
         if(this.basketMC.currentFrame != _loc1_)
         {
            this.basketMC.gotoAndStop(_loc1_);
         }
      }
      
      private function buffRowX() : Number
      {
         return this.heartMC != null ? Number(this.heartMC.x) : Number(40);
      }
      
      private function buffRowY() : Number
      {
         return (this.heartMC != null ? this.heartMC.y : 40) + BUFF_ICON_OFFSET_Y;
      }
      
      private function refreshBuffIcons() : void
      {
         var _loc1_:int = getTimer();
         if(this.isSlowdownActive())
         {
            if(this.slowIcon == null)
            {
               this.slowIcon = this.addBuffIcon(new LanternSpeedDownBuff());
            }
            this.setIconTimer(this.slowIcon,this.slowdownUntil - _loc1_);
         }
         else if(this.slowIcon != null)
         {
            this.removeBuffIcon(this.slowIcon);
            this.slowIcon = null;
         }
         if(this.isDoubleActive())
         {
            if(this.doubleIcon == null)
            {
               this.doubleIcon = this.addBuffIcon(new LanternDoubleBuff());
            }
            this.setIconTimer(this.doubleIcon,this.doubleUntil - _loc1_);
         }
         else if(this.doubleIcon != null)
         {
            this.removeBuffIcon(this.doubleIcon);
            this.doubleIcon = null;
         }
         if(this.isVenomActive())
         {
            if(this.venomIcon == null)
            {
               this.venomIcon = this.addBuffIcon(new LanternVenomDebuff());
            }
            this.setIconTimer(this.venomIcon,this.venomUntil - _loc1_);
         }
         else if(this.venomIcon != null)
         {
            this.removeBuffIcon(this.venomIcon);
            this.venomIcon = null;
         }
         this.restackBuffIcons();
      }
      
      private function addBuffIcon(param1:MovieClip) : MovieClip
      {
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
         param1.y = this.buffRowY();
         param1.scaleX = 0.7;
         param1.scaleY = 0.7;
         this.buffLayer.addChild(param1);
         return param1;
      }
      
      private function removeBuffIcon(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function setIconTimer(param1:MovieClip, param2:int) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:int = Math.ceil(param2 / 1000);
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(param1.txt != null)
         {
            param1.txt.text = _loc3_ + "s";
         }
      }
      
      private function restackBuffIcons() : void
      {
         var _loc5_:MovieClip = null;
         var _loc1_:Number = this.buffRowX();
         var _loc2_:int = 0;
         var _loc3_:Array = [this.slowIcon,this.doubleIcon,this.venomIcon];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc5_ = _loc3_[_loc4_] as MovieClip) != null && _loc5_.parent != null)
            {
               _loc5_.x = _loc1_ + _loc2_ * BUFF_ICON_SPACING;
               _loc2_++;
            }
            _loc4_++;
         }
      }
      
      private function removeAllBuffIcons() : void
      {
         this.removeBuffIcon(this.slowIcon);
         this.slowIcon = null;
         this.removeBuffIcon(this.doubleIcon);
         this.doubleIcon = null;
         this.removeBuffIcon(this.venomIcon);
         this.venomIcon = null;
      }
      
      private function spawnFloatingScore(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:String = param3 >= 0 ? "+" + param3 : "" + param3;
         var _loc5_:uint = param3 >= 0 ? uint(COLOR_SCORE_PLUS) : uint(COLOR_SCORE_MINUS);
         this.spawnFloatingText(param1,param2,_loc4_,_loc5_);
      }
      
      private function spawnFloatingText(param1:Number, param2:Number, param3:String, param4:uint) : void
      {
         var _loc6_:TextFormat = null;
         if(this.fxLayer == null)
         {
            return;
         }
         if(CatchingLantern.FLOAT_GLOW == null)
         {
            CatchingLantern.FLOAT_GLOW = CreateFilter.getGlowFilter({
               "color":0,
               "alpha":1,
               "strength":400,
               "blurX":2,
               "blurY":2
            });
         }
         var _loc5_:TextField;
         (_loc5_ = new TextField()).selectable = false;
         _loc5_.mouseEnabled = false;
         _loc5_.embedFonts = true;
         _loc5_.autoSize = TextFieldAutoSize.LEFT;
         if(param4 == COLOR_SCORE_PLUS)
         {
            _loc5_.defaultTextFormat = CatchingLantern.FLOAT_FORMAT_PLUS;
         }
         else if(param4 == COLOR_SCORE_MINUS)
         {
            _loc5_.defaultTextFormat = CatchingLantern.FLOAT_FORMAT_MINUS;
         }
         else
         {
            (_loc6_ = new TextFormat()).size = 44;
            _loc6_.bold = true;
            _loc6_.color = param4;
            _loc6_.font = "Franklin Gothic Demi";
            _loc5_.defaultTextFormat = _loc6_;
         }
         _loc5_.text = param3;
         _loc5_.filters = [CatchingLantern.FLOAT_GLOW];
         _loc5_.x = param1 - _loc5_.width * 0.5;
         _loc5_.y = param2 - 30;
         this.fxLayer.addChild(_loc5_);
         TweenLite.to(_loc5_,0.8,{
            "y":_loc5_.y - 90,
            "alpha":0,
            "ease":Linear.easeNone,
            "onComplete":this.removeFloatingText,
            "onCompleteParams":[_loc5_]
         });
      }
      
      private function removeFloatingText(param1:TextField) : void
      {
         if(param1 == null)
         {
            return;
         }
         TweenLite.killTweensOf(param1);
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function popObject(param1:MovieClip, param2:Boolean) : void
      {
         var _loc3_:Number = param1.y - 60;
         TweenLite.to(param1,0.25,{
            "y":_loc3_,
            "scaleX":(!!param2 ? 1.4 : 0.4),
            "scaleY":(!!param2 ? 1.4 : 0.4),
            "alpha":0,
            "onComplete":this.removeObject,
            "onCompleteParams":[param1]
         });
      }
      
      private function removeObject(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         TweenLite.killTweensOf(param1);
         var _loc2_:int = this.activeObjects.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.activeObjects.splice(_loc2_,1);
         }
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function endGame() : void
      {
         if(!this.playing)
         {
            return;
         }
         this.playing = false;
         this.stopVenom();
         this.removeAllBuffIcons();
         if(this.spawnTween != null)
         {
            TweenLite.killTweensOf(this.spawnObject);
            this.spawnTween = null;
         }
         this.clearActiveObjects();
         if(this.hudTimer != null)
         {
            this.eventHandler.removeListener(this.hudTimer,TimerEvent.TIMER,this.onHudTick);
            this.hudTimer.stop();
            this.hudTimer = null;
         }
         this.onGameOverAmf();
      }
      
      private function onGameOverAmf() : void
      {
         this.main.loading(true);
         var _loc1_:String = CUCSG.hash(Character.char_id + "_" + this.score.toString() + "_" + this.totalLanternCaught.toString() + "_" + this.bestCombo.toString() + "_" + Character.battle_code);
         this.main.amf_manager.service("urUACOuL6PahuoEd.VQF5sdP8F3Yj",[Character.char_id,Character.sessionkey,this.score,this.totalLanternCaught,this.bestCombo,_loc1_,Character.battle_code],this.onGameOverResponse);
      }
      
      private function onGameOverResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.renderResult(param1);
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.closePanel();
         }
      }
      
      public function renderResult(param1:Object) : void
      {
         this.onDragEnd();
         this.clickMask.visible = false;
         GF.removeAllChild(this.clickMask);
         this.resultMC.visible = true;
         this.resultMC.lanternCaughtMC.icon.gotoAndStop(1);
         this.resultMC.lanternScoreMC.icon.gotoAndStop(2);
         this.resultMC.lanternComboMC.icon.gotoAndStop(3);
         this.resultMC.lanternCaughtMC.txt_desc.text = "Lantern Caught";
         this.resultMC.lanternCaughtMC.txt_value.text = this.totalLanternCaught;
         this.resultMC.lanternScoreMC.txt_desc.text = "Total Score";
         this.resultMC.lanternScoreMC.txt_value.text = this.score;
         this.resultMC.lanternComboMC.txt_desc.text = "Highest Combo";
         this.resultMC.lanternComboMC.txt_value.text = this.bestCombo;
         this.eventHandler.addListener(this.resultMC.btn_close,MouseEvent.CLICK,this.closePanel);
         Character.addRewards(param1.rewards);
         this.main.HUD.setBasicData();
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this.resultMC["iconMc_" + _loc2_].visible = false;
            if(param1.rewards.length > _loc2_)
            {
               this.resultMC["iconMc_" + _loc2_].visible = true;
               this.resultMC["iconMc_" + _loc2_].icon.amountTxt.text = "";
               this.resultMC["iconMc_" + _loc2_].icon.ownedTxt.visible = false;
               if(Character.hasSkill(param1.rewards[_loc2_]) > 0)
               {
                  this.resultMC["iconMc_" + _loc2_].icon.ownedTxt.visible = true;
                  this.resultMC["iconMc_" + _loc2_].icon.ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(param1.rewards[_loc2_]) > 0)
               {
                  this.resultMC["iconMc_" + _loc2_].icon.ownedTxt.visible = true;
                  this.resultMC["iconMc_" + _loc2_].icon.ownedTxt.text = "Owned";
               }
               this.resultMC["iconMc_" + _loc2_].icon.btn_preview.visible = false;
               NinjaSage.loadItemIcon(this.resultMC["iconMc_" + _loc2_].icon,param1.rewards[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      private function clearActiveObjects() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = this.activeObjects.length - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = this.activeObjects[_loc1_] as MovieClip;
            if(_loc2_ != null)
            {
               TweenLite.killTweensOf(_loc2_);
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
            }
            _loc1_--;
         }
         this.activeObjects = [];
      }
      
      private function killLayerTweens(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = param1.numChildren - 1;
         while(_loc2_ >= 0)
         {
            TweenLite.killTweensOf(param1.getChildAt(_loc2_));
            _loc2_--;
         }
      }
      
      public function restartGame() : void
      {
         if(this.hudTimer != null)
         {
            this.eventHandler.removeListener(this.hudTimer,TimerEvent.TIMER,this.onHudTick);
            this.hudTimer.stop();
            this.hudTimer = null;
         }
         this.startGame();
      }
      
      public function closePanel(param1:MouseEvent = null) : void
      {
         this.summerMenu.showThisPanel();
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         this.playing = false;
         this.ending = false;
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            GF.removeAllChild(this.resultMC["iconMc_" + _loc1_].icon.rewardIcon.iconHolder);
            GF.removeAllChild(this.resultMC["iconMc_" + _loc1_].icon.skillIcon.iconHolder);
            _loc1_++;
         }
         if(this.main != null)
         {
            this.main.handleVillageHUDVisibility(true);
         }
         this.onDragEnd();
         this.clearActiveObjects();
         this.removeAllBuffIcons();
         this.stopAllHearts();
         this.killLayerTweens(this.fxLayer);
         this.killLayerTweens(this.objectLayer);
         TweenLite.killTweensOf(this.spawnObject);
         TweenLite.killTweensOf(this.endGame);
         this.spawnTween = null;
         this.stopVenom();
         if(this.hudTimer != null)
         {
            this.hudTimer.stop();
            this.hudTimer = null;
         }
         if(this.escapeKey != null)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this.eventHandler != null)
         {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
         }
         this.main = null;
         this.summerMenu = null;
         GF.removeAllChild(this);
      }
      
      private function stopAllHearts() : void
      {
         var _loc2_:MovieClip = null;
         if(this.heartMC == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < MAX_HEARTS)
         {
            _loc2_ = this.heartMC["heart_" + _loc1_] as MovieClip;
            if(_loc2_ != null)
            {
               if(_loc2_.totalFrames > 1)
               {
                  _loc2_.addFrameScript(_loc2_.totalFrames - 1,null);
               }
               _loc2_.stop();
            }
            _loc1_++;
         }
      }
   }
}
