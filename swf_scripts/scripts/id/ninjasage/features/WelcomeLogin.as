package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class WelcomeLogin extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var rewardData:Array = [];
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var response:Object;
      
      private var selectedLogin:int;
      
      public function WelcomeLogin(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.getEventData();
      }
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("qcjM2uAj17TP3Qac.tPUYjgx33D96",[Character.char_id,Character.sessionkey],this.eventDataResponse);
      }
      
      private function eventDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.rewardData = param1.rewards;
            this.initUI();
         }
         else if(param1.status > 1 && param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function initUI() : void
      {
         this.eventHandler.addListener(this.panelMC.panelMC.closeBtn,MouseEvent.CLICK,this.closePanel);
         var _loc1_:* = 0;
         while(_loc1_ < 7)
         {
            this.panelMC.panelMC["day_" + _loc1_].dayTxt.text = "Day " + (_loc1_ + 1);
            this.main.initButton(this.panelMC.panelMC["day_" + _loc1_].claimBtn,this.claimReward,"Claim");
            if(this.response.rewards[_loc1_].c == 0 && this.response.logins - 1 >= _loc1_)
            {
               this.panelMC.panelMC["day_" + _loc1_].tick.visible = false;
               this.panelMC.panelMC["day_" + _loc1_].lock.visible = false;
               this.panelMC.panelMC["day_" + _loc1_].claimBtn.visible = true;
            }
            else if(this.response.rewards[_loc1_].c == 0 && this.response.logins - 1 < _loc1_)
            {
               this.panelMC.panelMC["day_" + _loc1_].tick.visible = false;
               this.panelMC.panelMC["day_" + _loc1_].lock.visible = true;
               this.panelMC.panelMC["day_" + _loc1_].claimBtn.visible = false;
            }
            else if(this.response.rewards[_loc1_].c == 1)
            {
               this.panelMC.panelMC["day_" + _loc1_].tick.visible = true;
               this.panelMC.panelMC["day_" + _loc1_].lock.visible = false;
               this.panelMC.panelMC["day_" + _loc1_].claimBtn.visible = false;
            }
            this.panelMC.panelMC["day_" + _loc1_].iconMc.rewardIcon.amountTxt.text = this.rewardData[_loc1_].r.split(":")[1] != null ? "x" + this.rewardData[_loc1_].r.split(":")[1] : "";
            NinjaSage.loadItemIcon(this.panelMC.panelMC["day_" + _loc1_].iconMc,this.rewardData[_loc1_].r.split(":")[0]);
            _loc1_++;
         }
      }
      
      private function claimReward(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.selectedLogin = param1.currentTarget.parent.name.replace("day_","");
         this.main.amf_manager.service("qcjM2uAj17TP3Qac.PpM4fZRMx5W2",[Character.char_id,Character.sessionkey,this.selectedLogin],this.onRewardClaimed);
      }
      
      private function onRewardClaimed(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.addRewards(param1.rewards);
            this.main.giveReward(1,param1.rewards);
            this.main.HUD.setBasicData();
            this.panelMC.panelMC["day_" + this.selectedLogin].tick.visible = true;
            this.panelMC.panelMC["day_" + this.selectedLogin].lock.visible = false;
            this.panelMC.panelMC["day_" + this.selectedLogin].claimBtn.visible = false;
         }
         else if(param1.status > 1 && param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
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
         this.main.clearEvents();
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         this.response = null;
         this.rewardData = [];
         GF.removeAllChild(this.panelMC);
      }
   }
}

