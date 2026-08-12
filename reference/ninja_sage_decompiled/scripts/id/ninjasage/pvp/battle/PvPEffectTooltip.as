package id.ninjasage.pvp.battle
{
   import Combat.Effects;
   import Managers.NinjaSage;
   import flash.events.MouseEvent;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   public class PvPEffectTooltip
   {
       
      
      private var _btn;
      
      private var _eventHandler:EventHandler;
      
      public function PvPEffectTooltip(param1:*)
      {
         super();
         this._btn = param1;
         this._eventHandler = new EventHandler();
         this._eventHandler.addListener(param1,MouseEvent.ROLL_OVER,this.onRollOver);
         this._eventHandler.addListener(param1,MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this._btn.metaData = {"tooltip_text":this.getEffectTooltipText()};
         NinjaSage.showTextDynamicTooltip(param1);
         NinjaSage.tooltip.multiLine = false;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         NinjaSage.toolTiponOut(param1);
         NinjaSage.tooltip.multiLine = true;
      }
      
      public function getEffectTooltipText() : String
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc1_:Array = PvPBattleManager.BATTLE_HANDLER.ownEffects;
         if(!_loc1_ || _loc1_.length == 0)
         {
            return "No active effects";
         }
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.duration > 0)
            {
               _loc4_ = !!Effects.all_buffs[_loc3_.effect] ? "#2e8b57" : "#ff0000";
               _loc2_.push("<font color=\"" + _loc4_ + "\">" + this.getEffectLine(_loc3_) + "</font>");
            }
         }
         return _loc2_.length > 0 ? _loc2_.join("\n") : "No active effects";
      }
      
      private function getEffectLine(param1:Object) : String
      {
         var _loc4_:Object = null;
         var _loc2_:String = param1.effect_name || "";
         if(_loc2_ == "")
         {
            if(_loc4_ = Effects.all_buffs[param1.effect] || Effects.all_debuffs[param1.effect])
            {
               _loc2_ = _loc4_.effect_name || "";
            }
         }
         if(_loc2_ == "")
         {
            return String(param1.effect);
         }
         if(Util.checkInArray(param1.effect,Effects.dont_need_show_duration))
         {
            return _loc2_;
         }
         var _loc3_:* = param1.duration;
         if(Util.checkInArray(param1.effect,Effects.need_to_show_minus_duration))
         {
            _loc3_ = Math.max(1,Number(param1.duration) - 1);
         }
         return _loc2_ + " (" + _loc3_ + ")";
      }
      
      public function destroy() : void
      {
         if(this._btn && this._eventHandler)
         {
            this._eventHandler.removeAllEventListeners();
         }
         this._eventHandler = null;
         this._btn = null;
      }
   }
}
