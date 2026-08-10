package Panels
{
   import Managers.NinjaSage;
   import Storage.Character;
   import Storage.Library;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public class Hunting_House extends MovieClip
   {
      
      private var escapeKey:EscapeKeyManager;
      
      public var boss_0:MovieClip;
      
      public var boss_1:MovieClip;
      
      public var boss_2:MovieClip;
      
      public var boss_3:MovieClip;
      
      public var boss_4:MovieClip;
      
      public var btn_close:SimpleButton;
      
      public var btn_fight:SimpleButton;
      
      public var btn_next:SimpleButton;
      
      public var btn_prev:SimpleButton;
      
      public var btn_reset:SimpleButton;
      
      public var btn_Blacksmith:SimpleButton;
      
      public var btn_Recruit:SimpleButton;
      
      public var dropMC:MovieClip;
      
      public var loader_0:MovieClip;
      
      public var loader_1:MovieClip;
      
      public var lock_0:MovieClip;
      
      public var lock_1:MovieClip;
      
      public var lock_2:MovieClip;
      
      public var lock_3:MovieClip;
      
      public var lock_4:MovieClip;
      
      public var pageTxt:TextField;
      
      public var popup:MovieClip;
      
      public var txt_desc:TextField;
      
      public var txt_gold:TextField;
      
      public var txt_xp:TextField;
      
      public var main:*;
      
      internal var boss_rn:* = 0;
      
      internal var curr_page:* = 1;
      
      internal var itemCnt:* = 0;
      
      internal var bossList:* = ["ene_81","ene_82","ene_83",["ene_84","ene_85"],"ene_86","ene_106","ene_120","ene_155"];
      
      internal var total_page:* = 1;
      
      public var curr_page_boss:Array = [];
      
      internal var enemy_data:Array = [];
      
      internal var color:Color = new Color();
      
      public var boss_id:* = "";
      
      public var boss_num:* = -1;
      
      internal var obj:*;
      
      public var tooltip:ToolTip;
      
      public var array_info_holder:Array = [];
      
      public var rewardsArray:Array = [];
      
      private var eventHandler:* = new EventHandler();
      
      public function Hunting_House(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.popup.visible = false;
         this.eventHandler.addListener(this.btn_close,MouseEvent.CLICK,this.closePanel);
         this.eventHandler.addListener(this.btn_reset,MouseEvent.CLICK,this.openPop);
         this.eventHandler.addListener(this.btn_Blacksmith,MouseEvent.CLICK,this.openBlacksmith);
         this.eventHandler.addListener(this.btn_Recruit,MouseEvent.CLICK,this.openSocial);
         this.eventHandler.addListener(this.btn_next,MouseEvent.CLICK,this.changePage);
         this.eventHandler.addListener(this.btn_prev,MouseEvent.CLICK,this.changePage);
         this.tooltip = ToolTip.getInstance();
         this.getData();
      }
      
      internal function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("JDEUnbiWJXOtHxVv.FEoUCYCZHIb7",[Character.sessionkey,Character.char_id],this.dataResponse);
      }
      
      internal function openBlacksmith(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Blacksmith");
      }
      
      internal function openSocial(param1:MouseEvent) : void
      {
         this.main.loadPanel("Panels.Social");
      }
      
      internal function dataResponse(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = param1.data.split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.enemy_data.push(_loc2_[_loc3_]);
               _loc3_++;
            }
            this.loadBasicData(this.enemy_data,this.itemCnt);
         }
         else
         {
            this.main.getError(param1.error_code);
         }
      }
      
      internal function openPop(param1:MouseEvent) : void
      {
         this.popup.visible = true;
         this.eventHandler.addListener(this.popup.btn_close,MouseEvent.CLICK,this.closePop);
         this.eventHandler.addListener(this.popup.bg,MouseEvent.CLICK,this.closePop);
         this.eventHandler.addListener(this.popup.btn_confirm,MouseEvent.CLICK,this.resetTries);
      }
      
      internal function closePop(param1:MouseEvent) : void
      {
         this.popup.visible = false;
      }
      
      internal function resetTries(param1:MouseEvent) : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("HuntingHouse.buyTries",[Character.sessionkey,Character.char_id],this.buyResponse);
      }
      
      internal function buyResponse(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.popup.visible = false;
         this.main.loading(false);
         if(param1.status == 1)
         {
            Character.account_tokens -= 50;
            _loc2_ = param1.data.split(",");
            _loc3_ = 0;
            this.enemy_data = [];
            while(_loc3_ < _loc2_.length)
            {
               this.enemy_data.push(_loc2_[_loc3_]);
               _loc3_++;
            }
            this.loadBasicData(this.enemy_data,this.itemCnt);
         }
         else if(param1.status == 2)
         {
            this.main.getNotice("You dont have enough tokens to reset the hunting attempts.");
         }
         else
         {
            this.main.getError(param1.error_code);
         }
      }
      
      internal function changePage(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "btn_next")
         {
            if(this.curr_page < this.total_page)
            {
               ++this.curr_page;
               this.itemCnt = 5;
               this.loadBasicData(this.enemy_data,this.itemCnt);
            }
         }
         else if(param1.currentTarget.name == "btn_prev")
         {
            if(this.curr_page != 1)
            {
               --this.curr_page;
               this.itemCnt -= 5;
               this.loadBasicData(this.enemy_data,this.itemCnt);
            }
         }
         this.pageTxt.text = this.curr_page + "/" + this.total_page;
      }
      
      internal function loadBasicData(param1:Array, param2:*) : void
      {
         var _loc6_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = 5;
         this.total_page = int(this.bossList.length / 5 + 1);
         if(this.bossList.length < 6)
         {
            _loc4_ = this.bossList.length;
            this.total_page = 1;
         }
         if(this.bossList.length % 5 == 0)
         {
            this.total_page = this.bossList.length / 5;
         }
         this.pageTxt.text = this.curr_page + "/" + this.total_page;
         var _loc5_:* = 0;
         while(_loc5_ < 5)
         {
            _loc3_ = this.loadBossData(param2);
            if(_loc3_["name"] == null)
            {
               this["boss_" + _loc5_].visible = false;
               _loc5_++;
            }
            else
            {
               _loc6_ = {"bossTnc":param2};
               this["boss_" + _loc5_].visible = true;
               this["boss_" + _loc5_].gotoAndStop(1);
               this["boss_" + _loc5_]["txt_name"].text = _loc3_.name;
               this["boss_" + _loc5_]["txt_lvl"].text = _loc3_.lvl;
               this["boss_" + _loc5_]["txt_attempt"].text = "x" + param1[param2];
               this["boss_" + _loc5_]["rankMC"].gotoAndStop(_loc3_.rank);
               this["boss_" + _loc5_]["clickmask"].metaData = _loc6_;
               if(Character.character_lvl >= _loc3_.lvl)
               {
                  if(param1[param2] > 0)
                  {
                     this.color.brightness = 0;
                     this["lock_" + _loc5_].visible = false;
                     this["boss_" + _loc5_]["clickmask"].buttonMode = true;
                     this["boss_" + _loc5_].transform.colorTransform = this.color;
                     this.eventHandler.addListener(this["boss_" + _loc5_]["clickmask"],MouseEvent.MOUSE_OVER,this.bossOver);
                     this.eventHandler.addListener(this["boss_" + _loc5_]["clickmask"],MouseEvent.MOUSE_OUT,this.bossOut);
                     this.eventHandler.addListener(this["boss_" + _loc5_]["clickmask"],MouseEvent.CLICK,this.bossClick);
                  }
                  else
                  {
                     this.color.brightness = -0.3;
                     this["lock_" + _loc5_].visible = false;
                     this["boss_" + _loc5_]["clickmask"].buttonMode = true;
                     this["boss_" + _loc5_].transform.colorTransform = this.color;
                     this.eventHandler.addListener(this["boss_" + _loc5_]["clickmask"],MouseEvent.MOUSE_OVER,this.bossOver);
                     this.eventHandler.addListener(this["boss_" + _loc5_]["clickmask"],MouseEvent.MOUSE_OUT,this.bossOut);
                     this.eventHandler.addListener(this["boss_" + _loc5_]["clickmask"],MouseEvent.CLICK,this.bossClick);
                  }
               }
               else
               {
                  this.color.brightness = -0.3;
                  this["lock_" + _loc5_].visible = true;
                  this["boss_" + _loc5_]["clickmask"].buttonMode = false;
                  this["boss_" + _loc5_].transform.colorTransform = this.color;
                  this["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER,this.bossOver);
                  this["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT,this.bossOut);
                  this["boss_" + _loc5_]["clickmask"].removeEventListener(MouseEvent.CLICK,this.bossClick);
               }
               param2++;
               _loc5_++;
            }
         }
         this.selectBoss(this.itemCnt);
         this["boss_0"].gotoAndStop(3);
      }
      
      internal function bossOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget.parent.currentFrame != 3)
         {
            param1.currentTarget.parent.gotoAndStop(2);
         }
      }
      
      internal function bossOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget.parent.currentFrame != 3)
         {
            param1.currentTarget.parent.gotoAndStop(1);
         }
      }
      
      internal function bossClick(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < 5)
         {
            this["boss_" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         this.boss_rn = param1.currentTarget.metaData.bossTnc;
         param1.currentTarget.parent.gotoAndStop(3);
         var _loc3_:* = param1.currentTarget.parent.name.split("_");
         _loc3_ = _loc3_[1];
         this.selectBoss(this.boss_rn);
      }
      
      internal function selectBoss(param1:int) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         this.array_info_holder = [];
         this.rewardsArray = [];
         var _loc2_:* = this.loadBossData(param1);
         Character.hunting_house_boss_id = this.boss_id = _loc2_.id;
         Character.hunting_house_boss_num = this.boss_num = _loc2_.num;
         this.txt_desc.text = _loc2_.desc;
         this.txt_xp.text = _loc2_.xp;
         this.txt_gold.text = _loc2_.gold;
         if(this.enemy_data[param1] > 0)
         {
            this.color.brightness = 0;
            this.btn_fight.visible = true;
            this.btn_fight.mouseEnabled = true;
            this.btn_fight.transform.colorTransform = this.color;
            this.eventHandler.addListener(this.btn_fight,MouseEvent.CLICK,this.startBattle);
         }
         else
         {
            this.color.brightness = -0.6;
            this.btn_fight.visible = false;
            this.btn_fight.mouseEnabled = false;
            this.btn_fight.transform.colorTransform = this.color;
            this.eventHandler.removeListener(this.btn_fight,MouseEvent.CLICK,this.startBattle);
         }
         while(this.loader_0.numChildren > 0)
         {
            this.loader_0.removeChildAt(0);
         }
         while(this.loader_1.numChildren > 0)
         {
            this.loader_1.removeChildAt(0);
         }
         var _loc3_:* = 0;
         while(_loc3_ < 6)
         {
            this.dropMC["iconMC" + _loc3_].visible = false;
            while(this.dropMC["iconMC" + _loc3_].iconHolder.numChildren > 0)
            {
               this.dropMC["iconMC" + _loc3_].iconHolder.removeChildAt(0);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.rewards.length)
         {
            this.dropMC["iconMC" + _loc3_].visible = true;
            this.eventHandler.addListener(this.dropMC["iconMC" + _loc3_],MouseEvent.ROLL_OVER,this.toolTiponOver,false,0,true);
            this.eventHandler.addListener(this.dropMC["iconMC" + _loc3_],MouseEvent.ROLL_OUT,this.toolTiponOut,false,0,true);
            _loc6_ = _loc2_.rewards[_loc3_];
            _loc7_ = _loc6_.split("_");
            _loc8_ = Library.getItemInfo(_loc6_);
            if(_loc7_[0] == "wpn")
            {
               _loc9_ = "items";
               _loc10_ = new Array(_loc8_["item_name"],_loc8_["item_level"],_loc8_["item_damage"],_loc8_["item_description"]);
            }
            else
            {
               _loc9_ = "materials";
               _loc10_ = new Array(_loc8_["item_name"],_loc8_["item_level"],_loc8_["item_description"]);
            }
            this.array_info_holder.push(_loc10_);
            this.rewardsArray.push(_loc6_);
            GF.removeAllChild(this.dropMC["iconMC" + _loc3_].iconHolder);
            NinjaSage.loadIconSWF(_loc9_,_loc6_,this.dropMC["iconMC" + _loc3_]);
            _loc3_++;
         }
         var _loc4_:* = 0;
         var _loc5_:* = _loc2_.id;
         while(_loc4_ < _loc5_.length)
         {
            NinjaSage.loadIconSWF("enemy",_loc5_[_loc4_],this["loader_" + _loc4_],"StatichuntingHouse");
            _loc4_++;
         }
      }
      
      internal function startBattle(param1:MouseEvent) : void
      {
         if(int(Character.character_lvl) >= 10)
         {
            this.main.loading(true);
            this.main.amf_manager.service("JDEUnbiWJXOtHxVv.CCQV8v8GpKBY",[Character.char_id,this.boss_num,Character.sessionkey],this.onStartHuntingAmf);
         }
      }
      
      public function onStartHuntingAmf(param1:*) : *
      {
         var _loc2_:* = undefined;
         this.main.loading(false);
         if(param1.status == 1)
         {
            _loc2_ = this.loadBossData(this.boss_num);
            Character.mission_id = _loc2_["msn_bg"];
            Character.is_christmas_event = false;
            Character.is_hunting_house = false;
            Character.battle_code = param1.code;
            Character.battle_characters = ["char_" + Character.char_id];
            Character.battle_enemies = this.boss_id;
            this.main.combat = this.main.loadPanel("Panels.Combat",true);
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
      
      internal function loadBossData(param1:int) : *
      {
         var _loc2_:* = {};
         switch(param1)
         {
            case 0:
               _loc2_.id = ["ene_81"];
               _loc2_.num = 0;
               _loc2_.name = "Ginkotsu";
               _loc2_.msn_bg = "mission_21";
               _loc2_.lvl = "10";
               _loc2_.rank = 4;
               _loc2_.desc = "These wolf-like Ginkotsu live in the forest between the Wind Village and the Fire Village. \nThey are the best hunters in the forest. They always attack adventurers and passersby in the forest.";
               _loc2_.rewards = ["wpn_121","material_01","material_02"];
               _loc2_.gold = 4000;
               _loc2_.xp = 1491;
               break;
            case 1:
               _loc2_.id = ["ene_82"];
               _loc2_.num = 1;
               _loc2_.name = "Shikigami Yanki";
               _loc2_.msn_bg = "mission_22";
               _loc2_.lvl = "20";
               _loc2_.rank = 4;
               _loc2_.desc = "Summoned by Kojima. Kojima ordered Yanki to protect Kojima\'s Third Laboratory.\nYanki will not allow anyone to enter the laboratory.";
               _loc2_.rewards = ["wpn_123","material_01","material_02","material_03"];
               _loc2_.gold = 5000;
               _loc2_.xp = 4078;
               break;
            case 2:
               _loc2_.id = ["ene_83"];
               _loc2_.num = 2;
               _loc2_.name = "Gedo Sessho Seki";
               _loc2_.msn_bg = "mission_83";
               _loc2_.lvl = "25";
               _loc2_.rank = 3;
               _loc2_.desc = "Summoned by Kojima, Gedo Sessho Seki is the guardian of his Third Laboratory.";
               _loc2_.rewards = ["wpn_152","material_01","material_02","material_03"];
               _loc2_.gold = 6000;
               _loc2_.xp = 6745;
               break;
            case 3:
               _loc2_.id = ["ene_84","ene_85"];
               _loc2_.num = 3;
               _loc2_.name = "Tengu";
               _loc2_.msn_bg = "mission_84";
               _loc2_.lvl = "30";
               _loc2_.rank = 3;
               _loc2_.desc = "Kojima used Kinjutsu to turn dead bodies into these zombie Tengu.\nThese Tengu can recall and use all jutsu they learned when they were alive. Only the summoner may control them.";
               _loc2_.rewards = ["wpn_120","wpn_122","material_01","material_02","material_03","material_04"];
               _loc2_.gold = 7000;
               _loc2_.xp = 10602;
               break;
            case 4:
               _loc2_.id = ["ene_86"];
               _loc2_.num = 4;
               _loc2_.name = "Byakko";
               _loc2_.msn_bg = "mission_86";
               _loc2_.lvl = "40";
               _loc2_.rank = 2;
               _loc2_.desc = "Many years ago, an escaped ninja attempted to use a Kinjutsu to merge his body with the summon monster \'Byakko\' to gain immortality. \nHe failed. \'Byakko\' devoured him - it is a violent and cruel monster.";
               _loc2_.rewards = ["wpn_124","material_01","material_02","material_03","material_04","material_05"];
               _loc2_.gold = 14000;
               _loc2_.xp = 17834;
               break;
            case 5:
               _loc2_.id = ["ene_106"];
               _loc2_.num = 5;
               _loc2_.name = "Ape King";
               _loc2_.msn_bg = "mission_106";
               _loc2_.lvl = "50";
               _loc2_.rank = 2;
               _loc2_.desc = "Living in the Ape Mountain, Ape King is the leader of all apes.";
               _loc2_.rewards = ["wpn_276","material_01","material_02","material_03","material_04","material_05"];
               _loc2_.gold = 20000;
               _loc2_.xp = 48750;
               break;
            case 6:
               _loc2_.id = ["ene_120"];
               _loc2_.num = 6;
               _loc2_.name = "Battle Turtle";
               _loc2_.msn_bg = "mission_120";
               _loc2_.lvl = "55";
               _loc2_.rank = 2;
               _loc2_.desc = "Originated from the north, the Battle Turtle is known of its age, which is signified by the thorns on its shell.";
               _loc2_.rewards = ["wpn_330","material_01","material_02","material_03","material_04","material_05"];
               _loc2_.gold = 25000;
               _loc2_.xp = 58152;
               break;
            case 7:
               _loc2_.id = ["ene_155"];
               _loc2_.num = 7;
               _loc2_.name = "Soul General Mutoh";
               _loc2_.msn_bg = "mission_155";
               _loc2_.lvl = "60";
               _loc2_.rank = 1;
               _loc2_.desc = "Once dead, but resurrected with (Kinjutsu: Reverse Soul Resurrection), Soul General is now a rank SS-criminal who escaped to the Samu Village and serve as a secret weapon.";
               _loc2_.rewards = ["wpn_786","material_03","material_04","material_05"];
               _loc2_.gold = 30000;
               _loc2_.xp = 68225;
         }
         if(!_loc2_.hasOwnProperty("name"))
         {
            _loc2_.id = null;
            _loc2_.name = null;
         }
         return _loc2_;
      }
      
      public function toolTiponOver(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget.name;
         _loc2_ = _loc2_.replace("iconMC","");
         var _loc3_:* = this.rewardsArray[int(_loc2_)];
         var _loc4_:* = _loc3_.split("_");
         var _loc5_:* = "";
         switch(_loc4_[0])
         {
            case "wpn":
               _loc5_ = "" + this.array_info_holder[int(_loc2_)][0] + "\n(Weapon)\n" + "\nLevel " + this.array_info_holder[int(_loc2_)][1] + "\nDamage : " + this.array_info_holder[int(_loc2_)][2] + "\n\n" + this.array_info_holder[int(_loc2_)][3];
               break;
            case "material":
               _loc5_ = "" + this.array_info_holder[int(_loc2_)][0] + "\n(Material)\n" + "\nLevel " + this.array_info_holder[int(_loc2_)][1] + "\n\n" + this.array_info_holder[int(_loc2_)][2];
         }
         stage.addChild(this.tooltip);
         this.tooltip.followMouse = true;
         this.tooltip.fixedWidth = 350;
         this.tooltip.multiLine = true;
         this.tooltip.show(_loc5_);
      }
      
      internal function toolTiponOut(param1:MouseEvent) : void
      {
         this.tooltip.hide();
      }
      
      internal function killEverything() : void
      {
         this.eventHandler.removeAllEventListeners();
         var _loc1_:* = 0;
         while(_loc1_ < 6)
         {
            GF.removeAllChild(this.dropMC["iconMC" + _loc1_].iconHolder);
            _loc1_++;
         }
         NinjaSage.clearLoader();
         this.color = null;
         this.enemy_data = null;
         this.main = null;
         this.tooltip = null;
         this.popup = null;
         this.eventHandler = null;
         GF.removeAllChild(this);
         System.gc();
      }
      
      internal function closePanel(param1:MouseEvent) : void
      {
         this.killEverything();
         parent.removeChild(this);
      }
   }
}

