package id.ninjasage.multiplayer.battle
{
   import Managers.OutfitManager;
   import NinjaSage_fla.Symbol42_64;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.base.CharacterModelBase;
   import id.ninjasage.pvp.battle.PvPBattleManager;
   
   public class CharacterModel extends CharacterModelBase
   {
       
      
      public var back:MovieClip;
      
      public var back_hair:MovieClip;
      
      public var head:MovieClip;
      
      public var hitAreaMc:MovieClip;
      
      public var left_hand:MovieClip;
      
      public var left_lower_arm:MovieClip;
      
      public var left_lower_leg:MovieClip;
      
      public var left_shoe:MovieClip;
      
      public var left_upper_arm:MovieClip;
      
      public var left_upper_leg:MovieClip;
      
      public var lower_body:MovieClip;
      
      public var right_hand:MovieClip;
      
      public var right_lower_arm:MovieClip;
      
      public var right_lower_leg:MovieClip;
      
      public var right_shoe:MovieClip;
      
      public var right_upper_arm:MovieClip;
      
      public var right_upper_leg:MovieClip;
      
      public var shadow:MovieClip;
      
      public var skirt:MovieClip;
      
      public var throw02Mc:Symbol42_64;
      
      public var upper_body:MovieClip;
      
      public var weapon:MovieClip;
      
      public var weapon1:MovieClip;
      
      private var outfits;
      
      private var headMC:MovieClip = null;
      
      private var _hpAnimating:Boolean = false;
      
      private var _hpAnimationTimer:Timer = null;
      
      private var _hpAnimData:Object = null;
      
      public function CharacterModel(param1:String = "player", param2:int = 0)
      {
         this.outfits = [];
         addFrameScript(339,this.frame340);
         super(param1,param2);
         gotoAndStop(1);
      }
      
      public function setup(param1:CharacterManager, param2:Battle) : *
      {
         this.setModelFramescript();
         this.setAnimations(param1.getAnimations(),param1.getWeapon());
         this.setScalingAndSaveStartingPosition();
         this.loadOutfits(param1,param2);
         this.loadHead(param1);
         this.setupBottomBarInfo(param1,param2);
         this.setupTopLeftInfo(param1,param2);
         param2.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber()).charMc.scaleX = this.player_team == "player" ? -1 : 1;
      }
      
      public function loadOutfits(param1:CharacterManager, param2:Battle) : *
      {
         var _loc3_:* = new OutfitManager();
         if(!Character.is_stickman)
         {
            _loc3_.fillOutfit(this,param1.getWeapon(),param1.getBackItem(),param1.getClothing(),param1.getHair(),param1.getFace(),param1.getHairColor(),param1.getSkinColor());
         }
         this.outfits.push(_loc3_);
         var _loc4_:* = param2.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber());
         GF.removeAllChild(_loc4_.charMc);
         _loc4_.charMc.addChild(this);
         this.gotoStandby();
      }
      
      public function loadHead(param1:CharacterManager) : *
      {
         if(this.headMC)
         {
            GF.removeAllChild(this.headMC);
         }
         this.headMC = new (getDefinitionByName("CharHead") as Class)();
         var _loc2_:OutfitManager = new OutfitManager();
         _loc2_.fillHead(this.headMC,param1.getHair(),param1.getFace(),param1.getHairColor(),param1.getSkinColor());
         this.outfits.push(_loc2_);
      }
      
      public function getHead() : MovieClip
      {
         if(this.headMC)
         {
            return this.headMC;
         }
         return null;
      }
      
      public function setupBottomBarInfo(param1:CharacterManager, param2:*) : *
      {
         var _loc3_:* = param2.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber());
         _loc3_.hpBar.scaleX = Math.max(Math.min(param1.getCurrentHP() / param1.getMaxHP(),1),0);
         _loc3_.nameTxt.htmlText = Character.colorifyText(param1.getID(),"Lv. " + param1.getLevel() + " " + param1.getName(),_loc3_.nameTxt);
         _loc3_.rankMC.gotoAndStop(param1.getRank());
      }
      
      public function setupTopLeftInfo(param1:CharacterManager, param2:*) : *
      {
         if(param1.getID() == Character.char_id)
         {
            param2.char_hpcp.visible = true;
            param2.char_hpcp.txt_lvl.text = param1.getLevel();
            param2.char_hpcp.txt_name.htmlText = Character.colorifyText(param1.getID(),param1.getName(),param2.char_hpcp.txt_name);
            param2.char_hpcp.txt_hp.text = param1.getCurrentHP() + "/" + param1.getMaxHP();
            param2.char_hpcp.txt_cp.text = param1.getCurrentCP() + "/" + param1.getMaxCP();
            param2.char_hpcp.txt_xp.text = param1.getCurrentXP() + "/" + param1.getMaxXP();
            param2.char_hpcp.txt_sp.text = param1.getCurrentSP() + "/" + param1.getMaxSP();
            param2.char_hpcp.hpBar.scaleX = Math.max(Math.min(param1.getCurrentHP() / param1.getMaxHP(),1),0);
            param2.char_hpcp.cpBar.scaleX = Math.max(Math.min(param1.getCurrentCP() / param1.getMaxCP(),1),0);
            param2.char_hpcp.xpBar.scaleX = Math.max(Math.min(param1.getCurrentXP() / param1.getMaxXP(),1),0);
            param2.char_hpcp.spBar.scaleX = Math.max(Math.min(param1.getCurrentSP() / param1.getMaxSP(),1),0);
         }
      }
      
      public function refreshStats(param1:CharacterManager, param2:*) : CharacterModel
      {
         if(this._hpAnimating)
         {
            return this;
         }
         this.setupTopLeftInfo(param1,param2);
         param2.getObjectHolder(this.getPlayerTeam(),this.getPlayerNumber()).hpBar.scaleX = Math.max(Math.min(param1.getCurrentHP() / param1.getMaxHP(),1),0);
         return this;
      }
      
      public function animateHpToZero(param1:int, param2:int, param3:int, param4:CharacterManager, param5:*) : void
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
            "charId":param4.getID(),
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
         if(this._hpAnimData.charId == Character.char_id)
         {
            this._hpAnimData.battle.char_hpcp.txt_hp.text = _loc3_ + "/" + this._hpAnimData.maxHp;
            this._hpAnimData.battle.char_hpcp.hpBar.scaleX = Math.max(Math.min(_loc3_ / this._hpAnimData.maxHp,1),0);
         }
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
            if(this._hpAnimData.charId == Character.char_id)
            {
               this._hpAnimData.battle.char_hpcp.txt_hp.text = "0/" + this._hpAnimData.maxHp;
               this._hpAnimData.battle.char_hpcp.hpBar.scaleX = 0;
            }
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
      
      public function attackWithWeapon(param1:CharacterManager) : *
      {
         var _loc2_:Object = PvPBattleManager.getMain().getLibrary().getItemInfo(param1.getWeapon());
         var _loc3_:String = "attack_01";
         if(_loc2_.hasOwnProperty("attack_type"))
         {
            _loc3_ = _loc2_.attack_type;
         }
         var _loc4_:int = this.getPlayerTeam() == "player" ? int(PvPBattleManager.BATTLE_VARS.playerTarget) : int(PvPBattleManager.BATTLE_VARS.enemyTarget);
         var _loc5_:Array = [];
         var _loc6_:Object = this.calculateAttackPosition(_loc4_,_loc3_,_loc5_);
         this.x = _loc6_.x;
         this.y = _loc6_.y;
         this.gotoAndPlay(_loc3_);
      }
      
      override public function handleHitFrame() : *
      {
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.HIT));
      }
      
      override public function dodgeAnimationFinished() : *
      {
         super.dodgeAnimationFinished();
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.DODGE_FINISHED));
      }
      
      override public function chargeAnimationFinished() : *
      {
         super.chargeAnimationFinished();
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.CHARGE_FINISHED));
      }
      
      override public function weaponAttackFinished() : *
      {
         super.weaponAttackFinished();
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.WEAPON_FINISHED));
      }
      
      override public function itemAnimationFinished() : *
      {
         super.itemAnimationFinished();
         this.dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.ITEM_FINISHED));
      }
      
      override public function destroy() : *
      {
         Log.debug(this,"destroy",this.player_team + "_" + this.player_number);
         this.stopHpAnimation();
         super.destroy();
         if(this.headMC)
         {
            GF.removeAllChild(this.headMC);
         }
         GF.destroyArray(this.outfits);
         GF.removeAllChild(this);
         this.outfits = null;
         this.headMC = null;
      }
      
      function frame340() : *
      {
         this.stop();
      }
   }
}
