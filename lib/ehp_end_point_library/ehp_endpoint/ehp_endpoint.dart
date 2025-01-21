import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'dart:ui';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ehp_api/ehp_endpoint/ehp_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:uuid/uuid.dart';
import 'package:event_bus/event_bus.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:json_editor/json_editor.dart';

import 'ehp_api.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as sqlite;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

EventBus eventBus = EventBus();

class Endpoints {
  Endpoints._();

// base url
//static String baseUrl = "https://ehp.hosxp.net/phapi";
//static String baseUrl = "http://bgs.dyndns.tv/care_vision/phapi";
//static String baseUrl = "https://wg3.bgscloud.in.th/99999/phapi";
//static String baseUrl = "http://192.168.21.164:27778/hosapi";
//static String baseUrl = "https://bgslife.hosxp.net/bgsoffice_api/phapi";

  // static String baseUrl = "http://localhost:7062/phapi";
  // static String baseUrl =
  //     "https://software.developer.bmscloud.in.th/barrier_api/phapi";

  static String baseUrl = "https://venussentinel.bgs.co.th/api/phapi";

  // static String baseUrl =
  //     "https://software.developer.bgscloud.in.th/village_uat/phapi";
  // static String baseUrl = "http://bgs.dyndns.tv/barrier_api/phapi";
  // static String lineAPIUrl = "https://notify-api.line.me/api/notify";

  // receiveTimeout
  static const int receiveTimeout = 60000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String tokenPath = '/Token';
  static const String encryptPath = '/Encrypt';
  static const String dataPath = '/Data';
  static const String restAPIPath = '/RestAPI';

  static const String apiSystemCode = 'EHP-CLIENT-1';
  static const String apiKeyCode = 'FFFFFFFFFFFFFFFFFFFF';

  static String apiJWT = '';
  static String apiSessionToken = '';
  static String apiUserJWT = '';

  static String apiIDPJWT = '';

  static String houseInRegionRegistTypeIDlist = '1,3';

  static int dbVillageMooZeroID = 0;

  static Map<String, dynamic> apiIDPJWTPayload = {};
  static Map<String, dynamic> apiUserJWTPayload = {};

  static bool apiTokenInitOK = false;

  static const String mqttHostUrl = 'wss://rbr1.hosxp.net:15676/ws';
  static const String mqttUser = 'bms';
  static const String mqttPassword = 'bms';

  static const String mophBaseUrl = "https://cvp1.moph.go.th";
  // need to configured before use
  static String mophAccountUser = '';
  static String mophAccountHospitalCode = '';
  static String mophAccountPassword = '';

  static String mophAPIJWT = '';

  // firebase api key
  static String FCMAPIKey = '';

  static const String idpBaseUrl = 'https://phr1.moph.go.th/idp/api';

  static const String phrBaseUrl = 'https://phr1.moph.go.th/api';

  static bool errorDialogVisible = false;

  static String getHospitalCode() => EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];
}

class EHPMobile {
  static int appStartTick = (DateTime.now().millisecondsSinceEpoch ~/ 1000);
  static String clientIP = '';
  static String hospitalCode = '';
  static String hospitalName = '';

  static String loginName = '';
  static String userName = '';
  static int? bmsUserID;
  static String bmsUserName = '';
  static int? employeeID;
  static String employeeFullName = '';
  static int? empPositionID;
  static String empPositionName = '';

  static String hospitalProvinceName = '';
  static String hospitalDistrictName = '';
  static String hospitalTambolName = '';
  static String hospitalAddressCode = '';
  static String onlineID = getNewGUID();

  static String fcmToken = '';

  static bool videoCallBusy = false;

  static bool? BPStatus;

  static AppLifecycleState? appLifecycleState;

  static BuildContext? lastContext;

  static String deviceModel = '';

  static int idleSecond = 0;

  static String clientlocalName = 'EHP-Mobile';
  static String currentLocationName = '-';
  static String currentLocationNameFine = '-';

  static String expectedPONGFrom = '';
  static bool expectedPONGReceived = false;

  static bool forceCheckMOPHPersonnelOnNewRegister = true;

  // static Future<void> Function()? loginInitFunction;  not use use await login instead
  static Future<void> Function()? onOTPPinOKCallBack;

  static StreamSubscription? videoCallMQTTSubscription;
  static late GetStorage prefs;
  static String currentAddress = '';
  static Position? currentLocationPosition;

  static bool canOpenChatPage = false;
  static bool canOpenVideoCallDirectory = false;
}

class VideoCallerInfo {
  final String name;
  final String organizationCode;
  final String organizationName;
  final String callReason;
  final String callChannel;
  final String callerID;
  final DateTime callerDateTime;
  String? callerData;

  VideoCallerInfo(this.name, this.organizationCode, this.organizationName, this.callReason, this.callChannel, this.callerID, this.callerDateTime);

  Map<String, dynamic> toJson() => {
        'name': name,
        'organization_code': organizationCode,
        'organization_name': organizationName,
        'call_reason': callReason,
        'call_channel': callChannel,
        'caller_id': callerID,
        'caller_datetime_tick': (callerDateTime.toUtc().millisecondsSinceEpoch / 1000).round()
      };
}

