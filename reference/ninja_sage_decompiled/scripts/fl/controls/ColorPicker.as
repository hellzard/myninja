package fl.controls
{
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.events.ColorPickerEvent;
   import fl.managers.IFocusManager;
   import fl.managers.IFocusManagerComponent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   
   public class ColorPicker extends UIComponent implements IFocusManagerComponent
   {
      
      public static var defaultColors:Array;
      
      private static var defaultStyles:Object = {
         "upSkin":"ColorPicker_upSkin",
         "disabledSkin":"ColorPicker_disabledSkin",
         "overSkin":"ColorPicker_overSkin",
         "downSkin":"ColorPicker_downSkin",
         "colorWell":"ColorPicker_colorWell",
         "swatchSkin":"ColorPicker_swatchSkin",
         "swatchSelectedSkin":"ColorPicker_swatchSelectedSkin",
         "swatchWidth":50,
         "swatchHeight":50,
         "columnCount":18,
         "swatchPadding":5,
         "textFieldSkin":"ColorPicker_textFieldSkin",
         "textFieldWidth":null,
         "textFieldHeight":null,
         "textPadding":15,
         "background":"ColorPicker_backgroundSkin",
         "backgroundPadding":12,
         "textFormat":null,
         "focusRectSkin":null,
         "focusRectPadding":null,
         "embedFonts":false
      };
      
      protected static const POPUP_BUTTON_STYLES:Object = {
         "disabledSkin":"disabledSkin",
         "downSkin":"downSkin",
         "overSkin":"overSkin",
         "upSkin":"upSkin"
      };
      
      protected static const SWATCH_STYLES:Object = {
         "disabledSkin":"swatchSkin",
         "downSkin":"swatchSkin",
         "overSkin":"swatchSkin",
         "upSkin":"swatchSkin"
      };
       
      
      public var textField:TextField;
      
      protected var customColors:Array;
      
      protected var colorHash:Object;
      
      protected var paletteBG:DisplayObject;
      
      protected var selectedSwatch:Sprite;
      
      protected var _selectedColor:uint;
      
      protected var rollOverColor:int = -1;
      
      protected var _editable:Boolean = true;
      
      protected var _showTextField:Boolean = true;
      
      protected var isOpen:Boolean = false;
      
      protected var doOpen:Boolean = false;
      
      protected var swatchButton:BaseButton;
      
      protected var colorWell:DisplayObject;
      
      protected var swatchSelectedSkin:DisplayObject;
      
      protected var palette:Sprite;
      
      protected var textFieldBG:DisplayObject;
      
      protected var swatches:Sprite;
      
      protected var swatchMap:Array;
      
      protected var currRowIndex:int;
      
      protected var currColIndex:int;
      
      public function ColorPicker()
      {
         super();
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      public function get selectedColor() : uint
      {
         if(this.colorWell == null)
         {
            return 0;
         }
         return this.colorWell.transform.colorTransform.color;
      }
      
      public function set selectedColor(param1:uint) : void
      {
         if(!_enabled)
         {
            return;
         }
         this._selectedColor = param1;
         this.rollOverColor = -1;
         this.currColIndex = this.currRowIndex = 0;
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = param1;
         this.setColorWellColor(_loc2_);
         invalidate(InvalidationType.DATA);
      }
      
      public function get hexValue() : String
      {
         if(this.colorWell == null)
         {
            return this.colorToString(0);
         }
         return this.colorToString(this.colorWell.transform.colorTransform.color);
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         if(!param1)
         {
            this.close();
         }
         this.swatchButton.enabled = param1;
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(param1:Boolean) : void
      {
         this._editable = param1;
         invalidate(InvalidationType.STATE);
      }
      
      public function get showTextField() : Boolean
      {
         return this._showTextField;
      }
      
      public function set showTextField(param1:Boolean) : void
      {
         invalidate(InvalidationType.STYLES);
         this._showTextField = param1;
      }
      
      public function get colors() : Array
      {
         return this.customColors != null ? this.customColors : ColorPicker.defaultColors;
      }
      
      public function set colors(param1:Array) : void
      {
         this.customColors = param1;
         invalidate(InvalidationType.DATA);
      }
      
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         _imeMode = param1;
      }
      
      public function open() : void
      {
         if(!_enabled)
         {
            return;
         }
         this.doOpen = true;
         var _loc1_:IFocusManager = focusManager;
         if(_loc1_)
         {
            _loc1_.defaultButtonEnabled = false;
         }
         invalidate(InvalidationType.STATE);
      }
      
      public function close() : void
      {
         if(this.isOpen)
         {
            focusManager.form.removeChild(this.palette);
            this.isOpen = false;
            dispatchEvent(new Event(Event.CLOSE));
         }
         var _loc1_:IFocusManager = focusManager;
         if(_loc1_)
         {
            _loc1_.defaultButtonEnabled = true;
         }
         this.removeStageListener();
         this.cleanUpSelected();
      }
      
      private function addCloseListener(param1:Event) : *
      {
         removeEventListener(Event.ENTER_FRAME,this.addCloseListener);
         if(!this.isOpen)
         {
            return;
         }
         this.addStageListener();
      }
      
      protected function onStageClick(param1:MouseEvent) : void
      {
         if(!contains(param1.target as DisplayObject) && !this.palette.contains(param1.target as DisplayObject))
         {
            this.selectedColor = this._selectedColor;
            this.close();
         }
      }
      
      protected function setStyles() : void
      {
         var _loc1_:DisplayObject = this.colorWell;
         var _loc2_:Object = getStyleValue("colorWell");
         if(_loc2_ != null)
         {
            this.colorWell = getDisplayObjectInstance(_loc2_) as DisplayObject;
         }
         addChildAt(this.colorWell,getChildIndex(this.swatchButton));
         copyStylesToChild(this.swatchButton,POPUP_BUTTON_STYLES);
         this.swatchButton.drawNow();
         if(_loc1_ != null && contains(_loc1_) && _loc1_ != this.colorWell)
         {
            removeChild(_loc1_);
         }
      }
      
      protected function cleanUpSelected() : void
      {
         if(this.swatchSelectedSkin && this.palette.contains(this.swatchSelectedSkin))
         {
            this.palette.removeChild(this.swatchSelectedSkin);
         }
      }
      
      protected function onPopupButtonClick(param1:MouseEvent) : void
      {
         if(this.isOpen)
         {
            this.close();
         }
         else
         {
            this.open();
         }
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.STYLES,InvalidationType.DATA))
         {
            this.setStyles();
            this.drawPalette();
            this.setEmbedFonts();
            invalidate(InvalidationType.DATA,false);
            invalidate(InvalidationType.STYLES,false);
         }
         if(isInvalid(InvalidationType.DATA))
         {
            this.drawSwatchHighlight();
            this.setColorDisplay();
         }
         if(isInvalid(InvalidationType.STATE))
         {
            this.setTextEditable();
            if(this.doOpen)
            {
               this.doOpen = false;
               this.showPalette();
            }
            this.colorWell.visible = this.enabled;
         }
         if(isInvalid(InvalidationType.SIZE,InvalidationType.STYLES))
         {
            this.swatchButton.setSize(width,height);
            this.swatchButton.drawNow();
            this.colorWell.width = width;
            this.colorWell.height = height;
         }
         super.draw();
      }
      
      protected function showPalette() : void
      {
         if(this.isOpen)
         {
            this.positionPalette();
            return;
         }
         addEventListener(Event.ENTER_FRAME,this.addCloseListener,false,0,true);
         focusManager.form.addChild(this.palette);
         this.isOpen = true;
         this.positionPalette();
         dispatchEvent(new Event(Event.OPEN));
         stage.focus = this.textField;
         var _loc1_:Sprite = this.selectedSwatch;
         if(_loc1_ == null)
         {
            _loc1_ = this.findSwatch(this._selectedColor);
         }
         this.setSwatchHighlight(_loc1_);
      }
      
      protected function setEmbedFonts() : void
      {
         var _loc1_:Object = getStyleValue("embedFonts");
         if(_loc1_ != null)
         {
            this.textField.embedFonts = _loc1_;
         }
      }
      
      protected function drawSwatchHighlight() : void
      {
         this.cleanUpSelected();
         var _loc1_:Object = getStyleValue("swatchSelectedSkin");
         if(_loc1_ != null)
         {
            this.swatchSelectedSkin = getDisplayObjectInstance(_loc1_);
            this.swatchSelectedSkin.x = 0;
            this.swatchSelectedSkin.y = 0;
            this.swatchSelectedSkin.width = (getStyleValue("swatchWidth") as Number) + 2;
            this.swatchSelectedSkin.height = (getStyleValue("swatchHeight") as Number) + 2;
         }
      }
      
      protected function drawPalette() : void
      {
         if(this.isOpen)
         {
            focusManager.form.removeChild(this.palette);
         }
         this.palette = new Sprite();
         this.drawTextField();
         this.drawSwatches();
         this.drawBG();
      }
      
      protected function drawTextField() : void
      {
         var _loc5_:TextFormat = null;
         if(!this.showTextField)
         {
            return;
         }
         var _loc1_:Number = getStyleValue("backgroundPadding") as Number;
         var _loc2_:Number = getStyleValue("textPadding") as Number;
         this.textFieldBG = getDisplayObjectInstance(getStyleValue("textFieldSkin"));
         if(this.textFieldBG != null)
         {
            this.palette.addChild(this.textFieldBG);
            this.textFieldBG.x = this.textFieldBG.y = _loc1_;
         }
         var _loc3_:Object = UIComponent.getStyleDefinition();
         var _loc4_:TextFormat = !!this.enabled ? _loc3_.defaultTextFormat as TextFormat : _loc3_.defaultDisabledTextFormat as TextFormat;
         this.textField.setTextFormat(_loc4_);
         if((_loc5_ = getStyleValue("textFormat") as TextFormat) != null)
         {
            this.textField.setTextFormat(_loc5_);
         }
         else
         {
            _loc5_ = _loc4_;
         }
         this.textField.defaultTextFormat = _loc5_;
         this.setEmbedFonts();
         this.textField.restrict = "A-Fa-f0-9#";
         this.textField.maxChars = 6;
         this.palette.addChild(this.textField);
         this.textField.text = " #888888 ";
         this.textField.height = this.textField.textHeight + 6;
         this.textField.width = this.textField.textWidth + 6;
         this.textField.text = "";
         this.textField.x = this.textField.y = _loc1_ + _loc2_;
         this.textFieldBG.width = this.textField.width + _loc2_ * 2;
         this.textFieldBG.height = this.textField.height + _loc2_ * 2;
         this.setTextEditable();
      }
      
      protected function drawSwatches() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Number = getStyleValue("backgroundPadding") as Number;
         var _loc3_:Number = !!this.showTextField ? Number(Number(this.textFieldBG.y + this.textFieldBG.height + _loc2_)) : Number(Number(_loc2_));
         this.swatches = new Sprite();
         this.palette.addChild(this.swatches);
         this.swatches.x = _loc2_;
         this.swatches.y = _loc3_;
         var _loc4_:uint = getStyleValue("columnCount") as uint;
         var _loc5_:uint = getStyleValue("swatchPadding") as uint;
         var _loc6_:Number = getStyleValue("swatchWidth") as Number;
         var _loc7_:Number = getStyleValue("swatchHeight") as Number;
         this.colorHash = {};
         this.swatchMap = [];
         var _loc8_:uint = Math.min(1024,this.colors.length);
         var _loc9_:int = -1;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc8_)
         {
            (_loc1_ = this.createSwatch(this.colors[_loc10_])).x = (_loc6_ + _loc5_) * (_loc10_ % _loc4_);
            if(_loc1_.x == 0)
            {
               this.swatchMap.push([_loc1_]);
               _loc9_++;
            }
            else
            {
               this.swatchMap[_loc9_].push(_loc1_);
            }
            this.colorHash[this.colors[_loc10_]] = {
               "swatch":_loc1_,
               "row":_loc9_,
               "col":this.swatchMap[_loc9_].length - 1
            };
            _loc1_.y = Math.floor(_loc10_ / _loc4_) * (_loc7_ + _loc5_);
            this.swatches.addChild(_loc1_);
            _loc10_++;
         }
      }
      
      protected function drawBG() : void
      {
         var _loc1_:Object = getStyleValue("background");
         if(_loc1_ != null)
         {
            this.paletteBG = getDisplayObjectInstance(_loc1_) as Sprite;
         }
         if(this.paletteBG == null)
         {
            return;
         }
         var _loc2_:Number = Number(getStyleValue("backgroundPadding"));
         this.paletteBG.width = Math.max(!!this.showTextField ? Number(Number(this.textFieldBG.width)) : Number(Number(0)),this.swatches.width) + _loc2_ * 2;
         this.paletteBG.height = this.swatches.y + this.swatches.height + _loc2_;
         this.palette.addChildAt(this.paletteBG,0);
      }
      
      protected function positionPalette() : void
      {
         var myForm:DisplayObjectContainer = null;
         myForm = null;
         var theStageHeight:Number = NaN;
         var theStageWidth:Number = NaN;
         var p:Point = this.swatchButton.localToGlobal(new Point(0,0));
         myForm = focusManager.form;
         p = myForm.globalToLocal(p);
         var padding:Number = getStyleValue("backgroundPadding") as Number;
         try
         {
            theStageHeight = stage.stageHeight;
            theStageWidth = stage.stageWidth;
         }
         catch(se:SecurityError)
         {
            theStageHeight = myForm.height;
            theStageWidth = myForm.width;
         }
         if(p.x + this.palette.width > theStageWidth)
         {
            this.palette.x = p.x - this.palette.width << 0;
         }
         else
         {
            this.palette.x = p.x + this.swatchButton.width + padding << 0;
         }
         this.palette.y = Math.max(0,Math.min(p.y,theStageHeight - this.palette.height)) << 0;
      }
      
      protected function setTextEditable() : void
      {
         if(!this.showTextField)
         {
            return;
         }
         this.textField.type = !!this.editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         this.textField.selectable = this.editable;
      }
      
      override protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:Sprite = null;
         if(!this.isOpen)
         {
            return;
         }
         var _loc5_:ColorTransform = new ColorTransform();
         if(this.editable && this.showTextField)
         {
            if((_loc3_ = this.textField.text).indexOf("#") > -1)
            {
               _loc3_ = (_loc3_ = _loc3_.replace(/^\s+|\s+$/g,"")).replace(/#/g,"");
            }
            _loc2_ = parseInt(_loc3_,16);
            _loc4_ = this.findSwatch(_loc2_);
            this.setSwatchHighlight(_loc4_);
            _loc5_.color = _loc2_;
            this.setColorWellColor(_loc5_);
         }
         else
         {
            _loc2_ = this.rollOverColor;
            _loc5_.color = _loc2_;
         }
         if(param1.keyCode != Keyboard.ENTER)
         {
            return;
         }
         dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ENTER,_loc2_));
         this._selectedColor = this.rollOverColor;
         this.setColorText(_loc5_.color);
         this.rollOverColor = _loc5_.color;
         dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE,this.selectedColor));
         this.close();
      }
      
      protected function positionTextField() : void
      {
         if(!this.showTextField)
         {
            return;
         }
         var _loc1_:Number = getStyleValue("backgroundPadding") as Number;
         var _loc2_:Number = getStyleValue("textPadding") as Number;
         this.textFieldBG.x = this.paletteBG.x + _loc1_;
         this.textFieldBG.y = this.paletteBG.y + _loc1_;
         this.textField.x = this.textFieldBG.x + _loc2_;
         this.textField.y = this.textFieldBG.y + _loc2_;
      }
      
      protected function setColorDisplay() : void
      {
         if(!this.swatchMap.length)
         {
            return;
         }
         var _loc1_:ColorTransform = new ColorTransform(0,0,0,1,this._selectedColor >> 16,this._selectedColor >> 8 & 255,this._selectedColor & 255,0);
         this.setColorWellColor(_loc1_);
         this.setColorText(this._selectedColor);
         var _loc2_:Sprite = this.findSwatch(this._selectedColor);
         this.setSwatchHighlight(_loc2_);
         if(this.swatchMap.length && this.colorHash[this._selectedColor] == undefined)
         {
            this.cleanUpSelected();
         }
      }
      
      protected function setSwatchHighlight(param1:Sprite) : void
      {
         if(param1 == null)
         {
            if(this.palette.contains(this.swatchSelectedSkin))
            {
               this.palette.removeChild(this.swatchSelectedSkin);
            }
            return;
         }
         if(!this.palette.contains(this.swatchSelectedSkin) && this.colors.length > 0)
         {
            this.palette.addChild(this.swatchSelectedSkin);
         }
         else if(!this.colors.length)
         {
            return;
         }
         this.palette.setChildIndex(this.swatchSelectedSkin,this.palette.numChildren - 1);
         this.swatchSelectedSkin.x = this.swatches.x + param1.x - 1;
         this.swatchSelectedSkin.y = this.swatches.y + param1.y - 1;
         var _loc2_:* = param1.getChildByName("color").transform.colorTransform.color;
         this.currColIndex = this.colorHash[_loc2_].col;
         this.currRowIndex = this.colorHash[_loc2_].row;
      }
      
      protected function findSwatch(param1:uint) : Sprite
      {
         if(!this.swatchMap.length)
         {
            return null;
         }
         var _loc2_:Object = this.colorHash[param1];
         if(_loc2_ != null)
         {
            return _loc2_.swatch;
         }
         return null;
      }
      
      protected function onSwatchClick(param1:MouseEvent) : void
      {
         var _loc2_:ColorTransform = param1.target.getChildByName("color").transform.colorTransform;
         this._selectedColor = _loc2_.color;
         dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE,this.selectedColor));
         this.close();
      }
      
      protected function onSwatchOver(param1:MouseEvent) : void
      {
         var _loc2_:BaseButton = param1.target.getChildByName("color") as BaseButton;
         var _loc3_:ColorTransform = _loc2_.transform.colorTransform;
         this.setColorWellColor(_loc3_);
         this.setSwatchHighlight(param1.target as Sprite);
         this.setColorText(_loc3_.color);
         dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER,_loc3_.color));
      }
      
      protected function onSwatchOut(param1:MouseEvent) : void
      {
         var _loc2_:ColorTransform = param1.target.transform.colorTransform;
         dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT,_loc2_.color));
      }
      
      protected function setColorText(param1:uint) : void
      {
         if(this.textField == null)
         {
            return;
         }
         this.textField.text = "#" + this.colorToString(param1);
      }
      
      protected function colorToString(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16);
         while(_loc2_.length < 6)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      protected function setColorWellColor(param1:ColorTransform) : void
      {
         if(!this.colorWell)
         {
            return;
         }
         this.colorWell.transform.colorTransform = param1;
      }
      
      protected function createSwatch(param1:uint) : Sprite
      {
         var _loc7_:Graphics = null;
         var _loc2_:Sprite = new Sprite();
         var _loc3_:BaseButton = new BaseButton();
         _loc3_.focusEnabled = false;
         var _loc4_:Number = getStyleValue("swatchWidth") as Number;
         var _loc5_:Number = getStyleValue("swatchHeight") as Number;
         _loc3_.setSize(_loc4_,_loc5_);
         _loc3_.transform.colorTransform = new ColorTransform(0,0,0,1,param1 >> 16,param1 >> 8 & 255,param1 & 255,0);
         copyStylesToChild(_loc3_,SWATCH_STYLES);
         _loc3_.mouseEnabled = false;
         _loc3_.drawNow();
         _loc3_.name = "color";
         _loc2_.addChild(_loc3_);
         var _loc6_:Number = getStyleValue("swatchPadding") as Number;
         (_loc7_ = _loc2_.graphics).beginFill(0);
         _loc7_.drawRect(-_loc6_,-_loc6_,_loc4_ + _loc6_ * 2,_loc5_ + _loc6_ * 2);
         _loc7_.endFill();
         _loc2_.addEventListener(MouseEvent.CLICK,this.onSwatchClick,false,0,true);
         _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onSwatchOver,false,0,true);
         _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onSwatchOut,false,0,true);
         return _loc2_;
      }
      
      protected function addStageListener(param1:Event = null) : void
      {
         focusManager.form.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageClick,false,0,true);
      }
      
      protected function removeStageListener(param1:Event = null) : void
      {
         focusManager.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageClick,false);
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         super.focusInHandler(param1);
         setIMEMode(true);
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         if(param1.relatedObject == this.textField)
         {
            setFocus();
            return;
         }
         if(this.isOpen)
         {
            this.close();
         }
         super.focusOutHandler(param1);
         setIMEMode(false);
      }
      
      override protected function isOurFocus(param1:DisplayObject) : Boolean
      {
         return param1 == this.textField || super.isOurFocus(param1);
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc3_:ColorTransform = null;
         var _loc2_:Sprite = null;
         switch(param1.keyCode)
         {
            case Keyboard.SHIFT:
            case Keyboard.CONTROL:
               return;
            default:
               if(param1.ctrlKey)
               {
                  switch(param1.keyCode)
                  {
                     case Keyboard.DOWN:
                        this.open();
                        break;
                     case Keyboard.UP:
                        this.close();
                  }
                  return;
               }
               if(!this.isOpen)
               {
                  switch(param1.keyCode)
                  {
                     case Keyboard.UP:
                     case Keyboard.DOWN:
                     case Keyboard.LEFT:
                     case Keyboard.RIGHT:
                     case Keyboard.SPACE:
                        this.open();
                        return;
                  }
               }
               this.textField.maxChars = param1.keyCode == "#".charCodeAt(0) || this.textField.text.indexOf("#") > -1 ? 7 : 6;
               switch(param1.keyCode)
               {
                  case Keyboard.TAB:
                     _loc2_ = this.findSwatch(this._selectedColor);
                     this.setSwatchHighlight(_loc2_);
                     return;
                  case Keyboard.HOME:
                     this.currColIndex = this.currRowIndex = 0;
                     break;
                  case Keyboard.END:
                     this.currColIndex = this.swatchMap[this.swatchMap.length - 1].length - 1;
                     this.currRowIndex = this.swatchMap.length - 1;
                     break;
                  case Keyboard.PAGE_DOWN:
                     this.currRowIndex = this.swatchMap.length - 1;
                     break;
                  case Keyboard.PAGE_UP:
                     this.currRowIndex = 0;
                     break;
                  case Keyboard.ESCAPE:
                     if(this.isOpen)
                     {
                        this.selectedColor = this._selectedColor;
                     }
                     this.close();
                     return;
                  case Keyboard.ENTER:
                     return;
                  case Keyboard.UP:
                     this.currRowIndex = Math.max(-1,this.currRowIndex - 1);
                     if(this.currRowIndex == -1)
                     {
                        this.currRowIndex = this.swatchMap.length - 1;
                     }
                     break;
                  case Keyboard.DOWN:
                     this.currRowIndex = Math.min(this.swatchMap.length,this.currRowIndex + 1);
                     if(this.currRowIndex == this.swatchMap.length)
                     {
                        this.currRowIndex = 0;
                     }
                     break;
                  case Keyboard.RIGHT:
                     this.currColIndex = Math.min(this.swatchMap[this.currRowIndex].length,this.currColIndex + 1);
                     if(this.currColIndex == this.swatchMap[this.currRowIndex].length)
                     {
                        this.currColIndex = 0;
                        this.currRowIndex = Math.min(this.swatchMap.length,this.currRowIndex + 1);
                        if(this.currRowIndex == this.swatchMap.length)
                        {
                           this.currRowIndex = 0;
                        }
                     }
                     break;
                  case Keyboard.LEFT:
                     this.currColIndex = Math.max(-1,this.currColIndex - 1);
                     if(this.currColIndex == -1)
                     {
                        this.currColIndex = this.swatchMap[this.currRowIndex].length - 1;
                        this.currRowIndex = Math.max(-1,this.currRowIndex - 1);
                        if(this.currRowIndex == -1)
                        {
                           this.currRowIndex = this.swatchMap.length - 1;
                        }
                     }
                     break;
                  default:
                     return;
               }
               _loc3_ = this.swatchMap[this.currRowIndex][this.currColIndex].getChildByName("color").transform.colorTransform;
               this.rollOverColor = _loc3_.color;
               this.setColorWellColor(_loc3_);
               this.setSwatchHighlight(this.swatchMap[this.currRowIndex][this.currColIndex]);
               this.setColorText(_loc3_.color);
               return;
         }
      }
      
      override protected function configUI() : void
      {
         var _loc1_:uint = 0;
         super.configUI();
         tabChildren = false;
         if(ColorPicker.defaultColors == null)
         {
            ColorPicker.defaultColors = [];
            _loc1_ = 0;
            while(_loc1_ < 216)
            {
               ColorPicker.defaultColors.push(((_loc1_ / 6 % 3 << 0) + (_loc1_ / 108 << 0) * 3) * 51 << 16 | _loc1_ % 6 * 51 << 8 | (_loc1_ / 18 << 0) % 6 * 51);
               _loc1_++;
            }
         }
         this.colorHash = {};
         this.swatchMap = [];
         this.textField = new TextField();
         this.textField.tabEnabled = false;
         this.swatchButton = new BaseButton();
         this.swatchButton.focusEnabled = false;
         this.swatchButton.useHandCursor = false;
         this.swatchButton.autoRepeat = false;
         this.swatchButton.setSize(25,25);
         this.swatchButton.addEventListener(MouseEvent.CLICK,this.onPopupButtonClick,false,0,true);
         addChild(this.swatchButton);
         this.palette = new Sprite();
         this.palette.tabChildren = false;
         this.palette.cacheAsBitmap = true;
      }
   }
}
