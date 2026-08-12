package id.ninjasage.features.exam.chunin.stage3
{
   import Storage.Character;
   import flash.display.MovieClip;
   
   public class Mission_57 extends MovieClip
   {
       
      
      private var langFile;
      
      public var current_battle = 0;
      
      public var enemies:Array;
      
      public var main;
      
      public function Mission_57(param1:*)
      {
         this.enemies = ["ene_65","ene_63","ene_64"];
         super();
         this.main = param1;
         this.langFile = new Mission_57_Language();
         this.showDialogue();
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.langFile.textArr[0],this.langFile.textArr[1],this.langFile.textArr[2],this.langFile.textArr[3],this.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.startBattle1,"notshin1");
      }
      
      public function showDialogue2() : *
      {
         var _loc1_:* = [this.langFile.textArr[5]];
         this.main.showDialogue(_loc1_,this.startBattle2,"notshin1");
      }
      
      public function showDialogue3() : *
      {
         var _loc1_:* = [this.langFile.textArr[6],this.langFile.textArr[7]];
         this.main.showDialogue(_loc1_,this.startBattle3,"notshin1");
      }
      
      public function showDialogue4() : *
      {
         var _loc1_:* = [this.langFile.textArr[8],this.langFile.textArr[9],this.langFile.textArr[10]];
         this.main.showDialogue(_loc1_,this.finishStage3,"notshin1");
      }
      
      public function startBattle1() : *
      {
         this.main.startStage3Battle(0);
      }
      
      public function startBattle2() : *
      {
         this.main.startStage3Battle(1);
      }
      
      public function startBattle3() : *
      {
         this.main.startStage3Battle(2);
      }
      
      public function finishStage3() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("ChuninExam.finishStage",[Character.sessionkey,Character.char_id,3,this.current_battle,this.enemies],this.onFinishStageRes);
      }
      
      public function onFinishStageRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            this.main.removeAllChildsFromLoader();
            this.main.loadVillageAndHUD();
            this.langFile = null;
            this.enemies = null;
            this.main = null;
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
   }
}
