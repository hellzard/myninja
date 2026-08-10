package Panels
{
   import Managers.NinjaSage;
   import Managers.PreviewManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.GameData;
   import Storage.ItemDropSourceMapping;
   import Storage.PetInfo;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3938")]
   public class PetShop extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var preview:MovieClip;
      
      public var buyGold:SimpleButton;
      
      public var buyTokens:SimpleButton;
      
      public var txt_title:TextField;
      
      public var txt_gold:TextField;
      
      public var txt_token:TextField;
      
      public var eventHandler:EventHandler;
      
      private var petData:Array;
      
      private var petDataOriginal:Array;
      
      private var petInfo:Object;
      
      private var loaderSwf:BulkLoader;
      
      private var itemIndex:int = 0;
      
      private var itemLoading:int = 0;
      
      private var itemCount:int = 0;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var selectedPetIndex:int = -1;
      
      private var isLoading:Boolean;
      
      private var firstLoad:Boolean = true;
      
      private var petIconMCArray:Array;
      
      private var petStaticMCArray:Array;
      
      private var petSkillIconMCArray:Array;
      
      public var tooltip:ToolTip;
      
      public var confirmation:Confirmation;
      
      public var petMCPreview:PreviewManager;
      
      private var main:*;
      
      public function PetShop(param1:*)
      {
         super();
         var _loc2_:* = GameData.get("pet_shop");
         this.petData = [];
         this.petDataOriginal = [];
         this.petIconMCArray = [];
         this.petSkillIconMCArray = [];
         this.petStaticMCArray = [];
         this.petMCPreview = null;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.pets.length)
         {
            this.petData.push({
               "petId":_loc2_.pets[_loc3_].id,
               "petPrice":_loc2_.pets[_loc3_].price
            });
            this.petDataOriginal.push({
               "petId":_loc2_.pets[_loc3_].id,
               "petPrice":_loc2_.pets[_loc3_].price
            });
            _loc3_++;
         }
         this.gotoAndStop(1);
         this.addFrameScript(23,this.stopEntrance);
         this.main = param1;
         this.tooltip = ToolTip.getInstance();
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(9);
         this.eventHandler = new EventHandler();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.escapeKey.addListener(this.preview,this.closePreview);
         this.main.loading(true);
         this.initUI();
         this.initButton();
      }
      
      private function initUI() : void
      {
         this.main.handleVillageHUDVisibility(false);
         this.totalPage = Math.max(Math.ceil(this.petData.length / 9),1);
         this.panelMC.txt_goToPage.restrict = "0-9";
         this.txt_gold.text = Character.character_gold;
         this.txt_token.text = String(Character.account_tokens);
         this.panelMC.txt_goToPage.visible = false;
         this.panelMC.btn_to_page.visible = false;
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedPetHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function initButton() : void
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.buyGold,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.buyTokens,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_to_page,MouseEvent.CLICK,this.goToPage);
         this.eventHandler.addListener(this.panelMC.btn_search,MouseEvent.CLICK,this.searchItem);
         this.eventHandler.addListener(this.panelMC.btn_clearSearch,MouseEvent.CLICK,this.onSearchClear);
      }
      
      private function loadSwf() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.isLoading = true;
         if(this.itemIndex < this.itemLoading)
         {
            _loc1_ = this.petData[this.itemIndex].petId;
            _loc2_ = "pets/" + _loc1_ + ".swf";
            _loc3_ = this.loaderSwf.add(_loc2_);
            _loc3_.addEventListener(BulkLoader.COMPLETE,this.completeIcon);
            _loc3_.addEventListener(BulkLoader.ERROR,this.onItemLoadError);
            this.loaderSwf.start();
            return;
         }
         if(this.firstLoad)
         {
            this.main.loading(false);
            this.gotoAndPlay(1);
            this.firstLoad = false;
         }
         if(this.petData.length > 0)
         {
            this.selectPet(0);
         }
         this.isLoading = false;
      }
      
      private function onItemLoadError(param1:ErrorEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.completeIcon);
         this.petIconMCArray[this.itemCount] = null;
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      private function completeIcon(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onItemLoadError);
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         _loc4_ = param1.target.content.icon;
         if(!Character.play_items_animation)
         {
            _loc4_.stopAllMovieClips();
         }
         this.petIconMCArray.push(_loc4_);
         this.panelMC["item_" + this.itemCount].iconMc.iconHolder.addChild(_loc4_);
         this.panelMC["item_" + this.itemCount].gotoAndStop(1);
         this.panelMC["item_" + this.itemCount].visible = true;
         var _loc5_:String = this.petData[this.itemIndex].petId;
         param1.target.content[_loc5_].gotoAndStop(1);
         var _loc6_:Object = PetInfo.getPetStats(_loc5_);
         var _loc7_:Array = [];
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.attacks.length)
         {
            _loc4_ = param1.target.content["Skill_" + _loc8_];
            if(!Character.play_items_animation)
            {
               _loc4_.stopAllMovieClips();
            }
            _loc7_.push(_loc4_);
            _loc8_++;
         }
         this.petSkillIconMCArray.push(_loc7_);
         _loc4_ = param1.target.content.PetStaticFullBody;
         if(!Character.play_items_animation)
         {
            _loc4_.stopAllMovieClips();
         }
         this.petStaticMCArray.push(_loc4_);
         this.panelMC["item_" + this.itemCount].emblemMC.visible = _loc6_.pet_emblem ? true : false;
         this.panelMC["item_" + this.itemCount].tooltip = _loc6_;
         this.panelMC["item_" + this.itemCount].item_type = "pet";
         this.panelMC["item_" + this.itemCount].lvlTxt.text = _loc6_.pet_level;
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.MOUSE_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.MOUSE_OUT,this.toolTiponOut);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.CLICK,this.selectPet);
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      private function selectPet(param1:*) : void
      {
         var _loc2_:int = param1 is MouseEvent ? int(param1.currentTarget.name.replace("item_","")) : int(param1);
         this.resetSelectedPetHolder();
         this.selectedPetIndex = _loc2_ + int(int(this.currentPage - 1) * 9);
         var _loc3_:Object = this.panelMC["item_" + _loc2_].tooltip;
         if(this.petData[this.selectedPetIndex].petPrice.indexOf("gold_") >= 0)
         {
            this.panelMC.priceMC.gotoAndStop(1);
            this.panelMC.priceMC.txt_gold.text = this.petData[this.selectedPetIndex].petPrice.replace("gold_","");
         }
         else
         {
            this.panelMC.priceMC.gotoAndStop(2);
            this.panelMC.priceMC.txt_token.text = this.petData[this.selectedPetIndex].petPrice.replace("token_","");
         }
         this.panelMC.priceMC.visible = true;
         this.panelMC.btn_buy.visible = true;
         this.panelMC.btn_preview.visible = true;
         this.panelMC.pet_name.visible = true;
         this.panelMC.btn_buy.metaData = {"pet_data":_loc3_};
         this.eventHandler.addListener(this.panelMC.btn_buy,MouseEvent.CLICK,this.openBuyConfirmation);
         this.eventHandler.addListener(this.panelMC.btn_preview,MouseEvent.CLICK,this.loadPreviewSwf);
         this.panelMC.pet_name.text = _loc3_.pet_name;
         this.panelMC.pet_mc.addChild(this.petStaticMCArray[_loc2_]);
         var _loc4_:int = 0;
         while(_loc4_ < this.petSkillIconMCArray[_loc2_].length)
         {
            this.panelMC["skill_" + _loc4_].gotoAndStop(3);
            this.panelMC["skill_" + _loc4_].iconHolder.addChild(this.petSkillIconMCArray[_loc2_][_loc4_]);
            this.panelMC["skill_" + _loc4_].tooltip = _loc3_.attacks[_loc4_];
            this.panelMC["skill_" + _loc4_].item_type = "skill";
            this.eventHandler.addListener(this.panelMC["skill_" + _loc4_],MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.addListener(this.panelMC["skill_" + _loc4_],MouseEvent.MOUSE_OUT,this.toolTiponOut);
            _loc4_++;
         }
      }
      
      private function openBuyConfirmation(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to buy " + e.currentTarget.metaData.pet_data.pet_name + " ?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.buyPetAMF);
         addChild(this.confirmation);
      }
      
      private function buyPetAMF(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.petData[this.selectedPetIndex].petId];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["iMIeU5KsJgkI",_loc2_],this.onBuyPetAMF);
      }
      
      private function onBuyPetAMF(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveReward(1,this.petData[this.selectedPetIndex].petId);
            if(this.petData[this.selectedPetIndex].petPrice.indexOf("gold_") >= 0)
            {
               _loc2_ = this.petData[this.selectedPetIndex].petPrice.replace("gold_","");
               _loc3_ = Util.convertToNumber(_loc2_);
               Character.character_gold = String(Number(Character.character_gold) - Number(_loc3_));
            }
            else
            {
               _loc2_ = this.petData[this.selectedPetIndex].petPrice.replace("token_","");
               _loc3_ = Util.convertToNumber(_loc2_);
               Character.account_tokens -= _loc3_;
            }
            this.txt_gold.text = Character.character_gold;
            this.txt_token.text = String(Character.account_tokens);
            this.main.HUD.setBasicData();
         }
         else if(param1.status > 1 && param1.hasOwnProperty("result"))
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function loadPreviewSwf(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.resetPreviewHolder();
         var _loc2_:* = this.petData[this.selectedPetIndex].petId;
         var _loc3_:* = "pets/" + _loc2_ + ".swf";
         var _loc4_:* = this.loaderSwf.add(_loc3_);
         _loc4_.addEventListener(BulkLoader.COMPLETE,this.onCompletePetLoaded);
         _loc4_.addEventListener(BulkLoader.ERROR,this.onPetLoadError);
         this.loaderSwf.start();
      }
      
      private function onPetLoadError(param1:ErrorEvent) : void
      {
         this.main.loading(false);
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.onCompletePetLoaded);
         this.loaderSwf.removeAll();
         this.updatePageNumber();
         this.resetSelectedPetHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function onCompletePetLoaded(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onPetLoadError);
         this.petInfo = PetInfo.getPetStats(this.petData[this.selectedPetIndex].petId);
         var _loc3_:MovieClip = param1.target.content[this.petInfo.pet_id];
         this.petMCPreview = new PreviewManager(this.main,_loc3_,this.petInfo);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         this.main.loading(false);
         this.showPreview();
      }
      
      private function showPreview() : void
      {
         this.preview.visible = true;
         this.preview.petMc.addChild(this.petMCPreview.preview_mc);
         this.petMCPreview.preview_mc.gotoAndPlay("standby");
         var _loc1_:int = this.petMCPreview.preview_mc.currentLabels.length - 4;
         var _loc2_:int = 1;
         while(_loc2_ <= _loc1_)
         {
            this.preview["attack_0" + _loc2_].visible = true;
            this.main.initButton(this.preview["attack_0" + _loc2_],this.playSkillAnimation,"Skill " + _loc2_);
            this.main.initButton(this.preview.dodge,this.playSkillAnimation,"Dodge");
            this.main.initButton(this.preview.hit,this.playSkillAnimation,"Hit");
            this.main.initButton(this.preview.dead,this.playSkillAnimation,"Dead");
            _loc2_++;
         }
         this.eventHandler.addListener(this.preview.exitBtn,MouseEvent.CLICK,this.closePreview);
      }
      
      private function playSkillAnimation(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:int = int(param1.currentTarget.name.replace("attack_","")) - 1;
         if(_loc3_ != -1)
         {
            _loc4_ = this.petInfo.attacks[_loc3_].name;
            this.main.showMessage(_loc4_);
            _loc4_ = null;
         }
         this.petMCPreview.preview_mc.gotoAndPlay(_loc2_);
      }
      
      private function resetPreviewHolder() : void
      {
         if(this.petMCPreview)
         {
            this.petMCPreview.destroy();
         }
         var _loc1_:int = 1;
         while(_loc1_ <= 6)
         {
            this.preview["attack_0" + _loc1_].visible = false;
            _loc1_++;
         }
         this.petInfo = null;
         this.petMCPreview = null;
      }
      
      private function closePreview(param1:MouseEvent) : void
      {
         this.resetPreviewHolder();
         GF.removeAllChild(this.preview.petMc);
         this.preview.visible = false;
      }
      
      private function goToPage(param1:MouseEvent) : void
      {
         if(this.panelMC.txt_goToPage.text == "" || this.panelMC.txt_goToPage.text < 1 || this.panelMC.txt_goToPage.text > this.totalPage)
         {
            return;
         }
         this.currentPage = int(this.panelMC.txt_goToPage.text);
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedPetHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function searchItem(param1:MouseEvent) : void
      {
         var _loc6_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc2_:Array = [];
         var _loc3_:String = this.panelMC.txt_search.text.toLowerCase();
         var _loc4_:Array = this.petDataOriginal;
         var _loc5_:int = int(_loc4_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc7_];
            _loc8_ = PetInfo.getPetStats(_loc6_.petId);
            _loc9_ = _loc8_["pet_name"].toLowerCase();
            if(_loc9_.indexOf(_loc3_) >= 0)
            {
               _loc2_.push({
                  "petId":_loc6_.petId,
                  "petPrice":_loc6_.petPrice
               });
            }
            _loc7_++;
         }
         this.petData = _loc2_;
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.petData.length / 9),1);
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedPetHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function onSearchClear(param1:MouseEvent = null) : void
      {
         this.panelMC.txt_search.text = "";
         this.panelMC.txt_goToPage.text = "";
         this.petData = this.petDataOriginal;
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.petData.length / 9),1);
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedPetHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         if(this.isLoading)
         {
            return;
         }
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  break;
               }
               return;
               break;
            case "btn_prev":
               if(this.currentPage <= 1)
               {
                  return;
               }
               --this.currentPage;
         }
         this.resetPreviewHolder();
         this.resetSelectedPetHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         if(this.loaderSwf.itemsLoaded >= 18)
         {
            this.loaderSwf.removeAll();
         }
         this.loadSwf();
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function hoverOver(param1:Event) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function hoverOut(param1:Event) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function toolTiponOver(param1:MouseEvent) : void
      {
         var formatDesc:Function;
         var tooltipData:Object = null;
         var itemSource:Array = null;
         var desc:String = null;
         var itemType:String = null;
         var e:MouseEvent = param1;
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(!mc.tooltipCache)
         {
            formatDesc = function(param1:String, param2:String, param3:String = "", param4:String = "", param5:String = "", param6:Array = null):String
            {
               return param1 + "\n(" + param2 + ")\n" + (param3 ? "\nLevel: " + param3 : "") + (param4 ? "\n" + param4 : "") + "\n\n" + param5 + ItemDropSourceMapping.formatSourceText(param6);
            };
            tooltipData = mc.tooltip;
            if(!tooltipData)
            {
               return;
            }
            itemSource = tooltipData.hasOwnProperty("item_source") ? tooltipData.item_source : null;
            itemType = mc.item_type;
            switch(itemType)
            {
               case "pet":
                  e.currentTarget.gotoAndStop(2);
                  desc = formatDesc(tooltipData.pet_name,"Pet",tooltipData.pet_level,"",tooltipData.description,itemSource);
                  break;
               case "skill":
                  desc = formatDesc(tooltipData.name,"Skill",tooltipData.level,"<font color=\"#ffcc00\">Cooldown: " + tooltipData.cooldown + "</font>",tooltipData.description,null);
                  break;
               default:
                  desc = "";
            }
            mc.tooltipCache = desc;
         }
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(mc.tooltipCache);
      }
      
      private function toolTiponOut(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(1);
         this.tooltip.hide();
      }
      
      private function resetSelectedPetHolder() : void
      {
         GF.removeAllChild(this.panelMC.pet_mc);
         this.panelMC.btn_buy.metaData = {};
         this.preview.visible = false;
         this.panelMC.priceMC.visible = false;
         this.panelMC.btn_buy.visible = false;
         this.panelMC.btn_preview.visible = false;
         this.panelMC.pet_name.visible = false;
         this.eventHandler.removeListener(this.panelMC.btn_preview,MouseEvent.CLICK,this.loadPreviewSwf);
         this.eventHandler.removeListener(this.panelMC.btn_buy,MouseEvent.CLICK,this.openBuyConfirmation);
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            delete this.panelMC["skill_" + _loc1_].tooltip;
            delete this.panelMC["skill_" + _loc1_].tooltipCache;
            delete this.panelMC["skill_" + _loc1_].item_type;
            this.panelMC["skill_" + _loc1_].gotoAndStop(1);
            this.eventHandler.removeListener(this.panelMC["skill_" + _loc1_],MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this.panelMC["skill_" + _loc1_],MouseEvent.MOUSE_OUT,this.toolTiponOut);
            GF.removeAllChild(this.panelMC["skill_" + _loc1_].iconHolder);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            this.panelMC["item_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function resetIconHolder() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.petIconMCArray.length)
         {
            GF.removeAllChild(this.petIconMCArray[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.petStaticMCArray.length)
         {
            GF.removeAllChild(this.petStaticMCArray[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.petSkillIconMCArray.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.petSkillIconMCArray[_loc1_].length)
            {
               GF.removeAllChild(this.petSkillIconMCArray[_loc1_][_loc2_]);
               _loc2_++;
            }
            _loc1_++;
         }
         this.petIconMCArray = [];
         this.petSkillIconMCArray = [];
         this.petStaticMCArray = [];
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].iconMc.iconHolder);
            this.panelMC["item_" + _loc1_].gotoAndStop(1);
            this.panelMC["item_" + _loc1_].visible = false;
            this.panelMC["item_" + _loc1_].lockMc.visible = false;
            this.panelMC["item_" + _loc1_].emblemMC.visible = false;
            this.panelMC["item_" + _loc1_].amtTxt.visible = false;
            delete this.panelMC["item_" + _loc1_].tooltip;
            delete this.panelMC["item_" + _loc1_].tooltipCache;
            delete this.panelMC["item_" + _loc1_].item_type;
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_],MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_],MouseEvent.MOUSE_OUT,this.toolTiponOut);
            _loc1_++;
         }
      }
      
      private function resetRecursiveProperty() : void
      {
         this.itemLoading = this.currentPage * 9;
         if(this.petData.length < this.itemLoading)
         {
            this.itemLoading = this.petData.length;
         }
         this.itemIndex = (this.currentPage - 1) * 9;
         this.itemCount = 0;
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function stopEntrance() : void
      {
         this.stop();
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.handleVillageHUDVisibility(true);
         this.main.clearEvents();
         this.resetIconHolder();
         this.resetSelectedPetHolder();
         this.resetPreviewHolder();
         this.resetRecursiveProperty();
         this.eventHandler.removeAllEventListeners();
         this.loaderSwf.clear();
         this.tooltip.destroy();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.confirmation = null;
         this.tooltip = null;
         this.loaderSwf = null;
         this.main = null;
         this.petData = [];
         this.petDataOriginal = [];
         GF.removeAllChild(this);
      }
   }
}

