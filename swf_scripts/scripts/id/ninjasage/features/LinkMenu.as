package id.ninjasage.features
{
   import Managers.AppManager;
   import Storage.Character;
   import com.adobe.utils.StringUtil;
   import id.ninjasage.Clan;
   import id.ninjasage.Crew;
   
   public class LinkMenu
   {
      
      public static var ClanWar:* = "ClanWar";
      
      public static var ShadowWar:* = "ShadowWar";
      
      public static var PvP:* = "PvP";
      
      public static var CrewWar:* = "Crew";
      
      public function LinkMenu()
      {
         super();
      }
      
      public static function open(param1:*) : *
      {
         var _loc2_:* = AppManager.getInstance().main;
         switch(param1)
         {
            case ClanWar:
               _loc2_.loading(true);
               Clan.instance.getSeason(LinkMenu.clanOnGetStatus);
               break;
            case CrewWar:
               _loc2_.loading(true);
               Crew.instance.getSeason(LinkMenu.crewOnGetStatus);
               break;
            case ShadowWar:
               _loc2_.loading(true);
               _loc2_.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["gxVTa2Yqoe0C",[Character.char_id,Character.sessionkey]],LinkMenu.swOnGetSeason);
               break;
            case PvP:
               _loc2_.loading(true);
               _loc2_.loadPanel("id.ninjasage.pvp.PvP");
               break;
            default:
               LinkMenu.openOther(param1);
         }
      }
      
      private static function clanOnGetStatus(param1:Object, param2:* = null) : *
      {
         var _loc3_:* = AppManager.getInstance().main;
         _loc3_.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            _loc3_.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null || param1 == null)
         {
            _loc3_.getNotice("Clan server is unreachable.\nProbably maintenance.\nPlease try again later");
            return;
         }
         if(Boolean(param1) && param1.hasOwnProperty("timestamp"))
         {
            Character.clan_timestamp = param1.timestamp;
         }
         if(Boolean(param1) && param1.hasOwnProperty("season"))
         {
            Character.clan_season = param1.season;
         }
         _loc3_.loading(true);
         Clan.instance.login(Character.char_id,Character.sessionkey,LinkMenu.clanOnAuth);
      }
      
      private static function clanOnAuth(param1:*, param2:* = null) : *
      {
         var _loc3_:* = "Unable login to Clan Server";
         var _loc4_:* = AppManager.getInstance().main;
         _loc4_.loading(false);
         if(param1 != null && Boolean(param1.hasOwnProperty("access_token")))
         {
            Clan.instance.authToken(param1.access_token);
            Clan.instance.getClanData(LinkMenu.clanOnGetData);
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("statusCode")))
         {
            _loc3_ += "\nCode: " + param1.statusCode;
         }
         _loc4_.getNotice(_loc3_);
      }
      
      private static function clanOnGetData(param1:*, param2:* = null) : *
      {
         var _loc3_:* = AppManager.getInstance().main;
         _loc3_.loading(false);
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("clan")) && Boolean(param1.hasOwnProperty("char")))
         {
            Character.clan_data = param1.clan;
            Character.clan_char_data = param1.char;
            _loc3_.loadPanel("Panels.ClanVillage");
         }
         else
         {
            _loc3_.loadPanel("Panels.ClanCreate");
         }
      }
      
      private static function crewOnGetStatus(param1:Object, param2:* = null) : *
      {
         var _loc4_:Object = null;
         var _loc3_:* = AppManager.getInstance().main;
         _loc3_.loading(false);
         if(param1 != null && param1.hasOwnProperty("errorMessage"))
         {
            _loc3_.getNotice(param1.errorMessage);
            return;
         }
         if(param2 != null || param1 == null)
         {
            _loc3_.getNotice("Crew server is unreachable.\nProbably maintenance.\nPlease try again later");
            return;
         }
         if(Boolean(param1) && param1.hasOwnProperty("timestamp"))
         {
            Character.crew_timestamp = param1.timestamp;
         }
         if(Boolean(param1) && param1.hasOwnProperty("season"))
         {
            Character.crew_season = param1.season;
         }
         if(Boolean(param1) && param1.hasOwnProperty("phase"))
         {
            Crew.instance.setPhase(param1.phase);
         }
         if(Boolean(param1) && Boolean(param1.hasOwnProperty("rp1")) && param1.hasOwnProperty("rp2"))
         {
            _loc4_ = {
               "phase_1":param1.rp1,
               "phase_2":param1.rp2
            };
            Crew.instance.setRewardData(_loc4_);
         }
         _loc3_.loading(true);
         Crew.instance.login(Character.char_id,Character.sessionkey,LinkMenu.crewOnAuth);
      }
      
      private static function crewOnAuth(param1:*, param2:* = null) : *
      {
         var _loc3_:* = "Unable login to Crew Server";
         var _loc4_:* = AppManager.getInstance().main;
         _loc4_.loading(false);
         if(param1 != null && Boolean(param1.hasOwnProperty("access_token")))
         {
            Crew.instance.authToken(param1.access_token);
            Crew.instance.getCrewData(LinkMenu.crewOnGetData);
            return;
         }
         if(param1 != null && Boolean(param1.hasOwnProperty("code")))
         {
            _loc3_ += "\nCode: " + param1.code;
         }
         _loc4_.getNotice(_loc3_);
      }
      
      private static function crewOnGetData(param1:*, param2:* = null) : *
      {
         var _loc3_:* = AppManager.getInstance().main;
         _loc3_.loading(false);
         if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("crew")) && Boolean(param1.hasOwnProperty("char")))
         {
            Character.crew_data = param1.crew;
            Character.crew_char_data = param1.char;
            _loc3_.loadExternalSwfPanel("CrewVillage","CrewVillage");
         }
         else if(Boolean(param1 != null) && Boolean(param1.hasOwnProperty("code")) && param1.code == 404)
         {
            _loc3_.loadExternalSwfPanel("CrewCreate","CrewCreate");
         }
         else
         {
            _loc3_.getNotice("Unable to get info from Crew Server");
         }
      }
      
      private static function swOnGetSeason(param1:Object) : *
      {
         var _loc2_:* = AppManager.getInstance().main;
         _loc2_.loading(false);
         if(param1.status == 1)
         {
            Character.shadow_war_season = param1;
            if(param1.active)
            {
               _loc2_.loadExternalSwfPanel("ArenaVillage","ArenaVillage");
            }
            else
            {
               _loc2_.getNotice("No active season");
            }
         }
         else if(param1.status > 1)
         {
            _loc2_.getNotice(param1.result);
         }
         else
         {
            _loc2_.getError(param1.error);
         }
      }
      
      private static function openOther(param1:*) : *
      {
         if(StringUtil.beginsWith(param1,"Panels."))
         {
            AppManager.getInstance().main.loadPanel(param1);
         }
         else if(param1.indexOf("|"))
         {
            param1 = param1.split("|");
            AppManager.getInstance().main.loadExternalSwfPanel(param1[0],param1[1]);
         }
      }
   }
}

