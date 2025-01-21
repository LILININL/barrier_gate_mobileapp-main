import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/villageproject_resident_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VillageprojectResidentController {
  static Future<List<VillageprojectResident>> getVillageprojectResidents(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        VillageprojectResident.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${VillageprojectResident.newInstance().getDefaultRestURIParam()}&\$limit=100');

    return List<VillageprojectResident>.from(value.map((e) => e as VillageprojectResident));
  }

  static Future<VillageprojectResident> getVillageprojectResidentFromID(int villageprojectResidentID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(VillageprojectResident.newInstance(), 'villageproject_resident_id=$villageprojectResidentID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(VillageprojectResident.newInstance(), '?villageproject_resident_id=$villageprojectResidentID') as VillageprojectResident;
    } else {
      return VillageprojectResident.newInstance()..villageproject_resident_id = villageprojectResidentID;
    }
  }

  static Future<bool> saveVillageprojectResident(VillageprojectResident villageprojectResidentData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(villageprojectResidentData, villageprojectResidentData.getKeyFieldValue());
  }

  static Future<bool> deleteVillageprojectResident(VillageprojectResident villageprojectResidentData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(villageprojectResidentData);
  }
}
