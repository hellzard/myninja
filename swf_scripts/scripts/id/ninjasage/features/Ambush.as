package id.ninjasage.features
{
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import id.ninjasage.EventHandler;
   
   public class Ambush extends MovieClip
   {
      
      public var panelMC:MovieClip;
      
      public const TIME:uint = 30;
      
      private var randomNumberArr:Array;
      
      public const ENEMY_DEFAULT_HIT_CHANCE:Number = 0.0001;
      
      private var maxEngageNum:uint = 5;
      
      private var engagedNum:uint = 0;
      
      private var minEngageNum:uint = 3;
      
      public const DISTANCE:uint = 650;
      
      public const ENEMY_HIT_CHANCE_INC:Number = 0.0001;
      
      private var randomNumberFlag:uint = 0;
      
      private var enemyHitChance:Number;
      
      private var characterMC:MovieClip;
      
      private var main:*;
      
      private var character:*;
      
      private var eventHandler:*;
      
      public function Ambush(param1:*, param2:*, param3:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.characterMC = param3;
         this.characterMC.scaleX = -0.7;
         this.characterMC.scaleY = 0.7;
         this.eventHandler = new EventHandler();
         this.randomNumberArr = [];
         var _loc4_:int = 0;
         while(_loc4_ < 100)
         {
            this.randomNumberArr.push(NumberUtil.getRandom());
            _loc4_++;
         }
         this.onInit();
      }
      
      private function onInit() : void
      {
         this.panelMC["ambushMc"].addFrameScript(0,this.stopNotice,28,this.onAmbushFinish);
         this.panelMC["ambushMc"].gotoAndStop("idle");
         if(this.panelMC["runBar"]["closeup"])
         {
            GF.removeParent(this.panelMC["runBar"]["closeup"]);
         }
         this.panelMC["runBar"]["closeup"] = this.panelMC["runBar"].addChild(this.main.getPlayerHead());
         GF.removeAllChild(this.panelMC["charMc"]);
         this.panelMC["charMc"].addChild(this.characterMC);
         this.enemyHitChance = this.ENEMY_DEFAULT_HIT_CHANCE;
         this.randomNumberFlag = 0;
         this.engagedNum = this.main.ambushBattleData.current_engagement;
         this.minEngageNum = this.main.ambushBattleData.min_engagement;
         this.maxEngageNum = this.main.ambushBattleData.max_engagement;
         this.resume();
      }
      
      public function resume() : void
      {
         this.panelMC.visible = true;
         this.panelMC["runBar"].visible = true;
         this.panelMC["bg"].visible = true;
         this.panelMC["charMc"].visible = true;
         this.characterMC.gotoAndPlay("run");
         this.panelMC["bg"].play();
         this.eventHandler.addListener(this,Event.ENTER_FRAME,this.running);
      }
      
      public function pause() : void
      {
         this.eventHandler.removeListener(this,Event.ENTER_FRAME,this.running);
         this.eventHandler.removeAllEventListeners();
         this.panelMC["bg"].stop();
         this.characterMC.gotoAndStop("stand");
      }
      
      public function onAmbushFinish() : void
      {
         this.panelMC["ambushMc"].gotoAndStop("idle");
         this.main.startAmbushBattle();
         this.panelMC["runBar"].visible = false;
         this.panelMC["bg"].visible = false;
         this.panelMC["charMc"].visible = false;
         this.panelMC.visible = false;
      }
      
      public function onGoal() : void
      {
         this.panelMC.stop();
         this.main.is_ambush_battle = false;
         this.main.combat.endBattle(true);
      }
      
      public function stopNotice() : void
      {
         this.panelMC["ambushMc"].stop();
      }
      
      private function running(param1:Event) : void
      {
         if(this.randomNumberFlag >= this.randomNumberArr.length)
         {
            this.randomNumberFlag = 0;
         }
         var _loc2_:Number = Number(this.randomNumberArr[this.randomNumberFlag]);
         ++this.randomNumberFlag;
         if(this.panelMC["runBar"]["closeup"].x / this.DISTANCE > this.engagedNum / this.minEngageNum && this.panelMC["runBar"]["closeup"].x > 200)
         {
            _loc2_ = 0;
         }
         if(_loc2_ < this.enemyHitChance && this.engagedNum < this.maxEngageNum)
         {
            this.pause();
            ++this.engagedNum;
            this.main.ambushBattleData.current_engagement = this.engagedNum;
            this.enemyHitChance = this.ENEMY_DEFAULT_HIT_CHANCE;
            this.panelMC["ambushMc"].gotoAndPlay("play");
         }
         else
         {
            this.enemyHitChance += this.ENEMY_HIT_CHANCE_INC;
            if(this.panelMC["runBar"]["closeup"].x >= this.DISTANCE)
            {
               this.pause();
               this.onGoal();
            }
            else
            {
               this.panelMC["runBar"]["closeup"].x += 40 * this.TIME / this.DISTANCE;
            }
         }
      }
   }
}

