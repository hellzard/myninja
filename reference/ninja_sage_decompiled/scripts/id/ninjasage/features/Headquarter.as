package id.ninjasage.features
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class Headquarter extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var head:MovieClip;
      
      private var main;
      
      private var eventHandler:EventHandler;
      
      private var CLASS_NAME_ARR:Array;
      
      public function Headquarter(param1:*, param2:*)
      {
         this.CLASS_NAME_ARR = ["Medical Class","Sensor Class","Intelligence Class","Heavy Attack Class","Surprise Attack Class"];
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.eventHandler = new EventHandler();
         this.main.handleVillageHUDVisibility(false);
         this.panelMC.addFrameScript(42,this.initUI);
      }
      
      public function initUI() : void
      {
         var _loc2_:* = undefined;
         this.panelMC.stop();
         this.panelMC.btn_apply.visible = false;
         this.panelMC.convertMc.visible = false;
         this.panelMC.rankMC.gotoAndStop(Character.character_rank);
         this.panelMC.txt_name.htmlText = Character.colorifyText(Character.char_id,Character.character_name,this.panelMC.txt_name);
         this.panelMC.txt_id.text = Character.char_id;
         if(int(Character.character_rank) == 1)
         {
            this.panelMC.txt_rank.text = "Genin";
         }
         else if(int(Character.character_rank) == 2)
         {
            this.panelMC.txt_rank.text = "Chunin";
         }
         else if(int(Character.character_rank) == 3)
         {
            this.panelMC.txt_rank.text = "Tensai Chunin";
         }
         else if(int(Character.character_rank) == 4)
         {
            this.panelMC.txt_rank.text = "Jounin";
         }
         else if(int(Character.character_rank) == 5)
         {
            this.panelMC.txt_rank.text = "Tensai Jounin";
         }
         else if(int(Character.character_rank) == 6)
         {
            this.panelMC.txt_rank.text = "Special Jounin";
         }
         else if(int(Character.character_rank) == 7)
         {
            this.panelMC.txt_rank.text = "Tensai Special Jounin";
         }
         else if(int(Character.character_rank) == 8)
         {
            this.panelMC.txt_rank.text = "Ninja Tutor";
         }
         else if(int(Character.character_rank) == 9)
         {
            this.panelMC.txt_rank.text = "Senior Ninja Tutor";
         }
         if(Character.character_class != null)
         {
            this.panelMC.classMC.gotoAndStop(Character.character_class);
            _loc2_ = Character.character_class.replace("skill_400","");
            this.panelMC.txt_class.text = this.CLASS_NAME_ARR[_loc2_];
         }
         else
         {
            this.panelMC.classMC.gotoAndStop("classNull");
            this.panelMC.txt_class.text = "Special Class Unavailable";
         }
         this.panelMC.element_1.gotoAndStop(int(Character.character_element_1) + 1);
         this.panelMC.element_2.gotoAndStop(int(Character.character_element_2) + 1);
         if(Character.account_type == 0)
         {
            this.panelMC.element_3.gotoAndStop(1);
         }
         else
         {
            this.panelMC.element_3.gotoAndStop(int(Character.character_element_3) + 1);
         }
         var _loc1_:int = 1;
         while(_loc1_ < 4)
         {
            if(this.panelMC["element_" + _loc1_].currentFrame == 1)
            {
               this.eventHandler.addListener(this.panelMC["element_" + _loc1_],MouseEvent.CLICK,this.openAcademy);
            }
            _loc1_++;
         }
         this.panelMC.txt_gold.text = Character.character_gold;
         this.panelMC.txt_token.text = Character.account_tokens;
         if(int(Character.account_type) == 0)
         {
            this.panelMC.btn_apply.visible = true;
            this.eventHandler.addListener(this.panelMC.btn_apply,MouseEvent.CLICK,this.goToSite1);
         }
         if(int(Character.account_type) == 1 && int(Character.emblem_duration) > 0)
         {
            this.panelMC.btn_apply.visible = true;
            this.eventHandler.addListener(this.panelMC.btn_apply,MouseEvent.CLICK,this.goToSite1);
         }
         if(Character.account_type == 0)
         {
            this.panelMC.emblemMC.gotoAndStop(1);
            this.panelMC.emblemTxt.text = "Free User";
         }
         else
         {
            this.panelMC.emblemMC.gotoAndStop(2);
            this.panelMC.emblemTxt.text = "Ninja Emblem";
         }
         this.eventHandler.addListener(this.panelMC.btn_website,MouseEvent.CLICK,this.goToSite);
         this.eventHandler.addListener(this.panelMC.btn_info,MouseEvent.CLICK,this.infoProfile);
         this.eventHandler.addListener(this.panelMC.btn_convert,MouseEvent.CLICK,this.convertGold);
         this.eventHandler.addListener(this.panelMC.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panelMC.convertMc.btn_cvgold,MouseEvent.CLICK,this.convertAmf);
         this.head = this.main.getPlayerHead();
         this.head.scaleX *= 2.1;
         this.head.scaleY *= 2.1;
         this.panelMC.convertMc.insertedToken.restrict = "0-9.";
         this.panelMC["headHolder"].addChild(this.head);
      }
      
      public function goToSite(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://ninjasage.id/"));
      }
      
      public function goToSite1(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://ninjasage.id/merchants"));
      }
      
      public function convertGold(param1:MouseEvent) : void
      {
         this.panelMC.convertMc.visible = true;
         this.head.visible = false;
         this.panelMC.convertMc.gainedGold.text = 0;
         this.panelMC.convertMc.insertedToken.text = 0;
         this.panelMC.convertMc.ownedGold.text = Character.character_gold;
         this.panelMC.convertMc.ownedToken.text = Character.account_tokens;
         this.eventHandler.addListener(this.panelMC.convertMc.insertedToken,Event.CHANGE,this.convertToGold);
      }
      
      public function convertToGold(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(this.panelMC.convertMc.insertedToken.text);
         if(this.panelMC.convertMc.insertedToken.text > 1000000)
         {
            this.main.getNotice("Maximum Convert is 1.000.000 Token");
            this.panelMC.convertMc.gainedGold.text = 0;
            this.panelMC.convertMc.insertedToken.text = 0;
            this.panelMC.convertMc.ownedToken.text = Character.account_tokens;
         }
         else if(this.panelMC.convertMc.insertedToken.text > Character.account_tokens)
         {
            this.main.getNotice("You Can\'t Convert More Than Your Owned Token");
            this.panelMC.convertMc.gainedGold.text = 0;
            this.panelMC.convertMc.insertedToken.text = 0;
            this.panelMC.convertMc.ownedToken.text = Character.account_tokens;
         }
         else
         {
            this.panelMC.convertMc.gainedGold.text = int(this.panelMC.convertMc.insertedToken.text) * 1000;
            this.panelMC.convertMc.ownedGold.text = int(Character.character_gold) + int(this.panelMC.convertMc.gainedGold.text);
            this.panelMC.convertMc.ownedToken.text = int(Character.account_tokens) - int(this.panelMC.convertMc.insertedToken.text);
         }
      }
      
      public function infoProfile(param1:MouseEvent) : void
      {
         this.panelMC.convertMc.visible = false;
         this.head.visible = true;
      }
      
      public function openAcademy(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Academy");
         this.destroy();
      }
      
      public function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function convertAmf(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.7pRSSHy59yO9",[Character.sessionkey,Character.char_id,this.panelMC.convertMc.insertedToken.text],this.convertRes);
      }
      
      public function convertRes(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.getNotice("Your Token Has Been Converted to Gold!");
            this.panelMC.convertMc.gainedGold.text = 0;
            this.panelMC.convertMc.insertedToken.text = 0;
            this.panelMC.convertMc.ownedToken.text = param1.account_tokens;
            this.panelMC.convertMc.ownedGold.text = param1.character_gold;
            Character.character_gold = String(param1.character_gold);
            Character.account_tokens = int(param1.account_tokens);
            this.main.HUD.setBasicData();
         }
         else
         {
            this.main.getNotice("Please Insert At Least 1 Token!");
         }
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.handleVillageHUDVisibility(true);
         this.eventHandler.removeAllEventListeners();
         this.main.removeExternalSwfPanel();
         this.main = null;
         this.eventHandler = null;
         this.CLASS_NAME_ARR = [];
         GF.removeAllChild(this.head);
         GF.removeAllChild(this.panelMC.headHolder);
         GF.removeAllChild(this.panelMC);
         System.gc();
      }
   }
}
