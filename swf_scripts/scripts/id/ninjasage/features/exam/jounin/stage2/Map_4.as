package id.ninjasage.features.exam.jounin.stage2
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public dynamic class Map_4 extends MovieClip
   {
      
      public var main:*;
      
      public var map_mc:MovieClip;
      
      public var parent_mc:*;
      
      internal var clickPoint:Point = new Point();
      
      public function Map_4(param1:*, param2:*, param3:*)
      {
         super();
         this.main = param1;
         this.map_mc = param2;
         this.parent_mc = param3;
      }
      
      public function initMap() : void
      {
         this.map_mc.visible = true;
         this.parent_mc.map = this;
         this.map_mc.char_mc.addChild(this.parent_mc.player_mc);
         this.parent_mc.player_mc.scaleX = -1;
         this.parent_mc.player_mc.gotoAndStop("stand");
         if(!this.parent_mc.map4_enemy_killed)
         {
            this.parent_mc.getMap4Enemies(this.map_mc.enemy_mc);
         }
         this.map_mc.addEventListener(MouseEvent.CLICK,this.onGotoPos);
      }
      
      public function onGotoPos(param1:MouseEvent) : *
      {
         this.clickPoint.x = param1.localX;
         this.clickPoint.y = param1.localY;
         this.parent_mc.player_mc.gotoAndPlay("run");
         this.map_mc.addEventListener(Event.ENTER_FRAME,this.onCharMove);
      }
      
      public function onCharMove(param1:Event) : *
      {
         var _loc2_:Number = this.clickPoint.x - this.map_mc.char_mc.x;
         var _loc3_:Number = this.clickPoint.y - this.map_mc.char_mc.y;
         var _loc4_:* = _loc2_ > -15 && _loc2_ < 15;
         _loc4_ = (_loc4_) && (_loc3_ > -15 && _loc3_ < 15);
         if(_loc2_ < 0)
         {
            this.parent_mc.player_mc.scaleX = 1;
         }
         else
         {
            this.parent_mc.player_mc.scaleX = -1;
         }
         var _loc5_:Number = Math.atan2(_loc3_,_loc2_);
         this.map_mc.char_mc.x += 15 * Math.cos(_loc5_);
         this.map_mc.char_mc.y += 15 * Math.sin(_loc5_);
         if(Boolean(this.map_mc.char_mc.hitTestObject(this.map_mc.enterMc)) && Boolean(this.parent_mc.map4_enemy_killed))
         {
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.hideMaps();
            this.parent_mc.classMap5.initMap();
         }
         if(Boolean(this.map_mc.char_mc.hitTestObject(this.map_mc.enemy_mc)) && Boolean(this.parent_mc.map3_enemy_killed))
         {
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.main.startJouninStage2(3);
         }
         if(_loc4_)
         {
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
         }
      }
   }
}

