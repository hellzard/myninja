package id.ninjasage.features
{
   import com.gestouch.events.GestureEvent;
   import com.gestouch.gestures.PanGesture;
   import com.utils.GF;
   import fl.containers.ScrollPane;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class HistoryScrollPane extends MovieClip
   {
      
      private var scrollPane:*;
      
      private var contentHolder:MovieClip;
      
      private var paneData:Object;
      
      private var panGesture:PanGesture;
      
      public function HistoryScrollPane()
      {
         super();
         this.scrollPane = new ScrollPane();
         this.contentHolder = new MovieClip();
         this.panGesture = new PanGesture(this.scrollPane);
         this.panGesture.addEventListener(GestureEvent.GESTURE_CHANGED,this.onGestureChanged);
      }
      
      public function getScrollPane() : *
      {
         return this.scrollPane;
      }
      
      public function updatePane(param1:Object) : void
      {
         this.clearContent();
         this.paneData = param1;
         var _loc2_:Number = this.paneData.hasOwnProperty("text_width") ? Number(this.paneData.text_width) : 280;
         var _loc3_:Number = this.paneData.hasOwnProperty("x") ? Number(this.paneData.x) : 0;
         var _loc4_:Number = this.paneData.hasOwnProperty("y") ? Number(this.paneData.y) : 0;
         var _loc5_:TextFormat = this.paneData.hasOwnProperty("defaultFormat") && this.paneData.defaultFormat != null ? this.paneData.defaultFormat as TextFormat : this.createDefaultTextFormat();
         var _loc6_:Array = [];
         if(this.paneData.hasOwnProperty("history_raw"))
         {
            _loc6_ = this.buildLinesFromHistoryRaw(String(this.paneData.history_raw),_loc5_);
         }
         else if(this.paneData.hasOwnProperty("lines") && this.paneData.lines != null)
         {
            _loc6_ = this.paneData.lines as Array;
         }
         var _loc7_:Number = _loc4_;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:TextFormat = null;
         var _loc12_:Number = NaN;
         var _loc13_:TextField = null;
         _loc8_ = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = _loc6_[_loc8_] as Object;
            if(_loc9_ != null)
            {
               _loc10_ = _loc9_.hasOwnProperty("text") ? String(_loc9_.text) : "";
               _loc12_ = _loc9_.hasOwnProperty("marginAfter") ? Number(_loc9_.marginAfter) : 4;
               if(!_loc10_.length)
               {
                  if(!isNaN(_loc12_) && _loc12_ > 0)
                  {
                     _loc7_ += _loc12_;
                  }
               }
               else
               {
                  _loc11_ = _loc9_.hasOwnProperty("format") && _loc9_.format != null ? _loc9_.format as TextFormat : _loc5_;
                  _loc13_ = new TextField();
                  _loc13_.type = TextFieldType.DYNAMIC;
                  _loc13_.multiline = true;
                  _loc13_.wordWrap = true;
                  _loc13_.selectable = true;
                  _loc13_.mouseEnabled = true;
                  _loc13_.autoSize = TextFieldAutoSize.NONE;
                  _loc13_.embedFonts = false;
                  _loc13_.defaultTextFormat = _loc11_;
                  _loc13_.text = _loc10_;
                  _loc13_.setTextFormat(_loc11_);
                  _loc13_.width = _loc2_;
                  _loc13_.height = Math.max(_loc13_.textHeight + 6,18);
                  _loc13_.x = _loc3_;
                  _loc13_.y = _loc7_;
                  _loc7_ += _loc13_.height + (isNaN(_loc12_) ? 4 : _loc12_);
                  this.contentHolder.addChild(_loc13_);
               }
            }
            _loc8_++;
         }
         var _loc14_:Number = this.paneData.hasOwnProperty("width") && this.paneData.width != null ? Number(this.paneData.width) : Number(_loc3_ + _loc2_ + 20);
         var _loc15_:Number = this.paneData.hasOwnProperty("height") && this.paneData.height != null ? Number(this.paneData.height) : 400;
         this.scrollPane.setSize(_loc14_,_loc15_);
         var _loc16_:Boolean = this.paneData.hasOwnProperty("scroll_visible") && Boolean(this.paneData.scroll_visible);
         this.scrollPane.horizontalScrollPolicy = _loc16_ ? "auto" : "off";
         this.scrollPane.verticalScrollPolicy = _loc16_ ? "auto" : "off";
         this.scrollPane.source = this.contentHolder;
         this.scrollPane.invalidate();
         this.scrollPane.refreshPane();
      }
      
      private function createDefaultTextFormat() : TextFormat
      {
         return new TextFormat("_sans",12,16777215,false,false,false);
      }
      
      private function copyFormatWithColor(param1:TextFormat, param2:uint) : TextFormat
      {
         return new TextFormat(param1.font,param1.size,param2,param1.bold,param1.italic,param1.underline,param1.url,param1.target,param1.align,param1.leftMargin,param1.rightMargin,param1.indent,param1.leading);
      }
      
      private function neutralColor(param1:TextFormat) : uint
      {
         return param1.color != null ? uint(param1.color) : 16777215;
      }
      
      private function buildLinesFromHistoryRaw(param1:String, param2:TextFormat) : Array
      {
         var _loc3_:Array = [];
         if(param1 == null || !String(param1).length)
         {
            return _loc3_;
         }
         var _loc4_:RegExp = /<br\s*\/?>/gi;
         var _loc5_:Array = String(param1).split(_loc4_);
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:RegExp = /^\[([^\]]+)\]\s*(.*)$/;
         var _loc10_:TextFormat = null;
         var _loc11_:String = null;
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = String(_loc5_[_loc6_]).replace(/^\s+|\s+$/g,"");
            if(_loc7_.length)
            {
               _loc8_ = _loc7_.match(_loc9_);
               if(_loc8_)
               {
                  _loc3_.push({
                     "text":"[" + _loc8_[1] + "]",
                     "format":param2,
                     "marginAfter":2
                  });
                  _loc11_ = String(_loc8_[2]);
                  _loc10_ = this.textFormatForHistoryDescription(_loc11_,param2);
                  _loc3_.push({
                     "text":_loc11_,
                     "format":_loc10_,
                     "marginAfter":14
                  });
               }
               else
               {
                  _loc10_ = this.textFormatForHistoryDescription(_loc7_,param2);
                  _loc3_.push({
                     "text":_loc7_,
                     "format":_loc10_,
                     "marginAfter":14
                  });
               }
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      private function textFormatForHistoryDescription(param1:String, param2:TextFormat) : TextFormat
      {
         var _loc3_:Array = param1.match(/\bgained\s+([+-]?\d+)\s+reps/i);
         if(_loc3_)
         {
            return this.textFormatForSignedHighlight(int(_loc3_[1]),param2);
         }
         var _loc4_:Array = param1.match(/\bdealt\s+([+-]?\d+)\s+damage/i);
         if(_loc4_)
         {
            return this.textFormatForSignedHighlight(int(_loc4_[1]),param2);
         }
         if(/\blost\s+\d+\s+reps/i.test(param1))
         {
            return this.copyFormatWithColor(param2,16737894);
         }
         return this.copyFormatWithColor(param2,this.neutralColor(param2));
      }
      
      private function textFormatForSignedHighlight(param1:int, param2:TextFormat) : TextFormat
      {
         var _loc3_:uint = 6750054;
         var _loc4_:uint = 16737894;
         if(param1 > 0)
         {
            return this.copyFormatWithColor(param2,_loc3_);
         }
         if(param1 < 0)
         {
            return this.copyFormatWithColor(param2,_loc4_);
         }
         return this.copyFormatWithColor(param2,this.neutralColor(param2));
      }
      
      private function clearContent() : void
      {
         GF.removeAllChild(this.contentHolder);
         this.paneData = {};
      }
      
      private function onGestureChanged(param1:GestureEvent) : void
      {
         var _loc2_:PanGesture = PanGesture(param1.target);
         this.scrollPane.verticalScrollPosition -= _loc2_.offsetY;
         this.scrollPane.horizontalScrollPosition -= _loc2_.offsetX;
      }
      
      public function destroy() : void
      {
         if(this.panGesture != null)
         {
            this.panGesture.removeEventListener(GestureEvent.GESTURE_CHANGED,this.onGestureChanged);
         }
         this.clearContent();
         this.panGesture = null;
         this.scrollPane.source = null;
         this.scrollPane = null;
         this.contentHolder = null;
         this.paneData = null;
      }
   }
}

