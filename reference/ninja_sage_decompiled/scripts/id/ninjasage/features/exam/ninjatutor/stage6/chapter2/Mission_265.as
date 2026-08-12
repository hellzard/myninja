package id.ninjasage.features.exam.ninjatutor.stage6.chapter2
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_265 extends MovieClip
   {
       
      
      public var langFile;
      
      public var main;
      
      public var panelMC;
      
      public var player_mc;
      
      public var map_1:MovieClip;
      
      public var classMap1;
      
      public var npcs;
      
      public var map;
      
      public var battle1_cleared:Boolean = false;
      
      public function Mission_265(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.npcs = {
            "npcPain6":param2.npcPain6,
            "npcPain7":param2.npcPain7
         };
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_265_Language();
         this.map_1 = this.panelMC["Map_1"];
         this.hideMaps();
         this.initMap();
      }
      
      public function hideMaps() : void
      {
         this.map_1.visible = false;
      }
      
      public function initMap() : void
      {
         this.classMap1 = new Map_1(this.main,this.map_1,this);
         this.classMap1.showDialogue();
         this.classMap1.initMap();
      }
      
      public function getMapEnemies(param1:*, param2:*) : *
      {
         var _loc3_:* = ["ene_362"];
         var _loc4_:* = _loc3_[param2 - 1];
         return this.main.getEnemy(_loc4_,param1);
      }
      
      public function showFailDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[25]];
         this.main.showDialogueNew(_loc1_,this.destroy,this.getAsset("npcPain7"));
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
         GF.removeAllChild(this.panelMC);
         this.main = null;
         this.classMap1 = null;
         this.map_1 = null;
         this.panelMC = null;
         this.player_mc = null;
         this.langFile = null;
         this.map = null;
      }
   }
}
