package Popups
{
   import Managers.NinjaSage;
   import Panels.ClanVillage;
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   import id.ninjasage.EventHandler;
   
   public class ClanStamina extends MovieClip
   {
       
      
      public var btn_BuyOnigiri:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_restore:SimpleButton;
      
      public var btn_upgrade:SimpleButton;
      
      public var curr_stamina:TextField;
      
      public var new_stamina:TextField;
      
      public var restoreType:MovieClip;
      
      public var stamBar:MovieClip;
      
      public var txt_rolls:TextField;
      
      public var txt_stamina:TextField;
      
      public var main;
      
      public var __parent:ClanVillage;
      
      public var restore_type = "";
      
      var pop;
      
      public var eventHandler;
      
      public function ClanStamina(param1:*, param2:ClanVillage)
      {
         this.eventHandler = new EventHandler();
         super();
         this.main = param1;
         this.__parent = param2;
         this.updateDisplay(this.__parent.txt_stamina.text);
      }
      
      public function updateDisplay(param1:*) : *
      {
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePopup);
         this.eventHandler.addListener(this.btn_BuyOnigiri,MouseEvent.CLICK,this.buyOnigiriPackage);
         this.btn_restore.visible = false;
         this.btn_upgrade.visible = false;
         var _loc2_:* = NinjaSage.getMaterialAmount("material_69");
         this.txt_rolls.text = _loc2_;
         this.txt_stamina.text = param1;
         var _loc3_:* = this.__parent.char_data.max_stamina;
         this.curr_stamina.text = _loc3_;
         this.new_stamina.text = "";
         this.stamBar.scaleX = this.__parent.char_data.stamina / this.__parent.char_data.max_stamina;
         this.restoreType.gotoAndStop(2);
         if(_loc2_ > 0)
         {
            this.restoreType.gotoAndStop(1);
            this.btn_restore.visible = true;
            this.eventHandler.addListener(this.btn_restore,MouseEvent.CLICK,this.onRestoreStamina);
         }
         else if(Character.account_tokens >= 10)
         {
            this.btn_restore.visible = true;
            this.restoreType.gotoAndStop(2);
            this.eventHandler.addListener(this.btn_restore,MouseEvent.CLICK,this.onRestoreStamina);
         }
         else if(_loc2_ == 0 && Character.account_tokens >= 10)
         {
            this.btn_restore.visible = false;
            this.restoreType.gotoAndStop(2);
         }
         if(_loc3_ < 200)
         {
            this.new_stamina.text = String(int(_loc3_) + int(50));
            this.btn_upgrade.visible = true;
            this.eventHandler.addListener(this.btn_upgrade,MouseEvent.CLICK,this.onUpgradeMaxStamina);
         }
      }
      
      public function buyOnigiriPackage(param1:MouseEvent) : *
      {
         this.main.loadPanel("Popups.OnigiriPackages");
      }
      
      public function closePopup(param1:MouseEvent = null) : *
      {
         parent.removeChild(this);
         this.destroy();
      }
      
      public function onRestoreStamina(param1:MouseEvent) : *
      {
         var _loc2_:MouseEvent = param1;
         this.pop = null;
         this.pop = new Confirmation();
         var _loc3_:* = this.restoreType.currentFrame == 1 ? " 1 Roll?" : " 10 Tokens?";
         this.pop.txtMc.txt.text = "Are you sure that you want to restore 50 Stamina with " + _loc3_;
         this.eventHandler.addListener(this.pop.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.pop.btn_confirm,MouseEvent.CLICK,this.onRestoreStaminaConf);
         addChild(this.pop);
      }
      
      public function removeConfirmation(param1:MouseEvent) : *
      {
         this.eventHandler.removeListener(this.pop.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.removeListener(this.pop.btn_confirm,MouseEvent.CLICK,this.onUpgradeMaxStaminaConf);
         this.removeChild(this.pop);
         this.pop = null;
      }
      
      public function onRestoreStaminaConf(param1:MouseEvent) : *
      {
         this.restore_type = this.restoreType.currentFrame == 1 ? "rolls" : "tokens";
         Clan.instance.restoreStamina(this.onRestoreStaminaRes);
      }
      
      public function onUpgradeMaxStamina(param1:MouseEvent) : *
      {
         var _loc2_:MouseEvent = param1;
         this.pop = null;
         this.pop = new Confirmation();
         this.pop.txtMc.txt.text = "Are you sure that you want to increase your max stamina for 50 with 500 Tokens?";
         this.eventHandler.addListener(this.pop.btn_close,MouseEvent.CLICK,this.removeConfirmation);
         this.eventHandler.addListener(this.pop.btn_confirm,MouseEvent.CLICK,this.onUpgradeMaxStaminaConf);
         addChild(this.pop);
      }
      
      public function onUpgradeMaxStaminaConf(param1:MouseEvent) : *
      {
         this.main.loading(true);
         Clan.instance.upgradeMaxStamina(this.onUpgradeStaminaRes);
      }
      
      public function onUpgradeStaminaRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("unknown");
            return;
         }
         if(param1 == "ok")
         {
            Character.account_tokens -= 500;
            this.refreshData();
         }
      }
      
      public function refreshData() : *
      {
         Clan.instance.getClanData(this.onRefreshData);
      }
      
      public function onRefreshData(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("clan") && param1.hasOwnProperty("char"))
         {
            Character.clan_data = param1.clan;
            Character.clan_char_data = param1.char;
            if(this.__parent != null)
            {
               this.__parent.clan_data = param1.clan;
               this.__parent.char_data = param1.char;
               this.__parent.setDisplay();
               this.updateDisplay(this.txt_stamina.text);
            }
            removeChild(this.pop);
            this.pop = null;
            this.closePopup();
            return;
         }
         if(param2 != null)
         {
            this.main.removeLoadedPanel("Panels.ClanVillage");
            this.main.getError("Error");
            this.destroy();
         }
         removeChild(this.pop);
         this.pop = null;
         this.closePopup();
      }
      
      public function onRestoreStaminaRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 == "ok")
         {
            if(this.restore_type == "rolls")
            {
               Character.removeMaterials("material_69");
            }
            else
            {
               Character.account_tokens -= 10;
            }
            this.refreshData();
            return;
         }
         if(param2 != null)
         {
            this.main.getError("unknown error");
         }
      }
      
      public function destroy() : *
      {
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.pop = null;
         this.main = null;
         this.__parent = null;
      }
   }
}
