import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/me/widget/edit_profile_widget/edit_profile_widget_widget.dart';
import '/utils/butiinsheet_delet_acout_widget/butiinsheet_delet_acout_widget_widget.dart';
import '/utils/title_widget/title_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'buttonsheet_more_profile_widget_model.dart';
export 'buttonsheet_more_profile_widget_model.dart';

class ButtonsheetMoreProfileWidgetWidget extends StatefulWidget {
  const ButtonsheetMoreProfileWidgetWidget({super.key});

  @override
  State<ButtonsheetMoreProfileWidgetWidget> createState() =>
      _ButtonsheetMoreProfileWidgetWidgetState();
}

class _ButtonsheetMoreProfileWidgetWidgetState
    extends State<ButtonsheetMoreProfileWidgetWidget> {
  late ButtonsheetMoreProfileWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonsheetMoreProfileWidgetModel());

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
                    title: 'เพิ่มเติม',
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    'ทำรายการเพิ่มเติม',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w300,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
                Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Color(0x3F000000),
                      isDismissible: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: EditProfileWidgetWidget(),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48.0,
                    decoration: BoxDecoration(),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'แก้ไข',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyLargeFamily,
                              color: FlutterFlowTheme.of(context).accent1,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).bodyLargeFamily),
                            ),
                      ),
                    ),
                  ),
                ),
                // Divider(
                //   height: 1.0,
                //   thickness: 1.0,
                //   color: FlutterFlowTheme.of(context).alternate,
                // ),
                // InkWell(
                //   splashColor: Colors.transparent,
                //   focusColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   onTap: () async {
                //     Navigator.pop(context);
                //     showModalBottomSheet(
                //       isScrollControlled: true,
                //       backgroundColor: Colors.transparent,
                //       barrierColor: Color(0x3F000000),
                //       isDismissible: false,
                //       context: context,
                //       builder: (context) {
                //         return Padding(
                //           padding: MediaQuery.viewInsetsOf(context),
                //           child: ButiinsheetDeletAcoutWidgetWidget(),
                //         );
                //       },
                //     ).then((value) => safeSetState(() {}));
                //   },
                //   child: Container(
                //     width: double.infinity,
                //     height: 48.0,
                //     decoration: BoxDecoration(),
                //     child: Align(
                //       alignment: AlignmentDirectional(0.0, 0.0),
                //       child: Text(
                //         'ลบบัญชี',
                //         style: FlutterFlowTheme.of(context).bodyLarge.override(
                //               fontFamily:
                //                   FlutterFlowTheme.of(context).bodyLargeFamily,
                //               color: FlutterFlowTheme.of(context).error,
                //               letterSpacing: 0.0,
                //               useGoogleFonts: GoogleFonts.asMap().containsKey(
                //                   FlutterFlowTheme.of(context).bodyLargeFamily),
                //             ),
                //       ),
                //     ),
                //   ),
                // ),
                Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48.0,
                    decoration: BoxDecoration(),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'ยกเลิก',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyLargeFamily,
                              color: FlutterFlowTheme.of(context).error,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).bodyLargeFamily),
                            ),
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
