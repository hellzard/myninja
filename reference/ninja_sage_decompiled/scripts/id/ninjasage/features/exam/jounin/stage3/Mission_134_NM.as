package id.ninjasage.features.exam.jounin.stage3
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public dynamic class Mission_134_NM extends MovieClip
   {
       
      
      public var main;
      
      public var panelMC;
      
      public var _parent;
      
      public var map;
      
      private const ALL_COLOR:Array = [1,2,3,4,5,6];
      
      private var level:int = 1;
      
      private var choose:int = 6;
      
      private var curPos:int = 1;
      
      private var patternHistory:Array;
      
      private var generatedPattern:Array;
      
      private var selectedPattern:Array;
      
      private var completed = false;
      
      public function Mission_134_NM()
      {
         this.patternHistory = [];
         this.generatedPattern = [];
         this.selectedPattern = [];
         super();
      }
      
      public function init(param1:*, param2:*, param3:*, param4:int, param5:*) : *
      {
         this.main = param1;
         this.panelMC = param2;
         this._parent = param3;
         this.map = param5;
         this.level = param4;
         this.initialScreen();
      }
      
      private function initialScreen() : *
      {
         var _loc4_:* = undefined;
         this.completed = false;
         this.panelMC.hintMc.visible = false;
         this.panelMC.sealMc.gotoAndStop(this.level);
         this.panelMC.sealMc.sealBtnMc.gotoAndStop(1);
         this.panelMC.sealMc.sealBtnMc.btnMc.gotoAndStop(1);
         this.patternHistory = [];
         this.generatedPattern = [];
         this.selectedPattern = [];
         var _loc1_:* = 1;
         var _loc2_:* = 1;
         while(_loc1_ <= 10)
         {
            this.panelMC["history_" + _loc1_]["greenNotice"]["txt"].text = "0";
            this.panelMC["history_" + _loc1_]["yellowNotice"]["txt"].text = "0";
            _loc2_ = 1;
            while(_loc2_ <= 5)
            {
               this.panelMC["history_" + _loc1_]["rune_" + _loc2_].gotoAndStop(0);
               _loc2_++;
            }
            _loc1_++;
         }
         this.resetSelectedPattern(null);
         var _loc3_:* = this.getRandomSequence(1,this.ALL_COLOR.length);
         _loc1_ = 0;
         while(_loc1_ <= this.level)
         {
            this.generatedPattern.push(_loc3_[_loc1_]);
            (_loc4_ = this.panelMC["rune" + _loc1_]).gotoAndStop(1);
            _loc4_["txt"].text = String(_loc1_ + 1);
            _loc4_.x = 480 / 2 + _loc1_ * 110 - this.level * 30;
            _loc4_.scaleX = 1.5;
            _loc4_.scaleY = 1.5;
            this.panelMC.selectedPatternHolder.addChild(_loc4_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.choose)
         {
            this.panelMC["runeBtn_" + this.ALL_COLOR[_loc1_]].addEventListener(MouseEvent.CLICK,this.selectRune,false,0,true);
            _loc1_++;
         }
         _loc1_ = this.choose;
         while(_loc1_ < this.ALL_COLOR.length)
         {
            this.panelMC["runeBtn_" + this.ALL_COLOR[_loc1_]].visible = false;
            _loc1_++;
         }
         this.updateDisplay();
      }
      
      private function updateDisplay(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         this.panelMC["clearBtn"].addEventListener(MouseEvent.CLICK,this.resetSelectedPattern,false,0,true);
         _loc2_ = 1;
         while(_loc2_ <= this.level)
         {
            _loc3_ = this.panelMC["selectedPatternHolder"].getChildAt(_loc2_ - 1);
            _loc3_.gotoAndStop(1);
            _loc3_["txt"].text = String(_loc2_);
            _loc2_++;
         }
         this.selectedPattern = [];
         this.curPos = 1;
         this.updateCurPos();
         this.panelMC["sealMc"]["sealBtnMc"].gotoAndStop(1);
      }
      
      private function selectRune(param1:MouseEvent) : *
      {
         if(this.selectedPattern.length == this.level + 1)
         {
            return;
         }
         var _loc2_:int = int(String(param1.currentTarget.name).replace("runeBtn_",""));
         this.selectedPattern.push(_loc2_);
         var _loc3_:MovieClip = this.panelMC["selectedPatternHolder"].getChildAt(this.curPos - 1);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.gotoAndStop(_loc2_ + 1);
         _loc3_["highlightMc"].gotoAndStop("idle");
         _loc3_["txt"].text = "";
         if(this.selectedPattern.length == this.level + 1)
         {
            if(!this.panelMC["sealMc"]["sealBtnMc"]["btnMc"].hasEventListener(MouseEvent.CLICK))
            {
               this.panelMC["sealMc"]["sealBtnMc"]["btnMc"].addEventListener(MouseEvent.CLICK,this.checkResult,false,0,true);
            }
            this.panelMC["sealMc"]["sealBtnMc"]["btnMc"].gotoAndStop(2);
         }
         else
         {
            ++this.curPos;
            this.updateCurPos();
         }
      }
      
      private function checkResult(param1:MouseEvent) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = {};
         this.patternHistory.push(this.selectedPattern);
         _loc2_ = 0;
         while(_loc2_ < this.selectedPattern.length)
         {
            if(this.selectedPattern[_loc2_] == this.generatedPattern[_loc2_])
            {
               _loc5_++;
               if(_loc7_[this.selectedPattern[_loc2_]])
               {
                  _loc7_[this.selectedPattern[_loc2_]] += 1;
               }
               else
               {
                  _loc7_[this.selectedPattern[_loc2_]] = 1;
               }
            }
            this.panelMC["history_" + this.patternHistory.length]["rune_" + String(_loc2_ + 1)].gotoAndStop(this.selectedPattern[_loc2_] + 1);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.selectedPattern.length)
         {
            _loc4_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.generatedPattern.length)
            {
               if(this.selectedPattern[_loc2_] == this.generatedPattern[_loc3_])
               {
                  _loc4_++;
                  if(!_loc7_[this.selectedPattern[_loc2_]])
                  {
                     _loc7_[this.selectedPattern[_loc2_]] = _loc4_;
                     _loc6_++;
                  }
                  if(_loc4_ > _loc7_[this.selectedPattern[_loc2_]])
                  {
                     _loc7_[this.selectedPattern[_loc2_]] = _loc4_;
                     _loc6_++;
                     break;
                  }
               }
               _loc3_++;
            }
            _loc2_++;
         }
         this.panelMC["history_" + this.patternHistory.length]["greenNotice"]["txt"].text = String(_loc5_);
         this.panelMC["history_" + this.patternHistory.length]["yellowNotice"]["txt"].text = String(_loc6_);
         this.panelMC["clearBtn"].removeEventListener(MouseEvent.CLICK,this.updateDisplay);
         if(_loc5_ == this.level + 1)
         {
            this._parent.incrementSeal();
            this.panelMC.sealMc.sealBtnMc.gotoAndStop("unlock");
            _loc2_ = 0;
            while(_loc2_ < this.selectedPattern.length)
            {
               if(this.panelMC["sealMc"]["rune_" + String(_loc2_ + 1)])
               {
                  this.panelMC["sealMc"]["rune_" + String(_loc2_ + 1)].gotoAndStop(this.selectedPattern[_loc2_] + 1);
               }
               _loc2_++;
            }
            this.completed = true;
            setTimeout(this.exit,1000);
            return;
         }
         this.panelMC.sealMc.sealBtnMc.gotoAndStop("fail");
         if(this.patternHistory.length == 10)
         {
            this.showDialogueFail();
         }
         else
         {
            setTimeout(this.resetSelectedPattern,1000);
         }
      }
      
      public function showDialogueFail() : *
      {
         var _loc1_:* = [this._parent.langFile.textArr[5]];
         this.main.showDialogue(_loc1_,this.backToVillage,"shin");
      }
      
      public function backToVillage() : *
      {
         this._parent.destroy();
      }
      
      private function updateCurPos() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 1;
         while(_loc1_ <= this.level)
         {
            _loc2_ = this.panelMC["selectedPatternHolder"].getChildAt(_loc1_ - 1);
            if(_loc1_ == this.curPos)
            {
               _loc2_["highlightMc"].gotoAndPlay("show");
            }
            else
            {
               _loc2_["highlightMc"].gotoAndStop("idle");
            }
            _loc1_++;
         }
      }
      
      private function getRandomSequence(param1:int, param2:int) : Array
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
            _loc5_ = _loc5_.concat(_loc3_.splice(Math.floor(Math.random() * _loc3_.length),1));
         }
         return _loc5_;
      }
      
      public function getChildrenOf(param1:*) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc2_.push(param1.getChildAt(_loc3_));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function resetSelectedPattern(param1:MouseEvent = null) : *
      {
         var _loc3_:* = undefined;
         this.selectedPattern = [];
         this.curPos = 1;
         this.panelMC.sealMc.sealBtnMc.gotoAndStop(1);
         this.panelMC.sealMc.sealBtnMc.btnMc.gotoAndStop(1);
         this.panelMC.sealMc.sealBtnMc["btnMc"].removeEventListener(MouseEvent.CLICK,this.checkResult);
         var _loc2_:* = 1;
         while(_loc2_ <= this.level + 1)
         {
            this.panelMC.sealMc.sealBtnMc["rune_" + _loc2_].visible = true;
            this.panelMC.sealMc.sealBtnMc["rune_" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.panelMC.selectedPatternHolder.numChildren)
         {
            _loc3_ = this.panelMC.selectedPatternHolder.getChildAt(_loc2_);
            if(_loc3_)
            {
               _loc3_.gotoAndStop(1);
               _loc3_.txt.text = _loc2_ + 1;
            }
            _loc2_++;
         }
      }
      
      private function exit() : *
      {
         this.panelMC.visible = false;
         this.map.onExit();
      }
      
      private function pleaseDontCopyOurGameXoxo() : *
      {
      }
   }
}
