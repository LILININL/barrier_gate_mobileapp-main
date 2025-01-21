import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<String> _BrandCar = [
    'LEXUS',
    'TOYOTA',
    'MINI',
    'ACURA',
    'HONDA',
    'SUBARU',
    'MAZDA',
    'PORSCHE',
    'BMW',
    'KIA',
    'HYUNDAI',
    'BUICK',
    'INFINITI',
    'TESLA',
    'RAM',
    'CADILLA',
    'NISSAN',
    'GENESI',
    'AUDI',
    'CHEVROLET'
  ];
  List<String> get BrandCar => _BrandCar;
  set BrandCar(List<String> value) {
    _BrandCar = value;
  }

  void addToBrandCar(String value) {
    BrandCar.add(value);
  }

  void removeFromBrandCar(String value) {
    BrandCar.remove(value);
  }

  void removeAtIndexFromBrandCar(int index) {
    BrandCar.removeAt(index);
  }

  void updateBrandCarAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    BrandCar[index] = updateFn(_BrandCar[index]);
  }

  void insertAtIndexInBrandCar(int index, String value) {
    BrandCar.insert(index, value);
  }

  List<String> _Province = [
    'กระบี่',
    'กรุงเทพมหานคร',
    'กาญจนบุรี',
    'กาฬสินธุ์',
    'กำแพงเพชร',
    'ขอนแก่น',
    'จันทบุรี',
    'ฉะเชิงเทรา',
    'ชลบุรี',
    'ชัยนาท',
    'ชัยภูมิ',
    'ชุมพร',
    'เชียงราย',
    'เชียงใหม่',
    'ตรัง',
    'ตราด',
    'ตาก',
    'นครนายก',
    'นครปฐม',
    'นครพนม',
    'นครราชสีมา',
    'นครศรีธรรมราช',
    'นครสวรรค์',
    'นนทบุรี',
    'นราธิวาส',
    'น่าน',
    'บึงกาฬ',
    'บุรีรัมย์',
    'ปทุมธานี',
    'ประจวบคีรีขันธ์',
    'ปราจีนบุรี',
    'ปัตตานี',
    'พระนครศรีอยุธยา',
    'พะเยา',
    'พังงา',
    'พัทลุง',
    'พิจิตร',
    'พิษณุโลก',
    'เพชรบุรี',
    'เพชรบูรณ์',
    'แพร่'
  ];
  List<String> get Province => _Province;
  set Province(List<String> value) {
    _Province = value;
  }

  void addToProvince(String value) {
    Province.add(value);
  }

  void removeFromProvince(String value) {
    Province.remove(value);
  }

  void removeAtIndexFromProvince(int index) {
    Province.removeAt(index);
  }

  void updateProvinceAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    Province[index] = updateFn(_Province[index]);
  }

  void insertAtIndexInProvince(int index, String value) {
    Province.insert(index, value);
  }
}
