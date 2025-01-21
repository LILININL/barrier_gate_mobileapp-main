import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'title_widget_model.dart';
export 'title_widget_model.dart';

class TitleWidgetWidget extends StatefulWidget {
  const TitleWidgetWidget({
    super.key,
    this.header,
    this.title,
  });

  final String? header;
  final String? title;

  @override
  State<TitleWidgetWidget> createState() => _TitleWidgetWidgetState();
}

class _TitleWidgetWidgetState extends State<TitleWidgetWidget> {
  late TitleWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TitleWidgetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(),
        ),
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Text(
            valueOrDefault<String>(
              widget!.title,
              'title',
            ),
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).titleMediumFamily),
                ),
          ),
        ),
        FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 100.0,
          buttonSize: 32.0,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          icon: Icon(
            Icons.close_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 16.0,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
