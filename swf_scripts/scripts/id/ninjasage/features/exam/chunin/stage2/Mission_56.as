package id.ninjasage.features.exam.chunin.stage2
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_56 extends MovieClip
   {
      
      public var langFile:*;
      
      private var Kenta_dialog_01:Array;
      
      private var Kenta_dialog_02:Array;
      
      private var npcDialog_1:String;
      
      private var npcDialog_2:String;
      
      private var npcDialog_3:String;
      
      private var msg_1:String;
      
      private var msg_2:String;
      
      public const id:String = "msn56";
      
      public const type:String = "map_mission";
      
      public var mapIndexCache:uint;
      
      public var raigaTalked:Boolean = false;
      
      public var shinTalked:Boolean = false;
      
      public var scrollCollected:uint = 0;
      
      public var main:*;
      
      public var map:*;
      
      public var panelMC:*;
      
      public var player_mc:*;
      
      public var map9_enemy_killed:Boolean = false;
      
      public var map5_enemy_killed:Boolean = false;
      
      public var total_scrolls:* = 0;
      
      public var map_1:MovieClip;
      
      public var map_5:MovieClip;
      
      public var map_6:MovieClip;
      
      public var map_9:MovieClip;
      
      public var map_10:MovieClip;
      
      public var classMap1:*;
      
      public var classMap5:*;
      
      public var classMap6:*;
      
      public var classMap9:*;
      
      public var classMap10:*;
      
      public function Mission_56(param1:* = null, param2:* = null)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.map_1 = this.panelMC["Map_1"];
         this.map_5 = this.panelMC["Map_5"];
         this.map_6 = this.panelMC["Map_6"];
         this.map_9 = this.panelMC["Map_9"];
         this.map_10 = this.panelMC["Map_10"];
         this.langFile = new Mission_56_Language();
         this.hideMaps();
         this.initMap();
      }
      
      public function hideMaps() : void
      {
         this.map_1.visible = false;
         this.map_5.visible = false;
         this.map_6.visible = false;
         this.map_9.visible = false;
         this.map_10.visible = false;
      }
      
      public function initMap() : void
      {
         this.classMap1 = new Map_1(this.main,this.map_1,this);
         this.classMap5 = new Map_5(this.main,this.map_5,this);
         this.classMap6 = new Map_6(this.main,this.map_6,this);
         this.classMap9 = new Map_9(this.main,this.map_9,this);
         this.classMap10 = new Map_10(this.main,this.map_10,this);
         this.classMap1.showDialogue();
         this.classMap1.initMap();
      }
      
      public function updateScrolls() : *
      {
         this.map.map_mc.scrollTxt.text = "Scrolls " + this.total_scrolls + " / 2";
      }
      
      public function getMap9Enemies(param1:*) : *
      {
         return this.main.getEnemy("ene_31",param1);
      }
      
      public function getMap5Enemies(param1:*) : *
      {
         return this.main.getEnemy("ene_36",param1);
      }
      
      public function destroy() : void
      {
         this.main.loadVillageAndHUD();
         GF.removeAllChild(this.player_mc);
         GF.removeAllChild(this.map_1);
         GF.removeAllChild(this.map_5);
         GF.removeAllChild(this.map_6);
         GF.removeAllChild(this.map_9);
         GF.removeAllChild(this.map_10);
         GF.removeAllChild(this.panelMC);
         this.main = null;
         this.classMap1 = null;
         this.classMap5 = null;
         this.classMap6 = null;
         this.classMap9 = null;
         this.classMap10 = null;
         this.map_1 = null;
         this.map_5 = null;
         this.map_6 = null;
         this.map_9 = null;
         this.map_10 = null;
         this.panelMC = null;
         this.player_mc = null;
         this.map = null;
         this.langFile = null;
      }
   }
}

