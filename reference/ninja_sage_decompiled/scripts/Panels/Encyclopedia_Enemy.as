package Panels
{
   import Combat.BattleManager;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Managers.PreviewManager;
   import Storage.Character;
   import Storage.EnemyInfo;
   import Storage.GameData;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class Encyclopedia_Enemy extends MovieClip
   {
       
      
      public var optionMC:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      public var preview:MovieClip;
      
      public var buyGold:SimpleButton;
      
      public var buyTokens:SimpleButton;
      
      public var txt_title:TextField;
      
      public var txt_gold:TextField;
      
      public var txt_token:TextField;
      
      private var eventHandler:EventHandler;
      
      private var enemyData:Array;
      
      private var enemyDataOriginal:Array;
      
      private var enemyInfo:Object;
      
      private var loaderSwf:BulkLoader;
      
      private var itemIndex:int = 0;
      
      private var itemLoading:int = 0;
      
      private var itemCount:int = 0;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var currentPageBackground:int = 1;
      
      private var totalPageBackground:int = 1;
      
      private var selectedEnemyIndex:int = -1;
      
      private var isLoading:Boolean;
      
      private var firstLoad:Boolean = true;
      
      private var enemyStaticMCArray:Array;
      
      private var enemyStaticMCSelect:MovieClip;
      
      private var tooltip:ToolTip;
      
      private var enemyMCPreview:PreviewManager;
      
      private const attackLabel:Array = ["attack_01","attack_02","attack_03","attack_04","attack_05","attack_06","attack_07","attack_08","attack_09","attack_10","attack_11","attack_12","attack_13","attack_14","attack_15"];
      
      private var backgroundData:Array;
      
      private var battleEnemyId:Array;
      
      private var selectedMission:String = "mission_155";
      
      private var multiplier:Number = 1;
      
      private var selectedDiff:int = 1;
      
      private var main;
      
      public function Encyclopedia_Enemy(param1:*)
      {
         super();
         var _loc2_:* = GameData.get("encyclopedia");
         this.enemyData = EnemyInfo.getEncyIds();
         this.enemyDataOriginal = EnemyInfo.getEncyIds();
         this.backgroundData = _loc2_.background;
         this.enemyStaticMCArray = [];
         this.battleEnemyId = [];
         this.enemyMCPreview = null;
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
         this.totalPage = Math.max(Math.ceil(this.enemyData.length / 9),1);
         this.panelMC.txt_goToPage.restrict = "0-9";
         this.updatePageNumber();
         this.updateBackgroundHolder();
         this.resetEnemyPrepHolder();
         this.resetPreviewHolder();
         this.resetSelectedEnemyHolder();
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
         this.eventHandler.addListener(this.panelMC.btn_plus,MouseEvent.CLICK,this.addEnemy);
         this.eventHandler.addListener(this.panelMC.btn_reset,MouseEvent.CLICK,this.resetEnemy);
         this.eventHandler.addListener(this.panelMC.btn_battle,MouseEvent.CLICK,this.startBattle);
         this.eventHandler.addListener(this.panelMC.btn_option,MouseEvent.CLICK,this.openOption);
      }
      
      private function loadSwf() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.isLoading = true;
         if(this.itemIndex < this.itemLoading)
         {
            _loc1_ = this.enemyData[this.itemIndex];
            _loc2_ = "enemy/" + _loc1_ + ".swf";
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
         if(this.enemyData.length > 0)
         {
            this.selectEnemy(0);
         }
         this.isLoading = false;
      }
      
      private function onItemLoadError(param1:ErrorEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.completeIcon);
         this.enemyStaticMCArray[this.itemCount] = null;
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      private function completeIcon(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onItemLoadError);
         var _loc3_:MovieClip = null;
         _loc3_ = !!param1.target.content.hasOwnProperty("StaticFullBody") ? param1.target.content.StaticFullBody : param1.target.content.StatichuntingHouse;
         if(!Character.play_items_animation)
         {
            _loc3_.stopAllMovieClips();
         }
         this.enemyStaticMCArray.push(_loc3_);
         _loc3_.scaleX = 0.27;
         _loc3_.scaleY = 0.27;
         _loc3_.x = -25;
         _loc3_.y = -75;
         this.panelMC["item_" + this.itemCount].iconHolder.addChild(_loc3_);
         this.panelMC["item_" + this.itemCount].gotoAndStop(1);
         this.panelMC["item_" + this.itemCount].visible = true;
         var _loc4_:String = this.enemyData[this.itemIndex];
         param1.target.content[_loc4_].gotoAndStop(1);
         var _loc5_:Object = EnemyInfo.getEnemyStats(_loc4_);
         this.panelMC["item_" + this.itemCount].tooltip = _loc5_;
         this.panelMC["item_" + this.itemCount].lvlTxt.text = _loc5_.enemy_level;
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.MOUSE_OVER,this.toolTiponOver);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.MOUSE_OUT,this.toolTiponOut);
         this.eventHandler.addListener(this.panelMC["item_" + this.itemCount],MouseEvent.CLICK,this.selectEnemy);
         ++this.itemIndex;
         ++this.itemCount;
         this.loadSwf();
      }
      
      private function selectEnemy(param1:*) : void
      {
         var _loc2_:int = param1 is MouseEvent ? int(param1.currentTarget.name.replace("item_","")) : int(param1);
         this.resetSelectedEnemyHolder();
         this.selectedEnemyIndex = _loc2_ + int(int(this.currentPage - 1) * 9);
         var _loc3_:Object = this.panelMC["item_" + _loc2_].tooltip;
         this.panelMC.btn_preview.visible = true;
         this.panelMC.enemy_name.visible = true;
         this.eventHandler.addListener(this.panelMC.btn_preview,MouseEvent.CLICK,this.loadPreviewSwf);
         this.panelMC.enemy_name.text = _loc3_.enemy_name;
         NinjaSage.loadIconSWF("enemy",_loc3_.enemy_id,this.panelMC.enemy_mc,"StaticFullBody");
      }
      
      private function loadPreviewSwf(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.resetPreviewHolder();
         var _loc2_:* = this.enemyData[this.selectedEnemyIndex];
         var _loc3_:* = "enemy/" + _loc2_ + ".swf";
         var _loc4_:*;
         (_loc4_ = this.loaderSwf.add(_loc3_)).addEventListener(BulkLoader.COMPLETE,this.onCompleteEnemyLoaded);
         _loc4_.addEventListener(BulkLoader.ERROR,this.onEnemyLoadError);
         this.loaderSwf.start();
      }
      
      private function onEnemyLoadError(param1:ErrorEvent) : void
      {
         this.main.loading(false);
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.COMPLETE,this.onCompleteEnemyLoaded);
         this.loaderSwf.removeAll();
         this.updatePageNumber();
         this.resetSelectedEnemyHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function onCompleteEnemyLoaded(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.currentTarget.removeEventListener(BulkLoader.ERROR,this.onEnemyLoadError);
         this.enemyInfo = EnemyInfo.getEnemyStats(this.enemyData[this.selectedEnemyIndex]);
         var _loc3_:MovieClip = param1.target.content[this.enemyInfo.enemy_id];
         this.enemyMCPreview = new PreviewManager(this.main,_loc3_,this.enemyInfo);
         this.main.loading(false);
         this.showPreview();
      }
      
      private function showPreview() : void
      {
         this.preview.visible = true;
         this.preview.enemyMc.addChild(this.enemyMCPreview.preview_mc);
         this.enemyMCPreview.preview_mc.gotoAndPlay("standby");
         var _loc1_:int = 0;
         while(_loc1_ < this.enemyInfo.attacks.length)
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
         this.enemyMCPreview.preview_mc.gotoAndPlay(param1.currentTarget.name);
      }
      
      private function resetPreviewHolder() : void
      {
         if(this.enemyMCPreview)
         {
            this.enemyMCPreview.destroy();
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.attackLabel.length)
         {
            this.preview[this.attackLabel[_loc1_]].visible = false;
            _loc1_++;
         }
         this.enemyInfo = null;
         this.enemyMCPreview = null;
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
         this.resetSelectedEnemyHolder();
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
         var _loc4_:Array;
         var _loc5_:int = (_loc4_ = this.enemyDataOriginal).length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc7_];
            if((_loc9_ = (_loc8_ = EnemyInfo.getEnemyStats(_loc6_))["enemy_name"].toLowerCase()).indexOf(_loc3_) >= 0)
            {
               _loc2_.push(_loc6_);
            }
            _loc7_++;
         }
         this.enemyData = _loc2_;
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.enemyData.length / 9),1);
         this.loaderSwf.removeAll();
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedEnemyHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      private function onSearchClear(param1:MouseEvent) : void
      {
         this.panelMC.txt_search.text = "";
         this.panelMC.txt_goToPage.text = "";
         this.enemyData = this.enemyDataOriginal;
         this.currentPage = 1;
         this.totalPage = Math.max(Math.ceil(this.enemyData.length / 9),1);
         this.loaderSwf.removeAll();
         this.updatePageNumber();
         this.resetPreviewHolder();
         this.resetSelectedEnemyHolder();
         this.resetIconHolder();
         this.resetRecursiveProperty();
         this.loadSwf();
      }
      
      public function addEnemy(param1:MouseEvent) : void
      {
         if(this.battleEnemyId.length >= 3)
         {
            this.main.showMessage("Can\'t add more than 3 enemy");
            return;
         }
         this.battleEnemyId.push(this.enemyData[this.selectedEnemyIndex]);
         this.resetEnemyPrepHolder();
         this.updateBattlePrep();
      }
      
      public function updateBattlePrep() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.battleEnemyId.length)
         {
            this.panelMC["enemy_" + _loc1_].visible = true;
            this.panelMC["enemy_" + _loc1_].iconHolder.scaleX = 0.27;
            this.panelMC["enemy_" + _loc1_].iconHolder.scaleY = 0.27;
            this.panelMC["enemy_" + _loc1_].iconHolder.x = -25;
            this.panelMC["enemy_" + _loc1_].iconHolder.y = -75;
            NinjaSage.loadIconSWF("enemy",this.battleEnemyId[_loc1_],this.panelMC["enemy_" + _loc1_].iconHolder,"StaticFullBody");
            _loc1_++;
         }
      }
      
      public function updateBackgroundHolder() : void
      {
         GF.removeAllChild(this.panelMC.bg);
         this.panelMC.bg.scaleX = 0.2;
         this.panelMC.bg.scaleY = 0.2;
         NinjaSage.loadIconSWF("mission",Character.encyclopedia_battle.background,this.panelMC.bg,"BattleBG");
      }
      
      public function resetEnemyPrepHolder() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            GF.removeAllChild(this.panelMC["enemy_" + _loc1_].iconHolder);
            this.panelMC["enemy_" + _loc1_].iconHolder.scaleX = 1;
            this.panelMC["enemy_" + _loc1_].iconHolder.scaleY = 1;
            this.panelMC["enemy_" + _loc1_].iconHolder.x = 0;
            this.panelMC["enemy_" + _loc1_].iconHolder.y = 0;
            this.panelMC["enemy_" + _loc1_].gotoAndStop(1);
            this.panelMC["enemy_" + _loc1_].lockMc.visible = false;
            this.panelMC["enemy_" + _loc1_].emblemMC.visible = false;
            this.panelMC["enemy_" + _loc1_].amtTxt.visible = false;
            this.panelMC["enemy_" + _loc1_].lvlTxt.visible = false;
            this.panelMC["enemy_" + _loc1_].lvlLabel.visible = false;
            this.panelMC["enemy_" + _loc1_].visible = false;
            _loc1_++;
         }
         this.panelMC.bg.gotoAndStop(1);
      }
      
      public function openOption(param1:MouseEvent) : void
      {
         this.optionMC.visible = true;
         this.selectedMission = Character.encyclopedia_battle.background;
         Character.encyclopedia_battle.background = Character.encyclopedia_battle.background;
         this.optionMC.txt_allow_difficulty.text = Character.encyclopedia_battle.difficulty;
         this.optionMC.txt_allow_control.text = !!Character.encyclopedia_battle.controllable ? "YES" : "NO ";
         this.optionMC.descTxt.text = "";
         this.totalPageBackground = Math.max(Math.ceil(this.backgroundData.length / 6),1);
         this.optionMC.txt_page.text = this.currentPageBackground + "/" + this.totalPageBackground;
         this.eventHandler.addListener(this.optionMC.btn_prev_page,MouseEvent.CLICK,this.changePageBackground);
         this.eventHandler.addListener(this.optionMC.btn_next_page,MouseEvent.CLICK,this.changePageBackground);
         this.eventHandler.addListener(this.optionMC.btn_prev_control,MouseEvent.CLICK,this.setControllable);
         this.eventHandler.addListener(this.optionMC.btn_next_control,MouseEvent.CLICK,this.setControllable);
         this.eventHandler.addListener(this.optionMC.btn_prev_difficulty,MouseEvent.CLICK,this.setDifficulty);
         this.eventHandler.addListener(this.optionMC.btn_next_difficulty,MouseEvent.CLICK,this.setDifficulty);
         this.eventHandler.addListener(this.optionMC.btn_save,MouseEvent.CLICK,this.saveBattleOption);
         this.eventHandler.addListener(this.optionMC.btn_close,MouseEvent.CLICK,this.closeOption);
         this.loadBackground();
      }
      
      public function closeOption(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            GF.removeAllChild(this.optionMC["stage" + _loc2_].bgHolder);
            _loc2_++;
         }
         this.optionMC.visible = false;
      }
      
      public function loadBackground() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this.optionMC["stage" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = _loc1_ + int(int(this.currentPageBackground - 1) * 6);
            this.optionMC["stage" + _loc1_].visible = false;
            if(this.backgroundData.length > _loc2_)
            {
               this.optionMC["stage" + _loc1_].visible = true;
               this.optionMC["stage" + _loc1_].bgHolder.scaleX = 0.36;
               this.optionMC["stage" + _loc1_].bgHolder.scaleY = 0.25;
               GF.removeAllChild(this.optionMC["stage" + _loc1_].bgHolder);
               NinjaSage.loadIconSWF("mission",this.backgroundData[_loc2_],this.optionMC["stage" + _loc1_].bgHolder,"BattleBG");
               this.optionMC["stage" + _loc1_].mission_id = this.backgroundData[_loc2_];
               this.eventHandler.addListener(this.optionMC["stage" + _loc1_],MouseEvent.CLICK,this.selectMission);
            }
            _loc1_++;
         }
      }
      
      public function selectMission(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            this.optionMC["stage" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         param1.currentTarget.gotoAndStop(2);
         this.selectedMission = param1.currentTarget.mission_id;
      }
      
      public function changePageBackground(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next_page":
               if(this.totalPageBackground > this.currentPageBackground)
               {
                  ++this.currentPageBackground;
                  this.loadBackground();
               }
               break;
            case "btn_prev_page":
               if(this.currentPageBackground > 1)
               {
                  --this.currentPageBackground;
                  this.loadBackground();
               }
         }
         this.updatePageTextBackground();
      }
      
      public function updatePageTextBackground() : void
      {
         this.optionMC.txt_page.text = this.currentPageBackground + "/" + this.totalPageBackground;
      }
      
      public function setControllable(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "btn_prev_control":
               this.optionMC.txt_allow_control.text = "NO";
               Character.encyclopedia_battle.controllable = false;
               break;
            case "btn_next_control":
               this.optionMC.txt_allow_control.text = "YES";
               Character.encyclopedia_battle.controllable = true;
         }
      }
      
      public function setDifficulty(param1:MouseEvent) : void
      {
         var _loc2_:* = [{
            "name":"EASY",
            "multiplier":0.7
         },{
            "name":"NORMAL",
            "multiplier":1
         },{
            "name":"HARD",
            "multiplier":1.2
         }];
         switch(param1.currentTarget.name)
         {
            case "btn_prev_difficulty":
               --this.selectedDiff;
               if(this.selectedDiff < 0)
               {
                  this.selectedDiff = 0;
                  return;
               }
               break;
            case "btn_next_difficulty":
               ++this.selectedDiff;
               if(this.selectedDiff > int(_loc2_.length) - 1)
               {
                  this.selectedDiff = int(_loc2_.length) - 1;
                  return;
               }
               break;
         }
         this.optionMC.txt_allow_difficulty.text = _loc2_[this.selectedDiff].name;
         this.multiplier = _loc2_[this.selectedDiff].multiplier;
      }
      
      public function saveBattleOption(param1:MouseEvent) : void
      {
         this.optionMC.visible = false;
         this.main.showMessage("Option Saved!");
         Character.encyclopedia_battle.multiplier = this.multiplier;
         Character.encyclopedia_battle.controllable = this.optionMC.txt_allow_control.text == "YES" ? true : false;
         Character.encyclopedia_battle.background = this.selectedMission;
         Character.encyclopedia_battle.difficulty = this.optionMC.txt_allow_difficulty.text;
         this.updateBackgroundHolder();
      }
      
      public function startBattle(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.main.showMessage("Please equip at least 1 skill");
            return;
         }
         Character.mission_level = Character.character_lvl;
         this.main.combat = this.main.loadPanel("Combat.Battle",true);
         BattleManager.init(this.main.combat,this.main,BattleVars.TEST_MATCH,Character.encyclopedia_battle.background);
         BattleManager.addPlayerToTeam("player","char_" + Character.char_id);
         if(true)
         {
            Character.encyclopedia_battle.controllable = false;
         }
         Character.teammate_controllable = Character.encyclopedia_battle.controllable;
         Character.encyclopedia_battle.battle = true;
         if(this.battleEnemyId.length == 0)
         {
            BattleManager.addPlayerToTeam("enemy",this.enemyData[this.selectedEnemyIndex]);
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.battleEnemyId.length)
            {
               BattleManager.addPlayerToTeam("enemy",this.battleEnemyId[_loc2_]);
               _loc2_++;
            }
         }
         BattleManager.startBattle();
         this.destroy();
      }
      
      public function resetEnemy(param1:MouseEvent) : void
      {
         this.battleEnemyId = [];
         this.resetEnemyPrepHolder();
         this.updateBattlePrep();
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
         this.resetSelectedEnemyHolder();
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
         var tooltipData:Object = null;
         var desc:String = null;
         var itemType:String = null;
         var e:MouseEvent = param1;
         e.currentTarget.gotoAndStop(2);
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(!mc.tooltipCache)
         {
            var formatDesc:Function = function(param1:String, param2:String, param3:String = "", param4:String = "", param5:String = ""):String
            {
               return param1 + "\n(" + param2 + ")\n" + (!!param3 ? "\nLevel: " + param3 : "") + (!!param4 ? "\n" + param4 : "") + "\n\n" + param5;
            };
            tooltipData = mc.tooltip;
            if(!tooltipData)
            {
               return;
            }
            itemType = mc.item_type;
            desc = formatDesc(tooltipData.enemy_name,"Enemy",tooltipData.enemy_level,"",tooltipData.description);
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
      
      private function resetSelectedEnemyHolder() : void
      {
         GF.removeAllChild(this.panelMC.enemy_mc);
         GF.removeAllChild(this.enemyStaticMCSelect);
         this.preview.visible = false;
         this.optionMC.visible = false;
         this.panelMC.btn_preview.visible = false;
         this.panelMC.enemy_name.visible = false;
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
         while(_loc1_ < this.enemyStaticMCArray.length)
         {
            GF.removeAllChild(this.enemyStaticMCArray[_loc1_]);
            _loc1_++;
         }
         this.enemyStaticMCArray = [];
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
         if(this.enemyData.length < this.itemLoading)
         {
            this.itemLoading = this.enemyData.length;
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
         this.closeOption();
         this.updateBackgroundHolder();
         this.resetEnemyPrepHolder();
         this.resetIconHolder();
         this.resetSelectedEnemyHolder();
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
         this.enemyData.length = 0;
         this.enemyDataOriginal.length = 0;
         GF.removeAllChild(this);
      }
   }
}
