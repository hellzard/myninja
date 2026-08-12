package id.ninjasage.features.exam.jounin.stage4
{
   import Storage.Character;
   import flash.display.MovieClip;
   
   public class Mission_135 extends MovieClip
   {
       
      
      private var langFile;
      
      public var main;
      
      public function Mission_135(param1:*)
      {
         super();
         this.main = param1;
         this.langFile = new Mission_135_Language();
         this.showDialogue();
      }
      
      public function showDialogue() : *
      {
         var _loc1_:* = [this.langFile.textArr[0],this.langFile.textArr[1],this.langFile.textArr[2],this.langFile.textArr[3]];
         this.main.showDialogue(_loc1_,this.main.startJouninStage4,"chiyo");
      }
      
      public function showSuccessDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[4]];
         this.main.showDialogue(_loc1_,this.sendAmf,"chiyo");
      }
      
      public function sendAmf() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("JouninExam.finishStage",[Character.sessionkey,Character.char_id,9,this.main.stage5_enemies],this.onFinishStageRes);
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
      
      public function showFailDialog() : *
      {
         var _loc1_:* = [this.langFile.textArr[5]];
         this.main.showDialogue(_loc1_,this.destroy,"chiyo");
      }
      
      public function destroy() : *
      {
         this.main.removeAllChildsFromLoader();
         this.main.loadVillageAndHUD();
         this.main = null;
         this.langFile = null;
      }
   }
}
