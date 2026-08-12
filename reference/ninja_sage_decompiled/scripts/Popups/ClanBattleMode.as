package Popups
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.hurlant.crypto.hash.MD5;
   import com.hurlant.util.Hex;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public class ClanBattleMode extends MovieClip
   {
       
      
      public var btn_back:SimpleButton;
      
      public var btn_manual:SimpleButton;
      
      public var btn_quick:SimpleButton;
      
      public var opp_clan_name:TextField;
      
      public var recruit_id0:TextField;
      
      public var recruit_id1:TextField;
      
      public var main;
      
      public var __parent;
      
      public var _battle_popup;
      
      public var second_popup;
      
      public var rec_manual = null;
      
      public var eventHandler;
      
      private var destroyed = false;
      
      public function ClanBattleMode(param1:*, param2:*, param3:*)
      {
         this.eventHandler = new EventHandler();
         super();
         this.main = param1;
         this.__parent = param2;
         this._battle_popup = param3;
         var _loc4_:* = 0;
         while(_loc4_ < Character.clan_recruit_names.length)
         {
            if(this.hasOwnProperty("recruit_id" + _loc4_) && Character.clan_recruit_names[_loc4_])
            {
               this["recruit_id" + _loc4_].text = Character.clan_recruit_names[_loc4_];
            }
            _loc4_++;
         }
         this.updateDisplay();
         this.addButtonListeners();
      }
      
      public function addButtonListeners() : *
      {
         this.eventHandler.addListener(this.btn_back,MouseEvent.CLICK,this.backToBattlePanel);
         this.eventHandler.addListener(this.btn_manual,MouseEvent.CLICK,this.onManual);
         this.eventHandler.addListener(this.btn_quick,MouseEvent.CLICK,this.onQuick);
      }
      
      public function backToBattlePanel(param1:MouseEvent) : *
      {
         this._battle_popup.visible = true;
         this.destroy(false);
      }
      
      public function onManual(param1:MouseEvent) : *
      {
         this.second_popup = new ClanRecruitManual(this.main,this.__parent,this);
         this.addChild(this.second_popup);
      }
      
      public function onQuick(param1:MouseEvent) : *
      {
         this.main.loading(true);
         var _loc2_:* = NinjaSage.generateRandomString(24);
         var _loc3_:* = this._battle_popup.clans[this._battle_popup.attacking_clan_id].id;
         Clan.instance.quickAttack(_loc3_,_loc2_,this.onGetQuickAttackRes);
      }
      
      private function gen(param1:*) : *
      {
         return this.md5(param1.join("|z|"));
      }
      
      private function md5(param1:*) : *
      {
         return Hex.fromArray(new MD5().hash(Hex.toArray(Hex.fromString(param1))));
      }
      
      public function onGetQuickAttackRes(param1:Object, param2:* = null) : *
      {
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("reputation"))
         {
            Character.clan_data.reputation = param1.reputation;
            Character.clan_char_data.stamina = param1.stamina;
            this.__parent.char_data = Character.clan_char_data;
            this.__parent.clan_data = Character.clan_data;
            this.__parent.setDisplay();
            _loc3_ = new ClanBattleResults(this.main,this.__parent);
            _loc3_.updateDisplay(param1);
            this._battle_popup.visible = false;
            this.__parent.addChild(_loc3_);
            this.destroy();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            this.destroy();
            return;
         }
         if(param1 != null && param1.hasOwnProperty("statusCode"))
         {
            this.main.getNotice("Error Code: " + param1.statusCode);
            this.destroy();
            return;
         }
         this.main.getError("Error!");
         this.destroy();
      }
      
      public function updateDisplay() : *
      {
         this.opp_clan_name.text = this._battle_popup.clans[this._battle_popup.attacking_clan_id].name;
      }
      
      public function destroyPopups() : *
      {
         if(this._battle_popup)
         {
            this._battle_popup.destroy();
            this._battle_popup = null;
         }
      }
      
      public function destroy(param1:* = true) : *
      {
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         Log.debug(this,"DESTROY");
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         if(this.second_popup != null)
         {
            this.second_popup.destroy();
            this.second_popup = null;
         }
         if(param1 && this._battle_popup)
         {
            this._battle_popup.destroy();
            this._battle_popup = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
