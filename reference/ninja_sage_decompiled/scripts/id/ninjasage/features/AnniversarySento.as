package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.StatManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class AnniversarySento extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var main;
      
      private var response:Object;
      
      private var petList:Object;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var selectedPet:Object;
      
      private var timeout;
      
      public function AnniversarySento(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.panelMC.popupRewardList.visible = false;
         this.panelMC.patpat.visible = false;
         this.panelMC.patpat.panel.popupSelectPet.visible = false;
         this.getData();
      }
      
      private function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.oGcGJ5sve2RX",[Character.char_id,Character.sessionkey],this.onGetEventData);
      }
      
      private function onGetEventData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.updateTimeLeft();
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.manBtn,MouseEvent.CLICK,this.openCharacterSento);
         this.eventHandler.addListener(this.panelMC.petBtn,MouseEvent.CLICK,this.openPetSento);
         this.eventHandler.addListener(this.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.panelMC.tokenTxt.text = Character.account_tokens;
      }
      
      private function openPetSento(param1:MouseEvent) : void
      {
         this.panelMC.patpat.visible = true;
         this.panelMC.patpat.panel.tokenTxt.text = Character.account_tokens;
         this.panelMC.patpat.panel.xpTxt.text = "";
         if(this.response.pet == 1)
         {
            this.panelMC.patpat.panel.combine_btn_mc.visible = false;
         }
         this.eventHandler.addListener(this.panelMC.patpat.panel.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.patpat.panel.btnClose,MouseEvent.CLICK,this.closePetSento);
         this.eventHandler.addListener(this.panelMC.patpat.panel.iconMc_0,MouseEvent.CLICK,this.getPetList);
         this.eventHandler.addListener(this.panelMC.patpat.panel.petcar,MouseEvent.CLICK,this.getPetList);
         this.eventHandler.addListener(this.panelMC.patpat.panel.combine_btn_mc,MouseEvent.CLICK,this.claimPetXp);
         this.eventHandler.addListener(this.panelMC.patpat.panel.popupSelectPet.panel.btnClose,MouseEvent.CLICK,this.closePetList);
         this.eventHandler.addListener(this.panelMC.patpat.panel.popupSelectPet.panel.btnConfirm,MouseEvent.CLICK,this.closePetList);
         this.eventHandler.addListener(this.panelMC.patpat.panel.popupSelectPet.panel.btnPrevPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.patpat.panel.popupSelectPet.panel.btnNextPage,MouseEvent.CLICK,this.changePage);
      }
      
      private function closePetSento(param1:MouseEvent) : void
      {
         this.panelMC.patpat.visible = false;
         this.panelMC.patpat.panel.petcar.visible = true;
         this.eventHandler.removeListener(this.panelMC.patpat.panel.iconMc_0,MouseEvent.CLICK,this.getPetList);
         this.panelMC.patpat.panel.iconMc_0.petIcon.tooltip = null;
         NinjaSage.clearEventListener();
         GF.removeAllChild(this.panelMC.patpat.panel.iconMc_0.petIcon.iconHolder);
      }
      
      private function getPetList(param1:MouseEvent) : void
      {
         this.panelMC.patpat.panel.popupSelectPet.visible = true;
         this.main.loading(true);
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["ba5tOM3HhspX",[Character.char_id,Character.sessionkey]],this.onGetPets);
      }
      
      private function onGetPets(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.petList = param1.pets;
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.loadPetIcon();
      }
      
      private function loadPetIcon() : void
      {
         var _loc2_:int = 0;
         this.resetSelectedPet();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 4);
            if(this.petList.length > _loc2_)
            {
               this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].visible = true;
               this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].pet_data = this.petList[_loc2_];
               this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].pet_name.text = this.petList[_loc2_].pet_name;
               this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].current_lvl.text = this.petList[_loc2_].pet_level;
               this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].xpTxt.text = this.petList[_loc2_].pet_xp + "/" + StatManager.calculate_pet_xp(int(this.petList[_loc2_].pet_level));
               this.eventHandler.addListener(this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_],MouseEvent.CLICK,this.selectPet);
               NinjaSage.loadItemIcon(this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].iconMc_0.rewardIcon.iconHolder,this.petList[_loc2_].pet_swf,"icon");
            }
            else
            {
               this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.totalPage = Math.max(Math.ceil(this.petList.length / 4),1);
         this.updatePageNumber();
      }
      
      private function selectPet(param1:MouseEvent) : void
      {
         this.resetSelectedPet();
         var _loc2_:int = param1.currentTarget.name.replace("pet_selectInnerFrame","");
         this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc2_].thistxt.visible = true;
         this.selectedPet = param1.currentTarget.pet_data;
         this.loadPatpatIcon(this.selectedPet.pet_swf);
      }
      
      private function loadPatpatIcon(param1:String) : void
      {
         NinjaSage.loadItemIcon(this.panelMC.patpat.panel.iconMc_0.petIcon.iconHolder,param1,"icon");
         this.panelMC.patpat.panel.petcar.visible = false;
      }
      
      private function resetSelectedPet() : void
      {
         this.selectedPet = -1;
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].thistxt.visible = false;
            _loc1_++;
         }
      }
      
      private function claimPetXp(param1:MouseEvent) : void
      {
         if(this.selectedPet == null)
         {
            this.main.getNotice("Please select pet first.");
            return;
         }
         this.main.loading(false);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.ra3UZuc7BegK",[Character.char_id,Character.sessionkey,this.selectedPet.pet_id],this.onClaimedPetXp);
      }
      
      private function onClaimedPetXp(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.gained_xp + " " + this.selectedPet.pet_name + " Pet XP Claimed");
            this.main.giveReward(1,"xp_" + param1.gained_xp);
            this.panelMC.patpat.panel.petcar.visible = false;
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
      
      private function closePetList(param1:MouseEvent) : void
      {
         this.panelMC.patpat.panel.popupSelectPet.visible = false;
         this.currentPage = 1;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            GF.removeAllChild(this.panelMC.patpat.panel.popupSelectPet.panel["pet_selectInnerFrame" + _loc2_].iconMc_0.rewardIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function openCharacterSento(param1:MouseEvent) : void
      {
         this.panelMC.popupRewardList.visible = true;
         this.panelMC.popupRewardList.panel.tokenTxt.text = Character.account_tokens;
         this.panelMC.popupRewardList.panel.titleTxt.text = "Ninja Sento";
         if(this.response.ninja == 1)
         {
            this.panelMC.popupRewardList.panel.combine_btn_mc.visible = false;
         }
         this.eventHandler.addListener(this.panelMC.popupRewardList.panel.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.popupRewardList.panel.btnClose,MouseEvent.CLICK,this.closeCharacterSento);
         this.eventHandler.addListener(this.panelMC.popupRewardList.panel.combine_btn_mc,MouseEvent.CLICK,this.claimDoubleReward);
      }
      
      private function closeCharacterSento(param1:MouseEvent) : void
      {
         this.panelMC.popupRewardList.visible = false;
      }
      
      private function claimDoubleReward(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.B64wr3MRpcQu",[Character.char_id,Character.sessionkey],this.onClaimedDoubleReward);
      }
      
      private function onClaimedDoubleReward(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Double XP & Gold Claimed for 1 Hour");
            this.response.timestamp = param1.remaining;
            this.panelMC.popupRewardList.panel.combine_btn_mc.visible = false;
            this.updateTimeLeft();
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
      
      private function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btnNextPage":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.loadPetIcon();
               }
               break;
            case "btnPrevPage":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.loadPetIcon();
               }
         }
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.patpat.panel.popupSelectPet.panel.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      public function updateTimeLeft() : void
      {
         if(this.response.timestamp == null)
         {
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:* = this.response.timestamp;
         var _loc5_:* = Math.floor(_loc4_ / _loc1_);
         var _loc6_:* = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         var _loc7_:* = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         this.panelMC.popupRewardList.panel.timeTxt.text = _loc5_ + ":" + _loc6_ + ":" + _loc7_;
         this.timeout = setTimeout(this.updateTimeLeft,10000);
         this.response.timestamp -= 10;
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "getMoreBtn")
         {
            this.main.loadPanel("Panels.Recharge");
         }
         else
         {
            this.main.loadExternalSwfPanel("Headquarter","Headquarter");
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
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.main = null;
         this.eventHandler = null;
         this.petList = null;
         this.selectedPet = null;
         this.response = null;
         this.timeout = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}
