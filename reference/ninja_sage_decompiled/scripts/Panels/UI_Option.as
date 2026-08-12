package Panels
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.StageDisplayState;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import flash.geom.Rectangle;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.sounds.SoundAS;
   
   public class UI_Option extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panel:MovieClip;
      
      public var main;
      
      private var unmuted:Boolean = true;
      
      private var ns_so:SharedObject;
      
      private var eventHandler:EventHandler;
      
      private var onBattle:Boolean = false;
      
      private var destroying:Boolean = false;
      
      private var volSliderDragArea:Rectangle;
      
      private const QUALITY_LIST:Array = ["LOW","MEDIUM","HIGH","BEST"];
      
      private const FPS_LIST:Array = [24,30,40];
      
      private var confirmation:Confirmation;
      
      private var original_is_new_village:Boolean;
      
      public function UI_Option(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.eventHandler = new EventHandler();
         this.main = param1;
         this.ns_so = SharedObject.getLocal("ninja_sage");
         this.original_is_new_village = Character.is_new_village;
         this.initUI();
         this.initButton();
         this.initSound();
      }
      
      public function setOnBattle() : *
      {
         this.onBattle = true;
      }
      
      private function initUI() : void
      {
         this.panel.btn_download.visible = false;
         this.panel.btn_ManageData.visible = false;
         this.panel.btn_ManageData.visible = true;
         var _loc1_:int = 0;
         while(_loc1_ < this.QUALITY_LIST.length)
         {
            this.panel["radio_" + this.QUALITY_LIST[_loc1_]].dot.visible = false;
            this.eventHandler.addListener(this.panel["radio_" + this.QUALITY_LIST[_loc1_]],MouseEvent.CLICK,this.handleQuality);
            _loc1_++;
         }
         this.panel["radio_" + this.main.stage.quality].dot.visible = true;
         var _loc2_:int = this.main.stage.frameRate;
         this.main.stage.frameRate = _loc2_ >= 40 ? 40 : (_loc2_ >= 30 && _loc2_ <= 40 ? 30 : 24);
         _loc1_ = 0;
         while(_loc1_ < this.FPS_LIST.length)
         {
            this.panel["radio_" + this.FPS_LIST[_loc1_]].dot.visible = false;
            this.eventHandler.addListener(this.panel["radio_" + this.FPS_LIST[_loc1_]],MouseEvent.CLICK,this.handleFPS);
            _loc1_++;
         }
         this.panel["radio_" + this.main.stage.frameRate].dot.visible = true;
         this.panel.txt_charId.text = Character.char_id;
         this.panel.txt_version.text = Character.build_num;
         this.panel.txt_emblem.text = Character.account_type == 1 ? "Premium User" : "Free User";
         if(int(Character.emblem_duration) > 0)
         {
            this.panel.txt_emblem.text = "Trial Emblem " + Character.emblem_duration + " Days";
         }
         var _loc3_:String = this.ns_so.data.hasOwnProperty("option_is_stickman") && this.ns_so.data.option_is_stickman ? "on" : "off";
         this.panel.toggle_stickman.gotoAndStop(_loc3_);
         var _loc4_:String = this.ns_so.data.hasOwnProperty("option_enable_bgm") && this.ns_so.data.option_enable_bgm ? "on" : "off";
         this.panel.toggle_bgm.gotoAndStop(_loc4_);
         var _loc5_:String = this.ns_so.data.hasOwnProperty("option_enable_sfx") && this.ns_so.data.option_enable_sfx ? "on" : "off";
         this.panel.toggle_sfx.gotoAndStop(_loc5_);
         var _loc6_:String = !!Character.play_items_animation ? "on" : "off";
         this.panel.toggle_itemAnims.gotoAndStop(_loc6_);
         var _loc7_:String = !!Character.intel_class_animation ? "on" : "off";
         this.panel.toggle_intelAnims.gotoAndStop(_loc7_);
         var _loc8_:String = !!Character.senjutsu_animation ? "on" : "off";
         this.panel.toggle_senjutsuAnims.gotoAndStop(_loc8_);
         var _loc9_:String = this.main.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE ? "on" : "off";
         this.panel.toggle_fullscreen.gotoAndStop(_loc9_);
         var _loc10_:String = !!Character.is_new_village ? "on" : "off";
         this.panel.toggle_village.gotoAndStop(_loc10_);
      }
      
      private function initButton() : void
      {
         this.eventHandler.addListener(this.panel.toggle_stickman,MouseEvent.CLICK,this.handleStickman);
         this.eventHandler.addListener(this.panel.toggle_itemAnims,MouseEvent.CLICK,this.handleItemAnims);
         this.eventHandler.addListener(this.panel.toggle_fullscreen,MouseEvent.CLICK,this.handleFullScreen);
         this.eventHandler.addListener(this.panel.toggle_senjutsuAnims,MouseEvent.CLICK,this.handleSenjutsuAnims);
         this.eventHandler.addListener(this.panel.toggle_intelAnims,MouseEvent.CLICK,this.handleIntelAnims);
         this.eventHandler.addListener(this.panel.toggle_village,MouseEvent.CLICK,this.handleNewVillage);
         this.eventHandler.addListener(this.panel.toggle_bgm,MouseEvent.CLICK,this.handleBGM);
         this.eventHandler.addListener(this.panel.toggle_sfx,MouseEvent.CLICK,this.handleSFX);
         this.eventHandler.addListener(this.panel.soundMc.btnMin,MouseEvent.CLICK,this.handleVolume);
         this.eventHandler.addListener(this.panel.soundMc.btnPlus,MouseEvent.CLICK,this.handleVolume);
         this.eventHandler.addListener(this.panel.soundMc.volume,MouseEvent.MOUSE_DOWN,this.dragVolSlider);
         this.eventHandler.addListener(this,MouseEvent.MOUSE_UP,this.handleVolume);
         this.eventHandler.addListener(this.panel.soundMc.btnToggleSound,MouseEvent.CLICK,this.handleMute);
         this.eventHandler.addListener(this.panel.btn_news,MouseEvent.CLICK,this.handleSocial);
         this.eventHandler.addListener(this.panel.facebookPage,MouseEvent.CLICK,this.handleSocial);
         this.eventHandler.addListener(this.panel.facebookGroup,MouseEvent.CLICK,this.handleSocial);
         this.eventHandler.addListener(this.panel.discordChannel,MouseEvent.CLICK,this.handleSocial);
         this.eventHandler.addListener(this.panel.btn_change,MouseEvent.CLICK,this.handleChangeCharacter);
         this.eventHandler.addListener(this.panel.btn_logout,MouseEvent.CLICK,this.handleLogout);
         this.eventHandler.addListener(this.panel.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panel.btn_ManageData,MouseEvent.CLICK,this.deleteDataConfirmation);
         var _loc1_:Array = [{
            "button":this.panel.hint_stickman,
            "hint":"Turn your character into stickman and will not showing any outfit that equipped."
         },{
            "button":this.panel.hint_fullscreen,
            "hint":"Set the game resolution to Full Screen."
         },{
            "button":this.panel.hint_itemAnims,
            "hint":"Disable all animation that available on equipped items such as Weapon and Back Item. Turn off for smoother gameplay."
         },{
            "button":this.panel.hint_senjutsu,
            "hint":"Disable Senjutsu Transition animation when changing from basic skill to senjutsu skill."
         },{
            "button":this.panel.hint_intel,
            "hint":"Disable Intellegence Class Intro Animation that played at every start of battle. Only works if you are using Intellegence Special Class."
         },{
            "button":this.panel.hint_village,
            "hint":"Enable New Village UI and HUD. This will replace the old Village UI and HUD."
         }];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            NinjaSage.showDynamicTooltip(_loc1_[_loc2_].button,_loc1_[_loc2_].hint);
            _loc2_++;
         }
      }
      
      private function deleteDataConfirmation(param1:MouseEvent) : void
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to delete all your data?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.deleteData);
         this.addChild(this.confirmation);
      }
      
      private function removeConfirmation(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
      }
      
      private function deleteData(param1:MouseEvent) : void
      {
         var storageDir:File = null;
         var files:Array = null;
         var f:File = null;
         var e:MouseEvent = param1;
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         storageDir = File.applicationStorageDirectory;
         if(storageDir.exists)
         {
            files = storageDir.getDirectoryListing();
            for each(f in files)
            {
               try
               {
                  if(f.isDirectory)
                  {
                     f.deleteDirectory(true);
                  }
                  else
                  {
                     f.deleteFile();
                  }
               }
               catch(err:Error)
               {
                  continue;
               }
            }
         }
         this.handleLogout(null);
      }
      
      private function handleQuality(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name.replace("radio_","");
         var _loc3_:int = 0;
         while(_loc3_ < this.QUALITY_LIST.length)
         {
            this.panel["radio_" + this.QUALITY_LIST[_loc3_]].dot.visible = false;
            _loc3_++;
         }
         this.panel["radio_" + _loc2_].dot.visible = true;
         this.main.stage.quality = StageQuality[_loc2_];
      }
      
      private function handleFPS(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget.name.replace("radio_","");
         var _loc3_:int = 0;
         while(_loc3_ < this.FPS_LIST.length)
         {
            this.panel["radio_" + this.FPS_LIST[_loc3_]].dot.visible = false;
            _loc3_++;
         }
         this.panel["radio_" + _loc2_].dot.visible = true;
         this.main.stage.frameRate = _loc2_;
      }
      
      private function handleStickman(param1:MouseEvent) : void
      {
         var _loc2_:String = this.panel.toggle_stickman.currentFrameLabel == "off" ? "on" : "off";
         this.panel.toggle_stickman.gotoAndStop(_loc2_);
         Character.is_stickman = _loc2_ == "off" ? false : true;
         if(this.onBattle)
         {
            this.main.getNotice("\nThe setting will be applied on the next battle");
         }
      }
      
      private function handleItemAnims(param1:MouseEvent) : void
      {
         var _loc2_:String = this.panel.toggle_itemAnims.currentFrameLabel == "off" ? "on" : "off";
         this.panel.toggle_itemAnims.gotoAndStop(_loc2_);
         Character.play_items_animation = _loc2_ == "off" ? false : true;
         if(this.onBattle)
         {
            this.main.getNotice("\nThe setting will be applied on the next battle");
         }
      }
      
      private function handleIntelAnims(param1:MouseEvent) : void
      {
         var _loc2_:String = this.panel.toggle_intelAnims.currentFrameLabel == "off" ? "on" : "off";
         this.panel.toggle_intelAnims.gotoAndStop(_loc2_);
         Character.intel_class_animation = _loc2_ == "off" ? false : true;
         if(this.onBattle)
         {
            this.main.getNotice("\nThe setting will be applied on the next battle");
         }
      }
      
      private function handleSenjutsuAnims(param1:MouseEvent) : void
      {
         var _loc2_:String = this.panel.toggle_senjutsuAnims.currentFrameLabel == "off" ? "on" : "off";
         this.panel.toggle_senjutsuAnims.gotoAndStop(_loc2_);
         Character.senjutsu_animation = _loc2_ == "off" ? false : true;
      }
      
      private function handleFullScreen(param1:MouseEvent) : void
      {
         var _loc2_:String = this.panel.toggle_fullscreen.currentFrameLabel == "off" ? "on" : "off";
         this.panel.toggle_fullscreen.gotoAndStop(_loc2_);
         if(this.main.stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.main.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
         else
         {
            this.main.stage.displayState = StageDisplayState.NORMAL;
         }
      }
      
      private function handleBGM(param1:MouseEvent) : void
      {
         this.ns_so.data.option_enable_bgm = !!this.ns_so.data.option_enable_bgm ? false : true;
         this.main.bgm_enabled = this.ns_so.data.option_enable_bgm;
         if(this.main.bgm_enabled)
         {
            this.main.startBgm(!!this.onBattle ? "battle" : (!!Character.is_new_village ? "new_bgm" : "bgm"));
         }
         else
         {
            this.main.stopAllBgm();
         }
         var _loc2_:String = this.panel.toggle_bgm.currentFrameLabel == "off" ? "on" : "off";
         this.panel.toggle_bgm.gotoAndStop(_loc2_);
      }
      
      private function handleSFX(param1:MouseEvent) : void
      {
         this.ns_so.data.option_enable_sfx = !!this.ns_so.data.option_enable_sfx ? false : true;
         SoundAS.enableSfx = this.ns_so.data.option_enable_sfx;
         var _loc2_:String = this.panel.toggle_sfx.currentFrameLabel == "off" ? "on" : "off";
         this.panel.toggle_sfx.gotoAndStop(_loc2_);
      }
      
      private function handleNewVillage(param1:MouseEvent) : void
      {
         var _loc2_:String = !!this.onBattle ? "The village ui will be changed after the battle" : "The village ui will be changed after closing the option menu";
         this.main.getNotice(_loc2_);
         var _loc3_:String = this.panel.toggle_village.currentFrameLabel == "off" ? "on" : "off";
         this.panel.toggle_village.gotoAndStop(_loc3_);
         Character.is_new_village = _loc3_ == "off" ? false : true;
      }
      
      private function initSound() : void
      {
         var _loc1_:Number = this.ns_so.data.option_volume != null ? Number(this.ns_so.data.option_volume) : Number(1);
         this.panel.soundMc.volume.slider.x = _loc1_ * 145;
         this.unmuted = _loc1_ > 0;
         SoundMixer.soundTransform = new SoundTransform(this.panel.soundMc.volume.slider.x / 145);
         this.volSliderDragArea = new Rectangle(this.panel.soundMc.volume.width - 3,this.panel.soundMc.volume.y - 25,-this.panel.soundMc.volume.width + 3,0);
      }
      
      private function handleVolume(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "btnPlus")
         {
            if(this.panel.soundMc.volume.slider.x < 145)
            {
               this.panel.soundMc.volume.slider.x += 14.5;
            }
         }
         else if(param1.currentTarget.name == "btnMin")
         {
            if(this.panel.soundMc.volume.slider.x > 0)
            {
               this.panel.soundMc.volume.slider.x -= 14.5;
            }
         }
         else
         {
            param1.currentTarget.stopDrag();
         }
         if(this.panel.soundMc.volume.slider.x <= 0)
         {
            this.panel.soundMc.volume.slider.x = 0;
         }
         else if(this.panel.soundMc.volume.slider.x >= 145)
         {
            this.panel.soundMc.volume.slider.x = 145;
         }
         var _loc2_:* = (this.panel.soundMc.volume.slider.x / 145).toFixed(2);
         SoundMixer.soundTransform = new SoundTransform(_loc2_);
      }
      
      private function dragVolSlider(param1:MouseEvent) : void
      {
         param1.currentTarget.parent.volume.slider.startDrag(false,this.volSliderDragArea);
      }
      
      private function handleMute(param1:MouseEvent) : void
      {
         this.unmuted = !this.unmuted;
         if(!this.unmuted)
         {
            this.panel.soundMc.volume.slider.x = 0;
            this.main.showMessage("Sound Off");
         }
         else
         {
            this.main.showMessage("Sound On");
            this.panel.soundMc.volume.slider.x = 145;
         }
         SoundMixer.soundTransform = new SoundTransform(this.panel.soundMc.volume.slider.x / 145);
      }
      
      private function handleChangeCharacter(param1:MouseEvent) : void
      {
         Character.resetBattleInfo(this.main);
         this.main.removeAllChildsFromLoader();
         this.main.removeAllLoadedPanels();
         this.main.loadPanel("Panels.CharacterSelect");
         this.closePanel();
      }
      
      private function handleLogout(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("LOGOUT"));
         this.onBattle = false;
         Character.resetBattleInfo(this.main);
         if(this.main)
         {
            this.main.removeAllChildsFromLoader();
            this.main.removeAllLoadedPanels();
            this.main.loadPanel("Managers.LoginManager");
         }
         this.closePanel();
      }
      
      private function handleSocial(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         if(_loc2_ == "facebookPage")
         {
            navigateToURL(new URLRequest("https://www.facebook.com/NinjaSage.ID"));
         }
         else if(_loc2_ == "facebookGroup")
         {
            navigateToURL(new URLRequest("https://www.facebook.com/groups/ninjasage/"));
         }
         else if(_loc2_ == "discordChannel")
         {
            navigateToURL(new URLRequest("https://dc.ninjasage.id/"));
         }
         else if(_loc2_ == "txt_help")
         {
            navigateToURL(new URLRequest("https://dc.ninjasage.id/"));
         }
         else if(_loc2_ == "btn_news")
         {
            navigateToURL(new URLRequest("https://ninjasage.id/news"));
         }
      }
      
      private function closePanel(param1:MouseEvent = null) : void
      {
         if(this.ns_so)
         {
            this.ns_so.data.option_volume = SoundMixer.soundTransform.volume;
            this.ns_so.data.option_quality = this.main.stage.quality;
            this.ns_so.data.option_framerate = this.main.stage.frameRate;
            this.ns_so.data.option_is_stickman = Character.is_stickman;
            this.ns_so.data.option_item_animation = Character.play_items_animation;
            this.ns_so.data.option_intel_animation = Character.intel_class_animation;
            this.ns_so.data.option_senjutsu_animation = Character.senjutsu_animation;
            this.ns_so.data.option_enable_sfx = SoundAS.enableSfx;
            this.ns_so.data.option_is_new_village = Character.is_new_village;
            this.ns_so.flush();
            this.ns_so = null;
         }
         if(Character.is_new_village != this.original_is_new_village && !this.onBattle)
         {
            this.main.removeAllChildsFromLoader();
            this.main.removeAllLoadedPanels();
            this.main.loadVillageAndHUD();
         }
         this.destroy();
         GF.removeAllChild(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         if(this.destroying)
         {
            return;
         }
         this.destroying = true;
         if(this.main && !this.onBattle && this.main.combat != null)
         {
            this.main.combat.destroy();
            this.main.combat = null;
         }
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
         }
         this.volSliderDragArea = null;
         this.eventHandler = null;
         this.main = null;
         this.panel = null;
         this.ns_so = null;
         System.gc();
         for each(_loc1_ in ["combat","assets","skills","specialclass","talents","panels","etc"])
         {
            BulkLoader.getLoader(_loc1_).removeAll();
         }
      }
   }
}
