package id.ninjasage.multiplayer.battle
{
   import flash.events.Event;
   
   public class BattleAnimationEvent extends Event
   {
      
      public static const DODGE_FINISHED:String = "dodge";
      
      public static const CHARGE_FINISHED:String = "charge";
      
      public static const WEAPON_FINISHED:String = "weapon";
      
      public static const SKILL_FINISHED:String = "skill";
      
      public static const ITEM_FINISHED:String = "item";
      
      public static const ATTACK_FINISHED:String = "attack";
      
      public static const ITEM_USE:String = "item_use";
      
      public static const HIT:String = "hit";
      
      public static const DEAD:String = "dead";
      
      public var id:*;
      
      public function BattleAnimationEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null)
      {
         super(param1,param2,param3);
         this.id = param4;
      }
   }
}

