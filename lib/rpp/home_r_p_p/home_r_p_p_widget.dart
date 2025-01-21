import 'dart:convert';

import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:barrier_gate/function_untils/model/officer_model.dart';
import 'package:barrier_gate/utils/navbar_widget/navbar_widget_model.dart';
import 'package:barrier_gate/utils/navbar_widget/navbar_widget_widget.dart';
import 'package:barrier_gate/utils/navbar_widget/navigation_controller.dart';
import 'package:get/get.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/navbar_r_p_p_widget/navbar_r_p_p_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_r_p_p_model.dart';
export 'home_r_p_p_model.dart';

class HomeRPPWidget extends StatefulWidget {
  const HomeRPPWidget({super.key});

  @override
  State<HomeRPPWidget> createState() => _HomeRPPWidgetState();
}

class _HomeRPPWidgetState extends State<HomeRPPWidget> {
  late HomeRPPModel _model;
  late Future<void> onetimeload;
  var officerid = RxnString();
  var officerName = RxnString();
  var officerLoginName = RxnString();
  var base64ImageString = RxnString();
  var officeremail = RxnString();
  Rxn<Uint8List> imageBytes = Rxn<Uint8List>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeRPPModel());
    onetimeload = doGetSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> doGetSharedPreferences() async {
    final prefs = Get.find<SharedPreferencesControllerCenter>();

    officerid.value = await prefs.getString('officer_id');

    if (officerid.value != null) {
      try {
        // ดึงข้อมูล officer จาก SharedPreferences
        String? cachedName = await prefs.getString('officer_name');
        String? cachedEmail = await prefs.getString('officer_email');

        // ดึงข้อมูลจากฐานข้อมูล
        Officer officer = await OfficerController.getOfficerFromID(
          int.parse(officerid.value!),
        );

        // เปรียบเทียบข้อมูล
        if (officer.officer_name != null &&
            officer.officer_name == cachedName &&
            officer.officer_email != null &&
            officer.officer_email == cachedEmail) {
          print('Data matches, using cache');
          officerName.value = cachedName!;
          officeremail.value = cachedEmail!;
        } else {
          print('Data mismatch, updating cache');
          officerName.value = officer.officer_name ?? cachedName ?? '';
          officeremail.value = officer.officer_email ?? cachedEmail ?? '';

          // อัปเดต SharedPreferences เมื่อข้อมูลไม่ตรง
          await prefs.setString('officer_name', officer.officer_name ?? '');
          await prefs.setString('officer_email', officer.officer_email ?? '');
        }

        base64ImageString.value = await prefs.getString('officerImage');

        if (base64ImageString.value != null &&
            base64ImageString.value!.isNotEmpty) {
          imageBytes.value = base64Decode(base64ImageString.value!);
        }
      } catch (e) {
        print('Error fetching officer data: $e');
      }
    } else {
      print('No officer_id found in SharedPreferences');
    }
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
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: AlignmentDirectional(0.0, -1.0),
            image: Image.asset(
              'assets/images/bg1.png',
            ).image,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x7FF5F5F5),
                FlutterFlowTheme.of(context).secondaryBackground
              ],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: 90.0,
                    decoration: BoxDecoration(),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).accent1,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Container(
                                  width: 56.0,
                                  height: 56.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Obx(() {
                                    if (imageBytes.value != null &&
                                        imageBytes.value!.isNotEmpty) {
                                      return Image.memory(
                                        imageBytes.value!,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return Image.asset(
                                        'assets/images/user.png',
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  }),
                                )),
                          ),
                          Expanded(
                            child: Container(
                              width: 100.0,
                              height: 56.0,
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    return Text(officerName.value ?? '-',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeFamily),
                                            ));
                                  }),
                                ],
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
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        16.0,
                        0,
                        150.0,
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                'CheckpointList_RPP_list_view',
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                  ),
                                },
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  alignment: AlignmentDirectional(1.0, 1.0),
                                  image: Image.asset(
                                    'assets/images/car2.png',
                                  ).image,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x1A000000),
                                    offset: Offset(
                                      0.0,
                                      0.0,
                                    ),
                                  )
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context).accent1,
                                    FlutterFlowTheme.of(context).primary
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(0.56, -1.0),
                                  end: AlignmentDirectional(-0.56, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 24.0,
                                              height: 24.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.location_searching,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  size: 12.0,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    'จุดตรวจ',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLargeFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'การตรวจตรา สำหรับ เจ้าหน้ารักษาความปลอดภัย',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Visitorcarregistration');
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  alignment: AlignmentDirectional(1.0, 1.0),
                                  image: Image.asset(
                                    'assets/images/car2.png',
                                  ).image,
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFEB8031),
                                    FlutterFlowTheme.of(context).secondary
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(0.56, -1.0),
                                  end: AlignmentDirectional(-0.56, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 24.0,
                                              height: 24.0,
                                              decoration: BoxDecoration(
                                                color: Color(0x3BFFFFFF),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.add_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  size: 12.0,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    'ลงทะเบียนรถยนต์ผู้มาติดต่อ',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'เพิ่มรถยนต์บุคคลภายนอกที่เข้ามาติดต่อ',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily),
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Builder(
                  builder: (context) {
                    // final navigationController = Provider.of<
                    //         NavigationController>(context,
                    //     listen:
                    //         true); // ต้องใช้ listen: true เพื่ออัปเดตอัตโนมัติ
                    return wrapWithModel(
                      model: NavbarWidgetModel(),
                      updateCallback: () => safeSetState(() {}),
                      child: NavbarWidgetWidget(
                        slectpage: 1,
                        hide: false,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
