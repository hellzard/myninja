package id.ninjasage.features.exam.specialjounin.stage1.chapter2
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_205 extends MovieClip
   {
       
      
      public var langFile;
      
      public var main;
      
      public var panelMC;
      
      public var player_mc;
      
      public var map1_enemy_killed:Boolean = false;
      
      public var map2_enemy_killed:Boolean = false;
      
      public var map3_enemy_killed:Boolean = false;
      
      public var map_0:MovieClip;
      
      public var map_1:MovieClip;
      
      public var map_2:MovieClip;
      
      public var map_3:MovieClip;
      
      public var classMap0;
      
      public var classMap1;
      
      public var classMap2;
      
      public var classMap3;
      
      public var map;
      
      public function Mission_205(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_205_Language();
         this.map_0 = this.panelMC["Map_0"];
         this.map_1 = this.panelMC["Map_1"];
         this.map_2 = this.panelMC["Map_2"];
         this.map_3 = this.panelMC["Map_3"];
         this.hideMaps();
         this.initMap();
      }
      
      public function hideMaps() : void
      {
         this.map_0.visible = false;
         this.map_1.visible = false;
         this.map_2.visible = false;
         this.map_3.visible = false;
      }
      
      public function initMap() : void
      {
         this.classMap0 = new Map_0(this.main,this.map_0,this);
         this.classMap1 = new Map_1(this.main,this.map_1,this);
         this.classMap2 = new Map_2(this.main,this.map_2,this);
         this.classMap3 = new Map_3(this.main,this.map_3,this);
         this.classMap0.showDialogue();
         this.classMap0.initMap();
      }
      
      public function showFailDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.destroy,"npc_class");
      }
      
      public function destroy() : void
      {
         this.main.loadVillageAndHUD();
         GF.removeAllChild(this.player_mc);
         GF.removeAllChild(this.map_0);
         GF.removeAllChild(this.map_1);
         GF.removeAllChild(this.map_2);
         GF.removeAllChild(this.map_3);
         GF.removeAllChild(this.panelMC);
         this.main = null;
         this.classMap0 = null;
         this.classMap1 = null;
         this.classMap2 = null;
         this.classMap3 = null;
         this.map_0 = null;
         this.map_1 = null;
         this.map_2 = null;
         this.map_3 = null;
         this.panelMC = null;
         this.player_mc = null;
         this.langFile = null;
         this.map = null;
      }
      
      public function getMap1Enemies(param1:*) : *
      {
         return this.main.getEnemy("ene_145",param1);
      }
      
      public function getMap2Enemies(param1:*) : *
      {
         return this.main.getEnemy("ene_144",param1);
      }
      
      public function getMap3Enemies(param1:*) : *
      {
         return this.main.getEnemy("ene_184",param1);
      }
   }
}
