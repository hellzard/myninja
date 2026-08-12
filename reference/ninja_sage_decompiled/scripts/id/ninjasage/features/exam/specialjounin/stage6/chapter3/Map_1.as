package id.ninjasage.features.exam.specialjounin.stage6.chapter3
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public dynamic class Map_1 extends MovieClip
   {
       
      
      public var main;
      
      public var character;
      
      public var parent_mc;
      
      public var map_mc;
      
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
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[0]];
         this.main.showDialogue(_loc1_,this.showDialogue2,"vadarrage");
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[1]];
         this.main.showDialogue(_loc1_,this.showDialogue3,"yudai");
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[2]];
         this.main.showDialogue(_loc1_,this.showDialogue4,"yudai");
      }
      
      public function showDialogue4() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,this.showDialogue5,"npc_class");
      }
      
      public function showDialogue5() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.showDialogue6,"maeda");
      }
      
      public function showDialogue6() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[5]];
         this.main.showDialogue(_loc1_,this.showDialogue7,"attack");
      }
      
      public function showDialogue7() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[6]];
         this.main.showDialogue(_loc1_,this.showDialogue8,"health");
      }
      
      public function showDialogue8() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[7]];
         this.main.showDialogue(_loc1_,this.showDialogue9,"perceive");
      }
      
      public function showDialogue9() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[8]];
         this.main.showDialogue(_loc1_,null,"yudai");
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
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.showStory();
         }
         if(_loc4_)
         {
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
         }
      }
      
      public function showStory() : *
      {
         this.parent_mc.storyMC1.visible = true;
         this.parent_mc.storyMC1.gotoAndPlay(2);
         this.parent_mc.storyMC1.addFrameScript(120,this.frame121);
      }
      
      public function frame121() : *
      {
         this.parent_mc.storyMC1.stop();
         this.parent_mc.storyMC1.visible = false;
         this.main.startSpecialJouninS6C3Battle1();
      }
   }
}
