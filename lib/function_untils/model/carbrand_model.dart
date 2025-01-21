import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Carbrand extends EHPData {
  int? carbrand_id;
  String? carbrandbrand_name;
  static Carbrand newInstance() {
    return Carbrand(null, null);
  }

  Carbrand(this.carbrand_id, this.carbrandbrand_name);
  @override
  Carbrand fromJson(Map<String, dynamic> json) {
    return Carbrand(
      json['carbrand_id'],
      json['carbrandbrand_name']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return Carbrand.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'carbrand_id': carbrand_id,
        'carbrandbrand_name': carbrandbrand_name,
      };
  @override
  String getTableName() {
    return 'carbrand';
  }

  @override
  String getKeyFieldName() {
    return 'carbrand_id';
  }

  @override
  String getKeyFieldValue() {
    return carbrand_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "carbrand_id",
      "carbrandbrand_name"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      6
    ];
  }
}
