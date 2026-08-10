package NinjaSage_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8528")]
   public dynamic class battlestats_1230 extends MovieClip
   {
      
      public var bar_win_rate_attack:MovieClip;
      
      public var lbl_battles:TextField;
      
      public var lbl_winrate:TextField;
      
      public var lbl_wins:TextField;
      
      public var totalMatchesTxt:TextField;
      
      public var winRateTxt:TextField;
      
      public var winTxt:TextField;
      
      public function battlestats_1230()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

