package Popups
{
   import Managers.PreviewManager;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol9142")]
   public class PreviewSkill extends MovieClip
   {
      
      public var btn_close:SimpleButton;
      
      public var btn_replay:SimpleButton;
      
      public var skillMc:MovieClip;
      
      private var main:*;
      
      private var skillId:String;
      
      private var previewMC:PreviewManager;
      
      private var loaderSwf:BulkLoader;
      
      private var escapeKey:EscapeKeyManager;
      
      public function PreviewSkill(param1:*, param2:String)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePreview);
         this.main = param1;
         this.skillId = param2;
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.handleSkillPreview(this.skillId);
      }
      
      private function handleSkillPreview(param1:String) : void
      {
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePreview);
         this.btn_replay.addEventListener(MouseEvent.CLICK,this.handleReplay);
         this.loadSkillAndPreview();
      }
      
      private function loadSkillAndPreview() : void
      {
         var _loc1_:* = "skills/" + this.skillId + ".swf";
         var _loc2_:* = this.loaderSwf.add(_loc1_);
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.completePreview);
         this.loaderSwf.start();
      }
      
      private function completePreview(param1:*) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = SkillLibrary.getSkillInfo(this.skillId);
         var _loc4_:MovieClip = param1.target.content[this.skillId];
         this.previewMC = new PreviewManager(this.main,_loc4_,_loc3_);
         this.skillMc.scaleX = 1.6;
         this.skillMc.scaleY = 1.6;
         this.skillMc.addChild(this.previewMC.preview_mc);
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function closePreview(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.removeAllChild(this.skillMc);
         if(this.previewMC)
         {
            this.previewMC.destroy();
         }
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePreview);
         this.btn_replay.removeEventListener(MouseEvent.CLICK,this.handleReplay);
         this.main = null;
         this.skillId = null;
         GF.removeAllChild(this);
      }
   }
}

