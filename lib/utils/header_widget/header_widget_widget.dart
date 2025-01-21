import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'header_widget_model.dart';
export 'header_widget_model.dart';

class HeaderWidgetWidget extends StatefulWidget {
  const HeaderWidgetWidget({
    super.key,
    this.header,
  });

  final String? header;

  @override
  State<HeaderWidgetWidget> createState() => _HeaderWidgetWidgetState();
}

class _HeaderWidgetWidgetState extends State<HeaderWidgetWidget> {
  late HeaderWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HeaderWidgetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
      height: 48.0,
      decoration: BoxDecoration(),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Text(
          valueOrDefault<String>(
            widget!.header,
            'header',
          ),
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                color: Color(0xFF0B3706),
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
                useGoogleFonts: GoogleFonts.asMap().containsKey(
                    FlutterFlowTheme.of(context).titleMediumFamily),
              ),
        ),
      ),
    );
  }
}
