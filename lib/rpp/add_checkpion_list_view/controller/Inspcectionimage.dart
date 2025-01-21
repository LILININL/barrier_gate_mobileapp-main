import 'dart:io';
import 'dart:typed_data';

import 'package:barrier_gate/rpp/add_checkpion_list_view/controller/InspectionImage_model.dart';
import 'package:intl/intl.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class VillageInspectionImageController extends GetxController {
  Future<bool> saveVillageInspectionImage(
      VillageInspectionImage villageInspectionImageData) async {
    try {
      final result = await serviceLocator<EHPApi>().postRestAPIData(
          villageInspectionImageData,
          villageInspectionImageData.getKeyFieldValue());

      if (result) {
        // อัปเดตหรือเรียก refresh data ถ้าจำเป็น
        print('บันทึกข้อมูลสำเร็จ');
      } else {
        print('การบันทึกข้อมูลล้มเหลว');
      }

      return result;
    } catch (e) {
      print('เกิดข้อผิดพลาดระหว่างการบันทึกข้อมูล: $e');
      return false;
    }
  }

  static Future<VillageInspectionImage> getVillageInspectionImageFromID(
      int villageInspectionImageID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
        VillageInspectionImage.newInstance(),
        'image_id=$villageInspectionImageID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
          VillageInspectionImage.newInstance(),
          '?image_id=$villageInspectionImageID') as VillageInspectionImage;
    } else {
      return VillageInspectionImage.newInstance()
        ..image_id = villageInspectionImageID;
    }
  }

  static Future<bool> deleteVillageInspectionImage(
      VillageInspectionImage villageInspectionImageData) async {
    return await serviceLocator<EHPApi>()
        .deleteRestAPI(villageInspectionImageData);
  }
}

class VillageInspectionLogsController extends GetxController {
  final isLoading = false.obs; // สถานะการโหลดข้อมูล
  final villageInspectionLogsList =
      <VillageInspectionLogs>[].obs; // เก็บรายการข้อมูล

  // ดึงรายการ VillageInspectionLogs
  Future<void> getVillageInspectionLogs() async {
    try {
      isLoading.value = true;
      final value = await serviceLocator<EHPApi>().getRestAPI(
        VillageInspectionLogs.newInstance(),
        '?\$orderby=inspection_id desc&${VillageInspectionLogs.newInstance().getDefaultRestURIParam()}&\$limit=1',
      );

      villageInspectionLogsList.assignAll(
        List<VillageInspectionLogs>.from(
          value.map((e) => e as VillageInspectionLogs),
        ),
      );
    } catch (e) {
      print('Error fetching VillageInspectionLogs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateVillageInspectionLogs(
      VillageInspectionLogs villageInspectionLogsData) async {
    try {
      final result = await serviceLocator<EHPApi>().postRestAPIData(
        villageInspectionLogsData,
        villageInspectionLogsData.getKeyFieldValue(),
      );
      if (result) {
        print('Update successful');
      }
      return result;
    } catch (e) {
      print('Error updating VillageInspectionLogs: $e');
      return false;
    }
  }

  Future<List<File>> getImagesByInspectionId(int inspectionId) async {
    try {
      final value = await serviceLocator<EHPApi>().getRestAPI(
        VillageInspectionImage.newInstance(),
        '?inspection_id=$inspectionId',
      );

      // แปลงผลลัพธ์เป็นรายการไฟล์
      final images = value
          .map((e) async {
            final image = e as VillageInspectionImage; // แปลงเป็นโมเดล
            final imageData = image.image_blob; // ดึงข้อมูล blob
            if (imageData == null) return null;

            final tempDir = await getTemporaryDirectory();
            final filePath = '${tempDir.path}/image_$inspectionId.png';
            final file = File(filePath)..writeAsBytesSync(imageData);
            return file;
          })
          .whereType<File>()
          .toList();

      return images;
    } catch (e) {
      print('Error fetching images by inspection_id: $e');
      return [];
    }
  }

  // ดึงข้อมูล VillageInspectionLogs จาก ID
  Future<VillageInspectionLogs?> getVillageInspectionLogsFromID(
      int villageInspectionLogsID) async {
    try {
      final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
        VillageInspectionLogs.newInstance(),
        'inspection_id=$villageInspectionLogsID',
      );

      if ((dataCount ?? 0) > 0) {
        return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
          VillageInspectionLogs.newInstance(),
          '?inspection_id=$villageInspectionLogsID',
        ) as VillageInspectionLogs;
      } else {
        return VillageInspectionLogs.newInstance()
          ..inspection_id = villageInspectionLogsID;
      }
    } catch (e) {
      print('Error fetching VillageInspectionLogs by ID: $e');
      return null;
    }
  }

  static Future<int> getLatestInspectionId() async {
    try {
      final result = await serviceLocator<EHPApi>().getRestAPI(
        VillageInspectionLogs.newInstance(),
        '\$orderby=inspection_id desc&\$limit=1',
      );

      if (result.isNotEmpty) {
        final inspectionLog = result.first as VillageInspectionLogs;
        return inspectionLog.inspection_id ?? 0;
      }

      return 0; // ถ้าไม่มีข้อมูล คืนค่าเริ่มต้น
    } catch (e) {
      print('Error fetching latest inspection_id: $e');
      return 0; // เกิดข้อผิดพลาด
    }
  }

  // บันทึกข้อมูล VillageInspectionLogs
  static Future<VillageInspectionLogs?> saveVillageInspectionLogs(
      VillageInspectionLogs villageInspectionLogsData) async {
    try {
      // บันทึกข้อมูล
      final result = await serviceLocator<EHPApi>().postRestAPIData(
        villageInspectionLogsData,
        villageInspectionLogsData.getKeyFieldValue(),
      );

      if (result) {
        // ดึงข้อมูลล่าสุดหลังจากบันทึก
        final updatedLogs =
            await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
          VillageInspectionLogs.newInstance(),
          'qr_location_id=${villageInspectionLogsData.qr_location_id}&\$orderby=uploaded_at desc',
        ) as VillageInspectionLogs;

        return updatedLogs;
      }
      return null;
    } catch (e) {
      print('Error saving VillageInspectionLogs: $e');
      return null;
    }
  }

  // ลบข้อมูล VillageInspectionLogs
  Future<bool> deleteVillageInspectionLogs(
      VillageInspectionLogs villageInspectionLogsData) async {
    try {
      isLoading.value = true;
      final result = await serviceLocator<EHPApi>().deleteRestAPI(
        villageInspectionLogsData,
      );
      if (result) {
        villageInspectionLogsList.remove(villageInspectionLogsData);
        print('Delete successful');
      } else {
        print('Delete failed');
      }
      return result;
    } catch (e) {
      print('Error deleting VillageInspectionLogs: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
