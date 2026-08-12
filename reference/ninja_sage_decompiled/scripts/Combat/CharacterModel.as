package Combat
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import NinjaSage_fla.Symbol42_64;
   import Storage.Character;
   import Storage.Library;
   import Storage.WeaponBuffs;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.base.CharacterModelBase;
   
   public class CharacterModel extends CharacterModelBase
   {
       
      
      public var shadow:MovieClip;
      
      public var throw02Mc:Symbol42_64;
      
      public var weapon1:MovieClip;
      
      public var back:MovieClip;
      
      public var back_hair:MovieClip;
      
      public var head:MovieClip;
      
      public var hitAreaMc:MovieClip;
      
      public var holderMc:MovieClip;
      
      public var left_hand:MovieClip;
      
      public var left_lower_arm:MovieClip;
      
      public var left_lower_leg:MovieClip;
      
      public var left_shoe:MovieClip;
      
      public var left_upper_arm:MovieClip;
      
      public var left_upper_leg:MovieClip;
      
      public var lower_body:MovieClip;
      
      public var right_hand:MovieClip;
      
      public var right_lower_arm:MovieClip;
      
      public var right_lower_leg:MovieClip;
      
      public var right_shoe:MovieClip;
      
      public var right_upper_arm:MovieClip;
      
      public var right_upper_leg:MovieClip;
      
      public var skirt:MovieClip;
      
      public var upper_body:MovieClip;
      
      public var weapon:MovieClip;
      
      public var character_id:int;
      
      public var attack_results:Array;
      
      public var attack_result:Object;
      
      public var for_exam:Boolean;
      
      public var library;
      
      public var character_manager:CharacterManager;
      
      public var pet_model:PetModel = null;
      
      public var IS_DODGED:Boolean = false;
      
      public var IS_BLOCK_DAMAGE:Boolean = false;
      
      public var health_manager:HealthManager;
      
      public var actions_manager:ActionsManager;
      
      public var theft_mode:Boolean = false;
      
      public var blood_tax_mode:Boolean = false;
      
      public var unyielding_mode:Boolean = false;
      
      public var ultimate_string:Object;
      
      public var debuff_resist:Boolean = false;
      
      public var effects_manager:EffectsManager;
      
      public var are_random_skills_set:Boolean = false;
      
      public var random_skills:Array;
      
      public var IS_CHAOS:Boolean = false;
      
      public var outfits;
      
      public var knowledge_of_time:Object;
      
      public var background_active:Boolean = false;
      
      private var isTooltipSkillLoaded:Array;
      
      public var action_type:String = "start";
      
      private var enemy_ai:EnemyAI;
      
      public function CharacterModel(param1:String = "", param2:int = 0, param3:String = "", param4:Boolean = false)
      {
         this.outfits = [];
         this.knowledge_of_time = {};
         this.isTooltipSkillLoaded = [];
         addFrameScript(339,this.frame340);
         super();
         if(param1 == "" && param2 == 0 && param3 == "" && param4 == false)
         {
            return;
         }
         this.attack_result = {
            "damage":0,
            "effects":[],
            "multi_hit":false,
            "self_target":false
         };
         this.knowledge_of_time = {
            "is_active":false,
            "stored_damage":0,
            "max_store":0,
            "heal_block_turns":0
         };
         this.enemy_ai = new EnemyAI();
         this.attack_result = {};
         this.random_skills = [];
         this.player_team = param1;
         this.player_number = param2;
         this.player_identification = param3;
         this.for_exam = param4;
         if(!this.for_exam)
         {
            this.health_manager = new HealthManager(this.player_team,this.player_number);
            this.actions_manager = new ActionsManager(this.player_team,this.player_number,this);
            this.effects_manager = new EffectsManager(this.player_team,this.player_number);
            this.library = BattleManager.getMain().getLibrary();
         }
         this.character_id = int(this.player_identification.replace("char_",""));
         this.handlePlayerParentObjects();
         this.setScalingAndSaveStartingPosition();
         this.setModelFramescript();
         if(BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.SHADOWWAR_MATCH)
         {
            BattleManager.getMain().amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["HWpRKBsJR4i5",[Character.char_id,Character.sessionkey,this.character_id]],this.handleCharacterData);
         }
         else
         {
            BattleManager.getMain().amf_manager.service("36a62s4oZ7iYRJjd.iakN46g0GaJN",[Character.char_id,Character.sessionkey,this.character_id,BattleManager.BATTLE_VARS.BATTLE_MODE],this.handleCharacterData);
         }
      }
      
      public function handleCharacterData(param1:Object) : *
      {
         var _loc2_:OutfitManager = null;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         param1.char_id = this.character_id;
         this.characterAnimations = {
            "dodge":(param1.character_sets.hasOwnProperty("anims") && param1.character_sets.anims.hasOwnProperty("dodge") ? param1.character_sets.anims.dodge : "ani_1"),
            "standby":(param1.character_sets.hasOwnProperty("anims") && param1.character_sets.anims.hasOwnProperty("standby") ? param1.character_sets.anims.standby : "ani_5"),
            "win":(param1.character_sets.hasOwnProperty("anims") && param1.character_sets.anims.hasOwnProperty("win") ? param1.character_sets.anims.win : "ani_7"),
            "dead":(param1.character_sets.hasOwnProperty("anims") && param1.character_sets.anims.hasOwnProperty("dead") ? param1.character_sets.anims.dead : "ani_3"),
            "charge":(param1.character_sets.hasOwnProperty("anims") && param1.character_sets.anims.hasOwnProperty("charge") ? param1.character_sets.anims.charge : "ani_9"),
            "hit":(param1.character_sets.hasOwnProperty("anims") && param1.character_sets.anims.hasOwnProperty("hit") ? param1.character_sets.anims.hit : "ani_10"),
            "run":(param1.character_sets.hasOwnProperty("anims") && param1.character_sets.anims.hasOwnProperty("run") ? param1.character_sets.anims.run : "ani_11")
         };
         if("pet_id" in param1.pet_data && param1.pet_data != null && !this.for_exam)
         {
            _loc5_ += 200;
            _loc3_ = param1.pet_data;
            this.pet_model = new PetModel(this.getPlayerTeam(),this.getPlayerNumber(),param1.pet_data.pet_swf,_loc3_);
         }
         if(!this.for_exam)
         {
            this.character_manager = new CharacterManager(param1);
            this.character_manager.setModel(this);
            this.character_info = this.character_manager.getAllCharacterInfo();
            _loc2_ = new OutfitManager();
            this.overrideAnimations(Library.getItemInfo(this.character_manager.getWeapon()).anims);
            if(!Character.is_stickman)
            {
               _loc2_.fillOutfit(this,this.character_manager.getWeapon(),this.character_manager.getBackItem(),this.character_manager.getClothing(),this.character_manager.getHair(),this.character_manager.getFace(),this.character_info.hair_color,this.character_info.skin_color);
            }
            this.outfits.push(_loc2_);
            GF.removeAllChild(this.getMovieClipHolder().charMc);
            this.getMovieClipHolder().charMc.addChild(this);
            this.getMovieClipHolder().charMc.character_model = this;
            this.getMovieClipHolder().visible = true;
            this.health_manager.fillHealth(this.character_info);
            _loc4_ = this.player_number + 1;
            if(this.player_team == "player")
            {
               setTimeout(BattleManager.loadPlayerTeam,_loc5_,_loc4_);
            }
            if(this.player_team != "player")
            {
               setTimeout(BattleManager.loadEnemyTeam,_loc5_,_loc4_);
            }
            this.actions_manager.init();
         }
         else
         {
            this.weapon.visible = false;
            _loc2_ = new OutfitManager();
            if(!Character.is_stickman)
            {
               _loc2_.fillOutfit(this,null,null,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
            }
            this.outfits.push(_loc2_);
         }
      }
      
      public function reloadInfo() : *
      {
         this.character_info = this.character_manager.getAllCharacterInfo();
         this.health_manager.fillHealth(this.character_info);
      }
      
      public function get characterClanData() : Object
      {
         return this.character_manager.character.clan;
      }
      
      public function getAccuracy() : int
      {
         var _loc1_:int = this.character_info.character_accuracy;
         var _loc2_:Array = this.effects_manager.getActiveBuff("accuracy");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("accuracy");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"accuracy");
         return int(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"accuracy"));
      }
      
      public function getDodgeRate() : int
      {
         var _loc1_:int = this.character_info.character_dodge;
         var _loc2_:Array = this.effects_manager.getActiveBuff("dodge");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("dodge");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"dodge");
         return int(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"dodge"));
      }
      
      public function getCombustionChance() : int
      {
         var _loc1_:Number = Math.ceil(this.character_manager.getFireAttributes() * 0.4);
         var _loc2_:Array = this.effects_manager.getActiveBuff("combustion");
         var _loc3_:Array = this.effects_manager.getEquippedSetForEffects("combustion");
         var _loc4_:Array = this.effects_manager.getEquippedSetForEffects("combustion",false);
         var _loc5_:Array = this.effects_manager.getActiveDebuff("combustion");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_);
         _loc1_ = BattleManager.modifyChance(_loc3_,"ADD",_loc1_);
         _loc1_ = BattleManager.modifyChance(_loc5_,"RM",_loc1_);
         return Number(BattleManager.modifyChance(_loc4_,"RM",_loc1_));
      }
      
      public function getCriticalChance() : int
      {
         var _loc1_:Number = this.character_info.character_critical;
         var _loc2_:Array = this.effects_manager.getActiveBuff("critical");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("critical");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"critical");
         return Number(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"critical"));
      }
      
      public function getPurifyChance() : int
      {
         var _loc1_:Number = this.character_manager.getPurify();
         var _loc2_:Array = this.effects_manager.getActiveBuff("purify");
         var _loc3_:Array = this.effects_manager.getActiveDebuff("purify");
         _loc1_ = BattleManager.modifyChance(_loc2_,"ADD",_loc1_,"purify");
         return Number(BattleManager.modifyChance(_loc3_,"RM",_loc1_,"purify"));
      }
      
      public function getMovieClipHolder() : *
      {
         return BattleManager.getBattle()[this.movieclip_holder + this.player_number];
      }
      
      public function attackWithWeapon() : *
      {
         var _loc1_:* = this.library.getItemInfo(this.character_manager.getWeapon());
         var _loc2_:* = "attack_01";
         if("attack_type" in _loc1_)
         {
            _loc2_ = _loc1_.attack_type;
         }
         var _loc3_:int = this.player_team == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
         var _loc4_:Array = [];
         var _loc5_:Object = this.calculateAttackPosition(_loc3_,_loc2_,_loc4_);
         this.x = _loc5_.x;
         this.y = _loc5_.y;
         this.gotoAndPlay(_loc2_);
      }
      
      override public function handleHitFrame() : *
      {
         var _loc1_:* = this.library.getItemInfo(this.character_manager.getWeapon());
         var _loc2_:* = WeaponBuffs.getCopy(this.character_manager.getWeapon());
         var _loc3_:* = _loc2_.effects == null ? [] : _loc2_.effects;
         var _loc4_:Array = !!this.effects_manager.hadEffect("disable_weapon_effect") ? [] : _loc3_;
         _loc4_ = BattleManager.getBattle().checkForDisperse(_loc4_);
         var _loc5_:String = this.player_team == "player" ? "enemy" : "player";
         var _loc6_:int = this.player_team == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
         BattleManager.getBattle().setDefender(_loc5_,_loc6_);
         var _loc7_:int = int(_loc1_.item_damage);
         this.attack_results = [_loc7_,_loc4_,false];
         this.attack_result = {
            "damage":_loc7_,
            "effects":_loc4_,
            "multi_hit":false,
            "self_target":false
         };
         BattleManager.getBattle().weaponAttack();
         this.health_manager.chargePlayer(5,"Weapon");
      }
      
      public function checkBlockDamage() : int
      {
         return this.character_manager.checkBlockDamage();
      }
      
      public function checkIgnoreBlockDamage() : int
      {
         return this.character_manager.checkIgnoreBlockDamage();
      }
      
      public function checkConvertDamage() : Boolean
      {
         return this.character_manager.checkConvertDamage();
      }
      
      public function checkConvertDamageCP() : Boolean
      {
         return this.character_manager.checkConvertDamageCP();
      }
      
      public function getAttackResults() : Array
      {
         return this.attack_results;
      }
      
      public function getAttackResult() : Object
      {
         return this.attack_result;
      }
      
      public function targetIsSleeping() : *
      {
         var target:int = 0;
         var target_model:* = undefined;
         try
         {
            target = this.player_team == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
            target_model = this.player_team == "player" ? BattleManager.getBattle().enemy_team_players[target] : BattleManager.getBattle().character_team_players[target];
            if(Boolean(target_model.effects_manager.hadEffect("sleep")) || Boolean(target_model.effects_manager.hadEffect("pet_sleep")))
            {
               return true;
            }
         }
         catch(e:*)
         {
         }
         return false;
      }
      
      public function getSkillsCooldown() : *
      {
         return this.skills_with_cooldown;
      }
      
      public function handleRandomSkill(param1:*, param2:*) : *
      {
         var curr_skill_mc:* = undefined;
         var skill_holder:* = param1;
         var num:* = param2;
         var character_skills_mc:Array = this.actions_manager.character_skills_mc;
         if(!this.are_random_skills_set)
         {
            this.are_random_skills_set = true;
            try
            {
               this.random_skills = this.getRandomSequence(0,character_skills_mc.length - 1);
            }
            catch(e:*)
            {
               random_skills = [];
            }
         }
         if(this.random_skills.length > num)
         {
            skill_holder.visible = true;
            skill_holder.cdTxt.text = character_skills_mc[this.random_skills[num]].getCurrentCooldown() > 0 ? character_skills_mc[this.random_skills[num]].getCurrentCooldown() : "";
            if(!this.isTooltipSkillLoaded[num])
            {
               GF.removeAllChild(skill_holder.holder);
               NinjaSage.loadIconSWF("skills",character_skills_mc[this.random_skills[num]].skill_info.skill_id,skill_holder.holder,"icon");
               this.isTooltipSkillLoaded[num] = true;
            }
         }
         else
         {
            skill_holder.visible = false;
         }
      }
      
      function copyClip(param1:MovieClip) : *
      {
         var _loc2_:Class = Object(param1).constructor;
         return new _loc2_();
      }
      
      public function getAttack(param1:int = 0, param2:int = -1) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Array = this.actions_manager.character_skills_mc;
         var _loc7_:Array = this.actions_manager.character_talent_skills_mc;
         var _loc8_:Array = this.actions_manager.character_senjutsu_skills_mc;
         var _loc9_:SkillHandler = this.actions_manager.class_skill;
         var _loc10_:int = -1;
         var _loc11_:int = -1;
         var _loc12_:* = BattleManager.getBattle();
         var _loc13_:Array = this.player_team == "player" ? _loc12_.enemy_team_players : _loc12_.character_team_players;
         var _loc14_:Array = this.player_team == "player" ? _loc12_.character_team_players : _loc12_.enemy_team_players;
         var _loc15_:Object;
         _loc10_ = (_loc15_ = this.enemy_ai.decideAction(this,_loc13_,_loc14_)).type;
         _loc11_ = _loc15_.index;
         var _loc16_:String = this.player_team;
         var _loc17_:String = this.player_team == "player" ? "enemy" : "player";
         if(_loc6_.length > 0 && _loc10_ == -1)
         {
            _loc10_ = 2;
         }
         if(_loc10_ == -1 && _loc7_.length > 0 && _loc6_.length > 0)
         {
            _loc10_ = NumberUtil.randomInt(0,3) + 2;
         }
         if(param2 != -1 && param1 < 5)
         {
            if(_loc10_ != param2)
            {
               _loc11_ = -1;
            }
            _loc10_ = param2;
         }
         if(param1 > 10)
         {
            _loc10_ = 1;
         }
         var _loc18_:Object = this.getDecisionSkillInfo(_loc10_,_loc11_);
         var _loc19_:Boolean = _loc10_ == 1 || this.isOpponentTargetSkill(_loc18_);
         var _loc21_:Array = !!(_loc20_ = Boolean(_loc15_.is_friendly_target && !_loc19_)) ? _loc14_ : _loc13_;
         _loc15_.target = this.normalizeLiveTargetIndex(int(_loc15_.target),_loc21_);
         if(_loc20_)
         {
            BattleManager.getBattle().setDefender(_loc16_,_loc15_.target);
         }
         else
         {
            if(this.player_team == "player")
            {
               BattleVars.PLAYER_TARGET = _loc15_.target;
            }
            else
            {
               BattleVars.ENEMY_TARGET = _loc15_.target;
            }
            BattleManager.getBattle().setDefender(_loc17_,_loc15_.target);
         }
         var _loc22_:int = _loc15_.target;
         var _loc23_:Boolean = this.targetIsSleeping();
         if(_loc10_ == 1 && _loc23_)
         {
            _loc10_ = 6;
         }
         if(_loc10_ == 1)
         {
            this.actions_manager.onWeaponAttack();
         }
         else if(_loc10_ == 2)
         {
            if(_loc11_ == -1)
            {
               _loc11_ = NumberUtil.randomInt(0,_loc6_.length - 1);
            }
            if((_loc3_ = _loc6_[_loc11_]) == null)
            {
               this.getAttack(param1 + 1,2);
               return;
            }
            if(_loc4_ = Boolean(_loc3_.setPositionAndAttack(this.player_team,_loc22_,this.player_number,false)))
            {
               if(!(_loc5_ = this.actions_manager.onUseSkill(_loc11_,_loc23_)))
               {
                  this.getAttack(param1 + 1,2);
               }
            }
            else
            {
               this.getAttack(param1 + 1,2);
            }
         }
         else if(_loc10_ == 3)
         {
            if(_loc11_ == -1)
            {
               _loc11_ = NumberUtil.randomInt(0,_loc7_.length - 1);
            }
            if((_loc3_ = _loc7_[_loc11_]) == null)
            {
               this.getAttack(param1 + 1,3);
               return;
            }
            if(_loc4_ = Boolean(_loc3_.setPositionAndAttack(this.player_team,_loc22_,this.player_number,false)))
            {
               if(!(_loc5_ = this.actions_manager.useTalentSkill(_loc11_,_loc23_)))
               {
                  this.getAttack(param1 + 1,3);
               }
            }
            else
            {
               this.getAttack(param1 + 1,3);
            }
         }
         else if(_loc10_ == 4)
         {
            if(_loc11_ == -1)
            {
               _loc11_ = NumberUtil.randomInt(0,_loc8_.length - 1);
            }
            if((_loc3_ = _loc8_[_loc11_]) == null)
            {
               this.getAttack(param1 + 1,4);
               return;
            }
            if(_loc4_ = Boolean(_loc3_.setPositionAndAttack(this.player_team,_loc22_,this.player_number,false)))
            {
               if(!(_loc5_ = this.actions_manager.useSenjutsuSkill(_loc11_,_loc23_)))
               {
                  this.getAttack(param1 + 1,4);
               }
            }
            else
            {
               this.getAttack(param1 + 1,4);
            }
         }
         else if(_loc10_ == 5)
         {
            if((_loc3_ = _loc9_) == null)
            {
               this.getAttack(0,1);
               return;
            }
            if(_loc4_ = Boolean(_loc3_.setPositionAndAttack(this.player_team,_loc22_,this.player_number,false)))
            {
               if(!(_loc5_ = this.actions_manager.onUseClassSkill(null)))
               {
                  this.getAttack(0,1);
               }
            }
            else
            {
               this.getAttack(0,1);
            }
         }
         else if(_loc10_ == 6)
         {
            this.actions_manager.onChargeUsed();
         }
      }
      
      private function getDecisionSkillInfo(param1:int, param2:int) : Object
      {
         if(param1 == 2 && param2 >= 0 && param2 < this.actions_manager.character_skills_mc.length)
         {
            return this.actions_manager.character_skills_mc[param2] != null ? this.actions_manager.character_skills_mc[param2].skill_info : null;
         }
         if(param1 == 3 && param2 >= 0 && param2 < this.actions_manager.character_talent_skills_mc.length)
         {
            return this.actions_manager.character_talent_skills_mc[param2] != null ? this.actions_manager.character_talent_skills_mc[param2].skill_info : null;
         }
         if(param1 == 4 && param2 >= 0 && param2 < this.actions_manager.character_senjutsu_skills_mc.length)
         {
            return this.actions_manager.character_senjutsu_skills_mc[param2] != null ? this.actions_manager.character_senjutsu_skills_mc[param2].skill_info : null;
         }
         if(param1 == 5 && this.actions_manager.class_skill != null)
         {
            return this.actions_manager.class_skill.skill_info;
         }
         return null;
      }
      
      private function isOpponentTargetSkill(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(this.skillHasIntrinsicDamage(param1))
         {
            return true;
         }
         if(this.skillHasEnemyEffect(param1))
         {
            return true;
         }
         if(param1.hasOwnProperty("is_self_skill") && Boolean(param1.is_self_skill))
         {
            return false;
         }
         return false;
      }
      
      private function skillHasEnemyEffect(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:Array = param1 != null && param1.hasOwnProperty("effects") ? param1.effects : null;
         if(_loc2_ == null)
         {
            return false;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ != null && _loc3_.hasOwnProperty("target") && _loc3_.target == "enemy")
            {
               return true;
            }
         }
         return false;
      }
      
      private function skillHasIntrinsicDamage(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.hasOwnProperty("dmg") && Number(param1.dmg) > 0)
         {
            return true;
         }
         if(param1.hasOwnProperty("skill_damage") && Number(param1.skill_damage) > 0)
         {
            return true;
         }
         if(param1.hasOwnProperty("talent_skill_damage") && Number(param1.talent_skill_damage) > 0)
         {
            return true;
         }
         if(param1.hasOwnProperty("damage") && Number(param1.damage) > 0)
         {
            return true;
         }
         return false;
      }
      
      private function normalizeLiveTargetIndex(param1:int, param2:Array) : int
      {
         var _loc4_:Object = null;
         if(param2 == null || param2.length == 0)
         {
            return 0;
         }
         if(param1 >= 0 && param1 < param2.length && param2[param1] != null && param2[param1].health_manager != null && !param2[param1].health_manager.isDead())
         {
            return param1;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if((_loc4_ = param2[_loc3_]) != null && _loc4_.health_manager != null && !_loc4_.health_manager.isDead())
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function handleChaos() : *
      {
         this.actions_manager.handleChaos();
      }
      
      public function handleTease() : *
      {
         this.actions_manager.handleTease();
      }
      
      public function chargePlayer() : *
      {
         this.gotoAndPlay(this.getFrameLabel("charge"));
         this.health_manager.chargePlayer();
      }
      
      override public function weaponAttackFinished() : *
      {
         this.gotoStandby();
         BattleManager.getBattle().weaponAttackFinish();
      }
      
      override public function setScalingAndSaveStartingPosition() : *
      {
         if(!this.for_exam)
         {
            BattleManager.getBattle()[this.movieclip_holder + this.player_number].charMc.scaleX = this.player_team == "player" ? -1 : 1;
         }
         super.setScalingAndSaveStartingPosition();
      }
      
      public function isDead() : Boolean
      {
         return this.health_manager.isDead();
      }
      
      public function getAgility() : Number
      {
         return Number(this.character_manager.getAgility());
      }
      
      public function getPurify() : Number
      {
         return Number(this.getPurifyChance());
      }
      
      public function getHead() : MovieClip
      {
         var _loc1_:MovieClip = new (getDefinitionByName("CharHead") as Class)();
         var _loc2_:OutfitManager = new OutfitManager();
         _loc2_.fillHead(_loc1_,this.character_manager.getHair(),this.character_manager.getFace(),this.character_info.hair_color,this.character_info.skin_color);
         this.outfits.push(_loc2_);
         return _loc1_;
      }
      
      public function getLevel() : int
      {
         return this.character_info.character_level;
      }
      
      public function reduceHealth(param1:int) : *
      {
         this.health_manager.reduceHealth(param1);
      }
      
      override public function chargeAnimationFinished() : *
      {
         this.gotoStandby();
         BattleManager.getBattle().agility_bar_manager.startRun();
      }
      
      override public function playAnimation(param1:String) : *
      {
         if(param1 == "hit" || param1 == "dodge")
         {
            this.effects_manager.wakePlayer();
         }
         var _loc2_:String = this.getFrameLabel(param1);
         this.gotoAndPlay(_loc2_);
      }
      
      override public function destroy() : *
      {
         var _loc3_:* = undefined;
         if(this.enemy_ai)
         {
            this.enemy_ai.destroy();
         }
         this.enemy_ai = null;
         Log.info(this,"destroy",this.player_identification);
         this.characterAnimations = null;
         this.library = null;
         this.character_info = null;
         this.unyielding_mode = false;
         this.ultimate_string = null;
         this.theft_mode = false;
         this.blood_tax_mode = false;
         this.IS_CHAOS = false;
         this.attack_result = null;
         this.isTooltipSkillLoaded = null;
         this.attack_results = null;
         this.skills_with_cooldown = null;
         this.random_skills = null;
         var _loc1_:* = BattleManager.getBattle();
         var _loc2_:String = this.movieclip_holder + String(this.player_number);
         if(_loc1_ && _loc2_ in _loc1_)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc3_.charMc.character_model = null;
            GF.removeAllChild(_loc3_);
            _loc3_ = null;
         }
         _loc1_ = null;
         _loc2_ = null;
         if(this.pet_model)
         {
            this.pet_model.destroy();
         }
         this.pet_model = null;
         GF.destroyArray(this.outfits);
         this.outfits = null;
         if(this.character_manager)
         {
            this.character_manager.destroy();
         }
         this.character_manager = null;
         if(this.health_manager)
         {
            this.health_manager.destroy();
         }
         this.health_manager = null;
         if(this.actions_manager)
         {
            this.actions_manager.destroy();
         }
         this.actions_manager = null;
         if(this.effects_manager)
         {
            this.effects_manager.destroy();
         }
         this.effects_manager = null;
         this.gotoAndStop(1);
         super.destroy();
         GF.removeAllChild(this);
      }
      
      function frame340() : *
      {
         this.stop();
      }
   }
}
