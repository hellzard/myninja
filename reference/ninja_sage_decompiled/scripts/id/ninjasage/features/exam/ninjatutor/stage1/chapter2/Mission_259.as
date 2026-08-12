package id.ninjasage.features.exam.ninjatutor.stage1.chapter2
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_259 extends MovieClip
   {
       
      
      public var langFile;
      
      public var main;
      
      public var panelMC;
      
      public var player_mc;
      
      public var enemy1_killed:Boolean = false;
      
      public var enemy2_killed:Boolean = false;
      
      public var enemy3_killed:Boolean = false;
      
      public var enemy4_killed:Boolean = false;
      
      public var map_1:MovieClip;
      
      public var map_2:MovieClip;
      
      public var classMap1;
      
      public var classMap2;
      
      public var npcs;
      
      public var map;
      
      public function Mission_259(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.npcs = {
            "npcLoli":param2.npcLoli,
            "npcPain1":param2.npcPain1,
            "npcMonsterRed":param2.npcMonsterRed
         };
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_259_Language();
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
         this.classMap1.showDialogue();
         this.classMap1.initMap();
      }
      
      public function getMapEnemies(param1:*, param2:*) : *
      {
         var _loc3_:* = ["ene_348","ene_349","ene_350","ene_356"];
         var _loc4_:* = _loc3_[param2 - 1];
         return this.main.getEnemy(_loc4_,param1);
      }
      
      public function showFailDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[6]];
         this.main.showDialogueNew(_loc1_,this.showFailDialog2,this.getAsset("npcMonsterRed"));
      }
      
      public function showFailDialog2() : *
      {
         var _loc1_:* = [this.langFile.textArr[7]];
         this.main.showDialogueNew(_loc1_,this.destroy,this.getAsset("npcPain1"));
      }
      
      public function getAsset(param1:String) : MovieClip
      {
         return this.npcs[param1];
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
         this.langFile = null;
         this.map = null;
      }
   }
}
