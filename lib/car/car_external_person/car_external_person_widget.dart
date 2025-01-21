import 'package:barrier_gate/car/my_project_list_widget/visitor_car_controller.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_controller.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_visitor_controller.dart';
import 'package:barrier_gate/function_untils/model/04BR_MB_VisitorCarList_model.dart';
import 'package:barrier_gate/function_untils/model/carbrand_model.dart';
import 'package:barrier_gate/function_untils/model/thaiaddress_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_visitor_model.dart';
import 'package:barrier_gate/include_widget/dropdown_search2/lib/dropdown_search2.dart';
import 'package:barrier_gate/include_widget/flutter_rounded_date_picker/lib/flutter_rounded_date_picker.dart';
import 'package:barrier_gate/utils/butiinsheet_delet_widget/butiinsheet_delet_widget_widget.dart';
import 'package:barrier_gate/utils/popup_issue/popup_issue_widget.dart';
import 'package:barrier_gate/utils/popup_loading/popup_loading_widget.dart';
import 'package:barrier_gate/utils/popup_sucess/popup_sucess_widget.dart';
import 'package:barrier_gate/utils/title_widget/title_widget_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '/car/widget/butiinsheet_more_widget/butiinsheet_more_widget_widget.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'car_external_person_model.dart';
export 'car_external_person_model.dart';

class CarExternalPersonWidget extends StatefulWidget {
  const CarExternalPersonWidget({super.key, this.visitorCarData});
  final BrMbvisitorCarListModel04? visitorCarData;
  @override
  State<CarExternalPersonWidget> createState() =>
      _CarExternalPersonWidgetState();
}

class _CarExternalPersonWidgetState extends State<CarExternalPersonWidget> {
  late CarExternalPersonModel _model;
  late ButiinsheetMoreWidgetModel _model2;
  List<ThaiaddressModel> chwpartList = [];
  List<Carbrand> carbrandList = [];
  String? chwpartName = '';
  int? carBrandID;
  DateTime? curentPickedDate;
  bool isEdit = false;
  bool isReadOnly = true;
  // bool approve_status = true;
  late ThaiaddressModel selectedThaiaddressModel = ThaiaddressModel(
      null, null, null, null, null, null, null, null, null, null);
  late Carbrand selectedCarbrandModel = Carbrand(null, null);
  late Vehicle? vehicleData = Vehicle.newInstance();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  VisitorCarController visitorCarController = Get.put(VisitorCarController());

  @override
  void initState() {
    super.initState();
    getSharedLookup();

    visitorCarController.setVehicleVisitorStatusId(
      widget.visitorCarData!.vehicle_visitor_status_id.toString(),
    );

    _model = createModel(context, () => CarExternalPersonModel());
    _model2 = createModel(context, () => ButiinsheetMoreWidgetModel());
    _model.textController1 ??= TextEditingController(
        text: (widget.visitorCarData!.license_plate?.isNotEmpty ?? false)
            ? widget.visitorCarData!.license_plate
            : '-');
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textController3 ??= TextEditingController();

    _model.textController4 ??= TextEditingController(
        text: (widget.visitorCarData!.vehicle_model?.isNotEmpty ?? false)
            ? widget.visitorCarData!.vehicle_model
            : '-');
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController(
        text: (widget.visitorCarData!.color?.isNotEmpty ?? false)
            ? widget.visitorCarData!.color
            : '-');
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController(
        text: formatThaiDateShort4(
            widget.visitorCarData!.visitor_register_datetime));
    _model.textFieldFocusNode6 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  pickedDateTime(BuildContext context) async {
    final _datePickedDate = await showRoundedDatePicker(
        context: context,
        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
        era: EraMode.BUDDHIST_YEAR,
        locale: Locale('th', 'TH'),
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(
            DateTime.now().year + 1), // กำหนดวันที่สุดท้ายที่สามารถเลือกได้
        theme: ThemeData.dark());

    if (_datePickedDate != null) {
      setState(() {
        curentPickedDate = DateTime(
          _datePickedDate.year,
          _datePickedDate.month,
          _datePickedDate.day,
        );
      });

      _model.textController6.text = formatThaiDateShort4(curentPickedDate);

      // return curentPickedDate!;
    } else {
      curentPickedDate = DateTime.now();
      _model.textController6.text = formatThaiDateShort4(curentPickedDate);

      // return curentPickedDate!;
    }
  }

  getSharedLookup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final chwpartListSP = prefs.getStringList('chwpartList');
    chwpartList = chwpartListSP!.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return ThaiaddressModel.newInstance().fromJson(json);
    }).toList();

    if (widget.visitorCarData!.province!.isNotEmpty) {
      chwpartList.forEach((element) {
        if (element.name == widget.visitorCarData!.province) {
          selectedThaiaddressModel = element;
          chwpartName = element.name;
        }
      });
    }

