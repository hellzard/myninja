package Panels
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7069")]
   public class ClanCreate extends MovieClip
   {
      
      public var btn_ClanShop:SimpleButton;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_clan_list:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_create:SimpleButton;
      
      public var clan_name:TextField;
      
      public var iconMc0:MovieClip;
      
      public var iconMc1:MovieClip;
      
      public var iconMc2:MovieClip;
      
      public var iconMc3:MovieClip;
      
      public var iconMc4:MovieClip;
      
      public var main:*;
      
      public var clan_rews:* = ["wpn_400","back_100","hair_78_" + Character.character_gender,"set_300_" + Character.character_gender,"skill_01"];
      
      public var confirmation:*;
      
      public var eventHandler:*;
      
      public function ClanCreate(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClosePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.addButtonListeners();
         this.showRewards();
      }
      
      public function showRewards() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            NinjaSage.loadIconSWF(_loc1_ < 4 ? "items" : "skills",this.clan_rews[_loc1_],this["iconMc" + _loc1_]);
            _loc1_++;
         }
      }
      
      public function addButtonListeners() : *
      {
         this.eventHandler.addListener(this.btn_create,MouseEvent.CLICK,this.createClanConfirmation,false,0,true);
         this.eventHandler.addListener(this.btn_clan_list,MouseEvent.CLICK,this.onClanList,false,0,true);
         this.eventHandler.addListener(this.btn_ClanShop,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.onClosePanel,false,0,true);
      }
      
      public function createClanConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to create clan?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onCreateClanReq);
         addChild(this.confirmation);
      }
      
      public function onCreateClanReq(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         if(this["clan_name"].text == "")
         {
            this.main.getNotice("Clan name should not be empty!");
         }
         else
         {
            this.main.loading(true);
            Clan.instance.createClan(this.clan_name.text,this.onCreateClanRes);
         }
      }
      
      public function onCreateClanRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 == "ok")
         {
            Character.account_tokens -= 1000;
            Clan.instance.getClanData(this.onGetClanData);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("");
         }
      }
      
      public function onGetClanData(param1:*, param2:* = null) : *
      {
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("clan")) && Boolean(param1.hasOwnProperty("char")))
         {
            Character.clan_data = param1.clan;
            Character.clan_char_data = param1.char;
            this.main.loadPanel("Panels.ClanVillage");
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         this.onClosePanel(null);
      }
      
      public function onClanList(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.ClanRequest");
         this.onClosePanel(param1);
      }
      
      private function openPanel(param1:MouseEvent) : *
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Panels." + _loc2_);
      }
      
      public function onClosePanel(param1:MouseEvent) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            GF.removeAllChild(this["iconMc" + _loc2_]);
            _loc2_++;
         }
         NinjaSage.clearLoader();
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         GF.removeAllChild(this);
         parent.removeChild(this);
      }
   }
}

