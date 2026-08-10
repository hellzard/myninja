package id.ninjasage.pvp.battle
{
   import Managers.OutfitManager;
   import Popups.Confirmation;
   import Storage.Character;
   import Storage.SenjutsuSkillLevel;
   import Storage.SkillLibrary;
   import Storage.TalentSkillLevel;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Log;
   import id.ninjasage.pvp.PvPSocket;
   
   public class PvPActionManager
   {
      
      private var _destroyed:Boolean = false;
      
      private var _team:String;
      
      private var _playerNumber:int;
      
      private var _actionBar:MovieClip;
      
      private var _equippedSkills:Array = [];
      
      private var _loading_skill_id:String = "";
      
      private var _loading_skill_number:int = 0;
      
      private var _loading_active_skill_index:int = 0;
      
      private var _eventHandler:EventHandler;
      
      private var _skill_icons:Array = [];
      
      private var _talent_icons:Array = [];
      
      private var _senjutsu_icons:Array = [];
      
      private var _charId:Number = 0;
      
      private var _character_skills_mc:Array = [];
      
      private var _character_senjutsu_skills_mc:Array = [];
      
      private var _character_talent_skills_mc:Array = [];
      
      private var _character_talent_passive_skills_mc:Array = [];
      
      private var _character_senjutsu_passive_skills_mc:Array = [];
      
      private var _character_talent_skills_info:Array = [];
      
      private var _character_senjutsu_skills_info:Array = [];
      
      private var _special_skill_id:String = "";
      
      private var _special_skill_handler:PvPSkillHandler = null;
      
      private var _special_skill_icon:MovieClip = null;
      
      private var _copy_skill_id:String = "";
      
      private var _copy_skill_handler:PvPSkillHandler = null;
      
      private var _cooldown_info:Object = {};
      
      private var _confirmation:Confirmation = null;
      
      public function PvPActionManager(param1:String = "player", param2:int = 0, param3:Number = 0)
      {
         super();
         this._team = param1;
         this._playerNumber = param2;
         this._charId = param3;
         this._eventHandler = new EventHandler();
         this.fillActionBar();
      }
      
      public function fillActionBar() : *
      {
         var _loc1_:String = "actionBar";
         if(this._playerNumber == 1)
         {
            _loc1_ = "actionBar1";
         }
         if(this._playerNumber == 2)
         {
            _loc1_ = "actionBar2";
         }
         this._actionBar = PvPBattleManager.getBattle()[_loc1_];
         if(PvPBattleManager.PVP.character.getID() === this._charId)
         {
            this.hideTalents();
            this.addButtonListeners();
            this.checkSwitchSenjutsuNinjutsu();
            this.checkScrollsDisplay();
         }
         this.getEquippedSkillsAndLoad();
      }
      
      public function getEquippedSkillsAndLoad() : *
      {
         this._equippedSkills = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getEquippedSkills();
         this.loadEquippedSkills();
      }
      
      public function loadEquippedSkills() : *
      {
         if(this._equippedSkills.length > this._loading_skill_number)
         {
            this._loading_skill_id = this._equippedSkills[this._loading_skill_number];
            PvPBattleManager.getMain().loadSkillSWF(this._loading_skill_id,this.onSkillSWFLoaded);
         }
         else
         {
            Log.debug(this,this._team + this._playerNumber,"Completed loading basic skills");
            this.getTalentSkillsAndLoad();
         }
      }
      
      public function onSkillSWFLoaded(param1:*) : void
      {
         var _loc7_:* = undefined;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc3_:MovieClip = param1.target.content[this._loading_skill_id];
         _loc3_.gotoAndStop(1);
         _loc3_.stopAllMovieClips();
         var _loc4_:Object = SkillLibrary.getCopy(this._loading_skill_id);
         _loc4_.skill_id = this._loading_skill_id;
         var _loc5_:PvPSkillHandler = new PvPSkillHandler(_loc3_,this._team,this._playerNumber,_loc4_);
         var _loc6_:MovieClip = param1.target.content["icon"];
         this._skill_icons.push(_loc6_);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         if(PvPBattleManager.PVP.character.getID() === this._charId)
         {
            _loc7_ = this._actionBar["skill_" + this._loading_skill_number];
            GF.removeAllChild(_loc7_.holder);
            _loc7_.holder.addChild(_loc6_);
            _loc7_.item_id = this._loading_skill_id;
            _loc7_.is_talent = false;
            _loc7_.is_passive = false;
            this._eventHandler.addListener(_loc7_,MouseEvent.CLICK,this.onUseSkill);
            this._eventHandler.addListener(_loc7_,MouseEvent.MOUSE_OVER,PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
            this._eventHandler.addListener(_loc7_,MouseEvent.MOUSE_OUT,PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
         }
         this._character_skills_mc.push(_loc5_);
         ++this._loading_skill_number;
         this.loadEquippedSkills();
      }
      
      public function getTalentSkillsAndLoad() : *
      {
         var _loc4_:* = undefined;
         this._equippedSkills = [];
         this._loading_skill_number = 0;
         this._loading_active_skill_index = 0;
         this._loading_skill_id = "";
         var _loc1_:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentsSkills();
         var _loc2_:* = [];
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_] != null)
            {
               _loc4_ = _loc1_[_loc3_].split(":");
               _loc2_.push({
                  "item_id":_loc4_[0],
                  "item_level":_loc4_[1]
               });
            }
            _loc3_++;
         }
         this.loadTalentSkills(_loc2_);
      }
      
      public function loadTalentSkills(param1:Array = null) : *
      {
         if(param1 is Array)
         {
            this._equippedSkills = param1;
            this._special_skill_id = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getSpecialClass();
            Log.debug(this,"loadTalentSkills",this._team + this._playerNumber,this._special_skill_id);
         }
         if(this._equippedSkills.length > this._loading_skill_number)
         {
            this._loading_skill_id = this._equippedSkills[this._loading_skill_number].item_id;
            PvPBattleManager.getMain().loadSkillSWF(this._loading_skill_id,this.onTalentSkillSWFLoaded);
         }
         else if(this._special_skill_id != null)
         {
            PvPBattleManager.getMain().loadSkillSWF(this._special_skill_id,this.onClassSkillSWFLoaded);
         }
         else
         {
            Log.debug(this,this._team + this._playerNumber,"Completed loading talent skills");
            this.getSenjutsuSkillAndLoad();
         }
      }
      
      public function onClassSkillSWFLoaded(param1:*) : *
      {
         var _loc6_:PvPSkillHandler = null;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc3_:* = undefined;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = new MovieClip();
         if(param1.target.content[this._special_skill_id])
         {
            _loc3_ = SkillLibrary.getCopy(this._special_skill_id);
            _loc3_.skill_id = this._special_skill_id;
            _loc5_ = param1.target.content[this._special_skill_id];
            _loc5_.gotoAndStop(1);
            _loc5_.stopAllMovieClips();
            _loc6_ = new PvPSkillHandler(_loc5_,this._team,this._playerNumber,_loc3_);
            if(this._special_skill_id == "skill_4002")
            {
               this.checkFillOutfit(_loc6_);
            }
         }
         this._special_skill_handler = _loc6_;
         if(this._special_skill_id == "skill_4003")
         {
            _loc6_.setCurrentCooldown(_loc6_.skill_info.skill_cooldown);
         }
         if(PvPBattleManager.PVP.character.getID() == this._charId)
         {
            this._actionBar["btnClassSkill_1"].visible = true;
            _loc4_ = param1.target.content["icon"];
            this._special_skill_icon = _loc4_;
            GF.removeAllChild(this._actionBar["btnClassSkill_1"].holder);
            this._actionBar["btnClassSkill_1"].holder.addChild(_loc4_);
            this._actionBar["btnClassSkill_1"].item_id = this._special_skill_id;
            this._actionBar["btnClassSkill_1"].is_class = true;
            this._actionBar["btnClassSkill_1"].is_passive = false;
            if(this._special_skill_id != "skill_4002")
            {
               this._eventHandler.addListener(this._actionBar["btnClassSkill_1"],MouseEvent.CLICK,this.onUseClassSkill);
            }
            this._eventHandler.addListener(this._actionBar["btnClassSkill_1"],MouseEvent.MOUSE_OVER,PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
            this._eventHandler.addListener(this._actionBar["btnClassSkill_1"],MouseEvent.MOUSE_OUT,PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
         }
         this.getSenjutsuSkillAndLoad();
      }
      
      public function onTalentSkillSWFLoaded(param1:*) : *
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc16_:PvPSkillHandler = null;
         var _loc17_:* = undefined;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc6_:* = undefined;
         var _loc7_:OutfitManager = null;
         var _loc8_:MovieClip = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:String = null;
         var _loc13_:MovieClip = new MovieClip();
         var _loc14_:Class = null;
         var _loc15_:* = false;
         if(!param1.target.content[this._loading_skill_id])
         {
            _loc15_ = true;
         }
         if(this._loading_skill_id == "skill_1023" || this._loading_skill_id == "skill_1050")
         {
            _loc15_ = true;
         }
         _loc6_ = TalentSkillLevel.getTalentSkillLevels(this._loading_skill_id,PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentLevel(this._loading_skill_id));
         _loc6_.skill_id = this._loading_skill_id;
         if(param1.target.content[this._loading_skill_id])
         {
            _loc13_ = param1.target.content[this._loading_skill_id];
            _loc13_.gotoAndStop(1);
            _loc13_.stopAllMovieClips();
            _loc16_ = new PvPSkillHandler(_loc13_,this._team,this._playerNumber,_loc6_);
         }
         _loc3_ = int(this._loading_skill_id.replace("skill_",""));
         _loc4_ = _loc6_.type == "secret";
         if(PvPBattleManager.PVP.character.getID() == this._charId)
         {
            _loc8_ = param1.target.content["icon"];
            this._talent_icons.push(_loc8_);
            if(_loc15_)
            {
               this._actionBar["starMC"].visible = true;
               this._actionBar["boardMC"].visible = true;
               _loc9_ = 0;
               while(_loc9_ < 12)
               {
                  if(this._actionBar["pass_" + _loc9_].visible == false)
                  {
                     this._actionBar["pass_" + _loc9_].visible = true;
                     GF.removeAllChild(this._actionBar["pass_" + _loc9_].holder);
                     this._actionBar["pass_" + _loc9_].holder.addChild(_loc8_);
                     this._actionBar["pass_" + _loc9_].holder.skill_id = this._loading_skill_id;
                     this._actionBar["pass_" + _loc9_].item_id = this._loading_skill_id;
                     this._actionBar["pass_" + _loc9_].is_talent = true;
                     this._actionBar["pass_" + _loc9_].is_passive = true;
                     this._eventHandler.addListener(this._actionBar["pass_" + _loc9_],MouseEvent.MOUSE_OVER,PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                     this._eventHandler.addListener(this._actionBar["pass_" + _loc9_],MouseEvent.MOUSE_OUT,PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
                     break;
                  }
                  _loc9_++;
               }
            }
            else
            {
               _loc10_ = _loc4_ ? 4 : 0;
               _loc11_ = _loc4_ ? 8 : 4;
               _loc12_ = _loc4_ ? "se_" : "bl_";
               while(_loc10_ < _loc11_)
               {
                  if(this._actionBar[_loc12_ + _loc10_].filled == false)
                  {
                     _loc17_ = _loc12_ + _loc10_;
                     this._actionBar[_loc17_].filled = true;
                     GF.removeAllChild(this._actionBar[_loc17_].holder);
                     this._actionBar[_loc17_].holder.addChild(_loc8_);
                     this._actionBar[_loc17_].cdTxt.text = "";
                     this._actionBar[_loc17_].item_id = this._loading_skill_id;
                     this._actionBar[_loc17_].skill_index = this._loading_active_skill_index;
                     this._actionBar[_loc17_].is_talent = true;
                     this._actionBar[_loc17_].is_passive = false;
                     this._actionBar[_loc17_].is_secondary = _loc4_;
                     this._eventHandler.addListener(this._actionBar[_loc17_],MouseEvent.CLICK,this.useTalentSkill);
                     this._eventHandler.addListener(this._actionBar[_loc17_],MouseEvent.MOUSE_OVER,PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                     this._eventHandler.addListener(this._actionBar[_loc17_],MouseEvent.MOUSE_OUT,PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
                     ++this._loading_active_skill_index;
                     break;
                  }
                  _loc10_++;
               }
            }
         }
         if(!_loc15_)
         {
            this.addTalentSkillMcToArray(_loc16_,_loc17_);
         }
         if(_loc15_)
         {
            this.addTalentPassiveSkillMcToArray(this._equippedSkills[this._loading_skill_number]);
         }
         ++this._loading_skill_number;
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         this.loadTalentSkills();
      }
      
      public function getSenjutsuSkillAndLoad() : *
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         this._equippedSkills = [];
         this._loading_skill_number = 0;
         this._loading_active_skill_index = 0;
         this._loading_skill_id = "";
         var _loc1_:* = {};
         var _loc2_:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
         var _loc3_:* = _loc2_.getSenjutsuSkills();
         var _loc4_:* = _loc2_.getEquippedSenjutsuSkills();
         var _loc5_:* = [];
         var _loc6_:* = 0;
         while(_loc6_ < _loc3_.length)
         {
            if(_loc3_[_loc6_] != null)
            {
               _loc7_ = _loc3_[_loc6_].split(":");
               _loc1_[_loc7_[0]] = int(_loc7_[1]);
               _loc8_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(_loc7_[0],_loc2_.getSenjutsuLevel(_loc7_[0]));
               _loc5_.push({
                  "item_id":_loc7_[0],
                  "item_level":_loc7_[1]
               });
            }
            _loc6_++;
         }
         this.loadSenjutsuSkills(_loc5_);
      }
      
      public function loadSenjutsuSkills(param1:Array = null) : *
      {
         if(param1 is Array)
         {
            this._equippedSkills = param1;
         }
         if(this._equippedSkills.length > this._loading_skill_number)
         {
            this._loading_skill_id = this._equippedSkills[this._loading_skill_number].item_id;
            PvPBattleManager.getMain().loadSkillSWF(this._loading_skill_id,this.onSenjutsuSkillSWFLoaded);
         }
         else
         {
            Log.debug(this,this._team + this._playerNumber,"Completed loading senjutsu skills");
            PvPSocket.getInstance().emit("Battle.readyToFight",{
               "battle_id":PvPBattleManager.getBattleID(),
               "char_id":this._charId,
               "team":this._team,
               "num":this._playerNumber
            });
         }
      }
      
      public function onSenjutsuSkillSWFLoaded(param1:*) : *
      {
         var _loc3_:int = 0;
         var _loc12_:PvPSkillHandler = null;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc4_:* = undefined;
         var _loc5_:OutfitManager = null;
         var _loc6_:MovieClip = null;
         var _loc7_:* = undefined;
         var _loc8_:String = null;
         var _loc9_:MovieClip = new MovieClip();
         var _loc10_:Class = null;
         var _loc11_:* = false;
         _loc4_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(this._loading_skill_id,PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getSenjutsuLevel(this._loading_skill_id));
         _loc4_.skill_id = this._loading_skill_id;
         _loc11_ = _loc4_.cooldown == 0;
         if(Boolean(param1.target.content[this._loading_skill_id]) && !_loc11_)
         {
            _loc9_ = param1.target.content[this._loading_skill_id];
            _loc9_.gotoAndStop(1);
            _loc9_.stopAllMovieClips();
            _loc12_ = new PvPSkillHandler(_loc9_,this._team,this._playerNumber,_loc4_);
         }
         _loc3_ = int(this._loading_skill_id.replace("skill_",""));
         if(PvPBattleManager.PVP.character.getID() == this._charId)
         {
            _loc6_ = param1.target.content["icon"];
            this._senjutsu_icons.push(_loc6_);
            if(_loc11_)
            {
               this._actionBar["starMC"].visible = true;
               this._actionBar["boardMC"].visible = true;
               _loc7_ = 0;
               while(_loc7_ < 12)
               {
                  if(this._actionBar["pass_" + _loc7_].visible == false)
                  {
                     this._actionBar["pass_" + _loc7_].visible = true;
                     GF.removeAllChild(this._actionBar["pass_" + _loc7_].holder);
                     this._actionBar["pass_" + _loc7_].holder.addChild(_loc6_);
                     this._actionBar["pass_" + _loc7_].holder.skill_id = this._loading_skill_id;
                     this._actionBar["pass_" + _loc7_].item_id = this._loading_skill_id;
                     this._actionBar["pass_" + _loc7_].is_senjutsu = true;
                     this._actionBar["pass_" + _loc7_].is_passive = true;
                     this._eventHandler.addListener(this._actionBar["pass_" + _loc7_],MouseEvent.MOUSE_OVER,PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                     this._eventHandler.addListener(this._actionBar["pass_" + _loc7_],MouseEvent.MOUSE_OUT,PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
                     break;
                  }
                  _loc7_++;
               }
            }
            else
            {
               _loc13_ = 0;
               while(_loc13_ < 8)
               {
                  _loc14_ = "senjutsu_" + _loc13_;
                  if(this._actionBar[_loc14_].filled == false)
                  {
                     this._actionBar[_loc14_].filled = true;
                     GF.removeAllChild(this._actionBar[_loc14_].holder);
                     this._actionBar[_loc14_].holder.addChild(_loc6_);
                     this._actionBar[_loc14_].cdTxt.text = "";
                     this._actionBar[_loc14_].item_id = this._loading_skill_id;
                     this._actionBar[_loc14_].skill_index = this._loading_active_skill_index;
                     this._actionBar[_loc14_].is_senjutsu = true;
                     this._actionBar[_loc14_].is_passive = false;
                     this._eventHandler.addListener(this._actionBar[_loc14_],MouseEvent.CLICK,this.useSenjutsuSkill);
                     this._eventHandler.addListener(this._actionBar[_loc14_],MouseEvent.MOUSE_OVER,PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                     this._eventHandler.addListener(this._actionBar[_loc14_],MouseEvent.MOUSE_OUT,PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
                     ++this._loading_active_skill_index;
                     break;
                  }
                  _loc13_++;
               }
            }
         }
         if(!_loc11_)
         {
            this.addSenjutsuSkillMcToArray(_loc12_,_loc14_);
         }
         else
         {
            this.addSenjutsuPassiveSkillMcToArray(this._equippedSkills[this._loading_skill_number]);
         }
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         ++this._loading_skill_number;
         this.loadSenjutsuSkills();
      }
      
      public function addTalentSkillMcToArray(param1:PvPSkillHandler, param2:* = null) : *
      {
         this._character_talent_skills_mc.push(param1);
         if(param1 != null && param2 != null)
         {
            this._character_talent_skills_info.push({
               "mc_index":this._character_talent_skills_mc.length - 1,
               "action_bar_prefix":param2,
               "skill_index":this._loading_skill_id.replace("skill_10","")
            });
         }
      }
      
      public function addTalentPassiveSkillMcToArray(param1:*) : *
      {
         if(PvPBattleManager.PVP.character.getID() != this._charId)
         {
            return;
         }
         this._character_talent_passive_skills_mc.push(param1);
      }
      
      public function getTalentPassiveSkills() : *
      {
         return this._character_talent_passive_skills_mc;
      }
      
      public function getTalentSkillsMC() : *
      {
         return this._character_talent_skills_mc;
      }
      
      public function addSenjutsuSkillMcToArray(param1:PvPSkillHandler, param2:* = null) : *
      {
         this._character_senjutsu_skills_mc.push(param1);
         if(param1 != null && param2 != null)
         {
            this._character_senjutsu_skills_info.push({
               "mc_index":this._character_senjutsu_skills_mc.length - 1,
               "action_bar_prefix":param2,
               "skill_index":this._loading_skill_id.replace("skill_30","")
            });
         }
      }
      
      public function addSenjutsuPassiveSkillMcToArray(param1:*) : *
      {
         this._character_senjutsu_passive_skills_mc.push(param1);
      }
      
      public function getSenjutsuPassiveSkills() : *
      {
         return this._character_senjutsu_passive_skills_mc;
      }
      
      public function getSenjutsuSkillsMC() : *
      {
         return this._character_senjutsu_skills_mc;
      }
      
      public function showActionBar() : void
      {
         this._actionBar.visible = true;
      }
      
      public function hideActionBar() : void
      {
         this._actionBar.visible = false;
         PvPBattleManager.getBattle().atk_turnTimerTxt.visible = false;
      }
      
      public function checkSwitchSenjutsuNinjutsu() : *
      {
         var _loc1_:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
         if(_loc1_.getRank() < 8)
         {
            return;
         }
         this._actionBar["btn_senjutsu"].visible = true;
         this._actionBar["btn_ninjutsu"].visible = false;
      }
      
      public function checkScrollsDisplay() : *
      {
         var _loc3_:int = 0;
         var _loc1_:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
         if(_loc1_.getScrolls() <= 0)
         {
            return;
         }
         var _loc2_:MovieClip = PvPBattleManager.getBattle()["scrollDisplayMc_" + this._playerNumber];
         if(_loc2_)
         {
            _loc2_.visible = true;
            _loc3_ = 1;
            while(_loc3_ <= 5)
            {
               _loc2_["scroll_" + _loc3_].gotoAndStop(1);
               _loc3_++;
            }
         }
      }
      
      public function hideTalents() : *
      {
         var i:* = 0;
         this._actionBar.visible = false;
         this._actionBar["starMC"].visible = false;
         this._actionBar["boardMC"].visible = false;
         this._actionBar["bloodline_Logo"].visible = true;
         this._actionBar["btnClassSkill_1"].visible = false;
         while(i < 12)
         {
            if(i < 8)
            {
               this._actionBar["senjutsu_" + i].visible = false;
               this._actionBar["senjutsu_" + i].filled = false;
            }
            this._actionBar["pass_" + i].visible = false;
            i++;
         }
         i = 0;
         while(i < 4)
         {
            this._actionBar["bl_" + i].filled = false;
            this._actionBar["bl_" + i].visible = true;
            this._actionBar["se_" + String(int(i) + 4)].filled = false;
            this._actionBar["se_" + String(int(i) + 4)].visible = true;
            i++;
         }
         if(PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentType(1) != "")
         {
            try
            {
               this._actionBar["bloodline_Logo"].gotoAndStop(PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentType(1));
            }
            catch(e:*)
            {
            }
         }
         if(PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getRank() >= 8)
         {
            this._eventHandler.addListener(this._actionBar["btn_senjutsu"],MouseEvent.CLICK,this.toggleSenjutsu);
            this._eventHandler.addListener(this._actionBar["btn_ninjutsu"],MouseEvent.CLICK,this.toggleSenjutsu);
         }
      }
      
      public function hideSenjutsu() : *
      {
         this._actionBar["btn_senjutsu"].visible = true;
         this._actionBar["btn_ninjutsu"].visible = false;
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            this._actionBar["senjutsu_" + _loc1_].visible = false;
            this._actionBar["skill_" + _loc1_].visible = true;
            TweenLite.killTweensOf(this._actionBar["senjutsu_" + _loc1_]);
            _loc1_++;
         }
      }
      
      public function showSenjutsu() : *
      {
         this._actionBar["btn_senjutsu"].visible = false;
         this._actionBar["btn_ninjutsu"].visible = true;
         if(Character.senjutsu_animation)
         {
            PvPBattleManager.getBattle()["senjutsuTransition"].gotoAndPlay(2);
         }
         PvPBattleManager.getBattle().setChildIndex(PvPBattleManager.getBattle()["senjutsuTransition"],PvPBattleManager.getBattle().numChildren - 1);
         var _loc1_:* = 0;
         while(_loc1_ < 8)
         {
            this._actionBar["skill_" + _loc1_].visible = false;
            this._actionBar["senjutsu_" + _loc1_].visible = true;
            this._actionBar["senjutsu_" + _loc1_].rotationY = 180;
            TweenLite.killTweensOf(this._actionBar["senjutsu_" + _loc1_]);
            TweenLite.to(this._actionBar["senjutsu_" + _loc1_],1,{"rotationY":0});
            _loc1_++;
         }
      }
      
      public function checkFillOutfit(param1:*) : void
      {
         if(Boolean(param1.isOutfitFilled()) || Character.is_stickman)
         {
            return;
         }
         var _loc2_:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
         param1.fillOutfit(_loc2_.getWeapon(),_loc2_.getBackItem(),_loc2_.getClothing(),_loc2_.getHair(),_loc2_.getFace(),_loc2_.getHairColor(),_loc2_.getSkinColor());
      }
      
      public function addButtonListeners() : *
      {
         this._eventHandler.addListener(this._actionBar["btnAttack"],MouseEvent.CLICK,this.onWeaponAttack);
         this._eventHandler.addListener(this._actionBar["btnDodge"],MouseEvent.CLICK,this.onDodgeTurn);
         this._eventHandler.addListener(this._actionBar["btnCharge"],MouseEvent.CLICK,this.onChargeUsed);
         if("btnRun" in this._actionBar)
         {
            this._eventHandler.addListener(this._actionBar["btnRun"],MouseEvent.CLICK,this.onRun);
         }
      }
      
      public function onUseClassSkill(param1:MouseEvent) : void
      {
         Log.info(this,"onUseClassSkill",param1);
         PvPSocket.getInstance().emit("Battle.action.skill",{
            "battle_id":PvPBattleManager.getBattleID(),
            "skill_id":this._special_skill_handler.skill_info.skill_id
         });
         this.hideActionBar();
      }
      
      public function onUseSkill(param1:MouseEvent) : void
      {
         Log.info(this,"onUseSkill",param1);
         var _loc2_:* = param1.currentTarget.name.replace("skill_","");
         var _loc3_:* = this._character_skills_mc[_loc2_];
         PvPSocket.getInstance().emit("Battle.action.skill",{
            "battle_id":PvPBattleManager.getBattleID(),
            "skill_id":_loc3_.skill_info.skill_id
         });
         this.hideActionBar();
      }
      
      public function useTalentSkill(param1:MouseEvent) : void
      {
         Log.info(this,"useTalentSkill",param1);
         var _loc2_:* = this._actionBar[param1.currentTarget.name].skill_index;
         var _loc3_:* = this._character_talent_skills_mc[_loc2_];
         PvPSocket.getInstance().emit("Battle.action.skill",{
            "battle_id":PvPBattleManager.getBattleID(),
            "skill_id":_loc3_.skill_info.skill_id
         });
         this.hideActionBar();
      }
      
      public function useSenjutsuSkill(param1:MouseEvent) : void
      {
         Log.info(this,"useSenjutsuSkill",param1);
         var _loc2_:* = this._actionBar[param1.currentTarget.name].skill_index;
         var _loc3_:* = this._character_senjutsu_skills_mc[_loc2_];
         PvPSocket.getInstance().emit("Battle.action.skill",{
            "battle_id":PvPBattleManager.getBattleID(),
            "skill_id":_loc3_.skill_info.skill_id
         });
         this.hideActionBar();
      }
      
      public function updateSageModeButton() : void
      {
         var _loc1_:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
         if(_loc1_.getRank() < 8)
         {
            return;
         }
         if(_loc1_.getCurrentSP() >= _loc1_.getMaxSP())
         {
            PvPBattleManager.getMain().initButton(PvPBattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"],this.useSageMode);
         }
         else
         {
            PvPBattleManager.getMain().initButtonDisable(PvPBattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"],this.useSageMode);
         }
      }
      
      public function useSageMode(param1:MouseEvent) : void
      {
         Log.info(this,"useSageMode",param1);
         if(!this._actionBar.visible)
         {
            return;
         }
         PvPSocket.getInstance().emit("Battle.action.skill",{
            "battle_id":PvPBattleManager.getBattleID(),
            "skill_id":"skill_3000"
         });
         this.hideActionBar();
      }
      
      public function updateSkillsCooldownDisplay(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this._cooldown_info = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._character_skills_mc.length)
         {
            if(param1.hasOwnProperty(this._character_skills_mc[_loc2_].skill_info.skill_id))
            {
               _loc3_ = param1[this._character_skills_mc[_loc2_].skill_info.skill_id].cd;
               if(_loc3_ != 0)
               {
                  this._actionBar["skill_" + _loc2_].cdTxt.text = _loc3_;
                  PvPBattleManager.getMain().disableButton(this._actionBar["skill_" + _loc2_].holder);
               }
               else
               {
                  this._actionBar["skill_" + _loc2_].cdTxt.text = "";
                  PvPBattleManager.getMain().enableButton(this._actionBar["skill_" + _loc2_].holder);
               }
               if(_loc3_ == -1)
               {
                  this._actionBar["skill_" + _loc2_].cdTxt.text = "";
                  PvPBattleManager.getMain().disableButton(this._actionBar["skill_" + _loc2_].holder);
               }
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._character_senjutsu_skills_mc.length)
         {
            if(param1.hasOwnProperty(this._character_senjutsu_skills_mc[_loc2_].skill_info.skill_id))
            {
               _loc3_ = param1[this._character_senjutsu_skills_mc[_loc2_].skill_info.skill_id].cd;
               if(_loc3_ != 0)
               {
                  this._actionBar["senjutsu_" + _loc2_].cdTxt.text = _loc3_;
                  PvPBattleManager.getMain().disableButton(this._actionBar["senjutsu_" + _loc2_].holder);
               }
               else
               {
                  this._actionBar["senjutsu_" + _loc2_].cdTxt.text = "";
                  PvPBattleManager.getMain().enableButton(this._actionBar["senjutsu_" + _loc2_].holder);
               }
               if(_loc3_ == -1)
               {
                  this._actionBar["senjutsu_" + _loc2_].cdTxt.text = "";
                  PvPBattleManager.getMain().disableButton(this._actionBar["senjutsu_" + _loc2_].holder);
               }
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._character_talent_skills_info.length)
         {
            _loc4_ = this._character_talent_skills_info[_loc2_].action_bar_prefix;
            _loc5_ = this._character_talent_skills_info[_loc2_].mc_index;
            _loc6_ = this._character_talent_skills_mc[_loc5_];
            if(param1.hasOwnProperty(_loc6_.skill_info.skill_id))
            {
               _loc3_ = param1[_loc6_.skill_info.skill_id].cd;
               if(_loc3_ != 0)
               {
                  this._actionBar[_loc4_].cdTxt.text = _loc3_;
                  PvPBattleManager.getMain().disableButton(this._actionBar[_loc4_].holder);
               }
               else
               {
                  this._actionBar[_loc4_].cdTxt.text = "";
                  PvPBattleManager.getMain().enableButton(this._actionBar[_loc4_].holder);
               }
               if(_loc3_ == -1)
               {
                  this._actionBar[_loc4_].cdTxt.text = "";
                  PvPBattleManager.getMain().disableButton(this._actionBar[_loc4_].holder);
               }
            }
            _loc2_++;
         }
         if(this._special_skill_handler)
         {
            if(param1.hasOwnProperty(this._special_skill_handler.skill_info.skill_id))
            {
               _loc3_ = param1[this._special_skill_handler.skill_info.skill_id].cd;
               if(_loc3_ != 0)
               {
                  this._actionBar["btnClassSkill_1"].cdTxt.text = _loc3_;
                  PvPBattleManager.getMain().disableButton(this._actionBar["btnClassSkill_1"].holder);
               }
               else
               {
                  this._actionBar["btnClassSkill_1"].cdTxt.text = "";
                  PvPBattleManager.getMain().enableButton(this._actionBar["btnClassSkill_1"].holder);
               }
               if(_loc3_ == -1)
               {
                  this._actionBar["btnClassSkill_1"].cdTxt.text = "";
                  PvPBattleManager.getMain().disableButton(this._actionBar["btnClassSkill_1"].holder);
               }
            }
         }
      }
      
      public function updateScrollsDisplay() : void
      {
         var _loc4_:int = 0;
         var _loc1_:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
         if(_loc1_.getScrolls() <= 0)
         {
            return;
         }
         var _loc2_:MovieClip = PvPBattleManager.getBattle()["scrollDisplayMc_" + this._playerNumber];
         var _loc3_:* = _loc1_.getScrolls();
         _loc2_.visible = true;
         if(Boolean(_loc2_) && Boolean(_loc3_))
         {
            _loc4_ = 1;
            while(_loc4_ <= 5)
            {
               _loc2_["scroll_" + _loc4_].gotoAndStop(2);
               if(_loc4_ <= _loc3_)
               {
                  _loc2_["scroll_" + _loc4_].gotoAndStop(1);
               }
               _loc4_++;
            }
         }
      }
      
      public function getCooldownInfo(param1:String) : Object
      {
         return this._cooldown_info[param1];
      }
      
      public function hideCharacterMc() : void
      {
         var _loc1_:* = PvPBattleManager.getBattle().getObjectHolder(this._team,this._playerNumber).charMc;
         var _loc2_:* = PvPBattleManager.getBattle().getObjectHolder(this._team,this._playerNumber).skillMc;
         _loc1_.visible = false;
         _loc2_.visible = true;
         OutfitManager.removeChildsFromMovieClips(_loc2_);
      }
      
      public function showCharacterMc() : void
      {
         PvPBattleManager.getBattle().getObjectHolder(this._team,this._playerNumber).charMc.visible = true;
         PvPBattleManager.getBattle().getObjectHolder(this._team,this._playerNumber).skillMc.visible = false;
      }
      
      public function onWeaponAttack(param1:MouseEvent) : void
      {
         Log.info(this,"onWeaponAttack",param1);
         PvPSocket.getInstance().emit("Battle.action.weapon",{"battle_id":PvPBattleManager.getBattleID()});
         this.hideActionBar();
      }
      
      public function onDodgeTurn(param1:MouseEvent) : void
      {
         Log.info(this,"onDodgeTurn",param1);
         PvPSocket.getInstance().emit("Battle.action.dodge",{"battle_id":PvPBattleManager.getBattleID()});
         PvPBattleManager.BATTLE_HANDLER.stopTurnTimer();
         this.hideActionBar();
      }
      
      public function onChargeUsed(param1:MouseEvent) : void
      {
         Log.info(this,"onChargeUsed",param1);
         PvPSocket.getInstance().emit("Battle.action.charge",{"battle_id":PvPBattleManager.getBattleID()});
         this.hideActionBar();
      }
      
      public function onRun(param1:MouseEvent) : void
      {
         this._confirmation = new Confirmation();
         this._confirmation.txtMc.txt.text = "Are you sure you want to run?";
         this._eventHandler.addListener(this._confirmation.btn_confirm,MouseEvent.CLICK,this.onRunConfirm);
         this._eventHandler.addListener(this._confirmation.btn_close,MouseEvent.CLICK,this.onRunClose);
         PvPBattleManager.getMain().loader.addChild(this._confirmation);
      }
      
      public function onRunClose(param1:MouseEvent) : void
      {
         Log.info(this,"onRunClose",param1);
         GF.removeAllChild(this._confirmation);
         this._confirmation = null;
      }
      
      public function onRunConfirm(param1:MouseEvent) : void
      {
         Log.info(this,"onRunConfirm",param1);
         this.onRunClose(null);
         PvPSocket.getInstance().emit("Battle.action.run",{"battle_id":PvPBattleManager.getBattleID()});
         this.hideActionBar();
      }
      
      public function toggleSenjutsu(param1:MouseEvent) : *
      {
         if(this._actionBar["senjutsu_1"].visible)
         {
            this.hideSenjutsu();
         }
         else
         {
            this.showSenjutsu();
         }
      }
      
      public function playCopySkill(param1:String) : void
      {
         this._copy_skill_id = param1;
         PvPBattleManager.getMain().loadSkillSWF(param1,this.copySkillSWFLoaded);
      }
      
      public function copySkillSWFLoaded(param1:*) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         param1.target.content.gotoAndStop(1);
         param1.target.content.stopAllMovieClips();
         var _loc3_:Object = SkillLibrary.getCopy(this._copy_skill_id);
         if(_loc3_.skill_type == "9")
         {
            _loc3_ = TalentSkillLevel.getTalentSkillLevels(this._copy_skill_id,PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentLevel(this._copy_skill_id));
         }
         if(_loc3_.skill_type == "11")
         {
            _loc3_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(this._copy_skill_id,PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getSenjutsuLevel(this._copy_skill_id));
         }
         _loc3_.skill_id = this._copy_skill_id;
         if(this._copy_skill_handler)
         {
            this._copy_skill_handler.destroy();
            this._copy_skill_handler = null;
         }
         var _loc4_:* = param1.target.content[this._copy_skill_id];
         _loc4_.gotoAndStop(1);
         _loc4_.stopAllMovieClips();
         this._copy_skill_handler = new PvPSkillHandler(_loc4_,this._team,this._playerNumber,_loc3_);
         try
         {
            param1.target.loader.unloadAndStop(true);
         }
         catch(e:*)
         {
         }
         this.playSkill(this._copy_skill_id);
      }
      
      public function playSkill(param1:String) : void
      {
         var _loc2_:* = this.getSkillHandlerByID(param1);
         if(!_loc2_)
         {
            Log.error(this,"playSkill","Skill handler not found:",param1);
            return;
         }
         this.hideCharacterMc();
         this.checkFillOutfit(_loc2_);
         _loc2_.setPositionAndAttack(this._team,this._playerNumber,this._playerNumber,false);
         var _loc3_:* = PvPBattleManager.getBattle().getObjectHolder(this._team,this._playerNumber).skillMc;
         _loc3_.addChild(_loc2_.skill_mc);
         _loc2_.skill_mc.gotoAndPlay(1);
      }
      
      public function getSkillHandlerByID(param1:String) : PvPSkillHandler
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(Boolean(this._special_skill_handler) && this._special_skill_handler.skill_info.skill_id == param1)
         {
            return this._special_skill_handler;
         }
         if(Boolean(this._copy_skill_handler) && this._copy_skill_handler.skill_info.skill_id == param1)
         {
            return this._copy_skill_handler;
         }
         var _loc2_:Array = [this._character_skills_mc,this._character_talent_skills_mc,this._character_senjutsu_skills_mc];
         for each(_loc3_ in _loc2_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.skill_info.skill_id == param1)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public function getActionBar() : MovieClip
      {
         return this._actionBar;
      }
      
      public function destroy() : void
      {
         if(this._destroyed)
         {
            return;
         }
         if(this._eventHandler)
         {
            this._eventHandler.removeAllEventListeners();
            this._eventHandler = null;
         }
         if(this._character_skills_mc)
         {
            GF.destroyArray(this._character_skills_mc);
         }
         if(this._character_talent_skills_mc)
         {
            GF.destroyArray(this._character_talent_skills_mc);
         }
         if(this._character_senjutsu_skills_mc)
         {
            GF.destroyArray(this._character_senjutsu_skills_mc);
         }
         if(this._special_skill_handler)
         {
            this._special_skill_handler.destroy();
            this._special_skill_handler = null;
         }
         if(this._skill_icons)
         {
            GF.destroyArray(this._skill_icons);
            this._skill_icons = null;
         }
         if(this._talent_icons)
         {
            GF.destroyArray(this._talent_icons);
            this._talent_icons = null;
         }
         if(this._senjutsu_icons)
         {
            GF.destroyArray(this._senjutsu_icons);
            this._senjutsu_icons = null;
         }
         if(this._special_skill_icon)
         {
            GF.removeAllChild(this._special_skill_icon);
            this._special_skill_icon = null;
         }
         if(this._character_talent_passive_skills_mc)
         {
            GF.clearArray(this._character_talent_passive_skills_mc);
            this._character_talent_passive_skills_mc = null;
         }
         if(this._character_senjutsu_passive_skills_mc)
         {
            GF.clearArray(this._character_senjutsu_passive_skills_mc);
            this._character_senjutsu_passive_skills_mc = null;
         }
         if(this._character_talent_skills_info)
         {
            GF.clearArray(this._character_talent_skills_info);
            this._character_talent_skills_info = null;
         }
         if(this._character_senjutsu_skills_info)
         {
            GF.clearArray(this._character_senjutsu_skills_info);
            this._character_senjutsu_skills_info = null;
         }
         if(this._copy_skill_handler)
         {
            this._copy_skill_handler.destroy();
            this._copy_skill_handler = null;
         }
         this._equippedSkills = null;
         this._cooldown_info = null;
         this._character_senjutsu_passive_skills_mc = null;
         this._character_skills_mc = null;
         this._character_talent_skills_mc = null;
         this._loading_skill_id = null;
         this._special_skill_id = null;
         this._team = null;
         this._actionBar = null;
         this._destroyed = true;
      }
   }
}

