import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// 03BR_MB_ResidentCarList
// class BrMbResidentCarListModel03 extends EHPData {

class BrMbResidentCarListModel03 extends EHPData {
  int? vehicle_id;
  String? license_plate;
  String? province;
  String? vehicle_model;
  String? is_resident;
  String? color;
  int? villageproject_detail_id;
  String? carbrandbrand_name;
  String? car_detail;
  Uint8List? vehicle_picture;
  int? vehicle_picture_id;
  // vp.vehicle_picture
  static BrMbResidentCarListModel03 newInstance() {
    return BrMbResidentCarListModel03(null, null, null, null, null, null, null, null, null, null, null);
  }

  BrMbResidentCarListModel03(this.vehicle_id, this.license_plate, this.province, this.vehicle_model, this.is_resident, this.color, this.villageproject_detail_id, this.carbrandbrand_name, this.car_detail, this.vehicle_picture, this.vehicle_picture_id);
  @override
  BrMbResidentCarListModel03 fromJson(Map<String, dynamic> json) {
    return BrMbResidentCarListModel03(json['vehicle_id'], json['license_plate']?.toString(), json['province']?.toString(), json['vehicle_model']?.toString(), json['is_resident']?.toString(), json['color']?.toString(), json['villageproject_detail_id'], json['carbrandbrand_name'], json['car_detail'], json['vehicle_picture'] == null ? null : base64.decode(json['vehicle_picture'].toString()), json['vehicle_picture_id']);
  }

  @override
  EHPData getInstance() {
    return BrMbResidentCarListModel03.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicle_id,
        'license_plate': license_plate,
        'province': province,
        'vehicle_model': vehicle_model,
        'is_resident': is_resident,
        'color': color,
        'villageproject_detail_id': villageproject_detail_id,
        'carbrandbrand_name': carbrandbrand_name,
        'car_detail': car_detail,
        'vehicle_picture': vehicle_picture == null ? null : base64.encode(vehicle_picture!),
        'vehicle_picture_id': vehicle_picture_id
      };
  @override
  String getTableName() {
    return '[preset]';
  }

  @override
  String getKeyFieldName() {
    return 'table_name_id';
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
      "vehicle_model",
      "is_resident",
      "color",
      "villageproject_detail_id",
      "carbrandbrand_name",
      "car_detail",
      "vehicle_picture",
      "vehicle_picture_id"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      6,
      6,
      6,
      6,
      6,
      2,
      6,
      6,
      7,
      2
    ];
  }
}
