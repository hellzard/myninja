package Popups
{
   import Panels.ClanVillage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   import id.ninjasage.Clan;
   import id.ninjasage.EventHandler;
   
   public dynamic class ClanPrestigeBooster extends MovieClip
   {
       
      
      public var bg:MovieClip;
      
      public var prestigeBoosterMC:MovieClip;
      
      public var main;
      
      public var clanVillage:ClanVillage;
      
      public var eventHandler;
      
      public function ClanPrestigeBooster(param1:*, param2:*)
      {
         this.eventHandler = new EventHandler();
         super();
         this.main = param1;
         this.clanVillage = param2;
         this.prestigeBoosterMC.x -= this.main.stage.width;
         TweenLite.to(this.prestigeBoosterMC,0.5,{
            "x":622.85,
            "ease":"easeOutBack"
         });
         this.initUI();
      }
      
      public function initUI() : *
      {
         this.eventHandler.addListener(this.prestigeBoosterMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.prestigeBoosterMC.btn_boost,MouseEvent.CLICK,this.boostAmf);
      }
      
      public function boostAmf(param1:MouseEvent) : *
      {
         Clan.instance.boostPrestige(this.onBoostPrestigeRes);
      }
      
      public function onBoostPrestigeRes(param1:Object, param2:* = null) : *
      {
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("unknown message");
            return;
         }
         if(param1 != null && param1.hasOwnProperty("tokens"))
         {
            Character.account_tokens = param1.tokens;
            this.clanVillage.char_data.prestige_boost = param1.prestige_boost;
            this.clanVillage.setDisplay();
            this.clanVillage.checkTimeleft();
            this.main.showMessage(param1.result);
         }
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         TweenLite.killTweensOf(this.prestigeBoosterMC);
         GF.removeAllChild(this);
         this.destroy();
      }
      
      public function destroy() : *
      {
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.clanVillage = null;
      }
   }
}
