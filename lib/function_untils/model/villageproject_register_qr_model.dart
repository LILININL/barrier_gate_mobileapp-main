import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class VillageprojectRegisterQr extends EHPData {
  int? villageproject_register_qr_id;
  Uint8List? qr_image;
  String? qr_is_use;
  DateTime? qr_use_datetime;
  DateTime? qr_generate_datetime;
  int? villageproject_detail_id;
  int? officer_id;
  String? uuid;
  String? qr_text;
  static VillageprojectRegisterQr newInstance() {
    return VillageprojectRegisterQr(null, null, null, null, null, null, null, null, null);
  }

  VillageprojectRegisterQr(this.villageproject_register_qr_id, this.qr_image, this.qr_is_use, this.qr_use_datetime, this.qr_generate_datetime, this.villageproject_detail_id, this.officer_id, this.uuid, this.qr_text);
  @override
  VillageprojectRegisterQr fromJson(Map<String, dynamic> json) {
    return VillageprojectRegisterQr(
      json['villageproject_register_qr_id'],
      json['qr_image'] == null ? null : base64.decode(json['qr_image'].toString()),
      json['qr_is_use']?.toString(),
      json['qr_use_datetime'] == null ? null : parseDateTimeFormat(json['qr_use_datetime'].toString()),
      json['qr_generate_datetime'] == null ? null : parseDateTimeFormat(json['qr_generate_datetime'].toString()),
      json['villageproject_detail_id'],
      json['officer_id'],
      json['uuid']?.toString(),
      json['qr_text']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return VillageprojectRegisterQr.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'villageproject_register_qr_id': villageproject_register_qr_id,
        'qr_image': qr_image == null ? null : base64.encode(qr_image!),
        'qr_is_use': qr_is_use,
        'qr_use_datetime': qr_use_datetime == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(qr_use_datetime!),
        'qr_generate_datetime': qr_generate_datetime == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(qr_generate_datetime!),
        'villageproject_detail_id': villageproject_detail_id,
        'officer_id': officer_id,
        'uuid': uuid,
        'qr_text': qr_text,
      };
  @override
  String getTableName() {
    return 'villageproject_register_qr';
  }

  @override
  String getKeyFieldName() {
    return 'villageproject_register_qr_id';
  }

  @override
  String getKeyFieldValue() {
    return villageproject_register_qr_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "villageproject_register_qr_id",
      "qr_image",
      "qr_is_use",
      "qr_use_datetime",
      "qr_generate_datetime",
      "villageproject_detail_id",
      "officer_id",
      "uuid",
      "qr_text"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      7,
      6,
      4,
      4,
      2,
      2,
      6,
      6
    ];
  }
}
