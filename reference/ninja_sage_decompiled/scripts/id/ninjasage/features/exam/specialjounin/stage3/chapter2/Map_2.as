package id.ninjasage.features.exam.specialjounin.stage3.chapter2
{
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public dynamic class Map_2 extends MovieClip
   {
       
      
      public var main;
      
      public var character;
      
      public var parent_mc;
      
      var clickPoint:Point;
      
      public var map_mc:MovieClip;
      
      public function Map_2(param1:* = null, param2:* = null, param3:* = null)
      {
         this.clickPoint = new Point();
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
      
      public function showFinalDialog() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.finishStageS3C2,"yudai");
      }
      
      public function finishStageS3C2() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("SpecialJouninExam.finishStage",[Character.sessionkey,Character.char_id,16,[]],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.parent_mc.destroy();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
            this.parent_mc.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
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
         var _loc4_:* = (_loc4_ = _loc2_ > -15 && _loc2_ < 15) && (_loc3_ > -15 && _loc3_ < 15);
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
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.npcMc))
         {
            this.map_mc.npcMc.visible = false;
            this.map_mc.removeChild(this.map_mc.char_mc);
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.main.removeAllChild(this.map_mc.enemy_mc);
            this.main.startSpecialJouninS3C2Battle2();
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
