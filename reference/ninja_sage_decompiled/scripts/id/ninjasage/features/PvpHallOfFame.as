package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class PvpHallOfFame extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var main;
      
      private var outfits:Array;
      
      private var seasonalStats:Array;
      
      private var currentSeasonIndex:int = 0;
      
      private var currentSeason:int;
      
      private var earliestSeason:int;
      
      private var searchPlaceholder:String = "";
      
      public function PvpHallOfFame(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.outfits = [];
         this.panelMC.txt_search.restrict = "0-9";
         this.eventHandler = new EventHandler();
         this.getData();
      }
      
      private function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("jpwzlvqNru201CF3.Dl5gZgY2487S",[Character.char_id,Character.sessionkey],this.getDataResponse);
      }
      
      private function getDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.seasonalStats = param1.seasons;
            this.currentSeason = this.seasonalStats[this.currentSeasonIndex].season;
            this.earliestSeason = this.seasonalStats[this.seasonalStats.length - 1].season;
            if(this.seasonalStats.length == 0)
            {
               this.main.getNotice("No seasonal stats found");
               this.destroy();
               return;
            }
            this.initUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.destroy();
         }
      }
      
      private function initUI() : void
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changeSeason);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changeSeason);
         this.eventHandler.addListener(this.panelMC.btn_search,MouseEvent.CLICK,this.onSearch);
         this.panelMC.txt_season.text = "Season " + this.currentSeason.toString();
         this.panelMC.btn_clearSearch.visible = false;
         this.renderCharacters();
         this.updateSeasonPageButton();
      }
      
      private function renderCharacters() : void
      {
         var _loc2_:OutfitManager = null;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = new OutfitManager();
            this.outfits.push(_loc2_);
            _loc2_.fillOutfit(this.panelMC["char_mc" + _loc1_],this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].sets.weapon,this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].sets.back,this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].sets.set,this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].sets.hair,this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].sets.face,this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].sets.color_hair,this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].sets.color_skin);
            this.panelMC["infoMC" + _loc1_].txt_name.htmlText = Character.colorifyText(this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].id,this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].name,this.panelMC["infoMC" + _loc1_].txt_name);
            this.panelMC["infoMC" + _loc1_].txt_level.text = this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].level;
            this.panelMC["leagueInfo" + _loc1_].txt_trophy.text = this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].trophy;
            this.panelMC["leagueInfo" + _loc1_].leagueMC.gotoAndStop(this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].league + 1);
            NinjaSage.showDynamicTooltip(this.panelMC["leagueInfo" + _loc1_].leagueMC,this.seasonalStats[this.currentSeasonIndex].top3[_loc1_].league_name);
            _loc1_++;
         }
      }
      
      private function changeSeason(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_prev":
               if(this.currentSeasonIndex < this.seasonalStats.length - 1)
               {
                  ++this.currentSeasonIndex;
               }
               break;
            case "btn_next":
               if(this.currentSeasonIndex > 0)
               {
                  --this.currentSeasonIndex;
               }
         }
         this.updateSeasonPageButton();
         this.renderCharacters();
         this.updateSeasonText();
      }
      
      private function updateSeasonPageButton() : void
      {
         if(this.seasonalStats.length <= 1)
         {
            this.panelMC.btn_prev.visible = false;
            this.panelMC.btn_next.visible = false;
         }
         if(this.currentSeasonIndex == 0)
         {
            this.panelMC.btn_prev.visible = true;
            this.panelMC.btn_next.visible = false;
         }
         else if(this.currentSeasonIndex == this.seasonalStats.length - 1)
         {
            this.panelMC.btn_prev.visible = false;
            this.panelMC.btn_next.visible = true;
         }
         else
         {
            this.panelMC.btn_prev.visible = true;
            this.panelMC.btn_next.visible = true;
         }
      }
      
      private function updateSeasonText() : void
      {
         this.panelMC.txt_season.text = "Season " + this.seasonalStats[this.currentSeasonIndex].season;
      }
      
      private function onFocusIn(param1:FocusEvent) : void
      {
         if(param1.currentTarget.text == this.searchPlaceholder)
         {
            param1.currentTarget.text = "";
            param1.currentTarget.textColor = 0;
         }
      }
      
      private function onSearch(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.panelMC.txt_search.text);
         this.currentSeasonIndex = this.getSeasonIndex(_loc2_);
         if(this.currentSeasonIndex == -1)
         {
            this.main.showMessage("Season not found");
            return;
         }
         this.updateSeasonPageButton();
         this.updateSeasonText();
         this.renderCharacters();
      }
      
      private function getSeasonIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.seasonalStats.length)
         {
            if(this.seasonalStats[_loc2_].season == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function onFocusOut(param1:FocusEvent) : void
      {
         if(param1.currentTarget.text == "")
         {
            param1.currentTarget.text = this.searchPlaceholder;
            param1.currentTarget.textColor = 10066329;
         }
      }
      
      private function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.outfits.length)
         {
            this.outfits[_loc1_].destroy();
            GF.removeAllChild(this.panelMC["char_mc" + _loc1_]);
            _loc1_++;
         }
         this.outfits = null;
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}
