package Combat
{
   import Managers.OutfitManager;
   import Storage.ArenaBuffs;
   import Storage.Character;
   import Storage.SenjutsuSkillLevel;
   import Storage.SkillLibrary;
   import Storage.TalentSkillLevel;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import gs.TweenLite;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public class ActionsManager
   {
      
      public var player_team:*;
      
      public var player_number:*;
      
      public var player_model:*;
      
      public var action_bar:*;
      
      public var character_skills_mc:*;
      
      public var character_talent_skills:*;
      
      public var character_talent_skills_mc:*;
      
      private var character_talent_skills_info:* = [];
      
      public var character_talent_passive_skills_mc:*;
      
      public var character_senjutsu_skills:*;
      
      public var character_senjutsu_skills_mc:*;
      
      private var character_senjutsu_skills_info:* = [];
      
      public var character_senjutsu_passive_skills_mc:*;
      
      public var equipped_skills:*;
      
      public var loading_skill_number:* = 0;
      
      public var loading_skill_id:* = "";
      
      public var confirmation_mc:*;
      
      public var last_used_skill_mc:*;
      
      public var shadow_war_effect_applied:Boolean = false;
      
      public var all_loaded:* = false;
      
      public var can_use_class_skill:* = false;
      
      public var can_use_talent_skill:* = false;
      
      public var intelligence_class_used:* = false;
      
      public var class_skill:* = null;
      
      public var class_skill_id:* = null;
      
      public var skill_icons:Array = [];
      
      public var talent_icons:Array = [];
      
      public var senjutsu_icons:Array = [];
      
      public var specialclass_icon:MovieClip = null;
      
      public var loadeds:* = [];
      
      private var eventHandler:*;
      
      private var outfits:* = [];
      
      private var keyboard_enabled:Boolean = false;
      
      private var action_submitted:Boolean = false;
      
      public function ActionsManager(param1:String, param2:int, param3:*)
      {
         super();
         this.eventHandler = new EventHandler();
         this.player_team = param1;
         this.player_number = param2;
         this.player_model = param3;
         this.character_skills_mc = [];
         this.character_talent_skills = [];
         this.character_senjutsu_skills = [];
         this.character_senjutsu_skills_mc = [];
         this.character_senjutsu_passive_skills_mc = [];
         this.character_talent_skills_mc = [];
         this.character_talent_passive_skills_mc = [];
      }
      
      public function init() : *
      {
         if(this.isMainPlayerOrControllable())
         {
            this.fillActionBar();
         }
         else
         {
            this.getEquippedSkillsAndLoad();
         }
      }
      
      public function fillActionBar() : *
      {
         var _loc1_:String = "actionBar";
         if(this.player_number == 1)
         {
            _loc1_ = "actionBar1";
         }
         if(this.player_number == 2)
         {
            _loc1_ = "actionBar2";
         }
         this.action_bar = BattleManager.getBattle()[_loc1_];
         this.hideTalents();
         this.addButtonListeners();
         this.getEquippedSkillsAndLoad();
      }
      
      public function hideTalents() : *
      {
         var i:* = 0;
         this.setActionBarVisible(false);
         this.action_bar["starMC"].visible = false;
         this.action_bar["boardMC"].visible = false;
         this.action_bar["bloodline_Logo"].visible = true;
         this.action_bar["btnClassSkill_1"].visible = false;
         this.action_bar["btn_senjutsu"].visible = true;
         this.action_bar["btn_ninjutsu"].visible = false;
         while(i < 12)
         {
            if(i < 8)
            {
               this.action_bar["senjutsu_" + i].visible = false;
               this.action_bar["senjutsu_" + i].filled = false;
            }
            this.action_bar["pass_" + i].visible = false;
            i++;
         }
         i = 0;
         while(i < 4)
         {
            this.action_bar["bl_" + i].filled = false;
            this.action_bar["bl_" + i].visible = true;
            this.action_bar["se_" + String(int(i) + 4)].filled = false;
            this.action_bar["se_" + String(int(i) + 4)].visible = true;
            i++;
         }
         if(this.player_model.character_manager.getTalentType(1) != "")
         {
            try
            {
               this.action_bar["bloodline_Logo"].gotoAndStop(this.player_model.character_manager.getTalentType(1));
            }
            catch(e:*)
            {
            }
         }
         if(this.action_bar["btn_senjutsu"].visible)
         {
            this.eventHandler.addListener(this.action_bar["btn_senjutsu"],MouseEvent.CLICK,this.toggleSenjutsu);
            this.eventHandler.addListener(this.action_bar["btn_ninjutsu"],MouseEvent.CLICK,this.toggleSenjutsu);
         }
      }
      
      public function hideSenjutsu() : *
      {
         if(this.action_bar == null)
         {
            return;
         }
         this.action_bar["btn_senjutsu"].visible = true;
         this.action_bar["btn_ninjutsu"].visible = false;
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            this.action_bar["senjutsu_" + _loc1_].visible = false;
            this.action_bar["skill_" + _loc1_].visible = true;
            TweenLite.killTweensOf(this.action_bar["senjutsu_" + _loc1_]);
            _loc1_++;
         }
      }
      
      public function showSenjutsu() : *
      {
         if(this.action_bar == null)
         {
            return;
         }
         this.action_bar["btn_senjutsu"].visible = false;
         this.action_bar["btn_ninjutsu"].visible = true;
         if(Character.senjutsu_animation)
         {
            BattleManager.getBattle()["senjutsuTransition"].gotoAndPlay(2);
         }
         BattleManager.getBattle().setChildIndex(BattleManager.getBattle()["senjutsuTransition"],BattleManager.getBattle().numChildren - 1);
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            this.action_bar["skill_" + _loc1_].visible = false;
            this.action_bar["senjutsu_" + _loc1_].visible = true;
            this.action_bar["senjutsu_" + _loc1_].rotationY = 180;
            TweenLite.killTweensOf(this.action_bar["senjutsu_" + _loc1_]);
            TweenLite.to(this.action_bar["senjutsu_" + _loc1_],1,{"rotationY":0});
            _loc1_++;
         }
      }
      
      public function addButtonListeners() : *
      {
         this.eventHandler.addListener(this.action_bar["btnAttack"],MouseEvent.CLICK,this.onWeaponAttack);
         this.eventHandler.addListener(this.action_bar["btnDodge"],MouseEvent.CLICK,this.onDodgeTurn);
         this.eventHandler.addListener(this.action_bar["btnCharge"],MouseEvent.CLICK,this.onChargeUsed);
         if("btnRun" in this.action_bar)
         {
            this.eventHandler.addListener(this.action_bar["btnRun"],MouseEvent.CLICK,this.onRun);
         }
      }
      
      public function toggleSenjutsu(param1:MouseEvent = null) : *
      {
         if(this.action_bar["senjutsu_1"].visible)
         {
            this.hideSenjutsu();
         }
         else
         {
            this.showSenjutsu();
         }
      }
      
      public function handleChaos() : *
      {
         var _loc1_:int = Math.floor(Math.random() * 2);
         BattleTimer.stopTurnTimer();
         if(_loc1_ == 0)
         {
            this.onWeaponAttack(null,true);
         }
         else
         {
            this.onChargeUsed(null,true);
         }
      }
      
      public function handleTease() : *
      {
         this.onWeaponAttack(null,true);
      }
      
      public function isAbleToUseWeaponAttack() : Boolean
      {
         return Boolean(this.player_model.effects_manager.hadEffect("barrier")) || Boolean(this.player_model.effects_manager.hadEffect("dismantle")) || Boolean(this.player_model.effects_manager.hadEffect("pet_dismantle")) ? false : true;
      }
      
      public function onWeaponAttack(param1:* = null, param2:Boolean = false, param3:Boolean = false) : *
      {
         var _loc4_:* = param1 is MouseEvent;
         if(!this.isAbleToUseWeaponAttack())
         {
            if(param3)
            {
               this.onDodgeTurn();
            }
            else if(param2)
            {
               this.onChargeUsed(null,true,true);
            }
            else if(_loc4_)
            {
               BattleManager.getMain().showMessage("You can not attack with weapon.");
            }
            else
            {
               this.onChargeUsed(null,true,true);
            }
            return;
         }
         if(_loc4_)
         {
            if(param1.currentTarget.enabled)
            {
               if(this.player_model.IS_CHAOS)
               {
                  this.player_model.handleChaos();
                  return;
               }
            }
         }
         if(param1 is MouseEvent)
         {
            if(!this.beginActionSubmission())
            {
               return;
            }
            BattleTimer.stopTurnTimer();
            this.hideSenjutsu();
            Character.battle_logs.push({"_":"weapon"});
         }
         this.player_model.attackWithWeapon();
         this.setActionBarVisible(false);
      }
      
      public function setActionBarVisible(param1:Boolean = true) : *
      {
         if(param1)
         {
            this.resetActionSubmission();
         }
         BattleManager.getBattle()["btn_UI_Gear"].visible = false;
         try
         {
            BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"].visible = param1;
            this.action_bar.visible = param1;
         }
         catch(e:*)
         {
         }
         if(!param1)
         {
            this.disableKeyboardShortcuts();
         }
      }
      
      public function resetActionSubmission() : void
      {
         this.action_submitted = false;
      }
      
      private function beginActionSubmission() : Boolean
      {
         if(this.action_submitted)
         {
            return false;
         }
         this.action_submitted = true;
         return true;
      }
      
      public function onDodgeTurn(param1:MouseEvent = null) : *
      {
         if(param1 is MouseEvent)
         {
            if(!this.beginActionSubmission())
            {
               return;
            }
            BattleTimer.stopTurnTimer();
            this.hideSenjutsu();
            Character.battle_logs.push({"_":"skip"});
         }
         BattleManager.startRun();
         this.setActionBarVisible(false);
      }
      
      public function isAbleToUseCharge() : Boolean
      {
         return Boolean(this.player_model.effects_manager.hadEffect("charge_disable")) || Boolean(this.player_model.effects_manager.hadEffect("pet_charge_disable")) || Boolean(this.player_model.effects_manager.hadEffect("meridian_seal")) || Boolean(this.player_model.effects_manager.hadEffect("domain_expansion")) ? false : true;
      }
      
      public function onChargeUsed(param1:MouseEvent = null, param2:Boolean = false, param3:Boolean = false) : *
      {
         if(param1 is MouseEvent)
         {
            if(this.action_submitted)
            {
               return;
            }
            BattleTimer.stopTurnTimer();
            this.hideSenjutsu();
            Character.battle_logs.push({"_":"charge"});
         }
         var _loc4_:* = param1 is MouseEvent;
         if(!this.isAbleToUseCharge())
         {
            if(param3)
            {
               this.onDodgeTurn();
            }
            else if(param2)
            {
               this.onWeaponAttack(null,true,true);
            }
            else if(_loc4_)
            {
               BattleManager.getMain().showMessage("You can not charge.");
            }
            else
            {
               this.onDodgeTurn();
            }
            return;
         }
         if(_loc4_)
         {
            if(!param1.currentTarget.enabled)
            {
               if(this.player_model.IS_CHAOS)
               {
                  this.player_model.handleChaos();
                  return;
               }
               BattleManager.getMain().showMessage("You can not charge.");
               return;
            }
         }
         if(Boolean(_loc4_) && !this.beginActionSubmission())
         {
            return;
         }
         this.setActionBarVisible(false);
         this.player_model.chargePlayer();
      }
      
      public function onRun(param1:MouseEvent = null) : *
      {
         this.confirmation_mc = new (getDefinitionByName("Popups.Confirmation") as Class)();
         this.eventHandler.addListener(this.confirmation_mc.btn_confirm,MouseEvent.CLICK,this.onRunConfirm);
         this.eventHandler.addListener(this.confirmation_mc.btn_close,MouseEvent.CLICK,this.onRunClose);
         BattleManager.getBattle().addChild(this.confirmation_mc);
      }
      
      public function onRunConfirm(param1:MouseEvent) : *
      {
         this.playRunAnimation();
         this.onRunClose(param1);
         BattleTimer.stopTurnTimer();
         BattleManager.getBattle().resetGameModes();
         BattleManager.getBattle()._main.battleRewards("0","0","Run",false);
      }
      
      public function playRunAnimation() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < BattleManager.getBattle().character_team_players.length)
         {
            if(!BattleManager.getBattle().character_team_players[_loc1_].health_manager.isDead())
            {
               BattleManager.getBattle().character_team_players[_loc1_].playRun();
            }
            _loc1_++;
         }
      }
      
      public function onRunClose(param1:MouseEvent) : *
      {
         BattleManager.getBattle().removeChild(this.confirmation_mc);
         this.confirmation_mc = null;
      }
      
      public function getEquippedSkillsAndLoad() : *
      {
         this.equipped_skills = this.player_model.character_manager.getEquippedSkills();
         this.loadEquippedSkills();
      }
      
      public function loadEquippedSkills() : *
      {
         if(this.equipped_skills.length > this.loading_skill_number)
         {
            this.loading_skill_id = this.equipped_skills[this.loading_skill_number];
            BattleManager.getMain().loadSkillSWF(this.loading_skill_id,this.onSkillSWFLoaded);
         }
         else
         {
            this.getTalentSkillsAndLoad();
         }
      }
      
      public function getTalentSkillsAndLoad() : *
      {
         var _loc4_:* = undefined;
         this.equipped_skills = [];
         this.loading_skill_number = 0;
         this.loading_skill_id = "";
         var _loc1_:* = this.player_model.character_manager.getTalentsSkills();
         var _loc2_:* = [];
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_] != null)
            {
               _loc4_ = _loc1_[_loc3_].split(":");
               _loc2_.push({
                  "item_id":_loc4_[0],
                  "item_level":_loc4_[1]
               });
            }
            _loc3_++;
         }
         this.loadTalentSkills(_loc2_);
      }
      
      public function loadTalentSkills(param1:* = 0) : *
      {
         if(param1 is Array)
         {
            this.equipped_skills = param1;
            this.addToTalentSkillsArray();
         }
         if(this.equipped_skills.length > this.loading_skill_number)
         {
            this.loading_skill_id = this.equipped_skills[this.loading_skill_number].item_id;
            BattleManager.getMain().loadSkillSWF(this.loading_skill_id,this.onTalentSkillSWFLoaded);
         }
         else if(this.player_model.character_info.character_class != null)
         {
            try
            {
               this.class_skill_id = this.player_model.character_info.character_class;
               this.can_use_class_skill = true;
               this.can_use_talent_skill = true;
               if(this.class_skill_id == "skill_4002")
               {
                  this.can_use_class_skill = false;
               }
               if(this.class_skill_id != null)
               {
                  BattleManager.getMain().loadSkillSWF(this.class_skill_id,this.onClassSkillSWFLoaded);
               }
            }
            catch(e:*)
            {
            }
         }
         else
         {
            this.getSenjutsuSkillAndLoad();
         }
      }
      
      public function getSenjutsuSkillAndLoad() : *
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         this.equipped_skills = [];
         this.loading_skill_number = 0;
         this.loading_skill_id = "";
         var _loc1_:* = {};
         var _loc2_:* = this.player_model.character_manager.getSenjutsuSkills();
         var _loc3_:* = this.player_model.character_manager.getEquippedSenjutsuSkills();
         var _loc4_:* = [];
         var _loc5_:* = [];
         var _loc6_:* = 0;
         while(_loc6_ < _loc2_.length)
         {
            if(_loc2_[_loc6_] != null)
            {
               _loc7_ = _loc2_[_loc6_].split(":");
               _loc1_[_loc7_[0]] = int(_loc7_[1]);
               _loc8_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(_loc7_[0],this.player_model.character_manager.getSenjutsuLevel(_loc7_[0]));
               if((Boolean(_loc8_)) && _loc8_.cooldown == 0)
               {
                  _loc4_.push({
                     "item_id":_loc7_[0],
                     "item_level":_loc7_[1]
                  });
                  _loc5_.push(_loc7_[0] + ":" + _loc7_[1]);
               }
            }
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            if(!(_loc3_[_loc6_] == null || !_loc1_.hasOwnProperty(_loc3_[_loc6_])))
            {
               _loc4_.push({
                  "item_id":_loc3_[_loc6_],
                  "item_level":_loc1_[_loc3_[_loc6_]]
               });
               _loc5_.push(_loc3_[_loc6_] + ":" + _loc1_[_loc3_[_loc6_]]);
            }
            _loc6_++;
         }
         this.character_senjutsu_skills.push(_loc5_.join(","));
         this.loadSenjutsuSkills(_loc4_);
      }
      
      public function loadSenjutsuSkills(param1:* = 0) : *
      {
         if(param1 is Array)
         {
            this.equipped_skills = param1;
         }
         if(this.equipped_skills.length > this.loading_skill_number)
         {
            this.loading_skill_id = this.equipped_skills[this.loading_skill_number].item_id;
            BattleManager.getMain().loadSkillSWF(this.loading_skill_id,this.onSenjutsuSkillSWFLoaded);
         }
         else
         {
            this.all_loaded = true;
            this.reloadInfo();
         }
      }
      
      public function checkEffectForShadowWar() : *
      {
         var rank_squad_gua:* = undefined;
         var rank_squad_target:* = undefined;
         var squad_gua:* = undefined;
         var squad_target:* = undefined;
         var squad_rank_1:* = undefined;
         var applied_effect:* = undefined;
         var effect:* = undefined;
         var effect_type:* = undefined;
         try
         {
            this.shadow_war_effect_applied = true;
            rank_squad_gua = Character.shadow_war_battle_data.ranks[0];
            rank_squad_target = Character.shadow_war_battle_data.ranks[1];
            squad_gua = Character.getSquadName(Character.shadow_war_battle_data.player);
            squad_target = Character.getSquadName(Character.shadow_war_battle_data.enemy);
            squad_rank_1 = Character.getSquadName(Character.shadow_war_battle_data.rank_1);
            if(rank_squad_gua > 1 && rank_squad_target > 1)
            {
               return;
            }
            applied_effect = undefined;
            effect = ArenaBuffs.getArenaBuff(squad_rank_1);
            effect_type = "";
            if(squad_gua != squad_rank_1 && squad_target == squad_rank_1)
            {
               applied_effect = effect.buff.effect;
               effect_type = "Buff";
            }
            else if(squad_gua == squad_rank_1)
            {
               applied_effect = effect.debuff.effect;
               effect_type = "Debuff";
            }
            this.player_model.effects_manager["add" + effect_type](applied_effect);
         }
         catch(e:*)
         {
            this.shadow_war_effect_applied = false;
            Log.error(this,"sw:effect",e);
         }
      }
      
      public function checkUseIntelligenceClass() : *
      {
         var _loc1_:SkillHandler = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         if(this.player_team == "player" && this.player_number == 0)
         {
            if(!Character.intel_class_animation)
            {
               this.intelligence_class_used = true;
            }
            if(this.class_skill_id == "skill_4002" && !this.intelligence_class_used)
            {
               this.setActionBarVisible(false);
               this.intelligence_class_used = true;
               _loc1_ = this.class_skill;
               _loc2_ = this.getTarget();
               _loc3_ = this.getEnemyTeam();
               _loc4_ = BattleManager.getBattle().getObjectHolder(this.player_team,this.player_number);
               _loc5_ = BattleManager.getBattle().getObjectHolder(_loc3_,_loc2_);
               BattleManager.getBattle().playTheSkillAnimation(_loc1_.skill_mc,_loc5_,_loc4_);
            }
         }
         return false;
      }
      
      public function disableAttackClass() : *
      {
         this.action_bar["btnClassSkill_1"].cdTxt.text = "";
         BattleManager.getMain().disableButton(this.action_bar["btnClassSkill_1"].holder);
      }
      
      public function reduceCooldownToHeavyAttackClass() : *
      {
         if(this.class_skill_id == "skill_4003" && this.class_skill.getCurrentCooldown() > 0 && Boolean(this.can_use_class_skill))
         {
            this.class_skill.setCurrentCooldown(this.class_skill.getCurrentCooldown() - 1);
            this.action_bar["btnClassSkill_1"].cdTxt.text = this.class_skill.getCurrentCooldown();
            if(this.class_skill.getCurrentCooldown() == 0)
            {
               this.action_bar["btnClassSkill_1"].cdTxt.text = "";
               BattleManager.getMain().enableButton(this.action_bar["btnClassSkill_1"].holder);
               this.eventHandler.addListener(this.action_bar["btnClassSkill_1"],MouseEvent.CLICK,this.onUseClassSkill);
            }
         }
         return false;
      }
      
      public function canUseExceptionalSkill(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.player_team == "player" && this.player_number == 0)
         {
            if(this.class_skill_id == "skill_4001" && Boolean(this.can_use_class_skill))
            {
               _loc2_ = true;
            }
            else if(Boolean(param1.character_manager.hasTalentSkill("skill_1059")) && Boolean(this.can_use_talent_skill))
            {
               _loc2_ = true;
            }
            else
            {
               _loc2_ = false;
            }
         }
         return _loc2_;
      }
      
      public function disableAllButClassSkill() : *
      {
         this.greyOutActions();
         BattleManager.getBattle().agility_bar_manager.enable_actions = true;
      }
      
      public function greyOutActions(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this.toggleActionBarItem("bl_" + _loc2_,param1,this.useTalentSkill);
            this.toggleActionBarItem("se_" + (_loc2_ + 4),param1,this.useTalentSkill);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.character_skills_mc.length)
         {
            if(this.character_skills_mc[_loc2_] != null)
            {
               this.toggleActionBarItem("skill_" + _loc2_,param1,this.onUseSkill);
            }
            _loc2_++;
         }
         if(this.class_skill_id != "skill_4001")
         {
            this.toggleActionBarItem("btnClassSkill_1",param1,this.onUseClassSkill);
         }
         if(this.player_model.character_info.character_rank > 7)
         {
            this.toggleSenjutsuButtons(param1);
         }
         if(this.player_model.IS_CHAOS)
         {
            this.toggleActionBarItem("btnAttack",false,this.onWeaponAttack);
            this.toggleActionBarItem("btnCharge",false,this.onChargeUsed);
         }
         else
         {
            this.toggleActionBarItem("btnAttack",param1,this.onWeaponAttack);
            this.toggleActionBarItem("btnCharge",param1,this.onChargeUsed);
         }
      }
      
      public function enableKeyboardShortcuts() : void
      {
         if(this.keyboard_enabled)
         {
            return;
         }
         var _loc1_:* = BattleManager.getBattle();
         if(_loc1_ == null || _loc1_.stage == null)
         {
            return;
         }
         this.keyboard_enabled = true;
         _loc1_.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      public function disableKeyboardShortcuts() : void
      {
         if(!this.keyboard_enabled)
         {
            return;
         }
         var _loc1_:* = BattleManager.getBattle();
         if(_loc1_ == null || _loc1_.stage == null)
         {
            return;
         }
         this.keyboard_enabled = false;
         _loc1_.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc10_:SkillHandler = null;
         var _loc2_:uint = param1.keyCode;
         var _loc3_:int = -1;
         if(_loc2_ >= 49 && _loc2_ <= 56)
         {
            _loc3_ = _loc2_ - 49;
         }
         if(_loc2_ == 57)
         {
            if(Boolean(this.action_bar) && (Boolean(this.action_bar["btn_senjutsu"].visible) || Boolean(this.action_bar["btn_ninjutsu"].visible)))
            {
               this.toggleSenjutsu(null);
               return;
            }
         }
         var _loc4_:Boolean = Boolean(this.action_bar) && Boolean(this.action_bar["skill_0"]) && this.action_bar["skill_0"].visible == false;
         if(_loc4_)
         {
            if(this.character_senjutsu_skills_mc == null || _loc3_ >= this.character_senjutsu_skills_mc.length || this.character_senjutsu_skills_mc[_loc3_] == null)
            {
               return;
            }
            _loc10_ = this.character_senjutsu_skills_mc[_loc3_];
            this.useSenjutsuSkill(_loc3_);
            return;
         }
         if(this.character_skills_mc == null)
         {
            return;
         }
         if(_loc3_ < 0 || _loc3_ >= this.character_skills_mc.length)
         {
            return;
         }
         if(this.character_skills_mc[_loc3_] == null)
         {
            return;
         }
         var _loc5_:SkillHandler = this.character_skills_mc[_loc3_];
         if(this.player_model == null || this.player_model.effects_manager == null)
         {
            return;
         }
         var _loc6_:* = this.player_model.effects_manager;
         var _loc7_:Boolean = Boolean(_loc6_.hadEffect("restriction")) || Boolean(_loc6_.hadEffect("pet_restriction"));
         var _loc8_:Boolean = Boolean(_loc6_.hadEffect("ecstasy")) || Boolean(_loc6_.hadEffect("pet_ecstasy"));
         if(_loc5_.skill_info.skill_type < 6 && (_loc7_ || _loc8_))
         {
            BattleManager.showMessage(_loc7_ ? "Cannot use that while restricted." : "Cannot use that while under Ecstasy.");
            return;
         }
         if(_loc6_.hadEffect("meridian_seal"))
         {
            BattleManager.showMessage("Cannot use that while under Meridian Seal.");
            return;
         }
         if(_loc6_.hadEffect("barrier"))
         {
            BattleManager.showMessage("Cannot use that while under Barrier.");
            return;
         }
         if(_loc6_.hadEffect("unyielding"))
         {
            BattleManager.showMessage("Cannot use any skill, under Unyielding Effect");
            return;
         }
         if(Boolean(_loc6_.hadEffect("chaos")) || Boolean(_loc6_.hadEffect("pet_chaos")))
         {
            BattleManager.showMessage("Cannot use any skill while under Chaos!");
            return;
         }
         var _loc9_:Boolean = Boolean(_loc6_.hadEffect("stun")) || Boolean(_loc6_.hadEffect("pet_stun")) || Boolean(_loc6_.hadEffect("locked")) || Boolean(_loc6_.hadEffect("pet_frozen")) || Boolean(_loc6_.hadEffect("sleep")) || Boolean(_loc6_.hadEffect("pet_sleep")) || Boolean(_loc6_.hadEffect("petrify")) || Boolean(_loc6_.hadEffect("toxic_tooth")) || Boolean(_loc6_.hadEffect("fear"));
         if(_loc9_)
         {
            BattleManager.showMessage("Cannot use this skill while stunned!");
            return;
         }
         if(_loc5_.getCurrentCooldown() > 0)
         {
            BattleManager.showMessage("Skill is under cooldown");
            return;
         }
         if(!this.player_model.health_manager.hasEnoughCPForSkill(_loc5_.skill_info))
         {
            BattleManager.showMessage("Not enough chakra");
            return;
         }
         this.onUseSkill(_loc3_);
      }
      
      private function toggleActionBarItem(param1:String, param2:Boolean, param3:Function = null) : void
      {
         var _loc4_:String = param2 ? "disable" : "enable";
         var _loc5_:* = this.action_bar[param1];
         if(_loc5_ is MovieClip)
         {
            if(_loc5_.item_id == "skill_1059")
            {
               if(_loc5_.cdTxt.text == "")
               {
                  _loc4_ = "enable";
                  param2 = false;
               }
            }
         }
         if(param3 != null)
         {
            if(param2)
            {
               _loc5_.enabled = false;
               this.eventHandler.removeListener(_loc5_,MouseEvent.CLICK,param3);
            }
            else
            {
               _loc5_.enabled = true;
               this.eventHandler.addListener(_loc5_,MouseEvent.CLICK,param3);
            }
         }
         this.helpForActionBar(_loc4_,param1);
      }
      
      private function toggleSenjutsuButtons(param1:Boolean) : void
      {
         var _loc2_:String = param1 ? "initButtonDisable" : "initButton";
         BattleManager.getMain()[_loc2_](BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"],this.player_model.health_manager.useSageMode);
         this.toggleActionBarItem("btn_senjutsu",param1,this.toggleSenjutsu);
         this.toggleActionBarItem("btn_ninjutsu",param1,this.toggleSenjutsu);
      }
      
      public function reloadInfo() : *
      {
         this.player_model.reloadInfo();
      }
      
      public function addToTalentSkillsArray() : *
      {
         var _loc1_:String = "";
         var _loc2_:* = 0;
         while(_loc2_ < this.equipped_skills.length)
         {
            if(_loc1_ == "")
            {
               _loc1_ = this.equipped_skills[_loc2_].item_id + ":" + this.equipped_skills[_loc2_].item_level;
            }
            else
            {
               _loc1_ = _loc1_ + "," + this.equipped_skills[_loc2_].item_id + ":" + this.equipped_skills[_loc2_].item_level;
            }
            _loc2_++;
         }
         this.character_talent_skills.push(_loc1_);
      }
      
      public function onSkillSWFLoaded(param1:Event) : *
      {
         this.loadeds.push({
            "_":this.loading_skill_id,
            "__":param1.target["by" + "tes" + "Loa" + "ded"]
         });
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc3_:MovieClip = param1.target.content[this.loading_skill_id];
         _loc3_.gotoAndStop(1);
         _loc3_.stopAllMovieClips();
         var _loc4_:Object = SkillLibrary.getCopy(this.loading_skill_id);
         _loc4_.skill_id = this.loading_skill_id;
         var _loc5_:SkillHandler = new SkillHandler(_loc3_,this.player_team,this.player_number,_loc4_);
         var _loc6_:MovieClip = param1.target.content["icon"];
         this.skill_icons.push(_loc6_);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         if(this.isMainPlayerOrControllable())
         {
            GF.removeAllChild(this.action_bar["skill_" + this.loading_skill_number].holder);
            this.action_bar["skill_" + this.loading_skill_number].holder.addChild(_loc6_);
            this.action_bar["skill_" + this.loading_skill_number].item_id = this.loading_skill_id;
            this.action_bar["skill_" + this.loading_skill_number].is_talent = false;
            this.action_bar["skill_" + this.loading_skill_number].is_passive = false;
            this.eventHandler.addListener(this.action_bar["skill_" + this.loading_skill_number],MouseEvent.CLICK,this.onUseSkill);
            this.eventHandler.addListener(this.action_bar["skill_" + this.loading_skill_number],MouseEvent.MOUSE_OVER,BattleTooltip.showTooltip);
            this.eventHandler.addListener(this.action_bar["skill_" + this.loading_skill_number],MouseEvent.MOUSE_OUT,BattleTooltip.hideTooltip);
         }
         this.character_skills_mc.push(_loc5_);
         ++this.loading_skill_number;
         this.loadEquippedSkills();
      }
      
      public function onClassSkillSWFLoaded(param1:Event) : *
      {
         var _loc7_:SkillHandler = null;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc3_:* = undefined;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = new MovieClip();
         var _loc6_:Class = null;
         try
         {
         }
         catch(e:ReferenceError)
         {
         }
         if(param1.target.content[this.class_skill_id])
         {
            _loc3_ = SkillLibrary.getCopy(this.class_skill_id);
            _loc3_.skill_id = this.class_skill_id;
            _loc5_ = param1.target.content[this.class_skill_id];
            _loc5_.gotoAndStop(1);
            _loc5_.stopAllMovieClips();
            _loc7_ = new SkillHandler(_loc5_,this.player_team,this.player_number,_loc3_);
            if(this.class_skill_id == "skill_4002")
            {
               this.checkFillOutfit(_loc7_);
            }
         }
         this.class_skill = _loc7_;
         if(this.class_skill_id == "skill_4003")
         {
            _loc7_.setCurrentCooldown(_loc7_.skill_info.skill_cooldown);
         }
         if(this.isMainPlayerOrControllable())
         {
            if(this.class_skill_id == "skill_4003")
            {
               this.action_bar["btnClassSkill_1"].cdTxt.text = String(_loc7_.skill_info.skill_cooldown);
               BattleManager.getMain().disableButton(this.action_bar["btnClassSkill_1"].holder);
            }
            this.action_bar["btnClassSkill_1"].visible = true;
            _loc4_ = param1.target.content["icon"];
            this.specialclass_icon = _loc4_;
            GF.removeAllChild(this.action_bar["btnClassSkill_1"].holder);
            this.action_bar["btnClassSkill_1"].holder.addChild(_loc4_);
            this.action_bar["btnClassSkill_1"].item_id = this.class_skill_id;
            this.action_bar["btnClassSkill_1"].is_class = true;
            this.action_bar["btnClassSkill_1"].is_passive = false;
            if(this.class_skill_id != "skill_4003")
            {
               this.eventHandler.addListener(this.action_bar["btnClassSkill_1"],MouseEvent.CLICK,this.onUseClassSkill);
            }
            this.eventHandler.addListener(this.action_bar["btnClassSkill_1"],MouseEvent.MOUSE_OVER,BattleTooltip.showTooltip);
            this.eventHandler.addListener(this.action_bar["btnClassSkill_1"],MouseEvent.MOUSE_OUT,BattleTooltip.hideTooltip);
         }
         this.getSenjutsuSkillAndLoad();
      }
      
      public function onTalentSkillSWFLoaded(param1:Event) : *
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc17_:SkillHandler = null;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc6_:* = undefined;
         var _loc7_:OutfitManager = null;
         var _loc8_:MovieClip = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:String = null;
         var _loc13_:MovieClip = new MovieClip();
         var _loc14_:Class = null;
         var _loc15_:* = false;
         var _loc16_:* = null;
         if(!param1.target.content[this.loading_skill_id])
         {
            _loc15_ = true;
         }
         if(this.loading_skill_id == "skill_1023" || this.loading_skill_id == "skill_1050")
         {
            _loc15_ = true;
         }
         _loc6_ = TalentSkillLevel.getTalentSkillLevels(this.loading_skill_id,this.player_model.character_manager.getTalentLevel(this.loading_skill_id));
         _loc6_.skill_id = this.loading_skill_id;
         if(param1.target.content[this.loading_skill_id])
         {
            _loc13_ = param1.target.content[this.loading_skill_id];
            _loc13_.gotoAndStop(1);
            _loc13_.stopAllMovieClips();
            _loc17_ = new SkillHandler(_loc13_,this.player_team,this.player_number,_loc6_);
         }
         _loc3_ = int(this.loading_skill_id.replace("skill_",""));
         _loc4_ = _loc6_.type == "secret";
         _loc5_ = this.getTalentSkillsMC();
         if(_loc4_ && _loc5_.length < 4)
         {
            if(_loc5_.length == 2)
            {
               this.addTalentSkillMcToArray(null);
               this.addTalentSkillMcToArray(null);
            }
            else
            {
               this.addTalentSkillMcToArray(null);
            }
         }
         if(this.isMainPlayerOrControllable())
         {
            _loc8_ = param1.target.content["icon"];
            this.talent_icons.push(_loc8_);
            if(_loc15_)
            {
               this.action_bar["starMC"].visible = true;
               this.action_bar["boardMC"].visible = true;
               _loc9_ = 0;
               while(_loc9_ < 12)
               {
                  if(this.action_bar["pass_" + _loc9_].visible == false)
                  {
                     this.action_bar["pass_" + _loc9_].visible = true;
                     GF.removeAllChild(this.action_bar["pass_" + _loc9_].holder);
                     this.action_bar["pass_" + _loc9_].holder.addChild(_loc8_);
                     this.action_bar["pass_" + _loc9_].holder.skill_id = this.loading_skill_id;
                     this.action_bar["pass_" + _loc9_].item_id = this.loading_skill_id;
                     this.action_bar["pass_" + _loc9_].is_talent = true;
                     this.action_bar["pass_" + _loc9_].is_passive = true;
                     this.eventHandler.addListener(this.action_bar["pass_" + _loc9_],MouseEvent.MOUSE_OVER,BattleTooltip.showTooltip);
                     this.eventHandler.addListener(this.action_bar["pass_" + _loc9_],MouseEvent.MOUSE_OUT,BattleTooltip.hideTooltip);
                     break;
                  }
                  _loc9_++;
               }
            }
            else
            {
               _loc10_ = _loc4_ ? 4 : 0;
               _loc11_ = _loc4_ ? 8 : 4;
               _loc12_ = _loc4_ ? "se_" : "bl_";
               while(_loc10_ < _loc11_)
               {
                  if(this.action_bar[_loc12_ + _loc10_].filled == false)
                  {
                     _loc16_ = _loc12_ + _loc10_;
                     this.action_bar[_loc16_].filled = true;
                     GF.removeAllChild(this.action_bar[_loc16_].holder);
                     this.action_bar[_loc16_].holder.addChild(_loc8_);
                     this.action_bar[_loc16_].cdTxt.text = "";
                     this.action_bar[_loc16_].item_id = this.loading_skill_id;
                     this.action_bar[_loc16_].movieclip_id = _loc17_;
                     this.action_bar[_loc16_].is_talent = true;
                     this.action_bar[_loc16_].is_passive = false;
                     this.action_bar[_loc16_].is_secondary = _loc4_;
                     this.eventHandler.addListener(this.action_bar[_loc16_],MouseEvent.CLICK,this.useTalentSkill);
                     this.eventHandler.addListener(this.action_bar[_loc16_],MouseEvent.MOUSE_OVER,BattleTooltip.showTooltip);
                     this.eventHandler.addListener(this.action_bar[_loc16_],MouseEvent.MOUSE_OUT,BattleTooltip.hideTooltip);
                     break;
                  }
                  _loc10_++;
               }
            }
         }
         if(!_loc15_)
         {
            this.addTalentSkillMcToArray(_loc17_,_loc16_);
         }
         if(_loc15_)
         {
            this.addTalentPassiveSkillMcToArray(this.equipped_skills[this.loading_skill_number]);
         }
         ++this.loading_skill_number;
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         this.loadTalentSkills();
      }
      
      public function onSenjutsuSkillSWFLoaded(param1:Event) : *
      {
         var _loc3_:int = 0;
         var _loc13_:SkillHandler = null;
         var _loc14_:* = undefined;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc4_:* = undefined;
         var _loc5_:OutfitManager = null;
         var _loc6_:MovieClip = null;
         var _loc7_:* = undefined;
         var _loc8_:String = null;
         var _loc9_:MovieClip = new MovieClip();
         var _loc10_:Class = null;
         var _loc11_:* = false;
         var _loc12_:* = null;
         try
         {
         }
         catch(e:ReferenceError)
         {
         }
         _loc4_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.loading_skill_id,this.player_model.character_manager.getSenjutsuLevel(this.loading_skill_id));
         _loc4_.skill_id = this.loading_skill_id;
         _loc11_ = _loc4_.cooldown == 0;
         if(Boolean(param1.target.content[this.loading_skill_id]) && !_loc11_)
         {
            _loc9_ = param1.target.content[this.loading_skill_id];
            _loc9_.gotoAndStop(1);
            _loc9_.stopAllMovieClips();
            _loc13_ = new SkillHandler(_loc9_,this.player_team,this.player_number,_loc4_);
         }
         _loc3_ = int(this.loading_skill_id.replace("skill_",""));
         if(this.isMainPlayerOrControllable())
         {
            _loc6_ = param1.target.content["icon"];
            this.senjutsu_icons.push(_loc6_);
            if(_loc11_)
            {
               this.action_bar["starMC"].visible = true;
               this.action_bar["boardMC"].visible = true;
               _loc7_ = 0;
               while(_loc7_ < 12)
               {
                  if(this.action_bar["pass_" + _loc7_].visible == false)
                  {
                     this.action_bar["pass_" + _loc7_].visible = true;
                     GF.removeAllChild(this.action_bar["pass_" + _loc7_].holder);
                     this.action_bar["pass_" + _loc7_].holder.addChild(_loc6_);
                     this.action_bar["pass_" + _loc7_].holder.skill_id = this.loading_skill_id;
                     this.action_bar["pass_" + _loc7_].item_id = this.loading_skill_id;
                     this.action_bar["pass_" + _loc7_].is_senjutsu = true;
                     this.action_bar["pass_" + _loc7_].is_passive = true;
                     this.eventHandler.addListener(this.action_bar["pass_" + _loc7_],MouseEvent.MOUSE_OVER,BattleTooltip.showTooltip);
                     this.eventHandler.addListener(this.action_bar["pass_" + _loc7_],MouseEvent.MOUSE_OUT,BattleTooltip.hideTooltip);
                     break;
                  }
                  _loc7_++;
               }
            }
            else
            {
               _loc14_ = 0;
               while(_loc14_ < 8)
               {
                  _loc12_ = "senjutsu_" + _loc14_;
                  if(this.action_bar[_loc12_].filled == false)
                  {
                     this.action_bar[_loc12_].filled = true;
                     GF.removeAllChild(this.action_bar[_loc12_].holder);
                     this.action_bar[_loc12_].holder.addChild(_loc6_);
                     this.action_bar[_loc12_].cdTxt.text = "";
                     this.action_bar[_loc12_].item_id = this.loading_skill_id;
                     this.action_bar[_loc12_].movieclip_id = _loc13_;
                     this.action_bar[_loc12_].is_senjutsu = true;
                     this.action_bar[_loc12_].is_passive = false;
                     this.eventHandler.addListener(this.action_bar[_loc12_],MouseEvent.CLICK,this.useSenjutsuSkill);
                     this.eventHandler.addListener(this.action_bar[_loc12_],MouseEvent.MOUSE_OVER,BattleTooltip.showTooltip);
                     this.eventHandler.addListener(this.action_bar[_loc12_],MouseEvent.MOUSE_OUT,BattleTooltip.hideTooltip);
                     break;
                  }
                  _loc14_++;
               }
            }
         }
         if(!_loc11_)
         {
            this.addSenjutsuSkillMcToArray(_loc13_,_loc12_);
         }
         else
         {
            this.addSenjutsuPassiveSkillMcToArray(this.equipped_skills[this.loading_skill_number]);
         }
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         ++this.loading_skill_number;
         this.loadSenjutsuSkills();
      }
      
      public function addTalentSkillMcToArray(param1:SkillHandler, param2:* = null) : *
      {
         this.character_talent_skills_mc.push(param1);
         if(param1 != null && param2 != null)
         {
            this.character_talent_skills_info.push({
               "mc_index":this.character_talent_skills_mc.length - 1,
               "action_bar_prefix":param2,
               "skill_index":this.loading_skill_id.replace("skill_10","")
            });
         }
      }
      
      public function addTalentPassiveSkillMcToArray(param1:*) : *
      {
         this.character_talent_passive_skills_mc.push(param1);
      }
      
      public function getTalentPassiveSkills() : *
      {
         return this.character_talent_passive_skills_mc;
      }
      
      public function getTalentSkillsMC() : *
      {
         return this.character_talent_skills_mc;
      }
      
      public function addSenjutsuSkillMcToArray(param1:SkillHandler, param2:* = null) : *
      {
         this.character_senjutsu_skills_mc.push(param1);
         if(param1 != null && param2 != null)
         {
            this.character_senjutsu_skills_info.push({
               "mc_index":this.character_senjutsu_skills_mc.length - 1,
               "action_bar_prefix":param2,
               "skill_index":this.loading_skill_id.replace("skill_30","")
            });
         }
      }
      
      public function addSenjutsuPassiveSkillMcToArray(param1:*) : *
      {
         this.character_senjutsu_passive_skills_mc.push(param1);
      }
      
      public function getSenjutsuPassiveSkills() : *
      {
         return this.character_senjutsu_passive_skills_mc;
      }
      
      public function getSenjutsuSkillsMC() : *
      {
         return this.character_senjutsu_skills_mc;
      }
      
      public function getTarget() : int
      {
         if(this.player_team == "player")
         {
            return BattleVars.PLAYER_TARGET;
         }
         return BattleVars.ENEMY_TARGET;
      }
      
      public function getEnemyTeam() : String
      {
         if(this.player_team == "player")
         {
            return "enemy";
         }
         return "player";
      }
      
      public function onUseClassSkill(param1:*) : *
      {
         if(!this.can_use_class_skill)
         {
            return false;
         }
         var _loc2_:* = param1 is MouseEvent;
         if(_loc2_)
         {
            if(!param1.currentTarget.enabled)
            {
               BattleManager.showMessage("Cannot use any skill");
               return false;
            }
         }
         var _loc3_:SkillHandler = this.class_skill;
         var _loc4_:int = this.getTarget();
         if(this.player_model.effects_manager.hadEffect("unyielding"))
         {
            if(_loc2_)
            {
               BattleManager.showMessage("Cannot use any skill, under Unyielding Effect");
            }
            return false;
         }
         if(Boolean(this.player_model.IS_CHAOS) && Boolean(!_loc2_) && this.class_skill_id != "skill_4001")
         {
            this.handleChaos();
            return false;
         }
         var _loc5_:String = this.getEnemyTeam();
         var _loc6_:MovieClip = BattleManager.getBattle().getObjectHolder(this.player_team,this.player_number);
         var _loc7_:MovieClip = BattleManager.getBattle().getObjectHolder(_loc5_,_loc4_);
         this.checkFillOutfit(_loc3_);
         if(this.class_skill_id == "skill_4004")
         {
            _loc3_.setPositionAndAttack(this.player_team,_loc4_,this.player_number,false);
         }
         if(BattleManager.getBattle().showGUI)
         {
            BattleManager.giveMessage(_loc3_.skill_info.skill_name);
         }
         if(this.isMainPlayerOrControllable() && !this.beginActionSubmission())
         {
            return false;
         }
         BattleManager.getBattle().playTheSkillAnimation(_loc3_.skill_mc,_loc7_,_loc6_);
         this.setActionBarVisible(false);
         this.can_use_class_skill = false;
         this.helpForActionBar("disable","btnClassSkill_1");
         BattleTimer.stopTurnTimer();
         this.hideSenjutsu();
         Character.battle_logs.push({
            "_":"special-class",
            "__":_loc3_.skill_info.skill_id
         });
         if(param1 is MouseEvent)
         {
            this.eventHandler.removeListener(this.action_bar["btnClassSkill_1"],MouseEvent.CLICK,this.onUseClassSkill);
         }
         return true;
      }
      
      public function onUseSkill(param1:*, param2:Boolean = false) : Boolean
      {
         var _loc3_:int = 0;
         if(param1 is MouseEvent)
         {
            if(!param1.currentTarget.enabled)
            {
               BattleManager.showMessage("Cannot use any skill");
               return false;
            }
            _loc3_ = int(param1.currentTarget.name.replace("skill_",""));
         }
         else
         {
            _loc3_ = param1;
         }
         var _loc4_:SkillHandler = this.character_skills_mc[_loc3_];
         if(param2 && _loc4_.skill_info.skill_target != "Self")
         {
            return false;
         }
         if(!this.player_model.effects_manager.canPlayerUseSkill(this.player_team,this.player_number,_loc4_.skill_info,param1))
         {
            return false;
         }
         var _loc5_:int = this.getTarget();
         var _loc6_:Boolean = _loc4_.setPositionAndAttack(this.player_team,_loc5_,this.player_number,false);
         var _loc7_:Boolean = Boolean(this.player_model.health_manager.hasEnoughCPForSkill(_loc4_.skill_info));
         if(_loc6_)
         {
            if(_loc7_)
            {
               if(this.isMainPlayerOrControllable() && !this.beginActionSubmission())
               {
                  return false;
               }
               this.checkFillOutfit(_loc4_);
               this.playTheSkill(_loc4_);
               this.setActionBarVisible(false);
               BattleTimer.stopTurnTimer();
               Character.battle_logs.push({
                  "_":"skill",
                  "__":_loc4_.skill_info.skill_id
               });
               return true;
            }
            BattleManager.showMessage("Not enough chakra");
         }
         else if(param1 is MouseEvent)
         {
            BattleManager.showMessage("Skill is under cooldown");
         }
         return false;
      }
      
      public function checkFillOutfit(param1:*) : void
      {
         if(Boolean(param1.isOutfitFilled()) || Character.is_stickman)
         {
            return;
         }
         var _loc2_:* = this.player_model.character_manager;
         var _loc3_:* = this.player_model.character_info;
         param1.fillOutfit(_loc2_.getWeapon(),_loc2_.getBackItem(),_loc2_.getClothing(),_loc2_.getHair(),_loc2_.getFace(),_loc3_.hair_color,_loc3_.skin_color);
      }
      
      public function playTheSkill(param1:SkillHandler) : *
      {
         this.last_used_skill_mc = param1;
         var _loc2_:String = param1.skill_info.skill_id;
         var _loc3_:* = SkillLibrary.getCopy(_loc2_);
         var _loc4_:Boolean = _loc3_.skill_target == "Self" ? true : false;
         var _loc5_:Boolean = _loc3_.skill_type == "7" ? true : false;
         var _loc6_:Boolean = _loc3_.skill_type == "6" ? true : false;
         var _loc7_:int = this.getTarget();
         var _loc8_:String = this.getEnemyTeam();
         var _loc9_:MovieClip = BattleManager.getBattle().getObjectHolder(this.player_team,this.player_number);
         var _loc10_:MovieClip = BattleManager.getBattle().getObjectHolder(_loc8_,_loc7_);
         if(_loc6_)
         {
            this.reduceHPForUsingTaijutsu();
         }
         var _loc11_:int = int(this.player_model.health_manager.getSkillCpAmount(_loc3_));
         this.player_model.health_manager.reduceCP(_loc11_,"skill");
         this.player_model.health_manager.getSkillCpCost(_loc3_);
         if(BattleManager.getBattle().showGUI)
         {
            BattleManager.giveMessage(_loc3_.skill_name);
         }
         BattleManager.getBattle().playTheSkillAnimation(param1.skill_mc,_loc10_,_loc9_);
      }
      
      public function reduceHPForUsingTaijutsu() : *
      {
         var _loc1_:Number = 5;
         var _loc2_:Number = Number(this.player_model.effects_manager.getReduceTaijutsuImprove());
         if(_loc2_ > 0)
         {
            _loc1_ -= _loc2_ * 5 / 100;
         }
         var _loc3_:int = int(this.player_model.health_manager.getMaxHP());
         this.player_model.health_manager.reduceHealth(Math.floor(_loc3_ * _loc1_ / 100),"Taijutsu HP -");
      }
      
      public function useTalentSkill(param1:*, param2:Boolean = false) : *
      {
         var _loc6_:String = null;
         var _loc8_:Boolean = false;
         var _loc11_:int = 0;
         var _loc3_:* = param1 is MouseEvent;
         var _loc4_:* = -1;
         if(param1 is MouseEvent)
         {
            if(!param1.currentTarget.enabled)
            {
               if(param1.currentTarget.item_id != "skill_1059")
               {
                  BattleManager.showMessage("Cannot use any skill");
                  return false;
               }
            }
            _loc4_ = this.action_bar[param1.currentTarget.name].movieclip_id;
         }
         else
         {
            _loc4_ = this.character_talent_skills_mc[param1];
         }
         var _loc5_:SkillHandler = _loc4_;
         _loc6_ = _loc5_.skill_info.skill_id;
         if(_loc6_ == "skill_1029" && this.player_number > 0)
         {
            if(_loc3_)
            {
               BattleManager.showMessage("This skill can be used by primary player/enemy only!");
            }
            return false;
         }
         var _loc7_:* = int(_loc6_.replace("skill_10",""));
         if(this.player_model.effects_manager.hadEffect("snake_mark"))
         {
            if(_loc3_)
            {
               BattleManager.showMessage("Cannot use Talent and Senjutsu under Snake Mark");
            }
            return false;
         }
         if(!this.player_model.effects_manager.hadEffect("extreme_mode") && _loc6_ == "skill_1005")
         {
            if(_loc3_)
            {
               BattleManager.showMessage("This skill requires extreme mode!");
            }
            return false;
         }
         if(this.player_model.effects_manager.hadEffect("barrier"))
         {
            if(_loc3_)
            {
               BattleManager.showMessage("Under barrier!");
            }
            return false;
         }
         if(this.player_model.effects_manager.hadEffect("tease"))
         {
            if(_loc3_)
            {
               BattleManager.showMessage("Under Tease!");
            }
            return false;
         }
         _loc8_ = this.player_team == "player" ? Boolean(BattleVars.CHARACTER_REVIVED[this.player_number]) : Boolean(BattleVars.ENEMY_REVIVED[this.player_number]);
         if((_loc8_) && _loc7_ >= 18 && _loc7_ <= 23)
         {
            if(_loc3_)
            {
               BattleManager.showMessage("Died once, cannot use Eye of Mirror for this battle..");
            }
            return false;
         }
         if(this.player_model.effects_manager.hadEffect("unyielding"))
         {
            if(_loc3_)
            {
               BattleManager.showMessage("Cannot use any skill, under Unyielding Effect");
            }
            return false;
         }
         var _loc9_:Boolean = this.player_team == "player" ? Boolean(BattleVars.CHARACTER_TEAM_REVIVED[this.player_number]) : Boolean(BattleVars.ENEMY_TEAM_REVIVED[this.player_number]);
         var _loc10_:Boolean = this.isOneOrMoreTeammateDead();
         _loc11_ = this.player_team == "player" ? int(BattleManager.getBattle().character_team_players.length) : int(BattleManager.getBattle().enemy_team_players.length);
         if(_loc11_ == 1 && _loc7_ == 29)
         {
            if(_loc3_)
            {
               BattleManager.showMessage("Cannot Revive, Teammates not found!");
            }
            return false;
         }
         if(_loc7_ == 29 && !_loc3_)
         {
            return false;
         }
         if(!_loc10_ && _loc7_ == 29)
         {
            if(_loc3_)
            {
               BattleManager.showMessage("A teammate needs to die in order to use this skill!");
            }
            return false;
         }
         if(_loc9_ && _loc7_ >= 24 && _loc7_ <= 29)
         {
            if(_loc3_)
            {
               BattleManager.showMessage("Died once, cannot use Orochi for this battle..");
            }
            return false;
         }
         var _loc12_:int = this.getTarget();
         var _loc13_:String = this.getEnemyTeam();
         var _loc14_:* = TalentSkillLevel.getCopy(_loc6_,this.player_model.character_manager.getTalentLevel(_loc6_));
         if(param2)
         {
            if(_loc14_.skill_target != "Self")
            {
               return false;
            }
         }
         var _loc15_:* = _loc5_.setPositionAndAttack(this.player_team,_loc12_,this.player_number,false);
         _loc14_.talent_skill_cp_cost = Math.round(_loc14_.talent_skill_cp_cost * this.player_model.character_manager.getLevel());
         var _loc16_:* = this.player_model.health_manager.hasEnoughCPForSkill(_loc14_);
         if(_loc15_)
         {
            if(_loc16_)
            {
               if(this.isMainPlayerOrControllable() && !this.beginActionSubmission())
               {
                  return false;
               }
               this.checkFillOutfit(_loc5_);
               this.playTheTalentSkill(_loc5_);
               this.setActionBarVisible(false);
               BattleTimer.stopTurnTimer();
               this.hideSenjutsu();
               Character.battle_logs.push({
                  "_":"talent",
                  "__":_loc6_
               });
               return true;
            }
            BattleManager.showMessage("Not enough chakra");
         }
         else if(_loc3_)
         {
            BattleManager.showMessage("Talent skill is under cooldown");
         }
         return false;
      }
      
      public function useSenjutsuSkill(param1:* = null, param2:* = null) : *
      {
         var _loc3_:* = param1 is MouseEvent;
         var _loc4_:* = -1;
         var _loc5_:Boolean = true;
         if(param1 is MouseEvent)
         {
            _loc4_ = this.action_bar[param1.currentTarget.name].movieclip_id;
         }
         else
         {
            _loc4_ = this.character_senjutsu_skills_mc[param1];
         }
         var _loc6_:String = _loc4_.skill_info.skill_id;
         var _loc7_:Object = SkillLibrary.getSkillInfo(_loc6_);
         _loc5_ = Boolean(this.player_model.effects_manager.canPlayerUseSkill(this.player_team,this.player_number,_loc7_,param1));
         if(!_loc5_)
         {
            return false;
         }
         var _loc8_:int = this.getTarget();
         var _loc9_:* = SenjutsuSkillLevel.getCopy(_loc6_,this.player_model.character_manager.getSenjutsuLevel(_loc6_));
         if(this.player_model.effects_manager.hadEffect("snake_mark"))
         {
            if(_loc3_)
            {
               BattleManager.showMessage("Cannot use Talent and Senjutsu under Snake Mark");
            }
            return false;
         }
         if(param2)
         {
            if(_loc9_.target != "Self")
            {
               return false;
            }
         }
         if(_loc4_.setPositionAndAttack(this.player_team,_loc8_,this.player_number,false))
         {
            if(this.player_model.health_manager.hasEnoughSPForSkill(_loc9_))
            {
               if(this.isMainPlayerOrControllable() && !this.beginActionSubmission())
               {
                  return false;
               }
               this.checkFillOutfit(_loc4_);
               this.playTheSenjutsuSkill(_loc4_);
               this.setActionBarVisible(false);
               BattleTimer.stopTurnTimer();
               this.hideSenjutsu();
               Character.battle_logs.push({
                  "_":"senjutsu",
                  "__":_loc6_
               });
               return true;
            }
            BattleManager.showMessage("Not enough SP");
         }
         else if(_loc3_)
         {
            BattleManager.showMessage("Senjutsu skill is under cooldown");
         }
         return false;
      }
      
      public function isOneOrMoreTeammateDead() : *
      {
         var _loc1_:* = [];
         if(this.player_team == "player")
         {
            _loc1_ = BattleManager.getBattle().character_team_players;
         }
         else
         {
            _loc1_ = BattleManager.getBattle().enemy_team_players;
         }
         var _loc2_:* = _loc1_.length - 1;
         if(_loc2_ == 0)
         {
            return false;
         }
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            if(_loc1_[_loc4_].isDead())
            {
               _loc3_++;
            }
            _loc4_++;
         }
         _loc1_ = null;
         return _loc3_ > 0 ? true : false;
      }
      
      public function playTheTalentSkill(param1:*) : *
      {
         var _loc2_:int = this.getTarget();
         var _loc3_:String = this.getEnemyTeam();
         var _loc4_:MovieClip = BattleManager.getBattle().getObjectHolder(this.player_team,this.player_number);
         var _loc5_:MovieClip = BattleManager.getBattle().getObjectHolder(_loc3_,_loc2_);
         var _loc6_:String = param1.skill_info.skill_id;
         var _loc7_:* = TalentSkillLevel.getCopy(_loc6_,this.player_model.character_manager.getTalentLevel(_loc6_));
         _loc7_.talent_skill_cp_cost = Math.round(_loc7_.talent_skill_cp_cost * this.player_model.character_manager.getLevel());
         var _loc8_:int = int(this.player_model.health_manager.getSkillCpAmount(_loc7_));
         this.player_model.health_manager.reduceCP(_loc8_,"talent");
         this.player_model.health_manager.getSkillCpCost(_loc7_);
         if(BattleManager.getBattle().showGUI)
         {
            BattleManager.giveMessage(_loc7_.talent_skill_name);
         }
         BattleManager.getBattle().playTheSkillAnimation(param1.skill_mc,_loc5_,_loc4_);
      }
      
      public function playTheSenjutsuSkill(param1:*) : *
      {
         var _loc2_:int = this.getTarget();
         var _loc3_:String = this.getEnemyTeam();
         var _loc4_:MovieClip = BattleManager.getBattle().getObjectHolder(this.player_team,this.player_number);
         var _loc5_:MovieClip = BattleManager.getBattle().getObjectHolder(_loc3_,_loc2_);
         var _loc6_:String = param1.skill_info.skill_id;
         var _loc7_:* = SenjutsuSkillLevel.getCopy(_loc6_,this.player_model.character_manager.getSenjutsuLevel(_loc6_));
         var _loc8_:int = int(this.player_model.health_manager.getSkillSpAmount(_loc7_));
         this.player_model.health_manager.reduceSP(_loc8_,"SP -");
         if(BattleManager.getBattle().showGUI)
         {
            BattleManager.giveMessage(_loc7_.name);
         }
         BattleManager.getBattle().playTheSkillAnimation(param1.skill_mc,_loc5_,_loc4_);
      }
      
      public function reduceRandomSkillCoolDown(param1:int, param2:int = 0) : *
      {
         var _loc3_:Array = this.character_skills_mc;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = NumberUtil.randomInt(0,_loc3_.length - 1);
         var _loc6_:Boolean = true;
         if(_loc3_[_loc5_] != null && _loc3_[_loc5_].getCurrentCooldown() > 0)
         {
            _loc6_ = false;
            _loc3_[_loc5_].setCurrentCooldown(_loc3_[_loc5_].getCurrentCooldown() - param1);
            if(_loc3_[_loc5_].getCurrentCooldown() < 0)
            {
               _loc3_[_loc5_].setCurrentCooldown(0);
            }
         }
         if(_loc6_)
         {
            if(param2 < _loc4_)
            {
               param2++;
               this.reduceRandomSkillCoolDown(param1,param2);
            }
         }
      }
      
      public function rewindCooldown(param1:int, param2:Boolean = true, param3:Boolean = false) : *
      {
         var _loc4_:Array = this.character_skills_mc;
         var _loc5_:Array = this.character_talent_skills_mc;
         var _loc6_:int = 0;
         if(param2)
         {
            while(_loc6_ < _loc4_.length)
            {
               if(_loc4_[_loc6_] != null)
               {
                  _loc4_[_loc6_].setCurrentCooldown(int(_loc4_[_loc6_].getCurrentCooldown()) - param1);
                  if(_loc4_[_loc6_].getCurrentCooldown() < 0)
                  {
                     _loc4_[_loc6_].setCurrentCooldown(0);
                  }
               }
               _loc6_++;
            }
         }
         _loc6_ = 0;
         if(param3)
         {
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_] != null)
               {
                  _loc5_[_loc6_].setCurrentCooldown(int(_loc5_[_loc6_].getCurrentCooldown()) - param1);
                  if(_loc5_[_loc6_].getCurrentCooldown() < 0)
                  {
                     _loc5_[_loc6_].setCurrentCooldown(0);
                  }
               }
               _loc6_++;
            }
         }
         Effects.showEffectInfo(this.player_team,this.player_number,"Rewind Cooldown " + param1,false);
         this.updateSkillsCooldownDisplay(0);
      }
      
      public function increaseSkillTypeCds(param1:int, param2:int) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Array = this.character_skills_mc;
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_] != null)
            {
               _loc3_ = _loc4_[_loc5_].skill_info;
               if(int(_loc3_.skill_type) == param2)
               {
                  _loc4_[_loc5_].setCurrentCooldown(int(_loc4_[_loc5_].getCurrentCooldown()) + param1);
               }
            }
            _loc5_++;
         }
         var _loc6_:String = "Wind";
         if(param2 == 2)
         {
            _loc6_ = "Fire";
         }
         if(param2 == 3)
         {
            _loc6_ = "Lightning";
         }
         if(param2 == 4)
         {
            _loc6_ = "Earth";
         }
         if(param2 == 5)
         {
            _loc6_ = "Water";
         }
         Effects.showEffectInfo(this.player_team,this.player_number,_loc6_ + " +" + String(param1) + " CD");
         this.updateSkillsCooldownDisplay(0);
      }
      
      public function viceRapidCooldown(param1:int, param2:String) : *
      {
         var _loc3_:Array = this.character_skills_mc;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] != null)
            {
               _loc3_[_loc4_].setCurrentCooldown(int(_loc3_[_loc4_].getCurrentCooldown()) + param1);
            }
            _loc4_++;
         }
         Effects.showEffectInfo(this.player_team,this.player_number,param2);
         this.updateSkillsCooldownDisplay(0);
      }
      
      public function setCooldown(param1:int, param2:String) : *
      {
         var _loc6_:* = undefined;
         var _loc3_:* = "";
         var _loc4_:Array = this.character_skills_mc;
         var _loc5_:* = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = SkillLibrary.getSkillInfo(_loc4_[_loc5_].skill_info.skill_id);
            if(_loc6_.skill_id == param2)
            {
               _loc4_[_loc5_].setCurrentCooldown(int(_loc4_[_loc5_].getCurrentCooldown()) + param1);
            }
            _loc5_++;
         }
         Effects.showEffectInfo(this.player_team,this.player_number,"+ Cooldown ");
         this.updateSkillsCooldownDisplay(0);
      }
      
      public function rapidGenjutusuCooldown(param1:int) : *
      {
         var _loc2_:Array = this.character_skills_mc;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] != null)
            {
               if(_loc2_[_loc3_].skill_info.skill_type == "7")
               {
                  _loc2_[_loc3_].setCurrentCooldown(int(_loc2_[_loc3_].getCurrentCooldown()) - param1);
                  if(_loc2_[_loc3_].getCurrentCooldown() < 0)
                  {
                     _loc2_[_loc3_].setCurrentCooldown(0);
                  }
               }
            }
            _loc3_++;
         }
         Effects.showEffectInfo(this.player_team,this.player_number,"Genjutsu Cooldown!");
         this.updateSkillsCooldownDisplay(0);
      }
      
      public function reduceElementSkillsCD(param1:int = 1, param2:int = 0) : *
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Array = this.character_skills_mc;
         var _loc6_:* = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc5_[_loc6_] != null)
            {
               _loc3_ = _loc5_[_loc6_].skill_info.skill_id;
               _loc4_ = SkillLibrary.getSkillInfo(_loc3_);
               if(param2 != 0 && int(_loc4_.skill_type) == param2)
               {
                  _loc5_[_loc6_].setCurrentCooldown(int(_loc5_[_loc6_].getCurrentCooldown()) - param1);
                  if(_loc5_[_loc6_].getCurrentCooldown() < 0)
                  {
                     _loc5_[_loc6_].setCurrentCooldown(0);
                  }
               }
            }
            _loc6_++;
         }
      }
      
      public function randomOblivion(param1:int, param2:String) : *
      {
         var _loc3_:Array = this.character_skills_mc;
         var _loc4_:int = NumberUtil.randomInt(0,_loc3_.length - 1);
         if(_loc3_[_loc4_] == null)
         {
            return this.randomOblivion(param1,param2);
         }
         _loc3_[_loc4_].setCurrentCooldown(int(_loc3_[_loc4_].getCurrentCooldown()) + param1);
         Effects.showEffectInfo(this.player_team,this.player_number,param2,false);
         this.updateSkillsCooldownDisplay(0);
      }
      
      public function setCooldownFromEffect(param1:int, param2:String) : *
      {
         var _loc3_:Array = this.character_skills_mc.concat(this.character_talent_skills_mc,this.character_senjutsu_skills_mc);
         _loc3_ = this.removeEmptyIndices(_loc3_);
         param1 += 1;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] != null)
            {
               _loc3_[_loc4_].setCurrentCooldown(int(_loc3_[_loc4_].getCurrentCooldown()) + param1);
            }
            _loc4_++;
         }
         Effects.showEffectInfo(this.player_team,this.player_number,param2);
         this.updateSkillsCooldownDisplay(0);
      }
      
      public function setSingleCooldownFromEffect(param1:int, param2:String) : *
      {
         var _loc3_:Array = this.character_skills_mc.concat(this.character_talent_skills_mc,this.character_senjutsu_skills_mc);
         _loc3_ = this.removeEmptyIndices(_loc3_);
         param1 += 1;
         var _loc4_:int = Math.floor(Math.random() * _loc3_.length);
         _loc3_[_loc4_].setCurrentCooldown(int(_loc3_[_loc4_].getCurrentCooldown()) + param1);
         Effects.showEffectInfo(this.player_team,this.player_number,param2);
         this.updateSkillsCooldownDisplay(0);
      }
      
      internal function removeEmptyIndices(param1:Array) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(_loc3_ !== undefined)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function updateSkillsCooldownDisplay(param1:int = 1, param2:int = 0) : *
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         var _loc6_:Array = this.character_skills_mc;
         var _loc7_:* = 0;
         var _loc8_:Array = [];
         for(; _loc7_ < _loc6_.length; _loc7_++)
         {
            if(_loc6_[_loc7_] != null)
            {
               _loc6_[_loc7_].setCurrentCooldown(int(_loc6_[_loc7_].getCurrentCooldown()) - param1);
               if(_loc6_[_loc7_].getCurrentCooldown() < 0)
               {
                  _loc6_[_loc7_].setCurrentCooldown(0);
               }
               this.helpForActionBar("disable","skill_" + _loc7_);
               _loc3_ = _loc6_[_loc7_].skill_info.skill_id;
               _loc4_ = SkillLibrary.getSkillInfo(_loc3_);
               if(_loc6_[_loc7_].getCurrentCooldown() == 0)
               {
                  _loc8_.push(_loc3_);
               }
               if(!(param2 != 0 && _loc4_.skill_type != param2))
               {
                  _loc5_ = Boolean(this.player_model.effects_manager.hadEffect("restriction")) && int(_loc4_.skill_type) < 6;
                  _loc5_ = Boolean(this.player_model.effects_manager.hadEffect("pet_restriction")) && int(_loc4_.skill_type) < 6 || _loc5_;
                  _loc5_ = Boolean(this.player_model.effects_manager.hadEffect("ecstasy")) && int(_loc4_.skill_type) < 6 || _loc5_;
                  _loc5_ = Boolean(this.player_model.effects_manager.hadEffect("pet_ecstasy")) && int(_loc4_.skill_type) < 6 || _loc5_;
                  _loc5_ = Boolean(this.player_model.effects_manager.hadEffect("snake_mark")) && int(_loc4_.skill_type) == 9 || Boolean(int(_loc4_.skill_type == 11)) || _loc5_;
                  _loc5_ = Boolean(this.player_model.effects_manager.hadEffect("meridian_seal")) || _loc5_;
                  _loc5_ = Boolean(this.player_model.effects_manager.hadEffect("barrier")) || _loc5_;
                  if(_loc6_[_loc7_].getCurrentCooldown() == 0 && !_loc5_)
                  {
                     this.helpForActionBar("enable","skill_" + _loc7_);
                  }
                  try
                  {
                     this.action_bar["skill_" + String(_loc7_)].cdTxt.text = _loc6_[_loc7_].getCurrentCooldown() == 0 ? "" : _loc6_[_loc7_].getCurrentCooldown();
                  }
                  catch(e:*)
                  {
                  }
                  continue;
               }
               _loc6_[_loc7_].setCurrentCooldown(int(_loc6_[_loc7_].getCurrentCooldown()) + param1);
            }
         }
         this.player_model.character_manager.getSkillsWithCooldown(_loc8_);
      }
      
      public function updateSenjutsuSkillsCooldownDisplay(param1:int = 1) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < this.character_senjutsu_skills_mc.length)
         {
            _loc3_ = this.character_senjutsu_skills_mc[_loc2_];
            if(_loc3_ != null)
            {
               _loc3_.setCurrentCooldown(Math.max(0,int(this.character_senjutsu_skills_mc[_loc2_].getCurrentCooldown()) - param1));
               if(_loc3_.getCurrentCooldown() == 0)
               {
                  this.helpForActionBar("enable","senjutsu_" + _loc2_);
               }
               else
               {
                  this.helpForActionBar("disable","senjutsu_" + _loc2_);
               }
               try
               {
                  this.action_bar["senjutsu_" + _loc2_].cdTxt.text = _loc3_.getCurrentCooldown() == 0 ? "" : _loc3_.getCurrentCooldown();
               }
               catch(e:*)
               {
               }
            }
            _loc2_++;
         }
      }
      
      public function helpForActionBar(param1:String, param2:String) : void
      {
         var buttonHolder:* = undefined;
         var action:String = param1;
         var buttonName:String = param2;
         try
         {
            if(this.isMainPlayerOrControllable())
            {
               buttonHolder = this.action_bar[buttonName].holder;
               if(action == "disable")
               {
                  BattleManager.getMain().disableButton(buttonHolder);
               }
               else if(action == "enable")
               {
                  BattleManager.getMain().enableButton(buttonHolder);
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function updateTalentSkillsCooldownDisplay(param1:int = 1) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < this.character_talent_skills_info.length)
         {
            _loc3_ = this.character_talent_skills_info[_loc2_].mc_index;
            _loc4_ = this.character_talent_skills_info[_loc2_].action_bar_prefix;
            _loc5_ = this.character_talent_skills_info[_loc2_].skill_index;
            _loc6_ = this.character_talent_skills_mc[_loc3_];
            _loc6_.setCurrentCooldown(Math.max(0,int(this.character_talent_skills_mc[_loc3_].getCurrentCooldown()) - param1));
            if(_loc6_.skill_info.skill_id == "skill_1059")
            {
               if(_loc6_.getCurrentCooldown() == 0)
               {
                  this.helpForActionBar("enable",_loc4_);
                  this.can_use_talent_skill = true;
               }
               else
               {
                  this.helpForActionBar("disable",_loc4_);
                  this.can_use_talent_skill = false;
               }
            }
            if(_loc6_.getCurrentCooldown() == 0)
            {
               this.helpForActionBar("enable",_loc4_);
            }
            else
            {
               this.helpForActionBar("disable",_loc4_);
            }
            if(Boolean(this.player_team == "player") && Boolean(BattleVars.CHARACTER_REVIVED[this.player_number]) || Boolean(this.player_team == "enemy") && Boolean(BattleVars.ENEMY_REVIVED[this.player_number]))
            {
               if(_loc5_ >= 18 && _loc5_ <= 23)
               {
                  this.greyOutPassiveEOMSkills();
               }
            }
            if(Boolean(this.player_team == "player") && Boolean(BattleVars.CHARACTER_TEAM_REVIVED[this.player_number]) || Boolean(this.player_team == "enemy") && Boolean(BattleVars.ENEMY_TEAM_REVIVED[this.player_number]))
            {
               if(_loc5_ >= 24 && _loc5_ <= 29)
               {
                  this.greyOutPassiveOrochiSkills();
               }
            }
            this.action_bar[_loc4_].cdTxt.text = _loc6_.getCurrentCooldown() == 0 ? "" : _loc6_.getCurrentCooldown();
            _loc2_++;
         }
      }
      
      public function greyOutPassiveOrochiSkills() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         try
         {
            _loc1_ = 0;
            while(_loc1_ < 12)
            {
               if(this.action_bar["pass_" + _loc1_].visible)
               {
                  _loc2_ = int(this.action_bar["pass_" + _loc1_].holder.skill_id.replace("skill_10",""));
                  if(_loc2_ >= 24 && _loc2_ <= 29)
                  {
                     this.helpForActionBar("disable","pass_" + _loc1_);
                  }
               }
               _loc1_++;
            }
         }
         catch(e:*)
         {
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            try
            {
               this.eventHandler.removeListener(this.action_bar["bl_" + _loc1_],MouseEvent.CLICK,this.useTalentSkill);
            }
            catch(e:*)
            {
            }
            this.helpForActionBar("disable","bl_" + _loc1_);
            _loc1_++;
         }
      }
      
      public function greyOutPassiveEOMSkills() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         try
         {
            _loc1_ = 0;
            while(_loc1_ < 12)
            {
               if(this.action_bar["pass_" + _loc1_].visible)
               {
                  _loc2_ = int(this.action_bar["pass_" + _loc1_].holder.skill_id.replace("skill_10",""));
                  if(_loc2_ >= 18 && _loc2_ <= 23)
                  {
                     this.helpForActionBar("disable","pass_" + _loc1_);
                  }
               }
               _loc1_++;
            }
         }
         catch(e:*)
         {
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            try
            {
               this.eventHandler.removeListener(this.action_bar["bl_" + _loc1_],MouseEvent.CLICK,this.useTalentSkill);
            }
            catch(e:*)
            {
            }
            this.helpForActionBar("disable","bl_" + _loc1_);
            _loc1_++;
         }
      }
      
      public function greyOutPassiveSaintSkills() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            try
            {
               this.eventHandler.removeListener(this.action_bar["bl_" + _loc1_],MouseEvent.CLICK,this.useTalentSkill);
            }
            catch(e:*)
            {
            }
            this.helpForActionBar("disable","bl_" + _loc1_);
            _loc1_++;
         }
      }
      
      public function getTalentSkillsMCSkills() : *
      {
         if(this.character_talent_skills is Array && this.character_talent_skills.length > 0)
         {
            return this.character_talent_skills[0];
         }
         return "";
      }
      
      public function getSenjutsuSkillsMCSkills() : *
      {
         if(this.character_senjutsu_skills is Array && this.character_senjutsu_skills.length > 0)
         {
            return this.character_senjutsu_skills[0];
         }
         return "";
      }
      
      public function isMainPlayerOrControllable() : Boolean
      {
         if(this.player_team == "player" && this.player_number == 0)
         {
            return true;
         }
         return Boolean(Character.teammate_controllable) && this.player_team == "player";
      }
      
      public function destroy() : *
      {
         var _loc1_:int = 0;
         Log.debug(this,"destroy");
         this.disableKeyboardShortcuts();
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         GF.destroyArray(this.character_skills_mc);
         GF.destroyArray(this.character_talent_skills);
         GF.destroyArray(this.character_talent_skills_mc);
         GF.destroyArray(this.character_talent_passive_skills_mc);
         GF.destroyArray(this.character_talent_skills_info);
         GF.destroyArray(this.character_senjutsu_skills);
         GF.destroyArray(this.character_senjutsu_skills_mc);
         GF.destroyArray(this.character_senjutsu_passive_skills_mc);
         GF.destroyArray(this.character_senjutsu_skills_info);
         GF.destroyArray(this.outfits);
         GF.destroyArray([this.class_skill]);
         GF.clearArray(this.loadeds);
         GF.removeAllChild(this.player_model);
         GF.removeAllChild(this.specialclass_icon);
         GF.removeAllChildArray(this.skill_icons);
         GF.removeAllChildArray(this.talent_icons);
         GF.removeAllChildArray(this.senjutsu_icons);
         if(this.action_bar != null)
         {
            this.action_bar.cacheAsBitmap = false;
            _loc1_ = 0;
            while(_loc1_ < 8)
            {
               TweenLite.killTweensOf(this.action_bar["senjutsu_" + _loc1_]);
               TweenLite.killTweensOf(this.action_bar["skill_" + _loc1_]);
               delete this.action_bar["skill_" + _loc1_].movieclip_id;
               this.action_bar["skill_" + _loc1_].cacheAsBitmap = false;
               delete this.action_bar["senjutsu_" + _loc1_].movieclip_id;
               this.action_bar["senjutsu_" + _loc1_].cacheAsBitmap = false;
               GF.removeAllChild(this.action_bar["senjutsu_" + _loc1_].holder);
               GF.removeAllChild(this.action_bar["skill_" + _loc1_].holder);
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < 4)
            {
               delete this.action_bar["bl_" + _loc1_].movieclip_id;
               this.action_bar["bl_" + _loc1_].cacheAsBitmap = false;
               delete this.action_bar["se_" + int(_loc1_ + 4)].movieclip_id;
               this.action_bar["se_" + int(_loc1_ + 4)].cacheAsBitmap = false;
               GF.removeAllChild(this.action_bar["bl_" + _loc1_].holder);
               GF.removeAllChild(this.action_bar["se_" + int(_loc1_ + 4)].holder);
               if("enemyMcInfo_" + String(_loc1_) in this.action_bar && "skill_" + String(_loc1_ + 1) in this.action_bar["enemyMcInfo_" + String(_loc1_)])
               {
                  GF.removeAllChild(this.action_bar["enemyMcInfo_" + _loc1_]["skill_" + int(_loc1_ + 1)].holder);
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < 12)
            {
               GF.removeAllChild(this.action_bar["pass_" + _loc1_].holder);
               delete this.action_bar["pass_" + _loc1_].holder.skill_id;
               delete this.action_bar["pass_" + _loc1_].item_id;
               delete this.action_bar["pass_" + _loc1_].is_senjutsu;
               delete this.action_bar["pass_" + _loc1_].is_passive;
               _loc1_++;
            }
            this.action_bar["btnClassSkill_1"].cacheAsBitmap = false;
            GF.removeAllChild(this.action_bar["btnClassSkill_1"].holder);
         }
         GF.removeAllChild(this.action_bar);
         this.outfits = null;
         this.player_team = null;
         this.player_number = null;
         this.player_model = null;
         this.action_bar = null;
         this.character_skills_mc = null;
         this.character_talent_skills = null;
         this.character_talent_skills_mc = null;
         this.character_talent_skills_info = null;
         this.character_talent_passive_skills_mc = null;
         this.character_senjutsu_skills = null;
         this.character_senjutsu_skills_mc = null;
         this.character_senjutsu_skills_info = null;
         this.character_senjutsu_passive_skills_mc = null;
         this.equipped_skills = null;
         this.loading_skill_number = null;
         this.loading_skill_id = null;
         this.confirmation_mc = null;
         this.last_used_skill_mc = null;
         this.all_loaded = null;
         this.can_use_class_skill = null;
         this.can_use_talent_skill = null;
         this.intelligence_class_used = null;
         this.class_skill = null;
         this.class_skill_id = null;
         this.skill_icons = null;
         this.talent_icons = null;
         this.senjutsu_icons = null;
         this.specialclass_icon = null;
         this.loadeds = null;
      }
   }
}

