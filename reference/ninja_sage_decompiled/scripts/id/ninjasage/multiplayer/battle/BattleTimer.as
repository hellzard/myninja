package id.ninjasage.multiplayer.battle
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import id.ninjasage.Log;
   
   public class BattleTimer
   {
      
      private static const TIMER_INTERVAL_MS:int = 1000;
      
      public static const DEFAULT_TURN_DURATION_SECONDS:int = 20;
       
      
      private var _timer:Timer;
      
      private var _turnDurationSeconds:int;
      
      private var _isRunning:Boolean = false;
      
      private var _isPaused:Boolean = false;
      
      private var _onTimerCompleteCallback:Function = null;
      
      private var _onTimerTickCallback:Function = null;
      
      public function BattleTimer(param1:int = 20)
      {
         super();
         this._turnDurationSeconds = param1 > 0 ? int(param1) : int(DEFAULT_TURN_DURATION_SECONDS);
      }
      
      public function startTurnTimer(param1:int = -1) : void
      {
         if(param1 > 0)
         {
            this._turnDurationSeconds = param1;
         }
         if(this._timer != null)
         {
            this.destroyOldTimer();
         }
         this._timer = new Timer(TIMER_INTERVAL_MS,this._turnDurationSeconds);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete,false,0,true);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimerTick,false,0,true);
         this._timer.start();
         this._isRunning = true;
         this._isPaused = false;
      }
      
      public function stopTurnTimer() : void
      {
         if(this._timer != null)
         {
            this.destroyOldTimer();
         }
      }
      
      private function destroyOldTimer() : void
      {
         if(this._timer != null)
         {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
            if(this._isRunning || this._isPaused)
            {
               this._timer.stop();
               this._timer.reset();
            }
            this._timer = null;
         }
         this._isRunning = false;
         this._isPaused = false;
      }
      
      public function pauseTurnTimer() : Boolean
      {
         if(this._timer == null || !this._isRunning || this._isPaused)
         {
            return false;
         }
         var _loc1_:int = this._turnDurationSeconds - this._timer.currentCount;
         this._turnDurationSeconds = Math.min(_loc1_,BattleTimer.DEFAULT_TURN_DURATION_SECONDS);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         this._timer.stop();
         this._timer.reset();
         this._timer = null;
         this._isRunning = false;
         this._isPaused = true;
         return true;
      }
      
      public function resumeTurnTimer() : Boolean
      {
         if(!this._isPaused)
         {
            return false;
         }
         var _loc1_:int = this._turnDurationSeconds;
         if(_loc1_ <= 0)
         {
            this._isPaused = false;
            return false;
         }
         if(this._timer != null)
         {
            this.destroyOldTimer();
         }
         this._timer = new Timer(TIMER_INTERVAL_MS,_loc1_);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete,false,0,true);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimerTick,false,0,true);
         this._timer.start();
         this._isRunning = true;
         this._isPaused = false;
         return true;
      }
      
      public function setTimerCompleteCallback(param1:Function) : void
      {
         this._onTimerCompleteCallback = param1;
      }
      
      public function setTimerTickCallback(param1:Function) : void
      {
         this._onTimerTickCallback = param1;
      }
      
      public function getTurnDurationSeconds() : int
      {
         return this._turnDurationSeconds;
      }
      
      public function getTimer() : Timer
      {
         return this._timer;
      }
      
      public function isPaused() : Boolean
      {
         return this._isPaused;
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         var event:TimerEvent = param1;
         if(!this._timer)
         {
            return;
         }
         if(this._onTimerTickCallback != null)
         {
            try
            {
               this._onTimerTickCallback();
            }
            catch(e:Error)
            {
               Log.error(this,"onTimerTick","Error executing timer tick callback: " + e.message);
            }
         }
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         var event:TimerEvent = param1;
         if(!this._timer)
         {
            return;
         }
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         this._isRunning = false;
         this._isPaused = false;
         if(this._onTimerCompleteCallback != null)
         {
            try
            {
               this._onTimerCompleteCallback();
            }
            catch(e:Error)
            {
               Log.error(this,"onTimerComplete","Error executing timer complete callback: " + e.message);
            }
         }
      }
      
      public function destroy() : void
      {
         this.destroyOldTimer();
         this._onTimerCompleteCallback = null;
         this._onTimerTickCallback = null;
      }
   }
}
