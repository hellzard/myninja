package Managers
{
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6017")]
   public class ErrorManager extends MovieClip
   {
      
      public var btn_refresh:SimpleButton;
      
      public var errorCode:TextField;
      
      public var errorMsg:TextField;
      
      public var errorTitle:TextField;
      
      public var main:*;
      
      public function ErrorManager(param1:*)
      {
         super();
         this.main = param1;
         this.btn_refresh.addEventListener(MouseEvent.CLICK,this.logout);
      }
      
      public function errorInfo(param1:String = "2000") : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         switch(param1)
         {
            case "110":
               _loc2_ = "Maintenance";
               _loc3_ = "The game is currently under maintenance.";
               break;
            case "1100":
               _loc2_ = "Banned";
               _loc3_ = "Your account has been banned due to hacking activities detected. Please reach out to support.";
               break;
            case "282":
               _loc2_ = "Invalid Equipped Gear";
               _loc3_ = "You have equipped an item you don\'t have permission for.";
               break;
            case "269":
               _loc2_ = "Item Not Sellable";
               _loc3_ = "The item you are attempting to sell cannot be sold.";
               break;
            case "230":
               _loc2_ = "Invalid Sell Quantity";
               _loc3_ = "You are trying to sell more items than you have in your inventory.";
               break;
            case "230":
               _loc2_ = "Invalid Sell Quantity";
               _loc3_ = "You are trying to sell more items than you have in your inventory.";
               break;
            case "918":
               _loc2_ = "Invalid Talent";
               _loc3_ = "The talent you are trying to learn does not exist.";
               break;
            case "666":
               _loc2_ = "Account Problem";
               _loc3_ = "Oops! Something Went Wrong Error. Please relogin your account. If this common occur, please reach out the contact support";
               break;
            default:
               _loc2_ = "Connection Error";
               _loc3_ = "You have disconnected from the server.";
         }
         this.errorTitle.text = _loc2_;
         this.errorMsg.text = _loc3_;
         this.errorCode.text = "Error Code: " + param1;
      }
      
      internal function logout(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         this.btn_refresh.removeEventListener(MouseEvent.CLICK,this.logout);
         this.main.removeAllChildsFromLoader();
         this.main.removeAllLoadedPanels();
         this.main.loadPanel("Managers.LoginManager");
         for each(_loc2_ in ["combat","assets","skills","specialclass","talents","panels","etc"])
         {
            BulkLoader.getLoader(_loc2_).removeAll();
         }
         if(Boolean(this.main) && this.main.combat != null)
         {
            this.main.combat.destroy();
            this.main.combat = null;
         }
         GF.removeAllChild(this);
         System.gc();
         this.main = null;
      }
   }
}

