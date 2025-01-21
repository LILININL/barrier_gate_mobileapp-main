import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/rpp/add_checkpion_list_view/controller/InspectionImage_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditSpactionDetailController extends GetxController {
  var editDetails = <EditSpactionDetail>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // ดึงข้อมูลสำหรับการแก้ไข
  Future<void> fetchEditSpactionDetails(String inspectionId) async {
    try {
      isLoading.value = true;
      final value = await serviceLocator<EHPApi>().getRestAPI(
        EditSpactionDetail.newInstance(),
        '?xinspection_id=$inspectionId:S',
      );

      // อัปเดตค่าที่ดึงมาได้
      editDetails.value = List<EditSpactionDetail>.from(
          value.map((e) => e as EditSpactionDetail));
    } catch (e) {
      print('Error fetching inspection details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // บันทึกใหม่
  Future<bool> saveEditSpactionDetail(EditSpactionDetail detail) async {
    try {
      isLoading.value = true;
      return await serviceLocator<EHPApi>()
          .postRestAPIData(detail, detail.getKeyFieldValue());
    } catch (e) {
      print('Error saving EditSpactionDetail: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ลบข้อมูล
  Future<bool> deleteEditSpactionDetail(EditSpactionDetail detail) async {
    try {
      isLoading.value = true;
      return await serviceLocator<EHPApi>().deleteRestAPI(detail);
    } catch (e) {
      print('Error deleting EditSpactionDetail: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

class EditSpactionDetailImageController extends GetxController {
  var editImages = <EditSpactionDetailImage>[].obs;
  RxString inspectionID = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> fetchEditSpactionDetailImages(String inspectionId) async {
    try {
      if (inspectionId.isNotEmpty) {
        final value = await serviceLocator<EHPApi>().getRestAPI(
          EditSpactionDetailImage.newInstance(),
          '?xinspection_id=${inspectionId}:S',
        );

        // แปลงข้อมูลที่ได้มาเป็น Uint8List
        editImages.value = List<EditSpactionDetailImage>.from(
            value.map((e) => e as EditSpactionDetailImage));
      }
    } catch (e) {
      print('Error fetching EditSpactionDetailImages: $e');
    }
  }

  Future<bool> saveEditSpactionDetailImage(
      EditSpactionDetailImage detailImage) async {
    try {
      return await serviceLocator<EHPApi>()
          .postRestAPIData(detailImage, detailImage.getKeyFieldValue());
    } catch (e) {
      print('Error saving EditSpactionDetailImage: $e');
      return false;
    }
  }

  Future<bool> deleteEditSpactionDetailImage(
      EditSpactionDetailImage detailImage) async {
    try {
      return await serviceLocator<EHPApi>().deleteRestAPI(detailImage);
    } catch (e) {
      print('Error deleting EditSpactionDetailImage: $e');
      return false;
    }
  }
}
