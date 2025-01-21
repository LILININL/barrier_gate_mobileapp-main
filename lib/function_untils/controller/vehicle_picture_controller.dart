import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/vehicle_picture_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VehiclePictureController {
  static Future<List<VehiclePicture>> getVehiclePictures(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        VehiclePicture.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${VehiclePicture.newInstance().getDefaultRestURIParam()}&\$limit=100');

    return List<VehiclePicture>.from(value.map((e) => e as VehiclePicture));
  }

  static Future<VehiclePicture> getVehiclePictureFromID(int vehiclePictureID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(VehiclePicture.newInstance(), 'vehicle_picture_id=$vehiclePictureID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(VehiclePicture.newInstance(), '?vehicle_picture_id=$vehiclePictureID') as VehiclePicture;
    } else {
      return VehiclePicture.newInstance()..vehicle_picture_id = vehiclePictureID;
    }
  }

  static Future<bool> saveVehiclePicture(VehiclePicture vehiclePictureData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(vehiclePictureData, vehiclePictureData.getKeyFieldValue());
  }

  static Future<bool> deleteVehiclePicture(VehiclePicture vehiclePictureData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(vehiclePictureData);
  }
}
