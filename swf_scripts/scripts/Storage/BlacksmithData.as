package Storage
{
   public class BlacksmithData
   {
      
      public static var weaponList:* = ["wpn_609","wpn_119","wpn_179","wpn_164","wpn_293","wpn_137","wpn_135","wpn_294","wpn_295","wpn_131","wpn_125","wpn_181","wpn_296","wpn_140","wpn_297","wpn_139","wpn_303","wpn_136","wpn_304","wpn_305","wpn_138","wpn_141","wpn_143","wpn_126","wpn_134","wpn_298","wpn_142","wpn_127","wpn_144","wpn_611","wpn_307","wpn_145","wpn_306","wpn_299","wpn_146","wpn_128","wpn_308","wpn_291","wpn_130","wpn_148","wpn_129","wpn_292","wpn_150","wpn_612","wpn_151","wpn_336","wpn_339","wpn_333","wpn_332","wpn_335","wpn_338","wpn_337","wpn_334","wpn_1139","wpn_1141","wpn_1143","wpn_1145","wpn_1147","wpn_1149","wpn_1151","wpn_1153","wpn_1155","wpn_1157","wpn_1159"];
      
      public function BlacksmithData()
      {
         super();
      }
      
      public static function getForgeItems(param1:String) : *
      {
         var _loc2_:* = [];
         switch(param1)
         {
            case "wpn_609":
               _loc2_.item_materials = ["material_01"];
               _loc2_.item_mat_price = ["1"];
               _loc2_.token_price = 100;
               _loc2_.gold_price = 1000;
               _loc2_.req_weapon = "wpn_03";
               break;
            case "wpn_119":
               _loc2_.item_materials = ["material_01"];
               _loc2_.item_mat_price = ["5"];
               _loc2_.token_price = 100;
               _loc2_.gold_price = 10000;
               _loc2_.req_weapon = "wpn_24";
               break;
            case "wpn_179":
               _loc2_.item_materials = ["material_01"];
               _loc2_.item_mat_price = ["2"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 10000;
               _loc2_.req_weapon = "wpn_119";
               break;
            case "wpn_164":
               _loc2_.item_materials = ["material_01"];
               _loc2_.item_mat_price = ["3"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 10000;
               _loc2_.req_weapon = "wpn_01";
               break;
            case "wpn_293":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["3","1"];
               _loc2_.token_price = 500;
               _loc2_.gold_price = 11000;
               _loc2_.req_weapon = "wpn_23";
               break;
            case "wpn_137":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["5","1"];
               _loc2_.token_price = 600;
               _loc2_.gold_price = 12000;
               _loc2_.req_weapon = "wpn_12";
               break;
            case "wpn_135":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["3","1"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 6500;
               _loc2_.req_weapon = "wpn_06";
               break;
            case "wpn_294":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["5","1"];
               _loc2_.token_price = 500;
               _loc2_.gold_price = 13000;
               _loc2_.req_weapon = "wpn_36";
               break;
            case "wpn_295":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["5","2"];
               _loc2_.token_price = 500;
               _loc2_.gold_price = 15000;
               _loc2_.req_weapon = "wpn_50";
               break;
            case "wpn_131":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["2","1"];
               _loc2_.token_price = 100;
               _loc2_.gold_price = 7500;
               _loc2_.req_weapon = "wpn_111";
               break;
            case "wpn_125":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["5","3"];
               _loc2_.token_price = 500;
               _loc2_.gold_price = 15000;
               _loc2_.req_weapon = "wpn_39";
               break;
            case "wpn_181":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["3","1"];
               _loc2_.token_price = 200;
               _loc2_.gold_price = 15000;
               _loc2_.req_weapon = "wpn_125";
               break;
            case "wpn_296":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["7","2"];
               _loc2_.token_price = 600;
               _loc2_.gold_price = 17000;
               _loc2_.req_weapon = "wpn_31";
               break;
            case "wpn_140":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["6","3"];
               _loc2_.token_price = 600;
               _loc2_.gold_price = 18000;
               _loc2_.req_weapon = "wpn_16";
               break;
            case "wpn_297":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["8","3"];
               _loc2_.token_price = 600;
               _loc2_.gold_price = 19000;
               _loc2_.req_weapon = "wpn_47";
               break;
            case "wpn_303":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["5","3","1"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 2000;
               _loc2_.req_weapon = "wpn_301";
               break;
            case "wpn_136":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["5","1","1"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 10000;
               _loc2_.req_weapon = "wpn_131";
               break;
            case "wpn_139":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["3","2","1"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 10000;
               _loc2_.req_weapon = "wpn_37";
               break;
            case "wpn_304":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["5","3","1"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 2000;
               _loc2_.req_weapon = "wpn_301";
               break;
            case "wpn_305":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["5","3","1"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 2000;
               _loc2_.req_weapon = "wpn_301";
               break;
            case "wpn_138":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["3","2","1"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 10000;
               _loc2_.req_weapon = "wpn_07";
               break;
            case "wpn_141":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["5","3"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 20000;
               _loc2_.req_weapon = "wpn_21";
               break;
            case "wpn_143":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["5","3"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 20000;
               _loc2_.req_weapon = "wpn_20";
               break;
            case "wpn_126":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["5","3","1"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 21000;
               _loc2_.req_weapon = "wpn_42";
               break;
            case "wpn_134":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["4","4","1"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 11000;
               _loc2_.req_weapon = "wpn_05";
               break;
            case "wpn_298":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["6","3","2"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 23000;
               _loc2_.req_weapon = "wpn_44";
               break;
            case "wpn_142":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["5","2","2"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 25000;
               _loc2_.req_weapon = "wpn_25";
               break;
            case "wpn_127":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["5","3","2"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 25000;
               _loc2_.req_weapon = "wpn_40";
               break;
            case "wpn_144":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["5","4","2"];
               _loc2_.token_price = 600;
               _loc2_.gold_price = 13500;
               _loc2_.req_weapon = "wpn_85";
               break;
            case "wpn_611":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["4","3","2","1"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 15000;
               _loc2_.req_weapon = "wpn_610";
               break;
            case "wpn_307":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["5","3","3","1"];
               _loc2_.token_price = 600;
               _loc2_.gold_price = 3000;
               _loc2_.req_weapon = "wpn_302";
               break;
            case "wpn_145":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["4","3","2","1"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 15000;
               _loc2_.req_weapon = "wpn_49";
               break;
            case "wpn_306":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["5","3","3","1"];
               _loc2_.token_price = 600;
               _loc2_.gold_price = 3000;
               _loc2_.req_weapon = "wpn_302";
               break;
            case "wpn_299":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["5","3","3","1"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_136";
               break;
            case "wpn_146":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["4","3","2","1"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 15000;
               _loc2_.req_weapon = "wpn_45";
               break;
            case "wpn_128":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["8","5","3","1"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_56";
               break;
            case "wpn_308":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["5","5","3","1"];
               _loc2_.token_price = 600;
               _loc2_.gold_price = 3000;
               _loc2_.req_weapon = "wpn_302";
               break;
            case "wpn_291":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["8","5","3","2"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 33000;
               _loc2_.req_weapon = "wpn_59";
               break;
            case "wpn_130":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["10","6","4","3"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 34000;
               _loc2_.req_weapon = "wpn_79";
               break;
            case "wpn_148":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["3","2","2","1"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 35000;
               _loc2_.req_weapon = "wpn_86";
               break;
            case "wpn_129":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["10","8","6","3","1"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 35000;
               _loc2_.req_weapon = "wpn_54";
               break;
            case "wpn_292":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["9","6","4","5","1"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 42000;
               _loc2_.req_weapon = "wpn_88";
               break;
            case "wpn_150":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["4","3","1","1","1"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 25000;
               _loc2_.req_weapon = "wpn_46";
               break;
            case "wpn_612":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["4","3","1","1","1"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 25000;
               _loc2_.req_weapon = "wpn_611";
               break;
            case "wpn_151":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["4","3","1","1","1"];
               _loc2_.token_price = 300;
               _loc2_.gold_price = 25000;
               _loc2_.req_weapon = "wpn_60";
               break;
            case "wpn_336":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["5","4","2","1","2"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_70";
               break;
            case "wpn_339":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["5","4","2","1","2"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_107";
               break;
            case "wpn_333":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["5","4","2","1","2"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_62";
               break;
            case "wpn_332":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["10","7","5","4","3"];
               _loc2_.token_price = 800;
               _loc2_.gold_price = 120000;
               _loc2_.req_weapon = "wpn_10";
               break;
            case "wpn_335":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["5","4","2","1","2"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_69";
               break;
            case "wpn_338":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["5","4","2","1","2"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_76";
               break;
            case "wpn_337":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["5","4","2","1","2"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_71";
               break;
            case "wpn_334":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["5","4","2","1","2"];
               _loc2_.token_price = 400;
               _loc2_.gold_price = 30000;
               _loc2_.req_weapon = "wpn_63";
               break;
            case "wpn_1139":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["3","2"];
               _loc2_.token_price = 1000;
               _loc2_.gold_price = 1000000;
               _loc2_.req_weapon = "wpn_1138";
               break;
            case "wpn_1141":
               _loc2_.item_materials = ["material_01","material_02"];
               _loc2_.item_mat_price = ["5","4"];
               _loc2_.token_price = 2000;
               _loc2_.gold_price = 2000000;
               _loc2_.req_weapon = "wpn_1140";
               break;
            case "wpn_1143":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["7","5","3"];
               _loc2_.token_price = 3000;
               _loc2_.gold_price = 3000000;
               _loc2_.req_weapon = "wpn_1142";
               break;
            case "wpn_1145":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["15","13","7"];
               _loc2_.token_price = 4000;
               _loc2_.gold_price = 4000000;
               _loc2_.req_weapon = "wpn_1144";
               break;
            case "wpn_1147":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["15","13","7"];
               _loc2_.token_price = 4000;
               _loc2_.gold_price = 4000000;
               _loc2_.req_weapon = "wpn_1146";
               break;
            case "wpn_1149":
               _loc2_.item_materials = ["material_01","material_02","material_03"];
               _loc2_.item_mat_price = ["24","17","12"];
               _loc2_.token_price = 5000;
               _loc2_.gold_price = 5000000;
               _loc2_.req_weapon = "wpn_1148";
               break;
            case "wpn_1151":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["30","20","15","6"];
               _loc2_.token_price = 6000;
               _loc2_.gold_price = 6000000;
               _loc2_.req_weapon = "wpn_1150";
               break;
            case "wpn_1153":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04"];
               _loc2_.item_mat_price = ["35","27","23","15"];
               _loc2_.token_price = 7000;
               _loc2_.gold_price = 7000000;
               _loc2_.req_weapon = "wpn_1152";
               break;
            case "wpn_1155":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["40","33","25","15","3"];
               _loc2_.token_price = 8000;
               _loc2_.gold_price = 8000000;
               _loc2_.req_weapon = "wpn_1154";
               break;
            case "wpn_1157":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05"];
               _loc2_.item_mat_price = ["45","35","27","18","5"];
               _loc2_.token_price = 9000;
               _loc2_.gold_price = 9000000;
               _loc2_.req_weapon = "wpn_1156";
               break;
            case "wpn_1159":
               _loc2_.item_materials = ["material_01","material_02","material_03","material_04","material_05","material_06"];
               _loc2_.item_mat_price = ["50","40","30","20","10","1"];
               _loc2_.token_price = 10000;
               _loc2_.gold_price = 10000000;
               _loc2_.req_weapon = "wpn_1158";
         }
         if(!_loc2_.hasOwnProperty("item_materials"))
         {
            _loc2_.item_materials = null;
            _loc2_.item_mat_price = null;
            _loc2_.token_price = null;
            _loc2_.gold_price = null;
            _loc2_.req_weapon = null;
         }
         return _loc2_;
      }
   }
}

