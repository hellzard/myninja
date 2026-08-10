package id.ninjasage.features.exam.ninjatutor.stage6.chapter2
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
      
      public var main:*;
      
      public var map_mc:*;
      
      public var parent_mc:*;
      
      internal var clickPoint:Point = new Point();
      
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
         this.parent_mc.getMapEnemies(this.map_mc.enemy_mc,1);
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[0]];
         this.main.showDialogueNew(_loc1_,this.showDialogue2,this.parent_mc.getAsset("npcPain6"));
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[1]];
         this.main.showDialogueNew(_loc1_,this.showDialogue3,null);
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[2]];
         this.main.showDialogueNew(_loc1_,this.showDialogue3s,this.parent_mc.getAsset("npcPain6"));
      }
      
      public function showDialogue3s() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[3]];
         this.main.showDialogueNew(_loc1_,null,null);
      }
      
      public function showDialogue4() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[4]];
         this.main.showDialogueNew(_loc1_,this.showDialogue5,this.parent_mc.getAsset("npcPain6"));
      }
      
      public function showDialogue5() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[5]];
         this.main.showDialogueNew(_loc1_,this.showDialogue6,null);
      }
      
      public function showDialogue6() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[6]];
         this.main.showDialogueNew(_loc1_,this.showDialogue7,this.parent_mc.getAsset("npcPain6"));
      }
      
      public function showDialogue7() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[7]];
         this.main.showDialogueNew(_loc1_,this.showDialogue8,null);
      }
      
      public function showDialogue8() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[8]];
         this.main.showDialogueNew(_loc1_,this.showDialogue9,this.parent_mc.getAsset("npcPain6"));
      }
      
      public function showDialogue9() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[9]];
         this.main.showDialogueNew(_loc1_,this.showDialogue10,this.parent_mc.getAsset("npcPain7"));
      }
      
      public function showDialogue10() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[10]];
         this.main.showDialogueNew(_loc1_,this.showDialogue11,null);
      }
      
      public function showDialogue11() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[11]];
         this.main.showDialogueNew(_loc1_,this.showDialogue12,this.parent_mc.getAsset("npcPain7"));
      }
      
      public function showDialogue12() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[12]];
         this.main.showDialogueNew(_loc1_,this.showDialogue13,null);
      }
      
      public function showDialogue13() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[13]];
         this.main.showDialogueNew(_loc1_,this.showDialogue14,this.parent_mc.getAsset("npcPain7"));
      }
      
      public function showDialogue14() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[14]];
         this.main.showDialogueNew(_loc1_,this.showDialogue15,null);
      }
      
      public function showDialogue15() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[15]];
         this.main.showDialogueNew(_loc1_,this.showDialogue16,this.parent_mc.getAsset("npcPain7"));
      }
      
      public function showDialogue16() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[16]];
         this.main.showDialogueNew(_loc1_,this.showDialogue17,null);
      }
      
      public function showDialogue17() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[17]];
         this.main.showDialogueNew(_loc1_,this.showDialogue18,this.parent_mc.getAsset("npcPain7"));
      }
      
      public function showDialogue18() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[18]];
         this.main.showDialogueNew(_loc1_,this.showDialogue19,null);
      }
      
      public function showDialogue19() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[19]];
         this.main.showDialogueNew(_loc1_,this.showDialogue20,this.parent_mc.getAsset("npcPain7"));
      }
      
      public function showDialogue20() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[20]];
         this.main.showDialogueNew(_loc1_,this.showDialogue21,null);
      }
      
      public function showDialogue21() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[21]];
         this.main.showDialogueNew(_loc1_,this.showDialogue22,this.parent_mc.getAsset("npcPain7"));
      }
      
      public function showDialogue22() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[22]];
         this.main.showDialogueNew(_loc1_,this.main.startNinjaTutorS6C2Battle(2),null);
      }
      
      public function showFinalDialog() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[23]];
         this.main.showDialogueNew(_loc1_,this.showFinalDialog1,null);
      }
      
      public function showFinalDialog1() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[24]];
         this.main.showDialogueNew(_loc1_,this.finishStageS6C2,null);
      }
      
      public function finishStageS6C2() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("NinjaTutorExam.finishStage",[Character.char_id,Character.sessionkey,35,[]],this.onFinishStageRes);
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
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.enemy_mc))
         {
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.main.startNinjaTutorS6C2Battle(1);
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

