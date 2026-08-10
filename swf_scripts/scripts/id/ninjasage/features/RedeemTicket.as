package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.PetInfo;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class RedeemTicket extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:*;
      
      private var selectedReward:int = -1;
      
      private var selectedRewardName:String;
      
      private var selectedDragonBall:int = -1;
      
      private var selectedDragonBallMaterial:String = null;
      
      private var rewardList:*;
      
      private var dragonBall:Array = ["material_819","material_820","material_821","material_822","material_823"];
      
      private var dragonBallTier:Array = [{"materialId":["material_775:2","material_776:2","material_777:2","material_778:2","material_779:2","material_780:2","material_781:2"]},{"materialId":["material_782:2","material_783:2","material_784:2","material_785:2","material_786:2","material_787:2","material_788:2"]},{"materialId":["material_789:2","material_790:2","material_791:2","material_792:2","material_793:2","material_794:2","material_795:2"]},{"materialId":["material_796:2","material_797:2","material_798:2","material_799:2","material_800:2","material_801:2","material_802:2"]},{"materialId":["material_803:2","material_804:2","material_805:2","material_806:2","material_807:2","material_808:2","material_809:2"]}];
      
      private var confirmation:*;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 0;
      
      private var amount:int = 1;
      
      private var price:int = 1;
      
      private var cost:int = 1;
      
      private var ownedTicket:int;
      
      public function RedeemTicket(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.getBasicData();
      }
      
      private function getBasicData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("LfKCy8lSBGn7O5WS.2zzjfxrU2xh5",[Character.char_id,Character.sessionkey],this.basicDataResponse);
      }
      
      private function basicDataResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.rewardList = param1.exchanges;
            this.ownedTicket = param1.tickets;
            this.onShow();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.main.loading(false);
      }
      
      private function onShow() : *
      {
         var _loc1_:* = this.panelMC;
         this.initButton();
         this.initUI();
         _loc1_.qtyMC.visible = false;
         _loc1_.dbSelectMC.visible = false;
         _loc1_.txt_ticket.text = this.ownedTicket;
         _loc1_.titleTxt.text = "Redeem Ticket Rewards Selection";
         _loc1_.displayTxt2.text = "Please select ONE rewards below: ";
         _loc1_.displayTxt.text = "*Make sure you choose the reward wisely\n*Exchanged Reward Cannot Be Undone\n*Price Shown is per 1 ticket\n*Redeem Ticket Can Only Be Obtained From Recharge";
      }
      
      private function initUI() : *
      {
         var _loc3_:* = undefined;
         var _loc1_:* = this.panelMC;
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = _loc2_ + int(int(this.currentPage - 1) * 5);
            if(this.rewardList.length > _loc3_)
            {
               _loc1_["item" + _loc2_].visible = true;
               _loc1_["arrow_" + _loc2_].visible = true;
               _loc1_["item" + _loc2_].gotoAndStop(this.rewardList[_loc3_].code);
               _loc1_["item" + _loc2_].itemType.highlightMC.gotoAndStop("unselected");
               _loc1_["item" + _loc2_].buttonMode = true;
               _loc1_["item" + _loc2_].itemType.descTxt.text = this.rewardList[_loc3_].qty + "\n" + _loc1_["item" + _loc2_].itemType.nameTxt.text + "(s)";
               _loc1_["item" + _loc2_].reward_name = _loc1_["item" + _loc2_].itemType.nameTxt.text + "(s)";
               _loc1_["item" + _loc2_].selected_reward = _loc3_;
               this.eventHandler.addListener(_loc1_["item" + _loc2_],MouseEvent.CLICK,this.onClick);
            }
            else
            {
               _loc1_["item" + _loc2_].visible = false;
               _loc1_["arrow_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         this.updatePageNumber();
         this.totalPage = Math.max(Math.ceil(this.rewardList.length / 5),1);
      }
      
      private function onClick(param1:MouseEvent) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            this.panelMC["item" + _loc2_].itemType.highlightMC.gotoAndStop("unselected");
            _loc2_++;
         }
         this.selectedReward = param1.currentTarget.selected_reward;
         this.selectedRewardName = param1.currentTarget.reward_name;
         param1.currentTarget.itemType.highlightMC.gotoAndStop("selected");
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "nextBtn":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.initUI();
               }
               break;
            case "prevBtn":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.initUI();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : *
      {
         if(this.currentPage == 1)
         {
            this.panelMC.prevBtn.visible = false;
         }
         else
         {
            this.panelMC.prevBtn.visible = true;
         }
         if(this.currentPage == this.totalPage)
         {
            this.panelMC.nextBtn.visible = false;
         }
         else
         {
            this.panelMC.nextBtn.visible = true;
         }
      }
      
      private function initButton() : *
      {
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.prevBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.nextBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.buyTokens,MouseEvent.CLICK,this.closePanel);
         this.main.initButton(this.panelMC.btnConfirm,this.openBuyQuantity,"Select");
      }
      
      private function openBuyQuantity(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.selectedReward < 0)
         {
            this.main.showMessage("Please Select 1");
            return;
         }
         if(this.ownedTicket < 1)
         {
            if(this.rewardList[this.selectedReward].code != "pet")
            {
               this.main.showMessage("You don\'t have Redeem Ticket");
               return;
            }
         }
         if(this.rewardList[this.selectedReward].code == "dragon_ball")
         {
            this.panelMC.dbSelectMC.visible = true;
            this.panelMC.dbSelectMC.txt_title.text = "Select Dragon Ball";
            this.panelMC.dbSelectMC.txt_notice.text = "Note: you will get all the dragon ball from selected color";
            this.cost = 2;
            this.resetSelectedDragonBall();
            this.eventHandler.addListener(this.panelMC.dbSelectMC.btnClose,MouseEvent.CLICK,this.closeDragonBallSelect);
            this.main.initButton(this.panelMC.dbSelectMC.buyBtn,this.openConfirmation,"Exchange");
            _loc2_ = 0;
            while(_loc2_ < this.dragonBall.length)
            {
               NinjaSage.loadItemIcon(this.panelMC.dbSelectMC["iconMC" + _loc2_],this.dragonBall[_loc2_]);
               this.eventHandler.addListener(this.panelMC.dbSelectMC["iconMC" + _loc2_],MouseEvent.CLICK,this.selectDragonBall);
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = this.panelMC.qtyMC;
            this.panelMC.qtyMC.visible = true;
            if(this.rewardList[this.selectedReward].hasOwnProperty("swf"))
            {
               _loc3_.nextBtn.visible = false;
               _loc3_.prevBtn.visible = false;
               _loc3_.iconMC.visible = false;
               _loc3_.petIcon.visible = true;
               _loc4_ = PetInfo.getPetStats(this.rewardList[this.selectedReward].swf);
               _loc3_.petIcon.nameTxt.text = "Pet " + _loc4_.pet_name;
               _loc3_.petIcon.descTxt.text = _loc4_.description;
               _loc3_.petIcon.dateTxt.text = "Pet will be refreshed in " + this.rewardList[this.selectedReward].expiry;
               GF.removeAllChild(_loc3_.petIcon.iconMc.iconHolder);
               NinjaSage.loadIconSWF("pets",this.rewardList[this.selectedReward].swf,_loc3_.petIcon.iconMc.iconHolder,"with_holder");
            }
            else
            {
               _loc3_.nextBtn.visible = true;
               _loc3_.prevBtn.visible = true;
               _loc3_.iconMC.visible = true;
               _loc3_.petIcon.visible = false;
            }
            this.eventHandler.addListener(_loc3_.nextBtn,MouseEvent.CLICK,this.changeAmount);
            this.eventHandler.addListener(_loc3_.prevBtn,MouseEvent.CLICK,this.changeAmount);
            this.eventHandler.addListener(_loc3_.btnClose,MouseEvent.CLICK,this.closeQuantity);
            this.main.initButton(_loc3_.buyBtn,this.openConfirmation,"Exchange");
            this.price = this.rewardList[this.selectedReward].qty;
            this.cost = this.price * this.amount;
            _loc3_.iconMC.gotoAndStop(this.rewardList[this.selectedReward].code);
            _loc3_.iconMC.itemType.highlightMC.gotoAndStop(1);
            _loc3_.amountTxt.text = this.amount;
            _loc3_.iconMC.itemType.descTxt.text = this.cost + " " + this.selectedRewardName;
         }
      }
      
      private function changeAmount(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         var _loc3_:* = this.panelMC.qtyMC;
         if(this.amount <= 1 && _loc2_ != "nextBtn")
         {
            return;
         }
         if(this.amount >= this.ownedTicket && _loc2_ == "nextBtn")
         {
            this.main.showMessage("Cannot exceed owned ticket");
            return;
         }
         if(_loc2_ == "nextBtn")
         {
            this.amount += 1;
         }
         else
         {
            --this.amount;
         }
         this.cost = this.price * this.amount;
         _loc3_.amountTxt.text = this.amount;
         _loc3_.iconMC.itemType.descTxt.text = this.cost + " " + this.selectedRewardName;
      }
      
      private function selectDragonBall(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.currentTarget.name.replace("iconMC",""));
         this.resetSelectedDragonBall();
         this.panelMC.dbSelectMC["iconMC" + _loc2_].tick.visible = true;
         this.selectedDragonBall = _loc2_;
         this.selectedDragonBallMaterial = this.dragonBall[this.selectedDragonBall];
      }
      
      private function resetSelectedDragonBall() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.dragonBall.length)
         {
            this.panelMC.dbSelectMC["iconMC" + _loc1_].tick.visible = false;
            _loc1_++;
         }
      }
      
      private function exchangeTicket(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("LfKCy8lSBGn7O5WS.L3Fcb4y44gyf",[Character.char_id,Character.sessionkey,this.rewardList[this.selectedReward].code,this.amount,this.selectedDragonBallMaterial],this.onExchange);
      }
      
      private function onExchange(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(this.cost + " " + this.selectedRewardName + " Obtained");
            if(param1.materials.material_2063 > 0)
            {
               Character.replaceMaterials("material_2063",param1.materials.material_2063);
            }
            if(param1.materials.material_1002 > 0)
            {
               Character.replaceMaterials("material_1002",param1.materials.material_1002);
            }
            if(param1.materials.material_874 > 0)
            {
               Character.replaceMaterials("material_874",param1.materials.material_874);
            }
            if(param1.materials.material_69 > 0)
            {
               Character.replaceMaterials("material_69",param1.materials.material_69);
            }
            if(param1.materials.material_939 > 0)
            {
               Character.replaceMaterials("material_939",param1.materials.material_939);
            }
            if(param1.materials.material_941 > 0)
            {
               Character.replaceMaterials("material_941",param1.materials.material_941);
            }
            Character.account_tokens = param1.currencies.tokens;
            Character.character_gold = param1.currencies.gold;
            Character.character_tp = param1.currencies.tp;
            Character.character_ss = param1.currencies.ss;
            Character.character_prestige = param1.currencies.prestige;
            Character.character_merit = param1.currencies.merit;
            Character.character_pvp_point = param1.currencies.pvp_points;
            this.main.HUD.setBasicData();
            this.panelMC.txt_ticket.text = param1.materials.material_2063;
            GF.removeAllChild(this.confirmation);
            if(this.rewardList[this.selectedReward].hasOwnProperty("swf"))
            {
               this.main.giveReward(1,this.rewardList[this.selectedReward].swf);
            }
            if(this.rewardList[this.selectedReward].code == "dragon_ball")
            {
               Character.addRewards(this.dragonBallTier[this.selectedDragonBall].materialId);
               this.main.giveReward(1,this.dragonBallTier[this.selectedDragonBall].materialId);
            }
            this.closeDragonBallSelect();
            this.closeQuantity();
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
      
      private function closeQuantity(param1:MouseEvent = null) : *
      {
         this.panelMC.qtyMC.visible = false;
         GF.removeAllChild(this.panelMC.qtyMC.petIcon.iconMc.iconHolder);
         this.amount = 1;
         this.price = 1;
         this.cost = 1;
      }
      
      private function closeDragonBallSelect(param1:MouseEvent = null) : *
      {
         this.panelMC.dbSelectMC.visible = false;
         this.selectedDragonBall = -1;
         this.selectedDragonBallMaterial = null;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            this.panelMC.dbSelectMC["iconMC" + _loc2_].tick.visible = false;
            GF.removeAllChild(this.panelMC.dbSelectMC["iconMC" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.dbSelectMC["iconMC" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function openConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         if(this.rewardList[this.selectedReward].code == "dragon_ball" && this.selectedDragonBall == -1)
         {
            this.main.showMessage("Please select at least 1 dragon ball package");
            return;
         }
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are You Sure That You Want To Exchange " + this.amount + " Ticket To Redeem " + this.cost + " " + this.selectedRewardName + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.exchangeTicket);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function openRecharge(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.Recharge");
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
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.dragonBall = [];
         this.dragonBallTier = [];
         this.main = null;
         this.eventHandler = null;
         this.confirmation = null;
         this.currentPage = 1;
         this.totalPage = 0;
         this.amount = 1;
         this.price = 1;
         this.cost = 1;
         this.selectedReward = -1;
         this.selectedRewardName = null;
         GF.clearArray(this.rewardList);
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

