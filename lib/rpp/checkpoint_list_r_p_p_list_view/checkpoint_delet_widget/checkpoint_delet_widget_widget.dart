import 'dart:ui';

import 'package:barrier_gate/flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/title_widget/title_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'checkpoint_delet_widget_model.dart';
export 'checkpoint_delet_widget_model.dart';

class CheckpointDeletWidgetWidget extends StatefulWidget {
  const CheckpointDeletWidgetWidget({super.key});

  @override
  State<CheckpointDeletWidgetWidget> createState() =>
      _CheckpointDeletWidgetWidgetState();
}

class _CheckpointDeletWidgetWidgetState
    extends State<CheckpointDeletWidgetWidget> {
  late CheckpointDeletWidgetModel _model;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckpointDeletWidgetModel());
    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          BlurEffect(
            curve: Curves.easeInOut,
            delay: 2000.ms,
            duration: 2000.ms,
            begin: const Offset(0.0, 0.0),
            end: const Offset(4.0, 4.0),
          ),
        ],
      ),
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Align(
            alignment: AlignmentDirectional.center,
            child: Container(
              width: 350.0,
              height: 350.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title Widget
                    wrapWithModel(
                      model: _model.titleWidgetModel,
                      updateCallback: () => setState(() {}),
                      child: TitleWidgetWidget(
                        title: 'ลบข้อมูล',
                      ),
                    ),
                    // Delete Icon with Animation
                    Icon(
                      Icons.delete_outline_rounded,
                      color: FlutterFlowTheme.of(context).accent1,
                      size: 60.0,
                    ).animateOnPageLoad(
                        animationsMap['iconOnPageLoadAnimation']!),
                    // Confirmation Message
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'คุณต้องการลบข้อมูลหรือไม่?\n\n'
                          'หากทำการลบข้อมูลจุดตรวจ \nผลการปฏิบัติงานทั้งหมดจะถูกลบด้วย',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0, // ขนาดตัวอักษรใหญ่ขึ้นเล็กน้อย
                                fontWeight: FontWeight
                                    .w400, // เพิ่มน้ำหนักให้ดูชัดเจนขึ้น
                                // เพิ่ม line height เพื่อให้มีระยะห่างระหว่างบรรทัด
                                letterSpacing: 0.0,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText, // สีตัวอักษร
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .labelMediumFamily),
                              ),
                        ),
                      ),
                    ),

                    // Action Buttons (Cancel & Confirm)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Cancel Button
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            width: 100.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).error,
                              ),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                'ยกเลิก',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      color: FlutterFlowTheme.of(context).error,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // Confirm Button
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            width: 100.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  FlutterFlowTheme.of(context).accent1,
                                  FlutterFlowTheme.of(context).accent1
                                ],
                                stops: const [0.0, 1.0],
                                begin: const AlignmentDirectional(0.56, -1.0),
                                end: const AlignmentDirectional(-0.56, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                'ลบ',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ].divide(const SizedBox(height: 24.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
