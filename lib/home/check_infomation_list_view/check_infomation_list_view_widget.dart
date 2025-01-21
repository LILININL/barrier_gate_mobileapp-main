import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/controller/01BR_MB_VillageProject__controller.dart';
import 'package:barrier_gate/function_untils/controller/villageproject_register_qr_controller.dart';
import 'package:barrier_gate/function_untils/controller/villageproject_resident_controller.dart';
import 'package:barrier_gate/function_untils/model/01BR_MB_VillageProject__model.dart';
import 'package:barrier_gate/function_untils/model/villageproject_resident_model.dart';
import 'package:barrier_gate/home/home_list_view/home_list_view_widget.dart';
import 'package:barrier_gate/utils/popup_loading/popup_loading_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/popup_sucess_conect_staff/popup_sucess_conect_staff_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'check_infomation_list_view_model.dart';
export 'check_infomation_list_view_model.dart';

class CheckInfomationListViewWidget extends StatefulWidget {
  const CheckInfomationListViewWidget(
      {super.key,
      required this.villageproject_detail_id,
      required this.officerID});
  final int villageproject_detail_id;
  final int officerID;

  @override
  State<CheckInfomationListViewWidget> createState() =>
      _CheckInfomationListViewWidgetState();
}

class _CheckInfomationListViewWidgetState
    extends State<CheckInfomationListViewWidget> {
  late CheckInfomationListViewModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late List<BrMbVillageProjectModel01> villageProjectModelData = [];
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckInfomationListViewModel());
    // doRefreshData();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<List<BrMbVillageProjectModel01>> doRefreshData() async {
    return villageProjectModelData =
        await BrMbVillageProjectModel01Controller.getBrMbVillageProjectModel01s(
            widget.villageproject_detail_id.toString());
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
                            header: 'ยืนยันข้อมูล',
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
                        children: [
                          FutureBuilder<List<BrMbVillageProjectModel01>>(
                            future: doRefreshData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: ListView(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 24.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Text(
                                          'กรุณาตรวจสอบข้อมูลโครงการและที่อยู่',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w300,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0x0C00613A),
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            image: Image.asset(
                                              'assets/images/project.png',
                                            ).image,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24.0),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 24.0,
                                                    height: 24.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent1,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Icon(
                                                        Icons.cottage_outlined,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        size: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          'โครงการ',
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyLargeFamily),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 8.0)),
                                              ),
                                              Text(
                                                villageProjectModelData[0]
                                                    .villageproject_registered_name!,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
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
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0x0C00613A),
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            image: Image.asset(
                                              'assets/images/home.png',
                                            ).image,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24.0),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 24.0,
                                                    height: 24.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent1,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Icon(
                                                        Icons.add_home_outlined,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        size: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          'บ้านเลขที่',
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyLargeFamily),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 8.0)),
                                              ),
                                              Text(
                                                villageProjectModelData[0]
                                                        .addrpart! +
                                                    ' ซอย ' +
                                                    (villageProjectModelData[0]
                                                            .addr_soi ??
                                                        '-'),
                                                // '',
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
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
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0x0C00613A),
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            image: Image.asset(
                                              'assets/images/pin.png',
                                            ).image,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24.0),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 24.0,
                                                    height: 24.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent1,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Icon(
                                                        Icons.pin_drop_outlined,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        size: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          'ที่ตั้ง',
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyLargeFamily),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 8.0)),
                                              ),
                                              Text(
                                                '${villageProjectModelData[0].chwpart?.trim().isEmpty ?? true ? '' : villageProjectModelData[0].chwpart!} ${villageProjectModelData[0].amppart?.trim().isEmpty ?? true ? '' : villageProjectModelData[0].amppart!} ${villageProjectModelData[0].tmbpart?.trim().isEmpty ?? true ? '' : villageProjectModelData[0].tmbpart!} ${villageProjectModelData[0].postal_code?.trim().isEmpty ?? true ? '' : villageProjectModelData[0].postal_code!}',
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
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
                                    ].divide(SizedBox(height: 24.0)),
                                  ),
                                );
                                // return (snapshot.data!.length != 0)
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        "พบปัญหาการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง !"));
                                // Text("Error: ${snapshot.error}"));
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          // Expanded(
                          //   child: ListView(
                          //     padding: EdgeInsets.symmetric(vertical: 24.0),
                          //     shrinkWrap: true,
                          //     scrollDirection: Axis.vertical,
                          //     children: [
                          //       Align(
                          //         alignment: AlignmentDirectional(0.0, 0.0),
                          //         child: Text(
                          //           'กรุณาตรวจสอบข้อมูลโครงการและที่อยู่',
                          //           textAlign: TextAlign.center,
                          //           style: FlutterFlowTheme.of(context).bodyMedium.override(
                          //                 fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          //                 letterSpacing: 0.0,
                          //                 fontWeight: FontWeight.w300,
                          //                 useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          //               ),
                          //         ),
                          //       ),
                          //       Container(
                          //         width: double.infinity,
                          //         decoration: BoxDecoration(
                          //           color: Color(0x0C00613A),
                          //           image: DecorationImage(
                          //             fit: BoxFit.contain,
                          //             alignment: AlignmentDirectional(1.0, 1.0),
                          //             image: Image.asset(
                          //               'assets/images/project.png',
                          //             ).image,
                          //           ),
                          //           borderRadius: BorderRadius.circular(24.0),
                          //         ),
                          //         child: Padding(
                          //           padding: EdgeInsets.all(16.0),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.max,
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Row(
                          //                 mainAxisSize: MainAxisSize.max,
                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                          //                 children: [
                          //                   Container(
                          //                     width: 24.0,
                          //                     height: 24.0,
                          //                     decoration: BoxDecoration(
                          //                       color: FlutterFlowTheme.of(context).accent1,
                          //                       shape: BoxShape.circle,
                          //                     ),
                          //                     child: Align(
                          //                       alignment: AlignmentDirectional(0.0, 0.0),
                          //                       child: Icon(
                          //                         Icons.cottage_outlined,
                          //                         color: FlutterFlowTheme.of(context).primaryBackground,
                          //                         size: 12.0,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Column(
                          //                     mainAxisSize: MainAxisSize.max,
                          //                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                     children: [
                          //                       Align(
                          //                         alignment: AlignmentDirectional(0.0, 0.0),
                          //                         child: Text(
                          //                           'โครงการ',
                          //                           textAlign: TextAlign.center,
                          //                           maxLines: 1,
                          //                           style: FlutterFlowTheme.of(context).bodyLarge.override(
                          //                                 fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                          //                                 letterSpacing: 0.0,
                          //                                 useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                          //                               ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ].divide(SizedBox(width: 8.0)),
                          //               ),
                          //               Text(
                          //                 villageProjectModelData[0].villageproject_registered_name!,
                          //                 textAlign: TextAlign.center,
                          //                 maxLines: 1,
                          //                 style: FlutterFlowTheme.of(context).bodyMedium.override(
                          //                       fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          //                       letterSpacing: 0.0,
                          //                       useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          //                     ),
                          //               ),
                          //             ].divide(SizedBox(height: 16.0)),
                          //           ),
                          //         ),
                          //       ),
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           color: Color(0x0C00613A),
                          //           image: DecorationImage(
                          //             fit: BoxFit.contain,
                          //             alignment: AlignmentDirectional(1.0, 1.0),
                          //             image: Image.asset(
                          //               'assets/images/home.png',
                          //             ).image,
                          //           ),
                          //           borderRadius: BorderRadius.circular(24.0),
                          //         ),
                          //         child: Padding(
                          //           padding: EdgeInsets.all(16.0),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.max,
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Row(
                          //                 mainAxisSize: MainAxisSize.max,
                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                          //                 children: [
                          //                   Container(
                          //                     width: 24.0,
                          //                     height: 24.0,
                          //                     decoration: BoxDecoration(
                          //                       color: FlutterFlowTheme.of(context).accent1,
                          //                       shape: BoxShape.circle,
                          //                     ),
                          //                     child: Align(
                          //                       alignment: AlignmentDirectional(0.0, 0.0),
                          //                       child: Icon(
                          //                         Icons.add_home_outlined,
                          //                         color: FlutterFlowTheme.of(context).primaryBackground,
                          //                         size: 12.0,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Column(
                          //                     mainAxisSize: MainAxisSize.max,
                          //                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                     children: [
                          //                       Align(
                          //                         alignment: AlignmentDirectional(0.0, 0.0),
                          //                         child: Text(
                          //                           'บ้านเลขที่',
                          //                           textAlign: TextAlign.center,
                          //                           maxLines: 1,
                          //                           style: FlutterFlowTheme.of(context).bodyLarge.override(
                          //                                 fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                          //                                 letterSpacing: 0.0,
                          //                                 useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                          //                               ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ].divide(SizedBox(width: 8.0)),
                          //               ),
                          //               Text(
                          //                 villageProjectModelData[0].addrpart! + ' ซอย ' + (villageProjectModelData[0].addr_soi ?? '-'),
                          //                 textAlign: TextAlign.center,
                          //                 maxLines: 1,
                          //                 style: FlutterFlowTheme.of(context).bodyMedium.override(
                          //                       fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          //                       letterSpacing: 0.0,
                          //                       useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          //                     ),
                          //               ),
                          //             ].divide(SizedBox(height: 16.0)),
                          //           ),
                          //         ),
                          //       ),
                          //       Container(
                          //         decoration: BoxDecoration(
                          //           color: Color(0x0C00613A),
                          //           image: DecorationImage(
                          //             fit: BoxFit.contain,
                          //             alignment: AlignmentDirectional(1.0, 1.0),
                          //             image: Image.asset(
                          //               'assets/images/pin.png',
                          //             ).image,
                          //           ),
                          //           borderRadius: BorderRadius.circular(24.0),
                          //         ),
                          //         child: Padding(
                          //           padding: EdgeInsets.all(16.0),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.max,
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Row(
                          //                 mainAxisSize: MainAxisSize.max,
                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                          //                 children: [
                          //                   Container(
                          //                     width: 24.0,
                          //                     height: 24.0,
                          //                     decoration: BoxDecoration(
                          //                       color: FlutterFlowTheme.of(context).accent1,
                          //                       shape: BoxShape.circle,
                          //                     ),
                          //                     child: Align(
                          //                       alignment: AlignmentDirectional(0.0, 0.0),
                          //                       child: Icon(
                          //                         Icons.pin_drop_outlined,
                          //                         color: FlutterFlowTheme.of(context).primaryBackground,
                          //                         size: 12.0,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Column(
                          //                     mainAxisSize: MainAxisSize.max,
                          //                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                     children: [
                          //                       Align(
                          //                         alignment: AlignmentDirectional(0.0, 0.0),
                          //                         child: Text(
                          //                           'ที่ตั้ง',
                          //                           textAlign: TextAlign.center,
                          //                           maxLines: 1,
                          //                           style: FlutterFlowTheme.of(context).bodyLarge.override(
                          //                                 fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                          //                                 letterSpacing: 0.0,
                          //                                 useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                          //                               ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ].divide(SizedBox(width: 8.0)),
                          //               ),
                          //               Text(
                          //                 villageProjectModelData[0].chwpart! + ' ' + villageProjectModelData[0].amppart! + ' ' + villageProjectModelData[0].tmbpart! + ' ' + villageProjectModelData[0].postal_code!,
                          //                 textAlign: TextAlign.start,
                          //                 style: FlutterFlowTheme.of(context).bodyMedium.override(
                          //                       fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          //                       letterSpacing: 0.0,
                          //                       useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          //                     ),
                          //               ),
                          //             ].divide(SizedBox(height: 16.0)),
                          //           ),
                          //         ),
                          //       ),
                          //     ].divide(SizedBox(height: 24.0)),
                          //   ),
                          // ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: false,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: PopupLoadingWidget(),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));

                                // บันทึกข้อมูลลง ตาราง villageproject_resident
                                VillageprojectResident
                                    villageprojectResidentModel =
                                    VillageprojectResident.newInstance();
                                villageprojectResidentModel
                                        .villageproject_resident_id =
                                    await serviceLocator<EHPApi>()
                                        .getSerialNumber(
                                            'villageproject_resident_id',
                                            'villageproject_resident',
                                            'villageproject_resident_id');
                                villageprojectResidentModel
                                        .villageproject_detail_id =
                                    widget.villageproject_detail_id;
                                villageprojectResidentModel.officer_id =
                                    widget.officerID;
                                villageprojectResidentModel
                                        .resident_register_datetime =
                                    DateTime.now();

                                await VillageprojectResidentController
                                        .saveVillageprojectResident(
                                            villageprojectResidentModel)
                                    .then((value) async {
                                  Navigator.pop(context);
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    barrierColor: Color(0x3F000000),
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: PopupSucessConectStaffWidget(),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  await Future.delayed(
                                      const Duration(milliseconds: 2500));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeListViewWidget()),
                                  );
                                });
                              },
                              text: 'ยืนยัน',
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 16.0)),
          ),
        ),
      ),
    );
  }
}
