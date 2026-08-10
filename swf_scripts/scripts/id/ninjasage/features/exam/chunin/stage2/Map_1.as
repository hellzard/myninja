package id.ninjasage.features.exam.chunin.stage2
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public dynamic class Map_1 extends MovieClip
   {
      
      public var char_mc:MovieClip;
      
      public var blockAreaMc:MovieClip;
      
      public var scrollTxt:TextField;
      
      public var walkAreaMc:MovieClip;
      
      public var npcMc:MovieClip;
      
      public var exitMc:MovieClip;
      
      public var linkAreaMc:MovieClip;
      
      public var main:*;
      
      public var map_mc:*;
      
      public var character:*;
      
      public var _parent:*;
      
      internal var clickPoint:Point = new Point();
      
      public function Map_1(param1:*, param2:*, param3:*)
      {
         super();
         this.main = param1;
         this.map_mc = param2;
         this._parent = param3;
      }
      
      public function initMap() : void
      {
         this.map_mc.visible = true;
         this._parent.map = this;
         this._parent.updateScrolls();
         this.map_mc.char_mc.addChild(this._parent.player_mc);
         this._parent.player_mc.scaleX = -1;
         this._parent.player_mc.gotoAndStop("stand");
         this.map_mc.addEventListener(MouseEvent.CLICK,this.onGotoPos);
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this._parent.langFile.textArr[0],this._parent.langFile.textArr[1],this._parent.langFile.textArr[2],this._parent.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,null,"raiga");
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this._parent.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.testCallback,"raiga");
      }
      
      public function testCallback() : *
      {
         this._parent.hideMaps();
         this._parent.classMap6.initMap();
      }
      
      public function onGotoPos(param1:MouseEvent) : *
      {
         this.clickPoint.x = param1.localX;
         this.clickPoint.y = param1.localY;
         this._parent.player_mc.gotoAndPlay("run");
         this.map_mc.addEventListener(Event.ENTER_FRAME,this.onCharMove);
      }
      
      public function onCharMove(param1:Event) : *
      {
         var _loc2_:Number = this.clickPoint.x - this.map_mc.char_mc.x;
         var _loc3_:Number = this.clickPoint.y - this.map_mc.char_mc.y;
         if(_loc2_ < 0)
         {
            this._parent.player_mc.scaleX = 1;
         }
         else
         {
            this._parent.player_mc.scaleX = -1;
         }
         var _loc4_:Number = Math.atan2(_loc3_,_loc2_);
         this.map_mc.char_mc.x += 15 * Math.cos(_loc4_);
         this.map_mc.char_mc.y += 15 * Math.sin(_loc4_);
         if(this.map_mc.char_mc.x > 1500)
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.showDialogue2();
         }
         else if(_loc2_ < 5 && _loc3_ < 5)
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
         }
      }
   }
}

