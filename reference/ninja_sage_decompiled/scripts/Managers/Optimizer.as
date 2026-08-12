package Managers
{
   import flash.display.MovieClip;
   import flash.net.LocalConnection;
   import flash.sampler.getSize;
   import flash.system.System;
   
   public class Optimizer
   {
      
      public static var dispatchList:Array = [];
      
      public static var eventList:Array = [];
       
      
      public function Optimizer()
      {
         super();
      }
      
      public static function runGC(param1:*, param2:int, param3:Boolean = false) : *
      {
         var _loc4_:* = undefined;
         if(!param3)
         {
            killAllChild(param1,false);
            killAllListeners();
            param1.stopAllMovieClips();
            if(param2 > 0)
            {
               killIcons(param1,param2,false);
            }
            forceRunGC();
         }
         else
         {
            _loc4_ = System.freeMemory / 1000000;
            param1.stopAllMovieClips();
            getAllChild(param1);
            killAllChild(param1,true);
            getAllListeners();
            killAllListeners(true);
            if(param2 > 0)
            {
               killIcons(param1,param2,true);
            }
            forceRunGC(true);
            _loc4_ = null;
         }
      }
      
      public static function killIcons(param1:*, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            while(param1["item_" + _loc4_].iconMc.iconHolder.numChildren > 0)
            {
               param1["item_" + _loc4_].iconMc.iconHolder.removeChildAt(0);
               while(param1["item_" + _loc4_].numChildren > 0)
               {
                  param1["item_" + _loc4_].removeChildAt(0);
               }
            }
            param1["item_" + _loc4_].iconMc.iconHolder = null;
            param1["item_" + _loc4_].iconMc = null;
            param1["item_" + _loc4_] = null;
            _loc4_++;
         }
         _loc4_ = undefined;
         if(param3)
         {
         }
      }
      
      public static function forceRunGC(param1:Boolean = false) : void
      {
         try
         {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
         }
         catch(e:*)
         {
         }
         if(param1)
         {
         }
      }
      
      public static function getAllChild(param1:*) : *
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc2_ += param1.getChildAt(_loc3_).name + ", ";
            _loc3_++;
         }
         _loc3_ = undefined;
         _loc2_ = null;
      }
      
      public static function killAllChild(param1:*, param2:Boolean = false) : *
      {
         var _loc3_:* = param1.numChildren;
         param1.removeChildren(0,param1.numChildren - 1);
         if(param2)
         {
         }
         _loc3_ = null;
      }
      
      public static function removeAllChild(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 != null)
         {
            _loc2_ = param1.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               param1.removeChildAt(0);
               _loc3_++;
            }
         }
      }
      
      public static function addListeners(param1:*, param2:String, param3:Function, param4:Boolean = false, param5:int = 0, param6:Boolean = true) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!param1.hasEventListener(param2))
         {
            dispatchList.push({
               "func":param1,
               "name":param1.name
            });
            eventList.push({
               "type":param2,
               "listener":param3,
               "useCapture":param4
            });
            param1.addEventListener(param2,param3,param4,param5,param6);
         }
      }
      
      public static function killAllListeners(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         while(_loc4_ < eventList.length)
         {
            _loc2_ = eventList[_loc4_];
            _loc3_ = dispatchList[_loc4_].func;
            _loc3_.removeEventListener(_loc2_.type,_loc2_.listener,_loc2_.useCapture);
            _loc4_++;
         }
         _loc2_ = null;
         _loc3_ = null;
         dispatchList = [];
         eventList = [];
         _loc4_ = undefined;
         if(param1)
         {
         }
      }
      
      public static function getAllListeners() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = [];
         while(_loc1_ < eventList.length)
         {
            _loc2_.push(dispatchList[_loc1_].name + ": " + eventList[_loc1_].type + ", ");
            _loc1_++;
         }
         _loc2_ = null;
         _loc1_ = undefined;
      }
      
      public static function getMemoryInfo() : void
      {
      }
      
      public static function getObjSize(param1:*) : void
      {
      }
      
      public static function getObjSizeInBytes(param1:*) : void
      {
      }
      
      public static function getObjProperties(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = [];
         while(_loc4_ < eventList.length)
         {
            if(param1.name == dispatchList[_loc4_].name)
            {
               _loc5_[_loc5_.length] = eventList[_loc4_].type;
            }
            _loc4_++;
         }
         if(_loc5_.length > 0)
         {
         }
         try
         {
            _loc2_ = 0;
            _loc3_ = [];
            while(_loc2_ < param1.numChildren)
            {
               if(param1.getChildAt(_loc2_).name.indexOf("iconHolder") >= 0 || param1.getChildAt(_loc2_).name.indexOf("icon") >= 0)
               {
               }
               _loc3_[_loc3_.length] = param1.getChildAt(_loc2_).name;
               _loc2_++;
            }
            _loc3_ = null;
            _loc2_ = undefined;
         }
         catch(e:Error)
         {
         }
         _loc4_ = undefined;
         _loc5_ = null;
      }
      
      public static function getAllObjSizes(param1:*, param2:String = "true") : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = 0;
         if(param2)
         {
         }
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ += getSize(param1.getChildAt(_loc3_));
            _loc3_++;
         }
         _loc3_ = undefined;
         _loc4_ = undefined;
      }
   }
}
