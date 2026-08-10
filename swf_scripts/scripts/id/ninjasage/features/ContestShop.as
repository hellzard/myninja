package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.Library;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ContestShop extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var wpnArray:Array;
      
      private var backArray:Array;
      
      private var curr_page:int = 1;
      
      private var last_page:int = 0;
      
      private var total_page:int = 0;
      
      private var orig_indicator:* = "mcWeapon";
      
      private var selectedArray:Array;
      
      private var confirmation:Confirmation;
      
      private var target:int;
      
      private var price:int;
      
      private var type:String;
      
      private var selectedItem:String;
      
      private var self:ContestShop;
      
      private var eventHandler:EventHandler;
      
      public function ContestShop(param1:*, param2:*)
      {
         super();
         this.wpnArray = ["wpn_2078","wpn_2077","wpn_2079","wpn_2080","wpn_2081","wpn_2051","wpn_2052","wpn_2053","wpn_2054","wpn_2055","wpn_2056","wpn_2057","wpn_2058","wpn_2059","wpn_2060","wpn_2061","wpn_2062"];
         this.backArray = ["back_2075","back_2076","back_2078","back_2077","back_2055","back_2056","back_2057","back_2058","back_2059","back_2060","back_2061","back_2062","back_2063","back_2064","back_2065","back_2066"];
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.main.handleVillageHUDVisibility(false);
         this.panelMC.mcWeapon.gotoAndStop(3);
         this.panelMC.mcBackItem.gotoAndStop(1);
         this.eventHandler.addListener(this.panelMC.mcWeapon,MouseEvent.CLICK,this.loadItem,false,0,true);
         this.eventHandler.addListener(this.panelMC.mcWeapon,MouseEvent.MOUSE_OVER,this.over,false,0,true);
         this.eventHandler.addListener(this.panelMC.mcWeapon,MouseEvent.MOUSE_OUT,this.out,false,0,true);
         this.eventHandler.addListener(this.panelMC.mcBackItem,MouseEvent.CLICK,this.loadItem,false,0,true);
         this.eventHandler.addListener(this.panelMC.mcBackItem,MouseEvent.MOUSE_OVER,this.over,false,0,true);
         this.eventHandler.addListener(this.panelMC.mcBackItem,MouseEvent.MOUSE_OUT,this.out,false,0,true);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage,false,0,true);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage,false,0,true);
         this.eventHandler.addListener(this.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge,false,0,true);
         this.eventHandler.addListener(this.panelMC.getMoreBtn1,MouseEvent.CLICK,this.openHeadquaters,false,0,true);
         this.eventHandler.addListener(this.panelMC.closeBtn,MouseEvent.CLICK,this.closePanel,false,0,true);
         this.curr_page = 1;
         this.loadItem();
      }
      
      private function loadItem(param1:* = null) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1 is MouseEvent)
         {
            this.panelMC.mcWeapon.gotoAndStop(1);
            this.panelMC.mcBackItem.gotoAndStop(1);
            param1.currentTarget.gotoAndStop(3);
            this.orig_indicator = param1.currentTarget.name;
            this.curr_page = 1;
         }
         if(this.orig_indicator == "mcWeapon")
         {
            this.selectedArray = this.wpnArray;
         }
         else
         {
            this.selectedArray = this.backArray;
         }
         this.panelMC.tokenTxt.text = String(Character.account_tokens);
         this.panelMC.goldTxt.text = String(Character.character_gold);
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = _loc2_ + int(int(this.curr_page - 1) * 5);
            if(this.selectedArray.length > _loc3_)
            {
               this.panelMC["item_" + _loc2_].visible = true;
               this.panelMC["item_" + _loc2_].ownedTxt.visible = false;
               _loc4_ = Library.getItemInfo(this.selectedArray[_loc3_]);
               if(_loc4_.item_price_gold > 0)
               {
                  this.panelMC["item_" + _loc2_].tokenMC.visible = false;
                  this.panelMC["item_" + _loc2_].goldMC.visible = true;
                  this.panelMC["item_" + _loc2_].goldMC.goldTxt.text = _loc4_.item_price_gold;
                  this.main.initButtonDisable(this.panelMC["item_" + _loc2_].tokenMC.tokenBuy,this.buyConfirmation,"Buy");
                  this.main.initButton(this.panelMC["item_" + _loc2_].goldMC.goldBuy,this.buyConfirmation,"Buy");
               }
               else
               {
                  this.panelMC["item_" + _loc2_].tokenMC.visible = true;
                  this.panelMC["item_" + _loc2_].goldMC.visible = false;
                  this.panelMC["item_" + _loc2_].tokenMC.tokenTxt.text = _loc4_.item_price_tokens;
                  this.main.initButtonDisable(this.panelMC["item_" + _loc2_].goldMC.goldBuy,this.buyConfirmation,"Buy");
                  this.main.initButton(this.panelMC["item_" + _loc2_].tokenMC.tokenBuy,this.buyConfirmation,"Buy");
               }
               if(Character.isItemOwned(this.selectedArray[_loc3_]) > 0)
               {
                  this.panelMC["item_" + _loc2_].ownedTxt.visible = true;
                  this.panelMC["item_" + _loc2_].ownedTxt.text = "Owned";
               }
               this.panelMC["item_" + _loc2_].itemName.text = _loc4_.item_name;
               this.panelMC["item_" + _loc2_].rewardIcon.colorType.gotoAndStop("special");
               GF.removeAllChild(this.panelMC["item_" + _loc2_].rewardIcon.iconHolder);
               NinjaSage.loadItemIcon(this.panelMC["item_" + _loc2_].rewardIcon.iconHolder,this.selectedArray[_loc3_],"icon");
            }
            else
            {
               this.panelMC["item_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         this.total_page = Math.max(Math.ceil(this.selectedArray.length / 5),1);
         this.updatePageText();
      }
      
      public function buyConfirmation(param1:MouseEvent) : *
      {
         var item:*;
         var getItemInfo:*;
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         item = e.currentTarget.parent.parent.name.replace("item_","");
         this.target = int(item) + int(int(this.curr_page - 1) * 5);
         this.selectedItem = this.selectedArray[this.target];
         getItemInfo = Library.getItemInfo(this.selectedItem);
         if(getItemInfo.item_price_gold > 0)
         {
            this.price = getItemInfo.item_price_gold;
            this.type = " Gold";
         }
         else
         {
            this.price = getItemInfo.item_price_tokens;
            this.type = " Token";
         }
         this.confirmation.txtMc.txt.text = "Are you sure that you want to buy " + getItemInfo.item_name + " for " + this.price + this.type;
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            GF.removeAllChild(confirmation);
         },false,0,true);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyItem,false,0,true);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function buyItem(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.main.loading(false);
         this.main.amf_manager.service("orA84WWheAf1SI5M.9wv9idwQqKxJ",[Character.char_id,Character.sessionkey,this.selectedItem],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            _loc2_ = this.selectedItem.split("_");
            if(_loc2_[0] == "wpn")
            {
               Character.addWeapon(this.selectedItem);
            }
            else if(_loc2_[0] == "back")
            {
               Character.addBack(this.selectedItem);
            }
            if(this.type == " Token")
            {
               Character.account_tokens -= this.price;
            }
            else
            {
               Character.character_gold = String(Number(Character.character_gold) - this.price);
            }
            this.main.giveReward(1,this.selectedItem);
            this.main.HUD.setBasicData();
            this.loadItem();
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
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_page > this.curr_page)
               {
                  ++this.curr_page;
                  this.loadItem();
               }
               break;
            case "btn_prev":
               if(this.curr_page > 1)
               {
                  --this.curr_page;
                  this.loadItem();
               }
         }
         this.updatePageText();
      }
      
      private function updatePageText() : *
      {
         this.panelMC.txt_page.text = this.curr_page + "/" + this.total_page;
      }
      
      private function openRecharge(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function openHeadquaters(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("Headquarter","Headquarter");
      }
      
      private function over(param1:MouseEvent) : *
      {
         if(param1.currentTarget.parent.currentFrame !== 3)
         {
            param1.currentTarget.parent.gotoAndStop(2);
         }
      }
      
      private function out(param1:MouseEvent) : *
      {
         if(param1.currentTarget.parent.currentFrame !== 3)
         {
            param1.currentTarget.parent.gotoAndStop(1);
         }
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
         this.main.handleVillageHUDVisibility(true);
         NinjaSage.clearLoader();
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].rewardIcon.iconHolder);
            _loc1_++;
         }
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main.removeExternalSwfPanel();
         this.main = null;
         this.curr_page = 0;
         this.last_page = 0;
         this.total_page = 0;
         this.orig_indicator = null;
         this.selectedArray = null;
         this.confirmation = null;
         this.target = 0;
         this.price = 0;
         this.type = null;
         this.selectedItem = null;
         GF.clearArray(this.wpnArray);
         GF.clearArray(this.backArray);
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

