package id.ninjasage.features.exam.specialjounin.stage6.chapter2
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_211 extends MovieClip
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
      
      public var storyMC:MovieClip;
      
      public function Mission_211(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_211_Language();
         this.storyMC = param2["storyMC"];
         this.storyMC.gotoAndStop(1);
         this.storyMC.visible = false;
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
         var _loc1_:* = [this.langFile.textArr[7]];
         this.main.showDialogue(_loc1_,this.destroy,"yudai");
      }
      
      public function showFinalDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[5]];
         this.main.showDialogue(_loc1_,this.showFinalDialog1,"vadarnomask");
      }
      
      public function showFinalDialog1() : *
      {
         var _loc1_:* = [this.langFile.textArr[6]];
         this.main.showDialogue(_loc1_,this.finishStageS6C2,"yudai");
      }
      
      public function finishStageS6C2() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("SpecialJouninExam.finishStage",[Character.sessionkey,Character.char_id,22,[]],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.destroy();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function destroy() : void
      {
         this.main.loadVillageAndHUD();
         GF.removeAllChild(this.player_mc);
         GF.removeAllChild(this.map_1);
         GF.removeAllChild(this.panelMC);
         GF.removeAllChild(this.storyMC);
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
