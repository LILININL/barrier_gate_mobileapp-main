import 'dart:convert';
import 'dart:io';

import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_controller.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_picture_controller.dart';
import 'package:barrier_gate/function_untils/model/03BR_MB_ResidentCarList_model.dart';
import 'package:barrier_gate/function_untils/model/carbrand_model.dart';
import 'package:barrier_gate/function_untils/model/thaiaddress_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_picture_model.dart';
import 'package:barrier_gate/include_widget/dropdown_search2/lib/dropdown_search2.dart';
import 'package:barrier_gate/utils/butiinsheet_delet_widget/butiinsheet_delet_widget_widget.dart';
import 'package:barrier_gate/utils/popup_loading/popup_loading_widget.dart';
import 'package:barrier_gate/utils/popup_sucess/popup_sucess_widget.dart';
import 'package:barrier_gate/utils/title_widget/title_widget_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/car/widget/butiinsheet_more_widget/butiinsheet_more_widget_widget.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'cardetail_model.dart';
import 'package:image/image.dart' as img;

class CardetailWidget extends StatefulWidget {
  CardetailWidget({super.key, this.residentCarData});
  late BrMbResidentCarListModel03? residentCarData;

  @override
  State<CardetailWidget> createState() => _CardetailWidgetState();
}

class _CardetailWidgetState extends State<CardetailWidget> {
  late CardetailModel _model;
  List<ThaiaddressModel> chwpartList = [];
  List<Carbrand> carbrandList = [];
  String? chwpartName = '';
  int? carBrandID;
  bool isEdit = false;
  bool isReadOnly = true;
  late ThaiaddressModel selectedThaiaddressModel = ThaiaddressModel(
      null, null, null, null, null, null, null, null, null, null);
  late Carbrand selectedCarbrandModel = Carbrand(null, null);
  late Vehicle? vehicleData = Vehicle.newInstance();
  String? base64ImageString = '';
  Uint8List? imageBytes;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TitleWidgetModel titleWidgetModel;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardetailModel());
    titleWidgetModel = createModel(context, () => TitleWidgetModel());

    _model.textController1 ??= TextEditingController(
        text: (widget.residentCarData!.license_plate?.isNotEmpty ?? false)
            ? widget.residentCarData!.license_plate
            : '-');
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textController3 ??= TextEditingController();

    _model.textController4 ??= TextEditingController(
        text: (widget.residentCarData!.vehicle_model?.isNotEmpty ?? false)
            ? widget.residentCarData!.vehicle_model
            : '-');
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController(
        text: (widget.residentCarData!.color?.isNotEmpty ?? false)
            ? widget.residentCarData!.color
            : '-');
    _model.textFieldFocusNode5 ??= FocusNode();
    getSharedLookup();
    getImage();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  getSharedLookup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final chwpartListSP = prefs.getStringList('chwpartList');
    chwpartList = chwpartListSP!.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return ThaiaddressModel.newInstance().fromJson(json);
    }).toList();

    if (widget.residentCarData!.province!.isNotEmpty) {
      chwpartList.forEach((element) {
        if (element.name == widget.residentCarData!.province) {
          selectedThaiaddressModel = element;
        }
      });
    }

