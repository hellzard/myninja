package Popups
{
   import Managers.NinjaSage;
   import Panels.TalentShop;
   import Storage.Character;
   import Storage.GameData;
   import Storage.TalentInfo;
   import Storage.TalentSkillDescriptions;
   import bloodline_shop_fla.bloodline_display_40;
   import bloodline_shop_fla.description_68;
   import bloodline_shop_fla.discoverMc_69;
   import bloodline_shop_fla.emblem_64;
   import bloodline_shop_fla.icon_emblem2_71;
   import bloodline_shop_fla.skill_tree_62;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EventHandler;
   import id.ninjasage.Util;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1360")]
   public class TalentsShow extends MovieClip
   {
      
      public var btnClose:MovieClip;
      
      public var btn_Headquarter:SimpleButton;
      
      public var btnDiscover:MovieClip;
      
      public var btnLearnPad:discoverMc_69;
      
      public var btnNextPage:SimpleButton;
      
      public var btnPrevPage:SimpleButton;
      
      public var emblemMC:icon_emblem2_71;
      
      public var getMoreBtn:SimpleButton;
      
      public var goldTxt:TextField;
      
      public var pageTxt:TextField;
      
      public var panelMC:bloodline_display_40;
      
      public var skill_0:MovieClip;
      
      public var skill_1:MovieClip;
      
      public var skill_2:MovieClip;
      
      public var skill_3:MovieClip;
      
      public var tokenTxt:TextField;
      
      public var treeDescMC:description_68;
      
      public var treeMC:skill_tree_62;
      
      public var treePriceMC:emblem_64;
      
      public var parent_mc:TalentShop;
      
      public var main:*;
      
      public var tooltip:ToolTip = null;
      
      public var curr_mode:*;
      
      public var extreme_talents:*;
      
      public var extreme_talents_lab:*;
      
      public var extreme_talents_skills:*;
      
      public var secret_talents:*;
      
      public var secret_talents_lab:*;
      
      public var secret_talents_skills:*;
      
      public var selected_talent:* = 0;
      
      public var array_info_holder:*;
      
      public var curr_page:* = 1;
      
      public var total_page:* = 1;
      
      public var swf_loading:* = "";
      
      public var eventHandler:*;
      
      public function TalentsShow()
      {
         super();
      }
      
      public function openThis(param1:*) : *
      {
         this.extreme_talents = [];
         this.extreme_talents_lab = [];
         this.extreme_talents_skills = [];
         this.secret_talents = [];
         this.secret_talents_lab = [];
         this.secret_talents_skills = [];
         var _loc2_:* = GameData.get("talent_shop");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.extreme.length)
         {
            this.extreme_talents.push(_loc2_.extreme[_loc3_].id);
            this.extreme_talents_lab.push(_loc2_.extreme[_loc3_].lab);
            this.extreme_talents_skills.push(_loc2_.extreme[_loc3_].skill);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.secret.length)
         {
            this.secret_talents.push(_loc2_.secret[_loc3_].id);
            this.secret_talents_lab.push(_loc2_.secret[_loc3_].lab);
            this.secret_talents_skills.push(_loc2_.secret[_loc3_].skill);
            _loc3_++;
         }
         this.array_info_holder = [];
         this.parent_mc = param1;
         this.main = param1.main;
         this.eventHandler = new EventHandler();
         this.init();
      }
      
      public function init(param1:MouseEvent = null) : *
      {
         if(this.tooltip == null)
         {
            this.tooltip = ToolTip.getInstance();
         }
         this.total_page = Math.max(Math.ceil(this.extreme_talents.length / 4),1);
         this.curr_mode = "Extreme";
         this.curr_page = 1;
         this.addButtonListeners();
         this.initMovieClips();
         this.setTexts();
      }
      
      public function initSecret(param1:MouseEvent) : *
      {
         if(this.tooltip == null)
         {
            this.tooltip = ToolTip.getInstance();
         }
         this.total_page = Math.max(Math.ceil(this.secret_talents.length / 4),1);
         this.curr_mode = "Secret";
         this.curr_page = 1;
         this.addButtonListeners();
         this.initMovieClipsSecret();
         this.setTexts();
      }
      
      public function setTexts() : *
      {
         this.goldTxt.text = Character.character_gold;
         this.tokenTxt.text = String(Character.account_tokens);
         this.updatePageText();
      }
      
      public function initMovieClips() : *
      {
         this.panelMC.gotoAndStop("BL");
         this.main.initButton(this.panelMC.btnSecret,this.initSecret,"Secret");
         this.selected_talent = 0;
         this.loadTalents();
      }
      
      public function initMovieClipsSecret() : *
      {
         this.panelMC.gotoAndStop("SE");
         this.main.initButton(this.panelMC.btnBloodline,this.init,"Extreme");
         this.selected_talent = 0;
         this.loadTalentsSecret();
      }
      
      public function hideTalents() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            this["skill_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      public function changePage(param1:MouseEvent) : *
      {
         switch(param1.currentTarget.name)
         {
            case "btnNextPage":
               if(this.curr_page < this.total_page)
               {
                  ++this.curr_page;
                  this.selected_talent = int((this.curr_page - 1) * 4);
                  if(this.curr_mode == "Extreme")
                  {
                     this.loadTalents();
                  }
                  else
                  {
                     this.loadTalentsSecret();
                  }
               }
               break;
            case "btnPrevPage":
               if(this.curr_page > 1)
               {
                  --this.curr_page;
                  this.selected_talent = int((this.curr_page - 1) * 4);
                  if(this.curr_mode == "Extreme")
                  {
                     this.loadTalents();
                  }
                  else
                  {
                     this.loadTalentsSecret();
                  }
               }
         }
         this.updatePageText();
      }
      
      public function updatePageText() : *
      {
         this.pageTxt.text = this.curr_page + "/" + this.total_page;
      }
      
      public function loadNewTalent(param1:MouseEvent) : *
      {
         this.selected_talent = int(param1.currentTarget.name.replace("skill_",""));
         this.selected_talent = int(this.selected_talent) + int((this.curr_page - 1) * 4);
         if(this.curr_mode == "Extreme")
         {
            this.loadTalents();
            this.addButtonListeners();
         }
         else
         {
            this.loadTalentsSecret();
            this.addButtonListeners();
         }
      }
      
      public function loadTalents() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.array_info_holder = [];
         this.hideTalents();
         var _loc4_:* = 0;
         while(_loc4_ < this.extreme_talents.length)
         {
            _loc1_ = _loc4_ + int((this.curr_page - 1) * 4);
            if(!(this.extreme_talents.length <= _loc1_ || _loc4_ > 3))
            {
               _loc2_ = TalentInfo.getTalentInfos(this.extreme_talents[_loc1_]);
               GF.removeAllChild(this["skill_" + _loc4_].icon.holder);
               this["skill_" + _loc4_].visible = true;
               this["skill_" + _loc4_].icon.gotoAndStop("enable");
               this["skill_" + _loc4_].highlight.gotoAndStop("idle");
               _loc3_ = getDefinitionByName(this.extreme_talents[_loc1_] + "_logo") as Class;
               this["skill_" + _loc4_].icon.holder.addChild(new _loc3_());
               this["skill_" + _loc4_].iconBlock.visible = false;
               if(Character.character_talent_1 == this.extreme_talents[_loc1_])
               {
                  this["skill_" + _loc4_].iconBlock.visible = true;
               }
               this["skill_" + _loc4_].emblemMC.gotoAndStop(_loc2_.is_emblem ? "show" : "idle");
               this["skill_" + _loc4_].nameTxt.text = _loc2_.talent_name;
               this["skill_" + _loc4_].icon.typeIcon.gotoAndStop(this.curr_mode == "Extreme" ? 1 : 2);
               this.eventHandler.addListener(this["skill_" + _loc4_],MouseEvent.CLICK,this.loadNewTalent);
               if(_loc1_ == this.selected_talent)
               {
                  this["skill_" + _loc4_].highlight.gotoAndStop("show");
                  this.fillTreeMC();
                  this.fillTalentInfo();
                  this.fillTalentPriceInfo();
               }
            }
            _loc4_++;
         }
      }
      
      public function loadTalentsSecret() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.array_info_holder = [];
         this.hideTalents();
         var _loc4_:* = 0;
         while(_loc4_ < this.secret_talents.length)
         {
            _loc1_ = _loc4_ + int((this.curr_page - 1) * 4);
            if(!(this.secret_talents.length <= _loc1_ || _loc4_ > 3))
            {
               _loc2_ = TalentInfo.getTalentInfos(this.secret_talents[_loc1_]);
               GF.removeAllChild(this["skill_" + _loc4_].icon.holder);
               this["skill_" + _loc4_].visible = true;
               this["skill_" + _loc4_].icon.gotoAndStop("enable");
               this["skill_" + _loc4_].highlight.gotoAndStop("idle");
               _loc3_ = getDefinitionByName(this.secret_talents[_loc1_] + "_logo") as Class;
               this["skill_" + _loc4_].icon.holder.addChild(new _loc3_());
               this["skill_" + _loc4_].iconBlock.visible = false;
               if(Character.character_talent_2 == this.secret_talents[_loc1_])
               {
                  this["skill_" + _loc4_].iconBlock.visible = true;
               }
               if(Character.character_talent_3 == null && Character.character_rank == "7")
               {
                  this.btnDiscover.visible = true;
                  this.main.initButton(this.btnDiscover,this.discoverTalent,"Discover");
               }
               if(Character.character_talent_3 == this.secret_talents[_loc1_])
               {
                  this["skill_" + _loc4_].iconBlock.visible = true;
               }
               this["skill_" + _loc4_].emblemMC.gotoAndStop(_loc2_.is_emblem ? "show" : "idle");
               this["skill_" + _loc4_].nameTxt.text = _loc2_.talent_name;
               this["skill_" + _loc4_].icon.typeIcon.gotoAndStop(this.curr_mode == "Secret" ? 1 : 2);
               this.eventHandler.addListener(this["skill_" + _loc4_],MouseEvent.CLICK,this.loadNewTalent);
               if(_loc1_ == this.selected_talent)
               {
                  this["skill_" + _loc4_].highlight.gotoAndStop("show");
                  this.fillTreeMCSecret();
                  this.fillTalentInfoSecret();
                  this.fillTalentPriceInfoSecret();
               }
            }
            _loc4_++;
         }
      }
      
      public function fillTreeMC() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.treeMC.gotoAndStop(this.extreme_talents_lab[this.selected_talent]);
         var _loc3_:* = this.extreme_talents_skills[this.selected_talent];
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = "talent_" + this.extreme_talents[this.selected_talent] + "_skill_" + String(int(_loc4_) + 1);
            _loc1_ = TalentSkillDescriptions.getTalentSkillDescriptions(_loc2_);
            this.array_info_holder.push([_loc1_.talent_skill_name,_loc1_.talent_skill_description]);
            this.treeMC["skill_" + _loc4_].gotoAndStop("enable");
            this.treeMC["skill_" + _loc4_].typeIcon.gotoAndStop(this.curr_mode == "Extreme" ? 1 : 2);
            this.eventHandler.addListener(this.treeMC["skill_" + String(_loc4_)],MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
            this.eventHandler.addListener(this.treeMC["skill_" + String(_loc4_)],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
            GF.removeAllChild(this.treeMC["skill_" + _loc4_].holder);
            if("talent_skill_id" in _loc1_)
            {
               NinjaSage.loadIconSWF("skills",_loc1_.talent_skill_id,this.treeMC["skill_" + _loc4_].holder,"with_holder");
            }
            _loc4_++;
         }
      }
      
      public function fillTreeMCSecret() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.treeMC.gotoAndStop(this.secret_talents_lab[this.selected_talent]);
         var _loc3_:* = this.secret_talents_skills[this.selected_talent];
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = "talent_" + this.secret_talents[this.selected_talent] + "_skill_" + String(int(_loc4_) + 1);
            _loc1_ = TalentSkillDescriptions.getTalentSkillDescriptions(_loc2_);
            this.array_info_holder.push([_loc1_.talent_skill_name,_loc1_.talent_skill_description]);
            this.treeMC["skill_" + _loc4_].gotoAndStop("enable");
            this.treeMC["skill_" + _loc4_].typeIcon.gotoAndStop(this.curr_mode == "Extreme" ? 1 : 2);
            this.eventHandler.addListener(this.treeMC["skill_" + String(_loc4_)],MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
            this.eventHandler.addListener(this.treeMC["skill_" + String(_loc4_)],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
            GF.removeAllChild(this.treeMC["skill_" + _loc4_].holder);
            if("talent_skill_id" in _loc1_)
            {
               NinjaSage.loadIconSWF("skills",_loc1_.talent_skill_id,this.treeMC["skill_" + _loc4_].holder,"with_holder");
            }
            _loc4_++;
         }
      }
      
      internal function toolTiponOver(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         _loc2_ = _loc2_.replace("skill_","");
         var _loc3_:* = "" + this.array_info_holder[int(_loc2_)][0] + "\n(Skill)\n" + this.array_info_holder[int(_loc2_)][1];
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc3_);
      }
      
      internal function toolTiponOut(param1:MouseEvent) : void
      {
         this.tooltip.hide();
      }
      
      public function fillTalentInfo() : *
      {
         var _loc1_:* = TalentInfo.getTalentInfos(this.extreme_talents[this.selected_talent]);
         this.treeDescMC.gotoAndStop(this.curr_mode == "Extreme" ? "BL" : "SE");
         this.treeDescMC.treeNameTxt.text = _loc1_.talent_name;
         this.treeDescMC.treeDescTxt.text = _loc1_.talent_description;
      }
      
      public function fillTalentInfoSecret() : *
      {
         var _loc1_:* = TalentInfo.getTalentInfos(this.secret_talents[this.selected_talent]);
         this.treeDescMC.gotoAndStop(this.curr_mode == "Extreme" ? "BL" : "SE");
         this.treeDescMC.treeNameTxt.text = _loc1_.talent_name;
         this.treeDescMC.treeDescTxt.text = _loc1_.talent_description;
      }
      
      public function fillTalentPriceInfo() : *
      {
         var _loc1_:* = TalentInfo.getTalentInfos(this.extreme_talents[this.selected_talent]);
         this.treePriceMC.gotoAndStop(this.curr_mode == "Extreme" ? "BL" : "SE");
         this.treePriceMC.treePriceTxt.text = this.curr_mode == "Extreme" ? "Lv. 40 or Above" : "Lv. 50 or Above";
         this.treePriceMC.priceIcon.gotoAndStop("gold");
         this.treePriceMC.priceIcon1.gotoAndStop("token");
         this.treePriceMC.priceToken.text = Util.formatNumberWithDot(_loc1_.price_token);
         this.treePriceMC.priceGold.text = Util.formatNumberWithDot(_loc1_.price_gold);
         this.emblemMC.gotoAndStop(_loc1_.is_emblem ? "show" : "idle");
      }
      
      public function fillTalentPriceInfoSecret() : *
      {
         var _loc1_:* = TalentInfo.getTalentInfos(this.secret_talents[this.selected_talent]);
         this.treePriceMC.gotoAndStop(this.curr_mode == "Extreme" ? "BL" : "SE");
         this.treePriceMC.treePriceTxt.text = this.curr_mode == "Extreme" ? "Lv. 40 or Above" : "Lv. 50 or Above";
         this.treePriceMC.priceIcon.gotoAndStop("gold");
         this.treePriceMC.priceIcon1.gotoAndStop("token");
         this.treePriceMC.priceToken.text = Util.formatNumberWithDot(_loc1_.price_token);
         this.treePriceMC.priceGold.text = Util.formatNumberWithDot(_loc1_.price_gold);
         this.emblemMC.gotoAndStop(_loc1_.is_emblem ? "show" : "idle");
      }
      
      public function addButtonListeners() : *
      {
         this.main.initButton(this.btnClose,this.closeThis);
         this.eventHandler.addListener(this.btn_Headquarter,MouseEvent.CLICK,this.openExternalPanel);
         this.eventHandler.addListener(this.btnNextPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btnPrevPage,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.getMoreBtn,MouseEvent.CLICK,this.openRecharge);
         if(this.curr_mode == "Extreme")
         {
            if(Character.character_talent_1)
            {
               this.btnDiscover.visible = false;
               this.btnLearnPad.txt.text = "Learned";
            }
            else
            {
               this.btnDiscover.visible = true;
               this.main.initButton(this.btnDiscover,this.discoverTalent,"Discover");
            }
         }
         if(this.curr_mode == "Secret")
         {
            if(Character.character_talent_2)
            {
               this.btnDiscover.visible = false;
               this.btnLearnPad.txt.text = "Learned";
            }
            else
            {
               this.btnDiscover.visible = true;
               this.main.initButton(this.btnDiscover,this.discoverTalent,"Discover");
            }
            if(Character.character_talent_3)
            {
               this.btnDiscover.visible = false;
               this.btnLearnPad.txt.text = "Learned";
            }
            else if(Character.character_talent_2 != null && int(Character.character_rank) < 6)
            {
               this.btnDiscover.visible = false;
               this.btnLearnPad.txt.text = "Must Sp.Jounin";
            }
            else
            {
               this.btnDiscover.visible = true;
               this.main.initButton(this.btnDiscover,this.discoverTalent,"Discover");
            }
         }
      }
      
      public function discoverTalentAMF(param1:MouseEvent) : *
      {
         this.parent_mc.confirmBox.visible = false;
         this.main.loading(true);
         var _loc2_:* = undefined;
         if(this.curr_mode == "Extreme")
         {
            _loc2_ = this.extreme_talents[this.selected_talent];
         }
         else
         {
            _loc2_ = this.secret_talents[this.selected_talent];
         }
         this.main.amf_manager.service("RzFUf16G1EIy2bfB.Jnc7tAbUlYqG",[Character.char_id,Character.sessionkey,this.curr_mode,_loc2_],this.onTalentDiscovered);
      }
      
      public function discoverTalent(param1:MouseEvent) : *
      {
         var _loc2_:* = this.treeDescMC.treeNameTxt.text;
         var _loc3_:* = this.treePriceMC.priceGold.text + " Gold and " + this.treePriceMC.priceToken.text + " Token";
         this.parent_mc.showConfirmationBox("Are you sure want to use " + _loc3_ + " to discover " + _loc2_,this.discoverTalentAMF);
      }
      
      public function onTalentDiscovered(param1:Object) : *
      {
         this.main.loading(false);
         if(param1.status > 0)
         {
            if(param1.status > 1)
            {
               this.main.showMessage(param1.result);
               return;
            }
            if(param1.newt == 1)
            {
               Character.character_talent_1 = this.extreme_talents[this.selected_talent];
            }
            else if(param1.newt == 2)
            {
               Character.character_talent_2 = this.secret_talents[this.selected_talent];
            }
            else if(param1.newt == 3)
            {
               Character.character_talent_3 = this.secret_talents[this.selected_talent];
            }
            Character.account_tokens = param1.tokens;
            Character.character_gold = param1.golds;
            this.main.giveMessage("You have successfully learned new talent!");
            this.main.HUD.setBasicData();
            if(this.curr_mode == "Extreme")
            {
               this.loadTalents();
            }
            else
            {
               this.loadTalentsSecret();
            }
            this.setTexts();
            this.btnDiscover.visible = false;
            this.btnLearnPad.txt.text = "Learned";
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      public function openRecharge(param1:MouseEvent) : *
      {
         this.main.loadPanel("Panels.Recharge");
      }
      
      public function closeThis(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.curr_mode == "Extreme")
         {
            this.treeMC.gotoAndStop(this.extreme_talents_lab[this.selected_talent]);
            _loc2_ = this.extreme_talents_skills[this.selected_talent];
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               GF.removeAllChild(this.treeMC["skill_" + _loc3_].holder);
               _loc3_++;
            }
         }
         else
         {
            this.treeMC.gotoAndStop(this.secret_talents_lab[this.selected_talent]);
            _loc4_ = this.secret_talents_skills[this.selected_talent];
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               GF.removeAllChild(this.treeMC["skill_" + _loc5_].holder);
               _loc5_++;
            }
         }
         if(NinjaSage.loader != null)
         {
            NinjaSage.loader.removeAll();
         }
         this.array_info_holder = [];
         this.extreme_talents = [];
         this.extreme_talents_lab = [];
         this.extreme_talents_skills = [];
         this.secret_talents = [];
         this.secret_talents_lab = [];
         this.secret_talents_skills = [];
         this.eventHandler.removeAllEventListeners();
         this.tooltip.destroy();
         this.main = null;
         this.parent_mc = null;
         this.tooltip = null;
         this.eventHandler = null;
         this.visible = false;
         System.gc();
      }
      
      internal function openExternalPanel(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.name.replace("btn_","");
         this.main.loadExternalSwfPanel(_loc2_,_loc2_);
      }
   }
}

