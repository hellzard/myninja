package Managers
{
   import Storage.AnimationLibrary;
   import Storage.Character;
   import Storage.ItemDropSourceMapping;
   import Storage.Library;
   import Storage.PetInfo;
   import Storage.SetBuffs;
   import Storage.SkillLibrary;
   import br.com.stimuli.loading.BulkLoader;
   import com.abrahamyan.liquid.ToolTip;
   import com.utils.GF;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EventHandler;
   
   public class NinjaSage
   {
      
      public static var obj;
      
      public static var loader;
      
      public static var loading:Boolean = false;
      
      private static var itemMaps = {};
      
      private static var eventHandler;
      
      public static var tooltip;
      
      private static var main;
       
      
      public function NinjaSage()
      {
         super();
      }
      
      public static function initTooltipAndEventHandler(param1:*) : void
      {
         main = param1;
         eventHandler = new EventHandler();
         tooltip = ToolTip.getInstance();
      }
      
      public static function generateRandomString(param1:Number) : String
      {
         var _loc2_:String = "abcdefghijklmopqrtuvwyzABCDEFGHIJKLMOPQRSTUVWYZ0123456789";
         var _loc3_:Number = _loc2_.length - 1;
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < param1)
         {
            _loc4_ += _loc2_.charAt(Math.floor(Math.random() * _loc3_));
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function getMaterialAmount(param1:*) : *
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:String = Character.character_materials;
         if(!_loc2_ || _loc2_ == "")
         {
            return 0;
         }
         var _loc3_:Array = _loc2_.indexOf(",") >= 0 ? _loc2_.split(",") : [_loc2_];
         for each(_loc4_ in _loc3_)
         {
            if((_loc5_ = _loc4_.split(":"))[0] == param1)
            {
               return _loc5_[1];
            }
         }
         return 0;
      }
      
      public static function clearLoader() : *
      {
         if(!loader)
         {
            return;
         }
         itemMaps = {};
         loader.clear();
         loader = null;
      }
      
      public static function loadIconSWF(param1:*, param2:* = null, param3:* = null, param4:* = null) : void
      {
         var _loc5_:* = undefined;
         ensureIconLoader();
         ensureEventHandler();
         if(param1 is Array && param2 == null && param3 == null)
         {
            for each(_loc5_ in param1)
            {
               queueIconLoad(_loc5_.path,_loc5_.name,_loc5_.holder,_loc5_.type);
            }
         }
         else
         {
            queueIconLoad(param1,param2,param3,param4);
         }
         loading = hasPendingIconItems();
         loader.start();
      }
      
      private static function ensureIconLoader() : void
      {
         if(loader == null)
         {
            loader = BulkLoader.createUniqueNamedLoader(10,BulkLoader.LOG_INFO);
         }
      }
      
      private static function ensureEventHandler() : void
      {
         if(!eventHandler)
         {
            eventHandler = new EventHandler();
         }
      }
      
      private static function queueIconLoad(param1:String, param2:String, param3:*, param4:*) : void
      {
         var _loc5_:String = param2 + "-" + NinjaSage.generateRandomString(4);
         var _loc6_:* = loader.add(param1 + "/" + param2 + ".swf",{"id":_loc5_});
         itemMaps[_loc5_] = {
            "id":_loc5_,
            "path":param1,
            "name":param2,
            "holder":param3,
            "type":param4,
            "isLoaded":false
         };
         _loc6_.addEventListener(Event.COMPLETE,onIconItemLoaded,false,int.MIN_VALUE,true);
         _loc6_.addEventListener(BulkLoader.ERROR,onIconItemError,false,0,true);
      }
      
      private static function onIconItemLoaded(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(!_loc2_)
         {
            return;
         }
         removeIconItemListeners(_loc2_);
         var _loc3_:* = itemMaps[_loc2_.id];
         if(!_loc3_ || _loc3_.isLoaded)
         {
            return;
         }
         _loc3_.isLoaded = true;
         addLoadedIconToHolder(_loc2_,_loc3_);
      }
      
      private static function onIconItemError(param1:ErrorEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_)
         {
            removeIconItemListeners(_loc2_);
            cleanupIconRequest(_loc2_.id);
         }
         removeFailedIconItems();
         updateIconLoadingStatus();
      }
      
      private static function removeFailedIconItems() : void
      {
         var _loc2_:* = undefined;
         if(!loader)
         {
            return;
         }
         var _loc1_:Array = loader.getFailedItems();
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ && _loc2_.id)
            {
               cleanupIconRequest(_loc2_.id);
            }
         }
         updateIconLoadingStatus();
      }
      
      private static function removeIconItemListeners(param1:*) : void
      {
         if(!param1)
         {
            return;
         }
         param1.removeEventListener(Event.COMPLETE,onIconItemLoaded,false);
         param1.removeEventListener(BulkLoader.ERROR,onIconItemError,false);
      }
      
      private static function updateLoadedItems() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(!loader)
         {
            return;
         }
         var _loc1_:Array = [];
         for each(_loc2_ in itemMaps)
         {
            if(!(_loc2_.isLoaded || !loader.hasItem(_loc2_.id,false)))
            {
               _loc2_.isLoaded = true;
               _loc1_.push(_loc2_);
            }
         }
         for each(_loc3_ in _loc1_)
         {
            addLoadedIconToHolder(loader.get(_loc3_.id),_loc3_);
         }
      }
      
      private static function addLoadedIconToHolder(param1:*, param2:*) : void
      {
         var content:* = undefined;
         var type:* = undefined;
         var className:String = null;
         var typeName:String = null;
         var classMC:DisplayObject = null;
         var item:* = param1;
         var itemInfo:* = param2;
         try
         {
            if(!item || !itemInfo || !item.content)
            {
               return;
            }
            content = item.content;
            if(itemInfo.type != null)
            {
               type = itemInfo.type;
               if(type == "with_holder")
               {
                  addIconDisplayToHolder(getContentDisplayObject(content,"icon"),itemInfo.holder);
               }
               else if(type is Array)
               {
                  for each(className in type)
                  {
                     addIconDisplayToHolder(getContentDisplayObject(content,className),getHolderChild(itemInfo.holder,className));
                  }
               }
               else
               {
                  typeName = String(type);
                  classMC = getContentDisplayObject(content,typeName);
                  if(classMC is MovieClip && shouldLoopStandBy(typeName))
                  {
                     addStandByFrameScript(MovieClip(classMC));
                     MovieClip(classMC).gotoAndPlay("standby");
                  }
                  addIconDisplayToHolder(classMC,itemInfo.holder);
               }
            }
            else
            {
               addIconDisplayToHolder(getContentDisplayObject(content,"icon"),getDefaultIconHolder(itemInfo.holder));
            }
         }
         catch(e:Error)
         {
         }
         finally
         {
            cleanupIconRequest(!!itemInfo ? itemInfo.id : null);
            updateIconLoadingStatus();
         }
      }
      
      private static function getContentDisplayObject(param1:*, param2:String) : DisplayObject
      {
         if(!param1 || !param2 || !param1.hasOwnProperty(param2) || !(param1[param2] is DisplayObject))
         {
            return null;
         }
         return DisplayObject(param1[param2]);
      }
      
      private static function addIconDisplayToHolder(param1:DisplayObject, param2:*) : void
      {
         if(!param1 || !param2)
         {
            return;
         }
         disableIconMouseEvents(param1);
         if(!Character.play_items_animation && param1 is MovieClip)
         {
            MovieClip(param1).stopAllMovieClips();
         }
         param2.addChild(param1);
      }
      
      private static function disableIconMouseEvents(param1:DisplayObject) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1 is InteractiveObject)
         {
            InteractiveObject(param1).mouseEnabled = false;
         }
         if(param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).mouseChildren = false;
         }
      }
      
      private static function getHolderChild(param1:*, param2:String) : *
      {
         if(!param1 || !param2 || !param1.hasOwnProperty(param2))
         {
            return null;
         }
         return param1[param2];
      }
      
      private static function getDefaultIconHolder(param1:*) : *
      {
         if(!param1)
         {
            return null;
         }
         if(param1.hasOwnProperty("iconHolder"))
         {
            return param1.iconHolder;
         }
         if(param1.hasOwnProperty("icon") && param1.icon && param1.icon.hasOwnProperty("iconHolder"))
         {
            return param1.icon.iconHolder;
         }
         return param1;
      }
      
      private static function shouldLoopStandBy(param1:String) : Boolean
      {
         return param1 && (param1.indexOf("npc_") >= 0 || param1.indexOf("ene_") >= 0 || param1.indexOf("pet_") >= 0);
      }
      
      private static function cleanupIconRequest(param1:*) : void
      {
         if(!param1)
         {
            return;
         }
         try
         {
            if(loader && loader.get(param1))
            {
               loader.remove(param1,true);
            }
         }
         catch(removeError:Error)
         {
         }
         delete itemMaps[param1];
      }
      
      private static function updateIconLoadingStatus() : void
      {
         loading = hasPendingIconItems();
      }
      
      private static function hasPendingIconItems() : Boolean
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:* = itemMaps;
         for(_loc1_ in _loc3_)
         {
            return true;
         }
         return false;
      }
      
      public static function loadItemIcon(param1:*, param2:*, param3:String = "") : void
      {
         var holder:* = undefined;
         var holderForCurrency:* = undefined;
         var holderInfo:* = undefined;
         var itemid:* = undefined;
         var getskillinfo:Object = null;
         var getpetinfo:Object = null;
         var getaniminfo:Object = null;
         var geticoninfo:Object = null;
         var iconId:* = undefined;
         var holderMC:* = param1;
         var rewardId:* = param2;
         var className:String = param3;
         var configureHolder:Function = function(param1:String, param2:Boolean):void
         {
            holder = holderMC[param1];
            holderForCurrency = holder.iconHolder;
            holderMC.rewardIcon.visible = !param2;
            holderMC.skillIcon.visible = param2;
            holderMC[param1].gotoAndStop(1);
            if(holderMC[param1].hasOwnProperty("colorType"))
            {
               holderMC[param1]["colorType"].gotoAndStop(1);
            }
            else
            {
               holderMC[param1].stopAllMovieClips();
            }
         };
         var loadRewardIcon:Function = function(param1:String, param2:*):void
         {
            var _loc3_:Class = getDefinitionByName(param1) as Class;
            var _loc4_:DisplayObject;
            if(!(_loc4_ = holderForCurrency.getChildByName(param1)))
            {
               (_loc4_ = new _loc3_()).name = param1;
               if(_loc4_.hasOwnProperty("txt"))
               {
                  _loc4_["txt"].text = param2;
               }
               GF.removeAllChild(holderForCurrency);
               holderForCurrency.addChild(_loc4_);
            }
            else
            {
               _loc4_["txt"].text = param2;
            }
            setTooltip(param2);
         };
         var setTooltip:Function = function(param1:*):void
         {
            delete holderInfo.tooltipCache;
            holderInfo.tooltip = param1;
         };
         holder = holderMC;
         holderForCurrency = holderMC;
         holderInfo = holderMC.parent;
         itemid = rewardId.split(":")[0];
         itemid = itemid.replace("%s",Character.character_gender);
         var itemType:* = itemid.split("_");
         var getiteminfo:* = Library.getItemInfo(itemid);
         if(className == "")
         {
            holderInfo = holderMC;
            configureHolder(itemType[0] == "skill" || itemType[1] == "skill" ? "skillIcon" : "rewardIcon",itemType[0] == "skill" || itemType[1] == "skill");
         }
         holderInfo.item_type = itemType[0] == "icon" ? itemType[1] : itemType[0];
         var path:String = null;
         switch(itemType[0])
         {
            case "skill":
               path = "skills";
               getskillinfo = SkillLibrary.getSkillInfo(itemid);
               setTooltip(getskillinfo);
               break;
            case "pet":
               path = "pets";
               getpetinfo = PetInfo.getPetStats(itemid);
               setTooltip(getpetinfo);
               break;
            case "material":
               path = "materials";
               setTooltip(getiteminfo);
               break;
            case "essential":
               path = "essentials";
               setTooltip(getiteminfo);
               break;
            case "item":
               path = "consumables";
               setTooltip(getiteminfo);
               break;
            case "tokens":
            case "gold":
            case "tp":
            case "ss":
            case "prestige":
            case "merit":
            case "emblem":
            case "xp":
               loadRewardIcon(itemType[0],itemType[1]);
               break;
            case "ani":
               getaniminfo = AnimationLibrary.getAnimation(itemid);
               loadRewardIcon(itemid,getaniminfo);
               break;
            case "icon":
               path = "icons";
               iconId = itemid.replace("icon_","");
               geticoninfo = itemType[1] == "skill" ? SkillLibrary.getSkillInfo(iconId) : (itemType[1] == "pet" ? PetInfo.getPetStats(iconId) : Library.getItemInfo(iconId));
               setTooltip(geticoninfo);
               break;
            default:
               path = "items";
               setTooltip(getiteminfo);
         }
         if(path)
         {
            GF.removeAllChild(!!className ? holder : holder.iconHolder);
            loadIconSWF(path,itemid,holder,className || null);
         }
         if(!eventHandler)
         {
            eventHandler = new EventHandler();
         }
         if(!holderInfo.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            eventHandler.addListener(holderInfo,MouseEvent.MOUSE_OVER,toolTiponOver);
         }
         if(!holderInfo.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            eventHandler.addListener(holderInfo,MouseEvent.MOUSE_OUT,toolTiponOut);
         }
      }
      
      public static function toolTiponOver(param1:MouseEvent) : void
      {
         var tooltipData:Object = null;
         var desc:String = null;
         var itemType:String = null;
         var itemSource:Array = null;
         var skillSource:Array = null;
         var setItemId:String = null;
         var setSection:String = null;
         var e:MouseEvent = param1;
         var mc:MovieClip = e.currentTarget as MovieClip;
         if(!mc)
         {
            return;
         }
         if(!mc.tooltipCache)
         {
            var formatDesc:Function = function(param1:String, param2:String, param3:String, param4:String = "", param5:String = "", param6:Array = null):String
            {
               var _loc7_:* = "";
               switch(param2)
               {
                  case "Material":
                     _loc7_ = "\n<font color=\"#00cc00\">Owned: " + Character.getMaterialAmount(tooltipData.item_id) + "</font>";
                     break;
                  case "Essential":
                     _loc7_ = "\n<font color=\"#00cc00\">Owned: " + Character.getEssentialAmount(tooltipData.item_id) + "</font>";
                     break;
                  case "Item":
                     _loc7_ = "\n<font color=\"#00cc00\">Owned: " + Character.getConsumableAmount(tooltipData.item_id) + "</font>";
               }
               return param1 + "\n(" + param2 + ")\n\nLevel " + param3 + param4 + _loc7_ + "\n\n" + param5 + ItemDropSourceMapping.formatSourceText(param6);
            };
            tooltipData = mc.tooltip;
            itemType = mc.item_type;
            itemSource = !!tooltipData.hasOwnProperty("item_source") ? tooltipData.item_source : null;
            skillSource = !!tooltipData.hasOwnProperty("skill_source") ? tooltipData.skill_source : null;
            switch(itemType)
            {
               case "skill":
                  desc = formatDesc(tooltipData.skill_name,"Skill",tooltipData.skill_level,"\n<font color=\"#ff0000\">Damage: " + tooltipData.skill_damage + "</font>\n<font color=\"#0000ff\">CP Cost: " + tooltipData.skill_cp_cost + "</font>\n<font color=\"#ffcc00\">Cooldown: " + tooltipData.skill_cooldown + "</font>",tooltipData.skill_description,skillSource);
                  break;
               case "wpn":
                  desc = formatDesc(tooltipData.item_name,"Weapon",tooltipData.item_level,"\n<font color=\"#ff0000\">Damage: " + tooltipData.item_damage + "</font>",tooltipData.item_description,itemSource);
                  break;
               case "back":
               case "set":
               case "hair":
               case "accessory":
               case "material":
               case "item":
               case "essential":
                  desc = formatDesc(tooltipData.item_name,capitalizeFirstLetter(itemType),tooltipData.item_level,"",tooltipData.item_description,itemSource);
                  break;
               case "pet":
                  desc = tooltipData.pet_name + "\n(Pet)\n\n" + tooltipData.description + ItemDropSourceMapping.formatSourceText(itemSource);
                  break;
               case "tokens":
                  desc = "(Token)\n" + tooltipData + " Tokens";
                  break;
               case "gold":
                  desc = "(Gold)\n" + tooltipData + " Gold";
                  break;
               case "tp":
                  desc = "(TP)\n" + tooltipData + " TP";
                  break;
               case "xp":
                  desc = "(XP)\n" + tooltipData + " XP";
                  break;
               case "ss":
                  desc = "(SS)\n" + tooltipData + " SS";
                  break;
               case "prestige":
                  desc = "(Prestige)\n" + tooltipData + " Prestige";
                  break;
               case "merit":
                  desc = "(Merit)\n" + tooltipData + " Merit";
                  break;
               case "emblem":
                  desc = "(Emblem)\nEmblem";
                  break;
               case "ani":
                  desc = "(" + capitalizeFirstLetter(tooltipData.category) + " Animation)\n" + tooltipData.name;
                  break;
               default:
                  desc = "";
            }
            mc.tooltipCache = desc;
         }
         var finalDesc:String = mc.tooltipCache;
         var setItemType:String = mc.item_type;
         if(setItemType == "wpn" || setItemType == "back" || setItemType == "set" || setItemType == "hair" || setItemType == "accessory")
         {
            setItemId = mc.tooltip && mc.tooltip.hasOwnProperty("item_id") ? mc.tooltip.item_id : null;
            if(setItemId != null)
            {
               setSection = SetBuffs.buildSetTooltip(setItemId,Character.character_weapon,Character.character_back_item,Character.character_set,Character.character_hair,Character.character_accessory);
               if(setSection != "")
               {
                  finalDesc += setSection;
               }
            }
         }
         main.stage.addChild(tooltip);
         tooltip.followMouse = true;
         tooltip.fixedWidth = 350;
         tooltip.multiLine = true;
         tooltip.show(finalDesc);
      }
      
      public static function capitalizeFirstLetter(param1:String) : String
      {
         return param1.charAt(0).toUpperCase() + param1.slice(1);
      }
      
      public static function toolTiponOut(param1:MouseEvent) : void
      {
         tooltip.hide();
      }
      
      public static function showDynamicTooltip(param1:*, param2:String) : void
      {
         param1.metaData = {"tooltip_text":param2};
         if(!eventHandler)
         {
            eventHandler = new EventHandler();
         }
         eventHandler.addListener(param1,MouseEvent.ROLL_OVER,showTextDynamicTooltip);
         eventHandler.addListener(param1,MouseEvent.ROLL_OUT,toolTiponOut);
      }
      
      public static function showTextDynamicTooltip(param1:Event) : void
      {
         main.stage.addChild(tooltip);
         tooltip.followMouse = true;
         tooltip.fixedWidth = 300;
         tooltip.multiLine = true;
         tooltip.show(param1.currentTarget.metaData.tooltip_text);
      }
      
      public static function clearDynamicTooltip(param1:*) : *
      {
         param1.metaData = {};
         if(!eventHandler)
         {
            eventHandler = new EventHandler();
         }
         eventHandler.removeListener(param1,MouseEvent.ROLL_OVER,showTextDynamicTooltip);
         eventHandler.removeListener(param1,MouseEvent.ROLL_OUT,toolTiponOut);
      }
      
      public static function clearEventListener() : void
      {
         if(eventHandler)
         {
            eventHandler.removeAllEventListeners();
         }
      }
      
      public static function addStandByFrameScript(param1:*, param2:String = "standby") : *
      {
         var mc:* = param1;
         var labelName:String = param2;
         if(!mc)
         {
            return;
         }
         var labelFrame:Object = getLabelFrames(mc,labelName);
         if(!labelFrame || labelFrame.end <= 0)
         {
            return;
         }
         mc.addFrameScript(labelFrame.end - 1,function():void
         {
            mc.gotoAndPlay(labelName);
         });
      }
      
      public static function getLabelFrames(param1:MovieClip, param2:String) : Object
      {
         var _loc6_:* = undefined;
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         var _loc5_:int = 0;
         while(_loc5_ < param1.currentLabels.length)
         {
            if((_loc6_ = param1.currentLabels[_loc5_]).name == param2)
            {
               _loc3_ = _loc6_.frame;
               if(_loc5_ + 1 < param1.currentLabels.length)
               {
                  _loc4_ = param1.currentLabels[_loc5_ + 1].frame - 1;
               }
               else
               {
                  _loc4_ = param1.totalFrames;
               }
               break;
            }
            _loc5_++;
         }
         return {
            "start":_loc3_,
            "end":_loc4_
         };
      }
   }
}
