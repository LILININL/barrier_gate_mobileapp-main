import 'dart:convert';

import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BrMbVillageProjectModel01 extends EHPData {
  int? villageproject_id;
  String? villageproject_registered_name;
  String? addrpart;
  String? addr_soi;
  String? chwpart;
  String? amppart;
  String? tmbpart;
  String? postal_code;
  static BrMbVillageProjectModel01 newInstance() {
    return BrMbVillageProjectModel01(null, null, null, null, null, null, null, null);
  }

  BrMbVillageProjectModel01(this.villageproject_id, this.villageproject_registered_name, this.addrpart, this.addr_soi, this.chwpart, this.amppart, this.tmbpart, this.postal_code);
  @override
  BrMbVillageProjectModel01 fromJson(Map<String, dynamic> json) {
    return BrMbVillageProjectModel01(
      json['villageproject_id'],
      json['villageproject_registered_name']?.toString(),
      json['addrpart']?.toString(),
      json['addr_soi']?.toString(),
      json['chwpart']?.toString(),
      json['amppart']?.toString(),
      json['tmbpart']?.toString(),
      json['postal_code']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return BrMbVillageProjectModel01.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'villageproject_id': villageproject_id,
        'villageproject_registered_name': villageproject_registered_name,
        'addrpart': addrpart,
        'addr_soi': addr_soi,
        'chwpart': chwpart,
        'amppart': amppart,
        'tmbpart': tmbpart,
        'postal_code': postal_code,
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
    return villageproject_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "villageproject_id",
      "villageproject_registered_name",
      "addrpart",
      "addr_soi",
      "chwpart",
      "amppart",
      "tmbpart",
      "postal_code"
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
      6,
      6
    ];
  }
}
