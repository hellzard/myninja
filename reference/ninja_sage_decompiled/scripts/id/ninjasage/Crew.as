package id.ninjasage
{
   import Storage.Character;
   import flash.net.URLRequestHeader;
   
   public class Crew
   {
      
      public static var _instance:Crew;
       
      
      private var baseUrl;
      
      private var headers:Array;
      
      private var battleData;
      
      private var _delayDestroy = false;
      
      private var phase = 0;
      
      private var ui;
      
      private var isSkipAnimation = false;
      
      private var rewardData;
      
      public function Crew()
      {
         this.baseUrl = "https://crew.ninjasage.id";
         this.ui = {};
         this.rewardData = {};
         super();
         if(Crew._instance != null)
         {
            throw new Error("Cannot create double instance of crew");
         }
         this.headers = [new URLRequestHeader("Accept","application/json"),new URLRequestHeader("Content-Type","application/json"),new URLRequestHeader("Agent","NinjaSage " + Character.build_num)];
      }
      
      public static function get instance() : Crew
      {
         if(_instance == null)
         {
            _instance = new Crew();
         }
         return _instance;
      }
      
      public function setPhase(param1:int) : *
      {
         this.phase = param1;
      }
      
      public function getPhase() : int
      {
         return this.phase;
      }
      
      public function addUI(param1:*, param2:*) : *
      {
         this.ui[param1] = param2;
      }
      
      public function removeUI(param1:*) : *
      {
         var key:* = param1;
         if(this.ui.hasOwnProperty(key))
         {
            if("destroy" in this.ui[key])
            {
               try
               {
                  this.ui[key].destroy();
               }
               catch(e:*)
               {
               }
            }
         }
      }
      
      public function setBattleData(param1:*) : *
      {
         this.battleData = param1;
      }
      
      public function getBattleData() : *
      {
         return this.battleData;
      }
      
      public function setSkipAnimation(param1:Boolean) : *
      {
         this.isSkipAnimation = param1;
      }
      
      public function getSkipAnimation() : Boolean
      {
         return this.isSkipAnimation;
      }
      
      public function setRewardData(param1:*) : *
      {
         this.rewardData = param1;
      }
      
      public function getRewardData() : *
      {
         return this.rewardData;
      }
      
      public function getSeason(param1:Function) : *
      {
         Http.post(this.baseUrl + "/season",{},param1,this.headers);
      }
      
      public function getTokenPool(param1:Function) : *
      {
         Http.post(this.baseUrl + "/season/pool",{},param1,this.headers);
      }
      
      public function login(param1:*, param2:String, param3:Function) : *
      {
         Http.post(this.baseUrl + "/auth/login",{
            "char_id":param1,
            "session_key":param2
         },param3,this.headers);
      }
      
      public function authToken(param1:*) : *
      {
         this.headers.push(new URLRequestHeader("Authorization","Bearer " + param1));
      }
      
      public function getCrewData(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/crew",{},param1,this.headers);
      }
      
      public function getStamina(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/stamina",{},param1,this.headers);
      }
      
      public function getHistory(param1:Function) : *
      {
         Http.post(this.baseUrl + "/history",{},param1,this.headers);
      }
      
      public function getCrewsForBattle(param1:Function) : *
      {
         Http.post(this.baseUrl + "/battle/opponents",{},param1,this.headers);
      }
      
      public function searchCrewsForBattle(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/battle/opponents/" + param1,{},param2,this.headers);
      }
      
      public function getCrewsForRequest(param1:Function) : *
      {
         Http.post(this.baseUrl + "/request/available",{},param1,this.headers);
      }
      
      public function searchCrewsForRequest(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/request/available/" + param1,{},param2,this.headers);
      }
      
      public function sendRequestToCrew(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/request/" + param1,{},param2,this.headers);
      }
      
      public function getMembersInfo(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/crew/members",{},param1,this.headers);
      }
      
      public function getMemberRequests(param1:Function) : *
      {
         Http.post(this.baseUrl + "/request/all",{},param1,this.headers);
      }
      
      public function rejectMember(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/request/" + param1 + "/reject",{},param2,this.headers);
      }
      
      public function rejectMembers(param1:Function) : *
      {
         Http.post(this.baseUrl + "/request/all/reject",{},param1,this.headers);
      }
      
      public function acceptMember(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/request/" + param1 + "/accept",{},param2,this.headers);
      }
      
      public function quitFromCrew(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/quit",{},param1,this.headers);
      }
      
      public function kickMember(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/kick/" + param1,{},param2,this.headers);
      }
      
      public function promoteElder(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/promote-elder/" + param1,{},param2,this.headers);
      }
      
      public function donateGolds(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/donate/" + param1 + "/golds",{},param2,this.headers);
      }
      
      public function donateTokens(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/donate/" + param1 + "/tokens",{},param2,this.headers);
      }
      
      public function upgradeBuilding(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/upgrade/building/" + param1,{},param2,this.headers);
      }
      
      public function updateAnnouncement(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/announcements",{"announcement":param1},param2,this.headers);
      }
      
      public function publishAnnouncement(param1:Function) : *
      {
         Http.post(this.baseUrl + "/announcement/publish",{},param1,this.headers);
      }
      
      public function increaseMaxMembers(param1:Function) : *
      {
         Http.post(this.baseUrl + "/upgrade/max-members",{},param1,this.headers);
      }
      
      public function upgradeMaxStamina(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/stamina/upgrade-max",{},param1,this.headers);
      }
      
      public function boostPrestige(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/boost-prestige",{},param1,this.headers);
      }
      
      public function restoreStamina(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/stamina/refill",{},param1,this.headers);
      }
      
      public function getCrewRanks(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/battle/castles/" + param1 + "/ranks",{},param2,this.headers);
      }
      
      public function getRecoverLifeBar(param1:*, param2:*, param3:Function) : *
      {
         Http.post(this.baseUrl + "/battle/castles/" + param1 + "/recovery",param2,param3,this.headers);
      }
      
      public function recoverCastle(param1:*, param2:*, param3:Function) : *
      {
         Http.post(this.baseUrl + "/battle/castles/" + param1 + "/recover",param2,param3,this.headers);
      }
      
      public function getDefenders(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/battle/castles/" + param1 + "/defenders",{},param2,this.headers);
      }
      
      public function switchRole(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/battle/role/switch/" + param1,"",param2,this.headers);
      }
      
      public function getAttackers(param1:Function) : *
      {
         Http.post(this.baseUrl + "/battle/attackers",{},param1,this.headers);
      }
      
      public function getCastles(param1:Function, param2:* = 0) : *
      {
         Http.post(this.baseUrl + "/battle/castles/" + (param2 == 0 ? "" : int(param2)),{},param1,this.headers);
      }
      
      public function startBattle(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/battle/phase" + this.getPhase() + "/start",param1,param2,this.headers);
      }
      
      public function finishBattle(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/battle/phase" + this.getPhase() + "/finish",param1,param2,this.headers);
      }
      
      public function createCrew(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/create",{"name":param1},param2,this.headers);
      }
      
      public function renameCrew(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/rename",{"name":param1},param2,this.headers);
      }
      
      public function buyOnigiriPackage(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/buy-onigiri/" + param1,{},param2,this.headers);
      }
      
      public function getOnigiriInfo(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/member/" + param1 + "/onigiri/limit",{},param2,this.headers);
      }
      
      public function giveOnigiri(param1:*, param2:*, param3:Function) : *
      {
         Http.post(this.baseUrl + "/member/" + param1 + "/onigiri/gift/" + param2,{},param3,this.headers);
      }
      
      public function inviteCharacter(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/request/" + param1 + "/invite",{},param2,this.headers);
      }
      
      public function seasonHistories(param1:Function) : *
      {
         Http.post(this.baseUrl + "/season-histories",{},param1,this.headers);
      }
      
      public function getMiniGame(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/minigame",{},param1,this.headers);
      }
      
      public function startMiniGame(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/minigame/start",{},param1,this.headers);
      }
      
      public function finishMiniGame(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/minigame/finish",param1,param2,this.headers);
      }
      
      public function buyMiniGame(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/minigame/buy/" + param1,{},param2,this.headers);
      }
      
      public function changeCrewMaster(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/switch-master/" + param1,{},param2,this.headers);
      }
      
      public function getLastSeasonRewards(param1:Function) : *
      {
         Http.post(this.baseUrl + "/season/previous",{},param1,this.headers);
      }
      
      public function delayDestroy(param1:*) : *
      {
         this._delayDestroy = param1;
      }
      
      public function destroy() : *
      {
         var _loc1_:* = undefined;
         if(this._delayDestroy)
         {
            return;
         }
         for(_loc1_ in this.ui)
         {
            this.removeUI(_loc1_);
         }
         this.battleData = null;
         this.ui = null;
         this.headers = null;
         Crew._instance = null;
      }
   }
}
