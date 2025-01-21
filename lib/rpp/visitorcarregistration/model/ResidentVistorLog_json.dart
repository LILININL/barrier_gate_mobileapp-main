import 'dart:convert';

import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ResidentVistorLog extends EHPData {
  int? vehicle_id;
  int? villageproject_id;
  int? villageproject_detail_id;
  String? license_plate;
  DateTime? datetime_in;
  DateTime? datetime_out;
  String? is_resident;

  static ResidentVistorLog newInstance() {
    return ResidentVistorLog(null, null, null, null, null, null, null);
  }

  ResidentVistorLog(
      this.vehicle_id,
      this.villageproject_id,
      this.villageproject_detail_id,
      this.license_plate,
      this.datetime_in,
      this.datetime_out,
      this.is_resident);
  @override
  
  ResidentVistorLog fromJson(Map<String, dynamic> json) {
    return ResidentVistorLog(
      json['vehicle_id'],
      json['villageproject_id'],
      json['villageproject_detail_id'],
      json['license_plate']?.toString(),
      json['datetime_in'] == null
          ? null
          : parseDateTimeFormat(json['datetime_in'].toString()),
      json['datetime_out'] == null
          ? null
          : parseDateTimeFormat(json['datetime_out'].toString()),
      json['is_resident']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return ResidentVistorLog.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicle_id,
        'villageproject_id': villageproject_id,
        'villageproject_detail_id': villageproject_detail_id,
        'license_plate': license_plate,
        'datetime_in': datetime_in == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime_in!),
        'datetime_out': datetime_out == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime_out!),
        'is_resident': is_resident,
      };
  @override
  String getTableName() {
    return '[preset]/14BR_ResidentVistorLog';
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
      "villageproject_id",
      "villageproject_detail_id",
      "license_plate",
      "datetime_in",
      "datetime_out",
      "is_resident"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 2, 2, 6, 4, 4, 6];
  }
}
