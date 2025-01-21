import 'package:barrier_gate/car/car_external_person/car_external_person_widget.dart';
import 'package:barrier_gate/car/cardetail/cardetail_widget.dart';
import 'package:barrier_gate/car/my_project_list_widget/visitor_car_controller.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:barrier_gate/function_untils/controller/03BR_MB_ResidentCarList_controller.dart';
import 'package:barrier_gate/function_untils/controller/04BR_MB_VisitorCarList_controller.dart';
import 'package:barrier_gate/function_untils/model/02BR_MB_ResidentListVillage_model.dart';
import 'package:barrier_gate/function_untils/model/03BR_MB_ResidentCarList_model.dart';
import 'package:barrier_gate/function_untils/model/04BR_MB_VisitorCarList_model.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '/car/widget/buttonsheet_info_projact_widget/buttonsheet_info_projact_widget_widget.dart';
import '/car/widget/buttonsheet_menu_add_car_widget/buttonsheet_menu_add_car_widget_widget.dart';
import '/car/widget/item_externalvehicle_widget/item_externalvehicle_widget_widget.dart';
import '/car/widget/item_residents_cars_widget/item_residents_cars_widget_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'my_project_list_widget_model.dart';
export 'my_project_list_widget_model.dart';

// import 'package:month_year_picker/month_year_picker.dart';

class MyProjectListWidgetWidget extends StatefulWidget {
  const MyProjectListWidgetWidget({super.key, this.residentDetail});
  final BrMbResidentListVillageModel02? residentDetail;

  @override
  State<MyProjectListWidgetWidget> createState() =>
      _MyProjectListWidgetWidgetState();
}

