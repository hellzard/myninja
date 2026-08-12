package id.ninjasage.features
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   
   public dynamic class ExoticPackage extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      public function ExoticPackage(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.panelMC.btnClose.addEventListener(MouseEvent.CLICK,this.closePanel);
         this.panelMC.pageMC.btn_next.addEventListener(MouseEvent.CLICK,this.changePage);
         this.panelMC.pageMC.btn_prev.addEventListener(MouseEvent.CLICK,this.changePage);
         this.currentPage = 1;
         this.totalPage = this.panelMC.exoticMC.totalFrames;
         this.panelMC.exoticMC.gotoAndStop(this.currentPage);
         this.updatePageNumber();
         this.initButton();
      }
      
      private function initButton() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(this.panelMC.exoticMC.content["btn_" + _loc1_].hasEventListener(MouseEvent.CLICK))
            {
               this.panelMC.exoticMC.content["btn_" + _loc1_].removeEventListener(MouseEvent.CLICK,this.openPanel);
            }
            this.panelMC.exoticMC.content["btn_" + _loc1_].addEventListener(MouseEvent.CLICK,this.openPanel);
            _loc1_++;
         }
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
               }
               break;
            case "btn_prev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
               }
         }
         this.panelMC.exoticMC.gotoAndStop(this.currentPage);
         this.initButton();
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.pageMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function openPanel(param1:MouseEvent) : void
      {
         if(this.currentPage == 1)
         {
            switch(param1.currentTarget.name)
            {
               case "btn_0":
                  this.main.loadExternalSwfPanel("SpiritOfOrientSet","SpiritOfOrientSet");
                  break;
               case "btn_1":
                  this.main.loadExternalSwfPanel("NecromancerSet","NecromancerSet");
                  break;
               case "btn_2":
                  this.main.loadExternalSwfPanel("TearsOfKingdomSet","TearsOfKingdomSet");
                  break;
               case "btn_3":
                  this.main.loadExternalSwfPanel("AncientRuinsSet","AncientRuinsSet");
                  break;
               case "btn_4":
                  this.main.loadExternalSwfPanel("MechbuserSet","MechbuserSet");
            }
         }
         else if(this.currentPage == 2)
         {
            switch(param1.currentTarget.name)
            {
               case "btn_0":
                  this.main.loadExternalSwfPanel("FireBeastSet","FireBeastSet");
                  break;
               case "btn_1":
                  this.main.loadExternalSwfPanel("NightingaleSet","NightingaleSet");
                  break;
               case "btn_2":
                  this.main.loadExternalSwfPanel("MonolithSet","MonolithSet");
                  break;
               case "btn_3":
                  this.main.loadExternalSwfPanel("HanyaoniSet","HanyaoniSet");
                  break;
               case "btn_4":
                  this.main.loadExternalSwfPanel("DesertDwellerSet","DesertDwellerSet");
            }
         }
      }
      
      private function closePanel(param1:MouseEvent) : void
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
         this.panelMC.btnClose.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.panelMC.pageMC.btn_next.removeEventListener(MouseEvent.CLICK,this.changePage);
         this.panelMC.pageMC.btn_prev.removeEventListener(MouseEvent.CLICK,this.changePage);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.panelMC.exoticMC.content["btn_" + _loc1_].removeEventListener(MouseEvent.CLICK,this.openPanel);
            _loc1_++;
         }
         this.main.removeExternalSwfPanel();
         this.main = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
