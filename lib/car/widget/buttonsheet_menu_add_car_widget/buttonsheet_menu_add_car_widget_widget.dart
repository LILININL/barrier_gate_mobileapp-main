import 'package:barrier_gate/car/register_car_list_view/register_car_list_view_widget.dart';
import 'package:barrier_gate/car/register_external_person_view/register_external_person_view_widget.dart';
import 'package:barrier_gate/function_untils/model/02BR_MB_ResidentListVillage_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/title_widget/title_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'buttonsheet_menu_add_car_widget_model.dart';
export 'buttonsheet_menu_add_car_widget_model.dart';

class ButtonsheetMenuAddCarWidgetWidget extends StatefulWidget {
  const ButtonsheetMenuAddCarWidgetWidget({super.key, this.residentDetail});
  final BrMbResidentListVillageModel02? residentDetail;

  @override
  State<ButtonsheetMenuAddCarWidgetWidget> createState() => _ButtonsheetMenuAddCarWidgetWidgetState();
}

class _ButtonsheetMenuAddCarWidgetWidgetState extends State<ButtonsheetMenuAddCarWidgetWidget> {
  late ButtonsheetMenuAddCarWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonsheetMenuAddCarWidgetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

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
                    title: 'ลงทะเบียนรถ',
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    'กรุณาเลือกเพื่อทำรายการ',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w300,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterCarListViewWidget(
                                residentDetail: widget.residentDetail,
                              )),
                    );
                    // context.pushNamed('register_car_list_view');
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
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).accent1,
                          FlutterFlowTheme.of(context).primary
                        ],
                        stops: [
                          0.0,
                          1.0
                        ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24.0,
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x3BFFFFFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Icon(
                                        Icons.add_rounded,
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
                                          'เพิ่มรถยนต์ของฉัน',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: FlutterFlowTheme.of(context).primaryBackground,
                                size: 24.0,
                              ),
                            ],
                          ),
                          Text(
                            'เพิ่มรถยนต์ที่อยู่ในบ้านของคุณ',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                ),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterExternalPersonViewWidget(
                                residentDetail: widget.residentDetail,
                              )),
                    );
                    // context.pushNamed('register_external_person_view');
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
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFEB8031),
                          FlutterFlowTheme.of(context).secondary
                        ],
                        stops: [
                          0.0,
                          1.0
                        ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24.0,
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x3BFFFFFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Icon(
                                        Icons.add_rounded,
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
                                          'ลงทะเบียนรถยนต์ผู้มาติดต่อ',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: FlutterFlowTheme.of(context).primaryBackground,
                                size: 24.0,
                              ),
                            ],
                          ),
                          Text(
                            'เพิ่มรถยนต์บุคคลภายนอกที่เข้ามาติดต่อ',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                ),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
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
