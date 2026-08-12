package id.ninjasage.features.exam.jounin.stage3
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public dynamic class Map_1 extends MovieClip
   {
       
      
      public var main;
      
      public var map_mc:MovieClip;
      
      public var _parent;
      
      var clickPoint:Point;
      
      public function Map_1(param1:*, param2:*, param3:*)
      {
         this.clickPoint = new Point();
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
         this.map_mc.addEventListener(MouseEvent.CLICK,this.onGotoPos);
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
         var _loc4_:* = (_loc4_ = _loc2_ > -10 && _loc2_ < 10) && (_loc3_ > -10 && _loc3_ < 10);
         if(_loc2_ < 0)
         {
            this._parent.player_mc.scaleX = 1;
         }
         else
         {
            this._parent.player_mc.scaleX = -1;
         }
         var _loc5_:Number = Math.atan2(_loc3_,_loc2_);
         this.map_mc.char_mc.x += 10 * Math.cos(_loc5_);
         this.map_mc.char_mc.y += 10 * Math.sin(_loc5_);
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.linkAreaMc.link_4))
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this._parent.hideMaps();
            this._parent.classMap3.initMap();
         }
         else if(this.map_mc.char_mc.hitTestObject(this.map_mc.linkAreaMc.link_3))
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            if(this._parent.total_seals >= 1)
            {
               this._parent.hideMaps();
               this._parent.classMap5.initMap();
            }
            else
            {
               this.main.showMessage("Map locked.");
            }
         }
         else if(this.map_mc.char_mc.hitTestObject(this.map_mc.linkAreaMc.link_1))
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            if(this._parent.total_seals >= 3)
            {
               this._parent.hideMaps();
               this._parent.classMap9.initMap();
            }
            else
            {
               this.main.showMessage("Map locked.");
            }
         }
         else if(this.map_mc.char_mc.hitTestObject(this.map_mc.linkAreaMc.link_2))
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            if(this._parent.total_seals >= 2)
            {
               this._parent.hideMaps();
               this._parent.classMap7.initMap();
            }
            else
            {
               this.main.showMessage("Map locked.");
            }
         }
      }
   }
}
