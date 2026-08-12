package Panels
{
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class DailyRoulette extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panel:MovieClip;
      
      public var main;
      
      var roulette;
      
      var eventHandler;
      
      public function DailyRoulette(param1:*)
      {
         this.eventHandler = new EventHandler();
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.panel.roulette.gotoAndStop(11);
         this.panel.consecutive.gotoAndStop(0);
         this.eventHandler.addListener(this.panel.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.panel.btn_spin,MouseEvent.CLICK,this.spin);
         this.getData();
      }
      
      public function getData() : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("9lesJAskXMl8M5RC.MSxUfvkezsEs",[Character.char_id,Character.sessionkey],this.onGetData);
      }
      
      public function onGetData(param1:*) : *
      {
         this.main.loading(false);
         if(param1.status > 1)
         {
            this.main.getNotice(param1.result);
            return;
         }
         if(param1.status == 0)
         {
            this.main.getNotice("Unknown error");
            return;
         }
         this.panel.consecutive.gotoAndStop(int(param1.bonus));
         if(int(param1.can_spin) == 1)
         {
            this.panel.btn_spin.visible = true;
         }
         else
         {
            this.main.giveMessage("You can spin again tomorrow");
            this.panel.btn_spin.visible = false;
         }
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.main = null;
         this.panel.roulette = null;
         this.roulette = null;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         parent.removeChild(this);
      }
      
      public function spin(param1:MouseEvent) : *
      {
         this.panel.roulette.gotoAndPlay(1);
         var _loc2_:Timer = new Timer(800,1);
         _loc2_.start();
         this.eventHandler.addListener(_loc2_,TimerEvent.TIMER_COMPLETE,this.startAmf);
         this.panel.btn_spin.removeEventListener(MouseEvent.CLICK,this.spin);
      }
      
      public function startAmf(param1:*) : *
      {
         this.main.amf_manager.service("9lesJAskXMl8M5RC.h7DCMvsTP0iu",[Character.char_id,Character.sessionkey],this.spinRewards);
      }
      
      private function spinRewards(param1:*) : void
      {
         this.panel.btn_spin.removeEventListener(MouseEvent.CLICK,this.spin);
         if(int(param1.status) == 1)
         {
            Character.character_xp = param1.xp;
            Character.account_tokens = int(param1.tokens);
            Character.character_gold = param1.gold;
            this.main.giveReward(1,param1.reward_string);
            this.panel.roulette.gotoAndStop(int(param1.reward));
            this.panel.consecutive.gotoAndStop(int(param1.bonus));
         }
         else if(int(param1.status) == 2)
         {
            this.main.giveMessage("You Can Spin Again Tomorrow!");
            this.panel.roulette.gotoAndStop(10);
            this.panel.consecutive.gotoAndStop(1);
         }
         else
         {
            this.main.getNotice("Unknown Error");
            this.panel.roulette.gotoAndStop(10);
            this.panel.consecutive.gotoAndStop(1);
         }
         this.panel.roulette.last_frame.gotoAndStop(34);
         if(param1.level_up == true)
         {
            Character.character_lvl = String(int(Character.character_lvl) + 1);
            Character.character_xp = param1.xp;
            this.main.levelUp();
         }
      }
   }
}
