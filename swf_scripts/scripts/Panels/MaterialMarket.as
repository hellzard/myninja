package Panels
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.ForgeData;
   import Storage.ItemDropSourceMapping;
   import Storage.Library;
   import Storage.PetInfo;
   import Storage.SkillLibrary;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5511")]
   public class MaterialMarket extends MovieClip
   {
      
      private static const FORGE_CATEGORY_BY_TAB:Object = {
         "Weapon":"wpn",
         "BackItem":"back",
         "Set":"set",
         "Accessory":"accessory",
         "Hairstyle":"hair",
         "Skill":"skill",
         "Pet":"pet",
         "Material":"material"
      };
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var item_0:MovieClip;
      
      public var item_1:MovieClip;
      
      public var item_2:MovieClip;
      
      public var materialList:* = [];
      
      public var mcAccessory:MovieClip;
      
      public var mcBackItem:MovieClip;
      
      public var mcHairstyle:MovieClip;
      
      public var mcPet:MovieClip;
      
      public var mcSet:MovieClip;
      
      public var mcSkill:MovieClip;
      
      public var mcWeapon:MovieClip;
      
      public var mcMaterial:MovieClip;
      
      public var nextPageBtn:SimpleButton;
      
      public var pageTxt:TextField;
      
      public var txt_category:TextField;
      
      public var prevPageBtn:SimpleButton;
      
      public var main:*;
      
      public var orig_indicator:* = "wpn";
      
      internal var curr_page:* = 1;
      
      internal var itemCnt:* = 0;
      
      internal var itList:*;
      
      internal var total_page:* = 1;
      
      public var curr_page_items:Array = [];
      
      public var is_loading:* = false;
      
      public var lnr:* = 0;
      
      public var eventHandler:*;
      
      private var confirmation:*;
      
      private var selectedItem:*;
      
      private var category:String = "default";
      
      public function MaterialMarket(param1:*, param2:String = "default")
      {
         super();
         this.category = param2;
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.eventHandler = new EventHandler();
         this.main = param1;
         this.main.handleVillageHUDVisibility(false);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.setCategoryText();
         this.getItems();
      }
      
      public function getItems() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("gyb2ZyH5v4Isex6h.9gmctgD8tOfL",[Character.char_id,Character.sessionkey],this.onGetItems);
      }
      
      public function onGetItems(param1:*) : *
      {
         if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
            return;
         }
         ForgeData.constructData(param1.items);
         this.setUI();
         this.mcWeapon.gotoAndStop(1);
         this.loadCategory("Weapon");
         this.main.loading(false);
      }
      
      internal function resetButtons() : void
      {
         this.mcWeapon.gotoAndStop(3);
         this.mcSet.gotoAndStop(3);
         this.mcBackItem.gotoAndStop(3);
         this.mcAccessory.gotoAndStop(3);
         this.mcHairstyle.gotoAndStop(3);
         this.mcSkill.gotoAndStop(3);
         this.mcPet.gotoAndStop(3);
         this.mcMaterial.gotoAndStop(3);
      }
      
      internal function setUI() : void
      {
         this.resetButtons();
         this.mcWeapon.buttonMode = true;
         this.eventHandler.addListener(this.mcWeapon,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.mcWeapon,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.mcWeapon,MouseEvent.CLICK,this.click);
         this.mcSet.buttonMode = true;
         this.eventHandler.addListener(this.mcSet,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.mcSet,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.mcSet,MouseEvent.CLICK,this.click);
         this.mcBackItem.buttonMode = true;
         this.eventHandler.addListener(this.mcBackItem,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.mcBackItem,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.mcBackItem,MouseEvent.CLICK,this.click);
         this.mcAccessory.buttonMode = true;
         this.eventHandler.addListener(this.mcAccessory,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.mcAccessory,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.mcAccessory,MouseEvent.CLICK,this.click);
         this.mcHairstyle.buttonMode = true;
         this.eventHandler.addListener(this.mcHairstyle,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.mcHairstyle,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.mcHairstyle,MouseEvent.CLICK,this.click);
         this.mcSkill.buttonMode = true;
         this.eventHandler.addListener(this.mcSkill,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.mcSkill,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.mcSkill,MouseEvent.CLICK,this.click);
         this.mcPet.buttonMode = true;
         this.eventHandler.addListener(this.mcPet,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.mcPet,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.mcPet,MouseEvent.CLICK,this.click);
         this.mcMaterial.buttonMode = true;
         this.eventHandler.addListener(this.mcMaterial,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.mcMaterial,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.mcMaterial,MouseEvent.CLICK,this.click);
         this.eventHandler.addListener(this.nextPageBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.prevPageBtn,MouseEvent.CLICK,this.changePage);
      }
      
      internal function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame != 1)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      internal function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame != 1)
         {
            param1.currentTarget.gotoAndStop(3);
         }
      }
      
      internal function click(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         if(param1.currentTarget.currentFrame != 1)
         {
            this.resetButtons();
            param1.currentTarget.gotoAndStop(1);
            _loc2_ = param1.currentTarget.name.split("mc");
            _loc2_ = _loc2_[1];
            this.loadCategory(_loc2_);
         }
         _loc2_ = null;
      }
      
      internal function clearSlots() : void
      {
         this.item_0.visible = false;
         this.item_1.visible = false;
         this.item_2.visible = false;
         GF.removeAllChild(this.item_0.iconMc.iconHolder);
         GF.removeAllChild(this.item_1.iconMc.iconHolder);
         GF.removeAllChild(this.item_2.iconMc.iconHolder);
         var _loc1_:* = 0;
         while(_loc1_ < 10)
         {
            this.item_0["item_" + _loc1_].visible = false;
            this.item_1["item_" + _loc1_].visible = false;
            this.item_2["item_" + _loc1_].visible = false;
            GF.removeAllChild(this.item_0["item_" + _loc1_].iconMC.iconHolder);
            GF.removeAllChild(this.item_1["item_" + _loc1_].iconMC.iconHolder);
            GF.removeAllChild(this.item_2["item_" + _loc1_].iconMC.iconHolder);
            _loc1_++;
         }
         _loc1_ = null;
      }
      
      private function setCategoryText() : void
      {
         if(this.category != "default")
         {
            this.txt_category.text = "Only showing items from " + ItemDropSourceMapping.getDisplayName(this.category) + " Category";
         }
      }
      
      private function filterItemsByCategory(param1:Array) : Array
      {
         var _loc3_:String = null;
         if(this.category == "default")
         {
            return param1;
         }
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(ForgeData.getForgeItems(_loc3_)["category"] == this.category)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      internal function loadCategory(param1:String, param2:int = 1, param3:* = 0) : void
      {
         if(this.is_loading)
         {
            return;
         }
         this.clearSlots();
         this.itemCnt = param3;
         this.curr_page = param2;
         this.total_page = 1;
         this.orig_indicator = param1;
         this.itList = this.filterItemsByCategory(ForgeData.getItemByCategory(FORGE_CATEGORY_BY_TAB[param1]));
         this.total_page = Math.max(Math.ceil(this.itList.length / 3),1);
         this.pageTxt.text = this.curr_page + "/" + this.total_page;
         this.loadItems(this.itemCnt,this.curr_page);
      }
      
      internal function changePage(param1:MouseEvent) : void
      {
         if(this.is_loading)
         {
            return;
         }
         if(param1.currentTarget.name == "nextPageBtn")
         {
            if(this.curr_page < this.total_page)
            {
               ++this.curr_page;
               this.itemCnt += 3;
               this.clearSlots();
               this.loadItems(this.itemCnt,this.curr_page);
            }
         }
         else if(param1.currentTarget.name == "prevPageBtn")
         {
            if(this.curr_page != 1)
            {
               --this.curr_page;
               this.itemCnt -= 3;
               this.clearSlots();
               this.loadItems(this.itemCnt,this.curr_page);
            }
         }
         this.pageTxt.text = this.curr_page + "/" + this.total_page;
      }
      
      internal function checkLoading(param1:Event) : *
      {
         ++this.lnr;
         if(this.lnr > 3)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkLoading);
            this.is_loading = false;
         }
      }
      
      internal function loadItems(param1:*, param2:*) : void
      {
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         this.lnr = 0;
         this.is_loading = true;
         addEventListener(Event.ENTER_FRAME,this.checkLoading);
         this.curr_page_items = [];
         var _loc11_:* = 0;
         _loc12_ = Math.ceil(this.itList.length / param2);
         if(_loc12_ >= 3)
         {
            _loc12_ = 3;
         }
         while(_loc11_ < _loc12_)
         {
            _loc3_ = this.itList[param1];
            if(_loc3_ == undefined)
            {
               _loc11_++;
            }
            else
            {
               this["item_" + _loc11_].visible = true;
               this.curr_page_items.push(_loc3_);
               _loc4_ = ForgeData.getForgeItems(_loc3_);
               _loc5_ = Character.isItemOwned(_loc3_);
               this["item_" + _loc11_].endTxt.text = _loc4_["item_mat_end"] == null ? "Unavailable" : _loc4_["item_mat_end"];
               this["item_" + _loc11_].ownedTxt.text = _loc5_ ? "Owned" : "";
               _loc6_ = _loc3_.split("_");
               _loc6_ = _loc6_[0];
               if(_loc6_ == "skill")
               {
                  _loc9_ = SkillLibrary.getSkillInfo(_loc3_);
                  this["item_" + _loc11_].lvlTxt.text = _loc9_["skill_level"];
                  this["item_" + _loc11_].skillIconMc.visible = true;
                  this["item_" + _loc11_].iconMc.visible = false;
                  GF.removeAllChild(this["item_" + _loc11_].skillIconMc.iconHolder);
                  NinjaSage.loadItemIcon(this["item_" + _loc11_].skillIconMc.iconHolder,_loc3_,"icon");
               }
               else if(_loc6_ == "wpn")
               {
                  _loc9_ = Library.getItemInfo(_loc3_);
                  this["item_" + _loc11_].lvlTxt.text = _loc9_["item_level"];
                  GF.removeAllChild(this["item_" + _loc11_].iconMc.iconHolder);
                  NinjaSage.loadItemIcon(this["item_" + _loc11_].iconMc.iconHolder,_loc3_,"icon");
                  this["item_" + _loc11_].skillIconMc.visible = false;
                  this["item_" + _loc11_].iconMc.visible = true;
               }
               else if(_loc6_ == "pet")
               {
                  _loc9_ = PetInfo.getPetStats(_loc3_);
                  this["item_" + _loc11_].lvlTxt.text = 20;
                  GF.removeAllChild(this["item_" + _loc11_].iconMc.iconHolder);
                  NinjaSage.loadItemIcon(this["item_" + _loc11_].iconMc.iconHolder,_loc3_,"icon");
                  this["item_" + _loc11_].skillIconMc.visible = false;
                  this["item_" + _loc11_].iconMc.visible = true;
               }
               else if(_loc6_ == "material")
               {
                  _loc9_ = Library.getItemInfo(_loc3_);
                  this["item_" + _loc11_].lvlTxt.text = 20;
                  GF.removeAllChild(this["item_" + _loc11_].iconMc.iconHolder);
                  NinjaSage.loadItemIcon(this["item_" + _loc11_].iconMc.iconHolder,_loc3_,"icon");
                  this["item_" + _loc11_].skillIconMc.visible = false;
                  this["item_" + _loc11_].iconMc.visible = true;
               }
               else
               {
                  _loc9_ = Library.getItemInfo(_loc3_);
                  this["item_" + _loc11_].lvlTxt.text = _loc9_["item_level"];
                  GF.removeAllChild(this["item_" + _loc11_].iconMc.iconHolder);
                  NinjaSage.loadItemIcon(this["item_" + _loc11_].iconMc.iconHolder,_loc3_,"icon");
                  this["item_" + _loc11_].skillIconMc.visible = false;
                  this["item_" + _loc11_].iconMc.visible = true;
               }
               this["item_" + _loc11_].forgeBtn.metaData = {"item_info":_loc9_};
               _loc7_ = 0;
               _loc8_ = 0;
               while(_loc7_ < _loc4_["item_materials"].length)
               {
                  this["item_" + _loc11_]["item_" + _loc7_].visible = true;
                  this["item_" + _loc11_]["item_" + _loc7_].iconMC.visible = true;
                  this["item_" + _loc11_]["item_" + _loc7_].skillIconMc.visible = false;
                  _loc13_ = _loc3_;
                  _loc3_ = _loc4_["item_materials"][_loc7_];
                  _loc3_ = _loc3_.split("_");
                  _loc10_ = 0;
                  if(_loc3_[0] == "material")
                  {
                     GF.removeAllChild(this["item_" + _loc11_]["item_" + _loc7_].iconMC.iconHolder);
                     NinjaSage.loadItemIcon(this["item_" + _loc11_]["item_" + _loc7_].iconMC.iconHolder,_loc4_["item_materials"][_loc7_],"icon");
                     _loc10_ = this.calculateMat(_loc4_["item_materials"][_loc7_]);
                     _loc9_ = Library.getItemInfo(_loc4_["item_materials"][_loc7_]);
                  }
                  else if(_loc3_[0] == "wpn")
                  {
                     GF.removeAllChild(this["item_" + _loc11_]["item_" + _loc7_].iconMC.iconHolder);
                     NinjaSage.loadItemIcon(this["item_" + _loc11_]["item_" + _loc7_].iconMC.iconHolder,_loc4_["item_materials"][_loc7_],"icon");
                     _loc10_ = this.calculateWeapon(_loc4_["item_materials"][_loc7_]);
                     _loc9_ = Library.getItemInfo(_loc4_["item_materials"][_loc7_]);
                  }
                  else if(_loc3_[0] == "back")
                  {
                     GF.removeAllChild(this["item_" + _loc11_]["item_" + _loc7_].iconMC.iconHolder);
                     NinjaSage.loadItemIcon(this["item_" + _loc11_]["item_" + _loc7_].iconMC.iconHolder,_loc4_["item_materials"][_loc7_],"icon");
                     _loc10_ = this.calculateBackItem(_loc4_["item_materials"][_loc7_]);
                     _loc9_ = Library.getItemInfo(_loc4_["item_materials"][_loc7_]);
                  }
                  else
                  {
                     GF.removeAllChild(this["item_" + _loc11_]["item_" + _loc7_].skillIconMc.iconHolder);
                     this["item_" + _loc11_]["item_" + _loc7_].iconMC.visible = false;
                     this["item_" + _loc11_]["item_" + _loc7_].skillIconMc.visible = true;
                     NinjaSage.loadItemIcon(this["item_" + _loc11_]["item_" + _loc7_].skillIconMc.iconHolder,_loc4_["item_materials"][_loc7_],"icon");
                     _loc10_ = Character.isItemOwned(_loc4_["item_materials"][_loc7_]) ? 1 : 0;
                     _loc9_ = SkillLibrary.getSkillInfo(_loc4_["item_materials"][_loc7_]);
                  }
                  this["item_" + _loc11_]["item_" + _loc7_].txt1.text = _loc10_;
                  this["item_" + _loc11_]["item_" + _loc7_].txt2.text = _loc4_["item_mat_price"][_loc7_];
                  if(int(_loc10_) >= int(_loc4_["item_mat_price"][_loc7_]))
                  {
                     _loc8_++;
                  }
                  _loc7_++;
               }
               if(_loc4_["item_materials"].length == 1)
               {
                  if(_loc8_ >= _loc4_["item_materials"].length)
                  {
                     this["item_" + _loc11_].statusMC.gotoAndStop(1);
                     this["item_" + _loc11_].forgeBtn.visible = true;
                     this.eventHandler.addListener(this["item_" + _loc11_].forgeBtn,MouseEvent.CLICK,this.onForgeItemConfirmation);
                  }
                  else
                  {
                     this["item_" + _loc11_].statusMC.gotoAndStop(2);
                     this["item_" + _loc11_].forgeBtn.visible = false;
                  }
               }
               else if(_loc8_ >= _loc4_["item_materials"].length)
               {
                  this["item_" + _loc11_].statusMC.gotoAndStop(1);
                  this["item_" + _loc11_].forgeBtn.visible = true;
                  this.eventHandler.addListener(this["item_" + _loc11_].forgeBtn,MouseEvent.CLICK,this.onForgeItemConfirmation);
               }
               else
               {
                  this["item_" + _loc11_].statusMC.gotoAndStop(2);
                  this["item_" + _loc11_].forgeBtn.visible = false;
               }
               if(Boolean(_loc5_) && this.orig_indicator == "Skill")
               {
                  this["item_" + _loc11_].statusMC.gotoAndStop(2);
                  this["item_" + _loc11_].forgeBtn.visible = false;
               }
               param1++;
               _loc11_++;
            }
         }
         _loc11_ = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc10_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc9_ = null;
      }
      
      public function onForgeItemConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         var slotIndex:* = int(e.currentTarget.parent.name.replace("item_",""));
         var itemInfo:* = e.currentTarget.metaData.item_info;
         var itemName:* = "";
         if("item_name" in itemInfo)
         {
            itemName = itemInfo["item_name"];
         }
         else if("skill_name" in itemInfo)
         {
            itemName = itemInfo["skill_name"];
         }
         else if("pet_name" in itemInfo)
         {
            itemName = itemInfo["pet_name"];
         }
         this.selectedItem = this.curr_page_items[slotIndex];
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to forge " + itemName + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():void
         {
            removeChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onForgeItemRequest);
         addChild(this.confirmation);
      }
      
      public function onForgeItemRequest(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("gyb2ZyH5v4Isex6h.G62CaCDtR89f",[Character.char_id,Character.sessionkey,this.selectedItem],this.onForgeItemResponse);
      }
      
      public function onForgeItemResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status == 1)
            {
               _loc2_ = param1.item;
               if(_loc2_.indexOf("material_") >= 0)
               {
                  Character.addMaterials(_loc2_);
               }
               else if(_loc2_.indexOf("wpn_") >= 0)
               {
                  Character.addWeapon(_loc2_);
               }
               else if(_loc2_.indexOf("back_") >= 0)
               {
                  Character.addBack(_loc2_);
               }
               else if(_loc2_.indexOf("set_") >= 0)
               {
                  Character.addSet(_loc2_);
               }
               else if(_loc2_.indexOf("accessory_") >= 0)
               {
                  Character.addAccessory(_loc2_);
               }
               else if(_loc2_.indexOf("skill_") >= 0)
               {
                  Character.updateSkills(_loc2_);
               }
               else if(_loc2_.indexOf("hair_") >= 0)
               {
                  Character.addHair(_loc2_);
               }
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
                  if(_loc3_[0][_loc4_].indexOf("back_") >= 0)
                  {
                     Character.removeBackItem(_loc3_[0][_loc4_],_loc3_[1][_loc4_]);
                  }
                  if(_loc3_[0][_loc4_] == Character.character_weapon)
                  {
                     Character.character_weapon = "wpn_01";
                  }
                  if(_loc3_[0][_loc4_] == Character.character_back_item)
                  {
                     Character.character_back_item = "back_01";
                  }
                  if(_loc3_[0][_loc4_] == Character.character_accessory)
                  {
                     Character.character_accessory = "accessory_01";
                  }
                  _loc4_++;
               }
            }
            else
            {
               this.main.getNotice(param1.result);
            }
            this.loadCategory(this.orig_indicator,this.curr_page,this.itemCnt);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      internal function calculateWeapon(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = Character.character_weapons.split(",");
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_].split(":");
            if(_loc2_[0] == param1)
            {
               _loc5_ = _loc2_[1];
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      internal function calculateBackItem(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = Character.character_back_items.split(",");
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc4_].split(":");
            if(_loc2_[0] == param1)
            {
               _loc5_ = _loc2_[1];
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      internal function calculateMat(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = Character.character_materials.split(",");
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
      
      internal function killEverything() : void
      {
         this.main.handleVillageHUDVisibility(true);
         this.clearSlots();
         this.eventHandler.removeAllEventListeners();
         this.eventHandler.removeListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.removeListener(this.mcWeapon,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.removeListener(this.mcWeapon,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.removeListener(this.mcWeapon,MouseEvent.CLICK,this.click);
         this.eventHandler.removeListener(this.mcSet,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.removeListener(this.mcSet,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.removeListener(this.mcSet,MouseEvent.CLICK,this.click);
         this.eventHandler.removeListener(this.mcBackItem,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.removeListener(this.mcBackItem,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.removeListener(this.mcBackItem,MouseEvent.CLICK,this.click);
         this.eventHandler.removeListener(this.mcAccessory,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.removeListener(this.mcAccessory,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.removeListener(this.mcAccessory,MouseEvent.CLICK,this.click);
         this.eventHandler.removeListener(this.mcHairstyle,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.removeListener(this.mcHairstyle,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.removeListener(this.mcHairstyle,MouseEvent.CLICK,this.click);
         this.eventHandler.removeListener(this.mcSkill,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.removeListener(this.mcSkill,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.removeListener(this.mcSkill,MouseEvent.CLICK,this.click);
         this.eventHandler.removeListener(this.mcPet,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.removeListener(this.mcPet,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.removeListener(this.mcPet,MouseEvent.CLICK,this.click);
         this.eventHandler.removeListener(this.nextPageBtn,MouseEvent.CLICK,this.changePage);
         this.eventHandler.removeListener(this.prevPageBtn,MouseEvent.CLICK,this.changePage);
         var _loc1_:* = 0;
         GF.removeAllChild(this.item_0.iconMc.iconHolder);
         GF.removeAllChild(this.item_1.iconMc.iconHolder);
         GF.removeAllChild(this.item_2.iconMc.iconHolder);
         this.item_0.forgeBtn.metaData = {};
         this.item_1.forgeBtn.metaData = {};
         this.item_2.forgeBtn.metaData = {};
         while(_loc1_ < 10)
         {
            GF.removeAllChild(this.item_0["item_" + _loc1_].iconMC.iconHolder);
            GF.removeAllChild(this.item_1["item_" + _loc1_].iconMC.iconHolder);
            GF.removeAllChild(this.item_2["item_" + _loc1_].iconMC.iconHolder);
            _loc1_++;
         }
         NinjaSage.clearEventListener();
         this.mcWeapon.buttonMode = false;
         this.mcSet.buttonMode = false;
         this.mcBackItem.buttonMode = false;
         this.mcAccessory.buttonMode = false;
         this.mcHairstyle.buttonMode = false;
         this.mcSkill.buttonMode = false;
         this.eventHandler = null;
         this.main = null;
         System.gc();
      }
      
      internal function closePanel(param1:MouseEvent) : void
      {
         this.killEverything();
         GF.removeAllChild(this);
      }
   }
}