// ------------------------- /
    final carbrandListSP = prefs.getStringList('carbrandList');
    carbrandList = carbrandListSP!.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return Carbrand.newInstance().fromJson(json);
    }).toList();

    if (widget.residentCarData!.carbrandbrand_name!.isNotEmpty) {
      carbrandList.forEach((element) {
        if (element.carbrandbrand_name ==
            widget.residentCarData!.carbrandbrand_name) {
          selectedCarbrandModel = element;
        }
      });
    }

    vehicleData = await VehicleController.getVehicleFromID(
        widget.residentCarData!.vehicle_id!);
  }

  getImage() {
    if (widget.residentCarData!.vehicle_picture != null) {
      String base64String =
          base64Encode(widget.residentCarData!.vehicle_picture!);
      base64ImageString = base64String;
      imageBytes = base64Decode(base64ImageString!);
    }
    setState(() {});
  }

  // ฟังก์ชันเลือกภาพจาก Gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() async {
        _image = File(pickedFile.path);

        imageBytes = await File(pickedFile.path).readAsBytes();
        img.Image? image = img.decodeImage(imageBytes!);
        if (image != null) {
          setState(() {
            img.Image resizedImage =
                img.copyResize(image, width: 800); // ปรับขนาด width ตามต้องการ
            Uint8List compressedImage =
                Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
            String base64String = base64Encode(compressedImage);
            base64ImageString = base64String;
            print('_pickImageFromGallery ' + base64ImageString!);
            imageBytes = base64Decode(base64String!);
          });
        }
      });
    }
  }

  // ฟังก์ชันเปิดกล้องถ่ายรูป
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() async {
        _image = File(pickedFile.path);
        imageBytes = await File(pickedFile.path).readAsBytes();
        img.Image? image = img.decodeImage(imageBytes!);
        if (image != null) {
          setState(() {
            img.Image resizedImage =
                img.copyResize(image, width: 800); // ปรับขนาด width ตามต้องการ
            Uint8List compressedImage =
                Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
            String base64String = base64Encode(compressedImage);
            base64ImageString = base64String;
            print('_pickImageFromCamera ' + base64ImageString!);
            imageBytes = base64Decode(base64String!);
          });
        }
      });
    }
  }

  void _showPickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
              'assets/images/bgcar2.png',
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
                            header: 'รถยนต์',
                          ),
                        ),
                      ),
                      Container(
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
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: Color(0x3F000000),
                              isDismissible: false,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 1.0),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              wrapWithModel(
                                                model: titleWidgetModel,
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: TitleWidgetWidget(
                                                  title: 'เพิ่มเติม',
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  'ทำรายการเพิ่มเติม',
                                                  textAlign: TextAlign.center,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily),
                                                      ),
                                                ),
                                              ),
                                              Divider(
                                                height: 1.0,
                                                thickness: 1.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  isEdit = true;
                                                  isReadOnly = false;
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 48.0,
                                                  decoration: BoxDecoration(),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      'แก้ไข',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .accent1,
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
                                                ),
                                              ),
                                              Divider(
                                                height: 1.0,
                                                thickness: 1.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    barrierColor:
                                                        Color(0x3F000000),
                                                    isDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            32.0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    wrapWithModel(
                                                                      model:
                                                                          titleWidgetModel,
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          TitleWidgetWidget(
                                                                        title:
                                                                            'ลบข้อมูล',
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Text(
                                                                        'คุณต้องการลบข้อมูลหรือไม่?',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w300,
                                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      height:
                                                                          1.0,
                                                                      thickness:
                                                                          1.0,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          isDismissible:
                                                                              false,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: PopupLoadingWidget(),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));

                                                                        await VehicleController.deleteVehicle(vehicleData!).then((value) =>
                                                                            Navigator.pop(context));

                                                                        showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          barrierColor:
                                                                              Color(0x3F000000),
                                                                          isDismissible:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: PopupSucessWidget(),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));

                                                                        await Future.delayed(const Duration(
                                                                            milliseconds:
                                                                                1900));
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            48.0,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'ตกลง',
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                                  color: FlutterFlowTheme.of(context).accent1,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      height:
                                                                          1.0,
                                                                      thickness:
                                                                          1.0,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                    ),
                                                                    InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            48.0,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            'ยกเลิก',
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          16.0)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // child: ButiinsheetDeletWidgetWidget(),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 48.0,
                                                  decoration: BoxDecoration(),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      'ลบ',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
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
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 16.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // child: ButiinsheetMoreWidgetWidget(),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                        ),
                      ),
                    ]
                        .divide(SizedBox(width: 16.0))
                        .around(SizedBox(width: 16.0)),
                  ),
                ),
              ),
              Align(
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
                        InkWell(
                          onTap: () {
                            if (isReadOnly == false) {
                              _showPickerDialog(context); // แสดง dialog
                            }

                            //
                          },
                          child: Container(
                            width: 100.0,
                            height: 200.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Builder(builder: (context) {
                              if (base64ImageString == '') {
                                return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Opacity(
                                        opacity: 0.6,
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Icon(
                                            Icons.image_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 48.0,
                                          ),
                                        ),
                                      )
                                    ]);
                              } else {
                                return Image.memory(
                                  imageBytes!, // แสดงภาพจาก base64
                                  fit: BoxFit.cover,
                                );
                              }
                            }),
                          ),
                        ),
                        TextFormField(
                          controller: _model.textController1,
                          focusNode: _model.textFieldFocusNode1,
                          autofocus: false,
                          readOnly: isReadOnly,
                          obscureText: false,
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
                                      .containsKey(FlutterFlowTheme.of(context)
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
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyLargeFamily),
                              ),
                          validator: _model.textController1Validator
                              .asValidator(context),
                        ),
                        DropdownSearch<ThaiaddressModel>(
                          enabled: isEdit,
                          dialogMaxWidth: 100.0,
                          maxHeight: 300.0,
                          showSearchBox: true,
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
                                      .containsKey(FlutterFlowTheme.of(context)
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
                          },
                          selectedItem: selectedThaiaddressModel,
                          dropdownBuilder: (context, selectedItem) =>
                              selectedItem != null
                                  ? Text(
                                      (selectedItem as ThaiaddressModel).name ??
                                          ' ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Colors.black,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
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
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
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
                          enabled: isEdit,
                          dialogMaxWidth: 100.0,
                          maxHeight: 300.0,
                          showSearchBox: true,
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
                                      .containsKey(FlutterFlowTheme.of(context)
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
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
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
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
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
                                      .containsKey(FlutterFlowTheme.of(context)
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
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyLargeFamily),
                              ),
                          validator: _model.textController5Validator
                              .asValidator(context),
                        ),
                        TextFormField(
                          readOnly: isReadOnly,
                          controller: _model.textController5,
                          focusNode: _model.textFieldFocusNode5,
                          autofocus: false,
                          obscureText: false,
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
                                      .containsKey(FlutterFlowTheme.of(context)
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
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyLargeFamily),
                              ),
                          validator: _model.textController5Validator
                              .asValidator(context),
                        ),
                        if (isEdit)
                          FFButtonWidget(
                            onPressed: () async {
                              vehicleData!.license_plate =
                                  _model.textController1.text;

                              if (chwpartName != null &&
                                  chwpartName!.isNotEmpty) {
                                vehicleData!.province = chwpartName;
                              }

                              if (carBrandID != null) {
                                vehicleData!.carbrand_id = carBrandID;
                              }

                              vehicleData!.vehicle_model =
                                  _model.textController4.text;
                              vehicleData!.color = _model.textController5.text;
                              vehicleData!.sync_data = null;

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

                              if (_image != null) {
                                VehiclePicture vehiclePictureDate =
                                    VehiclePicture.newInstance();
                                if (widget
                                        .residentCarData!.vehicle_picture_id ==
                                    null) {
                                  vehiclePictureDate.vehicle_picture_id =
                                      await serviceLocator<EHPApi>()
                                          .getSerialNumber(
                                              'vehicle_picture_id',
                                              'vehicle_picture',
                                              'vehicle_picture_id');
                                } else {
                                  vehiclePictureDate.vehicle_picture_id = widget
                                      .residentCarData!.vehicle_picture_id;
                                }
                                vehiclePictureDate.vehicle_id =
                                    widget.residentCarData!.vehicle_id;

                                Uint8List imageBytes =
                                    await _image!.readAsBytes();
                                img.Image? image = img.decodeImage(imageBytes);
                                if (image != null) {
                                  // ลดขนาดภาพตามต้องการ (คุณสามารถปรับขนาดใหม่ที่นี่ได้)
                                  img.Image resizedImage = img.copyResize(image,
                                      width: 800); // ปรับขนาด width ตามต้องการ
                                  // บีบอัดภาพใหม่ โดยคุณภาพลดลง 80% (quality = 80)
                                  Uint8List compressedImage =
                                      Uint8List.fromList(img.encodeJpg(
                                          resizedImage,
                                          quality: 80));
                                  vehiclePictureDate.vehicle_picture =
                                      compressedImage;
                                  String base64String =
                                      base64Encode(compressedImage);
                                }

                                await VehiclePictureController
                                        .saveVehiclePicture(vehiclePictureDate)
                                    .then((value) => print('saveComplete'));
                              }

                              // if (_image != null) {
                              //   VehiclePicture vehiclePictureDate = VehiclePicture.newInstance();
                              //   vehiclePictureDate.vehicle_picture_id = await serviceLocator<EHPApi>().getSerialNumber('vehicle_picture_id', 'vehicle_picture', 'vehicle_picture_id');
                              //   vehiclePictureDate.vehicle_id = vehicleData.vehicle_id;

                              //   Uint8List imageBytes = await _image!.readAsBytes();
                              //   img.Image? image = img.decodeImage(imageBytes);
                              //   if (image != null) {
                              //     // ลดขนาดภาพตามต้องการ (คุณสามารถปรับขนาดใหม่ที่นี่ได้)
                              //     img.Image resizedImage = img.copyResize(image, width: 800); // ปรับขนาด width ตามต้องการ
                              //     // บีบอัดภาพใหม่ โดยคุณภาพลดลง 80% (quality = 80)
                              //     Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
                              //     vehiclePictureDate.vehicle_picture = compressedImage;
                              //     String base64String = base64Encode(compressedImage);
                              //   }
                              //   await VehiclePictureController.saveVehiclePicture(vehiclePictureDate).then((value) => print('saveComplete'));
                              // }

                              await VehicleController.saveVehicle(vehicleData!)
                                  .then((value) => {Navigator.pop(context)});

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
                              Navigator.pop(context, "result");
                            },
                            text: 'บันทึก',
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
                      ].divide(SizedBox(height: 24.0)),
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