class MQTTChatEvent {
  final dynamic payload;
  MQTTChatEvent(this.payload);
}

class UserEKYCCompleteEvent {}

class IoTMessageEvent {
  String event_id;
  int person_vt_type_id;
  String? system_name;
  String hospital_code;
  String cid;
  DateTime? acquired_datetime;
  String? device_manufacturer;
  String? device_model;
  String? device_serial_no;
  String value_text;
  double? value_decimal;

  IoTMessageEvent(this.event_id, this.person_vt_type_id, this.system_name, this.hospital_code, this.cid, this.acquired_datetime, this.device_manufacturer, this.device_model, this.device_serial_no, this.value_text, this.value_decimal);

  static IoTMessageEvent fromJson(Map<String, dynamic> json) {
    return IoTMessageEvent(
      json['event_id']?.toString() ?? '',
      json['person_vt_type_id'] ?? 0,
      json['system_name']?.toString() ?? '',
      json['hospital_code']?.toString() ?? '',
      json['cid']?.toString() ?? '',
      json['acquired_datetime'] == null ? null : parseDateTimeFormat(json['acquired_datetime'].toString()),
      json['device_manufacturer']?.toString() ?? '',
      json['device_model']?.toString() ?? '',
      json['device_serial_no']?.toString() ?? '',
      json['value_text']?.toString() ?? '',
      double.tryParse('${json['value_decimal']}'),
    );
  }
}

class NewVideoCallIncomingEvent {
  VideoCallerInfo callInfo;
  NewVideoCallIncomingEvent(this.callInfo);
}

class AcceptVideoCallIncomingEvent {
  VideoCallerInfo callInfo;
  AcceptVideoCallIncomingEvent(this.callInfo);
}

String addZero(String input, int length) {
  String s = input;
  while (s.length < length) {
    s = '0$s';
  }
  return s;
}

String getNewGUID() {
  return '{${Uuid().v4()}}'.toUpperCase();
}

