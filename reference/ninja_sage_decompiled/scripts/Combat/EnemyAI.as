package Combat
{
   import flash.utils.getTimer;
   
   public class EnemyAI
   {
      
      public static const TYPE_ATTACK:String = "attack";
      
      public static const TYPE_DEBUFF:String = "debuff";
      
      public static const TYPE_BUFF:String = "buff";
      
      public static const TYPE_PURIFY:String = "purify";
      
      public static const TYPE_RESIST:String = "resist";
      
      public static const TYPE_DISPERSE:String = "disperse";
      
      public static const TYPE_HEAL:String = "heal";
      
      public static const TYPE_STUN:String = "stun";
      
      public static const TYPE_DRAIN:String = "drain";
      
      private static const INTENT_AGGRESSIVE:String = "aggressive";
      
      private static const INTENT_DEFENSIVE:String = "defensive";
      
      private static const INTENT_SETUP:String = "setup";
      
      private static const INTENT_BURST_READY:String = "burst_ready";
      
      private static const INTENT_CONTROL:String = "control";
      
      private static const PERSONALITY_BERSERKER:String = "berserker";
      
      private static const PERSONALITY_GUARDIAN:String = "guardian";
      
      private static const PERSONALITY_TACTICIAN:String = "tactician";
      
      private static const PERSONALITY_TRICKSTER:String = "trickster";
      
      private static const PERSONALITY_HEALER:String = "healer";
      
      public static var ENABLE_AI_LOG:Boolean = false;
      
      public static var ENABLE_AI_PROFILE:Boolean = false;
      
      private static var DEBUG_MANUAL_ACTIONS:Object = {};
      
      private static var TEAM_TACTICAL_MEMORY:Object = {};
      
      private static const MAX_EVALUATED_SKILLS:int = 10;
      
      private static const MAX_EVALUATED_TARGETS:int = 3;
      
      private static const MAX_LOOKAHEAD_CANDIDATES:int = 6;
      
      private static const JITTER_WINDOW:Number = 0.18;
      
      private static const FINISH_HP_RATIO:Number = 0.25;
      
      private static const DAMAGE_BOOST_EFFECTS:Object = {
         "strengthen":true,
         "pet_strengthen":true,
         "strengthen_special":true,
         "combustion":true,
         "power_up":true,
         "stealth":true,
         "rage":true,
         "pet_rage":true,
         "lightning_armor":true,
         "pet_lightning_armor":true,
         "power_up_battle":true,
         "inquisitor":true,
         "kyubi_cloak":true,
         "shukaku_blessing":true,
         "tolerance":true,
         "solar_might":true,
         "extreme_mode":true,
         "senjutsu_strengthen":true,
         "sage_mode":true,
         "taijutsu_strengthen":true,
         "domain_expansion":true,
         "rampage":true
      };
      
      private static const HIGH_VALUE_ENEMY_BUFFS:Object = {
         "debuff_resist":true,
         "pet_debuff_resist":true,
         "bless":true,
         "flexible":true,
         "pet_flexible":true,
         "strengthen":true,
         "strengthen_special":true,
         "rage":true,
         "pet_rage":true,
         "stealth":true,
         "lightning_armor":true,
         "pet_lightning_armor":true,
         "sage_mode":true,
         "extreme_mode":true,
         "unyielding":true,
         "unyielding_soul":true,
         "invincible":true,
         "boundless":true,
         "domain_expansion":true,
         "cp_shield":true,
         "pet_cp_shield":true
      };
      
      private static const DEFENSIVE_BUFF_EFFECTS:Object = {
         "protection":true,
         "pet_protection":true,
         "plus_protection":true,
         "pet_plus_protection":true,
         "guard":true,
         "pet_guard":true,
         "invincible":true,
         "debuff_resist":true,
         "pet_debuff_resist":true,
         "bless":true,
         "immunity":true,
         "flexible":true,
         "pet_flexible":true,
         "serene_mind":true,
         "pet_serene_mind":true,
         "reactive_force":true,
         "cp_shield":true,
         "pet_cp_shield":true,
         "damage_absorption":true,
         "pet_damage_absorption":true,
         "fire_wall":true,
         "pet_fire_wall":true,
         "unyielding":true,
         "unyielding_soul":true,
         "cannot_reduced_cp":true,
         "bleeding_protection":true,
         "boundless":true
      };
      
      private static const OFFENSIVE_DEBUFF_EFFECTS:Object = {
         "weaken":true,
         "pet_weaken":true,
         "weak_body":true,
         "vulnerable":true,
         "expose_defence":true,
         "dark_curse":true,
         "demonic_curse":true,
         "darkness":true,
         "pet_darkness":true,
         "dismantle":true,
         "pet_dismantle":true,
         "negate":true,
         "conduction":true,
         "pet_conduction":true,
         "decrease_critical_chance":true,
         "decrease_critical_damage":true,
         "decrease_purify_active":true,
         "decrease_combustion_chance":true,
         "meridian_injury":true
      };
      
      private static const TEMPO_DEBUFF_EFFECTS:Object = {
         "blind":true,
         "pet_blind":true,
         "slow":true,
         "pet_slow":true,
         "slow_oil":true,
         "disorient":true,
         "disorient_2":true,
         "pet_disorient":true,
         "distract":true,
         "pet_distract":true,
         "ecstasy":true,
         "pet_ecstasy":true,
         "charge_disable":true,
         "pet_charge_disable":true,
         "double_cp_consumption":true,
         "oblivion":true,
         "pet_oblivion":true,
         "random_add_cooldown":true,
         "pet_random_add_cooldown":true,
         "add_cooldown":true,
         "add_cooldown_player":true,
         "decrease_charge":true,
         "meridian_cut_off":true
      };
      
      private static const RESOURCE_DEBUFF_EFFECTS:Object = {
         "decrease_max_cp":true,
         "instant_reduce_cp":true,
         "reduceCP":true,
         "reduce_cp":true,
         "reduce_hp_cp":true,
         "insta_reduce_max_cp":true,
         "insta_reduce_max_hpcp":true,
         "current_cp_drain":true,
         "cp_drain":true,
         "drain_cp":true,
         "chakra_burn":true,
         "absorb_cp":true,
         "weapon_attack_penalty":true
      };
      
      private static const VULNERABILITY_EFFECTS:Object = {
         "vulnerable":true,
         "expose_defence":true,
         "exposed":true,
         "defense_down":true,
         "defence_down":true,
         "weak_body":true,
         "weaken":true,
         "pet_weaken":true,
         "dark_curse":true,
         "demonic_curse":true,
         "dismantle":true,
         "pet_dismantle":true,
         "negate":true,
         "conduction":true,
         "pet_conduction":true
      };
      
      private static const EFFECT_TYPE_MAP:Object = {
         "purify":{
            "purify":true,
            "sensation":true,
            "debuff_clear":true
         },
         "buff":{
            "protection":true,
            "pet_protection":true,
            "plus_protection":true,
            "pet_plus_protection":true,
            "guard":true,
            "pet_guard":true,
            "invincible":true,
            "debuff_resist":true,
            "pet_debuff_resist":true,
            "debuff_resistance":true,
            "bless":true,
            "resist":true,
            "immunity":true,
            "strengthen":true,
            "pet_strengthen":true,
            "strengthen_special":true,
            "power_up":true,
            "regeneration":true,
            "pet_regeneration":true,
            "restoration":true,
            "pet_restoration":true,
            "peace":true,
            "pet_peace":true,
            "reflexes":true,
            "pet_frenzy":true,
            "attention":true,
            "pet_attention":true,
            "toad_attention":true,
            "concentration":true,
            "pet_concentration":true,
            "toad_concentration":true,
            "energize":true,
            "pet_energize":true,
            "flexible":true,
            "pet_flexible":true,
            "serene_mind":true,
            "pet_serene_mind":true,
            "reactive_force":true,
            "lightning_armor":true,
            "pet_lightning_armor":true,
            "stealth":true,
            "increase_charge_master":true,
            "instant_cp_recover":true,
            "pet_reduce_cd":true,
            "pet_ocean_atmosphere":true,
            "ocean_atmosphere":true,
            "reduce_cp_consumption":true,
            "excitation":true,
            "pet_excitation":true,
            "boundless":true,
            "cp_shield":true,
            "pet_cp_shield":true,
            "pet_mortal":true,
            "bloodfeed":true,
            "pet_bloodfeed":true,
            "bloodlust":true,
            "pet_bloodlust":true,
            "damage_absorption":true,
            "pet_damage_absorption":true,
            "fire_wall":true,
            "pet_fire_wall":true,
            "increase_agility":true,
            "pet_oil_bottle":true,
            "pet_reduce_cd_random":true,
            "pet_stubborn_recover_cp":true,
            "rage":true,
            "pet_rage":true,
            "kira_kuin":true,
            "sage_mode":true,
            "domain_expansion":true
         },
         "resist":{
            "debuff_resistance":true,
            "debuff_resist":true,
            "pet_debuff_resist":true,
            "bless":true,
            "resist":true,
            "immunity":true
         },
         "disperse":{
            "disperse":true,
            "disperse_all":true,
            "self_disperse_all":true
         },
         "heal":{
            "heal":true,
            "pet_heal":true,
            "health_regen":true,
            "regeneration":true,
            "pet_regeneration":true,
            "regenHP":true,
            "instant_hp_recover":true,
            "recover_hp_cp":true,
            "recover_cp_hp":true,
            "restoration":true,
            "pet_restoration":true
         },
         "stun":{
            "stun":true,
            "pet_stun":true,
            "locked":true,
            "lock":true,
            "sleep":true,
            "pet_sleep":true,
            "internal_injury":true,
            "acupuncture":true,
            "restriction":true,
            "pet_restriction":true,
            "chaos":true,
            "pet_chaos":true,
            "prison":true,
            "pet_prison":true,
            "frozen":true,
            "pet_frozen":true,
            "freeze":true,
            "chill":true,
            "petrify":true,
            "pet_petrify":true,
            "toxic_tooth":true,
            "meridian_seal":true,
            "pet_meridian_seal":true,
            "fear":true,
            "pet_fear":true,
            "numb":true,
            "pet_numb":true,
            "time_stop":true,
            "barrier":true
         },
         "drain":{
            "cp_drain":true,
            "pet_cp_drain":true,
            "current_cp_drain":true,
            "drain_cp":true,
            "drain_cp_with_attack":true,
            "drain_cp_stun":true,
            "drain_cp_injury":true,
            "hp_drain":true,
            "pet_hp_drain":true,
            "current_hp_drain":true,
            "drain_hp":true,
            "drain_hp_with_attack":true,
            "insta_drain_hp":true,
            "insta_drain_cp":true,
            "pet_drain_HpCp":true,
            "drain_HpCp":true,
            "chakra_burn":true,
            "absorb_cp":true,
            "drain_all":true,
            "instant_reduce_hp":true,
            "instant_reduce_cp":true,
            "insta_reduce_curr_hp":true,
            "insta_reduce_max_hp":true,
            "insta_reduce_max_cp":true,
            "insta_reduce_max_hpcp":true,
            "reduce_hp":true,
            "reduceHP":true,
            "reduce_hp_cp":true,
            "reduceCP":true,
            "reduce_cp":true
         },
         "debuff":{
            "bleeding":true,
            "pet_bleeding":true,
            "ultra_bleeding":true,
            "burn":true,
            "burning":true,
            "ultra_burning":true,
            "pet_burn":true,
            "poison":true,
            "flaming":true,
            "blaze":true,
            "burningX":true,
            "frostbite":true,
            "plague":true,
            "dark_curse":true,
            "demonic_curse":true,
            "darkness":true,
            "pet_darkness":true,
            "weaken":true,
            "pet_weaken":true,
            "weak_body":true,
            "vulnerable":true,
            "expose_defence":true,
            "conduction":true,
            "pet_conduction":true,
            "distract":true,
            "pet_distract":true,
            "ecstasy":true,
            "pet_ecstasy":true,
            "covid":true,
            "pet_flame_eater":true,
            "blind":true,
            "pet_blind":true,
            "slow":true,
            "pet_slow":true,
            "slow_oil":true,
            "disorient":true,
            "disorient_2":true,
            "pet_disorient":true,
            "dismantle":true,
            "pet_dismantle":true,
            "negate":true,
            "muddy":true,
            "charge_disable":true,
            "pet_charge_disable":true,
            "double_cp_consumption":true,
            "oblivion":true,
            "pet_oblivion":true,
            "random_add_cooldown":true,
            "pet_random_add_cooldown":true,
            "add_cooldown":true,
            "add_cooldown_player":true,
            "decrease_charge":true,
            "meridian_cut_off":true,
            "meridian_injury":true,
            "decrease_max_cp":true,
            "decrease_critical_chance":true,
            "decrease_critical_damage":true,
            "decrease_purify_active":true,
            "decrease_combustion_chance":true,
            "weapon_attack_penalty":true
         }
      };
       
      
      public var lastDecisionReport:Object;
      
      public var evaluatedSkillCount:int;
      
      public var evaluatedTargetCount:int;
      
      public var lookaheadEvaluationCount:int;
      
      public var decisionTimeMs:int;
      
      private var skillQueryCache:Object;
      
      private var usedSkillCounts:Object;
      
      private var lastSkillKey:String;
      
      private var previousSelfHP:Number;
      
      private var previousTargetHP:Number;
      
      private var previousTargetKey:String;
      
      private var decisionTurn:int;
      
      private var currentTargetModel:Object;
      
      private var decisionStartMs:int;
      
      private var plannedTarget:String;
      
      private var plannedSkill:String;
      
      private var plannedIntent:String;
      
      private var lastSetupTarget:String;
      
      private var turnsSinceSetup:int;
      
      private var currentIntent:String;
      
      private var currentPersonality:String;
      
      private var followedPreviousPlan:Boolean;
      
      private var planAbandonReason:String;
      
      public function EnemyAI()
      {
         super();
         this.skillQueryCache = {};
         this.usedSkillCounts = {};
         this.lastSkillKey = null;
         this.previousSelfHP = -1;
         this.previousTargetHP = -1;
         this.previousTargetKey = null;
         this.decisionTurn = 0;
         this.currentTargetModel = null;
         this.lastDecisionReport = null;
         this.evaluatedSkillCount = 0;
         this.evaluatedTargetCount = 0;
         this.lookaheadEvaluationCount = 0;
         this.decisionTimeMs = 0;
         this.decisionStartMs = 0;
         this.plannedTarget = null;
         this.plannedSkill = null;
         this.plannedIntent = null;
         this.lastSetupTarget = null;
         this.turnsSinceSetup = 99;
         this.currentIntent = INTENT_AGGRESSIVE;
         this.currentPersonality = PERSONALITY_TACTICIAN;
         this.followedPreviousPlan = false;
         this.planAbandonReason = "";
      }
      
      public static function hasDebugManualControl(param1:Object) : Boolean
      {
         return false;
      }
      
      public static function setDebugManualAction(param1:Object, param2:int, param3:int, param4:Boolean = false) : void
      {
         if(!hasDebugManualControl(param1))
         {
            return;
         }
         DEBUG_MANUAL_ACTIONS[getDebugManualKey(param1)] = {
            "index":param2,
            "target":param3,
            "is_friendly_target":param4
         };
      }
      
      private static function consumeDebugManualAction(param1:Object) : Object
      {
         if(!hasDebugManualControl(param1))
         {
            return null;
         }
         var _loc2_:String = getDebugManualKey(param1);
         if(!DEBUG_MANUAL_ACTIONS.hasOwnProperty(_loc2_))
         {
            return null;
         }
         var _loc3_:Object = DEBUG_MANUAL_ACTIONS[_loc2_];
         delete DEBUG_MANUAL_ACTIONS[_loc2_];
         return _loc3_;
      }
      
      private static function getDebugManualKey(param1:Object) : String
      {
         if(param1 == null)
         {
            return "";
         }
         var _loc2_:String = !!param1.hasOwnProperty("player_team") ? String(param1.player_team) : "";
         var _loc3_:String = !!param1.hasOwnProperty("player_number") ? String(param1.player_number) : "0";
         return _loc2_ + ":" + _loc3_;
      }
      
      public static function resetTeamTacticalMemory() : void
      {
         TEAM_TACTICAL_MEMORY = {};
         DEBUG_MANUAL_ACTIONS = {};
      }
      
      public function decideAction(param1:Object, param2:Array, param3:Array = null) : Object
      {
         this.resetPerformanceCounters();
         this.resetSkillQueryCache();
         var _loc4_:Object;
         if((_loc4_ = consumeDebugManualAction(param1)) != null)
         {
            return this.finalizeAction({
               "type":-1,
               "index":int(_loc4_.index),
               "is_aoe":false
            },int(_loc4_.target),Boolean(_loc4_.is_friendly_target),param1,"Manual debug Encyclopedia control");
         }
         this.performForcedDotPurify(param1);
         var _loc5_:Number = param1.health_manager.getCurrentHP() / param1.health_manager.getMaxHP();
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         if(param3)
         {
            _loc6_ = this.analyzeTeamState(param3);
         }
         if(_loc7_ = this.selectTeamSurvivalAction(param1,param3,_loc6_))
         {
            return _loc7_;
         }
         if(_loc7_ = this.selectTeamPurifyAction(param1,param3,_loc6_))
         {
            return _loc7_;
         }
         if(_loc7_ = this.selectSelfSurvivalAction(param1,_loc5_))
         {
            return _loc7_;
         }
         var _loc8_:Object;
         var _loc9_:Object = (_loc8_ = this.findRuthlessTarget(param1,param2)).model;
         var _loc10_:int = _loc8_.index;
         if(!_loc9_)
         {
            this.finishPerformanceCounters();
            return this.logActionDecision(param1,this.selectBestMove(param1),"Tidak ada target valid, pakai fallback ofensif");
         }
         this.currentTargetModel = _loc9_;
         var _loc11_:Object = this.analyzeTargetState(_loc9_);
         var _loc12_:Object = this.buildCombatProfile(param1,_loc9_,_loc11_);
         this.currentPersonality = this.resolvePersonality(param1);
         this.currentIntent = this.selectIntent(_loc12_,_loc11_,_loc6_);
         this.preparePlanningMemory(_loc9_);
         if(_loc7_ = this.selectUtilityPlannedAction(param1,_loc9_,_loc11_,_loc10_,param3,_loc6_,_loc12_))
         {
            return _loc7_;
         }
         return this.finalizeAction(this.selectBestMove(param1,_loc12_),_loc10_,false,param1,"Tidak ada kondisi khusus, pakai serangan ofensif terbaik");
      }
      
      private function selectTeamSurvivalAction(param1:Object, param2:Array, param3:Object) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(!param2 || param3 == null)
         {
            return null;
         }
         if(param3.priority_hp < 0.35)
         {
            if(_loc4_ = this.findReadySkillByType(param1,TYPE_HEAL,false,"master"))
            {
               return this.finalizeAction(_loc4_,0,true,param1,"Menyelamatkan master/leader yang HP-nya kritis");
            }
         }
         if(param3.lowest_hp < 0.3)
         {
            if(_loc5_ = this.findReadySkillByType(param1,TYPE_HEAL,true))
            {
               return this.finalizeAction(_loc5_,this.getSelfTargetIndex(param1),true,param1,"Memilih heal area karena HP tim rendah");
            }
         }
         return null;
      }
      
      private function selectTeamPurifyAction(param1:Object, param2:Array, param3:Object) : Object
      {
         if(!param2 || param3 == null || !param3.has_disabled)
         {
            return null;
         }
         var _loc4_:Object;
         if(_loc4_ = this.findReadySkillByType(param1,TYPE_PURIFY,true))
         {
            return this.finalizeAction(_loc4_,this.getSelfTargetIndex(param1),true,param1,"Membersihkan debuff tim dengan purify area");
         }
         return null;
      }
      
      private function selectSelfSurvivalAction(param1:Object, param2:Number) : Object
      {
         if(param2 >= 0.25)
         {
            return null;
         }
         var _loc3_:Object = this.findReadySkillByType(param1,TYPE_HEAL,false,"self");
         if(_loc3_)
         {
            return this.finalizeAction(_loc3_,this.getSelfTargetIndex(param1),true,param1,"HP diri sendiri kritis, pakai heal");
         }
         return null;
      }
      
      private function performForcedDotPurify(param1:Object) : void
      {
         var _loc2_:Object = this.analyzeDotPressure(param1);
         if(!_loc2_.force_purify)
         {
            return;
         }
         if(param1 != null && param1.effects_manager != null)
         {
            param1.effects_manager.purifyPlayer("Purify");
         }
      }
      
      private function selectUtilityPlannedAction(param1:Object, param2:Object, param3:Object, param4:int, param5:Array, param6:Object, param7:Object) : Object
      {
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc8_:Array = this.buildActionCandidates(param1,param7);
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Array = [];
         var _loc14_:Array = !!ENABLE_AI_LOG ? [] : null;
         var _loc15_:int = 0;
         while(_loc15_ < _loc8_.length)
         {
            _loc19_ = _loc8_[_loc15_];
            ++this.evaluatedSkillCount;
            _loc20_ = this.evaluateSkillAction(param1,_loc19_,param2,param3,param5,param6,param7);
            _loc13_.push(_loc20_);
            if(_loc14_ != null)
            {
               _loc14_.push(this.buildDebugReport(_loc20_));
            }
            if((_loc10_ = this.chooseBestOverride(_loc10_,this.getLethalOverride(param1,param2,_loc20_))) != null && !ENABLE_AI_LOG)
            {
               break;
            }
            _loc11_ = this.chooseBestOverride(_loc11_,this.getSurvivalOverride(param1,param2,_loc20_,param7));
            _loc12_ = this.chooseBestOverride(_loc12_,this.getSetupKillOverride(param1,param2,param3,_loc20_,param7));
            if(_loc9_ == null || _loc20_.score > _loc9_.score || _loc20_.score == _loc9_.score && _loc20_.tie_breaker < _loc9_.tie_breaker)
            {
               _loc9_ = _loc20_;
            }
            _loc15_++;
         }
         if(_loc10_ != null)
         {
            _loc9_ = _loc10_;
         }
         else if(_loc11_ != null)
         {
            _loc9_ = _loc11_;
         }
         else if(_loc12_ != null)
         {
            _loc9_ = _loc12_;
         }
         else
         {
            _loc9_ = this.pickJitteredBest(_loc13_,_loc9_);
         }
         if(_loc9_ == null)
         {
            this.finishPerformanceCounters();
            this.lastDecisionReport = !!this.shouldKeepDebugReport() ? {
               "turn":this.decisionTurn + 1,
               "scores":_loc14_,
               "selected":null,
               "overrides":{
                  "lethal":(_loc10_ != null ? _loc10_.override_score : 0),
                  "survival":(_loc11_ != null ? _loc11_.override_score : 0),
                  "setup":(_loc12_ != null ? _loc12_.override_score : 0)
               },
               "profile":this.buildPerformanceReport()
            } : null;
            return null;
         }
         this.finishPerformanceCounters();
         this.lastDecisionReport = !!this.shouldKeepDebugReport() ? {
            "turn":this.decisionTurn + 1,
            "scores":_loc14_,
            "selected":this.buildDebugReport(_loc9_),
            "overrides":{
               "lethal":(_loc10_ != null ? _loc10_.override_score : 0),
               "survival":(_loc11_ != null ? _loc11_.override_score : 0),
               "setup":(_loc12_ != null ? _loc12_.override_score : 0)
            },
            "profile":this.buildPerformanceReport()
         } : null;
         var _loc16_:Object = {
            "type":_loc9_.action.type,
            "index":_loc9_.action.index,
            "is_aoe":_loc9_.action.is_aoe
         };
         var _loc18_:int = !!(_loc17_ = Boolean(this.isFriendlyAction(_loc9_.metadata))) ? int(this.selectFriendlyTargetIndex(_loc9_.metadata,param5,param6,param1)) : int(param4);
         this.updatePlanningTelemetry(_loc9_,param2);
         return this.finalizeAction(_loc16_,_loc18_,_loc17_,param1,_loc9_.reason);
      }
      
      private function pickJitteredBest(param1:Array, param2:Object) : Object
      {
         var _loc12_:Object = null;
         var _loc13_:Number = NaN;
         if(param1 == null || param1.length <= 1)
         {
            return param2;
         }
         var _loc3_:Number = param2 != null ? Number(Number(param2.score)) : Number(Number.NEGATIVE_INFINITY);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_] != null && Number(param1[_loc4_].score) > _loc3_)
            {
               _loc3_ = Number(param1[_loc4_].score);
            }
            _loc4_++;
         }
         if(_loc3_ <= 0)
         {
            return param2;
         }
         var _loc5_:Number = _loc3_ * (1 - JITTER_WINDOW);
         var _loc6_:Array = [];
         var _loc7_:Number = 0;
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            if((_loc12_ = param1[_loc8_]) != null && Number(_loc12_.score) >= _loc5_)
            {
               _loc13_ = Number(_loc12_.score) - _loc5_ + 1;
               _loc6_.push({
                  "ev":_loc12_,
                  "weight":_loc13_
               });
               _loc7_ += _loc13_;
            }
            _loc8_++;
         }
         if(_loc6_.length <= 1 || _loc7_ <= 0)
         {
            return param2;
         }
         var _loc9_:Number = Math.random() * _loc7_;
         var _loc10_:Number = 0;
         var _loc11_:int = 0;
         while(_loc11_ < _loc6_.length)
         {
            _loc10_ += _loc6_[_loc11_].weight;
            if(_loc9_ < _loc10_)
            {
               return _loc6_[_loc11_].ev;
            }
            _loc11_++;
         }
         return param2;
      }
      
      private function chooseBestOverride(param1:Object, param2:Object) : Object
      {
         if(param2 == null)
         {
            return param1;
         }
         if(param1 == null || param2.override_score > param1.override_score || param2.override_score == param1.override_score && param2.tie_breaker < param1.tie_breaker)
         {
            return param2;
         }
         return param1;
      }
      
      private function getLethalOverride(param1:Object, param2:Object, param3:Object) : Object
      {
         if(param3 == null || this.isFriendlyAction(param3.metadata) || !this.canKillTarget(param1,param3.action,param2))
         {
            return null;
         }
         var _loc4_:Number = param2.health_manager != null ? Number(param2.health_manager.getCurrentHP()) : Number(0);
         var _loc5_:Number = Math.max(0,param3.actual_damage - _loc4_);
         param3.override_score = 100000 - _loc5_ - param3.metadata.cooldown * 10;
         param3.reason = !!ENABLE_AI_LOG ? "LETHAL override | damage:" + Math.round(param3.actual_damage) + " targetHP:" + Math.round(_loc4_) : "";
         return param3;
      }
      
      private function getSurvivalOverride(param1:Object, param2:Object, param3:Object, param4:Object) : Object
      {
         if(param3 == null || param4.self_hp_ratio >= 0.25)
         {
            return null;
         }
         var _loc5_:Object = param3.metadata;
         var _loc6_:Number = 0;
         if(_loc5_.tag_map.healing)
         {
            _loc6_ = 900 + this.scoreUtilityEffects(_loc5_.effects,param4);
         }
         else if(this.hasDefensiveMetadataEffect(_loc5_) && !this.hasActiveMetadataEffect(param1,_loc5_))
         {
            _loc6_ = 760 + this.scoreUtilityEffects(_loc5_.effects,param4);
         }
         else if(_loc5_.tag_map.control && !param4.enemy_disabled && !param4.enemy_protected)
         {
            _loc6_ = 680 + this.scoreUtilityEffects(_loc5_.effects,param4);
         }
         else if(_loc5_.tag_map.purify && param4.self_debuff_count > 0)
         {
            _loc6_ = 620 + param4.self_debuff_count * 50;
         }
         if(_loc6_ <= 0)
         {
            return null;
         }
         param3.override_score = _loc6_ - this.getRepeatPenalty(this.getActionKey(param3.action.type,param3.action.index));
         param3.reason = !!ENABLE_AI_LOG ? "SURVIVAL override | selfHP:" + Math.round(param4.self_hp_ratio * 100) + "% score:" + Math.round(param3.override_score) : "";
         return param3;
      }
      
      private function getSetupKillOverride(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object) : Object
      {
         if(param4 == null || !this.canKillNextTurnWithSetup(param1,param4.action,param4.metadata,param2,param3,param5))
         {
            return null;
         }
         param4.setup_kill_damage = param4.action.setup_kill_damage;
         param4.override_score = 50000 + param4.lookahead - param4.risk;
         param4.reason = !!ENABLE_AI_LOG ? "SETUP-KILL override | nextTurnDamage:" + Math.round(param4.setup_kill_damage) + " targetHP:" + Math.round(param3.current_hp) : "";
         return param4;
      }
      
      private function buildDebugReport(param1:Object) : Object
      {
         return {
            "action":param1.action,
            "score":Math.round(param1.score),
            "actual_damage":Math.round(param1.actual_damage),
            "override_score":(!!param1.hasOwnProperty("override_score") ? Math.round(param1.override_score) : 0),
            "tags":param1.metadata.tags,
            "intent":param1.intent,
            "personality":param1.personality,
            "breakdown":param1.breakdown,
            "reason":param1.reason
         };
      }
      
      private function buildActionCandidates(param1:Object, param2:Object) : Array
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc3_:Array = [];
         if(param1.hasOwnProperty("actions_manager") && param1.actions_manager != null)
         {
            _loc6_ = param1.actions_manager;
            this.appendCharacterCandidates(_loc3_,param1,_loc6_.character_skills_mc,2,param2);
            this.appendCharacterCandidates(_loc3_,param1,_loc6_.character_talent_skills_mc,3,param2);
            this.appendCharacterCandidates(_loc3_,param1,_loc6_.character_senjutsu_skills_mc,4,param2);
            if(_loc6_.class_skill && _loc6_.class_skill.getCurrentCooldown() <= 0 && this.canAffordCharacterSkill(param1,_loc6_.class_skill.skill_info,5))
            {
               this.addCandidateByPreScore(_loc3_,{
                  "type":5,
                  "index":0,
                  "skill":_loc6_.class_skill.skill_info,
                  "is_aoe":Boolean(_loc6_.class_skill.skill_info.is_aoe) || Boolean(_loc6_.class_skill.skill_info.multi_hit),
                  "tie_breaker":5000
               },param2);
            }
            if(this.canCharge(param1) && param2.self_cp_ratio < 0.35)
            {
               this.addCandidateByPreScore(_loc3_,{
                  "type":6,
                  "index":0,
                  "skill":{
                     "effects":[],
                     "dmg":0,
                     "cooldown":0
                  },
                  "is_aoe":false,
                  "tie_breaker":6000
               },param2);
            }
            this.sortCandidatesByPreScore(_loc3_);
            return _loc3_;
         }
         var _loc4_:Object;
         if((_loc4_ = this.getUnitInfo(param1)) == null || _loc4_.attacks == null)
         {
            return _loc3_;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.attacks.length)
         {
            _loc7_ = _loc4_.attacks[_loc5_];
            _loc8_ = _loc4_.curr_skill_cooldowns && _loc5_ < _loc4_.curr_skill_cooldowns.length ? int(int(_loc4_.curr_skill_cooldowns[_loc5_])) : 0;
            if(_loc7_ != null && _loc8_ <= 0 && this.isUnitSkillAvailable(_loc4_,_loc5_))
            {
               this.addCandidateByPreScore(_loc3_,{
                  "type":-1,
                  "index":_loc5_,
                  "skill":_loc7_,
                  "is_aoe":Boolean(_loc7_.multi_hit) || Boolean(_loc7_.is_aoe),
                  "tie_breaker":_loc5_
               },param2);
            }
            _loc5_++;
         }
         this.sortCandidatesByPreScore(_loc3_);
         return _loc3_;
      }
      
      private function appendCharacterCandidates(param1:Array, param2:Object, param3:Array, param4:int, param5:Object) : void
      {
         var _loc7_:Object = null;
         if(!param3)
         {
            return;
         }
         var _loc6_:int = 0;
         while(_loc6_ < param3.length)
         {
            if((_loc7_ = param3[_loc6_]) && _loc7_.getCurrentCooldown() <= 0 && this.canAffordCharacterSkill(param2,_loc7_.skill_info,param4))
            {
               this.addCandidateByPreScore(param1,{
                  "type":param4,
                  "index":_loc6_,
                  "skill":_loc7_.skill_info,
                  "is_aoe":Boolean(_loc7_.skill_info.is_aoe) || Boolean(_loc7_.skill_info.multi_hit),
                  "tie_breaker":param4 * 1000 + _loc6_
               },param5);
            }
            _loc6_++;
         }
      }
      
      private function addCandidateByPreScore(param1:Array, param2:Object, param3:Object) : void
      {
         if(param2 == null)
         {
            return;
         }
         param2.pre_score = this.scoreCandidatePrepass(param2,param3);
         if(param1.length < MAX_EVALUATED_SKILLS)
         {
            param1.push(param2);
            return;
         }
         var _loc4_:int = 0;
         var _loc5_:Object = param1[0];
         var _loc6_:int = 1;
         while(_loc6_ < param1.length)
         {
            if(param1[_loc6_].pre_score < _loc5_.pre_score || param1[_loc6_].pre_score == _loc5_.pre_score && param1[_loc6_].tie_breaker > _loc5_.tie_breaker)
            {
               _loc5_ = param1[_loc6_];
               _loc4_ = _loc6_;
            }
            _loc6_++;
         }
         if(param2.pre_score > _loc5_.pre_score || param2.pre_score == _loc5_.pre_score && param2.tie_breaker < _loc5_.tie_breaker)
         {
            param1[_loc4_] = param2;
         }
      }
      
      private function scoreCandidatePrepass(param1:Object, param2:Object) : Number
      {
         var _loc3_:Object = this.buildSkillMetadata(param1.skill);
         var _loc4_:Number = _loc3_.damage * 80;
         if(param1.type == 6)
         {
            _loc4_ += param2 != null ? (1 - param2.self_cp_ratio) * 180 : 60;
         }
         if(param1.is_aoe)
         {
            _loc4_ += 25;
         }
         if(_loc3_.tag_map.finisher)
         {
            _loc4_ += param2 != null && param2.target_hp_ratio <= 0.4 ? 120 : 25;
         }
         if(_loc3_.tag_map.healing)
         {
            _loc4_ += param2 != null ? (1 - param2.self_hp_ratio) * 220 : 60;
         }
         if(_loc3_.tag_map.purify)
         {
            _loc4_ += param2 != null ? param2.self_debuff_count * 65 : 35;
         }
         if(_loc3_.tag_map.disperse)
         {
            _loc4_ += param2 != null ? param2.enemy_buff_count * 35 : 30;
         }
         if(_loc3_.tag_map.control)
         {
            _loc4_ += param2 != null && !param2.enemy_disabled && !param2.enemy_protected ? 95 : 20;
         }
         if(_loc3_.tag_map.buff || _loc3_.tag_map.setup)
         {
            _loc4_ += this.scoreCheapSetupValue(_loc3_,param2);
         }
         if(_loc3_.tag_map.debuff)
         {
            _loc4_ += param2 != null && !param2.enemy_protected ? 85 : 20;
         }
         if(this.hasDefensiveMetadataEffect(_loc3_))
         {
            _loc4_ += param2 != null && param2.self_hp_ratio < 0.45 ? 95 : 35;
         }
         return Number((_loc4_ -= this.getRepeatPenalty(this.getActionKey(param1.type,param1.index)) * 0.5) - param1.tie_breaker * 0.001);
      }
      
      private function scoreCheapSetupValue(param1:Object, param2:Object) : Number
      {
         var _loc3_:Number = 35;
         if(this.hasDamageBoostMetadataEffect(param1))
         {
            _loc3_ += 80;
         }
         if(param1.next_skill >= 0)
         {
            _loc3_ += 65;
         }
         if(param2 != null && param2.has_damage_boost && !this.hasDefensiveMetadataEffect(param1))
         {
            _loc3_ -= 45;
         }
         if(param2 != null && param2.self_hp_ratio < 0.25 && !this.hasDefensiveMetadataEffect(param1) && !param1.tag_map.healing)
         {
            _loc3_ -= 70;
         }
         return _loc3_;
      }
      
      private function sortCandidatesByPreScore(param1:Array) : void
      {
         if(param1 == null || param1.length < 2)
         {
            return;
         }
         param1.sort(this.compareCandidatePreScore);
      }
      
      private function compareCandidatePreScore(param1:Object, param2:Object) : int
      {
         if(param1.pre_score > param2.pre_score)
         {
            return -1;
         }
         if(param1.pre_score < param2.pre_score)
         {
            return 1;
         }
         if(param1.tie_breaker < param2.tie_breaker)
         {
            return -1;
         }
         if(param1.tie_breaker > param2.tie_breaker)
         {
            return 1;
         }
         return 0;
      }
      
      private function isUnitSkillAvailable(param1:Object, param2:int) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.hasOwnProperty("skills_available") && param1.skills_available != null && param2 < param1.skills_available.length)
         {
            return int(param1.skills_available[param2]) != 0;
         }
         return true;
      }
      
      private function evaluateSkillAction(param1:Object, param2:Object, param3:Object, param4:Object, param5:Array, param6:Object, param7:Object) : Object
      {
         var _loc8_:Object = this.buildSkillMetadata(param2.skill);
         var _loc9_:Number = this.estimateCandidateDamage(param2.skill);
         var _loc10_:Number = this.estimateActualDamage(param1,param2.skill,param3);
         var _loc11_:Number = this.scoreImmediateValue(param1,param2,_loc8_,_loc9_,_loc10_,param7,param4,param3);
         var _loc12_:Number = this.scoreStrategicValue(param1,param3,_loc8_,param7,param4,param2);
         var _loc13_:Number = this.scoreComboPotential(param1,param2,_loc8_,param7,param3,param4);
         var _loc14_:Number = this.scoreTimingValue(param2,_loc8_,param7,param4);
         var _loc15_:Number = this.scoreRiskValue(param1,param3,param2,_loc8_,_loc9_,param7,param4);
         var _loc16_:Number = this.estimateLookaheadValue(param1,param2,_loc8_,param7,param3);
         var _loc17_:Number = this.scoreBurstWindow(param1,param2,_loc8_,_loc10_,param4,param3);
         var _loc18_:Number = this.scoreExpectedValue(param1,param2,_loc8_,_loc10_,param7,param4,param3);
         var _loc19_:Number = this.scoreTwoTurnLookahead(param1,param2,_loc8_,param7,param3,param4);
         var _loc20_:Number = this.scoreResourcePlanning(param1,param2,_loc8_,param7,param3);
         var _loc21_:Number = this.scoreTeamCoordination(param1,param2,_loc8_,param3,param4,param5,param6,param7);
         var _loc22_:Number = this.scoreSurvivalRisk(param1,_loc8_,param7,param3);
         var _loc23_:Number = this.scoreIntentAlignment(_loc8_,param7,param4);
         var _loc24_:Number = this.scorePersonalityModifier(_loc8_,param7,param4);
         var _loc25_:Number = this.scorePlanningMemory(param1,param2,_loc8_,param3,param4);
         var _loc26_:Number = this.scoreAntiStupidRules(param1,param2,_loc8_,param3,param4,param7);
         var _loc27_:Number = (_loc27_ = _loc11_ + _loc12_ + _loc13_ + _loc14_ + _loc16_ - _loc15_) + (_loc17_ + _loc18_ + _loc19_ + _loc20_ + _loc21_ + _loc22_ + _loc23_ + _loc24_ + _loc25_ + _loc26_);
         var _loc28_:String = !!ENABLE_AI_LOG ? "Utility score " + Math.round(_loc27_) + " | intent:" + this.currentIntent + " personality:" + this.currentPersonality + " now:" + Math.round(_loc11_) + " strategy:" + Math.round(_loc12_) + " combo:" + Math.round(_loc13_) + " timing:" + Math.round(_loc14_) + " burst:" + Math.round(_loc17_) + " ev:" + Math.round(_loc18_) + " 2turn:" + Math.round(_loc19_) + " resource:" + Math.round(_loc20_) + " team:" + Math.round(_loc21_) + " survivalRisk:" + Math.round(_loc22_) + " intentScore:" + Math.round(_loc23_) + " personalityScore:" + Math.round(_loc24_) + " plan:" + Math.round(_loc25_) + " antiStupid:" + Math.round(_loc26_) + " risk:" + Math.round(_loc15_) + " next:" + Math.round(_loc16_) : "";
         return {
            "action":{
               "type":param2.type,
               "index":param2.index,
               "is_aoe":param2.is_aoe
            },
            "score":_loc27_,
            "tie_breaker":param2.tie_breaker,
            "metadata":_loc8_,
            "actual_damage":_loc10_,
            "risk":_loc15_,
            "lookahead":_loc16_,
            "expected_value":_loc18_,
            "resource":_loc20_,
            "team_coordination":_loc21_,
            "survival_risk":_loc22_,
            "intent":this.currentIntent,
            "personality":this.currentPersonality,
            "intent_score":_loc23_,
            "personality_score":_loc24_,
            "plan_score":_loc25_,
            "anti_stupid":_loc26_,
            "breakdown":{
               "immediate":_loc11_,
               "strategic":_loc12_,
               "combo":_loc13_,
               "timing":_loc14_,
               "burst":_loc17_,
               "expected_value":_loc18_,
               "two_turn":_loc19_,
               "resource":_loc20_,
               "team_coordination":_loc21_,
               "survival_risk":_loc22_,
               "intent_score":_loc23_,
               "personality_score":_loc24_,
               "plan_score":_loc25_,
               "anti_stupid":_loc26_,
               "risk":_loc15_,
               "lookahead":_loc16_,
               "final":_loc27_
            },
            "reason":_loc28_
         };
      }
      
      private function buildSkillMetadata(param1:Object) : Object
      {
         var _loc8_:Object = null;
         var _loc9_:String = null;
         if(param1 != null && param1.hasOwnProperty("_ai_metadata_cache"))
         {
            return param1._ai_metadata_cache;
         }
         var _loc2_:Array = [];
         var _loc3_:Object = {};
         var _loc4_:Array = param1 != null && param1.hasOwnProperty("effects") ? param1.effects : [];
         var _loc5_:Number = this.estimateCandidateDamage(param1);
         this.addTag(_loc2_,_loc3_,_loc5_ > 0 ? "damage" : null);
         if(_loc5_ >= 2.5)
         {
            this.addTag(_loc2_,_loc3_,"finisher");
         }
         if(param1 != null && (Boolean(param1.multi_hit) || Boolean(param1.is_aoe) || String(param1.skill_target) == "All"))
         {
            this.addTag(_loc2_,_loc3_,"aoe");
         }
         if(param1 != null && param1.hasOwnProperty("next_skill"))
         {
            this.addTag(_loc2_,_loc3_,"setup");
         }
         var _loc6_:int = 0;
         while(_loc4_ && _loc6_ < _loc4_.length)
         {
            if((_loc8_ = _loc4_[_loc6_]) != null)
            {
               _loc9_ = _loc8_.effect;
               if(this.detectSingleEffectType(_loc8_,TYPE_HEAL))
               {
                  this.addTag(_loc2_,_loc3_,"healing");
               }
               if(this.detectSingleEffectType(_loc8_,TYPE_BUFF))
               {
                  this.addTag(_loc2_,_loc3_,"buff");
                  if(DAMAGE_BOOST_EFFECTS[_loc9_])
                  {
                     this.addTag(_loc2_,_loc3_,"setup");
                  }
               }
               if(this.detectSingleEffectType(_loc8_,TYPE_DEBUFF))
               {
                  this.addTag(_loc2_,_loc3_,"debuff");
                  if(_loc9_ == "bleeding" || _loc9_ == "pet_bleeding" || _loc9_ == "ultra_bleeding" || _loc9_ == "burn" || _loc9_ == "burning" || _loc9_ == "ultra_burning" || _loc9_ == "pet_burn" || _loc9_ == "poison" || _loc9_ == "frostbite")
                  {
                     this.addTag(_loc2_,_loc3_,"dot");
                  }
               }
               if(this.detectSingleEffectType(_loc8_,TYPE_STUN))
               {
                  this.addTag(_loc2_,_loc3_,"control");
               }
               if(this.detectSingleEffectType(_loc8_,TYPE_DRAIN))
               {
                  this.addTag(_loc2_,_loc3_,"control");
               }
               if(this.detectSingleEffectType(_loc8_,TYPE_DISPERSE))
               {
                  this.addTag(_loc2_,_loc3_,"disperse");
               }
               if(this.detectSingleEffectType(_loc8_,TYPE_PURIFY))
               {
                  this.addTag(_loc2_,_loc3_,"purify");
               }
               if(this.detectSingleEffectType(_loc8_,TYPE_RESIST))
               {
                  this.addTag(_loc2_,_loc3_,"buff");
               }
            }
            _loc6_++;
         }
         var _loc7_:Object = {
            "tags":_loc2_,
            "tag_map":_loc3_,
            "effects":_loc4_,
            "damage":_loc5_,
            "cooldown":this.getSkillCooldown(param1),
            "next_skill":(param1 != null && param1.hasOwnProperty("next_skill") ? int(param1.next_skill) : -1),
            "is_self_skill":param1 != null && param1.hasOwnProperty("is_self_skill") && Boolean(param1.is_self_skill)
         };
         if(param1 != null)
         {
            try
            {
               param1._ai_metadata_cache = _loc7_;
            }
            catch(e:*)
            {
            }
         }
         return _loc7_;
      }
      
      private function addTag(param1:Array, param2:Object, param3:String) : void
      {
         if(param3 == null || param3 == "" || param2[param3])
         {
            return;
         }
         param2[param3] = true;
         param1.push(param3);
      }
      
      private function scoreImmediateValue(param1:Object, param2:Object, param3:Object, param4:Number, param5:Number, param6:Object, param7:Object, param8:Object) : Number
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc9_:Number = this.scoreUtilityEffects(param3.effects,param6);
         if(param3.tag_map.damage)
         {
            _loc10_ = Math.max(1,param7.current_hp);
            _loc12_ = (_loc11_ = Math.min(1.5,param5 / _loc10_)) * 180;
            if(param6.has_damage_boost)
            {
               _loc12_ += _loc11_ * 45;
            }
            if(param7.hp_ratio <= 0.3)
            {
               _loc12_ += 45;
            }
            return _loc12_ + _loc9_;
         }
         if(param3.tag_map.buff)
         {
            _loc9_ += this.normalizeFutureDamageValue(this.estimateNextTurnDamageWithBuff(param1,param2,param3,param8,param6),param7) * 0.9;
         }
         if(param3.tag_map.debuff)
         {
            _loc9_ += this.estimateDebuffExploitScore(param1,param2,param3,param8,param7,param6) * 0.75;
         }
         return _loc9_;
      }
      
      private function scoreBurstWindow(param1:Object, param2:Object, param3:Object, param4:Number, param5:Object, param6:Object) : Number
      {
         var _loc8_:Number = NaN;
         var _loc7_:Number = 0;
         if(param3.tag_map.damage && this.isTargetVulnerable(param5))
         {
            _loc8_ = Math.max(1,param5.current_hp);
            _loc7_ += 90 + Math.min(120,param4 / _loc8_ * 120);
         }
         if(param3.tag_map.debuff)
         {
            _loc7_ += this.estimateDebuffExploitScore(param1,param2,param3,param6,param5,null) * 0.8;
         }
         return _loc7_;
      }
      
      private function estimateNextTurnDamageWithBuff(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object) : Number
      {
         if(param3 == null || !param3.tag_map.buff)
         {
            return 0;
         }
         var _loc6_:Number;
         if((_loc6_ = this.getBestFutureActualDamage(param1,param2,param4)) <= 0)
         {
            return 0;
         }
         var _loc7_:Number = this.getBuffDamageMultiplier(param3);
         var _loc8_:Number = this.getMetadataDurationFactor(param3);
         var _loc9_:Number = this.getNextTurnCastProbability(param1,param2);
         var _loc10_:Number = !!this.hasDefensiveMetadataEffect(param3) ? Number(0.75 + Math.max(0,1 - param5.self_hp_ratio)) : Number(1);
         var _loc11_:Number = !!this.metadataTargetsTeam(param3) ? Number(1.25) : Number(1);
         return _loc6_ * _loc7_ * _loc8_ * _loc9_ * _loc10_ * _loc11_;
      }
      
      private function estimateDebuffExploitScore(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object, param6:Object) : Number
      {
         if(param3 == null || !param3.tag_map.debuff || param5 == null)
         {
            return 0;
         }
         return this.normalizeFutureDamageValue(this.estimateDebuffExtraDamage(param1,param2,param3,param4,param5,param6),param5);
      }
      
      private function estimateDebuffExtraDamage(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object, param6:Object) : Number
      {
         if(param3 == null || !param3.tag_map.debuff || param5 == null)
         {
            return 0;
         }
         var _loc7_:Number;
         if((_loc7_ = this.getBestFutureActualDamage(param1,param2,param4)) <= 0)
         {
            return 0;
         }
         var _loc8_:Number = this.getMetadataDurationFactor(param3);
         var _loc9_:Number = this.getMetadataChanceFactor(param3);
         var _loc10_:Number = this.getDebuffExploitMultiplier(param3);
         var _loc11_:Number = !!this.isTargetVulnerable(param5) ? Number(1.25) : Number(1);
         var _loc12_:Number = param6 != null && param6.enemy_protected ? Number(0.45) : Number(1);
         return _loc7_ * _loc10_ * _loc8_ * _loc9_ * _loc11_ * _loc12_;
      }
      
      private function normalizeFutureDamageValue(param1:Number, param2:Object) : Number
      {
         if(param2 == null || param1 <= 0)
         {
            return 0;
         }
         return Math.min(260,param1 / Math.max(1,param2.current_hp) * 180);
      }
      
      private function getBuffDamageMultiplier(param1:Object) : Number
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc2_:Number = !!this.hasDamageBoostMetadataEffect(param1) ? Number(0.5) : Number(0.18);
         var _loc3_:int = 0;
         while(param1 != null && param1.effects != null && _loc3_ < param1.effects.length)
         {
            if((_loc4_ = param1.effects[_loc3_]) != null && this.detectSingleEffectType(_loc4_,TYPE_BUFF))
            {
               _loc5_ = this.getEffectAmountRatio(_loc4_);
               if(DAMAGE_BOOST_EFFECTS[_loc4_.effect])
               {
                  _loc2_ = Math.max(_loc2_,_loc5_ > 0 ? Number(_loc5_) : Number(0.5));
               }
               else if(DEFENSIVE_BUFF_EFFECTS[_loc4_.effect])
               {
                  _loc2_ = Math.max(_loc2_,0.12 + _loc5_ * 0.35);
               }
               else
               {
                  _loc2_ = Math.max(_loc2_,0.18 + _loc5_ * 0.4);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getDebuffExploitMultiplier(param1:Object) : Number
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc2_:Number = 0.16;
         var _loc3_:int = 0;
         while(param1 != null && param1.effects != null && _loc3_ < param1.effects.length)
         {
            if((_loc4_ = param1.effects[_loc3_]) != null && this.detectSingleEffectType(_loc4_,TYPE_DEBUFF))
            {
               _loc5_ = this.getEffectAmountRatio(_loc4_);
               if(VULNERABILITY_EFFECTS[_loc4_.effect] || OFFENSIVE_DEBUFF_EFFECTS[_loc4_.effect])
               {
                  _loc2_ = Math.max(_loc2_,_loc5_ > 0 ? Number(_loc5_) : Number(0.35));
               }
               else if(TEMPO_DEBUFF_EFFECTS[_loc4_.effect])
               {
                  _loc2_ = Math.max(_loc2_,0.22);
               }
               else if(RESOURCE_DEBUFF_EFFECTS[_loc4_.effect])
               {
                  _loc2_ = Math.max(_loc2_,0.18);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getEffectAmountRatio(param1:Object) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 == null)
         {
            return 0;
         }
         if(param1.hasOwnProperty("amount_prc"))
         {
            return Math.max(0,Number(param1.amount_prc) / 100);
         }
         if(param1.hasOwnProperty("amount"))
         {
            _loc2_ = Math.abs(Number(param1.amount));
            return _loc2_ > 1 ? Number(_loc2_ / 100) : Number(_loc2_);
         }
         return 0;
      }
      
      private function getMetadataDurationFactor(param1:Object) : Number
      {
         var _loc4_:Object = null;
         var _loc2_:int = 1;
         var _loc3_:int = 0;
         while(param1 != null && param1.effects != null && _loc3_ < param1.effects.length)
         {
            if((_loc4_ = param1.effects[_loc3_]) != null && _loc4_.hasOwnProperty("duration"))
            {
               _loc2_ = Math.max(_loc2_,int(_loc4_.duration));
            }
            _loc3_++;
         }
         return Math.min(1.6,0.75 + Math.min(4,_loc2_) * 0.2);
      }
      
      private function getMetadataChanceFactor(param1:Object) : Number
      {
         var _loc5_:Object = null;
         var _loc2_:Number = 1;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(param1 != null && param1.effects != null && _loc4_ < param1.effects.length)
         {
            if((_loc5_ = param1.effects[_loc4_]) != null && _loc5_.hasOwnProperty("chance"))
            {
               _loc2_ = Math.min(_loc2_,Math.max(0,Number(_loc5_.chance) / 100));
               _loc3_ = true;
            }
            if(_loc5_ != null && _loc5_.hasOwnProperty("buff_chance"))
            {
               _loc2_ = Math.min(_loc2_,Math.max(0,Number(_loc5_.buff_chance) / 100));
               _loc3_ = true;
            }
            if(_loc5_ != null && _loc5_.hasOwnProperty("success_rate"))
            {
               _loc2_ = Math.min(_loc2_,Math.max(0,Number(_loc5_.success_rate) / 100));
               _loc3_ = true;
            }
            _loc4_++;
         }
         return !!_loc3_ ? Number(_loc2_) : Number(1);
      }
      
      private function getNextTurnCastProbability(param1:Object, param2:Object) : Number
      {
         var _loc3_:* = this.getBestFutureActualDamage(param1,param2,this.currentTargetModel) > 0;
         return !!_loc3_ ? Number(1) : Number(0.35);
      }
      
      private function scoreExpectedValue(param1:Object, param2:Object, param3:Object, param4:Number, param5:Object, param6:Object, param7:Object) : Number
      {
         var _loc8_:Number = this.getMetadataChanceFactor(param3);
         var _loc9_:Number = 0;
         if(param3.tag_map.damage && _loc8_ < 1)
         {
            _loc9_ -= Math.min(160,param4 / Math.max(1,param6.current_hp) * 120 * (1 - _loc8_));
         }
         if(param3.tag_map.buff)
         {
            _loc9_ += this.normalizeFutureDamageValue(this.estimateNextTurnDamageWithBuff(param1,param2,param3,param7,param5),param6) * _loc8_ * 0.35;
            if(this.hasDefensiveMetadataEffect(param3))
            {
               _loc9_ += this.estimateDefensiveExpectedValue(param3,param5) * _loc8_;
            }
         }
         if(param3.tag_map.debuff)
         {
            _loc9_ += this.estimateDebuffExploitScore(param1,param2,param3,param7,param6,param5) * _loc8_ * 0.4;
            if(param3.tag_map.control)
            {
               _loc9_ += Math.min(90,param5.enemy_threat) * _loc8_;
            }
         }
         return _loc9_;
      }
      
      private function scoreTwoTurnLookahead(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object, param6:Object) : Number
      {
         var _loc7_:Number = this.getBestFutureActualDamage(param1,param2,param5);
         var _loc8_:Number = this.getBestFutureActualDamageTwoTurns(param1,param2,param5);
         var _loc9_:Number = (_loc9_ = Math.min(120,_loc7_ / Math.max(1,param6.current_hp) * 80)) + Math.min(90,_loc8_ / Math.max(1,param6.current_hp) * 55);
         if(param3.tag_map.buff || param3.tag_map.debuff || param3.tag_map.setup)
         {
            _loc9_ += Math.min(120,(_loc7_ + _loc8_) / Math.max(1,param6.current_hp) * 45);
         }
         if(param4.self_hp_ratio < 0.22 && !param3.tag_map.healing && !this.hasDefensiveMetadataEffect(param3) && !param3.tag_map.control)
         {
            _loc9_ -= 120;
         }
         return _loc9_;
      }
      
      private function scoreResourcePlanning(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object) : Number
      {
         var _loc6_:Number = this.getActionCPCost(param1,param2);
         var _loc7_:Number = this.getCurrentCP(param1);
         var _loc8_:Number = this.getMaxCP(param1);
         if(_loc6_ <= 0 || _loc8_ <= 0)
         {
            return 0;
         }
         var _loc9_:Number = this.ratioValue(_loc7_ - _loc6_,_loc8_);
         var _loc10_:Number = this.getBestFutureHighImpactCPCost(param1,param2,param5);
         var _loc11_:Number = 0;
         if(_loc7_ - _loc6_ < _loc10_ && !param3.tag_map.finisher && !param3.tag_map.healing && !param3.tag_map.control)
         {
            _loc11_ -= 95;
         }
         if(_loc9_ < 0.15 && param4.self_cp_ratio > 0.15 && !param3.tag_map.finisher)
         {
            _loc11_ -= 45;
         }
         if(param5 != null && param5.health_manager != null && this.estimateActualDamage(param1,param2.skill,param5) >= param5.health_manager.getCurrentHP())
         {
            _loc11_ += 120;
         }
         if(param3.tag_map.setup || param3.tag_map.buff || param3.tag_map.debuff)
         {
            _loc11_ += _loc7_ >= _loc6_ ? 25 : -120;
         }
         return _loc11_;
      }
      
      private function scoreTeamCoordination(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object, param6:Array, param7:Object, param8:Object) : Number
      {
         var _loc9_:Number = 0;
         var _loc10_:String = this.getTeamMemoryKey(param1);
         var _loc11_:String = this.getTargetMemoryKey(param4);
         var _loc12_:Object = TEAM_TACTICAL_MEMORY[_loc10_ + "|" + _loc11_];
         if(param3.tag_map.debuff && param4 != null && this.hasActiveMetadataEffect(param4,param3))
         {
            _loc9_ -= 120;
         }
         if(param3.tag_map.debuff && _loc12_ != null && _loc12_.effect != null && this.metadataHasEffect(param3,_loc12_.effect) && this.decisionTurn - int(_loc12_.turn) <= 2)
         {
            _loc9_ -= 95;
         }
         if(param3.tag_map.debuff && param6 != null && param6.length > 1)
         {
            _loc9_ += Math.min(120,this.getBestTeamFutureDamage(param6,param1,param4) / Math.max(1,param5.current_hp) * 90);
         }
         if(param3.tag_map.damage && this.isTargetVulnerable(param5) && param6 != null && param6.length > 1)
         {
            _loc9_ += 45;
         }
         if(this.metadataTargetsTeam(param3) && param7 != null && param7.alive_count > 1)
         {
            _loc9_ += 30 + param7.unbuffed_count * 18;
         }
         return _loc9_;
      }
      
      private function scoreSurvivalRisk(param1:Object, param2:Object, param3:Object, param4:Object) : Number
      {
         var _loc5_:Number = this.estimateDeathRisk(param1,param4,param3);
         var _loc6_:Number = 0;
         if(_loc5_ <= 0)
         {
            return 0;
         }
         if(param2.tag_map.healing)
         {
            _loc6_ += 140 * _loc5_;
         }
         if(this.hasDefensiveMetadataEffect(param2) || param2.tag_map.purify)
         {
            _loc6_ += 115 * _loc5_;
         }
         if(param2.tag_map.control && !param3.enemy_disabled && !param3.enemy_protected)
         {
            _loc6_ += 90 * _loc5_;
         }
         if((param2.tag_map.setup || param2.tag_map.buff) && !this.hasDefensiveMetadataEffect(param2) && !param2.tag_map.healing && _loc5_ > 0.7)
         {
            _loc6_ -= 120 * _loc5_;
         }
         return _loc6_;
      }
      
      private function scoreIntentAlignment(param1:Object, param2:Object, param3:Object) : Number
      {
         if(this.currentIntent == INTENT_DEFENSIVE)
         {
            if(param1.tag_map.healing || this.hasDefensiveMetadataEffect(param1) || param1.tag_map.purify)
            {
               return 70;
            }
            if(param1.tag_map.control)
            {
               return 45;
            }
            if(param1.tag_map.setup && !this.hasDefensiveMetadataEffect(param1))
            {
               return -45;
            }
         }
         else if(this.currentIntent == INTENT_SETUP)
         {
            if(param1.tag_map.setup || param1.tag_map.buff || param1.tag_map.debuff)
            {
               return 55;
            }
            if(param1.tag_map.damage && param3.hp_ratio > 0.45)
            {
               return -20;
            }
         }
         else if(this.currentIntent == INTENT_BURST_READY)
         {
            if(param1.tag_map.damage)
            {
               return 70;
            }
            if(param1.tag_map.debuff && !param3.is_vulnerable)
            {
               return 35;
            }
         }
         else if(this.currentIntent == INTENT_CONTROL)
         {
            if(param1.tag_map.control)
            {
               return 70;
            }
            if(param1.tag_map.debuff)
            {
               return 30;
            }
         }
         else
         {
            if(param1.tag_map.damage || param1.tag_map.finisher)
            {
               return 45;
            }
            if(param1.tag_map.healing && param2.self_hp_ratio > 0.55)
            {
               return -55;
            }
         }
         return 0;
      }
      
      private function scorePersonalityModifier(param1:Object, param2:Object, param3:Object) : Number
      {
         if(this.currentPersonality == PERSONALITY_BERSERKER)
         {
            if(param1.tag_map.damage || param1.tag_map.finisher)
            {
               return 45;
            }
            if(param1.tag_map.healing && param2.self_hp_ratio > 0.25)
            {
               return -40;
            }
            if(param1.tag_map.setup && param3.hp_ratio > 0.6)
            {
               return 20;
            }
         }
         else if(this.currentPersonality == PERSONALITY_GUARDIAN)
         {
            if(param1.tag_map.healing || this.hasDefensiveMetadataEffect(param1) || this.metadataTargetsTeam(param1))
            {
               return 45;
            }
            if(param1.tag_map.damage && param2.self_hp_ratio < 0.35)
            {
               return -25;
            }
         }
         else if(this.currentPersonality == PERSONALITY_TACTICIAN)
         {
            if(param1.tag_map.setup || param1.tag_map.debuff || param1.next_skill >= 0)
            {
               return 35;
            }
            if(param1.tag_map.disperse && param2.enemy_buff_count > 0)
            {
               return 25;
            }
         }
         else if(this.currentPersonality == PERSONALITY_TRICKSTER)
         {
            if(param1.tag_map.control || param1.tag_map.debuff || param1.tag_map.disperse)
            {
               return 45;
            }
            if(param1.tag_map.damage && param3.hp_ratio > 0.45)
            {
               return -15;
            }
         }
         else if(this.currentPersonality == PERSONALITY_HEALER)
         {
            if(param1.tag_map.healing || param1.tag_map.purify || this.metadataTargetsTeam(param1))
            {
               return 55;
            }
            if(param1.tag_map.damage && param2.self_hp_ratio < 0.45)
            {
               return -20;
            }
         }
         return 0;
      }
      
      private function scorePlanningMemory(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object) : Number
      {
         var _loc6_:Number = 0;
         var _loc7_:String = this.getTargetMemoryKey(param4);
         var _loc8_:String = this.getActionKey(param2.type,param2.index);
         if(this.plannedTarget != null && this.plannedTarget == _loc7_)
         {
            _loc6_ += 20;
            if(this.plannedSkill != null && this.plannedSkill == _loc8_)
            {
               _loc6_ += 55;
            }
            if(this.plannedIntent == INTENT_SETUP && (param3.tag_map.damage || param3.tag_map.finisher || param5.is_vulnerable))
            {
               _loc6_ += 65;
            }
            if(this.plannedIntent == INTENT_CONTROL && param3.tag_map.damage && this.targetIsDisabled(param4))
            {
               _loc6_ += 45;
            }
         }
         if(this.lastSetupTarget != null && this.lastSetupTarget == _loc7_ && this.turnsSinceSetup <= 2 && param3.tag_map.damage)
         {
            _loc6_ += 60;
         }
         return _loc6_;
      }
      
      private function scoreAntiStupidRules(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object, param6:Object) : Number
      {
         var _loc9_:Number = NaN;
         var _loc7_:Number = 0;
         var _loc8_:Number = this.estimateDeathRisk(param1,param4,param6);
         if(param3.tag_map.healing && param6.self_hp_ratio > 0.62 && _loc8_ < 0.25)
         {
            _loc7_ -= 130;
         }
         if(param3.tag_map.debuff && param4 != null && this.hasActiveMetadataEffect(param4,param3))
         {
            _loc7_ -= 150;
         }
         if((param3.tag_map.setup || param3.tag_map.buff) && !this.hasDefensiveMetadataEffect(param3) && !param3.tag_map.healing && _loc8_ > 0.75)
         {
            _loc7_ -= 150;
         }
         if(param3.tag_map.buff && this.hasActiveMetadataEffect(param1,param3))
         {
            _loc7_ -= 130;
         }
         if(param3.tag_map.buff && this.getMetadataDurationFactor(param3) <= 0.95 && param6.self_hp_ratio < 0.25 && !this.hasDefensiveMetadataEffect(param3))
         {
            _loc7_ -= 60;
         }
         if(param3.tag_map.damage && param5.hp_ratio <= 0.3)
         {
            _loc7_ += 55;
         }
         if(param3.tag_map.damage && param4 != null && param4.health_manager != null)
         {
            if((_loc9_ = this.estimateActualDamage(param1,param2.skill,param4) - param4.health_manager.getCurrentHP()) > param4.health_manager.getMaxHP() * 0.35 && !param3.tag_map.finisher)
            {
               _loc7_ -= 50;
            }
         }
         return _loc7_;
      }
      
      private function scoreStrategicValue(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object, param6:Object) : Number
      {
         var _loc8_:Number = NaN;
         var _loc7_:Number = 0;
         if(param3.tag_map.buff && !this.hasActiveMetadataEffect(param1,param3))
         {
            _loc7_ = (_loc7_ += param4.self_hp_ratio < 0.45 ? 95 : 55) + this.normalizeFutureDamageValue(this.estimateNextTurnDamageWithBuff(param1,param6,param3,param2,param4),param5);
         }
         if(param3.tag_map.debuff && !this.hasActiveMetadataEffect(param2,param3) && !param4.enemy_protected)
         {
            _loc8_ = param5.hp_ratio > 0.35 ? (param4.enemy_threat >= 90 ? Number(150) : Number(110)) : (param5.hp_ratio <= FINISH_HP_RATIO ? Number(0) : Number(45));
            _loc7_ = (_loc7_ += _loc8_) + this.estimateDebuffExploitScore(param1,param6,param3,param2,param5,param4);
         }
         if(param3.tag_map.disperse && param4.enemy_buff_count > 0)
         {
            _loc7_ += 95 + param4.enemy_buff_count * 15;
         }
         if(param3.tag_map.purify)
         {
            _loc7_ += param4.self_debuff_count * 55;
         }
         if(param3.tag_map.control && !param4.enemy_disabled && !param4.enemy_protected)
         {
            _loc7_ += 85;
         }
         return _loc7_;
      }
      
      private function scoreComboPotential(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object, param6:Object) : Number
      {
         var _loc9_:Object = null;
         var _loc7_:Number = 0;
         var _loc8_:Number = Math.max(1,param6 != null ? Number(Number(param6.current_hp)) : Number(1));
         if(param3.tag_map.setup)
         {
            _loc7_ += 45;
            if(!param4.has_damage_boost)
            {
               _loc7_ += 35;
            }
         }
         if(this.isPendingComboSkill(param1,param2))
         {
            _loc7_ += 140;
         }
         if(param3.next_skill >= 0)
         {
            if((_loc9_ = this.getUnitSkillByIndex(param1,param3.next_skill)) != null && this.comboSkillCanRunNextTurn(param1,param3.next_skill,param2))
            {
               _loc7_ += Math.max(25,Math.min(180,this.estimateActualDamage(param1,_loc9_,param5) / _loc8_ * 160));
            }
         }
         if(param3.tag_map.debuff || param3.tag_map.control)
         {
            _loc7_ += Math.min(120,this.getBestFutureActualDamage(param1,param2,param5) / _loc8_ * 100);
         }
         return _loc7_;
      }
      
      private function isPendingComboSkill(param1:Object, param2:Object) : Boolean
      {
         var _loc3_:Object = this.getUnitInfo(param1);
         return _loc3_ != null && _loc3_.hasOwnProperty("combo_skill") && Boolean(_loc3_.combo_skill) && _loc3_.hasOwnProperty("next_skill") && int(_loc3_.next_skill) == int(param2.index);
      }
      
      private function scoreTimingValue(param1:Object, param2:Object, param3:Object, param4:Object) : Number
      {
         var _loc5_:Number = this.decisionTurn <= 2 && param2.tag_map.setup ? Number(35) : Number(0);
         if(param2.tag_map.finisher && param4.hp_ratio <= 0.35)
         {
            _loc5_ += 120;
         }
         if(param2.tag_map.healing && param3.self_hp_ratio < 0.4)
         {
            _loc5_ += 120;
         }
         if(param2.cooldown >= 4 && param4.hp_ratio > 0.65 && !param2.tag_map.setup && !param2.tag_map.buff)
         {
            _loc5_ -= 45;
         }
         if(param1.type == 6 && param3.self_cp_ratio < 0.18)
         {
            _loc5_ += 70;
         }
         return _loc5_;
      }
      
      private function scoreRiskValue(param1:Object, param2:Object, param3:Object, param4:Object, param5:Number, param6:Object, param7:Object) : Number
      {
         var _loc8_:Number = this.getRepeatPenalty(this.getActionKey(param3.type,param3.index));
         if(param4.tag_map.buff && this.hasActiveMetadataEffect(param1,param4) || param4.tag_map.debuff && this.hasActiveMetadataEffect(param2,param4))
         {
            _loc8_ += 140;
         }
         if(param4.tag_map.control && param6.enemy_disabled)
         {
            _loc8_ += 120;
         }
         if(param4.tag_map.debuff && param6.enemy_protected)
         {
            _loc8_ += 150;
         }
         if(param4.cooldown >= 4 && param5 > 0 && param7.hp_ratio < 0.18 && !param4.tag_map.finisher)
         {
            _loc8_ += 55;
         }
         if(param4.tag_map.disperse && param6.enemy_buff_count == 0)
         {
            _loc8_ += 90;
         }
         return _loc8_;
      }
      
      private function estimateLookaheadValue(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object = null) : Number
      {
         var _loc8_:Object = null;
         var _loc6_:Number = this.getBestFutureActualDamage(param1,param2,param5);
         var _loc7_:Number = Math.min(220,_loc6_ / Math.max(1,param5 != null && param5.health_manager != null ? Number(param5.health_manager.getCurrentHP()) : Number(1)) * 160);
         if(param3.tag_map.setup || param3.tag_map.buff || param3.tag_map.debuff)
         {
            _loc7_ += 120 + Math.min(140,_loc6_ / Math.max(1,param5 != null && param5.health_manager != null ? Number(param5.health_manager.getCurrentHP()) : Number(1)) * 120);
         }
         if(param3.next_skill >= 0)
         {
            if((_loc8_ = this.getUnitSkillByIndex(param1,param3.next_skill)) != null && this.comboSkillCanRunNextTurn(param1,param3.next_skill,param2))
            {
               _loc7_ += Math.min(180,this.estimateActualDamage(param1,_loc8_,param5) / Math.max(1,param5 != null && param5.health_manager != null ? Number(param5.health_manager.getCurrentHP()) : Number(1)) * 160);
            }
         }
         if(param4.enemy_disabled)
         {
            _loc7_ *= 0.8;
         }
         return _loc7_;
      }
      
      private function getBestFutureDamage(param1:Object, param2:Object) : Number
      {
         var _loc5_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Object;
         if((_loc4_ = this.getUnitInfo(param1)) != null && _loc4_.attacks != null)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.attacks.length && this.canEvaluateMoreLookahead())
            {
               if(this.isUnitSkillAvailable(_loc4_,_loc5_) && this.willUnitSkillBeReadyNextTurn(_loc4_,_loc5_,param2))
               {
                  ++this.lookaheadEvaluationCount;
                  _loc3_ = Math.max(_loc3_,this.estimateCandidateDamage(_loc4_.attacks[_loc5_]));
               }
               _loc5_++;
            }
            return _loc3_;
         }
         if(param1.hasOwnProperty("actions_manager") && param1.actions_manager != null)
         {
            _loc3_ = Math.max(_loc3_,this.getBestDamageInCharacterArray(param1.actions_manager.character_skills_mc,2,param2));
            _loc3_ = Math.max(_loc3_,this.getBestDamageInCharacterArray(param1.actions_manager.character_talent_skills_mc,3,param2));
            _loc3_ = Math.max(_loc3_,this.getBestDamageInCharacterArray(param1.actions_manager.character_senjutsu_skills_mc,4,param2));
            if(this.canEvaluateMoreLookahead() && param1.actions_manager.class_skill && this.willCharacterSkillBeReadyNextTurn(param1.actions_manager.class_skill,5,0,param2))
            {
               ++this.lookaheadEvaluationCount;
               _loc3_ = Math.max(_loc3_,this.estimateCandidateDamage(param1.actions_manager.class_skill.skill_info));
            }
         }
         return _loc3_;
      }
      
      private function getBestFutureActualDamage(param1:Object, param2:Object, param3:Object) : Number
      {
         var _loc6_:int = 0;
         var _loc4_:Number = 0;
         var _loc5_:Object;
         if((_loc5_ = this.getUnitInfo(param1)) != null && _loc5_.attacks != null)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_.attacks.length && this.canEvaluateMoreLookahead())
            {
               if(this.isUnitSkillAvailable(_loc5_,_loc6_) && this.willUnitSkillBeReadyNextTurn(_loc5_,_loc6_,param2))
               {
                  ++this.lookaheadEvaluationCount;
                  _loc4_ = Math.max(_loc4_,this.estimateActualDamage(param1,_loc5_.attacks[_loc6_],param3));
               }
               _loc6_++;
            }
            return _loc4_;
         }
         return this.getBestFutureDamage(param1,param2);
      }
      
      private function getBestFutureActualDamageTwoTurns(param1:Object, param2:Object, param3:Object) : Number
      {
         var _loc6_:int = 0;
         var _loc4_:Number = 0;
         var _loc5_:Object;
         if((_loc5_ = this.getUnitInfo(param1)) != null && _loc5_.attacks != null)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_.attacks.length && this.canEvaluateMoreLookahead())
            {
               if(this.isUnitSkillAvailable(_loc5_,_loc6_) && this.willUnitSkillBeReadyWithinTurns(_loc5_,_loc6_,param2,2))
               {
                  ++this.lookaheadEvaluationCount;
                  _loc4_ = Math.max(_loc4_,this.estimateActualDamage(param1,_loc5_.attacks[_loc6_],param3));
               }
               _loc6_++;
            }
            return _loc4_;
         }
         if(param1.hasOwnProperty("actions_manager") && param1.actions_manager != null)
         {
            _loc4_ = Math.max(_loc4_,this.getBestDamageInCharacterArrayWithinTurns(param1.actions_manager.character_skills_mc,2,param2,2,param3,param1));
            _loc4_ = Math.max(_loc4_,this.getBestDamageInCharacterArrayWithinTurns(param1.actions_manager.character_talent_skills_mc,3,param2,2,param3,param1));
            _loc4_ = Math.max(_loc4_,this.getBestDamageInCharacterArrayWithinTurns(param1.actions_manager.character_senjutsu_skills_mc,4,param2,2,param3,param1));
            if(param1.actions_manager.class_skill && this.willCharacterSkillBeReadyWithinTurns(param1.actions_manager.class_skill,5,0,param2,2))
            {
               _loc4_ = Math.max(_loc4_,this.estimateActualDamage(param1,param1.actions_manager.class_skill.skill_info,param3));
            }
         }
         return _loc4_;
      }
      
      private function willUnitSkillBeReadyNextTurn(param1:Object, param2:int, param3:Object) : Boolean
      {
         if(param3 != null && param3.type == -1 && param3.index == param2)
         {
            return this.getSkillCooldown(param1.attacks[param2]) <= 1;
         }
         var _loc4_:int;
         return (_loc4_ = param1.curr_skill_cooldowns && param2 < param1.curr_skill_cooldowns.length ? int(int(param1.curr_skill_cooldowns[param2])) : 0) <= 1;
      }
      
      private function willUnitSkillBeReadyWithinTurns(param1:Object, param2:int, param3:Object, param4:int) : Boolean
      {
         if(param3 != null && param3.type == -1 && param3.index == param2)
         {
            return this.getSkillCooldown(param1.attacks[param2]) <= param4;
         }
         var _loc5_:int;
         return (_loc5_ = param1.curr_skill_cooldowns && param2 < param1.curr_skill_cooldowns.length ? int(int(param1.curr_skill_cooldowns[param2])) : 0) <= param4;
      }
      
      private function getBestDamageInCharacterArray(param1:Array, param2:int, param3:Object) : Number
      {
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(param1 && _loc5_ < param1.length && this.canEvaluateMoreLookahead())
         {
            if(param1[_loc5_] != null && param1[_loc5_].skill_info != null && this.willCharacterSkillBeReadyNextTurn(param1[_loc5_],param2,_loc5_,param3))
            {
               ++this.lookaheadEvaluationCount;
               _loc4_ = Math.max(_loc4_,this.estimateCandidateDamage(param1[_loc5_].skill_info));
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function willCharacterSkillBeReadyNextTurn(param1:Object, param2:int, param3:int, param4:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param4 != null && param4.type == param2 && param4.index == param3)
         {
            return this.getSkillCooldown(param1.skill_info) <= 1;
         }
         return param1.getCurrentCooldown() <= 1;
      }
      
      private function willCharacterSkillBeReadyWithinTurns(param1:Object, param2:int, param3:int, param4:Object, param5:int) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param4 != null && param4.type == param2 && param4.index == param3)
         {
            return this.getSkillCooldown(param1.skill_info) <= param5;
         }
         return param1.getCurrentCooldown() <= param5;
      }
      
      private function getBestDamageInCharacterArrayWithinTurns(param1:Array, param2:int, param3:Object, param4:int, param5:Object, param6:Object) : Number
      {
         var _loc7_:Number = 0;
         var _loc8_:int = 0;
         while(param1 && _loc8_ < param1.length && this.canEvaluateMoreLookahead())
         {
            if(param1[_loc8_] != null && param1[_loc8_].skill_info != null && this.willCharacterSkillBeReadyWithinTurns(param1[_loc8_],param2,_loc8_,param3,param4))
            {
               ++this.lookaheadEvaluationCount;
               _loc7_ = Math.max(_loc7_,this.estimateActualDamage(param6,param1[_loc8_].skill_info,param5));
            }
            _loc8_++;
         }
         return _loc7_;
      }
      
      private function getUnitSkillByIndex(param1:Object, param2:int) : Object
      {
         var _loc3_:Object = this.getUnitInfo(param1);
         if(_loc3_ == null || _loc3_.attacks == null || param2 < 0 || param2 >= _loc3_.attacks.length)
         {
            return null;
         }
         return _loc3_.attacks[param2];
      }
      
      private function canKillTarget(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(param2 == null || param3 == null || param3.health_manager == null)
         {
            return false;
         }
         var _loc4_:Object;
         if((_loc4_ = this.getSkillFromAction(param1,param2)) == null)
         {
            return false;
         }
         return this.estimateActualDamage(param1,_loc4_,param3) >= param3.health_manager.getCurrentHP();
      }
      
      private function canKillNextTurnWithSetup(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object, param6:Object) : Boolean
      {
         var _loc8_:Object = null;
         if(param3 == null || param4 == null || param5 == null || param5.current_hp <= 0)
         {
            return false;
         }
         if(!param3.tag_map.setup && !param3.tag_map.buff && !param3.tag_map.debuff)
         {
            return false;
         }
         if(param3.tag_map.damage && this.canKillTarget(param1,param2,param4))
         {
            return false;
         }
         var _loc7_:Number = 0;
         if(param3.next_skill >= 0)
         {
            if((_loc8_ = this.getUnitSkillByIndex(param1,param3.next_skill)) != null && this.comboSkillCanRunNextTurn(param1,param3.next_skill,param2))
            {
               _loc7_ = this.estimateActualDamage(param1,_loc8_,param4);
            }
         }
         _loc7_ = Math.max(_loc7_,this.getBestFutureActualDamage(param1,param2,param4));
         if(param3.tag_map.buff)
         {
            _loc7_ += this.estimateNextTurnDamageWithBuff(param1,param2,param3,param4,param6);
         }
         if(param3.tag_map.debuff)
         {
            _loc7_ += this.estimateDebuffExtraDamage(param1,param2,param3,param4,param5,param6);
         }
         param2.setup_kill_damage = _loc7_;
         return _loc7_ >= param5.current_hp;
      }
      
      private function estimateActualDamage(param1:Object, param2:Object, param3:Object = null) : Number
      {
         if(param2 == null)
         {
            return 0;
         }
         var _loc4_:Number;
         if((_loc4_ = this.estimateCandidateDamage(param2)) <= 0)
         {
            return 0;
         }
         if(param2.hasOwnProperty("is_static") && Boolean(param2.is_static))
         {
            return Math.floor(_loc4_);
         }
         if(param1 != null && param1.hasOwnProperty("pet_info") && param1.pet_info != null)
         {
            return Math.floor(_loc4_ * Math.round(3 * Number(param1.pet_info.pet_level)));
         }
         if(param1 != null && param1.hasOwnProperty("enemy_info") && param1.enemy_info != null)
         {
            return Math.floor(_loc4_ * this.getEnemyBaseDamage(param1));
         }
         if(param1 != null && param1.hasOwnProperty("npc_info") && param1.npc_info != null)
         {
            return Math.floor(_loc4_ * this.getNpcBaseDamage(param3));
         }
         return _loc4_;
      }
      
      private function getActionCPCost(param1:Object, param2:Object) : Number
      {
         if(param2 == null || param2.skill == null)
         {
            return 0;
         }
         var _loc3_:Object = param2.skill;
         if(_loc3_.hasOwnProperty("skill_cp_cost"))
         {
            return Number(_loc3_.skill_cp_cost);
         }
         if(_loc3_.hasOwnProperty("talent_skill_cp_cost"))
         {
            return Number(_loc3_.talent_skill_cp_cost);
         }
         if(_loc3_.hasOwnProperty("cp_cost"))
         {
            return Number(_loc3_.cp_cost);
         }
         if(_loc3_.hasOwnProperty("cost_cp"))
         {
            return Number(_loc3_.cost_cp);
         }
         return 0;
      }
      
      private function getCurrentCP(param1:Object) : Number
      {
         if(param1 == null || param1.health_manager == null)
         {
            return 0;
         }
         return param1.health_manager.getCurrentCP();
      }
      
      private function getMaxCP(param1:Object) : Number
      {
         if(param1 == null || param1.health_manager == null)
         {
            return 0;
         }
         return param1.health_manager.getMaxCP();
      }
      
      private function getBestFutureHighImpactCPCost(param1:Object, param2:Object, param3:Object) : Number
      {
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Object;
         if((_loc6_ = this.getUnitInfo(param1)) != null && _loc6_.attacks != null)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc6_.attacks.length && this.canEvaluateMoreLookahead())
            {
               if(this.isUnitSkillAvailable(_loc6_,_loc7_) && this.willUnitSkillBeReadyWithinTurns(_loc6_,_loc7_,param2,2))
               {
                  ++this.lookaheadEvaluationCount;
                  if((_loc8_ = this.estimateActualDamage(param1,_loc6_.attacks[_loc7_],param3)) > _loc5_)
                  {
                     _loc5_ = _loc8_;
                     _loc4_ = this.getSkillCPCost(_loc6_.attacks[_loc7_]);
                  }
               }
               _loc7_++;
            }
            return _loc4_;
         }
         if(param1.hasOwnProperty("actions_manager") && param1.actions_manager != null)
         {
            _loc4_ = Math.max(_loc4_,this.getBestHighImpactCostInCharacterArray(param1,param1.actions_manager.character_skills_mc,2,param2,param3));
            _loc4_ = Math.max(_loc4_,this.getBestHighImpactCostInCharacterArray(param1,param1.actions_manager.character_talent_skills_mc,3,param2,param3));
            _loc4_ = Math.max(_loc4_,this.getBestHighImpactCostInCharacterArray(param1,param1.actions_manager.character_senjutsu_skills_mc,4,param2,param3));
            if(param1.actions_manager.class_skill && this.willCharacterSkillBeReadyWithinTurns(param1.actions_manager.class_skill,5,0,param2,2))
            {
               _loc4_ = Math.max(_loc4_,this.getSkillCPCost(param1.actions_manager.class_skill.skill_info));
            }
         }
         return _loc4_;
      }
      
      private function getBestHighImpactCostInCharacterArray(param1:Object, param2:Array, param3:int, param4:Object, param5:Object) : Number
      {
         var _loc9_:Number = NaN;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:int = 0;
         while(param2 && _loc8_ < param2.length && this.canEvaluateMoreLookahead())
         {
            if(param2[_loc8_] != null && param2[_loc8_].skill_info != null && this.willCharacterSkillBeReadyWithinTurns(param2[_loc8_],param3,_loc8_,param4,2))
            {
               ++this.lookaheadEvaluationCount;
               if((_loc9_ = this.estimateActualDamage(param1,param2[_loc8_].skill_info,param5)) > _loc7_)
               {
                  _loc7_ = _loc9_;
                  _loc6_ = this.getSkillCPCost(param2[_loc8_].skill_info);
               }
            }
            _loc8_++;
         }
         return _loc6_;
      }
      
      private function getSkillCPCost(param1:Object) : Number
      {
         if(param1 == null)
         {
            return 0;
         }
         if(param1.hasOwnProperty("skill_cp_cost"))
         {
            return Number(param1.skill_cp_cost);
         }
         if(param1.hasOwnProperty("talent_skill_cp_cost"))
         {
            return Number(param1.talent_skill_cp_cost);
         }
         if(param1.hasOwnProperty("cp_cost"))
         {
            return Number(param1.cp_cost);
         }
         if(param1.hasOwnProperty("cost_cp"))
         {
            return Number(param1.cost_cp);
         }
         return 0;
      }
      
      private function estimateDefensiveExpectedValue(param1:Object, param2:Object) : Number
      {
         var _loc3_:Number = 45;
         var _loc4_:Number = this.getMetadataDurationFactor(param1);
         var _loc5_:Number = param2 != null ? Number(Math.max(0.2,1 - param2.self_hp_ratio)) : Number(0.4);
         if(this.hasDefensiveMetadataEffect(param1))
         {
            _loc3_ += 55;
         }
         if(param1.tag_map.healing)
         {
            _loc3_ += 45;
         }
         return _loc3_ * _loc4_ * _loc5_;
      }
      
      private function estimateDeathRisk(param1:Object, param2:Object, param3:Object) : Number
      {
         var _loc7_:Number = NaN;
         if(param1 == null || param2 == null)
         {
            if(param3 == null)
            {
               return 0;
            }
            _loc7_ = (_loc7_ = param3.self_hp_ratio < 0.25 ? Number(0.85) : Number(0)) + (param3.enemy_threat > 120 ? 0.25 : 0);
            return Math.max(0,Math.min(1,_loc7_));
         }
         if(param1 == null || param1.health_manager == null || param2 == null)
         {
            return 0;
         }
         var _loc4_:Number = this.getBestFutureActualDamage(param2,null,param1);
         var _loc5_:Number = Math.max(1,param1.health_manager.getCurrentHP());
         var _loc6_:Number = (_loc6_ = (_loc6_ = _loc4_ / _loc5_) + (param3 != null && param3.self_hp_ratio < 0.25 ? 0.35 : 0)) + (param3 != null && param3.enemy_threat > 110 ? 0.2 : 0);
         if(this.targetIsDisabled(param2))
         {
            _loc6_ *= 0.45;
         }
         return Math.max(0,Math.min(1,_loc6_));
      }
      
      private function getBestTeamFutureDamage(param1:Array, param2:Object, param3:Object) : Number
      {
         var _loc6_:Object = null;
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(param1 != null && _loc5_ < param1.length)
         {
            if((_loc6_ = param1[_loc5_]) != null && _loc6_ != param2 && _loc6_.health_manager != null && !_loc6_.health_manager.isDead())
            {
               _loc4_ = Math.max(_loc4_,this.getBestFutureActualDamage(_loc6_,null,param3));
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function metadataHasEffect(param1:Object, param2:String) : Boolean
      {
         if(param1 == null || param1.effects == null || param2 == null)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.effects.length)
         {
            if(param1.effects[_loc3_] != null && param1.effects[_loc3_].effect == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function getTeamMemoryKey(param1:Object) : String
      {
         if(param1 == null)
         {
            return "unknown";
         }
         if(param1.hasOwnProperty("player_team"))
         {
            return String(param1.player_team);
         }
         if(param1.hasOwnProperty("pet_team"))
         {
            return String(param1.pet_team);
         }
         return "unknown";
      }
      
      private function getTargetMemoryKey(param1:Object) : String
      {
         if(param1 == null)
         {
            return "none";
         }
         if(param1.hasOwnProperty("player_team") && param1.hasOwnProperty("player_number"))
         {
            return String(param1.player_team) + ":" + String(param1.player_number);
         }
         if(param1.hasOwnProperty("pet_team") && param1.hasOwnProperty("pet_number"))
         {
            return String(param1.pet_team) + ":" + String(param1.pet_number);
         }
         return this.getActorLabel(param1);
      }
      
      private function getEnemyBaseDamage(param1:Object) : Number
      {
         var _loc2_:Number = param1 != null && "getLevel" in param1 ? Number(Number(param1.getLevel())) : Number(1);
         return Math.round(20 + _loc2_ / 2 * (1 + 0.06 * _loc2_));
      }
      
      private function getNpcBaseDamage(param1:Object) : Number
      {
         var _loc2_:Number = param1 != null && "getLevel" in param1 ? Number(Number(param1.getLevel())) : Number(1);
         return Math.round(20 + _loc2_ / 2 * (1 + 0.06 * _loc2_));
      }
      
      private function hasDamageBoostMetadataEffect(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 == null || param1.effects == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.effects.length)
         {
            _loc3_ = param1.effects[_loc2_];
            if(_loc3_ != null && DAMAGE_BOOST_EFFECTS[_loc3_.effect])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function hasDefensiveMetadataEffect(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 == null || param1.effects == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.effects.length)
         {
            _loc3_ = param1.effects[_loc2_];
            if(_loc3_ != null && DEFENSIVE_BUFF_EFFECTS[_loc3_.effect])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function hasVulnerabilityMetadataEffect(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 == null || param1.effects == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.effects.length)
         {
            _loc3_ = param1.effects[_loc2_];
            if(_loc3_ != null && VULNERABILITY_EFFECTS[_loc3_.effect])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function analyzeDotPressure(param1:Object) : Object
      {
         var _loc5_:Object = null;
         var _loc2_:Object = {
            "count":0,
            "lifetime_ratio":0,
            "force_purify":false
         };
         if(param1 == null || param1.effects_manager == null || param1.effects_manager.dataDebuff == null || param1.health_manager == null)
         {
            return _loc2_;
         }
         var _loc3_:Number = Math.max(1,param1.health_manager.getMaxHP());
         var _loc4_:int = 0;
         while(_loc4_ < param1.effects_manager.dataDebuff.length)
         {
            if((_loc5_ = param1.effects_manager.dataDebuff[_loc4_]) != null && int(_loc5_.duration) > 0 && this.isPurifiableDotEffect(_loc5_.effect))
            {
               ++_loc2_.count;
               _loc2_.lifetime_ratio += this.estimateDotLifetimeRatio(_loc5_,_loc3_);
            }
            _loc4_++;
         }
         _loc2_.force_purify = _loc2_.count > 2 || _loc2_.lifetime_ratio >= 1;
         return _loc2_;
      }
      
      private function isPurifiableDotEffect(param1:String) : Boolean
      {
         return param1 != null && Effects.doesEffectDecreaseHealth(param1) && !Effects.doesEffectCannotPurified(param1);
      }
      
      private function estimateDotLifetimeRatio(param1:Object, param2:Number) : Number
      {
         if(param1 == null || param2 <= 0)
         {
            return 0;
         }
         var _loc3_:Number = this.getEffectDamageAmount(param1);
         var _loc4_:Number = Math.max(1,Number(param1.duration));
         if(param1.hasOwnProperty("calc_type") && String(param1.calc_type) == "percent")
         {
            return Math.max(0,_loc3_) * _loc4_ / 100;
         }
         return Math.max(0,_loc3_) * _loc4_ / param2;
      }
      
      private function getEffectDamageAmount(param1:Object) : Number
      {
         if(param1 == null)
         {
            return 0;
         }
         if(param1.hasOwnProperty("amount_hp") && Number(param1.amount_hp) > 0)
         {
            return Number(param1.amount_hp);
         }
         if(param1.hasOwnProperty("amount_prc") && Number(param1.amount_prc) > 0)
         {
            return Number(param1.amount_prc);
         }
         if(param1.hasOwnProperty("amount_per_debuff") && Number(param1.amount_per_debuff) > 0)
         {
            return Number(param1.amount_per_debuff);
         }
         if(param1.hasOwnProperty("amount") && Number(param1.amount) > 0)
         {
            return Number(param1.amount);
         }
         return 0;
      }
      
      private function targetHasVulnerability(param1:Object) : Boolean
      {
         var _loc2_:* = null;
         if(param1 == null || param1.effects_manager == null)
         {
            return false;
         }
         for(_loc2_ in VULNERABILITY_EFFECTS)
         {
            if(param1.effects_manager.hadEffect(_loc2_))
            {
               return true;
            }
         }
         return false;
      }
      
      private function isTargetVulnerable(param1:Object) : Boolean
      {
         return param1 != null && Boolean(param1.is_vulnerable);
      }
      
      private function comboSkillCanRunNextTurn(param1:Object, param2:int, param3:Object) : Boolean
      {
         var _loc4_:Object;
         if((_loc4_ = this.getUnitInfo(param1)) == null)
         {
            return true;
         }
         return this.willUnitSkillBeReadyNextTurn(_loc4_,param2,param3);
      }
      
      private function estimateCandidateDamage(param1:Object) : Number
      {
         if(param1 == null)
         {
            return 0;
         }
         if(param1.hasOwnProperty("dmg"))
         {
            return Number(param1.dmg);
         }
         return this.estimateSkillInfoDamage(param1);
      }
      
      private function getSkillCooldown(param1:Object) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         if(param1.hasOwnProperty("cooldown"))
         {
            return int(param1.cooldown);
         }
         if(param1.hasOwnProperty("skill_cooldown"))
         {
            return int(param1.skill_cooldown);
         }
         if(param1.hasOwnProperty("talent_skill_cooldown"))
         {
            return int(param1.talent_skill_cooldown);
         }
         return 0;
      }
      
      private function hasActiveMetadataEffect(param1:Object, param2:Object) : Boolean
      {
         var _loc4_:Object = null;
         if(param1 == null || param1.effects_manager == null || param2 == null || param2.effects == null)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.effects.length)
         {
            if((_loc4_ = param2.effects[_loc3_]) != null && param1.effects_manager.hadEffect(_loc4_.effect))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function isFriendlyAction(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 == null || param1.effects == null)
         {
            return false;
         }
         if(this.metadataHasEnemyDirectedEffect(param1))
         {
            return false;
         }
         if(param1.tag_map != null && param1.tag_map.damage)
         {
            return false;
         }
         if(param1.is_self_skill)
         {
            return true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.effects.length)
         {
            _loc3_ = param1.effects[_loc2_];
            if(_loc3_ != null && (_loc3_.target == "self" || _loc3_.target == "master") && (this.detectSingleEffectType(_loc3_,TYPE_HEAL) || this.detectSingleEffectType(_loc3_,TYPE_BUFF) || this.detectSingleEffectType(_loc3_,TYPE_PURIFY) || this.detectSingleEffectType(_loc3_,TYPE_RESIST) || this.effectTypeIsFriendlyBuff(_loc3_)))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function effectTypeIsFriendlyBuff(param1:Object) : Boolean
      {
         if(param1 == null || !param1.hasOwnProperty("type"))
         {
            return false;
         }
         var _loc2_:String = String(param1.type).toLowerCase();
         return _loc2_ == "buff" || _loc2_ == "heal" || _loc2_ == "purify" || _loc2_ == "resist";
      }
      
      private function selectFriendlyTargetIndex(param1:Object, param2:Array, param3:Object, param4:Object) : int
      {
         if(param1.is_self_skill || this.metadataTargetsSelf(param1))
         {
            return this.getSelfTargetIndex(param4);
         }
         if(param1.tag_map.healing && param3 != null)
         {
            return param3.index;
         }
         if(param2 != null && param2.length > 0)
         {
            return 0;
         }
         return this.getSelfTargetIndex(param4);
      }
      
      private function metadataTargetsSelf(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 == null || param1.effects == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.effects.length)
         {
            _loc3_ = param1.effects[_loc2_];
            if(_loc3_ != null && (_loc3_.target == "self" || (_loc3_.target == null || _loc3_.target == "" || _loc3_.target === undefined) && this.effectTypeIsFriendlyBuff(_loc3_)))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function metadataHasEnemyDirectedEffect(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return false;
         }
         if(param1.tag_map != null && param1.tag_map.damage)
         {
            return true;
         }
         if(param1.effects == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.effects.length)
         {
            _loc3_ = param1.effects[_loc2_];
            if(_loc3_ != null && _loc3_.hasOwnProperty("target") && (_loc3_.target == "enemy" || _loc3_.target == "target" || _loc3_.target == "opponent"))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function metadataTargetsTeam(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 == null || param1.effects == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.effects.length)
         {
            _loc3_ = param1.effects[_loc2_];
            if(_loc3_ != null && (_loc3_.target == "all" || _loc3_.target == "team" || _loc3_.target == "party" || _loc3_.target == "all_allies" || _loc3_.target == "master"))
            {
               return true;
            }
            _loc2_++;
         }
         return param1.tag_map.aoe && param1.tag_map.buff;
      }
      
      private function findRuthlessTarget(param1:Object, param2:Array) : Object
      {
         var _loc11_:Object = null;
         var _loc12_:Boolean = false;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:Object = null;
         var _loc3_:Object = this.findFinishableTarget(param2);
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         var _loc4_:Object;
         if((_loc4_ = this.findMainPlayerTarget(param2)) != null)
         {
            return _loc4_;
         }
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Number = 101;
         var _loc8_:Number = -1;
         var _loc9_:Boolean = this.hasAwakeOpponent(param2);
         var _loc10_:int = 0;
         while(_loc10_ < param2.length && this.evaluatedTargetCount < MAX_EVALUATED_TARGETS)
         {
            if((_loc11_ = param2[_loc10_]) && !_loc11_.health_manager.isDead())
            {
               ++this.evaluatedTargetCount;
               _loc12_ = _loc11_.effects_manager.hadEffect("sleep") || _loc11_.effects_manager.hadEffect("pet_sleep");
               _loc13_ = _loc11_.health_manager.getCurrentHP() / _loc11_.health_manager.getMaxHP();
               _loc14_ = _loc11_.health_manager.getCurrentCP();
               if(_loc12_ && param2.length > 1)
               {
                  if(_loc9_)
                  {
                     _loc10_++;
                     continue;
                  }
               }
               if(_loc13_ < _loc7_)
               {
                  _loc7_ = _loc13_;
                  _loc5_ = _loc11_;
                  _loc6_ = _loc10_;
               }
               if(_loc7_ > 0.4 && _loc14_ > _loc8_)
               {
                  _loc8_ = _loc14_;
                  _loc5_ = _loc11_;
                  _loc6_ = _loc10_;
               }
            }
            _loc10_++;
         }
         if(_loc5_ == null && param2.length > 0)
         {
            _loc15_ = 0;
            while(_loc15_ < param2.length)
            {
               if((_loc16_ = param2[_loc15_]) != null && _loc16_.health_manager != null && !_loc16_.health_manager.isDead())
               {
                  _loc5_ = _loc16_;
                  _loc6_ = _loc15_;
                  break;
               }
               _loc15_++;
            }
         }
         return {
            "model":_loc5_,
            "index":_loc6_
         };
      }
      
      private function findMainPlayerTarget(param1:Array) : Object
      {
         if(param1 == null || param1.length == 0)
         {
            return null;
         }
         var _loc2_:Object = param1[0];
         if(_loc2_ != null && _loc2_.hasOwnProperty("character_info") && _loc2_.health_manager != null && !_loc2_.health_manager.isDead())
         {
            return {
               "model":_loc2_,
               "index":0
            };
         }
         return null;
      }
      
      private function findFinishableTarget(param1:Array) : Object
      {
         var _loc7_:Object = null;
         var _loc8_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Boolean = false;
         if(param1 == null || param1.length == 0)
         {
            return null;
         }
         var _loc2_:Boolean = this.hasAwakeOpponent(param1);
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Number = FINISH_HP_RATIO;
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            if((_loc7_ = param1[_loc6_]) != null && _loc7_.health_manager != null && !_loc7_.health_manager.isDead() && _loc7_.health_manager.getMaxHP() > 0)
            {
               if(!((_loc8_ = _loc7_.effects_manager != null && (_loc7_.effects_manager.hadEffect("sleep") || _loc7_.effects_manager.hadEffect("pet_sleep"))) && _loc2_))
               {
                  _loc10_ = (_loc9_ = _loc7_.health_manager.getCurrentHP()) / _loc7_.health_manager.getMaxHP();
                  if(!(_loc11_ = this.previousTargetKey != null && this.getTargetMemoryKey(_loc7_) == this.previousTargetKey && this.previousTargetHP >= 0 && _loc9_ >= this.previousTargetHP) && _loc10_ <= _loc5_)
                  {
                     _loc5_ = _loc10_;
                     _loc3_ = _loc7_;
                     _loc4_ = _loc6_;
                  }
               }
            }
            _loc6_++;
         }
         if(_loc3_ == null)
         {
            return null;
         }
         return {
            "model":_loc3_,
            "index":_loc4_
         };
      }
      
      private function analyzeTeamState(param1:Array) : Object
      {
         var _loc11_:Object = null;
         var _loc12_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:Number = 101;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:Number = (_loc7_ = param1.length > 0 ? param1[0] : null) && !_loc7_.health_manager.isDead() ? Number(_loc7_.health_manager.getCurrentHP() / _loc7_.health_manager.getMaxHP()) : Number(1);
         var _loc9_:int = _loc7_ && !_loc7_.health_manager.isDead() ? int(this.getBuffCount(_loc7_)) : 0;
         var _loc10_:int = 0;
         while(_loc10_ < param1.length)
         {
            if((_loc11_ = param1[_loc10_]) && !_loc11_.health_manager.isDead())
            {
               _loc5_++;
               if((_loc12_ = _loc11_.health_manager.getCurrentHP() / _loc11_.health_manager.getMaxHP()) < _loc3_)
               {
                  _loc3_ = _loc12_;
                  _loc2_ = _loc10_;
               }
               if(this.getBuffCount(_loc11_) == 0)
               {
                  _loc6_++;
               }
               if(!_loc4_ && this.targetIsDisabled(_loc11_))
               {
                  _loc4_ = true;
               }
            }
            _loc10_++;
         }
         if(_loc3_ == 101)
         {
            _loc3_ = 1;
         }
         return {
            "index":_loc2_,
            "lowest_hp":_loc3_,
            "has_disabled":_loc4_,
            "priority_hp":_loc8_,
            "priority_buff_count":_loc9_,
            "alive_count":_loc5_,
            "unbuffed_count":_loc6_
         };
      }
      
      private function analyzeTargetState(param1:Object) : Object
      {
         if(param1 == null || param1.health_manager == null || param1.effects_manager == null)
         {
            return {
               "hp_ratio":1,
               "current_hp":0,
               "cp":0,
               "cp_ratio":0,
               "has_many_buffs":false,
               "has_debuff_resist":false,
               "has_flexible":false,
               "is_disabled":false,
               "is_vulnerable":false
            };
         }
         var _loc2_:Number = !!param1.health_manager ? Number(param1.health_manager.getCurrentHP() / param1.health_manager.getMaxHP()) : Number(1);
         var _loc3_:Number = !!param1.health_manager ? Number(param1.health_manager.getCurrentHP()) : Number(0);
         var _loc4_:Number = !!param1.health_manager ? Number(param1.health_manager.getCurrentCP()) : Number(0);
         var _loc5_:Number = !!param1.health_manager ? Number(param1.health_manager.getMaxCP()) : Number(0);
         return {
            "hp_ratio":_loc2_,
            "current_hp":_loc3_,
            "cp":_loc4_,
            "cp_ratio":this.ratioValue(_loc4_,_loc5_),
            "has_many_buffs":this.hasBuffs(param1,1),
            "has_debuff_resist":this.hasDebuffResistEffect(param1),
            "has_flexible":param1.effects_manager.hadEffect("flexible") || param1.effects_manager.hadEffect("pet_flexible"),
            "is_disabled":this.targetIsDisabled(param1),
            "is_vulnerable":this.targetHasVulnerability(param1)
         };
      }
      
      private function buildCombatProfile(param1:Object, param2:Object, param3:Object) : Object
      {
         var _loc4_:Number = this.getHPRatio(param1);
         var _loc5_:Number = param3.hp_ratio;
         var _loc6_:Number = this.getCPRatio(param1);
         var _loc7_:Number = param3.cp_ratio;
         var _loc8_:int = this.getDebuffCount(param1);
         var _loc9_:int = this.getBuffCount(param2);
         var _loc10_:Number = this.previousSelfHP < 0 ? Number(0) : Number(Math.max(0,this.previousSelfHP - param1.health_manager.getCurrentHP()));
         var _loc11_:Number = this.previousTargetHP < 0 ? Number(0) : Number(Math.max(0,this.previousTargetHP - param2.health_manager.getCurrentHP()));
         var _loc12_:Boolean = param3.has_debuff_resist || param3.has_flexible;
         var _loc13_:Boolean = this.hasHighValueBuff(param2);
         var _loc14_:Boolean = param2.effects_manager.hadEffect("unyielding");
         var _loc15_:Number = _loc7_ * 65 + _loc9_ * 12 + (!!_loc12_ ? 25 : 0) + (!!_loc13_ ? 25 : 0) + (!!_loc14_ ? 40 : 0) + (!!param3.is_disabled ? -35 : 0) + (_loc4_ < 0.35 ? 35 : 0) + _loc8_ * 10 + Math.min(35,this.ratioValue(_loc10_,param1.health_manager.getMaxHP()) * 120);
         var _loc16_:Number = Math.max(0,1 - _loc5_) + (_loc4_ > 0.65 ? 0.25 : 0) + Math.min(0.35,this.ratioValue(_loc11_,param2.health_manager.getMaxHP()) * 1.5);
         return {
            "self_hp_ratio":_loc4_,
            "target_hp_ratio":_loc5_,
            "self_cp_ratio":_loc6_,
            "enemy_cp_ratio":_loc7_,
            "enemy_threat":_loc15_,
            "pressure":_loc16_,
            "enemy_protected":_loc12_,
            "enemy_unyielding":_loc14_,
            "enemy_disabled":param3.is_disabled,
            "enemy_buff_count":_loc9_,
            "self_debuff_count":_loc8_,
            "has_damage_boost":this.hasDamageBoost(param1)
         };
      }
      
      private function selectIntent(param1:Object, param2:Object, param3:Object) : String
      {
         if(param1.self_hp_ratio < 0.32 || this.estimateDeathRisk(null,null,param1) > 0.8)
         {
            return INTENT_DEFENSIVE;
         }
         if(param3 != null && param3.lowest_hp < 0.35)
         {
            return INTENT_DEFENSIVE;
         }
         if(param2.is_vulnerable || param2.hp_ratio <= 0.35)
         {
            return INTENT_BURST_READY;
         }
         if(!param2.is_disabled && param1.enemy_threat >= 95 && !param1.enemy_protected)
         {
            return INTENT_CONTROL;
         }
         if(this.turnsSinceSetup > 1 && !param1.has_damage_boost && param2.hp_ratio > 0.45)
         {
            return INTENT_SETUP;
         }
         return INTENT_AGGRESSIVE;
      }
      
      private function resolvePersonality(param1:Object) : String
      {
         var _loc2_:String = this.readPersonalityField(param1);
         if(_loc2_ != null && _loc2_ != "")
         {
            return _loc2_;
         }
         var _loc3_:String = this.getActorLabel(param1).toLowerCase();
         var _loc4_:int;
         if((_loc4_ = this.stableStringBucket(_loc3_,5)) == 0)
         {
            return PERSONALITY_BERSERKER;
         }
         if(_loc4_ == 1)
         {
            return PERSONALITY_GUARDIAN;
         }
         if(_loc4_ == 2)
         {
            return PERSONALITY_TACTICIAN;
         }
         if(_loc4_ == 3)
         {
            return PERSONALITY_TRICKSTER;
         }
         return PERSONALITY_HEALER;
      }
      
      private function readPersonalityField(param1:Object) : String
      {
         var _loc2_:Object = this.getUnitInfo(param1);
         if(_loc2_ != null)
         {
            if(_loc2_.hasOwnProperty("ai_personality"))
            {
               return String(_loc2_.ai_personality);
            }
            if(_loc2_.hasOwnProperty("personality"))
            {
               return String(_loc2_.personality);
            }
            if(_loc2_.hasOwnProperty("ai_profile"))
            {
               return String(_loc2_.ai_profile);
            }
         }
         return null;
      }
      
      private function stableStringBucket(param1:String, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(param1 != null && _loc4_ < param1.length)
         {
            _loc3_ += param1.charCodeAt(_loc4_) * (_loc4_ + 1);
            _loc4_++;
         }
         return Math.abs(_loc3_) % param2;
      }
      
      private function preparePlanningMemory(param1:Object) : void
      {
         this.followedPreviousPlan = false;
         this.planAbandonReason = "";
         if(this.turnsSinceSetup < 99)
         {
            ++this.turnsSinceSetup;
         }
         if(this.plannedTarget != null && this.plannedTarget != this.getTargetMemoryKey(param1))
         {
            this.planAbandonReason = "planned target changed or became lower priority";
         }
      }
      
      private function hasAwakeOpponent(param1:Array) : Boolean
      {
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc2_ < param1.length && _loc3_ < MAX_EVALUATED_TARGETS)
         {
            if((_loc4_ = param1[_loc2_]) && !_loc4_.health_manager.isDead())
            {
               _loc3_++;
               if(!_loc4_.effects_manager.hadEffect("sleep") && !_loc4_.effects_manager.hadEffect("pet_sleep"))
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
      
      private function findReadySkillByType(param1:Object, param2:String, param3:Boolean = false, param4:String = null) : Object
      {
         var _loc7_:Object = null;
         var _loc8_:* = undefined;
         var _loc9_:Boolean = false;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc5_:String = param2 + "|" + param3 + "|" + (param4 != null ? param4 : "");
         if(this.skillQueryCache.hasOwnProperty(_loc5_))
         {
            return this.cloneSkillChoice(this.skillQueryCache[_loc5_]);
         }
         var _loc6_:Object = null;
         if(param1.hasOwnProperty("actions_manager"))
         {
            _loc7_ = param1.actions_manager;
            _loc8_ = null;
            if(_loc8_ = this.searchArrayForType(param1,_loc7_.character_skills_mc,param2,2,param3,param4))
            {
               _loc6_ = this.chooseHigherReadyTypeSkill(_loc6_,_loc8_);
            }
            if(_loc8_ = this.searchArrayForType(param1,_loc7_.character_talent_skills_mc,param2,3,param3,param4))
            {
               _loc6_ = this.chooseHigherReadyTypeSkill(_loc6_,_loc8_);
            }
            if(_loc8_ = this.searchArrayForType(param1,_loc7_.character_senjutsu_skills_mc,param2,4,param3,param4))
            {
               _loc6_ = this.chooseHigherReadyTypeSkill(_loc6_,_loc8_);
            }
            if(_loc7_.class_skill && _loc7_.class_skill.getCurrentCooldown() <= 0 && this.canAffordCharacterSkill(param1,_loc7_.class_skill.skill_info,5) && this.detectTypeFromEffects(_loc7_.class_skill.skill_info.effects,param2,param4))
            {
               _loc9_ = _loc7_.class_skill.skill_info.is_aoe || _loc7_.class_skill.skill_info.multi_hit;
               if(!param3 || param3 && _loc9_)
               {
                  _loc6_ = this.chooseHigherReadyTypeSkill(_loc6_,{
                     "type":5,
                     "index":0,
                     "is_aoe":_loc9_,
                     "score":this.scoreReadyTypeChoice(_loc7_.class_skill.skill_info,param2,param3,param4,_loc9_,5000)
                  });
               }
            }
         }
         else if(_loc10_ = this.getUnitInfo(param1))
         {
            if((_loc11_ = this.findIndexByType(_loc10_.attacks,_loc10_.curr_skill_cooldowns,param2,param3,param4,_loc10_.skills_available)) != -1)
            {
               _loc12_ = _loc10_.attacks[_loc11_];
               _loc6_ = {
                  "type":-1,
                  "index":_loc11_,
                  "is_aoe":_loc12_.multi_hit || _loc12_.is_aoe,
                  "score":this.scoreReadyTypeChoice(_loc12_,param2,param3,param4,_loc12_.multi_hit || _loc12_.is_aoe,_loc11_)
               };
            }
         }
         this.skillQueryCache[_loc5_] = _loc6_;
         return this.cloneSkillChoice(_loc6_);
      }
      
      private function searchArrayForType(param1:Object, param2:Array, param3:String, param4:int, param5:Boolean = false, param6:String = null) : Object
      {
         var _loc10_:Object = null;
         var _loc11_:Boolean = false;
         if(!param2)
         {
            return null;
         }
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = param2.length;
         while(_loc8_ < _loc9_)
         {
            if((_loc10_ = param2[_loc8_]) && _loc10_.getCurrentCooldown() <= 0 && this.canAffordCharacterSkill(param1,_loc10_.skill_info,param4) && this.detectTypeFromEffects(_loc10_.skill_info.effects,param3,param6))
            {
               _loc11_ = _loc10_.skill_info.is_aoe || _loc10_.skill_info.multi_hit;
               if(!param5 || param5 && _loc11_)
               {
                  _loc7_ = this.chooseHigherReadyTypeSkill(_loc7_,{
                     "type":param4,
                     "index":_loc8_,
                     "is_aoe":_loc11_,
                     "score":this.scoreReadyTypeChoice(_loc10_.skill_info,param3,param5,param6,_loc11_,param4 * 1000 + _loc8_)
                  });
               }
            }
            _loc8_++;
         }
         return _loc7_;
      }
      
      private function findIndexByType(param1:Array, param2:Array, param3:String, param4:Boolean = false, param5:String = null, param6:Array = null) : int
      {
         var _loc11_:Object = null;
         var _loc12_:Array = null;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         if(!param1)
         {
            return -1;
         }
         var _loc7_:int = -1;
         var _loc8_:Number = -999999;
         var _loc9_:int = 0;
         var _loc10_:int = param1.length;
         while(_loc9_ < _loc10_)
         {
            if(!(_loc11_ = param1[_loc9_]))
            {
               _loc9_++;
            }
            else
            {
               _loc12_ = !!_loc11_.hasOwnProperty("effects") ? _loc11_.effects : [];
               _loc13_ = Boolean(_loc11_.multi_hit) || Boolean(_loc11_.is_aoe);
               _loc14_ = param2 && _loc9_ < param2.length ? int(int(param2[_loc9_])) : 0;
               if(param6 != null && _loc9_ < param6.length && int(param6[_loc9_]) == 0)
               {
                  _loc9_++;
               }
               else
               {
                  if(_loc14_ <= 0 && (_loc11_.type == param3 || this.detectTypeFromEffects(_loc12_,param3,param5)))
                  {
                     if(!param4 || param4 && _loc13_)
                     {
                        _loc15_ = this.scoreReadyTypeChoice(_loc11_,param3,param4,param5,_loc13_,_loc9_);
                        if(_loc7_ == -1 || _loc15_ > _loc8_)
                        {
                           _loc8_ = _loc15_;
                           _loc7_ = _loc9_;
                        }
                     }
                  }
                  _loc9_++;
               }
            }
         }
         return _loc7_;
      }
      
      private function chooseHigherReadyTypeSkill(param1:Object, param2:Object) : Object
      {
         if(param2 == null)
         {
            return param1;
         }
         if(param1 == null || param2.score > param1.score)
         {
            return param2;
         }
         return param1;
      }
      
      private function scoreReadyTypeChoice(param1:Object, param2:String, param3:Boolean, param4:String, param5:Boolean, param6:int) : Number
      {
         var _loc7_:Object = this.buildSkillMetadata(param1);
         var _loc8_:Number = 0;
         if(param2 == TYPE_HEAL)
         {
            _loc8_ += 120 + this.scoreUtilityEffects(_loc7_.effects,null);
         }
         else if(param2 == TYPE_PURIFY)
         {
            _loc8_ += 105;
         }
         else if(param2 == TYPE_RESIST)
         {
            _loc8_ += 95;
         }
         else if(param2 == TYPE_DISPERSE)
         {
            _loc8_ += 90;
         }
         else if(param2 == TYPE_STUN)
         {
            _loc8_ += 100;
         }
         else if(param2 == TYPE_BUFF)
         {
            _loc8_ += this.scoreCheapSetupValue(_loc7_,null);
         }
         else
         {
            _loc8_ += _loc7_.damage * 80 + this.scoreUtilityEffects(_loc7_.effects,null);
         }
         if(param3 && param5)
         {
            _loc8_ += 45;
         }
         if(param4 != null && this.metadataTargetsSelf(_loc7_) && param4 == "self")
         {
            _loc8_ += 35;
         }
         return Number((_loc8_ = (_loc8_ += this.getMetadataChanceFactor(_loc7_) * 30) + this.getMetadataDurationFactor(_loc7_) * 20) - param6 * 0.001);
      }
      
      private function detectTypeFromEffects(param1:Array, param2:String, param3:String = null) : Boolean
      {
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         if(!param1)
         {
            return false;
         }
         var _loc4_:Object;
         if((_loc4_ = EFFECT_TYPE_MAP[param2]) == null)
         {
            return false;
         }
         var _loc5_:int = 0;
         var _loc6_:int = param1.length;
         while(_loc5_ < _loc6_)
         {
            if((_loc7_ = param1[_loc5_]) == null)
            {
               _loc5_++;
            }
            else
            {
               _loc8_ = _loc7_.effect;
               _loc9_ = _loc7_.target;
               if((!param3 || _loc9_ == param3) && (_loc4_[_loc8_] || this.isRegisteredGenericEffectType(_loc8_,param2)))
               {
                  return true;
               }
               _loc5_++;
            }
         }
         return false;
      }
      
      private function isRegisteredGenericEffectType(param1:String, param2:String) : Boolean
      {
         if(param1 == null || param1 == "")
         {
            return false;
         }
         if(param2 == TYPE_BUFF)
         {
            return Effects.all_buffs != null && Effects.all_buffs.hasOwnProperty(param1) && !this.isReservedBuffEffect(param1);
         }
         if(param2 == TYPE_DEBUFF)
         {
            return Effects.all_debuffs != null && Effects.all_debuffs.hasOwnProperty(param1) && !this.isReservedDebuffEffect(param1);
         }
         return false;
      }
      
      private function isReservedBuffEffect(param1:String) : Boolean
      {
         return EFFECT_TYPE_MAP.purify[param1] || EFFECT_TYPE_MAP.heal[param1] || EFFECT_TYPE_MAP.resist[param1] || EFFECT_TYPE_MAP.disperse[param1];
      }
      
      private function isReservedDebuffEffect(param1:String) : Boolean
      {
         return EFFECT_TYPE_MAP.stun[param1] || EFFECT_TYPE_MAP.drain[param1] || EFFECT_TYPE_MAP.disperse[param1];
      }
      
      private function targetIsDisabled(param1:Object) : Boolean
      {
         if(param1 == null || param1.effects_manager == null)
         {
            return false;
         }
         return param1.effects_manager.hadEffect("stun") || param1.effects_manager.hadEffect("pet_stun") || param1.effects_manager.hadEffect("locked") || param1.effects_manager.hadEffect("sleep") || param1.effects_manager.hadEffect("pet_sleep") || param1.effects_manager.hadEffect("internal_injury") || param1.effects_manager.hadEffect("restriction") || param1.effects_manager.hadEffect("pet_restriction") || param1.effects_manager.hadEffect("chaos") || param1.effects_manager.hadEffect("pet_chaos") || param1.effects_manager.hadEffect("frozen") || param1.effects_manager.hadEffect("pet_frozen") || param1.effects_manager.hadEffect("chill") || param1.effects_manager.hadEffect("prison") || param1.effects_manager.hadEffect("pet_prison") || param1.effects_manager.hadEffect("petrify") || param1.effects_manager.hadEffect("pet_petrify") || param1.effects_manager.hadEffect("toxic_tooth") || param1.effects_manager.hadEffect("fear") || param1.effects_manager.hadEffect("pet_fear") || param1.effects_manager.hadEffect("time_stop") || param1.effects_manager.hadEffect("barrier");
      }
      
      private function selectBestMove(param1:Object, param2:Object = null) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc3_:Object = this.getUnitInfo(param1);
         if(param1.hasOwnProperty("actions_manager"))
         {
            return (_loc4_ = this.selectBestCharacterOffense(param1,param2)) != null ? _loc4_ : {
               "type":1,
               "index":0
            };
         }
         if(_loc3_ != null)
         {
            _loc5_ = this.findAvailableOffenseIndex(_loc3_.attacks,_loc3_.curr_skill_cooldowns,param2,_loc3_.skills_available);
            return {
               "type":-1,
               "index":(_loc5_ >= 0 ? _loc5_ : 0)
            };
         }
         return {
            "type":-1,
            "index":0
         };
      }
      
      private function selectBestCharacterOffense(param1:Object, param2:Object = null) : Object
      {
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(!param1.hasOwnProperty("actions_manager") || param1.actions_manager == null)
         {
            return null;
         }
         var _loc3_:Object = param1.actions_manager;
         var _loc4_:Object = null;
         _loc4_ = this.chooseHigherScoredSkill(_loc4_,this.findBestSkillInArray(param1,_loc3_.character_skills_mc,2,param2));
         _loc4_ = this.chooseHigherScoredSkill(_loc4_,this.findBestSkillInArray(param1,_loc3_.character_talent_skills_mc,3,param2));
         _loc4_ = this.chooseHigherScoredSkill(_loc4_,this.findBestSkillInArray(param1,_loc3_.character_senjutsu_skills_mc,4,param2));
         if(_loc3_.class_skill && _loc3_.class_skill.getCurrentCooldown() <= 0 && this.canAffordCharacterSkill(param1,_loc3_.class_skill.skill_info,5))
         {
            _loc5_ = _loc3_.class_skill.skill_info;
            if(!this.isSupportSkillInfo(_loc5_))
            {
               _loc6_ = Boolean(_loc5_.is_aoe) || Boolean(_loc5_.multi_hit);
               _loc7_ = this.estimateSkillInfoDamage(_loc5_);
               _loc8_ = this.scoreSkillChoice(_loc5_.effects,_loc7_,_loc6_,this.getActionKey(5,0),param2);
               _loc4_ = this.chooseHigherScoredSkill(_loc4_,{
                  "type":5,
                  "index":0,
                  "is_aoe":_loc6_,
                  "estimated_damage":_loc7_,
                  "score":_loc8_
               });
            }
         }
         if(_loc4_ == null)
         {
            return null;
         }
         return {
            "type":_loc4_.type,
            "index":_loc4_.index,
            "is_aoe":_loc4_.is_aoe
         };
      }
      
      private function findBestSkillInArray(param1:Object, param2:Array, param3:int, param4:Object = null) : Object
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Boolean = false;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(!param2)
         {
            return null;
         }
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = param2.length;
         while(_loc6_ < _loc7_)
         {
            if((_loc8_ = param2[_loc6_]) && _loc8_.getCurrentCooldown() <= 0 && this.canAffordCharacterSkill(param1,_loc8_.skill_info,param3) && !this.isSupportSkillInfo(_loc8_.skill_info))
            {
               _loc9_ = _loc8_.skill_info;
               _loc10_ = Boolean(_loc9_.is_aoe) || Boolean(_loc9_.multi_hit);
               _loc11_ = this.estimateSkillInfoDamage(_loc9_);
               _loc12_ = this.scoreSkillChoice(_loc9_.effects,_loc11_,_loc10_,this.getActionKey(param3,_loc6_),param4);
               _loc5_ = this.chooseHigherScoredSkill(_loc5_,{
                  "type":param3,
                  "index":_loc6_,
                  "is_aoe":_loc10_,
                  "estimated_damage":_loc11_,
                  "score":_loc12_
               });
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      private function chooseHigherScoredSkill(param1:Object, param2:Object) : Object
      {
         if(param2 == null)
         {
            return param1;
         }
         if(param1 == null || param2.score > param1.score)
         {
            return param2;
         }
         return param1;
      }
      
      private function estimateSkillInfoDamage(param1:Object) : Number
      {
         if(param1 == null)
         {
            return 0;
         }
         if(param1.hasOwnProperty("skill_damage"))
         {
            return Number(param1.skill_damage);
         }
         if(param1.hasOwnProperty("talent_skill_damage"))
         {
            return Number(param1.talent_skill_damage);
         }
         if(param1.hasOwnProperty("damage"))
         {
            return Number(param1.damage);
         }
         return 0;
      }
      
      private function isSupportSkillInfo(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return true;
         }
         if(this.detectTypeFromEffects(param1.effects,TYPE_PURIFY) || this.detectTypeFromEffects(param1.effects,TYPE_RESIST))
         {
            return true;
         }
         return false;
      }
      
      private function canAffordCharacterSkill(param1:Object, param2:Object, param3:int) : Boolean
      {
         if(param1 == null || param1.health_manager == null || param2 == null)
         {
            return false;
         }
         if(param3 == 4)
         {
            return param1.health_manager.hasEnoughSPForSkill(param2);
         }
         if(param2.hasOwnProperty("skill_cp_cost") || param2.hasOwnProperty("talent_skill_cp_cost"))
         {
            return param1.health_manager.hasEnoughCPForSkill(param2);
         }
         return true;
      }
      
      private function findAvailableOffenseIndex(param1:Array, param2:Array, param3:Object = null, param4:Array = null) : int
      {
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Array = null;
         var _loc13_:Boolean = false;
         var _loc14_:Number = NaN;
         if(!param1 || param1.length == 0)
         {
            return -1;
         }
         var _loc5_:int = -1;
         var _loc6_:Number = -999999;
         var _loc7_:int = 0;
         var _loc8_:int = param1.length;
         while(_loc7_ < _loc8_)
         {
            if(!(_loc9_ = param1[_loc7_]))
            {
               _loc7_++;
            }
            else
            {
               _loc10_ = param2 && _loc7_ < param2.length ? int(int(param2[_loc7_])) : 0;
               if(param4 != null && _loc7_ < param4.length && int(param4[_loc7_]) == 0)
               {
                  _loc7_++;
               }
               else
               {
                  _loc11_ = !!_loc9_.hasOwnProperty("dmg") ? Number(Number(_loc9_.dmg)) : Number(0);
                  if(_loc10_ <= 0 && _loc9_.type != TYPE_PURIFY && _loc9_.type != TYPE_RESIST)
                  {
                     _loc12_ = !!_loc9_.hasOwnProperty("effects") ? _loc9_.effects : [];
                     _loc13_ = Boolean(_loc9_.multi_hit) || Boolean(_loc9_.is_aoe);
                     if((_loc14_ = this.scoreSkillChoice(_loc12_,_loc11_,_loc13_,this.getActionKey(-1,_loc7_),param3)) > _loc6_)
                     {
                        _loc6_ = _loc14_;
                        _loc5_ = _loc7_;
                     }
                  }
                  _loc7_++;
               }
            }
         }
         return _loc5_;
      }
      
      private function scoreSkillChoice(param1:Array, param2:Number, param3:Boolean, param4:String, param5:Object = null) : Number
      {
         var _loc6_:Number = param2;
         if(param3)
         {
            _loc6_ += 35;
         }
         if(param5 != null)
         {
            if(param5.target_hp_ratio < 0.4)
            {
               _loc6_ += 60;
            }
            if(param5.enemy_disabled)
            {
               _loc6_ += 45;
            }
            if(param5.pressure > 0)
            {
               _loc6_ += param5.pressure * 80;
            }
            if(param5.enemy_threat > 100)
            {
               _loc6_ += 35;
            }
            if(param5.has_damage_boost)
            {
               _loc6_ += param2 * 0.35;
            }
            if(param5.enemy_protected && this.hasEnemyControlEffect(param1))
            {
               _loc6_ -= 180;
            }
         }
         return Number((_loc6_ += this.scoreUtilityEffects(param1,param5)) - this.getRepeatPenalty(param4));
      }
      
      private function scoreUtilityEffects(param1:Array, param2:Object = null) : Number
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(!param1)
         {
            return 0;
         }
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if((_loc5_ = param1[_loc4_]) != null)
            {
               _loc6_ = _loc5_.effect;
               _loc7_ = _loc5_.target;
               if(EFFECT_TYPE_MAP.disperse[_loc6_])
               {
                  _loc3_ += param2 != null && (param2.enemy_protected || param2.enemy_buff_count > 0) ? 140 : 40;
               }
               else if(EFFECT_TYPE_MAP.stun[_loc6_])
               {
                  _loc3_ += param2 != null && !param2.enemy_disabled && !param2.enemy_protected ? 110 : 25;
               }
               else if(EFFECT_TYPE_MAP.drain[_loc6_])
               {
                  _loc3_ += param2 != null && param2.enemy_cp_ratio >= 0.4 && !param2.enemy_protected ? 80 : 20;
               }
               else if(EFFECT_TYPE_MAP.debuff[_loc6_])
               {
                  _loc3_ += this.scoreDebuffEffect(_loc6_,param2);
               }
               else if(_loc7_ == "self" && EFFECT_TYPE_MAP.heal[_loc6_])
               {
                  _loc3_ += param2 != null ? (1 - param2.self_hp_ratio) * 180 + (param2.enemy_threat > 120 ? 35 : 0) : 45;
               }
               else if(_loc7_ == "self" && EFFECT_TYPE_MAP.resist[_loc6_])
               {
                  _loc3_ += param2 != null && param2.enemy_threat > 90 ? 80 : 25;
               }
               else if(_loc7_ == "self" && EFFECT_TYPE_MAP.buff[_loc6_])
               {
                  _loc3_ += this.scoreSelfBuffEffect(_loc6_,param2);
               }
               else if(_loc7_ == "self" && this.detectSingleEffectType(_loc5_,TYPE_BUFF))
               {
                  _loc3_ += this.scoreSelfBuffEffect(_loc6_,param2);
               }
               else if(this.detectSingleEffectType(_loc5_,TYPE_DEBUFF))
               {
                  _loc3_ += this.scoreDebuffEffect(_loc6_,param2);
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function scoreSelfBuffEffect(param1:String, param2:Object = null) : Number
      {
         var _loc3_:Number = 35;
         if(HIGH_VALUE_ENEMY_BUFFS[param1])
         {
            _loc3_ += 75;
         }
         if(DAMAGE_BOOST_EFFECTS[param1])
         {
            _loc3_ += 55;
         }
         if(DEFENSIVE_BUFF_EFFECTS[param1])
         {
            _loc3_ += param2 != null && param2.enemy_threat >= 90 ? 55 : 30;
         }
         if(param1 == "unyielding_soul" || param1 == "cannot_reduced_cp" || param1 == "bleeding_protection")
         {
            _loc3_ += param2 != null && param2.enemy_threat >= 90 ? 80 : 45;
         }
         if(param2 != null && param2.self_hp_ratio < 0.45)
         {
            _loc3_ += 35;
         }
         return _loc3_;
      }
      
      private function scoreDebuffEffect(param1:String, param2:Object = null) : Number
      {
         var _loc3_:Number = 25;
         var _loc4_:Boolean = param2 != null && param2.enemy_protected;
         if(OFFENSIVE_DEBUFF_EFFECTS[param1])
         {
            _loc3_ += !!_loc4_ ? 10 : 115;
            if(param2 != null && param2.pressure > 0.25)
            {
               _loc3_ += 25;
            }
         }
         else if(TEMPO_DEBUFF_EFFECTS[param1])
         {
            _loc3_ += !!_loc4_ ? 5 : 90;
            if(param2 != null && !param2.enemy_disabled)
            {
               _loc3_ += 20;
            }
         }
         else if(RESOURCE_DEBUFF_EFFECTS[param1])
         {
            _loc3_ += !!_loc4_ ? 5 : 55;
            if(param2 != null && param2.enemy_cp_ratio >= 0.45)
            {
               _loc3_ += 35;
            }
         }
         else
         {
            _loc3_ += !!_loc4_ ? 0 : 35;
         }
         return _loc3_;
      }
      
      private function detectSingleEffectType(param1:Object, param2:String, param3:String = null) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc4_:Object;
         if((_loc4_ = EFFECT_TYPE_MAP[param2]) == null)
         {
            return false;
         }
         var _loc5_:String = param1.effect;
         var _loc6_:String = param1.target;
         return (!param3 || _loc6_ == param3) && (_loc4_[_loc5_] || this.isRegisteredGenericEffectType(_loc5_,param2));
      }
      
      private function hasEnemyControlEffect(param1:Array) : Boolean
      {
         return this.detectTypeFromEffects(param1,TYPE_STUN) || this.detectTypeFromEffects(param1,TYPE_DRAIN) || this.detectTypeFromEffects(param1,TYPE_DEBUFF);
      }
      
      private function getUnitInfo(param1:Object) : Object
      {
         if(param1.hasOwnProperty("enemy_info"))
         {
            return param1.enemy_info;
         }
         if(param1.hasOwnProperty("npc_info"))
         {
            return param1.npc_info;
         }
         if(param1.hasOwnProperty("pet_info"))
         {
            return param1.pet_info;
         }
         return null;
      }
      
      private function resetSkillQueryCache() : void
      {
         this.skillQueryCache = {};
      }
      
      private function resetPerformanceCounters() : void
      {
         this.evaluatedSkillCount = 0;
         this.evaluatedTargetCount = 0;
         this.lookaheadEvaluationCount = 0;
         this.decisionTimeMs = 0;
         this.decisionStartMs = getTimer();
         this.lastDecisionReport = null;
      }
      
      private function finishPerformanceCounters() : void
      {
         if(this.decisionStartMs > 0)
         {
            this.decisionTimeMs = getTimer() - this.decisionStartMs;
         }
      }
      
      private function canEvaluateMoreLookahead() : Boolean
      {
         return this.lookaheadEvaluationCount < MAX_LOOKAHEAD_CANDIDATES;
      }
      
      private function shouldKeepDebugReport() : Boolean
      {
         return ENABLE_AI_LOG || ENABLE_AI_PROFILE;
      }
      
      private function buildPerformanceReport() : Object
      {
         return {
            "evaluatedSkillCount":this.evaluatedSkillCount,
            "evaluatedTargetCount":this.evaluatedTargetCount,
            "lookaheadEvaluationCount":this.lookaheadEvaluationCount,
            "decisionTimeMs":this.decisionTimeMs,
            "maxEvaluatedSkills":MAX_EVALUATED_SKILLS,
            "maxEvaluatedTargets":MAX_EVALUATED_TARGETS,
            "maxLookaheadCandidates":MAX_LOOKAHEAD_CANDIDATES,
            "selectedIntent":this.currentIntent,
            "selectedPersonality":this.currentPersonality,
            "plannedTarget":this.plannedTarget,
            "plannedSkill":this.plannedSkill,
            "plannedIntent":this.plannedIntent,
            "lastSetupTarget":this.lastSetupTarget,
            "turnsSinceSetup":this.turnsSinceSetup,
            "followedPreviousPlan":this.followedPreviousPlan,
            "planAbandonReason":this.planAbandonReason
         };
      }
      
      private function cloneSkillChoice(param1:Object) : Object
      {
         if(param1 == null)
         {
            return null;
         }
         return {
            "type":param1.type,
            "index":param1.index,
            "is_aoe":param1.is_aoe
         };
      }
      
      private function finalizeAction(param1:Object, param2:int, param3:Boolean = false, param4:Object = null, param5:String = "") : Object
      {
         if(param1 == null)
         {
            return null;
         }
         if(this.decisionTimeMs == 0)
         {
            this.finishPerformanceCounters();
         }
         param1.target = param2;
         if(param3)
         {
            param1.is_friendly_target = true;
         }
         this.recordTeamTacticalIntent(param4,param1);
         this.recordActionMemory(param4,param1);
         if(this.shouldKeepDebugReport() && this.lastDecisionReport == null)
         {
            this.lastDecisionReport = {
               "turn":this.decisionTurn,
               "scores":null,
               "selected":{
                  "action":param1,
                  "reason":param5,
                  "intent":this.currentIntent,
                  "personality":this.currentPersonality
               },
               "overrides":null,
               "profile":this.buildPerformanceReport()
            };
         }
         return this.logActionDecision(param4,param1,param5);
      }
      
      private function logActionDecision(param1:Object, param2:Object, param3:String) : Object
      {
         if(!ENABLE_AI_LOG || param2 == null)
         {
            return param2;
         }
         var _loc4_:String = "[AI] " + this.getActorLabel(param1) + " | " + param3 + " | " + this.describeActionType(param2.type) + " idx:" + param2.index + " tgt:" + (!!param2.hasOwnProperty("target") ? param2.target : "-");
         return param2;
      }
      
      private function recordTeamTacticalIntent(param1:Object, param2:Object) : void
      {
         var _loc6_:Object = null;
         if(param1 == null || param2 == null || param2.hasOwnProperty("is_friendly_target") && param2.is_friendly_target)
         {
            return;
         }
         var _loc3_:Object = this.currentTargetModel;
         var _loc4_:Object = this.getSkillFromAction(param1,param2);
         if(_loc3_ == null || _loc4_ == null || _loc4_.effects == null)
         {
            return;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.effects.length)
         {
            if((_loc6_ = _loc4_.effects[_loc5_]) != null && this.detectSingleEffectType(_loc6_,TYPE_DEBUFF))
            {
               TEAM_TACTICAL_MEMORY[this.getTeamMemoryKey(param1) + "|" + this.getTargetMemoryKey(_loc3_)] = {
                  "effect":_loc6_.effect,
                  "turn":this.decisionTurn + 1,
                  "actor":this.getActorLabel(param1)
               };
               return;
            }
            _loc5_++;
         }
      }
      
      private function updatePlanningTelemetry(param1:Object, param2:Object) : void
      {
         if(param1 == null || param1.action == null)
         {
            return;
         }
         var _loc3_:String = this.getTargetMemoryKey(param2);
         var _loc4_:String = this.getActionKey(param1.action.type,param1.action.index);
         this.followedPreviousPlan = this.plannedTarget == _loc3_ && (this.plannedSkill == _loc4_ || this.plannedIntent == param1.intent);
         if(!this.followedPreviousPlan && this.plannedTarget != null && this.planAbandonReason == "")
         {
            this.planAbandonReason = "higher priority override or score won";
         }
         if(param1.metadata.tag_map.setup || param1.metadata.tag_map.buff || param1.metadata.tag_map.debuff)
         {
            this.plannedTarget = _loc3_;
            this.plannedSkill = null;
            if(param1.metadata.tag_map.control)
            {
               this.plannedIntent = INTENT_CONTROL;
            }
            else if(param1.metadata.tag_map.setup || param1.metadata.tag_map.buff || this.hasVulnerabilityMetadataEffect(param1.metadata) || this.targetHasVulnerability(param2))
            {
               this.plannedIntent = INTENT_SETUP;
               this.lastSetupTarget = _loc3_;
               this.turnsSinceSetup = 0;
            }
            else
            {
               this.plannedIntent = param1.intent;
            }
         }
         else
         {
            this.plannedTarget = _loc3_;
            this.plannedSkill = _loc4_;
            this.plannedIntent = param1.intent;
         }
      }
      
      private function getSelfTargetIndex(param1:Object) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         if("player_number" in param1)
         {
            return int(param1.player_number);
         }
         if("pet_number" in param1)
         {
            return int(param1.pet_number);
         }
         if("getPlayerNumber" in param1)
         {
            return int(param1.getPlayerNumber());
         }
         return 0;
      }
      
      private function getActorLabel(param1:Object) : String
      {
         if(param1 == null)
         {
            return "Unit";
         }
         if(param1.hasOwnProperty("player_identification") && param1.player_identification)
         {
            return String(param1.player_identification);
         }
         if(param1.hasOwnProperty("enemy_info") && param1.enemy_info && param1.enemy_info.hasOwnProperty("enemy_id"))
         {
            return "Enemy#" + String(param1.enemy_info.enemy_id);
         }
         if(param1.hasOwnProperty("npc_info") && param1.npc_info && param1.npc_info.hasOwnProperty("npc_id"))
         {
            return "Npc#" + String(param1.npc_info.npc_id);
         }
         if(param1.hasOwnProperty("pet_info") && param1.pet_info && param1.pet_info.hasOwnProperty("pet_id"))
         {
            return "Pet#" + String(param1.pet_info.pet_id);
         }
         return "Unit#" + String(this.getSelfTargetIndex(param1));
      }
      
      private function describeActionType(param1:int) : String
      {
         if(param1 == 1)
         {
            return "serangan biasa";
         }
         if(param1 == 2)
         {
            return "skill normal";
         }
         if(param1 == 3)
         {
            return "skill talent";
         }
         if(param1 == 4)
         {
            return "skill senjutsu";
         }
         if(param1 == 5)
         {
            return "skill class";
         }
         if(param1 == 6)
         {
            return "charge";
         }
         if(param1 == -1)
         {
            return "skill enemy/npc/pet";
         }
         return "aksi tidak dikenal";
      }
      
      private function hasDebuffs(param1:Object) : Boolean
      {
         return param1.effects_manager.dataDebuff.length > 0;
      }
      
      private function hasBuffs(param1:Object, param2:int = 0) : Boolean
      {
         return param1.effects_manager.dataBuff.length > param2;
      }
      
      private function getHPRatio(param1:Object) : Number
      {
         if(param1 == null || param1.health_manager == null)
         {
            return 1;
         }
         return this.ratioValue(param1.health_manager.getCurrentHP(),param1.health_manager.getMaxHP());
      }
      
      private function getCPRatio(param1:Object) : Number
      {
         if(param1 == null || param1.health_manager == null)
         {
            return 0;
         }
         return this.ratioValue(param1.health_manager.getCurrentCP(),param1.health_manager.getMaxCP());
      }
      
      private function getSPRatio(param1:Object) : Number
      {
         if(param1 == null || param1.health_manager == null)
         {
            return 0;
         }
         return this.ratioValue(param1.health_manager.getCurrentSP(),param1.health_manager.getMaxSP());
      }
      
      private function canCharge(param1:Object) : Boolean
      {
         if(param1 == null || param1.effects_manager == null)
         {
            return false;
         }
         return !param1.effects_manager.hadEffect("charge_disable") && !param1.effects_manager.hadEffect("pet_charge_disable") && !param1.effects_manager.hadEffect("meridian_seal") && !param1.effects_manager.hadEffect("domain_expansion");
      }
      
      private function ratioValue(param1:Number, param2:Number) : Number
      {
         if(param2 <= 0)
         {
            return 0;
         }
         return param1 / param2;
      }
      
      private function getBuffCount(param1:Object) : int
      {
         if(param1 == null || param1.effects_manager == null || param1.effects_manager.dataBuff == null)
         {
            return 0;
         }
         return param1.effects_manager.dataBuff.length;
      }
      
      private function getDebuffCount(param1:Object) : int
      {
         if(param1 == null || param1.effects_manager == null || param1.effects_manager.dataDebuff == null)
         {
            return 0;
         }
         return param1.effects_manager.dataDebuff.length;
      }
      
      private function hasDamageBoost(param1:Object) : Boolean
      {
         return this.hasAnyActiveEffect(param1,DAMAGE_BOOST_EFFECTS);
      }
      
      private function hasHighValueBuff(param1:Object) : Boolean
      {
         return this.hasAnyActiveEffect(param1,HIGH_VALUE_ENEMY_BUFFS);
      }
      
      private function hasDebuffResistEffect(param1:Object) : Boolean
      {
         if(param1 == null || param1.effects_manager == null)
         {
            return false;
         }
         return param1.effects_manager.hadEffect("debuff_resist") || param1.effects_manager.hadEffect("pet_debuff_resist") || param1.effects_manager.hadEffect("bless") || param1.effects_manager.hadEffect("unyielding") || param1.effects_manager.hadEffect("time_stop");
      }
      
      private function hasAnyActiveEffect(param1:Object, param2:Object) : Boolean
      {
         var _loc5_:Object = null;
         if(param1 == null || param1.effects_manager == null || param1.effects_manager.dataBuff == null)
         {
            return false;
         }
         var _loc3_:Object = param1.effects_manager.dataBuff;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc5_ = _loc3_[_loc4_]) != null && param2[_loc5_.effect])
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function getActionKey(param1:int, param2:int) : String
      {
         return String(param1) + ":" + String(param2);
      }
      
      private function getRepeatPenalty(param1:String) : Number
      {
         if(param1 == null)
         {
            return 0;
         }
         var _loc2_:int = !!this.usedSkillCounts.hasOwnProperty(param1) ? int(int(this.usedSkillCounts[param1])) : 0;
         var _loc3_:Number = _loc2_ * 24;
         if(this.lastSkillKey == param1)
         {
            _loc3_ += 90;
         }
         return _loc3_;
      }
      
      private function recordActionMemory(param1:Object, param2:Object) : void
      {
         if(param1 == null || param2 == null)
         {
            return;
         }
         ++this.decisionTurn;
         var _loc3_:String = this.getActionKey(param2.type,param2.index);
         this.lastSkillKey = _loc3_;
         this.usedSkillCounts[_loc3_] = !!this.usedSkillCounts.hasOwnProperty(_loc3_) ? int(this.usedSkillCounts[_loc3_]) + 1 : 1;
         if(param1.health_manager != null)
         {
            this.previousSelfHP = param1.health_manager.getCurrentHP();
         }
         var _loc4_:Object;
         if((_loc4_ = this.getRememberedTarget(param2)) != null && _loc4_.health_manager != null)
         {
            this.previousTargetKey = this.getTargetMemoryKey(_loc4_);
            this.previousTargetHP = _loc4_.health_manager.getCurrentHP();
         }
         else
         {
            this.previousTargetKey = null;
         }
      }
      
      private function getRememberedTarget(param1:Object) : Object
      {
         if(param1 == null || param1.hasOwnProperty("is_friendly_target") && param1.is_friendly_target)
         {
            return null;
         }
         return this.currentTargetModel;
      }
      
      private function hasActiveEffectFromAction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         var _loc5_:Object = null;
         if(param1 == null || param1.effects_manager == null)
         {
            return false;
         }
         var _loc4_:Object;
         if((_loc4_ = this.getSkillFromAction(param2,param3)) == null || _loc4_.effects == null)
         {
            return false;
         }
         for each(_loc5_ in _loc4_.effects)
         {
            if(_loc5_ != null && _loc5_.type == "Buff" && param1.effects_manager.hadEffect(_loc5_.effect))
            {
               return true;
            }
         }
         return false;
      }
      
      private function getSkillFromAction(param1:Object, param2:Object) : Object
      {
         if(param1 != null && param1.hasOwnProperty("actions_manager") && param1.actions_manager != null && param2 != null)
         {
            return this.getCharacterSkillFromAction(param1.actions_manager,param2);
         }
         var _loc3_:Object = this.getUnitInfo(param1);
         if(_loc3_ == null || _loc3_.attacks == null || param2 == null || param2.index < 0 || param2.index >= _loc3_.attacks.length)
         {
            return null;
         }
         return _loc3_.attacks[param2.index];
      }
      
      private function getCharacterSkillFromAction(param1:Object, param2:Object) : Object
      {
         var _loc3_:Object = null;
         if(param2.type == 2 && param1.character_skills_mc && param2.index >= 0 && param2.index < param1.character_skills_mc.length)
         {
            _loc3_ = param1.character_skills_mc[param2.index];
         }
         else if(param2.type == 3 && param1.character_talent_skills_mc && param2.index >= 0 && param2.index < param1.character_talent_skills_mc.length)
         {
            _loc3_ = param1.character_talent_skills_mc[param2.index];
         }
         else if(param2.type == 4 && param1.character_senjutsu_skills_mc && param2.index >= 0 && param2.index < param1.character_senjutsu_skills_mc.length)
         {
            _loc3_ = param1.character_senjutsu_skills_mc[param2.index];
         }
         else if(param2.type == 5 && param1.class_skill)
         {
            _loc3_ = param1.class_skill;
         }
         if(_loc3_ == null || _loc3_.skill_info == null)
         {
            return null;
         }
         return {
            "effects":_loc3_.skill_info.effects,
            "dmg":this.estimateSkillInfoDamage(_loc3_.skill_info)
         };
      }
      
      public function destroy() : void
      {
         this.plannedTarget = null;
         this.plannedSkill = null;
         this.plannedIntent = null;
         this.lastSetupTarget = null;
         this.skillQueryCache = null;
         this.usedSkillCounts = {};
         this.currentTargetModel = null;
         this.lastDecisionReport = null;
         this.lastSkillKey = null;
         this.previousTargetKey = null;
         this.previousSelfHP = -1;
         this.previousTargetHP = -1;
      }
   }
}
