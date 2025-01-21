import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home/widget/item_home_widget/item_home_widget_widget.dart';
import '/utils/navbar_widget/navbar_widget_widget.dart';
import 'home_list_view_widget.dart' show HomeListViewWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeListViewModel extends FlutterFlowModel<HomeListViewWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for item_home_widget component.
  late ItemHomeWidgetModel itemHomeWidgetModel1;
  // Model for item_home_widget component.
  late ItemHomeWidgetModel itemHomeWidgetModel2;
  // Model for navbar_widget component.
  late NavbarWidgetModel navbarWidgetModel;

  @override
  void initState(BuildContext context) {
    itemHomeWidgetModel1 = createModel(context, () => ItemHomeWidgetModel());
    itemHomeWidgetModel2 = createModel(context, () => ItemHomeWidgetModel());
    navbarWidgetModel = createModel(context, () => NavbarWidgetModel());
  }

  @override
  void dispose() {
    itemHomeWidgetModel1.dispose();
    itemHomeWidgetModel2.dispose();
    navbarWidgetModel.dispose();
  }
}
