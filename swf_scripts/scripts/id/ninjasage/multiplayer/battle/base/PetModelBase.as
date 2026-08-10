package id.ninjasage.multiplayer.battle.base
{
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class PetModelBase extends MovieClip
   {
      
      public var pet_info:Object = {};
      
      public var pet_team:String = "";
      
      public var pet_number:int = 0;
      
      public var start_x:int = 0;
      
      public var start_y:int = 0;
      
      public var object_mc:MovieClip = null;
      
      public var object_head:MovieClip = null;
      
      public var pet_swf:String = "";
      
      public function PetModelBase(param1:String = "player", param2:int = 0)
      {
         super();
         this.pet_team = param1;
         this.pet_number = param2;
      }
      
      public function setScalingAndSaveStartingPosition() : *
      {
         this.start_x = this.object_mc.x;
         this.start_y = this.object_mc.y;
         if(Boolean(this.pet_info) && Boolean(this.pet_info.hasOwnProperty("size_x")) && this.pet_info.hasOwnProperty("size_y"))
         {
            this.object_mc.scaleX = this.pet_info.size_x * BattleVars.PET_SCALE;
            this.object_mc.scaleY = this.pet_info.size_y * BattleVars.PET_SCALE;
         }
         else
         {
            this.object_mc.scaleX = BattleVars.PET_SCALE;
            this.object_mc.scaleY = BattleVars.PET_SCALE;
         }
      }
      
      public function setFrameScript() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this.pet_info || !this.pet_info.attacks)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.pet_info.attacks.length)
         {
            if(Boolean(this.pet_info.attacks[_loc1_].anims) && Boolean(this.pet_info.attacks[_loc1_].anims.hit))
            {
               _loc3_ = 0;
               while(_loc3_ < this.pet_info.attacks[_loc1_].anims.hit.length)
               {
                  this.object_mc.addFrameScript(this.pet_info.attacks[_loc1_].anims.hit[_loc3_],this.attackHit);
                  _loc3_++;
               }
            }
            if(Boolean(this.pet_info.attacks[_loc1_].anims) && Boolean(this.pet_info.attacks[_loc1_].anims.hasOwnProperty("fullscreen")))
            {
               this.object_mc.addFrameScript(this.pet_info.attacks[_loc1_].anims.fullscreen.add,this.addFullScreen);
               this.object_mc.addFrameScript(this.pet_info.attacks[_loc1_].anims.fullscreen.remove,this.removeFullScreen);
            }
            _loc2_ = NinjaSage.getLabelFrames(this.object_mc,this.pet_info.attacks[_loc1_].animation).end - 1;
            this.object_mc.addFrameScript(_loc2_,this.attackFinish);
            _loc1_++;
         }
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"standby").end - 1,this.standByFrameEnd);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dodge").end - 1,this.dodgeFrame);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"hit").end - 1,this.attackedFrame);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dead").end - 1,this.deadFrame);
         this.object_mc.gotoAndPlay("standby");
      }
      
      public function clearFrameScript() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this.pet_info || !this.pet_info.attacks)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.pet_info.attacks.length)
         {
            if(Boolean(this.pet_info.attacks[_loc1_].anims) && Boolean(this.pet_info.attacks[_loc1_].anims.hit))
            {
               _loc3_ = 0;
               while(_loc3_ < this.pet_info.attacks[_loc1_].anims.hit.length)
               {
                  this.object_mc.addFrameScript(this.pet_info.attacks[_loc1_].anims.hit[_loc3_],null);
                  _loc3_++;
               }
            }
            _loc2_ = NinjaSage.getLabelFrames(this.object_mc,this.pet_info.attacks[_loc1_].animation).end - 1;
            this.object_mc.addFrameScript(_loc2_,null);
            if(Boolean(this.pet_info.attacks[_loc1_].anims) && Boolean(this.pet_info.attacks[_loc1_].anims.hasOwnProperty("fullscreen")))
            {
               this.object_mc.addFrameScript(this.pet_info.attacks[_loc1_].anims.fullscreen.add,null);
               this.object_mc.addFrameScript(this.pet_info.attacks[_loc1_].anims.fullscreen.remove,null);
            }
            _loc1_++;
         }
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"standby").end - 1,null);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dodge").end - 1,null);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"hit").end - 1,null);
         this.object_mc.addFrameScript(NinjaSage.getLabelFrames(this.object_mc,"dead").end - 1,null);
         this.object_mc.stopAllMovieClips();
      }
      
      public function standByFrameEnd() : *
      {
         this.object_mc.x = this.start_x;
         this.object_mc.y = this.start_y;
         this.object_mc.gotoAndPlay("standby");
      }
      
      public function attackHit() : *
      {
      }
      
      public function attackFinish() : *
      {
         this.standByFrameEnd();
      }
      
      public function dodgeFrame() : *
      {
         this.standByFrameEnd();
      }
      
      public function attackedFrame() : *
      {
         this.standByFrameEnd();
      }
      
      public function deadFrame() : *
      {
         this.object_mc.stop();
      }
      
      public function addFullScreen() : *
      {
         if(this.object_mc.hasOwnProperty("fullScreenEffect"))
         {
            this.object_mc.fullScreenEffect.x = 0;
            this.object_mc.fullScreenEffect.y = 0;
            this.object_mc.fullScreenEffect.scaleX = 2;
            this.object_mc.fullScreenEffect.scaleY = 2;
         }
      }
      
      public function removeFullScreen() : *
      {
         if(this.object_mc.hasOwnProperty("fullScreenEffect"))
         {
         }
      }
      
      public function gotoAttackPos(param1:*, param2:* = "") : *
      {
         if(param2 == "startpos")
         {
            return;
         }
         if(!this.pet_info)
         {
            return;
         }
         switch(param2)
         {
            case BattleVars.Position_MELEE_1:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = -540;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = 540;
               }
               break;
            case BattleVars.Position_MELEE_2:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = -440;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = 440;
               }
               break;
            case BattleVars.Position_MELEE_3:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = -410;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = 410;
               }
               break;
            case BattleVars.Position_MELEE_4:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = -325;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = 325;
               }
               break;
            case BattleVars.Position_MELEE_5:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = -665;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = 665;
               }
               break;
            case BattleVars.Position_RANGE_1:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = -240;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = 240;
               }
               break;
            case BattleVars.Position_RANGE_2:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = -140;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = 140;
               }
               break;
            case BattleVars.Position_RANGE_3:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = 20;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = -20;
               }
               break;
            case BattleVars.Position_RANGE_4:
               if(this.pet_info.team != "player_pet")
               {
                  this.object_mc.x = 185;
               }
               if(this.pet_info.team == "player_pet")
               {
                  this.object_mc.x = -185;
               }
         }
         if(this.pet_info.team == "player_pet")
         {
            if(this.pet_info.num > 0)
            {
               this.object_mc.x += 140;
            }
            if(param1 > 0)
            {
               this.object_mc.x += 140;
            }
            if(this.pet_info.num == 1 && param1 == 0)
            {
               this.object_mc.y += 80;
            }
            if(this.pet_info.num == 2 && param1 == 0)
            {
               this.object_mc.y -= 80;
            }
            if(this.pet_info.num == 0 && param1 == 1)
            {
               this.object_mc.y -= 80;
            }
            if(this.pet_info.num == 0 && param1 == 2)
            {
               this.object_mc.y += 80;
            }
            if(this.pet_info.num == 1 && param1 == 2)
            {
               this.object_mc.y += 160;
            }
            if(this.pet_info.num == 2 && param1 == 1)
            {
               this.object_mc.y -= 160;
            }
         }
         else
         {
            if(this.pet_info.num > 0)
            {
               this.object_mc.x -= 140;
            }
            if(param1 > 0)
            {
               this.object_mc.x -= 140;
            }
            if(this.pet_info.num == 1 && param1 == 0)
            {
               this.object_mc.y += 80;
            }
            if(this.pet_info.num == 2 && param1 == 0)
            {
               this.object_mc.y -= 80;
            }
            if(this.pet_info.num == 0 && param1 == 1)
            {
               this.object_mc.y -= 80;
            }
            if(this.pet_info.num == 0 && param1 == 2)
            {
               this.object_mc.y += 80;
            }
            if(this.pet_info.num == 1 && param1 == 2)
            {
               this.object_mc.y += 160;
            }
            if(this.pet_info.num == 2 && param1 == 1)
            {
               this.object_mc.y -= 160;
            }
         }
      }
      
      public function playWin() : *
      {
      }
      
      public function playRun() : *
      {
      }
      
      public function playAnimation(param1:String) : *
      {
         var _loc2_:int = 0;
         if(Boolean(param1.indexOf("attack_") == 0) && Boolean(this.pet_info) && Boolean(this.pet_info.attacks))
         {
            _loc2_ = int(param1.replace("attack_","")) - 1;
            if(_loc2_ >= 0 && _loc2_ < this.pet_info.attacks.length)
            {
               this.gotoAttackPos(0,this.pet_info.attacks[_loc2_].posType);
            }
         }
         this.object_mc.gotoAndPlay(param1);
      }
      
      public function getPlayerTeam() : String
      {
         return this.pet_team;
      }
      
      public function getPlayerNumber() : int
      {
         return this.pet_number;
      }
      
      public function isPet() : Boolean
      {
         return true;
      }
      
      public function isCharacter() : Boolean
      {
         return false;
      }
      
      public function destroy() : *
      {
         this.clearFrameScript();
         if(this.object_mc)
         {
            this.object_mc.gotoAndStop(1);
         }
         GF.removeAllChild(this.object_mc);
         GF.removeAllChild(this.object_head);
         this.object_head = null;
         this.object_mc = null;
         this.start_x = 0;
         this.start_y = 0;
         this.pet_info = null;
         this.pet_team = null;
         this.pet_number = 0;
         this.pet_swf = null;
      }
   }
}

