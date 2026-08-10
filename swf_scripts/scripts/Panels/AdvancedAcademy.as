package Panels
{
   import Managers.NinjaLoader;
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.SkillLibrary;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol847")]
   public class AdvancedAcademy extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var buyGold:SimpleButton;
      
      public var buyTokens:SimpleButton;
      
      public var costBar:MovieClip;
      
      public var curSkill:MovieClip;
      
      public var element_mc0:MovieClip;
      
      public var element_mc1:MovieClip;
      
      public var element_mc2:MovieClip;
      
      public var element_mc3:MovieClip;
      
      public var element_mc4:MovieClip;
      
      public var iconType:MovieClip;
      
      public var skill_0:MovieClip;
      
      public var skill_1:MovieClip;
      
      public var skill_10:MovieClip;
      
      public var skill_11:MovieClip;
      
      public var skill_2:MovieClip;
      
      public var skill_3:MovieClip;
      
      public var skill_4:MovieClip;
      
      public var skill_5:MovieClip;
      
      public var skill_6:MovieClip;
      
      public var skill_7:MovieClip;
      
      public var skill_8:MovieClip;
      
      public var skill_9:MovieClip;
      
      public var txt_gold:TextField;
      
      public var txt_token:TextField;
      
      public var upIcon:MovieClip;
      
      public var upgrSkill:MovieClip;
      
      private var main:*;
      
      private var skills:Array = [];
      
      private var tooltip:ToolTip;
      
      public var eventHandler:* = new EventHandler();
      
      public function AdvancedAcademy(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClose);
         this.main = param1;
         this.tooltip = ToolTip.getInstance();
         this.displayCharacterStats();
         this.addButtonListeners();
         this.handleElementButtons();
         this.init();
         this.addSkills();
      }
      
      private function displayCharacterStats() : *
      {
         this["txt_gold"].text = String(Character.character_gold);
         this["txt_token"].text = String(Character.account_tokens);
      }
      
      private function addButtonListeners() : *
      {
         this.eventHandler.addListener(this["btn_close"],MouseEvent.CLICK,this.onClose);
         this.eventHandler.addListener(this["buyGold"],MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this["buyTokens"],MouseEvent.CLICK,this.openRecharge);
      }
      
      private function openRecharge(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function handleElementButtons() : *
      {
         this["element_mc0"].visible = false;
         this["element_mc1"].visible = false;
         this["element_mc2"].visible = false;
         if(int(Character.character_element_1) > 0)
         {
            this["element_mc0"].gotoAndStop(Character.character_element_1);
            this["element_mc0"].visible = true;
            this["element_mc0"]["element"].gotoAndStop(3);
            this["element_mc0"].buttonMode = true;
            this.eventHandler.addListener(this["element_mc0"],MouseEvent.CLICK,this.onSelectElement);
            this.eventHandler.addListener(this["element_mc0"]["element"],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.addListener(this["element_mc0"]["element"],MouseEvent.MOUSE_OUT,this.out);
         }
         if(int(Character.character_element_2) > 0)
         {
            this["element_mc1"].gotoAndStop(Character.character_element_2);
            this["element_mc1"].visible = true;
            this["element_mc1"]["element"].gotoAndStop(1);
            this["element_mc1"].buttonMode = true;
            this.eventHandler.addListener(this["element_mc1"],MouseEvent.CLICK,this.onSelectElement);
            this.eventHandler.addListener(this["element_mc1"]["element"],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.addListener(this["element_mc1"]["element"],MouseEvent.MOUSE_OUT,this.out);
         }
         if(int(Character.character_element_3) > 0)
         {
            this["element_mc2"].gotoAndStop(Character.character_element_3);
            this["element_mc2"].visible = true;
            this["element_mc2"]["element"].gotoAndStop(1);
            this["element_mc2"].buttonMode = true;
            this.eventHandler.addListener(this["element_mc2"],MouseEvent.CLICK,this.onSelectElement);
            this.eventHandler.addListener(this["element_mc2"]["element"],MouseEvent.MOUSE_OVER,this.over);
            this.eventHandler.addListener(this["element_mc2"]["element"],MouseEvent.MOUSE_OUT,this.out);
         }
         this["element_mc3"].visible = true;
         this["element_mc3"].gotoAndStop(1);
         this["element_mc3"].buttonMode = true;
         this.eventHandler.addListener(this["element_mc3"],MouseEvent.CLICK,this.onSelectElement);
         this.eventHandler.addListener(this["element_mc3"],MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this["element_mc3"],MouseEvent.MOUSE_OUT,this.out);
         this["element_mc4"].visible = true;
         this["element_mc4"].gotoAndStop(1);
         this["element_mc4"].buttonMode = true;
         this.eventHandler.addListener(this["element_mc4"],MouseEvent.CLICK,this.onSelectElement);
         this.eventHandler.addListener(this["element_mc4"],MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this["element_mc4"],MouseEvent.MOUSE_OUT,this.out);
      }
      
      private function over(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrame != 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function out(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrame != 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function addSkills() : *
      {
         this.hideSkills();
         this.skills["wind"] = [];
         this.skills["fire"] = [];
         this.skills["thunder"] = [];
         this.skills["earth"] = [];
         this.skills["water"] = [];
         this.skills["taijutsu"] = [];
         this.skills["genjutsu"] = [];
         this.skills["wind"]["evasion"] = ["skill_39","skill_271","skill_272","skill_273","skill_274","skill_275"];
         this.skills["wind"]["blade_of_wind"] = ["skill_85","skill_276","skill_277","skill_278","skill_279"];
         this.skills["wind"]["wind_peace"] = ["skill_161","skill_280","skill_281","skill_282"];
         this.skills["wind"]["dance_of_fujin"] = ["skill_151","skill_283","skill_284"];
         this.skills["wind"]["breakthrough"] = ["skill_285","skill_286"];
         this.skills["fire"]["fire_power"] = ["skill_36","skill_220","skill_221","skill_222","skill_223","skill_224"];
         this.skills["fire"]["hell_fire"] = ["skill_86","skill_225","skill_226","skill_227","skill_228"];
         this.skills["fire"]["fire_energy"] = ["skill_162","skill_229","skill_230","skill_231"];
         this.skills["fire"]["rage"] = ["skill_152","skill_232","skill_233"];
         this.skills["fire"]["phoenix"] = ["skill_234","skill_235"];
         this.skills["thunder"]["charge"] = ["skill_35","skill_288","skill_289","skill_290","skill_291","skill_292"];
         this.skills["thunder"]["flash"] = ["skill_87","skill_293","skill_294","skill_295","skill_296"];
         this.skills["thunder"]["bundle"] = ["skill_163","skill_297","skill_298","skill_299"];
         this.skills["thunder"]["armor"] = ["skill_153","skill_300","skill_301"];
         this.skills["thunder"]["boost"] = ["skill_302","skill_303"];
         this.skills["earth"]["golem"] = ["skill_59","skill_237","skill_238","skill_239","skill_240","skill_241"];
         this.skills["earth"]["absorb"] = ["skill_88","skill_242","skill_243","skill_244","skill_245"];
         this.skills["earth"]["rocks"] = ["skill_164","skill_246","skill_247","skill_248"];
         this.skills["earth"]["embrace"] = ["skill_154","skill_249","skill_250"];
         this.skills["earth"]["gaunt"] = ["skill_251","skill_252"];
         this.skills["water"]["renewal"] = ["skill_60","skill_254","skill_255","skill_256","skill_257","skill_258"];
         this.skills["water"]["bundle"] = ["skill_89","skill_259","skill_260","skill_261","skill_262"];
         this.skills["water"]["prison"] = ["skill_165","skill_264","skill_263","skill_265"];
         this.skills["water"]["shield"] = ["skill_155","skill_266","skill_267"];
         this.skills["water"]["shark"] = ["skill_268","skill_269"];
         this.skills["genjutsu"]["sealing"] = ["skill_706","skill_726"];
         this.showSkills(int(Character.character_element_1));
      }
      
      private function hideSkills() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < 12)
         {
            this["skill_" + _loc1_.toString()].visible = false;
            this["skill_" + _loc1_.toString()].buttonMode = true;
            _loc1_++;
         }
      }
      
      private function showSkills(param1:int) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         this["iconType"].gotoAndStop(param1);
         var _loc9_:String = this.getSkillElementType(param1);
         var _loc10_:Array = this.getElementTypeSkills(param1);
         var _loc11_:NinjaLoader = new NinjaLoader(this);
         var _loc12_:int = 0;
         while(_loc12_ < _loc10_.length)
         {
            _loc2_ = -1;
            _loc3_ = this.skills[_loc9_][_loc10_[_loc12_]];
            _loc4_ = _loc3_[0];
            _loc5_ = _loc3_[0];
            _loc6_ = int(_loc3_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               if(Character.isItemOwned(_loc3_[_loc7_]))
               {
                  _loc2_ = _loc7_;
                  _loc4_ = _loc3_[_loc7_];
                  _loc5_ = _loc3_[_loc7_ + 1];
               }
               _loc7_++;
            }
            _loc8_ = this["skill_" + _loc12_.toString()];
            _loc8_["maxTxt"].text = "";
            _loc8_["lvTxt"].text = "";
            _loc8_["percentBar"].scaleX = 1;
            GF.removeAllChild(this["skill_" + _loc12_].iconMC.iconHolder);
            NinjaSage.loadIconSWF("skills",_loc4_,this["skill_" + _loc12_].iconMC.iconHolder,"icon");
            if(_loc2_ >= 0)
            {
               _loc8_["percentBar"].visible = true;
               this.main.enableButton(_loc8_);
               _loc8_.visible = true;
               if(_loc2_ + 1 == _loc6_)
               {
                  _loc8_["maxTxt"].text = "MAX.";
                  _loc8_.current_skill_id = _loc4_;
                  this.eventHandler.removeListener(this["skill_" + _loc12_],MouseEvent.CLICK,this.onUpgradeSkill);
               }
               else
               {
                  _loc8_["percentBar"].scaleX = (_loc2_ + 1) / _loc6_;
                  _loc8_["lvTxt"].text = _loc2_ + 1 + " / " + _loc6_;
                  _loc8_.skill_element_type = _loc9_;
                  _loc8_.element_skills = _loc10_[_loc12_];
                  _loc8_.skill_element = param1;
                  _loc8_.current_level = _loc2_;
                  _loc8_.current_skill_id = _loc4_;
                  _loc8_.next_skill_id = _loc5_;
                  this.eventHandler.addListener(this["skill_" + _loc12_],MouseEvent.CLICK,this.onUpgradeSkill);
               }
            }
            else
            {
               _loc8_.removeEventListener(MouseEvent.CLICK,this.onUpgradeSkill);
               _loc8_["percentBar"].visible = false;
               _loc8_["maxTxt"].text = "LEARN.";
               _loc8_.current_skill_id = _loc4_;
               _loc8_.next_skill_id = _loc5_;
               this.main.disableButton(_loc8_);
            }
            this.eventHandler.addListener(_loc8_,MouseEvent.ROLL_OVER,this.toolTiponOver);
            this.eventHandler.addListener(_loc8_,MouseEvent.ROLL_OUT,this.toolTiponOut);
            _loc12_++;
         }
      }
      
      private function getSkillElementType(param1:int) : *
      {
         switch(param1)
         {
            case 1:
               return "wind";
            case 2:
               return "fire";
            case 3:
               return "thunder";
            case 4:
               return "earth";
            case 5:
               return "water";
            case 6:
               return "taijutsu";
            case 7:
               return "genjutsu";
            default:
               return;
         }
      }
      
      private function getElementTypeSkills(param1:int) : *
      {
         switch(param1)
         {
            case 1:
               return ["evasion","blade_of_wind","wind_peace","dance_of_fujin","breakthrough"];
            case 2:
               return ["fire_power","hell_fire","fire_energy","rage","phoenix"];
            case 3:
               return ["charge","flash","bundle","armor","boost"];
            case 4:
               return ["golem","absorb","rocks","embrace","gaunt"];
            case 5:
               return ["renewal","bundle","prison","shield","shark"];
            case 6:
               return [];
            case 7:
               return ["sealing"];
            default:
               return;
         }
      }
      
      private function init(param1:Boolean = false) : *
      {
         this["curSkill"].visible = param1;
         this["upgrSkill"].visible = param1;
         this["upIcon"].visible = param1;
         this["costBar"].visible = param1;
      }
      
      private function onSelectElement(param1:MouseEvent) : *
      {
         this.hideSkills();
         this.init();
         this["element_mc0"]["element"].gotoAndStop(1);
         this["element_mc1"]["element"].gotoAndStop(1);
         this["element_mc2"]["element"].gotoAndStop(1);
         this["element_mc3"].gotoAndStop(1);
         this["element_mc4"].gotoAndStop(1);
         var _loc2_:int = int(param1.currentTarget.name.replace("element_mc",""));
         if(_loc2_ == 0)
         {
            this["element_mc0"]["element"].gotoAndStop(3);
            this.showSkills(int(Character.character_element_1));
         }
         else if(_loc2_ == 1)
         {
            this["element_mc1"]["element"].gotoAndStop(3);
            this.showSkills(int(Character.character_element_2));
         }
         else if(_loc2_ == 2)
         {
            this["element_mc2"]["element"].gotoAndStop(3);
            this.showSkills(int(Character.character_element_3));
         }
         else if(_loc2_ == 3)
         {
            this["element_mc3"].gotoAndStop(3);
            this.showSkills(int(6));
         }
         else
         {
            this["element_mc4"].gotoAndStop(3);
            this.showSkills(int(7));
         }
      }
      
      private function onUpgradeSkill(param1:MouseEvent) : *
      {
         var _loc2_:NinjaLoader = new NinjaLoader(this);
         var _loc3_:* = param1.currentTarget;
         GF.removeAllChild(this["curSkill"]["iconMC0"]["iconHolder"]);
         GF.removeAllChild(this["upgrSkill"]["iconMC0"]["iconHolder"]);
         GF.removeAllChild(this["costBar"]["iconMC0"]["iconHolder"]);
         var _loc4_:* = SkillLibrary.getSkillInfo(_loc3_.current_skill_id);
         this["curSkill"]["iconType"].gotoAndStop(_loc3_.skill_element);
         this["curSkill"]["nameTxt"].text = _loc4_.skill_name;
         this["curSkill"]["levelTxt"].text = _loc4_.skill_level;
         this["curSkill"]["cpTxt"].text = _loc4_.skill_cp_cost;
         this["curSkill"]["damageTxt"].text = _loc4_.skill_damage;
         this["curSkill"]["cooldownTxt"].text = _loc4_.skill_cooldown;
         this["curSkill"]["descriptionTxt"].text = _loc4_.skill_description;
         NinjaSage.loadIconSWF("skills",_loc3_.current_skill_id,this["curSkill"].iconMC0.iconHolder,"icon");
         _loc4_ = SkillLibrary.getSkillInfo(_loc3_.next_skill_id);
         this["upgrSkill"]["iconType"].gotoAndStop(_loc3_.skill_element);
         this["upgrSkill"]["nameTxt"].text = _loc4_.skill_name;
         this["upgrSkill"]["levelTxt"].text = _loc4_.skill_level;
         this["upgrSkill"]["cpTxt"].text = _loc4_.skill_cp_cost;
         this["upgrSkill"]["damageTxt"].text = _loc4_.skill_damage;
         this["upgrSkill"]["cooldownTxt"].text = _loc4_.skill_cooldown;
         this["upgrSkill"]["descriptionTxt"].text = _loc4_.skill_description;
         NinjaSage.loadIconSWF("skills",_loc3_.next_skill_id,this["upgrSkill"].iconMC0.iconHolder,"icon");
         NinjaSage.loadIconSWF("skills",_loc3_.current_skill_id,this["costBar"].iconMC0.iconHolder,"icon");
         this["costBar"]["levelTxt"].text = _loc4_.skill_level;
         this["costBar"]["tokenTxt"].text = _loc4_.skill_price_tokens;
         this["costBar"]["btn_upgrade"].visible = false;
         if(int(Character.character_lvl) >= int(_loc4_.skill_level) && Character.account_tokens >= int(_loc4_.skill_price_tokens))
         {
            this.eventHandler.addListener(this["costBar"]["btn_upgrade"],MouseEvent.CLICK,this.onUpgradeSkillAmf);
            this["costBar"].current_skill_id = _loc3_.current_skill_id;
            this["costBar"].next_skill_id = _loc3_.next_skill_id;
            this["costBar"].skill_element_type = _loc3_.skill_element_type;
            this["costBar"].element_skills = _loc3_.element_skills;
            this["costBar"]["btn_upgrade"].visible = true;
         }
         this.init(true);
      }
      
      private function onUpgradeSkillAmf(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.parent;
         this.main.loading(true);
         this.main.amf_manager.service("CmoNYK4NJyrbu4Bk.a0R2CQcfmedy",[Character.char_id,Character.sessionkey,_loc2_.next_skill_id],this.onUpgradeResponse);
      }
      
      private function onUpgradeResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
            return;
         }
         var _loc2_:* = this["costBar"];
         Character.account_tokens = param1.account_tokens;
         Character.character_equipped_skills = param1.character_skills;
         Character.character_skill_set = param1.character_set_skills;
         Character.updateSkills(_loc2_.current_skill_id,false);
         Character.updateSkills(_loc2_.next_skill_id);
         this.displayCharacterStats();
         this.main.showMessage(param1.result);
         this.hideSkills();
         this.init();
         if(this["element_mc0"]["element"].currentFrame == 3)
         {
            this.showSkills(int(Character.character_element_1));
         }
         else if(this["element_mc1"]["element"].currentFrame == 3)
         {
            this.showSkills(int(Character.character_element_2));
         }
         else if(this["element_mc2"]["element"].currentFrame == 3)
         {
            this.showSkills(int(Character.character_element_3));
         }
         else if(this["element_mc3"].currentFrame == 3)
         {
            this.showSkills(6);
         }
         else
         {
            this.showSkills(7);
         }
      }
      
      private function toolTiponOver(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = SkillLibrary.getSkillInfo(_loc2_.current_skill_id);
         var _loc4_:* = "" + _loc3_.skill_name + "\n(Skill)\n" + "\nLevel " + _loc3_.skill_level + "\nDamage: " + _loc3_.skill_damage + "\nCP Cost: " + _loc3_.skill_cp_cost + "\nCooldown: " + _loc3_.skill_cooldown + "\n\n" + _loc3_.skill_description;
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc4_);
      }
      
      private function toolTiponOut(param1:MouseEvent) : *
      {
         this.tooltip.hide();
      }
      
      private function onClose(param1:MouseEvent) : *
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
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         if(this.tooltip)
         {
            this.tooltip.destroy();
         }
         this.skills.length = 0;
         this.tooltip = null;
         this.main = null;
         GF.removeAllChild(this);
      }
   }
}

