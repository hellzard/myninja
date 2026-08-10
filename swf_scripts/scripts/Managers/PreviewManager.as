package Managers
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import gs.TweenLite;
   
   public class PreviewManager
   {
      
      public var main:*;
      
      public var preview_mc:MovieClip;
      
      public var preview_info:Object;
      
      public var preview_type:String;
      
      private var skill_attack_hit_position:String;
      
      private var outfits:Array = [];
      
      private var outfit_list:Array = [];
      
      private var startPoint:Point;
      
      private var targetPoint:Point;
      
      private var point:Point;
      
      public function PreviewManager(param1:*, param2:MovieClip, param3:Object, param4:Array = null)
      {
         super();
         this.main = param1;
         this.preview_mc = param2;
         this.preview_info = param3;
         this.outfit_list = param4 != null ? param4 : [Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face,Character.character_color_hair,Character.character_color_skin];
         this.init();
      }
      
      private function init() : void
      {
         this.preview_mc.scaleX = -0.7;
         this.preview_mc.scaleY = 0.7;
         this.skill_attack_hit_position = "range_3";
         this.preview_type = this.preview_info.hasOwnProperty("skill_id") ? "skill" : "entity";
         if(this.preview_type == "skill")
         {
            this.fillOutfit();
         }
         this.setFrameScript();
      }
      
      private function setFrameScript() : void
      {
         var createBunshinFrameScript:Function;
         var createFrameScript:Function;
         var i:int = 0;
         var frame:int = 0;
         var shadowName:String = null;
         var effect:Object = null;
         var effectName:String = null;
         var effectType:String = null;
         var finishFrame:int = 0;
         if(this.preview_type == "skill")
         {
            this.preview_mc.addFrameScript(0,this.stopAnimation);
            this.preview_mc.addFrameScript(this.preview_mc.totalFrames - 1,this.handleEndAnimation);
            i = 0;
            while(i < this.preview_info.anims.hit.length)
            {
               this.preview_mc.addFrameScript(this.preview_info.anims.hit[i],this.handleHitAnimation);
               i++;
            }
            if(this.preview_info.anims.hasOwnProperty("fullscreen"))
            {
               this.preview_mc.addFrameScript(this.preview_info.anims.fullscreen.add,this.addFullScreen);
               this.preview_mc.addFrameScript(this.preview_info.anims.fullscreen.remove,this.removeFullScreen);
            }
            if(this.preview_info.anims.hasOwnProperty("splash"))
            {
               this.preview_mc.addFrameScript(this.preview_info.anims.splash.add,this.handleGenderSplash);
            }
            if(this.preview_info.anims.hasOwnProperty("bunshin"))
            {
               createBunshinFrameScript = function(param1:String):Function
               {
                  var shadowName:String = param1;
                  return function():void
                  {
                     handleBunshin(preview_mc[shadowName]);
                  };
               };
               i = 0;
               while(i < this.preview_info.anims.bunshin.length)
               {
                  frame = int(this.preview_info.anims.bunshin[i]);
                  shadowName = "shandow" + String(i + 1);
                  this.preview_mc.addFrameScript(frame,createBunshinFrameScript(shadowName));
                  i++;
               }
            }
            if(this.preview_info.anims.hasOwnProperty("effects"))
            {
               createFrameScript = function(param1:String, param2:String):Function
               {
                  var effectName:String = param1;
                  var effectType:String = param2;
                  return function():void
                  {
                     handleFlyingObject(preview_mc[effectName],effectType);
                  };
               };
               i = 0;
               while(i < this.preview_info.anims.effects.length)
               {
                  effect = this.preview_info.anims.effects[i];
                  frame = int(effect.add);
                  effectName = effect.name;
                  effectType = effect.type;
                  this.preview_mc.addFrameScript(frame,createFrameScript(effectName,effectType));
                  i++;
               }
            }
         }
         else
         {
            i = 0;
            while(i < this.preview_info.attacks.length)
            {
               finishFrame = NinjaSage.getLabelFrames(this.preview_mc,this.preview_info.attacks[i].animation).end - 1;
               this.preview_mc.addFrameScript(finishFrame,this.standByFrameEnd);
               if(this.preview_info.attacks[i].anims.hasOwnProperty("fullscreen"))
               {
                  this.preview_mc.addFrameScript(this.preview_info.attacks[i].anims.fullscreen.add,this.addFullScreen);
                  this.preview_mc.addFrameScript(this.preview_info.attacks[i].anims.fullscreen.remove,this.removeFullScreen);
               }
               i++;
            }
            this.preview_mc.addFrameScript(NinjaSage.getLabelFrames(this.preview_mc,"standby").end - 1,this.standByFrameEnd);
            this.preview_mc.addFrameScript(NinjaSage.getLabelFrames(this.preview_mc,"dodge").end - 1,this.standByFrameEnd);
            this.preview_mc.addFrameScript(NinjaSage.getLabelFrames(this.preview_mc,"hit").end - 1,this.standByFrameEnd);
            this.preview_mc.addFrameScript(NinjaSage.getLabelFrames(this.preview_mc,"dead").end - 1,this.standByFrameEnd);
            this.preview_mc.gotoAndPlay("standby");
         }
         this.preview_mc.gotoAndStop(1);
      }
      
      private function clearFrameScript() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.preview_type == "skill")
         {
            this.preview_mc.addFrameScript(0,null);
            this.preview_mc.addFrameScript(1,null);
            this.preview_mc.addFrameScript(this.preview_mc.totalFrames - 1,null);
            _loc1_ = 0;
            while(_loc1_ < this.preview_info.anims.hit.length)
            {
               this.preview_mc.addFrameScript(this.preview_info.anims.hit[_loc1_],null);
               _loc1_++;
            }
            if(this.preview_info.anims.hasOwnProperty("fullscreen"))
            {
               this.preview_mc.addFrameScript(this.preview_info.anims.fullscreen.add,null);
               this.preview_mc.addFrameScript(this.preview_info.anims.fullscreen.remove,null);
            }
            if(this.preview_info.anims.hasOwnProperty("splash"))
            {
               this.preview_mc.addFrameScript(this.preview_info.anims.splash.add,null);
            }
            if(this.preview_info.anims.hasOwnProperty("bunshin"))
            {
               _loc1_ = 0;
               while(_loc1_ < this.preview_info.anims.bunshin.length)
               {
                  this.preview_mc.addFrameScript(this.preview_info.anims.bunshin[_loc1_],null);
                  _loc1_++;
               }
            }
            if(this.preview_info.anims.hasOwnProperty("effects"))
            {
               _loc1_ = 0;
               while(_loc1_ < this.preview_info.anims.effects.length)
               {
                  this.preview_mc.addFrameScript(this.preview_info.anims.effects[_loc1_].add,null);
                  _loc1_++;
               }
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < this.preview_info.attacks.length)
            {
               _loc2_ = NinjaSage.getLabelFrames(this.preview_mc,this.preview_info.attacks[_loc1_].animation).end - 1;
               this.preview_mc.addFrameScript(_loc2_,null);
               if(this.preview_info.attacks[_loc1_].anims.hasOwnProperty("fullscreen"))
               {
                  this.preview_mc.addFrameScript(this.preview_info.attacks[_loc1_].anims.fullscreen.add,null);
                  this.preview_mc.addFrameScript(this.preview_info.attacks[_loc1_].anims.fullscreen.remove,null);
               }
               _loc1_++;
            }
            this.preview_mc.addFrameScript(NinjaSage.getLabelFrames(this.preview_mc,"standby").end - 1,null);
            this.preview_mc.addFrameScript(NinjaSage.getLabelFrames(this.preview_mc,"dodge").end - 1,null);
            this.preview_mc.addFrameScript(NinjaSage.getLabelFrames(this.preview_mc,"hit").end - 1,null);
            this.preview_mc.addFrameScript(NinjaSage.getLabelFrames(this.preview_mc,"dead").end - 1,null);
         }
      }
      
      public function stopAnimation() : void
      {
         this.preview_mc.stop();
      }
      
      public function standByFrameEnd() : void
      {
         this.preview_mc.x = 0;
         this.preview_mc.y = 0;
         this.preview_mc.gotoAndPlay("standby");
      }
      
      public function handleHitAnimation() : void
      {
      }
      
      public function handleEndAnimation() : void
      {
         this.preview_mc.gotoAndStop(1);
         this.preview_mc.x = 0;
         this.preview_mc.y = 0;
      }
      
      public function handleBunshin(param1:MovieClip) : void
      {
         this.fillOutfit(param1);
      }
      
      public function handleFlyingObject(param1:MovieClip, param2:String) : void
      {
         this.startPoint = null;
         this.targetPoint = null;
         this.point = null;
         var _loc3_:int = 1200;
         var _loc4_:int = 800;
         var _loc5_:Point = new Point(_loc3_,_loc4_);
         if(param2 == "target")
         {
            this.targetPoint = _loc5_;
         }
         else
         {
            this.point = _loc5_;
         }
         this.playFlyingObject(param1);
      }
      
      public function fillOutfit(param1:MovieClip = null) : void
      {
         if(Character.is_stickman)
         {
            return;
         }
         var _loc2_:OutfitManager = new OutfitManager();
         var _loc3_:MovieClip = param1 == null ? this.preview_mc : param1;
         var _loc4_:String = this.outfit_list[0];
         var _loc5_:String = this.outfit_list[1];
         var _loc6_:String = this.outfit_list[2];
         var _loc7_:String = this.outfit_list[3];
         var _loc8_:String = this.outfit_list[4];
         var _loc9_:String = this.outfit_list[5];
         var _loc10_:String = this.outfit_list[6];
         _loc2_.fillOutfit(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
         this.outfits.push(_loc2_);
      }
      
      public function addFullScreen() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.preview_type == "skill")
         {
            _loc1_ = Boolean(this.preview_info.anims.hasOwnProperty("fullscreen")) && "scale" in this.preview_info.anims.fullscreen ? int(this.preview_info.anims.fullscreen.scale) : 2;
         }
         else
         {
            _loc2_ = this.preview_mc.currentLabel;
            _loc3_ = int(_loc2_.replace("attack_","")) >= 10 ? int(_loc2_.replace("attack_","")) : int(_loc2_.replace("attack_0",""));
            _loc4_ = int(_loc3_) - 1;
            _loc1_ = Boolean(this.preview_info.attacks[_loc4_].anims.hasOwnProperty("fullscreen")) && "scale" in this.preview_info.attacks[_loc4_].anims.fullscreen ? int(this.preview_info.attacks[_loc4_].anims.fullscreen.scale) : 2;
         }
         this.preview_mc.fullScreenEffect.x = 0;
         this.preview_mc.fullScreenEffect.y = 0;
         this.preview_mc.fullScreenEffect.scaleX = _loc1_;
         this.preview_mc.fullScreenEffect.scaleY = _loc1_;
         this.main.loader.addChild(this.preview_mc.fullScreenEffect);
      }
      
      public function removeFullScreen() : void
      {
         this.main.loader.removeChild(this.preview_mc.fullScreenEffect);
      }
      
      public function handleGenderSplash() : void
      {
         this.preview_mc.splash.splash_0.visible = false;
         this.preview_mc.splash.splash_1.visible = false;
         this.preview_mc.splash["splash_" + Character.character_gender].visible = true;
      }
      
      public function playFlyingObject(param1:MovieClip) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         if(this.startPoint != null)
         {
            _loc2_ = this.preview_mc.globalToLocal(this.startPoint);
            param1.x = _loc2_.x;
            param1.y = _loc2_.y;
         }
         if(this.targetPoint != null)
         {
            _loc3_ = this.preview_mc.globalToLocal(this.targetPoint);
            param1.x = _loc3_.x;
            param1.y = _loc3_.y;
         }
         if(this.point != null)
         {
            _loc4_ = this.preview_mc.globalToLocal(this.point);
            param1.x = 0;
            param1.y = 0;
            TweenLite.to(param1,param1.totalFrames / 40,{
               "x":_loc4_.x,
               "y":_loc4_.y
            });
         }
         param1.gotoAndPlay(2);
      }
      
      public function destroy() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         TweenLite.killTweensOf(this.preview_mc);
         var _loc1_:int = 0;
         while(this.preview_mc != null && _loc1_ < this.preview_mc.numChildren)
         {
            _loc3_ = this.preview_mc.getChildAt(_loc1_);
            if(_loc3_)
            {
               TweenLite.killTweensOf(_loc3_);
            }
            _loc1_++;
         }
         this.clearFrameScript();
         for each(_loc2_ in ["effectMc","fullScreenEffect","back","back_hair","head","hitAreaMc","left_hand","left_lower_arm","left_lower_leg","left_shoe","left_upper_arm","left_upper_leg","lower_body","right_hand","right_lower_arm","right_lower_leg","right_shoe","right_upper_arm","right_upper_leg","shadow","skirt","throw02Mc","upper_body","weapon"])
         {
            if(this.preview_mc.hasOwnProperty(_loc2_))
            {
               GF.removeAllChild(this.preview_mc[_loc2_]);
            }
         }
         this.preview_mc.gotoAndStop(1);
         this.preview_mc.stopAllMovieClips();
         GF.removeAllChild(this.preview_mc);
         GF.destroyArray(this.outfits);
         this.outfits = null;
         this.outfit_list = null;
         this.preview_type = null;
         this.preview_mc = null;
         this.preview_info = null;
         this.startPoint = null;
         this.targetPoint = null;
         this.point = null;
         this.main = null;
      }
   }
}

