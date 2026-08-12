package id.ninjasage.features
{
   import Managers.OutfitManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class PvpLeaderboard extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var curr_page = 1;
      
      private var last_page = 0;
      
      private var total_page = 0;
      
      private var main;
      
      private var character;
      
      private var response;
      
      private var eventHandler;
      
      private var target;
      
      public function PvpLeaderboard(param1:*, param2:*)
      {
         this.target = 0;
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.panelMC.rewardMC.visible = false;
         this.panelMC.btnReward.visible = false;
         this.initButton();
         this.getLeaderboardData();
      }
      
      private function initButton() : *
      {
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btnReward,MouseEvent.CLICK,this.openLeaderboardReward);
         this.eventHandler.addListener(this.panelMC.btnPrev,MouseEvent.CLICK,this.changePage,false,0,true);
         this.eventHandler.addListener(this.panelMC.btnNext,MouseEvent.CLICK,this.changePage,false,0,true);
      }
      
      private function getLeaderboardData(param1:MouseEvent = null) : *
      {
         this.curr_page = 1;
         this.panelMC.titleTxt.text = "PvP Leaderboard";
         this.main.loading(true);
         this.main.amf_manager.service("jpwzlvqNru201CF3.QrvXH5ZmpivT",[Character.char_id,Character.sessionkey],this.leaderboardResponse);
      }
      
      private function leaderboardResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.response = param1;
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.currentCharacterRank();
         this.upperRank();
         this.lowerRank();
      }
      
      private function currentCharacterRank() : void
      {
         this.panelMC.userInfoMc.trophiesTxt.text = this.response.trophy;
         this.panelMC.userInfoMc.nameTxt.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.panelMC.userInfoMc.nameTxt);
         this.panelMC.userInfoMc.rankTxt.text = String(this.response.pos);
         this.panelMC.userInfoMc.bgMC.gotoAndStop(1);
         this.panelMC.userInfoMc.charRankMc.gotoAndStop(String(Character.character_rank));
         this.panelMC.userInfoMc.leagueMC.gotoAndStop(this.response.league + 1);
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
               this.panelMC["rankInfoMc" + _loc1_].trophiesTxt.text = this.response.data[_loc1_].trophy;
               this.panelMC["rankInfoMc" + _loc1_].charRankMc.gotoAndStop(this.response.data[_loc1_].rank);
               this.panelMC["rankInfoMc" + _loc1_].leagueMC.gotoAndStop(this.response.data[_loc1_].league + 1);
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
            _loc2_ = _loc1_ + int(int(this.curr_page - 1) * 7);
            if(this.response.data.length > _loc2_)
            {
               this.panelMC["rankInfoMc" + _loc1_].visible = true;
               this.panelMC["rankInfoMc" + _loc1_].nameTxt.htmlText = Character.colorifyText(this.response.data[_loc2_].char_id,this.response.data[_loc2_].name,this.panelMC["rankInfoMc" + _loc1_].nameTxt);
               this.panelMC["rankInfoMc" + _loc1_].trophiesTxt.text = this.response.data[_loc2_].trophy;
               this.panelMC["rankInfoMc" + _loc1_].rankTxt.text = _loc2_ + 1;
               this.panelMC["rankInfoMc" + _loc1_].charRankMc.gotoAndStop(this.response.data[_loc2_].rank);
               this.panelMC["rankInfoMc" + _loc1_].leagueMC.gotoAndStop(this.response.data[_loc2_].league + 1);
               this.panelMC["rankInfoMc" + _loc1_].buttonMode = true;
               this.panelMC["rankInfoMc" + _loc1_].metaData = {"charId":this.response.data[_loc2_].char_id};
               if(this.response.data[_loc2_].char_id == Character.char_id)
               {
                  this.panelMC["rankInfoMc" + _loc1_].bgMC.gotoAndStop("player");
               }
               else
               {
                  this.panelMC["rankInfoMc" + _loc1_].bgMC.gotoAndStop("normal");
               }
               this.eventHandler.addListener(this.panelMC["rankInfoMc" + _loc1_],MouseEvent.CLICK,this.openFriendProfile);
            }
            else
            {
               this.panelMC["rankInfoMc" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         this.total_page = Math.max(Math.ceil(this.response.data.length / 7),1);
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
               if(this.total_page > this.curr_page)
               {
                  ++this.curr_page;
                  this.lowerRank();
               }
               break;
            case "btnPrev":
               if(this.curr_page > 1)
               {
                  --this.curr_page;
                  this.lowerRank();
               }
         }
         this.updatePageText();
      }
      
      private function updatePageText() : *
      {
         this.panelMC.pageTxt.text = this.curr_page + "/" + this.total_page;
      }
      
      private function openLeaderboardReward(param1:MouseEvent) : *
      {
         this.rewardMC.visible = true;
         this.eventHandler.addListener(this.rewardMC,MouseEvent.CLICK,this.closeLeaderboardReward);
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
         var _loc1_:* = 0;
         while(_loc1_ < 10)
         {
            GF.removeAllChild(this.panelMC["rankInfoMc" + _loc1_].headHolder);
            _loc1_++;
         }
         this.eventHandler = null;
         this.main = null;
         this.response = null;
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
