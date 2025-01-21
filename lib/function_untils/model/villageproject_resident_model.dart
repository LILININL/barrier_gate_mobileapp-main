import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VillageprojectResident extends EHPData {
  int? villageproject_resident_id;
  DateTime? resident_register_datetime;
  int? villageproject_detail_id;
  int? officer_id;
  static VillageprojectResident newInstance() {
    return VillageprojectResident(null, null, null, null);
  }

  VillageprojectResident(this.villageproject_resident_id, this.resident_register_datetime, this.villageproject_detail_id, this.officer_id);
  @override
  VillageprojectResident fromJson(Map<String, dynamic> json) {
    return VillageprojectResident(
      json['villageproject_resident_id'],
      json['resident_register_datetime'] == null ? null : parseDateTimeFormat(json['resident_register_datetime'].toString()),
      json['villageproject_detail_id'],
      json['officer_id'],
    );
  }

  @override
  EHPData getInstance() {
    return VillageprojectResident.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'villageproject_resident_id': villageproject_resident_id,
        'resident_register_datetime': resident_register_datetime == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(resident_register_datetime!),
        'villageproject_detail_id': villageproject_detail_id,
        'officer_id': officer_id,
      };
  @override
  String getTableName() {
    return 'villageproject_resident';
  }

  @override
  String getKeyFieldName() {
    return 'villageproject_resident_id';
  }

  @override
  String getKeyFieldValue() {
    return villageproject_resident_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "villageproject_resident_id",
      "resident_register_datetime",
      "villageproject_detail_id",
      "officer_id"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      4,
      2,
      2
    ];
  }
}
