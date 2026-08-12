package id.ninjasage.features.exam.specialjounin.stage2.chapter2
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_206 extends MovieClip
   {
       
      
      public var langFile;
      
      public var main;
      
      public var panelMC;
      
      public var player_mc;
      
      public var map1_enemy_killed:Boolean = false;
      
      public var map2_enemy_killed:Boolean = false;
      
      public var map3_enemy_killed:Boolean = false;
      
      public var map_1:MovieClip;
      
      public var classMap1;
      
      public var map;
      
      public function Mission_206(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_206_Language();
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
      
      public function showFailDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,this.destroy,"akazosu");
      }
      
      public function destroy() : void
      {
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
