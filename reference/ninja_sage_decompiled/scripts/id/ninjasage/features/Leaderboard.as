package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Managers.OutfitManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class Leaderboard extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 0;
      
      private var main;
      
      private var response:Object;
      
      private var eventHandler:EventHandler;
      
      private var leaderboardData:Object;
      
      private var tabArray:Array;
      
      private var rewardData:Object;
      
      private var target:int;
      
      public function Leaderboard(param1:*, param2:*)
      {
         this.leaderboardData = {};
         this.rewardData = {};
         this.tabArray = [];
         this.target = 0;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.escapeKey.addListener(this.panelMC.rewardMC,this.closeLeaderboardReward);
         this.eventHandler = new EventHandler();
         this.panelMC.rewardMC.visible = false;
         this.getLeaderboardData();
      }
      
      private function getLeaderboardData(param1:MouseEvent = null) : *
      {
         var _loc2_:String = null;
         if(param1)
         {
            this.target = param1.currentTarget.name.replace("tab","");
            _loc2_ = this.tabArray[this.target][0];
         }
         else
         {
            _loc2_ = null;
         }
         this.main.loading(true);
         this.main.amf_manager.service("bQqnGVJtou5YIn69.fcigkFHrbhDR",[Character.char_id,Character.sessionkey,_loc2_],this.leaderboardResponse);
      }
      
      private function leaderboardResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
            this.leaderboardData = this.response.data;
            this.rewardData = this.response.rewards;
            if(this.tabArray.length < 1)
            {
               this.tabArray = this.response.categories;
               this.target = this.tabArray.length - 1;
            }
            this.currentPage = 1;
            this.panelMC.titleTxt.text = this.response.title;
            this.panelMC.playerKillTxt.text = this.response.kill_text;
            this.panelMC.timerMC.txt.text = "";
            if(this.response.freeze)
            {
               this.panelMC.timerMC.txt.text = this.response.freeze;
            }
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.destroy();
         }
         else
         {
            this.main.getError(param1.error);
            this.destroy();
         }
         this.initButton();
         this.upperRank();
         this.lowerRank();
      }
      
      private function initButton() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 5)
         {
            this.panelMC["tab" + _loc1_].visible = false;
            this.panelMC["tab" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         this.panelMC["tab" + this.target].gotoAndStop(3);
         _loc1_ = 0;
         while(_loc1_ < this.tabArray.length)
         {
            this.panelMC["tab" + _loc1_].visible = true;
            this.panelMC["tab" + _loc1_].txt.text = this.tabArray[_loc1_][1];
            this.panelMC["tab" + _loc1_].buttonMode = true;
            this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.ROLL_OVER,this.overFunction);
            this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.ROLL_OUT,this.outFunction);
            this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.CLICK,this.getLeaderboardData);
            _loc1_++;
         }
         NinjaSage.showDynamicTooltip(this.panelMC.btn_help,"Leaderboard points will be frozen after the timer ends.");
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btnReward,MouseEvent.CLICK,this.openLeaderboardReward);
         this.eventHandler.addListener(this.panelMC.btnPrev,MouseEvent.CLICK,this.changePage,false,0,true);
         this.eventHandler.addListener(this.panelMC.btnNext,MouseEvent.CLICK,this.changePage,false,0,true);
      }
      
      private function upperRank() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = _loc1_ + int(int(1 - 1) * 3);
            if(this.response.data.length > _loc2_)
            {
               this.panelMC["rankInfoMc" + _loc1_].visible = true;
               this.panelMC["rankInfoMc" + _loc1_].nameTxt.htmlText = Character.colorifyText(this.response.data[_loc1_].char_id,this.response.data[_loc1_].name,this.panelMC["rankInfoMc" + _loc1_].nameTxt);
               this.panelMC["rankInfoMc" + _loc1_].killTxt.text = this.response.data[_loc1_].kill;
               this.panelMC["rankInfoMc" + _loc1_].rankTxt.text = _loc1_ + 1;
               this.panelMC["rankInfoMc" + _loc1_].charRankMc.gotoAndStop(this.response.data[_loc1_].rank);
               this.panelMC["rankInfoMc" + _loc1_].buttonMode = true;
               this.panelMC["rankInfoMc" + _loc1_].metaData = {"charId":this.response.data[_loc1_].char_id};
               this.eventHandler.addListener(this.panelMC["rankInfoMc" + _loc1_],MouseEvent.CLICK,this.openFriendProfile);
               _loc3_ = this.getPlayerHead(_loc1_);
               _loc3_.scaleX = 1.7;
               _loc3_.scaleY = 1.7;
               _loc3_.x += 10;
               _loc3_.y -= 20;
               GF.removeAllChild(this.panelMC["rankInfoMc" + _loc1_].headHolder);
               this.panelMC["rankInfoMc" + _loc1_].headHolder.addChild(_loc3_);
            }
            else
            {
               this.panelMC["rankInfoMc" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function lowerRank() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 3;
         while(_loc1_ < 10)
         {
            _loc2_ = _loc1_ + int(int(this.currentPage - 1) * 7);
            if(this.response.data.length > _loc2_)
            {
               this.panelMC["rankInfoMc" + _loc1_].visible = true;
               this.panelMC["rankInfoMc" + _loc1_].nameTxt.htmlText = Character.colorifyText(this.response.data[_loc2_].char_id,this.response.data[_loc2_].name,this.panelMC["rankInfoMc" + _loc1_].nameTxt);
               this.panelMC["rankInfoMc" + _loc1_].killTxt.text = this.response.data[_loc2_].kill;
               this.panelMC["rankInfoMc" + _loc1_].rankTxt.text = _loc2_ + 1;
               this.panelMC["rankInfoMc" + _loc1_].charRankMc.gotoAndStop(this.response.data[_loc2_].rank);
               this.panelMC["rankInfoMc" + _loc1_].buttonMode = true;
               this.panelMC["rankInfoMc" + _loc1_].metaData = {"charId":this.response.data[_loc2_].char_id};
               this.eventHandler.addListener(this.panelMC["rankInfoMc" + _loc1_],MouseEvent.CLICK,this.openFriendProfile);
            }
            else
            {
               this.panelMC["rankInfoMc" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.totalPage = Math.max(Math.ceil(this.response.data.length / 7),1);
         this.updatePageText();
      }
      
      private function getPlayerHead(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(_loc2_)
         {
            _loc2_.destroy();
            _loc2_ = null;
         }
         _loc2_ = new OutfitManager();
         var _loc3_:* = new CharHead();
         _loc2_.fillHead(_loc3_,this.response.data[param1].sets.hair_style,this.response.data[param1].sets.face,this.response.data[param1].sets.hair_color,this.response.data[param1].sets.skin_color);
         return _loc3_;
      }
      
      private function openFriendProfile(param1:MouseEvent) : *
      {
         this.main.openFriendProfile(param1.currentTarget.metaData.charId,true);
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNext":
               if(this.totalPage > this.currentPage)
               {
                  ++this.currentPage;
                  this.lowerRank();
               }
               break;
            case "btnPrev":
               if(this.currentPage > 1)
               {
                  --this.currentPage;
                  this.lowerRank();
               }
         }
         this.updatePageText();
      }
      
      private function updatePageText() : *
      {
         this.panelMC.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function openLeaderboardReward(param1:MouseEvent) : *
      {
         var k:* = undefined;
         var categoryList:Array = null;
         var i:* = undefined;
         var rank:* = undefined;
         var currentReward:Array = null;
         var j:int = 0;
         var rewardId:String = null;
         var e:MouseEvent = param1;
         this.panelMC.rewardMC.visible = true;
         this.eventHandler.addListener(this.panelMC.rewardMC,MouseEvent.CLICK,this.closeLeaderboardReward);
         var keys:* = [];
         for(k in this.rewardData)
         {
            keys.push(k);
         }
         keys.sort(function(param1:*, param2:*):*
         {
            var _loc3_:* = param1 is String ? int(param1.split("-")[0]) : param1;
            var _loc4_:* = param2 is String ? int(param2.split("-")[0]) : param2;
            if(_loc3_ < _loc4_)
            {
               return -1;
            }
            if(_loc3_ > _loc4_)
            {
               return 1;
            }
            return 0;
         });
         categoryList = keys;
         i = 0;
         for each(rank in categoryList)
         {
            this.panelMC.rewardMC["lbl_name_" + i].text = "Rewards Rank " + rank;
            currentReward = !!this.rewardData[rank] ? this.rewardData[rank] : [];
            j = 0;
            while(j < 4)
            {
               this.panelMC.rewardMC["iconMc" + i + "_" + j].visible = false;
               this.panelMC.rewardMC["iconMc" + i + "_" + j].amountTxt.visible = false;
               if(j < currentReward.length)
               {
                  rewardId = currentReward[j].replace("%s",Character.character_gender);
                  this.panelMC.rewardMC["iconMc" + i + "_" + j].visible = true;
                  NinjaSage.loadItemIcon(this.panelMC.rewardMC["iconMc" + i + "_" + j],rewardId);
                  this.panelMC.rewardMC["iconMc" + i + "_" + j].ownedTxt.visible = false;
                  if(Character.hasSkill(rewardId) > 0)
                  {
                     this.panelMC.rewardMC["iconMc" + i + "_" + j].ownedTxt.visible = true;
                     this.panelMC.rewardMC["iconMc" + i + "_" + j].ownedTxt.text = "Owned";
                  }
                  if(Character.isItemOwned(rewardId) > 0)
                  {
                     this.panelMC.rewardMC["iconMc" + i + "_" + j].ownedTxt.visible = true;
                     this.panelMC.rewardMC["iconMc" + i + "_" + j].ownedTxt.text = "Owned";
                  }
               }
               j++;
            }
            i++;
         }
      }
      
      private function closeLeaderboardReward(param1:MouseEvent) : *
      {
         var _loc3_:int = 0;
         this.panelMC.rewardMC.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               GF.removeAllChild(this.panelMC.rewardMC["iconMc" + _loc2_ + "_" + _loc3_].rewardIcon.iconHolder);
               GF.removeAllChild(this.panelMC.rewardMC["iconMc" + _loc2_ + "_" + _loc3_].skillIcon.iconHolder);
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function hasSkill(param1:*) : *
      {
         var _loc2_:* = [];
         if(Character.character_skills != "")
         {
            if(Character.character_skills.indexOf(",") >= 0)
            {
               _loc2_ = Character.character_skills.split(",");
            }
            else
            {
               _loc2_ = [Character.character_skills];
            }
         }
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc4_])
            {
               _loc3_ = 1;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function overFunction(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrame == 3)
         {
            return;
         }
         param1.currentTarget.gotoAndStop(2);
      }
      
      private function outFunction(param1:MouseEvent) : *
      {
         if(param1.currentTarget.currentFrame == 3)
         {
            return;
         }
         param1.currentTarget.gotoAndStop(1);
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
         this.main.removeExternalSwfPanel();
         this.closeLeaderboardReward(null);
         var _loc1_:* = 0;
         while(_loc1_ < 10)
         {
            GF.removeAllChild(this.panelMC["rankInfoMc" + _loc1_].headHolder);
            _loc1_++;
         }
         this.leaderboardData = [];
         this.tabArray = [];
         this.rewardData = null;
         this.eventHandler = null;
         this.main = null;
         this.response = null;
         GF.removeAllChild(this.panelMC);
         this.panelMC = null;
         System.gc();
      }
   }
}
