import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/title_widget/title_widget_widget.dart';
import 'buttonsheet_forgot_password_widget_widget.dart'
    show ButtonsheetForgotPasswordWidgetWidget;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ButtonsheetForgotPasswordWidgetModel
    extends FlutterFlowModel<ButtonsheetForgotPasswordWidgetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for title_widget component.
  late TitleWidgetModel titleWidgetModel1;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // Model for title_widget component.
  late TitleWidgetModel titleWidgetModel2;
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 300000;
  int timerMilliseconds = 300000;
  String timerValue = StopWatchTimer.getDisplayTime(
    300000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  // Model for title_widget component.
  late TitleWidgetModel titleWidgetModel3;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {
    titleWidgetModel1 = createModel(context, () => TitleWidgetModel());
    titleWidgetModel2 = createModel(context, () => TitleWidgetModel());
    pinCodeController = TextEditingController();
    titleWidgetModel3 = createModel(context, () => TitleWidgetModel());
    passwordVisibility1 = false;
    passwordVisibility2 = false;
  }

  @override
  void dispose() {
    titleWidgetModel1.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    titleWidgetModel2.dispose();
    pinCodeController?.dispose();
    timerController.dispose();
    titleWidgetModel3.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
