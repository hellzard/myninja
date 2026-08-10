package Popups
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.Clan;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3737")]
   public class ClanIncreaseMembers extends MovieClip
   {
      
      public var panel:MovieClip;
      
      public var clan_village:*;
      
      public var clan_hall:*;
      
      public var main:*;
      
      private var max_members:* = 0;
      
      private var total_max_members:* = 45;
      
      private var token_req:* = 0;
      
      internal var total:* = 0;
      
      public function ClanIncreaseMembers(param1:*, param2:*, param3:*)
      {
         super();
         this.width = 2100;
         this.height = 1150;
         this.x = -50;
         this.y = -50;
         this.main = param1;
         this.clan_village = param2;
         this.clan_hall = param3;
         this.max_members = param3.clan_data.max_members;
         this.setData();
      }
      
      public function setData() : *
      {
         this.panel.clan_tokens.text = this.clan_hall.clan_data.tokens;
         var _loc1_:int = Math.min(Math.max(this.total_max_members - this.max_members,0),10);
         var _loc2_:* = this.max_members + _loc1_;
         var _loc3_:* = _loc2_ * 10;
         this.panel.txt_member.text = _loc2_;
         this.token_req = _loc3_;
         this.panel.txt_required.text = this.token_req;
         this.panel.btn_close.addEventListener(MouseEvent.CLICK,this.onClose);
         this.panel.btn_increase.addEventListener(MouseEvent.CLICK,this.increaseMembers);
         if(this.max_members >= this.total_max_members)
         {
            this.panel.btn_increase.removeEventListener(MouseEvent.CLICK,this.increaseMembers);
            this.panel.btn_increase.visible = false;
            this.panel.txt_member.text = "Max";
            this.panel.txt_required.text = "0";
         }
      }
      
      public function onClose(param1:MouseEvent = null) : *
      {
         parent.removeChild(this);
         this.clan_hall.displayTab("general");
         this.destroy();
      }
      
      internal function increaseMembers(param1:MouseEvent = null) : *
      {
         this.main.loading(true);
         Clan.instance.increaseMaxMembers(this.getDataResponse);
      }
      
      public function getDataResponse(param1:*, param2:* = null) : *
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
         if(param1 != null && Boolean(param1.hasOwnProperty("max_members")))
         {
            this.max_members = param1.max_members;
            this.clan_hall.clan_data.tokens -= this.token_req;
            this.main.giveMessage("You\'ve successfuly upgrade max member to " + this.panel.txt_member.text);
            this.setData();
         }
      }
      
      public function destroy() : *
      {
         this.main = null;
         this.clan_village = null;
         this.clan_hall = null;
         this.panel.btn_close.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.panel.btn_increase.removeEventListener(MouseEvent.CLICK,this.increaseMembers);
      }
   }
}

