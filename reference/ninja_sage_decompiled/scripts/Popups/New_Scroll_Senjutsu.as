package Popups
{
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class New_Scroll_Senjutsu extends MovieClip
   {
       
      
      public var title:TextField;
      
      public var txt:TextField;
      
      public var bg:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_SenjutsuSkillShop:SimpleButton;
      
      public var btn_SenjutsuShop:SimpleButton;
      
      public var btn_equip:SimpleButton;
      
      public var btn_upgrade:SimpleButton;
      
      public var main;
      
      public var loader:BulkLoader;
      
      public var eventHandler:EventHandler;
      
      private var escapeKey:EscapeKeyManager;
      
      public var loadedSenjutsuProfile;
      
      public function New_Scroll_Senjutsu(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.loader = BulkLoader.getLoader("assets");
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel,false,0,true);
         this.eventHandler.addListener(this.bg,MouseEvent.CLICK,this.closePanel,false,0,true);
         this.eventHandler.addListener(this.btn_SenjutsuShop,MouseEvent.CLICK,this.openSwfPanel,false,0,true);
         this.eventHandler.addListener(this.btn_SenjutsuSkillShop,MouseEvent.CLICK,this.openSwfPanel,false,0,true);
         this.eventHandler.addListener(this.btn_equip,MouseEvent.CLICK,this.openSwfPanel,false,0,true);
         this.applyColorEffect(this.btn_equip,1,1,1);
         if(Character.character_senjutsu != null)
         {
            this.applyColorEffect(this.btn_upgrade,1,1,1);
            this.eventHandler.addListener(this.btn_upgrade,MouseEvent.CLICK,this.openSwfPanel,false,0,true);
         }
      }
      
      public function openSwfPanel(param1:MouseEvent) : void
      {
         var btn:* = undefined;
         var loadItem:* = undefined;
         var e:MouseEvent = param1;
         btn = e.currentTarget.name.replace("btn_","");
         if(btn == "SenjutsuShop")
         {
            this.main.loadExternalSwfPanel("SenjutsuShop","SenjutsuShop");
            this.destroy();
         }
         else if(btn == "SenjutsuSkillShop")
         {
            this.main.loadExternalSwfPanel(btn,btn);
            this.destroy();
         }
         else
         {
            loadItem = this.loader.add("swfpanels/SenjutsuProfile.swf");
            loadItem.addEventListener(BulkLoader.COMPLETE,function(param1:Event):*
            {
               onSwfPanelLoaded(param1,btn);
            });
            this.loader.start();
         }
      }
      
      public function onSwfPanelLoaded(param1:Event, param2:String) : *
      {
         var _loc3_:* = param1.target.content;
         var _loc4_:Class = getDefinitionByName("id.ninjasage.features.SenjutsuProfile") as Class;
         this.loadedSenjutsuProfile = new _loc4_(this.main,_loc3_,param2);
         this.main.loader.addChild(_loc3_);
         this.destroy();
      }
      
      public function applyColorEffect(param1:SimpleButton, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:ColorTransform = new ColorTransform(1,1,1,1,param2,param3,param4,0);
         param1.transform.colorTransform = _loc5_;
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.eventHandler.removeAllEventListeners();
         this.loader.removeAll();
         this.main = null;
         this.eventHandler = null;
         this.loadedSenjutsuProfile = null;
         this.loader = null;
         GF.removeAllChild(this);
      }
      
      public function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
   }
}
