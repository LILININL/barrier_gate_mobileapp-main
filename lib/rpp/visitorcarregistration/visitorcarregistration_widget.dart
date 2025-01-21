import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/rpp/visitorcarregistration/controller/villageproject_detail_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rpp/item_home_in_project/item_home_in_project_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'visitorcarregistration_model.dart';
export 'visitorcarregistration_model.dart';

class VisitorcarregistrationWidget extends StatefulWidget {
  const VisitorcarregistrationWidget({super.key});

  @override
  State<VisitorcarregistrationWidget> createState() =>
      _VisitorcarregistrationWidgetState();
}

class _VisitorcarregistrationWidgetState
    extends State<VisitorcarregistrationWidget> {
  late VisitorcarregistrationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? villageprojectID = '';
  String? officerID = '';
  String? Searchhome;

  VillageprojectDetailController villageprojectDetailController =
      Get.put(VillageprojectDetailController());

  @override
  void initState() {
    super.initState();
    getProjectVillage();
    _model = createModel(context, () => VisitorcarregistrationModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  getProjectVillage() async {
    villageprojectID = (await SharedPreferencesControllerCenter()
            .getString('villageproject_id')) ??
        '';
    officerID =
        (await SharedPreferencesControllerCenter().getString('officer_id')) ??
            '';

    await villageprojectDetailController
        .fetchVillageprojectDetails(villageprojectID!);
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
              Container(
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                      onPressed: () async {
                                        context.pushNamed('home_RPP');
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: wrapWithModel(
                                      model: _model.headerWidgetModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: HeaderWidgetWidget(
                                        header: 'ลงทะเบียนรถยนต์ผู้มาติดต่อ',
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
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _model.textController,
                                          focusNode: _model.textFieldFocusNode,
                                          onChanged: (value) {
                                            villageprojectDetailController
                                                .searchVillageDetails(value);
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeFamily,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                          .containsKey(
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLargeFamily),
                                                    ),
                                            hintText:
                                                'ค้นหา...เลขที่บ้าน หรือ ซอย ......',
                                            hintStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLargeFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w200,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeFamily),
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00E6E6E6),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00F44336),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00F44336),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            prefixIcon: Icon(
                                              Icons.search_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              size: 20.0,
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLargeFamily),
                                              ),
                                          validator: _model
                                              .textControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                                Expanded(
                                  child: Obx(() {
                                    if (villageprojectDetailController
                                        .isLoading.value) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (villageprojectDetailController
                                        .villageprojectDetailListData.isEmpty) {
                                      return Center(
                                        child: Text('ไม่มีข้อมูล'),
                                      );
                                    }

                                    if (villageprojectDetailController
                                        .filteredVillageDetails.isEmpty) {
                                      return Center(
                                        child: Text('ไม่พบข้อมูลที่ค้นหา'),
                                      );
                                    }

                                    return ListView.builder(
                                      padding: EdgeInsets.only(
                                          top: 16, bottom: 10.0),
                                      itemCount: villageprojectDetailController
                                          .filteredVillageDetails.length,
                                      itemBuilder: (context, index) {
                                        final detail =
                                            villageprojectDetailController
                                                .filteredVillageDetails[index];
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            final detailController =
                                                Get.put(DetailController());

                                            detailController.setDetails(
                                              detail.house_number ?? '',
                                              detail.soi ?? '',
                                              detail.villageproject_resident_id
                                                      ?.toString() ??
                                                  '',
                                              detail.villageproject_detail_id
                                                      ?.toString() ??
                                                  '',
                                            );

                                            print(detail
                                                .villageproject_detail_id
                                                ?.toString());

                                            context.pushNamed(
                                                'externalvehicleregistration');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: wrapWithModel(
                                              model: _model
                                                  .itemHomeInProjectModel1,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: ItemHomeInProjectWidget(
                                                homenumber:
                                                    'บ้านเลขที่ ${detail.house_number}',
                                                alley: 'ซอย ${detail.soi}',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
