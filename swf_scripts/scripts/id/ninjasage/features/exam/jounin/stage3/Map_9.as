package id.ninjasage.features.exam.jounin.stage3
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public dynamic class Map_9 extends MovieClip
   {
      
      public var main:*;
      
      public var map_mc:*;
      
      public var _parent:*;
      
      public var kekkai:*;
      
      internal var clickPoint:Point = new Point();
      
      public function Map_9(param1:*, param2:*, param3:*)
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
         this._parent.updateSeals();
         this.map_mc.char_mc.addChild(this._parent.player_mc);
         this._parent.player_mc.scaleX = -1;
         this._parent.player_mc.gotoAndStop("stand");
         this.map_mc.addEventListener(MouseEvent.CLICK,this.onGotoPos,false,0,true);
         this.map_mc.npcMc.visible = this._parent.total_seals == 3 || this._parent.kekkaiGame.completed;
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
         var _loc4_:Number = Math.atan2(_loc3_,_loc2_);
         this.map_mc.char_mc.x += 15 * Math.cos(_loc4_);
         this.map_mc.char_mc.y += 15 * Math.sin(_loc4_);
         if(_loc2_ < 0)
         {
            this._parent.player_mc.scaleX = 1;
         }
         else
         {
            this._parent.player_mc.scaleX = -1;
         }
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.linkAreaMc))
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this._parent.hideMaps();
            this._parent.classMap1.initMap();
         }
         else if(Boolean(this.map_mc.char_mc.hitTestObject(this.map_mc.npcMc)) && Boolean(this.map_mc.npcMc.visible))
         {
            this.map_mc.npcMc.visible = false;
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this._parent.kekkaiGame.init(this.main,this._parent.kekkaiMC,this._parent,4,this);
            this._parent.kekkaiMC.visible = true;
         }
         else if(_loc2_ < 5 && _loc3_ < 5)
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
         }
      }
      
      public function onExit() : *
      {
         this.map_mc.npcMc.visible = this._parent.total_seals == 3 || this._parent.kekkaiGame.completed;
      }
   }
}

