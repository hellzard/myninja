package id.ninjasage.pvp
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EventHandler;
   
   public dynamic class BattleHistory extends MovieClip
   {
       
      
      public var pageMC:MovieClip;
      
      public var activityMC0:MovieClip;
      
      public var activityMC1:MovieClip;
      
      public var activityMC2:MovieClip;
      
      public var activityMC3:MovieClip;
      
      public var battleDetailMC:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var pageTxt:TextField;
      
      public var titleTxt:TextField;
      
      public var currentPage:int = 1;
      
      public var totalPage:int = 1;
      
      public var response;
      
      public var details;
      
      public var eventHandler;
      
      public var pvp:PvP;
      
      public function BattleHistory()
      {
         super();
         this.eventHandler = new EventHandler();
      }
      
      public function setContext(param1:PvP) : void
      {
         this.pvp = param1;
      }
      
      public function activate() : void
      {
         this.visible = true;
         this.getActivityData();
      }
      
      public function deactivate() : void
      {
         this.visible = false;
         this.eventHandler.removeAllEventListeners();
      }
      
      public function getActivityData() : void
      {
         this.battleDetailMC.visible = false;
         this.battleDetailMC.btn_replay.visible = false;
         this.pvp.main.loading(true);
         this.pvp.main.amf_manager.service("jpwzlvqNru201CF3.tJqe7b7H7n5Y",[Character.char_id,Character.sessionkey],this.responseActivityData);
      }
      
      public function responseActivityData(param1:Object) : void
      {
         this.pvp.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.initUI();
            this.initButton();
         }
         else
         {
            this.pvp.main.getNotice(param1.result || "Unknown Error");
         }
      }
      
      public function initUI() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 4);
            if(this.response.battles.length > _loc2_)
            {
               this["activityMC" + _loc1_].visible = true;
               this["activityMC" + _loc1_].playerContent.playerRankMC.gotoAndStop(this.response.battles[_loc2_].host.rank);
               this["activityMC" + _loc1_].enemyContent.playerRankMC.gotoAndStop(this.response.battles[_loc2_].enemy.rank);
               this["activityMC" + _loc1_].winLoseTxt.text = (this.response.battles[_loc2_].won == true ? "VICTORY" : "DEFEAT") + (this.response.battles[_loc2_].type != "" ? "    —    " + this.response.battles[_loc2_].type : "");
               this["activityMC" + _loc1_].winLoseTrophyTxt.text = this.response.battles[_loc2_].trophy;
               if(this.response.battles[_loc2_].host.id == Character.char_id)
               {
                  this["activityMC" + _loc1_].playerContent.playerNameTxt.htmlText = Character.colorifyText(this.response.battles[_loc2_].host.id,this.response.battles[_loc2_].host.name,this["activityMC" + _loc1_].playerContent.playerNameTxt);
                  this["activityMC" + _loc1_].playerContent.playerTrophyTxt.text = this.response.battles[_loc2_].host.trophy;
                  this["activityMC" + _loc1_].playerContent.lvTxt.text = this.response.battles[_loc2_].host.level;
                  this["activityMC" + _loc1_].playerContent.leagueMC.gotoAndStop(this.response.battles[_loc2_].host.league + 1);
                  this["activityMC" + _loc1_].enemyContent.playerNameTxt.htmlText = Character.colorifyText(this.response.battles[_loc2_].enemy.id,this.response.battles[_loc2_].enemy.name,this["activityMC" + _loc1_].enemyContent.playerNameTxt);
                  this["activityMC" + _loc1_].enemyContent.playerTrophyTxt.text = this.response.battles[_loc2_].enemy.trophy;
                  this["activityMC" + _loc1_].enemyContent.lvTxt.text = this.response.battles[_loc2_].enemy.level;
                  this["activityMC" + _loc1_].enemyContent.leagueMC.gotoAndStop(this.response.battles[_loc2_].enemy.league + 1);
               }
               else
               {
                  this["activityMC" + _loc1_].enemyContent.playerNameTxt.htmlText = Character.colorifyText(this.response.battles[_loc2_].enemy.id,this.response.battles[_loc2_].enemy.name,this["activityMC" + _loc1_].enemyContent.playerNameTxt);
                  this["activityMC" + _loc1_].enemyContent.playerTrophyTxt.text = this.response.battles[_loc2_].enemy.trophy;
                  this["activityMC" + _loc1_].enemyContent.lvTxt.text = this.response.battles[_loc2_].enemy.level;
                  this["activityMC" + _loc1_].enemyContent.leagueMC.gotoAndStop(this.response.battles[_loc2_].enemy.league + 1);
                  this["activityMC" + _loc1_].playerContent.playerNameTxt.htmlText = Character.colorifyText(this.response.battles[_loc2_].host.id,this.response.battles[_loc2_].host.name,this["activityMC" + _loc1_].playerContent.playerNameTxt);
                  this["activityMC" + _loc1_].playerContent.playerTrophyTxt.text = this.response.battles[_loc2_].host.trophy;
                  this["activityMC" + _loc1_].playerContent.lvTxt.text = this.response.battles[_loc2_].host.level;
                  this["activityMC" + _loc1_].playerContent.leagueMC.gotoAndStop(this.response.battles[_loc2_].host.league + 1);
               }
               this["activityMC" + _loc1_].dateTxt.text = this.response.battles[_loc2_].date;
               this["activityMC" + _loc1_].battle_id = this.response.battles[_loc2_].id;
               this.eventHandler.addListener(this["activityMC" + _loc1_],MouseEvent.CLICK,this.openBattleDetail);
               this["activityMC" + _loc1_].buttonMode = true;
            }
            else
            {
               this["activityMC" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.totalPage = Math.max(Math.ceil(this.response.battles.length / 4),1);
         this.updatePageText();
      }
      
      public function openBattleDetail(param1:MouseEvent) : void
      {
         this.pvp.main.loading(true);
         this.pvp.main.amf_manager.service("jpwzlvqNru201CF3.hNr7x0varVb9",[Character.char_id,Character.sessionkey,param1.currentTarget.battle_id],this.onBattleDetailResponse);
      }
      
      public function onBattleDetailResponse(param1:Object) : void
      {
         this.pvp.main.loading(false);
         if(param1.status == 1)
         {
            this.details = param1;
            this.initDetailsUI();
         }
         else
         {
            this.pvp.main.getNotice(param1.result || "Unknown Error");
         }
      }
      
      public function initDetailsUI() : void
      {
         this.battleDetailMC.visible = true;
         this.eventHandler.addListener(this.battleDetailMC.bg_close,MouseEvent.CLICK,this.closeBattleDetail);
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            this.battleDetailMC["player_skill_" + _loc1_].visible = false;
            this.battleDetailMC["enemy_skill_" + _loc1_].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.details.host.skills.length)
         {
            this.battleDetailMC["player_skill_" + _loc1_].visible = true;
            NinjaSage.loadItemIcon(this.battleDetailMC["player_skill_" + _loc1_],this.details.host.skills[_loc1_]);
            this.battleDetailMC["player_skill_" + _loc1_].ownedTxt.text = "";
            this.battleDetailMC["player_skill_" + _loc1_].amountTxt.text = "";
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.details.enemy.skills.length)
         {
            this.battleDetailMC["enemy_skill_" + _loc1_].visible = true;
            NinjaSage.loadItemIcon(this.battleDetailMC["enemy_skill_" + _loc1_],this.details.enemy.skills[_loc1_]);
            this.battleDetailMC["enemy_skill_" + _loc1_].ownedTxt.text = "";
            this.battleDetailMC["enemy_skill_" + _loc1_].amountTxt.text = "";
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            if(this.details.host.talents[_loc1_] != null)
            {
               this.battleDetailMC["player_talent_" + _loc1_].gotoAndStop(this.details.host.talents[_loc1_]);
            }
            if(this.details.enemy.talents[_loc1_] != null)
            {
               this.battleDetailMC["enemy_talent_" + _loc1_].gotoAndStop(this.details.enemy.talents[_loc1_]);
            }
            _loc1_++;
         }
         var _loc2_:* = ["clothing","accessory","back_item","weapon"];
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.battleDetailMC["player_item_" + _loc1_].visible = false;
            this.battleDetailMC["enemy_item_" + _loc1_].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            if(this.details.host.set[_loc2_[_loc1_]] != null)
            {
               this.battleDetailMC["player_item_" + _loc1_].visible = true;
               NinjaSage.loadItemIcon(this.battleDetailMC["player_item_" + _loc1_],this.details.host.set[_loc2_[_loc1_]]);
               this.battleDetailMC["player_item_" + _loc1_].ownedTxt.text = "";
               this.battleDetailMC["player_item_" + _loc1_].amountTxt.text = "";
            }
            if(this.details.enemy.set[_loc2_[_loc1_]] != null)
            {
               this.battleDetailMC["enemy_item_" + _loc1_].visible = true;
               NinjaSage.loadItemIcon(this.battleDetailMC["enemy_item_" + _loc1_],this.details.enemy.set[_loc2_[_loc1_]]);
               this.battleDetailMC["enemy_item_" + _loc1_].ownedTxt.text = "";
               this.battleDetailMC["enemy_item_" + _loc1_].amountTxt.text = "";
            }
            _loc1_++;
         }
         this.battleDetailMC.player_classMC.gotoAndStop(this.details.host.special_class);
         this.battleDetailMC.enemy_classMC.gotoAndStop(this.details.enemy.special_class);
         this.battleDetailMC.winLoseTxt.text = this.details.won == true ? "VICTORY" : "DEFEAT";
         this.battleDetailMC.winLoseTrophyTxt.text = this.details.trophy;
         this.battleDetailMC.playerNameTxt.htmlText = Character.colorifyText(this.details.host.id,this.details.host.name,this.battleDetailMC.playerNameTxt);
         this.battleDetailMC.playerTrophyTxt.text = this.details.host.trophy;
         this.battleDetailMC.playerLeagueMC.gotoAndStop(this.details.host.league + 1);
         NinjaSage.showDynamicTooltip(this.battleDetailMC.playerLeagueMC,this.details.host.league_name);
         this.battleDetailMC.playerLvTxt.text = this.details.host.level;
         this.battleDetailMC.enemyNameTxt.htmlText = Character.colorifyText(this.details.enemy.id,this.details.enemy.name,this.battleDetailMC.enemyNameTxt);
         this.battleDetailMC.enemyTrophyTxt.text = this.details.enemy.trophy;
         this.battleDetailMC.enemyLeagueMC.gotoAndStop(this.details.enemy.league + 1);
         NinjaSage.showDynamicTooltip(this.battleDetailMC.enemyLeagueMC,this.details.enemy.league_name);
         this.battleDetailMC.enemyLvTxt.text = this.details.enemy.level;
         this.battleDetailMC.dateTxt.text = this.details.date;
         this.pvp.main.outfit_manager.fillHead(this.battleDetailMC.player_head,this.details.host.set.hairstyle,this.details.host.set.face,this.details.host.set.hair_color,this.details.host.set.skin_color);
         this.pvp.main.outfit_manager.fillHead(this.battleDetailMC.enemy_head,this.details.enemy.set.hairstyle,this.details.enemy.set.face,this.details.enemy.set.hair_color,this.details.enemy.set.skin_color);
      }
      
      public function closeBattleDetail(param1:MouseEvent) : void
      {
         this.battleDetailMC.visible = false;
         var _loc2_:* = 0;
         while(_loc2_ < 8)
         {
            GF.removeAllChild(this.battleDetailMC["player_skill_" + _loc2_].holder);
            GF.removeAllChild(this.battleDetailMC["enemy_skill_" + _loc2_].holder);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            GF.removeAllChild(this.battleDetailMC["player_item_" + _loc2_].iconHolder);
            GF.removeAllChild(this.battleDetailMC["enemy_item_" + _loc2_].iconHolder);
            _loc2_++;
         }
         GF.removeAllChild(this.battleDetailMC.player_head.hair);
         GF.removeAllChild(this.battleDetailMC.player_head.face);
         GF.removeAllChild(this.battleDetailMC.enemy_head.hair);
         GF.removeAllChild(this.battleDetailMC.enemy_head.face);
         this.details = null;
      }
      
      public function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.initUI();
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.initUI();
               }
         }
         this.updatePageText();
      }
      
      public function initButton() : void
      {
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
      }
      
      public function updatePageText() : *
      {
         this.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.eventHandler.removeAllEventListeners();
         this.visible = false;
         this.currentPage = 1;
         this.totalPage = 1;
         this.response = null;
      }
      
      public function destroy() : *
      {
         this.currentPage = 0;
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
         }
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            this["activityMC" + _loc1_].buttonMode = false;
            this["activityMC" + _loc1_].battle_id = null;
            _loc1_++;
         }
         NinjaSage.clearLoader();
         this.eventHandler = null;
         this.response = null;
         this.visible = false;
      }
   }
}
