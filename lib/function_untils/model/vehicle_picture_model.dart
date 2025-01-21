import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VehiclePicture extends EHPData {
  int? vehicle_picture_id;
  Uint8List? vehicle_picture;
  int? vehicle_id;
  static VehiclePicture newInstance() {
    return VehiclePicture(null, null, null);
  }

  VehiclePicture(this.vehicle_picture_id, this.vehicle_picture, this.vehicle_id);
  @override
  VehiclePicture fromJson(Map<String, dynamic> json) {
    return VehiclePicture(
      json['vehicle_picture_id'],
      json['vehicle_picture'] == null ? null : base64.decode(json['vehicle_picture'].toString()),
      json['vehicle_id'],
    );
  }

  @override
  EHPData getInstance() {
    return VehiclePicture.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'vehicle_picture_id': vehicle_picture_id,
        'vehicle_picture': vehicle_picture == null ? null : base64.encode(vehicle_picture!),
        'vehicle_id': vehicle_id,
      };
  @override
  String getTableName() {
    return 'vehicle_picture';
  }

  @override
  String getKeyFieldName() {
    return 'vehicle_picture_id';
  }

  @override
  String getKeyFieldValue() {
    return vehicle_picture_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "vehicle_picture_id",
      "vehicle_picture",
      "vehicle_id"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      7,
      2
    ];
  }
}
