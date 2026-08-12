package Popups
{
   import Managers.NinjaSage;
   import Panels.TalentPanel;
   import Storage.Character;
   import Storage.TalentSkillDescriptions;
   import Storage.TalentSkillLevel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TalentSkillInfo extends MovieClip
   {
       
      
      public var btnClose:MovieClip;
      
      public var lbl_PassiveTxt:TextField;
      
      public var lvMaxTxt:TextField;
      
      public var nextCDTxt:TextField;
      
      public var nextCPTxt:TextField;
      
      public var nextDamageTxt:TextField;
      
      public var skillDescTxt:TextField;
      
      public var skillNameTxt:TextField;
      
      public var skill_icon:MovieClip;
      
      public var parent_mc:TalentPanel;
      
      public var main;
      
      public function TalentSkillInfo()
      {
         super();
      }
      
      public function init(param1:*) : *
      {
         this.parent_mc = param1;
         this.main = param1.main;
         this.addButtonListeners();
         this.initMovieClips();
      }
      
      public function setInfo(param1:*, param2:*) : *
      {
         NinjaSage.loadIconSWF("skills",param1,this.skill_icon.holder,"icon");
         var _loc3_:* = TalentSkillDescriptions.getTalentSkillDescriptions(param2);
         this.skillNameTxt.text = _loc3_.talent_skill_name;
         this.skillDescTxt.text = _loc3_.talent_skill_description;
         var _loc4_:* = TalentSkillLevel.getTalentSkillLevels(param1,10);
         this.nextDamageTxt.text = this.getInfoForDCC(_loc4_.talent_skill_damage);
         this.nextCPTxt.text = this.getInfoForDCC(_loc4_.talent_skill_cp_cost);
         this.nextCDTxt.text = _loc4_.skill_cooldown;
         this.lvMaxTxt.text = _loc4_.talent_skill_description;
         this.lbl_PassiveTxt.text = "";
         if(int(_loc4_.skill_cooldown) == 0)
         {
            this.lbl_PassiveTxt.text = "(Passive Skill)";
         }
      }
      
      public function getInfoForDCC(param1:*) : *
      {
         return String(Math.round(param1 * int(Character.character_lvl)));
      }
      
      public function initMovieClips() : *
      {
         this.skill_icon.gotoAndStop("enable");
         this.skill_icon.typeSkill.gotoAndStop(1);
      }
      
      public function addButtonListeners() : *
      {
         this.main.initButton(this.btnClose,this.closeThis);
      }
      
      public function closeThis(param1:MouseEvent) : *
      {
         this.visible = false;
      }
   }
}
