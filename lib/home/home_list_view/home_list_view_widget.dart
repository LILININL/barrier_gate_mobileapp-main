import 'dart:convert';

import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/car/my_project_list_widget/my_project_list_widget_widget.dart';
import 'package:barrier_gate/car/register_external_person_view/register_external_person_view_widget.dart';
import 'package:barrier_gate/function_untils/controller/02BR_MB_ResidentListVillage_controller.dart';
import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:barrier_gate/function_untils/model/02BR_MB_ResidentListVillage_model.dart';
import 'package:barrier_gate/function_untils/model/officer_model.dart';
import 'package:barrier_gate/utils/navbar_widget/navigation_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home/widget/item_home_widget/item_home_widget_widget.dart';
import '/utils/navbar_widget/navbar_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_list_view_model.dart';
export 'home_list_view_model.dart';

class HomeListViewWidget extends StatefulWidget {
  const HomeListViewWidget({super.key});

  @override
  State<HomeListViewWidget> createState() => _HomeListViewWidgetState();
}

class _HomeListViewWidgetState extends State<HomeListViewWidget> {
  late HomeListViewModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var officerid = RxnString();
  var officerName = RxnString();
  var officerLoginName = RxnString();
  var base64ImageString = RxnString();
  var officeremail = RxnString();
  Rxn<Uint8List> imageBytes = Rxn<Uint8List>();

  final prefs = Get.find<SharedPreferencesControllerCenter>();

  late List<BrMbResidentListVillageModel02> residentListVillageData = [];
  // ข้อมูลสมาชิกลูกบ้าน

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeListViewModel());
    doGetSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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

  Future<List<BrMbResidentListVillageModel02>> doRefreshData() async {
    // base64ImageString = prefs.getString('officer_id');
    return residentListVillageData =
        await BrMbResidentListVillageModel02Controller
            .getBrMbResidentListVillageModel02s(prefs.getString('officer_id'));
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
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent1,
                                shape: BoxShape.circle,
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
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
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
                            // Container(
                            //   width: 48.0,
                            //   height: 48.0,
                            //   decoration: BoxDecoration(),
                            // ),
                          ]
                              .divide(SizedBox(width: 16.0))
                              .around(SizedBox(width: 16.0)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(
                            0,
                            8.0,
                            0,
                            0.0,
                          ),
                          scrollDirection: Axis.vertical,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed('scan_QR_code');
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    alignment: AlignmentDirectional(1.0, 1.0),
                                    image: Image.asset(
                                      'assets/images/qrcod.png',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent1,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Icon(
                                                    Icons.qr_code_scanner,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 14.0,
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
                                                      'ลงทะเบียน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                              ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 8.0)),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'เพิ่มโครงการของคุณใหม่ด้วยการสแกนคิวอาร์โค้ด',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                      ),
                                    ].divide(SizedBox(height: 16.0)),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'โครงการของฉัน',
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
                            ),
                            FutureBuilder<List<BrMbResidentListVillageModel02>>(
                              future: doRefreshData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return (snapshot.data!.length != 0)
                                      ? ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: snapshot.data?.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final itemsData =
                                                snapshot.data![index];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyProjectListWidgetWidget(
                                                            residentDetail:
                                                                itemsData,
                                                          )),
                                                );
                                              },
                                              child: wrapWithModel(
                                                model:
                                                    _model.itemHomeWidgetModel1,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 8.0),
                                                  child: ItemHomeWidgetWidget(
                                                      icon: Icon(
                                                        Icons.home_filled,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        size: 14.0,
                                                      ),
                                                      data: itemsData),
                                                ),
                                              ),
                                            );
                                          })
                                      : Center(child: Text('ไม่มีข้อมูล'));
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          "พบปัญหาการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง ! " +
                                              snapshot.error.toString()));
                                  // Text("Error: ${snapshot.error}"));
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                    // Expanded()
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Builder(
                    builder: (context) {
                      final navigationController =
                          Provider.of<NavigationController>(context,
                              listen: false);
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
      ),
    );
  }
}
