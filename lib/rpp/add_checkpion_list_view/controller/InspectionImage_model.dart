import 'dart:convert';

import 'package:barrier_gate/flutter_flow/flutter_flow_util.dart';
import 'package:intl/intl.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';

class VillageInspectionImage extends EHPData {
  int? image_id;
  int? inspection_id;
  Uint8List? image_blob;
  DateTime? uploaded_at;
  static VillageInspectionImage newInstance() {
    return VillageInspectionImage(null, null, null, null);
  }

  VillageInspectionImage(
      this.image_id, this.inspection_id, this.image_blob, this.uploaded_at);
  @override
  VillageInspectionImage fromJson(Map<String, dynamic> json) {
    return VillageInspectionImage(
      json['image_id'],
      json['inspection_id'],
      json['image_blob'] == null
          ? null
          : base64.decode(json['image_blob'].toString()),
      json['uploaded_at'] == null
          ? null
          : parseDateTimeFormat(json['uploaded_at'].toString()),
    );
  }

  @override
  EHPData getInstance() {
    return VillageInspectionImage.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'image_id': image_id,
        'inspection_id': inspection_id,
        'image_blob': image_blob == null ? null : base64.encode(image_blob!),
        'uploaded_at': uploaded_at == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(uploaded_at!),
      };
  @override
  String getTableName() {
    return 'village_inspection_image';
  }

  @override
  String getKeyFieldName() {
    return 'image_id';
  }

  @override
  String getKeyFieldValue() {
    return image_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return ["image_id", "inspection_id", "image_blob", "uploaded_at"];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 2, 7, 4];
  }
}

class VillageInspectionLogs extends EHPData {
  int? inspection_id;
  int? officer_id;
  int? qr_location_id;
  DateTime? inspection_date;
  String? inspection_details;
  DateTime? inspection_update;
  static VillageInspectionLogs newInstance() {
    return VillageInspectionLogs(null, null, null, null, null, null);
  }

  VillageInspectionLogs(
      this.inspection_id,
      this.officer_id,
      this.qr_location_id,
      this.inspection_date,
      this.inspection_details,
      this.inspection_update);
  @override
  VillageInspectionLogs fromJson(Map<String, dynamic> json) {
    return VillageInspectionLogs(
      json['inspection_id'],
      json['officer_id'],
      json['qr_location_id'],
      json['inspection_date'] == null
          ? null
          : parseDateTimeFormat(json['inspection_date'].toString()),
      json['inspection_details']?.toString(),
      json['inspection_update'] == null
          ? null
          : parseDateTimeFormat(json['inspection_update'].toString()),
    );
  }

  @override
  EHPData getInstance() {
    return VillageInspectionLogs.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'inspection_id': inspection_id,
        'officer_id': officer_id,
        'qr_location_id': qr_location_id,
        'inspection_date': inspection_date == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(inspection_date!),
        'inspection_details': inspection_details,
        'inspection_update': inspection_update == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(inspection_update!),
      };
  @override
  String getTableName() {
    return 'village_inspection_logs';
  }

  @override
  String getKeyFieldName() {
    return 'inspection_id';
  }

  @override
  String getKeyFieldValue() {
    return inspection_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "inspection_id",
      "officer_id",
      "qr_location_id",
      "inspection_date",
      "inspection_details",
      "inspection_update"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 2, 2, 4, 6, 4];
  }
}

class EditSpactionDetail extends EHPData {
  int? inspection_id;
  int? officer_id;
  int? qr_location_id;
  DateTime? inspection_date;
  String? inspection_details;
  DateTime? inspection_update;
  int? qr_location_id_1;
  int? villageproject_id;
  String? qr_token;
  String? location_name;
  double? latitude;
  double? longitude;
  DateTime? created_at;
  DateTime? updated_at;
  Uint8List? qr_image;
  String? officer_name;
  int? officer_id_1;
  String? officer_fname;
  String? officer_lname;
  String? officer_pname;
  static EditSpactionDetail newInstance() {
    return EditSpactionDetail(null, null, null, null, null, null, null, null,
        null, null, null, null, null, null, null, null, null, null, null, null);
  }

