package Panels
{
   import Storage.Character;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2207")]
   public class SplashScreen extends MovieClip
   {
      
      public var progressBar:MovieClip;
      
      public var logo:MovieClip;
      
      public var bg:MovieClip;
      
      public var versionTxt:TextField;
      
      private var maxScale:* = 0;
      
      private var percentagePerTask:* = 1;
      
      private var tempVal:* = 0;
      
      public function SplashScreen(param1:* = null)
      {
         super();
         if(this.bg.totalFrames > 1)
         {
            this.bg.gotoAndStop(NumberUtil.randomInt(1,this.bg.totalFrames));
         }
         this.maxScale = this.progressBar.loadingIcon.progressbarNow.scaleX;
         this.progressBar.loadingIcon.progressbarNow.scaleX = 0;
         this.progressBar.titleTxt.text = "Loading...";
         this.versionTxt.text = Character.build_num;
      }
      
      public function setPercentagePerTask(param1:*) : *
      {
         this.percentagePerTask = this.calculateTask(1,param1);
      }
      
      public function getPercentagePerTask() : *
      {
         return this.percentagePerTask;
      }
      
      public function status(param1:String) : *
      {
         this.progressBar.titleTxt.text = param1;
      }
      
      public function increase(param1:* = 1) : *
      {
         param1 = Math.min(this.maxScale,Math.max(0,param1));
         this.progressBar.loadingIcon.progressbarNow.scaleX = param1 * this.maxScale;
      }
      
      public function startSubProgress() : *
      {
         this.tempVal = this.progressBar.loadingIcon.progressbarNow.scaleX;
         this.progressBar.loadingIcon.progressbarNow.scaleX = 0;
      }
      
      public function reset() : *
      {
         this.progressBar.loadingIcon.progressbarNow.scaleX = this.tempVal;
      }
      
      public function calculateTask(param1:*, param2:*) : *
      {
         var _loc3_:* = 100 / param2;
         return param1 * _loc3_ / 100;
      }
   }
}

