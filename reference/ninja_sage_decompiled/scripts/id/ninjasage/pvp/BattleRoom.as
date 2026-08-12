package id.ninjasage.pvp
{
   import Managers.OutfitManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public class BattleRoom extends MovieClip
   {
       
      
      public var btn_gear:SimpleButton;
      
      public var btn_pet:SimpleButton;
      
      public var btn_skill:SimpleButton;
      
      public var vsMC:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var bgHolder:MovieClip;
      
      public var roomInfoMC:MovieClip;
      
      public var teamA_0:MovieClip;
      
      public var teamA_1:MovieClip;
      
      public var teamA_2:MovieClip;
      
      public var teamB_0:MovieClip;
      
      public var teamB_1:MovieClip;
      
      public var teamB_2:MovieClip;
      
      private var destroyed:Boolean = false;
      
      private var autoStartCount:int;
      
      private var eventHandler:EventHandler;
      
      private var pvp:PvP;
      
      private var messages:Array;
      
      private var customSkills;
      
      private var equippedSkills;
      
      public var outfits:Array;
      
      public var autoStartTime:int;
      
      public var autoStartInterval;
      
      public var skillSelection;
      
      public function BattleRoom()
      {
         this.messages = [];
         this.customSkills = [];
         this.equippedSkills = [];
         this.outfits = [];
         this.autoStartTime = 6;
         super();
         this.eventHandler = new EventHandler();
         this.autoStartCount = this.autoStartTime;
      }
      
      public function setContext(param1:PvP) : void
      {
         this.pvp = param1;
      }
      
      public function activate() : void
      {
         this.visible = true;
         this.autoStartCount = this.autoStartTime;
         this.setupUI();
         this.setupButtons();
         this.setupChat();
         this.loadBackground();
         this.hideAllTeam();
         if(this.pvp.roomInfo && this.pvp.roomInfo["host"] && this.pvp.character)
         {
            this.setupRoomAsHost();
         }
         else
         {
            this.setupRoomAsEnemy();
         }
         if(this.pvp.isMatchMaking())
         {
            this.setupAutoStart();
         }
      }
      
      private function addRoomListener() : *
      {
         this.removeRoomListener();
         var _loc1_:* = PvPSocket.getInstance();
         _loc1_.on("Room.kicked",this.onPlayerKicked);
         _loc1_.on("Room.newPlayerJoined",this.getEnemyData);
         _loc1_.on("Room.allReady",this.enemyReady);
         _loc1_.on("Conversation.room.newMessage",this.onRoomChatMessage);
         _loc1_.on("Room.skills.list",this.onCustomSkills);
         _loc1_.on("Room.skills.set",this.onEquippedSkills);
         _loc1_.on("Room.countdown.start",this.onStartCountdown);
      }
      
      private function removeRoomListener() : *
      {
         var _loc1_:* = PvPSocket.getInstance();
         _loc1_.off("Room.kicked",this.onPlayerKicked);
         _loc1_.off("Room.newPlayerJoined",this.getEnemyData);
         _loc1_.off("Room.allReady",this.enemyReady);
         _loc1_.off("Conversation.room.newMessage",this.onRoomChatMessage);
         _loc1_.off("Room.skills.list",this.onCustomSkills);
         _loc1_.off("Room.skills.set",this.onEquippedSkills);
         _loc1_.off("Room.countdown.start",this.onStartCountdown);
      }
      
      private function setupUI() : void
      {
         if(!this.pvp.roomInfo)
         {
            return;
         }
         PvPSocket.getInstance().emit("Room.skills.list");
         var _loc1_:Object = this.pvp.roomInfo;
         var _loc2_:Boolean = Boolean(_loc1_["host"]);
         var _loc3_:Boolean = this.pvp.isMatchMaking();
         this.btn_close.visible = !_loc3_;
         this.roomInfoMC.roomId.text = _loc1_["room_id"] || "";
         this.roomInfoMC.roomPassword.text = _loc1_["password"] != null ? _loc1_["password"] : "-";
         this.roomInfoMC.battle_mode.text = _loc1_["mode"] != null ? _loc1_["mode"] : "1 VS 1";
         this.roomInfoMC.allow_pets.text = !!_loc1_["allow_pets"] ? "Yes" : "No";
         this.roomInfoMC.allow_scrolls.text = !!_loc1_["allow_scrolls"] ? "Yes" : "No";
         this.roomInfoMC.allow_spectators.text = !!_loc1_["allow_spectators"] ? "Yes" : "No";
         this.roomInfoMC.btn_start.visible = false;
         this.roomInfoMC.btn_ready.visible = false;
         this.roomInfoMC.startCountdown.visible = _loc3_;
         this.eventHandler.addListener(this.roomInfoMC.roomId,MouseEvent.CLICK,this.onCopyText);
         this.eventHandler.addListener(this.roomInfoMC.roomPassword,MouseEvent.CLICK,this.onCopyText);
         this.eventHandler.addListener(this.btn_skill,MouseEvent.CLICK,this.onSkillSelection);
      }
      
      private function onCustomSkills(param1:Object) : void
      {
         this.customSkills = param1;
      }
      
      private function onEquippedSkills(param1:Object) : void
      {
         this.equippedSkills = param1;
      }
      
      private function onStartCountdown(param1:*) : void
      {
         if(this.pvp.isMatchMaking())
         {
            this.autoStartCount = param1;
            this.setupAutoStart();
         }
      }
      
      private function onGearSelection(param1:MouseEvent) : void
      {
         this.pvp.main.getNotice("Gear selection is not available yet");
      }
      
      private function onPetSelection(param1:MouseEvent) : void
      {
         this.pvp.main.getNotice("Pet selection is not available yet");
      }
      
      private function onSkillSelection(param1:MouseEvent) : void
      {
         if(this.skillSelection)
         {
            this.skillSelection.destroy();
            this.skillSelection = null;
         }
         if(this.customSkills.length < 1)
         {
            this.pvp.main.showMessage("Loading skills... Please try again later");
            PvPSocket.getInstance().emit("Room.skills.list");
            return;
         }
         PvPSocket.getInstance().emit("Room.countdown.start");
         this.skillSelection = new SkillSelection();
         this.skillSelection.setContext(this.pvp);
         this.skillSelection.setEquippedSkills(this.equippedSkills);
         this.skillSelection.setSkillList(this.customSkills);
         this.pvp.main.loader.addChild(this.skillSelection);
      }
      
      private function onCopyText(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         switch(_loc2_)
         {
            case "roomId":
               System.setClipboard(this.roomInfoMC.roomId.text);
               this.pvp.main.showMessage("Room ID Copied!");
               break;
            case "roomPassword":
               System.setClipboard(this.roomInfoMC.roomPassword.text);
               this.pvp.main.showMessage("Room Password Copied!");
         }
      }
      
      private function hideAllTeam() : void
      {
         var _loc4_:MovieClip = null;
         var _loc1_:Boolean = this.pvp.isMatchMaking();
         var _loc2_:Array = this.getAllTeamMCs();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            (_loc4_ = _loc2_[_loc3_]).visible = false;
            if(_loc4_.hasOwnProperty("userInfoMc"))
            {
               if(_loc4_.userInfoMc.hasOwnProperty("btn_kick"))
               {
                  _loc4_.userInfoMc.btn_kick.visible = !_loc1_ && this.pvp.roomInfo && this.pvp.roomInfo["host"];
               }
               if(_loc4_.userInfoMc.hasOwnProperty("char_name"))
               {
                  _loc4_.userInfoMc.char_name.visible = true;
                  _loc4_.userInfoMc.char_name.text = "";
               }
            }
            if(_loc4_.hasOwnProperty("noPlayer"))
            {
               _loc4_.noPlayer.visible = false;
            }
            if(_loc4_.hasOwnProperty("char_mc"))
            {
               _loc4_.char_mc.visible = true;
            }
            _loc3_++;
         }
      }
      
      private function setupButtons() : void
      {
         var _loc1_:Boolean = this.pvp.isMatchMaking();
         var _loc2_:Boolean = this.pvp.roomInfo && this.pvp.roomInfo["host"];
         if(_loc1_)
         {
            if(this.btn_close)
            {
               this.btn_close.visible = false;
            }
            if(this.roomInfoMC.btn_start)
            {
               this.roomInfoMC.btn_start.visible = false;
            }
            if(this.roomInfoMC.btn_ready)
            {
               this.roomInfoMC.btn_ready.visible = false;
            }
            return;
         }
         if(this.btn_close)
         {
            this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         }
         if(this.roomInfoMC.btn_start && _loc2_)
         {
            this.eventHandler.addListener(this.roomInfoMC.btn_start,MouseEvent.CLICK,this.startMatch);
         }
         if(this.roomInfoMC.btn_ready && !_loc2_)
         {
            this.eventHandler.addListener(this.roomInfoMC.btn_ready,MouseEvent.CLICK,this.sendReady);
         }
         if(_loc2_ && this.teamB_0 && this.teamB_0.userInfoMc && this.teamB_0.userInfoMc.btn_kick)
         {
            this.eventHandler.addListener(this.teamB_0.userInfoMc.btn_kick,MouseEvent.CLICK,this.kickEnemy);
         }
      }
      
      private function enableReadyButton() : void
      {
         if(this.roomInfoMC.btn_ready)
         {
            this.roomInfoMC.btn_ready.visible = true;
         }
         this.eventHandler.addListener(this.roomInfoMC.btn_ready,MouseEvent.CLICK,this.sendReady);
      }
      
      private function enableCloseButton() : void
      {
         if(this.pvp.isMatchMaking())
         {
            return;
         }
         this.btn_close.visible = true;
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
      }
      
      private function disableCloseButton() : void
      {
         this.btn_close.visible = false;
         this.eventHandler.removeListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
      }
      
      private function setupChat() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         PvPSocket.getInstance().off("Conversation.room.newMessage",this.onRoomChatMessage);
         PvPSocket.getInstance().on("Conversation.room.newMessage",this.onRoomChatMessage);
         if(this.roomInfoMC.hasOwnProperty("chatBoxMc") && this.roomInfoMC.chatBoxMc)
         {
            _loc1_ = this.roomInfoMC.chatBoxMc;
            if(_loc1_.hasOwnProperty("chatInputMc") || _loc1_.hasOwnProperty("chatInputTxt"))
            {
               _loc2_ = _loc1_.chatInputMc || _loc1_.chatInputTxt;
               if(_loc2_)
               {
                  this.eventHandler.addListener(_loc2_,KeyboardEvent.KEY_UP,this.sendChat);
               }
            }
            if(_loc1_.hasOwnProperty("pvp_room_chat_outputMC"))
            {
               _loc1_.pvp_room_chat_outputMC.htmlText = "Room Chat:\n";
            }
         }
      }
      
      private function setupAutoStart() : void
      {
         if(this.pvp.isMatchMaking() && this.autoStartCount > 0)
         {
            this.clearAutoStart();
            this.autoStartInterval = setInterval(this.checkAutoStart,1000);
            if(this.roomInfoMC.hasOwnProperty("startCountdown"))
            {
               this.roomInfoMC.startCountdown.text = "Starting match in " + this.autoStartCount;
            }
         }
      }
      
      private function setupRoomAsHost() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:OutfitManager = null;
         if(!this.pvp.character || !this.teamA_0)
         {
            return;
         }
         var _loc1_:Boolean = this.pvp.isMatchMaking();
         var _loc2_:* = this.pvp.character;
         var _loc3_:MovieClip = this.teamA_0;
         _loc3_.visible = true;
         if(_loc3_.userInfoMc)
         {
            if(_loc3_.userInfoMc.hasOwnProperty("char_name"))
            {
               _loc3_.userInfoMc.char_name.htmlText = Character.colorifyText(_loc2_.getID(),_loc2_.getName(),_loc3_.userInfoMc.char_name) || "";
            }
            if(_loc3_.userInfoMc.hasOwnProperty("charLevelMC"))
            {
               _loc3_.userInfoMc.charLevelMC.levelTxt.text = String(_loc2_.getLevel() || "");
            }
            if(_loc3_.userInfoMc.hasOwnProperty("rankIcon"))
            {
               _loc3_.userInfoMc.rankIcon.gotoAndStop(_loc2_.getRank());
            }
            if(_loc3_.userInfoMc.hasOwnProperty("element_1"))
            {
               _loc4_ = _loc2_.getElementType(1);
               _loc3_.userInfoMc.element_1.gotoAndStop(_loc4_ != null && _loc4_ > 0 ? _loc4_ : 6);
            }
            this.setElementDisplay(_loc3_.userInfoMc,_loc2_);
         }
         if(_loc3_.userInfoMc && _loc3_.userInfoMc.hasOwnProperty("btn_kick"))
         {
            _loc3_.userInfoMc.btn_kick.visible = false;
         }
         if(!Character.is_stickman && _loc3_.hasOwnProperty("char_mc"))
         {
            _loc5_ = _loc2_.character && _loc2_.character.character_sets ? _loc2_.character.character_sets.hair_color : "";
            _loc6_ = _loc2_.character && _loc2_.character.character_sets ? _loc2_.character.character_sets.skin_color : "";
            (_loc7_ = new OutfitManager(false)).fillOutfit(_loc3_.char_mc,_loc2_.getWeapon(),_loc2_.getBackItem(),_loc2_.getClothing(),_loc2_.getHair(),_loc2_.getFace(),_loc5_,_loc6_);
            this.outfits.push(_loc7_);
         }
         if(_loc3_.hasOwnProperty("char_mc"))
         {
            this.stopAllEffects(_loc3_.char_mc);
         }
         if(this.teamB_0)
         {
            if(this.teamB_0.hasOwnProperty("readyTxt"))
            {
               this.teamB_0.readyTxt.text = !!_loc1_ ? "Ready" : "Not ready!";
            }
            if(this.teamB_0.userInfoMc)
            {
               this.teamB_0.userInfoMc.visible = false;
            }
            if(this.teamB_0.hasOwnProperty("noPlayer"))
            {
               this.teamB_0.noPlayer.visible = true;
            }
            if(this.teamB_0.hasOwnProperty("char_mc"))
            {
               this.teamB_0.char_mc.visible = false;
            }
            if(this.teamB_0.userInfoMc && this.teamB_0.userInfoMc.hasOwnProperty("btn_kick"))
            {
               this.teamB_0.userInfoMc.btn_kick.visible = false;
            }
         }
         this.addRoomListener();
      }
      
      private function setElementDisplay(param1:MovieClip, param2:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.hasOwnProperty("element_2"))
         {
            _loc3_ = param2.getElementType(2);
            if(_loc3_ > 0)
            {
               param1.element_2.gotoAndStop(_loc3_);
               param1.element_2.visible = true;
            }
            else
            {
               param1.element_2.visible = false;
            }
         }
         if(param1.hasOwnProperty("element_3"))
         {
            if((_loc4_ = param2.getElementType(3)) > 0)
            {
               param1.element_3.gotoAndStop(_loc4_);
               param1.element_3.visible = true;
            }
            else
            {
               param1.element_3.visible = false;
            }
         }
      }
      
      public function getAllTeamMCs() : Array
      {
         return [this.teamA_0,this.teamA_1,this.teamA_2,this.teamB_0,this.teamB_1,this.teamB_2];
      }
      
      public function loadBackground() : void
      {
         if(!this.pvp.roomInfo || !this.pvp.loaderSwf)
         {
            return;
         }
         var _loc1_:Object = this.pvp.roomInfo;
         var _loc2_:* = "stage" in _loc1_ && _loc1_.stage != null ? _loc1_["stage"] : (this.pvp.missionIDs && this.pvp.missionIDs.length > 0 ? this.pvp.missionIDs[0] : null);
         if(!_loc2_)
         {
            return;
         }
         if(this.pvp.loaderSwf.hasItem(_loc2_,false))
         {
            this.onBackgroundLoaded(this.pvp.loaderSwf.getContent(_loc2_));
            return;
         }
         this.pvp.loaderSwf.add("mission/" + _loc2_ + ".swf",{"id":_loc2_});
         var _loc3_:* = this.pvp.loaderSwf.get(_loc2_);
         if(_loc3_)
         {
            _loc3_.addEventListener(Event.COMPLETE,this.onBackgroundLoaded,false,0,true);
            this.pvp.loaderSwf.start();
         }
      }
      
      private function onBackgroundLoaded(param1:*) : void
      {
         var _loc6_:* = undefined;
         if(param1 && param1.currentTarget)
         {
            param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         }
         if(!this.pvp.roomInfo || !this.pvp.loaderSwf)
         {
            return;
         }
         var _loc3_:Object = this.pvp.roomInfo;
         var _loc4_:*;
         if(!(_loc4_ = "stage" in _loc3_ && _loc3_.stage != null ? _loc3_["stage"] : (this.pvp.missionIDs && this.pvp.missionIDs.length > 0 ? this.pvp.missionIDs[0] : null)))
         {
            return;
         }
         var _loc5_:*;
         if(_loc5_ = this.pvp.loaderSwf.get(_loc4_))
         {
            _loc5_.removeEventListener(Event.COMPLETE,this.onBackgroundLoaded);
            if((_loc6_ = _loc5_.content["BattleBG"]) && this.bgHolder)
            {
               _loc6_.scaleX = 1;
               _loc6_.scaleY = 1;
               _loc6_.width += 100;
               GF.removeAllChild(this.bgHolder);
               this.bgHolder.addChild(_loc6_);
            }
         }
      }
      
      public function getEnemyData(param1:*) : void
      {
         var _loc2_:Object = param1;
         if("enemy_id" in _loc2_ && _loc2_.enemy_id is Number)
         {
            this.pvp.main.amf_manager.service("36a62s4oZ7iYRJjd.iakN46g0GaJN",[Character.char_id,Character.sessionkey,_loc2_["enemy_id"],"PVP"],this.onGetEnemyInfo);
            return;
         }
         this.pvp.main.showMessage("Failed to get enemy info");
      }
      
      private function onGetEnemyInfo(param1:Object) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:OutfitManager = null;
         this.pvp.main.loading(false);
         if(!this.teamB_0 || !param1 || !param1.character_data)
         {
            return;
         }
         var _loc2_:Boolean = this.pvp.isMatchMaking();
         var _loc3_:Object = param1.character_data;
         var _loc4_:Object = param1.character_sets;
         if(this.teamB_0.userInfoMc)
         {
            this.teamB_0.visible = true;
            this.teamB_0.userInfoMc.visible = true;
            if(this.teamB_0.userInfoMc.hasOwnProperty("btn_kick"))
            {
               this.teamB_0.userInfoMc.btn_kick.metaData = {"id":_loc3_["character_id"]};
               this.teamB_0.userInfoMc.btn_kick.visible = !_loc2_ && (this.pvp.roomInfo && this.pvp.roomInfo["host"]);
            }
            if(this.teamB_0.userInfoMc.hasOwnProperty("char_name"))
            {
               this.teamB_0.userInfoMc.char_name.htmlText = Character.colorifyText(_loc3_.character_id,_loc3_.character_name,this.teamB_0.userInfoMc.char_name) || "";
            }
            if(this.teamB_0.userInfoMc.hasOwnProperty("charLevelMC"))
            {
               this.teamB_0.userInfoMc.charLevelMC.levelTxt.text = String(_loc3_.character_level || "");
            }
            if(this.teamB_0.userInfoMc.hasOwnProperty("rankIcon"))
            {
               this.teamB_0.userInfoMc.rankIcon.gotoAndStop(_loc3_.character_rank);
            }
            if(this.teamB_0.userInfoMc.hasOwnProperty("element_1"))
            {
               _loc5_ = _loc3_.character_element_1 != null ? _loc3_.character_element_1 : 6;
               this.teamB_0.userInfoMc.element_1.gotoAndStop(_loc5_);
            }
            this.setElementDisplayFromData(this.teamB_0.userInfoMc,_loc3_);
         }
         if(this.teamB_0.hasOwnProperty("noPlayer"))
         {
            this.teamB_0.noPlayer.visible = false;
         }
         if(this.teamB_0.hasOwnProperty("char_mc"))
         {
            this.teamB_0.char_mc.visible = true;
            if(!Character.is_stickman && _loc4_)
            {
               (_loc6_ = new OutfitManager(false)).fillOutfit(this.teamB_0.char_mc,_loc4_.weapon,_loc4_.back_item,_loc4_.clothing,_loc4_.hairstyle,_loc4_.face,_loc4_.hair_color,_loc4_.skin_color);
               this.outfits.push(_loc6_);
            }
            this.stopAllEffects(this.teamB_0.char_mc);
         }
         if(this.teamB_0.hasOwnProperty("readyTxt"))
         {
            this.teamB_0.readyTxt.text = !!_loc2_ ? "Ready" : "Not ready!";
         }
         if(_loc2_)
         {
            this.btn_close.visible = false;
            this.autoStartCount = this.autoStartTime;
            this.setupAutoStart();
         }
         this.addRoomListener();
      }
      
      public function setupRoomAsEnemy() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:OutfitManager = null;
         this.pvp.main.loading(true);
         var _loc1_:Boolean = this.pvp.isMatchMaking();
         this.autoStartCount = this.autoStartTime;
         if(_loc1_)
         {
            this.roomInfoMC.startCountdown.text = "Starting match in " + this.autoStartCount;
            this.roomInfoMC.startCountdown.visible = _loc1_;
         }
         this.loadBackground();
         if(this.roomInfoMC)
         {
            this.roomInfoMC.btn_start.visible = false;
            if(this.roomInfoMC.btn_ready)
            {
               this.roomInfoMC.btn_ready.visible = !_loc1_;
            }
         }
         if(this.pvp.character && this.teamB_0)
         {
            _loc2_ = this.pvp.character;
            this.teamB_0.visible = true;
            if(this.teamB_0.userInfoMc)
            {
               this.teamB_0.userInfoMc.visible = true;
               if(this.teamB_0.userInfoMc.hasOwnProperty("char_name"))
               {
                  this.teamB_0.userInfoMc.char_name.htmlText = Character.colorifyText(_loc2_.getID(),_loc2_.getName(),this.teamB_0.userInfoMc.char_name) || "";
               }
               if(this.teamB_0.userInfoMc.hasOwnProperty("charLevelMC"))
               {
                  this.teamB_0.userInfoMc.charLevelMC.levelTxt.text = String(_loc2_.getLevel() || "");
               }
               if(this.teamB_0.userInfoMc.hasOwnProperty("rankIcon"))
               {
                  this.teamB_0.userInfoMc.rankIcon.gotoAndStop(_loc2_.getRank());
               }
               if(this.teamB_0.userInfoMc.hasOwnProperty("element_1"))
               {
                  _loc3_ = _loc2_.getElementType(1);
                  this.teamB_0.userInfoMc.element_1.gotoAndStop(_loc3_ != null && _loc3_ > 0 ? _loc3_ : 6);
               }
               this.setElementDisplay(this.teamB_0.userInfoMc,_loc2_);
            }
            if(!Character.is_stickman && this.teamB_0.hasOwnProperty("char_mc"))
            {
               _loc4_ = _loc2_.character && _loc2_.character.character_sets ? _loc2_.character.character_sets.hair_color : "";
               _loc5_ = _loc2_.character && _loc2_.character.character_sets ? _loc2_.character.character_sets.skin_color : "";
               (_loc6_ = new OutfitManager(false)).fillOutfit(this.teamB_0.char_mc,_loc2_.getWeapon(),_loc2_.getBackItem(),_loc2_.getClothing(),_loc2_.getHair(),_loc2_.getFace(),_loc4_,_loc5_);
               this.outfits.push(_loc6_);
            }
            if(this.teamB_0.hasOwnProperty("char_mc"))
            {
               this.stopAllEffects(this.teamB_0.char_mc);
            }
            if(this.teamB_0.hasOwnProperty("noPlayer"))
            {
               this.teamB_0.noPlayer.visible = false;
            }
            if(this.teamB_0.hasOwnProperty("char_mc"))
            {
               this.teamB_0.char_mc.visible = true;
            }
            if(this.teamB_0.hasOwnProperty("readyTxt"))
            {
               this.teamB_0.readyTxt.text = !!_loc1_ ? "Ready" : "Not ready!";
            }
         }
         if(this.teamB_0.userInfoMc && this.teamB_0.userInfoMc.btn_kick)
         {
            this.teamB_0.userInfoMc.btn_kick.visible = this.pvp.roomInfo["host"];
         }
         this.setupUI();
         this.enableCloseButton();
         if(this.pvp.roomInfo["enemy_id"])
         {
            this.pvp.main.amf_manager.service("36a62s4oZ7iYRJjd.iakN46g0GaJN",[Character.char_id,Character.sessionkey,this.pvp.roomInfo["enemy_id"],"PVP"],this.onGetHostInfo);
         }
      }
      
      private function onGetHostInfo(param1:Object) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:OutfitManager = null;
         this.pvp.main.loading(false);
         if(!this.teamA_0 || !param1 || !param1.character_data)
         {
            return;
         }
         var _loc2_:Boolean = this.pvp.isMatchMaking();
         var _loc3_:Object = param1.character_data;
         var _loc4_:Object = param1.character_sets;
         if(this.teamA_0.userInfoMc)
         {
            this.teamA_0.visible = true;
            this.teamA_0.userInfoMc.visible = true;
            if(this.teamA_0.userInfoMc.hasOwnProperty("btn_kick"))
            {
               this.teamA_0.userInfoMc.btn_kick.visible = false;
            }
            if(this.teamA_0.userInfoMc.hasOwnProperty("char_name"))
            {
               this.teamA_0.userInfoMc.char_name.htmlText = Character.colorifyText(_loc3_.character_id,_loc3_.character_name,this.teamA_0.userInfoMc.char_name) || "";
            }
            if(this.teamA_0.userInfoMc.hasOwnProperty("charLevelMC"))
            {
               this.teamA_0.userInfoMc.charLevelMC.levelTxt.text = String(_loc3_.character_level || "");
            }
            if(this.teamA_0.userInfoMc.hasOwnProperty("rankIcon"))
            {
               this.teamA_0.userInfoMc.rankIcon.gotoAndStop(_loc3_.character_rank);
            }
            if(this.teamA_0.userInfoMc.hasOwnProperty("element_1"))
            {
               _loc5_ = _loc3_.character_element_1 != null ? _loc3_.character_element_1 : 6;
               this.teamA_0.userInfoMc.element_1.gotoAndStop(_loc5_);
            }
            this.setElementDisplayFromData(this.teamA_0.userInfoMc,_loc3_);
         }
         if(!Character.is_stickman && _loc4_ && this.teamA_0.hasOwnProperty("char_mc"))
         {
            (_loc6_ = new OutfitManager(false)).fillOutfit(this.teamA_0.char_mc,_loc4_.weapon,_loc4_.back_item,_loc4_.clothing,_loc4_.hairstyle,_loc4_.face,_loc4_.hair_color,_loc4_.skin_color);
            this.outfits.push(_loc6_);
         }
         if(this.teamA_0.hasOwnProperty("char_mc"))
         {
            this.stopAllEffects(this.teamA_0.char_mc);
         }
         if(_loc2_)
         {
            this.autoStartCount = this.autoStartTime;
            if(this.roomInfoMC.hasOwnProperty("startCountdown"))
            {
               this.roomInfoMC.startCountdown.text = "Starting match in " + this.autoStartCount;
            }
            this.setupAutoStart();
         }
         else
         {
            this.enableCloseButton();
            this.enableReadyButton();
         }
         this.addRoomListener();
      }
      
      private function setElementDisplayFromData(param1:MovieClip, param2:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.hasOwnProperty("element_2"))
         {
            _loc3_ = param2.character_element_2;
            if(_loc3_ > 0)
            {
               param1.element_2.gotoAndStop(_loc3_);
               param1.element_2.visible = true;
            }
            else
            {
               param1.element_2.visible = false;
            }
         }
         if(param1.hasOwnProperty("element_3"))
         {
            if((_loc4_ = param2.character_element_3) > 0)
            {
               param1.element_3.gotoAndStop(_loc4_);
               param1.element_3.visible = true;
            }
            else
            {
               param1.element_3.visible = false;
            }
         }
      }
      
      public function enemyReady(param1:* = null) : void
      {
         var _loc2_:Boolean = this.pvp.isMatchMaking();
         if(this.roomInfoMC.btn_ready)
         {
            this.roomInfoMC.btn_ready.visible = false;
         }
         if(this.teamB_0 && this.teamB_0.hasOwnProperty("readyTxt"))
         {
            this.teamB_0.readyTxt.text = "Ready!";
         }
         if(this.pvp.roomInfo && this.pvp.roomInfo["host"] && !_loc2_ && this.roomInfoMC.btn_start)
         {
            this.roomInfoMC.btn_start.visible = true;
         }
      }
      
      public function clearEnemyUI(param1:Boolean = false) : void
      {
         this.btn_close.visible = true;
         if(this.roomInfoMC.btn_start)
         {
            this.roomInfoMC.btn_start.visible = false;
         }
         if(this.teamB_0)
         {
            this.removeCharMCItems(this.teamB_0.char_mc);
            if(this.teamB_0.hasOwnProperty("readyTxt"))
            {
               this.teamB_0.readyTxt.text = "Not ready!";
            }
            if(this.teamB_0.userInfoMc)
            {
               this.teamB_0.userInfoMc.visible = false;
            }
            if(this.teamB_0.hasOwnProperty("noPlayer"))
            {
               this.teamB_0.noPlayer.visible = true;
            }
            if(this.teamB_0.hasOwnProperty("char_mc"))
            {
               this.teamB_0.char_mc.visible = false;
            }
         }
         if(this.pvp && this.pvp.roomInfo && !this.pvp.roomInfo["host"])
         {
            if(param1)
            {
               this.exitRoom();
            }
            this.visible = false;
         }
      }
      
      private function kickEnemy(param1:MouseEvent) : void
      {
         if(this.pvp.roomInfo && this.pvp.roomInfo["room_id"] && param1.target.metaData.id)
         {
            PvPSocket.getInstance().emit("Room.kick",{
               "roomId":this.pvp.roomInfo["room_id"],
               "charId":param1.target.metaData.id
            });
         }
      }
      
      private function onPlayerKicked(param1:Object = null) : void
      {
         Log.debug(this,"onPlayerKicked",JSON.stringify(param1));
         if(!param1)
         {
            this.closePanel(null);
            return;
         }
         if(param1.charId == this.pvp.character.getID())
         {
            this.pvp.main.showMessage("You have been kicked from the room");
            this.closePanel(null);
         }
         this.clearEnemyUI();
      }
      
      private function sendReady(param1:MouseEvent) : void
      {
         if(this.pvp.roomInfo && this.pvp.roomInfo["room_id"] && this.pvp.character)
         {
            PvPSocket.getInstance().emit("Room.ready",{
               "roomId":this.pvp.roomInfo["room_id"],
               "charId":this.pvp.character.getID()
            });
         }
      }
      
      private function startMatch(param1:MouseEvent = null) : void
      {
         if(this.pvp.roomInfo && this.pvp.roomInfo["room_id"])
         {
            PvPSocket.getInstance().emit("Battle.start",this.pvp.roomInfo["room_id"]);
         }
      }
      
      private function exitRoom(param1:* = null) : void
      {
         PvPSocket.getInstance().emit("Room.exit");
      }
      
      private function sendChat(param1:KeyboardEvent) : void
      {
         if(!this.roomInfoMC.hasOwnProperty("chatBoxMc") || !this.pvp.roomInfo)
         {
            return;
         }
         var _loc2_:* = this.roomInfoMC.chatBoxMc;
         var _loc3_:* = _loc2_.chatInputMc || _loc2_.chatInputTxt;
         if(!_loc3_ || param1.charCode != 13)
         {
            return;
         }
         var _loc4_:String;
         if((_loc4_ = _loc3_.text || "") != "")
         {
            PvPSocket.getInstance().emit("Conversation.room.sendMessage",{
               "roomId":this.pvp.roomInfo["room_id"],
               "message":_loc4_
            });
            _loc3_.text = "";
         }
      }
      
      private function onRoomChatMessage(param1:Object) : void
      {
         try
         {
            if(this.messages.length >= 50)
            {
               this.messages.shift();
            }
            this.messages.push(PvPLobby.formatLobbyMessage(param1));
            this.renderMessages();
         }
         catch(err:*)
         {
         }
      }
      
      private function renderMessages() : void
      {
         var _loc1_:* = undefined;
         try
         {
            if(!this.roomInfoMC.chatBoxMc || !this.roomInfoMC.chatBoxMc.hasOwnProperty("pvp_room_chat_outputMC"))
            {
               return;
            }
            _loc1_ = this.roomInfoMC.chatBoxMc.pvp_room_chat_outputMC;
            _loc1_.htmlText = this.messages.join("\n");
            if(_loc1_.hasOwnProperty("maxScrollV"))
            {
               _loc1_.scrollV = _loc1_.maxScrollV;
            }
         }
         catch(err:*)
         {
         }
      }
      
      private function checkAutoStart() : void
      {
         var _loc1_:PvPSocket = null;
         var _loc2_:Boolean = false;
         if(!this.pvp.isMatchMaking())
         {
            this.clearAutoStart();
            return;
         }
         --this.autoStartCount;
         if(this.roomInfoMC.hasOwnProperty("startCountdown"))
         {
            this.roomInfoMC.startCountdown.visible = true;
         }
         if(this.visible && this.autoStartCount <= 0)
         {
            this.clearAutoStart();
            this.autoStartCount = this.autoStartTime;
            _loc1_ = PvPSocket.getInstance();
            _loc2_ = this.pvp.roomInfo && this.pvp.roomInfo["host"];
            if(_loc2_)
            {
               if(this.roomInfoMC.hasOwnProperty("startCountdown"))
               {
                  this.roomInfoMC.startCountdown.text = "Starting match...";
               }
               this.startMatch();
            }
            else if(this.roomInfoMC.hasOwnProperty("startCountdown"))
            {
               this.roomInfoMC.startCountdown.text = "Waiting room master...";
            }
         }
         else
         {
            if(this.roomInfoMC.hasOwnProperty("startCountdown"))
            {
               this.roomInfoMC.startCountdown.text = "Starting match in " + this.autoStartCount;
            }
            if(this.skillSelection && this.skillSelection.hasOwnProperty("txt_timer"))
            {
               this.skillSelection.txt_timer.text = this.autoStartCount + "s";
            }
         }
      }
      
      private function clearAutoStart() : void
      {
         if(this.autoStartInterval)
         {
            clearInterval(this.autoStartInterval);
            this.autoStartInterval = null;
         }
      }
      
      private function removeCharMCItems(param1:*) : void
      {
         if(!param1 || param1 == null)
         {
            return;
         }
         if(param1.hasOwnProperty("weapon"))
         {
            GF.removeAllChild(param1.weapon);
         }
         if(param1.hasOwnProperty("back"))
         {
            GF.removeAllChild(param1.back);
         }
         if(param1.hasOwnProperty("skirt"))
         {
            GF.removeAllChild(param1.skirt);
         }
         if(param1.hasOwnProperty("head"))
         {
            if(param1["head"].hasOwnProperty("hair"))
            {
               GF.removeAllChild(param1.head.hair);
            }
            if(param1["head"].hasOwnProperty("face"))
            {
               GF.removeAllChild(param1.head.face);
            }
         }
         if(param1.hasOwnProperty("back_hair"))
         {
            GF.removeAllChild(param1.back_hair);
         }
      }
      
      private function stopAllEffects(param1:*) : void
      {
         if(!param1 || param1 == null)
         {
            return;
         }
         if(param1.hasOwnProperty("weapon"))
         {
            param1.weapon.stopAllMovieClips();
         }
         if(param1.hasOwnProperty("back"))
         {
            param1.back.stopAllMovieClips();
         }
         if(param1.hasOwnProperty("skirt"))
         {
            param1.skirt.stopAllMovieClips();
         }
         if(param1.hasOwnProperty("head") && param1.head.hasOwnProperty("hair"))
         {
            param1.head.hair.stopAllMovieClips();
         }
         if(param1.hasOwnProperty("back_hair"))
         {
            param1.back_hair.stopAllMovieClips();
         }
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         if(this.pvp.isMatchMaking())
         {
            return;
         }
         this.pvp.goToLobby();
         this.deactivate();
         this.exitRoom();
         if(this.roomInfoMC.hasOwnProperty("chatBoxMc") && this.roomInfoMC.chatBoxMc.hasOwnProperty("pvp_room_chat_outputMC"))
         {
            this.roomInfoMC.chatBoxMc.pvp_room_chat_outputMC.htmlText = "Room Chat:\n";
         }
      }
      
      public function closeByEscape(param1:MouseEvent = null) : void
      {
         this.closePanel(param1);
      }
      
      public function deactivate() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:OutfitManager = null;
         if(!this.destroyed)
         {
            _loc1_ = ["teamA_0","teamA_1","teamA_2","teamB_0","teamB_1","teamB_2"];
            for each(_loc2_ in _loc1_)
            {
               if(this.hasOwnProperty(_loc2_))
               {
                  _loc3_ = this[_loc2_];
                  if(_loc3_ && _loc3_.hasOwnProperty("char_mc"))
                  {
                     this.removeCharMCItems(_loc3_.char_mc);
                  }
               }
            }
         }
         if(this.roomInfoMC.hasOwnProperty("chatBoxMc"))
         {
            if((_loc4_ = this.roomInfoMC.chatBoxMc).hasOwnProperty("chatInputMc"))
            {
               _loc4_.chatInputMc.text = "";
            }
            else if(_loc4_.hasOwnProperty("chatInputTxt"))
            {
               _loc4_.chatInputTxt.text = "";
            }
         }
         if(this.skillSelection)
         {
            this.skillSelection.destroy();
            GF.removeAllChild(this.skillSelection);
            this.skillSelection = null;
         }
         this.visible = false;
         this.removeRoomListener();
         this.clearAutoStart();
         this.autoStartCount = this.autoStartTime;
         if(this.outfits && this.outfits.length > 0)
         {
            for each(_loc5_ in this.outfits)
            {
               _loc5_.destroy();
            }
            this.outfits = [];
         }
         this.messages = [];
         this.customSkills = [];
         this.pvp = null;
         GF.removeAllChild(this.bgHolder);
      }
      
      public function destroy() : void
      {
         if(this.destroyed)
         {
            return;
         }
         this.deactivate();
         this.messages = null;
         this.customSkills = null;
         this.equippedSkills = null;
         this.destroyed = true;
         if(this.teamA_0 && this.teamA_0.hasOwnProperty("char_mc"))
         {
            GF.removeAllChild(this.teamA_0.char_mc);
         }
         if(this.teamB_0 && this.teamB_0.hasOwnProperty("char_mc"))
         {
            GF.removeAllChild(this.teamB_0.char_mc);
         }
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
         }
         this.pvp = null;
         this.visible = false;
      }
   }
}
