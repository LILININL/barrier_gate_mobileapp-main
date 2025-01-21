import 'dart:convert';
import 'dart:io';

import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_locator.dart';
import 'package:barrier_gate/function_untils/controller/officer_picture_controller.dart';

import 'package:barrier_gate/function_untils/model/officer_model.dart';
import 'package:barrier_gate/function_untils/model/officer_picture_model.dart';
import 'package:barrier_gate/function_untils/model/prename_model.dart';
import 'package:barrier_gate/home/home_list_view/home_list_view_widget.dart';
import 'package:barrier_gate/login/signup/preAcontroller.dart';
import 'package:barrier_gate/utils/popup_loading/popup_loading_widget.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../function_untils/controller/officer_controller.dart';
import '../../include_widget/dropdown_search2/lib/dropdown_search2.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signup_model.dart';
export 'signup_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  late SignupModel _model;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Prename> prenameList = [];
  String prename = '';
  bool isTextVisible = false;
  bool isTextPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final prefs = Get.find<SharedPreferencesControllerCenter>();
  final officerController = Get.put(OfficerController());
  var phonntoken = RxnString();

  bool isFormSubmitted = false;

  PrenameAController prenameController = Get.put(PrenameAController());
  Prename? selectedPrename;

  @override
  void initState() {
    super.initState();
    prenameController.loadPrenamesFromPrefs();
    doGetSharedPreferences();
    _model = createModel(context, () => SignupModel());

    _model.textController1 ??= TextEditingController();

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

    _model.textController7 ??= TextEditingController();

    _model.textController8 ??= TextEditingController();
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController9 ??= TextEditingController();
    _model.textFieldFocusNode9 ??= FocusNode();
    //   getSharedLookup();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  // getSharedLookup() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   final prenameListSP = prefs.getStringList('prenameList');
  //   prenameList = prenameListSP!.map((jsonString) {
  //     Map<String, dynamic> json = jsonDecode(jsonString);
  //     return Prename.newInstance().fromJson(json);
  //   }).toList();
  // }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> doGetSharedPreferences() async {
    phonntoken.value = await prefs.getString('fcmToken');
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

  String? validatePrename(Prename? value) {
    if (value == null) {
      return 'กรุณาเลือกคำนำหน้า';
    }
    return null;
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากำหนดรหัสผ่าน';
    }
    if (value.length < 8) {
      return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'รหัสผ่านต้องมีตัวอักษร A-Z ตัวใหญ่อย่างน้อย 1 ตัว';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'รหัสผ่านต้องมีตัวอักษร a-z ตัวเล็กอย่างน้อย 1 ตัว';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'รหัสผ่านต้องมีตัวเลขอย่างน้อย 1 ตัว';
    }
    if (!RegExp(r'(?=.*[!@#/\*])').hasMatch(value)) {
      return 'รหัสผ่านต้องมีอักขระพิเศษอย่างน้อย 1 ตัว (!@#/*)';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }
    if (value != password) {
      return 'รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน';
    }
    return null;
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

// _showPickerDialog(context); // แสดง dialog
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
              'assets/images/bg3.png',
            ).image,
          ),
        ),
        child: Form(
          key: _formKey,
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
                              header: 'ลงทะเบียน',
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
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    PageView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: _model.pageViewController ??=
                                          PageController(initialPage: 0),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: ListView(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 24.0),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, -1.0),
                                                    child: Container(
                                                      width: 100.0,
                                                      height: 100.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent1,
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: _image != null
                                                              ? FileImage(File(
                                                                  _image!.path))
                                                              : AssetImage(
                                                                      'assets/images/user.png')
                                                                  as ImageProvider<
                                                                      Object>,
                                                          fit: BoxFit
                                                              .cover, // ทำให้รูปภาพพอดีกับวงกลม
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    1.0, 1.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                _showPickerDialog(
                                                                    context); // แสดง dialog ให้เลือกกล้องหรือแกลเลอรี
                                                              },
                                                              child: Container(
                                                                width: 32.0,
                                                                height: 32.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
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
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      'กรุณากรอกข้อมูลให้ครบถ้วน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                                  Obx(() {
                                                    if (prenameController
                                                        .isLoading.value) {
                                                      return const SizedBox
                                                          .shrink();
                                                    }

                                                    if (prenameController
                                                        .prenames.isEmpty) {
                                                      prenameController
                                                          .loadPrenamesFromPrefs();
                                                    }

                                                    // แสดง error เมื่อ isFormSubmitted เป็น true และไม่ได้เลือก prename
                                                    final errorMessage =
                                                        isFormSubmitted
                                                            ? validatePrename(
                                                                selectedPrename)
                                                            : null;

                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FormField<Prename>(
                                                          validator: (value) =>
                                                              validatePrename(
                                                                  selectedPrename),
                                                          builder:
                                                              (FormFieldState<
                                                                      Prename>
                                                                  field) {
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                DropdownSearch<
                                                                    Prename>(
                                                                  dialogMaxWidth:
                                                                      100.0,
                                                                  maxHeight:
                                                                      300.0,
                                                                  showSearchBox:
                                                                      true,
                                                                  dropdownSearchDecoration:
                                                                      InputDecoration(
                                                                    label: const Text(
                                                                        'คำนำหน้า'),
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: errorMessage !=
                                                                                null
                                                                            ? FlutterFlowTheme.of(context).error
                                                                            : FlutterFlowTheme.of(context).primary,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    disabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: errorMessage !=
                                                                                null
                                                                            ? FlutterFlowTheme.of(context).error // เปลี่ยนเป็นสีแดงเมื่อมี error
                                                                            : FlutterFlowTheme.of(context).tertiary,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    errorText:
                                                                        errorMessage,
                                                                    errorStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          fontSize:
                                                                              14.0,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          ),
                                                                        ),
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              const Color(0xFF868686),
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  items: prenameController
                                                                      .prenames,
                                                                  itemAsString:
                                                                      (item) =>
                                                                          item?.prename_name ??
                                                                          '',
                                                                  compareFn: (i,
                                                                          s) =>
                                                                      (i?.prename_name ??
                                                                          '') ==
                                                                      (s?.prename_name ??
                                                                          ''),
                                                                  onChanged:
                                                                      (item) {
                                                                    setState(
                                                                        () {
                                                                      selectedPrename =
                                                                          item;
                                                                      isFormSubmitted =
                                                                          false; // ปิด error เมื่อเลือก
                                                                    });
                                                                    prenameController
                                                                        .update();
                                                                  },
                                                                  dropdownBuilder: (context,
                                                                          selectedItem) =>
                                                                      selectedItem !=
                                                                              null
                                                                          ? Text(
                                                                              selectedItem.prename_name ?? '',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Colors.black,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                                                      FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    ),
                                                                                  ),
                                                                            )
                                                                          : Text(
                                                                              '',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: const Color(0xFF868686),
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                                                      FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    ),
                                                                                  ),
                                                                            ),
                                                                  popupItemBuilder:
                                                                      (context,
                                                                              item,
                                                                              isSelected) =>
                                                                          Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            12,
                                                                        horizontal:
                                                                            12),
                                                                    child: Text(
                                                                      item.prename_name ??
                                                                          '',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium,
                                                                    ),
                                                                  ),
                                                                  mode:
                                                                      Mode.MENU,
                                                                ),
                                                                if (field
                                                                    .hasError)
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        top:
                                                                            4.0),
                                                                    child: Text(
                                                                      field.errorText ??
                                                                          '',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            useGoogleFonts:
                                                                                GoogleFonts.asMap().containsKey(
                                                                              FlutterFlowTheme.of(context).bodySmallFamily,
                                                                            ),
                                                                          ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                  TextFormField(
                                                    controller:
                                                        _model.textController2,
                                                    focusNode: _model
                                                        .textFieldFocusNode2,
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'ชื่อ',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                fontSize: 14.0,
                                                                useGoogleFonts:
                                                                    GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                ),
                                                              ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'กรุณากรอกชื่อ';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        _model.textController3,
                                                    focusNode: _model
                                                        .textFieldFocusNode3,
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'นามสกุล',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                fontSize: 14.0,
                                                                useGoogleFonts:
                                                                    GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                ),
                                                              ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'กรุณากรอกนามสกุล';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        _model.textController4,
                                                    focusNode: _model
                                                        .textFieldFocusNode4,
                                                    autofocus: false,
                                                    obscureText: false,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          10),
                                                    ],
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'เบอร์โทรศัพท์',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts:
                                                                    GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily,
                                                                ),
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                fontSize: 14.0,
                                                                useGoogleFonts:
                                                                    GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                ),
                                                              ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLargeFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              GoogleFonts
                                                                      .asMap()
                                                                  .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                          ),
                                                        ),
                                                    validator: (value) {
                                                      String? result =
                                                          validatePhoneNumber(
                                                              value);
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
                                                      controller: _model
                                                          .textController5,
                                                      focusNode: _model
                                                          .textFieldFocusNode5,
                                                      autofocus: false,
                                                      obscureText: false,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'E-mail',
                                                        errorText: officerController
                                                                .emailErrorText
                                                                .value
                                                                .isNotEmpty
                                                            ? officerController
                                                                .emailErrorText
                                                                .value
                                                            : null, // แสดง error เฉพาะเมื่อมีข้อความ error
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  useGoogleFonts:
                                                                      GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelLargeFamily,
                                                                  ),
                                                                ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                        ),
                                                        errorStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  fontSize:
                                                                      14.0,
                                                                  useGoogleFonts:
                                                                      GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumFamily,
                                                                  ),
                                                                ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLargeFamily,
                                                            ),
                                                          ),
                                                      validator: (value) =>
                                                          validateEmail(value),
                                                      onChanged: (value) {
                                                        if (value.isNotEmpty) {
                                                          officerController
                                                              .checkDuplicateEmail(
                                                                  value);
                                                        } else {
                                                          officerController
                                                                  .emailErrorText
                                                                  .value =
                                                              ''; // ล้าง error หากช่องว่าง
                                                        }
                                                      },
                                                    );
                                                  }),
                                                ].divide(
                                                    SizedBox(height: 24.0)),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, -1.0),
                                              child: FlutterFlowIconButton(
                                                  borderColor:
                                                      Colors.transparent,
                                                  borderRadius: 100.0,
                                                  buttonSize: 56.0,
                                                  fillColor: Color(0x56227A4C),
                                                  icon: Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () async {
                                                    isFormSubmitted = true;
                                                    prenameController
                                                        .update(); // อัปเดต UI เพื่อแสดง error text

                                                    final officerController =
                                                        Get.find<
                                                            OfficerController>();

                                                    // ตรวจสอบฟอร์ม
                                                    if (_formKey.currentState!
                                                            .validate() &&
                                                        validatePrename(
                                                                selectedPrename) ==
                                                            null) {
                                                      // ดักว่าถ้ามี error ใน email ไม่ให้ไปหน้าถัดไป
                                                      if (officerController
                                                          .emailErrorText
                                                          .value
                                                          .isNotEmpty) {
                                                        return;
                                                      }

                                                      // ถ้าไม่มี error ให้เปลี่ยนหน้า
                                                      await _model
                                                          .pageViewController
                                                          ?.nextPage(
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    } else {
                                                      print('Form is invalid');
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: ListView(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 24.0),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      'กรุณากรอกข้อมูลให้ครบถ้วน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                                  TextFormField(
                                                    key: _model.textFieldKey7,
                                                    controller:
                                                        _model.textController7,
                                                    focusNode: _model
                                                        .textFieldFocusNode7,
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'ชื่อผู้ใช้งาน',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                fontSize: 14.0,
                                                                useGoogleFonts:
                                                                    GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                ),
                                                              ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                        RegExp(
                                                            r'^[^\u0E00-\u0E7F\s]*$'), // Regular expression to block Thai and spaces
                                                      ),
                                                    ],
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'กรุณากรอกชื่อผู้ใช้งาน';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        _model.textController8,
                                                    focusNode: _model
                                                        .textFieldFocusNode8,
                                                    autofocus: false,
                                                    obscureText: !_model
                                                        .passwordVisibility1,
                                                    decoration: InputDecoration(
                                                      labelText: 'รหัสผ่าน',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                fontSize: 14.0,
                                                                useGoogleFonts:
                                                                    GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                ),
                                                              ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      suffixIcon: InkWell(
                                                        onTap: () =>
                                                            safeSetState(
                                                          () => _model
                                                                  .passwordVisibility1 =
                                                              !_model
                                                                  .passwordVisibility1,
                                                        ),
                                                        focusNode: FocusNode(
                                                            skipTraversal:
                                                                true),
                                                        child: Icon(
                                                          _model.passwordVisibility1
                                                              ? Icons
                                                                  .visibility_outlined
                                                              : Icons
                                                                  .visibility_off_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'^[^\u0E00-\u0E7F\s]*$')),
                                                    ],
                                                    validator: (value) {
                                                      final passwordValidation =
                                                          validatePassword(
                                                              value);
                                                      final confirmPasswordValidation =
                                                          validateConfirmPassword(
                                                        value,
                                                        _model.textController9
                                                            .text,
                                                      );

                                                      if (passwordValidation !=
                                                              null &&
                                                          confirmPasswordValidation !=
                                                              null) {
                                                        return '$passwordValidation\n$confirmPasswordValidation';
                                                      } else if (passwordValidation !=
                                                          null) {
                                                        return passwordValidation;
                                                      } else if (confirmPasswordValidation !=
                                                          null) {
                                                        return confirmPasswordValidation;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        _model.textController9,
                                                    focusNode: _model
                                                        .textFieldFocusNode9,
                                                    autofocus: false,
                                                    obscureText: !_model
                                                        .passwordVisibility2,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'ยืนยันรหัสผ่าน',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                fontSize: 14.0,
                                                                useGoogleFonts:
                                                                    GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                ),
                                                              ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      suffixIcon: InkWell(
                                                        onTap: () =>
                                                            safeSetState(
                                                          () => _model
                                                                  .passwordVisibility2 =
                                                              !_model
                                                                  .passwordVisibility2,
                                                        ),
                                                        focusNode: FocusNode(
                                                            skipTraversal:
                                                                true),
                                                        child: Icon(
                                                          _model.passwordVisibility2
                                                              ? Icons
                                                                  .visibility_outlined
                                                              : Icons
                                                                  .visibility_off_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'^[^\u0E00-\u0E7F\s]*$')),
                                                    ],
                                                    validator: (value) {
                                                      final passwordValidation =
                                                          validatePassword(
                                                              value);
                                                      final confirmPasswordValidation =
                                                          validateConfirmPassword(
                                                        value,
                                                        _model.textController8
                                                            .text,
                                                      );

                                                      if (passwordValidation !=
                                                              null &&
                                                          confirmPasswordValidation !=
                                                              null) {
                                                        return '$passwordValidation\n$confirmPasswordValidation';
                                                      } else if (passwordValidation !=
                                                          null) {
                                                        return passwordValidation;
                                                      } else if (confirmPasswordValidation !=
                                                          null) {
                                                        return confirmPasswordValidation;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (isTextVisible)
                                                        Text(
                                                          'มี Username นี้แล้ว!',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .red, // ตั้งค่าสีตัวอักษรเป็นสีแดง
                                                          ),
                                                        ),
                                                      if (isTextPasswordVisible)
                                                        Text(
                                                          'ระบุ Password ไม่ถูกต้อง',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .red, // ตั้งค่าสีตัวอักษรเป็นสีแดง
                                                          ),
                                                        ),
                                                      Text(
                                                        'หมายเหตุ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                      ),
                                                      Text(
                                                        'ความยาวอย่างน้อย 8 ตัว',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
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
                                                      Text(
                                                        'A - Z  อย่างน้อย 1 ตัว',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
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
                                                      Text(
                                                        'a - z  อย่างน้อย 1 ตัว',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
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
                                                      Text(
                                                        'ตัวเลขอย่างน้อย 1 ตัว',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
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
                                                      Text(
                                                        'รหัสผ่านและยืนยันรหัสผ่านต้องตรงกัน',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
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
                                                    ].divide(
                                                        SizedBox(height: 8.0)),
                                                  ),
                                                ].divide(
                                                    SizedBox(height: 24.0)),
                                              ),
                                            ),
                                            FFButtonWidget(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  if (_model.textController8
                                                          .text !=
                                                      _model.textController9
                                                          .text) {
                                                    print('รหัสผ่านไม่ถูกต้อง');
                                                  } else {
                                                    bool isHaveUserLogin =
                                                        await OfficerController()
                                                            .getOfficerFromLoginname(
                                                                _model
                                                                    .textController7
                                                                    .text);

                                                    if (!isHaveUserLogin) {
                                                      var bytes = utf8.encode(
                                                          _model.textController8
                                                              .text);
                                                      var digest =
                                                          md5.convert(bytes);

                                                      Officer officerModel =
                                                          Officer.newInstance();
                                                      officerModel.officer_id =
                                                          await serviceLocator<
                                                                  EHPApi>()
                                                              .getSerialNumber(
                                                                  'officer_id',
                                                                  'officer',
                                                                  'officer_id');
                                                      officerModel
                                                              .officer_name =
                                                          selectedPrename!
                                                                  .prename_name!
                                                                  .toString() +
                                                              _model
                                                                  .textController2
                                                                  .text +
                                                              '  ' +
                                                              _model
                                                                  .textController3
                                                                  .text;
                                                      officerModel
                                                              .officer_login_name =
                                                          _model.textController7
                                                              .text;
                                                      officerModel
                                                              .officer_login_password_md5 =
                                                          digest
                                                              .toString()
                                                              .toUpperCase();
                                                      officerModel
                                                              .officer_login_password =
                                                          digest
                                                              .toString()
                                                              .toUpperCase();

                                                      // encryptMyData(_model
                                                      //         .textController8
                                                      //         .text)
                                                      //     .toUpperCase();
                                                      officerModel
                                                              .officer_pname =
                                                          selectedPrename!
                                                              .prename_name!
                                                              .toString();
                                                      officerModel
                                                              .officer_fname =
                                                          _model.textController2
                                                              .text;
                                                      officerModel
                                                              .officer_lname =
                                                          _model.textController3
                                                              .text;
                                                      officerModel
                                                              .officer_phone =
                                                          _model.textController4
                                                              .text;
                                                      officerModel
                                                              .officer_email =
                                                          _model.textController5
                                                              .text;
                                                      officerModel.is_resident =
                                                          "Y";

                                                      officerModel
                                                          .officer_active = "Y";

                                                      officerModel.token_phone =
                                                          phonntoken.toString();

                                                      if (_image != null) {
                                                        OfficerPicture
                                                            officerPictureModel =
                                                            OfficerPicture
                                                                .newInstance();
                                                        officerPictureModel
                                                                .officer_picture_id =
                                                            await serviceLocator<
                                                                    EHPApi>()
                                                                .getSerialNumber(
                                                                    'officer_picture_id',
                                                                    'officer_picture',
                                                                    'officer_picture_id');

                                                        Uint8List imageBytes =
                                                            await _image!
                                                                .readAsBytes();
                                                        img.Image? image =
                                                            img.decodeImage(
                                                                imageBytes);

                                                        if (image != null) {
                                                          img.Image
                                                              resizedImage =
                                                              img.copyResize(
                                                                  image,
                                                                  width: 800);
                                                          Uint8List
                                                              compressedImage =
                                                              Uint8List.fromList(
                                                                  img.encodeJpg(
                                                                      resizedImage,
                                                                      quality:
                                                                          80));
                                                          officerPictureModel
                                                                  .image =
                                                              compressedImage;
                                                          String base64String =
                                                              base64Encode(
                                                                  compressedImage);
                                                          await prefs.setString(
                                                              'officerImage',
                                                              base64String);
                                                        } else {
                                                          await prefs.setString(
                                                              'officerImage',
                                                              '');
                                                        }

                                                        officerPictureModel
                                                                .officer_id =
                                                            officerModel
                                                                .officer_id!;
                                                        officerPictureModel
                                                                .image_update =
                                                            DateTime.now();

                                                        await OfficerPictureController
                                                                .saveOfficerPicture(
                                                                    officerPictureModel)
                                                            .then((value) => print(
                                                                'saveComplete'));
                                                      }

                                                      showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isDismissible: false,
                                                        enableDrag: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                PopupLoadingWidget(),
                                                          );
                                                        },
                                                      ).then((value) =>
                                                          safeSetState(() {}));

                                                      await OfficerController
                                                              .saveNewOfficer(
                                                                  officerModel)
                                                          .then((value) async {
                                                        OfficerController
                                                            .updatetokenPP(
                                                                officerModel
                                                                    .officer_id!);
                                                        await prefs.setString(
                                                            'officer_name',
                                                            '${selectedPrename!.prename_name!.toString()} ${_model.textController2.text} ${_model.textController3.text}');
                                                        await prefs.setString(
                                                            'officer_login_name',
                                                            _model
                                                                .textController7
                                                                .text);
                                                        await prefs.setString(
                                                            'officer_login_password_md5',
                                                            digest
                                                                .toString()
                                                                .toUpperCase());
                                                        await prefs.setString(
                                                            'officer_id',
                                                            officerModel
                                                                .officer_id!
                                                                .toString());
                                                        await prefs.setString(
                                                            'AutoLogin', 'Y');

                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomeListViewWidget()),
                                                        );
                                                      });
                                                    } else {
                                                      isTextVisible = true;
                                                    }
                                                  }
                                                }
                                              },
                                              text: 'ยืนยัน',
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 56.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 16.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLargeFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily),
                                                        ),
                                                elevation: 0.0,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: smooth_page_indicator
                                          .SmoothPageIndicator(
                                        controller:
                                            _model.pageViewController ??=
                                                PageController(initialPage: 0),
                                        count: 2,
                                        axisDirection: Axis.horizontal,
                                        onDotClicked: (i) async {
                                          await _model.pageViewController!
                                              .animateToPage(
                                            i,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease,
                                          );
                                          safeSetState(() {});
                                        },
                                        effect: smooth_page_indicator
                                            .ExpandingDotsEffect(
                                          expansionFactor: 2.0,
                                          spacing: 8.0,
                                          radius: 24.0,
                                          dotWidth: 8.0,
                                          dotHeight: 8.0,
                                          dotColor: Color(0x2D227A4C),
                                          activeDotColor:
                                              FlutterFlowTheme.of(context)
                                                  .accent1,
                                          paintStyle: PaintingStyle.fill,
                                        ),
                                      ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
