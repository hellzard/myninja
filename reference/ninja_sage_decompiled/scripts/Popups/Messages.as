package Popups
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class Messages extends MovieClip
   {
       
      
      public var msgTxt:TextField;
      
      public var txt:String;
      
      public function Messages(param1:String)
      {
         addFrameScript(15,this.frame16,48,this.frame49);
         super();
         this.txt = param1;
         this.addFrameScript(15,this.showMessageNow);
         this.addFrameScript(48,this.deleteMsg);
      }
      
      public function deleteMsg() : *
      {
         this.stop();
         this.txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         else
         {
            this.visible = false;
         }
      }
      
      public function showMessageNow() : *
      {
         if(this.txt != null)
         {
            this.msgTxt.text = this.txt;
         }
      }
      
      function frame16() : *
      {
         if(this.txt != null)
         {
            this.msgTxt.text = this.txt;
         }
      }
      
      function frame49() : *
      {
         this.stop();
         this.txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         else
         {
            this.visible = false;
         }
      }
   }
}
