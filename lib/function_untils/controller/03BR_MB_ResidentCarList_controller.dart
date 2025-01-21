import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/03BR_MB_ResidentCarList_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BrMbResidentCarListModel03Controller {
  static Future<List<BrMbResidentCarListModel03>> getBrMbResidentCarList(String villageprojectResidentID, villageprojectDetailID) async {
    // /03BR_MB_ResidentCarList?xResident_id=4:S&xVillageDetailID=28:S
    final value = await serviceLocator<EHPApi>().getRestAPI(BrMbResidentCarListModel03.newInstance(), '03BR_MB_ResidentCarList?xResident_id=$villageprojectResidentID:S&xVillageDetailID=$villageprojectDetailID:S');
    return List<BrMbResidentCarListModel03>.from(value.map((e) => e as BrMbResidentCarListModel03));
  }

//    static Future<List<BrMbResidentListVillageModel02>> getBrMbResidentListVillageModel02s(String filter) async {
//     final value = await serviceLocator<EHPApi>().getRestAPI(
//         BrMbResidentListVillageModel02.newInstance(),
//         // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
//         '02BR_MB_ResidentListVillage?xID=${filter}:S'
//         // '?$filter&${BrMbResidentListVillageModel02.newInstance().getDefaultRestURIParam()}&\$limit=100'
//         );

//     return List<BrMbResidentListVillageModel02>.from(value.map((e) => e as BrMbResidentListVillageModel02));
//   }
// }

  // static Future<[preset]> get[preset]FromID(int [preset]ID) async {

  //   final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
  //       [preset].newInstance(), 'table_name_id=$[preset]ID');

  //   if ((dataCount ?? 0)>0) {
  //     return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
  //         [preset].newInstance(), '?table_name_id=$[preset]ID') as [preset];
  //   } else {

  //     return [preset].newInstance()
  //     ..table_name_id = [preset]ID;
  //   }

  // }

  // static Future<bool> save[preset]([preset] [preset]Data) async {
  //   return await serviceLocator<EHPApi>()
  //       .postRestAPIData([preset]Data, [preset]Data.getKeyFieldValue());
  // }

  // static Future<bool> delete[preset]([preset] [preset]Data) async {
  //   return await serviceLocator<EHPApi>().deleteRestAPI([preset]Data);
  // }
}
