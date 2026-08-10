package id.ninjasage.multiplayer.battle.base
{
   import Managers.OutfitManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import gs.TweenLite;
   import id.ninjasage.Log;
   
   public class SkillHandlerBase
   {
      
      public var skill_mc:MovieClip;
      
      public var skill_info:Object;
      
      public var fcHolder:MovieClip;
      
      protected var c_skill_cooldown:int = 0;
      
      protected var skill_attack_hit_position:String;
      
      protected var player_team:String;
      
      protected var player_number:int;
      
      protected var player_target:int;
      
      protected var is_multi_hit:Boolean = false;
      
      protected var outfit_filled:Boolean = false;
      
      protected var startPoint:Point;
      
      protected var targetPoint:Point;
      
      protected var point:Point;
      
      protected var outfits:Array = [];
      
      protected var gender:int = 0;
      
      public function SkillHandlerBase(param1:MovieClip, param2:String, param3:int, param4:Object, param5:*)
      {
         super();
         this.skill_mc = param1;
         this.skill_info = param4;
         this.player_team = param2;
         this.player_number = param3;
         this.init(param5);
      }
      
      protected function init(param1:*) : void
      {
         this.skill_mc.scaleX = this.player_team == "player" ? -param1 : Number(param1);
         this.skill_mc.scaleY = param1;
         this.skill_attack_hit_position = "attack_hit_position" in this.skill_info || this.skill_info.attack_hit_position != "" ? this.skill_info.attack_hit_position : "startpos";
         this.skill_info.skill_type = "skill_type" in this.skill_info ? this.skill_info.skill_type : (this.skill_info.type == null ? this.skill_info.talent_type : this.skill_info.type);
         this.skill_info.skill_cooldown = "skill_cooldown" in this.skill_info ? this.skill_info.skill_cooldown : this.skill_info.cooldown;
         this.setCurrentCooldown(0);
         this.setFrameScript();
      }
      
      protected function setFrameScript() : void
      {
         var i:int;
         var createBunshinFrameScript:Function;
         var createFrameScript:Function;
         var frame:int = 0;
         var shadowName:String = null;
         var effect:Object = null;
         var effectName:String = null;
         var effectType:String = null;
         var positionFrame:int = this.skill_info.anims.hasOwnProperty("position") ? int(this.skill_info.anims.position) : 2;
         this.skill_mc.addFrameScript(0,this.stopAnimation);
         this.skill_mc.addFrameScript(1,this.handleCooldown);
         this.skill_mc.addFrameScript(positionFrame,this.handlePosition);
         this.skill_mc.addFrameScript(this.skill_mc.totalFrames - 1,this.handleEndAnimation);
         i = 0;
         while(i < this.skill_info.anims.hit.length)
         {
            this.skill_mc.addFrameScript(this.skill_info.anims.hit[i],this.handleHitAnimation);
            i++;
         }
         if(this.skill_info.anims.hasOwnProperty("splash"))
         {
            this.skill_mc.addFrameScript(this.skill_info.anims.splash.add,this.handleGenderSplash);
         }
         if(this.skill_info.anims.hasOwnProperty("fullscreen"))
         {
            this.skill_mc.addFrameScript(this.skill_info.anims.fullscreen.add,this.addFullScreen);
            this.skill_mc.addFrameScript(this.skill_info.anims.fullscreen.remove,this.removeFullScreen);
         }
         if(this.skill_info.anims.hasOwnProperty("bunshin"))
         {
            createBunshinFrameScript = function(param1:String):Function
            {
               var shadowName:String = param1;
               return function():void
               {
                  handleBunshin(skill_mc[shadowName]);
               };
            };
            i = 0;
            while(i < this.skill_info.anims.bunshin.length)
            {
               frame = int(this.skill_info.anims.bunshin[i]);
               shadowName = "shandow" + String(i + 1);
               this.skill_mc.addFrameScript(frame,createBunshinFrameScript(shadowName));
               i++;
            }
         }
         if(this.skill_info.anims.hasOwnProperty("effects"))
         {
            createFrameScript = function(param1:String, param2:String):Function
            {
               var effectName:String = param1;
               var effectType:String = param2;
               return function():void
               {
                  handleFlyingObject(skill_mc[effectName],effectType);
               };
            };
            i = 0;
            while(i < this.skill_info.anims.effects.length)
            {
               effect = this.skill_info.anims.effects[i];
               frame = int(effect.add);
               effectName = effect.name;
               effectType = effect.type;
               this.skill_mc.addFrameScript(frame,createFrameScript(effectName,effectType));
               i++;
            }
         }
         this.skill_mc.gotoAndStop(1);
      }
      
      protected function clearFrameScript() : void
      {
         var _loc1_:int = this.skill_info.anims.hasOwnProperty("position") ? int(this.skill_info.anims.position) : 2;
         this.skill_mc.addFrameScript(0,null);
         this.skill_mc.addFrameScript(1,null);
         this.skill_mc.addFrameScript(_loc1_,null);
         this.skill_mc.addFrameScript(this.skill_mc.totalFrames - 1,null);
         var _loc2_:int = 0;
         while(_loc2_ < this.skill_info.anims.hit.length)
         {
            this.skill_mc.addFrameScript(this.skill_info.anims.hit[_loc2_],null);
            _loc2_++;
         }
         if(this.skill_info.anims.hasOwnProperty("splash"))
         {
            this.skill_mc.addFrameScript(this.skill_info.anims.splash.add,null);
            if(this.skill_info.anims.splash.hasOwnProperty("remove"))
            {
               this.skill_mc.addFrameScript(this.skill_info.anims.splash.remove,null);
            }
         }
         if(this.skill_info.anims.hasOwnProperty("fullscreen"))
         {
            this.skill_mc.addFrameScript(this.skill_info.anims.fullscreen.add,null);
            this.skill_mc.addFrameScript(this.skill_info.anims.fullscreen.remove,null);
         }
         if(this.skill_info.anims.hasOwnProperty("bunshin"))
         {
            _loc2_ = 0;
            while(_loc2_ < this.skill_info.anims.bunshin.length)
            {
               this.skill_mc.addFrameScript(this.skill_info.anims.bunshin[_loc2_],null);
               _loc2_++;
            }
         }
         if(this.skill_info.anims.hasOwnProperty("effects"))
         {
            _loc2_ = 0;
            while(_loc2_ < this.skill_info.anims.effects.length)
            {
               this.skill_mc.addFrameScript(this.skill_info.anims.effects[_loc2_].add,null);
               _loc2_++;
            }
         }
         this.skill_mc.stopAllMovieClips();
      }
      
      public function isOutfitFilled() : Boolean
      {
         return this.outfit_filled;
      }
      
      public function fillOutfit(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:MovieClip = null) : void
      {
         this.gender = param3.split("_")[2];
         if(Character.is_stickman)
         {
            return;
         }
         var _loc9_:OutfitManager = new OutfitManager();
         var _loc10_:MovieClip = param8 == null ? this.skill_mc : param8;
         _loc9_.fillOutfit(_loc10_,param1,param2,param3,param4,param5,param6,param7);
         this.outfit_filled = true;
         this.outfits.push(_loc9_);
      }
      
      protected function getActionType(param1:String) : String
      {
         var _loc2_:String = this.skill_info.skill_type;
         if(_loc2_ == "secret" || _loc2_ == "extreme")
         {
            return param1 == "hit" ? "hitByTalentSkill" : "talentSkillAttackFinished";
         }
         if(_loc2_ == "toad" || _loc2_ == "snake" || _loc2_ == "slug" || _loc2_ == "other")
         {
            return param1 == "hit" ? "hitBySenjutsuSkill" : "senjutsuSkillAttackFinished";
         }
         if(_loc2_ == "10")
         {
            return param1 == "hit" ? "hitBySpecialSkill" : "specialSkillAttackFinished";
         }
         return param1 == "hit" ? "playHitAnimation" : "skillAttackFinished";
      }
      
      public function setCurrentCooldown(param1:int) : void
      {
         this.c_skill_cooldown = param1;
      }
      
      public function getCurrentCooldown() : int
      {
         return this.c_skill_cooldown;
      }
      
      public function addFullScreen() : void
      {
         var _loc1_:int = "scale" in this.skill_info.anims.fullscreen ? int(this.skill_info.anims.fullscreen.scale) : 2;
         this.skill_mc.fullScreenEffect.x = 0;
         this.skill_mc.fullScreenEffect.y = 0;
         this.skill_mc.fullScreenEffect.scaleX = _loc1_;
         this.skill_mc.fullScreenEffect.scaleY = _loc1_;
      }
      
      public function removeFullScreen() : void
      {
      }
      
      public function stopAnimation() : void
      {
         this.skill_mc.stop();
      }
      
      public function handleHitAnimation() : void
      {
      }
      
      public function handleEndAnimation() : void
      {
         this.skill_mc.gotoAndStop(1);
         this.toStartPosition();
      }
      
      public function handleCooldown() : void
      {
         this.setCurrentCooldown(this.skill_info.skill_cooldown);
      }
      
      public function handlePosition() : void
      {
         this.setPositionAndAttack(this.player_team,this.player_target,this.player_number,true);
      }
      
      public function handleBunshin(param1:MovieClip) : void
      {
      }
      
      public function handleFlyingObject(param1:MovieClip, param2:String) : void
      {
      }
      
      public function handleGenderSplash() : void
      {
         try
         {
            if(this.skill_mc.hasOwnProperty("splash"))
            {
               this.skill_mc.splash.splash_0.visible = false;
               this.skill_mc.splash.splash_1.visible = false;
               this.skill_mc.splash["splash_" + this.gender].visible = true;
            }
         }
         catch(e:*)
         {
         }
      }
      
      public function setPositionAndAttack(param1:String, param2:int, param3:int, param4:Boolean = false) : Boolean
      {
         if(this.getCurrentCooldown() > 0 && !param4)
         {
            return false;
         }
         this.is_multi_hit = this.skill_info != null && (Boolean(this.skill_info.multi_hit) || this.skill_info.target == "All" || this.skill_info.skill_target == "All");
         this.player_target = param2;
         if(this.player_team != null && !param4)
         {
            return true;
         }
         this.goToAttackPosition();
         if(this.skill_attack_hit_position == "startpos")
         {
            if(this.is_multi_hit)
            {
               this.applyTargetYOffset();
            }
            return true;
         }
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.player_team == "player")
         {
            _loc5_ = 1;
         }
         else if(this.player_team == "enemy")
         {
            _loc5_ = -1;
         }
         if(this.player_number > 0)
         {
            _loc6_ += 170;
         }
         if(this.player_target != 0)
         {
            _loc6_ += this.player_number > 0 ? 140 : 130;
         }
         this.skill_mc.x += _loc6_ * _loc5_;
         if(this.skill_mc.name == "skill_7038" || this.skill_mc.name == "skill_7039")
         {
            this.skill_mc.x = this.player_team == "player" ? 490 : -490;
         }
         this.applyTargetYOffset();
         return true;
      }
      
      protected function applyTargetYOffset() : void
      {
         var _loc1_:int = this.is_multi_hit ? 0 : this.player_target;
         switch(this.player_number + ":" + _loc1_)
         {
            case "1:0":
            case "0:2":
               this.skill_mc.y += 80;
               break;
            case "2:0":
            case "0:1":
               this.skill_mc.y -= 80;
               break;
            case "1:2":
               this.skill_mc.y += 160;
               break;
            case "2:1":
               this.skill_mc.y -= 160;
         }
      }
      
      protected function goToAttackPosition() : void
      {
         var _loc1_:int = 0;
         switch(this.skill_attack_hit_position)
         {
            case "startpos":
               this.toStartPosition();
               return;
            case "meele_1":
               _loc1_ = 460;
               break;
            case "meele_2":
               _loc1_ = 360;
               break;
            case "meele_3":
               _loc1_ = 310;
               break;
            case "meele_4":
               _loc1_ = 260;
               break;
            case "range_1":
               _loc1_ = 160;
               break;
            case "range_2":
               _loc1_ = 110;
               break;
            case "range_3":
               _loc1_ = 0;
               break;
            default:
               return;
         }
         this.skill_mc.x += this.player_team == "player" ? _loc1_ : -_loc1_;
      }
      
      public function playFlyingObject(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         if(this.startPoint != null)
         {
            _loc2_ = this.skill_mc.globalToLocal(this.startPoint);
            param1.x = _loc2_.x;
            param1.y = _loc2_.y;
         }
         if(this.targetPoint != null)
         {
            _loc3_ = this.skill_mc.globalToLocal(this.targetPoint);
            param1.x = _loc3_.x;
            param1.y = _loc3_.y;
         }
         if(this.point != null)
         {
            _loc4_ = this.skill_mc.globalToLocal(this.point);
            param1.x = 0;
            param1.y = 0;
            TweenLite.to(param1,param1.totalFrames / 40,{
               "x":_loc4_.x,
               "y":_loc4_.y
            });
         }
         param1.gotoAndPlay(2);
      }
      
      protected function toStartPosition() : void
      {
         this.skill_mc.x = 0;
         this.skill_mc.y = 0;
      }
      
      protected function getTarget() : int
      {
         return 0;
      }
      
      protected function getEnemyTeam() : String
      {
         if(this.player_team == "player")
         {
            return "enemy";
         }
         return "player";
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         Log.debug(this,"destroy",this.skill_info.skill_id);
         if(this.skill_mc != null)
         {
            TweenLite.killTweensOf(this.skill_mc);
            _loc2_ = this.skill_mc.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.skill_mc.getChildAt(_loc3_);
               if(_loc4_)
               {
                  TweenLite.killTweensOf(_loc4_);
               }
               _loc3_++;
            }
         }
         this.clearFrameScript();
         if(this.skill_mc)
         {
            this.skill_mc.gotoAndStop(1);
         }
         for each(_loc1_ in ["effectMc","fullScreenEffect","back","back_hair","head","hitAreaMc","left_hand","left_lower_arm","left_lower_leg","left_shoe","left_upper_arm","left_upper_leg","lower_body","right_hand","right_lower_arm","right_lower_leg","right_shoe","right_upper_arm","right_upper_leg","shadow","skirt","throw02Mc","upper_body","weapon"])
         {
            if(this.skill_mc.hasOwnProperty(_loc1_))
            {
               GF.removeAllChild(this.skill_mc[_loc1_]);
            }
         }
         GF.removeAllChild(this.skill_mc);
         if(this.fcHolder)
         {
            GF.removeAllChild(this.fcHolder);
            GF.removeParent(this.fcHolder);
            this.fcHolder = null;
         }
         GF.destroyArray(this.outfits);
         this.outfits = null;
         this.skill_mc = null;
         this.skill_info = null;
         this.c_skill_cooldown = 0;
         this.skill_attack_hit_position = null;
         this.player_team = null;
         this.player_number = 0;
         this.player_target = 0;
         this.is_multi_hit = false;
         this.startPoint = null;
         this.targetPoint = null;
         this.point = null;
         this.outfit_filled = false;
      }
   }
}

