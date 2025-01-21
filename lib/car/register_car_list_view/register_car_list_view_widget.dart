import 'dart:convert';

import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_controller.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_picture_controller.dart';
import 'package:barrier_gate/function_untils/model/02BR_MB_ResidentListVillage_model.dart';
import 'package:barrier_gate/function_untils/model/carbrand_model.dart';
import 'package:barrier_gate/function_untils/model/prename_model.dart';
import 'package:barrier_gate/function_untils/model/thaiaddress_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_picture_model.dart';
import 'package:barrier_gate/include_widget/dropdown_search2/lib/dropdown_search2.dart';
import 'package:barrier_gate/utils/popup_loading/popup_loading_widget.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/car/widget/buttonsheet_cancel_save_car_widget/buttonsheet_cancel_save_car_widget_widget.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/popup_sucess/popup_sucess_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'register_car_list_view_model.dart';
export 'register_car_list_view_model.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class RegisterCarListViewWidget extends StatefulWidget {
  const RegisterCarListViewWidget({super.key, this.residentDetail});
  final BrMbResidentListVillageModel02? residentDetail;

  @override
  State<RegisterCarListViewWidget> createState() =>
      _RegisterCarListViewWidgetState();
}

class _RegisterCarListViewWidgetState extends State<RegisterCarListViewWidget> {
  late RegisterCarListViewModel _model;
  List<ThaiaddressModel> chwpartList = [];
  List<Carbrand> carbrandList = [];
  String? chwpartName = '';
  int? carBrandID;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final validate = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterCarListViewModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();

    _model.textController3 ??= TextEditingController();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();
    getSharedLookup();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  getSharedLookup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final chwpartListSP = prefs.getStringList('chwpartList');

    chwpartList = chwpartListSP!.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return ThaiaddressModel.newInstance().fromJson(json);
    }).toList();

