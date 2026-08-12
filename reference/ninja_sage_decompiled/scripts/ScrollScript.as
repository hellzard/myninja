package
{
   import flash.display.MovieClip;
   
   public class ScrollScript extends MovieClip
   {
       
      
      public var scroll_1:MovieClip;
      
      public var scroll_2:MovieClip;
      
      public var scroll_3:MovieClip;
      
      public var scroll_4:MovieClip;
      
      public var scroll_5:MovieClip;
      
      public function ScrollScript()
      {
         super();
      }
      
      public function updateDisplay(param1:*) : *
      {
         this.scroll_1.gotoAndStop(2);
         this.scroll_2.gotoAndStop(2);
         this.scroll_3.gotoAndStop(2);
         this.scroll_4.gotoAndStop(2);
         this.scroll_5.gotoAndStop(2);
         if(param1 == 1)
         {
            this.scroll_5.gotoAndStop(1);
         }
         else if(param1 == 2)
         {
            this.scroll_4.gotoAndStop(1);
            this.scroll_5.gotoAndStop(1);
         }
         else if(param1 == 3)
         {
            this.scroll_3.gotoAndStop(1);
            this.scroll_4.gotoAndStop(1);
            this.scroll_5.gotoAndStop(1);
         }
         else if(param1 == 4)
         {
            this.scroll_2.gotoAndStop(1);
            this.scroll_3.gotoAndStop(1);
            this.scroll_4.gotoAndStop(1);
            this.scroll_5.gotoAndStop(1);
         }
         else if(param1 == 5)
         {
            this.scroll_1.gotoAndStop(1);
            this.scroll_2.gotoAndStop(1);
            this.scroll_3.gotoAndStop(1);
            this.scroll_4.gotoAndStop(1);
            this.scroll_5.gotoAndStop(1);
         }
      }
   }
}
