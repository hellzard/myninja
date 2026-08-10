package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7214")]
   public class healing extends MovieClip
   {
      
      public var txt:TextField;
      
      public function healing()
      {
         super();
         addFrameScript(40,this.frame41);
      }
      
      public function frame41() : *
      {
         this.stop();
      }
   }
}

