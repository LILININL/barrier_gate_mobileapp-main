import 'dart:core';

import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/04BR_MB_VisitorCarList_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BrMbvisitorCarListModel04Controller {
  static Future<List<BrMbvisitorCarListModel04>> getBrMbvisitorCarListModel04s(String villageprojectResidentID, villageprojectDetailID) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        BrMbvisitorCarListModel04.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '04BR_MB_VisitorCarList?xvillageprojectResidentID=$villageprojectResidentID:S&xvillageprojectDetailID=$villageprojectDetailID:S');
// '03BR_MB_ResidentCarList?xResident_id=$villageprojectResidentID:S&xVillageDetailID=$villageprojectDetailID:S'
    return List<BrMbvisitorCarListModel04>.from(value.map((e) => e as BrMbvisitorCarListModel04));
  }

  static Future<List<BrMbvisitorCarListModel04>> getBrMbvisitorCarHistoryListModel04(String beginDate, endDate, xvillageprojectResidentID, xvillageprojectDetailID) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        BrMbvisitorCarListModel04.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '04BR_MB_VisitorCarListHistory?xvillageprojectResidentID=$xvillageprojectResidentID:S&beginDate=$beginDate:S&endDate=$endDate:S&xvillageprojectDetailID=$xvillageprojectDetailID:S'
        // '04BR_MB_VisitorCarListHistory?xvillageprojectResidentID=4:S&beginDate=${beginDate}:S&endDate=${endDate}'
        );
// '03BR_MB_ResidentCarList?xResident_id=$villageprojectResidentID:S&xVillageDetailID=$villageprojectDetailID:S'
    return List<BrMbvisitorCarListModel04>.from(value.map((e) => e as BrMbvisitorCarListModel04));
  }
}
