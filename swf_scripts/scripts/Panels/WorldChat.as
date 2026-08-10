package Panels
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   import id.ninjasage.features.RealtimeChat;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1231")]
   public dynamic class WorldChat extends RealtimeChat
   {
      
      public var btn_back:SimpleButton;
      
      public var btn_clancht:SimpleButton;
      
      public var btn_globalcht:SimpleButton;
      
      public var discordChannel:SimpleButton;
      
      public var facebookGroup:SimpleButton;
      
      public var facebookPage:SimpleButton;
      
      protected var chatBoxMc:MovieClip;
      
      protected var closeChat:MovieClip;
      
      protected var offlineIcon:MovieClip;
      
      protected var onlineIcon:MovieClip;
      
      protected var chatScrollPane:*;
      
      protected var chatType:String;
      
      public function WorldChat(param1:* = null, param2:* = "global")
      {
         super(param1);
         this.chatType = param2;
         this.x -= this.width;
         TweenLite.to(this,0.5,{
            "x":0,
            "ease":"easeOutBack",
            "onComplete":super.init
         });
      }
      
      override public function show() : *
      {
         super.show();
         TweenLite.to(this,0.5,{
            "x":0,
            "ease":"easeOutBack"
         });
      }
      
      override public function closeChatPanel(param1:MouseEvent = null) : *
      {
         TweenLite.to(this,0.5,{
            "x":-this.width,
            "onComplete":this.onChatAnimationFinish
         });
      }
      
      private function onChatAnimationFinish() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         super.closeChatPanel();
      }
      
      override public function destroy() : *
      {
         TweenLite.killTweensOf(this);
         super.destroy();
      }
      
      override protected function getSocketAddress() : *
      {
         var _loc1_:* = this.scheme + "://ws.ninjasage.id/";
         var _loc2_:* = "";
         if(this.chatType == "clan")
         {
            _loc2_ = "clan-chat";
         }
         else if(this.chatType == "global")
         {
            _loc2_ = "global-chat";
         }
         return _loc1_ + _loc2_;
      }
   }
}

