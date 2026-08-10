package id.ninjasage.pvp.battle
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import id.ninjasage.multiplayer.battle.base.SkillHandlerBase;
   
   public class PvPSkillHandler extends SkillHandlerBase
   {
      
      private var _filledBunshins:Dictionary = new Dictionary(true);
      
      public function PvPSkillHandler(param1:MovieClip, param2:String, param3:int, param4:Object)
      {
         super(param1,param2,param3,param4,PvPBattleVars.SKILL_SCALE);
      }
      
      override public function handleHitAnimation() : void
      {
         PvPBattleManager.BATTLE_HANDLER.handleHit();
      }
      
      override public function handleEndAnimation() : void
      {
         PvPBattleManager.BATTLE_HANDLER.handleSkillFinished(this.skill_info.skill_id);
         PvPBattleManager.getBattle().showCharacterMc(this.player_team,this.player_number);
         super.handleEndAnimation();
      }
      
      override public function handleBunshin(param1:MovieClip) : void
      {
         if(this._filledBunshins[param1])
         {
            return;
         }
         this._filledBunshins[param1] = true;
         var _loc2_:* = PvPBattleManager.CHARACTER_MANAGERS[this.player_team][this.player_number];
         var _loc3_:String = _loc2_.getWeapon();
         var _loc4_:String = _loc2_.getBackItem();
         var _loc5_:String = _loc2_.getClothing();
         var _loc6_:String = _loc2_.getHair();
         var _loc7_:String = _loc2_.getFace();
         var _loc8_:String = _loc2_.getHairColor();
         var _loc9_:String = _loc2_.getSkinColor();
         this.fillOutfit(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,param1);
      }
      
      override public function handleFlyingObject(param1:MovieClip, param2:String) : void
      {
         this.startPoint = null;
         this.targetPoint = null;
         this.point = null;
         var _loc3_:int = 125;
         var _loc4_:int = 600;
         var _loc5_:int = this.getTarget();
         var _loc6_:String = this.getEnemyTeam();
         var _loc7_:MovieClip = PvPBattleManager.getBattle().getObjectHolder(_loc6_,_loc5_);
         var _loc8_:Point = new Point(_loc7_.x + _loc3_,_loc7_.y + _loc4_);
         if(param2 == "target")
         {
            this.targetPoint = _loc8_;
         }
         else
         {
            this.point = _loc8_;
         }
         this.playFlyingObject(param1);
      }
      
      override public function addFullScreen() : void
      {
         try
         {
            super.addFullScreen();
            if(Boolean(this.skill_info.anims.hasOwnProperty("fullscreen")) && Boolean(this.skill_info.anims.fullscreen.hasOwnProperty("top")))
            {
               GF.removeParent(this.fcHolder);
               this.fcHolder = new MovieClip();
               this.fcHolder.addChild(this.skill_mc.fullScreenEffect);
               this.fcHolder.x = 0;
               this.fcHolder.y = 0;
               PvPBattleManager.getBattle().addChild(this.fcHolder);
               PvPBattleManager.getBattle().setChildIndex(this.fcHolder,3);
               PvPBattleManager.getBattle().setChildIndex(PvPBattleManager.getBattle().getObjectHolder(this.player_team,this.player_number),PvPBattleManager.getBattle().numChildren - 1);
            }
            else
            {
               PvPBattleManager.getMain().loader.addChild(this.skill_mc.fullScreenEffect);
            }
         }
         catch(e:*)
         {
         }
      }
      
      override public function removeFullScreen() : void
      {
         try
         {
            if(Boolean(this.skill_info.anims.hasOwnProperty("fullscreen")) && Boolean(this.skill_info.anims.fullscreen.hasOwnProperty("top")))
            {
               PvPBattleManager.getBattle().removeChild(this.fcHolder);
               this.fcHolder = null;
            }
            else
            {
               PvPBattleManager.getMain().loader.removeChild(this.skill_mc.fullScreenEffect);
            }
         }
         catch(e:*)
         {
         }
      }
   }
}

