package Combat
{
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BattleLoader
   {
      
      public static var bg_holder:*;
      
      public static var BG_Linkage:*;
      
      public var backgroundMC:MovieClip;
      
      public function BattleLoader()
      {
         super();
      }
      
      public function loadPlayerTeam(param1:int = 0) : *
      {
         var _loc2_:* = undefined;
         if(BattleManager.getPlayerTeam().length <= param1)
         {
            BattleVars.PLAYER_TEAM_LOADED = true;
            BattleManager.loadEnemyTeam();
            return;
         }
         var _loc3_:String = String(BattleManager.getPlayerTeam()[param1]);
         if(_loc3_.indexOf("char_") >= 0)
         {
            _loc2_ = new CharacterModel("player",param1,_loc3_);
            BattleManager.getBattle().character_team_players[param1] = _loc2_;
         }
         else if(_loc3_.indexOf("npc_") >= 0)
         {
            _loc2_ = new NpcModel("player",param1,_loc3_);
            BattleManager.getBattle().character_team_players[param1] = _loc2_;
         }
         else
         {
            _loc2_ = new EnemyModel("player",param1,_loc3_);
            BattleManager.getBattle().character_team_players[param1] = _loc2_;
         }
      }
      
      public function loadEnemyTeam(param1:int = 0) : *
      {
         var _loc2_:* = undefined;
         if(BattleManager.getEnemyTeam().length <= param1)
         {
            BattleVars.ENEMY_TEAM_LOADED = true;
            if(Character.is_jounin_stage_4)
            {
               BattleManager.getBattle().setElementsForStage4();
            }
            return;
         }
         var _loc3_:String = String(BattleManager.getEnemyTeam()[param1]);
         if(_loc3_.indexOf("char_") >= 0)
         {
            _loc2_ = new CharacterModel("enemy",param1,_loc3_);
            BattleManager.getBattle().enemy_team_players[param1] = _loc2_;
         }
         else
         {
            _loc2_ = new EnemyModel("enemy",param1,_loc3_);
            BattleManager.getBattle().enemy_team_players[param1] = _loc2_;
         }
      }
      
      public function loadBackground() : *
      {
         var _loc1_:String = BattleManager.getBackgound();
         BattleManager.getMain().loadSwf("mission",_loc1_,this.handleBackgroundLoad);
      }
      
      public function handleBackgroundLoad(param1:Event) : *
      {
         param1.target.removeEventListener(Event.COMPLETE,this.handleBackgroundLoad);
         this.clearLoadedBackground();
         this.backgroundMC = param1.target.content[BG_Linkage];
         this.backgroundMC.width += 100;
         BattleManager.getBattle().bgHolder.addChild(this.backgroundMC);
         if(Character.is_jounin_stage_4)
         {
            BattleLoader.bg_holder = this.backgroundMC;
            BattleManager.getBattle().setRandomStage();
         }
         param1.target.loader.unloadAndStop(true);
      }
      
      public function clearLoadedBackground() : *
      {
         if(this.backgroundMC != null)
         {
            if(BattleManager.getBattle() != null)
            {
               GF.removeAllChild(BattleManager.getBattle().bgHolder);
            }
            this.backgroundMC.cacheAsBitmap = false;
            GF.removeAllChild(this.backgroundMC);
            this.backgroundMC = null;
         }
      }
      
      public function hideEverything() : *
      {
         var _loc1_:Battle = BattleManager.getBattle();
         _loc1_.char_hpcp.visible = false;
         _loc1_.atbBar.visible = false;
         _loc1_.btn_UI_Gear.visible = false;
         _loc1_.sushiMc.visible = false;
         _loc1_.actionBar.enemyMcInfo_0.visible = false;
         _loc1_.actionBar.enemyMcInfo_1.visible = false;
         _loc1_.actionBar.enemyMcInfo_2.visible = false;
         _loc1_.actionBar.visible = false;
         _loc1_.actionBar1.visible = false;
         _loc1_.actionBar2.visible = false;
         _loc1_.atk_turnTimerTxt.visible = false;
         _loc1_.totalDamageHint.visible = false;
         var _loc2_:int = Character.temp_recruit_ids.length > 0 ? int(Character.temp_recruit_ids.length) : int(Character.character_recruit_ids.length);
         _loc1_.rekrut.text = _loc2_ + "/2";
         _loc1_.versionTxt.text = Character.build_num.replace("Public ","");
         if(int(Character.character_lvl) <= 80 && int(Character.character_rank) < 8)
         {
            _loc1_.senjutsuTransition.visible = false;
            _loc1_.actionBar.btn_senjutsu.visible = false;
            _loc1_.actionBar.btn_ninjutsu.visible = false;
            _loc1_.char_hpcp.btn_activate_senjutsu.visible = false;
            _loc1_.char_hpcp.txt_sp.visible = false;
            _loc1_.char_hpcp.spBar.visible = false;
            _loc1_.char_hpcp.spBarBg.visible = false;
            _loc1_.char_hpcp.spIcon.visible = false;
            _loc1_.char_hpcp.black_bg.height = 38.45;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc1_["charMc_" + String(_loc3_)].visible = false;
            _loc1_["charPetMc_" + String(_loc3_)].visible = false;
            _loc1_["enemyMc_" + String(_loc3_)].visible = false;
            _loc1_["enemyPetMc_" + String(_loc3_)].visible = false;
            _loc1_["scrollDisplayMc_" + String(_loc3_)].visible = false;
            _loc3_++;
         }
         _loc1_ = null;
      }
      
      public function destroy() : *
      {
         if(bg_holder != null)
         {
            GF.removeAllChild(bg_holder);
         }
         this.clearLoadedBackground();
         bg_holder = null;
         BG_Linkage = null;
      }
   }
}

