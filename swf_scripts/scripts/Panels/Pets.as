package Panels
{
   import Managers.ExpManager;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.PreviewManager;
   import Storage.Character;
   import Storage.Library;
   import Storage.PetInfo;
   import Storage.PetLearnRequirements;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3918")]
   public class Pets extends MovieClip
   {
      
      public var btn_clearSearch:SimpleButton;
      
      public var btn_combine:SimpleButton;
      
      public var btn_feed:SimpleButton;
      
      public var btn_preview:SimpleButton;
      
      public var btn_search:SimpleButton;
      
      public var btn_set_level:SimpleButton;
      
      public var btn_show:MovieClip;
      
      public var btn_to_page:SimpleButton;
      
      public var clickMask_1:MovieClip;
      
      public var clickMask_2:MovieClip;
      
      public var clickMask_3:MovieClip;
      
      public var clickMask_4:MovieClip;
      
      public var clickMask_5:MovieClip;
      
      public var clickMask_6:MovieClip;
      
      public var txt_goToPage:TextField;
      
      public var txt_search:TextField;
      
      private var escapeKey:EscapeKeyManager;
      
      public var Tooltip_Pet_Agility:MovieClip;
      
      public var Tooltip_Pet_Critical:MovieClip;
      
      public var Tooltip_Pet_Damage:MovieClip;
      
      public var Tooltip_Pet_Dodge:MovieClip;
      
      public var renameMc:MovieClip;
      
      public var feederMC:MovieClip;
      
      public var agilityTxt:TextField;
      
      public var btn_close:SimpleButton;
      
      public var btn_delete:SimpleButton;
      
      public var btn_equip:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_rename:SimpleButton;
      
      public var btn_unequip:SimpleButton;
      
      public var btn_pet:SimpleButton;
      
      public var confMC:MovieClip;
      
      public var criticalTxt:TextField;
      
      public var damageTxt:TextField;
      
      public var dodgeTxt:TextField;
      
      public var hpBar:MovieClip;
      
      public var hpTxt:TextField;
      
      public var lbl_agility:TextField;
      
      public var lbl_critical:TextField;
      
      public var lbl_damage:TextField;
      
      public var lbl_dodge:TextField;
      
      public var lbl_hp:TextField;
      
      public var lbl_lv:TextField;
      
      public var lbl_mp:TextField;
      
      public var lbl_xp:TextField;
      
      public var lvTxt:TextField;
      
      public var mpBar:MovieClip;
      
      public var mpTxt:TextField;
      
      public var nameTxt:TextField;
      
      public var pet_mc:MovieClip;
      
      public var skill_1:MovieClip;
      
      public var skill_1_lvTxt:TextField;
      
      public var skill_2:MovieClip;
      
      public var skill_2_lvTxt:TextField;
      
      public var skill_3:MovieClip;
      
      public var skill_3_lvTxt:TextField;
      
      public var skill_4:MovieClip;
      
      public var skill_4_lvTxt:TextField;
      
      public var skill_5:MovieClip;
      
      public var skill_5_lvTxt:TextField;
      
      public var skill_6:MovieClip;
      
      public var skill_6_lvTxt:TextField;
      
      public var slot_0:MovieClip;
      
      public var slot_1:MovieClip;
      
      public var slot_2:MovieClip;
      
      public var slot_3:MovieClip;
      
      public var txt_page:TextField;
      
      public var xpBar:MovieClip;
      
      public var xpTxt:TextField;
      
      public var main:*;
      
      public var tooltip:ToolTip = ToolTip.getInstance();
      
      public var pets:Array = [];
      
      public var array_info_holder:Array = [];
      
      public var curr_page:int = 1;
      
      public var total_page:int = 1;
      
      public var curr_pagefood:int = 1;
      
      public var total_pagefood:int = 1;
      
      public var selectedFood:Object;
      
      public var selected_pet_index:int = -1;
      
      public var selected_pet_slot_index:int = -1;
      
      public var pet_bskill:* = -1;
      
      public var learn_method:* = "";
      
      public var namePet:*;
      
      public var pet_body:*;
      
      public var amount:int = 1;
      
      public var price:int = 200;
      
      public var cost:int = 0;
      
      private var confirmation:*;
      
      private var self:Pets;
      
      public var preview:MovieClip;
      
      public var preview_mc:PreviewManager;
      
      public var selected_pet_id:*;
      
      public var total_labels:*;
      
      public var eventHandler:* = new EventHandler();
      
      public var original_pet_array:* = [];
      
      public var combinable_pet_array:* = [];
      
      public var ownedFood:Array = [];
      
      public var usableFood:Array = Library.getFoodIds();
      
      public var feedablePet:Array = PetInfo.getCombinePet();
      
      public var petInfo:Object;
      
      public var loaderSwf:BulkLoader = BulkLoader.createUniqueNamedLoader(12);
      
      public function Pets(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClose);
         this.escapeKey.addListener(this.preview,this.closePreview);
         this.main = param1;
         this.self = this;
         this.init();
         this.renameMc.visible = false;
         this.feederMC.visible = false;
         this.preview.visible = false;
         this.btn_show.filter_on.visible = false;
      }
      
      public function init() : *
      {
         this.confMC.visible = false;
         this.txt_goToPage.restrict = "0-9";
         this.setupButtons();
         this.setupSlots();
         this.setupSkills();
         this.getPets();
      }
      
      public function getPets() : *
      {
         this.main.loading(true);
         var _loc1_:Array = [Character.char_id,Character.sessionkey];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["ba5tOM3HhspX",_loc1_],this.onGetPets);
      }
      
      public function sortPetsByLevel(param1:Array) : Array
      {
         var pets:Array = param1;
         pets.sort(function(param1:Object, param2:Object):int
         {
            var _loc3_:Boolean = param1.pet_id == Character.character_pet_id;
            var _loc4_:Boolean = param2.pet_id == Character.character_pet_id;
            if(_loc3_)
            {
               return -1;
            }
            if(_loc4_)
            {
               return 1;
            }
            if(param1.pet_level > param2.pet_level)
            {
               return -1;
            }
            if(param1.pet_level < param2.pet_level)
            {
               return 1;
            }
            return 0;
         });
         return pets;
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
               this.onClose();
               return;
            }
            this.pets = this.sortPetsByLevel(param1.pets);
            this.original_pet_array = this.pets;
            _loc2_ = 0;
            while(_loc2_ < this.original_pet_array.length)
            {
               if(this.feedablePet.indexOf(this.original_pet_array[_loc2_].pet_swf) > -1)
               {
                  this.combinable_pet_array.push(this.original_pet_array[_loc2_]);
               }
               _loc2_++;
            }
            this.curr_page = 1;
            this.total_page = Math.max(Math.ceil(this.pets.length / 4),1);
            this.displayPets();
            this.updatePageText();
            this.onSelectPet(0);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function displayPets(param1:* = 0) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.setupSlots(false);
         var _loc4_:* = 0;
         while(_loc4_ < 4)
         {
            _loc2_ = _loc4_ + int(int(this.curr_page - 1) * 4);
            if(this.pets.length > _loc2_)
            {
               _loc3_ = Character.character_pet_id == this.pets[_loc2_].pet_id ? true : false;
               this["slot_" + _loc4_].visible = true;
               this["slot_" + _loc4_].nameTxt.text = this.pets[_loc2_].pet_name;
               this["slot_" + _loc4_].levelTxt.text = this.pets[_loc2_].pet_level;
               this["slot_" + _loc4_].iconActive.visible = _loc3_;
            }
            else
            {
               this["slot_" + _loc4_].visible = false;
            }
            _loc4_++;
         }
      }
      
      public function updatePageText() : *
      {
         this.txt_page.text = this.curr_page + "/" + this.total_page;
      }
      
      public function setupSlots(param1:Boolean = true) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 4)
         {
            this["slot_" + _loc2_].visible = false;
            this["slot_" + _loc2_].gotoAndStop(1);
            if(param1)
            {
               this.eventHandler.addListener(this["slot_" + _loc2_],MouseEvent.CLICK,this.onSelectPet);
               this.eventHandler.addListener(this["slot_" + _loc2_],MouseEvent.MOUSE_OUT,this.onOutPetSlot);
               this.eventHandler.addListener(this["slot_" + _loc2_],MouseEvent.MOUSE_OVER,this.onOverPetSlot);
            }
            _loc2_++;
         }
      }
      
      public function setupSkills() : *
      {
         var _loc1_:* = 1;
         while(_loc1_ < 7)
         {
            this["skill_" + _loc1_].gotoAndStop(1);
            this["skill_" + _loc1_ + "_lvTxt"].text = "";
            if(this["skill_" + _loc1_].numChildren == 6)
            {
               this["skill_" + _loc1_].removeChildAt(5);
            }
            this.setSkill(false,this["skill_" + _loc1_]);
            this.eventHandler.removeListener(this["clickMask_" + _loc1_],MouseEvent.CLICK,this.onLearnSkill);
            this.eventHandler.addListener(this["clickMask_" + _loc1_],MouseEvent.MOUSE_OUT,this.onOutPetSkill,false,0,true);
            this.eventHandler.addListener(this["clickMask_" + _loc1_],MouseEvent.MOUSE_OVER,this.onOverPetSkill,false,0,true);
            _loc1_++;
         }
      }
      
      public function onOverPetSkill(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = int(param1.currentTarget.name.replace("clickMask_","")) - 1;
         if(this.array_info_holder.length > _loc3_ && this.array_info_holder[_loc3_][0] != null)
         {
            _loc2_ = "" + this.array_info_holder[_loc3_][0] + "\n(Skill)\n" + "\nLevel: " + this.array_info_holder[_loc3_][1] + "\n<font color=\"#ffcc00\">Cooldown: " + this.array_info_holder[_loc3_][3] + "</font>\n\n" + this.array_info_holder[_loc3_][2];
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_loc2_);
         }
      }
      
      public function onLearnSkill(param1:MouseEvent) : *
      {
         this.confMC.visible = true;
         this.eventHandler.addListener(this.confMC.btn_learn_1,MouseEvent.CLICK,this.onLearnSkillAMF);
         this.eventHandler.addListener(this.confMC.btn_learn_2,MouseEvent.CLICK,this.onLearnSkillAMF);
         this.eventHandler.addListener(this.confMC.btn_close,MouseEvent.CLICK,this.onCloseConf);
         var _loc2_:* = int(param1.currentTarget.name.replace("clickMask_",""));
         this.pet_bskill = _loc2_;
         var _loc3_:Object = PetLearnRequirements.getSkillRequirements(_loc2_);
         this.confMC.level_1.text = Character.getMaterialAmount("material_01");
         this.confMC.level_2.text = Character.getMaterialAmount("material_02");
         this.confMC.level_3.text = Character.getMaterialAmount("material_03");
         this.confMC.level_4.text = Character.getMaterialAmount("material_04");
         this.confMC.level_5.text = Character.getMaterialAmount("material_05");
         this.confMC.mc1.level_1.text = _loc3_.material_01;
         this.confMC.mc1.level_2.text = _loc3_.material_02;
         this.confMC.mc1.level_3.text = _loc3_.material_03;
         this.confMC.mc1.level_4.text = _loc3_.material_04;
         this.confMC.mc1.level_5.text = _loc3_.material_05;
         this.confMC.mc1.goldTxt.text = _loc3_.golds;
         this.confMC.mc2.tokenTxt.text = _loc3_.tokens;
      }
      
      public function onLearnSkillAMF(param1:MouseEvent) : *
      {
         this.learn_method = param1.currentTarget.name == "btn_learn_1" ? "mc1" : "mc2";
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id,this.pet_bskill,this.learn_method];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["tl4aVjDDTLri",_loc2_],this.onSkillLearnAMFResponse);
      }
      
      public function onSkillLearnAMFResponse(param1:Object) : *
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this.main.getNotice(param1.result);
               return;
            }
            _loc2_ = PetLearnRequirements.getSkillRequirements(this.pet_bskill);
            if(this.learn_method == "mc1")
            {
               Character.character_gold = String(Number(Character.character_gold) - _loc2_.golds);
               _loc3_ = 0;
               while(_loc3_ < 5)
               {
                  if(_loc2_["material_0" + (_loc3_ + 1)] > 0)
                  {
                     Character.removeMaterials("material_0" + (_loc3_ + 1),_loc2_["material_0" + (_loc3_ + 1)]);
                  }
                  _loc3_++;
               }
            }
            else
            {
               Character.account_tokens = int(Character.account_tokens) - _loc2_.tokens;
            }
            this.main.HUD.setBasicData();
            this.init();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function onCloseConf(param1:MouseEvent) : *
      {
         this.confMC.visible = false;
      }
      
      public function onOutPetSkill(param1:MouseEvent) : *
      {
         this.tooltip.hide();
      }
      
      public function onOutPetSlot(param1:MouseEvent) : *
      {
         var _loc2_:* = int(param1.currentTarget.name.replace("slot_",""));
         if(this.selected_pet_slot_index != _loc2_)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      public function onOverPetSlot(param1:MouseEvent) : *
      {
         var _loc2_:* = int(param1.currentTarget.name.replace("slot_",""));
         if(this.selected_pet_slot_index != _loc2_)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      public function onSelectPet(param1:* = null) : *
      {
         if(param1 is MouseEvent)
         {
            if(this.selected_pet_slot_index != -1)
            {
               this["slot_" + this.selected_pet_slot_index].gotoAndStop(1);
            }
            this.selected_pet_slot_index = int(param1.currentTarget.name.replace("slot_",""));
            this.selected_pet_index = this.selected_pet_slot_index + int(int(this.curr_page - 1) * 4);
            param1.currentTarget.gotoAndStop(3);
         }
         else
         {
            this.selected_pet_slot_index = param1;
            this.selected_pet_index = this.selected_pet_slot_index + int(int(this.curr_page - 1) * 4);
            this["slot_" + this.selected_pet_slot_index].gotoAndStop(3);
         }
         var _loc2_:int = this.selected_pet_index;
         var _loc3_:int = int(this.pets[_loc2_].pet_level);
         var _loc4_:String = this.pets[_loc2_].pet_name;
         var _loc5_:int = int(this.pets[_loc2_].pet_mp);
         var _loc6_:int = int(this.pets[_loc2_].pet_xp);
         var _loc7_:int = ExpManager.calculate_pet_xp(int(_loc3_));
         var _loc8_:int = int(this.pets[_loc2_].pet_id);
         var _loc9_:Boolean = Character.character_pet_id == _loc8_ ? true : false;
         var _loc10_:Boolean = false;
         this.nameTxt.text = _loc4_;
         this.hpTxt.text = 60 + _loc3_ * 40 + " / " + (60 + _loc3_ * 40);
         this.mpTxt.text = _loc5_ + " / 100";
         this.lvTxt.text = String(_loc3_);
         this.xpTxt.text = _loc6_ + " / " + _loc7_;
         this.mpBar.scaleX = _loc5_ / 100;
         this.xpBar.scaleX = _loc6_ / _loc7_;
         this.damageTxt.text = String(_loc3_ * 3);
         this.criticalTxt.text = "5%";
         this.dodgeTxt.text = "5%";
         this.agilityTxt.text = String(int(_loc3_) + 9);
         this.btn_unequip.visible = false;
         this.btn_equip.visible = false;
         this.btn_feed.visible = false;
         this.btn_set_level.visible = false;
         this.btn_combine.visible = false;
         if(_loc9_)
         {
            this.btn_unequip.visible = true;
            this.btn_rename.visible = true;
         }
         else
         {
            this.btn_equip.visible = true;
            this.btn_rename.visible = true;
         }
         var _loc11_:int = 0;
         while(_loc11_ < this.feedablePet.length)
         {
            if(this.pets[_loc2_].pet_swf == this.feedablePet[_loc11_])
            {
               _loc10_ = true;
               break;
            }
            _loc11_++;
         }
         if(_loc10_)
         {
            this.btn_feed.visible = true;
            this.btn_combine.visible = true;
            this.eventHandler.addListener(this.btn_feed,MouseEvent.CLICK,this.openPetFeeder);
            this.eventHandler.addListener(this.btn_combine,MouseEvent.CLICK,this.openPetCombine);
         }
         this.selected_pet_id = this.pets[_loc2_].pet_swf;
         this.loadAndDisplayPetSkills();
      }
      
      public function initPreview(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.loadPetAndPreview(this.selected_pet_id);
      }
      
      public function loadPetAndPreview(param1:*) : *
      {
         var _loc2_:* = "pets/" + param1 + ".swf";
         var _loc3_:* = this.loaderSwf.add(_loc2_);
         _loc3_.addEventListener(BulkLoader.COMPLETE,this.completePreview);
         this.loaderSwf.start();
      }
      
      public function completePreview(param1:Event) : void
      {
         this.main.loading(false);
         this.petInfo = PetInfo.getPetStats(this.selected_pet_id);
         var _loc2_:MovieClip = param1.target.content[this.selected_pet_id];
         this.preview_mc = new PreviewManager(this.main,_loc2_,this.petInfo);
         this.total_labels = this.preview_mc.preview_mc.currentLabels.length - 4;
         this.showPreview();
      }
      
      public function showPreview() : *
      {
         this.preview.visible = true;
         this.preview.petMc.addChild(this.preview_mc.preview_mc);
         this.preview_mc.preview_mc.gotoAndPlay("standby");
         var _loc1_:* = 1;
         var _loc2_:* = 1;
         while(_loc2_ <= 6)
         {
            this.preview["attack_0" + _loc2_].visible = false;
            _loc2_++;
         }
         while(_loc1_ <= this.total_labels)
         {
            this.preview["attack_0" + _loc1_].visible = true;
            this.main.initButton(this.preview["attack_0" + _loc1_],this.playSkillAnimation,"Skill " + _loc1_);
            this.main.initButton(this.preview.dodge,this.playSkillAnimation,"Dodge");
            this.main.initButton(this.preview.hit,this.playSkillAnimation,"Hit");
            this.main.initButton(this.preview.dead,this.playSkillAnimation,"Dead");
            _loc1_++;
         }
         this.eventHandler.addListener(this.preview.exitBtn,MouseEvent.CLICK,this.closePreview);
      }
      
      public function playSkillAnimation(param1:MouseEvent) : *
      {
         var _loc4_:String = null;
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:int = int(param1.currentTarget.name.replace("attack_","")) - 1;
         if(_loc3_ != -1)
         {
            _loc4_ = this.petInfo.attacks[_loc3_].name;
            this.main.showMessage(_loc4_);
            _loc4_ = null;
         }
         this.preview_mc.preview_mc.gotoAndPlay(_loc2_);
      }
      
      public function closePreview(param1:MouseEvent) : *
      {
         if(this.preview_mc)
         {
            this.preview_mc.destroy();
         }
         OutfitManager.removeChildsFromMovieClips(this.preview.petMc);
         this.preview.visible = false;
         this.petInfo = null;
         this.preview_mc = null;
      }
      
      public function loadAndDisplayPetSkills() : *
      {
         var pet_swf:String = null;
         var pet_level:int = 0;
         var pet_skills:Array = null;
         pet_swf = null;
         pet_level = 0;
         pet_skills = null;
         pet_swf = this.pets[this.selected_pet_index].pet_swf;
         pet_level = int(this.pets[this.selected_pet_index].pet_level);
         pet_skills = this.pets[this.selected_pet_index].pet_skills.split(",");
         var swfPath:* = "pets/" + pet_swf + ".swf";
         var loadItem:* = this.loaderSwf.add(swfPath);
         loadItem.addEventListener(BulkLoader.COMPLETE,function(param1:Event):*
         {
            petLoaded(param1,pet_swf,pet_skills,pet_level);
         });
         this.loaderSwf.start();
      }
      
      public function petLoaded(param1:*, param2:*, param3:*, param4:*) : void
      {
         var s:* = undefined;
         var event:* = param1;
         var petSwf:* = param2;
         var petSkills:* = param3;
         var petLevel:* = param4;
         var csk_mc:* = undefined;
         s = undefined;
         var info:* = undefined;
         var e:* = event;
         var pet_swf:* = petSwf;
         var pet_skills:* = petSkills;
         var pet_level:* = petLevel;
         var butn:MovieClip = e.target.content.PetStaticFullBody;
         e.target.content[pet_swf].gotoAndStop(1);
         GF.removeAllChild(this.pet_body);
         this.pet_body = null;
         this.pet_body = butn;
         GF.removeAllChild(this.pet_mc);
         this.pet_body.scaleX = 1.5;
         this.pet_body.scaleY = 1.5;
         this.pet_mc.addChild(this.pet_body);
         this.setupSkills();
         this.array_info_holder = [];
         info = PetInfo.getPetStats(pet_swf);
         s = 0;
         while(s < pet_skills.length)
         {
            try
            {
               csk_mc = e.target.content["Skill_" + s];
               csk_mc.gotoAndStop(1);
               if(info)
               {
                  this["skill_" + (int(s) + 1) + "_lvTxt"].text = "Lv. " + info.attacks[s].level;
                  if(pet_level >= info.attacks[s].level)
                  {
                     this["skill_" + (int(s) + 1)].gotoAndStop(3);
                     this["skill_" + (int(s) + 1)].addChild(csk_mc);
                     this.array_info_holder.push([info.attacks[s].name,info.attacks[s].level,info.attacks[s].description,info.attacks[s].cooldown]);
                     if(pet_skills[s] == 1)
                     {
                        this.setSkill(true,this["skill_" + (int(s) + 1)]);
                     }
                     else
                     {
                        this.eventHandler.addListener(this["clickMask_" + (int(s) + 1)],MouseEvent.CLICK,this.onLearnSkill);
                        this["skill_" + (int(s) + 1)].gotoAndStop(2);
                     }
                  }
                  else
                  {
                     this.array_info_holder.push([null,null,null]);
                     this["skill_" + (int(s) + 1)].gotoAndStop(2);
                  }
               }
               else
               {
                  this.array_info_holder.push([null,null,null]);
                  this["skill_" + (int(s) + 1)].gotoAndStop(1);
               }
            }
            catch(e:*)
            {
               array_info_holder.push([null,null,null]);
               this["skill_" + (int(s) + 1)].gotoAndStop(1);
            }
            s++;
         }
      }
      
      public function setSkill(param1:Boolean, param2:*) : *
      {
         var _loc3_:Color = new Color();
         _loc3_.brightness = param1 ? Number(0) : Number(-0.5);
         param2.transform.colorTransform = _loc3_;
      }
      
      public function setupButtons() : *
      {
         this.btn_equip.visible = false;
         this.btn_unequip.visible = false;
         this.btn_rename.visible = false;
         this.renameMc.visible = false;
         this.btn_set_level.visible = false;
         this.btn_feed.visible = false;
         this.btn_combine.visible = false;
         this.eventHandler.addListener(this.btn_equip,MouseEvent.CLICK,this.onEquipPet);
         this.eventHandler.addListener(this.btn_unequip,MouseEvent.CLICK,this.onUnequipPet);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.onClose);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_rename,MouseEvent.CLICK,this.renamePet);
         this.eventHandler.addListener(this.btn_delete,MouseEvent.CLICK,this.deleteConfirmation);
         this.eventHandler.addListener(this.btn_preview,MouseEvent.CLICK,this.initPreview);
         this.eventHandler.addListener(this.btn_to_page,MouseEvent.CLICK,this.goToPage);
         this.eventHandler.addListener(this.btn_search,MouseEvent.CLICK,this.searchPet);
         this.eventHandler.addListener(this.btn_clearSearch,MouseEvent.CLICK,this.clearSearch);
         this.eventHandler.addListener(this.btn_show,MouseEvent.CLICK,this.showCombinablePet);
         NinjaSage.showDynamicTooltip(this.btn_show.filter_on,"Combinable pets");
         NinjaSage.showDynamicTooltip(this.btn_show.filter_off,"All pets");
      }
      
      private function showCombinablePet(param1:MouseEvent) : void
      {
         this.btn_show.filter_on.visible = !this.btn_show.filter_on.visible;
         this.pets = this.btn_show.filter_on.visible ? this.combinable_pet_array : this.original_pet_array;
         this.total_page = Math.max(Math.ceil(this.pets.length / 4),1);
         this.curr_page = 1;
         this.updatePageText();
         this.displayPets();
      }
      
      public function openPetFeeder(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         this.feederMC.visible = true;
         this.eventHandler.addListener(this.feederMC.btn_close,MouseEvent.CLICK,this.closeFeeder);
         this.eventHandler.addListener(this.feederMC.btn_prev,MouseEvent.CLICK,this.changePageFeed);
         this.eventHandler.addListener(this.feederMC.btn_next,MouseEvent.CLICK,this.changePageFeed);
         var _loc2_:* = Character.getMaterialsAsArray();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_].split(":")[0];
            if(this.searchFood(_loc4_,this.usableFood))
            {
               this.ownedFood.push(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
         this.total_pagefood = Math.max(Math.ceil(this.ownedFood.length / 10),1);
         this.updatePageNumber();
         this.showFoodIcon();
      }
      
      public function showFoodIcon() : *
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = _loc1_ + int(int(this.curr_pagefood - 1) * 10);
            this.feederMC["feed_" + _loc1_].visible = false;
            if(this.ownedFood.length > _loc2_)
            {
               this.feederMC["feed_" + _loc1_].visible = true;
               this.feederMC["feed_" + _loc1_].txt_qty.visible = false;
               this.feederMC["feed_" + _loc1_].icon.ownedTxt.visible = false;
               this.feederMC["feed_" + _loc1_].icon.amtTxt.text = "x" + this.ownedFood[_loc2_].split(":")[1];
               this.feederMC["feed_" + _loc1_].btn_feed.metaData = {
                  "food_id":this.ownedFood[_loc2_].split(":")[0],
                  "food_qty":this.ownedFood[_loc2_].split(":")[1],
                  "food_index":_loc2_,
                  "food_iteration":_loc1_
               };
               this.eventHandler.addListener(this.feederMC["feed_" + _loc1_].btn_feed,MouseEvent.CLICK,this.petFeedAMF);
               NinjaSage.loadItemIcon(this.feederMC["feed_" + _loc1_].icon,this.ownedFood[_loc2_].split(":")[0]);
            }
            _loc1_++;
         }
         this.updatePageNumber();
         this.total_pagefood = Math.max(Math.ceil(this.ownedFood.length / 10),1);
      }
      
      public function petFeedAMF(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.selectedFood = param1.currentTarget.metaData;
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id,this.selectedFood.food_id];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["Gw1ftCxOVoCy",_loc2_],this.petFeedResponse);
      }
      
      public function petFeedResponse(param1:Object) : *
      {
         var _loc2_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.removeMaterials(this.selectedFood.food_id,1);
            _loc2_ = int(this.ownedFood[this.selectedFood.food_index].split(":")[1]) - 1;
            this.ownedFood[this.selectedFood.food_index] = this.selectedFood.food_id + ":" + _loc2_;
            this.pets[this.selected_pet_index].pet_mp = param1.mp;
            this.feederMC["feed_" + this.selectedFood.food_iteration].icon.amtTxt.text = "x" + this.ownedFood[this.selectedFood.food_index].split(":")[1];
            this.mpTxt.text = this.pets[this.selected_pet_index].pet_mp + " / 100";
            this.mpBar.scaleX = this.pets[this.selected_pet_index].pet_mp / 100;
            this.main.showMessage("Pet successfuly fed");
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
      
      public function changePageFeed(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_pagefood > this.curr_pagefood)
               {
                  ++this.curr_pagefood;
                  this.showFoodIcon();
               }
               break;
            case "btn_prev":
               if(this.curr_pagefood > 1)
               {
                  --this.curr_pagefood;
                  this.showFoodIcon();
               }
         }
      }
      
      public function updatePageNumber() : *
      {
         this.feederMC.txt_page.text = this.curr_pagefood + "/" + this.total_pagefood;
      }
      
      public function searchFood(param1:*, param2:Array) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_] == param1)
            {
               _loc3_ = true;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function closeFeeder(param1:MouseEvent) : *
      {
         this.feederMC.visible = false;
         this.ownedFood = [];
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            GF.removeAllChild(this.feederMC["feed_" + _loc2_].icon.rewardIcon.holder);
            GF.removeAllChild(this.feederMC["feed_" + _loc2_].icon.skillIcon.holder);
            this.eventHandler.removeListener(this.feederMC["feed_" + _loc2_].btn_feed,MouseEvent.CLICK,this.petFeedAMF);
            _loc2_++;
         }
         this.eventHandler.removeListener(this.feederMC.btn_close,MouseEvent.CLICK,this.closeFeeder);
      }
      
      public function openPetCombine(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("PetCombination","PetCombination");
         this.onClose();
      }
      
      public function setMaxLevel(param1:MouseEvent) : *
      {
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["0p9GX07AefPo",_loc2_],this.onsetMaxLevel);
      }
      
      public function onsetMaxLevel(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(this.pets[this.selected_pet_index].pet_name + " Level Successfully Upgraded!");
            this.getPets();
         }
         else if(param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage("Unknown error");
         }
      }
      
      public function goToPage(param1:MouseEvent) : *
      {
         if(int(this.txt_goToPage.text) > this.total_page)
         {
            return;
         }
         this.curr_page = int(this.txt_goToPage.text);
         this.displayPets();
         this.updatePageText();
      }
      
      public function searchPet(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         if(this.txt_search.text == "")
         {
            return;
         }
         this.pets = this.original_pet_array;
         var _loc2_:Array = [];
         var _loc3_:String = this.txt_search.text.toLowerCase();
         var _loc5_:* = 0;
         while(_loc5_ < this.pets.length)
         {
            _loc4_ = this.pets[_loc5_].pet_name;
            if(_loc4_.toLowerCase().indexOf(_loc3_) >= 0)
            {
               _loc2_.push(this.pets[_loc5_]);
            }
            _loc5_++;
         }
         this.btn_show.filter_on.visible = false;
         this.pets = _loc2_;
         this.total_page = Math.max(Math.ceil(this.pets.length / 4),1);
         this.curr_page = 1;
         this.updatePageText();
         this.displayPets();
      }
      
      public function clearSearch(param1:MouseEvent) : *
      {
         this.txt_search.text = "";
         this.txt_goToPage.text = "";
         this.pets = this.original_pet_array;
         this.curr_page = 1;
         this.total_page = Math.max(Math.ceil(this.pets.length / 4),1);
         this.updatePageText();
         this.displayPets();
      }
      
      public function deleteConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = getDefinitionByName("Popups.Confirmation") as Class;
         this.confirmation = new this.confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to delete " + this.pets[this.selected_pet_index].pet_name + "?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            removeChild(self.confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onDeleteAMF);
         addChild(this.confirmation);
      }
      
      public function onDeleteAMF(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["tfrD84gTyxPN",_loc2_],this.onDeleteAMFResponse);
      }
      
      public function onDeleteAMFResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(this.pets[this.selected_pet_index].pet_name + " Successfully Deleted!");
            this.getPets();
         }
         else if(param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.showMessage("Unknown error");
         }
      }
      
      public function renamePet(param1:MouseEvent) : *
      {
         this.renameMc.visible = true;
         this.renameMc.txt_badges.text = Character.getEssentialAmount("essential_01");
         this.renameMc.buyItemMC.visible = false;
         this.namePet = this.renameMc.txt_name.text;
         this.eventHandler.addListener(this.renameMc.btn_close,MouseEvent.CLICK,this.closeRename);
         this.eventHandler.addListener(this.renameMc.btn_rename,MouseEvent.CLICK,this.onRenameReq);
         this.eventHandler.addListener(this.renameMc.btn_getBadge,MouseEvent.CLICK,this.buyItem);
         this.renameMc.charHolder.scaleX = 1;
         this.renameMc.charHolder.scaleY = 1;
         NinjaSage.loadIconSWF("pets",this.pets[this.selected_pet_index].pet_swf,this.renameMc.charHolder,"PetStaticFullBody");
      }
      
      public function closeRename(param1:MouseEvent) : void
      {
         this.renameMc.visible = false;
         GF.removeAllChild(this.renameMc.charHolder);
      }
      
      public function buyItem(param1:MouseEvent) : *
      {
         this.renameMc.buyItemMC.visible = true;
         this.eventHandler.addListener(this.renameMc.buyItemMC.btnClose,MouseEvent.CLICK,this.onClose);
         this.eventHandler.addListener(this.renameMc.buyItemMC.btnNext,MouseEvent.CLICK,this.changeAmount);
         this.eventHandler.addListener(this.renameMc.buyItemMC.btnPrev,MouseEvent.CLICK,this.changeAmount);
         this.cost = this.price * this.amount;
         this.renameMc.buyItemMC.numTxt.text = this.amount;
         this.renameMc.buyItemMC.tokenCost.txt_token.text = this.cost;
         this.eventHandler.addListener(this.renameMc.buyItemMC.buyBtn,MouseEvent.CLICK,this.buyBadge);
      }
      
      internal function changeAmount(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         if(this.amount < 1 && _loc2_ != "btnNext")
         {
            return;
         }
         if(_loc2_ == "btnNext")
         {
            this.amount += 1;
         }
         else
         {
            --this.amount;
         }
         this.cost = this.price * this.amount;
         this.renameMc.buyItemMC.numTxt.text = this.amount;
         this.renameMc.buyItemMC.tokenCost.txt_token.text = this.cost;
         this.eventHandler.addListener(this.renameMc.buyItemMC.buyBtn,MouseEvent.CLICK,this.buyBadge);
      }
      
      public function buyBadge(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.G1qj82TKIjdJ",[Character.sessionkey,Character.char_id,this.amount],this.onBuyBadge);
      }
      
      public function onBuyBadge(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(this.amount + " Rename Badge Succesfully Bought!");
            this.renameMc.txt_badges.text = param1.badge;
            this.main.HUD.setBasicData();
         }
         else
         {
            if(param1.status == 2)
            {
               this.main.showMessage("You Don\'t Have Enough Token");
               return;
            }
            this.main.showMessage(param1.error);
         }
      }
      
      public function onRenameReq(param1:MouseEvent) : *
      {
         var _loc2_:* = this.renameMc.txt_name.text;
         if(_loc2_ == "")
         {
            this.main.showMessage("Name cannot be empty!");
         }
         else
         {
            this.main.loading(true);
            this.main.amf_manager.service("q590e8VkpCrGuhvF.8ylcmRhd9YcG",[Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id,_loc2_],this.onRenameRes);
         }
      }
      
      public function onRenameRes(param1:Object) : *
      {
         var _loc2_:int = 0;
         this.main.loading(false);
         this.closeRename(null);
         if(param1.status == 1)
         {
            this.main.showMessage("Your Pet Name Has Been Changed!");
            this.renameMc.txt_name.text = "";
            _loc2_ = Character.account_type == 0 ? 3 : 1;
            Character.removeEssentials("essential_01",_loc2_);
            this.getPets();
         }
         else if(param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function onEquipPet(param1:MouseEvent) : *
      {
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["xHoUegxzspf8",_loc2_],this.onPetEquipped);
      }
      
      public function onUnequipPet(param1:MouseEvent) : *
      {
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["dqQVnP1A6v3U",_loc2_],this.onUnequippedPet);
      }
      
      public function onPetEquipped(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this.main.getNotice(param1.result);
               return;
            }
            Character.character_pet = param1.pet_swf;
            Character.character_pet_id = param1.pet_id;
            this.displayPets(this.selected_pet_slot_index);
            this.onSelectPet(this.selected_pet_slot_index);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function onUnequippedPet(param1:Object) : *
      {
         this.main.loading(false);
         Character.character_pet = "";
         Character.character_pet_id = 0;
         this.displayPets(this.selected_pet_slot_index);
         this.onSelectPet(this.selected_pet_slot_index);
      }
      
      public function onDeletePet(param1:MouseEvent) : *
      {
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_page > this.curr_page)
               {
                  ++this.curr_page;
                  this.displayPets();
               }
               break;
            case "btn_prev":
               if(this.curr_page > 1)
               {
                  --this.curr_page;
                  this.displayPets();
               }
         }
         this.updatePageText();
      }
      
      public function onClose(param1:MouseEvent = null) : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         var _loc2_:* = 1;
         while(_loc2_ < 7)
         {
            GF.removeAllChild(this["skill_" + _loc2_]);
            _loc2_++;
         }
         GF.removeAllChild(this.pet_mc);
         GF.removeAllChild(this.preview.petMc);
         GF.removeAllChild(this.pet_body);
         NinjaSage.clearDynamicTooltip(this.btn_show.filter_on);
         NinjaSage.clearDynamicTooltip(this.btn_show.filter_off);
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.tooltip = null;
         this.pets = [];
         this.original_pet_array = [];
         this.combinable_pet_array = [];
         this.array_info_holder = [];
         this.curr_page = 1;
         this.total_page = 1;
         this.selected_pet_index = -1;
         this.selected_pet_slot_index = -1;
         this.pet_bskill = -1;
         this.learn_method = "";
         this.namePet = null;
         this.pet_body = null;
         this.amount = 1;
         this.price = 200;
         this.cost = 0;
         this.confirmation = null;
         this.self = null;
         this.preview = null;
         this.preview_mc = null;
         this.selected_pet_id = null;
         this.total_labels = null;
         GF.removeAllChild(this);
         System.gc();
      }
   }
}

