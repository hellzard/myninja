package id.ninjasage.features.exam.chunin.stage4
{
   import Storage.Character;
   import flash.display.MovieClip;
   
   public class Mission_58 extends MovieClip
   {
      
      private var langFile:*;
      
      private var main:*;
      
      public function Mission_58(param1:*)
      {
         super();
         this.main = param1;
         this.langFile = new Mission_58_Language();
         this.showDialogue();
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.langFile.textArr[0],this.langFile.textArr[1],this.langFile.textArr[2]];
         this.main.showDialogue(_loc1_,this.showDialogue2,"ken");
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,this.showDialogue3,"kojima");
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.showDialogue4,"yudai");
      }
      
      public function showDialogue4() : *
      {
         var _loc1_:* = [this.langFile.textArr[5],this.langFile.textArr[6]];
         this.main.showDialogue(_loc1_,this.showDialogue5,"kojima");
      }
      
      public function showDialogue5() : *
      {
         var _loc1_:* = [this.langFile.textArr[7],this.langFile.textArr[8],this.langFile.textArr[9]];
         this.main.showDialogue(_loc1_,this.showDialogue6,"aniki");
      }
      
      public function showDialogue6() : *
      {
         var _loc1_:* = [this.langFile.textArr[10]];
         this.main.showDialogue(_loc1_,this.showDialogue7,"ken");
      }
      
      public function showDialogue7() : *
      {
         var _loc1_:* = [this.langFile.textArr[11]];
         this.main.showDialogue(_loc1_,this.showDialogue8,"kojima");
      }
      
      public function showDialogue8() : *
      {
         var _loc1_:* = [this.langFile.textArr[12]];
         this.main.showDialogue(_loc1_,this.showDialogue9,"yudai");
      }
      
      public function showDialogue9() : *
      {
         var _loc1_:* = [this.langFile.textArr[13]];
         this.main.showDialogue(_loc1_,this.showDialogue10,"kara");
      }
      
      public function showDialogue10() : *
      {
         var _loc1_:* = [this.langFile.textArr[14]];
         this.main.showDialogue(_loc1_,this.showDialogue11,"shin");
      }
      
      public function showDialogue11() : *
      {
         var _loc1_:* = [this.langFile.textArr[15]];
         this.main.showDialogue(_loc1_,this.startBattle,"genzu");
      }
      
      public function startBattle() : *
      {
         this.main.startStage4Battle();
      }
      
      public function showFinalDialogue() : *
      {
         var _loc1_:* = [this.langFile.textArr[17]];
         this.main.showDialogue(_loc1_,this.finishStage4,"yudai");
      }
      
      public function finishStage4() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("ChuninExam.finishStage",[Character.sessionkey,Character.char_id,4,this.main.stage4_enemies],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            this.main.removeAllChildsFromLoader();
            this.main.loadVillageAndHUD();
            this.langFile = null;
            this.main = null;
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
   }
}

