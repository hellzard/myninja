package id.ninjasage.features.exam.jounin.stage5
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_136 extends MovieClip
   {
      
      public var langFile:*;
      
      public var main:*;
      
      public var map:*;
      
      public var player_mc:*;
      
      public var cert_mc:MovieClip;
      
      public var cert:*;
      
      public var map_1:MovieClip;
      
      public var classMap1:*;
      
      public function Mission_136(param1:* = null, param2:* = null)
      {
         super();
         this.main = param1;
         this.cert_mc = param2.panelMC;
         this.cert_mc.gotoAndStop(1);
         this.cert_mc.visible = false;
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_136_Language();
         this.map_1 = param2["Map_1"];
         param2["BattleBG"].visible = false;
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
         var _loc1_:* = [this.langFile.textArr[9]];
         this.main.showDialogue(_loc1_,this.showFailDialog2,"mudo");
      }
      
      public function showFailDialog2() : *
      {
         var _loc1_:* = [this.langFile.textArr[9]];
         this.main.showDialogue(_loc1_,this.destroy,"kyotaro");
      }
      
      public function finishExam() : *
      {
         var _loc1_:* = [this.langFile.textArr[11]];
         this.main.showDialogue(_loc1_,this.fe1,"mudo");
      }
      
      public function fe1() : *
      {
         var _loc1_:* = [this.langFile.textArr[12]];
         this.main.showDialogue(_loc1_,this.fe2,"kyotaro");
      }
      
      public function fe2() : *
      {
         var _loc1_:* = [this.langFile.textArr[13]];
         this.main.showDialogue(_loc1_,this.fe3,"mudo");
      }
      
      public function fe3() : *
      {
         var _loc1_:* = [this.langFile.textArr[14]];
         this.main.showDialogue(_loc1_,this.fe4,"shin");
      }
      
      public function fe4() : *
      {
         var _loc1_:* = [this.langFile.textArr[15]];
         this.main.showDialogue(_loc1_,this.fe5,"genzu");
      }
      
      public function fe5() : *
      {
         var _loc1_:* = [this.langFile.textArr[16],this.langFile.textArr[17]];
         this.main.showDialogue(_loc1_,this.fe6,"yudai");
      }
      
      public function fe6() : *
      {
         var _loc1_:* = [this.langFile.textArr[18]];
         this.main.showDialogue(_loc1_,this.fe7,"kazekage");
      }
      
      public function fe7() : *
      {
         var _loc1_:* = [this.langFile.textArr[19],this.langFile.textArr[20]];
         this.main.showDialogue(_loc1_,this.fe8,"mizukage");
      }
      
      public function fe8() : *
      {
         var _loc1_:* = [this.langFile.textArr[21]];
         this.main.showDialogue(_loc1_,this.fe9,"tsuchikage");
      }
      
      public function fe9() : *
      {
         var _loc1_:* = [this.langFile.textArr[22]];
         this.main.showDialogue(_loc1_,this.showDone,"yudai");
      }
      
      public function showDone() : *
      {
         this.cert = new JouninCertificate(this.main,this.cert_mc,this);
         this.cert_mc.play();
         this.map_1.visible = false;
         this.cert_mc.visible = true;
      }
      
      public function sendAmfFinish() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("JouninExam.finishStage",[Character.sessionkey,Character.char_id,10,this.main.stage5_enemies],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function dialogAfterBattle1() : *
      {
         var _loc1_:* = [this.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.nextDialogAB1,"mudo");
      }
      
      public function nextDialogAB1() : *
      {
         var _loc1_:* = [this.langFile.textArr[5]];
         this.main.showDialogue(_loc1_,this.nextDialogAB2,"kyotaro");
      }
      
      public function nextDialogAB2() : *
      {
         var _loc1_:* = [this.langFile.textArr[6]];
         this.main.showDialogue(_loc1_,this.nextDialogAB3,"mudo");
      }
      
      public function nextDialogAB3() : *
      {
         var _loc1_:* = [this.langFile.textArr[7]];
         this.main.showDialogue(_loc1_,this.nextDialogAB4,"kyotaro");
      }
      
      public function nextDialogAB4() : *
      {
         var _loc1_:* = [this.langFile.textArr[8]];
         this.main.showDialogue(_loc1_,this.startStage,"mudo");
      }
      
      public function startStage() : *
      {
         this.main.continueStage5Jounin(2);
      }
      
      public function destroy() : *
      {
         this.main.removeAllChildsFromLoader();
         this.main.loadVillageAndHUD();
         this.main = null;
         GF.removeAllChild(this.player_mc);
         this.player_mc = null;
         GF.removeAllChild(this.map);
         this.map = null;
         GF.removeAllChild(this.cert_mc);
         this.cert_mc = null;
         this.langFile = null;
         this.classMap1 = null;
      }
   }
}

