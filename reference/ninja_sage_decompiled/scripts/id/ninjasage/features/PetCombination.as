package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.PetInfo;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class PetCombination extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var main;
      
      private var loaderSwf:BulkLoader;
      
      private var tooltip:ToolTip;
      
      private var response:Object;
      
      private var combineResponse:Object;
      
      private var petList:Object;
      
      private var combinablePet:Array;
      
      private var ownedPet:Array;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var petIndex:int = 0;
      
      private var petLoading:int = 0;
      
      private var petCount:int = 0;
      
      private var combinePrice:int = 0;
      
      private const BOOST_PRICE:int = 500;
      
      private const REQUIRED_LEVEL:int = 30;
      
      private const REQUIRED_MP:int = 100;
      
      private var currentSide:int;
      
      private var selectedPetLeft:Object;
      
      private var selectedPetRight:Object;
      
      private var isLoading:Boolean = false;
      
      private var timeout;
      
      public function PetCombination(param1:*, param2:*)
      {
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.combinablePet = PetInfo.getCombinePet();
         this.ownedPet = [];
         this.selectedPetLeft = {};
         this.selectedPetRight = {};
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.tooltip = ToolTip.getInstance();
         this.panelMC.popupCombineFailed.visible = false;
         this.panelMC.popupCombineSuccess.visible = false;
         this.panelMC.popupMessageMc.visible = false;
         this.panelMC.popupSelectPet.visible = false;
         this.getData();
      }
      
      private function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("ZeETaoA3U4LWgITi.Oy7uhkCdK9Nl",[Character.char_id,Character.sessionkey],this.onGetEventData);
      }
      
      private function onGetEventData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.updateTimeLeft();
            this.initUI();
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
      
      private function initUI() : void
      {
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_change_icon0,MouseEvent.CLICK,this.getPetList);
         this.eventHandler.addListener(this.panelMC.btn_change_icon1,MouseEvent.CLICK,this.getPetList);
         this.eventHandler.addListener(this.panelMC.combine_btn_mc,MouseEvent.CLICK,this.openCombineConfirmation);
         this.eventHandler.addListener(this.panelMC.reward_list_btn,MouseEvent.CLICK,this.openRewards);
         this.eventHandler.addListener(this.panelMC.successUpBtn,MouseEvent.CLICK,this.openBoostConfirmation);
         this.eventHandler.addListener(this.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.convertBtn,MouseEvent.CLICK,this.openRecharge);
         this.panelMC.combine_btn_mc.visible = false;
         this.panelMC.goldTxt.text = Character.character_gold;
         this.panelMC.tokenTxt.text = Character.account_tokens;
         this.panelMC.txt_required_gold.text = 0;
         this.panelMC.txt_required_token.text = this.BOOST_PRICE;
         if(this.response.boost > 0)
         {
            this.panelMC.successUpBtn.visible = false;
         }
      }
      
      private function getPetList(param1:MouseEvent) : void
      {
         this.currentSide = param1.currentTarget.name.replace("btn_change_icon","");
         this.main.loading(true);
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["ba5tOM3HhspX",[Character.char_id,Character.sessionkey]],this.onGetPets);
      }
      
      private function onGetPets(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.panelMC.popupSelectPet.visible = true;
            this.petList = param1.pets.sort(this.sortPetsByMPandLevel);
            this.initPetData();
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
      
      private function sortPetsByMPandLevel(param1:Object, param2:Object) : int
      {
         if(param1.pet_mp > param2.pet_mp)
         {
            return -1;
         }
         if(param1.pet_mp < param2.pet_mp)
         {
            return 1;
         }
         if(param1.pet_level > param2.pet_level)
         {
            return -1;
         }
         if(param1.pet_level < param2.pet_level)
         {
            return 1;
         }
         return 0;
      }
      
      private function initPetData() : void
      {
         this.eventHandler.addListener(this.panelMC.popupSelectPet.panel.btnClose,MouseEvent.CLICK,this.closePetList);
         this.eventHandler.addListener(this.panelMC.popupSelectPet.panel.btnConfirm,MouseEvent.CLICK,this.confirmPetSelect);
         this.eventHandler.addListener(this.panelMC.popupSelectPet.panel.btnPrevPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.popupSelectPet.panel.btnNextPage,MouseEvent.CLICK,this.changePage);
         var _loc1_:int = 0;
         while(_loc1_ < this.petList.length)
         {
            if(this.combinablePet.indexOf(this.petList[_loc1_].pet_swf) > -1)
            {
               this.ownedPet.push(this.petList[_loc1_]);
            }
            _loc1_++;
         }
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.ownedPet.length / 4),1);
         this.updatePageNumber();
         this.resetRecursiveProperty();
         this.resetIconHolder();
         this.loadPetSwf();
      }
      
      public function loadPetSwf() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.isLoading = true;
         if(this.petIndex < this.petLoading)
         {
            _loc1_ = this.ownedPet[this.petIndex].pet_swf;
            _loc2_ = "pets/" + _loc1_ + ".swf";
            _loc3_ = this.loaderSwf.add(_loc2_);
            _loc3_.addEventListener(BulkLoader.COMPLETE,this.completeIcon);
            _loc3_.addEventListener(BulkLoader.ERROR,this.onItemLoadError);
            this.loaderSwf.start();
            return;
         }
         this.isLoading = false;
      }
      
      public function onItemLoadError(param1:ErrorEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.completeIcon);
         ++this.petIndex;
         ++this.petCount;
         this.loadPetSwf();
      }
      
      public function completeIcon(param1:Event) : void
      {
         var _loc10_:Array = null;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onItemLoadError);
         var _loc3_:int = 0;
         while(_loc3_ < 6)
         {
            GF.removeAllChild(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc3_].holder);
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc3_].tooltip = null;
            _loc3_++;
         }
         GF.removeAllChild(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].iconMc_0.rewardIcon.iconHolder);
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].selectedMc.visible = false;
         var _loc4_:MovieClip = null;
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         _loc4_ = param1.target.content["icon"];
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].iconMc_0.skillIcon.visible = false;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].iconMc_0.rewardIcon.iconHolder.addChild(_loc4_);
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].visible = true;
         var _loc7_:* = this.ownedPet[this.petIndex].pet_swf;
         if(param1.target.content[_loc7_])
         {
            param1.target.content[_loc7_].gotoAndStop(1);
         }
         var _loc8_:* = PetInfo.getPetStats(_loc7_);
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].pet_name.text = this.ownedPet[this.petIndex].pet_name;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].current_lvl.text = this.ownedPet[this.petIndex].pet_level;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].current_gp.text = this.ownedPet[this.petIndex].pet_mp;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].required_lvl.text = this.REQUIRED_LEVEL;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].required_gp.text = this.REQUIRED_MP;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].tick_0.visible = false;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].tick_1.visible = false;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].cross_0.visible = false;
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].cross_1.visible = false;
         if(this.ownedPet[this.petIndex].pet_level >= this.REQUIRED_LEVEL)
         {
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].tick_0.visible = true;
         }
         else
         {
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].cross_0.visible = true;
         }
         if(int(this.ownedPet[this.petIndex].pet_mp) >= this.REQUIRED_MP)
         {
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].tick_1.visible = true;
         }
         else
         {
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].cross_1.visible = true;
         }
         NinjaSage.showDynamicTooltip(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].pet_name,this.ownedPet[this.petIndex].pet_name);
         NinjaSage.showDynamicTooltip(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].iconMc_0,_loc8_.pet_name);
         if(this.currentSide == 0)
         {
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].pet_selected.text = this.selectedPetRight.pet_id == this.ownedPet[this.petIndex].pet_id ? "Selected" : "";
         }
         else
         {
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].pet_selected.text = this.selectedPetLeft.pet_id == this.ownedPet[this.petIndex].pet_id ? "Selected" : "";
         }
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_["attacks"].length)
         {
            _loc6_ = param1.target.content["Skill_" + _loc9_];
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc9_ + "_lvTxt"].text = _loc8_.attacks[_loc9_].level;
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc9_].gotoAndStop("enable");
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc9_].holder.addChild(_loc6_);
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc9_].tooltip = _loc8_;
            this.eventHandler.addListener(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc9_],MouseEvent.ROLL_OVER,this.onOverPetSkill);
            this.eventHandler.addListener(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc9_],MouseEvent.ROLL_OUT,this.onOutPetSkill);
            if((_loc10_ = this.ownedPet[this.petIndex].pet_skills.split(","))[_loc9_] == 0)
            {
               this.applyColorEffect(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount]["skill_" + _loc9_],0.4,0.4,0.4);
            }
            _loc9_++;
         }
         if(this.ownedPet[this.petIndex].pet_level >= this.REQUIRED_LEVEL && this.ownedPet[this.petIndex].pet_mp >= this.REQUIRED_MP)
         {
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount].pet_data = this.ownedPet[this.petIndex];
            this.eventHandler.addListener(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount],MouseEvent.CLICK,this.selectPet);
         }
         else
         {
            this.eventHandler.addListener(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + this.petCount],MouseEvent.CLICK,this.selectPetError);
         }
         ++this.petIndex;
         ++this.petCount;
         this.loadPetSwf();
      }
      
      private function onOverPetSkill(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget.name.replace("skill_","");
         var _loc3_:String = "" + param1.currentTarget.tooltip.attacks[_loc2_].name + "\n(Skill)\n" + "\nLevel: " + param1.currentTarget.tooltip.attacks[_loc2_].level + "\n<font color=\"#ffcc00\">Cooldown: " + param1.currentTarget.tooltip.attacks[_loc2_].cooldown + "</font>\n\n" + param1.currentTarget.tooltip.attacks[_loc2_].description;
         this.main.stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc3_);
      }
      
      private function onOutPetSkill(param1:MouseEvent) : void
      {
         this.tooltip.hide();
      }
      
      private function selectPetError(param1:MouseEvent) : *
      {
         this.main.showMessage("Pet is not mature enough");
      }
      
      private function selectPet(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget.name.replace("pet_selectInnerFrame","");
         var _loc3_:* = 0;
         while(_loc3_ < 4)
         {
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc3_].selectedMc.visible = false;
            _loc3_++;
         }
         if(this.currentSide == 0)
         {
            this.selectedPetLeft = param1.currentTarget.pet_data;
         }
         else
         {
            this.selectedPetRight = param1.currentTarget.pet_data;
         }
         this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc2_].selectedMc.visible = true;
      }
      
      private function confirmPetSelect(param1:MouseEvent) : void
      {
         if(this.currentSide == 0)
         {
            if(this.selectedPetLeft.pet_swf == null)
            {
               this.main.showMessage("Please select a pet");
               return;
            }
            if(this.selectedPetLeft.pet_id == this.selectedPetRight.pet_id)
            {
               this.main.showMessage("Cannot select same pet to combine");
               return;
            }
            this.eventHandler.addListener(this.panelMC.iconMc_0.petIcon,MouseEvent.ROLL_OVER,this.onOverTooltipSelectedPet);
            this.eventHandler.addListener(this.panelMC.iconMc_0.petIcon,MouseEvent.ROLL_OUT,this.onOutPetSkill);
            NinjaSage.loadIconSWF("pets",this.selectedPetLeft.pet_swf,this.panelMC.iconMc_0.petIcon.iconHolder,"icon");
         }
         else
         {
            if(this.selectedPetRight.pet_swf == null)
            {
               this.main.showMessage("Please select a pet");
               return;
            }
            if(this.selectedPetLeft.pet_id == this.selectedPetRight.pet_id)
            {
               this.main.showMessage("Cannot select same pet to combine");
               return;
            }
            this.eventHandler.addListener(this.panelMC.iconMc_1.petIcon,MouseEvent.ROLL_OVER,this.onOverTooltipSelectedPet);
            this.eventHandler.addListener(this.panelMC.iconMc_1.petIcon,MouseEvent.ROLL_OUT,this.onOutPetSkill);
            NinjaSage.loadIconSWF("pets",this.selectedPetRight.pet_swf,this.panelMC.iconMc_1.petIcon.iconHolder,"icon");
         }
         if(this.selectedPetLeft.pet_swf != null && this.selectedPetRight.pet_swf != null)
         {
            this.panelMC.combine_btn_mc.visible = true;
         }
         var _loc2_:int = PetInfo.getPetStats(this.selectedPetLeft.pet_swf).pet_combine_gold;
         var _loc3_:int = PetInfo.getPetStats(this.selectedPetRight.pet_swf).pet_combine_gold;
         this.combinePrice = int(_loc2_ + _loc3_);
         this.panelMC.txt_required_gold.text = this.combinePrice;
         this.closePetList(null);
      }
      
      private function openCombineConfirmation(param1:MouseEvent) : void
      {
         this.panelMC.popupMessageMc.visible = true;
         this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btnClose,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btn_cancel_mc,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btn_ok_mc,MouseEvent.CLICK,this.combineAMF);
         this.panelMC.popupMessageMc.panel.decTxt.text = "If the combination process fails, the selected Pets and half of the Maturity Point (MP) will be returned.";
      }
      
      private function combineAMF(param1:MouseEvent) : void
      {
         this.closeConfirmation(null);
         this.main.loading(true);
         this.main.amf_manager.service("ZeETaoA3U4LWgITi.f89HrOngheNW",[Character.char_id,Character.sessionkey,this.selectedPetLeft.pet_id,this.selectedPetRight.pet_id],this.combineAMFResponse);
      }
      
      private function combineAMFResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.combineResponse = param1;
            Character.character_gold = String(Number(Character.character_gold) - Number(this.combinePrice));
            this.main.HUD.setBasicData();
            if(!param1.success)
            {
               this.openCombineFailed();
            }
            else
            {
               this.openCombineSuccess(param1.pets);
            }
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
      
      private function closeConfirmation(param1:MouseEvent) : void
      {
         this.panelMC.popupMessageMc.visible = false;
         this.panelMC.popupMessageMc.panel.decTxt.text = "";
         this.eventHandler.removeListener(this.panelMC.popupMessageMc.panel.btnClose,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.removeListener(this.panelMC.popupMessageMc.panel.btn_cancel_mc,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.removeListener(this.panelMC.popupMessageMc.panel.btn_ok_mc,MouseEvent.CLICK,this.combineAMF);
         this.eventHandler.removeListener(this.panelMC.popupMessageMc.panel.btn_ok_mc,MouseEvent.CLICK,this.boostAMF);
      }
      
      private function openCombineFailed() : void
      {
         this.panelMC.popupCombineFailed.visible = true;
         this.panelMC.popupCombineFailed.panel.titleTxt.text = "Combination Failed";
         this.panelMC.popupCombineFailed.panel.failTxt_0.text = "-" + int(this.selectedPetLeft.pet_mp / 2) + " MP";
         this.panelMC.popupCombineFailed.panel.failTxt_1.text = "-" + int(this.selectedPetRight.pet_mp / 2) + " MP";
         NinjaSage.loadIconSWF("pets",this.selectedPetLeft.pet_swf,this.panelMC.popupCombineFailed.panel.IconMc_0.rewardIcon.iconHolder,"icon");
         NinjaSage.loadIconSWF("pets",this.selectedPetRight.pet_swf,this.panelMC.popupCombineFailed.panel.IconMc_1.rewardIcon.iconHolder,"icon");
         this.eventHandler.addListener(this.panelMC.popupCombineFailed.panel.btnOk,MouseEvent.CLICK,this.closeCombineFailed);
      }
      
      private function closeCombineFailed(param1:MouseEvent) : void
      {
         this.panelMC.popupCombineFailed.visible = false;
         GF.removeAllChild(this.panelMC.popupCombineFailed.panel.IconMc_0.rewardIcon.iconHolder);
         GF.removeAllChild(this.panelMC.popupCombineFailed.panel.IconMc_1.rewardIcon.iconHolder);
         this.eventHandler.removeListener(this.panelMC.popupCombineFailed.panel.btnOk,MouseEvent.CLICK,this.closeCombineFailed);
         this.clearCombine();
      }
      
      private function openCombineSuccess(param1:String) : void
      {
         this.panelMC.popupCombineSuccess.visible = true;
         this.panelMC.popupCombineSuccess.panel.titleTxt.text = "Combination Success";
         NinjaSage.loadItemIcon(this.panelMC.popupCombineSuccess.panel.IconMc.rewardIcon.iconHolder,param1,"icon");
         this.eventHandler.addListener(this.panelMC.popupCombineSuccess.panel.btnOk,MouseEvent.CLICK,this.closeCombineSuccess);
      }
      
      private function closeCombineSuccess(param1:MouseEvent) : void
      {
         this.panelMC.popupCombineSuccess.visible = false;
         GF.removeAllChild(this.panelMC.popupCombineSuccess.panel.IconMc.rewardIcon.iconHolder);
         this.eventHandler.removeListener(this.panelMC.popupCombineSuccess.panel.btnOk,MouseEvent.CLICK,this.closeCombineSuccess);
         this.clearCombine();
      }
      
      private function clearCombine() : void
      {
         this.panelMC.combine_btn_mc.visible = false;
         this.panelMC.txt_required_gold.text = 0;
         this.panelMC.goldTxt.text = Character.character_gold;
         this.panelMC.tokenTxt.text = Character.account_tokens;
         this.selectedPetLeft = {};
         this.selectedPetRight = {};
         GF.removeAllChild(this.panelMC.iconMc_0.petIcon.iconHolder);
         GF.removeAllChild(this.panelMC.iconMc_1.petIcon.iconHolder);
         this.eventHandler.removeListener(this.panelMC.iconMc_0.petIcon,MouseEvent.ROLL_OVER,this.onOverTooltipSelectedPet);
         this.eventHandler.removeListener(this.panelMC.iconMc_0.petIcon,MouseEvent.ROLL_OUT,this.onOutPetSkill);
         this.eventHandler.removeListener(this.panelMC.iconMc_1.petIcon,MouseEvent.ROLL_OVER,this.onOverTooltipSelectedPet);
         this.eventHandler.removeListener(this.panelMC.iconMc_1.petIcon,MouseEvent.ROLL_OUT,this.onOutPetSkill);
      }
      
      private function openBoostConfirmation(param1:MouseEvent) : void
      {
         this.panelMC.popupMessageMc.visible = true;
         this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btnClose,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btn_cancel_mc,MouseEvent.CLICK,this.closeConfirmation);
         this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btn_ok_mc,MouseEvent.CLICK,this.boostAMF);
         this.panelMC.popupMessageMc.panel.decTxt.text = "Increase the combine rate? The boosted combine rate lasts for 3 hours.";
      }
      
      private function boostAMF(param1:MouseEvent) : void
      {
         this.closeConfirmation(null);
         this.main.loading(true);
         this.main.amf_manager.service("ZeETaoA3U4LWgITi.bf17UBCRC3vT",[Character.char_id,Character.sessionkey],this.boostAMFResponse);
      }
      
      private function boostAMFResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            this.panelMC.successUpBtn.visible = false;
            Character.account_tokens -= this.BOOST_PRICE;
            this.response.boost = param1.boost;
            this.main.HUD.setBasicData();
            this.updateTimeLeft();
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
      
      private function onOverTooltipSelectedPet(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget.parent.name.replace("iconMc_","");
         var _loc3_:Object = _loc2_ == 0 ? this.selectedPetLeft : this.selectedPetRight;
         var _loc4_:String = "" + _loc3_.pet_name + "\n\nLevel " + _loc3_.pet_level + "\n\nMP " + _loc3_.pet_mp;
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc4_);
      }
      
      private function closePetList(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.panelMC.popupSelectPet.visible = false;
         this.ownedPet = [];
         this.currentPage = 1;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               GF.removeAllChild(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc2_]["skill_" + _loc3_].holder);
               this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc2_]["skill_" + _loc3_].tooltip = null;
               _loc3_++;
            }
            GF.removeAllChild(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc2_].iconMc_0.rewardIcon.iconHolder);
            _loc2_++;
         }
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         if(this.isLoading)
         {
            return;
         }
         switch(param1.currentTarget.name)
         {
            case "btnNextPage":
               if(this.currentPage >= this.totalPage)
               {
                  return;
               }
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
               }
               break;
            case "btnPrevPage":
               if(this.currentPage <= 1)
               {
                  return;
               }
               if(this.currentPage > 1)
               {
                  --this.currentPage;
               }
               break;
         }
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loadPetSwf();
      }
      
      public function resetRecursiveProperty() : void
      {
         this.petLoading = this.currentPage * 4;
         if(this.ownedPet.length < this.petLoading)
         {
            this.petLoading = this.ownedPet.length;
         }
         this.petIndex = (this.currentPage - 1) * 4;
         this.petCount = 0;
      }
      
      public function resetIconHolder() : void
      {
         var _loc2_:int = 0;
         this.skillIconMC = [];
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            GF.removeAllChild(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].iconMc_0.rewardIcon.iconHolder);
            NinjaSage.clearDynamicTooltip(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].pet_name);
            NinjaSage.clearDynamicTooltip(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].iconMc_0);
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].visible = false;
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].gotoAndStop(1);
            this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].tooltip = null;
            this.eventHandler.removeListener(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_],MouseEvent.CLICK,this.selectPet);
            this.eventHandler.removeListener(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_],MouseEvent.CLICK,this.selectPetError);
            _loc2_ = 0;
            while(_loc2_ < 6)
            {
               GF.removeAllChild(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_]["skill_" + _loc2_].holder);
               this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_]["skill_" + _loc2_].tooltip = null;
               this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_]["skill_" + _loc2_ + "_lvTxt"].text = "";
               this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_]["skill_" + _loc2_].gotoAndStop("disable");
               this.eventHandler.removeListener(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_]["skill_" + _loc2_],MouseEvent.ROLL_OVER,this.onOverPetSkill);
               this.eventHandler.removeListener(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_]["skill_" + _loc2_],MouseEvent.ROLL_OUT,this.onOutPetSkill);
               this.applyColorEffect(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_]["skill_" + _loc2_],1,1,1);
               _loc2_++;
            }
            GF.removeAllChild(this.panelMC.popupSelectPet.panel["pet_selectInnerFrame" + _loc1_].iconMc_0.rewardIcon.iconHolder);
            _loc1_++;
         }
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.popupSelectPet.panel.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      public function updateTimeLeft() : void
      {
         if(this.response.boost == null)
         {
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:* = this.response.boost;
         var _loc5_:* = Math.floor(_loc4_ / _loc1_);
         var _loc6_:* = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         var _loc7_:* = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         this.panelMC.timeTxt.text = _loc5_ + ":" + _loc6_ + ":" + _loc7_;
         this.timeout = setTimeout(this.updateTimeLeft,10000);
         this.response.boost -= 10;
      }
      
      public function applyColorEffect(param1:MovieClip, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:ColorTransform = new ColorTransform(param2,param3,param4,1,1,1,1,0);
         param1.transform.colorTransform = _loc5_;
      }
      
      private function openRewards(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("DragonHuntReward","DragonHuntReward");
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "getMoreBtn")
         {
            this.main.loadPanel("Panels.Recharge");
         }
         else
         {
            this.main.loadExternalSwfPanel("Headquarter","Headquarter");
         }
      }
      
      private function closePanel(param1:MouseEvent) : void
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
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         if(this.tooltip)
         {
            this.tooltip.destroy();
            this.tooltip = null;
         }
         this.loaderSwf.clear();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.clearCombine();
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.combinablePet = [];
         this.ownedPet = [];
         this.selectedPetLeft = null;
         this.selectedPetRight = null;
         this.loaderSwf = null;
         this.main = null;
         this.eventHandler = null;
         this.petList = null;
         this.selectedPet = null;
         this.response = null;
         this.combineResponse = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