// ------------------------- /
    final carbrandListSP = prefs.getStringList('carbrandList');
    carbrandList = carbrandListSP!.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return Carbrand.newInstance().fromJson(json);
    }).toList();
  }

  // ฟังก์ชันเลือกภาพจาก Gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ฟังก์ชันเปิดกล้องถ่ายรูป
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: Color(0x3F000000),
                              isDismissible: false,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: ButtonsheetCancelSaveCarWidgetWidget(),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                        ),
                      ),
                      Expanded(
                        child: wrapWithModel(
                          model: _model.headerWidgetModel,
                          updateCallback: () => safeSetState(() {}),
                          child: HeaderWidgetWidget(
                            header: 'ลงทะเบียนรถยนต์',
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
                                    'กรุณาใส่ข้อมูลด้านล่างให้ครบถ้วน',
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
                                InkWell(
                                  onTap: () {
                                    _showPickerDialog(context); // แสดง dialog ใ
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        image: DecorationImage(
                                            image: _image != null
                                                ? FileImage(File(
                                                    _image!
                                                        .path)) as ImageProvider<
                                                    Object> // ใส่รูปภาพที่เลือกจากกล้องหรือแกลเลอรี
                                                : AssetImage(
                                                        'assets/images/user.png')
                                                    as ImageProvider<
                                                        Object>, // รูปภาพค่าเริ่มต้น
                                            fit: BoxFit
                                                .contain // ทำให้รูปภาพพอดีกับวงกลม
                                            )),
                                    child: Visibility(
                                      visible: _image == null ? true : false,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Opacity(
                                            opacity: 0.6,
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                Icons.image_outlined,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 48.0,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Text(
                                              'กรุณาเพิ่มรูปรถยนต์ของคุณ',
                                              textAlign: TextAlign.center,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmallFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmallFamily),
                                                      ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 8.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                Form(
                                  key: validate,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          controller: _model.textController1,
                                          focusNode: _model.textFieldFocusNode1,
                                          autofocus: false,
                                          obscureText: false,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'^[A-Za-zก-๙0-9]+$')), // อนุญาตแค่ภาษาไทยและตัวเลข
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'เลขทะเบียน',
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
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
                                            errorStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  fontSize: 14.0,
                                                  useGoogleFonts:
                                                      GoogleFonts.asMap()
                                                          .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                  ),
                                                ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLargeFamily),
                                              ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'กรุณากรอกเลขทะเบียน';
                                            }
                                            if (!RegExp(r'^[A-Za-zก-๙0-9]+$')
                                                .hasMatch(value)) {
                                              return 'กรุณากรอกเฉพาะตัวอักษรและตัวเลข';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: DropdownSearch<ThaiaddressModel>(
                                          dialogMaxWidth: 100.0,
                                          maxHeight: 300.0,
                                          showSearchBox: true,
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            label: Text('จังหวัด'),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                8.0, 0.0, 0.0, 0.0),
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            errorStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  fontSize: 14.0,
                                                  useGoogleFonts:
                                                      GoogleFonts.asMap()
                                                          .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                  ),
                                                ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(
                                                        context)
                                                    .error, // สีแดงตอน focused error
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16.0), // ทำให้ขอบมน
                                            ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                          items: chwpartList,
                                          itemAsString: (item) =>
                                              (item as ThaiaddressModel).name ??
                                              '',
                                          compareFn: (i, s) =>
                                              ((i as ThaiaddressModel).name ??
                                                  '') ==
                                              ((s as ThaiaddressModel).name ??
                                                  ''),
                                          onChanged: (item) {
                                            chwpartName = item!.name;
                                          },
                                          dropdownBuilder: (context,
                                                  selectedItem) =>
                                              selectedItem != null
                                                  ? Text(
                                                      (selectedItem
                                                                  as ThaiaddressModel)
                                                              .name ??
                                                          ' ',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: Colors
                                                                    .black,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                    )
                                                  : Text(
                                                      '',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: Color(
                                                                    0xFF868686),
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                    ),
                                          popupItemBuilder:
                                              (context, item, isSelected) =>
                                                  Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 12),
                                            child: Text(
                                              (item as ThaiaddressModel).name ??
                                                  '',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          ),
                                          mode: Mode.MENU,
                                          validator: (value) {
                                            if (chwpartName == null ||
                                                chwpartName!.isEmpty) {
                                              return 'กรุณาเลือกจังหวัด';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownSearch<Carbrand>(
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    hintStyle: FlutterFlowTheme.of(context)
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
                                  items: carbrandList,
                                  itemAsString: (item) =>
                                      (item as Carbrand).carbrandbrand_name ??
                                      '',
                                  compareFn: (i, s) =>
                                      ((i as Carbrand).carbrandbrand_name ??
                                          '') ==
                                      ((s as Carbrand).carbrandbrand_name ??
                                          ''),
                                  onChanged: (item) {
                                    carBrandID = item!.carbrand_id;
                                    // prename = item!.prename_name!;

                                    // setState(() {});
                                  },
                                  dropdownBuilder: (context, selectedItem) =>
                                      selectedItem != null
                                          ? Text(
                                              (selectedItem as Carbrand)
                                                      .carbrandbrand_name ??
                                                  ' ',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            Color(0xFF868686),
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily),
                                                      ),
                                            ),
                                  popupItemBuilder:
                                      (context, item, isSelected) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 12),
                                    child: Text(
                                      (item as Carbrand).carbrandbrand_name ??
                                          '',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                  ),
                                  mode: Mode.MENU,
                                ),
                                TextFormField(
                                  controller: _model.textController4,
                                  focusNode: _model.textFieldFocusNode4,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'รุ่นรถยนต์',
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
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                                  validator: _model.textController5Validator
                                      .asValidator(context),
                                ),
                                TextFormField(
                                  controller: _model.textController5,
                                  focusNode: _model.textFieldFocusNode5,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'สี',
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
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                                  validator: _model.textController5Validator
                                      .asValidator(context),
                                ),
                              ].divide(SizedBox(height: 24.0)),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (validate.currentState!.validate()) {
                                  Vehicle vehicleData = Vehicle.newInstance();
                                  vehicleData.vehicle_id =
                                      await serviceLocator<EHPApi>()
                                          .getSerialNumber('vehicle_id',
                                              'vehicle', 'vehicle_id');
                                  vehicleData.license_plate =
                                      _model.textController1.text;
                                  vehicleData.province = chwpartName;
                                  vehicleData.carbrand_id = carBrandID;
                                  vehicleData.vehicle_model =
                                      _model.textController4.text;
                                  vehicleData.color =
                                      _model.textController5.text;
                                  vehicleData.is_resident = "Y";
                                  vehicleData.villageproject_resident_id =
                                      widget.residentDetail!
                                          .villageproject_resident_id;
                                  vehicleData.villageproject_detail_id = widget
                                      .residentDetail!.villageproject_detail_id;
                                  // widget.residentDetail.villageproject_detail_id

                                  if (_image != null) {
                                    VehiclePicture vehiclePictureDate =
                                        VehiclePicture.newInstance();
                                    vehiclePictureDate.vehicle_picture_id =
                                        await serviceLocator<EHPApi>()
                                            .getSerialNumber(
                                                'vehicle_picture_id',
                                                'vehicle_picture',
                                                'vehicle_picture_id');
                                    vehiclePictureDate.vehicle_id =
                                        vehicleData.vehicle_id;

                                    Uint8List imageBytes =
                                        await _image!.readAsBytes();
                                    img.Image? image =
                                        img.decodeImage(imageBytes);
                                    if (image != null) {
                                      // ลดขนาดภาพตามต้องการ (คุณสามารถปรับขนาดใหม่ที่นี่ได้)
                                      img.Image resizedImage = img.copyResize(
                                          image,
                                          width:
                                              800); // ปรับขนาด width ตามต้องการ
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
                                            .saveVehiclePicture(
                                                vehiclePictureDate)
                                        .then((value) => print('saveComplete'));
                                  }

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
                                        child: PopupLoadingWidget(),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  await VehicleController.saveVehicle(
                                          vehicleData)
                                      .then(
                                          (value) => {Navigator.pop(context)});

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
                                        child: PopupSucessWidget(),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  await Future.delayed(
                                      const Duration(milliseconds: 1900));
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                                ;
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
    );
  }
}
