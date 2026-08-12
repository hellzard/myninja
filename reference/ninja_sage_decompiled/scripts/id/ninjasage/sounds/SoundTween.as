package id.ninjasage.sounds
{
   import flash.utils.getTimer;
   import id.ninjasage.signals.Signal;
   
   public class SoundTween
   {
       
      
      public var startTime:int;
      
      public var startVolume:Number;
      
      public var endVolume:Number;
      
      public var duration:Number;
      
      protected var isMasterFade:Boolean;
      
      protected var _sound:SoundInstance;
      
      protected var _isComplete:Boolean;
      
      public var ended:Signal;
      
      public var stopAtZero:Boolean;
      
      public function SoundTween(param1:SoundInstance, param2:Number, param3:Number, param4:Boolean = false)
      {
         super();
         if(param1)
         {
            this.sound = param1;
            this.startVolume = this.sound.volume;
         }
         this.ended = new Signal(SoundInstance);
         this.isMasterFade = param4;
         this.init(this.startVolume,param2,param3);
      }
      
      protected static function easeOutQuad(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * (param1 = param1 / param4) * (param1 - 2) + param2;
      }
      
      protected static function easeInOutQuad(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if((param1 = param1 / (param4 / 2)) < 1)
         {
            return param3 / 2 * param1 * param1 + param2;
         }
         return -param3 / 2 * (--param1 * (param1 - 2) - 1) + param2;
      }
      
      public function update(param1:int) : Boolean
      {
         if(this._isComplete)
         {
            return this._isComplete;
         }
         if(this.isMasterFade)
         {
            if(param1 - this.startTime < this.duration)
            {
               SoundAS.masterVolume = easeOutQuad(param1 - this.startTime,this.startVolume,this.endVolume - this.startVolume,this.duration);
            }
            else
            {
               SoundAS.masterVolume = this.endVolume;
            }
            this._isComplete = SoundAS.masterVolume == this.endVolume;
         }
         else
         {
            if(param1 - this.startTime < this.duration)
            {
               this.sound.volume = easeOutQuad(param1 - this.startTime,this.startVolume,this.endVolume - this.startVolume,this.duration);
            }
            else
            {
               this.sound.volume = this.endVolume;
            }
            this._isComplete = this.sound.volume == this.endVolume;
         }
         return this._isComplete;
      }
      
      public function init(param1:Number, param2:Number, param3:Number) : void
      {
         this.startTime = getTimer();
         this.startVolume = param1;
         this.endVolume = param2;
         this.duration = param3;
         this._isComplete = false;
      }
      
      public function end(param1:Boolean = false) : void
      {
         this._isComplete = true;
         if(!this.isMasterFade)
         {
            if(param1)
            {
               this.sound.volume = this.endVolume;
            }
            if(this.stopAtZero && this.sound.volume == 0)
            {
               this.sound.stop();
            }
         }
         this.ended.dispatch(this.sound);
         this.ended.removeAll();
      }
      
      public function kill() : void
      {
         this._isComplete = true;
         this.ended.removeAll();
         this.ended = null;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
      
      public function get sound() : SoundInstance
      {
         return this._sound;
      }
      
      public function set sound(param1:SoundInstance) : void
      {
         this._sound = param1;
         if(this.sound)
         {
         }
      }
   }
}
