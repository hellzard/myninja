package com.gestouch.extensions.native
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.geom.Point;
   
   public class DisplayObjectUtils
   {
       
      
      public function DisplayObjectUtils()
      {
         super();
      }
      
      public static function getTopTarget(param1:Stage, param2:Point, param3:Boolean = true, param4:uint = 0) : InteractiveObject
      {
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:InteractiveObject = null;
         var _loc10_:DisplayObjectContainer = null;
         var _loc5_:Array;
         if(!(_loc5_ = param1.getObjectsUnderPoint(param2)).length)
         {
            return param1;
         }
         var _loc6_:int;
         if((_loc6_ = _loc5_.length - 1 - param4) < 0)
         {
            return param1;
         }
         _loc7_ = _loc6_;
         while(_loc7_ >= 0)
         {
            _loc8_ = _loc5_[_loc7_] as DisplayObject;
            while(_loc8_ != param1)
            {
               if(_loc8_ is InteractiveObject)
               {
                  if((_loc8_ as InteractiveObject).mouseEnabled)
                  {
                     if(param3)
                     {
                        _loc9_ = _loc8_ as InteractiveObject;
                        _loc10_ = _loc8_.parent;
                        while(_loc10_)
                        {
                           if(!_loc9_ && _loc10_.mouseEnabled)
                           {
                              _loc9_ = _loc10_;
                           }
                           else if(!_loc10_.mouseChildren)
                           {
                              if(_loc10_.mouseEnabled)
                              {
                                 _loc9_ = _loc10_;
                              }
                              else
                              {
                                 _loc9_ = null;
                              }
                           }
                           _loc10_ = _loc10_.parent;
                        }
                        if(_loc9_)
                        {
                           return _loc9_;
                        }
                        return param1;
                     }
                     return _loc8_ as InteractiveObject;
                  }
                  break;
               }
               _loc8_ = _loc8_.parent;
            }
            _loc7_--;
         }
         return param1;
      }
   }
}
