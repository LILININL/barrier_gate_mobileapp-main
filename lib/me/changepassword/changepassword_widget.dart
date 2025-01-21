// ignore_for_file: use_build_context_synchronously

import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/me/widget/buttonsheet_cancel_save_cp_widget/buttonsheet_cancel_save_cp_widget_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/popup_sucess/popup_sucess_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'changepassword_model.dart';
export 'changepassword_model.dart';

class ChangepasswordWidget extends StatefulWidget {
  const ChangepasswordWidget({super.key});

  @override
  State<ChangepasswordWidget> createState() => _ChangepasswordWidgetState();
}

class _ChangepasswordWidgetState extends State<ChangepasswordWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late ChangepasswordModel _model;
  String? officerId;
  String? storedPasswordMd5;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChangepasswordModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _loadUserData();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      officerId = prefs.getString('officer_id') ?? '';
      storedPasswordMd5 = prefs.getString('officer_login_password_md5') ?? '';
    });
  }

  Future<bool> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      if (storedPasswordMd5 == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถโหลดข้อมูลผู้ใช้ได้')),
        );
        return false;
      }

      var bytes = utf8.encode(_model.textController1!.text);
      var digest = md5.convert(bytes).toString().toUpperCase();

      if (digest != storedPasswordMd5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('รหัสผ่านเดิมไม่ถูกต้อง')),
        );
        return false;
      }

      var newBytes = utf8.encode(_model.textController2!.text);
      var newDigest = md5.convert(newBytes).toString().toUpperCase();

      // เรียก updatePassword และรับค่า bool เพื่อบอกสถานะ
      bool result = await OfficerController.updatePassword(
        int.parse(officerId!),
        newDigest,
      );

      if (result) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('officer_login_password_md5', newDigest);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ')),
        // );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน')),
        );
        return false;
      }
    }
    return false;
  }

  String? validateConfirmNewPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่านใหม่';
    }
    if (value != password) {
      return 'รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากำหนดรหัสผ่าน';
    }
    if (value.length < 8) {
      return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'รหัสผ่านต้องมีตัวอักษร A-Z อย่างน้อย 1 ตัว';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'รหัสผ่านต้องมีตัวอักษร a-z อย่างน้อย 1 ตัว';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'รหัสผ่านต้องมีตัวเลขอย่างน้อย 1 ตัว';
    }
    if (!RegExp(r'(?=.*[!@#/\*])').hasMatch(value)) {
      return 'รหัสผ่านต้องมีอักขระพิเศษอย่างน้อย 1 ตัว (!@#/*)';
    }
    return null;
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
      backgroundColor: const Color(0xFFBBF4F6),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: const AlignmentDirectional(0.0, -1.0),
            image: Image.asset(
              'assets/images/bgcpw.png',
            ).image,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
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
                      const Color(0x00FFFFFF)
                    ],
                    stops: [0.0, 1.0],
                    begin: const AlignmentDirectional(0.0, -1.0),
                    end: const AlignmentDirectional(0, 1.0),
                  ),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(0.0, 1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(),
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
                              barrierColor: const Color(0x3F000000),
                              isDismissible: false,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child:
                                      const ButtonsheetCancelSaveCpWidgetWidget(),
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
                          child: const HeaderWidgetWidget(
                            header: 'เปลี่ยนรหัสผ่าน',
                          ),
                        ),
                      ),
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(),
                      ),
                    ]
                        .divide(const SizedBox(width: 16.0))
                        .around(const SizedBox(width: 16.0)),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    boxShadow: [
                      const BoxShadow(
                        blurRadius: 8.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                      )
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, -1.0),
                          child: Icon(
                            Icons.key_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 60.0,
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            'ตั้งค่ารหัสผ่านของคุณใหม่',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w300,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  controller: _model.textController1,
                                  focusNode: _model.textFieldFocusNode1,
                                  autofocus: false,
                                  obscureText: !_model.passwordVisibility1,
                                  decoration: InputDecoration(
                                    labelText: 'รหัสผ่านปัจจุบัน',
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
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    suffixIcon: InkWell(
                                      onTap: () => safeSetState(
                                        () => _model.passwordVisibility1 =
                                            !_model.passwordVisibility1,
                                      ),
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility1
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
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
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily),
                                      ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกรหัสผ่านเดิม';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  controller: _model.textController2,
                                  focusNode: _model.textFieldFocusNode2,
                                  autofocus: false,
                                  obscureText: !_model.passwordVisibility2,
                                  decoration: InputDecoration(
                                    labelText: 'รหัสผ่านใหม่',
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
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    suffixIcon: InkWell(
                                      onTap: () => safeSetState(
                                        () => _model.passwordVisibility2 =
                                            !_model.passwordVisibility2,
                                      ),
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility2
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
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
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily),
                                      ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[^\u0E00-\u0E7F\s]*$')),
                                  ],
                                  validator: (value) {
                                    // ตรวจสอบทั้งรหัสผ่านและความตรงกัน
                                    final passwordValidation =
                                        validatePassword(value);
                                    final confirmPasswordValidation =
                                        validateConfirmNewPassword(
                                      value,
                                      _model.textController3.text,
                                    );

                                    if (passwordValidation != null &&
                                        confirmPasswordValidation != null) {
                                      return '$passwordValidation\n$confirmPasswordValidation';
                                    } else if (passwordValidation != null) {
                                      return passwordValidation;
                                    } else if (confirmPasswordValidation !=
                                        null) {
                                      return confirmPasswordValidation;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  controller: _model.textController3,
                                  focusNode: _model.textFieldFocusNode3,
                                  autofocus: false,
                                  obscureText: !_model.passwordVisibility3,
                                  decoration: InputDecoration(
                                    labelText: 'ยืนยันรหัสผ่านใหม่',
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
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    suffixIcon: InkWell(
                                      onTap: () => safeSetState(
                                        () => _model.passwordVisibility3 =
                                            !_model.passwordVisibility3,
                                      ),
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility3
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
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
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily),
                                      ),
                                  validator: (value) {
                                    // ตรวจสอบทั้งรหัสผ่านและความตรงกัน
                                    final passwordValidation =
                                        validatePassword(value);
                                    final confirmPasswordValidation =
                                        validateConfirmNewPassword(
                                      value,
                                      _model.textController2.text,
                                    );

                                    if (passwordValidation != null &&
                                        confirmPasswordValidation != null) {
                                      return '$passwordValidation\n$confirmPasswordValidation';
                                    } else if (passwordValidation != null) {
                                      return passwordValidation;
                                    } else if (confirmPasswordValidation !=
                                        null) {
                                      return confirmPasswordValidation;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-1.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'หมายเหตุ',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              ),
                              Text(
                                'ความยาวอย่างน้อย 8 ตัว',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w300,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily),
                                    ),
                              ),
                              Text(
                                'A - Z  อย่างน้อย 1 ตัว',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w300,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily),
                                    ),
                              ),
                              Text(
                                'a - z  อย่างน้อย 1 ตัว',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w300,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily),
                                    ),
                              ),
                              Text(
                                'ตัวเลขอย่างน้อย 1 ตัว',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w300,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily),
                                    ),
                              ),
                              Text(
                                'รหัสผ่านและยืนยันรหัสผ่านต้องตรงกัน',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w300,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily),
                                    ),
                              ),
                            ].divide(const SizedBox(height: 4.0)),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              bool isPasswordChanged = await _changePassword();

                              if (isPasswordChanged) {
                                // แสดง Popup Success
                                showDialog(
                                  context: context, // ใช้ context ปัจจุบัน
                                  builder: (BuildContext dialogContext) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () async {
                                      // ลบข้อมูล SharedPreferences ทั้งหมด
                                      await SharedPreferencesControllerCenter
                                          .instance
                                          .clearAll();

                                      // ตรวจสอบว่าหน้ายังเปิดอยู่หรือไม่
                                      if (mounted) {
                                        if (Navigator.of(dialogContext,
                                                rootNavigator: true)
                                            .canPop()) {
                                          Navigator.of(dialogContext,
                                                  rootNavigator: true)
                                              .pop();
                                        }
                                        context.go(
                                            '/loginListView'); // ไปที่หน้า login
                                      }
                                    });

                                    return const PopupSucessWidget();
                                  },
                                );
                              } else {
                                // กรณีเปลี่ยนรหัสผ่านไม่สำเร็จ
                              }
                            },
                            text: 'ยืนยัน',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 56.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
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
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 24.0)),
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
