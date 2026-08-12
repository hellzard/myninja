package Panels
{
   import Popups.Confirmation;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   import id.ninjasage.features.RewardScrollPane;
   import id.ninjasage.features.TextScrollPane;
   
   public class Mailbox extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var contentMc:MovieClip;
      
      public var listMc:MovieClip;
      
      public var main;
      
      public var mails:Array;
      
      public var curr_page = 1;
      
      public var total_page = 1;
      
      public var current_mail;
      
      public var rws:Array;
      
      public var eventHandler;
      
      public var confirmation;
      
      public var textPane:TextScrollPane;
      
      public var rewardPane:RewardScrollPane;
      
      public function Mailbox(param1:*)
      {
         this.eventHandler = new EventHandler();
         this.textPane = new TextScrollPane();
         this.mails = [];
         this.rws = [];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClose);
         this.main = param1;
         this.gotoAndStop(1);
         this.addButtonListeners();
         this.setDisplay();
         this.getMails();
         this.updatePageText();
      }
      
      public function updatePageText() : *
      {
         this.listMc.txt_page.text = this.curr_page + "/" + this.total_page;
      }
      
      public function addButtonListeners() : *
      {
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.onClose);
         this.eventHandler.addListener(this.listMc.btn_prev,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.listMc.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.listMc.btn_claim,MouseEvent.CLICK,this.confirmationMessage);
         this.eventHandler.addListener(this.listMc.btn_delete,MouseEvent.CLICK,this.confirmationMessage);
      }
      
      public function setDisplay() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            this.listMc["mail_" + _loc1_].visible = false;
            this.eventHandler.removeListener(this.listMc["mail_" + _loc1_],MouseEvent.CLICK,this.openMailInfo);
            this.eventHandler.addListener(this.listMc["mail_" + _loc1_],MouseEvent.CLICK,this.openMailInfo);
            _loc1_++;
         }
      }
      
      public function confirmationMessage(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         var name:* = e.currentTarget.name.replace("btn_","");
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to " + name + " all mail that contain rewards?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         if(name == "claim")
         {
            this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onClaimAll);
         }
         else
         {
            this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onDeleteAll);
         }
         addChild(this.confirmation);
      }
      
      public function onClaimAll(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["wZJOCM18ykM0",[Character.char_id,Character.sessionkey]],this.claimAllResponse);
      }
      
      public function onDeleteAll(param1:MouseEvent) : *
      {
         removeChild(this.confirmation);
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["cIsq6Q02UKpL",[Character.char_id,Character.sessionkey]],this.onResponse);
      }
      
      public function onResponse(param1:Object) : *
      {
         if(param1.status == 1)
         {
            this.backToMails();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function claimAllResponse(param1:Object = null) : *
      {
         if(param1.status == 1)
         {
            if(param1.rewards != "")
            {
               this.main.giveReward(1,param1.rewards);
               this.main.showMessage(param1.result);
            }
            else
            {
               this.main.showMessage(param1.result);
            }
            this.backToMails();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function deleteConfirmation(param1:MouseEvent) : void
      {
         this.main.showConfirmation("Are you sure that you want to delete this mail?",this.deleteMail);
      }
      
      public function deleteMail(param1:MouseEvent) : *
      {
         var _loc2_:* = this.current_mail.mail_id;
         this.main.loading(true);
         var _loc3_:Array = [Character.char_id,Character.sessionkey,_loc2_];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["mIqNoM3WyxKI",_loc3_],this.onDeleteMail);
      }
      
      public function onDeleteMail(param1:Object) : *
      {
         this.main.loading(false);
         if("result" in param1)
         {
            this.main.getNotice(param1.result);
         }
         else
         {
            this.main.getNotice("Mail has been deleted!");
            this.backToMails();
         }
      }
      
      public function backToMails(param1:MouseEvent = null) : *
      {
         this.gotoAndStop(1);
         this.setDisplay();
         this.displayMails();
         this.updatePageText();
         this.addButtonListeners();
      }
      
      public function acceptFriendRequest(param1:MouseEvent) : *
      {
         this.eventHandler.removeListener(this.contentMc.actionHolder.btn_acceptinvite,MouseEvent.CLICK,this.acceptFriendRequest);
         var _loc2_:* = this.current_mail.mail_id;
         this.main.loading(true);
         var _loc3_:Array = [Character.char_id,Character.sessionkey,_loc2_];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["acceptFriendRequest",_loc3_],this.onFriendAccepted);
      }
      
      public function onFriendAccepted(param1:Object) : *
      {
         this.main.loading(false);
         this.main.getNotice(param1.result);
         this.backToMails();
      }
      
      public function acceptClanInvitation(param1:MouseEvent) : *
      {
         this.eventHandler.removeListener(this.contentMc.actionHolder.btn_acceptinvite,MouseEvent.CLICK,this.acceptFriendRequest);
         var _loc2_:* = this.current_mail.mail_id;
         this.main.loading(true);
         var _loc3_:Array = [Character.char_id,Character.sessionkey,_loc2_];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["QE8tzxAcqlB7",_loc3_],this.onClanAccpeted);
      }
      
      public function onClanAccpeted(param1:Object) : *
      {
         this.main.loading(false);
         this.main.getNotice(param1.result);
         this.backToMails();
      }
      
      public function openMailInfo(param1:MouseEvent) : *
      {
         var event:MouseEvent = param1;
         var m:* = int(event.currentTarget.name.replace("mail_",""));
         m += (int(this.curr_page) - 1) * 4;
         this.current_mail = this.mails[m];
         var params:Array = [Character.char_id,Character.sessionkey,this.current_mail.mail_id];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["mPoTCrq5T8Vy",params],function(param1:*):*
         {
         });
         this.gotoAndStop(2);
         this.contentMc.scrollPaneHolder.addChild(this.textPane.getScrollPane());
         this.contentMc.btn_claim.visible = false;
         this.eventHandler.addListener(this.contentMc.backBtn,MouseEvent.CLICK,this.backToMails);
         this.eventHandler.addListener(this.contentMc.deleteBtn,MouseEvent.CLICK,this.deleteConfirmation);
         this.contentMc.titleTxt.text = this.current_mail.mail_title;
         this.contentMc.senderTxt.text = this.current_mail.mail_sender;
         this.contentMc.dateTxt.text = this.current_mail.sent_date;
         this.textPane.updatePane({
            "text":this.current_mail.mail_body,
            "text_width":400.9,
            "width":498.9,
            "height":120.85,
            "font_size":14,
            "font_name":"Franklin Gothic Demi",
            "font_color":16777215,
            "align":"left",
            "x":0,
            "y":0,
            "scroll_visible":"auto"
         });
         this.contentMc.btn_claim.visible = false;
         this.contentMc.actionHolder.x = 305;
         this.contentMc.actionHolder.y = 365;
         if(this.current_mail.mail_type == 2)
         {
            this.contentMc.actionHolder.gotoAndStop(2);
            this.eventHandler.addListener(this.contentMc.actionHolder.btn_acceptinvite,MouseEvent.CLICK,this.acceptFriendRequest);
         }
         else if(this.current_mail.mail_type == 3 || this.current_mail.mail_type == 6)
         {
            this.contentMc.actionHolder.gotoAndStop(1);
            this.eventHandler.addListener(this.contentMc.actionHolder.btn_acceptinvite,MouseEvent.CLICK,this.acceptClanInvitation);
         }
         else if(this.current_mail.mail_type == 4)
         {
            this.contentMc.actionHolder.gotoAndStop(5);
            this.displayRewardIcons();
            this.contentMc.actionHolder.x = 400;
            this.contentMc.actionHolder.y = 260;
         }
         else if(this.current_mail.mail_type == 5)
         {
            this.contentMc.actionHolder.gotoAndStop(5);
            this.displayRewardIcons(true);
         }
         else
         {
            this.contentMc.actionHolder.visible = false;
         }
         Character.has_notification = false;
         this.main.HUD.checkNotification();
      }
      
      public function claimRewards(param1:MouseEvent) : *
      {
         var _loc2_:* = this.current_mail.mail_id;
         this.main.loading(true);
         var _loc3_:Array = [Character.char_id,Character.sessionkey,_loc2_];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["QeshfBPhDdSA",_loc3_],this.onClaimMailRewards);
      }
      
      public function onClaimMailRewards(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status != 1)
         {
            if(param1.status == 0)
            {
               this.main.getError(param1.error);
            }
            else
            {
               this.main.getNotice(param1.result);
            }
            return;
         }
         var _loc2_:* = 0;
         while(_loc2_ < 13)
         {
            GF.removeAllChild(this.contentMc.actionHolder["rewardIcon_" + _loc2_].iconMc.rewardIcon.iconHolder);
            GF.removeAllChild(this.contentMc.actionHolder["rewardIcon_" + _loc2_].iconMc.skillIcon.iconHolder);
            _loc2_++;
         }
         Character.addRewards(param1.rewards);
         this.main.giveReward(1,param1.rewards);
         this.main.HUD.setBasicData();
         this.backToMails();
      }
      
      public function displayRewardIcons(param1:Boolean = false) : *
      {
         this.rws = [this.current_mail.mail_rewards];
         if(this.current_mail.mail_rewards.indexOf(",") >= 0)
         {
            this.rws = this.current_mail.mail_rewards.split(",");
         }
         this.contentMc.btn_claim.visible = false;
         if(param1)
         {
            this.contentMc.actionHolder.x = 370;
            this.contentMc.actionHolder.y = 260;
            if(int(this.current_mail.mail_claimed) == 0)
            {
               this.contentMc.btn_claim.visible = true;
            }
            else
            {
               this.contentMc.btn_claim.visible = false;
            }
            this.eventHandler.addListener(this.contentMc.btn_claim,MouseEvent.CLICK,this.claimRewards);
         }
         else
         {
            this.contentMc.actionHolder.x = 330;
            this.contentMc.actionHolder.y = 388;
         }
         this.contentMc.actionHolder.visible = false;
         this.rewardPane = new RewardScrollPane();
         this.contentMc.scrollPaneHolder1.addChild(this.rewardPane.getRewardPane());
         this.rewardPane.updateRewardPane({
            "rewards":this.rws,
            "item_per_line":1,
            "width":524,
            "height":(this.rws.length >= 8 ? 69 : 75),
            "x":(this.rws.length >= 8 ? 47 : 61),
            "y":105,
            "scaleX":(this.rws.length >= 8 ? 0.46 : 0.6),
            "scaleY":(this.rws.length >= 8 ? 0.46 : 0.6),
            "scroll_direction":"horizontal",
            "scroll_visible":true
         });
      }
      
      public function getMails() : *
      {
         this.main.loading(true);
         var _loc1_:Array = [Character.char_id,Character.sessionkey];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["BLYQQn0JOp3A",_loc1_],this.onGetMails);
      }
      
      public function onGetMails(param1:Object) : *
      {
         this.mails = param1.mails;
         this.total_page = Math.max(Math.ceil(this.mails.length / 4),1);
         if(this.total_page < 1)
         {
            this.total_page = 1;
         }
         if(this.curr_page > this.total_page)
         {
            this.curr_page = this.total_page;
         }
         if(this.curr_page < 1)
         {
            this.curr_page = 1;
         }
         this.updatePageText();
         this.displayMails();
      }
      
      public function displayMails() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < 4)
         {
            this.listMc["mail_" + _loc2_].visible = false;
            _loc1_ = _loc2_ + (int(this.curr_page) - 1) * 4;
            if(this.mails.length > _loc1_)
            {
               this.listMc["mail_" + _loc2_].visible = true;
               this.listMc["mail_" + _loc2_].new_mc.visible = false;
               this.listMc["mail_" + _loc2_].titleTxt.text = this.mails[_loc1_].mail_title;
               this.listMc["mail_" + _loc2_].senderTxt.text = this.mails[_loc1_].mail_sender;
               this.listMc["mail_" + _loc2_].dateTxt.text = this.mails[_loc1_].sent_date;
               if(this.mails[_loc1_].mail_viewed == 0)
               {
                  this.listMc["mail_" + _loc2_].new_mc.visible = true;
               }
            }
            _loc2_++;
         }
         this.main.loading(false);
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btn_next":
               if(this.total_page > this.curr_page)
               {
                  ++this.curr_page;
                  this.displayMails();
                  break;
               }
               break;
            case "btn_prev":
               if(this.curr_page > 1)
               {
                  --this.curr_page;
                  this.displayMails();
                  break;
               }
         }
         this.updatePageText();
      }
      
      public function onClose(param1:MouseEvent) : *
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
         this.eventHandler.removeAllEventListeners();
         this.eventHandler = null;
         this.main = null;
         this.mails = null;
         this.rws = null;
         this.confirmation = null;
         this.current_mail = null;
         if(this.textPane != null)
         {
            this.textPane.destroy();
            this.textPane = null;
         }
         if(this.rewardPane != null)
         {
            this.rewardPane.destroy();
            this.rewardPane = null;
         }
         GF.removeAllChild(this);
      }
   }
}
