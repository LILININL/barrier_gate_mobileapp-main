import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/navbar_r_p_p_widget/navbar_r_p_p_widget_widget.dart';
import 'home_r_p_p_widget.dart' show HomeRPPWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeRPPModel extends FlutterFlowModel<HomeRPPWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for navbar_RPP_widget component.
  late NavbarRPPWidgetModel navbarRPPWidgetModel;

  @override
  void initState(BuildContext context) {
    navbarRPPWidgetModel = createModel(context, () => NavbarRPPWidgetModel());
  }

  @override
  void dispose() {
    navbarRPPWidgetModel.dispose();
  }
}
