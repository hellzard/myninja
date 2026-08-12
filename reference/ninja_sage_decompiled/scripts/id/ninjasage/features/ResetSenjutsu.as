package id.ninjasage.features
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class ResetSenjutsu extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var eventHandler:EventHandler;
      
      public var main;
      
      public var quantity;
      
      public var cost;
      
      public var selectedSenjutsu_1;
      
      public var selectedSenjutsu;
      
      public var senjutsuSelected;
      
      public var essential;
      
      public var matCheck;
      
      public function ResetSenjutsu(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.main.handleVillageHUDVisibility(false);
         this.quantity = 1;
         this.cost = 200;
         this.selectedSenjutsu_1 = 0;
         this.essential = 0;
         this.selectedSenjutsu = [];
         this.senjutsuSelected = [];
         this.panelMC.panelIcon.gotoAndStop(1);
         this.panelMC.buyItemMC.visible = false;
         this.panelMC.buyItemMC.prevBtn.visible = false;
         this.panelMC.buyItemMC.nextBtn.visible = false;
         this.panelMC.confirmationMc.visible = false;
         this.panelMC.panelMC.btn_reset.visible = false;
         this.panelMC.panelMC.btn_resetemblem.visible = false;
         this.panelMC.titleTxt.text = "Secret Kinjutsu Ritual";
         this.panelMC.essenceSkillTxt.text = String(0);
         this.panelMC.txt_token.text = String(Character.account_tokens);
         this.panelMC.subTitle.text = "Sage Mode Reset";
         this.panelMC.descTxt.text = "You can reset Sage Mode once you have enough Ninja Seal Gan.";
         this.panelMC.panelMC.freeuserMc.extremeTxt.text = "5";
         this.panelMC.panelMC.emblemuserMc.extremeTxt.text = "1";
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_getessence,MouseEvent.CLICK,this.buyItem);
         this.eventHandler.addListener(this.panelMC.btn_gettoken,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.btn_cancel,MouseEvent.CLICK,this.removeSelectedSkill);
         this.eventHandler.addListener(this.panelMC.panelMC.emblemBtn,MouseEvent.CLICK,this.emblemUpgrade);
         this.loadBasicData();
         this.eventHandler.addListener(this.panelMC.secretMc.skill_1,MouseEvent.CLICK,this.getSelectedSenjutsu);
         this.eventHandler.addListener(this.panelMC.secretMc.skill_2,MouseEvent.CLICK,this.getSelectedSenjutsu);
         this.eventHandler.addListener(this.panelMC.secretMc.skill_3,MouseEvent.CLICK,this.getSelectedSenjutsu);
         this.panelMC.ResetTypeMc.addFrameScript(25,this.stopAnimation,40,this.stopAnimation);
      }
      
      private function stopAnimation() : void
      {
         this.panelMC.ResetTypeMc.stop();
      }
      
      function loadBasicData() : void
      {
         this.panelMC.panelIcon.gotoAndStop("senjutsu");
         this.panelMC.ResetTypeMc.gotoAndStop(6);
         this.panelMC.essenceSkillTxt.text = this.getMaterial();
         this.panelMC.ResetTypeMc.resetTypeIcon.gotoAndStop("senjutsu");
         this.panelMC.secretMc.visible = true;
         this.panelMC.academyBtn.visible = false;
         this.panelMC.secretMc.gotoAndStop(6);
         this.panelMC.secretMc.skill_1.gotoAndStop(3);
         this.panelMC.secretMc.skill_1.skill.visible = false;
         this.panelMC.secretMc.skill_1.talent.visible = false;
         this.panelMC.secretMc.skill_1.senjutsu.gotoAndStop("learnSenjutsu");
         this.panelMC.secretMc.arrow2.visible = false;
         this.panelMC.secretMc.arrow3.visible = false;
         this.panelMC.secretMc.skill_2.visible = false;
         this.panelMC.secretMc.skill_3.visible = false;
         if(Character.character_senjutsu != null)
         {
            this.panelMC.secretMc.skill_1.senjutsu.gotoAndStop(Character.character_senjutsu);
         }
         else
         {
            this.panelMC.secretMc.skill_1.senjutsu.gotoAndStop("learnSenjutsu");
         }
         this.panelMC.panelMC.freeuserMc.gotoAndStop("secret");
         this.panelMC.panelMC.emblemuserMc.gotoAndStop("secret");
         this.panelMC.ResetTypeMc.resetTypeIcon.senjutsu.gotoAndStop("learnSenjutsu");
         if(int(Character.account_type) == 0)
         {
            this.panelMC.panelMC.btn_reset.visible = true;
         }
         if(int(Character.account_type) == 1 && int(Character.emblem_duration) > 0)
         {
            this.panelMC.panelMC.btn_resetemblem.visible = true;
         }
         if(int(Character.account_type) == 1 && int(Character.emblem_duration) == -1)
         {
            this.panelMC.panelMC.btn_resetemblem.visible = true;
         }
         this.matCheck = this.getMaterial();
         if(this.matCheck < 5)
         {
            this.eventHandler.addListener(this.panelMC.panelMC.btn_reset,MouseEvent.CLICK,this.buyItem);
         }
         else
         {
            this.eventHandler.addListener(this.panelMC.panelMC.btn_reset,MouseEvent.CLICK,this.confirmation);
         }
         if(this.matCheck < 1)
         {
            this.eventHandler.addListener(this.panelMC.panelMC.btn_resetemblem,MouseEvent.CLICK,this.buyItem);
         }
         else
         {
            this.eventHandler.addListener(this.panelMC.panelMC.btn_resetemblem,MouseEvent.CLICK,this.confirmation);
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
         this.main.handleVillageHUDVisibility(true);
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.eventHandler = null;
         this.main = null;
         GF.removeAllChild(this.panelMC);
      }
      
      public function buyItem(param1:MouseEvent) : *
      {
         this.panelMC.buyItemMC.titleTxt.text = "Buy More Seal Gan";
         this.panelMC.buyItemMC.itemNameTxt.text = "Ninja Seal Gan";
         this.panelMC.buyItemMC.visible = true;
         this.panelMC.buyItemMC.itemMC.gotoAndStop(5);
         this.panelMC.buyItemMC.itemMC.IconMc.gotoAndStop(1);
         this.panelMC.buyItemMC.itemMC.IconMc.itemMC.gotoAndStop("secret");
         this.panelMC.buyItemMC.numTxt.text = this.quantity;
         this.panelMC.buyItemMC.TokenCost.txt_token.text = this.cost;
         this.eventHandler.addListener(this.panelMC.buyItemMC.btn_buy,MouseEvent.CLICK,this.buyMaterial);
         this.eventHandler.addListener(this.panelMC.buyItemMC.btnClose,MouseEvent.CLICK,this.closeReset);
         this.eventHandler.addListener(this.panelMC.buyItemMC.btnNext,MouseEvent.CLICK,this.addQuantity);
         this.eventHandler.addListener(this.panelMC.buyItemMC.btnPrev,MouseEvent.CLICK,this.subQuantity);
      }
      
      public function confirmation(param1:MouseEvent) : *
      {
         if(this.senjutsuSelected.length == 0)
         {
            this.main.getNotice("Please Select Senjutsu First!");
            return;
         }
         this.panelMC.confirmationMc.visible = true;
         this.eventHandler.addListener(this.panelMC.confirmationMc.btn_confirm,MouseEvent.CLICK,this.resetAmf);
         this.eventHandler.addListener(this.panelMC.confirmationMc.btn_close,MouseEvent.CLICK,this.closeReset);
      }
      
      public function closeReset(param1:MouseEvent) : *
      {
         this.panelMC.buyItemMC.visible = false;
         this.panelMC.confirmationMc.visible = false;
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
      }
      
      public function addQuantity(param1:MouseEvent) : *
      {
         this.quantity = int(this.quantity) + 1;
         this.cost = int(200 * this.quantity);
         this.panelMC.buyItemMC.numTxt.text = this.quantity;
         this.panelMC.buyItemMC.TokenCost.txt_token.text = this.cost;
      }
      
      public function subQuantity(param1:MouseEvent) : *
      {
         if(this.quantity <= 1)
         {
            return;
         }
         this.quantity = int(this.quantity) - 1;
         this.cost = int(this.cost) - 200;
         this.panelMC.buyItemMC.numTxt.text = this.quantity;
         this.panelMC.buyItemMC.TokenCost.txt_token.text = this.cost;
      }
      
      public function getSelectedSenjutsu(param1:MouseEvent) : *
      {
         var _loc3_:* = undefined;
         this.selectedSenjutsu = [];
         this.senjutsuSelected = [];
         this.panelMC.ResetTypeMc.resetTypeIcon.gotoAndStop("senjutsu");
         this.panelMC.ResetTypeMc.gotoAndPlay("switchLeft");
         var _loc2_:String = param1.currentTarget.name.replace("skill_","");
         if(_loc2_ == "1")
         {
            _loc3_ = Character.character_senjutsu;
         }
         if(this.selectedSenjutsu.length < 1)
         {
            this.selectedSenjutsu.push("skill_" + _loc2_);
            this.panelMC.ResetTypeMc.resetTypeIcon["senjutsu"].gotoAndStop(_loc3_);
            this.senjutsuSelected.push(_loc3_);
         }
      }
      
      public function removeSelectedSkill(param1:MouseEvent) : *
      {
         this.selectedSenjutsu = [];
         this.senjutsuSelected = [];
         this.panelMC.ResetTypeMc.resetTypeIcon.senjutsu.gotoAndStop("learnSenjutsu");
      }
      
      public function resetAmf(param1:MouseEvent) : *
      {
         if(this.senjutsuSelected.length == 0)
         {
            this.main.showMessage("Please select a senjutsu first!");
            return;
         }
         var _loc2_:* = this.panelMC.confirmationMc.txt_reset.text;
         if(_loc2_ == "RESET")
         {
            this.main.loading(true);
            this.main.amf_manager.service("36a62s4oZ7iYRJjd.p9yV4A1ybQnT",[Character.char_id,Character.sessionkey,this.senjutsuSelected],this.resetSenjutsu);
         }
         else if(_loc2_ != "RESET")
         {
            this.main.giveMessage("Wrong Input! Must Type RESET in Uppercase");
            return;
         }
      }
      
      public function resetSenjutsu(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.getNotice("Your Senjutsu Has Resetted");
            Character.character_senjutsu = null;
            Character.character_equipped_senjutsu_skills = "";
            Character.character_senjutsu_skills = "";
            this.destroy();
         }
         else
         {
            if(param1.status == 0)
            {
               this.main.giveMessage("Please Select Senjutsu First!");
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
            if((_loc1_ = _loc2_[_loc3_].split(":"))[0] == "essential_11")
            {
               return _loc1_[1];
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function buyMaterial(param1:MouseEvent) : *
      {
         this.panelMC.buyItemMC.visible = false;
         this.panelMC.confirmationMc.visible = false;
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.Ymz3LrSU23C5",[Character.sessionkey,Character.char_id,this.quantity],this.buyMaterialRes);
      }
      
      public function buyMaterialRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            Character.addEssentials("essential_11:" + this.quantity);
            Character.account_tokens = param1.tokens;
            this.panelMC.essenceSkillTxt.text = param1.essential;
            this.panelMC.txt_token.text = String(Character.account_tokens);
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
