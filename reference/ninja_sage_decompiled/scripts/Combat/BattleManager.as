package Combat
{
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import flash.system.System;
   import flash.utils.setTimeout;
   
   public class BattleManager
   {
      
      public static var BATTLE:Battle;
      
      public static var BATTLE_TOOLTIP:BattleTooltip;
      
      public static var BATTLE_LOADER:BattleLoader;
      
      public static var BATTLE_VARS:BattleVars;
      
      public static var MAIN:main;
       
      
      public function BattleManager()
      {
         super();
      }
      
      public static function init(param1:Battle, param2:main, param3:String, param4:String, param5:String = "BattleBG") : void
      {
         BATTLE = param1;
         MAIN = param2;
         if(BATTLE_TOOLTIP == null)
         {
            BATTLE_TOOLTIP = new BattleTooltip();
         }
         if(BATTLE_VARS)
         {
            BATTLE_VARS.reset();
         }
         else
         {
            BATTLE_VARS = new BattleVars();
         }
         BATTLE_VARS.BATTLE_MODE = param3;
         BATTLE_VARS.BATTLE_BACKGROUND = param4;
         BATTLE_VARS.ORIGINAL_BATTLE_BACKGROUND = param4;
         if(BATTLE_LOADER == null)
         {
            BATTLE_LOADER = new BattleLoader();
         }
         BattleLoader.BG_Linkage = param5;
         BattleVars.CHARACTER_REVIVED = [false,false,false];
         BattleVars.CHARACTER_TEAM_REVIVED = [false,false,false];
         BattleVars.CHARACTER_LEFT_REDUCE_CD = [2,2,2];
         BattleVars.CHARACTER_ICM = [false,false,false];
         BattleVars.ENEMY_REVIVED = [false,false,false];
         BattleVars.ENEMY_TEAM_REVIVED = [false,false,false];
         BattleVars.ENEMY_ICM = [false,false,false];
         BattleVars.ENEMY_LEFT_REDUCE_CD = [2,2,2];
         BattleVars.PLAYER_TEAM_LOADED = false;
         BattleVars.ENEMY_TEAM_LOADED = false;
         BattleVars.PLAYER_TARGET = 0;
         BattleVars.MASTER_PLAYER_TARGET = 0;
         BattleVars.ENEMY_TARGET = 0;
         BattleVars.MATCH_RUNNING = true;
      }
      
      public static function modifyChance(param1:Array, param2:String, param3:int, param4:String = "") : int
      {
         var _loc6_:Object = null;
         var _loc7_:Boolean = false;
         var _loc5_:int = 0;
         for each(_loc6_ in param1)
         {
            _loc5_ = _loc6_.amount;
            _loc7_ = false;
            switch(_loc6_.effect)
            {
               case "transform":
               case "pet_frenzy":
                  _loc5_ = _loc6_.amount_cp;
                  break;
               case "meditation":
                  _loc5_ = _loc6_.amount_dodge;
                  break;
               case "slow":
               case "slow_oil":
                  if(_loc6_.calc_type == "number")
                  {
                     param3 -= _loc6_.amount;
                  }
                  else
                  {
                     param3 -= Math.floor(param3 * _loc5_ / 100);
                  }
                  continue;
               case "cp_cost":
                  if(_loc6_.calc_type == "number")
                  {
                     param3 += _loc5_;
                  }
                  else if(_loc6_.calc_type == "added_percent")
                  {
                     param3 += Math.floor(_loc5_ * param3 / 100);
                  }
                  else
                  {
                     param3 = Math.floor(_loc5_ * param3);
                  }
                  continue;
            }
            if(param2 == "ADD")
            {
               if(param4 != "accuracy" && param4 != "purify" && param4 != "dodge" && param4 != "critical" && param4 != "reactive_force")
               {
                  param3 = _loc6_.calc_type == "percent" ? (int(param3 = param3 + Math.round(param3 * _loc5_ / 100))) : (int(param3 = param3 + _loc5_));
               }
               else if(_loc6_.effect == "aqua_regia" && param4 == "accuracy")
               {
                  param3 += _loc6_.increase_accuracy;
               }
               else if(_loc6_.effect == "aqua_regia" && param4 == "purify")
               {
                  param3 += _loc6_.increase_purify;
               }
               else
               {
                  param3 += _loc5_;
               }
            }
            else if(param2 == "RM")
            {
               if(param4 != "accuracy" && param4 != "purify" && param4 != "dodge" && param4 != "critical" && param4 != "reactive_force")
               {
                  param3 = _loc6_.calc_type == "percent" ? (int(param3 = param3 - Math.round(param3 * _loc5_ / 100))) : (int(param3 = param3 - _loc5_));
               }
               else
               {
                  param3 -= _loc5_;
               }
            }
            if(param4 == "critical")
            {
            }
         }
         return param3;
      }
      
      public static function showMessage(param1:String) : *
      {
         MAIN.showMessage(param1);
      }
      
      public static function giveMessage(param1:String) : void
      {
         MAIN.giveMessage(param1);
      }
      
      public static function getNotice(param1:String) : void
      {
         MAIN.getNotice(param1);
      }
      
      public static function startBattle() : void
      {
         if(int(Character.character_rank) < 6)
         {
            Character.character_class = null;
         }
         MAIN.loading(true);
         var _loc1_:int = 0;
         var _loc2_:Array = Character.temp_recruit_ids.length > 0 ? Character.temp_recruit_ids : Character.character_recruit_ids;
         _loc2_ = BATTLE_VARS.BATTLE_MODE == BattleVars.CREW_MATCH ? Character.temp_recruit_ids : _loc2_;
         if(Character.is_independence_event)
         {
            if(Character.character_recruit_ids.length > 0)
            {
               _loc2_[1] = Character.character_recruit_ids[0];
            }
         }
         while(_loc1_ < _loc2_.length)
         {
            if(!MAIN.is_exam_stage3 && !Character.is_clan_war && !MAIN.is_jounin_exam_stage2 && !Character.is_ramadhan_event && BATTLE_VARS.BATTLE_MODE != BattleVars.SHADOWWAR_MATCH)
            {
               addPlayerToTeam("player",_loc2_[_loc1_]);
            }
            _loc1_++;
         }
         Character.battle_logs = [];
         BattleTooltip.reInitTooltip();
         BATTLE.setupView();
      }
      
      public static function hideEverything() : void
      {
         BATTLE_LOADER.hideEverything();
      }
      
      public static function addPlayerToTeam(param1:String, param2:String) : void
      {
         BATTLE_VARS.addPlayerToTeam(param1,param2);
      }
      
      public static function getBackgound() : String
      {
         return BATTLE_VARS.BATTLE_BACKGROUND;
      }
      
      public static function getPlayerTeam() : Array
      {
         return BATTLE_VARS.PLAYER_TEAM;
      }
      
      public static function getEnemyTeam() : Array
      {
         return BATTLE_VARS.ENEMY_TEAM;
      }
      
      public static function getMain() : main
      {
         return MAIN;
      }
      
      public static function getBattle() : Battle
      {
         return BATTLE;
      }
      
      public static function loadPlayerTeam(param1:int = 0) : void
      {
         BATTLE_LOADER.loadPlayerTeam(param1);
      }
      
      public static function loadEnemyTeam(param1:int = 0) : void
      {
         BATTLE_LOADER.loadEnemyTeam(param1);
         setTimeout(checkStartMatch,100);
      }
      
      public static function checkStartMatch() : *
      {
         if(BattleVars.PLAYER_TEAM_LOADED && BattleVars.ENEMY_TEAM_LOADED)
         {
            BattleVars.PLAYER_TEAM_LOADED = false;
            BattleVars.ENEMY_TEAM_LOADED = false;
            setTimeout(BATTLE.setupAgilityBar,100);
         }
      }
      
      public static function loadBackground() : void
      {
         BATTLE_LOADER.loadBackground();
      }
      
      public static function loading(param1:*) : void
      {
         MAIN.loading(param1);
      }
      
      public static function startRun() : void
      {
         if(BATTLE == null || BATTLE.agility_bar_manager == null)
         {
            return;
         }
         BATTLE.agility_bar_manager.startRun();
      }
      
      public static function getTotalDamage() : int
      {
         return BATTLE.total_damage;
      }
      
      public static function playBgm() : *
      {
         if(!MAIN)
         {
            return;
         }
         MAIN.stopAllBgm();
         MAIN.startBgm("battle");
      }
      
      public static function destroyCombat() : *
      {
         if(BATTLE_LOADER)
         {
            BATTLE_LOADER.destroy();
         }
         if(BATTLE_VARS)
         {
            BATTLE_VARS.destroy();
         }
         if(BATTLE_TOOLTIP)
         {
            BATTLE_TOOLTIP.destroy();
         }
         BATTLE_VARS = null;
         BATTLE_LOADER = null;
         BATTLE_TOOLTIP = null;
         BATTLE = null;
         MAIN = null;
         BattleManager.unloadBattleSwfs();
         System.gc();
      }
      
      private static function unloadBattleSwfs() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:BulkLoader = BulkLoader.getLoader("combat");
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_.items)
         {
            if((_loc5_ = _loc3_.url.url).indexOf("enemy/") >= 0 || _loc5_.indexOf("npcs/") >= 0 || _loc5_.indexOf("mission/") >= 0)
            {
               _loc2_.push(_loc5_);
            }
         }
         for each(_loc4_ in _loc2_)
         {
            _loc1_.remove(_loc4_);
         }
      }
   }
}
