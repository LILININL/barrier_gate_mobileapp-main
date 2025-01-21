import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/model/officer_picture_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class OfficerPictureController extends GetxController {
  var officerPictures = <OfficerPicture>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> getOfficerPictures(String filter) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      final value = await serviceLocator<EHPApi>().getRestAPI(
          OfficerPicture.newInstance(),
          '?$filter&${OfficerPicture.newInstance().getDefaultRestURIParam()}&\$limit=100');

      // Update observable list
      officerPictures.value =
          List<OfficerPicture>.from(value.map((e) => e as OfficerPicture));
    } catch (e) {
      errorMessage.value = 'Failed to fetch officer pictures';
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOfficerPicture(int officerID) async {
    try {
      isLoading(true);
      errorMessage('');

      final picture =
          await OfficerPictureController.getOfficerPictureFromID(officerID);

      if (picture.image != null) {
        officerPictures.assignAll([picture]);
      } else {
        errorMessage('No picture found');
      }
    } catch (e) {
      errorMessage('Error loading picture: $e');
    } finally {
      isLoading(false);
    }
  }
  // static Future<OfficerPicture> getOfficerPictureFromID(int officerPictureID) async {
  //   final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(OfficerPicture.newInstance(), 'officer_picture_id=$officerPictureID');

  //   if ((dataCount ?? 0) > 0) {
  //     return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(OfficerPicture.newInstance(), '?officer_picture_id=$officerPictureID') as OfficerPicture;
  //   } else {
  //     return OfficerPicture.newInstance()..officer_picture_id = officerPictureID;
  //   }
  // }

  static Future<OfficerPicture> getOfficerPictureFromID(int officerID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
        OfficerPicture.newInstance(), 'officer_id=$officerID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
              OfficerPicture.newInstance(), '?officer_id=$officerID')
          as OfficerPicture;
    } else {
      return OfficerPicture.newInstance()..officer_id = officerID;
    }
  }

  static Future<bool> saveOfficerPicture(
      OfficerPicture officerPictureData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(
        officerPictureData, officerPictureData.getKeyFieldValue());
  }

  static Future<bool> deleteOfficerPicture(
      OfficerPicture officerPictureData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(officerPictureData);
  }

  Future<void> uploadOfficerPicture(Uint8List imageBytes) async {
    final officerId = await Get.find<SharedPreferencesControllerCenter>()
        .getString('officer_id');

    if (officerId != null && officerId.isNotEmpty) {
      int officerPictureId;

      if (officerPictures.isNotEmpty &&
          officerPictures.first.officer_picture_id != null) {
        officerPictureId = officerPictures.first.officer_picture_id!;
      } else {
        officerPictureId = await serviceLocator<EHPApi>().getSerialNumber(
            'officer_picture_id', 'officer_picture', 'officer_picture_id');
      }

      final officerPicture = OfficerPicture.newInstance()
        ..officer_picture_id = officerPictureId
        ..image = imageBytes
        ..image_update = DateTime.now()
        ..officer_id = int.parse(officerId);

      try {
        final response = await serviceLocator<EHPApi>().postRestAPIData(
          officerPicture,
          officerPicture.officer_id.toString(),
        );

        if (response) {
          officerPictures.add(officerPicture);
        }
      } catch (e) {
        errorMessage('Upload Error: $e');
      }
    } else {
      errorMessage('Officer ID is missing or invalid');
    }
  }
}
