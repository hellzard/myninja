package Popups
{
   import Managers.OutfitManager;
   import Storage.Character;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   import id.ninjasage.Log;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7113")]
   public class ClanBattleResults extends MovieClip
   {
      
      public var bgHolder:MovieClip;
      
      public var loseClanTxt:TextField;
      
      public var loseRepTxt:TextField;
      
      public var loseTotalRepTxt:TextField;
      
      public var okBtn:SimpleButton;
      
      public var winClanTxt:TextField;
      
      public var winRepTxt:TextField;
      
      public var winTotalRepTxt:TextField;
      
      public var main:*;
      
      public var main2:* = null;
      
      public var __parent:* = null;
      
      private var destroyed:* = false;
      
      public function ClanBattleResults(param1:*, param2:* = null, param3:* = null)
      {
         super();
         this.main = param1;
         this.main2 = param3;
         this.__parent = param2;
      }
      
      public function onOk(param1:MouseEvent) : *
      {
         this.okBtn.removeEventListener(MouseEvent.CLICK,this.onOk);
         if(this.__parent != null)
         {
            parent.removeChild(this);
            this.destroy();
         }
         else if(this.main2 != null && Boolean(this.main2.man_pan))
         {
            this.main2.loader.removeChild(this);
            if(this.main2.man_pan.__parent)
            {
               this.main2.man_pan.__parent.char_data = Character.clan_char_data;
               this.main2.man_pan.__parent.clan_data = Character.clan_data;
               this.main2.man_pan.__parent.setDisplay();
               if(this.main2.man_pan.__parent.battle_panel.second_popup.second_popup != null)
               {
                  this.main2.man_pan.__parent.removeChild(this.main2.man_pan.__parent.battle_panel.second_popup.second_popup);
               }
               if(this.main2.man_pan.__parent.battle_panel != null)
               {
                  this.main2.man_pan.__parent.removeChild(this.main2.man_pan.__parent.battle_panel);
               }
            }
            this.main2.man_pan.destroy();
            this.main2.man_pan = null;
            this.main2 = null;
            this.destroy();
         }
         else
         {
            if(this.main.man_pan)
            {
               this.main.man_pan.__parent.destroy();
               this.main.man_pan.__parent = null;
               this.main.man_pan.destroy();
               this.main.man_pan = null;
            }
            OutfitManager.removeChildsFromMovieClips(this.main.loader);
            this.getClanStatusReq();
         }
      }
      
      internal function getClanStatusReq() : *
      {
         this.main.loading(true);
         Clan.instance.getClanData(this.onGetClanResNew);
      }
      
      public function onGetClanResNew(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("clan")) && Boolean(param1.hasOwnProperty("char")))
         {
            Character.clan_data = param1.clan;
            Character.clan_char_data = param1.char;
            this.main.loadPanel("Panels.ClanVillage");
            this.destroy();
            return;
         }
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("statusCode")) && param1.statusCode == 404)
         {
            this.main.loadPanel("Panels.ClanCreate");
            this.destroy();
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice(param1.errorMessage);
            this.destroy();
            return;
         }
         if(param2 != null)
         {
            this.main.getError("");
            this.destroy();
            return;
         }
      }
      
      public function onGetClanRes(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status == 1)
            {
               Character.clan_data = param1.clan_data;
               Character.clan_char_data = param1.char_data;
               this.main.loadPanel("Panels.ClanVillage");
            }
            else
            {
               if(param1.status == 5)
               {
                  this.main.loadPanel("Panels.ClanCreate");
                  this.destroy();
                  return;
               }
               this.main.getNotice(param1.result);
            }
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.destroy();
      }
      
      public function updateDisplay(param1:*) : *
      {
         this.okBtn.addEventListener(MouseEvent.CLICK,this.onOk);
         this.winClanTxt.text = Character.clan_data.name;
         this.winRepTxt.text = param1.gain;
         this.winTotalRepTxt.text = param1.reputation;
         this.loseClanTxt.text = param1.opponent_name;
         this.loseRepTxt.text = "-";
         this.loseTotalRepTxt.text = param1.opponent_reputation.toFixed(0);
         Character.clan_char_data.prestige = int(Character.clan_char_data.prestige) + param1.prestige;
         if(this.__parent != null)
         {
            this.__parent.setDisplay();
         }
      }
      
      public function destroy() : *
      {
         Log.debug(this,"DESTROY");
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         if(this.main.combat != null)
         {
            this.main.combat.destroy();
            this.main.getLoader("combat").removeAll();
            this.main.getLoader("assets").removeAll();
            this.main.battleCount = 0;
            if(this.main.getLoader("skills").itemsTotal > 16)
            {
               this.main.getLoader("skills").removeAll();
            }
            if(this.main.getLoader("talents").itemsTotal > 8)
            {
               this.main.getLoader("talents").removeAll();
            }
            this.main.getLoader("specialclass").removeAll();
         }
         this.main = null;
         this.main2 = null;
         this.__parent = null;
      }
   }
}

