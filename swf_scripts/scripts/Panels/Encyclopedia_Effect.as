package Panels
{
   import Storage.GameData;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2433")]
   public dynamic class Encyclopedia_Effect extends MovieClip
   {
      
      public var btn_clearSearch:SimpleButton;
      
      public var btn_search:SimpleButton;
      
      public var txt_search:TextField;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var btn_buff:SimpleButton;
      
      public var btn_debuff:SimpleButton;
      
      public var effectTxt:TextField;
      
      private var selectedEffect:Array;
      
      private var main:*;
      
      private var buffList:Array;
      
      private var debuffList:Array;
      
      private var currentTab:String;
      
      private var eventHandler:EventHandler;
      
      private var glowFilter:*;
      
      public function Encyclopedia_Effect(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         var _loc2_:Object = GameData.get("encyclopedia");
         this.buffList = _loc2_.effect.buffs;
         this.debuffList = _loc2_.effect.debuffs;
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.glowFilter = CreateFilter.getGlowFilter({
            "color":16776960,
            "strength":1000,
            "blurX":6,
            "blurY":6
         });
         this.btn_buff.filters = [this.glowFilter];
         this.currentTab = "buff";
         this.initData();
      }
      
      private function initData() : *
      {
         var _loc3_:* = undefined;
         this.selectedEffect = [];
         var _loc1_:Array = this.currentTab == "buff" ? this.buffList : this.debuffList;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            this.selectedEffect.push(this.formatEffect(_loc3_));
            _loc2_++;
         }
         this.showStatusEffect();
      }
      
      private function showStatusEffect() : *
      {
         this.effectTxt.htmlText = this.selectedEffect.join("\n");
         this.effectTxt.scrollV = this.effectTxt.scrollV;
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_buff,MouseEvent.CLICK,this.changeEffect);
         this.eventHandler.addListener(this.btn_debuff,MouseEvent.CLICK,this.changeEffect);
         this.eventHandler.addListener(this.btn_search,MouseEvent.CLICK,this.searchEffect);
         this.eventHandler.addListener(this.btn_clearSearch,MouseEvent.CLICK,this.clearSearch);
      }
      
      private function formatEffect(param1:*) : *
      {
         return this.formatColor(this.currentTab,param1.name) + "\n" + param1.description + "\n";
      }
      
      private function formatColor(param1:*, param2:*) : *
      {
         switch(param1)
         {
            case "buff":
               return this.colorize(param2,"#00ff00");
            case "debuff":
               return this.colorize(param2,"#ff0000");
            default:
               return this.colorize(param2,"#ffffff");
         }
      }
      
      private function colorize(param1:*, param2:*) : *
      {
         return "<font color=\"" + param2 + "\">" + param1 + "</font>";
      }
      
      private function clearSearch(param1:MouseEvent) : void
      {
         this.txt_search.text = "";
         this.initData();
      }
      
      private function searchEffect(param1:MouseEvent) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         var _loc3_:Array = this.currentTab == "buff" ? this.buffList : this.debuffList;
         var _loc4_:String = this.txt_search.text.toLowerCase();
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc7_];
            _loc6_ = _loc5_.name.toLowerCase();
            if(_loc6_.indexOf(_loc4_) >= 0)
            {
               _loc2_.push(_loc5_);
            }
            _loc7_++;
         }
         this.selectedEffect = [];
         _loc7_ = 0;
         while(_loc7_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc7_];
            this.selectedEffect.push(this.formatEffect(_loc5_));
            _loc7_++;
         }
         this.showStatusEffect();
      }
      
      private function changeEffect(param1:MouseEvent) : *
      {
         this.btn_buff.filters = null;
         this.btn_debuff.filters = null;
         if(param1.currentTarget.name == "btn_buff")
         {
            this.currentTab = "buff";
            this.btn_buff.filters = [this.glowFilter];
         }
         else
         {
            this.currentTab = "debuff";
            this.btn_debuff.filters = [this.glowFilter];
         }
         this.initData();
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.currentTab = null;
         this.btn_buff.filters = null;
         this.btn_debuff.filters = null;
         this.selectedEffect = [];
         this.buffList = [];
         this.debuffList = [];
         this.effectTxt.htmlText = "";
         GF.removeAllChild(this);
      }
   }
}

