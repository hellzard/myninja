package Popups
{
   import Managers.OutfitManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol9145")]
   public class PreviewItem extends MovieClip
   {
      
      public var btn_close:SimpleButton;
      
      public var char_mc:MovieClip;
      
      private var main:*;
      
      private var itemId:String;
      
      private var outfitsPreview:Array = [];
      
      private var escapeKey:EscapeKeyManager;
      
      public function PreviewItem(param1:*, param2:String)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closeItemPreview);
         this.main = param1;
         this.itemId = param2;
         this.handleItemPreview(this.itemId);
      }
      
      private function handleItemPreview(param1:String) : void
      {
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closeItemPreview);
         var _loc2_:* = new OutfitManager(false);
         var _loc3_:* = param1.indexOf("wpn") >= 0 ? param1 : Character.character_weapon;
         var _loc4_:* = param1.indexOf("back") >= 0 ? param1 : Character.character_back_item;
         var _loc5_:* = param1.indexOf("set") >= 0 ? param1 : Character.character_set;
         var _loc6_:* = param1.indexOf("hair") >= 0 ? param1 : Character.character_hair;
         _loc2_.fillOutfit(this.char_mc,_loc3_,_loc4_,_loc5_,_loc6_,Character.character_face,Character.character_color_hair,Character.character_color_skin);
         this.outfitsPreview.push(_loc2_);
      }
      
      private function closeItemPreview(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closeItemPreview);
         GF.destroyArray(this.outfitsPreview);
         this.outfitsPreview = [];
         this.main = null;
         this.itemId = null;
         this.outfitsPreview = null;
         GF.removeAllChild(this);
      }
   }
}

