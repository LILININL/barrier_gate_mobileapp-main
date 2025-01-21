import 'dart:convert';

import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ThaiaddressModel extends EHPData {
  String? addressid;
  String? name;
  String? chwpart;
  String? amppart;
  String? tmbpart;
  String? codetype;
  String? pocode;
  String? full_name;
  String? hos_guid;
  String? hos_guid_ext;
  static ThaiaddressModel newInstance() {
    return ThaiaddressModel(null, null, null, null, null, null, null, null, null, null);
  }

  ThaiaddressModel(this.addressid, this.name, this.chwpart, this.amppart, this.tmbpart, this.codetype, this.pocode, this.full_name, this.hos_guid, this.hos_guid_ext);
  @override
  ThaiaddressModel fromJson(Map<String, dynamic> json) {
    return ThaiaddressModel(
      json['addressid']?.toString(),
      json['name']?.toString(),
      json['chwpart']?.toString(),
      json['amppart']?.toString(),
      json['tmbpart']?.toString(),
      json['codetype']?.toString(),
      json['pocode']?.toString(),
      json['full_name']?.toString(),
      json['hos_guid']?.toString(),
      json['hos_guid_ext']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return ThaiaddressModel.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'addressid': addressid,
        'name': name,
        'chwpart': chwpart,
        'amppart': amppart,
        'tmbpart': tmbpart,
        'codetype': codetype,
        'pocode': pocode,
        'full_name': full_name,
        'hos_guid': hos_guid,
        'hos_guid_ext': hos_guid_ext,
      };
  @override
  String getTableName() {
    return 'thaiaddress';
  }

  @override
  String getKeyFieldName() {
    return 'addressid';
  }

  @override
  String getKeyFieldValue() {
    return addressid.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "addressid",
      "name",
      "chwpart",
      "amppart",
      "tmbpart",
      "codetype",
      "pocode",
      "full_name",
      "hos_guid",
      "hos_guid_ext"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      6,
      6,
      6,
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
