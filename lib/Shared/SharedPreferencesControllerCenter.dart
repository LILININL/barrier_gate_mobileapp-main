import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SharedPreferencesControllerCenter extends GetxController {
  // Singleton pattern
  static final SharedPreferencesControllerCenter _instance =
      SharedPreferencesControllerCenter._internal();

  factory SharedPreferencesControllerCenter() {
    return _instance;
  }

  SharedPreferencesControllerCenter._internal();

  static SharedPreferencesControllerCenter get instance =>
      Get.isRegistered<SharedPreferencesControllerCenter>()
          ? Get.find<SharedPreferencesControllerCenter>()
          : _instance;

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // สร้างตัวแปรรับค่าเวอร์ชันจากภายนอกด้วย RxString
  final RxString version = ''.obs;

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;

      // โหลดเวอร์ชันที่บันทึกไว้ ถ้าไม่มีให้ใช้ค่าเริ่มต้นจาก version
      String savedVersion = _prefs.getString('app_version') ?? version.value;
      version.value = savedVersion;

      // ถ้ายังไม่เคยบันทึกเวอร์ชัน ให้บันทึกค่าเริ่มต้น
      if (_prefs.getString('app_version') == null) {
        await saveVersion(version.value);
      }
    }
  }

  // เก็บรายการการแจ้งเตือนลง SharedPreferences
  Future<void> saveNotifications(
      List<Map<String, dynamic>> notifications) async {
    final prefs = await SharedPreferences.getInstance();

    // แปลงรายการเป็น JSON String
    final notificationsJson = jsonEncode(notifications);

    // บันทึกใน SharedPreferences
    await prefs.setString('notifications', notificationsJson);
  }

  // ดึงรายการการแจ้งเตือนจาก SharedPreferences
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    // ดึง JSON String จาก SharedPreferences
    final notificationsString = prefs.getString('notifications');
    if (notificationsString != null) {
      // แปลง JSON String กลับเป็น List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(jsonDecode(notificationsString));
    }

    // คืนค่าเป็นลิสต์ว่างถ้าไม่มีข้อมูล
    return [];
  }

  // ลบรายการการแจ้งเตือนทั้งหมด
  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
  }

  void setPermissionRequested(bool value) {
    _prefs.setBool('isPermissionRequested', value);
  }

  void setLocationPermissionRequested(bool value) {
    _prefs.setBool('isLocationPermissionRequested', value);
  }

  // อ่านสถานะการขอสิทธิ์ Location
  bool? getLocationPermissionRequested() {
    return _prefs.getBool('isLocationPermissionRequested');
  }

  // อ่านสถานะการขอสิทธิ์
  bool? getPermissionRequested() {
    return _prefs.getBool('isPermissionRequested');
  }

  Future<void> saveVersion(String newVersion) async {
    await init();
    version.value = newVersion;
    await _prefs.setString('app_version', newVersion);
  }

  Future<String> getSavedVersion() async {
    await init();
    return _prefs.getString('app_version') ?? version.value;
  }

  Future<bool> checkVersionAndUpdate(String newVersion) async {
    await init();
    String savedVersion = await getSavedVersion();

    if (savedVersion.isEmpty || savedVersion != newVersion) {
      await saveVersion(newVersion);
      return true;
    }
    return false;
  }

  Future<bool> isNewVersion([String? newVersion]) async {
    await init(); // Ensure SharedPreferences is initialized
    String savedVersion = await getSavedVersion();
    String currentVersion =
        newVersion ?? version.value; // ใช้ RxString version.value
    return savedVersion != currentVersion;
  }

  Future<void> setString(String key, String value) async {
    await init();
    await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await init();
    return _prefs.getString(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await init();
    await _prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    await init();
    return _prefs.getStringList(key);
  }

  Future<void> remove(String key) async {
    await init();
    await _prefs.remove(key);
  }

  Future<void> setStringWithExpiration(
      String key, String value, Duration duration) async {
    await init();
    await _prefs.setString(key, value);
    DateTime expirationTime = DateTime.now().add(duration);
    await _prefs.setString('$key-expiration', expirationTime.toIso8601String());
  }

  Future<String?> getStringWithExpiration(String key) async {
    if (await isExpired(key)) {
      await remove(key);
      return null;
    }
    return getString(key);
  }

  Future<bool> isExpired(String key) async {
    await init();
    String? expirationTimeString = _prefs.getString('$key-expiration');
    if (expirationTimeString != null) {
      DateTime expirationTime = DateTime.parse(expirationTimeString);
      return DateTime.now().isAfter(expirationTime);
    }
    return true;
  }

  Future<void> removeIfExpired(String key) async {
    if (await isExpired(key)) {
      await remove(key);
      await remove('$key-expiration');
    }
  }

  Future<void> clearExpiredData() async {
    await init();
    Set<String> keys = _prefs.getKeys();
    for (String key in keys) {
      if (await isExpired(key)) {
        await remove(key);
        await remove('$key-expiration');
      }
    }
  }

  Future<void> clearSharedPreferences() async {
    await SharedPreferencesControllerCenter.instance.clearAll();
  }

  // Future<void> clearAll() async {
  //   await init();
  //   await _prefs.clear();
  //   print('SharedPreferences cleared successfully.');
  // }

  Future<void> clearAll() async {
    await init();
    final keys = _prefs.getKeys();

    // รายการคีย์ที่ต้องการยกเว้นไม่ให้ลบ
    List<String> excludeKeys = [
      'EndpointsApiUserJWT',
      'EndpointsApiUserJWTExp',
      'app_version',
      'prenames',
      'chwpartList',
      'prenameList',
      'carbrandList'
    ];

    for (String key in keys) {
      if (!excludeKeys.contains(key)) {
        await _prefs.remove(key);
      }
    }
    print('SharedPreferences cleared successfully, except for excluded keys.');
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}
