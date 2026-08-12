package Panels
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   
   public class ResetTalent extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var ResetTypeMc:MovieClip;
      
      public var academyBtn:MovieClip;
      
      public var btn_cancel:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_getessence:SimpleButton;
      
      public var btn_gettoken:SimpleButton;
      
      public var buyItemMC:MovieClip;
      
      public var confirmationMc:MovieClip;
      
      public var descTxt:TextField;
      
      public var essenceSkillIcon:MovieClip;
      
      public var essenceSkillTxt:TextField;
      
      public var panelIcon:MovieClip;
      
      public var panelMC:MovieClip;
      
      public var secretMc:MovieClip;
      
      public var subTitle:TextField;
      
      public var titleTxt:TextField;
      
      public var txt_token:TextField;
      
      public var warnTxt:TextField;
      
      public var main;
      
      var quantity;
      
      var cost;
      
      var selectedTalent_1;
      
      var selectedTalent;
      
      var talentSelected;
      
      var essential;
      
      var matCheck;
      
      private var selectedTalentIndex:String;
      
      public function ResetTalent(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.quantity = 1;
         this.cost = 200;
         this.selectedTalent_1 = 0;
         this.essential = 0;
         this.selectedTalent = [];
         this.talentSelected = [];
         this.panelIcon.gotoAndStop(1);
         this.buyItemMC.visible = false;
         this.buyItemMC.prevBtn.visible = false;
         this.buyItemMC.nextBtn.visible = false;
         this.confirmationMc.visible = false;
         this.panelMC.btn_reset.visible = false;
         this.panelMC.btn_resetemblem.visible = false;
         this.titleTxt.text = "Reset Talent";
         this.essenceSkillTxt.text = String(0);
         this.txt_token.text = String(Character.account_tokens);
         this.subTitle.text = "Reset Talent";
         this.descTxt.text = "You can reset your Talent once you have enough Ninja Seal Gan.";
         this.panelMC.freeuserMc.extremeTxt.text = "5";
         this.panelMC.emblemuserMc.extremeTxt.text = "1";
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.btn_getessence.addEventListener(MouseEvent.CLICK,this.buyItem);
         this.btn_gettoken.addEventListener(MouseEvent.CLICK,this.openRecharge);
         this.btn_cancel.addEventListener(MouseEvent.CLICK,this.removeSelectedSkill);
         this.panelMC.emblemBtn.addEventListener(MouseEvent.CLICK,this.emblemUpgrade);
         this.loadBasicData();
         this.secretMc.skill_1.addEventListener(MouseEvent.CLICK,this.getSelectedTalent);
         this.secretMc.skill_2.addEventListener(MouseEvent.CLICK,this.getSelectedTalent);
         this.secretMc.skill_3.addEventListener(MouseEvent.CLICK,this.getSelectedTalent);
      }
      
      function loadBasicData() : void
      {
         this.panelIcon.gotoAndStop("talent");
         this.ResetTypeMc.gotoAndStop(6);
         this.essenceSkillTxt.text = this.getMaterial();
         this.ResetTypeMc.resetTypeIcon.gotoAndStop("talent");
         this.secretMc.visible = true;
         this.academyBtn.visible = false;
         this.secretMc.gotoAndStop(6);
         this.secretMc.skill_1.gotoAndStop(2);
         this.secretMc.skill_1.skill.visible = false;
         this.secretMc.skill_2.gotoAndStop(2);
         this.secretMc.skill_2.skill.visible = false;
         this.secretMc.skill_3.gotoAndStop(2);
         this.secretMc.skill_3.skill.visible = false;
         if(Character.character_talent_1 != null)
         {
            this.secretMc.skill_1.talent.gotoAndStop(Character.character_talent_1);
         }
         else
         {
            this.secretMc.skill_1.talent.gotoAndStop("learnExTalent");
         }
         if(Character.character_talent_2 != null)
         {
            this.secretMc.skill_2.talent.gotoAndStop(Character.character_talent_2);
         }
         else
         {
            this.secretMc.skill_2.talent.gotoAndStop("learnSecretTalent");
         }
         if(Character.character_talent_3 != null)
         {
            this.secretMc.skill_3.talent.gotoAndStop(Character.character_talent_3);
         }
         else
         {
            this.secretMc.skill_3.talent.gotoAndStop("learnSecretTalent");
         }
         this.panelMC.freeuserMc.gotoAndStop("talent");
         this.panelMC.emblemuserMc.gotoAndStop("talent");
         this.ResetTypeMc.resetTypeIcon.gotoAndStop(11);
         this.ResetTypeMc.resetTypeIcon.talent.gotoAndStop("learnExTalent");
         if(int(Character.account_type) == 0)
         {
            this.panelMC.btn_reset.visible = true;
         }
         if(int(Character.account_type) == 1 && int(Character.emblem_duration) > 0)
         {
            this.panelMC.btn_resetemblem.visible = true;
         }
         if(int(Character.account_type) == 1 && int(Character.emblem_duration) == -1)
         {
            this.panelMC.btn_resetemblem.visible = true;
            this.panelMC.emblemBtn.removeEventListener(MouseEvent.CLICK,this.emblemUpgrade);
         }
         this.matCheck = this.getMaterial();
         if(this.matCheck < 5)
         {
            this.panelMC.btn_reset.addEventListener(MouseEvent.CLICK,this.buyItem);
         }
         else
         {
            this.panelMC.btn_reset.addEventListener(MouseEvent.CLICK,this.confirmation);
         }
         if(this.matCheck < 1)
         {
            this.panelMC.btn_resetemblem.addEventListener(MouseEvent.CLICK,this.buyItem);
         }
         else
         {
            this.panelMC.btn_resetemblem.addEventListener(MouseEvent.CLICK,this.confirmation);
         }
      }
      
      function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      function emblemUpgrade(param1:MouseEvent) : void
      {
         this.main.loadPanel("Popups.EmblemUpgrade");
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.removeAllChild(this);
         this.main = null;
      }
      
      public function buyItem(param1:MouseEvent) : *
      {
         this.titleTxt.text = "Reset Talent";
         this.buyItemMC.titleTxt.text = "Buy More Seal Gan";
         this.buyItemMC.itemNameTxt.text = "Ninja Seal Gan";
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.panelMC.btn_reset.removeEventListener(MouseEvent.CLICK,this.confirmation);
         this.panelMC.btn_resetemblem.removeEventListener(MouseEvent.CLICK,this.confirmation);
         this.panelMC.btn_reset.removeEventListener(MouseEvent.CLICK,this.buyItem);
         this.panelMC.btn_resetemblem.removeEventListener(MouseEvent.CLICK,this.buyItem);
         this.buyItemMC.visible = true;
         this.buyItemMC.itemMC.gotoAndStop(5);
         this.buyItemMC.itemMC.IconMc.gotoAndStop(1);
         this.buyItemMC.itemMC.IconMc.itemMC.gotoAndStop("talent");
         this.buyItemMC.numTxt.text = this.quantity;
         this.buyItemMC.TokenCost.txt_token.text = this.cost;
         this.buyItemMC.btn_buy.addEventListener(MouseEvent.CLICK,this.buyMaterial);
         this.buyItemMC.btnClose.addEventListener(MouseEvent.CLICK,this.closeReset);
         this.buyItemMC.btnNext.addEventListener(MouseEvent.CLICK,this.addQuantity);
         this.buyItemMC.btnPrev.addEventListener(MouseEvent.CLICK,this.subQuantity);
      }
      
      public function confirmation(param1:MouseEvent) : *
      {
         if(this.talentSelected.length == 0)
         {
            this.main.getNotice("Please Select Talent First!");
            return;
         }
         this.panelMC.btn_reset.removeEventListener(MouseEvent.CLICK,this.buyItem);
         this.panelMC.btn_resetemblem.removeEventListener(MouseEvent.CLICK,this.buyItem);
         this.buyItemMC.btn_buy.removeEventListener(MouseEvent.CLICK,this.buyItem);
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.confirmationMc.visible = true;
         this.confirmationMc.btn_confirm.addEventListener(MouseEvent.CLICK,this.resetAmf);
         this.confirmationMc.btn_close.addEventListener(MouseEvent.CLICK,this.closeReset);
      }
      
      public function closeReset(param1:MouseEvent) : *
      {
         this.buyItemMC.visible = false;
         this.confirmationMc.visible = false;
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.buyItemMC.btnClose.removeEventListener(MouseEvent.CLICK,this.closeReset);
         this.confirmationMc.btn_close.removeEventListener(MouseEvent.CLICK,this.closeReset);
         this.buyItemMC.btn_buy.removeEventListener(MouseEvent.CLICK,this.closeReset);
      }
      
      public function addQuantity(param1:MouseEvent) : *
      {
         this.quantity = int(this.quantity) + 1;
         this.cost = int(200 * this.quantity);
         this.buyItemMC.numTxt.text = this.quantity;
         this.buyItemMC.TokenCost.txt_token.text = this.cost;
      }
      
      public function subQuantity(param1:MouseEvent) : *
      {
         if(this.quantity <= 1)
         {
            return;
         }
         this.quantity = int(this.quantity) - 1;
         this.cost = int(this.cost) - 200;
         this.buyItemMC.numTxt.text = this.quantity;
         this.buyItemMC.TokenCost.txt_token.text = this.cost;
      }
      
      public function getSelectedTalent(param1:MouseEvent) : *
      {
         this.selectedTalent = [];
         this.talentSelected = [];
         this.ResetTypeMc.resetTypeIcon.gotoAndStop("talent");
         this.ResetTypeMc.gotoAndPlay("switchLeft");
         this.selectedTalentIndex = param1.currentTarget.name.replace("skill_","");
         var _loc2_:* = undefined;
         if(this.selectedTalentIndex == "1")
         {
            _loc2_ = Character.character_talent_1;
         }
         else if(this.selectedTalentIndex == "2")
         {
            _loc2_ = Character.character_talent_2;
         }
         else if(this.selectedTalentIndex == "3")
         {
            _loc2_ = Character.character_talent_3;
         }
         if(this.selectedTalent.length < 1)
         {
            this.selectedTalent.push("skill_" + this.selectedTalentIndex);
            this.ResetTypeMc.resetTypeIcon["talent"].gotoAndStop(_loc2_);
            this.talentSelected.push(_loc2_);
         }
      }
      
      public function removeSelectedSkill(param1:MouseEvent) : *
      {
         this.selectedTalent = [];
         this.talentSelected = [];
         this.ResetTypeMc.resetTypeIcon.talent.gotoAndStop("learnExTalent");
      }
      
      public function resetAmf(param1:MouseEvent) : *
      {
         var _loc2_:* = this.confirmationMc.txt_reset.text;
         if(_loc2_ == "RESET")
         {
            this.main.loading(true);
            this.main.amf_manager.service("36a62s4oZ7iYRJjd.VIhLusozNoHU",[Character.char_id,Character.sessionkey,this.talentSelected],this.resetTalent);
         }
         else if(_loc2_ != "RESET")
         {
            this.main.giveMessage("Wrong Input! Must Type RESET in Uppercase");
            return;
         }
      }
      
      public function resetTalent(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.getNotice("Your Talent Has Resetted.");
            if(this.selectedTalentIndex == "1")
            {
               Character.character_talent_1 = null;
            }
            else if(this.selectedTalentIndex == "2")
            {
               Character.character_talent_2 = null;
               if(Character.character_talent_3 != null)
               {
                  Character.character_talent_2 = Character.character_talent_3;
                  Character.character_talent_3 = null;
               }
            }
            else if(this.selectedTalentIndex == "3")
            {
               Character.character_talent_3 = null;
            }
            this.removeChild(this.confirmationMc);
            this.destroy();
         }
         else
         {
            if(param1.status == 0)
            {
               this.main.giveMessage("Please Select Talent First!");
               return;
            }
            this.main.getError(param1.error);
         }
      }
      
      function getMaterial() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = [];
         if(Character.character_essentials != "")
         {
            if(Character.character_essentials.indexOf(",") >= 0)
            {
               _loc2_ = Character.character_essentials.split(",");
            }
            else
            {
               _loc2_ = [Character.character_essentials];
            }
         }
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((_loc1_ = _loc2_[_loc3_].split(":"))[0] == "essential_02")
            {
               return _loc1_[1];
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function buyMaterial(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.rclgzvBxbbYa",[Character.sessionkey,Character.char_id,this.quantity],this.buyMaterialRes);
      }
      
      public function buyMaterialRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveMessage(this.quantity + " Essence Gan Succesfully Bought!");
            Character.addEssentials("essential_02:" + this.quantity);
            Character.account_tokens -= this.cost;
            this.essenceSkillTxt.text = param1.essential;
            this.txt_token.text = String(Character.account_tokens);
            this.loadBasicData();
         }
         else
         {
            if(param1.status == 2)
            {
               this.main.giveMessage("You Don\'t Have Enough Token");
               return;
            }
            this.main.getError(param1.error);
         }
      }
   }
}
