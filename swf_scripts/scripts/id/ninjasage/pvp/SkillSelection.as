package id.ninjasage.pvp
{
   import Managers.NinjaSage;
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
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8158")]
   public dynamic class SkillSelection extends MovieClip
   {
      
      public var btn_buff:MovieClip;
      
      public var btn_debuff:MovieClip;
      
      public var btn_defense:MovieClip;
      
      public var btn_offense:MovieClip;
      
      public var timerMc:MovieClip;
      
      public var titleTxt:TextField;
      
      public var btn_clear:MovieClip;
      
      public var btn_clearSearch:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_save:SimpleButton;
      
      public var btn_search:SimpleButton;
      
      public var item_0:MovieClip;
      
      public var item_1:MovieClip;
      
      public var item_2:MovieClip;
      
      public var item_3:MovieClip;
      
      public var item_4:MovieClip;
      
      public var skillInfoMC:MovieClip;
      
      public var skill_0:MovieClip;
      
      public var skill_1:MovieClip;
      
      public var skill_2:MovieClip;
      
      public var skill_3:MovieClip;
      
      public var skill_4:MovieClip;
      
      public var skill_5:MovieClip;
      
      public var skill_6:MovieClip;
      
      public var skill_7:MovieClip;
      
      public var txt_timer:TextField;
      
      public var txt_page:TextField;
      
      public var txt_search:TextField;
      
      public var selectedCategory:Array = [];
      
      public var skillIconMC:Array = [];
      
      public var equippedSkill:Array = [];
      
      public var currentPage:int = 1;
      
      public var totalPage:int = 1;
      
      public var skillIndex:int = 0;
      
      public var skillLoading:int = 0;
      
      public var skillCount:int = 0;
      
      public var equippedCount:int = 0;
      
      public var selectedSkill:String;
      
      public var currentType:String;
      
      public var currentCategory:String;
      
      public var switchSkillIndexHolder:Array = [];
      
      public var eventHandler:*;
      
      public var tooltip:*;
      
      public var loaderSwf:* = BulkLoader.createUniqueNamedLoader(12);
      
      public var glowFilter:*;
      
      public var confirmation:*;
      
      private var escapeKey:EscapeKeyManager;
      
      private var pvp:PvP;
      
      private var originalSkillList:Array = [];
      
      public var destroyed:Boolean = false;
      
      public function SkillSelection()
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.tooltip = ToolTip.getInstance();
         this.eventHandler = new EventHandler();
         this.glowFilter = CreateFilter.getGlowFilter({
            "color":16776960,
            "strength":1000,
            "blurX":8,
            "blurY":8
         });
      }
      
      public function setContext(param1:PvP) : *
      {
         this.pvp = param1;
      }
      
      public function setSkillList(param1:Array) : *
      {
         this.originalSkillList = param1;
         this.currentType = "buff";
         this.currentCategory = "offense";
         this.updateSkillList();
         this.initButton();
         this.initUI();
      }
      
      public function setEquippedSkills(param1:Array) : *
      {
         this.equippedSkill = param1.length > 0 ? param1 : Character.character_skill_set.split(",");
      }
      
      public function updateSkillList() : *
      {
         this.selectedCategory = [];
         var _loc1_:int = this.currentType == "buff" ? 1 : 2;
         var _loc2_:int = this.currentCategory == "offense" ? 1 : 2;
         var _loc3_:* = 0;
         while(_loc3_ < this.originalSkillList.length)
         {
            if(this.originalSkillList[_loc3_].type == _loc1_ && this.originalSkillList[_loc3_].cat == _loc2_)
            {
               this.selectedCategory.push(this.originalSkillList[_loc3_].id);
            }
            _loc3_++;
         }
      }
      
      public function initUI() : *
      {
         this.skillInfoMC.visible = false;
         if(!this.pvp.isMatchMaking())
         {
            this.timerMc.visible = false;
         }
         this.txt_timer.text = "";
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 5),1);
         this.setTypeCategory();
         this.setCategory();
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
         _loc4_.stopAllMovieClips();
         this.skillIconMC.push(_loc4_);
         this["item_" + this.skillCount].iconMC.iconHolder.addChild(_loc4_);
         this["item_" + this.skillCount].gotoAndStop(1);
         this["item_" + this.skillCount].visible = true;
         var _loc5_:* = this.selectedCategory[this.skillIndex];
         param1.target.content[_loc5_].gotoAndStop(1);
         var _loc6_:* = SkillLibrary.getSkillInfo(_loc5_);
         this["item_" + this.skillCount].txt_name.text = _loc6_["skill_name"];
         this["item_" + this.skillCount].txt_dmg.text = _loc6_["skill_damage"];
         this["item_" + this.skillCount].txt_cp.text = _loc6_["skill_cp_cost"];
         this["item_" + this.skillCount].txt_cd.text = _loc6_["skill_cooldown"];
         if(this.equippedSkill.indexOf(_loc5_) > -1)
         {
            this["item_" + this.skillCount]["btn_equip_skill"].visible = false;
            this["item_" + this.skillCount]["txt_equipped"].visible = true;
         }
         else
         {
            this["item_" + this.skillCount]["btn_equip_skill"].visible = true;
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
         while(_loc2_ < 5)
         {
            this["item_" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         param1.currentTarget.gotoAndStop(3);
         var _loc3_:* = param1.currentTarget.name.replace("item_","");
         var _loc4_:* = param1.currentTarget.tooltip;
         this.skillInfoMC.visible = true;
         this.selectedSkill = _loc4_.skill_id;
         GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
         NinjaSage.loadItemIcon(this.skillInfoMC.iconMC.iconHolder,this.selectedSkill,"icon");
         this.skillInfoMC.txt_name.text = _loc4_.skill_name;
         this.skillInfoMC.txt_level.text = _loc4_.skill_level;
         this.skillInfoMC.txt_cp.text = _loc4_.skill_cp_cost;
         this.skillInfoMC.txt_dmg.text = _loc4_.skill_damage;
         this.skillInfoMC.txt_cd.text = _loc4_.skill_cooldown;
         this.skillInfoMC.txt_description.text = _loc4_.skill_description;
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
         GF.removeAllChild(this["skill_" + this.equippedCount].iconMC.iconHolder);
         var _loc3_:MovieClip = param1.target.content.icon;
         _loc3_.stopAllMovieClips();
         this["skill_" + this.equippedCount].iconMC.iconHolder.addChild(_loc3_);
         var _loc4_:* = SkillLibrary.getSkillInfo(this.equippedSkill[this.equippedCount]);
         param1.target.content[this.equippedSkill[this.equippedCount]].gotoAndStop(1);
         this["skill_" + this.equippedCount].tooltip = _loc4_;
         this.eventHandler.addListener(this["skill_" + this.equippedCount].btn_close_slot,MouseEvent.CLICK,this.removeEquippedSkill);
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
         var _loc2_:int = int(param1.currentTarget.parent.name.replace("item_",""));
         var _loc3_:int = _loc2_ + int(int(this.currentPage - 1) * 5);
         this["item_" + _loc2_].btn_equip_skill.visible = false;
         this["item_" + _loc2_].txt_equipped.visible = true;
         this["item_" + _loc2_].txt_equipped.text = "Equipped";
         this.equippedSkill.push(this.selectedCategory[_loc3_]);
         this.btn_clear.total.text = this.equippedSkill.length;
         this.loadEquippedSkills();
      }
      
      public function removeEquippedSkill(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         var _loc2_:* = param1.currentTarget.parent.name.replace("skill_","");
         if(_loc2_ >= this.equippedSkill.length)
         {
            return;
         }
         this.equippedSkill.splice(_loc2_,1);
         this.btn_clear.total.text = this.equippedSkill.length;
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
         this.btn_clear.total.text = this.equippedSkill.length;
         this.resetEquippedIconHolder();
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
         this.loadEquippedSkills();
      }
      
      public function searchItem(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.txt_search.text == "")
         {
            return;
         }
         this.updateSkillList();
         var _loc2_:Array = [];
         var _loc3_:String = this.txt_search.text.toLowerCase();
         var _loc6_:* = 0;
         while(_loc6_ < this.selectedCategory.length)
         {
            _loc5_ = this.selectedCategory[_loc6_];
            _loc4_ = SkillLibrary.getSkillInfo(_loc5_);
            if((Boolean(_loc4_)) && Boolean(_loc4_.hasOwnProperty("skill_name")) && _loc4_["skill_name"].toLowerCase().indexOf(_loc3_) >= 0)
            {
               _loc2_.push(_loc5_);
            }
            _loc6_++;
         }
         this.selectedCategory = _loc2_;
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 5),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadSwf();
      }
      
      public function onSearchClear(param1:MouseEvent = null) : *
      {
         this.txt_search.text = "";
         this.updateSkillList();
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 5),1);
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
         this.pvp.main.initButton(this.btn_clear,this.removeAllEquippedSkill,"Reset");
         this.btn_clear.total.text = this.equippedSkill.length;
         this.eventHandler.addListener(this.btn_search,MouseEvent.CLICK,this.searchItem);
         this.eventHandler.addListener(this.btn_clearSearch,MouseEvent.CLICK,this.onSearchClear);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
      }
      
      public function setTypeCategory() : *
      {
         this.btn_buff.gotoAndStop(3);
         this.eventHandler.addListener(this.btn_buff,MouseEvent.CLICK,this.changeType);
         this.eventHandler.addListener(this.btn_buff,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.btn_buff,MouseEvent.MOUSE_OUT,this.out);
         this.btn_debuff.gotoAndStop(1);
         this.eventHandler.addListener(this.btn_debuff,MouseEvent.CLICK,this.changeType);
         this.eventHandler.addListener(this.btn_debuff,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.btn_debuff,MouseEvent.MOUSE_OUT,this.out);
      }
      
      public function setCategory() : *
      {
         this.btn_offense.gotoAndStop(3);
         this.eventHandler.addListener(this.btn_offense,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.btn_offense,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.btn_offense,MouseEvent.MOUSE_OUT,this.out);
         this.btn_defense.gotoAndStop(1);
         this.eventHandler.addListener(this.btn_defense,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.btn_defense,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.btn_defense,MouseEvent.MOUSE_OUT,this.out);
      }
      
      public function changeCategory(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         this.resetAllCategoryTab();
         param1.currentTarget.gotoAndStop(3);
         this.currentCategory = param1.currentTarget.name == "btn_offense" ? "offense" : "defense";
         this.updateSkillList();
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 5),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.resetSkillDetail();
         this.loadSwf();
      }
      
      public function changeType(param1:MouseEvent) : *
      {
         if(this.isLoading)
         {
            return;
         }
         this.resetAllTypeCategory();
         this.resetAllCategoryTab();
         param1.currentTarget.gotoAndStop(3);
         this["btn_" + this.currentCategory].gotoAndStop(3);
         this.currentType = param1.currentTarget.name == "btn_buff" ? "buff" : "debuff";
         this.updateSkillList();
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.selectedCategory.length / 5),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.resetSkillDetail();
         this.loadSwf();
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
      
      public function resetAllTypeCategory() : *
      {
         this.btn_buff.gotoAndStop(1);
         this.btn_debuff.gotoAndStop(1);
      }
      
      public function resetAllCategoryTab() : *
      {
         this.btn_offense.gotoAndStop(1);
         this.btn_defense.gotoAndStop(1);
      }
      
      public function resetRecursiveProperty() : *
      {
         this.skillLoading = this.currentPage * 5;
         if(this.selectedCategory.length < this.skillLoading)
         {
            this.skillLoading = this.selectedCategory.length;
         }
         this.skillIndex = (this.currentPage - 1) * 5;
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
         while(_loc1_ < 5)
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
            GF.removeAllChild(this["skill_" + _loc1_].iconMC.iconHolder);
            this["skill_" + _loc1_].selected = false;
            this["skill_" + _loc1_].filters = null;
            delete this["skill_" + _loc1_].tooltip;
            delete this["skill_" + _loc1_].tooltipCache;
            this.eventHandler.removeListener(this["skill_" + _loc1_].btn_close_slot,MouseEvent.CLICK,this.removeEquippedSkill);
            this.eventHandler.removeListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OUT,this.toolTiponOut);
            this.eventHandler.removeListener(this["skill_" + _loc1_],MouseEvent.CLICK,this.selectSwitchingSkill);
            _loc1_++;
         }
      }
      
      public function resetSkillDetail() : *
      {
         this.skillInfoMC.visible = false;
         this.selectedSkill = null;
         this.skillInfoMC.txt_name.text = "";
         this.skillInfoMC.txt_level.text = "";
         this.skillInfoMC.txt_cp.text = "";
         this.skillInfoMC.txt_dmg.text = "";
         this.skillInfoMC.txt_cd.text = "";
         this.skillInfoMC.txt_description.text = "";
         GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
      }
      
      public function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         this.pvp.main.loadExternalSwfPanel(_loc2_,_loc2_);
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
            _loc4_ = _loc3_.hasOwnProperty("skill_source") ? _loc3_.skill_source : null;
            _loc5_ = _loc3_.skill_name + "\n(Skill)\n\nLevel " + _loc3_.skill_level + "\n<font color=\"#ff0000\">Damage: " + _loc3_.skill_damage + "</font>\n<font color=\"#0000ff\">CP Cost: " + _loc3_.skill_cp_cost + "</font>\n<font color=\"#ffcc00\">Cooldown: " + _loc3_.skill_cooldown + "</font>\n\n" + _loc3_.skill_description;
            _loc5_ = _loc5_ + ItemDropSourceMapping.formatSourceText(_loc4_);
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
      
      public function closePanel(param1:MouseEvent) : *
      {
         if(this.equippedSkill.length == 0)
         {
            this.pvp.main.getNotice("Equipped skill cannot empty");
            return;
         }
         PvPSocket.getInstance().emit("Room.skills.set",this.equippedSkill);
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
         this.resetSkillDetail();
         this.resetIconHolder();
         this.resetEquippedIconHolder();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.loaderSwf.clear();
         BulkLoader.getLoader("assets").removeAll();
         this.eventHandler.removeAllEventListeners();
         this.tooltip.destroy();
         this.selectedCategory = [];
         this.skillIconMC = [];
         this.equippedSkill = [];
         this.currentPage = 1;
         this.totalPage = 1;
         this.skillIndex = 0;
         this.skillLoading = 0;
         this.skillCount = 0;
         this.equippedCount = 0;
         this.glowFilter = null;
         this.selectedSkill = null;
         this.eventHandler = null;
         this.tooltip = null;
         this.loaderSwf = null;
         this.pvp = null;
         System.gc();
         GF.removeAllChild(this);
      }
   }
}

