package id.ninjasage.features
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class PvpLeague extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var response:Object;
      
      private var main:*;
      
      public function PvpLeague(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.getLeagueData();
      }
      
      public function getLeagueData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("jpwzlvqNru201CF3.k4epCvJA8mM9",[Character.char_id,Character.sessionkey],this.onLeagueResponse);
      }
      
      public function onLeagueResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.initUI();
         }
         else
         {
            this.main.getNotice(param1.result || "Unknown Error");
         }
      }
      
      private function initUI() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this.response.leagues[_loc1_].min || "";
            _loc3_ = this.response.leagues[_loc1_].max || "";
            _loc4_ = this.response.leagues[_loc1_].name || "";
            _loc5_ = _loc3_ == "" ? _loc2_ + "+" : _loc2_ + " - " + _loc3_;
            this.panelMC["amount_" + _loc1_].text = _loc5_;
            this.panelMC["name_" + _loc1_].text = _loc4_;
            _loc1_++;
         }
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}

