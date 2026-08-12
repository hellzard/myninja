package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.SkillLibrary;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class LimitedStore extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var rewardsArray:Array;
      
      private var skillList:Array;
      
      private var priceArray:Array;
      
      private var priceArray0:Array;
      
      private var priceArray1:Array;
      
      private var priceArray2:Array;
      
      private var priceArray3:Array;
      
      private var typeMC:MovieClip;
      
      private var target:int;
      
      private var target2:int;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var confirmation:Confirmation;
      
      private var selected_skill_id:String;
      
      private var price:int;
      
      private var limitedstore_timestamp = null;
      
      private var discount:String;
      
      private var eventHandler:EventHandler;
      
      private var timeout;
      
      private var refreshCost:int;
      
      private var refreshCount:int;
      
      public function LimitedStore(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.panelMC.panel.listMC.visible = false;
         this.loadAmf();
      }
      
      private function loadAmf() : *
      {
         this.rewardsArray = [];
         this.priceArray0 = [];
         this.priceArray1 = [];
         this.priceArray2 = [];
         this.priceArray3 = [];
         this.skillList = [];
         this.refreshCost = 0;
         this.refreshCount = 0;
         this.main.loading(true);
         this.main.amf_manager.service("TRPtXVyrTZgoqpd2.QChFea0iEJL3",[Character.char_id,Character.sessionkey],this.eventDataResponse);
      }
      
      private function eventDataResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.limitedstore_timestamp = param1.end_time;
            this.discount = param1.discounts;
            this.refreshCost = param1.refresh_cost;
            this.refreshCount = param1.refresh_count;
            _loc2_ = 0;
            for each(_loc3_ in param1.items)
            {
               this.rewardsArray.push(_loc3_.code);
               this["priceArray" + _loc2_] = _loc3_.prices;
               _loc2_++;
            }
            this.onShow();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function onShow() : *
      {
         this.eventHandler.addListener(this.panelMC.panel.closeBtn,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.panel.btn_skill_list,MouseEvent.CLICK,this.openSkillList);
         this.eventHandler.addListener(this.panelMC.panel.btn_refresh,MouseEvent.CLICK,this.refreshConfirmation);
         this.panelMC.panel.leftone.visible = false;
         this.panelMC.panel.twoboxupdateleft.visible = false;
         this.panelMC.panel.threeboxupdateleft.visible = false;
         this.panelMC.panel.fourboxupdateleft.visible = false;
         if(this.rewardsArray.length == 1)
         {
            this.panelMC.panel.leftone.visible = true;
            this.typeMC = this.panelMC.panel.leftone;
         }
         else if(this.rewardsArray.length == 2)
         {
            this.panelMC.panel.twoboxupdateleft.visible = true;
            this.typeMC = this.panelMC.panel.twoboxupdateleft;
         }
         else if(this.rewardsArray.length == 3)
         {
            this.panelMC.panel.threeboxupdateleft.visible = true;
            this.typeMC = this.panelMC.panel.threeboxupdateleft;
         }
         else if(this.rewardsArray.length == 4)
         {
            this.panelMC.panel.fourboxupdateleft.visible = true;
            this.typeMC = this.panelMC.panel.fourboxupdateleft;
         }
         this.panelMC.panel.notopen.visible = false;
         this.panelMC.panel.noneTxt.visible = false;
         this.panelMC.panel.bgnotopen.visible = false;
         this.showRewards();
         this.updateTimeleft();
         if(this.rewardsArray.length < 1)
         {
            this.panelMC.panel.notopen.visible = true;
            this.panelMC.panel.noneTxt.visible = true;
            this.panelMC.panel.bgnotopen.visible = true;
            this.panelMC.panel.noneTxt.text = "Mysterious Market is currently closed, please come back later.";
         }
         this.panelMC.panel.txt_refresh_count.text = "Refresh x" + String(this.refreshCount);
      }
      
      private function showRewards() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.panelMC.panel.tokenTxt.text = String(Character.account_tokens);
         this.panelMC.panel.emblemleftTxt.text = "Emblem " + String(this.discount) + "% OFF";
         this.main.initButton(this.panelMC.panel.getMoreBtn,this.openRecharge,"");
         var _loc1_:* = 0;
         while(_loc1_ < this.rewardsArray.length)
         {
            _loc2_ = this.rewardsArray[_loc1_];
            _loc3_ = _loc2_.split("_");
            if(_loc3_[0] != "skill")
            {
               _loc5_ = this.typeMC["Item_" + _loc1_].Icon_0.rewardIcon.iconHolder;
               this.typeMC["Item_" + _loc1_].Icon_0.skillIcon.visible = false;
               this.typeMC["Item_" + _loc1_].Icon_0.rewardIcon.colorType.gotoAndStop("special");
            }
            else
            {
               this.typeMC["Item_" + _loc1_].Icon_0.rewardIcon.visible = false;
               this.typeMC["Item_" + _loc1_].Icon_0.skillIcon.gotoAndStop("enable");
               _loc5_ = this.typeMC["Item_" + _loc1_].Icon_0.skillIcon.iconHolder;
            }
            _loc4_ = SkillLibrary.getSkillInfo(_loc2_);
            this.typeMC["Item_" + _loc1_].skillName.text = _loc4_.skill_name;
            this.typeMC["Item_" + _loc1_].skill["price_1"].text = this["priceArray" + _loc1_][0];
            this.typeMC["Item_" + _loc1_].skill["price_2"].text = this["priceArray" + _loc1_][1];
            this.typeMC["Item_" + _loc1_].skill["buyBtn_1"].visible = true;
            this.typeMC["Item_" + _loc1_].skill["buyBtn_2"].visible = true;
            if(_loc1_ != 0 && !Character.hasSkill(this.rewardsArray[_loc1_ - 1]))
            {
               this.main.initButtonDisable(this.typeMC["Item_" + _loc1_].skill["buyBtn_1"].buyBtn_1,this.showConfirmation,"Buy");
               this.main.initButtonDisable(this.typeMC["Item_" + _loc1_].skill["buyBtn_2"].buyBtn_1,this.showConfirmation,"Buy");
            }
            else
            {
               this.main.initButton(this.typeMC["Item_" + _loc1_].skill["buyBtn_1"].buyBtn_1,this.showConfirmation,"Buy");
               this.main.initButton(this.typeMC["Item_" + _loc1_].skill["buyBtn_2"].buyBtn_1,this.showConfirmation,"Buy");
            }
            this.typeMC["Item_" + _loc1_].tick.visible = false;
            if(this.hasSkill(this.rewardsArray[_loc1_]) > 0)
            {
               this.typeMC["Item_" + _loc1_].tick.visible = true;
               this.typeMC["Item_" + _loc1_].skill["buyBtn_1"].visible = false;
               this.typeMC["Item_" + _loc1_].skill["buyBtn_2"].visible = false;
               this.typeMC["Item_" + _loc1_].skill.getEmblemBtn.visible = false;
            }
            if(Character.account_type == 1)
            {
               this.typeMC["Item_" + _loc1_].skill.getEmblemBtn.visible = false;
               this.typeMC["Item_" + _loc1_].skill["buyBtn_1"].visible = false;
            }
            else
            {
               this.typeMC["Item_" + _loc1_].skill.getEmblemBtn.visible = true;
               this.typeMC["Item_" + _loc1_].skill["buyBtn_2"].visible = false;
               this.main.initButton(this.typeMC["Item_" + _loc1_].skill.getEmblemBtn,this.openRecharge,"GET EMBLEM");
            }
            NinjaSage.loadItemIcon(_loc5_,_loc2_,"icon");
            _loc1_++;
         }
      }
      
      private function showConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.target = e.currentTarget.parent.parent.parent.name.replace("Item_","");
         this.target2 = e.currentTarget.parent.name.replace("buyBtn_","");
         var itemid:* = this.rewardsArray[this.target];
         var getSkillInfo:* = SkillLibrary.getSkillInfo(itemid);
         this.selected_skill_id = this.rewardsArray[this.target];
         this.confirmation = new Confirmation();
         if(this.target == 0)
         {
            this.price = this["priceArray" + this.target][this.target2 - 1];
            this.confirmation.txtMc.txt.text = "Confirm buying " + getSkillInfo.skill_name + " for " + this.price + " Tokens ?";
         }
         else if(this.target == 1)
         {
            this.price = this["priceArray" + this.target][this.target2 - 1];
            this.confirmation.txtMc.txt.text = "Confirm buying " + getSkillInfo.skill_name + " for " + this.price + " Tokens ?";
         }
         else if(this.target == 2)
         {
            this.price = this["priceArray" + this.target][this.target2 - 1];
            this.confirmation.txtMc.txt.text = "Confirm buying " + getSkillInfo.skill_name + " for " + this.price + " Tokens ?";
         }
         else if(this.target == 3)
         {
            this.price = this["priceArray" + this.target][this.target2 - 1];
            this.confirmation.txtMc.txt.text = "Confirm buying " + getSkillInfo.skill_name + " for " + this.price + " Tokens ?";
         }
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPackage);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function buyPackage(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.main.amf_manager.service("TRPtXVyrTZgoqpd2.Nr9SIGfqNTww",[Character.char_id,Character.sessionkey,this.selected_skill_id],this.buyPackageResponse);
      }
      
      private function buyPackageResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.main.giveReward(1,this.selected_skill_id);
            Character.updateSkills(this.selected_skill_id,true);
            if(this.target > 0)
            {
               Character.updateSkills(this.rewardsArray[this.target - 1],false);
            }
            Character.account_tokens -= int(this.price);
            this.main.HUD.setBasicData();
            this.showRewards();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function openSkillList(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("TRPtXVyrTZgoqpd2.UQVGV7EobcWb",[Character.char_id,Character.sessionkey],this.openSkillListResponse);
      }
      
      private function openSkillListResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.skillList = param1.packages;
            this.panelMC.panel.listMC.visible = true;
            this.eventHandler.addListener(this.panelMC.panel.listMC.btn_close,MouseEvent.CLICK,this.closeSkillList);
            this.eventHandler.addListener(this.panelMC.panel.listMC.btnPrevPage,MouseEvent.CLICK,this.changePage);
            this.eventHandler.addListener(this.panelMC.panel.listMC.btnNextPage,MouseEvent.CLICK,this.changePage);
            this.panelMC.panel.listMC.txt_title.text = "Limited Store Skills";
            this.panelMC.panel.listMC.txt_ownedSkillTotal.text = this.getTotalOwnedSkills() + " / " + this.skillList.length + " Skills Owned";
            this.currentPage = 1;
            this.totalPage = Math.max(1,Math.ceil(this.skillList.length / 15));
            this.updatePageNumber();
            this.showSkillList();
         }
         else
         {
            this.main.showMessage(param1.result);
         }
      }
      
      private function showSkillList() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         while(_loc1_ < 15)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 15);
            this.panelMC.panel.listMC["skill_" + _loc1_].visible = false;
            this.panelMC.panel.listMC["skill_" + _loc1_].amountTxt.text = "";
            this.panelMC.panel.listMC["skill_" + _loc1_].ownedTxt.text = "";
            if(this.skillList.length > _loc2_)
            {
               this.panelMC.panel.listMC["skill_" + _loc1_].visible = true;
               NinjaSage.loadItemIcon(this.panelMC.panel.listMC["skill_" + _loc1_],this.skillList[_loc2_].advanced_skill);
               if(this.skillList[_loc2_].owned)
               {
                  this.panelMC.panel.listMC["skill_" + _loc1_].ownedTxt.text = "Owned";
               }
            }
            _loc1_++;
         }
      }
      
      private function getTotalOwnedSkills() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.skillList.length)
         {
            if(this.skillList[_loc2_].owned)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNextPage":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.showSkillList();
               }
               break;
            case "btnPrevPage":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.showSkillList();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : *
      {
         this.panelMC.panel.listMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function closeSkillList(param1:MouseEvent) : *
      {
         this.panelMC.panel.listMC.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < 15)
         {
            GF.removeAllChild(this.panelMC.panel.listMC["skill_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panel.listMC["skill_" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function refreshConfirmation(param1:MouseEvent) : *
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to refresh the skill for " + this.refreshCost + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.refreshSkill);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function removeConfirmation(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
      }
      
      private function refreshSkill(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("TRPtXVyrTZgoqpd2.X0BHbQGZg75T",[Character.char_id,Character.sessionkey],this.onSkillRefreshed);
      }
      
      private function onSkillRefreshed(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Store refreshed");
            Character.account_tokens -= this.refreshCost;
            this.main.HUD.setBasicData();
            this.loadAmf();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openRecharge(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function hasSkill(param1:*) : *
      {
         var _loc2_:* = [];
         if(Character.character_skills != "")
         {
            if(Character.character_skills.indexOf(",") >= 0)
            {
               _loc2_ = Character.character_skills.split(",");
            }
            else
            {
               _loc2_ = [Character.character_skills];
            }
         }
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc4_])
            {
               _loc3_ = 1;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function updateTimeleft() : *
      {
         if(this.limitedstore_timestamp == null)
         {
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:* = this.limitedstore_timestamp;
         var _loc5_:* = Math.floor(_loc4_ / _loc1_);
         var _loc6_:* = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         var _loc7_:* = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         this.panelMC.panel.leftdayTxt.text = _loc5_;
         this.panelMC.panel.lefthourTxt.text = _loc6_;
         this.panelMC.panel.leftminTxt.text = _loc7_;
         this.timeout = setTimeout(this.updateTimeleft,10000);
         this.limitedstore_timestamp -= 10;
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.rewardsArray.length)
         {
            GF.removeAllChild(this.typeMC["Item_" + _loc2_].Icon_0.rewardIcon.iconHolder);
            GF.removeAllChild(this.typeMC["Item_" + _loc2_].Icon_0.skillIcon.iconHolder);
            _loc2_++;
         }
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         NinjaSage.clearLoader();
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.main.clearEvents();
         this.main = null;
         this.eventHandler = null;
         this.typeMC = null;
         this.target = 0;
         this.target2 = 0;
         this.confirmation = null;
         this.selected_skill_id = null;
         this.price = 0;
         this.limitedstore_timestamp = null;
         this.discount = null;
         this.refreshCost = 0;
         this.refreshCount = 0;
         this.skillList = null;
         GF.clearArray(this.rewardsArray);
         GF.clearArray(this.priceArray0);
         GF.clearArray(this.priceArray1);
         GF.clearArray(this.priceArray2);
         GF.clearArray(this.priceArray3);
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
