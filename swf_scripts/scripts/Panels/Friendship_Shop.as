package Panels
{
   import Managers.NinjaSage;
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2474")]
   public dynamic class Friendship_Shop extends MovieClip
   {
      
      public var btn_close:SimpleButton;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_fk0:MovieClip;
      
      public var btn_fk1:MovieClip;
      
      public var btn_fk2:MovieClip;
      
      public var btn_fk3:MovieClip;
      
      public var btn_fk4:MovieClip;
      
      public var btn_fk5:MovieClip;
      
      public var btn_fk6:MovieClip;
      
      public var btn_fk7:MovieClip;
      
      public var btn_fk8:MovieClip;
      
      public var btn_fk9:MovieClip;
      
      public var iconMc0:MovieClip;
      
      public var iconMc1:MovieClip;
      
      public var iconMc2:MovieClip;
      
      public var iconMc3:MovieClip;
      
      public var iconMc4:MovieClip;
      
      public var iconMc5:MovieClip;
      
      public var iconMc6:MovieClip;
      
      public var iconMc7:MovieClip;
      
      public var iconMc8:MovieClip;
      
      public var iconMc9:MovieClip;
      
      public var banner:MovieClip;
      
      public var txt_kunai:TextField;
      
      public var btn_get_kunai:SimpleButton;
      
      public var main:*;
      
      private var eventHandler:EventHandler;
      
      private var confirmation:Confirmation;
      
      private var rewardData:Array;
      
      private var selectedExchange:int;
      
      private const FRIENDSHIP_KUNAI:String = "material_1002";
      
      public function Friendship_Shop(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.eventHandler = new EventHandler();
         this.rewardData = [];
         this.getData();
      }
      
      private function getData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.8V4eFxyCDQwm",[Character.char_id,Character.sessionkey],this.onGetData);
      }
      
      private function onGetData(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.rewardData = param1.items;
            this.initUI();
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
            this.destroy();
         }
      }
      
      private function initUI() : void
      {
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_get_kunai,MouseEvent.CLICK,this.closePanel);
         this.main.initButton(this.banner,this.closePanel,"Challenge Friend");
         var _loc1_:String = "Receive a \'Friendship Kunai\' After Winning Challenge Friends!";
         NinjaSage.showDynamicTooltip(this.btn_get_kunai,_loc1_);
         NinjaSage.showDynamicTooltip(this.banner,_loc1_);
         this.txt_kunai.text = Character.getMaterialAmount(this.FRIENDSHIP_KUNAI);
         var _loc2_:int = 0;
         while(_loc2_ < this.rewardData.length)
         {
            this["btn_fk" + _loc2_].metaData = {"id":this.rewardData[_loc2_].id};
            this.main.initButton(this["btn_fk" + _loc2_],this.exchangeConfirmation,this.rewardData[_loc2_].price);
            this["iconMc" + _loc2_].amtTxt.visible = false;
            this["iconMc" + _loc2_].ownedTxt.visible = false;
            NinjaSage.loadItemIcon(this["iconMc" + _loc2_],this.rewardData[_loc2_].item);
            _loc2_++;
         }
      }
      
      private function exchangeConfirmation(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         this.selectedExchange = e.currentTarget.metaData.id;
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure want to exchange this reward?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            GF.removeAllChild(confirmation);
            confirmation = null;
         });
         this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.exchangeItem);
         this.addChild(this.confirmation);
      }
      
      private function exchangeItem(param1:MouseEvent) : void
      {
         GF.removeAllChild(this.confirmation);
         this.confirmation = null;
         this.main.loading(true);
         this.main.amf_manager.service("OvAKMASEbHeDKgxc.lXQs29BRrtfm",[Character.char_id,Character.sessionkey,this.selectedExchange],this.exchangeResponse);
      }
      
      private function exchangeResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.addRewards(param1.reward);
            Character.replaceMaterials(this.FRIENDSHIP_KUNAI,param1.kunai);
            this.main.giveReward(1,param1.reward);
            this.main.HUD.setBasicData();
            this.txt_kunai.text = Character.getMaterialAmount(this.FRIENDSHIP_KUNAI);
         }
         else
         {
            this.main.showMessage(param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
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
         GF.removeAllChild(this.confirmation);
         GF.removeAllChild(this);
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.rewardData = null;
         this.confirmation = null;
         this.main = null;
         System.gc();
      }
   }
}

