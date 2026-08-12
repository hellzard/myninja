package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.PreviewManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.GameData;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   public class AnniversaryClothing extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      private var main;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var response:Object;
      
      private var packageData:Object;
      
      private var selectedPreviewSkill:String;
      
      private var selectedPreviewItem:String;
      
      private var selectedBuySkill:int;
      
      private var selectedBuyType:String;
      
      private var skillPrice:int;
      
      private var currencyType:String;
      
      private var loaderSwf:BulkLoader;
      
      private var previewMC:PreviewManager;
      
      private var outfits:Array;
      
      public function AnniversaryClothing(param1:*, param2:*)
      {
         this.outfits = [];
         var _loc3_:Object = GameData.get("anniv2026");
         super();
         this.packageData = _loc3_.clothing;
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.previewItemMC,this.closeItemPreview);
         this.escapeKey.addListener(this.panelMC.previewMC,this.closePreview);
         this.eventHandler = new EventHandler();
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.getEventData();
      }
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.54oleXcxG4U4",[Character.char_id,Character.sessionkey],this.onGetEventData);
      }
      
      private function onGetEventData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.initUI();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function initUI() : void
      {
         this.panelMC.tokenTxt.text = Character.account_tokens;
         this.panelMC.goldTxt.text = Character.character_gold;
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.convertBtn,MouseEvent.CLICK,this.openRecharge);
         this.openPackage();
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
      
      private function openPackage() : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc1_:MovieClip = this.panelMC;
         var _loc2_:Array = ["top","left","right"];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_["price" + _loc3_].txt.text = this.packageData[_loc2_[_loc3_]].price;
            _loc1_["buyBtn_" + _loc3_].metaData = {"position":_loc2_[_loc3_]};
            _loc1_["tick" + _loc3_].visible = false;
            _loc4_ = 0;
            while(_loc4_ < this.packageData[_loc2_[_loc3_]].rewards.length)
            {
               _loc5_ = this.packageData[_loc2_[_loc3_]].rewards[_loc4_].replace("%s",Character.character_gender);
               _loc1_[_loc2_[_loc3_] + "Icon_" + _loc4_].amountTxt.text = "";
               _loc1_[_loc2_[_loc3_] + "Icon_" + _loc4_].ownedTxt.text = "";
               NinjaSage.loadItemIcon(_loc1_[_loc2_[_loc3_] + "Icon_" + _loc4_],_loc5_);
               if(Character.hasSkill(_loc5_) > 0)
               {
                  _loc1_[_loc2_[_loc3_] + "Icon_" + _loc4_].ownedTxt.visible = true;
                  _loc1_[_loc2_[_loc3_] + "Icon_" + _loc4_].ownedTxt.text = "Owned";
               }
               if(Character.isItemOwned(_loc5_) > 0)
               {
                  _loc1_[_loc2_[_loc3_] + "Icon_" + _loc4_].ownedTxt.visible = true;
                  _loc1_[_loc2_[_loc3_] + "Icon_" + _loc4_].ownedTxt.text = "Owned";
               }
               _loc6_ = _loc2_[_loc3_] + "_bought";
               if(!this.response[_loc6_])
               {
                  this.main.initButton(_loc1_["buyBtn_" + _loc3_],this.showConfirmationPackage,this.packageData[_loc2_[_loc3_]].price);
               }
               else
               {
                  this.main.initButtonDisable(_loc1_["buyBtn_" + _loc3_],this.showConfirmationPackage,this.packageData[_loc2_[_loc3_]].price);
                  _loc1_["tick" + _loc3_].visible = true;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function openPreview(param1:MouseEvent) : void
      {
         if(param1.currentTarget.metaData.itemId.indexOf("skill_") >= 0)
         {
            this.handleSkillPreview(param1.currentTarget.metaData.itemId);
         }
         else
         {
            this.handleItemPreview(param1.currentTarget.metaData.itemId);
         }
      }
      
      private function handleItemPreview(param1:String) : void
      {
         this.panelMC.previewItemMC.visible = true;
         this.eventHandler.addListener(this.panelMC.previewItemMC.btn_close,MouseEvent.CLICK,this.closeItemPreview);
         this.selectedPreviewItem = param1;
         var _loc2_:* = new OutfitManager(false);
         var _loc3_:* = param1.indexOf("wpn") >= 0 ? param1 : Character.character_weapon;
         var _loc4_:* = param1.indexOf("back") >= 0 ? param1 : Character.character_back_item;
         var _loc5_:* = param1.indexOf("set") >= 0 ? param1 : Character.character_set;
         var _loc6_:* = param1.indexOf("hair") >= 0 ? param1 : Character.character_hair;
         _loc2_.fillOutfit(this.panelMC.previewItemMC.char_mc,_loc3_,_loc4_,_loc5_,_loc6_,Character.character_face,Character.character_color_hair,Character.character_color_skin);
         this.outfits.push(_loc2_);
      }
      
      private function closeItemPreview(param1:MouseEvent) : void
      {
         this.panelMC.previewItemMC.visible = false;
         GF.destroyArray(this.outfits);
         OutfitManager.clearStaticMc();
         this.outfits = [];
      }
      
      private function handleSkillPreview(param1:String) : void
      {
         this.panelMC.previewMC.visible = true;
         this.eventHandler.addListener(this.panelMC.previewMC.btn_close,MouseEvent.CLICK,this.closePreview);
         this.eventHandler.addListener(this.panelMC.previewMC.btn_replay,MouseEvent.CLICK,this.handleReplay);
         this.selectedPreviewSkill = param1;
         this.loadSkillAndPreview();
      }
      
      private function loadSkillAndPreview() : void
      {
         var _loc1_:* = "skills/" + this.selectedPreviewSkill + ".swf";
         var _loc2_:* = this.loaderSwf.add(_loc1_);
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.completePreview);
         this.loaderSwf.start();
      }
      
      private function completePreview(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = SkillLibrary.getSkillInfo(this.selectedPreviewSkill);
         var _loc4_:MovieClip = param1.target.content[this.selectedPreviewSkill];
         this.previewMC = new PreviewManager(this.main,_loc4_,_loc3_);
         this.panelMC.previewMC.skillMc.scaleX = 1.3;
         this.panelMC.previewMC.skillMc.scaleY = 1.3;
         this.panelMC.previewMC.skillMc.addChild(this.previewMC.preview_mc);
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function closePreview(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.panelMC.previewMC.skillMc);
         if(this.previewMC)
         {
            this.previewMC.destroy();
         }
         this.previewMC = null;
         this.panelMC.previewMC.visible = false;
      }
      
      private function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      private function showConfirmationPackage(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.selectedBuyType = e.currentTarget.metaData.position;
         this.skillPrice = Util.convertToNumber(this.packageData[this.selectedBuyType].price);
         this.currencyType = this.packageData[this.selectedBuyType].currency;
         this.confirmation.txtMc.txt.text = "Confirm buying this package for " + this.packageData[this.selectedBuyType].price + " " + this.currencyType + "?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buySkill);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function buySkill(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("zy8Ztqe05vkpqNx0.yGSJdsKIQcH0",[Character.char_id,Character.sessionkey,this.selectedBuyType],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.eventHandler.removeAllEventListeners();
            this.main.giveReward(1,this.packageData[this.selectedBuyType].rewards,"anniversary");
            Character.addRewards(this.packageData[this.selectedBuyType].rewards);
            this.response[this.selectedBuyType + "_bought"] = true;
            if(this.currencyType == "tokens")
            {
               Character.account_tokens = int(Character.account_tokens) - this.skillPrice;
            }
            else if(this.currencyType == "gold")
            {
               Character.character_gold = String(Number(Character.character_gold) - this.skillPrice);
            }
            this.initUI();
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         var _loc3_:int = 0;
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         var _loc1_:Array = ["top","left","right"];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.packageData[_loc1_[_loc2_]].rewards.length)
            {
               GF.removeAllChild(this.panelMC[_loc1_[_loc2_] + "Icon_" + _loc3_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC[_loc1_[_loc2_] + "Icon_" + _loc3_].skillIcon.iconHolder);
               _loc3_++;
            }
            _loc2_++;
         }
         GF.removeAllChild(this.panelMC);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.panelMC = null;
         this.response = null;
         this.packageData = null;
         this.main = null;
      }
   }
}
