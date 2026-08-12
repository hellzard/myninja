package id.ninjasage.features.exam.jounin.stage3
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Mission_134 extends MovieClip
   {
       
      
      public var langFile;
      
      public var mapIndexCache:uint;
      
      public var main;
      
      public var kekkaiMC;
      
      public var kekkaiGame;
      
      public var panelMC;
      
      public var player_mc;
      
      public var total_seals = 0;
      
      public var map_1:MovieClip;
      
      public var map_3:MovieClip;
      
      public var map_5:MovieClip;
      
      public var map_7:MovieClip;
      
      public var map_9:MovieClip;
      
      public var classMap1;
      
      public var classMap3;
      
      public var classMap5;
      
      public var classMap7;
      
      public var classMap9;
      
      public var map;
      
      public function Mission_134(param1:* = null, param2:* = null)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.player_mc = this.main.createPlayerMc();
         this.langFile = new Mission_134_Language();
         this.kekkaiMC = this.panelMC["Kekkai"];
         this.kekkaiGame = new Mission_134_NM();
         this.map_1 = this.panelMC["Map_1"];
         this.map_3 = this.panelMC["Map_3"];
         this.map_5 = this.panelMC["Map_5"];
         this.map_7 = this.panelMC["Map_7"];
         this.map_9 = this.panelMC["Map_9"];
         this.hideMaps();
         this.initMap();
      }
      
      public function hideMaps() : void
      {
         this.kekkaiMC.visible = false;
         this.map_1.visible = false;
         this.map_3.visible = false;
         this.map_5.visible = false;
         this.map_7.visible = false;
         this.map_9.visible = false;
      }
      
      public function initMap() : void
      {
         this.classMap1 = new Map_1(this.main,this.map_1,this);
         this.classMap3 = new Map_3(this.main,this.map_3,this);
         this.classMap5 = new Map_5(this.main,this.map_5,this);
         this.classMap7 = new Map_7(this.main,this.map_7,this);
         this.classMap9 = new Map_9(this.main,this.map_9,this);
         this.showDialogue();
         this.map = this.classMap1;
         this.classMap1.initMap();
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.langFile.textArr[0]];
         this.main.showDialogue(_loc1_,this.showDialogue2,"shin");
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.langFile.textArr[1]];
         this.main.showDialogue(_loc1_,this.showDialogue3,"shin");
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.langFile.textArr[2]];
         this.main.showDialogue(_loc1_,this.showDialogue4,"shin");
      }
      
      public function showDialogue4() : *
      {
         var _loc1_:* = [this.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,null,"shin");
      }
      
      public function updateSeals() : *
      {
         this.map.map_mc.scrollTxt.text = "Seals " + this.total_seals + " / 4";
      }
      
      public function incrementSeal() : *
      {
         this.total_seals += 1;
         if(this.total_seals >= 4)
         {
            this.showDialoguePass();
         }
         this.updateSeals();
      }
      
      public function showDialoguePass() : *
      {
         var _loc1_:* = [this.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.finishStage8,"shin");
      }
      
      public function finishStage8() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("JouninExam.finishStage",[Character.sessionkey,Character.char_id,8,this.total_seals],this.onFinishStageRes);
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
      
      public function destroy() : *
      {
         this.main.loadVillageAndHUD();
         GF.removeAllChild(this.player_mc);
         GF.removeAllChild(this.map_1);
         GF.removeAllChild(this.map_3);
         GF.removeAllChild(this.map_5);
         GF.removeAllChild(this.map_7);
         GF.removeAllChild(this.map_9);
         GF.removeAllChild(this.panelMC);
         this.main = null;
         this.classMap1 = null;
         this.classMap3 = null;
         this.classMap5 = null;
         this.classMap7 = null;
         this.classMap9 = null;
         this.map_1 = null;
         this.map_3 = null;
         this.map_5 = null;
         this.map_7 = null;
         this.map_9 = null;
         this.panelMC = null;
         this.player_mc = null;
         this.langFile = null;
         this.map = null;
      }
   }
}
