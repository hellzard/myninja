package id.ninjasage.features
{
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class EncyclopediaEffect extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var selectedEffect:Array;
      
      private var main:*;
      
      private var buffList:Array;
      
      private var debuffList:Array;
      
      private var buffCategoryList:Array = ["All","Offense","Defense","Hybrid"];
      
      private var debuffCategoryList:Array = ["All","Offense","Defense","Control","Hybrid"];
      
      private var currentTab:String;
      
      private var currentCategoryIndex:int;
      
      private var currentPage:int;
      
      private var totalPage:int;
      
      private var eventHandler:EventHandler;
      
      private var defaultFontSize:int = 20;
      
      public function EncyclopediaEffect(param1:*, param2:*)
      {
         super();
         var _loc3_:Object = GameData.get("encyclopedia");
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.buffList = _loc3_.effect.buffs;
         this.debuffList = _loc3_.effect.debuffs;
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.panelMC.txt_search.text = "";
         this.currentTab = "buff";
         this.currentCategoryIndex = 0;
         this.initButton();
         this.initCategoryButton();
         this.sortEffect();
      }
      
      private function initButton() : void
      {
         this.panelMC.btn_buff.gotoAndStop(3);
         this.panelMC.btn_debuff.gotoAndStop(1);
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_buff,MouseEvent.CLICK,this.changeTab);
         this.eventHandler.addListener(this.panelMC.btn_buff,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.panelMC.btn_buff,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.panelMC.btn_debuff,MouseEvent.CLICK,this.changeTab);
         this.eventHandler.addListener(this.panelMC.btn_debuff,MouseEvent.MOUSE_OVER,this.over);
         this.eventHandler.addListener(this.panelMC.btn_debuff,MouseEvent.MOUSE_OUT,this.out);
         this.eventHandler.addListener(this.panelMC.btn_search,MouseEvent.CLICK,this.searchEffect);
         this.eventHandler.addListener(this.panelMC.btn_clearSearch,MouseEvent.CLICK,this.clearSearch);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
      }
      
      private function sortEffect() : void
      {
         this.selectedEffect = [];
         var _loc1_:Object = {};
         var _loc2_:Array = this.currentTab == "buff" ? this.buffList : this.debuffList;
         var _loc3_:Array = this.currentTab == "buff" ? this.buffCategoryList : this.debuffCategoryList;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(this.currentCategoryIndex == 0)
            {
               _loc1_ = _loc2_[_loc4_];
               this.selectedEffect.push(_loc1_);
            }
            else if(_loc2_[_loc4_].category == _loc3_[this.currentCategoryIndex].toLowerCase())
            {
               _loc1_ = _loc2_[_loc4_];
               this.selectedEffect.push(_loc1_);
            }
            _loc4_++;
         }
         this.selectedEffect.sortOn("name",Array.CASEINSENSITIVE);
         this.currentPage = 1;
         this.totalPage = Math.max(1,Math.ceil(this.selectedEffect.length / 8));
         this.showStatusEffect();
      }
      
      private function showStatusEffect() : void
      {
         var _loc5_:int = 0;
         var _loc1_:String = this.currentTab == "buff" ? "Buff" : "Debuff";
         var _loc2_:String = this.currentTab == "buff" ? this.buffCategoryList[this.currentCategoryIndex] : this.debuffCategoryList[this.currentCategoryIndex];
         var _loc3_:String = _loc2_ + " " + _loc1_;
         this.panelMC.content.txt_title_0.htmlText = this.formatColor(this.currentCategoryIndex,_loc3_);
         this.panelMC.content.txt_title_1.htmlText = this.formatColor(this.currentCategoryIndex,_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < 8)
         {
            _loc5_ = _loc4_ + (this.currentPage - 1) * 8;
            this.panelMC.content["effect_" + _loc4_].visible = false;
            if(_loc5_ < this.selectedEffect.length)
            {
               this.panelMC.content["effect_" + _loc4_].visible = true;
               this.panelMC.content["effect_" + _loc4_].txt_effect_title.htmlText = this.formatColor(this.currentCategoryIndex,this.selectedEffect[_loc5_].name);
               this.adjustDescriptionFontSize(this.panelMC.content["effect_" + _loc4_].txt_effect_description,this.selectedEffect[_loc5_].description);
            }
            _loc4_++;
         }
         this.updatePageNumber();
      }
      
      private function adjustDescriptionFontSize(param1:TextField, param2:String) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:TextFormat = param1.getTextFormat();
         var _loc4_:Object = _loc3_.size || this.defaultFontSize;
         _loc3_.size = this.defaultFontSize;
         param1.htmlText = param2;
         param1.setTextFormat(_loc3_);
         var _loc5_:int = param1.height;
         var _loc6_:int = param1.width;
         var _loc7_:int = param1.textHeight;
         var _loc8_:int = param1.textWidth;
         var _loc9_:Boolean = _loc7_ > _loc5_;
         if(_loc9_)
         {
            _loc10_ = this.defaultFontSize;
            _loc11_ = 8;
            while((param1.textHeight > _loc5_ || param1.textWidth > _loc6_) && _loc10_ > _loc11_)
            {
               _loc10_ -= 0.5;
               _loc3_.size = _loc10_;
               param1.setTextFormat(_loc3_);
               _loc7_ = param1.textHeight;
               _loc8_ = param1.textWidth;
            }
         }
         else
         {
            _loc3_.size = this.defaultFontSize;
            param1.setTextFormat(_loc3_);
         }
      }
      
      private function formatColor(param1:int, param2:String) : String
      {
         if(this.currentTab == "buff")
         {
            switch(param1)
            {
               case 0:
                  return this.colorize(param2,"#66ff33");
               case 1:
                  return this.colorize(param2,"#ff3838");
               case 2:
                  return this.colorize(param2,"#ff9900");
            }
         }
         else
         {
            switch(param1)
            {
               case 0:
                  return this.colorize(param2,"#ff3838");
               case 1:
                  return this.colorize(param2,"#ff3838");
               case 2:
                  return this.colorize(param2,"#ff9900");
            }
         }
         return this.colorize(param2,"#cc66ff");
      }
      
      private function colorize(param1:String, param2:String) : String
      {
         return "<font color=\"" + param2 + "\">" + param1 + "</font>";
      }
      
      private function clearSearch(param1:MouseEvent) : void
      {
         this.panelMC.txt_search.text = "";
         this.sortEffect();
      }
      
      private function searchEffect(param1:MouseEvent) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         var _loc3_:Array = this.currentTab == "buff" ? this.buffList : this.debuffList;
         var _loc4_:String = this.panelMC.txt_search.text.toLowerCase();
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
            this.selectedEffect.push(_loc5_);
            _loc7_++;
         }
         this.selectedEffect.sortOn("name",Array.CASEINSENSITIVE);
         this.currentCategoryIndex = 0;
         this.initCategoryButton();
         this.panelMC.btn_0.gotoAndStop(3);
         this.currentPage = 1;
         this.totalPage = Math.max(1,Math.ceil(this.selectedEffect.length / 8));
         this.updatePageNumber();
         this.showStatusEffect();
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
               }
               break;
            case "btn_next":
               if(this.currentPage < this.totalPage)
               {
                  ++this.currentPage;
               }
         }
         this.showStatusEffect();
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function resetTab() : void
      {
         this.panelMC.btn_buff.gotoAndStop(1);
         this.panelMC.btn_debuff.gotoAndStop(1);
      }
      
      private function resetCategoryTab() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.panelMC["btn_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function changeTab(param1:MouseEvent) : void
      {
         this.resetTab();
         param1.currentTarget.gotoAndStop(3);
         this.currentTab = param1.currentTarget.name == "btn_buff" ? "buff" : "debuff";
         this.currentCategoryIndex = 0;
         this.initCategoryButton();
         this.sortEffect();
      }
      
      private function initCategoryButton() : void
      {
         var _loc1_:Array = this.currentTab == "buff" ? this.buffCategoryList : this.debuffCategoryList;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            this.panelMC["btn_" + _loc2_].visible = false;
            this.panelMC["btn_" + _loc2_].gotoAndStop(1);
            if(_loc2_ < _loc1_.length)
            {
               this.panelMC["btn_" + _loc2_].visible = true;
               this.panelMC["btn_" + _loc2_].txt.text = _loc1_[_loc2_];
               this.eventHandler.addListener(this.panelMC["btn_" + _loc2_],MouseEvent.CLICK,this.changeCategory);
               this.eventHandler.addListener(this.panelMC["btn_" + _loc2_],MouseEvent.MOUSE_OVER,this.over);
               this.eventHandler.addListener(this.panelMC["btn_" + _loc2_],MouseEvent.MOUSE_OUT,this.out);
            }
            _loc2_++;
         }
      }
      
      private function changeCategory(param1:MouseEvent) : void
      {
         this.currentCategoryIndex = param1.currentTarget.name.replace("btn_","");
         this.resetCategoryTab();
         param1.currentTarget.gotoAndStop(3);
         this.sortEffect();
      }
      
      private function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
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
         this.selectedEffect = [];
         this.buffList = [];
         this.debuffList = [];
         this.buffCategoryList = [];
         this.debuffCategoryList = [];
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
      }
   }
}

