package Popups
{
   import Managers.NinjaSage;
   import Managers.Optimizer;
   import Managers.OutfitManager;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   import id.ninjasage.Crew;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.GradientText;
   import id.ninjasage.features.LinkMenu;
   
   public class MissionReward extends MovieClip
   {
       
      
      public var dmgIcon:MovieClip;
      
      public var leagueIcon:MovieClip;
      
      public var meritIcon:MovieClip;
      
      public var txt_dmg:TextField;
      
      public var txt_merit:TextField;
      
      public var txt_trophy:TextField;
      
      public var battleStatus:TextField;
      
      public var bg:MovieClip;
      
      public var btn_claim:SimpleButton;
      
      public var item0:MovieClip;
      
      public var item1:MovieClip;
      
      public var item2:MovieClip;
      
      public var item3:MovieClip;
      
      public var item4:MovieClip;
      
      public var item5:MovieClip;
      
      public var item6:MovieClip;
      
      public var item7:MovieClip;
      
      public var item8:MovieClip;
      
      public var item9:MovieClip;
      
      public var txt_gold:TextField;
      
      public var txt_xp:TextField;
      
      public var _main;
      
      private var escapeKey:EscapeKeyManager;
      
      private var destroyed = false;
      
      public function MissionReward(param1:*, param2:String, param3:String, param4:String, param5:Object = null)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePop);
         this._main = param1;
         this.txt_xp.text = param2;
         this.txt_gold.text = param3;
         this.txt_trophy.visible = false;
         this.txt_merit.visible = false;
         this.txt_dmg.visible = false;
         this.leagueIcon.visible = false;
         this.meritIcon.visible = false;
         this.dmgIcon.visible = false;
         if(param5 != null && param5.trophy != null)
         {
            this.txt_trophy.visible = true;
            this.leagueIcon.visible = true;
            this.txt_trophy.text = param5.trophy + " (+" + param5.win_trophy + ")";
            this.leagueIcon.gotoAndStop(param5.rank + 1);
         }
         else if(param5 != null && param5.hasOwnProperty("data"))
         {
            this.txt_merit.visible = true;
            this.txt_dmg.visible = true;
            this.meritIcon.visible = true;
            this.dmgIcon.visible = true;
            this.txt_merit.text = "+" + param5.data.m;
            this.txt_dmg.text = "+" + param5.data.d;
         }
         this.btn_claim.addEventListener(MouseEvent.CLICK,this.closePop,false,0,true);
      }
      
      function closePop(param1:MouseEvent) : void
      {
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         System.gc();
         this.btn_claim.removeEventListener(MouseEvent.CLICK,this.closePop);
         OutfitManager.removeChildsFromMovieClips(this._main.loader);
         var _loc2_:* = 0;
         while(_loc2_ < 10)
         {
            this["item" + _loc2_].tooltip = null;
            GF.removeAllChild(this["item" + _loc2_].iconHolder);
            _loc2_++;
         }
         GradientText.removeAll();
         NinjaSage.clearLoader();
         OutfitManager.clearStaticMc();
         if(this._main.combat != null)
         {
            this._main.combat.destroy();
            this._main.combat = null;
            this._main.getLoader("combat").removeAll();
            this._main.getLoader("assets").removeAll();
            if(this._main.battleCount >= 3)
            {
               this._main.battleCount = 0;
            }
            this._main.getLoader("skills").removeAll();
            this._main.getLoader("talents").removeAll();
            this._main.getLoader("specialclass").removeAll();
         }
         if(this._main.man_pan != null)
         {
            this._main.man_pan.__parent.destroy();
            this._main.man_pan.__parent = null;
            this._main.man_pan.destroy();
            this._main.man_pan = null;
         }
         Clan.instance.delayDestroy(false);
         Clan.instance.destroy();
         Crew.instance.delayDestroy(false);
         Crew.instance.destroy();
         GF.removeAllChild(this);
         Optimizer.killAllListeners();
         this._main.stopAllBgm();
         this._main.startBgm();
         this._main.clearEvents();
         this._main.loadVillageAndHUD();
         if(Character.is_squad_war)
         {
            Character.is_squad_war = false;
            this._main.loadExternalSwfPanel("ArenaVillage","ArenaVillage");
         }
         if(Character.is_crew_war)
         {
            Character.is_crew_war = false;
            LinkMenu.open(LinkMenu.CrewWar);
         }
         if(this._main.is_exam_stage5)
         {
            Character.character_recruit_ids = [];
         }
         Character.resetBattleInfo(this._main);
         this._main = null;
      }
   }
}
