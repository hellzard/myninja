package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ArenaRewards extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var squadData:Object;
      
      private var winnerSquadData:Object;
      
      private var topGlobalData:Object;
      
      private var leagueRewardData:Object;
      
      private var tempLoader:BulkLoader;
      
      private const REWARD_API:String = "https://ninjasage.id/api/event/sw";
      
      public function ArenaRewards(param1:*, param2:*)
      {
         this.squadData = [];
         this.winnerSquadData = [];
         this.topGlobalData = [];
         this.leagueRewardData = [];
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_league,MouseEvent.CLICK,this.openPopupLeague);
         this.eventHandler.addListener(this.panelMC.leagueMC.bg,MouseEvent.CLICK,this.closePopupLeague);
         this.tempLoader = BulkLoader.createUniqueNamedLoader(1,BulkLoader.LOG_INFO);
         this.getRewardData();
      }
      
      private function getRewardData() : void
      {
         this.main.loading(true);
         this.tempLoader.add(this.REWARD_API,{
            "id":"api",
            "type":BulkLoader.TYPE_TEXT
         });
         this.tempLoader.addEventListener(BulkLoader.COMPLETE,this.onLoaded);
         this.tempLoader.addEventListener(BulkLoader.ERROR,this.onLoadError);
         this.tempLoader.start();
      }
      
      private function onLoaded(param1:BulkProgressEvent) : void
      {
         this.main.loading(false);
         var _loc2_:Object = JSON.parse(this.tempLoader.getContent("api"));
         this.squadData = _loc2_.data.squad;
         this.winnerSquadData = _loc2_.data.winner_squad;
         this.topGlobalData = _loc2_.data.top_global;
         this.leagueRewardData = _loc2_.data.league;
         this.initUI();
      }
      
      private function onLoadError(param1:ErrorEvent) : *
      {
         this.main.loading(false);
         this.destroy();
      }
      
      private function initUI() : *
      {
         this.panelMC.titleTxt.text = "Season " + Character.shadow_war_season.season.num + " Shadow War Rewards";
         this.panelMC.leagueMC.visible = false;
         this.loadRewardIcons(this.squadData,"squad_");
         this.loadRewardIcons(this.winnerSquadData,"winner_squad_");
         this.loadRewardIcons(this.topGlobalData,"top_global_");
         this.loadLeagueRewards();
         this.panelMC.league_sq0.gotoAndStop(8);
         this.panelMC.league_sq1.gotoAndStop(8);
         this.panelMC.league_sq2.gotoAndStop(7);
         this.panelMC.league_sq3.gotoAndStop(6);
         this.panelMC.league_sq4.gotoAndStop(5);
      }
      
      private function loadRewardIcons(param1:Object, param2:String) : void
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Array = [];
         for(_loc4_ in param1)
         {
            _loc3_.push(_loc4_);
         }
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = 0;
            while(_loc6_ < param1[_loc3_[_loc5_]].length)
            {
               NinjaSage.loadItemIcon(this.panelMC[param2 + _loc3_[_loc5_].replace("-","_")]["iconMc" + _loc6_],param1[_loc3_[_loc5_]][_loc6_]);
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      private function loadLeagueRewards() : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         for(_loc2_ in this.leagueRewardData)
         {
            _loc1_.push(_loc2_);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            this.panelMC["leagueMC"]["league" + _loc3_].gotoAndStop(_loc3_ + 4);
            _loc4_ = 0;
            while(_loc4_ < this.leagueRewardData[_loc1_[_loc3_]].length)
            {
               NinjaSage.loadItemIcon(this.panelMC["leagueMC"][_loc1_[_loc3_]]["iconMc" + _loc4_],this.leagueRewardData[_loc1_[_loc3_]][_loc4_]);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function openPopupLeague(param1:MouseEvent) : *
      {
         this.panelMC.leagueMC.visible = true;
      }
      
      private function closePopupLeague(param1:MouseEvent) : *
      {
         this.panelMC.leagueMC.visible = false;
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.main = null;
         this.eventHandler = null;
         this.rewardData = null;
         this.leagueRewardData = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
