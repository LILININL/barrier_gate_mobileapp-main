import 'package:intl/intl.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';

class RppDetail extends EHPData {
  int? inspection_id;
  int? officer_id;
  int? qr_location_id;
  DateTime? inspection_date;
  String? inspection_details;
  DateTime? inspection_update;
  int? qr_location_id_1;
  String? location_name;
  int? officer_id_1;
  String? officer_name;
  String? officer_lname;
  String? officer_fname;
  static RppDetail newInstance() {
    return RppDetail(
        null, null, null, null, null, null, null, null, null, null, null, null);
  }

  RppDetail(
      this.inspection_id,
      this.officer_id,
      this.qr_location_id,
      this.inspection_date,
      this.inspection_details,
      this.inspection_update,
      this.qr_location_id_1,
      this.location_name,
      this.officer_id_1,
      this.officer_name,
      this.officer_lname,
      this.officer_fname);
  @override
  RppDetail fromJson(Map<String, dynamic> json) {
    return RppDetail(
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
      json['location_name']?.toString(),
      json['officer_id_1'],
      json['officer_name']?.toString(),
      json['officer_lname']?.toString(),
      json['officer_fname']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return RppDetail.newInstance();
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
        'location_name': location_name,
        'officer_id_1': officer_id_1,
        'officer_name': officer_name,
        'officer_lname': officer_lname,
        'officer_fname': officer_fname,
      };
  @override
  String getTableName() {
    return '[preset]/18BR_RppInspectionLogDetail';
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
      "location_name",
      "officer_id_1",
      "officer_name",
      "officer_lname",
      "officer_fname"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 2, 2, 4, 6, 4, 2, 6, 2, 6, 6, 6];
  }
}
