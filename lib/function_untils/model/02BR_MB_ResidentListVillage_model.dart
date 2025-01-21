import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BrMbResidentListVillageModel02 extends EHPData {
  int? villageproject_resident_id;
  int? villageproject_detail_id;
  String? addrpart;
  String? addr_soi;
  String? villageproject_display_name;
  String? villageproject_registered_name;
  int? officer_id;
  String? chwpart;
  String? amppart;
  String? tmbpart;
  static BrMbResidentListVillageModel02 newInstance() {
    return BrMbResidentListVillageModel02(null, null, null, null, null, null, null, null, null, null);
  }

  BrMbResidentListVillageModel02(this.villageproject_resident_id, this.villageproject_detail_id, this.addrpart, this.addr_soi, this.villageproject_display_name, this.villageproject_registered_name, this.officer_id, this.chwpart, this.amppart, this.tmbpart);
  @override
  BrMbResidentListVillageModel02 fromJson(Map<String, dynamic> json) {
    return BrMbResidentListVillageModel02(
      json['villageproject_resident_id'],
      json['villageproject_detail_id'],
      json['addrpart']?.toString(),
      json['addr_soi']?.toString(),
      json['villageproject_display_name']?.toString(),
      json['villageproject_registered_name']?.toString(),
      json['officer_id'],
      json['chwpart']?.toString(),
      json['amppart']?.toString(),
      json['tmbpart']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return BrMbResidentListVillageModel02.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'villageproject_resident_id': villageproject_resident_id,
        'villageproject_detail_id': villageproject_detail_id,
        'addrpart': addrpart,
        'addr_soi': addr_soi,
        'villageproject_display_name': villageproject_display_name,
        'villageproject_registered_name': villageproject_registered_name,
        'officer_id': officer_id,
        'chwpart': chwpart,
        'amppart': amppart,
        'tmbpart': tmbpart,
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
      "villageproject_detail_id",
      "addrpart",
      "addr_soi",
      "villageproject_display_name",
      "villageproject_registered_name",
      "officer_id",
      "chwpart",
      "amppart",
      "tmbpart"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      2,
      6,
      6,
      6,
      6,
      2,
      6,
      6,
      6
    ];
  }
}
