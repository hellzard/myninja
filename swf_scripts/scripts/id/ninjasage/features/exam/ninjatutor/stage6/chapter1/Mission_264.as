package id.ninjasage.features.exam.ninjatutor.stage6.chapter1
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_264 extends MovieClip
   {
      
      public var langFile:*;
      
      public var main:*;
      
      public var panelMC:*;
      
      public var player_mc:*;
      
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
      
      public var npcs:*;
      
      public var map:*;
      
      public var enemy1_killed:Boolean = false;
      
      public var enemy2_killed:Boolean = false;
      
      public var enemy3_killed:Boolean = false;
      
      public var enemy4_killed:Boolean = false;
      
      public var enemy5_killed:Boolean = false;
      
      public function Mission_264(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.npcs = {
            "npcKage":param2.npcKage,
            "npcPain6":param2.npcPain6
         };
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_264_Language();
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
      
      public function getMapEnemies(param1:*, param2:*) : *
      {
         var _loc3_:* = ["ene_352","ene_354","ene_353","ene_351","ene_355"];
         var _loc4_:* = _loc3_[param2 - 1];
         return this.main.getEnemy(_loc4_,param1);
      }
      
      public function showFailDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[22]];
         this.main.showDialogueNew(_loc1_,this.destroy,null);
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
   }
}

