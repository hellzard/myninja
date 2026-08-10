package
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Combat.CharacterModel;
   import Managers.AppManager;
   import Managers.ErrorManager;
   import Managers.ExamManager;
   import Managers.LoginManager;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.StatManager;
   import Managers.VarManager;
   import Movieclips.LoadingMC;
   import Movieclips.Popup_msg;
   import Popups.ClanBattleResults;
   import Popups.Confirmation;
   import Storage.ArenaBuffs;
   import Storage.Character;
   import Storage.GameData;
   import Storage.Library;
   import Storage.MissionLibrary;
   import Storage.PetInfo;
   import Storage.SenjutsuInfo;
   import Storage.SenjutsuLevelLearnRequirements;
   import Storage.SenjutsuSkillDescriptions;
   import Storage.SenjutsuSkillLevel;
   import Storage.SkillBuffs;
   import Storage.SkillLibrary;
   import Storage.StorageLoader;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.adobe.crypto.CUCSG;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.utils.*;
   import id.ninjasage.Clan;
   import id.ninjasage.Util;
   import id.ninjasage.sounds.SoundAS;
   import id.ninjasage.sounds.SoundInstance;
   
   public class main extends MovieClip
   {
      
      public var loader:MovieClip;
      
      public var loaderMC:MovieClip;
      
      public var login_manager:LoginManager;
      
      public var amf_manager:*;
      
      public var stat_manager:StatManager;
      
      public var var_manager:VarManager;
      
      public var outfit_manager:OutfitManager;
      
      public var HUD:*;
      
      public var village:*;
      
      public var combat:*;
      
      public var GetNotice:*;
      
      public var pvp_tooltip:ToolTip;
      
      public var dimFilter:ColorMatrixFilter;
      
      public var panel_class:Class = null;
      
      public var panel_graph:* = null;
      
      public var dialogue:*;
      
      public var dialogue_texts:*;
      
      public var dialogue_nr:*;
      
      public var dialogue_callback:Function = null;
      
      public var is_exam_stage2:Boolean = false;
      
      public var is_exam_stage3:Boolean = false;
      
      public var is_exam_stage4:Boolean = false;
      
      public var is_exam_stage5:Boolean = false;
      
      public var is_jounin_exam_stage2:Boolean = false;
      
      public var is_jounin_exam_stage3:Boolean = false;
      
      public var is_jounin_exam_stage4:Boolean = false;
      
      public var is_jounin_exam_stage5:Boolean = false;
      
      public var is_special_jounin_exam_s1c2:Boolean = false;
      
      public var is_special_jounin_exam_s2c2:Boolean = false;
      
      public var is_special_jounin_exam_s3c2:Boolean = false;
      
      public var is_special_jounin_exam_s4c2:Boolean = false;
      
      public var is_special_jounin_exam_s5c2:Boolean = false;
      
      public var is_special_jounin_exam_s6c1:Boolean = false;
      
      public var is_special_jounin_exam_s6c2:Boolean = false;
      
      public var is_special_jounin_exam_s6c3:Boolean = false;
      
      public var is_ninja_tutor_exam_s1c2:Boolean = false;
      
      public var is_ninja_tutor_exam_s2c2:Boolean = false;
      
      public var is_ninja_tutor_exam_s3c2:Boolean = false;
      
      public var is_ninja_tutor_exam_s4c2:Boolean = false;
      
      public var is_ninja_tutor_exam_s5c2:Boolean = false;
      
      public var is_ninja_tutor_exam_s6c1:Boolean = false;
      
      public var is_ninja_tutor_exam_s6c2:Boolean = false;
      
      public var is_ambush_battle:Boolean = false;
      
      public var is_grade_s_stage_4:Boolean = false;
      
      public var is_grade_s_stage_5:Boolean = false;
      
      public var exam_msn:* = "mission_55.swf";
      
      public var exam_msn_class:* = null;
      
      public var exam_enemy:* = "";
      
      public var exam_enemy_mc:*;
      
      public var exam_enemy_loaded:Boolean = false;
      
      public var exam_stage:*;
      
      public var exam_panel_mc:*;
      
      public var last_hp:* = 0;
      
      public var stage3_battle:* = 0;
      
      public var stage3_enemies:Array = ["ene_65","ene_63","ene_64"];
      
      public var stage4_enemies:Array = ["ene_68","ene_67","ene_66"];
      
      public var stage5_enemies:Array = ["ene_45","ene_59"];
      
      public var sakura_battle_enemies:*;
      
      public var sakura_battle_counter:int = 0;
      
      public var summer_battle_enemies:*;
      
      public var summer_battle_counter:int = 0;
      
      public var thanksgiving_battle_enemies:*;
      
      public var thanksgiving_battle_counter:int = 0;
      
      public var valentine_battle_enemies:*;
      
      public var valentine_battle_counter:int = 0;
      
      public var grade_s_battle_enemies:Array = [];
      
      public var grade_s_battle_counter:int = 0;
      
      public var confronting_death_battle_counter:int = 0;
      
      public var confronting_death_scene:String;
      
      public var christmas_battle_counter:int = 0;
      
      public var christmas_scene:String;
      
      public var ambushBattleData:Object;
      
      public var remainingStatus:Array = [];
      
      public var man_pan:* = null;
      
      public var clan_Battle_res:*;
      
      public var exam_swf_event:Event = null;
      
      public var panel_msg_graph:* = null;
      
      internal var itemToLoad:Sprite;
      
      public var bgm_enabled:Boolean = false;
      
      public var extSwfPanel:*;
      
      public var extClassLoaded:*;
      
      public var panelLoader:*;
      
      private var loadSkillSWFCallback:* = null;
      
      private var loaderSkillSWF:* = null;
      
      private var loadSkillSWFId:* = null;
      
      public var eventHandler:*;
      
      public var battleCount:* = 0;
      
      public var skillLoaders:* = [];
      
      public var outfitManagerTemp:*;
      
      private var loadedPanels:* = {};
      
      private var useExtSwfScript:Boolean = false;
      
      private var previousBgm:* = null;
      
      public var loaderContext:LoaderContext;
      
      public var payment:* = null;
      
      public var confirmation:Confirmation;
      
      public function main()
      {
         super();
         this.loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain,null);
         AppManager.boot(this,stage);
      }
      
      public function isPaymentSupported() : Boolean
      {
         return this.payment != null && Boolean(this.payment.setupSuccess);
      }
      
      public function getPvpTooltip() : *
      {
         return this.pvp_tooltip;
      }
      
      public function getPetLibrary() : *
      {
         return PetInfo;
      }
      
      public function getLibrary() : *
      {
         return Library;
      }
      
      public function getSkillLibrary() : *
      {
         return SkillLibrary;
      }
      
      public function getSkillBuffs() : *
      {
         return SkillBuffs;
      }
      
      public function getArenaBuffs() : *
      {
         return ArenaBuffs;
      }
      
      public function getSenjutsuInfo() : *
      {
         return SenjutsuInfo;
      }
      
      public function getSenjutsuSkillDescriptions() : *
      {
         return SenjutsuSkillDescriptions;
      }
      
      public function getSenjutsuSkillLevel() : *
      {
         return SenjutsuSkillLevel;
      }
      
      public function getSenjutsuLevelLearnRequirements() : *
      {
         return SenjutsuLevelLearnRequirements;
      }
      
      public function getNinjaSage() : *
      {
         return NinjaSage;
      }
      
      public function hashCrypto() : *
      {
         var _loc1_:* = Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([Character.char_id,Character.sessionkey].join("|")))));
      }
      
      public function loadVillageAndHUD() : *
      {
         if(Character.is_new_village)
         {
            this.startBgm("new_bgm");
            this.loadPanel("Panels.NewVillage");
            this.loadPanel("Panels.NewHUD");
         }
         else
         {
            this.startBgm("bgm");
            this.loadPanel("Panels.Village");
            this.loadPanel("Panels.HUD");
         }
      }
      
      public function openFriendProfile(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:* = Character.is_new_village ? "Panels.New_UI_Friend_Profile" : "Panels.UI_Friend_Profile";
         var _loc4_:* = getDefinitionByName(_loc3_) as Class;
         var _loc5_:* = new _loc4_(this,param1,param2);
         this.loader.addChild(_loc5_);
      }
      
      public function removeAllChild(param1:*) : *
      {
         GF.removeAllChild(param1);
      }
      
      public function showConfirmation(param1:String, param2:Function, param3:Function = null) : *
      {
         var message:String = param1;
         var callback:Function = param2;
         var closeCallback:Function = param3;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = message;
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
            if(callback != null)
            {
               if(callback.length > 0)
               {
                  callback(null);
               }
               else
               {
                  callback();
               }
            }
         });
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
            if(closeCallback != null)
            {
               if(closeCallback.length > 0)
               {
                  closeCallback(null);
               }
               else
               {
                  closeCallback();
               }
            }
         });
         this.loader.addChild(this.confirmation);
      }
      
      public function loadEnemySWF(param1:*, param2:*) : *
      {
         var _loc3_:* = BulkLoader.getLoader("combat");
         var _loc4_:* = _loc3_.add("enemy/" + param1 + ".swf");
         _loc4_.addEventListener(BulkLoader.COMPLETE,param2);
         _loc3_.start();
      }
      
      public function loadNpcSWF(param1:*, param2:*) : *
      {
         var _loc3_:* = BulkLoader.getLoader("combat");
         var _loc4_:* = _loc3_.add("npcs/" + param1 + ".swf");
         _loc4_.addEventListener(BulkLoader.COMPLETE,param2);
         _loc3_.start();
      }
      
      public function getTooltipTextForItem(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         if(param1.indexOf("token") >= 0)
         {
            return "(Tokens) " + param1.split("_")[1];
         }
         if(param1.indexOf("gold") >= 0)
         {
            return "(Golds) " + param1.split("_")[1];
         }
         if(param1.indexOf("tp") >= 0)
         {
            return "(Talent Points) " + param1.split("_")[1];
         }
         if(param1.indexOf("skill_") >= 0)
         {
            _loc2_ = SkillLibrary.getSkillInfo(param1);
            return "" + _loc2_["skill_name"] + "\n(Skill)\n" + "\nLevel " + _loc2_["skill_level"] + "\nDamage: " + _loc2_["skill_damage"] + "\nCP Cost: " + _loc2_["skill_cp_cost"] + "\nCooldown: " + _loc2_["skill_cooldown"] + "\n\n" + _loc2_["skill_description"];
         }
         if(param1.indexOf("wpn_") >= 0)
         {
            _loc2_ = Library.getItemInfo(param1);
            return "" + _loc2_["item_name"] + "\n(Weapon)\n" + "\nLevel " + _loc2_["item_level"] + "\nDamage : " + _loc2_["item_damage"] + "\n\n" + _loc2_["item_description"];
         }
         if(param1.indexOf("pet_") >= 0)
         {
            _loc2_ = PetInfo.getPetStats(param1);
            return "" + _loc2_["pet_name"] + "\n(Pet)\n" + "\n\n" + _loc2_["description"];
         }
         _loc2_ = Library.getItemInfo(param1);
         _loc3_ = "Item";
         if(param1.indexOf("back_") >= 0)
         {
            _loc3_ = "Back Item";
         }
         if(param1.indexOf("set_") >= 0)
         {
            _loc3_ = "Clothing";
         }
         if(param1.indexOf("hair_") >= 0)
         {
            _loc3_ = "Hairstyle";
         }
         if(param1.indexOf("accessory_") >= 0)
         {
            _loc3_ = "Accessory";
         }
         return "" + _loc2_["item_name"] + "\n(" + _loc3_ + ")\n" + "\nLevel " + _loc2_["item_level"] + "\n\n" + _loc2_["item_description"];
      }
      
      public function loadSkillSWF(param1:*, param2:*) : *
      {
         var _loc3_:* = BulkLoader.getLoader("combat");
         var _loc4_:* = _loc3_.add("skills/" + param1 + ".swf");
         _loc4_.addEventListener(BulkLoader.COMPLETE,param2);
         _loc3_.start();
      }
      
      public function loadPetSWF(param1:*, param2:*) : *
      {
         var _loc3_:* = BulkLoader.getLoader("combat");
         var _loc4_:* = _loc3_.add("pets/" + param1 + ".swf");
         _loc4_.addEventListener(BulkLoader.COMPLETE,param2);
         _loc3_.start();
      }
      
      public function loadSkillSWF2(param1:*, param2:*) : *
      {
         var _loc4_:* = undefined;
         this.loadSkillSWFCallback = param2;
         var _loc3_:* = BulkLoader.getLoader("etc");
         if(param1 is Array)
         {
            for each(_loc4_ in param1)
            {
               _loc3_.add("skills/" + _loc4_ + ".swf");
            }
         }
         else
         {
            _loc3_.add("skills/" + param1 + ".swf");
         }
         _loc3_.addEventListener(BulkLoader.COMPLETE,this.onLoadedSkillSWF2,false,0,true);
         _loc3_.start();
         _loc3_ = null;
      }
      
      private function onLoadedSkillSWF2(param1:*) : *
      {
         var _loc2_:* = BulkLoader.getLoader("etc");
         this.loadSkillSWFCallback(_loc2_.items);
         _loc2_.removeEventListener(BulkLoader.COMPLETE,this.onLoadedSkillSWF2);
         _loc2_ = null;
         this.loadSkillSWFCallback = null;
      }
      
      public function makeChunin(param1:Array) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1.length > 0)
         {
            Character.character_rank = "3";
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1[_loc2_];
               if(_loc3_.indexOf("wpn_") >= 0)
               {
                  Character.addWeapon(_loc3_);
               }
               else if(_loc3_.indexOf("set_") >= 0)
               {
                  Character.addSet(_loc3_);
               }
               else if(_loc3_.indexOf("skill_") >= 0)
               {
                  Character.updateSkills(_loc3_);
               }
               else if(_loc3_.indexOf("tokens_") >= 0)
               {
                  Character.account_tokens += int(_loc3_.split("_")[1]);
               }
               _loc2_++;
            }
            this.HUD.setBasicData();
            this.HUD.loadFrame();
            this.giveReward(1,param1);
         }
      }
      
      public function makeJounin(param1:Array) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1.length > 0)
         {
            Character.character_rank = "5";
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1[_loc2_];
               if(_loc3_.indexOf("wpn_") >= 0)
               {
                  Character.addWeapon(_loc3_);
               }
               else if(_loc3_.indexOf("set_") >= 0)
               {
                  Character.addSet(_loc3_);
               }
               else if(_loc3_.indexOf("skill_") >= 0)
               {
                  Character.updateSkills(_loc3_);
               }
               else if(_loc3_.indexOf("material_") >= 0)
               {
                  Character.addMaterials(_loc3_);
               }
               else if(_loc3_.indexOf("tokens_") >= 0)
               {
                  Character.account_tokens += int(_loc3_.split("_")[1]);
               }
               _loc2_++;
            }
            this.HUD.setBasicData();
            this.giveReward(1,param1);
         }
      }
      
      public function getError(param1:String) : *
      {
         var _loc2_:* = new ErrorManager(this);
         this.loaderMC = _loc2_;
         _loc2_.errorInfo(param1);
         this.addChild(this.loaderMC);
      }
      
      public function handleVillageHUDVisibility(param1:Boolean = true) : *
      {
         if(this.loadedPanels["Panels.Village"] != null || this.loadedPanels["Panels.HUD"] != null || this.loadedPanels["Panels.NewVillage"] != null || this.loadedPanels["Panels.NewHUD"] != null)
         {
            if(this.loadedPanels.hasOwnProperty("Panels.Village"))
            {
               this.loadedPanels["Panels.Village"].visible = param1;
            }
            if(this.loadedPanels.hasOwnProperty("Panels.HUD"))
            {
               this.loadedPanels["Panels.HUD"].visible = param1;
            }
            if(this.loadedPanels.hasOwnProperty("Panels.NewVillage"))
            {
               this.loadedPanels["Panels.NewVillage"].visible = param1;
            }
            if(this.loadedPanels.hasOwnProperty("Panels.NewHUD"))
            {
               this.loadedPanels["Panels.NewHUD"].visible = param1;
            }
         }
      }
      
      public function loadPanel(param1:String, param2:Boolean = false) : *
      {
         if(Boolean(param1.indexOf("Popups.") < 0 && this.combat == null) && Boolean(this.panel_graph) && "destroy" in this.panel_graph)
         {
            this.panel_graph.destroy();
            this.panel_graph = null;
         }
         var _loc3_:* = undefined;
         this.panel_class = getDefinitionByName(param1) as Class;
         if(param1 == "Combat.Battle")
         {
            if(!StorageLoader.completed && (!Library.constructed || !SkillLibrary.constructed || !SkillBuffs.constructed))
            {
               this.showMessage("Game library not properly initialized. Trying to relogin");
               this.logout(null);
               return;
            }
            if(this.combat)
            {
               this.combat.destroy();
               this.combat = null;
            }
            if(!this.is_exam_stage3 && !this.is_jounin_exam_stage2 && !Character.is_clan_war && !Character.is_hanami_event && !Character.is_christmas_event)
            {
               _loc3_ = 0;
               while(_loc3_ < Character.character_recruit_ids.length)
               {
                  Character.battle_characters.push(Character.character_recruit_ids[_loc3_]);
                  _loc3_++;
               }
            }
            Character.teammate_controllable = false;
            if(this.is_jounin_exam_stage4 || this.is_jounin_exam_stage5)
            {
               Character.teammate_controllable = true;
            }
            if(this.is_exam_stage5)
            {
               Character.temp_recruit_ids = ["npc_1","npc_2"];
            }
            if(Character.is_independence_event)
            {
               Character.temp_recruit_ids = ["npc_107"];
            }
            if(this.is_exam_stage2 || this.is_exam_stage3 || this.is_jounin_exam_stage2 || this.is_jounin_exam_stage3 || this.is_jounin_exam_stage5 || this.is_special_jounin_exam_s1c2 || this.is_special_jounin_exam_s2c2 || this.is_special_jounin_exam_s3c2 || this.is_special_jounin_exam_s4c2 || this.is_special_jounin_exam_s5c2 || this.is_special_jounin_exam_s6c1 || this.is_special_jounin_exam_s6c2 || this.is_special_jounin_exam_s6c3 || this.is_ninja_tutor_exam_s1c2 || this.is_ninja_tutor_exam_s2c2 || this.is_ninja_tutor_exam_s3c2 || this.is_ninja_tutor_exam_s4c2 || this.is_ninja_tutor_exam_s5c2 || this.is_ninja_tutor_exam_s6c1 || this.is_ninja_tutor_exam_s6c2 || this.is_ambush_battle || this.is_grade_s_stage_4 || this.is_grade_s_stage_5)
            {
               this.is_exam_stage2 = false;
            }
            else
            {
               OutfitManager.removeChildsFromMovieClips(this.loader);
            }
            if(this.HUD)
            {
               this.HUD = null;
            }
            if(Boolean(this.panel_graph) && "destroy" in this.panel_graph)
            {
               this.panel_graph.destroy();
               this.panel_graph = null;
            }
            this.removeAllLoadedPanels();
         }
         if(this.shouldReuseObjects(param1))
         {
            if(!this.loadedPanels.hasOwnProperty(param1))
            {
               this.loadedPanels[param1] = new this.panel_class(this);
            }
            if(param1 == "Panels.HUD" || param1 == "Panels.NewHUD")
            {
               this.HUD = this.loadedPanels[param1];
            }
            if(param1 != "Panels.Village" && param1 != "Panels.HUD" && param1 != "Panels.NewVillage" && param1 != "Panels.NewHUD")
            {
               OutfitManager.removeChildsFromMovieClips(this.loader);
            }
            this.loadedPanels[param1].name = param1;
            this.loader.addChild(this.loadedPanels[param1]);
            return this.loadedPanels[param1];
         }
         this.panel_graph = new this.panel_class(this);
         this.panel_graph.name = param1;
         this.loader.addChild(this.panel_graph);
         if(param2)
         {
            return this.panel_graph;
         }
         this.panel_graph = null;
      }
      
      public function showDialogue(param1:*, param2:Function = null, param3:* = "shin") : *
      {
         if(this.dialogue)
         {
            this.dialogue.clickMc.removeEventListener(MouseEvent.CLICK,this.nextDialog);
            GF.removeAllChild(this.dialogue);
            this.dialogue = null;
            this.dialogue_callback = null;
         }
         this.dialogue_nr = 0;
         this.dialogue = new Dialogue(param3);
         param1 = this.replaceVariables(param1);
         this.dialogue_texts = param1;
         this.dialogue_callback = param2;
         this.dialogue.dialogueTxt.text = param1[this.dialogue_nr];
         this.dialogue.clickMc.addEventListener(MouseEvent.CLICK,this.nextDialog,false,0,true);
         this.addChild(this.dialogue);
      }
      
      public function showDialogueNew(param1:*, param2:Function = null, param3:MovieClip = null) : *
      {
         this.dialogue = new Dialogue("");
         param1 = this.replaceVariables(param1);
         this.dialogue_texts = param1;
         this.dialogue_callback = param2;
         this.dialogue.dialogueTxt.text = param1[0];
         this.dialogue.addNpcImage(param3);
         this.dialogue.clickMc.addEventListener(MouseEvent.CLICK,this.nextDialog,false,0,true);
         this.addChild(this.dialogue);
      }
      
      public function replaceVariables(param1:*) : Array
      {
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_] = param1[_loc2_].replace("[playername]",Character.character_name);
            _loc2_++;
         }
         return param1;
      }
      
      public function nextDialog(param1:MouseEvent) : *
      {
         var event:MouseEvent = param1;
         ++this.dialogue_nr;
         if(this.dialogue_texts.length > this.dialogue_nr)
         {
            this.dialogue.dialogueTxt.text = this.dialogue_texts[this.dialogue_nr];
         }
         else
         {
            try
            {
               this.removeChild(this.dialogue);
            }
            catch(e:*)
            {
            }
            if(this.dialogue_callback != null)
            {
               this.dialogue_callback();
            }
         }
      }
      
      public function disableButton(param1:*) : *
      {
         param1.last_filters = param1.filters;
         param1.is_enabled = false;
         param1.filters = [this.dimFilter];
      }
      
      public function enableButton(param1:*) : *
      {
         param1.is_enabled = true;
         param1.filters = [];
      }
      
      public function initButton(param1:*, param2:*, param3:* = "") : *
      {
         if(param3 != "")
         {
            param1.txt.text = param3;
         }
         param1.filters = [];
         param1.gotoAndStop(1);
         param1.buttonMode = true;
         if(param2 != null)
         {
            this.eventHandler.addListener(param1,MouseEvent.MOUSE_OUT,this.onOutButton,false,0,true);
            this.eventHandler.addListener(param1,MouseEvent.MOUSE_OVER,this.onOverButton,false,0,true);
            this.eventHandler.addListener(param1,MouseEvent.CLICK,param2,false,0,true);
         }
      }
      
      public function initButtonDisable(param1:*, param2:*, param3:* = "") : *
      {
         if(param3 != "")
         {
            param1.txt.text = param3;
         }
         param1.gotoAndStop(1);
         param1.buttonMode = true;
         param1.last_filters = param1.filters;
         param1.filters = [this.dimFilter];
         if(param2 != null)
         {
            this.eventHandler.addListener(param1,MouseEvent.MOUSE_OUT,this.onOutButton,false,0,true);
            this.eventHandler.addListener(param1,MouseEvent.MOUSE_OVER,this.onOverButton,false,0,true);
            this.eventHandler.removeListener(param1,MouseEvent.CLICK,param2);
         }
      }
      
      public function removeButtonListener(param1:*, param2:*, param3:* = "") : *
      {
         if("filters" in param1)
         {
            param1.filters = [];
         }
         if("last_filters" in param1)
         {
            param1.last_filters = [];
         }
         param1.buttonMode = false;
         this.eventHandler.removeListener(param1,MouseEvent.MOUSE_OUT,this.onOutButton);
         this.eventHandler.removeListener(param1,MouseEvent.MOUSE_OVER,this.onOverButton);
         this.eventHandler.removeListener(param1,MouseEvent.CLICK,param2);
      }
      
      public function clearEvents() : *
      {
         this.eventHandler.removeAllEventListeners();
      }
      
      public function onOutButton(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(1);
      }
      
      public function onOverButton(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(2);
      }
      
      public function getSkillIcon(param1:*, param2:*, param3:* = null) : *
      {
         var loader:*;
         var loadItem:*;
         var item_id:* = param1;
         var holder:* = param2;
         var mc:* = param3;
         var item_info:* = SkillLibrary.getSkillInfo(item_id);
         if(mc != null)
         {
            mc.text = item_info.skill_name;
         }
         loader = BulkLoader.getLoader("assets");
         loadItem = loader.add("skills/" + item_id + ".swf");
         loadItem.addEventListener(BulkLoader.COMPLETE,function(param1:*):*
         {
            onSkillSWFLoaded(param1,holder);
         });
         loader.start();
      }
      
      public function onSkillSWFLoaded(param1:Event, param2:*) : *
      {
         param1.target.content.stopAllMovieClips();
         var _loc3_:MovieClip = param1.target.content.icon;
         GF.removeAllChild(param2);
         param2.addChild(_loc3_);
      }
      
      public function getSkillAnimation(param1:*, param2:*, param3:* = null) : *
      {
         var loader:*;
         var url_request:*;
         var item_id:* = undefined;
         var skillId:* = param1;
         var holder:* = param2;
         var labelMc:* = param3;
         item_id = skillId;
         var item_info:* = SkillLibrary.getSkillInfo(item_id);
         if(labelMc != null)
         {
            labelMc.text = item_info.skill_name;
         }
         loader = new Loader();
         url_request = new URLRequest(Util.url("skills/" + item_id + ".swf"));
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:*):*
         {
            onSkillSWFAnimationLoaded(param1,holder,item_id);
         });
         loader.load(url_request);
      }
      
      public function onSkillSWFAnimationLoaded(param1:Event, param2:*, param3:*) : *
      {
         var _loc4_:* = param1.target.applicationDomain.getDefinition(param3) as Class;
         var _loc5_:MovieClip = new _loc4_(this,"player",0,_loc4_);
         param2.addChild(_loc5_);
      }
      
      public function copyClip(param1:MovieClip) : *
      {
         var _loc2_:Class = Object(param1).constructor;
         return new _loc2_();
      }
      
      public function loadPvpPanel() : void
      {
         this.panelLoader.removeAll();
         var _loc1_:* = this.panelLoader.add("swfpanels/pvp_panel.swf");
         _loc1_.addEventListener(BulkLoader.COMPLETE,this.onPvpPanelLoaded);
         this.panelLoader.start();
      }
      
      public function onPvpPanelLoaded(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:MovieClip = param1.target.content;
         _loc3_.cacheAsBitmap = true;
         _loc3_.init(this,Character);
         this.loadSwfPanel(_loc3_);
      }
      
      public function loadJouninStage(param1:*) : *
      {
         var _loc3_:Class = null;
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.showMessage("Please equip at least 1 skill");
            return;
         }
         if(param1 == "stage1")
         {
            this.exam_msn = "mission_132.swf";
            this.exam_msn_class = ExamManager.getJouninExamClass(1);
         }
         else if(param1 == "stage2")
         {
            this.exam_msn = "mission_133.swf";
            this.exam_msn_class = ExamManager.getJouninExamClass(2);
         }
         else if(param1 == "stage3")
         {
            this.exam_msn = "mission_134.swf";
            this.exam_msn_class = ExamManager.getJouninExamClass(3);
         }
         else
         {
            if(param1 == "stage4")
            {
               _loc3_ = ExamManager.getJouninExamClass(4);
               this.exam_stage = new _loc3_(this);
               this.removeAllChildsFromLoader();
               return;
            }
            if(param1 == "stage5")
            {
               this.exam_msn = "mission_136.swf";
               this.exam_msn_class = ExamManager.getJouninExamClass(5);
            }
         }
         var _loc2_:* = this.panelLoader.add("mission/" + this.exam_msn);
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.onStageSWFLoaded);
         this.panelLoader.start();
      }
      
      public function loadKekkai() : *
      {
         var _loc1_:Loader = new Loader();
         _loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onKekkaiLoaded);
         _loc1_.load(new URLRequest(Util.url("swfpanels/ValentineKekkaiGame.swf")));
      }
      
      public function onKekkaiLoaded(param1:Event) : *
      {
         var _loc2_:Class = param1.target.applicationDomain.getDefinition("ValentineKekkaiGame") as Class;
         var _loc3_:* = this.createPlayerMc();
         var _loc4_:* = new _loc2_(this,Character,_loc3_);
         this.addChild(_loc4_);
      }
      
      public function loadMissionMiniGame(param1:*, param2:*, param3:* = "mission") : *
      {
         var swfName:* = param1;
         var className:* = param2;
         var path:* = param3;
         var loadItem:* = this.panelLoader.add(path + "/" + swfName + ".swf");
         loadItem.addEventListener(BulkLoader.COMPLETE,function(param1:Event):*
         {
            onMiniGameLoaded(param1,className);
         });
         this.panelLoader.start();
      }
      
      public function onMiniGameLoaded(param1:Event, param2:String) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc4_:Class = param1.target.getDefinitionByName(param2) as Class;
         var _loc5_:* = new _loc4_(this,Character);
         OutfitManager.removeChildsFromMovieClips(this.loader);
         this.loader.addChild(_loc5_);
      }
      
      public function loadAmbushBattle() : *
      {
         var _loc1_:* = this.panelLoader.add("swfpanels/Ambush.swf");
         _loc1_.addEventListener(BulkLoader.COMPLETE,this.onAmbushLoaded);
         this.panelLoader.start();
      }
      
      public function onAmbushLoaded(param1:Event) : *
      {
         var _loc2_:MovieClip = param1.target.content;
         var _loc3_:* = this.createPlayerMc();
         var _loc4_:Class = getDefinitionByName("id.ninjasage.features.Ambush") as Class;
         this.exam_stage = new _loc4_(this,_loc2_,_loc3_);
         this.loader.addChild(_loc2_);
      }
      
      public function startAmbushBattle() : *
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         var _loc1_:Array = ["mission_1032","mission_1033","mission_1034"];
         var _loc2_:Array = [];
         var _loc3_:String = "mission_04";
         if(this.ambushBattleData.current_engagement != this.ambushBattleData.max_engagement)
         {
            _loc5_ = Character.is_delivery_event ? int(Math.floor(Math.random() * 3) + 1) : 3;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = Math.floor(Math.random() * this.ambushBattleData.random_enemy.length);
               _loc2_.push(this.ambushBattleData.random_enemy[_loc7_]);
               _loc6_++;
            }
         }
         else
         {
            _loc2_ = this.ambushBattleData.final_enemy;
         }
         this.is_ambush_battle = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         var _loc4_:* = Character.is_delivery_event ? BattleVars.EVENT_MATCH : BattleVars.MISSION_MATCH;
         if(Character.is_delivery_event)
         {
            _loc7_ = Math.floor(Math.random() * _loc1_.length);
            _loc3_ = _loc1_[_loc7_];
         }
         BattleManager.init(this.combat,this,_loc4_,_loc3_);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         _loc6_ = 0;
         while(_loc6_ < _loc2_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[_loc6_]);
            _loc6_++;
         }
         BattleManager.startBattle();
      }
      
      public function continueAmbushBattle() : *
      {
         this.exam_stage.resume();
         this.loader.removeChild(this.combat);
      }
      
      public function loadStage4GradeS() : *
      {
         this.exam_msn_class = ExamManager.getGradeSClass(4);
         this.panelLoader.removeAll();
         var _loc1_:* = this.panelLoader.add("mission/mission_277.swf");
         _loc1_.addEventListener(BulkLoader.COMPLETE,this.onStage4GradeSLoaded);
         this.panelLoader.start();
      }
      
      public function onStage4GradeSLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.exam_panel_mc = param1.target.content;
         this.exam_stage = new this.exam_msn_class(this,this.exam_panel_mc);
         this.loadSwfPanel();
      }
      
      public function startStage4GradeSBattle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = [["ene_453","ene_452","ene_453"],["ene_451","ene_453","ene_451"],["ene_454"],["ene_452","ene_451","ene_452"],["ene_454"],["ene_453","ene_453","ene_451"],["ene_454"]];
         this.grade_s_battle_counter = param1;
         this.is_grade_s_stage_4 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.MISSION_MATCH,"mission_277","BattleBG" + param1);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_[param1 - 1].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[param1 - 1][_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function continueStage4GradeS() : *
      {
         if(this.grade_s_battle_counter == 1)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy1_killed = true;
         }
         if(this.grade_s_battle_counter == 2)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy2_killed = true;
         }
         if(this.grade_s_battle_counter == 3)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy3_killed = true;
         }
         if(this.grade_s_battle_counter == 4)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy4_killed = true;
         }
         if(this.grade_s_battle_counter == 5)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy5_killed = true;
         }
         if(this.grade_s_battle_counter == 6)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy6_killed = true;
         }
         if(this.grade_s_battle_counter == 7)
         {
            this.exam_stage.enemy7_killed = true;
         }
         this.loader.removeChild(this.combat);
         this.combat = null;
      }
      
      public function loadStage5GradeS() : *
      {
         this.exam_msn_class = ExamManager.getGradeSClass(5);
         this.panelLoader.removeAll();
         var _loc1_:* = this.panelLoader.add("mission/mission_278.swf");
         _loc1_.addEventListener(BulkLoader.COMPLETE,this.onStage5GradeSLoaded);
         this.panelLoader.start();
      }
      
      public function onStage5GradeSLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.exam_panel_mc = param1.target.content;
         this.exam_stage = new this.exam_msn_class(this,this.exam_panel_mc);
         this.loadSwfPanel();
      }
      
      public function startStage5GradeSBattle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = [["ene_456","ene_456","ene_458"],["ene_458","ene_456","ene_458"],["ene_457","ene_456","ene_457"],["ene_459","ene_458","ene_456"]];
         this.grade_s_battle_counter = param1;
         this.is_grade_s_stage_5 = true;
         var _loc3_:String = param1 == 4 ? "BattleBG1" : "BattleBG";
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.MISSION_MATCH,"mission_278",_loc3_);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_[param1 - 1].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[param1 - 1][_loc4_]);
            _loc4_++;
         }
         BattleManager.startBattle();
      }
      
      public function continueStage5GradeS() : *
      {
         if(this.grade_s_battle_counter == 1)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy1_killed = true;
         }
         if(this.grade_s_battle_counter == 2)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy2_killed = true;
         }
         if(this.grade_s_battle_counter == 3)
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy3_killed = true;
         }
         if(this.grade_s_battle_counter == 4)
         {
            this.exam_stage.enemy7_killed = true;
         }
         this.loader.removeChild(this.combat);
         this.combat = null;
      }
      
      public function loadSpecialJouninStage(param1:*) : *
      {
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.showMessage("Please equip at least 1 skill");
            return;
         }
         if(param1 == "stage1c1")
         {
            this.exam_msn = "mission_200.swf";
            this.exam_msn_class = "Mission_200";
         }
         else if(param1 == "stage1c2")
         {
            this.exam_msn = "mission_205.swf";
            this.exam_msn_class = ExamManager.getSpecialJouninExamClass(1,2);
         }
         else if(param1 == "stage2c1")
         {
            this.exam_msn = "mission_202.swf";
            this.exam_msn_class = "Mission_202";
         }
         else if(param1 == "stage2c2")
         {
            this.exam_msn = "mission_206.swf";
            this.exam_msn_class = ExamManager.getSpecialJouninExamClass(2,2);
         }
         else if(param1 == "stage3c1")
         {
            this.exam_msn = "mission_203.swf";
            this.exam_msn_class = "Mission_203";
         }
         else if(param1 == "stage3c2")
         {
            this.exam_msn = "mission_207.swf";
            this.exam_msn_class = ExamManager.getSpecialJouninExamClass(3,2);
         }
         else if(param1 == "stage4c1")
         {
            this.exam_msn = "mission_204.swf";
            this.exam_msn_class = "Mission_204";
         }
         else if(param1 == "stage4c2")
         {
            this.exam_msn = "mission_208.swf";
            this.exam_msn_class = ExamManager.getSpecialJouninExamClass(4,2);
         }
         else if(param1 == "stage5c1")
         {
            this.exam_msn = "mission_201.swf";
            this.exam_msn_class = "Mission_201";
         }
         else if(param1 == "stage5c2")
         {
            this.exam_msn = "mission_209.swf";
            this.exam_msn_class = ExamManager.getSpecialJouninExamClass(5,2);
         }
         else if(param1 == "stage6c1")
         {
            this.exam_msn = "mission_210.swf";
            this.exam_msn_class = ExamManager.getSpecialJouninExamClass(6,1);
         }
         else if(param1 == "stage6c2")
         {
            this.exam_msn = "mission_211.swf";
            this.exam_msn_class = ExamManager.getSpecialJouninExamClass(6,2);
         }
         else if(param1 == "stage6c3")
         {
            this.exam_msn = "mission_212.swf";
            this.exam_msn_class = ExamManager.getSpecialJouninExamClass(6,3);
         }
         var _loc2_:Function = param1.split("c")[1] == "2" || param1.split("c")[0] == "stage6" ? this.onStageSWFLoaded : this.onStageSWFLoaded1;
         this.panelLoader.removeAll();
         var _loc3_:* = this.panelLoader.add("mission/" + this.exam_msn);
         _loc3_.addEventListener(BulkLoader.COMPLETE,_loc2_);
         this.panelLoader.start();
      }
      
      public function onStageSWFLoaded1(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:* = undefined;
         if(this.exam_msn_class == "Mission_135")
         {
            this.exam_swf_event = param1;
         }
         this.loading(false);
         var _loc4_:Class = param1.target.getDefinitionByName(this.exam_msn_class) as Class;
         if(this.exam_msn_class == "Mission_56" || this.exam_msn_class == "Mission_133" || this.exam_msn_class == "Mission_134" || this.exam_msn_class == "Mission_136" || this.exam_msn_class == "Mission_205" || this.exam_msn_class == "Mission_206" || this.exam_msn_class == "Mission_207" || this.exam_msn_class == "Mission_208" || this.exam_msn_class == "Mission_209" || this.exam_msn_class == "Mission_210" || this.exam_msn_class == "Mission_211" || this.exam_msn_class == "Mission_212" || this.exam_msn_class == "Mission_259" || this.exam_msn_class == "Mission_260" || this.exam_msn_class == "Mission_261" || this.exam_msn_class == "Mission_262" || this.exam_msn_class == "Mission_263" || this.exam_msn_class == "Mission_264" || this.exam_msn_class == "Mission_265")
         {
            _loc3_ = this.createPlayerMc();
            if(this.exam_stage)
            {
               this.resetExamBooleans();
               this.exam_stage = null;
            }
            this.exam_stage = new _loc4_(this,Character,_loc3_);
         }
         else
         {
            this.exam_stage = new _loc4_(this,Character);
         }
         this.exam_stage.name = "JOUNIN_STAGE";
         this.loadSwfPanel1();
      }
      
      public function loadSwfPanel1(param1:* = null) : *
      {
         OutfitManager.removeChildsFromMovieClips(this.loader);
         if(param1 != null)
         {
            this.loader.addChild(param1);
         }
         else
         {
            this.loader.addChild(this.exam_stage);
         }
      }
      
      public function loadNinjaTutorStage(param1:*) : *
      {
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.showMessage("Please equip at least 1 skill");
            return;
         }
         if(param1 == "stage1c1")
         {
            this.exam_msn = "mission_250.swf";
            this.exam_msn_class = "Mission_250";
         }
         else if(param1 == "stage1c2")
         {
            this.exam_msn = "mission_259.swf";
            this.exam_msn_class = ExamManager.getNinjaTutorExamClass(1,2);
         }
         else if(param1 == "stage2c1")
         {
            this.exam_msn = "mission_249.swf";
            this.exam_msn_class = "Mission_249";
         }
         else if(param1 == "stage2c2")
         {
            this.exam_msn = "mission_260.swf";
            this.exam_msn_class = ExamManager.getNinjaTutorExamClass(2,2);
         }
         else if(param1 == "stage3c1")
         {
            this.exam_msn = "mission_248.swf";
            this.exam_msn_class = "Mission_248";
         }
         else if(param1 == "stage3c2")
         {
            this.exam_msn = "mission_261.swf";
            this.exam_msn_class = ExamManager.getNinjaTutorExamClass(3,2);
         }
         else if(param1 == "stage4c1")
         {
            this.exam_msn = "mission_247.swf";
            this.exam_msn_class = "Mission_247";
         }
         else if(param1 == "stage4c2")
         {
            this.exam_msn = "mission_262.swf";
            this.exam_msn_class = ExamManager.getNinjaTutorExamClass(4,2);
         }
         else if(param1 == "stage5c1")
         {
            this.exam_msn = "mission_251.swf";
            this.exam_msn_class = "Mission_251";
         }
         else if(param1 == "stage5c2")
         {
            this.exam_msn = "mission_263.swf";
            this.exam_msn_class = ExamManager.getNinjaTutorExamClass(5,2);
         }
         else if(param1 == "stage6c1")
         {
            this.exam_msn = "mission_264.swf";
            this.exam_msn_class = ExamManager.getNinjaTutorExamClass(6,1);
         }
         else if(param1 == "stage6c2")
         {
            this.exam_msn = "mission_265.swf";
            this.exam_msn_class = ExamManager.getNinjaTutorExamClass(6,2);
         }
         var _loc2_:Function = param1.split("c")[1] == "2" || param1.split("c")[0] == "stage6" ? this.onStageSWFLoaded : this.onStageSWFLoaded1;
         this.panelLoader.removeAll();
         var _loc3_:* = this.panelLoader.add("mission/" + this.exam_msn);
         _loc3_.addEventListener(BulkLoader.COMPLETE,_loc2_);
         this.panelLoader.start();
      }
      
      public function loadStage(param1:*) : *
      {
         var _loc3_:Class = null;
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.showMessage("Please equip at least 1 skill");
            return;
         }
         if(param1 == "stage1")
         {
            this.exam_msn = "mission_55.swf";
            this.exam_msn_class = ExamManager.getChuninExamClass(1);
         }
         else if(param1 == "stage2")
         {
            this.exam_msn = "mission_56.swf";
            this.exam_msn_class = ExamManager.getChuninExamClass(2);
         }
         else
         {
            if(param1 == "stage3")
            {
               _loc3_ = ExamManager.getChuninExamClass(3);
               this.exam_stage = new _loc3_(this);
               this.removeAllChildsFromLoader();
               return;
            }
            if(param1 == "stage4")
            {
               _loc3_ = ExamManager.getChuninExamClass(4);
               this.exam_stage = new _loc3_(this);
               this.removeAllChildsFromLoader();
               return;
            }
            if(param1 == "stage5")
            {
               _loc3_ = ExamManager.getChuninExamClass(5);
               this.exam_stage = new _loc3_(this);
               this.removeAllChildsFromLoader();
               return;
            }
         }
         var _loc2_:* = this.panelLoader.add("mission/" + this.exam_msn);
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.onStageSWFLoaded);
         this.panelLoader.start();
      }
      
      public function startJouninStage2(param1:*, param2:* = null) : *
      {
         if(param2 != null)
         {
            this.exam_enemy = param2;
         }
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         this.is_jounin_exam_stage2 = true;
         Character.mission_id = "jounin_stage2_" + param1;
         var _loc3_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         var _loc4_:String = param1 == 4 ? "BattleBG1" : "BattleBG";
         Character.mission_level = 20;
         Character.battle_code = "stage2";
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,_loc3_["msn_bg"],_loc4_);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy",this.exam_enemy);
         BattleManager.startBattle();
      }
      
      public function startJouninStage4() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.is_jounin_exam_stage4 = true;
         Character.is_jounin_stage_4 = true;
         Character.mission_id = "jounin_stage4";
         Character.mission_level = 20;
         Character.battle_code = "stage4";
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_135");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy","ene_98");
         BattleManager.addPlayerToTeam("enemy","ene_98");
         BattleManager.addPlayerToTeam("enemy","ene_98");
         Character.teammate_controllable = true;
         BattleManager.startBattle();
      }
      
      public function finishStage4Jounin() : *
      {
         this.resetExamBooleans();
         this.exam_stage.showSuccessDialog();
      }
      
      public function resetExamBooleans() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.is_exam_stage2 = false;
         this.is_exam_stage3 = false;
         this.is_exam_stage4 = false;
         this.is_exam_stage5 = false;
         this.stage3_battle = 0;
         this.is_jounin_exam_stage2 = false;
         this.is_jounin_exam_stage3 = false;
         this.is_jounin_exam_stage4 = false;
         this.is_jounin_exam_stage5 = false;
         Character.is_jounin_stage_4 = false;
         Character.is_jounin_stage_5_1 = false;
         Character.is_jounin_stage_5_2 = false;
         Character.is_jounin_stage_5_2_set = false;
         this.is_special_jounin_exam_s1c2 = false;
         this.is_special_jounin_exam_s2c2 = false;
         this.is_special_jounin_exam_s3c2 = false;
         this.is_special_jounin_exam_s4c2 = false;
         this.is_special_jounin_exam_s5c2 = false;
         this.is_special_jounin_exam_s6c1 = false;
         this.is_special_jounin_exam_s6c2 = false;
         this.is_special_jounin_exam_s6c3 = false;
         this.is_ninja_tutor_exam_s1c2 = false;
         this.is_ninja_tutor_exam_s2c2 = false;
         this.is_ninja_tutor_exam_s3c2 = false;
         this.is_ninja_tutor_exam_s4c2 = false;
         this.is_ninja_tutor_exam_s5c2 = false;
         this.is_ninja_tutor_exam_s6c1 = false;
         this.is_ninja_tutor_exam_s6c2 = false;
         GF.removeAllChild(this.exam_stage);
         System.pauseForGCIfCollectionImminent(0.25);
         this.exam_enemy = null;
      }
      
      public function startJouninStage5(param1:*, param2:* = null) : *
      {
         if(param2 != null)
         {
            this.exam_enemy = param2;
         }
         if(param1 == 1)
         {
            Character.is_jounin_stage_5_1 = true;
         }
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         this.is_jounin_exam_stage5 = true;
         Character.mission_id = "jounin_stage5";
         var _loc3_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         Character.mission_level = 20;
         Character.battle_code = "stage5";
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,_loc3_["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy","ene_101");
         Character.teammate_controllable = true;
         BattleManager.startBattle();
      }
      
      public function continueStage5Jounin(param1:* = 0) : *
      {
         if(param1 == 0)
         {
            this.exam_stage.dialogAfterBattle1();
            return;
         }
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         Character.is_jounin_stage_5_1 = false;
         Character.is_jounin_stage_5_2 = true;
         Character.is_jounin_stage_5_2_set = true;
         this.is_jounin_exam_stage5 = true;
         Character.mission_id = "jounin_stage5";
         var _loc2_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         Character.mission_level = 20;
         Character.battle_code = "stage5";
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,_loc2_["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy","ene_101");
         BattleManager.addPlayerToTeam("enemy","ene_99");
         BattleManager.addPlayerToTeam("enemy","ene_100");
         Character.teammate_controllable = true;
         BattleManager.startBattle();
      }
      
      public function finishStage5Jounin() : *
      {
         this.exam_stage.map.map_mc.visible = true;
         this.resetExamBooleans();
         if(this.combat)
         {
            this.combat.destroy();
            this.loader.removeChild(this.combat);
            this.combat = null;
         }
         this.exam_stage.finishExam();
      }
      
      public function continueJouninExamStage2() : *
      {
         this.exam_stage.map.map_mc.visible = true;
         if(Character.mission_id == "jounin_stage2_1")
         {
            this.exam_stage.map2_enemy_killed = true;
         }
         if(Character.mission_id == "jounin_stage2_2")
         {
            this.exam_stage.map3_enemy_killed = true;
         }
         if(Character.mission_id == "jounin_stage2_3")
         {
            this.exam_stage.map4_enemy_killed = true;
         }
         if(Character.mission_id == "jounin_stage2_4")
         {
            this.exam_stage.map5_enemy_killed = true;
            this.exam_stage.map.showFinalDialog();
         }
         GF.removeAllChild(this.exam_enemy_mc);
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
      }
      
      public function startStage2Battle1() : *
      {
         this.exam_stage.map.map_mc.visible = false;
         this.is_exam_stage2 = true;
         Character.mission_id = "stage2_1";
         Character.mission_level = 20;
         Character.battle_code = "stage2";
         var _loc1_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,_loc1_["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy",this.exam_enemy);
         BattleManager.addPlayerToTeam("enemy",this.exam_enemy);
         BattleManager.addPlayerToTeam("enemy",this.exam_enemy);
         BattleManager.startBattle();
      }
      
      public function startStage2Battle2() : *
      {
         this.exam_stage.map.map_mc.visible = false;
         this.is_exam_stage2 = true;
         Character.mission_id = "stage2_2";
         Character.mission_level = 20;
         Character.battle_code = "stage2";
         var _loc1_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,_loc1_["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy",this.exam_enemy);
         BattleManager.addPlayerToTeam("enemy",this.exam_enemy);
         BattleManager.addPlayerToTeam("enemy",this.exam_enemy);
         BattleManager.startBattle();
      }
      
      public function continueStage2(param1:*) : *
      {
         this.exam_stage.map.map_mc.visible = true;
         if(param1 == 1)
         {
            this.exam_stage.map9_enemy_killed = true;
         }
         else
         {
            this.exam_stage.map5_enemy_killed = true;
         }
         ++this.exam_stage.total_scrolls;
         this.exam_stage.updateScrolls();
         GF.removeAllChild(this.exam_enemy_mc);
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
      }
      
      public function startStage3Battle(param1:*) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.is_exam_stage3 = true;
         this.exam_enemy = this.stage3_enemies[param1];
         Character.mission_id = "stage3";
         Character.mission_level = 20;
         Character.battle_code = "stage_3";
         var _loc2_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,_loc2_["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy",this.exam_enemy);
         BattleManager.startBattle();
      }
      
      public function continueStage3() : *
      {
         if(this.stage3_battle < 2)
         {
            if(this.stage3_battle == 0)
            {
               this.exam_stage.showDialogue2();
            }
            if(this.stage3_battle == 1)
            {
               this.exam_stage.showDialogue3();
            }
            ++this.stage3_battle;
         }
         else
         {
            this.exam_stage.showDialogue4();
            this.is_exam_stage3 = false;
         }
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
      }
      
      public function startStage4Battle() : *
      {
         this.is_exam_stage4 = true;
         Character.mission_id = "stage4";
         Character.mission_level = 20;
         Character.battle_code = "stage4";
         var _loc1_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,_loc1_["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy","ene_68");
         BattleManager.addPlayerToTeam("enemy","ene_67");
         BattleManager.addPlayerToTeam("enemy","ene_66");
         BattleManager.startBattle();
      }
      
      public function continueStage4() : *
      {
         this.exam_stage.showFinalDialogue();
         this.is_exam_stage4 = false;
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
      }
      
      public function startStage5Battle() : *
      {
         this.is_exam_stage5 = true;
         Character.mission_id = "stage5";
         Character.mission_level = 20;
         Character.battle_code = "stage5";
         var _loc1_:* = MissionLibrary.getMissionInfo(Character.mission_id);
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,_loc1_["msn_bg"]);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy","ene_45");
         BattleManager.addPlayerToTeam("enemy","ene_59");
         BattleManager.startBattle();
      }
      
      public function continueStage5() : *
      {
         this.exam_stage.showDialogueAfterBattle();
         Character.character_recruit_ids = [];
         this.is_exam_stage5 = false;
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
      }
      
      public function startSpecialJouninS1C2Battle1() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_145"];
         Character.mission_id = "special_jounin_s1c2_1";
         Character.battle_code = "jounin_s1c2_1";
         this.is_special_jounin_exam_s1c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_205","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS1C2Battle2() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_144","ene_145"];
         Character.mission_id = "special_jounin_s1c2_2";
         Character.battle_code = "jounin_s1c2_2";
         this.is_special_jounin_exam_s1c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_205","BattleBG2");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS1C2Battle3() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_184","ene_186","ene_187"];
         Character.mission_id = "special_jounin_s1c2_3";
         Character.battle_code = "jounin_s1c2_3";
         this.is_special_jounin_exam_s1c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_205","BattleBG3");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function continueSpecialJouninExamS1C2() : *
      {
         this.exam_stage.map.map_mc.visible = true;
         if(Character.mission_id == "special_jounin_s1c2_1")
         {
            this.exam_stage.map1_enemy_killed = true;
         }
         if(Character.mission_id == "special_jounin_s1c2_2")
         {
            this.exam_stage.map.map_mc.char_mc.visible = true;
            this.exam_stage.map2_enemy_killed = true;
         }
         if(Character.mission_id == "special_jounin_s1c2_3")
         {
            this.exam_stage.map3_enemy_killed = true;
            this.exam_stage.map.showFinalDialog();
         }
         OutfitManager.removeChildsFromMovieClips(this.exam_enemy_mc);
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.combat = null;
      }
      
      public function startSpecialJouninS2C2Battle1() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_145","ene_144"];
         Character.mission_id = "special_jounin_s2c2_1";
         Character.battle_code = "jounin_s2c2_1";
         this.is_special_jounin_exam_s2c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_206","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS2C2Battle2() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_144","ene_145"];
         Character.mission_id = "special_jounin_s2c2_2";
         Character.battle_code = "jounin_s2c2_2";
         this.is_special_jounin_exam_s2c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_206","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS2C2Battle3() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_183","ene_144","ene_145"];
         Character.mission_id = "special_jounin_s2c2_3";
         Character.battle_code = "jounin_s2c2_3";
         this.is_special_jounin_exam_s2c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_206","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function continueSpecialJouninExamS2C2() : *
      {
         this.exam_stage.map.map_mc.visible = true;
         if(Character.mission_id == "special_jounin_s2c2_1")
         {
            this.exam_stage.map1_enemy_killed = true;
            OutfitManager.removeChildsFromMovieClips(this.exam_stage.map.map_mc.enemy_mc0);
         }
         if(Character.mission_id == "special_jounin_s2c2_2")
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.map2_enemy_killed = true;
            OutfitManager.removeChildsFromMovieClips(this.exam_stage.map.map_mc.enemy_mc1);
            if(this.exam_stage.map2_enemy_killed == true)
            {
               this.exam_stage.map.map_mc.npcMc.visible = true;
            }
         }
         if(Character.mission_id == "special_jounin_s2c2_3")
         {
            this.exam_stage.map3_enemy_killed = true;
            this.exam_stage.map.showFinalDialog();
         }
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.combat = null;
      }
      
      public function startSpecialJouninS3C2Battle1() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_144","ene_145"];
         Character.mission_id = "special_jounin_s3c2_1";
         Character.battle_code = "jounin_s3c2_1";
         this.is_special_jounin_exam_s3c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_207","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS3C2Battle2() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_185"];
         Character.mission_id = "special_jounin_s3c2_2";
         Character.battle_code = "jounin_s3c2_2";
         this.is_special_jounin_exam_s3c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_207","BattleBG2");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function continueSpecialJouninExamS3C2() : *
      {
         this.exam_stage.map.map_mc.visible = true;
         if(Character.mission_id == "special_jounin_s3c2_1")
         {
            this.exam_stage.map1_enemy_killed = true;
         }
         if(Character.mission_id == "special_jounin_s3c2_2")
         {
            this.exam_stage.map2_enemy_killed = true;
            this.exam_stage.map.showFinalDialog();
         }
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.combat = null;
      }
      
      public function startSpecialJouninS4C2Battle1() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = true;
         var _loc1_:Array = ["ene_181"];
         Character.mission_id = "special_jounin_s4c2_1";
         Character.battle_code = "jounin_s4c2_1";
         this.is_special_jounin_exam_s4c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_208","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS5C2Battle1() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = true;
         var _loc1_:Array = ["ene_182"];
         Character.mission_id = "special_jounin_s5c2_1";
         Character.battle_code = "jounin_s5c2_1";
         this.is_special_jounin_exam_s5c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_209","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS6C1Battle1() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_180"];
         Character.mission_id = "special_jounin_s6c1_1";
         Character.battle_code = "jounin_s6c1_1";
         this.is_special_jounin_exam_s6c1 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_210","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS6C2Battle1() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_188"];
         Character.mission_id = "special_jounin_s6c2_1";
         Character.battle_code = "jounin_s6c2_1";
         this.is_special_jounin_exam_s6c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_211","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSpecialJouninS6C3Battle1() : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc1_:Array = ["ene_189"];
         Character.mission_id = "special_jounin_s6c3_1";
         Character.battle_code = "jounin_s6c3_1";
         this.is_special_jounin_exam_s6c3 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_212","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc1_[_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function finishSpecialJouninExam() : *
      {
         this.exam_stage.map.map_mc.visible = true;
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.combat = null;
         this.exam_stage.showFinalDialog();
      }
      
      public function startNinjaTutorS1C2Battle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = [["ene_348"],["ene_349"],["ene_350"],["ene_356","ene_347","ene_346"]];
         Character.mission_id = "ninja_tutor_s1c2_" + param1;
         Character.battle_code = "tutor_s1c2_" + param1;
         this.is_ninja_tutor_exam_s1c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_259","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_[param1 - 1].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[param1 - 1][_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function startNinjaTutorS2C2Battle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = [["ene_357","ene_345","ene_345"],["ene_358","ene_345","ene_345"]];
         Character.mission_id = "ninja_tutor_s2c2_" + param1;
         Character.battle_code = "tutor_s2c2_" + param1;
         this.is_ninja_tutor_exam_s2c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_260","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_[param1 - 1].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[param1 - 1][_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function startNinjaTutorS3C2Battle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = ["ene_359","ene_345","ene_345"];
         Character.mission_id = "ninja_tutor_s3c2_" + param1;
         Character.battle_code = "tutor_s3c2_" + param1;
         this.is_ninja_tutor_exam_s3c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_261","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function startNinjaTutorS4C2Battle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = ["ene_360","ene_345","ene_345"];
         Character.mission_id = "ninja_tutor_s4c2_" + param1;
         Character.battle_code = "tutor_s4c2_" + param1;
         this.is_ninja_tutor_exam_s4c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_262","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function startNinjaTutorS5C2Battle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = ["ene_361","ene_345","ene_345"];
         Character.mission_id = "ninja_tutor_s5c2_" + param1;
         Character.battle_code = "tutor_s5c2_" + param1;
         this.is_ninja_tutor_exam_s5c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_263","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function startNinjaTutorS6C1Battle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = [["ene_352","ene_352","ene_352"],["ene_354","ene_354","ene_354"],["ene_353","ene_353","ene_353"],["ene_351","ene_351","ene_351"],["ene_355","ene_355","ene_355"]];
         Character.mission_id = "ninja_tutor_s6c1_" + param1;
         Character.battle_code = "tutor_s6c1_" + param1;
         this.is_ninja_tutor_exam_s6c1 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_264","BattleBG" + param1);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_[param1 - 1].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[param1 - 1][_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function startNinjaTutorS6C2Battle(param1:int) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = false;
         var _loc2_:Array = [["ene_362","ene_345","ene_345"],["ene_363","ene_362"]];
         Character.mission_id = "ninja_tutor_s6c2_" + param1;
         Character.battle_code = "tutor_s6c2_" + param1;
         this.is_ninja_tutor_exam_s6c2 = true;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EXAM_MATCH,"mission_265","BattleBG");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_[param1 - 1].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_[param1 - 1][_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function continueNinjaTutorExamS1C2() : *
      {
         if(Character.mission_id == "ninja_tutor_s1c2_1")
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy1_killed = true;
         }
         if(Character.mission_id == "ninja_tutor_s1c2_2")
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy2_killed = true;
         }
         if(Character.mission_id == "ninja_tutor_s1c2_3")
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy3_killed = true;
         }
         if(Character.mission_id == "ninja_tutor_s1c2_4")
         {
            this.exam_stage.enemy4_killed = true;
            this.exam_stage.map.showFinalDialog();
         }
         this.loader.removeChild(this.combat);
         this.combat = null;
      }
      
      public function continueNinjaTutorExamS2C2() : *
      {
         if(!this.exam_stage.battle1_cleared)
         {
            this.exam_stage.battle1_cleared = true;
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.map.showDialogue8();
         }
         else
         {
            this.exam_stage.map.showFinalDialog();
         }
         this.loader.removeChild(this.combat);
         this.combat = null;
      }
      
      public function continueNinjaTutorExamS3C2() : *
      {
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = true;
         this.combat = null;
         this.exam_stage.map.showFinalDialog();
      }
      
      public function continueNinjaTutorExamS4C2() : *
      {
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = true;
         this.combat = null;
         this.exam_stage.map.showFinalDialog();
      }
      
      public function continueNinjaTutorExamS5C2() : *
      {
         this.loader.removeChild(this.combat);
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         this.exam_stage.map.map_mc.visible = true;
         this.combat = null;
         this.exam_stage.map.showFinalDialog();
      }
      
      public function continueNinjaTutorExamS6C1() : *
      {
         if(Character.mission_id == "ninja_tutor_s6c1_1")
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy1_killed = true;
         }
         if(Character.mission_id == "ninja_tutor_s6c1_2")
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy2_killed = true;
         }
         if(Character.mission_id == "ninja_tutor_s6c1_3")
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy3_killed = true;
         }
         if(Character.mission_id == "ninja_tutor_s6c1_4")
         {
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.enemy4_killed = true;
         }
         if(Character.mission_id == "ninja_tutor_s6c1_5")
         {
            this.exam_stage.enemy5_killed = true;
            this.exam_stage.map.showFinalDialog();
         }
         this.loader.removeChild(this.combat);
         this.combat = null;
      }
      
      public function continueNinjaTutorExamS6C2() : *
      {
         if(!this.exam_stage.battle1_cleared)
         {
            this.exam_stage.battle1_cleared = true;
            this.exam_stage.map.map_mc.visible = true;
            this.exam_stage.map.showDialogue4();
         }
         else
         {
            this.exam_stage.map.showFinalDialog();
         }
         this.loader.removeChild(this.combat);
         this.combat = null;
      }
      
      public function loadConfrontingDeathDialogue(param1:String) : void
      {
         this.confronting_death_scene = param1;
         var _loc2_:* = this.panelLoader.add("swfpanels/ConfrontingDeathDialogue.swf",{"id":"ConfrontingDeathDialogue"});
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.onConfrontingDeathDialogueLoaded);
         this.panelLoader.start();
      }
      
      private function onConfrontingDeathDialogueLoaded(param1:Event) : *
      {
         this.panelLoader.removeEventListener(BulkLoader.COMPLETE,this.onConfrontingDeathDialogueLoaded);
         var _loc2_:MovieClip = param1.target.content;
         var _loc3_:Class = getDefinitionByName("id.ninjasage.features.ConfrontingDeathDialogue") as Class;
         var _loc4_:MovieClip = new _loc3_(_loc2_,this.confronting_death_scene);
         this.loader.addChild(_loc2_);
         this.panelLoader.removeAll();
      }
      
      public function startConfrontingDeathBattle(param1:*) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         var _loc2_:Object = GameData.get("confrontingdeath2025").bosses;
         ++this.confronting_death_battle_counter;
         Character.is_confronting_death_event = true;
         Character.mission_id = _loc2_.background[int(param1.replace("battle_","")) - 1];
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EVENT_MATCH,Character.mission_id);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.id[param1].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_.id[param1][_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function loadChristmasDialogue(param1:String) : void
      {
         this.christmas_scene = param1;
         this.panelLoader.add("swfpanels/ChristmasDialogue.swf",{"id":"ChristmasDialogue"});
         this.panelLoader.addEventListener(BulkLoader.COMPLETE,this.onChristmasDialogueLoaded);
         this.panelLoader.start();
      }
      
      private function onChristmasDialogueLoaded(param1:Event) : *
      {
         this.panelLoader.removeEventListener(BulkLoader.COMPLETE,this.onChristmasDialogueLoaded);
         var _loc2_:Class = this.panelLoader.getContent("ChristmasDialogue").loaderInfo.applicationDomain.getDefinition("ChristmasDialogue") as Class;
         var _loc3_:MovieClip = new _loc2_();
         var _loc4_:Class = getDefinitionByName("id.ninjasage.features.ChristmasDialogue") as Class;
         var _loc5_:MovieClip = new _loc4_(_loc3_,this.christmas_scene);
         this.loader.addChild(_loc3_);
         this.panelLoader.removeAll();
      }
      
      public function startChristmasBattle(param1:*) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         var _loc2_:Object = GameData.get("christmas2024").bosses;
         ++this.christmas_battle_counter;
         Character.is_christmas_event = true;
         Character.mission_id = _loc2_.background[int(param1.replace("battle_","")) - 1];
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EVENT_MATCH,Character.mission_id);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.id[param1].length)
         {
            BattleManager.addPlayerToTeam("enemy",_loc2_.id[param1][_loc3_]);
            _loc3_++;
         }
         BattleManager.startBattle();
      }
      
      public function startSakuraBattle(param1:*) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         Character.is_hunting_house = false;
         Character.is_hanami_event = true;
         Character.is_christmas_event = false;
         Character.mission_id = "mission_1020";
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EVENT_MATCH,Character.mission_id);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         BattleManager.addPlayerToTeam("enemy",this.sakura_battle_enemies[param1]);
         BattleManager.startBattle();
      }
      
      public function startSummerBattle(param1:*) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         Character.is_hunting_house = false;
         Character.is_summer_event = true;
         Character.is_christmas_event = false;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EVENT_MATCH,Character.mission_id);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:* = 0;
         while(_loc2_ < this.summer_battle_enemies[param1].length)
         {
            BattleManager.addPlayerToTeam("enemy",this.summer_battle_enemies[param1][_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startThanksgivingBattle(param1:*) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         Character.is_hunting_house = false;
         Character.is_thanksgiving_special_event = true;
         Character.is_christmas_event = false;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EVENT_MATCH,Character.mission_id);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:* = 0;
         while(_loc2_ < this.thanksgiving_battle_enemies[param1].length)
         {
            BattleManager.addPlayerToTeam("enemy",this.thanksgiving_battle_enemies[param1][_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startValentineBattle(param1:*) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         Character.is_hunting_house = false;
         Character.is_valentine_special_event = true;
         Character.is_christmas_event = false;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.EVENT_MATCH,Character.mission_id);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:* = 0;
         while(_loc2_ < this.valentine_battle_enemies[param1].length)
         {
            BattleManager.addPlayerToTeam("enemy",this.valentine_battle_enemies[param1][_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startGradeSBattle(param1:*) : *
      {
         if(this.combat)
         {
            this.combat.destroy();
            this.combat = null;
         }
         Character.is_hunting_house = false;
         Character.is_christmas_event = false;
         this.combat = this.loadPanel("Combat.Battle",true);
         BattleManager.init(this.combat,this,BattleVars.MISSION_MATCH,"mission_275");
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         var _loc2_:* = 0;
         while(_loc2_ < this.grade_s_battle_enemies[param1].length)
         {
            BattleManager.addPlayerToTeam("enemy",this.grade_s_battle_enemies[param1][_loc2_]);
            _loc2_++;
         }
         BattleManager.startBattle();
      }
      
      public function startClanBattle(param1:*) : *
      {
         Clan.instance.delayDestroy(true);
         this.man_pan = param1;
         this.loading(true);
         var _loc2_:int = int(Character.clan_recruits.length);
         var _loc3_:* = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(int(Character.clan_recruits[_loc4_].replace("char_","")));
            _loc4_++;
         }
         Clan.instance.startManualAttack(Character.clan_attack_id,_loc3_,this.startClanBattleRes);
      }
      
      public function startClanBattleRes(param1:Object, param2:* = null) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.loading(false);
         if(param1 != null && param1.hasOwnProperty("finished"))
         {
            Character.clan_data.clan_reputation = int(param1.clan_win_total_rep);
            Character.clan_char_data.stamina = int(Character.clan_char_data.stamina) - int(10);
            if(this.clan_Battle_res != null)
            {
               this.clan_Battle_res.destroy();
               this.clan_Battle_res = null;
            }
            this.clan_Battle_res = new ClanBattleResults(this,null,this);
            this.clan_Battle_res.updateDisplay(param1);
            this.loader.addChild(this.clan_Battle_res);
            this.man_pan.destroyPopups();
            this.man_pan = null;
            this.clan_Battle_res = null;
            Clan.instance.delayDestroy(false);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("enemies"))
         {
            Character.is_clan_war = true;
            Character.clan_enemy_building = param1;
            Character.mission_id = "stage5";
            Character.mission_level = Character.character_lvl;
            _loc3_ = MissionLibrary.getMissionInfo(Character.mission_id);
            Character.battle_code = param1.battle_id;
            Character.battle_characters = Character.clan_recruits;
            this.combat = this.loadPanel("Combat.Battle",true);
            BattleManager.init(this.combat,this,BattleVars.CLAN_MATCH,_loc3_["msn_bg"]);
            BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
            Character.character_recruit_ids = [];
            _loc4_ = 0;
            while(_loc4_ < Character.clan_recruits.length)
            {
               BattleManager.addPlayerToTeam("player",Character.clan_recruits[_loc4_]);
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < param1.enemies.length)
            {
               BattleManager.addPlayerToTeam("enemy","char_" + param1.enemies[_loc4_]);
               _loc4_++;
            }
            BattleManager.startBattle();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.getError("");
            Clan.instance.delayDestroy(false);
            return;
         }
      }
      
      public function onStageSWFLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.exam_panel_mc = param1.target.content;
         this.loading(false);
         if(this.exam_stage)
         {
            this.resetExamBooleans();
            this.exam_stage = null;
         }
         this.exam_stage = new this.exam_msn_class(this,this.exam_panel_mc);
         this.loadSwfPanel();
      }
      
      public function removeAllChildsFromLoader() : *
      {
         OutfitManager.removeChildsFromMovieClips(this.loader);
      }
      
      public function loadSwfPanel(param1:* = null) : *
      {
         OutfitManager.removeChildsFromMovieClips(this.loader);
         if(param1 != null)
         {
            this.loader.addChild(param1);
         }
         else
         {
            this.loader.addChild(this.exam_panel_mc);
         }
      }
      
      public function getMainAndCharacter() : Array
      {
         return [this,Character];
      }
      
      public function getEnemy(param1:*, param2:*) : *
      {
         GF.removeAllChild(param2);
         NinjaSage.loadIconSWF("enemy",param1,param2,param1);
         this.exam_enemy = param1;
         this.exam_enemy_mc = param2;
      }
      
      public function checkIfExamEnemyLoaded(param1:*, param2:*) : *
      {
         if(!this.exam_enemy_loaded)
         {
            this.loading(false);
            this.getEnemy(param1,param2);
         }
      }
      
      public function onEnemySWFLoaded(param1:Event, param2:*) : *
      {
         var _loc3_:MovieClip = null;
         this.exam_enemy_loaded = true;
         var _loc4_:Class = param1.target.applicationDomain.getDefinition(this.exam_enemy) as Class;
         _loc3_ = new _loc4_();
         NinjaSage.addStandByFrameScript(_loc3_);
         param2.addChild(_loc3_);
         this.exam_enemy_mc = param2;
         this.loading(false);
      }
      
      public function loadSwf(param1:String, param2:String, param3:*) : *
      {
         var _loc4_:* = BulkLoader.getLoader("combat");
         var _loc5_:* = _loc4_.add(param1 + "/" + param2 + ".swf");
         _loc5_.addEventListener(BulkLoader.COMPLETE,param3);
         _loc4_.start();
      }
      
      public function getPlayerHead() : *
      {
         if(this.outfitManagerTemp)
         {
            this.outfitManagerTemp.destroy();
            this.outfitManagerTemp = null;
         }
         this.outfitManagerTemp = new OutfitManager();
         var _loc1_:* = new CharHead();
         this.outfitManagerTemp.fillHead(_loc1_,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
         return _loc1_;
      }
      
      public function createPlayerMc() : *
      {
         BattleManager.init(null,this,"","");
         var _loc1_:* = new CharacterModel("playerX",0,"char_" + Character.char_id,true);
         _loc1_.width *= 1.7;
         _loc1_.height *= 1.7;
         return _loc1_;
      }
      
      public function levelUp() : void
      {
         this.panel_class = getDefinitionByName("Popups.LevelUp") as Class;
         this.panel_graph = new this.panel_class();
         this.loader.addChild(this.panel_graph);
         this.panel_graph = null;
         this.panel_class = null;
      }
      
      public function battleRewards(param1:String, param2:String, param3:*, param4:Boolean, param5:Object = null) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         this.panel_class = getDefinitionByName("Popups.MissionReward") as Class;
         this.panel_graph = new this.panel_class(this,param1,param2,param3,param5);
         this.loader.addChild(this.panel_graph);
         if(param3 == "Lost")
         {
            this.panel_graph.battleStatus.text = "You\'ve died !";
         }
         else if(param3 == "Run")
         {
            this.panel_graph.battleStatus.text = "You ran away !";
         }
         var _loc11_:* = 0;
         while(_loc11_ < 10)
         {
            this.panel_graph["item" + String(_loc11_)].visible = false;
            _loc11_++;
         }
         if(param3 is Array)
         {
            _loc6_ = 0;
            while(_loc6_ < param3.length)
            {
               this.panel_graph["item" + String(_loc6_)].visible = true;
               _loc7_ = "items";
               if(param3[_loc6_].indexOf("tp_") >= 0)
               {
                  Character.character_tp = int(int(Character.character_tp) + int(param3[_loc6_].split("_")[1])).toString();
                  this.panel_graph["item" + String(_loc6_)].amtTxt.text = "";
               }
               else if(param3[_loc6_].indexOf("ss_") >= 0)
               {
                  Character.character_ss = int(int(Character.character_ss) + int(param3[_loc6_].split("_")[1]));
                  this.panel_graph["item" + String(_loc6_)].amtTxt.text = "";
               }
               else if(param3[_loc6_].indexOf("tokens_") >= 0)
               {
                  Character.account_tokens = int(int(Character.account_tokens) + int(param3[_loc6_].split("_")[1]));
                  this.panel_graph["item" + String(_loc6_)].amtTxt.text = "";
               }
               else if(param3[_loc6_].indexOf("gold_") >= 0)
               {
                  Character.character_gold = int(int(Character.character_gold) + int(param3[_loc6_].split("_")[1])).toString();
                  this.panel_graph["item" + String(_loc6_)].amtTxt.text = "";
               }
               else if(param3[_loc6_].indexOf("xp_") >= 0)
               {
                  Character.character_xp = int(int(Character.character_xp) + int(param3[_loc6_].split("_")[1])).toString();
                  this.panel_graph["item" + String(_loc6_)].amtTxt.text = "";
               }
               else
               {
                  if(param3[_loc6_].indexOf("material_") >= 0)
                  {
                     _loc7_ = "materials";
                  }
                  if(param3[_loc6_].indexOf("essential_") >= 0)
                  {
                     _loc7_ = "essentials";
                  }
                  if(param3[_loc6_].indexOf("pet_") >= 0)
                  {
                     _loc7_ = "pets";
                  }
                  if(param3[_loc6_].indexOf("item_") >= 0)
                  {
                     _loc7_ = "consumables";
                  }
                  if(param3[_loc6_].indexOf("wpn_") >= 0)
                  {
                     _loc7_ = "weapons";
                  }
                  if(param3[_loc6_].indexOf("back_") >= 0)
                  {
                     _loc7_ = "backitems";
                  }
                  _loc8_ = param3[_loc6_].split("_");
                  _loc9_ = 1;
                  _loc10_ = param3[_loc6_];
                  if(_loc8_.length == 3)
                  {
                     _loc9_ = _loc8_[2];
                     _loc10_ = _loc8_[0] + "_" + _loc8_[1];
                  }
                  if(_loc7_ == "weapons")
                  {
                     Character.addWeapon(param3[_loc6_]);
                  }
                  else if(_loc7_ == "backitems")
                  {
                     Character.addBack(param3[_loc6_]);
                  }
                  else if(_loc7_ == "materials")
                  {
                     Character.addMaterials(_loc10_,_loc9_);
                  }
                  else if(_loc7_ == "consumables")
                  {
                     Character.addConsumables(_loc10_,_loc9_);
                  }
                  else
                  {
                     Character.addEssentials(_loc10_,_loc9_);
                  }
                  if(_loc9_ > 1)
                  {
                     this.panel_graph["item" + String(_loc6_)].amtTxt.text = "x" + _loc9_;
                  }
               }
               NinjaSage.loadItemIcon(this.panel_graph["item" + _loc6_].iconHolder,param3[_loc6_],"icon");
               _loc6_++;
            }
         }
         this.panel_graph.y = 55;
         this.panel_graph.x = 55;
         this.panel_graph.width = 1950;
         this.panel_graph.height = 1100;
         Character.character_gold = String(Number(Character.character_gold) + int(param2));
         if(param4)
         {
            this.levelUp();
         }
         this.panel_graph = null;
         this.panel_class = null;
      }
      
      public function getNotice(param1:String) : *
      {
         this.panel_class = getDefinitionByName("Panels.GetNotice") as Class;
         this.panel_graph = new this.panel_class(param1);
         this.loader.addChild(this.panel_graph);
         this.panel_graph.x = this.panel_graph.y = 55;
         this.panel_graph.width = 1950;
         this.panel_graph.height = 1100;
         this.panel_graph = null;
         this.panel_class = null;
      }
      
      public function getUpdate() : *
      {
         this.panel_class = getDefinitionByName("Panels.Update") as Class;
         this.panel_graph = new this.panel_class(this);
         this.loader.addChild(this.panel_graph);
         this.panel_graph.y = 55;
         this.panel_graph.x = 55;
         this.panel_graph.width = 1950;
         this.panel_graph.height = 1100;
         this.panel_graph = null;
         this.panel_class = null;
      }
      
      public function showMessage(param1:String) : *
      {
         this.panel_class = getDefinitionByName("Popups.Messages") as Class;
         this.panel_msg_graph = new this.panel_class(param1);
         this.panel_msg_graph.gotoAndPlay("show");
         this.loader.addChild(this.panel_msg_graph);
         this.panel_msg_graph.y = 0;
         this.panel_msg_graph.x = 0;
         this.panel_msg_graph.scaleX = 2;
         this.panel_msg_graph.scaleY = 2;
         this.panel_msg_graph = null;
         this.panel_class = null;
      }
      
      public function getPromotion(param1:Object) : *
      {
         this.panel_class = getDefinitionByName("Panels.GetPromotion") as Class;
         this.panel_graph = new this.panel_class(param1);
         this.loader.addChild(this.panel_graph);
         this.panel_graph = null;
         this.panel_class = null;
      }
      
      public function giveReward(param1:int, param2:*, param3:String = "default") : *
      {
         var _loc6_:int = 0;
         var _loc4_:* = undefined;
         this.panel_class = getDefinitionByName("Popups.GetReward") as Class;
         this.panel_graph = new this.panel_class();
         if(param3 != "default")
         {
            this.panel_graph.backgroundMC.gotoAndStop(param3);
         }
         if(param2 is Array)
         {
            _loc4_ = param2;
         }
         else
         {
            _loc4_ = param2.split(",");
         }
         var _loc5_:int = int(_loc4_.length);
         if(_loc5_ <= 12)
         {
            this.panel_graph.rewardMC.gotoAndStop(_loc5_);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               this.panel_graph.rewardMC["iconMC" + _loc6_].ownedTxt.text = "";
               this.panel_graph.rewardMC["iconMC" + _loc6_].amtTxt.text = "";
               if(Character.hasSkill(_loc4_[_loc6_].split(":")[0]) > 0 || Character.isItemOwned(_loc4_[_loc6_].split(":")[0]) > 0)
               {
                  this.panel_graph.rewardMC["iconMC" + _loc6_].ownedTxt.text = "Owned";
               }
               if(_loc4_[_loc6_].split(":")[1] > 1)
               {
                  this.panel_graph.rewardMC["iconMC" + _loc6_].amtTxt.text = "x" + _loc4_[_loc6_].split(":")[1];
               }
               NinjaSage.loadItemIcon(this.panel_graph.rewardMC["iconMC" + _loc6_],_loc4_[_loc6_].replace("%s",Character.character_gender));
               this.panel_graph.rewardMC["iconMC" + _loc6_].btn_preview.visible = this.checkIsItemOrSkill(_loc4_[_loc6_].split(":")[0]);
               this.panel_graph.rewardMC["iconMC" + _loc6_].btn_preview.metaData = {"itemId":_loc4_[_loc6_].split(":")[0]};
               this.eventHandler.addListener(this.panel_graph.rewardMC["iconMC" + _loc6_].btn_preview,MouseEvent.CLICK,this.openPreview);
               _loc6_++;
            }
         }
         else
         {
            this.panel_graph.rewardMC.visible = false;
            this.panel_graph.rewardPane.updateRewardPane({
               "rewards":_loc4_,
               "item_per_line":5,
               "width":475,
               "height":223,
               "x":90,
               "y":105,
               "scaleX":0.9,
               "scaleY":0.9,
               "scroll_direction":"vertical",
               "scroll_visible":true
            });
         }
         if(param1 == 1)
         {
            this.panel_graph.txt_title.text = "Congratulations !";
            this.panel_graph.txt_description.text = "You got";
         }
         else if(param1 == 2)
         {
            this.panel_graph.txt_title.text = "Congratulations !";
            this.panel_graph.txt_description.text = "You learned";
         }
         this.loader.addChild(this.panel_graph);
         this.panel_graph = null;
         this.panel_class = null;
      }
      
      public function openPreview(param1:MouseEvent) : void
      {
         var _loc2_:Class = null;
         if(param1.currentTarget.metaData.itemId.indexOf("skill_") >= 0)
         {
            _loc2_ = getDefinitionByName("Popups.PreviewSkill") as Class;
         }
         else
         {
            _loc2_ = getDefinitionByName("Popups.PreviewItem") as Class;
         }
         var _loc3_:MovieClip = new _loc2_(this,param1.currentTarget.metaData.itemId);
         this.loader.addChild(_loc3_);
      }
      
      private function checkIsItemOrSkill(param1:String) : Boolean
      {
         var _loc2_:Array = ["skill_","hair_","set_","back_","wpn_"];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1.indexOf(_loc2_[_loc3_]) >= 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function giveMessage(param1:String) : void
      {
         var _loc2_:Popup_msg = new Popup_msg(param1);
         _loc2_.scaleX = 1.9;
         _loc2_.scaleY = 1.9;
         this.loader.addChild(_loc2_);
         _loc2_ = null;
      }
      
      public function showBanInfo(param1:String, param2:String, param3:String, param4:String) : *
      {
         var banType:String = param1;
         var banReason:String = param2;
         var banMessage:String = param3;
         var banPunishment:String = param4;
         this.panel_class = getDefinitionByName("Managers.BanManager") as Class;
         this.panel_graph = new this.panel_class(this);
         this.loader.addChild(this.panel_graph);
         if(banType == "1")
         {
            this.panel_graph.errorMsg.text = "WARNING! Illegal activities have been detected in your account and thus your account is being disabled\nSuch behaviour have violated the Term & Conditions.\nThe penalties can be pardoned by amnesty.";
            this.panel_graph.errorCode.text = "Ban Status: " + banPunishment + " days left.";
         }
         else if(banType == "2")
         {
            this.panel_graph.errorMsg.text = "WARNING! Illegal activities have been detected in your account and thus your account is being disabled\nSuch behaviour have violated the Term & Conditions.\nThe penalties can be pardoned by amnesty.";
            this.panel_graph.errorCode.text = "Ban Status: Permanent.";
         }
         else if(banType == "3")
         {
            this.panel_graph.errorMsg.text = "WARNING! Illegal activities have been detected in your account and thus your account is being disabled\nSuch behaviour have violated the Term & Conditions.\nThe penalties can be pardoned by amnesty.";
            this.panel_graph.errorCode.text = "Ban Status: $4.99 fee required to unlock your account.";
         }
         else if(banType == "4")
         {
            this.panel_graph.errorMsg.text = "WARNING! Illegal activities have been detected in your account and thus your account is being disabled\nSuch behaviour have violated the Term & Conditions.\nThe penalties can be pardoned by amnesty.";
            this.panel_graph.errorCode.text = "Ban Status: Permanent.";
            this.panel_graph.nameTxt.text = "Username: " + Character.account_username;
            this.showMessage("Banned Reason : " + banReason);
            this.eventHandler.addListener(this.panel_graph.errorMsg,MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               showMessage("Banned Reason : " + banReason);
            });
         }
         else if(banType == "5")
         {
            this.panel_graph.errorMsg.text = "WARNING! Illegal activities have been detected in your account and thus your account is being disabled\nSuch behaviour have violated the Term & Conditions.\nThe penalties can be pardoned by amnesty.";
            this.panel_graph.errorCode.text = "Ban Status: Permanent.";
         }
         else if(banType == "6")
         {
            this.panel_graph.errorMsg.text = "An authorized refund has been detected on your account. \nYour account has been suspended.  \n\nIn order to recover your account, you will need to pay 200% of the refunded amount.";
            this.panel_graph.errorCode.text = "Ban Status: $" + banMessage + " fee required to unlock your account.";
         }
         else if(banType == "7")
         {
            this.panel_graph.errorMsg.text = banReason;
            this.panel_graph.errorCode.text = banMessage;
            this.panel_graph.ban_txt.text = "Your account just lost 1000 tokens!";
         }
         this.panel_graph.amnestyMsg.htmlText = "<a href=\'event:myEvent\'>[Amnesty Account Now]</a>";
         this.panel_graph.amnestyMsg.addEventListener("link",this.amnestyRedirect);
         this.panel_graph.csMsg.htmlText = "<a href=\'event:myEvent\'>[Contact Support]</a>";
         this.panel_graph.csMsg.addEventListener("link",this.customerServiceRedirect);
         this.panel_graph.btn_refresh.addEventListener(MouseEvent.CLICK,this.logout,false,0,true);
         this.panel_graph = null;
         this.panel_class = null;
      }
      
      public function amnestyRedirect(param1:TextEvent) : void
      {
         navigateToURL(new URLRequest("http://127.0.0.1:800/en/merchants?buy-now"));
      }
      
      public function customerServiceRedirect(param1:TextEvent) : void
      {
         navigateToURL(new URLRequest("https://www.facebook.com/NinjaSage.ID"));
      }
      
      internal function logout(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         Character.resetBattleInfo(this);
         if(this.combat != null)
         {
            this.combat.destroy();
            this.combat = null;
         }
         for each(_loc2_ in ["combat","assets","skills","specialclass","talents","panels","etc"])
         {
            BulkLoader.getLoader(_loc2_).removeAll();
         }
         System.gc();
         this.loadPanel("Managers.LoginManager");
      }
      
      public function loading(param1:Boolean) : *
      {
         if(param1 == true)
         {
            this.loaderMC = new LoadingMC();
            if(this.loaderMC.hasOwnProperty("bg") && this.loaderMC.bg.totalFrames > 1)
            {
               this.loaderMC.bg.gotoAndStop(NumberUtil.randomInt(1,this.loaderMC.bg.totalFrames));
            }
            this.addChild(this.loaderMC);
         }
         else
         {
            GF.removeAllChild(this.loaderMC);
            this.loaderMC = null;
         }
      }
      
      public function onCompleteIcon(param1:Event) : *
      {
         var _loc2_:Class = param1.target.applicationDomain.getDefinition("icon") as Class;
         this.itemToLoad = new _loc2_();
         this.itemToLoad.x = 500;
         this.itemToLoad.y = 500;
         return this.itemToLoad;
      }
      
      public function onCompleteModel(param1:Event) : *
      {
         var _loc2_:Class = param1.target.applicationDomain.getDefinition("item") as Class;
         this.itemToLoad = new _loc2_();
      }
      
      public function getHash(param1:*) : *
      {
         return CUCSG.hash(param1);
      }
      
      public function stopBgm() : *
      {
      }
      
      public function stopAllBgm() : void
      {
         SoundAS.pauseAll();
      }
      
      public function startBgm(param1:String = null) : void
      {
         var sound:SoundInstance;
         var soundId:String = param1;
         if(!this.bgm_enabled)
         {
            return;
         }
         if(soundId == null)
         {
            soundId = Character.is_new_village ? "new_bgm" : "bgm";
         }
         if(this.previousBgm == null)
         {
            this.previousBgm = soundId;
         }
         if(!SoundAS.isLoaded(soundId))
         {
            SoundAS.loadSound(Util.url("sounds/" + soundId + ".mp3"),soundId);
         }
         sound = null;
         try
         {
            SoundAS.pauseAll();
            sound = SoundAS.getSound(soundId);
            if(soundId != "battle" && sound.isPaused)
            {
               sound.resume();
            }
            else
            {
               sound.playLoop(0.5);
            }
         }
         catch(e:*)
         {
            SoundAS.playLoop(soundId,0.5);
         }
      }
      
      public function loadExternalSwfPanel(param1:*, param2:*, param3:Boolean = false) : *
      {
         this.extSwfPanel = param1;
         this.useExtSwfScript = param3;
         if(this.panelLoader.itemsTotal > 3)
         {
            this.panelLoader.removeAll();
         }
         var _loc4_:* = this.panelLoader.add("swfpanels/" + param2 + ".swf");
         _loc4_.addEventListener(BulkLoader.COMPLETE,this.onExternalSwfPanelLoaded);
         this.panelLoader.start();
      }
      
      public function onExternalSwfPanelLoaded(param1:Event) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Class = null;
         var _loc4_:* = undefined;
         param1.currentTarget.removeEventListener(param1.type,this.onExternalSwfPanelLoaded);
         if(!this.useExtSwfScript)
         {
            _loc2_ = param1.target.content;
            _loc2_.cacheAsBitmap = true;
            _loc3_ = getDefinitionByName("id.ninjasage.features." + this.extSwfPanel) as Class;
            this.extClassLoaded = new _loc3_(this,_loc2_);
            this.loader.addChild(_loc2_);
         }
         else
         {
            _loc4_ = param1.target.applicationDomain.getDefinition(this.extSwfPanel) as Class;
            this.extClassLoaded = new _loc4_(this,Character);
            this.extClassLoaded.name = this.extSwfPanel;
            this.loader.addChild(this.extClassLoaded);
         }
      }
      
      public function removeExternalSwfPanel() : *
      {
         this.extClassLoaded = null;
      }
      
      public function removeLoadedPanel(param1:String) : *
      {
         if(this.loadedPanels.hasOwnProperty(param1))
         {
            if(this.loadedPanels[param1].hasOwnProperty("destroy"))
            {
               this.loadedPanels[param1].destroy();
            }
            this.loadedPanels[param1] = null;
            delete this.loadedPanels[param1];
         }
      }
      
      public function removeAllLoadedPanels() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.loadedPanels)
         {
            this.removeLoadedPanel(_loc1_);
         }
      }
      
      private function shouldReuseObjects(param1:*) : *
      {
         if(param1 == "Panels.ClanVillage" || param1 == "Panels.Village" || param1 == "Panels.HUD" || param1 == "Panels.NewVillage" || param1 == "Panels.NewHUD")
         {
            return true;
         }
         return false;
      }
      
      public function getLoader(param1:*) : *
      {
         var _loc2_:* = BulkLoader.getLoader(param1);
         if(_loc2_ == null)
         {
            return new BulkLoader(param1,10);
         }
         return _loc2_;
      }
      
      public function getTempLoader() : *
      {
         return BulkLoader.createUniqueNamedLoader(12,BulkLoader.LOG_INFO);
      }
   }
}

