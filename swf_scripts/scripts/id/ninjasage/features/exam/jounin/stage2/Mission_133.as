package id.ninjasage.features.exam.jounin.stage2
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_133 extends MovieClip
   {
      
      public var langFile:*;
      
      public var main:*;
      
      public var panelMC:*;
      
      public var player_mc:*;
      
      public var map2_enemy_killed:Boolean = false;
      
      public var map3_enemy_killed:Boolean = false;
      
      public var map4_enemy_killed:Boolean = false;
      
      public var map5_enemy_killed:Boolean = false;
      
      public var map_1:MovieClip;
      
      public var map_2:MovieClip;
      
      public var map_3:MovieClip;
      
      public var map_4:MovieClip;
      
      public var map_5:MovieClip;
      
      public var classMap1:*;
      
      public var classMap2:*;
      
      public var classMap3:*;
      
      public var classMap4:*;
      
      public var classMap5:*;
      
      public var map:*;
      
      public function Mission_133(param1:* = null, param2:* = null)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_133_Language();
         this.map_1 = this.panelMC["Map_1"];
         this.map_2 = this.panelMC["Map_2"];
         this.map_3 = this.panelMC["Map_3"];
         this.map_4 = this.panelMC["Map_4"];
         this.map_5 = this.panelMC["Map_5"];
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
      }
      
      public function initMap() : void
      {
         this.classMap1 = new Map_1(this.main,this.map_1,this);
         this.classMap2 = new Map_2(this.main,this.map_2,this);
         this.classMap3 = new Map_3(this.main,this.map_3,this);
         this.classMap4 = new Map_4(this.main,this.map_4,this);
         this.classMap5 = new Map_5(this.main,this.map_5,this);
         this.classMap1.showDialogue();
         this.classMap1.initMap();
      }
      
      public function showFailDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[7]];
         this.main.showDialogue(_loc1_,this.destroy,"genzu");
      }
      
      public function destroy() : void
      {
         this.main.loadVillageAndHUD();
         GF.removeAllChild(this.player_mc);
         GF.removeAllChild(this.map_1);
         GF.removeAllChild(this.map_2);
         GF.removeAllChild(this.map_3);
         GF.removeAllChild(this.map_4);
         GF.removeAllChild(this.map_5);
         GF.removeAllChild(this.panelMC);
         this.main = null;
         this.classMap1 = null;
         this.classMap2 = null;
         this.classMap3 = null;
         this.classMap4 = null;
         this.classMap5 = null;
         this.map_1 = null;
         this.map_2 = null;
         this.map_3 = null;
         this.map_4 = null;
         this.map_5 = null;
         this.panelMC = null;
         this.player_mc = null;
         this.langFile = null;
         this.map = null;
      }
      
      public function getMap2Enemies(param1:*) : *
      {
         return this.main.getEnemy("ene_95",param1);
      }
      
      public function getMap3Enemies(param1:*) : *
      {
         return this.main.getEnemy("ene_96",param1);
      }
      
      public function getMap4Enemies(param1:*) : *
      {
         return this.main.getEnemy("ene_97",param1);
      }
      
      public function getMap5Enemies(param1:*) : *
      {
         param1.addChild(this.main.createPlayerMc());
         param1.scaleX = -1;
      }
   }
}

