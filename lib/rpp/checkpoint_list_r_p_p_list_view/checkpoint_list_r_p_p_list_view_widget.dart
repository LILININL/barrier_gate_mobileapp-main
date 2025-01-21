import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/rpp/checkpoint_list_r_p_p_list_view/controller/rpp_controller.dart';
import 'package:barrier_gate/rpp/checkpoint_list_r_p_p_list_view/controller/rpp_model.dart';
import 'package:get/get.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rpp/item_checkpoin/item_checkpoin_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'checkpoint_list_r_p_p_list_view_model.dart';
export 'checkpoint_list_r_p_p_list_view_model.dart';

class CheckpointListRPPListViewWidget extends StatefulWidget {
  const CheckpointListRPPListViewWidget({super.key});

  @override
  State<CheckpointListRPPListViewWidget> createState() =>
      _CheckpointListRPPListViewWidgetState();
}

class _CheckpointListRPPListViewWidgetState
    extends State<CheckpointListRPPListViewWidget> {
  late CheckpointListRPPListViewModel _model;
  String? inspectionId;

  String _searchQuery = "";
  DateTime? _selectedDate;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  RppDetailController rppDetailController = Get.put(RppDetailController());

  @override
  void initState() {
    super.initState();
    clearInspectionId();
    _selectedDate = DateTime.now();
    _model = createModel(context, () => CheckpointListRPPListViewModel());
    // rppDetailController.fetchRppDetails();
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.datePicked = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> clearInspectionId() async {
    await SharedPreferencesControllerCenter().remove('inspection_id');
    print('Inspection ID cleared.');
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
                                        header: 'รายการจุดตรวจ',
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
                                            setState(() {
                                              _searchQuery =
                                                  value.toLowerCase();
                                            });
                                          },
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
                                            hintText: 'ค้นหา......',
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
                                      FlutterFlowIconButton(
                                        borderRadius: 100.0,
                                        buttonSize: 48.0,
                                        fillColor: Color(0x4D00613A),
                                        icon: Icon(
                                          Icons.calendar_month,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 20.0,
                                        ),
                                        onPressed: () async {
                                          final pickedDate =
                                              await showModalBottomSheet<
                                                  DateTime>(
                                            context: context,

                                            isDismissible: true,
                                            backgroundColor: Colors
                                                .transparent, // พื้นหลังโปร่งใส
                                            builder: (context) {
                                              DateTime tempPickedDate =
                                                  DateTime.now();

                                              // ค่าเริ่มต้น
                                              return Stack(
                                                children: [
                                                  // พื้นที่นอก Modal
                                                  GestureDetector(
                                                    onTap: () {
                                                      // เมื่อกดนอกจอ ให้ปิด Modal พร้อมส่งค่าที่เลือก
                                                      Navigator.of(context)
                                                          .pop(tempPickedDate);
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  // CupertinoDatePicker
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          // Picker
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                3,
                                                            child:
                                                                CupertinoDatePicker(
                                                              mode:
                                                                  CupertinoDatePickerMode
                                                                      .date,
                                                              minimumDate:
                                                                  DateTime(
                                                                      1900),
                                                              initialDateTime:
                                                                  tempPickedDate,
                                                              maximumDate:
                                                                  DateTime
                                                                      .now(),
                                                              onDateTimeChanged:
                                                                  (newDateTime) {
                                                                tempPickedDate =
                                                                    newDateTime; // อัปเดตค่า
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (pickedDate != null) {
                                            setState(() {
                                              _selectedDate =
                                                  pickedDate; // บันทึกวันที่ที่เลือก
                                            });
                                          }
                                        },
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                                Expanded(
                                  child: FutureBuilder<List<RppDetail>>(
                                    future: rppDetailController.fetchRppDetails(
                                      selectedDate:
                                          _selectedDate ?? DateTime.now(),
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                              'เกิดข้อผิดพลาด: ${snapshot.error}'),
                                        );
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                            child: Text('ไม่พบข้อมูล'));
                                      }

                                      final filteredDetails = snapshot.data!
                                          .where((detail) =>
                                              detail.location_name
                                                  ?.toLowerCase()
                                                  .contains(_searchQuery) ??
                                              false)
                                          .toList();

                                      filteredDetails.sort((a, b) {
                                        final dateA =
                                            a.inspection_date ?? DateTime.now();
                                        final dateB =
                                            b.inspection_date ?? DateTime.now();
                                        return dateB.compareTo(dateA); // DESC
                                      });

                                      if (filteredDetails.isEmpty) {
                                        return Center(
                                            child: Text(
                                                'ไม่พบผลลัพธ์ที่ตรงกับคำค้นหา'));
                                      }

                                      return ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        itemCount: filteredDetails.length,
                                        itemBuilder: (context, index) {
                                          final detail = filteredDetails[index];

                                          return InkWell(
                                            onTap: () async {
                                              await SharedPreferencesControllerCenter()
                                                  .setString(
                                                'inspection_id',
                                                detail.inspection_id.toString(),
                                              );

                                              context.pushNamed(
                                                'add_checkpion_list_view',
                                                extra: <String, dynamic>{
                                                  'isEditMode': true,
                                                  kTransitionInfoKey:
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType.fade,
                                                  ),
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: ItemCheckpoinWidget(
                                                checkpoinname:
                                                    detail.location_name ??
                                                        'ไม่ระบุจุดตรวจ',
                                                date: formatVisitorDatenotTime(
                                                        detail
                                                            .inspection_date!) ??
                                                    'ไม่ระบุวันที่',
                                                time: formatVisitorDateonlyTime(
                                                        detail
                                                            .inspection_date!) ??
                                                    'ไม่ระบุเวลา',
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ].divide(SizedBox(height: 16.0)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(1.0, 1.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16.0,
                          color: Color(0x33000000),
                          offset: Offset(
                            0.0,
                            0.0,
                          ),
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(1.0, 1.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 100.0,
                        buttonSize: 56.0,
                        fillColor: FlutterFlowTheme.of(context).primary,
                        icon: Icon(
                          Icons.qr_code_scanner_rounded,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.pushNamed('scan_QR_code_checkpion');
                        },
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

String formatVisitorDateadnTime(DateTime? dateTime, {String prefix = ''}) {
  if (dateTime == null) return '$prefix -';
  final formattedDateTime = dateTimeFormat(
      "d MMMM y HH:mm",
      DateTime(dateTime.year + 543, dateTime.month, dateTime.day, dateTime.hour,
          dateTime.minute, dateTime.second));
  return '$prefix$formattedDateTime';
}

String formatVisitorDatenotTime(DateTime? dateTime, {String prefix = ''}) {
  if (dateTime == null) return '$prefix -';

  // เพิ่ม 543 ปี
  DateTime buddhistDate =
      DateTime(dateTime.year + 543, dateTime.month, dateTime.day);

  // ฟอร์แมตวันที่เป็นภาษาไทย
  final formattedDateTime =
      DateFormat('d MMMM y', 'th_TH').format(buddhistDate);

  return '$prefix$formattedDateTime';
}

String formatVisitorDateonlyTime(DateTime? dateTime, {String prefix = ''}) {
  if (dateTime == null) return '$prefix -';

  // ฟอร์แมตเวลาเท่านั้น
  final formattedDateTime = DateFormat('HH:mm', 'th_TH').format(dateTime);

  return '$prefix$formattedDateTime';
}

DateTime? convertToBuddhistYear(DateTime? date) {
  if (date == null) return null;
  return DateTime(date.year + 543, date.month, date.day, date.hour, date.minute,
      date.second);
}
