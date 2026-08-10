package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7797")]
   public dynamic class skillToolTip extends MovieClip
   {
      
      public var cooldownTxt:TextField;
      
      public var currskillTxt:TextField;
      
      public var skillNameTxt:TextField;
      
      public var iconMC:MovieClip;
      
      public var classMC:MovieClip;
      
      public var healTxt:TextField;
      
      public var healIcon:MovieClip;
      
      public var iconCooldown:MovieClip;
      
      public var damageIcon:MovieClip;
      
      public function skillToolTip()
      {
         super();
         addFrameScript(1,this.frame2);
      }
      
      internal function frame2() : *
      {
         this.stop();
      }
   }
}

