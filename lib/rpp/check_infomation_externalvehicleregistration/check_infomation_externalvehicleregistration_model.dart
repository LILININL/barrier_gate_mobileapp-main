import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rpp/image_car_licenseplate/image_car_licenseplate_widget.dart';
import '/rpp/image_id_card/image_id_card_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/popup_sucess/popup_sucess_widget.dart';
import 'check_infomation_externalvehicleregistration_widget.dart'
    show CheckInfomationExternalvehicleregistrationWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CheckInfomationExternalvehicleregistrationModel
    extends FlutterFlowModel<CheckInfomationExternalvehicleregistrationWidget> {
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
