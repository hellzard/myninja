package Panels
{
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import id.ninjasage.Clan;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class WallOfFame extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var bg:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var clanWinnerMC0:MovieClip;
      
      public var clanWinnerMC1:MovieClip;
      
      public var clanWinnerMC2:MovieClip;
      
      public var clanWinnerMC3:MovieClip;
      
      public var titleTxt:TextField;
      
      private var main;
      
      private var curr_page = 1;
      
      private var last_page = 0;
      
      private var total_page = 0;
      
      private var clanData;
      
      private var rew_loading = 0;
      
      private var loader;
      
      private var eventHandler;
      
      public function WallOfFame(param1:*)
      {
         this.eventHandler = new EventHandler();
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.loader = this.main.getTempLoader();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.getData();
      }
      
      private function getData() : *
      {
         Clan.instance.seasonHistories(this.getDataResponse);
      }
      
      private function getDataResponse(param1:Object, param2:* = null) : *
      {
         var _loc3_:* = undefined;
         if(param1 != null && param1.hasOwnProperty("histories"))
         {
            this.clanData = param1.histories;
            for each(_loc3_ in param1.histories)
            {
               this.loader.add(_loc3_.banner,{"id":_loc3_.clan_id});
            }
            this.showWallOfFame();
            return;
         }
      }
      
      private function showWallOfFame() : *
      {
         var _loc3_:* = undefined;
         this.loader.addEventListener(BulkLoader.COMPLETE,this.onClanLogoLoaded);
         this.loader.start();
         this.resetClanIcons();
         this.rew_loading = 0;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc1_ < 4)
         {
            _loc3_ = _loc1_ + int(int(this.curr_page - 1) * 4);
            if(this.clanData.length > _loc3_)
            {
               this["clanWinnerMC" + _loc1_].visible = true;
               this["clanWinnerMC" + _loc1_].clanSeasonTxt.text = "Season " + this.clanData[_loc3_].season;
               this["clanWinnerMC" + _loc1_].clanNameTxt.text = this.clanData[_loc3_].clan_name;
               this["clanWinnerMC" + _loc1_].clanMasterTxt.text = this.clanData[_loc3_].master;
               this["clanWinnerMC" + _loc1_].reputationTxt.text = this.clanData[_loc3_].reputation;
               this["clanWinnerMC" + _loc1_].endedDateTxt.text = this.clanData[_loc3_].season_ended_at;
               if(this.loader.hasItem(this.clanData[_loc3_].clan_id,false))
               {
                  _loc2_++;
               }
            }
            else
            {
               this["clanWinnerMC" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(_loc2_ > 0)
         {
            this.onClanLogoLoaded(null);
         }
         this.updatePageNumber();
         this.total_page = Math.max(Math.ceil(this.clanData.length / 4),1);
      }
      
      private function onClanLogoLoaded(param1:* = null) : *
      {
         var _loc3_:* = undefined;
         if(this.rew_loading > 3)
         {
            this.rew_loading = 0;
            this.loader.removeEventListener(BulkLoader.COMPLETE,this.showWallOfFame);
            return;
         }
         var _loc2_:* = this.rew_loading + int(int(this.curr_page - 1) * 4);
         if(!this.clanData[_loc2_])
         {
            return;
         }
         if(this.loader.hasItem(this.clanData[_loc2_].clan_id,false))
         {
            _loc3_ = this.loader.getContent(this.clanData[_loc2_].clan_id);
            this["clanWinnerMC" + this.rew_loading].clanLogoHolder.addChild(_loc3_);
         }
         ++this.rew_loading;
         setTimeout(this.onClanLogoLoaded,100);
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_page > this.curr_page)
               {
                  ++this.curr_page;
                  this.showWallOfFame();
               }
               break;
            case "btn_prev":
               if(this.curr_page > 1)
               {
                  --this.curr_page;
                  this.showWallOfFame();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : *
      {
         if(this.curr_page == 1)
         {
            this.btn_prev.visible = false;
         }
         else
         {
            this.btn_prev.visible = true;
         }
         if(this.total_page == this.curr_page)
         {
            this.btn_next.visible = false;
         }
         else
         {
            this.btn_next.visible = true;
         }
      }
      
      private function resetClanIcons() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            GF.removeAllChild(this["clanWinnerMC" + _loc1_].clanLogoHolder);
            _loc1_++;
         }
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         this.main = null;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.loader.clear();
         this.loader = null;
         this.resetClanIcons();
         GF.removeAllChild(this);
      }
   }
}
