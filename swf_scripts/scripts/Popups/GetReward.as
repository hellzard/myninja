package Popups
{
   import Managers.NinjaSage;
   import NinjaSage_fla.getrewardbackground_1940;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.features.RewardScrollPane;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol10216")]
   public class GetReward extends MovieClip
   {
      
      public var backgroundMC:getrewardbackground_1940;
      
      public var bg:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_confirm:SimpleButton;
      
      public var rewardMC:MovieClip;
      
      public var txt_description:TextField;
      
      public var txt_title:TextField;
      
      public var scrollPaneHolder:MovieClip;
      
      public var rewardPane:RewardScrollPane;
      
      private var escapeKey:EscapeKeyManager;
      
      public function GetReward()
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePop);
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePop);
         this.bg.addEventListener(MouseEvent.CLICK,this.closePop);
         this.btn_confirm.addEventListener(MouseEvent.CLICK,this.closePop);
         this.rewardPane = new RewardScrollPane();
         this.scrollPaneHolder.addChild(this.rewardPane.getRewardPane());
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.rewardPane.destroy();
         this.rewardPane = null;
         this.btn_confirm.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePop);
         this.bg.removeEventListener(MouseEvent.CLICK,this.closePop);
         var _loc1_:int = 0;
         while(_loc1_ < this.rewardMC.currentFrame)
         {
            GF.removeAllChild(this.rewardMC["iconMC" + _loc1_].rewardIcon.iconHolder);
            GF.removeAllChild(this.rewardMC["iconMC" + _loc1_].skillIcon.iconHolder);
            _loc1_++;
         }
         NinjaSage.clearLoader();
         GF.removeAllChild(this);
         System.gc();
      }
      
      internal function closePop(param1:MouseEvent) : void
      {
         this.destroy();
      }
   }
}

