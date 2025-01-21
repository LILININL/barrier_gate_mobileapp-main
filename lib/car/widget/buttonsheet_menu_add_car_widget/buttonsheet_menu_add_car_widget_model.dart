import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/title_widget/title_widget_widget.dart';
import 'buttonsheet_menu_add_car_widget_widget.dart'
    show ButtonsheetMenuAddCarWidgetWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ButtonsheetMenuAddCarWidgetModel
    extends FlutterFlowModel<ButtonsheetMenuAddCarWidgetWidget> {
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
