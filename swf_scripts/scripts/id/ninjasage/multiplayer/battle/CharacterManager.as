package id.ninjasage.multiplayer.battle
{
   import Managers.AppManager;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.base.CharacterManagerBase;
   
   public class CharacterManager extends CharacterManagerBase
   {
      
      private var actionManager:*;
      
      private var _mockedCharId:int = -1;
      
      public function CharacterManager(param1:Object)
      {
         this.fillCharacterData(param1);
         super(param1);
      }
      
      public function getSpecialClass() : String
      {
         return this.character.character_data.character_class || null;
      }
      
      public function getSenjutsu() : String
      {
         return this.character.character_data.character_senjutsu || null;
      }
      
      override public function getMaxHP() : int
      {
         return this.character.stats.maxHp;
      }
      
      public function getCurrentHP() : int
      {
         return this.character.stats.hp;
      }
      
      override public function getMaxCP() : int
      {
         return this.character.stats.maxCp;
      }
      
      public function getCurrentCP() : int
      {
         return this.character.stats.cp;
      }
      
      override public function getMaxSP() : int
      {
         return this.character.stats.maxSp;
      }
      
      public function getCurrentSP() : int
      {
         return this.character.stats.sp;
      }
      
      public function getCurrentXP() : int
      {
         return this.character.character_data.character_xp;
      }
      
      public function getMaxXP() : int
      {
         return AppManager.getInstance().main.stat_manager.calculate_xp(this.getLevel());
      }
      
      public function setActionManager(param1:*) : *
      {
         this.actionManager = param1;
      }
      
      public function getActionManager() : *
      {
         return this.actionManager;
      }
      
      public function getCharacterModel() : CharacterModel
      {
         return this.character_model;
      }
      
      public function isDead() : Boolean
      {
         return this.character.stats.hp <= 0;
      }
      
      override public function getAgility() : int
      {
         return int(this.character.stats.agility) || 0;
      }
      
      public function getEnemyRandomSkills() : Object
      {
         return this.character.enemy_random_skills;
      }
      
      public function getScrolls() : int
      {
         return this.character.scrolls;
      }
      
      public function fillCharacterData(param1:Object) : void
      {
         param1.stats = param1.stat;
         param1.char_id = param1.id;
         param1.character_sets = {
            "weapon":param1.set.weapon,
            "back_item":param1.set.back_item,
            "clothing":param1.set.clothing,
            "hairstyle":param1.set.hairstyle,
            "face":param1.set.face,
            "hair_color":param1.set.hair_color,
            "skin_color":param1.set.skin_color,
            "anims":param1.set.animations,
            "skills":param1.set.skills,
            "senjutsu_skills":param1.set.senjutsus
         };
         param1.character_data = {
            "character_id":param1.id,
            "character_name":param1.name,
            "character_level":param1.level,
            "character_rank":param1.rank,
            "character_xp":param1.xp,
            "character_element_1":(param1.hasOwnProperty("element_1") ? param1.element_1 : (param1.hasOwnProperty("elements") ? param1.elements[0] : "")),
            "character_element_2":(param1.hasOwnProperty("element_2") ? param1.element_2 : (param1.hasOwnProperty("elements") ? param1.elements[1] : "")),
            "character_element_3":(param1.hasOwnProperty("element_3") ? param1.element_3 : (param1.hasOwnProperty("elements") ? param1.elements[2] : "")),
            "character_talent_1":(param1.hasOwnProperty("talent_1") ? param1.talent_1 : (param1.hasOwnProperty("talents") ? param1.talents[0] : "")),
            "character_talent_2":(param1.hasOwnProperty("talent_2") ? param1.talent_2 : (param1.hasOwnProperty("talents") ? param1.talents[1] : "")),
            "character_talent_3":(param1.hasOwnProperty("talent_3") ? param1.talent_3 : (param1.hasOwnProperty("talents") ? param1.talents[2] : "")),
            "character_class":(param1.hasOwnProperty("special_class") ? param1.special_class : null),
            "character_senjutsu":(param1.hasOwnProperty("senjutsu") ? param1.senjutsu : null)
         };
         param1.character_points = {
            "atrrib_wind":param1.point.wind,
            "atrrib_fire":param1.point.fire,
            "atrrib_lightning":param1.point.lightning,
            "atrrib_water":param1.point.water,
            "atrrib_earth":param1.point.earth,
            "atrrib_free":param1.point.free
         };
         param1.character_inventory = {
            "char_talent_skills":(Boolean(param1.set) && Boolean(param1.set.talents) ? param1.set.talents : ""),
            "char_senjutsu_skills":(Boolean(param1.set) && Boolean(param1.set.senjutsus) ? param1.set.senjutsus : "")
         };
         param1.enemy_random_skills = {};
         param1.scrolls = param1.hasOwnProperty("scrolls") ? param1.scrolls : 0;
      }
      
      public function updateStats(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this.character.stats.hasOwnProperty(_loc2_))
            {
               this.character.stats[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function updateScrolls(param1:int) : void
      {
         this.character.scrolls = param1;
      }
      
      public function updateEnemyRandomSkills(param1:Object) : void
      {
         this.character.enemy_random_skills = param1;
      }
      
      public function setCharId(param1:int) : void
      {
         this._mockedCharId = param1;
      }
      
      public function revertCharId() : void
      {
         this._mockedCharId = -1;
      }
      
      override public function getID() : int
      {
         if(this._mockedCharId >= 0)
         {
            return this._mockedCharId;
         }
         return super.getID();
      }
      
      override public function destroy() : *
      {
         Log.debug(this,"destroy",this.getID());
         if(this.character_model)
         {
            this.character_model.destroy();
         }
         if(this.actionManager)
         {
            this.actionManager.destroy();
         }
         super.destroy();
         this.actionManager = null;
      }
   }
}

