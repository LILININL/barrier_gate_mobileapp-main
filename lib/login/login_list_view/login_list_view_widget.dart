import 'dart:convert';
import 'dart:io';
import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/function_untils/controller/carbrand_controller.dart';
import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:barrier_gate/function_untils/controller/officer_picture_controller.dart';
import 'package:barrier_gate/function_untils/controller/prename_controller.dart';
import 'package:barrier_gate/function_untils/controller/thaiaddress_controller.dart';
import 'package:barrier_gate/function_untils/model/carbrand_model.dart';
import 'package:barrier_gate/function_untils/model/officer_model.dart';
import 'package:barrier_gate/function_untils/model/prename_model.dart';
import 'package:barrier_gate/function_untils/model/thaiaddress_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_list_view_model.dart';
export 'login_list_view_model.dart';

class LoginListViewWidget extends StatefulWidget {
  const LoginListViewWidget({super.key});

  @override
  State<LoginListViewWidget> createState() => _LoginListViewWidgetState();
}

class _LoginListViewWidgetState extends State<LoginListViewWidget> {
  late LoginListViewModel _model;
  late SharedPreferences prefs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginListViewModel());
    _loadLookupList();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadLookupList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ข้อมูลจังหวัดในประเทศไทย
    List<ThaiaddressModel> loadThaiaddressModel =
        await ThaiaddressController.getChwpart('');
    final thaiaddressJsonList = loadThaiaddressModel
        .map((ThaiaddressModel) => jsonEncode(ThaiaddressModel.toJson()))
        .toList();
    await prefs.setStringList('chwpartList', thaiaddressJsonList);

    // ข้อมูลคำนำหน้าชื่อ
    List<Prename> prenameModel = await PrenameController.getPrenames('');
    final prenameJsonList =
        prenameModel.map((Prename) => jsonEncode(Prename.toJson())).toList();
    await prefs.setStringList('prenameList', prenameJsonList);

    // ยี่ห้อรถยนต์
    List<Carbrand> carbrandModel = await CarbrandController.getCarbrands('');
    final carbrandJsonList =
        carbrandModel.map((Carbrand) => jsonEncode(Carbrand.toJson())).toList();
    // print('carbrandJsonList ' + carbrandJsonList.length.toString());
    await prefs.setStringList('carbrandList', carbrandJsonList);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // คืนค่าเป็น false เพื่อไม่ให้สามารถกดย้อนกลับได้
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              alignment: AlignmentDirectional(0.0, -1.0),
              image: Image.asset(
                'assets/images/rgbg.png',
              ).image,
            ),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x4DFFFFFF), Color(0x00FFFFFF)],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(0.0, -1.0),
                end: AlignmentDirectional(0, 1.0),
              ),
            ),
            child: Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.9,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: AlignmentDirectional(0.0, -1.0),
                    image: Image.asset(
                      'assets/images/bg.png',
                    ).image,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 100.0, 16.0, 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              // decoration: BoxDecoration(
                              //   color: FlutterFlowTheme.of(context)
                              //       .secondaryBackground,
                              //   shape: BoxShape.circle,
                              // ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/logo.png', 
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'With modern security system with \nVenus Sentinel',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .titleMediumFamily),
                                  ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'or, let us take on the job from start to finish.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .labelMediumFamily),
                                      ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    // prefs =
                                    //     await SharedPreferences.getInstance();
                                    // late List<Officer>? userLoginData;
                                    // userLoginData =
                                    //     await OfficerController.getLoginOfficer(
                                    //         'officerName', '');

                                    // if (userLoginData.isNotEmpty) {
                                    //   if (userLoginData[0].is_resident == 'Y' ) {
                                    //     await prefs.setString('officer_name',
                                    //         '${userLoginData[0].officer_pname}${userLoginData[0].officer_fname!} ${userLoginData[0].officer_lname!}');
                                    //     await prefs.setString(
                                    //         'officer_login_name',
                                    //         userLoginData[0]
                                    //             .officer_login_name!);
                                    //     await prefs.setString(
                                    //         'officer_login_password_md5',
                                    //         userLoginData[0]
                                    //             .officer_login_password_md5!);
                                    //     await prefs.setString(
                                    //         'officer_id',
                                    //         userLoginData[0]
                                    //             .officer_id!
                                    //             .toString());

                                    //     // await OfficerPictureController.saveOfficerPicture(officerPictureModel).then((value) => print('saveComplete'));
                                    //   }else if
                                    //    (userLoginData[0].is_security_guard == 'Y' ) {
                                    //     await prefs.setString('officer_name',
                                    //         '${userLoginData[0].officer_pname}${userLoginData[0].officer_fname!} ${userLoginData[0].officer_lname!}');
                                    //     await prefs.setString(
                                    //         'officer_login_name',
                                    //         userLoginData[0]
                                    //             .officer_login_name!);
                                    //     await prefs.setString(
                                    //         'officer_login_password_md5',
                                    //         userLoginData[0]
                                    //             .officer_login_password_md5!);
                                    //     await prefs.setString(
                                    //         'officer_id',
                                    //         userLoginData[0]
                                    //             .officer_id!
                                    //             .toString());

                                    // await OfficerPictureController.saveOfficerPicture(officerPictureModel).then((value) => print('saveComplete'));
//                                }

                                    // print('userLoginData ' +
                                    //     userLoginData[0]
                                    //         .officer_id
                                    //         .toString());

                                    // await OfficerPictureController
                                    //         .getOfficerPictureFromID(
                                    //             userLoginData[0].officer_id!)
                                    //     .then((value) async {
                                    //   if (value.image != null) {
                                    //     // แปลง Uint8List เป็น Base64 string
                                    //     String base64String =
                                    //         base64Encode(value.image!);
                                    //     await prefs.setString(
                                    //         'officerImage', base64String);
                                    //     print(
                                    //         base64String); // Base64 string ของรูปภาพ
                                    //     print(
                                    //         'userLoginData ' + base64String);
                                    //   } else {
                                    //     await prefs.setString(
                                    //         'officerImage', '');
                                    //   }
                                    // });

                                    context.pushNamed('signin');

                                    // print('userLoginData ' + userLoginData.length!.toString());
                                    // }

                                    // context.pushNamed('signin');
                                  },
                                  text: 'Sign In',
                                  options: FFButtonOptions(
                                    width: 400.0,
                                    height: 56.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily),
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed('signup');
                                  },
                                  text: 'Sign Up',
                                  options: FFButtonOptions(
                                    width: 400.0,
                                    height: 56.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily),
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 24.0)),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              SharedPreferencesControllerCenter
                                  .instance.version.value,
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodySmallFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodySmallFamily),
                                  ),
                            ),
                          ),
                        ]
                            .divide(SizedBox(height: 60.0))
                            .addToStart(SizedBox(height: 32.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
