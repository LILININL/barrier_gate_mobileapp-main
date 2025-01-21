import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rpp/item_checkpoin/item_checkpoin_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'checkpoint_list_r_p_p_list_view_widget.dart'
    show CheckpointListRPPListViewWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CheckpointListRPPListViewModel
    extends FlutterFlowModel<CheckpointListRPPListViewWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header_widget component.
  late HeaderWidgetModel headerWidgetModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  DateTime? datePicked;
  // Model for item_checkpoin component.
  late ItemCheckpoinModel itemCheckpoinModel1;
  // Model for item_checkpoin component.
  late ItemCheckpoinModel itemCheckpoinModel2;
  // Model for item_checkpoin component.
  late ItemCheckpoinModel itemCheckpoinModel3;
  // Model for item_checkpoin component.
  late ItemCheckpoinModel itemCheckpoinModel4;

  @override
  void initState(BuildContext context) {
    headerWidgetModel = createModel(context, () => HeaderWidgetModel());
    itemCheckpoinModel1 = createModel(context, () => ItemCheckpoinModel());
    itemCheckpoinModel2 = createModel(context, () => ItemCheckpoinModel());
    itemCheckpoinModel3 = createModel(context, () => ItemCheckpoinModel());
    itemCheckpoinModel4 = createModel(context, () => ItemCheckpoinModel());
  }

  @override
  void dispose() {
    headerWidgetModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    itemCheckpoinModel1.dispose();
    itemCheckpoinModel2.dispose();
    itemCheckpoinModel3.dispose();
    itemCheckpoinModel4.dispose();
  }
}
