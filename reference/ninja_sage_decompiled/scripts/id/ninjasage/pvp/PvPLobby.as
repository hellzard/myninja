package id.ninjasage.pvp
{
   import Managers.OutfitManager;
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.CharacterManager;
   import id.ninjasage.multiplayer.battle.CharacterModel;
   
   public class PvPLobby
   {
       
      
      private var pvp:PvP;
      
      private var lobbyMessages:Array;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      public function PvPLobby()
      {
         this.lobbyMessages = [];
         super();
         this.eventHandler = new EventHandler();
      }
      
      public static function formatLobbyMessage(param1:Object) : *
      {
         var charName:String = null;
         var charId:String = null;
         var message:String = null;
         var data:Object = param1;
         try
         {
            charName = data && data.character && data.character.name ? String(data.character.name) : "?";
            charId = data && data.character && data.character.id != null ? String(data.character.id) : "?";
            message = data && data.message ? String(data.message) : "";
            return charName + " [" + charId + "]: " + message;
         }
         catch(err:*)
         {
            return "";
         }
      }
      
      public function setContext(param1:PvP) : void
      {
         this.pvp = param1;
      }
      
      public function addListeners() : void
      {
         this.removeListeners();
         PvPSocket.getInstance().on("Client.characterInfo",this.onCharacterInfo);
         PvPSocket.getInstance().on("Conversation.lobby.messageHistory",this.onHistoryLobbyMessage);
         PvPSocket.getInstance().on("Conversation.lobby.newMessage",this.onNewLobbyMessage);
         this.eventHandler.addListener(this.pvp.chatBoxMc,KeyboardEvent.KEY_UP,this.sendChat);
         this.eventHandler.addListener(this.pvp.btn_refill,MouseEvent.CLICK,this.refillEnergyConfirmation);
      }
      
      public function removeListeners() : void
      {
         PvPSocket.getInstance().off("Client.characterInfo",this.onCharacterInfo);
         PvPSocket.getInstance().off("Conversation.lobby.messageHistory",this.onHistoryLobbyMessage);
         PvPSocket.getInstance().off("Conversation.lobby.newMessage",this.onNewLobbyMessage);
         this.eventHandler.removeListener(this.pvp.chatBoxMc,KeyboardEvent.KEY_UP,this.sendChat);
      }
      
      private function onCharacterInfo(param1:Object) : void
      {
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:OutfitManager = null;
         var _loc8_:String = null;
         var _loc2_:Object = param1;
         if(!_loc2_ || !_loc2_.character)
         {
            return;
         }
         Log.debug(this,"onCharacterInfo",JSON.stringify(_loc2_.character));
         if(this.pvp.character)
         {
            GF.destroyArray(this.pvp.outfits);
            this.pvp.outfits = [];
            this.pvp.character.destroy();
            this.pvp.character = null;
         }
         var _loc3_:CharacterModel = new CharacterModel();
         var _loc4_:CharacterManager;
         (_loc4_ = new CharacterManager(_loc2_.character)).setModel(_loc3_);
         this.pvp.character = _loc4_;
         this.pvp["btn_join"].visible = true;
         this.pvp["btn_create"].visible = true;
         this.pvp["btn_live"].visible = true;
         this.pvp["rankMC"].gotoAndStop(_loc4_.getRank());
         this.pvp["nameTxt"].htmlText = Character.colorifyText(_loc4_.getID(),_loc4_.getName(),this.pvp["nameTxt"]);
         this.pvp["emblemMC"].visible = false;
         this.pvp["classMC"].gotoAndStop(_loc4_.getSpecialClass() || 1);
         this.pvp["senjutsuMC"].gotoAndStop(_loc4_.getSenjutsu() || 1);
         this.pvp["txt_lvl"].text = _loc4_.getLevel();
         this.pvp["txt_hp"].text = String(_loc4_.getMaxHP()) + "/" + String(_loc4_.getMaxHP());
         this.pvp["txt_cp"].text = String(_loc4_.getMaxCP()) + "/" + String(_loc4_.getMaxCP());
         if(this.pvp.hasOwnProperty("character") && !Character.is_stickman)
         {
            (_loc6_ = this.pvp.main.getPlayerHead()).scaleX = 2;
            _loc6_.scaleY = 2;
            if(this.pvp.hasOwnProperty("headMc") && this.pvp["headMc"].hasOwnProperty("headHolder"))
            {
               GF.removeAllChild(this.pvp["headMc"]["headHolder"]);
               this.pvp["headMc"]["headHolder"].addChild(_loc6_);
            }
            _loc7_ = new OutfitManager();
            if(this.pvp.hasOwnProperty("char_mc"))
            {
               _loc7_.fillOutfit(this.pvp["char_mc"],_loc4_.getWeapon(),_loc4_.getBackItem(),_loc4_.getClothing(),_loc4_.getHair(),_loc4_.getFace(),_loc2_.character.set.hair_color);
               this.pvp.outfits.push(_loc7_);
               this.pvp.char_mc.stopAllMovieClips();
            }
         }
         this.pvp["char_mc"].weapon.stopAllMovieClips();
         this.pvp["char_mc"].back.stopAllMovieClips();
         this.pvp["char_mc"].skirt.stopAllMovieClips();
         this.pvp["char_mc"].head.hair.stopAllMovieClips();
         this.pvp["char_mc"].back_hair.stopAllMovieClips();
         _loc5_ = 1;
         while(_loc5_ < 6)
         {
            if(this.pvp.hasOwnProperty("element_" + _loc5_))
            {
               this.pvp["element_" + _loc5_].gotoAndStop(int(_loc4_.getElementType(_loc5_)) + 1);
            }
            _loc8_ = _loc4_.getTalentType(_loc5_);
            if(this.pvp.hasOwnProperty("talent_" + _loc5_) && _loc8_ != "null")
            {
               this.pvp["talent_" + _loc5_].gotoAndStop(_loc8_);
            }
            _loc5_++;
         }
         this.pvp.main.loading(false);
         this.pvp.playIdleAnimation();
         this.updateTitleMC();
      }
      
      public function updateTitleMC() : void
      {
         this.pvp["titleMC"].gotoAndStop("live");
      }
      
      public function showChatBox(param1:MouseEvent = null) : void
      {
         try
         {
            if(!this.pvp.chatBoxMc)
            {
               return;
            }
            this.pvp.chatBoxMc.chatBg.visible = true;
            this.pvp.chatBoxMc.chatBoxTxt.visible = true;
            this.pvp.chatBoxMc.clickmask.visible = false;
            this.pvp.chatBoxMc.placeholderTxt.visible = false;
            this.pvp.chatBoxMc.bg_close.visible = true;
            this.pvp.chatBoxMc.chatInputTxt.text = "";
            this.renderLobbyMessages();
         }
         catch(err:*)
         {
         }
      }
      
      public function closeChatBox(param1:MouseEvent = null) : void
      {
         try
         {
            if(!this.pvp.chatBoxMc)
            {
               return;
            }
            this.pvp.chatBoxMc.chatBoxTxt.htmlText = "";
            this.pvp.chatBoxMc.chatInputTxt.htmlText = "";
            this.pvp.chatBoxMc.chatBg.visible = false;
            this.pvp.chatBoxMc.chatBoxTxt.visible = false;
            this.pvp.chatBoxMc.clickmask.visible = true;
            this.pvp.chatBoxMc.placeholderTxt.visible = true;
            this.pvp.chatBoxMc.bg_close.visible = false;
         }
         catch(err:*)
         {
         }
      }
      
      private function sendChat(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         try
         {
            if(!this.pvp.chatBoxMc || !PvPSocket.getInstance().socket.connected)
            {
               return;
            }
            if(!this.pvp.chatBoxMc.hasOwnProperty("chatInputTxt"))
            {
               return;
            }
            if(param1.charCode != 13)
            {
               return;
            }
            _loc2_ = String(this.pvp.chatBoxMc.chatInputTxt.text);
            if(_loc2_ && _loc2_.length > 0)
            {
               PvPSocket.getInstance().emit("Conversation.lobby.sendMessage",_loc2_);
               this.pvp.chatBoxMc.chatInputTxt.text = "";
            }
         }
         catch(err:*)
         {
         }
      }
      
      private function onHistoryLobbyMessage(param1:Object) : void
      {
         var _loc2_:int = 0;
         try
         {
            this.lobbyMessages = [];
            if(param1 is Array)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.length)
               {
                  this.lobbyMessages.push(PvPLobby.formatLobbyMessage(param1[_loc2_]));
                  _loc2_++;
               }
            }
            this.renderLobbyMessages();
         }
         catch(err:*)
         {
         }
      }
      
      private function onNewLobbyMessage(param1:Object) : void
      {
         try
         {
            if(this.lobbyMessages.length >= 200)
            {
               this.lobbyMessages.shift();
            }
            this.lobbyMessages.push(PvPLobby.formatLobbyMessage(param1));
            this.renderLobbyMessages();
         }
         catch(err:*)
         {
         }
      }
      
      private function renderLobbyMessages() : void
      {
         try
         {
            if(!this.pvp.chatBoxMc || !this.pvp.chatBoxMc.hasOwnProperty("chatBoxTxt"))
            {
               return;
            }
            this.pvp.chatBoxMc.chatBoxTxt.htmlText = this.lobbyMessages.join("\n");
            if(this.pvp.chatBoxMc.chatBoxTxt.hasOwnProperty("maxScrollV"))
            {
               this.pvp.chatBoxMc.chatBoxTxt.scrollV = this.pvp.chatBoxMc.chatBoxTxt.maxScrollV;
            }
         }
         catch(err:*)
         {
         }
      }
      
      private function refillEnergyConfirmation(param1:MouseEvent) : void
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure to refill full energy for " + this.pvp.response.data.refill_price + " tokens?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.refillEnergy);
         this.pvp.addChild(this.confirmation);
      }
      
      private function refillEnergy(param1:MouseEvent) : void
      {
         this.removeConfirmation();
         this.pvp.main.loading(true);
         this.pvp.main.amf_manager.service("jpwzlvqNru201CF3.UI41FZ21gqTb",[Character.char_id,Character.sessionkey],this.refillEnergyRes);
      }
      
      private function refillEnergyRes(param1:Object) : void
      {
         this.pvp.main.loading(false);
         if(param1.status == 1)
         {
            this.pvp.showNotice("Energy refilled successfully!");
            this.pvp.response.data.energy = param1.energy;
            Character.account_tokens = param1.account_tokens;
            this.pvp.updateEnergy();
            this.pvp.main.HUD.setBasicData();
         }
         else
         {
            this.pvp.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      private function removeConfirmation(param1:MouseEvent = null) : void
      {
         this.eventHandler.removeListener(this.confirmation.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.removeListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.refillEnergy);
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
      }
      
      public function activate() : void
      {
         this.lobbyMessages = [];
         this.addListeners();
      }
      
      public function deactivate() : void
      {
         this.lobbyMessages = [];
         this.removeListeners();
      }
      
      public function destroy() : void
      {
         this.removeListeners();
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
         }
         this.eventHandler = null;
         this.lobbyMessages = [];
         this.pvp = null;
      }
   }
}