class _MyProjectListWidgetWidgetState extends State<MyProjectListWidgetWidget>
    with TickerProviderStateMixin {
  late MyProjectListWidgetModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<BrMbResidentCarListModel03> residentCarList = [];
  List<BrMbvisitorCarListModel04> visitCarList = [];

  // DateTime? _selected;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyProjectListWidgetModel());
    doRefreshData();

    doRefreshVisitHistoryData();
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  VisitorCarController dddw = Get.put(VisitorCarController());

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<List<BrMbResidentCarListModel03>> doRefreshData() async {
    if (widget.residentDetail?.villageproject_resident_id == null ||
        widget.residentDetail?.villageproject_detail_id == null) {
      print('residentCarList >> Resident detail is null');
      return [];
    }

    residentCarList =
        await BrMbResidentCarListModel03Controller.getBrMbResidentCarList(
            widget.residentDetail!.villageproject_resident_id.toString(),
            widget.residentDetail!.villageproject_detail_id.toString());
    print('residentCarList >> ${DateTime.now()} ${residentCarList.length}');
    return residentCarList;
  }

  Future<List<BrMbvisitorCarListModel04>> doRefreshVisitData() async {
    if (widget.residentDetail?.villageproject_resident_id == null ||
        widget.residentDetail?.villageproject_detail_id == null) {
      print('visitCarList >> Resident detail is null');
      return [];
    }

    visitCarList =
        await BrMbvisitorCarListModel04Controller.getBrMbvisitorCarListModel04s(
            widget.residentDetail!.villageproject_resident_id.toString(),
            widget.residentDetail!.villageproject_detail_id.toString());
    return visitCarList;
  }

  Future<List<BrMbvisitorCarListModel04>> doRefreshVisitHistoryData() async {
    if (widget.residentDetail?.villageproject_resident_id == null ||
        widget.residentDetail?.villageproject_detail_id == null) {
      print('visitCarHistoryList >> Resident detail is null');
      return [];
    }

    DateTime firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    DateTime lastDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    DateFormat formatter = DateFormat('yyyy.MM.dd');
    String formattedFirstDay = formatter.format(firstDayOfMonth);
    String formattedLastDay = formatter.format(lastDayOfMonth);

    visitCarList = await BrMbvisitorCarListModel04Controller
        .getBrMbvisitorCarHistoryListModel04(
            formattedFirstDay,
            formattedLastDay,
            widget.residentDetail!.villageproject_resident_id,
            widget.residentDetail!.villageproject_detail_id.toString());
    return visitCarList;
  }

  void _incrementDate(bool isIncrement) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + (isIncrement ? 1 : -1),
      );
      // print('_selectedDate : ' + formatThaiMonthShort(_selectedDate));
    });
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
                                header:
                                    'บ้านเลขที่ ${widget.residentDetail?.addrpart?.toString() ?? '-'}',
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
                                Icons.info_rounded,
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
                                      child: ButtonsheetInfoProjactWidgetWidget(
                                          residentDetail:
                                              widget.residentDetail),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                barrierColor: Color(0x3F000000),
                                isDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: ButtonsheetMenuAddCarWidgetWidget(
                                        residentDetail: widget.residentDetail),
                                  );
                                },
                              ).then((value) {
                                setState(() {
                                  // อัปเดตค่าหรือ UI ที่ต้องการหลังจาก bottom sheet ถูกปิด
                                });
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  alignment: AlignmentDirectional(1.0, 1.0),
                                  image: Image.asset(
                                    'assets/images/car2.png',
                                  ).image,
                                ),
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
                                gradient: LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context).accent1,
                                    FlutterFlowTheme.of(context).primary
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(0.56, -1.0),
                                  end: AlignmentDirectional(-0.56, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.add_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  size: 12.0,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    'ลงทะเบียน',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLargeFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'เพิ่มรถยนต์ของฉัน/ผู้มาติดต่อ',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment(0.0, 0),
                                child: TabBar(
                                  labelColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  unselectedLabelColor: Color(0xFF737373),
                                  labelStyle: FlutterFlowTheme.of(context)
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
                                  unselectedLabelStyle:
                                      FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .labelLargeFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .labelLargeFamily),
                                          ),
                                  indicatorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  tabs: [
                                    Tab(
                                      text: 'รถยนต์ภายในบ้าน',
                                    ),
                                    Tab(
                                      text: 'รถยนต์ผู้มาติดต่อ',
                                    ),
                                  ],
                                  controller: _model.tabBarController,
                                  onTap: (i) async {
                                    [() async {}, () async {}][i]();
                                  },
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _model.tabBarController,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          setState(() {});
                                        },
                                        child: ListView(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            Text(
                                              'รถยนต์ของฉัน',
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                            FutureBuilder<
                                                List<
                                                    BrMbResidentCarListModel03>>(
                                              future: doRefreshData(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return (snapshot
                                                              .data!.length !=
                                                          0)
                                                      ? ListView.builder(
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          itemCount: snapshot
                                                              .data?.length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final itemsData =
                                                                snapshot.data![
                                                                    index];

                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                final result =
                                                                    await Navigator
                                                                        .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        CardetailWidget(
                                                                            residentCarData:
                                                                                itemsData),
                                                                  ),
                                                                );
                                                                // ตรวจสอบผลลัพธ์เมื่อหน้าถูกปิดแล้ว
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
                                                                    // อัปเดต UI หรือค่าต่างๆ ที่ต้องการ
                                                                  });
                                                                }
                                                              },
                                                              child:
                                                                  wrapWithModel(
                                                                model: _model
                                                                    .itemResidentsCarsWidgetModel1,
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          8.0),
                                                                  child:
                                                                      ItemResidentsCarsWidgetWidget(
                                                                    licenseplate:
                                                                        'ทะเบียน ${itemsData.license_plate?.isEmpty ?? true ? '-' : itemsData.license_plate}',

                                                                    detailcar: (itemsData.province?.isEmpty ??
                                                                                true
                                                                            ? ' '
                                                                            : itemsData
                                                                                .province!) +
                                                                        (itemsData.carbrandbrand_name?.isEmpty ??
                                                                                true
                                                                            ? ' '
                                                                            : ' ${itemsData.carbrandbrand_name!}') +
                                                                        (itemsData.color?.isEmpty ??
                                                                                true
                                                                            ? '-'
                                                                            : ' สี ${itemsData.color!}'),
                                                                    // detailcar: (itemsData.car_detail?.isEmpty ?? true ? '-' : itemsData.car_detail!) + ' สี' + (itemsData.color?.isEmpty ?? true ? '-' : itemsData.color!),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          })
                                                      : Center(
                                                          child: Text(
                                                              'ไม่มีข้อมูล'));
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          "พบปัญหาการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง ! ${snapshot.error}"));
                                                  // Text("Error: ${snapshot.error}"));
                                                } else {
                                                  return Builder(
                                                      builder: (context) {
                                                    print(
                                                        'residentCarList-----  ${DateTime.now()}');
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  });
                                                }
                                              },
                                            ),
                                          ].divide(SizedBox(height: 16.0)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          setState(() {});
                                        },
                                        child: ListView(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                'เร็วๆนี้',
                                                style:
                                                    FlutterFlowTheme.of(context)
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
                                            FutureBuilder<
                                                List<
                                                    BrMbvisitorCarListModel04>>(
                                              future: doRefreshVisitData(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return (snapshot
                                                              .data!.length !=
                                                          0)
                                                      ? ListView.builder(
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          itemCount: snapshot
                                                              .data?.length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final itemsData =
                                                                snapshot.data![
                                                                    index];

                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                dddw.vehicleVisitorStatusId
                                                                        .value =
                                                                    itemsData
                                                                        .vehicle_visitor_status_id!
                                                                        .toString();

                                                                await Navigator
                                                                    .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        CarExternalPersonWidget(
                                                                            visitorCarData:
                                                                                itemsData),
                                                                  ),
                                                                );
                                                                setState(() {
                                                                  // อัปเดต UI หรือค่าต่างๆ ที่ต้องการ
                                                                });
                                                                // context.pushNamed('car_external_person');
                                                              },
                                                              child:
                                                                  wrapWithModel(
                                                                model: _model
                                                                    .itemExternalvehicleWidgetModel1,
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          8.0),
                                                                  child:
                                                                      ItemExternalvehicleWidgetWidget(
                                                                    licenseplate:
                                                                        itemsData
                                                                            .license_plate,
                                                                    detailcar: (itemsData.province?.isEmpty ??
                                                                                true
                                                                            ? ' '
                                                                            : itemsData
                                                                                .province!) +
                                                                        (itemsData.carbrandbrand_name?.isEmpty ??
                                                                                true
                                                                            ? ' '
                                                                            : ' ${itemsData.carbrandbrand_name!}') +
                                                                        (itemsData.color?.isEmpty ??
                                                                                true
                                                                            ? '-'
                                                                            : ' สี ${itemsData.color!}'),
                                                                    datetime:
                                                                        '${formatThaiDateShort4(itemsData.vehicle_visitor_datetime_in)} - ${formatThaiDateShort4(itemsData.vehicle_visitor_datetime_out)}',
                                                                    isConfirmBtn:
                                                                        true,
                                                                    visitorCarData:
                                                                        itemsData,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          })
                                                      : Center(
                                                          child: Text(
                                                              'ไม่มีข้อมูล'));
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          "พบปัญหาการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง ! ${snapshot.error}"));
                                                  // Text("Error: ${snapshot.error}"));
                                                } else {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              },
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'ประวัติย้อนหลัง',
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
                                                Container(
                                                    child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.arrow_back_ios),
                                                      iconSize: 20,
                                                      onPressed: () {
                                                        _incrementDate(false);
                                                      },
                                                    ),
                                                    Text(
                                                      formatThaiMonthShort(
                                                          _selectedDate),
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
                                                    IconButton(
                                                      icon: Icon(Icons
                                                          .arrow_forward_ios),
                                                      iconSize: 20,
                                                      onPressed: () {
                                                        _incrementDate(true);
                                                      },
                                                    ),
                                                  ],
                                                )),
                                              ],
                                            ),
                                            FutureBuilder<
                                                List<
                                                    BrMbvisitorCarListModel04>>(
                                              future:
                                                  doRefreshVisitHistoryData(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return (snapshot
                                                              .data!.length !=
                                                          0)
                                                      ? ListView.builder(
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          itemCount: snapshot
                                                              .data?.length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final itemsData =
                                                                snapshot.data![
                                                                    index];

                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                final visitorCarController =
                                                                    Get.find<
                                                                        VisitorCarController>();

                                                                visitorCarController
                                                                    .setVehicleVisitorStatusId(
                                                                  itemsData
                                                                      .vehicle_visitor_status_id!
                                                                      .toString(),
                                                                );
                                                                print(
                                                                    'aaaaaaaaaaaaaa${visitorCarController.vehicleVisitorStatusId.value}');
                                                                await Navigator
                                                                    .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        CarExternalPersonWidget(
                                                                            visitorCarData:
                                                                                itemsData),
                                                                  ),
                                                                );

                                                                // บันทึกค่า vehicle_visitor_status_id

                                                                setState(() {
                                                                  // อัปเดต UI หรือค่าต่างๆ ที่ต้องการ
                                                                });
                                                                // context.pushNamed('car_external_person');
                                                              },
                                                              child:
                                                                  wrapWithModel(
                                                                model: _model
                                                                    .itemExternalvehicleWidgetModel1,
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          8.0),
                                                                  child:
                                                                      ItemExternalvehicleWidgetWidget(
                                                                    visitorCarData:
                                                                        itemsData,
                                                                    licenseplate:
                                                                        itemsData
                                                                            .license_plate,
                                                                    detailcar: (itemsData.province?.isEmpty ??
                                                                                true
                                                                            ? ' '
                                                                            : itemsData
                                                                                .province!) +
                                                                        (itemsData.carbrandbrand_name?.isEmpty ??
                                                                                true
                                                                            ? ' '
                                                                            : ' ${itemsData.carbrandbrand_name!}') +
                                                                        (itemsData.color?.isEmpty ??
                                                                                true
                                                                            ? '-'
                                                                            : ' สี ${itemsData.color!}'),
                                                                    datetime:
                                                                        '${formatThaiDateShort4(itemsData.vehicle_visitor_datetime_in)} - ${formatThaiDateShort4(itemsData.vehicle_visitor_datetime_out)}',
                                                                    isConfirmBtn:
                                                                        false,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          })
                                                      : Center(
                                                          child: Text(
                                                              'ไม่มีข้อมูล'));
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          "พบปัญหาการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง ! ${snapshot.error}"));
                                                  // Text("Error: ${snapshot.error}"));
                                                } else {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              },
                                            ),
                                          ].divide(SizedBox(height: 0.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                          .divide(SizedBox(height: 8.0))
                          .addToStart(SizedBox(height: 8.0)),
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
