import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/title_widget/title_widget_widget.dart';
import 'buttonsheet_info_projact_widget_widget.dart'
    show ButtonsheetInfoProjactWidgetWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ButtonsheetInfoProjactWidgetModel
    extends FlutterFlowModel<ButtonsheetInfoProjactWidgetWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for title_widget component.
  late TitleWidgetModel titleWidgetModel;

  @override
  void initState(BuildContext context) {
    titleWidgetModel = createModel(context, () => TitleWidgetModel());
  }

  @override
  void dispose() {
    titleWidgetModel.dispose();
  }
}
