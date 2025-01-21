import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BrMbvisitorCarListModel04 extends EHPData {
  int? vehicle_visitor_id;
  int? vehicle_id;
  DateTime? vehicle_visitor_datetime_in;
  DateTime? vehicle_visitor_datetime_out;
  String? license_plate;
  String? car_detail;
  DateTime? visitor_register_datetime;
  String? province;
  String? vehicle_model;
  String? carbrandbrand_name;
  int? vehicle_visitor_status_id;
  String? color;
  String? approve_status;
  int? villageproject_detail_id;

  static BrMbvisitorCarListModel04 newInstance() {
    return BrMbvisitorCarListModel04(null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  }

  BrMbvisitorCarListModel04(this.vehicle_visitor_id, this.vehicle_id, this.vehicle_visitor_datetime_in, this.vehicle_visitor_datetime_out, this.license_plate, this.car_detail, this.visitor_register_datetime, this.province, this.vehicle_model, this.carbrandbrand_name, this.vehicle_visitor_status_id, this.color, this.approve_status, this.villageproject_detail_id);

  @override
  BrMbvisitorCarListModel04 fromJson(Map<String, dynamic> json) {
    return BrMbvisitorCarListModel04(json['vehicle_visitor_id'], json['vehicle_id'], json['vehicle_visitor_datetime_in'] == null ? null : parseDateTimeFormat(json['vehicle_visitor_datetime_in'].toString()), json['vehicle_visitor_datetime_out'] == null ? null : parseDateTimeFormat(json['vehicle_visitor_datetime_out'].toString()), json['license_plate']?.toString(), json['car_detail']?.toString(), json['visitor_register_datetime'] == null ? null : parseDateTimeFormat(json['visitor_register_datetime'].toString()), json['province']?.toString(), json['vehicle_model']?.toString(), json['carbrandbrand_name']?.toString(), json['vehicle_visitor_status_id'], json['color']?.toString(), json['approve_status']?.toString(), json['villageproject_detail_id']);
  }

  @override
  EHPData getInstance() {
    return BrMbvisitorCarListModel04.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'vehicle_visitor_id': vehicle_visitor_id,
        'vehicle_id': vehicle_id,
        'vehicle_visitor_datetime_in': vehicle_visitor_datetime_in == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(vehicle_visitor_datetime_in!),
        'vehicle_visitor_datetime_out': vehicle_visitor_datetime_out == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(vehicle_visitor_datetime_out!),
        'license_plate': license_plate,
        'car_detail': car_detail,
        'visitor_register_datetime': visitor_register_datetime == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(visitor_register_datetime!),
        'province': province,
        'vehicle_model': vehicle_model,
        'carbrandbrand_name': carbrandbrand_name,
        'vehicle_visitor_status_id': vehicle_visitor_status_id,
        'color': color,
        'approve_status': approve_status,
        'villageproject_detail_id': villageproject_detail_id
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
      "license_plate",
      "car_detail",
      "visitor_register_datetime",
      "province",
      "vehicle_model",
      "carbrandbrand_name",
      "vehicle_visitor_status_id",
      "color",
      "approve_status",
      "villageproject_detail_id"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      2,
      4,
      4,
      6,
      6,
      4,
      6,
      6,
      6,
      2,
      6,
      6,
      2
    ];
  }
}
