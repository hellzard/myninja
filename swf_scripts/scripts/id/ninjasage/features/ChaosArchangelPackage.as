package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.PreviewManager;
   import Storage.AnimationLibrary;
   import Storage.Character;
   import Storage.Library;
   import Storage.PetInfo;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ChaosArchangelPackage extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var previewMC:PreviewManager;
      
      private var loaderSwf:BulkLoader;
      
      private var item_hair:String;
      
      private var item_set:String;
      
      private var item_back:String;
      
      private var item_wpn:String;
      
      private var item_acc:String;
      
      private var item_skill:Array;
      
      private var item_pet:String;
      
      private var item_animation:String;
      
      private var selectedSkill:String;
      
      private var selectedPet:String;
      
      private var selectedPackage:int = 0;
      
      private var currentSet:int = 0;
      
      private var outfits:Array = [];
      
      private var gender:int = Character.character_gender;
      
      private var packageData:Array = [];
      
      private var petInfo:Object;
      
      private const tabButton:Array = ["mcHairstyle","mcSet","mcBackItem","mcWeapon","mcAccessory","mcPet","mcAnimation"];
      
      private const skillButton:Array = ["mcSkill0","mcSkill1","mcSkill2"];
      
      private const packageTitle:String = "Chaos Archangel Package";
      
      private var rewardPane:RewardScrollPane;
      
      private var previewAnimType:String;
      
      private var isOutfitFileld:Boolean = false;
      
      public function ChaosArchangelPackage(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.panelMC.previewIdle,this.closePreviewAnimation);
         this.escapeKey.addListener(this.panelMC.panelMC.previewSkill,this.closePreview);
         this.escapeKey.addListener(this.panelMC.panelMC.previewPet,this.closePreview);
         this.eventHandler = new EventHandler();
         this.rewardPane = new RewardScrollPane();
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
         this.setRewardData();
         this.initUI();
      }
      
      private function setRewardData() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         this.packageData = [];
         var _loc1_:Object = this.getPackageData().content;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            this.packageData.push({
               "packageName":_loc3_.name,
               "packagePrice":_loc3_.price,
               "packageReward":[],
               "packageOutfit":{
                  "package_hair":[],
                  "package_set":[],
                  "package_back":_loc3_.outfits.back,
                  "package_weapon":_loc3_.outfits.weapon,
                  "package_pet":_loc3_.outfits.pet,
                  "package_accessory":_loc3_.outfits.accessory,
                  "package_skill":_loc3_.outfits.skill,
                  "package_animation":_loc3_.outfits.ani
               }
            });
            _loc4_ = 0;
            while(_loc4_ < _loc3_.outfits.hair.length)
            {
               this.packageData[_loc2_].packageOutfit.package_hair.push(_loc3_.outfits.hair[_loc4_].replace("%s",this.gender));
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.outfits.set.length)
            {
               this.packageData[_loc2_].packageOutfit.package_set.push(_loc3_.outfits.set[_loc4_].replace("%s",this.gender));
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.rewards.length)
            {
               this.packageData[_loc2_].packageReward.push(_loc3_.rewards[_loc4_].replace("%s",this.gender));
               _loc4_++;
            }
            _loc2_++;
         }
      }
      
      private function initUI() : void
      {
         var _loc2_:String = null;
         this.main.handleVillageHUDVisibility(false);
         this.panelMC.panelMC.pet_mc.x += 60;
         this.panelMC.panelMC.pet_mc.y += 70;
         this.panelMC.panelMC.genderChange.gotoAndStop(Character.character_gender + 1);
         this.panelMC.panelMC.genderChange.buttonMode = true;
         this.panelMC.panelMC.previewSkill.visible = false;
         this.panelMC.panelMC.previewPet.visible = false;
         this.panelMC.panelMC.previewIdle.visible = false;
         this.panelMC.panelMC.previewIdle.char_mc.gotoAndStop(1);
         this.panelMC.panelMC.txt_eventDate.text = this.getPackageData().date;
         this.panelMC.panelMC.scrollPaneHolder.addChild(this.rewardPane.getRewardPane());
         this.eventHandler.addListener(this.panelMC.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.panelMC.btn_set_0,MouseEvent.CLICK,this.selectSetNumber);
         this.eventHandler.addListener(this.panelMC.panelMC.btn_set_1,MouseEvent.CLICK,this.selectSetNumber);
         this.eventHandler.addListener(this.panelMC.panelMC.btn_set_2,MouseEvent.CLICK,this.selectSetNumber);
         this.eventHandler.addListener(this.panelMC.panelMC.genderChange,MouseEvent.CLICK,this.handleChangeGender);
         var _loc1_:int = 0;
         while(_loc1_ < this.packageData.length)
         {
            this.panelMC.panelMC["item_" + _loc1_].highlight.visible = false;
            this.panelMC.panelMC["item_" + _loc1_].iconMc.gotoAndStop(_loc1_ + 1);
            this.panelMC.panelMC["item_" + _loc1_].txt_packageName.text = this.packageData[_loc1_].packageName;
            _loc2_ = this.main.isPaymentSupported() ? this.main.payment.getProductData("id.ninjasage.chaosarchangel." + (_loc1_ + 1)).priceString : this.packageData[_loc1_].packagePrice;
            this.panelMC.panelMC["item_" + _loc1_].txt_packagePrice.text = _loc2_;
            this.panelMC.panelMC["item_" + _loc1_].buttonMode = true;
            this.eventHandler.addListener(this.panelMC.panelMC["item_" + _loc1_],MouseEvent.CLICK,this.selectPackage);
            _loc1_++;
         }
         this.panelMC.panelMC["item_" + this.selectedPackage].highlight.visible = true;
         this.panelMC.panelMC.txt_title.text = this.getPackageData().name;
         this.panelMC.panelMC.txt_packageName.text = this.packageData[this.selectedPackage].packageName;
         this.updateRewardPane();
         this.selectPackage();
         this.loadIconPreview();
         this.initTooltipRightSide();
      }
      
      private function handleChangeGender(param1:MouseEvent) : void
      {
         this.gender = this.gender == 1 ? 0 : 1;
         this.panelMC.panelMC.genderChange.gotoAndStop(this.gender + 1);
         this.setRewardData();
         this.setUsedOutfit();
         this.loadIconPreview();
         this.updateRewardPane();
      }
      
      private function selectSetNumber(param1:MouseEvent) : void
      {
         this.currentSet = param1.currentTarget.name.replace("btn_set_","");
         this.setUsedOutfit();
         this.loadIconPreview();
      }
      
      private function selectPackage(param1:MouseEvent = null) : void
      {
         this.selectedPackage = param1 ? int(param1.currentTarget.name.replace("item_","")) : 0;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            this.panelMC.panelMC["btn_set_" + _loc2_].visible = false;
            if(this.packageData[this.selectedPackage].packageOutfit.package_hair[_loc2_])
            {
               this.panelMC.panelMC["btn_set_" + _loc2_].visible = true;
            }
            if(this.packageData[this.selectedPackage].packageOutfit.package_set[_loc2_])
            {
               this.panelMC.panelMC["btn_set_" + _loc2_].visible = true;
            }
            if(this.packageData[this.selectedPackage].packageOutfit.package_weapon[_loc2_])
            {
               this.panelMC.panelMC["btn_set_" + _loc2_].visible = true;
            }
            if(this.packageData[this.selectedPackage].packageOutfit.package_back[_loc2_])
            {
               this.panelMC.panelMC["btn_set_" + _loc2_].visible = true;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.packageData.length)
         {
            this.panelMC.panelMC["item_" + _loc2_].highlight.visible = false;
            _loc2_++;
         }
         this.panelMC.panelMC["item_" + this.selectedPackage].highlight.visible = true;
         this.panelMC.panelMC.txt_packageName.text = this.packageData[this.selectedPackage].packageName;
         this.panelMC.panelMC.btn_buy.metaData = {"packageId":"id.ninjasage.chaosarchangel." + (this.selectedPackage + 1)};
         this.main.initButton(this.panelMC.panelMC.btn_buy,this.buyPack,this.main.isPaymentSupported() ? this.main.payment.getProductData("id.ninjasage.chaosarchangel." + (this.selectedPackage + 1)).priceString : "Merchant");
         this.updateRewardPane();
         this.setUsedOutfit();
         this.loadIconPreview();
      }
      
      private function updateRewardPane() : void
      {
         this.rewardPane.updateRewardPane({
            "rewards":this.packageData[this.selectedPackage].packageReward,
            "item_per_line":2,
            "width":null,
            "height":515,
            "x":105,
            "y":125,
            "scroll_direction":"vertical"
         });
      }
      
      private function loadIconPreview() : void
      {
         this.resetIconMc();
         var _loc1_:OutfitManager = new OutfitManager();
         if(this.item_wpn == null)
         {
            GF.removeAllChild(this.panelMC.panelMC.char_mc.weapon);
         }
         GF.removeAllChild(this.panelMC.panelMC.char_mc.back_hair);
         _loc1_.fillOutfit(this.panelMC.panelMC.char_mc,this.item_wpn,this.item_back,this.item_set,this.item_hair,"face_01_" + this.gender,"null|null","null|null");
         this.outfits.push(_loc1_);
         var _loc2_:Array = [this.item_hair,this.item_set,this.item_back,this.item_wpn,this.item_acc];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] != null)
            {
               this.panelMC.panelMC[this.tabButton[_loc3_]].visible = true;
               NinjaSage.loadItemIcon(this.panelMC.panelMC[this.tabButton[_loc3_]],_loc2_[_loc3_]);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.item_skill.length)
         {
            if(this.item_skill[_loc3_] != null)
            {
               this.panelMC.panelMC[this.skillButton[_loc3_]].visible = true;
               NinjaSage.loadItemIcon(this.panelMC.panelMC[this.skillButton[_loc3_]],this.item_skill[_loc3_]);
               this.eventHandler.addListener(this.panelMC.panelMC[this.skillButton[_loc3_]],MouseEvent.CLICK,this.handlePreview);
            }
            _loc3_++;
         }
         if(this.item_pet != null)
         {
            if(this.item_pet == null)
            {
               return;
            }
            this.panelMC.panelMC.mcPet.visible = true;
            NinjaSage.loadItemIcon(this.panelMC.panelMC.mcPet,this.item_pet);
            this.panelMC.panelMC.pet_mc.scaleX = 1.2;
            this.panelMC.panelMC.pet_mc.scaleY = 1.2;
            NinjaSage.loadIconSWF("pets",this.item_pet,this.panelMC.panelMC.pet_mc,this.item_pet);
            this.eventHandler.addListener(this.panelMC.panelMC.mcPet,MouseEvent.CLICK,this.handlePreview);
         }
         if(this.item_animation != null)
         {
            this.panelMC.panelMC.mcAnimation.visible = true;
            NinjaSage.loadItemIcon(this.panelMC.panelMC.mcAnimation,this.item_animation);
            this.eventHandler.addListener(this.panelMC.panelMC.mcAnimation,MouseEvent.CLICK,this.previewAnimation);
         }
         this.panelMC.panelMC.mcBasicAtk.visible = false;
         this.eventHandler.addListener(this.panelMC.panelMC.mcBasicAtk,MouseEvent.CLICK,this.previewAnimation);
         NinjaSage.showDynamicTooltip(this.panelMC.panelMC.mcBasicAtk,"Exclusive Weapon Basic Attack & Standby");
      }
      
      private function resetIconMc() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.tabButton.length)
         {
            GF.removeAllChild(this.panelMC.panelMC[this.tabButton[_loc1_]].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC[this.tabButton[_loc1_]].skillIcon.iconHolder);
            this.panelMC.panelMC[this.tabButton[_loc1_]].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.skillButton.length)
         {
            GF.removeAllChild(this.panelMC.panelMC[this.skillButton[_loc1_]].rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.panelMC[this.skillButton[_loc1_]].skillIcon.iconHolder);
            this.panelMC.panelMC[this.skillButton[_loc1_]].visible = false;
            this.eventHandler.removeListener(this.panelMC.panelMC[this.skillButton[_loc1_]],MouseEvent.CLICK,this.handlePreview);
            _loc1_++;
         }
         GF.removeAllChild(this.panelMC.panelMC.pet_mc);
         this.eventHandler.removeListener(this.panelMC.panelMC.mcPet,MouseEvent.CLICK,this.handlePreview);
      }
      
      private function setUsedOutfit() : void
      {
         var _loc1_:int = this.packageData[this.selectedPackage].packageOutfit.package_hair.length > 1 ? this.currentSet : 0;
         var _loc2_:int = this.packageData[this.selectedPackage].packageOutfit.package_set.length > 1 ? this.currentSet : 0;
         var _loc3_:int = this.packageData[this.selectedPackage].packageOutfit.package_back.length > 1 ? this.currentSet : 0;
         var _loc4_:int = this.packageData[this.selectedPackage].packageOutfit.package_weapon.length > 1 ? this.currentSet : 0;
         var _loc5_:int = this.packageData[this.selectedPackage].packageOutfit.package_accessory.length > 1 ? this.currentSet : 0;
         var _loc6_:int = this.packageData[this.selectedPackage].packageOutfit.package_pet.length > 1 ? this.currentSet : 0;
         var _loc7_:int = this.packageData[this.selectedPackage].packageOutfit.package_animation.length > 1 ? this.currentSet : 0;
         this.item_hair = this.packageData[this.selectedPackage].packageOutfit.package_hair[_loc1_];
         this.item_set = this.packageData[this.selectedPackage].packageOutfit.package_set[_loc2_];
         this.item_back = this.packageData[this.selectedPackage].packageOutfit.package_back[_loc3_];
         this.item_wpn = this.packageData[this.selectedPackage].packageOutfit.package_weapon[_loc4_];
         this.item_acc = this.packageData[this.selectedPackage].packageOutfit.package_accessory[_loc5_];
         this.item_pet = this.packageData[this.selectedPackage].packageOutfit.package_pet[_loc6_];
         this.item_skill = this.packageData[this.selectedPackage].packageOutfit.package_skill;
         this.item_animation = this.packageData[this.selectedPackage].packageOutfit.package_animation[_loc7_];
      }
      
      private function initTooltipRightSide() : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.packageData.length)
         {
            _loc2_ = [];
            _loc3_ = {};
            _loc4_ = 0;
            while(_loc4_ < this.packageData[_loc1_].packageReward.length)
            {
               _loc6_ = this.packageData[_loc1_].packageReward[_loc4_];
               _loc7_ = _loc6_.split("_")[0];
               if(_loc7_ == "skill")
               {
                  _loc3_ = SkillLibrary.getSkillInfo(_loc6_);
                  _loc2_.push(_loc3_.skill_name);
               }
               else if(_loc7_ == "pet")
               {
                  _loc3_ = PetInfo.getPetStats(_loc6_);
                  _loc2_.push(_loc3_.pet_name);
               }
               else if(_loc7_ == "tokens")
               {
                  _loc3_ = _loc6_.split("_")[1] + " Tokens";
                  _loc2_.push(_loc3_);
               }
               else if(_loc7_ == "emblem")
               {
                  _loc3_ = "Permanent Emblem";
                  _loc2_.push(_loc3_);
               }
               else
               {
                  _loc3_ = Library.getItemInfo(_loc6_);
                  _loc2_.push(_loc3_.item_name);
               }
               _loc4_++;
            }
            _loc5_ = this.packageData[_loc1_].packageName + "\n\nThis package contains these following items: \n\n";
            NinjaSage.showDynamicTooltip(this.panelMC.panelMC["item_" + _loc1_].iconMc,_loc5_ + _loc2_.join("\n"));
            _loc1_++;
         }
      }
      
      private function previewAnimation(param1:MouseEvent) : void
      {
         this.previewAnimType = param1.currentTarget.name;
         this.panelMC.panelMC.previewIdle.visible = true;
         var _loc2_:OutfitManager = new OutfitManager();
         _loc2_.fillOutfit(this.panelMC.panelMC.previewIdle.char_mc,this.item_wpn,this.item_back,this.item_set,this.item_hair,"face_01_" + this.gender,"null|null","null|null");
         this.outfits.push(_loc2_);
         this.main.initButton(this.panelMC.panelMC.previewIdle.standbyBtn,this.playAnimation,"Standby");
         this.main.initButton(this.panelMC.panelMC.previewIdle.attackBtn,this.playAnimation,"Attack");
         this.eventHandler.addListener(this.panelMC.panelMC.previewIdle.exitBtn,MouseEvent.CLICK,this.closePreviewAnimation);
         this.panelMC.panelMC.previewIdle.replayBtn.visible = false;
         this.playAnimationPreview();
      }
      
      private function playAnimationPreview(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(this.previewAnimType == "mcAnimation")
         {
            NinjaSage.addStandByFrameScript(this.panelMC.panelMC.previewIdle.char_mc,AnimationLibrary.getAnimation(this.item_animation).label);
            this.panelMC.panelMC.previewIdle.char_mc.gotoAndPlay(AnimationLibrary.getAnimation(this.item_animation).label);
         }
         else
         {
            _loc2_ = Library.getItemInfo(this.item_wpn);
            _loc3_ = _loc2_.anims != null && Boolean(_loc2_.anims.hasOwnProperty("standby")) ? AnimationLibrary.getAnimation(_loc2_.anims.standby).label : "standby";
            _loc4_ = NinjaSage.getLabelFrames(this.panelMC.panelMC.previewIdle.char_mc,_loc2_.attack_type);
            _loc5_ = NinjaSage.getLabelFrames(this.panelMC.panelMC.previewIdle.char_mc,_loc3_);
            this.panelMC.panelMC.previewIdle.char_mc.addFrameScript(_loc4_.end - 1,this.gotoStandby);
            this.panelMC.panelMC.previewIdle.char_mc.addFrameScript(_loc5_.end - 1,this.gotoStandby);
            this.panelMC.panelMC.previewIdle.char_mc.gotoAndPlay(_loc3_);
         }
      }
      
      public function gotoStandby() : void
      {
         var _loc1_:Object = Library.getItemInfo(this.item_wpn);
         var _loc2_:String = _loc1_.anims != null && Boolean(_loc1_.anims.hasOwnProperty("standby")) ? AnimationLibrary.getAnimation(_loc1_.anims.standby).label : "standby";
         this.panelMC.panelMC.previewIdle.char_mc.gotoAndPlay(_loc2_);
      }
      
      private function playAnimation(param1:MouseEvent) : void
      {
         var _loc2_:Object = Library.getItemInfo(this.item_wpn);
         var _loc3_:String = param1.currentTarget.name == "standbyBtn" ? (_loc2_.anims != null && Boolean(_loc2_.anims.hasOwnProperty("standby")) ? AnimationLibrary.getAnimation(_loc2_.anims.standby).label : "standby") : _loc2_.attack_type;
         this.panelMC.panelMC.previewIdle.char_mc.gotoAndPlay(_loc3_);
      }
      
      private function closePreviewAnimation(param1:MouseEvent) : void
      {
         this.panelMC.panelMC.previewIdle.visible = false;
         this.panelMC.panelMC.previewIdle.char_mc.gotoAndStop(1);
      }
      
      private function handlePreview(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "mcPet")
         {
            this.loadPetAndPreview(this.item_pet);
         }
         else
         {
            this.loadSkillAndPreview(this.item_skill[param1.currentTarget.name.replace("mcSkill","")]);
         }
      }
      
      private function loadSkillAndPreview(param1:String) : void
      {
         this.main.loading(true);
         this.resetPreviewHolder();
         this.selectedSkill = param1;
         var _loc2_:String = "skills/" + this.selectedSkill + ".swf";
         var _loc3_:* = this.loaderSwf.add(_loc2_);
         _loc3_.addEventListener(BulkLoader.COMPLETE,this.completePreviewSkill);
         this.loaderSwf.start();
      }
      
      public function completePreviewSkill(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = SkillLibrary.getSkillInfo(this.selectedSkill);
         var _loc4_:MovieClip = param1.target.content[this.selectedSkill];
         _loc4_.gotoAndStop(1);
         var _loc5_:Array = [this.item_wpn,this.item_back,this.item_set,this.item_hair,"face_01_" + this.gender,"null|null","null|null"];
         this.previewMC = new PreviewManager(this.main,_loc4_,_loc3_,_loc5_);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         this.main.loading(false);
         this.showPreviewSkill();
      }
      
      public function showPreviewSkill() : void
      {
         this.panelMC.panelMC.previewSkill.visible = true;
         this.panelMC.panelMC.previewSkill.skillMc.addChild(this.previewMC.preview_mc);
         this.previewMC.preview_mc.gotoAndPlay(2);
         this.eventHandler.addListener(this.panelMC.panelMC.previewSkill.exitBtn,MouseEvent.CLICK,this.closePreview);
         this.eventHandler.addListener(this.panelMC.panelMC.previewSkill.replayBtn,MouseEvent.CLICK,this.handleReplay);
      }
      
      public function handleReplay(param1:MouseEvent) : void
      {
         this.previewMC.preview_mc.gotoAndPlay(2);
      }
      
      public function loadPetAndPreview(param1:String) : void
      {
         this.main.loading(true);
         this.resetPreviewHolder();
         var _loc2_:String = "pets/" + param1 + ".swf";
         var _loc3_:* = this.loaderSwf.add(_loc2_);
         this.selectedPet = param1;
         _loc3_.addEventListener(BulkLoader.COMPLETE,this.onCompletePetLoaded);
         this.loaderSwf.start();
      }
      
      private function onCompletePetLoaded(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.petInfo = PetInfo.getPetStats(this.selectedPet);
         var _loc3_:MovieClip = param1.target.content[this.selectedPet];
         _loc3_.gotoAndStop(1);
         this.previewMC = new PreviewManager(this.main,_loc3_,this.petInfo);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         this.main.loading(false);
         this.showPreviewPet();
      }
      
      private function showPreviewPet() : void
      {
         this.panelMC.panelMC.previewPet.visible = true;
         this.panelMC.panelMC.previewPet.petMc.addChild(this.previewMC.preview_mc);
         this.panelMC.panelMC.previewPet.petMc.scaleX = 1.2;
         this.panelMC.panelMC.previewPet.petMc.scaleY = 1.2;
         this.previewMC.preview_mc.gotoAndPlay("standby");
         var _loc1_:int = this.previewMC.preview_mc.currentLabels.length - 4;
         var _loc2_:int = 1;
         while(_loc2_ <= _loc1_)
         {
            this.panelMC.panelMC.previewPet["attack_0" + _loc2_].visible = true;
            this.main.initButton(this.panelMC.panelMC.previewPet["attack_0" + _loc2_],this.playSkillAnimation,"Skill " + _loc2_);
            this.main.initButton(this.panelMC.panelMC.previewPet.dodge,this.playSkillAnimation,"Dodge");
            this.main.initButton(this.panelMC.panelMC.previewPet.hit,this.playSkillAnimation,"Hit");
            this.main.initButton(this.panelMC.panelMC.previewPet.dead,this.playSkillAnimation,"Dead");
            _loc2_++;
         }
         this.eventHandler.addListener(this.panelMC.panelMC.previewPet.exitBtn,MouseEvent.CLICK,this.closePreview);
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
         this.previewMC.preview_mc.gotoAndPlay(_loc2_);
      }
      
      private function closePreview(param1:MouseEvent) : void
      {
         this.resetPreviewHolder();
         this.panelMC.panelMC.previewSkill.visible = false;
         this.panelMC.panelMC.previewPet.visible = false;
      }
      
      private function resetPreviewHolder() : void
      {
         if(this.previewMC)
         {
            this.previewMC.destroy();
         }
         var _loc1_:int = 1;
         while(_loc1_ <= 6)
         {
            this.panelMC.panelMC.previewPet["attack_0" + _loc1_].visible = false;
            _loc1_++;
         }
         GF.removeAllChild(this.panelMC.panelMC.previewSkill.skillMc);
         GF.removeAllChild(this.panelMC.panelMC.previewPet.petMc);
         this.petInfo = null;
         this.previewMC = null;
      }
      
      private function buyPack(param1:MouseEvent) : void
      {
         if(this.main.isPaymentSupported())
         {
            this.main.payment.purchaseProduct(param1.currentTarget.metaData.packageId);
         }
         else
         {
            navigateToURL(new URLRequest("http://127.0.0.1:800/merchants"));
         }
      }
      
      private function getPackageData() : Object
      {
         var _loc1_:Object = Character.event_data.hasOwnProperty("packages") && Character.event_data.packages != null ? Character.event_data.packages : [];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].code == "chaosarchangel")
            {
               return _loc1_[_loc2_];
            }
            _loc2_++;
         }
         return null;
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
         this.main.handleVillageHUDVisibility(true);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.panelMC.panelMC["item_" + _loc1_].buttonMode = false;
            _loc1_++;
         }
         GF.destroyArray(this.outfits);
         this.resetIconMc();
         this.resetPreviewHolder();
         this.eventHandler.removeAllEventListeners();
         this.loaderSwf.clear();
         this.rewardPane.destroy();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         OutfitManager.clearStaticMc();
         this.packageData = [];
         this.rewardPane = null;
         this.petInfo = null;
         this.loaderSwf = null;
         this.main = null;
         this.eventHandler = null;
         this.previewMC = null;
         this.outfits = null;
         GF.removeAllChild(this.panelMC.panelMC.scrollPaneHolder);
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}

