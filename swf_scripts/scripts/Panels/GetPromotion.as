package Panels
{
   import Managers.AppManager;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.features.LinkMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3716")]
   public dynamic class GetPromotion extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var bg:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var imageHolder:MovieClip;
      
      public var loadingTxt:TextField;
      
      public var titleTxt:TextField;
      
      private var main:*;
      
      private var bannerData:Object;
      
      private var eventHandler:EventHandler = new EventHandler();
      
      private var loaderAsset:BulkLoader;
      
      public function GetPromotion(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = AppManager.getInstance().main;
         this.loaderAsset = this.main.getTempLoader();
         var _loc2_:Object = {};
         if(param1 is String)
         {
            _loc2_ = {
               "url":param1,
               "link":param1,
               "title":"",
               "action":"open:link"
            };
         }
         else
         {
            _loc2_ = param1;
         }
         this.bannerData = _loc2_;
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.bg,MouseEvent.CLICK,this.closePanel);
         this.addPromotion();
      }
      
      private function addPromotion() : void
      {
         if(!this.bannerData.hasOwnProperty("url"))
         {
            this.destroy();
            return;
         }
         this.loaderAsset.add(this.bannerData.url,{"id":this.bannerData.url});
         this.loaderAsset.addEventListener(BulkLoader.COMPLETE,this.onPromotionLoaded);
         this.loaderAsset.start();
      }
      
      private function onPromotionLoaded(param1:*) : void
      {
         var _loc2_:Function = null;
         this.loaderAsset.removeEventListener(BulkLoader.COMPLETE,this.onPromotionLoaded);
         this.imageHolder.addChild(this.loaderAsset.getContent(this.bannerData.url,true));
         this.imageHolder.width = 1670;
         this.imageHolder.height = 728;
         if(this.bannerData.hasOwnProperty("title"))
         {
            this.titleTxt.text = this.bannerData.title;
         }
         if(this.bannerData.hasOwnProperty("action"))
         {
            _loc2_ = this.bannerData.action == "open:link" ? this.openLink : this.openMenu;
            this.eventHandler.addListener(this.imageHolder,MouseEvent.CLICK,_loc2_);
         }
      }
      
      public function openLink(param1:MouseEvent) : *
      {
         navigateToURL(new URLRequest(this.bannerData.link));
         this.closePanel(param1);
      }
      
      public function openMenu(param1:MouseEvent) : void
      {
         LinkMenu.open(this.bannerData.menu);
         this.closePanel(param1);
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.removeAllChild(this.imageHolder);
         this.eventHandler.removeAllEventListeners();
         this.loaderAsset.clear();
         this.eventHandler = null;
         this.loaderAsset = null;
         this.imageHolder = null;
         this.main = null;
         this.bannerData = null;
         GF.removeAllChild(this);
      }
   }
}

