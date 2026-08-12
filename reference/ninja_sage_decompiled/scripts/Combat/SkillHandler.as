package Combat
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import id.ninjasage.multiplayer.battle.base.SkillHandlerBase;
   
   public class SkillHandler extends SkillHandlerBase
   {
       
      
      private var rox:int = 1337;
      
      public function SkillHandler(param1:MovieClip, param2:String, param3:int, param4:Object)
      {
         this.rox = Math.round(Math.random() * 2147483647);
         super(param1,param2,param3,param4,BattleVars.SKILL_SCALE);
      }
      
      override public function handleHitAnimation() : void
      {
         BattleManager.getBattle()[this.getActionType("hit")](this.player_team,this.player_number,this.skill_info.skill_id);
      }
      
      override public function handleEndAnimation() : void
      {
         super.handleEndAnimation();
         BattleManager.getBattle()[this.getActionType("finish")](this.player_team,this.player_number,this.skill_info.skill_id);
      }
      
      override public function handleBunshin(param1:MovieClip) : void
      {
         var _loc2_:String = BattleManager.getBattle().attacker_model.character_manager.getWeapon();
         var _loc3_:String = BattleManager.getBattle().attacker_model.character_manager.getBackItem();
         var _loc4_:String = BattleManager.getBattle().attacker_model.character_manager.getClothing();
         var _loc5_:String = BattleManager.getBattle().attacker_model.character_manager.getHair();
         var _loc6_:String = BattleManager.getBattle().attacker_model.character_manager.getFace();
         var _loc7_:String = BattleManager.getBattle().attacker_model.character_info.hair_color;
         var _loc8_:String = BattleManager.getBattle().attacker_model.character_info.skin_color;
         this.fillOutfit(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,param1);
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
         var _loc7_:MovieClip = BattleManager.getBattle().getObjectHolder(_loc6_,_loc5_);
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
      
      override public function setCurrentCooldown(param1:int) : void
      {
         this.c_skill_cooldown = param1 ^ this.rox;
      }
      
      override public function getCurrentCooldown() : int
      {
         return this.c_skill_cooldown ^ this.rox;
      }
      
      override public function addFullScreen() : void
      {
         try
         {
            super.addFullScreen();
            if(this.skill_info.anims.hasOwnProperty("fullscreen") && this.skill_info.anims.fullscreen.hasOwnProperty("top"))
            {
               this.fcHolder = new MovieClip();
               this.fcHolder.addChild(this.skill_mc.fullScreenEffect);
               this.fcHolder.x = 0;
               this.fcHolder.y = 0;
               BattleManager.getBattle().addChild(this.fcHolder);
               BattleManager.getBattle().setChildIndex(this.fcHolder,3);
               BattleManager.getBattle().setChildIndex(BattleManager.getBattle().getObjectHolder(this.player_team,this.player_number),BattleManager.getBattle().numChildren - 1);
            }
            else
            {
               BattleManager.getMain().loader.addChild(this.skill_mc.fullScreenEffect);
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
            if(this.skill_info.anims.hasOwnProperty("fullscreen") && this.skill_info.anims.fullscreen.hasOwnProperty("top"))
            {
               BattleManager.getBattle().removeChild(this.fcHolder);
               this.fcHolder = null;
            }
            else
            {
               BattleManager.getMain().loader.removeChild(this.skill_mc.fullScreenEffect);
            }
         }
         catch(e:*)
         {
         }
      }
      
      override protected function getTarget() : int
      {
         return this.player_team == "player" ? int(BattleVars.PLAYER_TARGET) : int(BattleVars.ENEMY_TARGET);
      }
   }
}
