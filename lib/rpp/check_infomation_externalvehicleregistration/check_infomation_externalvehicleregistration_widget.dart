import 'package:barrier_gate/function_untils/controller/vehicle_visitor_controller.dart';
import 'package:barrier_gate/function_untils/model/vehicle_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_visitor_model.dart';
import 'package:barrier_gate/rpp/check_infomation_externalvehicleregistration/Controller/aotu_plate_medol.dart';
import 'package:barrier_gate/rpp/check_infomation_externalvehicleregistration/Controller/auto_plate_controller.dart';
import 'package:barrier_gate/rpp/visitorcarregistration/controller/villageproject_detail_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rpp/image_car_licenseplate/image_car_licenseplate_widget.dart';
import '/rpp/image_id_card/image_id_card_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/popup_sucess/popup_sucess_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'check_infomation_externalvehicleregistration_model.dart';
export 'check_infomation_externalvehicleregistration_model.dart';

class CheckInfomationExternalvehicleregistrationWidget extends StatefulWidget {
  const CheckInfomationExternalvehicleregistrationWidget({super.key});

  @override
  State<CheckInfomationExternalvehicleregistrationWidget> createState() =>
      _CheckInfomationExternalvehicleregistrationWidgetState();
}

class _CheckInfomationExternalvehicleregistrationWidgetState
    extends State<CheckInfomationExternalvehicleregistrationWidget> {
  late CheckInfomationExternalvehicleregistrationModel _model;
  GlobalKey<FormState> valiPalte = GlobalKey<FormState>();
  GlobalKey<FormState> ckeke = GlobalKey<FormState>();
  GlobalKey<FormState> nameckeke = GlobalKey<FormState>();
  GlobalKey<FormState> autoPlatenumber = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? errorMessage;
  DetailController detailController = Get.put(DetailController());
  IDCardController idCardController = Get.put(IDCardController());
  PlateController textPlateController = Get.put(PlateController());
  VehicleVisitorLogController logVisit = Get.put(VehicleVisitorLogController());
  VehicleController vehicleController = Get.put(VehicleController());

  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode1 = FocusNode();
  final TextEditingController textController = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  final TextEditingController textController3 = TextEditingController();
  final TextEditingController textController4 = TextEditingController();
  @override
  void initState() {
    super.initState();
    _model = createModel(
        context, () => CheckInfomationExternalvehicleregistrationModel());

    final Map<RxString, TextEditingController> controllersMap = {
      idCardController.idNumber: textController,
      idCardController.fullName: textController2,
      (textPlateController.autoPlate.value.number ?? '').obs: textController3,
      (textPlateController.autoPlate.value.province ?? '').obs: textController4,
    };

    controllersMap.forEach((rxValue, textController) {
      textController.text = rxValue.value;
      ever(rxValue, (value) {
        textController.text = value;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Reset orientation when navigating back
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        return true;
      },
      child: Scaffold(
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
                'assets/images/bgcar.png',
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
                              context.pushNamed('Visitorcarregistration');
                            },
                          ),
                        ),
                        Expanded(
                          child: wrapWithModel(
                            model: _model.headerWidgetModel,
                            updateCallback: () => safeSetState(() {}),
                            child: HeaderWidgetWidget(
                              header: 'ข้อมูลรถยนต์ผู้มาติดต่อ',
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
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 24.0),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'กรุณาตรวจสอบข้อมูลรถยนต์ผู้มาติดต่อ',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w300,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
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
                                          'assets/images/huse.png',
                                        ).image,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
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
                                                        Icons.home_filled,
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
                                                    children: [
                                                      Obx(
                                                        () => Text(
                                                          'บ้านเลขที่: ${detailController.selectedAddrest.value}',
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
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Obx(
                                                  () => Text(
                                                    'ซอย: ${detailController.selectedAddrSoi.value}',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 16.0)),
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0x0C00613A),
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            image: Image.asset(
                                              'assets/images/user1.png',
                                            ).image,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 24.0,
                                                        height: 24.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent1,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Icon(
                                                            Icons
                                                                .directions_car,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            size: 12.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        height: 25,
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Form(
                                                                key:
                                                                    autoPlatenumber,
                                                                child:
                                                                    TextFormField(
                                                                  focusNode:
                                                                      focusNode1,
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .allow(RegExp(
                                                                            r'^[A-Za-zก-๙0-9]+$')), // อนุญาตแค่ภาษาไทยและตัวเลข
                                                                  ],
                                                                  controller:
                                                                      TextEditingController(
                                                                    text: textPlateController
                                                                            .autoPlate
                                                                            .value
                                                                            .number ??
                                                                        ' ไม่พบเลขทะเบียนรถ ',
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    textPlateController
                                                                        .autoPlate
                                                                        .value
                                                                        .number = value;
                                                                  },
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                          fontFamily: FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts: GoogleFonts.asMap()
                                                                              .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          ),
                                                                          fontSize:
                                                                              16),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        null,
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    errorStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          fontSize:
                                                                              11.0,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'กรุณากรอกเลขทะเบียน';
                                                                    }
                                                                    if (!RegExp(
                                                                            r'^[A-Za-zก-๙0-9]+$')
                                                                        .hasMatch(
                                                                            value)) {
                                                                      return 'กรุณากรอกเฉพาะตัวอักษรและตัวเลข';
                                                                    }

                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width: 200,
                                                        height: 20,
                                                        child: Obx(
                                                          () => Form(
                                                            key: valiPalte,
                                                            child:
                                                                TextFormField(
                                                              // focusNode:
                                                              //     focusNode1,
                                                              controller:
                                                                  TextEditingController
                                                                      .fromValue(
                                                                TextEditingValue(
                                                                  text: textPlateController
                                                                          .autoPlate
                                                                          .value
                                                                          .province ??
                                                                      ' ไม่พบจังหวัด ',
                                                                ),
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                textPlateController
                                                                        .autoPlate
                                                                        .value
                                                                        .province =
                                                                    value;
                                                              },
                                                              style: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .bodyMedium
                                                                  .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          GoogleFonts.asMap()
                                                                              .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                      ),
                                                                      fontSize:
                                                                          16),
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: null,
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                errorStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      fontSize:
                                                                          11.0,
                                                                      useGoogleFonts:
                                                                          GoogleFonts.asMap()
                                                                              .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                      ),
                                                                    ),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'กรุณากรอกจังหวัด';
                                                                }

                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 16.0)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8.0,
                                        right: 8.0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                          onPressed: () {
                                            if (focusNode1.hasFocus) {
                                              focusNode1.unfocus();
                                            } else {
                                              focusNode1.requestFocus();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0x0C00613A),
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            image: Image.asset(
                                              'assets/images/user1.png',
                                            ).image,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 24.0,
                                                        height: 24.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent1,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            size: 12.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        height: 25,
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Form(
                                                                key: nameckeke,
                                                                child:
                                                                    TextFormField(
                                                                  focusNode:
                                                                      focusNode,
                                                                  controller:
                                                                      textController2,
                                                                  onChanged:
                                                                      (value) {
                                                                    idCardController
                                                                        .fullName
                                                                        .value = value;
                                                                  },
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                          fontFamily: FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts: GoogleFonts.asMap()
                                                                              .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          ),
                                                                          fontSize:
                                                                              16),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        null,
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    errorStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          fontSize:
                                                                              11.0,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'กรุณากรอกชื่อ-นามสกุล';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        width: 200,
                                                        height: 20,
                                                        child: Obx(
                                                          () => Form(
                                                            key: ckeke,
                                                            child:
                                                                TextFormField(
                                                              focusNode:
                                                                  focusNode,
                                                              controller:
                                                                  TextEditingController
                                                                      .fromValue(
                                                                TextEditingValue(
                                                                  text: idCardController
                                                                      .idNumber
                                                                      .value,
                                                                  selection:
                                                                      TextSelection
                                                                          .collapsed(
                                                                    offset: idCardController
                                                                        .idNumber
                                                                        .value
                                                                        .length,
                                                                  ),
                                                                ),
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                idCardController
                                                                        .idNumber
                                                                        .value =
                                                                    value;
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly,
                                                                LengthLimitingTextInputFormatter(
                                                                    13),
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        GoogleFonts.asMap()
                                                                            .containsKey(
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumFamily,
                                                                    ),
                                                                  ),
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: null,
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                errorStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      fontSize:
                                                                          11.0,
                                                                      useGoogleFonts:
                                                                          GoogleFonts.asMap()
                                                                              .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                      ),
                                                                    ),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'กรุณากรอกเลขบัตรประชาชน';
                                                                }
                                                                if (!RegExp(
                                                                        r'^\d+$')
                                                                    .hasMatch(
                                                                        value)) {
                                                                  return 'กรุณากรอกเฉพาะตัวเลขเท่านั้น';
                                                                }
                                                                if (value
                                                                        .length <
                                                                    13) {
                                                                  return 'กรุณากรอกเลขบัตรประชาชนให้ครบ 13 หลัก';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 16.0)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8.0,
                                        right: 8.0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                          onPressed: () {
                                            if (focusNode.hasFocus) {
                                              focusNode.unfocus();
                                            } else {
                                              focusNode.requestFocus();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(height: 24.0)),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if ((ckeke.currentState?.validate() ??
                                          false) &&
                                      (valiPalte.currentState?.validate() ??
                                          false) &&
                                      (nameckeke.currentState?.validate() ??
                                          false) &&
                                      (autoPlatenumber.currentState
                                              ?.validate() ??
                                          false)) {
                                    // ถ้าข้อมูลถูกต้อง

                                    String? NPlate = textPlateController
                                        .autoPlate.value.number;
                                    String? ProPlate = textPlateController
                                        .autoPlate.value.province;
                                    String idNumber =
                                        idCardController.idNumber.value;
                                    String name =
                                        idCardController.fullName.value;

                                    // ดึงค่า ซอย และบ้านเลขที่ จาก detailController
                                    int houseNumber = int.tryParse(
                                        detailController
                                            .selectedAddrest.value)!;
                                    int alley = int.tryParse(detailController
                                        .selectedAddrSoi.value)!;

                                    // สร้าง object VehicleVisitorLog
                                    VehicleVisitorLog newLog =
                                        VehicleVisitorLog(
                                      null,
                                      houseNumber,
                                      alley,
                                      NPlate,
                                      ProPlate,
                                      name,
                                      idNumber,
                                      DateTime.now(),
                                    );

                                    Vehicle newVehicle = Vehicle.newInstance();
                                    newVehicle.vehicle_id =
                                        await serviceLocator<EHPApi>()
                                            .getSerialNumber('vehicle_id',
                                                'vehicle', 'vehicle_id');
                                    newVehicle.license_plate = NPlate;
                                    newVehicle.province = ProPlate;
                                    newVehicle.color = null;
                                    newVehicle.vehicle_model = null;
                                    newVehicle.is_resident = 'N';
                                    newVehicle.carbrand_id = 1;
                                    newVehicle.villageproject_detail_id =
                                        int.tryParse(detailController
                                            .villageproject_detail_id.value);

                                    VehicleVisitor newnewVehicle =
                                        VehicleVisitor.newInstance();

                                    newnewVehicle.vehicle_visitor_id =
                                        await serviceLocator<EHPApi>()
                                            .getSerialNumber(
                                                'vehicle_visitor_id',
                                                'vehicle_visitor',
                                                'vehicle_visitor_id');
                                    newnewVehicle.vehicle_id =
                                        newVehicle.vehicle_id;
                                    newnewVehicle.villageproject_resident_id =
                                        int.tryParse(detailController
                                            .villageproject_resident_id.value)!;
                                    newnewVehicle.vehicle_visitor_datetime_in =
                                        DateTime.now();
                                    newnewVehicle.vehicle_visitor_datetime_out =
                                        null;
                                    newnewVehicle.visitor_register_datetime =
                                        DateTime.now();
                                    newnewVehicle.approve_status = "N";
                                    newnewVehicle.is_all_day_access = null;
                                    newnewVehicle.vehicle_visitor_status_id = 1;

                                    // บันทึกข้อมูล
                                    bool result = await logVisit
                                        .saveVehicleVisitorLog(newLog);

                                    await VehicleController.saveVehicle(
                                        newVehicle);
                                    await VehicleVisitorController
                                        .saveVehicleVisitor(newnewVehicle);

                                    if (result) {
                                      // ignore: use_build_context_synchronously
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        barrierColor: const Color(0x3F000000),
                                        isDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: PopupSucessWidget(),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));

                                      await Future.delayed(
                                          const Duration(milliseconds: 1900));

                                      // ignore: use_build_context_synchronously
                                      context.go(
                                        '/Visitorcarregistration',
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey:
                                              const TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.fade,
                                            duration: Duration(milliseconds: 0),
                                          ),
                                        },
                                      );
                                    } else {
                                      print(errorMessage);
                                    }
                                  }
                                },
                                text: 'ตกลง',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
