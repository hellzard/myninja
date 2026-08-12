package Panels
{
   import Popups.Confirmation;
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class DailyRewards extends MovieClip
   {
       
      
      public var claim_3:SimpleButton;
      
      public var tokenAni:MovieClip;
      
      public var xpAni:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var Icon:MovieClip;
      
      public var learnAllSkills:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var buyGold:SimpleButton;
      
      public var buyTokens:SimpleButton;
      
      public var claim_0:SimpleButton;
      
      public var claim_1:SimpleButton;
      
      public var claim_2:SimpleButton;
      
      public var icon:MovieClip;
      
      public var tokenIcon:MovieClip;
      
      public var txt_0:TextField;
      
      public var txt_1:TextField;
      
      public var txt_2:TextField;
      
      public var txt_gold:TextField;
      
      public var txt_token:TextField;
      
      public var xpBounsIcon:MovieClip;
      
      public var xp_data:MovieClip;
      
      public var main;
      
      var conf:Confirmation;
      
      var element:int;
      
      private var eventHandler:EventHandler;
      
      private var timestamp;
      
      private var timeout;
      
      public function DailyRewards(param1:*)
      {
         this.eventHandler = new EventHandler();
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClose);
         this.main = param1;
         this.main.loading(true);
         this.updateDisplay();
         this.tokenAni.addFrameScript(25,this.callUpdate);
         this.xpAni.addFrameScript(25,this.callUpdate);
         this.eventHandler.addListener(this.learnAllSkills.btnClose,MouseEvent.CLICK,this.onClosePopup);
      }
      
      public function callUpdate() : *
      {
         this.updateDisplay();
      }
      
      public function updateDisplay() : *
      {
         this.learnAllSkills.visible = false;
         this.txt_0.text = "";
         this.txt_1.text = "";
         this.claim_0.visible = false;
         this.claim_1.visible = false;
         this.claim_2.visible = false;
         this.claim_3.visible = false;
         if(int(Character.character_lvl) >= 80)
         {
            this.txt_2.visible = false;
            this.claim_2.visible = true;
            this.claim_2.addEventListener(MouseEvent.CLICK,this.claimScroll);
         }
         this.tokenAni.gotoAndStop("idle");
         this.xpAni.gotoAndStop("idle");
         this.eventHandler.addListener(this.btnClose,MouseEvent.CLICK,this.onClose);
         this.getInfo();
         this.main.HUD.setBasicData();
      }
      
      public function getInfo() : *
      {
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.v9oh8eA9EOEn",[Character.char_id,Character.sessionkey],this.onGetData);
      }
      
      public function onGetData(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.txt_0.text = param1.tokens == true ? "" : "Come back tomorrow!";
            if(!param1.xp)
            {
               if(param1.timer > 0)
               {
                  this.timestamp = param1.timer;
                  this.updateTimeLeft();
               }
               else
               {
                  this.txt_1.text = "Come back tomorrow!";
               }
            }
            this.claim_0.visible = param1.tokens == true;
            this.claim_1.visible = param1.xp == true;
            this.claim_3.visible = param1.xp == true;
            if(this.claim_1.visible && this.claim_3.visible)
            {
               this.txt_1.text = "";
            }
            if(int(Character.character_lvl) >= 80)
            {
               this.claim_2.visible = param1.scroll == false;
            }
            this.eventHandler.addListener(this.claim_0,MouseEvent.CLICK,this.claimTokens);
            this.eventHandler.addListener(this.claim_1,MouseEvent.CLICK,this.claimXP);
            this.eventHandler.addListener(this.claim_3,MouseEvent.CLICK,this.claimDoubleXP);
         }
         else if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.main.loading(false);
      }
      
      public function claimTokens(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.mhRelIPdSUTP",[Character.char_id,Character.sessionkey],this.onClaimedTokens);
      }
      
      public function onClaimedTokens(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.tokenAni.gotoAndPlay("show");
            Character.account_tokens += 25;
            this.claim_0.visible = false;
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
      
      public function claimXP(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.vMD8KeJJ3Rbf",[Character.char_id,Character.sessionkey],this.onClaimedXP);
      }
      
      public function onClaimedXP(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.xpAni.gotoAndPlay("show");
            this.main.giveReward(1,"xp_" + param1.reward);
            Character.character_xp = param1.xp;
            if(param1.level_up == true)
            {
               Character.character_lvl = String(int(Character.character_lvl) + 1);
               Character.character_xp = param1.xp;
               this.main.levelUp();
               this.main.HUD.loadFrame();
            }
            this.claim_1.visible = false;
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
      
      public function claimDoubleXP(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.aFYyJqCe8Zly",[Character.char_id,Character.sessionkey],this.onClaimedDoubleXP);
      }
      
      public function onClaimedDoubleXP(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.xpAni.gotoAndPlay("show");
            this.claim_1.visible = false;
            this.claim_3.visible = false;
            this.timestamp = param1.timer;
            this.updateTimeLeft();
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
      
      public function updateTimeLeft() : void
      {
         if(this.timestamp == null)
         {
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:* = this.timestamp;
         var _loc5_:* = Math.floor(_loc4_ / _loc1_);
         var _loc6_:* = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         var _loc7_:* = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         this.txt_1.text = _loc5_ + ":" + _loc6_ + ":" + _loc7_;
         this.timeout = setTimeout(this.updateTimeLeft,10000);
         this.timestamp -= 10;
      }
      
      public function claimScroll(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("X5UfSEw5XCksM1Eg.RPTEFC1sImk0",[Character.char_id,Character.sessionkey],this.onClaimedScroll);
      }
      
      public function onClaimedScroll(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,"essential_10");
            Character.addEssentials("essentia_10");
            this.claim_2.visible = false;
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
      
      public function claimSkills(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("ScrollOfWisdom","ScrollOfWisdom");
      }
      
      public function onClosePopup(param1:* = null) : *
      {
         this.learnAllSkills.visible = false;
      }
      
      public function onClose(param1:* = null) : *
      {
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         this.timeout = null;
         this.main.HUD.setBasicData();
         this.main = null;
         parent.removeChild(this);
      }
   }
}
