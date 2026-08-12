package id.ninjasage.features
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.GameData;
   import Storage.Library;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.utils.ByteArray;
   import id.ninjasage.EscapeKeyManager;
   
   public class EudemonGarden extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var main;
      
      public var boss_rn:int = 0;
      
      public var curr_page:int = 1;
      
      public var itemCnt:int = 0;
      
      public var bossList;
      
      public var total_page:int = 1;
      
      public var curr_page_boss:Array;
      
      public var enemy_data:Array;
      
      public var color:Color;
      
      public var boss_id:String = "";
      
      public var boss_num:int = -1;
      
      private var gameData;
      
      public function EudemonGarden(param1:*, param2:*)
      {
         this.gameData = GameData.get("eudemon");
         this.enemy_data = [];
         this.bossList = this.gameData.bosses.length;
         this.curr_page_boss = [];
         this.color = new Color();
         super();
         this.main = param1;
         this.panelMC = param2;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.panelMC.popup.visible = false;
         this.panelMC.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.panelMC.btn_reset.addEventListener(MouseEvent.CLICK,this.openPop);
         this.panelMC.btn_Blacksmith.addEventListener(MouseEvent.CLICK,this.openBlacksmith);
         this.panelMC.btn_Recruit.addEventListener(MouseEvent.CLICK,this.openSocial);
         this.panelMC.btn_next.addEventListener(MouseEvent.CLICK,this.changePage);
         this.panelMC.btn_prev.addEventListener(MouseEvent.CLICK,this.changePage);
         this.getData();
      }
      
      function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("A11M5XZ9wxhTs2Dr.RuyuMINDEhfE",[Character.sessionkey,Character.char_id],this.dataResponse);
      }
      
      function openBlacksmith(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Blacksmith");
      }
      
      function openSocial(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("Social","Social");
      }
      
      function dataResponse(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = param1.data.split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.enemy_data.push(_loc2_[_loc3_]);
               _loc3_++;
            }
            this.loadBasicData(this.enemy_data,this.itemCnt);
         }
         else
         {
            this.main.getError(param1.error_code);
         }
      }
      
      function openPop(param1:MouseEvent) : void
      {
         this.panelMC.popup.visible = true;
         var _loc2_:int = int(Character.character_lvl) >= 80 ? 80 : 50;
         this.panelMC.popup.txt.text = "Confirm restoring all Hunting House tries for " + _loc2_ + " Tokens ? ";
         this.panelMC.popup.btn_close.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.panelMC.popup.btn_close.addEventListener(MouseEvent.CLICK,this.closePop);
         this.panelMC.popup.bg.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.panelMC.popup.bg.addEventListener(MouseEvent.CLICK,this.closePop);
         this.panelMC.popup.btn_confirm.removeEventListener(MouseEvent.CLICK,this.resetTries);
         this.panelMC.popup.btn_confirm.addEventListener(MouseEvent.CLICK,this.resetTries);
      }
      
      function closePop(param1:MouseEvent) : void
      {
         this.panelMC.popup.visible = false;
      }
      
      function resetTries(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("A11M5XZ9wxhTs2Dr.qsFqy866qqQr",[Character.sessionkey,Character.char_id],this.buyResponse);
      }
      
      function buyResponse(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.panelMC.popup.visible = false;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc4_ = int(Character.character_lvl) >= 80 ? 80 : 50;
            Character.account_tokens -= _loc4_;
            _loc2_ = param1.data.split(",");
            _loc3_ = 0;
            this.enemy_data = [];
            while(_loc3_ < _loc2_.length)
            {
               this.enemy_data.push(_loc2_[_loc3_]);
               _loc3_++;
            }
            this.loadBasicData(this.enemy_data,this.itemCnt);
         }
         else if(param1.status == 2)
         {
            this.main.getNotice("You dont have enough tokens to reset the hunting attempts.");
         }
         else
         {
            this.main.getError(param1.error_code);
         }
      }
      
      function changePage(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "btn_next")
         {
            if(this.curr_page < this.total_page)
            {
               ++this.curr_page;
               this.itemCnt += 5;
               this.loadBasicData(this.enemy_data,this.itemCnt);
            }
         }
         else if(param1.currentTarget.name == "btn_prev")
         {
            if(this.curr_page != 1)
            {
               --this.curr_page;
               this.itemCnt -= 5;
               this.loadBasicData(this.enemy_data,this.itemCnt);
            }
         }
         this.panelMC.pageTxt.text = this.curr_page + "/" + this.total_page;
      }
      
      function loadBasicData(param1:Array, param2:*) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         this.main.handleVillageHUDVisibility(false);
         var _loc3_:* = undefined;
         var _loc4_:* = 5;
         this.total_page = int(this.bossList / 5 + 1);
         if(this.bossList < 6)
         {
            _loc4_ = this.bossList;
            this.total_page = 1;
         }
         if(this.bossList % 5 == 0)
         {
            this.total_page = this.bossList / 5;
         }
         this.panelMC.pageTxt.text = this.curr_page + "/" + this.total_page;
         var _loc5_:* = 0;
         while(_loc5_ < 5)
         {
            _loc3_ = this.loadBossData(param2);
            _loc6_ = _loc5_ + int(int(this.curr_page - 1) * 5);
            if(this.bossList > _loc6_)
            {
               this.panelMC["boss_" + _loc5_].visible = true;
               _loc7_ = {"bossTnc":param2};
               this.panelMC["boss_" + _loc5_].gotoAndStop(1);
               this.panelMC["boss_" + _loc5_]["txt_name"].text = _loc3_.name;
               this.panelMC["boss_" + _loc5_]["txt_lvl"].text = _loc3_.lvl;
               this.panelMC["boss_" + _loc5_]["txt_attempt"].text = "x" + param1[param2];
               this.panelMC["boss_" + _loc5_]["rankMC"].gotoAndStop(_loc3_.rank);
               if(int(Character.character_lvl) >= int(_loc3_.lvl))
               {
                  if(param1[param2] > 0)
                  {
                     this.color.brightness = 0;
                     this.panelMC["lock_" + _loc5_].visible = false;
                     this.panelMC["boss_" + _loc5_]["clickmask"].buttonMode = true;
                     this.panelMC["boss_" + _loc5_].transform.colorTransform = this.color;
                     this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER,this.bossOver);
                     this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT,this.bossOut);
                     this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.CLICK,this.bossClick);
                     this.panelMC["boss_" + _loc5_]["clickmask"].addEventListener(MouseEvent.MOUSE_OVER,this.bossOver);
                     this.panelMC["boss_" + _loc5_]["clickmask"].addEventListener(MouseEvent.MOUSE_OUT,this.bossOut);
                     this.panelMC["boss_" + _loc5_]["clickmask"].addEventListener(MouseEvent.CLICK,this.bossClick);
                  }
                  else
                  {
                     this.color.brightness = -0.3;
                     this.panelMC["lock_" + _loc5_].visible = false;
                     this.panelMC["boss_" + _loc5_]["clickmask"].buttonMode = true;
                     this.panelMC["boss_" + _loc5_].transform.colorTransform = this.color;
                     this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER,this.bossOver);
                     this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT,this.bossOut);
                     this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.CLICK,this.bossClick);
                     this.panelMC["boss_" + _loc5_]["clickmask"].addEventListener(MouseEvent.MOUSE_OVER,this.bossOver);
                     this.panelMC["boss_" + _loc5_]["clickmask"].addEventListener(MouseEvent.MOUSE_OUT,this.bossOut);
                     this.panelMC["boss_" + _loc5_]["clickmask"].addEventListener(MouseEvent.CLICK,this.bossClick);
                  }
               }
               else
               {
                  this.color.brightness = -0.3;
                  this.panelMC["lock_" + _loc5_].visible = true;
                  this.panelMC["boss_" + _loc5_]["clickmask"].buttonMode = false;
                  this.panelMC["boss_" + _loc5_].transform.colorTransform = this.color;
                  this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER,this.bossOver);
                  this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT,this.bossOut);
                  this.panelMC["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.CLICK,this.bossClick);
               }
               this.panelMC["boss_" + _loc5_]["clickmask"].metaData = _loc7_;
            }
            else
            {
               this.panelMC["boss_" + _loc5_].visible = false;
               this.panelMC["lock_" + _loc5_].visible = false;
            }
            param2++;
            _loc5_++;
         }
         this.selectBoss(this.itemCnt);
         this.panelMC["boss_0"].gotoAndStop(3);
      }
      
      function bossOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget.parent.currentFrame != 3)
         {
            param1.currentTarget.parent.gotoAndStop(2);
         }
      }
      
      function bossOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget.parent.currentFrame != 3)
         {
            param1.currentTarget.parent.gotoAndStop(1);
         }
      }
      
      function bossClick(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            this.panelMC["boss_" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         this.boss_rn = param1.currentTarget.metaData.bossTnc;
         param1.currentTarget.parent.gotoAndStop(3);
         var _loc3_:* = param1.currentTarget.parent.name.split("_");
         _loc3_ = _loc3_[1];
         this.selectBoss(this.boss_rn);
      }
      
      function selectBoss(param1:int) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = this.loadBossData(param1);
         Character.hunting_house_boss_id = this.boss_id = _loc2_.id;
         Character.hunting_house_boss_num = this.boss_num = _loc2_.num;
         this.panelMC.txt_desc.text = _loc2_.desc;
         this.panelMC.txt_xp.text = _loc2_.xp;
         this.panelMC.txt_gold.text = _loc2_.gold;
         if(this.enemy_data[param1] > 0)
         {
            this.color.brightness = 0;
            this.panelMC.btn_fight.visible = true;
            this.panelMC.btn_fight.mouseEnabled = true;
            this.panelMC.btn_fight.transform.colorTransform = this.color;
            this.panelMC.btn_fight.removeEventListener(MouseEvent.CLICK,this.startBattle);
            this.panelMC.btn_fight.addEventListener(MouseEvent.CLICK,this.startBattle);
         }
         else
         {
            this.color.brightness = -0.6;
            this.panelMC.btn_fight.visible = false;
            this.panelMC.btn_fight.mouseEnabled = false;
            this.panelMC.btn_fight.transform.colorTransform = this.color;
            this.panelMC.btn_fight.removeEventListener(MouseEvent.CLICK,this.startBattle);
         }
         GF.removeAllChild(this.panelMC.loader_0);
         GF.removeAllChild(this.panelMC.loader_1);
         var _loc3_:* = 0;
         while(_loc3_ < 14)
         {
            this.panelMC.dropMC["iconMC" + _loc3_].visible = false;
            while(this.panelMC.dropMC["iconMC" + _loc3_].iconHolder.numChildren > 0)
            {
               this.panelMC.dropMC["iconMC" + _loc3_].iconHolder.removeChildAt(0);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.rewards.length)
         {
            this.panelMC.dropMC["iconMC" + _loc3_].visible = true;
            _loc6_ = (_loc5_ = _loc2_.rewards[_loc3_]).split("_");
            _loc7_ = Library.getItemInfo(_loc5_);
            if(_loc6_[0] == "wpn")
            {
               _loc8_ = "items";
               _loc9_ = new Array(_loc7_["item_name"],_loc7_["item_level"],_loc7_["item_damage"],_loc7_["item_description"]);
            }
            else
            {
               _loc8_ = "materials";
               _loc9_ = new Array(_loc7_["item_name"],_loc7_["item_level"],_loc7_["item_description"]);
            }
            GF.removeAllChild(this.panelMC.dropMC["iconMC" + _loc3_].iconHolder);
            NinjaSage.loadItemIcon(this.panelMC.dropMC["iconMC" + _loc3_].iconHolder,_loc5_,"icon");
            _loc3_++;
         }
         _loc3_ = 0;
         var _loc4_:* = _loc2_.id;
         while(_loc3_ < _loc4_.length)
         {
            NinjaSage.loadIconSWF("enemy",_loc4_[_loc3_],this.panelMC["loader_" + _loc3_],"StatichuntingHouse");
            _loc3_++;
         }
      }
      
      function startBattle(param1:MouseEvent) : void
      {
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.main.showMessage("Please equip at least 1 skill");
            return;
         }
         if(int(Character.character_lvl) >= 10)
         {
            this.main.loading(true);
            this.main.amf_manager.service("A11M5XZ9wxhTs2Dr.iIOH3uczAJZI",[Character.char_id,this.boss_num,Character.sessionkey],this.onStartHuntingAmf);
         }
      }
      
      public function onStartHuntingAmf(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = this.loadBossData(this.boss_num);
            Character.is_eudemon_garden = true;
            Character.eudemon_boss_num = this.boss_num;
            Character.battle_code = param1.code;
            if(param1.hash != this.__hash(Character.char_id + Character.battle_code + this.boss_num))
            {
               this.main.loading(false);
               this.main.showMessage("Invalid hash, please try again or re-logout");
               return;
            }
            this.main.combat = this.main.loadPanel("Combat.Battle",true);
            BattleManager.init(this.main.combat,this.main,BattleVars.EVENT_MATCH,_loc2_["bg"]);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.id.length)
            {
               BattleManager.addPlayerToTeam("enemy",_loc2_.id[_loc3_]);
               _loc3_++;
            }
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
      
      function loadBossData(param1:int) : *
      {
         return this.gameData.bosses[param1];
      }
      
      private function __hash(param1:*) : *
      {
         var _loc2_:ByteArray = Crypto.getHash("sha256").hash(Crypto.bytesArray(param1));
         return Hex.fromArray(_loc2_);
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.handleVillageHUDVisibility(true);
         this.panelMC.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.panelMC.btn_reset.removeEventListener(MouseEvent.CLICK,this.openPop);
         this.panelMC.btn_Blacksmith.removeEventListener(MouseEvent.CLICK,this.openBlacksmith);
         this.panelMC.btn_Recruit.removeEventListener(MouseEvent.CLICK,this.openSocial);
         this.panelMC.btn_next.removeEventListener(MouseEvent.CLICK,this.changePage);
         this.panelMC.btn_prev.removeEventListener(MouseEvent.CLICK,this.changePage);
         this.panelMC.popup.btn_close.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.panelMC.popup.bg.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.panelMC.popup.btn_confirm.removeEventListener(MouseEvent.CLICK,this.resetTries);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.panelMC["boss_" + _loc1_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER,this.bossOver);
            this.panelMC["boss_" + _loc1_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT,this.bossOut);
            this.panelMC["boss_" + _loc1_]["clickmask"].removeEventListener(MouseEvent.CLICK,this.bossClick);
            _loc1_++;
         }
         this.panelMC.btn_fight.removeEventListener(MouseEvent.CLICK,this.startBattle);
         GF.removeAllChild(this.panelMC.loader_0);
         GF.removeAllChild(this.panelMC.loader_1);
         _loc1_ = 0;
         while(_loc1_ < 14)
         {
            GF.removeAllChild(this.panelMC.dropMC["iconMC" + _loc1_].iconHolder);
            _loc1_++;
         }
         this.main.removeExternalSwfPanel();
         NinjaSage.clearLoader();
         this.color = null;
         this.enemy_data = null;
         this.main = null;
         this.gameData = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
      
      function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
   }
}
