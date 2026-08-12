package Popups
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import id.ninjasage.Clan;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public class ClanRecruitManual extends MovieClip
   {
       
      
      public var btn_close:SimpleButton;
      
      public var btn_fight:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var member_0:MovieClip;
      
      public var member_1:MovieClip;
      
      public var member_10:MovieClip;
      
      public var member_2:MovieClip;
      
      public var member_3:MovieClip;
      
      public var member_4:MovieClip;
      
      public var member_5:MovieClip;
      
      public var member_6:MovieClip;
      
      public var member_7:MovieClip;
      
      public var member_8:MovieClip;
      
      public var member_9:MovieClip;
      
      public var txt_page:TextField;
      
      public var txt_recruited:TextField;
      
      public var main;
      
      public var __parent;
      
      public var battle_mode;
      
      public var members:Array;
      
      public var current_page:int = 1;
      
      public var total_page:int = 1;
      
      public var second_popup = null;
      
      public var total_recruited = 0;
      
      public var selected_member_indexs;
      
      public var eventHandler;
      
      private var destroyed = false;
      
      public function ClanRecruitManual(param1:*, param2:*, param3:*)
      {
         this.eventHandler = new EventHandler();
         this.members = [];
         this.selected_member_indexs = [];
         super();
         this.main = param1;
         this.__parent = param2;
         this.battle_mode = param3;
         this.main.loading(true);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.backToBattlePanel);
         this.eventHandler.addListener(this.btn_fight,MouseEvent.CLICK,this.gotoBattleMode);
         Clan.instance.getDefenders(this.showMembersInfo);
         Character.clan_recruits = [];
         Character.clan_recruit_names = [];
      }
      
      public function gotoBattleMode(param1:MouseEvent) : *
      {
         if(Character.character_skill_set == "" || Character.character_skill_set == null)
         {
            this.main.showMessage("Please equip at least 1 skill");
            return;
         }
         this.main.startClanBattle(this.battle_mode);
         this.destroy(false);
      }
      
      public function backToBattlePanel(param1:MouseEvent) : *
      {
         this.destroy(false);
      }
      
      public function showMembersInfo(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice(param1.errorMessage);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("statusCode"))
         {
            this.main.getNotice("Error Code: " + param1.statusCode);
            return;
         }
         if(param1 != null && param1.hasOwnProperty("members"))
         {
            this.members = param1.members;
            this.current_page = 1;
            this.total_page = Math.max(Math.ceil(this.members.length / 11),1);
            this.displayMembers();
            this.txt_page.text = this.current_page + " / " + this.total_page;
            this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
            this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
            return;
         }
         if(param2 != null)
         {
            this.main.getError("Unknown erorr");
            return;
         }
      }
      
      public function updatePageText() : *
      {
         this.txt_page.text = this.current_page + " / " + this.total_page;
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_page > this.current_page)
               {
                  ++this.current_page;
                  this.displayMembers();
               }
               break;
            case "btn_prev":
               if(this.current_page > 1)
               {
                  --this.current_page;
                  this.displayMembers();
               }
         }
         this.updatePageText();
      }
      
      public function displayMembers() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < 11)
         {
            _loc1_ = _loc2_ + (this.current_page - 1) * 11;
            if(this.members.length > _loc1_)
            {
               this["member_" + _loc2_].gotoAndStop(1);
               this["member_" + _loc2_].visible = true;
               if(this.members[_loc1_].char_id == Character.char_id && this["member_" + _loc2_].hasEventListener(MouseEvent.CLICK))
               {
                  this["member_" + _loc2_].removeEventListener(MouseEvent.CLICK,this.selectMember);
               }
               else
               {
                  this.eventHandler.addListener(this["member_" + _loc2_],MouseEvent.CLICK,this.selectMember);
               }
               this["member_" + _loc2_].member_name.htmlText = Character.colorifyText(this.members[_loc1_].char_id,this.members[_loc1_].name,this["member_" + _loc2_].member_name);
               this["member_" + _loc2_].member_level.text = this.members[_loc1_].level;
               this["member_" + _loc2_].member_stamina.text = this.members[_loc1_].stamina;
               this["member_" + _loc2_].member_reputation.text = this.members[_loc1_].reputation;
            }
            else
            {
               this["member_" + _loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      public function resetOtherthis() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 11)
         {
            this["member_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      public function selectMember(param1:MouseEvent) : *
      {
         var _loc2_:* = int(param1.currentTarget.name.replace("member_",""));
         var _loc3_:* = _loc2_ + (this.current_page - 1) * 11;
         if(this.members[_loc3_].char_id == Character.char_id)
         {
            return;
         }
         if(this.total_recruited == 2)
         {
            if(this.selected_member_indexs[0] == _loc3_)
            {
               this.selected_member_indexs = [this.selected_member_indexs[1]];
               this["member_" + _loc2_].gotoAndStop(1);
               --this.total_recruited;
            }
            if(this.selected_member_indexs[1] == _loc3_)
            {
               this.selected_member_indexs = [this.selected_member_indexs[0]];
               this["member_" + _loc2_].gotoAndStop(1);
               --this.total_recruited;
            }
         }
         else if(this.selected_member_indexs.length > 0)
         {
            if(this.selected_member_indexs[0] == _loc3_)
            {
               this.selected_member_indexs = [];
               --this.total_recruited;
               param1.currentTarget.gotoAndStop(1);
            }
            else if(this.selected_member_indexs[1] == _loc3_)
            {
               this.selected_member_indexs = [this.selected_member_indexs[0]];
               --this.total_recruited;
               param1.currentTarget.gotoAndStop(1);
            }
            else
            {
               this.selected_member_indexs.push(_loc3_);
               ++this.total_recruited;
               param1.currentTarget.gotoAndStop(2);
            }
         }
         else
         {
            this.selected_member_indexs.push(_loc3_);
            ++this.total_recruited;
            param1.currentTarget.gotoAndStop(2);
         }
         Character.clan_recruits = [];
         Character.clan_recruit_names = [];
         var _loc4_:* = 0;
         while(_loc4_ < this.selected_member_indexs.length)
         {
            Character.clan_recruits.push("char_" + this.members[this.selected_member_indexs[_loc4_]].char_id);
            Character.clan_recruit_names.push(this.members[this.selected_member_indexs[_loc4_]].name);
            _loc4_++;
         }
         this.txt_recruited.text = String(this.total_recruited);
      }
      
      public function destroy(param1:* = true) : *
      {
         var destroyBattleMode:* = param1;
         Log.debug(this,"DESTROY");
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         this.eventHandler.removeAllEventListeners();
         GF.clearArray(this.members);
         GF.clearArray(this.selected_member_indexs);
         GF.clearArray(Character.clan_recruit_names);
         this.eventHandler = null;
         this.members = null;
         this.selected_member_indexs = null;
         this.main = null;
         this.__parent = null;
         if(destroyBattleMode && this.battle_mode)
         {
            this.battle_mode.destroy();
         }
         if(this.second_popup)
         {
            try
            {
               this.second_popup.destroy();
            }
            catch(e:*)
            {
               Log.error(this,"Destroy",e);
            }
            this.second_popup = null;
         }
         this.battle_mode = null;
         this.second_popup = null;
         GF.removeAllChild(this);
      }
   }
}
