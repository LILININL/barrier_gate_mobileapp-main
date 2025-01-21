import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class FirebaseApi {
  static String fcmtoken = '';
  static String accessToken = '';
  static bool initialized = false;

  final prefs = Get.put(SharedPreferencesControllerCenter(), permanent: true);

  static getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "village-f1c7a",
      "private_key_id": "931ea0390eebecd395563fb2f9a2cecc9dcffcf1",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCwTl8dc+URdS+1\njkWNg5rVYneQ+lwJUA84u4FAcwdmGWIpXAGtTEZlOC5xsuIZQjwLutC29WPw1/Ul\nppGEAowG6O/hhIQsB3SpRv2zeZVRS2htCc7TJJjOORhM80rC+R+FC7wVb1nlW3z4\nH3DVyAMHBCcywJAPf32NjpsNdQbm6y4K5rVbB7QYguSyIhv/OFc1X8IW1y6Tc66B\n98PgWDsBqpWlUqy7wpBtfUZ5Z6VYqjpRyq9ntOa/pde0UgpHKIbt2BcJ3M4Mvuz/\nH4mK7U+pv698kPnnU/+dwAS//ezbOd5gwvk5VGdXgo8FqZ0fHaT74tbMYi2aNzId\nZ5XhPXqPAgMBAAECggEAHaHefK3I92kxzpsN954B/RFitTxPEcWh+VAShkmPGcr0\nY60yHvVt839A1x1QwRwPyYzpnYaa+JTjgCOB26Ut8c9e2hGSwW+zXOwwoeSygwpg\nj8sRNw20nRydh/lwPFrwwETbpOKlQlZhJ7bpGRVX5Or+x5nz3Jb5/DvWtalQsqjX\nBe60pUqVjCSdx854Hb3lwiZCy4egu89R0JG9GCpVFxvIOAm3devv3FgLg6b1NKon\n9WuccTV0pyH4olJxXsKyCpLqQaqkTNpcR876VtcmkgNiC2EZJMOJCwYyMrO4o4Ex\n+INpPqRn20rtpDvFBNZ12g8ILosXOXHXGT06Kmx8yQKBgQDd2HvLSWggfiQIQ172\nHcAeNYz7iOXxw0qCxhzB5Crrrgvj6kogJE/UAa1ZOwc0rYzq2Mp1DXceP16aHIws\nisaPGKFAfY7dab+IOKwuhGWeUpOY3XRvcAh6+ZXRwlSS09S+nQLwnZOoftz3ouA7\nZLKvoIddVRBSKvauzsEbzF8DywKBgQDLcw6oQBOrVqRyTeTHkE/FiWjp+omxT21w\nQD8vNt+5sMvSHAsASztJuFjdv7mwYYBxNIr09X5rdBvU7oG1FSOANHrwMVFzPWVN\nb/EEM4NoJpOIakgDQLuFayAzS50kaBTijfYk9hNhB3uGz69Awh9otpq1LqOCIUzR\nayLgcXIzzQKBgHE+RsMYr6yWd3I4YcskmKNTFqp30Vk+JVToKFnZTQeNishHGpuZ\nrZ49VO3Nsfnz9ZEUJRTnUL0CABqPJAbAuGbnXbj73uerSXgR5eLA9taAtJM9yGfy\nOoH70byHhICG3XyHza5h4bQLPmSyod/voT8BpNfBylkHUXEeXXkBNCdNAoGBALZT\n1cXpLvd1fYjG0AodBbClVbWjBzU1VoGrwjRg/B1hGTiiUyWfRnHp2RJZ2WL97msF\nyKaBQBuygaLRYMLVP+yMm8SYnkMluZytfpTiSZjUQZGWlhT8NVH7UG9IC3tuH5Ft\n4jL7qSBi4UxO4eOqVRW12G4ZbwWXLE3dsvLsGIndAoGAM76lMtsJVnTcEDeescMC\nlSbzziEyNB9LAC23VKxRa3QxfaSmN4u8sWIiSAdcGEbGbCW5cC+FUBYECqUzISPQ\nXDdXhl9qhFwlNoidjnLUdUyJ2eKvw/XjeYICXs0mw/vsUC7psVinNxmpOMLKVeqz\nPKq0R0/fuQycYSdRv1BOkn0=\n-----END PRIVATE KEY-----\n",
      "client_email": "venus-sentinel@village-f1c7a.iam.gserviceaccount.com",
      "client_id": "115586784168536068351",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/venus-sentinel%40village-f1c7a.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();

    log(credentials.accessToken.data, name: 'getAccessToken');
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ${credentials.accessToken.data}');

    accessToken = credentials.accessToken.data;
  }

  Future<void> saveNotification(RemoteMessage message) async {
    // final data = message.data;
    // String register_id = await Prefs().getString('register_id') ?? '0';
    // DateTime datetime = await GetData().getDateTimeServer('yyyy-MM-dd HH:mm:ss');
    // final mNotificationData = MNotification.newInstance();

    // mNotificationData.notification_id = await serviceLocator<EHPApi>().getSerialNumber('notification_id', 'm_notification', 'notification_id') as int;
    // mNotificationData.title = message.notification!.title;
    // mNotificationData.body = message.notification!.body;
    // mNotificationData.register_id = int.tryParse(register_id);
    // mNotificationData.reading_status = 'N';
    // mNotificationData.datetime = datetime;
    // mNotificationData.deposit_home_register_id = int.parse(data['deposit_home_register_id']);

    // await MNotificationController.saveMNotification(mNotificationData);
    // await Notifications().countBadge();
  }

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High importance Notifications',
      description: 'This channel is used for important notification',
      importance: Importance.defaultImportance);

  Future<void> _handleNotificationClick(
      BuildContext context, RemoteMessage message) async {
    // ดึงค่า AutoLogin จาก SharedPreferences
    String autoLogin =
        await prefs.getString('AutoLogin') ?? 'N'; // ค่าเริ่มต้นเป็น 'N'

    log(autoLogin, name: 'AutoLogin Value');

    if (autoLogin == 'Y') {
      // กรณีที่ AutoLogin เป็น 'Y'
      final notificationData = message.data;
      if (notificationData.containsKey('redirect')) {
        final screen = notificationData['redirect'];
        context.push('/homeListView'); // เปลี่ยนหน้าไปยัง '/detailnotification'
      }
    } else {
      // กรณีที่ AutoLogin ไม่ใช่ 'Y'
      context.pushReplacementNamed(
          'login_list_view'); // เปลี่ยนหน้าไปยังหน้าล็อกอิน
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log('onBackgroundMessage');
    // saveNotification(message);
  }

  Future<void> getFCMToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    FirebaseApi.fcmtoken = fcmToken.toString();

    final fcmTokenController = Get.put(OfficerController());
    fcmTokenController.updateFCMToken(fcmToken!);
    print('bbbbbbbbbbbbbbbbbbbbbb ${fcmToken.toString()}');
  }

  Future<void> initFCM(BuildContext context) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      log('getInitialMessage', name: 'FirebaseAPI');
      if (message != null) {
        // TODO: ตรวจสอบและจัดการกับ initialMessage ที่ได้รับเมื่อแอปเปิดครั้งแรก
        _handleNotificationClick(context, message);
      }
    });

    // TODO: ตั้งค่า callback สำหรับการรับแจ้งเตือนเมื่อแอปอยู่ใน background หรือ terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('onMessageOpenedApp', name: 'FirebaseAPI');
      // saveNotification(message);
      _handleNotificationClick(context, message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // TODO: ตั้งค่า callback สำหรับการรับแจ้งเตือนเมื่อแอปอยู่ใน foreground
    FirebaseMessaging.onMessage.listen((message) {
      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notification = message.notification;
      if (notification == null) return;
      log('onMessage', name: 'FirebaseAPI');
      // saveNotification(message);
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: iosNotificationDetails,
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(
          message.toMap(),
        ),
      );
    });

    if (Platform.isAndroid) {
      const _android = AndroidInitializationSettings('@drawable/ic_launcher');
      const _settings = InitializationSettings(android: _android);
      await _localNotifications.initialize(
        _settings,
        onDidReceiveNotificationResponse: (notificationResponse) {
          final message =
              RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
          _handleNotificationClick(context, message);
        },
      );
    } else if (Platform.isIOS) {}

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }
}
