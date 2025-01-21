import '/car/widget/buttonsheet_info_projact_widget/buttonsheet_info_projact_widget_widget.dart';
import '/car/widget/buttonsheet_menu_add_car_widget/buttonsheet_menu_add_car_widget_widget.dart';
import '/car/widget/item_externalvehicle_widget/item_externalvehicle_widget_widget.dart';
import '/car/widget/item_residents_cars_widget/item_residents_cars_widget_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'my_project_list_widget_widget.dart' show MyProjectListWidgetWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyProjectListWidgetModel
    extends FlutterFlowModel<MyProjectListWidgetWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header_widget component.
  late HeaderWidgetModel headerWidgetModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for item_residents_cars_widget component.
  late ItemResidentsCarsWidgetModel itemResidentsCarsWidgetModel1;
  // Model for item_residents_cars_widget component.
  late ItemResidentsCarsWidgetModel itemResidentsCarsWidgetModel2;
  // Model for item_residents_cars_widget component.
  late ItemResidentsCarsWidgetModel itemResidentsCarsWidgetModel3;
  // Model for item_externalvehicle_widget component.
  late ItemExternalvehicleWidgetModel itemExternalvehicleWidgetModel1;
  DateTime? datePicked;
  // Model for item_externalvehicle_widget component.
  late ItemExternalvehicleWidgetModel itemExternalvehicleWidgetModel2;

  @override
  void initState(BuildContext context) {
    headerWidgetModel = createModel(context, () => HeaderWidgetModel());
    itemResidentsCarsWidgetModel1 =
        createModel(context, () => ItemResidentsCarsWidgetModel());
    itemResidentsCarsWidgetModel2 =
        createModel(context, () => ItemResidentsCarsWidgetModel());
    itemResidentsCarsWidgetModel3 =
        createModel(context, () => ItemResidentsCarsWidgetModel());
    itemExternalvehicleWidgetModel1 =
        createModel(context, () => ItemExternalvehicleWidgetModel());
    itemExternalvehicleWidgetModel2 =
        createModel(context, () => ItemExternalvehicleWidgetModel());
  }

  @override
  void dispose() {
    headerWidgetModel.dispose();
    tabBarController?.dispose();
    itemResidentsCarsWidgetModel1.dispose();
    itemResidentsCarsWidgetModel2.dispose();
    itemResidentsCarsWidgetModel3.dispose();
    itemExternalvehicleWidgetModel1.dispose();
    itemExternalvehicleWidgetModel2.dispose();
  }
}
