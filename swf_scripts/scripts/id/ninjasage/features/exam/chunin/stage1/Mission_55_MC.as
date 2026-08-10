package id.ninjasage.features.exam.chunin.stage1
{
   public class Mission_55_MC
   {
      
      public var questions:Array = [];
      
      public function Mission_55_MC()
      {
         super();
         this.questions.push({
            "q":"What was the first weapon that Shin gave you?",
            "a":2,
            "c":["Axe","Claw","Kunai","Sword","I cannot remember"],
            "id":1
         });
         this.questions.push({
            "q":"Which action allows you to gain Chakra in battle?",
            "a":3,
            "c":["Dance","Run","Eat","Charge","Sleep"],
            "id":2
         });
         this.questions.push({
            "q":"Which technique is specialized in illusions and transformations?",
            "a":1,
            "c":["Taijutsu (Body Techniques)","Genjutsu (Illusionary Techniques)","Kenjutsu (Sword Technique)","Kinjutsu (Forbidden Techniques)","Fuinjutsu (Sealing Techniques)"],
            "id":3
         });
         this.questions.push({
            "q":"How many friends can you recruit to join your party for missions?",
            "a":1,
            "c":["1","2","3","4","I cannot recruit friends to do missions"],
            "id":4
         });
         this.questions.push({
            "q":"Which item allows the character to recover HP?",
            "a":1,
            "c":["Chakra Scroll","HP Healing Scroll","Smoke Bomb","Rations Pills","Magic Potion"],
            "id":5
         });
         this.randomArray();
      }
      
      internal function randomArray() : *
      {
         var _loc1_:Array = new Array(this.questions.length);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.questions.length)
         {
            _loc2_ = int(Math.random() * this.questions.length);
            while(_loc1_[_loc2_] != null)
            {
               _loc2_ = int(Math.random() * this.questions.length);
            }
            _loc1_[_loc2_] = this.questions[_loc3_];
            _loc3_++;
         }
         this.questions = _loc1_;
      }
   }
}

