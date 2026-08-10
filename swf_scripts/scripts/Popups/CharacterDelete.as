package Popups
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7139")]
   public class CharacterDelete extends MovieClip
   {
      
      public var bg:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_confirm:SimpleButton;
      
      public var txt:TextField;
      
      public var txt_pass:TextField;
      
      public var main:*;
      
      public function CharacterDelete(param1:*)
      {
         super();
         this.width = 2100;
         this.height = 1150;
         this.x = -20;
         this.y = 0;
         this.main = param1;
         this.getBasicData();
      }
      
      internal function getBasicData() : void
      {
         this.txt.text = "Confirm deleting " + Character.character_name + " ?";
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePop);
         this.bg.addEventListener(MouseEvent.CLICK,this.closePop);
         this.btn_confirm.addEventListener(MouseEvent.CLICK,this.deleteCharacter);
      }
      
      internal function deleteCharacter(param1:MouseEvent) : void
      {
         if(this.txt_pass.text == "")
         {
            this.main.showMessage("Please enter a password");
            return;
         }
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.mRiNm3xCrQD4",[Character.char_ids[Character.selected_char],Character.sessionkey,Character.account_username,this.txt_pass.text],this.delResponse);
      }
      
      internal function delResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.loadPanel("Managers.LoginManager");
            this.killEverything();
         }
         else if(param1.status > 1)
         {
            if(param1.hasOwnProperty("result"))
            {
               this.main.giveMessage(param1.result);
            }
            this.killEverything();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      internal function killEverything() : void
      {
         this.btn_confirm.removeEventListener(MouseEvent.CLICK,this.deleteCharacter);
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.bg.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.main = null;
         GF.removeAllChild(this);
      }
      
      internal function closePop(param1:MouseEvent) : void
      {
         this.killEverything();
      }
   }
}

