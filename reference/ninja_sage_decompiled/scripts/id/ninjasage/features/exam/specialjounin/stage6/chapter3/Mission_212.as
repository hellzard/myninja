package id.ninjasage.features.exam.specialjounin.stage6.chapter3
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_212 extends MovieClip
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
      
      public var storyMC1:MovieClip;
      
      public var storyMC2:MovieClip;
      
      public function Mission_212(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_212_Language();
         param2.stopAllMovieClips();
         param2.gotoAndStop(1);
         this.storyMC1 = param2["storyMC1"];
         this.storyMC1.gotoAndStop(1);
         this.storyMC1.visible = false;
         this.storyMC2 = param2["storyMC2"];
         this.storyMC2.gotoAndStop(1);
         this.storyMC2.visible = false;
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
         var _loc1_:* = [this.langFile.textArr[13]];
         this.main.showDialogue(_loc1_,this.destroy,"yudai");
      }
      
      public function showFinalDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[10]];
         this.main.showDialogue(_loc1_,this.showFinalDialog1,"yudai");
      }
      
      public function showFinalDialog1() : *
      {
         var _loc1_:* = [this.langFile.textArr[11]];
         this.main.showDialogue(_loc1_,this.showStory,"vadarnomask");
      }
      
      public function showWinDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[12]];
         this.main.showDialogue(_loc1_,this.finishStageS6C3,"yudai");
      }
      
      public function finishStageS6C3() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("SpecialJouninExam.finishStage",[Character.sessionkey,Character.char_id,23,[]],this.onFinishStageRes);
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
      
      public function showStory() : *
      {
         this.storyMC2.visible = true;
         this.storyMC2.gotoAndPlay(1);
         this.storyMC2.addFrameScript(489,this.frame490);
      }
      
      public function frame490() : *
      {
         this.storyMC2.stop();
         this.storyMC2.visible = false;
         this.showWinDialog();
      }
      
      public function destroy() : void
      {
         this.main.loadVillageAndHUD();
         GF.removeAllChild(this.player_mc);
         GF.removeAllChild(this.map_1);
         GF.removeAllChild(this.panelMC);
         GF.removeAllChild(this.storyMC1);
         GF.removeAllChild(this.storyMC2);
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
