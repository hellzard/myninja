package id.ninjasage.features.exam.chunin.stage5
{
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Mission_59 extends MovieClip
   {
       
      
      public var langFile;
      
      public var main;
      
      public var chunin;
      
      public var loaderSwf:BulkLoader;
      
      public function Mission_59(param1:*)
      {
         super();
         this.main = param1;
         this.loaderSwf = BulkLoader.getLoader("assets");
         this.langFile = new Mission_59_Language();
         this.showDialogue();
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.langFile.textArr[0],this.langFile.textArr[1]];
         this.main.showDialogue(_loc1_,this.showDialogue2,"yudai");
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.langFile.textArr[2]];
         this.main.showDialogue(_loc1_,this.showDialogue3,"shin");
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,this.showDialogue4,"genzu");
      }
      
      public function showDialogue4() : *
      {
         var _loc1_:* = [this.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.showDialogue5,"kojima");
      }
      
      public function showDialogue5() : *
      {
         var _loc1_:* = [this.langFile.textArr[5]];
         this.main.showDialogue(_loc1_,this.showDialogue6,"genzu");
      }
      
      public function showDialogue6() : *
      {
         var _loc1_:* = [this.langFile.textArr[6],this.langFile.textArr[7]];
         this.main.showDialogue(_loc1_,this.showDialogue7,"kojima");
      }
      
      public function showDialogue7() : *
      {
         var _loc1_:* = [this.langFile.textArr[8]];
         this.main.showDialogue(_loc1_,this.showDialogue8,"aniki");
      }
      
      public function showDialogue8() : *
      {
         var _loc1_:* = [this.langFile.textArr[9]];
         this.main.showDialogue(_loc1_,this.showDialogue9,"shin");
      }
      
      public function showDialogue9() : *
      {
         var _loc1_:* = [this.langFile.textArr[10]];
         this.main.showDialogue(_loc1_,this.startBattle,"aniki");
      }
      
      public function startBattle() : *
      {
         this.main.startStage5Battle();
      }
      
      public function showDialogueAfterBattle() : *
      {
         var _loc1_:* = [this.langFile.textArr[11]];
         this.main.showDialogue(_loc1_,this.showDialogueAfterBattle1,"ken");
      }
      
      public function showDialogueAfterBattle1() : *
      {
         var _loc1_:* = [this.langFile.textArr[12]];
         this.main.showDialogue(_loc1_,this.showDialogueAfterBattle2,"shin");
      }
      
      public function showDialogueAfterBattle2() : *
      {
         var _loc1_:* = [this.langFile.textArr[13],this.langFile.textArr[14],this.langFile.textArr[15]];
         this.main.showDialogue(_loc1_,this.showDialogueAfterBattle3,"yudai");
      }
      
      public function showDialogueAfterBattle3() : *
      {
         var _loc1_:* = [this.langFile.textArr[16]];
         this.main.showDialogue(_loc1_,this.showDialogueAfterBattle4,"shin");
      }
      
      public function showDialogueAfterBattle4() : *
      {
         var _loc1_:* = [this.langFile.textArr[17]];
         this.main.showDialogue(_loc1_,this.showTheRankup,"genzu");
      }
      
      public function showTheRankup() : *
      {
         var _loc1_:* = this.loaderSwf.add("mission/mission_59.swf");
         _loc1_.addEventListener(BulkLoader.COMPLETE,this.onChuninCertificateLoaded);
         this.loaderSwf.start();
      }
      
      public function onChuninCertificateLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.chunin = new ChuninCertificate(this.main,param1.target.content,this);
         this.main.loader.addChild(param1.target.content);
      }
      
      public function finishStage5() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("ChuninExam.finishStage",[Character.sessionkey,Character.char_id,5,this.main.stage5_enemies],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            this.main.removeAllChildsFromLoader();
            this.loaderSwf.removeAll();
            this.chunin.destroy();
            this.main.loadVillageAndHUD();
            this.langFile = null;
            this.loaderSwf = null;
            this.chunin = null;
            this.main = null;
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
   }
}
