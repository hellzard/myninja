package id.ninjasage.features.exam.smission.stage5
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_278 extends MovieClip
   {
      
      public var main:*;
      
      public var panelMC:*;
      
      public var player_mc:*;
      
      public var enemy1_killed:Boolean = false;
      
      public var enemy2_killed:Boolean = false;
      
      public var enemy3_killed:Boolean = false;
      
      public var enemy4_killed:Boolean = false;
      
      public var map_1:MovieClip;
      
      public var map_2:MovieClip;
      
      public var classMap1:*;
      
      public var classMap2:*;
      
      public var map:*;
      
      public function Mission_278(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.map_1 = this.panelMC["Map_1"];
         this.map_2 = this.panelMC["Map_2"];
         this.hideMaps();
         this.initMap();
      }
      
      public function hideMaps() : void
      {
         this.map_1.visible = false;
         this.map_2.visible = false;
      }
      
      public function initMap() : void
      {
         this.classMap1 = new Map_1(this.main,this.map_1,this);
         this.classMap2 = new Map_2(this.main,this.map_2,this);
         this.classMap1.initMap();
      }
      
      public function getMapEnemies(param1:*, param2:*) : *
      {
         var _loc3_:* = ["ene_456","ene_458","ene_457","ene_459"];
         var _loc4_:* = _loc3_[param2 - 1];
         return this.main.getEnemy(_loc4_,param1);
      }
      
      public function destroy() : void
      {
         this.main.resetExamBooleans();
         this.main.loadVillageAndHUD();
         GF.removeAllChild(this.player_mc);
         GF.removeAllChild(this.map_1);
         GF.removeAllChild(this.map_2);
         GF.removeAllChild(this.panelMC);
         this.main = null;
         this.classMap1 = null;
         this.classMap2 = null;
         this.map_1 = null;
         this.map_2 = null;
         this.panelMC = null;
         this.player_mc = null;
         this.map = null;
      }
   }
}

