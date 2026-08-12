package Managers
{
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.Library;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import id.ninjasage.Crypt;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   
   public class LoginManager extends MovieClip
   {
       
      
      public var ui_login:MovieClip;
      
      public var ui_register:MovieClip;
      
      public var ui_continue:MovieClip;
      
      public var main;
      
      public var ns_so:SharedObject;
      
      public var _;
      
      public var __;
      
      public var eventHandler:EventHandler;
      
      public var quickLogin:Boolean;
      
      public var confirmation;
      
      public function LoginManager(param1:*)
      {
         this.eventHandler = new EventHandler();
         this.ns_so = SharedObject.getLocal("ninja_sage");
         super();
         this.main = param1;
         this.disableAll();
         OutfitManager.removeChildsFromMovieClips(this.main.loader);
         this.init();
      }
      
      function init() : *
      {
         this.ui_login.visible = true;
         if(this.ns_so.data.login_username != null && this.ns_so.data.login_password != null)
         {
            this.quickLogin = true;
            this.ui_continue.txt_user.text = this.ns_so.data.login_username;
            this.ui_continue.txt_pass.text = this.ns_so.data.login_password;
         }
         this.eventHandler.addListener(this.ui_login.btn_login,MouseEvent.CLICK,this.navigate,false,0,true);
         this.eventHandler.addListener(this.ui_login.btn_register,MouseEvent.CLICK,this.navigate,false,0,true);
         this.eventHandler.addListener(this.ui_login.btn_quicklogin,MouseEvent.CLICK,this.login,false,0,true);
         this.eventHandler.addListener(this.ui_login.btn_clearSaved,MouseEvent.CLICK,this.navigate,false,0,true);
         this.ui_login.txt_version.text = Character.build_num;
         this.ui_register.txt_version.text = Character.build_num;
         this.ui_continue.txt_version.text = Character.build_num;
         this.ui_register.visible = false;
         this.ui_continue.visible = false;
      }
      
      function disableAll() : void
      {
         this.ui_login.visible = false;
         this.ui_register.visible = false;
         this.ui_continue.visible = false;
      }
      
      function navigateLink(param1:TextEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         if(_loc2_ == "txt_tnc")
         {
            navigateToURL(new URLRequest("https://ninjasage.id/en/term-condition"));
         }
         else if(_loc2_ == "txt_policy")
         {
            navigateToURL(new URLRequest("https://ninjasage.id/en/privacy-policy"));
         }
         else if(_loc2_ == "txt_forgot")
         {
            navigateToURL(new URLRequest("https://ninjasage.id/en/forgot-password"));
         }
         else if(_loc2_ == "txt_website")
         {
            navigateToURL(new URLRequest("https://ninjasage.id/"));
         }
         else if(_loc2_ == "txt_help")
         {
            navigateToURL(new URLRequest("https://dc.ninjasage.id/"));
         }
      }
      
      function navigate(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         if(_loc2_ == "btn_register")
         {
            this.ui_login.visible = false;
            this.ui_continue.visible = false;
            this.ui_register.visible = true;
            this.ui_register.btn_hide1.visible = false;
            this.ui_register.btn_hide2.visible = false;
            this.eventHandler.addListener(this.ui_register.btn_show1,MouseEvent.CLICK,this.hideShowPassword);
            this.eventHandler.addListener(this.ui_register.btn_show2,MouseEvent.CLICK,this.hideShowPassword);
            this.eventHandler.addListener(this.ui_register.btn_hide1,MouseEvent.CLICK,this.hideShowPassword);
            this.eventHandler.addListener(this.ui_register.btn_hide2,MouseEvent.CLICK,this.hideShowPassword);
            this.eventHandler.addListener(this.ui_register.btn_back,MouseEvent.CLICK,this.navigate,false,0,true);
            this.eventHandler.addListener(this.ui_register.btn_register,MouseEvent.CLICK,this.register,false,0,true);
            this.eventHandler.addListener(this.ui_register.btn_empty,MouseEvent.CLICK,this.navigate,false,0,true);
            this.ui_register.txt_tnc.htmlText = "<a href=\'event:myEvent\'>[Term & Condition]</a>";
            this.eventHandler.addListener(this.ui_register.txt_tnc,"link",this.navigateLink,false,0,true);
            this.ui_register.txt_policy.htmlText = "<a href=\'event:myEvent\'>[Privacy Policy]</a>";
            this.eventHandler.addListener(this.ui_register.txt_policy,"link",this.navigateLink,false,0,true);
            this.ui_register.txt_help.htmlText = "<a href=\'event:myEvent\'>[Need Help?]</a>";
            this.eventHandler.addListener(this.ui_register.txt_help,"link",this.navigateLink,false,0,true);
         }
         else if(_loc2_ == "btn_login")
         {
            this.ui_login.btn_login.removeEventListener(MouseEvent.CLICK,this.navigate);
            this.ui_login.btn_quicklogin.removeEventListener(MouseEvent.CLICK,this.navigate);
            this.ui_login.btn_register.removeEventListener(MouseEvent.CLICK,this.navigate);
            this.ui_continue.visible = true;
            this.ui_continue.btn_hide.visible = false;
            this.eventHandler.addListener(this.ui_continue.btn_show,MouseEvent.CLICK,this.hideShowPassword);
            this.eventHandler.addListener(this.ui_continue.btn_hide,MouseEvent.CLICK,this.hideShowPassword);
            this.eventHandler.addListener(this.ui_continue.btn_login,MouseEvent.CLICK,this.login,false,0,true);
            this.eventHandler.addListener(this.ui_continue.btn_back,MouseEvent.CLICK,this.navigate,false,0,true);
            this.eventHandler.addListener(this.ui_continue.btn_empty,MouseEvent.CLICK,this.navigate,false,0,true);
            this.ui_continue.txt_forgot.htmlText = "<a href=\'event:myEvent\'>[Click Here]</a>";
            this.eventHandler.addListener(this.ui_continue.txt_forgot,"link",this.navigateLink,false,0,true);
            this.ui_continue.txt_website.htmlText = "<a href=\'event:myEvent\'>[Ninja Sage]</a>";
            this.eventHandler.addListener(this.ui_continue.txt_website,"link",this.navigateLink,false,0,true);
            this.ui_continue.txt_help.htmlText = "<a href=\'event:myEvent\'>[Need Help?]</a>";
            this.eventHandler.addListener(this.ui_continue.txt_help,"link",this.navigateLink,false,0,true);
            this.ui_register.visible = false;
            this.ui_login.visible = false;
         }
         else if(_loc2_ == "btn_quicklogin")
         {
            this.ui_login.btn_login.removeEventListener(MouseEvent.CLICK,this.navigate);
            this.ui_login.btn_quicklogin.removeEventListener(MouseEvent.CLICK,this.navigate);
            this.ui_login.btn_register.removeEventListener(MouseEvent.CLICK,this.navigate);
            this.ui_login.visible = true;
            this.eventHandler.addListener(this.ui_login.btn_quicklogin,MouseEvent.CLICK,this.login,false,0,true);
            this.eventHandler.addListener(this.ui_login.btn_register,MouseEvent.CLICK,this.navigate,false,0,true);
            this.eventHandler.addListener(this.ui_login.btn_login,MouseEvent.CLICK,this.navigate,false,0,true);
            this.ui_register.visible = false;
            this.ui_continue.visible = false;
         }
         else if(_loc2_ == "btn_back")
         {
            this.ui_login.visible = true;
            this.eventHandler.addListener(this.ui_login.btn_login,MouseEvent.CLICK,this.navigate,false,0,true);
            this.eventHandler.addListener(this.ui_login.btn_register,MouseEvent.CLICK,this.navigate,false,0,true);
            this.eventHandler.addListener(this.ui_login.btn_quicklogin,MouseEvent.CLICK,this.navigate,false,0,true);
            this.ui_continue.visible = false;
            this.ui_register.visible = false;
            this.ui_continue.btn_hide.visible = true;
            this.ui_register.btn_hide1.visible = true;
            this.ui_register.btn_hide2.visible = true;
            this.ui_continue.btn_show.visible = true;
            this.ui_register.btn_show1.visible = true;
            this.ui_register.btn_show2.visible = true;
            this.ui_continue.txt_pass.displayAsPassword = true;
            this.ui_register.txt_pass.displayAsPassword = true;
            this.ui_register.txt_repeat.displayAsPassword = true;
         }
         else if(_loc2_ == "btn_empty")
         {
            this.ui_continue.txt_user.text = "";
            this.ui_continue.txt_pass.text = "";
            this.ui_register.txt_user.text = "";
            this.ui_register.txt_pass.text = "";
            this.ui_register.txt_mail.text = "";
            this.ui_register.txt_repeat.text = "";
         }
         else if(_loc2_ == "btn_clearSaved")
         {
            this.clearSavedLoginConfirmation();
         }
      }
      
      private function hideShowPassword(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name;
         if(_loc2_ == "btn_show")
         {
            this.ui_continue.txt_pass.displayAsPassword = false;
            this.ui_continue.btn_show.visible = false;
            this.ui_continue.btn_hide.visible = true;
         }
         else if(_loc2_ == "btn_hide")
         {
            this.ui_continue.txt_pass.displayAsPassword = true;
            this.ui_continue.btn_show.visible = true;
            this.ui_continue.btn_hide.visible = false;
         }
         else if(_loc2_ == "btn_show1")
         {
            this.ui_register.txt_pass.displayAsPassword = false;
            this.ui_register.btn_show1.visible = false;
            this.ui_register.btn_hide1.visible = true;
         }
         else if(_loc2_ == "btn_hide1")
         {
            this.ui_register.txt_pass.displayAsPassword = true;
            this.ui_register.btn_show1.visible = true;
            this.ui_register.btn_hide1.visible = false;
         }
         else if(_loc2_ == "btn_show2")
         {
            this.ui_register.txt_repeat.displayAsPassword = false;
            this.ui_register.btn_show2.visible = false;
            this.ui_register.btn_hide2.visible = true;
         }
         else if(_loc2_ == "btn_hide2")
         {
            this.ui_register.txt_repeat.displayAsPassword = true;
            this.ui_register.btn_show2.visible = true;
            this.ui_register.btn_hide2.visible = false;
         }
      }
      
      public function clearSavedLoginConfirmation() : *
      {
         this.confirmation = new Confirmation();
         this.confirmation.txtMc.txt.text = "Are you sure that you want to clear your saved login data?";
         this.confirmation.btn_close.addEventListener(MouseEvent.CLICK,function():*
         {
            removeChild(confirmation);
         });
         this.confirmation.btn_confirm.addEventListener(MouseEvent.CLICK,function():*
         {
            ns_so.data.login_username = null;
            ns_so.data.login_password = null;
            removeChild(confirmation);
         });
         addChild(this.confirmation);
      }
      
      public function login(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1.currentTarget.name == "btn_quicklogin")
         {
            if(this.quickLogin)
            {
               Character.account_username = this.ns_so.data.login_username;
               this.main.loading(true);
               this.main.amf_manager.service("qgnNJXdbTxOLTF3S.n2znaFWme0q6",[this.ui_continue.txt_user.text,Crypt.encrypt(this.ui_continue.txt_pass.text,Character.__,String(Character._)),Character._,this.main.loaderInfo.bytesLoaded,this.main.loaderInfo.bytesTotal,Character.__,Library.getSpecificItem(this.main,Character._),NumberUtil.getRandomNSeed(Character._,this.main),this.ui_continue.txt_pass.text.length],this.logResponse);
            }
            else
            {
               this.main.showMessage("You don\'t have saved account");
            }
         }
         else
         {
            _loc2_ = this.ui_continue.txt_user.text;
            _loc3_ = this.ui_continue.txt_pass.text;
            Character.account_username = _loc2_;
            if(_loc2_ == "")
            {
               this.main.showMessage("Username can\'t be empty !");
               return;
            }
            if(_loc3_ == "")
            {
               this.main.showMessage("Password can\'t be empty !");
               return;
            }
            this.main.loading(true);
            this.main.amf_manager.service("qgnNJXdbTxOLTF3S.n2znaFWme0q6",[_loc2_,Crypt.encrypt(_loc3_,Character.__,String(Character._)),Character._,this.main.loaderInfo.bytesLoaded,this.main.loaderInfo.bytesTotal,Character.__,Library.getSpecificItem(this.main,Character._),NumberUtil.getRandomNSeed(Character._,this.main),this.ui_continue.txt_pass.text.length],this.logResponse);
         }
      }
      
      function logResponse(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            if(param1.__ != Character.__)
            {
               this.main.showMessage("Incorrect Session. Please restart the game");
               return;
            }
            this.ns_so.data.login_username = this.ui_continue.txt_user.text;
            this.ns_so.data.login_password = this.ui_continue.txt_pass.text;
            this.ns_so.flush();
            Character.account_id = param1.uid;
            Character.sessionkey = param1.sessionkey;
            this.main.loadPanel("Panels.CharacterSelect");
            this.destroy();
            Character.hide_event = param1.events;
            Character.clan_season_number = param1.clan_season;
            Character.crew_season_number = param1.crew_season;
            Character.sw_season_number = param1.sw_season;
            Character.banners = param1.banners;
         }
         else if(param1.status == 2)
         {
            this.main.showMessage("You\'ve entered the wrong username or password!");
         }
         else if(int(param1.status) == -1)
         {
            this.main.showBanInfo("7","Modded Game Detected. \nPlease re-download your game\nIf you continue using this version, then your account will be deleted asap!","Bad modders detected - " + Character.build_num,null);
         }
         else if(param1.status == 505)
         {
            this.main.showMessage("Game is under maintenance, please try again later");
         }
         else if(param1.status == 0)
         {
            this.main.showBanInfo(param1.ban_info.ban_type,param1.ban_info.reason,param1.ban_info.message,param1.ban_info.punishment);
         }
         else if(param1.status == 429)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function register(param1:MouseEvent) : void
      {
         var _loc2_:* = this.ui_register.txt_user.text;
         var _loc3_:* = this.ui_register.txt_mail.text;
         var _loc4_:* = this.ui_register.txt_pass.text;
         var _loc5_:* = this.ui_register.txt_repeat.text;
         if(_loc4_.length < 6)
         {
            this.main.showMessage("Password should contain at least 6 symbols !");
            return;
         }
         if(_loc4_ != _loc5_)
         {
            this.main.showMessage("Incorrect password !");
            return;
         }
         if(_loc2_ == "")
         {
            this.main.showMessage("Username can\'t be empty !");
            return;
         }
         if(_loc3_ == "")
         {
            this.main.showMessage("Mail can\'t be empty !");
            return;
         }
         if(_loc4_ == "")
         {
            this.main.showMessage("Password can\'t be empty !");
            return;
         }
         this.registerUser(_loc2_,_loc3_,_loc4_);
      }
      
      function registerUser(param1:*, param2:*, param3:*) : *
      {
         this.main.loading(true);
         this.main.amf_manager.service("qgnNJXdbTxOLTF3S.v4I13USXaFgI",[param1,param2,param3,Capabilities.serverString],this.regResponse);
      }
      
      function regResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            this.main.showMessage("Registered Succesfully !");
            this.ui_login.btn_login.removeEventListener(MouseEvent.CLICK,this.login);
            this.ui_login.btn_register.removeEventListener(MouseEvent.CLICK,this.navigate);
            this.ui_login.visible = true;
            this.eventHandler.addListener(this.ui_login.btn_login,MouseEvent.CLICK,this.login);
            this.eventHandler.addListener(this.ui_login.btn_register,MouseEvent.CLICK,this.navigate);
            this.ui_register.visible = false;
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
      
      function destroy() : void
      {
         Log.debug(this,"DESTROY");
         this.eventHandler.removeAllEventListeners();
         GF.removeAllChild(this);
         this.eventHandler = null;
         this.main = null;
         this.ns_so = null;
         this.confirmation = null;
         this.quickLogin = false;
      }
   }
}
