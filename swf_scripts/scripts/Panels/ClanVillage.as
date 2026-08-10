package Panels
{
   import Managers.OutfitManager;
   import Managers.StatManager;
   import Popups.ClanBattle;
   import Popups.ClanPrestigeBooster;
   import Popups.ClanStamina;
   import Popups.ClanUpgrade;
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import id.ninjasage.Clan;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6611")]
   public class ClanVillage extends MovieClip
   {
      
      public var btn_ClanOnlineList:SimpleButton;
      
      public var btn_prestigeBooster:SimpleButton;
      
      public var prestigeBoosterEnd:MovieClip;
      
      public var txt_onigiri:TextField;
      
      public var btn_clanBattle:SimpleButton;
      
      public var btn_clanHall:SimpleButton;
      
      public var btn_clanHotSpring:MovieClip;
      
      public var btn_clanRamen:MovieClip;
      
      public var btn_clanTemple:MovieClip;
      
      public var btn_clanTrainingHall:MovieClip;
      
      public var btn_staminaPanel:SimpleButton;
      
      public var btn_village:SimpleButton;
      
      public var btn_Scroll_Clan_Shop:SimpleButton;
      
      public var btn_clanReward:SimpleButton;
      
      public var btn_fame:SimpleButton;
      
      public var btn_repsim:SimpleButton;
      
      public var btn_ClanWarLeaderboard:SimpleButton;
      
      public var clanSeasonEnd:MovieClip;
      
      public var cpBar:MovieClip;
      
      public var face_mc:MovieClip;
      
      public var headMc:MovieClip;
      
      public var hpBar:MovieClip;
      
      public var levelTxt:TextField;
      
      public var stamBar:MovieClip;
      
      public var staminaPlusMc:MovieClip;
      
      public var staminaPlusText:TextField;
      
      public var txt_clan_gold:TextField;
      
      public var txt_clan_name:TextField;
      
      public var txt_clan_tokens:TextField;
      
      public var txt_cp:TextField;
      
      public var txt_gold:TextField;
      
      public var txt_hp:TextField;
      
      public var txt_members:TextField;
      
      public var txt_name:TextField;
      
      public var txt_prestige:TextField;
      
      public var txt_rep:TextField;
      
      public var txt_stamina:TextField;
      
      public var txt_tokens:TextField;
      
      public var main:*;
      
      public var clan_timestamp:*;
      
      public var booster_timestamp:*;
      
      public var clan_data:*;
      
      public var char_data:*;
      
      public var battle_panel:* = null;
      
      public var clan_hall:* = null;
      
      public var upgrade_panel:* = null;
      
      public var onlinelist:*;
      
      public var eventHandler:* = new EventHandler();
      
      private var escapeKey:EscapeKeyManager;
      
      public var timeout:*;
      
      public var timeoutBooster:*;
      
      public var loaderAsset:*;
      
      public var destroyed:* = false;
      
      public function ClanVillage(param1:*)
      {
         System.gc();
         this.clan_data = Character.clan_data;
         this.char_data = Character.clan_char_data;
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.loaderAsset = this.main.getTempLoader();
         this.addButtonListeners();
         this.setDisplay();
         this.checkTimeleft();
         this.onlinelist = new WorldChat(this.main,"clan");
         this.onlinelist.manualClose();
      }
      
      public function destroy() : *
      {
         Log.debug(this,"DESTROY");
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.removeAllChild(this.headMc.face_mc);
         if(this.eventHandler == null)
         {
            return;
         }
         this.eventHandler.removeAllEventListeners();
         if(this.timeout)
         {
            clearTimeout(this.timeout);
         }
         this.timeout = null;
         if(this.timeoutBooster)
         {
            clearTimeout(this.timeoutBooster);
         }
         this.timeoutBooster = null;
         Clan.instance.destroy();
         if(this.onlinelist)
         {
            this.onlinelist.destroy();
         }
         this.loaderAsset.clear();
         BulkLoader.getLoader("assets").removeAll();
         OutfitManager.clearStaticMc();
         this.loaderAsset = null;
         this.eventHandler = null;
         this.clan_timestamp = null;
         this.clan_data = null;
         this.char_data = null;
         this.battle_panel = null;
         this.clan_hall = null;
         this.upgrade_panel = null;
         this.onlinelist = null;
         this.main.removeLoadedPanel("Panels.ClanVillage");
         this.main = null;
         OutfitManager.removeChildsFromMovieClips(this);
      }
      
      public function checkTimeleft() : *
      {
         this.clan_timestamp = Character.clan_timestamp;
         this.updateTimeleft();
         this.prestigeBoosterEnd.visible = false;
         if(this.char_data.prestige_boost > 0)
         {
            this.prestigeBoosterEnd.visible = true;
            this.booster_timestamp = this.char_data.prestige_boost;
            this.updateBoosterTimeleft();
         }
      }
      
      public function updateTimeleft() : *
      {
         var _loc7_:* = undefined;
         if(this.timeout)
         {
            clearTimeout(this.timeout);
            this.timeout = null;
         }
         if(this.destroyed)
         {
            if(this.timeout)
            {
               clearTimeout(this.timeout);
            }
            this.timeout = null;
            return;
         }
         if(this.clan_timestamp == null)
         {
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:* = this.clan_timestamp;
         var _loc5_:* = Math.floor(_loc4_ / _loc1_);
         var _loc6_:* = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         _loc7_ = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         if(_loc7_ > 30)
         {
            this.staminaPlusMc.gotoAndStop(60 - _loc7_);
         }
         else
         {
            this.staminaPlusMc.gotoAndStop(30 - _loc7_);
         }
         this.clanSeasonEnd.daysTxt.text = _loc5_;
         this.clanSeasonEnd.hoursTxt.text = _loc6_;
         this.clanSeasonEnd.minutesTxt.text = _loc7_;
         this.clan_timestamp -= 10;
         Clan.instance.getStamina(this.onGetStamina);
      }
      
      public function onGetStamina(param1:Object, param2:* = null) : *
      {
         if(this.timeout)
         {
            clearTimeout(this.timeout);
            this.timeout = null;
         }
         if(param1 != null && param1.hasOwnProperty("char"))
         {
            Character.clan_char_data = param1.char;
            this.char_data = param1.char;
            this.txt_stamina.text = this.char_data.stamina + " / " + this.char_data.max_stamina;
            this.stamBar.scaleX = this.char_data.stamina / this.char_data.max_stamina;
            this.timeout = setTimeout(this.updateTimeleft,10000);
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            this.destroy();
         }
         if(param2 != null)
         {
            this.main.getError("");
            return;
         }
      }
      
      public function updateBoosterTimeleft() : *
      {
         if(this.timeoutBooster)
         {
            clearTimeout(this.timeoutBooster);
            this.timeoutBooster = null;
         }
         if(this.destroyed)
         {
            if(this.timeoutBooster)
            {
               clearTimeout(this.timeoutBooster);
            }
            this.timeoutBooster = null;
            return;
         }
         var _loc1_:* = 86400;
         var _loc2_:* = 3600;
         var _loc3_:* = 60;
         var _loc4_:* = this.booster_timestamp;
         var _loc5_:* = Math.floor(_loc4_ / _loc1_);
         var _loc6_:* = Math.floor((_loc4_ - _loc5_ * _loc1_) / _loc2_);
         var _loc7_:* = Math.floor((_loc4_ - _loc5_ * _loc1_ - _loc6_ * _loc2_) / _loc3_);
         this.prestigeBoosterEnd.daysTxt.text = _loc5_;
         this.prestigeBoosterEnd.hoursTxt.text = _loc6_;
         this.prestigeBoosterEnd.minutesTxt.text = _loc7_;
         this.booster_timestamp -= 10;
         this.timeoutBooster = setTimeout(this.updateBoosterTimeleft,10000);
      }
      
      public function setDisplay() : *
      {
         this.btn_clanRamen.gotoAndStop(int(this.clan_data.ramen) + 1);
         this.btn_clanHotSpring.gotoAndStop(int(this.clan_data.hot_spring) + 1);
         this.btn_clanTemple.gotoAndStop(int(this.clan_data.temple) + 1);
         this.btn_clanTrainingHall.gotoAndStop(int(this.clan_data.training_hall) + 1);
         var _loc1_:* = this.main.getPlayerHead();
         _loc1_.scaleX = 2.1;
         _loc1_.scaleY = 2.1;
         _loc1_.x += 25;
         _loc1_.y -= 15;
         OutfitManager.removeChildsFromMovieClips(this.headMc.face_mc);
         this.headMc.face_mc.addChild(_loc1_);
         var _loc2_:* = int((this.clan_data.hot_spring * 0.3 + int(1)) * StatManager.calculate_stats_with_data("hp"));
         var _loc3_:* = int((this.clan_data.temple * 0.3 + int(1)) * StatManager.calculate_stats_with_data("cp"));
         this.txt_hp.text = _loc2_ + "/" + _loc2_;
         this.txt_cp.text = _loc3_ + "/" + _loc3_;
         this.txt_name.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.txt_name);
         this.levelTxt.text = Character.character_lvl;
         this.txt_gold.text = Character.character_gold;
         this.txt_tokens.text = String(Character.account_tokens);
         this.txt_onigiri.text = Character.getMaterialAmount("material_69");
         this.txt_stamina.text = this.char_data.stamina + " / " + this.char_data.max_stamina;
         this.stamBar.scaleX = this.char_data.stamina / this.char_data.max_stamina;
         this.txt_prestige.text = this.char_data.prestige;
         var _loc4_:* = 30 + this.clan_data.ramen * 10;
         this.staminaPlusText.text = "+" + _loc4_ + "/30 min";
         this.txt_clan_name.text = this.clan_data.name;
         this.txt_rep.text = this.clan_data.reputation;
         this.txt_members.text = this.clan_data.members + " / " + this.clan_data.max_members;
         this.txt_clan_gold.text = this.clan_data.golds;
         this.txt_clan_tokens.text = this.clan_data.tokens;
      }
      
      public function addButtonListeners() : *
      {
         this.btn_ClanOnlineList.addEventListener(MouseEvent.CLICK,this.openOnlineList,false,0,true);
         this.btn_ClanOnlineList.visible = true;
         this.eventHandler.addListener(this.btn_village,MouseEvent.CLICK,this.buttonManager);
         if(this.clan_data.master_id == Character.char_id || this.clan_data.elder_id == Character.char_id)
         {
            if(this.clan_data.ramen < 4)
            {
               this.eventHandler.addListener(this.btn_clanRamen,MouseEvent.CLICK,this.buttonManager);
            }
            else if(this.btn_clanRamen.hasEventListener(MouseEvent.CLICK))
            {
               this.eventHandler.removeListener(this.btn_clanRamen,MouseEvent.CLICK,this.buttonManager);
            }
            if(this.clan_data.hot_spring < 4)
            {
               this.eventHandler.addListener(this.btn_clanHotSpring,MouseEvent.CLICK,this.buttonManager);
            }
            else if(this.btn_clanHotSpring.hasEventListener(MouseEvent.CLICK))
            {
               this.eventHandler.removeListener(this.btn_clanHotSpring,MouseEvent.CLICK,this.buttonManager);
            }
            if(this.clan_data.temple < 4)
            {
               this.eventHandler.addListener(this.btn_clanTemple,MouseEvent.CLICK,this.buttonManager);
            }
            else if(this.btn_clanTemple.hasEventListener(MouseEvent.CLICK))
            {
               this.eventHandler.removeListener(this.btn_clanTemple,MouseEvent.CLICK,this.buttonManager);
            }
            if(this.clan_data.training_hall < 4)
            {
               this.eventHandler.addListener(this.btn_clanTrainingHall,MouseEvent.CLICK,this.buttonManager);
            }
            else if(this.btn_clanTrainingHall.hasEventListener(MouseEvent.CLICK))
            {
               this.eventHandler.removeListener(this.btn_clanTrainingHall,MouseEvent.CLICK,this.buttonManager);
            }
         }
         this.eventHandler.addListener(this.btn_clanHall,MouseEvent.CLICK,this.buttonManager);
         this.eventHandler.addListener(this.btn_clanBattle,MouseEvent.CLICK,this.buttonManager);
         this.eventHandler.addListener(this.btn_staminaPanel,MouseEvent.CLICK,this.buttonManager);
         this.eventHandler.addListener(this.btn_prestigeBooster,MouseEvent.CLICK,this.buttonManager);
         this.eventHandler.addListener(this.btn_Scroll_Clan_Shop,MouseEvent.CLICK,this.openPopup);
         this.eventHandler.addListener(this.btn_clanReward,MouseEvent.CLICK,this.openClanReward);
         this.eventHandler.addListener(this.btn_fame,MouseEvent.CLICK,this.openWallOfFame);
         this.eventHandler.addListener(this.btn_repsim,MouseEvent.CLICK,this.openRepSim);
         this.eventHandler.addListener(this.btn_ClanWarLeaderboard,MouseEvent.CLICK,this.openClanWarLeaderboard);
      }
      
      public function buttonManager(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         switch(param1.currentTarget.name)
         {
            case "btn_clanHall":
               if(this.clan_hall)
               {
                  this.clan_hall.destroy();
               }
               this.clan_hall = new ClanHall(this.main,this);
               this.addChild(this.clan_hall);
               break;
            case "btn_clanBattle":
               this.battle_panel = new ClanBattle(this.main,this);
               this.addChild(this.battle_panel);
               break;
            case "btn_staminaPanel":
               _loc2_ = new ClanStamina(this.main,this);
               this.addChild(_loc2_);
               break;
            case "btn_prestigeBooster":
               _loc2_ = new ClanPrestigeBooster(this.main,this);
               this.addChild(_loc2_);
               break;
            case "btn_clanRamen":
               this.upgrade_panel = new ClanUpgrade(this.main,this);
               this.upgrade_panel.upgrading_name = "clan_ramen";
               this.upgrade_panel.showInfo(0,this.clan_data.ramen);
               this.addChild(this.upgrade_panel);
               break;
            case "btn_clanHotSpring":
               this.upgrade_panel = new ClanUpgrade(this.main,this);
               this.upgrade_panel.upgrading_name = "clan_hot_spring";
               this.upgrade_panel.showInfo(1,this.clan_data.hot_spring);
               this.addChild(this.upgrade_panel);
               break;
            case "btn_clanTemple":
               this.upgrade_panel = new ClanUpgrade(this.main,this);
               this.upgrade_panel.upgrading_name = "clan_temple";
               this.upgrade_panel.showInfo(2,this.clan_data.temple);
               this.addChild(this.upgrade_panel);
               break;
            case "btn_clanTrainingHall":
               if(this.upgrade_panel is ClanUpgrade)
               {
                  this.upgrade_panel.onClose(null);
                  this.upgrade_panel = null;
               }
               this.upgrade_panel = new ClanUpgrade(this.main,this);
               this.upgrade_panel.upgrading_name = "clan_training_hall";
               this.upgrade_panel.showInfo(3,this.clan_data.training_hall);
               this.addChild(this.upgrade_panel);
               break;
            case "btn_village":
               this.closePanel(param1);
         }
      }
      
      public function closePanel(param1:MouseEvent = null) : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         this.main.loadVillageAndHUD();
         this.destroy();
      }
      
      internal function openOnlineList(param1:MouseEvent) : *
      {
         if(this.onlinelist)
         {
            this.onlinelist.show();
            return;
         }
         this.onlinelist = new WorldChat(this.main,"clan");
         this.onlinelist.manualClose();
         this.main.loader.addChild(this.onlinelist);
      }
      
      internal function openClanReward(param1:MouseEvent) : *
      {
         var _loc2_:* = this.loaderAsset.add("http://127.0.0.1:800/api/clan/rewards");
         if(_loc2_.isLoaded)
         {
            this.onClanRewardLoaded(_loc2_);
         }
         else
         {
            _loc2_.addEventListener(Event.COMPLETE,this.onClanRewardLoaded,false,0,true);
            this.loaderAsset.start();
         }
      }
      
      internal function openWallOfFame(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.WallOfFame");
      }
      
      internal function openRepSim(param1:MouseEvent) : *
      {
         navigateToURL(new URLRequest("http://127.0.0.1:800/en/player/clan/simulator"));
      }
      
      internal function openClanWarLeaderboard(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.ClanWarLeaderboard");
      }
      
      internal function onClanRewardLoaded(param1:*) : *
      {
         var link:* = undefined;
         var e:* = param1;
         this.loaderAsset.removeEventListener(Event.COMPLETE,this.onClanRewardLoaded);
         try
         {
            link = JSON.parse(String(e.target.content));
            if("data" in link)
            {
               this.main.getPromotion(link.data);
            }
         }
         catch(e:*)
         {
            this.main.showMessage("Cannot initialize banner, please retry again");
         }
      }
      
      internal function openPanel(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Panels." + _loc2_);
      }
      
      internal function openPopup(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Popups." + _loc2_);
      }
   }
}

