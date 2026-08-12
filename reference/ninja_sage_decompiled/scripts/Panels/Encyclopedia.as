package Panels
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   
   public dynamic class Encyclopedia extends MovieClip
   {
       
      
      public var bg:MovieClip;
      
      public var btn_Encyclopedia_Npc:SimpleButton;
      
      public var descriptionTx:TextField;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_close:SimpleButton;
      
      public var btn_Encyclopedia_Items:SimpleButton;
      
      public var btn_Encyclopedia_Pets:SimpleButton;
      
      public var btn_Encyclopedia_Skills:SimpleButton;
      
      public var btn_Encyclopedia_Enemy:SimpleButton;
      
      public var btn_Encyclopedia_Effect:SimpleButton;
      
      public var main;
      
      public function Encyclopedia(param1:*)
      {
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.closePanel);
         this.main = param1;
         this.btn_close.addEventListener(MouseEvent.CLICK,this.closePanel,false,0,true);
         this.btn_Encyclopedia_Items.addEventListener(MouseEvent.CLICK,this.openPanel,false,0,true);
         this.btn_Encyclopedia_Pets.addEventListener(MouseEvent.CLICK,this.openPanel,false,0,true);
         this.btn_Encyclopedia_Skills.addEventListener(MouseEvent.CLICK,this.openPanel,false,0,true);
         this.btn_Encyclopedia_Enemy.addEventListener(MouseEvent.CLICK,this.openPanel,false,0,true);
         this.btn_Encyclopedia_Npc.addEventListener(MouseEvent.CLICK,this.openPanel,false,0,true);
         this.btn_Encyclopedia_Effect.addEventListener(MouseEvent.CLICK,this.openPanel,false,0,true);
      }
      
      function openPanel(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "btn_Encyclopedia_Effect")
         {
            this.main.loadExternalSwfPanel("EncyclopediaEffect","EncyclopediaEffect");
            return;
         }
         var _loc2_:String = param1.currentTarget.name.replace("btn_","");
         this.main.loadPanel("Panels." + _loc2_);
      }
      
      public function closePanel(param1:MouseEvent) : *
      {
         this.main.handleVillageHUDVisibility(true);
         this.main = null;
         this.btn_close.removeEventListener(MouseEvent.CLICK,this.closePanel);
         this.btn_Encyclopedia_Items.removeEventListener(MouseEvent.CLICK,this.openPanel);
         this.btn_Encyclopedia_Pets.removeEventListener(MouseEvent.CLICK,this.openPanel);
         this.btn_Encyclopedia_Skills.removeEventListener(MouseEvent.CLICK,this.openPanel);
         this.btn_Encyclopedia_Enemy.removeEventListener(MouseEvent.CLICK,this.openPanel);
         this.btn_Encyclopedia_Npc.removeEventListener(MouseEvent.CLICK,this.openPanel);
         this.btn_Encyclopedia_Effect.removeEventListener(MouseEvent.CLICK,this.openPanel);
         GF.removeAllChild(this);
         System.gc();
      }
   }
}
