package Popups
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7133")]
   public class ClanBattle extends MovieClip
   {
      
      public var btn_close:SimpleButton;
      
      public var btn_fight:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_search:SimpleButton;
      
      public var clan_0:MovieClip;
      
      public var clan_1:MovieClip;
      
      public var clan_2:MovieClip;
      
      public var clan_3:MovieClip;
      
      public var clan_4:MovieClip;
      
      public var clan_5:MovieClip;
      
      public var clan_6:MovieClip;
      
      public var txt_page:TextField;
      
      public var txt_search:TextField;
      
      public var main:*;
      
      public var __parent:*;
      
      public var clan_sel_slot:int = -1;
      
      public var clan_sel_idx:int = -1;
      
      public var current_page:* = 0;
      
      public var total_page:* = 0;
      
      public var clans:Array = [];
      
      public var clansTmp:Array = [];
      
      private var firstSearch:* = true;
      
      public var search:* = "";
      
      public var is_search:* = false;
      
      public var search_clan_idx:* = -1;
      
      public var second_popup:* = null;
      
      internal var attacking_clan_id:*;
      
      private var eventHandler:* = new EventHandler();
      
      private var destroyed:* = false;
      
      public function ClanBattle(param1:*, param2:*)
      {
         this.clans = [];
         this.clansTmp = [];
         super();
         this.main = param1;
         this.__parent = param2;
         this.addButtonListeners();
         this.clearClanTable();
         this.updatePageText();
         this.getClanTable();
      }
      
      public function updatePageText() : *
      {
         this.txt_page.text = String(this.current_page) + " / " + String(this.total_page);
      }
      
      public function clearClanTable(param1:Boolean = false) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 7)
         {
            this["clan_" + _loc2_].gotoAndStop(1);
            if(!this["clan_" + _loc2_].hasEventListener(MouseEvent.CLICK))
            {
               this.eventHandler.addListener(this["clan_" + _loc2_],MouseEvent.CLICK,this.onSelectClan);
            }
            this["clan_" + _loc2_].visible = param1;
            _loc2_++;
         }
      }
      
      public function onSelectClan(param1:MouseEvent) : *
      {
         if(this.clan_sel_slot != -1)
         {
            this["clan_" + this.clan_sel_slot].gotoAndStop(1);
         }
         var _loc2_:* = int(param1.currentTarget.name.replace("clan_",""));
         this.clan_sel_slot = _loc2_;
         if(this.is_search)
         {
            if(this.clans[this.search_clan_idx].id == Character.clan_data.clan_id)
            {
               this.main.getNotice("You can not attack own clan!");
               this.clan_sel_idx = -1;
               this.clan_sel_slot = -1;
               this.search_clan_idx = -1;
               return;
            }
            this.clan_sel_idx = this.search_clan_idx;
            param1.currentTarget.gotoAndStop(2);
         }
         else
         {
            this.clan_sel_idx = _loc2_ + (this.current_page - 1) * 7;
            if(this.clans[this.clan_sel_idx].id == Character.clan_data.clan_id)
            {
               this.main.getNotice("You can not attack own clan!");
               this.clan_sel_idx = -1;
               this.clan_sel_slot = -1;
               this.search_clan_idx = -1;
               return;
            }
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      public function getClanTable() : *
      {
         this.main.loading(true);
         Clan.instance.getClansForBattle(this.onGetClansRes);
      }
      
      public function onGetClansRes(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && Boolean(param1.hasOwnProperty("clans")))
         {
            this.clans = param1.clans;
            this.current_page = 1;
            this.total_page = Math.max(Math.ceil(param1.clans.length / 7),1);
            this.displayClans();
            if(Boolean(this.is_search) && param1.clans.length < 1)
            {
               this.main.getNotice("No clan are found with this ID");
            }
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice("Server Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      public function displayClans() : *
      {
         var _loc1_:* = undefined;
         this.is_search = false;
         this.updatePageText();
         this.clearClanTable();
         this.clan_sel_idx = -1;
         var _loc2_:* = 0;
         while(_loc2_ < 7)
         {
            _loc1_ = _loc2_ + (this.current_page - 1) * 7;
            if(this.clans.length > _loc1_)
            {
               this["clan_" + _loc2_].gotoAndStop(1);
               this["clan_" + _loc2_].visible = true;
               this["clan_" + _loc2_].clan_id.text = this.clans[_loc1_].id;
               this["clan_" + _loc2_].clan_name.text = this.clans[_loc1_].name;
               this["clan_" + _loc2_].clan_reputation.text = this.clans[_loc1_].reputation;
               this["clan_" + _loc2_].clan_members.text = this.clans[_loc1_].members + " / " + this.clans[_loc1_].max_members;
            }
            else
            {
               this["clan_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      public function displayClan(param1:*) : *
      {
         this.is_search = true;
         this.clan_sel_idx = -1;
         this.clearClanTable();
         this.txt_page.text = "1 / 1";
         var _loc2_:Boolean = false;
         var _loc3_:* = 0;
         while(_loc3_ < this.clans.length)
         {
            if(this.clans[_loc3_].id == param1)
            {
               this.search_clan_idx = _loc3_;
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this["clan_0"].gotoAndStop(1);
            this["clan_0"].visible = true;
            this["clan_0"].clan_id.text = this.clans[this.search_clan_idx].id;
            this["clan_0"].clan_name.text = this.clans[this.search_clan_idx].name;
            this["clan_0"].clan_reputation.text = this.clans[this.search_clan_idx].reputation;
            this["clan_0"].clan_members.text = this.clans[this.search_clan_idx].members + " / " + this.clans[this.search_clan_idx].max_members;
            return;
         }
         this.current_page = 1;
         this.displayClans();
         this.main.showMessage("Searching in unlisted clan...");
         Clan.instance.searchClansForBattle(int(this.txt_search.text),this.onGetSearchClansRes);
      }
      
      public function addButtonListeners() : *
      {
         this.eventHandler.addListener(this.btn_fight,MouseEvent.CLICK,this.onFightPopup);
         this.eventHandler.addListener(this.btn_search,MouseEvent.CLICK,this.onSearch);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.onClosePanel);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_page > this.current_page)
               {
                  ++this.current_page;
                  this.displayClans();
               }
               break;
            case "btn_prev":
               if(this.current_page > 1)
               {
                  --this.current_page;
                  this.displayClans();
               }
         }
         this.updatePageText();
      }
      
      private function onGetSearchClansRes(param1:*, param2:* = null) : *
      {
         if(param1 != null && Boolean(param1.hasOwnProperty("clans")))
         {
            if(this.firstSearch)
            {
               this.clansTmp = this.clans;
               this.firstSearch = false;
            }
            if(param1.clans == null)
            {
               param1.clans = [];
            }
            this.onGetClansRes(param1,null);
            return;
         }
         this.onGetClansRes(param1,param2);
      }
      
      public function onSearch(param1:MouseEvent) : *
      {
         if(this.txt_search.text == "")
         {
            if(this.clansTmp.length > 0)
            {
               this.clans = this.clansTmp;
            }
            this.displayClans();
         }
         else
         {
            this.search = int(this.txt_search.text);
            this.displayClan(this.search);
         }
      }
      
      public function onFightPopup(param1:MouseEvent) : *
      {
         if(this.clan_sel_idx == -1)
         {
            this.main.getNotice("Please select a clan first!");
         }
         else
         {
            if(Character.clan_char_data.stamina < 10)
            {
               this.main.getNotice("Out of stamina!");
               return;
            }
            this.attacking_clan_id = this.clan_sel_idx;
            Character.clan_attack_id = this.clans[this.attacking_clan_id].id;
            this.second_popup = new ClanBattleMode(this.main,this.__parent,this);
            this.addChild(this.second_popup);
         }
      }
      
      public function onClosePanel(param1:MouseEvent) : *
      {
         var event:MouseEvent = param1;
         Log.debug(this,"DESTROY");
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.__parent = null;
         GF.clearArray(this.clans);
         GF.clearArray(this.clansTmp);
         this.clans = null;
         this.clansTmp = null;
         try
         {
            GF.removeAllChild(this);
         }
         catch(e:*)
         {
            Log.error(this,"Destroy",e);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this.second_popup)
         {
            try
            {
               this.second_popup.destroy();
            }
            catch(e:*)
            {
               Log.error(this,"Destroy",e);
            }
            this.second_popup = null;
         }
      }
      
      public function destroy() : *
      {
         if(this.destroyed)
         {
            return;
         }
         this.onClosePanel(null);
      }
   }
}

