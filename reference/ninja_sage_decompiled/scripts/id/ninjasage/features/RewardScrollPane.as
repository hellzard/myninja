package id.ninjasage.features
{
   import Managers.AppManager;
   import Managers.NinjaSage;
   import Storage.Character;
   import com.gestouch.events.GestureEvent;
   import com.gestouch.gestures.PanGesture;
   import com.utils.GF;
   import fl.containers.ScrollPane;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EventHandler;
   
   public class RewardScrollPane extends MovieClip
   {
       
      
      private var scrollPane;
      
      private var iconRewardList:Array;
      
      private var instanceEmpty:MovieClip;
      
      private var paneData:Object;
      
      private var panGesture:PanGesture;
      
      private var eventHandler:EventHandler;
      
      public function RewardScrollPane()
      {
         super();
         this.iconRewardList = [];
         this.scrollPane = new ScrollPane();
         this.instanceEmpty = new MovieClip();
         this.panGesture = new PanGesture(this.scrollPane);
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.panGesture,GestureEvent.GESTURE_CHANGED,this.onGestureChanged);
      }
      
      public function getRewardPane() : *
      {
         return this.scrollPane;
      }
      
      public function updateRewardPane(param1:Object) : void
      {
         var _loc7_:Class = null;
         var _loc8_:MovieClip = null;
         this.clearContent();
         this.paneData = param1;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.paneData.rewards.length)
         {
            _loc8_ = new (_loc7_ = getDefinitionByName("IconReward") as Class)();
            if(this.paneData.hasOwnProperty("scaleX") && this.paneData.scaleX != null)
            {
               _loc8_.icon.scaleX = this.paneData.scaleX;
            }
            if(this.paneData.hasOwnProperty("scaleY") && this.paneData.scaleY != null)
            {
               _loc8_.icon.scaleY = this.paneData.scaleY;
            }
            NinjaSage.loadItemIcon(_loc8_.icon,this.paneData.rewards[_loc4_]);
            _loc8_.icon.ownedTxt.visible = false;
            if(Character.hasSkill(this.paneData.rewards[_loc4_].split(":")[0]) > 0 || Character.isItemOwned(this.paneData.rewards[_loc4_].split(":")[0]) > 0)
            {
               _loc8_.icon.ownedTxt.visible = true;
               _loc8_.icon.ownedTxt.text = "Owned";
            }
            _loc8_.icon.amtTxt.visible = false;
            if(this.paneData.rewards[_loc4_].split(":")[1] > 1)
            {
               _loc8_.icon.amtTxt.visible = true;
               _loc8_.icon.amtTxt.text = "x" + this.paneData.rewards[_loc4_].split(":")[1];
            }
            _loc8_.icon.btn_preview.visible = this.checkIsItemOrSkill(this.paneData.rewards[_loc4_].split(":")[0]);
            _loc8_.icon.btn_preview.metaData = {"itemId":this.paneData.rewards[_loc4_].split(":")[0]};
            this.eventHandler.addListener(_loc8_.icon.btn_preview,MouseEvent.CLICK,AppManager.getInstance().main.openPreview);
            _loc8_.icon.x = _loc2_;
            _loc8_.icon.y = _loc3_;
            if(this.paneData.scroll_direction == "vertical")
            {
               _loc2_ += this.paneData.x;
               if((_loc4_ + 1) % this.paneData.item_per_line == 0)
               {
                  _loc2_ = 0;
                  _loc3_ += this.paneData.y;
               }
            }
            else
            {
               _loc3_ += this.paneData.y;
               if((_loc4_ + 1) % this.paneData.item_per_line == 0)
               {
                  _loc3_ = 0;
                  _loc2_ += this.paneData.x;
               }
            }
            this.iconRewardList.push(_loc8_);
            this.instanceEmpty.addChild(_loc8_.icon);
            _loc4_++;
         }
         var _loc5_:int = this.paneData.hasOwnProperty("width") && this.paneData.width != null ? int(this.paneData.width) : int(this.instanceEmpty.width + 20);
         var _loc6_:int = this.paneData.hasOwnProperty("height") && this.paneData.height != null ? int(this.paneData.height) : int(this.instanceEmpty.height + 20);
         this.scrollPane.setSize(_loc5_,_loc6_);
         this.scrollPane.horizontalScrollPolicy = this.paneData.hasOwnProperty("scroll_visible") && this.paneData.scroll_visible ? "auto" : this.paneData.scroll_visible;
         this.scrollPane.verticalScrollPolicy = this.paneData.hasOwnProperty("scroll_visible") && this.paneData.scroll_visible ? "auto" : this.paneData.scroll_visible;
         this.scrollPane.source = this.instanceEmpty;
         this.scrollPane.invalidate();
         this.scrollPane.refreshPane();
      }
      
      private function checkIsItemOrSkill(param1:String) : Boolean
      {
         var _loc2_:Array = ["skill_","hair_","set_","back_","wpn_"];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1.indexOf(_loc2_[_loc3_]) >= 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function clearContent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.iconRewardList.length)
         {
            GF.removeAllChild(this.iconRewardList[_loc1_].icon.rewardIcon.iconHolder);
            GF.removeAllChild(this.iconRewardList[_loc1_].icon.skillIcon.iconHolder);
            GF.removeAllChild(this.iconRewardList[_loc1_]);
            _loc1_++;
         }
         GF.removeAllChild(this.instanceEmpty);
         this.iconRewardList = [];
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
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         NinjaSage.clearLoader();
         this.clearContent();
         this.panGesture = null;
         this.scrollPane.source = null;
         this.scrollPane = null;
         this.instanceEmpty = null;
         this.iconRewardList = null;
         this.paneData = null;
      }
   }
}
