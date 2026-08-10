package Panels
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.BlacksmithData;
   import Storage.Character;
   import Storage.Library;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3449")]
   public dynamic class Blacksmith extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panel:MovieClip;
      
      public var main:*;
      
      public var orig_indicator:* = "wpn";
      
      public var array_info_holder:Array;
      
      internal var character_weapons_amount:Array;
      
      internal var curr_page:* = 1;
      
      internal var itemCnt:* = 0;
      
      internal var itList:*;
      
      internal var total_page:* = 1;
      
      public var curr_page_items:Array;
      
      private var tooltip:ToolTip;
      
      private var confirmation:*;
      
      private var eventHandler:*;
      
      public function Blacksmith(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.itList = BlacksmithData.weaponList;
         this.curr_page_items = [];
         this.array_info_holder = [];
         this.main = param1;
         this.tooltip = ToolTip.getInstance();
         this.eventHandler = new EventHandler();
         this.main.handleVillageHUDVisibility(false);
         this.eventHandler.addListener(this.panel.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panel.nextPageBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panel.prevPageBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panel.buyGold,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panel.buyToken,MouseEvent.CLICK,this.openRecharge);
         this.panel.txt_gold.text = Character.character_gold;
         this.panel.txt_token.text = Character.account_tokens;
         var _loc2_:* = 1;
         while(_loc2_ < 7)
         {
            this.panel.ownedMagatama["level_" + _loc2_].text = this.getMaterial("material_0" + _loc2_);
            _loc2_++;
         }
         this.loadCategory();
      }
      
      public function openRecharge(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.main.handleVillageHUDVisibility(true);
         this.main = null;
         this.array_info_holder = null;
         this.eventHandler.removeAllEventListeners();
         this.curr_page_items = null;
         this.itList = null;
         this.tooltip = null;
         this.confirmation = null;
         this.eventHandler = null;
         var _loc2_:* = 0;
         while(_loc2_ < 3)
         {
            GF.removeAllChild(this.panel["item_" + _loc2_].iconMc.iconHolder);
            GF.removeAllChild(this.panel["item_" + _loc2_].iconMc1.iconHolder);
            _loc2_++;
         }
         if(NinjaSage.loader != null)
         {
            NinjaSage.loader.removeAll();
         }
         this.panel = null;
         GF.removeAllChild(this);
         System.gc();
      }
      
      internal function getMaterial(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = [];
         if(Character.character_materials != "")
         {
            if(Character.character_materials.indexOf(",") >= 0)
            {
               _loc3_ = Character.character_materials.split(",");
            }
            else
            {
               _loc3_ = [Character.character_materials];
            }
         }
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_].split(":");
            if(_loc2_[0] == param1)
            {
               return _loc2_[1];
            }
            _loc4_++;
         }
         return 0;
      }
      
      internal function loadCategory() : void
      {
         this.itemCnt = 0;
         this.curr_page = 1;
         this.total_page = 1;
         this.itList = BlacksmithData.weaponList;
         this.orig_indicator = "wpn";
         var _loc1_:* = 3;
         this.total_page = int(this.itList.length / 3 + 1);
         if(this.itList.length < 4)
         {
            _loc1_ = this.itList.length;
            this.total_page = 1;
         }
         if(this.itList.length % 3 == 0)
         {
            this.total_page = this.itList.length / 3;
         }
         this.panel.pageTxt.text = this.curr_page + "/" + this.total_page;
         this.array_info_holder.splice(0);
         this.loadItems(this.itemCnt,this.curr_page);
      }
      
      internal function loadItems(param1:*, param2:*) : void
      {
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this.curr_page_items = [];
         var _loc7_:* = 0;
         var _loc8_:* = int(this.itList.length / param2);
         if(_loc8_ >= 3)
         {
            _loc8_ = 3;
         }
         else
         {
            _loc8_--;
         }
         while(_loc7_ < 3)
         {
            _loc4_ = this.itList[param1];
            _loc5_ = BlacksmithData.getForgeItems(_loc4_);
            if(_loc5_["item_materials"] == null)
            {
               this.panel["item_" + _loc7_].visible = false;
               _loc7_++;
            }
            else
            {
               this.panel["item_" + _loc7_].visible = true;
               this.curr_page_items.push(_loc4_);
               _loc6_ = Library.getItemInfo(_loc4_);
               this.panel["item_" + _loc7_].ownedTxt.text = Character.isItemOwned(_loc4_) ? "Owned" : "";
               _loc9_ = Library.getItemInfo(_loc5_["req_weapon"]);
               if(_loc4_ == null)
               {
                  this.panel["item_" + _loc7_].matqtyTxt.text = "x0";
               }
               else
               {
                  this.panel["item_" + _loc7_].matqtyTxt.text = "x" + this.calculateWeapon(_loc5_["req_weapon"]);
               }
               this.panel["item_" + _loc7_].matlvTxt.text = _loc9_["item_level"];
               this.eventHandler.addListener(this.panel["item_" + _loc7_].iconMc,MouseEvent.ROLL_OVER,this.tooltipOnHover,false,0,true);
               this.eventHandler.addListener(this.panel["item_" + _loc7_].iconMc1,MouseEvent.ROLL_OVER,this.tooltipOnHover,false,0,true);
               this.eventHandler.addListener(this.panel["item_" + _loc7_].iconMc,MouseEvent.ROLL_OUT,this.tooltipOnOut,false,0,true);
               this.eventHandler.addListener(this.panel["item_" + _loc7_].iconMc1,MouseEvent.ROLL_OUT,this.tooltipOnOut,false,0,true);
               this.panel["item_" + _loc7_].statusMC.gotoAndStop(2);
               GF.removeAllChild(this.panel["item_" + _loc7_].iconMc.iconHolder);
               GF.removeAllChild(this.panel["item_" + _loc7_].iconMc1.iconHolder);
               NinjaSage.loadIconSWF("items",_loc5_["req_weapon"],this.panel["item_" + _loc7_].iconMc);
               NinjaSage.loadIconSWF("items",_loc4_,this.panel["item_" + _loc7_].iconMc1);
               _loc10_ = _loc9_["item_premium"];
               _loc11_ = _loc6_["item_premium"];
               _loc12_ = {"wpn_id":_loc6_["item_id"]};
               this.panel["item_" + _loc7_].forgeBtn.metaData = _loc12_;
               this.eventHandler.addListener(this.panel["item_" + _loc7_].forgeBtn,MouseEvent.CLICK,this.onForgeItemRequest,false,0,true);
               this.panel["item_" + _loc7_].buyBtn.metaData = _loc12_;
               this.eventHandler.addListener(this.panel["item_" + _loc7_].buyBtn,MouseEvent.CLICK,this.onBuyItemRequest,false,0,true);
               this.panel["item_" + _loc7_].iconMc1.metaData = {"description":_loc6_["item_name"] + "\n" + "\nLevel " + _loc6_["item_level"] + "\n<font color=\"#ff0000\">Damage: " + _loc6_["item_damage"] + "</font>\n\n " + _loc6_["item_description"]};
               this.panel["item_" + _loc7_].emblemMc.visible = false;
               this.panel["item_" + _loc7_].iconMc.metaData = {"description":_loc9_["item_name"] + "\n" + "\nLevel " + _loc9_["item_level"] + "\n<font color=\"#ff0000\">Damage: " + _loc9_["item_damage"] + "</font>\n\n " + _loc9_["item_description"]};
               if(_loc10_ == true)
               {
                  this.panel["item_" + _loc7_].emblemMc.visible = true;
                  this.panel["item_" + _loc7_].emblemMc.gotoAndStop(2);
               }
               this.panel["item_" + _loc7_].forgelvTxt.text = _loc6_["item_level"];
               this.panel["item_" + _loc7_].matlvTxt.text = _loc9_["item_level"];
               this.panel["item_" + _loc7_].costTxt.text = _loc5_["gold_price"];
               this.panel["item_" + _loc7_].tokenTxt.text = _loc5_["token_price"] + " Tokens";
               this.panel["item_" + _loc7_].iconMc.visible = true;
               _loc13_ = 1;
               while(_loc13_ < 7)
               {
                  this.panel["item_" + _loc7_].requiredMaterials["level_" + _loc13_].text = "0";
                  _loc13_++;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc5_["item_materials"].length)
               {
                  this.panel["item_" + _loc7_].requiredMaterials["level_" + (_loc3_ + 1)].text = _loc5_["item_mat_price"][_loc3_];
                  _loc3_++;
               }
               _loc7_++;
               param1++;
            }
         }
         _loc7_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
      }
      
      internal function getWeaponRequired(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = [];
         if(Character.character_weapons != "")
         {
            if(Character.character_weapons.indexOf(",") >= 0)
            {
               _loc3_ = Character.character_weapons.split(",");
            }
            else
            {
               _loc3_ = [Character.character_weapons];
            }
         }
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_].split(":");
            if(_loc2_[0] == param1)
            {
               return _loc2_[1];
            }
            _loc4_++;
         }
         return 0;
      }
      
      public function onBuyItemRequest(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to buy this item?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.confirmation.btn_confirm.metaData = {"wpn_id":e.currentTarget.metaData.wpn_id};
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyItemRequest);
         addChild(this.confirmation);
      }
      
      public function buyItemRequest(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("6Hu2D6CELUrCZjuG.ci7L9Yqm8zUA",[Character.char_id,Character.sessionkey,param1.currentTarget.metaData.wpn_id,"tokens"],this.onForgeItemResponse);
      }
      
      public function onForgeItemRequest(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("6Hu2D6CELUrCZjuG.ci7L9Yqm8zUA",[Character.char_id,Character.sessionkey,param1.currentTarget.metaData.wpn_id,"gold"],this.onForgeItemResponse);
      }
      
      public function onForgeItemResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.main.loading(false);
         if(int(param1.status) > 0)
         {
            if(int(param1.status) == 1)
            {
               _loc2_ = param1.item;
               Character.addWeapon(_loc2_);
               _loc3_ = param1.requirements;
               _loc4_ = 0;
               while(_loc4_ < _loc3_[0].length)
               {
                  if(_loc3_[0][_loc4_].indexOf("material_") >= 0)
                  {
                     Character.removeMaterials(_loc3_[0][_loc4_],_loc3_[1][_loc4_]);
                  }
                  if(_loc3_[0][_loc4_].indexOf("wpn_") >= 0)
                  {
                     Character.removeWeapon(_loc3_[0][_loc4_],_loc3_[1][_loc4_]);
                  }
                  _loc4_++;
               }
               this.main.giveMessage(param1.result);
            }
            else
            {
               this.main.getNotice(param1.result);
            }
            this.loadCategory();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      internal function gotoCharacterSelect() : *
      {
         this.main.loadPanel("Panels.CharacterSelect");
      }
      
      internal function calculateWeapon(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = Character.character_weapons.split(",");
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_].split(":");
            if(_loc2_[0] == param1)
            {
               return _loc2_[1];
            }
            _loc4_++;
         }
         return 0;
      }
      
      internal function tooltipOnHover(param1:MouseEvent) : void
      {
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(param1.currentTarget.metaData.description);
      }
      
      internal function tooltipOnOut(param1:MouseEvent) : void
      {
         this.tooltip.hide();
      }
      
      internal function changePage(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "nextPageBtn")
         {
            if(this.curr_page < this.total_page)
            {
               ++this.curr_page;
               this.itemCnt += 3;
               this.array_info_holder.splice(0);
               this.loadItems(this.itemCnt,this.curr_page);
            }
         }
         else if(param1.currentTarget.name == "prevPageBtn")
         {
            if(this.curr_page != 1)
            {
               --this.curr_page;
               this.itemCnt -= 3;
               this.array_info_holder.splice(0);
               this.loadItems(this.itemCnt,this.curr_page);
            }
         }
         this.panel.pageTxt.text = this.curr_page + "/" + this.total_page;
      }
   }
}

