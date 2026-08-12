package Panels
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Popups.Confirmation;
   import Storage.AnimationLibrary;
   import Storage.Character;
   import Storage.Library;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class Animation_Shop extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var animationShopData:Object;
      
      private var selectedAnimData:Object;
      
      private var categoryData:Array;
      
      private var tabButtons:Array;
      
      private var currentTab:String;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var outfits:Array;
      
      private var response:Object;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      public function Animation_Shop(param1:*)
      {
         this.outfits = [];
         this.animationShopData = {
            "standby":AnimationLibrary.getCategory("standby"),
            "dodge":AnimationLibrary.getCategory("dodge"),
            "win":AnimationLibrary.getCategory("win"),
            "dead":AnimationLibrary.getCategory("dead")
         };
         this.tabButtons = ["standby","dodge","win","dead"];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.initUI();
      }
      
      private function initUI() : void
      {
         var _loc3_:OutfitManager = null;
         this.initTabButtons();
         this.panelMC["btn_" + this.tabButtons[0]].gotoAndStop(3);
         this.categoryData = this.animationShopData[this.tabButtons[0]];
         this.currentTab = this.tabButtons[0];
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.categoryData.length / 8),1);
         if(!Character.is_stickman)
         {
            _loc3_ = new OutfitManager();
            _loc3_.fillOutfit(this.panelMC.char_mc,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
            this.outfits.push(_loc3_);
         }
         var _loc1_:String = AnimationLibrary.getAnimation(Character.equipped_animations[this.currentTab]).label;
         var _loc2_:Object = Library.getItemInfo(Character.character_weapon);
         _loc1_ = _loc2_.anims && _loc2_.anims.hasOwnProperty("standby") && _loc2_.anims.standby != null ? AnimationLibrary.getAnimation(_loc2_.anims.standby).label : _loc1_;
         NinjaSage.addStandByFrameScript(this.panelMC.char_mc,_loc1_);
         this.panelMC.char_mc.gotoAndPlay(_loc1_);
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_getGold,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.btn_getToken,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.panelMC.txt_gold.text = Character.character_gold;
         this.panelMC.txt_token.text = Character.account_tokens;
         this.updatePageText();
         this.renderAnimationList();
      }
      
      private function renderAnimationList() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 8);
            this.panelMC["anim_" + _loc1_].visible = false;
            if(this.categoryData.length > _loc2_)
            {
               this.panelMC["anim_" + _loc1_].visible = true;
               this.panelMC["anim_" + _loc1_].emblemMC.visible = false;
               this.panelMC["anim_" + _loc1_].equippedTxt.visible = false;
               this.panelMC["anim_" + _loc1_].pose.gotoAndStop(this.categoryData[_loc2_].label);
               this.panelMC["anim_" + _loc1_].metaData = {"animation_data":this.categoryData[_loc2_]};
               this.eventHandler.addListener(this.panelMC["anim_" + _loc1_].clickmask,MouseEvent.CLICK,this.onPlayAnimation);
               NinjaSage.showDynamicTooltip(this.panelMC["anim_" + _loc1_].clickmask,this.categoryData[_loc2_].name);
               if(this.categoryData[_loc2_].premium)
               {
                  this.panelMC["anim_" + _loc1_].emblemMC.visible = true;
               }
               if(this.categoryData[_loc2_].price > 0 && this.categoryData[_loc2_].buyable && !this.hasAnimation(this.categoryData[_loc2_].id))
               {
                  this.panelMC["anim_" + _loc1_].btn_buy.visible = true;
                  this.panelMC["anim_" + _loc1_].btn_equip.visible = false;
                  this.panelMC["anim_" + _loc1_].overlay.visible = true;
                  this.main.initButton(this.panelMC["anim_" + _loc1_].btn_buy,this.buyConfirmation,this.categoryData[_loc2_].price);
               }
               else if(this.categoryData[_loc2_].price == 0 && !this.categoryData[_loc2_].buyable && !this.hasAnimation(this.categoryData[_loc2_].id))
               {
                  this.panelMC["anim_" + _loc1_].btn_buy.visible = false;
                  this.panelMC["anim_" + _loc1_].overlay.visible = true;
                  this.panelMC["anim_" + _loc1_].btn_equip.visible = false;
               }
               else
               {
                  this.panelMC["anim_" + _loc1_].btn_buy.visible = false;
                  this.panelMC["anim_" + _loc1_].overlay.visible = false;
                  if(this.hasAnimation(this.categoryData[_loc2_].id) && Character.equipped_animations[this.currentTab] == this.categoryData[_loc2_].id)
                  {
                     this.panelMC["anim_" + _loc1_].equippedTxt.visible = true;
                     this.panelMC["anim_" + _loc1_].btn_equip.visible = false;
                  }
                  else
                  {
                     this.panelMC["anim_" + _loc1_].btn_equip.visible = true;
                     this.panelMC["anim_" + _loc1_].equippedTxt.visible = false;
                     this.eventHandler.addListener(this.panelMC["anim_" + _loc1_].btn_equip,MouseEvent.CLICK,this.onEquipAnimation);
                  }
               }
            }
            _loc1_++;
         }
      }
      
      private function onPlayAnimation(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = param1.currentTarget.parent.metaData.animation_data;
         if(_loc2_.hasOwnProperty("loop") && _loc2_.loop)
         {
            NinjaSage.addStandByFrameScript(this.panelMC.char_mc,_loc2_.label);
         }
         else
         {
            _loc3_ = NinjaSage.getLabelFrames(this.panelMC.char_mc,_loc2_.label);
            this.panelMC.char_mc.addFrameScript(_loc3_.end - 1,this.stopAnimation);
         }
         this.panelMC.char_mc.gotoAndPlay(_loc2_.label);
      }
      
      private function stopAnimation() : void
      {
         this.panelMC.char_mc.stop();
      }
      
      private function buyConfirmation(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.selectedAnimData = e.currentTarget.parent.metaData.animation_data;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to buy " + this.selectedAnimData.name + " animation for " + this.selectedAnimData.price + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            GF.removeAllChild(confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onBuyAnimation);
         this.panelMC.addChild(this.confirmation);
      }
      
      private function onBuyAnimation(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         if(Character.account_type == 0 && this.selectedAnimData.premium)
         {
            this.openRecharge(param1);
            return;
         }
         if(Character.account_tokens < this.selectedAnimData.price)
         {
            this.main.showMessage("You don\'t have enough tokens to buy this animation");
            return;
         }
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.u7Ove1qc4jAm",[Character.char_id,Character.sessionkey,this.selectedAnimData.id],this.buyResponse);
      }
      
      private function buyResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.character_animations += "," + this.selectedAnimData.id;
            Character.account_tokens -= this.selectedAnimData.price;
            this.panelMC.txt_gold.text = Character.character_gold;
            this.panelMC.txt_token.text = Character.account_tokens;
            this.main.HUD.setBasicData();
            this.renderAnimationList();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function onEquipAnimation(param1:MouseEvent) : void
      {
         this.selectedAnimData = param1.currentTarget.parent.metaData.animation_data;
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.NyvqxXkhGuuY",[Character.char_id,Character.sessionkey,this.selectedAnimData.id],this.equipResponse);
      }
      
      private function equipResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.equipped_animations[this.currentTab] = this.selectedAnimData.id;
            this.renderAnimationList();
         }
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function hasAnimation(param1:String) : Boolean
      {
         return Character.character_animations.indexOf(param1) != -1;
      }
      
      private function updatePageText() : void
      {
         this.panelMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.renderAnimationList();
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.renderAnimationList();
               }
         }
         this.updatePageText();
      }
      
      private function initTabButtons() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.tabButtons.length)
         {
            this.panelMC["btn_" + this.tabButtons[_loc1_]].gotoAndStop(1);
            NinjaSage.showDynamicTooltip(this.panelMC["btn_" + this.tabButtons[_loc1_]],NinjaSage.capitalizeFirstLetter(this.tabButtons[_loc1_]));
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabButtons[_loc1_]],MouseEvent.MOUSE_OVER,this.onTabButtonOver);
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabButtons[_loc1_]],MouseEvent.MOUSE_OUT,this.onTabButtonOut);
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabButtons[_loc1_]],MouseEvent.CLICK,this.onTabButtonClick);
            _loc1_++;
         }
      }
      
      private function onTabButtonOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame != 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function onTabButtonOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame != 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function onTabButtonClick(param1:MouseEvent) : void
      {
         this.initTabButtons();
         param1.currentTarget.gotoAndStop(3);
         this.currentTab = param1.currentTarget.name.replace("btn_","");
         this.categoryData = this.animationShopData[this.currentTab];
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.categoryData.length / 8),1);
         this.renderAnimationList();
         this.updatePageText();
      }
      
      private function openRecharge(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "btn_getGold")
         {
            this.main.loadExternalSwfPanel("Headquarter","Headquarter");
         }
         else
         {
            this.main.loadPanel("Panels.Recharge");
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
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         GF.destroyArray(this.outfits);
         this.outfits = [];
         this.animationShopData = null;
         this.categoryData = null;
         this.tabButtons = null;
         this.currentTab = null;
         this.currentPage = 0;
         this.totalPage = 0;
         this.confirmation = null;
         this.selectedAnimData = null;
         this.main = null;
         GF.removeAllChild(this.panelMC.char_mc);
         GF.removeAllChild(this);
         this.panelMC = null;
      }
   }
}
