import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';
import 'package:barrier_gate/function_untils/model/vehicle_model.dart';
import 'package:barrier_gate/rpp/visitorcarregistration/model/ResidentVistorLog_json.dart';
import 'package:barrier_gate/rpp/visitorcarregistration/model/villageproject_detail_model.dart';
import 'package:get/get.dart';

class VillageprojectDetailController extends GetxController {
  var villageprojectDetailListData = <VillageprojectDetail>[].obs;
  var filteredVillageDetails = <VillageprojectDetail>[].obs;
  var isLoading = false.obs;

  Future<void> fetchVillageprojectDetails(String villageprojectID) async {
    try {
      isLoading.value = true;
      final value = await serviceLocator<EHPApi>().getRestAPI(
          VillageprojectDetail.newInstance(),
          '?xvillageproject_id=$villageprojectID:S&\$limit=100');

      villageprojectDetailListData.value = List<VillageprojectDetail>.from(
          value.map((e) => e as VillageprojectDetail));

      // กำหนดค่าข้อมูลที่กรอง = ข้อมูลทั้งหมด เมื่อโหลดสำเร็จ
      filteredVillageDetails.value = villageprojectDetailListData;
    } catch (e) {
      print('Error fetching village project details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchVillageDetails(String query) {
    if (query.isEmpty) {
      filteredVillageDetails.value = villageprojectDetailListData;
    } else {
      filteredVillageDetails.value = villageprojectDetailListData
          .where((detail) =>
              detail.house_number!.contains(query) ||
              detail.soi!.contains(query))
          .toList();
    }
  }

  static Future<VillageprojectDetail> getVillageprojectDetailFromID(
      int villageprojectDetailID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
        VillageprojectDetail.newInstance(),
        'villageproject_detail_id=$villageprojectDetailID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
              VillageprojectDetail.newInstance(),
              '?villageproject_detail_id=$villageprojectDetailID')
          as VillageprojectDetail;
    } else {
      return VillageprojectDetail.newInstance()
        ..villageproject_detail_id = villageprojectDetailID;
    }
  }

  static Future<bool> saveVillageprojectDetail(
      VillageprojectDetail villageprojectDetailData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(
        villageprojectDetailData, villageprojectDetailData.getKeyFieldValue());
  }

  static Future<bool> deleteVillageprojectDetail(
      VillageprojectDetail villageprojectDetailData) async {
    return await serviceLocator<EHPApi>()
        .deleteRestAPI(villageprojectDetailData);
  }
}

class ResidentVistorLogController extends GetxController {
  // ใช้ Map ในการเก็บข้อมูล โดยใช้ villageproject_detail_id เป็น key
  final residentLogsMap = <int, List<ResidentVistorLog>>{}.obs;
  final isLoading = false.obs;

  // ดึงข้อมูลและจัดเก็บใน Map
  Future<void> fetchResidentVistorLogs(int villageprojectDetailID) async {
    try {
      isLoading.value = true;
      print(
          "Fetching logs for villageprojectDetailID: $villageprojectDetailID");

      final rawData = await serviceLocator<EHPApi>().getRestAPI(
        ResidentVistorLog.newInstance(),
        '?villageprojectDetailID1=$villageprojectDetailID:S&villageprojectDetailID2=$villageprojectDetailID:S',
      );

      // แปลงข้อมูลเป็น ResidentVistorLog และเก็บลงใน Map
      final logs = List<ResidentVistorLog>.from(
        rawData.map((e) => e as ResidentVistorLog),
      );

      residentLogsMap[villageprojectDetailID] = logs;

      print("Logs fetched for $villageprojectDetailID: ${logs.length}");
    } catch (e) {
      print("Error fetching resident visitor logs: $e");
    } finally {
      isLoading.value = false;
      print("isLoading set to false");
    }
  }
}

class DetailController extends GetxController {
  var selectedAddrest = ''.obs;
  var selectedAddrSoi = ''.obs;
  var villageproject_resident_id = ''.obs;
  var villageproject_detail_id = ''.obs;

  void setDetails(
    String addrest,
    String addrSoi,
    String? villageprojectResidentId,
    String? villageproject_detail_id,
  ) {
    selectedAddrest.value = addrest;
    selectedAddrSoi.value = addrSoi;
    this.villageproject_detail_id.value = villageproject_detail_id!;
    villageproject_resident_id.value = villageprojectResidentId!;
  }
}

class IDCardController extends GetxController {
  var fullName = ''.obs;
  var idNumber = ''.obs;

  void updateIDCardInfo(String name, String id) {
    fullName.value = name;
    idNumber.value = id.replaceAll(' ', '');
  }
}

class VehicleController {
  static Future<List<Vehicle>> getVehicles(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        Vehicle.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${Vehicle.newInstance().getDefaultRestURIParam()}&\$limit=100');

    return List<Vehicle>.from(value.map((e) => e as Vehicle));
  }

  static Future<Vehicle> getVehicleFromID(int vehicleID) async {
    final dataCount = await serviceLocator<EHPApi>()
        .getRestAPIDataCount(Vehicle.newInstance(), 'vehicle_id=$vehicleID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
          Vehicle.newInstance(), '?vehicle_id=$vehicleID') as Vehicle;
    } else {
      return Vehicle.newInstance()..vehicle_id = vehicleID;
    }
  }

  static Future<bool> saveVehicle(Vehicle vehicleData) async {
    return await serviceLocator<EHPApi>()
        .postRestAPIData(vehicleData, vehicleData.getKeyFieldValue());
  }

  static Future<bool> deleteVehicle(Vehicle vehicleData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(vehicleData);
  }
}
