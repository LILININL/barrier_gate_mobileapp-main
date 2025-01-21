import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/function_untils/controller/fireconfig.dart';
import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:barrier_gate/function_untils/controller/officer_picture_controller.dart';
import 'package:barrier_gate/function_untils/model/officer_model.dart';
import 'package:barrier_gate/function_untils/model/officer_picture_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/popup_sucess/popup_sucess_widget.dart';
import '/utils/title_widget/title_widget_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_profile_widget_model.dart';
export 'edit_profile_widget_model.dart';

class EditProfileWidgetWidget extends StatefulWidget {
  const EditProfileWidgetWidget({super.key});

  @override
  State<EditProfileWidgetWidget> createState() =>
      _EditProfileWidgetWidgetState();
}

class _EditProfileWidgetWidgetState extends State<EditProfileWidgetWidget> {
  late EditProfileWidgetModel _model;

  String? officerid;
  String? officerName;
  String? officerLoginName;
  String? base64ImageString;
  String? officeremail;
  Uint8List? imageBytes;

  OfficerPictureController pictureController =
      Get.put(OfficerPictureController());

  OfficerController officerController = Get.put(OfficerController());
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      final emailRegExp = RegExp(
        r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
      );

      if (!emailRegExp.hasMatch(value)) {
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      }
    }

    return null; // คืนค่า null เมื่อไม่มีข้อผิดพลาด
  }

  Future<void> loadOfficerPicture(int officerID) async {
    OfficerPicture officerPicture =
        await OfficerPictureController.getOfficerPictureFromID(officerID);

    if (officerPicture.image != null) {
      setState(() {
        imageBytes = officerPicture.image;
      });
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกเบอร์โทรศัพท์';
    }

    // ลบตัวอักษรที่ไม่ใช่ตัวเลขทั้งหมด
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length != 10) {
      return 'กรุณากรอกเบอร์โทรศัพท์ให้ครบ 10 หลัก';
    }

    // ฟอร์แมตเบอร์โทรศัพท์เป็น XXX-XXX-XXXX
    String formattedNumber = formatPhoneNumber(digitsOnly);

    // คืนค่า null เมื่อไม่มีข้อผิดพลาด
    return null;
  }

  String formatPhoneNumber(String digits) {
    if (digits.length != 10) return digits;
    return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6, 10)}';
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileWidgetModel());
    doGetOfficerDataFromAPI();

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController();
    _model.textFieldFocusNode6 ??= FocusNode();

    // _model.textController7 ??= TextEditingController();
    // _model.textFieldFocusNode7 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> doGetOfficerDataFromAPI() async {
    final prefs = Get.find<SharedPreferencesControllerCenter>();

    officerid = await prefs.getString('officer_id');

    if (officerid != null) {
      try {
        Officer officer =
            await OfficerController.getOfficerFromID(int.parse(officerid!));

        _model.textController1?.text = officer.officer_pname ?? '-';
        _model.textController2.text = officer.officer_fname ?? '- ';
        _model.textController3.text = officer.officer_lname ?? '- ';
        _model.textController4.text = officer.officer_phone ?? '- ';
        _model.textController5?.text = officer.officer_email ?? '-';
        // _model.textController7?.text = officer.line_id ?? '-';

        // ดึงรูปภาพของ Officer
        pictureController.fetchOfficerPicture(int.parse(officerid!));
      } catch (e) {
        print('Error fetching officer data: $e');
      }
    } else {
      print('No officer_id found in SharedPreferences');
    }
  }

  // // // Save camera data (add or update)
  Future<bool> saveEditofficer() async {
    Officer officerModel = Officer.newInstance();

    if (_model.textController1.text.isEmpty ||
        _model.textController2.text.isEmpty ||
        _model.textController3.text.isEmpty ||
        _model.textController4.text.isEmpty ||
        _model.textController5.text.isEmpty) {
      print('One or more fields are empty!');
      return false;
    }

    officerModel.officer_id = int.parse(officerid!);
    officerModel.officer_name = [
      _model.textController1.text.trim(),
      _model.textController2.text.trim(),
      _model.textController3.text.trim(),
    ].where((text) => text.isNotEmpty).join(' ');
    officerModel.officer_pname = _model.textController1.text;
    officerModel.officer_fname = _model.textController2.text;
    officerModel.officer_lname = _model.textController3.text;
    officerModel.officer_phone = _model.textController4.text;
    officerModel.officer_email = _model.textController5.text;
    officerModel.officer_phone = FirebaseApi.fcmtoken;

    bool success = await OfficerController.saveOfficer(officerModel);

    if (success) {
      final prefs = await SharedPreferencesControllerCenter.instance;
      await prefs.setString('officer_name', officerModel.officer_name ?? '');
    } else {
      print('Save officer failed');
    }

    print('Save officer result: $success');
    return success;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.8,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Color(0x33000000),
                offset: Offset(
                  0.0,
                  2.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 500.0,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            wrapWithModel(
                              model: _model.titleWidgetModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: TitleWidgetWidget(
                                title: 'แก้ไขข้อมูลผู้ใช้งาน',
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  0,
                                  200.0,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      'กรุณาตรวจสอบข้อมูลของคุณให้ดี',
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
                                  Autocomplete<String>(
                                    initialValue:
                                        TextEditingValue(text: 'นางสาว'),
                                    optionsBuilder: (textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<String>.empty();
                                      }
                                      return ['เด็กชาย', ''].where((option) {
                                        final lowercaseOption =
                                            option.toLowerCase();
                                        return lowercaseOption.contains(
                                            textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    optionsViewBuilder:
                                        (context, onSelected, options) {
                                      return AutocompleteOptionsList(
                                        textFieldKey: _model.textFieldKey1,
                                        textController: _model.textController1!,
                                        options: options.toList(),
                                        onSelected: onSelected,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                        textHighlightStyle: TextStyle(),
                                        elevation: 4.0,
                                        optionBackgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                        optionHighlightColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        maxHeight: 200.0,
                                      );
                                    },
                                    onSelected: (String selection) {
                                      safeSetState(() =>
                                          _model.textFieldSelectedOption1 =
                                              selection);
                                      FocusScope.of(context).unfocus();
                                    },
                                    fieldViewBuilder: (
                                      context,
                                      textEditingController,
                                      focusNode,
                                      onEditingComplete,
                                    ) {
                                      _model.textFieldFocusNode1 = focusNode;

                                      _model.textController1 =
                                          textEditingController;
                                      return TextFormField(
                                        key: _model.textFieldKey1,
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        onEditingComplete: onEditingComplete,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'คำนำหน้า',
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
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeFamily),
                                            ),
                                        validator: _model
                                            .textController1Validator
                                            .asValidator(context),
                                      );
                                    },
                                  ),
                                  TextFormField(
                                    controller: _model.textController2,
                                    focusNode: _model.textFieldFocusNode2,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'ชื่อ',
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
                                    validator: _model.textController2Validator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller: _model.textController3,
                                    focusNode: _model.textFieldFocusNode3,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'นามสกุล',
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
                                    validator: _model.textController3Validator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller: _model.textController4,
                                    focusNode: _model.textFieldFocusNode4,
                                    autofocus: false,
                                    obscureText: false,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'เบอร์โทรศัพท์',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .labelLargeFamily,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w300,
                                            useGoogleFonts:
                                                GoogleFonts.asMap().containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .labelLargeFamily,
                                            ),
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
                                          useGoogleFonts:
                                              GoogleFonts.asMap().containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyLargeFamily,
                                          ),
                                        ),
                                    validator: (value) {
                                      String? result =
                                          validatePhoneNumber(value);
                                      if (result == null) {
                                        // อัปเดตค่าในช่องป้อนข้อมูลเป็นรูปแบบที่ฟอร์แมตแล้ว
                                        // _model.textController4
                                        //         .text =
                                        //     formatPhoneNumber(
                                        //         value!.replaceAll(
                                        //             RegExp(
                                        //                 r'[^\d]'),
                                        //             ''));
                                      }
                                      return result;
                                    },
                                  ),
                                  Obx(() {
                                    return TextFormField(
                                      controller: _model.textController5,
                                      focusNode: _model.textFieldFocusNode5,
                                      autofocus: false,
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'E-mail',
                                        errorText: officerController
                                                .emailErrorText.value.isNotEmpty
                                            ? officerController
                                                .emailErrorText.value
                                            : null, // แสดง error เฉพาะเมื่อมีข้อความ error
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLargeFamily,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w300,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .labelLargeFamily,
                                              ),
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
                                        errorStyle: FlutterFlowTheme.of(context)
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
                                            useGoogleFonts:
                                                GoogleFonts.asMap().containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                            ),
                                          ),
                                      validator: (value) =>
                                          validateEmail(value),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          officerController
                                              .checkDuplicateEmail(value);
                                        } else {
                                          officerController
                                                  .emailErrorText.value =
                                              ''; // ล้าง error หากช่องว่าง
                                        }
                                      },
                                    );
                                  }),
                                  // TextFormField(
                                  //   controller: _model.textController6,
                                  //   focusNode: _model.textFieldFocusNode6,
                                  //   autofocus: false,
                                  //   obscureText: false,
                                  //   decoration: InputDecoration(
                                  //     labelText: 'line',
                                  //     labelStyle: FlutterFlowTheme.of(
                                  //             context)
                                  //         .labelLarge
                                  //         .override(
                                  //           fontFamily:
                                  //               FlutterFlowTheme.of(context)
                                  //                   .labelLargeFamily,
                                  //           letterSpacing: 0.0,
                                  //           fontWeight: FontWeight.w300,
                                  //           useGoogleFonts: GoogleFonts
                                  //                   .asMap()
                                  //               .containsKey(
                                  //                   FlutterFlowTheme.of(
                                  //                           context)
                                  //                       .labelLargeFamily),
                                  //         ),
                                  //     enabledBorder: OutlineInputBorder(
                                  //       borderSide: BorderSide(
                                  //         color:
                                  //             FlutterFlowTheme.of(context)
                                  //                 .alternate,
                                  //         width: 1.0,
                                  //       ),
                                  //       borderRadius:
                                  //           BorderRadius.circular(24.0),
                                  //     ),
                                  //     focusedBorder: OutlineInputBorder(
                                  //       borderSide: BorderSide(
                                  //         color:
                                  //             FlutterFlowTheme.of(context)
                                  //                 .primary,
                                  //         width: 1.0,
                                  //       ),
                                  //       borderRadius:
                                  //           BorderRadius.circular(24.0),
                                  //     ),
                                  //     errorBorder: OutlineInputBorder(
                                  //       borderSide: BorderSide(
                                  //         color:
                                  //             FlutterFlowTheme.of(context)
                                  //                 .error,
                                  //         width: 1.0,
                                  //       ),
                                  //       borderRadius:
                                  //           BorderRadius.circular(24.0),
                                  //     ),
                                  //     focusedErrorBorder:
                                  //         OutlineInputBorder(
                                  //       borderSide: BorderSide(
                                  //         color:
                                  //             FlutterFlowTheme.of(context)
                                  //                 .error,
                                  //         width: 1.0,
                                  //       ),
                                  //       borderRadius:
                                  //           BorderRadius.circular(24.0),
                                  //     ),
                                  //     contentPadding:
                                  //         EdgeInsetsDirectional.fromSTEB(
                                  //             16.0, 0.0, 16.0, 0.0),
                                  //   ),
                                  //   style: FlutterFlowTheme.of(context)
                                  //       .bodyLarge
                                  //       .override(
                                  //         fontFamily:
                                  //             FlutterFlowTheme.of(context)
                                  //                 .bodyLargeFamily,
                                  //         letterSpacing: 0.0,
                                  //         useGoogleFonts:
                                  //             GoogleFonts.asMap()
                                  //                 .containsKey(
                                  //                     FlutterFlowTheme.of(
                                  //                             context)
                                  //                         .bodyLargeFamily),
                                  //       ),
                                  //   validator: _model
                                  //       .textController6Validator
                                  //       .asValidator(context),
                                  // ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        print('object');

                                        bool success = await saveEditofficer();

                                        if (success) {
                                          // Show success popup
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  if (context.mounted &&
                                                      Navigator.of(context)
                                                          .canPop()) {
                                                    Navigator.of(context).pop();

                                                    if (success) {
                                                      context.pushReplacement(
                                                          '/meListView');
                                                    }
                                                  }
                                                });
                                                return PopupSucessWidget();
                                              });
                                        } else {}
                                      },
                                      text: 'ยืนยัน',
                                      options: FFButtonOptions(
                                        width: 100.0,
                                        height: 56.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Color(0x56227A4C),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmallFamily),
                                            ),
                                        elevation: 0.0,
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 24.0)),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ],
                    ),
                  ),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
