package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.GameData;
   import com.adobe.crypto.CUCSG;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class Recruit extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var npcInfo:Object;
      
      private var npcDetail:Array;
      
      private var npcIdx:int;
      
      private var curr_page:int = 1;
      
      private var last_page:int = 0;
      
      private var total_page:int = 0;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var target:int = 0;
      
      public function Recruit(param1:*, param2:*)
      {
         this.npcInfo = GameData.get("recruit");
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.initButton();
         this.setNpcUI();
      }
      
      private function initButton() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 2)
         {
            this.panelMC["tab" + _loc1_].visible = false;
            this.panelMC["tab" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.npcInfo.npcs.length)
         {
            this.panelMC["tab" + _loc1_].visible = true;
            this.panelMC["tab" + _loc1_].txt.text = this.npcInfo.npcs[_loc1_].tab_name;
            this.panelMC["tab" + _loc1_].buttonMode = true;
            this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.ROLL_OVER,this.overFunction);
            this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.ROLL_OUT,this.outFunction);
            this.eventHandler.addListener(this.panelMC["tab" + _loc1_],MouseEvent.CLICK,this.setNpcUI);
            _loc1_++;
         }
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.btn_prev,MouseEvent.CLICK,this.changePage,false,0,true);
         this.eventHandler.addListener(this.panelMC.btn_next,MouseEvent.CLICK,this.changePage,false,0,true);
      }
      
      private function setNpcUI(param1:MouseEvent = null) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1 is MouseEvent)
         {
            this.target = param1.currentTarget.name.replace("tab","");
            this.curr_page = 1;
            _loc2_ = 0;
            while(_loc2_ < this.npcInfo.npcs.length)
            {
               this.panelMC["tab" + _loc2_].gotoAndStop(1);
               _loc2_++;
            }
            param1.currentTarget.gotoAndStop(3);
         }
         else
         {
            this.panelMC.tab0.gotoAndStop(3);
         }
         if(this.npcInfo.npcs[this.target].type == "Classic")
         {
            this.npcDetail = this.npcInfo.npcs[0].detail;
         }
         else
         {
            this.npcDetail = this.npcInfo.npcs[1].detail;
         }
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = _loc2_ + int(int(this.curr_page - 1) * 4);
            GF.removeAllChild(this.panelMC["npcMC" + _loc2_].holder);
            if(this.npcDetail.length > _loc3_)
            {
               this.panelMC["npcMC" + _loc2_].visible = true;
               this.panelMC["npcMC" + _loc2_].nameTxt.text = this.npcDetail[_loc3_].name;
               this.panelMC["npcMC" + _loc2_].lvlTxt.text = "Lv. " + String(this.npcDetail[_loc3_].level);
               this.panelMC["npcMC" + _loc2_].rankMC.gotoAndStop(this.npcDetail[_loc3_].rank);
               NinjaSage.loadIconSWF("npcs",this.npcDetail[_loc3_].id,this.panelMC["npcMC" + _loc2_].holder,"StaticFullBody");
               if(this.npcDetail[_loc3_].premium)
               {
                  this.panelMC["npcMC" + _loc2_].emblemMC.visible = true;
               }
               else
               {
                  this.panelMC["npcMC" + _loc2_].emblemMC.visible = false;
               }
               if(this.npcDetail[_loc3_].price_token == 0 && this.npcDetail[_loc3_].price_gold > 0)
               {
                  this.panelMC["npcMC" + _loc2_].priceMC.gotoAndStop(1);
                  this.panelMC["npcMC" + _loc2_].priceMC.txt_gold.text = this.npcDetail[_loc3_].price_gold;
               }
               else
               {
                  this.panelMC["npcMC" + _loc2_].priceMC.gotoAndStop(2);
                  this.panelMC["npcMC" + _loc2_].priceMC.txt_token.text = this.npcDetail[_loc3_].price_token;
               }
               this.eventHandler.addListener(this.panelMC["npcMC" + _loc2_].btn_recruit,MouseEvent.CLICK,this.onRecruitAmf);
            }
            else
            {
               this.panelMC["npcMC" + _loc2_].visible = false;
            }
            _loc2_++;
         }
         this.total_page = Math.max(Math.ceil(this.npcDetail.length / 4),1);
         this.updatePageText();
      }
      
      private function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_page > this.curr_page)
               {
                  ++this.curr_page;
                  this.setNpcUI();
               }
               break;
            case "btn_prev":
               if(this.curr_page > 1)
               {
                  --this.curr_page;
                  this.setNpcUI();
               }
         }
         this.updatePageText();
      }
      
      private function updatePageText() : *
      {
         this.panelMC.txt_page.text = this.curr_page + "/" + this.total_page;
      }
      
      private function onRecruitAmf(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.parent.name.replace("npcMC","");
         this.npcIdx = int(_loc2_) + int(int(this.curr_page - 1) * 4);
         if(this.npcDetail[this.npcIdx].premium && Character.account_type == 0)
         {
            this.main.showMessage("You need to be premium user to recruit this NPC!");
            return;
         }
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.gD5eaToDxQLX",[Character.char_id,Character.sessionkey,this.npcDetail[this.npcIdx].id],this.onRecruitAmfRes);
      }
      
      private function onRecruitAmfRes(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = param1.recruiters[1];
            _loc3_ = CUCSG.hash(param1.recruiters[0][0]);
            if(_loc2_ == _loc3_)
            {
               if(this.npcDetail[this.npcIdx].price_token == 0 && this.npcDetail[this.npcIdx].price_gold > 0)
               {
                  Character.character_gold = String(int(Character.character_gold) - int(this.npcDetail[this.npcIdx].price_gold));
               }
               else
               {
                  Character.account_tokens = int(Character.account_tokens) - int(this.npcDetail[this.npcIdx].price_token);
               }
               Character.character_recruit_ids = param1.recruiters[0];
               this.main.HUD.setBasicData();
               this.main.showMessage("Successfully recruited teammate!");
            }
            else
            {
               this.main.getError(204);
            }
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getNotice(param1.error);
         }
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
         this.main.HUD.setBasicData();
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.eventHandler = null;
         this.main = null;
         this.npcInfo = null;
         this.npcDetail = null;
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            GF.removeAllChild(this.panelMC["npcMC" + _loc1_].holder);
            _loc1_++;
         }
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
