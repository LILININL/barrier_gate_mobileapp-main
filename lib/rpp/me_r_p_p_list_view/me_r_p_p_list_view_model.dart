import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/me/widget/buttonsheet_logout_widget/buttonsheet_logout_widget_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/navbar_r_p_p_widget/navbar_r_p_p_widget_widget.dart';
import 'me_r_p_p_list_view_widget.dart' show MeRPPListViewWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MeRPPListViewModel extends FlutterFlowModel<MeRPPListViewWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header_widget component.
  late HeaderWidgetModel headerWidgetModel;
  // Model for navbar_RPP_widget component.
  late NavbarRPPWidgetModel navbarRPPWidgetModel;

  @override
  void initState(BuildContext context) {
    headerWidgetModel = createModel(context, () => HeaderWidgetModel());
    navbarRPPWidgetModel = createModel(context, () => NavbarRPPWidgetModel());
  }

  @override
  void dispose() {
    headerWidgetModel.dispose();
    navbarRPPWidgetModel.dispose();
  }
}
