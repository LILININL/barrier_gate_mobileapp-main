import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/me/widget/buttonsheet_logout_widget/buttonsheet_logout_widget_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/navbar_widget/navbar_widget_widget.dart';
import 'me_list_view_widget.dart' show MeListViewWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MeListViewModel extends FlutterFlowModel<MeListViewWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header_widget component.
  late HeaderWidgetModel headerWidgetModel;
  // Model for navbar_widget component.
  late NavbarWidgetModel navbarWidgetModel;

  @override
  void initState(BuildContext context) {
    headerWidgetModel = createModel(context, () => HeaderWidgetModel());
    navbarWidgetModel = createModel(context, () => NavbarWidgetModel());
  }

  @override
  void dispose() {
    headerWidgetModel.dispose();
    navbarWidgetModel.dispose();
  }
}
