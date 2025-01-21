import 'dart:developer';
import 'dart:io';

import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/function_untils/controller/fireconfig.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:barrier_gate/function_untils/controller/carbrand_controller.dart';
import 'package:barrier_gate/function_untils/controller/prename_controller.dart';
import 'package:barrier_gate/function_untils/controller/thaiaddress_controller.dart';
import 'package:barrier_gate/function_untils/model/carbrand_model.dart';
import 'package:barrier_gate/function_untils/model/thaiaddress_model.dart';
import 'package:barrier_gate/login/signup/preAcontroller.dart';
import 'package:barrier_gate/notification/notify/OverlayNovicationbar.dart';
import 'package:barrier_gate/utils/navbar_widget/navigation_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'ehp_end_point_library/ehp_api.dart';
import 'ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'function_untils/model/prename_model.dart';
import 'index.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // เรียกใช้เมื่อได้รับข้อความใน Background
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = FFAppState();

  await appState.initializePersistedState();

  setUpServiceLocator();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final prefs = Get.put(SharedPreferencesControllerCenter(), permanent: true);

  prefs.version.value = 'BATA TEST 68.01.16.001 P';

  bool isNew = await prefs.checkVersionAndUpdate(prefs.version.value);

  if (isNew) {
    print('New version detected and updated!');
  } else {
    print('No version change.');
  }

  try {
    final apiInitializedResult = await EHPApi.initializeEHPToken();
    log('main => EHPApi.initializeEHPToken() = $apiInitializedResult');

    String? jwt = await prefs.getString('EndpointsApiUserJWT');
    String? jwtExp = await prefs.getString('EndpointsApiUserJWTExp');

    Future<void> updateJWT() async {
      await serviceLocator<EHPApi>().getUserJWT('0000000000001', 'admin');
      await prefs.setString(
          'EndpointsApiUserJWT', Endpoints.apiUserJWT.toString());
      await prefs.setString('EndpointsApiUserJWTExp',
          Endpoints.apiUserJWTPayload['exp'].toString());
    }

    print("JWT Check " + jwt.toString());

    if (jwt != null && jwt.isNotEmpty) {
      // print("JWT Check jwt != null && jwt.isNotEmpty ");
      DateTime expTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(jwtExp!) * 1000);
      // print("JWT Check jwt  expTime " + expTime.toString());
      DateTime now = DateTime.now();
      // คำนวณส่วนต่างของเวลา
      Duration difference = expTime.difference(now);
      // แปลงส่วนต่างเป็นชั่วโมง
      int hoursDifference = difference.inHours;
      // print("JWT Check jwt ส่วนต่างของเวลาคือ $hoursDifference ชั่วโมง");
      if (hoursDifference < 28) {
        await updateJWT();
      } else {
        Endpoints.apiUserJWT = jwt;
        Endpoints.apiUserJWTPayload = Jwt.parseJwt(jwt);
      }
    } else {
      await updateJWT();
    }
  } catch (e) {
    log('Error initializing API or getting JWT: $e');
  }

  final prenameController = Get.put(PrenameAController(), permanent: true);
  await prenameController.loadPrenamesFromPrefs();

  Get.put(NotificationController());

  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  // await dotenv.load(fileName: "configis.env");
  final envString = await rootBundle.loadString('assets/configis.env');
  final envMap = Map<String, String>.fromEntries(
    envString.split('\n').where((line) => line.contains('=')).map((line) {
      final split = line.split('=');
      return MapEntry(split[0].trim(), split[1].trim());
    }),
  );

  dotenv.testLoad(mergeWith: envMap);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appState),
        ChangeNotifierProvider(create: (_) => NavigationController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  final prefs = Get.put(SharedPreferencesControllerCenter(), permanent: true);

  Future<bool> requestLocationPermission() async {
    // ตรวจสอบว่าผู้ใช้เคยขอสิทธิ์แล้วหรือยัง
    bool isPermissionRequested =
        prefs.getLocationPermissionRequested() ?? false;

    if (isPermissionRequested) {
      print("Location permission already requested");
      // ถือว่าสิทธิ์ได้รับการจัดการแล้ว
      return Permission.location.isGranted;
    }

    // ตรวจสอบสถานะสิทธิ์ปัจจุบัน
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      // บันทึกสถานะว่าขอสิทธิ์แล้ว
      prefs.setLocationPermissionRequested(true);
      return true;
    } else if (status.isDenied) {
      // ขอสิทธิ์ใหม่
      status = await Permission.location.request();
      if (status.isGranted) {
        // บันทึกสถานะว่าขอสิทธิ์แล้ว
        prefs.setLocationPermissionRequested(true);
        return true;
      }
    } else if (status.isPermanentlyDenied) {
      // สิทธิ์ถูกปฏิเสธถาวร เปิดการตั้งค่า
      await openAppSettings();
    }

    // หากยังไม่ได้รับสิทธิ์
    return false;
  }

  Future<bool> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // เรียกใช้ SharedPreferencesControllerCenter

    // ตรวจสอบว่าเคยขอสิทธิ์แล้วหรือยัง
    bool isPermissionRequested = prefs.getPermissionRequested() ?? false;

    if (isPermissionRequested) {
      print("Notification permission already requested");
      return true; // ถือว่าสิทธิ์ได้รับการจัดการแล้ว
    }

    // ตรวจสอบสถานะสิทธิ์
    NotificationSettings settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // บันทึกสถานะว่าขอสิทธิ์แล้ว
      prefs.setPermissionRequested(true);
      return true;
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // ขอสิทธิ์ใหม่
      settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // บันทึกสถานะว่าขอสิทธิ์แล้ว
        prefs.setPermissionRequested(true);
        return true;
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // บันทึกสถานะว่าขอสิทธิ์แบบชั่วคราว
      prefs.setPermissionRequested(true);
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      // ขอสิทธิ์ใหม่ในกรณีที่ยังไม่มีการขอ
      settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // บันทึกสถานะว่าขอสิทธิ์แล้ว
        prefs.setPermissionRequested(true);
        return true;
      }
    }

    // หากยังไม่ได้รับสิทธิ์
    return false;
  }

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    requestNotificationPermission();
    FirebaseApi().getFCMToken();
    FirebaseApi.getAccessToken();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    Future.delayed(Duration.zero, () async {
      final officerId = prefs.getString('officer_id');
      final autoLogin = prefs.getString('AutoLogin');
      final officerRole = prefs.getString('officer_role');

      if (officerId != null && autoLogin == 'Y') {
        if (officerRole == 'rss') {
          _router.routerDelegate
              .pop('/homeListView'); // Redirect to homeListView
        } else if (officerRole == 'rpp') {
          _router.routerDelegate.pop('/homeRPP'); // Redirect to homeRPP
        }
      }
    });

    Future.delayed(Duration(milliseconds: 1000),
        () => safeSetState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Venus Sentinel',
      locale: const Locale('th', 'TH'),
      supportedLocales: const [
        Locale('th', 'TH'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        //  GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
