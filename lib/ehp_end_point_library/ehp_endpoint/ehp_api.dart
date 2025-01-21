import 'dart:convert';
import 'dart:developer';
import 'package:ehp_api/ehp_mqtt/ehp_mqtt_connection.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import 'package:crypto/crypto.dart';

import 'package:get/get.dart' as GetPackage;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:ehp_api/dio/options.dart';
import 'package:ehp_api/dio/response.dart';

import 'dio_client.dart';
import 'ehp_endpoint.dart';
import 'ehp_locator.dart';

import 'package:encrypt/encrypt.dart' as enc;
import 'dart:developer' as logDev;
import 'package:flutter/foundation.dart';

Duration? durationParse(String time) {
  try {
    final dt = DateFormat('HH:mm:ss').parse(time);
    // final dt = DateTime.parse('2000-01-01 $time');
    return Duration(hours: dt.hour, minutes: dt.minute, seconds: dt.second);
  } catch (e) {
    debugPrint('durationParse error $time $e');
  }
}

String printDurationHHMMSS(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

abstract class EHPData {
  // EHPData();
  EHPData fromJson(Map<String, dynamic> json); // => EHPData();
  Map<String, dynamic> toJson(); // => {};
  String getTableName(); // => '';
  EHPData getInstance(); // => EHPData.empty();
  String getKeyFieldName();
  String getKeyFieldValue();

  List<int> getFieldTypeForUpdate();
  List<String> getFieldNameForUpdate();
  String getDefaultRestURIParam();
}

class LineApi {
  final DioClient dioClient;
  LineApi({required this.dioClient});
}

class EHPApi {
  final DioClient dioClient;
  final MqttConnection mqtt = MqttConnection.getInstanse();
  // for save field type map from api to use when post data update to rest api
  static Map<String, dynamic> ehpFieldTypeMap = {};

  EHPApi({required this.dioClient});

  static bool checkResponseIsValid(DioResponse response) {
    if (response.statusCode == 200) {
      //  debugPrint('response.data = ${response.data}');

      if (response.data == null) return false;

      final rdata = (response.data as Map);

      if (rdata.containsKey('call_stack')) {
        debugPrint('call_stack detected !');

        final callStackString = '${rdata['call_stack'] ?? ''}';
        for (var s in callStackString.split('\r\n')) {
          debugPrint(s);
        }
      } else {
        debugPrint('no call_stack');
      }

      if (rdata.containsKey('sWhere')) {
        debugPrint('sWhere : ${rdata['sWhere']}');
      }

      if (rdata.containsKey('sWhereBinding')) {
        debugPrint('sWhereBinding : ${rdata['sWhereBinding']}');
      }

      //field_name

      if (rdata.containsKey('field_name')) {
        //  debugPrint('field_name : ${rdata['field_name']}');
        logDev.log('${rdata['field_name']}', name: 'field_name');
      }

      if (rdata.containsKey('MessageCode') && rdata.containsKey('Message') && (response.data['MessageCode'] != 200)) {
        return false;
      }

      if (response.data['result'].toString().isNotEmpty) {
        return true;
      }
    } else {
      if (response.data == null) return false;

      final rdata = (response.data as Map);

      if (rdata.containsKey('call_stack')) {
        debugPrint('call_stack detected !');

        final callStackString = '${rdata['call_stack'] ?? ''}';
        for (var s in callStackString.split('\r\n')) {
          debugPrint(s);
        }
      } else {
        debugPrint('no call_stack');
      }
    }

    return false;
  }

  static String getAPIResponseMessage(DioResponse response) {
    final rdata = response.data as Map;

    if (rdata.containsKey('MessageCode') && rdata.containsKey('Message')) {
      return '${response.data['MessageCode'] ?? ''} : ${rdata['Message'] ?? ''}';
    }

    return '${response.statusCode} : No Message';
  }

  static String getAPIResponseCallStack(DioResponse response) {
    final rdata = response.data as Map;

    if (rdata.containsKey('call_stack')) {
      return '${response.data['call_stack'] ?? ''}';
    }

    return '';
  }

  static bool checkAndShowResponseIsValid(DioResponse response) {
    if (!checkResponseIsValid(response)) {
      _showSnackBarWithTitle('Error', '${getResponseMessage(response)}');
      return false;
    }
    return true;

    if (response.statusCode == 200) {
      final rdata = response.data as Map;

      if (rdata.containsKey('MessageCode') && rdata.containsKey('Message') && (response.data['MessageCode'] != 200)) {
        _showSnackBar(rdata['Message'] ?? '');

        return false;
      }

      if (response.data['result'].toString().isNotEmpty) {
        return true;
      }
    }

    _showSnackBar('Invalid response');

    return false;
  }

  static String getResponseMessage(DioResponse response) {
    final rdata = response.data as Map;

    if (rdata.containsKey('MessageCode') && rdata.containsKey('Message')) {
      return response.data['Message'].toString();
    }

    return '';
  }

  static String hashString(String input) {
    var bytes = utf8.encode(input); // Convert the string to bytes
    var hash = sha256.convert(bytes); // Generate the SHA-256 hash
    return hash.toString(); // Convert the hash to a string
  }

  static String createHmacSha256Hash(String string, String secret) {
    // Encode the string and secret as bytes
    var stringBytes = utf8.encode(string);
    var secretBytes = utf8.encode(secret);

    // Create the HMAC SHA256 hash
    var hash = Hmac(sha256, secretBytes).convert(stringBytes);

    // Return the hexadecimal representation of the hash
    return hash.toString().toUpperCase();
  }

  ///Accepts encrypted data and decrypt it. Returns plain text
  static String decryptWithAES(String skey, enc.Encrypted encryptedData) {
    final cipherKey = enc.Key.fromUtf8(skey);
    final encryptService = enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.cbc)); //Using AES CBC encryption
    final initVector = enc.IV.fromUtf8(skey.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    return encryptService.decrypt(encryptedData, iv: initVector);
  }

  ///Encrypts the given plainText using the key. Returns encrypted data
  static enc.Encrypted encryptWithAES(String skey, String plainText) {
    final cipherKey = enc.Key.fromUtf8(skey);
    final encryptService = enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.cbc));
    final initVector = enc.IV.fromUtf8(skey.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    enc.Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  Future<DioResponse> getAPIJWT() async {
    DioResponse response = DioResponse(requestOptions: RequestOptions());
    try {
      final DioResponse statusResponse = await dioClient.get(
        '/Status',
        authHeader: '',
      );

      debugPrint('getAPIJWT() check status = $statusResponse.data');
      if (checkResponseIsValid(statusResponse)) {
        EHPMobile.clientIP = statusResponse.data['client_ip'] ?? '';

        response = await dioClient.post(
          '${Endpoints.tokenPath}?Action=JWT',
          data: {
            'system_code': Endpoints.apiSystemCode,
            'key_code': Endpoints.apiKeyCode,
          },
          authHeader: '',
        );

        // debugPrint('response.data = $response.data');

        if (checkResponseIsValid(response)) {
          Endpoints.apiJWT = response.data['result'].toString();

          // debugPrint('Endpoints.apiToken = ${Endpoints.apiJWT}');
        }

        return response;
      } else {
        debugPrint('Error response');
      }
    } catch (e) {
      // rethrow;
    }
    return response;
  }

  Future<DioResponse> getAPIAccessToken() async {
    try {
      final DioResponse response = await dioClient.post(
        '${Endpoints.tokenPath}?Action=ACT',
        data: {
          'JWT': Endpoints.apiJWT,
        },
        authHeader: '',
      );

      //  debugPrint('response.data = $response.data');

      if (checkResponseIsValid(response)) {
        Endpoints.apiSessionToken = response.data['result'].toString();

        debugPrint('Endpoints.apiSessionToken = ${Endpoints.apiSessionToken}');
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DioResponse> getUserOTP(String cid, String password) async {
    Endpoints.apiUserJWT = '';
    Endpoints.apiUserJWTPayload.clear();

    try {
      debugPrint('try login with $cid and hash ${createHmacSha256Hash(password, 'bms+')}');
      debugPrint('session token : ${Endpoints.apiSessionToken}');

      final DioResponse response = await dioClient.post(
        '${Endpoints.tokenPath}?Action=USER',
        data: {
          'cid': cid,
          'password_hash': createHmacSha256Hash(password, 'bms+'),
          'need_otp': true
        },
        authHeader: Endpoints.apiSessionToken,
      );

      debugPrint('USER API response.data = $response.data');

      // if (checkResponseIsValid(response)) {
      //  Endpoints.apiUserJWT = response.data['result'].toString();

      //  }

      return response;
    } catch (e) {
      debugPrint('Error : $e');
      return DioResponse(data: {}, requestOptions: RequestOptions(), statusCode: 500, statusMessage: 'Request Failed');
    }
  }

  // Future<DioResponse> getUserJWT(
  //     String cid, String password, String otp) async {
  //   Endpoints.apiUserJWT = '';
  //   Endpoints.apiUserJWTPayload.clear();

  //   try {
  //     final DioResponse response = await dioClient.post(
  //       '${Endpoints.tokenPath}?Action=CONFIRMOTP',
  //       data: {
  //         'cid': cid,
  //         'password_hash': createHmacSha256Hash(password, 'bgs+'),
  //         // 'otp': otp
  //       },
  //       authHeader: Endpoints.apiSessionToken,
  //     );

  //     // debugPrint('getUserJWT response.data = $response.data');

  //     if (checkResponseIsValid(response)) {
  //       Endpoints.apiUserJWT = response.data['result'].toString();

  //       debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

  //       if (Endpoints.apiUserJWT.isNotEmpty) {
  //         Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
  //         log('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

  //         log('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

  //         EHPMobile.loginName =
  //             Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
  //         EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']
  //                 ['full_name'] ??
  //             '';

  //         EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']
  //                 ['profile']['hospital_address_code'] ??
  //             '';
  //         EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']
  //                 ['profile']['hospital_province_name'] ??
  //             '';
  //         EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']
  //                 ['profile']['hospital_district_name'] ??
  //             '';
  //         EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']
  //                 ['profile']['hospital_tambol_name'] ??
  //             '';
  //       }
  //     }

  //     return response;
  //   } catch (e) {
  //     return DioResponse(
  //         data: {},
  //         requestOptions: RequestOptions(),
  //         statusCode: 500,
  //         statusMessage: 'Request Failed');
  //   }
  // }

  Future<DioResponse> getUserJWT(String cid, String password) async {
    Endpoints.apiUserJWT = '';
    Endpoints.apiUserJWTPayload.clear();

    try {
      final DioResponse response = await dioClient.post(
        '${Endpoints.tokenPath}?Action=USER',
        data: {
          'cid': cid,
          'password_hash': createHmacSha256Hash(password, 'bms+'),
        },
        authHeader: Endpoints.apiSessionToken,
      );

      // print("authHeader "+authHeader)
      print("getUserJWT" + Endpoints.apiSessionToken);

      print("getUserJWT " + createHmacSha256Hash(password, 'bms+'));

      // debugPrint('getUserJWT response.data = $response.data');

      if (checkResponseIsValid(response)) {
        Endpoints.apiUserJWT = response.data['result'].toString();

        debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

        if (Endpoints.apiUserJWT.isNotEmpty) {
          Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
          log('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

          log('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

          EHPMobile.loginName = Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
          EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']['full_name'] ?? '';

          EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']['profile']['hospital_address_code'] ?? '';
          EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_province_name'] ?? '';
          EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_district_name'] ?? '';
          EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_tambol_name'] ?? '';
        }
      }

      return response;
    } catch (e) {
      return DioResponse(data: {}, requestOptions: RequestOptions(), statusCode: 500, statusMessage: 'Request Failed');
    }
  }

  Future<DioResponse> getUserJWTFromMOPHIDP(String sjwt) async {
    Endpoints.apiUserJWT = '';
    Endpoints.apiUserJWTPayload.clear();

    try {
      final DioResponse response = await dioClient.post(
        '${Endpoints.tokenPath}?Action=USER-MOPH-IDP',
        data: {
          'idp_jwt': sjwt
        },
        authHeader: Endpoints.apiSessionToken,
      );

      //debugPrint('getUserJWT response.data = $response.data');

      if (checkResponseIsValid(response)) {
        Endpoints.apiIDPJWT = sjwt;
        Endpoints.apiIDPJWTPayload = Jwt.parseJwt(Endpoints.apiIDPJWT);

        Endpoints.apiUserJWT = response.data['result'].toString();

        // debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

        if (Endpoints.apiUserJWT.isNotEmpty) {
          Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
          // debugPrint('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

          // debugPrint('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

          EHPMobile.loginName = Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
          EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']['full_name'] ?? '';

          EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']['profile']['hospital_address_code'] ?? '';
          EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_province_name'] ?? '';
          EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_district_name'] ?? '';
          EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_tambol_name'] ?? '';
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getSerialNumber(String serialName, String tableName, String pkName) async {
    final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

    print('getSerialNumber ' + '${Endpoints.dataPath}?Action=GetSerialNumberCheckExists');
    print('getSerialNumber data ' + '${Endpoints.apiUserJWT}');
    // final hcode = '00000';
    do {
      final DioResponse response = await dioClient.post(
        '${Endpoints.dataPath}?Action=GetSerialNumberCheckExists',
        data: {
          'hospital_code': hcode,
          'serial_number_name': serialName,
          'table_name': tableName,
          'field_name': pkName
        },
        authHeader: Endpoints.apiUserJWT,
      );

      //debugPrint('getSerialNumber response.data = $response.data');

      if (checkResponseIsValid(response)) {
        return response.data['result'];
      } else {
        await showAPIErrorDialog(response);
      }
    } while (true);
  }

  static Future<bool> initializeEHPToken() async {
    debugPrint('initializeEHPToken() start ...');

    await GetStorage.init();
    EHPMobile.prefs = GetStorage();

    /*  var initError = false;
     try {
       EHPMobile.prefs = await SharedPreferences.getInstance();
     } catch(e) {
       debugPrint('Error await SharedPreferences ${e}');
       SharedPreferences.setMockInitialValues({});
       initError = true;
     }

     if (initError) {
       debugPrint('reinit SharedPreferences');
       EHPMobile.prefs = await SharedPreferences.getInstance();
       debugPrint('EHPMobile.prefs = ${EHPMobile.prefs}');
     } */

    Endpoints.apiTokenInitOK = false;
    await serviceLocator<EHPApi>().getAPIJWT();

    debugPrint('getAPIJWT() ok');

    if (Endpoints.apiJWT.isNotEmpty) {
      await serviceLocator<EHPApi>().getAPIAccessToken();

      debugPrint('getAPIAccessToken() ok');
    } else {
      debugPrint('================= Endpoints.apiJWT isEmpty !!! ==================');
    }

    if (Endpoints.apiJWT.isNotEmpty && Endpoints.apiSessionToken.isNotEmpty) {
      Endpoints.apiTokenInitOK = true;
      return true;
    }

    debugPrint('Error initializeEHPToken() return false !!!');
    return false;
  }

  static Future<String> getHNListFromCIDForInCondition({required String cid}) async {
    final data = await serviceLocator<EHPApi>().getRestAPIResponse('patient/?cid=$cid&\$field=hn&\$limit=100');

    if (data.data['result'] == null) {
      return '%27xxyyzz%27';
    }

    Iterable<dynamic> list = data.data['result'];

    List<String> ls = [];

    list.forEach((element) {
      ls.add('%27${element['hn']}%27');
    });

    return ls.join(',');
  }

  static Future<void> initEHPEndpointVariable() async {
    final data = await serviceLocator<EHPApi>().getRestAPIResponse('village/?village_moo=0&\$field=village_id');

    Endpoints.dbVillageMooZeroID = data.data['result'] == null ? 0 : data.data['result'][0]['village_id'];

    /* final hrcount = await serviceLocator<EHPApi>().getRestAPIDataCount(
        HouseRegistType.newInstance(), 'export_code[in]"1","3"');

    if ((hrcount ?? 0) > 0) {
      final hrdata = await serviceLocator<EHPApi>().getRestAPI(
          HouseRegistType.newInstance(),
          '?export_code[in]"1","3"&\$field=house_regist_type_id');

      List<String> rows = [];
      hrdata.forEach((element) {
        rows.add((element as HouseRegistType).house_regist_type_id.toString());
      });

      Endpoints.houseInRegionRegistTypeIDlist = rows.join(',');
    } */
  }

  // Future<List<EHPData>> getRestAPI(EHPData data, String idOrFilter) async {
  //   bool hasError = false;

  //   try {
  //     final tableName = data.getTableName();

  //     final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

  //     debugPrint('start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');

  //     final DioResponse response = await dioClient.get(
  //       '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
  //       authHeader: Endpoints.apiUserJWT,
  //     );

  //     debugPrint('getRestAPI response.data = ${response.data}');

  //     if (checkResponseIsValid(response)) {
  //       if (response.data['field'].toString().isNotEmpty) {
  //         EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];
  //       }

  //       Iterable l = response.data['result'];

  //       if (l.isNotEmpty) {
  //         logDev.log('${l.first ?? ''}', name: 'first result');
  //       }

  //       final List<EHPData> res = List<EHPData>.from(l.map((model) => data.fromJson(model)));

  //       if (res.isNotEmpty) {
  //         logDev.log('${res[0].toJson()}', name: 'first object');
  //       }

  //       return res;
  //     } else {
  //       await showAPIErrorDialog(response);
  //     }
  //   } catch (e) {
  //     debugPrint('error $e');
  //     hasError = true;
  //   }

  //   // Return an empty list as a fallback if there's an error
  //   return [];
  // }

  Future<List<EHPData>> getRestAPI(EHPData data, String idOrFilter) async {
    bool hasError = false;

    do {
      try {
        final tableName = data.getTableName();

        final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        debugPrint('start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');

        do {
          final DioResponse response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
            authHeader: Endpoints.apiUserJWT,
          );

          debugPrint('getRestAPI response.data = $response.data');

          if (checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);

            // if (!idOrFilter.contains('?')) {
            if (response.data['field'].toString().isNotEmpty) {
              EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];

              // debugPrint('ehpFieldTypeMap = ${EHPApi.ehpFieldTypeMap}');
            }
            // }

            Iterable l = response.data['result'];

            if (l.isNotEmpty) {
              logDev.log('${l.first ?? ''}', name: 'first result');
            }

            final List<EHPData> res = List<EHPData>.from(l.map((model) => data.fromJson(model)));

            if (res.isNotEmpty) {
              //debugPrint('getRestAPI res 0 = ${res[0].toJson()}');
              logDev.log('${res[0].toJson()}', name: 'first object');
            }

            return res;
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }

  // Future<List<EHPData>> getRestAPI(EHPData data, String idOrFilter) async {
  //   bool hasError = false;
  //   do {
  //     try {
  //       final tableName = data.getTableName();
  //       final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];
  //       // final hcode = '00000';
  //       // debugPrint(
  //       //     'start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');
  //       do {
  //         // final DioResponse response = await dioClient.get(
  //         //   '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
  //         //   authHeader: Endpoints.apiUserJWT,
  //         // );
  //         final DioResponse response = await dioClient.get(
  //           '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
  //           //'https://bgs1.blogdns.net:443/bgsapiv2uat/RestAPI/00000/$tableName/$idOrFilter',
  //           authHeader: Endpoints.apiJWT,
  //         );
  //         // debugPrint('getRestAPI response.data = $response.data');
  //         if (checkResponseIsValid(response)) {
  //           //final List<EHPData> res = data.fromJson(response.data['result']);
  //           // if (!idOrFilter.contains('?')) {
  //           if (response.data['field'].toString().isNotEmpty) {
  //             EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];

  //             // debugPrint('ehpFieldTypeMap = ${EHPApi.ehpFieldTypeMap}');
  //           }
  //           // }

  //           Iterable l = response.data['result'];

  //           if (l.isNotEmpty) {
  //             logDev.log('${l.first ?? ''}', name: 'first result');
  //           }

  //           final List<EHPData> res = List<EHPData>.from(l.map((model) => data.fromJson(model)));

  //           if (res.isNotEmpty) {
  //             //debugPrint('getRestAPI res 0 = ${res[0].toJson()}');
  //             logDev.log('${res[0].toJson()}', name: 'first object');
  //           }

  //           return res;
  //         } else {
  //           await showAPIErrorDialog(response);
  //         }
  //       } while (true);

  //       // return null;
  //     } catch (e) {
  //       //rethrow;
  //       debugPrint('error $e');
  //       hasError = true;
  //     }
  //   } while (hasError);
  // }

  Future<dynamic> getRestAPIWithPath(String requestPath) async {
    bool hasError = false;

    do {
      try {
        final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        debugPrint('start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$requestPath');

        do {
          final DioResponse response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$requestPath',
            authHeader: Endpoints.apiUserJWT,
          );

          debugPrint('getRestAPIWithPath response.data = $response.data');

          if (checkResponseIsValid(response)) {
            return response.data['result'];
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }

  Future<dynamic> getRestAPIWithPathIgnoreError(String requestPath) async {
    try {
      final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

      debugPrint('start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$requestPath');

      // do {
      final DioResponse response = await dioClient.get(
        '${Endpoints.restAPIPath}/$hcode/$requestPath',
        authHeader: Endpoints.apiUserJWT,
      );

      debugPrint('getRestAPI response.data = $response.data');

      if (checkResponseIsValid(response)) {
        return response.data['result'];
      } else {
        // await showAPIErrorDialog(response);
      }
      //  } while (true);

      return null;
    } catch (e) {
      // rethrow;
    }
  }

  Future<bool> deleteRestAPI(EHPData data) async {
    bool hasError = false;

    do {
      try {
        final tableName = data.getTableName();

        final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        debugPrint('start deleteRestAPI : ${Endpoints.restAPIPath}/$hcode/$tableName/${data.getKeyFieldValue()}');

        do {
          final DioResponse response = await dioClient.delete(
            '${Endpoints.restAPIPath}/$hcode/$tableName/${data.getKeyFieldValue()}',
            authHeader: Endpoints.apiUserJWT,
          );

          debugPrint('deleteRestAPI response.data = $response.data');

          if (checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);

            return true;
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }

  Future<EHPData?> getRestAPISingleFirstObject(EHPData data, String idOrFilter) async {
    bool hasError = false;

    do {
      try {
        if (idOrFilter.isEmpty) {
          throw Exception('No id or filter specify');
        }

        final tableName = data.getTableName();

        // final hcode = '00000';

        final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // debugPrint(
        //     'start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');

        do {
          final DioResponse response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
            //'https://bgs1.blogdns.net:443/bgsapiv2uat/RestAPI/00000/$tableName/$idOrFilter',
            authHeader: Endpoints.apiJWT,
          );

          // debugPrint('getRestAPISingleFirstObject response.data = $response.data');

          if (checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);

            // if (!idOrFilter.contains('?')) {
            if (response.data['field'].toString().isNotEmpty) {
              EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];

              // debugPrint('ehpFieldTypeMap = ${EHPApi.ehpFieldTypeMap}');
            }
            //  }

            Iterable l = response.data['result'];
            final List<EHPData> res = List<EHPData>.from(l.map((model) => data.fromJson(model)));

            if (res.isNotEmpty) {
              // debugPrint('getRestAPI res 0 = ${res[0].toJson()}');
              return res[0];
            } else {
              return data;
            }
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }

  Future<int?> getRestAPIDataCount(EHPData data, String filter) async {
    bool hasError = false;

    do {
      try {
        // if (filter.isEmpty) {
        //   throw Exception('No filter specify');
        // }

        final tableName = data.getTableName();

        // final hcode = '00000';
        final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // debugPrint(
        //     'start getRestAPIDataCount : ${Endpoints.restAPIPath}/$hcode/$tableName/?$filter');

        do {
          final DioResponse response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$tableName/?$filter&\$getcount=1',
            authHeader: Endpoints.apiJWT,
          );

          //  debugPrint('getRestAPIDataCount response.data = $response.data');

          if (checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);
            debugPrint('data_count = ${response.data['result'][0]['data_count']}');
            return response.data['result'] == null ? 0 : response.data['result'][0]['data_count'];
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }

  Future<bool> postRestAPIData(EHPData data, String idOrFilter) async {
    bool hasError = false;

    do {
      try {
        if (idOrFilter.isEmpty) {
          throw Exception('No id or filter specify');
        }

        final tableName = data.getTableName();

        // final hcode = '00000';
        final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // logDev.log(
        //     'start postRestAPIData : ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');
        // logDev.log(
        //     'post payload for data ${data.runtimeType.toString()} : ${data.toJson()}');

        logDev.log('EHPApi.ehpFieldTypeMap ${data.runtimeType.toString()} = ${EHPApi.ehpFieldTypeMap[data.runtimeType.toString()]} count = ${((EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] as List?) ?? []).length}', name: 'post_field');
        logDev.log('${data.toJson()} count = ${data.toJson().length}', name: 'post_data');

        do {
          final DioResponse response = await dioClient.post(
            '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
            data: {
              'data': [
                data.toJson()
              ],
              'update_field': data.getFieldNameForUpdate(),
              'field': data.getFieldTypeForUpdate() /* data.getFieldTypeForUpdate().isNotEmpty
                ? data.getFieldTypeForUpdate()
                : EHPApi.ehpFieldTypeMap[data.runtimeType.toString()]*/
            },
            authHeader: Endpoints.apiJWT,
          );

          // debugPrint('postRestAPIData response.data = $response.data');
          logDev.log('statusCode.');
          logDev.log(response.statusCode.toString());

          if (checkResponseIsValid(response)) {
            if (response.data['field'].toString().isNotEmpty) {
              EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];

              // debugPrint('ehpFieldTypeMap = ${EHPApi.ehpFieldTypeMap}');
            }

            return true;
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }

  Future<bool> deleteRestAPIData(EHPData data, String id) async {
    bool hasError = false;

    do {
      try {
        if (id.isEmpty) {
          throw Exception('No id');
        }

        final tableName = data.getTableName();

        final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        debugPrint('start deleteRestAPIData : ${Endpoints.restAPIPath}/$hcode/$tableName/$id');

        //  do {
        final DioResponse response = await dioClient.delete(
          '${Endpoints.restAPIPath}/$hcode/$tableName/$id',
          authHeader: Endpoints.apiUserJWT,
        );

        // debugPrint('postRestAPIData response.data = $response.data');

        if (checkResponseIsValid(response)) {
          return true;
        } else {
          await showAPIErrorDialog(response);
        }
        // } while (true);

        return true;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }

  Future<DioResponse> getRestAPIResponse(String requestPath) async {
    bool hasError = false;

    do {
      try {
        final hcode = EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        do {
          debugPrint('start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$requestPath');

          final DioResponse response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$requestPath',
            authHeader: Endpoints.apiUserJWT,
          );

          debugPrint('getRestAPI response.data = $response.data');

          if (checkResponseIsValid(response)) {
            return response;
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }

  static Future<void> showAPIErrorDialog(DioResponse response) async {
    debugPrint('showAPIErrorDialog $response');

    while (Endpoints.errorDialogVisible) {
      await Future.delayed(Duration(seconds: 1));
    }

    Endpoints.errorDialogVisible = true;

    try {
      await showDialog(
        context: GetPackage.Get.overlayContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("API Error", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            content: Container(
              height: 450,
              child: Column(
                children: [
                  Text(getAPIResponseMessage(response)),
                  Divider(
                    height: 10,
                  ),
                  Text(
                    'Call Stack : ${getAPIResponseCallStack(response)}',
                    style: TextStyle(fontSize: 8, fontFamily: GoogleFonts.inconsolata().fontFamily),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 35,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                label: Text("Retry"),
                icon: Icon(Icons.refresh),
                onPressed: () {
                  GetPackage.Get.back();
                },
              ),
            ],
          );
        },
      );
    } finally {
      Endpoints.errorDialogVisible = false;
    }
  }

  static Future<void> showErrorDialog(String errorMessage) async {
    debugPrint('showAPIErrorDialog $errorMessage');

    while (Endpoints.errorDialogVisible) {
      await Future.delayed(Duration(seconds: 1));
    }

    Endpoints.errorDialogVisible = true;

    try {
      await showDialog(
        context: GetPackage.Get.overlayContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            content: Container(
              height: 350,
              child: Column(
                children: [
                  Text(errorMessage),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                label: Text("Retry"),
                icon: Icon(Icons.refresh),
                onPressed: () {
                  GetPackage.Get.back();
                },
              ),
            ],
          );
        },
      );
    } finally {
      Endpoints.errorDialogVisible = false;
    }
  }

  static Future<bool> checkMOPHAccountJWT() async {
    DateTime? expiryDate;

    if (Endpoints.mophAccountUser.isEmpty) {
      Get.snackbar(
        'Configuration Error',
        'Endpoints.mophAccountUser is not set',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return false;
    }

    if (Endpoints.mophAccountPassword.isEmpty) {
      Get.snackbar(
        'Configuration Error',
        'Endpoints.mophAccountPassword is not set',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return false;
    }

    try {
      expiryDate = Endpoints.mophAPIJWT.isEmpty ? null : Jwt.getExpiryDate(Endpoints.mophAPIJWT);

      if ((expiryDate ?? DateTime.fromMillisecondsSinceEpoch(0)).microsecondsSinceEpoch < DateTime.now().add(const Duration(minutes: -15)).microsecondsSinceEpoch) {
        final dio = serviceLocator<MOPHDioClient>();

        final response = await dio.post('?Action=get_moph_access_token', authHeader: '', data: {
          'user': Endpoints.mophAccountUser,
          'password_hash': createHmacSha256Hash(Endpoints.mophAccountPassword, '\$jwt@moph#').toUpperCase(),
          'hospital_code': Endpoints.mophAccountHospitalCode
        });

        debugPrint('get_moph_access_token rcv > ${response.data}');

        if (response.data.toString().substring(0, 3) != 'eyJ') {
          Get.snackbar(
            'Invalid MOPH-AC Response',
            response.data.toString(),
            backgroundColor: Colors.white,
            colorText: Colors.red,
          );
        }

        expiryDate = Jwt.getExpiryDate(response.data);
        debugPrint('moph jwt expire = $expiryDate');

        if ((expiryDate ?? DateTime.fromMillisecondsSinceEpoch(0)).microsecondsSinceEpoch > DateTime.now().add(const Duration(minutes: -15)).microsecondsSinceEpoch) {
          debugPrint('moph jwt = ${response.data}');
          Endpoints.mophAPIJWT = response.data;
          return true;
        }
      }

      return Endpoints.mophAPIJWT.isNotEmpty;
    } catch (e) {
      debugPrint('error : ${e.toString()}');
    }

    return false;
  }

//   static void updatebgsVideoOnline() async {
//     try {
// // ss := PostCurlWithContentType('hosxp.net', '443', '/phapi/Video?Action=UpdateOnline', v, '', 'application/json', true);
//       /*
//     v := _obj(['hospital_code', fhospitalcode,
//      'hospital_user_id', flgn,
//      'hospital_name', fhospitalname,
//      'location_name', UniMainModule.fcomputerdepname,
//         'computer_name', MainModule.fcomputername,
//         'hospital_user_name', UniMainModule.FbgsOfficerName,
//          'online_datetime', Variant(d),
//           'application_name', extractfilename(paramstr(0)),
//           'province_name', FPingHospitalProvinceName,
//           'district_name', FPingHospitalDistrictName,
//            'online_id', FOnlineID,
//            'idle_time', SecondsIdle,
//            'video_ready',boolean2char(UniMainModule.FVideoDeviceReady),
//             'client_platform', 'EHP'

//         ]);

//      */

//       final postData = {
//         'hospital_code': EHPMobile.hospitalCode,
//         'hospital_user_id': EHPMobile.loginName,
//         'hospital_name': EHPMobile.hospitalName,
//         'location_name': EHPMobile.currentLocationName,
//         'computer_name': EHPMobile.deviceModel,
//         'hospital_user_name': EHPMobile.userName,
//         'online_datetime': DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()),
//         'application_name': 'Flutter-mobile',
//         'province_name': EHPMobile.hospitalProvinceName,
//         'district_name': EHPMobile.hospitalDistrictName,
//         'online_id': EHPMobile.onlineID,
//         'idle_time': EHPMobile.idleSecond,
//         'video_ready': 'Y',
//         'client_platform': EHPMobile.clientPlatformName,
//         'video_version': 1,
//         'fcm_token': EHPMobile.fcmToken
//       };

//       debugPrint('start updatebgsVideoOnline : $postData');

//       final DioResponse response = await serviceLocator<EHPApi>().dioClient.post('/Video?Action=UpdateOnline', authHeader: '', data: postData);

//       debugPrint('updatebgsVideoOnline response = $response.data');

//       if (checkResponseIsValid(response)) {
//       } else {}

//       // return null;
//     } catch (e) {
//       // rethrow;
//     }
//   }

  static Future<String> postPasteJSON(Map<String, dynamic> data) async {
    bool hasError = false;

    do {
      try {
        do {
          final DioResponse response = await serviceLocator<EHPApi>().dioClient.post('/PasteJSON?Action=POST', authHeader: Endpoints.apiUserJWT, data: data);

          if (checkResponseIsValid(response)) {
            return response.data['result'].toString();
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }
}

String stripMargin(String s) {
  return s.splitMapJoin(
    RegExp(r'^', multiLine: true),
    onMatch: (_) => '\n',
    onNonMatch: (n) => n.trim(),
  );
}

void _showSnackBar(String message) {
  GetPackage.Get.snackbar('Invalid API Response', message,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent.shade700,
      icon: Icon(
        Icons.error_sharp,
        color: Colors.yellow,
      ));
}

void _showSnackBarWithTitle(String title, String message) {
  GetPackage.Get.snackbar(title, message,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent.shade700,
      icon: Icon(
        Icons.error_sharp,
        color: Colors.yellow,
      ));
}

DateTime? tryParseBuddistDateDDMMYYYY(String inDate) {
  final dateComponent = inDate.split('/');

  if (dateComponent.length < 3) return null;

  final d = int.tryParse(dateComponent[0]) ?? 0;

  if (d > 31) return null;
  if (d < 1) return null;

  final m = int.tryParse(dateComponent[1]) ?? 0;

  if (m < 1) return null;
  if (m > 12) return null;

  final y = int.tryParse(dateComponent[2]) ?? 0;

  if (y < 2200) return null;
  if (y > 2900) return null;

  return DateFormat('d/M/yyyy').parse('$d/$m/${y - 543}');
}

void logFull(String logData) {
  logDev.log(logData);
}

// Future GetTaskAccessRight(int bgsUserID) async {
//   List xbgsUserRight = [];
//   await bgsUserRightController.getbgsUserRights(bgsUserID.toString()).then((value) {
//     value.forEach((element) {
//       xbgsUserRight.add(element.user_right_code);
//     });
//   });
//   EHPMobile.bgsUserRight = xbgsUserRight.toList().toString();
//   print('EHPMobile.bgsUserRight ' + EHPMobile.bgsUserRight);
// }

// bool canOfficerTaskAccess(String userRightCode) {
//   if (EHPMobile.bgsUserRight.contains(userRightCode) || EHPMobile.bgsUserRight.contains('administrator')) {
//     return true;
//   } else {
//     return false;
//   }
// }

// String CheckPlatformDeviceIsMobile(context) {
//   bool isMobile;
//   String test;

//   if ((defaultTargetPlatform == TargetPlatform.android) ||
//       (defaultTargetPlatform == TargetPlatform.iOS)) {
//     isMobile = true;
//     test = 'isMobilex';
//   } else {
//     isMobile = false;
//     test = 'Web';
//   }

//   return test;
// }

bool CheckPlatformDeviceIsMobile(BuildContext context) {
  const kMobileWidthCutoff = 640.0;
  final width = MediaQuery.of(context).size.width;
  bool isMobile;
  // String test;

  if ((defaultTargetPlatform == TargetPlatform.android) || (defaultTargetPlatform == TargetPlatform.iOS)) {
    isMobile = true;
    // test = 'isMobilex';
  } else {
    isMobile = false;
    // print('CheckPlatformDeviceIsMobile : ' + width.toString());
    if (width < kMobileWidthCutoff) {
      isMobile = true;
    }

    // test = 'Web';
  }

  return isMobile;
}

// Future<bool> canOfficerTaskAccess(String taskCode, String operationCode) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? bgsUserID = prefs.getString('bgsUserID');
//   print('>>> canOfficerTaskAccess <<<');
//   bool canAccess = false;
//   // EHPMobile.bgsUserID = 648; //Set ไว้ก่อน
//   List<String> bgs_group_id = [];
//   String condition = '';
//   List<bgsGroupList> ehpbgsGroupList = [];
//   try {
//     final bgsGroupTaskID = await serviceLocator<EHPApi>().getRestAPISingleFirstObject(bgsGroupTask.newInstance(), '?bgs_group_task_code=$taskCode') as bgsGroupTask;
//     print('bgsGroupTaskID' + bgsGroupTaskID.bgs_group_task_id.toString());
//     int bgs_group_task_id = bgsGroupTaskID.bgs_group_task_id!;
//     print(bgs_group_task_id);
//     if (bgs_group_task_id == null) {
//       //เช็คก่อนว่า มี bgs_group_task_id ในตาราง bgs_group_task ก่อนไหม ถ้าไม่มี ก็ false
//       return false;
//     }
//     //เช็คก่อนกว่า bgs_user_id มีการผูกให้สิทธิแล้วหรือยัง
//     final bgsGroupIDList = await serviceLocator<EHPApi>().getRestAPI(bgsGroupList.newInstance(), '?bgs_user_id=${bgsUserID}&${bgsGroupList.newInstance().getDefaultRestURIParam()}&\$limit=100');
//     ehpbgsGroupList = List<bgsGroupList>.from(bgsGroupIDList.map((e) => e as bgsGroupList));
//     print('Count Group List ' + ehpbgsGroupList.length.toString());
//     if (ehpbgsGroupList.length > 0) {
//       for (var i = 0; i < ehpbgsGroupList.length; i++) {
//         if (i == 0) {
//           bgs_group_id.add(ehpbgsGroupList[i].bgs_group_id.toString() + '%');
//         } else {
//           bgs_group_id.add('2C' + ehpbgsGroupList[i].bgs_group_id.toString() + '%');
//         }
//         print('bgs_group_id : ' + i.toString() + '>' + ehpbgsGroupList[i].bgs_group_id.toString());
//       }
//     } else {
//       //ถ้าไม่มี bgs Group List แสดงว่า ยังไม่ได้ตั้งค่าสิทธิแต่ละ User reture false ไป
//       bgs_group_id.add('-999%');
//       return false;
//     }
//     // Check Task Module 999 group_id มี 999
//     print('> : ' + '?bgs_group_id[in]${bgs_group_id.join('').substring(0, bgs_group_id.join().length - 1)}&bgs_group_module_id=999');
//     final checkGroupAdmin = await serviceLocator<EHPApi>().getRestAPIDataCount(bgsGroupModuleAccess.newInstance(), 'bgs_group_id[in]${bgs_group_id.join('').substring(0, bgs_group_id.join().length - 1)}&bgs_group_module_id=999');
//     if (checkGroupAdmin! > 0) {
//       return true;
//     }
//     print('checkGroupAdmin : ' + await checkGroupAdmin.toString());
//     //
//     print('user : bgs_group_id : ' + bgs_group_id.join(''));
//     print('taskcode ' + taskCode + ' bgs_group_task_id : ' + bgs_group_task_id.toString());
//     condition = '?bgs_group_id[in]${bgs_group_id.join('').substring(0, bgs_group_id.join().length - 1)}&bgs_group_task_id=${bgs_group_task_id.toString()}';
//     print('condition : ' + condition);
//     final canTaskAccess = await serviceLocator<EHPApi>().getRestAPISingleFirstObject(getbgsGroupTaskAccess.newInstance(), condition) as getbgsGroupTaskAccess;
//     if (await canTaskAccess.bgs_group_task_access_id == null) {
//       canAccess = false;
//     } else {
//       switch (operationCode) {
//         case 'VIEW':
//           {
//             if (canTaskAccess.can_view == null || canTaskAccess.can_view == 'N') {
//               canAccess = false;
//             } else {
//               canAccess = true;
//             }
//             break;
//           }
//         case 'ADD':
//           {
//             if (canTaskAccess.can_add == null || canTaskAccess.can_add == 'N') {
//               canAccess = false;
//             } else {
//               canAccess = true;
//             }
//             break;
//           }
//         case 'EDIT':
//           {
//             if (canTaskAccess.can_edit == null || canTaskAccess.can_edit == 'N') {
//               canAccess = false;
//             } else {
//               canAccess = true;
//             }
//             break;
//           }

//         case 'DELETE':
//           {
//             if (canTaskAccess.can_delete == null || canTaskAccess.can_delete == 'N') {
//               canAccess = false;
//             } else {
//               canAccess = true;
//             }
//             break;
//           }
//       }
//     }
//     print('bgs_group_task_code :  ' + taskCode + ' , canTaskAccess : ' + operationCode + ' Value ' + canAccess.toString() + ' , bgs_group_task_access_id ' + canTaskAccess.bgs_group_task_access_id.toString());
//     return canAccess;
//   } catch (e) {
//     print('Error ' + e.toString());
//     return false;
//   }
// }

//ใช้สำหรับรับส่ง Text Message Socket
// sendMessageSocket(String msgText, String headerText, int receiveID, String employeeID) {
//   var focusCode = FocusNode();
//   var message = msgText;
//   if (message.isEmpty) return;
//   SocketService.sendMessage(message, headerText, receiveID, employeeID);
//   focusCode.requestFocus();
// }



// 