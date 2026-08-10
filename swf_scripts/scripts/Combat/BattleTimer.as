package Combat
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BattleTimer
   {
      
      public static var turn_timer:Timer = null;
      
      public static var turn_timer_seconds:int = 20;
      
      public function BattleTimer()
      {
         super();
      }
      
      public static function startTurnTimer() : *
      {
         if(turn_timer != null && turn_timer.running)
         {
            stopTurnTimer();
         }
         turn_timer = new Timer(1000,turn_timer_seconds);
         var _loc1_:* = BattleManager.getBattle();
         if(_loc1_)
         {
            _loc1_.atk_turnTimerTxt.visible = true;
            _loc1_.atk_turnTimerTxt.txt.text = String(turn_timer_seconds);
         }
         turn_timer.addEventListener(TimerEvent.TIMER,turnTimerTick,false,0,true);
         turn_timer.addEventListener(TimerEvent.TIMER_COMPLETE,turnTimerCompleted,false,0,true);
         turn_timer.start();
      }
      
      public static function stopTurnTimer() : *
      {
         if(turn_timer != null && turn_timer.running)
         {
            turn_timer.removeEventListener(TimerEvent.TIMER,turnTimerTick);
            turn_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,turnTimerCompleted);
            turn_timer.stop();
            turn_timer.reset();
         }
         var _loc1_:* = BattleManager.getBattle();
         if(_loc1_)
         {
            _loc1_.atk_turnTimerTxt.visible = false;
            _loc1_.atk_turnTimerTxt.txt.text = "";
         }
      }
      
      public static function turnTimerTick(param1:TimerEvent) : *
      {
         var _loc2_:* = BattleManager.getBattle();
         if(BattleVars.MATCH_RUNNING && Boolean(_loc2_))
         {
            _loc2_.atk_turnTimerTxt.txt.text = String(turn_timer_seconds - int(param1.currentTarget.currentCount));
         }
      }
      
      public static function turnTimerCompleted(param1:TimerEvent) : *
      {
         var _loc3_:Object = null;
         turn_timer.removeEventListener(TimerEvent.TIMER,turnTimerTick);
         turn_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,turnTimerCompleted);
         var _loc2_:* = BattleManager.getBattle();
         if(_loc2_)
         {
            _loc2_.atk_turnTimerTxt.visible = false;
            _loc2_.atk_turnTimerTxt.txt.text = "";
            _loc2_.actionBar.visible = false;
            try
            {
               _loc3_ = _loc2_.character_team_players[0];
               if(Boolean(_loc3_) && Boolean(_loc3_.actions_manager))
               {
                  _loc3_.actions_manager.disableKeyboardShortcuts();
               }
            }
            catch(err:*)
            {
            }
         }
         if(BattleVars.MATCH_RUNNING)
         {
            BattleManager.startRun();
         }
      }
      
      public static function destroy() : *
      {
         stopTurnTimer();
         turn_timer = null;
      }
   }
}

