package id.ninjasage.features.exam.smission.stage4
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_277 extends MovieClip
   {
      
      public var main:*;
      
      public var panelMC:*;
      
      public var player_mc:*;
      
      public var enemy1_killed:Boolean = false;
      
      public var enemy2_killed:Boolean = false;
      
      public var enemy3_killed:Boolean = false;
      
      public var enemy4_killed:Boolean = false;
      
      public var enemy5_killed:Boolean = false;
      
      public var enemy6_killed:Boolean = false;
      
      public var enemy7_killed:Boolean = false;
      
      public var map_1:MovieClip;
      
      public var map_2:MovieClip;
      
      public var map_3:MovieClip;
      
      public var map_4:MovieClip;
      
      public var map_5:MovieClip;
      
      public var map_6:MovieClip;
      
      public var map_7:MovieClip;
      
      public var map_8:MovieClip;
      
      public var classMap1:*;
      
      public var classMap2:*;
      
      public var classMap3:*;
      
      public var classMap4:*;
      
      public var classMap5:*;
      
      public var classMap6:*;
      
      public var classMap7:*;
      
      public var classMap8:*;
      
      public var map:*;
      
      public function Mission_277(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.map_1 = this.panelMC["Map_1"];
         this.map_2 = this.panelMC["Map_2"];
         this.map_3 = this.panelMC["Map_3"];
         this.map_4 = this.panelMC["Map_4"];
         this.map_5 = this.panelMC["Map_5"];
         this.map_6 = this.panelMC["Map_6"];
         this.map_7 = this.panelMC["Map_7"];
         this.map_8 = this.panelMC["Map_8"];
         this.hideMaps();
         this.initMap();
      }
      
      public function hideMaps() : void
      {
         this.map_1.visible = false;
         this.map_2.visible = false;
         this.map_3.visible = false;
         this.map_4.visible = false;
         this.map_5.visible = false;
         this.map_6.visible = false;
         this.map_7.visible = false;
         this.map_8.visible = false;
      }
      
      public function initMap() : void
      {
         this.classMap1 = new Map_1(this.main,this.map_1,this);
         this.classMap2 = new Map_2(this.main,this.map_2,this);
         this.classMap3 = new Map_3(this.main,this.map_3,this);
         this.classMap4 = new Map_4(this.main,this.map_4,this);
         this.classMap5 = new Map_5(this.main,this.map_5,this);
         this.classMap6 = new Map_6(this.main,this.map_6,this);
         this.classMap7 = new Map_7(this.main,this.map_7,this);
         this.classMap8 = new Map_8(this.main,this.map_8,this);
         this.classMap1.initMap();
      }
      
      public function getMapEnemies(param1:*, param2:*) : *
      {
         var _loc3_:* = ["ene_453","ene_451","ene_454","ene_452","ene_454","ene_453","ene_454"];
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
         GF.removeAllChild(this.map_3);
         GF.removeAllChild(this.map_4);
         GF.removeAllChild(this.map_5);
         GF.removeAllChild(this.map_6);
         GF.removeAllChild(this.map_7);
         GF.removeAllChild(this.map_8);
         GF.removeAllChild(this.panelMC);
         this.main = null;
         this.classMap1 = null;
         this.classMap2 = null;
         this.classMap3 = null;
         this.classMap4 = null;
         this.classMap5 = null;
         this.classMap6 = null;
         this.classMap7 = null;
         this.classMap8 = null;
         this.map_1 = null;
         this.map_2 = null;
         this.map_3 = null;
         this.map_4 = null;
         this.map_5 = null;
         this.map_6 = null;
         this.map_7 = null;
         this.map_8 = null;
         this.panelMC = null;
         this.player_mc = null;
         this.map = null;
      }
   }
}

