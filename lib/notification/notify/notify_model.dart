import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/navbar_widget/navbar_widget_widget.dart';
import 'notify_widget.dart' show NotifyWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotifyModel extends FlutterFlowModel<NotifyWidget> {
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
