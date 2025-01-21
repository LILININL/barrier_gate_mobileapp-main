import 'dart:convert';
import 'package:barrier_gate/rpp/check_infomation_externalvehicleregistration/Controller/aotu_plate_medol.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';

class PlateController extends GetxController {
  var plateImage = ''.obs; // เก็บ Base64 ของรูปภาพที่ถ่าย
  var token = ''.obs; // เก็บ Token ที่ได้รับจาก API
  var autoPlate = AutoPlate().obs; // เก็บข้อมูลจาก Model AutoPlate

  Future<void> sendPlateImageWithToken() async {
    try {
      // เช็คค่าของ username และ password
      String username = dotenv.env['USERNAME'] ?? '';
      String password = dotenv.env['PASSWORD'] ?? '';

      print("Debug: Username = $username");
      print("Debug: Password = $password");

      if (username.isEmpty || password.isEmpty) {
        throw Exception("Username or Password is not set in .env");
      }

      // เช็คผลลัพธ์จากการขอ Token
      var tokenResponse = await _fetchToken(username, password);
      if (tokenResponse != null) {
        token.value = tokenResponse;
        print("Debug: Token fetched successfully = ${token.value}");
        await _sendPlateImage();
      } else {
        print("Error: Failed to fetch token.");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  // ฟังก์ชันขอ Token
  Future<String?> _fetchToken(String username, String password) async {
    var headers = {
      'Content-Type': 'application/json',
    };

    var request =
        http.Request('POST', Uri.parse('https://aiplate.bms.co.th/api/token'));

    request.body = json.encode({
      "username": username,
      "password": password,
    });

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Response status: ${response.statusCode}");
      print("Response body: $responseBody");

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);

        // แปลงข้อมูลที่ได้เป็นโมเดล TokenAutoPlate
        var tokenData = TokenAutoPlate(
          refresh: data['refresh'],
          access: data['access'],
        );

        // Debug ข้อมูลโมเดล
        print("Access Token: ${tokenData.access}");
        print("Refresh Token: ${tokenData.refresh}");

        return tokenData.access; // ส่งคืน Access Token
      } else {
        print(
            "Error: Failed to fetch token with status ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception while fetching token: $e");
      return null;
    }
  }

  // ฟังก์ชันส่ง Plate Image
  Future<void> _sendPlateImage() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token.value}',
    };

    var request = http.Request(
      'POST',
      Uri.parse('https://aiplate.bms.co.th/api/auto-plate'),
    );

    request.body = json.encode({"image_data_base64": plateImage.value});

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Response status: ${response.statusCode}");
      print("Response body: $responseBody");

      if (response.statusCode == 200) {
        // ตรวจสอบการแปลงข้อมูล JSON
        var parsedData = json.decode(responseBody);

        if (parsedData is Map<String, dynamic>) {
          print("Debug: Parsed Data -> $parsedData");

          // ส่ง parsedData เข้า AutoPlate.fromJson โดยตรง
          autoPlate.value = AutoPlate.fromJson(parsedData);

          print("Plate image sent successfully:");
          print("Number: ${autoPlate.value.number}");
          print("Province: ${autoPlate.value.province}");
        } else {
          print("Error: Response data is not a valid JSON object.");
        }
      } else {
        print("Error sending plate image: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception while sending plate image: $e");
    }
  }
}

class VehicleVisitorLogController extends GetxController {
  var vehicleVisitorLogs = <VehicleVisitorLog>[].obs;
  var isLoading = false.obs;

  Future<void> fetchVehicleVisitorLogs(String filter) async {
    try {
      isLoading.value = true;
      final value = await serviceLocator<EHPApi>().getRestAPI(
        VehicleVisitorLog.newInstance(),
        '?$filter&${VehicleVisitorLog.newInstance().getDefaultRestURIParam()}&\$limit=100',
      );
      vehicleVisitorLogs.value = List<VehicleVisitorLog>.from(
          value.map((e) => e as VehicleVisitorLog));
    } finally {
      isLoading.value = false;
    }
  }

  Future<VehicleVisitorLog> fetchVehicleVisitorLogByID(
      int vehicleVisitorLogID) async {
    isLoading.value = true;
    try {
      final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
          VehicleVisitorLog.newInstance(),
          'vehicle_visitor_log_id=$vehicleVisitorLogID');

      if ((dataCount ?? 0) > 0) {
        final vehicleVisitorLog = await serviceLocator<EHPApi>()
                .getRestAPISingleFirstObject(VehicleVisitorLog.newInstance(),
                    '?vehicle_visitor_log_id=$vehicleVisitorLogID')
            as VehicleVisitorLog;
        return vehicleVisitorLog;
      } else {
        return VehicleVisitorLog.newInstance()
          ..vehicle_visitor_log_id = vehicleVisitorLogID;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveVehicleVisitorLog(
      VehicleVisitorLog vehicleVisitorLogData) async {
    isLoading.value = true;
    try {
      final result = await serviceLocator<EHPApi>().postRestAPIData(
          vehicleVisitorLogData, vehicleVisitorLogData.getKeyFieldValue());
      if (result) {
        fetchVehicleVisitorLogs(''); // Refresh list after saving
      }
      return result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteVehicleVisitorLog(
      VehicleVisitorLog vehicleVisitorLogData) async {
    isLoading.value = true;
    try {
      final result =
          await serviceLocator<EHPApi>().deleteRestAPI(vehicleVisitorLogData);
      if (result) {
        vehicleVisitorLogs.removeWhere((item) =>
            item.vehicle_visitor_log_id ==
            vehicleVisitorLogData.vehicle_visitor_log_id);
      }
      return result;
    } finally {
      isLoading.value = false;
    }
  }
}
