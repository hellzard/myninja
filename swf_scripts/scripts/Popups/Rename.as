package Popups
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2961")]
   public class Rename extends MovieClip
   {
      
      public var btn_close:SimpleButton;
      
      public var btn_rename:SimpleButton;
      
      public var btn_getBadge:SimpleButton;
      
      public var charHolder:MovieClip;
      
      public var buyItemMC:MovieClip;
      
      public var new_charname:TextField;
      
      public var txt_badges:TextField;
      
      public var amount:int = 1;
      
      public var price:int = 200;
      
      public var cost:int = 0;
      
      public var main:*;
      
      public var eventHandler:EventHandler;
      
      public var pop:Confirmation;
      
      private const MATERIAL_RENAME:String = "essential_01";
      
      public function Rename(param1:*)
      {
         super();
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.buyItemMC.visible = false;
         this.txt_badges.text = Character.getEssentialAmount(this.MATERIAL_RENAME);
         this.charHolder.addChild(this.main.getPlayerHead());
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.onClose);
         this.eventHandler.addListener(this.btn_rename,MouseEvent.CLICK,this.showConfirmation);
         this.eventHandler.addListener(this.btn_getBadge,MouseEvent.CLICK,this.buyItem);
      }
      
      public function buyItem(param1:MouseEvent) : *
      {
         this.buyItemMC.visible = true;
         this.eventHandler.addListener(this.buyItemMC.btnClose,MouseEvent.CLICK,this.closeBuy);
         this.eventHandler.addListener(this.buyItemMC.btnNext,MouseEvent.CLICK,this.changeAmount);
         this.eventHandler.addListener(this.buyItemMC.btnPrev,MouseEvent.CLICK,this.changeAmount);
         this.cost = this.price * this.amount;
         this.buyItemMC.numTxt.text = this.amount;
         this.buyItemMC.tokenCost.txt_token.text = this.cost;
         this.eventHandler.addListener(this.buyItemMC.buyBtn,MouseEvent.CLICK,this.buyBadge);
      }
      
      internal function closeBuy(param1:MouseEvent) : void
      {
         this.buyItemMC.visible = false;
         this.amount = 1;
      }
      
      internal function changeAmount(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         if(this.amount < 1 && _loc2_ != "btnNext")
         {
            return;
         }
         if(_loc2_ == "btnNext")
         {
            this.amount += 1;
         }
         else
         {
            --this.amount;
         }
         this.cost = this.price * this.amount;
         this.buyItemMC.numTxt.text = this.amount;
         this.buyItemMC.tokenCost.txt_token.text = this.cost;
         this.eventHandler.addListener(this.buyItemMC.buyBtn,MouseEvent.CLICK,this.buyBadge);
      }
      
      public function buyBadge(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.G1qj82TKIjdJ",[Character.sessionkey,Character.char_id,this.amount],this.onBuyBadge);
      }
      
      public function onBuyBadge(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.giveMessage(this.amount + " Rename Badge Succesfully Bought!");
            Character.account_tokens -= this.cost;
            Character.addEssentials(this.MATERIAL_RENAME,this.amount);
            this.txt_badges.text = Character.getEssentialAmount(this.MATERIAL_RENAME);
            this.main.HUD.setBasicData();
            this.closeBuy(null);
         }
         else
         {
            if(param1.status == 2)
            {
               this.main.giveMessage("You Don\'t Have Enough Token");
               return;
            }
            this.main.giveMessage(param1.error);
         }
      }
      
      public function showConfirmation(param1:MouseEvent) : *
      {
         var restore_amount:*;
         var event:MouseEvent = param1;
         var e:MouseEvent = event;
         if(this.new_charname.text == "")
         {
            this.main.getNotice("Nickname cannot be empty!");
            return;
         }
         this.pop = new Confirmation();
         restore_amount = Character.account_type == 0 ? "3 rename badges?" : "1 rename badges?";
         this.pop.txtMc.txt.text = "Are you sure that you want to change your nickname for " + restore_amount;
         this.eventHandler.addListener(this.pop.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(pop);
         });
         this.eventHandler.addListener(this.pop.btn_confirm,MouseEvent.CLICK,this.onRenameCharacterAMF);
         addChild(this.pop);
      }
      
      public function onRenameCharacterAMF(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.1KzvcYRhdZHk",[Character.sessionkey,Character.char_ids[Character.selected_char],this.new_charname.text],this.renameResponse);
      }
      
      public function renameResponse(param1:Object) : *
      {
         var _loc2_:int = 0;
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.getNotice(param1.result);
            Character.character_name = this.new_charname.text;
            _loc2_ = Character.account_type == 0 ? 3 : 1;
            Character.removeEssentials(this.MATERIAL_RENAME,_loc2_);
            this.main.HUD.loadFrame();
            this.main.HUD.setBasicData();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.onClose();
      }
      
      public function onClose(param1:MouseEvent = null) : *
      {
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.pop = null;
         this.main = null;
         GF.removeAllChild(this);
      }
   }
}

