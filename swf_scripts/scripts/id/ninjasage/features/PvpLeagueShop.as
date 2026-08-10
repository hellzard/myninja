package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.GameData;
   import Storage.ItemDropSourceMapping;
   import Storage.Library;
   import Storage.SetBuffs;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class PvpLeagueShop extends MovieClip
   {
      
      public static var hairMC:MovieClip;
      
      public static var backHairMC:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var weaponArray:Array;
      
      public var backArray:Array;
      
      public var accArray:Array;
      
      public var setArray:Array;
      
      public var hairArray:Array;
      
      public var essentialArray:Array;
      
      public var consumableArray:Array;
      
      public var skillArray:Array;
      
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
      
      public var buyQuantity:int = 1;
      
      public var itemPerPage:int = 6;
      
      public var tabIndicator:String = "weapon";
      
      public var selectedHairColor:String;
      
      public var selectedSkinColor:String;
      
      public var shopType:String;
      
      public var selectedBuyItem:Object;
      
      public var selectedHairMC:MovieClip;
      
      public var selectedBackHairMC:MovieClip;
      
      public var selectedSetMC:Array = [];
      
      public var isLoading:Boolean;
      
      public var tempWeaponMC:MovieClip;
      
      public var tempBackItemMC:MovieClip;
      
      public var tempHairMC:MovieClip;
      
      public var tempBackHairMC:MovieClip;
      
      public var tempSetMC:MovieClip;
      
      public var tempSetArray:Array = [];
      
      public var tempSkirtMC:MovieClip;
      
      public var buyPanel:MovieClip;
      
      public var eventHandler:EventHandler;
      
      public var tooltip:ToolTip;
      
      public var main:*;
      
      public var loaderSwf:BulkLoader;
      
      public var color:Color;
      
      public var confirmation:Confirmation;
      
      public var panelMC:MovieClip;
      
      public const GOLD_MATERIAL:String = "material_1999";
      
      public const PURPLE_MATERIAL:String = "material_1998";
      
      public const tabButton:Array = ["mcWeapon","mcBackItem","mcSkill"];
      
      public const bodyArray:Array = ["upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe"];
      
      public function PvpLeagueShop(param1:*, param2:*)
      {
         super();
         var _loc3_:* = GameData.get("pvp_league_shop");
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.eventHandler = new EventHandler();
         this.tooltip = ToolTip.getInstance();
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(10);
         this.color = new Color();
         this.main.handleVillageHUDVisibility(false);
         this.getItemData();
      }
      
      public function getItemData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("jpwzlvqNru201CF3.FufwjMUIFJzq",[Character.char_id,Character.sessionkey],this.getItemResponse);
      }
      
      public function getItemResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.weaponArray = param1.data.weapons;
            this.backArray = param1.data.backs;
            this.accArray = param1.data.accs;
            this.consumableArray = param1.data.items;
            this.essentialArray = param1.data.essentials;
            this.skillArray = param1.data.skills;
            this.hairArray = param1.data.hairs;
            this.setArray = param1.data.sets;
            this.initButton();
            this.initUI();
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
      
      public function initButton() : void
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
      }
      
      public function initUI() : void
      {
         var _loc1_:* = undefined;
         if(!Character.is_stickman)
         {
            _loc1_ = new OutfitManager();
            _loc1_.fillOutfit(this.panelMC.char_mc,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
            this.outfits.push(_loc1_);
         }
         this.updatePlayerCurrency();
         this.selectedHairColor = Character.character_color_hair;
         this.selectedSkinColor = Character.character_color_skin;
         NinjaSage.showDynamicTooltip(this.panelMC.btn_help,"This item has no purchase time limit and will remain permanently available in the shop. You can purchase it whenever you want without worrying about expiration or limited-time availability.");
         this.panelMC.confirmationMC.visible = false;
         this.panelMC.mcWeapon.gotoAndStop(3);
         this.tabIndicator = "weapon";
         this.selectedCategory = this.weaponArray;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / this.itemPerPage),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
      }
      
      public function updatePlayerCurrency() : void
      {
         this.panelMC.txt_coin.text = Character.character_pvp_point;
         this.panelMC.txt_gold.text = Character.getMaterialAmount(this.GOLD_MATERIAL);
         this.panelMC.txt_purple.text = Character.getMaterialAmount(this.PURPLE_MATERIAL);
      }
      
      public function loadSwf() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.isLoading = true;
         if(this.itemIndex < this.itemLoading)
         {
            _loc1_ = this.selectedCategory[this.itemIndex].code;
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
      
      public function completeIcon(param1:Event) : void
      {
         var _loc7_:MovieClip = null;
         var _loc8_:Array = null;
         var _loc9_:* = undefined;
         var _loc10_:MovieClip = null;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onItemLoadError);
         var _loc3_:MovieClip = null;
         _loc3_ = param1.target.content.icon;
         if(!Character.play_items_animation)
         {
            _loc3_.stopAllMovieClips();
         }
         this.iconMCArray.push(_loc3_);
         this.panelMC["item_" + this.itemCount].visible = true;
         this.panelMC["item_" + this.itemCount].gotoAndStop(1);
         var _loc4_:* = this.selectedCategory[this.itemIndex].code;
         var _loc5_:Object = {};
         this.panelMC["item_" + this.itemCount].iconMC.btn_preview.visible = false;
         if(this.selectedCategory[this.itemIndex].code.indexOf("skill") > -1)
         {
            _loc5_ = SkillLibrary.getSkillInfo(_loc4_);
            _loc5_.item_id = _loc5_.skill_id;
            _loc5_.item_level = _loc5_.skill_level;
            _loc5_.item_name = _loc5_.skill_name;
            _loc5_.item_price_gold = _loc5_.skill_price_gold;
            _loc5_.item_price_token = _loc5_.skill_price_tokens;
            param1.target.content[_loc5_.skill_id].gotoAndStop(1);
            this.panelMC["item_" + this.itemCount].iconMC.rewardIcon.visible = false;
            this.panelMC["item_" + this.itemCount].iconMC.skillIcon.visible = true;
            this.panelMC["item_" + this.itemCount].iconMC.btn_preview.visible = true;
            this.panelMC["item_" + this.itemCount].iconMC.btn_preview.metaData = {"itemId":_loc4_};
            this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].iconMC.btn_preview,MouseEvent.CLICK,this.openPreview);
            this.panelMC["item_" + this.itemCount].iconMC.skillIcon.iconHolder.addChild(_loc3_);
         }
         else
         {
            _loc5_ = Library.getItemInfo(_loc4_);
            this.panelMC["item_" + this.itemCount].iconMC.rewardIcon.visible = true;
            this.panelMC["item_" + this.itemCount].iconMC.skillIcon.visible = false;
            this.panelMC["item_" + this.itemCount].iconMC.rewardIcon.iconHolder.addChild(_loc3_);
         }
         if(this.tabIndicator == "weapon")
         {
            _loc3_ = param1.target.content.weapon;
            if(!Character.play_items_animation)
            {
               _loc3_.stopAllMovieClips();
            }
            this.itemEquipMC.push(_loc3_);
         }
         else if(this.tabIndicator == "back")
         {
            _loc3_ = param1.target.content.back_item;
            if(!Character.play_items_animation)
            {
               _loc3_.stopAllMovieClips();
            }
            this.itemEquipMC.push(_loc3_);
         }
         else if(this.tabIndicator == "hair")
         {
            _loc3_ = param1.target.content.hair;
            if(!Character.play_items_animation)
            {
               _loc3_.stopAllMovieClips();
            }
            this.itemEquipMC.push(_loc3_);
            try
            {
               _loc7_ = param1.target.content.back_hair;
               if(!Character.play_items_animation)
               {
                  _loc7_.stopAllMovieClips();
               }
               this.backHairMC.push(_loc7_);
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
               _loc3_ = param1.target.content[this.bodyArray[_loc9_]];
               if(!Character.play_items_animation)
               {
                  _loc3_.stopAllMovieClips();
               }
               _loc8_.push(_loc3_);
               _loc9_++;
            }
            try
            {
               _loc10_ = param1.target.content.skirt;
               if(!Character.play_items_animation)
               {
                  _loc10_.stopAllMovieClips();
               }
               this.skirtMC.push(_loc10_);
            }
            catch(error:*)
            {
            }
            this.itemEquipMC.push(_loc8_);
         }
         this.panelMC["item_" + this.itemCount].iconMC.ownedTxt.visible = false;
         if(Character.hasSkill(_loc5_.item_id) > 0)
         {
            this.panelMC["item_" + this.itemCount].iconMC.ownedTxt.visible = true;
            this.panelMC["item_" + this.itemCount].iconMC.ownedTxt.text = "Owned";
         }
         if(Character.isItemOwned(_loc5_.item_id) > 0)
         {
            this.panelMC["item_" + this.itemCount].iconMC.ownedTxt.visible = true;
            this.panelMC["item_" + this.itemCount].iconMC.ownedTxt.text = "Owned";
         }
         this.panelMC["item_" + this.itemCount].clickMask.tooltip = _loc5_;
         this.panelMC["item_" + this.itemCount].clickMask.item_type = _loc4_.split("_")[0];
         this.panelMC["item_" + this.itemCount].clickMask.metaData = {"id":_loc4_};
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickMask,MouseEvent.MOUSE_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickMask,MouseEvent.MOUSE_OUT,this.toolTiponOut);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].clickMask,MouseEvent.CLICK,this.loadItem);
         var _loc6_:int = this.getCurrencyType(_loc4_);
         this.panelMC["item_" + this.itemCount].currencyMC.gotoAndStop(_loc6_);
         if(_loc6_ == 1)
         {
            this.panelMC["item_" + this.itemCount].currencyMC.content.txt_coin.text = this.selectedCategory[this.itemIndex].p.pts;
            this.panelMC["item_" + this.itemCount].currencyMC.content.txt_gold.text = this.selectedCategory[this.itemIndex].p.y;
            this.panelMC["item_" + this.itemCount].currencyMC.content.txt_purple.text = this.selectedCategory[this.itemIndex].p.p;
         }
         else if(_loc6_ == 2)
         {
            this.panelMC["item_" + this.itemCount].currencyMC.content.txt_coin.text = this.selectedCategory[this.itemIndex].p.pts;
            this.panelMC["item_" + this.itemCount].currencyMC.content.txt_gold.text = this.selectedCategory[this.itemIndex].p.y;
         }
         else if(_loc6_ == 3)
         {
            this.panelMC["item_" + this.itemCount].currencyMC.content.txt_coin.text = this.selectedCategory[this.itemIndex].p.pts;
            this.panelMC["item_" + this.itemCount].currencyMC.content.txt_purple.text = this.selectedCategory[this.itemIndex].p.p;
         }
         else
         {
            this.panelMC["item_" + this.itemCount].currencyMC.content.txt_coin.text = this.selectedCategory[this.itemIndex].p.pts;
         }
         this.panelMC["item_" + this.itemCount].btn_exchange.metaData = {
            "item_info":_loc5_,
            "price_info":this.selectedCategory[this.itemIndex]
         };
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount].btn_exchange,MouseEvent.CLICK,this.openBuyConfirmation);
         if(_loc5_.item_id.indexOf("material") >= 0 || _loc5_.item_id.indexOf("essential") >= 0 || _loc5_.item_id.indexOf("item") >= 0 || _loc5_.item_id.indexOf("skill") >= 0)
         {
            this.eventHandler.removeListener(this.panelMC["item_" + this.itemCount].clickMask,MouseEvent.CLICK,this.loadItem);
         }
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      private function getCurrencyType(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.selectedCategory.length)
         {
            if(this.selectedCategory[_loc2_].code == param1)
            {
               if(this.selectedCategory[_loc2_].p.pts > 0 && this.selectedCategory[_loc2_].p.p > 0 && this.selectedCategory[_loc2_].p.y > 0)
               {
                  return 1;
               }
               if(this.selectedCategory[_loc2_].p.pts > 0 && this.selectedCategory[_loc2_].p.y > 0)
               {
                  return 2;
               }
               if(this.selectedCategory[_loc2_].p.pts > 0 && this.selectedCategory[_loc2_].p.p > 0)
               {
                  return 3;
               }
            }
            _loc2_++;
         }
         return 4;
      }
      
      public function loadItem(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.metaData.id;
         var _loc3_:String = "items/" + _loc2_ + ".swf";
         var _loc4_:* = this.loaderSwf.add(_loc3_);
         _loc4_.addEventListener(BulkLoader.COMPLETE,this.previewItem);
         this.loaderSwf.start();
      }
      
      public function previewItem(param1:Event) : void
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
                  this.selectedBackHairMC = this.tempSkirtMC;
                  this.panelMC.char_mc["skirt"].addChild(this.tempSkirtMC);
               }
               catch(error:Error)
               {
               }
               _loc2_++;
            }
         }
      }
      
      public function openBuyConfirmation(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget.metaData.item_info;
         this.selectedBuyItem = param1.currentTarget.metaData.price_info;
         this.panelMC.confirmationMC.visible = true;
         this.panelMC.confirmationMC.txt_title.text = "Are you sure want to exchange these materials for " + _loc2_.item_name + "?";
         var _loc3_:int = this.getCurrencyType(_loc2_.item_id);
         this.panelMC.confirmationMC.currencyMC.gotoAndStop(_loc3_);
         if(_loc3_ == 1)
         {
            this.panelMC.confirmationMC.currencyMC.content.txt_coin.text = this.selectedBuyItem.p.pts;
            this.panelMC.confirmationMC.currencyMC.content.txt_gold.text = this.selectedBuyItem.p.y;
            this.panelMC.confirmationMC.currencyMC.content.txt_purple.text = this.selectedBuyItem.p.p;
         }
         else if(_loc3_ == 2)
         {
            this.panelMC.confirmationMC.currencyMC.content.txt_coin.text = this.selectedBuyItem.p.pts;
            this.panelMC.confirmationMC.currencyMC.content.txt_gold.text = this.selectedBuyItem.p.y;
         }
         else if(_loc3_ == 3)
         {
            this.panelMC.confirmationMC.currencyMC.content.txt_coin.text = this.selectedBuyItem.p.pts;
            this.panelMC.confirmationMC.currencyMC.content.txt_purple.text = this.selectedBuyItem.p.p;
         }
         else
         {
            this.panelMC.confirmationMC.currencyMC.content.txt_coin.text = this.selectedBuyItem.p.pts;
         }
         NinjaSage.loadItemIcon(this.panelMC.confirmationMC.iconMC,_loc2_.item_id);
         this.panelMC.confirmationMC.iconMC.amountTxt.visible = false;
         this.panelMC.confirmationMC.iconMC.ownedTxt.visible = false;
         this.panelMC.confirmationMC.iconMC.btn_preview.visible = false;
         this.eventHandler.addListener(this.panelMC.confirmationMC.btn_confirm,MouseEvent.CLICK,this.buyItemAmf);
         this.eventHandler.addListener(this.panelMC.confirmationMC.btn_cancel,MouseEvent.CLICK,this.onCloseConfItem);
      }
      
      public function buyItemAmf(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("jpwzlvqNru201CF3.iMb0qi2y0CZg",[Character.char_id,Character.sessionkey,this.selectedBuyItem.id],this.buyResponse);
      }
      
      public function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Item succesfully exchanged!");
            Character.character_pvp_point -= this.selectedBuyItem.p.pts;
            Character.removeMaterials(this.GOLD_MATERIAL,this.selectedBuyItem.p.y);
            Character.removeMaterials(this.PURPLE_MATERIAL,this.selectedBuyItem.p.p);
            Character.addRewards(this.selectedBuyItem.code);
            this.main.giveReward(1,this.selectedBuyItem.code);
            this.main.HUD.setBasicData();
            this.onCloseConfItem();
            this.initUI();
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
      
      public function onCloseConfItem(param1:MouseEvent = null) : void
      {
         GF.removeAllChild(this.panelMC.confirmationMC.iconMC.rewardIcon.iconHolder);
         GF.removeAllChild(this.panelMC.confirmationMC.iconMC.skillIcon.iconHolder);
         this.panelMC.confirmationMC.visible = false;
      }
      
      public function clearPreview(param1:MouseEvent) : void
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
      
      public function addHairColor(param1:MovieClip) : void
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
      
      public function addSkinColor(param1:MovieClip) : void
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
      
      public function changePage(param1:MouseEvent) : void
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
      
      public function updatePageNumber() : void
      {
         this.panelMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      public function changeCategory(param1:MouseEvent) : void
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
               break;
            case "mcSet":
               this.selectedCategory = this.setArray;
               this.tabIndicator = "set";
               break;
            case "mcBackItem":
               this.selectedCategory = this.backArray;
               this.tabIndicator = "back";
               break;
            case "mcAccessory":
               this.selectedCategory = this.accArray;
               this.tabIndicator = "accessory";
               break;
            case "mcEssentials":
               this.selectedCategory = this.essentialArray;
               this.tabIndicator = "essential";
               break;
            case "mcHairstyle":
               this.selectedCategory = this.hairArray;
               this.tabIndicator = "hair";
               break;
            case "mcItems":
               this.selectedCategory = this.consumableArray;
               this.tabIndicator = "consumable";
               break;
            case "mcSkill":
               this.selectedCategory = this.skillArray;
               this.tabIndicator = "skill";
         }
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / this.itemPerPage),1);
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadSwf();
      }
      
      public function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      public function resetRecursiveProperty() : void
      {
         this.itemLoading = this.currentPage * this.itemPerPage;
         if(this.selectedCategory.length < this.itemLoading)
         {
            this.itemLoading = this.selectedCategory.length;
         }
         this.itemIndex = (this.currentPage - 1) * this.itemPerPage;
         this.itemCount = 0;
      }
      
      public function resetIconHolder() : void
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
         while(_loc1_ < this.itemPerPage)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].iconMC.rewardIcon.iconHolder);
            this.panelMC["item_" + _loc1_].gotoAndStop(1);
            this.panelMC["item_" + _loc1_].visible = false;
            this.panelMC["item_" + _loc1_].iconMC.skillIcon.visible = false;
            this.panelMC["item_" + _loc1_].iconMC.amountTxt.visible = false;
            delete this.panelMC["item_" + _loc1_].clickMask.tooltip;
            delete this.panelMC["item_" + _loc1_].clickMask.tooltipCache;
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickMask,MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickMask,MouseEvent.MOUSE_OUT,this.toolTiponOut);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_].clickMask,MouseEvent.CLICK,this.loadItem);
            _loc1_++;
         }
      }
      
      public function removeChildsFromMovieClip(param1:MovieClip) : void
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
         else if(_loc3_ == "skill")
         {
            _loc2_ = "skills";
         }
         else
         {
            _loc2_ = "items";
         }
         return _loc2_;
      }
      
      public function hoverOver(param1:Event) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      public function hoverOut(param1:Event) : void
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
               var _loc7_:String = "";
               switch(itemType)
               {
                  case "material":
                     _loc7_ = "\n<font color=\"#00cc00\">Owned: " + Character.getMaterialAmount(tooltipData.item_id) + "</font>";
                     break;
                  case "essential":
                     _loc7_ = "\n<font color=\"#00cc00\">Owned: " + Character.getEssentialAmount(tooltipData.item_id) + "</font>";
                     break;
                  case "item":
                     _loc7_ = "\n<font color=\"#00cc00\">Owned: " + Character.getConsumableAmount(tooltipData.item_id) + "</font>";
               }
               return param1 + "\n(" + param2 + ")\n\nLevel " + param3 + param4 + _loc7_ + "\n\n" + param5 + ItemDropSourceMapping.formatSourceText(param6);
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
                  desc = formatDesc(tooltipData.skill_name,"Skill",tooltipData.skill_level,"\n<font color=\"#ff0000\">Damage: " + tooltipData.skill_damage + "</font>\n<font color=\"#0000ff\">CP Cost: " + tooltipData.skill_cp_cost + "</font>\n<font color=\"#ffcc00\">Cooldown: " + tooltipData.skill_cooldown + "</font>",tooltipData.skill_description,skillSource);
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
         this.panelMC.stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(finalDesc);
      }
      
      public function toolTiponOut(param1:MouseEvent) : void
      {
         param1.currentTarget.parent.gotoAndStop(1);
         this.tooltip.hide();
      }
      
      private function openPreview(param1:MouseEvent) : void
      {
         this.main.openPreview(param1);
      }
      
      public function removeCharMCItems(param1:*) : void
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
      
      public function closePanel(param1:MouseEvent) : void
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
         this.main.HUD.setBasicData();
         this.main.HUD.loadFrame();
         var _loc1_:* = 0;
         while(_loc1_ < this.itemPerPage)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].iconMC.rewardIcon.iconHolder);
            this.panelMC["item_" + _loc1_].clickMask.tooltip = null;
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
         this.main.clearEvents();
         this.eventHandler.removeAllEventListeners();
         this.resetIconHolder();
         this.tooltip.destroy();
         this.loaderSwf.clear();
         NinjaSage.clearLoader();
         BulkLoader.getLoader("assets").removeAll();
         this.weaponArray = [];
         this.backArray = [];
         this.accArray = [];
         this.setArray = [];
         this.hairArray = [];
         this.essentialArray = [];
         this.consumableArray = [];
         this.skillArray = [];
         this.selectedCategory = [];
         this.outfits = [];
         this.itemEquipMC = [];
         this.backHairMC = [];
         this.skirtMC = [];
         this.tempSetArray = [];
         this.iconMCArray = [];
         this.currentPage = 1;
         this.totalPage = 1;
         this.buyQuantity = 1;
         this.tempWeaponMC = null;
         this.tempBackItemMC = null;
         this.tempHairMC = null;
         this.tempBackHairMC = null;
         this.tempSetMC = null;
         this.tempSkirtMC = null;
         this.buyPanel = null;
         this.confirmation = null;
         this.selectedBuyItem = null;
         this.selectedHairColor = null;
         this.selectedSkinColor = null;
         this.selectedHairMC = null;
         this.selectedBackHairMC = null;
         this.selectedSetMC = null;
         this.loaderSwf = null;
         this.tabIndicator = null;
         this.color = null;
         this.eventHandler = null;
         this.tooltip = null;
         this.main = null;
         this.removeCharMCItems(this.panelMC.char_mc);
         GF.removeAllChild(this.panelMC.char_mc);
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

