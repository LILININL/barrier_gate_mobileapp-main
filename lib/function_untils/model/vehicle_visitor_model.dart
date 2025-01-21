import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VehicleVisitor extends EHPData {
  int? vehicle_visitor_id;
  int? vehicle_id;
  DateTime? vehicle_visitor_datetime_in;
  DateTime? vehicle_visitor_datetime_out;
  DateTime? visitor_register_datetime;
  int? villageproject_resident_id;
  int? vehicle_visitor_status_id;
  String? approve_status;
  String? is_all_day_access;
  int? villageproject_detail_id;
  static VehicleVisitor newInstance() {
    return VehicleVisitor(
        null, null, null, null, null, null, null, null, null, null);
  }

  VehicleVisitor(
      this.vehicle_visitor_id,
      this.vehicle_id,
      this.vehicle_visitor_datetime_in,
      this.vehicle_visitor_datetime_out,
      this.visitor_register_datetime,
      this.villageproject_resident_id,
      this.vehicle_visitor_status_id,
      this.approve_status,
      this.is_all_day_access,
      this.villageproject_detail_id);
  @override
  VehicleVisitor fromJson(Map<String, dynamic> json) {
    return VehicleVisitor(
        json['vehicle_visitor_id'],
        json['vehicle_id'],
        json['vehicle_visitor_datetime_in'] == null
            ? null
            : parseDateTimeFormat(
                json['vehicle_visitor_datetime_in'].toString()),
        json['vehicle_visitor_datetime_out'] == null
            ? null
            : parseDateTimeFormat(
                json['vehicle_visitor_datetime_out'].toString()),
        json['visitor_register_datetime'] == null
            ? null
            : parseDateTimeFormat(json['visitor_register_datetime'].toString()),
        json['villageproject_resident_id'],
        json['vehicle_visitor_status_id'],
        json['approve_status'],
        json['is_all_day_access'],
        json['villageproject_detail_id']);
  }

  @override
  EHPData getInstance() {
    return VehicleVisitor.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'vehicle_visitor_id': vehicle_visitor_id,
        'vehicle_id': vehicle_id,
        'vehicle_visitor_datetime_in': vehicle_visitor_datetime_in == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(vehicle_visitor_datetime_in!),
        'vehicle_visitor_datetime_out': vehicle_visitor_datetime_out == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(vehicle_visitor_datetime_out!),
        'visitor_register_datetime': visitor_register_datetime == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(visitor_register_datetime!),
        'villageproject_resident_id': villageproject_resident_id,
        'vehicle_visitor_status_id': vehicle_visitor_status_id,
        'approve_status': approve_status,
        'is_all_day_access': is_all_day_access,
        'villageproject_detail_id': villageproject_detail_id
      };
  @override
  String getTableName() {
    return 'vehicle_visitor';
  }

  @override
  String getKeyFieldName() {
    return 'vehicle_visitor_id';
  }

  @override
  String getKeyFieldValue() {
    return vehicle_visitor_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "vehicle_visitor_id",
      "vehicle_id",
      "vehicle_visitor_datetime_in",
      "vehicle_visitor_datetime_out",
      "visitor_register_datetime",
      "villageproject_resident_id",
      "vehicle_visitor_status_id",
      "approve_status",
      "is_all_day_access",
      "villageproject_detail_id"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 2, 4, 4, 4, 2, 2, 6, 6, 2];
  }
}
