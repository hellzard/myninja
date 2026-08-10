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
   
   public class RamadhanPackage extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      private var main:*;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var response:Object;
      
      private var packageData:Object;
      
      private var selectedPreviewSkill:String;
      
      private var selectedPreviewItem:String;
      
      private var skillPrice:int;
      
      private var loaderSwf:BulkLoader;
      
      private var previewMC:PreviewManager;
      
      private var outfits:Array = [];
      
      public function RamadhanPackage(param1:*, param2:*)
      {
         var _loc3_:Object = GameData.get("ramadhan2026");
         super();
         this.packageData = {
            "packageName":_loc3_.paket.name,
            "packagePrice":_loc3_.paket.price,
            "packageRewards":_loc3_.paket.rewards
         };
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.previewItemMC,this.closeItemPreview);
         this.escapeKey.addListener(this.panelMC.previewMC,this.closePreview);
         this.eventHandler = this.main.eventHandler;
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.main.handleVillageHUDVisibility(false);
         this.getEventData();
      }
      
      private function getEventData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("RamadhanEvent2026.getPackage",[Character.char_id,Character.sessionkey],this.onGetEventData);
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
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function initUI() : void
      {
         this.panelMC.previewMC.visible = false;
         this.panelMC.tokenTxt.text = Character.account_tokens;
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         this.openPackage();
      }
      
      private function checkIsItemOrSkill(param1:String) : Boolean
      {
         var _loc2_:Array = ["skill_"];
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
         var _loc3_:String = null;
         var _loc1_:MovieClip = this.panelMC;
         var _loc2_:int = 0;
         while(_loc2_ < this.packageData.packageRewards.length)
         {
            _loc3_ = this.packageData.packageRewards[_loc2_].replace("%s",Character.character_gender);
            _loc1_["iconMC_" + _loc2_].amountTxt.text = "";
            _loc1_["iconMC_" + _loc2_].ownedTxt.text = "";
            _loc1_["iconMC_" + _loc2_].btn_preview.visible = this.checkIsItemOrSkill(_loc3_);
            _loc1_["iconMC_" + _loc2_].btn_preview.metaData = {"itemId":_loc3_};
            this.eventHandler.addListener(_loc1_["iconMC_" + _loc2_].btn_preview,MouseEvent.CLICK,this.openPreview);
            NinjaSage.loadItemIcon(_loc1_["iconMC_" + _loc2_],_loc3_);
            if(Character.hasSkill(_loc3_) > 0)
            {
               _loc1_["iconMC_" + _loc2_].ownedTxt.visible = true;
               _loc1_["iconMC_" + _loc2_].ownedTxt.text = "Owned";
            }
            if(Character.isItemOwned(_loc3_) > 0)
            {
               _loc1_["iconMC_" + _loc2_].ownedTxt.visible = true;
               _loc1_["iconMC_" + _loc2_].ownedTxt.text = "Owned";
            }
            _loc2_++;
         }
         if(Character.account_type == 0)
         {
            _loc1_.priceMC.btn_buy_0.visible = true;
            _loc1_.priceMC.btn_buy_1.visible = false;
            _loc1_.priceMC.btn_emblem.visible = true;
         }
         else
         {
            _loc1_.priceMC.btn_buy_0.visible = false;
            _loc1_.priceMC.btn_buy_1.visible = true;
            _loc1_.priceMC.btn_emblem.visible = false;
         }
         _loc1_.priceMC.tick.visible = false;
         if(this.response.package_bought)
         {
            _loc1_.priceMC.tick.visible = true;
            _loc1_.priceMC.btn_buy_0.visible = false;
            _loc1_.priceMC.btn_buy_1.visible = false;
         }
         _loc1_.priceMC.price_0.text = this.packageData.packagePrice[0];
         _loc1_.priceMC.price_1.text = this.packageData.packagePrice[1];
         this.eventHandler.addListener(_loc1_.priceMC.btn_emblem,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(_loc1_.priceMC.btn_buy_0,MouseEvent.CLICK,this.showConfirmationPackage);
         this.eventHandler.addListener(_loc1_.priceMC.btn_buy_1,MouseEvent.CLICK,this.showConfirmationPackage);
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
         this.panelMC.previewMC.skillMc.scaleX = 1.7;
         this.panelMC.previewMC.skillMc.scaleY = 1.7;
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
         this.skillPrice = this.packageData.packagePrice[Character.account_type];
         this.confirmation.txtMc.txt.text = "Confirm buying " + this.packageData.packageName + " for " + this.skillPrice + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPackage);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function buyPackage(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.main.loading(true);
         this.main.amf_manager.service("RamadhanEvent2026.buyItem",[Character.char_id,Character.sessionkey],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,this.packageData.packageRewards,"ramadhan");
            Character.addRewards(this.packageData.packageRewards);
            this.response.package_bought = true;
            Character.account_tokens = int(Character.account_tokens) - this.skillPrice;
            this.initUI();
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
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
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.packageData.packageRewards.length)
         {
            GF.removeAllChild(this.panelMC["iconMC_" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC["iconMC_" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         this.main.handleVillageHUDVisibility(true);
         GF.removeAllChild(this.panelMC);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.confirmation = null;
         this.panelMC = null;
         this.response = null;
         this.packageData = null;
         this.main = null;
      }
   }
}

