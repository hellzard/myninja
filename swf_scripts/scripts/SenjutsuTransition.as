package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6354")]
   public class SenjutsuTransition extends MovieClip
   {
      
      public function SenjutsuTransition()
      {
         super();
         addFrameScript(0,this.frame1,30,this.frame31);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame31() : *
      {
         this.gotoAndStop(1);
      }
   }
}

