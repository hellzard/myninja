package Panels
{
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import id.ninjasage.Clan;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.Util;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6817")]
   public class ClanMemberRequest extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_accept:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_reject:SimpleButton;
      
      public var btn_rejectAll:SimpleButton;
      
      public var btn_invite_member:SimpleButton;
      
      public var member_0:MovieClip;
      
      public var member_1:MovieClip;
      
      public var member_2:MovieClip;
      
      public var member_3:MovieClip;
      
      public var member_4:MovieClip;
      
      public var member_5:MovieClip;
      
      public var member_6:MovieClip;
      
      public var member_7:MovieClip;
      
      public var addMemberMC:MovieClip;
      
      public var txt_page:TextField;
      
      public var main:*;
      
      public var clan_village:*;
      
      public var clan_hall:*;
      
      public var member_sel_slot:int = -1;
      
      public var member_sel_idx:int = -1;
      
      public var current_page:* = 0;
      
      public var total_page:* = 0;
      
      public var members:Array = [];
      
      public var search:* = "";
      
      public var charData:*;
      
      public var charSets:*;
      
      public var color_1:*;
      
      public var color_2:*;
      
      public var char_id:*;
      
      internal var pop:*;
      
      public var eventHandler:* = new EventHandler();
      
      public function ClanMemberRequest(param1:*, param2:*, param3:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClosePanel);
         this.main = param1;
         this.clan_village = param2;
         this.clan_hall = param3;
         this.addButtonListeners();
         this.clearMemberTable();
         this.updatePageText();
         this.getMembersTable();
         this.addMemberMC.visible = false;
      }
      
      public function updatePageText() : *
      {
         this.txt_page.text = this.current_page + " / " + this.total_page;
      }
      
      public function clearMemberTable(param1:Boolean = false) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < 8)
         {
            this["member_" + _loc2_].gotoAndStop(1);
            if(!this["member_" + _loc2_].hasEventListener(MouseEvent.CLICK))
            {
               this.eventHandler.addListener(this["member_" + _loc2_],MouseEvent.CLICK,this.onSelectMember);
            }
            this["member_" + _loc2_].visible = param1;
            _loc2_++;
         }
      }
      
      public function onSelectMember(param1:MouseEvent) : *
      {
         if(this.member_sel_slot != -1)
         {
            this["member_" + this.member_sel_slot].gotoAndStop(1);
         }
         var _loc2_:* = int(param1.currentTarget.name.replace("member_",""));
         this.member_sel_slot = _loc2_;
         this.member_sel_idx = _loc2_ + (this.current_page - 1) * 8;
         param1.currentTarget.gotoAndStop(2);
      }
      
      public function getMembersTable() : *
      {
         this.main.loading(true);
         Clan.instance.getMemberRequests(this.onGetMembersRes);
      }
      
      public function onGetMembersRes(param1:*, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && Boolean(param1.hasOwnProperty("requests")))
         {
            this.members = param1.requests;
            this.current_page = 1;
            this.total_page = Math.max(Math.ceil(param1.total / 8),1);
            this.displayMembers();
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("errorMessage")))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getError("unknown error");
      }
      
      public function displayMembers() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.updatePageText();
         this.clearMemberTable();
         this.member_sel_idx = -1;
         var _loc5_:* = 0;
         while(_loc5_ < 8)
         {
            _loc1_ = _loc5_ + (this.current_page - 1) * 8;
            if(this.members.length > _loc1_)
            {
               this["member_" + _loc5_].gotoAndStop(1);
               this["member_" + _loc5_].visible = true;
               this["member_" + _loc5_].member_id.text = this.members[_loc1_].char_id;
               this["member_" + _loc5_].member_name.htmlText = Character.colorifyText(this.members[_loc1_].char_id,this.members[_loc1_].name,this["member_" + _loc5_].member_name);
               this["member_" + _loc5_].member_level.text = this.members[_loc1_].level;
               this["member_" + _loc5_].emblemMc.visible = false;
               if(this.members[_loc1_].emblem == 1)
               {
                  this["member_" + _loc5_].emblemMc.visible = true;
               }
               this["member_" + _loc5_].element_1.gotoAndStop(1);
               this["member_" + _loc5_].element_2.gotoAndStop(1);
               this["member_" + _loc5_].element_3.gotoAndStop(1);
               this["member_" + _loc5_].element_4.gotoAndStop(1);
               this["member_" + _loc5_].element_5.gotoAndStop(1);
               _loc2_ = this.members[_loc1_].element_1;
               _loc3_ = this.members[_loc1_].element_2;
               _loc4_ = this.members[_loc1_].element_3;
               if(["element_" + _loc2_] in this["member_" + _loc5_])
               {
                  this["member_" + _loc5_]["element_" + _loc2_].gotoAndStop(2);
               }
               if(["element_" + _loc3_] in this["member_" + _loc5_])
               {
                  this["member_" + _loc5_]["element_" + _loc3_].gotoAndStop(2);
               }
               if(["element_" + _loc4_] in this["member_" + _loc5_])
               {
                  this["member_" + _loc5_]["element_" + _loc4_].gotoAndStop(2);
               }
            }
            else
            {
               this["member_" + _loc5_].visible = false;
            }
            _loc5_++;
         }
      }
      
      public function addButtonListeners() : *
      {
         this.eventHandler.addListener(this.btn_accept,MouseEvent.CLICK,this.onAcceptReq);
         this.eventHandler.addListener(this.btn_reject,MouseEvent.CLICK,this.onRejectReq);
         this.eventHandler.addListener(this.btn_rejectAll,MouseEvent.CLICK,this.onRejectAllReq);
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.onClosePanel);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_invite_member,MouseEvent.CLICK,this.onInviteMember);
      }
      
      public function onInviteMember(param1:MouseEvent) : *
      {
         this.addMemberMC.visible = true;
         this.addMemberMC.characterInfo.visible = false;
         this.addMemberMC.btn_invite_member.visible = false;
         this.eventHandler.addListener(this.addMemberMC.btn_search,MouseEvent.CLICK,this.searchCharacter);
         this.eventHandler.addListener(this.addMemberMC.btn_close,MouseEvent.CLICK,this.closePanelInvite);
      }
      
      public function searchCharacter(param1:MouseEvent) : *
      {
         this.main.loading(true);
         this.addMemberMC.char_id = this.addMemberMC.search.text;
         this.addMemberMC.characterInfo.visible = false;
         this.addMemberMC.btn_invite_member.visible = false;
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.iakN46g0GaJN",[Character.char_id,Character.sessionkey,this.addMemberMC.search.text],this.searchCallback);
      }
      
      public function searchCallback(param1:*) : *
      {
         var _loc4_:Loader = null;
         this.main.loading(false);
         if(param1.status > 1 && Boolean(param1.result))
         {
            this.main.getNotice(param1.result);
            return;
         }
         if(!param1.result && param1.status > 1)
         {
            this.main.getNotice("Unknown error");
            return;
         }
         this.char_id = this.addMemberMC.char_id;
         this.addMemberMC.btn_invite_member.visible = true;
         this.eventHandler.addListener(this.addMemberMC.btn_invite_member,MouseEvent.CLICK,this.sendInviteRequest);
         var _loc2_:* = param1.character_data;
         this.charData = _loc2_;
         this.charSets = param1.character_sets;
         this.addMemberMC.characterInfo.visible = true;
         this.addMemberMC.characterInfo.lvlMC.txt_lvl.text = _loc2_.character_level;
         this.addMemberMC.characterInfo.txt_name.htmlText = Character.colorifyText(this.char_id,_loc2_.character_name,this.addMemberMC.characterInfo.txt_name);
         this.addMemberMC.characterInfo.rankMC.gotoAndStop(_loc2_.character_rank);
         this.addMemberMC.characterInfo.element_1.gotoAndStop(int(_loc2_.character_element_1) + 1);
         this.addMemberMC.characterInfo.element_2.gotoAndStop(int(_loc2_.character_element_2) + 1);
         if(param1.account_type == 0)
         {
            this.addMemberMC.characterInfo.element_3.gotoAndStop(1);
         }
         else
         {
            this.addMemberMC.characterInfo.element_3.gotoAndStop(int(_loc2_.character_element_3) + 1);
         }
         this.addMemberMC.characterInfo.emblemMC.gotoAndStop(int(param1.account_type) + 1);
         this.addMemberMC.characterInfo.talent_1.gotoAndStop(4);
         this.addMemberMC.characterInfo.talent_2.gotoAndStop(4);
         this.addMemberMC.characterInfo.talent_3.gotoAndStop(4);
         var _loc3_:Loader = new Loader();
         this.eventHandler.addListener(_loc3_.contentLoaderInfo,Event.COMPLETE,this.onCompleteHair);
         _loc3_.load(new URLRequest(Util.url("items/" + this.charSets.hairstyle + ".swf")));
         this.eventHandler.addListener((_loc4_ = new Loader()).contentLoaderInfo,Event.COMPLETE,this.onCompleteFace);
         _loc4_.load(new URLRequest(Util.url("items/" + this.charSets.face + ".swf")));
      }
      
      public function onCompleteHair(param1:*) : *
      {
         var hair_mc:*;
         var event:* = param1;
         var back_hair:Class = null;
         var e:* = event;
         var hair:Class = e.target.applicationDomain.getDefinition("hair") as Class;
         this.addMemberMC.hairMC = new hair();
         hair_mc = [];
         if(this.addMemberMC.characterInfo.holder["hair"].numChildren > 0)
         {
            this.addMemberMC.characterInfo.holder["hair"].removeChildAt(0);
         }
         this.addMemberMC.characterInfo.holder["hair"].addChild(this.addMemberMC.hairMC);
         hair_mc.push(this.addMemberMC.hairMC);
         this.addHairColor(0);
         try
         {
            back_hair = e.target.applicationDomain.getDefinition("back_hair") as Class;
            this.addMemberMC.backHairMC = new back_hair();
            if(this.addMemberMC.characterInfo.holder["back_hair"].numChildren > 0)
            {
               this.addMemberMC.characterInfo.holder["back_hair"].removeChildAt(0);
            }
            this.addMemberMC.characterInfo.holder["back_hair"].addChild(this.addMemberMC.backHairMC);
            hair_mc.push(this.addMemberMC.backHairMC);
            this.addHairColor(1);
         }
         catch(e:Error)
         {
            Log.error(this,"hair model error ",e);
         }
      }
      
      public function onCompleteFace(param1:*) : *
      {
         var event:* = param1;
         var ClassDefinition:Class = null;
         var butn:MovieClip = null;
         var e:* = event;
         try
         {
            ClassDefinition = e.target.applicationDomain.getDefinition("face") as Class;
            butn = new ClassDefinition();
            while(this.addMemberMC.characterInfo.holder["face"].numChildren > 0)
            {
               this.addMemberMC.characterInfo.holder["face"].removeChildAt(0);
            }
            this.addMemberMC.characterInfo.holder["face"].addChild(butn);
         }
         catch(e:*)
         {
            Log.error(this,"face model error",e);
         }
      }
      
      public function addHairColor(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:ColorTransform = new ColorTransform();
         var _loc4_:ColorTransform = new ColorTransform();
         _loc2_ = this.charSets.hair_color;
         var _loc5_:* = _loc2_.split("|");
         _loc3_.color = _loc5_[0];
         _loc4_.color = _loc5_[1];
         this.color_1 = _loc5_[0];
         this.color_2 = _loc5_[1];
         if(param1 == 0)
         {
            if(_loc5_[0] != "null")
            {
               this.addMemberMC.hairMC.hair_color_1.transform.colorTransform = _loc3_;
            }
            if(_loc5_[1] != "null")
            {
               this.addMemberMC.hairMC.hair_color_2.transform.colorTransform = _loc4_;
            }
         }
         else
         {
            if(_loc5_[0] != "null")
            {
               this.addMemberMC.backHairMC.hair_color_1.transform.colorTransform = _loc3_;
            }
            if(_loc5_[1] != "null")
            {
               this.addMemberMC.backHairMC.hair_color_2.transform.colorTransform = _loc4_;
            }
         }
      }
      
      internal function killEverythingInvite() : void
      {
         this.addMemberMC.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanelInvite);
         this.addMemberMC.btn_search.removeEventListener(MouseEvent.CLICK,this.closePanelInvite);
         this.addMemberMC.characterInfo.element_1.removeEventListener(MouseEvent.CLICK,this.closePanelInvite);
         this.addMemberMC.characterInfo.element_2.removeEventListener(MouseEvent.CLICK,this.closePanelInvite);
         this.addMemberMC.characterInfo.element_3.removeEventListener(MouseEvent.CLICK,this.closePanelInvite);
         this.addMemberMC.characterInfo.element_3.removeEventListener(MouseEvent.CLICK,this.closePanelInvite);
         this.addMemberMC.characterInfo.emblemMC.removeEventListener(MouseEvent.CLICK,this.closePanelInvite);
         this.addMemberMC.main = null;
      }
      
      internal function closePanelInvite(param1:MouseEvent) : void
      {
         this.killEverythingInvite();
         parent.removeChild(this);
      }
      
      public function sendInviteRequest(param1:MouseEvent) : *
      {
         if(this.char_id == "")
         {
            this.main.getNotice("No char_id!");
            return;
         }
         Clan.instance.inviteCharacter(this.char_id,this.onInviteRequestSent);
      }
      
      public function onInviteRequestSent(param1:Object, param2:* = null) : *
      {
         if(param1 == "ok")
         {
            this.main.giveMessage("Invitation has been sent");
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Unable to send Invitation.\n" + param1.errorMessage);
         }
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
      
      public function onRejectMembersResConf(param1:MouseEvent) : *
      {
         this.main.loading(true);
         Clan.instance.rejectMembers(this.onRejectMemberRes);
      }
      
      public function onRejectAllReq(param1:MouseEvent) : *
      {
         var event:MouseEvent = param1;
         var e:MouseEvent = event;
         this.pop = new Confirmation();
         this.pop.txtMc.txt.text = "Are you sure that you want to reject all requests?";
         this.eventHandler.addListener(this.pop.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(pop);
            this.pop = null;
         });
         this.eventHandler.addListener(this.pop.btn_confirm,MouseEvent.CLICK,this.onRejectMembersResConf);
         addChild(this.pop);
      }
      
      public function onRejectMemberResConf(param1:MouseEvent) : *
      {
         var _loc2_:* = this.members[this.member_sel_idx].char_id;
         this.main.loading(true);
         Clan.instance.rejectMember(_loc2_,this.onRejectMemberRes);
      }
      
      public function onRejectReq(param1:MouseEvent) : *
      {
         var event:MouseEvent = param1;
         var e:MouseEvent = event;
         if(this.member_sel_idx == -1)
         {
            this.main.getNotice("Please select a member first!");
         }
         else
         {
            this.pop = new Confirmation();
            this.pop.txtMc.txt.text = "Are you sure that you want to reject this request?";
            this.eventHandler.addListener(this.pop.btn_close,MouseEvent.CLICK,function():*
            {
               removeChild(pop);
            });
            this.eventHandler.addListener(this.pop.btn_confirm,MouseEvent.CLICK,this.onRejectMemberResConf);
            addChild(this.pop);
         }
      }
      
      public function onRejectMemberRes(param1:Object, param2:* = null) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("result"))
         {
            this.main.getNotice("Member has been rejected");
            this.clearMemberTable();
            setTimeout(this.getMembersTable,1000);
            this.member_sel_idx = -1;
            this.clan_hall.displayTab("general");
            this.clan_village.setDisplay();
            removeChild(this.pop);
            this.pop = null;
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getNotice("Failed to reject the request. Please try again later");
      }
      
      public function onAcceptMembersResConf(param1:MouseEvent) : *
      {
         var _loc2_:* = this.members[this.member_sel_idx].char_id;
         this.main.loading(true);
         Clan.instance.acceptMember(_loc2_,this.onAcceptMemberRes);
      }
      
      public function onAcceptReq(param1:MouseEvent) : *
      {
         var event:MouseEvent = param1;
         var e:MouseEvent = event;
         if(this.member_sel_idx == -1)
         {
            this.main.getNotice("Please select a member first!");
         }
         else
         {
            this.pop = new Confirmation();
            this.pop.txtMc.txt.text = "Are you sure that you want to accept this request?";
            this.eventHandler.addListener(this.pop.btn_close,MouseEvent.CLICK,function():*
            {
               removeChild(pop);
            });
            this.eventHandler.addListener(this.pop.btn_confirm,MouseEvent.CLICK,this.onAcceptMembersResConf);
            addChild(this.pop);
         }
      }
      
      public function onAcceptMemberRes(param1:Object, param2:*) : *
      {
         this.main.loading(false);
         if(param1 != null && param1.hasOwnProperty("result"))
         {
            this.main.getNotice("Member accepted");
            this.clearMemberTable();
            setTimeout(this.getMembersTable,1000);
            this.member_sel_idx = -1;
            this.clan_hall.displayTab("general");
            this.clan_village.setDisplay();
            removeChild(this.pop);
            this.pop = null;
            return;
         }
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            this.main.getNotice("Error: " + param1.errorMessage);
            return;
         }
         this.main.getNotice("Failed to accept the member. Please try again later");
      }
      
      public function onClosePanel(param1:MouseEvent) : *
      {
         parent.removeChild(this);
         this.clan_hall.displayTab("general");
         this.clan_village.setDisplay();
         this.destroy();
      }
      
      public function destroy() : *
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         GF.clearArray(this.members);
         this.pop = null;
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.clan_hall = null;
         this.clan_village = null;
         GF.removeAllChild(this);
      }
   }
}

