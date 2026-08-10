package Panels
{
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Managers.StatManager;
   import Storage.Character;
   import Storage.GameData;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol9116")]
   public class New_UI_Friend_Profile extends MovieClip
   {
      
      public static var check_talent:Boolean = false;
      
      public static var check_senjutsu:Boolean = false;
      
      public var btn_detail:SimpleButton;
      
      public var clanLogoHolder:MovieClip;
      
      public var classMC:MovieClip;
      
      public var earthDesc:TextField;
      
      public var fireDesc:TextField;
      
      public var lbl_accuracy:TextField;
      
      public var lbl_agility:TextField;
      
      public var lbl_attribute:TextField;
      
      public var lbl_crit:TextField;
      
      public var lbl_dodge:TextField;
      
      public var lbl_mastery:TextField;
      
      public var lbl_profile:TextField;
      
      public var lbl_purify:TextField;
      
      public var lightningDesc:TextField;
      
      public var maxEarth1:MovieClip;
      
      public var maxFire1:MovieClip;
      
      public var maxLightning1:MovieClip;
      
      public var maxWater1:MovieClip;
      
      public var maxWind1:MovieClip;
      
      public var placeholder_1:MovieClip;
      
      public var placeholder_2:MovieClip;
      
      public var placeholder_3:MovieClip;
      
      public var placeholder_4:MovieClip;
      
      public var placeholder_5:MovieClip;
      
      public var placeholder_6:MovieClip;
      
      public var placeholder_7:MovieClip;
      
      public var placeholder_8:MovieClip;
      
      public var senjutsu:MovieClip;
      
      public var spBar:MovieClip;
      
      public var txt_accuracy:TextField;
      
      public var txt_sp:TextField;
      
      public var waterDesc:TextField;
      
      public var windDesc:TextField;
      
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
      
      public var main:*;
      
      public var char_id:*;
      
      private var clan:*;
      
      private var character:*;
      
      private var sets:*;
      
      private var pets:*;
      
      private var points:*;
      
      private var inventory:*;
      
      private var self:New_UI_Friend_Profile;
      
      private var skillInformations:Array = [];
      
      private var confirmation:*;
      
      public var eventHandler:* = new EventHandler();
      
      public var outfit_manager:*;
      
      public var is_sw:Boolean = false;
      
      private var destroyed:* = false;
      
      public function New_UI_Friend_Profile(param1:*, param2:String, param3:Boolean = false)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.self = this;
         this.main = param1;
         this.is_sw = param3;
         this.outfit_manager = new OutfitManager();
         this.char_id = param2;
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
         this.txt_id.text = "ID  " + this.char_id;
         this.eventHandler.addListener(this.txt_id,MouseEvent.CLICK,this.onCopyText);
         this.txt_name.htmlText = Character.colorifyText(this.char_id,_loc2_.character_name,this.txt_name);
         this.eventHandler.addListener(this.txt_name,MouseEvent.CLICK,this.onCopyText);
         this.txt_lvl.text = _loc2_.character_level;
         this.rankMC.gotoAndStop(_loc2_.character_rank);
         this.element_1.gotoAndStop(int(_loc2_.character_element_1) + 1);
         this.element_2.gotoAndStop(int(_loc2_.character_element_2) + 1);
         this.element_3.gotoAndStop(int(_loc2_.character_element_3) + 1);
         this.senjutsu.gotoAndStop(_loc2_.character_senjutsu || 1);
         this.txt_wind.text = String(this.points.atrrib_wind);
         this.txt_fire.text = String(this.points.atrrib_fire);
         this.txt_lightning.text = String(this.points.atrrib_lightning);
         this.txt_water.text = String(this.points.atrrib_water);
         this.txt_earth.text = String(this.points.atrrib_earth);
         var _loc3_:* = new StatManager(this.main).calculate_xp(int(_loc2_.character_level));
         this.txt_hp.text = this.calculate_stats("hp") + " / " + this.calculate_stats("hp");
         this.txt_cp.text = this.calculate_stats("cp") + " / " + this.calculate_stats("cp");
         this.txt_sp.text = this.calculate_stats("sp") + " / " + this.calculate_stats("sp");
         this.txt_agility.text = this.calculate_stats("agility");
         this.txt_crit.text = this.calculate_stats("critical") + "%";
         this.txt_dodge.text = this.calculate_stats("dodge") + "%";
         this.txt_purify.text = this.calculate_stats("purify") + "%";
         this.txt_accuracy.text = this.calculate_stats("accuracy") + "%";
         this.txt_xp.text = _loc2_.character_xp + " / " + _loc3_;
         this.xpBar.bar.scaleX = Math.max(Math.min(Number(_loc2_.character_xp) / Number(_loc3_),2.79),0);
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
         NinjaSage.showDynamicTooltip(this.element_1,this.getElementName(int(_loc2_.character_element_1)));
         NinjaSage.showDynamicTooltip(this.element_2,this.getElementName(int(_loc2_.character_element_2)));
         NinjaSage.showDynamicTooltip(this.element_3,this.getElementName(int(_loc2_.character_element_3)));
         NinjaSage.showDynamicTooltip(this.senjutsu,this.getSenjutsuName(_loc2_.character_senjutsu));
         NinjaSage.showDynamicTooltip(this.talent_1,this.getTalentName(_loc2_.character_talent_1));
         NinjaSage.showDynamicTooltip(this.talent_2,this.getTalentName(_loc2_.character_talent_2));
         NinjaSage.showDynamicTooltip(this.talent_3,this.getTalentName(_loc2_.character_talent_3));
         NinjaSage.showDynamicTooltip(this.windDesc,"Each point increases 0.4% dodge chance, 1 agility and 1% extra damage to Wind Ninjutsu");
         NinjaSage.showDynamicTooltip(this.fireDesc,"Each point increases 0.4% extra damage to all types of damage, 0.4% chance to increase all types of damage by 30% for 1 turn (known as Combustion) and 1% extra damage to Fire Ninjutsu.");
         NinjaSage.showDynamicTooltip(this.lightningDesc,"Each point increases 0.4% critical chance, increase critical strike damage bonus by 0.8% and 1% extra damage to Thunder Ninjutsu.");
         NinjaSage.showDynamicTooltip(this.waterDesc,"Each point increases the max CP by 30, 0.4% chance to remove all negative effect at the start of the turn (known as Purify), 1% extra damage to Water Ninjutsu and 1% healing bonus.");
         NinjaSage.showDynamicTooltip(this.earthDesc,"Each point increases the max HP by 30, 0.4% chance to cause 30% damage taken to the attacker as well (known as Reactive Force) and 1% extra damage to Rock Ninjutsu!");
      }
      
      internal function openDetail(param1:MouseEvent) : *
      {
         var _loc4_:String = null;
         this.detailMC.visible = true;
         if(this.is_sw)
         {
            this.hideSkills();
         }
         else
         {
            this.loadSkills("detail");
         }
         var _loc2_:Array = [this.sets.hairstyle,this.sets.clothing,this.sets.back_item,this.sets.weapon,this.sets.accessory];
         var _loc3_:* = 0;
         while(_loc3_ < 5)
         {
            GF.removeAllChild(this.detailMC["item" + _loc3_].iconHolder);
            this.detailMC["item" + _loc3_].visible = false;
            if(_loc2_[_loc3_].split("_")[1] != "00")
            {
               this.detailMC["item" + _loc3_].visible = true;
               this.detailMC["item" + _loc3_].ownedTxt.visible = false;
               this.detailMC["item" + _loc3_].amtTxt.visible = false;
               this.detailMC["item" + _loc3_].btn_preview.visible = this.checkIsItemOrSkill(_loc2_[_loc3_]);
               this.detailMC["item" + _loc3_].btn_preview.metaData = {"itemId":_loc2_[_loc3_]};
               this.eventHandler.addListener(this.detailMC["item" + _loc3_].btn_preview,MouseEvent.CLICK,this.main.openPreview);
               NinjaSage.loadItemIcon(this.detailMC["item" + _loc3_],_loc2_[_loc3_]);
            }
            _loc3_++;
         }
         if("pet_swf" in this.pets && this.pets.pet_swf != null)
         {
            GF.removeAllChild(this.detailMC["item5"].rewardIcon.iconHolder);
            GF.removeAllChild(this.detailMC.petMC.petMc.charMc);
            this.detailMC["item5"].ownedTxt.visible = false;
            this.detailMC["item5"].amtTxt.visible = false;
            this.detailMC["item5"].btn_preview.visible = false;
            NinjaSage.loadItemIcon(this.detailMC["item5"],this.pets.pet_swf);
            NinjaSage.loadIconSWF("pets",this.pets.pet_swf,this.detailMC.petMC.petMc.charMc,this.pets.pet_swf);
            _loc4_ = this.pets.pet_name + "\nLevel " + this.pets.pet_level;
            NinjaSage.showDynamicTooltip(this.detailMC["petMC"],_loc4_);
            this.detailMC.petMC.petMc.charMc.scaleX = 1.2;
            this.detailMC.petMC.petMc.charMc.scaleY = 1.2;
         }
         else
         {
            this.detailMC["item5"].visible = false;
         }
         this.outfit_manager.fillOutfit(this.detailMC.char_mc,this.sets.weapon,this.sets.back_item,this.sets.clothing,this.sets.hairstyle,this.sets.face,this.sets.hair_color,this.sets.skin_color);
         this.eventHandler.addListener(this.detailMC.closeBtn,MouseEvent.CLICK,this.closeDetail);
         this.char_mc.visible = false;
         _loc3_ = 1;
         while(_loc3_ < 9)
         {
            this["skill_" + _loc3_].visible = false;
            _loc3_++;
         }
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
      
      internal function closeDetail(param1:MouseEvent) : *
      {
         this.detailMC.visible = false;
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            GF.removeAllChild(this.detailMC["item" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.detailMC["item" + _loc2_].skillIcon.iconHolder);
            _loc2_++;
         }
         _loc2_ = 1;
         while(_loc2_ < 9)
         {
            GF.removeAllChild(this.detailMC["skill_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this.detailMC["skill_" + _loc2_].skillIcon.iconHolder);
            this["placeholder_" + _loc2_].visible = true;
            _loc2_++;
         }
         GF.removeAllChild(this.detailMC.petMC.petMc.charMc);
         if(!this.is_sw)
         {
            _loc2_ = 1;
            while(_loc2_ <= this.sets.skills.split(",").length)
            {
               this["skill_" + _loc2_].visible = true;
               _loc2_++;
            }
         }
         this.char_mc.visible = true;
         System.gc();
      }
      
      internal function onCopyText(param1:MouseEvent) : *
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
         var _loc1_:* = 1;
         while(_loc1_ < 9)
         {
            this["skill_" + _loc1_].visible = false;
            this.detailMC["skill_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function loadSkills(param1:String = "profile") : *
      {
         var _loc2_:* = this.sets.skills.split(",");
         var _loc3_:MovieClip = param1 == "profile" ? this : this.detailMC;
         var _loc4_:* = 1;
         while(_loc4_ < 9)
         {
            _loc3_["skill_" + _loc4_].visible = false;
            if(param1 == "detail")
            {
               this["placeholder_" + _loc4_].visible = false;
            }
            if(_loc2_.length >= _loc4_)
            {
               _loc3_["placeholder_" + _loc4_].visible = false;
               _loc3_["skill_" + _loc4_].visible = true;
               _loc3_["skill_" + _loc4_].ownedTxt.visible = false;
               _loc3_["skill_" + _loc4_].amtTxt.visible = false;
               _loc3_["skill_" + _loc4_].btn_preview.visible = true;
               _loc3_["skill_" + _loc4_].btn_preview.metaData = {"itemId":_loc2_[_loc4_ - 1]};
               this.eventHandler.addListener(_loc3_["skill_" + _loc4_].btn_preview,MouseEvent.CLICK,this.main.openPreview);
               NinjaSage.loadItemIcon(_loc3_["skill_" + _loc4_],_loc2_[_loc4_ - 1]);
            }
            _loc4_++;
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
      
      private function getTalentName(param1:String) : String
      {
         var _loc2_:* = GameData.get("talent_info")[param1];
         if(_loc2_)
         {
            return _loc2_.talent_name;
         }
         return "Not Learned";
      }
      
      private function getSenjutsuName(param1:String) : String
      {
         switch(param1)
         {
            case "toad":
               return "Toad";
            case "snake":
               return "Snake";
            case "other":
               return "Other";
            default:
               return "Not Learned";
         }
      }
      
      private function getElementName(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return "Wind";
            case 2:
               return "Fire";
            case 3:
               return "Lightning";
            case 4:
               return "Earth";
            case 5:
               return "Water";
            default:
               return "Not Learned";
         }
      }
      
      internal function closePanel(param1:MouseEvent) : void
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
         this.clan = null;
         this.character = null;
         this.sets = null;
         this.pets = null;
         this.points = null;
         this.inventory = null;
         this.skillInformations = [];
         this.confirmation = null;
         this.self = null;
         this.main = null;
         var _loc2_:* = 1;
         while(_loc2_ < 9)
         {
            GF.removeAllChild(this["skill_" + _loc2_].rewardIcon.iconHolder);
            GF.removeAllChild(this["skill_" + _loc2_].skillIcon.iconHolder);
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

