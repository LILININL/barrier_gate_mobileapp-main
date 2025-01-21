import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/prename_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';


class PrenameController {

  
  static Future<List<Prename>> getPrenames(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        Prename.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${Prename.newInstance().getDefaultRestURIParam()}&\$limit=199');

    return List<Prename>.from(value.map((e) => e as Prename));
  }

  static Future<Prename> getPrenameFromID(int prenameID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(Prename.newInstance(), 'prename_id=$prenameID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(Prename.newInstance(), '?prename_id=$prenameID') as Prename;
    } else {
      return Prename.newInstance()..prename_id = prenameID;
    }
  }

  static Future<bool> savePrename(Prename prenameData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(prenameData, prenameData.getKeyFieldValue());
  }

  static Future<bool> deletePrename(Prename prenameData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(prenameData);
  }
}
