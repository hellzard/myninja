package Panels
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Popups.Confirmation;
   import Popups.ItemBuyConfirmation;
   import Storage.Character;
   import Storage.ItemDropSourceMapping;
   import Storage.Library;
   import Storage.SetBuffs;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import fl.events.ColorPickerEvent;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4513")]
   public dynamic class UI_Gear extends MovieClip
   {
      
      public var btn_filter:MovieClip;
      
      public var btn_clear:SimpleButton;
      
      public var btn_clearSearch:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_preset:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_search:SimpleButton;
      
      public var btn_sell_mode:MovieClip;
      
      public var btn_to_page:SimpleButton;
      
      public var btn_unequip:SimpleButton;
      
      public var char_mc:MovieClip;
      
      public var colorMC0:MovieClip;
      
      public var colorMC1:MovieClip;
      
      public var item_0:MovieClip;
      
      public var item_1:MovieClip;
      
      public var item_2:MovieClip;
      
      public var item_3:MovieClip;
      
      public var item_4:MovieClip;
      
      public var item_5:MovieClip;
      
      public var item_6:MovieClip;
      
      public var item_7:MovieClip;
      
      public var item_8:MovieClip;
      
      public var item_9:MovieClip;
      
      public var mcAccessory:MovieClip;
      
      public var mcBackItem:MovieClip;
      
      public var mcColor:MovieClip;
      
      public var mcEssentials:MovieClip;
      
      public var mcHairstyle:MovieClip;
      
      public var mcFavorite:MovieClip;
      
      public var mcItems:MovieClip;
      
      public var mcMaterials:MovieClip;
      
      public var mcSet:MovieClip;
      
      public var mcWeapon:MovieClip;
      
      public var presetMC:MovieClip;
      
      public var sortMC:MovieClip;
      
      public var sellTxt:TextField;
      
      public var txt_goToPage:TextField;
      
      public var txt_page:TextField;
      
      public var txt_search:TextField;
      
      public var weaponArray:Array = this.sortItems(Character.character_weapons.split(","));
      
      public var backArray:Array = this.sortItems(Character.character_back_items.split(","));
      
      public var accArray:Array = this.sortItems(Character.character_accessories.split(","));
      
      public var setArray:Array = this.sortItems(Character.character_sets.split(","));
      
      public var hairArray:Array = this.sortItems(Character.character_hairs.split(","));
      
      public var materialArray:Array = this.sortItems(Character.character_materials.split(","));
      
      public var essentialArray:Array = this.sortItems(Character.character_essentials.split(","));
      
      public var consumableArray:Array = this.sortItems(Character.character_consumables.split(","));
      
      public var favoriteArray:Array = this.sortItems(Character.character_item_favorites.split(","));
      
      public var selectedCategory:Array;
      
      public var presets:Array;
      
      public var outfits:Array = [];
      
      public var iconMCArray:Array = [];
      
      public var itemEquipMC:Array = [];
      
      public var backHairMC:Array = [];
      
      public var skirtMC:Array = [];
      
      public var currentPage:int = 1;
      
      public var totalPage:int = 1;
      
      public var itemIndex:int = 0;
      
      public var itemLoading:int = 0;
      
      public var itemCount:int = 0;
      
      public var sellQuantity:int = 1;
      
      public var sellMaxQuantity:int = 1;
      
      public var presetTarget:int;
      
      public var preset_total_page:int = 0;
      
      public var preset_curr_page:int = 1;
      
      public var tabIndicator:String = "weapon";
      
      public var equippedItem:String;
      
      public var usableItem:String;
      
      public var selectedHairColor:String;
      
      public var selectedSkinColor:String;
      
      public var tempItemId:String;
      
      public var selectedSellItem:Object;
      
      public var selectedHairMC:MovieClip;
      
      public var selectedBackHairMC:MovieClip;
      
      public var selectedSkirtMC:MovieClip;
      
      public var selectedSetMC:Array = [];
      
      public var color:Color;
      
      public var isLoading:Boolean;
      
      public var firstLoad:Boolean = true;
      
      public var sellMode:Boolean = false;
      
      public var tempWeaponMC:MovieClip;
      
      public var tempBackItemMC:MovieClip;
      
      public var tempHairMC:MovieClip;
      
      public var tempBackHairMC:MovieClip;
      
      public var tempSetMC:MovieClip;
      
      public var tempSetArray:Array = [];
      
      public var tempSkirtMC:MovieClip;
      
      public var eventHandler:*;
      
      public var escapeKey:EscapeKeyManager;
      
      public var tooltip:*;
      
      public var main:*;
      
      public var loaderSwf:* = BulkLoader.createUniqueNamedLoader(10);
      
      public var sellPanel:*;
      
      public var useItemPanel:ItemBuyConfirmation;
      
      public var useItemQuantity:int = 1;
      
      public var useItemMaxQuantity:int = 1;
      
      public var confirmation:*;
      
      public var tabButton:Array = ["mcWeapon","mcSet","mcBackItem","mcAccessory","mcEssentials","mcMaterials","mcItems","mcHairstyle","mcColor","mcFavorite"];
      
      public var bodyArray:Array = ["upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe"];
      
      public var sortListArray:Array = ["Default","Clan","Shadow War","Crew","Package","Spending","Leaderboard"];
      
      public var selectedSort:int = 0;
      
      public var isDescription:Boolean = false;
      
      public var originalItemAnimation:Boolean;
      
      public function UI_Gear(param1:*)
      {
         super();
         this.main = param1;
         this.tooltip = ToolTip.getInstance();
         this.eventHandler = new EventHandler();
         this.escapeKey = new EscapeKeyManager(this);
         this.color = new Color();
         this.initButton();
         this.initUI();
      }
      
      public function initButton() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.tabButton.length)
         {
            this[this.tabButton[_loc1_]].gotoAndStop(1);
            this[this.tabButton[_loc1_]].buttonMode = true;
            this.eventHandler.addListener(this[this.tabButton[_loc1_]],MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(this[this.tabButton[_loc1_]],MouseEvent.MOUSE_OVER,this.hoverOver);
            this.eventHandler.addListener(this[this.tabButton[_loc1_]],MouseEvent.MOUSE_OUT,this.hoverOut);
            _loc1_++;
         }
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_unequip,MouseEvent.CLICK,this.unEquipItem);
         this.eventHandler.addListener(this.btn_sell_mode,MouseEvent.CLICK,this.toggleSellMode);
         this.eventHandler.addListener(this.btn_clear,MouseEvent.CLICK,this.clearPreview);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_preset,MouseEvent.CLICK,this.getPresetData);
         this.eventHandler.addListener(this.btn_to_page,MouseEvent.CLICK,this.goToPage);
         this.eventHandler.addListener(this.btn_search,MouseEvent.CLICK,this.searchItem);
         this.eventHandler.addListener(this.btn_clearSearch,MouseEvent.CLICK,this.clearSearch);
         this.escapeKey.addListener(this.btn_close,this.closePanel);
         this.escapeKey.addListener(this.presetMC,this.closePreset);
         this.main.initButton(this.sortMC.btn_sort,this.openSortList,this.selectedSort);
         NinjaSage.showDynamicTooltip(this.sortMC.btn_sort,"Showing all items");
         this.eventHandler.addListener(this.btn_filter,MouseEvent.CLICK,this.handleSearchFilter);
         NinjaSage.showDynamicTooltip(this.btn_filter.filter_on,"Search by description");
         NinjaSage.showDynamicTooltip(this.btn_filter.filter_off,"Search by name");
      }
      
      public function addItemFavorite(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.metaData.id;
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.qmuUkGOUH6mu",[Character.char_id,Character.sessionkey,_loc2_],this.addFavoriteResponse);
      }
      
      public function removeItemFavorite(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.metaData.id;
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.mj6LuFKeWbTn",[Character.char_id,Character.sessionkey,_loc2_],this.removeFavoriteResponse);
      }
      
      public function addFavoriteResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.setFavoriteData(param1.data);
            this.main.showMessage("Item added to favorites");
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function removeFavoriteResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.setFavoriteData(param1.data);
            this.main.showMessage("Item removed from favorites");
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function setFavoriteData(param1:*) : void
      {
         var _loc2_:Array = param1 is Array ? param1 : [];
         Character.character_item_favorites = _loc2_.join(",");
         this.favoriteArray = this.sortItems(_loc2_);
         if(this.tabIndicator == "favorite")
         {
            this.selectedCategory = this.favoriteArray;
         }
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function refreshOriginalArray(param1:String) : void
      {
         switch(param1)
         {
            case "weapon":
               this.weaponArray = this.sortItems(Character.character_weapons.split(","));
               break;
            case "set":
               this.setArray = this.sortItems(Character.character_sets.split(","));
               break;
            case "back":
               this.backArray = this.sortItems(Character.character_back_items.split(","));
               break;
            case "accessory":
               this.accArray = this.sortItems(Character.character_accessories.split(","));
               break;
            case "hair":
               this.hairArray = this.sortItems(Character.character_hairs.split(","));
         }
      }
      
      public function getItemTypeFromId(param1:String) : String
      {
         var _loc2_:String = param1.split("_")[0];
         switch(_loc2_)
         {
            case "wpn":
               return "weapon";
            case "set":
               return "set";
            case "back":
               return "back";
            case "accessory":
               return "accessory";
            case "hair":
               return "hair";
            case "material":
               return "material";
            case "essential":
               return "essential";
            case "item":
               return "consumable";
            default:
               return _loc2_;
         }
      }
      
      public function initUI() : *
      {
         var _loc1_:* = undefined;
         if(!Character.is_stickman)
         {
            _loc1_ = new OutfitManager();
            _loc1_.fillOutfit(this.char_mc,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
            this.outfits.push(_loc1_);
         }
         this.presetMC.visible = false;
         this.btn_sell_mode.tick.visible = false;
         this.colorMC0.visible = false;
         this.colorMC1.visible = false;
         this.btn_unequip.visible = false;
         this.sortMC.sort_list.visible = false;
         this.btn_filter.filter_on.visible = false;
         this.txt_goToPage.restrict = "0-9";
         this.selectedHairColor = Character.character_color_hair;
         this.selectedSkinColor = Character.character_color_skin;
         this.mcWeapon.gotoAndStop(3);
         this.tabIndicator = "weapon";
         this.selectedCategory = this.weaponArray;
         this.equippedItem = Character.character_weapon;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
      }
      
      public function loadSwf() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.isLoading = true;
         if(this.itemIndex < this.itemLoading)
         {
            _loc1_ = this.selectedCategory[this.itemIndex].split(":")[0];
            _loc2_ = this.getAssetPath(_loc1_) + "/" + _loc1_ + ".swf";
            _loc3_ = this.loaderSwf.add(_loc2_);
            _loc3_.addEventListener(BulkLoader.COMPLETE,this.completeIcon);
            _loc3_.addEventListener(BulkLoader.ERROR,this.onItemLoadError);
            this.loaderSwf.start();
            return;
         }
         this.isLoading = false;
      }
      
      public function onItemLoadError(param1:ErrorEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.completeIcon);
         this.itemEquipMC[this.itemCount] = null;
         this.backHairMC[this.itemCount] = null;
         this.skirtMC[this.itemCount] = null;
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      public function completeIcon(param1:Event) : *
      {
         var iconClass:Class;
         var itemMC:MovieClip;
         var effectiveType:String;
         var itemId:*;
         var itemQty:*;
         var getItemInfo:*;
         var isMaterial:Boolean;
         var isConsumable:Boolean;
         var isEssential:Boolean;
         var isEquipped:Boolean;
         var currentItemId:String = null;
         var backHairIcon:MovieClip = null;
         var loadedSet:Array = null;
         var i:* = undefined;
         var skirtIcon:MovieClip = null;
         var favType:String = null;
         var e:Event = param1;
         e.currentTarget.removeEventListener(e.type,arguments.callee);
         e.currentTarget.removeEventListener(BulkLoader.ERROR,this.onItemLoadError);
         iconClass = null;
         itemMC = null;
         itemMC = e.target.content.icon;
         if(!Character.play_items_animation)
         {
            itemMC.stopAllMovieClips();
         }
         this.iconMCArray.push(itemMC);
         this["item_" + this.itemCount].iconMc.iconHolder.addChild(itemMC);
         this["item_" + this.itemCount].gotoAndStop(1);
         this["item_" + this.itemCount].visible = true;
         effectiveType = this.tabIndicator;
         if(this.tabIndicator == "favorite")
         {
            currentItemId = this.selectedCategory[this.itemIndex].split(":")[0];
            effectiveType = this.getItemTypeFromId(currentItemId);
         }
         if(effectiveType == "weapon")
         {
            itemMC = e.target.content.weapon;
            if(!Character.play_items_animation)
            {
               itemMC.stopAllMovieClips();
            }
            this.itemEquipMC.push(itemMC);
         }
         else if(effectiveType == "back")
         {
            itemMC = e.target.content.back_item;
            if(!Character.play_items_animation)
            {
               itemMC.stopAllMovieClips();
            }
            this.itemEquipMC.push(itemMC);
         }
         else if(effectiveType == "hair")
         {
            itemMC = e.target.content.hair;
            if(!Character.play_items_animation)
            {
               itemMC.stopAllMovieClips();
            }
            this.itemEquipMC.push(itemMC);
            try
            {
               backHairIcon = e.target.content.back_hair;
               if(!Character.play_items_animation)
               {
                  backHairIcon.stopAllMovieClips();
               }
               this.backHairMC.push(backHairIcon);
            }
            catch(error:*)
            {
               this.backHairMC.push(null);
            }
         }
         else if(effectiveType == "set")
         {
            loadedSet = [];
            i = 0;
            while(i < this.bodyArray.length)
            {
               itemMC = e.target.content[this.bodyArray[i]];
               if(!Character.play_items_animation)
               {
                  itemMC.stopAllMovieClips();
               }
               loadedSet.push(itemMC);
               i++;
            }
            try
            {
               skirtIcon = e.target.content.skirt;
               if(!Character.play_items_animation)
               {
                  skirtIcon.stopAllMovieClips();
               }
               this.skirtMC.push(skirtIcon);
            }
            catch(error:*)
            {
               this.skirtMC.push(null);
            }
            this.itemEquipMC.push(loadedSet);
         }
         itemId = this.selectedCategory[this.itemIndex].split(":")[0];
         itemQty = this.selectedCategory[this.itemIndex].split(":")[1];
         getItemInfo = Library.getItemInfo(itemId);
         this["item_" + this.itemCount].lvlTxt.text = getItemInfo.item_level;
         if(itemQty != undefined)
         {
            this["item_" + this.itemCount].amtTxt.visible = true;
            this["item_" + this.itemCount].amtTxt.text = "x" + itemQty;
         }
         else
         {
            this["item_" + this.itemCount].amtTxt.visible = false;
            itemQty = 1;
         }
         if(getItemInfo.item_premium)
         {
            this["item_" + this.itemCount].emblemMC.visible = true;
         }
         if(getItemInfo.item_level <= int(Character.character_lvl))
         {
            this.color.brightness = 0;
            this["item_" + this.itemCount].transform.colorTransform = this.color;
            this["item_" + this.itemCount].btn_equip.visible = true;
            this["item_" + this.itemCount].lockMc.visible = false;
         }
         if(getItemInfo.item_id.indexOf("material") >= 0 || getItemInfo.item_id.indexOf("essential") >= 0 || getItemInfo.item_id.indexOf("item") >= 0)
         {
            this["item_" + this.itemCount].btn_equip.visible = false;
            this["item_" + this.itemCount].btn_use.visible = false;
         }
         if(Boolean(getItemInfo.hasOwnProperty("item_usable")) && Boolean(getItemInfo.item_usable))
         {
            this["item_" + this.itemCount].btn_use.visible = true;
            this["item_" + this.itemCount].btn_use.metaData = {
               "usable_item":getItemInfo,
               "owned_qty":itemQty
            };
            this.eventHandler.addListener(this["item_" + this.itemCount].btn_use,MouseEvent.CLICK,this.useItem);
         }
         isMaterial = getItemInfo.item_id.indexOf("material") >= 0;
         isConsumable = getItemInfo.item_id.indexOf("item") >= 0;
         isEssential = getItemInfo.item_id.indexOf("essential") >= 0;
         if(isMaterial || isConsumable || isEssential)
         {
            this["item_" + this.itemCount].btn_addFavorite.visible = false;
            this["item_" + this.itemCount].btn_removeFavorite.visible = false;
         }
         else
         {
            this["item_" + this.itemCount].btn_addFavorite.metaData = {"id":getItemInfo["item_id"]};
            this["item_" + this.itemCount].btn_removeFavorite.metaData = {"id":getItemInfo["item_id"]};
            if(this.tabIndicator == "favorite")
            {
               this["item_" + this.itemCount].btn_addFavorite.visible = false;
               this["item_" + this.itemCount].btn_removeFavorite.visible = true;
               this.eventHandler.addListener(this["item_" + this.itemCount].btn_removeFavorite,MouseEvent.CLICK,this.removeItemFavorite);
            }
            else if(this.favoriteArray.indexOf(getItemInfo["item_id"]) >= 0)
            {
               this["item_" + this.itemCount].btn_addFavorite.visible = false;
               this["item_" + this.itemCount].btn_removeFavorite.visible = true;
            }
            else
            {
               this["item_" + this.itemCount].btn_addFavorite.visible = true;
               this["item_" + this.itemCount].btn_removeFavorite.visible = false;
               this.eventHandler.addListener(this["item_" + this.itemCount].btn_addFavorite,MouseEvent.CLICK,this.addItemFavorite);
            }
         }
         if(this.sellMode)
         {
            this["item_" + this.itemCount].btn_equip.visible = false;
            this["item_" + this.itemCount].btn_use.visible = false;
            this["item_" + this.itemCount].btn_addFavorite.visible = false;
            this["item_" + this.itemCount].btn_removeFavorite.visible = false;
            this["item_" + this.itemCount].btn_sell.gotoAndStop(1);
            this["item_" + this.itemCount].btn_sell.visible = true;
            this["item_" + this.itemCount].btn_sell.txt_price.text = getItemInfo.item_sell_price;
            this["item_" + this.itemCount].btn_sell.metaData = {
               "item_info":getItemInfo,
               "owned_qty":itemQty
            };
            this.eventHandler.addListener(this["item_" + this.itemCount].btn_sell,MouseEvent.CLICK,this.openSellConfirmation);
            this.eventHandler.addListener(this["item_" + this.itemCount].btn_sell,MouseEvent.MOUSE_OVER,this.hoverOver);
            this.eventHandler.addListener(this["item_" + this.itemCount].btn_sell,MouseEvent.MOUSE_OUT,this.hoverOut);
         }
         isEquipped = false;
         if(this.tabIndicator == "favorite")
         {
            favType = this.getItemTypeFromId(itemId);
            if(favType == "weapon" && itemId == Character.character_weapon)
            {
               isEquipped = true;
            }
            else if(favType == "set" && itemId == Character.character_set)
            {
               isEquipped = true;
            }
            else if(favType == "back" && itemId == Character.character_back_item)
            {
               isEquipped = true;
            }
            else if(favType == "accessory" && itemId == Character.character_accessory)
            {
               isEquipped = true;
            }
            else if(favType == "hair" && itemId == Character.character_hair)
            {
               isEquipped = true;
            }
         }
         else
         {
            isEquipped = itemId == this.equippedItem;
         }
         if(isEquipped)
         {
            this["item_" + this.itemCount]["txt_equipped"].visible = true;
            this["item_" + this.itemCount]["btn_equip"].visible = false;
         }
         this["item_" + this.itemCount].clickmask.tooltip = getItemInfo;
         this["item_" + this.itemCount].clickmask.item_type = itemId.split("_")[0];
         this["item_" + this.itemCount].btn_equip.metaData = {"id":getItemInfo["item_id"]};
         this["item_" + this.itemCount].clickmask.metaData = {"id":getItemInfo["item_id"]};
         this.eventHandler.addListener(this["item_" + this.itemCount].clickmask,MouseEvent.MOUSE_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this["item_" + this.itemCount].clickmask,MouseEvent.MOUSE_OUT,this.toolTiponOut);
         this.eventHandler.addListener(this["item_" + this.itemCount].clickmask,MouseEvent.CLICK,this.loadItem);
         this.eventHandler.addListener(this["item_" + this.itemCount].btn_equip,MouseEvent.CLICK,this.loadItem);
         if(getItemInfo.item_id.indexOf("material") >= 0 || getItemInfo.item_id.indexOf("essential") >= 0 || getItemInfo.item_id.indexOf("item") >= 0)
         {
            this.eventHandler.removeListener(this["item_" + this.itemCount].clickmask,MouseEvent.CLICK,this.loadItem);
            this.eventHandler.removeListener(this["item_" + this.itemCount].btn_equip,MouseEvent.CLICK,this.loadItem);
         }
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      public function loadItem(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         this.tempItemId = param1.currentTarget.metaData.id;
         var _loc3_:String = "items/" + this.tempItemId + ".swf";
         var _loc4_:* = this.loaderSwf.add(_loc3_);
         _loc4_.addEventListener(BulkLoader.COMPLETE,_loc2_ == "btn_equip" ? this.equipItem : this.onItemPreviewed);
         this.loaderSwf.start();
      }
      
      public function onItemPreviewed(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:String = this.tabIndicator;
         if(this.tabIndicator == "favorite")
         {
            _loc2_ = this.getItemTypeFromId(this.tempItemId);
         }
         if(_loc2_ == "weapon")
         {
            this.removeChildsFromMovieClip(this.char_mc["weapon"]);
            if(this.tempWeaponMC != null)
            {
               this.tempWeaponMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempWeaponMC);
            this.tempWeaponMC = null;
            this.tempWeaponMC = param1.target.content.weapon;
            this.char_mc["weapon"].addChild(this.tempWeaponMC);
         }
         else if(_loc2_ == "back")
         {
            this.removeChildsFromMovieClip(this.char_mc["back"]);
            if(this.tempBackItemMC != null)
            {
               this.tempBackItemMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempBackItemMC);
            this.tempBackItemMC = null;
            this.tempBackItemMC = param1.target.content.back_item;
            this.char_mc["back"].addChild(this.tempBackItemMC);
         }
         else if(_loc2_ == "hair")
         {
            this.removeChildsFromMovieClip(this.char_mc.head["hair"]);
            if(this.tempHairMC != null)
            {
               this.tempHairMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempHairMC);
            this.tempHairMC = null;
            this.tempHairMC = param1.target.content.hair;
            this.selectedHairMC = this.tempHairMC;
            this.addHairColor(this.tempHairMC);
            this.char_mc.head["hair"].addChild(this.tempHairMC);
            try
            {
               this.removeChildsFromMovieClip(this.char_mc["back_hair"]);
               if(this.tempBackHairMC != null)
               {
                  this.tempBackHairMC.stopAllMovieClips();
               }
               GF.removeAllChild(this.tempBackHairMC);
               this.tempBackHairMC = null;
               this.tempBackHairMC = param1.target.content.back_hair;
               this.selectedBackHairMC = this.tempBackHairMC;
               this.addHairColor(this.tempBackHairMC);
               this.char_mc["back_hair"].addChild(this.tempBackHairMC);
            }
            catch(error:Error)
            {
            }
         }
         else if(_loc2_ == "set")
         {
            _loc3_ = 0;
            while(_loc3_ < this.selectedSetMC.length)
            {
               if(this.selectedSetMC[_loc3_] != null)
               {
                  this.selectedSetMC[_loc3_].stopAllMovieClips();
               }
               GF.removeAllChild(this.selectedSetMC[_loc3_]);
               _loc3_++;
            }
            this.selectedSetMC = [];
            _loc3_ = 0;
            while(_loc3_ < this.tempSetArray.length)
            {
               if(this.tempSetArray[_loc3_] != null)
               {
                  this.tempSetArray[_loc3_].stopAllMovieClips();
               }
               GF.removeAllChild(this.tempSetArray[_loc3_]);
               _loc3_++;
            }
            this.tempSetArray = [];
            _loc3_ = 0;
            while(_loc3_ < this.bodyArray.length)
            {
               this.tempSetMC = param1.target.content[this.bodyArray[_loc3_]];
               this.tempSetArray.push(this.tempSetMC);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.bodyArray.length)
            {
               this.removeChildsFromMovieClip(this.char_mc[this.bodyArray[_loc3_]]);
               this.selectedSetMC.push(this.tempSetArray[_loc3_]);
               this.addSkinColor(this.tempSetArray[_loc3_]);
               this.char_mc[this.bodyArray[_loc3_]].addChild(this.tempSetArray[_loc3_]);
               _loc3_++;
            }
            try
            {
               this.removeChildsFromMovieClip(this.char_mc["skirt"]);
               if(this.tempSkirtMC != null)
               {
                  this.tempSkirtMC.stopAllMovieClips();
               }
               GF.removeAllChild(this.tempSkirtMC);
               this.tempSkirtMC = null;
               this.tempSkirtMC = param1.target.content.skirt;
               this.selectedSkirtMC = this.tempSkirtMC;
               this.char_mc["skirt"].addChild(this.tempSkirtMC);
            }
            catch(error:Error)
            {
            }
         }
      }
      
      public function equipItem(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:String = this.tabIndicator;
         if(this.tabIndicator == "favorite")
         {
            _loc2_ = this.getItemTypeFromId(this.tempItemId);
         }
         if(_loc2_ == "weapon")
         {
            this.removeChildsFromMovieClip(this.char_mc["weapon"]);
            if(this.tempWeaponMC != null)
            {
               this.tempWeaponMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempWeaponMC);
            this.tempWeaponMC = null;
            this.tempWeaponMC = param1.target.content.weapon;
            Character.character_weapon = this.tempItemId;
            this.equippedItem = this.tempItemId;
            this.char_mc["weapon"].addChild(this.tempWeaponMC);
            GF.removeAllChild(OutfitManager.weapon_mc[0]);
            OutfitManager.weapon_mc[0] = this.tempWeaponMC;
            this.setDefaultArray();
         }
         else if(_loc2_ == "back")
         {
            this.removeChildsFromMovieClip(this.char_mc["back"]);
            if(this.tempBackItemMC != null)
            {
               this.tempBackItemMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempBackItemMC);
            this.tempBackItemMC = null;
            this.tempBackItemMC = param1.target.content.back_item;
            Character.character_back_item = this.tempItemId;
            this.equippedItem = this.tempItemId;
            this.char_mc["back"].addChild(this.tempBackItemMC);
            GF.removeAllChild(OutfitManager.back_mc[0]);
            OutfitManager.back_mc[0] = this.tempBackItemMC;
            this.setDefaultArray();
         }
         else if(_loc2_ == "hair")
         {
            this.removeChildsFromMovieClip(this.char_mc.head["hair"]);
            if(this.tempHairMC != null)
            {
               this.tempHairMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempHairMC);
            this.tempHairMC = null;
            this.tempHairMC = param1.target.content.hair;
            this.selectedHairMC = this.tempHairMC;
            this.addHairColor(this.tempHairMC);
            Character.character_hair = this.tempItemId;
            this.equippedItem = this.tempItemId;
            this.char_mc.head["hair"].addChild(this.tempHairMC);
            GF.removeAllChild(OutfitManager.hair_mc[0]);
            OutfitManager.hair_mc[0] = this.tempHairMC;
            try
            {
               this.removeChildsFromMovieClip(this.char_mc["back_hair"]);
               if(this.tempBackHairMC != null)
               {
                  this.tempBackHairMC.stopAllMovieClips();
               }
               GF.removeAllChild(this.tempBackHairMC);
               this.tempBackHairMC = null;
               this.tempBackHairMC = param1.target.content.back_hair;
               this.selectedBackHairMC = this.tempBackHairMC;
               this.addHairColor(this.tempBackHairMC);
               this.char_mc["back_hair"].addChild(this.tempBackHairMC);
               GF.removeAllChild(OutfitManager.hair_mc[1]);
               OutfitManager.hair_mc[1] = this.tempBackHairMC;
            }
            catch(error:Error)
            {
            }
            this.setDefaultArray();
         }
         else if(_loc2_ == "accessory")
         {
            Character.character_accessory = this.tempItemId;
            this.equippedItem = this.tempItemId;
            this.setDefaultArray();
         }
         else if(_loc2_ == "set")
         {
            _loc3_ = 0;
            while(_loc3_ < this.selectedSetMC.length)
            {
               if(this.selectedSetMC[_loc3_] != null)
               {
                  this.selectedSetMC[_loc3_].stopAllMovieClips();
               }
               GF.removeAllChild(this.selectedSetMC[_loc3_]);
               _loc3_++;
            }
            this.selectedSetMC = [];
            _loc3_ = 0;
            while(_loc3_ < this.tempSetArray.length)
            {
               if(this.tempSetArray[_loc3_] != null)
               {
                  this.tempSetArray[_loc3_].stopAllMovieClips();
               }
               GF.removeAllChild(this.tempSetArray[_loc3_]);
               _loc3_++;
            }
            this.tempSetArray = [];
            _loc3_ = 0;
            while(_loc3_ < this.bodyArray.length)
            {
               this.tempSetMC = param1.target.content[this.bodyArray[_loc3_]];
               this.tempSetArray.push(this.tempSetMC);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.bodyArray.length)
            {
               this.removeChildsFromMovieClip(this.char_mc[this.bodyArray[_loc3_]]);
               this.selectedSetMC.push(this.tempSetArray[_loc3_]);
               this.addSkinColor(this.tempSetArray[_loc3_]);
               this.char_mc[this.bodyArray[_loc3_]].addChild(this.tempSetArray[_loc3_]);
               GF.removeAllChild(OutfitManager.set_mc[_loc3_]);
               OutfitManager.set_mc[_loc3_] = this.tempSetArray[_loc3_];
               _loc3_++;
            }
            try
            {
               this.removeChildsFromMovieClip(this.char_mc["skirt"]);
               if(this.tempSkirtMC != null)
               {
                  this.tempSkirtMC.stopAllMovieClips();
               }
               GF.removeAllChild(this.tempSkirtMC);
               this.tempSkirtMC = null;
               this.tempSkirtMC = param1.target.content.skirt;
               this.char_mc["skirt"].addChild(this.tempSkirtMC);
               GF.removeAllChild(OutfitManager.set_mc[14]);
               OutfitManager.set_mc[14] = this.tempSkirtMC;
            }
            catch(error:Error)
            {
            }
            Character.character_set = this.tempItemId;
            this.equippedItem = this.tempItemId;
            this.setDefaultArray();
         }
         if(this.tabIndicator == "favorite")
         {
            this.refreshOriginalArray(_loc2_);
         }
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
         this.main.HUD.loadFrame();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function toggleSellMode(param1:MouseEvent) : *
      {
         this.btn_sell_mode.tick.visible = !this.btn_sell_mode.tick.visible;
         this.sellMode = this.btn_sell_mode.tick.visible;
         this.currentPage = 1;
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function openSellConfirmation(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.metaData;
         this.sellMaxQuantity = _loc2_.owned_qty;
         this.selectedSellItem = _loc2_.item_info;
         this.sellPanel = new ItemBuyConfirmation();
         this.sellPanel.btn_buy.visible = false;
         this.sellPanel.btn_use.visible = false;
         this.eventHandler.addListener(this.sellPanel.btn_sell,MouseEvent.CLICK,this.sellItemAmf);
         this.eventHandler.addListener(this.sellPanel.btn_prev,MouseEvent.CLICK,this.onChangeQuantity);
         this.eventHandler.addListener(this.sellPanel.btn_prev_10,MouseEvent.CLICK,this.onChangeQuantity);
         this.eventHandler.addListener(this.sellPanel.btn_next,MouseEvent.CLICK,this.onChangeQuantity);
         this.eventHandler.addListener(this.sellPanel.btn_next_10,MouseEvent.CLICK,this.onChangeQuantity);
         this.eventHandler.addListener(this.sellPanel.btn_close,MouseEvent.CLICK,this.onCloseConfItem);
         this.sellPanel.item.lvlTxt.text = this.selectedSellItem["item_level"];
         this.sellPanel.item.gotoAndStop(1);
         this.sellPanel.desctxt.text = "Confirm selling " + this.selectedSellItem["item_name"] + "?";
         this.sellPanel.txt_quality.text = this.sellQuantity;
         this.sellPanel.txt_gold.text = String(this.sellQuantity * this.selectedSellItem.item_sell_price);
         GF.removeAllChild(this.sellPanel.item.iconMc.iconHolder);
         NinjaSage.loadIconSWF(this.getAssetPath(this.selectedSellItem.item_id),this.selectedSellItem.item_id,this.sellPanel.item.iconMc.iconHolder,"icon");
         this.main.loader.addChild(this.sellPanel);
         this.escapeKey.addListener(this.sellPanel,this.onCloseConfItem);
      }
      
      public function onChangeQuantity(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_prev":
               if(this.sellQuantity > 1)
               {
                  --this.sellQuantity;
               }
               break;
            case "btn_prev_10":
               if(this.sellQuantity > 10)
               {
                  this.sellQuantity -= 10;
                  break;
               }
               this.sellQuantity = 1;
               break;
            case "btn_next":
               if(this.sellQuantity < 100)
               {
                  ++this.sellQuantity;
               }
               break;
            case "btn_next_10":
               if(this.sellQuantity < 100)
               {
                  this.sellQuantity += 10;
               }
         }
         if(this.sellQuantity > 100)
         {
            this.sellQuantity = 100;
         }
         if(this.sellQuantity > this.sellMaxQuantity)
         {
            this.sellQuantity = this.sellMaxQuantity;
         }
         this.sellPanel.txt_quality.text = this.sellQuantity;
         this.sellPanel.txt_gold.text = String(this.sellQuantity * this.selectedSellItem.item_sell_price);
      }
      
      public function sellItemAmf(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.dSEakmGvt8xt",[Character.char_id,Character.sessionkey,this.selectedSellItem.item_id,this.sellQuantity],this.sellResponse);
      }
      
      public function sellResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(this.sellQuantity + " " + this.selectedSellItem.item_name + " succesfully sold!");
            Character.character_gold = param1.data.character_gold;
            this.main.HUD.setBasicData();
            _loc2_ = this.selectedSellItem.item_id.split("_");
            if(_loc2_[0] == "wpn")
            {
               Character.removeWeapon(this.selectedSellItem.item_id,this.sellQuantity);
            }
            else if(_loc2_[0] == "set")
            {
               Character.removeSet(this.selectedSellItem.item_id,this.sellQuantity);
            }
            else if(_loc2_[0] == "accessory")
            {
               Character.removeAccesory(this.selectedSellItem.item_id,this.sellQuantity);
            }
            else if(_loc2_[0] == "hair")
            {
               Character.removeHair(this.selectedSellItem.item_id);
            }
            else if(_loc2_[0] == "back")
            {
               Character.removeBackItem(this.selectedSellItem.item_id,this.sellQuantity);
            }
            else if(_loc2_[0] == "material")
            {
               Character.removeMaterials(this.selectedSellItem.item_id,this.sellQuantity);
            }
            else if(_loc2_[0] == "essential")
            {
               Character.removeEssentials(this.selectedSellItem.item_id,this.sellQuantity);
            }
            else if(_loc2_[0] == "item")
            {
               Character.removeConsumables(this.selectedSellItem.item_id,this.sellQuantity);
            }
            this.onCloseConfItem();
            this.resetIconHolder();
            this.setDefaultArray();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
         this.sellQuantity = 1;
      }
      
      public function onCloseConfItem(param1:MouseEvent = null) : *
      {
         this.escapeKey.removeListener(this.sellPanel,this.onCloseConfItem);
         GF.removeAllChild(this.sellPanel.item.iconMc.iconHolder);
         GF.removeAllChild(this.sellPanel);
         this.sellQuantity = 1;
         this.sellPanel = null;
      }
      
      public function getPresetData(param1:MouseEvent = null) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.2i9S4MV921j7",[Character.char_id,Character.sessionkey],this.getPresetResponse);
      }
      
      public function getPresetResponse(param1:Object = null) : *
      {
         if(param1.status == 1)
         {
            this.presets = param1.presets;
            this.openPreset();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
         this.main.loading(false);
      }
      
      public function openPreset() : *
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:OutfitManager = null;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         this.presetMC.visible = true;
         this.main.handleVillageHUDVisibility(false);
         this.originalItemAnimation = Character.play_items_animation;
         Character.play_items_animation = false;
         this.char_mc.visible = false;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this["item_" + _loc1_].visible = false;
            _loc1_++;
         }
         this.presetMC.renameMC.visible = false;
         this.eventHandler.addListener(this.presetMC.btnClose,MouseEvent.CLICK,this.closePreset);
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc2_ < 4)
         {
            this.presetMC["presetItem" + _loc2_].visible = false;
            this.presetMC["presetItem" + _loc2_].yellowBorder.visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            if(this.presets.length == 0)
            {
               _loc4_ = -1;
               _loc5_ = int(this.presets.length);
               _loc6_ = getDefinitionByName("PlusButton") as Class;
               _loc7_ = new _loc6_();
               this.presetMC["plusHolder" + _loc5_].visible = true;
               this.presetMC["plusHolder" + _loc5_].addChild(_loc7_);
               _loc7_.buttonMode = true;
               this.eventHandler.addListener(_loc7_,MouseEvent.CLICK,this.presetBuyConfirmation);
               return;
            }
            _loc4_ = _loc2_ + int(int(this.preset_curr_page - 1) * 4);
            if(this.presets.length > _loc4_)
            {
               this.presetMC["presetItem" + _loc2_].visible = true;
               _loc8_ = [this.presets[_loc4_].hair,this.presets[_loc4_].clothing,this.presets[_loc4_].back_item,this.presets[_loc4_].weapon,this.presets[_loc4_].accessory];
               _loc9_ = [Character.character_hair,Character.character_set,Character.character_back_item,Character.character_weapon,Character.character_accessory];
               _loc10_ = new OutfitManager(this.main);
               if(String(_loc8_) == String(_loc9_))
               {
                  this.presetMC["presetItem" + _loc2_].yellowBorder.visible = true;
               }
               GF.removeAllChild(this.presetMC["plusHolder" + _loc2_]);
               if(this.presets.length < 4)
               {
                  _loc5_ = int(this.presets.length);
                  _loc6_ = getDefinitionByName("PlusButton") as Class;
                  _loc7_ = new _loc6_();
                  this.presetMC["plusHolder" + _loc5_].visible = true;
                  this.presetMC["plusHolder" + _loc5_].addChild(_loc7_);
                  _loc7_.buttonMode = true;
                  this.eventHandler.addListener(_loc7_,MouseEvent.CLICK,this.presetBuyConfirmation);
               }
               this.presetMC["presetItem" + _loc2_].nameTxt.text = this.presets[_loc4_].name;
               _loc10_.useLoader("assets").fillOutfit(this.presetMC["presetItem" + _loc2_].char_mc,this.presets[_loc4_].weapon,this.presets[_loc4_].back_item,this.presets[_loc4_].clothing,this.presets[_loc4_].hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
               this.eventHandler.addListener(this.presetMC["presetItem" + _loc2_].btnSave,MouseEvent.CLICK,this.savePresetConfirmation);
               this.eventHandler.addListener(this.presetMC["presetItem" + _loc2_].btnUsePreset,MouseEvent.CLICK,this.selectPreset);
               this.eventHandler.addListener(this.presetMC["presetItem" + _loc2_].btnRename,MouseEvent.CLICK,this.renamePreset);
               while(_loc3_ < 5)
               {
                  _loc11_ = this.presetMC["presetItem" + _loc2_]["iconMC" + _loc3_].rewardIcon;
                  this.presetMC["presetItem" + _loc2_]["iconMC" + _loc3_].rewardIcon.noItem.visible = true;
                  GF.removeAllChild(_loc11_.iconHolder);
                  if(_loc8_[_loc3_] != null)
                  {
                     this.presetMC["presetItem" + _loc2_]["iconMC" + _loc3_].rewardIcon.noItem.visible = false;
                     NinjaSage.loadIconSWF("items",_loc8_[_loc3_],_loc11_);
                  }
                  _loc12_ = Library.getItemInfo(_loc8_[_loc3_]);
                  this.presetMC["presetItem" + _loc2_]["iconMC" + _loc3_].tooltip = _loc12_;
                  this.presetMC["presetItem" + _loc2_]["iconMC" + _loc3_].item_type = _loc8_[_loc3_].split("_")[0];
                  this.eventHandler.addListener(this.presetMC["presetItem" + _loc2_]["iconMC" + _loc3_],MouseEvent.ROLL_OVER,this.toolTiponOver);
                  this.eventHandler.addListener(this.presetMC["presetItem" + _loc2_]["iconMC" + _loc3_],MouseEvent.ROLL_OUT,this.toolTiponOut);
                  _loc3_++;
               }
            }
            else
            {
               this.presetMC["presetItem" + _loc2_].visible = false;
            }
            _loc2_++;
            _loc3_ = 0;
         }
      }
      
      public function selectPreset(param1:MouseEvent) : *
      {
         this.presetTarget = int(param1.currentTarget.parent.name.replace("presetItem","")) + int(int(this.preset_curr_page - 1) * 4);
         Character.character_hair = this.presets[this.presetTarget].hair;
         Character.character_set = this.presets[this.presetTarget].clothing;
         Character.character_back_item = this.presets[this.presetTarget].back_item;
         Character.character_weapon = this.presets[this.presetTarget].weapon;
         Character.character_accessory = this.presets[this.presetTarget].accessory;
         this.main.showMessage("Preset Changed to " + this.presets[this.presetTarget].name);
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
         this.getPresetData();
         this.setDefaultArray();
         this.initUI();
      }
      
      public function savePresetConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.presetTarget = int(e.currentTarget.parent.name.replace("presetItem","")) + int(int(this.preset_curr_page - 1) * 4);
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to save your preset to " + this.presets[this.presetTarget].name + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.savePreset);
         addChild(this.confirmation);
      }
      
      public function savePreset(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.ZwiSgZ9QhGjW",[Character.char_id,Character.sessionkey,this.presets[this.presetTarget].id,Character.character_weapon,Character.character_set,Character.character_hair,Character.character_back_item,Character.character_accessory,Character.character_color_hair],this.savePresetResponse);
      }
      
      public function savePresetResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.main.showMessage("Preset Saved to " + this.presets[this.presetTarget].name);
            this.getPresetData();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function renamePreset(param1:MouseEvent) : *
      {
         this.presetTarget = int(param1.currentTarget.parent.name.replace("presetItem","")) + int(int(this.preset_curr_page - 1) * 4);
         this.presetMC.renameMC.visible = true;
         this.eventHandler.addListener(this.presetMC.renameMC.btn_close,MouseEvent.CLICK,this.closePresetRename);
         this.eventHandler.addListener(this.presetMC.renameMC.btn_confirm,MouseEvent.CLICK,this.presetRenameConfirmation);
      }
      
      public function presetRenameConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to rename your " + this.presets[this.presetTarget].name + " preset name to " + this.presetMC.renameMC.nameTxt.text + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onPresetRename);
         addChild(this.confirmation);
      }
      
      public function onPresetRename(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.faOiPGgjDin6",[Character.char_id,Character.sessionkey,this.presets[this.presetTarget].id,this.presetMC.renameMC.nameTxt.text],this.presetRenameResponse);
      }
      
      public function presetRenameResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.main.showMessage("Preset " + this.presets[this.presetTarget].name + " Renamed to " + this.presetMC.renameMC.nameTxt.text);
            this.presetMC.renameMC.nameTxt.text = "";
            this.getPresetData();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function closePresetRename(param1:MouseEvent) : *
      {
         this.presetMC.renameMC.visible = false;
         this.presetMC.renameMC.nameTxt.text = "";
         this.confirmation = null;
      }
      
      public function presetBuyConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         if(this.presets.length == 0)
         {
            this.confirmation.txtMc.txt.text = "Are you sure that you want to unlock new preset for 0 tokens?";
         }
         else
         {
            this.confirmation.txtMc.txt.text = "Are you sure that you want to unlock new preset for 500 tokens?";
         }
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onPresetBuy);
         addChild(this.confirmation);
      }
      
      public function onPresetBuy(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.MlMXVvboanph",[Character.char_id,Character.sessionkey],this.presetBuyResponse);
      }
      
      public function presetBuyResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            Character.account_tokens = param1.tokens;
            this.main.HUD.setBasicData();
            this.getPresetData();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function closePreset(param1:MouseEvent) : *
      {
         Character.play_items_animation = this.originalItemAnimation;
         this.char_mc.visible = true;
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            this["item_" + _loc2_].visible = this["item_" + _loc2_].iconMc.iconHolder.numChildren > 0;
            _loc2_++;
         }
         this.main.handleVillageHUDVisibility(true);
         this.presetMC.visible = false;
      }
      
      public function openSortList(param1:MouseEvent) : void
      {
         this.sortMC.sort_list.visible = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.sortListArray.length)
         {
            this.main.initButton(this.sortMC.sort_list["sort_" + _loc2_],this.selectSort,this.sortListArray[_loc2_]);
            _loc2_++;
         }
      }
      
      public function selectSort(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.currentTarget.name.replace("sort_",""));
         if(this.selectedSort == _loc2_)
         {
            this.sortMC.sort_list.visible = false;
            return;
         }
         this.selectedSort = _loc2_;
         this.sortMC.btn_sort.txt.text = this.sortListArray[this.selectedSort];
         this.sortMC.sort_list.visible = false;
         this.currentPage = 1;
         this.updateSortTooltip();
         this.setDefaultArray();
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function updateSortTooltip() : void
      {
         var _loc1_:String = this.selectedSort == 0 ? "all" : this.sortListArray[this.selectedSort].toLowerCase();
         NinjaSage.showDynamicTooltip(this.sortMC.btn_sort,"Showing " + _loc1_ + " items");
      }
      
      public function handleSearchFilter(param1:MouseEvent) : *
      {
         this.btn_filter.filter_on.visible = !this.btn_filter.filter_on.visible;
         this.isDescription = this.btn_filter.filter_on.visible ? true : false;
      }
      
      public function searchItem(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc7_:String = null;
         if(this.txt_search.text == "")
         {
            return;
         }
         this.setDefaultArray();
         var _loc2_:Array = [];
         var _loc3_:String = this.txt_search.text.toLowerCase();
         var _loc6_:* = 0;
         while(_loc6_ < this.selectedCategory.length)
         {
            _loc5_ = this.selectedCategory[_loc6_].split(":")[0];
            _loc4_ = Library.getItemInfo(_loc5_);
            _loc7_ = this.isDescription ? "item_description" : "item_name";
            if(Boolean(_loc4_) && Boolean(_loc4_.hasOwnProperty(_loc7_)) && _loc4_[_loc7_].toLowerCase().indexOf(_loc3_) >= 0)
            {
               _loc2_.push(this.selectedCategory[_loc6_]);
            }
            _loc6_++;
         }
         this.selectedCategory = this.sortItems(_loc2_);
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
         this.currentPage = 1;
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function clearSearch(param1:MouseEvent) : *
      {
         this.txt_search.text = "";
         this.txt_goToPage.text = "";
         this.currentPage = 1;
         this.setDefaultArray();
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function useItem(param1:MouseEvent) : *
      {
         this.usableItem = param1.currentTarget.metaData.usable_item["item_id"];
         this.useItemQuantity = 1;
         if(this.usableItem == "essential_10")
         {
            this.main.loadExternalSwfPanel("ScrollOfWisdom","ScrollOfWisdom");
            return;
         }
         if(param1.currentTarget.metaData.owned_qty > 1)
         {
            this.useItemPanel = new ItemBuyConfirmation();
            this.useItemPanel.btn_buy.visible = false;
            this.useItemPanel.btn_sell.visible = false;
            this.useItemPanel.currencyIcon.visible = false;
            this.useItemPanel.lbl_use.visible = false;
            this.useItemPanel.txt_gold.visible = false;
            this.useItemMaxQuantity = param1.currentTarget.metaData.owned_qty;
            this.eventHandler.addListener(this.useItemPanel.btn_use,MouseEvent.CLICK,this.useItemAmf);
            this.eventHandler.addListener(this.useItemPanel.btn_prev,MouseEvent.CLICK,this.onChangeQuantityUse);
            this.eventHandler.addListener(this.useItemPanel.btn_prev_10,MouseEvent.CLICK,this.onChangeQuantityUse);
            this.eventHandler.addListener(this.useItemPanel.btn_next,MouseEvent.CLICK,this.onChangeQuantityUse);
            this.eventHandler.addListener(this.useItemPanel.btn_next_10,MouseEvent.CLICK,this.onChangeQuantityUse);
            this.eventHandler.addListener(this.useItemPanel.btn_close,MouseEvent.CLICK,this.closeUseItemPanel);
            this.useItemPanel.item.lvlTxt.text = param1.currentTarget.metaData.usable_item["item_level"];
            this.useItemPanel.item.gotoAndStop(1);
            this.useItemPanel.desctxt.text = "Confirm using " + param1.currentTarget.metaData.usable_item["item_name"] + "?";
            this.useItemPanel.txt_quality.text = String(this.useItemQuantity);
            GF.removeAllChild(this.useItemPanel.item.iconMc.iconHolder);
            NinjaSage.loadIconSWF(this.getAssetPath(param1.currentTarget.metaData.usable_item["item_id"]),param1.currentTarget.metaData.usable_item["item_id"],this.useItemPanel.item.iconMc.iconHolder,"icon");
            this.main.loader.addChild(this.useItemPanel);
            this.escapeKey.addListener(this.useItemPanel,this.closeUseItemPanel);
         }
         else
         {
            this.useItemAmf();
         }
      }
      
      public function useItemAmf(param1:MouseEvent = null) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.kbCjIzXIF7GF",[Character.char_id,Character.sessionkey,this.usableItem,this.useItemQuantity],this.onUseItem);
      }
      
      public function onChangeQuantityUse(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_prev":
               if(this.useItemQuantity > 1)
               {
                  --this.useItemQuantity;
               }
               break;
            case "btn_prev_10":
               if(this.useItemQuantity > 10)
               {
                  this.useItemQuantity -= 10;
                  break;
               }
               this.useItemQuantity = 1;
               break;
            case "btn_next":
               if(this.useItemQuantity < 100)
               {
                  ++this.useItemQuantity;
               }
               break;
            case "btn_next_10":
               if(this.useItemQuantity < 100)
               {
                  this.useItemQuantity += 10;
               }
         }
         if(this.useItemQuantity > 100)
         {
            this.useItemQuantity = 100;
         }
         if(this.useItemQuantity > this.useItemMaxQuantity)
         {
            this.useItemQuantity = this.useItemMaxQuantity;
         }
         this.useItemPanel.txt_quality.text = String(this.useItemQuantity);
      }
      
      public function onUseItem(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            Character.addRewards(param1.rewards);
            Character.removeEssentials(this.usableItem,this.useItemQuantity);
            this.materialArray = this.sortItems(Character.character_materials.split(","));
            this.essentialArray = this.sortItems(Character.character_essentials.split(","));
            this.setDefaultArray();
            this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
            this.main.HUD.setBasicData();
            this.main.giveReward(1,param1.rewards);
            this.closeUseItemPanel();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function closeUseItemPanel(param1:MouseEvent = null) : *
      {
         if(this.useItemPanel != null)
         {
            this.escapeKey.removeListener(this.useItemPanel,this.closeUseItemPanel);
            GF.removeAllChild(this.useItemPanel.item.iconMc.iconHolder);
            GF.removeAllChild(this.useItemPanel);
            this.useItemQuantity = 1;
            this.useItemPanel = null;
         }
      }
      
      public function goToPage(param1:MouseEvent) : *
      {
         if(this.txt_goToPage.text == "")
         {
            return;
         }
         if(int(this.txt_goToPage.text) > this.totalPage || int(this.txt_goToPage.text) <= 0)
         {
            return;
         }
         this.currentPage = int(this.txt_goToPage.text);
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function clearPreview(param1:MouseEvent) : *
      {
         this.removeChildsFromMovieClip(this.char_mc["weapon"]);
         this.removeChildsFromMovieClip(this.char_mc["back"]);
         this.removeChildsFromMovieClip(this.char_mc.head["hair"]);
         this.removeChildsFromMovieClip(this.char_mc["back_hair"]);
         this.removeChildsFromMovieClip(this.char_mc["skirt"]);
         var _loc2_:* = 0;
         while(_loc2_ < this.bodyArray.length)
         {
            this.removeChildsFromMovieClip(this.char_mc[this.bodyArray[_loc2_]]);
            this.char_mc[this.bodyArray[_loc2_]].addChild(OutfitManager.set_mc[_loc2_]);
            _loc2_++;
         }
         try
         {
            this.char_mc["weapon"].addChild(OutfitManager.weapon_mc[0]);
            this.char_mc.head["hair"].addChild(OutfitManager.hair_mc[0]);
            this.char_mc["back_hair"].addChild(OutfitManager.hair_mc[1]);
            this.char_mc["skirt"].addChild(OutfitManager.set_mc[14]);
            this.char_mc["back"].addChild(OutfitManager.back_mc[0]);
         }
         catch(error:Error)
         {
         }
      }
      
      public function unEquipItem(param1:MouseEvent) : *
      {
         if(this.tabIndicator == "accessory")
         {
            Character.character_accessory = "accessory_00";
            this.equippedItem = "accessory_00";
         }
         else if(this.tabIndicator == "back")
         {
            Character.character_back_item = "back_00";
            this.equippedItem = "back_00";
            this.removeChildsFromMovieClip(this.char_mc["back"]);
            OutfitManager.back_mc[0] = null;
         }
         this.currentPage = 1;
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function addHairColor(param1:MovieClip) : *
      {
         var _loc2_:ColorTransform = new ColorTransform();
         var _loc3_:ColorTransform = new ColorTransform();
         var _loc4_:* = this.selectedHairColor.split("|");
         _loc2_.color = _loc4_[0];
         _loc3_.color = _loc4_[1];
         if("hair_color_1" in param1 && _loc4_[0] != "null")
         {
            if(_loc4_[0] != "null")
            {
               try
               {
                  param1.hair_color_1.transform.colorTransform = _loc2_;
               }
               catch(error:Error)
               {
               }
            }
         }
         if("hair_color_2" in param1 && _loc4_[1] != "null")
         {
            try
            {
               param1.hair_color_2.transform.colorTransform = _loc3_;
            }
            catch(error:Error)
            {
            }
         }
      }
      
      public function addSkinColor(param1:MovieClip) : *
      {
         var _loc2_:ColorTransform = new ColorTransform();
         var _loc3_:* = this.selectedSkinColor.split("|");
         _loc2_.color = _loc3_[0];
         if(_loc3_[0] != "null")
         {
            if("skin_color" in param1)
            {
               try
               {
                  param1.skin_color.transform.colorTransform = _loc2_;
               }
               catch(error:Error)
               {
               }
            }
         }
      }
      
      public function addFaceColor(param1:MovieClip) : *
      {
         var _loc2_:ColorTransform = new ColorTransform();
         var _loc3_:* = this.selectedSkinColor.split("|");
         _loc2_.color = _loc3_[1];
         if(_loc3_[1] != "null")
         {
            if("skin_color" in param1)
            {
               try
               {
                  param1.skin_color.transform.colorTransform = _loc2_;
               }
               catch(error:Error)
               {
               }
            }
         }
      }
      
      public function resetSkinColor(param1:MouseEvent) : *
      {
         Character.character_color_skin = "null|null";
         this.selectedSkinColor = "null|null";
         var _loc2_:ColorTransform = new ColorTransform();
         var _loc3_:* = 0;
         while(_loc3_ < this.bodyArray.length)
         {
            this.removeChildsFromMovieClip(this.char_mc[this.bodyArray[_loc3_]]);
            if("skin_color" in this.selectedSetMC[_loc3_])
            {
               this.selectedSetMC[_loc3_].skin_color.transform.colorTransform = _loc2_;
            }
            this.char_mc[this.bodyArray[_loc3_]].addChild(this.selectedSetMC[_loc3_]);
            _loc3_++;
         }
         this.removeChildsFromMovieClip(this.char_mc.head.face);
         OutfitManager.face_mc[0].skin_color.transform.colorTransform = _loc2_;
         this.char_mc.head.face.addChild(OutfitManager.face_mc[0]);
      }
      
      public function resetHairColor(param1:MouseEvent) : void
      {
         Character.character_color_hair = "null|null";
         this.selectedHairColor = "null|null";
         var _loc2_:ColorTransform = new ColorTransform();
         this.removeChildsFromMovieClip(this.char_mc.head["hair"]);
         this.selectedHairMC.hair_color_1.transform.colorTransform = _loc2_;
         this.selectedHairMC.hair_color_2.transform.colorTransform = _loc2_;
         this.char_mc.head["hair"].addChild(this.selectedHairMC);
      }
      
      public function colorChangeHandler1(param1:ColorPickerEvent) : *
      {
         if(!this.selectedHairMC.hasOwnProperty("hair_color_1") || !OutfitManager.hair_mc[0].hasOwnProperty("hair_color_1"))
         {
            this.main.showMessage("This hair doesn\'t support coloring");
            return;
         }
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedHairColor.split("|");
         this.selectedHairColor = _loc2_ + "|" + _loc3_[1];
         Character.character_color_hair = this.selectedHairColor;
         this.removeChildsFromMovieClip(this.char_mc.head["hair"]);
         this.addHairColor(this.selectedHairMC);
         this.char_mc.head["hair"].addChild(this.selectedHairMC);
      }
      
      public function colorChangeHandler2(param1:ColorPickerEvent) : *
      {
         if(!this.selectedHairMC.hasOwnProperty("hair_color_2") || !OutfitManager.hair_mc[0].hasOwnProperty("hair_color_2"))
         {
            this.main.showMessage("This hair doesn\'t support coloring");
            return;
         }
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedHairColor.split("|");
         this.selectedHairColor = _loc3_[0] + "|" + _loc2_;
         Character.character_color_hair = this.selectedHairColor;
         this.removeChildsFromMovieClip(this.char_mc.head["hair"]);
         this.addHairColor(this.selectedHairMC);
         this.char_mc.head["hair"].addChild(this.selectedHairMC);
      }
      
      public function colorChangeHandler3(param1:ColorPickerEvent) : *
      {
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedSkinColor.split("|");
         this.selectedSkinColor = _loc2_ + "|" + _loc3_[1];
         Character.character_color_skin = this.selectedSkinColor;
         var _loc4_:* = 0;
         while(_loc4_ < this.bodyArray.length)
         {
            this.removeChildsFromMovieClip(this.char_mc[this.bodyArray[_loc4_]]);
            this.addSkinColor(this.selectedSetMC[_loc4_]);
            this.char_mc[this.bodyArray[_loc4_]].addChild(this.selectedSetMC[_loc4_]);
            _loc4_++;
         }
      }
      
      public function colorChangeHandler4(param1:ColorPickerEvent) : *
      {
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedSkinColor.split("|");
         this.selectedSkinColor = _loc3_[0] + "|" + _loc2_;
         Character.character_color_skin = this.selectedSkinColor;
         this.removeChildsFromMovieClip(this.char_mc.head.face);
         this.addFaceColor(OutfitManager.face_mc[0]);
         this.char_mc.head.face.addChild(OutfitManager.face_mc[0]);
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  break;
               }
               return;
               break;
            case "btn_prev":
               if(this.currentPage <= 1)
               {
                  return;
               }
               --this.currentPage;
         }
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         if(this.loaderSwf.itemsLoaded >= 50)
         {
            this.loaderSwf.removeAll();
         }
         this.loadSwf();
      }
      
      public function updatePageNumber() : *
      {
         this.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      public function changeCategory(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.tabButton.length)
         {
            this[this.tabButton[_loc2_]].gotoAndStop(1);
            _loc2_++;
         }
         param1.currentTarget.gotoAndStop(3);
         var _loc3_:String = param1.currentTarget.name;
         switch(_loc3_)
         {
            case "mcWeapon":
               this.selectedCategory = this.weaponArray;
               this.tabIndicator = "weapon";
               this.equippedItem = Character.character_weapon;
               break;
            case "mcSet":
               this.selectedCategory = this.setArray;
               this.tabIndicator = "set";
               this.equippedItem = Character.character_set;
               break;
            case "mcBackItem":
               this.selectedCategory = this.backArray;
               this.tabIndicator = "back";
               this.equippedItem = Character.character_back_item;
               break;
            case "mcAccessory":
               this.selectedCategory = this.accArray;
               this.tabIndicator = "accessory";
               this.equippedItem = Character.character_accessory;
               break;
            case "mcEssentials":
               this.selectedCategory = this.essentialArray;
               this.tabIndicator = "essential";
               break;
            case "mcMaterials":
               this.selectedCategory = this.materialArray;
               this.tabIndicator = "material";
               break;
            case "mcHairstyle":
               this.selectedCategory = this.hairArray;
               this.tabIndicator = "hair";
               this.equippedItem = Character.character_hair;
               break;
            case "mcItems":
               this.selectedCategory = this.consumableArray;
               this.tabIndicator = "consumable";
               break;
            case "mcFavorite":
               this.selectedCategory = this.favoriteArray;
               this.tabIndicator = "favorite";
               this.equippedItem = null;
               break;
            case "mcColor":
         }
         this.btn_unequip.visible = this.tabIndicator == "accessory" || this.tabIndicator == "back" ? true : false;
         this.sortMC.visible = this.tabIndicator == "essential" || this.tabIndicator == "material" || this.tabIndicator == "consumable" || this.tabIndicator == "hair" || this.tabIndicator == "favorite" ? false : true;
         if(_loc3_ == "mcColor")
         {
            this.colorMC0.visible = true;
            this.colorMC1.visible = true;
            this.colorMC0.resetColor.buttonMode = true;
            this.colorMC1.resetColor.buttonMode = true;
            this.eventHandler.addListener(this.colorMC0.cPicker1,ColorPickerEvent.CHANGE,this.colorChangeHandler1);
            this.eventHandler.addListener(this.colorMC0.cPicker2,ColorPickerEvent.CHANGE,this.colorChangeHandler2);
            this.eventHandler.addListener(this.colorMC0.resetColor,MouseEvent.CLICK,this.resetHairColor);
            this.eventHandler.addListener(this.colorMC1.cPicker1,ColorPickerEvent.CHANGE,this.colorChangeHandler3);
            this.eventHandler.addListener(this.colorMC1.cPicker2,ColorPickerEvent.CHANGE,this.colorChangeHandler4);
            this.eventHandler.addListener(this.colorMC1.resetColor,MouseEvent.CLICK,this.resetSkinColor);
            if(this.firstLoad)
            {
               this.selectedHairMC = OutfitManager.hair_mc[0];
               this.selectedBackHairMC = OutfitManager.hair_mc[1];
               this.selectedSetMC = OutfitManager.set_mc;
               this.firstLoad = false;
            }
         }
         else
         {
            this.colorMC0.visible = false;
            this.colorMC1.visible = false;
            this.currentPage = 1;
            this.selectedSort = 0;
            this.updateSortTooltip();
            this.sortMC.btn_sort.txt.text = this.sortListArray[this.selectedSort];
            this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 10),1);
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
         }
      }
      
      public function setDefaultArray() : *
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc1_:Object = {
            "weapon":"character_weapons",
            "set":"character_sets",
            "back":"character_back_items",
            "accessory":"character_accessories",
            "hair":"character_hairs",
            "material":"character_materials",
            "essential":"character_essentials",
            "consumable":"character_consumables"
         };
         if(this.tabIndicator == "favorite")
         {
            this.selectedCategory = this.favoriteArray;
         }
         else if(this.tabIndicator in _loc1_)
         {
            _loc2_ = this.tabIndicator == "weapon" ? "wpn" : this.tabIndicator;
            _loc3_ = _loc1_[this.tabIndicator];
            _loc4_ = this.getSelectedArray(_loc2_,_loc3_);
            this.selectedCategory = _loc4_;
         }
      }
      
      public function getSelectedArray(param1:String, param2:String) : Array
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc3_:Array = Character[param2].split(",");
         if(this.selectedSort == 0)
         {
            return this.sortItems(_loc3_);
         }
         var _loc4_:Array = Library.getItemIds(param1,Character.character_gender,this.sortListArray[this.selectedSort].replace(" ","").toLowerCase());
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc6_];
            _loc8_ = _loc7_.split(":")[0];
            if(_loc4_.indexOf(_loc8_) > -1)
            {
               _loc5_.push(_loc7_);
            }
            _loc6_++;
         }
         return this.sortItems(_loc5_);
      }
      
      public function resetRecursiveProperty() : *
      {
         this.itemLoading = this.currentPage * 10;
         if(this.selectedCategory.length < this.itemLoading)
         {
            this.itemLoading = this.selectedCategory.length;
         }
         this.itemIndex = (this.currentPage - 1) * 10;
         this.itemCount = 0;
      }
      
      public function resetIconHolder() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         while(_loc1_ < this.itemEquipMC.length)
         {
            if(this.tabIndicator == "set")
            {
               _loc2_ = 0;
               while(_loc2_ < this.bodyArray.length)
               {
                  if(this.itemEquipMC[_loc1_] != null && this.itemEquipMC[_loc1_][_loc2_] != null)
                  {
                     this.itemEquipMC[_loc1_][_loc2_].stopAllMovieClips();
                     GF.removeAllChild(this.itemEquipMC[_loc1_][_loc2_]);
                  }
                  _loc2_++;
               }
            }
            else if(this.itemEquipMC[_loc1_] is Array)
            {
               _loc2_ = 0;
               while(_loc2_ < this.bodyArray.length)
               {
                  if(this.itemEquipMC[_loc1_][_loc2_] != null)
                  {
                     this.itemEquipMC[_loc1_][_loc2_].stopAllMovieClips();
                  }
                  GF.removeAllChild(this.itemEquipMC[_loc1_][_loc2_]);
                  _loc2_++;
               }
            }
            else
            {
               if(this.itemEquipMC[_loc1_] != null)
               {
                  this.itemEquipMC[_loc1_].stopAllMovieClips();
               }
               GF.removeAllChild(this.itemEquipMC[_loc1_]);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.backHairMC.length)
         {
            if(this.backHairMC[_loc1_] != null)
            {
               this.backHairMC[_loc1_].stopAllMovieClips();
            }
            GF.removeAllChild(this.backHairMC[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.skirtMC.length)
         {
            if(this.skirtMC[_loc1_] != null)
            {
               this.skirtMC[_loc1_].stopAllMovieClips();
            }
            GF.removeAllChild(this.skirtMC[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.iconMCArray.length)
         {
            if(this.iconMCArray[_loc1_] != null)
            {
               this.iconMCArray[_loc1_].stopAllMovieClips();
            }
            GF.removeAllChild(this.iconMCArray[_loc1_]);
            _loc1_++;
         }
         this.iconMCArray = [];
         this.itemEquipMC = [];
         this.backHairMC = [];
         this.skirtMC = [];
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            GF.removeAllChild(this["item_" + _loc1_].iconMc.iconHolder);
            this.color.brightness = -0.3;
            this["item_" + _loc1_].transform.colorTransform = this.color;
            this["item_" + _loc1_].gotoAndStop(1);
            this["item_" + _loc1_].visible = false;
            this["item_" + _loc1_].btn_equip.visible = false;
            this["item_" + _loc1_].btn_use.visible = false;
            this["item_" + _loc1_].btn_sell.visible = false;
            this["item_" + _loc1_].btn_addFavorite.visible = false;
            this["item_" + _loc1_].btn_removeFavorite.visible = false;
            this["item_" + _loc1_].lockMc.visible = true;
            this["item_" + _loc1_].emblemMC.visible = false;
            this["item_" + _loc1_].amtTxt.visible = false;
            this["item_" + _loc1_].txt_equipped.visible = false;
            this["item_" + _loc1_].btn_use.metaData = {};
            this["item_" + _loc1_].btn_equip.metaData = {};
            this["item_" + _loc1_].btn_sell.metaData = {};
            this["item_" + _loc1_].btn_addFavorite.metaData = {};
            this["item_" + _loc1_].btn_removeFavorite.metaData = {};
            delete this["item_" + _loc1_].clickmask.tooltip;
            delete this["item_" + _loc1_].clickmask.tooltipCache;
            this.eventHandler.removeListener(this["item_" + _loc1_].clickmask,MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this["item_" + _loc1_].clickmask,MouseEvent.MOUSE_OUT,this.toolTiponOut);
            this.eventHandler.removeListener(this["item_" + _loc1_].clickmask,MouseEvent.CLICK,this.loadItem);
            this.eventHandler.removeListener(this["item_" + _loc1_].btn_equip,MouseEvent.CLICK,this.loadItem);
            this.eventHandler.removeListener(this["item_" + _loc1_].btn_use,MouseEvent.CLICK,this.useItem);
            this.eventHandler.removeListener(this["item_" + _loc1_].btn_addFavorite,MouseEvent.CLICK,this.addItemFavorite);
            this.eventHandler.removeListener(this["item_" + _loc1_].btn_removeFavorite,MouseEvent.CLICK,this.removeItemFavorite);
            _loc1_++;
         }
      }
      
      public function removeChildsFromMovieClip(param1:MovieClip) : *
      {
         GF.removeAllChild(param1);
      }
      
      public function getAssetPath(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = param1.split("_")[0];
         if(_loc3_ == "material")
         {
            _loc2_ = "materials";
         }
         else if(_loc3_ == "essential")
         {
            _loc2_ = "essentials";
         }
         else if(_loc3_ == "item")
         {
            _loc2_ = "consumables";
         }
         else
         {
            _loc2_ = "items";
         }
         return _loc2_;
      }
      
      public function hoverOver(param1:Event) : *
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      public function hoverOut(param1:Event) : *
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      public function toolTiponOver(param1:MouseEvent) : void
      {
         var mc:MovieClip;
         var finalDesc:String;
         var setItemType:String;
         var formatDesc:Function;
         var tooltipData:Object = null;
         var itemSource:Array = null;
         var skillSource:Array = null;
         var desc:String = null;
         var itemType:String = null;
         var setItemId:String = null;
         var setSection:String = null;
         var e:MouseEvent = param1;
         e.currentTarget.parent.gotoAndStop(2);
         mc = e.currentTarget as MovieClip;
         if(!mc.tooltipCache)
         {
            formatDesc = function(param1:String, param2:String, param3:String, param4:String = "", param5:String = "", param6:Array = null):String
            {
               return param1 + "\n(" + param2 + ")\n\nLevel " + param3 + param4 + "\n\n" + param5 + ItemDropSourceMapping.formatSourceText(param6);
            };
            tooltipData = mc.tooltip;
            if(!tooltipData)
            {
               return;
            }
            itemSource = tooltipData.hasOwnProperty("item_source") ? tooltipData.item_source : null;
            skillSource = tooltipData.hasOwnProperty("skill_source") ? tooltipData.skill_source : null;
            itemType = mc.item_type;
            switch(itemType)
            {
               case "skill":
                  desc = formatDesc(tooltipData.skill_name,"Skill",tooltipData.skill_level,"\nDamage: " + tooltipData.skill_damage + "\nCP Cost: " + tooltipData.skill_cp_cost + "\nCooldown: " + tooltipData.skill_cooldown,tooltipData.skill_description,skillSource);
                  break;
               case "wpn":
                  desc = formatDesc(tooltipData.item_name,"Weapon",tooltipData.item_level,"\n<font color=\"#ff0000\">Damage: " + tooltipData.item_damage + "</font>",tooltipData.item_description,itemSource);
                  break;
               case "back":
                  desc = formatDesc(tooltipData.item_name,"Back Item",tooltipData.item_level,"",tooltipData.item_description,itemSource);
                  break;
               case "set":
                  desc = formatDesc(tooltipData.item_name,"Clothes",tooltipData.item_level,"",tooltipData.item_description,itemSource);
                  break;
               case "hair":
                  desc = formatDesc(tooltipData.item_name,"Hairstyle",tooltipData.item_level,"",tooltipData.item_description,itemSource);
                  break;
               case "accessory":
                  desc = formatDesc(tooltipData.item_name,"Accessories",tooltipData.item_level,"",tooltipData.item_description,itemSource);
                  break;
               case "material":
                  desc = formatDesc(tooltipData.item_name,"Material",tooltipData.item_level,"",tooltipData.item_description,itemSource);
                  break;
               case "essential":
                  desc = formatDesc(tooltipData.item_name,"Essentials",tooltipData.item_level,"",tooltipData.item_description,itemSource);
                  break;
               case "item":
                  desc = formatDesc(tooltipData.item_name,"Consumables",tooltipData.item_level,"",tooltipData.item_description,itemSource);
                  break;
               case "pet":
                  desc = formatDesc(tooltipData.pet_name,"Pet",tooltipData.pet_level,"",tooltipData.description,itemSource);
                  break;
               case "tokens":
                  desc = "(Token)\n" + tooltipData + " Tokens";
                  break;
               case "gold":
                  desc = "(Gold)\n" + tooltipData + " Gold";
                  break;
               case "tp":
                  desc = "(TP)\n" + tooltipData + " TP";
                  break;
               case "xp":
                  desc = "(XP)\n" + tooltipData + " XP";
                  break;
               case "ss":
                  desc = "(SS)\n" + tooltipData + " SS";
                  break;
               default:
                  desc = "";
            }
            mc.tooltipCache = desc;
         }
         finalDesc = mc.tooltipCache;
         setItemType = mc.item_type;
         if(setItemType == "wpn" || setItemType == "back" || setItemType == "set" || setItemType == "hair" || setItemType == "accessory")
         {
            setItemId = Boolean(mc.tooltip) && Boolean(mc.tooltip.hasOwnProperty("item_id")) ? mc.tooltip.item_id : null;
            if(setItemId != null)
            {
               setSection = SetBuffs.buildSetTooltip(setItemId,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_accessory);
               if(setSection != "")
               {
                  finalDesc += setSection;
               }
            }
         }
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(finalDesc);
      }
      
      public function toolTiponOut(param1:MouseEvent) : *
      {
         param1.currentTarget.parent.gotoAndStop(1);
         this.tooltip.hide();
      }
      
      public function sortItems(param1:Array) : Array
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(param1.length == 0)
         {
            return param1;
         }
         var _loc2_:String = param1[0];
         var _loc3_:String = null;
         var _loc4_:Array = [Character.character_weapon,Character.character_back_item,Character.character_accessory,Character.character_set,Character.character_hair];
         if(Character.character_back_item == "back_00" || Character.character_accessory == "accessory_00")
         {
            _loc7_ = param1[0].split("_")[0];
            if(_loc7_ == "back" || _loc7_ == "accessory")
            {
               return param1;
            }
         }
         for each(_loc5_ in param1)
         {
            _loc8_ = _loc5_.split(":")[0];
            if(_loc4_.indexOf(_loc8_) != -1)
            {
               _loc3_ = _loc5_;
               break;
            }
         }
         _loc6_ = _loc3_ ? [_loc3_] : [_loc2_];
         for each(_loc5_ in param1)
         {
            if(_loc6_[0] != _loc5_)
            {
               _loc6_.push(_loc5_);
            }
         }
         return _loc6_;
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.WmalnCMVwOnL",[Character.char_id,Character.sessionkey,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_accessory,Character.character_hair,Character.character_color_hair,Character.character_color_skin],this.equipResponse);
      }
      
      public function equipResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.destroy();
         }
         else
         {
            if(param1.status > 1 && param1.hasOwnProperty("result"))
            {
               this.main.showMessage(param1.result);
               return;
            }
            if(param1.error == 102)
            {
               this.main.showMessage(param1.result);
               return;
            }
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.destroy();
         }
      }
      
      public function removeCharMCItems(param1:*) : *
      {
         if(!param1 || param1 == null)
         {
            return;
         }
         if(param1.hasOwnProperty("weapon"))
         {
            GF.removeAllChild(param1.weapon);
         }
         if(param1.hasOwnProperty("back"))
         {
            GF.removeAllChild(param1.back);
         }
         if(param1.hasOwnProperty("skirt"))
         {
            GF.removeAllChild(param1.skirt);
         }
         if(param1.hasOwnProperty("head"))
         {
            if(param1["head"].hasOwnProperty("hair"))
            {
               GF.removeAllChild(param1.head.hair);
            }
            if(param1["head"].hasOwnProperty("face"))
            {
               GF.removeAllChild(param1.head.face);
            }
         }
         if(param1.hasOwnProperty("back_hair"))
         {
            GF.removeAllChild(param1.back_hair);
         }
      }
      
      public function destroy() : *
      {
         this.main.HUD.setBasicData();
         this.main.HUD.loadFrame();
         var _loc1_:* = 0;
         while(_loc1_ < 10)
         {
            GF.removeAllChild(this["item_" + _loc1_].iconMc.iconHolder);
            this["item_" + _loc1_].clickmask.tooltip = null;
            this["item_" + _loc1_].btn_use.metaData = {};
            this["item_" + _loc1_].btn_equip.metaData = {};
            this["item_" + _loc1_].btn_sell.metaData = {};
            this["item_" + _loc1_].btn_addFavorite.metaData = {};
            this["item_" + _loc1_].btn_removeFavorite.metaData = {};
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.tabButton.length)
         {
            this[this.tabButton[_loc1_]].buttonMode = false;
            _loc1_++;
         }
         GF.removeAllChild(this.tempWeaponMC);
         GF.removeAllChild(this.tempBackItemMC);
         GF.removeAllChild(this.tempHairMC);
         GF.removeAllChild(this.tempBackHairMC);
         GF.removeAllChild(this.tempSetMC);
         GF.removeAllChild(this.tempSkirtMC);
         _loc1_ = 0;
         while(_loc1_ < this.tempSetArray.length)
         {
            GF.removeAllChild(this.tempSetArray[_loc1_]);
            _loc1_++;
         }
         GF.destroyArray(this.outfits);
         this.colorMC1.resetColor.buttonMode = false;
         this.firstLoad = true;
         this.main.clearEvents();
         this.eventHandler.removeAllEventListeners();
         this.escapeKey.destroy();
         this.resetIconHolder();
         this.tooltip.destroy();
         this.loaderSwf.clear();
         NinjaSage.clearLoader();
         OutfitManager.clearStaticMc();
         BulkLoader.getLoader("assets").removeAll();
         this.weaponArray = [];
         this.backArray = [];
         this.accArray = [];
         this.setArray = [];
         this.hairArray = [];
         this.materialArray = [];
         this.essentialArray = [];
         this.consumableArray = [];
         this.favoriteArray = [];
         this.selectedCategory = [];
         this.outfits = [];
         this.itemEquipMC = [];
         this.backHairMC = [];
         this.skirtMC = [];
         this.tempSetArray = [];
         this.iconMCArray = [];
         this.currentPage = 1;
         this.totalPage = 1;
         this.sellQuantity = 1;
         this.sellMaxQuantity = 1;
         this.presetTarget = 0;
         this.preset_total_page = 0;
         this.preset_curr_page = 1;
         this.tempWeaponMC = null;
         this.tempBackItemMC = null;
         this.tempHairMC = null;
         this.tempBackHairMC = null;
         this.tempSetMC = null;
         this.tempSkirtMC = null;
         this.sellPanel = null;
         this.confirmation = null;
         this.selectedSellItem = null;
         this.selectedHairColor = null;
         this.selectedSkinColor = null;
         this.selectedHairMC = null;
         this.selectedBackHairMC = null;
         this.selectedSkirtMC = null;
         this.selectedSetMC = null;
         this.loaderSwf = null;
         this.tabIndicator = null;
         this.equippedItem = null;
         this.color = null;
         this.eventHandler = null;
         this.escapeKey = null;
         this.tooltip = null;
         this.main = null;
         this.removeCharMCItems(this.char_mc);
         GF.removeAllChild(this.char_mc);
         GF.removeAllChild(this);
         System.gc();
      }
   }
}

