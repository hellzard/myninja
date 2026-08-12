package Panels
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.Clan;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class ClanRequest extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panel:MovieClip;
      
      public var main;
      
      public var clan_sel_slot:int = -1;
      
      public var clan_sel_idx:int = -1;
      
      public var current_page = 0;
      
      public var total_page = 0;
      
      public var clans:Array;
      
      public var search = "";
      
      public var selectedClanId:int = -1;
      
      public var eventHandler;
      
      public var clansTmp:Array;
      
      public var is_search = false;
      
      public var firstSearch = true;
      
      public function ClanRequest(param1:*)
      {
         this.clansTmp = [];
         this.eventHandler = new EventHandler();
         this.clans = [];
         this.clansTmp = [];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClosePanel);
         this.main = param1;
         this.addButtonListeners();
         this.clearClanTable();
         this.updatePageText();
         this.getClanTable();
      }
      
      public function updatePageText() : *
      {
         this.panel.txt_page.text = this.current_page + " / " + this.total_page;
      }
      
      public function clearClanTable(param1:Boolean = false) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            this.panel["clan_" + _loc2_].gotoAndStop(1);
            this.eventHandler.addListener(this.panel["clan_" + _loc2_],MouseEvent.CLICK,this.onSelectClan,false,0,true);
            this.panel["clan_" + _loc2_].visible = param1;
            _loc2_++;
         }
      }
      
      public function onSelectClan(param1:MouseEvent) : *
      {
         if(this.clan_sel_slot != -1)
         {
            this.panel["clan_" + this.clan_sel_slot].gotoAndStop(1);
         }
         var _loc2_:* = int(param1.currentTarget.name.replace("clan_",""));
         this.selectedClanId = param1.currentTarget.clan_id.text;
         this.clan_sel_slot = _loc2_;
         this.clan_sel_idx = _loc2_ + (this.current_page - 1) * 6;
         param1.currentTarget.gotoAndStop(2);
      }
      
      public function getClanTable() : *
      {
         this.main.loading(true);
         Clan.instance.getClansForRequest(this.onGetClansRes);
      }
      
      public function onGetClansRes(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("clans"))
         {
            this.clans = param1.clans;
            this.current_page = 1;
            this.total_page = Math.max(Math.ceil(param1.clans.length / 6),1);
            this.displayClans();
            if(this.is_search && param1.clans.length < 1)
            {
               this.main.getNotice("No clan are found with this ID");
            }
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Server Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      public function displayClans() : *
      {
         this.is_search = true;
         var _loc1_:* = undefined;
         this.updatePageText();
         this.clearClanTable();
         this.clan_sel_idx = -1;
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            _loc1_ = _loc2_ + (this.current_page - 1) * 6;
            if(this.clans.length > _loc1_)
            {
               this.panel["clan_" + _loc2_].gotoAndStop(1);
               this.panel["clan_" + _loc2_].visible = true;
               this.panel["clan_" + _loc2_].clan_id.text = this.clans[_loc1_].id;
               this.panel["clan_" + _loc2_].clan_name.text = this.clans[_loc1_].name;
               this.panel["clan_" + _loc2_].clan_reputation.text = this.clans[_loc1_].reputation;
               this.panel["clan_" + _loc2_].clan_members.text = this.clans[_loc1_].members + " / " + this.clans[_loc1_].max_members;
            }
            else
            {
               this.panel["clan_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      public function displayClan(param1:*) : *
      {
         this.is_search = true;
         this.clan_sel_idx = -1;
         this.clearClanTable();
         this.panel.txt_page.text = "1 / 1";
         var _loc2_:Boolean = false;
         var _loc3_:* = -1;
         var _loc4_:* = 0;
         while(_loc4_ < this.clans.length)
         {
            if(this.clans[_loc4_].id == param1)
            {
               _loc3_ = _loc4_;
               _loc2_ = true;
               break;
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            this.panel["clan_0"].gotoAndStop(1);
            this.panel["clan_0"].visible = true;
            this.panel["clan_0"].clan_id.text = this.clans[_loc3_].id;
            this.panel["clan_0"].clan_name.text = this.clans[_loc3_].name;
            this.panel["clan_0"].clan_reputation.text = this.clans[_loc3_].reputation;
            this.panel["clan_0"].clan_members.text = this.clans[_loc3_].members + " / " + this.clans[_loc3_].max_members;
            return;
         }
         this.current_page = 1;
         this.displayClans();
         this.main.showMessage("Searching in unlisted clan...");
         Clan.instance.searchClansForRequest(int(this.panel.txt_search.text),this.onGetSearchClansRes);
      }
      
      public function addButtonListeners() : *
      {
         this.eventHandler.addListener(this.panel.btn_request,MouseEvent.CLICK,this.onRequestReq,false,0,true);
         this.eventHandler.addListener(this.panel.btn_search,MouseEvent.CLICK,this.onSearch,false,0,true);
         this.eventHandler.addListener(this.panel.btn_close,MouseEvent.CLICK,this.onClosePanel,false,0,true);
         this.eventHandler.addListener(this.panel.btn_next,MouseEvent.CLICK,this.changePage,false,0,true);
         this.eventHandler.addListener(this.panel.btn_prev,MouseEvent.CLICK,this.changePage,false,0,true);
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
      
      public function onSearch(param1:MouseEvent) : *
      {
         if(this.panel.txt_search.text == "")
         {
            if(this.clansTmp.length > 0)
            {
               this.clans = this.clansTmp;
               this.clansTmp = [];
               this.firstSearch = true;
            }
            this.current_page = 1;
            this.total_page = Math.max(Math.ceil(this.clans.length / 6),1);
            this.displayClans();
         }
         else
         {
            this.search = int(this.panel.txt_search.text);
            this.displayClan(this.search);
         }
      }
      
      public function onGetSearchClansRes(param1:*, param2:* = null) : *
      {
         if(param1 != null && param1.hasOwnProperty("clans"))
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
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Server Error: " + param1.errorMessage);
            return;
         }
         this.onGetClansRes(param1,param2);
      }
      
      public function onRequestReq(param1:MouseEvent) : *
      {
         if(this.clan_sel_idx == -1 || this.selectedClanId == -1)
         {
            this.main.getNotice("Please select a clan first!");
         }
         else
         {
            this.main.loading(true);
            Clan.instance.sendRequestToClan(this.selectedClanId,this.onRequestToClanRes);
         }
      }
      
      public function onRequestToClanRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("result"))
         {
            this.clearClanTable();
            this.getClanTable();
            this.main.getNotice(param1.result);
            this.clan_sel_idx = -1;
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      public function onClosePanel(param1:MouseEvent) : *
      {
         GF.clearArray(this.clans);
         GF.clearArray(this.clansTmp);
         this.clansTmp = null;
         this.clans = null;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main.loadPanel("Panels.ClanCreate");
         this.main = null;
         parent.removeChild(this);
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.onClosePanel(null);
      }
   }
}
