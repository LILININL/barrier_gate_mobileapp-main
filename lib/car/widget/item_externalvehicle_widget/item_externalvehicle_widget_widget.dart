import 'package:barrier_gate/function_untils/controller/vehicle_visitor_controller.dart';
import 'package:barrier_gate/function_untils/model/04BR_MB_VisitorCarList_model.dart';
import 'package:barrier_gate/function_untils/model/vehicle_visitor_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'item_externalvehicle_widget_model.dart';
export 'item_externalvehicle_widget_model.dart';

class ItemExternalvehicleWidgetWidget extends StatefulWidget {
  const ItemExternalvehicleWidgetWidget({
    super.key,
    String? licenseplate,
    String? detailcar,
    String? datetime,
    required this.isConfirmBtn,
    required this.visitorCarData,
  })  : this.licenseplate = licenseplate ?? 'licenseplate',
        this.detailcar = detailcar ?? 'detailcar',
        this.datetime = datetime ?? 'datetime';

  final String licenseplate;
  final String detailcar;
  final String datetime;
  final bool isConfirmBtn;
  final BrMbvisitorCarListModel04 visitorCarData;

  @override
  State<ItemExternalvehicleWidgetWidget> createState() => _ItemExternalvehicleWidgetWidgetState();
}

class _ItemExternalvehicleWidgetWidgetState extends State<ItemExternalvehicleWidgetWidget> {
  late ItemExternalvehicleWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemExternalvehicleWidgetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xE6FFFFFF),
        image: DecorationImage(
          fit: BoxFit.contain,
          alignment: AlignmentDirectional(1.0, 1.0),
          image: Image.asset(
            'assets/images/car.png',
          ).image,
        ),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryBackground,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent1,
                        shape: BoxShape.circle,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          Icons.directions_car_rounded,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 12.0,
                        ),
                      ),
                    ),
                    Text(
                      widget!.licenseplate,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                          ),
                    ),
                  ].divide(SizedBox(width: 8.0)),
                ),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget!.detailcar,
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    ),
                    Text(
                      widget!.datetime,
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                          ),
                    ),
                  ].divide(SizedBox(height: 4.0)),
                ),
                // if (widget.isConfirmBtn)
                //   FFButtonWidget(
                //     onPressed: () async {
                //       if (widget.visitorCarData?.vehicle_visitor_datetime_in != null) {
                //         if (widget.visitorCarData?.approve_status.toString() != 'Y') {
                //           late VehicleVisitor VehicleVisitorData;
                //           VehicleVisitorData = await VehicleVisitorController.getVehicleVisitorFromID(widget.visitorCarData!.vehicle_visitor_id!);
                //           VehicleVisitorData.approve_status = 'Y';
                //           await VehicleVisitorController.saveVehicleVisitor(VehicleVisitorData).then((value) {});
                //           setState(() {
                //             widget.visitorCarData!.approve_status = 'Y';
                //           });
                //         }
                //       }
                //     },
                //     text: 'ยืนยัน',
                //     options: FFButtonOptions(
                //       width: 100.0,
                //       height: 48.0,
                //       padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                //       iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                //       color: widget.visitorCarData?.approve_status.toString() != 'Y' ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                //       textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                //             fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                //             color: FlutterFlowTheme.of(context).secondaryBackground,
                //             letterSpacing: 0.0,
                //             useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                //           ),
                //       elevation: 0.0,
                //       borderSide: BorderSide(
                //         color: Colors.transparent,
                //         width: 1.0,
                //       ),
                //       borderRadius: BorderRadius.circular(100.0),
                //     ),
                //   ),
              ],
            ),
          ].divide(SizedBox(height: 16.0)),
        ),
      ),
    );
  }
}
