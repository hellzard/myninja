package Popups
{
   import Managers.StatManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5691")]
   public class LevelUp extends MovieClip
   {
      
      public var btn_confirm:SimpleButton;
      
      public var txt_agility:TextField;
      
      public var txt_cp:TextField;
      
      public var txt_hp:TextField;
      
      public var txt_lvl:TextField;
      
      public var stat_manager:StatManager = new StatManager();
      
      public function LevelUp()
      {
         super();
         this.width = 2100;
         this.height = 1080;
         this.x = -100;
         this.y = 0;
         this.play();
         addFrameScript(0,this.frame1,56,this.frame57,72,this.frame73,94,this.frame95,117,this.frame118,134,this.frame135);
      }
      
      internal function frame1() : void
      {
         this.play();
      }
      
      internal function frame57() : void
      {
         this.txt_lvl.text = Character.character_lvl;
      }
      
      internal function frame73() : void
      {
         this.txt_hp.text = this.stat_manager.calculate_stats("hp");
      }
      
      internal function frame95() : void
      {
         this.txt_cp.text = this.stat_manager.calculate_stats("cp");
      }
      
      internal function frame118() : void
      {
         this.txt_agility.text = this.stat_manager.calculate_stats("agility");
      }
      
      internal function frame135() : void
      {
         this.stop();
         this.btn_confirm.addEventListener(MouseEvent.CLICK,this.closePop);
      }
      
      internal function closePop(param1:MouseEvent) : void
      {
         addFrameScript(0,null,56,null,72,null,94,null,117,null,134,null);
         this.btn_confirm.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.stat_manager = null;
         GF.removeAllChild(this);
         parent.removeChild(this);
      }
   }
}

