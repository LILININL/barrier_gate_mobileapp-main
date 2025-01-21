import 'dart:convert';

import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Prename extends EHPData {
  int? prename_id;
  String? prename_name;
  int? sex_id;
  static Prename newInstance() {
    return Prename(null, null, null);
  }

  Prename(this.prename_id, this.prename_name, this.sex_id);
  @override
  Prename fromJson(Map<String, dynamic> json) {
    return Prename(
      json['prename_id'],
      json['prename_name']?.toString(),
      json['sex_id'],
    );
  }

  @override
  EHPData getInstance() {
    return Prename.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'prename_id': prename_id,
        'prename_name': prename_name,
        'sex_id': sex_id,
      };
  @override
  String getTableName() {
    return 'prename';
  }

  @override
  String getKeyFieldName() {
    return 'prename_id';
  }

  @override
  String getKeyFieldValue() {
    return prename_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "prename_id",
      "prename_name",
      "sex_id"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      6,
      2
    ];
  }
}
