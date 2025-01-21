//เพิ่มรถผู้มาติดต่อภายนอก
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_controller.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_visitor_controller.dart';
import 'package:barrier_gate/function_untils/model/02BR_MB_ResidentListVillage_model.dart';
import 'package:barrier_gate/function_untils/model/carbrand_model.dart';
import 'package:barrier_gate/function_untils/model/thaiaddress_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_visitor_model.dart';
import 'package:barrier_gate/include_widget/dropdown_search2/lib/dropdown_search2.dart';
import 'package:barrier_gate/include_widget/flutter_rounded_date_picker/lib/flutter_rounded_date_picker.dart';
import 'package:barrier_gate/utils/popup_loading/popup_loading_widget.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/car/widget/buttonsheet_cancel_save_car_widget/buttonsheet_cancel_save_car_widget_widget.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/popup_sucess/popup_sucess_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'register_external_person_view_model.dart';
export 'register_external_person_view_model.dart';

class RegisterExternalPersonViewWidget extends StatefulWidget {
  const RegisterExternalPersonViewWidget({super.key, this.residentDetail});

  final BrMbResidentListVillageModel02? residentDetail;

  @override
  State<RegisterExternalPersonViewWidget> createState() =>
      _RegisterExternalPersonViewWidgetState();
}

class _RegisterExternalPersonViewWidgetState
    extends State<RegisterExternalPersonViewWidget> {
  late RegisterExternalPersonViewModel _model;
  List<ThaiaddressModel> chwpartList = [];
  List<Carbrand> carbrandList = [];
  String? chwpartName = '';
  int? carBrandID;
  DateTime? curentPickedDate;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterExternalPersonViewModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();

    _model.textController3 ??= TextEditingController();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??=
        TextEditingController(text: formatThaiDateShort4(_model.datePicked));
    _model.textFieldFocusNode6 ??= FocusNode();
    getSharedLookup();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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

  Future<void> pickedDateTime(BuildContext context) async {
    final DateTime now = DateTime.now(); // วันที่และเวลาปัจจุบัน
    final DateTime? _datePickedDate = await showRoundedDatePicker(
      context: context,
      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
      era: EraMode.BUDDHIST_YEAR,
      locale: Locale('th', 'TH'),
      initialDate: curentPickedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1),
      theme: ThemeData.dark(),
    );

    if (_datePickedDate != null) {
      setState(() {
        // เก็บเวลาเดิมไว้ใน curentPickedDate (เช่น ชั่วโมงและนาที)
        curentPickedDate = DateTime(
          _datePickedDate.year,
          _datePickedDate.month,
          _datePickedDate.day,
          now.hour, // ใช้ชั่วโมงของเวลาปัจจุบัน
          now.minute, // ใช้นาทีของเวลาปัจจุบัน
        );
        // แสดงผลเฉพาะวันที่ใน TextField แต่เก็บเวลาไว้ในตัวแปร
        _model.textController6.text = formatThaiDateShort4(
          DateTime(
            curentPickedDate!.year,
            curentPickedDate!.month,
            curentPickedDate!.day,
          ),
        );

        // อัปเดต UI หรือสถานะที่เกี่ยวข้อง
        checkBoxEnableCheck();
      });
    }
  }

  bool canEnableCheckBox() {
    if (curentPickedDate == null) return false;

    DateTime now = DateTime.now();
    DateTime currentDateOnly = DateTime(now.year, now.month, now.day);

    DateTime pickedDateOnly = DateTime(
      curentPickedDate!.year,
      curentPickedDate!.month,
      curentPickedDate!.day,
    );

    return pickedDateOnly.isAfter(currentDateOnly) ||
        pickedDateOnly.isAtSameMomentAs(currentDateOnly);
  }

