package id.ninjasage.features
{
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class SpecialDeals extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var confirmation:Confirmation;
      
      private var eventHandler:EventHandler;
      
      private var rewardPaneList:Array = [];
      
      private var packData:Array = [];
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var price:int;
      
      private var target:int;
      
      public function SpecialDeals(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.getData();
      }
      
      private function getData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("uZNdHi59Y6XFnN0d.fFufp62MJBxN",[Character.char_id,Character.sessionkey],this.getDataResponse);
      }
      
      private function getDataResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.packData = param1.deals;
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
         this.main.handleVillageHUDVisibility(false);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.rewardPaneList.push(new RewardScrollPane());
            this.panelMC["item_" + _loc1_].scrollPaneHolder.addChild(this.rewardPaneList[_loc1_].getRewardPane());
            _loc1_++;
         }
         this.currentPage = 1;
         this.totalPage = Math.max(1,Math.ceil(this.packData.length / 4));
         this.panelMC.tokenMc.tokenTxt.text = String(Character.account_tokens);
         this.eventHandler.addListener(this.panelMC.closeBtn,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btnNextPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btnPrevPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.tokenMc.plusTokens,MouseEvent.CLICK,this.openRecharge);
         this.renderPacks();
         this.updatePageText();
      }
      
      private function renderPacks() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.panelMC["item_" + _loc1_].visible = false;
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 4);
            if(this.packData.length > _loc2_)
            {
               this.panelMC["item_" + _loc1_].visible = true;
               this.panelMC["item_" + _loc1_].nameTxt.text = this.packData[_loc2_].name;
               this.panelMC["item_" + _loc1_].endTxt.text = this.packData[_loc2_].end;
               this.panelMC["item_" + _loc1_].buyBtn.metaData = {"index":_loc2_};
               this.main.initButton(this.panelMC["item_" + _loc1_].buyBtn,this.showConfirmation,this.packData[_loc2_].price);
               this.rewardPaneList[_loc1_].updateRewardPane({
                  "rewards":this.packData[_loc2_].items,
                  "item_per_line":2,
                  "width":365,
                  "height":null,
                  "x":125,
                  "y":140,
                  "scroll_direction":"horizontal",
                  "scroll_visible":false
               });
            }
            _loc1_++;
         }
      }
      
      private function updatePageText() : void
      {
         this.panelMC.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btnNextPage":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderPacks();
               }
               break;
            case "btnPrevPage":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderPacks();
               }
         }
         this.updatePageText();
      }
      
      private function showConfirmation(param1:MouseEvent) : void
      {
         this.target = this.packData[param1.currentTarget.metaData.index].id;
         this.price = this.packData[param1.currentTarget.metaData.index].price;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to buy " + this.packData[param1.currentTarget.metaData.index].name + " for " + this.price + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPackage);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function removeConfirmation(param1:MouseEvent) : *
      {
         this.eventHandler.removeListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPackage);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
      }
      
      private function buyPackage(param1:MouseEvent) : void
      {
         this.removeConfirmation(null);
         this.main.amf_manager.service("uZNdHi59Y6XFnN0d.UIHsu3uYK2oF",[Character.char_id,Character.sessionkey,this.target],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         if(param1.status == 1)
         {
            this.main.showMessage("You have successfully bought this package!");
            Character.addRewards(param1.rewards);
            this.main.giveReward(1,param1.rewards,"independence");
            Character.account_tokens = int(Character.account_tokens) - this.price;
            this.main.HUD.setBasicData();
            this.panelMC.tokenMc.tokenTxt.text = String(Character.account_tokens);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
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
         this.main.handleVillageHUDVisibility(true);
         this.eventHandler.removeAllEventListeners();
         GF.destroyArray(this.rewardPaneList);
         this.rewardPaneList = null;
         this.eventHandler = null;
         this.confirmation = null;
         this.packData = null;
         this.main = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
         System.gc();
      }
   }
}

