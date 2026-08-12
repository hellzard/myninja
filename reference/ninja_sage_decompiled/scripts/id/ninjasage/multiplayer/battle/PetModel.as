package id.ninjasage.multiplayer.battle
{
   import Managers.AppManager;
   import Storage.PetInfo;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.base.PetModelBase;
   
   public class PetModel extends PetModelBase
   {
       
      
      private var petHolder:MovieClip;
      
      private var _hpAnimating:Boolean = false;
      
      private var _hpAnimationTimer:Timer = null;
      
      private var _hpAnimData:Object = null;
      
      public function PetModel(param1:String = "player_pet", param2:int = 0)
      {
         super(param1,param2);
      }
      
      public function setup(param1:PetManager, param2:Battle) : *
      {
         this.pet_swf = param1.getPetSWF();
         this.petHolder = param2.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber());
         this.setupBottomBarInfo(param1,param2);
         AppManager.getInstance().main.loadPetSWF(this.pet_swf,this.onPetLoaded);
      }
      
      public function onPetLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         this.pet_info = PetInfo.getCopy(this.pet_swf);
         this.object_mc = param1.target.content[this.pet_swf];
         this.object_mc.gotoAndStop(1);
         if(true)
         {
            this.object_mc.stopAllMovieClips();
         }
         this.object_head = param1.target.content["pet_head"];
         this.setFrameScript();
         this.setScalingAndSaveStartingPosition();
         GF.removeAllChild(this.petHolder.charMc);
         this.petHolder.charMc.scaleX = this.getPlayerTeam() == "player_pet" ? -1 : 1;
         this.petHolder.charMc.addChild(this.object_mc);
      }
      
      public function getHead() : MovieClip
      {
         if(this.object_head)
         {
            return this.object_head;
         }
         return null;
      }
      
      public function setupBottomBarInfo(param1:PetManager, param2:*) : *
      {
         var _loc3_:* = param2.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber());
         _loc3_.hpBar.scaleX = Math.max(Math.min(param1.getCurrentHP() / param1.getMaxHP(),1),0);
         _loc3_.txtmc.nameTxt.htmlText = "Lv. " + param1.getLevel() + " " + param1.getName();
      }
      
      public function refreshStats(param1:PetManager, param2:*) : PetModel
      {
         if(this._hpAnimating)
         {
            return this;
         }
         param2.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber()).hpBar.scaleX = Math.max(Math.min(param1.getCurrentHP() / param1.getMaxHP(),1),0);
         return this;
      }
      
      public function animateHpToZero(param1:int, param2:int, param3:int, param4:PetManager, param5:*) : void
      {
         this.stopHpAnimation();
         this._hpAnimating = true;
         var _loc6_:int = Math.max(1,Math.ceil(param3 / 50));
         var _loc7_:int = Math.ceil(param3 / _loc6_);
         this._hpAnimData = {
            "fromHp":param1,
            "maxHp":param2,
            "totalTicks":_loc6_,
            "currentTick":0,
            "petId":param4.getID(),
            "battle":param5
         };
         this._hpAnimationTimer = new Timer(_loc7_,_loc6_);
         this._hpAnimationTimer.addEventListener(TimerEvent.TIMER,this.onHpAnimationTick);
         this._hpAnimationTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHpAnimationComplete);
         this._hpAnimationTimer.start();
      }
      
      private function onHpAnimationTick(param1:TimerEvent) : void
      {
         if(!this._hpAnimData)
         {
            return;
         }
         ++this._hpAnimData.currentTick;
         var _loc2_:Number = this._hpAnimData.currentTick / this._hpAnimData.totalTicks;
         var _loc3_:int = Math.max(0,Math.round(this._hpAnimData.fromHp * (1 - _loc2_)));
         var _loc4_:*;
         (_loc4_ = this._hpAnimData.battle.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber())).hpBar.scaleX = Math.max(Math.min(_loc3_ / this._hpAnimData.maxHp,1),0);
      }
      
      private function onHpAnimationComplete(param1:TimerEvent) : void
      {
         var _loc2_:* = undefined;
         this._hpAnimating = false;
         if(this._hpAnimationTimer)
         {
            this._hpAnimationTimer.removeEventListener(TimerEvent.TIMER,this.onHpAnimationTick);
            this._hpAnimationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onHpAnimationComplete);
            this._hpAnimationTimer.stop();
            this._hpAnimationTimer = null;
         }
         if(this._hpAnimData)
         {
            _loc2_ = this._hpAnimData.battle.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber());
            _loc2_.hpBar.scaleX = 0;
            this._hpAnimData = null;
         }
      }
      
      public function stopHpAnimation() : void
      {
         this._hpAnimating = false;
         if(this._hpAnimationTimer)
         {
            this._hpAnimationTimer.removeEventListener(TimerEvent.TIMER,this.onHpAnimationTick);
            this._hpAnimationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onHpAnimationComplete);
            this._hpAnimationTimer.stop();
            this._hpAnimationTimer = null;
         }
         this._hpAnimData = null;
      }
      
      override public function attackHit() : *
      {
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.HIT));
      }
      
      override public function attackFinish() : *
      {
         super.attackFinish();
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.ATTACK_FINISHED));
      }
      
      override public function dodgeFrame() : *
      {
         super.dodgeFrame();
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.DODGE_FINISHED));
      }
      
      override public function attackedFrame() : *
      {
         super.attackedFrame();
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.HIT));
      }
      
      override public function deadFrame() : *
      {
         super.deadFrame();
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.DEAD));
      }
      
      override public function addFullScreen() : *
      {
         super.addFullScreen();
         if(this.object_mc.hasOwnProperty("fullScreenEffect"))
         {
            AppManager.getInstance().main.loader.addChild(this.object_mc.fullScreenEffect);
         }
      }
      
      override public function removeFullScreen() : *
      {
         if(this.object_mc.hasOwnProperty("fullScreenEffect"))
         {
            AppManager.getInstance().main.loader.removeChild(this.object_mc.fullScreenEffect);
         }
         super.removeFullScreen();
      }
      
      override public function destroy() : *
      {
         Log.debug(this,"destroy",this.getPlayerTeam() + "_" + this.getPlayerNumber());
         this.stopHpAnimation();
         super.destroy();
      }
   }
}
