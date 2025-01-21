import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/carbrand_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class CarbrandController {
  static Future<List<Carbrand>> getCarbrands(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        Carbrand.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${Carbrand.newInstance().getDefaultRestURIParam()}&\$limit=100');

    return List<Carbrand>.from(value.map((e) => e as Carbrand));
  }

  static Future<Carbrand> getCarbrandFromID(int carbrandID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(Carbrand.newInstance(), 'carbrand_id=$carbrandID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(Carbrand.newInstance(), '?carbrand_id=$carbrandID') as Carbrand;
    } else {
      return Carbrand.newInstance()..carbrand_id = carbrandID;
    }
  }

  static Future<bool> saveCarbrand(Carbrand carbrandData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(carbrandData, carbrandData.getKeyFieldValue());
  }

  static Future<bool> deleteCarbrand(Carbrand carbrandData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(carbrandData);
  }
}
