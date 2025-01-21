import 'package:barrier_gate/function_untils/model/02BR_MB_ResidentListVillage_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/title_widget/title_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'buttonsheet_info_projact_widget_model.dart';
export 'buttonsheet_info_projact_widget_model.dart';

class ButtonsheetInfoProjactWidgetWidget extends StatefulWidget {
  ButtonsheetInfoProjactWidgetWidget({super.key, this.residentDetail});
  final BrMbResidentListVillageModel02? residentDetail;
  @override
  State<ButtonsheetInfoProjactWidgetWidget> createState() => _ButtonsheetInfoProjactWidgetWidgetState();
}

class _ButtonsheetInfoProjactWidgetWidgetState extends State<ButtonsheetInfoProjactWidgetWidget> {
  late ButtonsheetInfoProjactWidgetModel _model;
  SharedPreferences? prefs;
  String? officer_id;
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonsheetInfoProjactWidgetModel());
    doRefresh();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  doRefresh() async {
    prefs = await SharedPreferences.getInstance();

    officer_id = prefs!.getString('officer_id');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                wrapWithModel(
                  model: _model.titleWidgetModel,
                  updateCallback: () => safeSetState(() {}),
                  child: TitleWidgetWidget(
                    title: 'ข้อมูลโครงการ',
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    'ข้อมูลรายละเอียดโครงการและที่อยู่',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w300,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
                ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0x0C00613A),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          alignment: AlignmentDirectional(1.0, 1.0),
                          image: Image.asset(
                            'assets/images/project.png',
                          ).image,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.cottage_outlined,
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      size: 12.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        'โครงการ',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                            Text(
                              widget.residentDetail!.villageproject_display_name!.toString(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                  ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0x0C00613A),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          alignment: AlignmentDirectional(1.0, 1.0),
                          image: Image.asset(
                            'assets/images/user_icon.png',
                          ).image,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.person,
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      size: 12.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        'ID ลูกบ้าน',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                            Text(
                              officer_id.toString().padLeft(12, '0'),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                  ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0x0C00613A),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          alignment: AlignmentDirectional(1.0, 1.0),
                          image: Image.asset(
                            'assets/images/home.png',
                          ).image,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.add_home_outlined,
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      size: 12.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        'บ้านเลขที่',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                            Text(
                              widget.residentDetail!.addr_soi.toString(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                  ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0x0C00613A),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          alignment: AlignmentDirectional(1.0, 1.0),
                          image: Image.asset(
                            'assets/images/pin.png',
                          ).image,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.pin_drop_outlined,
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      size: 12.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        'ที่ตั้ง',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                            Text(
                              'ซอย ' + (widget.residentDetail!.addr_soi?.isEmpty ?? true ? '-' : widget.residentDetail!.addr_soi!) + ' ' + widget.residentDetail!.chwpart! + ' ' + widget.residentDetail!.amppart! + ' ' + widget.residentDetail!.tmbpart!,
                              // 'ซอย สุขสวัสดิ์ 33 แขวงราษฎร์บูรณะ เขตราษฎร์บูรณะ กรุงเทพมหานคร 10140',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                  ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 16.0)),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
