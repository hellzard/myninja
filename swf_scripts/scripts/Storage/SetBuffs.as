package Storage
{
   import id.ninjasage.Util;
   
   public class SetBuffs
   {
      
      private static var data:Object = {};
      
      private static var memberIndex:Object = {};
      
      private static var _constructed:Boolean = false;
      
      private static const SLOTS:Array = ["weapon","back_item","accessory","cloth","hair"];
      
      private static const TOOLTIP_SLOTS:Array = ["weapon","back_item","cloth","hair","accessory"];
      
      public function SetBuffs()
      {
         super();
      }
      
      private static function normalizeMemberId(param1:String, param2:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(param2 == null || param2 == "")
         {
            return param2;
         }
         if(param1 == "cloth" || param1 == "hair")
         {
            _loc3_ = String(param2);
            if(_loc3_.indexOf("%s") >= 0)
            {
               return _loc3_;
            }
            _loc4_ = _loc3_.lastIndexOf("_");
            if(_loc4_ > 0)
            {
               _loc5_ = _loc3_.substr(_loc4_ + 1);
               if(_loc5_ == "0" || _loc5_ == "1")
               {
                  return _loc3_.substr(0,_loc4_ + 1) + "%s";
               }
            }
         }
         return String(param2);
      }
      
      public static function constructData(param1:*) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:* = undefined;
         SetBuffs.data = {};
         SetBuffs.memberIndex = {};
         var _loc2_:Array = param1 != null && Boolean(param1.hasOwnProperty("sets")) ? param1.sets : param1 as Array;
         if(_loc2_ == null)
         {
            _constructed = true;
            return;
         }
         for each(_loc3_ in _loc2_)
         {
            if(!(_loc3_ == null || !_loc3_.hasOwnProperty("setId") || _loc3_.setId == null))
            {
               _loc4_ = String(_loc3_.setId);
               if(!SetBuffs.data.hasOwnProperty(_loc4_))
               {
                  SetBuffs.data[_loc4_] = _loc3_;
                  _loc5_ = _loc3_.hasOwnProperty("members") ? _loc3_.members : null;
                  if(!(_loc5_ == null || !(_loc5_ is Object) || _loc5_ is Array || _loc5_ is String || _loc5_ is Number))
                  {
                     for each(_loc6_ in SLOTS)
                     {
                        if(!(!_loc5_.hasOwnProperty(_loc6_) || _loc5_[_loc6_] == null))
                        {
                           _loc7_ = _loc5_[_loc6_] as Array;
                           if(_loc7_ != null)
                           {
                              for each(_loc8_ in _loc7_)
                              {
                                 if(_loc8_ != null)
                                 {
                                    SetBuffs.memberIndex[_loc6_ + "|" + normalizeMemberId(_loc6_,String(_loc8_))] = _loc4_;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         _constructed = true;
      }
      
      public static function getSetIdForItem(param1:String, param2:String) : String
      {
         if(param2 == null || param2 == "")
         {
            return null;
         }
         var _loc3_:String = param1 + "|" + normalizeMemberId(param1,param2);
         return SetBuffs.memberIndex.hasOwnProperty(_loc3_) ? SetBuffs.memberIndex[_loc3_] : null;
      }
      
      private static function getRawTierEffects(param1:String, param2:int) : Array
      {
         if(param1 == null || !SetBuffs.data.hasOwnProperty(param1))
         {
            return null;
         }
         var _loc3_:Object = SetBuffs.data[param1];
         if(!_loc3_.hasOwnProperty("tiers") || _loc3_.tiers == null)
         {
            return null;
         }
         var _loc4_:String = String(param2);
         if(!_loc3_.tiers.hasOwnProperty(_loc4_) || _loc3_.tiers[_loc4_] == null)
         {
            return null;
         }
         return _loc3_.tiers[_loc4_] as Array;
      }
      
      public static function getTierEffects(param1:String, param2:int) : Array
      {
         var _loc5_:* = undefined;
         var _loc3_:Array = getRawTierEffects(param1,param2);
         if(_loc3_ == null)
         {
            return [];
         }
         var _loc4_:Array = [];
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_ != null)
            {
               _loc4_.push(SetBuffs.normalizeEffect(Util.copy(_loc5_)));
            }
         }
         return _loc4_;
      }
      
      private static function normalizeEffect(param1:*) : Object
      {
         if(!("duration" in param1))
         {
            param1.duration = 0;
         }
         if(!("calc_type" in param1))
         {
            param1.calc_type = "percent";
         }
         if(!("amount" in param1))
         {
            param1.amount = 0;
         }
         if(!("chance" in param1))
         {
            param1.chance = 100;
         }
         return param1;
      }
      
      private static function itemTypeToSlot(param1:String) : String
      {
         switch(param1)
         {
            case "wpn":
               return "weapon";
            case "back":
               return "back_item";
            case "set":
               return "cloth";
            case "hair":
               return "hair";
            case "accessory":
               return "accessory";
            default:
               return null;
         }
      }
      
      public static function getSetIdForAnyItem(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1 == null || param1 == "")
         {
            return null;
         }
         for each(_loc2_ in TOOLTIP_SLOTS)
         {
            _loc3_ = getSetIdForItem(_loc2_,param1);
            if(_loc3_ != null)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function getSetName(param1:String) : String
      {
         if(param1 == null || !SetBuffs.data.hasOwnProperty(param1))
         {
            return param1;
         }
         var _loc2_:Object = SetBuffs.data[param1];
         return _loc2_.hasOwnProperty("set_name") && _loc2_.set_name != null ? String(_loc2_.set_name) : param1;
      }
      
      public static function getSetMembers(param1:String) : Array
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         var _loc2_:Array = [];
         if(param1 == null || !SetBuffs.data.hasOwnProperty(param1))
         {
            return _loc2_;
         }
         var _loc3_:Object = SetBuffs.data[param1];
         var _loc4_:Object = _loc3_.hasOwnProperty("members") ? _loc3_.members : null;
         if(_loc4_ == null || !(_loc4_ is Object) || _loc4_ is Array || _loc4_ is String || _loc4_ is Number)
         {
            return _loc2_;
         }
         for each(_loc5_ in TOOLTIP_SLOTS)
         {
            if(!(!_loc4_.hasOwnProperty(_loc5_) || _loc4_[_loc5_] == null))
            {
               _loc6_ = _loc4_[_loc5_] as Array;
               if(_loc6_ != null)
               {
                  for each(_loc7_ in _loc6_)
                  {
                     if(_loc7_ != null)
                     {
                        _loc2_.push({
                           "slot":_loc5_,
                           "itemId":String(_loc7_)
                        });
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public static function formatEffectText(param1:Object) : String
      {
         if(param1 == null)
         {
            return "";
         }
         var _loc2_:String = param1.hasOwnProperty("effect_name") && param1.effect_name != null ? String(param1.effect_name) : String(param1.effect);
         var _loc3_:* = param1.hasOwnProperty("amount") ? param1.amount : 0;
         var _loc4_:String = param1.hasOwnProperty("calc_type") && param1.calc_type == "percent" ? "%" : "";
         return "+" + _loc3_ + _loc4_ + " " + _loc2_;
      }
      
      private static function formatTierEffects(param1:String, param2:int) : String
      {
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc3_:Array = getRawTierEffects(param1,param2);
         if(_loc3_ == null || _loc3_.length < 1)
         {
            return "";
         }
         var _loc4_:Array = [];
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_ != null)
            {
               _loc6_ = formatEffectText(_loc5_);
               if(_loc6_ != "")
               {
                  _loc4_.push(_loc6_);
               }
            }
         }
         return _loc4_.join(", ");
      }
      
      public static function buildSetTooltip(param1:String, param2:String, param3:String, param4:String, param5:String = null, param6:String = null) : String
      {
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc20_:Boolean = false;
         var _loc21_:String = null;
         var _loc22_:* = undefined;
         var _loc23_:String = null;
         var _loc24_:String = null;
         if(!SetBuffs.constructed)
         {
            return "";
         }
         var _loc7_:String = getSetIdForAnyItem(param1);
         if(_loc7_ == null)
         {
            return "";
         }
         var _loc8_:Array = getSetMembers(_loc7_);
         if(_loc8_.length < 1)
         {
            return "";
         }
         var _loc9_:Object = {
            "weapon":(param2 != null ? param2 : ""),
            "back_item":(param3 != null ? param3 : ""),
            "cloth":(param4 != null ? param4 : ""),
            "hair":(param5 != null ? param5 : ""),
            "accessory":(param6 != null ? param6 : "")
         };
         var _loc10_:Object = {};
         for each(_loc11_ in _loc8_)
         {
            if(_loc9_.hasOwnProperty(_loc11_.slot))
            {
               if(normalizeMemberId(_loc11_.slot,_loc9_[_loc11_.slot]) == normalizeMemberId(_loc11_.slot,_loc11_.itemId))
               {
                  _loc10_[_loc11_.slot] = true;
               }
            }
         }
         _loc12_ = 0;
         for(_loc13_ in _loc10_)
         {
            _loc12_++;
         }
         _loc14_ = 0;
         _loc15_ = {};
         for each(_loc11_ in _loc8_)
         {
            if(!_loc15_.hasOwnProperty(_loc11_.slot))
            {
               _loc15_[_loc11_.slot] = true;
               _loc14_++;
            }
         }
         _loc17_ = "\n" + (_loc16_ = "\n") + getSetName(_loc7_) + " (" + _loc12_ + "/" + _loc14_ + ")" + _loc16_;
         for each(_loc11_ in _loc8_)
         {
            _loc20_ = _loc10_.hasOwnProperty(_loc11_.slot) && normalizeMemberId(_loc11_.slot,_loc9_[_loc11_.slot]) == normalizeMemberId(_loc11_.slot,_loc11_.itemId);
            _loc21_ = String(_loc11_.itemId);
            if(_loc21_.indexOf("%s") >= 0)
            {
               _loc21_ = _loc21_.replace("%s",Character.character_gender);
            }
            _loc22_ = Library.getItemInfo(_loc21_);
            _loc23_ = Boolean(_loc22_ != null) && Boolean(_loc22_.hasOwnProperty("item_name")) && _loc22_.item_name != "null" ? _loc22_.item_name : _loc21_;
            if(_loc20_)
            {
               _loc17_ += "• " + _loc23_ + _loc16_;
            }
            else
            {
               _loc17_ += "<font color=\"#888888\">• " + _loc23_ + "</font>" + _loc16_;
            }
         }
         _loc18_ = "";
         _loc19_ = 2;
         while(_loc19_ <= _loc14_)
         {
            _loc24_ = formatTierEffects(_loc7_,_loc19_);
            if(_loc24_ != "")
            {
               if(_loc12_ >= _loc19_)
               {
                  _loc18_ += "(" + _loc19_ + ") " + _loc24_ + _loc16_;
               }
               else
               {
                  _loc18_ += "<font color=\"#888888\">(" + _loc19_ + ") " + _loc24_ + "</font>" + _loc16_;
               }
            }
            _loc19_++;
         }
         if(_loc18_ != "")
         {
            _loc17_ += _loc16_ + "Set Effects:" + _loc16_ + _loc18_;
         }
         return _loc17_;
      }
      
      public static function get constructed() : Boolean
      {
         return SetBuffs._constructed == true;
      }
   }
}

