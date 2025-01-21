import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/01BR_MB_VillageProject__model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BrMbVillageProjectModel01Controller {
  static Future<List<BrMbVillageProjectModel01>> getBrMbVillageProjectModel01s(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        BrMbVillageProjectModel01.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '/01BR_MB_VillageProject?xID=$filter:S');

    return List<BrMbVillageProjectModel01>.from(value.map((e) => e as BrMbVillageProjectModel01));
  }
}