// ------------------------- /
    final carbrandListSP = prefs.getStringList('carbrandList');
    carbrandList = carbrandListSP!.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return Carbrand.newInstance().fromJson(json);
    }).toList();

    if (widget.visitorCarData!.carbrandbrand_name!.isNotEmpty) {
      carbrandList.forEach((element) {
        if (element.carbrandbrand_name ==
            widget.visitorCarData!.carbrandbrand_name) {
          selectedCarbrandModel = element;
          carBrandID = element.carbrand_id;
        }
      });
    }

    vehicleData = await VehicleController.getVehicleFromID(
        widget.visitorCarData!.vehicle_id!);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
                            header: 'รถยนต์ผู้มาติดต่อ',
                          ),
                        ),
                      ),
                      Obx(() {
                        if (visitorCarController
                            .vehicleVisitorStatusId.value.isEmpty) {
                          return SizedBox.shrink(); // ซ่อน widget ไว้ก่อน
                        }

                        return Visibility(
                          visible: visitorCarController
                                  .vehicleVisitorStatusId.value ==
                              '3',
                          child: Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(),
                            child: FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.keyboard_control,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                if (visitorCarController
                                        .vehicleVisitorStatusId ==
                                    3) {
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
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 1.0),
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      wrapWithModel(
                                                        model: _model2
                                                            .titleWidgetModel,
                                                        updateCallback: () =>
                                                            safeSetState(() {}),
                                                        child:
                                                            TitleWidgetWidget(
                                                          title: 'เพิ่มเติม',
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          'ทำรายการเพิ่มเติม',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 1.0,
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            isEdit = true;
                                                            isReadOnly = false;
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 48.0,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Text(
                                                              'แก้ไข',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyLargeFamily,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .accent1,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyLargeFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 1.0,
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            barrierColor: Color(
                                                                0x3F000000),
                                                            isDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    ButiinsheetDeletWidgetWidget(),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(
                                                                  () {}));
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 48.0,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Text(
                                                              'ลบ',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyLargeFamily,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyLargeFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Divider(
                                                      //   height: 1.0,
                                                      //   thickness: 1.0,
                                                      //   color: FlutterFlowTheme.of(context).alternate,
                                                      // ),
                                                      // InkWell(
                                                      //   splashColor: Colors.transparent,
                                                      //   focusColor: Colors.transparent,
                                                      //   hoverColor: Colors.transparent,
                                                      //   highlightColor: Colors.transparent,
                                                      //   onTap: () async {
                                                      //     Navigator.pop(context);
                                                      //   },
                                                      //   child: Container(
                                                      //     width: double.infinity,
                                                      //     height: 48.0,
                                                      //     decoration: BoxDecoration(),
                                                      //     child: Align(
                                                      //       alignment: AlignmentDirectional(0.0, 0.0),
                                                      //       child: Text(
                                                      //         'ยกเลิก',
                                                      //         style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                      //               fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                      //               color: FlutterFlowTheme.of(context).error,
                                                      //               letterSpacing: 0.0,
                                                      //               useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                                      //             ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ].divide(
                                                        SizedBox(height: 16.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )

                                          // ButiinsheetMoreWidgetWidget(),
                                          );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                }
                              },
                            ),
                          ),
                        );
                      }),
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
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        scrollDirection: Axis.vertical,
                        children: [
                          TextFormField(
                            controller: _model.textController1,
                            focusNode: _model.textFieldFocusNode1,
                            autofocus: false,
                            obscureText: false,
                            readOnly: isReadOnly,
                            decoration: InputDecoration(
                              labelText: 'เลขทะเบียน',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
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
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyLargeFamily),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          DropdownSearch<ThaiaddressModel>(
                            dialogMaxWidth: 100.0,
                            maxHeight: 300.0,
                            showSearchBox: true,
                            enabled: isEdit,
                            dropdownSearchDecoration: InputDecoration(
                              label: Text('จังหวัด'),
                              contentPadding:
                                  EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Color(0xFF868686),
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                            items: chwpartList,
                            itemAsString: (item) =>
                                (item as ThaiaddressModel).name ?? '',
                            compareFn: (i, s) =>
                                ((i as ThaiaddressModel).name ?? '') ==
                                ((s as ThaiaddressModel).name ?? ''),
                            onChanged: (item) {
                              chwpartName = item!.name;
                              // prename = item!.prename_name!;

                              // setState(() {});
                            },
                            selectedItem: selectedThaiaddressModel,
                            validator: (value) {
                              if (value == null) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            dropdownBuilder: (context, selectedItem) =>
                                selectedItem != null
                                    ? Text(
                                        (selectedItem as ThaiaddressModel)
                                                .name ??
                                            ' ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Colors.black,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                      )
                                    : Text(
                                        '',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF868686),
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                      ),
                            popupItemBuilder: (context, item, isSelected) =>
                                Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              child: Text(
                                (item as ThaiaddressModel).name ?? '',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                            mode: Mode.MENU,
                          ),
                          DropdownSearch<Carbrand>(
                            dialogMaxWidth: 100.0,
                            maxHeight: 300.0,
                            showSearchBox: true,
                            enabled: isEdit,
                            dropdownSearchDecoration: InputDecoration(
                              label: Text('ยี่ห้อรถยนต์'),
                              contentPadding:
                                  EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Color(0xFF868686),
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                            items: carbrandList,
                            itemAsString: (item) =>
                                (item as Carbrand).carbrandbrand_name ?? '',
                            compareFn: (i, s) =>
                                ((i as Carbrand).carbrandbrand_name ?? '') ==
                                ((s as Carbrand).carbrandbrand_name ?? ''),
                            onChanged: (item) {
                              carBrandID = item!.carbrand_id;
                              // prename = item!.prename_name!;

                              // setState(() {});
                            },
                            selectedItem: selectedCarbrandModel,
                            dropdownBuilder: (context, selectedItem) =>
                                selectedItem != null
                                    ? Text(
                                        (selectedItem as Carbrand)
                                                .carbrandbrand_name ??
                                            ' ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Colors.black,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                      )
                                    : Text(
                                        '',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF868686),
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                      ),
                            popupItemBuilder: (context, item, isSelected) =>
                                Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              child: Text(
                                (item as Carbrand).carbrandbrand_name ?? '',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                            mode: Mode.MENU,
                          ),
                          TextFormField(
                            controller: _model.textController4,
                            focusNode: _model.textFieldFocusNode4,
                            autofocus: false,
                            obscureText: false,
                            readOnly: isReadOnly,
                            decoration: InputDecoration(
                              labelText: 'รุ่นรถยนต์',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
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
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyLargeFamily),
                                ),
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'This field is required';
                            //   }
                            //   return null;
                            // },
                          ),
                          TextFormField(
                            controller: _model.textController5,
                            focusNode: _model.textFieldFocusNode5,
                            autofocus: false,
                            obscureText: false,
                            readOnly: isReadOnly,
                            decoration: InputDecoration(
                              labelText: 'สี',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
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
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyLargeFamily),
                                ),
                            validator: _model.textController5Validator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.textController6,
                            focusNode: _model.textFieldFocusNode6,
                            autofocus: false,
                            readOnly: isReadOnly,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'วันที่',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
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
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  await pickedDateTime(context);
                                },
                                child: Icon(
                                  Icons.date_range_outlined,
                                  size: 16.0,
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
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyLargeFamily),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'IN',
                                    // widget.visitorCarData!.approve_status.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 100.0,
                                    buttonSize: 60.0,
                                    // fillColor: FlutterFlowTheme.of(context).accent1,
                                    fillColor: (widget.visitorCarData
                                                ?.vehicle_visitor_datetime_in !=
                                            null)
                                        ? FlutterFlowTheme.of(context).accent1
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    icon: FaIcon(
                                      FontAwesomeIcons.carSide,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      size: 18.0,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
                                  ),
                                  Text(
                                    (widget.visitorCarData
                                                    ?.vehicle_visitor_datetime_in !=
                                                null &&
                                            formatThaiDateTime(widget
                                                    .visitorCarData!
                                                    .vehicle_visitor_datetime_in!)
                                                .isNotEmpty)
                                        ? formatThaiDateTime(widget
                                            .visitorCarData!
                                            .vehicle_visitor_datetime_in!)
                                        : '-',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                              Expanded(
                                child: Container(
                                  width: 100.0,
                                  height: 4.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        (widget.visitorCarData
                                                    ?.vehicle_visitor_datetime_in !=
                                                null)
                                            ? FlutterFlowTheme.of(context)
                                                .accent1
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        (widget.visitorCarData?.approve_status
                                                    .toString() ==
                                                'Y')
                                            ? FlutterFlowTheme.of(context)
                                                .accent1
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText
                                      ],
                                      stops: [0.0, 1.0],
                                      begin: AlignmentDirectional(0.56, -1.0),
                                      end: AlignmentDirectional(-0.56, 1.0),
                                    ),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'OUT',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 100.0,
                                    buttonSize: 60.0,
                                    // fillColor: FlutterFlowTheme.of(context).secondaryText,
                                    fillColor: (widget
                                                .visitorCarData?.approve_status
                                                .toString() ==
                                            'Y')
                                        ? FlutterFlowTheme.of(context).accent1
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,

                                    icon: FaIcon(
                                      FontAwesomeIcons.carSide,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      size: 18.0,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
                                  ),
                                  Text(
                                    (widget.visitorCarData
                                                    ?.vehicle_visitor_datetime_out !=
                                                null &&
                                            formatThaiDateTime(widget
                                                    .visitorCarData!
                                                    .vehicle_visitor_datetime_out!)
                                                .isNotEmpty)
                                        ? formatThaiDateTime(widget
                                            .visitorCarData!
                                            .vehicle_visitor_datetime_out!)
                                        : '-',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ],
                          ),

                          // Comment ไว้เผื่อแก้ไข
//                           Visibility(
//                             visible: (isReadOnly),
//                             child: FFButtonWidget(
//                                 onPressed: () async {
//                                   if (widget.visitorCarData?.vehicle_visitor_datetime_in != null) {
//                                     if (widget.visitorCarData?.approve_status.toString() != 'Y') {
//                                       late VehicleVisitor VehicleVisitorData;
//                                       VehicleVisitorData = await VehicleVisitorController.getVehicleVisitorFromID(widget.visitorCarData!.vehicle_visitor_id!);
//                                       VehicleVisitorData.approve_status = 'Y';

//                                       await VehicleVisitorController.saveVehicleVisitor(VehicleVisitorData).then((value) {});

//                                       setState(() {
//                                         widget.visitorCarData!.approve_status = 'Y';
//                                       });
//                                     }
//                                   }
// // PopupIssueWidget
//                                 },
//                                 text: 'ยืนยัน',
//                                 options: FFButtonOptions(
//                                   width: 100.0,
//                                   height: 56.0,
//                                   padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
//                                   iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//                                   color: (widget.visitorCarData?.approve_status.toString() == 'Y')
//                                       ? FlutterFlowTheme.of(context).secondaryText // สีเมื่อ approve_status เป็น 'Y'
//                                       : FlutterFlowTheme.of(context).accent1, // สีเมื่อ approve_status ไม่ใช่ 'Y'
//                                   textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
//                                         fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
//                                         color: FlutterFlowTheme.of(context).primaryBackground,
//                                         letterSpacing: 0.0,
//                                         useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
//                                       ),
//                                   elevation: 0.0,
//                                   borderSide: BorderSide(
//                                     color: Colors.transparent,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(100.0),
//                                 )

//                                 ),
//                           ),
                          Visibility(
                            visible: isEdit,
                            child: FFButtonWidget(
                              onPressed: () async {
                                Vehicle vehicleData = Vehicle.newInstance();

                                vehicleData =
                                    await VehicleController.getVehicleFromID(
                                        widget.visitorCarData!.vehicle_id!);
                                vehicleData.license_plate =
                                    _model.textController1.text;
                                vehicleData.province = chwpartName;
                                vehicleData.carbrand_id = carBrandID;
                                vehicleData.vehicle_model =
                                    _model.textController4.text;
                                vehicleData.color = _model.textController5.text;

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

                                await VehicleController.saveVehicle(vehicleData)
                                    .then((value) async => {
                                          // Navigator.pop(context)

                                          Navigator.pop(context)
                                        });

                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  barrierColor: Color(0x3F000000),
                                  isDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: PopupSucessWidget(),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));

                                await Future.delayed(
                                    const Duration(milliseconds: 1900));
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              text: 'แก้ไข',
                              options: FFButtonOptions(
                                width: 100.0,
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
                                          .primaryBackground,
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
