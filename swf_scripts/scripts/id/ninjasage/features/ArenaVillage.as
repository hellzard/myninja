package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Panels.WorldChat;
   import Popups.Confirmation;
   import Storage.ArenaBuffs;
   import Storage.Character;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ArenaVillage extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var currentSquad:String;
      
      public var main:*;
      
      public var eventHandler:EventHandler;
      
      public var confirmation:Confirmation;
      
      public var timeout:*;
      
      public var shadowWarData:Object;
      
      public var leaderboardData:Object;
      
      public var battleData:Object;
      
      public var currentPageEnemy:int = 1;
      
      public var totalPageEnemy:int = 1;
      
      public var currentPageLeaderboard:int = 1;
      
      public var totalPageLeaderboard:int = 1;
      
      public var outfits:Array = [];
      
      public var bodyArray:Array = ["upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe"];
      
      public var missionIds:Array;
      
      public var worldChat:MovieClip;
      
      public function ArenaVillage(param1:*, param2:*)
      {
         var _loc3_:Object = GameData.get("encyclopedia");
         this.missionIds = _loc3_.background;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.initButton();
         this.initUI();
         this.getShadowWarData();
      }
      
      public function initUI() : *
      {
         this.panelMC.cardMC.gotoAndStop(1);
         this.panelMC.cardMC.visible = false;
         this.panelMC.battleMC.visible = false;
         this.panelMC.leaderboardMC.visible = false;
         this.panelMC.cardMC.addFrameScript(42,this.initCardSquad);
         this.panelMC.arenaSeasonEnd.seasonTxt.text = Character.shadow_war_season.season.num;
         this.updateSeasonTime();
      }
      
      public function getShadowWarData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["7hLKu8XKMfPb",[Character.char_id,Character.sessionkey]],this.onDataResponse);
      }
      
      public function onDataResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.shadowWarData = param1;
            Character.squad_data = param1;
            if(param1.show_profile)
            {
               this.panelMC.cardMC.visible = true;
               this.panelMC.cardMC.gotoAndPlay(2);
            }
            this.main.handleVillageHUDVisibility(false);
         }
         else if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function getBattleData(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["qrlc5ErUXwhN",[Character.char_id,Character.sessionkey]],this.onBattleDataResponse);
      }
      
      public function onBattleDataResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.battleData = param1;
            this.openBattlePopup();
         }
         else if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function initCardSquad() : *
      {
         this.panelMC.cardMC.stop();
         this.panelMC.cardMC.seasonTxt.text = "Shadow War Season " + Character.shadow_war_season.season.num;
         this.panelMC.cardMC.seasonDateTxt.text = Character.shadow_war_season.season.date;
         this.panelMC.cardMC.squadIcon.gotoAndStop(Character.getSquadName(Character.squad_data.squad));
         this.panelMC.cardMC.leagueIcon.gotoAndStop(Character.squad_data.rank + 1);
         this.panelMC.cardMC.trophyTxt.text = Character.squad_data.trophy != null ? Character.squad_data.trophy : 0;
         this.panelMC.cardMC.nicknameTxt.text = "[" + Character.char_id + "] " + Character.character_name;
         this.panelMC.cardMC.squadTxt.htmlText = "You are assigned to <font color=\"#ffff00\">" + Character.getSquadFullName(Character.squad_data.squad) + "</font>";
         this.eventHandler.addListener(this.panelMC.cardMC.confirmBtn,MouseEvent.CLICK,this.closeCard);
      }
      
      public function closeCard(param1:MouseEvent) : *
      {
         this.panelMC.cardMC.visible = false;
         this.panelMC.cardMC.gotoAndStop(1);
         this.eventHandler.removeListener(this.panelMC.cardMC.confirmBtn,MouseEvent.CLICK,this.closeCard);
      }
      
      public function openBattlePopup() : *
      {
         this.panelMC.battleMC.visible = true;
         this.panelMC.battleMC.btn_prev.visible = false;
         this.totalPageEnemy = this.battleData.enemies.length;
         this.panelMC.battleMC.txt_page.text = this.currentPageEnemy + "/" + this.totalPageEnemy;
         this.updatePageTextEnemy();
         this.initBattlePopupUI();
      }
      
      public function closeBattlePopup(param1:MouseEvent) : *
      {
         this.panelMC.battleMC.visible = false;
         this.currentPageEnemy = 1;
      }
      
      public function initBattlePopupUI() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc1_:* = this.battleData.enemies[this.currentPageEnemy - 1];
         this.clearStaticFullBody();
         if(this.outfits[_loc1_.id] == null)
         {
            _loc2_ = new OutfitManager();
            _loc2_.fillOutfit(this.panelMC.battleMC.char_mc,_loc1_.set.weapon,_loc1_.set.back_item,_loc1_.set.clothing,_loc1_.set.hairstyle,_loc1_.set.face,_loc1_.set.hair_color,_loc1_.set.skin_color);
            this.outfits[_loc1_.id] = _loc2_;
         }
         else
         {
            this.outfits[_loc1_.id].fillOutfit(this.panelMC.battleMC.char_mc,_loc1_.set.weapon,_loc1_.set.back_item,_loc1_.set.clothing,_loc1_.set.hairstyle,_loc1_.set.face,_loc1_.set.hair_color,_loc1_.set.skin_color);
         }
         this.panelMC.battleMC.txt_player_name.text = Character.character_name;
         this.panelMC.battleMC.txt_player_squad.text = Character.getSquadFullName(this.shadowWarData.squad);
         this.panelMC.battleMC.txt_char_trophies.text = Character.getLeagueFullName(this.shadowWarData.rank) + " (" + this.shadowWarData.trophy + ")";
         this.panelMC.battleMC.char_leagueIcon.gotoAndStop(this.shadowWarData.rank + 1);
         this.panelMC.battleMC.char_squadMc.gotoAndStop(Character.getSquadName(this.shadowWarData.squad));
         this.panelMC.battleMC.enemy_leagueIcon.gotoAndStop(_loc1_.rank + 1);
         this.panelMC.battleMC.enemy_squadMc.gotoAndStop(Character.getSquadName(_loc1_.squad));
         this.panelMC.battleMC.txt_enemy_squad.text = Character.getSquadFullName(_loc1_.squad);
         this.panelMC.battleMC.txt_stamina.text = this.shadowWarData.energy + "/100";
         this.panelMC.battleMC.bar_stamina.scaleX = Math.max(Math.min(int(this.shadowWarData.energy) / 100,1),0);
         if(Boolean(_loc1_.set.hasOwnProperty("skills")) && _loc1_.set.skills != null)
         {
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               this.panelMC.battleMC["iconMc" + _loc3_].visible = false;
               if(_loc3_ < _loc1_.set.skills.length)
               {
                  this.panelMC.battleMC["iconMc" + _loc3_].visible = true;
                  NinjaSage.loadItemIcon(this.panelMC.battleMC["iconMc" + _loc3_],_loc1_.set.skills[_loc3_]);
               }
               _loc3_++;
            }
         }
         this.panelMC.battleMC.txt_battlefield_situation.text = "No Applied Effect.";
         if(this.shadowWarData.squads[0].squad == this.shadowWarData.squad)
         {
            _loc4_ = ArenaBuffs.getArenaBuff(Character.getSquadName(this.shadowWarData.squad));
            this.panelMC.battleMC.txt_battlefield_situation.htmlText = "Applied Effect: " + "<font color=\"#ff0000\"> " + _loc4_.debuff.name + "</font>\n" + _loc4_.debuff.description;
         }
         else if(this.shadowWarData.squads[0].squad == _loc1_.squad)
         {
            _loc4_ = ArenaBuffs.getArenaBuff(Character.getSquadName(_loc1_.squad));
            this.panelMC.battleMC.txt_battlefield_situation.htmlText = "Applied Effect: " + "<font color=\"#00ff00\"> " + _loc4_.buff.name + "</font>\n" + _loc4_.buff.description;
         }
      }
      
      public function clearStaticFullBody() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.bodyArray.length)
         {
            GF.removeAllChild(this.panelMC.battleMC.char_mc[this.bodyArray[_loc1_]]);
            _loc1_++;
         }
      }
      
      public function changePageEnemy(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPageEnemy > this.currentPageEnemy)
               {
                  ++this.currentPageEnemy;
                  this.initBattlePopupUI();
               }
               break;
            case "btn_prev":
               if(this.currentPageEnemy > 1)
               {
                  --this.currentPageEnemy;
                  this.initBattlePopupUI();
               }
         }
         this.updatePageTextEnemy();
      }
      
      public function updatePageTextEnemy() : *
      {
         this.panelMC.battleMC.txt_page.text = this.currentPageEnemy + "/" + this.totalPageEnemy;
         if(this.currentPageEnemy == this.totalPageEnemy)
         {
            this.panelMC.battleMC.btn_next.visible = false;
         }
         else
         {
            this.panelMC.battleMC.btn_next.visible = true;
         }
         if(this.currentPageEnemy <= 1)
         {
            this.panelMC.battleMC.btn_prev.visible = false;
         }
         else
         {
            this.panelMC.battleMC.btn_prev.visible = true;
         }
      }
      
      public function refreshEnemyConfirmation(param1:MouseEvent) : *
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to refresh the enemy for 40 tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.refreshEnemy);
         this.panelMC.addChild(this.confirmation);
      }
      
      public function refreshEnemy(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["9J8a1uK5OmB9",[Character.char_id,Character.sessionkey]],this.onEnemyRefreshed);
      }
      
      public function onEnemyRefreshed(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            this.battleData = param1;
            Character.account_tokens -= 40;
            this.currentPageEnemy = 1;
            this.main.HUD.setBasicData();
            this.getBattleData(null);
         }
         else if(param1.status > 1)
         {
            this.main.getNotice(param1.result || "Unknown Error");
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function refillEnergyConfirmation(param1:MouseEvent) : *
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to refill the energy for 50 tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.refillEnergy);
         this.panelMC.addChild(this.confirmation);
      }
      
      public function removeConfirmation(param1:MouseEvent) : *
      {
         if(this.confirmation != null)
         {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
         }
      }
      
      public function refillEnergy(param1:MouseEvent) : *
      {
         this.eventHandler.removeListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.refillEnergy);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["PPmHCGJdasBh",[Character.char_id,Character.sessionkey]],this.onEnergyRefilled);
      }
      
      public function onEnergyRefilled(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Energy refilled");
            Character.account_tokens -= 50;
            this.shadowWarData.energy = param1.energy;
            this.panelMC.battleMC.txt_stamina.text = this.shadowWarData.energy + "/100";
            this.panelMC.battleMC.bar_stamina.scaleX = Math.max(Math.min(int(this.shadowWarData.energy) / 100,1),0);
            this.main.HUD.setBasicData();
         }
         else if(param1.status > 1)
         {
            this.main.getNotice(param1.result || "Unknown Error");
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function startBattle(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["kUNJc8371y19",[Character.char_id,Character.sessionkey,this.battleData.enemies[this.currentPageEnemy - 1].id]],this.onBattleStarted);
      }
      
      public function onBattleStarted(param1:Object) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.is_squad_war = true;
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < this.shadowWarData.squads.length)
            {
               if(this.shadowWarData.squad == this.shadowWarData.squads[_loc4_].squad)
               {
                  _loc2_ = _loc4_ + 1;
               }
               if(this.battleData.enemies[this.currentPageEnemy - 1].squad == this.shadowWarData.squads[_loc4_].squad)
               {
                  _loc3_ = _loc4_ + 1;
               }
               _loc4_++;
            }
            Character.shadow_war_battle_data = {
               "ranks":[_loc2_,_loc3_],
               "player":this.shadowWarData.squad,
               "enemy":this.battleData.enemies[this.currentPageEnemy - 1].squad,
               "rank_1":this.shadowWarData.squads[0].squad
            };
            Character.battle_code = param1.id;
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            _loc5_ = Math.floor(Math.random() * this.missionIds.length);
            BattleManager.init(this.main.combat,this.main,BattleVars.SHADOWWAR_MATCH,this.missionIds[_loc5_]);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            BattleManager.addPlayerToTeam("enemy","char_" + this.battleData.enemies[this.currentPageEnemy - 1].id);
            BattleManager.startBattle();
            this.destroy();
         }
         else if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function openSquadInfo(param1:MouseEvent) : *
      {
         this.panelMC.leaderboardMC.visible = true;
         this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_close,MouseEvent.CLICK,this.closeLeaderboardPanel);
         this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_prev,MouseEvent.CLICK,this.changePageLeaderboard);
         this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_next,MouseEvent.CLICK,this.changePageLeaderboard);
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         switch(_loc2_)
         {
            case "KageGuardSquad":
               this.panelMC.leaderboardMC.txt_squad_name.text = "Kage Guard Squad";
               this.currentSquad = "kage";
               break;
            case "HqGuardSquad":
               this.panelMC.leaderboardMC.txt_squad_name.text = "HQ Guard";
               this.currentSquad = "hq";
               break;
            case "AmbushSquad":
               this.panelMC.leaderboardMC.txt_squad_name.text = "Ambush Squad";
               this.currentSquad = "ambush";
               break;
            case "AssaultSquad":
               this.panelMC.leaderboardMC.txt_squad_name.text = "Assault Squad";
               this.currentSquad = "assault";
               break;
            case "MedicGuardSquad":
               this.panelMC.leaderboardMC.txt_squad_name.text = "Medic Guard";
               this.currentSquad = "medic";
         }
         this.panelMC.leaderboardMC.squadMc.gotoAndStop(this.currentSquad);
         this.panelMC.leaderboardMC.txt_battlefield_desc.htmlText = "Debuff " + "<font color=\"#ffff00\"> " + ArenaBuffs.getArenaBuff(this.currentSquad).debuff.name + "</font>\n" + ArenaBuffs.getArenaBuff(this.currentSquad).debuff.description + "\n\nBuff " + "<font color=\"#ffff00\"> " + ArenaBuffs.getArenaBuff(this.currentSquad).buff.name + "</font>\n" + ArenaBuffs.getArenaBuff(this.currentSquad).buff.description;
         var _loc3_:* = 0;
         while(_loc3_ < this.shadowWarData.squads.length)
         {
            if(Character.getSquadId(this.currentSquad) == this.shadowWarData.squads[_loc3_].squad)
            {
               this.panelMC.leaderboardMC.rankMc.numberTxt.text = _loc3_ + 1;
            }
            _loc3_++;
         }
         this.initSquadLeaderboardData();
      }
      
      public function closeLeaderboardPanel(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this.panelMC.leaderboardMC["rankInfoMc_" + _loc2_].buttonMode = false;
            this.panelMC.leaderboardMC["rankInfoMc_" + _loc2_].metaData = {};
            _loc2_++;
         }
         this.panelMC.leaderboardMC.visible = false;
         this.currentPageLeaderboard = 1;
         this.totalPageLeaderboard = 1;
         this.eventHandler.removeListener(this.panelMC.leaderboardMC.btn_close,MouseEvent.CLICK,this.closeLeaderboardPanel);
      }
      
      public function initSquadLeaderboardData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["jUHDf0ZyjluX",[Character.char_id,Character.sessionkey,Character.getSquadId(this.currentSquad)]],this.leaderboardResponse);
      }
      
      public function leaderboardResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.leaderboardData = param1;
            this.showLeaderboard();
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
      }
      
      public function showLeaderboard() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageLeaderboard - 1) * 8);
            if(this.leaderboardData.players.length > _loc2_)
            {
               this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].visible = true;
               this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].txt_name.htmlText = Character.colorifyText(this.leaderboardData.players[_loc2_].id,this.leaderboardData.players[_loc2_].name,this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].txt_name);
               this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].txt_rank.text = String(_loc2_ + 1);
               this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].txt_score.text = this.leaderboardData.players[_loc2_].trophy;
               this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].leagueIcon.gotoAndStop(this.leaderboardData.players[_loc2_].rank + 1);
               this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].buttonMode = true;
               this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].metaData = {"charId":this.leaderboardData.players[_loc2_].id};
               this.eventHandler.addListener(this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_],MouseEvent.CLICK,this.openFriendProfile);
            }
            else
            {
               this.panelMC.leaderboardMC["rankInfoMc_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.totalPageLeaderboard = Math.max(Math.ceil(this.leaderboardData.players.length / 8),1);
         this.updatePageText();
      }
      
      public function openFriendProfile(param1:MouseEvent) : *
      {
         this.main.openFriendProfile(param1.currentTarget.metaData.charId,true);
      }
      
      public function changePageLeaderboard(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPageLeaderboard > this.currentPageLeaderboard)
               {
                  ++this.currentPageLeaderboard;
                  this.showLeaderboard();
               }
               break;
            case "btn_prev":
               if(this.currentPageLeaderboard > 1)
               {
                  --this.currentPageLeaderboard;
                  this.showLeaderboard();
               }
         }
         this.updatePageText();
      }
      
      public function updatePageText() : *
      {
         this.panelMC.leaderboardMC.txt_page.text = this.currentPageLeaderboard + "/" + this.totalPageLeaderboard;
      }
      
      public function updateSeasonTime() : void
      {
         if(Character.shadow_war_season.season.time == null)
         {
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:* = Character.shadow_war_season.season.time;
         var _loc5_:* = Math.floor(_loc4_ / _loc1_);
         var _loc6_:* = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         var _loc7_:* = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         this.panelMC.arenaSeasonEnd.daysTxt.text = _loc5_;
         this.panelMC.arenaSeasonEnd.hoursTxt.text = _loc6_;
         this.panelMC.arenaSeasonEnd.minutesTxt.text = _loc7_;
         this.timeout = setTimeout(this.updateSeasonTime,10000);
         Character.shadow_war_season.season.time -= 10;
      }
      
      public function initButton() : *
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_AmbushSquad,MouseEvent.CLICK,this.openSquadInfo);
         this.eventHandler.addListener(this.panelMC.btn_AssaultSquad,MouseEvent.CLICK,this.openSquadInfo);
         this.eventHandler.addListener(this.panelMC.btn_HqGuardSquad,MouseEvent.CLICK,this.openSquadInfo);
         this.eventHandler.addListener(this.panelMC.btn_KageGuardSquad,MouseEvent.CLICK,this.openSquadInfo);
         this.eventHandler.addListener(this.panelMC.btn_MedicGuardSquad,MouseEvent.CLICK,this.openSquadInfo);
         this.eventHandler.addListener(this.panelMC.btn_battle,MouseEvent.CLICK,this.getBattleData);
         this.eventHandler.addListener(this.panelMC.dropdownBtn,MouseEvent.CLICK,this.handleDropdown);
         this.eventHandler.addListener(this.panelMC.dropdownMc.close_btn,MouseEvent.CLICK,this.handleDropdown);
         this.eventHandler.addListener(this.panelMC.dropdownMc.btn_league,MouseEvent.CLICK,this.openArenaLeague);
         this.eventHandler.addListener(this.panelMC.dropdownMc.btn_rewards,MouseEvent.CLICK,this.openArenaRewards);
         this.eventHandler.addListener(this.panelMC.dropdownMc.btn_leaderboard,MouseEvent.CLICK,this.openArenaLeaderboard);
         this.eventHandler.addListener(this.panelMC.dropdownMc.btn_hint,MouseEvent.CLICK,this.openPresetSelection);
         this.eventHandler.addListener(this.panelMC.dropdownMc.btn_card,MouseEvent.CLICK,this.openCardProfile);
         this.eventHandler.addListener(this.panelMC.dropdownMc.btn_leaderboardRealtime,MouseEvent.CLICK,this.openRealtimeLeaderboard);
         this.eventHandler.addListener(this.panelMC.dropdownMc.btn_WorldChat,MouseEvent.CLICK,this.openChat);
         this.eventHandler.addListener(this.panelMC.battleMC.btn_close,MouseEvent.CLICK,this.closeBattlePopup);
         this.eventHandler.addListener(this.panelMC.battleMC.btn_prev,MouseEvent.CLICK,this.changePageEnemy);
         this.eventHandler.addListener(this.panelMC.battleMC.btn_next,MouseEvent.CLICK,this.changePageEnemy);
         this.eventHandler.addListener(this.panelMC.battleMC.btn_change_enemy,MouseEvent.CLICK,this.refreshEnemyConfirmation);
         this.eventHandler.addListener(this.panelMC.battleMC.btn_restore,MouseEvent.CLICK,this.refillEnergyConfirmation);
         this.eventHandler.addListener(this.panelMC.battleMC.btn_fight,MouseEvent.CLICK,this.startBattle);
      }
      
      public function handleDropdown(param1:MouseEvent) : *
      {
         this.panelMC.dropdownMc.visible = !this.panelMC.dropdownMc.visible;
      }
      
      public function openChat(param1:MouseEvent) : void
      {
         this.worldChat = new WorldChat(this.main);
         this.main.loader.addChild(this.worldChat);
      }
      
      public function openCardProfile(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("ArenaStatistic","ArenaStatistic");
      }
      
      public function openRealtimeLeaderboard(param1:MouseEvent) : *
      {
         navigateToURL(new URLRequest("http://127.0.0.1:800/en/leaderboards/shadow-war/realtime"));
      }
      
      public function openArenaLeague(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("ArenaLeague","ArenaLeague");
      }
      
      public function openArenaRewards(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("ArenaRewards","ArenaRewards");
      }
      
      public function openArenaLeaderboard(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("ArenaLeaderboard","ArenaLeaderboard");
      }
      
      public function openPresetSelection(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("ArenaPreset","ArenaPreset");
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.main.handleVillageHUDVisibility(true);
         this.destroy();
      }
      
      public function destroy() : *
      {
         var _loc2_:* = undefined;
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this.outfits != null && this.outfits.length > 0)
         {
            for(_loc2_ in this.outfits)
            {
               this.outfits[_loc2_].destroy();
               delete this.outfits[_loc2_];
            }
         }
         if(this.worldChat)
         {
            this.worldChat.destroy();
         }
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            GF.removeAllChild(this.panelMC.battleMC["iconMc" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.battleMC["iconMc" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         this.worldChat = null;
         this.outfits = [];
         this.bodyArray = [];
         this.missionIds = [];
         GF.removeAllChild(this.panelMC.battleMC.char_mc);
         GF.removeAllChild(this.panelMC.battleMC);
         GF.removeAllChild(this.panelMC.leaderboardMC);
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         OutfitManager.clearStaticMc();
         this.outfits = null;
         this.main = null;
         this.eventHandler = null;
         this.shadowWarData = null;
         this.leaderboardData = null;
         this.battleData = null;
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         this.timeout = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

