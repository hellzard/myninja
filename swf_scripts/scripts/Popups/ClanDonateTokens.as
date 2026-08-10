package Popups
{
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7040")]
   public class ClanDonateTokens extends MovieClip
   {
      
      public var amountTxt:TextField;
      
      public var btn_close:SimpleButton;
      
      public var btn_donate:SimpleButton;
      
      public var char_tokens:TextField;
      
      public var clan_tokens:TextField;
      
      public var main:*;
      
      public var clan_village:*;
      
      public var clan_hall:*;
      
      internal var total:* = 0;
      
      public function ClanDonateTokens(param1:*, param2:*, param3:*)
      {
         super();
         this.main = param1;
         this.clan_village = param2;
         this.clan_hall = param3;
         this.clan_tokens.text = param3.clan_data.tokens;
         this.char_tokens.text = String(Character.account_tokens);
         this.btn_donate.addEventListener(MouseEvent.CLICK,this.onDonate);
         this.btn_close.addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      public function onClose(param1:MouseEvent = null) : *
      {
         parent.removeChild(this);
         this.clan_hall.displayTab("general");
         this.destroy();
      }
      
      public function onDonate(param1:MouseEvent) : *
      {
         this.total = int(this.amountTxt.text);
         if(this.total < 1)
         {
            this.main.getNotice("Amount need to be more than 0");
            return;
         }
         this.main.loading(true);
         Clan.instance.donateTokens(this.total,this.onDonateTokens);
      }
      
      public function onDonateTokens(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("unknown error");
            return;
         }
         if(this.clan_hall != null)
         {
            Character.account_tokens = Number(Character.account_tokens) - this.total;
            this.char_tokens.text = String(Character.account_tokens);
            this.main.getNotice("Tokens has been donated!");
            this.clan_hall.refreshData();
            this.onClose();
         }
      }
      
      public function destroy() : *
      {
         this.main = null;
         this.clan_village = null;
         this.clan_hall = null;
         this.btn_donate.removeEventListener(MouseEvent.CLICK,this.onDonate);
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.onClose);
      }
   }
}

