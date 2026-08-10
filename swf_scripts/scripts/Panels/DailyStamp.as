package Panels
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2053")]
   public dynamic class DailyStamp extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panel:MovieClip;
      
      internal var rewardsArray:Array;
      
      public var costs:* = [];
      
      public var loginCount:* = 0;
      
      public var main:*;
      
      private var eventHandler:* = new EventHandler();
      
      private var selected:int = -1;
      
      public function DailyStamp(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.rewardsArray = [];
         this.main = param1;
         this.rew_loading = 0;
         addFrameScript(6,this.frame7,12,this.frame13,27,this.frame28);
      }
      
      internal function frame7() : *
      {
         var _loc1_:* = 1;
         while(_loc1_ <= 31)
         {
            this.panel["s" + _loc1_].visible = false;
            _loc1_++;
         }
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            this.panel["tick_" + _loc2_].visible = false;
            this.panel["btn_claim_" + _loc2_].visible = false;
            _loc2_++;
         }
         this.loadData();
      }
      
      internal function frame13() : *
      {
         this.stop();
         this.eventHandler.addListener(this.panel.btnClose,MouseEvent.CLICK,this.closePanel,false,0,true);
      }
      
      public function loadData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.io0QSVL8uEHn",[Character.char_id,Character.sessionkey],this.onDataLoaded);
      }
      
      public function onDataLoaded(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(int(param1.status) != 1)
         {
            if("result" in param1)
            {
               this.main.showMessage(param1.result);
               return;
            }
            this.main.showMessage("Unknown error");
            return;
         }
         this.rewardsArray = param1.items;
         this.loginCount = param1.count;
         for each(_loc2_ in param1.attendances)
         {
            if("s" + _loc2_ in this.panel)
            {
               this.panel["s" + _loc2_].visible = true;
            }
         }
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            if(_loc3_ < this.rewardsArray.length)
            {
               this.costs.push(this.rewardsArray[_loc3_].price);
               _loc4_ = "DAY0" + (_loc3_ + 1);
               if(this.panel[_loc4_])
               {
                  this.panel[_loc4_].text = this.rewardsArray[_loc3_].price;
               }
               if(param1.rewards[_loc3_] == 1)
               {
                  this.panel["tick_" + _loc3_].visible = true;
                  this.panel["btn_claim_" + _loc3_].visible = false;
               }
               else if(this.loginCount >= this.rewardsArray[_loc3_].price)
               {
                  this.panel["btn_claim_" + _loc3_].visible = true;
                  this.eventHandler.addListener(this.panel["btn_claim_" + _loc3_],MouseEvent.CLICK,this.claimAttendance,false,0,true);
               }
            }
            else
            {
               this.panel["tick_" + _loc3_].visible = false;
               this.panel["btn_claim_" + _loc3_].visible = false;
            }
            _loc3_++;
         }
         this.loadRewards();
         this.main.loading(false);
      }
      
      internal function frame28() : *
      {
         this.gotoAndStop("idle");
         GF.removeAllChild(this);
      }
      
      public function claimAttendance(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.selected = int(param1.currentTarget.name.split("_")[2]);
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.H8EBMq5S6BUp",[Character.char_id,Character.sessionkey,this.rewardsArray[this.selected].id],this.onClaimAttendance);
      }
      
      public function onClaimAttendance(param1:Object) : *
      {
         this.main.loading(false);
         if(int(param1.status) != 1)
         {
            if("result" in param1)
            {
               this.main.showMessage(param1.result);
               return;
            }
            this.main.showMessage("Unknown error");
            return;
         }
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            if(param1.rewards[_loc2_] == 1)
            {
               this.panel["tick_" + _loc2_].visible = true;
               this.panel["btn_claim_" + _loc2_].visible = false;
            }
            else if(this.loginCount >= this.costs[_loc2_])
            {
               this.panel["btn_claim_" + _loc2_].visible = true;
               this.eventHandler.addListener(this.panel["btn_claim_" + _loc2_],MouseEvent.CLICK,this.claimAttendance,false,0,true);
            }
            _loc2_++;
         }
         Character.addRewards(param1.reward);
         this.panel["tick_" + this.selected].visible = true;
         this.panel["btn_claim_" + this.selected].visible = false;
         if(param1.level_up == true)
         {
            Character.character_lvl = String(int(Character.character_lvl) + 1);
            Character.character_xp = param1.xp;
            this.main.levelUp();
            this.main.HUD.loadFrame();
         }
         this.main.HUD.loadFrame();
         this.main.HUD.setBasicData();
         this.main.giveReward(1,param1.reward);
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.gotoAndPlay("exit");
      }
      
      public function loadRewards() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < 6)
         {
            this.panel["iconMc" + _loc1_].ownedTxt.visible = false;
            this.panel["iconMc" + _loc1_].amtTxt.visible = false;
            NinjaSage.loadItemIcon(this.panel["iconMc" + _loc1_],this.rewardsArray[_loc1_].item);
            _loc1_++;
         }
      }
   }
}

