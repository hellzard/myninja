package id.ninjasage.features.exam.jounin.stage5
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class JouninCertificate extends MovieClip
   {
       
      
      public var clickableMask:MovieClip;
      
      public var card:MovieClip;
      
      public var headHolder:MovieClip;
      
      public var rankTxt:TextField;
      
      public var nameTxt:TextField;
      
      public var head:MovieClip;
      
      public var jounin_emblem:MovieClip;
      
      public var main;
      
      public var panelMC;
      
      public var _parent;
      
      public function JouninCertificate(param1:*, param2:*, param3:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2;
         this._parent = param3;
         this.panelMC.addFrameScript(79,this.frame80,102,this.frame103);
      }
      
      public function finishThis(param1:MouseEvent) : *
      {
         this.panelMC.removeEventListener(MouseEvent.CLICK,this.finishThis);
         this._parent.sendAmfFinish();
         GF.removeAllChild(this);
      }
      
      function frame80() : *
      {
         this.panelMC["nameTxt"].text = "Name: " + Character.character_name;
         this.panelMC["rankTxt"].text = "Rank: Tensai Jounin";
         this.panelMC["head"] = this.main.getPlayerHead();
         this.panelMC["head"].scaleX *= 3;
         this.panelMC["head"].scaleY *= 3;
         this.panelMC["headHolder"].addChild(this.panelMC["head"]);
      }
      
      function frame103() : *
      {
         this.panelMC.stop();
         this.panelMC.addEventListener(MouseEvent.CLICK,this.finishThis);
      }
   }
}
