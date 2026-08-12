package Popups
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   
   public class ClanUpgrade extends MovieClip
   {
       
      
      public var bmc:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_upgrade:SimpleButton;
      
      public var clvltxt:TextField;
      
      public var curr_desc:TextField;
      
      public var curr_level:TextField;
      
      public var mc:MovieClip;
      
      public var next_desc:TextField;
      
      public var next_level:TextField;
      
      public var nmc:MovieClip;
      
      public var nxtlvl:TextField;
      
      public var nxtmcc:MovieClip;
      
      public var price:TextField;
      
      public var price_type:MovieClip;
      
      public var upgtxt:TextField;
      
      public var main;
      
      public var clan_village;
      
      public var upgrade_info:Array;
      
      public var pricing:Array;
      
      public var upgrading_name = "";
      
      public var totalprice = 0;
      
      public function ClanUpgrade(param1:*, param2:*)
      {
         this.upgrade_info = [];
         this.pricing = [1000000,1000000,1000000,4000];
         super();
         this.main = param1;
         this.clan_village = param2;
         this.defaultLook();
         this.upgrade_info = [];
         this.btn_close.addEventListener(MouseEvent.CLICK,this.onClose);
         this.btn_upgrade.addEventListener(MouseEvent.CLICK,this.onUpgrade);
         this.upgrade_info.push(["No boosts","+10 Stamina every 30 minutes","+20 Stamina every 30 minutes","+30 Stamina every 30 minutes"]);
         this.upgrade_info.push(["No boosts","+30% maximum HP","+60% maximum HP","+90% maximum HP"]);
         this.upgrade_info.push(["No boosts","+30% maximum CP","+60% maximum CP","+90% maximum CP"]);
         this.upgrade_info.push(["No boosts","+30% damage for all attacks","+60% damage for all attacks","+90% damage for all attacks"]);
      }
      
      public function onClose(param1:MouseEvent) : *
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.btn_upgrade.removeEventListener(MouseEvent.CLICK,this.onUpgrade);
         this.main = null;
         this.clan_village = null;
         GF.clearArray(this.upgrade_info);
      }
      
      public function onUpgrade(param1:MouseEvent) : *
      {
         this.main.loading(true);
         Clan.instance.upgradeBuilding(this.upgrading_name,this.onUpgradeRes);
      }
      
      public function onUpgradeRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("unknown error");
         }
         if(this.clan_village != null)
         {
            Clan.instance.getClanData(this.onGetClanResNew);
         }
      }
      
      public function onGetClanResNew(param1:*, param2:* = null) : *
      {
         if(param1 != null && param1.hasOwnProperty("clan") && param1.hasOwnProperty("char") && this.clan_village != null)
         {
            this.clan_village.clan_data = param1.clan;
            this.clan_village.char_data = param1.char;
            this.clan_village.setDisplay();
            this.onClose(null);
         }
      }
      
      public function showInfo(param1:int, param2:int) : *
      {
         if(param2 == 3)
         {
            gotoAndStop(param1 + 1);
            this.price_type.visible = false;
            this.price.text = "";
            this.mc.gotoAndStop(param2 + 1);
            this.nmc.gotoAndStop(param2 + 1);
            this.curr_level.text = String(param2);
            this.curr_desc.text = this.upgrade_info[param1][param2];
            this.next_level.text = String(param2);
            this.next_desc.text = this.upgrade_info[param1][param2];
            this.btn_upgrade.visible = false;
         }
         else
         {
            gotoAndStop(param1 + 1);
            this.price_type.gotoAndStop(1);
            this.price.text = this.pricing[param2 + 1];
            if(param2 == 2)
            {
               this.price_type.gotoAndStop(2);
            }
            this.totalprice = int(this.price.text);
            this.mc.gotoAndStop(param2 + 1);
            this.nmc.gotoAndStop(param2 + 2);
            this.curr_level.text = String(param2);
            this.curr_desc.text = this.upgrade_info[param1][param2];
            this.next_level.text = String(param2 + 1);
            this.next_desc.text = this.upgrade_info[param1][param2 + 1];
         }
      }
      
      public function defaultLook() : *
      {
         gotoAndStop(1);
         this.price_type.gotoAndStop(1);
         this.curr_level.text = "";
         this.curr_desc.text = "";
         this.next_level.text = "";
         this.next_desc.text = "";
         this.price.text = "";
      }
   }
}
