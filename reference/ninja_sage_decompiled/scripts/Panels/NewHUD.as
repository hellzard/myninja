package Panels
{
   import Managers.NinjaSage;
   import Managers.StatManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public class NewHUD extends MovieClip
   {
       
      
      public var btn_AnniversarySkillSelection:SimpleButton;
      
      public var btn_DailyActivities:SimpleButton;
      
      public var btn_Featured:SimpleButton;
      
      public var btn_Headquarter:SimpleButton;
      
      public var btn_New_Pets:SimpleButton;
      
      public var btn_New_UI_Skillset:SimpleButton;
      
      public var btn_RMPackages:SimpleButton;
      
      public var btn_SeasonalPackage:SimpleButton;
      
      public var btn_SenjutsuProfile:SimpleButton;
      
      public var btn_SpecialOffer:SimpleButton;
      
      public var btn_WorldChat:SimpleButton;
      
      public var dailyExpandMC:MovieClip;
      
      public var featuredExpandMC:MovieClip;
      
      public var lvStatusBar:MovieClip;
      
      public var notification:MovieClip;
      
      public var rmExpandMC:MovieClip;
      
      public var seasonalExpandMC:MovieClip;
      
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
      
      public var btn_New_UI_Gear:SimpleButton;
      
      public var btn_New_UI_Profile:SimpleButton;
      
      public var btn_UI_Skillset:SimpleButton;
      
      public var buyTokens:SimpleButton;
      
      public var btn_ChuninPackages:SimpleButton;
      
      public var frame:MovieClip;
      
      public var txt_gold:TextField;
      
      public var rekrut:TextField;
      
      public var txt_token:TextField;
      
      public var main;
      
      public var stat_manager:StatManager;
      
      public var swf_loading = "";
      
      public var worldchat;
      
      public var eventHandler;
      
      public function NewHUD(param1:*)
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
         this.btn_ChuninPackages.visible = false;
         this.featuredExpandMC.btn_LimitedStore.visible = false;
         this.featuredExpandMC.btn_SpecialDeals.visible = false;
         this.rmExpandMC.btn_ChaosArchangelPackage.visible = false;
         this.seasonalExpandMC.btn_RamadhanPackage.visible = false;
         this.seasonalExpandMC.btn_AnniversaryClothing.visible = false;
         this.btn_AnniversarySkillSelection.visible = false;
         this.eventHandler.addListener(this.btn_New_UI_Profile,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_TalentPanel,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_SenjutsuProfile,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.btn_EventMenu,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.btn_New_UI_Gear,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_New_UI_Skillset,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_UI_Option,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_New_Pets,MouseEvent.CLICK,this.petLock,false,0,true);
         this.eventHandler.addListener(this.btn_Mailbox,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.btn_WorldChat,MouseEvent.CLICK,this.openChat,false,0,true);
         this.eventHandler.addListener(this.btn_Featured,MouseEvent.CLICK,this.expandFeatured,false,0,true);
         this.eventHandler.addListener(this.btn_DailyActivities,MouseEvent.CLICK,this.expandDaily,false,0,true);
         this.eventHandler.addListener(this.btn_SeasonalPackage,MouseEvent.CLICK,this.expandSeasonal,false,0,true);
         this.eventHandler.addListener(this.btn_RMPackages,MouseEvent.CLICK,this.expandRM,false,0,true);
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
         if(Character.hide_event.indexOf("ramadhan2026") > -1)
         {
            this.seasonalExpandMC.btn_RamadhanPackage.visible = true;
            this.eventHandler.addListener(this.seasonalExpandMC.btn_RamadhanPackage,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.hide_event.indexOf("anniv2026") > -1)
         {
            this.seasonalExpandMC.btn_AnniversaryClothing.visible = true;
            this.eventHandler.addListener(this.seasonalExpandMC.btn_AnniversaryClothing,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(this.getSkillSelectionVisible())
         {
            this.btn_AnniversarySkillSelection.visible = true;
            this.eventHandler.addListener(this.btn_AnniversarySkillSelection,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.hide_event.indexOf("chaosarchangel") > -1)
         {
            this.rmExpandMC.btn_ChaosArchangelPackage.visible = true;
            this.eventHandler.addListener(this.rmExpandMC.btn_ChaosArchangelPackage,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.hide_event.indexOf("mysterious-market") > -1)
         {
            this.featuredExpandMC.btn_LimitedStore.visible = true;
            this.eventHandler.addListener(this.featuredExpandMC.btn_LimitedStore,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         if(Character.hide_event.indexOf("special-deals") > -1)
         {
            this.featuredExpandMC.btn_SpecialDeals.visible = true;
            this.eventHandler.addListener(this.featuredExpandMC.btn_SpecialDeals,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         }
         this.eventHandler.addListener(this.featuredExpandMC.btn_ContestShop,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.btn_Recharge,MouseEvent.CLICK,this.openRecharge,false,0,true);
         this.eventHandler.addListener(this.btn_Headquarter,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.buyTokens,MouseEvent.CLICK,this.openRecharge);
         this.eventHandler.addListener(this.btn_Social,MouseEvent.CLICK,this.openSocial,false,0,true);
         this.eventHandler.addListener(this.btn_WelcomeLogin,MouseEvent.CLICK,this.openExternalPanel,false,0,true);
         this.eventHandler.addListener(this.dailyExpandMC.btn_DailyScratch,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.dailyExpandMC.btn_DailyRoulette,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.dailyExpandMC.btn_DailyStamp,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.eventHandler.addListener(this.dailyExpandMC.btn_DailyRewards,MouseEvent.CLICK,this.openPanel,false,0,true);
         this.handleExpandFrameScript();
         this.loadFrame();
         this.setBasicData();
         this.checkNotification();
      }
      
      public function expandFeatured(param1:MouseEvent) : void
      {
         if(this.featuredExpandMC.currentFrame > 1)
         {
            this.featuredExpandMC.gotoAndPlay("close");
            return;
         }
         this.featuredExpandMC.visible = true;
         this.featuredExpandMC.gotoAndPlay(1);
         this.closeAllExpanded();
         this.featuredExpandMC.bg.visible = true;
         this.eventHandler.addListener(this.featuredExpandMC.bg,MouseEvent.CLICK,this.closeAllExpanded,false,0,true);
      }
      
      public function expandDaily(param1:MouseEvent) : void
      {
         if(this.dailyExpandMC.currentFrame > 1)
         {
            this.dailyExpandMC.gotoAndPlay("close");
            return;
         }
         this.dailyExpandMC.visible = true;
         this.dailyExpandMC.gotoAndPlay(1);
         this.closeAllExpanded();
         this.dailyExpandMC.bg.visible = true;
         this.eventHandler.addListener(this.dailyExpandMC.bg,MouseEvent.CLICK,this.closeAllExpanded,false,0,true);
      }
      
      public function expandSeasonal(param1:MouseEvent) : void
      {
         if(this.seasonalExpandMC.currentFrame > 1)
         {
            this.seasonalExpandMC.gotoAndPlay("close");
            return;
         }
         this.seasonalExpandMC.visible = true;
         this.seasonalExpandMC.gotoAndPlay(1);
         this.closeAllExpanded();
         this.seasonalExpandMC.bg.visible = true;
         this.eventHandler.addListener(this.seasonalExpandMC.bg,MouseEvent.CLICK,this.closeAllExpanded,false,0,true);
      }
      
      public function expandRM(param1:MouseEvent) : void
      {
         if(this.rmExpandMC.currentFrame > 1)
         {
            this.rmExpandMC.gotoAndPlay("close");
            return;
         }
         this.rmExpandMC.visible = true;
         this.rmExpandMC.gotoAndPlay(1);
         this.closeAllExpanded();
         this.rmExpandMC.bg.visible = true;
         this.eventHandler.addListener(this.rmExpandMC.bg,MouseEvent.CLICK,this.closeAllExpanded,false,0,true);
      }
      
      public function closeAllExpanded(param1:MouseEvent = null) : void
      {
         if(this.featuredExpandMC.currentFrame > 1)
         {
            this.featuredExpandMC.gotoAndPlay("close");
         }
         if(this.dailyExpandMC.currentFrame > 1)
         {
            this.dailyExpandMC.gotoAndPlay("close");
         }
         if(this.seasonalExpandMC.currentFrame > 1)
         {
            this.seasonalExpandMC.gotoAndPlay("close");
         }
         if(this.rmExpandMC.currentFrame > 1)
         {
            this.rmExpandMC.gotoAndPlay("close");
         }
         this.featuredExpandMC.bg.visible = false;
         this.dailyExpandMC.bg.visible = false;
         this.seasonalExpandMC.bg.visible = false;
         this.rmExpandMC.bg.visible = false;
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
      
      function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         if(_loc2_ == "SenjutsuProfile" && int(Character.character_lvl) <= 80 && int(Character.character_rank) < 8)
         {
            this.main.getNotice("Must clear Senior Ninja Tutor Exam first!");
            return;
         }
         if(_loc2_ == "ChaosArchangelPackage")
         {
            this.main.loadExternalSwfPanel("ChaosArchangelPackage","ChaosArchangelPackage");
            return;
         }
         this.main.loadExternalSwfPanel(_loc2_,_loc2_);
      }
      
      function openChat(param1:MouseEvent) : *
      {
         this.worldchat = new WorldChat(this.main);
         this.main.loader.addChild(this.worldchat);
      }
      
      function openRecharge(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      function openSocial(param1:MouseEvent) : void
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
      
      function openPanel(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         if(_loc2_ == "TalentPanel" && int(Character.character_lvl) <= 40 && int(Character.character_rank) < 4)
         {
            this.main.getNotice("Must clear Jounin Exam first!");
            return;
         }
         if(_loc2_ == "DailyRewards" && Character.account_type == 0)
         {
            this.main.getNotice("You must be an emblem user to open daily rewards");
            return;
         }
         if(_loc2_ == "Mailbox")
         {
            this.main.loadPanel("Panels.NewMailbox");
            return;
         }
         this.main.loadPanel("Panels." + _loc2_);
      }
      
      function petLock(param1:MouseEvent) : void
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
               _loc4_ = (_loc7_ = String(40 - int(Character.character_lvl))) + " levels to go";
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
               _loc4_ = (_loc7_ = String(60 - int(Character.character_lvl))) + " levels to go";
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
               _loc4_ = (_loc7_ = String(80 - int(Character.character_lvl))) + " levels to go";
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
      
      public function handleExpandFrameScript() : void
      {
         this.featuredExpandMC.visible = false;
         this.dailyExpandMC.visible = false;
         this.seasonalExpandMC.visible = false;
         this.rmExpandMC.visible = false;
         this.featuredExpandMC.bg.visible = false;
         this.dailyExpandMC.bg.visible = false;
         this.seasonalExpandMC.bg.visible = false;
         this.rmExpandMC.bg.visible = false;
         this.featuredExpandMC.gotoAndStop(1);
         var featuredFramesOpen:Object = NinjaSage.getLabelFrames(this.featuredExpandMC,"open");
         var featuredFramesClose:Object = NinjaSage.getLabelFrames(this.featuredExpandMC,"close");
         this.featuredExpandMC.addFrameScript(featuredFramesOpen.end,function():void
         {
            featuredExpandMC.stop();
         });
         this.featuredExpandMC.addFrameScript(featuredFramesClose.end - 1,function():void
         {
            featuredExpandMC.gotoAndStop(1);
            featuredExpandMC.visible = false;
         });
         this.dailyExpandMC.gotoAndStop(1);
         var dailyFramesOpen:Object = NinjaSage.getLabelFrames(this.dailyExpandMC,"open");
         var dailyFramesClose:Object = NinjaSage.getLabelFrames(this.dailyExpandMC,"close");
         this.dailyExpandMC.addFrameScript(dailyFramesOpen.end,function():void
         {
            dailyExpandMC.stop();
         });
         this.dailyExpandMC.addFrameScript(dailyFramesClose.end - 1,function():void
         {
            dailyExpandMC.gotoAndStop(1);
            dailyExpandMC.visible = false;
         });
         this.seasonalExpandMC.gotoAndStop(1);
         var seasonalFramesOpen:Object = NinjaSage.getLabelFrames(this.seasonalExpandMC,"open");
         var seasonalFramesClose:Object = NinjaSage.getLabelFrames(this.seasonalExpandMC,"close");
         this.seasonalExpandMC.addFrameScript(seasonalFramesOpen.end,function():void
         {
            seasonalExpandMC.stop();
         });
         this.seasonalExpandMC.addFrameScript(seasonalFramesClose.end - 1,function():void
         {
            seasonalExpandMC.gotoAndStop(1);
            seasonalExpandMC.visible = false;
         });
         this.rmExpandMC.gotoAndStop(1);
         var rmFramesOpen:Object = NinjaSage.getLabelFrames(this.rmExpandMC,"open");
         var rmFramesClose:Object = NinjaSage.getLabelFrames(this.rmExpandMC,"close");
         this.rmExpandMC.addFrameScript(rmFramesOpen.end,function():void
         {
            rmExpandMC.stop();
         });
         this.rmExpandMC.addFrameScript(rmFramesClose.end - 1,function():void
         {
            rmExpandMC.gotoAndStop(1);
            rmExpandMC.visible = false;
         });
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
