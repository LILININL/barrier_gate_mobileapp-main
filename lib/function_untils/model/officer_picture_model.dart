import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class OfficerPicture extends EHPData {
  int? officer_picture_id;
  Uint8List? image;
  DateTime? image_update;
  int? officer_id;
  static OfficerPicture newInstance() {
    return OfficerPicture(null, null, null, null);
  }

  OfficerPicture(this.officer_picture_id, this.image, this.image_update, this.officer_id);
  @override
  OfficerPicture fromJson(Map<String, dynamic> json) {
    return OfficerPicture(
      json['officer_picture_id'],
      json['image'] == null ? null : base64.decode(json['image'].toString()),
      json['image_update'] == null ? null : parseDateTimeFormat(json['image_update'].toString()),
      json['officer_id'],
    );
  }

  @override
  EHPData getInstance() {
    return OfficerPicture.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'officer_picture_id': officer_picture_id,
        'image': image == null ? null : base64.encode(image!),
        'image_update': image_update == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(image_update!),
        'officer_id': officer_id,
      };
  @override
  String getTableName() {
    return 'officer_picture';
  }

  @override
  String getKeyFieldName() {
    return 'officer_picture_id';
  }

  @override
  String getKeyFieldValue() {
    return officer_picture_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "officer_picture_id",
      "image",
      "image_update",
      "officer_id"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      7,
      4,
      2
    ];
  }
}
