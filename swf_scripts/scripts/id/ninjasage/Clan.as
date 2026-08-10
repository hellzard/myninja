package id.ninjasage
{
   import Storage.Character;
   import flash.net.URLRequestHeader;
   
   public class Clan
   {
      
      public static var _instance:Clan;
      
      private var baseUrl:* = "https://clan.ninjasage.id";
      
      private var headers:Array;
      
      private var _delayDestroy:* = false;
      
      public function Clan()
      {
         super();
         if(Clan._instance != null)
         {
            throw new Error("Cannot create double instance of clan");
         }
         this.headers = [new URLRequestHeader("Accept","application/json"),new URLRequestHeader("Content-Type","application/json"),new URLRequestHeader("Agent","NinjaSage " + Character.build_num)];
      }
      
      public static function get instance() : Clan
      {
         if(_instance == null)
         {
            _instance = new Clan();
         }
         return _instance;
      }
      
      public function getSeason(param1:Function) : *
      {
         Http.post(this.baseUrl + "/season",{},param1,this.headers);
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
      
      public function getClanData(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/clan",{},param1,this.headers);
      }
      
      public function getStamina(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/stamina",{},param1,this.headers);
      }
      
      public function getHistory(param1:Function) : *
      {
         Http.post(this.baseUrl + "/history",{},param1,this.headers);
      }
      
      public function getClansForBattle(param1:Function) : *
      {
         Http.post(this.baseUrl + "/battle/opponents",{},param1,this.headers);
      }
      
      public function searchClansForBattle(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/battle/opponents/" + param1,{},param2,this.headers);
      }
      
      public function getClansForRequest(param1:Function) : *
      {
         Http.post(this.baseUrl + "/request/available",{},param1,this.headers);
      }
      
      public function searchClansForRequest(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/request/available/" + param1,{},param2,this.headers);
      }
      
      public function sendRequestToClan(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/player/request/" + param1,{},param2,this.headers);
      }
      
      public function getMembersInfo(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/clan-members",{},param1,this.headers);
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
      
      public function quitFromClan(param1:Function) : *
      {
         Http.post(this.baseUrl + "/player/quit",{},param1,this.headers);
      }
      
      public function kickMember(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/member/" + param1 + "/kick",{},param2,this.headers);
      }
      
      public function swapMaster(param1:Function) : *
      {
         Http.post(this.baseUrl + "/swap-master",{},param1,this.headers);
      }
      
      public function promoteElder(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/member/" + param1 + "/promote-elder",{},param2,this.headers);
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
         Http.post(this.baseUrl + "/upgrade-building/" + param1,{},param2,this.headers);
      }
      
      public function updateAnnouncement(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/announcement/save",{"announcement":param1},param2,this.headers);
      }
      
      public function publishAnnouncement(param1:Function) : *
      {
         Http.post(this.baseUrl + "/announcement/publish",{},param1,this.headers);
      }
      
      public function increaseMaxMembers(param1:Function) : *
      {
         Http.post(this.baseUrl + "/member/increase-max-members",{},param1,this.headers);
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
      
      public function getDefenders(param1:Function) : *
      {
         Http.post(this.baseUrl + "/battle/defenders",{},param1,this.headers);
      }
      
      public function quickAttack(param1:*, param2:*, param3:Function) : *
      {
         Http.post(this.baseUrl + "/battle/quick/" + param1,{"code":param2},param3,this.headers);
      }
      
      public function startManualAttack(param1:*, param2:*, param3:Function) : *
      {
         Http.post(this.baseUrl + "/battle/manual/start/" + param1,{"recruits":param2},param3,this.headers);
      }
      
      public function finishManualAttack(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/battle/manual/finish",{
            "id":param1[1],
            "stats":param1[0],
            "code":param1[2],
            "hash":param1[3]
         },param2,this.headers);
      }
      
      public function createClan(param1:*, param2:Function) : *
      {
         Http.post(this.baseUrl + "/create",{"name":param1},param2,this.headers);
      }
      
      public function renameClan(param1:*, param2:Function) : *
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
         Http.post(this.baseUrl + "/invite-character/" + param1,{},param2,this.headers);
      }
      
      public function seasonHistories(param1:Function) : *
      {
         Http.post(this.baseUrl + "/season-histories",{},param1,this.headers);
      }
      
      public function delayDestroy(param1:*) : *
      {
         this._delayDestroy = param1;
      }
      
      public function destroy() : *
      {
         if(this._delayDestroy)
         {
            return;
         }
         this.headers = null;
         Clan._instance = null;
      }
   }
}

