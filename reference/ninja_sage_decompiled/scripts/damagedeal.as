package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class damagedeal extends MovieClip
   {
       
      
      public var txt:TextField;
      
      public function damagedeal()
      {
         super();
         addFrameScript(40,this.frame26);
      }
      
      public function frame26() : *
      {
         this.stop();
      }
   }
}
