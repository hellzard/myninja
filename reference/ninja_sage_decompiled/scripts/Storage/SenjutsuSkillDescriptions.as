package Storage
{
   import flash.display.MovieClip;
   
   public class SenjutsuSkillDescriptions extends MovieClip
   {
       
      
      public var main;
      
      public function SenjutsuSkillDescriptions(param1:*)
      {
         super();
         this.main = param1;
      }
      
      public static function getSenjutsuSkillDescriptions(param1:String) : *
      {
         var _loc2_:* = {};
         switch(param1)
         {
            case "senjutsu_other_skill_1":
               _loc2_.id = "skill_3500";
               _loc2_.name = "Senjutsu: Super Charges";
               _loc2_.description = "Restore self HP and CP.";
               _loc2_.order = 1;
               break;
            case "senjutsu_other_skill_2":
               _loc2_.id = "skill_3000";
               _loc2_.name = "Senjutsu: Sage Mode";
               _loc2_.description = "Strengthen Senjutsu\'s power and allows casting Senjutsu without costing SP.";
               _loc2_.order = 2;
               break;
            case "senjutsu_other_skill_3":
               _loc2_.id = "skill_3501";
               _loc2_.name = "Senjutsu: Paper Bomb";
               _loc2_.description = "Inflicts \'Flaming\' by 5% for 4 turns.";
               _loc2_.order = 3;
               break;
            case "senjutsu_other_skill_4":
               _loc2_.id = "skill_3502";
               _loc2_.name = "Senjutsu: Flash Head Kick";
               _loc2_.description = "Removes all positive status of the target.";
               _loc2_.order = 4;
               break;
            case "senjutsu_toad_skill_1":
               _loc2_.id = "skill_3001";
               _loc2_.name = "Senjutsu: Mountains Flavor";
               _loc2_.description = "Absorbing natural power from the mountains to increase HP cap and all attack damage.";
               _loc2_.order = 1;
               break;
            case "senjutsu_toad_skill_2":
               _loc2_.id = "skill_3002";
               _loc2_.name = "Senjutsu: Toad Oil";
               _loc2_.description = "Spit out a special toad oil at target to decrease target\'s agility.";
               _loc2_.link1 = "skill_3001";
               _loc2_.order = 2;
               break;
            case "senjutsu_toad_skill_3":
               _loc2_.id = "skill_3003";
               _loc2_.name = "Senjutsu: Toad Fire Curse";
               _loc2_.description = "Cast out fire balls around the target and hit the target with a big explosion (extra damage will be done to those who is under the Toad Oil effect)";
               _loc2_.link1 = "skill_3001";
               _loc2_.order = 3;
               break;
            case "senjutsu_toad_skill_4":
               _loc2_.id = "skill_3004";
               _loc2_.name = "Senjutsu: Shield of Toad";
               _loc2_.description = "A shield made of toad\'s oil which can sustain a certain amount of damage.";
               _loc2_.link1 = "skill_3002";
               _loc2_.order = 4;
               break;
            case "senjutsu_toad_skill_5":
               _loc2_.id = "skill_3005";
               _loc2_.name = "Senjutsu: Ishikawa Goemon";
               _loc2_.description = "Summon a little toad which can steal and use a skill from the target with a lick of its tongue (PvP Jutsu) (Not applicable on Talent skills and Senjutsu)";
               _loc2_.link1 = "skill_3002";
               _loc2_.order = 5;
               break;
            case "senjutsu_toad_skill_6":
               _loc2_.id = "skill_3006";
               _loc2_.name = "Senjutsu: Toad Spirit";
               _loc2_.description = "Aided with the spirit of toad, player has a higher chance to cast critical hits and accuracy when HP is low.";
               _loc2_.link1 = "skill_3003";
               _loc2_.order = 6;
               break;
            case "senjutsu_toad_skill_7":
               _loc2_.id = "skill_3007";
               _loc2_.name = "Senjutsu: Special Pipe";
               _loc2_.description = "Exhale a thick blanket of smoke and hit the target with the pipe.";
               _loc2_.link1 = "skill_3003";
               _loc2_.order = 7;
               break;
            case "senjutsu_toad_skill_8":
               _loc2_.id = "skill_3008";
               _loc2_.name = "Senjutsu: Secret Sake of Toad";
               _loc2_.description = "Drink the special sake to increase all attack damage.";
               _loc2_.link1 = "skill_3004";
               _loc2_.link2 = "skill_3005";
               _loc2_.order = 8;
               break;
            case "senjutsu_toad_skill_9":
               _loc2_.id = "skill_3009";
               _loc2_.name = "Senjutsu: Power of Toad";
               _loc2_.description = "Summon a huge toad and attack the enemy.";
               _loc2_.link1 = "skill_3006";
               _loc2_.link2 = "skill_3007";
               _loc2_.order = 9;
               break;
            case "senjutsu_toad_skill_10":
               _loc2_.id = "skill_3010";
               _loc2_.name = "Senjutsu: Pneuma Toad Bomb";
               _loc2_.description = "Infused with potent power, player casts out a ball of all target. (PvP Jutsu)";
               _loc2_.link1 = "skill_3008";
               _loc2_.link2 = "skill_3009";
               _loc2_.order = 10;
               break;
            case "senjutsu_snake_skill_1":
               _loc2_.id = "skill_3101";
               _loc2_.name = "Senjutsu: Earth Flavor";
               _loc2_.description = "Trained to master natural power from snake cavern, less CP consumption while using skill and skill cooldown is shorter when skill is first used.";
               _loc2_.order = 1;
               break;
            case "senjutsu_snake_skill_2":
               _loc2_.id = "skill_3102";
               _loc2_.name = "Senjutsu: Toxic Fangs";
               _loc2_.description = "Special toxic sprayed at target and poison target.";
               _loc2_.order = 2;
               break;
            case "senjutsu_snake_skill_3":
               _loc2_.id = "skill_3103";
               _loc2_.name = "Senjutsu: Snake Swallow";
               _loc2_.description = "A big snake sprang out from the ground under target, and decrease the target’s maximum limit of CP.";
               _loc2_.link1 = "skill_3101";
               _loc2_.link2 = "skill_3102";
               _loc2_.order = 3;
               break;
            case "senjutsu_snake_skill_4":
               _loc2_.id = "skill_3104";
               _loc2_.name = "Senjutsu: Seven Snake Attack";
               _loc2_.description = "Summon lots of snakes to attack target. This Senjutsu hits target with high accuracy.";
               _loc2_.link1 = "skill_3103";
               _loc2_.order = 4;
               break;
            case "senjutsu_snake_skill_5":
               _loc2_.id = "skill_3105";
               _loc2_.name = "Senjutsu: Snake Mark";
               _loc2_.description = "Marked target with a serpent (debuff) causing target unable to use talent and senjutsu skill.";
               _loc2_.link1 = "skill_3103";
               _loc2_.order = 5;
               break;
            case "senjutsu_snake_skill_6":
               _loc2_.id = "skill_3106";
               _loc2_.name = "Senjutsu: Special Snake Scales";
               _loc2_.description = "Use scales to make a shield; if enemy attack player, enemy will get HP, CP and SP damages.";
               _loc2_.link1 = "skill_3104";
               _loc2_.order = 6;
               break;
            case "senjutsu_snake_skill_7":
               _loc2_.id = "skill_3107";
               _loc2_.name = "Senjutsu: Shedding";
               _loc2_.description = "Shed like a snake, player can ignore all damage and effect based on the amount of SP.";
               _loc2_.link1 = "skill_3105";
               _loc2_.order = 7;
               break;
            case "senjutsu_snake_skill_8":
               _loc2_.id = "skill_3108";
               _loc2_.name = "Senjutsu: Psychedelic Sound";
               _loc2_.description = "Confuse enemy with sonic vibration forcing target to use weapon attack only. (PvP Jutsu)";
               _loc2_.link1 = "skill_3104";
               _loc2_.link2 = "skill_3105";
               _loc2_.order = 8;
               break;
            case "senjutsu_snake_skill_9":
               _loc2_.id = "skill_3109";
               _loc2_.name = "Senjutsu: Snakes Shadow";
               _loc2_.description = "Summon the eight shadowed snakes to put target under chaotic illusion for alternate turns.";
               _loc2_.link1 = "skill_3108";
               _loc2_.order = 9;
               break;
            case "senjutsu_snake_skill_10":
               _loc2_.id = "skill_3110";
               _loc2_.name = "Senjutsu: Dragon Sublimation";
               _loc2_.description = "Player transform into a dragon and drain target\'s HP to convert it as his own SP. (PvP Jutsu)";
               _loc2_.link1 = "skill_3109";
               _loc2_.order = 10;
               break;
            case "senjutsu_slug_skill_1":
               _loc2_.id = "skill_3201";
               _loc2_.name = "Senjutsu: Slug Sage";
               _loc2_.description = "Channeling the vitality of the Shikkotsu slugs, the player fortifies their body to greatly increase Max HP while continuously regenerating HP each turn.";
               _loc2_.order = 1;
               break;
            case "senjutsu_slug_skill_2":
               _loc2_.id = "skill_3202";
               _loc2_.name = "Senjutsu: Slugs Protection";
               _loc2_.description = "A protective slug membrane coats the player, absorbing a portion of incoming damage through CP while steadily restoring CP each turn.";
               _loc2_.link1 = "skill_3201";
               _loc2_.order = 2;
               break;
            case "senjutsu_slug_skill_3":
               _loc2_.id = "skill_3203";
               _loc2_.name = "Senjutsu: Slugs Explosion";
               _loc2_.description = "Bursting acidic slugs erupt on the target, weakening their muscles and reducing the opponent\'s attack damage.";
               _loc2_.link1 = "skill_3202";
               _loc2_.order = 3;
               break;
            case "senjutsu_slug_skill_4":
               _loc2_.id = "skill_3204";
               _loc2_.name = "Senjutsu: Earth Mastery";
               _loc2_.description = "Drawing on the earthen wisdom of the slugs, the player increases Earth ninjutsu attack damage and improves reactive force chance.";
               _loc2_.link1 = "skill_3202";
               _loc2_.order = 4;
               break;
            case "senjutsu_slug_skill_5":
               _loc2_.id = "skill_3205";
               _loc2_.name = "Senjutsu: Chakra Kick";
               _loc2_.description = "A chakra-infused strike that sears the target\'s chakra network, reducing the opponent\'s CP each turn.";
               _loc2_.link1 = "skill_3202";
               _loc2_.order = 5;
               break;
            case "senjutsu_slug_skill_6":
               _loc2_.id = "skill_3206";
               _loc2_.name = "Senjutsu: Chakra Mega Punch";
               _loc2_.description = "A devastating chakra-charged blow that ruptures the target, inflicting bleeding so the enemy takes extra damage.";
               _loc2_.link1 = "skill_3203";
               _loc2_.order = 6;
               break;
            case "senjutsu_slug_skill_7":
               _loc2_.id = "skill_3207";
               _loc2_.name = "Senjutsu: Slugs Blessing";
               _loc2_.description = "The slugs share their boundless vitality, healing the player and the entire team at once.";
               _loc2_.link1 = "skill_3205";
               _loc2_.order = 7;
               break;
            case "senjutsu_slug_skill_8":
               _loc2_.id = "skill_3208";
               _loc2_.name = "Senjutsu: Stoneheart Fortitude";
               _loc2_.description = "Hardening the body like the resilient slugs of Shikkotsu, the player permanently increases their Max HP.";
               _loc2_.link1 = "skill_3204";
               _loc2_.order = 8;
               break;
            case "senjutsu_slug_skill_9":
               _loc2_.id = "skill_3209";
               _loc2_.name = "Senjutsu: Slugs Absorption";
               _loc2_.description = "Hungry slugs latch onto every foe, draining HP from all targets based on their current HP";
               _loc2_.link1 = "skill_3208";
               _loc2_.order = 9;
               break;
            case "senjutsu_slug_skill_10":
               _loc2_.id = "skill_3210";
               _loc2_.name = "Senjutsu: Slugs Breath";
               _loc2_.description = "The player exhales a corrosive slug mist over all targets, inflicting \'Reverse Healing\' so enemies lose HP instead of being healed.";
               _loc2_.link1 = "skill_3209";
               _loc2_.order = 10;
               break;
            default:
               return false;
         }
         return _loc2_;
      }
   }
}
