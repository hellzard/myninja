package id.ninjasage.features.exam.chunin.stage2
{
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public dynamic class Map_10 extends MovieClip
   {
      
      public var char_mc:MovieClip;
      
      public var blockAreaMc:MovieClip;
      
      public var scrollTxt:TextField;
      
      public var walkAreaMc:MovieClip;
      
      public var npcMc:MovieClip;
      
      public var linkAreaMc:MovieClip;
      
      public var main:*;
      
      public var character:*;
      
      public var map_mc:*;
      
      public var _parent:*;
      
      internal var clickPoint:Point = new Point();
      
      public function Map_10(param1:*, param2:*, param3:*)
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
         this._parent.player_mc.scaleX = -1;
         this.map_mc.char_mc.addChild(this._parent.player_mc);
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
      
      public function showDialogue(param1:Boolean) : *
      {
         var _loc2_:* = param1 ? 5 : 6;
         var _loc3_:* = [this._parent.langFile.textArr[_loc2_]];
         if(param1)
         {
            this.main.showDialogue(_loc3_,this.finishStage2);
         }
         else
         {
            this.main.showDialogue(_loc3_);
         }
      }
      
      public function finishStage2() : *
      {
         this.main.amf_manager.service("ChuninExam.finishStage",[Character.sessionkey,Character.char_id,2,this._parent.map5_enemy_killed,this._parent.map9_enemy_killed,this._parent.total_scrolls],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         var _loc2_:* = undefined;
         if(param1.status > 0)
         {
            _loc2_ = param1.hash;
            this._parent.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
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
         if(this.map_mc.char_mc.x > 600)
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            if(this._parent.total_scrolls == 2)
            {
               this.showDialogue(true);
            }
            else
            {
               this.showDialogue(false);
            }
         }
         else if(this.map_mc.char_mc.x < 120)
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this._parent.hideMaps();
            this._parent.classMap5.initMap();
         }
         else if(_loc2_ < 5 && _loc3_ < 5)
         {
            this._parent.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
         }
      }
   }
}

