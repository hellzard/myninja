package id.ninjasage.features
{
   import Managers.OutfitManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ArenaStatistic extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var main;
      
      private var overallStats:Object;
      
      private var seasonalStats:Array;
      
      private var outfits:Array;
      
      private var currentTab:String = "seasonal_stats";
      
      private var currentSeasonIndex:int = 0;
      
      private var currentSeason:int;
      
      private var earliestSeason:int;
      
      private var searchPlaceholder:String = "Season number";
      
      public function ArenaStatistic(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.outfits = [];
         this.eventHandler = new EventHandler();
         this.getData();
      }
      
      private function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["zdUPy1oqIQOS",[Character.char_id,Character.sessionkey]],this.getDataResponse);
      }
      
      private function getDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.overallStats = param1.overall;
            this.seasonalStats = param1.seasonal;
            this.currentSeason = this.seasonalStats[0].season;
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
         this.panelMC.detailMC.visible = false;
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_view_more,MouseEvent.CLICK,this.openViewMore);
         var _loc1_:OutfitManager = new OutfitManager();
         this.outfits.push(_loc1_);
         _loc1_.fillHead(this.panelMC.infoMC.holder,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
         _loc1_.fillOutfit(this.panelMC.char_mc,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
         this.panelMC.squadIcon.gotoAndStop(Character.getSquadName(Character.squad_data.squad));
         this.panelMC.leagueIcon.gotoAndStop(Character.squad_data.rank + 1);
         this.panelMC.infoMC.txt_name.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.panelMC.infoMC.txt_name);
         this.panelMC.infoMC.txt_level.text = "Lv. " + Character.character_lvl;
         var _loc2_:MovieClip = this.panelMC.seasonalStatsMC;
         var _loc3_:Object = this.seasonalStats[this.currentSeasonIndex];
         _loc2_.txt_season.text = "Season " + _loc3_.season;
         _loc2_.txt_season_date.text = _loc3_.started_at + " - " + _loc3_.ended_at;
         _loc2_.txt_total_battle.text = _loc3_.stats.total_battles;
         _loc2_.txt_win_rate_attack.text = _loc3_.stats.win_rate_attack + "%";
         _loc2_.bar_win_rate_attack.bar.scaleX = Math.min(Math.max(_loc3_.stats.win_rate_attack / 100,0),1);
         _loc2_.txt_win_rate_defend.text = _loc3_.stats.win_rate_defend + "%";
         _loc2_.bar_win_rate_defend.bar.scaleX = Math.min(Math.max(_loc3_.stats.win_rate_defend / 100,0),1);
         var _loc4_:MovieClip;
         (_loc4_ = this.panelMC.overallStatsMC).txt_played_season.text = this.overallStats.seasons_played;
         _loc4_.txt_total_battle.text = this.overallStats.total_battles;
         _loc4_.txt_win_rate_attack.text = this.overallStats.overall_attack_win_rate + "%";
         _loc4_.bar_win_rate_attack.bar.scaleX = Math.min(Math.max(this.overallStats.overall_attack_win_rate / 100,0),1);
         _loc4_.txt_win_rate_defend.text = this.overallStats.overall_defend_win_rate + "%";
         _loc4_.bar_win_rate_defend.bar.scaleX = Math.min(Math.max(this.overallStats.overall_defend_win_rate / 100,0),1);
      }
      
      private function openViewMore(param1:MouseEvent) : void
      {
         this.panelMC.detailMC.visible = true;
         this.eventHandler.addListener(this.panelMC.detailMC.btn_close,MouseEvent.CLICK,this.closeViewMore);
         this.eventHandler.addListener(this.panelMC.detailMC.btn_seasonal_stats,MouseEvent.CLICK,this.changeTab);
         this.eventHandler.addListener(this.panelMC.detailMC.btn_overall_stats,MouseEvent.CLICK,this.changeTab);
         this.resetTab();
         this.panelMC.detailMC.btn_seasonal_stats.gotoAndStop(3);
         this.panelMC.detailMC.seasonalStatsMC.visible = true;
         this.renderSeasonalStats();
      }
      
      private function changeTab(param1:MouseEvent) : void
      {
         this.resetTab();
         this.currentTab = param1.currentTarget.name.replace("btn_","");
         param1.currentTarget.gotoAndStop(3);
         if(this.currentTab == "seasonal_stats")
         {
            this.panelMC.detailMC.seasonalStatsMC.visible = true;
            this.renderSeasonalStats();
         }
         else
         {
            this.panelMC.detailMC.overallStatsMC.visible = true;
            this.renderOverallStats();
         }
      }
      
      private function renderOverallStats() : void
      {
         var _loc1_:MovieClip = this.panelMC.detailMC.overallStatsMC;
         _loc1_.txt_total_attack.text = this.overallStats.total_attacks;
         _loc1_.txt_total_attack_win.text = this.overallStats.total_attack_wins;
         _loc1_.txt_overall_attack_win_rate.text = this.overallStats.overall_attack_win_rate + "%";
         _loc1_.bar_overall_attack_win_rate.bar.scaleX = Math.min(Math.max(this.overallStats.overall_attack_win_rate / 100,0),1);
         _loc1_.txt_total_defend.text = this.overallStats.total_defends;
         _loc1_.txt_total_defend_win.text = this.overallStats.total_defend_wins;
         _loc1_.txt_overall_defend_win_rate.text = this.overallStats.overall_defend_win_rate + "%";
         _loc1_.bar_overall_defend_win_rate.bar.scaleX = Math.min(Math.max(this.overallStats.overall_defend_win_rate / 100,0),1);
         _loc1_.txt_total_battle.text = this.overallStats.total_battles;
         _loc1_.txt_avg_battle_season.text = this.overallStats.avg_battles_per_season;
         _loc1_.txt_performance_grade.text = this.overallStats.performance_grade;
         _loc1_.txt_performance_grade.textColor = this.getGradeColor(this.overallStats.performance_grade);
         _loc1_.txt_overall_win_rate.text = this.overallStats.overall_win_rate + "%";
         _loc1_.bar_overall_win_rate.bar.scaleX = Math.min(Math.max(this.overallStats.overall_win_rate / 100,0),1);
         _loc1_.txt_best_season.text = this.overallStats.best_season;
         _loc1_.txt_best_season_win_rate.text = this.overallStats.best_season_win_rate + "%";
         _loc1_.bar_best_season_win_rate.bar.scaleX = Math.min(Math.max(this.overallStats.best_season_win_rate / 100,0),1);
         _loc1_.txt_worst_season.text = this.overallStats.worst_season;
         _loc1_.txt_worst_season_win_rate.text = this.overallStats.worst_season_win_rate + "%";
         _loc1_.bar_worst_season_win_rate.bar.scaleX = Math.min(Math.max(this.overallStats.worst_season_win_rate / 100,0),1);
         _loc1_.txt_played_season.text = this.overallStats.seasons_played;
      }
      
      private function renderSeasonalStats() : void
      {
         var _loc1_:MovieClip = this.panelMC.detailMC.seasonalStatsMC;
         _loc1_.txt_search.restrict = "0-9";
         _loc1_.txt_search.text = this.searchPlaceholder;
         _loc1_.txt_search.textColor = 10066329;
         this.eventHandler.addListener(_loc1_.txt_search,FocusEvent.FOCUS_IN,this.onFocusIn);
         this.eventHandler.addListener(_loc1_.txt_search,FocusEvent.FOCUS_OUT,this.onFocusOut);
         this.eventHandler.addListener(_loc1_.btn_search,MouseEvent.CLICK,this.onSearch);
         this.eventHandler.addListener(_loc1_.btn_prev,MouseEvent.CLICK,this.changeSeason);
         this.eventHandler.addListener(_loc1_.btn_next,MouseEvent.CLICK,this.changeSeason);
         _loc1_.txt_total_attack.text = this.seasonalStats[this.currentSeasonIndex].stats.attacks;
         _loc1_.txt_total_attack_win.text = this.seasonalStats[this.currentSeasonIndex].stats.attack_win;
         _loc1_.txt_win_rate_attack.text = this.seasonalStats[this.currentSeasonIndex].stats.win_rate_attack + "%";
         _loc1_.bar_win_rate_attack.bar.scaleX = Math.min(Math.max(this.seasonalStats[this.currentSeasonIndex].stats.win_rate_attack / 100,0),1);
         _loc1_.txt_total_defend.text = this.seasonalStats[this.currentSeasonIndex].stats.defends;
         _loc1_.txt_total_defend_win.text = this.seasonalStats[this.currentSeasonIndex].stats.defend_win;
         _loc1_.txt_win_rate_defend.text = this.seasonalStats[this.currentSeasonIndex].stats.win_rate_defend + "%";
         _loc1_.bar_win_rate_defend.bar.scaleX = Math.min(Math.max(this.seasonalStats[this.currentSeasonIndex].stats.win_rate_defend / 100,0),1);
         _loc1_.txt_avg_battle_time.text = this.seasonalStats[this.currentSeasonIndex].stats.avg_battle_time;
         _loc1_.txt_total_battle.text = this.seasonalStats[this.currentSeasonIndex].stats.total_battles;
         _loc1_.txt_season_start_date.text = this.seasonalStats[this.currentSeasonIndex].started_at;
         _loc1_.txt_season_end_date.text = this.seasonalStats[this.currentSeasonIndex].ended_at;
         _loc1_.txt_season.text = "Season " + this.seasonalStats[this.currentSeasonIndex].season;
         this.updateSeasonPageButton();
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
         this.renderSeasonalStats();
      }
      
      private function updateSeasonPageButton() : void
      {
         if(this.seasonalStats.length <= 1)
         {
            this.panelMC.detailMC.seasonalStatsMC.btn_prev.visible = false;
            this.panelMC.detailMC.seasonalStatsMC.btn_next.visible = false;
         }
         if(this.currentSeasonIndex == 0)
         {
            this.panelMC.detailMC.seasonalStatsMC.btn_prev.visible = true;
            this.panelMC.detailMC.seasonalStatsMC.btn_next.visible = false;
         }
         else if(this.currentSeasonIndex == this.seasonalStats.length - 1)
         {
            this.panelMC.detailMC.seasonalStatsMC.btn_prev.visible = false;
            this.panelMC.detailMC.seasonalStatsMC.btn_next.visible = true;
         }
         else
         {
            this.panelMC.detailMC.seasonalStatsMC.btn_prev.visible = true;
            this.panelMC.detailMC.seasonalStatsMC.btn_next.visible = true;
         }
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
         var _loc2_:int = int(this.panelMC.detailMC.seasonalStatsMC.txt_search.text);
         this.currentSeasonIndex = this.getSeasonIndex(_loc2_);
         if(this.currentSeasonIndex == -1)
         {
            this.main.showMessage("Season not found");
            return;
         }
         this.renderSeasonalStats();
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
      
      private function resetTab() : void
      {
         this.panelMC.detailMC.btn_seasonal_stats.gotoAndStop(1);
         this.panelMC.detailMC.btn_overall_stats.gotoAndStop(1);
         this.panelMC.detailMC.seasonalStatsMC.visible = false;
         this.panelMC.detailMC.overallStatsMC.visible = false;
      }
      
      private function closeViewMore(param1:MouseEvent) : void
      {
         this.panelMC.detailMC.visible = false;
         this.currentSeasonIndex = 0;
      }
      
      private function getGradeColor(param1:String) : uint
      {
         switch(param1.toUpperCase())
         {
            case "S+":
               return 16766720;
            case "S":
               return 16770919;
            case "A+":
               return 14819071;
            case "A":
               return 14456831;
            case "B+":
               return 2003199;
            case "B":
               return 9955583;
            case "C+":
               return 3329330;
            case "C":
               return 7130992;
            default:
               return 16777215;
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
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}
