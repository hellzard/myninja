package Managers
{
   import com.utils.GF;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLRequest;
   import id.ninjasage.EventHandler;
   
   public class NinjaLoader
   {
       
      
      var _parent = null;
      
      public var curr_loading = 0;
      
      public var total_to_load = 0;
      
      public var icons:Array;
      
      public var holder;
      
      public var lbl;
      
      public var path:String;
      
      public var frame_pass = 0;
      
      public var eventHandler;
      
      public var holders;
      
      public function NinjaLoader(param1:*)
      {
         this.holders = [];
         this.eventHandler = new EventHandler();
         super();
         this._parent = param1;
      }
      
      public function loadIcons(param1:Array, param2:*, param3:String, param4:String = "items", param5:int = 0) : *
      {
         this.curr_loading = param5;
         if(param5 != 0)
         {
            this.icons = [];
            this.icons.length = param5 + 1;
            this.icons[param5] = param1[0];
         }
         else
         {
            this.icons = param1;
         }
         this.holder = param2;
         this.path = param4;
         this.lbl = param3;
         this.startLoading();
      }
      
      public function startLoading() : *
      {
         var obj:* = undefined;
         obj = undefined;
         var loader:Loader = null;
         if(this.icons.length > this.curr_loading)
         {
            this.frame_pass = 0;
            if(this.lbl != "")
            {
               this.holder[this.lbl + this.curr_loading].visible = true;
               obj = this.holder[this.lbl + this.curr_loading];
            }
            else
            {
               obj = this.holder;
            }
            loader = new Loader();
            this.eventHandler.addListener(this._parent,Event.ENTER_FRAME,this.checkLoading);
            this.eventHandler.addListener(loader.contentLoaderInfo,Event.COMPLETE,function(param1:Event):*
            {
               item_completeIcon(param1,obj,path);
            },false,0,true);
            loader.load(new URLRequest(this.path + "/" + this.icons[this.curr_loading] + ".swf"));
         }
      }
      
      public function item_completeIcon(param1:*, param2:*, param3:*) : void
      {
         var _loc4_:Class = null;
         var _loc5_:* = new (_loc4_ = param1.target.applicationDomain.getDefinition("icon") as Class)();
         if(param3 == "skills")
         {
            if("holder" in param2)
            {
               param2.holder.addChild(_loc5_);
               ++this.curr_loading;
               this.startLoading();
               return;
            }
            if("skillIconMc" in param2)
            {
               if("iconHolder" in param2.skillIconMc)
               {
                  param2.skillIconMc.iconHolder.addChild(_loc5_);
               }
               else
               {
                  param2.skillIconMc.addChild(_loc5_);
               }
            }
            else if("iconMC" in param2)
            {
               if("iconHolder" in param2.iconMC)
               {
                  param2.iconMC.iconHolder.addChild(_loc5_);
               }
               else
               {
                  param2.iconMC.addChild(_loc5_);
               }
            }
            else if("iconMc" in param2)
            {
               if("iconHolder" in param2.iconMc)
               {
                  param2.iconMc.iconHolder.addChild(_loc5_);
               }
               else
               {
                  param2.iconMc.addChild(_loc5_);
               }
            }
            else if("skillIcon" in param2)
            {
               param2.skillIcon.iconHolder.addChild(_loc5_);
            }
            else if("iconHolder" in param2)
            {
               param2.iconHolder.addChild(_loc5_);
            }
         }
         else if("iconHolder" in param2)
         {
            param2.iconHolder.addChild(_loc5_);
         }
         else if("iconMc" in param2)
         {
            if("iconHolder" in param2.iconMc)
            {
               param2.iconMc.iconHolder.addChild(_loc5_);
            }
            else
            {
               param2.iconMc.addChild(_loc5_);
            }
         }
         else if("iconMC" in param2)
         {
            if("iconHolder" in param2.iconMC)
            {
               param2.iconMC.iconHolder.addChild(_loc5_);
            }
            else
            {
               param2.iconMC.addChild(_loc5_);
            }
         }
         else
         {
            param2.icon.iconHolder.addChild(_loc5_);
         }
         this.holders.push(param2);
         ++this.curr_loading;
         this.startLoading();
      }
      
      public function checkLoading(param1:Event) : *
      {
         ++this.frame_pass;
         if(this.frame_pass > 5)
         {
            this._parent.removeEventListener(Event.ENTER_FRAME,this.checkLoading);
            this.frame_pass = 0;
            this.startLoading();
         }
      }
      
      public function destroy() : *
      {
         var _loc1_:* = undefined;
         this.eventHandler.removeAllEventListeners();
         GF.clearArray(this.icons);
         for each(_loc1_ in this.holders)
         {
            GF.removeAllChild(_loc1_);
            _loc1_ = null;
         }
         GF.clearArray(this.holders);
         this.holder = null;
         this.holders = null;
         this.path = null;
         this.lbl = null;
         this.eventHandler = null;
         this._parent = null;
         this.icons = null;
      }
   }
}
