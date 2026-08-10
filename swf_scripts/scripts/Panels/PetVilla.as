package Panels
{
   import Managers.ExpManager;
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2922")]
   public dynamic class PetVilla extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panel:MovieClip;
      
      public var main:*;
      
      public var tooltip:ToolTip;
      
      public var pets:Array = [];
      
      public var all_pets:Array;
      
      public var filtered_pets:Array;
      
      public var array_info_holder:Array = [];
      
      public var curr_page:int = 1;
      
      public var total_page:int = 1;
      
      public var selected_pet_index:int = -1;
      
      public var selected_pet_slot_index:int = -1;
      
      public var crframe:* = 0;
      
      public var display_pet_number:int = 0;
      
      public var slots:Array;
      
      private var trainPetSlot1:PetTraining;
      
      private var trainPetSlot2:PetTraining;
      
      private var trainPetSlot3:PetTraining;
      
      private var trainPetSlot4:PetTraining;
      
      private var trainPetSlotArr:Array;
      
      public var trained_pet:*;
      
      public var eventHandler:* = new EventHandler();
      
      public var skipPrice:int = 0;
      
      public var confirmation:*;
      
      private var buySlotMethod:String;
      
      public function PetVilla(param1:*)
      {
         this.pet_mcs = [];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClose);
         this.trainPetSlot1 = new PetTraining();
         this.trainPetSlot2 = new PetTraining();
         this.trainPetSlot3 = new PetTraining();
         this.trainPetSlot4 = new PetTraining();
         this.trainPetSlotArr = [this.trainPetSlot1,this.trainPetSlot2,this.trainPetSlot3,this.trainPetSlot4];
         this.main = param1;
         this.setDefaultUI();
      }
      
      public function setDefaultUI() : *
      {
         this.main.handleVillageHUDVisibility(false);
         this.panel.popUpUnlockMC.visible = false;
         this.panel.popUpCompleteMC.visible = false;
         this.panel.heyaDarenMC.visible = false;
         this.panel.btnHide.tick.visible = true;
         this.eventHandler.addListener(this.panel.btnClose,MouseEvent.CLICK,this.onClose,false,0,true);
         this.eventHandler.addListener(this.panel.btnPrevPage,MouseEvent.CLICK,this.changePage,false,0,true);
         this.eventHandler.addListener(this.panel.btnNextPage,MouseEvent.CLICK,this.changePage,false,0,true);
         this.eventHandler.addListener(this.panel.btnHide,MouseEvent.CLICK,this.hideMaxLevelPets,false,0,true);
         this.main.initButton(this.panel.convertBtn,this.openRecharge);
         this.main.initButton(this.panel.getMoreBtn,this.openRecharge);
         this.init();
      }
      
      public function init() : *
      {
         this.panel.goldTxt.text = String(Character.character_gold);
         this.panel.tokenTxt.text = String(Character.account_tokens);
         this.panel.titleTxt.text = "Pet Villa";
         this.getPets();
      }
      
      public function getPets() : *
      {
         this.main.loading(true);
         var _loc1_:Array = [Character.char_id,Character.sessionkey];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["lsm8FxN9JVXl",_loc1_],this.onGetPets);
      }
      
      public function onGetPets(param1:Object) : *
      {
         var _loc2_:* = undefined;
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this.main.getNotice(param1.result);
               return;
            }
            this.slots = param1.slots;
            this.all_pets = param1.pets;
            this.filtered_pets = [];
            _loc2_ = 0;
            while(_loc2_ < this.all_pets.length)
            {
               if(this.all_pets[_loc2_].pet_level < Character.character_lvl)
               {
                  this.filtered_pets.push(this.all_pets[_loc2_]);
               }
               _loc2_++;
            }
            this.pets = this.panel.btnHide.tick.visible ? this.filtered_pets : this.all_pets;
            this.curr_page = 1;
            this.total_page = Math.max(Math.ceil(this.pets.length / 6),1);
            this.displayPets();
            this.displaySlots();
            this.updatePageText();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function hideMaxLevelPets(param1:MouseEvent) : void
      {
         this.panel.btnHide.tick.visible = !this.panel.btnHide.tick.visible;
         this.pets = this.panel.btnHide.tick.visible ? this.filtered_pets : this.all_pets;
         this.curr_page = 1;
         this.total_page = Math.max(Math.ceil(this.pets.length / 6),1);
         this.displayPets();
         this.updatePageText();
      }
      
      public function findPet(param1:int) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.pets.length)
         {
            if(this.pets[_loc2_].pet_id == param1)
            {
               return this.pets[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function displaySlots() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            if(this.slots[_loc1_].status == 0)
            {
               this.panel["roomMC_" + _loc1_].gotoAndStop("lock");
               this.panel["roomMC_" + _loc1_].readyTxt.text = "Slot Locked";
               this.main.initButton(this.panel["roomMC_" + _loc1_].functionBtn,this.buySlotPopup,"Buy Slot");
            }
            else if(this.slots[_loc1_].status == 1)
            {
               this.panel["roomMC_" + _loc1_].gotoAndStop("waiting");
            }
            else if(this.slots[_loc1_].status == 2)
            {
               _loc2_ = this.findPet(this.slots[_loc1_].pet_id);
               if(_loc2_ == null)
               {
                  _loc1_++;
                  continue;
               }
               this.panel["roomMC_" + _loc1_].gotoAndStop("normal");
               GF.removeAllChild(this.panel["roomMC_" + _loc1_].iconHolder);
               NinjaSage.loadIconSWF("pets",_loc2_.pet_swf,this.panel["roomMC_" + _loc1_].iconHolder,"PetStaticFullBody");
               this.panel["roomMC_" + _loc1_].petNameTxt.text = _loc2_.pet_name;
               this.panel["roomMC_" + _loc1_].lvMC.txt.text = _loc2_.pet_level;
               _loc3_ = this.getTrainData(_loc2_.pet_level + 1,"second");
               this.panel["roomMC_" + _loc1_].functionBtn.metaData = {
                  "pet_id":this.slots[_loc1_].pet_id,
                  "skip_price":this.slots[_loc1_].skip_price
               };
               this.panel["roomMC_" + _loc1_].cancelBtn.metaData = {"pet_id":this.slots[_loc1_].pet_id};
               this.main.initButton(this.panel["roomMC_" + _loc1_].functionBtn,this.skipTrainingConfirmation,"Skip");
               this.main.initButton(this.panel["roomMC_" + _loc1_].cancelBtn,this.cancelTrainingConfirmation,"Cancel");
               this.trainPetSlotArr[_loc1_].startTimer(_loc2_.pet_id,this["panel"]["roomMC_" + _loc1_],this.slots[_loc1_].completed_at,_loc3_,this.onTrainPetTick,this.onTrainPetComplete);
            }
            else if(this.slots[_loc1_].status == 3)
            {
               _loc2_ = this.findPet(this.slots[_loc1_].pet_id);
               if(_loc2_ == null)
               {
                  _loc1_++;
                  continue;
               }
               this.panel["roomMC_" + _loc1_].gotoAndStop("done");
               GF.removeAllChild(this.panel["roomMC_" + _loc1_].iconHolder);
               NinjaSage.loadIconSWF("pets",_loc2_.pet_swf,this.panel["roomMC_" + _loc1_].iconHolder,"PetStaticFullBody");
               this.panel["roomMC_" + _loc1_].functionBtn.visible = true;
               this.panel["roomMC_" + _loc1_].petNameTxt.text = _loc2_.pet_name;
               this.panel["roomMC_" + _loc1_].lvMC.txt.text = _loc2_.pet_level;
               this.panel["roomMC_" + _loc1_].functionBtn.metaData = {"pet_id":this.slots[_loc1_].pet_id};
               this.main.initButton(this.panel["roomMC_" + _loc1_].functionBtn,this.onCheckoutPet,"OK");
            }
            else
            {
               this.panel["roomMC_" + _loc1_].gotoAndStop("lock");
               this.panel["roomMC_" + _loc1_].readyTxt.text = "Slot Locked";
            }
            _loc1_++;
         }
      }
      
      public function skipTrainingConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.skipPrice = e.currentTarget.metaData.skip_price;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure to checkout this pet early, it costs " + this.skipPrice + " tokens ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.confirmation.btn_confirm.metaData = {"pet_id":e.currentTarget.metaData.pet_id};
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.skipTraining);
         addChild(this.confirmation);
      }
      
      public function skipTraining(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         var _loc2_:Array = [Character.char_id,Character.sessionkey,param1.currentTarget.metaData.pet_id];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["ue3Z6iIxP5Zm",_loc2_],this.onSkipTrain);
      }
      
      public function onSkipTrain(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            Character.account_tokens -= this.skipPrice;
            this.init();
            this.main.HUD.setBasicData();
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
      
      public function cancelTrainingConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure to cancel pet training? gold spent will not returned";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.confirmation.btn_confirm.metaData = {"pet_id":e.currentTarget.metaData.pet_id};
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.cancelTraining);
         addChild(this.confirmation);
      }
      
      public function cancelTraining(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         var _loc2_:Array = [Character.char_id,Character.sessionkey,param1.currentTarget.metaData.pet_id];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["Kxo1PC8Bvz0R",_loc2_],this.onCancelTrain);
      }
      
      public function onCancelTrain(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            this.init();
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
      
      public function onError(param1:*) : *
      {
      }
      
      public function displayPets(param1:* = null) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         while(_loc11_ < 6)
         {
            _loc2_ = _loc11_ + int(int(this.curr_page - 1) * 6);
            if(this.pets.length > _loc2_)
            {
               this.panel["petMC_" + _loc11_].gotoAndStop("normal");
               this.panel["petMC_" + _loc11_].visible = true;
               GF.removeAllChild(this.panel["petMC_" + _loc11_].iconHolder);
               NinjaSage.loadIconSWF("pets",this.pets[_loc2_].pet_swf,this.panel["petMC_" + _loc11_].iconHolder,"PetStaticFullBody");
               this.panel["petMC_" + _loc11_].nameTxt.text = this.pets[_loc2_].pet_name;
               this.panel["petMC_" + _loc11_].lvMC.txt.text = this.pets[_loc2_].pet_level;
               _loc3_ = int(this.pets[_loc2_].pet_level);
               if(_loc3_ >= int(Character.character_lvl))
               {
                  this.panel["petMC_" + _loc11_].lvCapTxt.visible = true;
                  this.panel["petMC_" + _loc11_].lvCapTxt.text = "Max. Reached";
                  this.panel["petMC_" + _loc11_].trainTimeTxt.visible = false;
                  this.panel["petMC_" + _loc11_].hourTxt.visible = false;
                  this.panel["petMC_" + _loc11_].lvMC1.visible = false;
                  this.panel["petMC_" + _loc11_].lvMC2.visible = false;
                  this.panel["petMC_" + _loc11_].arrowMc.visible = false;
                  this.panel["petMC_" + _loc11_].trainBtn.visible = false;
                  this.panel["petMC_" + _loc11_].xpMC.xpTxt.text = this.pets[_loc2_].pet_xp + "/" + ExpManager.calculate_pet_xp(int(_loc3_));
                  this.panel["petMC_" + _loc11_].xpMC.xpBar.scaleX = this.pets[_loc2_].pet_xp / ExpManager.calculate_pet_xp(int(_loc3_));
               }
               else
               {
                  this.panel["petMC_" + _loc11_].lvCapTxt.visible = false;
                  this.panel["petMC_" + _loc11_].trainTimeTxt.visible = true;
                  this.panel["petMC_" + _loc11_].hourTxt.visible = true;
                  this.panel["petMC_" + _loc11_].lvMC1.visible = true;
                  this.panel["petMC_" + _loc11_].lvMC2.visible = true;
                  this.panel["petMC_" + _loc11_].arrowMc.visible = true;
                  this.panel["petMC_" + _loc11_].trainBtn.visible = true;
                  this.panel["petMC_" + _loc11_].lvMC1.txt.text = _loc3_;
                  this.panel["petMC_" + _loc11_].lvMC2.txt.text = int(_loc3_) + 1;
                  this.panel["petMC_" + _loc11_].xpMC.xpTxt.text = this.pets[_loc2_].pet_xp + "/" + ExpManager.calculate_pet_xp(int(_loc3_));
                  this.panel["petMC_" + _loc11_].xpMC.xpBar.scaleX = this.pets[_loc2_].pet_xp / ExpManager.calculate_pet_xp(int(_loc3_));
                  this.panel["petMC_" + _loc11_].hourTxt.text = this.pets[_loc2_].train_time_text;
                  this.panel["petMC_" + _loc11_].trainBtn.metaData = {"pet_id":this.pets[_loc2_].pet_id};
                  this.main.initButton(this.panel["petMC_" + _loc11_].trainBtn,this.onClickTrainPet,this.pets[_loc2_].train_gold);
               }
            }
            else
            {
               this.panel["petMC_" + _loc11_].gotoAndStop("noPet");
               this.main.initButton(this.panel["petMC_" + _loc11_].buyPetBtn,this.openPetShop,"Buy a Pet");
            }
            _loc11_++;
         }
      }
      
      public function onClickTrainPet(param1:MouseEvent) : *
      {
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,param1.currentTarget.metaData.pet_id];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["dHyadkhGj7K6",_loc2_],this.trainPetResponse);
      }
      
      public function trainPetResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            this.init();
         }
         else
         {
            if(param1.status != 0)
            {
               this.main.showMessage(param1.result);
               return;
            }
            this.main.getError(param1.error);
         }
      }
      
      public function onCheckoutPet(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.trained_pet = param1.currentTarget.metaData.pet_id;
         var _loc2_:Array = [Character.char_id,Character.sessionkey,param1.currentTarget.metaData.pet_id];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["UYi3tKwT2D4L",_loc2_],this.checkoutPetResponse);
      }
      
      public function checkoutPetResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panel.popUpCompleteMC.panel.lvCapMC.visible = false;
            _loc2_ = this.findPet(this.trained_pet);
            this.panel.popUpCompleteMC.visible = true;
            GF.removeAllChild(this.panel.popUpCompleteMC.panel.iconHolder);
            NinjaSage.loadIconSWF("pets",_loc2_.pet_swf,this.panel.popUpCompleteMC.panel.iconHolder,"PetStaticFullBody");
            this.panel.popUpCompleteMC.panel.titleTxt.text = "Training Completed";
            this.panel.popUpCompleteMC.panel.displayTxt.text = "Your pet\'s training is completed";
            this.panel.popUpCompleteMC.panel.petNameTxt.text = _loc2_.pet_name;
            this.panel.popUpCompleteMC.panel.lvMC.txt.text = _loc2_.pet_level + 1;
            if(_loc2_.pet_level >= Character.character_lvl)
            {
               this.panel.popUpCompleteMC.panel.lvCapMC.visible = true;
            }
            this.main.initButton(this.panel.popUpCompleteMC.panel.okBtn,this.closePopupComplete,"OK");
         }
         else
         {
            if(param1.status != 0)
            {
               this.main.showMessage(param1.result);
               return;
            }
            this.main.getError(param1.error);
         }
      }
      
      public function buySlotPopup(param1:MouseEvent) : *
      {
         this.panel.popUpUnlockMC.visible = true;
         var _loc2_:MovieClip = this.panel.popUpUnlockMC.panel;
         _loc2_.titleTxt.text = "Buy Room Slot";
         _loc2_.displayTxt.text = "You can buy slot using token, friendship kunai or buy emblem to instantly unlock all room";
         _loc2_.inviteFdBtn.visible = false;
         _loc2_.fkMC.visible = false;
         _loc2_.typeMC_0.gotoAndStop("token");
         _loc2_.typeMC_0.typeTxt.text = "Token";
         this.main.initButton(_loc2_.typeMC_0.itemTokenBtn,this.onBuySlot,"400");
         _loc2_.typeMC_1.gotoAndStop("fk");
         _loc2_.typeMC_1.typeTxt.text = "Friendship Kunai";
         this.main.initButton(_loc2_.typeMC_1.itemFKBtn,this.onBuySlot,"300");
         _loc2_.typeMC_2.gotoAndStop("emblem");
         _loc2_.typeMC_2.typeTxt.text = "Ninja Emblem";
         this.main.initButton(_loc2_.typeMC_2.itemEmblemBtn,this.openRecharge,"Get Now!");
         this.eventHandler.addListener(_loc2_.btnClose,MouseEvent.CLICK,this.closePopup,false,0,true);
      }
      
      public function onBuySlot(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         switch(param1.currentTarget.name)
         {
            case "itemTokenBtn":
               _loc2_ = "tokens";
               break;
            case "itemFKBtn":
               _loc2_ = "kunai";
               break;
            default:
               return;
         }
         this.buySlotMethod = _loc2_;
         var _loc3_:Array = [Character.char_id,Character.sessionkey,_loc2_];
         this.main.loading(true);
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["pvRR9Oi7KqdJ",_loc3_],this.onBuyAMFResponse);
      }
      
      public function onBuyAMFResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Slot Succesfully Unlocked!");
            if(this.buySlotMethod == "tokens")
            {
               Character.account_tokens -= 400;
            }
            else
            {
               Character.removeMaterials("material_1002",300);
            }
            this.init();
         }
         else
         {
            if(param1.status != 0)
            {
               this.main.showMessage(param1.result);
               return;
            }
            this.main.getError(param1.error);
         }
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNextPage":
               if(this.total_page > this.curr_page)
               {
                  ++this.curr_page;
                  this.displayPets();
               }
               break;
            case "btnPrevPage":
               if(this.curr_page > 1)
               {
                  --this.curr_page;
                  this.displayPets();
               }
         }
         this.updatePageText();
      }
      
      public function updatePageText() : *
      {
         this.panel.pageTxt.text = this.curr_page + "/" + this.total_page;
      }
      
      internal function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      internal function openSocial(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Social");
      }
      
      internal function openPetShop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.PetShop");
         this.onClose(null);
      }
      
      public function closePopup(param1:MouseEvent) : *
      {
         this.panel.popUpUnlockMC.visible = false;
      }
      
      public function closePopupComplete(param1:MouseEvent) : *
      {
         this.panel.popUpCompleteMC.visible = false;
         this.init();
      }
      
      public function onClose(param1:MouseEvent) : *
      {
         this.main.handleVillageHUDVisibility(true);
         this.main.HUD.setBasicData();
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc2_ < 4)
         {
            GF.removeAllChild(this.panel["roomMC_" + _loc2_].iconHolder);
            _loc2_++;
         }
         while(_loc3_ < 6)
         {
            GF.removeAllChild(this.panel["petMC_" + _loc3_].iconHolder);
            _loc3_++;
         }
         GF.removeAllChild(this.panel.popUpCompleteMC.panel.iconHolder);
         parent.removeChild(this);
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         if(this.tooltip)
         {
            this.tooltip.destroy();
         }
         GF.destroyArray(this.trainPetSlotArr);
         GF.removeAllChild(this.panel);
         GF.clearArray(this.pets);
         GF.clearArray(this.array_info_holder);
         GF.clearArray(this.slots);
         this.trainPetSlotArr = null;
         this.tooltip = null;
         this.main = null;
         this.pets = null;
         this.array_info_holder = null;
         this.slots = null;
         this.eventHandler = null;
         Log.debug(this,"DESTROY");
         System.gc();
      }
      
      private function getTrainData(param1:uint, param2:String) : *
      {
         if(param2 == "second")
         {
            return Number((param1 - 1) * 1440);
         }
         if(param2 == "gold")
         {
            return (param1 - 1) * 2000;
         }
         return 0;
      }
      
      private function onTrainPetTick(param1:int) : void
      {
         if(!this.slots)
         {
            return;
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.slots.length)
         {
            if(this.slots[_loc2_].pet_id == param1)
            {
               --this.slots[_loc2_].completed_at;
            }
            _loc2_++;
         }
      }
      
      private function onTrainPetComplete(param1:int) : void
      {
         this.slots[param1].status = 3;
         this.clearAllTrainPetSlot();
         this.displaySlots();
      }
      
      private function clearAllTrainPetSlot() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.trainPetSlotArr.length)
         {
            this.trainPetSlotArr[_loc1_].stopTimer();
            _loc1_++;
         }
      }
   }
}

