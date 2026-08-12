package Panels
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Storage.Character;
   import Storage.GameData;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class DeveloperTools extends MovieClip
   {
       
      
      public var btn_spoiler_clan:SimpleButton;
      
      public var btn_spoiler_sw:SimpleButton;
      
      public var spoilerMC:MovieClip;
      
      public var spoilerSWMC:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var addBtn:SimpleButton;
      
      public var closeBtn:SimpleButton;
      
      public var setBtn:SimpleButton;
      
      public var changeBtn:SimpleButton;
      
      public var itemTxt:TextField;
      
      public var levelTxt:TextField;
      
      public var rankTxt:TextField;
      
      public var emblemMc:MovieClip;
      
      private var main;
      
      private var eventHandler;
      
      private var itemStringHolder;
      
      private var levelHolder;
      
      private var rankHolder;
      
      public function DeveloperTools(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.initUI();
      }
      
      private function initUI() : *
      {
         this.spoilerMC.visible = false;
         this.spoilerSWMC.visible = false;
         this.emblemMc.gotoAndStop(Character.account_type + 1);
         this.eventHandler.addListener(this.addBtn,MouseEvent.CLICK,this.sendAmfItem,false,0,true);
         this.eventHandler.addListener(this.setBtn,MouseEvent.CLICK,this.sendAmfLevelRank,false,0,true);
         this.eventHandler.addListener(this.changeBtn,MouseEvent.CLICK,this.changeCharacter,false,0,true);
         this.eventHandler.addListener(this.closeBtn,MouseEvent.CLICK,this.closePanel,false,0,true);
         this.eventHandler.addListener(this.emblemMc,MouseEvent.CLICK,this.setEmblem,false,0,true);
         this.eventHandler.addListener(this.btn_spoiler_clan,MouseEvent.CLICK,this.handleSpoilerClan,false,0,true);
         this.eventHandler.addListener(this.btn_spoiler_sw,MouseEvent.CLICK,this.handleSpoilerSW,false,0,true);
         this.eventHandler.addListener(this.spoilerMC.btn_close,MouseEvent.CLICK,this.closeSpoiler,false,0,true);
         this.eventHandler.addListener(this.spoilerSWMC.btn_close,MouseEvent.CLICK,this.closeSpoilerSW,false,0,true);
         this.emblemMc.buttonMode = true;
      }
      
      private function sendAmfItem(param1:MouseEvent) : *
      {
         this.itemStringHolder = this.itemTxt.text;
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.cLZZyYtmMXKq",[Character.char_id,Character.sessionkey,this.itemStringHolder],this.sendAmfItemResponse);
      }
      
      private function sendAmfItemResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            Character.addRewards(param1.items);
            this.main.giveReward(1,param1.items);
            if("HUD" in this.main && this.main.HUD)
            {
               this.main.HUD.setBasicData();
            }
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function sendAmfLevelRank(param1:MouseEvent) : *
      {
         this.levelHolder = this.levelTxt.text;
         this.rankHolder = this.rankTxt.text;
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.ri32UaGVEv2t",[Character.char_id,Character.sessionkey,this.levelHolder,this.rankHolder],this.sendAmfLevelRankResponse);
      }
      
      private function sendAmfLevelRankResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.main.showMessage(param1.result);
            Character.character_lvl = this.levelHolder;
            Character.character_rank = this.rankHolder;
            if("HUD" in this.main && this.main.HUD)
            {
               this.main.HUD.loadFrame();
               this.main.HUD.setBasicData();
            }
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function changeCharacter(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.CharacterSelect");
         this.destroy();
      }
      
      private function setEmblem(param1:MouseEvent) : *
      {
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.oJbEOUTQdle5",[Character.char_id,Character.sessionkey],this.setEmblemResponse);
      }
      
      private function setEmblemResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            if(Character.account_type == 0)
            {
               Character.account_type = 1;
            }
            else
            {
               Character.account_type = 0;
            }
            this.main.showMessage(param1.result);
            this.emblemMc.gotoAndStop(Character.account_type + 1);
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.status);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      private function handleSpoilerClan(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:OutfitManager = null;
         this.spoilerMC.visible = true;
         this.main.handleVillageHUDVisibility(false);
         var _loc2_:Array = GameData.get("cwsw").clan;
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            _loc4_ = "0";
            this.spoilerMC["char_mc" + _loc3_].icon.visible = false;
            if(_loc2_[_loc3_].accessory)
            {
               this.spoilerMC["char_mc" + _loc3_].icon.visible = true;
               this.spoilerMC["char_mc" + _loc3_].icon.ownedTxt.visible = false;
               this.spoilerMC["char_mc" + _loc3_].icon.amtTxt.visible = false;
               NinjaSage.loadItemIcon(this.spoilerMC["char_mc" + _loc3_].icon,_loc2_[_loc3_].accessory);
            }
            (_loc5_ = new OutfitManager()).fillOutfit(this.spoilerMC["char_mc" + _loc3_],_loc2_[_loc3_].weapon,_loc2_[_loc3_].back,_loc2_[_loc3_].set.replace("%s",_loc4_),_loc2_[_loc3_].hair.replace("%s",_loc4_),"face_01_" + _loc4_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            _loc4_ = "1";
            this.spoilerMC["char_mc" + (_loc3_ + 5)].icon.visible = false;
            if(_loc2_[_loc3_].accessory)
            {
               this.spoilerMC["char_mc" + (_loc3_ + 5)].icon.visible = true;
               this.spoilerMC["char_mc" + _loc3_].icon.ownedTxt.visible = false;
               this.spoilerMC["char_mc" + _loc3_].icon.amtTxt.visible = false;
               NinjaSage.loadItemIcon(this.spoilerMC["char_mc" + (_loc3_ + 5)].icon,_loc2_[_loc3_].accessory);
            }
            (_loc5_ = new OutfitManager()).fillOutfit(this.spoilerMC["char_mc" + (_loc3_ + 5)],_loc2_[_loc3_].weapon,_loc2_[_loc3_].back,_loc2_[_loc3_].set.replace("%s",_loc4_),_loc2_[_loc3_].hair.replace("%s",_loc4_),"face_01_" + _loc4_);
            _loc3_++;
         }
      }
      
      private function closeSpoiler(param1:MouseEvent) : void
      {
         this.main.handleVillageHUDVisibility(true);
         this.spoilerMC.visible = false;
      }
      
      private function handleSpoilerSW(param1:MouseEvent) : void
      {
         var _loc6_:OutfitManager = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         this.spoilerSWMC.visible = true;
         this.main.handleVillageHUDVisibility(false);
         var _loc2_:Object = GameData.get("cwsw").sw;
         var _loc3_:int = 0;
         var _loc4_:String = "0";
         var _loc5_:String = "1";
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            this.spoilerSWMC["char_mc_ab" + _loc3_].icon.visible = false;
            if(_loc2_.all_squad[_loc3_].accessory)
            {
               this.spoilerSWMC["char_mc_ab" + _loc3_].icon.visible = true;
               this.spoilerSWMC["char_mc_ab" + _loc3_].icon.ownedTxt.visible = false;
               this.spoilerSWMC["char_mc_ab" + _loc3_].icon.amtTxt.visible = false;
               NinjaSage.loadItemIcon(this.spoilerSWMC["char_mc_ab" + _loc3_].icon,_loc2_.all_squad[_loc3_].accessory);
            }
            _loc4_ = "0";
            (_loc6_ = new OutfitManager()).fillOutfit(this.spoilerSWMC["char_mc_ab" + _loc3_],_loc2_.all_squad[_loc3_].weapon,_loc2_.all_squad[_loc3_].back,_loc2_.all_squad[_loc3_].set.replace("%s",_loc4_),_loc2_.all_squad[_loc3_].hair.replace("%s",_loc4_),"face_01_" + _loc4_);
            this.spoilerSWMC["char_mc_ag" + _loc3_].icon.visible = false;
            if(_loc2_.all_squad[_loc3_].accessory)
            {
               this.spoilerSWMC["char_mc_ag" + _loc3_].icon.visible = true;
               this.spoilerSWMC["char_mc_ag" + _loc3_].icon.ownedTxt.visible = false;
               this.spoilerSWMC["char_mc_ag" + _loc3_].icon.amtTxt.visible = false;
               NinjaSage.loadItemIcon(this.spoilerSWMC["char_mc_ag" + _loc3_].icon,_loc2_.all_squad[_loc3_].accessory);
            }
            _loc5_ = "1";
            (_loc6_ = new OutfitManager()).fillOutfit(this.spoilerSWMC["char_mc_ag" + _loc3_],_loc2_.all_squad[_loc3_].weapon,_loc2_.all_squad[_loc3_].back,_loc2_.all_squad[_loc3_].set.replace("%s",_loc5_),_loc2_.all_squad[_loc3_].hair.replace("%s",_loc5_),"face_01_" + _loc5_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 2)
         {
            this.spoilerSWMC["char_mc_wb" + _loc3_].icon.visible = false;
            if(_loc2_.winner_squad[_loc3_].accessory)
            {
               this.spoilerSWMC["char_mc_wb" + _loc3_].icon.visible = true;
               this.spoilerSWMC["char_mc_wb" + _loc3_].icon.ownedTxt.visible = false;
               this.spoilerSWMC["char_mc_wb" + _loc3_].icon.amtTxt.visible = false;
               NinjaSage.loadItemIcon(this.spoilerSWMC["char_mc_wb" + _loc3_].icon,_loc2_.winner_squad[_loc3_].accessory);
            }
            _loc4_ = "0";
            (_loc6_ = new OutfitManager()).fillOutfit(this.spoilerSWMC["char_mc_wb" + _loc3_],_loc2_.winner_squad[_loc3_].weapon,_loc2_.winner_squad[_loc3_].back,_loc2_.winner_squad[_loc3_].set.replace("%s",_loc4_),_loc2_.winner_squad[_loc3_].hair.replace("%s",_loc4_),"face_01_" + _loc4_);
            this.spoilerSWMC["char_mc_wg" + _loc3_].icon.visible = false;
            if(_loc2_.winner_squad[_loc3_].accessory)
            {
               this.spoilerSWMC["char_mc_wg" + _loc3_].icon.visible = true;
               this.spoilerSWMC["char_mc_wg" + _loc3_].icon.ownedTxt.visible = false;
               this.spoilerSWMC["char_mc_wg" + _loc3_].icon.amtTxt.visible = false;
               NinjaSage.loadItemIcon(this.spoilerSWMC["char_mc_wg" + _loc3_].icon,_loc2_.winner_squad[_loc3_].accessory);
            }
            _loc5_ = "1";
            (_loc6_ = new OutfitManager()).fillOutfit(this.spoilerSWMC["char_mc_wg" + _loc3_],_loc2_.winner_squad[_loc3_].weapon,_loc2_.winner_squad[_loc3_].back,_loc2_.winner_squad[_loc3_].set.replace("%s",_loc5_),_loc2_.winner_squad[_loc3_].hair.replace("%s",_loc5_),"face_01_" + _loc5_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 2)
         {
            this.spoilerSWMC["char_mc_gb" + _loc3_].icon.visible = false;
            if(_loc2_.global_rank[_loc3_].accessory)
            {
               this.spoilerSWMC["char_mc_gb" + _loc3_].icon.visible = true;
               this.spoilerSWMC["char_mc_gb" + _loc3_].icon.ownedTxt.visible = false;
               this.spoilerSWMC["char_mc_gb" + _loc3_].icon.amtTxt.visible = false;
               NinjaSage.loadItemIcon(this.spoilerSWMC["char_mc_gb" + _loc3_].icon,_loc2_.global_rank[_loc3_].accessory);
            }
            _loc4_ = "0";
            (_loc6_ = new OutfitManager()).fillOutfit(this.spoilerSWMC["char_mc_gb" + _loc3_],_loc2_.global_rank[_loc3_].weapon,_loc2_.global_rank[_loc3_].back,_loc2_.global_rank[_loc3_].set.replace("%s",_loc4_),_loc2_.global_rank[_loc3_].hair.replace("%s",_loc4_),"face_01_" + _loc4_);
            this.spoilerSWMC["char_mc_gg" + _loc3_].icon.visible = false;
            if(_loc2_.global_rank[_loc3_].accessory)
            {
               this.spoilerSWMC["char_mc_gg" + _loc3_].icon.visible = true;
               this.spoilerSWMC["char_mc_gg" + _loc3_].icon.ownedTxt.visible = false;
               this.spoilerSWMC["char_mc_gg" + _loc3_].icon.amtTxt.visible = false;
               NinjaSage.loadItemIcon(this.spoilerSWMC["char_mc_gg" + _loc3_].icon,_loc2_.global_rank[_loc3_].accessory);
            }
            _loc5_ = "1";
            (_loc6_ = new OutfitManager()).fillOutfit(this.spoilerSWMC["char_mc_gg" + _loc3_],_loc2_.global_rank[_loc3_].weapon,_loc2_.global_rank[_loc3_].back,_loc2_.global_rank[_loc3_].set.replace("%s",_loc5_),_loc2_.global_rank[_loc3_].hair.replace("%s",_loc5_),"face_01_" + _loc5_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _loc7_ = _loc2_.all_squad[_loc3_].weapon;
            _loc8_ = _loc2_.all_squad[_loc3_].back;
            _loc9_ = _loc2_.all_squad[_loc3_].accessory;
            _loc10_ = _loc2_.all_squad[_loc3_].pet;
            if(_loc7_ != null)
            {
               this.spoilerSWMC["b" + _loc3_].gotoAndStop("wpn");
               this.spoilerSWMC["g" + _loc3_].gotoAndStop("wpn");
            }
            else if(_loc8_ != null)
            {
               this.spoilerSWMC["b" + _loc3_].gotoAndStop("back");
               this.spoilerSWMC["g" + _loc3_].gotoAndStop("back");
            }
            else if(_loc9_ != null)
            {
               this.spoilerSWMC["b" + _loc3_].gotoAndStop("acc");
               this.spoilerSWMC["g" + _loc3_].gotoAndStop("acc");
            }
            else if(_loc10_ != null)
            {
               this.spoilerSWMC["b" + _loc3_].gotoAndStop("pet");
               this.spoilerSWMC["g" + _loc3_].gotoAndStop("pet");
            }
            _loc3_++;
         }
         _loc7_ = _loc2_.winner_squad[0].weapon;
         _loc8_ = _loc2_.winner_squad[0].back;
         _loc9_ = _loc2_.winner_squad[0].accessory;
         _loc10_ = _loc2_.winner_squad[0].pet;
         if(_loc7_ != null)
         {
            this.spoilerSWMC["bw0"].gotoAndStop("wpn");
            this.spoilerSWMC["gw0"].gotoAndStop("wpn");
         }
         else if(_loc8_ != null)
         {
            this.spoilerSWMC["bw0"].gotoAndStop("back");
            this.spoilerSWMC["gw0"].gotoAndStop("back");
         }
         else if(_loc9_ != null)
         {
            this.spoilerSWMC["bw0"].gotoAndStop("acc");
            this.spoilerSWMC["gw0"].gotoAndStop("acc");
         }
         else if(_loc10_ != null)
         {
            this.spoilerSWMC["bw0"].gotoAndStop("pet");
            this.spoilerSWMC["gw0"].gotoAndStop("pet");
         }
         _loc3_ = 0;
         while(_loc3_ < 2)
         {
            _loc7_ = _loc2_.global_rank[_loc3_].weapon;
            _loc8_ = _loc2_.global_rank[_loc3_].back;
            _loc9_ = _loc2_.global_rank[_loc3_].accessory;
            _loc10_ = _loc2_.global_rank[_loc3_].pet;
            if(_loc7_ != null)
            {
               this.spoilerSWMC["bg" + _loc3_].gotoAndStop("wpn");
               this.spoilerSWMC["gg" + _loc3_].gotoAndStop("wpn");
            }
            else if(_loc8_ != null)
            {
               this.spoilerSWMC["bg" + _loc3_].gotoAndStop("back");
               this.spoilerSWMC["gg" + _loc3_].gotoAndStop("back");
            }
            else if(_loc9_ != null)
            {
               this.spoilerSWMC["bg" + _loc3_].gotoAndStop("acc");
               this.spoilerSWMC["gg" + _loc3_].gotoAndStop("acc");
            }
            else if(_loc10_ != null)
            {
               this.spoilerSWMC["bg" + _loc3_].gotoAndStop("pet");
               this.spoilerSWMC["gg" + _loc3_].gotoAndStop("pet");
            }
            _loc3_++;
         }
      }
      
      private function closeSpoilerSW(param1:MouseEvent) : void
      {
         this.main.handleVillageHUDVisibility(true);
         this.spoilerSWMC.visible = false;
      }
      
      private function closePanel(param1:MouseEvent) : *
      {
         this.destroy();
      }
      
      private function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.eventHandler.removeAllEventListeners();
         this.main = null;
         this.eventHandler = null;
         this.itemStringHolder = null;
         this.levelHolder = null;
         this.rankHolder = null;
         GF.removeAllChild(this);
      }
   }
}
