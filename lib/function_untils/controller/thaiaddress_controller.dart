import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../model/thaiaddress_model.dart';

class ThaiaddressController {
  static Future<List<ThaiaddressModel>> getThaiaddresss(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        ThaiaddressModel.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${ThaiaddressModel.newInstance().getDefaultRestURIParam()}&\$limit=10249');

    return List<ThaiaddressModel>.from(value.map((e) => e as ThaiaddressModel));
  }

  static Future<List<ThaiaddressModel>> getChwpart(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        ThaiaddressModel.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        'thaiaddress?codetype=1&\$limit=100');

    return List<ThaiaddressModel>.from(value.map((e) => e as ThaiaddressModel));
  }

  // static Future<Thaiaddress> getThaiaddressFromID(int thaiaddressID) async {

  //   final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
  //       Thaiaddress.newInstance(), 'addressid=$thaiaddressID');

  //   if ((dataCount ?? 0)>0) {
  //     return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
  //         Thaiaddress.newInstance(), '?addressid=$thaiaddressID') as Thaiaddress;
  //   } else {

  //     return Thaiaddress.newInstance()
  //     ..addressid = thaiaddressID;
  //   }

  // }

  static Future<bool> saveThaiaddress(ThaiaddressModel thaiaddressData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(thaiaddressData, thaiaddressData.getKeyFieldValue());
  }

  static Future<bool> deleteThaiaddress(ThaiaddressModel thaiaddressData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(thaiaddressData);
  }
}
