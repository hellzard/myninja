package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.StatManager;
   import Storage.Character;
   import Storage.EnemyInfo;
   import Storage.GameData;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class MonsterHunter extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var rewardsArray:Array;
      
      private var response:Object;
      
      private var enemyStats:String;
      
      public function MonsterHunter(param1:*, param2:*)
      {
         var _loc3_:* = GameData.get("monster_hunter");
         this.rewardsArray = _loc3_.rewards;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.getEventData();
      }
      
      private function getEventData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("vnB7P8simcleapK1.rqZYazLcWOgx",[Character.char_id,Character.sessionkey],this.onShow);
      }
      
      private function onShow(param1:Object = null) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.initUI();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function initUI() : *
      {
         this.main.handleVillageHUDVisibility(false);
         this.eventHandler.addListener(this.panelMC.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.panelMC.convertBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.panelMC.goBattleBtn,MouseEvent.CLICK,this.startEventFight);
         this.eventHandler.addListener(this.panelMC.panelMC.materialMarketBtn,MouseEvent.CLICK,this.openMaterialMarket);
         this.panelMC.panelMC.lvMc.lvLow.txt.text = Character.character_lvl;
         this.panelMC.panelMC.lvMc.lvHigh.txt.text = int(Character.character_lvl) + 5;
         this.panelMC.panelMC.detailGoldTxt.text = int(Character.character_lvl) * 2500 / 40;
         this.panelMC.panelMC.detailXpTxt.text = int(Character.character_lvl) * 2500 / 40;
         this.panelMC.panelMC.goldTxt.text = Character.character_gold;
         this.panelMC.panelMC.tokenTxt.text = String(Character.account_tokens);
         this.panelMC.panelMC.teamMemberTxt.text = Character.character_recruit_ids.length + "/2";
         this.panelMC.panelMC.energyTxt.text = this.response.energy + "/100";
         this.panelMC.panelMC.EnergyProcessBar.scaleX = this.response.energy / 97;
         this.loadRewardIcon();
         this.loadMonsterIcon();
      }
      
      private function startEventFight(param1:MouseEvent) : *
      {
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.main.showMessage("Please equip at least 1 skill");
            return;
         }
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = this.response.boss_id;
         Character.christmas_boss_num = 0;
         Character.christmas_boss_id = _loc5_;
         _loc2_ = StatManager.calculate_stats_with_data("agility");
         _loc3_ = EnemyInfo.getCopy(_loc5_);
         this.enemyStats = "id:" + _loc3_["enemy_id"] + "|hp:" + _loc3_["enemy_hp"] + "|agility:" + _loc3_["enemy_agility"];
         _loc4_ = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.char_id) + String(_loc5_))));
         this.main.loading(true);
         this.main.amf_manager.service("vnB7P8simcleapK1.L0ZnAYiHcaRE",[Character.char_id,_loc5_,_loc4_,Character.sessionkey],this.onStartEventAmf);
      }
      
      private function onStartEventAmf(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(param1.hash != Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(String(Character.christmas_boss_id) + param1.code + String(Character.char_id)))))
            {
               this.main.showMessage(param1.result);
               return;
            }
            Character.is_monster_hunter_event = true;
            Character.battle_code = param1.code;
            Character.mission_id = "mission_1024";
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.EVENT_MATCH,Character.mission_id);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            BattleManager.addPlayerToTeam("enemy",Character.christmas_boss_id);
            BattleManager.startBattle();
            this.destroy();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function loadMonsterIcon() : *
      {
         NinjaSage.loadIconSWF("enemy",this.response.boss_id,this.panelMC.panelMC.enemyHolder,this.response.boss_id);
         this.panelMC.panelMC.enemyHolder.scaleX = 0.5;
         this.panelMC.panelMC.enemyHolder.scaleY = 0.5;
      }
      
      private function loadRewardIcon() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.rewardsArray.length)
         {
            NinjaSage.loadItemIcon(this.panelMC.panelMC["rewardItem" + _loc1_].iconHolder,this.rewardsArray[_loc1_],"icon");
            _loc1_++;
         }
      }
      
      private function openRecharge(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openMaterialMarket(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.MaterialMarket");
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
         this.main.handleVillageHUDVisibility(true);
         NinjaSage.clearLoader();
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         var _loc1_:* = 0;
         while(_loc1_ < this.rewardsArray.length)
         {
            this.panelMC.panelMC["rewardItem" + _loc1_].tooltip = null;
            GF.removeAllChild(this.panelMC.panelMC["rewardItem" + _loc1_].iconHolder);
            _loc1_++;
         }
         GF.removeAllChild(this.panelMC.panelMC.enemyHolder);
         this.rewardsArray = [];
         this.main = null;
         this.eventHandler = null;
         this.response = null;
         this.enemyStats = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
