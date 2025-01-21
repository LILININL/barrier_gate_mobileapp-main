import 'dart:convert';

import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/function_untils/controller/officer_controller.dart';
import 'package:barrier_gate/function_untils/controller/officer_picture_controller.dart';
import 'package:barrier_gate/function_untils/model/officer_model.dart';
import 'package:barrier_gate/function_untils/model/officer_picture_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/me/widget/buttonsheet_more_profile_widget/buttonsheet_more_profile_widget_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_list_view_model.dart';
export 'profile_list_view_model.dart';

class ProfileListViewWidget extends StatefulWidget {
  const ProfileListViewWidget({super.key});

  @override
  State<ProfileListViewWidget> createState() => _ProfileListViewWidgetState();
}

class _ProfileListViewWidgetState extends State<ProfileListViewWidget> {
  late ProfileListViewModel _model;

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
  void initState() {
    super.initState();
    doGetOfficerDataFromAPI();
    _model = createModel(context, () => ProfileListViewModel());

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

  Future<void> loadOfficerPicture(int officerID) async {
    OfficerPicture officerPicture =
        await OfficerPictureController.getOfficerPictureFromID(officerID);

    if (officerPicture.image != null) {
      setState(() {
        imageBytes = officerPicture.image;
      });
    }
  }

  Future<void> doGetOfficerDataFromAPI() async {
    final prefs = Get.find<SharedPreferencesControllerCenter>();

    officerid = await prefs.getString('officer_id');

    if (officerid != null) {
      try {
        Officer officer =
            await OfficerController.getOfficerFromID(int.parse(officerid!));

        _model.textController1?.text = officer.officer_login_name ?? '-';
        _model.textController2.text = officer.officer_pname ?? '- ';
        _model.textController3.text = officer.officer_fname ?? '- ';
        _model.textController4.text = officer.officer_lname ?? '- ';
        _model.textController5.text = officer.officer_phone ?? '- ';
        _model.textController6?.text = officer.officer_email ?? '-';
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
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              onPressed: () {
                                context.pushReplacement('/meListView');
                              },
                            ),
                          ),
                          Expanded(
                            child: wrapWithModel(
                              model: _model.headerWidgetModel,
                              updateCallback: () => safeSetState(() {}),
                              child: HeaderWidgetWidget(
                                header: 'ข้อมูลผู้ใช้งาน',
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
                                      child:
                                          ButtonsheetMoreProfileWidgetWidget(),
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
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent1,
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Container(
                                        width: 200.0,
                                        height: 200.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Obx(() {
                                          if (pictureController
                                              .isLoading.value) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (pictureController
                                              .errorMessage.isNotEmpty) {
                                            return Image.asset(
                                              'assets/images/user.png',
                                              fit: BoxFit.cover,
                                            );
                                          } else if (pictureController
                                                  .officerPictures.isNotEmpty &&
                                              pictureController.officerPictures
                                                      .first.image !=
                                                  null) {
                                            return Image.memory(
                                              pictureController
                                                  .officerPictures.first.image!,
                                              fit: BoxFit.cover,
                                            );
                                          } else {
                                            return Image.asset(
                                              'assets/images/user.png',
                                              fit: BoxFit.cover,
                                            );
                                          }
                                        })),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(1.0, 1.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        final List<SelectedFile>?
                                            selectedMediaList =
                                            await selectMediaWithSourceBottomSheet(
                                          context: context,
                                          maxWidth: 1024.00,
                                          maxHeight: 1024.00,
                                          imageQuality: 100,
                                          allowPhoto: true,
                                          includeDimensions: true,
                                          includeBlurHash: true,
                                        );

                                        if (selectedMediaList != null &&
                                            selectedMediaList.isNotEmpty) {
                                          final selectedMedia =
                                              selectedMediaList
                                                  .first; // ใช้ไฟล์แรกที่เลือก

                                          // อ่านไฟล์เป็น Uint8List
                                          final Uint8List imageBytes =
                                              selectedMedia.bytes;

                                          // เริ่มอัปโหลด
                                          safeSetState(() =>
                                              _model.isDataUploading = true);

                                          await pictureController
                                              .uploadOfficerPicture(imageBytes);

                                          await pictureController
                                              .fetchOfficerPicture(
                                                  int.parse(officerid!));

                                          final String base64String =
                                              base64Encode(imageBytes);
                                          await Get.find<
                                                  SharedPreferencesControllerCenter>()
                                              .setString(
                                                  'officerImage', base64String);

                                          safeSetState(() {
                                            _model.uploadedLocalFile =
                                                FFUploadedFile(
                                              name: selectedMedia.filePath,
                                              bytes: imageBytes,
                                            );
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 32.0,
                                        height: 32.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Text(
                                  'บัญชีผู้ใช้งาน',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
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
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _model.textController1,
                                              focusNode:
                                                  _model.textFieldFocusNode1,
                                              autofocus: false,
                                              readOnly: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: false,
                                                labelText: 'ชื่อบัญชีผู้ใช้งาน',
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
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                      ),
                                              validator: _model
                                                  .textController1Validator
                                                  .asValidator(context),
                                            ),
                                          ].divide(SizedBox(height: 16.0)),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Text(
                                  'ข้อมูลผู้ใช้งาน',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
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
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
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
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _model.textController2,
                                              focusNode:
                                                  _model.textFieldFocusNode2,
                                              autofocus: false,
                                              readOnly: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: false,
                                                labelText: 'คำนำหน้า',
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
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                      ),
                                              validator: _model
                                                  .textController2Validator
                                                  .asValidator(context),
                                            ),
                                            Divider(
                                              height: 1.0,
                                              thickness: 1.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            TextFormField(
                                              controller:
                                                  _model.textController3,
                                              focusNode:
                                                  _model.textFieldFocusNode3,
                                              autofocus: false,
                                              readOnly: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: false,
                                                labelText: 'ชื่อ',
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
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                      ),
                                              validator: _model
                                                  .textController3Validator
                                                  .asValidator(context),
                                            ),
                                            Divider(
                                              height: 1.0,
                                              thickness: 1.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            TextFormField(
                                              controller:
                                                  _model.textController4,
                                              focusNode:
                                                  _model.textFieldFocusNode4,
                                              autofocus: false,
                                              readOnly: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: false,
                                                labelText: 'นามสุกล',
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
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                      ),
                                              validator: _model
                                                  .textController4Validator
                                                  .asValidator(context),
                                            ),
                                            Divider(
                                              height: 1.0,
                                              thickness: 1.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            TextFormField(
                                              controller:
                                                  _model.textController5,
                                              focusNode:
                                                  _model.textFieldFocusNode5,
                                              autofocus: false,
                                              readOnly: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: false,
                                                labelText: 'เบอร์โทรศัพท์',
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
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                      ),
                                              validator: _model
                                                  .textController5Validator
                                                  .asValidator(context),
                                            ),
                                            Divider(
                                              height: 1.0,
                                              thickness: 1.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            TextFormField(
                                              controller:
                                                  _model.textController6,
                                              focusNode:
                                                  _model.textFieldFocusNode6,
                                              autofocus: false,
                                              readOnly: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: false,
                                                labelText: 'E-mail',
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
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                      ),
                                              validator: _model
                                                  .textController6Validator
                                                  .asValidator(context),
                                            ),
                                            // Divider(
                                            //   height: 1.0,
                                            //   thickness: 1.0,
                                            //   color:
                                            //       FlutterFlowTheme.of(context)
                                            //           .alternate,
                                            // ),
                                            // TextFormField(
                                            //   controller:
                                            //       _model.textController7,
                                            //   focusNode:
                                            //       _model.textFieldFocusNode7,
                                            //   autofocus: false,
                                            //   readOnly: true,
                                            //   obscureText: false,
                                            //   decoration: InputDecoration(
                                            //     isDense: false,
                                            //     labelText: 'ID line',
                                            //     labelStyle:
                                            //         FlutterFlowTheme.of(context)
                                            //             .labelLarge
                                            //             .override(
                                            //               fontFamily:
                                            //                   FlutterFlowTheme.of(
                                            //                           context)
                                            //                       .labelLargeFamily,
                                            //               letterSpacing: 0.0,
                                            //               fontWeight:
                                            //                   FontWeight.w300,
                                            //               useGoogleFonts: GoogleFonts
                                            //                       .asMap()
                                            //                   .containsKey(
                                            //                       FlutterFlowTheme.of(
                                            //                               context)
                                            //                           .labelLargeFamily),
                                            //             ),
                                            //     enabledBorder: InputBorder.none,
                                            //     focusedBorder: InputBorder.none,
                                            //     errorBorder: InputBorder.none,
                                            //     focusedErrorBorder:
                                            //         InputBorder.none,
                                            //   ),
                                            //   style:
                                            //       FlutterFlowTheme.of(context)
                                            //           .bodyLarge
                                            //           .override(
                                            //             fontFamily:
                                            //                 FlutterFlowTheme.of(
                                            //                         context)
                                            //                     .bodyLargeFamily,
                                            //             letterSpacing: 0.0,
                                            //             useGoogleFonts: GoogleFonts
                                            //                     .asMap()
                                            //                 .containsKey(
                                            //                     FlutterFlowTheme.of(
                                            //                             context)
                                            //                         .bodyLargeFamily),
                                            //           ),
                                            //   validator: _model
                                            //       .textController7Validator
                                            //       .asValidator(context),
                                            // ),
                                          ].divide(SizedBox(height: 8.0)),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ].divide(SizedBox(height: 24.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
