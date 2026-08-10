package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Storage.Character;
   import Storage.ItemDropSourceMapping;
   import Storage.Library;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
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
   
   public dynamic class Wardrobe extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var btn_clear:SimpleButton;
      
      public var btn_clearSearch:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_preset:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_search:SimpleButton;
      
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
      
      public var txt_goToPage:TextField;
      
      public var txt_page:TextField;
      
      public var txt_search:TextField;
      
      public var weaponArray:Array = this.sortItems(Character.character_weapons.split(","));
      
      public var backArray:Array = this.sortItems(Character.character_back_items.split(","));
      
      public var accArray:Array = this.sortItems(Character.character_accessories.split(","));
      
      public var setArray:Array = this.sortItems(Character.character_sets.split(","));
      
      public var hairArray:Array = this.sortItems(Character.character_hairs.split(","));
      
      public var materialArray:Array;
      
      public var essentialArray:Array;
      
      public var consumableArray:Array;
      
      public var selectedCategory:Array;
      
      public var presets:Array;
      
      public var outfits:Array = [];
      
      public var itemEquipMC:Array = [];
      
      public var backHairMC:Array = [];
      
      public var skirtMC:Array = [];
      
      public var currentPage:int = 1;
      
      public var totalPage:int = 1;
      
      public var itemIndex:int = 0;
      
      public var itemLoading:int = 0;
      
      public var itemCount:int = 0;
      
      public var presetTarget:int;
      
      public var preset_total_page:int = 0;
      
      public var preset_curr_page:int = 1;
      
      public var tabIndicator:String = "weapon";
      
      public var equippedItem:String;
      
      public var usableItem:String;
      
      public var selectedHairColor:String;
      
      public var selectedSkinColor:String;
      
      public var selectedHairMC:MovieClip;
      
      public var selectedBackHairMC:MovieClip;
      
      public var selectedSetMC:Array;
      
      public var color:*;
      
      public var isLoading:Boolean;
      
      public var firstLoad:Boolean = true;
      
      public var eventHandler:*;
      
      public var tooltip:*;
      
      public var main:*;
      
      public var loaderSwf:* = BulkLoader.createUniqueNamedLoader(10);
      
      public var confirmation:*;
      
      public var character:*;
      
      public var preset_selection_parent:*;
      
      public var savedWithButton:String;
      
      public var tabButton:Array = ["mcHairstyle","mcSet","mcBackItem","mcWeapon","mcAccessory","mcPet"];
      
      public var bodyArray:Array = ["upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe"];
      
      public var selected_class:String;
      
      public var skill_inventoryMC:*;
      
      public var pet_inventoryMC:*;
      
      public function Wardrobe(param1:*, param2:*, param3:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.preset_selection_parent = param3;
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
            _loc1_++;
         }
         if(PresetData.preset_id_used == PresetData.preset_id_edit)
         {
            this.panelMC.btn_use.visible = false;
         }
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_to_page,MouseEvent.CLICK,this.goToPage);
         this.eventHandler.addListener(this.panelMC.btn_search,MouseEvent.CLICK,this.searchItem);
         this.eventHandler.addListener(this.panelMC.btn_clearSearch,MouseEvent.CLICK,this.clearSearch);
         this.eventHandler.addListener(this.panelMC.btn_skill,MouseEvent.CLICK,this.openSkillInventory);
         this.eventHandler.addListener(this.panelMC.btn_save,MouseEvent.CLICK,this.savePreset);
         this.eventHandler.addListener(this.panelMC.btn_use,MouseEvent.CLICK,this.usePreset);
      }
      
      public function openSkillInventory(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = this.preset_selection_parent.skillMC;
         var _loc3_:Class = getDefinitionByName("id.ninjasage.features.SkillInventory") as Class;
         this.skill_inventoryMC = new _loc3_(this.main,_loc2_,this);
         _loc2_.visible = true;
      }
      
      public function initUI() : *
      {
         var _loc1_:* = undefined;
         if(!Character.is_stickman)
         {
            _loc1_ = new OutfitManager();
            _loc1_.fillOutfit(this.panelMC.char_mc,PresetData.preset_wpn,PresetData.preset_back,PresetData.preset_set,PresetData.preset_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
            this.outfits.push(_loc1_);
         }
         this.panelMC.txt_goToPage.restrict = "0-9";
         this.panelMC.txt_title.text = Character.character_name + "\'s Wardrobe";
         this.panelMC.txt_presetName.text = PresetData.selected_preset_name;
         this.selectedHairColor = Character.character_color_hair;
         this.selectedSkinColor = Character.character_color_skin;
         this.tabIndicator = "hair";
         this.selectedCategory = this.hairArray;
         this.equippedItem = PresetData.preset_hair;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 9),1);
         this.loadTabIconSwf();
         this.loadPetIconAndBody();
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
      }
      
      public function loadTabIconSwf(param1:int = 100000000) : *
      {
         var _loc3_:int = 0;
         var _loc2_:Array = [PresetData.preset_hair,PresetData.preset_set,PresetData.preset_back,PresetData.preset_wpn,PresetData.preset_acc];
         if(param1 > 4)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               NinjaSage.loadItemIcon(this.panelMC[this.tabButton[_loc3_]],_loc2_[_loc3_]);
               _loc3_++;
            }
         }
         else
         {
            NinjaSage.loadItemIcon(this.panelMC[this.tabButton[param1]],_loc2_[param1]);
         }
      }
      
      public function loadPetIconAndBody() : *
      {
         GF.removeAllChild(this.panelMC.pet_mc);
         GF.removeAllChild(this.panelMC.mcPet.rewardIcon.iconHolder);
         if(PresetData.preset_pet == "" || PresetData.preset_pet_id == 0)
         {
            return;
         }
         NinjaSage.loadItemIcon(this.panelMC.mcPet,PresetData.preset_pet);
         this.panelMC.pet_mc.scaleX = 1.4;
         this.panelMC.pet_mc.scaleY = 1.4;
         NinjaSage.loadIconSWF("pets",PresetData.preset_pet,this.panelMC.pet_mc,PresetData.preset_pet);
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
         var _loc8_:Array = null;
         var _loc9_:* = undefined;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onItemLoadError);
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         _loc4_ = param1.target.content["icon"];
         if(!Character.play_items_animation)
         {
            _loc4_.stopAllMovieClips();
         }
         this.panelMC["item_" + this.itemCount].iconMc.iconHolder.addChild(_loc4_);
         this.panelMC["item_" + this.itemCount].gotoAndStop(1);
         this.panelMC["item_" + this.itemCount].visible = true;
         if(this.tabIndicator == "weapon")
         {
            _loc4_ = param1.target.content["weapon"];
            if(!Character.play_items_animation)
            {
               _loc4_.stopAllMovieClips();
            }
            this.itemEquipMC.push(_loc4_);
         }
         else if(this.tabIndicator == "back")
         {
            _loc4_ = param1.target.content["back_item"];
            if(!Character.play_items_animation)
            {
               _loc4_.stopAllMovieClips();
            }
            this.itemEquipMC.push(_loc4_);
         }
         else if(this.tabIndicator == "hair")
         {
            _loc4_ = param1.target.content["hair"];
            if(!Character.play_items_animation)
            {
               _loc4_.stopAllMovieClips();
            }
            this.itemEquipMC.push(_loc4_);
            try
            {
               _loc4_ = param1.target.content["back_hair"];
               if(!Character.play_items_animation)
               {
                  _loc4_.stopAllMovieClips();
               }
               this.backHairMC.push(_loc4_);
            }
            catch(error:*)
            {
            }
         }
         else if(this.tabIndicator == "set")
         {
            _loc8_ = [];
            _loc9_ = 0;
            while(_loc9_ < this.bodyArray.length)
            {
               _loc4_ = param1.target.content[this.bodyArray[_loc9_]];
               if(!Character.play_items_animation)
               {
                  _loc4_.stopAllMovieClips();
               }
               _loc8_.push(_loc4_);
               _loc9_++;
            }
            try
            {
               _loc4_ = param1.target.content["skirt"];
               if(!Character.play_items_animation)
               {
                  _loc4_.stopAllMovieClips();
               }
               this.skirtMC.push(_loc4_);
            }
            catch(error:*)
            {
            }
            this.itemEquipMC.push(_loc8_);
         }
         var _loc5_:* = this.selectedCategory[this.itemIndex].split(":")[0];
         var _loc6_:* = this.selectedCategory[this.itemIndex].split(":")[1];
         var _loc7_:* = Library.getItemInfo(_loc5_);
         this.panelMC["item_" + this.itemCount].lvlTxt.text = _loc7_.item_level;
         if(_loc6_ != undefined)
         {
            this.panelMC["item_" + this.itemCount].amtTxt.visible = true;
            this.panelMC["item_" + this.itemCount].amtTxt.text = "x" + _loc6_;
         }
         else
         {
            this.panelMC["item_" + this.itemCount].amtTxt.visible = false;
            _loc6_ = 1;
         }
         if(_loc7_.item_premium)
         {
            this.panelMC["item_" + this.itemCount].emblemMC.visible = true;
         }
         if(_loc7_.item_level <= int(Character.character_lvl))
         {
            this.color.brightness = 0;
            this.panelMC["item_" + this.itemCount].transform.colorTransform = this.color;
            this.panelMC["item_" + this.itemCount].btn_equip.visible = true;
            this.panelMC["item_" + this.itemCount].lockMc.visible = false;
         }
         this.panelMC["item_" + this.itemCount].btn_sell.visible = false;
         if(_loc5_ == this.equippedItem)
         {
            this.panelMC["item_0"]["txt_equipped"].visible = true;
            this.panelMC["item_0"]["btn_equip"].visible = false;
         }
         this.panelMC["item_" + this.itemCount].clickmask.tooltip = _loc7_;
         this.panelMC["item_" + this.itemCount].clickmask.item_type = _loc5_.split("_")[0];
         this.panelMC["item_" + this.itemCount].btn_equip.metaData = {"equip_item":_loc7_["item_id"]};
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickmask,MouseEvent.MOUSE_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickmask,MouseEvent.MOUSE_OUT,this.toolTiponOut);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickmask,MouseEvent.CLICK,this.previewItem);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].btn_equip,MouseEvent.CLICK,this.equipItem);
         if(_loc7_.item_id.indexOf("material") >= 0 || _loc7_.item_id.indexOf("essential") >= 0 || _loc7_.item_id.indexOf("item") >= 0)
         {
            this.eventHandler.removeListener(this.panelMC["item_" + this.itemCount].clickmask,MouseEvent.CLICK,this.previewItem);
            this.eventHandler.removeListener(this.panelMC["item_" + this.itemCount].btn_equip,MouseEvent.CLICK,this.equipItem);
         }
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      public function previewItem(param1:MouseEvent) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:int = int(param1.currentTarget.parent.name.replace("item_",""));
         if(this.tabIndicator == "weapon")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc["weapon"]);
            this.panelMC.char_mc["weapon"].addChild(this.itemEquipMC[_loc2_]);
         }
         else if(this.tabIndicator == "back")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
            this.panelMC.char_mc["back"].addChild(this.itemEquipMC[_loc2_]);
         }
         else if(this.tabIndicator == "hair")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
            this.selectedHairMC = this.itemEquipMC[_loc2_];
            this.addHairColor(this.itemEquipMC[_loc2_]);
            this.panelMC.char_mc.head["hair"].addChild(this.itemEquipMC[_loc2_]);
            try
            {
               this.removeChildsFromMovieClip(this.panelMC.char_mc["back_hair"]);
               this.selectedBackHairMC = this.backHairMC[_loc2_];
               this.addHairColor(this.backHairMC[_loc2_]);
               this.panelMC.char_mc["back_hair"].addChild(this.backHairMC[_loc2_]);
            }
            catch(error:Error)
            {
            }
         }
         else if(this.tabIndicator == "set")
         {
            this.selectedSetMC = [];
            _loc3_ = 0;
            while(_loc3_ < this.bodyArray.length)
            {
               this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_loc3_]]);
               this.selectedSetMC.push(this.itemEquipMC[_loc2_][_loc3_]);
               this.addSkinColor(this.itemEquipMC[_loc2_][_loc3_]);
               this.panelMC.char_mc[this.bodyArray[_loc3_]].addChild(this.itemEquipMC[_loc2_][_loc3_]);
               try
               {
                  this.removeChildsFromMovieClip(this.panelMC.char_mc["skirt"]);
                  this.panelMC.char_mc["skirt"].addChild(this.skirtMC[_loc2_]);
               }
               catch(error:Error)
               {
               }
               _loc3_++;
            }
         }
      }
      
      public function equipItem(param1:MouseEvent) : *
      {
         var _loc5_:* = undefined;
         var _loc2_:* = param1.currentTarget.metaData.equip_item;
         var _loc3_:* = _loc2_.split("_")[0];
         var _loc4_:int = int(param1.currentTarget.parent.name.replace("item_",""));
         if(_loc3_ == "wpn")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc["weapon"]);
            PresetData.preset_wpn = _loc2_;
            this.equippedItem = _loc2_;
            this.panelMC.char_mc["weapon"].addChild(this.itemEquipMC[_loc4_]);
            OutfitManager.weapon_mc[0] = this.itemEquipMC[_loc4_];
            this.loadTabIconSwf(3);
            this.setDefaultArray();
         }
         else if(_loc3_ == "back")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
            PresetData.preset_back = _loc2_;
            this.equippedItem = _loc2_;
            this.panelMC.char_mc["back"].addChild(this.itemEquipMC[_loc4_]);
            OutfitManager.back_mc[0] = this.itemEquipMC[_loc4_];
            this.loadTabIconSwf(2);
            this.setDefaultArray();
         }
         else if(_loc3_ == "hair")
         {
            this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
            this.selectedHairMC = this.itemEquipMC[_loc4_];
            this.addHairColor(this.itemEquipMC[_loc4_]);
            PresetData.preset_hair = _loc2_;
            this.equippedItem = _loc2_;
            this.panelMC.char_mc.head["hair"].addChild(this.itemEquipMC[_loc4_]);
            OutfitManager.hair_mc[0] = this.itemEquipMC[_loc4_];
            try
            {
               this.removeChildsFromMovieClip(this.panelMC.char_mc["back_hair"]);
               this.selectedBackHairMC = this.backHairMC[_loc4_];
               this.addHairColor(this.backHairMC[_loc4_]);
               this.panelMC.char_mc["back_hair"].addChild(this.backHairMC[_loc4_]);
               OutfitManager.hair_mc[1] = this.backHairMC[_loc4_];
            }
            catch(error:Error)
            {
            }
            this.loadTabIconSwf(0);
            this.setDefaultArray();
         }
         else if(_loc3_ == "accessory")
         {
            PresetData.preset_acc = _loc2_;
            this.equippedItem = _loc2_;
            this.loadTabIconSwf(4);
            this.setDefaultArray();
         }
         else if(_loc3_ == "set")
         {
            this.selectedSetMC = [];
            _loc5_ = 0;
            while(_loc5_ < this.bodyArray.length)
            {
               this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_loc5_]]);
               this.selectedSetMC.push(this.itemEquipMC[_loc4_][_loc5_]);
               this.addSkinColor(this.itemEquipMC[_loc4_][_loc5_]);
               this.panelMC.char_mc[this.bodyArray[_loc5_]].addChild(this.itemEquipMC[_loc4_][_loc5_]);
               OutfitManager.set_mc[_loc5_] = this.itemEquipMC[_loc4_][_loc5_];
               try
               {
                  this.removeChildsFromMovieClip(this.panelMC.char_mc["skirt"]);
                  this.panelMC.char_mc["skirt"].addChild(this.skirtMC[_loc4_]);
                  OutfitManager.set_mc[14] = this.skirtMC[_loc4_];
               }
               catch(error:Error)
               {
               }
               _loc5_++;
            }
            PresetData.preset_set = _loc2_;
            this.equippedItem = _loc2_;
            this.loadTabIconSwf(1);
            this.setDefaultArray();
         }
         this.currentPage = 1;
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function searchItem(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
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
            if((Boolean(_loc4_)) && Boolean(_loc4_.hasOwnProperty("item_name")) && _loc4_["item_name"].toLowerCase().indexOf(_loc3_) >= 0)
            {
               _loc2_.push(this.selectedCategory[_loc6_]);
            }
            _loc6_++;
         }
         this.selectedCategory = this.sortItems(_loc2_);
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 9),1);
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
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 9),1);
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
            PresetData.preset_acc = "accessory_00";
            this.equippedItem = "accessory_00";
         }
         else if(this.tabIndicator == "back")
         {
            PresetData.preset_back = "back_00";
            this.equippedItem = "back_00";
            this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
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
      
      public function colorChangeHandler1(param1:*) : *
      {
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedHairColor.split("|");
         this.selectedHairColor = _loc2_ + "|" + _loc3_[1];
         Character.character_color_hair = this.selectedHairColor;
         this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
         this.addHairColor(this.selectedHairMC);
         this.panelMC.char_mc.head["hair"].addChild(this.selectedHairMC);
      }
      
      public function colorChangeHandler2(param1:*) : *
      {
         var _loc2_:* = uint("0x" + param1.target.hexValue);
         var _loc3_:* = this.selectedHairColor.split("|");
         this.selectedHairColor = _loc3_[0] + "|" + _loc2_;
         Character.character_color_hair = this.selectedHairColor;
         this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
         this.addHairColor(this.selectedHairMC);
         this.panelMC.char_mc.head["hair"].addChild(this.selectedHairMC);
      }
      
      public function colorChangeHandler3(param1:*) : *
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
      
      public function colorChangeHandler4(param1:*) : *
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
         if(this.loaderSwf.itemsLoaded >= 40)
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
         var _loc4_:MovieClip = null;
         var _loc5_:Class = null;
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
               this.equippedItem = PresetData.preset_wpn;
               break;
            case "mcSet":
               this.selectedCategory = this.setArray;
               this.tabIndicator = "set";
               this.equippedItem = PresetData.preset_set;
               break;
            case "mcBackItem":
               this.selectedCategory = this.backArray;
               this.tabIndicator = "back";
               this.equippedItem = PresetData.preset_back;
               break;
            case "mcAccessory":
               this.selectedCategory = this.accArray;
               this.tabIndicator = "accessories";
               this.equippedItem = PresetData.preset_acc;
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
               this.equippedItem = PresetData.preset_hair;
               break;
            case "mcItems":
               this.selectedCategory = this.consumableArray;
               this.tabIndicator = "consumable";
               break;
            case "mcColor":
               break;
            case "mcPet":
               _loc4_ = this.preset_selection_parent.petMC;
               _loc5_ = getDefinitionByName("id.ninjasage.features.PetInventory") as Class;
               this.pet_inventoryMC = new _loc5_(this.main,_loc4_,this);
               _loc4_.visible = true;
               return;
         }
         if(_loc3_ != "mcColor")
         {
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 9),1);
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
         }
      }
      
      public function setDefaultArray() : *
      {
         if(this.tabIndicator == "weapon")
         {
            this.weaponArray = this.sortItems(Character.character_weapons.split(","));
            this.selectedCategory = this.weaponArray;
         }
         else if(this.tabIndicator == "set")
         {
            this.setArray = this.sortItems(Character.character_sets.split(","));
            this.selectedCategory = this.setArray;
         }
         else if(this.tabIndicator == "back")
         {
            this.backArray = this.sortItems(Character.character_back_items.split(","));
            this.selectedCategory = this.backArray;
         }
         else if(this.tabIndicator == "accessories")
         {
            this.accArray = this.sortItems(Character.character_accessories.split(","));
            this.selectedCategory = this.accArray;
         }
         else if(this.tabIndicator == "hair")
         {
            this.hairArray = this.sortItems(Character.character_hairs.split(","));
            this.selectedCategory = this.hairArray;
         }
      }
      
      public function resetRecursiveProperty() : *
      {
         this.itemLoading = this.currentPage * 9;
         if(this.selectedCategory.length < this.itemLoading)
         {
            this.itemLoading = this.selectedCategory.length;
         }
         this.itemIndex = (this.currentPage - 1) * 9;
         this.itemCount = 0;
      }
      
      public function resetIconHolder() : *
      {
         this.itemEquipMC = [];
         this.backHairMC = [];
         this.skirtMC = [];
         var _loc1_:* = 0;
         while(_loc1_ < 9)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].iconMc.iconHolder);
            this.color.brightness = -0.3;
            this.panelMC["item_" + _loc1_].transform.colorTransform = this.color;
            this.panelMC["item_" + _loc1_].gotoAndStop(1);
            this.panelMC["item_" + _loc1_].visible = false;
            this.panelMC["item_" + _loc1_].btn_equip.visible = false;
            this.panelMC["item_" + _loc1_].btn_use.visible = false;
            this.panelMC["item_" + _loc1_].lockMc.visible = true;
            this.panelMC["item_" + _loc1_].emblemMC.visible = false;
            this.panelMC["item_" + _loc1_].amtTxt.visible = false;
            this.panelMC["item_" + _loc1_].txt_equipped.visible = false;
            this.panelMC["item_" + _loc1_].clickmask.tooltip = null;
            this.panelMC["item_" + _loc1_].btn_use.metaData = {};
            this.panelMC["item_" + _loc1_].btn_equip.metaData = {};
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickmask,MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickmask,MouseEvent.MOUSE_OUT,this.toolTiponOut);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickmask,MouseEvent.CLICK,this.previewItem);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].btn_equip,MouseEvent.CLICK,this.equipItem);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].btn_use,MouseEvent.CLICK,this.useItem);
            _loc1_++;
         }
      }
      
      public function removeChildsFromMovieClip(param1:MovieClip) : *
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
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
      
      public function toolTiponOver(param1:MouseEvent) : *
      {
         param1.currentTarget.parent.gotoAndStop(2);
         var _loc2_:String = "";
         var _loc3_:Object = param1.currentTarget.tooltip;
         var _loc4_:Array = Boolean(_loc3_) && _loc3_.hasOwnProperty("item_source") ? _loc3_.item_source : null;
         var _loc5_:Array = Boolean(_loc3_) && _loc3_.hasOwnProperty("skill_source") ? _loc3_.skill_source : null;
         switch(param1.currentTarget.item_type)
         {
            case "skill":
               _loc2_ = "" + param1.currentTarget.tooltip.skill_name + "\n(Skill)\n" + "\nLevel " + param1.currentTarget.tooltip.skill_level + "\nDamage: " + param1.currentTarget.tooltip.skill_damage + "\nCP Cost: " + param1.currentTarget.tooltip.skill_cp_cost + "\nCooldown: " + param1.currentTarget.tooltip.skill_cooldown + "\n\n" + param1.currentTarget.tooltip.skill_description + ItemDropSourceMapping.formatSourceText(_loc5_);
               break;
            case "wpn":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Weapon)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n<font color=\"#ff0000\">Damage: " + param1.currentTarget.tooltip.item_damage + "</font>\n\n" + param1.currentTarget.tooltip.item_description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "back":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Back Item)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "set":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Clothes)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "hair":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Hairstyle)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "accessory":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Accessories)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "material":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Material)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "essential":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Essentials)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "item":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Consumables)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "pet":
               _loc2_ = "" + param1.currentTarget.tooltip.pet_name + "\n(Pet)\n" + "\nLevel " + param1.currentTarget.tooltip.pet_level + "\n\n" + param1.currentTarget.tooltip.description + ItemDropSourceMapping.formatSourceText(_loc4_);
               break;
            case "tokens":
               _loc2_ = "(Token)\n" + param1.currentTarget.tooltip + " Tokens";
               break;
            case "gold":
               _loc2_ = "(Gold)\n" + param1.currentTarget.tooltip + " Gold";
               break;
            case "tp":
               _loc2_ = "(TP)\n" + param1.currentTarget.tooltip + " TP";
               break;
            case "xp":
               _loc2_ = "(XP)\n" + param1.currentTarget.tooltip + " XP";
         }
         this.main.stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc2_);
      }
      
      public function toolTiponOut(param1:MouseEvent) : *
      {
         param1.currentTarget.parent.gotoAndStop(1);
         this.tooltip.hide();
      }
      
      public function sortItems(param1:Array) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         if(param1.length == 1)
         {
            return param1;
         }
         if(PresetData.preset_back == "back_00" || PresetData.preset_acc == "accessory_00")
         {
            _loc2_ = param1[_loc6_].split("_");
            if(_loc2_[0] == "back" || _loc2_[0] == "accessory")
            {
               return param1;
            }
         }
         while(_loc6_ < param1.length)
         {
            _loc3_ = param1[_loc6_].split(":");
            _loc4_ = _loc3_[0];
            if(_loc4_ == PresetData.preset_wpn || _loc4_ == PresetData.preset_back || _loc4_ == PresetData.preset_acc || _loc4_ == PresetData.preset_set || _loc4_ == PresetData.preset_hair)
            {
               _loc5_ = param1[_loc6_];
            }
            _loc6_++;
         }
         var _loc7_:Array = _loc5_ != null ? [_loc5_] : [param1[0]];
         _loc6_ = 0;
         var _loc8_:* = 1;
         while(_loc6_ < param1.length)
         {
            if(_loc7_[0] != param1[_loc6_])
            {
               _loc7_[_loc8_] = param1[_loc6_];
               _loc8_++;
            }
            _loc6_++;
         }
         return _loc7_;
      }
      
      public function savePreset(param1:MouseEvent) : void
      {
         if(param1 != null)
         {
            this.savedWithButton = param1.currentTarget.name;
         }
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,PresetData.preset_id_edit,this.panelMC.txt_presetName.text,PresetData.preset_wpn,PresetData.preset_set,PresetData.preset_hair,PresetData.preset_back,PresetData.preset_acc,PresetData.preset_hair_color,PresetData.preset_skill,PresetData.preset_pet_id];
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["EnrYOXfXF26s",_loc2_],this.onPresetSaved);
      }
      
      private function onPresetSaved(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.preset_selection_parent.getData();
            PresetData.selected_preset_name = this.panelMC.txt_presetName.text;
            if(this.savedWithButton == "btn_close")
            {
               this.destroy();
               return;
            }
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
      
      public function usePreset(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["ETt1WsMUsaLg",[Character.char_id,Character.sessionkey,PresetData.preset_id_edit]],this.onPresetUsed);
      }
      
      private function onPresetUsed(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.btn_use.visible = false;
            this.preset_selection_parent.getData();
            PresetData.preset_id_used = PresetData.preset_id_edit;
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
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.savedWithButton = param1.currentTarget.name;
         this.savePreset(null);
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
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         var _loc1_:* = 0;
         while(_loc1_ < 9)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].iconMc.iconHolder);
            this.panelMC["item_" + _loc1_].clickmask.tooltip = null;
            this.panelMC["item_" + _loc1_].btn_use.metaData = {};
            this.panelMC["item_" + _loc1_].btn_equip.metaData = {};
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.tabButton.length)
         {
            this.panelMC[this.tabButton[_loc1_]].buttonMode = false;
            _loc1_++;
         }
         GF.destroyArray(this.outfits);
         this.firstLoad = true;
         this.eventHandler.removeAllEventListeners();
         this.tooltip.destroy();
         NinjaSage.clearLoader();
         this.loaderSwf.clear();
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
         this.selectedCategory = [];
         this.outfits = [];
         this.itemEquipMC = [];
         this.backHairMC = [];
         this.skirtMC = [];
         this.currentPage = 1;
         this.totalPage = 1;
         this.presetTarget = 0;
         this.preset_total_page = 0;
         this.preset_curr_page = 1;
         this.savedWithButton = null;
         this.confirmation = null;
         this.selectedHairColor = null;
         this.selectedSkinColor = null;
         this.selectedHairMC = null;
         this.selectedBackHairMC = null;
         this.selectedSetMC = null;
         this.loaderSwf = null;
         this.tabIndicator = null;
         this.equippedItem = null;
         this.color = null;
         this.eventHandler = null;
         this.tooltip = null;
         this.main = null;
         this.pet_inventoryMC = null;
         this.skill_inventoryMC = null;
         this.removeCharMCItems(this.panelMC.char_mc);
         this.panelMC.visible = false;
         System.gc();
      }
   }
}

