package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class PvpMilestoneRewards extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var main:*;
      
      private var response:Object;
      
      public function PvpMilestoneRewards(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.outfits = [];
         this.eventHandler = new EventHandler();
         this.getData();
      }
      
      private function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("jpwzlvqNru201CF3.1SjDH98kXWgN",[Character.char_id,Character.sessionkey],this.getDataResponse);
      }
      
      private function getDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1.rewards;
            this.initUI();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.destroy();
         }
      }
      
      private function initUI() : void
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.panelMC.reward_4.txt_notice.text = "Only TOP 10 PVP LEADERBOARD Can obtain this reward";
         this.panelMC.txt_desc.text = "Rewards will be sent to the mailbox after season ended";
         this.renderRewards();
      }
      
      private function renderRewards() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.panelMC["reward_" + _loc1_]["txt_requirement"].text = String(this.response[_loc1_].requirement) + " Trophy";
            this.panelMC["reward_" + _loc1_]["icon"].amountTxt.text = this.response[_loc1_].quantity <= 1 ? "" : "x" + this.response[_loc1_].quantity;
            this.panelMC["reward_" + _loc1_]["icon"].ownedTxt.visible = false;
            if(Character.hasSkill(this.response[_loc1_].id) > 0)
            {
               this.panelMC["reward_" + _loc1_]["icon"].ownedTxt.visible = true;
               this.panelMC["reward_" + _loc1_]["icon"].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(this.response[_loc1_].id) > 0)
            {
               this.panelMC["reward_" + _loc1_]["icon"].ownedTxt.visible = true;
               this.panelMC["reward_" + _loc1_]["icon"].ownedTxt.text = "Owned";
            }
            this.panelMC["reward_" + _loc1_]["icon"].btn_preview.visible = this.checkIsItemOrSkill(this.response[_loc1_].id);
            this.panelMC["reward_" + _loc1_]["icon"].btn_preview.metaData = {"itemId":this.response[_loc1_].id};
            this.eventHandler.addListener(this.panelMC["reward_" + _loc1_]["icon"].btn_preview,MouseEvent.CLICK,this.main.openPreview);
            NinjaSage.loadItemIcon(this.panelMC["reward_" + _loc1_]["icon"],this.response[_loc1_].id);
            _loc1_++;
         }
      }
      
      private function checkIsItemOrSkill(param1:String) : Boolean
      {
         var _loc2_:Array = ["skill_","hair_","set_","back_","wpn_"];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1.indexOf(_loc2_[_loc3_]) >= 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
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
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         this.response = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}

