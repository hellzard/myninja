package Managers
{
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.utils.setTimeout;
   import id.ninjasage.Log;
   
   public class OutfitManager
   {
      
      public static var hairMC:MovieClip;
      
      public static var backHairMC:MovieClip;
      
      public static var setMC:MovieClip;
      
      public static var faceMC:MovieClip;
      
      public static var weapon_mc:Array = [];
      
      public static var back_mc:Array = [];
      
      public static var set_mc:Array = [];
      
      public static var hair_mc:Array = [];
      
      public static var face_mc:Array = [];
      
      public var char_mc:* = null;
      
      public var char_head_mc:* = null;
      
      public var char_head_loaded:* = true;
      
      public var char_bodyArray:Array = [];
      
      public var hairMC2:MovieClip;
      
      public var backHairMC2:MovieClip;
      
      public var faceMC2:MovieClip;
      
      public var hair_color:*;
      
      public var face_color:*;
      
      public var hair_colors:* = null;
      
      public var skin_colors:* = null;
      
      public var face_colors:* = null;
      
      internal var color_1:uint;
      
      internal var color_2:uint;
      
      private var loader:*;
      
      private var wpnId:*;
      
      private var setId:*;
      
      private var backId:*;
      
      private var hairId:*;
      
      private var faceId:*;
      
      private var fillHeadFaceId:*;
      
      private var fillHeadHairId:*;
      
      private var removeCharMc:Boolean = true;
      
      public function OutfitManager(param1:Boolean = true)
      {
         this.char_bodyArray = new Array("upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe");
         super();
         this.removeCharMc = param1;
         this.loader = BulkLoader.getLoader("assets");
      }
      
      public static function removeChildsFromMovieClips(param1:*) : *
      {
         var _loc2_:* = undefined;
         while(param1.numChildren > 0)
         {
            _loc2_ = param1.getChildAt(0);
            param1.removeChildAt(0);
            _loc2_ = null;
         }
      }
      
      public static function releaseStaticMc() : *
      {
         OutfitManager.set_mc = [];
         OutfitManager.hair_mc = [];
         OutfitManager.face_mc = [];
         OutfitManager.weapon_mc = [];
         OutfitManager.back_mc = [];
         OutfitManager.hairMC = null;
         OutfitManager.backHairMC = null;
         OutfitManager.setMC = null;
         OutfitManager.faceMC = null;
      }
      
      public static function clearStaticMc() : *
      {
         GF.removeAllChildArray(OutfitManager.set_mc);
         GF.removeAllChildArray(OutfitManager.hair_mc);
         GF.removeAllChildArray(OutfitManager.face_mc);
         GF.removeAllChildArray(OutfitManager.weapon_mc);
         GF.removeAllChildArray(OutfitManager.back_mc);
         OutfitManager.set_mc = [];
         OutfitManager.hair_mc = [];
         OutfitManager.face_mc = [];
         OutfitManager.weapon_mc = [];
         OutfitManager.back_mc = [];
         GF.removeAllChild(OutfitManager.hairMC);
         GF.removeAllChild(OutfitManager.backHairMC);
         GF.removeAllChild(OutfitManager.setMC);
         GF.removeAllChild(OutfitManager.faceMC);
         OutfitManager.hairMC = null;
         OutfitManager.backHairMC = null;
         OutfitManager.setMC = null;
         OutfitManager.faceMC = null;
      }
      
      public function useLoader(param1:*) : OutfitManager
      {
         return this;
      }
      
      private function hasAnimatedMovieClip(param1:DisplayObject) : Boolean
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         if(param1 is MovieClip && MovieClip(param1).totalFrames > 1)
         {
            return true;
         }
         if(!(param1 is DisplayObjectContainer))
         {
            return false;
         }
         _loc3_ = DisplayObjectContainer(param1);
         while(_loc4_ < _loc3_.numChildren)
         {
            _loc2_ = _loc3_.getChildAt(_loc4_);
            if(this.hasAnimatedMovieClip(_loc2_))
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function fillOutfitSelf(param1:*) : *
      {
         this.char_mc = param1;
         this.hair_colors = Character.character_color_hair;
         this.skin_colors = this.face_color = Character.character_color_skin;
         this.loadItem(Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_face);
      }
      
      public function fillOutfit(param1:*, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String = "", param8:String = "") : *
      {
         this.char_mc = param1;
         if(param7 != "")
         {
            this.hair_colors = param7;
         }
         if(param8 != "")
         {
            this.skin_colors = param8;
            this.face_colors = param8;
         }
         this.loadItem(param2,param3,param4,param5,param6);
      }
      
      public function fillHead(param1:*, param2:*, param3:* = "face_01_0", param4:* = "0|0", param5:* = "0|0") : *
      {
         if(!this.char_head_loaded)
         {
            setTimeout(this.fillHead,200,param1,param2,param3,param4,param5);
            return;
         }
         this.char_head_loaded = false;
         this.char_head_mc = param1;
         this.hair_color = param4;
         this.face_color = param5;
         this.fillHeadFaceId = param3;
         this.fillHeadHairId = param2;
         var _loc6_:* = "items/" + param3.replace("%s",Character.character_gender) + ".swf";
         param3 = this.loader.add(_loc6_);
         param3.addEventListener(BulkLoader.COMPLETE,this.onCompleteFace2);
         _loc6_ = "items/" + param2.replace("%s",Character.character_gender) + ".swf";
         param2 = this.loader.add(_loc6_);
         param2.addEventListener(BulkLoader.COMPLETE,this.onCompleteHair2);
         this.loader.start();
      }
      
      public function onCompleteHair2(param1:*) : *
      {
         var back_hair:Class;
         var e:*;
         var event:* = param1;
         event.currentTarget.removeEventListener(event.type,this.onCompleteHair2);
         back_hair = null;
         e = event;
         try
         {
            this.hairMC2 = e.target.content["hair"];
            if(!Character.play_items_animation)
            {
               this.hairMC2.stopAllMovieClips();
               this.hairMC2.cacheAsBitmap = true;
            }
            else if(!this.hasAnimatedMovieClip(this.hairMC2))
            {
               this.hairMC2.cacheAsBitmap = true;
            }
            if(this.char_head_mc["hair"].numChildren > 0)
            {
               this.char_head_mc["hair"].removeChildAt(0);
            }
            this.char_head_mc["hair"].addChild(this.hairMC2);
            hair_mc.push(this.hairMC2);
            this.addHairColor(0,"fillHead");
            if(this.char_head_mc.hasOwnProperty("back_hair"))
            {
               if(this.char_head_mc["back_hair"].numChildren > 0)
               {
                  this.char_head_mc["back_hair"].removeChildAt(0);
               }
            }
            if(e.target.content.hasOwnProperty("back_hair"))
            {
               this.backHairMC2 = e.target.content["back_hair"];
               if(!Character.play_items_animation)
               {
                  this.backHairMC2.stopAllMovieClips();
                  this.backHairMC2.cacheAsBitmap = true;
               }
               else if(!this.hasAnimatedMovieClip(this.backHairMC2))
               {
                  this.backHairMC2.cacheAsBitmap = true;
               }
               this.char_head_mc["back_hair"].addChild(this.backHairMC2);
               hair_mc.push(this.backHairMC2);
               this.addHairColor(1,"fillHead");
            }
         }
         catch(e:Error)
         {
            Log.error(this,"hair model error",e);
         }
         this.char_head_loaded = true;
      }
      
      public function onCompleteFace2(param1:*) : void
      {
         param1.currentTarget.removeEventListener(param1.type,this.onCompleteFace2);
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         var _loc4_:* = param1;
         try
         {
            this.faceMC2 = _loc4_.target.content["face"];
            this.faceMC2.stopAllMovieClips();
            this.faceMC2.cacheAsBitmap = true;
            if(this.char_head_mc["face"].numChildren > 0)
            {
               this.removeChildsFromMovieClip(this.char_head_mc["face"]);
            }
            this.char_head_mc["face"].addChild(this.faceMC2);
            face_mc.push(this.faceMC2);
            this.addFaceColor();
         }
         catch(e:*)
         {
         }
      }
      
      public function loadItem(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         if(param1 != null)
         {
            this.wpnId = "items/" + param1.replace("%s",Character.character_gender) + ".swf";
            _loc6_ = this.loader.add(this.wpnId);
            _loc6_.addEventListener(BulkLoader.COMPLETE,this.onCompleteWpn);
         }
         if(param2 != null)
         {
            this.backId = "items/" + param2.replace("%s",Character.character_gender) + ".swf";
            _loc7_ = this.loader.add(this.backId);
            _loc7_.addEventListener(BulkLoader.COMPLETE,this.onCompleteBack);
         }
         if(param3 != null)
         {
            this.setId = "items/" + param3.replace("%s",Character.character_gender) + ".swf";
            _loc8_ = this.loader.add(this.setId);
            _loc8_.addEventListener(BulkLoader.COMPLETE,this.onCompleteSet);
         }
         if(param4 != null)
         {
            this.hairId = "items/" + param4.replace("%s",Character.character_gender) + ".swf";
            _loc9_ = this.loader.add(this.hairId);
            _loc9_.addEventListener(BulkLoader.COMPLETE,this.onCompleteHair);
         }
         if(param5 != null)
         {
            this.faceId = "items/" + param5.replace("%s",Character.character_gender) + ".swf";
            _loc10_ = this.loader.add(this.faceId);
            _loc10_.addEventListener(BulkLoader.COMPLETE,this.onCompleteFace);
         }
         this.loader.start();
      }
      
      public function onCompleteWpn(param1:Event) : void
      {
         var wpn:* = undefined;
         var wpn1:* = undefined;
         var content:Event = param1;
         content.currentTarget.removeEventListener(content.type,this.onCompleteWpn);
         try
         {
            wpn = content.target.content.weapon;
            if(!Character.play_items_animation)
            {
               wpn.stopAllMovieClips();
               wpn.cacheAsBitmap = true;
            }
            else if(!this.hasAnimatedMovieClip(wpn))
            {
               wpn.cacheAsBitmap = true;
            }
            if(this.char_mc.hasOwnProperty("weapon"))
            {
               this.removeChildsFromMovieClip(this.char_mc["weapon"]);
               this.char_mc["weapon"].addChild(wpn);
            }
            weapon_mc.push(wpn);
            wpn = null;
            if(content.target.content.hasOwnProperty("weapon1"))
            {
               wpn1 = content.target.content.weapon1;
               if(!Character.play_items_animation)
               {
                  wpn1.stopAllMovieClips();
                  wpn1.cacheAsBitmap = true;
               }
               else if(!this.hasAnimatedMovieClip(wpn1))
               {
                  wpn1.cacheAsBitmap = true;
               }
               if(this.char_mc.hasOwnProperty("weapon1"))
               {
                  this.removeChildsFromMovieClip(this.char_mc["weapon1"]);
                  this.char_mc["weapon1"].addChild(wpn1);
               }
               weapon_mc.push(wpn1);
               wpn1 = null;
            }
         }
         catch(e:*)
         {
         }
      }
      
      public function onCompleteBack(param1:Event) : void
      {
         var bi:* = undefined;
         var content:Event = param1;
         content.currentTarget.removeEventListener(content.type,this.onCompleteBack);
         try
         {
            bi = content.target.content.back_item;
            if(!Character.play_items_animation)
            {
               bi.stopAllMovieClips();
               bi.cacheAsBitmap = true;
            }
            else if(!this.hasAnimatedMovieClip(bi))
            {
               bi.cacheAsBitmap = true;
            }
            if(this.char_mc.hasOwnProperty("back"))
            {
               this.removeChildsFromMovieClip(this.char_mc["back"]);
               this.char_mc["back"].addChild(bi);
            }
            back_mc.push(bi);
         }
         catch(e:*)
         {
         }
      }
      
      public function onCompleteFace(param1:Event) : void
      {
         var content:Event = param1;
         content.currentTarget.removeEventListener(content.type,this.onCompleteFace);
         try
         {
            faceMC = content.target.content.face;
            faceMC.stopAllMovieClips();
            faceMC.cacheAsBitmap = true;
            if(this.char_mc["head"]["face"].numChildren > 0)
            {
               this.removeChildsFromMovieClip(this.char_mc["head"]["face"]);
            }
            this.char_mc["head"]["face"].addChild(faceMC);
            face_mc.push(faceMC);
            this.addFaceColor();
         }
         catch(e:*)
         {
         }
      }
      
      public function onCompleteSet(param1:Event) : void
      {
         var loc1:*;
         var skirt:* = undefined;
         var content:Event = param1;
         content.currentTarget.removeEventListener(content.type,this.onCompleteSet);
         loc1 = 0;
         while(loc1 < this.char_bodyArray.length)
         {
            try
            {
               setMC = content.target.content[this.char_bodyArray[loc1]];
               if(!Character.play_items_animation)
               {
                  setMC.stopAllMovieClips();
                  setMC.cacheAsBitmap = true;
               }
               else if(!this.hasAnimatedMovieClip(setMC))
               {
                  setMC.cacheAsBitmap = true;
               }
               this.removeChildsFromMovieClip(this.char_mc[this.char_bodyArray[loc1]]);
               this.char_mc[this.char_bodyArray[loc1]].addChild(setMC);
               set_mc.push(setMC);
               this.addSkinColor();
               loc1++;
            }
            catch(e:Error)
            {
               loc1++;
            }
         }
         try
         {
            if(content.target.content.hasOwnProperty("skirt"))
            {
               this.removeChildsFromMovieClip(this.char_mc["skirt"]);
               skirt = content.target.content.skirt;
               if(!Character.play_items_animation)
               {
                  skirt.stopAllMovieClips();
               }
               this.char_mc["skirt"].addChild(skirt);
               set_mc.push(skirt);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function onCompleteHair(param1:Event) : *
      {
         var content:Event = param1;
         if(content == null)
         {
            return;
         }
         content.currentTarget.removeEventListener(content.type,this.onCompleteHair);
         try
         {
            hairMC = content.target.content.hair;
            if(!Character.play_items_animation)
            {
               hairMC.stopAllMovieClips();
               hairMC.cacheAsBitmap = true;
            }
            else if(!this.hasAnimatedMovieClip(hairMC))
            {
               hairMC.cacheAsBitmap = true;
            }
            if(this.char_mc["head"]["hair"].numChildren > 0)
            {
               this.char_mc["head"]["hair"].removeChildAt(0);
            }
            this.char_mc["head"]["hair"].addChild(hairMC);
            hair_mc.push(hairMC);
            this.addHairColor(0);
            if(this.char_mc.hasOwnProperty("back_hair"))
            {
               if(this.char_mc["back_hair"].numChildren > 0)
               {
                  this.char_mc["back_hair"].removeChildAt(0);
               }
            }
            if(content.target.content.hasOwnProperty("back_hair"))
            {
               backHairMC = content.target.content.back_hair;
               if(!Character.play_items_animation)
               {
                  backHairMC.stopAllMovieClips();
                  backHairMC.cacheAsBitmap = true;
               }
               else if(!this.hasAnimatedMovieClip(backHairMC))
               {
                  backHairMC.cacheAsBitmap = true;
               }
               this.char_mc["back_hair"].addChild(backHairMC);
               hair_mc.push(backHairMC);
               this.addHairColor(1);
            }
         }
         catch(e:Error)
         {
            Log.error(this,"hair model error",e);
         }
      }
      
      public function addHairColor(param1:int, param2:* = null) : void
      {
         var _loc3_:ColorTransform = new ColorTransform();
         var _loc4_:ColorTransform = new ColorTransform();
         var _loc5_:* = Character.character_color_hair;
         var _loc6_:* = hairMC;
         var _loc7_:* = backHairMC;
         if(param2 != null)
         {
            _loc5_ = this.hair_color;
            _loc6_ = this.hairMC2;
            _loc7_ = this.backHairMC2;
         }
         if(this.hair_colors != null && param2 == null)
         {
            _loc5_ = this.hair_colors;
         }
         var _loc8_:* = _loc5_.split("|");
         _loc3_.color = _loc8_[0];
         _loc4_.color = _loc8_[1];
         this.color_1 = _loc8_[0];
         this.color_2 = _loc8_[1];
         if(param1 == 0)
         {
            if("hair_color_1" in _loc6_ && _loc8_[0] != "null")
            {
               _loc6_.hair_color_1.transform.colorTransform = _loc3_;
            }
            if("hair_color_2" in _loc6_ && _loc8_[1] != "null")
            {
               _loc6_.hair_color_2.transform.colorTransform = _loc4_;
            }
         }
         else
         {
            if("hair_color_1" in _loc7_ && _loc8_[0] != "null")
            {
               _loc7_.hair_color_1.transform.colorTransform = _loc3_;
            }
            if("hair_color_2" in _loc7_ && _loc8_[1] != "null")
            {
               _loc7_.hair_color_2.transform.colorTransform = _loc4_;
            }
         }
      }
      
      public function addSkinColor() : void
      {
         var _loc1_:ColorTransform = new ColorTransform();
         var _loc2_:ColorTransform = new ColorTransform();
         var _loc3_:* = Character.character_color_skin;
         if(this.skin_colors != null)
         {
            _loc3_ = this.skin_colors;
         }
         var _loc4_:* = _loc3_.split("|");
         _loc1_.color = _loc4_[0];
         _loc2_.color = _loc4_[1];
         try
         {
            if(_loc4_[0] != "null")
            {
               setMC.skin_color.transform.colorTransform = _loc1_;
            }
         }
         catch(e:*)
         {
         }
      }
      
      public function addFaceColor(param1:* = null) : void
      {
         var _loc2_:ColorTransform = new ColorTransform();
         var _loc3_:ColorTransform = new ColorTransform();
         var _loc4_:* = Character.character_color_skin;
         var _loc5_:* = faceMC;
         if(param1 != null)
         {
            _loc4_ = param1;
            _loc5_ = this.faceMC2;
         }
         if(this.face_colors != null && param1 == null)
         {
            _loc4_ = this.face_colors;
         }
         var _loc6_:* = _loc4_.split("|");
         _loc2_.color = _loc6_[0];
         _loc3_.color = _loc6_[1];
         try
         {
            if(_loc6_[1] != "null")
            {
               _loc5_.skin_color.transform.colorTransform = _loc3_;
            }
         }
         catch(e:*)
         {
         }
      }
      
      public function removeChildsFromMovieClip(param1:*) : *
      {
         GF.removeAllChild(param1);
      }
      
      public function clearChilds() : *
      {
         var _loc1_:* = undefined;
         if(this.char_mc)
         {
            _loc1_ = 0;
            while(_loc1_ < this.char_bodyArray.length)
            {
               if(Boolean(this.char_bodyArray[_loc1_]) && this.char_bodyArray[_loc1_] in this.char_mc)
               {
                  GF.removeAllChild(this.char_mc[this.char_bodyArray[_loc1_]]);
               }
               _loc1_++;
            }
            if("weapon" in this.char_mc)
            {
               GF.removeAllChild(this.char_mc["weapon"]);
            }
            if("skirt" in this.char_mc)
            {
               GF.removeAllChild(this.char_mc["skirt"]);
            }
            if("back" in this.char_mc)
            {
               GF.removeAllChild(this.char_mc["back"]);
            }
            if(this.char_mc["back_hair"])
            {
               GF.removeAllChild(this.char_mc["back_hair"]);
            }
            if(this.char_mc["head"])
            {
               if("hair" in this.char_mc["head"])
               {
                  GF.removeAllChild(this.char_mc["head"]["hair"]);
               }
               if("face" in this.char_mc["head"])
               {
                  GF.removeAllChild(this.char_mc["head"]["face"]);
               }
            }
            if(this.removeCharMc)
            {
               GF.removeAllChild(this.char_mc);
            }
         }
         if(this.char_head_mc)
         {
            if("back_hair" in this.char_head_mc)
            {
               GF.removeAllChild(this.char_head_mc["back_hair"]);
            }
            if("hair" in this.char_head_mc)
            {
               GF.removeAllChild(this.char_head_mc["hair"]);
            }
            if("face" in this.char_head_mc)
            {
               GF.removeAllChild(this.char_head_mc["face"]);
            }
            GF.removeAllChild(this.char_head_mc);
         }
      }
      
      public function destroy() : *
      {
         Log.debug(this,"DESTROY");
         this.clearChilds();
         GF.clearArray(this.char_bodyArray);
         if(this.hairMC2)
         {
            GF.removeAllChild(this.hairMC2);
         }
         if(this.faceMC2)
         {
            GF.removeAllChild(this.faceMC2);
         }
         if(this.backHairMC2)
         {
            GF.removeAllChild(this.backHairMC2);
         }
         this.char_mc = null;
         this.char_head_mc = null;
         this.char_head_loaded = null;
         this.char_bodyArray = null;
         this.hairMC2 = null;
         this.faceMC2 = null;
         this.backHairMC2 = null;
         this.hair_color = null;
         this.hair_colors = null;
         this.color_1 = 0;
         this.color_2 = 0;
         this.loader = null;
         this.wpnId = null;
         this.setId = null;
         this.backId = null;
         this.hairId = null;
         this.faceId = null;
         this.fillHeadFaceId = null;
         this.fillHeadHairId = null;
      }
   }
}