// ฟังก์ชันอัปเดต checkbox เมื่อมีการเปลี่ยนแปลงวันที่
  void checkBoxEnableCheck() {
    setState(() {
      if (!canEnableCheckBox()) {
        isChecked = false; // ล้างค่าเมื่อเลือกวันที่ย้อนหลัง
      }
    });
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
                            header: 'รถยนต์ผู้มาติดต่อ',
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
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 24.0),
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
                                  TextFormField(
                                    controller: _model.textController1,
                                    focusNode: _model.textFieldFocusNode1,
                                    autofocus: false,
                                    obscureText: false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(
                                          r'^[A-Za-zก-๙0-9]+$')), // อนุญาตแค่ภาษาไทยและตัวเลข
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'เลขทะเบียน',
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
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      errorStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            fontSize: 14.0,
                                            useGoogleFonts:
                                                GoogleFonts.asMap().containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                            ),
                                          ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily),
                                        ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'กรุณากรอกเลขทะเบียน';
                                      }
                                      if (!RegExp(r'^[A-Za-zก-๙0-9]+$')
                                          .hasMatch(value)) {
                                        return 'กรุณากรอกเฉพาะตัวอักษรและตัวเลข';
                                      }

                                      return null;
                                    },
                                  ),
                                  DropdownSearch<ThaiaddressModel>(
                                    dialogMaxWidth: 100.0,
                                    maxHeight: 300.0,
                                    showSearchBox: true,
                                    dropdownSearchDecoration: InputDecoration(
                                      label: Text('จังหวัด'),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          8.0, 0.0, 0.0, 0.0),
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
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
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      errorStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            fontSize: 14.0,
                                            useGoogleFonts:
                                                GoogleFonts.asMap().containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                            ),
                                          ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
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
                                    validator: (value) {
                                      if (chwpartName == null ||
                                          chwpartName!.isEmpty) {
                                        return 'กรุณาเลือกจังหวัด';
                                      }
                                      return null;
                                    },
                                    dropdownBuilder: (context, selectedItem) =>
                                        selectedItem != null
                                            ? Text(
                                                (selectedItem
                                                            as ThaiaddressModel)
                                                        .name ??
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
                                        (item as ThaiaddressModel).name ?? '',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                    ),
                                    mode: Mode.MENU,
                                  ),
                                  DropdownSearch<Carbrand>(
                                    dialogMaxWidth: 100.0,
                                    maxHeight: 300.0,
                                    showSearchBox: true,
                                    dropdownSearchDecoration: InputDecoration(
                                      label: Text('ยี่ห้อรถยนต์'),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          8.0, 0.0, 0.0, 0.0),
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
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
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
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
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
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
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
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
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
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
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily),
                                        ),
                                    validator: _model.textController5Validator
                                        .asValidator(context),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: _model.textController6,
                                        focusNode: _model.textFieldFocusNode6,
                                        autofocus: false,
                                        readOnly: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'วันที่',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLargeFamily,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w300,
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
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeFamily),
                                            ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'กรุณาเลือกวันที่';
                                          }
                                          return null;
                                        },
                                      ),

                                      // Checkbox สำหรับเลือก "เข้าออกตลอดทั้งวัน"
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                              value: isChecked,
                                              onChanged: canEnableCheckBox()
                                                  ? (bool? value) {
                                                      setState(() {
                                                        isChecked = value!;
                                                      });
                                                    }
                                                  : null, // ปิดการทำงานเมื่อเงื่อนไขไม่ผ่าน
                                              activeColor: canEnableCheckBox()
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : Colors.grey,
                                              checkColor: Colors.white,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            Text(
                                              '  เข้า - ออกตลอดทั้งวัน',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        color: canEnableCheckBox()
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText
                                                            : Colors
                                                                .grey, // เปลี่ยนสีข้อความเมื่อปิดใช้งาน
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                      ),
                                            ),
                                          ],
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
                                  if (_formKey.currentState!.validate()) {
                                    // บันทึกข้อมูลตารางรถ
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
                                    vehicleData.is_resident = "N";
                                    vehicleData.villageproject_resident_id =
                                        widget.residentDetail!
                                            .villageproject_resident_id;
                                    vehicleData.villageproject_detail_id =
                                        widget.residentDetail!
                                            .villageproject_detail_id;

                                    // บันทึกข้อมูล Visitor
                                    VehicleVisitor visitorData =
                                        VehicleVisitor.newInstance();
                                    visitorData.vehicle_visitor_id =
                                        await serviceLocator<EHPApi>()
                                            .getSerialNumber(
                                                'vehicle_visitor_id',
                                                'vehicle_visitor',
                                                'vehicle_visitor_id');
                                    visitorData.vehicle_id =
                                        vehicleData.vehicle_id;
                                    visitorData.visitor_register_datetime =
                                        curentPickedDate;
                                    visitorData.villageproject_resident_id =
                                        widget.residentDetail!
                                            .villageproject_resident_id;
                                    visitorData.vehicle_visitor_status_id = 3;
                                    visitorData.is_all_day_access =
                                        isChecked ? "Y" : null;

                                    visitorData
                                        .villageproject_detail_id = widget
                                                .residentDetail
                                                ?.villageproject_detail_id !=
                                            null
                                        ? widget.residentDetail
                                            ?.villageproject_detail_id
                                        : null;

                                    ;

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
                                        .then((value) async => {
                                              // Navigator.pop(context)
                                              await VehicleVisitorController
                                                      .saveVehicleVisitor(
                                                          visitorData)
                                                  .then((value) =>
                                                      {Navigator.pop(context)})
                                            });

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
                          ].divide(SizedBox(height: 16.0)),
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
