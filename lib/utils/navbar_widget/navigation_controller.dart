// navigation_controller.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationController extends ChangeNotifier {
  int _currentPage = 1;
  String? _officerRole;

  int get currentPage => _currentPage;
  String? get officerRole => _officerRole;

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> setOfficerRole(String? role) async {
    _officerRole = role;
    notifyListeners();
  }


}
