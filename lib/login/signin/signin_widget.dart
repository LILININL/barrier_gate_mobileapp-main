import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:barrier_gate/function_untils/controller/officer_picture_controller.dart';
import 'package:barrier_gate/function_untils/model/officer_model.dart';
import 'package:barrier_gate/rpp/externalvehicleregistration/externalvehicleregistration_widget.dart';
import 'package:barrier_gate/utils/navbar_widget/navigation_controller.dart';
import 'package:barrier_gate/utils/popup_issue/popup_issue_widget.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/login/widget/buttonsheet_forgot_password_widget/buttonsheet_forgot_password_widget_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signin_model.dart';
export 'signin_model.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SigninWidget extends StatefulWidget {
  const SigninWidget({super.key});

  @override
  State<SigninWidget> createState() => _SigninWidgetState();
}

class _SigninWidgetState extends State<SigninWidget> {
  late SigninModel _model;
  final prefs = Get.find<SharedPreferencesControllerCenter>();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var phonntoken = RxnString();

  OfficerPictureController Offi = Get.put(OfficerPictureController());

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SigninModel());
    doGetSharedPreferences();
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> doGetSharedPreferences() async {
    phonntoken.value = await prefs.getString('fcmToken');
  }

  Future<void> onLoginSuccess(String role, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('officer_role', role);

    // อัปเดต NavigationController เพื่อให้ Navbar โหลดใหม่
    final navigationController =
        Provider.of<NavigationController>(context, listen: false);
    navigationController.setOfficerRole(role);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFBBF4F6),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: AlignmentDirectional(0.0, -1.0),
            image: Image.asset(
              'assets/images/bg4_1.png',
            ).image,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66FFFFFF), Color(0x00FFFFFF)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: 90.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).secondaryBackground,
                      Color(0x00FFFFFF)
                    ],
                    stops: [0.0, 1.0],
                    begin: AlignmentDirectional(0.0, -1.0),
                    end: AlignmentDirectional(0, 1.0),
                  ),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 20.0,
                          ),
                          onPressed: () async {
                            context.safePop();
                          },
                        ),
                      ),
                      Expanded(
                        child: wrapWithModel(
                          model: _model.headerWidgetModel,
                          updateCallback: () => safeSetState(() {}),
                          child: HeaderWidgetWidget(
                            header: 'Welcome',
                          ),
                        ),
                      ),
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(),
                      ),
                    ]
                        .divide(SizedBox(width: 16.0))
                        .around(SizedBox(width: 16.0)),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8.0,
                            color: Color(0x33000000),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                'สวัสดี\nเริ่มต้นใช้งาน Venus Sentinel เพื่อสัมผัสประสบการณ์ดีๆ',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily),
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextFormField(
                                  controller: _model.textController1,
                                  focusNode: _model.textFieldFocusNode1,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'User name',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelLargeFamily,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w300,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .labelLargeFamily),
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyLargeFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily),
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).accent1,
                                  validator: (value) {
                                    // print('object');
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _model.textController2,
                                  focusNode: _model.textFieldFocusNode2,
                                  autofocus: true,
                                  obscureText: !_model.passwordVisibility,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelLargeFamily,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w300,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .labelLargeFamily),
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    suffixIcon: InkWell(
                                      onTap: () => safeSetState(
                                        () => _model.passwordVisibility =
                                            !_model.passwordVisibility,
                                      ),
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyLargeFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily),
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).accent1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    Navigator.pop(context);
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      isDismissible: false,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child:
                                              ButtonsheetForgotPasswordWidgetWidget(),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  },
                                  child: Text(
                                    'Forgot your password?',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w300,
                                          decoration: TextDecoration.underline,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
//                                 InkWell(
//                                   splashColor: Colors.transparent,
//                                   focusColor: Colors.transparent,
//                                   hoverColor: Colors.transparent,
//                                   highlightColor: Colors.transparent,
//                                   onTap: () async {
//                                     // await Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(
//                                     //     builder: (context) => OCRScreen(),
//                                     //   ),
//                                     // );
//                                     // final cameras = await availableCameras();
//                                     // final firstCamera = cameras.first;
//                                     // await Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(
//                                     //     builder: (context) =>
//                                     //         ExternalvehicleregistrationWidget(),
//                                     //   ),
//                                     // );
//                                     // await Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(
//                                     //     builder: (context) => OCRScreen(),
//                                     //   ),
//                                     // );

// //                                    context.pushNamed('home_RPP');
//                                     // context.pushNamed('externalvehicleregistration');
//                                   },
//                                   child: Text(
//                                     'รปภ',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily:
//                                               FlutterFlowTheme.of(context)
//                                                   .bodyMediumFamily,
//                                           letterSpacing: 0.0,
//                                           fontWeight: FontWeight.w300,
//                                           decoration: TextDecoration.underline,
//                                           useGoogleFonts: GoogleFonts.asMap()
//                                               .containsKey(
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyMediumFamily),
//                                         ),
//                                   ),
//                                 ),
                              ].divide(SizedBox(height: 24.0)),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    late List<Officer>? userLoginData;

                                    var bytes = utf8.encode(_model
                                        .textController2
                                        .text); // แปลงเป็น bytes
                                    var digest =
                                        md5.convert(bytes); // คำนวณ MD5 hash

                                    userLoginData =
                                        await OfficerController.getLoginOfficer(
                                      _model.textController1.text,
                                      digest.toString().toUpperCase(),
                                    );

                                    if (userLoginData.isNotEmpty) {
                                      final officer = userLoginData[0];

                                      // กรณี Resident
                                      if (officer.is_resident == 'Y') {
                                        await prefs.setString(
                                            'officer_role', 'rss');

                                        await prefs.setString('officer_name',
                                            '${officer.officer_pname} ${officer.officer_fname!} ${officer.officer_lname!}');

                                        await prefs.setString('officer_email',
                                            officer.officer_email!);
                                        await prefs.setString(
                                            'officer_login_name',
                                            officer.officer_login_name!);
                                        await prefs.setString(
                                            'officer_login_password_md5',
                                            officer
                                                .officer_login_password_md5!);
                                        await prefs.setString('officer_id',
                                            officer.officer_id!.toString());
                                        await prefs.setString('AutoLogin', 'Y');

                                        await Offi.getOfficerPictures(
                                                'officer_id=${officer.officer_id}')
                                            .then((_) async {
                                          if (Offi.officerPictures.isNotEmpty) {
                                            var officerPicture =
                                                Offi.officerPictures.first;

                                            if (officerPicture.image != null) {
                                              String base64String =
                                                  base64Encode(
                                                      officerPicture.image!);
                                              await prefs.setString(
                                                  'officerImage', base64String);
                                            } else {
                                              await prefs.setString(
                                                  'officerImage', '');
                                            }
                                          } else {
                                            await prefs.setString(
                                                'officerImage', '');
                                          }
                                        });
                                        OfficerController.updatetokenPP(
                                            officer.officer_id!);

                                        await onLoginSuccess('rss', context);
                                        context.pushNamed('home_list_view');

                                        // context
                                        //     .pushNamed(
                                        //   'home_list_view',
                                        // )
                                        //     .then((_) {
                                        //   Provider.of<NavigationController>(
                                        //           context,
                                        //           listen: false)
                                        //       .setOfficerRole('rss');
                                        // });
                                      }
                                      // กรณี Security Guard
                                      else if (officer.is_security_guard ==
                                          'Y') {
                                        await prefs.setString(
                                            'officer_role', 'rpp');
                                        OfficerController.updatetokenPP(
                                            officer.officer_id!);

                                        await prefs.setString('officer_name',
                                            '${officer.officer_pname} ${officer.officer_fname!} ${officer.officer_lname!}');
                                        await prefs.setString(
                                            'officer_login_name',
                                            officer.officer_login_name!);
                                        await prefs.setString(
                                            'officer_login_password_md5',
                                            officer
                                                .officer_login_password_md5!);
                                        await prefs.setString('officer_id',
                                            officer.officer_id!.toString());
                                        await prefs.setString(
                                            'villageproject_id',
                                            officer.villageproject_id
                                                .toString());
                                        await prefs.setString('AutoLogin', 'Y');

                                        await Offi.getOfficerPictures(
                                                'officer_id=${officer.officer_id}')
                                            .then((_) async {
                                          if (Offi.officerPictures.isNotEmpty) {
                                            var officerPicture =
                                                Offi.officerPictures.first;

                                            if (officerPicture.image != null) {
                                              String base64String =
                                                  base64Encode(
                                                      officerPicture.image!);
                                              await prefs.setString(
                                                  'officerImage', base64String);
                                            } else {
                                              await prefs.setString(
                                                  'officerImage', '');
                                            }
                                          } else {
                                            await prefs.setString(
                                                'officerImage', '');
                                          }
                                        });

                                        await onLoginSuccess('rpp', context);
                                        context.pushNamed('home_RPP');

                                        // context
                                        //     .pushNamed(
                                        //   'home_RPP',
                                        // )
                                        //     .then((_) {
                                        //   Provider.of<NavigationController>(
                                        //           context,
                                        //           listen: false)
                                        //       .setOfficerRole('rpp');
                                        // });
                                      }
                                    } else {
                                      // กรณีข้อมูลไม่ถูกต้อง
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        isDismissible: false,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: PopupIssueWidget(
                                              messageIssue:
                                                  "Username หรือ Password ไม่ถูกต้อง",
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));

                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.pop(context);
                                      });
                                    }
                                  }
                                },
                                text: 'Sign In',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 56.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
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
                          ]
                              .divide(SizedBox(height: 24.0))
                              .around(SizedBox(height: 24.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
