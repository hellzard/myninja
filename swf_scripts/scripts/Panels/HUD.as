package Panels
{
   import Managers.StatManager;
   import NinjaSage_fla.Symbol576_390;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5976")]
   public class HUD extends MovieClip
   {
      
      public var btn_AnniversaryClothing:SimpleButton;
      
      public var btn_AnniversarySkillSelection:SimpleButton;
      
      public var btn_ChaosArchangelPackage:SimpleButton;
      
      public var btn_DailyScratch:SimpleButton;
      
      public var btn_Headquarter:SimpleButton;
      
      public var btn_SenjutsuProfile:SimpleButton;
      
      public var btn_SpecialOffer:SimpleButton;
      
      public var btn_WorldChat:SimpleButton;
      
      public var lvStatusBar:Symbol576_390;
      
      public var notification:MovieClip;
      
      public var worldChatHolder:MovieClip;
      
      public var btn_Pets:SimpleButton;
      
      public var btn_TalentPanel:SimpleButton;
      
      public var btn_EventMenu:SimpleButton;
      
      public var btn_ChuninExam:SimpleButton;
      
      public var btn_JouninExam:SimpleButton;
      
      public var btn_SpecialJouninExam:SimpleButton;
      
      public var btn_NinjaTutorExam:SimpleButton;
      
      public var btn_Mailbox:SimpleButton;
      
      public var btn_WelcomeLogin:SimpleButton;
      
      public var btn_Recharge:SimpleButton;
      
      public var btn_Social:SimpleButton;
      
      public var btn_UI_Option:SimpleButton;
      
      public var btn_UI_Gear:SimpleButton;
      
      public var btn_UI_Profile:SimpleButton;
      
      public var btn_UI_Skillset:SimpleButton;
      
      public var btn_DailyRewards:SimpleButton;
      
      public var btn_DailyRoulette:SimpleButton;
      
      public var buy_Headquarter:SimpleButton;
      
      public var buy_DailyScratch:SimpleButton;
      
      public var btn_DailyStamp:SimpleButton;
      
      public var buyTokens:SimpleButton;
      
      public var btn_LimitedStore:SimpleButton;
      
      public var btn_ChuninPackages:SimpleButton;
      
      public var btn_MekkorvathPackage:SimpleButton;
      
      public var btn_SpecialDeals:SimpleButton;
      
      public var btn_Notification:SimpleButton;
      
      public var frame:MovieClip;
      
      public var txt_gold:TextField;
      
      public var rekrut:TextField;
      
      public var txt_token:TextField;
      
      public var main:*;
      
      public var stat_manager:StatManager;
      
      public var swf_loading:* = "";
      
      public var worldchat:*;
      
      public var eventHandler:*;
      
      public function HUD(param1:*)
      {
         System.gc();
         this.stat_manager = new StatManager(this);
         this.eventHandler = new EventHandler();
         super();
         this.main = param1;
         this.lvStatusBar.visible = true;
         this.btn_ChuninExam.visible = false;
         this.btn_JouninExam.visible = false;
         this.btn_SpecialJouninExam.visible = false;
         this.btn_NinjaTutorExam.visible = false;
         this.btn_LimitedStore.visible = false;
         this.btn_ChuninPackages.visible = false;
         this.btn_SpecialDeals.visible = false;
         this.btn_Notification.visible = false;
         this.btn_ChaosArchangelPackage.visible = false;
         this.btn_AnniversaryClothing.visible = false;
         this.btn_AnniversarySkillSelection.visible = false;
         this.btn_Recharge.visible = false;
         this.eventHandler.addListener(this.btn_UI_Profile,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_TalentPanel,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_SenjutsuProfile,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.btn_EventMenu,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.btn_UI_Gear,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_UI_Skillset,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_DailyScratch,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_DailyRoulette,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_DailyStamp,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_UI_Option,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_Pets,MouseEvent.CLICK,this.petLock,false,0,true);
         this.eventHandler.addListener(this.btn_Mailbox,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_Notification,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.btn_WorldChat,MouseEvent.CLICK,this.openChat,false,0,true);
         if(int(Character.character_lvl) == 20 && int(Character.character_rank) == 1)
         {
            this.btn_ChuninExam.visible = true;
            this.btn_ChuninPackages.visible = true;
            this.eventHandler.addListener(this.btn_ChuninPackages,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
            this.eventHandler.addListener(this.btn_ChuninExam,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(int(Character.character_lvl) == 40 && int(Character.character_rank) == 3)
         {
            this.btn_JouninExam.visible = true;
            this.eventHandler.addListener(this.btn_JouninExam,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(int(Character.character_lvl) == 60 && int(Character.character_rank) == 5)
         {
            this.btn_SpecialJouninExam.visible = true;
            this.eventHandler.addListener(this.btn_SpecialJouninExam,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(int(Character.character_lvl) == 80 && int(Character.character_rank) == 7)
         {
            this.btn_NinjaTutorExam.visible = true;
            this.eventHandler.addListener(this.btn_NinjaTutorExam,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.welcome_status == 1)
         {
            this.btn_WelcomeLogin.visible = false;
            this.btn_WelcomeLogin.removeEventListener(MouseEvent.CLICK,this.openExternalPanel);
         }
         else
         {
            this.btn_WelcomeLogin.visible = true;
            this.eventHandler.addListener(this.btn_WelcomeLogin,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.features.indexOf("special-offer") > -1)
         {
            this.btn_SpecialOffer.visible = true;
            this.eventHandler.addListener(this.btn_SpecialOffer,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         else
         {
            this.btn_SpecialOffer.visible = false;
            this.btn_SpecialOffer.removeEventListener(MouseEvent.CLICK,this.openExternalPanel);
         }
         if(Character.hide_event.indexOf("mysterious-market") > -1)
         {
            this.btn_LimitedStore.visible = true;
            this.eventHandler.addListener(this.btn_LimitedStore,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.hide_event.indexOf("special-deals") > -1)
         {
            this.btn_SpecialDeals.visible = true;
            this.eventHandler.addListener(this.btn_SpecialDeals,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.hide_event.indexOf("anniv2026") > -1)
         {
            this.btn_AnniversaryClothing.visible = true;
            this.eventHandler.addListener(this.btn_AnniversaryClothing,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(this.getSkillSelectionVisible())
         {
            this.btn_AnniversarySkillSelection.visible = true;
            this.eventHandler.addListener(this.btn_AnniversarySkillSelection,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.hide_event.indexOf("chaosarchangel") > -1)
         {
            this.btn_ChaosArchangelPackage.visible = true;
            this.eventHandler.addListener(this.btn_ChaosArchangelPackage,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         this.eventHandler.addListener(this.btn_Recharge,MouseEvent.CLICK,this.openRecharge,false,0,true);
         this.eventHandler.addListener(this.btn_Headquarter,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.buyTokens,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.btn_Social,MouseEvent.CLICK,this.openSocial,false,0,true);
         this.eventHandler.addListener(this.btn_WelcomeLogin,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.dailyRewards();
         this.loadFrame();
         this.setBasicData();
         this.checkNotification();
      }
      
      public function getSkillSelectionVisible() : Boolean
      {
         var _loc1_:Array = Character.event_data.features;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].panel == "AnniversarySkillSelection")
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      internal function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         if(_loc2_ == "SenjutsuProfile" && int(Character.character_lvl) <= 80 && int(Character.character_rank) < 8)
         {
            this.main.getNotice("Must clear Senior Ninja Tutor Exam first!");
            return;
         }
         if(_loc2_ == "MekkorvathPackage")
         {
            this.main.loadExternalSwfPanel("ElementalArsPackage","ElementalArsPackage");
            return;
         }
         if(_loc2_ == "TaixiouMountainPackage")
         {
            this.main.loadExternalSwfPanel("TaixiouMountainPackage","TaixiouMountainPackage");
            return;
         }
         this.main.loadExternalSwfPanel(_loc2_,_loc2_);
      }
      
      internal function openChat(param1:MouseEvent) : *
      {
         this.worldchat = new WorldChat(this.main);
         this.main.loader.addChild(this.worldchat);
      }
      
      internal function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      internal function openSocial(param1:MouseEvent) : void
      {
         this.main.loadExternalSwfPanel("Social","Social");
      }
      
      public function loadFrame() : void
      {
         this.frame.txt_name.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.frame.txt_name);
         this.frame.txt_lvl.text = Character.character_lvl;
         this.frame.txt_hp.text = StatManager.calculate_stats_with_data("hp") + " / " + StatManager.calculate_stats_with_data("hp");
         this.frame.txt_cp.text = StatManager.calculate_stats_with_data("cp") + " / " + StatManager.calculate_stats_with_data("cp");
         this.frame.txt_xp.text = int(Character.character_xp) + " / " + String(this.stat_manager.calculate_xp(int(Character.character_lvl)));
         this.frame.txt_sp.text = "0 / " + StatManager.calculate_stats_with_data("sp");
         this.frame.spBar.scaleX = 0;
         var _loc1_:* = int(this.stat_manager.calculate_xp(int(Character.character_lvl)));
         this.frame.xpBar.scaleX = Math.max(Math.min(int(Character.character_xp) / _loc1_,1),0);
         if(int(Character.character_lvl) <= 80 && int(Character.character_rank) < 8)
         {
            this.frame.txt_sp.visible = false;
            this.frame.spBar.visible = false;
            this.frame.spBarBg.visible = false;
            this.frame.spIcon.visible = false;
            this.frame.black_bg.height = 38.45;
         }
      }
      
      internal function openPanel(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         if(_loc2_ == "TalentPanel" && int(Character.character_lvl) <= 40 && int(Character.character_rank) < 4)
         {
            this.main.getNotice("Must clear Jounin Exam first!");
            return;
         }
         this.main.loadPanel("Panels." + _loc2_);
      }
      
      internal function petLock(param1:MouseEvent) : void
      {
         if(int(Character.character_lvl) < 20 && int(Character.character_rank) < 2)
         {
            this.main.getNotice("You must be atleast chunin or higher rank to open pet");
         }
         else
         {
            this.openPanel(param1);
         }
      }
      
      internal function dailyRewards() : void
      {
         if(Character.account_type == 0)
         {
            this.btn_DailyRewards.visible = false;
         }
         else
         {
            this.eventHandler.addListener(this.btn_DailyRewards,MouseEvent.CLICK,this.openPanel,false,0,true);
         }
      }
      
      public function setBasicData() : void
      {
         this.txt_gold.text = String(Character.character_gold);
         this.txt_token.text = String(Character.account_tokens);
         this.rekrut.text = Character.character_recruit_ids.length + "/2";
         var _loc1_:* = "lv" + Character.character_lvl;
         var _loc2_:* = "Genin";
         var _loc3_:* = "Chunin";
         var _loc4_:* = String(20 - int(Character.character_lvl)) + " levels to go";
         var _loc5_:* = "rank1";
         var _loc6_:* = "rank3";
         var _loc7_:* = 0;
         if(int(Character.character_lvl) >= 20)
         {
            _loc1_ = "lv0";
            _loc4_ = "20 levels to go";
            _loc5_ = "rank" + Character.character_rank;
            _loc2_ = "Chunin";
            _loc6_ = "rank5";
            _loc3_ = "Jounin";
            if(int(Character.character_lvl) == 20)
            {
               if(int(Character.character_rank) < 2)
               {
                  _loc4_ = "Take the exam now!";
                  _loc1_ = "lv20";
                  _loc5_ = "rank1";
                  _loc2_ = "Genin";
                  _loc6_ = "rank3";
                  _loc3_ = "Chunin";
               }
            }
            else
            {
               _loc7_ = String(40 - int(Character.character_lvl));
               _loc4_ = _loc7_ + " levels to go";
               _loc7_ = 20 - _loc7_;
               _loc1_ = "lv" + _loc7_;
            }
         }
         if(int(Character.character_lvl) >= 40)
         {
            _loc1_ = "lv0";
            _loc4_ = "20 levels to go";
            _loc5_ = "rank" + Character.character_rank;
            _loc2_ = "Jounin";
            _loc6_ = "rank7";
            _loc3_ = "Special Jounin";
            if(int(Character.character_lvl) == 40)
            {
               if(int(Character.character_rank) < 4)
               {
                  _loc4_ = "Take the exam now!";
                  _loc1_ = "lv20";
                  _loc5_ = "rank3";
                  _loc2_ = "Chunin";
                  _loc6_ = "rank5";
                  _loc3_ = "Jounin";
               }
            }
            else
            {
               _loc7_ = String(60 - int(Character.character_lvl));
               _loc4_ = _loc7_ + " levels to go";
               _loc7_ = 20 - _loc7_;
               _loc1_ = "lv" + _loc7_;
            }
         }
         if(int(Character.character_lvl) >= 60)
         {
            _loc1_ = "lv0";
            _loc4_ = "20 levels to go";
            _loc5_ = "rank" + Character.character_rank;
            _loc2_ = "Special Jounin";
            _loc6_ = "rank9";
            _loc3_ = "Ninja Tutor";
            if(int(Character.character_lvl) == 60)
            {
               if(int(Character.character_rank) < 6)
               {
                  _loc4_ = "Take the exam now!";
                  _loc1_ = "lv20";
                  _loc5_ = "rank5";
                  _loc2_ = "Jounin";
                  _loc6_ = "rank7";
                  _loc3_ = "Special Jounin";
               }
            }
            else
            {
               _loc7_ = String(80 - int(Character.character_lvl));
               _loc4_ = _loc7_ + " levels to go";
               _loc7_ = 20 - _loc7_;
               _loc1_ = "lv" + _loc7_;
               if(int(Character.character_lvl) == 80)
               {
                  _loc4_ = "Take the exam now!";
               }
               if(int(Character.character_lvl) >= 80 && int(Character.character_rank) >= 8)
               {
                  this.lvStatusBar.visible = false;
               }
            }
         }
         try
         {
            this.lvStatusBar.bar.gotoAndStop(_loc1_);
            this.lvStatusBar.bar.rankbasetxt.text = _loc2_;
            this.lvStatusBar.bar.ranktxt.text = _loc3_;
            this.lvStatusBar.bar.txt.text = _loc4_;
            this.lvStatusBar.bar.iconBase.gotoAndStop(_loc5_);
            this.lvStatusBar.bar.icon.gotoAndStop(_loc6_);
         }
         catch(e:*)
         {
         }
      }
      
      public function checkNotification() : void
      {
         if(Character.has_notification == true)
         {
            this.notification.visible = true;
         }
         else
         {
            this.notification.visible = false;
         }
      }
      
      public function destroy() : *
      {
         Log.debug(this,"DESTROY");
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         this.stat_manager = null;
         this.swf_loading = null;
         if(this.worldchat)
         {
            this.worldchat.destroy();
         }
         this.worldchat = null;
         GF.removeAllChild(this);
      }
   }
}

