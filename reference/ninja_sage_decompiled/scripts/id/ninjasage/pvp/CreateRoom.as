package id.ninjasage.pvp
{
   import Managers.NinjaSage;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public class CreateRoom extends MovieClip
   {
       
      
      public var hintTxt:TextField;
      
      public var stageMC:MovieClip;
      
      public var titleTxt:TextField;
      
      public var version_txt:TextField;
      
      public var btn_close:SimpleButton;
      
      public var btn_create_room:SimpleButton;
      
      public var btn_next_mode:SimpleButton;
      
      public var btn_next_pets:SimpleButton;
      
      public var btn_next_scrolls:SimpleButton;
      
      public var btn_next_spectate:SimpleButton;
      
      public var btn_prev_mode:SimpleButton;
      
      public var btn_prev_pets:SimpleButton;
      
      public var btn_prev_scrolls:SimpleButton;
      
      public var btn_prev_spectate:SimpleButton;
      
      public var password:TextField;
      
      public var stage0:MovieClip;
      
      public var stage1:MovieClip;
      
      public var stage2:MovieClip;
      
      public var stage3:MovieClip;
      
      public var stage4:MovieClip;
      
      public var stage5:MovieClip;
      
      public var txt_allow_pets:TextField;
      
      public var txt_allow_scrolls:TextField;
      
      public var txt_allow_spectate:TextField;
      
      public var txt_battle_mode:TextField;
      
      private var selectedMission:String = "";
      
      private var currentPageBackground:int = 1;
      
      private var totalPageBackground:int = 1;
      
      private var eventHandler:EventHandler;
      
      private var pvp:PvP;
      
      private var missionIDs:Array;
      
      public function CreateRoom()
      {
         this.missionIDs = [];
         super();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this.stageMC["bg_" + _loc1_].bgContent.gotoAndStop(1);
            _loc1_++;
         }
         this.hidePanel();
         this.password.text = "";
         this.btn_prev_mode.visible = false;
         this.btn_next_mode.visible = false;
         this.eventHandler = new EventHandler();
      }
      
      public function setContext(param1:PvP) : void
      {
         this.pvp = param1;
      }
      
      public function btnHandler(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_prev_mode":
               break;
            case "btn_next_mode":
               break;
            case "btn_prev_spectate":
               this.txt_allow_spectate.text = "No";
               break;
            case "btn_next_spectate":
               this.txt_allow_spectate.text = "Yes";
               break;
            case "btn_prev_pets":
               this.txt_allow_pets.text = "No";
               break;
            case "btn_next_pets":
               this.txt_allow_pets.text = "Yes";
               break;
            case "btn_prev_scrolls":
               this.txt_allow_scrolls.text = "No";
               break;
            case "btn_next_scrolls":
               this.txt_allow_scrolls.text = "Yes";
         }
      }
      
      public function activate() : *
      {
         this.visible = true;
         this.eventHandler.addListener(this.btn_prev_pets,MouseEvent.CLICK,this.btnHandler);
         this.eventHandler.addListener(this.btn_next_pets,MouseEvent.CLICK,this.btnHandler);
         this.eventHandler.addListener(this.btn_prev_spectate,MouseEvent.CLICK,this.btnHandler);
         this.eventHandler.addListener(this.btn_next_spectate,MouseEvent.CLICK,this.btnHandler);
         this.eventHandler.addListener(this.btn_prev_scrolls,MouseEvent.CLICK,this.btnHandler);
         this.eventHandler.addListener(this.btn_next_scrolls,MouseEvent.CLICK,this.btnHandler);
         this.eventHandler.addListener(this.stageMC.btn_prev_bg,MouseEvent.CLICK,this.changePageBackground);
         this.eventHandler.addListener(this.stageMC.btn_next_bg,MouseEvent.CLICK,this.changePageBackground);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.hidePanel);
         this.eventHandler.addListener(this.btn_create_room,MouseEvent.CLICK,this.createRoom);
         this.txt_allow_spectate.text = "Yes";
         this.txt_allow_scrolls.text = "Yes";
         this.txt_allow_pets.text = "Yes";
         this.missionIDs = !!this.pvp ? this.pvp.getMissionIDs() : [];
         this.totalPageBackground = Math.max(Math.ceil(this.missionIDs.length / 6),1);
         this.currentPageBackground = 1;
         this.updatePageTextBackground();
         this.loadMissionsSwf();
         this.selectedMission = "";
      }
      
      public function loadMissionsSwf() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this.stageMC["bg_" + _loc1_].bgContent.gotoAndStop(1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageBackground - 1) * 6);
            this.stageMC["bg_" + _loc1_].bgContent.visible = false;
            if(this.missionIDs.length > _loc2_)
            {
               this.stageMC["bg_" + _loc1_].bgContent.visible = true;
               this.stageMC["bg_" + _loc1_].bgContent.bgHolder.scaleX = 0.36;
               this.stageMC["bg_" + _loc1_].bgContent.bgHolder.scaleY = 0.3;
               GF.removeAllChild(this.stageMC["bg_" + _loc1_].bgContent.bgHolder);
               NinjaSage.loadIconSWF("mission",this.missionIDs[_loc2_],this.stageMC["bg_" + _loc1_].bgContent.bgHolder,"BattleBG");
               this.stageMC["bg_" + _loc1_].bgContent.metaData = {"mission_id":this.missionIDs[_loc2_]};
               this.eventHandler.addListener(this.stageMC["bg_" + _loc1_].bgContent,MouseEvent.CLICK,this.selectMission);
            }
            _loc1_++;
         }
      }
      
      public function selectMission(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            this.stageMC["bg_" + _loc2_].bgContent.gotoAndStop(1);
            _loc2_++;
         }
         param1.currentTarget.gotoAndStop(2);
         this.selectedMission = param1.currentTarget.metaData.mission_id;
      }
      
      public function changePageBackground(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next_bg":
               if(this.totalPageBackground > this.currentPageBackground)
               {
                  ++this.currentPageBackground;
                  this.loadMissionsSwf();
               }
               break;
            case "btn_prev_bg":
               if(this.currentPageBackground > 1)
               {
                  --this.currentPageBackground;
                  this.loadMissionsSwf();
               }
         }
         this.updatePageTextBackground();
      }
      
      public function updatePageTextBackground() : void
      {
         this.stageMC.txt_page_bg.text = this.currentPageBackground + "/" + this.totalPageBackground;
      }
      
      public function hidePanel(param1:* = null) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            GF.removeAllChild(this.stageMC["bg_" + _loc2_].bgContent.bgHolder);
            _loc2_++;
         }
         this.visible = false;
      }
      
      public function createRoom(param1:MouseEvent) : *
      {
         if(this.selectedMission == "")
         {
            this.pvp.main.showMessage("Please select a stage.");
            return;
         }
         var _loc2_:String = this.txt_battle_mode.text;
         var _loc3_:String = _loc2_ && _loc2_.toLowerCase().indexOf("rank") >= 0 ? "ranked" : "casual";
         var _loc5_:* = (_loc4_ = this.password.text) && _loc4_.length > 0 ? _loc4_ : "";
         PvPSocket.getInstance().emit("Room.create",{
            "settings":{
               "stage":this.selectedMission,
               "mode":_loc3_,
               "allowPets":this.txt_allow_pets.text == "Yes",
               "allowScrolls":this.txt_allow_scrolls.text == "Yes",
               "allowSpectators":this.txt_allow_spectate.text == "Yes"
            },
            "password":_loc5_
         });
      }
      
      public function deactivate() : void
      {
         this.visible = false;
         this.hidePanel();
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
      }
      
      public function destroy() : *
      {
         Log.debug(this,"destroy");
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.missionIDs = [];
         this.currentPageBackground = 1;
         this.totalPageBackground = 1;
         GF.removeAllChild(this);
      }
   }
}
