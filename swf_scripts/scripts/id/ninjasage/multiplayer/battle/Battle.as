package id.ninjasage.multiplayer.battle
{
   import Managers.OutfitManager;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8049")]
   public class Battle extends MovieClip
   {
      
      public var atk_turnTimerTxt:MovieClip;
      
      public var battleTimeMc:TextField;
      
      public var berserkMC:MovieClip;
      
      public var btn_UI_Gear:SimpleButton;
      
      public var btn_UI_Option:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_openLog:SimpleButton;
      
      public var chatBoxMc:MovieClip;
      
      public var effectLogMC:MovieClip;
      
      public var hourglassMC:MovieClip;
      
      public var logo:MovieClip;
      
      public var spectatorViewMC:MovieClip;
      
      public var actionBar:MovieClip;
      
      public var atbBar:MovieClip;
      
      public var bgHolder:MovieClip;
      
      public var char_hpcp:MovieClip;
      
      public var charMc_0:MovieClip;
      
      public var charMc_1:MovieClip;
      
      public var charMc_2:MovieClip;
      
      public var charPetMc_0:MovieClip;
      
      public var charPetMc_1:MovieClip;
      
      public var charPetMc_2:MovieClip;
      
      public var enemyMc_0:MovieClip;
      
      public var enemyMc_1:MovieClip;
      
      public var enemyMc_2:MovieClip;
      
      public var enemyPetMc_0:MovieClip;
      
      public var enemyPetMc_1:MovieClip;
      
      public var enemyPetMc_2:MovieClip;
      
      public var scrollDisplayMc_0:MovieClip;
      
      public var scrollDisplayMc_1:MovieClip;
      
      public var scrollDisplayMc_2:MovieClip;
      
      public var senjutsuTransition:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var destroyed:Boolean = false;
      
      public function Battle()
      {
         super();
         this.eventHandler = new EventHandler();
         this.senjutsuTransition.gotoAndStop(1);
      }
      
      public function setupAgilityBar() : void
      {
         Log.debug(this,"setupAgilityBar","Setting up agility bar");
         if(this.enemyMc_0)
         {
            this.eventHandler.addListener(this.enemyMc_0,MouseEvent.CLICK,this.onTargetChange);
         }
         if(this.enemyMc_1)
         {
            this.eventHandler.addListener(this.enemyMc_1,MouseEvent.CLICK,this.onTargetChange);
         }
         if(this.enemyMc_2)
         {
            this.eventHandler.addListener(this.enemyMc_2,MouseEvent.CLICK,this.onTargetChange);
         }
      }
      
      private function onTargetChange(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:int = 0;
         if(_loc2_.indexOf("enemyMc_") >= 0)
         {
            _loc3_ = int(_loc2_.split("_")[1]);
            Log.debug(this,"onTargetChange","Player target changed to: " + _loc3_);
         }
      }
      
      public function getObjectHolder(param1:String, param2:int) : *
      {
         if(param1 == "player")
         {
            return this["charMc_" + param2.toString()];
         }
         if(param1 == "enemy")
         {
            return this["enemyMc_" + param2.toString()];
         }
         if(param1 == "player_pet")
         {
            return this["charPetMc_" + param2.toString()];
         }
         if(param1 == "enemy_pet")
         {
            return this["enemyPetMc_" + param2.toString()];
         }
      }
      
      public function startBattle() : *
      {
      }
      
      public function playHitAnimation(param1:String, param2:int, param3:String) : void
      {
      }
      
      public function hitByTalentSkill(param1:String, param2:int, param3:String) : void
      {
      }
      
      public function hitBySenjutsuSkill(param1:String, param2:int, param3:String) : void
      {
      }
      
      public function hitBySpecialSkill(param1:String, param2:int, param3:String) : void
      {
      }
      
      public function talentSkillAttackFinished(param1:String, param2:int, param3:String) : void
      {
         this.showCharacterMc(param1,param2);
      }
      
      public function senjutsuSkillAttackFinished(param1:String, param2:int, param3:String) : void
      {
         this.showCharacterMc(param1,param2);
      }
      
      public function specialSkillAttackFinished(param1:String, param2:int, param3:String) : void
      {
         this.showCharacterMc(param1,param2);
      }
      
      public function skillAttackFinished(param1:String, param2:int, param3:String) : void
      {
         this.showCharacterMc(param1,param2);
      }
      
      public function showCharacterMc(param1:String, param2:int) : void
      {
         var _loc3_:* = this.getObjectHolder(param1,param2).charMc;
         var _loc4_:* = this.getObjectHolder(param1,param2).skillMc;
         OutfitManager.removeChildsFromMovieClips(_loc4_);
         _loc3_.visible = true;
         _loc4_.visible = false;
      }
      
      public function clearBattleField() : void
      {
         Log.debug(this,"clearBattleField","Clearing battle field");
      }
      
      public function destroy() : void
      {
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         this.clearBattleField();
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
         }
         GF.removeAllChild(this.actionBar);
         GF.removeAllChild(this.atbBar);
         GF.removeAllChild(this.bgHolder);
         GF.removeAllChild(this.char_hpcp);
         GF.removeAllChild(this.charMc_0);
         GF.removeAllChild(this.charMc_1);
         GF.removeAllChild(this.charMc_2);
         GF.removeAllChild(this.charPetMc_0);
         GF.removeAllChild(this.charPetMc_1);
         GF.removeAllChild(this.charPetMc_2);
         GF.removeAllChild(this.enemyMc_0);
         GF.removeAllChild(this.enemyMc_1);
         GF.removeAllChild(this.enemyMc_2);
         GF.removeAllChild(this.enemyPetMc_0);
         GF.removeAllChild(this.enemyPetMc_1);
         GF.removeAllChild(this.enemyPetMc_2);
         GF.removeAllChild(this.scrollDisplayMc_0);
         GF.removeAllChild(this.scrollDisplayMc_1);
         GF.removeAllChild(this.scrollDisplayMc_2);
         GF.removeAllChild(this.senjutsuTransition);
         GF.removeAllChild(this.atk_turnTimerTxt);
         GF.removeAllChild(this.chatBoxMc);
         GF.removeAllChild(this.effectLogMC);
         GF.removeAllChild(this.logo);
         GF.removeAllChild(this.spectatorViewMC);
         this.actionBar = null;
         this.atbBar = null;
         this.bgHolder = null;
         this.char_hpcp = null;
         this.charMc_0 = null;
         this.charMc_1 = null;
         this.charMc_2 = null;
         this.charPetMc_0 = null;
         this.charPetMc_1 = null;
         this.charPetMc_2 = null;
         this.enemyMc_0 = null;
         this.enemyMc_1 = null;
         this.enemyMc_2 = null;
         this.enemyPetMc_0 = null;
         this.enemyPetMc_1 = null;
         this.enemyPetMc_2 = null;
         this.scrollDisplayMc_0 = null;
         this.scrollDisplayMc_1 = null;
         this.scrollDisplayMc_2 = null;
         this.senjutsuTransition = null;
         this.chatBoxMc = null;
         this.effectLogMC = null;
         this.logo = null;
         this.spectatorViewMC = null;
         GF.removeAllChild(this);
      }
   }
}

