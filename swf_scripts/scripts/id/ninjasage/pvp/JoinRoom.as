package id.ninjasage.pvp
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8790")]
   public class JoinRoom extends MovieClip
   {
      
      public var titleTxt:TextField;
      
      public var btn_close:SimpleButton;
      
      public var btn_join_room:SimpleButton;
      
      public var btn_spectate_room:SimpleButton;
      
      public var password:TextField;
      
      public var roomId:TextField;
      
      private var eventHandler:*;
      
      private var pvp:PvP;
      
      public function JoinRoom()
      {
         super();
         this.eventHandler = new EventHandler();
      }
      
      public function setContext(param1:PvP) : void
      {
         this.pvp = param1;
      }
      
      public function initUI() : *
      {
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_join_room,MouseEvent.CLICK,this.joinRoom);
         this.eventHandler.addListener(this.btn_spectate_room,MouseEvent.CLICK,this.spectateRoom);
         this.roomId.text = "";
         this.password.text = "";
         this.btn_close.visible = true;
         this.btn_join_room.visible = true;
         this.btn_spectate_room.visible = true;
      }
      
      public function spectateRoom(param1:MouseEvent) : *
      {
         if(this.roomId.text == "")
         {
            this.pvp.main.showMessage("Room ID is required.");
            return;
         }
         this.pvp.main.loading(true);
         PvPSocket.getInstance().emit("Battle.spectator.join",{
            "roomId":this.roomId.text,
            "password":this.password.text
         });
      }
      
      public function joinRoom(param1:MouseEvent) : *
      {
         if(this.roomId.text == "")
         {
            this.pvp.main.showMessage("Room ID is required.");
            return;
         }
         PvPSocket.getInstance().emit("Room.join",{
            "id":this.roomId.text,
            "password":this.password.text
         });
      }
      
      public function activate() : *
      {
         this.visible = true;
         this.initUI();
      }
      
      public function deactivate() : void
      {
         this.visible = false;
         this.eventHandler.removeAllEventListeners();
      }
      
      public function closePanel(param1:MouseEvent = null) : *
      {
         this.deactivate();
      }
      
      public function destroy() : *
      {
         Log.debug(this,"destroyed");
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
         }
         this.eventHandler = null;
         this.pvp = null;
      }
   }
}

