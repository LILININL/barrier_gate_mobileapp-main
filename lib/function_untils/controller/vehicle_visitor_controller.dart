import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/vehicle_visitor_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VehicleVisitorController {
  static Future<List<VehicleVisitor>> getVehicleVisitors(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        VehicleVisitor.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${VehicleVisitor.newInstance().getDefaultRestURIParam()}&\$limit=100');

    return List<VehicleVisitor>.from(value.map((e) => e as VehicleVisitor));
  }

  static Future<VehicleVisitor> getVehicleVisitorFromID(int vehicleVisitorID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(VehicleVisitor.newInstance(), 'vehicle_visitor_id=$vehicleVisitorID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(VehicleVisitor.newInstance(), '?vehicle_visitor_id=$vehicleVisitorID') as VehicleVisitor;
    } else {
      return VehicleVisitor.newInstance()..vehicle_visitor_id = vehicleVisitorID;
    }
  }

  static Future<bool> saveVehicleVisitor(VehicleVisitor vehicleVisitorData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(vehicleVisitorData, vehicleVisitorData.getKeyFieldValue());
  }

  static Future<bool> deleteVehicleVisitor(VehicleVisitor vehicleVisitorData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(vehicleVisitorData);
  }
}
