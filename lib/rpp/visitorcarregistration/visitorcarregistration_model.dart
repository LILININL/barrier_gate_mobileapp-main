import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rpp/item_home_in_project/item_home_in_project_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'visitorcarregistration_widget.dart' show VisitorcarregistrationWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VisitorcarregistrationModel
    extends FlutterFlowModel<VisitorcarregistrationWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header_widget component.
  late HeaderWidgetModel headerWidgetModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for item_home_in_project component.
  late ItemHomeInProjectModel itemHomeInProjectModel1;
  // Model for item_home_in_project component.
  late ItemHomeInProjectModel itemHomeInProjectModel2;
  // Model for item_home_in_project component.
  late ItemHomeInProjectModel itemHomeInProjectModel3;
  // Model for item_home_in_project component.
  late ItemHomeInProjectModel itemHomeInProjectModel4;

  @override
  void initState(BuildContext context) {
    headerWidgetModel = createModel(context, () => HeaderWidgetModel());
    itemHomeInProjectModel1 =
        createModel(context, () => ItemHomeInProjectModel());
    itemHomeInProjectModel2 =
        createModel(context, () => ItemHomeInProjectModel());
    itemHomeInProjectModel3 =
        createModel(context, () => ItemHomeInProjectModel());
    itemHomeInProjectModel4 =
        createModel(context, () => ItemHomeInProjectModel());
  }

  @override
  void dispose() {
    headerWidgetModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    itemHomeInProjectModel1.dispose();
    itemHomeInProjectModel2.dispose();
    itemHomeInProjectModel3.dispose();
    itemHomeInProjectModel4.dispose();
  }
}
