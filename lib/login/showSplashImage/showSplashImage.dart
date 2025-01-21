import 'dart:convert';
import 'dart:io';
import 'package:barrier_gate/function_untils/controller/carbrand_controller.dart';
import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:barrier_gate/function_untils/controller/officer_picture_controller.dart';
import 'package:barrier_gate/function_untils/controller/prename_controller.dart';
import 'package:barrier_gate/function_untils/controller/thaiaddress_controller.dart';
import 'package:barrier_gate/function_untils/model/carbrand_model.dart';
import 'package:barrier_gate/function_untils/model/officer_model.dart';
import 'package:barrier_gate/function_untils/model/prename_model.dart';
import 'package:barrier_gate/function_untils/model/thaiaddress_model.dart';
import 'package:barrier_gate/index.dart';
import 'package:barrier_gate/login/login_list_view/login_list_view_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class showSplashImageWidget extends StatefulWidget {
  const showSplashImageWidget({super.key});

  @override
  State<showSplashImageWidget> createState() => _showSplashImageWidget();
}

class _showSplashImageWidget extends State<showSplashImageWidget> {
  // late SharedPreferences prefs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // _model = createModel(context, () => LoginListViewModel());
    _loadLookupAndAutoLogin();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadLookupAndAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ข้อมูลจังหวัดในประเทศไทย
    List<ThaiaddressModel> loadThaiaddressModel = await ThaiaddressController.getChwpart('');
    final thaiaddressJsonList = loadThaiaddressModel.map((ThaiaddressModel) => jsonEncode(ThaiaddressModel.toJson())).toList();
    await prefs.setStringList('chwpartList', thaiaddressJsonList);
    // ข้อมูลคำนำหน้าชื่อ
    List<Prename> prenameModel = await PrenameController.getPrenames('');
    final prenameJsonList = prenameModel.map((Prename) => jsonEncode(Prename.toJson())).toList();
    await prefs.setStringList('prenameList', prenameJsonList);
    // ยี่ห้อรถยนต์
    List<Carbrand> carbrandModel = await CarbrandController.getCarbrands('');
    final carbrandJsonList = carbrandModel.map((Carbrand) => jsonEncode(Carbrand.toJson())).toList();
    await prefs.setStringList('carbrandList', carbrandJsonList);

    String? AutoLogin = prefs.getString('AutoLogin');
    print('AutoLogin  ' + AutoLogin.toString());
    if (AutoLogin == "Y") {
      print('มีการ Login Username แล้ว ');

      context.pushNamed('home_list_view');
    } else {
      print('ไม่มีการ Login Username แล้ว ');
      context.pushNamed('login_list_view');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FlutterFlowTheme.of(context).primaryBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 250.0,
              height: 250.0,
              fit: BoxFit.contain,
            ),
          ),
          const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
