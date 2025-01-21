import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/controller/fireconfig.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../model/officer_model.dart';

class OfficerController extends GetxController {
  // สร้าง observable list สำหรับเก็บ Officer
  var officerList = <Officer>[].obs;
  var isLoading = false.obs;
  var emailErrorText = ''.obs;
  var fcmToken = ''.obs;

  // เมทอดสำหรับดึงข้อมูล Officer พร้อมเงื่อนไข filter
  Future<void> getOfficers(String filter) async {
    try {
      isLoading(true); // เริ่มโหลดข้อมูล
      final value = await serviceLocator<EHPApi>().getRestAPI(
        Officer.newInstance(),
        '?$filter&${Officer.newInstance().getDefaultRestURIParam()}&\$limit=100',
      );

      // อัปเดต observable list
      officerList.value = List<Officer>.from(value.map((e) => e as Officer));
    } catch (e) {
      print('Error fetching officers: $e');
    } finally {
      isLoading(false); // หยุดโหลดเมื่อเสร็จสิ้น
    }
  }

  Future<void> checkDuplicateEmail(String email) async {
    if (email.isEmpty) {
      emailErrorText.value = ''; // ล้างข้อความ error เมื่อช่องว่าง
      return;
    }

    try {
      final value = await serviceLocator<EHPApi>().getRestAPI(
        Officer.newInstance(),
        '?officer_email=$email&${Officer.newInstance().getDefaultRestURIParam()}&\$limit=1',
      );

      // หากพบอีเมลซ้ำ แสดงข้อความ error
      if (value.isNotEmpty) {
        emailErrorText.value = 'อีเมลนี้มีในระบบแล้ว';
      } else {
        emailErrorText.value = ''; // ล้าง error หากไม่มีอีเมลซ้ำ
      }
    } catch (e) {
      print('Error checking email: $e');
      emailErrorText.value = 'เกิดข้อผิดพลาดในการตรวจสอบอีเมล';
    }
  }

  Future<List<Officer>> getOfficersInstance(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
      Officer.newInstance(),
      '?$filter&${Officer.newInstance().getDefaultRestURIParam()}&\$limit=100',
    );

    return List<Officer>.from(value.map((e) => e as Officer));
  }

  static Future<List<Officer>> getLoginOfficer(
      String officer_login_name, officer_login_password_md5) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        Officer.newInstance(),
        '?officer_login_name=$officer_login_name&officer_login_password_md5=$officer_login_password_md5');
    return List<Officer>.from(value.map((e) => e as Officer));
  }

  static Future<bool> updatePassword(
      int officerID, String newPasswordMd5) async {
    Officer officer = await getOfficerFromID(officerID);

    officer.officer_login_password_md5 = newPasswordMd5;
    officer.officer_login_password = newPasswordMd5;

    final response = await serviceLocator<EHPApi>().postRestAPIData(
      officer,
      officerID.toString(),
    );

    return response;
  }

  static Future<bool> updatetokenPP(int officerID) async {
    Officer officer = await getOfficerFromID(officerID);

    officer.token_phone = FirebaseApi.fcmtoken;

    final response = await serviceLocator<EHPApi>().postRestAPIData(
      officer,
      officerID.toString(),
    );

    return response;
  }

  static Future<Officer> getOfficerFromID(int officerID) async {
    final dataCount = await serviceLocator<EHPApi>()
        .getRestAPIDataCount(Officer.newInstance(), 'officer_id=$officerID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
          Officer.newInstance(), '?officer_id=$officerID') as Officer;
    } else {
      return Officer.newInstance()..officer_id = officerID;
    }
  }

  Future<bool> getOfficerFromLoginname(String officerName) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
        Officer.newInstance(), 'officer_login_name=$officerName');

    if (dataCount! > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> saveNewOfficer(Officer officerData) async {
    return await serviceLocator<EHPApi>()
        .postRestAPIData(officerData, officerData.getKeyFieldValue());
  }

  static Future<bool> saveOfficer(Officer officerData) async {
    try {
      Officer? existingOfficer;

      try {
        existingOfficer = await getOfficerFromID(officerData.officer_id!);
      } catch (e) {
        print('No existing officer found, creating a new record.');
      }

      if (existingOfficer != null) {
        existingOfficer.officer_name =
            officerData.officer_name ?? existingOfficer.officer_name;
        existingOfficer.officer_group_list_text =
            officerData.officer_group_list_text ??
                existingOfficer.officer_group_list_text;
        existingOfficer.officer_login_name = officerData.officer_login_name ??
            existingOfficer.officer_login_name;
        existingOfficer.officer_login_password_md5 =
            officerData.officer_login_password_md5 ??
                existingOfficer.officer_login_password_md5;
        existingOfficer.officer_pname =
            officerData.officer_pname ?? existingOfficer.officer_pname;
        existingOfficer.officer_fname =
            officerData.officer_fname ?? existingOfficer.officer_fname;
        existingOfficer.officer_lname =
            officerData.officer_lname ?? existingOfficer.officer_lname;
        existingOfficer.officer_phone =
            officerData.officer_phone ?? existingOfficer.officer_phone;
        existingOfficer.officer_email =
            officerData.officer_email ?? existingOfficer.officer_email;
        existingOfficer.token_phone =
            officerData.token_phone ?? existingOfficer.token_phone;

        return await serviceLocator<EHPApi>().postRestAPIData(
            existingOfficer, existingOfficer.getKeyFieldValue());
      } else {
        // 4. ถ้าไม่มีข้อมูลเก่า ให้บันทึกข้อมูลใหม่ทั้งหมด
        return await serviceLocator<EHPApi>()
            .postRestAPIData(officerData, officerData.getKeyFieldValue());
      }
    } catch (e) {
      print('Error saving officer: $e');
      return false;
    }
  }

  static Future<bool> deleteOfficer(Officer officerData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(officerData);
  }

  void updateFCMToken(String token) {
    fcmToken.value = token;
  }

  // ฟังก์ชันสำหรับดึงค่า fcmToken
  String getFCMToken() {
    return FirebaseApi.fcmtoken;
  }
}
