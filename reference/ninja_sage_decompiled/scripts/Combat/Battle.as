package Combat
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Popups.ClanBattleResults;
   import Storage.AccessoryBuffs;
   import Storage.BackItemBuffs;
   import Storage.Character;
   import Storage.Library;
   import Storage.SenjutsuSkillLevel;
   import Storage.SkillBuffs;
   import Storage.SkillLibrary;
   import Storage.TalentSkillLevel;
   import Storage.WeaponBuffs;
   import amf.amfConnect;
   import com.adobe.crypto.CUCSG;
   import com.hurlant.crypto.hash.MD5;
   import com.hurlant.util.Base64;
   import com.hurlant.util.Hex;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import id.ninjasage.Clan;
   import id.ninjasage.Crew;
   import id.ninjasage.EventHandler;
   import id.ninjasage.GradientText;
   import id.ninjasage.Log;
   import id.ninjasage.Util;
   
   public class Battle extends MovieClip
   {
       
      
      public var atk_turnTimerTxt:MovieClip;
      
      public var btn_WorldChat:SimpleButton;
      
      public var dh_hint:MovieClip;
      
      public var loader:MovieClip;
      
      public var logo:MovieClip;
      
      public var rekrut:TextField;
      
      public var senjutsuTransition:SenjutsuTransition;
      
      public var sushiMc:MovieClip;
      
      public var teamMc:MovieClip;
      
      public var teamTxt:TextField;
      
      public var totalDamageHint:MovieClip;
      
      public var versionTxt:TextField;
      
      public var woodFrame:MovieClip;
      
      public var actionBar:MovieClip;
      
      public var actionBar1:MovieClip;
      
      public var actionBar2:MovieClip;
      
      public var atbBar:MovieClip;
      
      public var bgHolder:MovieClip;
      
      public var btnOption:SimpleButton;
      
      public var btn_UI_Gear:SimpleButton;
      
      public var charMc_0:CharHpHolder;
      
      public var charMc_1:CharHpHolder;
      
      public var charMc_2:CharHpHolder;
      
      public var charPetMc_0:CharPetHpHolder;
      
      public var charPetMc_1:CharPetHpHolder;
      
      public var charPetMc_2:CharPetHpHolder;
      
      public var char_hpcp:MovieClip;
      
      public var enemyMcInfo_0:MovieClip;
      
      public var enemyMcInfo_1:MovieClip;
      
      public var enemyMcInfo_2:MovieClip;
      
      public var enemyMc_0:MovieClip;
      
      public var enemyMc_1:MovieClip;
      
      public var enemyMc_2:MovieClip;
      
      public var enemyPetMc_0:EnemyPetHpHolder;
      
      public var enemyPetMc_1:EnemyPetHpHolder;
      
      public var enemyPetMc_2:EnemyPetHpHolder;
      
      public var scrollDisplayMc_0:ScrollScript;
      
      public var scrollDisplayMc_1:ScrollScript;
      
      public var scrollDisplayMc_2:ScrollScript;
      
      public var character_team_players:Array;
      
      public var enemy_team_players:Array;
      
      public var agility_bar_manager:AgilityBarManager;
      
      public var attacker_model;
      
      public var defender_model;
      
      public var master_model;
      
      public var animation;
      
      public var base_damage:int;
      
      public var total_damage:int;
      
      public var total_damage_done:Number = 0;
      
      public var defender_models:Array;
      
      public var attacker_models:Array;
      
      public var reset_new_amount_objects:Array;
      
      public var reset_next_turn_objects:Array;
      
      public var _main;
      
      public var gear = null;
      
      public var option = null;
      
      public var world_chat = null;
      
      public var battle_stages_fllw;
      
      public var can_set_elements:Boolean = false;
      
      public var current_round = 0;
      
      public var type_disperse:String = "";
      
      public var copySkillMC:SkillHandler;
      
      public var showGUI:Boolean = true;
      
      private var eventHandler;
      
      private var debugEnemyActionBarState:Array;
      
      private var debugEnemySkillPanel:MovieClip;
      
      private var debugEnemyManualWaiting:Boolean = false;
      
      private var outfits;
      
      private var destroyed = false;
      
      private var pendingTimeouts:Array;
      
      public function Battle(param1:*)
      {
         this.outfits = [];
         this.pendingTimeouts = [];
         this.character_team_players = [];
         this.enemy_team_players = [];
         this.defender_models = [];
         this.attacker_models = [];
         this.reset_new_amount_objects = [];
         this.reset_next_turn_objects = [];
         this.battle_stages_fllw = ["wind","fire","thunder","earth","water"];
         super();
         this._main = param1;
         this.eventHandler = new EventHandler();
      }
      
      public function setupView() : *
      {
         BattleManager.loadBackground();
         BattleManager.hideEverything();
         BattleManager.loadPlayerTeam();
         BattleManager.playBgm();
      }
      
      public function setupAgilityBar() : *
      {
         this.eventHandler.addListener(this["enemyMc_0"],MouseEvent.CLICK,this.onTargetChange);
         this.eventHandler.addListener(this["enemyMc_1"],MouseEvent.CLICK,this.onTargetChange);
         this.eventHandler.addListener(this["enemyMc_2"],MouseEvent.CLICK,this.onTargetChange);
         this.eventHandler.addListener(this["charMc_0"],MouseEvent.CLICK,this.onDebugEnemyTargetChange);
         this.eventHandler.addListener(this["charMc_1"],MouseEvent.CLICK,this.onDebugEnemyTargetChange);
         this.eventHandler.addListener(this["charMc_2"],MouseEvent.CLICK,this.onDebugEnemyTargetChange);
         this.eventHandler.addListener(this["btn_WorldChat"],MouseEvent.CLICK,this.openWorldChat);
         this.eventHandler.addListener(this["btn_UI_Gear"],MouseEvent.CLICK,this.onOpenGear);
         this.eventHandler.addListener(this["btnOption"],MouseEvent.CLICK,this.openSettings);
         this.eventHandler.addListener(this["logo"],MouseEvent.CLICK,this.hideUI);
         this.showTargetArrow();
         this.agility_bar_manager = new AgilityBarManager();
         this.setupBattleEffectTooltips();
      }
      
      public function openWorldChat(param1:MouseEvent) : *
      {
         if(this.character_team_players.length > 0 && this.character_team_players[0].isCharacter())
         {
            this.character_team_players[0].actions_manager.disableKeyboardShortcuts();
         }
         this.world_chat = this._main.loadPanel("Panels.WorldChat",true);
         if(this.world_chat)
         {
            this.world_chat.addEventListener(Event.REMOVED_FROM_STAGE,this.onWorldChatClosed);
         }
      }
      
      private function onWorldChatClosed(param1:*) : void
      {
         if(this.world_chat)
         {
            this.world_chat.removeEventListener(Event.REMOVED_FROM_STAGE,this.onWorldChatClosed);
         }
         this.world_chat = null;
         this.reEnableKeyboardIfPlayerTurn();
      }
      
      public function onOpenGear(param1:MouseEvent) : *
      {
         if(this.character_team_players.length > 0 && this.character_team_players[0].isCharacter())
         {
            this.character_team_players[0].actions_manager.disableKeyboardShortcuts();
         }
         this.gear = this._main.loadPanel("Panels.Battle_UI_Gear",true);
         if(this.gear)
         {
            this.gear.addEventListener(Event.REMOVED_FROM_STAGE,this.onGearClosed);
         }
      }
      
      private function onGearClosed(param1:*) : void
      {
         if(this.gear)
         {
            this.gear.removeEventListener(Event.REMOVED_FROM_STAGE,this.onGearClosed);
         }
         this.gear = null;
         this.reEnableKeyboardIfPlayerTurn();
      }
      
      public function openSettings(param1:MouseEvent) : *
      {
         if(this.character_team_players.length > 0 && this.character_team_players[0].isCharacter())
         {
            this.character_team_players[0].actions_manager.disableKeyboardShortcuts();
         }
         this.option = this._main.loadPanel("Panels.UI_Option",true);
         this.option.panel.btn_change.visible = false;
         this.option.setOnBattle();
         if(this.option)
         {
            this.option.addEventListener(Event.REMOVED_FROM_STAGE,this.onOptionClosed);
         }
      }
      
      private function onOptionClosed(param1:*) : void
      {
         if(this.option)
         {
            this.option.removeEventListener(Event.REMOVED_FROM_STAGE,this.onOptionClosed);
         }
         this.option = null;
         this.reEnableKeyboardIfPlayerTurn();
      }
      
      private function reEnableKeyboardIfPlayerTurn() : void
      {
         var _loc1_:* = undefined;
         if(this.character_team_players.length > 0 && this.character_team_players[0].isCharacter())
         {
            _loc1_ = this.character_team_players[0].actions_manager;
            if(_loc1_.action_bar && _loc1_.action_bar.visible)
            {
               _loc1_.enableKeyboardShortcuts();
            }
         }
      }
      
      public function setRandomStage() : *
      {
         var _loc1_:int = Math.floor(Math.random() * 5);
         var _loc2_:* = this.battle_stages_fllw[_loc1_];
         if(Character.stage_mode == _loc2_)
         {
            this.setRandomStage();
            return;
         }
         this.setStageBGTo(_loc2_);
      }
      
      public function setStageBGTo(param1:*) : *
      {
         var stageMode:* = param1;
         Character.stage_mode = stageMode;
         switch(stageMode)
         {
            case "wind":
               BattleLoader.bg_holder.gotoAndStop("bg_1");
               break;
            case "fire":
               BattleLoader.bg_holder.gotoAndStop("bg_2");
               break;
            case "thunder":
               BattleLoader.bg_holder.gotoAndStop("bg_3");
               break;
            case "earth":
               BattleLoader.bg_holder.gotoAndStop("bg_4");
               break;
            case "water":
               BattleLoader.bg_holder.gotoAndStop("bg_5");
         }
         BattleLoader.bg_holder.bgMC.anim.addFrameScript(BattleLoader.bg_holder.bgMC.anim.totalFrames - 1,function():void
         {
            BattleLoader.bg_holder.bgMC.anim.stop();
         });
         BattleLoader.bg_holder.bgMC.anim.play();
         if(this.can_set_elements)
         {
            this.setElementsForStage4();
         }
      }
      
      public function setElementsForStage4() : *
      {
         this.can_set_elements = true;
         var _loc1_:Array = [];
         if(Character.stage_mode == "wind")
         {
            _loc1_ = ["wind","fire","thunder"];
         }
         else if(Character.stage_mode == "fire")
         {
            _loc1_ = ["fire","thunder","earth"];
         }
         else if(Character.stage_mode == "thunder")
         {
            _loc1_ = ["thunder","earth","water"];
         }
         else if(Character.stage_mode == "earth")
         {
            _loc1_ = ["earth","water","wind"];
         }
         else if(Character.stage_mode == "water")
         {
            _loc1_ = ["water","wind","fire"];
         }
         var _loc2_:Array = [false,false,false];
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         while(_loc3_ < _loc1_.length)
         {
            if(!_loc2_[_loc3_])
            {
               if(!(_loc4_ = this.enemy_team_players[_loc3_].setModes(Character.stage_mode,_loc1_[_loc3_])) && _loc3_ == 0)
               {
                  _loc2_[1] = true;
                  if(!(_loc4_ = this.enemy_team_players[1].setModes(Character.stage_mode,_loc1_[_loc3_])))
                  {
                     _loc2_[2] = true;
                     this.enemy_team_players[2].setModes(Character.stage_mode,_loc1_[_loc3_]);
                  }
               }
               _loc2_[_loc3_] = true;
            }
            _loc3_++;
         }
      }
      
      public function onTargetChange(param1:MouseEvent) : *
      {
         var _loc2_:int = int(param1.currentTarget.name.replace("enemyMc_",""));
         var _loc3_:* = this.getObjectHolder("enemy",_loc2_).charMc.character_model;
         var _loc4_:Boolean = false;
         if(_loc3_.health_manager.getCurrentHP() > 0)
         {
            if(this.isMainPlayerOrControllable(this.agility_bar_manager.ambush_team,this.agility_bar_manager.ambush_num))
            {
               if(!this.agility_bar_manager.is_running)
               {
                  _loc4_ = true;
                  BattleVars.MASTER_PLAYER_TARGET = _loc2_;
                  BattleVars.PLAYER_TARGET = _loc2_;
               }
            }
         }
         if(_loc4_)
         {
            this.resetTargetArrows();
            this.showTargetArrow();
         }
      }
      
      public function onDebugEnemyTargetChange(param1:MouseEvent) : *
      {
         if(!this.isCurrentDebugEnemyManualTurn())
         {
            return;
         }
         var _loc2_:int = int(param1.currentTarget.name.replace("charMc_",""));
         var _loc3_:* = this.getObjectHolder("player",_loc2_).charMc.character_model;
         if(_loc3_ != null && _loc3_.health_manager.getCurrentHP() > 0)
         {
            BattleVars.ENEMY_TARGET = _loc2_;
            this.setDefender("player",_loc2_);
         }
      }
      
      public function showTargetArrow() : *
      {
         this.getObjectHolder("enemy",BattleVars.PLAYER_TARGET).targetArrow.gotoAndPlay("show");
         var _loc1_:int = this.numChildren - 2;
         this.setChildIndex(this.getObjectHolder("enemy",BattleVars.PLAYER_TARGET),_loc1_);
      }
      
      public function resetTargetArrows() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = this.getObjectHolder("enemy",_loc2_);
            _loc1_.targetArrow.gotoAndStop("idle");
            _loc2_++;
         }
      }
      
      public function addToResetNextTurnOnNextTurn(param1:Object, param2:String, param3:int) : *
      {
         this.reset_next_turn_objects.push([param1,param2,param3]);
      }
      
      public function resetNextTurnOnNextTurn(param1:String, param2:int) : *
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.reset_next_turn_objects.length)
         {
            if((_loc3_ = this.reset_next_turn_objects[_loc4_])[1] == param1 && _loc3_[2] == param2)
            {
               _loc3_[0].next_turn = false;
               this.reset_next_turn_objects.removeAt(_loc4_);
               this.resetNextTurnOnNextTurn(param1,param2);
               break;
            }
            _loc4_++;
         }
      }
      
      public function addToResetNewAmountOnNextTurn(param1:Object, param2:String, param3:int) : *
      {
         this.reset_new_amount_objects.push([param1,param2,param3]);
      }
      
      public function resetNewAmountOnNextTurn(param1:String, param2:int) : *
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.reset_new_amount_objects.length)
         {
            if((_loc3_ = this.reset_new_amount_objects[_loc4_])[1] == param1 && _loc3_[2] == param2)
            {
               _loc3_[0].new_amount = undefined;
               this.reset_new_amount_objects.removeAt(_loc4_);
               this.resetNewAmountOnNextTurn(param1,param2);
               break;
            }
            _loc4_++;
         }
      }
      
      public function resetVarsForNextTurn(param1:String, param2:int) : *
      {
         this.resetNewAmountOnNextTurn(param1,param2);
         this.resetNextTurnOnNextTurn(param1,param2);
         BattleVars.resetVarsForNextTurn();
         this.total_damage = 0;
         this.hideActionBars();
         this.handleObjectLayers(param1,param2);
      }
      
      private function isUnderSkipTurnEffect(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(param1.effects_manager.hadEffect("skip_turn"))
         {
            _loc2_ = param1.effects_manager.getEffect("skip_turn");
            if(_loc2_.chance >= NumberUtil.getRandomInt())
            {
               --_loc2_.duration;
               return true;
            }
         }
         return false;
      }
      
      private function handleBlockDamage() : void
      {
         if(this.attacker_model == undefined || this.defender_model == undefined)
         {
            return;
         }
         var _loc1_:Boolean = false;
         if(!this.attacker_model.isCharacter())
         {
            return;
         }
         var _loc2_:int = this.defender_model.checkBlockDamage();
         var _loc3_:int = 0;
         if(this.attacker_model.isCharacter())
         {
            _loc3_ += this.attacker_model.checkIgnoreBlockDamage();
         }
         var _loc4_:int = NumberUtil.getRandomInt();
         _loc2_ -= _loc3_;
         if(_loc2_ > 0 && _loc2_ > _loc4_)
         {
            _loc1_ = true;
            Effects.showEffectInfo(this.defender_model.getPlayerTeam(),this.defender_model.getPlayerNumber(),"Parry",false);
         }
         this.defender_model.IS_BLOCK_DAMAGE = _loc1_;
      }
      
      private function resetBattleVars() : void
      {
         BattleVars.SKILL_USED_ID = "";
         BattleVars.ATTACK_TYPE = "";
         BattleVars.IS_SELF_SKILL = false;
         BattleVars.IS_CRITICAL = false;
         BattleVars.GENJUTSU_REBOUND = false;
      }
      
      public function setupViewForAmbush(param1:String, param2:int, param3:Boolean = false) : void
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         this.debugEnemyManualWaiting = false;
         this.resetBattleVars();
         this.attacker_model = this.getObjectHolder(param1,param2).charMc.character_model;
         this.attacker_model.effects_manager.checkForSnakeShadow(this.attacker_model);
         var _loc4_:Object = this.attacker_model;
         BattleVars.checkPurify(_loc4_);
         var _loc5_:Object = _loc4_.effects_manager;
         var _loc6_:Object = _loc4_.health_manager;
         _loc4_.debuff_resist = false;
         _loc5_.resetKnowledgeOfTime();
         if(_loc4_.isCharacter() && _loc4_.isDead() && BattleVars.PLAY_DEAD_ANIMATION == "CHAR")
         {
            this.checkPlayDeadAnimation();
         }
         this.attacker_model.effects_manager.getCriticalAndAccuracyWhenHPBelow();
         this.attacker_model.effects_manager.getAccuracyBelowHP();
         this.attacker_model.IS_CHAOS = false;
         if(this.isUnderSkipTurnEffect(_loc4_))
         {
            BattleManager.startRun();
            return;
         }
         var _loc7_:String = _loc5_.showActiveEffects();
         _loc5_.deductDurationOfEffects();
         if(_loc7_ == "")
         {
            for each(_loc8_ in _loc5_.getActiveEffects())
            {
               if(_loc8_.duration > 0 && Effects.doesEffectSkipTurns(_loc8_.effect))
               {
                  _loc7_ = "stun";
                  --_loc8_.duration;
                  break;
               }
            }
         }
         this.handleBlockDamage();
         BattleVars.checkCombustion(_loc4_);
         _loc5_.resetHasAddedHpCpEffects();
         this.resetVarsForNextTurn(param1,param2);
         _loc6_.addSP("turn");
         _loc5_.checkPurifyOnRoundStart();
         _loc5_.checkPassiveEffects();
         _loc5_.checkMeridianCutOffFinish();
         _loc5_.checkDecreaseMaxCPFinish();
         _loc5_.checkDecreaseMaxHPCPFinish();
         _loc5_.checkIncreaseMaxHPFinish();
         _loc5_.checkIncreaseMaxHPCPFinish();
         if(!_loc4_.isCharacter() && _loc4_.isDead())
         {
            BattleManager.startRun();
            return;
         }
         if(_loc6_.checkActivateUnyielding() || _loc6_.checkReviveEOM())
         {
            return;
         }
         if(_loc4_.isCharacter() && _loc4_.isDead())
         {
            BattleManager.startRun();
            return;
         }
         if(_loc4_.isCharacter())
         {
            (_loc9_ = _loc4_.actions_manager).updateSkillsCooldownDisplay();
            _loc9_.updateTalentSkillsCooldownDisplay();
            _loc9_.updateSenjutsuSkillsCooldownDisplay();
         }
         _loc5_.checkBackgroundChangeFinish();
         if(_loc7_ == "" && param3)
         {
            this.setupDebugEnemyManualControl();
         }
         else if(_loc7_ == "")
         {
            this.setActionsAvailable(param1,param2);
         }
         else
         {
            this.handleSkipTurns(_loc7_,param1,param2);
         }
      }
      
      public function setupDebugEnemyManualControl() : void
      {
         this.handleDebugEnemyManualTurn();
      }
      
      public function isDebugEnemyManualWaiting() : Boolean
      {
         return this.debugEnemyManualWaiting;
      }
      
      public function setActionsAvailable(param1:String, param2:int, param3:String = "") : void
      {
         if(this.isDebugEncyclopediaEnemyControl(param1,param2))
         {
            this.handleDebugEnemyManualTurn();
            return;
         }
         if(this.isMainPlayerOrControllable(param1,param2))
         {
            this.handleVisibility(param2);
            BattleTimer.startTurnTimer();
            if(this.showGUI)
            {
               this["btn_UI_Gear"].visible = true;
            }
            this["char_hpcp"]["btn_activate_senjutsu"].visible = this.attacker_model.character_info.character_rank > 7;
            this["dh_hint"]["captureBtn"].visible = BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.DRAGON_HUNT_MATCH || Character.is_cny_event;
            if(param3 == "Exceptional Skill")
            {
               this.handleExceptionalSkill();
            }
            this.checkShadowWarEffects();
            this.handleIntelligenceClass();
            if(param1 == "player" && param2 == 0)
            {
               this.handlePlayerTurn();
            }
         }
         else
         {
            this.handleNonControllableAttacker();
         }
      }
      
      private function handleVisibility(param1:int) : void
      {
         var _loc2_:String = this.getActionBarName(param1);
         this.attacker_model.actions_manager.resetActionSubmission();
         this[_loc2_].visible = true;
         this.setChildIndex(this[_loc2_],this.numChildren - 1);
         if(this.showGUI)
         {
            this["btn_UI_Gear"].visible = true;
         }
         this["char_hpcp"]["btn_activate_senjutsu"].visible = this.attacker_model.character_info.character_rank > 7;
         this["dh_hint"]["captureBtn"].visible = BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.DRAGON_HUNT_MATCH;
      }
      
      private function handleExceptionalSkill() : void
      {
         if(this.showGUI)
         {
            this["btn_UI_Gear"].visible = false;
         }
         this["dh_hint"]["captureBtn"].visible = false;
         this.attacker_model.actions_manager.disableAllButClassSkill();
      }
      
      private function checkShadowWarEffects() : void
      {
         if(BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.SHADOWWAR_MATCH && !this.attacker_model.actions_manager.shadow_war_effect_applied)
         {
            this.attacker_model.actions_manager.checkEffectForShadowWar();
         }
      }
      
      private function handleIntelligenceClass() : void
      {
         this.attacker_model.actions_manager.checkUseIntelligenceClass();
         this.attacker_model.actions_manager.reduceCooldownToHeavyAttackClass();
      }
      
      private function getActionBarName(param1:int) : String
      {
         return param1 == 1 ? "actionBar1" : (param1 == 2 ? "actionBar2" : "actionBar");
      }
      
      private function handlePlayerTurn() : void
      {
         this.restoreDebugEnemySkillButtons();
         BattleVars.PLAYER_TARGET = BattleVars.MASTER_PLAYER_TARGET;
         this.resetTargetArrows();
         this.showTargetArrow();
         this.showDragonHuntHint();
         this.showTotalDamageHint();
         this.attacker_model.actions_manager.enableKeyboardShortcuts();
         if(Character.is_jounin_stage_4 && ++this.current_round > 1)
         {
            this.current_round = 0;
            this.setRandomStage();
         }
      }
      
      private function isDebugEncyclopediaEnemyControl(param1:String, param2:int) : Boolean
      {
         return false;
      }
      
      private function isCurrentDebugEnemyManualTurn() : Boolean
      {
         return this.attacker_model != null && this.attacker_model.isEnemy() && this.isDebugEncyclopediaEnemyControl(this.attacker_model.getPlayerTeam(),this.attacker_model.getPlayerNumber());
      }
      
      private function handleDebugEnemyManualTurn() : void
      {
         BattleVars.ATTACKER_TYPE = "ENEMY";
         this.debugEnemyManualWaiting = true;
         this.reduceDebugEnemyCooldowns();
         this.selectDefaultDebugEnemyTarget();
         this.actionBar.visible = false;
         BattleTimer.stopTurnTimer();
         if(this.showGUI)
         {
            this["btn_UI_Gear"].visible = true;
         }
         this.showDebugEnemySkillPanel();
      }
      
      private function reduceDebugEnemyCooldowns() : void
      {
         var _loc1_:Array = this.attacker_model.enemy_info.curr_skill_cooldowns;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] > 0)
            {
               --_loc1_[_loc2_];
            }
            _loc2_++;
         }
      }
      
      private function selectDefaultDebugEnemyTarget() : void
      {
         var _loc1_:int = BattleVars.ENEMY_TARGET;
         if(!this.isAlivePlayerTarget(_loc1_))
         {
            _loc1_ = 0;
            while(_loc1_ < this.character_team_players.length && !this.isAlivePlayerTarget(_loc1_))
            {
               _loc1_++;
            }
            if(_loc1_ >= this.character_team_players.length)
            {
               _loc1_ = 0;
            }
         }
         BattleVars.ENEMY_TARGET = _loc1_;
         this.setDefender("player",_loc1_);
      }
      
      private function isAlivePlayerTarget(param1:int) : Boolean
      {
         return this.character_team_players != null && param1 >= 0 && param1 < this.character_team_players.length && this.character_team_players[param1] != null && this.character_team_players[param1].health_manager != null && this.character_team_players[param1].health_manager.getCurrentHP() > 0;
      }
      
      private function updateDebugEnemySkillButtons() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         this.saveDebugEnemySkillButtons();
         var _loc1_:Array = this.attacker_model.enemy_info.attacks;
         var _loc2_:Array = this.attacker_model.enemy_info.curr_skill_cooldowns;
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            _loc4_ = this.actionBar["skill_" + _loc3_];
            _loc5_ = _loc1_ != null && _loc3_ < _loc1_.length;
            _loc4_.addEventListener(MouseEvent.CLICK,this.onDebugEnemySkillSelected,false,1000,true);
            _loc4_.enabled = _loc5_ && int(_loc2_[_loc3_]) <= 0;
            _loc4_.mouseEnabled = _loc5_;
            _loc4_.mouseChildren = _loc5_;
            _loc4_.visible = _loc5_;
            _loc4_.alpha = _loc5_ && int(_loc2_[_loc3_]) <= 0 ? 1 : 0.45;
            if("cdTxt" in _loc4_)
            {
               _loc4_.cdTxt.text = _loc5_ && int(_loc2_[_loc3_]) > 0 ? String(_loc2_[_loc3_]) : String(_loc3_ + 1);
            }
            _loc3_++;
         }
      }
      
      private function saveDebugEnemySkillButtons() : void
      {
         var _loc2_:* = undefined;
         if(this.debugEnemyActionBarState != null)
         {
            return;
         }
         this.debugEnemyActionBarState = [];
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = this.actionBar["skill_" + _loc1_];
            this.debugEnemyActionBarState.push({
               "visible":_loc2_.visible,
               "alpha":_loc2_.alpha,
               "enabled":_loc2_.enabled,
               "mouseEnabled":_loc2_.mouseEnabled,
               "mouseChildren":_loc2_.mouseChildren,
               "cdText":("cdTxt" in _loc2_ ? _loc2_.cdTxt.text : "")
            });
            _loc1_++;
         }
      }
      
      private function restoreDebugEnemySkillButtons() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         if(this.debugEnemyActionBarState == null)
         {
            return;
         }
         this.hideDebugEnemySkillPanel();
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = this.actionBar["skill_" + _loc1_];
            _loc3_ = this.debugEnemyActionBarState[_loc1_];
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onDebugEnemySkillSelected);
            _loc2_.visible = _loc3_.visible;
            _loc2_.alpha = _loc3_.alpha;
            _loc2_.enabled = _loc3_.enabled;
            _loc2_.mouseEnabled = _loc3_.mouseEnabled;
            _loc2_.mouseChildren = _loc3_.mouseChildren;
            if("cdTxt" in _loc2_)
            {
               _loc2_.cdTxt.text = _loc3_.cdText;
            }
            _loc1_++;
         }
         this.debugEnemyActionBarState = null;
      }
      
      private function showDebugEnemySkillPanel() : void
      {
         var _loc4_:MovieClip = null;
         this.hideDebugEnemySkillPanel();
         var _loc1_:Array = this.attacker_model.enemy_info.attacks;
         var _loc2_:Array = this.attacker_model.enemy_info.curr_skill_cooldowns;
         if(_loc1_ == null)
         {
            return;
         }
         this.debugEnemySkillPanel = new MovieClip();
         this.debugEnemySkillPanel.name = "debugEnemySkillPanel";
         this.debugEnemySkillPanel.x = 760;
         this.debugEnemySkillPanel.y = 95;
         this.addChild(this.debugEnemySkillPanel);
         this.setChildIndex(this.debugEnemySkillPanel,this.numChildren - 1);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            (_loc4_ = this.createDebugEnemySkillButton(_loc3_,int(_loc2_[_loc3_]))).x = int(_loc3_ % 3) * 66;
            _loc4_.y = int(_loc3_ / 3) * 66;
            this.debugEnemySkillPanel.addChild(_loc4_);
            _loc3_++;
         }
      }
      
      private function hideDebugEnemySkillPanel() : void
      {
         var _loc1_:* = undefined;
         if(this.debugEnemySkillPanel == null)
         {
            return;
         }
         while(this.debugEnemySkillPanel.numChildren > 0)
         {
            _loc1_ = this.debugEnemySkillPanel.removeChildAt(0);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onDebugEnemyPanelSkillSelected);
         }
         if(this.debugEnemySkillPanel.parent != null)
         {
            this.debugEnemySkillPanel.parent.removeChild(this.debugEnemySkillPanel);
         }
         this.debugEnemySkillPanel = null;
      }
      
      private function createDebugEnemySkillButton(param1:int, param2:int) : MovieClip
      {
         var _loc6_:TextField = null;
         var _loc3_:MovieClip = new MovieClip();
         var _loc4_:* = param2 <= 0;
         _loc3_.name = "debugEnemySkill_" + param1;
         _loc3_.skill_index = param1;
         _loc3_.buttonMode = true;
         _loc3_.mouseChildren = false;
         _loc3_.alpha = !!_loc4_ ? Number(1) : Number(0.45);
         _loc3_.graphics.beginFill(!!_loc4_ ? uint(5973256) : uint(2960685),0.92);
         _loc3_.graphics.lineStyle(2,!!_loc4_ ? uint(15843890) : uint(7829367));
         _loc3_.graphics.drawRoundRect(0,0,60,60,10,10);
         _loc3_.graphics.endFill();
         var _loc5_:TextField;
         (_loc5_ = new TextField()).defaultTextFormat = new TextFormat("_sans",21,16777215,true,null,null,null,null,"center");
         _loc5_.width = 60;
         _loc5_.height = 28;
         _loc5_.y = param2 > 0 ? Number(7) : Number(16);
         _loc5_.selectable = false;
         _loc5_.mouseEnabled = false;
         _loc5_.text = String(param1 + 1);
         _loc3_.addChild(_loc5_);
         if(param2 > 0)
         {
            (_loc6_ = new TextField()).defaultTextFormat = new TextFormat("_sans",14,16763904,true,null,null,null,null,"center");
            _loc6_.width = 60;
            _loc6_.height = 20;
            _loc6_.y = 36;
            _loc6_.selectable = false;
            _loc6_.mouseEnabled = false;
            _loc6_.text = String(param2);
            _loc3_.addChild(_loc6_);
         }
         _loc3_.addEventListener(MouseEvent.CLICK,this.onDebugEnemyPanelSkillSelected,false,0,true);
         return _loc3_;
      }
      
      private function onDebugEnemyPanelSkillSelected(param1:MouseEvent) : void
      {
         if(!this.isCurrentDebugEnemyManualTurn())
         {
            return;
         }
         param1.stopImmediatePropagation();
         this.submitDebugEnemySkill(int(param1.currentTarget.skill_index));
      }
      
      private function onDebugEnemySkillSelected(param1:MouseEvent) : void
      {
         if(!this.isCurrentDebugEnemyManualTurn())
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:int = int(param1.currentTarget.name.replace("skill_",""));
         this.submitDebugEnemySkill(_loc2_);
      }
      
      private function submitDebugEnemySkill(param1:int) : void
      {
         var _loc2_:Array = this.attacker_model.enemy_info.attacks;
         var _loc3_:Array = this.attacker_model.enemy_info.curr_skill_cooldowns;
         if(_loc2_ == null || param1 < 0 || param1 >= _loc2_.length)
         {
            return;
         }
         if(int(_loc3_[param1]) > 0)
         {
            BattleManager.getMain().showMessage("Skill is under cooldown");
            return;
         }
         this.debugEnemyManualWaiting = false;
         EnemyAI.setDebugManualAction(this.attacker_model,param1,BattleVars.ENEMY_TARGET);
         BattleTimer.stopTurnTimer();
         this.restoreDebugEnemySkillButtons();
         this.hideDebugEnemySkillPanel();
         this.actionBar.visible = false;
         this.attacker_model.getAttack(false);
      }
      
      private function handleNonControllableAttacker() : void
      {
         var _loc1_:String = !!this.attacker_model.isPet() ? "PET" : (!!this.attacker_model.isNpc() ? "NPC" : (!!this.attacker_model.isEnemy() ? "ENEMY" : "CHARACTER"));
         BattleVars.ATTACKER_TYPE = _loc1_;
         if(_loc1_ == "PET" || _loc1_ == "NPC")
         {
            this.fillMasterModel();
         }
         this.attacker_model.getAttack();
      }
      
      public function handleSkipTurns(param1:String, param2:String, param3:int) : *
      {
         var _loc4_:Boolean = Effects.doesEffectSkipTurns(param1);
         var _loc5_:Boolean = this.attacker_model.isCharacter();
         var _loc6_:* = ["barrier","chaos","pet_chaos"].indexOf(param1) != -1;
         if(_loc5_ && (_loc4_ || _loc6_) && this.attacker_model.actions_manager.canUseExceptionalSkill(this.attacker_model))
         {
            this.attacker_model.IS_CHAOS = param1 == "chaos" || param1 == "pet_chaos";
            return this.setActionsAvailable(param2,param3,"Exceptional Skill");
         }
         if(_loc4_)
         {
            this.agility_bar_manager.startRun();
            return;
         }
         if(_loc6_)
         {
            this.attacker_model.handleChaos();
            return;
         }
         if(param1 == "tease")
         {
            if(_loc5_)
            {
               this.attacker_model.handleTease();
            }
            else
            {
               this.agility_bar_manager.startRun();
            }
            return;
         }
         if(_loc5_ && Util.in_array(param1,["barrier","restriction","pet_restriction","meridian_seal"]))
         {
            return this.setActionsAvailable(param2,param3);
         }
         this.agility_bar_manager.startRun();
      }
      
      private function handleDisperse(param1:Array, param2:Object) : Boolean
      {
         var _loc6_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Vector.<Object> = param2.effects_manager.dataBuff;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_].effect == "disperse")
            {
               if("chance" in param1[_loc5_])
               {
                  _loc6_ = NumberUtil.getRandomInt();
                  if(param1[_loc5_].chance < _loc6_)
                  {
                     return false;
                  }
               }
               _loc3_ = true;
               param2.health_manager.createDisplay("Disperse");
               this.removeEffect(_loc4_,"disperse");
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      private function removeEffect(param1:Vector.<Object>, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(param1.length > 0)
         {
            _loc3_ = param1.length - 1;
            for(; _loc3_ >= 0; _loc3_--)
            {
               _loc4_ = param1[_loc3_];
               if(param2 == "disperse")
               {
                  if("no_disperse" in _loc4_ && _loc4_.no_disperse || Effects.doesEffectCannotDisperse(_loc4_.effect))
                  {
                     continue;
                  }
               }
               else if(param2 == "purify")
               {
                  if("no_purify" in _loc4_ && _loc4_.no_purify || Effects.doesEffectCannotPurified(_loc4_.effect))
                  {
                     continue;
                  }
               }
               param1.splice(_loc3_,1);
            }
         }
      }
      
      private function handlePurify(param1:Array, param2:Object) : void
      {
         var _loc4_:Vector.<Object> = null;
         if(param1.length == 0)
         {
            return;
         }
         if(param2.effects_manager.hadEffect("negate") && param1[0].effect != "sensation")
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].effect == "purify" || param1[_loc3_].effect == "sensation" || param1[_loc3_].effect == "debuff_clear")
            {
               if("is_master_buff" in param1[_loc3_] && param1[_loc3_].is_master_buff)
               {
                  param2 = BattleManager.getBattle().master_model;
               }
               if("target" in param1[_loc3_] && param1[_loc3_].target == "master")
               {
                  param2 = BattleManager.getBattle().master_model;
               }
               if(!(param2 == null || param2.effects_manager == null))
               {
                  param2.effects_manager.checkRecoverHPAfterPurified();
                  param2.effects_manager.checkDecreaseMaxCPFinish();
                  param2.effects_manager.checkDecreaseMaxHPCPFinish();
                  _loc4_ = param2.effects_manager.dataDebuff;
                  param2.health_manager.createDisplay("Purify");
                  this.removeEffect(_loc4_,"purify");
               }
            }
            _loc3_++;
         }
      }
      
      public function weaponAttack() : *
      {
         BattleVars.ATTACK_TYPE = "weapon";
         this.attacker_model.action_type = "weapon";
         this.handleDamageAndEffects();
      }
      
      public function weaponAttackFinish() : *
      {
         this.afterAttackChecks("weapon",false,true);
      }
      
      public function hitPlayer() : *
      {
         this.handleDamageAndEffects();
      }
      
      public function hitByPet() : *
      {
         this.handleDamageAndEffects();
      }
      
      public function hitEnemyNpc() : *
      {
         this.handleDamageAndEffects();
      }
      
      public function handleDamageAndEffects() : void
      {
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:Object = null;
         var _loc1_:Object = this.attacker_model.getAttackResult();
         var _loc2_:int = _loc1_.damage;
         var _loc3_:Array = _loc1_.effects;
         var _loc4_:Boolean = _loc1_.multi_hit;
         var _loc5_:Boolean = _loc1_.self_target;
         var _loc6_:Object = this.attacker_model;
         var _loc7_:* = this.geetTarget(_loc5_) + "_model";
         var _loc8_:Array = [this[_loc7_]];
         this.fillPlayers("attacker");
         this.fillPlayers("defender");
         if(_loc4_)
         {
            _loc8_ = this[_loc7_ + "s"];
         }
         this.handlePurify(_loc3_,_loc6_);
         if(!_loc5_)
         {
            this.handlingDodge();
            _loc9_ = 0;
            for each(_loc10_ in _loc8_)
            {
               if(!(_loc10_ == null || _loc10_.health_manager == null || _loc10_.isDead()))
               {
                  if(!_loc10_.IS_DODGED)
                  {
                     _loc9_++;
                  }
               }
            }
            for each(_loc11_ in _loc8_)
            {
               if(_loc11_.IS_DODGED)
               {
                  this.displayDodge(_loc11_);
               }
               else
               {
                  _loc13_ = this.handleDisperse(_loc3_,_loc11_);
                  this.defender_model = _loc11_;
                  if(_loc13_)
                  {
                     _loc11_.IS_BLOCK_DAMAGE = false;
                  }
                  if(!_loc13_)
                  {
                     _loc11_.effects_manager.getDebuffResistByTalent();
                  }
                  this.addInternalInjury(_loc3_,_loc11_);
                  this.handlingExtraEffects(BattleVars.SKILL_USED_ID);
                  this.handlingDamage(_loc11_,_loc2_,_loc9_);
               }
            }
            this.handlingWeaponAttackEffect();
            if(BattleVars.ATTACK_TYPE == "weapon")
            {
               _loc6_.effects_manager.checkWeaponAttackPenalty();
            }
            if((_loc12_ = _loc6_.effects_manager.checkAoeAttackerDamage("recoil_curse",_loc9_)) > 0)
            {
               for each(_loc14_ in _loc8_)
               {
                  if(!(_loc14_ == null || _loc14_.health_manager == null || _loc14_.isDead()))
                  {
                     if(!_loc14_.IS_DODGED)
                     {
                        if(int(_loc14_.health_manager.getCurrentHP()) > 0)
                        {
                           _loc14_.health_manager.addHealth(_loc12_,"Recoil Curse +");
                        }
                     }
                  }
               }
            }
         }
         this.handlingEffect(_loc3_);
         if(BattleVars.SKILL_USED_ID == "skill_2348" && BattleVars.ATTACKER_TYPE != "PET")
         {
            this.attacker_model.effects_manager.checkRandomBuff();
         }
         _loc6_.theft_mode = false;
         _loc6_.blood_tax_mode = false;
      }
      
      private function addInternalInjury(param1:Array, param2:Object) : *
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param1)
         {
            if(!_loc3_.is_passive)
            {
               if(_loc3_.effect == "internal_injury")
               {
                  if(!param2.IS_DODGED)
                  {
                     param2.effects_manager.addDebuff(_loc3_);
                  }
               }
            }
         }
      }
      
      private function handlingWeaponAttackEffect() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc1_:String = "weapon";
         if(this.attacker_model.effects_manager.hadEffect("disable_weapon_effect"))
         {
            return;
         }
         var _loc2_:Array = this.attacker_model.effects_manager.getAllCharacterSetEffects();
         for each(_loc3_ in _loc2_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(Effects.doesEffectGoesToActiveAfterPassive(_loc4_.effect))
               {
                  if(this.shouldActivateEffect(_loc4_,_loc1_))
                  {
                     this.handlePassiveToActiveEffect(_loc4_);
                  }
               }
            }
         }
      }
      
      private function shouldActivateEffect(param1:Object, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         if("chance" in param1)
         {
            _loc3_ = NumberUtil.getRandomInt();
            return param1.chance >= _loc3_ && BattleVars.ATTACK_TYPE == param2;
         }
         return true;
      }
      
      private function handlingDodge() : void
      {
         var _loc7_:Object = null;
         var _loc1_:Boolean = false;
         var _loc2_:Array = this.defender_models;
         var _loc3_:Array = ["skill_2058","skill_2059","skill_2060","skill_4004","skill_554","skill_719","skill_669","skill_2146","skill_2165","skill_2179","skill_2188","skill_2203","skill_2215","skill_6063","skill_6064","skill_2219","skill_2241","skill_2303","skill_2316","skill_2341","skill_2369","skill_5002","skill_2389","skill_7056","skill_7057"];
         var _loc4_:Array = ["skill_426","skill_2222","skill_431"];
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc7_ = _loc2_[_loc6_];
            _loc1_ = BattleVars.getCalculateDodge(_loc7_,this.attacker_model,BattleVars.SKILL_USED_ID);
            _loc6_++;
         }
      }
      
      private function displayDodge(param1:Object) : void
      {
         if(param1.IS_DODGED)
         {
            param1.playAnimation("dodge");
            param1.effects_manager.checkAddHPAfterDodge();
            param1.effects_manager.checkStrengthenAfterDodgedTheAttack();
            Effects.showEffectInfo(param1.getPlayerTeam(),param1.getPlayerNumber(),"Dodge",false);
         }
      }
      
      private function handlingEffects(param1:Array) : void
      {
         var effect:Object = null;
         var effectType:String = null;
         var selfTargets:Array = null;
         var buffTargets:Array = null;
         var debuffTargets:Array = null;
         var effects:Array = param1;
         for each(effect in effects)
         {
            if(!effect.is_passive)
            {
               try
               {
                  effectType = effect.is_self_buff || effect.is_master_buff || effect.is_buff || effect.is_self && !effect.is_debuff ? "buff" : "debuff";
                  if(effect.effect == "internal_injury" && !effect.is_self_debuff)
                  {
                     continue;
                  }
                  if(effect.is_self_buff && effect.is_debuff || effect.is_self_debuff)
                  {
                     selfTargets = [this.attacker_model];
                     this.applyEffect(selfTargets,effect,"Debuff");
                  }
                  else if(effectType == "buff")
                  {
                     buffTargets = [this.attacker_model];
                     buffTargets = !!effect.is_master_buff ? [this.master_model] : buffTargets;
                     if("multi_hit" in effect)
                     {
                        buffTargets = !!effect.multi_hit ? this.attacker_models : buffTargets;
                     }
                     this.applyEffect(buffTargets,effect,"Buff");
                  }
                  else
                  {
                     debuffTargets = [this.defender_model];
                     if("multi_hit" in effect)
                     {
                        debuffTargets = !!effect.multi_hit ? this.defender_models : debuffTargets;
                     }
                     else if("is_master_debuff" in effect)
                     {
                        debuffTargets = !!effect.is_master_debuff ? [this.master_model] : debuffTargets;
                     }
                     this.applyEffect(debuffTargets,effect,"Debuff");
                  }
               }
               catch(e:Error)
               {
                  continue;
               }
            }
         }
      }
      
      private function handlingEffect(param1:Array) : void
      {
         var effect:Object = null;
         var effects:Array = param1;
         for each(effect in effects)
         {
            if(!effect.passive)
            {
               if(!(effect.effect === "internal_injury" && effect.target != "self"))
               {
                  try
                  {
                     this.setEffect(effect.target,effect);
                  }
                  catch(e:Error)
                  {
                  }
               }
            }
         }
      }
      
      private function setEffect(param1:String, param2:Object) : *
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         if(param1 == null || param1 == "" || param1 === undefined)
         {
            param1 = this.inferDefaultEffectTarget(param2);
            if(param1 == null)
            {
               return;
            }
         }
         if(param1 === "self")
         {
            if(param2.multi_hit)
            {
               _loc3_ = (_loc4_ = String(this.attacker_model.getPlayerTeam())) == "player" ? this.character_team_players : this.enemy_team_players;
            }
            else
            {
               _loc3_ = [this.attacker_model];
            }
         }
         else if(param1 === "enemy")
         {
            _loc3_ = !!param2.multi_hit ? this.defender_models : [this.defender_model];
         }
         else if(param1 === "master")
         {
            _loc3_ = [this.master_model];
         }
         if(_loc3_ == null)
         {
            return;
         }
         this.applyEffect(_loc3_,param2,param2.type);
      }
      
      private function inferDefaultEffectTarget(param1:Object) : String
      {
         if(param1 == null || !param1.hasOwnProperty("type"))
         {
            return null;
         }
         var _loc2_:String = String(param1.type).toLowerCase();
         if(_loc2_ == "buff" || _loc2_ == "heal" || _loc2_ == "purify" || _loc2_ == "resist")
         {
            return "self";
         }
         return null;
      }
      
      private function applyEffect(param1:Array, param2:Object, param3:String) : *
      {
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc4_:int = 0;
         for(; _loc4_ < param1.length; _loc4_++)
         {
            if(!((_loc5_ = param1[_loc4_]) == null || _loc5_.health_manager == null))
            {
               if(param3 === "Debuff")
               {
                  if(_loc5_.isDead())
                  {
                     continue;
                  }
                  if(_loc5_.IS_DODGED)
                  {
                     continue;
                  }
                  if(BattleVars.GENJUTSU_REBOUND)
                  {
                     _loc5_.health_manager.createDisplay("Genjutsu Rebound");
                     _loc5_ = this.attacker_model;
                  }
                  else if(_loc5_ != this.attacker_model)
                  {
                     _loc5_.playAnimation("hit");
                  }
               }
               if(param2.hasOwnProperty("conditional") && param2.conditional)
               {
                  if(param2.effect === "ultra_burning")
                  {
                     _loc6_ = false;
                     for each(_loc7_ in _loc5_.effects_manager.dataDebuff)
                     {
                        if(_loc7_.effect !== "ultra_burning")
                        {
                           if(!(_loc7_.effect === "burn" && _loc7_.hasOwnProperty("exclude_from_conditional") && _loc7_.exclude_from_conditional))
                           {
                              _loc6_ = true;
                           }
                           continue;
                        }
                     }
                     if(!_loc6_)
                     {
                        continue;
                     }
                  }
               }
               if("chance" in param2)
               {
                  if(param2.chance >= NumberUtil.getRandomInt())
                  {
                     _loc5_.effects_manager["add" + param3](param2,_loc5_);
                  }
               }
               else
               {
                  _loc5_.effects_manager["add" + param3](param2,_loc5_);
               }
            }
         }
      }
      
      private function handlingExtraEffects(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = SkillLibrary.get(param1);
         var _loc4_:Array;
         if((_loc4_ = SkillBuffs.getCopy(param1).skill_effect) == null)
         {
            _loc4_ = [];
         }
         _loc4_ = this.getElementalEffects(_loc4_,int(_loc3_.skill_type));
         _loc4_ = this.checkForDisperse(_loc4_);
         if(param1 == "skill_236" && Boolean(this.getAttacker().effects_manager.hadEffect("attention")))
         {
            if(this.defender_model.IS_DODGED)
            {
               return;
            }
            _loc2_ = {
               "passive":false,
               "type":"Debuff",
               "target":"enemy",
               "effect":"instant_reduce_hp",
               "effect_name":"Instant Reduce HP",
               "calc_type":"percent",
               "reduce_type":"MAX",
               "duration":0,
               "amount":_loc4_[0].amount
            };
            this.defender_model.effects_manager.addDebuff(_loc2_);
         }
         if(param1 == "skill_270" && Boolean(this.getAttacker().effects_manager.hadEffect("plus_extra_hp")))
         {
            _loc2_ = {
               "passive":false,
               "type":"Debuff",
               "target":"enemy",
               "effect":"weaken",
               "effect_name":"Weaken",
               "calc_type":"percent",
               "duration":_loc4_[0].duration,
               "amount":_loc4_[0].amount
            };
            this.defender_model.effects_manager.addDebuff(_loc2_);
         }
         if(param1 == "skill_253" && Boolean(this.getAttacker().effects_manager.hadEffect("plus_protection")))
         {
            _loc2_ = {
               "passive":false,
               "type":"Debuff",
               "target":"enemy",
               "effect":"internal_injury",
               "effect_name":"Internal Injury",
               "duration":_loc4_[0].duration
            };
            this.defender_model.effects_manager.addDebuff(_loc2_);
         }
         if(param1 == "skill_287" && Boolean(this.getAttacker().effects_manager.hadEffect("reduce_wind_cd")))
         {
            _loc2_ = {
               "passive":false,
               "type":"Debuff",
               "target":"enemy",
               "effect":"bleeding",
               "effect_name":"Bleeding",
               "calc_type":"percent",
               "duration":_loc4_[0].duration,
               "amount":_loc4_[0].amount
            };
            this.defender_model.effects_manager.addDebuff(_loc2_);
         }
         if(param1 == "skill_2359" && (this.defender_model.effects_manager.hadEffect("bleeding") || this.defender_model.effects_manager.hadEffect("pet_bleeding")))
         {
            _loc2_ = {
               "passive":false,
               "type":"Debuff",
               "target":"enemy",
               "effect":"instant_reduce_hp",
               "effect_name":"Bleeding HP",
               "duration":0,
               "amount":10,
               "calc_type":"percent",
               "reduce_type":"MAX",
               "chance":100
            };
            this.defender_model.effects_manager.addDebuff(_loc2_);
         }
      }
      
      private function handlingDamage(param1:Object, param2:int, param3:int = 1) : void
      {
         if(param1.isDead())
         {
            return;
         }
         if(param2 <= 0)
         {
            return;
         }
         var _loc4_:Boolean;
         if(_loc4_ = param1.effects_manager.checkForShedding())
         {
            param1.health_manager.createDisplay("Shedding");
            return;
         }
         this.attacker_model.effects_manager.checkForPowerofToad(param1);
         var _loc5_:Boolean;
         if((_loc5_ = this.attacker_model.effects_manager.handleLightMatter()) && !param1.IS_BLOCK_DAMAGE)
         {
            param1.effects_manager.addEffect("Debuff","internal_injury","Internal Injury",0,"",2,100,"after_attack");
         }
         var _loc6_:Boolean;
         if((_loc6_ = this.attacker_model.effects_manager.handleDarkMatter()) && !param1.IS_BLOCK_DAMAGE)
         {
            param1.effects_manager.addEffect("Debuff","disable_weapon_effect","Disable Weapon Effect",0,"",2,100,"immediately");
         }
         if(BattleVars.SKILL_USED_ID == "skill_4004")
         {
            this.initiateAssaultClass(param1,param2);
            return;
         }
         if(param1.IS_BLOCK_DAMAGE)
         {
            Effects.showEffectInfo(param1.getPlayerTeam(),param1.getPlayerNumber(),"Damage Blocked",false);
            return;
         }
         var _loc7_:Object;
         (_loc7_ = param1.effects_manager).wakePlayer();
         if(BattleVars.SWITCH_ATTACK_MODELS)
         {
            param1 = this.attacker_model;
         }
         if(BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            if(!(param1.debuff_resist || param1.effects_manager.hadEffect("debuff_resist")))
            {
               BattleVars.REDUCED_HP_AS_DAMAGE = false;
               param2 += this.handleReduceHpAsDamage(BattleVars.SKILL_USED_ID,param1);
               param1.health_manager.reduceHealth(param2,"HP-");
               param1.playAnimation("hit");
               _loc7_.wakePlayer();
               param1.health_manager.addSP("attacked",param2);
               param1.effects_manager.handlingTransform(param2);
               this.total_damage = param2;
               param1.effects_manager.checkReboundAfterHPDeduct(param2);
               return;
            }
         }
         var _loc8_:int = int(BattleVars.SKILL_USED_ID.replace("skill_",""));
         var _loc9_:Boolean = BattleVars.SKILL_USED_TYPE == 6 || _loc8_ > 999 && _loc8_ < 1006;
         var _loc10_:Boolean = BattleVars.IS_CRITICAL;
         if(BattleVars.ATTACKER_TYPE != "PET" && !BattleVars.IS_SELF_SKILL)
         {
            _loc7_.checkRandomLock();
         }
         param2 = this.attacker_model.effects_manager.calculateDamage(param2,param1,_loc9_);
         param1.effects_manager.calculateChanceFromTalent_Wolfram(param2);
         this.handleFlashThornedStrike(param2,param1);
         _loc7_.checkBurnAfterDidDamage();
         _loc7_.checkLavaShield();
         _loc7_.checkCapture();
         _loc7_.checkBleedingAfterDidDamage();
         _loc7_.checkStunAfterDidDamage();
         _loc7_.checkDisorientAttacker();
         _loc7_.checkSlowAttacker();
         _loc7_.checkReduceHPAttacker();
         _loc7_.checkDamageToCP(param1,param2);
         if(_loc10_ && param2 > 0)
         {
            _loc7_.checkBurnAfterCritical(param1);
            _loc7_.checkStunAfterCritical(param1);
            _loc7_.checkRecoverHPAfterReceivedCritical(param1);
            this.attacker_model.effects_manager.checkRecoverHPAfterCritical(this.attacker_model);
            this.attacker_model.effects_manager.checkConcentrationAfterCritical(this.attacker_model);
         }
         param2 = _loc7_.checkAbsorbDamage(param1,param2);
         if(BattleVars.SKILL_USED_TYPE == 1 || BattleVars.SKILL_USED_TYPE == 3)
         {
            _loc7_.checkWeakenEnemy();
         }
         if(BattleVars.SKILL_USED_TYPE == 1 || BattleVars.SKILL_USED_TYPE == 5)
         {
            _loc7_.checkFreezeEnemy();
         }
         param1.health_manager.addSP("attacked",param2);
         var _loc11_:Boolean = param2 === 0 ? true : false;
         if(this.checkForReboundDamage(this.attacker_model,param1,param2))
         {
            return;
         }
         param1.playAnimation("hit");
         param1.health_manager.reduceHealth(param2,"-");
         param1.effects_manager.handlingTransform(param2);
         param1.effects_manager.checkTheft();
         param1.effects_manager.checkTheft("blood_tax");
         var _loc12_:Boolean;
         if(_loc12_ = param1.checkConvertDamage())
         {
            param1.health_manager.addHealth(param2,"Damage Converted HP +");
         }
         param1.effects_manager.checkReboundAfterHPDeduct(param2);
         _loc7_.checkPassiveEffectsAfterBeingHit(param1,this.attacker_model,_loc11_);
         this.total_damage = param2;
      }
      
      private function handleFlashThornedStrike(param1:int, param2:Object) : void
      {
         if(BattleVars.SKILL_USED_ID != "skill_7046" && BattleVars.SKILL_USED_ID != "skill_7047")
         {
            return;
         }
         var _loc3_:Object = {
            "type":"Debuff",
            "target":"enemy",
            "effect":"disperse",
            "effect_name":"Disperse",
            "amount":0,
            "duration":1,
            "chance":100
         };
         var _loc4_:Object = {
            "type":"Debuff",
            "target":"enemy",
            "effect":"slow",
            "effect_name":"Slow",
            "amount":0,
            "calc_type":"number",
            "duration":1,
            "chance":100
         };
         if(BattleVars.SKILL_USED_ID == "skill_7046")
         {
            if(param1 < 1500)
            {
               return;
            }
            _loc4_["amount"] = 85;
         }
         if(BattleVars.SKILL_USED_ID == "skill_7047")
         {
            if(param1 < 1500)
            {
               return;
            }
            _loc4_["amount"] = 100;
         }
         this.handleDisperse([_loc3_],param2);
         param2.effects_manager.addDebuff(_loc4_,param2,false);
      }
      
      private function reboundDamage(param1:Object, param2:Object, param3:int, param4:String) : void
      {
         param1.health_manager.reduceHealth(param3,param4);
         param2.playAnimation("hit");
         this.total_damage = param3;
      }
      
      private function checkForReboundDamage(param1:Object, param2:Object, param3:int) : Boolean
      {
         var _loc4_:Boolean = false;
         if(param2.effects_manager.checkSereneMind())
         {
            this.reboundDamage(param1,param2,param3,"Serene Mind -");
            _loc4_ = true;
         }
         if(param1.effects_manager.hadEffect("confinement"))
         {
            this.reboundDamage(param1,param2,param3,"Confinement -");
            _loc4_ = true;
         }
         return _loc4_;
      }
      
      private function initiateAssaultClass(param1:Object, param2:int) : void
      {
         param1.health_manager.reduceHealth(param2,"HP -");
         param1.playAnimation("hit");
         param1.effects_manager.wakePlayer();
         param1.health_manager.addSP("attacked",param2);
         param1.effects_manager.handlingTransform(param2);
         this.total_damage = param2;
         param1.effects_manager.checkReboundAfterHPDeduct(param2);
      }
      
      private function addDamageAfterCritical(param1:int) : int
      {
         var _loc4_:Object = null;
         var _loc2_:int = 50;
         if(this.attacker_model.effects_manager.hadEffect("decrease_critical_damage"))
         {
            _loc4_ = this.attacker_model.effects_manager.getEffect("decrease_critical_damage");
            _loc2_ -= _loc4_.amount;
         }
         if(this.attacker_model.effects_manager.hadEffect("critical_buff_n_received_stun"))
         {
            _loc4_ = this.attacker_model.effects_manager.getEffect("critical_buff_n_received_stun");
            _loc2_ += _loc4_.amount;
         }
         if(this.attacker_model.effects_manager.hadEffect("pet_mortal"))
         {
            _loc4_ = this.attacker_model.effects_manager.getEffect("pet_mortal");
            _loc2_ += _loc4_.amount;
         }
         var _loc3_:int = 0;
         if(this.attacker_model.isCharacter())
         {
            _loc2_ += Math.round(this.attacker_model.character_manager.getLightningAttributes() * 0.8);
            _loc2_ += Math.round(this.attacker_model.effects_manager.getIncreaseCriticalByPassiveEffects("percent"));
            _loc3_ += Math.round(this.attacker_model.effects_manager.getIncreaseCriticalByPassiveEffects("number"));
         }
         return int(param1 * (1 + _loc2_ / 100) + _loc3_);
      }
      
      private function getTarget() : String
      {
         return !!BattleVars.IS_SELF_SKILL ? "attacker" : "defender";
      }
      
      private function geetTarget(param1:Boolean) : String
      {
         return !!param1 ? "attacker" : "defender";
      }
      
      public function handlePassiveToActiveEffect(param1:Object) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.effect == "kill_instant_under")
         {
            _loc2_ = int(this.defender_model.health_manager.getCurrentHP());
            _loc3_ = int(this.defender_model.health_manager.getMaxHP());
            if(_loc2_ > Math.floor(_loc3_ * param1.amount / 100))
            {
               return;
            }
            param1.calc_type = "percent";
            param1.prev_effect = "kill_instant_under";
            param1.reduce_type = "MAX";
         }
         param1.effect = Effects.convertPassiveToActiveEffect(param1.effect);
         if(param1.type === "Debuff")
         {
            if(!this.defender_model.IS_DODGED)
            {
               this.defender_model.effects_manager.addDebuff(param1);
            }
         }
         else if(param1.type === "Buff")
         {
            this.attacker_model.effects_manager.addBuff(param1);
         }
      }
      
      public function fillMasterModel() : *
      {
         var _loc1_:String = String(this.attacker_model.getPlayerTeam());
         var _loc2_:int = "pet_info" in this.attacker_model ? int(int(this.attacker_model.getPlayerNumber())) : 0;
         if(_loc1_ == "player")
         {
            this.master_model = this.character_team_players[_loc2_];
         }
         if(_loc1_ == "enemy")
         {
            this.master_model = this.enemy_team_players[_loc2_];
         }
      }
      
      public function fillPlayers(param1:String) : void
      {
         var _loc2_:Object = param1 == "defender" ? this.defender_model : this.attacker_model;
         var _loc3_:String = String(_loc2_.getPlayerTeam());
         if(param1 == "defender")
         {
            this.attacker_models = _loc3_ == "player" ? this.enemy_team_players : this.character_team_players;
         }
         else
         {
            this.defender_models = _loc3_ == "player" ? this.enemy_team_players : this.character_team_players;
         }
      }
      
      public function hideActionBars() : *
      {
         this["actionBar"].visible = false;
         this["actionBar1"].visible = false;
         this["actionBar2"].visible = false;
      }
      
      public function getObjectHolder(param1:String, param2:int) : *
      {
         if(param1 == "player")
         {
            return this["charMc_" + param2.toString()];
         }
         if(param1 == "enemy")
         {
            return this["enemyMc_" + param2.toString()];
         }
         if(param1 == "player_pet")
         {
            return this["charPetMc_" + param2.toString()];
         }
         if(param1 == "enemy_pet")
         {
            return this["enemyPetMc_" + param2.toString()];
         }
      }
      
      public function setDefender(param1:String, param2:int) : void
      {
         var _loc3_:MovieClip = this.getObjectHolder(param1,param2);
         if(_loc3_ == null || _loc3_.charMc == null || _loc3_.charMc.character_model == null)
         {
            return;
         }
         this.defender_model = _loc3_.charMc.character_model;
         BattleVars.calculateDodge(this.defender_model,this.attacker_model);
         BattleVars.calculateCritical(this.defender_model,this.attacker_model);
      }
      
      public function getDefender() : *
      {
         return this.defender_model;
      }
      
      public function getAttacker() : *
      {
         return this.attacker_model;
      }
      
      public function isMainPlayerOrControllable(param1:String, param2:int) : Boolean
      {
         if(param1 == "player" && param2 == 0)
         {
            return true;
         }
         return Character.teammate_controllable && param1 == "player" && Boolean(this.character_team_players[param2].isCharacter());
      }
      
      public function handleObjectLayers(param1:String, param2:int) : *
      {
         var _loc3_:MovieClip = this.getObjectHolder(param1,param2);
         var _loc4_:int = this.numChildren - 1;
         this.setChildIndex(_loc3_,_loc4_);
      }
      
      public function enemyAttacked() : *
      {
         this.afterAttackChecks("",false,true);
      }
      
      public function petAttacked() : *
      {
         this.afterAttackChecks("",false,true);
      }
      
      public function npcAttacked() : *
      {
         this.afterAttackChecks("",false,true);
      }
      
      public function checkPlayDeadAnimation() : *
      {
         var _loc1_:* = undefined;
         if(BattleVars.PLAY_DEAD_ANIMATION == "CHAR")
         {
            _loc1_ = this.getObjectHolder(BattleVars.PLAY_DEAD_TEAM,BattleVars.PLAY_DEAD_NUMBER).charMc.character_model;
            _loc1_.playAnimation("standby");
            _loc1_.health_manager.playDeadAnimation();
         }
         if(BattleVars.PLAY_DEAD_ANIMATION == "PET")
         {
            _loc1_ = this.getObjectHolder(BattleVars.PLAY_DEAD_TEAM,BattleVars.PLAY_DEAD_NUMBER).charMc.character_model;
            _loc1_.deadFrame();
            _loc1_.health_manager.playDeadAnimation();
         }
         if(BattleVars.PLAY_DEAD_ANIMATION == "ENEMY&NPC")
         {
            _loc1_ = this.getObjectHolder(BattleVars.PLAY_DEAD_TEAM,BattleVars.PLAY_DEAD_NUMBER).charMc.character_model;
            _loc1_.deadFrame();
            _loc1_.health_manager.playDeadAnimation();
         }
         BattleVars.PLAY_DEAD_ANIMATION = "";
      }
      
      public function getTalentSkills() : *
      {
         try
         {
            return String(this.attacker_model.actions_manager.character_talent_skills[0]);
         }
         catch(e:*)
         {
            return "";
         }
      }
      
      public function getSenjutsuSkills() : *
      {
         try
         {
            return String(this.attacker_model.actions_manager.character_senjutsu_skills[0]);
         }
         catch(e:*)
         {
            return "";
         }
      }
      
      public function hitByTalentSkill(param1:String, param2:int, param3:String) : void
      {
         var fireFaint:Object = null;
         var team:String = param1;
         var num:int = param2;
         var skillId:String = param3;
         BattleVars.ATTACK_TYPE = "talent";
         BattleVars.SKILL_USED_ID = skillId;
         var isTrue:Boolean = false;
         var titan:Boolean = this.attacker_model.effects_manager.hadEffect("titan_mode");
         var emberstep_demonic:Boolean = this.attacker_model.effects_manager.hadEffect("emberstep_demonic");
         var targetTeam:String = team == "player" ? "enemy" : "player";
         var targetNum:int = team == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
         try
         {
            this.setDefender(targetTeam,targetNum);
         }
         catch(e:Error)
         {
         }
         var talentLevel:int = this.attacker_model.character_manager.getTalentLevel(skillId);
         var talent:Object = TalentSkillLevel.getCopy(skillId,talentLevel);
         talent.talent_skill_damage = Math.floor(talent.talent_skill_damage * this.attacker_model.character_manager.getLevel());
         var skillTarget:Boolean = "skill_target" in talent && talent.skill_target == "Self" ? true : false;
         var talentDamage:int = talent.talent_skill_damage;
         if(skillId == "skill_1022")
         {
            BattleVars.JUST_USED_TITAN = true;
         }
         if(titan && skillId == "skill_1022")
         {
            this.defender_model.IS_DODGED = false;
         }
         else
         {
            talent.effects = this.checkForDisperse(talent.effects);
            isTrue = int(skillId.replace("skill_","")) > 999 && int(skillId.replace("skill_","")) < 1006 ? true : false;
            switch(skillId)
            {
               case "skill_1038":
                  if(Boolean(this.defender_model.effects_manager.hadEffect("capture")))
                  {
                     talentDamage = Math.floor(talentDamage * 3);
                  }
                  break;
               case "skill_1037":
                  if(Boolean(this.defender_model.effects_manager.hadEffect("silhouette")))
                  {
                     talent.effects[2].amount = Math.floor(talent.effects[2].amount * 3);
                  }
                  break;
               case "skill_1041":
                  if(Boolean(this.defender_model.effects_manager.hadEffect("fire_faint")))
                  {
                     fireFaint = this.defender_model.effects_manager.getEffect("fire_faint");
                     talentDamage += Math.floor(fireFaint.amount * talentDamage / 100);
                  }
            }
         }
         var isMultiHit:* = talent.target == "All" ? true : talent.multi_hit;
         this.attacker_model.attack_result = {
            "damage":talentDamage,
            "effects":talent.effects,
            "multi_hit":isMultiHit,
            "self_target":skillTarget
         };
         this.handleDamageAndEffects();
      }
      
      public function talentSkillAttackFinished(param1:String, param2:int, param3:String) : *
      {
         var _loc4_:* = undefined;
         (_loc4_ = this.getObjectHolder(param1,param2)).charMc.visible = true;
         OutfitManager.removeChildsFromMovieClips(_loc4_.skillMc);
         this.clearCopySkillMC();
         this.afterAttackChecks(param3,false,true);
      }
      
      public function hitBySenjutsuSkill(param1:String, param2:int, param3:String) : *
      {
         BattleVars.ATTACK_TYPE = "senjutsu";
         BattleVars.SKILL_USED_ID = param3;
         var _loc4_:String = param1 == "player" ? "enemy" : "player";
         var _loc5_:int = param1 == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
         this.setDefender(_loc4_,_loc5_);
         var _loc6_:* = SkillLibrary.getSkillInfo(param3);
         var _loc7_:* = this.attacker_model.character_manager.getSenjutsuLevel(_loc6_.skill_id);
         var _loc8_:* = SenjutsuSkillLevel.getCopy(param3,_loc7_);
         var _loc9_:Boolean = "target" in _loc8_ && _loc8_.target == "Self" ? true : false;
         var _loc10_:int = int(_loc8_.damage);
         var _loc11_:Boolean = _loc8_.target == "All" ? true : Boolean(_loc8_.multi_hit);
         BattleVars.SKILL_USED_TYPE = int(_loc6_.skill_type);
         this.attacker_model.action_type = _loc6_.skill_type;
         if(Boolean(_loc8_.multi_hit) && _loc9_)
         {
            BattleVars.SWITCH_ATTACK_MODELS = true;
         }
         this.attacker_model.attack_result = {
            "damage":_loc10_,
            "effects":_loc8_.effects,
            "multi_hit":_loc11_,
            "self_target":_loc9_
         };
         this.handleDamageAndEffects();
      }
      
      public function senjutsuSkillAttackFinished(param1:String, param2:int, param3:String) : *
      {
         var _loc4_:* = undefined;
         (_loc4_ = this.getObjectHolder(param1,param2)).charMc.visible = true;
         OutfitManager.removeChildsFromMovieClips(_loc4_.skillMc);
         this.clearCopySkillMC();
         this.afterAttackChecks(param3,false,true);
      }
      
      public function checkDamageAfterCriticalAndCombustion(param1:*) : int
      {
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(BattleVars.CAN_NOT_DODGE || BattleVars.REDUCED_HP_AS_DAMAGE)
         {
            return param1;
         }
         if(this.attacker_model.isCharacter())
         {
            _loc3_ = this.attacker_model.character_manager.getFireAttributes() * 0.4;
         }
         if(_loc3_ > 0)
         {
            param1 += Math.floor(param1 * _loc3_ / 100);
         }
         if(BattleVars.IS_CRITICAL)
         {
            param1 = Math.floor(param1 * 1.5);
            if(this.attacker_model.effects_manager.hadEffect("decrease_critical_damage"))
            {
               _loc2_ = int(this.attacker_model.effects_manager.getEffect("decrease_critical_damage").amount);
               param1 -= Math.floor(param1 * _loc2_ / 100);
            }
            if(this.attacker_model.effects_manager.hadEffect("critical_buff_n_received_stun"))
            {
               _loc2_ = int(this.attacker_model.effects_manager.getEffect("critical_buff_n_received_stun").amount);
               param1 += Math.floor(param1 * _loc2_ / 100);
            }
            if(this.attacker_model.effects_manager.hadEffect("pet_mortal"))
            {
               _loc2_ = int(this.attacker_model.effects_manager.getEffect("pet_mortal").amount);
               param1 += Math.floor(param1 * _loc2_ / 100);
            }
            if(this.attacker_model.isCharacter())
            {
               if((_loc4_ = Number(this.attacker_model.effects_manager.getIncreaseCriticalByPassiveEffects())) > 0)
               {
                  param1 += Math.floor(param1 * _loc4_ / 100);
               }
               if((_loc4_ = this.attacker_model.character_manager.getLightningAttributes() * 0.8) > 0)
               {
                  param1 += Math.floor(param1 * _loc4_ / 100);
               }
            }
            if(BattleVars.SKILL_USED_ID == "skill_634")
            {
               if((_loc5_ = this.attacker_model.effects_manager.dataBuff.length) > 0)
               {
                  param1 += Math.floor(param1 * (_loc5_ * 30) / 100);
               }
            }
         }
         if(BattleVars.IS_COMBUSTION)
         {
            param1 = Math.floor(param1 * 1.3);
         }
         return param1;
      }
      
      public function hitBySpecialSkill(param1:String, param2:int, param3:String) : *
      {
         var _loc11_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         BattleVars.ATTACK_TYPE = "class_skill";
         BattleVars.SKILL_USED_ID = param3;
         var _loc8_:String = param1 == "player" ? "enemy" : "player";
         var _loc9_:int = param1 == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
         this.setDefender(_loc8_,_loc9_);
         var _loc10_:* = SkillLibrary.getSkillInfo(param3);
         var _loc12_:Boolean = (_loc11_ = "skill_target" in _loc10_ ? String(_loc10_.skill_target) : "Target") == "Self" ? true : false;
         BattleVars.IS_GENJUTSU = false;
         BattleVars.SKILL_USED_TYPE = int(_loc10_.skill_type);
         this.attacker_model.action_type = _loc10_.skill_type;
         BattleVars.IS_SELF_SKILL = _loc12_;
         var _loc13_:* = _loc10_.skill_damage;
         if(param3 == "skill_4004")
         {
            _loc4_ = 64 * (this.attacker_model.getLevel() - 60) + 700;
            _loc5_ = int(this.defender_model.health_manager.getMaxHP());
            _loc7_ = (_loc6_ = int(this.defender_model.health_manager.getCurrentHP())) / _loc5_;
            _loc4_ *= _loc7_;
            _loc13_ = Math.floor(_loc4_);
            BattleVars.CAN_NOT_DODGE = true;
         }
         var _loc14_:Array;
         if((_loc14_ = SkillBuffs.getCopy(param3).skill_effect) == null)
         {
            _loc14_ = [];
         }
         _loc14_ = this.checkForDisperse(_loc14_);
         var _loc15_:Boolean = _loc11_ == "All" ? true : Boolean(_loc10_.multi_hit);
         if(Boolean(_loc10_.multi_hit) && _loc12_)
         {
            BattleVars.SWITCH_ATTACK_MODELS = true;
         }
         var _loc16_:int = 0;
         while(_loc16_ < _loc14_.length)
         {
            if(_loc14_[_loc16_].effect == "heal")
            {
               if("recalc_amount_formula" in _loc14_[_loc16_])
               {
                  _loc14_[_loc16_].amount = int(_loc14_[_loc16_].amount) * this.attacker_model.getLevel() - 3200;
               }
            }
            _loc16_++;
         }
         this.attacker_model.attack_results = [_loc13_,_loc14_,_loc15_,_loc12_];
         this.attacker_model.attack_result = {
            "damage":_loc13_,
            "effects":_loc14_,
            "multi_hit":_loc15_,
            "self_target":_loc12_
         };
         this.handleDamageAndEffects();
      }
      
      public function checkForDisperse(param1:Array) : *
      {
         this.type_disperse = "normal";
         BattleVars.IS_DISPERSED = false;
         var _loc2_:int = 0;
         var _loc3_:int = NumberUtil.getRandomInt();
         while(_loc2_ < param1.length)
         {
            if(!param1[_loc2_].passive)
            {
               if(param1[_loc2_].type === "Debuff" && param1[_loc2_].target === "enemy")
               {
                  if(param1[_loc2_].effect == "disperse" || param1[_loc2_].effect == "disperse_all")
                  {
                     if(param1[_loc2_].chance > _loc3_)
                     {
                        BattleVars.IS_DISPERSED = true;
                        if(param1[_loc2_].effect == "disperse")
                        {
                           this.type_disperse = "normal";
                        }
                        if(param1[_loc2_].effect == "disperse_all")
                        {
                           this.type_disperse = "all";
                        }
                     }
                  }
               }
            }
            _loc2_++;
         }
         return param1;
      }
      
      public function checkForReduceHpAsDamage(param1:Array) : *
      {
         BattleVars.REDUCED_HP_AS_DAMAGE = false;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].effect == "reduce_hp_as_damage" || param1[_loc2_].effect == "insta_reduce_curr_hp")
            {
               BattleVars.REDUCED_HP_AS_DAMAGE = true;
            }
            _loc2_++;
         }
      }
      
      private function handleReduceHpAsDamage(param1:String, param2:Object) : int
      {
         var _loc6_:Object = null;
         BattleVars.REDUCED_HP_AS_DAMAGE = false;
         var _loc3_:Array = SkillBuffs.getSkillBuff(param1).skill_effect;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((_loc6_ = _loc3_[_loc5_]).effect == "reduce_hp_as_damage")
            {
               _loc4_ += Math.round(param2.health_manager.getCurrentHP() * _loc6_.amount / 100);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function playHitAnimation(param1:String, param2:int, param3:String) : void
      {
         var _loc23_:int = 0;
         var _loc24_:Object = null;
         var _loc25_:Object = null;
         var _loc4_:Object = this.attacker_model;
         var _loc5_:Object = this.defender_model;
         var _loc6_:* = param1 == "player";
         BattleVars.ATTACK_TYPE = "skill";
         BattleVars.SKILL_USED_ID = param3;
         var _loc7_:String = !!_loc6_ ? "enemy" : "player";
         var _loc8_:int = !!_loc6_ ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
         this.setDefender(_loc7_,_loc8_);
         var _loc9_:Object;
         var _loc10_:Boolean = (_loc9_ = this.attacker_model.effects_manager).hadEffect("overload");
         var _loc11_:int = _loc9_.getCooldownDecreaseForSkills();
         var _loc13_:int = (_loc12_ = Boolean(_loc9_.getCooldownReduceFromTalent(param3))) && param3 != "skill_3000" ? int(Math.max(0,Math.floor(this.attacker_model.actions_manager.last_used_skill_mc.getCurrentCooldown() / 2 - 1))) : 0;
         var _loc14_:int;
         var _loc15_:Array = [_loc14_ = _loc9_.getCooldownReduceMemekKuda(param3),_loc11_,_loc13_];
         var _loc16_:int = 0;
         while(_loc16_ < _loc15_.length)
         {
            if(_loc15_[_loc16_] > 0)
            {
               this.updateCooldown(param1,param2,_loc15_[_loc16_],_loc16_ == 2 && _loc12_);
            }
            _loc16_++;
         }
         var _loc17_:Object;
         if(!(_loc17_ = SkillLibrary.getSkillInfo(param3)))
         {
            _loc17_ = {};
         }
         var _loc18_:String;
         var _loc19_:* = (_loc18_ = !!_loc17_.hasOwnProperty("skill_target") ? _loc17_.skill_target : "Target") == "Self";
         BattleVars.IS_GENJUTSU = _loc17_.skill_type == 7;
         BattleVars.SKILL_USED_TYPE = _loc17_.skill_type;
         BattleVars.IS_SELF_SKILL = _loc19_;
         if(this.defender_model && this.defender_model.isCharacter() && !_loc19_ && _loc17_.skill_type == 7)
         {
            BattleVars.GENJUTSU_REBOUND = this.defender_model.effects_manager.checkReboundEffects();
         }
         var _loc20_:int = !!_loc17_.hasOwnProperty("skill_damage") ? int(_loc17_.skill_damage) : 0;
         if(_loc10_ && BattleVars.OVERLOAD_MODE)
         {
            _loc20_ += Math.min(this.attacker_model.health_manager.temp_damage_taken,1000);
         }
         _loc20_ = this.attacker_model.effects_manager.addElementalDamage(_loc20_,_loc17_.skill_type,this.defender_model);
         var _loc21_:Array;
         if(!(_loc21_ = SkillBuffs.getCopy(param3).skill_effect))
         {
            _loc21_ = [];
         }
         _loc21_ = this.getElementalEffects(_loc21_,_loc17_.skill_type);
         _loc21_ = this.checkForDisperse(_loc21_);
         this.checkForReduceHpAsDamage(_loc21_);
         switch(param3)
         {
            case "skill_576":
               _loc20_ = Math.floor(Math.random() * 2900) + 101;
               this.attacker_model.health_manager.setCurrentHP(1);
               break;
            case "skill_2010":
               _loc23_ = NumberUtil.getRandomInt();
               _loc24_ = null;
               for each(_loc25_ in _loc21_)
               {
                  if(_loc25_.effect == "sacrifice_self_health_chance" && _loc25_.chance >= _loc23_)
                  {
                     _loc24_ = _loc25_;
                     break;
                  }
               }
               if(_loc24_)
               {
                  _loc20_ = Math.floor(Math.random() * 3900) + 101;
                  this.attacker_model.health_manager.setCurrentHP(1);
               }
               break;
            case "skill_2113":
               BattleVars.JUST_USED_OVERLOAD = true;
               if(_loc10_ && this.defender_model)
               {
                  this.defender_model.IS_DODGED = false;
               }
               if(!_loc10_ && this.defender_model && !this.defender_model.IS_DODGED)
               {
                  this.handlingEffect(_loc21_);
               }
         }
         if(_loc21_.length > 0 && _loc21_[0].hasOwnProperty("effect") && _loc21_[0].effect == "critical_on_heavy_voltage" && this.attacker_model.effects_manager.hadEffect("heavy_voltage"))
         {
            BattleVars.IS_CRITICAL = true;
         }
         if(!_loc10_)
         {
            this.attacker_model.health_manager.temp_damage_taken = 0;
         }
         var _loc22_:Boolean;
         if((_loc22_ = !!_loc17_.hasOwnProperty("multi_hit") ? Boolean(_loc17_.multi_hit) : false) && _loc19_)
         {
            BattleVars.SWITCH_ATTACK_MODELS = true;
         }
         this.attacker_model.attack_result = {
            "damage":_loc20_,
            "effects":_loc21_,
            "multi_hit":_loc22_,
            "self_target":_loc19_
         };
         this.handleDamageAndEffects();
      }
      
      private function updateCooldown(param1:String, param2:int, param3:int, param4:Boolean = false) : void
      {
         var _loc8_:* = undefined;
         var _loc5_:Array = param1 == "player" ? BattleVars.CHARACTER_LEFT_REDUCE_CD : BattleVars.ENEMY_LEFT_REDUCE_CD;
         var _loc6_:Array = param1 == "player" ? BattleVars.CHARACTER_REDUCE_CD : BattleVars.ENEMY_REDUCE_CD;
         var _loc7_:int;
         if((_loc7_ = int(_loc5_[param2])) > 0 && param3 > 0)
         {
            if((_loc8_ = this.attacker_model.actions_manager.last_used_skill_mc) != null)
            {
               _loc8_.setCurrentCooldown(int(_loc8_.getCurrentCooldown()) - param3);
            }
            --_loc6_[param2];
         }
      }
      
      private function getElementalEffects(param1:Array, param2:int) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc6_:Object;
         var _loc5_:Object;
         if((_loc6_ = (_loc5_ = this.getAttacker()).effects_manager.hadEffect("heavy_voltage")) && param2 === 3)
         {
            if(_loc4_ = _loc5_.effects_manager.getEffect("heavy_voltage"))
            {
               param1.push({
                  "passive":false,
                  "type":"Debuff",
                  "target":"enemy",
                  "effect":"stun",
                  "calc_type":"number",
                  "duration":_loc4_.amount,
                  "amount":0
               });
            }
         }
         var _loc7_:Boolean;
         if((_loc7_ = _loc5_.effects_manager.hadEffect("plus_protection")) && param2 === 4)
         {
            if(_loc4_ = _loc5_.effects_manager.getEffect("plus_protection"))
            {
               _loc4_.new_amount = 100;
            }
         }
         var _loc8_:Object = _loc5_.effects_manager.getChanceToRecoverPercentHPCP();
         if(param2 == 4 || param2 == 5)
         {
            _loc3_ = NumberUtil.getRandomInt();
            if(_loc8_.chance > _loc3_)
            {
               _loc4_ = {
                  "effect":"recover_hp_cp",
                  "calc_type":"percent",
                  "amount":_loc8_.amount,
                  "chance":100
               };
               _loc5_.effects_manager.addBuff(_loc4_);
            }
         }
         return param1;
      }
      
      public function specialSkillAttackFinished(param1:String, param2:int, param3:String) : *
      {
         var _loc4_:* = undefined;
         (_loc4_ = this.getObjectHolder(param1,param2)).charMc.visible = true;
         OutfitManager.removeChildsFromMovieClips(_loc4_.skillMc);
         this.clearCopySkillMC();
         if(param3 == "skill_4002")
         {
            this.character_team_players[0].actions_manager.setActionBarVisible(true);
         }
         else
         {
            if(param3 == "skill_4003")
            {
               this.character_team_players[0].actions_manager.disableAttackClass();
            }
            this.afterAttackChecks(param3,false,true);
         }
      }
      
      public function skillAttackFinished(param1:String, param2:int, param3:String) : *
      {
         var _loc4_:* = undefined;
         (_loc4_ = this.getObjectHolder(param1,param2)).charMc.visible = true;
         OutfitManager.removeChildsFromMovieClips(_loc4_.skillMc);
         this.clearCopySkillMC();
         this.afterAttackChecks(param3,true,true);
      }
      
      private function checkUltimateStringActive() : void
      {
         if(this.attacker_model != null && this.attacker_model.isCharacter())
         {
            if(this.attacker_model.ultimate_string != null && this.attacker_model.ultimate_string.isTrue)
            {
               this.attacker_model.health_manager.addHealth(this.attacker_model.ultimate_string.amount,"Recover HP +");
               this.attacker_model.ultimate_string = null;
            }
         }
         if(this.defender_model != null && this.defender_model.isCharacter())
         {
            if(this.defender_model.ultimate_string != null && this.defender_model.ultimate_string.isTrue)
            {
               this.defender_model.health_manager.addHealth(this.defender_model.ultimate_string.amount,"Recover HP +");
               this.defender_model.ultimate_string = null;
            }
         }
      }
      
      private function isRunOnlyFollowUp(param1:String) : Boolean
      {
         return param1 == "skill_7038" || param1 == "skill_7039";
      }
      
      private function resetAfterAttackModes() : void
      {
         BattleVars.TITAN_MODE = false;
         BattleVars.EMBERSTEP = false;
         BattleVars.OVERLOAD_MODE = false;
      }
      
      private function isModelDead(param1:*) : Boolean
      {
         return param1 == null || param1.health_manager == null || param1.health_manager.isDead();
      }
      
      private function canCheckCounter(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean) : Boolean
      {
         return !param4 && param3 && param1 && !BattleVars.IS_SELF_SKILL && this.total_damage != 0 && !param2;
      }
      
      private function canCheckCopy(param1:Boolean, param2:Boolean, param3:Boolean) : Boolean
      {
         return !BattleVars.COUNTER_SKILL && param3 && param1 && !BattleVars.IS_SELF_SKILL && !BattleVars.GENJUTSU_REBOUND && !param2;
      }
      
      private function updateFollowUpModes(param1:String, param2:Boolean) : void
      {
         if(param1 == "" || param2)
         {
            return;
         }
         BattleVars.TITAN_MODE = this.checkTitanMode(param1);
         BattleVars.EMBERSTEP = this.checkEmberstepDemonic(param1);
         if(this.checkOverloadMode(param1))
         {
            BattleVars.OVERLOAD_MODE = true;
         }
      }
      
      private function syncFollowUpModesWithEffects() : void
      {
         if(!this.attacker_model.effects_manager.hadEffect("titan_mode"))
         {
            BattleVars.TITAN_MODE = false;
         }
         if(!this.attacker_model.effects_manager.hadEffect("emberstep_demonic"))
         {
            BattleVars.EMBERSTEP = false;
         }
         if(!this.attacker_model.effects_manager.hadEffect("overload"))
         {
            BattleVars.OVERLOAD_MODE = false;
            BattleVars.JUST_USED_OVERLOAD = false;
         }
         else if(!BattleVars.JUST_USED_OVERLOAD)
         {
            BattleVars.OVERLOAD_MODE = true;
         }
         if(BattleVars.IS_BLOCKED || BattleVars.IS_DAMAGE_CONVERTED)
         {
            BattleVars.TITAN_MODE = false;
         }
      }
      
      private function clearCopyFollowUpState() : void
      {
         BattleVars.COPY_SKILL_ID_SAVE = "";
         BattleVars.ANIMATION_OVERRIDE = false;
         BattleVars.ANIMATION_OVERRIDER = "";
      }
      
      private function clearDefenderDeathFollowUps() : void
      {
         BattleVars.TITAN_MODE = false;
         BattleVars.EMBERSTEP = false;
         BattleVars.COPY_SKILL = false;
         BattleVars.COUNTER_SKILL = false;
         BattleVars.STEAL_JUTSU = false;
         BattleVars.OVERLOAD_MODE = false;
         this.clearCopyFollowUpState();
      }
      
      private function clearAttackerDeathFollowUps() : void
      {
         BattleVars.OVERLOAD_MODE = false;
         BattleVars.TITAN_MODE = false;
         BattleVars.EMBERSTEP = false;
         BattleVars.EMBERSTEP_USED = "";
         this.clearCopyFollowUpState();
      }
      
      private function syncJustUsedFlags() : void
      {
         if(BattleVars.JUST_USED_TITAN)
         {
            BattleVars.TITAN_MODE = false;
         }
         if(BattleVars.JUST_USED_OVERLOAD)
         {
            BattleVars.OVERLOAD_MODE = false;
         }
         if(BattleVars.JUST_USED_EMBERSTEP)
         {
            BattleVars.EMBERSTEP = false;
         }
         if(!BattleVars.TITAN_MODE && !BattleVars.OVERLOAD_MODE && !BattleVars.EMBERSTEP)
         {
            BattleVars.JUST_USED_TITAN = false;
            BattleVars.JUST_USED_OVERLOAD = false;
            BattleVars.JUST_USED_EMBERSTEP = false;
         }
      }
      
      private function hasPendingAfterAttackFollowUp() : Boolean
      {
         return BattleVars.TITAN_MODE || BattleVars.EMBERSTEP || BattleVars.COUNTER_SKILL || BattleVars.COPY_SKILL || BattleVars.OVERLOAD_MODE || BattleVars.STEAL_JUTSU || BattleVars.ANIMATION_OVERRIDE;
      }
      
      private function scheduleTimeout(param1:Function, param2:Number, ... rest) : void
      {
         if(this.pendingTimeouts == null)
         {
            return;
         }
         var _loc4_:uint = setTimeout.apply(null,[param1,param2].concat(rest));
         this.pendingTimeouts.push(_loc4_);
      }
      
      private function scheduleAfterAttackFollowUp() : Boolean
      {
         if(BattleVars.TITAN_MODE && !BattleVars.JUST_USED_TITAN)
         {
            BattleVars.JUST_USED_TITAN = true;
            this.scheduleTimeout(this.copySkill,250,"skill_1022");
            return true;
         }
         if(BattleVars.EMBERSTEP && !BattleVars.JUST_USED_EMBERSTEP)
         {
            BattleVars.JUST_USED_EMBERSTEP = true;
            this.scheduleTimeout(this.copySkill,250,BattleVars.EMBERSTEP_USED);
            return true;
         }
         if(BattleVars.OVERLOAD_MODE && !BattleVars.JUST_USED_OVERLOAD)
         {
            BattleVars.JUST_USED_OVERLOAD = true;
            this.scheduleTimeout(this.copySkill,250,"skill_2113");
            return true;
         }
         if(BattleVars.COUNTER_SKILL)
         {
            BattleVars.COUNTER_SKILL = false;
            this.scheduleTimeout(this.copySkill,250,BattleVars.COPY_SKILL_ID_SAVE,this.defender_model);
            return true;
         }
         if(BattleVars.COPY_SKILL)
         {
            BattleVars.COPY_SKILL = false;
            this.scheduleTimeout(this.copySkill,250,BattleVars.COPY_SKILL_ID_SAVE,this.defender_model);
            return true;
         }
         if(BattleVars.STEAL_JUTSU)
         {
            BattleVars.STEAL_JUTSU = false;
            this.scheduleTimeout(this.copySkill,250,BattleVars.COPY_SKILL_ID_SAVE,this.attacker_model);
            return true;
         }
         if(BattleVars.ANIMATION_OVERRIDE)
         {
            BattleVars.ANIMATION_OVERRIDE = false;
            this.scheduleTimeout(this.copySkill,250,BattleVars.COPY_SKILL_ID_SAVE,this[BattleVars.ANIMATION_OVERRIDER + "_model"]);
            return true;
         }
         return false;
      }
      
      public function afterAttackChecks(param1:String = "", param2:Boolean = false, param3:Boolean = false) : *
      {
         var _loc4_:Boolean = this.isRunOnlyFollowUp(param1);
         var _loc5_:Boolean = this.defender_model && this.defender_model.isCharacter();
         var _loc6_:Boolean = this.defender_model && this.defender_model.IS_DODGED;
         var _loc7_:Boolean = this.isModelDead(this.attacker_model);
         var _loc8_:Boolean = this.isModelDead(this.defender_model);
         if(_loc4_)
         {
            this.agility_bar_manager.startRun();
            return;
         }
         this.resetAfterAttackModes();
         if(this.canCheckCounter(_loc5_,_loc6_,param3,_loc4_))
         {
            BattleVars.COUNTER_SKILL = this.defender_model.effects_manager.dealCounterSkill();
         }
         if(param1 == "" && param3 && !BattleVars.COUNTER_SKILL)
         {
            this.agility_bar_manager.checkForBattleStatus();
         }
         this.checkUltimateStringActive();
         if(this.canCheckCopy(_loc5_,_loc6_,param2))
         {
            BattleVars.COPY_SKILL = this.defender_model.effects_manager.checkCopySkill(param1);
         }
         if(param1 == "skill_3005" && !_loc6_)
         {
            BattleVars.STEAL_JUTSU = this.attacker_model.effects_manager.checkStealJutsu();
         }
         this.updateFollowUpModes(param1,_loc8_);
         this.syncFollowUpModesWithEffects();
         _loc7_ = this.isModelDead(this.attacker_model);
         if(_loc8_ = this.isModelDead(this.defender_model))
         {
            this.clearDefenderDeathFollowUps();
         }
         if(_loc7_)
         {
            this.clearAttackerDeathFollowUps();
         }
         this.syncJustUsedFlags();
         if(!this.hasPendingAfterAttackFollowUp())
         {
            this.agility_bar_manager.startRun();
            return;
         }
         if(this.scheduleAfterAttackFollowUp())
         {
            return;
         }
         this.agility_bar_manager.startRun();
      }
      
      public function activeteICM(param1:*) : *
      {
         this.agility_bar_manager.stopRun();
         var _loc2_:String = String(param1.getPlayerTeam());
         var _loc3_:int = int(param1.getPlayerNumber());
         if(_loc2_ == "player")
         {
            BattleVars.CHARACTER_ICM[_loc3_] = true;
         }
         else
         {
            BattleVars.ENEMY_ICM[_loc3_] = true;
         }
         this.attacker_model = param1;
      }
      
      public function revivePlayer(param1:*) : *
      {
         this.agility_bar_manager.stopRun();
         var _loc2_:String = String(param1.getPlayerTeam());
         var _loc3_:int = int(param1.getPlayerNumber());
         if(_loc2_ == "player")
         {
            BattleVars.CHARACTER_REVIVED[_loc3_] = true;
         }
         else
         {
            BattleVars.ENEMY_REVIVED[_loc3_] = true;
         }
         this.attacker_model = param1;
         this.scheduleTimeout(this.copySkill,250,"skill_1023");
      }
      
      public function activateUnyielding(param1:*) : *
      {
         this.agility_bar_manager.stopRun();
         param1.unyielding_mode = true;
         this.attacker_model = param1;
         this.scheduleTimeout(this.copySkill,250,"skill_1050");
      }
      
      public function copySkill(param1:String, param2:* = null) : *
      {
         var _loc3_:* = undefined;
         if(!BattleVars.MATCH_RUNNING)
         {
            return;
         }
         if(param2 == null)
         {
            param2 = this.attacker_model;
         }
         else
         {
            _loc3_ = this.attacker_model;
            this.attacker_model = param2;
            this.defender_model = _loc3_;
         }
         var _loc4_:Object = SkillLibrary.getSkillInfo(param1);
         BattleVars.COPY_SKILL_TEXT = _loc4_.skill_name;
         BattleVars.COPY_SKILL_ID = param1;
         if(BattleVars.COPY_SKILL_ID == "skill_1050")
         {
            BattleVars.COPY_SKILL_TEXT = "Unyielding Saint";
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_1022")
         {
            BattleVars.COPY_SKILL_TEXT = "Titan Mode";
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_3000")
         {
            BattleVars.COPY_SKILL_TEXT = "Sage Mode";
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_2113")
         {
            BattleVars.COPY_SKILL_TEXT = "Overload Cannon";
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_7042")
         {
            BattleVars.COPY_SKILL_TEXT = "Hellbound Strike";
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_7043")
         {
            BattleVars.COPY_SKILL_TEXT = "Hellbound Strike";
         }
         var _loc5_:Boolean = BattleVars.COPY_SKILL_ID == "skill_1050" || BattleVars.COPY_SKILL_ID == "skill_1022" || BattleVars.COPY_SKILL_ID == "skill_1023" || BattleVars.COPY_SKILL_ID == "skill_2113" || BattleVars.COPY_SKILL_ID == "skill_3000" || BattleVars.COPY_SKILL_ID == "skill_7038" || BattleVars.COPY_SKILL_ID == "skill_7039" || BattleVars.COPY_SKILL_ID == "skill_7042" || BattleVars.COPY_SKILL_ID == "skill_7043";
         var _loc6_:Boolean = this.attacker_model == null || this.attacker_model.health_manager == null || this.attacker_model.health_manager.isDead();
         var _loc7_:Boolean = this.defender_model == null || this.defender_model.health_manager == null || this.defender_model.health_manager.isDead();
         if(!_loc5_ && (_loc6_ || _loc7_))
         {
            BattleVars.COPY_SKILL_ID_SAVE = "";
            BattleVars.COPY_SKILL_ID = "";
            BattleVars.COPY_SKILL_TEXT = "";
            this.agility_bar_manager.startRun();
            return;
         }
         if(BattleVars.COPY_SKILL_ID == "skill_4002")
         {
            this.agility_bar_manager.startRun();
            return;
         }
         if(BattleVars.COPY_SKILL_TEXT == "Titan Mode" && (this.base_damage <= 0 || this.attacker_model.health_manager.isDead() || this.defender_model == null || this.defender_model.health_manager == null || Boolean(this.defender_model.health_manager.isDead())))
         {
            this.agility_bar_manager.startRun();
            return;
         }
         this.setAmbushTeam(param2.getPlayerTeam());
         this.setAmbushNum(param2.getPlayerNumber());
         BattleManager.getMain().loadSkillSWF(BattleVars.COPY_SKILL_ID,this.onSkillSWFLoaded);
      }
      
      public function onSkillSWFLoaded(param1:Event) : void
      {
         var _loc10_:String = null;
         var _loc11_:int = 0;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         if(true)
         {
            param1.target.content.stopAllMovieClips();
         }
         var _loc3_:int = 0;
         var _loc4_:Object = SkillLibrary.getCopy(BattleVars.COPY_SKILL_ID);
         if(int(BattleVars.COPY_SKILL_ID.split("_")[1]) >= 1000 && int(BattleVars.COPY_SKILL_ID.split("_")[1]) <= 1200)
         {
            _loc4_ = TalentSkillLevel.getTalentSkillLevels(BattleVars.COPY_SKILL_ID,this.attacker_model.character_manager.getTalentLevel(BattleVars.COPY_SKILL_ID));
         }
         if(int(BattleVars.COPY_SKILL_ID.split("_")[1]) >= 3001 && int(BattleVars.COPY_SKILL_ID.split("_")[1]) <= 3500)
         {
            _loc4_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(BattleVars.COPY_SKILL_ID,this.attacker_model.character_manager.getSenjutsuLevel(BattleVars.COPY_SKILL_ID));
         }
         var _loc5_:MovieClip;
         (_loc5_ = param1.target.content[BattleVars.COPY_SKILL_ID]).gotoAndStop(1);
         if(true)
         {
            _loc5_.stopAllMovieClips();
         }
         this.copySkillMC = new SkillHandler(_loc5_,this.getAmbushTeam(),this.getAmbushNum(),_loc4_);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         var _loc6_:* = this.attacker_model.character_manager;
         if(!this.copySkillMC.isOutfitFilled())
         {
            this.copySkillMC.fillOutfit(_loc6_.getWeapon(),_loc6_.getBackItem(),_loc6_.getClothing(),_loc6_.getHair(),_loc6_.getFace(),this.attacker_model.character_info.hair_color,this.attacker_model.character_info.skin_color);
         }
         var _loc7_:MovieClip = this.getObjectHolder(this.attacker_model.getPlayerTeam(),this.attacker_model.getPlayerNumber());
         if(this.defender_model == null)
         {
            _loc10_ = this.attacker_model.getPlayerTeam() == "player" ? "enemy" : "player";
            _loc11_ = this.attacker_model.getPlayerTeam() == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
            this.setDefender(_loc10_,_loc11_);
         }
         var _loc8_:* = this.getObjectHolder(this.defender_model.getPlayerTeam(),this.defender_model.getPlayerNumber());
         var _loc9_:int = this.attacker_model.getPlayerTeam() == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
         if(BattleVars.COPY_SKILL_ID == "skill_1022")
         {
            BattleVars.IS_BLOCKED = false;
            this.defender_model.IS_DODGED = false;
            this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(),_loc9_,this.attacker_model.getPlayerNumber(),false);
            this.playTheSkillAnimation(this.copySkillMC.skill_mc,_loc8_,_loc7_,true);
            Effects.showEffectInfo(this.attacker_model.getPlayerTeam(),this.attacker_model.getPlayerNumber(),BattleVars.COPY_SKILL_TEXT,false);
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_2113")
         {
            BattleVars.GENJUTSU_REBOUND = false;
            BattleVars.IS_BLOCKED = false;
            this.defender_model.IS_DODGED = false;
            this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(),_loc9_,this.attacker_model.getPlayerNumber(),false);
            this.playTheSkillAnimation(this.copySkillMC.skill_mc,_loc8_,_loc7_,true);
            Effects.showEffectInfo(this.attacker_model.getPlayerTeam(),this.attacker_model.getPlayerNumber(),BattleVars.COPY_SKILL_TEXT,false);
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_7042" || BattleVars.COPY_SKILL_ID == "skill_7043")
         {
            BattleVars.GENJUTSU_REBOUND = false;
            BattleVars.IS_BLOCKED = false;
            this.defender_model.IS_DODGED = false;
            this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(),_loc9_,this.attacker_model.getPlayerNumber(),false);
            this.playTheSkillAnimation(this.copySkillMC.skill_mc,_loc8_,_loc7_,true);
            Effects.showEffectInfo(this.attacker_model.getPlayerTeam(),this.attacker_model.getPlayerNumber(),BattleVars.COPY_SKILL_TEXT,false);
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_1023")
         {
            BattleVars.GENJUTSU_REBOUND = false;
            BattleVars.IS_BLOCKED = false;
            this.defender_model.IS_DODGED = false;
            this.playTheSkillAnimation(this.copySkillMC.skill_mc,_loc8_,_loc7_,true);
            Effects.showEffectInfo(this.attacker_model.getPlayerTeam(),this.attacker_model.getPlayerNumber(),BattleVars.COPY_SKILL_TEXT,false);
         }
         else if(BattleVars.COPY_SKILL_ID == "skill_7038" || BattleVars.COPY_SKILL_ID == "skill_7039")
         {
            BattleVars.GENJUTSU_REBOUND = false;
            BattleVars.IS_BLOCKED = false;
            this.defender_model.IS_DODGED = false;
            this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(),_loc9_,this.attacker_model.getPlayerNumber(),true);
            this.playTheSkillAnimation(this.copySkillMC.skill_mc,_loc8_,_loc7_,true);
            Effects.showEffectInfo(this.attacker_model.getPlayerTeam(),this.attacker_model.getPlayerNumber(),BattleVars.COPY_SKILL_TEXT,false);
         }
         else if(this.attacker_model.health_manager.hasEnoughCPForSkill(_loc4_))
         {
            _loc3_ = int(this.attacker_model.health_manager.getSkillCpAmount(_loc4_));
            this.attacker_model.health_manager.reduceCP(_loc3_,"skill");
            this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(),_loc9_,this.attacker_model.getPlayerNumber(),false);
            this.playTheSkillAnimation(this.copySkillMC.skill_mc,_loc8_,_loc7_,true);
            Effects.showEffectInfo(this.attacker_model.getPlayerTeam(),this.attacker_model.getPlayerNumber(),BattleVars.COPY_SKILL_TEXT,false);
         }
         else
         {
            this.afterAttackChecks();
         }
      }
      
      public function checkTitanMode(param1:String) : Boolean
      {
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         if(this.defender_model == null || !this.attacker_model.isCharacter() || this.defender_model.IS_DODGED || param1 == "skill_1022")
         {
            return false;
         }
         var _loc2_:* = this.agility_bar_manager.ambush_team == "player";
         var _loc3_:int = this.agility_bar_manager.ambush_num;
         var _loc4_:Boolean;
         if((_loc4_ = !!_loc2_ ? Boolean(BattleVars.CHARACTER_REVIVED[_loc3_]) : Boolean(BattleVars.ENEMY_REVIVED[_loc3_])) || !this.attacker_model.effects_manager.hadEffect("titan_mode"))
         {
            return false;
         }
         if(BattleVars.ATTACK_TYPE == "weapon")
         {
            _loc7_ = Library.getItemInfo(this.attacker_model.character_manager.getWeapon());
            this.base_damage = !!_loc7_.hasOwnProperty("item_damage") ? int(_loc7_.item_damage) : 0;
            return this.base_damage != 0;
         }
         var _loc5_:Object = SkillLibrary.getSkillInfo(param1);
         var _loc6_:int = int(param1.split("_")[1]);
         if(_loc5_.skill_type == 9)
         {
            _loc8_ = this.attacker_model.character_manager.getTalentLevel(param1);
            _loc5_ = TalentSkillLevel.getTalentSkillLevels(param1,_loc8_);
         }
         if(_loc5_.hasOwnProperty("talent_skill_damage"))
         {
            this.base_damage = _loc5_.talent_skill_damage;
         }
         else if(_loc5_.hasOwnProperty("skill_damage"))
         {
            this.base_damage = _loc5_.skill_damage;
         }
         else
         {
            this.base_damage = 0;
         }
         if(param1 == "skill_4004")
         {
            this.base_damage = 1;
         }
         return this.base_damage != 0;
      }
      
      public function checkEmberstepDemonic(param1:String) : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         if(!this.attacker_model.isCharacter())
         {
            return false;
         }
         var _loc2_:Boolean = Boolean(this.attacker_model.effects_manager.hadEffect("emberstep_demonic"));
         if(param1 == "skill_7042")
         {
            BattleVars.EMBERSTEP_USED = "skill_7042";
         }
         if(param1 == "skill_7043")
         {
            BattleVars.EMBERSTEP_USED = "skill_7043";
         }
         if(BattleVars.ATTACK_TYPE == "weapon")
         {
            _loc5_ = Library.getItemInfo(this.attacker_model.character_manager.getWeapon());
            this.base_damage = !!_loc5_.hasOwnProperty("item_damage") ? int(_loc5_.item_damage) : 0;
            return this.base_damage != 0;
         }
         var _loc3_:Object = SkillLibrary.getSkillInfo(param1);
         var _loc4_:int = int(param1.split("_")[1]);
         if(_loc3_.skill_type == 9)
         {
            _loc6_ = this.attacker_model.character_manager.getTalentLevel(param1);
            _loc3_ = TalentSkillLevel.getTalentSkillLevels(param1,_loc6_);
         }
         if(_loc3_.hasOwnProperty("talent_skill_damage"))
         {
            this.base_damage = _loc3_.talent_skill_damage;
         }
         else if(_loc3_.hasOwnProperty("skill_damage"))
         {
            this.base_damage = _loc3_.skill_damage;
         }
         else
         {
            this.base_damage = 0;
         }
         if(param1 == "skill_4004")
         {
            this.base_damage = 1;
         }
         return this.base_damage != 0 && _loc2_ && param1 != "skill_1023" && param1 != "skill_1050" && param1 != "skill_7042" && param1 != "skill_7043";
      }
      
      public function checkOverloadMode(param1:String) : Boolean
      {
         if(!this.attacker_model.isCharacter())
         {
            return false;
         }
         var _loc2_:Boolean = Boolean(this.attacker_model.effects_manager.hadEffect("overload"));
         return _loc2_ && param1 != "skill_2113" && param1 != "skill_1023" && param1 != "skill_1050";
      }
      
      public function playTheSkillAnimation(param1:*, param2:*, param3:*, param4:Boolean = false) : *
      {
         var _loc5_:Point = null;
         var _loc6_:int = this.numChildren - 1;
         this.setChildIndex(param3,_loc6_);
         if("playAnimation" in param1)
         {
            _loc5_ = new Point(param2.x,param2.y + 400);
            this.scheduleTimeout(param1.playAnimation,300,_loc5_);
         }
         else if("playAnimationInTarget" in param1)
         {
            _loc5_ = new Point(param2.x + 125,param2.y + 600);
            this.scheduleTimeout(param1.playAnimationInTarget,300,_loc5_);
         }
         else
         {
            this.scheduleTimeout(this.playItemAtFrameOne,300,param1);
         }
         this.scheduleTimeout(this.hideCharacterAndShowSkill,250,param3,param1);
      }
      
      public function hideCharacterAndShowSkill(param1:*, param2:*) : *
      {
         param1.charMc.visible = false;
         OutfitManager.removeChildsFromMovieClips(param1["skillMc"]);
         param1["skillMc"].addChild(param2);
      }
      
      public function playItemAtFrameOne(param1:*) : *
      {
         param1.gotoAndPlay(1);
      }
      
      public function setAmbushTeam(param1:String) : *
      {
         this.agility_bar_manager.ambush_team = param1;
      }
      
      public function getAmbushTeam() : String
      {
         return this.agility_bar_manager.ambush_team;
      }
      
      public function setAmbushNum(param1:int) : *
      {
         this.agility_bar_manager.ambush_num = param1;
      }
      
      public function getAmbushNum() : int
      {
         return this.agility_bar_manager.ambush_num;
      }
      
      public function enemyDead() : *
      {
      }
      
      public function checkSealEnemy() : *
      {
         var _loc1_:int = int(this.enemy_team_players[0].health_manager.getCurrentHP());
         var _loc2_:int = int(this.enemy_team_players[0].health_manager.getMaxHP());
         var _loc3_:int = Math.ceil(BattleVars.CAPTURE_RANGE_START * _loc2_ / 100);
         var _loc4_:int = Math.ceil(BattleVars.CAPTURE_RANGE_END * _loc2_ / 100);
         if(_loc1_ >= _loc3_ && _loc4_ >= _loc1_)
         {
            return true;
         }
         return false;
      }
      
      public function preCaptureEnemy() : *
      {
         this.enemy_team_players[0].object_mc.gotoAndPlay("dead");
      }
      
      public function showPercentageHpOfEnemy() : *
      {
         var _loc1_:int = int(this.enemy_team_players[0].health_manager.getCurrentHP());
         var _loc2_:int = int(this.enemy_team_players[0].health_manager.getMaxHP());
         var _loc3_:int = Math.ceil(_loc1_ / _loc2_ * 100);
         this["sushiMc"].visible = true;
         this["sushiMc"]["txt_hp"].text = _loc1_ + "/" + _loc2_;
         this["sushiMc"]["txt_hp_prc"].text = _loc3_ + "%";
         this.eventHandler.addListener(this["sushiMc"]["btnClose"],MouseEvent.CLICK,this.onCloseSushiMc);
      }
      
      public function onCloseSushiMc(param1:MouseEvent) : *
      {
         this["sushiMc"].visible = false;
         BattleManager.startRun();
      }
      
      public function showDragonHuntHint() : *
      {
         if(BattleManager.BATTLE_VARS.BATTLE_MODE != BattleVars.DRAGON_HUNT_MATCH && !Character.is_cny_event)
         {
            return;
         }
         this["dh_hint"].visible = true;
         if(!this["dh_hint"]["captureBtn"].hasEventListener(MouseEvent.CLICK))
         {
            this.eventHandler.addListener(this["dh_hint"]["captureBtn"],MouseEvent.CLICK,this.onOpenGear);
         }
         this["dh_hint"]["dragonIconMc"].gotoAndStop(this.enemy_team_players[0].player_identification);
         this["dh_hint"]["catchableTxt"].text = "Capturable range " + BattleVars.CAPTURE_RANGE_START + "% - " + BattleVars.CAPTURE_RANGE_END + "%";
         var _loc1_:int = BattleVars.CAPTURE_RANGE_END - BattleVars.CAPTURE_RANGE_START;
         var _loc2_:int = BattleVars.CAPTURE_RANGE_START * 140 / 100;
         this["dh_hint"]["redHpBarMc"].scaleX = _loc1_ / 100;
         this["dh_hint"]["redHpBarMc"].x = 97 + _loc2_;
      }
      
      public function showTotalDamageHint() : *
      {
         if(!Character.is_ramadhan_event)
         {
            return;
         }
         this["totalDamageHint"].visible = true;
         this["totalDamageHint"]["descTxt"].text = "Total Damage";
         this["totalDamageHint"]["turnTxt"].text = this.agility_bar_manager.player_turns + " Turn remaining.";
         this["totalDamageHint"]["dmgTxt"].text = Util.formatNumberWithDot(this.getTotalDamageDoneToEnemies());
         if(this.agility_bar_manager.player_turns < 1)
         {
            this.actionBar.visible = false;
            this.character_team_players[0].gotoStandby();
            this.agility_bar_manager.playWinAnimationToSelfAndTeammates();
            this.enemy_team_players[0].playAnimation("dead");
            this.endBattle(true);
            return;
         }
      }
      
      public function hideDragonHuntHint() : *
      {
         this["dh_hint"].visible = false;
      }
      
      public function captureEnemy() : *
      {
         var _loc1_:int = int(this.enemy_team_players[0].health_manager.getCurrentHP());
         var _loc2_:int = int(this.enemy_team_players[0].health_manager.getMaxHP());
         BattleVars.CAPTURED_AT = Math.ceil(_loc1_ / _loc2_ * 100);
         this.endBattle(true);
      }
      
      public function addToTotalDamageDoneToEnemies(param1:Number) : *
      {
         this.total_damage_done += param1;
      }
      
      public function getTotalDamageDoneToEnemies() : Number
      {
         return this.total_damage_done;
      }
      
      public function sendBattleFinishedLogs(param1:*) : *
      {
         if(!param1.is_connected)
         {
            this.scheduleTimeout(this.sendBattleFinishedLogs,100,param1);
         }
         param1.sendBattleFinished(Character.char_id,Character.char_id,Character.battle_code,Character.battle_logs.join("; "));
      }
      
      private function getLoadedsSkill() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = [];
         try
         {
            _loc2_ = this.getObjectHolder("player",0).charMc.character_model;
            if(_loc2_ && _loc2_.actions_manager)
            {
               _loc1_ = _loc2_.actions_manager.loadeds;
            }
         }
         catch(e:*)
         {
         }
         return _loc1_;
      }
      
      private function endBattleAndCallAmf(param1:Boolean) : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:Number = NaN;
         var _loc2_:* = undefined;
         this._main.loading(false);
         Character.teammate_controllable = false;
         var _loc3_:* = {
            "wind":Character.atrrib_wind,
            "fire":Character.atrrib_fire,
            "lightning":Character.atrrib_lightning,
            "water":Character.atrrib_water,
            "earth":Character.atrrib_earth
         };
         var _loc4_:Object = {
            "weapon":Character.character_weapon,
            "set":Character.character_set,
            "back_item":Character.character_back_item,
            "accessory":Character.character_accessory
         };
         var _loc5_:* = {
            "status":_loc3_,
            "items":_loc4_,
            "____":this.getLoadedsSkill(),
            "bytes":{
               "_":("loaderInfo" in this._main ? this._main.loaderInfo.bytesLoaded : null),
               "__":("loaderInfo" in this._main ? this._main.loaderInfo.bytesTotal : null),
               "___":Library.getItemInfo("duar",this._main,Character["_"]),
               "____":Character["_"],
               "_____":("loa" + "der" + "In" + "fo" in this._main ? this["_main"]["loa" + "der" + "In" + "fo"]["by" + "tes" + "Loa" + "ded"] : null),
               "______":("lo" + "ader" + "In" + "fo" in this._main ? this["_main"]["lo" + "ader" + "In" + "fo"]["byt" + "es" + "To" + "tal"] : null)
            }
         };
         _loc6_ = Base64.encode(JSON.stringify(_loc5_));
         if(param1)
         {
            switch(BattleManager.BATTLE_VARS.BATTLE_MODE)
            {
               case BattleVars.FRIENDLY_MATCH:
                  _loc2_ = CUCSG.hash(Character.char_id + Character.battle_code + Character.sessionkey);
                  new amfConnect().service("OvAKMASEbHeDKgxc.t21mDUCcClAY",[Character.char_id,Character.battle_code,_loc2_,Character.sessionkey,_loc6_],this.onBattleFinishAmf,true);
                  break;
               case BattleVars.CLAN_MATCH:
                  _loc7_ = [_loc6_,Character.clan_attack_id,Character.battle_code];
                  _loc2_ = Hex.fromArray(new MD5().hash(Hex.toArray(Hex.fromString([Character.char_id,Character.sessionkey,Character.clan_attack_id,Character.battle_code].join("|")))));
                  _loc7_.push(_loc2_);
                  Clan.instance.delayDestroy(false);
                  Clan.instance.finishManualAttack(_loc7_,this.finishClanBattleRes);
                  break;
               case BattleVars.CREW_MATCH:
                  _loc8_ = Crew.instance.getBattleData();
                  Crew.instance.delayDestroy(false);
                  Crew.instance.finishBattle({
                     "b":_loc8_.b,
                     "s":_loc6_,
                     "c":_loc8_.c,
                     "t":_loc8_.t,
                     "f":Character.temp_recruit_ids,
                     "h":Hex.fromArray(new MD5().hash(Hex.toArray(Hex.fromString([Character.char_id,_loc8_.b,_loc8_.t,_loc8_.c,_loc6_].join("|")))))
                  },this.finishCrewBattle);
                  break;
               case BattleVars.MISSION_MATCH:
                  if(Character.stage_grade_s_mission == 2 && this._main.grade_s_battle_counter < 2)
                  {
                     this._main.remainingStatus = [];
                     _loc9_ = 0;
                     while(_loc9_ < this.character_team_players.length)
                     {
                        this._main.remainingStatus.push({
                           "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                           "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                           "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                           "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                           "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                        });
                        _loc9_++;
                     }
                     ++this._main.grade_s_battle_counter;
                     this._main.startGradeSBattle(this._main.grade_s_battle_counter);
                  }
                  else if(Character.stage_grade_s_mission == 3 && this._main.is_ambush_battle)
                  {
                     this._main.remainingStatus = [];
                     _loc9_ = 0;
                     while(_loc9_ < this.character_team_players.length)
                     {
                        this._main.remainingStatus.push({
                           "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                           "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                           "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                           "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                           "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                        });
                        _loc9_++;
                     }
                     this._main.continueAmbushBattle();
                  }
                  else if(Character.stage_grade_s_mission == 4 && this._main.grade_s_battle_counter < 7)
                  {
                     this._main.continueStage4GradeS();
                  }
                  else if(Character.stage_grade_s_mission == 5 && this._main.grade_s_battle_counter < 4)
                  {
                     this._main.continueStage5GradeS();
                  }
                  else
                  {
                     this._main.remainingStatus = [];
                     _loc2_ = CUCSG.hash(Character.mission_id + Character.char_id + Character.battle_code + this.getTotalDamageDoneToEnemies());
                     new amfConnect().service("IOIJB836r2Hu2PPW.MSi71s3i1X89",[Character.char_id,Character.mission_id,Character.battle_code,_loc2_,this.getTotalDamageDoneToEnemies(),Character.sessionkey,_loc6_,Character.stage_grade_s_mission],this.onBattleFinishAmf,true);
                  }
                  break;
               case BattleVars.SHADOWWAR_MATCH:
                  _loc2_ = CUCSG.hash(String(Character.char_id) + String(Character.battle_code) + String(this.getTotalDamageDoneToEnemies()) + _loc6_);
                  new amfConnect().service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["X23RAVNJfVzG",[Character.char_id,Character.sessionkey,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc6_,_loc2_]],this.onBattleFinishAmf,true);
                  break;
               case BattleVars.DRAGON_HUNT_MATCH:
                  _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString() + BattleVars.DH_MODE.toString() + BattleVars.CAPTURED_AT.toString());
                  new amfConnect().service("uw8zuDzUq5Zgt3o7.hX8xVb3mvz0m",[Character.char_id,Character.christmas_boss_id,Character.battle_code,_loc2_,this.getTotalDamageDoneToEnemies(),Character.sessionkey,_loc6_,BattleVars.DH_MODE,BattleVars.CAPTURED_AT],this.onBattleFinishAmf,true);
                  break;
               case BattleVars.EVENT_MATCH:
                  if(Character.is_hunting_house)
                  {
                     _loc2_ = CUCSG.hash(String(Character.hunting_zone) + String(Character.char_id) + String(Character.battle_code));
                     new amfConnect().service("JDEUnbiWJXOtHxVv.wrlPOTLOEWFE",[Character.char_id,Character.hunting_zone,Character.battle_code,_loc2_,Character.sessionkey,_loc6_],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_eudemon_garden)
                  {
                     _loc2_ = CUCSG.hash(String(Character.eudemon_boss_num) + String(Character.char_id) + String(Character.battle_code));
                     new amfConnect().service("A11M5XZ9wxhTs2Dr.L6IPyPI8oNXL",[Character.char_id,Character.eudemon_boss_num,Character.battle_code,_loc2_,Character.sessionkey,_loc6_],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_salus_event)
                  {
                     _loc2_ = CUCSG.hash(Character.christmas_boss_num.toString() + Character.char_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString());
                     new amfConnect().service("SalusEvent2023.finishBattle",[Character.char_id,Character.christmas_boss_num,Character.battle_code,_loc2_,this.getTotalDamageDoneToEnemies(),Character.sessionkey,_loc6_],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_monster_hunter_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("vnB7P8simcleapK1.hW7GRYkEv7Ak",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_thanksgiving_special_event)
                  {
                     if(this._main.thanksgiving_battle_counter >= 2)
                     {
                        Character.is_thanksgiving_special_event = false;
                        this._main.remainingStatus = [];
                        this._main.thanksgiving_battle_counter = 0;
                        _loc2_ = CUCSG.hash(Character.christmas_boss_num.toString() + Character.char_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString());
                        new amfConnect().service("ThanksGivingEvent2023.finishExtremeBattle",[Character.char_id,Character.christmas_boss_num,Character.battle_code,_loc2_,this.getTotalDamageDoneToEnemies(),Character.sessionkey,_loc6_],this.onBattleFinishAmf,true);
                     }
                     else
                     {
                        this._main.remainingStatus = [];
                        _loc9_ = 0;
                        while(_loc9_ < this.character_team_players.length)
                        {
                           this._main.remainingStatus.push({
                              "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                              "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                              "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                              "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                              "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                           });
                           _loc9_++;
                        }
                        ++this._main.thanksgiving_battle_counter;
                        this._main.startThanksgivingBattle(this._main.thanksgiving_battle_counter);
                     }
                  }
                  else if(Character.is_valentine_special_event)
                  {
                     if(this._main.valentine_battle_counter >= 2)
                     {
                        Character.is_valentine_special_event = false;
                        this._main.remainingStatus = [];
                        this._main.valentine_battle_counter = 0;
                        _loc2_ = CUCSG.hash(Character.christmas_boss_id.toString() + Character.char_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString());
                        new amfConnect().service("ValentineEvent2024.finishSpecialBattle",[Character.char_id.toString(),Character.christmas_boss_id,Character.battle_code,_loc2_,this.getTotalDamageDoneToEnemies().toString(),Character.sessionkey,_loc6_],this.onBattleFinishAmf,true);
                     }
                     else
                     {
                        this._main.remainingStatus = [];
                        _loc9_ = 0;
                        while(_loc9_ < this.character_team_players.length)
                        {
                           this._main.remainingStatus.push({
                              "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                              "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                              "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                              "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                              "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                           });
                           _loc9_++;
                        }
                        ++this._main.valentine_battle_counter;
                        this._main.startValentineBattle(this._main.valentine_battle_counter);
                     }
                  }
                  else if(Character.is_delivery_event)
                  {
                     if(this._main.is_ambush_battle)
                     {
                        this._main.remainingStatus = [];
                        _loc9_ = 0;
                        while(_loc9_ < this.character_team_players.length)
                        {
                           this._main.remainingStatus.push({
                              "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                              "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                              "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                              "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                              "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                           });
                           _loc9_++;
                        }
                        this._main.continueAmbushBattle();
                     }
                     else
                     {
                        _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                        _loc10_ = (int(Character.char_id) + int(Character.character_lvl)) * (105 * this._main.ambushBattleData.current_engagement);
                        new amfConnect().service("DeliveryEvent2024.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,_loc10_,Character.sessionkey],this.onBattleFinishAmf,true);
                     }
                  }
                  else if(Character.is_summer_special_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("SummerEvent2024.finishSpecialBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_poseidon_event)
                  {
                     if(this._main.poseidon_battle_counter >= 2)
                     {
                        _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                        new amfConnect().service("PoseidonEvent2024.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                     }
                     else
                     {
                        this._main.loadPoseidonDialogue("scene_2");
                     }
                  }
                  else if(Character.is_cny_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString() + BattleVars.CAPTURED_AT.toString());
                     new amfConnect().service("ChineseNewYear2025.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,_loc2_,this.getTotalDamageDoneToEnemies(),Character.sessionkey,_loc6_,BattleVars.CAPTURED_AT],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_valentine_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("ValentineEvent2025.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_anniversary_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("zy8Ztqe05vkpqNx0.uKk9VAgM7xjS",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_anniversary_spenemy_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("zy8Ztqe05vkpqNx0.GtYKoRXt5qvS",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_ramadhan_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("RamadhanEvent2025.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_world_master_games_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("WorldMasterGames2025.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_independence_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("IndependenceEvent2025.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_yinyang_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("YinYangEvent.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_halloween_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("HalloweenEvent2025.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_confronting_death_event)
                  {
                     if(this._main.confronting_death_battle_counter >= 2)
                     {
                        _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                        new amfConnect().service("Kut8xeaxJWcRM9w1.x5IKJPcQWrY6",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                     }
                     else
                     {
                        this._main.loadConfrontingDeathDialogue("scene_2");
                     }
                  }
                  else if(Character.is_thanksgiving_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("ThanksGivingEvent2025.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_christmas_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("ChristmasEvent2025.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_kyunoki_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("PhantomKyunokiEvent2026.finishBattle",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_hanami_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("1MrX5OoGfy794qny.YhuinqR2G0jc",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_easter_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("dNybGv4T7OcLQ5Yq.1NhuEHC4J6Rb",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_worldcup_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("qewuJV7QnTaJ86hH.Bz98TOibrLoV",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_summer_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("urUACOuL6PahuoEd.iETwupoGdQMO",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  else if(Character.is_circus_event)
                  {
                     _loc2_ = CUCSG.hash(Character.char_id.toString() + Character.christmas_boss_id.toString() + Character.battle_code + this.getTotalDamageDoneToEnemies().toString() + _loc6_.toString());
                     new amfConnect().service("Yg8TZbNQrrhSci2l.fRGiPcIczAbE",[Character.char_id,Character.christmas_boss_id,Character.battle_code,this.getTotalDamageDoneToEnemies(),_loc2_,_loc6_,Character.sessionkey],this.onBattleFinishAmf,true);
                  }
                  break;
               case BattleVars.EXAM_MATCH:
                  Character.character_class = null;
                  if(this._main.is_ninja_tutor_exam_s1c2)
                  {
                     this._main.continueNinjaTutorExamS1C2();
                  }
                  else if(this._main.is_ninja_tutor_exam_s2c2)
                  {
                     this._main.continueNinjaTutorExamS2C2();
                  }
                  else if(this._main.is_ninja_tutor_exam_s3c2)
                  {
                     this._main.continueNinjaTutorExamS3C2();
                  }
                  else if(this._main.is_ninja_tutor_exam_s4c2)
                  {
                     this._main.continueNinjaTutorExamS4C2();
                  }
                  else if(this._main.is_ninja_tutor_exam_s5c2)
                  {
                     this._main.continueNinjaTutorExamS5C2();
                  }
                  else if(this._main.is_ninja_tutor_exam_s6c1)
                  {
                     this._main.continueNinjaTutorExamS6C1();
                  }
                  else if(this._main.is_ninja_tutor_exam_s6c2)
                  {
                     this._main.continueNinjaTutorExamS6C2();
                  }
                  else if(this._main.is_special_jounin_exam_s1c2)
                  {
                     this._main.continueSpecialJouninExamS1C2();
                  }
                  else if(this._main.is_special_jounin_exam_s2c2)
                  {
                     this._main.continueSpecialJouninExamS2C2();
                  }
                  else if(this._main.is_special_jounin_exam_s3c2)
                  {
                     this._main.continueSpecialJouninExamS3C2();
                  }
                  else if(this._main.is_special_jounin_exam_s4c2)
                  {
                     this._main.finishSpecialJouninExam();
                  }
                  else if(this._main.is_special_jounin_exam_s5c2)
                  {
                     this._main.finishSpecialJouninExam();
                  }
                  else if(this._main.is_special_jounin_exam_s6c1)
                  {
                     this._main.finishSpecialJouninExam();
                  }
                  else if(this._main.is_special_jounin_exam_s6c2)
                  {
                     this._main.finishSpecialJouninExam();
                  }
                  else if(this._main.is_special_jounin_exam_s6c3)
                  {
                     this._main.finishSpecialJouninExam();
                  }
                  else if(Boolean(this._main.is_jounin_exam_stage2) || Character.mission_id == "jounin_stage2_4")
                  {
                     this._main.continueJouninExamStage2();
                  }
                  else if(this._main.is_jounin_exam_stage5)
                  {
                     this._main.finishStage5Jounin();
                  }
                  else if(this._main.is_jounin_exam_stage4)
                  {
                     this._main.finishStage4Jounin();
                  }
                  else if(this._main.is_exam_stage5)
                  {
                     this._main.continueStage5();
                  }
                  else if(this._main.is_exam_stage4)
                  {
                     this._main.continueStage4();
                  }
                  else if(this._main.is_exam_stage3)
                  {
                     this._main.continueStage3();
                  }
                  else if(this._main.exam_enemy == "ene_31")
                  {
                     this._main.exam_enemy = "";
                     this._main.continueStage2(1);
                  }
                  else if(this._main.exam_enemy == "ene_36")
                  {
                     this._main.exam_enemy = "";
                     this._main.continueStage2(2);
                  }
                  break;
               case BattleVars.TEST_MATCH:
                  this._main.battleRewards("0","0","Testing",false);
            }
         }
         else if(Boolean(this._main.is_jounin_exam_stage2) || Boolean(this._main.is_jounin_exam_stage5) || Boolean(this._main.is_jounin_exam_stage4) || Boolean(this._main.is_special_jounin_exam_s6c3) || Boolean(this._main.is_special_jounin_exam_s6c2) || Boolean(this._main.is_special_jounin_exam_s6c1) || Boolean(this._main.is_special_jounin_exam_s5c2) || Boolean(this._main.is_special_jounin_exam_s4c2) || Boolean(this._main.is_special_jounin_exam_s3c2) || Boolean(this._main.is_special_jounin_exam_s2c2) || Boolean(this._main.is_special_jounin_exam_s1c2) || Boolean(this._main.is_ninja_tutor_exam_s1c2) || Boolean(this._main.is_ninja_tutor_exam_s2c2) || Boolean(this._main.is_ninja_tutor_exam_s3c2) || Boolean(this._main.is_ninja_tutor_exam_s4c2) || Boolean(this._main.is_ninja_tutor_exam_s5c2) || Boolean(this._main.is_ninja_tutor_exam_s6c1) || Boolean(this._main.is_ninja_tutor_exam_s6c2))
         {
            this._main.exam_stage.showFailDialog();
         }
         else
         {
            this._main.battleRewards("0","0","Lost",false);
         }
         this.resetGameModes();
      }
      
      public function endBattle(param1:Boolean) : *
      {
         BattleVars.MATCH_RUNNING = false;
         BattleTimer.stopTurnTimer();
         this._main.loading(false);
         ++this._main.battleCount;
         this.scheduleTimeout(this.endBattleAndCallAmf,1200,param1);
      }
      
      public function onBattleFinishAmf(param1:Object = null) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         Character.character_recruit_ids = [];
         if(param1 != null)
         {
            if(param1.status == 1)
            {
               Character.character_xp = param1.xp;
               _loc4_ = int(param1.level) - int(Character.character_lvl);
               Character.atrrib_free = _loc4_;
               Character.character_lvl = param1.level;
               if(BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.ARENA_MATCH)
               {
                  _loc2_ = getDefinitionByName("ShadowWarReward") as Class;
                  _loc3_ = new _loc2_(this._main,param1.trophies_got);
                  this._main.loader.addChild(_loc3_);
               }
               else
               {
                  this._main.battleRewards(param1.result[0],param1.result[1],param1.result[2],param1.level_up,param1);
                  if(Character.is_confronting_death_event)
                  {
                     this._main.loadConfrontingDeathDialogue("scene_3");
                  }
               }
            }
            else
            {
               this._main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
               this._main.getError(!!param1.hasOwnProperty("error") ? param1.error : "2000");
            }
         }
         else if(BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.ARENA_MATCH)
         {
            _loc2_ = getDefinitionByName("ShadowWarReward") as Class;
            _loc3_ = new _loc2_(this._main,0);
            this._main.loader.addChild(_loc3_);
         }
         else
         {
            this._main.battleRewards("0","0",[],false);
         }
      }
      
      public function hideUI(param1:MouseEvent) : void
      {
         this.showGUI = !this.showGUI;
         this.char_hpcp.visible = this.showGUI;
         this.atbBar.visible = this.showGUI;
         this.btn_UI_Gear.visible = this.showGUI;
         this.teamMc.visible = this.showGUI;
         this.teamTxt.visible = this.showGUI;
         this.rekrut.visible = this.showGUI;
         this.woodFrame.visible = this.showGUI;
         this.btn_WorldChat.visible = this.showGUI;
         this.btnOption.visible = this.showGUI;
         this.versionTxt.visible = this.showGUI;
         var _loc2_:int = 0;
         while(_loc2_ < this.character_team_players.length)
         {
            this["charMc_" + _loc2_].hpBar.visible = this.showGUI;
            this["charMc_" + _loc2_].rankMC.visible = this.showGUI;
            this["charMc_" + _loc2_].nameTxt.visible = this.showGUI;
            this["charMc_" + _loc2_].targetArrow.visible = this.showGUI;
            this["charMc_" + _loc2_].wood.visible = this.showGUI;
            if(this.character_team_players[_loc2_].hasOwnProperty("pet_model") && this.character_team_players[_loc2_].pet_model != null)
            {
               this["charPetMc_" + _loc2_].hpBar.visible = this.showGUI;
               this["charPetMc_" + _loc2_].txtmc.visible = this.showGUI;
               this["charPetMc_" + _loc2_].wood.visible = this.showGUI;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.enemy_team_players.length)
         {
            this["enemyMc_" + _loc2_].hpBar.visible = this.showGUI;
            this["enemyMc_" + _loc2_].nameTxt.visible = this.showGUI;
            this["enemyMc_" + _loc2_].wood.visible = this.showGUI;
            this["enemyMc_" + _loc2_].targetArrow.visible = this.showGUI;
            this["enemyMc_" + _loc2_].rankMC.visible = !!this.enemy_team_players[_loc2_].isCharacter() ? this.showGUI : false;
            if(this.enemy_team_players[_loc2_].hasOwnProperty("pet_model") && this.enemy_team_players[_loc2_].pet_model != null)
            {
               this["enemyPetMc_" + _loc2_].hpBar.visible = this.showGUI;
               this["enemyPetMc_" + _loc2_].txtmc.visible = this.showGUI;
               this["enemyPetMc_" + _loc2_].wood.visible = this.showGUI;
            }
            _loc2_++;
         }
      }
      
      public function finishClanBattleRes(param1:Object, param2:* = null) : *
      {
         var _loc3_:* = undefined;
         Character.character_recruit_ids = [];
         if(param1 != null && param1.hasOwnProperty("gain"))
         {
            _loc3_ = new ClanBattleResults(this._main);
            _loc3_.updateDisplay(param1);
            this.addChild(_loc3_);
         }
         else
         {
            this._main.getError("");
         }
         this.animation = new Animation(this,false);
         this.animation.gotoAndPlay(1);
         this._main.loader.addChild(this.animation);
         this.eventHandler.addListener(this.animation,Event.REMOVED_FROM_STAGE,this.animationRemoved);
      }
      
      public function finishCrewBattle(param1:* = null, param2:* = null) : *
      {
         if(param1 != null && param1.hasOwnProperty("data"))
         {
            this._main.battleRewards("0","0",[],false,param1);
         }
         else
         {
            this._main.battleRewards("0","0",[],false);
         }
      }
      
      function animationRemoved(param1:Event) : *
      {
         this.eventHandler.removeListener(this.animation,Event.REMOVED_FROM_STAGE,this.animationRemoved);
         this.animation = null;
      }
      
      public function resetGameModes() : *
      {
         var _loc1_:* = null;
         if("_main" in this && this._main != null)
         {
            _loc1_ = this._main;
         }
         else if(BattleManager.MAIN != null)
         {
            _loc1_ = BattleManager.MAIN;
         }
         if(_loc1_)
         {
            _loc1_.is_ninja_tutor_exam_s1c2 = false;
            _loc1_.is_ninja_tutor_exam_s2c2 = false;
            _loc1_.is_ninja_tutor_exam_s3c2 = false;
            _loc1_.is_ninja_tutor_exam_s4c2 = false;
            _loc1_.is_ninja_tutor_exam_s5c2 = false;
            _loc1_.is_ninja_tutor_exam_s6c1 = false;
            _loc1_.is_ninja_tutor_exam_s6c2 = false;
            _loc1_.is_special_jounin_exam_s1c2 = false;
            _loc1_.is_special_jounin_exam_s2c2 = false;
            _loc1_.is_special_jounin_exam_s3c2 = false;
            _loc1_.is_special_jounin_exam_s4c2 = false;
            _loc1_.is_special_jounin_exam_s5c2 = false;
            _loc1_.is_special_jounin_exam_s6c1 = false;
            _loc1_.is_special_jounin_exam_s6c2 = false;
            _loc1_.is_special_jounin_exam_s6c3 = false;
            _loc1_.is_jounin_exam_stage2 = false;
            _loc1_.is_jounin_exam_stage3 = false;
            _loc1_.is_jounin_exam_stage4 = false;
            _loc1_.is_jounin_exam_stage5 = false;
            _loc1_.is_exam_stage2 = false;
            _loc1_.is_exam_stage3 = false;
            _loc1_.is_exam_stage4 = false;
            _loc1_.is_exam_stage5 = false;
         }
         else
         {
            Log.error(this,"resetGameModes: No main object found");
         }
         Character.temp_recruit_ids = [];
         BattleVars.BACKGROUND_CHANGED = false;
         BattleVars.BACKGROUND_CHANGED_CASTER = "";
         Character.is_jounin_stage_4 = false;
         Character.is_jounin_stage_5_1 = false;
         Character.is_jounin_stage_5_2 = false;
         Character.is_anniversary_event = false;
         Character.is_cny_event = false;
         Character.is_hunting_house = false;
         Character.is_friend_berantem = false;
         Character.is_easter_event = false;
         Character.is_valentine_event = false;
         Character.is_thanksgiving_event = false;
         Character.is_salus_event = false;
         Character.is_monster_hunter_event = false;
         Character.is_halloween_event = false;
         Character.is_halloween_special_event = false;
         Character.is_clan_war = false;
         Character.is_eudemon_garden = false;
         Character.is_hard_mode = false;
         Character.encyclopedia_battle.battle = false;
      }
      
      public function backToVillage() : *
      {
         OutfitManager.removeChildsFromMovieClips(this._main.loader);
         this._main.loadVillageAndHUD();
      }
      
      public function backToClan() : *
      {
         OutfitManager.removeChildsFromMovieClips(this._main.loader);
         this._main.loadVillageAndHUD();
         this._main.loadPanel("Panels.ClanVillage");
      }
      
      public function clearCopySkillMC() : *
      {
         if(this.copySkillMC)
         {
            this.copySkillMC.destroy();
            this.copySkillMC = null;
         }
      }
      
      public function clearCombatUI() : *
      {
         this.parent.removeChild(this);
      }
      
      private function setupBattleEffectTooltips() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(this["charMc_" + _loc1_] && this["charMc_" + _loc1_].btn_info)
            {
               this.bindEffectTooltip(this["charMc_" + _loc1_].btn_info,"character",_loc1_);
            }
            if(this["enemyMc_" + _loc1_] && this["enemyMc_" + _loc1_].btn_info)
            {
               this.bindEffectTooltip(this["enemyMc_" + _loc1_].btn_info,"enemy",_loc1_);
            }
            _loc1_++;
         }
      }
      
      private function bindEffectTooltip(param1:*, param2:String, param3:int) : void
      {
         var btn:* = param1;
         var team:String = param2;
         var idx:int = param3;
         this.eventHandler.addListener(btn,MouseEvent.ROLL_OVER,function(param1:MouseEvent):void
         {
            btn.metaData = {"tooltip_text":getEffectTooltipText(team,idx)};
            NinjaSage.showTextDynamicTooltip(param1);
            NinjaSage.tooltip.multiLine = false;
         });
         this.eventHandler.addListener(btn,MouseEvent.ROLL_OUT,function(param1:MouseEvent):void
         {
            NinjaSage.toolTiponOut(param1);
            NinjaSage.tooltip.multiLine = true;
         });
      }
      
      private function getEffectTooltipText(param1:String, param2:int) : String
      {
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc3_:* = param1 == "character" ? this.character_team_players[param2] : this.enemy_team_players[param2];
         if(!_loc3_ || !_loc3_.effects_manager)
         {
            return "No active effects";
         }
         var _loc4_:Array = [];
         var _loc5_:* = _loc3_.effects_manager.dataBuff;
         var _loc6_:* = _loc3_.effects_manager.dataDebuff;
         if(_loc5_)
         {
            for each(_loc7_ in _loc5_)
            {
               if(_loc7_.duration > 0)
               {
                  _loc4_.push("<font color=\"#2e8b57\">" + this.getEffectLine(_loc7_) + "</font>");
               }
            }
         }
         if(_loc6_)
         {
            for each(_loc8_ in _loc6_)
            {
               if(_loc8_.duration > 0)
               {
                  _loc4_.push("<font color=\"#ff0000\">" + this.getEffectLine(_loc8_) + "</font>");
               }
            }
         }
         return _loc4_.length > 0 ? _loc4_.join("\n") : "No active effects";
      }
      
      private function getEffectLine(param1:Object) : String
      {
         var _loc6_:Object = null;
         var _loc2_:String = param1.effect_name || "";
         if(_loc2_ == "")
         {
            if(_loc6_ = Effects.all_buffs[param1.effect] || Effects.all_debuffs[param1.effect])
            {
               _loc2_ = _loc6_.effect_name || "";
            }
         }
         if(_loc2_ == "")
         {
            return String(param1.effect);
         }
         var _loc3_:* = param1.amount != null ? param1.amount : (param1.amount_hp != null ? param1.amount_hp : (param1.amount_cp != null ? param1.amount_cp : null));
         var _loc4_:String = _loc3_ != null && Number(_loc3_) != 0 ? " (" + String(_loc3_) + (param1.calc_type == "percent" ? "%" : "") + ")" : "";
         if(Util.checkInArray(param1.effect,Effects.dont_need_show_duration))
         {
            return _loc2_ + _loc4_;
         }
         var _loc5_:int = param1.duration;
         if(Util.checkInArray(param1.effect,Effects.need_to_show_minus_duration))
         {
            if(param1.hasOwnProperty("shown_duration") && int(param1.shown_duration) > 0)
            {
               _loc5_ = int(param1.shown_duration);
            }
            else
            {
               _loc5_ = Math.max(1,param1.duration - 1);
            }
         }
         return _loc2_ + _loc4_ + " (" + _loc5_ + " Turn)";
      }
      
      public function destroy() : *
      {
         var _loc2_:uint = 0;
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         Log.debug(this,"destroy");
         if(this.pendingTimeouts != null)
         {
            for each(_loc2_ in this.pendingTimeouts)
            {
               clearTimeout(_loc2_);
            }
            this.pendingTimeouts = null;
         }
         GradientText.removeAll();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(this["charMc_" + _loc1_] && this["charMc_" + _loc1_].btn_info)
            {
               NinjaSage.clearDynamicTooltip(this["charMc_" + _loc1_].btn_info);
            }
            if(this["enemyMc_" + _loc1_] && this["enemyMc_" + _loc1_].btn_info)
            {
               NinjaSage.clearDynamicTooltip(this["enemyMc_" + _loc1_].btn_info);
            }
            _loc1_++;
         }
         NinjaSage.tooltip.multiLine = true;
         this.clearCopySkillMC();
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.hideDebugEnemySkillPanel();
         if(this.gear)
         {
            this.gear.destroy();
         }
         if(this.option)
         {
            this.option.destroy();
         }
         if(this.world_chat)
         {
            this.world_chat.destroy();
         }
         this.world_chat = null;
         this.gear = null;
         this.option = null;
         this._main = null;
         this.agility_bar_manager.destroy();
         this.agility_bar_manager = null;
         this.attacker_model = null;
         this.defender_model = null;
         this.battle_stages_fllw = null;
         GF.removeAllChild(this.master_model);
         this.master_model = null;
         if(this.defender_models is Array)
         {
            GF.destroyArray(this.defender_models);
         }
         this.defender_models = null;
         if(this.attacker_models is Array)
         {
            GF.destroyArray(this.attacker_models);
         }
         this.attacker_models = null;
         GF.destroyArray(this.outfits);
         GF.clearArray(this.reset_new_amount_objects);
         GF.clearArray(this.reset_next_turn_objects);
         GF.clearArray(Character.battle_logs);
         GF.destroyArray(this.character_team_players);
         GF.destroyArray(this.enemy_team_players);
         this.reset_new_amount_objects = null;
         this.reset_next_turn_objects = null;
         this.character_team_players = null;
         this.enemy_team_players = null;
         GF.removeAllChild(this.bgHolder);
         GF.removeAllChild(this.actionBar);
         GF.removeAllChild(this.actionBar1);
         GF.removeAllChild(this.actionBar2);
         GF.removeAllChild(this.atbBar);
         GF.removeAllChild(this.char_hpcp);
         GF.removeAllChild(this.charMc_0);
         GF.removeAllChild(this.charMc_1);
         GF.removeAllChild(this.charMc_2);
         GF.removeAllChild(this.charPetMc_0);
         GF.removeAllChild(this.charPetMc_1);
         GF.removeAllChild(this.charPetMc_2);
         GF.removeAllChild(this.enemyMc_0);
         GF.removeAllChild(this.enemyMc_1);
         GF.removeAllChild(this.enemyMc_2);
         GF.removeAllChild(this.enemyPetMc_0);
         GF.removeAllChild(this.enemyPetMc_1);
         GF.removeAllChild(this.enemyPetMc_2);
         GF.removeAllChild(this.scrollDisplayMc_0);
         GF.removeAllChild(this.scrollDisplayMc_1);
         GF.removeAllChild(this.scrollDisplayMc_2);
         GF.removeAllChild(this.atk_turnTimerTxt);
         GF.removeAllChild(this.dh_hint);
         GF.removeAllChild(this.logo);
         GF.removeAllChild(this.senjutsuTransition);
         GF.removeAllChild(this.sushiMc);
         GF.removeAllChild(this.teamMc);
         GF.removeAllChild(this.totalDamageHint);
         GF.removeAllChild(this.woodFrame);
         this.bgHolder = null;
         this.actionBar = null;
         this.actionBar1 = null;
         this.actionBar2 = null;
         this.atbBar = null;
         this.char_hpcp = null;
         this.charMc_0 = null;
         this.charMc_1 = null;
         this.charMc_2 = null;
         this.charPetMc_0 = null;
         this.charPetMc_1 = null;
         this.charPetMc_2 = null;
         this.enemyMc_0 = null;
         this.enemyMc_1 = null;
         this.enemyMc_2 = null;
         this.enemyPetMc_0 = null;
         this.enemyPetMc_1 = null;
         this.enemyPetMc_2 = null;
         this.scrollDisplayMc_0 = null;
         this.scrollDisplayMc_1 = null;
         this.scrollDisplayMc_2 = null;
         this.dh_hint = null;
         this.logo = null;
         this.senjutsuTransition = null;
         this.sushiMc = null;
         this.teamMc = null;
         this.totalDamageHint = null;
         this.woodFrame = null;
         WeaponBuffs.clearCached();
         AccessoryBuffs.clearCached();
         BackItemBuffs.clearCached();
         Character.battle_logs = [];
         this.outfits = null;
         GF.removeAllChild(this);
         BattleTimer.destroy();
         this.atk_turnTimerTxt = null;
         EnemyAI.resetTeamTacticalMemory();
         BattleManager.destroyCombat();
      }
   }
}
