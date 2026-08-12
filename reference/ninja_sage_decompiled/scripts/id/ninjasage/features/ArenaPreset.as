package id.ninjasage.features
{
   import Managers.NinjaSage;
   import Storage.Character;
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import id.ninjasage.EscapeKeyManager;
   import id.ninjasage.EventHandler;
   
   public dynamic class ArenaPreset extends MovieClip
   {
       
      
      private var escapeKey:EscapeKeyManager;
      
      public var panelMC:MovieClip;
      
      private var main;
      
      private var eventHandler;
      
      private var response:Object;
      
      private var selectedUse:int;
      
      public var tempWardrobeMC:MovieClip;
      
      public var wardrobeMC:MovieClip;
      
      public var skillMC:MovieClip;
      
      public var petMC:MovieClip;
      
      public function ArenaPreset(param1:*, param2:*)
      {
         super();
         this.main = param1;
         this.panelMC = param2.panelMC;
         this.escapeKey = new EscapeKeyManager(this.panelMC);
         this.escapeKey.addListener(this.panelMC,this.closePanel);
         this.skillMC = param2.SkillInventory;
         this.petMC = param2.PetInventory;
         this.tempWardrobeMC = param2.Wardrobe;
         this.skillMC.visible = false;
         this.petMC.visible = false;
         this.tempWardrobeMC.visible = false;
         this.eventHandler = new EventHandler();
         this.eventHandler.addListener(this.panelMC.btnClose,MouseEvent.CLICK,this.closePanel);
         this.getData();
      }
      
      public function getData() : void
      {
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["FZqdrGVcxsEh",[Character.char_id,Character.sessionkey]],this.onDataResponse);
      }
      
      private function onDataResponse(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            PresetData.presetCallback = param1;
            PresetData.preset_id_used = param1.active;
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.initUI();
      }
      
      public function initUI() : void
      {
         this.panelMC.titleTxt.text = "Defender Preset Selection";
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.panelMC["preset_" + _loc1_].nameTxt.text = PresetData.presetCallback.presets[_loc1_].name;
            this.eventHandler.addListener(this.panelMC["preset_" + _loc1_].btn_use,MouseEvent.CLICK,this.usePreset);
            this.eventHandler.addListener(this.panelMC["preset_" + _loc1_].btn_edit,MouseEvent.CLICK,this.editPreset);
            if(PresetData.preset_id_used == PresetData.presetCallback.presets[_loc1_].id)
            {
               this.panelMC["preset_" + _loc1_].btn_use.visible = false;
               this.panelMC.currentPresetTxt.text = "Current Preset: " + PresetData.presetCallback.presets[_loc1_].name;
            }
            else
            {
               this.panelMC["preset_" + _loc1_].btn_use.visible = true;
            }
            _loc1_++;
         }
      }
      
      private function editPreset(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget.parent.name.replace("preset_","");
         PresetData.preset_id_edit = PresetData.presetCallback.presets[_loc2_].id;
         PresetData.preset_hair = PresetData.presetCallback.presets[_loc2_].hair;
         PresetData.preset_set = PresetData.presetCallback.presets[_loc2_].clothing;
         PresetData.preset_back = PresetData.presetCallback.presets[_loc2_].back_item;
         PresetData.preset_wpn = PresetData.presetCallback.presets[_loc2_].weapon;
         PresetData.preset_acc = PresetData.presetCallback.presets[_loc2_].accessory;
         PresetData.preset_hair_color = PresetData.presetCallback.presets[_loc2_].hair_color;
         PresetData.preset_skin_color = PresetData.presetCallback.presets[_loc2_].skin_color;
         PresetData.preset_skill = PresetData.presetCallback.presets[_loc2_].skills;
         PresetData.preset_pet = PresetData.presetCallback.presets[_loc2_].pet.pet_swf == null ? "" : PresetData.presetCallback.presets[_loc2_].pet.pet_swf;
         PresetData.preset_pet_id = PresetData.presetCallback.presets[_loc2_].pet.pet_id == null ? 0 : int(PresetData.presetCallback.presets[_loc2_].pet.pet_id);
         PresetData.selected_preset_name = PresetData.presetCallback.presets[_loc2_].name;
         this.loadWardrobe();
      }
      
      private function usePreset(param1:MouseEvent) : void
      {
         this.selectedUse = param1.currentTarget.parent.name.replace("preset_","");
         this.main.loading(true);
         this.main.amf_manager.service("sbLWNKNMlyKVKII8.SPR94PwhZknv",["ETt1WsMUsaLg",[Character.char_id,Character.sessionkey,PresetData.presetCallback.presets[this.selectedUse].id]],this.onUsePreset);
      }
      
      private function onUsePreset(param1:Object) : void
      {
         this.main.loading(false);
         if(param1.status == 1)
         {
            PresetData.preset_id_used = PresetData.presetCallback.presets[this.selectedUse].id;
            this.initUI();
         }
         else if(param1.status > 1)
         {
            this.main.showMessage(param1.result);
         }
         else
         {
            this.main.getError(param1.error);
         }
         this.initUI();
      }
      
      public function loadWardrobe() : *
      {
         var _loc1_:Class = getDefinitionByName("id.ninjasage.features.Wardrobe") as Class;
         this.wardrobeMC = new _loc1_(this.main,this.tempWardrobeMC,this);
         this.tempWardrobeMC.visible = true;
      }
      
      private function closePanel(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(this.escapeKey)
         {
            this.escapeKey.destroy();
            this.escapeKey = null;
         }
         this.main.removeExternalSwfPanel();
         this.eventHandler.removeAllEventListeners();
         NinjaSage.clearLoader();
         NinjaSage.clearEventListener();
         this.main = null;
         this.character = null;
         this.eventHandler = null;
         GF.removeAllChild(this.panelMC);
      }
   }
}
