package id.ninjasage.features.exam.ninjatutor.stage1.chapter2
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public dynamic class Map_1 extends MovieClip
   {
       
      
      public var char_mc:MovieClip;
      
      public var enemy_mc0:MovieClip;
      
      public var enemy_mc1:MovieClip;
      
      public var enemy_mc2:MovieClip;
      
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
         if(!this.parent_mc.enemy1_killed)
         {
            this.parent_mc.getMapEnemies(this.map_mc.enemy_mc0,1);
         }
         if(!this.parent_mc.enemy2_killed)
         {
            this.parent_mc.getMapEnemies(this.map_mc.enemy_mc1,2);
         }
         if(!this.parent_mc.enemy3_killed)
         {
            this.parent_mc.getMapEnemies(this.map_mc.enemy_mc2,3);
         }
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[0]];
         this.main.showDialogueNew(_loc1_,this.showDialogue2,this.parent_mc.getAsset("npcLoli"));
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[1]];
         this.main.showDialogueNew(_loc1_,this.showDialogue3,this.parent_mc.getAsset("npcMonsterRed"));
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.parent_mc.langFile.textArr[2]];
         this.main.showDialogueNew(_loc1_,null,null);
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
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.enemy_mc0))
         {
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.main.startNinjaTutorS1C2Battle(1);
            this.main.removeAllChild(this.map_mc.enemy_mc0);
         }
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.enemy_mc1))
         {
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.main.startNinjaTutorS1C2Battle(2);
            this.main.removeAllChild(this.map_mc.enemy_mc1);
         }
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.enemy_mc2))
         {
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.main.startNinjaTutorS1C2Battle(3);
            this.main.removeAllChild(this.map_mc.enemy_mc2);
         }
         if(this.map_mc.char_mc.hitTestObject(this.map_mc.linkAreaMc) && this.parent_mc.enemy1_killed && this.parent_mc.enemy2_killed && this.parent_mc.enemy3_killed)
         {
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
            this.parent_mc.hideMaps();
            this.parent_mc.classMap2.initMap();
         }
         if(_loc4_)
         {
            this.parent_mc.player_mc.gotoAndStop("stand");
            this.map_mc.removeEventListener(Event.ENTER_FRAME,this.onCharMove);
         }
      }
   }
}
