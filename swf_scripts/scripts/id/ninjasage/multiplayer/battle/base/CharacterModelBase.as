package id.ninjasage.multiplayer.battle.base
{
   import Combat.BattleVars;
   import Storage.AnimationLibrary;
   import Storage.Library;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   
   public class CharacterModelBase extends MovieClip
   {
      
      public var character_info:Object = {};
      
      public var animScript:Object = {};
      
      public var skills_with_cooldown:Array;
      
      public var player_identification:String = "";
      
      public var characterAnimations:Object = {};
      
      public var movieclip_holder:String = "";
      
      public var player_team:String = "";
      
      public var player_number:int = 0;
      
      public var start_x:int = 0;
      
      public var start_y:int = 0;
      
      public function CharacterModelBase(param1:String = "player", param2:int = 0)
      {
         super();
         this.player_team = param1;
         this.player_number = param2;
      }
      
      public function handlePlayerParentObjects() : *
      {
         this.movieclip_holder = this.player_team == "player" ? "charMc_" : "enemyMc_";
      }
      
      public function setModelFramescript() : *
      {
         var _loc1_:* = undefined;
         this.animScript = {
            32:this.gotoStandby,
            45:this.gotoRun,
            50:this.handleHitFrame,
            77:this.weaponAttackFinished,
            79:this.handleHitFrame,
            112:this.weaponAttackFinished,
            114:this.handleHitFrame,
            142:this.weaponAttackFinished,
            144:this.handleHitFrame,
            171:this.weaponAttackFinished,
            173:this.handleHitFrame,
            203:this.weaponAttackFinished,
            215:this.handleHitFrame,
            231:this.weaponAttackFinished,
            233:this.handleHitFrame,
            259:this.weaponAttackFinished,
            283:this.dodgeAnimationFinished,
            299:this.hitAnimationFinished,
            319:this.deadAnimationFinished,
            338:this.matchEndAnimationFinished,
            365:this.smokeAnimationFinished,
            396:this.chargeAnimationFinished,
            425:this.itemAnimationFinished,
            453:this.gotoStandby,
            481:this.deadAnimationFinishedLoop,
            502:this.handleHitFrame,
            518:this.weaponAttackFinished,
            578:this.matchEndAnimationFinishedLoop,
            598:this.dodgeAnimationFinished,
            643:this.dodgeAnimationFinished,
            693:this.dodgeAnimationFinished,
            717:this.dodgeAnimationFinished,
            780:this.handleHitFrame,
            795:this.weaponAttackFinished,
            831:this.gotoStandby,
            861:this.dodgeAnimationFinished,
            880:this.gotoStandby,
            893:this.handleHitFrame,
            909:this.weaponAttackFinished,
            946:this.handleHitFrame,
            952:this.weaponAttackFinished,
            934:this.gotoStandby
         };
         this.characterAnimations = {
            "dodge":"ani_1",
            "standby":"ani_5",
            "win":"ani_7",
            "dead":"ani_3",
            "charge":"ani_9",
            "hit":"ani_10",
            "run":"ani_11"
         };
         for(_loc1_ in this.animScript)
         {
            addFrameScript(_loc1_,this.animScript[_loc1_]);
         }
      }
      
      public function setAnimations(param1:Object, param2:String) : *
      {
         this.characterAnimations = {
            "dodge":(param1.hasOwnProperty("dodge") ? param1.dodge : "ani_1"),
            "standby":(param1.hasOwnProperty("standby") ? param1.standby : "ani_5"),
            "win":(param1.hasOwnProperty("win") ? param1.win : "ani_7"),
            "dead":(param1.hasOwnProperty("dead") ? param1.dead : "ani_3"),
            "charge":(param1.hasOwnProperty("charge") ? param1.charge : "ani_9"),
            "hit":(param1.hasOwnProperty("hit") ? param1.hit : "ani_10"),
            "run":(param1.hasOwnProperty("run") ? param1.run : "ani_11")
         };
         this.overrideAnimations(Library.getItemInfo(param2).anims);
      }
      
      public function overrideAnimations(param1:Object) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.hasOwnProperty("standby") && param1.standby != null)
         {
            this.characterAnimations.standby = param1.standby;
         }
         if(param1.hasOwnProperty("dodge") && param1.dodge != null)
         {
            this.characterAnimations.dodge = param1.dodge;
         }
         if(param1.hasOwnProperty("win") && param1.win != null)
         {
            this.characterAnimations.win = param1.win;
         }
         if(param1.hasOwnProperty("dead") && param1.dead != null)
         {
            this.characterAnimations.dead = param1.dead;
         }
         if(param1.hasOwnProperty("charge") && param1.charge != null)
         {
            this.characterAnimations.charge = param1.charge;
         }
         if(param1.hasOwnProperty("hit") && param1.hit != null)
         {
            this.characterAnimations.hit = param1.hit;
         }
         if(param1.hasOwnProperty("run") && param1.run != null)
         {
            this.characterAnimations.run = param1.run;
         }
      }
      
      public function setScalingAndSaveStartingPosition() : *
      {
         this.start_x = this.x;
         this.start_y = this.y;
         this.scaleX = BattleVars.CHAR_SCALE;
         this.scaleY = BattleVars.CHAR_SCALE;
      }
      
      public function dodgeAnimationFinished() : *
      {
         this.gotoStandby();
      }
      
      public function hitAnimationFinished() : *
      {
         this.gotoStandby();
      }
      
      public function chargeAnimationFinished() : *
      {
         this.gotoStandby();
      }
      
      public function itemAnimationFinished() : *
      {
         this.gotoStandby();
      }
      
      public function smokeAnimationFinished() : *
      {
         this.stop();
      }
      
      public function matchEndAnimationFinished() : *
      {
         this.x = this.start_x;
         this.y = this.start_y;
         this.stop();
      }
      
      public function matchEndAnimationFinishedLoop() : *
      {
         this.x = this.start_x;
         this.y = this.start_y;
         this.gotoAndPlay(this.getFrameLabel("win"));
      }
      
      public function deadAnimationFinished() : *
      {
         this.x = this.start_x;
         this.y = this.start_y;
         this.stop();
      }
      
      public function deadAnimationFinishedLoop() : *
      {
         this.x = this.start_x;
         this.y = this.start_y;
         this.gotoAndPlay(this.getFrameLabel("dead"));
      }
      
      public function gotoRun() : *
      {
         this.gotoAndPlay("run");
      }
      
      public function gotoStandby() : *
      {
         this.x = this.start_x;
         this.y = this.start_y;
         this.gotoAndPlay(this.getFrameLabel("standby"));
      }
      
      public function getPlayerTeam() : String
      {
         return this.player_team;
      }
      
      public function getPlayerNumber() : int
      {
         return this.player_number;
      }
      
      public function isCharacter() : Boolean
      {
         return true;
      }
      
      public function isPet() : Boolean
      {
         return false;
      }
      
      public function isEnemy() : Boolean
      {
         return false;
      }
      
      public function isNpc() : Boolean
      {
         return false;
      }
      
      public function playWin() : *
      {
         this.gotoAndPlay(this.getFrameLabel("win"));
      }
      
      public function playRun() : *
      {
         this.gotoAndPlay(this.getFrameLabel("run"));
      }
      
      protected function getFrameLabel(param1:String) : String
      {
         if(!this.hasOwnProperty("characterAnimations"))
         {
            return param1;
         }
         switch(param1)
         {
            case "dodge":
            case "dead":
            case "standby":
            case "win":
            case "hit":
            case "run":
            case "charge":
               return AnimationLibrary.getAnimation(this.characterAnimations[param1]).label;
            default:
               return param1;
         }
      }
      
      public function weaponAttackFinished() : *
      {
         this.gotoStandby();
      }
      
      protected function calculateAttackPosition(param1:int, param2:String, param3:Array = null) : Object
      {
         if(param3 == null)
         {
            param3 = [];
         }
         var _loc4_:Object = {
            "x":-400,
            "y":0
         };
         if(param3.indexOf(param2) != -1)
         {
            _loc4_.x = 0;
         }
         if(param1 > 0)
         {
            _loc4_.x -= 125;
         }
         if(this.player_number > 0)
         {
            _loc4_.x -= 125;
         }
         if(param1 > 0 && this.player_number > 0)
         {
            _loc4_.x -= 50;
         }
         var _loc5_:String = param1 + "_" + this.player_number;
         var _loc6_:Object = {
            "1_0":-100,
            "2_0":70,
            "0_1":100,
            "0_2":-70,
            "2_1":170,
            "1_2":-170
         };
         _loc4_.y = _loc6_[_loc5_] || 0;
         return _loc4_;
      }
      
      protected function getRandomSequence(param1:int, param2:int) : Array
      {
         if(param1 > param2)
         {
            throw new Error("Max value should be greater than Min value!");
         }
         if(param1 == param2)
         {
            return [param1];
         }
         var _loc3_:Array = [];
         var _loc4_:int = param1;
         while(_loc4_ <= param2)
         {
            _loc3_.push(_loc4_);
            _loc4_++;
         }
         var _loc5_:Array = [];
         while(_loc3_.length > 0)
         {
            _loc5_ = _loc5_.concat(_loc3_.splice(NumberUtil.randomInt(0,_loc3_.length - 1),1));
         }
         return _loc5_;
      }
      
      public function handleHitFrame() : *
      {
      }
      
      public function playAnimation(param1:String) : *
      {
         this.gotoAndPlay(this.getFrameLabel(param1));
      }
      
      public function destroy() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = ["back","back_hair","head","hitAreaMc","holderMc","left_hand","left_lower_arm","left_lower_leg","left_shoe","left_upper_arm","left_upper_leg","lower_body","right_hand","right_lower_arm","right_lower_leg","right_shoe","right_upper_arm","right_upper_leg","skirt","upper_body","weapon"];
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ in this)
            {
               GF.removeAllChild(this[_loc2_]);
               this[_loc2_] = null;
            }
         }
         if(this.animScript)
         {
            for(_loc3_ in this.animScript)
            {
               addFrameScript(_loc3_,null);
            }
         }
         this.gotoAndStop(1);
         this.animScript = null;
         this.characterAnimations = null;
         this.movieclip_holder = null;
         this.player_team = null;
         this.player_number = 0;
         this.start_x = 0;
         this.start_y = 0;
      }
   }
}

