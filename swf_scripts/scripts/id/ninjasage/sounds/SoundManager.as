package id.ninjasage.sounds
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.media.Sound;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import id.ninjasage.signals.Signal;
   
   public class SoundManager
   {
      
      protected var instances:Vector.<SoundInstance>;
      
      protected var instancesBySound:Dictionary;
      
      protected var instancesByType:Object;
      
      protected var groupsByName:Object;
      
      public var groups:Vector.<SoundManager>;
      
      protected var activeTweens:Vector.<SoundTween>;
      
      protected var ticker:Sprite;
      
      protected var _tickEnabled:Boolean;
      
      protected var _mute:Boolean;
      
      protected var _volume:Number;
      
      protected var _pan:Number;
      
      protected var _masterVolume:Number;
      
      protected var _masterTween:SoundTween;
      
      private var _searching:Boolean;
      
      private var _enableSfx:Boolean;
      
      public var loadCompleted:Signal;
      
      public var loadFailed:Signal;
      
      public var parent:SoundManager;
      
      public function SoundManager()
      {
         super();
         this.init();
      }
      
      public function play(param1:String, param2:Number = 1, param3:Number = 0, param4:int = 0, param5:Boolean = false, param6:Boolean = true, param7:Boolean = false) : SoundInstance
      {
         var _loc8_:SoundInstance = this.getSound(param1);
         if(this.instances.indexOf(_loc8_) == -1)
         {
         }
         if(!param6 && _loc8_.isPlaying)
         {
            _loc8_.volume = param2;
         }
         else
         {
            _loc8_.play(param2,param3,param4,param5,param7);
         }
         return _loc8_;
      }
      
      public function playLoop(param1:String, param2:Number = 1, param3:Number = 0, param4:Boolean = true) : SoundInstance
      {
         return this.play(param1,param2,param3,-1,false,true,param4);
      }
      
      public function playFx(param1:String, param2:Number = 1, param3:Number = 0, param4:int = 0) : SoundInstance
      {
         return this.play(param1,this._enableSfx ? param2 : 0,param3,param4,true);
      }
      
      public function get enableSfx() : Boolean
      {
         return this._enableSfx;
      }
      
      public function set enableSfx(param1:Boolean) : void
      {
         this._enableSfx = param1;
      }
      
      public function stopAll() : void
      {
         var _loc1_:* = int(this.instances.length);
         while(_loc1_--)
         {
            this.instances[_loc1_].stop();
         }
      }
      
      public function resume(param1:String) : SoundInstance
      {
         return this.getSound(param1).resume();
      }
      
      public function resumeAll() : void
      {
         var _loc1_:* = int(this.instances.length);
         while(_loc1_--)
         {
            this.instances[_loc1_].resume();
         }
      }
      
      public function pause(param1:String) : SoundInstance
      {
         return this.getSound(param1).pause();
      }
      
      public function pauseAll() : void
      {
         var _loc1_:* = int(this.instances.length);
         while(_loc1_--)
         {
            this.instances[_loc1_].pause();
         }
      }
      
      public function fadeTo(param1:String, param2:Number = 1, param3:Number = 1000, param4:Boolean = true) : SoundInstance
      {
         return this.getSound(param1).fadeTo(param2,param3,param4);
      }
      
      public function fadeAllTo(param1:Number = 1, param2:Number = 1000, param3:Boolean = true) : void
      {
         var _loc4_:* = int(this.instances.length);
         while(_loc4_--)
         {
            this.instances[_loc4_].fadeTo(param1,param2,param3);
         }
      }
      
      public function fadeMasterTo(param1:Number = 1, param2:Number = 1000, param3:Boolean = true) : void
      {
         this.addMasterTween(this._masterVolume,param1,param2,param3);
      }
      
      public function fadeFrom(param1:String, param2:Number = 0, param3:Number = 1, param4:Number = 1000, param5:Boolean = true) : SoundInstance
      {
         return this.getSound(param1).fadeFrom(param2,param3,param4,param5);
      }
      
      public function fadeAllFrom(param1:Number = 0, param2:Number = 1, param3:Number = 1000, param4:Boolean = true) : void
      {
         var _loc5_:* = int(this.instances.length);
         while(_loc5_--)
         {
            this.instances[_loc5_].fadeFrom(param1,param2,param3,param4);
         }
      }
      
      public function fadeMasterFrom(param1:Number = 0, param2:Number = 1, param3:Number = 1000, param4:Boolean = true) : void
      {
         this.addMasterTween(param1,param2,param3,param4);
      }
      
      public function get mute() : Boolean
      {
         return this._mute;
      }
      
      public function set mute(param1:Boolean) : void
      {
         this._mute = param1;
         var _loc2_:* = int(this.instances.length);
         while(_loc2_--)
         {
            this.instances[_loc2_].mute = this._mute;
         }
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(param1:Number) : void
      {
         this._volume = param1;
         var _loc2_:* = int(this.instances.length);
         while(_loc2_--)
         {
            this.instances[_loc2_].volume = this._volume;
         }
      }
      
      public function get pan() : Number
      {
         return this._pan;
      }
      
      public function set pan(param1:Number) : void
      {
         this._pan = param1;
         var _loc2_:* = int(this.instances.length);
         while(_loc2_--)
         {
            this.instances[_loc2_].pan = this._pan;
         }
      }
      
      public function set soundTransform(param1:SoundTransform) : void
      {
         var _loc2_:* = int(this.instances.length);
         while(_loc2_--)
         {
            this.instances[_loc2_].soundTransform = param1;
         }
      }
      
      public function getSound(param1:String, param2:Boolean = false) : SoundInstance
      {
         var si:SoundInstance = null;
         var i:int = 0;
         var type:String = param1;
         var forceNew:Boolean = param2;
         if(this._searching)
         {
            return null;
         }
         try
         {
            this._searching = true;
            if(type == null)
            {
               return null;
            }
            si = this.instancesByType[type];
            if(!si)
            {
               if(!si && Boolean(this.parent))
               {
                  si = this.parent.getSound(type);
               }
               if(!si && Boolean(this.groups))
               {
                  i = int(this.groups.length);
                  while(i--)
                  {
                     si = this.groups[i].getSound(type);
                     if(si)
                     {
                        break;
                     }
                  }
               }
               if(Boolean(si) && this.instances.indexOf(si) == -1)
               {
                  this.addInstance(si);
               }
            }
            if(!si)
            {
               return null;
            }
            if(forceNew)
            {
               si = si.clone();
            }
         }
         finally
         {
            this._searching = false;
         }
         return si;
      }
      
      public function loadSound(param1:String, param2:String, param3:int = 100) : void
      {
         var _loc4_:SoundInstance = this.instancesByType[param2];
         if((Boolean(_loc4_)) && _loc4_.url == param1)
         {
            return;
         }
         _loc4_ = new SoundInstance(null,param2);
         _loc4_.url = param1;
         _loc4_.sound = new Sound(new URLRequest(param1),new SoundLoaderContext(param3,false));
         _loc4_.sound.addEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadError,false,0,true);
         _loc4_.sound.addEventListener(Event.COMPLETE,this.onSoundLoadComplete,false,0,true);
         this.addInstance(_loc4_);
      }
      
      public function isLoaded(param1:String) : Boolean
      {
         return this.instancesByType[param1];
      }
      
      public function addSound(param1:String, param2:Sound) : void
      {
         var _loc3_:SoundInstance = null;
         if(this.instancesByType[param1])
         {
            _loc3_ = this.instancesByType[param1];
            _loc3_.sound = param2;
         }
         else
         {
            _loc3_ = new SoundInstance(param2,param1);
         }
         this.addInstance(_loc3_);
      }
      
      public function removeSound(param1:String) : void
      {
         if(this.instancesByType[param1] == null)
         {
            return;
         }
         var _loc2_:* = int(this.instances.length);
         while(_loc2_--)
         {
            if(this.instances[_loc2_].type == param1)
            {
               this.instancesBySound[this.instances[_loc2_].sound] = null;
               this.instances[_loc2_].destroy();
               this.instances.splice(_loc2_,1);
            }
         }
         this.instancesByType[param1] = null;
      }
      
      public function removeAll() : void
      {
         var _loc1_:* = int(this.instances.length);
         while(_loc1_--)
         {
            this.instances[_loc1_].destroy();
         }
         if(this.groups)
         {
            _loc1_ = int(this.groups.length);
            while(_loc1_--)
            {
               this.groups[_loc1_].removeAll();
            }
            this.groups.length = 0;
         }
         this.init();
      }
      
      public function get masterVolume() : Number
      {
         return this._masterVolume;
      }
      
      public function set masterVolume(param1:Number) : void
      {
         var _loc2_:SoundInstance = null;
         this._masterVolume = param1;
         var _loc3_:* = int(this.instances.length);
         while(_loc3_--)
         {
            _loc2_ = this.instances[_loc3_];
            _loc2_.volume = _loc2_.volume;
         }
      }
      
      public function group(param1:String) : SoundManager
      {
         if(!this.groupsByName[param1])
         {
            this.groupsByName[param1] = new SoundManager();
            (this.groupsByName[param1] as SoundManager).parent = this;
            if(!this.groups)
            {
               this.groups = new Vector.<SoundManager>(0);
            }
            this.groups.push(this.groupsByName[param1]);
         }
         return this.groupsByName[param1];
      }
      
      protected function init() : void
      {
         if(!this.loadCompleted)
         {
            this.loadCompleted = new Signal(SoundInstance);
         }
         if(!this.loadFailed)
         {
            this.loadFailed = new Signal(SoundInstance);
         }
         this._volume = 1;
         this._pan = 0;
         this._masterVolume = 1;
         this.instances = new Vector.<SoundInstance>(0);
         this.instancesBySound = new Dictionary(true);
         this.instancesByType = {};
         this.groupsByName = {};
         this.activeTweens = new Vector.<SoundTween>();
      }
      
      internal function addMasterTween(param1:Number, param2:Number, param3:Number, param4:Boolean) : void
      {
         if(!this._masterTween)
         {
            this._masterTween = new SoundTween(null,0,0,true);
         }
         this._masterTween.init(param1,param2,param3);
         this._masterTween.stopAtZero = param4;
         this._masterTween.update(0);
         if(this.activeTweens.indexOf(this._masterTween) == -1)
         {
            this.activeTweens.push(this._masterTween);
         }
         this.tickEnabled = true;
      }
      
      internal function addTween(param1:String, param2:Number, param3:Number, param4:Number, param5:Boolean) : SoundTween
      {
         var _loc6_:SoundInstance = this.getSound(param1);
         if(param2 >= 0)
         {
            _loc6_.volume = param2;
         }
         if(_loc6_.fade)
         {
            _loc6_.fade.kill();
         }
         var _loc7_:SoundTween = new SoundTween(_loc6_,param3,param4);
         _loc7_.stopAtZero = param5;
         _loc7_.update(_loc7_.startTime);
         this.activeTweens.push(_loc7_);
         this.tickEnabled = true;
         return _loc7_;
      }
      
      protected function onTick(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:* = int(this.activeTweens.length);
         while(_loc3_--)
         {
            if(this.activeTweens[_loc3_].update(_loc2_))
            {
               this.activeTweens[_loc3_].end();
               this.activeTweens.splice(_loc3_,1);
            }
         }
         this.tickEnabled = this.activeTweens.length > 0;
      }
      
      protected function addInstance(param1:SoundInstance) : void
      {
         param1.mute = this._mute;
         param1.manager = this;
         if(this.instances.indexOf(param1) == -1)
         {
            this.instances.push(param1);
         }
         this.instancesBySound[param1.sound] = param1;
         this.instancesByType[param1.type] = param1;
      }
      
      protected function onSoundLoadComplete(param1:Event) : void
      {
         var _loc2_:Sound = param1.target as Sound;
         this.loadCompleted.dispatch(this.instancesBySound[_loc2_]);
         this.removeSoundListener(_loc2_);
      }
      
      protected function onSoundLoadProgress(param1:ProgressEvent) : void
      {
      }
      
      protected function onSoundLoadError(param1:IOErrorEvent) : void
      {
         var _loc2_:SoundInstance = this.instancesBySound[param1.target as Sound];
         this.loadFailed.dispatch(_loc2_);
         this.removeSoundListener(param1.target);
      }
      
      protected function removeSoundListener(param1:*) : *
      {
         if(!param1)
         {
            return;
         }
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadError);
         param1.removeEventListener(Event.COMPLETE,this.onSoundLoadComplete);
      }
      
      protected function get tickEnabled() : Boolean
      {
         return this._tickEnabled;
      }
      
      protected function set tickEnabled(param1:Boolean) : void
      {
         if(param1 == this._tickEnabled)
         {
            return;
         }
         this._tickEnabled = param1;
         if(this._tickEnabled)
         {
            if(!this.ticker)
            {
               this.ticker = new Sprite();
            }
            this.ticker.addEventListener(Event.ENTER_FRAME,this.onTick);
         }
         else
         {
            this.ticker.removeEventListener(Event.ENTER_FRAME,this.onTick);
         }
      }
   }
}

