package Panels
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Storage.Character;
   import Storage.ItemDropSourceMapping;
   import Storage.Library;
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
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3676")]
   public dynamic class Encyclopedia_Items extends MovieClip
   {
      
      public var panelMC:MovieClip;
      
      public var txt_title:TextField;
      
      private var escapeKey:EscapeKeyManager;
      
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
      
      public var mcItems:MovieClip;
      
      public var mcMaterials:MovieClip;
      
      public var mcSet:MovieClip;
      
      public var mcWeapon:MovieClip;
      
      public var presetMC:MovieClip;
      
      public var sellTxt:TextField;
      
      public var txt_goToPage:TextField;
      
      public var txt_page:TextField;
      
      public var txt_search:TextField;
      
      public var weaponArray:Array = Library.getItemIds("wpn");
      
      public var backArray:Array = Library.getItemIds("back");
      
      public var accArray:Array = Library.getItemIds("accessory");
      
      public var setArray:Array = Library.getItemIds("set",Character.character_gender);
      
      public var hairArray:Array = Library.getItemIds("hair",Character.character_gender);
      
      public var materialArray:Array = Library.getItemIds("item").concat(Library.getItemIds("material"));
      
      public var essentialArray:Array = [];
      
      public var consumableArray:Array = [];
      
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
      
      public var tabIndicator:String = "weapon";
      
      public var equippedItem:String;
      
      public var usableItem:String;
      
      public var selectedHairColor:String;
      
      public var selectedSkinColor:String;
      
      public var selectedSellItem:Object;
      
      public var selectedHairMC:MovieClip;
      
      public var selectedBackHairMC:MovieClip;
      
      public var selectedSkirtMC:MovieClip;
      
      public var selectedSetMC:Array = [];
      
      public var color:Color;
      
      public var isLoading:Boolean;
      
      public var firstLoad:Boolean = true;
      
      public var tempWeaponMC:MovieClip;
      
      public var tempBackItemMC:MovieClip;
      
      public var tempHairMC:MovieClip;
      
      public var tempBackHairMC:MovieClip;
      
      public var tempSetMC:MovieClip;
      
      public var tempSetArray:Array = [];
      
      public var tempSkirtMC:MovieClip;
      
      public var isDescription:Boolean = false;
      
      public var eventHandler:*;
      
      public var tooltip:*;
      
      public var main:*;
      
      public var loaderSwf:* = BulkLoader.createUniqueNamedLoader(10);
      
      public var tabButton:Array = ["mcWeapon","mcHairstyle","mcSet","mcBackItem","mcAccessory","mcMaterials","mcEssentials"];
      
      public var bodyArray:Array = ["upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe"];
      
      public function Encyclopedia_Items(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.tooltip = ToolTip.getInstance();
         this.eventHandler = new EventHandler();
         this.color = new Color();
         this.initButton();
         this.initUI();
      }
      
      public function initButton() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.tabButton.length)
         {
            this.panelMC[this.tabButton[_loc1_]].gotoAndStop(1);
            this.panelMC[this.tabButton[_loc1_]].buttonMode = true;
            this.eventHandler.addListener(this.panelMC[this.tabButton[_loc1_]],MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(this.panelMC[this.tabButton[_loc1_]],MouseEvent.MOUSE_OVER,this.hoverOver);
            this.eventHandler.addListener(this.panelMC[this.tabButton[_loc1_]],MouseEvent.MOUSE_OUT,this.hoverOut);
            _loc1_++;
         }
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_to_page,MouseEvent.CLICK,this.goToPage);
         this.eventHandler.addListener(this.panelMC.btn_search,MouseEvent.CLICK,this.searchItem);
         this.eventHandler.addListener(this.panelMC.btn_clearSearch,MouseEvent.CLICK,this.clearSearch);
         this.eventHandler.addListener(this.panelMC.btn_filter,MouseEvent.CLICK,this.handleSearchFilter);
         NinjaSage.showDynamicTooltip(this.panelMC.btn_filter.filter_on,"Search by description");
         NinjaSage.showDynamicTooltip(this.panelMC.btn_filter.filter_off,"Search by name");
      }
      
      public function initUI() : *
      {
         var _loc1_:* = undefined;
         if(!Character.is_stickman)
         {
            _loc1_ = new OutfitManager();
            _loc1_.fillOutfit(this.panelMC.char_mc,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
            this.outfits.push(_loc1_);
         }
         this.panelMC.txt_goToPage.restrict = "0-9";
         this.panelMC.char_name.text = Character.character_name;
         this.selectedHairColor = Character.character_color_hair;
         this.selectedSkinColor = Character.character_color_skin;
         this.panelMC.btn_filter.filter_on.visible = false;
         this.panelMC.mcWeapon.gotoAndStop(3);
         this.tabIndicator = "weapon";
         this.selectedCategory = this.weaponArray;
         this.equippedItem = Character.character_weapon;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 12),1);
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
         if(this.firstLoad)
         {
            this.main.loading(false);
            this.firstLoad = false;
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
         var itemId:*;
         var itemQty:*;
         var getItemInfo:*;
         var backHairIcon:MovieClip = null;
         var loadedSet:Array = null;
         var i:* = undefined;
         var skirtIcon:MovieClip = null;
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
         this.panelMC["item_" + this.itemCount].iconMc.iconHolder.addChild(itemMC);
         this.panelMC["item_" + this.itemCount].gotoAndStop(1);
         this.panelMC["item_" + this.itemCount].visible = true;
         if(this.tabIndicator == "weapon")
         {
            itemMC = e.target.content.weapon;
            if(!Character.play_items_animation)
            {
               itemMC.stopAllMovieClips();
            }
            this.itemEquipMC.push(itemMC);
         }
         else if(this.tabIndicator == "back")
         {
            itemMC = e.target.content.back_item;
            if(!Character.play_items_animation)
            {
               itemMC.stopAllMovieClips();
            }
            this.itemEquipMC.push(itemMC);
         }
         else if(this.tabIndicator == "hair")
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
         else if(this.tabIndicator == "set")
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
         this.panelMC["item_" + this.itemCount].lvlTxt.text = getItemInfo.item_level;
         if(getItemInfo.item_premium)
         {
            this.panelMC["item_" + this.itemCount].emblemMC.visible = true;
         }
         this.panelMC["item_" + this.itemCount].clickMask.tooltip = getItemInfo;
         this.panelMC["item_" + this.itemCount].clickMask.item_type = itemId.split("_")[0];
         this.panelMC["item_" + this.itemCount].clickMask.metaData = {"id":itemId};
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickMask,MouseEvent.MOUSE_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickMask,MouseEvent.MOUSE_OUT,this.toolTiponOut);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickMask,MouseEvent.CLICK,this.loadItem);
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      public function loadItem(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.metaData.id;
         var _loc3_:String = "items/" + _loc2_ + ".swf";
         var _loc4_:* = this.loaderSwf.add(_loc3_);
         _loc4_.addEventListener(BulkLoader.COMPLETE,this.previewItem);
         this.loaderSwf.start();
      }
      
      public function previewItem(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.tabIndicator == "weapon")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc["weapon"]);
            if(this.tempWeaponMC != null)
            {
               this.tempWeaponMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempWeaponMC);
            this.tempWeaponMC = null;
            this.tempWeaponMC = param1.target.content.weapon;
            this.panelMC.char_mc["weapon"].addChild(this.tempWeaponMC);
         }
         else if(this.tabIndicator == "back")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
            if(this.tempBackItemMC != null)
            {
               this.tempBackItemMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempBackItemMC);
            this.tempBackItemMC = null;
            this.tempBackItemMC = param1.target.content.back_item;
            this.panelMC.char_mc["back"].addChild(this.tempBackItemMC);
         }
         else if(this.tabIndicator == "hair")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
            if(this.tempHairMC != null)
            {
               this.tempHairMC.stopAllMovieClips();
            }
            GF.removeAllChild(this.tempHairMC);
            this.tempHairMC = null;
            this.tempHairMC = param1.target.content.hair;
            this.selectedHairMC = this.tempHairMC;
            this.addHairColor(this.tempHairMC);
            this.panelMC.char_mc.head["hair"].addChild(this.tempHairMC);
            try
            {
               this.removeChildsFromMovieClip(this.panelMC.char_mc["back_hair"]);
               if(this.tempBackHairMC != null)
               {
                  this.tempBackHairMC.stopAllMovieClips();
               }
               GF.removeAllChild(this.tempBackHairMC);
               this.tempBackHairMC = null;
               this.tempBackHairMC = param1.target.content.back_hair;
               this.selectedBackHairMC = this.tempBackHairMC;
               this.addHairColor(this.tempBackHairMC);
               this.panelMC.char_mc["back_hair"].addChild(this.tempBackHairMC);
            }
            catch(error:Error)
            {
            }
         }
         else if(this.tabIndicator == "set")
         {
            _loc2_ = 0;
            while(_loc2_ < this.selectedSetMC.length)
            {
               if(this.selectedSetMC[_loc2_] != null)
               {
                  this.selectedSetMC[_loc2_].stopAllMovieClips();
               }
               GF.removeAllChild(this.selectedSetMC[_loc2_]);
               _loc2_++;
            }
            this.selectedSetMC = [];
            _loc2_ = 0;
            while(_loc2_ < this.tempSetArray.length)
            {
               if(this.tempSetArray[_loc2_] != null)
               {
                  this.tempSetArray[_loc2_].stopAllMovieClips();
               }
               GF.removeAllChild(this.tempSetArray[_loc2_]);
               _loc2_++;
            }
            this.tempSetArray = [];
            _loc2_ = 0;
            while(_loc2_ < this.bodyArray.length)
            {
               this.tempSetMC = param1.target.content[this.bodyArray[_loc2_]];
               this.tempSetArray.push(this.tempSetMC);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.bodyArray.length)
            {
               this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_loc2_]]);
               this.selectedSetMC.push(this.tempSetArray[_loc2_]);
               this.addSkinColor(this.tempSetArray[_loc2_]);
               this.panelMC.char_mc[this.bodyArray[_loc2_]].addChild(this.tempSetArray[_loc2_]);
               _loc2_++;
            }
            try
            {
               this.removeChildsFromMovieClip(this.panelMC.char_mc["skirt"]);
               if(this.tempSkirtMC != null)
               {
                  this.tempSkirtMC.stopAllMovieClips();
               }
               GF.removeAllChild(this.tempSkirtMC);
               this.tempSkirtMC = null;
               this.tempSkirtMC = param1.target.content.skirt;
               this.selectedSkirtMC = this.tempSkirtMC;
               this.panelMC.char_mc["skirt"].addChild(this.tempSkirtMC);
            }
            catch(error:Error)
            {
            }
         }
      }
      
      public function handleSearchFilter(param1:MouseEvent) : *
      {
         this.panelMC.btn_filter.filter_on.visible = !this.panelMC.btn_filter.filter_on.visible;
         this.isDescription = this.panelMC.btn_filter.filter_on.visible ? true : false;
      }
      
      public function searchItem(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc7_:String = null;
         if(this.panelMC.txt_search.text == "")
         {
            return;
         }
         this.setDefaultArray();
         var _loc2_:Array = [];
         var _loc3_:String = this.panelMC.txt_search.text.toLowerCase();
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
         this.selectedCategory = _loc2_;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 12),1);
         this.currentPage = 1;
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function clearSearch(param1:MouseEvent) : *
      {
         this.panelMC.txt_search.text = "";
         this.panelMC.txt_goToPage.text = "";
         this.currentPage = 1;
         this.setDefaultArray();
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 12),1);
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function goToPage(param1:MouseEvent) : *
      {
         if(this.panelMC.txt_goToPage.text == "")
         {
            return;
         }
         if(int(this.panelMC.txt_goToPage.text) > this.totalPage || int(this.panelMC.txt_goToPage.text) <= 0)
         {
            return;
         }
         this.currentPage = int(this.panelMC.txt_goToPage.text);
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function clearPreview(param1:MouseEvent) : *
      {
         this.removeChildsFromMovieClip(this.panelMC.char_mc["weapon"]);
         this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
         this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
         this.removeChildsFromMovieClip(this.panelMC.char_mc["back_hair"]);
         this.removeChildsFromMovieClip(this.panelMC.char_mc["skirt"]);
         var _loc2_:* = 0;
         while(_loc2_ < this.bodyArray.length)
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_loc2_]]);
            this.panelMC.char_mc[this.bodyArray[_loc2_]].addChild(OutfitManager.set_mc[_loc2_]);
            _loc2_++;
         }
         try
         {
            this.panelMC.char_mc["weapon"].addChild(OutfitManager.weapon_mc[0]);
            this.panelMC.char_mc.head["hair"].addChild(OutfitManager.hair_mc[0]);
            this.panelMC.char_mc["back_hair"].addChild(OutfitManager.hair_mc[1]);
            this.panelMC.char_mc["skirt"].addChild(OutfitManager.set_mc[14]);
            this.panelMC.char_mc["back"].addChild(OutfitManager.back_mc[0]);
         }
         catch(error:Error)
         {
         }
      }
      
      public function unEquipItem(param1:MouseEvent) : *
      {
         if(this.tabIndicator == "accessories")
         {
            Character.character_accessory = "accessory_00";
            this.equippedItem = "accessory_00";
         }
         else if(this.tabIndicator == "back")
         {
            Character.character_back_item = "back_00";
            this.equippedItem = "back_00";
            this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
            OutfitManager.back_mc = null;
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
            try
            {
               param1.hair_color_1.transform.colorTransform = _loc2_;
            }
            catch(error:Error)
            {
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
            this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_loc3_]]);
            if("skin_color" in this.selectedSetMC[_loc3_])
            {
               this.selectedSetMC[_loc3_].skin_color.transform.colorTransform = _loc2_;
            }
            this.panelMC.char_mc[this.bodyArray[_loc3_]].addChild(this.selectedSetMC[_loc3_]);
            _loc3_++;
         }
         this.removeChildsFromMovieClip(this.panelMC.char_mc.head.face);
         OutfitManager.face_mc[0].skin_color.transform.colorTransform = _loc2_;
         this.panelMC.char_mc.head.face.addChild(OutfitManager.face_mc[0]);
      }
      
      public function colorChangeHandler1(param1:ColorPickerEvent) : *
      {
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedHairColor.split("|");
         this.selectedHairColor = _loc2_ + "|" + _loc3_[1];
         Character.character_color_hair = this.selectedHairColor;
         this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
         this.addHairColor(this.selectedHairMC);
         this.panelMC.char_mc.head["hair"].addChild(this.selectedHairMC);
      }
      
      public function colorChangeHandler2(param1:ColorPickerEvent) : *
      {
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedHairColor.split("|");
         this.selectedHairColor = _loc3_[0] + "|" + _loc2_;
         Character.character_color_hair = this.selectedHairColor;
         this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
         this.addHairColor(this.selectedHairMC);
         this.panelMC.char_mc.head["hair"].addChild(this.selectedHairMC);
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
            this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_loc4_]]);
            this.addSkinColor(this.selectedSetMC[_loc4_]);
            this.panelMC.char_mc[this.bodyArray[_loc4_]].addChild(this.selectedSetMC[_loc4_]);
            _loc4_++;
         }
      }
      
      public function colorChangeHandler4(param1:ColorPickerEvent) : *
      {
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedSkinColor.split("|");
         this.selectedSkinColor = _loc3_[0] + "|" + _loc2_;
         Character.character_color_skin = this.selectedSkinColor;
         this.removeChildsFromMovieClip(this.panelMC.char_mc.head.face);
         this.addFaceColor(OutfitManager.face_mc[0]);
         this.panelMC.char_mc.head.face.addChild(OutfitManager.face_mc[0]);
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
         this.panelMC.txt_page.text = this.currentPage + "/" + this.totalPage;
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
            this.panelMC[this.tabButton[_loc2_]].gotoAndStop(1);
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
               this.tabIndicator = "accessories";
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
            case "mcColor":
         }
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 12),1);
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function setDefaultArray() : *
      {
         if(this.tabIndicator == "weapon")
         {
            this.weaponArray = Library.getItemIds("wpn");
            this.selectedCategory = this.weaponArray;
         }
         else if(this.tabIndicator == "set")
         {
            this.setArray = Library.getItemIds("set",Character.character_gender);
            this.selectedCategory = this.setArray;
         }
         else if(this.tabIndicator == "back")
         {
            this.backArray = Library.getItemIds("back");
            this.selectedCategory = this.backArray;
         }
         else if(this.tabIndicator == "accessories")
         {
            this.accArray = Library.getItemIds("accessory");
            this.selectedCategory = this.accArray;
         }
         else if(this.tabIndicator == "hair")
         {
            this.hairArray = Library.getItemIds("hair",Character.character_gender);
            this.selectedCategory = this.hairArray;
         }
         else if(this.tabIndicator == "material")
         {
            this.materialArray = Library.getItemIds("item").concat(Library.getItemIds("material"));
            this.selectedCategory = this.materialArray;
         }
         else if(this.tabIndicator == "essential")
         {
            this.essentialArray = [];
            this.selectedCategory = this.essentialArray;
         }
         else if(this.tabIndicator == "consumable")
         {
            this.consumableArray = [];
            this.selectedCategory = this.consumableArray;
         }
      }
      
      public function resetRecursiveProperty() : *
      {
         this.itemLoading = this.currentPage * 12;
         if(this.selectedCategory.length < this.itemLoading)
         {
            this.itemLoading = this.selectedCategory.length;
         }
         this.itemIndex = (this.currentPage - 1) * 12;
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
         while(_loc1_ < 12)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].iconMc.iconHolder);
            this.panelMC["item_" + _loc1_].transform.colorTransform = this.color;
            this.panelMC["item_" + _loc1_].gotoAndStop(1);
            this.panelMC["item_" + _loc1_].visible = false;
            this.panelMC["item_" + _loc1_].lockMc.visible = false;
            this.panelMC["item_" + _loc1_].emblemMC.visible = false;
            this.panelMC["item_" + _loc1_].amtTxt.visible = false;
            delete this.panelMC["item_" + _loc1_].clickMask.tooltip;
            delete this.panelMC["item_" + _loc1_].clickMask.tooltipCache;
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickMask,MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickMask,MouseEvent.MOUSE_OUT,this.toolTiponOut);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickMask,MouseEvent.CLICK,this.loadItem);
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
         var formatDesc:Function;
         var tooltipData:Object = null;
         var itemSource:Array = null;
         var skillSource:Array = null;
         var desc:String = null;
         var itemType:String = null;
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
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(mc.tooltipCache);
      }
      
      public function toolTiponOut(param1:MouseEvent) : *
      {
         param1.currentTarget.parent.gotoAndStop(1);
         this.tooltip.hide();
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
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
         var _loc1_:int = 0;
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         _loc1_ = 0;
         while(_loc1_ < 12)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].iconMc.iconHolder);
            delete this.panelMC["item_" + _loc1_].clickMask.tooltip;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.tabButton.length)
         {
            this.panelMC[this.tabButton[_loc1_]].buttonMode = false;
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
         this.resetIconHolder();
         this.firstLoad = true;
         NinjaSage.clearLoader();
         OutfitManager.clearStaticMc();
         BulkLoader.getLoader("assets").removeAll();
         this.eventHandler.removeAllEventListeners();
         this.tooltip.destroy();
         this.loaderSwf.clear();
         this.weaponArray = [];
         this.backArray = [];
         this.accArray = [];
         this.setArray = [];
         this.hairArray = [];
         this.materialArray = [];
         this.essentialArray = [];
         this.consumableArray = [];
         this.selectedCategory = [];
         this.outfits = [];
         this.itemEquipMC = [];
         this.backHairMC = [];
         this.skirtMC = [];
         this.tempSetArray = [];
         this.iconMCArray = [];
         this.currentPage = 1;
         this.totalPage = 1;
         this.tempWeaponMC = null;
         this.tempBackItemMC = null;
         this.tempHairMC = null;
         this.tempBackHairMC = null;
         this.tempSetMC = null;
         this.tempSkirtMC = null;
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
         this.tooltip = null;
         this.main = null;
         this.removeCharMCItems(this.panelMC.char_mc);
         GF.removeAllChild(this.panelMC.char_mc);
         GF.removeAllChild(this);
         System.gc();
      }
   }
}

