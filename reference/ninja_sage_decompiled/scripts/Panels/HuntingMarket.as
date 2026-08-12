package Panels
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.ForgeDataHunting;
   import Storage.ItemDropSourceMapping;
   import Storage.Library;
   import Storage.PetInfo;
   import Storage.SkillLibrary;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.Util;
   
   public class HuntingMarket extends MovieClip
   {
       
      
      public var item_3:MovieClip;
      
      public var titleTxt:TextField;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var item_0:MovieClip;
      
      public var item_1:MovieClip;
      
      public var item_2:MovieClip;
      
      public var materialList;
      
      public var mcAccessory:MovieClip;
      
      public var mcBackItem:MovieClip;
      
      public var mcHairstyle:MovieClip;
      
      public var mcPet:MovieClip;
      
      public var mcSet:MovieClip;
      
      public var mcSkill:MovieClip;
      
      public var mcWeapon:MovieClip;
      
      public var mcMaterial:MovieClip;
      
      public var nextPageBtn:SimpleButton;
      
      public var materialBagBtn:SimpleButton;
      
      public var pageTxt:TextField;
      
      public var prevPageBtn:SimpleButton;
      
      public var main;
      
      public var tooltip:ToolTip;
      
      public var orig_indicator = "wpn";
      
      public var array_info_holder:Array;
      
      var curr_page = 1;
      
      var itemCnt = 0;
      
      var itList;
      
      var total_page = 1;
      
      public var curr_page_items:Array;
      
      public var is_loading = false;
      
      public var lnr = 0;
      
      public function HuntingMarket(param1:*)
      {
         this.materialList = [];
         this.curr_page_items = [];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.main.handleVillageHUDVisibility(false);
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.getItems();
      }
      
      public function getItems() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("JDEUnbiWJXOtHxVv.rRBL7SvzeCII",[Character.char_id,Character.sessionkey],this.onGetItems);
      }
      
      public function onGetItems(param1:*) : *
      {
         if(param1.status > 1)
         {
            this.main.loading(false);
            this.main.getNotice(param1.result);
            this.closePanel();
            return;
         }
         ForgeDataHunting.constructData(param1.items);
         this.itList = ForgeDataHunting.getItemByCategory("wpn");
         this.setUI();
         this.mcWeapon.gotoAndStop(1);
         this.loadCategory("Weapon");
         this.main.loading(false);
      }
      
      function resetButtons() : void
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
      
      function setUI() : void
      {
         this.array_info_holder = [];
         this.tooltip = ToolTip.getInstance();
         this.resetButtons();
         this.mcWeapon.buttonMode = true;
         this.mcWeapon.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcWeapon.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcWeapon.addEventListener(MouseEvent.CLICK,this.click);
         this.mcSet.buttonMode = true;
         this.mcSet.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcSet.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcSet.addEventListener(MouseEvent.CLICK,this.click);
         this.mcBackItem.buttonMode = true;
         this.mcBackItem.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcBackItem.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcBackItem.addEventListener(MouseEvent.CLICK,this.click);
         this.mcAccessory.buttonMode = true;
         this.mcAccessory.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcAccessory.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcAccessory.addEventListener(MouseEvent.CLICK,this.click);
         this.mcHairstyle.buttonMode = true;
         this.mcHairstyle.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcHairstyle.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcHairstyle.addEventListener(MouseEvent.CLICK,this.click);
         this.mcSkill.buttonMode = true;
         this.mcSkill.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcSkill.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcSkill.addEventListener(MouseEvent.CLICK,this.click);
         this.mcPet.buttonMode = true;
         this.mcPet.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcPet.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcPet.addEventListener(MouseEvent.CLICK,this.click);
         this.mcMaterial.buttonMode = true;
         this.mcMaterial.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcMaterial.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcMaterial.addEventListener(MouseEvent.CLICK,this.click);
         this.nextPageBtn.addEventListener(MouseEvent.CLICK,this.changePage);
         this.prevPageBtn.addEventListener(MouseEvent.CLICK,this.changePage);
         this.materialBagBtn.addEventListener(MouseEvent.CLICK,this.openGear);
      }
      
      function openGear(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.UI_Gear");
      }
      
      function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame != 1)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame != 1)
         {
            param1.currentTarget.gotoAndStop(3);
         }
      }
      
      function click(param1:MouseEvent) : void
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
      
      function clearSlots() : void
      {
         this.item_0.visible = false;
         this.item_1.visible = false;
         this.item_2.visible = false;
         this.item_3.visible = false;
         var _loc1_:* = 0;
         while(_loc1_ < 12)
         {
            this.item_0["item_" + _loc1_].visible = false;
            this.item_1["item_" + _loc1_].visible = false;
            this.item_2["item_" + _loc1_].visible = false;
            this.item_3["item_" + _loc1_].visible = false;
            while(this.item_0.iconMc.iconHolder.numChildren > 0)
            {
               this.item_0.iconMc.iconHolder.removeChildAt(0);
            }
            while(this.item_1.iconMc.iconHolder.numChildren > 0)
            {
               this.item_1.iconMc.iconHolder.removeChildAt(0);
            }
            while(this.item_2.iconMc.iconHolder.numChildren > 0)
            {
               this.item_2.iconMc.iconHolder.removeChildAt(0);
            }
            while(this.item_3.iconMc.iconHolder.numChildren > 0)
            {
               this.item_3.iconMc.iconHolder.removeChildAt(0);
            }
            while(this.item_0.skillIconMc.iconHolder.numChildren > 0)
            {
               this.item_0.skillIconMc.iconHolder.removeChildAt(0);
            }
            while(this.item_1.skillIconMc.iconHolder.numChildren > 0)
            {
               this.item_1.skillIconMc.iconHolder.removeChildAt(0);
            }
            while(this.item_2.skillIconMc.iconHolder.numChildren > 0)
            {
               this.item_2.skillIconMc.iconHolder.removeChildAt(0);
            }
            while(this.item_3.skillIconMc.iconHolder.numChildren > 0)
            {
               this.item_3.skillIconMc.iconHolder.removeChildAt(0);
            }
            while(this.item_0["item_" + _loc1_].iconMC.iconHolder.numChildren > 0)
            {
               this.item_0["item_" + _loc1_].iconMC.iconHolder.removeChildAt(0);
            }
            while(this.item_1["item_" + _loc1_].iconMC.iconHolder.numChildren > 0)
            {
               this.item_1["item_" + _loc1_].iconMC.iconHolder.removeChildAt(0);
            }
            while(this.item_2["item_" + _loc1_].iconMC.iconHolder.numChildren > 0)
            {
               this.item_2["item_" + _loc1_].iconMC.iconHolder.removeChildAt(0);
            }
            while(this.item_3["item_" + _loc1_].iconMC.iconHolder.numChildren > 0)
            {
               this.item_3["item_" + _loc1_].iconMC.iconHolder.removeChildAt(0);
            }
            _loc1_++;
         }
         _loc1_ = null;
      }
      
      function loadCategory(param1:String, param2:int = 1, param3:* = 0) : void
      {
         if(this.is_loading)
         {
            return;
         }
         this.clearSlots();
         this.itemCnt = param3;
         this.curr_page = param2;
         this.total_page = 1;
         if(param1 == "Weapon")
         {
            this.itList = ForgeDataHunting.getItemByCategory("wpn");
            this.orig_indicator = "Weapon";
         }
         else if(param1 == "BackItem")
         {
            this.itList = ForgeDataHunting.getItemByCategory("back");
            this.orig_indicator = "BackItem";
         }
         else if(param1 == "Set")
         {
            this.itList = ForgeDataHunting.getItemByCategory("set");
            this.orig_indicator = "Set";
         }
         else if(param1 == "Accessory")
         {
            this.itList = ForgeDataHunting.getItemByCategory("accessory");
            this.orig_indicator = "Accessory";
         }
         else if(param1 == "Hairstyle")
         {
            this.itList = ForgeDataHunting.getItemByCategory("hair");
            this.orig_indicator = "Hairstyle";
         }
         else if(param1 == "Skill")
         {
            this.itList = ForgeDataHunting.getItemByCategory("skill");
            this.orig_indicator = "Skill";
         }
         else if(param1 == "Pet")
         {
            this.itList = ForgeDataHunting.getItemByCategory("pet");
            this.orig_indicator = "Pet";
         }
         else if(param1 == "Material")
         {
            this.itList = ForgeDataHunting.getItemByCategory("material");
            this.orig_indicator = "Material";
         }
         this.total_page = Math.max(Math.ceil(this.itList.length / 4),1);
         this.array_info_holder.splice(0);
         this.pageTxt.text = this.curr_page + "/" + this.total_page;
         this.loadItems(this.itemCnt,this.curr_page);
      }
      
      function changePage(param1:MouseEvent) : void
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
               this.itemCnt += 4;
               this.clearSlots();
               this.array_info_holder.splice(0);
               this.loadItems(this.itemCnt,this.curr_page);
            }
         }
         else if(param1.currentTarget.name == "prevPageBtn")
         {
            if(this.curr_page != 1)
            {
               --this.curr_page;
               this.itemCnt -= 4;
               this.clearSlots();
               this.array_info_holder.splice(0);
               this.loadItems(this.itemCnt,this.curr_page);
            }
         }
         this.pageTxt.text = this.curr_page + "/" + this.total_page;
      }
      
      function checkLoading(param1:Event) : *
      {
         ++this.lnr;
         if(this.lnr > 4)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkLoading);
            this.is_loading = false;
         }
      }
      
      function loadItems(param1:*, param2:*) : void
      {
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         this.lnr = 0;
         this.is_loading = true;
         addEventListener(Event.ENTER_FRAME,this.checkLoading);
         this.curr_page_items = [];
         var _loc13_:* = 0;
         if((_loc14_ = Math.ceil(this.itList.length / param2)) >= 4)
         {
            _loc14_ = 4;
         }
         while(_loc13_ < _loc14_)
         {
            if((_loc3_ = this.itList[param1]) == undefined)
            {
               _loc13_++;
            }
            else
            {
               this["item_" + _loc13_].visible = true;
               this.curr_page_items.push(_loc3_);
               _loc4_ = ForgeDataHunting.getForgeItems(_loc3_);
               _loc5_ = Character.isItemOwned(_loc3_);
               this["item_" + _loc13_].ownedTxt.text = !!_loc5_ ? "Owned" : "";
               if((_loc6_ = (_loc6_ = _loc3_.split("_"))[0]) == "skill")
               {
                  _loc9_ = SkillLibrary.getSkillInfo(_loc3_);
                  this["item_" + _loc13_].lvlTxt.text = _loc9_["skill_level"];
                  this["item_" + _loc13_].skillIconMc.visible = true;
                  this["item_" + _loc13_].iconMc.visible = false;
                  GF.removeAllChild(this["item_" + _loc13_].skillIconMc.iconHolder);
                  NinjaSage.loadIconSWF("skills",_loc3_,this["item_" + _loc13_].skillIconMc);
                  this["item_" + _loc13_].skillIconMc.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
                  this["item_" + _loc13_].skillIconMc.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                  _loc10_ = new Array(_loc9_["skill_name"],_loc9_["skill_level"],_loc9_["skill_damage"],_loc9_["skill_cp_cost"],_loc9_["skill_cooldown"],_loc9_["skill_description"],_loc9_["skill_source"]);
                  this.array_info_holder.push(_loc10_);
               }
               else if(_loc6_ == "wpn")
               {
                  _loc9_ = Library.getItemInfo(_loc3_);
                  this["item_" + _loc13_].lvlTxt.text = _loc9_["item_level"];
                  GF.removeAllChild(this["item_" + _loc13_].iconMc.iconHolder);
                  NinjaSage.loadIconSWF("items",_loc3_,this["item_" + _loc13_].iconMc);
                  this["item_" + _loc13_].skillIconMc.visible = false;
                  this["item_" + _loc13_].iconMc.visible = true;
                  this["item_" + _loc13_].iconMc.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
                  this["item_" + _loc13_].iconMc.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                  _loc10_ = new Array(_loc9_["item_name"],_loc9_["item_level"],_loc9_["item_damage"],_loc9_["item_description"],_loc9_["item_source"]);
                  this.array_info_holder.push(_loc10_);
               }
               else if(_loc6_ == "pet")
               {
                  _loc9_ = PetInfo.getPetStats(_loc3_);
                  this["item_" + _loc13_].lvlTxt.text = 20;
                  GF.removeAllChild(this["item_" + _loc13_].iconMc.iconHolder);
                  NinjaSage.loadIconSWF("pets",_loc3_,this["item_" + _loc13_].iconMc);
                  this["item_" + _loc13_].skillIconMc.visible = false;
                  this["item_" + _loc13_].iconMc.visible = true;
                  this["item_" + _loc13_].iconMc.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
                  this["item_" + _loc13_].iconMc.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                  _loc10_ = new Array(_loc9_["pet_name"],"20",_loc9_["description"],_loc9_["item_source"]);
                  this.array_info_holder.push(_loc10_);
               }
               else if(_loc6_ == "material")
               {
                  _loc9_ = Library.getItemInfo(_loc3_);
                  this["item_" + _loc13_].lvlTxt.text = 20;
                  GF.removeAllChild(this["item_" + _loc13_].iconMc.iconHolder);
                  NinjaSage.loadIconSWF("materials",_loc3_,this["item_" + _loc13_].iconMc);
                  this["item_" + _loc13_].skillIconMc.visible = false;
                  this["item_" + _loc13_].iconMc.visible = true;
                  this["item_" + _loc13_].iconMc.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
                  this["item_" + _loc13_].iconMc.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                  _loc10_ = new Array(_loc9_["item_name"],_loc9_["item_level"],_loc9_["item_description"],_loc9_["item_source"]);
                  this.array_info_holder.push(_loc10_);
               }
               else
               {
                  _loc9_ = Library.getItemInfo(_loc3_);
                  this["item_" + _loc13_].lvlTxt.text = _loc9_["item_level"];
                  GF.removeAllChild(this["item_" + _loc13_].iconMc.iconHolder);
                  NinjaSage.loadIconSWF("items",_loc3_,this["item_" + _loc13_].iconMc);
                  this["item_" + _loc13_].skillIconMc.visible = false;
                  this["item_" + _loc13_].iconMc.visible = true;
                  this["item_" + _loc13_].iconMc.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
                  this["item_" + _loc13_].iconMc.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                  _loc10_ = new Array(_loc9_["item_name"],_loc9_["item_level"],_loc9_["item_description"],_loc9_["item_source"]);
                  this.array_info_holder.push(_loc10_);
               }
               _loc7_ = 0;
               _loc11_ = 0;
               while(_loc7_ < _loc4_["item_materials"].length)
               {
                  this["item_" + _loc13_]["item_" + _loc7_].visible = true;
                  this["item_" + _loc13_]["item_" + _loc7_].iconMC.visible = true;
                  this["item_" + _loc13_]["item_" + _loc7_].skillIconMc.visible = false;
                  _loc15_ = _loc3_;
                  _loc3_ = _loc4_["item_materials"][_loc7_];
                  _loc3_ = _loc3_.split("_");
                  _loc12_ = 0;
                  if(_loc3_[0] == "material")
                  {
                     GF.removeAllChild(this["item_" + _loc13_]["item_" + _loc7_].iconMC.iconHolder);
                     NinjaSage.loadIconSWF("materials",_loc4_["item_materials"][_loc7_],this["item_" + _loc13_]["item_" + _loc7_].iconMC);
                     _loc12_ = this.calculateMat(_loc4_["item_materials"][_loc7_]);
                     _loc9_ = Library.getItemInfo(_loc4_["item_materials"][_loc7_]);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOverMats,false,0,true);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.item_type = "Material";
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.tooltip = [_loc9_["item_name"],_loc9_["item_level"],_loc9_["item_description"],_loc9_["item_source"]];
                  }
                  else if(_loc3_[0] == "wpn")
                  {
                     GF.removeAllChild(this["item_" + _loc13_]["item_" + _loc7_].iconMC.iconHolder);
                     NinjaSage.loadIconSWF("items",_loc4_["item_materials"][_loc7_],this["item_" + _loc13_]["item_" + _loc7_].iconMC);
                     _loc12_ = this.calculateWeapon(_loc4_["item_materials"][_loc7_]);
                     _loc9_ = Library.getItemInfo(_loc4_["item_materials"][_loc7_]);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOverMats,false,0,true);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.item_type = "Weapon";
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.tooltip = [_loc9_["item_name"],_loc9_["item_level"],_loc9_["item_damage"],_loc9_["item_description"],_loc9_["item_source"]];
                  }
                  else if(_loc3_[0] == "back")
                  {
                     GF.removeAllChild(this["item_" + _loc13_]["item_" + _loc7_].iconMC.iconHolder);
                     NinjaSage.loadIconSWF("items",_loc4_["item_materials"][_loc7_],this["item_" + _loc13_]["item_" + _loc7_].iconMC);
                     _loc12_ = this.calculateBackItem(_loc4_["item_materials"][_loc7_]);
                     _loc9_ = Library.getItemInfo(_loc4_["item_materials"][_loc7_]);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOverMats,false,0,true);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.item_type = "BackItem";
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.tooltip = [_loc9_["item_name"],_loc9_["item_level"],_loc9_["item_description"],_loc9_["item_source"]];
                  }
                  else
                  {
                     GF.removeAllChild(this["item_" + _loc13_]["item_" + _loc7_].skillIconMc.iconHolder);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.visible = false;
                     this["item_" + _loc13_]["item_" + _loc7_].skillIconMc.visible = true;
                     NinjaSage.loadIconSWF("skills",_loc4_["item_materials"][_loc7_],this["item_" + _loc13_]["item_" + _loc7_].skillIconMc);
                     _loc12_ = !!Character.isItemOwned(_loc4_["item_materials"][_loc7_]) ? 1 : 0;
                     _loc9_ = SkillLibrary.getSkillInfo(_loc4_["item_materials"][_loc7_]);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.addEventListener(MouseEvent.ROLL_OVER,this.toolTiponOverMats,false,0,true);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.addEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.item_type = "Skill";
                     this["item_" + _loc13_]["item_" + _loc7_].iconMC.tooltip = [_loc9_["skill_name"],_loc9_["skill_level"],_loc9_["skill_damage"],_loc9_["skill_cp_cost"],_loc9_["skill_cooldown"],_loc9_["skill_description"],_loc9_["skill_source"]];
                  }
                  this["item_" + _loc13_]["item_" + _loc7_].txt1.text = _loc12_;
                  this["item_" + _loc13_]["item_" + _loc7_].txt2.text = _loc4_["item_mat_price"][_loc7_];
                  if(int(_loc12_) >= int(_loc4_["item_mat_price"][_loc7_]))
                  {
                     _loc11_++;
                  }
                  _loc7_++;
               }
               if(_loc4_["item_materials"].length == 1)
               {
                  if(_loc11_ >= _loc4_["item_materials"].length)
                  {
                     this["item_" + _loc13_].statusMC.gotoAndStop(1);
                     this["item_" + _loc13_].forgeBtn.visible = true;
                     this["item_" + _loc13_].forgeBtn.addEventListener(MouseEvent.CLICK,this.onForgeItemRequest);
                  }
                  else
                  {
                     this["item_" + _loc13_].statusMC.gotoAndStop(2);
                     this["item_" + _loc13_].forgeBtn.visible = false;
                  }
               }
               else if(_loc11_ >= _loc4_["item_materials"].length)
               {
                  this["item_" + _loc13_].statusMC.gotoAndStop(1);
                  this["item_" + _loc13_].forgeBtn.visible = true;
                  this["item_" + _loc13_].forgeBtn.addEventListener(MouseEvent.CLICK,this.onForgeItemRequest);
               }
               else
               {
                  this["item_" + _loc13_].statusMC.gotoAndStop(2);
                  this["item_" + _loc13_].forgeBtn.visible = false;
               }
               param1++;
               _loc13_++;
            }
         }
         _loc13_ = null;
         _loc7_ = null;
         _loc11_ = null;
         _loc12_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc9_ = null;
      }
      
      public function onForgeItemRequest(param1:MouseEvent) : *
      {
         this.main.loading(true);
         var _loc2_:* = int(param1.currentTarget.parent.name.replace("item_",""));
         var _loc3_:* = this.curr_page_items[_loc2_];
         this.main.amf_manager.service("JDEUnbiWJXOtHxVv.WIgUDPjy3IxY",[Character.char_id,Character.sessionkey,_loc3_],this.onForgeItemResponse);
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
      
      function calculateWeapon(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = Character.character_weapons.split(",");
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc2_ = _loc3_[_loc4_].split(":"))[0] == param1)
            {
               _loc5_ = _loc2_[1];
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      function calculateBackItem(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = Character.character_back_items.split(",");
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc2_ = _loc3_[_loc4_].split(":"))[0] == param1)
            {
               _loc5_ = _loc2_[1];
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      function calculateMat(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = Character.character_materials.split(",");
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc2_ = _loc3_[_loc4_].split(":"))[0] == param1)
            {
               return _loc2_[1];
            }
            _loc4_++;
         }
         return 0;
      }
      
      public function loadSkillSWF(param1:String, param2:*) : void
      {
         var object:* = undefined;
         var itemId:String = param1;
         var holder:* = param2;
         var item:String = itemId;
         object = holder;
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):*
         {
            param1.target.removeEventListener(param1.type,arguments.callee);
            item_completeIcon(param1,object);
         },false,0,true);
         loader.load(new URLRequest(Util.url("skills/" + item + ".swf")));
      }
      
      public function loadIconSWF(param1:String, param2:*) : void
      {
         var object:* = undefined;
         var itemId:String = param1;
         var holder:* = param2;
         var item:String = itemId;
         object = holder;
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):*
         {
            param1.target.removeEventListener(param1.type,arguments.callee);
            item_completeIcon(param1,object);
         },false,0,true);
         loader.load(new URLRequest(Util.url("items/" + item + ".swf")));
      }
      
      public function loadMaterialSWF(param1:String, param2:*) : void
      {
         var object:* = undefined;
         var itemId:String = param1;
         var holder:* = param2;
         var item:String = itemId;
         object = holder;
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):*
         {
            param1.target.removeEventListener(param1.type,arguments.callee);
            item_completeIcon(param1,object);
         },false,0,true);
         loader.load(new URLRequest(Util.url("materials/" + item + ".swf")));
      }
      
      public function item_completeIcon(param1:*, param2:*) : void
      {
         var _loc3_:Class = param1.target.applicationDomain.getDefinition("icon") as Class;
         var _loc4_:* = new _loc3_();
         param2.iconHolder.addChild(_loc4_);
      }
      
      function toolTiponOver(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.parent.name;
         _loc2_ = _loc2_.replace("item_","");
         var _loc3_:* = "";
         var _loc4_:* = this.array_info_holder[int(_loc2_)];
         switch(this.orig_indicator)
         {
            case "Weapon":
               _loc3_ = "" + _loc4_[0] + "\n(Weapon)\n" + "\nLevel " + _loc4_[1] + "\nDamage : " + _loc4_[2] + "\n\n" + _loc4_[3];
               break;
            case "Set":
               _loc3_ = "" + _loc4_[0] + "\n(Clothing)\n" + "\nLevel " + _loc4_[1] + "\n\n" + _loc4_[2];
               break;
            case "BackItem":
               _loc3_ = "" + _loc4_[0] + "\n(Back Item)\n" + "\nLevel " + _loc4_[1] + "\n\n" + _loc4_[2];
               break;
            case "Accessory":
               _loc3_ = "" + _loc4_[0] + "\n(Accessory)\n" + "\nLevel " + _loc4_[1] + "\n\n" + _loc4_[2];
               break;
            case "Hairstyle":
               _loc3_ = "" + _loc4_[0] + "\n(Hairstyle)\n" + "\nLevel " + _loc4_[1] + "\n\n" + _loc4_[2];
               break;
            case "Skill":
               _loc3_ = "" + _loc4_[0] + "\n(Skill)\n" + "\nLevel " + _loc4_[1] + "\nDamage: " + _loc4_[2] + "\nCP Cost: " + _loc4_[3] + "\nCooldown: " + _loc4_[4] + "\n\n" + _loc4_[5];
               break;
            case "Pet":
               _loc3_ = "" + _loc4_[0] + "\n(Pet)\n" + "\nLevel " + _loc4_[1] + "\n\n" + _loc4_[2];
               break;
            case "Material":
               _loc3_ = "" + _loc4_[0] + "\n(Material)\n" + "\nLevel " + _loc4_[1] + "\n\n" + _loc4_[2];
         }
         if(_loc4_ && _loc4_.length > 0)
         {
            _loc3_ += ItemDropSourceMapping.formatSourceText(_loc4_[_loc4_.length - 1]);
         }
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc3_);
      }
      
      function toolTiponOverMats(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.parent.name;
         var _loc3_:* = param1.currentTarget.tooltip;
         _loc2_ = _loc2_.replace("item_","");
         var _loc4_:* = "";
         switch(param1.currentTarget.item_type)
         {
            case "Weapon":
               _loc4_ = "" + _loc3_[0] + "\n(Weapon)\n" + "\nLevel " + _loc3_[1] + "\nDamage : " + _loc3_[2] + "\n\n" + _loc3_[3];
               break;
            case "Set":
               _loc4_ = "" + _loc3_[0] + "\n(Clothing)\n" + "\nLevel " + _loc3_[1] + "\n\n" + _loc3_[2];
               break;
            case "BackItem":
               _loc4_ = "" + _loc3_[0] + "\n(Back Item)\n" + "\nLevel " + _loc3_[1] + "\n\n" + _loc3_[2];
               break;
            case "Accessory":
               _loc4_ = "" + _loc3_[0] + "\n(Accessory)\n" + "\nLevel " + _loc3_[1] + "\n\n" + _loc3_[2];
               break;
            case "Hairstyle":
               _loc4_ = "" + _loc3_[0] + "\n(Hairstyle)\n" + "\nLevel " + _loc3_[1] + "\n\n" + _loc3_[2];
               break;
            case "Skill":
               _loc4_ = "" + _loc3_[0] + "\n(Skill)\n" + "\nLevel " + _loc3_[1] + "\nDamage: " + _loc3_[2] + "\nCP Cost: " + _loc3_[3] + "\nCooldown: " + _loc3_[4] + "\n\n" + _loc3_[5];
               break;
            case "Pet":
               _loc4_ = "" + _loc3_[0] + "\n(Pet)\n" + "\nLevel " + _loc3_[1] + "\n\n" + _loc3_[2];
               break;
            case "Material":
               _loc4_ = "" + _loc3_[0] + "\n(Material)\n" + "\nLevel " + _loc3_[1] + "\n\n" + _loc3_[2];
         }
         if(_loc3_ && _loc3_.length > 0)
         {
            _loc4_ += ItemDropSourceMapping.formatSourceText(_loc3_[_loc3_.length - 1]);
         }
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc4_);
      }
      
      function toolTiponOut(param1:MouseEvent) : void
      {
         this.tooltip.hide();
      }
      
      function killEverything() : void
      {
         this.main.handleVillageHUDVisibility(true);
         this.clearSlots();
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.mcWeapon.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcWeapon.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcWeapon.removeEventListener(MouseEvent.CLICK,this.click);
         this.mcSet.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcSet.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcSet.removeEventListener(MouseEvent.CLICK,this.click);
         this.mcBackItem.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcBackItem.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcBackItem.removeEventListener(MouseEvent.CLICK,this.click);
         this.mcAccessory.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcAccessory.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcAccessory.removeEventListener(MouseEvent.CLICK,this.click);
         this.mcHairstyle.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcHairstyle.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcHairstyle.removeEventListener(MouseEvent.CLICK,this.click);
         this.mcSkill.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcSkill.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcSkill.removeEventListener(MouseEvent.CLICK,this.click);
         this.mcPet.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.mcPet.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.mcPet.removeEventListener(MouseEvent.CLICK,this.click);
         this.nextPageBtn.removeEventListener(MouseEvent.CLICK,this.changePage);
         this.prevPageBtn.removeEventListener(MouseEvent.CLICK,this.changePage);
         this["item_0"].iconMc.removeEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver);
         this["item_0"].iconMc.removeEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut);
         this["item_1"].iconMc.removeEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver);
         this["item_1"].iconMc.removeEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut);
         this["item_2"].iconMc.removeEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver);
         this["item_2"].iconMc.removeEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut);
         this["item_0"].skillIconMc.removeEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver);
         this["item_0"].skillIconMc.removeEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut);
         this["item_1"].skillIconMc.removeEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver);
         this["item_1"].skillIconMc.removeEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut);
         this["item_2"].skillIconMc.removeEventListener(MouseEvent.ROLL_OVER,this.toolTiponOver);
         this["item_2"].skillIconMc.removeEventListener(MouseEvent.ROLL_OUT,this.toolTiponOut);
         this.mcWeapon.buttonMode = false;
         this.mcSet.buttonMode = false;
         this.mcBackItem.buttonMode = false;
         this.mcAccessory.buttonMode = false;
         this.mcHairstyle.buttonMode = false;
         this.mcSkill.buttonMode = false;
         this.tooltip = null;
         this.main = null;
         this.array_info_holder = null;
         System.gc();
      }
      
      function closePanel(param1:MouseEvent = null) : void
      {
         this.killEverything();
         parent.removeChild(this);
      }
   }
}
