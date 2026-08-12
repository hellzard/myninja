package Panels
{
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
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public class New_UI_Profile extends MovieClip
   {
       
      
      public var btn_Animation_Shop:SimpleButton;
      
      public var btn_viewAsFriend:SimpleButton;
      
      public var clanLogoHolder:MovieClip;
      
      public var classMC:MovieClip;
      
      public var earthDesc:TextField;
      
      public var fireDesc:TextField;
      
      public var lbl_accuracy:TextField;
      
      public var lbl_agility:TextField;
      
      public var lbl_attributes:TextField;
      
      public var lbl_crit:TextField;
      
      public var lbl_dodge:TextField;
      
      public var lbl_mastery:TextField;
      
      public var lbl_profile:TextField;
      
      public var lbl_purify:TextField;
      
      public var lightningDesc:TextField;
      
      public var maxEarth0:SimpleButton;
      
      public var maxEarth1:MovieClip;
      
      public var maxFire0:SimpleButton;
      
      public var maxFire1:MovieClip;
      
      public var maxLightning0:SimpleButton;
      
      public var maxLightning1:MovieClip;
      
      public var maxWater0:SimpleButton;
      
      public var maxWater1:MovieClip;
      
      public var maxWind0:SimpleButton;
      
      public var maxWind1:MovieClip;
      
      public var senjutsu:MovieClip;
      
      public var spBar:MovieClip;
      
      public var txt_accuracy:TextField;
      
      public var txt_sp:TextField;
      
      public var waterDesc:TextField;
      
      public var windDesc:TextField;
      
      private var escapeKey:EscapeKeyManager;
      
      public var add_earth:SimpleButton;
      
      public var add_fire:SimpleButton;
      
      public var add_lightning:SimpleButton;
      
      public var add_water:SimpleButton;
      
      public var add_wind:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_reset:SimpleButton;
      
      public var char_mc:MovieClip;
      
      public var cpBar:MovieClip;
      
      public var element_1:MovieClip;
      
      public var element_2:MovieClip;
      
      public var element_3:MovieClip;
      
      public var emblemMC:MovieClip;
      
      public var hpBar:MovieClip;
      
      public var rankMC:MovieClip;
      
      public var sub_earth:SimpleButton;
      
      public var sub_fire:SimpleButton;
      
      public var sub_lightning:SimpleButton;
      
      public var sub_water:SimpleButton;
      
      public var btn_rename:SimpleButton;
      
      public var sub_wind:SimpleButton;
      
      public var talent_1:MovieClip;
      
      public var talent_2:MovieClip;
      
      public var talent_3:MovieClip;
      
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
      
      public var main;
      
      public var stat_manager:StatManager;
      
      public var outfit_manager:OutfitManager;
      
      public var eventHandler:EventHandler;
      
      private var loaderSwf = null;
      
      public function New_UI_Profile(param1:*)
      {
         this.eventHandler = new EventHandler();
         this.stat_manager = new StatManager();
         this.outfit_manager = new OutfitManager(param1);
         this.loaderSwf = BulkLoader.createUniqueNamedLoader();
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.savePoints);
         this.main = param1;
         this.getBasicData();
         this.getAttributePoints();
         this.addPointListeners();
         this.addClanLogo();
      }
      
      public function addClanLogo() : *
      {
         if(Character.clan_banner != null)
         {
            this.loaderSwf.add(Character.clan_banner,{"id":"clanBanner"});
            this.loaderSwf.addEventListener(BulkLoader.COMPLETE,this.onClanLogoLoaded);
            this.loaderSwf.start();
         }
         else
         {
            this.clanLogoHolder.visible = false;
         }
      }
      
      private function onClanLogoLoaded(param1:*) : *
      {
         this.clanLogoHolder.addChild(this.loaderSwf.getContent("clanBanner",true));
         NinjaSage.showDynamicTooltip(this.clanLogoHolder,"[" + Character.clan_id + "] " + Character.clan_name);
         this.clanLogoHolder.scaleX = 0.5;
         this.clanLogoHolder.scaleY = 0.5;
      }
      
      function getAttributePoints() : void
      {
         var _loc1_:int = Character.atrrib_wind + Character.atrrib_fire + Character.atrrib_lightning + Character.atrrib_water + Character.atrrib_earth;
         Character.atrrib_free = int(Character.character_lvl) - _loc1_;
         this.txt_wind.text = String(Character.atrrib_wind);
         this.txt_fire.text = String(Character.atrrib_fire);
         this.txt_lightning.text = String(Character.atrrib_lightning);
         this.txt_water.text = String(Character.atrrib_water);
         this.txt_earth.text = String(Character.atrrib_earth);
         this.txt_free.text = String(Character.atrrib_free) + " Available Points";
         this.add_wind.visible = true;
         this.add_fire.visible = true;
         this.add_lightning.visible = true;
         this.add_water.visible = true;
         this.add_earth.visible = true;
         this.sub_wind.visible = true;
         this.sub_fire.visible = true;
         this.sub_lightning.visible = true;
         this.sub_water.visible = true;
         this.sub_earth.visible = true;
         if(Character.atrrib_free < 1)
         {
            this.add_wind.visible = false;
            this.add_fire.visible = false;
            this.add_lightning.visible = false;
            this.add_water.visible = false;
            this.add_earth.visible = false;
         }
         if(Character.atrrib_wind < 1)
         {
            this.sub_wind.visible = false;
         }
         if(Character.atrrib_fire < 1)
         {
            this.sub_fire.visible = false;
         }
         if(Character.atrrib_lightning < 1)
         {
            this.sub_lightning.visible = false;
         }
         if(Character.atrrib_water < 1)
         {
            this.sub_water.visible = false;
         }
         if(Character.atrrib_earth < 1)
         {
            this.sub_earth.visible = false;
         }
         this.txt_hp.text = StatManager.calculate_stats_with_data("hp") + " / " + StatManager.calculate_stats_with_data("hp");
         this.txt_cp.text = StatManager.calculate_stats_with_data("cp") + " / " + StatManager.calculate_stats_with_data("cp");
         this.txt_sp.text = StatManager.calculate_stats_with_data("sp") + " / " + StatManager.calculate_stats_with_data("sp");
         this.txt_agility.text = StatManager.calculate_stats_with_data("agility");
         this.txt_crit.text = StatManager.calculate_stats_with_data("critical") + "%";
         this.txt_dodge.text = StatManager.calculate_stats_with_data("dodge") + "%";
         this.txt_purify.text = StatManager.calculate_stats_with_data("purify") + "%";
         this.txt_accuracy.text = StatManager.calculate_stats_with_data("accuracy") + "%";
      }
      
      function addPointListeners() : void
      {
         this.eventHandler.addListener(this.add_wind,MouseEvent.CLICK,this.addPoints,false,0,true);
         this.eventHandler.addListener(this.add_fire,MouseEvent.CLICK,this.addPoints,false,0,true);
         this.eventHandler.addListener(this.add_lightning,MouseEvent.CLICK,this.addPoints,false,0,true);
         this.eventHandler.addListener(this.add_water,MouseEvent.CLICK,this.addPoints,false,0,true);
         this.eventHandler.addListener(this.add_earth,MouseEvent.CLICK,this.addPoints,false,0,true);
         this.eventHandler.addListener(this.sub_wind,MouseEvent.CLICK,this.subPoints,false,0,true);
         this.eventHandler.addListener(this.sub_fire,MouseEvent.CLICK,this.subPoints,false,0,true);
         this.eventHandler.addListener(this.sub_lightning,MouseEvent.CLICK,this.subPoints,false,0,true);
         this.eventHandler.addListener(this.sub_water,MouseEvent.CLICK,this.subPoints,false,0,true);
         this.eventHandler.addListener(this.sub_earth,MouseEvent.CLICK,this.subPoints,false,0,true);
         this.eventHandler.addListener(this.btn_reset,MouseEvent.CLICK,this.resetPoints,false,0,true);
         var _loc1_:* = 0;
         while(_loc1_ < 2)
         {
            this.eventHandler.addListener(this["maxWind" + _loc1_],MouseEvent.CLICK,this.onMaxPoints,false,0,true);
            this.eventHandler.addListener(this["maxFire" + _loc1_],MouseEvent.CLICK,this.onMaxPoints,false,0,true);
            this.eventHandler.addListener(this["maxLightning" + _loc1_],MouseEvent.CLICK,this.onMaxPoints,false,0,true);
            this.eventHandler.addListener(this["maxWater" + _loc1_],MouseEvent.CLICK,this.onMaxPoints,false,0,true);
            this.eventHandler.addListener(this["maxEarth" + _loc1_],MouseEvent.CLICK,this.onMaxPoints,false,0,true);
            _loc1_++;
         }
         this.eventHandler.addListener(this.btn_viewAsFriend,MouseEvent.CLICK,this.openFriendProfile,false,0,true);
         this.eventHandler.addListener(this.btn_Animation_Shop,MouseEvent.CLICK,this.openAnimationShop,false,0,true);
         NinjaSage.showDynamicTooltip(this.btn_viewAsFriend,"View as friend");
         NinjaSage.showDynamicTooltip(this.btn_Animation_Shop,"Animation");
         NinjaSage.showDynamicTooltip(this.btn_rename,"Rename");
      }
      
      function addPoints(param1:MouseEvent) : void
      {
         if(Character.atrrib_free > 0)
         {
            if(param1.currentTarget.name == "add_wind")
            {
               ++Character.atrrib_wind;
               --Character.atrrib_free;
            }
            else if(param1.currentTarget.name == "add_fire")
            {
               ++Character.atrrib_fire;
               --Character.atrrib_free;
            }
            else if(param1.currentTarget.name == "add_lightning")
            {
               ++Character.atrrib_lightning;
               --Character.atrrib_free;
            }
            else if(param1.currentTarget.name == "add_water")
            {
               ++Character.atrrib_water;
               --Character.atrrib_free;
            }
            else if(param1.currentTarget.name == "add_earth")
            {
               ++Character.atrrib_earth;
               --Character.atrrib_free;
            }
            this.getAttributePoints();
         }
      }
      
      function subPoints(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "sub_wind")
         {
            if(Character.atrrib_wind > 0)
            {
               --Character.atrrib_wind;
               ++Character.atrrib_free;
            }
         }
         else if(param1.currentTarget.name == "sub_fire")
         {
            if(Character.atrrib_fire > 0)
            {
               --Character.atrrib_fire;
               ++Character.atrrib_free;
            }
         }
         else if(param1.currentTarget.name == "sub_lightning")
         {
            if(Character.atrrib_lightning > 0)
            {
               --Character.atrrib_lightning;
               ++Character.atrrib_free;
            }
         }
         else if(param1.currentTarget.name == "sub_water")
         {
            if(Character.atrrib_water > 0)
            {
               --Character.atrrib_water;
               ++Character.atrrib_free;
            }
         }
         else if(param1.currentTarget.name == "sub_earth")
         {
            if(Character.atrrib_earth > 0)
            {
               --Character.atrrib_earth;
               ++Character.atrrib_free;
            }
         }
         this.getAttributePoints();
      }
      
      function resetPoints(param1:MouseEvent) : void
      {
         Character.atrrib_wind = 0;
         Character.atrrib_fire = 0;
         Character.atrrib_lightning = 0;
         Character.atrrib_water = 0;
         Character.atrrib_earth = 0;
         this.getAttributePoints();
      }
      
      function onMaxPoints(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name.indexOf("maxWind") != -1)
         {
            Character.atrrib_wind += Character.atrrib_free;
         }
         else if(param1.currentTarget.name.indexOf("maxFire") != -1)
         {
            Character.atrrib_fire += Character.atrrib_free;
         }
         else if(param1.currentTarget.name.indexOf("maxLightning") != -1)
         {
            Character.atrrib_lightning += Character.atrrib_free;
         }
         else if(param1.currentTarget.name.indexOf("maxWater") != -1)
         {
            Character.atrrib_water += Character.atrrib_free;
         }
         else if(param1.currentTarget.name.indexOf("maxEarth") != -1)
         {
            Character.atrrib_earth += Character.atrrib_free;
         }
         this.getAttributePoints();
      }
      
      function getHelp(param1:MouseEvent) : void
      {
         this.main.getNotice("You Can Instantly Maxed Your Element Points by Clicking on Its Icon.");
      }
      
      function onMaxWind(param1:MouseEvent) : void
      {
         Character.atrrib_wind = 0;
         Character.atrrib_fire = 0;
         Character.atrrib_lightning = 0;
         Character.atrrib_water = 0;
         Character.atrrib_earth = 0;
         Character.atrrib_wind = int(Character.character_lvl);
         this.getAttributePoints();
      }
      
      function getBasicData() : void
      {
         NinjaSage.showDynamicTooltip(this.windDesc,"Each point increases 0.4% dodge chance, 1 agility and 1% extra damage to Wind Ninjutsu");
         NinjaSage.showDynamicTooltip(this.fireDesc,"Each point increases 0.4% extra damage to all types of damage, 0.4% chance to increase all types of damage by 30% for 1 turn (known as Combustion) and 1% extra damage to Fire Ninjutsu.");
         NinjaSage.showDynamicTooltip(this.lightningDesc,"Each point increases 0.4% critical chance, increase critical strike damage bonus by 0.8% and 1% extra damage to Thunder Ninjutsu.");
         NinjaSage.showDynamicTooltip(this.waterDesc,"Each point increases the max CP by 30, 0.4% chance to remove all negative effect at the start of the turn (known as Purify), 1% extra damage to Water Ninjutsu and 1% healing bonus.");
         NinjaSage.showDynamicTooltip(this.earthDesc,"Each point increases the max HP by 30, 0.4% chance to cause 30% damage taken to the attacker as well (known as Reactive Force) and 1% extra damage to Rock Ninjutsu!");
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.savePoints);
         this.eventHandler.addListener(this.btn_rename,MouseEvent.CLICK,this.openRename);
         if(Character.account_type == 0)
         {
            this.emblemMC.gotoAndStop(1);
            this.eventHandler.addListener(this.emblemMC,MouseEvent.CLICK,this.openPremiumPop);
         }
         else if(Character.account_type == 1)
         {
            this.emblemMC.gotoAndStop(2);
         }
         this.rankMC.gotoAndStop(Character.character_rank);
         this.element_1.gotoAndStop(int(Character.character_element_1) + 1);
         this.element_2.gotoAndStop(int(Character.character_element_2) + 1);
         this.eventHandler.addListener(this.element_1,MouseEvent.CLICK,this.openAcademy);
         this.eventHandler.addListener(this.element_2,MouseEvent.CLICK,this.openAcademy);
         NinjaSage.showDynamicTooltip(this.element_1,this.getElementName(int(Character.character_element_1)));
         NinjaSage.showDynamicTooltip(this.element_2,this.getElementName(int(Character.character_element_2)));
         if(Character.account_type == 0)
         {
            this.eventHandler.addListener(this.element_3,MouseEvent.CLICK,this.openPremiumPop);
         }
         else
         {
            this.eventHandler.addListener(this.element_3,MouseEvent.CLICK,this.openAcademy);
         }
         this.element_3.gotoAndStop(int(Character.character_element_3) + 1);
         NinjaSage.showDynamicTooltip(this.element_3,this.getElementName(int(Character.character_element_3)));
         if(Character.character_talent_1)
         {
            this.talent_1.gotoAndStop(Character.character_talent_1);
         }
         else
         {
            this.talent_1.gotoAndStop(3);
         }
         this.talent_2.gotoAndStop(4);
         this.talent_3.gotoAndStop(4);
         if(int(Character.character_lvl) == 50 || int(Character.character_rank) > 3)
         {
            if(Character.character_talent_2)
            {
               this.talent_2.gotoAndStop(Character.character_talent_2);
            }
            if(Character.character_talent_3)
            {
               this.talent_3.gotoAndStop(Character.character_talent_3);
            }
         }
         NinjaSage.showDynamicTooltip(this.talent_1,this.getTalentName(Character.character_talent_1));
         NinjaSage.showDynamicTooltip(this.talent_2,this.getTalentName(Character.character_talent_2));
         NinjaSage.showDynamicTooltip(this.talent_3,this.getTalentName(Character.character_talent_3));
         this.senjutsu.gotoAndStop(Character.character_senjutsu || 1);
         NinjaSage.showDynamicTooltip(this.senjutsu,this.getSenjutsuName(Character.character_senjutsu));
         if(Character.character_rank < "5")
         {
            this.classMC.visible = false;
         }
         var _loc1_:* = !!Character.character_class ? Character.character_class : "classNull";
         if(Character.character_class != null)
         {
            this.classMC.gotoAndStop(_loc1_);
            this.eventHandler.addListener(this.classMC.changeClassBtn,MouseEvent.CLICK,this.showChangeClass,false,0,true);
         }
         else
         {
            this.classMC.gotoAndStop(_loc1_);
         }
         var _loc2_:Boolean = int(Character.character_lvl) < 60 && Character.character_class == null && int(Character.character_rank) < 7;
         if(_loc2_)
         {
            this.classMC.visible = false;
         }
         this.txt_lvl.text = Character.character_lvl;
         this.txt_name.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.txt_name);
         this.eventHandler.addListener(this.txt_name,MouseEvent.CLICK,this.onCopyText);
         this.txt_id.text = "ID  " + Character.char_id;
         this.eventHandler.addListener(this.txt_id,MouseEvent.CLICK,this.onCopyText);
         this.txt_xp.text = Character.character_xp + " / " + String(this.stat_manager.calculate_xp(int(Character.character_lvl)));
         this.xpBar.bar.scaleX = Math.max(Math.min(Number(Character.character_xp) / Number(this.stat_manager.calculate_xp(int(Character.character_lvl))),2.79),0);
         this.outfit_manager.fillOutfit(this.char_mc,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin);
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
            case "slug":
               return "Slug";
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
      
      function showChangeClass(param1:MouseEvent) : *
      {
         this.main.loadExternalSwfPanel("SpecialClassChange","SpecialClassChange");
      }
      
      public function openFriendProfile(param1:MouseEvent) : *
      {
         this.main.openFriendProfile(Character.char_id,false);
         parent.removeChild(this);
         this.destroy();
      }
      
      function openAnimationShop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Animation_Shop");
      }
      
      function openPremiumPop(param1:MouseEvent) : void
      {
         this.main.loadPanel("Popups.EmblemUpgrade");
      }
      
      function openRename(param1:MouseEvent) : void
      {
         this.main.loadPanel("Popups.Rename");
      }
      
      function openAcademy(param1:MouseEvent) : void
      {
         if(Character._inBattle)
         {
            this.main.giveMessage("You can\'t change your skill set during battle !");
         }
      }
      
      function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         Log.debug(this,"DESTROY");
         GF.removeAllChild(this.char_mc);
         GF.removeAllChild(this.clanLogoHolder);
         this.eventHandler.removeAllEventListeners();
         NinjaSage.tooltip.hide();
         NinjaSage.clearDynamicTooltip(this.clanLogoHolder);
         NinjaSage.clearDynamicTooltip(this.btn_viewAsFriend);
         NinjaSage.clearEventListener();
         BulkLoader.getLoader("assets").removeAll();
         OutfitManager.clearStaticMc();
         this.loaderSwf.clear();
         this.loaderSwf = null;
         this.outfit_manager.destroy();
         this.eventHandler = null;
         this.outfit_manager = null;
         this.stat_manager = null;
         this.main = null;
         System.gc();
      }
      
      function savePoints(param1:* = null) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.ioFO1sY6dCkK",[Character.char_id,Character.sessionkey,Character.atrrib_wind,Character.atrrib_fire,Character.atrrib_lightning,Character.atrrib_water,Character.atrrib_earth,Character.atrrib_free],this.pointResponse);
      }
      
      function pointResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status != 1)
         {
            this.main.getError(param1.error);
         }
         if("HUD" in this.main && this.main.HUD)
         {
            this.main.HUD.loadFrame();
         }
         parent.removeChild(this);
         GF.removeAllChild(this);
         this.destroy();
      }
   }
}
