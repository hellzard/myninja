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
   
   public class NewMailbox extends MovieClip
   {
       
      
      public var btn_all:SimpleButton;
      
      public var clanMc:MovieClip;
      
      public var crewMc:MovieClip;
      
      public var generalMc:MovieClip;
      
      public var listMc:MovieClip;
      
      public var optionMc:MovieClip;
      
      public var rewardMc:MovieClip;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var main;
      
      public var mails:Array;
      
      public var allMails:Array;
      
      public var generalMails:Array;
      
      public var clanMails:Array;
      
      public var crewMails:Array;
      
      public var rewardMails:Array;
      
      public var curr_page = 1;
      
      public var total_page = 1;
      
      public var current_mail;
      
      public var rws:Array;
      
      public var eventHandler;
      
      public var confirmation;
      
      public var textPane:TextScrollPane;
      
      public var rewardPane:RewardScrollPane;
      
      public function NewMailbox(param1:*)
      {
         this.eventHandler = new EventHandler();
         this.mails = [];
         this.allMails = [];
         this.rws = [];
         this.generalMails = [];
         this.clanMails = [];
         this.crewMails = [];
         this.rewardMails = [];
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.onClose);
         this.main = param1;
         this.initUI();
         this.addButtonListeners();
         this.getMails();
         this.updatePageText();
      }
      
      public function initUI() : void
      {
         this.listMc.visible = true;
         this.generalMc.visible = false;
         this.rewardMc.visible = false;
         this.clanMc.visible = false;
         this.crewMc.visible = false;
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
         this.eventHandler.addListener(this.btn_all,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.optionMc.btn_general,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.optionMc.btn_clan,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.optionMc.btn_crew,MouseEvent.CLICK,this.changeCategory);
         this.eventHandler.addListener(this.optionMc.btn_reward,MouseEvent.CLICK,this.changeCategory);
      }
      
      public function changeCategory(param1:MouseEvent) : *
      {
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         switch(_loc2_)
         {
            case "general":
               this.mails = this.generalMails;
               break;
            case "clan":
               this.mails = this.clanMails;
               break;
            case "crew":
               this.mails = this.crewMails;
               break;
            case "reward":
               this.mails = this.rewardMails;
               break;
            default:
               this.mails = this.allMails;
         }
         this.curr_page = 1;
         this.total_page = Math.max(Math.ceil(this.mails.length / 5),1);
         this.updatePageText();
         this.displayMails();
      }
      
      public function confirmationMessage(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         var name:* = e.currentTarget.name.replace("btn_","");
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to " + name + " all mail that contain rewards?";
         this.eventHandler.addListener(this.confirmation.btn_close,MouseEvent.CLICK,function():*
         {
            GF.removeAllChild(confirmation);
         });
         if(name == "claim")
         {
            this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onClaimAll);
         }
         else
         {
            this.eventHandler.addListener(this.confirmation.btn_confirm,MouseEvent.CLICK,this.onDeleteAll);
         }
         this.addChild(this.confirmation);
      }
      
      public function onClaimAll(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["wZJOCM18ykM0",[Character.char_id,Character.sessionkey]],this.claimAllResponse);
      }
      
      public function onDeleteAll(param1:MouseEvent) : *
      {
         GF.removeAllChild(this.confirmation);
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
         var _loc2_:int = this.current_mail.mail_id;
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
         this.initUI();
         this.displayMails();
         this.updatePageText();
         this.addButtonListeners();
         if(this.rewardPane != null)
         {
            this.rewardPane.destroy();
            this.rewardPane = null;
         }
         if(this.textPane != null)
         {
            this.textPane.destroy();
            this.textPane = null;
         }
      }
      
      public function openMailInfo(param1:MouseEvent) : *
      {
         var e:MouseEvent = param1;
         var mc:MovieClip = null;
         var m:* = int(e.currentTarget.name.replace("mail_",""));
         m += (int(this.curr_page) - 1) * 5;
         this.current_mail = this.mails[m];
         var params:Array = [Character.char_id,Character.sessionkey,this.current_mail.mail_id];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["mPoTCrq5T8Vy",params],function(param1:*):*
         {
         });
         this.listMc.visible = false;
         if(this.current_mail.mail_type == 1)
         {
            mc = this.generalMc;
         }
         else if(this.current_mail.mail_type == 3)
         {
            mc = this.clanMc;
            this.eventHandler.addListener(this.clanMc.btn_acceptinvite,MouseEvent.CLICK,this.acceptClanInvitation);
         }
         else if(this.current_mail.mail_type == 6)
         {
            mc = this.crewMc;
            this.eventHandler.addListener(this.crewMc.btn_acceptinvite,MouseEvent.CLICK,this.acceptClanInvitation);
         }
         else if(this.current_mail.mail_type == 5)
         {
            mc = this.rewardMc;
            this.displayRewardIcons();
         }
         mc.visible = true;
         this.textPane = new TextScrollPane();
         mc.scrollPaneHolder.addChild(this.textPane.getScrollPane());
         this.eventHandler.addListener(mc.backBtn,MouseEvent.CLICK,this.backToMails);
         this.eventHandler.addListener(mc.deleteBtn,MouseEvent.CLICK,this.deleteConfirmation);
         mc.titleTxt.text = this.current_mail.mail_title;
         mc.senderTxt.text = this.current_mail.mail_sender;
         mc.dateTxt.text = this.current_mail.sent_date;
         this.textPane.updatePane({
            "text":this.current_mail.mail_body,
            "text_width":620.9,
            "width":650.9,
            "height":(this.current_mail.mail_type == 5 ? 185.85 : 260),
            "font_size":16,
            "font_name":"Franklin Gothic Demi",
            "font_color":16777215,
            "align":"left",
            "x":0,
            "y":0,
            "scroll_visible":"auto"
         });
         Character.has_notification = false;
         this.main.HUD.checkNotification();
      }
      
      public function claimRewards(param1:MouseEvent) : *
      {
         var _loc2_:int = this.current_mail.mail_id;
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
         Character.addRewards(param1.rewards);
         this.main.giveReward(1,param1.rewards);
         this.main.HUD.setBasicData();
         this.backToMails();
      }
      
      public function displayRewardIcons() : *
      {
         this.rws = [this.current_mail.mail_rewards];
         if(this.current_mail.mail_rewards.indexOf(",") >= 0)
         {
            this.rws = this.current_mail.mail_rewards.split(",");
         }
         this.rewardMc.btn_claim.visible = false;
         if(int(this.current_mail.mail_claimed) == 0)
         {
            this.rewardMc.btn_claim.visible = true;
            this.eventHandler.addListener(this.rewardMc.btn_claim,MouseEvent.CLICK,this.claimRewards);
         }
         this.rewardPane = new RewardScrollPane();
         this.rewardMc.scrollPaneHolder1.addChild(this.rewardPane.getRewardPane());
         this.rewardPane.updateRewardPane({
            "rewards":this.rws,
            "item_per_line":1,
            "width":625,
            "height":98.4,
            "x":73,
            "y":105,
            "scaleX":0.7,
            "scaleY":0.7,
            "scroll_direction":"horizontal",
            "scroll_visible":"auto"
         });
      }
      
      public function acceptClanInvitation(param1:MouseEvent) : void
      {
         var _loc2_:int = this.current_mail.mail_id;
         this.main.loading(true);
         var _loc3_:Array = [Character.char_id,Character.sessionkey,_loc2_];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["QE8tzxAcqlB7",_loc3_],this.onClanAccepted);
      }
      
      public function onClanAccepted(param1:Object) : void
      {
         this.main.loading(false);
         this.main.getNotice(param1.result);
         this.backToMails();
      }
      
      public function getMails() : *
      {
         this.main.loading(true);
         var _loc1_:Array = [Character.char_id,Character.sessionkey];
         this.main.amf_manager.service("KDkIEt2vd8GfhUdQ.IeDixA9GPIob",["BLYQQn0JOp3A",_loc1_],this.onGetMails);
      }
      
      public function onGetMails(param1:Object) : *
      {
         var _loc2_:Object = null;
         if(param1.status == 1)
         {
            this.main.loading(false);
            _loc2_ = this.current_mail;
            this.allMails = param1.mails;
            this.separateMails();
            if(_loc2_ != null)
            {
               if(_loc2_.mail_type == 1)
               {
                  this.mails = this.generalMails;
               }
               else if(_loc2_.mail_type == 3)
               {
                  this.mails = this.clanMails;
               }
               else if(_loc2_.mail_type == 5)
               {
                  this.mails = this.rewardMails;
               }
               else if(_loc2_.mail_type == 6)
               {
                  this.mails = this.crewMails;
               }
               else
               {
                  this.mails = this.allMails;
               }
            }
            else if(this.mails == this.generalMails)
            {
               this.mails = this.generalMails;
            }
            else if(this.mails == this.clanMails)
            {
               this.mails = this.clanMails;
            }
            else if(this.mails == this.rewardMails)
            {
               this.mails = this.rewardMails;
            }
            else if(this.mails == this.crewMails)
            {
               this.mails = this.crewMails;
            }
            else
            {
               this.mails = this.allMails;
            }
            this.total_page = Math.max(Math.ceil(this.mails.length / 5),1);
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
         else
         {
            this.main.showMessage(!!param1.hasOwnProperty("result") ? param1.result : "Unknown Error");
         }
      }
      
      public function separateMails() : *
      {
         this.generalMails = [];
         this.clanMails = [];
         this.rewardMails = [];
         this.crewMails = [];
         var _loc1_:int = 0;
         while(_loc1_ < this.allMails.length)
         {
            if(this.allMails[_loc1_].mail_type == 1)
            {
               this.generalMails.push(this.allMails[_loc1_]);
            }
            else if(this.allMails[_loc1_].mail_type == 3)
            {
               this.clanMails.push(this.allMails[_loc1_]);
            }
            else if(this.allMails[_loc1_].mail_type == 5)
            {
               this.rewardMails.push(this.allMails[_loc1_]);
            }
            else if(this.allMails[_loc1_].mail_type == 6)
            {
               this.crewMails.push(this.allMails[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      public function displayMails() : *
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.listMc["mail_" + _loc1_].visible = false;
            _loc2_ = _loc1_ + (int(this.curr_page) - 1) * 5;
            if(this.mails.length > _loc2_)
            {
               this.listMc["mail_" + _loc1_].visible = true;
               this.listMc["mail_" + _loc1_].new_mc.visible = false;
               this.listMc["mail_" + _loc1_].titleTxt.text = this.mails[_loc2_].mail_title;
               this.listMc["mail_" + _loc1_].senderTxt.text = this.mails[_loc2_].mail_sender;
               this.listMc["mail_" + _loc1_].dateTxt.text = this.mails[_loc2_].sent_date;
               this.eventHandler.addListener(this.listMc["mail_" + _loc1_],MouseEvent.CLICK,this.openMailInfo);
               if(this.mails[_loc2_].mail_viewed == 0)
               {
                  this.listMc["mail_" + _loc1_].new_mc.visible = true;
               }
            }
            _loc1_++;
         }
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
         this.textPane = null;
         GF.removeAllChild(this);
      }
   }
}
