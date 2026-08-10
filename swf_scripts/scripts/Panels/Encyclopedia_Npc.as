package Panels
{
   import Managers.NinjaSage;
   import Managers.PreviewManager;
   import Storage.Character;
   import Storage.NpcInfo;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3684")]
   public class Encyclopedia_Npc extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var preview:MovieClip;
      
      public var txt_title:TextField;
      
      private var eventHandler:EventHandler;
      
      private var npcData:Array;
      
      private var npcDataOriginal:Array;
      
      private var npcInfo:Object;
      
      private var loaderSwf:BulkLoader;
      
      private var itemIndex:int = 0;
      
      private var itemLoading:int = 0;
      
      private var itemCount:int = 0;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var selectedNpcIndex:int = -1;
      
      private var isLoading:Boolean;
      
      private var firstLoad:Boolean = true;
      
      private var npcStaticMCArray:Array;
      
      private var npcStaticMCSelect:MovieClip;
      
      private var tooltip:ToolTip;
      
      private var npcMCPreview:PreviewManager;
      
      private const attackLabel:Array = ["attack_01","attack_02","attack_03","attack_04","attack_05","attack_06","attack_07","attack_08","attack_09","attack_10","attack_11","attack_12","attack_13","attack_14","attack_15"];
      
      private var main:*;
      
      public function Encyclopedia_Npc(param1:*)
      {
         super();
         this.npcData = NpcInfo.getEncyIds();
         this.npcDataOriginal = NpcInfo.getEncyIds();
         this.npcStaticMCArray = [];
         this.npcMCPreview = null;
         this.main = param1;
         this.tooltip = ToolTip.getInstance();
         this.loaderSwf = BulkLoader.createUniqueNamedLoader(9);
         this.eventHandler = new EventHandler();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.escapeKey.addListener(this.preview,this.closePreview);
         this.initUI();
         this.initButton();
      }
      
      private function initUI() : void
      {
         this.totalPage = Math.max(Math.ceil(this.npcData.length / 9),1);
         this.panelMC.txt_goToPage.restrict = "0-9";
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedNpcHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function initButton() : void
      {
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.panelMC.btn_to_page,MouseEvent.CLICK,this.goToPage);
         this.eventHandler.addListener(this.panelMC.btn_search,MouseEvent.CLICK,this.searchItem);
         this.eventHandler.addListener(this.panelMC.btn_clearSearch,MouseEvent.CLICK,this.onSearchClear);
      }
      
      private function loadSwf() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.isLoading = true;
         if(this.itemIndex < this.itemLoading)
         {
            _loc1_ = this.npcData[this.itemIndex];
            _loc2_ = "npcs/" + _loc1_ + ".swf";
            _loc3_ = this.loaderSwf.add(_loc2_,{
               "id":_loc1_,
               "type":"movieclip"
            });
            _loc3_.addEventListener(BulkLoader.COMPLETE,this.completeIcon);
            _loc3_.addEventListener(BulkLoader.ERROR,this.onItemLoadError);
            this.loaderSwf.start();
            return;
         }
         if(this.firstLoad)
         {
            this.main.loading(false);
            this.firstLoad = false;
         }
         if(this.npcData.length > 0)
         {
            this.selectNpc(0);
         }
         this.isLoading = false;
      }
      
      private function onItemLoadError(param1:ErrorEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.completeIcon);
         this.npcStaticMCArray[this.itemCount] = null;
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      private function completeIcon(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onItemLoadError);
         var _loc3_:MovieClip = param1.target.content[this.npcData[this.itemIndex]];
         var _loc4_:MovieClip = null;
         _loc4_ = param1.target.content.hasOwnProperty("StaticFullBody") ? param1.target.content.StaticFullBody : param1.target.content.StatichuntingHouse;
         if(!Character.play_items_animation)
         {
            _loc4_.stopAllMovieClips();
         }
         this.npcStaticMCArray.push(_loc4_);
         _loc4_.scaleX = 0.27;
         _loc4_.scaleY = 0.27;
         _loc4_.x = -25;
         _loc4_.y = -75;
         this.panelMC["item_" + this.itemCount].iconHolder.addChild(_loc4_);
         this.panelMC["item_" + this.itemCount].gotoAndStop(1);
         this.panelMC["item_" + this.itemCount].visible = true;
         var _loc5_:String = this.npcData[this.itemIndex];
         param1.target.content[_loc5_].gotoAndStop(1);
         var _loc6_:Object = NpcInfo.getNpcStats(_loc5_);
         this.panelMC["item_" + this.itemCount].tooltip = _loc6_;
         this.panelMC["item_" + this.itemCount].lvlTxt.text = _loc6_.npc_level;
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.MOUSE_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.MOUSE_OUT,this.toolTiponOut);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.CLICK,this.selectNpc);
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      private function selectNpc(param1:*) : void
      {
         var _loc2_:int = param1 is MouseEvent ? int(param1.currentTarget.name.replace("item_","")) : int(param1);
         this.resetSelectedNpcHolder();
         this.selectedNpcIndex = _loc2_ + int(int(this.currentPage - 1) * 9);
         var _loc3_:Object = this.panelMC["item_" + _loc2_].tooltip;
         this.panelMC.btn_preview.visible = true;
         this.panelMC.npc_name.visible = true;
         this.eventHandler.addListener(this.panelMC.btn_preview,MouseEvent.CLICK,this.loadPreviewSwf);
         this.panelMC.npc_name.text = _loc3_.npc_name;
         NinjaSage.loadIconSWF("npcs",_loc3_.npc_id,this.panelMC.npc_mc,"StaticFullBody");
      }
      
      private function loadPreviewSwf(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.resetPreviewHolder();
         var _loc2_:* = this.npcData[this.selectedNpcIndex];
         var _loc3_:* = "npcs/" + _loc2_ + ".swf";
         var _loc4_:* = this.loaderSwf.add(_loc3_);
         _loc4_.addEventListener(BulkLoader.COMPLETE,this.onCompleteNpcLoaded);
         _loc4_.addEventListener(BulkLoader.ERROR,this.onNpcLoadError);
         this.loaderSwf.start();
      }
      
      private function onNpcLoadError(param1:ErrorEvent) : void
      {
         this.main.loading(false);
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.onCompleteNpcLoaded);
         this.loaderSwf.removeAll();
         this.updatePageNumber();
         this.resetSelectedNpcHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function onCompleteNpcLoaded(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onNpcLoadError);
         this.npcInfo = NpcInfo.getNpcStats(this.npcData[this.selectedNpcIndex]);
         var _loc3_:MovieClip = param1.target.content[this.npcInfo.npc_id];
         this.npcMCPreview = new PreviewManager(this.main,_loc3_,this.npcInfo);
         this.main.loading(false);
         this.showPreview();
      }
      
      private function showPreview() : void
      {
         this.preview.visible = true;
         this.preview.enemyMc.addChild(this.npcMCPreview.preview_mc);
         this.npcMCPreview.preview_mc.gotoAndPlay("standby");
         var _loc1_:int = 0;
         while(_loc1_ < this.npcInfo.attacks.length)
         {
            this.preview[this.attackLabel[_loc1_]].visible = true;
            this.main.initButton(this.preview[this.attackLabel[_loc1_]],this.playSkillAnimation,"Skill " + (_loc1_ + 1));
            this.main.initButton(this.preview.dodge,this.playSkillAnimation,"Dodge");
            this.main.initButton(this.preview.hit,this.playSkillAnimation,"Hit");
            this.main.initButton(this.preview.dead,this.playSkillAnimation,"Dead");
            _loc1_++;
         }
         this.eventHandler.addListener(this.preview.exitBtn,MouseEvent.CLICK,this.closePreview);
      }
      
      private function playSkillAnimation(param1:MouseEvent) : void
      {
         this.npcMCPreview.preview_mc.gotoAndPlay(param1.currentTarget.name);
      }
      
      private function resetPreviewHolder() : void
      {
         if(this.npcMCPreview)
         {
            this.npcMCPreview.destroy();
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.attackLabel.length)
         {
            this.preview[this.attackLabel[_loc1_]].visible = false;
            _loc1_++;
         }
         this.npcInfo = null;
         this.npcMCPreview = null;
      }
      
      private function closePreview(param1:MouseEvent) : void
      {
         this.resetPreviewHolder();
         this.preview.visible = false;
         GF.removeAllChild(this.preview.enemyMc);
      }
      
      private function goToPage(param1:MouseEvent) : void
      {
         if(this.panelMC.txt_goToPage.text == "" || this.panelMC.txt_goToPage.text < 1 || this.panelMC.txt_goToPage.text > this.totalPage)
         {
            return;
         }
         this.currentPage = int(this.panelMC.txt_goToPage.text);
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedNpcHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function searchItem(param1:MouseEvent) : void
      {
         var _loc6_:String = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc2_:Array = [];
         var _loc3_:String = this.panelMC.txt_search.text.toLowerCase();
         var _loc4_:Array = this.npcDataOriginal;
         var _loc5_:int = int(_loc4_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc7_];
            _loc8_ = NpcInfo.getNpcStats(_loc6_);
            _loc9_ = _loc8_["npc_name"].toLowerCase();
            if(_loc9_.indexOf(_loc3_) >= 0)
            {
               _loc2_.push(_loc6_);
            }
            _loc7_++;
         }
         this.npcData = _loc2_;
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.npcData.length / 9),1);
         this.loaderSwf.removeAll();
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedNpcHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function onSearchClear(param1:MouseEvent) : void
      {
         this.panelMC.txt_search.text = "";
         this.panelMC.txt_goToPage.text = "";
         this.npcData = this.npcDataOriginal;
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.npcData.length / 9),1);
         this.loaderSwf.removeAll();
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedNpcHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function changePage(param1:MouseEvent) : void
      {
         if(this.isLoading)
         {
            return;
         }
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  break;
               }
               return;
               break;
            case "btn_prev":
               if(this.currentPage <= 1)
               {
                  return;
               }
               --this.currentPage;
         }
         this.resetPreviewHolder();
         this.resetSelectedNpcHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.updatePageNumber();
         this.loaderSwf.removeAll();
         this.loadSwf();
      }
      
      private function updatePageNumber() : void
      {
         this.panelMC.txt_page.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function hoverOver(param1:Event) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function hoverOut(param1:Event) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function toolTiponOver(param1:MouseEvent) : void
      {
         var mc:MovieClip;
         var formatDesc:Function;
         var tooltipData:Object = null;
         var desc:String = null;
         var itemType:String = null;
         var e:MouseEvent = param1;
         e.currentTarget.gotoAndStop(2);
         mc = e.currentTarget as MovieClip;
         if(!mc.tooltipCache)
         {
            formatDesc = function(param1:String, param2:String, param3:String = "", param4:String = "", param5:String = ""):String
            {
               return param1 + "\n(" + param2 + ")\n" + (param3 ? "\nLevel: " + param3 : "") + (param4 ? "\n" + param4 : "") + "\n\n" + param5;
            };
            tooltipData = mc.tooltip;
            if(!tooltipData)
            {
               return;
            }
            itemType = mc.item_type;
            desc = formatDesc(tooltipData.npc_name,"Npc",tooltipData.npc_level,"",tooltipData.description);
            mc.tooltipCache = desc;
         }
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(mc.tooltipCache);
      }
      
      private function toolTiponOut(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(1);
         this.tooltip.hide();
      }
      
      private function resetSelectedNpcHolder() : void
      {
         GF.removeAllChild(this.panelMC.npc_mc);
         GF.removeAllChild(this.npcStaticMCSelect);
         this.preview.visible = false;
         this.panelMC.btn_preview.visible = false;
         this.panelMC.npc_name.visible = false;
         this.eventHandler.removeListener(this.panelMC.btn_preview,MouseEvent.CLICK,this.loadPreviewSwf);
         var _loc1_:int = 0;
         while(_loc1_ < 9)
         {
            this.panelMC["item_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function resetIconHolder() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.npcStaticMCArray.length)
         {
            GF.removeAllChild(this.npcStaticMCArray[_loc1_]);
            _loc1_++;
         }
         this.npcStaticMCArray = [];
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            GF.removeAllChild(this.panelMC["item_" + _loc1_].iconMc.iconHolder);
            this.panelMC["item_" + _loc1_].gotoAndStop(1);
            this.panelMC["item_" + _loc1_].visible = false;
            this.panelMC["item_" + _loc1_].lockMc.visible = false;
            this.panelMC["item_" + _loc1_].emblemMC.visible = false;
            this.panelMC["item_" + _loc1_].amtTxt.visible = false;
            delete this.panelMC["item_" + _loc1_].tooltip;
            delete this.panelMC["item_" + _loc1_].tooltipCache;
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_],MouseEvent.MOUSE_OVER,this.toolTiponOver);
            this.eventHandler.removeListener(this.panelMC["item_" + _loc1_],MouseEvent.MOUSE_OUT,this.toolTiponOut);
            _loc1_++;
         }
      }
      
      private function resetRecursiveProperty() : void
      {
         this.itemLoading = this.currentPage * 9;
         if(this.npcData.length < this.itemLoading)
         {
            this.itemLoading = this.npcData.length;
         }
         this.itemIndex = (this.currentPage - 1) * 9;
         this.itemCount = 0;
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
         this.main.clearEvents();
         this.resetIconHolder();
         this.resetSelectedNpcHolder();
         this.resetPreviewHolder();
         this.resetRecursiveProperty();
         this.eventHandler.removeAllEventListeners();
         this.loaderSwf.clear();
         this.tooltip.destroy();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.tooltip = null;
         this.loaderSwf = null;
         this.main = null;
         this.npcData.length = 0;
         this.npcDataOriginal.length = 0;
         GF.removeAllChild(this);
      }
   }
}

