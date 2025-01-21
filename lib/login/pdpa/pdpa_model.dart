import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'pdpa_widget.dart' show PdpaWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PdpaModel extends FlutterFlowModel<PdpaWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header_widget component.
  late HeaderWidgetModel headerWidgetModel;

  @override
  void initState(BuildContext context) {
    headerWidgetModel = createModel(context, () => HeaderWidgetModel());
  }

  @override
  void dispose() {
    headerWidgetModel.dispose();
  }
}
