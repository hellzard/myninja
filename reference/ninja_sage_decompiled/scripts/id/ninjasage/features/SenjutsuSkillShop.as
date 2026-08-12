package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.GameData;
   import Storage.SkillLibrary;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class SenjutsuSkillShop extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var main;
      
      private var response:Object;
      
      private var skillList:Array;
      
      private var ownedSenjutsuSkills:Array;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var selectedSkill:Object;
      
      public function SenjutsuSkillShop(param1:*, param2:*)
      {
         this.skillList = [];
         this.ownedSenjutsuSkills = [];
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.main.handleVillageHUDVisibility(false);
         this.skillList = GameData.get("senjutsu_skill_shop").skills;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.eventHandler = new EventHandler();
         this.getSenjutsuFromAmf();
      }
      
      private function getSenjutsuFromAmf() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("fBANtsWU39EIjrT8.BMMQvYvp2ME8",[Character.char_id,Character.sessionkey],this.onAmfResponse);
      }
      
      private function onAmfResponse(param1:Object) : *
      {
         var _loc2_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.data.length)
            {
               this.ownedSenjutsuSkills.push(param1.data[_loc2_]);
               _loc2_++;
            }
            this.initUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function initUI() : void
      {
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_preview,MouseEvent.CLICK,this.openPreview);
         this.eventHandler.addListener(this.panelMC.btn_learn,MouseEvent.CLICK,this.learnConfirmation);
         this.panelMC.txt_token.text = Character.account_tokens;
         this.panelMC.txt_name.text = "Select a Skill";
         this.panelMC.txt_sp.text = "0";
         this.panelMC.txt_dmg.text = "0";
         this.panelMC.txt_cd.text = "0";
         this.panelMC.txt_desc.text = "Click a skill to show details.";
         this.panelMC.txt_level.text = "0";
         this.panelMC.txt_levelreq.text = "0";
         this.panelMC.iconMC.amountTxt.text = "";
         this.panelMC.iconMC.ownedTxt.text = "";
         this.panelMC.iconMC.btn_preview.visible = false;
         this.totalPage = Math.max(Math.ceil(this.skillList.length / 4),1);
         this.updatePageNumber();
         this.renderSkills();
      }
      
      private function renderSkills() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.panelMC["item_" + _loc1_].visible = false;
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 4);
            if(this.skillList.length > _loc2_)
            {
               this.panelMC["item_" + _loc1_].visible = true;
               this.panelMC["item_" + _loc1_].iconMC.ownedTxt.visible = false;
               this.panelMC["item_" + _loc1_].iconMC.amountTxt.visible = false;
               this.panelMC["item_" + _loc1_].iconMC.btn_preview.visible = false;
               if(this.hasSkill(this.skillList[_loc2_]) > 0)
               {
                  this.panelMC["item_" + _loc1_].iconMC.ownedTxt.visible = true;
                  this.panelMC["item_" + _loc1_].iconMC.ownedTxt.text = "Owned";
               }
               _loc3_ = SkillLibrary.getSkillInfo(this.skillList[_loc2_]);
               NinjaSage.loadItemIcon(this.panelMC["item_" + _loc1_].iconMC,this.skillList[_loc2_]);
               this.panelMC["item_" + _loc1_].txt_name.text = _loc3_.skill_name;
               this.panelMC["item_" + _loc1_].txt_level.text = _loc3_.skill_level;
               this.panelMC["item_" + _loc1_].txt_price.text = _loc3_.skill_price_tokens;
               this.panelMC["item_" + _loc1_].metaData = {"skillData":_loc3_};
               this.eventHandler.addListener(this.panelMC["item_" + _loc1_],MouseEvent.CLICK,this.selectSkill);
               this.panelMC["item_" + _loc1_].iconMC.btn_preview.visible = false;
            }
            _loc1_++;
         }
      }
      
      private function selectSkill(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget.metaData.skillData;
         this.selectedSkill = _loc2_;
         NinjaSage.loadItemIcon(this.panelMC.iconMC,this.selectedSkill.skill_id);
         this.panelMC.txt_name.text = _loc2_.skill_name;
         this.panelMC.txt_level.text = _loc2_.skill_level;
         this.panelMC.txt_levelreq.text = _loc2_.skill_level;
         this.panelMC.txt_sp.text = _loc2_.skill_cp_cost;
         this.panelMC.txt_dmg.text = _loc2_.skill_damage;
         this.panelMC.txt_cd.text = _loc2_.skill_cooldown;
         this.panelMC.txt_desc.text = _loc2_.skill_description;
         this.panelMC.iconMC.amountTxt.text = "";
         this.panelMC.iconMC.ownedTxt.text = "";
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderSkills();
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderSkills();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function checkIsItemOrSkill(param1:String) : Boolean
      {
         var _loc2_:Array = ["skill_","hair_","set_","back_","wpn_"];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1.indexOf(_loc2_[_loc3_]) >= 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function hasSkill(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.ownedSenjutsuSkills.length)
         {
            if(param1 == this.ownedSenjutsuSkills[_loc3_].id)
            {
               _loc2_ = 1;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function openPreview(param1:MouseEvent) : *
      {
         if(this.selectedSkill == null)
         {
            return this.main.showMessage("Please select a skill to preview");
         }
         param1.currentTarget.metaData = {"itemId":this.selectedSkill.skill_id};
         this.main.openPreview(param1);
      }
      
      private function learnConfirmation(param1:MouseEvent) : *
      {
         if(this.selectedSkill == null)
         {
            return this.main.showMessage("Please select a skill to learn");
         }
         if(this.hasSkill(this.selectedSkill.skill_id) > 0)
         {
            return this.main.showMessage("You already own this skill");
         }
         this.main.showConfirmation("Are you sure to learn " + this.selectedSkill.skill_name + " for " + this.selectedSkill.skill_price_tokens + " tokens?",this.learnSkillAmf);
      }
      
      private function learnSkillAmf(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("fBANtsWU39EIjrT8.QxdqRSLnAAPu",[Character.char_id,Character.sessionkey,this.selectedSkill.skill_id],this.onLearned);
      }
      
      private function onLearned(param1:Object) : *
      {
         var _loc2_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Skill succesfully learned.");
            this.ownedSenjutsuSkills = [];
            _loc2_ = 0;
            while(_loc2_ < param1.data.length)
            {
               this.ownedSenjutsuSkills.push(param1.data[_loc2_]);
               _loc2_++;
            }
            Character.account_tokens = param1.tokens;
            this.initUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         this.main.handleVillageHUDVisibility(true);
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         this.response = null;
         this.skillList = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}
