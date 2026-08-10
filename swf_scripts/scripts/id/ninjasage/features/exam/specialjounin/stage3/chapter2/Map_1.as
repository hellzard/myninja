package id.ninjasage.features.exam.specialjounin.stage3.chapter2
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public dynamic class Map_1 extends MovieClip
   {
      
      public var main:*;
      
      public var character:*;
      
      public var parent_mc:*;
      
      internal var clickPoint:Point = new Point();
      
      public var map_mc:MovieClip;
      
      public function Map_1(param1:* = null, param2:* = null, param3:* = null)
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
         this.map_mc.addEventListener(MouseEvent.CLICK,this.onGotoPos);
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[1]];
         this.main.showDialogue(_loc1_,this.showDialogue2,"darkninja");
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[2]];
         this.main.showDialogue(_loc1_,this.showDialogue3,"butterfly");
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,null,"darkninja");
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
         if(Boolean(this.map_mc.char_mc.hitTestObject(this.map_mc.linkAreaMc.link_1)) && Boolean(this.parent_mc.map1_enemy_killed))
         {
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.hideMaps();
            this.parent_mc.classMap2.initMap();
         }
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.enemy_mc))
         {
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            GF.removeAllChild(this.map_mc.enemy_mc);
            this.main.startSpecialJouninS3C2Battle1();
            this.parent_mc.player_mc.gotoAndStop("stand");
         }
         if(_loc4_)
         {
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
         }
      }
   }
}

