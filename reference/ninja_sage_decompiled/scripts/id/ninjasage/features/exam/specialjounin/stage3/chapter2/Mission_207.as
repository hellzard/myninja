package id.ninjasage.features.exam.specialjounin.stage3.chapter2
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_207 extends MovieClip
   {
       
      
      public var langFile;
      
      public var main;
      
      public var panelMC;
      
      public var player_mc;
      
      public var map1_enemy_killed:Boolean = false;
      
      public var map2_enemy_killed:Boolean = false;
      
      public var map3_enemy_killed:Boolean = false;
      
      public var map_1:MovieClip;
      
      public var map_2:MovieClip;
      
      public var classMap1;
      
      public var classMap2;
      
      public var map;
      
      public function Mission_207(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_207_Language();
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
      
      public function showFailDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[0]];
         this.main.showDialogue(_loc1_,this.destroy,"perceive");
      }
      
      public function destroy() : void
      {
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
