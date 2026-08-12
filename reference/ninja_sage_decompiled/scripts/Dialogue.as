package
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public class Dialogue extends MovieClip
   {
       
      
      public var npcHolder:MovieClip;
      
      public var aniki:MovieClip;
      
      public var clickMc:SimpleButton;
      
      public var dialogueTxt:TextField;
      
      public var genzu:MovieClip;
      
      public var kara:MovieClip;
      
      public var kara2:MovieClip;
      
      public var ken:MovieClip;
      
      public var kojima:MovieClip;
      
      public var notshin1:MovieClip;
      
      public var raiga:MovieClip;
      
      public var shin:MovieClip;
      
      public var yudai:MovieClip;
      
      public var kazekage:MovieClip;
      
      public var raikage:MovieClip;
      
      public var mizukage:MovieClip;
      
      public var tsuchikage:MovieClip;
      
      public var chiyo:MovieClip;
      
      public var kyotaro:MovieClip;
      
      public var mudo:MovieClip;
      
      public var npc_class:MovieClip;
      
      public var darkninja:MovieClip;
      
      public var genan:MovieClip;
      
      public var blackops:MovieClip;
      
      public var maeda:MovieClip;
      
      public var perceive:MovieClip;
      
      public var attack:MovieClip;
      
      public var akazosu:MovieClip;
      
      public var butterfly:MovieClip;
      
      public var kuken:MovieClip;
      
      public var panda:MovieClip;
      
      public var bull:MovieClip;
      
      public var health:MovieClip;
      
      public var vadarnomask:MovieClip;
      
      public var vadarrage:MovieClip;
      
      public var loli:MovieClip;
      
      public var monMc:MovieClip;
      
      public var pain1:MovieClip;
      
      public var empty:MovieClip;
      
      public function Dialogue(param1:* = "shin")
      {
         super();
         this.shin.visible = false;
         this.notshin1.visible = false;
         this.yudai.visible = false;
         this.kojima.visible = false;
         this.ken.visible = false;
         this.kara.visible = false;
         this.kara2.visible = false;
         this.genzu.visible = false;
         this.aniki.visible = false;
         this.raiga.visible = false;
         this.tsuchikage.visible = false;
         this.mizukage.visible = false;
         this.kazekage.visible = false;
         this.raikage.visible = false;
         this.chiyo.visible = false;
         this.kyotaro.visible = false;
         this.mudo.visible = false;
         this.npc_class.visible = false;
         this.darkninja.visible = false;
         this.genan.visible = false;
         this.blackops.visible = false;
         this.perceive.visible = false;
         this.attack.visible = false;
         this.akazosu.visible = false;
         this.butterfly.visible = false;
         this.kuken.visible = false;
         this.bull.visible = false;
         this.health.visible = false;
         this.vadarnomask.visible = false;
         this.vadarrage.visible = false;
         this.panda.visible = false;
         this.maeda.visible = false;
         this.loli.visible = false;
         this.pain1.visible = false;
         this.monMc.visible = false;
         this.empty.visible = false;
         if(param1 == "shin")
         {
            this.shin.visible = true;
         }
         else if(param1 == "notshin1")
         {
            this.notshin1.visible = true;
         }
         else if(param1 == "yudai")
         {
            this.yudai.visible = true;
         }
         else if(param1 == "kojima")
         {
            this.kojima.visible = true;
         }
         else if(param1 == "ken")
         {
            this.ken.visible = true;
         }
         else if(param1 == "kara")
         {
            this.kara.visible = true;
         }
         else if(param1 == "genzu")
         {
            this.genzu.visible = true;
         }
         else if(param1 == "aniki")
         {
            this.aniki.visible = true;
         }
         else if(param1 == "kara2")
         {
            this.kara2.visible = true;
         }
         else if(param1 == "raiga")
         {
            this.raiga.visible = true;
         }
         else if(param1 == "tsuchikage")
         {
            this.tsuchikage.visible = true;
         }
         else if(param1 == "raikage")
         {
            this.raikage.visible = true;
         }
         else if(param1 == "kazekage")
         {
            this.kazekage.visible = true;
         }
         else if(param1 == "mizukage")
         {
            this.mizukage.visible = true;
         }
         else if(param1 == "chiyo")
         {
            this.chiyo.visible = true;
         }
         else if(param1 == "kyotaro")
         {
            this.kyotaro.visible = true;
         }
         else if(param1 == "mudo")
         {
            this.mudo.visible = true;
         }
         else if(param1 == "npc_class")
         {
            this.npc_class.visible = true;
         }
         else if(param1 == "darkninja")
         {
            this.darkninja.visible = true;
         }
         else if(param1 == "genan")
         {
            this.genan.visible = true;
         }
         else if(param1 == "blackops")
         {
            this.blackops.visible = true;
         }
         else if(param1 == "maeda")
         {
            this.maeda.visible = true;
         }
         else if(param1 == "perceive")
         {
            this.perceive.visible = true;
         }
         else if(param1 == "attack")
         {
            this.attack.visible = true;
         }
         else if(param1 == "akazosu")
         {
            this.akazosu.visible = true;
         }
         else if(param1 == "butterfly")
         {
            this.butterfly.visible = true;
         }
         else if(param1 == "kuken")
         {
            this.kuken.visible = true;
         }
         else if(param1 == "panda")
         {
            this.panda.visible = true;
         }
         else if(param1 == "bull")
         {
            this.bull.visible = true;
         }
         else if(param1 == "health")
         {
            this.health.visible = true;
         }
         else if(param1 == "vadarnomask")
         {
            this.vadarnomask.visible = true;
         }
         else if(param1 == "vadarrage")
         {
            this.vadarrage.visible = true;
         }
         else if(param1 == "loli")
         {
            this.loli.visible = true;
         }
         else if(param1 == "pain1")
         {
            this.pain1.visible = true;
         }
         else if(param1 == "monMc")
         {
            this.monMc.visible = true;
         }
         else if(param1 == "empty")
         {
            this.empty.visible = true;
         }
      }
      
      public function addNpcImage(param1:MovieClip) : *
      {
         GF.removeAllChild(this.npcHolder);
         if(param1 != null)
         {
            this.npcHolder.addChild(param1);
         }
      }
   }
}
