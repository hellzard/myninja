package Panels
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.PreviewManager;
   import Storage.Character;
   import Storage.ItemDropSourceMapping;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class UI_Skillset extends MovieClip
   {
       
      
      public var btn_filter:MovieClip;
      
      public var element_mc10:MovieClip;
      
      public var element_mc5:MovieClip;
      
      public var element_mc6:MovieClip;
      
      public var element_mc7:MovieClip;
      
      public var element_mc8:MovieClip;
      
      public var element_mc9:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_ResetSkill:SimpleButton;
      
      public var btn_add_preset:SimpleButton;
      
      public var btn_clear:SimpleButton;
      
      public var btn_clearSearch:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_close_slot0:SimpleButton;
      
      public var btn_close_slot1:SimpleButton;
      
      public var btn_close_slot2:SimpleButton;
      
      public var btn_close_slot3:SimpleButton;
      
      public var btn_close_slot4:SimpleButton;
      
      public var btn_close_slot5:SimpleButton;
      
      public var btn_close_slot6:SimpleButton;
      
      public var btn_close_slot7:SimpleButton;
      
      public var btn_help:SimpleButton;
      
      public var btn_randomizeSkill:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_preset_1:SimpleButton;
      
      public var btn_preset_2:SimpleButton;
      
      public var btn_preset_3:SimpleButton;
      
      public var btn_preset_4:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_preview:SimpleButton;
      
      public var btn_save:SimpleButton;
      
      public var btn_search:SimpleButton;
      
      public var btn_to_page:SimpleButton;
      
      public var element_mc0:MovieClip;
      
      public var element_mc1:MovieClip;
      
      public var element_mc2:MovieClip;
      
      public var element_mc3:MovieClip;
      
      public var element_mc4:MovieClip;
      
      public var item_0:MovieClip;
      
      public var item_1:MovieClip;
      
      public var item_10:MovieClip;
      
      public var item_11:MovieClip;
      
      public var item_2:MovieClip;
      
      public var item_3:MovieClip;
      
      public var item_4:MovieClip;
      
      public var item_5:MovieClip;
      
      public var item_6:MovieClip;
      
      public var item_7:MovieClip;
      
      public var item_8:MovieClip;
      
      public var item_9:MovieClip;
      
      public var preview:MovieClip;
      
      public var skillInfoMC:MovieClip;
      
      public var skill_0:MovieClip;
      
      public var skill_1:MovieClip;
      
      public var skill_2:MovieClip;
      
      public var skill_3:MovieClip;
      
      public var skill_4:MovieClip;
      
      public var skill_5:MovieClip;
      
      public var skill_6:MovieClip;
      
      public var skill_7:MovieClip;
      
      public var txt_goToPage:TextField;
      
      public var txt_page:TextField;
      
      public var txt_search:TextField;
      
      public var windSkills:Array;
      
      public var waterSkills:Array;
      
      public var fireSkills:Array;
      
      public var thunderSkills:Array;
      
      public var earthSkills:Array;
      
      public var taijutsuSkills:Array;
      
      public var genjutsuSkills:Array;
      
      public var clanSkills:Array;
      
      public var shadowwarSkills:Array;
      
      public var packageSkills:Array;
      
      public var leaderboardSkills:Array;
      
      public var spendingSkills:Array;
      
      public var crewSkills:Array;
      
      public var selectedCategory:Array;
      
      public var skillPreset:Array;
      
      public var skillIconMC:Array;
      
      public var equippedSkill:Array;
      
      public var currentPage:int = 1;
      
      public var totalPage:int = 1;
      
      public var skillIndex:int = 0;
      
      public var skillLoading:int = 0;
      
      public var skillCount:int = 0;
      
      public var equippedCount:int = 0;
      
      public var cost:int = 0;
      
      public var selectedPreset:int = 1;
      
      public var selectedSkill:String;
      
      public var currentElement:String;
      
      public var switchSkillIndexHolder:Array;
      
      public var eventHandler;
      
      public var tooltip;
      
      public var main;
      
      public var loaderSwf;
      
      public var glowFilter;
      
      public var confirmation;
      
      public var previewMC:PreviewManager;
      
      public var isDescription:Boolean = false;
      
      public function UI_Skillset(param1:*)
      {
         this.skillIconMC = [];
         this.equippedSkill = [];
         this.switchSkillIndexHolder = [];
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.windSkills = [];
         this.waterSkills = [];
         this.fireSkills = [];
         this.thunderSkills = [];
         this.earthSkills = [];
         this.taijutsuSkills = [];
         this.genjutsuSkills = [];
         this.clanSkills = [];
         this.shadowwarSkills = [];
         this.packageSkills = [];
         this.leaderboardSkills = [];
         this.spendingSkills = [];
         this.crewSkills = [];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.escapeKey.addListener(this.preview,this.closePreview);
         this.main = param1;
         this.tooltip = ToolTip.getInstance();
         this.eventHandler = new EventHandler();
         this.glowFilter = CreateFilter.getGlowFilter({
            "color":16776960,
            "strength":1000,
            "blurX":8,
            "blurY":8
         });
         this.getSkillSets();
         this.setOwnedSkillsArray();
         this.setElementCategory();
         this.initButton();
         this.initUI();
      }
      
      public function initUI() : *
      {
         this.preview.visible = false;
         this.skillInfoMC.visible = false;
         this.btn_preview.visible = false;
         this.btn_save.visible = false;
         this.btn_filter.filter_on.visible = false;
         this.txt_goToPage.restrict = "0-9";
         this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_1));
         this.equippedSkill = Character.character_skill_set.split(",")[0] == "" ? [] : Character.character_skill_set.split(",");
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 12),1);
         this.loadEquippedSkills();
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
         if(this.skillIndex < this.skillLoading)
         {
            _loc1_ = this.selectedCategory[this.skillIndex];
            _loc2_ = "skills/" + _loc1_ + ".swf";
            _loc3_ = this.loaderSwf.add(_loc2_);
            _loc3_.addEventListener(BulkLoader.COMPLETE,this.completeIcon);
            _loc3_.addEventListener(BulkLoader.ERROR,this.onItemLoadError);
            this.loaderSwf.start();
            return;
         }
         this.isLoading = false;
      }
      
      public function onItemLoadError(param1:ErrorEvent) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.completeIcon);
         this.skillIconMC[this.skillCount] = null;
         ++this.skillIndex;
         ++this.skillCount;
         this.loadSwf();
      }
      
      public function completeIcon(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onItemLoadError);
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         param1.target.content.stopAllMovieClips();
         _loc4_ = param1.target.content.icon;
         if(!Character.play_items_animation)
         {
            _loc4_.stopAllMovieClips();
         }
         this.skillIconMC.push(_loc4_);
         this["item_" + this.skillCount].iconMC.iconHolder.addChild(_loc4_);
         this["item_" + this.skillCount].gotoAndStop(1);
         this["item_" + this.skillCount].visible = true;
         var _loc5_:* = this.selectedCategory[this.skillIndex];
         param1.target.content[_loc5_].stopAllMovieClips();
         var _loc6_:* = SkillLibrary.getSkillInfo(_loc5_);
         this["item_" + this.skillCount].txt_name.text = _loc6_["skill_name"];
         this["item_" + this.skillCount].txt_level.text = _loc6_["skill_level"];
         if(int(Character.character_lvl) >= _loc6_["skill_level"])
         {
            this["item_" + this.skillCount]["btn_equip_skill"].visible = true;
            this["item_" + this.skillCount]["txt_equipped"].visible = false;
         }
         else
         {
            this["item_" + this.skillCount]["btn_equip_skill"].visible = false;
         }
         if(this.equippedSkill.indexOf(_loc5_) > -1)
         {
            this["item_" + this.skillCount]["btn_equip_skill"].visible = false;
            this["item_" + this.skillCount]["txt_equipped"].visible = true;
         }
         else
         {
            this["item_" + this.skillCount]["txt_equipped"].visible = false;
         }
         this["item_" + this.skillCount].tooltip = _loc6_;
         this.eventHandler.addListener(this["item_" + this.skillCount]["btn_equip_skill"],MouseEvent.CLICK,this.equipSkill);
         this.eventHandler.addListener(this["item_" + this.skillCount],MouseEvent.CLICK,this.showSkillDetail);
         this.eventHandler.addListener(this["item_" + this.skillCount],MouseEvent.ROLL_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this["item_" + this.skillCount],MouseEvent.ROLL_OUT,this.toolTiponOut);
         ++this.skillIndex;
         ++this.skillCount;
         this.loadSwf();
      }
      
      public function showSkillDetail(param1:MouseEvent) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 12)
         {
            this["item_" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         param1.currentTarget.gotoAndStop(3);
         var _loc3_:* = param1.currentTarget.name.replace("item_","");
         var _loc4_:* = param1.currentTarget.tooltip;
         this.skillInfoMC.visible = true;
         this.btn_preview.visible = true;
         this.selectedSkill = _loc4_.skill_id;
         GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
         NinjaSage.loadItemIcon(this.skillInfoMC.iconMC.iconHolder,this.selectedSkill,"icon");
         this.skillInfoMC.iconType.gotoAndStop(_loc4_.skill_type);
         this.skillInfoMC.txt_name.text = _loc4_.skill_name;
         this.skillInfoMC.txt_level.text = _loc4_.skill_level;
         this.skillInfoMC.txt_cp.text = _loc4_.skill_cp_cost;
         this.skillInfoMC.txt_dmg.text = _loc4_.skill_damage;
         this.skillInfoMC.txt_cd.text = _loc4_.skill_cooldown;
         this.skillInfoMC.txt_description.text = _loc4_.skill_description;
      }
      
      public function loadSkillAndPreview(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.resetPreviewHolder();
         var _loc2_:* = "skills/" + this.selectedSkill + ".swf";
         var _loc3_:* = this.loaderSwf.add(_loc2_);
         _loc3_.addEventListener(BulkLoader.COMPLETE,this.completePreview);
         this.loaderSwf.start();
      }
      
      public function completePreview(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.skill_info = SkillLibrary.getSkillInfo(this.selectedSkill);
         var _loc3_:* = param1.target.content[this.selectedSkill];
         this.previewMC = new PreviewManager(this.main,_loc3_,this.skill_info);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         this.main.loading(false);
         this.showPreview();
      }
      
      public function showPreview() : void
      {
         this.preview.visible = true;
         this.preview.skillMc.addChild(this.previewMC.preview_mc);
         this.previewMC.preview_mc.gotoAndPlay(2);
         this.eventHandler.addListener(this.preview.exitBtn,MouseEvent.CLICK,this.closePreview);
         this.eventHandler.addListener(this.preview.replayBtn,MouseEvent.CLICK,this.handleReplay);
      }
      
      public function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      public function closePreview(param1:MouseEvent) : void
      {
         this.resetPreviewHolder();
         this.preview.visible = false;
         GF.removeAllChild(this.preview.skillMc);
      }
      
      public function loadEquippedSkills() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.equippedCount < this.equippedSkill.length)
         {
            _loc1_ = "skills/" + this.equippedSkill[this.equippedCount] + ".swf";
            _loc2_ = this.loaderSwf.add(_loc1_);
            _loc2_.addEventListener(BulkLoader.COMPLETE,this.completeEquipIcon);
            this.loaderSwf.start();
            return;
         }
      }
      
      public function completeEquipIcon(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         GF.removeAllChild(this["skill_" + this.equippedCount].iconHolder);
         var _loc3_:MovieClip = param1.target.content.icon;
         this["skill_" + this.equippedCount].iconHolder.addChild(_loc3_);
         var _loc4_:* = SkillLibrary.getSkillInfo(this.equippedSkill[this.equippedCount]);
         param1.target.content[this.equippedSkill[this.equippedCount]].stopAllMovieClips();
         this["skill_" + this.equippedCount].tooltip = _loc4_;
         this.eventHandler.addListener(this["btn_close_slot" + this.equippedCount],MouseEvent.CLICK,this.removeEquippedSkill);
         this.eventHandler.addListener(this["skill_" + this.equippedCount],MouseEvent.MOUSE_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this["skill_" + this.equippedCount],MouseEvent.MOUSE_OUT,this.toolTiponOut);
         this["skill_" + this.equippedCount].selected = false;
         this.eventHandler.addListener(this["skill_" + this.equippedCount],MouseEvent.CLICK,this.selectSwitchingSkill);
         ++this.equippedCount;
         this.loadEquippedSkills();
      }
      
      public function selectSwitchingSkill(param1:MouseEvent) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         param1.currentTarget.filters = [this.glowFilter];
         var _loc2_:* = param1.currentTarget.name.replace("skill_","");
         if(param1.currentTarget.selected)
         {
            this.switchSkillIndexHolder = [];
            param1.currentTarget.selected = false;
            param1.currentTarget.filters = null;
            return;
         }
         param1.currentTarget.selected = true;
         this.switchSkillIndexHolder.push(_loc2_);
         if(this.switchSkillIndexHolder.length == 2)
         {
            this.tooltip.hide();
            _loc3_ = this.equippedSkill[this.switchSkillIndexHolder[0]];
            this.equippedSkill[this.switchSkillIndexHolder[0]] = this.equippedSkill[this.switchSkillIndexHolder[1]];
            this.equippedSkill[this.switchSkillIndexHolder[1]] = _loc3_;
            this.switchSkillIndexHolder = [];
            _loc4_ = 0;
            while(_loc4_ < 8)
            {
               this["skill_" + _loc4_].selected = false;
               this["skill_" + _loc4_].filters = null;
               _loc4_++;
            }
            this.resetRecursiveProperty();
            this.resetEquippedIconHolder();
            this.loadEquippedSkills();
         }
      }
      
      public function equipSkill(param1:MouseEvent) : *
      {
         if(this.equippedSkill.length >= 8)
         {
            return;
         }
         var _loc2_:int = param1.currentTarget.parent.name.replace("item_","");
         var _loc3_:int = _loc2_ + int(int(this.currentPage - 1) * 12);
         this["item_" + _loc2_].btn_equip_skill.visible = false;
         this["item_" + _loc2_].txt_equipped.visible = true;
         this["item_" + _loc2_].txt_equipped.text = "Equipped";
         this.equippedSkill.push(this.selectedCategory[_loc3_]);
         this.loadEquippedSkills();
      }
      
      public function removeEquippedSkill(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         var _loc2_:* = param1.currentTarget.name.replace("btn_close_slot","");
         if(_loc2_ >= this.equippedSkill.length)
         {
            return;
         }
         this.equippedSkill.splice(_loc2_,1);
         this.resetEquippedIconHolder();
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
         this.loadEquippedSkills();
      }
      
      public function removeAllEquippedSkill(param1:MouseEvent) : *
      {
         this.equippedSkill = [];
         this.resetEquippedIconHolder();
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
         this.loadEquippedSkills();
      }
      
      public function handleSearchFilter(param1:MouseEvent) : *
      {
         this.btn_filter.filter_on.visible = !this.btn_filter.filter_on.visible;
         this.isDescription = !!this.btn_filter.filter_on.visible ? true : false;
      }
      
      public function searchItem(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
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
            _loc5_ = this.selectedCategory[_loc6_];
            _loc4_ = SkillLibrary.getSkillInfo(_loc5_);
            if(this.isDescription)
            {
               if(_loc4_ && _loc4_.hasOwnProperty("skill_description") && _loc4_["skill_description"].toLowerCase().indexOf(_loc3_) >= 0)
               {
                  _loc2_.push(this.selectedCategory[_loc6_]);
               }
            }
            else if(_loc4_ && _loc4_.hasOwnProperty("skill_name") && _loc4_["skill_name"].toLowerCase().indexOf(_loc3_) >= 0)
            {
               _loc2_.push(this.selectedCategory[_loc6_]);
            }
            _loc6_++;
         }
         this.selectedCategory = _loc2_;
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 12),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
      }
      
      public function onSearchClear(param1:MouseEvent = null) : *
      {
         this.txt_search.text = "";
         this.txt_goToPage.text = "";
         if(this.currentElement == "wind")
         {
            this.selectedCategory = this.windSkills;
         }
         else if(this.currentElement == "water")
         {
            this.selectedCategory = this.waterSkills;
         }
         else if(this.currentElement == "fire")
         {
            this.selectedCategory = this.fireSkills;
         }
         else if(this.currentElement == "thunder")
         {
            this.selectedCategory = this.thunderSkills;
         }
         else if(this.currentElement == "earth")
         {
            this.selectedCategory = this.earthSkills;
         }
         else if(this.currentElement == "taijutsu")
         {
            this.selectedCategory = this.taijutsuSkills;
         }
         else if(this.currentElement == "genjutsu")
         {
            this.selectedCategory = this.genjutsuSkills;
         }
         else if(this.currentElement == "clan")
         {
            this.selectedCategory = this.clanSkills;
         }
         else if(this.currentElement == "shadowwar")
         {
            this.selectedCategory = this.shadowwarSkills;
         }
         else if(this.currentElement == "package")
         {
            this.selectedCategory = this.packageSkills;
         }
         else if(this.currentElement == "leaderboard")
         {
            this.selectedCategory = this.leaderboardSkills;
         }
         else if(this.currentElement == "spending")
         {
            this.selectedCategory = this.spendingSkills;
         }
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 12),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
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
      
      public function getSkillSets() : *
      {
         this.main.loading(false);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.1lU1LbLrP0DC",[Character.char_id,Character.sessionkey],this.getSkillSetsResponse);
      }
      
      public function getSkillSetsResponse(param1:Object) : *
      {
         var _loc3_:* = undefined;
         this.skillPreset = param1.skillsets;
         var _loc2_:* = 1;
         while(_loc2_ < 5)
         {
            this["btn_preset_" + _loc2_].visible = false;
            _loc2_++;
         }
         _loc2_ = 1;
         while(_loc2_ < this.skillPreset.length + 1)
         {
            _loc3_ = this.skillPreset[_loc2_ - 1].skills;
            if(_loc3_ == Character.character_skill_set)
            {
               this["btn_preset_" + _loc2_].filters = [this.glowFilter];
            }
            this["btn_preset_" + _loc2_].visible = true;
            this.eventHandler.addListener(this["btn_preset_" + _loc2_],MouseEvent.CLICK,this.changePreset);
            _loc2_++;
         }
         if(this.skillPreset.length == 4)
         {
            this.btn_add_preset.visible = false;
         }
         if(this.skillPreset.length >= 1)
         {
            this.btn_help.visible = true;
         }
         this.main.loading(false);
      }
      
      public function changePreset(param1:MouseEvent) : *
      {
         var _loc2_:* = 1;
         while(_loc2_ < 5)
         {
            this["btn_preset_" + _loc2_].filters = null;
            _loc2_++;
         }
         this.selectedPreset = int(param1.currentTarget.name.replace("btn_preset_",""));
         if(param1.currentTarget)
         {
            param1.currentTarget.filters = [this.glowFilter];
         }
         if(this.btn_save.visible != true)
         {
            this.btn_save.visible = true;
         }
         if(!this.btn_save.hasEventListener(MouseEvent.CLICK))
         {
            this.eventHandler.addListener(this.btn_save,MouseEvent.CLICK,this.savePreset);
         }
         this.equippedSkill = this.skillPreset[int(this.selectedPreset) - 1].skills.split(",");
         Character.character_skill_set = this.skillPreset[int(this.selectedPreset) - 1].skills;
         this.resetEquippedIconHolder();
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
         this.loadEquippedSkills();
      }
      
      public function savePreset(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.LqhBYt6LHZ3I",[Character.char_id,Character.sessionkey,this.skillPreset[this.selectedPreset - 1].id,this.equippedSkill.join(",")],this.savePresetResponse);
      }
      
      public function savePresetResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.skillPreset = param1.skillsets;
            Character.character_equipped_skills = this.equippedSkill.join(",");
            Character.character_skill_set = this.equippedSkill.join(",");
            this.main.showMessage("Preset has been saved");
         }
         else if(param1.result != null)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
            this.destroy();
         }
         this.loadEquippedSkills();
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
      }
      
      public function buyConfirmation(param1:MouseEvent) : *
      {
         if(Character.account_type == 1)
         {
            this.cost = 200;
         }
         else
         {
            this.cost = 600;
         }
         if(this.skillPreset.length == 0)
         {
            this.cost = 0;
         }
         this.confirmation = getDefinitionByName("Popups.Confirmation") as Class;
         this.confirmation = new this.confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to unlock new preset for " + this.cost + " token?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPreset);
         addChild(this.confirmation);
      }
      
      public function closeConfirmation(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
      }
      
      public function buyPreset(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.wWuZRrx1d6u4",[Character.char_id,Character.sessionkey],this.buyPresetResponse);
      }
      
      public function buyPresetResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Slot succesfully bought");
            this.skillPreset = param1.skillsets;
            _loc2_ = 1;
            while(_loc2_ < this.skillPreset.length + 1)
            {
               this["btn_preset_" + String(_loc2_)].visible = true;
               if(!this["btn_preset_" + String(_loc2_)].hasEventListener(MouseEvent.CLICK))
               {
                  this.eventHandler.addListener(this["btn_preset_" + String(_loc2_)],MouseEvent.CLICK,this.changePreset);
               }
               _loc2_++;
            }
            if(this.skillPreset.length == 4)
            {
               this.btn_add_preset.visible = false;
            }
            if(this.skillPreset.length >= 1)
            {
               this.btn_help.visible = true;
            }
            Character.account_tokens = int(Character.account_tokens) - this.cost;
            this.main.HUD.setBasicData();
         }
         else if(param1.result)
         {
            this.main.getNotice(param1.result);
         }
      }
      
      public function showHelp(param1:MouseEvent) : *
      {
         this.main.getNotice("You must select your preset first before editing skill preset and press Save Skill Button after editing skills, otherwise it won\'t be saved to your preset.");
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
                  this.loadSwf();
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
               this.loadSwf();
         }
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         if(this.loaderSwf.itemsLoaded >= 60)
         {
            this.loaderSwf.removeAll();
         }
         this.loadSwf();
      }
      
      public function updatePageNumber() : *
      {
         this.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      public function initButton() : *
      {
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_clear,MouseEvent.CLICK,this.removeAllEquippedSkill);
         this.eventHandler.addListener(this.btn_to_page,MouseEvent.CLICK,this.goToPage);
         this.eventHandler.addListener(this.btn_search,MouseEvent.CLICK,this.searchItem);
         this.eventHandler.addListener(this.btn_clearSearch,MouseEvent.CLICK,this.onSearchClear);
         this.eventHandler.addListener(this.btn_ResetSkill,MouseEvent.CLICK,this.openExternalPanel);
         this.eventHandler.addListener(this.btn_preview,MouseEvent.CLICK,this.loadSkillAndPreview);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_add_preset,MouseEvent.CLICK,this.buyConfirmation);
         this.eventHandler.addListener(this.btn_help,MouseEvent.CLICK,this.showHelp);
         this.eventHandler.addListener(this.btn_filter,MouseEvent.CLICK,this.handleSearchFilter);
         this.eventHandler.addListener(this.btn_randomizeSkill,MouseEvent.CLICK,this.confirmationRandomizeSkill);
         NinjaSage.showDynamicTooltip(this.btn_filter.filter_on,"Search by description");
         NinjaSage.showDynamicTooltip(this.btn_filter.filter_off,"Search by name");
         NinjaSage.showDynamicTooltip(this.btn_randomizeSkill,"Random skills");
         NinjaSage.showDynamicTooltip(this.btn_preview,"Preview skill");
      }
      
      public function setElementCategory() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 3)
         {
            this["element_mc" + _loc1_].visible = false;
            this["element_mc" + _loc1_].gotoAndStop(1);
            if(Character["character_element_" + (_loc1_ + 1)] > 0)
            {
               this["element_mc" + _loc1_].visible = true;
               this["element_mc" + _loc1_].gotoAndStop(Character["character_element_" + (_loc1_ + 1)]);
               this["element_mc" + _loc1_].element.gotoAndStop(1);
               NinjaSage.showDynamicTooltip(this["element_mc" + _loc1_].element,this.getElementName(Character["character_element_" + (_loc1_ + 1)]));
               this.eventHandler.addListener(this["element_mc" + _loc1_].element,MouseEvent.CLICK,this.changeCategory);
               this.eventHandler.addListener(this["element_mc" + _loc1_].element,MouseEvent.MOUSE_OVER,this.over);
               this.eventHandler.addListener(this["element_mc" + _loc1_].element,MouseEvent.MOUSE_OUT,this.out);
            }
            _loc1_++;
         }
         var _loc2_:Array = ["Taijutsu","Genjutsu","Clan","Shadow War","Package","Leaderboard","Spending","Crew"];
         _loc1_ = 3;
         while(_loc1_ < 11)
         {
            this["element_mc" + _loc1_].gotoAndStop(1);
            NinjaSage.showDynamicTooltip(this["element_mc" + _loc1_],_loc2_[_loc1_ - 3]);
            this.eventHandler.addListener(this["element_mc" + _loc1_],MouseEvent.CLICK,this.changeCategory);
            this.eventHandler.addListener(this["element_mc" + _loc1_],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.addListener(this["element_mc" + _loc1_],MouseEvent.MOUSE_OUT,this.out);
            _loc1_++;
         }
      }
      
      public function changeCategory(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         this.resetAllElementsTab();
         param1.currentTarget.gotoAndStop(3);
         var _loc2_:* = param1.currentTarget.name == "element" ? param1.currentTarget.parent.name : param1.currentTarget.name;
         switch(_loc2_)
         {
            case "element_mc0":
               this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_1));
               break;
            case "element_mc1":
               this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_2));
               break;
            case "element_mc2":
               this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_3));
               break;
            case "element_mc3":
               this.selectedCategory = this.getElementSkillsArray(6);
               break;
            case "element_mc4":
               this.selectedCategory = this.getElementSkillsArray(7);
               break;
            case "element_mc5":
               this.selectedCategory = this.getElementSkillsArray(8);
               break;
            case "element_mc6":
               this.selectedCategory = this.getElementSkillsArray(9);
               break;
            case "element_mc7":
               this.selectedCategory = this.getElementSkillsArray(10);
               break;
            case "element_mc8":
               this.selectedCategory = this.getElementSkillsArray(11);
               break;
            case "element_mc9":
               this.selectedCategory = this.getElementSkillsArray(12);
               break;
            case "element_mc10":
               this.selectedCategory = this.getElementSkillsArray(13);
         }
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 12),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.resetSkillDetail();
         this.loadSwf();
      }
      
      public function getElementSkillsArray(param1:int) : Array
      {
         switch(param1)
         {
            case 1:
               this.currentElement = "wind";
               return this.windSkills;
            case 2:
               this.currentElement = "fire";
               return this.fireSkills;
            case 3:
               this.currentElement = "thunder";
               return this.thunderSkills;
            case 4:
               this.currentElement = "earth";
               return this.earthSkills;
            case 5:
               this.currentElement = "water";
               return this.waterSkills;
            case 6:
               this.currentElement = "taijutsu";
               return this.taijutsuSkills;
            case 7:
               this.currentElement = "genjutsu";
               return this.genjutsuSkills;
            case 8:
               this.currentElement = "clan";
               return this.clanSkills;
            case 9:
               this.currentElement = "shadowwar";
               return this.shadowwarSkills;
            case 10:
               this.currentElement = "package";
               return this.packageSkills;
            case 11:
               this.currentElement = "leaderboard";
               return this.leaderboardSkills;
            case 12:
               this.currentElement = "spending";
               return this.spendingSkills;
            case 13:
               this.currentElement = "crew";
               return this.crewSkills;
            default:
               return [];
         }
      }
      
      public function getElementName(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return "Wind";
            case 2:
               return "Fire";
            case 3:
               return "Lightning";
            case 4:
               return "Earth";
            case 5:
               return "Water";
            default:
               return "No Element";
         }
      }
      
      public function setOwnedSkillsArray() : *
      {
         var _loc4_:* = undefined;
         var _loc1_:* = Character.character_skills.split(",");
         var _loc2_:* = {
            "windSkills":SkillLibrary.getSkillIds("1"),
            "waterSkills":SkillLibrary.getSkillIds("5"),
            "fireSkills":SkillLibrary.getSkillIds("2"),
            "thunderSkills":SkillLibrary.getSkillIds("3"),
            "earthSkills":SkillLibrary.getSkillIds("4"),
            "taijutsuSkills":SkillLibrary.getSkillIds("6"),
            "genjutsuSkills":SkillLibrary.getSkillIds("7"),
            "clanSkills":SkillLibrary.getSkillByCategory("clan"),
            "shadowwarSkills":SkillLibrary.getSkillByCategory("shadowwar"),
            "packageSkills":SkillLibrary.getSkillByCategory("package"),
            "leaderboardSkills":SkillLibrary.getSkillByCategory("leaderboard"),
            "spendingSkills":SkillLibrary.getSkillByCategory("spending"),
            "crewSkills":SkillLibrary.getSkillByCategory("crew")
         };
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_.length)
         {
            for(_loc4_ in _loc2_)
            {
               if(_loc2_[_loc4_].indexOf(_loc1_[_loc3_]) > -1)
               {
                  this[_loc4_].push(_loc1_[_loc3_]);
               }
            }
            _loc3_++;
         }
      }
      
      public function over(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      public function out(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      public function setDefaultArray() : *
      {
         if(this.currentElement == "wind")
         {
            this.selectedCategory = this.windSkills;
         }
         else if(this.currentElement == "water")
         {
            this.selectedCategory = this.waterSkills;
         }
         else if(this.currentElement == "fire")
         {
            this.selectedCategory = this.fireSkills;
         }
         else if(this.currentElement == "thunder")
         {
            this.selectedCategory = this.thunderSkills;
         }
         else if(this.currentElement == "earth")
         {
            this.selectedCategory = this.earthSkills;
         }
         else if(this.currentElement == "taijutsu")
         {
            this.selectedCategory = this.taijutsuSkills;
         }
         else if(this.currentElement == "genjutsu")
         {
            this.selectedCategory = this.genjutsuSkills;
         }
         else if(this.currentElement == "clan")
         {
            this.selectedCategory = this.clanSkills;
         }
         else if(this.currentElement == "shadowwar")
         {
            this.selectedCategory = this.shadowwarSkills;
         }
         else if(this.currentElement == "package")
         {
            this.selectedCategory = this.packageSkills;
         }
         else if(this.currentElement == "leaderboard")
         {
            this.selectedCategory = this.leaderboardSkills;
         }
         else if(this.currentElement == "spending")
         {
            this.selectedCategory = this.spendingSkills;
         }
         else if(this.currentElement == "crew")
         {
            this.selectedCategory = this.crewSkills;
         }
      }
      
      public function resetAllElementsTab() : *
      {
         this.element_mc0.element.gotoAndStop(1);
         this.element_mc1.element.gotoAndStop(1);
         this.element_mc2.element.gotoAndStop(1);
         var _loc1_:* = 3;
         while(_loc1_ < 11)
         {
            this["element_mc" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      public function resetRecursiveProperty() : *
      {
         this.skillLoading = this.currentPage * 12;
         if(this.selectedCategory.length < this.skillLoading)
         {
            this.skillLoading = this.selectedCategory.length;
         }
         this.skillIndex = (this.currentPage - 1) * 12;
         this.skillCount = 0;
         this.equippedCount = 0;
      }
      
      public function resetIconHolder() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.skillIconMC.length)
         {
            GF.removeAllChild(this.skillIconMC[_loc1_]);
            _loc1_++;
         }
         this.skillIconMC = [];
         _loc1_ = 0;
         while(_loc1_ < 12)
         {
            GF.removeAllChild(this["item_" + _loc1_].iconMC.iconHolder);
            this["item_" + _loc1_].visible = false;
            this["item_" + _loc1_].gotoAndStop(1);
            delete this["item_" + _loc1_].tooltip;
            delete this["item_" + _loc1_].tooltipCache;
            this.eventHandler.removeListener(this["item_" + _loc1_]["btn_equip_skill"],MouseEvent.CLICK,this.equipSkill);
            this.eventHandler.removeListener(this["item_" + _loc1_],MouseEvent.CLICK,this.showSkillDetail);
            this.eventHandler.removeListener(this["item_" + _loc1_],MouseEvent.ROLL_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this["item_" + _loc1_],MouseEvent.ROLL_OUT,this.toolTiponOut);
            _loc1_++;
         }
      }
      
      public function resetEquippedIconHolder() : *
      {
         this.switchSkillIndexHolder = [];
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            GF.removeAllChild(this["skill_" + _loc1_].iconHolder);
            this["skill_" + _loc1_].selected = false;
            this["skill_" + _loc1_].filters = null;
            delete this["skill_" + _loc1_].tooltip;
            delete this["skill_" + _loc1_].tooltipCache;
            this.eventHandler.removeListener(this["btn_close_slot" + _loc1_],MouseEvent.CLICK,this.removeEquippedSkill);
            this.eventHandler.removeListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OUT,this.toolTiponOut);
            this.eventHandler.removeListener(this["skill_" + _loc1_],MouseEvent.CLICK,this.selectSwitchingSkill);
            _loc1_++;
         }
      }
      
      public function resetSkillDetail() : *
      {
         this.skillInfoMC.visible = false;
         this.btn_preview.visible = false;
         this.selectedSkill = null;
         this.skillInfoMC.txt_name.text = "";
         this.skillInfoMC.txt_level.text = "";
         this.skillInfoMC.txt_cp.text = "";
         this.skillInfoMC.txt_dmg.text = "";
         this.skillInfoMC.txt_cd.text = "";
         this.skillInfoMC.txt_description.text = "";
         GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
      }
      
      public function resetPreviewHolder() : void
      {
         if(this.previewMC)
         {
            this.previewMC.destroy();
         }
         this.previewMC = null;
      }
      
      public function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         this.main.loadExternalSwfPanel(_loc2_,_loc2_);
      }
      
      public function toolTiponOver(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(!_loc2_.tooltipCache)
         {
            _loc3_ = _loc2_.tooltip;
            if(!_loc3_)
            {
               return;
            }
            _loc4_ = !!_loc3_.hasOwnProperty("skill_source") ? _loc3_.skill_source : null;
            _loc5_ = (_loc5_ = _loc3_.skill_name + "\n(Skill)\n\nLevel " + _loc3_.skill_level + "\n<font color=\"#ff0000\">Damage: " + _loc3_.skill_damage + "</font>\n<font color=\"#0000ff\">CP Cost: " + _loc3_.skill_cp_cost + "</font>\n<font color=\"#ffcc00\">Cooldown: " + _loc3_.skill_cooldown + "</font>\n\n" + _loc3_.skill_description) + ItemDropSourceMapping.formatSourceText(_loc4_);
            _loc2_.tooltipCache = _loc5_;
         }
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc2_.tooltipCache);
      }
      
      public function toolTiponOut(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
         this.tooltip.hide();
      }
      
      public function confirmationRandomizeSkill(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         this.main.showConfirmation("Are you sure you want to randomize your equipped skills?",this.randomizeSkill);
      }
      
      public function randomizeSkill() : *
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         var _loc1_:Array = Character.character_skills.split(",");
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if((_loc7_ = _loc1_[_loc3_]) != "")
            {
               _loc8_ = SkillLibrary.getSkillInfo(_loc7_);
               if(int(Character.character_lvl) >= int(_loc8_["skill_level"]))
               {
                  _loc2_.push(_loc7_);
               }
            }
            _loc3_++;
         }
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc4_:int = _loc2_.length;
         while(_loc4_ > 1)
         {
            _loc4_--;
            _loc5_ = int(Math.random() * (_loc4_ + 1));
            _loc6_ = _loc2_[_loc5_];
            _loc2_[_loc5_] = _loc2_[_loc4_];
            _loc2_[_loc4_] = _loc6_;
         }
         if(_loc2_.length <= 8)
         {
            this.equippedSkill = _loc2_.slice();
         }
         else
         {
            this.equippedSkill = _loc2_.slice(0,8);
         }
         this.resetEquippedIconHolder();
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
         this.loadEquippedSkills();
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         if(this.equippedSkill.length == 0)
         {
            this.main.getNotice("Equipped skill cannot empty");
            return;
         }
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.vJINFPFPprdc",[Character.char_id,Character.sessionkey,this.equippedSkill.join(",")],this.equipResponse);
      }
      
      public function equipResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.character_equipped_skills = this.equippedSkill.join(",");
            Character.character_skill_set = this.equippedSkill.join(",");
            this.destroy();
         }
         else if(param1.status > 1)
         {
            this.main.getNotice(param1.result || "Equipped skill cannot empty");
         }
         else
         {
            this.main.getError(param1.error);
            this.destroy();
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
         while(_loc1_ < 10)
         {
            NinjaSage.clearDynamicTooltip(this["element_mc" + _loc1_]);
            _loc1_++;
         }
         GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
         this.resetPreviewHolder();
         this.resetSkillDetail();
         this.resetIconHolder();
         this.resetEquippedIconHolder();
         NinjaSage.clearDynamicTooltip(this.btn_filter.filter_on);
         NinjaSage.clearDynamicTooltip(this.btn_filter.filter_off);
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.loaderSwf.clear();
         OutfitManager.clearStaticMc();
         BulkLoader.getLoader("assets").removeAll();
         this.eventHandler.removeAllEventListeners();
         this.tooltip.destroy();
         this.windSkills = [];
         this.waterSkills = [];
         this.fireSkills = [];
         this.thunderSkills = [];
         this.earthSkills = [];
         this.taijutsuSkills = [];
         this.genjutsuSkills = [];
         this.clanSkills = [];
         this.shadowwarSkills = [];
         this.packageSkills = [];
         this.leaderboardSkills = [];
         this.spendingSkills = [];
         this.crewSkills = [];
         this.selectedCategory = [];
         this.skillIconMC = [];
         this.equippedSkill = [];
         this.skillPreset = [];
         this.currentPage = 1;
         this.totalPage = 1;
         this.skillIndex = 0;
         this.skillLoading = 0;
         this.skillCount = 0;
         this.equippedCount = 0;
         this.cost = 0;
         this.selectedPreset = 1;
         this.glowFilter = null;
         this.confirmation = null;
         this.selectedSkill = null;
         this.currentElement = null;
         this.eventHandler = null;
         this.tooltip = null;
         this.loaderSwf = null;
         this.previewMC = null;
         this.main = null;
         System.gc();
         GF.removeAllChild(this);
      }
   }
}
