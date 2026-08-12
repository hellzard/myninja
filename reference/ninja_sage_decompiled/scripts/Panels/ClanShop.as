package Panels
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.features.BaseShop;
   
   public dynamic class ClanShop extends BaseShop
   {
       
      
      public var btn_ClanItemUpgrade:SimpleButton;
      
      public var btn_clear:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var buyGold:SimpleButton;
      
      public var char_mc:MovieClip;
      
      public var currencyType:MovieClip;
      
      public var item_0:MovieClip;
      
      public var item_1:MovieClip;
      
      public var item_10:MovieClip;
      
      public var item_11:MovieClip;
      
      public var item_12:MovieClip;
      
      public var item_13:MovieClip;
      
      public var item_14:MovieClip;
      
      public var item_2:MovieClip;
      
      public var item_3:MovieClip;
      
      public var item_4:MovieClip;
      
      public var item_5:MovieClip;
      
      public var item_6:MovieClip;
      
      public var item_7:MovieClip;
      
      public var item_8:MovieClip;
      
      public var item_9:MovieClip;
      
      public var mcAccessory:MovieClip;
      
      public var mcBackItem:MovieClip;
      
      public var mcEssentials:MovieClip;
      
      public var mcHairstyle:MovieClip;
      
      public var mcItems:MovieClip;
      
      public var mcSet:MovieClip;
      
      public var mcSkill:MovieClip;
      
      public var mcWeapon:MovieClip;
      
      public var popup:MovieClip;
      
      public var txt_gold:TextField;
      
      public var txt_page:TextField;
      
      public function ClanShop(param1:*)
      {
         var main:* = param1;
         super(main);
         this.hideMovieclips();
         this.initShopData("clan");
         this.eventHandler.addListener(this.btn_ClanItemUpgrade,MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            main.loadPanel("Panels.ClanItemUpgrade");
         });
      }
      
      protected function hideMovieclips() : void
      {
         this.mcSkill.visible = false;
         this.mcSet.visible = false;
         this.mcHairstyle.visible = false;
         this.mcAccessory.visible = false;
      }
   }
}
