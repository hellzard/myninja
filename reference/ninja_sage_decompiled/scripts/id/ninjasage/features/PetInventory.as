package id.ninjasage.features
{
   import Managers.OutfitManager;
   import Managers.StatManager;
   import Storage.Character;
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
   
   public class PetInventory extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var Tooltip_Pet_Agility:MovieClip;
      
      public var Tooltip_Pet_Critical:MovieClip;
      
      public var Tooltip_Pet_Damage:MovieClip;
      
      public var Tooltip_Pet_Dodge:MovieClip;
      
      public var renameMc:MovieClip;
      
      public var agilityTxt:TextField;
      
      public var btn_close:SimpleButton;
      
      public var btn_delete:SimpleButton;
      
      public var btn_equip:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_rename:SimpleButton;
      
      public var btn_unequip:SimpleButton;
      
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
      
      public var _main;
      
      public var tooltip;
      
      public var pets:Array;
      
      public var array_info_holder:Array;
      
      public var curr_page:int = 1;
      
      public var total_page:int = 1;
      
      public var selected_pet_index:int = -1;
      
      public var selected_pet_slot_index:int = -1;
      
      public var pet_bskill = -1;
      
      public var learn_method = "";
      
      public var namePet;
      
      public var pet_head;
      
      public var amount:int = 1;
      
      public var price:int = 200;
      
      public var cost:int = 0;
      
      private var confirmation;
      
      private var self;
      
      public var preview:MovieClip;
      
      public var preview_mc;
      
      public var selected_pet_id;
      
      public var total_labels;
      
      public var eventHandler;
      
      public var original_pet_array;
      
      public var parent_wardrobe;
      
      public var loaderSwf;
      
      public function PetInventory(param1:*, param2:*, param3:*)
      {
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.pets = [];
         this.original_pet_array = [];
         this.array_info_holder = [];
         super();
         this._main = param1;
         this.panelMC = param2;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.onClose);
         this.escapeKey.addListener(this.panelMC.preview,this.closePreview);
         this.parent_wardrobe = param3;
         this.self = this;
         this.init();
         this.panelMC.renameMc.visible = false;
         this.panelMC.preview.visible = false;
      }
      
      public function init() : *
      {
         this.tooltip = ToolTip.getInstance();
         this.eventHandler = new EventHandler();
         this.panelMC.confMC.visible = false;
         this.panelMC.txt_goToPage.restrict = "0-9";
         this.setupButtons();
         this.setupSlots();
         this.setupSkills();
         this.getPets();
      }
      
      public function getPets() : *
      {
         this._main.loading(true);
         var _loc1_:Array = [Character.char_id,Character.sessionkey];
         this._main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["ba5tOM3HhspX",_loc1_],this.onGetPets);
      }
      
      public function onGetPets(param1:Object) : *
      {
         this._main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this.onClose();
               this._main.getNotice(param1.result);
               return;
            }
            this.pets = param1.pets;
            this.original_pet_array = param1.pets;
            this.curr_page = 1;
            this.total_page = Math.max(Math.ceil(this.pets.length / 4),1);
            this.displayPets();
            this.updatePageText();
         }
         else
         {
            this._main.getError(param1.error);
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
               _loc3_ = PresetData.preset_pet_id == this.pets[_loc2_].pet_id ? true : false;
               this.panelMC["slot_" + _loc4_].visible = true;
               this.panelMC["slot_" + _loc4_].nameTxt.text = this.pets[_loc2_].pet_name;
               this.panelMC["slot_" + _loc4_].levelTxt.text = this.pets[_loc2_].pet_level;
               this.panelMC["slot_" + _loc4_].iconActive.visible = _loc3_;
            }
            else
            {
               this.panelMC["slot_" + _loc4_].visible = false;
            }
            _loc4_++;
         }
         this.onSelectPet(param1);
      }
      
      public function updatePageText() : *
      {
         this.panelMC.txt_page.text = this.curr_page + "/" + this.total_page;
      }
      
      public function setupSlots(param1:Boolean = true) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 4)
         {
            this.panelMC["slot_" + _loc2_].visible = false;
            this.panelMC["slot_" + _loc2_].gotoAndStop(1);
            if(param1)
            {
               this.eventHandler.addListener(this.panelMC["slot_" + _loc2_],MouseEvent.CLICK,this.onSelectPet);
               this.eventHandler.addListener(this.panelMC["slot_" + _loc2_],MouseEvent.MOUSE_OUT,this.onOutPetSlot);
               this.eventHandler.addListener(this.panelMC["slot_" + _loc2_],MouseEvent.MOUSE_OVER,this.onOverPetSlot);
            }
            _loc2_++;
         }
      }
      
      public function setupSkills() : *
      {
         var _loc1_:* = 1;
         while(_loc1_ < 7)
         {
            this.panelMC["skill_" + _loc1_].gotoAndStop(1);
            this.panelMC["skill_" + _loc1_ + "_lvTxt"].text = "";
            if(this.panelMC["skill_" + _loc1_].numChildren == 6)
            {
               this.panelMC["skill_" + _loc1_].removeChildAt(5);
            }
            this.setSkill(false,this.panelMC["skill_" + _loc1_]);
            this.panelMC["skill_" + _loc1_].removeEventListener(MouseEvent.CLICK,this.onLearnSkill);
            this.eventHandler.addListener(this.panelMC["skill_" + _loc1_],MouseEvent.MOUSE_OUT,this.onOutPetSkill,false,0,true);
            this.eventHandler.addListener(this.panelMC["skill_" + _loc1_],MouseEvent.MOUSE_OVER,this.onOverPetSkill,false,0,true);
            _loc1_++;
         }
      }
      
      public function onOverPetSkill(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = int(param1.currentTarget.name.replace("skill_","")) - 1;
         if(this.array_info_holder.length > _loc3_ && this.array_info_holder[_loc3_][0] != null)
         {
            _loc2_ = "" + this.array_info_holder[_loc3_][0] + "\n(Skill)\n" + "\nLevel: " + this.array_info_holder[_loc3_][1] + "\n<font color=\"#ffcc00\">Cooldown: " + this.array_info_holder[_loc3_][3] + "</font>\n\n" + this.array_info_holder[_loc3_][2];
            this._main.stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_loc2_);
         }
      }
      
      public function onLearnSkill(param1:MouseEvent) : *
      {
         this.panelMC.confMC.visible = true;
         this.eventHandler.addListener(this.panelMC.confMC.btn_learn_1,MouseEvent.CLICK,this.onLearnSkillAMF);
         this.eventHandler.addListener(this.panelMC.confMC.btn_learn_2,MouseEvent.CLICK,this.onLearnSkillAMF);
         this.eventHandler.addListener(this.panelMC.confMC.btn_close,MouseEvent.CLICK,this.onCloseConf);
         var _loc2_:* = int(param1.currentTarget.name.replace("skill_",""));
         this.pet_bskill = _loc2_;
         var _loc3_:Object = PetLearnRequirements.getSkillRequirements(_loc2_);
         this.panelMC.confMC.level_1.text = Character.getMaterialAmount("material_01");
         this.panelMC.confMC.level_2.text = Character.getMaterialAmount("material_02");
         this.panelMC.confMC.level_3.text = Character.getMaterialAmount("material_03");
         this.panelMC.confMC.level_4.text = Character.getMaterialAmount("material_04");
         this.panelMC.confMC.level_5.text = Character.getMaterialAmount("material_05");
         this.panelMC.confMC.mc1.level_1.text = _loc3_.material_01;
         this.panelMC.confMC.mc1.level_2.text = _loc3_.material_02;
         this.panelMC.confMC.mc1.level_3.text = _loc3_.material_03;
         this.panelMC.confMC.mc1.level_4.text = _loc3_.material_04;
         this.panelMC.confMC.mc1.level_5.text = _loc3_.material_05;
         this.panelMC.confMC.mc1.goldTxt.text = _loc3_.golds;
         this.panelMC.confMC.mc2.tokenTxt.text = _loc3_.tokens;
      }
      
      public function onLearnSkillAMF(param1:MouseEvent) : *
      {
         this.learn_method = param1.currentTarget.name == "btn_learn_1" ? "mc1" : "mc2";
         this._main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id,this.pet_bskill,this.learn_method];
         this._main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["tl4aVjDDTLri",_loc2_],this.onSkillLearnAMFResponse);
      }
      
      public function onSkillLearnAMFResponse(param1:Object) : *
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         this._main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this._main.getNotice(param1.result);
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
            this._main.HUD.setBasicData();
            this.init();
         }
         else
         {
            this._main.getError(param1.error);
         }
      }
      
      public function onCloseConf(param1:MouseEvent) : *
      {
         this.panelMC.confMC.visible = false;
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
               this.panelMC["slot_" + this.selected_pet_slot_index].gotoAndStop(1);
            }
            this.selected_pet_slot_index = int(param1.currentTarget.name.replace("slot_",""));
            this.selected_pet_index = this.selected_pet_slot_index + int(int(this.curr_page - 1) * 4);
            param1.currentTarget.gotoAndStop(3);
         }
         else
         {
            this.selected_pet_slot_index = param1;
            this.selected_pet_index = this.selected_pet_slot_index + int(int(this.curr_page - 1) * 4);
            this.panelMC["slot_" + this.selected_pet_slot_index].gotoAndStop(3);
         }
         var _loc2_:* = this.selected_pet_index;
         var _loc3_:* = 60 + this.pets[_loc2_].pet_level * 40;
         var _loc4_:* = 60 + this.pets[_loc2_].pet_level * 40;
         this.panelMC.nameTxt.text = this.pets[_loc2_].pet_name;
         this.panelMC.hpTxt.text = _loc3_;
         this.panelMC.mpTxt.text = _loc4_;
         this.panelMC.lvTxt.text = this.pets[_loc2_].pet_level;
         this.panelMC.xpTxt.text = this.pets[_loc2_].pet_xp + "/" + StatManager.calculate_pet_xp(int(this.pets[_loc2_].pet_level));
         this.panelMC.xpBar.scaleX = this.pets[_loc2_].pet_xp / StatManager.calculate_pet_xp(int(this.pets[_loc2_].pet_level));
         this.panelMC.damageTxt.text = String(this.pets[_loc2_].pet_level * 3);
         this.panelMC.criticalTxt.text = "5%";
         this.panelMC.dodgeTxt.text = "5%";
         this.panelMC.agilityTxt.text = String(int(this.pets[_loc2_].pet_level) + 11);
         var _loc5_:* = PresetData.preset_pet_id == this.pets[_loc2_].pet_id ? true : false;
         this.panelMC.btn_unequip.visible = false;
         this.panelMC.btn_equip.visible = false;
         if(_loc5_)
         {
            this.panelMC.btn_unequip.visible = true;
            this.panelMC.btn_rename.visible = true;
         }
         else
         {
            this.panelMC.btn_equip.visible = true;
            this.panelMC.btn_rename.visible = true;
         }
         this.selected_pet_id = this.pets[_loc2_].pet_swf;
         this.loadAndDisplayPetSkills();
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
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Class = param1.target.getDefinitionByName(this.selected_pet_id) as Class;
         var _loc4_:* = this.selected_pet_id;
         var _loc5_:*;
         (_loc5_ = PetInfo.getPetStats(this.selected_pet_id)).pet_skills = "";
         var _loc6_:MovieClip;
         (_loc6_ = new _loc3_(this,"player_pet",0,_loc5_)).pet_hp = 0;
         _loc6_.scaleX = -0.8;
         _loc6_.scaleY = 0.8;
         this.total_labels = _loc6_.currentLabels.length - 4;
         this.preview_mc = _loc6_;
      }
      
      public function showPreview(param1:MouseEvent) : *
      {
         this.panelMC.preview.visible = true;
         var _loc2_:* = this.panelMC.preview.petMc.addChild(this.preview_mc);
         _loc2_.gotoAndPlay("standby");
         var _loc3_:* = 1;
         var _loc4_:* = 1;
         while(_loc4_ <= 6)
         {
            this.preview["attack_0" + _loc4_].visible = false;
            _loc4_++;
         }
         while(_loc3_ <= this.total_labels)
         {
            this.preview["attack_0" + _loc3_].visible = true;
            this._main.initButton(this.preview["attack_0" + _loc3_],this.playSkillAnimation,"Skill " + _loc3_);
            this._main.initButton(this.panelMC.preview.dodge,this.playSkillAnimation,"Dodge");
            this._main.initButton(this.panelMC.preview.hit,this.playSkillAnimation,"Hit");
            this._main.initButton(this.panelMC.preview.dead,this.playSkillAnimation,"Dead");
            _loc3_++;
         }
         this.eventHandler.addListener(this.panelMC.preview.exitBtn,MouseEvent.CLICK,this.closePreview);
      }
      
      public function playSkillAnimation(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         this.preview_mc.gotoAndPlay(_loc2_);
      }
      
      public function hitByPet() : *
      {
      }
      
      public function petAttacked() : *
      {
      }
      
      public function closePreview(param1:MouseEvent) : *
      {
         OutfitManager.removeChildsFromMovieClips(this.panelMC.preview.petMc);
         this.panelMC.preview.visible = false;
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
         pet_level = this.pets[this.selected_pet_index].pet_level;
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
         var loadEvent:* = param1;
         var petSwf:* = param2;
         var petSkills:* = param3;
         var petLevel:* = param4;
         var csk_mc:* = undefined;
         s = undefined;
         var info:* = undefined;
         var e:* = loadEvent;
         var pet_swf:* = petSwf;
         var pet_skills:* = petSkills;
         var pet_level:* = petLevel;
         var butn:* = e.target.content["PetStaticFullBody"];
         e.target.content[pet_swf].gotoAndStop(1);
         this.pet_head = butn;
         if(this.panelMC.pet_mc.numChildren > 0)
         {
            this.panelMC.pet_mc.removeChildAt(0);
         }
         butn.scaleX = 1.5;
         butn.scaleY = 1.5;
         this.panelMC.pet_mc.addChild(butn);
         this.setupSkills();
         this.array_info_holder = [];
         info = PetInfo.getPetStats(pet_swf);
         s = 0;
         for(; s < pet_skills.length; s++)
         {
            try
            {
               csk_mc = e.target.content["Skill_" + s];
               if(info)
               {
                  this.panelMC["skill_" + (int(s) + 1) + "_lvTxt"].text = "Lv. " + info.attacks[s].level;
                  if(pet_level >= info.attacks[s].level)
                  {
                     this.panelMC["skill_" + (int(s) + 1)].gotoAndStop(3);
                     this.panelMC["skill_" + (int(s) + 1)].addChild(csk_mc);
                     this.array_info_holder.push([info.attacks[s].name,info.attacks[s].level,info.attacks[s].description,info.attacks[s].cooldown]);
                     if(pet_skills[s] == 1)
                     {
                        this.setSkill(true,this.panelMC["skill_" + (int(s) + 1)]);
                     }
                     else
                     {
                        this.eventHandler.addListener(this.panelMC["skill_" + (int(s) + 1)],MouseEvent.CLICK,this.onLearnSkill);
                        this.panelMC["skill_" + (int(s) + 1)].gotoAndStop(2);
                     }
                  }
                  else
                  {
                     this.array_info_holder.push([null,null,null]);
                     this.panelMC["skill_" + (int(s) + 1)].gotoAndStop(2);
                  }
               }
               else
               {
                  this.array_info_holder.push([null,null,null]);
                  this.panelMC["skill_" + (int(s) + 1)].gotoAndStop(1);
               }
            }
            catch(e:*)
            {
               array_info_holder.push([null,null,null]);
               this.panelMC["skill_" + (int(s) + 1)].gotoAndStop(1);
               continue;
            }
         }
      }
      
      public function setSkill(param1:Boolean, param2:*) : *
      {
         var _loc3_:Color = new Color();
         _loc3_.brightness = !!param1 ? Number(Number(0)) : Number(Number(-0.5));
         param2.transform.colorTransform = _loc3_;
      }
      
      public function setupButtons() : *
      {
         this.panelMC.btn_equip.visible = false;
         this.panelMC.btn_unequip.visible = false;
         this.panelMC.btn_rename.visible = true;
         this.panelMC.btn_preview.visible = false;
         this.panelMC.renameMc.visible = false;
         this.eventHandler.addListener(this.panelMC.btn_equip,MouseEvent.CLICK,this.onEquipPet);
         this.eventHandler.addListener(this.panelMC.btn_unequip,MouseEvent.CLICK,this.onUnequipPet);
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.onClose);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_rename,MouseEvent.CLICK,this.renamePet);
         this.eventHandler.addListener(this.panelMC.btn_delete,MouseEvent.CLICK,this.deleteConfirmation);
         this.eventHandler.addListener(this.panelMC.btn_to_page,MouseEvent.CLICK,this.goToPage);
         this.eventHandler.addListener(this.panelMC.btn_search,MouseEvent.CLICK,this.searchPet);
         this.eventHandler.addListener(this.panelMC.btn_clearSearch,MouseEvent.CLICK,this.clearSearch);
      }
      
      public function setMaxLevel(param1:MouseEvent) : *
      {
         this._main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id];
         this._main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["0p9GX07AefPo",_loc2_],this.onsetMaxLevel);
      }
      
      public function onsetMaxLevel(param1:Object) : *
      {
         this._main.loading(false);
         if(param1.status == 1)
         {
            this._main.showMessage(this.pets[this.selected_pet_index].pet_name + " Level Successfully Upgraded!");
            this.getPets();
         }
         else if(param1.hasOwnProperty("result"))
         {
            this._main.showMessage(param1.result);
         }
         else
         {
            this._main.showMessage("Unknown error");
         }
      }
      
      public function goToPage(param1:MouseEvent) : *
      {
         if(int(this.panelMC.txt_goToPage.text) > this.total_page)
         {
            return;
         }
         this.curr_page = int(this.panelMC.txt_goToPage.text);
         this.displayPets();
         this.updatePageText();
      }
      
      public function searchPet(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         if(this.panelMC.txt_search.text == "")
         {
            return;
         }
         this.pets = this.original_pet_array;
         var _loc2_:Array = [];
         var _loc3_:String = this.panelMC.txt_search.text.toLowerCase();
         var _loc5_:* = 0;
         while(_loc5_ < this.pets.length)
         {
            if((_loc4_ = this.pets[_loc5_].pet_name).toLowerCase().indexOf(_loc3_) >= 0)
            {
               _loc2_.push(this.pets[_loc5_]);
            }
            _loc5_++;
         }
         this.pets = _loc2_;
         this.total_page = Math.max(Math.ceil(this.pets.length / 4),1);
         this.curr_page = 1;
         this.updatePageText();
         this.displayPets();
      }
      
      public function clearSearch(param1:MouseEvent) : *
      {
         this.panelMC.txt_search.text = "";
         this.panelMC.txt_goToPage.text = "";
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
         this._main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id];
         this._main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["tfrD84gTyxPN",_loc2_],this.onDeleteAMFResponse);
      }
      
      public function onDeleteAMFResponse(param1:Object) : *
      {
         this._main.loading(false);
         if(param1.status == 1)
         {
            this._main.showMessage(this.pets[this.selected_pet_index].pet_name + " Successfully Deleted!");
            this.getPets();
         }
         else if(param1.hasOwnProperty("result"))
         {
            this._main.showMessage(param1.result);
         }
         else
         {
            this._main.showMessage("Unknown error");
         }
      }
      
      public function renamePet(param1:MouseEvent) : *
      {
         this.panelMC.renameMc.visible = true;
         this.panelMC.renameMc.txt_badges.text = Character.getEssentialAmount("essential_01");
         this.panelMC.renameMc.buyItemMC.visible = false;
         this.namePet = this.panelMC.renameMc.txt_name.text;
         this.eventHandler.addListener(this.panelMC.renameMc.btn_close,MouseEvent.CLICK,this.onClose);
         this.eventHandler.addListener(this.panelMC.renameMc.btn_rename,MouseEvent.CLICK,this.onRenameReq);
         this.eventHandler.addListener(this.panelMC.renameMc.btn_getBadge,MouseEvent.CLICK,this.buyItem);
         this.pet_head.x = 0;
         this.pet_head.y = 0;
         this.pet_head.scaleX = 0.2;
         this.pet_head.scaleY = 0.2;
         this.renameMc.charHolder.addChild(this.pet_head);
      }
      
      public function buyItem(param1:MouseEvent) : *
      {
         this.panelMC.renameMc.buyItemMC.visible = true;
         this.eventHandler.addListener(this.panelMC.renameMc.buyItemMC.btnClose,MouseEvent.CLICK,this.onClose);
         this.eventHandler.addListener(this.panelMC.renameMc.buyItemMC.btnNext,MouseEvent.CLICK,this.changeAmount);
         this.eventHandler.addListener(this.panelMC.renameMc.buyItemMC.btnPrev,MouseEvent.CLICK,this.changeAmount);
         this.cost = this.price * this.amount;
         this.panelMC.renameMc.buyItemMC.numTxt.text = this.amount;
         this.panelMC.renameMc.buyItemMC.tokenCost.txt_token.text = this.cost;
         this.eventHandler.addListener(this.panelMC.renameMc.buyItemMC.buyBtn,MouseEvent.CLICK,this.buyBadge);
      }
      
      function changeAmount(param1:MouseEvent) : void
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
         this.panelMC.renameMc.buyItemMC.numTxt.text = this.amount;
         this.panelMC.renameMc.buyItemMC.tokenCost.txt_token.text = this.cost;
         this.eventHandler.addListener(this.panelMC.renameMc.buyItemMC.buyBtn,MouseEvent.CLICK,this.buyBadge);
      }
      
      public function buyBadge(param1:MouseEvent) : *
      {
         this._main.loading(true);
         this._main.amf_manager.service("36a62s4oZ7iYRJjd.G1qj82TKIjdJ",[Character.sessionkey,Character.char_id,this.amount],this.onBuyBadge);
      }
      
      public function onBuyBadge(param1:Object) : *
      {
         this._main.loading(false);
         if(param1.status == 1)
         {
            this._main.showMessage(this.amount + " Rename Badge Succesfully Bought!");
            this.panelMC.renameMc.txt_badges.text = param1.badge;
            this._main.HUD.setBasicData();
         }
         else
         {
            if(param1.status == 2)
            {
               this._main.showMessage("You Don\'t Have Enough Token");
               return;
            }
            this._main.showMessage(param1.error);
         }
      }
      
      public function onRenameReq(param1:MouseEvent) : *
      {
         var _loc2_:* = this.panelMC.renameMc.txt_name.text;
         if(_loc2_ == "")
         {
            this._main.showMessage("Name cannot be empty!");
         }
         else
         {
            this._main.loading(true);
            this._main.amf_manager.service("q590e8VkpCrGuhvF.8ylcmRhd9YcG",[Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index].pet_id,_loc2_],this.onRenameRes);
         }
      }
      
      public function onRenameRes(param1:Object) : *
      {
         this._main.loading(false);
         if(param1.status == 1)
         {
            this._main.showMessage("Your Pet Name Has Been Changed!");
            this._main.loadPanel("Managers.LoginManager");
            this._main = null;
         }
         else if(param1.hasOwnProperty("result"))
         {
            this._main.showMessage(param1.result);
         }
         else
         {
            this._main.getError(param1.error);
         }
      }
      
      public function onEquipPet(param1:MouseEvent) : *
      {
         PresetData.preset_pet = this.pets[this.selected_pet_index].pet_swf;
         PresetData.preset_pet_id = this.pets[this.selected_pet_index].pet_id;
         this.displayPets(this.selected_pet_slot_index);
         this.parent_wardrobe.loadPetIconAndBody();
      }
      
      public function onUnequipPet(param1:MouseEvent) : *
      {
         PresetData.preset_pet = "";
         PresetData.preset_pet_id = 0;
         this.displayPets(this.selected_pet_slot_index);
         this.parent_wardrobe.loadPetIconAndBody();
      }
      
      public function onPetEquipped(param1:Object) : *
      {
         this._main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this._main.getNotice(param1.result);
               return;
            }
            PresetData.preset_pet = param1.pet_swf;
            PresetData.preset_pet_id = param1.pet_id;
            this.displayPets(this.selected_pet_slot_index);
         }
         else
         {
            this._main.getError(param1.error);
         }
      }
      
      public function onUnequippedPet(param1:Object) : *
      {
         this._main.loading(false);
         PresetData.preset_pet = "";
         PresetData.preset_pet_id = 0;
         this.displayPets(this.selected_pet_slot_index);
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
         var _loc2_:* = 1;
         while(_loc2_ < 7)
         {
            GF.removeAllChild(this.panelMC["skill_" + _loc2_]);
            _loc2_++;
         }
         GF.removeAllChild(this.panelMC.pet_mc);
         GF.removeAllChild(this.panelMC.preview.petMc);
         this.eventHandler.removeAllEventListeners();
         this.loaderSwf.clear();
         this.loaderSwf = null;
         this._main = null;
         this.tooltip = null;
         this.pets = [];
         this.original_pet_array = [];
         this.array_info_holder = [];
         this.curr_page = 1;
         this.total_page = 1;
         this.selected_pet_index = -1;
         this.selected_pet_slot_index = -1;
         this.pet_bskill = -1;
         this.learn_method = "";
         this.namePet = null;
         this.pet_head = null;
         this.amount = 1;
         this.price = 200;
         this.cost = 0;
         this.confirmation = null;
         this.self = null;
         this.preview = null;
         this.preview_mc = null;
         this.selected_pet_id = null;
         this.total_labels = null;
         this.panelMC.visible = false;
         System.gc();
      }
   }
}
