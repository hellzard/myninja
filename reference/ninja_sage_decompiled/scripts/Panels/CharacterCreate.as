package Panels
{
   import Storage.Character;
   import br.com.stimuli.loading.BulkLoader;
   import com.adobe.crypto.CUCSG;
   import com.utils.GF;
   import fl.controls.ColorPicker;
   import fl.events.ColorPickerEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.Log;
   
   public class CharacterCreate extends MovieClip
   {
      
      public static var hairMC:MovieClip;
      
      public static var backHairMC:MovieClip;
      
      public static var weapon_mc;
      
      public static var back_mc;
      
      public static var set_mc:Array = [];
      
      public static var hair_mc:Array = [];
       
      
      public var txt_name:TextField;
      
      public var txt_skincolor:TextField;
      
      public var txt_version:TextField;
      
      private var escapeKey:EscapeKeyManager;
      
      public var btn_create:SimpleButton;
      
      public var btn_element_1:MovieClip;
      
      public var btn_element_2:MovieClip;
      
      public var btn_element_3:MovieClip;
      
      public var btn_element_4:MovieClip;
      
      public var btn_element_5:MovieClip;
      
      public var btn_gen_next:SimpleButton;
      
      public var btn_gen_prev:SimpleButton;
      
      public var btn_hair_next:SimpleButton;
      
      public var btn_hair_prev:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var cPicker1:ColorPicker;
      
      public var cPicker2:ColorPicker;
      
      public var char_mc:MovieClip;
      
      public var char_name:TextField;
      
      public var decor1:MovieClip;
      
      public var decor2:MovieClip;
      
      public var txt_gender:TextField;
      
      public var txt_hair:TextField;
      
      public var main;
      
      var current_gender = 0;
      
      var selected_hair_style_color = "";
      
      public var char_bodyArray:Array;
      
      var hair_num = 1;
      
      var element = 1;
      
      var color_1:uint;
      
      var color_2:uint;
      
      var loaderSwf:BulkLoader;
      
      public function CharacterCreate(param1:*)
      {
         this.char_bodyArray = new Array("upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe");
         super();
         this.escapeKey = new EscapeKeyManager(this);
         this.escapeKey.addListener(this,this.changeCharacter);
         this.main = param1;
         this.loaderSwf = BulkLoader.getLoader("assets");
         this.getBasicData();
      }
      
      function getBasicData() : void
      {
         this.loadItem("wpn_01","back_01","set_01_0","hair_01_0","face_01_0");
         if(this.current_gender == 0)
         {
            this.txt_gender.text = "Male";
         }
         else
         {
            this.txt_gender.text = "Female";
         }
         this.btn_gen_next.addEventListener(MouseEvent.CLICK,this.swapGender);
         this.btn_gen_prev.addEventListener(MouseEvent.CLICK,this.swapGender);
         this.btn_hair_next.addEventListener(MouseEvent.CLICK,this.swapHair);
         this.btn_hair_prev.addEventListener(MouseEvent.CLICK,this.swapHair);
         this.selected_hair_style_color = "0|0";
         this.txt_hair.text = this.hair_num + " /18";
         this.cPicker1.editable = true;
         this.cPicker1.addEventListener(ColorPickerEvent.CHANGE,this.colorChangeHandler1);
         this.cPicker2.editable = true;
         this.cPicker2.addEventListener(ColorPickerEvent.CHANGE,this.colorChangeHandler2);
         this.btn_create.addEventListener(MouseEvent.CLICK,this.createChar);
         this.btn_close.addEventListener(MouseEvent.CLICK,this.changeCharacter);
         var _loc1_:* = 1;
         while(_loc1_ < 6)
         {
            this["btn_element_" + _loc1_].gotoAndStop(1);
            this["btn_element_" + _loc1_].buttonMode = true;
            this["btn_element_" + _loc1_].addEventListener(MouseEvent.CLICK,this.selectElement);
            this["btn_element_" + _loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.over);
            this["btn_element_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.out);
            _loc1_++;
         }
         _loc1_ = null;
         this["btn_element_1"].gotoAndStop(3);
      }
      
      function clearAll() : void
      {
         var _loc1_:* = 1;
         while(_loc1_ < 6)
         {
            this["btn_element_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
         _loc1_ = null;
      }
      
      function selectElement(param1:MouseEvent) : void
      {
         this.clearAll();
         param1.currentTarget.gotoAndStop(3);
         var _loc2_:* = param1.currentTarget.name.split("_");
         this.element = _loc2_[2];
      }
      
      function over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      function out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame !== 3)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      function createChar(param1:MouseEvent) : void
      {
         if(this.char_name.text.length < 2)
         {
            this.main.giveMessage("Character\'s name at least have 2 characters");
            return;
         }
         this.main.loading(true);
         var _loc2_:Array = [Character.account_id,CUCSG.hash(Character.sessionkey),this.char_name.text,this.current_gender,this.element,this.selected_hair_style_color,this.hair_num];
         _loc2_ = [_loc2_];
         this.main.amf_manager.service("36a62s4oZ7iYRJjd.4ojsZyXghftc",_loc2_,this.regResponse);
      }
      
      function killEverything() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.btn_gen_next.removeEventListener(MouseEvent.CLICK,this.swapGender);
         this.btn_gen_prev.removeEventListener(MouseEvent.CLICK,this.swapGender);
         this.btn_hair_next.removeEventListener(MouseEvent.CLICK,this.swapHair);
         this.btn_hair_prev.removeEventListener(MouseEvent.CLICK,this.swapHair);
         this.btn_create.removeEventListener(MouseEvent.CLICK,this.createChar);
         this.cPicker1.removeEventListener(ColorPickerEvent.CHANGE,this.colorChangeHandler1);
         this.cPicker2.removeEventListener(ColorPickerEvent.CHANGE,this.colorChangeHandler2);
         var _loc1_:* = 1;
         while(_loc1_ < 6)
         {
            this["btn_element_" + _loc1_].buttonMode = false;
            this["btn_element_" + _loc1_].removeEventListener(MouseEvent.CLICK,this.selectElement);
            this["btn_element_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.over);
            this["btn_element_" + _loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.out);
            _loc1_++;
         }
         _loc1_ = null;
         this.current_gender = null;
         this.selected_hair_style_color = null;
         hairMC = null;
         backHairMC = null;
         this.char_bodyArray = null;
         weapon_mc = null;
         back_mc = null;
         set_mc = null;
         hair_mc = null;
         this.hair_num = null;
         this.element = null;
         if(this.loaderSwf)
         {
            this.loaderSwf.removeAll();
         }
         this.loaderSwf = null;
         GF.removeAllChild(this);
      }
      
      function regResponse(param1:Object) : void
      {
         this.main.loading(false);
         this.killEverything();
         if(param1.status == 1)
         {
            this.main.loadPanel("Managers.LoginManager");
         }
         else
         {
            this.main.getError(param1.error);
         }
      }
      
      function colorChangeHandler1(param1:ColorPickerEvent) : void
      {
         var _loc2_:uint = uint("0x" + param1.target.hexValue);
         this.color_1 = _loc2_;
         var _loc3_:* = this.selected_hair_style_color.split("|");
         this.selected_hair_style_color = this.color_1 + "|" + _loc3_[1];
         this.addHairColor(0);
         try
         {
            this.addHairColor(1);
         }
         catch(e:*)
         {
         }
      }
      
      function colorChangeHandler2(param1:ColorPickerEvent) : void
      {
         var _loc2_:uint = uint("0x" + param1.target.hexValue);
         this.color_2 = _loc2_;
         var _loc3_:* = this.selected_hair_style_color.split("|");
         this.selected_hair_style_color = _loc3_[0] + "|" + this.color_2;
         this.addHairColor(0);
         try
         {
            this.addHairColor(1);
         }
         catch(e:*)
         {
         }
      }
      
      function swapHair(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         while(this.char_mc["back_hair"].numChildren > 0)
         {
            this.char_mc["back_hair"].removeChildAt(0);
         }
         if(param1.currentTarget.name == "btn_hair_next")
         {
            if(this.hair_num < 18)
            {
               ++this.hair_num;
               this.txt_hair.text = this.hair_num + " /18";
            }
            else
            {
               this.hair_num = 1;
               this.txt_hair.text = this.hair_num + " /18";
            }
         }
         else if(this.hair_num > 1)
         {
            --this.hair_num;
            this.txt_hair.text = this.hair_num + " /18";
         }
         else
         {
            this.hair_num = 18;
            this.txt_hair.text = this.hair_num + " /18";
         }
         if(this.hair_num > 9)
         {
            _loc2_ = this.loaderSwf.add("items/hair_" + this.hair_num + "_" + this.current_gender + ".swf");
         }
         else
         {
            _loc2_ = this.loaderSwf.add("items/hair_0" + this.hair_num + "_" + this.current_gender + ".swf");
         }
         _loc2_.addEventListener(BulkLoader.COMPLETE,this.onCompleteHair);
         this.loaderSwf.start();
      }
      
      function addHairColor(param1:int) : void
      {
         var _loc2_:ColorTransform = new ColorTransform();
         var _loc3_:ColorTransform = new ColorTransform();
         var _loc4_:* = this.selected_hair_style_color.split("|");
         _loc2_.color = _loc4_[0];
         _loc3_.color = _loc4_[1];
         this.color_1 = _loc4_[0];
         this.color_2 = _loc4_[1];
         if(param1 == 0)
         {
            hairMC.hair_color_2.transform.colorTransform = _loc3_;
            hairMC.hair_color_1.transform.colorTransform = _loc2_;
         }
         else
         {
            backHairMC.hair_color_2.transform.colorTransform = _loc3_;
            backHairMC.hair_color_1.transform.colorTransform = _loc2_;
         }
      }
      
      function swapGender(param1:MouseEvent) : void
      {
         this.hair_num = 1;
         this.txt_hair.text = this.hair_num + " /18";
         while(this.char_mc["back_hair"].numChildren > 0)
         {
            this.char_mc["back_hair"].removeChildAt(0);
         }
         if(this.current_gender == 0)
         {
            this.loadItem("wpn_01","back_01","set_01_1","hair_01_1","face_01_1");
            this.current_gender = 1;
            this.txt_gender.text = "Female";
         }
         else
         {
            this.loadItem("wpn_01","back_01","set_01_0","hair_01_0","face_01_0");
            this.current_gender = 0;
            this.txt_gender.text = "Male";
         }
      }
      
      public function loadItem(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         var _loc6_:* = this.loaderSwf.add("items/" + param1 + ".swf");
         var _loc7_:* = this.loaderSwf.add("items/" + param2 + ".swf");
         var _loc8_:* = this.loaderSwf.add("items/" + param3 + ".swf");
         var _loc9_:* = this.loaderSwf.add("items/" + param4 + ".swf");
         var _loc10_:* = this.loaderSwf.add("items/" + param5 + ".swf");
         _loc6_.addEventListener(BulkLoader.COMPLETE,this.onCompleteWpn);
         _loc7_.addEventListener(BulkLoader.COMPLETE,this.onCompleteWpn);
         _loc8_.addEventListener(BulkLoader.COMPLETE,this.onCompleteSet);
         _loc9_.addEventListener(BulkLoader.COMPLETE,this.onCompleteHair);
         _loc10_.addEventListener(BulkLoader.COMPLETE,this.onCompleteFace);
         this.loaderSwf.start();
      }
      
      public function onCompleteWpn(param1:*) : void
      {
         var event:* = param1;
         var butn:MovieClip = null;
         var e:* = event;
         try
         {
            butn = e.target.content["weapon"];
            this.removeChildsFromMovieClip(this.char_mc["weapon"]);
            this.char_mc["weapon"].addChild(butn);
            weapon_mc = butn;
         }
         catch(e:*)
         {
         }
      }
      
      public function onCompleteBack(param1:*) : void
      {
         var event:* = param1;
         var butn:MovieClip = null;
         var e:* = event;
         try
         {
            butn = e.target.content["back_item"];
            this.removeChildsFromMovieClip(this.char_mc["back"]);
            this.char_mc["back"].addChild(butn);
            back_mc = butn;
         }
         catch(e:*)
         {
         }
      }
      
      public function onCompleteFace(param1:*) : void
      {
         var event:* = param1;
         var butn:MovieClip = null;
         var e:* = event;
         try
         {
            butn = e.target.content["face"];
            if(this.char_mc["head"]["face"].numChildren > 0)
            {
               this.removeChildsFromMovieClip(this.char_mc["head"]["face"]);
            }
            this.char_mc["head"]["face"].addChild(butn);
         }
         catch(e:*)
         {
         }
      }
      
      public function onCompleteSet(param1:*) : void
      {
         var event:* = param1;
         var classGetMC1:MovieClip = null;
         var classGetMC:MovieClip = null;
         var e:* = event;
         var i:* = 0;
         set_mc = [];
         while(i < this.char_bodyArray.length)
         {
            try
            {
               classGetMC1 = e.target.content[this.char_bodyArray[i]];
               this.removeChildsFromMovieClip(this.char_mc[this.char_bodyArray[i]]);
               this.char_mc[this.char_bodyArray[i]].addChild(classGetMC1);
               set_mc.push(classGetMC1);
               i++;
            }
            catch(e:Error)
            {
               i++;
            }
         }
         try
         {
            classGetMC = e.target.content["skirt"];
            this.removeChildsFromMovieClip(this.char_mc["skirt"]);
            this.char_mc["skirt"].addChild(classGetMC);
            set_mc.push(classGetMC);
         }
         catch(e:Error)
         {
         }
      }
      
      public function onCompleteHair(param1:*) : *
      {
         var event:* = param1;
         var e:* = event;
         hairMC = e.target.content["hair"];
         hair_mc = [];
         while(this.char_mc["head"]["hair"].numChildren > 0)
         {
            this.char_mc["head"]["hair"].removeChildAt(0);
         }
         this.char_mc["head"]["hair"].addChild(hairMC);
         hair_mc.push(hairMC);
         this.addHairColor(0);
         try
         {
            backHairMC = e.target.content["back_hair"];
            while(this.char_mc["back_hair"].numChildren > 0)
            {
               this.char_mc["back_hair"].removeChildAt(0);
            }
            this.char_mc["back_hair"].addChild(backHairMC);
            hair_mc.push(backHairMC);
            this.addHairColor(1);
         }
         catch(e:Error)
         {
            Log.error(this,"hair model error ",e);
         }
      }
      
      function changeCharacter(param1:MouseEvent) : void
      {
         this.killEverything();
      }
      
      public function removeChildsFromMovieClip(param1:*) : *
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
   }
}
