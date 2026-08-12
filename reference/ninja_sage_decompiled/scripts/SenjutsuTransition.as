package
{
   import flash.display.MovieClip;
   
   public class SenjutsuTransition extends MovieClip
   {
       
      
      public function SenjutsuTransition()
      {
         super();
         addFrameScript(0,this.frame1,30,this.frame31);
      }
      
      function frame1() : *
      {
         this.stop();
      }
      
      function frame31() : *
      {
         this.gotoAndStop(1);
      }
   }
}
