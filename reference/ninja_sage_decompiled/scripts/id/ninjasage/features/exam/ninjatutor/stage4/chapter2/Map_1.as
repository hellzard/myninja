package id.ninjasage.features.exam.ninjatutor.stage4.chapter2
{
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public dynamic class Map_1 extends MovieClip
   {
       
      
      public var char_mc:MovieClip;
      
      public var enemy_mc:MovieClip;
      
      public var linkAreaMc:MovieClip;
      
      public var main;
      
      public var map_mc;
      
      public var parent_mc;
      
      var clickPoint:Point;
      
      public function Map_1(param1:* = null, param2:* = null, param3:* = null)
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
         this.parent_mc.getMapEnemies(this.map_mc.enemy_mc,1);
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[0]];
         this.main.showDialogueNew(_loc1_,this.showDialogue2,this.parent_mc.getAsset("npcPain4"));
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[1]];
         this.main.showDialogueNew(_loc1_,this.showDialogue3,this.parent_mc.getAsset("npcBrownHair"));
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[2]];
         this.main.showDialogueNew(_loc1_,this.showDialogue4,null);
      }
      
      public function showDialogue4() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[3]];
         this.main.showDialogueNew(_loc1_,this.showDialogue5,this.parent_mc.getAsset("npcPain4"));
      }
      
      public function showDialogue5() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[4]];
         this.main.showDialogueNew(_loc1_,this.showDialogue6,this.parent_mc.getAsset("npcBrownHair"));
      }
      
      public function showDialogue6() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[5]];
         this.main.showDialogueNew(_loc1_,this.showDialogue7,null);
      }
      
      public function showDialogue7() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[6]];
         this.main.showDialogueNew(_loc1_,null,this.parent_mc.getAsset("npcPain4"));
      }
      
      public function showFinalDialog() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[7]];
         this.main.showDialogueNew(_loc1_,this.showFinalDialog1,null);
      }
      
      public function showFinalDialog1() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[8]];
         this.main.showDialogueNew(_loc1_,this.showFinalDialog2,null);
      }
      
      public function showFinalDialog2() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[9]];
         this.main.showDialogueNew(_loc1_,this.finishStageS4C2,this.parent_mc.getAsset("npcBrownHair"));
      }
      
      public function finishStageS4C2() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("NinjaTutorExam.finishStage",[Character.char_id,Character.sessionkey,31,[]],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.parent_mc.destroy();
            this.main = null;
            this.parent_mc = null;
            this.clickPoint = null;
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
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.enemy_mc))
         {
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.main.startNinjaTutorS4C2Battle(1);
            this.main.removeAllChild(this.map_mc.enemy_mc);
         }
         if(_loc4_)
         {
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
         }
      }
   }
}
