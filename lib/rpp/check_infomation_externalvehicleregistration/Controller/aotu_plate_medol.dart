import 'dart:convert';
import 'package:barrier_gate/flutter_flow/flutter_flow_util.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';

class AutoPlate {
  String? number;
  String? province;
  Debug? debug;

  AutoPlate({
    this.number,
    this.province,
    this.debug,
  });

  // รองรับ Map<String, dynamic> โดยตรง
  factory AutoPlate.fromJson(Map<String, dynamic> json) => AutoPlate(
        number: json["number"],
        province: json["province"],
        debug: json["debug"] == null ? null : Debug.fromMap(json["debug"]),
      );

  Map<String, dynamic> toMap() => {
        "number": number,
        "province": province,
        "debug": debug?.toMap(),
      };
}

class Debug {
  ProvinceTop5? provinceTop5;
  ProvinceBase64? provinceBase64;
  ProcessTime? processTime;

  Debug({
    this.provinceTop5,
    this.provinceBase64,
    this.processTime,
  });

  factory Debug.fromJson(String str) => Debug.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Debug.fromMap(Map<String, dynamic> json) => Debug(
        provinceTop5: json["province_top5"] == null
            ? null
            : ProvinceTop5.fromMap(json["province_top5"]),
        provinceBase64: json["province_base64"] == null
            ? null
            : ProvinceBase64.fromMap(json["province_base64"]),
        processTime: json["process_time"] == null
            ? null
            : ProcessTime.fromMap(json["process_time"]),
      );

  Map<String, dynamic> toMap() => {
        "province_top5": provinceTop5?.toMap(),
        "province_base64": provinceBase64?.toMap(),
        "process_time": processTime?.toMap(),
      };
}

class ProcessTime {
  int? plateLocation;
  int? plateDecode;

  ProcessTime({
    this.plateLocation,
    this.plateDecode,
  });

  factory ProcessTime.fromJson(String str) =>
      ProcessTime.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProcessTime.fromMap(Map<String, dynamic> json) => ProcessTime(
        plateLocation: json["plate_location"],
        plateDecode: json["plate_decode"],
      );

  Map<String, dynamic> toMap() => {
        "plate_location": plateLocation,
        "plate_decode": plateDecode,
      };
}

class ProvinceBase64 {
  String? nonfixOrientation;
  String? fixOrientation;

  ProvinceBase64({
    this.nonfixOrientation,
    this.fixOrientation,
  });

  factory ProvinceBase64.fromJson(String str) =>
      ProvinceBase64.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProvinceBase64.fromMap(Map<String, dynamic> json) => ProvinceBase64(
        nonfixOrientation: json["nonfix_orientation"],
        fixOrientation: json["fix_orientation"],
      );

  Map<String, dynamic> toMap() => {
        "nonfix_orientation": nonfixOrientation,
        "fix_orientation": fixOrientation,
      };
}

class ProvinceTop5 {
  List<List<dynamic>>? nonfixOrientation;
  List<List<dynamic>>? fixOrientation;

  ProvinceTop5({
    this.nonfixOrientation,
    this.fixOrientation,
  });

  factory ProvinceTop5.fromJson(String str) =>
      ProvinceTop5.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProvinceTop5.fromMap(Map<String, dynamic> json) => ProvinceTop5(
        nonfixOrientation: json["nonfix_orientation"] == null
            ? []
            : List<List<dynamic>>.from(json["nonfix_orientation"]!
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
        fixOrientation: json["fix_orientation"] == null
            ? []
            : List<List<dynamic>>.from(json["fix_orientation"]!
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toMap() => {
        "nonfix_orientation": nonfixOrientation == null
            ? []
            : List<dynamic>.from(nonfixOrientation!
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
        "fix_orientation": fixOrientation == null
            ? []
            : List<dynamic>.from(fixOrientation!
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class TokenAutoPlate {
  String? refresh;
  String? access;

  TokenAutoPlate({
    this.refresh,
    this.access,
  });

  factory TokenAutoPlate.fromJson(String str) =>
      TokenAutoPlate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TokenAutoPlate.fromMap(Map<String, dynamic> json) => TokenAutoPlate(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toMap() => {
        "refresh": refresh,
        "access": access,
      };
}

class VehicleVisitorLog extends EHPData {
  int? vehicle_visitor_log_id;
  int? addrpart;
  int? addr_soi;
  String? license_plate;
  String? province_code;
  String? full_name;
  String? id_card_number;
  DateTime? log_visit_datetime;
  static VehicleVisitorLog newInstance() {
    return VehicleVisitorLog(null, null, null, null, null, null, null, null);
  }

  VehicleVisitorLog(
      this.vehicle_visitor_log_id,
      this.addrpart,
      this.addr_soi,
      this.license_plate,
      this.province_code,
      this.full_name,
      this.id_card_number,
      this.log_visit_datetime);
  @override
  VehicleVisitorLog fromJson(Map<String, dynamic> json) {
    return VehicleVisitorLog(
      json['vehicle_visitor_log_id'],
      json['addrpart'],
      json['addr_soi'],
      json['license_plate']?.toString(),
      json['province_code']?.toString(),
      json['full_name']?.toString(),
      json['id_card_number']?.toString(),
      json['log_visit_datetime'] == null
          ? null
          : parseDateTimeFormat(json['log_visit_datetime'].toString()),
    );
  }

  @override
  EHPData getInstance() {
    return VehicleVisitorLog.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'vehicle_visitor_log_id': vehicle_visitor_log_id,
        'addrpart': addrpart,
        'addr_soi': addr_soi,
        'license_plate': license_plate,
        'province_code': province_code,
        'full_name': full_name,
        'id_card_number': id_card_number,
        'log_visit_datetime': log_visit_datetime == null
            ? null
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(log_visit_datetime!),
      };
  @override
  String getTableName() {
    return 'vehicle_visitor_log';
  }

  @override
  String getKeyFieldName() {
    return 'vehicle_visitor_log_id';
  }

  @override
  String getKeyFieldValue() {
    return vehicle_visitor_log_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "vehicle_visitor_log_id",
      "addrpart",
      "addr_soi",
      "license_plate",
      "province_code",
      "full_name",
      "id_card_number",
      "log_visit_datetime"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [2, 2, 2, 6, 6, 6, 6, 4];
  }
}
