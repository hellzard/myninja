package id.ninjasage
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.system.System;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.getTimer;
   
   public class Stats extends Sprite
   {
      
      public static var displayed:* = false;
      
      protected const WIDTH:uint = 150;
      
      protected const HEIGHT:uint = 100;
      
      protected var xml:XML;
      
      protected var text:TextField;
      
      protected var style:StyleSheet;
      
      protected var timer:uint;
      
      protected var fps:uint;
      
      protected var ms:uint;
      
      protected var ms_prev:uint;
      
      protected var mem:Number;
      
      protected var mem_max:Number;
      
      protected var graph:BitmapData;
      
      protected var rectangle:Rectangle;
      
      protected var fps_graph:uint;
      
      protected var mem_graph:uint;
      
      protected var mem_max_graph:uint;
      
      protected var colors:Colors = new Colors();
      
      public function Stats(param1:*)
      {
         super();
         var _loc2_:ContextMenu = new ContextMenu();
         var _loc3_:* = new ContextMenuItem("Show Profiler",true);
         var _loc4_:* = new ContextMenuItem("Reset Preferences",true);
         _loc2_.customItems = [_loc3_,_loc4_];
         param1.contextMenu = _loc2_;
         _loc3_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onSelect,false,0,true);
         _loc4_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.clearSharedObject,false,0,true);
         param1 = null;
      }
      
      private function showStats() : *
      {
         if(displayed)
         {
            return;
         }
         displayed = true;
         this.init(null);
      }
      
      private function hideStats() : *
      {
         displayed = false;
         this.destroy(null);
      }
      
      public function onSelect(param1:*) : *
      {
         if(!displayed)
         {
            this.showStats();
         }
         else
         {
            this.hideStats();
         }
      }
      
      private function init(param1:Event) : void
      {
         this.mem_max = 0;
         this.xml = <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>;
         this.style = new StyleSheet();
         this.style.setStyle("xml",{
            "fontSize":"20px",
            "fontFamily":"_sans",
            "leading":"-2px"
         });
         this.style.setStyle("fps",{"color":this.hex2css(this.colors.fps)});
         this.style.setStyle("ms",{"color":this.hex2css(this.colors.ms)});
         this.style.setStyle("mem",{"color":this.hex2css(this.colors.mem)});
         this.style.setStyle("memMax",{"color":this.hex2css(this.colors.memmax)});
         this.text = new TextField();
         this.text.width = this.WIDTH;
         this.text.height = 100;
         this.text.styleSheet = this.style;
         this.text.condenseWhite = true;
         this.text.selectable = false;
         this.text.mouseEnabled = false;
         this.rectangle = new Rectangle(this.WIDTH - 1,0,1,this.HEIGHT - 50);
         graphics.beginFill(this.colors.bg);
         graphics.drawRect(0,0,this.WIDTH,this.HEIGHT);
         graphics.endFill();
         addChild(this.text);
         this.graph = new BitmapData(this.WIDTH,this.HEIGHT - 50,false,this.colors.bg);
         graphics.drawRect(0,50,this.WIDTH,this.HEIGHT - 50);
         addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function destroy(param1:Event) : void
      {
         graphics.clear();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         this.graph.dispose();
         removeEventListener(MouseEvent.CLICK,this.onClick);
         removeEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(param1:Event) : void
      {
         this.timer = getTimer();
         if(this.timer - 1000 > this.ms_prev)
         {
            this.ms_prev = this.timer;
            this.mem = Number((System.totalMemory * 9.54e-7).toFixed(3));
            this.mem_max = this.mem_max > this.mem ? this.mem_max : this.mem;
            this.fps_graph = Math.min(this.graph.height,this.fps / stage.frameRate * this.graph.height);
            this.mem_graph = Math.min(this.graph.height,Math.sqrt(Math.sqrt(this.mem * 5000))) - 2;
            this.mem_max_graph = Math.min(this.graph.height,Math.sqrt(Math.sqrt(this.mem_max * 5000))) - 2;
            this.graph.scroll(-1,0);
            this.graph.fillRect(this.rectangle,this.colors.bg);
            this.graph.setPixel(this.graph.width - 1,this.graph.height - this.fps_graph,this.colors.fps);
            this.graph.setPixel(this.graph.width - 1,this.graph.height - (this.timer - this.ms >> 1),this.colors.ms);
            this.graph.setPixel(this.graph.width - 1,this.graph.height - this.mem_graph,this.colors.mem);
            this.graph.setPixel(this.graph.width - 1,this.graph.height - this.mem_max_graph,this.colors.memmax);
            this.xml.fps = "FPS: " + this.fps + " / " + stage.frameRate;
            this.xml.mem = "MEM: " + this.mem;
            this.xml.memMax = "MAX: " + this.mem_max;
            this.fps = 0;
         }
         ++this.fps;
         this.xml.ms = "MS: " + (this.timer - this.ms);
         this.ms = this.timer;
         this.text.htmlText = this.xml;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(mouseY / height > 0.5)
         {
            --stage.frameRate;
         }
         else
         {
            ++stage.frameRate;
         }
         this.xml.fps = "FPS: " + this.fps + " / " + stage.frameRate;
         this.text.htmlText = this.xml;
      }
      
      private function hex2css(param1:int) : String
      {
         return "#" + param1.toString(16);
      }
      
      private function clearSharedObject(param1:*) : *
      {
         var _loc2_:* = SharedObject.getLocal("ninja_sage");
         _loc2_.clear();
         _loc2_.flush();
         _loc2_ = null;
      }
   }
}

class Colors
{
   
   public var bg:uint = 4294967295;
   
   public var fps:uint = 16776960;
   
   public var ms:uint = 16776960;
   
   public var mem:uint = 16776960;
   
   public var memmax:uint = 16776960;
   
   public function Colors()
   {
      super();
   }
}
