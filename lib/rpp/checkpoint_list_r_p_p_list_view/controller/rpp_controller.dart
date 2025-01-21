import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/rpp/checkpoint_list_r_p_p_list_view/controller/rpp_model.dart';
import 'package:intl/intl.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';

import 'package:get/get.dart';

class RppDetailController extends GetxController {
  // รายการ RppDetail
  var rppDetails = <RppDetail>[].obs;
  String? villageprojectID = '';
  String? officerID = '';
  // สถานะการโหลด
  var isLoading = false.obs;
  getProjectVillage() async {
    villageprojectID = (await SharedPreferencesControllerCenter()
            .getString('villageproject_id')) ??
        '';
    officerID =
        (await SharedPreferencesControllerCenter().getString('officer_id')) ??
            '';
  }

  // ฟังก์ชันดึงรายการ RppDetail ด้วย filter
  Future<List<RppDetail>> fetchRppDetails(
      {required DateTime selectedDate}) async {
    try {
      await getProjectVillage();
      final formattedDate =
          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

      // ดึงข้อมูลจาก API หรือฐานข้อมูล
      final value = await serviceLocator<EHPApi>().getRestAPI(
        RppDetail.newInstance(),
        '?xvillageproject_id=$villageprojectID:S&xofficer_id=$officerID:S&xinspection_date=$formattedDate:S&\$gendartclass=1',
      );

      return List<RppDetail>.from(
        value.map((e) => e as RppDetail),
      );
    } catch (e) {
      print('Error fetching RppDetails: $e');
      return [];
    }
  }

  // ฟังก์ชันดึง RppDetail โดยใช้ ID
  Future<RppDetail?> fetchRppDetailFromID(int rppDetailID) async {
    try {
      isLoading.value = true; // เริ่มสถานะโหลด
      final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
        RppDetail.newInstance(),
        'table_name_id=$rppDetailID',
      );

      if ((dataCount ?? 0) > 0) {
        return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
          RppDetail.newInstance(),
          '?table_name_id=$rppDetailID',
        ) as RppDetail;
      } else {
        return RppDetail.newInstance()..inspection_id = rppDetailID;
      }
    } catch (e) {
      print('Error fetching RppDetail by ID: $e');
      return null;
    } finally {
      isLoading.value = false; // จบสถานะโหลด
    }
  }

  // ฟังก์ชันบันทึก RppDetail
  Future<bool> saveRppDetail(RppDetail rppDetailData) async {
    try {
      return await serviceLocator<EHPApi>().postRestAPIData(
        rppDetailData,
        rppDetailData.getKeyFieldValue(),
      );
    } catch (e) {
      print('Error saving RppDetail: $e');
      return false;
    }
  }

  // ฟังก์ชันลบ RppDetail
  Future<bool> deleteRppDetail(RppDetail rppDetailData) async {
    try {
      return await serviceLocator<EHPApi>().deleteRestAPI(rppDetailData);
    } catch (e) {
      print('Error deleting RppDetail: $e');
      return false;
    }
  }
}
