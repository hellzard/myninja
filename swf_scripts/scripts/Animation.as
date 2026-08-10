package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4867")]
   public class Animation extends MovieClip
   {
      
      public var battlemanager:*;
      
      public var is_start:Boolean = false;
      
      public function Animation(param1:*, param2:Boolean = true)
      {
         addFrameScript(17,this.frame18);
         super();
         this.is_start = param2;
         this.battlemanager = param1;
         addFrameScript(17,this.deleteThis);
      }
      
      public function deleteThis() : *
      {
         this.stop();
         if(this.is_start)
         {
            this.battlemanager.startBattle();
         }
         else
         {
            this.battlemanager._main.loader.removeChild(this);
            this.destroy();
         }
      }
      
      public function destroy() : *
      {
         this.battlemanager = null;
         this.is_start = false;
      }
      
      internal function frame18() : *
      {
         this.stop();
         if(this.is_start)
         {
            this.battlemanager.startBattle();
         }
         else
         {
            this.battlemanager._main.loader.removeChild(this);
            this.destroy();
         }
      }
   }
}