bool xcheckPID(String cid) {
  final cidStr = cid.replaceAll(new RegExp(r'[^0-9]'), '');
  if (cidStr.length == 13) {
    return true;
  }

  return false;
}

Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
      CREATE TABLE person_vt_test_result (
        person_vt_test_result_id INTEGER PRIMARY KEY,
        cid TEXT,
        person_vt_datetime TEXT,
        person_vt_location_type_id INTEGER,
        person_vt_type_id INTEGER,
        person_vt_test_result_decimal REAL,
        person_vt_test_result_text TEXT,
        officer_cid TEXT,
        person_vt_note TEXT,
        device_manufacturer TEXT,
        device_model TEXT,
        device_serial_no TEXT,
        location_latitude TEXT,
        location_longitude TEXT,
        ref_value1 REAL,
        ref_value2 REAL,
        ref_value3 REAL,
        eval_text TEXT,
        location_address TEXT
      )
    ''');
}

bool checkPID(String cid) {
  if (cid.length != 13) return false;
  var sum = 0;
  for (var i = 0; i < 12; i++) {
    sum += int.parse(cid[i]) * (13 - i);
  }
  var mod = sum % 11;
  var checkDigit = 11 - mod;
  if (checkDigit >= 10) checkDigit = checkDigit - 10;
  if (int.parse(cid[12]) != checkDigit) return false;
  return true;
}

String sortUser(String user1, String user2) {
  List<Map<String, dynamic>> user = [
    {
      'name': user1
    },
    {
      'name': user2
    }
  ];
  user.sort((a, b) {
    return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
  });

  return (user[0]['name'] ?? '') + ':' + (user[1]['name'] ?? '');
}

Future<void> initPlatformData() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var deviceData = <String, dynamic>{};

  try {
    if (kIsWeb) {
      deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
    } else {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      } else if (Platform.isLinux) {
        deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
      } else if (Platform.isMacOS) {
        deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
      } else if (Platform.isWindows) {
        deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
      }
    }

    debugPrint('deviceData = $deviceData');
  } on PlatformException {
    deviceData = <String, dynamic>{
      'Error:': 'Failed to get platform version.'
    };
  }
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  EHPMobile.deviceModel = '${build.manufacturer} ${build.model} (${build.version.release}) - ${build.version.incremental}';

  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
    'displaySizeInches': ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
    'displayWidthPixels': build.displayMetrics.widthPx,
    'displayWidthInches': build.displayMetrics.widthInches,
    'displayHeightPixels': build.displayMetrics.heightPx,
    'displayHeightInches': build.displayMetrics.heightInches,
    'displayXDpi': build.displayMetrics.xDpi,
    'displayYDpi': build.displayMetrics.yDpi,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  EHPMobile.deviceModel = '${data.utsname.nodename} ${data.systemVersion}';

  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'version': data.version,
    'id': data.id,
    'idLike': data.idLike,
    'versionCodename': data.versionCodename,
    'versionId': data.versionId,
    'prettyName': data.prettyName,
    'buildId': data.buildId,
    'variant': data.variant,
    'variantId': data.variantId,
    'machineId': data.machineId,
  };
}

Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  EHPMobile.deviceModel = '${data.vendor} ${data.browserName} ${data.appVersion} ';

  return <String, dynamic>{
    'browserName': describeEnum(data.browserName),
    'appCodeName': data.appCodeName,
    'appName': data.appName,
    'appVersion': data.appVersion,
    'deviceMemory': data.deviceMemory,
    'language': data.language,
    'languages': data.languages,
    'platform': data.platform,
    'product': data.product,
    'productSub': data.productSub,
    'userAgent': data.userAgent,
    'vendor': data.vendor,
    'vendorSub': data.vendorSub,
    'hardwareConcurrency': data.hardwareConcurrency,
    'maxTouchPoints': data.maxTouchPoints,
  };
}

Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return <String, dynamic>{
    'computerName': data.computerName,
    'hostName': data.hostName,
    'arch': data.arch,
    'model': data.model,
    'kernelVersion': data.kernelVersion,
    'osRelease': data.osRelease,
    'activeCPUs': data.activeCPUs,
    'memorySize': data.memorySize,
    'cpuFrequency': data.cpuFrequency,
    'systemGUID': data.systemGUID,
  };
}

Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'numberOfCores': data.numberOfCores,
    'computerName': data.computerName,
    'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    'userName': data.userName,
    'majorVersion': data.majorVersion,
    'minorVersion': data.minorVersion,
    'buildNumber': data.buildNumber,
    'platformId': data.platformId,
    'csdVersion': data.csdVersion,
    'servicePackMajor': data.servicePackMajor,
    'servicePackMinor': data.servicePackMinor,
    'suitMask': data.suitMask,
    'productType': data.productType,
    'reserved': data.reserved,
    'buildLab': data.buildLab,
    'buildLabEx': data.buildLabEx,
    'digitalProductId': data.digitalProductId,
    'displayVersion': data.displayVersion,
    'editionId': data.editionId,
    'installDate': data.installDate,
    'productId': data.productId,
    'productName': data.productName,
    'registeredOwner': data.registeredOwner,
    'releaseId': data.releaseId,
    'deviceId': data.deviceId,
  };
}

Future waitWhile(bool test(), [int maxMSWait = 2000]) {
  var completer = Completer();
  final stopwatch = Stopwatch()..start();
  check() {
    if (test() || (stopwatch.elapsedMilliseconds > maxMSWait)) {
      completer.complete();
    } else {
      Timer(Duration.zero, check);
    }
  }

  check();
  return completer.future;
}

// Future<String> checkVisitType(String xTime, String chkhol) async {
//   String vt = "";

// var cc = await getSQLCount('holiday', 'holiday_date=${getCurrentDateStr()}') == 0;

// print('cc : ${cc}');

// if (chkhol == "Use" && cc != "0") {
//   vt = await fGetSQLData("select visit_type from visit_type where visit_type_name like '%นอกเวลา%'");
// } else {
//   rtc.getData("select * from visit_type");
//   while (!rtc.eof()) {
//     var record = rtc.fieldByName("time_range_begin");
//     String tBegin = record["time_range_begin"];s
//     String tEnd = record["time_range_end"];

//     if (checkTime(tBegin, tEnd, xTime)) {
//       vt = record["visit_type"];
//       break;
//     }

//     rtc.next();
//   }
//   rtc.free();
// }
//   return cc.toString();
// }

int getAgeYear(DateTime dateOfBirth) {
  try {
    var currentDate = DateTime.now();
    int ageInYears = currentDate.year - dateOfBirth.year;
    int ageInMonths = currentDate.month - dateOfBirth.month;
    if (currentDate.month < dateOfBirth.month || (currentDate.month == dateOfBirth.month && currentDate.day < dateOfBirth.day)) {
      ageInYears--;
    }
    if (currentDate.month < dateOfBirth.month) {
      ageInMonths += 12;
    }
    return ageInYears;
  } catch (e) {
    return 0;
  }
}

String getAgeString(DateTime dateOfBirth) {
  try {
    var currentDate = DateTime.now();
    int ageInYears = currentDate.year - dateOfBirth.year;
    int ageInMonths = currentDate.month - dateOfBirth.month;
    if (currentDate.month < dateOfBirth.month || (currentDate.month == dateOfBirth.month && currentDate.day < dateOfBirth.day)) {
      ageInYears--;
    }
    if (currentDate.month < dateOfBirth.month) {
      ageInMonths += 12;
    }
    return "$ageInYears ปี, $ageInMonths เดือน";
  } catch (e) {
    return '';
  }
}

String getDatePassedString(DateTime refDate) {
  var sReturn = '';

  try {
    var currentDate = DateTime.now();
    int ageInYears = currentDate.year - refDate.year;
    int ageInMonths = currentDate.month - refDate.month;
    if (currentDate.month < refDate.month || (currentDate.month == refDate.month && currentDate.day < refDate.day)) {
      ageInYears--;
    }
    if (currentDate.month < refDate.month) {
      ageInMonths += 12;
    }

    if (ageInYears > 0) {
      sReturn = '$ageInYears ปี';
    }

    if (ageInMonths > 0) {
      sReturn = '$sReturn, $ageInMonths เดือน';
    }

    if ((ageInYears + ageInMonths) == 0) {
      sReturn = '${refDate.difference(currentDate).inDays} วัน';
    }

    return sReturn;
  } catch (e) {
    return '';
  }
}

DateTime? parseDateFormat(String dateString) {
  try {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  } catch (e) {
    debugPrint('parseDateFormat $dateString error $e');
  }
}

DateTime? parseDateTimeFormat(String dateString) {
  try {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateString);
  } catch (e) {
    debugPrint('parseDateTimeFormat $dateString error $e');
  }
}

String replaceAllSpaceToSingleSpace(String spaceString) {
  return spaceString.replaceAllMapped(RegExp(r'\s+'), (m) => ' ');
}

String getAssetImageNameForPerson(DateTime birthDate, String sex) {
  final ageY = getAgeYear(birthDate);

  if (ageY <= 1) {
    return 'assets/images/icon/person_baby_256px.png';
  } else if (ageY <= 18) {
    switch (sex) {
      case '1':
        return 'assets/images/icon/person_male_boy_256px.png';
      default:
        return 'assets/images/icon/person_male_girl_256px.png';
    }
  } else if (ageY <= 60) {
    switch (sex) {
      case '1':
        return 'assets/images/icon/person_male_adult_256px.png';
      default:
        return 'assets/images/icon/person_female_adult_256px.png';
    }
  } else {
    switch (sex) {
      case '1':
        return 'assets/images/icon/person_male_old_256px.png';
      default:
        return 'assets/images/icon/person_female_old_256px.png';
    }
  }

  return 'assets/images/icon/person_unknown_256px.png';
}

// Custom Encrypt / Decrypt

final key = enc.Key.fromUtf8('#B@ngkokGlob@l#1Software!#!12024'); //32 chars
final iv = enc.IV.fromUtf8('#B@ngkokGlob@l#1'); //16 chars

//encrypt
String encryptMyData(String text) {
  final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final encrypted_data = e.encrypt(text, iv: iv);
  return encrypted_data.base64;
}

//dycrypt
String decryptMyData(String text) {
  final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final decrypted_data = e.decrypt(enc.Encrypted.fromBase64(text), iv: iv);
  return decrypted_data;
}

void printFormatJSON(String json) {
  final x = JsonEditor.string(
    jsonString: json,
    onValueChanged: (value) {
      logFull(value.toPrettyString());
    },
  );
}

Future<void> showErrorDialog(String errorMessage) async {
  //await EHPApi.showErrorDialog(errorMessage);

  await Get.defaultDialog(title: "Error", middleText: errorMessage, backgroundColor: Colors.white, titleStyle: TextStyle(color: Colors.red.shade700), middleTextStyle: TextStyle(color: Colors.indigo), radius: 10);
}

void exitApplication() {
  FlutterExitApp.exitApp(iosForceExit: true);
}

String formatThaiDateFull(DateTime? date) {
  if (date == null) {
    return '';
  }
  return DateFormat.yMMMMEEEEd().formatInBuddhistCalendarThai(date ?? DateTime.now());
}

String formatThaiDateShort1(DateTime? date) {
  DateTime getTime = DateTime.now();

  if (date == null) {
    return '';
  }

  return '${DateFormat.d().formatInBuddhistCalendarThai(date ?? DateTime.now())} ${DateFormat.MMMM('th').formatInBuddhistCalendarThai(date ?? DateTime.now())} ${int.tryParse(DateFormat('yyyy').format(date ?? DateTime.now()))! + 543}';
}

String formatThaiDateShort2(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat('dd').format(date ?? DateTime.now())}-${DateFormat('MM').format(date ?? DateTime.now())}-${int.tryParse(DateFormat('yyyy').format(date ?? DateTime.now()))! + 543}';
}

String formatThaiDateShort4(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat('dd').format(date ?? DateTime.now())}/${DateFormat('MM').format(date ?? DateTime.now())}/${int.tryParse(DateFormat('yyyy').format(date ?? DateTime.now()))! + 543}';
}

String formatThaiDateShort5(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${int.tryParse(DateFormat('yyyy').format(date ?? DateTime.now()))! + 543}';
}

String formatThaiDateTime(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat('dd').format(date)}/${DateFormat('MM').format(date)}/${int.tryParse(DateFormat('yyyy').format(date))! + 543} ${DateFormat('HH:mm').format(date)} น.';
}

String formatThaiDateShort3(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat.d().formatInBuddhistCalendarThai(date ?? DateTime.now())} ${DateFormat.MMM('th').formatInBuddhistCalendarThai(date ?? DateTime.now())} ${int.tryParse(DateFormat('yyyy').format(date ?? DateTime.now()))! + 543}';
}

String formatThaiMonthShort(DateTime? date) {
  if (date == null) {
    return '';
  }

  // แสดงเฉพาะเดือนและปีในพุทธศักราช (Buddhist year)
  return '${DateFormat.MMMM('th').formatInBuddhistCalendarThai(date)} ${int.tryParse(DateFormat('yyyy').format(date))! + 543}';
}

String getCurrentDate() {
  final date = DateTime.now();

  return '${DateFormat.d().formatInBuddhistCalendarThai(date ?? DateTime.now())} ${DateFormat.MMM('th').formatInBuddhistCalendarThai(date ?? DateTime.now())} ${int.tryParse(DateFormat('yyyy').format(date ?? DateTime.now()))! + 543}';
}

String pttypeNo(String xCid) {
  List<String> cidChar = xCid.split('');
  String strPtNo = '${cidChar[0]}-${cidChar[1]}${cidChar[2]}${cidChar[3]}${cidChar[4]}-'
      '${cidChar[5]}${cidChar[6]}${cidChar[7]}${cidChar[8]}${cidChar[9]}-'
      '${cidChar[10]}${cidChar[11]}-${cidChar[12]}';

  return strPtNo;
}

String convertDateString2(String date) {
  List<String> parts = date.split("-");
  String year = parts[0];
  String month = parts[1];
  String day = parts[2];
  String yth = year + month + day;

  return yth;
}

// Future<String> GetCheckVisitType() async {
//   return await getSQLData('visit_type', 'visit_type', '${getCurrentTimeStrEHP()}>=time_range_begin&${getCurrentTimeStrEHP()}>=time_range_end');
// }

String getCurrentDateStr() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

String getCurrentTimeStr() {
  return DateFormat('HH:mm:ss').format(DateTime.now());
}

String getCurrentDateStrEHP() {
  return DateFormat('yyyy.MM.dd').format(DateTime.now());
}

String getCurrentTimeStrEHP() {
  return DateFormat('HH.mm.ss').format(DateTime.now());
}

String formatThaiTime(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat('HH:mm:ss').format(date ?? DateTime.now())}';
}

String formatThaiTime2(String format, DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat(format).format(date ?? DateTime.now())}';
}

String formatThaiTimeWithDurationHM(Duration? time) {
  if (time == null) {
    return '';
  }

  return '${(time.inHours.toString().padLeft(2, '0'))}:${(time.inMinutes.remainder(60).toString().padLeft(2, '0'))}';
}

String getENCurrentDate(String xToday) {
  // Split the input date string into year, month, and day
  List<String> dateParts = xToday.split("-");
  String year = dateParts[0];
  String month = dateParts[1];
  String day = dateParts[2];

  // Extract the last two digits of the year
  String yth = year.substring(2) + month + day;

  return yth;
}

String getThaiCurrentDate(String xToday) {
  // Split the input date string into year, month, and day
  List<String> dateParts = xToday.split("-");
  String year = dateParts[0];
  String month = dateParts[1];
  String day = dateParts[2];

  // Convert the year to the Thai calendar year
  int thYear = int.parse(year) + 543;
  // Format the Thai year as a string
  String thYearStr = thYear.toString();

  // Combine the Thai year, month, and day into the desired format
  String yth = "${thYearStr.substring(2)}$month$day";

  return yth;
}

// class DropDownStaff extends StatelessWidget {
//   DropDownStaff({
//     super.key,
//     required this.selectItem,
//     required this.onChangeds,
//     required this.checkErrorIcon,
//     this.validators,
//     this.textHint,
//     this.hintColor,
//     this.SetColor,
//   });

//   String? textHint;
//   Color? hintColor;
//   Color? SetColor;
//   final Person? selectItem;
//   final bool checkErrorIcon;
//   String? Function(Person?)? validators;
//   void Function(Person?)? onChangeds;

//   // String chwID, ampID;
//   @override
//   Widget build(BuildContext context) {
//     textHint == null ? textHint = 'กรุณาเลือก' : null;
//     hintColor == null ? hintColor = FlutterFlowTheme.of(context).secondaryText : null;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child: DropdownSearch<Person>(
//         dropDownButton: Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: FlutterFlowTheme.of(context).secondaryText,
//           size: 24.0,
//         ),
//         showAsSuffixIcons: true,
//         isFilteredOnline: false,
//         showClearButton: false,
//         showSearchBox: true,
//         dropdownBuilderSupportsNullItem: true,
//         selectedItem: selectItem,
//         validator: validators,
//         dropdownSearchDecoration: InputDecoration(
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: FlutterFlowTheme.of(context).accent3,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: FlutterFlowTheme.of(context).tertiary,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           errorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: checkErrorIcon ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).accent3,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           focusedErrorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: checkErrorIcon ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).tertiary,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           prefixIconConstraints: BoxConstraints(),
//           prefixIcon: checkErrorIcon
//               ? Icon(
//                   Icons.warning_rounded,
//                   color: Colors.red,
//                   size: 20.0,
//                 )
//               : null,
//           hintText: textHint,
//           hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
//                 fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                 color: checkErrorIcon ? FlutterFlowTheme.of(context).error : hintColor,
//                 fontWeight: FontWeight.w200,
//                 useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//               ),
//         ),
//         onFind: (filter) => PersonController.getPersons('fname[Like]%$filter%'),
//         itemAsString: (item) => '${item?.pname}${item?.fname} ${item?.lname}' ?? '',
//         compareFn: (i, s) => (i?.person_id ?? '') == (s?.person_id ?? ''),
//         maxHeight: MediaQuery.of(context).size.height * 0.5,
//         dropdownBuilder: (context, selectedItem) => selectedItem != null
//             ? Text(
//                 '${selectedItem?.pname}${selectedItem?.fname} ${selectedItem?.lname}' ?? '',
//                 maxLines: 1,
//                 overflow: TextOverflow.visible,
//                 style: FlutterFlowTheme.of(context).bodyMedium.override(
//                       fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                       fontWeight: FontWeight.w300,
//                       color: SetColor,
//                       useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                     ),
//               )
//             : Text(''),
//         popupShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(0.0),
//             bottomRight: Radius.circular(0.0),
//             topLeft: Radius.circular(16.0),
//             topRight: Radius.circular(16.0),
//           ),
//         ),
//         popupTitle: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
//                     child: Container(
//                       width: 80.0,
//                       height: 8.0,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'กรุณาเลือก เจ้าหน้าที่',
//                     style: FlutterFlowTheme.of(context).bodyLarge.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
//                           color: FlutterFlowTheme.of(context).primaryText,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
//                         ),
//                   ),
//                   SizedBox(height: 4.0),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 0,
//               right: 5,
//               child: TextButton(
//                   onPressed: () async {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'ยกเลิก',
//                     style: FlutterFlowTheme.of(context).bodyMedium.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                           color: FlutterFlowTheme.of(context).error,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                         ),
//                   ),
//                   style: ButtonStyle(
//                     overlayColor: MaterialStateProperty.all((FlutterFlowTheme.of(context).error).withOpacity(.1)),
//                   )),
//             )
//           ],
//         ),
//         searchFieldProps: TextFieldProps(
//             cursorColor: FlutterFlowTheme.of(context).tertiary,
//             padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
//             style: FlutterFlowTheme.of(context).bodyLarge.override(
//                   fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
//                   color: FlutterFlowTheme.of(context).primaryText,
//                   fontWeight: FontWeight.w300,
//                   useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
//                 ),
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.grey[300],
//               hintText: 'ค้นหา',
//               contentPadding: EdgeInsets.symmetric(vertical: 0),
//               hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
//                     fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
//                     color: FlutterFlowTheme.of(context).secondaryText,
//                     fontWeight: FontWeight.w100,
//                     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodySmallFamily),
//                     lineHeight: 1.0,
//                   ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               prefixIcon: Icon(
//                 Icons.search_rounded,
//                 color: FlutterFlowTheme.of(context).primary,
//                 size: 24.0,
//               ),
//             )),
//         popupItemBuilder: (context, item, isSelected) => Column(
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//                   child: Text(
//                     '${item.pname}${item.fname} ${item.lname}' ?? '',
//                     style: FlutterFlowTheme.of(context).bodyMedium.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 color: Colors.grey[300],
//                 height: 1,
//               ),
//             ),
//           ],
//         ),
//         loadingBuilder: (context, searchEntry) {
//           return Center(
//             child: Lottie.asset(
//               'assets/lottie_animations/loading.json',
//               width: 100.0,
//               height: 100.0,
//               fit: BoxFit.cover,
//               animate: true,
//             ),
//           );
//         },
//         mode: Mode.BOTTOM_SHEET,
//         onChanged: onChangeds,
//       ),
//     );
//   }
// }

// Future<String> checkVisitType(String xTime, String chkhol) async {
//   String vt = '';

//   vt = await getSQLData('visit_type', 'visit_type', '');

//   return vt
//
//
//
//
//
//
//
//
// ;
// }

// class DropDownClinic extends StatelessWidget {
//   DropDownClinic({
//     super.key,
//     required this.selectItem,
//     required this.onChangeds,
//     required this.checkErrorIcon,
//     this.validators,
//     this.textHint,
//     this.hintColor,
//     this.SetColor,
//   });

//   String? textHint;
//   Color? hintColor;
//   Color? SetColor;
//   final Clinic? selectItem;
//   final bool checkErrorIcon;
//   String? Function(Clinic?)? validators;
//   void Function(Clinic?)? onChangeds;

//   // String chwID, ampID;

//   @override
//   Widget build(BuildContext context) {
//     textHint == null ? textHint = 'กรุณาเลือก' : null;
//     hintColor == null ? hintColor = FlutterFlowTheme.of(context).secondaryText : null;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child: DropdownSearch<Clinic>(
//         dropDownButton: Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: FlutterFlowTheme.of(context).accent3,
//           size: 20.0,
//         ),
//         showAsSuffixIcons: true,
//         isFilteredOnline: false,
//         showClearButton: false,
//         showSearchBox: true,
//         dropdownBuilderSupportsNullItem: true,
//         selectedItem: selectItem,
//         validator: validators,
//         dropdownSearchDecoration: InputDecoration(
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: FlutterFlowTheme.of(context).accent3,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: FlutterFlowTheme.of(context).tertiary,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           errorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: checkErrorIcon ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).accent3,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           focusedErrorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: checkErrorIcon ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).tertiary,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           prefixIconConstraints: BoxConstraints(),
//           prefixIcon: checkErrorIcon
//               ? Icon(
//                   Icons.warning_rounded,
//                   color: Colors.red,
//                   size: 20.0,
//                 )
//               : null,
//           hintText: textHint,
//           hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
//                 fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                 color: checkErrorIcon ? FlutterFlowTheme.of(context).error : hintColor,
//                 fontWeight: FontWeight.w200,
//                 useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//               ),
//         ),
//         onFind: (filter) => ClinicController.getClinics2('pp_special_service_place_type_name[Like]%$filter%'),
//         itemAsString: (item) => item?.name ?? '',
//         compareFn: (i, s) => (i?.clinic ?? '') == (s?.clinic ?? ''),
//         maxHeight: MediaQuery.of(context).size.height * 0.5,
//         dropdownBuilder: (context, selectedItem) => selectedItem != null
//             ? Text(
//                 selectedItem.name ?? '',
//                 maxLines: 1,
//                 overflow: TextOverflow.visible,
//                 style: FlutterFlowTheme.of(context).bodyMedium.override(
//                       fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                       fontWeight: FontWeight.w300,
//                       color: SetColor,
//                       useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                     ),
//               )
//             : Text(''),
//         popupShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(0.0),
//             bottomRight: Radius.circular(0.0),
//             topLeft: Radius.circular(16.0),
//             topRight: Radius.circular(16.0),
//           ),
//         ),
//         popupTitle: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
//                     child: Container(
//                       width: 80.0,
//                       height: 8.0,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'กรุณาเลือก สถานที่',
//                     style: FlutterFlowTheme.of(context).bodyLarge.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
//                           color: FlutterFlowTheme.of(context).primaryText,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
//                         ),
//                   ),
//                   SizedBox(height: 4.0),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 0,
//               right: 5,
//               child: TextButton(
//                   onPressed: () async {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'ยกเลิก',
//                     style: FlutterFlowTheme.of(context).bodyMedium.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                           color: FlutterFlowTheme.of(context).error,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                         ),
//                   ),
//                   style: ButtonStyle(
//                     overlayColor: MaterialStateProperty.all((FlutterFlowTheme.of(context).error).withOpacity(.1)),
//                   )),
//             )
//           ],
//         ),
//         searchFieldProps: TextFieldProps(
//             cursorColor: FlutterFlowTheme.of(context).tertiary,
//             padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
//             style: FlutterFlowTheme.of(context).bodyLarge.override(
//                   fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
//                   color: FlutterFlowTheme.of(context).primaryText,
//                   fontWeight: FontWeight.w300,
//                   useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
//                 ),
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.grey[300],
//               hintText: 'ค้นหา',
//               contentPadding: EdgeInsets.symmetric(vertical: 0),
//               hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
//                     fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
//                     color: FlutterFlowTheme.of(context).secondaryText,
//                     fontWeight: FontWeight.w100,
//                     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodySmallFamily),
//                     lineHeight: 1.0,
//                   ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               prefixIcon: Icon(
//                 Icons.search_rounded,
//                 color: FlutterFlowTheme.of(context).primary,
//                 size: 24.0,
//               ),
//             )),
//         popupItemBuilder: (context, item, isSelected) => Column(
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//                   child: Text(
//                     item.name ?? '',
//                     style: FlutterFlowTheme.of(context).bodyMedium.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 color: Colors.grey[300],
//                 height: 1,
//               ),
//             ),
//           ],
//         ),
//         loadingBuilder: (context, searchEntry) {
//           return Center(
//             child: Lottie.asset(
//               'assets/lottie_animations/loading.json',
//               width: 100.0,
//               height: 100.0,
//               fit: BoxFit.cover,
//               animate: true,
//             ),
//           );
//         },
//         mode: Mode.BOTTOM_SHEET,
//         onChanged: onChangeds,
//       ),
//     );
//   }
// }

// class DropDownPlace extends StatelessWidget {
//   DropDownPlace({
//     super.key,
//     required this.selectItem,
//     required this.onChangeds,
//     required this.checkErrorIcon,
//     this.validators,
//     this.textHint,
//     this.hintColor,
//     this.SetColor,
//   });

//   String? textHint;
//   Color? hintColor;
//   Color? SetColor;
//   final PpSpecialServicePlaceType? selectItem;
//   final bool checkErrorIcon;
//   String? Function(PpSpecialServicePlaceType?)? validators;
//   void Function(PpSpecialServicePlaceType?)? onChangeds;

//   // String chwID, ampID;

//   @override
//   Widget build(BuildContext context) {
//     textHint == null ? textHint = 'กรุณาเลือก' : null;
//     hintColor == null ? hintColor = FlutterFlowTheme.of(context).secondaryText : null;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child: DropdownSearch<PpSpecialServicePlaceType>(
//         dropDownButton: Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: FlutterFlowTheme.of(context).accent3,
//           size: 20.0,
//         ),
//         showAsSuffixIcons: true,
//         isFilteredOnline: false,
//         showClearButton: false,
//         showSearchBox: true,
//         dropdownBuilderSupportsNullItem: true,
//         selectedItem: selectItem,
//         validator: validators,
//         dropdownSearchDecoration: InputDecoration(
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: FlutterFlowTheme.of(context).accent3,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: FlutterFlowTheme.of(context).tertiary,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           errorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: checkErrorIcon ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).accent3,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           focusedErrorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: checkErrorIcon ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).tertiary,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           prefixIconConstraints: BoxConstraints(),
//           prefixIcon: checkErrorIcon
//               ? Icon(
//                   Icons.warning_rounded,
//                   color: Colors.red,
//                   size: 20.0,
//                 )
//               : null,
//           hintText: textHint,
//           hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
//                 fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                 color: checkErrorIcon ? FlutterFlowTheme.of(context).error : hintColor,
//                 fontWeight: FontWeight.w200,
//                 useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//               ),
//         ),
//         onFind: (filter) => PpSpecialServicePlaceTypeController.getPpSpecialServicePlaceTypes('pp_special_service_place_type_name[Like]%$filter%'),
//         itemAsString: (item) => item?.pp_special_service_place_type_name ?? '',
//         compareFn: (i, s) => (i?.pp_special_service_place_type_id ?? '') == (s?.pp_special_service_place_type_id ?? ''),
//         maxHeight: MediaQuery.of(context).size.height * 0.5,
//         dropdownBuilder: (context, selectedItem) => selectedItem != null
//             ? Text(
//                 selectedItem.pp_special_service_place_type_name ?? '',
//                 maxLines: 1,
//                 overflow: TextOverflow.visible,
//                 style: FlutterFlowTheme.of(context).bodyMedium.override(
//                       fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                       fontWeight: FontWeight.w300,
//                       color: SetColor,
//                       useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                     ),
//               )
//             : Text(''),
//         popupShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(0.0),
//             bottomRight: Radius.circular(0.0),
//             topLeft: Radius.circular(16.0),
//             topRight: Radius.circular(16.0),
//           ),
//         ),
//         popupTitle: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
//                     child: Container(
//                       width: 80.0,
//                       height: 8.0,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'กรุณาเลือก สถานที่',
//                     style: FlutterFlowTheme.of(context).bodyLarge.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
//                           color: FlutterFlowTheme.of(context).primaryText,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
//                         ),
//                   ),
//                   SizedBox(height: 4.0),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 0,
//               right: 5,
//               child: TextButton(
//                   onPressed: () async {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'ยกเลิก',
//                     style: FlutterFlowTheme.of(context).bodyMedium.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                           color: FlutterFlowTheme.of(context).error,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                         ),
//                   ),
//                   style: ButtonStyle(
//                     overlayColor: MaterialStateProperty.all((FlutterFlowTheme.of(context).error).withOpacity(.1)),
//                   )),
//             )
//           ],
//         ),
//         searchFieldProps: TextFieldProps(
//             cursorColor: FlutterFlowTheme.of(context).tertiary,
//             padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
//             style: FlutterFlowTheme.of(context).bodyLarge.override(
//                   fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
//                   color: FlutterFlowTheme.of(context).primaryText,
//                   fontWeight: FontWeight.w300,
//                   useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
//                 ),
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.grey[300],
//               hintText: 'ค้นหา',
//               contentPadding: EdgeInsets.symmetric(vertical: 0),
//               hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
//                     fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
//                     color: FlutterFlowTheme.of(context).secondaryText,
//                     fontWeight: FontWeight.w100,
//                     useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodySmallFamily),
//                     lineHeight: 1.0,
//                   ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x00000000),
//                   width: 1.0,
//                 ),
//                 borderRadius: BorderRadius.circular(100.0),
//               ),
//               prefixIcon: Icon(
//                 Icons.search_rounded,
//                 color: FlutterFlowTheme.of(context).primary,
//                 size: 24.0,
//               ),
//             )),
//         popupItemBuilder: (context, item, isSelected) => Column(
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//                   child: Text(
//                     item.pp_special_service_place_type_name ?? '',
//                     style: FlutterFlowTheme.of(context).bodyMedium.override(
//                           fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
//                           fontWeight: FontWeight.w300,
//                           useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 color: Colors.grey[300],
//                 height: 1,
//               ),
//             ),
//           ],
//         ),
//         loadingBuilder: (context, searchEntry) {
//           return Center(
//             child: Lottie.asset(
//               'assets/lottie_animations/loading.json',
//               width: 100.0,
//               height: 100.0,
//               fit: BoxFit.cover,
//               animate: true,
//             ),
//           );
//         },
//         mode: Mode.BOTTOM_SHEET,
//         onChanged: onChangeds,
//       ),
//     );
//   }
// }

Future<String> getVN(String cDate) async {
  var dateParts = cDate.split("-");
  var year = int.parse(dateParts[0]);
  var month = dateParts[1];
  var day = dateParts[2];

  var thYear = (year + 543).toString();
  var yth = "${thYear.substring(2)}$month$day";

  var vnSr = await serviceLocator<EHPApi>().getSerialNumber('vn', 'ovst', 'null');

  var formatVn = vnSr.toString().padLeft(6, '0');

  var vn = "$yth$formatVn";

  return vn;
}

Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Get.snackbar(
      'Location Error',
      'Location services are disabled. Please enable the services',
    );

    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.snackbar(
        'Location Error',
        'Location permissions are denied',
      );

      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Get.snackbar(
      'Location Error',
      'Location permissions are permanently denied, we cannot request permissions.',
    );

    return false;
  }
  return true;
}

Future<void> _getAddressFromLatLng(Position position) async {
  await placemarkFromCoordinates(position.latitude, position.longitude).then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];

    EHPMobile.currentLocationName = '${place.subLocality}, ${place.subAdministrativeArea}';
    EHPMobile.currentLocationNameFine = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  }).catchError((e) {
    debugPrint(e);
  });
}

Future<void> updateCurrentPosition() async {
  final hasPermission = await _handleLocationPermission();
  if (!hasPermission) return;
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
    EHPMobile.currentLocationPosition = position;

    _getAddressFromLatLng(EHPMobile.currentLocationPosition!);
  }).catchError((e) {
    debugPrint(e);
  });
}
