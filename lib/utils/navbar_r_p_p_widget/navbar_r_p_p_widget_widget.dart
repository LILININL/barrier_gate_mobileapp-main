import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navbar_r_p_p_widget_model.dart';
export 'navbar_r_p_p_widget_model.dart';

class NavbarRPPWidgetWidget extends StatefulWidget {
  const NavbarRPPWidgetWidget({
    super.key,
    required this.slectpage,
    bool? hide,
  }) : this.hide = hide ?? false;

  final int? slectpage;
  final bool hide;

  @override
  State<NavbarRPPWidgetWidget> createState() => _NavbarRPPWidgetWidgetState();
}

class _NavbarRPPWidgetWidgetState extends State<NavbarRPPWidgetWidget> {
  late NavbarRPPWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavbarRPPWidgetModel());

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x00FFFFFF), Color(0xE6FFFFFF)],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(0.0, -1.0),
          end: AlignmentDirectional(0, 1.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: 80.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 16.0,
                color: Color(0x26000000),
                offset: Offset(
                  0.0,
                  0.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 100.0,
                      buttonSize: 48.0,
                      fillColor: widget!.slectpage == 1
                          ? Color(0x2000613A)
                          : Color(0x00000000),
                      icon: Icon(
                        Icons.home_filled,
                        color: widget!.slectpage == 1
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pushNamed(
                          'home_RPP',
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                              duration: Duration(milliseconds: 0),
                            ),
                          },
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 100.0,
                      buttonSize: 48.0,
                      fillColor: widget!.slectpage == 3
                          ? Color(0x2000613A)
                          : Color(0x00000000),
                      icon: Icon(
                        Icons.person_2_rounded,
                        color: widget!.slectpage == 3
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pushNamed(
                          'me_list_view',
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                              duration: Duration(milliseconds: 0),
                            ),
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
