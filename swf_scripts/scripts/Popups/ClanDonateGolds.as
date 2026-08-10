package Popups
{
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7048")]
   public class ClanDonateGolds extends MovieClip
   {
      
      public var amountTxt:TextField;
      
      public var btn_close:SimpleButton;
      
      public var btn_donate:SimpleButton;
      
      public var char_golds:TextField;
      
      public var clan_golds:TextField;
      
      public var main:*;
      
      public var clan_village:*;
      
      public var clan_hall:*;
      
      internal var total:* = 0;
      
      public function ClanDonateGolds(param1:*, param2:*, param3:*)
      {
         super();
         this.main = param1;
         this.clan_village = param2;
         this.clan_hall = param3;
         this.clan_golds.text = param3.clan_data.golds;
         this.char_golds.text = Character.character_gold;
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
         Clan.instance.donateGolds(this.total,this.onDonateGolds);
      }
      
      public function onDonateGolds(param1:*, param2:* = null) : *
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
            Character.character_gold = String(Number(Character.character_gold) - this.total);
            this.main.getNotice("Golds has been donated!");
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

