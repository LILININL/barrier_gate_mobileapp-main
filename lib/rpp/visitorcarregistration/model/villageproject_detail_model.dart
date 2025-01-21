import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VillageprojectDetail extends EHPData {
  int? villageproject_id;
  int? villageproject_detail_id;
  String? house_number;
  String? soi;
  int? villageproject_resident_id;
  static VillageprojectDetail newInstance() {
    return VillageprojectDetail(null, null, null, null, null);
  }

  VillageprojectDetail(this.villageproject_id, this.villageproject_detail_id,
      this.house_number, this.soi, this.villageproject_resident_id);
  @override
  VillageprojectDetail fromJson(Map<String, dynamic> json) {
    return VillageprojectDetail(
      json['villageproject_id'],
      json['villageproject_detail_id'],
      json['house_number']?.toString(),
      json['soi']?.toString(),
      json['villageproject_resident_id'],
    );
  }

  @override
  EHPData getInstance() {
    return VillageprojectDetail.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'villageproject_id': villageproject_id,
        'villageproject_detail_id': villageproject_detail_id,
        'house_number': house_number,
        'soi': soi,
        'villageproject_resident_id': villageproject_resident_id,
      };
  @override
  String getTableName() {
    return '[preset]/21BR_RppInspectionDetailList';
  }

  @override
  String getKeyFieldName() {
    return 'table_name_id';
  }

  @override
  String getKeyFieldValue() {
    return villageproject_detail_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "villageproject_id",
      "villageproject_detail_id",
      "house_number",
      "soi",
      "villageproject_resident_id"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 2, 6, 6, 2];
  }
}
