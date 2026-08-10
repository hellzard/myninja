package Combat
{
   import Storage.SkillLibrary;
   import com.utils.GF;
   import com.utils.NumberUtil;
   
   public class BattleVars
   {
      
      public static const MATCH_STATE_STARTED:int = 1;
      
      public static const MATCH_STATE_ENDED:int = 2;
      
      public static const SKILL_SCALE:Number = 0.42;
      
      public static const CHAR_SCALE:Number = 0.42;
      
      public static const NPC_SCALE:Number = 0.75;
      
      public static const PET_SCALE:Number = 0.75;
      
      public static const ENEMY_SCALE:Number = 0.8;
      
      public static const Position_MELEE_1:String = "melee_1";
      
      public static const Position_MELEE_2:String = "melee_2";
      
      public static const Position_MELEE_3:String = "melee_3";
      
      public static const Position_MELEE_4:String = "melee_4";
      
      public static const Position_MELEE_5:String = "melee_5";
      
      public static const Position_RANGE_1:String = "range_1";
      
      public static const Position_RANGE_2:String = "range_2";
      
      public static const Position_RANGE_3:String = "range_3";
      
      public static const Position_RANGE_4:String = "range_4";
      
      public static const Position_START:String = "start";
      
      public static var PLAYER_TEAM_LOADED:Boolean = false;
      
      public static var ENEMY_TEAM_LOADED:Boolean = false;
      
      public static var MASTER_PLAYER_TARGET:int = 0;
      
      public static var PLAYER_TARGET:int = 0;
      
      public static var ENEMY_TARGET:int = 0;
      
      public static var FRIENDLY_MATCH:String = "FRIENDLY";
      
      public static var MISSION_MATCH:String = "MISSION";
      
      public static var EVENT_MATCH:String = "EVENT";
      
      public static var CLAN_MATCH:String = "CLAN";
      
      public static var CREW_MATCH:String = "CREW";
      
      public static var EXAM_MATCH:String = "EXAM";
      
      public static var ARENA_MATCH:String = "ARENA";
      
      public static var DRAGON_HUNT_MATCH:String = "DRAGONHUNT";
      
      public static var TEST_MATCH:String = "TEST";
      
      public static var SHADOWWAR_MATCH:String = "SHADOWWAR";
      
      public static var MATCH_RUNNING:Boolean = false;
      
      public static var CAN_NOT_DODGE:Boolean = false;
      
      public static var IS_DODGED:Boolean = false;
      
      public static var IS_CRITICAL:Boolean = false;
      
      public static var IS_COMBUSTION:Boolean = false;
      
      public static var IS_BLOCKED:Boolean = false;
      
      public static var IS_DAMAGE_CONVERTED:Boolean = false;
      
      public static var IS_DAMAGE_CONVERTED_CP:Boolean = false;
      
      public static var IS_DISPERSED:Boolean = false;
      
      public static var REDUCED_HP_AS_DAMAGE:Boolean = false;
      
      public static var SHOW_DAMAGE_ZERO:Boolean = false;
      
      public static var ATTACKER_TYPE:String = "";
      
      public static var ATTACK_TYPE:String = "";
      
      public static var ATTACK_FROM:String = "";
      
      public static var TITAN_MODE:Boolean = false;
      
      public static var EMBERSTEP:Boolean = false;
      
      public static var EMBERSTEP_USED:String = "";
      
      public static var OVERLOAD_MODE:Boolean = false;
      
      public static var JUST_USED_TITAN:Boolean = false;
      
      public static var JUST_USED_EMBERSTEP:Boolean = false;
      
      public static var JUST_USED_OVERLOAD:Boolean = false;
      
      public static var IS_SELF_SKILL:Boolean = false;
      
      public static var SWITCH_ATTACK_MODELS:Boolean = false;
      
      public static var IS_GENJUTSU:Boolean = false;
      
      public static var COPY_SKILL:Boolean = false;
      
      public static var COUNTER_SKILL:Boolean = false;
      
      public static var STEAL_JUTSU:Boolean = false;
      
      public static var GENJUTSU_REBOUND:Boolean = false;
      
      public static var ANIMATION_OVERRIDE:Boolean = false;
      
      public static var ANIMATION_OVERRIDER:String = "";
      
      public static var BACKGROUND_CHANGED:Boolean = false;
      
      public static var BACKGROUND_CHANGED_CASTER:String = "";
      
      public static var PLAY_DEAD_ANIMATION:String = "";
      
      public static var PLAY_DEAD_TEAM:String = "";
      
      public static var PLAY_DEAD_NUMBER:int = 0;
      
      public static var COPY_SKILL_ID_SAVE:String = "";
      
      public static var COPY_SKILL_ID:String = "";
      
      public static var COPY_SKILL_TEXT:String = "";
      
      public static var SKILL_USED_ID:String = "";
      
      public static var SKILL_USED_TYPE:int = 0;
      
      public static var HP_RECOVER_AFTER:int = 0;
      
      public static var CP_RECOVER_AFTER:int = 0;
      
      public static var CAPTURE_RANGE_START:int = 0;
      
      public static var CAPTURE_RANGE_END:int = 0;
      
      public static var CAPTURED_AT:int = -1;
      
      public static var DH_MODE:int = -1;
      
      public static var CRYSTAL_BLOCK:Boolean = false;
      
      public static var S_C:Boolean = false;
      
      public static var CHARACTER_REVIVED:Array = [false,false,false];
      
      public static var CHARACTER_TEAM_REVIVED:Array = [false,false,false];
      
      public static var CHARACTER_ICM:Array = [false,false,false];
      
      public static var CHARACTER_TOAD:Array = [0,0,0];
      
      public static var CHARACTER_LEFT_REDUCE_CD:Array = [2,2,2];
      
      public static var CHARACTER_REDUCE_CD:Array = [8,8,8];
      
      public static var ENEMY_REVIVED:Array = [false,false,false];
      
      public static var ENEMY_TEAM_REVIVED:Array = [false,false,false];
      
      public static var ENEMY_ICM:Array = [false,false,false];
      
      public static var ENEMY_TOAD:Array = [0,0,0];
      
      public static var ENEMY_LEFT_REDUCE_CD:Array = [2,2,2];
      
      public static var ENEMY_REDUCE_CD:Array = [8,8,8];
      
      public var MATCH_STATE:int = 0;
      
      public var BATTLE_MODE:String = "";
      
      public var BATTLE_BACKGROUND:String = "";
      
      public var ORIGINAL_BATTLE_BACKGROUND:String = "";
      
      public var PLAYER_TEAM:Array = [];
      
      public var ENEMY_TEAM:Array = [];
      
      public function BattleVars()
      {
         super();
      }
      
      public static function getRandomEnemyTarget() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         while(_loc1_ < BattleManager.getBattle().character_team_players.length)
         {
            if(!BattleManager.getBattle().character_team_players[_loc1_].health_manager.isDead())
            {
               if(Boolean(BattleManager.getBattle().character_team_players[_loc1_].effects_manager.hadEffect("sleep")) || Boolean(BattleManager.getBattle().character_team_players[_loc1_].effects_manager.hadEffect("pet_sleep")))
               {
                  _loc3_.push(_loc1_);
               }
               else
               {
                  _loc2_.push(_loc1_);
               }
            }
            _loc1_++;
         }
         if(_loc2_.length > 0)
         {
            ENEMY_TARGET = _loc2_[NumberUtil.randomInt(0,_loc2_.length - 1)];
         }
         else
         {
            ENEMY_TARGET = _loc3_[NumberUtil.randomInt(0,_loc3_.length - 1)];
         }
      }
      
      public static function getRandomPlayerTarget() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         while(_loc1_ < BattleManager.getBattle().enemy_team_players.length)
         {
            if(!BattleManager.getBattle().enemy_team_players[_loc1_].health_manager.isDead())
            {
               if(Boolean(BattleManager.getBattle().enemy_team_players[_loc1_].effects_manager.hadEffect("sleep")) || Boolean(BattleManager.getBattle().enemy_team_players[_loc1_].effects_manager.hadEffect("pet_sleep")))
               {
                  _loc3_.push(_loc1_);
               }
               else
               {
                  _loc2_.push(_loc1_);
               }
            }
            _loc1_++;
         }
         if(_loc2_.length > 0)
         {
            PLAYER_TARGET = _loc2_[NumberUtil.randomInt(0,_loc2_.length - 1)];
         }
         else
         {
            PLAYER_TARGET = _loc3_[NumberUtil.randomInt(0,_loc3_.length - 1)];
         }
      }
      
      public static function resetVarsForNextTurn() : *
      {
         PLAY_DEAD_ANIMATION = "";
         ATTACKER_TYPE = "";
         ATTACK_FROM = "";
         REDUCED_HP_AS_DAMAGE = false;
         IS_DISPERSED = false;
         GENJUTSU_REBOUND = false;
         SWITCH_ATTACK_MODELS = false;
         IS_SELF_SKILL = false;
         IS_GENJUTSU = false;
         SHOW_DAMAGE_ZERO = false;
         CAN_NOT_DODGE = false;
         SKILL_USED_TYPE = 0;
         HP_RECOVER_AFTER = 0;
         CP_RECOVER_AFTER = 0;
      }
      
      public static function calculateDodge(param1:Object, param2:Object) : void
      {
         var _loc3_:int = int(param2.getAccuracy());
         var _loc4_:int = int(param1.getDodgeRate());
         var _loc5_:int = _loc4_ - _loc3_;
         var _loc6_:int = NumberUtil.getRandomInt();
         param1.IS_DODGED = _loc5_ >= _loc6_ ? true : false;
      }
      
      public static function getCalculateDodge(param1:Object, param2:Object, param3:String) : Boolean
      {
         var _loc10_:int = 0;
         var _loc4_:int = int(param2.getAccuracy());
         var _loc5_:int = int(param1.getDodgeRate());
         var _loc6_:int = param3 == "skill_3104" ? int(param2.effects_manager.getIgnoreDodgeBySenjutsu()) : 0;
         var _loc7_:int = SkillLibrary.getExtremeHitChance(param3);
         if(param3 == "skill_634")
         {
            _loc10_ = int(param2.effects_manager.dataBuff.length);
            if(_loc10_ > 0)
            {
               _loc4_ += _loc10_ * 20;
            }
         }
         if(_loc6_ > 0)
         {
            _loc5_ -= _loc6_;
         }
         _loc5_ -= _loc7_;
         var _loc8_:int = _loc5_ - _loc4_;
         var _loc9_:int = NumberUtil.getRandomInt();
         param1.IS_DODGED = _loc8_ >= _loc9_ ? true : false;
         return param1.IS_DODGED;
      }
      
      public static function calculateCritical(param1:Object, param2:Object) : void
      {
         var _loc3_:int = int(param2.getCriticalChance());
         if(BattleVars.SKILL_USED_ID == "skill_1062" && _loc3_ < 50)
         {
            _loc3_ = 70;
         }
         else if(BattleVars.SKILL_USED_ID == "skill_6060" && _loc3_ < 50)
         {
            _loc3_ = 60;
         }
         var _loc4_:int = NumberUtil.getRandomInt();
         IS_CRITICAL = _loc3_ >= _loc4_ ? true : false;
      }
      
      public static function checkPurify(param1:*) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc2_:int = int(param1.getPurify());
         var _loc3_:int = NumberUtil.getRandomInt();
         if(_loc2_ >= _loc3_)
         {
            param1.effects_manager.purifyPlayer();
            return true;
         }
         return false;
      }
      
      public static function checkCombustion(param1:*) : *
      {
         var _loc2_:int = int(param1.getCombustionChance());
         var _loc3_:int = NumberUtil.getRandomInt();
         IS_COMBUSTION = _loc2_ >= _loc3_ ? true : false;
         if(IS_COMBUSTION)
         {
            param1.effects_manager.showCombustion();
         }
      }
      
      public function reset() : *
      {
         GF.clearArray(this.PLAYER_TEAM);
         GF.clearArray(this.ENEMY_TEAM);
         this.PLAYER_TEAM = [];
         this.ENEMY_TEAM = [];
      }
      
      public function addPlayerToTeam(param1:String, param2:String) : *
      {
         switch(param1)
         {
            case "player":
               if(this.PLAYER_TEAM.length == 3)
               {
                  return;
               }
               this.PLAYER_TEAM.push(param2);
               break;
            case "enemy":
               if(this.ENEMY_TEAM.length == 3)
               {
                  return;
               }
               this.ENEMY_TEAM.push(param2);
         }
      }
      
      public function destroy() : *
      {
         this.reset();
      }
   }
}

