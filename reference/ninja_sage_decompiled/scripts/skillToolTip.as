package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
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
      
      function frame2() : *
      {
         this.stop();
      }
   }
}
