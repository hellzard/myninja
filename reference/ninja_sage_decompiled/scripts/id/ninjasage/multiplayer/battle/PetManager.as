package id.ninjasage.multiplayer.battle
{
   import id.ninjasage.Log;
   
   public class PetManager
   {
       
      
      private var pet:Object;
      
      private var pet_model:PetModel;
      
      public function PetManager(param1:Object)
      {
         super();
         this.pet = param1;
      }
      
      public function getName() : String
      {
         return this.pet.name;
      }
      
      public function getID() : String
      {
         return this.pet.char_id + "_pet";
      }
      
      public function getLevel() : int
      {
         return this.pet.level;
      }
      
      public function getMaxHP() : int
      {
         return this.pet.stat.maxHp;
      }
      
      public function getCurrentHP() : int
      {
         return this.pet.stat.hp;
      }
      
      public function getPetSWF() : String
      {
         return this.pet.pet.swf;
      }
      
      public function setPetModel(param1:PetModel) : void
      {
         this.pet_model = param1;
      }
      
      public function getPetModel() : PetModel
      {
         return this.pet_model;
      }
      
      public function getPlayerTeam() : String
      {
         return this.pet_model.getPlayerTeam();
      }
      
      public function getPlayerNumber() : int
      {
         return this.pet_model.getPlayerNumber();
      }
      
      public function isDead() : Boolean
      {
         return this.pet.stat.hp <= 0;
      }
      
      public function getAgility() : int
      {
         return this.pet.stat.agility;
      }
      
      public function updateStats(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this.pet.stat.hasOwnProperty(_loc2_))
            {
               this.pet.stat[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function destroy() : *
      {
         Log.debug(this,"destroy",this.getPetSWF());
         if(this.pet_model)
         {
            this.pet_model.destroy();
         }
         this.pet = null;
         this.pet_model = null;
      }
   }
}
