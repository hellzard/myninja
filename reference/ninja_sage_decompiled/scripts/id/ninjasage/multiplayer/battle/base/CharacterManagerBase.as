package id.ninjasage.multiplayer.battle.base
{
   public class CharacterManagerBase
   {
       
      
      public var character;
      
      public var character_model;
      
      private var talentsMap;
      
      private var senjutsuMap;
      
      public function CharacterManagerBase(param1:*)
      {
         this.talentsMap = {};
         this.senjutsuMap = {};
         super();
         this.character = param1;
         this.fillMaps();
      }
      
      public function getPlayerTeam() : String
      {
         return this.character_model.getPlayerTeam();
      }
      
      public function getPlayerNumber() : int
      {
         return this.character_model.getPlayerNumber();
      }
      
      public function setModel(param1:CharacterModelBase) : *
      {
         this.character_model = param1;
      }
      
      public function getName() : String
      {
         return this.character.character_data.character_name;
      }
      
      public function getLevel() : int
      {
         return int(this.character.character_data.character_level);
      }
      
      public function getMaxHP() : int
      {
         return 0;
      }
      
      public function getMaxCP() : int
      {
         return 0;
      }
      
      public function getMaxSP() : int
      {
         return 0;
      }
      
      public function getClanBuildingLevel(param1:String) : int
      {
         return 0;
      }
      
      public function getElementType(param1:int) : int
      {
         if(param1 == 1)
         {
            if("character_data" in this.character)
            {
               return int(this.character.character_data.character_element_1);
            }
         }
         else if(param1 == 2)
         {
            if("character_data" in this.character)
            {
               return int(this.character.character_data.character_element_2);
            }
         }
         else if(param1 == 3)
         {
            if("character_data" in this.character)
            {
               return int(this.character.character_data.character_element_3);
            }
         }
         return 0;
      }
      
      public function getTalentType(param1:int) : String
      {
         if("character_data" in this.character)
         {
            if(param1 == 1)
            {
               return String(this.character.character_data.character_talent_1);
            }
            if(param1 == 2)
            {
               return String(this.character.character_data.character_talent_2);
            }
            if(param1 == 3)
            {
               return String(this.character.character_data.character_talent_3);
            }
         }
         return "";
      }
      
      public function getRank() : int
      {
         return int(this.character.character_data.character_rank);
      }
      
      public function getID() : int
      {
         return int(this.character.char_id);
      }
      
      public function getSessionKey() : String
      {
         return this.character.sessionkey;
      }
      
      public function getFace() : String
      {
         return this.character.character_sets.face;
      }
      
      public function getHair() : String
      {
         return this.character.character_sets.hairstyle;
      }
      
      public function getAnimations() : Object
      {
         return this.character.character_sets.anims || {};
      }
      
      public function getWeapon() : String
      {
         return this.character.character_sets.weapon;
      }
      
      public function getAccessory() : String
      {
         return this.character.character_sets.accessory;
      }
      
      public function getBackItem() : String
      {
         return this.character.character_sets.back_item;
      }
      
      public function getClothing() : String
      {
         return this.character.character_sets.clothing;
      }
      
      public function getHairColor() : String
      {
         return this.character.character_sets.hair_color;
      }
      
      public function getSkinColor() : String
      {
         return this.character.character_sets.skin_color;
      }
      
      public function getWindAttributes() : int
      {
         return int(this.character.character_points.atrrib_wind);
      }
      
      public function getFireAttributes() : int
      {
         return int(this.character.character_points.atrrib_fire);
      }
      
      public function getLightningAttributes() : int
      {
         return int(this.character.character_points.atrrib_lightning);
      }
      
      public function getEarthAttributes() : int
      {
         return int(this.character.character_points.atrrib_earth);
      }
      
      public function getWaterAttributes() : int
      {
         return int(this.character.character_points.atrrib_water);
      }
      
      public function getAgility() : int
      {
         return 0;
      }
      
      public function recalculateHP() : int
      {
         return 0;
      }
      
      public function recalculateCP() : int
      {
         return 0;
      }
      
      public function recalculateSP() : int
      {
         return 0;
      }
      
      public function getPurify() : int
      {
         return 0;
      }
      
      public function checkBlockDamage() : int
      {
         return 0;
      }
      
      public function checkIgnoreBlockDamage() : int
      {
         return 0;
      }
      
      public function checkConvertDamage() : Boolean
      {
         return false;
      }
      
      public function getEquippedSkills() : Array
      {
         if(!this.character || !this.character.character_sets || !this.character.character_sets.skills)
         {
            return [];
         }
         if(this.character.character_sets.skills is Array)
         {
            return this.character.character_sets.skills;
         }
         var _loc1_:String = String(this.character.character_sets.skills);
         _loc1_ = _loc1_.replace(/^\s+|\s+$/g,"");
         return !!_loc1_ ? _loc1_.split(/\s*,\s*/) : [];
      }
      
      public function getSpecificSkill(param1:String) : Boolean
      {
         var _loc4_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:Array = this.getEquippedSkills();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      public function getEquippedSenjutsuSkills() : Array
      {
         if(this.character.character_sets.senjutsu_skills != null)
         {
            if(this.character.character_sets.senjutsu_skills is Array)
            {
               return this.character.character_sets.senjutsu_skills;
            }
            if(this.character.character_sets.senjutsu_skills.indexOf(",") >= 0)
            {
               return this.character.character_sets.senjutsu_skills.split(",");
            }
            return [this.character.character_sets.senjutsu_skills];
         }
         return [];
      }
      
      public function getTalentsSkills() : Array
      {
         if(this.character.character_inventory.char_talent_skills == "")
         {
            return [];
         }
         if(this.character.character_inventory.char_talent_skills is Array)
         {
            return this.character.character_inventory.char_talent_skills;
         }
         return this.character.character_inventory.char_talent_skills.split(",");
      }
      
      public function getSenjutsuSkills() : Array
      {
         if(this.character.character_inventory.char_senjutsu_skills == "")
         {
            return [];
         }
         if(this.character.character_inventory.char_senjutsu_skills is Array)
         {
            return this.character.character_inventory.char_senjutsu_skills;
         }
         return this.character.character_inventory.char_senjutsu_skills.split(",");
      }
      
      public function getSkillsWithCooldown(param1:Array) : *
      {
         this.character_model.skills_with_cooldown = param1;
      }
      
      public function hasTalentSkill(param1:String) : Boolean
      {
         return this.talentsMap.hasOwnProperty(param1);
      }
      
      public function getTalentLevel(param1:String) : int
      {
         if(this.hasTalentSkill(param1))
         {
            return this.talentsMap[param1];
         }
         return 0;
      }
      
      public function hasSenjutsuSkill(param1:String) : Boolean
      {
         return this.senjutsuMap.hasOwnProperty(param1);
      }
      
      public function getSenjutsuLevel(param1:String) : int
      {
         if(this.hasSenjutsuSkill(param1))
         {
            return this.senjutsuMap[param1];
         }
         return 0;
      }
      
      private function fillMaps() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = this.getTalentsSkills();
         for each(_loc2_ in _loc1_)
         {
            _loc5_ = _loc2_.split(":");
            this.talentsMap[_loc5_[0]] = int(_loc5_[1]);
         }
         _loc3_ = this.getSenjutsuSkills();
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = _loc4_.split(":");
            this.senjutsuMap[_loc6_[0]] = int(_loc6_[1]);
         }
      }
      
      public function get characterClanData() : Object
      {
         return this.character.clan;
      }
      
      public function destroy() : *
      {
         this.talentsMap = null;
         this.senjutsuMap = null;
         this.character = null;
         this.character_model = null;
      }
   }
}
