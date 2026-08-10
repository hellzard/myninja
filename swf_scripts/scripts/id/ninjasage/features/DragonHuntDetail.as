package id.ninjasage.features
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class DragonHuntDetail extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main:*;
      
      private var eventHandler:EventHandler;
      
      private var langArr:Array;
      
      private var langArr2:Array;
      
      private var langArr3:Array;
      
      private var currentPage:int = 1;
      
      private var maxPage:int = 6;
      
      public function DragonHuntDetail(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.langArr = ["Details"];
         this.langArr2 = ["Five Dragons Return","Use of Dragon Balls  ","Use of Seal Reel","How to get Seal Reel","Use of Pet Food","How to get Pet Food"];
         this.langArr3 = ["Once upon a time, there were five dragons each born with a different element. \n\nSince their incredible power can destroy the world, so they were imprisoned on a deserted island by Master Iho. \n\nAfter two hundred years, the locks have been broken. Kage has sent a Ninja team to capture the dragons and save the world. ","There are a total of 5 sets, each set contain seven Dragon Balls. Players can then challenge a Dragon BOSS once they have collected a complete set of Dragon Balls.\n\nPlayers can then challenge a Dragon BOSS once they have collected a complete set of Dragon Balls.","Dragons can be captured by using Seal Reel.","Obtain Seal Reels from Daily Stamp or Shop.","Feeding Pet Dragons with Pet Food will increase their maturity points. \n\nDifferent Pet Food provides different increase in level.A full maturity bar is one of the conditions for Pet Combination.","There are two kinds of Pet Food, namely Fruits and Easter Eggs. \n\nFruits and Easter Eggs can be obtained from Dragon battles or Gacha."];
         this.eventHandler.addListener(this.panelMC["btnClose"],MouseEvent.CLICK,this.closePanel);
         this.updateDetail();
      }
      
      private function prevPage(param1:MouseEvent) : *
      {
         if(this.currentPage > 1)
         {
            --this.currentPage;
         }
         this.updateDetail();
      }
      
      private function nextPage(param1:MouseEvent) : *
      {
         if(this.currentPage < this.maxPage)
         {
            this.currentPage += 1;
         }
         this.updateDetail();
      }
      
      private function updateDetail() : *
      {
         var _loc1_:MovieClip = this["panelMC"];
         var _loc2_:int = this.currentPage - 1;
         _loc1_["titleTxt"].text = this.langArr[0];
         _loc1_["subTitleTxt"].text = this.langArr2[_loc2_];
         _loc1_["detailPage"]["detailPage"]["PageDetailTxt"].text = this.langArr3[_loc2_];
         _loc1_["pageTxt"].text = this.currentPage + " / " + this.maxPage;
         _loc1_["detailPage"]["detailPage"].gotoAndStop(this.currentPage);
         this.eventHandler.addListener(_loc1_["btnNextPage"],MouseEvent.CLICK,this.nextPage);
         _loc1_["btnNextPage"].visible = true;
         if(this.currentPage >= this.maxPage)
         {
            this.eventHandler.removeListener(_loc1_["btnNextPage"],MouseEvent.CLICK,this.nextPage);
            _loc1_["btnNextPage"].visible = false;
         }
         this.eventHandler.addListener(_loc1_["btnPrevPage"],MouseEvent.CLICK,this.prevPage);
         _loc1_["btnPrevPage"].visible = true;
         if(this.currentPage <= 1)
         {
            this.eventHandler.removeListener(_loc1_["btnPrevPage"],MouseEvent.CLICK,this.prevPage);
            _loc1_["btnPrevPage"].visible = false;
         }
      }
      
      private function closePanel(param1:MouseEvent) : *
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
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.langArr = [];
         this.langArr2 = [];
         this.langArr3 = [];
         this.main = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}

