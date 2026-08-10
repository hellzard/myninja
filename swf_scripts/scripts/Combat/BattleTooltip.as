package Combat
{
   import Storage.Character;
   import Storage.SenjutsuSkillLevel;
   import Storage.TalentSkillLevel;
   import com.abrahamyan.liquid.ToolTip;
   import flash.events.MouseEvent;
   
   public class BattleTooltip
   {
      
      public static var library:*;
      
      public static var skill_library:*;
      
      public static var tooltip:ToolTip = null;
      
      public static var RE_INIT_TOOLTIP:Boolean = true;
      
      public function BattleTooltip()
      {
         super();
         library = BattleManager.MAIN.getLibrary();
         skill_library = BattleManager.MAIN.getSkillLibrary();
         if(BattleTooltip.tooltip == null)
         {
            BattleTooltip.initTooltip();
         }
         BattleManager.getMain().addEventListener(MouseEvent.CLICK,this.onClickRemoveTooltip);
      }
      
      public static function showTooltip(param1:MouseEvent) : *
      {
         var item_info:Object = null;
         var ee:int = 0;
         var current_hp:* = undefined;
         var current_cp:* = undefined;
         var max_hp:* = undefined;
         var max_cp:* = undefined;
         var sk:int = 0;
         var skill_holder:* = undefined;
         var new_amount:int = 0;
         var formula:Number = NaN;
         var defender_max_hp:int = 0;
         var defender_current_hp:int = 0;
         var defender_current_prc_hp:Number = NaN;
         var damage:* = undefined;
         var e:MouseEvent = param1;
         var item:String = String(e.currentTarget.item_id);
         var is_talent:Boolean = Boolean(e.currentTarget.is_talent);
         var is_passive:Boolean = Boolean(e.currentTarget.is_passive);
         var is_class:Boolean = Boolean(e.currentTarget.is_class);
         var is_senjutsu:* = Boolean(e.currentTarget.is_senjutsu);
         var library_holder:* = skill_library;
         var tooltip_info:String = "";
         var skill_type:String = "Skill";
         var main_char:* = BattleManager.getBattle().character_team_players[0];
         BattleTooltip.tooltip.multiLine = true;
         if(is_talent)
         {
            item_info = TalentSkillLevel.getCopy(item,main_char.character_manager.getTalentLevel(item));
            item_info.talent_skill_cp_cost = Math.round(item_info.talent_skill_cp_cost * main_char.getLevel());
            item_info.talent_skill_damage = Math.floor(item_info.talent_skill_damage * main_char.getLevel());
            item_info.talent_skill_cp_cost = main_char.health_manager.getSkillCpAmount(item_info);
            if(is_passive)
            {
               skill_type = "Passive Skill";
               tooltip_info = "<b>" + item_info.talent_skill_name + "</b>\n";
               tooltip_info += "(" + skill_type + ")\n\n";
               tooltip_info += item_info.talent_skill_description;
            }
            else
            {
               skill_type = "Talent Skill";
               tooltip_info = "<b>" + item_info.talent_skill_name + "</b>\n";
               tooltip_info += "(" + skill_type + ")\n\n";
               tooltip_info += "<font color=\"#ff0000\">" + "Damage: " + item_info.talent_skill_damage + "</font>\n";
               tooltip_info += "<font color=\"#0000ff\">" + "CP Cost: " + item_info.talent_skill_cp_cost + "</font>\n";
               tooltip_info += "<font color=\"#ffcc00\">" + "Cooldown: " + item_info.skill_cooldown + "</font>\n\n";
               tooltip_info += item_info.talent_skill_description;
            }
         }
         else if(is_class)
         {
            if(Character.character_class == "skill_4002")
            {
               ee = 0;
               while(ee < BattleManager.getBattle().enemy_team_players.length)
               {
                  current_hp = BattleManager.getBattle().enemy_team_players[ee].health_manager.getCurrentHP();
                  current_cp = BattleManager.getBattle().enemy_team_players[ee].health_manager.getCurrentCP();
                  max_hp = BattleManager.getBattle().enemy_team_players[ee].health_manager.getMaxHP();
                  max_cp = BattleManager.getBattle().enemy_team_players[ee].health_manager.getMaxCP();
                  if(current_hp > 10000)
                  {
                     current_hp /= 1000;
                     current_hp = Number(current_hp).toFixed(1).toString();
                     current_hp += "k";
                  }
                  if(current_cp > 10000)
                  {
                     current_cp /= 1000;
                     current_cp = Number(current_cp).toFixed(1).toString();
                     current_cp += "k";
                  }
                  if(max_hp > 10000)
                  {
                     max_hp /= 1000;
                     max_hp = Number(max_hp).toFixed(1).toString();
                     max_hp += "k";
                  }
                  if(max_cp > 10000)
                  {
                     max_cp /= 1000;
                     max_cp = Number(max_cp).toFixed(1).toString();
                     max_cp += "k";
                  }
                  BattleManager.getBattle()["actionBar"]["enemyMcInfo_" + ee.toString()].visible = true;
                  BattleManager.getBattle()["actionBar"]["enemyMcInfo_" + ee.toString()].txt_hp.text = current_hp + "/" + max_hp;
                  BattleManager.getBattle()["actionBar"]["enemyMcInfo_" + ee.toString()].txt_cp.text = current_cp + "/" + max_cp;
                  sk = 1;
                  while(sk < 5)
                  {
                     skill_holder = BattleManager.getBattle()["actionBar"]["enemyMcInfo_" + ee.toString()]["skill_" + sk];
                     skill_holder.visible = false;
                     if(BattleManager.getBattle().enemy_team_players[ee].isCharacter())
                     {
                        skill_holder.visible = true;
                        BattleManager.getBattle().enemy_team_players[ee].handleRandomSkill(skill_holder,int(sk - 1));
                     }
                     sk++;
                  }
                  ee++;
               }
               return;
            }
            item_info = library_holder.getSkillInfo(item);
            tooltip_info = "<b>" + item_info.skill_name + "</b>\n";
            tooltip_info += "(Special Class)\n\n";
            if(Character.character_class == "skill_4000")
            {
               new_amount = 70 * int(Character.character_lvl) - 3200;
               item_info.skill_description = item_info.skill_description.replace("[valamount]",new_amount.toString());
            }
            if(Character.character_class == "skill_4004")
            {
               formula = 64 * (int(Character.character_lvl) - 60) + 700;
               defender_max_hp = int(BattleManager.getBattle().enemy_team_players[BattleVars.PLAYER_TARGET].health_manager.getMaxHP());
               defender_current_hp = int(BattleManager.getBattle().enemy_team_players[BattleVars.PLAYER_TARGET].health_manager.getCurrentHP());
               defender_current_prc_hp = defender_current_hp / defender_max_hp;
               formula *= defender_current_prc_hp;
               damage = Math.floor(formula).toString();
               item_info.skill_description = "Ignore target status. According to character\'s level and target remaining HP, this skill will deal [valamount] damage. Used once only in each battle.";
               item_info.skill_description = item_info.skill_description.replace("[valamount]",damage.toString());
            }
            tooltip_info += item_info.skill_description;
         }
         else if(is_senjutsu)
         {
            item_info = SenjutsuSkillLevel.getCopy(item,main_char.character_manager.getSenjutsuLevel(item));
            tooltip_info = "<b>" + item_info.name + "</b>\n";
            tooltip_info += "(" + (item_info.type == "toad" ? "Toad Senjutsu" : (item_info.type == "snake" ? "Snake Senjutsu" : "Senjutsu")) + ")\n\n";
            tooltip_info += "<font color=\"#ff0000\">" + "Damage: " + item_info.damage + "</font>\n";
            tooltip_info += "<font color=\"#ff5300\">" + "SP Cost: " + item_info.sp_cost + "</font>\n";
            tooltip_info += "<font color=\"#ffcc00\">" + "Cooldown: " + item_info.cooldown + "</font>\n\n";
            tooltip_info += item_info.description;
         }
         else
         {
            item_info = library_holder.getCopy(item);
            item_info.skill_cp_cost = main_char.health_manager.getSkillCpAmount(item_info);
            if(item_info.skill_type == 1)
            {
               skill_type = "Wind";
            }
            if(item_info.skill_type == 2)
            {
               skill_type = "Fire";
            }
            if(item_info.skill_type == 3)
            {
               skill_type = "Lightning";
            }
            if(item_info.skill_type == 4)
            {
               skill_type = "Earth";
            }
            if(item_info.skill_type == 5)
            {
               skill_type = "Water";
            }
            if(item_info.skill_type == 6)
            {
               skill_type = "Taijutsu";
            }
            if(item_info.skill_type == 7)
            {
               skill_type = "Genjutsu";
            }
            if(item_info.skill_type == 10)
            {
               skill_type = "Special Class";
            }
            tooltip_info = "<b>" + item_info.skill_name + "</b>\n";
            tooltip_info += "(" + skill_type + ")\n\n";
            tooltip_info += "Level: " + item_info.skill_level + "\n";
            if("skill_heal" in item_info)
            {
               if(item_info.skill_heal == "MAX")
               {
                  item_info.skill_heal = main_char.health_manager.getMaxHP();
               }
               tooltip_info += "<font color=\"#00ff00\">" + "Heal: " + item_info.skill_heal + "</font>\n";
            }
            else if("skill_damage" in item_info)
            {
               tooltip_info += "<font color=\"#ff0000\">" + "Damage: " + item_info.skill_damage + "</font>\n";
            }
            tooltip_info += "<font color=\"#0000ff\">" + "CP Cost: " + item_info.skill_cp_cost + "</font>\n";
            tooltip_info += "<font color=\"#ffcc00\">" + "Cooldown: " + item_info.skill_cooldown + "</font>\n\n";
            tooltip_info += item_info.skill_description;
         }
         try
         {
            BattleTooltip.tooltip.show(tooltip_info);
         }
         catch(e:*)
         {
            if(BattleTooltip.RE_INIT_TOOLTIP)
            {
               BattleTooltip.reInitTooltip();
            }
         }
      }
      
      public static function initTooltip() : *
      {
         BattleTooltip.tooltip = BattleManager.MAIN.getPvpTooltip();
         BattleTooltip.tooltip.followMouse = true;
         BattleTooltip.tooltip.fixedWidth = 350;
         BattleTooltip.tooltip.multiLine = true;
         BattleManager.MAIN.addChild(BattleTooltip.tooltip);
      }
      
      public static function reInitTooltip() : *
      {
         BattleTooltip.RE_INIT_TOOLTIP = false;
         BattleTooltip.initTooltip();
      }
      
      public static function hideTooltip(param1:MouseEvent) : *
      {
         try
         {
            BattleManager.getBattle()["actionBar"]["enemyMcInfo_0"].visible = false;
            BattleManager.getBattle()["actionBar"]["enemyMcInfo_1"].visible = false;
            BattleManager.getBattle()["actionBar"]["enemyMcInfo_2"].visible = false;
         }
         catch(e:*)
         {
         }
         try
         {
            BattleTooltip.tooltip.hide();
         }
         catch(e2:*)
         {
         }
      }
      
      public function onClickRemoveTooltip(param1:MouseEvent) : *
      {
         BattleTooltip.hideTooltip(param1);
      }
      
      public function destroy() : *
      {
         if(BattleManager.getMain())
         {
            BattleManager.getMain().removeEventListener(MouseEvent.CLICK,this.onClickRemoveTooltip);
         }
         if(tooltip)
         {
            tooltip.destroy();
         }
         library = null;
         skill_library = null;
         tooltip = null;
      }
   }
}

