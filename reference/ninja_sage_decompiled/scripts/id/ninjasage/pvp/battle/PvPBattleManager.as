package id.ninjasage.pvp.battle
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import flash.system.System;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.EffectOverlay;
   import id.ninjasage.multiplayer.battle.Battle;
   import id.ninjasage.multiplayer.battle.CharacterManager;
   import id.ninjasage.multiplayer.battle.PetManager;
   import id.ninjasage.pvp.PvP;
   
   public class PvPBattleManager
   {
      
      private static var _instance:PvPBattleManager;
      
      private static var _battle:Battle;
      
      private static var _battleLoader:PvPBattleLoader;
      
      private static var _battleVars:PvPBattleVars;
      
      private static var _agilityBarManager:PvPAgilityBarManager;
      
      private static var _battleHandler:PvPBattleHandler;
      
      private static var _battleTooltip:PvPBattleTooltip;
      
      private static var _effectOverlay:EffectOverlay;
      
      private static var _main;
      
      private static var _pvp:PvP;
      
      private static var _isHost:Boolean = false;
      
      private static var _isSpectator:Boolean = false;
      
      private static var _isDestroying:Boolean = false;
      
      private static var _characterManagers = {
         "player":[],
         "enemy":[]
      };
      
      private static var _petManagers = {
         "player_pet":[],
         "enemy_pet":[]
      };
       
      
      public function PvPBattleManager()
      {
         super();
         if(_instance)
         {
            throw new Error("PvPBattleManager is a singleton. Use getInstance() instead.");
         }
      }
      
      public static function getInstance() : PvPBattleManager
      {
         if(!_instance)
         {
            _instance = new PvPBattleManager();
         }
         return _instance;
      }
      
      public static function init(param1:PvP, param2:String) : void
      {
         if(!param1)
         {
            Log.error("PvPBattleManager","init","PvP instance is null");
            return;
         }
         if(!param2 || param2.length == 0)
         {
            Log.warning("PvPBattleManager","init","No background ID provided, using default");
            param2 = "mission_1011";
         }
         _pvp = param1;
         _battle = param1.battleUI;
         _main = param1.main;
         if(!_main)
         {
            Log.error("PvPBattleManager","init","Main instance is null");
            return;
         }
         if(_battleVars)
         {
            _battleVars.reset();
         }
         else
         {
            _battleVars = new PvPBattleVars();
         }
         _battleVars.battleMode = "PVP";
         _battleVars.battleBackground = param2;
         _battleVars.originalBattleBackground = param2;
         if(!_battleTooltip)
         {
            _battleTooltip = new PvPBattleTooltip();
         }
         if(!_effectOverlay && _battle)
         {
            _effectOverlay = new EffectOverlay(_battle);
            _effectOverlay.init();
         }
         if(!_battleLoader)
         {
            _battleLoader = new PvPBattleLoader(_battle,_main);
         }
         _battleVars.matchRunning = true;
      }
      
      public static function initiateBattle(param1:PvP, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(!param1 || !param2)
         {
            Log.error("PvPBattleManager","initiateBattle","Invalid parameters");
            return;
         }
         Log.info("PvPBattleManager","initiateBattle","Starting PvP battle");
         _isSpectator = param1.spectatorMode || param2.hasOwnProperty("spectator") && param2.spectator === true;
         if(!_isSpectator)
         {
            if((_loc4_ = param2.hostId || param2.host_char_id) && param1.character)
            {
               _isHost = String(_loc4_) == String(param1.character.getID());
            }
         }
         else
         {
            _isHost = false;
            if((_loc5_ = param2.hostId || param2.host_char_id) && param1.character)
            {
               param1.character.setCharId(int(_loc5_));
            }
         }
         var _loc3_:String = param2.background || param2.stage || "mission_1011";
         init(param1,_loc3_);
         if(!_battleVars)
         {
            Log.error("PvPBattleManager","initiateBattle","Battle vars not initialized");
            return;
         }
         _battleVars.battleId = param2.battleId || "";
         _battleVars.elapsedMs = Math.max(0,Number(param2.elapsedMs || 0));
         _battleVars.matchMode = param2.mode || "";
         setupTeams(param2);
         _battleLoader.loadBackground();
         _battleLoader.hideEverything();
         _battleLoader.loadPlayer();
         if(!_agilityBarManager)
         {
            _agilityBarManager = new PvPAgilityBarManager();
            _battleHandler = new PvPBattleHandler();
         }
         _pvp.visible = false;
         _main.loader.addChild(_battle);
      }
      
      private static function setupTeams(param1:Object) : void
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc2_:String = param1.hostId || param1.host_char_id;
         var _loc3_:String = param1.enemyId || param1.enemy_char_id;
         if(!_loc2_ || !_loc3_)
         {
            Log.warning("PvPBattleManager","setupTeams","Missing hostId or enemyId in payload");
            return;
         }
         var _loc4_:String = !!_isHost ? _loc2_ : _loc3_;
         var _loc5_:String = !!_isHost ? _loc3_ : _loc2_;
         if(_loc4_)
         {
            _battleVars.addPlayerToTeam("player",_loc4_);
         }
         if(_loc5_)
         {
            _battleVars.addPlayerToTeam("enemy",_loc5_);
         }
         if(param1.playerTeam && param1.playerTeam is Array)
         {
            _loc6_ = param1.playerTeam as Array;
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _battleVars.addPlayerToTeam("player",_loc6_[_loc7_]);
               _loc7_++;
            }
         }
         if(param1.enemyTeam && param1.enemyTeam is Array)
         {
            _loc8_ = param1.enemyTeam as Array;
            _loc7_ = 0;
            while(_loc7_ < _loc8_.length)
            {
               _battleVars.addPlayerToTeam("enemy",_loc8_[_loc7_]);
               _loc7_++;
            }
         }
      }
      
      public static function endBattle(param1:Object = null) : void
      {
         if(_isDestroying)
         {
            Log.warning("PvPBattleManager","endBattle","Already destroying battle, skipping re-entrant call");
            return;
         }
         Log.info("PvPBattleManager","endBattle","Ending PvP battle");
         _isDestroying = true;
         if(_battleVars)
         {
            _battleVars.matchRunning = false;
         }
         destroyBattle();
         _isDestroying = false;
      }
      
      public static function hideEverything() : void
      {
         if(_battleLoader)
         {
            _battleLoader.hideEverything();
         }
      }
      
      public static function addPlayerToTeam(param1:String, param2:String) : void
      {
         var _loc3_:Boolean = false;
         if(_battleVars)
         {
            _loc3_ = _battleVars.addPlayerToTeam(param1,param2);
            if(!_loc3_)
            {
               Log.warning("PvPBattleManager","addPlayerToTeam","Failed to add character " + param2 + " to team " + param1);
            }
         }
      }
      
      public static function getBackground() : String
      {
         return !!_battleVars ? _battleVars.battleBackground : "";
      }
      
      public static function getPlayerTeam() : Array
      {
         return !!_battleVars ? _battleVars.playerTeam : [];
      }
      
      public static function getEnemyTeam() : Array
      {
         return !!_battleVars ? _battleVars.enemyTeam : [];
      }
      
      public static function getMain() : *
      {
         return _main;
      }
      
      public static function getBattle() : Battle
      {
         return _battle;
      }
      
      public static function getBattleID() : String
      {
         return !!_battleVars ? _battleVars.battleId : "";
      }
      
      public static function getBattleElapsedMs() : Number
      {
         return !!_battleVars ? Number(_battleVars.elapsedMs) : Number(0);
      }
      
      public static function getIsHost() : Boolean
      {
         return _isHost;
      }
      
      public static function getIsSpectator() : Boolean
      {
         return _isSpectator;
      }
      
      public static function getIsRankedMode() : Boolean
      {
         return _battleVars && _battleVars.matchMode === "ranked";
      }
      
      public static function getCharacterManagerByID(param1:String) : CharacterManager
      {
         var _loc3_:Array = null;
         var _loc4_:CharacterManager = null;
         var _loc5_:int = 0;
         var _loc2_:int = int(param1);
         _loc3_ = _characterManagers["player"];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((_loc4_ = _loc3_[_loc5_] as CharacterManager) && _loc4_.getID() == _loc2_)
            {
               return _loc4_;
            }
            _loc5_++;
         }
         _loc3_ = _characterManagers["enemy"];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((_loc4_ = _loc3_[_loc5_] as CharacterManager) && _loc4_.getID() == _loc2_)
            {
               return _loc4_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public static function getPetManagerByID(param1:String) : PetManager
      {
         var _loc3_:Array = null;
         var _loc4_:PetManager = null;
         var _loc5_:int = 0;
         var _loc2_:String = param1;
         _loc3_ = _petManagers["player_pet"];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((_loc4_ = _loc3_[_loc5_] as PetManager) && _loc4_.getID() == _loc2_)
            {
               return _loc4_;
            }
            _loc5_++;
         }
         _loc3_ = _petManagers["enemy_pet"];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((_loc4_ = _loc3_[_loc5_] as PetManager) && _loc4_.getID() == _loc2_)
            {
               return _loc4_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public static function loadBackground() : void
      {
         if(_battleLoader)
         {
            _battleLoader.loadBackground();
         }
      }
      
      public static function loading(param1:Boolean) : void
      {
         if(_main && _main.hasOwnProperty("loading"))
         {
            _main.loading(param1);
         }
      }
      
      public static function destroyBattle() : void
      {
         var team:* = undefined;
         var num:* = undefined;
         var characterManager:CharacterManager = null;
         var petManager:PetManager = null;
         Log.debug("PvPBattleManager","destroyBattle","Destroying battle resources");
         if(_main && _main.loader.contains(_battle))
         {
            try
            {
               _main.loader.removeChild(_battle);
            }
            catch(e:Error)
            {
               Log.warning("PvPBattleManager","destroyBattle","Error removing battle from main loader: " + e.message);
            }
         }
         if(_battle)
         {
            try
            {
               _battle.clearBattleField();
            }
            catch(e:Error)
            {
               Log.warning("PvPBattleManager","destroyBattle","Error clearing battle field: " + e.message);
            }
            try
            {
               _battle.destroy();
            }
            catch(e:Error)
            {
               Log.warning("PvPBattleManager","destroyBattle","Error destroying battle: " + e.message);
            }
            _battle = null;
         }
         if(_battleLoader)
         {
            try
            {
               _battleLoader.destroy();
            }
            catch(e:Error)
            {
               Log.warning("PvPBattleManager","destroyBattle","Error destroying battle loader: " + e.message);
            }
            _battleLoader = null;
         }
         if(_battleVars)
         {
            _battleVars.matchRunning = false;
            try
            {
               _battleVars.destroy();
            }
            catch(e:Error)
            {
               Log.warning("PvPBattleManager","destroyBattle","Error destroying battle vars: " + e.message);
            }
            _battleVars = null;
         }
         if(_effectOverlay)
         {
            try
            {
               _effectOverlay.destroy();
            }
            catch(e:Error)
            {
               Log.warning("PvPBattleManager","destroyBattle","Error destroying effect overlay: " + e.message);
            }
            _effectOverlay = null;
         }
         if(_agilityBarManager)
         {
            _agilityBarManager.destroy();
            _agilityBarManager = null;
         }
         if(_battleHandler)
         {
            _battleHandler.destroy();
            _battleHandler = null;
         }
         if(_characterManagers)
         {
            for(team in _characterManagers)
            {
               for(num in _characterManagers[team])
               {
                  characterManager = _characterManagers[team][num];
                  if(characterManager)
                  {
                     characterManager.destroy();
                  }
               }
               _characterManagers[team] = [];
            }
         }
         if(_petManagers)
         {
            for(team in _petManagers)
            {
               for(num in _petManagers[team])
               {
                  petManager = _petManagers[team][num];
                  if(petManager)
                  {
                     petManager.destroy();
                  }
               }
               _petManagers[team] = [];
            }
         }
         if(_pvp)
         {
            _pvp.visible = true;
            _pvp.goToLobby();
         }
         if(_battleTooltip)
         {
            _battleTooltip.destroy();
            _battleTooltip = null;
         }
         if(_main)
         {
            _main.getLoader("combat").removeAll();
            _main.getLoader("assets").removeAll();
            _main.getLoader("specialclass").removeAll();
            _main.getLoader("skills").removeAll();
            _main.getLoader("talents").removeAll();
         }
         OutfitManager.releaseStaticMc();
         if(_pvp && _pvp.character && _isSpectator)
         {
            _pvp.character.revertCharId();
         }
         NinjaSage.clearLoader();
         _main = null;
         _pvp = null;
         _isHost = false;
         _isSpectator = false;
         System.gc();
      }
      
      public static function get BATTLE() : Battle
      {
         return _battle;
      }
      
      public static function get BATTLE_LOADER() : PvPBattleLoader
      {
         return _battleLoader;
      }
      
      public static function get BATTLE_VARS() : PvPBattleVars
      {
         return _battleVars;
      }
      
      public static function get MAIN() : *
      {
         return _main;
      }
      
      public static function get PVP() : PvP
      {
         return _pvp;
      }
      
      public static function get IS_HOST() : Boolean
      {
         return _isHost;
      }
      
      public static function get ROOM_INFO() : *
      {
         return _pvp.roomInfo;
      }
      
      public static function get CHARACTER_MANAGERS() : *
      {
         return _characterManagers;
      }
      
      public static function get PET_MANAGERS() : *
      {
         return _petManagers;
      }
      
      public static function get AGILITY_BAR_MANAGER() : *
      {
         return _agilityBarManager;
      }
      
      public static function get BATTLE_HANDLER() : PvPBattleHandler
      {
         return _battleHandler;
      }
      
      public static function addCharacterManager(param1:String, param2:int, param3:CharacterManager) : void
      {
         _characterManagers[param1][param2] = param3;
      }
      
      public static function addPetManager(param1:String, param2:int, param3:PetManager) : void
      {
         _petManagers[param1][param2] = param3;
      }
      
      public static function get BATTLE_TOOLTIP() : PvPBattleTooltip
      {
         return _battleTooltip;
      }
      
      public static function get EFFECT_OVERLAY() : EffectOverlay
      {
         return _effectOverlay;
      }
   }
}
