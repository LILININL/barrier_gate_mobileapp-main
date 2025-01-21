import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/villageproject_register_qr_model.dart';
import 'package:barrier_gate/function_untils/model/villageproject_resident_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VillageprojectRegisterQrController {
  static Future<List<VillageprojectRegisterQr>> getVillageprojectRegisterQrs(
      String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        VillageprojectRegisterQr.newInstance(),
        '?$filter&${VillageprojectRegisterQr.newInstance().getDefaultRestURIParam()}&\$limit=100');

    return List<VillageprojectRegisterQr>.from(
        value.map((e) => e as VillageprojectRegisterQr));
  }

  static Future<bool> checkDuplicateByDetailId(
      int detailId, int? officer_id) async {
    var response = await serviceLocator<EHPApi>().getRestAPI(
      VillageprojectResident.newInstance(),
      '?villageproject_detail_id=$detailId&officer_id=$officer_id',
    );

    print('Response: $response'); // Debug เพื่อดูผลลัพธ์ที่ได้จาก API
    return response.isNotEmpty;
  }

  static Future<VillageprojectRegisterQr> getVillageprojectRegisterQrFromID(
      int villageprojectRegisterQrID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
        VillageprojectRegisterQr.newInstance(),
        'villageproject_register_qr_id=$villageprojectRegisterQrID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
              VillageprojectRegisterQr.newInstance(),
              '?villageproject_register_qr_id=$villageprojectRegisterQrID')
          as VillageprojectRegisterQr;
    } else {
      return VillageprojectRegisterQr.newInstance()
        ..villageproject_register_qr_id = villageprojectRegisterQrID;
    }
  }

  static Future<bool> saveVillageprojectRegisterQr(
      VillageprojectRegisterQr villageprojectRegisterQrData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(
        villageprojectRegisterQrData,
        villageprojectRegisterQrData.getKeyFieldValue());
  }

  static Future<bool> deleteVillageprojectRegisterQr(
      VillageprojectRegisterQr villageprojectRegisterQrData) async {
    return await serviceLocator<EHPApi>()
        .deleteRestAPI(villageprojectRegisterQrData);
  }
}
