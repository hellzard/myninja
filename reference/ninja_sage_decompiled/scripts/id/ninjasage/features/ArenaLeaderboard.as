package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.ArenaBuffs;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ArenaLeaderboard extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var currentPage:int = 1;
      
      public var totalPage:int;
      
      public var currentSquad:int = 0;
      
      public var main;
      
      public var eventHandler:EventHandler;
      
      public var overallRanking:Object;
      
      public function ArenaLeaderboard(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.loadLeaderboardData();
         this.initButton();
      }
      
      public function loadLeaderboardData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["v2gxCtmN4kOH",[Character.char_id,Character.sessionkey]],this.leaderboardResponse);
      }
      
      public function leaderboardResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.overallRanking = param1;
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.initUI();
      }
      
      public function initUI() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            this.panelMC["rankMc_" + _loc1_].numberTxt.text = String(_loc1_ + 1);
            this.panelMC["squadScore_" + _loc1_].text = this.overallRanking.squads[_loc1_].trophy;
            this.panelMC["squadMc_" + _loc1_].gotoAndStop(Character.getSquadName(this.overallRanking.squads[_loc1_].squad));
            NinjaSage.showDynamicTooltip(this.panelMC["squadMc_" + _loc1_],Character.getSquadFullName(this.overallRanking.squads[_loc1_].squad).toUpperCase());
            _loc1_++;
         }
         this.updateEffectData(null);
         this.showLeaderboard();
      }
      
      public function showLeaderboard() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 5);
            if(this.overallRanking.players.length > _loc2_)
            {
               this.panelMC["rankInfoMc_" + _loc1_].visible = true;
               this.panelMC["rankInfoMc_" + _loc1_].txt_name.htmlText = Character.colorifyText(this.overallRanking.players[_loc2_].id,this.overallRanking.players[_loc2_].name,this.panelMC["rankInfoMc_" + _loc1_].txt_name);
               this.panelMC["rankInfoMc_" + _loc1_].txt_rank.text = String(_loc2_ + 1);
               this.panelMC["rankInfoMc_" + _loc1_].txt_score.text = this.overallRanking.players[_loc2_].trophy;
               this.panelMC["rankInfoMc_" + _loc1_].leagueIcon.gotoAndStop(this.overallRanking.players[_loc2_].rank + 1);
               this.panelMC["rankInfoMc_" + _loc1_].squadMc.gotoAndStop(Character.getSquadName(this.overallRanking.players[_loc2_].squad));
               this.panelMC["rankInfoMc_" + _loc1_].buttonMode = true;
               this.panelMC["rankInfoMc_" + _loc1_].metaData = {"charId":this.overallRanking.players[_loc2_].id};
               this.eventHandler.addListener(this.panelMC["rankInfoMc_" + _loc1_],MouseEvent.CLICK,this.openFriendProfile);
            }
            else
            {
               this.panelMC["rankInfoMc_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.totalPage = Math.max(Math.ceil(this.overallRanking.players.length / 5),1);
         this.updatePageText();
      }
      
      public function setCurrentSquad(param1:MouseEvent) : *
      {
         this.currentSquad = param1.currentTarget.name.replace("squadMc_","");
         this.loadLeaderboardData();
      }
      
      public function openFriendProfile(param1:MouseEvent) : *
      {
         this.main.openFriendProfile(param1.currentTarget.metaData.charId,true);
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.showLeaderboard();
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.showLeaderboard();
               }
         }
         this.updatePageText();
      }
      
      public function updatePageText() : *
      {
         this.panelMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      public function updateEffectData(param1:MouseEvent) : *
      {
         if(param1 is MouseEvent)
         {
            this.currentSquad = param1.currentTarget.name.replace("squadMc_","");
         }
         this.panelMC.txt_squad_desc.htmlText = "Debuff " + "<font color=\"#ffff00\"> " + ArenaBuffs.getArenaBuff(Character.getSquadName(this.overallRanking.squads[this.currentSquad].squad)).debuff.name + "</font>\n" + ArenaBuffs.getArenaBuff(Character.getSquadName(this.overallRanking.squads[this.currentSquad].squad)).debuff.description + "\n\nBuff " + "<font color=\"#ffff00\"> " + ArenaBuffs.getArenaBuff(Character.getSquadName(this.overallRanking.squads[this.currentSquad].squad)).buff.name + "</font>\n" + ArenaBuffs.getArenaBuff(Character.getSquadName(this.overallRanking.squads[this.currentSquad].squad)).buff.description;
      }
      
      public function initButton() : *
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            this.eventHandler.addListener(this.panelMC["squadMc_" + _loc1_],MouseEvent.CLICK,this.updateEffectData);
            _loc1_++;
         }
      }
      
      public function closePanel(param1:MouseEvent) : *
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
         NinjaSage.clearEventListener();
         this.main = null;
         this.eventHandler = null;
         this.overallRanking = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
