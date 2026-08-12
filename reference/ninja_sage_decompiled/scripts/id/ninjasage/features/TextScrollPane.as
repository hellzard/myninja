package id.ninjasage.features
{
   import com.gestouch.events.GestureEvent;
   import com.gestouch.gestures.PanGesture;
   import com.utils.GF;
   import fl.containers.ScrollPane;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class TextScrollPane extends MovieClip
   {
       
      
      private var scrollPane;
      
      private var contentHolder:MovieClip;
      
      private var paneData:Object;
      
      private var panGesture:PanGesture;
      
      private var glowFilter;
      
      private var linkTextFields:Array;
      
      private var linkUrls:Object;
      
      public function TextScrollPane()
      {
         super();
         this.scrollPane = new ScrollPane();
         this.contentHolder = new MovieClip();
         this.linkTextFields = [];
         this.linkUrls = {};
         this.panGesture = new PanGesture(this.scrollPane);
         this.panGesture.addEventListener(GestureEvent.GESTURE_CHANGED,this.onGestureChanged);
         this.glowFilter = new GlowFilter(0,1,3,3,17,BitmapFilterQuality.HIGH);
      }
      
      public function getScrollPane() : *
      {
         return this.scrollPane;
      }
      
      public function updatePane(param1:Object) : void
      {
         var _loc19_:TextField = null;
         var _loc20_:Object = null;
         var _loc21_:uint = 0;
         var _loc22_:TextFormat = null;
         var _loc23_:TextField = null;
         this.clearContent();
         this.paneData = param1;
         var _loc2_:String = !!this.paneData.hasOwnProperty("text") ? String(this.paneData.text) : "";
         var _loc3_:Number = !!this.paneData.hasOwnProperty("text_width") ? Number(Number(this.paneData.text_width)) : Number(280);
         var _loc4_:Number = !!this.paneData.hasOwnProperty("height") ? Number(Number(this.paneData.height)) : Number(400);
         var _loc5_:Number = !!this.paneData.hasOwnProperty("font_size") ? Number(Number(this.paneData.font_size)) : Number(12);
         var _loc6_:String = !!this.paneData.hasOwnProperty("font_name") ? String(this.paneData.font_name) : "_sans";
         var _loc7_:uint = !!this.paneData.hasOwnProperty("font_color") ? uint(uint(this.paneData.font_color)) : uint(16777215);
         var _loc8_:String = !!this.paneData.hasOwnProperty("align") ? String(this.paneData.align) : "left";
         var _loc9_:Number = !!this.paneData.hasOwnProperty("x") ? Number(Number(this.paneData.x)) : Number(0);
         var _loc10_:Number = !!this.paneData.hasOwnProperty("y") ? Number(Number(this.paneData.y)) : Number(0);
         var _loc11_:String = !!this.paneData.hasOwnProperty("scroll_visible") ? String(this.paneData.scroll_visible) : "off";
         var _loc12_:TextFormat;
         (_loc12_ = new TextFormat(_loc6_,_loc5_,_loc7_,false,false,false)).align = _loc8_;
         var _loc13_:Object;
         var _loc14_:String = (_loc13_ = this.parseLinks(_loc2_)).bodyText;
         var _loc15_:Array = _loc13_.links;
         var _loc16_:Number = _loc10_;
         if(_loc14_.length > 0)
         {
            (_loc19_ = this.createBaseTextField(_loc3_)).defaultTextFormat = _loc12_;
            _loc19_.htmlText = _loc14_;
            _loc19_.setTextFormat(_loc12_);
            _loc19_.height = Math.max(_loc19_.textHeight + 6,18);
            _loc19_.x = _loc9_;
            _loc19_.y = _loc16_;
            _loc19_.filters = [this.glowFilter];
            this.contentHolder.addChild(_loc19_);
            _loc16_ += _loc19_.height + 4;
         }
         var _loc17_:int = 0;
         while(_loc17_ < _loc15_.length)
         {
            _loc21_ = (_loc20_ = _loc15_[_loc17_]).color != null ? uint(uint(_loc20_.color)) : uint(_loc7_);
            (_loc22_ = new TextFormat(_loc6_,_loc5_,_loc21_,_loc20_.bold,_loc20_.italic,_loc20_.underline)).align = _loc8_;
            (_loc23_ = this.createBaseTextField(_loc3_)).selectable = false;
            _loc23_.defaultTextFormat = _loc22_;
            _loc23_.text = _loc20_.text;
            _loc23_.name = "link_" + _loc17_;
            _loc23_.height = Math.max(_loc23_.textHeight + 6,18);
            _loc23_.x = _loc9_;
            _loc23_.y = _loc16_;
            _loc23_.filters = [this.glowFilter];
            this.linkUrls[_loc23_.name] = _loc20_.href;
            _loc23_.addEventListener(MouseEvent.CLICK,this.onLinkClick);
            this.linkTextFields.push(_loc23_);
            this.contentHolder.addChild(_loc23_);
            _loc16_ += _loc23_.height + 2;
            _loc17_++;
         }
         var _loc18_:Number = this.paneData.hasOwnProperty("width") && this.paneData.width != null ? Number(Number(this.paneData.width)) : Number(Number(_loc9_ + _loc3_ + 20));
         this.scrollPane.setSize(_loc18_,_loc4_);
         this.scrollPane.horizontalScrollPolicy = _loc11_;
         this.scrollPane.verticalScrollPolicy = _loc11_;
         this.scrollPane.source = this.contentHolder;
         this.scrollPane.invalidate();
         this.scrollPane.refreshPane();
      }
      
      private function createBaseTextField(param1:Number) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.type = TextFieldType.DYNAMIC;
         _loc2_.multiline = true;
         _loc2_.wordWrap = true;
         _loc2_.selectable = true;
         _loc2_.mouseEnabled = true;
         _loc2_.autoSize = TextFieldAutoSize.NONE;
         _loc2_.embedFonts = true;
         _loc2_.antiAliasType = AntiAliasType.ADVANCED;
         _loc2_.gridFitType = GridFitType.SUBPIXEL;
         _loc2_.width = param1;
         return _loc2_;
      }
      
      private function parseLinks(param1:String) : Object
      {
         var _loc4_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:* = undefined;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc2_:Array = [];
         var _loc3_:RegExp = /((?:<[biu]>\s*)*)<a\s+([^>]*)>([\s\S]*?)<\/a>((?:\s*<\/[biu]>)*)/gi;
         var _loc5_:String = param1;
         while((_loc4_ = _loc3_.exec(param1)) != null)
         {
            _loc6_ = String(_loc4_[1]);
            _loc7_ = String(_loc4_[2]);
            _loc8_ = this.stripTags(String(_loc4_[3]));
            _loc9_ = String(_loc4_[4]);
            if((_loc11_ = !!(_loc10_ = _loc7_.match(/href\s*=\s*['"]([^'"]+)['"]/i)) ? String(_loc10_[1]) : "").indexOf("event:") == 0)
            {
               _loc11_ = _loc11_.substr(6);
            }
            _loc12_ = null;
            if(_loc13_ = _loc7_.match(/style\s*=\s*['"]([^'"]+)['"]/i))
            {
               if(_loc14_ = String(_loc13_[1]).match(/color\s*:\s*([^;]+)/i))
               {
                  _loc12_ = this.parseColor(String(_loc14_[1]).replace(/^\s+|\s+$/g,""));
               }
            }
            _loc2_.push({
               "href":_loc11_,
               "text":_loc8_,
               "bold":_loc6_.indexOf("<b>") >= 0,
               "underline":true,
               "italic":_loc6_.indexOf("<i>") >= 0,
               "color":_loc12_
            });
            _loc5_ = _loc5_.replace(_loc4_[0],"");
         }
         _loc5_ = _loc5_.replace(/^\s+|\s+$/g,"");
         return {
            "bodyText":_loc5_,
            "links":_loc2_
         };
      }
      
      private function parseColor(param1:String) : uint
      {
         param1 = param1.toLowerCase();
         switch(param1)
         {
            case "blue":
               return 3381759;
            case "red":
               return 16724787;
            case "green":
               return 3407667;
            case "yellow":
               return 16776960;
            case "white":
               return 16777215;
            case "cyan":
               return 65535;
            case "orange":
               return 16750848;
            case "purple":
               return 10040319;
            case "pink":
               return 16737996;
            default:
               if(param1.charAt(0) == "#")
               {
                  return uint("0x" + param1.substr(1));
               }
               if(param1.indexOf("0x") == 0)
               {
                  return uint(param1);
               }
               return 3381759;
         }
      }
      
      private function stripTags(param1:String) : String
      {
         return param1.replace(/<[^>]+>/g,"");
      }
      
      private function onLinkClick(param1:MouseEvent) : void
      {
         var _loc2_:TextField = param1.currentTarget as TextField;
         var _loc3_:String = this.linkUrls[_loc2_.name];
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_.indexOf("http://") != 0 && _loc3_.indexOf("https://") != 0)
         {
            _loc3_ = "https://" + _loc3_;
         }
         navigateToURL(new URLRequest(_loc3_),"_blank");
      }
      
      private function clearContent() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.linkTextFields.length)
         {
            this.linkTextFields[_loc1_].removeEventListener(MouseEvent.CLICK,this.onLinkClick);
            _loc1_++;
         }
         this.linkTextFields = [];
         this.linkUrls = {};
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
         this.scrollPane.horizontalScrollPolicy = "off";
         this.scrollPane.verticalScrollPolicy = "off";
         this.scrollPane.invalidate();
         this.scrollPane.refreshPane();
         if(this.panGesture != null)
         {
            this.panGesture.removeEventListener(GestureEvent.GESTURE_CHANGED,this.onGestureChanged);
         }
         this.clearContent();
         this.panGesture = null;
         this.glowFilter = null;
         this.linkTextFields = null;
         this.linkUrls = null;
         this.scrollPane.source = null;
         this.scrollPane = null;
         this.contentHolder = null;
         this.paneData = null;
      }
   }
}
