package Managers
{
   import Panels.Academy;
   import Panels.CharacterCreate;
   import Panels.CharacterSelect;
   import Panels.GetNotice;
   import Panels.HUD;
   import Panels.Hunting_House;
   import Panels.Mission_Room;
   import Panels.Recharge;
   import Panels.Shop;
   import Panels.UI_Gear;
   import Panels.UI_Option;
   import Panels.UI_Profile;
   import Panels.UI_Skillset;
   import Panels.Village;
   import Popups.EmblemUpgrade;
   import Popups.LevelUp;
   import Popups.Rename;
   import Popups.Scroll_Battle;
   import Popups.Scroll_Hunting;
   
   public class VarManager
   {
       
      
      public var main;
      
      public function VarManager(param1:*)
      {
         var _loc2_:EmblemUpgrade = null;
         var _loc3_:LoginManager = null;
         var _loc4_:BanManager = null;
         var _loc5_:CharacterSelect = null;
         var _loc6_:Village = null;
         var _loc7_:HUD = null;
         var _loc8_:ErrorManager = null;
         var _loc9_:UI_Profile = null;
         var _loc10_:UI_Gear = null;
         var _loc11_:UI_Skillset = null;
         var _loc12_:Hunting_House = null;
         var _loc13_:Mission_Room = null;
         var _loc14_:Shop = null;
         var _loc15_:Academy = null;
         var _loc16_:GetNotice = null;
         var _loc17_:CharacterCreate = null;
         var _loc18_:Recharge = null;
         var _loc19_:Scroll_Hunting = null;
         var _loc20_:Scroll_Battle = null;
         var _loc21_:UI_Option = null;
         var _loc22_:LevelUp = null;
         var _loc23_:Rename = null;
         super();
         this.main = param1;
      }
   }
}
