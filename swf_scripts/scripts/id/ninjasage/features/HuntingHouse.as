package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Storage.Character;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.utils.ByteArray;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class HuntingHouse extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var bosses:Array;
      
      private var energy:int;
      
      private var amount:int = 1;
      
      private const price:int = 5;
      
      private var cost:int = 0;
      
      private var bossIdx:int;
      
      private var response:Object;
      
      private var currentDif:String;
      
      private var currentZone:int;
      
      private var currentBoss:Array;
      
      private const KARI_BADGE:String = "material_509";
      
      private const HARD_BOSS_REQUIREMENT:int = 10;
      
      private const EASY_BOSS_REQUIREMENT:int = 5;
      
      public function HuntingHouse(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.destroy);
         this.eventHandler = new EventHandler();
         this.getData();
      }
      
      private function getData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("JDEUnbiWJXOtHxVv.FEoUCYCZHIb7",[Character.char_id,Character.sessionkey],this.onGetDataResponse);
      }
      
      private function onGetDataResponse(param1:Object = null) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.setWorldMap();
            this.initUI();
            if(!this.response.daily_claim)
            {
               this.openDailyClaim();
            }
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
      
      private function initUI() : *
      {
         this.main.handleVillageHUDVisibility(false);
         this.panelMC.panelMC.popupBuyItemMc.visible = false;
         this.panelMC.panelMC.bossDetailMc.visible = false;
         this.panelMC.panelMC.HuntingDarenMC.visible = false;
         this.panelMC.panelMC.dailyMc.visible = false;
         var _loc1_:* = 1;
         while(_loc1_ < 5)
         {
            this.panelMC.panelMC.WorldMapMc["eventBoss" + _loc1_].visible = false;
            this.panelMC.panelMC.WorldMapMc["eventBossBg" + _loc1_].visible = false;
            _loc1_++;
         }
         this.panelMC.panelMC.titleTxt.text = "Hunting House";
         this.panelMC.panelMC.subTitle.text = "Click any Boss Icon to Start";
         this.panelMC.panelMC.lbl_recruited.text = "Team";
         this.panelMC.panelMC.recruitedTxt.text = Character.character_recruit_ids.length + "/2";
         this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
         this.panelMC.panelMC.HuntingTicketTxt.text = this.response.material;
         this.main.initButton(this.panelMC.panelMC.getDailyItemBtn,this.openMenu,"");
         this.main.initButton(this.panelMC.panelMC.getMoreBtn,this.openMenu,"");
         this.main.initButton(this.panelMC.panelMC.getMoreItemBtn,this.openMenu,"Get More!");
         this.main.initButton(this.panelMC.panelMC.goForgePanelBtn,this.openMenu,"Material Bag");
         this.main.initButton(this.panelMC.panelMC.recruitFriendBtn,this.openMenu,"Recruit");
         this.eventHandler.addListener(this.panelMC.panelMC.btnClose,MouseEvent.CLICK,this.openMenu);
      }
      
      private function setWorldMap() : *
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = this.panelMC.panelMC.WorldMapMc;
         while(_loc1_ < 5)
         {
            if(this.response.zones[_loc1_].hardBoss == null && this.response.zones[_loc1_].easyBoss == null)
            {
               _loc3_["EasyBoss" + int(_loc1_ + 1)].visible = false;
               _loc3_["HardBoss" + int(_loc1_ + 1)].visible = false;
            }
            else if(this.response.zones[_loc1_].hardBoss != null && this.response.zones[_loc1_].easyBoss == null)
            {
               _loc3_["EasyBoss" + int(_loc1_ + 1)].visible = false;
               _loc3_["HardBoss" + int(_loc1_ + 1)].visible = true;
               _loc3_["HardBoss" + int(_loc1_ + 1)].lvMc.lvLow.txt.text = String(int(Character.character_lvl) - 5);
               _loc3_["HardBoss" + int(_loc1_ + 1)].lvMc.lvHigh.txt.text = String(int(Character.character_lvl) + 10);
               this.main.initButton(_loc3_["HardBoss" + int(_loc1_ + 1)],this.openBossDetail,"");
               NinjaSage.loadIconSWF("enemy",this.response.zones[_loc1_].hardBoss[0],_loc3_["HardBoss" + int(_loc1_ + 1)].bossHolder1,"enemy_head");
               NinjaSage.loadIconSWF("enemy",this.response.zones[_loc1_].hardBoss[1],_loc3_["HardBoss" + int(_loc1_ + 1)].bossHolder2,"enemy_head");
            }
            else if(this.response.zones[_loc1_].hardBoss == null && this.response.zones[_loc1_].easyBoss != null)
            {
               _loc3_["EasyBoss" + int(_loc1_ + 1)].visible = true;
               _loc3_["HardBoss" + int(_loc1_ + 1)].visible = false;
               _loc3_["EasyBoss" + int(_loc1_ + 1)].lvMc.lvLow.txt.text = String(int(Character.character_lvl) - 5);
               _loc3_["EasyBoss" + int(_loc1_ + 1)].lvMc.lvHigh.txt.text = String(int(Character.character_lvl) + 10);
               this.main.initButton(_loc3_["EasyBoss" + int(_loc1_ + 1)],this.openBossDetail,"");
               NinjaSage.loadIconSWF("enemy",this.response.zones[_loc1_].easyBoss[0],_loc3_["EasyBoss" + int(_loc1_ + 1)].bossHolder1,"enemy_head");
            }
            _loc1_++;
         }
      }
      
      private function openBossDetail(param1:MouseEvent) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         this.panelMC.panelMC.bossDetailMc.visible = true;
         var _loc2_:* = this.panelMC.panelMC.bossDetailMc.panel;
         var _loc3_:* = param1.currentTarget.name;
         var _loc4_:int = undefined;
         if(_loc3_.indexOf("HardBoss") != -1)
         {
            _loc2_.gotoAndStop("hard");
            _loc5_ = _loc3_.replace("HardBoss","");
            _loc4_ = _loc5_ - 1;
            this.currentZone = int(_loc4_);
            this.currentDif = "HardBoss";
            this.currentBoss = this.response["zones"][_loc4_].hardBoss;
            _loc2_.huntingPassMc.HuntingTicketTxt.text = String(this.HARD_BOSS_REQUIREMENT);
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc6_ < 10)
            {
               _loc8_ = _loc6_ + 0 * 10;
               while(_loc7_ < 2)
               {
                  _loc9_ = this.response.bosses[this.currentBoss[_loc7_]];
                  _loc2_["detailMc" + _loc7_].nameTxt.text = _loc9_.name;
                  _loc2_["detailMc" + _loc7_].decTxt.text = _loc9_.description;
                  _loc2_["detailMc" + _loc7_].goldMc.txt.text = String(int(Character.character_lvl) * 220 / 50);
                  _loc2_["detailMc" + _loc7_].xpMc.txt.text = String(int(Character.character_lvl) * 250 / 40);
                  _loc2_["detailMc" + _loc7_].lvMc.lvLow.txt.text = String(int(Character.character_lvl) - 5);
                  _loc2_["detailMc" + _loc7_].lvMc.lvHigh.txt.text = String(int(Character.character_lvl) + 10);
                  _loc2_["detailMc" + _loc7_].bgMc.gotoAndStop(_loc4_);
                  if(_loc9_.rewards.length > _loc8_)
                  {
                     _loc2_["detailMc" + _loc7_]["item" + _loc6_].visible = true;
                     if(!_loc2_["detailMc" + _loc7_]["item" + _loc6_].holder.filled)
                     {
                        NinjaSage.loadItemIcon(_loc2_["detailMc" + _loc7_]["item" + _loc6_].holder,_loc9_.rewards[_loc8_],"icon");
                     }
                  }
                  else
                  {
                     _loc2_["detailMc" + _loc7_]["item" + _loc6_].visible = false;
                  }
                  _loc7_++;
               }
               _loc6_++;
               _loc7_ = 0;
            }
            NinjaSage.loadIconSWF("enemy",this.response["zones"][_loc4_].hardBoss[0],_loc2_["detailMc0"].bossHolder,"StatichuntingHouse");
            NinjaSage.loadIconSWF("enemy",this.response["zones"][_loc4_].hardBoss[1],_loc2_["detailMc1"].bossHolder,"StatichuntingHouse");
         }
         else
         {
            _loc2_.gotoAndStop("easy");
            _loc5_ = _loc3_.replace("EasyBoss","");
            _loc4_ = _loc5_ - 1;
            this.currentZone = int(_loc4_);
            this.currentDif = "EasyBoss";
            this.currentBoss = this.response["zones"][_loc4_].easyBoss;
            _loc2_.huntingPassMc.HuntingTicketTxt.text = String(this.EASY_BOSS_REQUIREMENT);
            _loc6_ = 0;
            while(_loc6_ < 10)
            {
               _loc9_ = this.response.bosses[this.currentBoss[0]];
               _loc8_ = _loc6_ + 0 * 10;
               _loc2_["detailMc0"].nameTxt.text = _loc9_.name;
               _loc2_["detailMc0"].decTxt.text = _loc9_.description;
               _loc2_["detailMc0"].goldMc.txt.text = String(int(Character.character_lvl) * 220 / 50);
               _loc2_["detailMc0"].xpMc.txt.text = String(int(Character.character_lvl) * 250 / 40);
               _loc2_["detailMc0"].lvMc.lvLow.txt.text = String(int(Character.character_lvl) - 5);
               _loc2_["detailMc0"].lvMc.lvHigh.txt.text = String(int(Character.character_lvl) + 10);
               _loc2_["detailMc0"].bgMc.gotoAndStop(_loc4_);
               if(_loc9_.rewards.length > _loc8_)
               {
                  _loc2_["detailMc0"]["item" + _loc6_].visible = true;
                  NinjaSage.loadItemIcon(_loc2_["detailMc0"]["item" + _loc6_].holder,_loc9_.rewards[_loc8_],"icon");
               }
               else
               {
                  _loc2_["detailMc0"]["item" + _loc6_].visible = false;
               }
               _loc6_++;
            }
            NinjaSage.loadIconSWF("enemy",this.response["zones"][_loc4_].easyBoss[0],_loc2_["detailMc0"].bossHolder,"StatichuntingHouse");
         }
         this.main.initButton(_loc2_.attackBtn,this.startBattle,"Fight");
         this.eventHandler.addListener(_loc2_.btnClose,MouseEvent.CLICK,this.closeBossDetail);
      }
      
      private function closeBossDetail(param1:MouseEvent = null) : *
      {
         this.panelMC.panelMC.bossDetailMc.visible = false;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(this.currentDif == "HardBoss")
         {
            while(_loc2_ < 10)
            {
               while(_loc3_ < 2)
               {
                  GF.removeAllChild(this.panelMC.panelMC.bossDetailMc.panel["detailMc" + _loc3_].bossHolder);
                  GF.removeAllChild(this.panelMC.panelMC.bossDetailMc.panel["detailMc" + _loc3_]["item" + _loc2_].holder);
                  this.panelMC.panelMC.bossDetailMc.panel["detailMc" + _loc3_]["item" + _loc2_].holder.filled = false;
                  _loc3_++;
               }
               _loc2_++;
               _loc3_ = 0;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < 10)
            {
               GF.removeAllChild(this.panelMC.panelMC.bossDetailMc.panel["detailMc0"].bossHolder);
               GF.removeAllChild(this.panelMC.panelMC.bossDetailMc.panel["detailMc0"]["item" + _loc2_].holder);
               this.panelMC.panelMC.bossDetailMc.panel["detailMc0"]["item" + _loc2_].holder.filled = false;
               _loc2_++;
            }
         }
         System.gc();
      }
      
      private function openDailyClaim() : *
      {
         this.panelMC.panelMC.dailyMc.visible = true;
         var _loc1_:* = this.panelMC.panelMC.dailyMc;
         _loc1_.amountTxt.text = Character.account_type == 1 ? "x10" : "x5";
         this.eventHandler.addListener(_loc1_.claimBtn,MouseEvent.CLICK,this.claimDaily);
         this.eventHandler.addListener(_loc1_.btnClose,MouseEvent.CLICK,this.closeDailyClaim);
      }
      
      private function claimDaily(param1:MouseEvent) : *
      {
         this.main.amf_manager.service("JDEUnbiWJXOtHxVv.No7GAg9Qzdp8",[Character.char_id,Character.sessionkey],this.onClaimDaily);
      }
      
      private function onClaimDaily(param1:Object) : *
      {
         var _loc2_:* = undefined;
         if(param1.status == 1)
         {
            _loc2_ = Character.account_type == 1 ? 10 : 5;
            Character.addMaterials(this.KARI_BADGE,_loc2_);
            this.panelMC.panelMC.HuntingTicketTxt.text = param1.material;
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.closeDailyClaim();
      }
      
      private function closeDailyClaim(param1:MouseEvent = null) : *
      {
         this.panelMC.panelMC.dailyMc.visible = false;
         this.eventHandler.removeListener(this.panelMC.panelMC.dailyMc.btnClose,MouseEvent.CLICK,this.closeDailyClaim);
         this.eventHandler.removeListener(this.panelMC.panelMC.dailyMc.claimBtn,MouseEvent.CLICK,this.claimDaily);
      }
      
      private function openBadgeShop() : *
      {
         this.panelMC.panelMC.popupBuyItemMc.visible = true;
         var _loc1_:* = this.panelMC.panelMC.popupBuyItemMc.panel;
         _loc1_.titleTxt.text = "Buy Kari Badge";
         _loc1_.itemNameTxt.text = "Kari Badge";
         _loc1_.TokenCost.txt_token.text = this.price;
         _loc1_.numTxt.text = this.amount;
         this.main.initButton(_loc1_.buyBtn,this.buyBudge,"Buy");
         this.eventHandler.addListener(_loc1_.btnClose,MouseEvent.CLICK,this.closeBadge);
         this.eventHandler.addListener(_loc1_.btnNext,MouseEvent.CLICK,this.changeAmount);
         this.eventHandler.addListener(_loc1_.btnPrev,MouseEvent.CLICK,this.changeAmount);
         this.main.initButton(this.panelMC.panelMC.popupBuyItemMc.panel.buyBtn,this.buyBadge,"Buy");
      }
      
      private function changeAmount(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         if(this.amount <= 1 && _loc2_ != "btnNext")
         {
            return;
         }
         if(_loc2_ == "btnNext")
         {
            this.amount += 1;
         }
         else
         {
            --this.amount;
         }
         this.cost = this.price * this.amount;
         this.panelMC.panelMC.popupBuyItemMc.panel.numTxt.text = this.amount;
         this.panelMC.panelMC.popupBuyItemMc.panel.TokenCost.txt_token.text = this.cost;
      }
      
      private function buyBadge(param1:MouseEvent) : *
      {
         this.main.loading(false);
         this.main.amf_manager.service("JDEUnbiWJXOtHxVv.A21fJuhYJxyQ",[Character.char_id,Character.sessionkey,this.amount],this.onBuyBadge);
      }
      
      private function onBuyBadge(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.account_tokens -= this.cost;
            this.panelMC.panelMC.HuntingTicketTxt.text = param1.material;
            this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
            this.main.showMessage(this.amount + " Kari Badge Succesfully Bought!");
            Character.addMaterials(this.KARI_BADGE,this.amount);
            this.main.HUD.setBasicData();
         }
         else if(param1.status == 2)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function closeBadge(param1:MouseEvent) : *
      {
         this.amount = 1;
         this.panelMC.panelMC.popupBuyItemMc.visible = false;
      }
      
      private function openMenu(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         switch(_loc2_)
         {
            case "getDailyItemBtn":
               this.openBadgeShop();
               break;
            case "getMoreItemBtn":
               this.openBadgeShop();
               break;
            case "getMoreBtn":
               this.main.loadPanel("Panels.Recharge");
               break;
            case "goForgePanelBtn":
               this.main.loadPanel("Panels.HuntingMarket");
               break;
            case "recruitFriendBtn":
               this.main.loadExternalSwfPanel("Social","Social");
               break;
            case "btnClose":
               this.destroy();
         }
      }
      
      private function startBattle(param1:MouseEvent) : *
      {
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.main.showMessage("Please equip at least 1 skill");
            return;
         }
         if(int(Character.character_lvl) >= 0)
         {
            this.main.loading(true);
            this.main.amf_manager.service("JDEUnbiWJXOtHxVv.CCQV8v8GpKBY",[Character.char_id,int(this.currentZone + 1),Character.sessionkey],this.onStartHuntingAmf);
         }
      }
      
      private function onStartHuntingAmf(param1:Object) : *
      {
         var _loc2_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.mission_id = this.getBackgroundBattle(this.currentZone + 1);
            Character.battle_code = param1.code;
            if(param1.hash != this.__hash(String(this.currentZone + 1) + String(Character.char_id) + Character.battle_code))
            {
               this.main.loading(false);
               this.main.showMessage("Invalid hash, please try again or re-logout");
               return;
            }
            Character.is_hunting_house = true;
            Character.hunting_zone = int(this.currentZone + 1);
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.EVENT_MATCH,Character.mission_id);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            _loc2_ = 0;
            while(_loc2_ < this.currentBoss.length)
            {
               BattleManager.addPlayerToTeam("enemy",this.currentBoss[_loc2_]);
               _loc2_++;
            }
            BattleManager.startBattle();
            this.closeBossDetail();
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
      
      private function getBackgroundBattle(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return "mission_155";
            case 2:
               return "mission_03";
            case 3:
               return "mission_32";
            case 4:
               return "mission_1016";
            case 5:
               return "mission_1017";
            default:
               return "mission_01";
         }
      }
      
      private function __hash(param1:*) : *
      {
         var _loc2_:ByteArray = Crypto.getHash("sha256").hash(Crypto.bytesArray(param1));
         return Hex.fromArray(_loc2_);
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
         NinjaSage.clearEventListener();
         this.main.clearEvents();
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         var _loc1_:* = 1;
         while(_loc1_ < 6)
         {
            GF.removeAllChild(this.panelMC.panelMC.WorldMapMc["EasyBoss" + _loc1_].bossHolder1);
            GF.removeAllChild(this.panelMC.panelMC.WorldMapMc["HardBoss" + _loc1_].bossHolder1);
            GF.removeAllChild(this.panelMC.panelMC.WorldMapMc["HardBoss" + _loc1_].bossHolder2);
            _loc1_++;
         }
         this.bosses = [];
         this.main = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

