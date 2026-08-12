package Panels
{
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.StatManager;
   import Storage.Character;
   import Storage.Library;
   import Storage.PetInfo;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class UI_Friend_Profile extends MovieClip
   {
      
      public static var check_talent:Boolean = false;
      
      public static var check_senjutsu:Boolean = false;
       
      
      public var bgSkill:MovieClip;
      
      public var btn_detail:SimpleButton;
      
      public var btn_rename:SimpleButton;
      
      public var clanLogoHolder:MovieClip;
      
      public var classMC:MovieClip;
      
      public var txt_accuracy:TextField;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var btn_unfriend:SimpleButton;
      
      public var btn_AddFriend:SimpleButton;
      
      public var char_mc:MovieClip;
      
      public var cpBar:MovieClip;
      
      public var element_1:MovieClip;
      
      public var element_2:MovieClip;
      
      public var element_3:MovieClip;
      
      public var emblemMC:MovieClip;
      
      public var hpBar:MovieClip;
      
      public var rankMC:MovieClip;
      
      public var talent_1:MovieClip;
      
      public var talent_2:MovieClip;
      
      public var talent_3:MovieClip;
      
      public var skill_1:MovieClip;
      
      public var skill_2:MovieClip;
      
      public var skill_3:MovieClip;
      
      public var skill_4:MovieClip;
      
      public var skill_5:MovieClip;
      
      public var skill_6:MovieClip;
      
      public var skill_7:MovieClip;
      
      public var skill_8:MovieClip;
      
      public var detailMC:MovieClip;
      
      public var txt_agility:TextField;
      
      public var txt_cp:TextField;
      
      public var txt_crit:TextField;
      
      public var txt_dodge:TextField;
      
      public var txt_earth:TextField;
      
      public var txt_fire:TextField;
      
      public var txt_free:TextField;
      
      public var txt_hp:TextField;
      
      public var txt_id:TextField;
      
      public var txt_lightning:TextField;
      
      public var txt_lvl:TextField;
      
      public var txt_name:TextField;
      
      public var txt_purify:TextField;
      
      public var txt_water:TextField;
      
      public var txt_wind:TextField;
      
      public var txt_xp:TextField;
      
      public var xpBar:MovieClip;
      
      public var profileTitle:TextField;
      
      public var main;
      
      public var char_id;
      
      private var clan;
      
      private var character;
      
      private var sets;
      
      private var pets;
      
      private var points;
      
      private var inventory;
      
      private var self:UI_Friend_Profile;
      
      private var tooltip:ToolTip;
      
      private var skillInformations:Array;
      
      private var confirmation;
      
      public var eventHandler;
      
      public var outfit_manager;
      
      public var is_sw:Boolean = false;
      
      private var destroyed = false;
      
      public function UI_Friend_Profile(param1:*, param2:String, param3:Boolean = false)
      {
         this.skillInformations = [];
         this.eventHandler = new EventHandler();
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.self = this;
         this.main = param1;
         this.is_sw = param3;
         this.outfit_manager = new OutfitManager();
         this.char_id = param2;
         this.tooltip = ToolTip.getInstance();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_detail,MouseEvent.CLICK,this.openDetail);
         this.detailMC.visible = false;
         this.btn_unfriend.visible = false;
         this.btn_AddFriend.visible = false;
         this.loadProfile();
      }
      
      public function loadProfile() : *
      {
         this.main.loading(true);
         try
         {
            this.main.amf_manager.service("36a62s4oZ7iYRJjd.iakN46g0GaJN",[Character.char_id,Character.sessionkey,this.char_id],this.friendProfileCallback);
         }
         catch(e:Error)
         {
            this.main.loading(false);
         }
      }
      
      public function friendProfileCallback(param1:Object) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.main.loading(false);
         if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
            return;
         }
         if(param1.status == 0)
         {
            this.main.getError(param1.error);
            return;
         }
         if(param1.clan != null)
         {
            if(param1.clan.banner != null)
            {
               _loc4_ = BulkLoader.getLoader("assets");
               this.clan = param1.clan;
               _loc4_.add(param1.clan.banner,{"id":"clanBanner"});
               _loc4_.addEventListener(BulkLoader.COMPLETE,this.onClanLogoLoaded);
               _loc4_.start();
               _loc4_ = null;
            }
            else
            {
               this.clanLogoHolder.visible = false;
            }
         }
         if(this.char_id != Character.char_id)
         {
            _loc5_ = param1.hasOwnProperty("friend") && param1.friend === true;
            this.btn_unfriend.visible = _loc5_;
            if(!_loc5_)
            {
               this.btn_AddFriend.visible = true;
               this.btn_AddFriend.x -= 150;
            }
            this.eventHandler.addListener(this.btn_unfriend,MouseEvent.CLICK,this.unfriendConfirmation);
            this.eventHandler.addListener(this.btn_AddFriend,MouseEvent.CLICK,this.sendFriendRequest);
         }
         var _loc2_:* = param1.character_data;
         if(_loc2_.character_class != null)
         {
            this.classMC.gotoAndStop(_loc2_.character_class);
         }
         else
         {
            this.classMC.gotoAndStop("classNull");
         }
         if(_loc2_.character_level < 60 && _loc2_.character_class == null && _loc2_.character_rank < 7)
         {
            this.classMC.visible = false;
         }
         this.classMC.changeClassBtn.visible = false;
         this.character = param1.character_data;
         this.sets = param1.character_sets;
         this.points = param1.character_points;
         this.inventory = param1.character_inventory;
         this.pets = param1.pet_data;
         this.profileTitle.text = _loc2_.character_name + "\'s Profile";
         this.txt_id.text = "ID  " + this.char_id;
         this.eventHandler.addListener(this.txt_id,MouseEvent.CLICK,this.onCopyText);
         this.txt_name.htmlText = Character.colorifyText(this.char_id,_loc2_.character_name,this.txt_name);
         this.eventHandler.addListener(this.txt_name,MouseEvent.CLICK,this.onCopyText);
         this.txt_lvl.text = "Lv. " + _loc2_.character_level;
         this.rankMC.gotoAndStop(_loc2_.character_rank);
         this.element_1.gotoAndStop(int(_loc2_.character_element_1) + 1);
         this.element_2.gotoAndStop(int(_loc2_.character_element_2) + 1);
         this.element_3.gotoAndStop(int(_loc2_.character_element_3) + 1);
         this.txt_wind.text = String(this.points.atrrib_wind);
         this.txt_fire.text = String(this.points.atrrib_fire);
         this.txt_lightning.text = String(this.points.atrrib_lightning);
         this.txt_water.text = String(this.points.atrrib_water);
         this.txt_earth.text = String(this.points.atrrib_earth);
         var _loc3_:* = new StatManager(this.main).calculate_xp(int(_loc2_.character_level));
         this.txt_hp.text = this.calculate_stats("hp") + " / " + this.calculate_stats("hp");
         this.txt_cp.text = this.calculate_stats("cp") + " / " + this.calculate_stats("cp");
         this.txt_agility.text = this.calculate_stats("agility");
         this.txt_crit.text = this.calculate_stats("critical") + "%";
         this.txt_dodge.text = this.calculate_stats("dodge") + "%";
         this.txt_purify.text = this.calculate_stats("purify") + "%";
         this.txt_accuracy.text = this.calculate_stats("accuracy") + "%";
         this.txt_xp.text = _loc2_.character_xp + " / " + _loc3_;
         this.xpBar.scaleX = Math.max(Math.min(Number(_loc2_.character_xp) / Number(_loc3_),1.71),0);
         this.emblemMC.gotoAndStop(int(param1.account_type) + 1);
         if(_loc2_.character_talent_1)
         {
            this.talent_1.gotoAndStop(_loc2_.character_talent_1);
         }
         else
         {
            this.talent_1.gotoAndStop(3);
         }
         if(_loc2_.character_talent_2)
         {
            this.talent_2.gotoAndStop(_loc2_.character_talent_2);
         }
         else
         {
            this.talent_2.gotoAndStop(4);
         }
         if(_loc2_.character_talent_3)
         {
            this.talent_3.gotoAndStop(_loc2_.character_talent_3);
         }
         else
         {
            this.talent_3.gotoAndStop(4);
         }
         this.outfit_manager.fillOutfit(this.char_mc,this.sets.weapon,this.sets.back_item,this.sets.clothing,this.sets.hairstyle,this.sets.face,this.sets.hair_color,this.sets.skin_color);
         if(this.is_sw)
         {
            this.hideSkills();
         }
         else
         {
            this.loadSkills();
         }
      }
      
      function openDetail(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.detailMC.visible = true;
         this.detailMC.nicknameTxt.text = this.character.character_name;
         var _loc2_:Array = [this.sets.hairstyle,this.sets.clothing,this.sets.back_item,this.sets.weapon,this.sets.accessory];
         var _loc3_:* = 0;
         while(_loc3_ < 5)
         {
            GF.removeAllChild(this.detailMC["item" + _loc3_].iconHolder);
            if(_loc2_[_loc3_].split("_")[1] != "00")
            {
               this.detailMC["item" + _loc3_].visible = true;
               NinjaSage.loadIconSWF("items",_loc2_[_loc3_],this.detailMC["item" + _loc3_].iconHolder,"icon");
               _loc4_ = Library.getItemInfo(_loc2_[_loc3_]);
               this.detailMC["item" + _loc3_].tooltip = _loc4_;
               this.detailMC["item" + _loc3_].item_type = _loc4_.item_id.split("_")[0];
               this.eventHandler.addListener(this.detailMC["item" + _loc3_],MouseEvent.ROLL_OVER,this.tooltipOnHover,false,0,true);
               this.eventHandler.addListener(this.detailMC["item" + _loc3_],MouseEvent.ROLL_OUT,this.tooltipOnOut,false,0,true);
            }
            else
            {
               this.detailMC["item" + _loc3_].visible = false;
            }
            _loc3_++;
         }
         if("pet_swf" in this.pets && this.pets.pet_swf != null)
         {
            GF.removeAllChild(this.detailMC["item5"].iconHolder);
            GF.removeAllChild(this.detailMC.petMc.charMc);
            this.detailMC.petTxt.text = this.pets.pet_name;
            NinjaSage.loadIconSWF("pets",this.pets.pet_swf,this.detailMC.item5.iconHolder,"icon");
            NinjaSage.loadIconSWF("pets",this.pets.pet_swf,this.detailMC.petMc.charMc,this.pets.pet_swf);
            (_loc5_ = PetInfo.getPetStats(this.pets.pet_swf)).pet_level_player = this.pets.pet_level;
            this.detailMC["item5"].tooltip = _loc5_;
            this.detailMC["item5"].item_type = _loc5_.pet_id.split("_")[0];
            this.eventHandler.addListener(this.detailMC["item5"],MouseEvent.ROLL_OVER,this.tooltipOnHover,false,0,true);
            this.eventHandler.addListener(this.detailMC["item5"],MouseEvent.ROLL_OUT,this.tooltipOnOut,false,0,true);
            this.detailMC.petMc.charMc.scaleX = 1.2;
            this.detailMC.petMc.charMc.scaleY = 1.2;
         }
         else
         {
            this.detailMC["item5"].visible = false;
         }
         this.outfit_manager.fillOutfit(this.detailMC.char_mc,this.sets.weapon,this.sets.back_item,this.sets.clothing,this.sets.hairstyle,this.sets.face,this.sets.hair_color,this.sets.skin_color);
         this.eventHandler.addListener(this.detailMC.closeBtn,MouseEvent.CLICK,this.closeDetail);
      }
      
      function closeDetail(param1:MouseEvent) : *
      {
         this.detailMC.visible = false;
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            GF.removeAllChild(this.detailMC["item" + _loc2_].iconHolder);
            _loc2_++;
         }
         GF.removeAllChild(this.detailMC.petMc.charMc);
         System.gc();
      }
      
      function onCopyText(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         switch(_loc2_)
         {
            case "txt_id":
               System.setClipboard(this.txt_id.text.replace("ID  ",""));
               this.main.showMessage("ID Copied!");
               break;
            case "txt_name":
               System.setClipboard(this.txt_name.text);
               this.main.showMessage("Nickname Copied!");
         }
      }
      
      private function onClanLogoLoaded(param1:*) : *
      {
         BulkLoader.getLoader("assets").removeEventListener(BulkLoader.COMPLETE,this.onClanLogoLoaded);
         this.clanLogoHolder.addChild(BulkLoader.getLoader("assets").getContent("clanBanner",true));
         NinjaSage.showDynamicTooltip(this.clanLogoHolder,"[" + this.clan.id + "] " + this.clan.name);
         this.clanLogoHolder.scaleX = 0.5;
         this.clanLogoHolder.scaleY = 0.5;
      }
      
      protected function calculate_stats(param1:*) : *
      {
         return StatManager.calculate_stats_with_data(param1,this.character.character_level,this.points.atrrib_earth,this.points.atrrib_water,this.points.atrrib_wind,this.points.atrrib_lightning,this.sets.weapon,this.sets.back_item,this.sets.accessory,this.inventory.char_talent_skills,this.inventory.char_senjutsu_skills,this.sets.clothing,this.sets.hairstyle);
      }
      
      private function hideSkills() : void
      {
         this.bgSkill.visible = false;
         var _loc1_:* = 1;
         while(_loc1_ < 9)
         {
            this["skill_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function loadSkills() : *
      {
         var _loc3_:* = undefined;
         var _loc1_:* = this.sets.skills.split(",");
         var _loc2_:* = 1;
         while(_loc2_ < 9)
         {
            if(_loc2_ <= _loc1_.length)
            {
               _loc3_ = SkillLibrary.getSkillInfo(_loc1_[_loc2_ - 1]);
               if(_loc3_.item_id == "null")
               {
                  return;
               }
               this["skill_" + _loc2_].tooltip = _loc3_;
               this["skill_" + _loc2_].item_type = _loc3_.skill_id.split("_")[0];
               this.eventHandler.addListener(this["skill_" + _loc2_],MouseEvent.ROLL_OVER,this.tooltipOnHover,false,0,true);
               this.eventHandler.addListener(this["skill_" + _loc2_],MouseEvent.ROLL_OUT,this.tooltipOnOut,false,0,true);
               NinjaSage.loadIconSWF("skills",_loc1_[_loc2_ - 1],this["skill_" + _loc2_]);
            }
            _loc2_++;
         }
      }
      
      protected function unfriendConfirmation(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         this.confirmation = getDefinitionByName("Popups.Confirmation") as Class;
         this.confirmation = new this.confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to unfriend " + this.character.character_name + "?";
         this.confirmation.btn_close.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            removeChild(self.confirmation);
         });
         this.confirmation.btn_confirm.addEventListener(MouseEvent.CLICK,this.unfriendCharacter);
         addChild(this.confirmation);
      }
      
      protected function unfriendCharacter(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            removeChild(this.confirmation);
            this.main.amf_manager.service("OvAKMASEbHeDKgxc.XnQr1WuEfkNY",[Character.char_id,Character.sessionkey,this.char_id],this.unfriendCallback);
         }
         catch(e:Error)
         {
            this.main.loading(false);
         }
      }
      
      public function unfriendCallback(param1:Object) : *
      {
         if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
            return;
         }
         if(param1.status == 0)
         {
            this.main.getError(param1.error);
            return;
         }
         this.main.giveMessage(param1.result);
         this.closePanel(null);
      }
      
      public function sendFriendRequest(param1:MouseEvent) : *
      {
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.fRhD12Uvu6No",[Character.char_id,Character.sessionkey,this.char_id],this.onFriendRequestSent);
      }
      
      public function onFriendRequestSent(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
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
      
      private function tooltipOnHover(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         switch(param1.currentTarget.item_type)
         {
            case "skill":
               _loc2_ = "" + param1.currentTarget.tooltip.skill_name + "\n(Skill)\n" + "\nLevel " + param1.currentTarget.tooltip.skill_level + "\n<font color=\"#ff0000\">Damage: " + param1.currentTarget.tooltip.skill_damage + "</font>\n<font color=\"#0000ff\">CP Cost: " + param1.currentTarget.tooltip.skill_cp_cost + "</font>\n<font color=\"#ffcc00\">Cooldown: " + param1.currentTarget.tooltip.skill_cooldown + "</font>\n\n" + param1.currentTarget.tooltip.skill_description;
               break;
            case "wpn":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Weapon)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n<font color=\"#ff0000\">Damage: " + param1.currentTarget.tooltip.item_damage + "</font>\n\n" + param1.currentTarget.tooltip.item_description;
               break;
            case "back":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Back Item)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description;
               break;
            case "set":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Clothes)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description;
               break;
            case "hair":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Hairstyle)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description;
               break;
            case "accessory":
               _loc2_ = "" + param1.currentTarget.tooltip.item_name + "\n(Accessory)\n" + "\nLevel " + param1.currentTarget.tooltip.item_level + "\n\n" + param1.currentTarget.tooltip.item_description;
               break;
            case "pet":
               _loc2_ = "" + param1.currentTarget.tooltip.pet_name + "\n(Pet)\n" + "\nLevel " + param1.currentTarget.tooltip.pet_level_player + "\n\n" + param1.currentTarget.tooltip.description;
         }
         this.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc2_);
      }
      
      function tooltipOnOut(param1:MouseEvent) : void
      {
         this.tooltip.hide();
      }
      
      function closePanel(param1:MouseEvent) : void
      {
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         parent.removeChild(this);
         this.outfit_manager.destroy();
         this.outfit_manager = null;
         if(!BattleVars.MATCH_RUNNING)
         {
            BulkLoader.getLoader("assets").removeAll();
         }
         GF.removeAllChild(this.char_mc);
         this.char_mc = null;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.tooltip.destroy();
         this.clan = null;
         this.character = null;
         this.sets = null;
         this.pets = null;
         this.points = null;
         this.inventory = null;
         this.skillInformations = [];
         this.confirmation = null;
         this.tooltip = null;
         this.self = null;
         this.main = null;
         var _loc2_:* = 1;
         while(_loc2_ < 9)
         {
            GF.removeAllChild(this["skill_" + _loc2_].iconHolder);
            _loc2_++;
         }
         NinjaSage.clearDynamicTooltip(this.clanLogoHolder);
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         System.gc();
         GF.removeAllChild(this);
      }
   }
}
