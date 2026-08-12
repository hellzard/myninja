package Panels
{
   import Combat.BattleManager;
   import Combat.BattleTimer;
   import Combat.BattleVars;
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.ItemDropSourceMapping;
   import Storage.Library;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.multiplayer.battle.BattleAnimationEvent;
   
   public class Battle_UI_Gear extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var item_0:MovieClip;
      
      public var item_1:MovieClip;
      
      public var item_2:MovieClip;
      
      public var item_3:MovieClip;
      
      public var item_4:MovieClip;
      
      public var item_5:MovieClip;
      
      public var item_6:MovieClip;
      
      public var item_7:MovieClip;
      
      public var item_8:MovieClip;
      
      public var item_9:MovieClip;
      
      public var txt_page:TextField;
      
      public var main;
      
      public var combat;
      
      public var current_page = 1;
      
      public var total_page = 1;
      
      public var current_number = 0;
      
      public var usable_items:Array;
      
      public var character_usable_items:Array;
      
      public var array_info_holder:Array;
      
      public var tooltip:ToolTip;
      
      public var cache:Object;
      
      public var eventHandler;
      
      public function Battle_UI_Gear(param1:* = null, param2:* = null, param3:int = 0)
      {
         this.usable_items = [];
         this.usable_items = Library.getConsumableIds();
         this.character_usable_items = [];
         this.array_info_holder = [];
         this.eventHandler = new EventHandler();
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         if(param1 != null && param2 == null && param3 == 0)
         {
            this.main = param1;
            this.combat = this.main.combat;
            this.current_number = this.combat != null && this.combat.agility_bar_manager != null ? this.combat.agility_bar_manager.ambush_num : 0;
         }
         else
         {
            this.combat = param1;
            this.main = param2;
            this.current_number = param3;
         }
         this.tooltip = ToolTip.getInstance();
         this.hideItems();
         this.getUsableItemsAndUpdateDisplay();
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
      }
      
      function closePanel(param1:MouseEvent = null) : void
      {
         this.btn_prev.removeEventListener(MouseEvent.CLICK,this.changePagination);
         this.btn_next.removeEventListener(MouseEvent.CLICK,this.changePagination);
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.btn_prev = null;
         this.btn_next = null;
         this.btn_close = null;
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            GF.removeAllChild(this["item_" + _loc2_].iconMc.iconHolder);
            this["item_" + _loc2_] = null;
            _loc2_++;
         }
         if(this.combat != null && this.combat.gear != null)
         {
            this.combat.gear = null;
            if(parent)
            {
               parent.removeChild(this);
            }
         }
         NinjaSage.clearLoader();
         this.destroy();
         System.gc();
      }
      
      public function hideItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this["item_" + _loc1_].gotoAndStop(1);
            this["item_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      public function getUsableItemsAndUpdateDisplay() : void
      {
         var _loc1_:String = Character.character_consumables;
         if(_loc1_ == "")
         {
            this.character_usable_items = [];
            this.current_page = 1;
            this.total_page = 1;
            this.updatePageNumberDisplay();
            this.displayUsableItems();
            return;
         }
         var _loc2_:Array = _loc1_.indexOf(",") >= 0 ? _loc1_.split(",") : [_loc1_];
         this.character_usable_items = _loc2_.filter(this.filterUsableItems,null);
         this.current_page = 1;
         this.total_page = Math.max(Math.ceil(this.character_usable_items.length / 10),1);
         this.updatePageNumberDisplay();
         this.displayUsableItems();
      }
      
      private function filterUsableItems(param1:String, param2:int, param3:Array) : Boolean
      {
         var _loc4_:String = param1.split(":")[0];
         return this.usable_items.indexOf(_loc4_) >= 0;
      }
      
      public function updatePageNumberDisplay() : void
      {
         this.txt_page.text = this.current_page + "/" + this.total_page;
         if(!this.btn_prev.hasEventListener(MouseEvent.CLICK))
         {
            this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePagination);
         }
         if(!this.btn_next.hasEventListener(MouseEvent.CLICK))
         {
            this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePagination);
         }
      }
      
      public function changePagination(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         if(_loc2_ == "btn_prev" && this.current_page > 1)
         {
            --this.current_page;
         }
         else if(_loc2_ == "btn_next" && this.current_page < this.total_page)
         {
            ++this.current_page;
         }
         this.displayUsableItems();
         this.txt_page.text = this.current_page + "/" + this.total_page;
      }
      
      public function displayUsableItems() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         this.hideItems();
         this.array_info_holder = [];
         var _loc1_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < 10)
         {
            _loc1_ = _loc6_ + (this.current_page - 1) * 10;
            if(this.character_usable_items.length <= _loc1_)
            {
               break;
            }
            _loc3_ = (_loc7_ = this.character_usable_items[_loc1_].split(":"))[0];
            _loc2_ = _loc7_[1];
            _loc5_ = [(_loc4_ = Library.getItemInfo(_loc3_))["item_name"],_loc4_["item_level"],_loc4_["item_description"],_loc4_["item_source"]];
            this.array_info_holder.push(_loc5_);
            _loc8_ = this["item_" + _loc6_];
            GF.removeAllChild(_loc8_.iconMc.iconHolder);
            NinjaSage.loadIconSWF("consumables",_loc3_,_loc8_.iconMc);
            this.eventHandler.addListener(_loc8_,MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
            this.eventHandler.addListener(_loc8_,MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
            _loc8_.amtTxt.text = "x" + _loc2_;
            _loc8_.lvlTxt.text = _loc4_.item_level;
            _loc8_.visible = true;
            _loc8_.btn_use.visible = true;
            _loc8_.lockMc.visible = false;
            if(int(_loc4_.item_level) > int(Character.character_lvl))
            {
               _loc8_.lockMc.visible = true;
               _loc8_.btn_use.visible = false;
            }
            else
            {
               this.eventHandler.addListener(_loc8_.btn_use,MouseEvent.CLICK,this.handleItemUse);
            }
            _loc6_++;
         }
      }
      
      function toolTiponOver(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.currentTarget.name).replace("item_","");
         var _loc3_:int = int(_loc2_);
         var _loc4_:Array;
         var _loc5_:String = (_loc4_ = this.array_info_holder[_loc3_])[0] + "\n(Item)\n" + "\nLevel " + _loc4_[1] + "\n\n" + _loc4_[2] + ItemDropSourceMapping.formatSourceText(_loc4_.length > 3 ? _loc4_[3] : null);
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc5_);
      }
      
      public function toolTiponOut(param1:MouseEvent) : void
      {
         this.tooltip.hide();
      }
      
      public function handleItemUse(param1:MouseEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.visible = false;
         var _loc2_:int = param1.currentTarget.parent.name.replace("item_","");
         var _loc3_:int = _loc2_ + (this.current_page - 1) * 10;
         var _loc6_:* = (_loc4_ = this.character_usable_items[_loc3_].split(":"))[0];
         var _loc7_:* = (_loc5_ = Library.getItemInfo(_loc6_)).effect;
         if(_loc6_ == "item_52" || _loc6_ == "item_53" || _loc6_ == "item_58")
         {
            if(BattleManager.BATTLE_VARS.BATTLE_MODE != BattleVars.DRAGON_HUNT_MATCH)
            {
               if(this.main != null)
               {
                  this.main.showMessage("Sealing Scroll can be used during Dragon Hunt Battles.");
               }
               return;
            }
         }
         if(_loc6_ == "item_58" && !Character.is_cny_event)
         {
            if(this.main != null)
            {
               this.main.showMessage("Chinese Sealing Scroll can be used during Chinese New Year Battles.");
            }
            return;
         }
         dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.ITEM_USE,false,false,_loc6_));
         this.cache = {
            "id":_loc6_,
            "effect":_loc7_
         };
         if(this.main != null && this.main.amf_manager != null)
         {
            this.main.amf_manager.service("36a62s4oZ7iYRJjd.zLYzbsmF8811",[Character.sessionkey,Character.char_id,_loc6_],this.onUserItemResponse);
         }
         else
         {
            this.onUseItem();
         }
      }
      
      public function onUseItem() : void
      {
         var _loc1_:String = this.cache.id;
         var _loc2_:Array = this.cache.effect is Array ? this.cache.effect : [this.cache.effect];
         var _loc3_:Boolean = false;
         if(_loc1_ == "item_52" || _loc1_ == "item_53" || _loc1_ == "item_58")
         {
            if(this.combat != null)
            {
               _loc3_ = _loc1_ == "item_53" || this.combat.checkSealEnemy();
               if(_loc3_)
               {
                  if(this.main != null)
                  {
                     this.main.showMessage("Capture Success!");
                  }
                  if(this.combat.preCaptureEnemy != null)
                  {
                     setTimeout(this.combat.preCaptureEnemy,200);
                  }
                  if(this.combat.captureEnemy != null)
                  {
                     setTimeout(this.combat.captureEnemy,1200);
                  }
               }
               else
               {
                  if(this.main != null)
                  {
                     this.main.showMessage("Capture failed, try again");
                  }
                  setTimeout(BattleManager.startRun,500);
               }
            }
         }
         else
         {
            if(_loc1_ == "item_01")
            {
               setTimeout(this.onRunWithItem,200);
               return;
            }
            if(_loc1_ == "item_54")
            {
               if(this.combat != null && this.combat.showPercentageHpOfEnemy != null)
               {
                  setTimeout(this.combat.showPercentageHpOfEnemy,500);
               }
               this.recoverWithItem(_loc2_);
            }
            else
            {
               this.recoverWithItem(_loc2_);
            }
         }
         if(this.combat != null && this.combat.character_team_players != null && this.combat.character_team_players[this.current_number] != null)
         {
            this.combat.character_team_players[this.current_number].gotoAndPlay("item");
            if(this.combat.character_team_players[this.current_number].actions_manager != null)
            {
               this.combat.character_team_players[this.current_number].actions_manager.setActionBarVisible(false);
            }
         }
         this.tooltip.hide();
         BattleTimer.stopTurnTimer();
         Character.removeConsumables(_loc1_,1);
         Character.battle_logs.push({
            "_":"DH",
            "__":_loc1_
         });
         this.closePanel(null);
      }
      
      private function recoverWithItem(param1:Array) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         if(this.combat == null || this.combat.character_team_players == null || this.combat.character_team_players[this.current_number] == null)
         {
            return;
         }
         var _loc2_:Object = this.combat.character_team_players[this.current_number];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((_loc4_ = param1[_loc3_]).hasOwnProperty("recover"))
            {
               _loc5_ = 0;
               _loc6_ = "effect" in _loc4_ ? _loc4_.effect : _loc4_.name;
               switch(_loc6_)
               {
                  case "hp_percent":
                     _loc5_ = Math.floor(_loc2_.health_manager.max_hp * _loc4_.recover / 100);
                     break;
                  case "hp_number":
                     _loc5_ = _loc4_.recover;
                     break;
                  case "cp_percent":
                     _loc5_ = Math.floor(_loc2_.health_manager.max_cp * _loc4_.recover / 100);
                     break;
                  case "cp_number":
                     _loc5_ = _loc4_.recover;
                     break;
                  case "sp_percent":
                     _loc5_ = Math.floor(_loc2_.health_manager.max_sp * _loc4_.recover / 100);
                     break;
                  case "sp_number":
                     _loc5_ = _loc4_.recover;
                     break;
                  default:
                     _loc5_ = 0;
               }
               if(_loc5_ > 0)
               {
                  _loc5_ = _loc2_.effects_manager.increaseRecoverByEffects(_loc5_,_loc6_.indexOf("hp") != -1 ? "hp" : (_loc6_.indexOf("cp") != -1 ? "cp" : "sp"));
                  if(_loc6_.indexOf("hp") != -1)
                  {
                     _loc2_.health_manager.addHealth(_loc5_,"HealMC ");
                  }
                  else if(_loc6_.indexOf("cp") != -1)
                  {
                     _loc2_.health_manager.addCP(_loc5_);
                  }
                  else if(_loc6_.indexOf("sp") != -1)
                  {
                     _loc2_.health_manager.addSP("Recover SP +",_loc5_);
                  }
               }
            }
            else if(_loc4_.type === "Buff")
            {
               _loc2_.effects_manager.addBuff(_loc4_);
            }
            else
            {
               _loc2_.effects_manager.addDebuff(_loc4_);
            }
            _loc3_++;
         }
         setTimeout(BattleManager.startRun,750);
      }
      
      public function onUserItemResponse(param1:Object) : void
      {
         var _loc2_:Array = ["item_52","item_53","item_54","item_58"];
         if(param1.status == 1)
         {
            this.onUseItem();
         }
         else if(_loc2_.indexOf(this.cache != null ? this.cache.id : "") < 0)
         {
            this.onUseItem();
         }
         else if(this.main != null && this.main.giveMessage != null)
         {
            this.main.giveMessage(param1.result);
         }
      }
      
      public function onRunWithItem() : void
      {
         if(this.combat != null && this.combat.character_team_players != null && this.combat.character_team_players[this.current_number] != null)
         {
            this.combat.character_team_players[this.current_number].gotoAndPlay("smoke");
            try
            {
               if(BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.EXAM_MATCH)
               {
                  Character.character_class = null;
               }
            }
            catch(e:*)
            {
            }
            if(this.combat.character_team_players[this.current_number].actions_manager != null)
            {
               this.combat.character_team_players[this.current_number].actions_manager.setActionBarVisible(false);
            }
         }
         var _loc1_:* = BattleManager.getBattle();
         if(_loc1_ != null)
         {
            _loc1_.resetGameModes();
            if(_loc1_._main != null)
            {
               _loc1_._main.battleRewards("0","0","Run",false);
            }
         }
         System.gc();
         this.closePanel(null);
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         Log.debug(this,"DESTROY",getQualifiedClassName(this));
         GF.removeAllChild(this);
         GF.clearArray(this.character_usable_items);
         GF.clearArray(this.array_info_holder);
         if(this.eventHandler)
         {
            this.eventHandler.removeAllEventListeners();
         }
         if(this.tooltip)
         {
            this.tooltip.destroy();
            this.tooltip = null;
         }
         this.cache = null;
         this.usable_items = null;
         this.array_info_holder = null;
         this.character_usable_items = null;
         this.eventHandler = null;
         this.combat = null;
         this.main = null;
      }
   }
}
