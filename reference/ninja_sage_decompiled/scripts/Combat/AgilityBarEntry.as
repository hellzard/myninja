package Combat
{
   import flash.display.MovieClip;
   
   public class AgilityBarEntry
   {
       
      
      public var id:String;
      
      public var head:MovieClip;
      
      public var model;
      
      public var agility:int;
      
      public var lastX:Number;
      
      public var teamName:String;
      
      public var teamNum:int;
      
      public var isPet:Boolean;
      
      public function AgilityBarEntry(param1:String, param2:MovieClip, param3:*, param4:int, param5:Number, param6:String, param7:int, param8:Boolean)
      {
         super();
         this.id = param1;
         this.head = param2;
         this.model = param3;
         this.agility = param4;
         this.lastX = param5;
         this.teamName = param6;
         this.teamNum = param7;
         this.isPet = param8;
      }
   }
}
