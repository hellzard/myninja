package id.ninjasage.features
{
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class SpecialOffer extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var response:Object;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var currentIndex:int = 0;
      
      private var loaderAsset:BulkLoader;
      
      private var rewardPane:RewardScrollPane;
      
      private var main;
      
      public function SpecialOffer(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.loaderAsset = this.main.getTempLoader();
         this.rewardPane = new RewardScrollPane();
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.panelMC.btn_buy.gotoAndStop(1);
         this.getOfferData();
      }
      
      public function getOfferData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("ksumY1sNukmExPYW.CowDqX9KOSAe",[Character.char_id,Character.sessionkey],this.onLeagueResponse);
      }
      
      public function onLeagueResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1.offers;
            this.initUI();
         }
         else
         {
            this.main.getNotice(param1.result || "Unknown Error");
            this.destroy();
         }
      }
      
      private function initUI() : void
      {
         this.currentIndex = 0;
         this.currentPage = 1;
         this.totalPage = Math.max(1,Math.ceil(this.response.length / 1));
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.panelMC.scrollPaneHolder.addChild(this.rewardPane.getRewardPane());
         this.updatePageNumber();
         this.loadOffer();
      }
      
      private function loadOffer() : void
      {
         this.currentIndex = (this.currentPage - 1) * 1;
         if(!this.response[this.currentIndex].hasOwnProperty("url"))
         {
            this.destroy();
            return;
         }
         var _loc1_:String = this.response[this.currentIndex].url;
         GF.removeAllChild(this.panelMC.imageHolder);
         this.panelMC.txt_title.text = this.response[this.currentIndex].title;
         var _loc2_:* = this.loaderAsset.getContent(_loc1_);
         if(_loc2_)
         {
            this.showOffer(_loc2_);
            return;
         }
         this.loaderAsset.add(_loc1_,{"id":_loc1_});
         this.loaderAsset.addEventListener(BulkLoader.COMPLETE,this.onPromotionLoaded);
         this.loaderAsset.start();
      }
      
      private function onPromotionLoaded(param1:*) : void
      {
         this.loaderAsset.removeEventListener(BulkLoader.COMPLETE,this.onPromotionLoaded);
         this.showOffer(this.loaderAsset.getContent(this.response[this.currentIndex].url));
      }
      
      private function showOffer(param1:*) : void
      {
         this.updateRewardPane();
         this.panelMC.imageHolder.addChild(param1);
         this.panelMC.imageHolder.width = 1046;
         this.panelMC.imageHolder.height = 830;
         if(this.response[this.currentIndex].hasOwnProperty("title"))
         {
            this.panelMC.txt_title.text = this.response[this.currentIndex].title;
         }
         var _loc2_:String = !!this.main.isPaymentSupported() ? this.main.payment.getProductData(this.response[this.currentIndex].iapId).priceString : this.response[this.currentIndex].price;
         this.main.initButton(this.panelMC.btn_buy,this.onClickBuy,_loc2_);
      }
      
      private function updateRewardPane() : void
      {
         this.rewardPane.updateRewardPane({
            "rewards":this.response[this.currentIndex].rewards,
            "item_per_line":7,
            "width":null,
            "height":145,
            "scaleX":1.3,
            "scaleY":1.3,
            "x":135,
            "y":148,
            "scroll_direction":"vertical",
            "scroll_visible":true
         });
      }
      
      public function onClickBuy(param1:MouseEvent) : *
      {
         if(this.main.isPaymentSupported())
         {
            this.main.payment.purchaseProduct(this.response[this.currentIndex].iapId);
         }
         else
         {
            navigateToURL(new URLRequest("https://ninjasage.id/merchants"));
         }
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.loadOffer();
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.loadOffer();
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : void
      {
         if(this.currentPage == 1)
         {
            this.panelMC.btn_prev.visible = false;
         }
         else
         {
            this.panelMC.btn_prev.visible = true;
         }
         if(this.totalPage == this.currentPage)
         {
            this.panelMC.btn_next.visible = false;
         }
         else
         {
            this.panelMC.btn_next.visible = true;
         }
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.removeAllChild(this.panelMC.imageHolder);
         this.loaderAsset.clear();
         this.loaderAsset = null;
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
