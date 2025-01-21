import 'dart:io';

import 'package:barrier_gate/flutter_flow/flutter_flow_util.dart';
import 'package:ehp_api/ehp_endpoint/ehp_api.dart';
import 'package:ehp_api/ehp_endpoint/ehp_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image/image.dart' as image;

import 'package:crypto/crypto.dart';
import 'package:ehp_api/dio/response.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

import 'dart:developer' as dev;

class GetData {
  static String MD5(String input) {
    var md5En = md5.convert(utf8.encode(input)).toString().toLowerCase();
    return md5En;
  }

  static String SHA256(String input) {
    var SHA256En = sha256.convert(utf8.encode(input + 'royalthaipolice4.0!@#\$%')).toString().toLowerCase();
    return SHA256En;
  }

  Future<Map<String, dynamic>> DeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    return deviceInfo.data;
  }

  Future<bool> getAPIStatus() async {
    try {
      final DioResponse statusResponse = await serviceLocator<EHPApi>().dioClient.get(
            '/Status',
            authHeader: '',
          );
      if (statusResponse.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printError(info: "error : ${e.toString()}");
      return false;
    }
  }

  Future<DateTime> getDateTimeServer(String formate) async {
    final DioResponse statusResponse = await serviceLocator<EHPApi>().dioClient.get(
          '/Status',
          authHeader: '',
        );
    var tempDate = DateTime.now();
    if (EHPApi.checkResponseIsValid(statusResponse)) {
      DateTime resDT = DateTime.parse(statusResponse.data['RequestTime']);
      var dtChange = DateFormat(formate).format(resDT);
      tempDate = DateTime.parse(dtChange);
    }
    return tempDate;
  }

  Future<DateTime> getDateServer() async {
    final DioResponse statusResponse = await serviceLocator<EHPApi>().dioClient.get(
          '/Status',
          authHeader: '',
        );
    var tempDate = DateTime.now();
    if (EHPApi.checkResponseIsValid(statusResponse)) {
      DateTime resDT = DateTime.parse(statusResponse.data['RequestTime']);
      var dtChange = DateFormat("yyyy-MM-dd").format(resDT);
      tempDate = DateTime.parse(dtChange);
    }
    return tempDate;
  }

  Future<Duration> getTimeServer() async {
    final DioResponse statusResponse = await serviceLocator<EHPApi>().dioClient.get(
          '/Status',
          authHeader: '',
        );
    Duration? tempDate;
    if (EHPApi.checkResponseIsValid(statusResponse)) {
      DateTime resDT = DateTime.parse(statusResponse.data['RequestTime']);
      var dtChange = DateFormat("HH:mm:ss").format(resDT);
      tempDate = durationParse(dtChange); // dura(dtChange);//DurationDateTime.parse(dtChange);
    }
    return tempDate!;
  }

  Future<DateTime> getDateTimeServer2() async {
    final DioResponse statusResponse = await serviceLocator<EHPApi>().dioClient.get(
          '/Status',
          authHeader: '',
        );
    var tempDate = DateTime.now();
    if (EHPApi.checkResponseIsValid(statusResponse)) {
      DateTime resDT = DateTime.parse(statusResponse.data['RequestTime']);
      var dtChange = DateFormat("yyyy-MM-dd HH:mm:ss").format(resDT);
      tempDate = DateTime.parse(dtChange);
    }
    return tempDate;
  }

  static String formatThaiDateMMMM(DateTime? date) {
    if (date == null) {
      return '';
    }
    return '${DateFormat('dd').format(date ?? DateTime.now())} ${DateFormat('MMMM', 'th').format(date ?? DateTime.now())} ${int.tryParse(DateFormat('yyyy').format(date ?? DateTime.now()))! + 543}';
  }
}
