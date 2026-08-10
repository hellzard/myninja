package Panels
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PetTraining extends MovieClip
   {
      
      private var trainTimer:Timer = null;
      
      private var slotHolder:MovieClip;
      
      private var trainingTime:uint;
      
      private var remainingTime:uint;
      
      private var slotNum:uint;
      
      private var petId:uint;
      
      private var petDataId:uint;
      
      private var cbFnComplete:Function;
      
      private var cbFnTick:Function;
      
      public function PetTraining()
      {
         super();
      }
      
      public function startTimer(param1:int, param2:MovieClip, param3:uint, param4:int, param5:Function, param6:Function) : *
      {
         this.slotHolder = param2;
         this.slotNum = uint(String(this.slotHolder.name).substr(7,1));
         this.remainingTime = param3;
         this.trainingTime = param4;
         this.cbFnTick = param5;
         this.cbFnComplete = param6;
         this.petId = param1;
         if(this.remainingTime == 0)
         {
            this.cbFnComplete(this.slotNum);
         }
         else if(this.trainTimer == null)
         {
            this.trainTimer = new Timer(1000,this.remainingTime);
            this.trainTimer.addEventListener(TimerEvent.TIMER,this.onUpdateProgress);
            this.trainTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.trainTimer.start();
         }
      }
      
      private function onUpdateProgress(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.remainingTime > 0)
         {
            --this.remainingTime;
         }
         if(this.slotHolder["timerTxt"])
         {
            _loc2_ = int(this.remainingTime);
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            _loc3_ = Math.floor(_loc2_ / 60);
            _loc4_ = Math.floor(_loc3_ / 60);
            _loc2_ %= 60;
            _loc3_ %= 60;
            this.slotHolder["timerTxt"].text = this.checkDigits(_loc4_) + ":" + this.checkDigits(_loc3_) + ":" + this.checkDigits(_loc2_);
            this.slotHolder["percentBar"].scaleX = Math.max(0,(this.trainingTime - this.remainingTime) / this.trainingTime);
            if(this.cbFnTick != null)
            {
               this.cbFnTick(this.petId);
            }
         }
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this.trainTimer.removeEventListener(TimerEvent.TIMER,this.onUpdateProgress);
         this.trainTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.trainTimer = null;
         if(this.cbFnTick != null)
         {
            this.cbFnTick(this.petId);
         }
         if(this.cbFnComplete != null)
         {
            this.stopTimer();
            this.cbFnComplete(this.slotNum);
         }
      }
      
      public function stopTimer() : *
      {
         if(this.trainTimer != null)
         {
            this.trainTimer.removeEventListener(TimerEvent.TIMER,this.onUpdateProgress);
            this.trainTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.trainTimer.reset();
            this.trainTimer.stop();
            this.trainTimer = null;
         }
      }
      
      public function destroy() : *
      {
         this.stopTimer();
         GF.removeAllChild(this.slotHolder);
         this.cbFnComplete = null;
         this.cbFnTick = null;
      }
      
      private function checkDigits(param1:int) : String
      {
         if(param1.toString().length < 2)
         {
            return "0" + param1.toString();
         }
         return param1.toString();
      }
   }
}

