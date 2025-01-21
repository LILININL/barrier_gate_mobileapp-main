import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/02BR_MB_ResidentListVillage_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// BrMbResidentListVillageModel02
class BrMbResidentListVillageModel02Controller {
  static Future<List<BrMbResidentListVillageModel02>>
      getBrMbResidentListVillageModel02s(Future<String?> futureFilter) async {
    final filter =
        await futureFilter; // Await the future to get the actual value

    if (filter == null || filter.isEmpty) {
      throw Exception("Filter cannot be null or empty");
    }

    final value = await serviceLocator<EHPApi>().getRestAPI(
        BrMbResidentListVillageModel02.newInstance(),
        '02BR_MB_ResidentListVillage?xID=${filter}:S');

    return List<BrMbResidentListVillageModel02>.from(
        value.map((e) => e as BrMbResidentListVillageModel02));
  }
}
