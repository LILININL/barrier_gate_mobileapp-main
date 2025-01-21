import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'popup_sucess_conect_staff_model.dart';
export 'popup_sucess_conect_staff_model.dart';

class PopupSucessConectStaffWidget extends StatefulWidget {
  const PopupSucessConectStaffWidget({super.key});

  @override
  State<PopupSucessConectStaffWidget> createState() =>
      _PopupSucessConectStaffWidgetState();
}

class _PopupSucessConectStaffWidgetState
    extends State<PopupSucessConectStaffWidget> {
  late PopupSucessConectStaffModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupSucessConectStaffModel());

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
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: 300.0,
          height: 300.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Lottie.asset(
                  'assets/jsons/success.json',
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.contain,
                  frameRate: FrameRate(24.0),
                  repeat: false,
                  animate: true,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'ลงทะเบียนเข้าโครงการสำเร็จ',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .titleMediumFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .titleMediumFamily),
                            ),
                      ),
                    ),
                  ].divide(SizedBox(height: 8.0)),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
