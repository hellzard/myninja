package id.ninjasage.features
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class EventMenu extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      private var main:*;
      
      private var panelMC:MovieClip;
      
      private var eventHandler:EventHandler;
      
      private var tabCategoryData:Array;
      
      private var images:Array;
      
      private var eventData:Object;
      
      private var selectedTab:String;
      
      private var currentPage:int;
      
      private var totalPage:int;
      
      private var currentIndexImage:int;
      
      public function EventMenu(param1:*, param2:*)
      {
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.images = [];
         this.tabCategoryData = [{
            "id":"seasonal",
            "button":"seasonal",
            "name":"Seasonal Events"
         },{
            "id":"event:permanent",
            "button":"mainevent",
            "name":"Main Events"
         },{
            "id":"features",
            "button":"mainfeature",
            "name":"Main Features"
         }];
         this.eventData = Character.event_data;
         super();
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.panelMC.mainFeatureMC.visible = false;
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         var _loc1_:int = 0;
         while(_loc1_ < this.tabCategoryData.length)
         {
            this.panelMC["btn_" + this.tabCategoryData[_loc1_].button].txt.text = this.tabCategoryData[_loc1_].name;
            this.panelMC["btn_" + this.tabCategoryData[_loc1_].button].metaData = {"id":this.tabCategoryData[_loc1_].id};
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabCategoryData[_loc1_].button],MouseEvent.CLICK,this.selectTab);
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabCategoryData[_loc1_].button],MouseEvent.MOUSE_OVER,this.hoverOver);
            this.eventHandler.addListener(this.panelMC["btn_" + this.tabCategoryData[_loc1_].button],MouseEvent.MOUSE_OUT,this.hoverOut);
            _loc1_++;
         }
         this.eventHandler.addListener(this.panelMC.seasonalDetailMC.pageMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.seasonalDetailMC.pageMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.mainFeatureMC.pageMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.mainFeatureMC.pageMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.resetSelectedTab();
         this.panelMC["btn_" + this.getTabData(Character.event_current_tab).button].gotoAndStop(3);
         this.selectTab();
      }
      
      private function selectTab(param1:MouseEvent = null) : void
      {
         if(param1)
         {
            Character.event_current_page = 1;
            Character.event_current_tab = param1.currentTarget.metaData.id;
            this.resetSelectedTab();
            param1.currentTarget.gotoAndStop(3);
         }
         var _loc2_:int = Character.event_current_tab == "seasonal" ? 1 : 8;
         this.totalPage = Math.max(1,Math.ceil(this.eventData[Character.event_current_tab].length / _loc2_));
         this.panelMC.mainFeatureMC.visible = Character.event_current_tab == "seasonal" ? false : true;
         if(Character.event_current_tab == "seasonal")
         {
            this.renderSeasonalUI();
         }
         else
         {
            this.renderEventUI();
         }
         this.panelMC.txt_title.text = this.getTabData(Character.event_current_tab).name;
         this.updatePageNumber();
      }
      
      private function getTabData(param1:*) : Object
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.tabCategoryData.length)
         {
            if(Character.event_current_tab == this.tabCategoryData[_loc2_].id)
            {
               return this.tabCategoryData[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function renderSeasonalUI() : void
      {
         var _loc1_:Object = this.eventData[Character.event_current_tab][Character.event_current_page - 1];
         var _loc2_:MovieClip = this.panelMC.seasonalDetailMC;
         _loc2_.txt_eventName.text = _loc1_.name;
         _loc2_.txt_eventDesc.text = _loc1_.desc;
         _loc2_.txt_eventDate.text = _loc1_.date;
         _loc2_.btn_start.metaData = _loc1_;
         this.eventHandler.addListener(_loc2_.btn_start,MouseEvent.CLICK,this.openEventPanel);
         GF.removeAllChild(this.panelMC.imageHolder);
         var _loc3_:* = this.eventData.seasonal[Character.event_current_page - 1].image;
         if(_loc3_ != null)
         {
            _loc3_.width = 1178;
            _loc3_.height = 790;
            this.panelMC.imageHolder.addChild(_loc3_);
         }
      }
      
      private function renderEventUI() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this.panelMC.mainFeatureMC["item_" + _loc1_].visible = false;
            _loc2_ = _loc1_ + int(int(Character.event_current_page - 1) * 8);
            if(this.eventData[Character.event_current_tab].length > _loc2_)
            {
               if(Boolean(this.eventData[Character.event_current_tab][_loc2_].hasOwnProperty("icon")) && (this.eventData[Character.event_current_tab][_loc2_].icon != null || this.eventData[Character.event_current_tab][_loc2_].icon != ""))
               {
                  this.panelMC.mainFeatureMC["item_" + _loc1_].visible = true;
                  this.panelMC.mainFeatureMC["item_" + _loc1_].icon.gotoAndStop(this.eventData[Character.event_current_tab][_loc1_].icon);
                  this.panelMC.mainFeatureMC["item_" + _loc1_].metaData = this.eventData[Character.event_current_tab][_loc1_];
                  this.main.initButton(this.panelMC.mainFeatureMC["item_" + _loc1_],this.openEventPanel,this.eventData[Character.event_current_tab][_loc1_].name);
               }
            }
            _loc1_++;
         }
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > Character.event_current_page)
               {
                  ++Character.event_current_page;
                  if(Character.event_current_tab == "seasonal")
                  {
                     this.renderSeasonalUI();
                  }
                  else
                  {
                     this.renderEventUI();
                  }
               }
               break;
            case "btn_prev":
               if(Character.event_current_page > 1)
               {
                  --Character.event_current_page;
                  if(Character.event_current_tab == "seasonal")
                  {
                     this.renderSeasonalUI();
                  }
                  else
                  {
                     this.renderEventUI();
                  }
               }
         }
         this.updatePageNumber();
      }
      
      private function updatePageNumber() : void
      {
         var _loc1_:MovieClip = Character.event_current_tab == "seasonal" ? this.panelMC.seasonalDetailMC.pageMC : this.panelMC.mainFeatureMC.pageMC;
         _loc1_.txt_page.text = Character.event_current_page + "/" + this.totalPage;
      }
      
      private function openEventPanel(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget.metaData;
         if(_loc2_.hasOwnProperty("inside") && Boolean(_loc2_.inside))
         {
            this.main.loadPanel("Panels." + _loc2_.panel);
         }
         else
         {
            this.main.loadExternalSwfPanel(_loc2_.panel,_loc2_.panel);
         }
         this.destroy();
      }
      
      private function resetSelectedTab() : void
      {
         this.panelMC["btn_seasonal"].gotoAndStop(1);
         this.panelMC["btn_mainevent"].gotoAndStop(1);
         this.panelMC["btn_mainfeature"].gotoAndStop(1);
      }
      
      private function hoverOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function hoverOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
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
         GF.removeAllChild(this.panelMC);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.tabCategoryData = null;
         this.eventData = null;
         this.panelMC = null;
         this.main = null;
      }
   }
}