  EditSpactionDetail(
      this.inspection_id,
      this.officer_id,
      this.qr_location_id,
      this.inspection_date,
      this.inspection_details,
      this.inspection_update,
      this.qr_location_id_1,
      this.villageproject_id,
      this.qr_token,
      this.location_name,
      this.latitude,
      this.longitude,
      this.created_at,
      this.updated_at,
      this.qr_image,
      this.officer_name,
      this.officer_id_1,
      this.officer_fname,
      this.officer_lname,
      this.officer_pname);
  @override
  EditSpactionDetail fromJson(Map<String, dynamic> json) {
    return EditSpactionDetail(
      json['inspection_id'],
      json['officer_id'],
      json['qr_location_id'],
      json['inspection_date'] == null
          ? null
          : parseDateTimeFormat(json['inspection_date'].toString()),
      json['inspection_details']?.toString(),
      json['inspection_update'] == null
          ? null
          : parseDateTimeFormat(json['inspection_update'].toString()),
      json['qr_location_id_1'],
      json['villageproject_id'],
      json['qr_token']?.toString(),
      json['location_name']?.toString(),
      json['latitude'] == null
          ? null
          : double.tryParse(json['latitude'].toString()),
      json['longitude'] == null
          ? null
          : double.tryParse(json['longitude'].toString()),
      json['created_at'] == null
          ? null
          : parseDateTimeFormat(json['created_at'].toString()),
      json['updated_at'] == null
          ? null
          : parseDateTimeFormat(json['updated_at'].toString()),
      json['qr_image'] == null
          ? null
          : base64.decode(json['qr_image'].toString()),
      json['officer_name']?.toString(),
      json['officer_id_1'],
      json['officer_fname']?.toString(),
      json['officer_lname']?.toString(),
      json['officer_pname']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return EditSpactionDetail.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'inspection_id': inspection_id,
        'officer_id': officer_id,
        'qr_location_id': qr_location_id,
        'inspection_date': inspection_date == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(inspection_date!),
        'inspection_details': inspection_details,
        'inspection_update': inspection_update == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(inspection_update!),
        'qr_location_id_1': qr_location_id_1,
        'villageproject_id': villageproject_id,
        'qr_token': qr_token,
        'location_name': location_name,
        'latitude': latitude,
        'longitude': longitude,
        'created_at': created_at == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(created_at!),
        'updated_at': updated_at == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(updated_at!),
        'qr_image': qr_image == null ? null : base64.encode(qr_image!),
        'officer_name': officer_name,
        'officer_id_1': officer_id_1,
        'officer_fname': officer_fname,
        'officer_lname': officer_lname,
        'officer_pname': officer_pname,
      };
  @override
  String getTableName() {
    return '[preset]/20BR_RppInspectionLogDetailList';
  }

  @override
  String getKeyFieldName() {
    return 'table_name_id';
  }

  @override
  String getKeyFieldValue() {
    return inspection_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "inspection_id",
      "officer_id",
      "qr_location_id",
      "inspection_date",
      "inspection_details",
      "inspection_update",
      "qr_location_id_1",
      "villageproject_id",
      "qr_token",
      "location_name",
      "latitude",
      "longitude",
      "created_at",
      "updated_at",
      "qr_image",
      "officer_name",
      "officer_id_1",
      "officer_fname",
      "officer_lname",
      "officer_pname"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 2, 2, 4, 6, 4, 2, 2, 6, 6, 3, 3, 4, 4, 7, 6, 2, 6, 6, 6];
  }
}

class EditSpactionDetailImage extends EHPData {
  Uint8List? image_blob;
  int? inspection_id;
  static EditSpactionDetailImage newInstance() {
    return EditSpactionDetailImage(null, null);
  }

  EditSpactionDetailImage(this.image_blob, this.inspection_id);
  @override
  EditSpactionDetailImage fromJson(Map<String, dynamic> json) {
    return EditSpactionDetailImage(
      json['image_blob'] == null
          ? null
          : base64.decode(json['image_blob'].toString()),
      json['inspection_id'],
    );
  }

  @override
  EHPData getInstance() {
    return EditSpactionDetailImage.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'image_blob': image_blob == null ? null : base64.encode(image_blob!),
        'inspection_id': inspection_id,
      };
  @override
  String getTableName() {
    return '[preset]/19BR_RppInspectionLogDetailImage';
  }

  @override
  String getKeyFieldName() {
    return 'table_name_id';
  }

  @override
  String getKeyFieldValue() {
    return inspection_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return ["image_blob", "inspection_id"];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [7, 2];
  }
}
