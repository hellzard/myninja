package Panels
{
   import Storage.Character;
   import Storage.GameData;
   import Storage.PetInfo;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class TailedBeast extends MovieClip
   {
       
      
      public var btn_buy:SimpleButton;
      
      public var item_5:MovieClip;
      
      public var item_6:MovieClip;
      
      public var item_7:MovieClip;
      
      public var item_8:MovieClip;
      
      public var item_9:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var item_0:MovieClip;
      
      public var item_1:MovieClip;
      
      public var item_2:MovieClip;
      
      public var item_3:MovieClip;
      
      public var item_4:MovieClip;
      
      public var pet_mc:MovieClip;
      
      public var priceMC:MovieClip;
      
      public var pet_name:TextField;
      
      public var pet_desc:TextField;
      
      public var pet_gendesc:TextField;
      
      public var btn_close:SimpleButton;
      
      public var btn_petshop:SimpleButton;
      
      public var btn_recharge:SimpleButton;
      
      public var skill_1:MovieClip;
      
      public var skill_2:MovieClip;
      
      public var skill_3:MovieClip;
      
      public var skill_4:MovieClip;
      
      public var skill_5:MovieClip;
      
      public var skill_6:MovieClip;
      
      public var main;
      
      public var tooltip:ToolTip;
      
      public var curr_page:int = 1;
      
      public var pets:Array;
      
      public var pets_cost:Array;
      
      public var pet_mcs:Array;
      
      public var pet_icons:Array;
      
      public var pet_info:Array;
      
      public var pet_skills_mcs:Array;
      
      public var array_info_holder:Array;
      
      public var selected_pet_index:int = -1;
      
      public var selected_pet_slot_index:int = -1;
      
      public var display_pet_number:int = 0;
      
      private var confirmation;
      
      private var self:TailedBeast;
      
      private var eventHandler;
      
      private var loaderSwf:BulkLoader;
      
      public function TailedBeast(param1:*)
      {
         var _loc2_:* = GameData.get("tailed_beast");
         this.pets = [];
         this.pets_cost = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.pets.length)
         {
            this.pets.push(_loc2_.pets[_loc3_].id);
            this.pets_cost.push(_loc2_.pets[_loc3_].price);
            _loc3_++;
         }
         this.pet_mcs = [];
         this.pet_info = [];
         this.pet_skills_mcs = [];
         this.array_info_holder = [];
         this.pet_icons = [];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.loaderSwf = BulkLoader.getLoader("assets");
         this.main.handleVillageHUDVisibility(false);
         this.main.loading(true);
         this.self = this;
         this.init();
      }
      
      public function init() : *
      {
         this.tooltip = ToolTip.getInstance();
         this.display_pet_number = 0;
         this.curr_page = 1;
         this.setupButtons();
         this.setupSlots();
         this.setupSkills();
         this.displayPets();
      }
      
      public function displayPets(param1:* = 0) : *
      {
         var pet_swf:* = undefined;
         var holder:* = undefined;
         var loadItem:* = undefined;
         var startIndex:* = param1;
         pet_swf = undefined;
         holder = undefined;
         var loader:Loader = null;
         var display_pet_nr:* = startIndex;
         if(display_pet_nr == 0)
         {
            this.pet_mcs = [];
            this.pet_info = [];
            this.pet_icons = [];
            this.pet_skills_mcs = [];
            this.array_info_holder = [];
         }
         var cp:* = display_pet_nr + (int(this.curr_page) - 1) * 10;
         if(this.pets.length > cp)
         {
            pet_swf = this.pets[cp];
            holder = this["item_" + cp];
            this.crframe = 0;
            addEventListener(Event.ENTER_FRAME,this.checkLoading);
            loadItem = this.loaderSwf.add("pets/" + pet_swf + ".swf");
            loadItem.addEventListener(BulkLoader.COMPLETE,function(param1:Event):*
            {
               petLoaded(param1,pet_swf,holder);
            });
            this.loaderSwf.start();
         }
         else
         {
            this.onSelectPet(0);
            this.main.loading(false);
         }
      }
      
      public function checkLoading(param1:Event) : *
      {
         ++this.crframe;
         if(this.crframe > 5)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkLoading);
            this.displayPets(this.display_pet_number);
         }
      }
      
      public function petLoaded(param1:*, param2:*, param3:*) : void
      {
         var pskills:Array = null;
         var c_array_info_holder:Array = null;
         var event:* = param1;
         var petSwf:* = param2;
         var holder:* = param3;
         pskills = null;
         var csk_mc:* = undefined;
         c_array_info_holder = null;
         var info:* = undefined;
         var e:* = event;
         var pet_swf:* = petSwf;
         removeEventListener(Event.ENTER_FRAME,this.checkLoading);
         var butn:* = e.target.content["PetStaticFullBody"];
         butn.scaleX = 1.8;
         butn.scaleY = 1.8;
         var head:* = e.target.content["icon"];
         this.pet_icons.push(head);
         holder.visible = true;
         this.pet_mcs.push(butn);
         var pet_infos:* = PetInfo.getPetStats(pet_swf);
         this.pet_info.push(pet_infos);
         pskills = [];
         c_array_info_holder = [];
         info = PetInfo.getPetStats(pet_swf);
         var s:* = 0;
         for(; s < 6; s++)
         {
            try
            {
               csk_mc = e.target.content["Skill_" + s];
               if(info)
               {
                  pskills.push(csk_mc);
                  c_array_info_holder.push([info.attacks[s].name,info.attacks[s].level,info.attacks[s].description,info.attacks[s].cooldown]);
               }
               else
               {
                  pskills.push(null);
                  c_array_info_holder.push([null,null,null]);
               }
            }
            catch(e:*)
            {
               pskills.push(null);
               c_array_info_holder.push([null,null,null]);
               continue;
            }
         }
         if(e.target.content[pet_swf])
         {
            e.target.content[pet_swf].gotoAndStop(1);
         }
         this.array_info_holder.push(c_array_info_holder);
         this.pet_skills_mcs.push(pskills);
         ++this.display_pet_number;
         this.displayPets(this.display_pet_number);
      }
      
      function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      function openPetShop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.PetShop");
      }
      
      public function setupSlots(param1:Boolean = true) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 10)
         {
            if(param1)
            {
               this.eventHandler.addListener(this["item_" + _loc2_],MouseEvent.CLICK,this.onSelectPet);
            }
            _loc2_++;
         }
      }
      
      public function onSelectPet(param1:* = null) : *
      {
         var _loc3_:* = undefined;
         if(this.selected_pet_slot_index != -1)
         {
            this["item_" + this.selected_pet_slot_index];
         }
         if(param1 is MouseEvent)
         {
            this.selected_pet_slot_index = int(param1.currentTarget.name.replace("item_",""));
         }
         else
         {
            this.selected_pet_slot_index = param1;
         }
         this.selected_pet_index = this.selected_pet_slot_index;
         this.pet_name.text = this.pet_info[this.selected_pet_index].pet_name;
         this.pet_desc.text = this.pet_info[this.selected_pet_index].description;
         this.pet_gendesc.text = "The Legendary Pet - " + this.pet_info[this.selected_pet_index].pet_name + " Has Been Unleashed in the Fire Village!\nGet " + this.pet_info[this.selected_pet_index].pet_name + " Now and Unleash Its Full Power!";
         if(this.pet_info[this.selected_pet_index].pet_name == "Slebew")
         {
            this.btn_buy.visible = false;
            this.priceMC.visible = false;
            this.btn_recharge.visible = true;
            this.eventHandler.addListener(this.btn_recharge,MouseEvent.CLICK,this.openRecharge);
         }
         else if(this.pet_info[this.selected_pet_index].pet_name == "Jyubi")
         {
            this.btn_buy.visible = false;
            this.priceMC.visible = false;
            this.btn_recharge.visible = false;
         }
         else
         {
            this.btn_buy.visible = true;
            this.priceMC.visible = true;
         }
         if(this.pet_mc.numChildren > 0)
         {
            this.pet_mc.removeChildAt(0);
         }
         this.pet_mc.addChild(this.pet_mcs[this.selected_pet_index]);
         var _loc2_:* = 1;
         while(_loc2_ < 7)
         {
            this["skill_" + _loc2_].gotoAndStop(1);
            if(this["skill_" + _loc2_].numChildren == 6)
            {
               this["skill_" + _loc2_].removeChildAt(5);
            }
            if(this.pet_skills_mcs[this.selected_pet_index][_loc2_ - 1] != null)
            {
               this["skill_" + _loc2_].addChild(this.pet_skills_mcs[this.selected_pet_index][_loc2_ - 1]);
            }
            _loc2_++;
         }
         if((_loc3_ = this.pets_cost[this.selected_pet_index]).indexOf("token_") >= 0)
         {
            this.priceMC.gotoAndStop(2);
            this.priceMC.txt_token.text = _loc3_.split("_")[1];
         }
         else
         {
            this.priceMC.gotoAndStop(1);
            this.priceMC.txt_gold.text = _loc3_.split("_")[1];
         }
      }
      
      public function setupSkills() : *
      {
         var _loc1_:* = 1;
         while(_loc1_ < 7)
         {
            this["skill_" + _loc1_].gotoAndStop(1);
            if(this["skill_" + _loc1_].numChildren == 6)
            {
               this["skill_" + _loc1_].removeChildAt(5);
            }
            this.eventHandler.addListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OUT,this.onOutPetSkill,false,0,true);
            this.eventHandler.addListener(this["skill_" + _loc1_],MouseEvent.MOUSE_OVER,this.onOverPetSkill,false,0,true);
            _loc1_++;
         }
      }
      
      public function onOverPetSkill(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = int(param1.currentTarget.name.replace("skill_","")) - 1;
         if(this.array_info_holder.length > this.selected_pet_index && this.array_info_holder[this.selected_pet_index].length > _loc3_ && this.array_info_holder[this.selected_pet_index][_loc3_][0] != null)
         {
            _loc2_ = "" + this.array_info_holder[this.selected_pet_index][_loc3_][0] + "\n(Skill)\n" + "\nLevel: " + this.array_info_holder[this.selected_pet_index][_loc3_][1] + "\nCooldown:" + this.array_info_holder[this.selected_pet_index][_loc3_][3] + "\n\n" + this.array_info_holder[this.selected_pet_index][_loc3_][2];
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_loc2_);
         }
      }
      
      public function onOutPetSkill(param1:MouseEvent) : *
      {
         this.tooltip.hide();
      }
      
      public function setupButtons() : *
      {
         this.btn_recharge.visible = false;
         this.eventHandler.addListener(this.btn_buy,MouseEvent.CLICK,this.buyConfirmation);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
      }
      
      public function onClosePop(param1:MouseEvent) : *
      {
         if(this.popup != null)
         {
            this.popup.visible = false;
            this.popup = false;
         }
      }
      
      protected function buyConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = getDefinitionByName("Popups.Confirmation") as Class;
         this.confirmation = new this.confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to buy " + this.pet_info[this.selected_pet_index].pet_name + "?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            removeChild(self.confirmation);
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onBuyAMF);
         addChild(this.confirmation);
      }
      
      public function onBuyAMF(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.loading(true);
         var _loc2_:Array = [Character.char_id,Character.sessionkey,this.pets[this.selected_pet_index]];
         this.main.amf_manager.service("q590e8VkpCrGuhvF.iq3iNpv1nycS",["iMIeU5KsJgkI",_loc2_],this.onBuyAMFResponse);
      }
      
      public function onBuyAMFResponse(param1:Object) : *
      {
         var _loc2_:* = undefined;
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this.main.getNotice(param1.result);
               return;
            }
            this.main.giveReward(1,this.pets[this.selected_pet_index]);
            if((_loc2_ = this.pets_cost[this.selected_pet_index]).indexOf("token_") >= 0)
            {
               Character.account_tokens -= int(_loc2_.split("_")[1]);
            }
            else
            {
               Character.character_gold = String(Number(Character.character_gold) - int(_loc2_.split("_")[1]));
            }
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function closePanel(param1:MouseEvent = null) : *
      {
         this.main.handleVillageHUDVisibility(true);
         this.main.HUD.setBasicData();
         this.tooltip.destroy();
         this.eventHandler.removeAllEventListeners();
         this.loaderSwf.removeAll();
         this.pets = [];
         this.pets_cost = [];
         this.eventHandler = null;
         this.tooltip = null;
         this.main = null;
         this.loaderSwf = null;
         this.self = null;
         GF.removeAllChild(this);
         System.gc();
      }
   }
}
