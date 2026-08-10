package Popups
{
   import Managers.NinjaSage;
   import Panels.TalentPanel;
   import Storage.Character;
   import Storage.TalentLevelLearnRequirements;
   import Storage.TalentSkillDescriptions;
   import Storage.TalentSkillLevel;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1619")]
   public class TalentLvlUP extends MovieClip
   {
      
      public var btnTrainMax:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var bpPrice:TextField;
      
      public var bpTxt:TextField;
      
      public var btnClose:MovieClip;
      
      public var btnTrain:MovieClip;
      
      public var currCPTxt:TextField;
      
      public var currCooldownTxt:TextField;
      
      public var currDamageTxt:TextField;
      
      public var currSkillLv:TextField;
      
      public var currskillTxt:TextField;
      
      public var lbl_PassiveTxt:TextField;
      
      public var nextCPTxt:TextField;
      
      public var nextCooldownTxt:TextField;
      
      public var nextDamageTxt:TextField;
      
      public var nextSkillLv:TextField;
      
      public var nextskillTxt:TextField;
      
      public var noClanMc:MovieClip;
      
      public var skillDescTxt:TextField;
      
      public var skillNameTxt:TextField;
      
      public var skill_icon:MovieClip;
      
      public var parent_mc:TalentPanel;
      
      public var main:*;
      
      public var skill_id:*;
      
      public var ref:String;
      
      public var isMax:Boolean = false;
      
      internal var price:* = 0;
      
      internal var clevel:* = 0;
      
      internal var level:* = 0;
      
      internal var talent_sk_id:*;
      
      public function TalentLvlUP()
      {
         super();
      }
      
      public function init(param1:*) : *
      {
         this.parent_mc = param1;
         this.main = param1.main;
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closeThis);
         this.isMax = false;
         this.addButtonListeners();
         this.initMovieClips();
         this.setTexts();
      }
      
      public function setInfo(param1:String, param2:String, param3:*, param4:String) : *
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:int = 0;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this.skill_id = param1;
         this.ref = param4;
         this.level = param3;
         this.talent_sk_id = param2;
         GF.removeAllChild(this.skill_icon.holder);
         NinjaSage.loadIconSWF("skills",this.skill_id,this.skill_icon.holder,"with_holder");
         var _loc7_:* = TalentSkillDescriptions.getTalentSkillDescriptions(this.talent_sk_id);
         this.skillNameTxt.text = _loc7_.talent_skill_name;
         this.skillDescTxt.text = _loc7_.talent_skill_description;
         this.price = TalentLevelLearnRequirements.getSkillRequirements(int(param3) + 1);
         if(this.isMax)
         {
            _loc9_ = 0;
            _loc10_ = int(Character.character_tp);
            _loc11_ = this.level;
            while(_loc11_ < 10)
            {
               _loc8_ = _loc11_ + 1;
               _loc12_ = TalentLevelLearnRequirements.getSkillRequirements(_loc8_).tp;
               if(_loc9_ + _loc12_ > _loc10_)
               {
                  _loc8_ = _loc11_;
                  break;
               }
               _loc9_ += _loc12_;
               _loc11_++;
            }
            this.clevel = _loc8_;
            this.price.tp = _loc9_;
         }
         else
         {
            this.clevel = int(param3) + 1;
         }
         this.bpPrice.text = this.price.tp + "TP";
         this.lbl_PassiveTxt.text = "";
         this.currSkillLv.text = "Current Level: " + param3;
         this.nextSkillLv.text = "Next Level: " + this.clevel;
         if(param3 > 0)
         {
            _loc5_ = TalentSkillLevel.getTalentSkillLevels(this.skill_id,param3);
            this.currDamageTxt.text = this.getInfoForDCC(_loc5_.talent_skill_damage);
            this.currCPTxt.text = this.getInfoForDCC(_loc5_.talent_skill_cp_cost);
            this.currCooldownTxt.text = _loc5_.skill_cooldown;
            this.currskillTxt.text = _loc5_.talent_skill_description;
            _loc6_ = TalentSkillLevel.getTalentSkillLevels(this.skill_id,this.clevel);
            this.nextDamageTxt.text = this.getInfoForDCC(_loc6_.talent_skill_damage);
            this.nextCPTxt.text = this.getInfoForDCC(_loc6_.talent_skill_cp_cost);
            this.nextCooldownTxt.text = _loc6_.skill_cooldown;
            this.nextskillTxt.text = _loc6_.talent_skill_description;
            if(int(_loc6_.skill_cooldown) == 0)
            {
               this.lbl_PassiveTxt.text = "(Passive Skill)";
            }
         }
         else
         {
            this.currDamageTxt.text = "0";
            this.currCPTxt.text = "0";
            this.currCooldownTxt.text = "0";
            this.currskillTxt.text = "";
            _loc6_ = TalentSkillLevel.getTalentSkillLevels(this.skill_id,this.clevel);
            this.nextDamageTxt.text = this.getInfoForDCC(_loc6_.talent_skill_damage);
            this.nextCPTxt.text = this.getInfoForDCC(_loc6_.talent_skill_cp_cost);
            this.nextCooldownTxt.text = _loc6_.skill_cooldown;
            this.nextskillTxt.text = _loc6_.talent_skill_description;
            if(int(_loc6_.skill_cooldown) == 0)
            {
               this.lbl_PassiveTxt.text = "(Passive Skill)";
            }
         }
      }
      
      public function getInfoForDCC(param1:*) : *
      {
         return String(Math.round(param1 * int(Character.character_lvl)));
      }
      
      public function setTexts() : *
      {
         this.bpTxt.text = String(Character.character_tp) + "TP";
      }
      
      public function initMovieClips() : *
      {
         this.skill_icon.gotoAndStop("enable");
         this.skill_icon.typeSkill.gotoAndStop(1);
      }
      
      public function addButtonListeners() : *
      {
         this.main.initButton(this.btnClose,this.closeThis);
         this.main.initButton(this.btnTrain,this.onTrainAMF,"Upgrade");
         this.main.initButton(this.btnTrainMax,this.setMaxTrue,"Upgrade Max");
      }
      
      public function setMaxTrue(param1:MouseEvent) : void
      {
         this.isMax = !this.isMax;
         var _loc2_:String = this.isMax ? "Normal" : "Upgrade Max";
         this.main.initButton(this.btnTrainMax,this.setMaxTrue,_loc2_);
         this.setInfo(this.skill_id,this.talent_sk_id,this.level,this.ref);
      }
      
      public function onTrainAMFSend(param1:MouseEvent) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.parent_mc.confirmBox.visible = false;
         this.main.loading(true);
         this.main.amf_manager.service("RzFUf16G1EIy2bfB.NWcNAjOYUOcm",[Character.char_id,Character.sessionkey,this.skill_id,this.isMax ? 1 : 0],this.onTrainResponse);
      }
      
      public function onTrainAMF(param1:MouseEvent) : *
      {
         this.parent_mc.showConfirmationBox("Are you sure want to use " + this.price.tp + " TP to Upgrade " + this.skillNameTxt.text + " to level " + this.clevel,this.onTrainAMFSend);
      }
      
      public function onTrainResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this.main.getNotice(param1.result);
               return;
            }
            Character.character_tp = String(param1.current_tp);
            this.visible = false;
            this.parent_mc.setTexts();
            this.parent_mc.reloadTalentInfo(this.ref);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function closeThis(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.removeAllChild(this.skill_icon.holder);
         this.visible = false;
         this.main = null;
      }
   }
}

