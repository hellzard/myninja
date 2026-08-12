package id.ninjasage.multiplayer
{
   import flash.display.MovieClip;
   import flash.text.TextFormat;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import gs.easing.Linear;
   import id.ninjasage.multiplayer.battle.Battle;
   import id.ninjasage.multiplayer.battle.CharacterManager;
   
   public class EffectOverlay
   {
       
      
      private var _battle:Battle;
      
      private var timeouts:Array;
      
      private var buffOverlayList:Array;
      
      public function EffectOverlay(param1:Battle)
      {
         this.timeouts = [];
         this.buffOverlayList = [];
         super();
         this._battle = param1;
      }
      
      public function init() : *
      {
         this.timeouts.push(setTimeout(this.buffOverlay,200,this.timeouts.length));
      }
      
      private function resumePollingIfNeeded() : void
      {
         if(this.timeouts != null && this.timeouts.length == 0)
         {
            this.init();
         }
      }
      
      public function buffOverlay(param1:int = 0) : void
      {
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         if(this.buffOverlayList == null || this.timeouts == null)
         {
            return;
         }
         if(this.buffOverlayList.length > 0)
         {
            _loc2_ = this.buffOverlayList[0];
            _loc3_ = new (getDefinitionByName(_loc2_.type) as Class)();
            _loc3_.stop();
            _loc3_.txt.text = _loc2_.text;
            this.changeBuffTextColor(_loc3_,_loc2_.color);
            _loc4_ = this.buffOverlayList.length;
            _loc3_.x = _loc2_.x;
            _loc3_.y = _loc2_.y - _loc4_ * 25;
            this._battle.addChild(_loc3_);
            _loc5_ = _loc3_.y - 200;
            TweenLite.to(_loc3_,1.5,{
               "y":_loc5_,
               "ease":Linear.easeNone,
               "onComplete":this.removeBuffFromScreen,
               "onCompleteParams":[_loc3_]
            });
            this.buffOverlayList.shift();
         }
         if(this.timeouts.length > 0)
         {
            this.timeouts.shift();
         }
         if(this.buffOverlayList != null && this.buffOverlayList.length > 0)
         {
            this.init();
         }
      }
      
      public function removeBuffFromScreen(param1:*) : void
      {
         var _loc2_:* = this._battle;
         if(_loc2_ && param1.parent == _loc2_)
         {
            TweenLite.killTweensOf(param1);
            _loc2_.removeChild(param1);
         }
      }
      
      public function showEffectFromText(param1:*, param2:String) : void
      {
         var _loc3_:String = this.getMcModel(param2);
         if(_loc3_ == "healing" || _loc3_ == "charging")
         {
            param2 = this.getNumberFromText(param2);
         }
         this.buffOverlayList.push({
            "type":_loc3_,
            "x":param1.x + 130,
            "y":param1.y - 100,
            "text":param2,
            "color":16777215
         });
         this.resumePollingIfNeeded();
      }
      
      public function showEffectInfo(param1:CharacterManager, param2:String) : void
      {
         var _loc3_:* = this._battle.getObjectHolder(param1.getPlayerTeam(),param1.getPlayerNumber());
         this.showEffectFromText(_loc3_,param2);
      }
      
      public function showOverlays(param1:*, param2:Array) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = param1.getCharacterManagerByID(param2[_loc3_].id);
            _loc5_ = param1.getPetManagerByID(param2[_loc3_].id);
            if(_loc6_ = !!_loc4_ ? _loc4_ : _loc5_)
            {
               _loc7_ = this._battle.getObjectHolder(_loc6_.getPlayerTeam(),_loc6_.getPlayerNumber());
               this.showOverlay(_loc7_,param2[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      public function showOverlayEffects(param1:CharacterManager, param2:Array) : *
      {
         var _loc3_:* = this._battle.getObjectHolder(param1.getPlayerTeam(),param1.getPlayerNumber());
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            this.showOverlay(_loc3_,param2[_loc4_]);
            _loc4_++;
         }
      }
      
      private function showOverlay(param1:MovieClip, param2:Object) : *
      {
         var _loc3_:* = param2.icon == "h";
         param2.icon = !!_loc3_ ? "healing" : "damagedeal";
         var _loc4_:String = "";
         if(param2.icon == "healing" && param2.amount)
         {
            _loc4_ = String(param2.amount);
         }
         else if(param2.hasOwnProperty("txt"))
         {
            _loc4_ = param2.txt;
         }
         this.buffOverlayList.push({
            "type":param2.icon,
            "x":param1.x + 130,
            "y":param1.y - (!!_loc3_ ? 100 : 125),
            "text":_loc4_,
            "color":param2.color
         });
         this.resumePollingIfNeeded();
      }
      
      public function getMcModel(param1:String) : String
      {
         var _loc2_:Array = ["BloodfeedMC","BloodlustMC","HealMC","DamageAbsorption","DamageToHp","LiquidationArmor"];
         var _loc3_:Array = [param1];
         if(param1.indexOf(" ") >= 0)
         {
            _loc3_ = param1.split(" ");
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc2_.indexOf(_loc3_[_loc4_]) >= 0)
            {
               return "healing";
            }
            _loc4_++;
         }
         return "damagedeal";
      }
      
      public function getNumberFromText(param1:String) : String
      {
         var _loc2_:Array = [param1];
         if(param1.indexOf(" ") >= 0)
         {
            _loc2_ = param1.split(" ");
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(!isNaN(Number(_loc2_[_loc3_])))
            {
               return _loc2_[_loc3_];
            }
            _loc3_++;
         }
         return "0";
      }
      
      public function changeBuffTextColor(param1:MovieClip, param2:*) : *
      {
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.color = param2;
         param1.txt.setTextFormat(_loc3_);
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.timeouts.length)
         {
            clearTimeout(this.timeouts[_loc1_]);
            _loc1_++;
         }
         this.timeouts = [];
         this.buffOverlayList = [];
         this.buffOverlayList = null;
         this.timeouts = null;
         this._battle = null;
      }
   }
}
