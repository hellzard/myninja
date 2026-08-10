package Popups
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.features.LinkMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3390")]
   public class Scroll_Arena extends MovieClip
   {
      
      public var bg:MovieClip;
      
      public var btn_Arena:SimpleButton;
      
      public var btn_Pvp:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var main:*;
      
      public var eventHandler:*;
      
      private var escapeKey:EscapeKeyManager;
      
      public function Scroll_Arena(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel,false,0,true);
         this.eventHandler.addListener(this.bg,MouseEvent.CLICK,this.closePanel,false,0,true);
         if(Character.features.indexOf("pvp") > -1)
         {
            this.applyColorEffect(this.btn_Pvp,1,1,1);
            this.eventHandler.addListener(this.btn_Pvp,MouseEvent.CLICK,this.openSwfPanel,false,0,true);
         }
         this.applyColorEffect(this.btn_Arena,1,1,1);
         this.eventHandler.addListener(this.btn_Arena,MouseEvent.CLICK,this.openShadowWar,false,0,true);
      }
      
      public function openShadowWar(param1:MouseEvent) : *
      {
         LinkMenu.open(LinkMenu.ShadowWar);
         this.closePanel(param1);
      }
      
      public function onSeasonChecked(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.shadow_war_season = param1;
            if(param1.active)
            {
               this.main.loadExternalSwfPanel("ArenaVillage","ArenaVillage");
               this.destroy();
            }
            else
            {
               this.main.getNotice("No active season");
            }
         }
         else if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function openSwfPanel(param1:MouseEvent) : void
      {
         LinkMenu.open(LinkMenu.PvP);
         this.destroy();
      }
      
      public function applyColorEffect(param1:SimpleButton, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:ColorTransform = new ColorTransform(1,1,1,1,param2,param3,param4,0);
         param1.transform.colorTransform = _loc5_;
      }
      
      internal function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         GF.removeAllChild(this);
      }
      
      internal function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
         parent.removeChild(this);
      }
   }
}

