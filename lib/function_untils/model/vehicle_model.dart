import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Vehicle extends EHPData {
  int? vehicle_id;
  String? license_plate;
  String? province;
  String? color;
  String? vehicle_model;
  String? is_resident;
  int? villageproject_resident_id;
  int? carbrand_id;
  int? villageproject_detail_id;
  String? sync_data;

  static Vehicle newInstance() {
    return Vehicle(null, null, null, null, null, null, null, null, null, null);
  }

  Vehicle(
      this.vehicle_id,
      this.license_plate,
      this.province,
      this.color,
      this.vehicle_model,
      this.is_resident,
      this.villageproject_resident_id,
      this.carbrand_id,
      this.villageproject_detail_id,
      this.sync_data);
  @override
  Vehicle fromJson(Map<String, dynamic> json) {
    return Vehicle(
      json['vehicle_id'],
      json['license_plate']?.toString(),
      json['province']?.toString(),
      json['color']?.toString(),
      json['vehicle_model']?.toString(),
      json['is_resident']?.toString(),
      json['villageproject_resident_id'],
      json['carbrand_id'],
      json['villageproject_detail_id'],
      json['sync_data'],
    );
  }

  @override
  EHPData getInstance() {
    return Vehicle.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicle_id,
        'license_plate': license_plate,
        'province': province,
        'color': color,
        'vehicle_model': vehicle_model,
        'is_resident': is_resident,
        'villageproject_resident_id': villageproject_resident_id,
        'carbrand_id': carbrand_id,
        'villageproject_detail_id': villageproject_detail_id,
        'sync_data': sync_data
      };
  @override
  String getTableName() {
    return 'vehicle';
  }

  @override
  String getKeyFieldName() {
    return 'vehicle_id';
  }

  @override
  String getKeyFieldValue() {
    return vehicle_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "vehicle_id",
      "license_plate",
      "province",
      "color",
      "vehicle_model",
      "is_resident",
      "villageproject_resident_id",
      "carbrand_id",
      "villageproject_detail_id",
      "sync_data"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 6, 6, 6, 6, 6, 2, 2, 2, 6];
  }
}
