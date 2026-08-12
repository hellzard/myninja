package Combat
{
   import Managers.StatManager;
   import Storage.Character;
   import com.utils.NumberUtil;
   import id.ninjasage.multiplayer.battle.base.CharacterManagerBase;
   
   public class CharacterManager extends CharacterManagerBase
   {
       
      
      public function CharacterManager(param1:*)
      {
         super(param1);
      }
      
      override public function getMaxHP() : int
      {
         var _loc1_:Object = this.character_model.character_info;
         return "character_hp" in _loc1_ ? int(_loc1_.character_max_hp) : 0;
      }
      
      override public function getMaxCP() : int
      {
         var _loc1_:Object = this.character_model.character_info;
         return "character_cp" in _loc1_ ? int(_loc1_.character_max_cp) : 0;
      }
      
      override public function getClanBuildingLevel(param1:String) : int
      {
         if(!this.character.hasOwnProperty("clan") || this.character.clan == null)
         {
            return 0;
         }
         return int(this.character.clan[param1]);
      }
      
      override public function getAgility() : int
      {
         return StatManager.getAgility(this);
      }
      
      override public function recalculateHP() : int
      {
         return StatManager.recalculateHp(this);
      }
      
      override public function recalculateCP() : int
      {
         return StatManager.recalculateCp(this);
      }
      
      override public function recalculateSP() : int
      {
         return StatManager.recalculateSp(this);
      }
      
      override public function getPurify() : int
      {
         return StatManager.getPurify(this);
      }
      
      override public function checkBlockDamage() : int
      {
         return int(StatManager.getBlockChance(this));
      }
      
      override public function checkIgnoreBlockDamage() : int
      {
         return int(StatManager.getIgnoreBlockChance(this));
      }
      
      override public function checkConvertDamage() : Boolean
      {
         var _loc1_:int = StatManager.getConvertChance(this);
         var _loc2_:int = NumberUtil.getRandomInt();
         return _loc1_ > 0 && _loc1_ >= _loc2_;
      }
      
      public function checkConvertDamageCP() : Boolean
      {
         var _loc1_:int = StatManager.getConvertChanceCP(this);
         var _loc2_:int = NumberUtil.getRandomInt();
         return _loc1_ > 0 && _loc1_ >= _loc2_;
      }
      
      public function isActionsManagerLoaded() : Boolean
      {
         return this.character_model.actions_manager.all_loaded;
      }
      
      public function getAllCharacterInfo() : Object
      {
         var _loc1_:* = this.character.character_data;
         var _loc2_:* = this.character.character_sets;
         var _loc3_:* = this.character.character_points;
         var _loc4_:* = _loc1_.character_class;
         var _loc5_:* = BattleManager.getMain();
         if(this.character_model.getPlayerTeam() == "player" && this.character_model.getPlayerNumber() == 0)
         {
            _loc4_ = this.checkSpecialJouninExam(_loc4_,_loc5_);
         }
         return {
            "character_id":_loc1_.character_id,
            "character_name":_loc1_.character_name,
            "character_level":_loc1_.character_level,
            "character_rank":_loc1_.character_rank,
            "character_sw_rank":_loc1_.character_sw_rank,
            "character_xp":_loc1_.character_xp,
            "character_hp":StatManager.getHp(this),
            "character_max_hp":StatManager.getHp(this),
            "character_cp":StatManager.getCp(this),
            "character_max_cp":StatManager.getCp(this),
            "character_sp":StatManager.getSp(this),
            "character_max_sp":StatManager.getSp(this),
            "original_character_max_cp":StatManager.getCp(this),
            "hair_color":_loc2_.hair_color,
            "skin_color":_loc2_.skin_color,
            "character_face":_loc2_.face,
            "character_hair":_loc2_.hairstyle,
            "character_weapon":_loc2_.weapon,
            "character_accessory":_loc2_.accessory,
            "character_back_item":_loc2_.back_item,
            "character_set":_loc2_.clothing,
            "character_equipped_skills":_loc2_.skills,
            "character_class":_loc4_,
            "character_agility":StatManager.getAgility(this),
            "character_dodge":StatManager.getDodge(this),
            "character_critical":StatManager.getCritical(this),
            "character_accuracy":StatManager.getAccuracy(this)
         };
      }
      
      public function getTalentSkillsString() : String
      {
         if(this.character_model.getPlayerTeam() == "player" && this.character_model.getPlayerNumber() == 0)
         {
            return Character.character_talent_skills;
         }
         if(this.character.hasOwnProperty("character_inventory") && this.character.character_inventory.hasOwnProperty("char_talent_skills"))
         {
            return this.character.character_inventory.char_talent_skills;
         }
         return "";
      }
      
      public function getSenjutsuSkillsString() : String
      {
         if(this.character_model.getPlayerTeam() == "player" && this.character_model.getPlayerNumber() == 0)
         {
            return Character.character_senjutsu_skills;
         }
         if(this.character.hasOwnProperty("character_inventory") && this.character.character_inventory.hasOwnProperty("char_senjutsu_skills"))
         {
            return this.character.character_inventory.char_senjutsu_skills;
         }
         return "";
      }
      
      private function checkSpecialJouninExam(param1:*, param2:*) : *
      {
         if(param2.is_special_jounin_exam_s1c2 && Character.mission_id == "special_jounin_s1c2_3")
         {
            Character.character_class = "skill_4002";
            return "skill_4002";
         }
         if(param2.is_special_jounin_exam_s2c2 && Character.mission_id == "special_jounin_s2c2_3")
         {
            Character.character_class = "skill_4004";
            return "skill_4004";
         }
         if(param2.is_special_jounin_exam_s3c2 && Character.mission_id == "special_jounin_s3c2_2")
         {
            Character.character_class = "skill_4001";
            return "skill_4001";
         }
         if(param2.is_special_jounin_exam_s4c2)
         {
            Character.character_class = "skill_4003";
            return "skill_4003";
         }
         if(param2.is_special_jounin_exam_s5c2)
         {
            Character.character_class = "skill_4000";
            return "skill_4000";
         }
         if(param2.is_special_jounin_exam_s6c1 || param2.is_special_jounin_exam_s6c2 || param2.is_special_jounin_exam_s6c3)
         {
            Character.character_class = null;
            return null;
         }
         return param1;
      }
      
      override public function destroy() : *
      {
         super.destroy();
         this.character = null;
         this.character_model = null;
      }
   }
}
