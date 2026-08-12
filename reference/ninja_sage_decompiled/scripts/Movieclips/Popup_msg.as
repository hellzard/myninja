package Movieclips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class Popup_msg extends MovieClip
   {
       
      
      public var txt_msg:TextField;
      
      public var text:String;
      
      public function Popup_msg(param1:String)
      {
         super();
         addFrameScript(13,this.frame14,97,this.frame98);
         this.text = param1;
         this.play();
      }
      
      function frame14() : *
      {
         if(this.text)
         {
            this.txt_msg.text = this.text;
         }
      }
      
      function frame98() : *
      {
         this.stop();
         this.text = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
