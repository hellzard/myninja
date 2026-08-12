package Panels
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.PreviewManager;
   import Storage.Character;
   import Storage.GameData;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class Academy extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var btn_ResetSkill:SimpleButton;
      
      public var btn_element_0:MovieClip;
      
      public var btn_element_1:MovieClip;
      
      public var btn_element_2:MovieClip;
      
      public var preview:MovieClip;
      
      public var btn_element_3:MovieClip;
      
      public var btn_element_4:MovieClip;
      
      public var btn_element_5:MovieClip;
      
      public var btn_element_6:MovieClip;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var buyGold:SimpleButton;
      
      public var buyTokens:SimpleButton;
      
      public var skillInfoMC:MovieClip;
      
      public var skill_0:MovieClip;
      
      public var skill_1:MovieClip;
      
      public var skill_2:MovieClip;
      
      public var skill_3:MovieClip;
      
      public var skill_4:MovieClip;
      
      public var skill_5:MovieClip;
      
      public var skill_6:MovieClip;
      
      public var txt_gold:TextField;
      
      public var txt_page:TextField;
      
      public var txt_token:TextField;
      
      public var main;
      
      public var total_page = 0;
      
      public var curr_page = 1;
      
      public var last_page = 1;
      
      public var skills_list:Array;
      
      public var skills_cnt = 0;
      
      public var skills_var_0 = 0;
      
      public var skills_var_1 = 0;
      
      public var cntSkills = 0;
      
      public var skill_damage:Array;
      
      public var energy_cost:Array;
      
      public var cool_down:Array;
      
      public var skillname:Array;
      
      public var skilltype:Array;
      
      public var skilllevel:Array;
      
      public var skilldescription:Array;
      
      public var skillCostGolds:Array;
      
      public var skillCostTokens:Array;
      
      public var skillEmblemBoolean:Array;
      
      public var skills_mc:Array;
      
      public var skill_id_holder_arr:Array;
      
      public var selected_skill_id:String = "";
      
      public var wind_skills:Array;
      
      public var water_skills:Array;
      
      public var fire_skills:Array;
      
      public var thunder_skills:Array;
      
      public var earth_skills:Array;
      
      public var taijutsu_skills:Array;
      
      public var genjutsu_skills:Array;
      
      public var swf_loading = "";
      
      public var is_loading = false;
      
      public var previewMC:PreviewManager;
      
      public var eventHandler;
      
      public var skill_info;
      
      private var loaderSwf:BulkLoader;
      
      public function Academy(param1:*)
      {
         this.skills_list = [];
         var _loc2_:* = GameData.get("academy");
         this.wind_skills = _loc2_.wind;
         this.fire_skills = _loc2_.fire;
         this.thunder_skills = _loc2_.thunder;
         this.earth_skills = _loc2_.earth;
         this.water_skills = _loc2_.water;
         this.taijutsu_skills = _loc2_.taijutsu;
         this.genjutsu_skills = _loc2_.genjutsu;
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.escapeKey.addListener(this.preview,this.closePreview);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.loaderSwf = BulkLoader.getLoader("assets");
         this.main.handleVillageHUDVisibility(false);
         this.preview.visible = false;
         this.startLoading();
         this.eventHandler.addListener(this.btn_ResetSkill,MouseEvent.CLICK,this.openExternalPanel);
      }
      
      function startLoading() : void
      {
         this.skill_damage = [];
         this.energy_cost = [];
         this.cool_down = [];
         this.skillname = [];
         this.skilltype = [];
         this.skilllevel = [];
         this.skilldescription = [];
         this.skillCostGolds = [];
         this.skillCostTokens = [];
         this.skillEmblemBoolean = [];
         this.skills_mc = [];
         this.skill_id_holder_arr = [];
         this.getBasicData();
         this.loadSkills();
      }
      
      function loadSkills() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < 7)
         {
            this["skill_" + _loc1_].visible = false;
            GF.removeAllChild(this["skill_" + _loc1_]["iconMC"]["iconHolder"]);
            _loc1_++;
         }
      }
      
      function loadElement(param1:*) : void
      {
         var event:* = param1;
         if(this.is_loading)
         {
            return;
         }
         var elementName:* = event;
         if(event is MouseEvent)
         {
            this.last_page = 1;
            this.resetAllElements();
            elementName = event.currentTarget.name;
            event.currentTarget.gotoAndStop(3);
         }
         switch(elementName)
         {
            case "btn_element_0":
               this.skills_list = this.wind_skills;
               break;
            case "btn_element_4":
               this.skills_list = this.water_skills;
               break;
            case "btn_element_1":
               this.skills_list = this.fire_skills;
               break;
            case "btn_element_2":
               this.skills_list = this.thunder_skills;
               break;
            case "btn_element_3":
               this.skills_list = this.earth_skills;
               break;
            case "btn_element_5":
               this.skills_list = this.taijutsu_skills;
               break;
            case "btn_element_6":
               this.skills_list = this.genjutsu_skills;
         }
         this.skills_cnt = 0;
         this.cntSkills = 0;
         this.curr_page = this.last_page;
         this.skill_id_holder_arr.splice(0);
         this.skill_damage.splice(0);
         this.energy_cost.splice(0);
         this.cool_down.splice(0);
         this.skillname.splice(0);
         this.skilltype.splice(0);
         this.skilllevel.splice(0);
         this.skilldescription.splice(0);
         this.skills_mc.splice(0);
         this.skillCostGolds.splice(0);
         this.skillCostTokens.splice(0);
         this.skillEmblemBoolean.splice(0);
         var i:* = 0;
         try
         {
            while(i < 7)
            {
               this["skill_" + i].visible = false;
               GF.removeAllChild(this["skill_" + i]["iconMC"]["iconHolder"]);
               i++;
            }
            this.updateSkillValues();
            this.setTheSkills();
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function updateSkillValues() : void
      {
         this.skills_cnt = 0;
         this.cntSkills = 0;
         this.skill_id_holder_arr.splice(0);
         this.skill_damage.splice(0);
         this.energy_cost.splice(0);
         this.cool_down.splice(0);
         this.skillname.splice(0);
         this.skilltype.splice(0);
         this.skilllevel.splice(0);
         this.skilldescription.splice(0);
         this.skills_mc.splice(0);
         this.skillCostGolds.splice(0);
         this.skillCostTokens.splice(0);
         this.skillEmblemBoolean.splice(0);
         var i:* = 0;
         try
         {
            while(i < 7)
            {
               this["skill_" + i].visible = false;
               GF.removeAllChild(this["skill_" + i]["iconMC"]["iconHolder"]);
               i++;
            }
         }
         catch(e:Error)
         {
         }
         this.total_page = Math.max(Math.ceil(this.skills_list.length / 7),1);
         this.skills_var_1 = this.curr_page * 7;
         if(this.skills_list.length < this.skills_var_1)
         {
            this.skills_var_1 = this.skills_list.length;
         }
         this.skills_var_0 = (this.curr_page - 1) * 7;
         this["txt_page"].text = this.curr_page + " / " + this.total_page;
      }
      
      function setTheSkills() : void
      {
         var _loc1_:* = undefined;
         this.is_loading = true;
         if(this.skills_var_0 < this.skills_var_1)
         {
            _loc1_ = this.loaderSwf.add("skills/" + this.skills_list[this.skills_var_0] + ".swf");
            _loc1_.addEventListener(BulkLoader.COMPLETE,this.completeIcon);
            this.loaderSwf.start();
         }
         else
         {
            this.is_loading = false;
         }
      }
      
      public function completeIcon(param1:Event) : void
      {
         var _loc5_:* = undefined;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this["skill_" + int(this.cntSkills)].visible = true;
         var _loc3_:MovieClip = param1.target.content["icon"];
         if(param1.target.content[this.skills_list[this.skills_var_0]])
         {
            param1.target.content[this.skills_list[this.skills_var_0]].gotoAndStop(1);
         }
         this.skills_mc.push(_loc3_);
         this.skill_id_holder_arr[this.cntSkills] = this.skills_list[this.skills_var_0];
         var _loc4_:* = SkillLibrary.getSkillInfo(this.skills_list[this.skills_var_0]);
         this.skill_damage[this.cntSkills] = int(_loc4_["skill_damage"]);
         this.energy_cost[this.cntSkills] = int(_loc4_["skill_cp_cost"]);
         this.cool_down[this.cntSkills] = int(_loc4_["skill_cooldown"]);
         this.skillname[this.cntSkills] = _loc4_["skill_name"];
         this.skilltype[this.cntSkills] = _loc4_["skill_type"];
         this.skilllevel[this.cntSkills] = _loc4_["skill_level"];
         this.skilldescription[this.cntSkills] = _loc4_["skill_description"];
         this.skillCostGolds[this.cntSkills] = _loc4_["skill_price_gold"];
         this.skillCostTokens[this.cntSkills] = _loc4_["skill_price_tokens"];
         this.skillEmblemBoolean[this.cntSkills] = _loc4_["skill_premium"];
         if(_loc4_["skill_price_gold"] > 0)
         {
            this["skill_" + int(this.cntSkills)].priceMC.gotoAndStop(1);
            this["skill_" + int(this.cntSkills)].priceMC.txt_gold.text = _loc4_["skill_price_gold"];
         }
         else
         {
            this["skill_" + int(this.cntSkills)].priceMC.gotoAndStop(2);
            this["skill_" + int(this.cntSkills)].priceMC.txt_token.text = _loc4_["skill_price_tokens"];
         }
         if((_loc5_ = this.hasSkill(this.skills_list[this.skills_var_0])) > 0)
         {
            this["skill_" + int(this.cntSkills)].priceMC.gotoAndStop(3);
         }
         if(_loc4_["item_premium"])
         {
            this["skill_" + this.cntSkills]["emblemMC"].visible = true;
            this.eventHandler.addListener(this["skill_" + this.cntSkills]["emblemMC"],MouseEvent.CLICK,this.emblemPopup);
         }
         else
         {
            this["skill_" + this.cntSkills]["emblemMC"].visible = false;
            this.eventHandler.removeListener(this["skill_" + this.cntSkills]["emblemMC"],MouseEvent.CLICK,this.emblemPopup);
         }
         this["skill_" + int(this.cntSkills)]["txt_name"].text = _loc4_["skill_name"];
         this["skill_" + int(this.cntSkills)]["txt_level"].text = _loc4_["skill_level"];
         GF.removeAllChild(this["skill_" + int(this.cntSkills)]["iconMC"]["iconHolder"]);
         this["skill_" + int(this.cntSkills)]["iconMC"]["iconHolder"].addChild(_loc3_);
         this.eventHandler.addListener(this["skill_" + int(this.cntSkills)],MouseEvent.CLICK,this.openSkillInfo);
         ++this.skills_var_0;
         ++this.cntSkills;
         this.setTheSkills();
      }
      
      public function openSkillInfo(param1:MouseEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.currentTarget.name;
         this.resetAllSkills();
         param1.currentTarget.gotoAndStop(3);
         this["skillInfoMC"].visible = true;
         var _loc3_:* = _loc2_.replace("skill_","");
         GF.removeAllChild(this["skillInfoMC"]["iconMC"]["iconHolder"]);
         this["skillInfoMC"]["iconType"].gotoAndStop(this.skilltype[_loc3_]);
         this.selected_skill_id = this.skill_id_holder_arr[_loc3_];
         NinjaSage.loadItemIcon(this["skillInfoMC"]["iconMC"]["iconHolder"],this.selected_skill_id,"icon");
         this["skillInfoMC"]["txt_name"].text = this.skillname[_loc3_];
         this["skillInfoMC"]["txt_level"].text = this.skilllevel[_loc3_];
         this["skillInfoMC"]["txt_dmg"].text = this.skill_damage[_loc3_];
         this["skillInfoMC"]["txt_cp"].text = this.energy_cost[_loc3_];
         this["skillInfoMC"]["txt_cd"].text = this.cool_down[_loc3_];
         this["skillInfoMC"]["txt_description"].text = this.skilldescription[_loc3_];
         this["skillInfoMC"]["txt_lvl"].text = this.skilllevel[_loc3_];
         this.eventHandler.addListener(this["skillInfoMC"]["btn_preview"],MouseEvent.CLICK,this.loadSkillAndPreview);
         if(this.skillEmblemBoolean[_loc3_])
         {
            this["skillInfoMC"]["emblemMC"].visible = true;
            this.eventHandler.addListener(this["skillInfoMC"]["emblemMC"],MouseEvent.CLICK,this.emblemPopup);
         }
         else
         {
            this["skillInfoMC"]["emblemMC"].visible = false;
            this.eventHandler.removeListener(this["skillInfoMC"]["emblemMC"],MouseEvent.CLICK,this.emblemPopup);
         }
         if((_loc4_ = this.hasSkill(this.skill_id_holder_arr[_loc3_])) > 0)
         {
            this["skillInfoMC"]["btn_learn"].visible = false;
            this.eventHandler.removeListener(this["skillInfoMC"]["btn_learn"],MouseEvent.CLICK,this.learnSkill);
         }
         else
         {
            this["skillInfoMC"]["btn_learn"].visible = true;
            this.eventHandler.addListener(this["skillInfoMC"]["btn_learn"],MouseEvent.CLICK,this.learnSkill);
         }
         if(this.skillCostGolds[_loc3_] > 0)
         {
            this["skillInfoMC"].priceMC.gotoAndStop(1);
            this["skillInfoMC"].priceMC.txt_gold.text = this.skillCostGolds[_loc3_];
         }
         else
         {
            this["skillInfoMC"].priceMC.gotoAndStop(2);
            this["skillInfoMC"].priceMC.txt_token.text = this.skillCostTokens[_loc3_];
         }
      }
      
      public function loadSkillAndPreview(param1:MouseEvent) : *
      {
         this.main.loading(true);
         var _loc2_:* = this.loaderSwf.add("skills/" + this.selected_skill_id + ".swf");
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.completePreview);
         this.loaderSwf.start();
      }
      
      public function completePreview(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.skill_info = SkillLibrary.getSkillInfo(this.selected_skill_id);
         var _loc3_:* = param1.target.content[this.selected_skill_id];
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
      
      public function closePreview(param1:MouseEvent) : *
      {
         if(this.previewMC)
         {
            this.previewMC.destroy();
         }
         this.previewMC = null;
         this.preview.visible = false;
         GF.removeAllChild(this.preview.skillMc);
      }
      
      public function hasSkill(param1:*) : *
      {
         var _loc2_:* = [];
         if(Character.character_skills != "")
         {
            if(Character.character_skills.indexOf(",") >= 0)
            {
               _loc2_ = Character.character_skills.split(",");
            }
            else
            {
               _loc2_ = [Character.character_skills];
            }
         }
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc4_])
            {
               _loc3_ = 1;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      function learnSkill(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.JJ9ezMetJTxm",[Character.sessionkey,Character.char_id,this.selected_skill_id],this.buyResponse);
      }
      
      function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.last_page = this.curr_page;
            this.loadElement("same");
            Character.character_gold = param1.data.character_gold;
            Character.account_tokens = param1.data.account_tokens;
            Character.character_element_1 = param1.data.character_element_1;
            Character.character_element_2 = param1.data.character_element_2;
            Character.character_element_3 = param1.data.character_element_3;
            this.txt_gold.text = Character.character_gold;
            this.txt_token.text = String(Character.account_tokens);
            Character.character_skills = Character.character_skills + "," + this.selected_skill_id;
         }
         else if(param1.status == 2)
         {
            this.main.getNotice("You already own this skill.");
         }
         else if(param1.status == 3)
         {
            this.main.getNotice("You dont have enough resources to learn this skill.");
         }
         else if(param1.status == 4)
         {
            this.main.getNotice("You cannot learn jutsu from this element.");
         }
         else if(param1.status == 5)
         {
            this.main.getNotice("Your level is not high enough for this item.");
         }
         else if(param1.status == 6 || param1.status == 7)
         {
            this.main.loadPanel("Popups.EmblemUpgrade");
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      function changeListNum(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         if(this.is_loading)
         {
            return;
         }
         var _loc3_:* = param1.currentTarget.name;
         switch(_loc3_)
         {
            case "btn_prev":
               _loc2_ = (_loc3_ = this).curr_page - 1;
               _loc3_.curr_page = _loc2_;
               if(this.curr_page <= 0)
               {
                  this.curr_page = 1;
                  this.skills_cnt = 0;
                  this.cntSkills = 0;
                  return;
               }
               this.skills_cnt -= 12;
               this.cntSkills -= 12;
               break;
            case "btn_next":
               _loc2_ = (_loc3_ = this).curr_page + 1;
               _loc3_.curr_page = _loc2_;
               if(this.curr_page > this.total_page)
               {
                  this.curr_page = this.total_page;
                  return;
               }
               break;
         }
         this.updateSkillValues();
         this.setTheSkills();
      }
      
      function emblemPopup(param1:MouseEvent) : void
      {
         this.main.loadPanel("Popups.EmblemUpgrade");
      }
      
      function getBasicData() : void
      {
         if(this.is_loading)
         {
            return;
         }
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.buyGold,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.buyTokens,MouseEvent.CLICK,this.openRecharge);
         this.txt_gold.text = Character.character_gold;
         this.txt_token.text = String(Character.account_tokens);
         this.eventHandler.addListener(this["btn_next"],MouseEvent.CLICK,this.changeListNum);
         this.eventHandler.addListener(this["btn_prev"],MouseEvent.CLICK,this.changeListNum);
         this.setUI();
         this["btn_element_0"].gotoAndStop(3);
         this["btn_element_0"].buttonMode = false;
         this.skillInfoMC.visible = false;
         this.skills_list = this.wind_skills;
         this.skills_cnt = 0;
         this.cntSkills = 0;
         this.curr_page = 1;
         this.skill_id_holder_arr.splice(0);
         this.skill_damage.splice(0);
         this.energy_cost.splice(0);
         this.cool_down.splice(0);
         this.skillname.splice(0);
         this.skilltype.splice(0);
         this.skilllevel.splice(0);
         this.skilldescription.splice(0);
         this.skills_mc.splice(0);
         this.skillCostGolds.splice(0);
         this.skillCostTokens.splice(0);
         this.skillEmblemBoolean.splice(0);
         var i:* = 0;
         try
         {
            while(i < 7)
            {
               this["skill_" + i].visible = false;
               GF.removeAllChild(this["skill_" + i]["iconMC"]["iconHolder"]);
               i++;
            }
            this.updateSkillValues();
            this.setTheSkills();
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      function setUI() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < 7)
         {
            this["btn_element_" + _loc1_].gotoAndStop(1);
            this["btn_element_" + _loc1_].buttonMode = true;
            this.eventHandler.addListener(this["btn_element_" + _loc1_],MouseEvent.CLICK,this.loadElement);
            this.eventHandler.addListener(this["btn_element_" + _loc1_],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.addListener(this["btn_element_" + _loc1_],MouseEvent.MOUSE_OUT,this.out);
            this["skill_" + _loc1_].gotoAndStop(1);
            this["skill_" + _loc1_].buttonMode = true;
            this.eventHandler.addListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.addListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OUT,this.out);
            _loc1_++;
         }
      }
      
      function resetAllElements() : void
      {
         this["btn_element_0"].gotoAndStop(1);
         this["btn_element_1"].gotoAndStop(1);
         this["btn_element_2"].gotoAndStop(1);
         this["btn_element_3"].gotoAndStop(1);
         this["btn_element_4"].gotoAndStop(1);
         this["btn_element_5"].gotoAndStop(1);
         this["btn_element_6"].gotoAndStop(1);
      }
      
      function resetAllSkills() : void
      {
         this["skill_0"].gotoAndStop(1);
         this["skill_1"].gotoAndStop(1);
         this["skill_2"].gotoAndStop(1);
         this["skill_3"].gotoAndStop(1);
         this["skill_4"].gotoAndStop(1);
         this["skill_5"].gotoAndStop(1);
         this["skill_6"].gotoAndStop(1);
      }
      
      function selectSkill(param1:MouseEvent = null) : void
      {
         this.resetAllSkills();
         param1.currentTarget.gotoAndStop(3);
      }
      
      function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      function killEverything() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.handleVillageHUDVisibility(true);
         this.eventHandler.removeListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.removeListener(this.btn_prev,MouseEvent.CLICK,this.changeListNum);
         this.eventHandler.removeListener(this.btn_next,MouseEvent.CLICK,this.changeListNum);
         var _loc1_:* = 0;
         while(_loc1_ < 7)
         {
            this["btn_element_" + _loc1_].buttonMode = false;
            this.eventHandler.removeListener(this["btn_element_" + _loc1_],MouseEvent.CLICK,this.loadElement);
            this.eventHandler.removeListener(this["btn_element_" + _loc1_],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.removeListener(this["btn_element_" + _loc1_],MouseEvent.MOUSE_OUT,this.out);
            this["skill_" + _loc1_].buttonMode = false;
            this.eventHandler.removeListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.removeListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OUT,this.out);
            this.eventHandler.removeListener(this["skill_" + _loc1_]["emblemMC"],MouseEvent.CLICK,this.emblemPopup);
            GF.removeAllChild(this["skill_" + _loc1_]["iconMC"]["iconHolder"]);
            _loc1_++;
         }
         GF.removeAllChild(this["skillInfoMC"]["iconMC"]["iconHolder"]);
         GF.removeAllChild(this.preview.skillMc);
         this.eventHandler.removeListener(this["skillInfoMC"]["btn_learn"],MouseEvent.CLICK,this.learnSkill);
         this.eventHandler.removeListener(this.buyGold,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.removeListener(this.buyTokens,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.removeAllEventListeners();
         OutfitManager.clearStaticMc();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         BulkLoader.getLoader("assets").removeAll();
         this.loaderSwf.removeAll();
         this.eventHandler = null;
         this.total_page = null;
         this.curr_page = null;
         this.skills_list = null;
         this.skills_cnt = null;
         this.skills_var_0 = null;
         this.skills_var_1 = null;
         this.cntSkills = null;
         this.selected_skill_id = null;
         this.skill_damage = null;
         this.energy_cost = null;
         this.cool_down = null;
         this.skillname = null;
         this.skilltype = null;
         this.skilllevel = null;
         this.skilldescription = null;
         this.skillCostGolds = null;
         this.skillCostTokens = null;
         this.skillEmblemBoolean = null;
         this.skills_mc = null;
         this.skill_id_holder_arr = null;
         this.wind_skills = null;
         this.water_skills = null;
         this.fire_skills = null;
         this.thunder_skills = null;
         this.earth_skills = null;
         this.taijutsu_skills = null;
         this.genjutsu_skills = null;
         this.buyGold = null;
         this.buyTokens = null;
         this.main = null;
         this.loaderSwf = null;
         GF.removeAllChild(this);
         System.gc();
      }
      
      function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         this.main.loadExternalSwfPanel(_loc2_,_loc2_);
         this.killEverything();
      }
      
      function closePanel(param1:MouseEvent) : void
      {
         this.killEverything();
      }
   }
}
