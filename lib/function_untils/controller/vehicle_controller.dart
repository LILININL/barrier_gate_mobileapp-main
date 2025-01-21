import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/vehicle_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VehicleController {
  static Future<List<Vehicle>> getVehicles(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        Vehicle.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${Vehicle.newInstance().getDefaultRestURIParam()}&\$limit=100');

    return List<Vehicle>.from(value.map((e) => e as Vehicle));
  }

  static Future<Vehicle> getVehicleFromID(int vehicleID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(Vehicle.newInstance(), 'vehicle_id=$vehicleID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(Vehicle.newInstance(), '?vehicle_id=$vehicleID') as Vehicle;
    } else {
      return Vehicle.newInstance()..vehicle_id = vehicleID;
    }
  }

  static Future<bool> saveVehicle(Vehicle vehicleData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(vehicleData, vehicleData.getKeyFieldValue());
  }

  static Future<bool> deleteVehicle(Vehicle vehicleData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(vehicleData);
  }
}
